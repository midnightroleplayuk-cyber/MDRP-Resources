/* ============================================================
   WALLKINDS (1.4.0, PearOS 27): os fundos "de tipo" do ecrã bloqueado e do principal, como no iOS 26 -
   Emoji, Meteorologia (ao vivo), Astronomia (Terra, Lua, Marte, Sistema solar), Cor e Fotos aleatórias -
   e os estilos de foto dos fundos de imagem (Natural, Preto e branco, Duotom, Lavado).
   O ESTADO só guarda a receita (custom = { kind, … }, uns bytes de JSON): o desenho faz-se aqui, em tempo
   de execução, e NUNCA vai para o System.state nem para a conta - um data URL de 100-200 kB por ecrã
   enchia o account.update até ao 'toolarge' do servidor (ver system.js save()).
   - SVG (Meteorologia, Astronomia, Cor): string gerada de forma síncrona, devolvida como data URI SVG com
     aspas SIMPLES (o mesmo formato do Wallpapers.dataUri: estes valores chegam a entrar em style="…").
     Os <filter> (desfoque, turbulência) vivem DENTRO da imagem: é desenho rasterizado uma vez, não um
     filter CSS numa camada do DOM (esse sim proibido no CEF - retângulo preto atrás do telemóvel).
   - CANVAS (Emoji, estilos de foto): assíncrono. A primeira chamada devolve um substituto (a cor de fundo,
     a foto natural) e o desenho fica numa fila de um trabalho de cada vez; quando acaba, o resultado vai
     para a cache e, se o fundo atual ainda é o mesmo, System.repaintWallpaper() (50 ms, agrupado) +
     Bridge.emit('wallkind:ready', sig) para as miniaturas da galeria se repintarem.
   - Tudo em cache pela assinatura (sig) + largura do ecrã (os dobráveis desenham a 670/1340 de largura).
   Carrega logo a seguir ao wallpapers.js, ANTES do system.js/lock.js/photos.js: System, WX e Photos
   só se leem dentro das funções, nunca no arranque do ficheiro.
   ============================================================ */
