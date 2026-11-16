/* ============================================================
   ÍCONES - app icons PearOS (desenhados em SVG, sem assets Apple)
   + ícones das apps RP + glifos de UI (24×24, stroke)
   ============================================================ */
window.Icons = (() => {
  /* ---- "Liquid Glass" (PearOS 26 / PearPhone 18): brilho no topo, aro interior claro, sombra suave em baixo e profundidade nos glifos ----
     Os ids são iguais em todos os ícones (definições idênticas), por isso podem coexistir na mesma página. */
  /* PearOS 26 (revisão 2026-09-08): camadas fundo → glifo → REFLEXO SUAVE de cima para baixo (sem "cap" curvo à PearOS 6), brilho muito ténue, aro interior fino e uniforme; nada de bevel/gloss */
  const GLASS_DEFS = `<defs><linearGradient id="iSheen" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".16"/><stop offset=".5" stop-color="#fff" stop-opacity=".02"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient><radialGradient id="iGlow" cx="28%" cy="-6%" r="78%"><stop offset="0" stop-color="#fff" stop-opacity=".14"/><stop offset=".65" stop-color="#fff" stop-opacity="0"/></radialGradient><linearGradient id="iRim" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".42"/><stop offset=".5" stop-color="#fff" stop-opacity=".08"/><stop offset="1" stop-color="#fff" stop-opacity=".22"/></linearGradient><linearGradient id="iShade" x1="0" y1="0" x2="0" y2="1"><stop offset=".6" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".12"/></linearGradient><filter id="iGl" x="-20%" y="-20%" width="140%" height="140%"><feDropShadow dx="0" dy="1.4" stdDeviation="1.3" flood-color="#000" flood-opacity=".26"/></filter></defs>`;
  const GLASS = `<rect width="100" height="100" fill="url(#iShade)"/><rect width="100" height="100" fill="url(#iGlow)"/><rect width="100" height="100" fill="url(#iSheen)"/><rect x="1" y="1" width="98" height="98" rx="26" fill="none" stroke="url(#iRim)" stroke-width="1.6"/>`;
  /* ---- DEFINIÇÕES DO VIDRO: UMA vez no documento ----
     Cada ícone repetia as mesmas 17 definições (4 gradientes com 10 <stop> + o filtro) - mais de
     metade dos nós de cada tile. A home com ~28 ícones eram ~480 nós de SVG em cópia, reconstruídos
     a cada Home.render e a pesar em cada recálculo de estilo (tema, accent, --scale). Num SVG inline,
     `url(#iSheen)` resolve no documento inteiro, por isso basta existirem uma vez.
     · o contentor NÃO pode ser display:none (o Chromium não pinta gradientes/filtros de dentro de
       uma subárvore sem caixa) - fica com 0×0 fora do fluxo;
     · vai para o INÍCIO do body: com ids repetidos ganha o primeiro na ordem do documento, e assim
       é sempre este (visível) e nunca um tile escondido numa camada fechada;
     · se ainda não houver body (script no <head> de um harness), o ícone leva as definições
       inline como dantes - nunca sai um ícone sem vidro. */
  let defsEl = null;
  const defsReady = () => {
    if (defsEl && defsEl.isConnected) return true;
    const b = typeof document !== 'undefined' && document.body; if (!b) return false;
    defsEl = document.getElementById('iconGlassDefs');
    if (!defsEl) {
      defsEl = document.createElement('div'); defsEl.id = 'iconGlassDefs'; defsEl.setAttribute('aria-hidden', 'true');
      defsEl.style.cssText = 'position:absolute;width:0;height:0;overflow:hidden;pointer-events:none';
      defsEl.innerHTML = `<svg width="0" height="0" xmlns="http://www.w3.org/2000/svg" focusable="false">${GLASS_DEFS}</svg>`;
    }
    b.insertBefore(defsEl, b.firstChild);
    return true;
  };
  const SVG = (inner, noGlass) => `<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">${defsReady() ? '' : GLASS_DEFS}${inner}${noGlass ? '' : GLASS}</svg>`;
  const GL = inner => `<g filter="url(#iGl)">${inner}</g>`;
  const G = (id, a, b, c) => `<defs><linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${a}"/>${c ? `<stop offset=".55" stop-color="${b}"/><stop offset="1" stop-color="${c}"/>` : `<stop offset="1" stop-color="${b}"/>`}</linearGradient></defs><rect width="100" height="100" fill="url(#${id})"/>`;
  const MESES = ['JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SET','OUT','NOV','DEZ'];
  /* mês do ícone do Calendário no idioma escolhido (fora do português, o Intl em maiúsculas) */
  const calMon = d => { if (window.L && L.code && L.code !== 'pt' && L.intl) { try { const s = new Intl.DateTimeFormat(L.intl(), { month: 'short' }).format(d).replace(/\.$/, ''); return s.toLocaleUpperCase(L.intl()); } catch (e) {} } return MESES[d.getMonth()]; };
  const PHONE_PATH = 'M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z';

  /* ============================================================
     ESTILOS DOS ÍCONES (PearOS 27 · 1.4.0): Predefinido | Escuro | Transparente | Colorido (matiz + saturação, tom Claro/Escuro).
     Regra do CEF: nada de filter (nem hue-rotate, nem saturate) e nada de color-mix. Por isso o SVG de cada ícone é REESCRITO antes
     de virar imagem: o FUNDO (o bloco do G(), o retângulo liso do Mapas/Notas/etiquetas, os gradientes que cobrem o quadrado inteiro
     do Instashot/IA) e as CORES DO GLIFO são trocados por cores calculadas aqui, sempre em hex/rgba.
       · Escuro: fundo quase preto com um resto da cor original; glifo de uma cor só (branco) passa a ter a cor da app (o degradê do
         fundo vai para o glifo, como o Telefone verde em fundo preto); ícones de fundo BRANCO (Calendário, Relógio, Notas...) invertem
         os neutros (o mostrador branco fica escuro, os ponteiros pretos ficam claros);
       · Transparente: fundo fora (o vidro vem do CSS, homecustom.css) e o glifo todo branco, com a opacidade a seguir a luminosidade;
       · Colorido: fundo no degradê da cor escolhida (escuro no tom Escuro, a cor viva no tom Claro, como na fotografia) e o glifo
         mapeado pela luminosidade entre um tom escuro e um tom claro da mesma cor.
     A luminosidade dos ícones de fundo claro é lida AO CONTRÁRIO nos neutros: é o que faz os ponteiros do Relógio e o dia do
     Calendário ficarem claros em fundo escuro, sem um desenho próprio por ícone.
     Os ids dos gradientes de um ícone estilizado levam um sufixo do estilo: num SVG inline (pastas, Relógio, Biblioteca) ids
     repetidos resolvem para o PRIMEIRO no documento, e um ícone Predefinido ainda montado noutro sítio pintaria o Escuro. */
  const MODES = ['default', 'dark', 'clear', 'tinted'];
  const GLASS_IDS = new Set(['iSheen', 'iGlow', 'iRim', 'iShade', 'iGl']);
  let STYLE = { mode: 'default', hue: 210, sat: .7, tone: 'light' }, sigS = 'default', liveStale = false;
  const c01 = v => v < 0 ? 0 : v > 1 ? 1 : v;
  /* assinatura do DESENHO: o Transparente não depende da cor nem do tom (o material do quadrado é CSS), o Escuro também não -
     mudar o tom num deles não refaz nenhum ícone */
  const sigOf = st => st.mode === 'tinted' ? `tinted,${Math.round(st.hue)},${(+st.sat).toFixed(2)},${st.tone}` : st.mode;
  const sfxOf = st => st.mode === 'tinted' ? `t${Math.round(st.hue)}x${Math.round(st.sat * 100)}${st.tone === 'dark' ? 'd' : 'l'}` : st.mode.charAt(0) + 'k';
  const normStyle = s => { s = s || {}; const n = v => typeof v === 'number' ? v : parseFloat(v), h = n(s.hue), t = n(s.sat);
    return { mode: MODES.includes(s.mode) ? s.mode : 'default', hue: isFinite(h) ? ((h % 360) + 360) % 360 : 210, sat: isFinite(t) ? c01(t) : .7,
      tone: s.tone === 'dark' ? 'dark' : s.tone === 'auto' ? (window.System && System.state && System.state.dark ? 'dark' : 'light') : 'light' }; };
  /* ---- cores (tudo em JS: o CEF não faz contas de cor no CSS) ---- */
  const NAMED = { white: [255, 255, 255], black: [0, 0, 0] };
  const pc = v => { v = String(v == null ? '' : v).trim().toLowerCase(); let m;
    if ((m = /^#([0-9a-f]{3,8})$/.exec(v))) { let h = m[1]; if (h.length < 5) h = h.split('').map(c => c + c).join(''); if (h.length !== 6 && h.length !== 8) return null;
      return [parseInt(h.slice(0, 2), 16), parseInt(h.slice(2, 4), 16), parseInt(h.slice(4, 6), 16), h.length === 8 ? parseInt(h.slice(6, 8), 16) / 255 : 1]; }
    if ((m = /^rgba?\(([^)]+)\)$/.exec(v))) { const p = m[1].split(/[\s,/]+/).filter(Boolean).map(parseFloat); if (p.length < 3 || p.slice(0, 3).some(isNaN)) return null; return [p[0], p[1], p[2], p.length > 3 && !isNaN(p[3]) ? p[3] : 1]; }
    return NAMED[v] ? NAMED[v].concat(1) : null; };
  const hsl = (h, s, l) => { h = (((h % 360) + 360) % 360) / 360; s = c01(s); l = c01(l); if (!s) { const v = l * 255; return [v, v, v]; }
    const q = l < .5 ? l * (1 + s) : l + s - l * s, p = 2 * l - q, f = t => { t = t < 0 ? t + 1 : t > 1 ? t - 1 : t; return t < 1 / 6 ? p + (q - p) * 6 * t : t < .5 ? q : t < 2 / 3 ? p + (q - p) * (2 / 3 - t) * 6 : p; };
    return [f(h + 1 / 3) * 255, f(h) * 255, f(h - 1 / 3) * 255]; };
  const hex = c => '#' + c.slice(0, 3).map(v => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('').toUpperCase();
  const out = (c, a) => (a == null || a >= .995) ? hex(c) : `rgba(${c.slice(0, 3).map(v => Math.round(Math.max(0, Math.min(255, v)))).join(',')},${Math.max(0, a).toFixed(3)})`;
  const lum = c => Math.sqrt(.299 * (c[0] / 255) ** 2 + .587 * (c[1] / 255) ** 2 + .114 * (c[2] / 255) ** 2);   /* luminosidade percebida (HSP) */
  const chroma = c => (Math.max(c[0], c[1], c[2]) - Math.min(c[0], c[1], c[2])) / 255;
  const mixc = (a, b, t) => [0, 1, 2].map(i => a[i] + (b[i] - a[i]) * t);
  /* Colorido: tom Escuro = quadrado escuro com o glifo claro tingido (spec); tom Claro = a cor viva com o glifo quase branco
     (a fotografia do PearOS 27, com "Light" escolhido: ícones cor-de-rosa com o desenho rosa-claro) */
  const palette = st => { const h = st.hue, s = c01(st.sat);
    return st.tone === 'dark' ? { top: hsl(h, s * .5, .25), bot: hsl(h, s * .58, .12), hi: hsl(h, s * .82, .82), lo: hsl(h, s * .5, .34) }
      : { top: hsl(h, s * .74, .52), bot: hsl(h, s * .8, .35), hi: hsl(h, s * .5, .94), lo: hsl(h, s * .62, .30) }; };
  const DK_T = [50, 50, 54], DK_B = [13, 13, 15];   /* Escuro: topo e base do quadrado (o PearOS também clareia o topo) */
  const tintCurve = Le => Math.pow(c01((Le - .16) / .84), 1.5);   /* sol do Meteorologia (.9) fica um pouco mais escuro do que a nuvem branca (1) */
  /* Transparente: por alfa só se clareia (branco por cima de branco é branco), por isso as partes ESCURAS de um glifo claro (a lente da
     Câmara, a aba do Mail) passam a preto translúcido - "recortes" que deixam ver o vidro; as claras ficam brancas. Nos ícones de fundo
     branco os neutros medem-se pelo CONTRASTE com o papel: o preto (#111 do dia do Calendário) fica branco forte, o cinzento-claro das
     linhas fica branco ténue - nunca recorte. */
  const clearCol = (c, lightNeutral) => { const L = lum(c), a = c[3];
    if (lightNeutral) return out([255, 255, 255], a * (.12 + .88 * Math.pow(c01(1 - L), 1.1)));
    return L >= .5 ? out([255, 255, 255], a * (.35 + .65 * Math.pow((L - .5) / .5, .9))) : out([0, 0, 0], a * (.18 + .4 * (.5 - L) / .5)); };
  /* ---- percorrer as etiquetas do SVG com o contexto de cada uma (fundo, glifo ou vidro) ---- */
  const TAG = /<(\/?)([a-zA-Z][\w:.-]*)([^>]*?)(\/?)>/g;
  const SHAPES = new Set(['rect', 'path', 'circle', 'ellipse', 'line', 'polyline', 'polygon', 'text', 'image', 'use']);
  const CATTR = /(\s(?:fill|stroke|stop-color)=")([^"]*)(")/g, CSTYLE = /(\b(?:fill|stroke|stop-color)\s*:\s*)([^;"]+)/g;
  const BGREF = /<rect width="100" height="100" fill="url\(#([^)"]+)\)"/g;
  function walk(s, bg, fn) {
    let grad = null, dep = 0, quiet = 0, first = true;   /* dep: dentro de <defs>; quiet: <mask>/<clipPath>/<filter> (aí as cores têm outro sentido: nunca se mexe) */
    return s.replace(TAG, (m, cl, tag, attrs, sc) => {
      const t = tag.toLowerCase();
      if (cl) { if (t === 'lineargradient' || t === 'radialgradient') grad = null; else if (t === 'defs') dep = Math.max(0, dep - 1); else if (t === 'mask' || t === 'clippath' || t === 'filter') quiet = Math.max(0, quiet - 1); return m; }
      if (t === 'lineargradient' || t === 'radialgradient') { if (!sc) { const im = /\bid="([^"]*)"/.exec(attrs), cy = /\bcy="(-?[\d.]+)(%?)"/.exec(attrs); grad = { id: im ? im[1] : '', radial: t === 'radialgradient', low: !!cy && parseFloat(cy[1]) / (cy[2] ? 100 : 1) > .5 }; } return m; }
      if (t === 'defs') { if (!sc) dep++; return m; }
      if (t === 'mask' || t === 'clippath' || t === 'filter') { if (!sc) quiet++; return m; }
      if (t === 'svg') return m;
      let ctx;
      if (quiet) ctx = 'glass';
      else if (t === 'stop') ctx = !grad ? 'glyph' : GLASS_IDS.has(grad.id) ? 'glass' : bg.has(grad.id) ? 'bg' : 'glyph';
      else if (/url\(#(?:iShade|iGlow|iSheen|iRim)\)/.test(attrs)) ctx = 'glass';
      else if (t === 'rect' && /^\s*width="100" height="100" fill="[^"]*"\s*$/.test(attrs)) ctx = /fill="url\(#/.test(attrs) ? 'bgref' : (first && !dep ? 'bare' : 'glyph');
      else ctx = 'glyph';
      if (!dep && SHAPES.has(t)) first = false;
      const r = fn(t, attrs, ctx, grad);
      if (r == null) return m;
      return typeof r === 'object' ? r.html : '<' + tag + r + sc + '>';
    });
  }
  /* 1.ª passagem: de que cor é o fundo (claro e neutro? de uma cor viva?) e se o glifo é todo branco */
  function analyse(s, bg) {
    const B = [], Gc = []; let bare = null;
    const take = (v, into) => { const c = pc(v); if (c) into.push(c); };
    walk(s, bg, (t, attrs, ctx) => {
      if (ctx === 'glass' || ctx === 'bgref') return null;
      if (ctx === 'bare') { const c = pc((/fill="([^"]*)"/.exec(attrs) || [])[1]); if (c) { B.push(c); bare = c; } return null; }
      const into = ctx === 'bg' ? B : Gc;
      attrs.replace(CATTR, (m, a, v) => { take(v, into); return m; });
      const sm = /style="([^"]*)"/.exec(attrs); if (sm) sm[1].replace(CSTYLE, (m, a, v) => { take(v, into); return m; });
      return null;
    });
    const avg = f => B.reduce((x, c) => x + f(c), 0) / Math.max(1, B.length), L = avg(lum), C = avg(chroma), solid = Gc.filter(c => c[3] > .9);
    return { has: B.length > 0, bare, lightBg: B.length > 0 && L > .62 && C < .3, neutral: B.length > 0 && C < .14,
      mono: solid.length > 0 && solid.every(c => chroma(c) < .14 && lum(c) > .85), brand: B.length ? B.reduce((a, c) => chroma(c) > chroma(a) ? c : a, B[0]) : null };
  }
  /* os ids novos levam o id da app: dois ícones inline com o mesmo id e cores diferentes (Música e Telefone numa pasta) pintavam igual */
  const bgBlock = (gid, top, bot, vb) => `<defs><linearGradient id="${gid}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${top}"/><stop offset="1" stop-color="${bot}"/></linearGradient></defs><rect ${vb ? `x="${vb[0]}" y="${vb[1]}" width="${vb[2]}" height="${vb[3]}"` : 'width="100" height="100"'} fill="url(#${gid})"/>`;
  const escRe = s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  function restyleSvg(s, id, st) {
    const iid = String(id == null ? 'x' : id).replace(/[^\w-]/g, '').slice(0, 40) || 'x', GB = 'gBg-' + iid, GR = 'gBrand-' + iid;
    const bg = new Set(); s.replace(BGREF, (m, g) => { if (!GLASS_IDS.has(g)) bg.add(g); return m; });
    const an = analyse(s, bg), mode = st.mode, pal = mode === 'tinted' ? palette(st) : null;
    /* Escuro com glifo branco num fundo de cor: o glifo leva o DEGRADÊ do fundo (cópia do gradiente com outro id, um pouco mais clara) */
    let brandDefs = '', brandRef = null, brandSolid = null;
    if (mode === 'dark' && an.mono && an.has && !an.neutral && !an.lightBg) {
      brandSolid = an.brand ? hex(mixc(an.brand, [255, 255, 255], .12)) : null;
      const bid = [...bg][0];
      if (bid) { const mm = new RegExp('<(linearGradient|radialGradient)\\b[^>]*\\bid="' + escRe(bid) + '"[^>]*>[\\s\\S]*?<\\/\\1>').exec(s);
        if (mm) { brandDefs = '<defs>' + mm[0].replace(/\bid="[^"]*"/, `id="${GR}"`).replace(/stop-color="([^"]*)"/g, (x, v) => { const c = pc(v); return c ? `stop-color="${out(mixc(c, [255, 255, 255], .12), c[3])}"` : x; }) + '</defs>'; brandRef = `url(#${GR})`; } }
      if (!brandRef) brandRef = brandSolid;
    }
    const bgStop = (c, off, g) => {
      if (mode === 'clear') return 'rgba(255,255,255,0)';
      let t = c01(off); if (g && g.radial && g.low) t = 1 - t;   /* radial com o centro em baixo (Instashot): o centro é a parte ESCURA */
      return mode === 'tinted' ? out(mixc(pal.top, pal.bot, t), c[3]) : out(mixc(c, mixc(DK_T, DK_B, t), .86), c[3]);
    };
    /* Transparente: depois de desenhada uma parte BRANCA do glifo (o comando do Jogos, os anéis do Encontrar), os pormenores de cor que
       vêm por cima dela são recortes (preto translúcido); antes disso (o sol do Meteorologia, as cartas da Carteira) ficam brancos.
       A ordem do SVG é a ordem de pintura, por isso basta seguir o percurso. */
    let whiteBase = false;
    const glyph = (v, c, isStop) => {
      const a = c[3], L = lum(c), neu = chroma(c) < .14, Le = an.lightBg && neu ? 1 - L : L;
      if (mode === 'clear') { if (whiteBase && !neu && !an.lightBg && !isStop) return out([0, 0, 0], a * .3); return clearCol(c, an.lightBg && neu); }
      if (mode === 'tinted') return out(mixc(pal.lo, pal.hi, tintCurve(Le)), a);
      if (an.lightBg) { if (neu) { const g = (.12 + .84 * (1 - L)) * 255; return out([g, g, g], a); } return out(mixc(c, [0, 0, 0], .1), a); }
      if (neu && L > .85) { if (a > .9 && brandRef) return isStop ? (brandSolid || out([206, 206, 212], a)) : brandRef; return an.neutral ? out([236, 236, 241], a) : out([206, 206, 212], a); }
      return v;
    };
    let r = walk(s, bg, (t, attrs, ctx, g) => {
      if (ctx === 'glass' || ctx === 'bgref') return null;
      if (ctx === 'bare') { const c = pc((/fill="([^"]*)"/.exec(attrs) || [])[1]) || [128, 128, 128, 1];
        if (mode === 'clear') return { html: '<rect width="100" height="100" fill="none"/>' };
        return { html: mode === 'tinted' ? bgBlock(GB, out(pal.top), out(pal.bot)) : bgBlock(GB, out(mixc(c, DK_T, .86)), out(mixc(c, DK_B, .86))) }; }
      if (ctx === 'bg') { const om = /\boffset="(-?[\d.]+)(%?)"/.exec(attrs), off = om ? parseFloat(om[1]) / (om[2] ? 100 : 1) : 0;
        const na = attrs.replace(CATTR, (m, a, v, q) => { const c = pc(v); return c ? a + bgStop(c, off, g) + q : m; }); return na === attrs ? null : na; }
      let na = attrs.replace(CATTR, (m, a, v, q) => { const c = pc(v); return c ? a + glyph(v, c, a.indexOf('stop-color') > -1) + q : m; });
      na = na.replace(/style="([^"]*)"/, (m, sv) => 'style="' + sv.replace(CSTYLE, (mm, p, v) => { const c = pc(v); return c ? p + glyph(v, c, p.indexOf('stop-color') > -1) : mm; }) + '"');
      if (mode === 'clear' && t !== 'stop' && !whiteBase) attrs.replace(/\s(?:fill|stroke)="([^"]*)"/g, (m, v) => { const fc = pc(v); if (fc && fc[3] > .9 && chroma(fc) < .14 && lum(fc) > .85) whiteBase = true; return m; });
      return na === attrs ? null : na;
    });
    /* sem fundo nenhum (ícone de imagem, SVG de outro resource): no Escuro e no Colorido entra um quadrado por trás de tudo */
    if (!an.has && (mode === 'dark' || mode === 'tinted')) { const vm = /^\s*<svg\b[^>]*\bviewBox="([-\d.\s,]+)"/.exec(r), vb = vm ? vm[1].trim().split(/[\s,]+/).map(Number) : null;
      const blk = mode === 'tinted' ? bgBlock(GB, out(pal.top), out(pal.bot), vb && vb.length === 4 ? vb : null) : bgBlock(GB, out(DK_T), out(DK_B), vb && vb.length === 4 ? vb : null);
      r = r.replace(/^(\s*<svg\b[^>]*>)/, (m0, o) => o + blk); }
    if (brandDefs) r = r.replace(/^(\s*<svg\b[^>]*>)/, (m0, o) => o + brandDefs);
    /* o que não tem fill pinta a PRETO por omissão: no Escuro/Colorido/Transparente essa cor também segue o estilo */
    r = r.replace(/^(\s*<svg\b)([^>]*)>/, (m0, a, b) => /\sfill=/.test(b) ? m0 : `${a}${b} fill="${glyph('#000', [0, 0, 0, 1], false)}">`);
    /* Fotos: as pétalas multiplicam-se com o fundo branco; em fundo escuro isso dava preto (screen), no vidro/cor ficam normais e mais leves */
    if (r.indexOf('mix-blend-mode:multiply') > -1) { r = r.replace(/mix-blend-mode:multiply/g, mode === 'dark' ? 'mix-blend-mode:screen' : 'mix-blend-mode:normal'); if (mode !== 'dark') r = r.replace(/opacity="\.9"/g, 'opacity=".55"'); }
    const sx = '_' + sfxOf(st);
    return r.replace(/(\sid=")([^"]+)(")/g, (m0, a, v, q) => GLASS_IDS.has(v) ? m0 : a + v + sx + q)
      .replace(/url\(#([^)\s"']+)\)/g, (m0, v) => GLASS_IDS.has(v) ? m0 : 'url(#' + v + sx + ')')
      .replace(/(\s(?:xlink:)?href="#)([^"]+)(")/g, (m0, a, v, q) => GLASS_IDS.has(v) ? m0 : a + v + sx + q);
  }
  /* ---- ícones de IMAGEM (apps de outros resources: {url} / 'nui://…png'): canvas, só se a imagem não sujar o canvas ----
     Outro resource é outra origem: sem CORS o getImageData lança e o ícone fica o normal (melhor isso do que um quadrado vazio).
     Assíncrono: quando a cópia fica pronta a regra .tl-<id> é refeita no sítio e sai 'icons:restyled' para os SVG inline. */
  /* IMG: cópia recolorida por estilo ATUAL (o prune larga as outras); IMG_LAST: a última cópia pronta de cada imagem (serve de
     ponte enquanto se arrasta um cursor); IMG_BAD: imagens que sujam o canvas (sem CORS) - nunca mais se tentam.
     ⚠️ 1.4.0 (revisão): antes cada valor de matiz/saturação de um arrasto criava uma Image + canvas + toDataURL e ficava para
     sempre no Map (centenas de PNG por arrasto, e uma imagem sem CORS voltava a ser descarregada a cada passo). Agora, a arrastar
     (IMG_LIVE) não se processa nada: fica a última cópia da mesma família (ou o desenho normal) e a passagem final faz a definitiva. */
  const IMG = new Map(), IMG_IDS = new Map(), IMG_LAST = new Map(), IMG_BAD = new Set();
  let IMG_LIVE = false;
  const unesc = v => String(v).replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
  function procImg(u, st, k) {
    IMG.set(k, null);   /* a caminho: null = fica o desenho normal até a cópia ficar pronta */
    const img = new Image(); if (!/^data:/i.test(u)) img.crossOrigin = 'anonymous';
    img.onload = () => { try { const N = 96, cv = document.createElement('canvas'); cv.width = cv.height = N; const x = cv.getContext('2d');
      const iw = img.naturalWidth || N, ih = img.naturalHeight || N, k2 = Math.max(N / iw, N / ih); x.drawImage(img, (N - iw * k2) / 2, (N - ih * k2) / 2, iw * k2, ih * k2);
      const d = x.getImageData(0, 0, N, N), p = d.data, pal = st.mode === 'tinted' ? palette(st) : null;
      for (let i = 0; i < p.length; i += 4) { const c = [p[i], p[i + 1], p[i + 2]], L = lum(c); let o;
        if (st.mode === 'dark') o = [c[0] * .6, c[1] * .6, c[2] * .6];
        else if (st.mode === 'clear') { const q = pc(clearCol([c[0], c[1], c[2], 1], false)); o = q.slice(0, 3); p[i + 3] = p[i + 3] * q[3]; }
        else o = mixc(pal.lo, pal.hi, tintCurve(L));
        p[i] = o[0]; p[i + 1] = o[1]; p[i + 2] = o[2]; }
      x.putImageData(d, 0, 0); const url = cv.toDataURL('image/png'); IMG_LAST.set(u, { mode: st.mode, url });
      if (k.slice(0, k.indexOf('|')) === sigS) { IMG.set(k, url); refreshImg(u); } else IMG.delete(k);   /* estilo entretanto mudou: não se guarda */
    } catch (e) { IMG_BAD.add(u); IMG.delete(k); /* canvas sujo (outra origem sem CORS): fica o ícone normal, e não se volta a tentar */ } };
    img.onerror = () => { IMG_BAD.add(u); IMG.delete(k); };
    img.src = u;
  }
  function imgStyle(s, id, st) {
    let miss = false; const sg = sigOf(st);
    const r = s.replace(/(<image\b[^>]*?\shref=")([^"]*)(")/g, (m, a, v, q) => { const u = unesc(v); if (!u || IMG_BAD.has(u)) return m;
      const k = sg + '|' + u, hit = IMG.get(k); if (typeof hit === 'string') return a + hit + q;
      if (!IMG_IDS.has(u)) IMG_IDS.set(u, new Set()); IMG_IDS.get(u).add(id);
      if (IMG_LIVE && st === STYLE) { const last = IMG_LAST.get(u); if (last && last.mode === st.mode) return a + last.url + q; miss = true; return m; }   /* a arrastar: ponte */
      miss = true; if (!IMG.has(k)) procImg(u, st, k); return m; });
    return miss ? null : r;
  }
  /* o desenho de um ícone num estilo: Android devolve sempre o original (os ícones Nova UI têm o mapa deles) */
  function applyStyle(raw, id, st) {
    st = st || STYLE;
    if (!raw || st.mode === 'default' || curOS() === 'android') return raw;
    try { let s = String(raw); if (/<image\b/i.test(s)) { s = imgStyle(s, id, st); if (s == null) return raw; } return restyleSvg(s, id, st); }
    catch (e) { console.error('[apex_phone] estilo do ícone', id, e); return raw; }
  }

  /* ---------- App icons ---------- */
  /* paletas PearOS 26 (topo mais claro → base mais escura, saturadas) */
  const GREEN = ['#8AF9A6', '#34D058', '#1CAD3E'], BLUE = ['#6CB8FF', '#2A8BFF', '#0F63EA'], RED = ['#FF8A98', '#FC3C55', '#DD1F3B'], GRAY = ['#B4B4BA', '#77777D', '#4B4B50'], DARK = ['#3E3E44', '#1C1C1E', '#0A0A0B'], WHITE = ['#FFFFFF', '#FAFAFC', '#EDEDF2'];
  const app = {
    phone: () => SVG(G('gPh', ...GREEN) + GL(`<path transform="translate(23.5 23.5) scale(2.2)" fill="#fff" d="${PHONE_PATH}"/>`)),
    messages: () => SVG(G('gMs', ...GREEN) + GL(`<path fill="#fff" d="M50 21C29 21 14 33.5 14 49c0 8.6 4.6 16.3 12 21.4-.6 4.6-2.6 8.4-5.4 11.2 5.8-.4 11-2.7 15-6.2 4.5 1.4 9.3 2.1 14.4 2.1 21 0 36-12.5 36-28S71 21 50 21z"/>`)),
    safari: () => { let t = ''; for (let i = 0; i < 72; i++) t += `<line x1="50" y1="11.5" x2="50" y2="${11.5 + (i % 6 === 0 ? 7 : 3.5)}" stroke="#fff" stroke-width="1.4" transform="rotate(${i * 5} 50 50)"/>`;
      return SVG(G('gSf', ...WHITE) + `<defs><radialGradient id="gSf2" cx="50%" cy="35%" r="65%"><stop offset="0" stop-color="#5EB6FF"/><stop offset="1" stop-color="#0857D8"/></radialGradient></defs>` + GL(`<circle cx="50" cy="50" r="41" fill="url(#gSf2)"/>`) + `${t}<g transform="rotate(45 50 50)"><polygon points="50,15 43.5,50 56.5,50" fill="#FF3B30"/><polygon points="50,85 43.5,50 56.5,50" fill="#fff"/></g><circle cx="50" cy="50" r="41" fill="none" stroke="rgba(255,255,255,.35)" stroke-width="1"/>`); },
    music: () => SVG(G('gMu', ...RED) + GL(`<path fill="#fff" d="M70 22 40 28.5c-1.6.3-2.7 1.7-2.7 3.3V62a11 11 0 1 0 5.4 9.5V41l24-5v18a11 11 0 1 0 5.4 9.5V25.2c0-1.9-1.8-3.5-3.7-3.2z"/>`)),
    facetime: () => SVG(G('gFt', ...GREEN) + GL(`<rect x="15" y="31" width="47" height="38" rx="11" fill="#fff"/><path d="M64 44.5 84 32v36L64 55.5z" fill="#fff"/>`)),
    calendar: () => { const d = new Date(); return SVG(G('gCa', ...WHITE) + `<text x="50" y="29" text-anchor="middle" font-family="Inter,-apple-system,sans-serif" font-size="14" font-weight="600" letter-spacing=".5" fill="#FF3B30">${calMon(d)}</text><text x="50" y="81" text-anchor="middle" font-family="Inter,-apple-system,sans-serif" font-size="56" font-weight="300" letter-spacing="-2" fill="#111">${d.getDate()}</text>`); },
    photos: () => { const cols = ['#FFD400', '#FF9500', '#FF3B30', '#FF2D6F', '#B04AE0', '#2F7BFF', '#3EC8F0', '#59D64A']; let p = ''; cols.forEach((c, i) => { p += `<ellipse cx="50" cy="29" rx="11.5" ry="22.5" fill="${c}" opacity=".9" style="mix-blend-mode:multiply" transform="rotate(${i * 45} 50 50)"/>`; }); return SVG(G('gPo', ...WHITE) + p); },
    camera: () => SVG(G('gCm', ...GRAY) + GL(`<rect x="15" y="33" width="70" height="46" rx="10" fill="#fff"/><rect x="35" y="24" width="30" height="13" rx="4.5" fill="#fff"/>`) + `<circle cx="50" cy="56" r="16.5" fill="#3A3A3C"/><circle cx="50" cy="56" r="11.5" fill="#F2F2F7"/><circle cx="50" cy="56" r="7" fill="#2C2C2E"/><circle cx="47.5" cy="53" r="2" fill="rgba(255,255,255,.8)"/><circle cx="73" cy="42" r="3" fill="#3A3A3C"/>`),
    mail: () => SVG(G('gMa', ...BLUE) + GL(`<rect x="13" y="27" width="74" height="48" rx="9" fill="#fff"/>`) + `<path d="M17 33 50 58 83 33" fill="none" stroke="#1466F2" stroke-width="4" stroke-linejoin="round" stroke-linecap="round"/>`),
    clock: () => { let t = ''; for (let i = 0; i < 12; i++) t += `<line x1="50" y1="12" x2="50" y2="${i % 3 === 0 ? 19.5 : 16.5}" stroke="#000" stroke-width="${i % 3 === 0 ? 3 : 1.8}" stroke-linecap="round" transform="rotate(${i * 30} 50 50)"/>`;
      return SVG(G('gCk', ...WHITE) + `<circle cx="50" cy="50" r="42" fill="#fff" stroke="#000" stroke-width="6"/>${t}<line class="hh" x1="50" y1="50" x2="50" y2="28" stroke="#000" stroke-width="4.5" stroke-linecap="round" transform="rotate(300 50 50)"/><line class="mh" x1="50" y1="50" x2="50" y2="18" stroke="#000" stroke-width="3.5" stroke-linecap="round" transform="rotate(60 50 50)"/><line class="sh" x1="50" y1="56" x2="50" y2="16" stroke="#FF9F0A" stroke-width="1.6" stroke-linecap="round" transform="rotate(0 50 50)"/><circle cx="50" cy="50" r="3" fill="#000"/><circle cx="50" cy="50" r="1.4" fill="#FF9F0A"/>`); },
    maps: () => SVG(`<rect width="100" height="100" fill="#EDEBE3"/><rect x="-10" y="-10" width="54" height="60" rx="16" fill="#A5DE8C"/><rect x="58" y="60" width="62" height="62" rx="20" fill="#86C9F2"/><rect x="0" y="44" width="100" height="11" fill="#fff"/><rect x="44" y="0" width="11" height="100" fill="#fff"/><path d="M-5 80 57 18" stroke="#F8D66A" stroke-width="10" stroke-linecap="round"/><path d="M-5 80 57 18" stroke="#EEBF3F" stroke-width="2" stroke-dasharray="4 5"/>` + GL(`<circle cx="70" cy="33" r="7" fill="#0A84FF" stroke="#fff" stroke-width="3"/><path d="M28 51c-8 0-14 6-14 14 0 10 14 25 14 25s14-15 14-25c0-8-6-14-14-14z" fill="#FF3B30"/><circle cx="28" cy="65" r="5" fill="#fff"/>`)),
    weather: () => SVG(G('gWe', ...BLUE) + `<defs><radialGradient id="gSun" cx="40%" cy="35%" r="70%"><stop offset="0" stop-color="#FFE580"/><stop offset="1" stop-color="#FFC42B"/></radialGradient></defs><circle cx="36" cy="37" r="14.5" fill="url(#gSun)"/>` + GL(`<g fill="#fff"><circle cx="58" cy="58" r="15.5"/><circle cx="71.5" cy="53" r="11.5"/><circle cx="45" cy="61" r="11.5"/><rect x="45" y="58" width="38" height="15.5" rx="7.5"/></g>`)),
    reminders: () => SVG(G('gRe', ...WHITE) + GL(`<circle cx="24" cy="30" r="7" fill="#FF3B30"/><circle cx="24" cy="50" r="7" fill="#FF9F0A"/><circle cx="24" cy="70" r="7" fill="#0A84FF"/>`) + `<g fill="#D1D1D6"><rect x="38" y="26" width="42" height="8" rx="4"/><rect x="38" y="46" width="42" height="8" rx="4"/><rect x="38" y="66" width="42" height="8" rx="4"/></g>`),
    notes: () => SVG(`<rect width="100" height="100" fill="#fff"/><defs><linearGradient id="gNt" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFE066"/><stop offset="1" stop-color="#FFD135"/></linearGradient></defs><rect width="100" height="28" fill="url(#gNt)"/><g fill="rgba(0,0,0,.28)"><circle cx="22" cy="14" r="2.6"/><circle cx="36" cy="14" r="2.6"/><circle cx="50" cy="14" r="2.6"/><circle cx="64" cy="14" r="2.6"/><circle cx="78" cy="14" r="2.6"/></g><g fill="#D1D1D6"><rect x="18" y="42" width="64" height="5" rx="2.5"/><rect x="18" y="56" width="64" height="5" rx="2.5"/><rect x="18" y="70" width="44" height="5" rx="2.5"/></g>`),
    appstore: () => SVG(G('gAs', ...BLUE) + GL(`<g fill="none" stroke="#fff" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"><path d="M31 72 50 32l19 40M24 60h52M42 72l-4 6M58 72l4 6"/></g>`)),
    wallet: () => SVG(G('gWa', ...DARK) + GL(`<rect x="18" y="19" width="64" height="40" rx="7" fill="#0A84FF"/><rect x="18" y="28" width="64" height="40" rx="7" fill="#30D158"/><rect x="18" y="37" width="64" height="40" rx="7" fill="#FFD60A"/><rect x="18" y="46" width="64" height="40" rx="7" fill="#FF453A"/><rect x="12" y="61" width="76" height="27" rx="8" fill="#2C2C2E"/>`) + `<rect x="12" y="61" width="76" height="27" rx="8" fill="none" stroke="rgba(255,255,255,.18)" stroke-width="1"/>`),
    home: () => SVG(G('gHo', ...WHITE) + `<defs><linearGradient id="gHo2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFB84A"/><stop offset="1" stop-color="#FF8500"/></linearGradient></defs>` + GL(`<path d="M50 19 15 50h9.5v30h20V62h11v18h20V50H85z" fill="url(#gHo2)"/>`)),
    calculator: () => { let c = ''; [26, 44, 62, 80].forEach((y, r) => [28, 50, 72].forEach((x, k) => { c += `<circle cx="${x}" cy="${y}" r="8.2" fill="${r === 0 ? '#A5A5A5' : (k === 2 ? '#FF9F0A' : '#3A3A3C')}"/>`; })); return SVG(G('gCl', ...DARK) + GL(c)); },
    contacts: () => SVG(G('gCo', '#EDEDF2', '#CFCFD5', '#B9B9C0') + GL(`<rect x="24" y="17" width="56" height="67" rx="8" fill="#FBF7EC"/>`) + `<g fill="#8E8E93"><rect x="18" y="28" width="10" height="7" rx="2.5"/><rect x="18" y="42" width="10" height="7" rx="2.5"/><rect x="18" y="56" width="10" height="7" rx="2.5"/><rect x="18" y="70" width="10" height="7" rx="2.5"/></g><circle cx="54" cy="44" r="10" fill="#8E8E93"/><path d="M36 76c0-11 8-18 18-18s18 7 18 18z" fill="#8E8E93"/>`),
    settings: () => { let t = ''; for (let i = 0; i < 8; i++) t += `<rect x="43.5" y="10.5" width="13" height="19" rx="5.5" fill="#fff" transform="rotate(${i * 45} 50 50)"/>`; return SVG(G('gSe', ...GRAY) + GL(`${t}<circle cx="50" cy="50" r="26.5" fill="#fff"/>`) + `<circle cx="50" cy="50" r="11.5" fill="url(#gSe)"/><circle cx="50" cy="50" r="11.5" fill="none" stroke="rgba(0,0,0,.12)" stroke-width="1"/>`); },
    /* ---- apps RP ---- */
    billing: () => SVG(G('gBi', ...WHITE) + GL(`<path d="M28 17h44v63l-5.5-4-5.5 4-5.5-4-5.5 4-5.5-4-5.5 4-5.5-4L28 80z" fill="#0A84FF"/>`) + `<g stroke="#fff" stroke-width="4" stroke-linecap="round"><path d="M38 33h24M38 45h24M38 57h14"/></g><circle cx="66" cy="66" r="12" fill="#30D158" stroke="#fff" stroke-width="3"/><path d="m60 66 4 4 8-8" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>`),
    /* Encontrar (Find My): radar verde com o ponto de localização */
    findmy: () => SVG(G('gFm', ...GREEN) + GL(`<circle cx="50" cy="50" r="31" fill="none" stroke="#fff" stroke-width="5" opacity=".9"/><circle cx="50" cy="50" r="17.5" fill="none" stroke="#fff" stroke-width="5" opacity=".9"/>`) + `<circle cx="50" cy="50" r="8" fill="#0A84FF" stroke="#fff" stroke-width="3.5"/>`),
    services: () => SVG(G('gSv', '#4FB7FF', '#1A8CFF', '#0A4FD6') + GL(`<circle cx="50" cy="50" r="30" fill="none" stroke="#fff" stroke-width="12"/>`) + `<circle cx="50" cy="50" r="30" fill="none" stroke="#0A4FD6" stroke-width="12" stroke-dasharray="14 33" stroke-dashoffset="7"/><circle cx="50" cy="50" r="14" fill="#fff"/>`),
    /* Instashot (2026-10-01, pedido do dono: "mais parecido com o Instagram"): o degradê quente amarelo, laranja, rosa e roxo
       a subir do canto de baixo, com o toque azul em cima, e a câmara em contorno branco com a lente e o ponto do flash */
    instashot: () => SVG(`<defs><radialGradient id="gIs" cx="30%" cy="107%" r="150%"><stop offset="0" stop-color="#FDDA5C"/><stop offset=".08" stop-color="#FDDA5C"/><stop offset=".45" stop-color="#FF5341"/><stop offset=".72" stop-color="#D3348F"/><stop offset="1" stop-color="#8A3AC8"/></radialGradient><radialGradient id="gIs2" cx="-10%" cy="-5%" r="75%"><stop offset="0" stop-color="#4C68D7"/><stop offset=".25" stop-color="#4C68D7" stop-opacity=".85"/><stop offset="1" stop-color="#8A3AC8" stop-opacity="0"/></radialGradient></defs><rect width="100" height="100" fill="url(#gIs)"/><rect width="100" height="100" fill="url(#gIs2)"/>` + GL(`<rect x="23" y="23" width="54" height="54" rx="16" fill="none" stroke="#fff" stroke-width="6.5"/><circle cx="50" cy="50" r="13" fill="none" stroke="#fff" stroke-width="6.5"/><circle cx="66" cy="34" r="4" fill="#fff"/>`)),
    twix: () => SVG(G('gTw', ...DARK) + GL(`<path transform="translate(21 21) scale(2.42)" d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" fill="#fff"/>`)),   /* a mesma marca do cabeçalho da app (social.js) */
    reels: () => SVG(G('gRl', '#2A2A2E', '#0E0E10', '#000') + `<path d="M38 26 76 50 38 74z" fill="#25F4EE" transform="translate(-3 3)"/><path d="M38 26 76 50 38 74z" fill="#FE2C55" transform="translate(3 -3)"/>` + GL(`<path d="M38 26 76 50 38 74z" fill="#fff"/>`)),
    aichat: () => SVG(`<defs><linearGradient id="gAi" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FF4F8B"/><stop offset=".5" stop-color="#8E5CFF"/><stop offset="1" stop-color="#2F7BFF"/></linearGradient></defs><rect width="100" height="100" fill="url(#gAi)"/>` + GL(`<path d="M50 18c2.6 14.4 7.6 19.4 22 22-14.4 2.6-19.4 7.6-22 22-2.6-14.4-7.6-19.4-22-22 14.4-2.6 19.4-7.6 22-22z" fill="#fff"/><path d="M72 58c1.3 7 3.8 9.5 10.8 10.8-7 1.3-9.5 3.8-10.8 10.8-1.3-7-3.8-9.5-10.8-10.8 7-1.3 9.5-3.8 10.8-10.8z" fill="#fff" opacity=".85"/>`)),
    darkchat: () => SVG(G('gDc', ...DARK) + GL(`<path d="M22 30a8 8 0 0 1 8-8h40a8 8 0 0 1 8 8v30a8 8 0 0 1-8 8H44l-14 12V68h-0a8 8 0 0 1-8-8z" fill="none" stroke="#fff" stroke-width="5.5" stroke-linejoin="round"/><circle cx="38" cy="45" r="4.2" fill="#fff"/><circle cx="50" cy="45" r="4.2" fill="#fff"/><circle cx="62" cy="45" r="4.2" fill="#fff"/>`)),
  };

  /* ---------- Ícone de uma app de OUTRO resource: {url} | {label,color} | {svg} ----------
     ⚠️ Este valor vem do `icon` do RegisterApp de outro resource e entra por innerHTML no documento do
     TELEMÓVEL (home, dock, App Switcher, AppShop, pesquisa) - que tem acesso ao Bridge e ao Store.
     Era devolvido tal como vinha: um `icon` como '<img src=x onerror=…>' corria código lá dentro,
     exatamente o que o sandbox das apps externas (iframe) existe para evitar. Agora:
       · SVG passa pelo safeSvg abaixo (o mesmo método do notify.js e do widgets.js);
       · URL só nui:// , http(s):// ou data:image/… (nada de javascript: nem data:text);
       · a cor só em #hex e a etiqueta escapada.
     O que não passar cai no ícone das Definições - um ícone errado é melhor do que código de fora. */
  const ESC = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ESC[c]);
  const HEX = /^#[0-9a-f]{3,8}$/i;
  const isImg = s => typeof s === 'string' && (/^(https?:\/\/|nui:\/\/|data:image\/(png|jpe?g|webp|gif|svg\+xml);)/i.test(s) || /^[\w./-]+\.(png|jpe?g|webp|gif|svg)(\?[\w=&.%+-]*)?$/i.test(s));
  /* só etiquetas de DESENHO: sem <script>, <a>, <foreignObject>, <animate>… (e sem HTML, que o <svg> aceitaria) */
  const SVG_OK = new Set(['svg', 'g', 'defs', 'title', 'desc', 'path', 'circle', 'ellipse', 'rect', 'line', 'polyline', 'polygon', 'text', 'tspan', 'image', 'use', 'clippath', 'mask', 'pattern', 'symbol', 'lineargradient', 'radialgradient', 'stop',
    'filter', 'fegaussianblur', 'feoffset', 'feflood', 'fecomposite', 'femerge', 'femergenode', 'fecolormatrix', 'feblend', 'femorphology', 'fedropshadow']);
  /* style: o mesmo critério do BAD_STYLE do widgets.js - o CSS aceita escapes (`\75 rl(`), comentários a meio
     de uma propriedade e var(), e um filtro só por palavras fugia com eles. Qualquer destes deita fora o
     atributo inteiro (aqui é sempre um ícone de outro resource: não há nada legítimo a perder). */
  const BAD_STYLE = /[\\<>]|\/\*|url\s*\(|image-set|expression|@import|binding|behavior|var\s*\(/i;
  /* o <template> é um documento INERTE: nada corre nem carrega enquanto se limpa (o mesmo truque do notify.js) */
  function safeSvg(h) {
    if (typeof h !== 'string' || h.length > 60000 || !/^\s*<svg[\s>]/i.test(h)) return null;
    try {
      const t = document.createElement('template'); t.innerHTML = h;
      const root = t.content.firstElementChild;
      if (!root || root.localName !== 'svg' || t.content.children.length !== 1) return null;
      root.querySelectorAll('*').forEach(e => { if (!SVG_OK.has(e.localName.toLowerCase())) e.remove(); });
      [root, ...root.querySelectorAll('*')].forEach(e => [...e.attributes].forEach(a => {
        const nm = a.name.toLowerCase(), v = a.value.replace(/[\u0000-\u0020]+/g, '').toLowerCase();
        const link = nm === 'href' || nm === 'xlink:href' || nm === 'src';
        if (nm.startsWith('on') || /javascript:|vbscript:|data:text/.test(v) || (nm === 'style' && BAD_STYLE.test(v))
          || (link && !/^(#|https?:|nui:|data:image\/(png|jpe?g|webp|gif);)/.test(v))) e.removeAttribute(a.name);
      }));
      return root.outerHTML;
    } catch (e) { return null; }
  }
  function custom(def) {
    if (!def) return app.settings();
    /* ícones de imagem (apps de outros resources) passam pelo MESMO invólucro dos ícones do sistema: reflexo, sombra interior, aro e máscara squircle */
    const wrapUrl = u => SVG(`<image href="${esc(u)}" width="100" height="100" preserveAspectRatio="xMidYMid slice"/>`);
    if (typeof def === 'string') { const s = def.trim(); return s.startsWith('<') ? (safeSvg(s) || app.settings()) : (isImg(s) ? wrapUrl(s) : app.settings()); }
    if (typeof def !== 'object') return app.settings();
    if (def.svg) return safeSvg(String(def.svg).trim()) || app.settings();
    if (def.url) { const u = String(def.url).trim(); return isImg(u) ? wrapUrl(u) : app.settings(); }
    const c = HEX.test(String(def.color || '').trim()) ? String(def.color).trim() : '#0A84FF', l = esc(String(def.label == null || def.label === '' ? '?' : def.label).slice(0, 2));
    return SVG(`<rect width="100" height="100" fill="${c}"/>` + GL(`<text x="50" y="64" text-anchor="middle" font-family="Inter,sans-serif" font-size="40" font-weight="700" fill="#fff">${l}</text>`));
  }
  /* Cada ícone é um SVG completo (4 gradientes + filtro + 4 rects) construído por concatenação de strings. A AppShop chega a pedir
     ~17 numa só vista e a pesquisa refazia dezenas por tecla - era a maior fatia do bloqueio ao abrir a loja. O resultado é imutável
     para um dado id, por isso guarda-se; `clearTiles` limpa quando uma app é REdefinida com outro ícone (System.App.define). */
  const tileCache = new Map();
  /* ÍCONES POR SISTEMA (Android, 2026-10-01): o telemóvel Android desenha os ícones das apps do sistema no estilo Nova UI
     (js/icons-android.js chama Icons.registerOS('android', { id: () => svg })). As apps que não tiverem versão própria
     usam o ícone de sempre: como nos telemóveis a sério, uma app de terceiros tem o mesmo ícone nos dois sistemas.
     As caches são por sistema (chave "os:id") para a troca de aparelho não misturar desenhos. */
  const OS_APP = { android: {} };
  const curOS = () => (window.System && System.os) || 'ios';
  const registerOS = (os, map) => { if (!OS_APP[os] || !map) return; Object.keys(map).forEach(k => { if (typeof map[k] === 'function') OS_APP[os][k] = map[k]; }); clearTiles(); };
  const rawDraw = id => { const m = OS_APP[curOS()]; if (m && m[id]) { try { return m[id](); } catch (e) { console.error('[apex_phone] ícone', curOS(), id, e); } } return app[id] ? app[id]() : custom((window.App && App.get(id) || {}).icon); };
  /* o ponto ÚNICO por onde passam tile() e tileUrl(): o estilo entra aqui, por isso pastas, Biblioteca, AppShop, notificações e
     apps de empresa (capp_*, o mesmo G()) seguem-no todos */
  const draw = id => applyStyle(rawDraw(id), id);
  /* as caches levam a assinatura do estilo (no Android não: lá o desenho é sempre o original) */
  const curSig = () => curOS() === 'android' ? 'raw' : sigS;
  const ck = id => curOS() + ':' + id + '|' + curSig();
  /* o defsReady() também aqui: um tile em cache não volta a passar pelo SVG(), e as definições
     globais têm de estar no documento sempre que um tile sai (é só um `isConnected`) */
  function tile(id) { defsReady(); const k = ck(id); const hit = tileCache.get(k); if (hit !== undefined) return hit;
    const out = draw(id); tileCache.set(k, out); return out; }
  /* ---------- O MESMO ÍCONE COMO IMAGEM (2026-09-20) ----------
     `tile()` devolve SVG para INSERIR no DOM: cada cópia cria a árvore toda (defs, gradientes, paths…) - 20 a 30 nós. Numa
     lista com o mesmo ícone repetido (AppShop: 122 ícones = ~1060 nós, 85% da app) isso é o que a torna pesada.
     `tileUrl()` devolve o mesmo desenho como `url("data:image/svg+xml,…")` para pôr em background-image: UM nó, e o
     Chromium decodifica cada URL uma só vez e reutiliza-a em todas as cópias.
     ⚠️ Uma imagem é um documento ISOLADO: as definições de vidro do documento (#iGl, #iShade…) não lá chegam, por isso vão
     SEMPRE embutidas (`GLASS_DEFS`), ao contrário do caminho inline. */
  const urlCache = new Map();
  /* ÍCONES VIVOS: o Relógio tem ponteiros que o tickClocks roda no DOM a cada segundo. Dentro de uma imagem isso não
     acontece (é um documento isolado e parado), por isso devolve-se `null` e quem chama volta ao SVG inline. */
  const LIVE = /class="(hh|mh|sh)"/;
  /* SVG → url('data:…') (os defs do vidro embutidos: uma imagem é um documento isolado) */
  const toUrl = inner => {
    /* o markup já vem com <svg …>: injetam-se os defs logo a seguir à etiqueta de abertura */
    const svg = String(inner).replace(/^(<svg[^>]*>)/, (_, open) => open + GLASS_DEFS);
    /* aspas SIMPLES à volta do url: assim cabe num atributo style="…" sem partir o HTML (as aspas duplas de dentro do SVG
       já saem codificadas pelo encodeURIComponent) */
    return "url('data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg) + "')";
  };
  function tileUrl(id) {
    const k = ck(id); const hit = urlCache.get(k); if (hit !== undefined) return hit;
    const inner = draw(id);
    if (LIVE.test(String(inner))) { urlCache.set(k, null); return null; }
    const out = toUrl(inner);
    urlCache.set(k, out); return out;
  }
  /* O endereço da imagem é longo (o SVG inteiro): repeti-lo no `style` de cada cópia enchia o documento de texto. Vai UMA vez
     para uma folha de estilo própria (`.tl-<id>`) e cada ícone leva só a classe.
     1.4.0: a imagem vai numa variável (--tli) e o background-image lê-a. Assim a regra muda NO SÍTIO quando o estilo muda (os
     ícones já montados - home, dock, pastas, clone da galeria - trocam sem render nenhum) e o homecustom.css pode pôr camadas por
     baixo do desenho no Transparente (var(--tli), vidro, cópia desfocada do fundo). `ruled` guarda chave → {id, regra}: sem o id
     não havia como refazer a regra. */
  let sheet = null; const ruled = new Map();
  const cssId = id => { const s = String(id).replace(/[^\w-]/g, ''); return (s && !/^[0-9-]/.test(s)) ? s : null; };
  const updRule = r => { const u = tileUrl(r.id); r.sig = curSig(); if (!u) return; try { r.rule.style.setProperty('--tli', u); } catch (e) {} };
  function ruleFor(id) {
    const base = cssId(id); if (!base) return null;                /* id que não dá uma classe válida: fica com style inline */
    const os = curOS(), key = os === 'ios' ? base : os + '-' + base;   /* a classe do Android é outra (tl-android-<id>): as duas regras coexistem */
    const r = ruled.get(key);
    if (r) { if (r.os === os && r.sig !== curSig()) updRule(r); return 'tl-' + key; }   /* regra de outro estilo ainda por refazer (passagem ao vivo parcial): refaz-se ao usar */
    const u = tileUrl(id); if (!u) return null;
    if (!sheet) { const st = document.createElement('style'); st.id = 'iconTiles'; document.head.appendChild(st); sheet = st.sheet; }
    try { const i = sheet.insertRule('.tl-' + key + '{--tli:' + u + ';background-image:var(--tli)}', sheet.cssRules.length); ruled.set(key, { id, os, key, rule: sheet.cssRules[i], sig: curSig() }); } catch (e) { return null; }
    return 'tl-' + key;
  }
  /* o `<div class="tile">` pronto: imagem quando dá, SVG inline quando o ícone é vivo (Relógio). É por aqui que devem passar
     as listas e grelhas com MUITOS ícones - ecrã principal, biblioteca, AppShop. */
  const tileBox = (id, cls = '') => {
    const r = ruleFor(id); if (r) return `<div class="tile img ${r} ${cls}"></div>`;
    const u = tileUrl(id); if (u) return `<div class="tile img ${cls}" style="background-image:${u}"></div>`;
    return `<div class="tile ${cls}">${tile(id)}</div>`;
  };
  /* o ícone de uma app pode mudar (App.define com outro icon): cai a cache das duas formas E a regra da folha, senão os
     ecrãs já desenhados ficavam com o desenho antigo */
  /* `function` e não const: o registerOS (acima) chama-a e corre antes de esta linha ser lida */
  function clearTiles(id) {
    const drop = c => { const r = c && ruled.get(c); if (!r) return; ruled.delete(c); if (!sheet) return;
      for (let i = sheet.cssRules.length - 1; i >= 0; i--) { if (sheet.cssRules[i] === r.rule || sheet.cssRules[i].selectorText === '.tl-' + c) { sheet.deleteRule(i); break; } } };
    if (id === undefined) { tileCache.clear(); urlCache.clear(); [...ruled.keys()].forEach(drop); }
    else { const c = cssId(id), pre = Object.keys(OS_APP).concat('ios').map(o => o + ':' + id + '|');   /* as chaves são "os:id|estilo": cai o id em TODOS os estilos */
      [tileCache, urlCache].forEach(m => [...m.keys()].forEach(k => { if (pre.some(p => k.startsWith(p))) m.delete(k); }));
      if (c) { drop(c); Object.keys(OS_APP).forEach(o => drop(o + '-' + c)); } }
  }

  /* ---------- trocar de estilo ----------
     setStyle guarda o estilo e, se o DESENHO mudou (sigOf), refaz as regras .tl-* no sítio - no máximo uma passagem por frame
     (os cursores da folha Personalizar chamam isto a 60 Hz). Ao vivo ({live:true}, a arrastar um cursor) só se refazem as regras
     que estão à vista no ecrã principal (e no clone da galeria/menu de contexto): com a AppShop já aberta podiam ser 120 SVG por
     frame. As outras ficam marcadas e refazem-se na passagem FINAL (largar o cursor → System.setState → System.apply → setStyle
     com a mesma assinatura: é aí que sai {final:true}) ou quando forem usadas (ruleFor). */
  let rsPend = false, rsFinal = false, hk = null, hkT = 0;
  const homeKeys = () => { const now = performance.now(); if (hk && now - hkT < 400) return hk; hk = new Set(); hkT = now;
    document.querySelectorAll('#home .tile.img, .dock .tile.img, .lsg-hicons .tile.img, .ctx-preview .tile.img').forEach(t => t.classList.forEach(c => { if (c.slice(0, 3) === 'tl-') hk.add(c.slice(3)); })); return hk; };
  function pass(final) {
    const os = curOS(), sg = curSig(), keys = final ? null : homeKeys();
    ruled.forEach((r, key) => { if (r.os !== os || r.sig === sg) return; if (keys && !keys.has(key)) return; updRule(r); });
    /* passagem final depois de um arrasto: os ícones de IMAGEM ficaram com a ponte (ou o normal) desenhados JÁ com esta assinatura,
       por isso o ciclo de cima salta-os - refazem-se aqui, e agora (IMG_LIVE falso) o imgStyle pede a cópia definitiva */
    if (final) IMG_IDS.forEach((ids, u) => { if (IMG_BAD.has(u) || typeof IMG.get(sigS + '|' + u) === 'string') return;
      ids.forEach(id => { const k = 'ios:' + id + '|' + sigS; tileCache.delete(k); urlCache.delete(k); const c = cssId(id), r = c && ruled.get(c); if (r && r.os === os) updRule(r); }); });
    liveStale = !final;
    if (window.Bridge && Bridge.emit) Bridge.emit('icons:restyled', { final: !!final, sig: sigS });
  }
  function restyle(final) {
    rsFinal = rsFinal || final !== false;
    if (rsPend) return; rsPend = true;
    const run = () => { if (!rsPend) return; rsPend = false; const f = rsFinal; rsFinal = false; pass(f); };
    /* rAF para juntar os pedidos de um frame; o setTimeout é a rede para quando o rAF não corre (telemóvel guardado, headless) */
    try { requestAnimationFrame(run); } catch (e) {} setTimeout(run, 50);
  }
  /* largas as entradas de outros estilos (um arrasto de matiz deixava centenas) */
  const prune = () => { const sg = '|' + sigS; [tileCache, urlCache].forEach(m => [...m.keys()].forEach(k => { if (k.slice(0, 8) !== 'android:' && !k.endsWith(sg)) m.delete(k); }));
    const pre = sigS + '|'; [...IMG.keys()].forEach(k => { if (k.slice(0, pre.length) !== pre) IMG.delete(k); }); };   /* as cópias PNG dos ícones de imagem também (eram para sempre) */
  function setStyle(s, opts) {
    const nx = normStyle(s), live = !!(opts && opts.live), sig = sigOf(nx);
    STYLE = nx; IMG_LIVE = live;
    /* body[data-icons]/[data-icontone] são do System.apply (um só dono); aqui só a tinta para o material do Colorido */
    try { document.documentElement.style.setProperty('--icon-tint-rgb', hsl(nx.hue, nx.sat, .5).map(Math.round).join(',')); } catch (e) {}
    /* Android: guarda (o setOS limpa as caches ao voltar ao PearOS e o desenho sai já no estilo certo), mas não refaz nada */
    if (curOS() === 'android') { sigS = sig; return false; }
    if (sig === sigS) { if (!live && liveStale) restyle(true); return false; }
    sigS = sig; prune(); hk = null; restyle(!live); return true;
  }
  /* pré-visualizações (folha Personalizar): o desenho num estilo qualquer, sem tocar nas caches */
  const styled = (id, st) => applyStyle(rawDraw(id), id, normStyle(st));
  /* um ícone de imagem ficou pronto no estilo atual: cai a cache desse id, a regra refaz-se no sítio e os SVG inline refazem-se */
  function refreshImg(u) {
    const ids = [...(IMG_IDS.get(u) || [])]; if (!ids.length) return;
    ids.forEach(id => { const k = 'ios:' + id + '|' + sigS; tileCache.delete(k); urlCache.delete(k); const c = cssId(id), r = c && ruled.get(c); if (r && r.os === curOS()) updRule(r); });
    if (window.Bridge && Bridge.emit) Bridge.emit('icons:restyled', { final: true, sig: sigS, ids });
  }

  /* ---------- Glifos UI (24×24) ---------- */
  const P = {
    chevR: '<path d="m9 18 6-6-6-6"/>', chevL: '<path d="m15 18-6-6 6-6"/>', chevD: '<path d="m6 9 6 6 6-6"/>', chevU: '<path d="m18 15-6-6-6 6"/>',
    plus: '<path d="M12 5v14M5 12h14"/>', minus: '<path d="M5 12h14"/>', x: '<path d="M18 6 6 18M6 6l12 12"/>', check: '<path d="m5 12 5 5L20 7"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
    more: '<g fill="currentColor" stroke="none"><circle cx="5" cy="12" r="1.7"/><circle cx="12" cy="12" r="1.7"/><circle cx="19" cy="12" r="1.7"/></g>',
    moreV: '<g fill="currentColor" stroke="none"><circle cx="12" cy="5" r="1.7"/><circle cx="12" cy="12" r="1.7"/><circle cx="12" cy="19" r="1.7"/></g>',
    trash: '<path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6M10 11v6M14 11v6"/>',
    heart: '<path d="M19.5 12.6 12 20l-7.5-7.4A5 5 0 1 1 12 6.1a5 5 0 1 1 7.5 6.5z"/>', heartFill: '<path fill="currentColor" d="M19.5 12.6 12 20l-7.5-7.4A5 5 0 1 1 12 6.1a5 5 0 1 1 7.5 6.5z"/>',
    play: '<path d="M6 4l14 8-14 8z" fill="currentColor" stroke="none"/>', pause: '<g fill="currentColor" stroke="none"><rect x="5" y="4" width="5" height="16" rx="1"/><rect x="14" y="4" width="5" height="16" rx="1"/></g>',
    /* Reels: a "claquete" do Instagram - moldura arredondada, a barra de cima com duas diagonais
       (como a fita de filme) e o triângulo de leitura. O `play` sozinho é um triângulo cheio e não
       se lê como separador de vídeos numa barra de traço. */
    reels: '<rect x="3" y="3" width="18" height="18" rx="5"/><path d="M3.4 8.7h17.2M8.2 3.2l2.9 5.4M14 3.2l2.9 5.4"/><path d="M10.6 11.4v4.6l4-2.3z" fill="currentColor" stroke="none"/>',
    next: '<path d="M4 5l9 7-9 7zM15 5h3v14h-3z" fill="currentColor" stroke="none"/>', prev: '<path d="M20 5l-9 7 9 7zM6 5h3v14H6z" fill="currentColor" stroke="none"/>',
    shuffle: '<path d="M16 3h5v5M4 20 21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/>', repeat: '<path d="m17 2 4 4-4 4M3 11v-1a4 4 0 0 1 4-4h14M7 22l-4-4 4-4M21 13v1a4 4 0 0 1-4 4H3"/>',
    phone: `<path d="${PHONE_PATH}"/>`, phoneFill: `<path fill="currentColor" stroke="none" d="${PHONE_PATH}"/>`,
    phoneDown: `<g transform="rotate(135 12 12)"><path fill="currentColor" stroke="none" d="${PHONE_PATH}"/></g>`,
    video: '<path d="m22 8-6 4 6 4V8Z"/><rect x="2" y="6" width="14" height="12" rx="2"/>',
    mic: '<rect x="9" y="2" width="6" height="12" rx="3"/><path d="M5 10a7 7 0 0 0 14 0M12 17v4M8 21h8"/>', micOff: '<rect x="9" y="2" width="6" height="12" rx="3"/><path d="M5 10a7 7 0 0 0 14 0M12 17v4M8 21h8M3 3l18 18"/>',
    camera: '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/>',
    share: '<path d="M12 3v12M8 7l4-4 4 4M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7"/>', compose: '<path d="M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/>',
    mail: '<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 7L2 7"/>',
    star: '<path d="m12 2 3.1 6.3 6.9 1-5 4.9 1.2 6.8L12 17.8 5.8 21l1.2-6.8-5-4.9 6.9-1z"/>', starFill: '<path fill="currentColor" d="m12 2 3.1 6.3 6.9 1-5 4.9 1.2 6.8L12 17.8 5.8 21l1.2-6.8-5-4.9 6.9-1z"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>', alarm: '<circle cx="12" cy="13" r="8"/><path d="M12 9v4l2 2M5 3 2 6M22 6l-3-3"/>',
    timer: '<circle cx="12" cy="14" r="8"/><path d="M10 2h4M12 14l3-3"/>', stopwatch: '<circle cx="12" cy="13" r="8"/><path d="M12 9v4M10 2h4M12 2v3"/>',
    globe: '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>',
    list: '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
    grid: '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>',
    bookmark: '<path d="m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>', tabs: '<rect x="6" y="3" width="15" height="15" rx="3"/><path d="M3 8v10a3 3 0 0 0 3 3h10"/>',
    arrowL: '<path d="M19 12H5M12 19l-7-7 7-7"/>', arrowR: '<path d="M5 12h14M12 5l7 7-7 7"/>', arrowUp: '<path d="M12 19V5M5 12l7-7 7 7"/>', arrowDown: '<path d="M12 5v14M5 12l7 7 7-7"/>',
    gear: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>',
    wifi: '<path d="M5 12.55a11 11 0 0 1 14.08 0M1.42 9a16 16 0 0 1 21.16 0M8.53 16.11a6 6 0 0 1 6.95 0"/><circle cx="12" cy="20" r="1" fill="currentColor"/>',
    bluetooth: '<path d="m7 7 10 10-5 5V2l5 5L7 17"/>',
    airplane: '<path d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/>',
    cellular: '<path d="M2 20h.01M7 20v-4M12 20v-8M17 20V8M22 4v16"/>', moon: '<path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/>',
    sun: '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M6.3 17.7l-1.4 1.4M19.1 4.9l-1.4 1.4"/>',
    bell: '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0"/>', bellOff: '<path d="M8.7 3A6 6 0 0 1 18 8c0 2 .3 3.7.9 5M17 17H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0M2 2l20 20"/>',
    lock: '<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>', unlock: '<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/>',
    battery: '<rect x="2" y="7" width="16" height="10" rx="2"/><path d="M22 11v2M5 10v4M8 10v4"/>', lowpower: '<rect x="2" y="7" width="16" height="10" rx="2"/><path d="M22 11v2M6 12h4"/>',
    textsize: '<path d="M4 7V4h16v3M9 20h6M12 4v16"/>',
    hand: '<path d="M18 11V6a2 2 0 0 0-4 0v1M14 10V4a2 2 0 0 0-4 0v2M10 10.5V6a2 2 0 0 0-4 0v8"/><path d="M18 8a2 2 0 1 1 4 0v6a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15"/>',
    eye: '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/>',
    person: '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>', personCircle: '<circle cx="12" cy="12" r="10"/><circle cx="12" cy="10" r="3"/><path d="M6.2 18.5a7 7 0 0 1 11.6 0"/>',
    personPlus: '<circle cx="10" cy="8" r="4"/><path d="M2 21a8 8 0 0 1 16 0M19 8v6M16 11h6"/>', users: '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>',
    keypad: '<g fill="currentColor" stroke="none"><circle cx="6" cy="5" r="1.8"/><circle cx="12" cy="5" r="1.8"/><circle cx="18" cy="5" r="1.8"/><circle cx="6" cy="11" r="1.8"/><circle cx="12" cy="11" r="1.8"/><circle cx="18" cy="11" r="1.8"/><circle cx="6" cy="17" r="1.8"/><circle cx="12" cy="17" r="1.8"/><circle cx="18" cy="17" r="1.8"/><circle cx="12" cy="22" r="1.8"/></g>',
    voicemail: '<circle cx="6" cy="12" r="4"/><circle cx="18" cy="12" r="4"/><path d="M6 16h12"/>',
    message: '<path d="M21 11.5a8.4 8.4 0 0 1-9 8.4 9.6 9.6 0 0 1-2.8-.4L4 21l1.4-4.2A8.3 8.3 0 0 1 4 11.5C4 6.8 7.8 3.5 12.5 3.5S21 6.8 21 11.5z"/>',
    calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>', checkCircle: '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>', circle: '<circle cx="12" cy="12" r="10"/>',
    home: '<path d="m3 11 9-8 9 8v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 22V12h6v10"/>', map: '<path d="M3 6v15l6-3 6 3 6-3V3l-6 3-6-3z"/><path d="M9 3v15M15 6v15"/>',
    pin: '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/>', nav: '<path d="m3 11 19-9-9 19-2-8z"/>',
    location: '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/><circle cx="12" cy="12" r="8"/>',
    car: '<path d="M5 17h14M6 17v2H4v-6l2-5h12l2 5v6h-2v-2M3 13h18"/><circle cx="7.5" cy="14.5" r="1" fill="currentColor"/><circle cx="16.5" cy="14.5" r="1" fill="currentColor"/>',
    walk: '<circle cx="13" cy="4" r="2"/><path d="m10 22 2-8M14 22l-2-5-2-4M9 13l3-4 3 1 3 3"/>',
    cloud: '<path d="M17.5 19H9a7 7 0 1 1 6.7-9h1.8a4.5 4.5 0 1 1 0 9Z"/>', cloudSun: '<path d="M12 2v2M4.9 4.9l1.4 1.4M2 12h2M20 12h2M19.1 4.9l-1.4 1.4"/><path d="M15.9 11.6A5 5 0 1 0 8.4 13"/><path d="M13 22H7a5 5 0 1 1 4.5-7h1.5a3.5 3.5 0 0 1 0 7Z"/>',
    rain: '<path d="M16 13v8M8 13v8M12 15v8"/><path d="M20 16.6A5 5 0 0 0 18 7h-1.3A7 7 0 1 0 6 16.5"/>', wind: '<path d="M17.7 7.7a2.5 2.5 0 1 1 1.8 4.3H2M9.6 4.6A2 2 0 1 1 11 8H2M12.6 19.4A2 2 0 1 0 14 16H2"/>',
    drop: '<path d="M12 22a7 7 0 0 0 7-7c0-2-1-3.9-3-5.5s-3.5-4-4-6.5c-.5 2.5-2 4.9-4 6.5S5 13 5 15a7 7 0 0 0 7 7z"/>',
    /* duas pessoas (separador Pessoas da Encontrar, como o person.2 do PearOS) */
    people: '<circle cx="9" cy="8" r="3.6"/><path d="M2.5 19.5c0-3.6 2.9-6 6.5-6s6.5 2.4 6.5 6"/><circle cx="17" cy="9" r="2.8"/><path d="M15.4 13.6c3.3-.3 6.1 1.9 6.1 5.4"/>',
    /* meteorologia a sério (tipos de tempo do jogo): neve, nevoeiro, trovoada */
    snow: '<path d="M12 2v20M2 12h20M5 5l14 14M19 5L5 19"/><path d="M12 5l-2-2M12 5l2-2M12 19l-2 2M12 19l2 2M5 12l-2-2M5 12l-2 2M19 12l2-2M19 12l2 2"/>',
    fog: '<path d="M20 12.5A5 5 0 0 0 18 3.5h-1.3A7 7 0 1 0 6 13"/><path d="M4 17h16M6 21h12"/>',
    storm: '<path d="M20 15.6A5 5 0 0 0 18 6h-1.3A7 7 0 1 0 6 15.5"/><path d="M13 11l-3 6h4l-3 6"/>',
    chart: '<path d="M3 3v18h18M7 15l4-5 4 3 5-7"/>', card: '<rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/>',
    book: '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>',
    gamepad: '<path d="M6 12h4M8 10v4M15 13h.01M18 11h.01"/><path d="M17.3 5H6.7a4 4 0 0 0-4 3.6l-.6 6.8A2.7 2.7 0 0 0 6.8 17l2-2.5h6.4l2 2.5a2.7 2.7 0 0 0 4.7-1.6l-.6-6.8a4 4 0 0 0-4-3.6z"/>',
    tv: '<rect x="2" y="4" width="20" height="14" rx="2"/><path d="M8 22h8"/>', music: '<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>',
    headphones: '<path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>',
    earbuds: '<path d="M6 4a3 3 0 0 1 3 3v6a3 3 0 0 1-6 0V7a3 3 0 0 1 3-3zM18 4a3 3 0 0 1 3 3v6a3 3 0 0 1-6 0V7a3 3 0 0 1 3-3z"/><path d="M9 16v2a1 1 0 0 1-1 1H5M15 16v2a1 1 0 0 0 1 1h3"/>',
    translate: '<path d="m5 8 6 6M4 14l6-6 2-3M2 5h12M7 2h1M22 22l-5-10-5 10M14 18h6"/>',
    bulb: '<path d="M9 18h6M10 22h4M15.1 14a5 5 0 1 0-6.2 0c.8.7 1.1 1.4 1.1 2v1h4v-1c0-.6.3-1.3 1.1-2z"/>', thermo: '<path d="M14 4v10.5a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z"/>',
    fan: '<circle cx="12" cy="12" r="2"/><path d="M12 10a5 5 0 0 1 0-8 5 5 0 0 1 0 8zM14 12a5 5 0 0 1 8 0 5 5 0 0 1-8 0zM12 14a5 5 0 0 1 0 8 5 5 0 0 1 0-8zM10 12a5 5 0 0 1-8 0 5 5 0 0 1 8 0z"/>',
    plug: '<path d="M9 2v6M15 2v6M6 8h12v4a6 6 0 0 1-12 0zM12 18v4"/>',
    speaker: '<path d="M11 5 6 9H2v6h4l5 4z"/><path d="M15.5 8.5a5 5 0 0 1 0 7M19 5a9 9 0 0 1 0 14"/>', speakerLow: '<path d="M11 5 6 9H2v6h4l5 4z"/>', volumeX: '<path d="M11 5 6 9H2v6h4l5 4z"/><path d="m23 9-6 6M17 9l6 6"/>',
    dot: '<circle cx="12" cy="12" r="5" fill="currentColor" stroke="none"/>', info: '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>',
    update: '<path d="M21 12a9 9 0 1 1-3-6.7M21 3v6h-6"/>', storage: '<rect x="2" y="4" width="20" height="7" rx="2"/><rect x="2" y="13" width="20" height="7" rx="2"/><path d="M6 7.5h.01M6 16.5h.01"/>',
    faceid: '<path d="M7 3H5a2 2 0 0 0-2 2v2M17 3h2a2 2 0 0 1 2 2v2M7 21H5a2 2 0 0 1-2-2v-2M17 21h2a2 2 0 0 0 2-2v-2M9 9h.01M15 9h.01M12 9v4h-1M9 15.5a4 4 0 0 0 6 0"/>',
    key: '<circle cx="8" cy="15" r="4"/><path d="m10.9 12.1 8.1-8.1M21 6l-2-2M17 8l-2-2"/>', sliders: '<path d="M4 21v-7M4 10V3M12 21v-9M12 8V3M20 21v-5M20 12V3M1 14h6M9 8h6M17 16h6"/>',
    download: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>',
    cart: '<circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2 2h2l2.7 12.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L22 7H5.1"/>',
    photo: '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-5-5L5 21"/>', image: '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-5-5L5 21"/>',
    power: '<path d="M18.36 6.64a9 9 0 1 1-12.73 0M12 2v10"/>', briefcase: '<rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2M2 13h20"/>',
    bank: '<path d="M3 9.5 12 4l9 5.5M5 10v8M9.5 10v8M14.5 10v8M19 10v8M3 20.5h18"/>', dollar: '<path d="M12 2v20M17 6.5H9.5a3 3 0 0 0 0 6h5a3 3 0 0 1 0 6H6"/>',
    hourglass: '<path d="M6 2h12M6 22h12M7 2v4.5a5 5 0 0 0 2.5 4.3L12 12l-2.5 1.2A5 5 0 0 0 7 17.5V22M17 2v4.5a5 5 0 0 1-2.5 4.3L12 12l2.5 1.2a5 5 0 0 1 2.5 4.3V22"/>',
    flag: '<path d="M4 22V4a1 1 0 0 1 1-1h11l-2 4 2 4H5"/>', newspaper: '<path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0V6"/><path d="M18 14h-8M15 18h-5M10 6h8v4h-8z"/>',
    calc: '<rect x="4" y="2" width="16" height="20" rx="2"/><path d="M8 6h8M8 12h.01M12 12h.01M16 12h.01M8 16h.01M12 16h.01M16 16h.01"/>',
    apple: '<path fill="currentColor" stroke="none" d="M16.4 12.6c0-2.4 2-3.6 2.1-3.7-1.1-1.7-2.9-1.9-3.5-1.9-1.5-.2-2.9.9-3.7.9-.8 0-1.9-.9-3.2-.8-1.6 0-3.1 1-4 2.4-1.7 3-.4 7.3 1.2 9.7.8 1.2 1.8 2.5 3 2.4 1.2 0 1.7-.8 3.2-.8s1.9.8 3.2.8c1.3 0 2.2-1.2 3-2.4.9-1.3 1.3-2.6 1.3-2.7 0 0-2.6-1-2.6-3.9zM14 5.4c.7-.8 1.1-1.9 1-3-1 0-2.1.7-2.8 1.5-.6.7-1.2 1.9-1 2.9 1.1.1 2.1-.5 2.8-1.4z"/>',
    ellipsisCircle: '<circle cx="12" cy="12" r="10"/><g fill="currentColor" stroke="none"><circle cx="8" cy="12" r="1.3"/><circle cx="12" cy="12" r="1.3"/><circle cx="16" cy="12" r="1.3"/></g>',
    sparkles: '<path d="m12 3 1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9zM5 3v4M3 5h4M19 17v4M17 19h4"/>',
    send: '<path d="m22 2-7 20-4-9-9-4z"/><path d="M22 2 11 13"/>', copy: '<rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>',
    forward: '<path d="m15 17 5-5-5-5"/><path d="M4 18v-2a4 4 0 0 1 4-4h12"/>', reply: '<path d="m9 17-5-5 5-5"/><path d="M20 18v-2a4 4 0 0 0-4-4H4"/>',
    paperclip: '<path d="m21.44 11.05-9.19 9.19a6 6 0 0 1-8.49-8.49l8.57-8.57A4 4 0 1 1 18 8.84l-8.59 8.57a2 2 0 0 1-2.83-2.83l8.49-8.48"/>',
    /* lanterna: cabeça em trapézio a estreitar para baixo + corpo estreito + raios. A anterior tinha a boca larga com uma
       "tampa" a meio e lia-se como um CAIXOTE DO LIXO no ecrã bloqueado. */
    flashlight: '<path d="M8.2 4.2h7.6l-.9 4.1H9.1z"/><path d="M9.1 8.3h5.8v11.2a1.5 1.5 0 0 1-1.5 1.5h-2.8a1.5 1.5 0 0 1-1.5-1.5z"/><path d="M12 12.2v2.6"/><path d="M12 1.4v1.3M6.7 2.6l.7 1.1M17.3 2.6l-.7 1.1"/>',
    rotate: '<path d="M21 12a9 9 0 1 1-3-6.7"/><path d="M21 3v6h-6"/><rect x="9" y="9" width="6" height="8" rx="1"/>', mirror: '<rect x="2" y="4" width="20" height="13" rx="2"/><path d="M8 21h8M12 17v4M6 8h6"/>',
    record: '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4" fill="currentColor"/>', bolt: '<path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z"/>',
    shield: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>', hash: '<path d="M4 9h16M4 15h16M10 3 8 21M16 3l-2 18"/>',
    at: '<circle cx="12" cy="12" r="4"/><path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"/>', ghost: '<path d="M9 10h.01M15 10h.01M12 2a8 8 0 0 0-8 8v12l3-3 2.5 3 2.5-3 2.5 3 2.5-3 3 3V10a8 8 0 0 0-8-8z"/>',
    sim: '<path d="M6 2h8l4 4v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z"/><rect x="7" y="11" width="10" height="7" rx="1"/><path d="M10 11v7M14 11v7M7 14.5h10"/>',
    expand: '<path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/>', minimize: '<path d="M4 14h6v6M20 10h-6V4M14 10l7-7M3 21l7-7"/>',
    zoom: '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5M11 8v6M8 11h6"/>', wrench: '<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>',
    lifebuoy: '<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="4"/><path d="m4.93 4.93 4.24 4.24M14.83 9.17l4.24-4.24M14.83 14.83l4.24 4.24M9.17 14.83l-4.24 4.24"/>',
    smile: '<circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01"/>', backspace: '<path d="M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z"/><path d="m18 9-6 6M12 9l6 6"/>',
    shiftKey: '<path d="M12 3 3 12h5v8h8v-8h5z"/>', enter: '<path d="M9 10 4 15l5 5"/><path d="M20 4v7a4 4 0 0 1-4 4H4"/>',
    link: '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>',
    logout: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>', ban: '<circle cx="12" cy="12" r="10"/><path d="m4.9 4.9 14.2 14.2"/>',
    move: '<path d="M5 9l-3 3 3 3M9 5l3-3 3 3M15 19l-3 3-3-3M19 9l3 3-3 3M2 12h20M12 2v20"/>', folder: '<path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/>',
    plusCircle: '<circle cx="12" cy="12" r="10"/><path d="M12 8v8M8 12h8"/>', xCircle: '<circle cx="12" cy="12" r="10"/><path d="m15 9-6 6M9 9l6 6"/>', minusCircle: '<circle cx="12" cy="12" r="10"/><path d="M8 12h8"/>',
    compass: '<circle cx="12" cy="12" r="10"/><path d="m16.24 7.76-2.12 6.36-6.36 2.12 2.12-6.36z"/>', aperture: '<circle cx="12" cy="12" r="10"/><path d="m14.31 8 5.74 9.94M9.69 8h11.48M7.38 12l5.74-9.94M9.69 16 3.95 6.06M14.31 16H2.83M16.62 12l-5.74 9.94"/>',
    film: '<rect x="2" y="2" width="20" height="20" rx="2"/><path d="M7 2v20M17 2v20M2 12h20M2 7h5M2 17h5M17 17h5M17 7h5"/>', tag: '<path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><path d="M7 7h.01"/>',
    clipboard: '<rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>',
    receipt: '<path d="M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1z"/><path d="M8 7h8M8 11h8M8 15h5"/>',
    gauge: '<path d="m12 14 4-4"/><path d="M3.34 19a10 10 0 1 1 17.32 0"/>', fuel: '<path d="M3 22V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v16M3 22h10M13 10h2a2 2 0 0 1 2 2v3a1.5 1.5 0 0 0 3 0V9l-3-3"/><path d="M5 8h6"/>',
    layers: '<path d="m12 2 10 6-10 6L2 8z"/><path d="m2 14 10 6 10-6"/>', pen: '<path d="M17 3a2.83 2.83 0 0 1 4 4L7.5 20.5 2 22l1.5-5.5z"/>',
    chat: '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>', activity: '<path d="M22 12h-4l-3 9L9 3l-3 9H2"/>',
    flame: '<path d="M12 2c1.5 4 5 5.5 5 11a5 5 0 0 1-10 0c0-2.5 1-4 2-5 .5 2 1.5 3 2.5 3.5C12 9 11 6 12 2z"/>', garage: '<path d="M3 10 12 3l9 7v10H3z"/><path d="M7 20v-7h10v7M7 16h10"/>', bag2: '<path d="M6 8h12l1 12H5z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
    /* AppShop PearOS 26: Hoje (página), Jogos (foguetão), Arcade (joystick) */
    today: '<rect x="3.5" y="4" width="17" height="16" rx="3"/><path d="M7.5 9.5h9M7.5 13.5h9M7.5 17h5"/>',
    rocket: '<path d="M12 2.5c3.1 2.3 4.6 5.7 4.6 10.2L12 16.6l-4.6-3.9C7.4 8.2 8.9 4.8 12 2.5z"/><circle cx="12" cy="9.6" r="1.7"/><path d="M7.5 12.4 4.4 15.3l3.3.5M16.5 12.4l3.1 2.9-3.3.5M10 17.6c-.3 1.6-1 2.9-2.2 3.9 1.8.1 3.1-.4 4.2-1.4 1.1 1 2.4 1.5 4.2 1.4-1.2-1-1.9-2.3-2.2-3.9"/>',
    joystick: '<circle cx="12" cy="6" r="3"/><path d="M12 9v6"/><rect x="4" y="15" width="16" height="5.5" rx="2.2"/><path d="M8 17.8h.01M16 17.8h.01"/>',
    /* AirShare (PearOS): ponto ao centro e arcos concêntricos abertos em baixo (pacote AD) */
    airdrop: '<circle cx="12" cy="12" r="2.2" fill="currentColor" stroke="none"/><path d="M7.9 16.4a5.8 5.8 0 0 1 0-8.8M16.1 7.6a5.8 5.8 0 0 1 0 8.8"/><path d="M5.1 19.6a9.8 9.8 0 0 1 0-15.2M18.9 4.4a9.8 9.8 0 0 1 0 15.2"/>',
    /* conta-gotas (Personalizar → escolher a cor do fundo) */
    eyedropper: '<path d="m2 22 1-1h3l9-9"/><path d="M3 21v-3l9-9"/><path d="m15 6 3.4-3.4a2.1 2.1 0 1 1 3 3L18 9l.4.4a2.1 2.1 0 1 1-3 3l-3.8-3.8a2.1 2.1 0 1 1 3-3l.4.4z"/>',
  };

  function g(name, size) { const s = size ? ` width="${size}" height="${size}"` : ''; return `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"${s}>${P[name] || ''}</svg>`; }

  function tickClocks(root) {
    const d = new Date(); const h = (d.getHours() % 12) * 30 + d.getMinutes() * .5, m = d.getMinutes() * 6 + d.getSeconds() * .1, s = d.getSeconds() * 6;
    const r = root || document;
    r.querySelectorAll('.hh').forEach(e => e.setAttribute('transform', `rotate(${h} 50 50)`));
    r.querySelectorAll('.mh').forEach(e => e.setAttribute('transform', `rotate(${m} 50 50)`));
    r.querySelectorAll('.sh').forEach(e => e.setAttribute('transform', `rotate(${s} 50 50)`));
  }
  return { app, tile, tileUrl, tileBox, clearTiles, custom, g, tickClocks, MESES, has: n => !!P[n], SVG, G, GL, registerOS, OS_APP, P,
    /* 1.4.0 - estilos (Predefinido / Escuro / Transparente / Colorido): setStyle({ mode, hue, sat, tone }, { live }) · style() · styleSig()
       · styled(id, style) (SVG, sem cache) · styledUrl(id, style) (o mesmo em url('data:…') para background-image) · restyle() */
    setStyle, style: () => Object.assign({}, STYLE), styleSig: () => sigS, styled, styledUrl: (id, st) => toUrl(styled(id, st)), restyle: () => restyle(true), MODES: MODES.slice() };
})();
