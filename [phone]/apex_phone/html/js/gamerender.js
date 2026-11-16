/* ============================================================
   GAMERENDER - põe a vista do jogo (FiveM) dentro de um <canvas> WebGL
   Sem dependências, sem vídeo. Serve o visor da Câmara e a chamada de vídeo.

   ── COMO A IMAGEM DO JOGO ENTRA AQUI ─────────────────────────
   Não existe nativo nem export que vá buscar o frame do jogo. O que existe é
   uma BATIDA SECRETA no estado da textura, que o CEF do FiveM vigia:

       gl.texParameterf(TEXTURE_2D, TEXTURE_WRAP_T, CLAMP_TO_EDGE);
       gl.texParameterf(TEXTURE_2D, TEXTURE_WRAP_T, MIRRORED_REPEAT);
       gl.texParameterf(TEXTURE_2D, TEXTURE_WRAP_T, REPEAT);

   Três `texParameterf` seguidos sobre TEXTURE_WRAP_T, com esses valores e por
   essa ordem, marcam a textura ligada como "vista do jogo". A partir daí o CEF
   troca-lhe o conteúdo pelo backbuffer antes de pintar a página NUI.

   Fonte: @citizenfx/three (o fork que o screenshot-basic usa),
   src/renderers/webgl/WebGLTextures.js, ramo `if (texture.isCfxTexture)` - e o
   lb-phone faz exatamente a mesma sequência à mão. O `console.log('f?')` que
   aparece nos logs do FiveM sai desse ramo: é o sinal de que a troca foi pedida.

   ⚠️ Tem de ser texParameter**f** (a variante float). Com `texParameteri` não
      acontece nada e o visor fica VERMELHO (o pixel de espera) para sempre.
   ⚠️ O nome do sampler (`external_texture`) NÃO é o gatilho - é só convenção,
      copiada do lb-phone. O gatilho é a sequência acima.

   Num browser normal a troca nunca acontece e este código desenha um retângulo
   vermelho: é para isso que serve `isPlaceholder()`, e é por isso que
   `available()` dá false fora do FiveM.

   ── A CURA DAS "FOTOS PRETAS" ────────────────────────────────
   O jogo e o CEF correm a cadências diferentes: há frames em que a textura
   externa ainda não foi produzida (loading, troca de câmara, frames saltados)
   e chega PRETA. Num visor isso é um piscar; numa foto é uma foto preta.
   A cura é um anel de 4 texturas com os frames anteriores e um fallback POR
   PIXEL dentro do fragment shader:

       if (color.rgb != vec3(0.0, 0.0, 0.0)) { usa o frame do jogo }
       else { procura, do mais recente para o mais antigo, um frame não-preto }

   Notas que importam:
     · em GLSL ES, `!=` entre vec3 dá um bool escalar (true se QUALQUER
       componente diferir) - logo o teste é "este pixel não é preto puro";
     · o teste é por pixel, não por frame. Um preto genuíno do jogo (céu
       nocturno, carro preto) também cai no fallback, mas o frame anterior tem
       quase de certeza o mesmo preto nesse sítio: sem artefacto visível;
     · o programa de cópia (que arquiva o frame no anel) NÃO tem fallback de
       propósito - se copiasse o fallback, um frame preto propagava a imagem
       velha para sempre e o anel deixava de detetar frames em falta.

   ── A FOTO É O PRÓPRIO CANVAS ────────────────────────────────
   `toDataURL()`/`toBlob()` leem o canvas: o que se vê é exatamente o que sai.
   Isto só funciona por causa de `preserveDrawingBuffer: true` (ver adiante).
   Antes de capturar, quem chama deve pedir ao Lua para esconder o HUD do GTA
   (e esperar uns frames) - este módulo não fala com o Lua de propósito.

   ── ZOOM DIGITAL E DIAGONAL (setZoom / setRoll) ──────────────
   A CellCam do GTA não tem zoom por botão nem roll: os dois são feitos AQUI, nas UVs.
   O vertex shader do programa principal aplica uma transformação AFIM às coordenadas de
   textura (u_uv_mat · uv + u_uv_off): rodar e encolher o recorte à volta do CENTRO DO
   VISOR (não do frame - na selfie o visor está deslocado pelo xOffset). Como é afim, a
   interpolação entre os 4 vértices dá o resultado exato por pixel, sem custo no fragment.
   O programa de cópia (o anel) fica com a IDENTIDADE: o anel guarda sempre o frame tal
   como chega, para as UVs do fallback baterem certo com as da textura externa.
   O roll leva um recorte extra (`cover`) calculado com a folga REAL do frame à volta do
   visor: no retrato o frame 16:9 sobra dos lados e quase não é preciso ampliar; no PANO
   (visor = frame) reduz-se ao clássico |cos|+|sin| de um quadrado. Nunca aparecem cantos.
   Tudo isto fica na foto, porque a foto é o canvas.
   ============================================================ */
