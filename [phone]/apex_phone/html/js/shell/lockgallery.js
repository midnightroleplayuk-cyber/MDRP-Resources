/* ============================================================
   LOCK GALLERY - personalização do ecrã bloqueado E do ecrã principal (PearOS 17 → 26, PearPhone 18 Pro)
   Long press numa zona vazia do lock (550 ms) → autenticação (recente / Face Key / código) → o lock ENCOLHE para um cartão
   (o próprio #lock, com cópia do wallpaper por baixo), fundo escurecido + cópia pré-desfocada, galeria horizontal com arrasto
   físico (limiar 25 % ou velocidade), pílula de Foco, "+" (novo fundo: destaque, fotos, cores, gradientes), apagar por swipe ↑
   + caixote, sair por toque no cartão / fundo / indicador / lateral.
   "Personalizar" → os DOIS ECRÃS lado a lado (o #lock encolhe para a esquerda, o ecrã principal nasce à direita):
     · tocar no ecrã bloqueado → editor do bloqueado (relógio: fonte/peso/tamanho/cor; widgets; controlos inferiores);
     · tocar no ecrã principal → editor do principal (Par / Cor / Gradiente / Fotos + Desfocar), Cancelar repõe, Concluído aplica;
     · tocar fora → volta à galeria.
   Dados: System.state.lockScreens = [{ id, name, wallpaper, custom, clockFont, clockColor, clockSize, clockWeight, widgets,
   controls, focus, depth, home }], state.lockCurrent = id. `home` = { mode: 'pair'|'color'|'gradient'|'photo', css, url, seed,
   wallpaper, blur } - sem `home` é um PAR (o principal usa o fundo do bloqueado; compatível com os ecrãs já gravados).
   Aplicar um ecrã = escrever as chaves que o System JÁ usa: lockWallpaper (bloqueado) + wallpaper/wallpaperCustom (principal)
   + clockFont, clockColor, clockSize, clockWeight, lockWidgetsV2, lockControls, dnd - o lock e a home desenham-se como sempre.
   Era aqui a falha que se sentia: aplicar só escrevia o bloqueado e um fundo novo nunca chegava ao ecrã principal.
   `depth` (fundo / relógio / sujeito PNG à frente) fica preparado em .lock-depth; só se usa quando um fundo o trouxer.
   Regras CEF: só transform/opacity; o desfoque de fundo é a imagem pré-desfocada (--wp-lock-blur); sem backdrop-filter no jogo;
   o "Desfocar" do principal é uma imagem JÁ desfocada num canvas (nunca filter no DOM).
   ============================================================ */
