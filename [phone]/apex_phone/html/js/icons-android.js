/* ============================================================
   ICONES NOVA UI 8.5 (Android, "NOVA S26 Ultra") e NOMES ANDROID
   Icons.registerOS('android', {...}) desenha as apps do SISTEMA no estilo Nova UI 8.5 (revisao 2026-10-01, a partir
   dos icones de referencia do design system que o dono enviou): fundo de cor viva com gradiente quase vertical (mais
   claro em cima), glifo GRANDE e plano (branco, as vezes com uma segunda tonalidade a fazer de "lado" para dar volume),
   alguns icones em fundo claro prateado (Camara, Relogio, Calculadora) ou escuro (Definicoes), e um aro fino de luz
   a seguir a forma (claro em cima, escuro em baixo). A sombra que faz o icone "flutuar" e do CSS (oneui-home.css).
   Sem o vidro do PearOS (Icons.SVG(inner, true)). O desenho ocupa o quadrado 100x100 inteiro e a mascara squircle
   do CSS (o mesmo caminho SQ daqui) corta os cantos.
   As apps de terceiros (Instashot, Tweeter, Zapp, Match, Eats, Dark Chat, Onion, Cripto, Marketplace, jogos,
   Faturas, Servicos, Garagem) nao tem versao propria: ficam com o icone de sempre, como num telemovel a serio.
   Desenhos originais (nenhuma forma copiada de outra marca). Sem texto dentro dos icones: um SVG usado como
   imagem e um documento isolado e nao ve as fontes da pagina, por isso os numeros do Calendario sao tracos.
   ============================================================ */