window.WallKinds = (() => {
  const KINDS = ['emoji', 'weather', 'astro', 'color', 'shuffle'];
  const PSTYLES = ['natural', 'mono', 'duotone', 'wash'];
  const BODIES = ['earth', 'moon', 'mars', 'solar'];
  const CSTYLES = ['vibrant', 'tone', 'deep', 'vapor', 'bright'];
  const LAYOUTS = ['grid', 'rings', 'spiral', 'large'];
  const EVERY = ['wake', 'hour', 'day'];
  /* nomes (chaves PT; quem mostra embrulha em L.t) */
  const NAMES = {
    kind: { emoji: 'Emoji', weather: 'Meteorologia', astro: 'Astronomia', color: 'Cor', shuffle: 'Aleatórias' },
    astro: { earth: 'Terra', moon: 'Lua', mars: 'Marte', solar: 'Sistema solar' },
    color: { vibrant: 'Vibrante', tone: 'Tonal', deep: 'Profunda', vapor: 'Vapor', bright: 'Brilhante' },
    layout: { grid: 'Grelha', rings: 'Anéis', spiral: 'Espiral', large: 'Grande' },
    style: { natural: 'Natural', mono: 'Preto e branco', duotone: 'Duotom', wash: 'Lavado' },
    every: { wake: 'Ao acordar', hour: 'A cada hora', day: 'Todos os dias' }
  };
  const H = 956;
  const isKind = c => !!(c && typeof c === 'object' && c.kind && KINDS.includes(c.kind));
  /* um estilo desconhecido vale "natural" (cai no caminho normal do url) - nunca uma imagem partida */
  const isStyled = c => !!(c && typeof c === 'object' && !c.kind && typeof c.url === 'string' && c.url && PSTYLES.includes(c.style) && c.style !== 'natural');
  const needs = c => isKind(c) || isStyled(c);

  /* ---------- utilitários ---------- */
  /* largura do ecrã em px do desenho: 440, ou 670/1340 no PearPhone Fold (o fundo cobre o ecrã inteiro sem esticar) */
  const SW = () => { const w = window.System ? +System.SW : 0; return w > 0 ? Math.round(w) : 440; };
  const f = n => Math.round(n * 10) / 10;
  const clamp = (v, a, b) => v < a ? a : v > b ? b : v;
  /* gerador pseudo-aleatório com semente: as estrelas, a chuva e a neve saem SEMPRE iguais para a mesma receita
     (a cache e a assinatura dependem disso; um Math.random() fazia cada repintura diferente) */
  const rng = s => { s = (s >>> 0) % 2147483647 || 1; return () => (s = s * 16807 % 2147483647) / 2147483647; };
  const hx = n => ('0' + clamp(Math.round(n), 0, 255).toString(16)).slice(-2);
  const rgbHex = (r, g, b) => ('#' + hx(r) + hx(g) + hx(b)).toUpperCase();
  const rgbOf = h => { const m = /^#?([0-9a-f]{6})$/i.exec(String(h || '')); const n = m ? parseInt(m[1], 16) : 0; return [n >> 16 & 255, n >> 8 & 255, n & 255]; };
  const mix = (a, b, t) => { const A = rgbOf(a), B = rgbOf(b); return rgbHex(A[0] + (B[0] - A[0]) * t, A[1] + (B[1] - A[1]) * t, A[2] + (B[2] - A[2]) * t); };
  const hsl = (h, s, l) => { h = ((h % 360) + 360) % 360; s = clamp(s, 0, 1); l = clamp(l, 0, 1); const a = s * Math.min(l, 1 - l), k = n => (n + h / 30) % 12, c = n => l - a * Math.max(-1, Math.min(k(n) - 3, 9 - k(n), 1)); return rgbHex(c(0) * 255, c(8) * 255, c(4) * 255); };
  const lum = h => { const [r, g, b] = rgbOf(h); return (.2126 * r + .7152 * g + .0722 * b) / 255; };
  const svgDoc = (W, defs, body) => `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}"><defs>${defs}</defs>${body}</svg>`;
  /* aspas SIMPLES e nenhuma aspa dentro do valor (entra em style="…" nas miniaturas; encodeURIComponent não codifica a ') */
  const svgUri = s => `url('data:image/svg+xml;charset=utf-8,${encodeURIComponent(s).replace(/'/g, '%27')}')`;
  const cssUrl = u => `url('${String(u).replace(/'/g, '%27').replace(/"/g, '%22')}')`;
  /* um url relativo dentro de var(--wp-lock) seria resolvido contra a folha de estilo que o usa (css/…), não contra o documento */
  const abs = u => { try { return /^(data:|blob:|[a-z]+:\/\/)/i.test(u) ? u : new URL(u, location.href).href; } catch (e) { return u; } };
  const stop = (o, c, a) => `<stop offset="${o}" stop-color="${c}"${a == null || a === 1 ? '' : ` stop-opacity="${a}"`}/>`;
  const radial = (id, stops, extra) => `<radialGradient id="${id}"${extra || ''}>${stops.map(s => stop(s[0], s[1], s[2])).join('')}</radialGradient>`;
  const linear = (id, stops, extra) => `<linearGradient id="${id}"${extra || ' x1="0" y1="0" x2="0" y2="1"'}>${stops.map(s => stop(s[0], s[1], s[2])).join('')}</linearGradient>`;
  const blurF = (id, s, pad) => `<filter id="${id}" x="-${pad || 30}%" y="-${pad || 30}%" width="${100 + 2 * (pad || 30)}%" height="${100 + 2 * (pad || 30)}%"><feGaussianBlur stdDeviation="${s}"/></filter>`;
  /* PONTOS (estrelas, flocos): um traço de comprimento ZERO com pontas redondas desenha um círculo - centenas de pontos
     cabem num único <path> por tamanho (um <circle> por estrela punha a Astronomia acima dos 20 kB) */
  function dots(pts, w, color, op) { return pts.length ? `<path d="${pts.join('')}" fill="none" stroke="${color}" stroke-width="${w}" stroke-linecap="round" stroke-opacity="${op}"/>` : ''; }
  function stars(W, n, seed, y0, y1, k) {
    const r = rng(seed), G = [[], [], [], []], glow = [];
    for (let i = 0; i < n; i++) { const x = f(r() * W), y = f(y0 + Math.pow(r(), 1.25) * (y1 - y0)), q = r(); const g = q < .58 ? 0 : q < .86 ? 1 : q < .97 ? 2 : 3; G[g].push(`M${x} ${y}h0`); if (g === 3) glow.push([x, y]); }
    const SZ = [1, 1.5, 2.1, 2.8], OP = [.42, .62, .82, 1];
    return glow.map(([x, y]) => `<circle cx="${x}" cy="${y}" r="9" fill="url(#sgl)" opacity="${(.8 * k).toFixed(2)}"/>`).join('') + G.map((g, i) => dots(g, SZ[i], '#FFFFFF', (OP[i] * k).toFixed(2))).join('');
  }
  const STAR_GLOW = radial('sgl', [[0, '#FFFFFF', .7], [.35, '#CFE0FF', .18], [1, '#CFE0FF', 0]]);

  /* ---------- METEOROLOGIA (ao vivo: WX.now() do lock.js) ---------- */
  /* fases do dia pela hora do jogo: madrugada 5-7, dia, pôr do sol 18-20, noite */
  const PHASE = h => h >= 5 && h < 7 ? 'dawn' : h >= 7 && h < 18 ? 'day' : h >= 18 && h < 20 ? 'dusk' : 'night';
  function wxNow() {
    let n = null; try { n = window.WX && WX.now ? WX.now() : null; } catch (e) { n = null; }
    let h = n && n.hour != null && isFinite(+n.hour) ? +n.hour : (window.System && System.gameHour != null ? +System.gameHour : new Date().getHours());
    h = ((Math.floor(h) % 24) + 24) % 24;
    const c = n && SKY[n.c] ? n.c : 'sunny';
    return { c, ph: PHASE(h), h };
  }
  /* "balde" do tempo: só muda o desenho quando muda a condição ou a fase (não a cada hora); lastWx = o último desenhado */
  const wxKey = () => { const n = wxNow(); return n.c + ':' + n.ph; };
  let lastWx = null;
  /* céu [topo, meio, fundo] de dia | de noite; madrugada e pôr do sol misturam os dois e aquecem o horizonte */
  const SKY = {
    sunny: [['#0E4BB3', '#2C7AD8', '#8CC0F1'], ['#020816', '#0A1736', '#1A315F']],
    cloudy: [['#53719A', '#7F98B9', '#BBCADB'], ['#0B1121', '#172238', '#2A3751']],
    rain: [['#34445A', '#53677F', '#8293A7'], ['#070C15', '#131C2A', '#233041']],
    storm: [['#171B28', '#2D3346', '#4A526C'], ['#03050A', '#0D111B', '#1A1F2F']],
    snow: [['#6E86A3', '#A3B6CC', '#DEE6EF'], ['#101928', '#222F47', '#3A4963']],
    fog: [['#7C8898', '#A8B2BE', '#D4DAE0'], ['#151A23', '#262D39', '#3C4451']]
  };
  const WARM = { dawn: ['#3A3E7C', '#B47C9C', '#FFBC8C'], dusk: ['#23255C', '#9C4E80', '#FF8D5A'] };
  function skyOf(c, ph) {
    const P = SKY[c] || SKY.sunny; if (ph === 'day') return P[0]; if (ph === 'night') return P[1];
    const w = c === 'sunny' ? .85 : c === 'cloudy' ? .55 : c === 'fog' ? .4 : .28;
    return P[0].map((x, i) => mix(mix(P[1][i], x, .55), WARM[ph][i], i === 0 ? w * .55 : w));
  }
  /* nuvens: dois feitios (cúmulo alto e um mais largo e baixo), grupos de círculos + base elíptica, SEM fill (o <use> dá a cor).
     O gradiente é userSpaceOnUse no espaço LOCAL da nuvem: um único degradê por toda a silhueta (luz em cima, cinzento na
     base) - com objectBoundingBox cada bola tinha o seu degradê e via-se o contorno de cada círculo (ar de desenho animado) */
  const CLOUD = '<g id="c0"><circle cx="-70" cy="6" r="36"/><circle cx="-32" cy="-16" r="48"/><circle cx="16" cy="-30" r="58"/><circle cx="62" cy="-10" r="44"/><circle cx="98" cy="10" r="30"/><circle cx="-104" cy="18" r="24"/><ellipse cx="0" cy="20" rx="124" ry="28"/></g>'
    + '<g id="c1"><circle cx="-92" cy="10" r="28"/><circle cx="-52" cy="-6" r="40"/><circle cx="-6" cy="-18" r="46"/><circle cx="42" cy="-8" r="40"/><circle cx="86" cy="4" r="32"/><circle cx="122" cy="14" r="22"/><ellipse cx="12" cy="20" rx="140" ry="24"/></g>';
  const CLC = { sunny: ['#FFFFFF', '#DCE7F5', .12], cloudy: ['#FCFDFE', '#BFCBD9', .2], rain: ['#B5BFCC', '#76808F', .3], storm: ['#62697B', '#2F3443', .42], snow: ['#FFFFFF', '#D2DBE6', .16], fog: ['#F3F5F7', '#CBD1D8', .1] };
  /* posições [x (fração da largura), y, escala, opacidade] por condição */
  const CLOUDS = {
    sunny: [[.8, 650, .5, .55], [.16, 790, .68, .5]],
    cloudy: [[.1, 150, .9, .95], [.74, 92, 1.1, 1], [.92, 380, .8, .92], [.24, 470, 1, .95], [.72, 650, .95, .92], [.18, 830, 1.15, .95], [.86, 905, .9, .92]],
    rain: [[.08, 64, 1.15, 1], [.5, 36, 1.3, 1], [.94, 84, 1.1, 1], [.3, 196, 1, .96], [.78, 226, 1.05, .96]],
    storm: [[.06, 60, 1.25, 1], [.48, 30, 1.4, 1], [.96, 90, 1.2, 1], [.26, 210, 1.1, 1], [.76, 240, 1.15, 1]],
    snow: [[.14, 72, 1, .95], [.6, 40, 1.2, 1], [.96, 112, 1, .95], [.38, 206, .9, .9]],
    fog: [[.22, 120, 1, .35], [.8, 300, 1.1, .3]]
  };
  function svgWeather(W) {
    const n = wxNow(), c = n.c, ph = n.ph, night = ph === 'night', low = ph === 'dawn' || ph === 'dusk', sk = skyOf(c, ph);
    let d = linear('g', [[0, sk[0]], [.55, sk[1]], [1, sk[2]]]) + STAR_GLOW + blurF('cs', 11) + blurF('cb', 2.6) + blurF('fb', 24, 60) + blurF('sb', 1.2) + blurF('gb', 7, 60);
    let b = `<rect width="${W}" height="${H}" fill="url(#g)"/>`;
    const clear = c === 'sunny';
    /* estrelas: noite limpa (muitas), nublada (poucas, entre as nuvens), madrugada/pôr do sol limpos (as primeiras, só em cima) */
    if (night && (clear || c === 'cloudy' || c === 'snow')) b += stars(W, clear ? 130 : 45, 7, 0, clear ? 760 : 520, clear ? 1 : .6);
    else if (low && clear) b += stars(W, 26, 9, 0, 260, .45);
    /* SOL / LUA */
    if (clear && ph === 'day') {
      const sx = f(W * .2), sy = 150;
      d += radial('sh', [[0, '#FFFFFF', .98], [.07, '#FFFBEA', .9], [.2, '#FFF5D6', .42], [.5, '#FFF2CF', .1], [1, '#FFF2CF', 0]], ' r=".5"') + radial('fl', [[0, '#FFFFFF', .26], [1, '#FFFFFF', 0]], ' r=".5"')
        + radial('sk', [[0, '#FFFFFF'], [.6, '#FFFEF7'], [1, '#FFF6DA', 0]], ' r=".5"');
      /* raios: triângulos finos em leque, desfocados e muito transparentes; reflexos da lente na diagonal para baixo */
      let rays = ''; const R = rng(3);
      for (let i = 0; i < 9; i++) { const a = (18 + i * 9 + R() * 4) * Math.PI / 180, L = 520 + R() * 380, w = .018 + R() * .02; rays += `M${sx} ${sy}L${f(sx + Math.cos(a - w) * L)} ${f(sy + Math.sin(a - w) * L)}L${f(sx + Math.cos(a + w) * L)} ${f(sy + Math.sin(a + w) * L)}Z`; }
      const fx = t => f(sx + (W * .86 - sx) * t), fy = t => f(sy + (840 - sy) * t);
      b += `<path d="${rays}" fill="#FFF8E1" opacity=".11" filter="url(#gb)"/><circle cx="${sx}" cy="${sy}" r="340" fill="url(#sh)"/><circle cx="${sx}" cy="${sy}" r="36" fill="url(#sk)"/>`
        + `<circle cx="${fx(.38)}" cy="${fy(.38)}" r="24" fill="url(#fl)"/><circle cx="${fx(.56)}" cy="${fy(.56)}" r="9" fill="#FFFFFF" fill-opacity=".14"/><circle cx="${fx(.8)}" cy="${fy(.8)}" r="46" fill="none" stroke="#FFFFFF" stroke-opacity=".09" stroke-width="5"/>`;
    } else if (clear && low) {
      /* sol baixo: brilho quente a subir do horizonte, meio disco a nascer/pôr */
      const sx = f(W * (ph === 'dawn' ? .3 : .7)), sy = 915;
      d += radial('sg', [[0, '#FFF1D2', .95], [.18, '#FFD49A', .7], [.45, '#FFAE6E', .28], [1, '#FF9A5C', 0]], ' r=".5"') + radial('sd', [[0, '#FFFDF6'], [.7, '#FFF0D2'], [1, '#FFE2B4', 0]], ' r=".5"');
      b += `<circle cx="${sx}" cy="${sy}" r="560" fill="url(#sg)"/><circle cx="${sx}" cy="${sy}" r="46" fill="url(#sd)"/>`;
    } else if (night && (clear || c === 'cloudy')) {
      /* lua quase cheia: disco com luz de lado, mares ténues e o halo frio à volta */
      const mx = f(W * .74), my = 170;
      d += radial('mh', [[0, '#DCE6FF', .34], [.3, '#BFD0FF', .12], [1, '#BFD0FF', 0]], ' r=".5"') + radial('md', [[0, '#FFFEF8'], [.7, '#ECE8DA'], [1, '#C9C4B3']], ' cx=".42" cy=".38" r=".62"');
      b += `<circle cx="${mx}" cy="${my}" r="210" fill="url(#mh)"/><circle cx="${mx}" cy="${my}" r="31" fill="url(#md)"/>`
        + `<g fill="#9C978A" fill-opacity=".22"><ellipse cx="${f(mx - 9)}" cy="${my - 8}" rx="9" ry="7"/><ellipse cx="${f(mx + 6)}" cy="${my - 2}" rx="7" ry="6"/><ellipse cx="${f(mx - 3)}" cy="${my + 12}" rx="6" ry="4"/></g>`
        + `<path d="M${f(mx + 4)} ${my - 31}a31 31 0 0 1 0 62a24 31 0 0 0 0-62z" fill="#0A1430" fill-opacity=".18"/>`;
    } else if (c === 'fog' && !night) {
      /* sol difuso atrás do nevoeiro */
      d += radial('fs', [[0, '#FFFFFF', .7], [.25, '#FFFFFF', .28], [1, '#FFFFFF', 0]], ' r=".5"');
      b += `<circle cx="${f(W * .66)}" cy="200" r="190" fill="url(#fs)"/>`;
    }
    /* clarão do relâmpago por trás das nuvens */
    if (c === 'storm') { d += radial('lf', [[0, '#DCE6FF', .55], [.4, '#9FB4FF', .18], [1, '#9FB4FF', 0]], ' r=".5"'); b += `<circle cx="${f(W * .62)}" cy="230" r="330" fill="url(#lf)"/>`; }
    /* NUVENS */
    const cc = CLC[c] || CLC.sunny; let top = cc[0], bot = cc[1];
    if (night) { top = mix(top, '#3B4766', .72); bot = mix(bot, '#182033', .72); } else if (low) { bot = mix(bot, WARM[ph][2], .5); top = mix(top, '#FFE9DA', .3); }
    d += CLOUD + linear('cg', [[0, top], [.5, mix(top, bot, .35)], [1, bot]], ' gradientUnits="userSpaceOnUse" x1="0" y1="-92" x2="0" y2="50"')
      + radial('ch', [[0, '#FFFFFF', night ? .18 : .55], [1, '#FFFFFF', 0]], ' gradientUnits="userSpaceOnUse" cx="0" cy="-58" r="120"');
    /* nebulosidade ao longe (grandes manchas muito desfocadas) para o céu encoberto ter profundidade atrás das nuvens */
    if (c === 'cloudy' || c === 'rain' || c === 'storm' || c === 'snow') { const R = rng(51), hz = night ? '#6C7A96' : c === 'storm' ? '#8A93A8' : '#FFFFFF';
      for (let i = 0; i < 4; i++) b += `<ellipse cx="${f(W * (.1 + R() * .8))}" cy="${f(120 + i * 190 + R() * 60)}" rx="${f(W * (.55 + R() * .3))}" ry="${f(70 + R() * 40)}" fill="${hz}" fill-opacity="${(.1 + R() * .1).toFixed(2)}" filter="url(#fb)"/>`; }
    /* cada nuvem: sombra desfocada por baixo, corpo, brilho em cima; uma sim, uma não com o outro feitio e espelhada.
       `opacity` (do grupo) e não fill-opacity: com fill-opacity cada círculo compõe à parte e as sobreposições viam-se */
    b += (CLOUDS[c] || []).map(([x, y, s, o], i) => { const t = `translate(${f(W * x)} ${y}) scale(${i % 2 ? -s : s} ${s})`, h = `#c${i % 2}`;
      return `<use href="${h}" transform="${t} translate(4 16)" fill="#000" opacity="${(cc[2] * o).toFixed(2)}" filter="url(#cs)"/><use href="${h}" transform="${t}" fill="url(#cg)" opacity="${o}" filter="url(#cb)"/><use href="${h}" transform="${t}" fill="url(#ch)" opacity="${o}" filter="url(#cb)"/>`; }).join('');
    /* CHUVA / TROVOADA: dois planos de riscos inclinados (longe: finos e ténues; perto: mais compridos) */
    if (c === 'rain' || c === 'storm') {
      const lines = (n, seed, len, w, op) => { const R = rng(seed); let p = ''; for (let i = 0; i < n; i++) { const x = R() * (W + 80), y = 150 + R() * (H - 120); p += `M${f(x)} ${f(y)}l-${f(len * .22)} ${f(len * (.75 + R() * .5))}`; } return `<path d="${p}" stroke="#D6E4F5" stroke-width="${w}" stroke-linecap="round" stroke-opacity="${op}" fill="none"/>`; };
      b += lines(Math.round(W * .22), 21, 24, 1, .22) + lines(Math.round(W * .11), 22, 40, 1.5, .34);
    }
    if (c === 'storm') {
      /* raio: zigue-zague (pequenos desvios com semente: um traço de régua parecia um desenho) com brilho azulado desfocado e um ramo */
      const R = rng(61), zig = (pts, j) => 'M' + pts.map(([x, y], i) => f(W * x + (i && i < pts.length - 1 ? (R() - .5) * j : 0)) + ' ' + f(y)).join('L');
      const bolt = zig([[.63, 238], [.61, 290], [.585, 340], [.6, 372], [.575, 420], [.545, 480], [.56, 540], [.52, 600], [.5, 655], [.47, 712]], 18), br = zig([[.58, 430], [.63, 462], [.65, 500], [.68, 540]], 12);
      b += `<path d="${bolt}${br}" stroke="#BFD2FF" stroke-width="12" stroke-opacity=".55" fill="none" stroke-linejoin="round" filter="url(#gb)"/><path d="${bolt}" stroke="#FFFFFF" stroke-width="3.4" fill="none" stroke-linejoin="round" stroke-linecap="round"/><path d="${br}" stroke="#FFFFFF" stroke-width="2" fill="none" stroke-linejoin="round" stroke-linecap="round" stroke-opacity=".85"/>`;
    }
    /* NEVE: flocos longe (desfocados) e perto */
    if (c === 'snow') {
      const R = rng(31), far = [], mid = [], near = [];
      for (let i = 0; i < Math.round(W * .32); i++) { const p = `M${f(R() * W)} ${f(120 + R() * (H - 100))}h0`, q = R(); (q < .5 ? far : q < .85 ? mid : near).push(p); }
      b += `<g filter="url(#sb)">${dots(far, 3.2, '#FFFFFF', .55)}</g>${dots(mid, 4.2, '#FFFFFF', .8)}${dots(near, 6.5, '#FFFFFF', .92)}`;
    }
    /* NEVOEIRO: faixas largas e muito desfocadas */
    if (c === 'fog') {
      const R = rng(41);
      for (let i = 0; i < 7; i++) b += `<ellipse cx="${f(W * (.2 + R() * .6))}" cy="${f(260 + i * 105 + R() * 40)}" rx="${f(W * (.7 + R() * .4))}" ry="${f(38 + R() * 30)}" fill="${night ? '#8E98A8' : '#FFFFFF'}" fill-opacity="${(.22 + R() * .2).toFixed(2)}" filter="url(#fb)"/>`;
    }
    /* luz do horizonte (dia) e vinheta suave: o relógio branco lê-se em cima, o fundo não fica chapado */
    d += linear('hz', [[0, '#FFFFFF', 0], [1, night ? '#3A5A9A' : '#FFFFFF', night ? .18 : .16]]) + radial('vg', [[.55, '#000000', 0], [1, '#000000', .22]], ' cx=".5" cy=".4" r=".75"');
    b += `<rect y="${H - 300}" width="${W}" height="300" fill="url(#hz)"/><rect width="${W}" height="${H}" fill="url(#vg)"/>`;
    return svgDoc(W, d, b);
  }

  /* ---------- ASTRONOMIA ---------- */
  /* fundo do espaço: gradiente quase preto centrado no planeta, duas nebulosas muito ténues (gradientes radiais, sem
     filtro: já são macios) e o campo de estrelas */
  function space(W, cx, cy, seed) {
    return {
      d: radial('sp', [[0, '#0D1934'], [.45, '#060B1B'], [1, '#010206']], ` gradientUnits="userSpaceOnUse" cx="${f(cx)}" cy="${f(cy)}" r="980"`) + radial('n1', [[0, '#4A3A90', .3], [1, '#4A3A90', 0]], ' r=".5"') + radial('n2', [[0, '#1B6890', .2], [1, '#1B6890', 0]], ' r=".5"') + STAR_GLOW,
      b: `<rect width="${W}" height="${H}" fill="url(#sp)"/><ellipse cx="${f(W * .18)}" cy="230" rx="${f(W * .75)}" ry="230" fill="url(#n1)" transform="rotate(-26 ${f(W * .18)} 230)"/><ellipse cx="${f(W * .88)}" cy="430" rx="${f(W * .6)}" ry="190" fill="url(#n2)"/>` + stars(W, Math.round(W * .3), seed, 0, H, 1)
    };
  }
  /* ===== TERRA: contornos em longitude/latitude (grosseiros de propósito: o desfoque das costas vem do feDisplacementMap)
     projetados em ortográfica centrada em África/Europa - a vista do globo que toda a gente reconhece ===== */
  const GEO = {
    af: [-17.1, 20.9, -16, 24, -13, 27.7, -9.8, 29.9, -9.6, 32.5, -6.9, 34, -5.9, 35.8, -2, 35.1, 3, 36.8, 10.2, 37.2, 11, 35, 10.3, 33.5, 15.3, 32.3, 19.9, 30.9, 20.1, 32.3, 25, 31.7, 29.9, 31.3, 32.3, 31.3, 34.2, 31.3, 34.9, 29.5, 33.6, 27.9, 35.5, 23.9, 37.3, 21, 38.5, 18, 41.7, 13.9, 43.3, 12.5, 44.3, 10.4, 51.2, 11.8, 51, 10.4, 49, 6, 46, 2, 43, -0.5, 40.2, -3, 39.3, -6, 40.4, -10.5, 40.6, -15, 37, -17.5, 35.3, -22, 35.5, -24.1, 32.9, -26, 32.6, -28.7, 30.4, -31.3, 27.5, -33.6, 25.6, -34, 22.6, -33.9, 20, -34.8, 18.4, -34, 17.9, -31, 16.5, -28.6, 15, -26.6, 14.4, -22.9, 13.1, -20, 11.8, -17.2, 12.2, -13.5, 13.6, -11.5, 13.2, -8.8, 12.3, -6, 11.8, -4, 9.4, -1.2, 9.5, 2, 9.8, 3.6, 8.5, 4.5, 5.6, 4.4, 4, 6.3, 1.6, 6.2, -2, 4.8, -4.6, 5.2, -7.6, 4.4, -9.5, 5.4, -11.3, 6.8, -13.2, 8.6, -15.1, 10.9, -16.7, 12.4, -17.4, 14.7, -16.5, 16.3, -16.1, 19],
    mg: [49.3, -12, 50.4, -15.5, 49.5, -17.8, 47.2, -24.9, 45.2, -25.5, 43.7, -23.5, 44.2, -20, 44.4, -16.3, 46.3, -15.7, 47.9, -13.5],
    eu: [-5.6, 36, -2, 36.7, 0, 38.6, -.3, 39.5, 3.2, 41.9, 3.1, 43, 6, 43.1, 7.5, 43.8, 8.8, 44.4, 10.2, 43.9, 12.3, 41.7, 15.6, 40, 16, 38, 17, 39, 18.5, 40.1, 17.2, 40.5, 16, 41.9, 13.5, 43.6, 12.3, 44.6, 13.7, 45.6, 15, 44.6, 18.5, 42.5, 19.5, 41.8, 19.3, 40.4, 21.2, 38.3, 21.7, 36.8, 22.9, 36.5, 23.2, 38.2, 24, 38, 22.9, 40.6, 26.1, 40.6, 28.9, 41, 28, 43.2, 29.7, 45.3, 31, 46.6, 33.6, 44.5, 36.5, 45.3, 38.3, 47.1, 39.6, 47, 38.9, 44.4, 41.6, 41.6, 44.5, 41.3, 49.5, 40.5, 48.6, 42.6, 47.5, 45.4, 48.6, 46.4, 51.2, 47.1, 53, 46.8, 58, 50, 70, 55, 85, 58, 100, 62, 100, 72, 80, 73, 68, 72, 58, 70.5, 53, 68.3, 44, 68.4, 33.1, 69.4, 28.5, 70.9, 25.3, 71.1, 19.2, 69.9, 16.3, 68.8, 13.6, 67.5, 10.6, 64.4, 7, 63, 5, 61.6, 5.6, 58.9, 7, 58, 10, 59, 10.5, 59.5, 11.2, 58.9, 12.4, 56.9, 12.9, 55.6, 14.6, 56.2, 16.5, 57.1, 19, 59.8, 17.3, 60.6, 17.9, 62.6, 21, 64, 22.2, 65.8, 25.2, 65, 21.4, 61.6, 22.5, 60.2, 29, 60.5, 28.8, 59.5, 23.5, 59.3, 24.1, 57.1, 21.3, 57.1, 21.2, 55.2, 18.5, 54.7, 14.3, 54, 11, 54.4, 10.6, 55.5, 10.5, 57.7, 8.1, 56.8, 8.6, 55.4, 8.7, 53.9, 7, 53.5, 4.7, 53, 3.6, 51.5, 1.7, 51, 1.3, 50.1, -1.3, 49.7, -1.6, 48.7, -4.7, 48.6, -4.5, 47.9, -2.2, 47.2, -1.2, 46, -1.8, 43.4, -7.7, 43.8, -9.3, 43, -8.8, 42, -8.9, 37, -6.3, 36.9],
    as: [26.2, 40, 27.2, 37.6, 28.5, 36.6, 30.6, 36.8, 32.5, 36.1, 36, 36.7, 35.9, 35, 35, 33, 34.2, 31.3, 34.9, 29.5, 36.5, 26, 38.1, 24.1, 39.1, 21.7, 41.2, 18.9, 42.6, 15.5, 43.4, 12.7, 45, 12.8, 48.7, 14, 52.2, 15.6, 55.4, 17.6, 58.4, 20.4, 59.8, 22.5, 57.3, 23.9, 56.3, 26.2, 54.2, 24.2, 51.4, 24.3, 51.6, 25.3, 50.2, 26.6, 48.5, 29.9, 50.5, 30, 51.5, 27.8, 54.5, 26.6, 56.3, 27.2, 57.5, 25.7, 61.6, 25.2, 66.6, 25.4, 68.8, 23.5, 72.8, 21, 73, 16, 76.3, 9.5, 77.5, 8, 80.2, 13, 80.3, 15.9, 82.3, 17, 86.9, 21.3, 89, 22, 92, 22, 94, 18, 97.6, 16.5, 98.5, 10, 100, 6, 103, 1.5, 104, 10, 108, 20, 112, 40, 100, 55, 58, 50, 54, 42, 53.9, 37, 49, 37.4, 49.5, 40.5, 44.5, 41.3, 41.6, 41.6, 36, 41.7, 31.2, 41.1, 29, 41.1],
    uk: [-5.7, 50, 1.4, 51.2, 1.7, 52.7, 0, 53.5, -1.6, 55.6, -2, 57.7, -3.1, 58.6, -5, 58.6, -6.2, 57.5, -5.6, 56.2, -4.9, 54.8, -3.2, 54.2, -4.4, 53.4, -4.7, 52.1, -3.4, 51.4, -5.1, 51.6],
    ie: [-6, 52.2, -6.2, 53.9, -7.6, 55.2, -10, 54.2, -9.9, 52, -8, 51.6],
    is: [-24, 64.8, -22, 66.4, -16, 66.5, -13.5, 65.2, -18, 63.4, -22.5, 63.8],
    gr: [-44, 60, -40, 64.5, -32, 68, -22, 70.5, -20, 75, -30, 83, -60, 82, -58, 76, -54, 70, -51, 65, -48, 61],
    sa: [-35, -5.5, -37, -4.7, -39, -3, -44, -2.5, -48, -1, -50, 0, -51, 4, -52.5, 5.5, -57, 6, -60, 8.5, -63, 10.5, -67, 10.6, -71.5, 12, -72.5, 11, -76, 9.5, -77.5, 8, -80, 1, -81, -4, -79, -8, -76, -14, -70.3, -18.5, -70.5, -23, -71.5, -30, -73, -37, -73.5, -43, -74.5, -48, -73, -53, -68.5, -54.5, -65.5, -55, -67, -50, -65.5, -45, -63, -41, -62, -39, -57.5, -38, -56.5, -36.5, -58.5, -34.5, -53.5, -34, -48.5, -28, -48.5, -25.5, -44.5, -23, -41, -22, -39, -17.5, -39, -13.5, -37, -10.5, -35, -7.5]
  };
  const D2R = Math.PI / 180;
  /* ortográfica: ponto (lon, lat) → (x, y) no disco unitário. Um ponto do lado de TRÁS é encostado para FORA do limbo
     (×1.15): a corda entre dois pontos escondidos fica fora do disco e o recorte apaga-a - sem isto ficava uma faixa de mar
     entre a terra e a borda do planeta */
  function proj(lon, lat, lon0, lat0) {
    const p = lat * D2R, l = (lon - lon0) * D2R, p0 = lat0 * D2R;
    let x = Math.cos(p) * Math.sin(l), y = Math.cos(p0) * Math.sin(p) - Math.sin(p0) * Math.cos(p) * Math.cos(l);
    const c = Math.sin(p0) * Math.sin(p) + Math.cos(p0) * Math.cos(p) * Math.cos(l);
    if (c < 0) { const m = Math.hypot(x, y) || 1; x = x / m * 1.15; y = y / m * 1.15; }
    return [x, -y];
  }
  /* costa arredondada: curvas quadráticas pelos pontos médios (os cantos do polígono grosseiro desaparecem). Píxeis inteiros:
     o deslocamento fractal mexe ±6 px de qualquer forma, e as décimas punham a Terra acima dos 15 kB */
  function geoPath(a, cx, cy, r, lon0, lat0) {
    const P = []; for (let i = 0; i < a.length; i += 2) { const q = proj(a[i], a[i + 1], lon0, lat0); P.push([Math.round(cx + q[0] * r), Math.round(cy + q[1] * r)]); }
    const n = P.length, mid = (A, B) => Math.round((A[0] + B[0]) / 2) + ' ' + Math.round((A[1] + B[1]) / 2);
    let s = 'M' + mid(P[n - 1], P[0]); for (let i = 0; i < n; i++) s += 'Q' + P[i][0] + ' ' + P[i][1] + ' ' + mid(P[i], P[(i + 1) % n]); return s + 'Z';
  }
  /* luz e sombra de um planeta (comum a Terra, Lua e Marte): escurecer do limbo + "disco da noite" (um círculo preto
     muito desfocado deslocado para o lado oposto ao Sol) - o terminador sai suave e curvo como numa fotografia */
  function shade(cx, cy, r, nx, ny, nk, op) {
    return {
      d: radial('lm', [[0, '#000000', 0], [.62, '#000000', 0], [.88, '#000000', .28], [1, '#000000', .6]], ' r=".5"') + blurF('nb', f(r * .13), 40),
      b: `<circle cx="${f(cx)}" cy="${f(cy)}" r="${r}" fill="url(#lm)"/><circle cx="${f(cx + nx * r)}" cy="${f(cy + ny * r)}" r="${f(r * nk)}" fill="#000000" fill-opacity="${op}" filter="url(#nb)"/>`
    };
  }
  function svgEarth(W) {
    /* o Sol vem da direita: o disco da noite fica à esquerda e o terminador cruza o Atlântico, à vista (em baixo à esquerda caía
       fora do ecrã - o planeta continua abaixo da borda) */
    const cx = W / 2, cy = 744, r = 252, L0 = 14, P0 = 16, sp = space(W, cx, cy, 11), sh = shade(cx, cy, r, -1.08, .12, 1.02, .9);
    const yl = lat => cy + proj(L0, lat, L0, P0)[1] * r, y0 = yl(72), y1 = yl(-36), off = lat => clamp((yl(lat) - y0) / (y1 - y0), 0, 1).toFixed(3);
    /* cor da terra pela latitude: tundra, floresta temperada, Mediterrâneo, Sara/Arábia, Sahel, Congo, savana, Kalahari */
    const LAND = [[72, '#7E9468'], [60, '#4F7B3B'], [47, '#61833F'], [39, '#8E8F53'], [32, '#C5A467'], [22, '#D6B577'], [15, '#BCA061'], [9, '#6B8638'], [1, '#2F6A2B'], [-10, '#477532'], [-19, '#8A8A4D'], [-27, '#A68F5E'], [-34, '#5F7F42']];
    const land = Object.keys(GEO).filter(k => k !== 'gr').map(k => geoPath(GEO[k], cx, cy, r, L0, P0)).join('');
    const ice = geoPath(GEO.gr, cx, cy, r, L0, P0);
    let d = sp.d + `<clipPath id="ec"><circle cx="${f(cx)}" cy="${cy}" r="${r}"/></clipPath>`
      + radial('oc', [[0, '#3A92EA'], [.42, '#1C64C0'], [.78, '#0D3C8A'], [1, '#082455']], ' cx=".7" cy=".36" r=".85"')
      + `<linearGradient id="ld" gradientUnits="userSpaceOnUse" x1="0" y1="${f(y0)}" x2="0" y2="${f(y1)}">${LAND.map(([la, c]) => stop(off(la), c)).join('')}</linearGradient>`
      /* costas e nuvens: turbulência fractal DENTRO da imagem (rasterizada uma vez); nunca um filter no DOM */
      + `<filter id="ed" x="-5%" y="-5%" width="110%" height="110%"><feTurbulence type="fractalNoise" baseFrequency=".03" numOctaves="3" seed="4"/><feDisplacementMap in="SourceGraphic" scale="13" xChannelSelector="R" yChannelSelector="G"/></filter>`
      /* nuvens com REDEMOINHOS: o ruído fino é deslocado por um ruído largo (domain warping) - sem isto eram riscos horizontais */
      + `<filter id="ek" x="0" y="0" width="100%" height="100%"><feTurbulence type="fractalNoise" baseFrequency=".014 .022" numOctaves="5" seed="9" result="n"/><feTurbulence type="fractalNoise" baseFrequency=".005" numOctaves="2" seed="3" result="w"/><feDisplacementMap in="n" in2="w" scale="70" xChannelSelector="R" yChannelSelector="B" result="s"/><feColorMatrix in="s" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 5.2 0 0 0 -2.72"/><feComposite in2="SourceGraphic" operator="in"/></filter>`
      + radial('sc', [[0, '#7CC0FF', 0], [.8, '#7CC0FF', 0], [.95, '#8ACBFF', .38], [1, '#B7E0FF', .6]], ' r=".5"')
      + radial('gl', [[0, '#FFFFFF', .3], [1, '#FFFFFF', 0]], ' r=".5"')
      + radial('at', [[0, '#5AA8FF', 0], [.885, '#5AA8FF', 0], [.895, '#9AD3FF', .85], [.93, '#4C8FFF', .32], [1, '#2F6BFF', 0]], ` gradientUnits="userSpaceOnUse" cx="${f(cx)}" cy="${cy}" r="${f(r * 1.13)}"`)
      /* a atmosfera só brilha do lado do Sol (máscara da direita para a esquerda) */
      + `<linearGradient id="am" x1="1" y1="0" x2="0" y2="0">${stop(0, '#FFFFFF')}${stop(.45, '#FFFFFF', .85)}${stop(.8, '#FFFFFF', .1)}${stop(1, '#FFFFFF', 0)}</linearGradient><mask id="hm"><rect width="${W}" height="${H}" fill="url(#am)"/></mask>`
      + blurF('rb', 1.6) + sh.d;
    let b = sp.b + `<circle cx="${f(cx)}" cy="${cy}" r="${f(r * 1.13)}" fill="url(#at)" mask="url(#hm)"/>`
      + `<g clip-path="url(#ec)"><circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="url(#oc)"/>`
      + `<g filter="url(#ed)"><path d="${land}" fill="url(#ld)"/><path d="${ice}" fill="#E9EFF5"/><ellipse cx="${f(cx + 20)}" cy="${f(cy - r * .955)}" rx="${f(r * .5)}" ry="${f(r * .085)}" fill="#F1F5F9"/></g>`
      + `<circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="#FFFFFF" filter="url(#ek)" opacity=".92"/>`
      + `<circle cx="${f(cx + r * .42)}" cy="${f(cy - r * .2)}" r="${f(r * .4)}" fill="url(#gl)"/>`
      + `<circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="url(#sc)"/>` + sh.b + `</g>`
      + `<circle cx="${f(cx)}" cy="${cy}" r="${r - .5}" fill="none" stroke="#BFE4FF" stroke-width="2.4" stroke-opacity=".75" filter="url(#rb)" mask="url(#hm)"/>`;
    return svgDoc(W, d, b);
  }
  /* ===== LUA: terras altas claras e lisas, "mares" escuros de contorno orgânico (elipses deslocadas por turbulência e
     desfocadas), grão fino quase invisível e crateras com a luz certa (Sol à direita: a parede de DENTRO do lado esquerdo
     fica iluminada, a do lado direito em sombra, a borda exterior direita brilha); Tycho com os raios claros ===== */
  function svgMoon(W) {
    const cx = W / 2, cy = 736, r = 246, sp = space(W, cx, cy, 13), sh = shade(cx, cy, r, -1.06, .2, 1.02, .9);
    const X = u => f(cx + u * r), Y = v => f(cy + v * r), R = k => f(k * r);
    const MARIA = [[-.34, -.4, .27, .19, -20], [.04, -.37, .15, .13, 10], [.22, -.13, .2, .15, -12], [.6, -.31, .1, .085, 0], [-.58, -.02, .22, .38, 8], [-.16, .26, .16, .11, 15], [.48, .06, .11, .14, -18], [-.3, .48, .11, .07, 0]];
    const CR = [[.3, .44, .065, 1], [-.62, .42, .05, 0], [.12, .62, .04, 0], [-.18, -.64, .055, 0], [.68, -.06, .045, 0], [-.78, -.22, .04, 0], [.32, -.62, .035, 0], [-.42, .16, .045, 0], [.8, .3, .03, 0], [-.04, .74, .04, 0], [.56, .4, .028, 0], [.1, -.02, .025, 0], [-.6, -.5, .032, 0]];
    let d = sp.d + `<clipPath id="ec"><circle cx="${f(cx)}" cy="${cy}" r="${r}"/></clipPath>`
      + radial('mb', [[0, '#F3F1EC'], [.45, '#D8D5CE'], [.85, '#A7A49D'], [1, '#77756F']], ' cx=".64" cy=".4" r=".75"')
      + `<filter id="md" x="-20%" y="-20%" width="140%" height="140%"><feTurbulence type="fractalNoise" baseFrequency=".022" numOctaves="3" seed="6"/><feDisplacementMap in="SourceGraphic" scale="30" xChannelSelector="R" yChannelSelector="G"/><feGaussianBlur stdDeviation="5"/></filter>`
      /* grão: ruído fino → pontos escuros de alfa BAIXO (o "multiplicar" sem feBlend); forte demais parecia esponja */
      + `<filter id="mg" x="0" y="0" width="100%" height="100%"><feTurbulence type="fractalNoise" baseFrequency=".11" numOctaves="2" seed="2"/><feColorMatrix values="0 0 0 0 .25 0 0 0 0 .24 0 0 0 0 .23 .62 0 0 0 -.27"/><feComposite in2="SourceGraphic" operator="in"/></filter>`
      + linear('cr', [[0, '#FFFFFF', .2], [.45, '#55534E', .14], [1, '#2E2D2A', .5]], ' x1="0" y1="0" x2="1" y2="0"')
      + linear('cb', [[0, '#FFFFFF', 0], [.6, '#FFFFFF', .06], [1, '#FFFFFF', .55]], ' x1="0" y1="0" x2="1" y2="0"')
      + radial('ty', [[0, '#FFFFFF', .75], [.45, '#FFFFFF', .22], [1, '#FFFFFF', 0]], ' r=".5"') + sh.d;
    const ty = CR[0];
    let rays = ''; { const Rr = rng(5); for (let i = 0; i < 16; i++) { const a = Rr() * Math.PI * 2, L = r * (.25 + Rr() * .5); rays += `M${X(ty[0])} ${Y(ty[1])}l${f(Math.cos(a) * L)} ${f(Math.sin(a) * L)}`; } }
    let b = sp.b + `<g clip-path="url(#ec)"><circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="url(#mb)"/>`
      + `<g fill="#6E6B65" fill-opacity=".58" filter="url(#md)">${MARIA.map(([u, v, a, e, t]) => `<ellipse cx="${X(u)}" cy="${Y(v)}" rx="${R(a)}" ry="${R(e)}" transform="rotate(${t} ${X(u)} ${Y(v)})"/>`).join('')}</g>`
      + `<circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="#FFFFFF" filter="url(#mg)"/>`
      + `<path d="${rays}" stroke="#FFFFFF" stroke-opacity=".09" stroke-width="2.5" stroke-linecap="round"/>`
      + CR.map(([u, v, k, t]) => (t ? `<circle cx="${X(u)}" cy="${Y(v)}" r="${R(k * 2.4)}" fill="url(#ty)"/>` : '') + `<circle cx="${X(u)}" cy="${Y(v)}" r="${R(k)}" fill="url(#cr)"/><circle cx="${X(u)}" cy="${Y(v)}" r="${R(k)}" fill="none" stroke="url(#cb)" stroke-width="1.6"/>`).join('')
      + sh.b + `</g>`;
    return svgDoc(W, d, b);
  }
  /* ===== MARTE: ferrugem com regiões escuras (Syrtis Major, Acidalium), Valles Marineris, calote polar e uma atmosfera
     rosada muito fina do lado iluminado ===== */
  function svgMars(W) {
    const cx = W / 2, cy = 740, r = 238, sp = space(W, cx, cy, 17), sh = shade(cx, cy, r, .9, .62, 1, .86);
    const X = u => f(cx + u * r), Y = v => f(cy + v * r), R = k => f(k * r);
    const DARK = [[.18, -.12, .2, .32, 18], [-.4, -.5, .3, .13, -10], [-.18, .1, .16, .1, 0], [.55, .28, .18, .1, 25], [-.6, .3, .14, .2, 0], [.05, .5, .28, .09, -5]];
    /* zonas mais claras (ocre/areia, como Arabia Terra e Hellas): partem a cor única de ferrugem */
    const LIGHT = [[-.12, -.3, .22, .12, 10], [.42, -.42, .18, .1, -15], [-.3, .55, .3, .12, 5], [.6, .02, .14, .2, 0]];
    let d = sp.d + `<clipPath id="ec"><circle cx="${f(cx)}" cy="${cy}" r="${r}"/></clipPath>`
      + radial('mb', [[0, '#F2A877'], [.38, '#DB7442'], [.75, '#A9451F'], [1, '#56200E']], ' cx=".36" cy=".34" r=".78"')
      + `<filter id="md" x="-20%" y="-20%" width="140%" height="140%"><feTurbulence type="fractalNoise" baseFrequency=".03" numOctaves="3" seed="12"/><feDisplacementMap in="SourceGraphic" scale="38" xChannelSelector="R" yChannelSelector="G"/><feGaussianBlur stdDeviation="4"/></filter>`
      + `<filter id="mg" x="0" y="0" width="100%" height="100%"><feTurbulence type="fractalNoise" baseFrequency=".06" numOctaves="4" seed="3"/><feColorMatrix values="0 0 0 0 .35 0 0 0 0 .12 0 0 0 0 .05 1.05 0 0 0 -.42"/><feComposite in2="SourceGraphic" operator="in"/></filter>`
      + blurF('pc', 5, 60) + blurF('vm', 2.2)
      + radial('at', [[0, '#FF9A70', 0], [.9, '#FF9A70', 0], [.91, '#FFC2A0', .55], [1, '#FF8A60', 0]], ` gradientUnits="userSpaceOnUse" cx="${f(cx)}" cy="${cy}" r="${f(r * 1.08)}"`)
      + `<linearGradient id="am" x1="0" y1="0" x2="1" y2="1">${stop(0, '#FFFFFF')}${stop(.55, '#FFFFFF', .5)}${stop(.8, '#FFFFFF', 0)}</linearGradient><mask id="hm"><rect width="${W}" height="${H}" fill="url(#am)"/></mask>` + sh.d;
    let b = sp.b + `<circle cx="${f(cx)}" cy="${cy}" r="${f(r * 1.08)}" fill="url(#at)" mask="url(#hm)"/><g clip-path="url(#ec)"><circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="url(#mb)"/>`
      + `<g fill="#F4B27E" fill-opacity=".3" filter="url(#md)">${LIGHT.map(([u, v, a, e, t]) => `<ellipse cx="${X(u)}" cy="${Y(v)}" rx="${R(a)}" ry="${R(e)}" transform="rotate(${t} ${X(u)} ${Y(v)})"/>`).join('')}</g>`
      + `<g fill="#6A2612" fill-opacity=".5" filter="url(#md)">${DARK.map(([u, v, a, e, t]) => `<ellipse cx="${X(u)}" cy="${Y(v)}" rx="${R(a)}" ry="${R(e)}" transform="rotate(${t} ${X(u)} ${Y(v)})"/>`).join('')}</g>`
      + `<circle cx="${f(cx)}" cy="${cy}" r="${r}" fill="#FFFFFF" filter="url(#mg)"/>`
      /* Valles Marineris: um sulco fino e desfocado (grosso e escuro parecia uma boca) */
      + `<path d="M${X(-.6)} ${Y(-.04)}Q${X(-.32)} ${Y(-.15)} ${X(-.02)} ${Y(-.09)}" stroke="#5A1E0C" stroke-opacity=".32" stroke-width="3.5" fill="none" stroke-linecap="round" filter="url(#vm)"/>`
      + `<ellipse cx="${X(-.02)}" cy="${Y(-.93)}" rx="${R(.25)}" ry="${R(.065)}" fill="#FBF3EC" fill-opacity=".85" filter="url(#pc)"/>`
      + sh.b + `</g>`;
    return svgDoc(W, d, b);
  }
  /* ===== SISTEMA SOLAR: o Sol no canto de baixo à esquerda, órbitas em perspetiva e os planetas iluminados do lado do Sol ===== */
  function svgSolar(W) {
    const sx = -34, sy = 884, rot = -21, sp = space(W, W * .62, 320, 23);
    const ORB = [176, 246, 326, 418, 540, 690, 860];
    const rotP = (x, y) => { const a = rot * D2R, dx = x - sx, dy = y - sy; return [sx + dx * Math.cos(a) - dy * Math.sin(a), sy + dx * Math.sin(a) + dy * Math.cos(a)]; };
    const at = (i, deg) => { const t = deg * D2R; return rotP(sx + ORB[i] * Math.cos(t), sy + ORB[i] * .48 * Math.sin(t)); };
    let d = sp.d + radial('co', [[0, '#FFF7DC'], [.1, '#FFE08A', .95], [.24, '#FFA43A', .5], [.5, '#FF6E1C', .14], [1, '#FF5A10', 0]], ' r=".5"')
      + radial('sd', [[0, '#FFFFF6'], [.55, '#FFE27C'], [.85, '#FFAE3A'], [1, '#F2761A']], ' r=".5"')
      + `<filter id="sg" x="0" y="0" width="100%" height="100%"><feTurbulence type="fractalNoise" baseFrequency=".05" numOctaves="3" seed="8"/><feColorMatrix values="0 0 0 0 1 0 0 0 0 .55 0 0 0 0 .1 1.5 0 0 0 -.55"/><feComposite in2="SourceGraphic" operator="in"/></filter>`;
    /* gradiente "esfera" virado para o Sol (que está em baixo à esquerda de todos) */
    const ball = (id, a, m, z) => radial(id, [[0, a], [.55, m], [1, z]], ' cx=".34" cy=".66" r=".78" fx=".26" fy=".74"');
    d += ball('pm', '#D8D3CB', '#9C968C', '#3E3A35') + ball('pv', '#FFF0C8', '#E2C487', '#6E5528') + ball('pe', '#8CC8FF', '#2C74CF', '#0B2552') + ball('pr', '#F7A57C', '#C9532E', '#4E1B0C')
      + ball('ps', '#FFF3CF', '#E3C88E', '#6B5530') + ball('pn', '#C9F1FF', '#5FB6DE', '#163E5A')
      + `<linearGradient id="jb" x1="0" y1="0" x2="0" y2="1">${[['0', '#E9D3B0'], ['.16', '#C9925F'], ['.27', '#EDDCBE'], ['.4', '#B97E52'], ['.5', '#E8D2AE'], ['.62', '#C58C5C'], ['.74', '#EFE0C6'], ['.86', '#BC8558'], ['1', '#D9BC92']].map(s => stop(s[0], s[1])).join('')}</linearGradient>`
      + radial('jsh', [[0, '#000000', 0], [.55, '#000000', .05], [1, '#000000', .72]], ' cx=".3" cy=".7" r=".85"')
      + `<linearGradient id="rg" x1="0" y1="0" x2="1" y2="0">${stop(0, '#D9C496', .2)}${stop(.3, '#EADBB6', .75)}${stop(.5, '#B8A27A', .35)}${stop(.7, '#EADBB6', .75)}${stop(1, '#D9C496', .2)}</linearGradient>`;
    let b = sp.b + `<circle cx="${sx}" cy="${sy}" r="560" fill="url(#co)"/>`
      + `<g fill="none" stroke="#FFFFFF" stroke-width="1.1" transform="rotate(${rot} ${sx} ${sy})">${ORB.map((o, i) => `<ellipse cx="${sx}" cy="${sy}" rx="${o}" ry="${f(o * .48)}" stroke-opacity="${(.2 - i * .015).toFixed(3)}"/>`).join('')}</g>`
      + `<circle cx="${sx}" cy="${sy}" r="118" fill="url(#sd)"/><circle cx="${sx}" cy="${sy}" r="118" fill="#FFFFFF" filter="url(#sg)" opacity=".5"/>`;
    const P = (i, deg, rr, id) => { const [x, y] = at(i, deg); return { x: f(x), y: f(y), r: rr, id }; };
    /* ângulos escolhidos para cada planeta cair DENTRO do ecrã de 440 (fora das notificações e dos botões de baixo) */
    const me = P(0, -6, 6, 'pm'), ve = P(1, -48, 10, 'pv'), ea = P(2, -18, 12, 'pe'), ma = P(3, 6, 8.5, 'pr'), ju = P(4, -60, 30, 'jb'), sa = P(5, -42, 22, 'ps'), ne = P(6, -66, 13, 'pn');
    [me, ve, ea, ma, ne].forEach(p => { b += `<circle cx="${p.x}" cy="${p.y}" r="${p.r}" fill="url(#${p.id})"/>`; });
    /* Terra: um pouco de verde, nuvens e a Lua */
    b += `<path d="M${f(ea.x - 4)} ${f(ea.y - 6)}q4-3 7 1t-2 6t-5-7z" fill="#5E9D49" fill-opacity=".9"/><circle cx="${f(ea.x + 19)}" cy="${f(ea.y - 9)}" r="2.6" fill="url(#pm)"/>`;
    /* Júpiter: faixas + Grande Mancha Vermelha + esfera */
    b += `<circle cx="${ju.x}" cy="${ju.y}" r="${ju.r}" fill="url(#jb)"/><ellipse cx="${f(ju.x + 9)}" cy="${f(ju.y + 8)}" rx="6" ry="3.5" fill="#B5553A" fill-opacity=".85"/><circle cx="${ju.x}" cy="${ju.y}" r="${ju.r}" fill="url(#jsh)"/>`;
    /* Saturno: metade de trás do anel, o planeta, metade da frente */
    const rx = f(sa.r * 2.25), rg = (half) => `<path d="M${f(sa.x - rx)} ${sa.y}a${rx} ${f(rx * .26)} 0 0 ${half} ${f(rx * 2)} 0" fill="none" stroke="url(#rg)" stroke-width="6" transform="rotate(-18 ${sa.x} ${sa.y})"/>`;
    b += rg(1) + `<circle cx="${sa.x}" cy="${sa.y}" r="${sa.r}" fill="url(#ps)"/><circle cx="${sa.x}" cy="${sa.y}" r="${sa.r}" fill="url(#jsh)"/>` + rg(0);
    return svgDoc(W, d, b);
  }
  const ASTRO = { earth: svgEarth, moon: svgMoon, mars: svgMars, solar: svgSolar };

  /* ---------- COR: fundo na matiz + três manchas macias (matiz ±25) como os gradientes "Cor" do iOS ----------
     Sem filtros: as manchas são gradientes radiais a desvanecer (macios por natureza e baratos de rasterizar). */
  const CST = { vibrant: [.9, .55], tone: [.35, .6], deep: [.7, .28], vapor: [.5, .75], bright: [.95, .7] };
  const normColor = c => { let h = +(c && c.hue); h = isFinite(h) ? ((Math.round(h) % 360) + 360) % 360 : 210; return { hue: h, style: CSTYLES.includes(c && c.style) ? c.style : 'vibrant' }; };
  function colorPlan(c) {
    const { hue: h, style } = normColor(c), [s, l] = CST[style];
    /* Vapor: base ESCURA com vapor pastel a subir do fundo (o relógio branco lê-se em cima); os outros: base na própria cor */
    if (style === 'vapor') return { top: hsl(h, .4, .12), bot: hsl(h + 12, .42, .2), blobs: [[.14, 240, 380, h - 25, s, l, .34], [.92, 760, 420, h + 25, s, l, .66], [.3, 1010, 520, h, s, l + .04, .78]] };
    if (style === 'bright') return { top: hsl(h - 6, s, .84), bot: hsl(h + 10, s, .62), blobs: [[.12, 200, 420, h - 25, s, l + .08, .85], [.95, 540, 430, h + 25, s, l, .8], [.32, 940, 500, h, s, l - .1, .85]] };
    return { top: hsl(h - 6, s, clamp(l + .1, 0, .9)), bot: hsl(h + 10, s, clamp(l - .22, .05, 1)), blobs: [[.12, 190, 420, h - 25, s, clamp(l + .12, 0, .92), .9], [.95, 530, 430, h + 25, s, l, .85], [.32, 940, 500, h, s * .95, clamp(l - .14, .04, 1), .9]] };
  }
  function svgColor(c, W) {
    const p = colorPlan(c);
    let d = linear('g', [[0, p.top], [1, p.bot]]) + linear('sh', [[0, '#FFFFFF', .12], [.5, '#FFFFFF', 0]], ' x1="0" y1="0" x2="1" y2="1"');
    let b = `<rect width="${W}" height="${H}" fill="url(#g)"/>`;
    p.blobs.forEach(([x, y, r, h, s, l, o], i) => { const col = hsl(h, s, l); d += radial('b' + i, [[0, col, o], [.55, col, f(o * .45 * 100) / 100], [1, col, 0]], ' r=".5"'); b += `<ellipse cx="${f(W * x)}" cy="${y}" rx="${f(r * Math.max(1, W / 440) ** .5)}" ry="${r}" fill="url(#b${i})"/>`; });
    return svgDoc(W, d, b + `<rect width="${W}" height="${H}" fill="url(#sh)"/>`);
  }

  /* ---------- EMOJI ---------- */
  /* a fonte de cor do Windows primeiro (o CEF do jogo corre em Windows), depois as dos outros sistemas para o browser */
  const EFONT = '"Segoe UI Emoji","Apple Color Emoji","Noto Color Emoji","Segoe UI Symbol",sans-serif';
  const normEmoji = c => {
    let set = Array.isArray(c && c.set) ? c.set.filter(x => typeof x === 'string' && x.trim() && x.length <= 16).slice(0, 6) : [];
    if (!set.length) set = ['😀'];
    return { set, layout: LAYOUTS.includes(c && c.layout) ? c.layout : 'grid', bg: /^#[0-9a-f]{6}$/i.test(c && c.bg) ? c.bg.toUpperCase() : '#FFD60A' };
  };
  /* posições por disposição (x, y, tamanho, rotação, índice do emoji) - as mesmas servem ao canvas e aos "confetes" */
  function emojiPlaces(e, W) {
    const out = [], n = e.set.length;
    if (e.layout === 'grid') {
      /* grelha desencontrada (linhas alternadas meio passo ao lado), em diagonal pela ordem do conjunto */
      const cols = Math.max(5, Math.round(W / 88)), dx = W / cols, dy = 92;
      for (let r = 0; r * dy < H + dy; r++) for (let c = 0; c <= cols; c++) { const off = r % 2 ? 0 : .5; if (off && c === cols) continue; out.push([(c + off) * dx, 40 + r * dy, 52, 0, (r + c) % n]); }
    } else if (e.layout === 'rings') {
      /* anéis concêntricos à volta do meio do ecrã, um emoji por anel */
      const cx = W / 2, cy = 520, far = Math.hypot(Math.max(cx, W - cx), Math.max(cy, H - cy)) + 40;
      out.push([cx, cy, 92, 0, 0]);
      for (let k = 1; 30 + k * 86 < far; k++) { const R = 30 + k * 86, m = Math.round(2 * Math.PI * R / 82); for (let j = 0; j < m; j++) { const a = j / m * 2 * Math.PI + k * .37; out.push([cx + Math.cos(a) * R, cy + Math.sin(a) * R, 48, a + Math.PI / 2, k % n]); } }
    } else if (e.layout === 'spiral') {
      /* espiral de Arquimedes a crescer para fora: o emoji aumenta com o raio */
      const cx = W / 2, cy = 540, far = Math.hypot(W, H) * .62; let t = 0, i = 0;
      while (true) { const R = 10 + 16 * t; if (R > far) break; const s = 22 + R * .1; out.push([cx + Math.cos(t) * R, cy + Math.sin(t) * R, s, t + Math.PI / 2, i++ % n]); t += (s * 1.08) / Math.max(R, 24); }
    } else {
      /* grande: três emojis enormes, ligeiramente rodados */
      [[.28, 478, 182, -.2], [.72, 650, 182, .16], [.34, 822, 182, -.08]].forEach(([x, y, s, a], i) => out.push([W * x, y, s, a, i % n]));
    }
    return out;
  }
  function emojiBg(x, W, bg) {
    x.fillStyle = bg; x.fillRect(0, 0, W, H);
    const g = x.createRadialGradient(W * .5, H * .28, 0, W * .5, H * .28, H * .85); g.addColorStop(0, 'rgba(255,255,255,.2)'); g.addColorStop(.6, 'rgba(255,255,255,0)'); g.addColorStop(1, 'rgba(0,0,0,.14)');
    x.fillStyle = g; x.fillRect(0, 0, W, H);
  }
  function renderEmoji(e, W) {
    const cv = document.createElement('canvas'); cv.width = W; cv.height = H; const x = cv.getContext('2d');
    emojiBg(x, W, e.bg); x.textAlign = 'center'; x.textBaseline = 'middle';
    emojiPlaces(e, W).forEach(([px, py, s, a, i]) => { x.save(); x.translate(px, py); if (a) x.rotate(a); x.font = `${Math.round(s)}px ${EFONT}`; x.fillText(e.set[i], 0, s * .05); x.restore(); });
    return cssUrl(cv.toDataURL('image/jpeg', .85));
  }
  /* SEM fonte de emoji a cores (o teste do emojiOk falhou): discos "confetes" nas cores de cada emoji - nunca quadrados
     vazios (tofu). A cor sai de um hash do próprio emoji, estável. */
  function svgConfetti(e, W) {
    const hue = s => { let h = 0; for (const ch of s) h = (h * 31 + ch.codePointAt(0)) % 3600; return h % 360; };
    let b = `<rect width="${W}" height="${H}" fill="${e.bg}"/><rect width="${W}" height="${H}" fill="url(#v)"/>`;
    emojiPlaces(e, W).forEach(([px, py, s, a, i]) => { const h = hue(e.set[i]), r = f(s * .4); b += `<circle cx="${f(px)}" cy="${f(py)}" r="${r}" fill="${hsl(h, .8, .58)}"/><circle cx="${f(px - r * .3)}" cy="${f(py - r * .3)}" r="${f(r * .38)}" fill="#FFFFFF" fill-opacity=".3"/>`; });
    return svgDoc(W, radial('v', [[0, '#FFFFFF', .18], [.6, '#FFFFFF', 0], [1, '#000000', .14]], ' cx=".5" cy=".28" r=".9"'), b);
  }
  /* fonte de emoji A CORES presente? desenha 😀 num canvas 32×32 e conta píxeis coloridos (uma fonte só a preto e branco
     ou um quadrado vazio não tem nenhum). Fica em cache: a fonte não muda com o telemóvel aberto. */
  let eok = null;
  function emojiOk() {
    if (eok != null) return eok;
    try {
      const c = document.createElement('canvas'); c.width = c.height = 32; const x = c.getContext('2d');
      x.textAlign = 'center'; x.textBaseline = 'middle'; x.font = '26px ' + EFONT; x.fillText('😀', 16, 17);
      const d = x.getImageData(0, 0, 32, 32).data; let n = 0;
      for (let i = 0; i < d.length; i += 4) { if (d[i + 3] < 100) continue; if (Math.max(d[i], d[i + 1], d[i + 2]) - Math.min(d[i], d[i + 1], d[i + 2]) > 40) n++; }
      eok = n >= 20;
    } catch (e) { eok = false; }
    return eok;
  }
  /* ~120 emojis em 6 grupos para o teclado do editor (sem bandeiras: a fonte do Windows não as tem) */
  const CATALOG = [
    { name: 'Caras', list: ['😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇', '🙂', '😉', '😍', '🥰', '😘', '😋', '😎', '🤩', '🥳', '😴'] },
    { name: 'Animais', list: ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐧', '🐦', '🦄', '🐝', '🦋'] },
    { name: 'Comida', list: ['🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🍒', '🍑', '🥭', '🍍', '🥥', '🥑', '🍕', '🍔', '🍟', '🌮', '🍩', '🧁'] },
    { name: 'Atividades', list: ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🥊', '⛳', '🎳', '🛹', '🎮', '🎲', '🎯', '🎸', '🎧', '🎨'] },
    { name: 'Objetos', list: ['📱', '💻', '⌚', '📷', '💡', '🔦', '🎁', '🎈', '🔑', '🧸', '✏️', '📚', '💎', '🚗', '🚀', '✈️', '🚲', '⏰', '🕶️', '👑'] },
    { name: 'Símbolos', list: ['❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '⭐', '🌟', '✨', '⚡', '🔥', '🌈', '☀️', '🌙', '❄️', '🌸', '🍀', '🎵'] }
  ];

  /* ---------- ESTILOS DE FOTO (canvas, píxel a píxel: o filter do canvas existe no CEF mas não faz duotom nem lavado) ---------- */
  function toneData(d, st, W) {
    const A = [27, 27, 58], B = [242, 193, 78], n = d.length, rows = n / 4 / W;
    for (let i = 0; i < n; i += 4) {
      const r = d[i], g = d[i + 1], b = d[i + 2]; let y = .2126 * r + .7152 * g + .0722 * b;
      if (st === 'mono') { y = (y - 128) * 1.14 + 128; d[i] = d[i + 1] = d[i + 2] = y; }
      else if (st === 'duotone') { let t = y / 255; t = t * t * (3 - 2 * t) * .65 + t * .35; d[i] = A[0] + (B[0] - A[0]) * t; d[i + 1] = A[1] + (B[1] - A[1]) * t; d[i + 2] = A[2] + (B[2] - A[2]) * t; }
      else {
        /* lavado: tira 55 % da cor e passa um véu quente (laranja em cima → pêssego em baixo), sem perder as sombras */
        const k = (i / 4 / W) / rows, wr = 255, wg = 156 + 46 * k, wb = 104 + 46 * k;
        const R = r + (y - r) * .55, G = g + (y - g) * .55, Bv = b + (y - b) * .55;
        d[i] = R * .62 + R * wr / 255 * .3 + wr * .06; d[i + 1] = G * .62 + G * wg / 255 * .3 + wg * .06; d[i + 2] = Bv * .62 + Bv * wb / 255 * .3 + wb * .06;
      }
    }
  }
  function renderStyle(c, W, done) {
    let fin = false; const end = v => { if (fin) return; fin = true; done(v); };
    const img = new Image();
    /* só a mesma origem (ou data:) deixa ler os píxeis: um link https sem CORS "suja" o canvas e fica a foto natural */
    if (!/^data:/i.test(c.url)) img.crossOrigin = 'anonymous';
    img.onload = () => { try {
      /* 1.4.1: a cópia fica com a PROPORÇÃO da foto (o lado que falta para cobrir o ecrã, o outro a sobrar) e não recortada à do ecrã: o
         enquadramento (custom.crop) anda sobre o mesmo quadro em qualquer estilo, senão ao mudar para Preto e branco a foto saltava e as
         partes de fora do ecrã deixavam de existir. O background-size:cover da camada dá exatamente o corte de antes. */
      /* teto de 2400 com UM só fator: limitar cada lado à parte deformava a foto (720×1565 no dobrável aberto ficava 21 % esmagada) */
      const iw = img.naturalWidth || W, ih = img.naturalHeight || H, k = Math.min(Math.max(W / iw, H / ih), 2400 / Math.max(iw, ih)), CW = Math.round(iw * k), CH = Math.round(ih * k);
      const cv = document.createElement('canvas'); cv.width = CW; cv.height = CH; const x = cv.getContext('2d');
      x.drawImage(img, 0, 0, CW, CH);
      const id = x.getImageData(0, 0, CW, CH); toneData(id.data, c.style, CW); x.putImageData(id, 0, 0);
      end(cssUrl(cv.toDataURL('image/jpeg', .85)));
    } catch (e) { end(null); } };
    img.onerror = () => end(null);
    setTimeout(() => end(null), 20000);   /* uma imagem que nunca responde não prende a fila */
    img.src = abs(c.url);
  }

  /* ---------- FOTOS ALEATÓRIAS ---------- */
  /* candidatas: as fotos (sem vídeos) da galeria, as mais recentes primeiro; "Favoritas" sem nenhuma favorita usa todas
     (um fundo cinzento por não haver favoritas parecia avaria) */
  function candidates(c) {
    const P = window.Photos && Array.isArray(Photos.cache) ? Photos.cache : [];
    let l = P.filter(p => p && p.id != null && !p.video);
    if (c && c.from === 'favorites') { const fv = l.filter(p => p.favorite); if (fv.length) l = fv; }
    return l.slice().sort((a, b) => (+b.created || 0) - (+a.created || 0));
  }
  /* a lista das Fotos só existe depois de Photos.load() (a app abrir) - pede-se uma vez, no máximo a cada 30 s */
  let photosAt = 0;
  function ensurePhotos() {
    if (!window.Photos || !Photos.load || (Array.isArray(Photos.cache) && Photos.cache.length)) return;
    if (!(window.System && System.ready) || Date.now() - photosAt < 30000) return;
    photosAt = Date.now();
    Promise.resolve().then(() => Photos.load()).then(() => { if (candidates({}).length) changed('shuffle'); }, () => {});
  }
  /* o base64 de uma foto chega aos bocados (Photos.data): pede-se À FRENTE da fila e repinta-se quando chegar */
  const fetching = new Set();
  function fetchPhoto(p) {
    if (!window.Photos || !Photos.data || fetching.has(p.id)) return;
    fetching.add(p.id);
    Promise.resolve().then(() => Photos.data(p, true)).then(u => { fetching.delete(p.id); if (u) changed('shuffle'); }, () => fetching.delete(p.id));
  }
  function resolve(c) {
    if (!c || c.kind !== 'shuffle') return null;
    const l = candidates(c); if (!l.length) { ensurePhotos(); return null; }
    const p = l.find(x => String(x.id) === String(c.cur)) || l[0];
    if (!p.url && p.len) fetchPhoto(p);
    return { url: typeof p.url === 'string' && /^(data:image\/|https?:)/i.test(p.url) ? p.url : null, seed: p.seed != null ? p.seed : null, id: p.id };
  }
  /* a seguinte, pela data, em ciclo; não grava nada (quem chama decide) */
  function advance(c) {
    const o = Object.assign({}, c || {}, { kind: 'shuffle', from: c && c.from === 'favorites' ? 'favorites' : 'all', every: EVERY.includes(c && c.every) ? c.every : 'hour', at: Date.now() });
    const l = candidates(o); if (!l.length) { o.cur = c && c.cur != null ? c.cur : null; return o; }
    const i = l.findIndex(p => String(p.id) === String(c && c.cur));
    o.cur = l[(i + 1) % l.length].id; return o;
  }
  const SHUF0 = 'linear-gradient(165deg,#5B6474 0%,#2A2F3A 55%,#14161C 100%)';
  function shuffleCss(c) { const r = resolve(c); if (!r) return SHUF0; if (r.url) return cssUrl(r.url); return r.seed != null && window.photoBg ? photoBg(r.seed) : SHUF0; }

  /* ---------- assinatura, cache, fila ---------- */
  function sig(c) {
    if (!c || typeof c !== 'object') return '';
    if (c.kind === 'emoji') { const e = normEmoji(c); return JSON.stringify(['emoji', e.set, e.layout, e.bg]); }
    if (c.kind === 'weather') return '["weather"]';
    if (c.kind === 'astro') return JSON.stringify(['astro', BODIES.includes(c.body) ? c.body : 'earth']);
    if (c.kind === 'color') { const k = normColor(c); return JSON.stringify(['color', k.hue, k.style]); }
    if (c.kind === 'shuffle') return JSON.stringify(['shuffle', c.from === 'favorites' ? 'favorites' : 'all', EVERY.includes(c.every) ? c.every : 'hour', c.cur == null ? null : c.cur]);
    if (isStyled(c)) return JSON.stringify(['style', c.style, c.url.length, c.url.slice(-32)]);
    return '';
  }
  /* SVG (data URI) → JPEG num canvas do mesmo tamanho; um data: SVG sem foreignObject não suja o canvas no Chromium. Falhou → null
     (quem chama fica com o SVG). O alto é sempre 956 (os SVG dos tipos são W × 956, ver makeBlur que lê o viewBox). */
  const ASTRO_BG = 'radial-gradient(120% 70% at 50% 35%,#0d1426 0%,#05070d 60%,#000 100%)';
  function rasterSvg(v, W, cb) {
    const m = /^url\('([\s\S]*)'\)$/.exec(String(v || '')); if (!m) { cb(null); return; }
    const img = new Image(); let fin = false; const end = x => { if (fin) return; fin = true; cb(x); };
    const t = setTimeout(() => end(null), 8000);
    img.onload = () => { clearTimeout(t); try { const cv = document.createElement('canvas'); cv.width = W; cv.height = 956; const x = cv.getContext('2d'); x.fillStyle = '#000'; x.fillRect(0, 0, W, 956); x.drawImage(img, 0, 0, W, 956); end(cssUrl(cv.toDataURL('image/jpeg', .9))); } catch (e) { end(null); } };
    img.onerror = () => { clearTimeout(t); end(null); };
    img.src = m[1];
  }
  /* cache por chave (sig + largura [+ balde do tempo]); os data URL dos canvas pesam ~100 kB - limite de 40 entradas */
  const cache = new Map();
  const put = (k, v) => { cache.delete(k); cache.set(k, v); while (cache.size > 40) cache.delete(cache.keys().next().value); return v; };
  const get = k => { if (!cache.has(k)) return null; const v = cache.get(k); cache.delete(k); cache.set(k, v); return v; };
  /* UM trabalho de canvas de cada vez, com um respiro entre eles: abrir a galeria com seis emojis não congela o toque */
  const jobs = [], pending = new Set(); let busy = false;
  function enqueue(key, s, run) { if (pending.has(key)) return; pending.add(key); jobs.push({ key, s, run }); pump(); }
  function pump() {
    if (busy || !jobs.length) return; busy = true;
    setTimeout(() => { const j = jobs.shift(); let done = false;
      const fin = v => { if (done) return; done = true; pending.delete(j.key); if (v) put(j.key, v); busy = false; ready(j.s); pump(); };
      try { j.run(fin); } catch (e) { console.error('[apex_phone] WallKinds', e); fin(null); } }, 30);
  }
  /* os fundos que estão no ecrã agora (o bloqueado usa o da home quando lockWallpaper é null) */
  function current() { const s = window.System && System.state; if (!s) return []; const lw = s.lockWallpaper; return [lw ? lw.custom : s.wallpaperCustom, s.wallpaperCustom].filter(Boolean); }
  /* repintura agrupada (50 ms). Com o telemóvel GUARDADO (body.hidden, sem espreitar) fica para o próximo phone:open:
     o canvas do desfoque do makeBlur não precisa de correr para um ecrã que ninguém vê */
  let rT = null, dirty = false;
  const pocket = () => { const b = document.body; return !!(b && b.classList.contains('hidden') && !b.classList.contains('pk')); };
  function repaintSoon() {
    if (pocket()) { dirty = true; return; }
    clearTimeout(rT); rT = setTimeout(() => { rT = null; try { if (window.System && System.repaintWallpaper) System.repaintWallpaper(); } catch (e) { console.error('[apex_phone] repaintWallpaper', e); } }, 50);
  }
  function ready(s) { try { Bridge.emit('wallkind:ready', s); } catch (e) {} if (current().some(c => needs(c) && sig(c) === s)) repaintSoon(); }
  /* um tipo mudou por fora (fotos chegaram, o tempo mudou): avisa as miniaturas e repinta se estiver em uso */
  function changed(kind) {
    const mine = current().filter(c => c.kind === kind);
    try { const l = kind === 'weather' ? ['["weather"]'] : [...new Set(mine.map(sig))]; (l.length ? l : [JSON.stringify([kind])]).forEach(s => Bridge.emit('wallkind:ready', s)); } catch (e) {}
    if (mine.length) repaintSoon();
  }

  /* ---------- API ---------- */
  function css(c) {
    if (!needs(c)) return c && typeof c.url === 'string' && c.url ? cssUrl(abs(c.url)) : (c && c.css) || (c && c.seed && window.photoBg ? photoBg(c.seed) : '');
    if (c.kind === 'shuffle') return shuffleCss(c);   /* sem cache: a foto pode chegar depois com a mesma receita */
    const W = SW(), s = sig(c), wk = c.kind === 'weather' ? wxKey() : '', key = s + '|' + W + (wk ? '|' + wk : '');
    if (wk) lastWx = wk;
    const hit = get(key); if (hit) return hit;
    try {
      if (c.kind === 'weather') return put(key, svgUri(svgWeather(W)));
      /* astronomia: os SVG da Terra/Marte/Lua usam feTurbulence + feDisplacementMap (50-60 ms a rasterizar a 440×956, ~220 ms ao
         dobro) e uma camada de ecrã inteiro volta a rasterizar sempre que muda de tamanho (dobrável, escala, fim da animação da
         galeria). Desenha-se o SVG UMA vez num canvas (fila, como o emoji) e o ecrã usa o JPEG; até lá, o céu estrelado escuro. */
      if (c.kind === 'astro') { const svg = svgUri((ASTRO[c.body] || svgEarth)(W)); enqueue(key, s, done => rasterSvg(svg, W, v => done(v || svg))); return ASTRO_BG; }
      if (c.kind === 'color') return put(key, svgUri(svgColor(c, W)));
      if (c.kind === 'emoji') {
        const e = normEmoji(c);
        if (!emojiOk()) return put(key, svgUri(svgConfetti(e, W)));
        enqueue(key, s, done => { let v = null; try { v = renderEmoji(e, W); } catch (err) { v = svgUri(svgConfetti(e, W)); } done(v); });
        return `linear-gradient(${e.bg},${e.bg})`;
      }
      /* estilo de foto: a natural enquanto desenha; se o canvas ficar sujo/falhar, a natural PARA SEMPRE nesta receita */
      const nat = cssUrl(abs(c.url));
      enqueue(key, s, done => renderStyle(c, W, v => done(v || nat)));
      return nat;
    } catch (e) { console.error('[apex_phone] WallKinds.css', e); return c.kind === 'emoji' ? `linear-gradient(${normEmoji(c).bg},${normEmoji(c).bg})` : SHUF0; }
  }
  /* ---------- ENQUADRAMENTO das fotos (1.4.1) ----------
     custom.crop = { x: 0..1, y: 0..1, s: 1..2.5, a } no custom de um fundo de imagem ({ url [, style] }): x/y = background-position em %,
     s = zoom por cima do "cover", a = largura/altura da foto. O `a` é preciso porque o background-size não sabe multiplicar o cover:
     "120%" é a largura e numa foto deitada (16:9) a altura ficava curta e via-se o fundo; com a proporção escolhe-se o eixo que manda
     (foto mais larga do que a caixa → a altura, senão a largura), para cada caixa: ecrã, cartão, Fold, miniatura quadrada. Sem `a`
     (uma receita à mão) vale a largura. Só receita: uns bytes de JSON, nada de imagens recortadas no estado. */
  const CROP_S = 2.5;
  function cropOf(c) { const k = c && typeof c === 'object' && !c.kind && c.url && c.crop; if (!k || typeof k !== 'object') return null;
    const n = (v, d) => isFinite(+v) && v !== null && v !== '' ? +v : d;
    return { x: clamp(n(k.x, .5), 0, 1), y: clamp(n(k.y, .5), 0, 1), s: clamp(n(k.s, 1), 1, CROP_S), a: +k.a > 0 ? +k.a : 0 }; }
  /* { size, pos } para uma caixa w × h (por omissão o ecrã), ou null sem enquadramento: quem pinta volta ao cover/center da classe */
  function cropCss(c, w, h) { const k = cropOf(c); if (!k) return null; const W = w > 0 ? w : SW(), H2 = h > 0 ? h : H, pc = +(k.s * 100).toFixed(2) + '%';
    return { size: k.a && k.a > W / H2 ? 'auto ' + pc : pc + ' auto', pos: +(k.x * 100).toFixed(2) + '% ' + +(k.y * 100).toFixed(2) + '%' }; }
  function dark(c) {
    if (!c || typeof c !== 'object') return true;
    if (c.kind === 'weather') { const n = wxNow(); return lum(skyOf(n.c, n.ph)[0]) < .55; }
    if (c.kind === 'color') return lum(colorPlan(c).top) < .6;
    if (c.kind === 'emoji') return lum(normEmoji(c).bg) < .6;
    return true;   /* astronomia, fotos aleatórias e estilos de foto: o relógio branco lê-se por cima */
  }
  const name = c => !c ? '' : isKind(c) ? NAMES.kind[c.kind] : isStyled(c) ? NAMES.style[c.style] : '';
  const presets = {
    emoji: [
      { set: ['😀', '😍', '🥳'], layout: 'grid', bg: '#FFD60A' },
      { set: ['🐶', '🐱', '🐼'], layout: 'rings', bg: '#9BD9FF' },
      { set: ['🍓', '🍒', '🍑'], layout: 'spiral', bg: '#FFB3C1' },
      { set: ['⚽', '🏀', '🎾'], layout: 'grid', bg: '#34C759' },
      { set: ['🌸', '🌼', '🌷'], layout: 'large', bg: '#BBA9FF' },
      { set: ['🚀', '🌙', '⭐'], layout: 'spiral', bg: '#1C1C3A' }
    ],
    astro: BODIES.slice(), color: CSTYLES.slice(), shuffle: { from: 'all', every: 'hour' }
  };

  /* ---------- AO VIVO ---------- */
  /* Meteorologia: repinta quando muda a condição ou a fase do dia (o 'gameTime' chega a cada hora do jogo; o desenho só
     muda 4 vezes por dia + quando o tempo muda) */
  function wxTick() { const k = wxKey(); if (k === lastWx) return; lastWx = k; changed('weather'); }
  /* Fotos aleatórias: ao acordar (cada phone:open), a cada hora (60 s de relógio a verificar o `at`) ou uma vez por dia.
     UMA escrita de estado por troca: os dois espaços (bloqueado/principal) que tenham a mesma receita recebem o MESMO
     objeto novo (o par continua par) e a entrada atual de lockScreens vai no mesmo setState. */
  function due(c, wake) {
    if (!c || c.kind !== 'shuffle') return false; const at = +c.at || 0, now = Date.now();
    if (c.every === 'wake') return !!wake;
    if (c.every === 'day') return new Date(at).toDateString() !== new Date(now).toDateString();
    return now - at >= 3600e3;
  }
  function shuffleTick(wake) {
    const S = window.System; if (!S || !S.state || !S.ready) return;
    /* nunca debaixo do editor/galeria do bloqueado: o fundo mudava nas mãos de quem está a personalizar */
    try { const X = window.LockGallery && LockGallery._x; if (X && X.isOpen && X.isOpen()) return; } catch (e) {}
    const s = S.state, lw = s.lockWallpaper, lockC = lw && lw.custom, homeC = s.wallpaperCustom;
    const lockDue = due(lockC, wake), homeDue = due(homeC, wake); if (!lockDue && !homeDue) return;
    if (candidates(lockDue ? lockC : homeC).length < 2) return;   /* uma foto só: não há para onde trocar */
    const map = new Map(), adv = c => { const k = sig(c); if (!map.has(k)) map.set(k, advance(c)); return map.get(k); };
    const patch = {};
    if (lockDue) patch.lockWallpaper = Object.assign({}, lw, { custom: adv(lockC) });
    if (homeDue) patch.wallpaperCustom = adv(homeC);
    if (Array.isArray(s.lockScreens) && s.lockCurrent != null) {
      let ch = false; const nx = c => c && c.kind === 'shuffle' && map.get(sig(c));
      const ls = s.lockScreens.map(e => { if (!e || e.id !== s.lockCurrent) return e; let o = e; const a = nx(e.custom); if (a) { o = Object.assign({}, o, { custom: a }); ch = true; }
        const h = e.home && nx(e.home.custom); if (h) { o = Object.assign({}, o, { home: Object.assign({}, e.home, { custom: h }) }); ch = true; } return o; });
      if (ch) patch.lockScreens = ls;
    }
    S.setState(patch);
  }
  if (window.Bridge && Bridge.on) {
    Bridge.on('wx:changed', wxTick); Bridge.on('gameTime', () => setTimeout(wxTick, 0));
    Bridge.on('phone:open', () => { wxTick(); if (dirty) { dirty = false; repaintSoon(); } try { shuffleTick(true); } catch (e) { console.error('[apex_phone] shuffle', e); } });
    Bridge.on('ready', () => { if (current().some(c => c.kind === 'shuffle')) ensurePhotos(); });
    Bridge.on('photos', () => { if (current().some(c => c.kind === 'shuffle')) changed('shuffle'); });
  }
  /* relógio lento (60 s): só a hora das Fotos aleatórias e a fase do dia sem 'gameTime' (browser); com o telemóvel
     guardado não faz nada - acorda no phone:open */
  setInterval(() => { if (pocket()) return; try { wxTick(); shuffleTick(false); } catch (e) {} }, 60000);

  return {
    KINDS, STYLES: PSTYLES, BODIES, CSTYLES, LAYOUTS, EVERY, NAMES,
    isKind, needs, css, sig, resolve, advance, name, dark, presets, cropOf, cropCss, CROP_S,
    emojiCatalog: () => CATALOG.map(g => ({ name: g.name, list: g.list.slice() })), emojiOk,
    /* para quem desenha pré-visualizações: o tom do céu de agora e o balde do tempo */
    wxKey, styleName: s => NAMES.style[s] || NAMES.style.natural
  };
})();