window.GameRender = (() => {
  'use strict';

  /* ------------------------------------------------------------------
     CONSTANTES
     ------------------------------------------------------------------ */

  const PREV_FRAME_COUNT = 4;   // profundidade do anel de frames anteriores
  const ATTRIB_POSITION  = 0;
  const ATTRIB_TEXCOORD  = 1;

  /* preserveDrawingBuffer é OBRIGATÓRIO: sem ele o browser pode limpar o
     drawing buffer logo a seguir ao compositing, e `toDataURL()`/`toBlob()`
     saem VAZIOS (pretos) mesmo com o visor a mostrar imagem. É a única razão
     pela qual se pode fotografar sem voltar a desenhar de propósito. */
  /* ⚠️ SEM `desynchronized: true` (o lb-phone tem-no). Um canvas low-latency pode saltar o
     compositor no Chromium e anular precisamente a preservação do drawing buffer - é o par de
     opções que produz o sintoma "o visor mostra imagem, a foto sai preta", que é exatamente o
     problema que este motor veio resolver. A latência extra é irrelevante num visor de câmara. */
  const CONTEXT_OPTIONS = {
    antialias: false,
    depth: false,
    alpha: false,
    stencil: false,
    preserveDrawingBuffer: true,
    powerPreference: 'high-performance'
  };

  /* Quad em TRIANGLE_STRIP, já em clip space: cobre sempre o viewport inteiro. */
  const QUAD_POSITIONS = new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]);

  /* UV com (0,0) em baixo-à-esquerda - a textura do jogo também chega com a
     origem em baixo, por isso NÃO se inverte o Y aqui. */
  const QUAD_TEXCOORDS = new Float32Array([0, 0, 1, 0, 0, 1, 1, 1]);

  /* O marcador que o CEF do FiveM procura para substituir esta textura. */
  const MAGIC_PIXEL = new Uint8Array([255, 0, 0, 255]);

  const DEFAULT_MIME    = 'image/webp';   // se o CEF não souber, cai em image/png
  const DEFAULT_QUALITY = 0.92;

  /* ------------------------------------------------------------------
     SHADERS
     ------------------------------------------------------------------ */

  /* u_uv_mat/u_uv_off: zoom digital + roll (ver cabeçalho). Um uniform por programa: o principal
     leva a transformação, o de cópia leva a identidade (uniforms nascem a ZERO em GLSL - sem a
     identidade explícita o anel arquivava um frame todo da mesma cor). */
  const VERTEX_SHADER = `
attribute vec2 a_position;
attribute vec2 a_texcoord;

uniform mat2 u_uv_mat;
uniform vec2 u_uv_off;

varying vec2 texture_coords;

void main() {
    gl_Position = vec4(a_position, 0.0, 1.0);

    texture_coords = u_uv_mat * a_texcoord + u_uv_off;
}
`;

  /* O 4 do array de samplers tem de ser um literal (em GLSL ES 1.0 um array de
     samplers só pode ser indexado por expressão constante - e o índice de um
     `for` com limites literais conta como tal). Injeta-se a constante para o
     shader e o anel nunca poderem divergir. */
  const FRAGMENT_SHADER_MAIN = `
precision mediump float;

varying highp vec2 texture_coords;

uniform sampler2D external_texture;
uniform sampler2D u_prev_frame_texture[${PREV_FRAME_COUNT}];

void main()
{
    vec4 color = texture2D(external_texture, texture_coords);

    if (color.rgb != vec3(0.0, 0.0, 0.0)) {
        gl_FragColor = color;

        return;
    }

    // O original deixava gl_FragColor por escrever quando TODO o anel estava
    // preto (arranque a frio) - em GLSL ES isso é valor indefinido. Escreve-se
    // preto opaco à cabeça para o pior caso ser determinístico.
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);

    for (int i = 0; i < ${PREV_FRAME_COUNT}; i++) {
        vec4 prev_color = texture2D(u_prev_frame_texture[i], texture_coords);

        if (prev_color.rgb != vec3(0.0, 0.0, 0.0)) {
            gl_FragColor = prev_color;

            break;
        }
    }
}
`;

  const FRAGMENT_SHADER_COPY = `
precision mediump float;

varying highp vec2 texture_coords;

uniform sampler2D external_texture;

void main()
{
    gl_FragColor = texture2D(external_texture, texture_coords);
}
`;

  /* ------------------------------------------------------------------
     AUXILIARES
     ------------------------------------------------------------------ */

  function compileShader(gl, type, source) {
    const shader = gl.createShader(type);
    if (!shader) throw new Error('shader não criado');

    gl.shaderSource(shader, source);
    gl.compileShader(shader);

    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      const log = gl.getShaderInfoLog(shader) || 'erro de compilação desconhecido';
      gl.deleteShader(shader);
      throw new Error(log);
    }
    return shader;
  }

  function createProgram(gl, fragmentSource) {
    const vs = compileShader(gl, gl.VERTEX_SHADER, VERTEX_SHADER);
    const fs = compileShader(gl, gl.FRAGMENT_SHADER, fragmentSource);
    const program = gl.createProgram();
    if (!program) throw new Error('programa não criado');

    gl.attachShader(program, vs);
    gl.attachShader(program, fs);

    // Locations FIXAS nos dois programas: assim os vertexAttribPointer são
    // configurados uma única vez e servem tanto o programa principal como o
    // de cópia (em WebGL1, sem VAO, o estado dos atributos é global).
    gl.bindAttribLocation(program, ATTRIB_POSITION, 'a_position');
    gl.bindAttribLocation(program, ATTRIB_TEXCOORD, 'a_texcoord');

    gl.linkProgram(program);
    gl.deleteShader(vs);
    gl.deleteShader(fs);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      const log = gl.getProgramInfoLog(program) || 'erro de link desconhecido';
      gl.deleteProgram(program);
      throw new Error(log);
    }
    return program;
  }

  /* Pré-calcula, para cada posição da cabeça do anel, o mapeamento
     slot-do-array → unidade de textura.
     O PORQUÊ: o anel roda a cada frame. Rodar 4 inteiros num uniform é muito
     mais barato do que reordenar texturas - e garante que
     u_prev_frame_texture[0] é SEMPRE o frame mais recente (N-1) e o [3] o mais
     antigo (N-4, o que vai ser reciclado neste frame). O +1 existe porque a
     unidade 0 está reservada para a textura do jogo. */
  function buildTextureUnitOrders(count) {
    const orders = [];
    for (let head = 0; head < count; head++) {
      const order = new Int32Array(count);
      for (let slot = 0; slot < count; slot++) {
        order[slot] = (head + count - 1 - slot) % count + 1;
      }
      orders.push(order);
    }
    return orders;
  }

  function createTextures(gl) {
    const mainTexture = gl.createTexture();
    if (!mainTexture) throw new Error('textura principal não criada');

    gl.bindTexture(gl.TEXTURE_2D, mainTexture);

    // Ponto de partida: 1×1 vermelho. Enquanto se vir VERMELHO no visor é porque a vista do jogo
    // ainda não substituiu esta textura.
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, MAGIC_PIXEL);

    // ⚠️⚠️ A BATIDA SECRETA - é ISTO que faz o CEF do FiveM trocar o conteúdo desta textura pela
    // vista do jogo. Não é o nome do sampler nem o pixel mágico: é uma SEQUÊNCIA de três
    // `texParameterf` sobre TEXTURE_WRAP_T com CLAMP_TO_EDGE → MIRRORED_REPEAT → REPEAT.
    // Fonte: @citizenfx/three (o fork que o screenshot-basic usa), em
    // src/renderers/webgl/WebGLTextures.js, ramo `if (texture.isCfxTexture)` - e o lb-phone faz
    // exatamente a mesma sequência à mão. O `console.log('f?')` que aparece nos logs do FiveM
    // vem desse ramo: é o sinal de que a troca foi pedida.
    // ⚠️ TEM de ser texParameter**f** (a variante float). Com texParameteri não acontece nada e o
    //    visor fica VERMELHO para sempre - foi exatamente esse o sintoma.
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);   // repõe o modo normal

    const prevTextures = [];
    for (let i = 0; i < PREV_FRAME_COUNT; i++) {
      const tex = gl.createTexture();
      if (!tex) continue;

      gl.bindTexture(gl.TEXTURE_2D, tex);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
      // O tamanho real é dado por _allocHistory(); aqui basta existir.
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
      prevTextures.push(tex);
    }

    gl.bindTexture(gl.TEXTURE_2D, mainTexture);
    return { mainTexture, prevTextures };
  }

  function createBuffers(gl, prevTextures) {
    const vertexBuffer   = gl.createBuffer();
    const texcoordBuffer = gl.createBuffer();
    if (!vertexBuffer || !texcoordBuffer) throw new Error('buffers não criados');

    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, QUAD_POSITIONS, gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, QUAD_TEXCOORDS, gl.STATIC_DRAW);

    // Um FBO por textura do anel, para lá copiar o frame atual.
    const prevBuffers = [];
    for (let i = 0; i < prevTextures.length; i++) {
      const fbo = gl.createFramebuffer();
      if (!fbo) continue;
      gl.bindFramebuffer(gl.FRAMEBUFFER, fbo);
      gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, prevTextures[i], 0);
      prevBuffers.push(fbo);
    }
    gl.bindFramebuffer(gl.FRAMEBUFFER, null);

    return { vertexBuffer, texcoordBuffer, prevBuffers };
  }

  const MAX_ZOOM = 8;    // além disto são meia dúzia de pixéis esticados
  const MAX_ROLL = 45;   // graus; mais do que isto já é uma foto ao contrário, não uma diagonal

  /* Quanto é preciso ampliar um recorte w×h rodado de `deg` graus à volta do seu centro para a
     rotação não deixar cantos vazios, quando à volta dele só há `roomX`/`roomY` de imagem (metade
     da largura/altura disponível a partir do centro). Sem folga (roomX = w/2, roomY = h/2) e num
     quadrado dá o clássico |cos|+|sin|. É a mesma conta para o canvas WebGL e para a cena falsa
     do browser - por isso é pública (GameRender.coverScale). */
  function coverScale(w, h, deg, roomX, roomY) {
    const t = (Number(deg) || 0) * Math.PI / 180;
    const c = Math.abs(Math.cos(t)), s = Math.abs(Math.sin(t));
    w = Math.max(1, w || 1); h = Math.max(1, h || 1);
    roomX = roomX > 0 ? roomX : w / 2;
    roomY = roomY > 0 ? roomY : h / 2;
    const needX = (w * c + h * s) / 2, needY = (w * s + h * c) / 2;
    /* PAISAGEM (±90°, telemóvel deitado): o lado comprido do visor passa a apanhar a LARGURA do frame, que sobra -
       sem o chão de 1 o recorte abre (k < 1) e vê-se o campo de visão inteiro, como numa foto ao baixo a sério.
       Na diagonal (≤ 45°) o chão fica: o enquadramento de sempre não muda. */
    const floor = Math.abs(Number(deg) || 0) > 46 ? 0 : 1;
    return Math.max(floor, needX / roomX, needY / roomY);
  }

  /* Converte um data URL em Blob - só é usado se o CEF não tiver toBlob(). */
  function dataURLToBlob(url) {
    try {
      if (!url) return null;
      const comma = url.indexOf(',');
      const head  = url.slice(0, comma);
      const mime  = (head.match(/:(.*?);/) || [])[1] || 'image/png';
      const bin   = atob(url.slice(comma + 1));
      const bytes = new Uint8Array(bin.length);
      for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
      return new Blob([bytes], { type: mime });
    } catch (e) { return null; }
  }

  /* ------------------------------------------------------------------
     DISPONIBILIDADE
     ------------------------------------------------------------------ */

  let availableCache = null;   // os contextos WebGL são recurso escasso: testa-se 1×

  /* Só há vista do jogo dentro do CEF do FiveM. Não existe nenhuma extensão
     WebGL "external texture" para testar (a substituição é do lado do CEF), por
     isso o que se pode verificar honestamente é: (a) estamos na NUI do FiveM,
     (b) há contexto WebGL1, (c) existe WEBGL_lose_context - a única extensão
     que este módulo usa mesmo (em destroy()). */
  function available() {
    if (availableCache !== null) return availableCache;
    availableCache = false;
    try {
      if (typeof window === 'undefined' || typeof document === 'undefined') return false;
      if (typeof window.WebGLRenderingContext === 'undefined') return false;
      if (typeof window.GetParentResourceName !== 'function') return false;   // fora do jogo

      const probe = document.createElement('canvas');
      probe.width = 1;
      probe.height = 1;
      const gl = probe.getContext('webgl', CONTEXT_OPTIONS);
      if (!gl) return false;

      const lose = gl.getExtension('WEBGL_lose_context');
      availableCache = !!lose;
      if (lose) lose.loseContext();   // liberta já o contexto de teste
    } catch (e) {
      availableCache = false;
    }
    return availableCache;
  }

  /* ------------------------------------------------------------------
     OBJETO INERTE (browser, harness, WebGL em falta)
     Mesma forma da instância real e absolutamente seguro: nada rebenta e
     `isBlack()` diz sempre "preto" para nunca se guardar uma foto vazia.
     É uma FÁBRICA e não um singleton: cada visor tem de poder marcar-se como
     destruído sem afetar os outros.
     ------------------------------------------------------------------ */

  function createInert() {
    return {
      live: false,
      destroyed: false,
      quality: 1,
      zoom: 1,
      roll: 0,
      viewport: { x: 0, y: 0, width: 0, height: 0 },
      canvasSize: { width: 0, height: 0 },
      resize() {},
      resizeByAspect() {},
      setQuality() {},
      setMaxFps() {},
      setXOffset() {},
      setYOffset() {},
      setZoom(z) { this.zoom = Math.min(MAX_ZOOM, Math.max(1, Number(z) || 1)); },       /* guarda o valor: a cena falsa do browser lê-o */
      setRoll(d) { this.roll = Math.min(MAX_ROLL, Math.max(-MAX_ROLL, Number(d) || 0)); },
      setLandscape(d) { this.land = d === 90 || d === -90 ? d : 0; },
      land: 0,
      renderOnce() {},
      pause() {},
      resume() {},
      isBlack() { return true; },
      isBlankRows() { return true; },
      isPlaceholder() { return false; },
      toDataURL() { return null; },
      toBlob() { return Promise.resolve(null); },
      destroy() { this.destroyed = true; }
    };
  }

  /* ------------------------------------------------------------------
     O RENDERER
     ------------------------------------------------------------------ */

  class Renderer {
    constructor(canvas, gl) {
      this.live      = true;
      this.canvas    = canvas;
      this.gl        = gl;
      this.destroyed = false;
      this.paused    = false;

      this.quality = 1;      // multiplicador de resolução (1 = nativa)
      this.xOffset = 0;      // -0.5 = encosta à direita · 0 = centrado · +0.5 = à esquerda
      this.yOffset = 0;
      this.zoom    = 1;      // zoom DIGITAL (recorte central das UVs), >= 1
      this.roll    = 0;      // diagonal em graus, -45…45 (positivo = sentido dos ponteiros, como o rotate() do CSS)
      this.land    = 0;      // PAISAGEM: 0 | ±90 - o telemóvel está deitado (CSS rotate no .device) e o frame roda ao contrário para ficar direito
      this.aspect  = null;   // último rácio pedido, para reagir ao resize da janela

      this.viewport   = { x: 0, y: 0, width: 0, height: 0 };  // já em pixéis de quality
      this.canvasSize = { width: 0, height: 0 };              // recorte pedido, ANTES de quality

      this.mainProgram = createProgram(gl, FRAGMENT_SHADER_MAIN);
      this.copyProgram = createProgram(gl, FRAGMENT_SHADER_COPY);

      const textures    = createTextures(gl);
      this.mainTexture  = textures.mainTexture;
      this.prevTextures = textures.prevTextures;
      this.prevTextureUnits      = this.prevTextures.map((_, i) => gl.TEXTURE1 + i);
      this.prevTextureUnitOrders = buildTextureUnitOrders(this.prevTextures.length);
      this.nextPrevTexture       = 0;
      this.prevTextureWidth      = 0;
      this.prevTextureHeight     = 0;

      const buffers       = createBuffers(gl, this.prevTextures);
      this.vertexBuffer   = buffers.vertexBuffer;
      this.texcoordBuffer = buffers.texcoordBuffer;
      this.prevBuffers    = buffers.prevBuffers;

      // A vista do jogo está SEMPRE na unidade 0, nos dois programas.
      gl.useProgram(this.mainProgram);
      gl.uniform1i(gl.getUniformLocation(this.mainProgram, 'external_texture'), 0);
      this.prevTextureUniformLocation =
        gl.getUniformLocation(this.mainProgram, 'u_prev_frame_texture[0]');
      if (this.prevTextureUniformLocation && this.prevTextureUnitOrders[0]) {
        gl.uniform1iv(this.prevTextureUniformLocation, this.prevTextureUnitOrders[0]);
      }
      this.uvMatLocation = gl.getUniformLocation(this.mainProgram, 'u_uv_mat');
      this.uvOffLocation = gl.getUniformLocation(this.mainProgram, 'u_uv_off');
      // identidade até o primeiro resize() calcular o enquadramento (uniforms nascem a zero)
      if (this.uvMatLocation) gl.uniformMatrix2fv(this.uvMatLocation, false, [1, 0, 0, 1]);
      if (this.uvOffLocation) gl.uniform2f(this.uvOffLocation, 0, 0);

      gl.useProgram(this.copyProgram);
      gl.uniform1i(gl.getUniformLocation(this.copyProgram, 'external_texture'), 0);
      // o anel arquiva o frame SEM zoom/roll: identidade fixa, para sempre
      const copyMat = gl.getUniformLocation(this.copyProgram, 'u_uv_mat');
      const copyOff = gl.getUniformLocation(this.copyProgram, 'u_uv_off');
      if (copyMat) gl.uniformMatrix2fv(copyMat, false, [1, 0, 0, 1]);
      if (copyOff) gl.uniform2f(copyOff, 0, 0);

      // Atributos configurados de uma vez (locations fixas nos dois programas).
      gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
      gl.vertexAttribPointer(ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0);
      gl.enableVertexAttribArray(ATTRIB_POSITION);

      gl.bindBuffer(gl.ARRAY_BUFFER, this.texcoordBuffer);
      gl.vertexAttribPointer(ATTRIB_TEXCOORD, 2, gl.FLOAT, false, 0, 0);
      gl.enableVertexAttribArray(ATTRIB_TEXCOORD);

      this._loop = this._loop.bind(this);
      this._onWindowResize = this._onWindowResize.bind(this);
      this.animationFrame = 0;
      this._resizePending = 0;
      this.minFrameMs = 0;    // 0 = desenha a cada requestAnimationFrame; ver setMaxFps()
      this._nextDrawAt = 0;   // hora do próximo desenho com teto (fase fixa, ver _loop)
      this._keepRing = false; // setQuality(q, { keepHistory }) a decorrer: o resize não re-aloca o anel
    }

    /* -------- enquadramento -------- */

    /* O modelo mental: a CANVAS é o recorte (o visor do telemóvel) e o VIEWPORT
       é o frame do jogo desenhado lá dentro. Como o frame do jogo tem sempre o
       aspeto da JANELA, o viewport é maior do que a canvas e a sua origem é
       NEGATIVA: o frame transborda dos dois lados e a canvas vê a fatia central.
       Ou seja, o ENQUADRAMENTO é feito pelo viewport; as UVs só entram para o zoom
       digital e o roll (_updateUV), que giram à volta do centro desse recorte. */
    resize(width, height) {
      const gl = this.gl;
      if (!gl || this.destroyed) return;
      if (!(width > 0) || !(height > 0)) return;

      const winW = Math.max(1, window.innerWidth  || 1);
      const winH = Math.max(1, window.innerHeight || 1);
      const q    = this.quality;

      this.canvasSize = { width: width, height: height };

      // "contain": escala que faz o recorte pedido caber dentro da janela.
      const fit = Math.min(winW / width, winH / height);

      // Metade da folga, sempre <= 0: centra o frame do jogo no recorte.
      const baseX = ((width  * fit) - winW) / 2 * q;
      const baseY = ((height * fit) - winH) / 2 * q;

      const canvasW = Math.max(1, Math.round(width  * q));
      const canvasH = Math.max(1, Math.round(height * q));
      // Mexer em canvas.width re-aloca (e limpa) o drawing buffer - só quando muda.
      if (gl.canvas.width  !== canvasW) gl.canvas.width  = canvasW;
      if (gl.canvas.height !== canvasH) gl.canvas.height = canvasH;

      const vpW = Math.max(1, Math.round(winW * q));
      const vpH = Math.max(1, Math.round(winH * q));

      // Deslizar dentro da folga: x = base * (1 - 2*offset). O tamanho da janela
      // cancela-se por completo nesta conta (o original lia-o à toa).
      this.viewport = {
        x: Math.round(baseX * (1 - 2 * this.xOffset)) | 0,   // o |0 mata o -0
        y: Math.round(baseY * (1 - 2 * this.yOffset)) | 0,
        width: vpW,
        height: vpH
      };
      gl.viewport(this.viewport.x, this.viewport.y, vpW, vpH);

      this._updateUV();   // o centro do visor dentro do frame mudou: o zoom/roll giram à volta dele
      /* setQuality(q, { keepHistory: true }) (4 nov 2026, o Live Photo da videochamada): o anel fica com o tamanho que tinha.
         O shader lê-o por UV, por isso um anel mais pequeno serve um desenho maior; re-alocar zerava-o e o disparo ficava
         sem rede contra o frame preto - era exatamente o caso para que o anel existe. */
      if (!this._keepRing) this._allocHistory(vpW, vpH);
    }

    /* Recalcula u_uv_mat/u_uv_off do programa principal a partir de zoom, roll e enquadramento.
       Em pixéis do frame: p = uv·(vpW,vpH); d = p − centro do visor; a fonte de d é
       centro + R(θ)·d / k, com k = zoom · cover. Escrito como afim em uv, o vertex shader faz o
       resto. Só uniforms: não toca no canvas nem no anel, por isso pode correr por frame (slider). */
    _updateUV() {
      const gl = this.gl;
      if (!gl || this.destroyed || !this.uvMatLocation) return;
      const vp = this.viewport;
      const vpW = Math.max(1, vp.width), vpH = Math.max(1, vp.height);
      const W = Math.max(1, gl.canvas.width), H = Math.max(1, gl.canvas.height);
      // centro do visor em pixéis do frame (vp.x/vp.y são <= 0: o frame transborda do canvas)
      const cx = W / 2 - vp.x, cy = H / 2 - vp.y;
      const roomX = Math.max(1, Math.min(cx, vpW - cx)), roomY = Math.max(1, Math.min(cy, vpH - cy));
      const deg = this.roll + this.land;
      const k = this.zoom * coverScale(W, H, deg, roomX, roomY);
      const t = deg * Math.PI / 180;
      // sentido dos ponteiros NO ECRÃ = R(+θ) nas coordenadas do GL (y para cima)
      const c = Math.cos(t) / k, s = Math.sin(t) / k;
      // mat2 em GLSL é por COLUNAS: mat * uv = (m0·u + m2·v, m1·u + m3·v)
      const m0 = c, m2 = -s * vpH / vpW, m1 = s * vpW / vpH, m3 = c;
      const ox = (cx - (c * cx - s * cy)) / vpW, oy = (cy - (s * cx + c * cy)) / vpH;
      gl.useProgram(this.mainProgram);
      gl.uniformMatrix2fv(this.uvMatLocation, false, [m0, m1, m2, m3]);
      if (this.uvOffLocation) gl.uniform2f(this.uvOffLocation, ox, oy);
    }

    /* Zoom digital: recorte central do frame, z >= 1 (1 = o que o jogo dá). O scroll do jogo (zoom
       da CellCam) é outra coisa e continua a funcionar por cima disto. Fica gravado na foto. */
    setZoom(z) {
      z = Math.min(MAX_ZOOM, Math.max(1, Number(z) || 1));
      if (z === this.zoom) return;
      this.zoom = z;
      this._updateUV();
    }

    /* Diagonal: roda o frame à volta do centro do visor, com recorte extra para nunca haver
       cantos vazios (ver coverScale). Fica gravado na foto. */
    setRoll(deg) {
      deg = Math.min(MAX_ROLL, Math.max(-MAX_ROLL, Number(deg) || 0));
      if (deg === this.roll) return;
      this.roll = deg;
      this._updateUV();
    }

    /* Paisagem: 0 ou ±90. Soma-se à diagonal nas UVs (o frame roda ao contrário do aparelho, para o jogo ficar
       direito no ecrã deitado) e o recorte abre até ao campo de visão inteiro (coverScale sem chão). */
    setLandscape(deg) {
      deg = deg === 90 || deg === -90 ? deg : 0;
      if (deg === this.land) return;
      this.land = deg;
      this._updateUV();
    }

    /* aspect = largura / altura (ex.: 3/4 no modo retrato, 16/9 em paisagem). */
    resizeByAspect(aspect) {
      if (!(aspect > 0)) return;
      this.aspect = aspect;

      const winW = Math.max(1, window.innerWidth  || 1);
      const winH = Math.max(1, window.innerHeight || 1);

      let w = winH * aspect;   // largura se ocupar toda a ALTURA da janela
      let h = winW / aspect;   // altura  se ocupar toda a LARGURA da janela

      if (w > winW) w = winW;  // limitado pela largura
      else          h = winH;  // limitado pela altura

      this.resize(w, h);
    }

    /* Não muda o enquadramento, só a resolução a que tudo é desenhado.
       Uso típico: em 4K, setQuality(1920 / window.innerWidth) → renderiza a
       metade sem perder enquadramento nem tamanho útil da foto. */
    setQuality(q, opts) {
      if (!(q > 0)) return;
      q = Math.min(4, Math.max(0.1, q));
      if (q === this.quality) return;   // evitar limpar o anel à toa (ver abaixo)
      this.quality = q;
      this._keepRing = !!(opts && opts.keepHistory && this.prevTextureWidth);
      try { this.resize(this.canvasSize.width || 1, this.canvasSize.height || 1); } finally { this._keepRing = false; }
    }

    /* Teto de desenhos por segundo do ciclo (4 nov 2026). O PiP da videochamada é uma janela de ~120 px: redesenhá-lo a
       cada frame do CEF (60+ por segundo, cada um com a cópia do frame inteiro para o anel) é GPU gasta sem se ver.
       0 = sem teto (a app Câmara). O renderOnce() nunca é limitado: o disparo quer sempre um frame fresco. */
    setMaxFps(fps) {
      fps = Number(fps) || 0;
      this.minFrameMs = fps > 0 ? 1000 / Math.min(240, Math.max(1, fps)) : 0;
      this._nextDrawAt = 0;
    }

    /* Nota de compatibilidade: o lb-phone guarda o SINAL INVERTIDO
       (setXOffset(-0.2) na selfie ⇒ desliza para revelar mais da esquerda).
       Aqui o valor é usado tal e qual: +0.5 revela a margem esquerda do frame,
       -0.5 a direita, 0 fica centrado. Fora de [-0.5, +0.5] aparecem barras. */
    setXOffset(v) {
      v = Math.min(0.5, Math.max(-0.5, Number(v) || 0));
      if (v === this.xOffset) return;
      this.xOffset = v;
      this.resize(this.canvasSize.width || 1, this.canvasSize.height || 1);
    }

    /* No lb-phone o yOffset é letra morta (o render passa 0 em vez de
       viewport.y). Aqui funciona - mas só se nota no ramo "limitado pela
       largura" (recorte mais largo do que a janela), onde baseY < 0. */
    setYOffset(v) {
      v = Math.min(0.5, Math.max(-0.5, Number(v) || 0));
      if (v === this.yOffset) return;
      this.yOffset = v;
      this.resize(this.canvasSize.width || 1, this.canvasSize.height || 1);
    }

    /* O anel guarda o frame INTEIRO (aspeto da janela), à resolução de render.
       Só re-aloca quando o tamanho muda: re-alocar limpa o histórico e, durante
       ~4 frames, o visor fica sem rede contra o preto. Por isso é que chamar
       setQuality() por frame (num slider) mata o anti-flicker. */
    _allocHistory(width, height) {
      const gl = this.gl;
      if (!gl) return;
      if (this.prevTextureWidth === width && this.prevTextureHeight === height) return;

      this.prevTextureWidth  = width;
      this.prevTextureHeight = height;
      this.nextPrevTexture   = 0;

      for (let i = 0; i < this.prevTextures.length; i++) {
        gl.activeTexture(this.prevTextureUnits[i]);
        gl.bindTexture(gl.TEXTURE_2D, this.prevTextures[i]);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
      }

      gl.activeTexture(gl.TEXTURE0);
      gl.bindTexture(gl.TEXTURE_2D, this.mainTexture);
    }

    _onWindowResize() {
      // Debounce por rAF: um resize dispara em rajada e cada um re-aloca 4 texturas.
      if (this._resizePending || this.destroyed) return;
      this._resizePending = requestAnimationFrame(() => {
        this._resizePending = 0;
        if (this.destroyed) return;
        if (this.aspect) this.resizeByAspect(this.aspect);
        else if (this.canvasSize.width) this.resize(this.canvasSize.width, this.canvasSize.height);
      });
    }

    /* -------- ciclo de desenho -------- */

    _loop(ts) {
      this.animationFrame = 0;
      if (this.destroyed || this.paused) return;
      /* com teto (setMaxFps) salta os frames do rAF que chegam antes da HORA MARCADA. A hora avança um intervalo de cada vez
         (fase fixa), não "intervalo desde o último desenho": com esse, um rAF a 35-58 Hz desenhava um sim, um não e o PiP
         ficava a 17-29 por segundo em vez de 30. Folga de 2 ms contra arredondamentos; atraso grande ou relógio para trás
         recomeça a contagem. */
      const now = typeof ts === 'number' ? ts : performance.now();
      const step = this.minFrameMs;
      if (!step) { this._draw(); }
      else if (!this._nextDrawAt || now >= this._nextDrawAt - 2 || now + 4 * step < this._nextDrawAt) {
        this._nextDrawAt = (this._nextDrawAt && now - this._nextDrawAt < step && now + 4 * step >= this._nextDrawAt) ? this._nextDrawAt + step : now + step;
        this._draw();
      }
      this.animationFrame = requestAnimationFrame(this._loop);
    }

    /* noArchive (12 nov): desenha só o PASSO 1, sem guardar o frame no anel. É o renderOnce({ archive: false }) da verificação
       de preto do vídeo: um frame repetido no anel encurtava a rede contra o preto do ciclo. */
    _draw(noArchive) {
      const gl = this.gl;
      if (!gl || this.destroyed || gl.isContextLost()) return;

      const count = Math.min(
        this.prevTextures.length,
        this.prevBuffers.length,
        this.prevTextureUnits.length,
        this.prevTextureUnitOrders.length
      );

      /* PASSO 1 - desenhar para o ecrã, com o fallback do anel. */
      gl.useProgram(this.mainProgram);
      if (count && this.prevTextureUniformLocation) {
        // Roda só o mapeamento slot→unidade: o frame N-1 fica no slot 0.
        gl.uniform1iv(this.prevTextureUniformLocation, this.prevTextureUnitOrders[this.nextPrevTexture]);
      }
      gl.viewport(this.viewport.x, this.viewport.y, this.viewport.width, this.viewport.height);
      gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

      /* PASSO 2 - arquivar o frame do jogo (inteiro, sem recorte nem offset,
         para os UVs baterem certo com os da textura externa). */
      if (count && noArchive !== true) {
        const head = this.nextPrevTexture;

        // Não se pode ler e escrever a mesma textura: desliga-se da unidade.
        gl.activeTexture(this.prevTextureUnits[head]);
        gl.bindTexture(gl.TEXTURE_2D, null);

        gl.useProgram(this.copyProgram);
        gl.viewport(0, 0, this.prevTextureWidth, this.prevTextureHeight);
        gl.bindFramebuffer(gl.FRAMEBUFFER, this.prevBuffers[head]);
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
        gl.bindFramebuffer(gl.FRAMEBUFFER, null);

        gl.bindTexture(gl.TEXTURE_2D, this.prevTextures[head]);   // religar na unidade
        gl.activeTexture(gl.TEXTURE0);

        this.nextPrevTexture = (head + 1) % count;
      }

      gl.flush();
    }

    /* Um frame avulso, mesmo em pausa - útil para garantir imagem fresca
       imediatamente antes de fotografar. */
    renderOnce(opts) {
      if (this.destroyed) return;
      this._draw(!!(opts && opts.archive === false));
    }

    pause() {
      this.paused = true;
      if (this.animationFrame) {
        cancelAnimationFrame(this.animationFrame);
        this.animationFrame = 0;
      }
    }

    resume() {
      if (this.destroyed || !this.paused) return;
      this.paused = false;
      this._nextDrawAt = 0;
      if (!this.animationFrame) this.animationFrame = requestAnimationFrame(this._loop);
    }

    _start() {
      if (this.destroyed || this.paused || this.animationFrame) return;
      this.animationFrame = requestAnimationFrame(this._loop);
    }

    /* -------- captura -------- */

    /* Lê alguns pixéis do canvas e diz se o frame está preto. Serve para nunca
       se guardar uma foto vazia (jogo ainda a carregar, câmara a trocar, anel
       ainda por encher). Não é um teste de exposição: um cenário nocturno
       genuinamente escuro pode dar true - daí o limiar ser regulável. */
    /* O visor está a mostrar o PIXEL DE ESPERA (vermelho puro)?
       Quer dizer que o CEF ainda não trocou a textura pela vista do jogo. Sem este teste
       guardava-se um retângulo vermelho na galeria como se fosse uma fotografia - foi
       exatamente o que aconteceu quando faltava a "batida secreta" do createTextures(). */
    isPlaceholder() {
      const gl = this.gl;
      if (!gl || this.destroyed || gl.isContextLost()) return false;
      const w = gl.drawingBufferWidth, h = gl.drawingBufferHeight;
      if (!w || !h) return false;
      const px = new Uint8Array(4);
      const grid = [0.2, 0.5, 0.8];
      try {
        for (let i = 0; i < grid.length; i++) {
          for (let j = 0; j < grid.length; j++) {
            gl.readPixels(Math.min(w - 1, Math.floor(w * grid[i])), Math.min(h - 1, Math.floor(h * grid[j])),
              1, 1, gl.RGBA, gl.UNSIGNED_BYTE, px);
            if (!(px[0] > 235 && px[1] < 24 && px[2] < 24)) return false;   /* basta UM ponto que não seja vermelho puro */
          }
        }
      } catch (e) { return false; }
      return true;
    }

    isBlack(threshold) {
      const gl = this.gl;
      if (!gl || this.destroyed || gl.isContextLost()) return true;

      const t = typeof threshold === 'number' ? threshold : 6;
      const w = gl.drawingBufferWidth;
      const h = gl.drawingBufferHeight;
      if (!w || !h) return true;

      const px = new Uint8Array(4);
      const grid = [0.25, 0.5, 0.75];   // 9 pontos espalhados (a origem em baixo é irrelevante)

      try {
        for (let i = 0; i < grid.length; i++) {
          for (let j = 0; j < grid.length; j++) {
            const x = Math.min(w - 1, Math.floor(w * grid[i]));
            const y = Math.min(h - 1, Math.floor(h * grid[j]));
            gl.readPixels(x, y, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, px);
            if (px[0] > t || px[1] > t || px[2] > t) return false;
          }
        }
      } catch (e) {
        return true;   // na dúvida, trata como preto (não guarda)
      }
      return true;
    }

    /* (ronda 2) Preto A SÉRIO, para o VÍDEO: nenhum pixel aceso em 3 linhas INTEIRAS (25 %, 50 % e 80 % da altura), limiar 3.
       Os 9 pontos do isBlack() dão falsos positivos numa cena de noite (é a lição do apex_adminmenu 2.2.20: máximo 15 numa
       noite ainda é imagem) e no vídeo isso congelava a imagem aos bocados. Erro de leitura = "não está preto": na dúvida o
       vídeo continua a gravar em vez de parar de pintar. */
    isBlankRows(threshold) {
      const gl = this.gl;
      if (!gl || this.destroyed || gl.isContextLost()) return true;
      const t = typeof threshold === 'number' ? threshold : 3;
      const w = gl.drawingBufferWidth, h = gl.drawingBufferHeight;
      if (!w || !h) return true;
      const row = new Uint8Array(w * 4);
      try {
        const ys = [0.25, 0.5, 0.8];
        for (let k = 0; k < ys.length; k++) {
          gl.readPixels(0, Math.min(h - 1, Math.floor(h * ys[k])), w, 1, gl.RGBA, gl.UNSIGNED_BYTE, row);
          for (let i = 0; i < row.length; i += 4) if (row[i] > t || row[i + 1] > t || row[i + 2] > t) return false;
        }
      } catch (e) { return false; }
      return true;
    }

    /* A foto é o próprio canvas: o que se vê é o que sai. Se o CEF não souber
       codificar o mime pedido, o toDataURL do Chromium devolve PNG em silêncio. */
    toDataURL(mime, quality) {
      if (!this.canvas || this.destroyed) return null;
      try {
        return this.canvas.toDataURL(
          mime || DEFAULT_MIME,
          typeof quality === 'number' ? quality : DEFAULT_QUALITY
        );
      } catch (e) { return null; }
    }

    toBlob(mime, quality) {
      if (!this.canvas || this.destroyed) return Promise.resolve(null);

      const type = mime || DEFAULT_MIME;
      const q    = typeof quality === 'number' ? quality : DEFAULT_QUALITY;
      const canvas = this.canvas;

      if (typeof canvas.toBlob === 'function') {
        return new Promise(resolve => {
          try { canvas.toBlob(b => resolve(b || null), type, q); }
          catch (e) { resolve(null); }
        });
      }
      return Promise.resolve(dataURLToBlob(this.toDataURL(type, q)));
    }

    /* -------- fim -------- */

    /* Ao contrário do lb-phone, NÃO remove a <canvas> do DOM por omissão -
       quem a criou é que manda nela. Passar true para replicar o original. */
    destroy(removeCanvas) {
      if (this.destroyed) return;
      this.destroyed = true;

      if (this.animationFrame) { cancelAnimationFrame(this.animationFrame); this.animationFrame = 0; }
      if (this._resizePending) { cancelAnimationFrame(this._resizePending); this._resizePending = 0; }
      try { window.removeEventListener('resize', this._onWindowResize); } catch (e) {}

      const gl = this.gl;
      if (gl) {
        try {
          for (let i = 0; i < this.prevBuffers.length; i++)  gl.deleteFramebuffer(this.prevBuffers[i]);
          for (let i = 0; i < this.prevTextures.length; i++) gl.deleteTexture(this.prevTextures[i]);
          if (this.mainTexture)    gl.deleteTexture(this.mainTexture);
          if (this.vertexBuffer)   gl.deleteBuffer(this.vertexBuffer);
          if (this.texcoordBuffer) gl.deleteBuffer(this.texcoordBuffer);
          if (this.mainProgram)    gl.deleteProgram(this.mainProgram);
          if (this.copyProgram)    gl.deleteProgram(this.copyProgram);

          // Devolve já o contexto: o browser só permite ~16 em simultâneo e a
          // Câmara/chamada podem abrir e fechar muitas vezes por sessão.
          const lose = gl.getExtension('WEBGL_lose_context');
          if (lose) lose.loseContext();
        } catch (e) {}
      }

      if (removeCanvas && this.canvas && this.canvas.parentNode) {
        try { this.canvas.parentNode.removeChild(this.canvas); } catch (e) {}
      }

      this.gl = null;
      this.live = false;
      this.mainProgram = null;
      this.copyProgram = null;
      this.mainTexture = null;
      this.vertexBuffer = null;
      this.texcoordBuffer = null;
      this.prevTextureUniformLocation = null;
      this.uvMatLocation = null;
      this.uvOffLocation = null;
      this.prevTextures = [];
      this.prevBuffers = [];
      this.prevTextureUnits = [];
      this.prevTextureUnitOrders = [];
    }
  }

  /* ------------------------------------------------------------------
     API PÚBLICA
     ------------------------------------------------------------------ */

  /* create(canvas, opts) - NUNCA lança. Fora do jogo (ou se o WebGL falhar)
     devolve o objeto inerte: os call sites podem chamar tudo à vontade e
     distinguem os dois mundos por `.live` (ou por GameRender.available()).

     opts:
       aspect            rácio inicial (largura/altura), ex. 3/4
       quality           multiplicador de resolução inicial
       autoResize        reagir ao resize da janela (por omissão true)
       maxFps            teto de desenhos por segundo do ciclo (0/omisso = cada rAF;
                         o PiP da videochamada usa Config.VideoCall.pipFps)
       allowOutsideGame  criar mesmo fora do FiveM (só para harness: o visor
                         fica VERMELHO, que é o pixel mágico por substituir) */
  /* ⚠️ Um contexto morto por `loseContext()` NÃO volta sozinho: pela spec do WebGL só um
     `restoreContext()` o traz de volta, e `getContext('webgl')` devolve o MESMO objeto perdido
     em vez de null. Como o destroy() perde o contexto de propósito (para libertar VRAM), a
     segunda vida do mesmo <canvas> arrancava com um contexto zombie - os shaders não compilavam
     e o círculo do Face Key ficava preto para sempre depois de fechar e reabrir o telemóvel.
     A cura é dar-lhe um <canvas> NOVO: o elemento é substituído por um clone no mesmo sítio. */
  function freshCanvas(canvas) {
    try {
      const gl = canvas.getContext('webgl');
      if (!gl || !gl.isContextLost || !gl.isContextLost()) return canvas;
      if (!canvas.parentNode) return canvas;
      const clone = canvas.cloneNode(false);
      canvas.parentNode.replaceChild(clone, canvas);
      return clone;
    } catch (e) { return canvas; }
  }

  function create(canvas, opts) {
    opts = opts || {};
    let gl = null;
    try {
      if (!canvas || typeof canvas.getContext !== 'function') return createInert();
      if (!available() && !opts.allowOutsideGame) return createInert();

      canvas = freshCanvas(canvas);
      gl = canvas.getContext('webgl', CONTEXT_OPTIONS);
      if (!gl || (gl.isContextLost && gl.isContextLost())) return createInert();

      const instance = new Renderer(canvas, gl);

      if (typeof opts.quality === 'number') instance.quality = Math.min(4, Math.max(0.1, opts.quality));
      if (opts.maxFps > 0) instance.setMaxFps(opts.maxFps);
      if (opts.aspect > 0) instance.resizeByAspect(opts.aspect);
      else instance.resize(canvas.width || 1, canvas.height || 1);

      if (opts.autoResize !== false) {
        try { window.addEventListener('resize', instance._onWindowResize); } catch (e) {}
      }

      instance._start();
      return instance;
    } catch (e) {
      // Um shader que não compila ou um contexto perdido não podem levar a NUI
      // atrás - o telemóvel tem de continuar a funcionar sem câmara.
      // ⚠️ O contexto já criado TEM de ser largado aqui: o CEF só dá ~16 e cada tentativa
      // falhada comia um em silêncio, até a câmara deixar de abrir sem explicação.
      try { if (gl) gl.getExtension('WEBGL_lose_context') && gl.getExtension('WEBGL_lose_context').loseContext(); } catch (e2) {}
      try { console.warn('[GameRender] indisponível:', e && e.message); } catch (e2) {}
      return createInert();
    }
  }

  return {
    create: create,
    available: available,
    inert: createInert,
    coverScale: coverScale,
    MAX_ZOOM: MAX_ZOOM,
    MAX_ROLL: MAX_ROLL,
    PREV_FRAME_COUNT: PREV_FRAME_COUNT,
    CONTEXT_OPTIONS: CONTEXT_OPTIONS
  };
})();
