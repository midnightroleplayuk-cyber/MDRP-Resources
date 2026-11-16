/* ============================================================
   WALLPAPERS: fundos "PearPhone 18" (anéis metálicos) desenhados em
   SVG, em todas as cores do PearPhone 18 / 17 Pro / Air, + ficheiros
   opcionais em html/img/wallpapers/ (Config.Wallpapers).
   ANDROID (NOVA S26 Ultra, Nova UI 8.5): os fundos do aparelho são os
   ficheiros s26-*.jpg (dobras de cetim, um por cor). Cada sistema vê a
   SUA lista: o PearPhone nunca mostra os s26-*, o S26 nunca mostra os
   fundos de cor do PearPhone. Os extras que o servidor juntar aparecem
   nos dois.
   NOVA Flip (moldura flip-*): cetim DESENHADO na cor do aparelho
   (FLIP_SETS, svgFlip), sem ficheiros; só aparece com um Flip aberto.
   ============================================================ */
window.Wallpapers = (() => {
  /* colorways: bg (fundo), hi (luz), mid (corpo), lo (sombra), glow (brilho de fundo) */
  const SETS = [
    { id: 'orange',   name: 'Cosmic Orange', bg: '#F0701F', hi: '#FFCB9A', mid: '#E4611A', lo: '#4A1702', glow: '#FFD6B0', dark: false },
    { id: 'blue',     name: 'Deep Blue',     bg: '#1F3F72', hi: '#A9CBFF', mid: '#2F5EA3', lo: '#050E22', glow: '#8FB5F5', dark: true },
    { id: 'silver',   name: 'Silver',        bg: '#D7D9DD', hi: '#FFFFFF', mid: '#B5B8BF', lo: '#4E515A', glow: '#FFFFFF', dark: false },
    { id: 'black',    name: 'Space Black',   bg: '#141417', hi: '#86868F', mid: '#2A2A30', lo: '#000000', glow: '#55555E', dark: true },
    { id: 'sky',      name: 'Sky Blue',      bg: '#ABD2F4', hi: '#FFFFFF', mid: '#8CBBE4', lo: '#2F5F8C', glow: '#FFFFFF', dark: false },
    { id: 'gold',     name: 'Light Gold',    bg: '#E8D6B3', hi: '#FFF8E8', mid: '#D6BF95', lo: '#7A5C2E', glow: '#FFFFFF', dark: false },
    { id: 'lavender', name: 'Lavender',      bg: '#C7B5E7', hi: '#F6F0FF', mid: '#B097DB', lo: '#4E3782', glow: '#FFFFFF', dark: false },
    { id: 'sage',     name: 'Sage',          bg: '#B6C7AE', hi: '#F2F8EE', mid: '#9BB092', lo: '#3F5238', glow: '#FFFFFF', dark: false },
    { id: 'mist',     name: 'Mist Blue',     bg: '#B8CEE3', hi: '#F4F9FE', mid: '#99B5D1', lo: '#3E5F81', glow: '#FFFFFF', dark: false },
    { id: 'white',    name: 'White',         bg: '#F0F0F2', hi: '#FFFFFF', mid: '#D3D3D8', lo: '#7C7C86', glow: '#FFFFFF', dark: false },
    { id: 'wine',     name: 'Bordô',         bg: '#5A2A33', hi: '#E8A9B4', mid: '#7A3A46', lo: '#1C0A0E', glow: '#D98C9A', dark: true },
  ];
  /* cores do NOVA S26 Ultra (as dos ficheiros s26-*.jpg): o tone() e o `dark` saem daqui; o desenho de recurso
     (sem ficheiros) também. `dark` = o relógio branco do bloqueado lê-se bem por cima (o Branco é o único claro). */
  const S26_SETS = [
    { id: 's26-black',  name: 'Preto',        bg: '#141519', hi: '#9EABC0', mid: '#2A2D34', lo: '#030405', glow: '#5D7396', dark: true },
    { id: 's26-white',  name: 'Branco',       bg: '#A9AEB8', hi: '#F2F3F6', mid: '#A4A9B4', lo: '#596070', glow: '#F6ECDF', dark: false },
    { id: 's26-violet', name: 'Violeta',      bg: '#4F4994', hi: '#D9D0F5', mid: '#5B55A2', lo: '#171446', glow: '#E59BD8', dark: true },
    { id: 's26-sky',    name: 'Azul-celeste', bg: '#5D97CE', hi: '#E3F0FB', mid: '#64A0D5', lo: '#1E4F80', glow: '#8FF0F0', dark: true },
  ];
  /* NOVA Flip (2026-10-01): um fundo de cetim por cor do aparelho, DESENHADO aqui (sem ficheiros: o jogo so serve os
     que estao em Config.Wallpapers). Cores tiradas das texturas dos modelos (flip_*_color.png), em tom medio para os
     nomes brancos dos icones se lerem. `sh` = forca das sombras (o creme fica claro). So entram na lista com um Flip. */
  const FLIP_SETS = [
    { id: 'flip-lavender',  name: 'Lavanda',  bg: '#9686C8', hi: '#F4EEFF', mid: '#8B7CC2', lo: '#2C2361', glow: '#F7D5F3', dark: true },
    { id: 'flip-grey',      name: 'Grafite',  bg: '#2C2F35', hi: '#C9D0DA', mid: '#3B3F47', lo: '#050607', glow: '#8798B2', dark: true },
    { id: 'flip-cream',     name: 'Creme',    bg: '#D6C7A2', hi: '#FFFAEE', mid: '#CDBC92', lo: '#977C52', glow: '#FFF2D6', dark: false, sh: .7 },
    { id: 'flip-pistachio', name: 'Pistácio', bg: '#A2B889', hi: '#F3F9E6', mid: '#96AE7D', lo: '#3D5634', glow: '#F4FFD8', dark: true, sh: .85 },
  ];
  /* sistema do aparelho aberto (System.os); antes do System existir é o PearOS */
  const isAnd = () => !!(window.System && System.os === 'android');
  /* geometria dos anéis (cx, cy, rx, ry, rotação, espessura): cluster em diagonal como no wallpaper do 17 Pro */
  const RINGS = [
    [150, 330, 98, 84, -28, 46], [300, 300, 66, 56, 18, 40], [352, 405, 54, 46, -12, 34],
    [292, 512, 62, 53, 24, 38], [176, 560, 74, 62, -20, 42], [96, 470, 50, 42, 14, 32], [230, 640, 44, 38, -30, 28],
  ];
  const cache = {};
  function svg(set) {
    let defs = `<defs><filter id="bl" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="16"/></filter><filter id="bl2" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="3"/></filter>
      <radialGradient id="glow" cx="30%" cy="28%" r="70%"><stop offset="0" stop-color="${set.glow}" stop-opacity=".55"/><stop offset=".55" stop-color="${set.glow}" stop-opacity="0"/></radialGradient>
      <radialGradient id="vig" cx="60%" cy="80%" r="90%"><stop offset=".4" stop-color="${set.lo}" stop-opacity="0"/><stop offset="1" stop-color="${set.lo}" stop-opacity=".55"/></radialGradient>`;
    let body = `<rect width="440" height="956" fill="${set.bg}"/><rect width="440" height="956" fill="url(#glow)"/>`;
    let shadows = '', rings = '';
    RINGS.forEach(([cx, cy, rx, ry, rot, w], i) => {
      defs += `<linearGradient id="r${i}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${set.hi}"/><stop offset=".42" stop-color="${set.mid}"/><stop offset=".75" stop-color="${set.lo}"/><stop offset="1" stop-color="${set.mid}"/></linearGradient>
        <linearGradient id="s${i}" x1="1" y1="1" x2="0" y2="0"><stop offset="0" stop-color="${set.hi}" stop-opacity=".95"/><stop offset=".35" stop-color="${set.hi}" stop-opacity="0"/></linearGradient>`;
      const t = `transform="rotate(${rot} ${cx} ${cy})"`;
      shadows += `<ellipse cx="${cx + 14}" cy="${cy + 22}" rx="${rx}" ry="${ry}" fill="none" stroke="${set.lo}" stroke-opacity=".5" stroke-width="${w}" ${t} filter="url(#bl)"/>`;
      rings += `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="none" stroke="url(#r${i})" stroke-width="${w}" ${t}/>
        <ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="none" stroke="url(#s${i})" stroke-width="${w * .55}" ${t} opacity=".9"/>
        <ellipse cx="${cx}" cy="${cy}" rx="${rx - w / 2 + 1.5}" ry="${ry - w / 2 + 1.5}" fill="none" stroke="${set.hi}" stroke-opacity=".55" stroke-width="2" ${t} filter="url(#bl2)"/>
        <ellipse cx="${cx}" cy="${cy}" rx="${rx + w / 2 - 1}" ry="${ry + w / 2 - 1}" fill="none" stroke="${set.lo}" stroke-opacity=".45" stroke-width="1.5" ${t}/>`;
    });
    body += shadows + rings + `<rect width="440" height="956" fill="url(#vig)"/>`;
    return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 956" width="440" height="956">${defs}</defs>${body}</svg>`;
  }
  /* desenho de RECURSO do S26 (só quando o servidor não lista nenhum s26-*.jpg): as mesmas dobras de cetim em
     diagonal, em versão leve (três faixas com sombra, corpo e brilho na crista) */
  function svgFold(set) {
    const bands = [[250, 1], [560, .8], [860, .65]];
    let body = '';
    bands.forEach(([y0, k]) => {
      const d = `M-80 ${y0 + 60}C110 ${y0 - 60} 250 ${y0 + 70} 520 ${y0 - 250}`;
      body += `<path d="${d}" fill="none" stroke="${set.lo}" stroke-opacity="${(.55 * k).toFixed(2)}" stroke-width="150" transform="translate(16 34)" filter="url(#fb)"/>`
        + `<path d="${d}" fill="none" stroke="${set.mid}" stroke-width="130" filter="url(#fs)"/>`
        + `<path d="${d}" fill="none" stroke="${set.hi}" stroke-opacity="${(.75 * k).toFixed(2)}" stroke-width="14" transform="translate(-10 -38)" filter="url(#fh)"/>`;
    });
    return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 956" width="440" height="956"><defs>`
      + `<filter id="fb" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="34"/></filter><filter id="fs" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="16"/></filter><filter id="fh" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="6"/></filter>`
      + `<linearGradient id="fg" x1="0" y1="0" x2=".35" y2="1"><stop offset="0" stop-color="${set.bg}"/><stop offset="1" stop-color="${set.lo}"/></linearGradient>`
      + `<radialGradient id="fl" cx="85%" cy="70%" r="60%"><stop offset="0" stop-color="${set.glow}" stop-opacity=".28"/><stop offset="1" stop-color="${set.glow}" stop-opacity="0"/></radialGradient></defs>`
      + `<rect width="440" height="956" fill="url(#fg)"/>${body}<rect width="440" height="956" fill="url(#fl)"/></svg>`;
  }
  /* NOVA Flip: o mesmo cetim do S26 mas a descer para a direita (espelhado), mais largo e macio: sombra desfocada, corpo,
     crista larga e um fio de luz fino por cima. Brilho no canto de cima e sombra no fundo. */
  function svgFlip(set) {
    const F = [['M-140 330C40 200 210 360 580 80', .75, 150], ['M-140 640C60 470 250 640 580 360', 1, 175], ['M-140 960C70 790 280 930 580 660', .7, 150]];
    const sh = set.sh || 1; let body = '';
    F.forEach(([d, k, w]) => {
      body += `<path d="${d}" fill="none" stroke="${set.lo}" stroke-opacity="${(.6 * k * sh).toFixed(2)}" stroke-width="${w + 30}" transform="translate(-18 40)" filter="url(#xb)"/>`
        + `<path d="${d}" fill="none" stroke="${set.mid}" stroke-width="${w}" filter="url(#xs)"/>`
        + `<path d="${d}" fill="none" stroke="${set.hi}" stroke-opacity="${(.4 * k).toFixed(2)}" stroke-width="50" transform="translate(8 -30)" filter="url(#xs2)"/>`
        + `<path d="${d}" fill="none" stroke="${set.hi}" stroke-opacity="${(.62 * k).toFixed(2)}" stroke-width="6" transform="translate(9 -44)" filter="url(#xh)"/>`;
    });
    const blur = (id, s) => `<filter id="${id}" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="${s}"/></filter>`;
    return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 956" width="440" height="956"><defs>${blur('xb', 30)}${blur('xs', 14)}${blur('xs2', 12)}${blur('xh', 3.2)}`
      + `<linearGradient id="xg" x1="0" y1="0" x2=".3" y2="1"><stop offset="0" stop-color="${set.bg}"/><stop offset=".55" stop-color="${set.mid}"/><stop offset="1" stop-color="${set.lo}"/></linearGradient>`
      + `<radialGradient id="xl" cx="88%" cy="18%" r="62%"><stop offset="0" stop-color="${set.glow}" stop-opacity=".38"/><stop offset="1" stop-color="${set.glow}" stop-opacity="0"/></radialGradient>`
      + `<radialGradient id="xv" cx="30%" cy="100%" r="70%"><stop offset="0" stop-color="${set.lo}" stop-opacity="${(.45 * sh).toFixed(2)}"/><stop offset="1" stop-color="${set.lo}" stop-opacity="0"/></radialGradient></defs>`
      + `<rect width="440" height="956" fill="url(#xg)"/><g transform="matrix(-1 0 0 1 440 0)">${body}</g><rect width="440" height="956" fill="url(#xl)"/><rect width="440" height="956" fill="url(#xv)"/></svg>`;
  }
  /* aspas SIMPLES: estes valores entram em style="background:…" (aspas duplas partiam o atributo e as miniaturas ficavam vazias) */
  const dataUri = set => cache[set.id] || (cache[set.id] = `url('data:image/svg+xml;charset=utf-8,${encodeURIComponent(S26_SETS.includes(set) ? svgFold(set) : FLIP_SETS.includes(set) ? svgFlip(set) : svg(set)).replace(/'/g, '%27')}')`);
  const LEGACY = { 'wp-bronze': 'orange', 'wp-orange': 'orange', 'wp-blue': 'blue', 'wp-purple': 'lavender', 'wp-green': 'sage', 'wp-pink': 'lavender', 'wp-mono': 'black' };
  /* fundos OFICIAIS (ficheiros em html/img/wallpapers, lista em Config.Wallpapers; o Lua sobrepõe esta lista no arranque).
     Um por COR DE APARELHO (PearPhone 18 Pro Max): black / white / blue (azul-gelo) / wine (bordô).
     NOVA S26 Ultra: s26-black / s26-white / s26-violet / s26-sky. */
  const NAMES = { black: 'Preto', white: 'Branco', blue: 'Azul-gelo', wine: 'Bordô',
    's26-black': 'Preto', 's26-white': 'Branco', 's26-violet': 'Violeta', 's26-sky': 'Azul-celeste' };
  /* ficheiro → colorway desenhada equivalente (para tone() e para o `dark`) */
  const FILE_SET = { black: 'black', white: 'white', blue: 'blue', wine: 'wine',
    's26-black': 's26-black', 's26-white': 's26-white', 's26-violet': 's26-violet', 's26-sky': 's26-sky' };
  let files = ['black.jpg', 'white.jpg', 'blue.jpg', 'wine.jpg', 's26-black.jpg', 's26-white.jpg', 's26-violet.jpg', 's26-sky.jpg'];
  /* de que sistema é cada ficheiro: s26-* (ou nova-*) só no Android; os fundos de cor do PearPhone só no PearOS;
     qualquer outro que o servidor junte vale nos dois */
  const AND_FILE = /^(s26|nova)-/i;
  const IOS_OWN = new Set(['black.jpg', 'white.jpg', 'blue.jpg', 'wine.jpg', 'cosmic-orange.jpg', 'silver.jpg', 'deep-blue.jpg']);
  const iosFiles = () => files.filter(f => !AND_FILE.test(f));
  const andFiles = () => files.filter(f => !IOS_OWN.has(f.toLowerCase()));
  const osFiles = () => isAnd() ? andFiles() : iosFiles();
  /* FUNDOS POR LINK DO SERVIDOR (1.1.4): o Config.Wallpapers aceita também URLs https (Discord, Imgur…) ou { url, name }.
     Entram na mesma lista que os ficheiros (id 'file:<url>'), nos dois sistemas, com o nome dado ou tirado do ficheiro. */
  const remoteNames = {};
  const isRemote = f => /^https?:\/\//i.test(String(f || ''));
  const fileName = f => {
    if (isRemote(f)) { if (remoteNames[f]) return remoteNames[f]; try { const p = new URL(f).pathname.split('/').pop() || ''; const k = decodeURIComponent(p).replace(/\.[a-z0-9]+$/i, '').replace(/[_-]+/g, ' ').trim(); return k ? k.replace(/\b\w/g, c => c.toUpperCase()).slice(0, 24) : 'Servidor'; } catch (e) { return 'Servidor'; } }
    const k = f.replace(/\.[a-z]+$/i, ''); return NAMES[k] || k.replace(/[_-]+/g, ' ').replace(/\b\w/g, c => c.toUpperCase()); };
  /* aspas simples e nunca uma aspa dentro do valor (entra em style="…") */
  const fileCss = f => isRemote(f) ? `url('${String(f).replace(/'/g, '%27')}')` : `url('img/wallpapers/${f}')`;
  const setOfFile = f => { const s = FILE_SET[String(f || '').replace(/\.[a-z]+$/i, '')]; return s ? (SETS.find(x => x.id === s) || S26_SETS.find(x => x.id === s)) : null; };
  /* ---- "COR DO APARELHO" (id 'auto', o fundo por omissão) ----
     A moldura vem do ITEM com que o telemóvel abriu (client/main.lua → 'open'/'frame' → System.setFrame → Wallpapers.frame).
     Cada cor tem o seu ficheiro; as molduras antigas caem na mais parecida (o mesmo mapa de Config.FrameProps). */
  const FRAME_FILE = { black: 'black.jpg', white: 'white.jpg', silver: 'white.jpg', blue: 'blue.jpg', wine: 'wine.jpg', orange: 'wine.jpg',
    'fold-night': 'blue.jpg', 'fold-star': 'white.jpg' };   /* PearPhone Fold (2026-10-01): azul-noite e branco-estrela */
  /* Android: a moldura do S26 escolhe o seu ficheiro; uma moldura do PearPhone (o sistema pode chegar antes da
     moldura) cai na cor do S26 mais parecida */
  const FRAME_FILE_AND = { 's26-black': 's26-black.jpg', 's26-white': 's26-white.jpg', 's26-violet': 's26-violet.jpg', 's26-sky': 's26-sky.jpg',
    black: 's26-black.jpg', white: 's26-white.jpg', silver: 's26-white.jpg', blue: 's26-sky.jpg', wine: 's26-violet.jpg', orange: 's26-violet.jpg' };
  /* PearOS com uma moldura do S26 (só de passagem, na troca de item): a cor do PearPhone mais parecida */
  const FRAME_FILE_IOS_S26 = { 's26-black': 'black.jpg', 's26-white': 'white.jpg', 's26-violet': 'wine.jpg', 's26-sky': 'blue.jpg' };
  let frame = 'black';
  /* NOVA Flip aberto (moldura flip-*, só no Android): a "Cor do aparelho" é o cetim desenhado da cor do Flip, e os quatro
     entram na lista. Noutro aparelho um flip-* gravado vale a cor do aparelho (fica gravado para quando se voltar ao Flip). */
  const flipSet = id => FLIP_SETS.find(x => x.id === id);
  const onFlip = () => isAnd() && !!flipSet(frame);
  /* nomes de cor (Vera, contas antigas) que com um Flip aberto apontam para o cetim dele */
  const FLIP_ALIAS = { lavender: 'flip-lavender', sage: 'flip-pistachio', gold: 'flip-cream', silver: 'flip-grey' };
  const flipOf = id => onFlip() ? (flipSet(id) || flipSet(FLIP_ALIAS[id])) : null;
  function deviceFile() {
    if (isAnd()) { if (onFlip()) return null; const l = andFiles(), f = FRAME_FILE_AND[frame]; if (f && l.includes(f)) return f; const s = l.find(x => AND_FILE.test(x)); return s || (l.length ? l[0] : null); }
    const l = iosFiles(), f = FRAME_FILE[frame] || FRAME_FILE_IOS_S26[frame]; if (f && l.includes(f)) return f; return l.length ? l[0] : null;
  }
  function deviceSet() {
    if (isAnd()) { if (onFlip()) return flipSet(frame); const f = deviceFile(); return (f && setOfFile(f)) || S26_SETS.find(x => x.id === frame) || setOfFile(FRAME_FILE_AND[frame]) || S26_SETS[0]; }
    return setOfFile(FRAME_FILE[frame] || FRAME_FILE_IOS_S26[frame]) || SETS.find(x => x.id === frame) || SETS[0];
  }
  const AUTO = 'auto';
  const isAuto = id => !id || id === AUTO;
  /* pedido do utilizador: com ficheiros oficiais presentes a lista mostra SÓ esses; os anéis desenhados ficam como recurso quando não há ficheiros.
     O primeiro é sempre "Cor do aparelho" (segue o item usado). Cada sistema vê os seus; com um Flip vêm a seguir os quatro cetins dele. */
  function list() {
    const auto = { id: AUTO, name: 'Cor do aparelho', css: css(AUTO), auto: true, dark: !!(get(AUTO) || {}).dark };
    const fl = osFiles(), flips = onFlip() ? FLIP_SETS.map(s => ({ id: s.id, name: s.name, css: dataUri(s), dark: s.dark })) : [];
    if (fl.length) return [auto].concat(flips, fl.map(f => ({ id: 'file:' + f, name: fileName(f), css: fileCss(f), file: true, dark: (setOfFile(f) || { dark: true }).dark })));
    return [auto].concat(flips, (isAnd() ? S26_SETS : SETS).map(s => ({ id: s.id, name: s.name, css: dataUri(s), dark: s.dark })));
  }
  /* ids antigos ('orange', 'blue', …) → ficheiro oficial correspondente, ou o do APARELHO quando não há correspondência
     (as contas antigas gravaram 'orange'/'file:cosmic-orange.jpg' como omissão: passam a seguir a cor do item; os ficheiros
     cosmic-orange/silver/deep-blue já não existem, por isso 'orange' não tem entrada aqui de propósito) */
  const OFFICIAL = { black: 'black.jpg', white: 'white.jpg', silver: 'white.jpg', blue: 'blue.jpg', wine: 'wine.jpg' };
  /* o mesmo no Android (também serve os nomes de cor da Vera: preto, branco, prata, azul, céu, violeta, lavanda) */
  const OFFICIAL_AND = { black: 's26-black.jpg', white: 's26-white.jpg', silver: 's26-white.jpg', blue: 's26-sky.jpg', sky: 's26-sky.jpg', mist: 's26-sky.jpg', lavender: 's26-violet.jpg',
    's26-black': 's26-black.jpg', 's26-white': 's26-white.jpg', 's26-violet': 's26-violet.jpg', 's26-sky': 's26-sky.jpg' };
  const isS26Id = id => S26_SETS.some(x => x.id === id);
  const fileFor = id => { const f = (isAnd() ? OFFICIAL_AND : OFFICIAL)[id]; if (f && osFiles().includes(f)) return f; return deviceFile(); };
  /* um ficheiro do OUTRO sistema (fundo escolhido no PearPhone e agora aberto no S26, ou o contrário) não rebenta nem
     aparece: mostra a cor do aparelho, e a escolha fica gravada para quando se voltar ao outro telemóvel */
  const fileOk = f => osFiles().includes(f) ? f : (deviceFile() || f);
  function css(id) { if (isAuto(id)) { const f = deviceFile(); return f ? fileCss(f) : dataUri(deviceSet()); } id = String(id); if (LEGACY[id]) id = LEGACY[id];
    { const fx = flipOf(id); if (fx) return dataUri(fx); if (flipSet(id)) return css(AUTO); }   /* cetim do Flip: só com um Flip aberto */
    if (id.startsWith('file:')) { const f = fileOk(id.slice(5)); return osFiles().includes(f) ? fileCss(f) : dataUri(deviceSet()); }
    const f = fileFor(id); if (f) return fileCss(f);
    if (isAnd()) return dataUri(S26_SETS.find(x => x.id === id) || deviceSet());
    const s = SETS.find(x => x.id === id); return dataUri(s || (isS26Id(id) ? deviceSet() : SETS[0])); }
  function get(id) { if (isAuto(id)) return deviceSet(); id = String(id); if (LEGACY[id]) id = LEGACY[id];
    { const fx = flipOf(id); if (fx) return fx; if (flipSet(id)) return deviceSet(); }
    if (id.startsWith('file:')) { const f = fileOk(id.slice(5)); return setOfFile(f) || (osFiles().includes(f) ? { id, name: fileName(f), dark: true } : deviceSet()); }
    if (isAnd()) { const f = OFFICIAL_AND[id]; return S26_SETS.find(x => x.id === id) || (f && osFiles().includes(f) && setOfFile(f)) || deviceSet(); }
    return SETS.find(x => x.id === id) || (isS26Id(id) ? deviceSet() : SETS[0]); }
  /* id "resolvido" para a UI marcar o selecionado: 'auto' fica 'auto'; um ficheiro/colorway que já não existe (ou que é do
     outro sistema) passa a 'auto' (segue o aparelho) */
  function resolve(id) { if (isAuto(id)) return AUTO; id = String(id); if (LEGACY[id]) id = LEGACY[id]; const fl = osFiles();
    { const fx = flipOf(id); if (fx) return fx.id; if (flipSet(id)) return AUTO; }
    if (id.startsWith('file:')) return fl.includes(id.slice(5)) ? id : AUTO;
    const f = (isAnd() ? OFFICIAL_AND : OFFICIAL)[id]; if (f && fl.includes(f)) return 'file:' + f;
    if (fl.length) return AUTO;
    if (isAnd()) { if (isS26Id(id)) return id; const m = OFFICIAL_AND[id]; const s = m && S26_SETS.find(x => x.id + '.jpg' === m); return s ? s.id : AUTO; }
    return isS26Id(id) ? AUTO : id; }
  /* cor representativa de um fundo (a cor "do corpo" da colorway: bordô no Bordô, azul no Azul-gelo…).
     O editor do ecrã principal começa "Cor" e "Gradiente" nela quando não consegue ler os píxeis da imagem (canvas sem CORS). */
  function tone(id) { const s = get(id); return (s && (s.mid || s.bg)) || '#3A3A3C'; }
  return { list, css, get, resolve, tone, AUTO, isAuto, S26: S26_SETS,
    /* as colorways do sistema aberto (a Vera lista os nomes): PearOS = as de sempre, Android = as do S26 (com um Flip, as dele primeiro) */
    get SETS() { return isAnd() ? (onFlip() ? FLIP_SETS.concat(S26_SETS) : S26_SETS) : SETS; }, FLIP: FLIP_SETS,
    /* devolve true quando a moldura mudou (quem chama volta a aplicar o fundo, que pode ser 'auto') */
    setFrame(f) { if (typeof f !== 'string' || !f || f === frame) return false; frame = f; return true; }, get frame() { return frame; },
    /* Config.Wallpapers: nomes de ficheiro, URLs https ou { url, name } (o Lua manda a tabela tal como está) */
    set files(v) { const arr = Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []); const out = [];
      for (const x of arr) { if (typeof x === 'string' && x) out.push(x); else if (x && typeof x === 'object' && typeof x.url === 'string' && isRemote(x.url)) { out.push(x.url); if (typeof x.name === 'string' && x.name) remoteNames[x.url] = x.name.slice(0, 40); } }
      files = out; }, get files() { return files; }, isRemote };
})();
