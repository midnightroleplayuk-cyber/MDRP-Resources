/* ============================================================
   SYSUI (Android, Nova UI 8.5): moldura do NOVA S26 Ultra e do NOVA
   dobravel (fechado e aberto), barra de estado,
   barra de navegacao (3 botoes ou gestos) e o Voltar do sistema.
   So desenha com body.os-android: no PearOS o anel, a barra de estado e
   a ilha continuam a ser os do system.js, island.js e system.css.
   O modulo arranca SEMPRE (o sistema pode mudar a meio, ao trocar de
   item) e reage ao Bridge 'os:changed'.
   ============================================================ */
window.SysUI = (() => {
  const isA = () => !!(window.System && System.os === 'android');
  const T = s => (window.L && L.t ? L.t(s) : s);
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const scr = () => document.getElementById('screen');
  const safe = fn => { try { return fn(); } catch (e) { console.error('[apex_phone] sysui', e); return undefined; } };

  /* ---------- Icones do sistema Nova UI ----------
     Desenhados aqui (e nao no icons.js) porque sao do SISTEMA: barra de estado, navegacao, chips, volume e menu de
     energia. Tracos arredondados de 1,9 e cheios onde a Nova UI os usa cheios (telefone, reproduzir, aviao). O
     island.js e o hardware.js usam-nos por SysUI.icon (chamado em tempo de execucao: este ficheiro carrega depois). */
  const IC = {
    back: { d: '<path d="M14.6 5.4 8 12l6.6 6.6"/>' },
    kbdown: { d: '<path d="M5.8 9.4 12 15.6l6.2-6.2"/>' },
    home: { d: '<rect x="5.6" y="5.6" width="12.8" height="12.8" rx="3.9"/>' },
    recents: { d: '<path d="M7.2 6.6v10.8M12 6.6v10.8M16.8 6.6v10.8"/>' },
    phone: { f: 1, d: '<path d="M6.6 10.8a15.1 15.1 0 0 0 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1A17 17 0 0 1 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1z"/>' },
    phoneDown: { f: 1, d: '<path d="M12 9c-1.6 0-3.2.3-4.6.7v3.1c0 .4-.2.7-.6.9-1 .5-1.9 1.1-2.7 1.9-.2.2-.4.3-.7.3s-.5-.1-.7-.3L.3 13.1a1 1 0 0 1 0-1.4A16.6 16.6 0 0 1 12 7c4.5 0 8.7 1.8 11.7 4.7.2.2.3.4.3.7s-.1.5-.3.7l-2.5 2.5c-.2.2-.4.3-.7.3s-.5-.1-.7-.3a11 11 0 0 0-2.7-1.9 1 1 0 0 1-.6-.9V9.7C15.2 9.3 13.6 9 12 9z"/>' },
    micOff: { d: '<path d="M15 10.4V6a3 3 0 0 0-5.8-1.1M9 9v2.6a3 3 0 0 0 4.8 2.4"/><path d="M18.4 11.2a6.4 6.4 0 0 1-.6 2.6M5.6 11.2a6.4 6.4 0 0 0 10.2 5.1M12 17.6V21"/><path d="M4 4l16 16"/>' },
    speaker: { d: '<path d="M4 9.4h3.2L11.6 6v12l-4.4-3.4H4z" fill="currentColor" stroke="none"/><path d="M15.2 9.2a4 4 0 0 1 0 5.6M17.8 6.6a7.6 7.6 0 0 1 0 10.8"/>' },
    timer: { d: '<circle cx="12" cy="13.2" r="7.4"/><path d="M12 13.2V9.6M9.8 2.8h4.4M18.2 6.8l1.4-1.4"/>' },
    nav: { f: 1, d: '<path d="M12 2.8 19.6 20.4 12 16.8l-7.6 3.6z"/>' },
    play: { f: 1, d: '<path d="M8 5.7v12.6c0 .9 1 1.4 1.7.9l9.6-6.3c.6-.4.6-1.4 0-1.8L9.7 4.8C9 4.3 8 4.8 8 5.7z"/>' },
    pause: { f: 1, d: '<rect x="6.4" y="5" width="4.2" height="14" rx="1.4"/><rect x="13.4" y="5" width="4.2" height="14" rx="1.4"/>' },
    prev: { f: 1, d: '<rect x="5.6" y="5.6" width="2.4" height="12.8" rx="1"/><path d="M18.6 6.5v11c0 .9-1 1.4-1.7.9l-7.4-5.5a1.1 1.1 0 0 1 0-1.8l7.4-5.5c.7-.5 1.7 0 1.7.9z"/>' },
    next: { f: 1, d: '<rect x="16" y="5.6" width="2.4" height="12.8" rx="1"/><path d="M5.4 6.5v11c0 .9 1 1.4 1.7.9l7.4-5.5a1.1 1.1 0 0 0 0-1.8L7.1 5.6c-.7-.5-1.7 0-1.7.9z"/>' },
    download: { d: '<path d="M12 4v10.6M7.6 10.4 12 14.8l4.4-4.4M5.2 19.4h13.6"/>' },
    check: { d: '<path d="M5.2 12.6 9.6 17 18.8 7.6"/>' },
    x: { d: '<path d="M6.5 6.5l11 11M17.5 6.5l-11 11"/>' },
    bell: { d: '<path d="M6.2 16.6V11a5.8 5.8 0 0 1 11.6 0v5.6l1.6 1.6H4.6z"/><path d="M10 20.6a2.2 2.2 0 0 0 4 0"/>' },
    bellOff: { d: '<path d="M8.2 6.1A5.8 5.8 0 0 1 17.8 11v4.2M15.6 18.2H4.6l1.6-1.6V11c0-.8.2-1.6.5-2.3"/><path d="M10 20.6a2.2 2.2 0 0 0 4 0M4 4l16 16"/>' },
    vibrate: { d: '<rect x="8.2" y="4" width="7.6" height="16" rx="2"/><path d="M4.8 8.6v6.8M2.2 10.6v2.8M19.2 8.6v6.8M21.8 10.6v2.8"/>' },
    media: { d: '<path d="M9.2 17.4V6.6l10-2v10.8"/><circle cx="6.8" cy="17.4" r="2.4"/><circle cx="16.8" cy="15.4" r="2.4"/>' },
    callVol: { d: '<path d="M6.6 10.8a15.1 15.1 0 0 0 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1A17 17 0 0 1 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1z"/>' },
    more: { f: 1, d: '<circle cx="5.8" cy="12" r="1.8"/><circle cx="12" cy="12" r="1.8"/><circle cx="18.2" cy="12" r="1.8"/>' },
    gear: { d: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/>' },
    power: { d: '<path d="M12 3.4v8.2"/><path d="M7.1 6.5a7.6 7.6 0 1 0 9.8 0"/>' },
    restart: { d: '<path d="M19.6 12a7.6 7.6 0 1 1-2.3-5.4"/><path d="M19.6 4.2v4.7h-4.7"/>' },
    sos: { f: 1, d: '<path d="M10.4 3.2h3.2v6.1l5.3-3.1 1.6 2.8-5.3 3 5.3 3.1-1.6 2.8-5.3-3.1v6.1h-3.2v-6.1l-5.3 3.1-1.6-2.8 5.3-3.1-5.3-3 1.6-2.8 5.3 3.1z"/>' },
    dnd: { d: '<circle cx="12" cy="12" r="8.2"/><path d="M8.2 12h7.6"/>' },
    key: { d: '<circle cx="7.6" cy="12" r="3.6"/><path d="M11.2 12h9.4M17.4 12v3.2M20.6 12v2.6"/>' },
    airplane: { f: 1, d: '<path d="M21 16v-2l-8-5V3.5a1.5 1.5 0 0 0-3 0V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5z"/>' },
    hotspot: { d: '<circle cx="12" cy="12.6" r="1.6" fill="currentColor" stroke="none"/><path d="M8.6 16a4.8 4.8 0 0 1 0-6.8M15.4 9.2a4.8 4.8 0 0 1 0 6.8M5.7 18.9a8.9 8.9 0 0 1 0-12.6M18.3 6.3a8.9 8.9 0 0 1 0 12.6"/>' },
    chevR: { d: '<path d="M9.4 5.6 15.8 12l-6.4 6.4"/>' },
    expand: { d: '<path d="M14.4 4.8h4.8v4.8M9.6 19.2H4.8v-4.8M19.2 4.8l-5.6 5.6M4.8 19.2l5.6-5.6"/>' },
    /* barra de tarefas do dobravel aberto: "Todas as apps" (3 x 3 pontos) e a lupa da pesquisa do painel das apps */
    apps: { f: 1, d: '<circle cx="5.6" cy="5.6" r="2"/><circle cx="12" cy="5.6" r="2"/><circle cx="18.4" cy="5.6" r="2"/><circle cx="5.6" cy="12" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="18.4" cy="12" r="2"/><circle cx="5.6" cy="18.4" r="2"/><circle cx="12" cy="18.4" r="2"/><circle cx="18.4" cy="18.4" r="2"/>' },
    search: { d: '<circle cx="10.8" cy="10.8" r="6.4"/><path d="m15.6 15.6 4.6 4.6"/>' },
  };
  function icon(name, size, cls) {
    const o = IC[name]; if (!o) return '';
    const s = size ? ` width="${size}" height="${size}"` : '';
    const paint = o.f ? 'fill="currentColor" stroke="none"' : 'fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"';
    return `<svg class="asi${cls ? ' ' + cls : ''}" viewBox="0 0 24 24" ${paint}${s} aria-hidden="true">${o.d}</svg>`;
  }

  /* ---------- MOLDURA do NOVA S26 Ultra ----------
     Aparelho 460x976 (o mesmo do PearPhone: as apps contam com o ecra 440x956 em (10,10)). Metal plano de 3 px + bisel
     preto uniforme de 7 px. Raios concentricos 50 (carcaca) > 47 (bisel) > 40 (ecra): bem mais retos que os 67/57 do
     PearPhone, como o S26 Ultra. A cor vem das variaveis --f1..--f4 de cada .device.frame-s26-* (oneui-sysui.css),
     tiradas das fotografias dos aparelhos. Tudo vetorial, sem filter nem box-shadow (regra do CEF). */
  /* retangulo arredondado (x, y, largura, altura, raio) */
  const rr = (x, y, w, h, r) => `M${x + r} ${y}H${x + w - r}A${r} ${r} 0 0 1 ${x + w} ${y + r}V${y + h - r}A${r} ${r} 0 0 1 ${x + w - r} ${y + h}H${x + r}A${r} ${r} 0 0 1 ${x} ${y + h - r}V${y + r}A${r} ${r} 0 0 1 ${x + r} ${y}Z`;
  /* a moldura segue o FORMATO e o ESTADO do aparelho (o system.js passa-os; sem eles, System.form / System.foldOpen): o NOVA
     dobrável (molduras flip-*) tem uma fechada e outra aberta (foldRing), os outros a do S26 */
  function frameRing(f, open) {
    const form = f || (window.System && System.form);
    if (form === 'fold') return foldRing(open != null ? !!open : !!(window.System && System.foldOpen));
    return barRing();
  }
  function barRing() {
    const R50 = rr(0, 0, 460, 976, 50), R47 = rr(3, 3, 454, 970, 47), R40 = rr(10, 10, 440, 956, 40);
    return `<svg class="frame-ring asb-ring" data-os="android" data-form="bar" viewBox="0 0 460 976" aria-hidden="true"><defs>
      <linearGradient id="asbFrame" gradientUnits="userSpaceOnUse" x1="40" y1="-10" x2="420" y2="986"><stop offset="0" class="s1"/><stop offset=".38" class="s2"/><stop offset=".72" class="s3"/><stop offset="1" class="s4"/></linearGradient>
      <linearGradient id="asbFlat" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="460" y2="0"><stop offset="0" stop-color="#fff" stop-opacity=".22"/><stop offset=".012" stop-color="#fff" stop-opacity="0"/><stop offset=".988" stop-color="#fff" stop-opacity="0"/><stop offset="1" stop-color="#fff" stop-opacity=".16"/></linearGradient>
      <linearGradient id="asbShine" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="0" y2="976"><stop offset="0" stop-color="#fff" stop-opacity=".18"/><stop offset=".08" stop-color="#fff" stop-opacity="0"/><stop offset=".92" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".16"/></linearGradient>
      </defs>
      <path class="shade" d="${rr(-6, -5, 472, 986, 56)}" stroke-width="4" stroke-opacity=".05"/><path class="shade" d="${rr(-3, -2.5, 466, 981, 53)}" stroke-width="3" stroke-opacity=".09"/><path class="shade" d="${rr(-1, -.5, 462, 977, 51)}" stroke-width="2" stroke-opacity=".14"/>
      <path fill="url(#asbFrame)" fill-rule="evenodd" d="${R50}${R47}"/><path fill="url(#asbFlat)" fill-rule="evenodd" d="${R50}${R47}"/><path fill="url(#asbShine)" fill-rule="evenodd" d="${R50}${R47}"/>
      <path class="bz" fill-rule="evenodd" d="${R47}${R40}"/>
      <path class="asb-chamfer" fill="none" d="${rr(3.4, 3.4, 453.2, 969.2, 46.6)}"/><path class="glass" fill="none" d="${R40}"/>
      <path class="rim" fill="none" d="${rr(.5, .5, 459, 975, 49.5)}"/></svg>`;
  }

  /* ---------- MOLDURA do NOVA dobravel (molduras flip-*, contrato v2 de 2026-10-01: abre como um LIVRO) ----------
     As referencias do dono: FECHADO (imagem 11) quase quadrado em pe, bisel fino, cantos pouco redondos; ABERTO (imagem 12)
     deitado, o mesmo bisel fino e as marcas pequenas da dobradica a meio das arestas de cima e de baixo. Sem vinco nenhum.
     Fechado 690x976 (ecra 670x956 em (10,10)), raios 34 > 30 > 24; aberto 1360x976 (ecra 1340x956), raios 32 > 28 > 22.
     Aluminio acetinado de 4 px + bisel preto de 6 px; cores em --f1..--f4 e --hg1..--hg3 de cada .device.frame-flip-*
     (oneui-sysui.css). A animacao de abrir/fechar e do system.js (o aparelho e a folha, o .frig no .stage). */
  function foldRing(open) {
    const W = open ? 1360 : 690, RO = open ? 32 : 34, M = W / 2;
    const O = rr(0, 0, W, 976, RO), Mt = rr(4, 4, W - 8, 968, RO - 4), S = rr(10, 10, W - 20, 956, RO - 10);
    /* dobradica (aberto): a moldura parte-se a meio e aparece a tampa escura, um pouco saliente, em cima e em baixo */
    const hinge = open ? `<path class="asf-gap" fill="none" d="M${M - 7} 0V4.4M${M + 7} 0V4.4M${M - 7} 971.6V976M${M + 7} 971.6V976"/>`
      + `<rect class="asf-cap" x="${M - 6.6}" y="-1.4" width="13.2" height="5.6" rx="1.8" fill="url(#asfHingeH)"/><rect class="asf-cap" x="${M - 6.6}" y="971.8" width="13.2" height="5.6" rx="1.8" fill="url(#asfHingeH)"/>` : '';
    return `<svg class="frame-ring asb-ring asf-ring" data-os="android" data-form="fold" viewBox="0 0 ${W} 976" aria-hidden="true"><defs>
      <linearGradient id="asfFrame" gradientUnits="userSpaceOnUse" x1="${(40 * W / 460).toFixed(1)}" y1="-10" x2="${(W - 40 * W / 460).toFixed(1)}" y2="986"><stop offset="0" class="s1"/><stop offset=".38" class="s2"/><stop offset=".72" class="s3"/><stop offset="1" class="s4"/></linearGradient>
      <linearGradient id="asfSatin" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="${W}" y2="0"><stop offset="0" stop-color="#fff" stop-opacity=".36"/><stop offset="${(5 / W).toFixed(4)}" stop-color="#fff" stop-opacity=".08"/><stop offset="${(1 - 5 / W).toFixed(4)}" stop-color="#fff" stop-opacity=".08"/><stop offset="1" stop-color="#fff" stop-opacity=".28"/></linearGradient>
      <linearGradient id="asfShine" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="0" y2="976"><stop offset="0" stop-color="#fff" stop-opacity=".22"/><stop offset=".07" stop-color="#fff" stop-opacity="0"/><stop offset=".93" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".14"/></linearGradient>
      <linearGradient id="asfHingeH" gradientUnits="userSpaceOnUse" x1="${M - 6.6}" y1="0" x2="${M + 6.6}" y2="0"><stop offset="0" class="h2"/><stop offset=".22" class="h1"/><stop offset=".5" class="h3"/><stop offset=".78" class="h1"/><stop offset="1" class="h2"/></linearGradient>
      </defs>
      <path class="shade" d="${rr(-6, -5, W + 12, 986, RO + 6)}" stroke-width="4" stroke-opacity=".05"/><path class="shade" d="${rr(-3, -2.5, W + 6, 981, RO + 3)}" stroke-width="3" stroke-opacity=".09"/><path class="shade" d="${rr(-1, -.5, W + 2, 977, RO + 1)}" stroke-width="2" stroke-opacity=".14"/>
      <path fill="url(#asfFrame)" fill-rule="evenodd" d="${O}${Mt}"/><path fill="url(#asfSatin)" fill-rule="evenodd" d="${O}${Mt}"/><path fill="url(#asfShine)" fill-rule="evenodd" d="${O}${Mt}"/>
      <path class="bz" fill-rule="evenodd" d="${Mt}${S}"/>
      <path class="asb-chamfer" fill="none" d="${rr(4.4, 4.4, W - 8.8, 967.2, RO - 4.4)}"/><path class="asf-lip" fill="none" d="${rr(9.4, 9.4, W - 18.8, 957.2, RO - 9.4)}"/><path class="glass" fill="none" d="${S}"/>
      <path class="rim" fill="none" d="${rr(.5, .5, W - 1, 975, RO - .5)}"/>${hinge}</svg>`;
  }
  /* o system.js redesenha a moldura quando muda o sistema, o formato ou o estado do dobravel; isto e so a garantia (Bridge
     'form:changed' / 'fold:state'): se a moldura que esta no aparelho ja e a certa, nao faz nada */
  function syncRing() {
    if (!isA()) return; const d = document.querySelector('.device'); if (!d) return;
    const cur = d.querySelector(':scope > .frame-ring'); if (cur && cur.dataset.os !== 'android') return;   /* anel do PearPhone: e do system.js */
    const form = (window.System && System.form) === 'fold' ? 'fold' : 'bar', st = form === 'fold' ? (System.foldOpen ? 'open' : 'closed') : '';
    if (cur && cur.dataset.form === form && (cur.dataset.state || '') === st) return;
    if (cur) cur.remove(); d.insertAdjacentHTML('beforeend', frameRing(form, form === 'fold' && System.foldOpen));
    const n = d.querySelector(':scope > .frame-ring'); if (n) { n.dataset.os = 'android'; n.dataset.ring = 'android'; if (st) n.dataset.state = st; }
  }
  /* rede de seguranca das copias desfocadas do fundo no NOVA dobravel: o makeBlur do system.js pinta a copia de uma imagem
     quando ela acaba de carregar, e a de um fundo ANTERIOR pode acabar depois da do atual (no arranque o Android comeca com o
     fundo da moldura por omissao, um JPG do S26, e o cetim do dobravel, um SVG, fica pronto primeiro): os paineis de vidro, a
     barra de estado e o texto do bloqueado ficavam com o fundo errado. Pouco depois volta-se a aplicar o fundo atual (a copia
     certa ja esta em cache, nada pisca) e a barra e o bloqueado medem outra vez a luz. */
  let wpT = null;
  const onNovaFold = () => isA() && !!window.System && System.form === 'fold';
  function wpSettle() {
    clearTimeout(wpT); if (!onNovaFold()) return;
    wpT = setTimeout(() => safe(() => {
      if (!onNovaFold() || typeof System.apply !== 'function') return;
      System.apply._wp = null; System.apply(); schedule();
      if (System.locked && window.Lock && Lock.tick) Lock.tick(new Date(), true);
    }), 900);
  }

  /* ---------- BARRA DE ESTADO (48 px) ----------
     Esquerda: hora (#sbTime, o System.tick escreve-a), chips das atividades (.asb-chips, do island.js) e os icones
     monocromaticos das apps com notificacoes por ler (.asb-notifs). Direita (.sb-right): privacidade, vibrar, Nao
     incomodar, VPN, ponto de acesso, aviao ou Wi-Fi + rede + sinal, e a bateria Nova UI (pilula com a carga e, com
     battPercent, o numero vazado). A cor segue o .light-sb (currentColor). Os nos so mudam quando o conteudo muda. */
  function ensureBar() {
    const sb = document.querySelector('#screen .statusbar') || document.querySelector('.statusbar'); if (!sb) return null;
    let chips = sb.querySelector(':scope > .asb-chips');
    if (!chips) { chips = document.createElement('span'); chips.className = 'asb-chips'; const t = sb.querySelector('#sbTime'); if (t && t.nextSibling) sb.insertBefore(chips, t.nextSibling); else sb.appendChild(chips); }
    let notifs = sb.querySelector(':scope > .asb-notifs');
    if (!notifs) { notifs = document.createElement('span'); notifs.className = 'asb-notifs'; sb.insertBefore(notifs, chips.nextSibling); }
    return { sb, chips, notifs, right: sb.querySelector('.sb-right') };
  }
  /* sinal de 4 barras arredondadas e Wi-Fi em leque, as formas da Nova UI (kit da One UI 8.5) */
  const SIGNAL = '<svg class="asb-sig" width="15" height="14" viewBox="0 0 14 14" fill="currentColor" aria-hidden="true"><rect x="0" y="9" width="2.2" height="5" rx="1.1"/><rect x="3.9" y="6" width="2.2" height="8" rx="1.1"/><rect x="7.8" y="3" width="2.2" height="11" rx="1.1"/><rect x="11.7" y="0" width="2.2" height="14" rx="1.1"/></svg>';
  /* sem SIM: o mesmo triangulo do sinal, so contorno, com um traco (as barras do SIGNAL a 25 % por baixo) */
  const NOSIM = '<svg class="asb-sig asb-nosim" width="15" height="14" viewBox="0 0 14 14" fill="currentColor" aria-hidden="true"><g opacity=".3"><rect x="0" y="9" width="2.2" height="5" rx="1.1"/><rect x="3.9" y="6" width="2.2" height="8" rx="1.1"/><rect x="7.8" y="3" width="2.2" height="11" rx="1.1"/><rect x="11.7" y="0" width="2.2" height="14" rx="1.1"/></g><path d="M1 1.2 12.8 13" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/></svg>';
  const WIFI = '<svg class="asb-wifi" width="18" height="14" viewBox="0 0 17.9 14" fill="currentColor" aria-hidden="true"><path d="M10 12.7a1.3 1.3 0 1 1-2.5 0 1.3 1.3 0 0 1 2.5 0Z"/><path d="M12.4 10.4c.4-.3.5-.9.1-1.2a6.3 6.3 0 0 0-7.3-.1c-.4.4-.3.9.1 1.2.4.4.9.3 1.3 0a4.5 4.5 0 0 1 4.5 0c.4.3 1 .4 1.3.1Z"/><path d="M14.9 7.8c.4-.3.5-.9.2-1.2a9.4 9.4 0 0 0-12.4-.1c-.3.4-.3.9.1 1.2.4.3.9.2 1.3-.1a7.6 7.6 0 0 1 9.6.1c.3.3.9.4 1.2.1Z"/><path d="M17.5 5.3c.4-.3.5-.9.2-1.3A12.6 12.6 0 0 0 .2 3.5c-.3.4-.2 1 .1 1.3.4.3 1 .3 1.4-.1a10.8 10.8 0 0 1 14.5.4c.4.4.9.5 1.3.2Z"/></svg>';
  let battSeq = 0;
  /* bateria Nova UI: pilula 25x13, carga opaca e o resto translucido; com a percentagem o numero sai VAZADO (mascara),
     como na One UI 8. Vermelha com pouca carga, laranja em poupanca de energia. */
  /* Nova UI 9 (One UI 8.5 e 9): a percentagem e obrigatoria na barra de estado e vive DENTRO da pilula ("fundo da bateria"),
     que ficou maior; por isso a barra pede sempre o numero (renderStatus) e a pilula pequena passa de 25x13 a 28x14 */
  function battery(level, pct, low, save, big) {
    const W = big ? 30 : 28, H = big ? 16 : 14, r = H / 2, id = 'asbB' + (++battSeq);
    const lv = Math.max(0, Math.min(100, Math.round(+level || 0)));
    const w = Math.max(r * .9, W * lv / 100).toFixed(2);
    const col = low ? '#F2453D' : save ? '#FF8A1F' : 'currentColor';
    const txt = pct ? `<text x="${W / 2}" y="${(H / 2 + (big ? 3.7 : 3.5)).toFixed(2)}" text-anchor="middle" font-family="Inter,'Segoe UI',sans-serif" font-size="${big ? 11 : 10}" font-weight="700" fill="#000">${lv}</text>` : '';
    return `<svg class="asb-batt" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}" aria-hidden="true"><defs><mask id="${id}m" maskUnits="userSpaceOnUse" x="0" y="0" width="${W}" height="${H}"><rect width="${W}" height="${H}" fill="#fff"/>${txt}</mask><clipPath id="${id}c"><rect width="${w}" height="${H}"/></clipPath></defs>`
      + `<g mask="url(#${id}m)"><rect width="${W}" height="${H}" rx="${r}" fill="currentColor" fill-opacity=".36"/><rect width="${W}" height="${H}" rx="${r}" fill="${col}" clip-path="url(#${id}c)"/></g></svg>`;
  }
  let rightSig = null;
  function renderStatus(state, ind) {
    if (!isA()) return;
    const bar = ensureBar(); if (!bar || !bar.right) return;
    const s = state || (window.System && System.state) || {}, i = ind || {};
    const low = (+s.battery || 0) <= 15, save = !!s.lowPower, pct = true;   /* Nova UI 9: o numero vai sempre dentro da pilula */
    /* eSIM (js/apps/esim.js): SIM obrigatório e nenhuma linha = o sinal riscado (sem SIM), como no Android */
    const nos = !!(window.ESim && ESim.noSim && ESim.noSim());
    const sig = [nos ? 1 : 0, i.cam ? 1 : 0, i.mic ? 1 : 0, s.silent ? 1 : 0, s.dnd ? 1 : 0, s.vpn ? 1 : 0, s.hotspot ? 1 : 0, s.airplane ? 1 : 0, s.wifi ? 1 : 0, s.cellular ? 1 : 0, s.battery, pct ? 1 : 0, low ? 1 : 0, save ? 1 : 0].join('|');
    if (sig !== rightSig || !bar.right.querySelector('.asb-batt')) {
      rightSig = sig; let h = '';
      if (i.cam || i.mic) h += `<i class="asb-priv${i.cam ? '' : ' asb-mic'}"></i>`;   /* indicador de privacidade: camara ou microfone em uso (verde, como no Android) */
      if (s.silent) h += icon('vibrate', 16, 'asb-ic');
      if (s.dnd) h += icon('dnd', 15, 'asb-ic');
      if (s.vpn) h += icon('key', 16, 'asb-ic');
      if (s.hotspot && !s.airplane) h += icon('hotspot', 16, 'asb-ic');
      if (s.airplane) h += icon('airplane', 16, 'asb-ic');
      if (s.wifi && !s.airplane) h += WIFI;
      if (nos && !s.airplane) h += NOSIM;
      else if (s.cellular && !s.airplane) h += (s.wifi ? '' : '<span class="asb-net">5G</span>') + SIGNAL;
      h += battery(s.battery, pct, low, save);
      bar.right.innerHTML = h;
    }
    renderNotifs();
  }

  /* ---------- icones das notificacoes por ler ----------
     Monocromaticos, como no Android: um glifo por app (as do sistema e as de terceiros que o recurso conhece) e, para
     as outras, a inicial num quadrado arredondado. Vem a app mais recente primeiro; o que nao cabe ao lado dos chips
     vira um ponto. */
  const NGLYPH = { messages: 'message', phone: 'phone', mail: 'mail', calendar: 'calendar', clock: 'clock', reminders: 'list', photos: 'photo', camera: 'camera',
    music: 'headphones', podcasts: 'headphones', maps: 'pin', weather: 'cloud', wallet: 'card', appstore: 'download', settings: 'gear', notes: 'book', recado: 'chat',
    instashot: 'camera', twix: 'at', reels: 'reels', facetime: 'video', darkchat: 'chat', match: 'heart', eats: 'cart', marketplace: 'cart', billing: 'receipt',
    services: 'lifebuoy', garage: 'car', home: 'home', findmy: 'location', crypto: 'chart', games: 'gamepad', aichat: 'sparkles', onion: 'globe', safari: 'globe',
    calculator: 'calc', groups: 'people', voicemsg: 'mic', airdrop: 'share', contacts: 'person', bank: 'bank', files: 'layers' };
  function monoIcon(app, size) {
    const sz = size || 16; const n = NGLYPH[app];
    if (n && window.Icons && Icons.has && Icons.has(n)) return `<span class="asb-ni-g" style="width:${sz}px;height:${sz}px">${Icons.g(n, sz)}</span>`;
    const nm = (window.App && App.name ? App.name(app) : app) || '?';
    return `<span class="asb-ni-l" style="width:${sz}px;height:${sz}px;font-size:${Math.round(sz * .62)}px">${esc(String(nm).trim().charAt(0).toUpperCase() || '?')}</span>`;
  }
  function unreadApps() {
    let l = []; try { l = window.Notify && Notify.all ? Notify.all() : []; } catch (e) { l = []; }
    /* as silenciosas (type 'silent') ficam so no painel, como no Android: nao ganham icone na barra de estado */
    const out = []; (Array.isArray(l) ? l : []).forEach(n => { if (n && !n.read && n.app && n.type !== 'silent' && out.indexOf(n.app) < 0) out.push(n.app); });
    return out;
  }
  let notifSig = null;
  function renderNotifs() {
    if (!isA()) return; const bar = ensureBar(); if (!bar) return;
    const apps = unreadApps();
    /* espaco: a hora + os chips + os icones nao podem passar da camara (x = 213). Sem chips cabem 4; com um, 2; com dois, nenhum */
    const nChips = bar.chips.querySelectorAll('.alc-chip:not(.alc-out)').length;
    const slots = nChips >= 2 ? 0 : nChips === 1 ? 2 : 4;
    const shown = apps.slice(0, slots), more = nChips < 2 && apps.length > shown.length;
    const sig = shown.join(',') + (more ? '+' : '');
    if (sig !== notifSig || bar.notifs.childElementCount !== shown.length + (more ? 1 : 0)) {
      notifSig = sig;
      bar.notifs.innerHTML = shown.map(a => `<span class="asb-ni" data-app="${esc(a)}">${monoIcon(a, 15)}</span>`).join('') + (more ? '<i class="asb-more"></i>' : '');
    }
    fitLeft();
  }
  /* a esquerda da barra (hora, chips, icones) nunca chega a camara (x 213): medido, porque a largura dos chips muda
     (uma chamada passa de 9:59 a 10:00, um titulo de musica comprido). Primeiro os icones das notificacoes saem, depois
     os chips encurtam o texto e, se ainda nao chegar, ficam so com o icone, do ultimo para o primeiro. So mede com chips na barra e o telemovel visivel. */
  const LEFT_MAX = 205;   /* a camara comeca em x 213: 8 px de folga */
  const SWn = () => (window.System && System.SW) || 440;   /* largura do ecra: 440, ou 670 / 1340 no dobravel */
  /* dobravel: a camara nao esta sempre ao meio (aberto fica a 72 % da largura): o limite e a aresta esquerda dela, medida */
  function leftMax(rs, k) {
    if (!(window.System && System.form === 'fold')) return LEFT_MAX;
    const c = document.querySelector('#screen .island'); const r = c && c.getBoundingClientRect();
    return r && r.width ? (r.left - rs.left) / k - 8 : SWn() / 2 - 15;
  }
  function fitLeft() {
    if (!isA()) return; const bar = ensureBar(); if (!bar) return;
    const chips = [...bar.chips.querySelectorAll('.alc-chip:not(.alc-out)')];
    const b = document.body; if (!chips.length || (b.classList.contains('hidden') && !b.classList.contains('pk'))) { chips.forEach(c => c.classList.remove('alc-tight', 'alc-compact')); bar.notifs.style.display = ''; return; }
    const s = scr(); const rs = s && s.getBoundingClientRect(); if (!rs || !rs.width) return; const k = rs.width / SWn(), max = leftMax(rs, k);
    const edge = () => (Math.max(bar.chips.getBoundingClientRect().right, bar.notifs.style.display === 'none' ? 0 : bar.notifs.getBoundingClientRect().right) - rs.left) / k;
    chips.forEach(c => c.classList.remove('alc-tight', 'alc-compact')); bar.notifs.style.display = '';
    if (edge() <= max) return;
    bar.notifs.style.display = 'none';
    for (let i = chips.length - 1; i >= 0 && edge() > max; i--) chips[i].classList.add('alc-tight');
    for (let i = chips.length - 1; i >= 0 && edge() > max; i--) chips[i].classList.add('alc-compact');
  }
  let nT = null;
  const notifsSoon = () => { clearTimeout(nT); nT = setTimeout(() => safe(renderNotifs), 30); };

  /* ---------- BARRA DE NAVEGACAO ----------
     buttons: 3 botoes (Recentes ||| , Inicio, Voltar <) numa barra de 48 px no fundo; gesture: so a pega 134x5.
     Sobre uma app a barra fica OPACA com a cor do que esta por cima dela (a app, a folha aberta, o teclado), medida no
     ecra e nao adivinhada: assim o fundo da app continua ate ao fundo como num Android. Na home, na gaveta, no bloqueado
     com o codigo e sobre os paineis fica transparente. */
  let nav = null, pill = null, kbh = null, inited = false;
  /* NOVA Fold8 (pedido do dono, 4 out, imagem 34): ABERTO a barra de baixo e a MESMA de fechado, ao centro: segue a escolha
     (por omissao os gestos, so a pega). A de 3 out forcava os 3 botoes a direita com o telemovel aberto. */
  const navMode = () => (window.System && System.state && System.state.navMode === 'gesture') ? 'gesture' : 'buttons';
  const navOrder = () => (window.System && System.state && System.state.navOrder === 'back-home-recents') ? 'back-home-recents' : 'recents-home-back';
  function buildNav() {
    const s = scr(); if (!s) return false;
    if (nav && nav.isConnected && pill && pill.isConnected && kbh && kbh.isConnected) return true;
    s.querySelectorAll(':scope > .anb, :scope > .anb-pill, :scope > .anb-kbh').forEach(n => n.remove());
    nav = document.createElement('div'); nav.className = 'anb';
    nav.innerHTML = `<div class="anb-btn anb-recents" data-k="recents" role="button" aria-label="${esc(T('Recentes'))}">${icon('recents', 22)}</div>`
      + `<div class="anb-btn anb-home" data-k="home" role="button" aria-label="${esc(T('Início'))}">${icon('home', 22)}</div>`
      + `<div class="anb-btn anb-back" data-k="back" role="button" aria-label="${esc(T('Voltar'))}">${icon('back', 22, 'anb-i-back')}${icon('kbdown', 22, 'anb-i-kb')}</div>`;
    pill = document.createElement('div'); pill.className = 'anb-pill';
    /* gestos com o teclado aberto: a seta para baixo à direita da pega esconde o teclado (como nos Samsung; com 3 botões é o
       próprio Voltar que vira seta, .anb-kb) */
    kbh = document.createElement('div'); kbh.className = 'anb-kbh'; kbh.setAttribute('role', 'button'); kbh.setAttribute('aria-label', T('Ocultar teclado'));
    kbh.innerHTML = icon('kbdown', 22);
    s.appendChild(nav); s.appendChild(pill); s.appendChild(kbh);
    kbh.addEventListener('pointerdown', e => e.stopPropagation());
    kbh.addEventListener('click', e => { e.stopPropagation(); tapFx(); if (window.Keyboard && Keyboard.hide) Keyboard.hide(); });
    const btn = k => nav.querySelector(`[data-k="${k}"]`);
    /* o pointerdown nao pode chegar aos gestos nem as camadas por baixo */
    nav.addEventListener('pointerdown', e => e.stopPropagation());
    btn('back').addEventListener('click', e => { e.stopPropagation(); tapFx(); back(); });
    btn('recents').addEventListener('click', e => { e.stopPropagation(); tapFx(); recents(); });
    btn('home').addEventListener('click', e => { e.stopPropagation(); tapFx(); home(); });
    /* manter o Inicio = Vera (se estiver ligada nas Definicoes), como o assistente da tecla Inicio do Android */
    if (window.UI && UI.longPress) UI.longPress(btn('home'), () => { if (!isA()) return; const st = System.state || {}; if (st.vera === false || !window.Vera || !Vera.open) return; safe(() => { if (System.locked) return; UI.dismissAll && UI.dismissAll(); Vera.open(); }); }, 520);
    return true;
  }
  const tapFx = () => { try { if (System.state.haptics !== false && window.Sound) Sound.play('click'); } catch (e) {} };

  /* cor por baixo da barra: percorre o que esta pintado nesse ponto do ecra (de cima para baixo) e mistura as cores
     de fundo ate ficar opaco. Uma imagem (fundo de ecra, capa) pelo caminho = barra transparente.
     grad (so o NOVA Fold8): um degrade sem imagem conta com a cor do FIM (a de baixo), por cima da cor de fundo do elemento, em vez
     de parar como uma imagem (o ceu da Meteorologia, o veu do leitor da Musica). O S26 continua como estava. */
  const parseRgb = v => { const m = /rgba?\(([^)]+)\)/.exec(v || ''); if (!m) return null; const p = m[1].split(',').map(x => parseFloat(x)); return { r: p[0], g: p[1], b: p[2], a: p.length > 3 ? p[3] : 1 }; };
  function sampleAt(x, y, grad) {
    const s = scr(); if (!s) return null; const rc = s.getBoundingClientRect(); if (!rc.width) return null; const k = rc.width / SWn();
    let list = []; try { list = document.elementsFromPoint(rc.left + x * k, rc.top + y * k); } catch (e) { return null; }
    let R = 0, G = 0, B = 0, A = 0, img = false;
    for (const n of list) {
      if (!s.contains(n) || n === s) continue;
      if (n === nav || n === pill || (nav && nav.contains(n))) continue;
      const cs = getComputedStyle(n);
      if (+cs.opacity < .05 || cs.visibility === 'hidden') continue;
      if (cs.backgroundImage && cs.backgroundImage !== 'none') {
        if (!grad || cs.backgroundImage.indexOf('url(') > -1) { img = true; break; }
        const st = cs.backgroundImage.match(/rgba?\([^)]+\)/g), gc = st && st.length ? parseRgb(st[st.length - 1]) : null;
        if (gc && gc.a > .01) { const w = (1 - A) * gc.a; R += gc.r * w; G += gc.g * w; B += gc.b * w; A += w; if (A >= .97) break; }
      }
      const c = parseRgb(cs.backgroundColor); if (!c || c.a <= .01) continue;
      const w = (1 - A) * c.a; R += c.r * w; G += c.g * w; B += c.b * w; A += w;
      if (A >= .97) break;
    }
    if (A <= 0) return { a: 0, img };
    return { r: R / A, g: G / A, b: B / A, a: A, img };
  }
  const lum = c => (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b) / 255;
  /* cor de fundo de uma APP aberta: a vista de cima, o conteudo dela, a raiz propria da app ou a janela (o primeiro opaco);
     sem nenhum opaco, a cor do tema da app (statusBar 'light' = app escura, como a Camara e a Musica). Camara/visor = preto. */
  function appBg(id) {
    if (!id || !System.windows) return null;
    if (document.body.classList.contains('see-through') || document.body.classList.contains('camera-mode')) return { r: 0, g: 0, b: 0, a: 1 };
    const win = System.windows[id]; if (!win || win.classList.contains('bg')) return null;
    const top = win.querySelector(':scope > .nav-stack > .view:last-child');
    const cands = [top, top && top.querySelector(':scope > .content'), top && top.querySelector(':scope > .content > *'), win.querySelector(':scope > .nav-stack'), win];
    for (const n of cands) { if (!n) continue; const c = parseRgb(getComputedStyle(n).backgroundColor); if (c && c.a >= .97) return c; }
    const def = (window.App && App.get(id)) || {};
    const darkApp = def.statusBar === 'light' ? true : def.statusBar === 'dark' ? false : document.body.classList.contains('dark');
    return darkApp ? { r: 1, g: 1, b: 2, a: 1 } : { r: 245, g: 245, b: 247, a: 1 };
  }
  /* o que se ve AGORA (sincrono: o teclado, a Vera e os pedidos de permissao perguntam-no ao abrir, antes do proximo
     updNav). A barra de 3 botoes nao aparece no assistente, nem no ecra bloqueado (so com o codigo ou uma app aberta),
     nem com o telemovel deitado (ai fica so a pega, como no PearOS). */
  function visibility() {
    if (!isA() || !window.System) return { buttons: false, pill: false };
    const mode = navMode(), locked = !!System.locked, app = System.currentApp ? System.currentApp() : null;
    const pin = !!(window.Lock && Lock.pinShown), setup = !!(window.Setup && Setup.running), land = !!System.landscape;
    const show = !setup && (!locked || pin || !!app);
    return { buttons: show && mode === 'buttons' && !land, pill: (show && mode === 'gesture' && !(locked && !app)) || (land && !!app) };
  }
  const navVisible = () => visibility().buttons;

  /* ---------- cor da barra de estado sobre fundos CLAROS ----------
     Com uma app aberta quem decide e o system.js (.light-sb). No ecra bloqueado o lock.js mede o fundo e poe #lock.als-lt
     quando e claro: a barra (irma do #lock, antes dele no DOM: sem :has nao ha CSS que la chegue) passa a escura com ele.
     Na home mede-se aqui a faixa de cima da copia pre-desfocada do fundo (--wp-blur), so quando ela muda. */
  let homeLuma = 0, lumaVar = null, lumaSeq = 0;
  const lumOf = (r, g, b) => (.2126 * r + .7152 * g + .0722 * b) / 255;
  function lumaHome() {
    const s = scr(); if (!s) return; const v = s.style.getPropertyValue('--wp-blur') || ''; if (v === lumaVar) return; lumaVar = v; const seq = ++lumaSeq;
    const m = /url\("([^"]+)"\)/.exec(v) || /url\('([^']+)'\)/.exec(v) || /url\(([^)]+)\)/.exec(v);
    if (!m) { const h = /#([0-9a-f]{6})/i.exec(v); const n = h ? parseInt(h[1], 16) : 0; setHomeLuma(h ? lumOf(n >> 16, (n >> 8) & 255, n & 255) : 0); return; }
    const img = new Image(); if (!/^data:/.test(m[1])) img.crossOrigin = 'anonymous';
    img.onload = () => { if (seq !== lumaSeq) return; try { const W = 12, H = 26, c = document.createElement('canvas'); c.width = W; c.height = H; const x = c.getContext('2d'); x.drawImage(img, 0, 0, W, H);
      const d = x.getImageData(0, 0, W, 2).data; let sum = 0; for (let i = 0; i < d.length; i += 4) sum += lumOf(d[i], d[i + 1], d[i + 2]); setHomeLuma(sum / (d.length / 4)); } catch (e) { setHomeLuma(0); } };
    img.onerror = () => { if (seq === lumaSeq) setHomeLuma(0); };
    img.src = m[1];
  }
  /* quem desenha por cima do fundo da home (relogio, nomes dos icones) pode seguir o mesmo: Bridge 'sysui:luma' { home } */
  function setHomeLuma(v) { const prev = homeLuma > .62; homeLuma = +v || 0; paintSb(); schedule(); if ((homeLuma > .62) !== prev) Bridge.emit('sysui:luma', { home: homeLuma, light: homeLuma > .62 }); }
  /* ecras de chamada do Telefone (phone.js poe as classes no #screen): voz e chamada recebida seguem o TEMA (escuros no
     claro), a videochamada e sempre de icones brancos por cima da imagem */
  function paintSb() {
    const sb = document.querySelector('#screen .statusbar'); if (!sb) return;
    let dark = false, light = false;
    if (isA() && window.System) {
      /* os ecras da chamada sao FILHOS do #screen (phone.js / facecall.js anexam-nos), nao classes dele: conta o que esta
         la e visivel (minimizado = display none; o cartao de fim continua no ecra ate sair do DOM) */
      const s = scr(), has = c => { if (!s) return false; if (s.classList.contains(c)) return true; const n = s.querySelector(':scope > .' + c); return !!(n && n.style.display !== 'none'); };
      const isOpen = m => { const o = window[m]; try { return !!(o && o.isOpen && o.isOpen()); } catch (e) { return false; } };
      const over = ['QuickPanel', 'Drawer', 'EdgePanel', 'Switcher', 'Vera'].some(isOpen);
      /* NOVA Fold8: a gaveta de apps (e a pesquisa dela) tem fundo próprio, claro no tema claro: o tom vem dela e não da faixa do
         fundo da home (que muda entre 670 e 1340 e trocava as cores ao abrir) */
      if (document.body.classList.contains('form-fold') && isOpen('Drawer') && !['QuickPanel', 'EdgePanel', 'Switcher', 'Vera'].some(isOpen)) dark = !document.body.classList.contains('dark');
      else if (!over) {
        if (has('afc-call')) light = true;
        else if (has('aph-call') || has('aph-inc')) { if (document.body.classList.contains('dark')) light = true; else dark = true; }
        else if (!(System.currentApp && System.currentApp())) {
          if (System.locked) { const lk = document.getElementById('lock'); dark = !!(lk && lk.classList.contains('als-lt') && !(window.Lock && Lock.pinShown)); }
          else dark = homeLuma > .62 && !(window.Home && ((Home.folderOpen && Home.folderOpen()) || (Home.searchOpen && Home.searchOpen())));
        }
      }
    }
    if (sb.classList.contains('asb-dark') !== dark) sb.classList.toggle('asb-dark', dark);
    if (sb.classList.contains('asb-light') !== light) sb.classList.toggle('asb-light', light);
  }
  let navSig = null;
  function updNav() {
    const a = isA(), b = document.body;
    if (!a) { if (b.dataset.nav) delete b.dataset.nav; if (nav) nav.classList.remove('anb-on'); if (pill) pill.classList.remove('anb-on'); if (kbh) kbh.classList.remove('anb-on'); navSig = null; tbOff(); paintSb(); return; }
    const mode = navMode(); if (b.dataset.nav !== mode) b.dataset.nav = mode;
    lumaHome(); paintSb();
    if (!buildNav()) return;
    if (nav.dataset.order !== navOrder()) nav.dataset.order = navOrder();
    const v = visibility();
    nav.classList.toggle('anb-on', v.buttons);
    pill.classList.toggle('anb-on', v.pill);
    nav.classList.toggle('anb-kb', !!(window.Keyboard && Keyboard.visible));
    const kbOn = navMode() === 'gesture' && !b.classList.contains('landscape') && !!(window.Keyboard && Keyboard.visible);
    if (kbh.classList.contains('anb-on') !== kbOn) kbh.classList.toggle('anb-on', kbOn);
    safe(tbUpd);   /* barra de tarefas do dobravel aberto (so dentro das apps) */
    if (b.classList.contains('hidden') && !b.classList.contains('pk')) return;   /* guardado: nada para medir (display:none) */
    /* cor: botoes por cima do que estiver logo acima da barra; pega por cima do que estiver por baixo dela */
    /* sem cor opaca por baixo (fundo de ecra, painel de vidro, codigo do bloqueado) os icones seguem a cor da barra de
       estado, que o sistema e os paineis ja acertam para o que esta por tras (.light-sb, painel rapido claro...) */
    const sbDark = () => { const sb = document.querySelector('#screen .statusbar'); const c = sb && parseRgb(getComputedStyle(sb).color); return !!(c && lum(c) < .5); };
    if (nav.classList.contains('anb-on')) {
      /* NOVA Fold8 aberto: a amostra e na ponta DIREITA (o detalhe das duas colunas, o teclado da Calculadora), nao em x 4 (a lista
         ou a barra lateral, que pintavam a barra inteira de 1340 com a cor delas). Um veu escuro por cima de uma imagem (o leitor
         da Musica) da uma barra escura, nao a cor clara de recurso */
      const fold = !!(window.System && System.form === 'fold');
      let c = sampleAt(onFoldOpen() ? SWn() - 4 : 4, 956 - 48 - 6, fold);
      let solid = !!(c && !c.img && c.a >= .97);
      if (!solid && fold && c && c.a >= .4 && lum(c) < .25) { c = { r: c.r * c.a, g: c.g * c.a, b: c.b * c.a, a: 1 }; solid = true; }
      /* COM UMA APP ABERTA a barra NUNCA fica transparente (2026-10-01, "os botoes do Samsung tem de se adaptar sempre a
         app"): se a amostra apanhou o fundo do ecra (a janela ainda a crescer do icone, uma lista com imagem por baixo,
         uma app de fundo transparente), a cor passa a ser a da propria app, como o navigationBarColor do Android */
      if (!solid && window.System && System.currentApp) { const fb = appBg(System.currentApp()); if (fb) { c = fb; solid = true; } }
      /* dobravel aberto: o cartao do painel rapido deixa a app a vista com um veu leve (oneui-panel.css .qp-bg, sem ponteiro, por
         isso a amostra nao o ve): a barra leva o mesmo veu */
      if (solid && onFoldOpen() && isOpenM('QuickPanel')) { const v = b.classList.contains('dark') ? .72 : .9; c = { r: c.r * v, g: c.g * v, b: c.b * v, a: 1 }; }
      const dark = solid ? lum(c) > .62 : sbDark();
      const bg = solid ? `rgb(${Math.round(c.r)},${Math.round(c.g)},${Math.round(c.b)})` : 'transparent';
      const sig = bg + '|' + dark;
      if (sig !== navSig) { navSig = sig; nav.style.backgroundColor = bg; nav.classList.toggle('anb-dk', dark); nav.classList.toggle('anb-solid', solid); }
    }
    if (pill.classList.contains('anb-on')) {
      const c = sampleAt(SWn() / 2, 944);
      const dark = (c && !c.img && c.a >= .97) ? lum(c) > .62 : sbDark();
      pill.classList.toggle('anb-dk', dark);
    }
  }
  let uT = null, uT2 = null, uT3 = null, uT4 = null;
  /* tres passagens: ja (o estado mudou), a meio e DEPOIS das transicoes (folhas, paineis e a janela de uma app a crescer do
     icone, que leva ~450 ms mais a mola: medida aos 480 ms ainda apanhava o fundo do ecra por baixo). No dobravel mais uma aos
     240 ms: o veu de um alerta ou de uma folha (0,2 s) escurece a barra logo a seguir a ele, e nao meio segundo depois */
  function schedule() { clearTimeout(uT); clearTimeout(uT2); clearTimeout(uT3); clearTimeout(uT4); uT = setTimeout(() => safe(updNav), 20); uT2 = setTimeout(() => safe(updNav), 480); uT3 = setTimeout(() => safe(updNav), 950);
    if (document.body.classList.contains('form-fold')) uT4 = setTimeout(() => safe(updNav), 240); }

  /* observa so o que decide a barra: os filhos diretos do ecra (folhas, paineis, teclado, bloqueado), as janelas das
     apps e a pilha de vistas de cada uma. Nada de subtree no ecra inteiro (as listas das apps mudam a toda a hora). */
  let mo = null; const seen = new WeakMap();
  function watch(n, opts) { if (!n || !mo) return; const k = JSON.stringify(opts); if (seen.get(n) === k) return; seen.set(n, k); try { mo.observe(n, opts); } catch (e) {} }
  function hookTree() {
    const s = scr(); if (!s || !mo) return;
    watch(s, { childList: true, attributes: true, attributeFilter: ['class'] });
    const ap = document.getElementById('apps');
    [...s.children].forEach(c => { if (c === nav || c === pill || c === ap || c === ftb || (atp && c === atp.wrap)) return; watch(c, { attributes: true, attributeFilter: ['class'] }); });
    if (ap) { watch(ap, { childList: true, attributes: true, attributeFilter: ['class'] }); [...ap.children].forEach(w => { watch(w, { attributes: true, attributeFilter: ['class'] }); const st = w.querySelector(':scope > .nav-stack'); if (st) watch(st, { childList: true }); }); }
  }
  function startObserver() {
    if (mo || typeof MutationObserver !== 'function') return;
    mo = new MutationObserver(recs => {
      let hit = false;
      for (const r of recs) { const t = r.target; if (t === nav || t === pill || (nav && nav.contains(t)) || (ftb && ftb.contains(t)) || (atp && atp.wrap.contains(t))) continue;
        /* a barra flutuante e o painel das apps entram e saem do #screen sem mudar nada da barra */
        if (r.type === 'childList' && [...r.addedNodes, ...r.removedNodes].every(n => n === ftb || (atp && n === atp.wrap))) continue;
        hit = true; break; }
      if (!hit || !isA()) return;
      hookTree(); schedule();
    });
    hookTree();
  }

  /* ---------- BARRA DE TAREFAS do NOVA Fold8 ABERTO (spec_fold 1, 2026-10-03) ----------
     So no ecra de dentro e so DENTRO das apps (a home tem a dock e a pesquisa; nunca no ecra de fora, no bloqueado, nos
     paineis, nos recentes, com o teclado, na camara nem numa chamada em ecra inteiro). Esquerda para a direita: "Todas as
     apps", as apps da dock (ate 6), um fio e 2 recentes (a mais recente primeiro, sem as da dock nem a que esta a frente).
     - botoes: a propria barra de 48 px leva o grupo de apps (.anb-tb) a esquerda dos tres botoes, que ficam a direita;
     - gestos: barra flutuante (.atb: botao redondo + pilula) escondida; um deslizar CURTO e LENTO para cima a partir da pega
       mostra-a, qualquer toque fora dela ou outra app esconde-a.
     Tudo construido UMA vez: os icones sao nos por id que so mudam de sitio (nada pisca ao abrir ou trocar de app).
     Para os outros modulos: body.atb-on (barra de tarefas a vista), body.atb-up (a flutuante esta em cima) e --taskbar-h no body
     (quanto ela tapa por cima da janela da app: 72 px com a flutuante, 0 com botoes porque ai o #apps ja acaba na barra). */
  const TB_PIN = 6, TB_REC = 3, FTB_H = 72;   /* 3 recentes, como no Fold (imagem 17 do dono) */
  let tbBox = null, ftb = null, atp = null, tbSigNow = '', tbH = -1, ftbUp = false;
  const onFoldOpen = () => isA() && !!window.System && System.form === 'fold' && !!System.foldOpen;
  const isOpenM = m => { const o = window[m]; try { return !!(o && o.isOpen && o.isOpen()); } catch (e) { return false; } };
  /* a barra pode estar a vista? (o teclado so a esvazia: os botoes continuam) */
  function tbEligible() {
    if (!onFoldOpen()) return false;
    const app = System.currentApp ? System.currentApp() : null, b = document.body, s = scr();
    if (!app || System.locked || System.landscape || (window.Setup && Setup.running) || (window.Hardware && Hardware.screenOff)) return false;
    /* a câmara TEM a barra de tarefas no Fold aberto (imagem 18 do dono); o resto do ecrã transparente (Face Key) não */
    if (app !== 'camera' && (b.classList.contains('camera-mode') || b.classList.contains('see-through'))) return false;
    if (callScreenUp() || (s && s.querySelector(':scope > .afc-call, :scope > .fc'))) return false;
    if (['QuickPanel', 'Drawer', 'Switcher', 'Vera', 'EdgePanel'].some(isOpenM)) return false;
    return true;
  }
  const tbGestureOk = () => navMode() === 'gesture' && tbEligible() && !(window.Keyboard && Keyboard.visible);
  /* apps da barra: as da dock da home e as 2 recentes */
  function tbData() {
    const inst = System.installed ? System.installed() : [], cur = System.currentApp ? System.currentApp() : null;
    const ok = id => typeof id === 'string' && inst.includes(id) && !!(window.App && App.get(id)) && !App.get(id).hidden;
    const lay = window.Home && Home.layout ? Home.layout() : null;
    const pin = ((lay && lay.dock) || []).filter((id, i, a) => ok(id) && a.indexOf(id) === i).slice(0, TB_PIN);
    const rec = [];
    (System.recents || []).concat((System.state && System.state.recentApps) || []).forEach(id => { if (rec.length < TB_REC && ok(id) && id !== cur && !pin.includes(id) && !rec.includes(id)) rec.push(id); });
    return { pin, rec };
  }
  /* icone da barra: um no por app, que so muda de sitio */
  function tbIcon(id, cls) {
    const n = document.createElement('div'); n.className = cls; n.dataset.id = id; n.setAttribute('role', 'button'); n.setAttribute('aria-label', App.name(id));
    n.innerHTML = Icons.tileBox(id);
    n.addEventListener('pointerdown', e => { e.stopPropagation(); n._held = false; });
    n.addEventListener('click', e => { e.stopPropagation(); if (n._held) { n._held = false; return; } tapFx(); tbOpen(id, n); });
    if (window.UI && UI.longPress) UI.longPress(n, () => { n._held = true; tbMenu(id, n); }, 480);
    return n;
  }
  function tbSync(box, ids, cls) {
    if (!box) return; const have = new Map(); [...box.children].forEach(n => have.set(n.dataset.id, n));
    let prev = null;
    ids.forEach(id => { let n = have.get(id); if (n) have.delete(id); else n = tbIcon(id, cls);
      const want = prev ? prev.nextSibling : box.firstChild; if (n !== want) box.insertBefore(n, want); prev = n; });
    have.forEach(n => n.remove());
  }
  function tbFill() {
    const d = tbData(), sig = d.pin.join(',') + '|' + d.rec.join(',');
    if (sig === tbSigNow && (!tbBox || tbBox.isConnected) && (!ftb || ftb.isConnected)) return;
    tbSigNow = sig;
    [tbBox, ftb].forEach(r => { if (!r) return; tbSync(r.querySelector('.tb-pin'), d.pin, 'tb-ic'); tbSync(r.querySelector('.tb-rec'), d.rec, 'tb-ic'); r.classList.toggle('tb-norec', !d.rec.length); });
  }
  /* abrir ou trocar de app: a janela nasce do icone da barra; a flutuante e o painel das apps saem */
  function tbOpen(id, n) {
    closeAtp(true); hideFtb();
    if (!window.App || !App.get(id)) return;
    if (System.currentApp && System.currentApp() === id) return;
    safe(() => System.openApp(id, n && n.querySelector('.tile')));
  }
  /* toque longo: o menu da app (o mesmo pop-up da home e da gaveta) */
  function tbMenu(id, n) {
    if (!window.Home || !Home.ahMenu) return; const d = App.get(id) || {}; const rows = [];
    let a = []; try { a = typeof d.actions === 'function' ? d.actions() : d.actions; } catch (e) { a = []; }
    (Array.isArray(a) ? a : []).filter(x => x && x.label && typeof x.onTap === 'function').slice(0, 4).forEach(x => rows.push({ label: x.label, icon: x.icon || 'chevR', onTap: () => { hideFtb(); x.onTap(); } }));
    rows.push({ label: T('Abrir'), icon: 'expand', onTap: () => tbOpen(id, n) });
    safe(() => Home.ahMenu(n, rows, [{ label: T('Informações'), icon: 'info', onTap: () => { hideFtb(); Home.appInfo && Home.appInfo(id); } }]));
  }
  const tbAppsBtn = cls => `<div class="${cls}" role="button" aria-label="${esc(T('Todas as apps'))}">${icon('apps', 20)}</div>`;
  const tbInner = () => `<div class="tb-pin"></div><i class="tb-div"></i><div class="tb-rec"></div>`;
  /* com botoes: o grupo vive DENTRO da barra de navegacao (a esquerda dos botoes) */
  function ensureTb() {
    if (!nav) return null; if (tbBox && tbBox.parentNode === nav) return tbBox;
    tbBox = document.createElement('div'); tbBox.className = 'anb-tb'; tbBox.innerHTML = tbAppsBtn('anb-tba') + tbInner();
    tbBox.querySelector('.anb-tba').addEventListener('click', e => { e.stopPropagation(); tapFx(); toggleAtp(); });
    nav.insertBefore(tbBox, nav.firstChild); tbSigNow = ''; return tbBox;
  }
  /* com gestos: a barra flutuante (botao redondo + pilula), por cima da pega */
  function ensureFtb() {
    const s = scr(); if (!s) return null; if (ftb && ftb.parentNode === s) return ftb;
    ftb = document.createElement('div'); ftb.className = 'atb';
    ftb.innerHTML = `<div class="atb-in">${tbAppsBtn('atb-apps')}<div class="atb-pill">${tbInner()}</div></div>`;
    ftb.addEventListener('pointerdown', e => e.stopPropagation());
    ftb.querySelector('.atb-apps').addEventListener('click', e => { e.stopPropagation(); tapFx(); toggleAtp(); });
    s.appendChild(ftb); tbSigNow = ''; return ftb;
  }
  /* 0 = sem nada inline (vale o 0px do oneui-sysui.css): o body dos outros telemoveis nunca ganha estilo */
  function setTbH(px) { if (px === tbH) return; tbH = px; if (px) document.body.style.setProperty('--taskbar-h', px + 'px'); else document.body.style.removeProperty('--taskbar-h'); }
  function tbClasses(on) { const b = document.body; if (b.classList.contains('atb-on') !== on) b.classList.toggle('atb-on', on); if (b.classList.contains('atb-up') !== ftbUp) b.classList.toggle('atb-up', ftbUp); setTbH(ftbUp ? FTB_H : 0); }
  function showFtb() {
    if (!tbGestureOk() || !ensureFtb()) return; tbFill();
    ftbUp = true; ftb.classList.add('atb-up'); if (pill) pill.classList.add('anb-tbup'); tbClasses(true);
  }
  function hideFtb() {
    if (!ftbUp) return; ftbUp = false;
    if (ftb) ftb.classList.remove('atb-up'); if (pill) pill.classList.remove('anb-tbup');
    if (atp && atp.open && !atpTyping()) closeAtp();   /* a escrever na pesquisa do painel: o teclado esconde a barra, o painel fica */
    tbClasses(!!(nav && nav.classList.contains('anb-tbon')));
  }
  /* outro sistema (trocou-se para um PearPhone): a barra de tarefas sai toda, com as classes e o --taskbar-h do body (antes ficavam
     atb-on e .anb-tbon e o SysUI.taskbar.on dizia true no PearOS) */
  function tbOff() {
    closeAtp(true); ftbUp = false; if (ftb) ftb.classList.remove('atb-up'); if (pill) pill.classList.remove('anb-tbup');
    if (nav) nav.classList.remove('anb-tbon'); tbClasses(false);
  }
  /* estado da barra a cada passagem do updNav */
  function tbUpd() {
    if (!nav) return;
    const ok = tbEligible(), mode = navMode(), kb = !!(window.Keyboard && Keyboard.visible);
    const bar = ok && mode === 'buttons' && nav.classList.contains('anb-on');
    if (bar || (ok && mode === 'gesture') || tbBox) { if (onFoldOpen()) ensureTb(); }
    if (bar || ftbUp) tbFill();
    if (nav.classList.contains('anb-tbon') !== (bar && !kb)) nav.classList.toggle('anb-tbon', bar && !kb);
    if (ftbUp && !tbGestureOk()) hideFtb();
    if (atp && atp.open && !ok) closeAtp(true);
    tbClasses((bar && !kb) || ftbUp);
  }

  /* gestos: deslizar CURTO e LENTO para cima a partir da pega (largar entre 40 e 140 px, devagar) = mostrar a barra; mais
     comprido ou mais rapido continua a ser o Inicio / os Recentes do gestures.js. Ouvido em captura no window, antes da
     .hb-zone: so nesse caso o pointerup nao lhe chega e o arrasto dele acaba com um pointercancel sem deslocamento (a janela
     volta com mola, como num arrasto curto). Um toque fora da barra flutuante esconde-a. */
  let sw = null, synth = false;
  const zk = () => (window.UI && UI.zoom && UI.zoom()) || 1;
  function swDown(e) {
    if (synth) return; const t = e.target;
    if (ftbUp && ftb && !ftb.contains(t) && !(atp && atp.wrap.contains(t))) hideFtb();
    sw = (t && t.classList && t.classList.contains('hb-zone') && tbGestureOk()) ? { id: e.pointerId, x: e.clientX, y: e.clientY, ly: e.clientY, lt: Date.now(), vy: 0, z: zk() } : null;
  }
  function swMove(e) { if (!sw || synth || e.pointerId !== sw.id) return; const now = Date.now(); sw.vy = (sw.ly - e.clientY) / sw.z / Math.max(1, now - sw.lt); sw.ly = e.clientY; sw.lt = now; }
  function swUp(e) {
    if (synth) return; const s = sw; sw = null; if (!s || e.pointerId !== s.id || e.type !== 'pointerup') return;
    const dy = (s.y - e.clientY) / s.z, dx = (e.clientX - s.x) / s.z, v = Date.now() - s.lt > 90 ? 0 : s.vy;
    if (dy < 40 || dy > 140 || Math.abs(dx) > 90 || v > .8 || !tbGestureOk()) return;
    e.stopImmediatePropagation();
    synth = true;
    try { e.target.dispatchEvent(new PointerEvent('pointercancel', { bubbles: true, cancelable: true, pointerId: s.id, clientX: s.x + 12 * s.z, clientY: s.y, pointerType: e.pointerType || 'mouse', isPrimary: true })); } catch (x) {}
    synth = false;
    showFtb();
  }

  /* ---------- PAINEL "Todas as apps" (botao da barra de tarefas) ----------
     Cartao de vidro por cima da barra (760 de largura, 8 colunas, pesquisa em pilula em baixo), por cima da app. A grelha
     faz-se uma vez e so muda quando as apps mudam; a pesquisa so esconde/mostra os icones. Fecha ao tocar fora, com Voltar,
     com o Inicio e ao abrir uma app. */
  function drawerApps() {
    if (window.Drawer && typeof Drawer.apps === 'function') { try { return Drawer.apps(); } catch (e) {} }
    return (System.installed ? System.installed() : []).filter(id => App.get(id) && !App.get(id).hidden);
  }
  function ensureAtp() {
    const s = scr(); if (!s) return null; if (atp && atp.wrap.parentNode === s) return atp;
    const wrap = document.createElement('div'); wrap.className = 'atp-w';
    wrap.innerHTML = `<div class="atp"><div class="atp-g"></div><div class="atp-none"></div><label class="atp-s">${icon('search', 20)}<input class="atp-q" type="text" spellcheck="false" autocomplete="off" maxlength="40"></label></div>`;
    s.appendChild(wrap);
    const card = wrap.firstElementChild, grid = card.querySelector('.atp-g'), input = card.querySelector('.atp-q');
    input.placeholder = T('Pesquisar'); card.querySelector('.atp-none').textContent = T('Sem resultados');
    wrap.addEventListener('pointerdown', e => { e.stopPropagation(); if (e.target === wrap) closeAtp(); });
    input.addEventListener('input', () => atpFilter());
    atp = { wrap, card, grid, input, open: false, sig: '' };
    return atp;
  }
  function atpFill() {
    const ids = drawerApps(), sig = ids.join(','); if (sig === atp.sig) return; atp.sig = sig;
    const have = new Map(); [...atp.grid.children].forEach(n => have.set(n.dataset.id, n)); let prev = null;
    ids.forEach(id => { let n = have.get(id);
      if (n) have.delete(id);
      else { n = document.createElement('div'); n.className = 'atp-it'; n.dataset.id = id; n.setAttribute('role', 'button'); n.innerHTML = Icons.tileBox(id) + '<span></span>';
        n.lastElementChild.textContent = App.name(id); n.addEventListener('click', e => { e.stopPropagation(); tapFx(); tbOpen(id, n); }); }
      const want = prev ? prev.nextSibling : atp.grid.firstChild; if (n !== want) atp.grid.insertBefore(n, want); prev = n; });
    have.forEach(n => n.remove());
  }
  function atpFilter() {
    if (!atp) return; const q = String(atp.input.value || '').trim().toLowerCase(); let n = 0;
    [...atp.grid.children].forEach(it => { const hit = !q || App.name(it.dataset.id).toLowerCase().includes(q); if (hit) n++; if (it.classList.contains('atp-hide') === hit) it.classList.toggle('atp-hide', !hit); });
    atp.card.classList.toggle('atp-empty', !n);
  }
  function openAtp() {
    if (!tbEligible() || !ensureAtp()) return;
    atpFill(); atp.input.value = ''; atpFilter();
    atp.wrap.classList.toggle('atp-g-mode', navMode() === 'gesture');
    atp.open = true; atp.wrap.classList.add('on'); void atp.wrap.offsetWidth; atp.wrap.classList.add('in');
    document.body.classList.add('atp-open');
  }
  function closeAtp(instant) {
    if (!atp || !atp.open) return; atp.open = false;
    try { atp.input.blur(); } catch (e) {} try { if (window.Keyboard && Keyboard.visible && Keyboard.hide) Keyboard.hide(); } catch (e) {}
    atp.wrap.classList.remove('in'); document.body.classList.remove('atp-open'); atpKb();
    clearTimeout(atp.t); const w = atp.wrap; if (instant) w.classList.remove('on'); else atp.t = setTimeout(() => { if (!atp.open) w.classList.remove('on'); }, 220);
  }
  function toggleAtp() { if (atp && atp.open) closeAtp(); else openAtp(); }
  /* o teclado aberto pela pesquisa do painel (keyboard.js abre-o no focusin): o cartão SOBE (transform, oneui-sysui.css .atp-kb) até
     ficar 12 acima das teclas e encolhe o que for preciso para o topo não sair do ecrã; o teclado passa para cima do véu do painel
     (body.atp-open #kb), para as teclas apanharem os toques. Antes o cartão ficava por cima do teclado e tapava as filas do meio */
  const atpTyping = () => !!(atp && atp.open && window.Keyboard && Keyboard.visible && document.activeElement === atp.input);
  function atpKb() {
    if (!atp) return; const kb = document.getElementById('kb'); let lift = 0;
    if (atp.open && kb && window.Keyboard && Keyboard.visible) {
      const bot = parseFloat(getComputedStyle(atp.card).bottom) || 0, kbTop = 956 - kb.offsetHeight - (parseFloat(getComputedStyle(kb).bottom) || 0);
      lift = Math.max(0, Math.round((956 - bot) - (kbTop - 12)));
    }
    if (lift) atp.wrap.style.setProperty('--atp-kb', lift + 'px'); else atp.wrap.style.removeProperty('--atp-kb');
    if (atp.wrap.classList.contains('atp-kb') !== lift > 0) atp.wrap.classList.toggle('atp-kb', lift > 0);
  }

  /* ---------- VOLTAR / INICIO / RECENTES ---------- */
  const panels = ['QuickPanel', 'EdgePanel', 'Drawer', 'Switcher', 'Vera', 'Notify', 'CC', 'LockGallery'];
  function closePanels() { panels.forEach(m => { const o = window[m]; try { if (o && o.isOpen && o.isOpen() && o.close) o.close(); } catch (e) {} }); }
  const callScreenUp = () => { const c = window.PhoneApp && PhoneApp.current; return !!(c && c.el && c.el.isConnected && !c.min && c.el.style.display !== 'none'); };
  /* ordem do contrato (docs/ANDROID.md 4): teclado > camada de cima > paineis/gaveta/Edge/recentes/pasta/pesquisa >
     vista da app > fechar a app. Devolve true quando o Voltar fez alguma coisa. */
  function back() {
    if (!isA()) return false;
    return !!safe(() => {
      if (window.Hardware && Hardware.screenOff) return false;
      if (window.Keyboard && Keyboard.visible) { const a = document.activeElement; if (a && a.blur && a.matches && a.matches('input,textarea,[contenteditable]')) a.blur(); Keyboard.hide(); schedule(); return true; }
      /* barra de tarefas do dobravel aberto: o painel das apps e a barra flutuante saem primeiro */
      if (atp && atp.open) { closeAtp(); return true; }
      if (ftbUp) { hideFtb(); return true; }
      if (window.Hardware && Hardware.powerOpen && Hardware.powerOpen()) { Hardware.hidePowerOff(); return true; }
      if (window.Hardware && Hardware.volumeOpen && Hardware.volumeOpen()) { Hardware.hideVolume(); return true; }
      if (window.Island && Island.expanded) { Island.collapse(); return true; }
      if (window.UI && UI.dismissTop && UI.dismissTop()) return true;
      /* os modulos com estados por dentro (edicao dos mosaicos, pesquisa da gaveta, menu de um icone) tem o seu back():
         devolve true quando gastou o toque. Os outros fecham se estiverem abertos. */
      for (const m of panels) { const o = window[m]; try {
        if (!o) continue;
        if (typeof o.back === 'function') { if (o.back()) return true; continue; }
        if (o.isOpen && o.isOpen() && o.close) { o.close(); return true; }
      } catch (e) { console.error('[apex_phone] back', m, e); } }
      /* cartao dos auriculares (Earbuds, permissions.js): nao e uma folha do UI, sai com o hide() dele */
      { const s = scr(); if (window.Earbuds && Earbuds.hide && s && s.querySelector(':scope > .abud-card.in, :scope > .earbuds-card.in')) { Earbuds.hide(); return true; } }
      if (window.Home && !System.currentApp()) {
        if (typeof Home.back === 'function') { if (Home.back()) return true; }
        else {
          if (Home.folderOpen && Home.folderOpen()) { Home.closeFolder(); return true; }
          if (Home.searchOpen && Home.searchOpen()) { Home.closeSearch(); return true; }
          if (Home.edit) { Home.exitEdit(); return true; }
        }
        if (Home.spotOpen && Home.spotOpen()) { Home.closeSpot(); return true; }
      }
      if (System.locked) {
        if (System.currentApp()) { System.closeApp(); return true; }
        if (window.Lock && Lock.pinShown) { Lock.hidePin(); return true; }
        return false;
      }
      /* chamada em ecra inteiro: o Voltar leva-a para o chip da barra de estado (a chamada continua); a tocar nao recusa */
      if (callScreenUp()) { const c = PhoneApp.current; if (c.t0 || c.outgoing) PhoneApp.minimize(); return true; }
      const id = System.currentApp();
      if (id) {
        const win = System.windows[id], def = (window.App && App.get(id)) || {};
        /* uma app pode tratar o Voltar ela propria (camada interna, leitor, editor, selecao):
           App.define({ back(win) { ...; return true } }) (onBack tambem serve). true = gastou o toque. */
        for (const fn of [def.back, def.onBack]) { if (typeof fn !== 'function') continue; try { if (fn.call(def, win) === true) return true; } catch (e) { console.error('[apex_phone] back', id, e); } }
        const stack = win && win.querySelector(':scope > .nav-stack');
        if (stack) {
          const top = stack.lastElementChild;
          if (top && top.classList.contains('leave')) return true;   /* ja esta a voltar: um segundo toque nao tira duas vistas */
          const views = [...stack.children].filter(v => !v.classList.contains('leave'));
          if (views.length > 1) { const nb = top.querySelector(':scope > .navbar .nb-back'); if (nb) nb.click(); else UI.pop(top); return true; }
        }
        System.closeApp(); return true;
      }
      return false;
    });
  }
  function home() {
    if (!isA()) return;
    safe(() => {
      if (window.Hardware && Hardware.screenOff) { Hardware.wake(); return; }
      if (window.Hardware && Hardware.powerOpen && Hardware.powerOpen()) Hardware.hidePowerOff();
      if (window.Island && Island.expanded) Island.collapse();
      if (window.UI && UI.dismissAll) UI.dismissAll();
      closePanels(); closeAtp(true); hideFtb();
      if (System.locked) { if (System.currentApp()) System.closeApp(); else if (window.Lock && Lock.pinShown) Lock.hidePin(); return; }
      /* a chamada (ligada ou ainda a chamar) passa para o chip da barra de estado: sem isto o Inicio com uma chamada a sair
         nao fazia nada (o ecra da chamada fica por cima de tudo) */
      if (callScreenUp()) PhoneApp.minimize();
      if (window.Home) {
        /* tudo o que estiver aberto na home sai (menu de um icone, selecao, pasta, edicao, pesquisa) */
        if (typeof Home.reset === 'function') { try { Home.reset(); } catch (e) { console.error('[apex_phone] Home.reset', e); } }
        if (typeof Home.back === 'function') { let n = 0; while (n++ < 8 && Home.back()) {} }
        else { if (Home.closeFolder) Home.closeFolder(); if (Home.closeSearch && Home.searchOpen && Home.searchOpen()) Home.closeSearch(); if (Home.edit && Home.exitEdit) Home.exitEdit(); }
        if (Home.closeSpot && Home.spotOpen && Home.spotOpen()) Home.closeSpot();
      }
      if (System.currentApp()) System.closeApp(); else if (window.Home && Home.goPage) Home.goPage(0);
    });
    schedule();
  }
  function recents() {
    if (!isA()) return;
    safe(() => {
      if ((window.Hardware && Hardware.screenOff) || System.locked) return;
      if (window.Island && Island.expanded) Island.collapse();
      if (window.UI && UI.dismissAll) UI.dismissAll();
      closeAtp(true); hideFtb();
      ['QuickPanel', 'EdgePanel', 'Drawer', 'Vera', 'Notify', 'CC'].forEach(m => { const o = window[m]; try { if (o && o.isOpen && o.isOpen() && o.close) o.close(); } catch (e) {} });
      if (callScreenUp()) PhoneApp.minimize();
      if (window.Switcher && Switcher.toggle) Switcher.toggle();
    });
    schedule();
  }

  /* ---------- arranque ---------- */
  function applyAll() { safe(updNav); if (isA()) { safe(() => System.renderStatus && System.renderStatus()); safe(renderNotifs); } schedule(); }
  function init() {
    if (inited) return; inited = true;
    ensureBar(); buildNav(); startObserver();
    Bridge.on('os:changed', () => { rightSig = null; notifSig = null; navSig = null; applyAll(); });
    Bridge.on('state', p => { if (!p) return; if ('navMode' in p || 'navOrder' in p || 'theme' in p || 'dark' in p || 'edgePanel' in p) { navSig = null; schedule(); safe(updNav); } });
    ['app:open', 'app:close', 'app:kill', 'rotate', 'lock', 'unlock', 'ready', 'phone:open', 'wallpaper:changed'].forEach(ev => Bridge.on(ev, () => schedule()));
    ['notif', 'notification', 'notify:changed', 'notif:open', 'app:open', 'phone:open', 'session:changed', 'factory:reset'].forEach(ev => Bridge.on(ev, notifsSoon));
    /* barra de tarefas: o deslizar curto da pega (em captura, antes do gestures.js) e o que a esconde */
    addEventListener('pointerdown', e => safe(() => swDown(e)), true);
    addEventListener('pointermove', e => safe(() => swMove(e)), true);
    addEventListener('pointerup', e => safe(() => swUp(e)), true);
    addEventListener('pointercancel', e => { if (!synth) sw = null; }, true);
    ['app:open', 'app:close', 'app:kill', 'lock', 'phone:close', 'os:changed', 'fold:state', 'form:changed'].forEach(ev => Bridge.on(ev, () => { safe(hideFtb); if (ev !== 'app:open') safe(() => closeAtp(true)); }));
    Bridge.on('apps:changed', () => { if (atp) atp.sig = ''; tbSigNow = ''; });
    Bridge.on('kb:show', () => { safe(atpKb); safe(updNav); }); Bridge.on('kb:hide', () => { safe(atpKb); safe(updNav); });   /* o painel "Todas as apps" sobe por cima do teclado */
    applyAll();
  }
  /* o System.setOS corre no arranque ANTES do init dos modulos: o body[data-nav] tem de estar certo logo a seguir */
  if (window.Bridge && Bridge.on) Bridge.on('os:changed', () => { if (!inited) { const b = document.body; if (isA()) b.dataset.nav = navMode(); else delete b.dataset.nav; } });
  /* tambem antes do init: a primeira moldura do arranque (setFrame logo a seguir ao setOS) ja e a do dobravel. Abrir ou fechar o
     dobravel muda a largura do ecra: a barra (chips ate a camara) e a de navegacao voltam a medir-se */
  if (window.Bridge && Bridge.on) { Bridge.on('form:changed', () => { safe(syncRing); wpSettle(); }); Bridge.on('wallpaper:changed', wpSettle);
    Bridge.on('fold:state', () => { safe(syncRing); wpSettle(); if (inited) { navSig = null; schedule(); safe(fitLeft); } }); }

  /* barra de tarefas (NOVA Fold8 aberto): show/hide = a flutuante dos gestos; apps = o painel "Todas as apps" */
  const taskbar = { show: () => safe(showFtb), hide: () => safe(hideFtb), openApps: () => safe(openAtp), closeApps: () => safe(() => closeAtp()),
    get on() { return document.body.classList.contains('atb-on'); }, get up() { return ftbUp; }, get appsOpen() { return !!(atp && atp.open); }, get height() { return Math.max(0, tbH); } };
  return { init, frameRing, syncRing, renderStatus, renderNotifs, fitLeft, back, home, recents, navMode, navOrder, navVisible, get homeLight() { return homeLuma > .62; }, icon, monoIcon, unreadApps, battery, ensureBar, refresh: schedule, taskbar, get inited() { return inited; } };
})();