(() => {
  'use strict';
  if (!window.Icons || !Icons.registerOS) return;
  const XMLNS = 'http://www.w3.org/2000/svg';

  /* ---------- DEFINICOES (gradientes e recortes) ----------
     Cada icone leva as suas definicoes DENTRO do SVG (quando vira imagem, via Icons.tileUrl, e um documento isolado).
     Quando o icone entra INLINE na pagina (o Relogio vivo sempre; os outros em notificacoes, recentes, etc.), o mesmo id
     repete se em varias copias e o Chromium usa a PRIMEIRA da pagina: se essa estiver numa camada escondida
     (display:none), o gradiente nao pinta e o icone sai vazio. Por isso as definicoes tambem vao UMA vez para um
     contentor visivel de 0x0 no inicio do <body> (o mesmo truque das definicoes do vidro no icons.js): e sempre esse o
     primeiro da pagina. Ids com o prefixo "nv" (nao colidem com os do PearOS). */
  const defsStore = new Map();
  let box = null;
  function paintBox() { if (box && box.isConnected) box.innerHTML = `<svg width="0" height="0" xmlns="${XMLNS}" focusable="false"><defs>${[...defsStore.values()].join('')}</defs></svg>`; }
  function globalDefs(key, defs) {
    const fresh = !defsStore.has(key);
    if (fresh) defsStore.set(key, defs);
    const b = typeof document !== 'undefined' && document.body; if (!b) return;
    if (!box || !box.isConnected) {
      box = document.getElementById('novaIconDefs');
      if (!box) { box = document.createElement('div'); box.id = 'novaIconDefs'; box.setAttribute('aria-hidden', 'true'); box.style.cssText = 'position:absolute;width:0;height:0;overflow:hidden;pointer-events:none'; }
      b.insertBefore(box, b.firstChild); paintBox(); return;
    }
    if (fresh) paintBox();
  }

  /* forma do icone Nova UI 8.5: superelipse (expoente ~2,9), mais redonda do que um quadrado de cantos arredondados.
     ⚠️ E o MESMO caminho da mascara em oneui-home.css (body.os-android .tile.img / .tile > svg): mudar os dois juntos. */
  const SQ = 'M50 0C88 0 100 12 100 50S88 100 50 100 0 88 0 50 12 0 50 0Z';
  /* comuns a todos: luz no topo, sombra tenue em baixo, o branco dos glifos e o aro (luz em cima, aresta escura em baixo) */
  /* Nova UI 8.5 (mais profundidade e cor): luz radial no canto de cima a esquerda (nvLite), uma faixa de brilho especular no terco de
     cima (nvGloss), uma vinheta suave nas arestas (nvVig: o centro fica mais claro e saturado, as bordas mais fundas) e a sombra de
     baixo (nvShade). Tudo gradientes estaticos dentro do proprio SVG: zero filtros, zero custo no CEF */
  const SHARED = '<radialGradient id="nvLite" gradientUnits="userSpaceOnUse" cx="28" cy="-4" r="86"><stop offset="0" stop-color="#fff" stop-opacity=".26"/><stop offset=".55" stop-color="#fff" stop-opacity=".06"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient>'
    + '<linearGradient id="nvGloss" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="0" y2="52"><stop offset="0" stop-color="#fff" stop-opacity=".2"/><stop offset=".55" stop-color="#fff" stop-opacity=".06"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient>'
    + '<radialGradient id="nvVig" gradientUnits="userSpaceOnUse" cx="50" cy="46" r="62"><stop offset="0" stop-color="#000" stop-opacity="0"/><stop offset=".72" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".16"/></radialGradient>'
    + '<linearGradient id="nvShade" gradientUnits="userSpaceOnUse" x1="0" y1="55" x2="0" y2="100"><stop offset="0" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".1"/></linearGradient>'
    + '<linearGradient id="nvW" gradientUnits="userSpaceOnUse" x1="0" y1="16" x2="0" y2="86"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#EEF0F6"/></linearGradient>'
    + `<clipPath id="nvSq"><path d="${SQ}"/></clipPath>`
    + '<linearGradient id="nvRim" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="0" y2="100"><stop offset="0" stop-color="#fff" stop-opacity=".62"/><stop offset=".18" stop-color="#fff" stop-opacity=".16"/><stop offset=".5" stop-color="#fff" stop-opacity="0"/><stop offset=".82" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".2"/></linearGradient>';
  /* aro: traco no contorno da forma; o recorte (nvSq) corta a metade de fora, fica ~1 px por dentro */
  const RIM = `<path d="${SQ}" fill="none" stroke="url(#nvRim)" stroke-width="3.2"/>`;
  /* gradiente do fundo em userSpaceOnUse: os "recortes" (detalhes pintados com a cor do fundo) ficam alinhados com ele.
     Por omissao quase vertical (a referencia: claro em cima, mais fundo em baixo, com um ligeiro desvio na diagonal) */
  const grad = (id, a, b, c, x1 = 38, y1 = 0, x2 = 62, y2 = 100) => `<linearGradient id="${id}" gradientUnits="userSpaceOnUse" x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}"><stop offset="0" stop-color="${a}"/>${c ? `<stop offset=".55" stop-color="${b}"/><stop offset="1" stop-color="${c}"/>` : `<stop offset="1" stop-color="${b}"/>`}</linearGradient>`;
  const FULL = f => `<rect width="100" height="100" fill="${f}"/>`;
  const BG = id => FULL(`url(#${id})`) + FULL('url(#nvLite)') + FULL('url(#nvGloss)') + FULL('url(#nvVig)') + FULL('url(#nvShade)');
  /* sombra do glifo: duas copias escuras e curtas (sem filtros: barato no CEF e nitido em qualquer tamanho). Nos icones claros
     (glifo branco em fundo prateado) mais forte; nos de cor (8.5) uma sombra leve que descola o glifo do fundo */
  const SH = (g, c = '#000', k = 1) => `<g opacity="${(.1 * k).toFixed(3)}" transform="translate(0 1.2)">${g(c)}</g><g opacity="${(.09 * k).toFixed(3)}" transform="translate(0 2.8)">${g(c)}</g>`;
  /* glifo branco com volume: sombra leve por baixo + a propria forma em branco */
  const GW = (g, k = .9) => SH(g, '#000', k) + g(W);
  /* monta o icone: definicoes (no SVG e no contentor global) + desenho + aro, tudo recortado na forma squircle: assim o icone ja
     sai com a forma certa mesmo onde o CSS nao lhe poe a mascara (listas, notificacoes) e o aro nunca aparece fora dela */
  const make = (key, defs, body) => { const d = SHARED + defs; globalDefs('shared', SHARED); globalDefs(key, defs); return Icons.SVG(`<defs>${d}</defs><g clip-path="url(#nvSq)">${body}${RIM}</g>`, true); };
  const W = 'url(#nvW)';

  /* ---------- NUMEROS EM TRACO (Calendario) ----------
     Caixa de 10x17 por algarismo, traco redondo: geometricos como a Outfit, iguais em qualquer maquina. */
  const DIG = {
    0: 'M5 .8C7.6 .8 9.4 4.2 9.4 8.5S7.6 16.2 5 16.2 .6 12.8 .6 8.5 2.4 .8 5 .8Z',
    1: 'M2 3.8 6 .8V16.2',
    2: 'M1.1 4.6C1.5 2.3 3.1 .8 5.2 .8 7.6 .8 9.1 2.5 9.1 4.7 9.1 6.6 8 8 6.3 9.8L1 16.2H9.4',
    3: 'M1.3 .8H8.9L4.6 6.7C7.5 6.5 9.6 8.6 9.6 11.4 9.6 14.2 7.4 16.2 4.9 16.2 3 16.2 1.5 15.3.8 13.7',
    4: 'M7.2 16.2V.8L.8 11.3H9.7',
    5: 'M8.9 .8H2.6L1.8 7.7C2.8 6.9 4 6.5 5.2 6.5 7.8 6.5 9.6 8.5 9.6 11.3 9.6 14.1 7.6 16.2 4.9 16.2 3 16.2 1.5 15.3.8 13.7',
    6: 'M7.6 .8 2.5 8.4M5.2 7.4A4.4 4.4 0 1 1 5.2 16.2 4.4 4.4 0 1 1 5.2 7.4Z',
    7: 'M.8 .8H9.5L4 16.2',
    8: 'M5.2 .8A3.8 3.8 0 1 1 5.2 8.4 3.8 3.8 0 1 1 5.2 .8ZM5.2 8.4A3.9 3.9 0 1 1 5.2 16.2 3.9 3.9 0 1 1 5.2 8.4Z',
    9: 'M2.8 16.2 7.9 8.6M5.2 1A4.4 4.4 0 1 1 5.2 9.8 4.4 4.4 0 1 1 5.2 1Z',
  };
  /* extremos horizontais de cada algarismo (para centrar pelo desenho e nao pela caixa: o "1" e estreito) */
  const DIGX = { 0: [.6, 9.4], 1: [2, 6], 2: [1, 9.4], 3: [.8, 9.6], 4: [.8, 9.7], 5: [.8, 9.6], 6: [.8, 9.6], 7: [.8, 9.5], 8: [1.3, 9.1], 9: [.8, 9.6] };
  /* numero centrado em (cx, top), altura h, traco sw (unidades do icone) */
  function digits(n, cx, top, h, sw, color) {
    const s = [...String(n)].filter(d => DIG[d]), k = h / 15.4, gap = 3.2;
    if (!s.length) return '';
    /* espacamento proporcional: cada algarismo encosta ao anterior com o mesmo intervalo (o "11" nao fica aberto) */
    const xs = []; let pos = 0;
    s.forEach((d, i) => { if (i) pos += DIGX[s[i - 1]][1] + gap - DIGX[d][0]; xs.push(pos); });
    const lo = DIGX[s[0]][0], hi = xs[xs.length - 1] + DIGX[s[s.length - 1]][1];
    const x0 = cx - ((lo + hi) / 2) * k, y0 = top - .8 * k;
    return `<g fill="none" stroke="${color}" stroke-width="${(sw / k).toFixed(3)}" stroke-linecap="round" stroke-linejoin="round" transform="translate(${x0.toFixed(2)} ${y0.toFixed(2)}) scale(${k.toFixed(4)})">`
      + s.map((d, i) => `<path transform="translate(${xs[i].toFixed(2)} 0)" d="${DIG[d]}"/>`).join('') + '</g>';
  }
  /* estrela de 4 pontas (centro, raio, cintura) */
  const star = (cx, cy, r, k = .2) => { const q = r * k; return `M${cx} ${cy - r}Q${cx + q} ${cy - q} ${cx + r} ${cy}Q${cx + q} ${cy + q} ${cx} ${cy + r}Q${cx - q} ${cy + q} ${cx - r} ${cy}Q${cx - q} ${cy - q} ${cx} ${cy - r}Z`; };
  const ang = (cx, cy, r, deg) => { const a = (deg - 90) * Math.PI / 180; return [+(cx + r * Math.cos(a)).toFixed(2), +(cy + r * Math.sin(a)).toFixed(2)]; };
  /* claros prateados (Camara, Relogio, Calculadora): o mesmo fundo nos tres */
  const SILVER = id => grad(id, '#F4F5F8', '#C4C7D0');

  /* ---------- OS ICONES ---------- */
  const map = {
    /* Telefone: auscultador de pe (um "C" aberto para a direita) com o lado em verde claro a dar espessura */
    phone: () => {
      const g = c => `<g fill="${c}"><path d="M55.5 25.5C44.5 28 37.5 38 37.5 50S44.5 72 55.5 74.5" fill="none" stroke="${c}" stroke-width="13.4" stroke-linecap="round"/><rect x="46" y="15" width="19" height="19" rx="8" transform="rotate(-12 55.5 24.5)"/><rect x="46" y="66" width="19" height="19" rx="8" transform="rotate(12 55.5 75.5)"/></g>`;
      return make('phone', grad('nvPhB', '#2FEA6C', '#0DA748'), BG('nvPhB') + `<g transform="translate(50.5 50) scale(.88) translate(-50.5 -50)"><g opacity=".62" transform="translate(4.6 .4)">${g('#fff')}</g>${g(W)}</g>`);
    },
    /* Mensagens: balao largo e redondo com tres pontos e a cauda (em azul muito claro) em baixo a esquerda */
    messages: () => {
      const bub = c => `<path fill="${c}" d="M51 21C74.5 21 83 29.5 83 46.5S74.5 72 51 72 19 63.5 19 46.5 27.5 21 51 21Z"/>`;
      return make('messages', grad('nvMsB', '#2DB5FF', '#1A6BFF'), BG('nvMsB')
        + '<path d="M30.5 65 24.5 80C31.5 79 38 76 42.5 71.5Z" fill="#fff" fill-opacity=".72"/>'
        + GW(bub)
        + [36.5, 51, 65.5].map(x => `<circle cx="${x}" cy="46.5" r="4.9" fill="url(#nvMsB)"/>`).join(''));
    },
    /* Contactos: disco vermelho mais escuro com a pessoa (cabeca e ombros) em branco */
    contacts: () => {
      const person = c => `<g fill="${c}"><circle cx="50" cy="39.5" r="10.2"/><path d="M32 66C32 57.5 40.2 52.5 50 52.5S68 57.5 68 66V67A4 4 0 0 1 64 71H36A4 4 0 0 1 32 67Z"/></g>`;
      return make('contacts', grad('nvCoB', '#FF6A64', '#E52F3A') + grad('nvCoD', '#D2242F', '#B41824', null, 50, 15, 50, 85),
        BG('nvCoB') + '<circle cx="50" cy="50" r="35" fill="url(#nvCoD)"/><circle cx="50" cy="50" r="35" fill="none" stroke="#fff" stroke-opacity=".14" stroke-width="1.2"/>' + GW(person));
    },
    /* Camara: corpo branco em fundo prateado, objetiva grande e escura com um reflexo violeta, ponto vermelho do flash */
    camera: () => {
      const body = c => `<rect x="14" y="25" width="72" height="51" rx="12.5" fill="${c}"/>`;
      return make('camera', SILVER('nvCmB') + '<linearGradient id="nvCmW" gradientUnits="userSpaceOnUse" x1="0" y1="25" x2="0" y2="76"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#EBEDF2"/></linearGradient>'
        + '<radialGradient id="nvCmL" gradientUnits="userSpaceOnUse" cx="46.5" cy="46" r="14"><stop offset="0" stop-color="#3F4377"/><stop offset=".6" stop-color="#1D1F35"/><stop offset="1" stop-color="#0D0E17"/></radialGradient>',
        BG('nvCmB') + SH(body, '#3A4052', 1.5) + body('url(#nvCmW)')
        + '<circle cx="50" cy="50.5" r="18.5" fill="#121318"/><circle cx="50" cy="50.5" r="12" fill="url(#nvCmL)"/>'
        + '<path d="M41.6 46.4A9.2 9.2 0 0 1 48.6 41.4" fill="none" stroke="#9A86FF" stroke-width="2.2" stroke-linecap="round"/>'
        + '<circle cx="50" cy="50.5" r="5" fill="#05060A"/><circle cx="46.3" cy="46.6" r="1.7" fill="#fff" fill-opacity=".85"/><circle cx="25.5" cy="34.5" r="3.4" fill="#FF3B30"/>');
    },
    /* Galeria: flor de seis petalas redondas, branco e rosa alternados, com o miolo laranja */
    photos: () => {
      const cols = ['#fff', '#FFB8D3', '#FFF0F5', '#FFC2DA', '#fff', '#FFB8D3'];
      const petals = f => [0, 60, 120, 180, 240, 300].map((a, i) => `<ellipse cx="50" cy="31.5" rx="11.2" ry="14.8" fill="${f || cols[i]}" transform="rotate(${a} 50 50)"/>`).join('');
      return make('photos', grad('nvPoB', '#E9338F', '#FF3F5C', '#FF6A2E', 6, 0, 94, 100),
        BG('nvPoB') + SH(c => petals(c), '#000', .9) + petals() + '<circle cx="50" cy="50" r="9" fill="#FF5A1E"/><circle cx="48" cy="48" r="3.2" fill="#FF8A4A"/>');
    },
    /* Definicoes: roda dentada branca em fundo grafite, anel cinzento e o miolo com os quatro raios */
    settings: () => {
      let teeth = ''; for (let i = 0; i < 12; i++) teeth += `<rect x="45" y="12.5" width="10" height="13" rx="2.6" transform="rotate(${i * 30} 50 50)"/>`;
      const gear = c => `<g fill="${c}">${teeth}<circle cx="50" cy="50" r="31"/></g>`;
      return make('settings', grad('nvSeB', '#4F5162', '#2A2B36') + '<clipPath id="nvSeC"><circle cx="50" cy="50" r="14.6"/></clipPath>',
        BG('nvSeB') + GW(gear, 1.4)
        + '<circle cx="50" cy="50" r="21.5" fill="#BDBEC7"/><circle cx="50" cy="50" r="14.6" fill="#383A47"/>'
        + '<g clip-path="url(#nvSeC)" fill="#BDBEC7"><rect x="46.8" y="30" width="6.4" height="40" transform="rotate(45 50 50)"/><rect x="46.8" y="30" width="6.4" height="40" transform="rotate(-45 50 50)"/></g>'
        + '<circle cx="50" cy="50" r="5.4" fill="#BDBEC7"/><circle cx="50" cy="50" r="2.4" fill="#383A47"/>');
    },
    /* Relogio: mostrador branco grande em fundo prateado; ponteiros VIVOS (classes hh/mh, rodados pelo Icons.tickClocks):
       o das horas violeta, o dos minutos preto; sem ponteiro dos segundos */
    clock: () => {
      const d = new Date(), h = (d.getHours() % 12) * 30 + d.getMinutes() * .5, m = d.getMinutes() * 6 + d.getSeconds() * .1;
      const face = c => `<circle cx="50" cy="50" r="37" fill="${c}"/>`;
      return make('clock', SILVER('nvCkB') + '<linearGradient id="nvCkF" gradientUnits="userSpaceOnUse" x1="0" y1="13" x2="0" y2="87"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#F2F3F7"/></linearGradient>',
        BG('nvCkB') + SH(face, '#3A4052', 1.6) + face('url(#nvCkF)')
        + `<g class="hh" transform="rotate(${h} 50 50)"><line x1="50" y1="50" x2="50" y2="31" stroke="#8D5CF6" stroke-width="5.2" stroke-linecap="round"/></g>`
        + `<g class="mh" transform="rotate(${m} 50 50)"><line x1="50" y1="50" x2="50" y2="21.5" stroke="#15161B" stroke-width="5.2" stroke-linecap="round"/></g>`
        + '<circle cx="50" cy="50" r="5" fill="#15161B"/><circle cx="50" cy="50" r="2.2" fill="#fff"/>');
    },
    /* Calculadora: duas teclas redondas escuras ("+" e "-") e a tecla "=" em capsula verde, em fundo prateado */
    calculator: () => {
      const keys = c => `<g fill="${c}"><circle cx="33.5" cy="33" r="14.8"/><circle cx="33.5" cy="67" r="14.8"/><rect x="54" y="18" width="29" height="64" rx="14.5"/></g>`;
      return make('calculator', SILVER('nvClB') + grad('nvClG', '#3AD86A', '#16A447', null, 50, 18, 50, 82),
        BG('nvClB') + SH(keys, '#3A4052', 1.5) + '<g fill="#2A2B33"><circle cx="33.5" cy="33" r="14.8"/><circle cx="33.5" cy="67" r="14.8"/></g>'
        + '<rect x="54" y="18" width="29" height="64" rx="14.5" fill="url(#nvClG)"/>'
        + '<g fill="none" stroke="#fff" stroke-width="4.2" stroke-linecap="round"><path d="M33.5 26.3V39.7M26.8 33H40.2M26.8 67H40.2M62.5 45.3H74.5M62.5 54.7H74.5"/></g>');
    },
    /* Calendario: folha clara com a faixa azul e o DIA DO MES vivo (numeros em traco) */
    calendar: () => {
      const day = new Date().getDate();
      const band = '<path d="M0 0H100V32H0Z" fill="url(#nvCaT)"/><g fill="#fff" fill-opacity=".92"><rect x="29" y="9.5" width="6.5" height="13" rx="3.25"/><rect x="64.5" y="9.5" width="6.5" height="13" rx="3.25"/></g>';
      return make('calendar', grad('nvCaB', '#FFFFFF', '#E3E6EE', null, 50, 0, 50, 100) + grad('nvCaT', '#4F8DFF', '#2A5FF2', null, 50, 0, 50, 32),
        BG('nvCaB') + band + '<rect y="32" width="100" height="2.2" fill="#000" fill-opacity=".05"/>' + digits(day, 50, 45, 32, 5.6, '#1C2240'));
    },
    /* Notas: bloco branco com as argolas a esquerda e o canto de baixo dobrado (rosado), em fundo vermelho alaranjado */
    notes: () => {
      const sheet = c => `<path fill="${c}" d="M36 19H67A7 7 0 0 1 74 26V63.5L57.5 80H36A7 7 0 0 1 29 73V26A7 7 0 0 1 36 19Z"/>`;
      return make('notes', grad('nvNtB', '#FF7B48', '#EA3826'),
        BG('nvNtB') + GW(sheet)
        + '<path d="M74 63.5 57.5 80V69.5A6 6 0 0 1 63.5 63.5Z" fill="#FFB3A4"/>'
        + `<g fill="url(#nvNtB)">${[30, 40.5, 51, 61.5].map(y => `<circle cx="29" cy="${y}" r="3.5"/>`).join('')}</g>`);
    },
    /* Lembretes: disco violeta escuro com o visto em duas tonalidades (lilas e branco) */
    reminders: () => {
      const tick = c => `<path d="M35.5 51 46 61.5 66.5 39.5" fill="none" stroke="${c}" stroke-width="8.6" stroke-linecap="round" stroke-linejoin="round"/>`;
      return make('reminders', grad('nvReB', '#985DFF', '#5E30EA') + grad('nvReD', '#3E1DA6', '#2E1288', null, 50, 16, 50, 84),
        BG('nvReB') + '<circle cx="50" cy="50" r="34.5" fill="url(#nvReD)"/><circle cx="50" cy="50" r="34.5" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="1.2"/>'
        + SH(tick, '#000', .9) + '<path d="M35.5 51 46 61.5" fill="none" stroke="#C7B4FF" stroke-width="8.6" stroke-linecap="round"/><path d="M46 61.5 66.5 39.5" fill="none" stroke="#fff" stroke-width="8.6" stroke-linecap="round"/>');
    },
    /* Meteorologia: sol com raios curtos em cima a direita, uma nuvem azul clara atras e a nuvem branca grande a frente */
    weather: () => {
      let rays = ''; for (let i = 0; i < 8; i++) { const [x1, y1] = ang(65, 34, 15.5, i * 45), [x2, y2] = ang(65, 34, 20, i * 45); rays += `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}"/>`; }
      return make('weather', grad('nvWeB', '#45D2FF', '#1597F0') + '<radialGradient id="nvWeS" gradientUnits="userSpaceOnUse" cx="62" cy="31" r="13"><stop offset="0" stop-color="#FFEA7A"/><stop offset="1" stop-color="#FFC21C"/></radialGradient>',
        BG('nvWeB') + `<g stroke="#FFDD55" stroke-width="3.4" stroke-linecap="round">${rays}</g><circle cx="65" cy="34" r="11.5" fill="url(#nvWeS)"/>`
        + '<g fill="#A6DDFF"><circle cx="67" cy="58.5" r="11.5"/><rect x="54" y="57" width="28" height="15" rx="7.5"/></g>'
        + GW(c => `<g fill="${c}"><circle cx="46" cy="50.5" r="16.5"/><circle cx="29.5" cy="59" r="11.5"/><rect x="18" y="52" width="49" height="20" rx="10"/></g>`));
    },
    /* Email: envelope branco fechado com a aba em "V" recortada, em fundo ambar */
    mail: () => make('mail', grad('nvMaB', '#FFB02E', '#F2731C'),
      BG('nvMaB') + GW(c => `<rect x="17" y="27" width="66" height="47" rx="9.5" fill="${c}"/>`)
      + '<path d="M22 33.5 46.2 51.6C48.4 53.3 51.6 53.3 53.8 51.6L78 33.5" fill="none" stroke="url(#nvMaB)" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>'),
    /* Internet: planeta branco com o anel azul claro inclinado (passa por tras e pela frente) */
    safari: () => {
      const orbit = 'cx="50" cy="50" rx="39" ry="12" transform="rotate(-36 50 50)"';
      return make('safari', grad('nvSfB', '#8165FF', '#4A2DE2') + '<radialGradient id="nvSfP" gradientUnits="userSpaceOnUse" cx="44" cy="41" r="30"><stop offset="0" stop-color="#fff"/><stop offset=".6" stop-color="#F5F3FF"/><stop offset="1" stop-color="#DCD5FF"/></radialGradient>'
        + '<clipPath id="nvSfC"><rect x="-10" y="50" width="120" height="60" transform="rotate(-36 50 50)"/></clipPath>',
        BG('nvSfB') + `<ellipse ${orbit} fill="none" stroke="#86CFFF" stroke-width="5"/>` + SH(c => `<circle cx="50" cy="50" r="23" fill="${c}"/>`, '#000', 1) + '<circle cx="50" cy="50" r="23" fill="url(#nvSfP)"/>'
        + `<g clip-path="url(#nvSfC)"><ellipse ${orbit} fill="none" stroke="url(#nvSfB)" stroke-width="9.4"/><ellipse ${orbit} fill="none" stroke="#86CFFF" stroke-width="5"/></g>`);
    },
    /* Musica: colcheia grande com a bandeira curva */
    music: () => {
      const g = c => `<g fill="${c}"><ellipse cx="39.5" cy="68" rx="12.6" ry="9.8" transform="rotate(-22 39.5 68)"/><rect x="45.6" y="21" width="6.8" height="48" rx="3.4"/><path d="M49 21.5C51.5 20.6 54 20.9 56 22.4 62.5 27.4 70.4 30.2 72.4 40.4 73.4 45.4 71.6 50.6 68.4 54 69.2 47.2 65.6 41.6 59 39.4 56.6 38.6 54 38.6 52.4 38.8Z"/></g>`;
      return make('music', grad('nvMuB', '#FF6B8E', '#E1245A'), BG('nvMuB') + GW(g));
    },
    /* Mapas: mapa dobrado em tres paineis, estrada e o alfinete */
    maps: () => {
      const pin = c => `<path fill="${c}" d="M55.5 20.5C64.9 20.5 71.5 27.6 71.5 36.4 71.5 47.4 59.4 57.6 57 59.5 56.1 60.2 54.9 60.2 54 59.5 51.6 57.6 39.5 47.4 39.5 36.4 39.5 27.6 46.1 20.5 55.5 20.5Z"/>`;
      return make('maps', grad('nvMpB', '#FBFDFC', '#DCE6E2', null, 50, 0, 50, 100) + grad('nvMpR', '#FF7A55', '#EE3B2E', null, 50, 20, 50, 60),
        BG('nvMpB')
        + '<g stroke-linejoin="round" stroke-width="2"><path d="M17 31 37 23.5V75L17 82.5Z" fill="#6FD496" stroke="#6FD496"/><path d="M37 23.5 63 31V82.5L37 75Z" fill="#A9DEF7" stroke="#A9DEF7"/><path d="M63 31 83 23.5V75L63 82.5Z" fill="#5CC686" stroke="#5CC686"/></g>'
        + '<path d="M17 66 37 58.5 63 66 83 53" fill="none" stroke="#fff" stroke-width="4.4" stroke-linejoin="round"/><path d="M17 66 37 58.5 63 66 83 53" fill="none" stroke="#FFD34E" stroke-width="1.6" stroke-linejoin="round" stroke-dasharray="3 3.4"/>'
        + SH(pin, '#3A0A00', 1.4) + pin('url(#nvMpR)') + '<circle cx="55.5" cy="36.4" r="6.2" fill="#fff"/>');
    },
    /* NOVA Store: saco de compras branco (pegas presas em dois pontos) com a estrela NOVA, em rosa a laranja */
    appstore: () => make('appstore', grad('nvAsB', '#FF3F86', '#FF6B3B', null, 20, 0, 80, 100),
      BG('nvAsB') + '<path d="M38.5 40V33.5C38.5 26.8 43.6 21.5 50 21.5S61.5 26.8 61.5 33.5V40" fill="none" stroke="#fff" stroke-width="5.4" stroke-linecap="round"/>'
      + GW(c => `<path fill="${c}" d="M26 35H74C76.3 35 78 37 77.8 39.2L75.6 72C75.2 77.6 70.6 82 65 82H35C29.4 82 24.8 77.6 24.4 72L22.2 39.2C22 37 23.7 35 26 35Z"/>`)
      + '<circle cx="38.5" cy="43" r="3.3" fill="url(#nvAsB)"/><circle cx="61.5" cy="43" r="3.3" fill="url(#nvAsB)"/>'
      + `<path d="${star(50, 62, 9.5, .17)}" fill="url(#nvAsB)"/>`),
    /* Carteira: cartao branco a frente (com a faixa verde a azul) e outro translucido atras, em azul a violeta */
    wallet: () => make('wallet', grad('nvWaB', '#4A7DFF', '#6436EF', null, 20, 0, 80, 100) + grad('nvWaS', '#2FD47D', '#2B86FF', null, 30, 34, 42, 72),
      BG('nvWaB') + '<rect x="22" y="22" width="60" height="40" rx="7.5" fill="#fff" fill-opacity=".34" transform="rotate(-9 52 42)"/>'
      + GW(c => `<rect x="17" y="32" width="66" height="44" rx="8" fill="${c}"/>`)
      + '<path d="M28 38.5H45.5L37 69.5H27A3 3 0 0 1 24 66.5V42.5A4 4 0 0 1 28 38.5Z" fill="url(#nvWaS)"/>'),
    /* Videochamada: camara de video com a pessoa recortada no corpo */
    facetime: () => make('facetime', grad('nvFtB', '#3EE3B4', '#0B9C7D'), BG('nvFtB')
      + GW(c => `<g fill="${c}"><rect x="14.5" y="29.5" width="49" height="41" rx="12.5"/><path d="M66.5 45 79.6 36.4C82 34.8 85 36.5 85 39.3V60.7C85 63.5 82 65.2 79.6 63.6L66.5 55Z"/></g>`)
      + '<g fill="url(#nvFtB)"><circle cx="39" cy="44.5" r="6.6"/><path d="M27 63.5C27 56.7 32.4 53 39 53S51 56.7 51 63.5Z"/></g>'),
    /* Encontrar: alfinete branco com o furo azul, pousado num anel azul claro */
    findmy: () => make('findmy', grad('nvFmB', '#2E9DFF', '#1C5DF0'),
      BG('nvFmB') + '<ellipse cx="50" cy="74" rx="18" ry="5.8" fill="#9DCBFF"/>'
      + GW(c => `<path fill="${c}" d="M50 18.5C62.2 18.5 71 27.6 71 39.5 71 52.6 58.3 64.6 53.4 70.6 51.6 72.8 48.4 72.8 46.6 70.6 41.7 64.6 29 52.6 29 39.5 29 27.6 37.8 18.5 50 18.5Z"/>`)
      + '<circle cx="50" cy="39.5" r="8.4" fill="url(#nvFmB)"/>'),
    /* Casa: casa com a porta recortada e o sinal da casa inteligente */
    home: () => make('home', grad('nvHoB', '#3FD3E0', '#0D86C2'), BG('nvHoB')
      + GW(c => `<path fill="${c}" d="M50 19.5C51.2 19.5 52.3 19.9 53.2 20.7L80.5 44.3C82.6 46.1 81.3 49.5 78.6 49.5H75V74A7 7 0 0 1 68 81H32A7 7 0 0 1 25 74V49.5H21.4C18.7 49.5 17.4 46.1 19.5 44.3L46.8 20.7C47.7 19.9 48.8 19.5 50 19.5Z"/>`)
      + '<path d="M43.5 81V69A6.5 6.5 0 0 1 56.5 69V81Z" fill="url(#nvHoB)"/><path d="M42.5 51A10.6 10.6 0 0 1 57.5 51" fill="none" stroke="url(#nvHoB)" stroke-width="3.2" stroke-linecap="round"/><circle cx="50" cy="56" r="2.4" fill="url(#nvHoB)"/>'),
    /* Vera Chat: balao translucido com a estrela grande da IA e uma pequena (gradiente ciano a verde das funcoes de IA) */
    aichat: () => make('aichat', grad('nvAiB', '#2EC4FF', '#22D6B2', '#7AE26C', 12, 0, 88, 100),
      BG('nvAiB') + '<path fill="#fff" fill-opacity=".26" d="M62 21.5H38A20.5 20.5 0 0 0 17.5 42V51.5A20.5 20.5 0 0 0 38 72H59L73.7 82.4C75.4 83.6 77.6 82.1 77.1 80.1L74.4 69.6C79 65.9 82.5 59.4 82.5 51.5V42A20.5 20.5 0 0 0 62 21.5Z"/>'
      + GW(c => `<path d="${star(46, 45, 20, .16)}" fill="${c}"/>`) + `<path d="${star(66.5, 60.5, 8.5, .18)}" fill="#fff" fill-opacity=".9"/>`),
  };
  Icons.registerOS('android', map);

  /* ---------- NOMES ANDROID (Nova UI, pt-PT) ----------
     So os nomes mudam: os ids, os dados e o servidor sao os mesmos nos dois sistemas. A Vera Chat fica com o nome do
     PearOS (vem do Config.AI). A loja segue System.osInfo().store (Config.Android.store; "NOVA Store" por omissao). */
  const NAMES = {
    phone: 'Telefone', messages: 'Mensagens', contacts: 'Contactos', camera: 'Câmara', photos: 'Galeria', settings: 'Definições',
    clock: 'Relógio', calculator: 'Calculadora', calendar: 'Calendário', notes: 'Notas', reminders: 'Lembretes', weather: 'Meteorologia',
    mail: 'Email', safari: 'Internet', music: 'Música', maps: 'Mapas', appstore: 'NOVA Store', wallet: 'Carteira', facetime: 'Videochamada',
    findmy: 'Encontrar', home: 'Casa', airdrop: 'Partilha rápida',
  };
  /* o nome da loja so se le com o sistema Android ativo (o osInfo() descreve o sistema atual) */
  function syncStore() {
    try {
      if (!window.App || !App.alias || !window.System || System.os !== 'android' || !System.osInfo) return;
      const st = String((System.osInfo() || {}).store || '').trim();
      if (st && (!App.ALIAS || !App.ALIAS.android || App.ALIAS.android.appstore !== st)) App.alias('android', { appstore: st });
    } catch (e) { console.error('[apex_phone] nome da loja (android)', e); }
  }
  /* o Calendario mostra o dia do mes: ao virar o dia o desenho em cache fica velho. Com o Android ativo, a primeira
     verificacao depois da meia noite deita fora esse icone e pede ao ecra principal para se redesenhar. */
  let lastDay = new Date().getDate();
  function dayTick() {
    const d = new Date().getDate(); if (d === lastDay) return; lastDay = d;
    try { if (window.System && System.os === 'android') { Icons.clearTiles('calendar'); if (window.Bridge && Bridge.emit) Bridge.emit('apps:changed'); } } catch (e) {}
  }
  function boot() {
    if (!window.App || !App.alias) return;
    App.alias('android', NAMES);
    syncStore();
    if (window.Bridge && Bridge.on) { Bridge.on('os:changed', syncStore); Bridge.on('ready', syncStore); }
    setInterval(dayTick, 60000);
  }
  /* o App (system.js) carrega DEPOIS deste ficheiro: os nomes registam-se quando a pagina acabar de ler os scripts */
  if (window.App && App.alias) boot(); else document.addEventListener('DOMContentLoaded', boot, { once: true });
})();