window.LockGallery = (() => {
  /* PearOS 27 (1.4.0, medido na captura do iOS 26): o cartão atual fica a .70 (308×669, centrado na vertical) para caberem a etiqueta
     COLEÇÕES por cima e os pontos + Personalizar por baixo; os vizinhos têm o MESMO tamanho (já não encolhem para .74), a 336 px de
     centro a centro (308 + 28 de folga). Antes: .84 (370 px) + 14 px até ao vizinho a .74 = 362. */
  const g = UI.g; const SP0 = 336;
  /* PearPhone Fold (lockgallery.css, --lsg-k / --lsg-ks): fechado (670) o cartão atual fica a .66 (442 px) e os vizinhos a .56,
     426 px ao lado; aberto (1340) a .5 (670 px) e os vizinhos a .42, 638 px ao lado. O centro é o da zona de conteúdo */
  const isFold = () => !!(window.System && System.form === 'fold');
  const foldOpen = () => isFold() && !!System.foldOpen;
  const spOf = () => isFold() ? (foldOpen() ? 638 : 426) : SP0;
  const cardW = () => isFold() ? (foldOpen() ? 1340 * .5 : 670 * .66) : 440 * .7;   /* largura do cartão atual (limiar do arrasto) */
  let root, dim, sides, ui, focusBtn, customBtn, addBtn, trashBtn, cancelBtn, duo, hcard, lblL, lblR, hbar, hpanel, askEl, topEl, dotsEl,
    editSnap = null, editNew = false, open = false, edit = false, pick = false, homeEd = null, drag = null, closing = false, closeT = null, settleT = null, returnTo = null, addMode = false, addT = null;   /* editSnap: cópia do ecrã ao entrar em Personalizar - "Cancelar" repõe-a (as escolhas aplicam-se ao vivo). homeEd: { draft, panel, auto } enquanto o editor do principal está aberto (o rascunho só se aplica no Concluído). addMode: o cartão "Adicionar novo" (depois do último ecrã) está ao centro */
  /* modos de Foco = System.state.focus ('none'|'dnd'|'work'|'sleep', o mesmo do Centro de Controlo). 'personal' ficou só para ler
     ecrãs antigos gravados com ele (nunca teve efeito; ao aplicar conta como sem foco, como antes) - já não se oferece no seletor. */
  const FOCUS = { none: 'Foco', dnd: 'Não incomodar', personal: 'Pessoal', work: 'Trabalho', sleep: 'Dormir' };
  const FOCUS_ICON = { none: 'moon', dnd: 'moon', personal: 'personCircle', work: 'briefcase', sleep: 'moon' };
  const FOCUS_MODES = ['none', 'dnd', 'work', 'sleep'];
  const focusNow = () => { const s = S(); if (!s.dnd) return 'none'; return FOCUS_MODES.includes(s.focus) && s.focus !== 'none' ? s.focus : 'dnd'; };
  /* relógio: alinhamento/posição/estilo (Lock.applyClock valida e passa a atributos do #lock) */
  /* clockWght: peso exato (barra de "Fonte e cor"); null = o da fonte. clockScale (1.4.0, a pega do relógio): tamanho contínuo .72..1.75,
     null = o do clockSize antigo; clockNumerals: sistema de numeração da hora ('latn' = 0-9). Os dois TÊM de estar aqui: a cópia do
     Cancelar (editSnap/aSnap) assenta por cima do CLOCK_DEF e um ecrã gravado antes deles ficava com o tamanho/números escolhidos. */
  const CLOCK_DEF = { clockAlign: 'center', clockPos: 'top', clockStyle: 'glass', clockWght: null, clockScale: null, clockNumerals: 'latn' };
  const scr = () => UI.screen(); const lockEl = () => document.getElementById('lock'); const S = () => System.state;
  /* LockEditor (lockeditor.js, 1.4.0) é OUTRO ficheiro: se faltar (ficheiro em cache, ordem de carga) a galeria continua com os painéis
     de sempre; se rebentar, o erro é relançado fora do fluxo (aparece no F8 / no harness) em vez de deixar a galeria a meio. Só PearOS. */
  const hasLE = fn => !isAnd() && !!(window.LockEditor && typeof LockEditor[fn] === 'function');
  const LE = (fn, ...a) => { if (!hasLE(fn)) return undefined; try { return LockEditor[fn](...a); } catch (e) { setTimeout(() => { throw e; }); return undefined; } };
  /* tipos de fundo novos (wallpapers27.js: emoji, meteorologia, astronomia, cor, aleatórias e estilos de foto): `custom` é um objeto
     pequeno ({ kind, … }) que se desenha em tempo real - NUNCA um data URL gravado. Sem o módulo carregado ficam os fundos de sempre. */
  const kindOk = c => !!(c && window.WallKinds && WallKinds.needs && WallKinds.needs(c));
  const kindSig = c => { if (!c) return null; if (kindOk(c)) { try { return WallKinds.sig(c); } catch (e) { return JSON.stringify(c); } } return c.kind ? JSON.stringify(c) : (c.style && c.url ? 'style:' + c.style : null); };
  /* medidas do relógio de um ecrã (cartões laterais / miniaturas): as do Lock.clockMetrics (lock.js) quando existe; senão a mesma conta
     aqui - k = clockScale (ou small .85 / normal 1 / large 1.14), a fonte cresce até ×1,15 (kx) e o resto é esticão vertical (sy) */
  const clockM = ls => { if (window.Lock && Lock.clockMetrics) { try { const m = Lock.clockMetrics(ls); if (m && m.fs > 0) return m; } catch (e) {} }
    const v = +ls.clockScale; const k = ls.clockScale != null && isFinite(v) ? Math.max(.72, Math.min(1.75, v)) : ({ small: .85, large: 1.14 }[ls.clockSize] || 1);
    const kx = Math.min(k, 1.15), sy = Math.max(1, k / 1.15); const N = window.Lock && Array.isArray(Lock.NUMERALS) ? Lock.NUMERALS.find(n => n[0] === ls.clockNumerals) : null;
    return { k, kx, sy, fs: 176 * kx, fsWide: 160 * kx, numFit: N && +N[3] > 0 ? +N[3] : 1 }; };
  /* algarismos que não são latinos (Devanágari, árabe-índico, tailandês…): as fontes da hora não os têm; estas são as do Windows do jogo */
  const NUM_STACK = "'Segoe UI','Nirmala UI','Leelawadee UI','Khmer UI','Lao UI','Microsoft Himalaya','Myanmar Text','Microsoft YaHei',sans-serif";
  const uid = () => 'ls' + Math.random().toString(36).slice(2, 8);
  const res = id => (Wallpapers.resolve ? Wallpapers.resolve(id) : id);
  /* paletas do seletor de fundos e do editor do principal */
  const COLORS = [['#0A84FF', 'Azul'], ['#1C1C1E', 'Grafite'], ['#30D158', 'Verde'], ['#FF375F', 'Rosa'], ['#BF5AF2', 'Roxo'], ['#FF9F0A', 'Laranja'], ['#FFD60A', 'Amarelo'], ['#64D2FF', 'Céu'], ['#A2845E', 'Castanho'], ['#8E8E93', 'Cinzento']];
  const GRADS = [['linear-gradient(160deg,#0a1440,#14307a 48%,#0b2262)', 'Meia-noite'], ['linear-gradient(160deg,#FF9F0A,#FF375F)', 'Pôr do sol'], ['linear-gradient(160deg,#5E5CE6,#BF5AF2)', 'Violeta'], ['linear-gradient(160deg,#64D2FF,#0A84FF 55%,#1B3FA6)', 'Oceano'], ['linear-gradient(160deg,#30D158,#0C7A4B)', 'Floresta'], ['linear-gradient(160deg,#FFD60A,#FF9F0A)', 'Âmbar'], ['linear-gradient(160deg,#FF6482,#BF5AF2 60%,#5E5CE6)', 'Aurora'], ['linear-gradient(160deg,#636366,#1C1C1E)', 'Grafite']];
  /* FONTES DA HORA (folha "Fonte e cor", PearOS 17): [id (state.clockFont), nome, estilo da amostra e da miniatura,
     [peso mín, máx] quando a fonte é variável (mostra a barra do peso), peso de origem, fator de tamanho].
     O #lock lê as MESMAS regras no lock.css (body[data-clockfont]); o fator encolhe as fontes largas para a hora caber nos 440 px
     (medido no harness: "09:41" a 176 px). Todas existem no CEF do jogo: Bahnschrift, Cambria, Times New Roman, Impact e Arial Black
     são do Windows; Inter, Outfit e MonteCarlo vêm na pasta fonts/. 'thin' (contas antigas) continua a valer, sem quadrado próprio. */
  const BAHN = "'Bahnschrift','Arial Narrow',Inter,sans-serif";
  const FONTS = [
    ['default', 'Padrão', `font-family:${BAHN};font-stretch:75%`, [300, 700], 600, 1],
    ['bold', 'Negrito', `font-family:${BAHN};font-stretch:75%`, [300, 700], 800, 1],
    ['wide', 'Larga', `font-family:${BAHN};font-stretch:normal`, [300, 700], 500, 1],
    ['rounded', 'Arredondada', 'font-family:var(--font-rounded);font-stretch:normal', [300, 800], 600, 1],
    ['geo', 'Geométrica', "font-family:'Outfit',Inter,sans-serif;font-stretch:normal", [100, 900], 600, .95],
    ['heavy', 'Pesada', "font-family:'Outfit',Inter,sans-serif;font-stretch:normal", [100, 900], 900, .9],
    ['mono', 'Mono', 'font-family:var(--font-mono);font-stretch:normal;letter-spacing:0', null, 500, 1],
    ['serif', 'Serifa', "font-family:Cambria,'Times New Roman',serif;font-stretch:normal", null, 400, .94],
    ['italic', 'Itálica', "font-family:'Times New Roman',Times,serif;font-stretch:normal;font-style:italic", null, 400, 1],
    ['script', 'Manuscrita', "font-family:'MonteCarlo',cursive;font-stretch:normal;letter-spacing:0", null, 400, 1],
    ['poster', 'Cartaz', "font-family:Impact,'Arial Narrow',sans-serif;font-stretch:normal", null, 400, 1],
    ['block', 'Bloco', "font-family:'Arial Black',Arial,sans-serif;font-stretch:normal", null, 900, .78],
  ];
  const fontOf = id => FONTS.find(f => f[0] === id) || (id === 'thin' ? ['thin', 'Fina', FONTS[0][2], [300, 700], 200, 1] : FONTS[0]);
  const LEGACY_F = ['default', 'thin', 'bold', 'rounded', 'mono'];   /* as fontes de sempre: o "Peso" antigo (clockWeight) ainda manda nelas */
  /* o peso da hora de um ecrã: o exato da barra; senão o "Peso" antigo nas fontes de sempre; senão o da fonte */
  const wghtOf = ls => { const w = Math.round(+ls.clockWght); if (ls.clockWght != null && w >= 100 && w <= 900) return w; const F = fontOf(ls.clockFont);
    if (LEGACY_F.includes(F[0])) { if (ls.clockWeight === 'light') return 300; if (ls.clockWeight === 'bold') return 800; } return F[4]; };
  /* cores da hora (PearOS 17: branco, marfim, amarelo, verde, rosa, menta, lavanda, salmão, laranja, ciano; o arco-íris abre o seletor) */
  const SWATCHES = ['#FFFFFF', '#F3E9D8', '#FFD60A', '#62E27F', '#FF7AB6', '#7FF0D2', '#BBA9FF', '#FF9C86', '#FF9F0A', '#5DD9FF'];

  /* ---------- fundos: valor de background-image de { wallpaper, custom } (a mesma ordem de prioridade do System.wpStyle) ---------- */
  const HOME0 = { mode: 'pair', blur: false };
  const homeOf = ls => Object.assign({}, HOME0, (ls && ls.home) || {});
  const solid = c => `linear-gradient(${c},${c})`;   /* cor sólida como imagem: assim TUDO vai por background-image e o background-size da classe nunca é apagado por um shorthand */
  const isColor = v => /^(#|rgb|hsl)/i.test(String(v || '').trim());
  function bgOf(src) { const c = src && src.custom;
    /* 1.4.0: um tipo (ou um estilo de foto) resolve-se primeiro, de forma síncrona (SVG em string / cópia em cache; o canvas do emoji e dos
       estilos chega depois por 'wallkind:ready'). Um erro do módulo não pode deixar o cartão vazio: cai no fundo de sempre. */
    if (kindOk(c)) { try { const v = WallKinds.css(c); if (v) return v; } catch (e) { setTimeout(() => { throw e; }); } }
    if (c && c.url) return UI.img(c.url); if (c && c.css) return isColor(c.css) ? solid(c.css) : c.css; if (c && c.seed && window.photoBg) return photoBg(c.seed); return Wallpapers.css((src && src.wallpaper) || S().wallpaper); }
  /* ⚠️ nunca dentro de uma string de HTML: um url("…") com aspas duplas fechava o atributo style (as fotos com data: URL ficavam em branco) */
  const paintBg = (el, v) => { if (el) el.style.backgroundImage = v || 'none'; };
  /* 1.4.1: enquadramento da foto (custom.crop) numa caixa w × h (por omissão com a proporção do ecrã: cartões e miniaturas). Sem crop limpa,
     para a classe voltar ao center/cover - os cartões laterais são novos, mas a miniatura do editor e o cartão do principal reutilizam-se. */
  const cropBox = (custom, w, h) => { try { return window.WallKinds && WallKinds.cropCss ? WallKinds.cropCss(custom, w || (System.SW || 440), h || 956) : null; } catch (e) { return null; } };
  const paintCrop = (el, custom, w, h) => { if (!el) return; const c = cropBox(custom, w, h); el.style.backgroundSize = c ? c.size : ''; el.style.backgroundPosition = c ? c.pos : ''; };
  const lockSrc = ls => ({ wallpaper: ls.wallpaper || S().wallpaper, custom: ls.custom || null });
  /* ⚠️ o Chromium (browser e CEF) resolve um url() RELATIVO dentro de uma variável CSS contra a FOLHA onde está o var(), não contra o
     documento: o --wp-lock do System ('img/wallpapers/…') lido em css/lockgallery.css apontava para css/img/wallpapers/… (404) e o
     #lock::before ficava vazio - o cartão do ecrã bloqueado (galeria, escolhedor dos dois ecrãs, editor) era TRANSPARENTE e via-se o
     véu através dele, ao lado de um ecrã principal bem pintado. O cartão passa a ler --lsg-lock, já com o endereço absoluto. */
  const absBg = v => { const m = /^url\((['"]?)(.*)\1\)$/.exec(String(v || '').trim()); if (!m || /^[a-z][a-z0-9+.-]*:/i.test(m[2])) return v; try { return UI.img(new URL(m[2], document.baseURI).href); } catch (e) { return v; } };
  const paintLockCard = ls => { const el = lockEl(); if (!el || !ls) return; el.style.setProperty('--lsg-lock', absBg(bgOf(lockSrc(ls))) || 'none'); liveCrop(cropBox(ls.custom)); };
  /* o cartão é o #lock::before (um pseudo-elemento não tem CSSOM): o enquadramento vai por variáveis, as mesmas que o editor reescreve durante
     o arrasto (lockgallery.css). null = sem enquadramento (cai no center/cover de sempre) */
  const liveCrop = c => { const st = (lockEl() || {}).style; if (!st) return; if (c) { st.setProperty('--lsg-lock-size', c.size); st.setProperty('--lsg-lock-pos', c.pos); } else { st.removeProperty('--lsg-lock-size'); st.removeProperty('--lsg-lock-pos'); } };
  /* o fundo (nítido) do ecrã principal de um ecrã bloqueado, segundo o modo */
  function homeSrc(ls, h) { h = h || homeOf(ls); const lk = lockSrc(ls);
    if ((h.mode === 'color' || h.mode === 'gradient') && h.css) return { wallpaper: lk.wallpaper, custom: { css: h.css } };
    if (h.mode === 'photo' && (h.url || h.seed)) return { wallpaper: lk.wallpaper, custom: { url: h.url || null, seed: h.url ? null : h.seed } };
    if (h.mode === 'photo' && h.wallpaper) return { wallpaper: h.wallpaper, custom: null };
    return lk; }
  /* desfocar só faz sentido numa IMAGEM: cores, gradientes e as fotos de demonstração (gradientes) já são suaves */
  /* 1.4.0: os tipos novos (emoji, meteorologia, astronomia, cor, aleatórias) já são desenhos suaves ou mudam sozinhos - também não; um estilo
     de foto ({ url, style }) é uma imagem e desfoca-se como as outras */
  const canBlur = (ls, h) => { const s = homeSrc(ls, h); if (s.custom && s.custom.kind) return false; return !(s.custom && (s.custom.css || (!s.custom.url && s.custom.seed))); };
  /* url de dentro de um url(…) - o data URI dos SVG tem parênteses (rotate(), url(#…)): não se corta no primeiro ")" (mesma leitura do System.makeBlur) */
  const urlOf = v => { const m = /url\("([^"]+)"\)/.exec(v || '') || /url\('([^']+)'\)/.exec(v || '') || /url\(([^)]+)\)/.exec(v || ''); return m ? m[1] : null; };
  const BLUR = {}, AVG = {}, WAIT = {};
  /* ⚠️ chamava-se loadImg, tal como a versão com Promise da folha do link (mais abaixo). Duas `function` com o mesmo nome no mesmo
     âmbito: o JavaScript eleva as duas e fica a ÚLTIMA - o blurOf e o avgColor chamavam a da Promise, que ignora os callbacks: o
     "Desfocar" do ecrã principal nunca produzia a cópia desfocada (WAIT acumulava pedidos para sempre) e a "Cor"/"Gradiente" ficavam
     na cor provisória do Wallpapers.tone. Nome próprio para a versão de callbacks. */
  function loadImgCb(src, ok, fail) { const img = new Image(); if (!/^data:/.test(src)) img.crossOrigin = 'anonymous'; img.onload = () => ok(img); img.onerror = () => fail && fail(); img.src = src; }
  /* cover de uma imagem num canvas com margem (sem bordas esbatidas); os SVG sem tamanho intrínseco fiável assumem a proporção do ecrã */
  function cover(x, img, W, H, pad) { let iw = img.naturalWidth || img.width, ih = img.naturalHeight || img.height; if (!iw || !ih || (iw === 300 && ih === 150)) { iw = 440; ih = 956; } const r = Math.max((W + pad) / iw, (H + pad) / ih), w = iw * r, h = ih * r; x.drawImage(img, (W - w) / 2, (H - h) / 2, w, h); }
  /* "Desfocar" do ecrã principal (legibilidade dos ícones): imagem PRÉ-DESFOCADA num canvas pequeno → JPEG em data URL.
     No jogo não pode haver filter no DOM; o filter do CANVAS é desenho, não camada (o System.makeBlur já o usa). Onde o canvas não
     tiver filter, reduz-se a 1/8 e volta-se a ampliar: a interpolação faz o desfoque. 176×382 a .8 ≈ 8 KB (vai para a conta). */
  function blurOf(src, cb) { if (BLUR[src]) { cb(BLUR[src]); return; } (WAIT[src] = WAIT[src] || []).push(cb); if (WAIT[src].length > 1) return;
    const done = v => { const l = WAIT[src] || []; delete WAIT[src]; if (v) BLUR[src] = v; l.forEach(f => { try { f(v); } catch (e) {} }); };
    loadImgCb(src, img => { try { const W = 176, H = 382, c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d'); x.fillStyle = '#1C1C1E'; x.fillRect(0, 0, W, H);
      if ('filter' in x) { x.filter = 'blur(7px) saturate(135%)'; cover(x, img, W, H, 44); x.filter = 'none'; }
      else { const t = document.createElement('canvas'); t.width = 22; t.height = 48; cover(t.getContext('2d'), img, 22, 48, 6); x.imageSmoothingEnabled = true; x.drawImage(t, 0, 0, W, H); }
      x.fillStyle = 'rgba(0,0,0,.1)'; x.fillRect(0, 0, W, H);   /* um véu leve: é para os ícones se lerem por cima */
      done(c.toDataURL('image/jpeg', .8)); } catch (e) { done(null); } }, () => done(null)); }   /* imagem externa sem CORS: fica a nítida */
  /* cor dominante (para "Cor" e "Gradiente" começarem numa cor do próprio fundo, como no PearPhone): média pesada pela saturação */
  function avgColor(bg, cb, fb) { fb = fb || '#3A3A3C'; const u = urlOf(bg); if (!u) { const m = /#[0-9a-f]{6}/i.exec(bg || ''); cb(m ? m[0].toUpperCase() : fb); return; } if (AVG[u]) { cb(AVG[u]); return; }
    loadImgCb(u, img => { try { const W = 16, H = 34, c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d'); cover(x, img, W, H, 0); const d = x.getImageData(0, 0, W, H).data; let r = 0, gg = 0, b = 0, n = 0;
      for (let i = 0; i < d.length; i += 4) { const mx = Math.max(d[i], d[i + 1], d[i + 2]), mn = Math.min(d[i], d[i + 1], d[i + 2]); const w = (mx - mn) / 255 + .04; r += d[i] * w; gg += d[i + 1] * w; b += d[i + 2] * w; n += w; }
      r /= n; gg /= n; b /= n; const k = 150 / Math.max(1, r, gg, b); const hex = '#' + [r, gg, b].map(v => Math.round(Math.min(255, v * k)).toString(16).padStart(2, '0')).join('').toUpperCase(); AVG[u] = hex; cb(hex); } catch (e) { cb(fb); } }, () => cb(fb)); }
  const mix = (hex, t, p) => { const n = parseInt(String(hex).replace('#', ''), 16); if (isNaN(n)) return hex; const T = t === 'w' ? 255 : 0; return '#' + [n >> 16, (n >> 8) & 255, n & 255].map(v => Math.round(v + (T - v) * p).toString(16).padStart(2, '0')).join(''); };
  const gradFrom = c => `linear-gradient(160deg,${mix(c, 'w', .28)},${mix(c, 'b', .45)})`;
  /* fundo do principal para pintar/aplicar: nítido já; se tiver desfoque e ainda não houver cópia, `later(v)` recebe a desfocada quando estiver pronta */
  function homeBg(ls, h, later) { const sharp = bgOf(homeSrc(ls, h)); if (!h.blur || !canBlur(ls, h)) return sharp; const u = urlOf(sharp); if (u && BLUR[u]) return UI.img(BLUR[u]); if (u && later) blurOf(u, out => { if (out) later(UI.img(out)); }); return sharp; }

  /* ---------- dados ---------- */
  function fromState() { const s = S(); const lw = s.lockWallpaper; const wc = s.wallpaperCustom && !s.wallpaperCustom.blur ? s.wallpaperCustom : null;
    return { id: uid(), name: 'Ecrã bloqueado', wallpaper: lw ? (lw.wallpaper || null) : (s.wallpaper || null), custom: lw ? (lw.custom || null) : wc, clockFont: s.clockFont || 'default', clockColor: s.clockColor || '#FFFFFF', clockSize: s.clockSize || 'normal', clockWeight: s.clockWeight || 'regular', clockAlign: s.clockAlign || CLOCK_DEF.clockAlign, clockPos: s.clockPos || CLOCK_DEF.clockPos, clockStyle: s.clockStyle || CLOCK_DEF.clockStyle, clockWght: s.clockWght != null ? s.clockWght : null, clockScale: s.clockScale != null ? s.clockScale : null, clockNumerals: s.clockNumerals || 'latn', widgets: (s.lockWidgetsV2 || []).slice(), controls: (s.lockControls || ['torch', 'camera']).slice(), focus: focusNow(), depth: null, home: Object.assign({}, HOME0) }; }
  function list() { let l = S().lockScreens; if (!Array.isArray(l) || !l.length) { l = [fromState()]; System.setState({ lockScreens: l, lockCurrent: l[0].id }, { noApply: true }); } return l; }
  function curIdx() { const l = list(); const i = l.findIndex(x => x.id === S().lockCurrent); return i < 0 ? 0 : i; }
  const cur = () => list()[curIdx()];
  const save = l => System.setState({ lockScreens: l }, { noApply: true });
  /* aplicar um ecrã bloqueado = o bloqueado E o seu ecrã principal (lockWallpaper passa a ir sempre explícito: o principal pode ser outro) */
  /* opts.focus === false: não mexer no Foco. Editar o relógio/widgets de um ecrã reaplicava-o inteiro e desligava um Foco que o
     jogador tivesse ligado depois no Centro de Controlo; o Foco do ecrã só se aplica ao escolher o ecrã ou ao mudar o próprio Foco. */
  function applyLS(ls, opts) {
    const h = homeOf(ls), lk = lockSrc(ls), hs = homeSrc(ls, h);
    const patch = { lockCurrent: ls.id, lockWallpaper: { wallpaper: lk.wallpaper, custom: lk.custom }, wallpaper: hs.wallpaper, wallpaperCustom: hs.custom, clockFont: ls.clockFont || 'default', clockColor: ls.clockColor || '#FFFFFF', clockSize: ls.clockSize || 'normal', clockWeight: ls.clockWeight || 'regular', clockAlign: ls.clockAlign || CLOCK_DEF.clockAlign, clockPos: ls.clockPos || CLOCK_DEF.clockPos, clockStyle: ls.clockStyle || CLOCK_DEF.clockStyle, clockWght: ls.clockWght != null ? ls.clockWght : null, clockScale: ls.clockScale != null ? ls.clockScale : null, clockNumerals: ls.clockNumerals || 'latn', lockWidgetsV2: (ls.widgets || []).slice(), lockControls: (ls.controls || ['torch', 'camera']).slice() };
    if (h.blur && canBlur(ls, h)) { const u = urlOf(bgOf(hs)); if (u && BLUR[u]) patch.wallpaperCustom = { url: BLUR[u], blur: true };
      /* a cópia desfocada ainda não existe: aplica-se a nítida e troca-se quando o canvas acabar - SE o ecrã continuar a ser este e a pedir desfoque */
      else if (u) blurOf(u, out => { const c = cur(); if (!out || S().lockCurrent !== ls.id || !c || !homeOf(c).blur || urlOf(bgOf(homeSrc(c))) !== u) return; System.setState({ wallpaperCustom: { url: out, blur: true } }); Bridge.emit('wallpaper:changed'); }); }
    /* Foco do ecrã → System.state.focus; `dnd` acompanha (é o interruptor que o notify.js e a barra de estado já leem) */
    if (!opts || opts.focus !== false) { const f = FOCUS_MODES.includes(ls.focus) ? ls.focus : 'none'; if (f !== 'none') { patch.focus = f; patch.dnd = true; } else if (S().dnd || (S().focus && S().focus !== 'none')) { patch.focus = 'none'; patch.dnd = false; } }
    System.setState(patch); paintLockCard(ls); if (window.Lock) { Lock.renderWidgets(); Lock.renderShortcuts(); if (Lock.applyClock) Lock.applyClock(); Lock.tick(new Date(), true); }
    Bridge.emit('wallpaper:changed');   /* Definições › Fundo repinta as pré-visualizações */
  }
  /* o.focus === false: nunca reaplicar o Foco (o Cancelar do editor repõe a cópia inteira, que também traz `focus`, e desligava o Foco do CC) */
  function updateCur(patch, o) { const l = list().slice(); const i = curIdx(); l[i] = Object.assign({}, l[i], patch); save(l); applyLS(l[i], { focus: !(o && o.focus === false) && 'focus' in patch }); paintUI(); }
  /* o fundo pode mudar por FORA da galeria (Fotos › Definir como fundo, Vera): o ecrã atual absorve o que está no estado,
     senão a galeria mostrava um par que já não é o que está no telemóvel. Só grava; não aplica (já está aplicado). */
  function homeFromState(ls) { const s = S(), wc = s.wallpaperCustom, lk = lockSrc(ls);
    if (wc && wc.blur) return Object.assign(homeOf(ls), { blur: true });   /* a origem de um fundo desfocado não se reconstrói: fica o modo que o ecrã já tinha */
    if (wc && wc.css) return { mode: /gradient/i.test(wc.css) ? 'gradient' : 'color', css: wc.css, blur: false };
    /* 1.4.0: um tipo no principal só existe como PAR (nenhum modo do principal cria um tipo): igual ao do bloqueado → par; outro → fica o modo que o ecrã já tinha */
    if (wc && wc.kind) return lk.custom && kindSig(lk.custom) === kindSig(wc) ? Object.assign({}, HOME0) : homeOf(ls);
    if (wc && (wc.url || wc.seed)) return lk.custom && (lk.custom.url || null) === (wc.url || null) && (lk.custom.url ? true : lk.custom.seed === wc.seed) ? Object.assign({}, HOME0) : { mode: 'photo', url: wc.url || null, seed: wc.url ? null : wc.seed, blur: false };
    return !lk.custom && res(s.wallpaper) === res(lk.wallpaper) ? Object.assign({}, HOME0) : { mode: 'photo', wallpaper: s.wallpaper, blur: false }; }
  /* kindSig: dois fundos do mesmo tipo com parâmetros diferentes (outro emoji, outra cor, a foto seguinte das aleatórias) não são o mesmo fundo */
  const sig = src => JSON.stringify([src.custom ? null : res(src.wallpaper), src.custom ? [src.custom.url || null, src.custom.css || null, src.custom.url ? null : (src.custom.seed || null), kindSig(src.custom)] : null]);
  function sync() { const l = list(), i = curIdx(), ls = l[i], s = S(); if (!ls) return;
    const lw = s.lockWallpaper; const eff = lw ? { wallpaper: lw.wallpaper || s.wallpaper, custom: lw.custom || null } : { wallpaper: s.wallpaper, custom: s.wallpaperCustom && !s.wallpaperCustom.blur ? s.wallpaperCustom : null };
    let next = ls; if (sig(eff) !== sig(lockSrc(ls))) next = Object.assign({}, ls, { wallpaper: eff.wallpaper || null, custom: eff.custom });
    const wc = s.wallpaperCustom; const homeOk = wc && wc.blur ? homeOf(next).blur : sig({ wallpaper: s.wallpaper, custom: wc || null }) === sig(homeSrc(next));
    if (!homeOk || !lw) next = Object.assign({}, next, { home: !lw ? Object.assign({}, HOME0) : homeFromState(next) });   /* sem lockWallpaper no estado os dois ecrãs são o mesmo: é um par */
    if (next !== ls && JSON.stringify(next) !== JSON.stringify(ls)) { const nl = l.slice(); nl[i] = next; save(nl); } }

  /* ---------- UI ---------- */
  function init() {
    if (root) return;
    /* "Cancelar" só existe nos editores (em cima, à esquerda; "Concluído" fica à direita, azul) - como no PearPhone.
       .lsg-duo: o ecrã principal e as legendas do escolhedor dos dois ecrãs (o ecrã bloqueado é o próprio #lock).
       .lsg-hbar/.lsg-hpanel: barra de opções do editor do principal e a paleta que abre por cima dela. .lsg-ask: "par ou personalizar?"
       PearOS 27: .lsg-top = a etiqueta por cima do cartão ("COLEÇÕES" / "ADICIONAR NOVO"), .lsg-dots = um ponto por ecrã + o do cartão "Adicionar novo". */
    root = UI.el(`<div class="lsg-root"><div class="lsg-dim"></div><div class="lsg-sides"></div><div class="lsg-duo"><div class="lsg-hcard"><div class="lsg-hbg"></div><div class="lsg-hmock"></div></div><div class="lsg-lbl l"></div><div class="lsg-lbl r"></div></div><div class="lsg-trash">${g('trash', 24)}</div><div class="lsg-top"></div><div class="lsg-dots"></div><div class="lsg-ui"><div class="lsg-cancel">${UI.esc(L.t('Cancelar'))}</div><div class="lsg-focus"></div><div class="lsg-row"><div class="lsg-custom">${UI.esc(L.t('Personalizar'))}</div><div class="lsg-add">${g('plus', 24)}</div></div></div><div class="lsg-hpanel"></div><div class="lsg-hbar"></div><div class="lsg-ask"></div></div>`);
    scr().appendChild(root); dim = root.querySelector('.lsg-dim'); sides = root.querySelector('.lsg-sides'); ui = root.querySelector('.lsg-ui'); focusBtn = root.querySelector('.lsg-focus'); customBtn = root.querySelector('.lsg-custom'); addBtn = root.querySelector('.lsg-add'); trashBtn = root.querySelector('.lsg-trash'); cancelBtn = root.querySelector('.lsg-cancel'); topEl = root.querySelector('.lsg-top'); dotsEl = root.querySelector('.lsg-dots');
    duo = root.querySelector('.lsg-duo'); hcard = root.querySelector('.lsg-hcard'); lblL = root.querySelector('.lsg-lbl.l'); lblR = root.querySelector('.lsg-lbl.r'); hbar = root.querySelector('.lsg-hbar'); hpanel = root.querySelector('.lsg-hpanel'); askEl = root.querySelector('.lsg-ask');
    customBtn.onclick = e => { e.stopPropagation(); if (homeEd) exitHome(true); else if (edit) doneEdit(); else enterPick(); };
    cancelBtn.onclick = e => { e.stopPropagation(); if (homeEd) exitHome(false); else cancelEdit(); }; cancelBtn.addEventListener('pointerdown', e => e.stopPropagation());
    addBtn.onclick = e => { e.stopPropagation(); addBtn.classList.remove('pop'); void addBtn.offsetWidth; addBtn.classList.add('pop'); setTimeout(() => { if (open && !closing) wallpaperGallery(create); }, 220); };
    focusBtn.onclick = e => { e.stopPropagation(); pickFocus(); };
    trashBtn.onclick = e => { e.stopPropagation(); removeCur(); };
    [customBtn, addBtn, focusBtn, trashBtn].forEach(b => b.addEventListener('pointerdown', e => e.stopPropagation()));
    /* escolhedor dos dois ecrãs: principal (cartão ou legenda) → editor do principal; legenda do bloqueado → editor do bloqueado; o resto do véu → galeria */
    hcard.onclick = e => { e.stopPropagation(); if (pick) enterHome(); };
    lblR.onclick = e => { e.stopPropagation(); if (pick) enterHome(); }; lblL.onclick = e => { e.stopPropagation(); if (pick) enterEdit(); };
    /* um duplo toque em Personalizar: o 2.º toque caía no véu (o botão muda de sítio no escolhedor) e voltava logo à galeria - parecia que nada acontecia */
    dim.onclick = () => { if (pick && Date.now() - pickAt > 450) exitPick(); };
    hbar.innerHTML = [['pair', 'Par', ''], ['color', 'Cor', ''], ['gradient', 'Gradiente', ''], ['photo', 'Fotos', g('photo')], ['blur', 'Desfocar', g('drop')]].map(([k, l, ic]) => `<div class="lsg-hopt k-${k}" data-k="${k}"><div class="lsg-hc">${ic}</div><span>${UI.esc(L.t(l))}</span></div>`).join('');
    hbar.onclick = e => { const o = e.target.closest('.lsg-hopt'); if (o && homeEd) homeOption(o.dataset.k); };
    bindDrag();
    /* editar: tocar no relógio / widgets / atalhos abre o painel respetivo (captura: os widgets e atalhos não fazem a sua ação normal) */
    /* moldura dos widgets vazia no modo Personalizar: "Adicionar widgets" (o CSS lê attr(data-empty); traduzível) */
    const lwEmpty = () => { const w = lockEl().querySelector('.lock-widgets'); if (w) w.dataset.empty = L.t('Adicionar widgets'); }; lwEmpty(); if (L.onChange) L.onChange(lwEmpty);
    /* na galeria NENHUM clique dentro do cartão faz a sua ação normal: fora do modo editar, um toque num widget
       (.lw → requestUnlock) abria o teclado do código por cima do cartão enquanto a galeria fechava.
       No escolhedor dos dois ecrãs o #lock É o cartão do ecrã bloqueado: um toque nele abre o editor do bloqueado. */
    /* o "menos" de um widget já posto tira-o (com a folha "Adicionar widgets" aberta ou não); tocar fora das zonas fecha a folha aberta */
    lockEl().addEventListener('click', e => { if (!open) return; e.stopPropagation(); e.preventDefault(); if (pick) { enterEdit(); return; } if (!edit) return;
      const rm = e.target.closest('.lkw-rm'); if (rm) { const k = rm.parentElement && rm.parentElement.dataset.k; if (k) { Sound.play('click'); setWidgets((cur().widgets || []).filter(x => x !== k)); } return; }
      /* PearOS 27: o "−" de um controlo do fundo tira-o (fica o "+" tracejado no lugar); a pega do relógio (.lke-handle) trata dos seus
         próprios toques (um clique depois de arrastar não pode abrir a "Fonte e cor"); a linha de baixo do editor é do LockEditor */
      const rc = e.target.closest('.ls-rm'); if (rc) { removeControl(sideOf(rc.closest('.ls-btn'))); return; }
      if (e.target.closest('.lke-handle,.lke-row')) return;
      if (e.target.closest('.lock-clockwrap')) { if (wshKind !== 'fc') editClock(); } else if (e.target.closest('.lock-shortcuts')) { const b = e.target.closest('.ls-btn'); closeWs(); editControls(sideOf(b)); } else if (e.target.closest('.lock-widgets,.lock-top')) { if (wshKind !== 'aw') editWidgets(); } else closeWs(); }, true);
    dim.addEventListener('click', () => { if (edit) closeWs(); });
    paintTop(); if (L.onChange) L.onChange(paintTop);
    LE('init', root);   /* o editor do PearOS 27 monta as peças dele (linha de baixo, pega do relógio) dentro da .lsg-root */
  }
  /* lado de um botão do fundo do ecrã (0 = esquerda, 1 = direita): data-side do lock.js; sem ele, a posição entre os irmãos */
  const sideOf = b => { if (!b) return 0; if (b.dataset.side != null && b.dataset.side !== '') return +b.dataset.side ? 1 : 0; const p = b.parentNode; return p ? Math.max(0, Math.min(1, [...p.querySelectorAll('.ls-btn')].indexOf(b))) : 0; };
  /* "−" num controlo: esse lado fica 'none' (o lock mostra o "+" tracejado no editor e nada fora dele) */
  function removeControl(side) { Sound.play('click'); if (hasLE('removeControl')) { LE('removeControl', side); return; } const ctl = (cur().controls || ['torch', 'camera']).slice(0, 2); while (ctl.length < 2) ctl.push('none'); ctl[side ? 1 : 0] = 'none'; updateCur({ controls: ctl }); }
  /* etiqueta por cima do cartão: COLEÇÕES (os ecrãs gravados) / ADICIONAR NOVO (o último cartão); maiúsculas pelo CSS, o texto traduz-se */
  function paintTop() { if (topEl) topEl.textContent = L.t(addMode ? 'Adicionar novo' : 'Coleções'); }
  /* pontos por baixo do cartão: um por ecrã + o do "Adicionar novo"; aceso = o ecrã atual, ou o último com o cartão de adicionar ao centro */
  function paintDots() { if (!dotsEl) return; const n = list().length, on = addMode ? n : curIdx(); let h = ''; for (let k = 0; k <= n; k++) h += `<i${k === on ? ' class="on"' : ''}></i>`; dotsEl.innerHTML = h; }
  function paintUI() { if (!focusBtn) return; const ls = cur(); focusBtn.innerHTML = `${g(FOCUS_ICON[ls.focus] || 'moon', 16)}<span>${UI.esc(FOCUS[ls.focus] || 'Foco')}</span>`; }   /* no Android a galeria do PearOS pode nunca ter sido construída */
  /* pré-visualização de um ecrã bloqueado (cartão lateral): cadeado + data + relógio com a fonte/peso/tamanho/cor dele + widgets.
     O fundo NÃO vai na string (ver paintBg): mockEl() pinta-o pelo CSSOM. */
  /* Nova UI: a mesma pré-visualização com o ecrã bloqueado do Android (cadeado, data, relógio empilhado, widgets e atalhos),
     para as miniaturas que as Definições pedem (thumb). As classes als-mock-* não tocam no #lock real */
  function mockA(ls) {
    const d = new Date(), h = d.getHours(), hh = UI.pad(S().clock24 === false ? ((h % 12) || 12) : h), mm = UI.pad(d.getMinutes());
    const rgb = (h2 => { const s = String(h2 || '#FFFFFF').replace('#', ''); const n = parseInt(s.length === 3 ? s.split('').map(c => c + c).join('') : s, 16); return isNaN(n) ? '255,255,255' : [(n >> 16) & 255, (n >> 8) & 255, n & 255].join(','); })(ls.clockColor);
    const f = ['default', 'rounded', 'mono', 'thin', 'bold'].includes(ls.clockFont) ? ls.clockFont : 'default';
    const IC = { weather: 'sun', battery: 'battery', calendar: 'calendar', alarm: 'alarm', reminders: 'checkCircle' };
    const ctl = aControls(ls), C = window.Lock ? Lock.CONTROLS : {};
    return `<div class="lsg-card"><div class="als-mock" data-f="${f}" data-w="${['light', 'bold'].includes(ls.clockWeight) ? ls.clockWeight : 'regular'}" data-s="${ls.clockStyle === 'outline' ? 'outline' : 'solid'}" data-a="${['left', 'right'].includes(ls.clockAlign) ? ls.clockAlign : 'center'}" data-p="${ls.clockPos === 'middle' ? 'middle' : 'top'}" data-z="${['small', 'large'].includes(ls.clockSize) ? ls.clockSize : 'normal'}" style="--clock-rgb:${rgb}">
      <div class="als-mock-lk">${g('lock')}</div><div class="als-mock-top"><div class="als-mock-dt">${UI.esc(window.L && L.code && L.code !== 'pt' && UI.wdShort ? UI.wdShort(d) + ', ' + UI.fmtDayMonth(d) : UI.DIAS_C[d.getDay()].toLowerCase() + '., ' + d.getDate() + ' de ' + UI.MESES[d.getMonth()])}</div><div class="als-mock-ck"><span>${hh}</span><span>${mm}</span></div>
      <div class="als-mock-w" data-n="${Math.min(3, (ls.widgets || []).length)}">${(ls.widgets || []).slice(0, 3).map(k => `<i>${g(IC[k] || 'grid')}</i>`).join('')}</div></div>
      <div class="als-mock-sc">${ctl.map(k => `<i class="${k === 'none' ? 'none' : ''}">${C[k] && C[k].icon ? g(C[k].icon) : ''}</i>`).join('')}</div></div></div>`;
  }
  function mock(ls) {
    if (isAnd()) return mockA(ls);
    const d = new Date(); const F = fontOf(ls.clockFont);
    /* 1.4.0: os algarismos do sistema de numeração do ecrã (Lock.clockText; ':' fica) e o tamanho contínuo (clockM: a fonte cresce até
       ×1,15 e o resto vira esticão vertical, --clock-sy no .lsg-mock → scaleY do CSS). As variáveis vão no PRÓPRIO cartão: as do
       documentElement são as do ecrã atual e o vizinho ficava com o tamanho dele. */
    const nu = ls.clockNumerals || 'latn'; let hm = UI.fmtTime(d); if (window.Lock && Lock.clockText) { try { const t = Lock.clockText(d, nu); if (typeof t === 'string' && t) hm = t; } catch (e) {} }
    const M = clockM(ls);
    const wide = hm.length > 4; const FS = +(wide ? M.fsWide : M.fs).toFixed(1);   /* "22:18" (5 caracteres): a mesma redução do relógio real (.lock-clock.wide), senão o cartão vizinho tinha a hora maior do que o atual */
    const rgb = (h => { const s = String(h || '#FFFFFF').replace('#', ''); const n = parseInt(s.length === 3 ? s.split('').map(c => c + c).join('') : s, 16); return isNaN(n) ? '255,255,255' : [(n >> 16) & 255, (n >> 8) & 255, n & 255].join(','); })(ls.clockColor);
    const opt = (k, list) => list.includes(ls[k]) ? ls[k] : CLOCK_DEF[k];   /* só valores conhecidos entram no atributo */
    const cf = F[0];   /* data-clockfont: o lockgallery.css aperta as fontes largas como o lock.css faz pelo body */
    /* fonte, peso e fator de tamanho da tabela FONTS (as mesmas regras do lock.css); widgets com a marcação do ecrã (Lock.widgets) */
    /* algarismos não latinos: a fonte da hora não os tem - as mesmas regras que o lock.css dá ao #lock (lá só valem no #lock: body[data-numerals]
       é do ecrã ATUAL): a pilha do sistema sem o aperto de 75 %, line-height .8 (a linha de base no sítio da hora ocidental) e o fator de
       largura do sistema (numFit) em em nos dígitos e nos dois pontos. No #lock esse fator SUBSTITUI o da fonte (mesmo peso, declarado
       depois) - a fonte da hora já não desenha estes dígitos - por isso aqui também substitui o F[5]. */
    const NL = nu !== 'latn', em = NL ? (+M.numFit > 0 ? +M.numFit : 1) : F[5];
    const ST = `font-size:${FS}px;font-weight:${wghtOf(ls)};${F[2]}${NL ? `;font-family:${NUM_STACK};font-stretch:normal;font-style:normal;letter-spacing:-2px;line-height:.8;align-items:center` : ''}`, sp = em !== 1 ? ` style="font-size:${em}em"` : '';
    const W = window.Lock && Lock.widgets, wl = W ? W.fit(ls.widgets).map(k => W.html(k)).join('') : '';
    return `<div class="lsg-card"><div class="lsg-mock" data-clockfont="${cf}" data-clockalign="${opt('clockAlign', ['center', 'left', 'right'])}" data-clockpos="${opt('clockPos', ['top', 'middle'])}" data-clockstyle="${opt('clockStyle', ['glass', 'solid', 'outline'])}" data-numerals="${NL ? String(nu).replace(/[^a-z]/gi, '') : 'latn'}" style="--clock-color:${ls.clockColor || '#fff'};--clock-rgb:${rgb};--clock-k:${(+M.k).toFixed(3)};--clock-kx:${(+M.kx).toFixed(3)};--clock-sy:${(+M.sy).toFixed(3)}"><div class="lock-face">${g('lock')}</div><div class="lock-date">${UI.esc(UI.fmtDate(d, false, true))}</div><div class="lock-clock${wide ? ' wide' : ''}" style="${ST}">${hm.split('').map(ch => `<span class="${ch === ':' ? 'c' : 'd'}"${sp}><span class="n">${UI.esc(ch)}</span></span>`).join('')}</div><div class="lock-widgets lkw-row">${wl}</div></div></div>`;
  }
  const mockEl = ls => { const e = UI.el(mock(ls)); paintBg(e, bgOf(lockSrc(ls))); paintCrop(e, ls.custom); return e; };
  /* ecrã principal em miniatura: CÓPIA da 1.ª página, da pesquisa e da dock do #home (ícones, pastas e widgets verdadeiros,
     na disposição do utilizador). Sem data-id/ids: nenhum querySelector do sistema (tileOf, badge, harness) pode confundir a cópia com a home real. */
  function homeClone() {
    const w = document.createElement('div'); w.className = 'lsg-hicons' + (S().showLabels === false ? ' nolabels' : ''); const home = document.getElementById('home'); if (!home) return w;
    /* dobráveis: a cópia leva as medidas da grelha que o home.js escreve no #home (célula, passo, topo, pontos...) e as classes
       dele, para a disposição ser a mesma (sem isto a grelha e os pontos ficavam com as medidas do telemóvel) */
    ['hm-fold', 'hm-two', 'hm-large'].forEach(c => { if (home.classList.contains(c)) w.classList.add(c); });   /* hm-large (1.4.0): ícones grandes do "Personalizar" do principal - a cópia também */
    ['--icon', '--gap-x', '--row-step', '--grid-w', '--page-w', '--hm-top', '--hm-x0', '--hm-cwid', '--hm-sw', '--hm-dots-y', '--hm-dgap'].forEach(k => { const v = home.style.getPropertyValue(k); if (v) w.style.setProperty(k, v); });
    /* dobráveis: as páginas à vista (Home.view), fechado uma, aberto as duas lado a lado (a da esquerda primeiro); o telemóvel
       normal mostra sempre a primeira, como antes */
    const all = [...home.querySelectorAll('.pages .page')], vw = isFold() && window.Home && Array.isArray(Home.view) && Home.view.length ? Home.view : [0];
    const pages = document.createElement('div'); pages.className = 'pages'; vw.slice(0, foldOpen() ? 2 : 1).forEach(i => { const pg = all[i] || all[0]; if (pg) pages.appendChild(pg.cloneNode(true)); }); w.appendChild(pages);
    /* PearPhone Fold: a dock vertical e a pesquisa vivem na barra direita (.rl-home, dentro do #home): vão também na cópia */
    ['.page-dots', '.search-pill', '.dock', '.rl-home'].forEach(sel => { const e = home.querySelector(sel); if (e && !(sel === '.dock' && e.closest('.rl-home'))) w.appendChild(e.cloneNode(true)); });
    w.querySelectorAll('[data-id],[data-fid],[data-wid]').forEach(n => { n.removeAttribute('data-id'); n.removeAttribute('data-fid'); n.removeAttribute('data-wid'); });
    w.querySelectorAll('[id]').forEach(n => { if (n.namespaceURI === 'http://www.w3.org/1999/xhtml') n.removeAttribute('id'); });   /* os ids dos <defs> SVG ficam: são iguais aos da home real e as referências url(#…) continuam a resolver */
    w.querySelectorAll('.pressed,.ghost,.dragging,.over').forEach(n => n.classList.remove('pressed', 'ghost', 'dragging', 'over'));
    return w; }
  /* pinta um cartão de ecrã principal (fundo do rascunho + ícones). tok: um pedido de desfoque que chegue atrasado não pinta por cima de uma escolha mais recente */
  let hTok = 0;
  function paintHome(card, ls, h, withIcons) { const bg = card.querySelector('.lsg-hbg'); const t = ++hTok; paintBg(bg, homeBg(ls, h, v => { if (t === hTok) paintBg(bg, v); })); paintCrop(bg, !h.blur ? homeSrc(ls, h).custom : null); if (withIcons) { const hm = card.querySelector('.lsg-hmock'); hm.innerHTML = ''; hm.appendChild(homeClone()); } }
  /* miniatura estática (Definições › Fundo e a pergunta do par): o ecrã inteiro 440×956 reduzido por transform, cantos proporcionais */
  function thumb(kind, ls, w) { ls = ls || cur(); w = w || 140; const k = w / 440;
    const box = UI.el(`<div class="lsg-thumb ${kind === 'home' ? 'home' : 'lock'}" style="width:${w}px;height:${Math.round(956 * k)}px;border-radius:${Math.round(57 * k)}px"><div class="lsg-thumb-in" style="transform:scale(${k.toFixed(4)})"></div></div>`); const inn = box.firstElementChild;
    if (kind === 'home') { const c = UI.el('<div class="lsg-hcard"><div class="lsg-hbg"></div><div class="lsg-hmock"></div></div>'); const bg = c.firstElementChild; paintBg(bg, homeBg(ls, homeOf(ls), v => paintBg(bg, v))); paintCrop(bg, !homeOf(ls).blur ? homeSrc(ls).custom : null); c.lastElementChild.appendChild(homeClone()); inn.appendChild(c); }
    else inn.appendChild(mockEl(ls));
    return box; }
  function paintSides() { if (!open) return; const l = list(), i = curIdx(), SP = spOf(), n = l.length; sides.innerHTML = ''; [[i - 1, -SP, 'var(--lsg-pl)'], [i + 1, SP, 'var(--lsg-pr)']].forEach(([k, pos, p]) => { if (k < 0 || k >= l.length) return; const d = UI.el(`<div class="lsg-side" data-i="${k}" style="--pos:${pos}px;--lsg-p:${p}"></div>`); d.appendChild(mockEl(l[k])); sides.appendChild(d); });
    /* PearOS 27: o cartão "Adicionar novo" vem DEPOIS do último ecrã (índice n, a (n − i) × SP do atual). Também a dois lugares de distância:
       fica fora do ecrã (o .screen recorta) mas entra com o arrasto até ao último, em vez de nascer do nada quando ele assenta */
    if (!isAnd() && n - i <= 2) { const d = UI.el(`<div class="lsg-side lsg-addcard" data-i="${n}" style="--pos:${(n - i) * SP}px;--lsg-p:${n - i === 1 ? 'var(--lsg-pr)' : '0'}"></div>`); d.appendChild(addCardEl()); sides.appendChild(d); }
    paintDots(); paintTop(); }
  /* o cartão "Adicionar novo": preto, a data e a hora em vidro cinzento (a mesma marcação dos cartões, fonte de origem) e um "+" de vidro
     CLEAR ao centro. Não é um ecrã: nunca fica "atual" (System.lockCurrent não muda); tocá-lo ao centro abre o seletor de fundos */
  function addCardEl() { const e = UI.el(mock(Object.assign({}, CLOCK_DEF, { clockFont: 'default', clockColor: '#96969B', clockSize: 'normal', clockWeight: 'regular', widgets: [] })));
    e.classList.add('lsg-addin'); e.appendChild(UI.el(`<div class="lsg-plus lg27 clear int" role="button" aria-label="${UI.esc(L.t('Adicionar novo fundo'))}">${g('plus', 30)}</div>`)); return e; }
  /* ⚠️ garantia do estado FINAL: se o relógio das transições não avançar (headless do harness; CEF com a página sem foco),
     os cartões e barras novos ficavam presos no ponto de partida (invisíveis). Depois da duração, cancelar a transição impõe o
     valor final - numa transição que já acabou isto não faz nada. */
  function settle() { clearTimeout(settleT); settleT = setTimeout(() => { const s = scr(); const lockOk = open && !closing && !drag && !s.classList.contains('lsg-anim') && !s.classList.contains('lsg-drag');   /* o #lock também (é o cartão do bloqueado), mas nunca a meio de um arrasto ou de uma troca de cartão */
    [hcard, lblL, lblR, hbar, hpanel, askEl, askEl && askEl.firstElementChild, focusBtn, topEl, dotsEl, lockOk ? lockEl() : null].concat(lockOk && sides ? [...sides.children] : []).forEach(e => {   /* + a etiqueta, os pontos e os cartões laterais (o "Adicionar novo" desliza para o centro) */ if (!e) return; const t = e.style.transition; e.style.transition = 'none'; void e.offsetWidth; e.style.transition = t; }); }, 720); }
  /* ---------- arrasto (física) ---------- */
  /* PearOS 27: para a esquerda do último ecrã já não há parede - está lá o cartão "Adicionar novo"; a parede passa a ser ele (addMode) */
  const rubber = dx => { const i = curIdx(); if (addMode) return dx < 0 ? dx * .3 : dx; if (dx > 0 && i === 0) return dx * .3; if (dx < 0 && isAnd() && i === list().length - 1) return dx * .3; return dx; };
  function setDx(dx, anim) { const s = scr(); s.classList.toggle('lsg-anim', !!anim); s.style.setProperty('--lsg-dx', dx.toFixed(1) + 'px'); const p = Math.max(-1, Math.min(1, dx / spOf())); s.style.setProperty('--lsg-ap', Math.abs(p).toFixed(3)); s.style.setProperty('--lsg-pl', Math.max(0, p).toFixed(3)); s.style.setProperty('--lsg-pr', Math.max(0, -p).toFixed(3)); }
  function bindDrag() {
    const s = scr();
    s.addEventListener('pointerdown', e => { if (!open || edit || pick || homeEd || closing || aOn) return;   /* aOn: o editor Android não tem cartões para arrastar */ if (e.target.closest('.lsg-ui,.lsg-focus,.lsg-trash,.lsg-duo,.lsg-hbar,.lsg-hpanel,.lsg-ask,.sheet-wrap,.overlay,.as-wrap')) return; if (e.button && e.pointerType === 'mouse') return; drag = { x: e.clientX, y: e.clientY, lx: e.clientX, lt: Date.now(), v: 0, dx: 0, dy: 0, axis: null, target: e.target, z: UI.zoom() }; try { s.setPointerCapture(e.pointerId); } catch (x) {} }, true);
    s.addEventListener('pointermove', e => { if (!drag) return; const z = drag.z || 1; const dx = (e.clientX - drag.x) / z, dy = (e.clientY - drag.y) / z; const now = Date.now(); drag.v = (e.clientX - drag.lx) / z / Math.max(1, now - drag.lt); drag.lx = e.clientX; drag.lt = now; drag.dx = dx; drag.dy = dy;
      if (!drag.axis && (Math.abs(dx) > 8 || Math.abs(dy) > 8)) { drag.axis = Math.abs(dx) >= Math.abs(dy) ? 'x' : 'y'; s.classList.add('lsg-drag'); }
      if (drag.axis === 'x') setDx((addMode ? -spOf() : 0) + rubber(dx)); else if (drag.axis === 'y' && !addMode) { const y = Math.max(-90, Math.min(0, dy * .5));   /* no "Adicionar novo" não há o que apagar */ s.style.setProperty('--lsg-dy', y + 'px'); trashBtn.classList.toggle('show', dy < -60); } }, true);
    const up = e => { if (!drag) return; const d = drag; drag = null; s.classList.remove('lsg-drag'); const idle = Date.now() - d.lt > 90; const v = idle ? 0 : d.v;
      if (d.axis === 'x') { s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show');   /* mudar de cartão desarma o apagar: o cartão novo não pode chegar já levantado com o caixote */ const n = list().length, i = curIdx(), w = cardW(); let go = 0; if (d.dx < -w * .25 || v < -.6) go = 1; else if (d.dx > w * .25 || v > .6) go = -1;
        /* o cartão "Adicionar novo" (índice n): para lá do último ecrã entra no modo de adicionar; de lá, para a direita volta ao ecrã atual */
        if (addMode) { if (go === -1) leaveAdd(); else setDx(-spOf(), true); return; }
        const ni = i + go; if (go === 1 && ni === n && !isAnd()) { enterAdd(); return; } if (go && ni >= 0 && ni < n) select(ni, go); else setDx(0, true); return; }
      if (d.axis === 'y' && addMode) { s.style.setProperty('--lsg-dy', '0px'); return; }
      if (d.axis === 'y') { if (d.dy < -60) { s.style.setProperty('--lsg-dy', '-64px'); trashBtn.classList.add('show'); }   /* −64 (era −40): o caixote fica DEBAIXO do cartão e acima do Personalizar, sem tocar em nenhum */ else { s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); } return; }
      /* toque: cartão lateral → escolhe-o; cartão atual ou fundo → sai */
      /* o "Adicionar novo": ao lado → vem para o centro; ao centro → abre o seletor de fundos (o mesmo do "+") */
      const side = d.target.closest('.lsg-side'); if (side) { if (side.classList.contains('lsg-addcard')) { if (addMode) openPicker(); else enterAdd(); return; } if (addMode) { leaveAdd(); return; } const k = +side.dataset.i; select(k, k > curIdx() ? 1 : -1); return; }
      if (trashBtn.classList.contains('show')) { s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); return; }
      if (addMode) { leaveAdd(); return; }   /* com o "Adicionar novo" ao centro, tocar no cartão escurecido (o atual, à esquerda) ou no véu volta ao ecrã atual - não fecha */
      close(); };
    s.addEventListener('pointerup', up, true); s.addEventListener('pointercancel', up, true);
  }
  function select(ni, dir) { const l = list(); const ls = l[ni]; if (!ls) { setDx(0, true); return; } const s = scr(); setDx(-dir * spOf(), true); customBtn.classList.add('dim'); Sound.play('click');
    /* ao assentar, o cartão volta a dx 0 já com o conteúdo novo - SEM transição: sem o .lsg-anim a regra base
       .screen.lsg #lock ainda anima o transform (.45 s) e o cartão deslizava de volta desde −362 px.
       applyLS aplica o par inteiro: escolher outro cartão muda também o fundo do ecrã principal (PearPhone). */
    setTimeout(() => { if (!open) return; const lk = lockEl(); applyLS(ls); paintSides(); s.classList.remove('lsg-anim'); lk.style.transition = 'none'; s.style.setProperty('--lsg-dx', '0px'); s.style.setProperty('--lsg-ap', '0'); s.style.setProperty('--lsg-pl', '0'); s.style.setProperty('--lsg-pr', '0'); void lk.offsetWidth; lk.style.transition = ''; customBtn.classList.remove('dim'); paintUI(); }, 380); }
  /* ---------- cartão "Adicionar novo" (PearOS 27) ----------
     O #lock (o ecrã atual) desliza para o lugar do vizinho da esquerda e escurece como ele (--lsg-dx = −SP); o cartão de adicionar,
     a +SP, fica ao centro. Classe de estado `lsg-adding` no #screen - NÃO `lsg-add`: essa é a classe do botão "+" e todas as regras
     dele (círculo de vidro de 56 px, .hide = display:none, .pop) apanhavam o ecrã inteiro. O Personalizar e o Foco escondem-se. */
  const animEnd = () => { clearTimeout(addT); addT = setTimeout(() => { if (!drag) scr().classList.remove('lsg-anim'); }, 400); };
  function enterAdd() { if (!open || edit || pick || homeEd || closing || addMode || aOn || isAnd()) return; addMode = true; const s = scr();
    s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); s.classList.add('lsg-adding'); setDx(-spOf(), true); customBtn.classList.add('hide'); focusBtn.classList.add('hide'); paintTop(); paintDots(); Sound.play('click'); animEnd(); settle(); }
  /* instant: sem animação (um ecrã novo acabou de nascer no seletor: o cartão atual já é ele e tem de estar ao centro) */
  function leaveAdd(instant) { if (!addMode) return; addMode = false; const s = scr(); s.classList.remove('lsg-adding'); if (customBtn) { customBtn.classList.remove('hide'); focusBtn.classList.remove('hide'); }
    if (instant) { const lk = lockEl(); s.classList.remove('lsg-anim'); lk.style.transition = 'none'; setDx(0); void lk.offsetWidth; lk.style.transition = ''; } else { setDx(0, true); Sound.play('click'); animEnd(); }
    paintTop(); paintDots(); settle(); }
  function openPicker() { if (open && !closing && !edit && !homeEd) wallpaperGallery(create); }
  /* ---------- abrir / fechar ---------- */
  /* Nova UI: o mesmo pedido (autenticação recente / reconhecimento facial / PIN, onde a impressão digital também serve) abre o editor Android */
  function request() { if (open || !System.locked || !window.Lock) return; const go = isAnd() ? () => aOpen() : open_; if (Lock.authedRecently()) { go(); return; } if (S().faceIdUnlock) { Lock.faceScan(go); return; } Lock.verifyPin(go); }
  function open_() { if (open || closing) return; init(); if (focusBtn.parentNode !== lockEl()) lockEl().appendChild(focusBtn);   /* o Foco vive no cartão: encolhe e arrasta com ele (PearPhone) */
    open = true; edit = false; pick = false; homeEd = null; addMode = false; customBtn.classList.remove('hide'); list(); sync(); paintLockCard(cur()); paintSides(); paintUI(); const s = scr(); s.classList.remove('lsg-adding'); s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); setDx(0); s.classList.add('lsg'); if (window.Notify) Notify.close(); Bridge.emit('overlay', 'lsg'); }
  /* aShut: o editor da Nova UI esta a sair (open continua true 360 ms). Um segundo close() nesse intervalo (Inicio, Voltar,
     bloquear, trocar de sistema logo a seguir ao Concluido) caia no fecho do PearOS sem init(): rebentava no trashBtn e
     deixava o .lsg-closing preso no ecra (o #lock::before da galeria a pintar por cima do bloqueado) */
  function close(instant) { if (aOn) { aClose(true, instant); return; } if (aShut) { if (instant) aDone(); return; } if (!open || closing) return; returnTo = null; hideAsk(); if (edit) exitEdit(true); else LE('onExitEdit'); if (homeEd) exitHome(false, true); if (pick) exitPick(true);
    if (addMode) { addMode = false; scr().classList.remove('lsg-adding'); customBtn.classList.remove('hide'); focusBtn.classList.remove('hide'); setDx(0, true); }   /* o cartão volta ao centro enquanto cresce para ecrã inteiro */
    closing = true; const s = scr(); clearTimeout(closeT); s.classList.add('lsg-closing'); s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); drag = null;
    try { if (window.UI && UI.dismissAll) UI.dismissAll(); } catch (e) {}   /* as folhas da galeria não lhe sobrevivem: o indicador passa por cima delas e fechava a galeria com a folha aberta */
    /* os botões desaparecem primeiro; 150 ms depois o cartão volta a ocupar o ecrã (remove .lsg → transição para scale 1) */
    setTimeout(() => { s.classList.remove('lsg', 'lsg-anim', 'lsg-drag'); }, instant ? 0 : 150);
    closeT = setTimeout(() => { s.classList.remove('lsg-closing'); sides.innerHTML = ''; hcard.querySelector('.lsg-hmock').innerHTML = ''; open = false; closing = false; }, instant ? 0 : 520); }   /* a cópia da home sai do DOM com a galeria */
  /* os botões mudam de sítio (Personalizar em baixo ↔ Cancelar/Concluído em cima): desvanecem em vez de saltar */
  const uiFade = () => { ui.style.transition = 'none'; ui.style.opacity = '0'; void ui.offsetWidth; ui.style.transition = ''; ui.style.opacity = ''; };
  /* aberto a partir das Definições: acabada a edição, volta-se lá (o PearPhone também volta às Definições) */
  function backToOrigin() { if (!returnTo) return; const to = returnTo; returnTo = null;
    setTimeout(() => { if (!open || edit || homeEd) return; close(); setTimeout(() => { if (System.locked && window.Lock) Lock.unlock(); setTimeout(() => System.openApp(to), 260); }, 560); }, 280); }
  /* ---------- os dois ecrãs (Personalizar) ---------- */
  /* aOn: com o editor da Nova UI aberto (open=true) a galeria do PearOS nao existe (init() nunca correu: botoes a undefined) */
  let pickAt = 0;
  function enterPick() { if (aOn || aShut || !open || edit || homeEd || pick || closing) return; leaveAdd(true); pick = true; pickAt = Date.now(); const ls = cur();
    lblL.textContent = L.t('Ecrã bloqueado'); lblR.textContent = L.t('Ecrã principal'); paintHome(hcard, ls, homeOf(ls), true);
    const s = scr(); s.classList.remove('lsg-anim'); s.style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); setDx(0); s.classList.add('lsg-pick'); Sound.play('click'); settle(); }
  function exitPick(silent) { if (!pick) return; pick = false; scr().classList.remove('lsg-pick'); if (!silent) Sound.play('click'); settle(); }
  /* isNew: o ecrã acabou de nascer no +. Aí o Cancelar APAGA-O (é o que o PearPhone faz); nos outros repõe a cópia. */
  function enterEdit(isNew) { if (aOn || aShut || !open || edit || homeEd) return; leaveAdd(true); if (pick) { pick = false; scr().classList.remove('lsg-pick'); } edit = true; editNew = !!isNew;
    /* CLOCK_DEF por baixo: um ecrã gravado antes de clockAlign/clockPos/clockStyle não tinha as chaves e o Cancelar (merge da cópia) deixava ficar o que se escolheu */
    const c = cur(); editSnap = isNew ? null : Object.assign({}, CLOCK_DEF, c, { widgets: (c.widgets || []).slice(), controls: (c.controls || []).slice() });
    scr().classList.add('lsg-edit'); customBtn.textContent = L.t('Concluído'); addBtn.classList.add('hide'); focusBtn.classList.add('hide'); uiFade(); Sound.play('click'); settle();
    LE('onEnterEdit'); }   /* PearOS 27: pega do relógio, molduras, "−" dos controlos e a linha de baixo (lockeditor.js) */
  function exitEdit(silent) { closeWs(); LE('onExitEdit'); edit = false; editSnap = null; editNew = false; scr().classList.remove('lsg-edit'); if (customBtn) { customBtn.textContent = L.t('Personalizar'); addBtn.classList.remove('hide'); focusBtn.classList.remove('hide'); uiFade(); } if (!silent) Sound.play('click'); settle(); }
  /* Concluído no editor do bloqueado: num ecrã acabado de criar o PearPhone pergunta se fica um PAR ou se se personaliza o principal */
  function doneEdit() { if (editNew) { askPair(); return; } exitEdit(); backToOrigin(); }
  function cancelEdit() {
    if (!edit) return;
    const snap = editSnap, era = editNew; exitEdit();
    if (era) { const l = list().slice(); const i = curIdx(); if (l.length > 1) { l.splice(i, 1); save(l); applyLS(l[Math.max(0, i - 1)]); paintSides(); paintUI(); } }
    else if (snap) updateCur(snap, { focus: false });
    backToOrigin();
  }
  function hideAsk() { if (askEl) { askEl.classList.remove('show'); settle(); } }
  function askPair() { const ls = cur(); askEl.innerHTML = `<div class="lsg-ask-card"><div class="lsg-ask-pv"></div><div class="lsg-ask-b k-pair">${UI.esc(L.t('Definir como par de fundos'))}</div><div class="lsg-ask-b k-home">${UI.esc(L.t('Personalizar ecrã principal'))}</div></div>`;
    const pv = askEl.querySelector('.lsg-ask-pv'); pv.appendChild(thumb('lock', ls, 112)); pv.appendChild(thumb('home', ls, 112));
    const choose = v => { if (!askEl.classList.contains('show')) return; hideAsk(); if (v === 'home') { exitEdit(true); enterHome(); } else { exitEdit(); backToOrigin(); } };
    askEl.querySelector('.k-pair').onclick = e => { e.stopPropagation(); choose('pair'); }; askEl.querySelector('.k-home').onclick = e => { e.stopPropagation(); choose('home'); };
    askEl.onclick = e => { if (e.target === askEl) choose('pair'); };   /* tocar fora = fica o par (a escolha que não muda nada) */
    askEl.onpointerdown = e => e.stopPropagation();
    void askEl.offsetWidth; askEl.classList.add('show'); Sound.play('pop'); settle(); }
  /* ---------- editor do ecrã principal ---------- */
  function enterHome() { if (aOn || aShut || !open || homeEd || edit || closing) return; const ls = cur(); const lk = lockSrc(ls); const tone = !lk.custom && Wallpapers.tone ? Wallpapers.tone(lk.wallpaper) : '#3A3A3C'; homeEd = { draft: homeOf(ls), panel: null, auto: tone };
    if (!pick || !hcard.querySelector('.lsg-hicons')) paintHome(hcard, ls, homeEd.draft, true); pick = false;
    /* a cor do próprio fundo chega do canvas depois; um rascunho que ainda estava na cor provisória acompanha-a */
    avgColor(bgOf(lk), c => { if (!homeEd || c === homeEd.auto) return; const was = homeEd.auto, d = homeEd.draft; homeEd.auto = c; if (d.mode === 'color' && d.css === was) setDraft({ css: c }); else if (d.mode === 'gradient' && d.css === gradFrom(was)) setDraft({ css: gradFrom(c) }); else { paintHbar(); if (homeEd.panel) paintPanel(); } }, tone);
    const s = scr(); s.classList.remove('lsg-pick', 'lsg-edit'); s.classList.add('lsg-home'); customBtn.textContent = L.t('Concluído'); addBtn.classList.add('hide'); focusBtn.classList.add('hide'); paintHbar(); uiFade(); Sound.play('click'); settle(); }
  /* keep=true (Concluído): grava o rascunho no ecrã e aplica-o (o principal muda já); keep=false (Cancelar): nada foi aplicado, nada a repor */
  function exitHome(keep, silent) { if (!homeEd) return; const d = homeEd.draft; homeEd = null; scr().classList.remove('lsg-home', 'lsg-hpanel-on'); hpanel.classList.remove('show'); customBtn.textContent = L.t('Personalizar'); addBtn.classList.remove('hide'); focusBtn.classList.remove('hide'); uiFade();
    if (keep) updateCur({ home: Object.assign({}, d) }); if (!silent) Sound.play('click'); settle(); if (!silent) backToOrigin(); }
  function setDraft(patch) { if (!homeEd) return; homeEd.draft = Object.assign({}, homeEd.draft, patch); paintHome(hcard, cur(), homeEd.draft, false); paintHbar(); if (homeEd.panel) paintPanel(); }
  async function homeOption(k) { const d = homeEd.draft; Sound.play('click');
    if (k === 'pair') { setDraft({ mode: 'pair', css: null, url: null, seed: null, wallpaper: null }); showPanel(null); return; }
    if (k === 'color' || k === 'gradient') { if (d.mode === k) { showPanel(homeEd.panel === k ? null : k); return; } setDraft({ mode: k, css: k === 'color' ? homeEd.auto : gradFrom(homeEd.auto), url: null, seed: null, wallpaper: null, blur: false }); showPanel(k); return; }
    if (k === 'photo') { showPanel(null); if (!window.Photos) return; const p = await Photos.pick('Fundo do ecrã principal'); if (p && homeEd) setDraft({ mode: 'photo', url: p.url || null, seed: p.url ? null : p.seed, css: null, wallpaper: null }); return; }
    if (k === 'blur') { if (!canBlur(cur(), d)) return; setDraft({ blur: !d.blur });
      /* a cópia desfocada precisa de ler os píxeis da imagem; uma imagem de fora sem CORS não deixa - diz-se e o interruptor volta atrás, em vez de ficar ligado sem efeito */
      if (!d.blur) { const u = urlOf(bgOf(homeSrc(cur(), homeEd.draft))); if (u) blurOf(u, out => { if (!out && homeEd && homeEd.draft.blur) { UI.toast('Não foi possível desfocar este fundo'); setDraft({ blur: false }); } }); } }
  }
  function paintHbar() { if (!homeEd || !hbar) return; const d = homeEd.draft, ls = cur(); const o = k => hbar.querySelector('.lsg-hopt.k-' + k);   /* prefixo k-: .photo/.home/.pair já existem noutras folhas (a grelha das Fotos pintava um quadrado atrás do círculo) */ const c = k => o(k).firstElementChild;
    ['pair', 'color', 'gradient', 'photo'].forEach(k => o(k).classList.toggle('on', d.mode === k));
    paintBg(c('pair'), bgOf(lockSrc(ls)));
    paintBg(c('color'), d.mode === 'color' && d.css ? solid(d.css) : 'conic-gradient(from 200deg,#FF375F,#FF9F0A,#FFD60A,#30D158,#64D2FF,#0A84FF,#BF5AF2,#FF375F)');
    paintBg(c('gradient'), d.mode === 'gradient' && d.css ? d.css : gradFrom(homeEd.auto));
    const ph = d.mode === 'photo' && (d.url || d.seed); paintBg(c('photo'), ph ? bgOf({ custom: { url: d.url, seed: d.url ? null : d.seed } }) : 'none'); o('photo').classList.toggle('has', !!ph);
    o('blur').classList.toggle('on', !!d.blur && canBlur(ls, d)); o('blur').classList.toggle('off', !canBlur(ls, d)); }
  function showPanel(k) { if (!homeEd) return; homeEd.panel = k; if (k) paintPanel(); hpanel.classList.toggle('show', !!k); scr().classList.toggle('lsg-hpanel-on', !!k); settle(); }   /* paleta aberta: o cartão sobe e encolhe (ela tapava a dock da pré-visualização) */
  function paintPanel() { const k = homeEd.panel, d = homeEd.draft; const auto = k === 'color' ? homeEd.auto : gradFrom(homeEd.auto); const items = [auto].concat((k === 'color' ? COLORS : GRADS).map(x => x[0]).filter(v => v.toUpperCase() !== auto.toUpperCase()));   /* 1.º círculo = a cor do fundo; sem repetidos (dois anéis acesos ao mesmo tempo) */
    hpanel.innerHTML = ''; items.forEach(v => { const b = document.createElement('b'); paintBg(b, k === 'color' ? solid(v) : v); if (d.css === v) b.className = 'on'; b.onclick = e => { e.stopPropagation(); Sound.play('click'); setDraft({ mode: k, css: v, blur: false }); }; hpanel.appendChild(b); }); }
  /* ---------- painéis de edição ---------- */
  const sect = t => UI.el(`<div class="lsg-sect">${UI.esc(t)}</div>`);
  /* def: valor que conta como escolhido quando o ecrã ainda não tem a chave (ecrãs gravados antes de ela existir) */
  function optRow(title, items, key, cls, def) { const ls = cur(); const now = ls[key] != null ? ls[key] : def; const sec = UI.el(`<div class="lsg-sec"><div class="lsg-sect">${UI.esc(title)}</div><div class="lsg-opts"></div></div>`); const o = sec.querySelector('.lsg-opts');
    items.forEach(([v, l, st]) => { const d = UI.el(`<div class="lsg-opt ${now === v ? 'on' : ''}"><div class="lsg-pv ${cls || ''}" style="${st || ''}">10:09</div><span>${UI.esc(l)}</span></div>`); d.onclick = () => { [...o.children].forEach(x => x.classList.toggle('on', x === d)); updateCur({ [key]: v }); Sound.play('click'); }; o.appendChild(d); }); return sec; }
  /* ---------- folhas do editor do bloqueado (PearOS 17): "Adicionar widgets" e "Fonte e cor" ----------
     Folha ESCURA por cima do véu (vidro = cópia pré-desfocada do fundo + tinta, sem backdrop-filter), mais baixa do que o ecrã:
     o cartão do ecrã bloqueado continua à vista em cima e mostra cada escolha AO VIVO. O invólucro não apanha toques (o "menos" dos
     widgets e o relógio do cartão continuam tocáveis); tocar fora das zonas, no véu ou no X fecha. Uma folha de cada vez. */
  let wsh = null, wshKind = null, awPaint = null;
  function closeWs() { const s = wsh; wsh = null; wshKind = null; awPaint = null; if (s && s.el && s.el.isConnected && !s.el.classList.contains('closing')) s.close(); }
  function wsheet(title, body, kind) {
    closeWs();
    const sh = UI.sheet({ title, body, cls: 'lsg-ws lsg-ws-' + kind, onClose: () => { if (wsh === sh) { wsh = null; wshKind = null; awPaint = null; } } });
    const r = sh.el.querySelector('.sh-r'); if (r) { r.innerHTML = g('x', 15); r.setAttribute('aria-label', L.t('Fechar')); }   /* o X do PearOS em vez do "OK" */
    wsh = sh; wshKind = kind;
    setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing')) sh.el.classList.add('in'); }, 80);   /* o rAF que mostra a folha nem sempre corre (CEF sem foco / headless) */
    return sh; }
  /* barra de arrastar (cor personalizada e peso): devolve 0..1; onEnd(null) = cancelado */
  function slider(bar, onMove, onEnd) { let on = false;
    const at = e => { const r = bar.getBoundingClientRect(); return Math.max(0, Math.min(1, (e.clientX - r.left) / Math.max(1, r.width))); };
    bar.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; e.stopPropagation(); on = true; try { bar.setPointerCapture(e.pointerId); } catch (x) {} onMove(at(e)); });
    bar.addEventListener('pointermove', e => { if (on) onMove(at(e)); });
    bar.addEventListener('pointerup', e => { if (!on) return; on = false; onEnd(at(e)); });
    bar.addEventListener('pointercancel', () => { if (!on) return; on = false; onEnd(null); }); }
  const thumbAt = (bar, v) => { const t = bar.firstElementChild; if (t) t.style.left = `calc(${(v * 100).toFixed(2)}% - ${(v * 26).toFixed(1)}px)`; };   /* polegar de 26 px sempre dentro da barra */
  /* cor personalizada: matiz (0..360) + tom (0 = pastel, .5 = cor pura, 1 = escura) */
  const hexOf = (r, gg, b) => '#' + [r, gg, b].map(v => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('').toUpperCase();
  function pureOf(h) { h = ((h % 360) + 360) % 360; const x = 1 - Math.abs((h / 60) % 2 - 1); const [r, gg, b] = h < 60 ? [1, x, 0] : h < 120 ? [x, 1, 0] : h < 180 ? [0, 1, x] : h < 240 ? [0, x, 1] : h < 300 ? [x, 0, 1] : [1, 0, x]; return [r * 255, gg * 255, b * 255]; }
  function htHex(h, t) { const p = pureOf(h); if (t <= .5) { const k = t * 2; return hexOf(...p.map(c => 255 + (c - 255) * k)); } const k = (t - .5) * 2 * .8; return hexOf(...p.map(c => c * (1 - k))); }
  function hexHT(hex) { const n = parseInt(String(hex || '').replace('#', ''), 16); if (isNaN(n)) return [210, .5]; const r = (n >> 16) & 255, gg = (n >> 8) & 255, b = n & 255, mx = Math.max(r, gg, b), mn = Math.min(r, gg, b), d = mx - mn;
    let h = 0; if (d) { if (mx === r) h = 60 * (((gg - b) / d) % 6); else if (mx === gg) h = 60 * ((b - r) / d + 2); else h = 60 * ((r - gg) / d + 4); }
    const t = mx >= 250 ? (1 - mn / 255) / 2 : .5 + (1 - mx / 255) / 1.6; return [(h + 360) % 360, Math.max(0, Math.min(1, t))]; }
  /* hora ao vivo enquanto se arrasta (só as variáveis CSS; o estado grava-se ao largar) */
  const liveColor = hex => { const n = parseInt(hex.slice(1), 16); const de = document.documentElement.style; de.setProperty('--clock-color', hex); de.setProperty('--clock-rgb', [(n >> 16) & 255, (n >> 8) & 255, n & 255].join(',')); };
  /* PearOS 27 (1.4.0): "Fonte e cor", "Adicionar widgets" e os controlos vivem no lockeditor.js (cartão flutuante de vidro, folha com
     pesquisa e secções por app, galeria de controlos). O corpo de sempre fica como recurso se o módulo não estiver carregado. */
  function editClock() { if (hasLE('editClock')) return LE('editClock'); const body = UI.el('<div class="lsg-panel lsg-fc"></div>');
    /* COR DA HORA: dez círculos + o arco-íris (seletor próprio: o <input type=color> não funciona no CEF) */
    body.appendChild(sect(L.t('Cor da hora')));
    const row = UI.el('<div class="lsg-fc-sw"></div>'); body.appendChild(row);
    const pk = UI.el(`<div class="lsg-fc-pk"><div class="lsg-fc-bar hue"><i></i></div><div class="lsg-fc-bar tone"><i></i></div></div>`);
    const hueBar = pk.children[0], toneBar = pk.children[1]; let H = 210, T = .5;
    const sws = SWATCHES.map(h => { const d = UI.el(`<div class="lsg-fc-c" data-c="${h}"><i></i></div>`); d.firstElementChild.style.background = h;
      d.onclick = e => { e.stopPropagation(); Sound.play('click'); pk.classList.remove('on'); updateCur({ clockColor: h }); paintSel(); }; row.appendChild(d); return d; });
    const rb = UI.el('<div class="lsg-fc-c rb"><i></i></div>'); row.appendChild(rb); body.appendChild(pk);
    const paintSel = () => { const c = String(cur().clockColor || '#FFFFFF').toUpperCase(); let hit = false; sws.forEach(d => { const on = d.dataset.c === c; d.classList.toggle('on', on); if (on) hit = true; }); rb.classList.toggle('on', !hit || pk.classList.contains('on')); };
    const paintPk = () => { const pure = hexOf(...pureOf(H)); toneBar.style.background = `linear-gradient(90deg,#FFFFFF,${pure} 50%,${htHex(H, 1)})`; thumbAt(hueBar, H / 360); thumbAt(toneBar, T);
      const c = htHex(H, T); hueBar.firstElementChild.style.background = pure; toneBar.firstElementChild.style.background = c; };
    rb.onclick = e => { e.stopPropagation(); Sound.play('click'); const was = pk.classList.contains('on'); if (!was) { [H, T] = hexHT(cur().clockColor); paintPk(); } pk.classList.toggle('on', !was); paintSel(); };
    const commitC = () => { updateCur({ clockColor: htHex(H, T) }); paintSel(); };
    slider(hueBar, v => { H = v * 360; paintPk(); liveColor(htHex(H, T)); }, v => { if (v == null) { System.setState({}, { noSave: true }); return; } commitC(); });
    slider(toneBar, v => { T = v; paintPk(); liveColor(htHex(H, T)); }, v => { if (v == null) { System.setState({}, { noSave: true }); return; } commitC(); });
    paintSel();
    /* FONTE DA HORA: grelha de 3 colunas com "12" em cada fonte; a escolhida fica numa pílula mais escura. As amostras são
       estilos fixos da tabela FONTS (nada vem do jogador). O nome vai escondido (leitores de ecrã e testes). */
    body.appendChild(sect(L.t('Fonte da hora')));
    const fg = UI.el('<div class="lsg-fc-grid"></div>'); body.appendChild(fg);
    const ftiles = FONTS.map(f => { const t = UI.el(`<div class="lsg-opt lsg-fc-f" data-f="${f[0]}" aria-label="${UI.esc(L.t(f[1]))}"><b>12</b><span class="lsg-fc-fn">${UI.esc(L.t(f[1]))}</span></div>`); t.firstElementChild.style.cssText = `${f[2]};font-weight:${f[4]}`;
      t.onclick = e => { e.stopPropagation(); Sound.play('click'); updateCur({ clockFont: f[0], clockWght: null, clockWeight: 'regular' }); paintF(); }; fg.appendChild(t); return t; });
    /* peso: só nas fontes variáveis (Bahnschrift, Inter, Outfit); A pequeno à esquerda, A grande à direita, como no PearOS */
    const wr = UI.el(`<div class="lsg-fc-w"><span class="a">A</span><div class="lsg-fc-bar wt"><i></i></div><span class="b">A</span></div>`); body.appendChild(wr);
    const wBar = wr.querySelector('.wt'); let wNow = 600;
    const rng = () => fontOf(cur().clockFont)[3];
    const paintF = () => { const ls = cur(), F = fontOf(ls.clockFont), id = F[0] === 'thin' ? 'default' : F[0]; ftiles.forEach(t => t.classList.toggle('on', t.dataset.f === id));
      const R = F[3]; wr.classList.toggle('off', !R); if (R) { wNow = Math.max(R[0], Math.min(R[1], wghtOf(ls))); thumbAt(wBar, (wNow - R[0]) / (R[1] - R[0])); } };
    const liveW = w => { document.body.dataset.clockwght = '1'; document.documentElement.style.setProperty('--clock-wght', String(w)); };
    slider(wBar, v => { const R = rng(); if (!R) return; wNow = Math.round(R[0] + v * (R[1] - R[0])); thumbAt(wBar, v); liveW(wNow); },
      v => { const R = rng(); if (!R) return; if (v == null) { System.setState({}, { noSave: true }); paintF(); return; } updateCur({ clockWght: wNow, clockWeight: wNow <= 350 ? 'light' : wNow >= 700 ? 'bold' : 'regular' }); });
    paintF();
    /* o resto da apresentação da hora (as mesmas chaves de sempre) */
    body.appendChild(optRow(L.t('Tamanho'), [['small', L.t('Pequeno'), 'font-size:22px'], ['normal', L.t('Normal'), 'font-size:28px'], ['large', L.t('Grande'), 'font-size:34px']], 'clockSize'));
    /* as pré-visualizações destes três são estilos inline de strings fixas (nada vem do jogador) */
    body.appendChild(optRow(L.t('Estilo'), [['glass', L.t('Vidro'), 'color:rgba(255,255,255,.62)'], ['solid', L.t('Sólido'), 'color:#fff'], ['outline', L.t('Contorno'), 'color:transparent;-webkit-text-stroke:1.4px #fff;font-family:Arial,sans-serif;font-stretch:normal']], 'clockStyle', '', CLOCK_DEF.clockStyle));
    body.appendChild(optRow(L.t('Alinhamento'), [['left', L.t('Esquerda'), 'justify-content:flex-start;padding-left:10px;font-size:22px'], ['center', L.t('Centro'), 'font-size:22px'], ['right', L.t('Direita'), 'justify-content:flex-end;padding-right:10px;font-size:22px']], 'clockAlign', '', CLOCK_DEF.clockAlign));
    body.appendChild(optRow(L.t('Posição'), [['top', L.t('Em cima'), 'align-items:flex-start;padding-top:6px;font-size:20px'], ['middle', L.t('Ao meio'), 'font-size:20px']], 'clockPos', '', CLOCK_DEF.clockPos));
    wsheet(L.t('Fonte e cor'), body, 'fc'); }
  /* widgets da Nova UI (aWidgets, Android): a lista de sempre */
  const WIDGETS = [['weather', 'Meteorologia', 'sun'], ['battery', 'Bateria', 'battery'], ['calendar', 'Calendário', 'calendar'], ['alarm', 'Alarme', 'alarm'], ['reminders', 'Lembretes', 'checkCircle']];
  /* a lista do ecrã atual muda: grava (aplica ao vivo no cartão) e repinta os quadrados da folha, se estiver aberta */
  function setWidgets(list) { updateCur({ widgets: list.slice() }); if (awPaint) awPaint(); }
  /* "Adicionar widgets" (PearOS 17): pré-visualizações com os dados verdadeiros, em quadrados de vidro escuro; grelha de 4
     colunas (redondo = 1 lugar, retangular = 2, como na linha do ecrã). Tocar põe o widget na linha se couber; tocar num que já
     lá está tira-o; no cartão, o "menos" de cada widget também o tira. Os quadrados constroem-se uma vez; só mudam classes. */
  function editWidgets() { if (hasLE('editWidgets')) return LE('editWidgets'); const W = window.Lock && Lock.widgets; if (!W) return;
    const body = UI.el('<div class="lsg-panel lsg-aw"></div>'); body.appendChild(sect(L.t('Widgets')));
    const gr = UI.el('<div class="lsg-aw-grid"></div>'); body.appendChild(gr);
    const used = l => l.reduce((a, k) => a + W.slot(k), 0);
    const tiles = W.list().map(w => { const t = UI.el(`<div class="lsg-aw-t ${w.kind === 'r' ? 'r' : 'c'}" data-k="${w.k}" aria-label="${UI.esc(L.t(w.name))}"><div class="lsg-aw-pv">${W.html(w.k)}</div><i class="lsg-aw-ck">${g('check', 12)}</i></div>`);
      t.onclick = e => { e.stopPropagation(); const now = W.fit(cur().widgets || []);
        if (now.includes(w.k)) { Sound.play('click'); setWidgets(now.filter(x => x !== w.k)); return; }
        if (used(now) + W.slot(w.k) > W.SLOTS) { t.classList.remove('shake'); void t.offsetWidth; t.classList.add('shake'); Sound.play('error'); UI.toast(L.t('Sem espaço: retira um widget primeiro')); return; }
        Sound.play('click'); setWidgets(now.concat(w.k)); };
      gr.appendChild(t); return t; });
    body.appendChild(UI.el(`<div class="group-footer lsg-aw-foot">${UI.esc(L.t('Os widgets ficam por baixo da hora, até 4 lugares. Toca num widget já posto para o retirar.'))}</div>`));
    wsheet(L.t('Adicionar widgets'), body, 'aw');
    awPaint = () => { const now = W.fit(cur().widgets || []), u = used(now); tiles.forEach(t => { const k = t.dataset.k, on = now.includes(k); t.classList.toggle('on', on); t.classList.toggle('full', !on && u + W.slot(k) > W.SLOTS); }); };
    awPaint(); }
  /* side: o botão tocado (0 esquerda / 1 direita) - a galeria de controlos do PearOS 27 abre para esse lado */
  function editControls(side) { if (hasLE('editControls')) return LE('editControls', side ? 1 : 0); const C = Lock.CONTROLS; const keys = ['torch', 'camera', 'timer', 'calc', 'notes', 'alarm', 'music', 'none']; const body = UI.el('<div class="lsg-panel"></div>');
    ['Controlo da esquerda', 'Controlo da direita'].forEach((t, side) => { const sec = UI.el('<div class="lsg-sec"></div>'); sec.appendChild(sect(t)); const gr = UI.el('<div class="lsg-wgrid"></div>');
      keys.forEach(k => { const c = C[k]; const d = UI.el(`<div class="lsg-wcard ${cur().controls[side] === k ? 'on' : ''}"><div class="lsg-wic">${g(c.icon || 'x', 22)}</div><span>${UI.esc(c.label)}</span><i>${g('check', 17)}</i></div>`); d.onclick = () => { const ctl = cur().controls.slice(); ctl[side] = k; updateCur({ controls: ctl }); [...gr.children].forEach((x, i) => x.classList.toggle('on', keys[i] === k)); Sound.play('click'); }; gr.appendChild(d); });
      sec.appendChild(gr); body.appendChild(sec); });
    UI.sheet({ title: 'Controlos', right: 'OK', body }); }
  async function pickFocus() { const v = await UI.actionSheet({ title: 'Foco', buttons: FOCUS_MODES.map(k => ({ label: k === 'none' ? 'Sem foco' : FOCUS[k], value: k, icon: FOCUS_ICON[k] })) }); if (v == null) return; updateCur({ focus: v }); }
  /* ---------- novo fundo ---------- */
  /* o ecrã novo herda relógio, widgets e controlos do atual e nasce como PAR: escolher um fundo muda os DOIS ecrãs */
  function createDetached(patch) { const l = list().slice(); const base = cur(); const ls = Object.assign(fromState(), { id: uid(), widgets: base.widgets.slice(), controls: base.controls.slice(), focus: 'none', home: Object.assign({}, HOME0) }, patch); l.push(ls); save(l); applyLS(ls); Sound.play('pop'); return ls; }
  function create(patch) { leaveAdd(true); createDetached(patch); paintSides(); paintUI();   /* escolhido no "Adicionar novo": sai-se desse modo primeiro (o ecrã novo é o atual, ao centro) */
    setTimeout(() => { if (open && !closing) enterEdit(true); }, 320); }   /* PearPhone: escolher o fundo entra logo em personalizar o ecrã novo (o Cancelar apaga-o; o Concluído pergunta pelo par) */
  /* ---------- IMAGEM POR LINK / COLAR (1.1.4, "upload image") ----------
     Não há seletor de ficheiros no CEF do FiveM (um <input type=file> não abre nada), por isso o caminho é COLAR: um link
     direto para a imagem (Discord, Imgur, Fivemanage…) ou uma imagem copiada (Ctrl+V dentro do campo), que é reduzida como
     uma foto e guardada nas Fotos. O link só é aceite depois de a imagem carregar mesmo (pré-visualização). O fundo fica
     como { custom: { url } }: o mesmo formato dos fundos "Das Fotos", por isso tudo o resto (galeria, editor, blur) já o
     entende. Config.WallpaperLinks (ready → System.config.wallpaperLinks): enabled / hosts / maxLength / paste. */
  /* key: 'wallpaperLinks' (fundos, por omissão) ou 'photoLinks' (Fotos › Adicionar por link, Config.PhotoLinks); sem a chave pedida
     no System.config vale o wallpaperLinks - o mesmo recuo do client/main.lua para um config.lua sem Config.PhotoLinks */
  const linkCfg = key => { const C = (window.System && System.config) || {}; return Object.assign({ enabled: true, hosts: [], maxLength: 512, paste: true }, C[key || 'wallpaperLinks'] || C.wallpaperLinks || {}); };
  function checkLink(u, cfg) {
    cfg = cfg || linkCfg(); u = String(u || '').trim();
    if (!u) return { error: '' };
    if (/^data:image\/(jpeg|jpg|png|webp|gif);base64,/i.test(u)) return u.length <= 260000 ? { url: u } : { error: L.t('A imagem colada é demasiado grande') };
    if (!/^https?:\/\//i.test(u)) return { error: L.t('O link tem de começar por https://') };
    if (u.length > (+cfg.maxLength || 512) || /[\s"'<>\\]/.test(u)) return { error: L.t('Esse link não parece válido') };
    const hosts = Array.isArray(cfg.hosts) ? cfg.hosts.filter(h => typeof h === 'string' && h) : [];
    if (hosts.length) { let host = ''; try { host = new URL(u).hostname.toLowerCase(); } catch (e) { return { error: L.t('Esse link não parece válido') }; }
      if (!hosts.some(h => { h = h.toLowerCase(); return host === h || host.endsWith('.' + h); })) return { error: L.t('Este servidor não permite links deste site') }; }
    return { url: u };
  }
  function loadImg(u) { return new Promise(res => { let done = false; const fin = v => { if (done) return; done = true; res(v); }; const t = setTimeout(() => fin(false), 12000); const im = new Image(); im.onload = () => { clearTimeout(t); fin(!!(im.naturalWidth || im.width)); }; im.onerror = () => { clearTimeout(t); fin(false); }; im.src = u; }); }
  /* opts (a mesma folha serve as Fotos, para não haver duas cópias): { title, button, footer, cfg ('wallpaperLinks' | 'photoLinks' | objeto),
     pasteDone } - com pasteDone uma imagem COLADA fica logo guardada nas Fotos e a folha fecha (onPick(patch, { pasted: true, photo })):
     na app Fotos o destino É a galeria, não fazia sentido pedir ainda um "Guardar" a quem acabou de a ver guardada. */
  function linkSheet(onPick, opts) {
    opts = opts || {};
    const cfg = opts.cfg && typeof opts.cfg === 'object' ? opts.cfg : linkCfg(opts.cfg);
    if (cfg.enabled === false) { UI.toast(L.t('Os links de imagem estão desligados neste servidor')); return null; }
    const body = UI.el(`<div class="lsg-panel lsg-link">
      <div class="lsg-link-row"><input class="lsg-link-in" type="url" spellcheck="false" autocapitalize="off" autocomplete="off" placeholder="${UI.esc(L.t('Cola aqui o link da imagem (Discord, Imgur…)'))}"><div class="lsg-link-paste" role="button">${g('clipboard', 18)}<span>${UI.esc(L.t('Colar'))}</span></div></div>
      <div class="lsg-link-pv"><div class="lsg-link-img"></div><div class="lsg-link-msg">${UI.esc(L.t('Pré-visualização'))}</div></div>
      <div class="btn-p lsg-link-use dis">${UI.esc(L.t(opts.button || 'Usar como fundo'))}</div>
      <div class="group-footer lsg-link-foot">${UI.esc(L.t(opts.footer || 'Links de anexos do Discord expiram ao fim de 24 h: se o fundo desaparecer, cola um link novo.'))}${cfg.paste !== false ? ' ' + UI.esc(L.t('Também podes colar uma imagem copiada (Ctrl+V): fica guardada nas Fotos.')) : ''}</div>
    </div>`);
    const inp = body.querySelector('.lsg-link-in'), img = body.querySelector('.lsg-link-img'), msg = body.querySelector('.lsg-link-msg'), use = body.querySelector('.lsg-link-use');
    let cur = null, seq = 0, busy = false;
    const setMsg = (t, bad) => { msg.textContent = t || ''; msg.classList.toggle('bad', !!bad); msg.style.display = t ? '' : 'none'; };
    const show = u => { paintBg(img, `url('${String(u).replace(/'/g, '%27')}')`); img.classList.add('has'); };
    const clear = () => { cur = null; img.classList.remove('has'); img.style.backgroundImage = ''; use.classList.add('dis'); };
    async function tryUrl(raw) {
      const my = ++seq; const r = checkLink(raw, cfg);
      if (r.error !== undefined) { clear(); setMsg(r.error || L.t('Pré-visualização'), !!r.error); return; }
      clear(); setMsg(L.t('A carregar…'));
      const ok = await loadImg(r.url); if (my !== seq) return;
      if (!ok) { setMsg(L.t('Não foi possível carregar essa imagem. Confirma que o link abre a imagem diretamente.'), true); return; }
      cur = r.url; show(cur); setMsg(''); use.classList.remove('dis');
    }
    let deb = 0; inp.addEventListener('input', () => { clearTimeout(deb); deb = setTimeout(() => tryUrl(inp.value), 350); });
    inp.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); clearTimeout(deb); tryUrl(inp.value); } });
    /* colar: texto (link) segue pelo 'input'; uma IMAGEM copiada é reduzida como uma foto e guardada nas Fotos */
    inp.addEventListener('paste', async e => {
      const dt = e.clipboardData; if (!dt) return;
      const f = [...(dt.files || [])].find(x => /^image\//.test(x.type)) || [...(dt.items || [])].filter(i => i.kind === 'file' && /^image\//.test(i.type)).map(i => i.getAsFile()).find(Boolean);
      if (!f) return;
      e.preventDefault();
      if (cfg.paste === false || !window.Photos) { setMsg(L.t('Os links de imagem estão desligados neste servidor'), true); return; }
      if (busy) return; busy = true; clear(); setMsg(L.t('A carregar…'));
      try {
        const src = await new Promise(res => { const fr = new FileReader(); fr.onload = () => res(typeof fr.result === 'string' ? fr.result : null); fr.onerror = () => res(null); fr.readAsDataURL(f); });
        const small = src ? await Photos.shrink(src, 1400, null) : null;   /* sem recorte: o fundo é a imagem inteira */
        if (!small || small === Photos.BLACK) { setMsg(L.t('Não foi possível ler a imagem colada'), true); return; }
        const p = await Photos.save(small, {});
        if (!p || p.error) { setMsg(L.t('Não foi possível ler a imagem colada'), true); return; }
        /* a imagem acabada de subir já está aqui: fica na linha nova da cache (como a Câmara faz), senão a galeria voltava a descarregá-la */
        try { await Photos.load(); const row = Photos.cache.find(x => x && x.id === p.id); if (row && !row.url) row.url = small; } catch (e) {}
        Bridge.emit('photos');
        if (opts.pasteDone) { sh.close(); onPick({ wallpaper: null, custom: { url: small } }, { pasted: true, photo: p }); return; }   /* Fotos: já está na galeria, acabou */
        UI.toast(L.t('Imagem colada guardada nas Fotos'));
        cur = small; show(cur); setMsg(''); use.classList.remove('dis'); inp.value = '';
      } finally { busy = false; }
    });
    body.querySelector('.lsg-link-paste').onclick = async () => { Sound.play('click');
      try { const t = navigator.clipboard && navigator.clipboard.readText ? await navigator.clipboard.readText() : ''; if (t && t.trim()) { inp.value = t.trim(); tryUrl(inp.value); return; } } catch (e) {}
      try { inp.focus(); } catch (e) {} UI.toast(L.t('Usa Ctrl+V no campo para colar')); };
    use.onclick = () => { if (!cur || use.classList.contains('dis')) return; Sound.play('click'); const u = cur; sh.close(); onPick({ wallpaper: null, custom: { url: u } }, { pasted: false }); };
    const sh = UI.sheet({ title: L.t(opts.title || 'Adicionar imagem por link'), right: L.t('Cancelar'), body, cls: 'lsg-sheet lsg-link-sheet' });
    setTimeout(() => { try { inp.focus(); } catch (e) {} }, 350);
    return sh;
  }
  /* as Definições: o fundo do link nasce como PAR (bloqueado + principal), como o "Adicionar novo fundo" */
  function addFromLink(done) { return linkSheet(patch => { const ls = createDetached(patch); if (done) done(ls); }); }
  /* "Adicionar novo fundo" (PearOS 17 → 27): categorias em círculo, depois secções com miniaturas na proporção do ecrã e o relógio por cima.
     onPick(patch) recebe { wallpaper, custom } - a galeria cria e edita o ecrã; as Definições criam e aplicam logo.
     1.4.0: as categorias que diziam "em breve" criam fundos dos tipos novos (wallpapers27.js). Aleatórias / Emoji / Astronomia / Cor abrem a
     sub-folha do LockEditor POR CIMA desta (ela só fecha quando a sub-folha escolher: recebe o choose); sem o LockEditor escolhe-se logo a
     predefinição. Depois das Fotos, uma linha de pré-visualização por tipo. Sem o wallpapers27.js (ou no Android) fica o seletor de sempre. */
  /* opts.title: o editor usa a mesma folha para MUDAR o fundo do ecrã que está a editar ('Mudar fundo'), não para criar um novo */
  function wallpaperGallery(onPick, opts) { let sh = null; const body = UI.el('<div class="lsg-panel lsg-picker"></div>'); const d = new Date(); const hm = UI.fmtTime(d); const dt = UI.fmtWdDayMon ? UI.fmtWdDayMon(d) : `${UI.DIAS_C[d.getDay()]}, ${d.getDate()} ${UI.MESES[d.getMonth()].slice(0, 3)}`;
    const WK = !isAnd() && window.WallKinds && typeof WallKinds.css === 'function' ? WallKinds : null; const P = (WK && WK.presets) || {};
    const choose = patch => { if (sh) sh.close(); onPick(typeof patch === 'function' ? patch() : patch); };   /* uma função calcula o fundo no toque (a foto das aleatórias depende das Fotos já carregadas) */
    const kcss = c => { try { return WK.css(c) || 'none'; } catch (e) { setTimeout(() => { throw e; }); return 'none'; } };
    const kTiles = [];   /* miniaturas dos tipos: as de canvas (emoji) nascem com a cor de fundo e repintam-se no 'wallkind:ready' */
    const tile = (bg, name, patch, kc) => { const e = UI.el(`<div class="lsg-wpi"><div class="lsg-wp"><div class="lsg-wp-t"><span>${UI.esc(dt)}</span><b>${UI.esc(hm)}</b></div></div>${name ? `<span class="lsg-wp-n">${UI.esc(name)}</span>` : ''}</div>`); paintBg(e.firstElementChild, bg); if (kc) kTiles.push([e.firstElementChild, kc]); e.onclick = () => { Sound.play('click'); choose(patch); }; return e; };
    const repaintK = () => kTiles.forEach(([el, kc]) => { if (el.isConnected) paintBg(el, kcss(kc())); });
    const row = (title, items) => { if (!items.length) return null; const sec = UI.el(`<div class="lsg-psec"><div class="lsg-ptitle">${UI.esc(title)}</div><div class="lsg-prow"></div></div>`); const r = sec.lastElementChild; items.forEach(x => r.appendChild(x)); body.appendChild(sec); return sec; };
    const fromPhotos = async () => { if (sh) sh.close(); if (!window.Photos) return; const p = await Photos.pick('Escolher fundo'); if (p) onPick({ wallpaper: null, custom: { url: p.url || null, seed: p.url ? null : p.seed } }); };
    /* "upload image": link direto ou imagem colada (ver linkSheet); só aparece com Config.WallpaperLinks.enabled */
    const fromLink = () => { if (sh) sh.close(); linkSheet(onPick); };
    const linkCat = linkCfg().enabled !== false ? [['link', 'Link', 'linear-gradient(145deg,#34C759,#30B0C7)', fromLink]] : [];
    /* aleatórias: a predefinição já AVANÇADA para uma foto (cur) - senão o ecrã nascia sem foto até à primeira troca */
    const shuffleC = () => { const p = Object.assign({ from: 'all', every: 'hour' }, P.shuffle || {}, { kind: 'shuffle' }); try { return (WK.advance && WK.advance(p)) || p; } catch (e) { return p; } };
    const via = (fn, def) => () => { if (hasLE(fn)) LE(fn, choose); else choose(def); };
    const emoji0 = () => ({ wallpaper: null, custom: Object.assign({ set: ['\u{1F600}'], layout: 'grid', bg: '#FFD60A' }, (P.emoji || [])[0] || {}, { kind: 'emoji' }) });
    const cats = UI.el('<div class="lsg-cats"></div>'); let colorSec = null;
    const CONIC = 'conic-gradient(from 200deg,#FF375F,#FF9F0A,#FFD60A,#30D158,#64D2FF,#0A84FF,#BF5AF2,#FF375F)';
    const kindCats = WK ? [['layers', 'Aleatórias', 'linear-gradient(145deg,#FF6482,#FF375F)', via('pickShuffle', () => ({ wallpaper: null, custom: shuffleC() }))], ['smile', 'Emoji', 'linear-gradient(145deg,#FFD60A,#FF9F0A)', via('pickEmoji', emoji0)],
      ['cloudSun', 'Meteorologia', 'linear-gradient(145deg,#64D2FF,#30B0C7)', () => choose({ wallpaper: null, custom: { kind: 'weather' } })], ['sparkles', 'Astronomia', 'linear-gradient(145deg,#3A3A6A,#0B0B24)', via('pickAstro', () => ({ wallpaper: null, custom: { kind: 'astro', body: 'earth' } }))],
      ['drop', 'Cor', CONIC, via('pickColor', () => ({ wallpaper: null, custom: { kind: 'color', hue: 210, style: 'vibrant' } }))]]
      : [['drop', 'Cor', CONIC, () => { if (colorSec) colorSec.scrollIntoView({ behavior: 'smooth', block: 'start' }); }]];
    [['photo', 'Fotos', 'linear-gradient(145deg,#5AC8FA,#0A84FF)', fromPhotos]].concat(linkCat, kindCats).forEach(([ic, l, bg, fn]) => {
      const c = UI.el(`<div class="lsg-cat"><div class="lsg-cat-c">${g(ic, 24)}</div><span>${UI.esc(L.t(l))}</span></div>`); paintBg(c.firstElementChild, bg); c.onclick = () => { Sound.play('click'); fn(); }; cats.appendChild(c); });
    body.appendChild(cats);
    /* Em destaque primeiro: são os fundos oficiais (e a 2.ª miniatura continua a ser o 2.º fundo, que é o que o harness escolhe) */
    row(L.t('Em destaque'), Wallpapers.list().map(w => tile(w.css, w.name, { wallpaper: w.id, custom: null })));
    const photoSec = row(L.t('Fotos'), [UI.el(`<div class="lsg-wpi more"><div class="lsg-wp"><div class="lsg-wp-add">${g('photo', 26)}<span>${UI.esc(L.t('Todas as fotos'))}</span></div></div></div>`)]);
    const more = photoSec.querySelector('.more'); more.onclick = () => { Sound.play('click'); fromPhotos(); };
    const fillPhotos = () => { const pc = (window.Photos && Photos.cache) || []; const r = photoSec.lastElementChild; r.querySelectorAll('.lsg-wpi:not(.more)').forEach(x => x.remove()); pc.slice(0, 12).forEach(p => r.insertBefore(tile(Photos.bg ? Photos.bg(p) : bgOf({ custom: { url: p.url, seed: p.seed } }), '', { wallpaper: null, custom: { url: p.url || null, seed: p.url ? null : p.seed } }), more)); };
    fillPhotos(); if (window.Photos && Photos.load && !(Photos.cache || []).length) Promise.resolve(Photos.load()).then(() => { fillPhotos(); repaintK(); }).catch(() => {});   /* a miniatura das aleatórias também depende das Fotos */
    /* pré-visualizações dos tipos (o toque escolhe logo esta variante; a categoria lá em cima abre as opções todas) */
    if (WK) { const kt = (c, name) => tile(kcss(c), name, { wallpaper: null, custom: c }, () => c);
      row(L.t('Aleatórias'), [tile(kcss(shuffleC()), L.t('Fotos aleatórias'), () => ({ wallpaper: null, custom: shuffleC() }), shuffleC)]);
      row(L.t('Meteorologia'), [kt({ kind: 'weather' }, L.t('Tempo atual'))]);
      const AN = { earth: 'Terra', moon: 'Lua', mars: 'Marte', solar: 'Sistema solar' };
      row(L.t('Astronomia'), (Array.isArray(P.astro) && P.astro.length ? P.astro : Object.keys(AN)).map(b => kt({ kind: 'astro', body: b }, L.t(AN[b] || String(b)))));
      row(L.t('Emoji'), (Array.isArray(P.emoji) ? P.emoji : []).slice(0, 6).map(e => kt(Object.assign({}, e, { kind: 'emoji' }), '')));
      const CN = { vibrant: 'Vibrante', tone: 'Tonal', deep: 'Profunda', vapor: 'Vapor', bright: 'Brilhante' };
      row(L.t('Cor'), (Array.isArray(P.color) && P.color.length ? P.color : Object.keys(CN)).map(st => kt({ kind: 'color', hue: 210, style: st }, L.t(CN[st] || String(st))))); }
    colorSec = row(L.t('Cores'), COLORS.map(([c, n]) => tile(solid(c), L.t(n), { wallpaper: null, custom: { css: c } })));
    row(L.t('Gradientes'), GRADS.map(([c, n]) => tile(c, L.t(n), { wallpaper: null, custom: { css: c } })));
    body.appendChild(UI.el(`<div class="group-footer lsg-pfoot">${UI.esc(L.t('O fundo escolhido fica no ecrã bloqueado e no ecrã principal. Depois podes personalizar cada um.'))}</div>`));
    const offK = WK && Bridge.on ? Bridge.on('wallkind:ready', repaintK) : null;
    sh = UI.sheet({ title: L.t((opts && opts.title) || 'Adicionar novo fundo'), right: L.t('Cancelar'), body, cls: 'lsg-sheet', onClose: () => { if (typeof offK === 'function') offK(); } });
    setTimeout(() => { if (sh.el.isConnected && !sh.el.classList.contains('closing')) sh.el.classList.add('in'); }, 80);   /* o rAF que mostra a folha nem sempre corre (CEF sem foco / headless): o mesmo estado final, garantido */
    return sh; }
  async function removeCur() { const l = list(); const reset = () => { scr().style.setProperty('--lsg-dy', '0px'); trashBtn.classList.remove('show'); };
    if (l.length <= 1) { UI.toast('Não podes apagar o único ecrã bloqueado'); reset(); return; }
    if (!(await UI.confirm('Apagar ecrã bloqueado', 'Este ecrã bloqueado e a sua personalização vão ser removidos.', 'Apagar', true))) { reset(); return; }
    const i = curIdx(); const s = scr(); trashBtn.classList.remove('show'); s.classList.add('lsg-remove'); Sound.play('click');
    setTimeout(() => { const nl = l.filter((_, k) => k !== i); save(nl); const ni = Math.min(i, nl.length - 1); s.classList.remove('lsg-remove'); s.style.setProperty('--lsg-dy', '0px'); applyLS(nl[ni]); paintSides(); paintUI(); }, 320); }
  /* ================= NOVA UI 8.5: EDITOR DO ECRÃ BLOQUEADO (Android) =================
     A Nova UI não tem a galeria de ecrãs do PearOS: o toque longo (com autenticação) abre logo o ecrã bloqueado em modo de
     edição, em tamanho real, com as zonas editáveis contornadas (relógio, widgets, atalhos) e "Cancelar" / "Concluído" em
     cima. Tocar numa zona abre a folha de baixo com as opções dela (estilos de relógio, cores, tamanho, posição; widgets;
     atalhos da esquerda e da direita); o botão "Fundo" muda o fundo. As escolhas aplicam-se ao vivo, nas MESMAS chaves do
     estado (é o ecrã atual de lockScreens que muda, pelo updateCur), e o Cancelar repõe a cópia tirada à entrada.
     Classes als-ed-* (a página é uma só). Só transform/opacity animam; sem backdrop-filter (a folha é opaca). */
  const isAnd = () => !!(window.System && System.os === 'android');
  let aRoot = null, aOn = false, aSnap = null, aPanel = null, aSide = 0, aCloseT = null, aShut = false;
  /* estilos do relógio da Nova UI = combinações das chaves que já existem (fonte + estilo) */
  const A_STYLES = [['nova', 'Nova', 'default', 'solid'], ['fina', 'Fina', 'thin', 'solid'], ['negrito', 'Negrito', 'bold', 'solid'], ['arred', 'Arredondado', 'rounded', 'solid'], ['mono', 'Mono', 'mono', 'solid'], ['contorno', 'Contorno', 'default', 'outline']];
  const A_COLORS = ['#FFFFFF', '#FFD60A', '#FF9F0A', '#FF375F', '#BF5AF2', '#64D2FF', '#30D158', '#000000'];
  const A_CTL = ['phone', 'camera', 'torch', 'timer', 'calc', 'notes', 'alarm', 'music', 'none'];
  const aStyleOf = ls => { if (ls.clockStyle === 'outline') return 'contorno'; const s = A_STYLES.find(x => x[2] === (ls.clockFont || 'default') && x[3] === 'solid'); return s ? s[0] : 'nova'; };
  /* os atalhos que o ecrã tem de facto no Android (a predefinição do PearOS lê-se como Telefone + Câmara, como no lock.js) */
  const aControls = ls => { const c = Array.isArray(ls.controls) && ls.controls.length === 2 ? ls.controls.slice() : ['phone', 'camera']; return c[0] === 'torch' && c[1] === 'camera' && ls.ctlOS !== 'android' ? ['phone', 'camera'] : c; };
  function aInit() {
    if (aRoot) return;
    aRoot = UI.el(`<div class="als-ed"><div class="als-ed-top"><div class="als-ed-b als-ed-cancel"></div><div class="als-ed-b als-ed-done"></div></div>
      <div class="als-ed-wall"><div class="als-ed-wbtn">${g('photo', 20)}<span></span></div></div>
      <div class="als-ed-sheet"><div class="als-ed-grab"></div><div class="als-ed-head"><b></b><div class="als-ed-ok"></div></div><div class="als-ed-body"></div></div></div>`);
    scr().appendChild(aRoot);
    aLabels(); if (L.onChange) L.onChange(aLabels);
    const stop = e => e.stopPropagation();
    aRoot.querySelectorAll('.als-ed-b,.als-ed-wbtn,.als-ed-sheet').forEach(n => n.addEventListener('pointerdown', stop));
    aRoot.querySelector('.als-ed-cancel').onclick = e => { e.stopPropagation(); Sound.play('click'); aClose(false); };
    aRoot.querySelector('.als-ed-done').onclick = e => { e.stopPropagation(); Sound.play('click'); aClose(true); };
    aRoot.querySelector('.als-ed-ok').onclick = e => { e.stopPropagation(); Sound.play('click'); aSheet(null); };
    aRoot.querySelector('.als-ed-wbtn').onclick = e => { e.stopPropagation(); Sound.play('click'); aSheet('wall'); };
    /* no editor nada dentro do ecrã faz a sua ação: um toque escolhe a zona (ou fecha a folha) */
    lockEl().addEventListener('click', e => { if (!aOn) return; e.stopPropagation(); e.preventDefault();
      const sc = e.target.closest('.als-sc');
      const z = e.target.closest('.als-top') ? 'clock' : e.target.closest('.lock-widgets') ? 'widgets' : sc ? 'controls' : null;
      if (sc) aSide = +sc.dataset.side || 0;
      aSheet(z && z !== aPanel ? z : (z === 'controls' ? 'controls' : null)); }, true);
  }
  function aLabels() { if (!aRoot) return; const q = (s, t) => { const n = aRoot.querySelector(s); if (n) n.textContent = t; };
    q('.als-ed-cancel', L.t('Cancelar')); q('.als-ed-done', L.t('Concluído')); q('.als-ed-wbtn span', L.t('Fundo')); q('.als-ed-ok', L.t('OK'));
    const w = lockEl() && lockEl().querySelector('.lock-widgets'); if (w) w.dataset.empty = L.t('Adicionar widgets'); }
  function aOpen(panel) {
    if (aOn || closing) return; aInit(); list(); sync();
    const c = cur(); aSnap = Object.assign({}, CLOCK_DEF, c, { widgets: (c.widgets || []).slice(), controls: (c.controls || []).slice(), ctlOS: c.ctlOS || null });   /* ctlOS explícito: o Cancelar também o repõe */
    open = true; aOn = true; aShut = false; aPanel = null; clearTimeout(aCloseT); aLabels();
    if (window.Notify) Notify.close();
    const s = scr(); s.classList.remove('als-edit-out'); s.classList.add('als-edit'); aRoot.classList.add('on');
    if (window.Lock && Lock.renderNowPlaying) Lock.renderNowPlaying();   /* a Now Bar sai (é conteúdo do momento, como as notificações) */
    Bridge.emit('overlay', 'lsg'); Sound.play('pop');
    if (panel) setTimeout(() => { if (aOn) aSheet(panel); }, 260);
  }
  /* keep=false (Cancelar): repõe a cópia da entrada. Aberto pelas Definições: no fim volta-se lá */
  function aClose(keep, instant) {
    if (!aOn) return; const snap = aSnap; aOn = false; aSnap = null;
    if (!keep && snap) updateCur(snap, { focus: false });
    aSheet(null, true); const s = scr(); s.classList.remove('als-edit'); s.classList.add('als-edit-out'); if (aRoot) aRoot.classList.remove('on');
    lockEl().removeAttribute('data-aed');
    clearTimeout(aCloseT); aShut = true; aCloseT = setTimeout(aDone, 360);
    if (instant) aDone();
    const to = returnTo; returnTo = null;
    if (to) setTimeout(() => { if (System.locked && window.Lock) Lock.unlock(); setTimeout(() => System.openApp(to), 260); }, 380);
  }
  function aDone() { clearTimeout(aCloseT); if (!aShut) return; aShut = false; scr().classList.remove('als-edit-out'); open = false; if (window.Lock && Lock.renderNowPlaying) Lock.renderNowPlaying(); }
  /* a folha de baixo: monta o conteúdo da zona e sobe (transform). null fecha */
  function aSheet(k, silent) {
    if (!aRoot) return; const sh = aRoot.querySelector('.als-ed-sheet'); aPanel = k || null;
    lockEl().setAttribute('data-aed', aPanel || ''); aRoot.classList.toggle('als-ed-sh', !!aPanel);
    if (!aPanel) { sh.classList.remove('on'); return; }
    const titles = { clock: 'Relógio', widgets: 'Widgets', controls: 'Atalhos', wall: 'Fundo' };
    aRoot.querySelector('.als-ed-head b').textContent = L.t(titles[aPanel]);
    const body = aRoot.querySelector('.als-ed-body'); body.innerHTML = ''; body.scrollTop = 0;
    if (aPanel === 'clock') aClock(body); else if (aPanel === 'widgets') aWidgets(body); else if (aPanel === 'controls') aCtl(body); else aWall(body);
    sh.classList.add('on'); if (!silent) Sound.play('click');
  }
  const aSec = (body, t) => { const s = UI.el(`<div class="als-ed-sec"><div class="als-ed-st">${UI.esc(L.t(t))}</div></div>`); body.appendChild(s); return s; };
  /* controlo segmentado (um só "ligado"); os botões não se refazem: só muda a classe */
  function aSeg(host, items, now, onPick) { const r = UI.el('<div class="als-ed-seg"></div>');
    items.forEach(([v, l, ic]) => { const b = UI.el(`<div class="${v === now ? 'on' : ''}" data-v="${v}">${ic ? g(ic, 18) : UI.esc(L.t(l))}</div>`); if (ic) b.setAttribute('aria-label', L.t(l));
      b.onclick = e => { e.stopPropagation(); [...r.children].forEach(x => x.classList.toggle('on', x === b)); Sound.play('click'); onPick(v); }; r.appendChild(b); });
    host.appendChild(r); return r; }
  function aClock(body) {
    const ls = cur(); const now = aStyleOf(ls);
    const st = aSec(body, 'Estilo do relógio'); const row = UI.el('<div class="als-ed-styles"></div>'); st.appendChild(row);
    const d = new Date(), h = d.getHours(), hh = UI.pad(S().clock24 === false ? ((h % 12) || 12) : h), mm = UI.pad(d.getMinutes());
    A_STYLES.forEach(([id, l, font, style]) => { const t = UI.el(`<div class="als-ed-sty${id === now ? ' on' : ''}" data-f="${font}" data-s="${style}"><div class="als-ed-mini"><span>${hh}</span><span>${mm}</span></div><i>${UI.esc(L.t(l))}</i></div>`);
      t.onclick = e => { e.stopPropagation(); [...row.children].forEach(x => x.classList.toggle('on', x === t)); Sound.play('click'); updateCur({ clockFont: font, clockStyle: style }); };
      row.appendChild(t); });
    const cs = aSec(body, 'Cor'); const cr = UI.el('<div class="als-ed-colors"></div>'); cs.appendChild(cr);
    A_COLORS.forEach(c => { const b = UI.el(`<div class="${(ls.clockColor || '#FFFFFF').toUpperCase() === c ? 'on' : ''}"><i></i></div>`); b.firstElementChild.style.background = c;
      b.onclick = e => { e.stopPropagation(); [...cr.children].forEach(x => x.classList.toggle('on', x === b)); Sound.play('click'); updateCur({ clockColor: c }); }; cr.appendChild(b); });
    const two = (a, b) => { const r = UI.el('<div class="als-ed-two"></div>'); r.appendChild(a); r.appendChild(b); body.appendChild(r); };
    const half = t => UI.el(`<div class="als-ed-sec"><div class="als-ed-st">${UI.esc(L.t(t))}</div></div>`);
    const w1 = half('Espessura'), w2 = half('Tamanho');
    aSeg(w1, [['light', 'Leve'], ['regular', 'Normal'], ['bold', 'Negrito']], ls.clockWeight || 'regular', v => updateCur({ clockWeight: v }));
    aSeg(w2, [['small', 'Pequeno'], ['normal', 'Normal'], ['large', 'Grande']], ls.clockSize || 'normal', v => updateCur({ clockSize: v }));
    two(w1, w2);
    const p1 = half('Posição'), p2 = half('Alinhamento');
    aSeg(p1, [['top', 'Em cima'], ['middle', 'Ao meio']], ls.clockPos || CLOCK_DEF.clockPos, v => updateCur({ clockPos: v }));
    aSeg(p2, [['left', 'Esquerda'], ['center', 'Centro'], ['right', 'Direita']], ls.clockAlign || CLOCK_DEF.clockAlign, v => updateCur({ clockAlign: v }));
    two(p1, p2);
  }
  function aWidgets(body) {
    const sec = aSec(body, 'Escolha até 3 widgets'); const gr = UI.el('<div class="als-ed-grid"></div>'); sec.appendChild(gr);
    WIDGETS.forEach(([k, l, ic]) => { const d = UI.el(`<div class="als-ed-opt ${cur().widgets.includes(k) ? 'on' : ''}"><div class="als-ed-oi">${g(ic, 22)}</div><span>${UI.esc(L.t(l))}</span><i>${g('check', 15)}</i></div>`);
      d.onclick = e => { e.stopPropagation(); let w = cur().widgets.slice(); if (w.includes(k)) w = w.filter(x => x !== k); else { w.push(k); if (w.length > 3) w = w.slice(-3); }
        updateCur({ widgets: w }); [...gr.children].forEach((c, i) => c.classList.toggle('on', w.includes(WIDGETS[i][0]))); Sound.play('click'); };
      gr.appendChild(d); });
  }
  function aCtl(body) {
    const C = window.Lock ? Lock.CONTROLS : {};
    ['Atalho da esquerda', 'Atalho da direita'].forEach((t, side) => {
      const sec = aSec(body, t); if (side === aSide) sec.classList.add('cur'); const gr = UI.el('<div class="als-ed-ctl"></div>'); sec.appendChild(gr);
      A_CTL.forEach(k => { const c = C[k] || { icon: 'x', label: k }; const d = UI.el(`<div class="${aControls(cur())[side] === k ? 'on' : ''}"><div class="als-ed-ci">${g(c.icon || 'x', 22)}</div><span>${UI.esc(L.t(c.label))}</span></div>`);
        d.onclick = e => { e.stopPropagation(); const ctl = aControls(cur()); ctl[side] = k; updateCur({ controls: ctl, ctlOS: 'android' }); [...gr.children].forEach((x, i) => x.classList.toggle('on', A_CTL[i] === k)); Sound.play('click'); };
        gr.appendChild(d); });
    });
  }
  /* fundo: o ecrã atual passa a ter este fundo e o principal acompanha (um par, como na Nova UI) */
  function aWall(body) {
    const ls = cur(); const pick = patch => { updateCur(Object.assign({ home: Object.assign({}, HOME0) }, patch)); aSheet('wall', true); };
    const isCur = (wp, custom) => !ls.custom ? (!custom && res(ls.wallpaper) === res(wp)) : !!(custom && ls.custom.css && custom.css === ls.custom.css);
    const row = (t, cls) => { const s = aSec(body, t); const r = UI.el(`<div class="als-ed-row ${cls || ''}"></div>`); s.appendChild(r); return r; };
    const wr = row('Fundos', 'als-ed-rwp');
    Wallpapers.list().forEach(w => { const t = UI.el(`<div class="als-ed-wp${isCur(w.id, null) ? ' on' : ''}"><i></i><span>${UI.esc(w.name || '')}</span></div>`); paintBg(t.firstElementChild, w.css);
      t.onclick = e => { e.stopPropagation(); Sound.play('click'); pick({ wallpaper: w.id, custom: null }); }; wr.appendChild(t); });
    const ph = UI.el(`<div class="als-ed-wp more${ls.custom && (ls.custom.url || ls.custom.seed) ? ' on' : ''}"><i>${g('photo', 24)}</i><span>${UI.esc(L.t('Galeria'))}</span></div>`);
    ph.onclick = async e => { e.stopPropagation(); Sound.play('click'); if (!window.Photos) return; const p = await Photos.pick(L.t('Escolher fundo')); if (p && aOn) pick({ wallpaper: null, custom: { url: p.url || null, seed: p.url ? null : p.seed } }); };
    wr.appendChild(ph);
    /* imagem por link / colada (1.1.4) */
    if (linkCfg().enabled !== false) { const lk = UI.el(`<div class="als-ed-wp more"><i>${g('link', 24)}</i><span>${UI.esc(L.t('Link'))}</span></div>`);
      lk.onclick = e => { e.stopPropagation(); Sound.play('click'); linkSheet(patch => { if (aOn) pick(patch); }); }; wr.appendChild(lk); }
    const cr = row('Cores', 'als-ed-rdot');
    COLORS.forEach(([c, n]) => { const b = UI.el(`<div class="als-ed-dot${isCur(null, { css: c }) ? ' on' : ''}" aria-label="${UI.esc(L.t(n))}"><i></i></div>`); paintBg(b.firstElementChild, solid(c));
      b.onclick = e => { e.stopPropagation(); Sound.play('click'); pick({ wallpaper: null, custom: { css: c } }); }; cr.appendChild(b); });
    const gr = row('Gradientes', 'als-ed-rdot');
    GRADS.forEach(([c, n]) => { const b = UI.el(`<div class="als-ed-dot${isCur(null, { css: c }) ? ' on' : ''}" aria-label="${UI.esc(L.t(n))}"><i></i></div>`); paintBg(b.firstElementChild, c);
      b.onclick = e => { e.stopPropagation(); Sound.play('click'); pick({ wallpaper: null, custom: { css: c } }); }; gr.appendChild(b); });
  }

  /* ---------- API para as Definições ---------- */
  /* abre a galeria (sem pedir o código: quem chama já está desbloqueado) e entra no editor pedido; `back` = app para onde voltar no fim */
  /* kind: 'lock' | 'home' | 'clock' (folha "Fonte e cor") | 'widgets' (folha "Adicionar widgets") */
  function openEditor(kind, back) { if (isAnd()) { aOpen(kind === 'home' ? 'wall' : kind === 'clock' || kind === 'widgets' ? kind : null); if (aOn) returnTo = back || null; return; }
    open_(); if (!open) return; returnTo = back || null; setTimeout(() => { if (!open || closing) return; if (kind === 'home') { enterHome(); return; } enterEdit();
      if (kind === 'clock' || kind === 'widgets') setTimeout(() => { if (open && edit && !closing) { if (kind === 'clock') editClock(); else editWidgets(); } }, 420); }, 480); }
  function use(id) { const ls = list().find(x => x.id === id); if (ls && ls.id !== S().lockCurrent) applyLS(ls); return ls || null; }
  function addNew(done) { return wallpaperGallery(patch => { const ls = createDetached(patch); if (done) done(ls); }); }
  /* guardar o telemóvel a meio: sai da galeria de imediato (como apagar o ecrã no PearPhone); sem isto reabria com a galeria/edição/caixote onde ficaram */
  if (window.Bridge && Bridge.on) Bridge.on('phone:close', () => close(true));
  /* 1.4.0: um fundo desenhado em canvas (emoji, estilo de foto) acabou de ficar pronto - o cartão atual e os vizinhos repintam-se */
  /* só quando o aviso é de um fundo que um dos ecrãs usa (pelo bloqueado ou pelo principal): a meteorologia avisa a cada mudança de
     tempo/fase do dia e cada emoji desenhado avisa também - refazer os cartões laterais em todos era trabalho à toa com a galeria aberta */
  const usesSig = s => { const W = window.WallKinds; if (!W || !W.needs) return false; const isWx = s === '["weather"]';
    return list().some(ls => [lockSrc(ls).custom, homeSrc(ls).custom].some(c => c && W.needs(c) && (isWx ? c.kind === 'weather' : W.sig(c) === s))); };
  if (window.Bridge && Bridge.on) Bridge.on('wallkind:ready', s => { if (!open || aOn || isAnd() || !sides) return; try { if (!usesSig(s)) return; } catch (e) {} paintLockCard(cur()); paintSides(); });
  /* internos para o editor do PearOS 27 (lockeditor.js) e o "Personalizar" do principal (homecustom.js): os mesmos caminhos de escrita
     (updateCur → applyLS), as mesmas folhas (wsheet), barras e cores - nada se duplica noutro ficheiro. Os nomes são contrato. */
  const _x = { cur, list, curIdx, save, updateCur, applyLS, createDetached, create, fromState, lockSrc, homeSrc, homeOf, bgOf, paintBg, paintCrop, cropBox, liveCrop, absBg, paintLockCard, paintSides, paintUI, settle, scr, lockEl, S, uid, sig, FONTS, fontOf, wghtOf, SWATCHES, COLORS, GRADS, CLOCK_DEF,
    wsheet, closeWs, get wsh() { return wsh; }, get wshKind() { return wshKind; }, setAwPaint: fn => { awPaint = typeof fn === 'function' ? fn : null; }, slider, thumbAt, hexOf, pureOf, htHex, hexHT, liveColor, setWidgets, sect, optRow, linkSheet, linkCfg, wallpaperGallery,
    blurOf, avgColor, loadImgCb, isEdit: () => edit, isOpen: () => open, isPick: () => pick, enterEdit, exitEdit, doneEdit, cancelEdit, exitPick,
    /* extra (não fazem parte do contrato, mas custam nada): */ isAdd: () => addMode, enterAdd, leaveAdd, openPicker, mock, mockEl, thumb, clockM, kindSig, canBlur, homeBg, solid, spOf, isAnd, root: () => root, removeControl };
  return { init, request, open: skipAuth => { if (skipAuth) { if (isAnd()) aOpen(); else open_(); } else request(); }, close, enterEdit, exitEdit, enterPick, exitPick, enterHome, exitHome, isOpen: () => open, list, current: cur,
    /* estado para testes/depuração */ get mode() { return aOn ? 'android' + (aPanel ? ':' + aPanel : '') : !open ? 'closed' : homeEd ? 'home' : edit ? 'lock' : pick ? 'pick' : 'gallery'; }, get draft() { return homeEd ? Object.assign({}, homeEd.draft) : null }, setHomeDraft: setDraft,
    /* Nova UI: abrir uma folha do editor (testes e Definições): 'clock' | 'widgets' | 'controls' | 'wall' */ sheet: k => { if (aOn) aSheet(k || null); },
    homeOf, thumb, sync, use, addNew, addFromLink, linkSheet, linkCfg, checkLink, openEditor, apply: applyLS,   /* linkSheet/linkCfg: a app Fotos usa a mesma folha com cfg 'photoLinks' */
    /* folhas do editor do bloqueado do PearOS (com o editor aberto): "Fonte e cor" e "Adicionar widgets" */ editClock: () => { if (edit) editClock(); }, editWidgets: () => { if (edit) editWidgets(); }, editControls: side => { if (edit) editControls(side); }, closeSheet: closeWs, FONTS, _x };
})();
