/* ===================== APPS DE TRABALHO (apps personalizadas do painel admin), 2026-10-03 =====================
   Policia, hospital, mecanico, taxi, advogados, noticias, empresas... O painel (admin.js, "Apps de trabalho") cria as
   definicoes; o servidor (server/capps.lua) publica-as em GlobalState['apex_phone:capps'] e o client/capps.lua passa-as
   para aqui (push 'capps:defs' e o callback 'capps:get' no arranque). Este ficheiro:
     · desenha o icone de cada app (degrade bg -> bg2 com o glifo branco ao centro, o mesmo vidro dos icones do sistema);
     · regista/retira cada app com App.define('capp_' + id) conforme quem a pode ver (publica ou emprego da equipa) e
       volta a avaliar quando as definicoes mudam ou o emprego muda (player:update), como o thirdparty.js;
     · abre a app: separadores com os modulos do lado escolhido ("Cidadão / Equipa" para quem e da equipa) e uma vista
       por tipo de modulo: form, appointments, dispatch, records, posts, roster, info e (v2) catalog (menu + carrinho +
       encomendas), billing (faturas da empresa, a quem esta perto ou por numero) e duty (entrar/sair de servico, turnos);
     · v2: campos novos (email, url, hora, escolha multipla, estrelas, foto, secao, texto) com min/max, valor de origem,
       ajuda e showIf (o campo aparece/desaparece ao vivo; o servidor aplica a mesma regra); o capps.access diz, por
       modulo, que lado existe e que acoes o escalao permite (can.reply/status/assign/delete/create): o que nao pode,
       nao aparece;
     · refresca ao vivo (push 'capps:changed'): so as linhas afetadas mudam, nada de repintar a lista inteira.
   A NUI nunca decide nada: cada pedido vai ao servidor (capps.*), que volta a verificar papel, escalao, dono e tamanhos.
   Texto do admin e dos jogadores vai sempre dentro de data-noi18n (o tradutor do telemovel nao lhe toca).
   window.CApps = { glyphs, glyphNames, glyphSvg(name, size), iconFor(def), iconSvg(def), defs(), open(id) }
   ============================================================================================================ */
window.CApps = (() => {
  const esc = UI.esc;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => { if (window.L && L.tf) return L.tf(s, ...a); let i = 0; return String(s).replace(/%s/g, () => String(a[i++] == null ? '' : a[i - 1])); };
  const isA = () => !!(window.System && System.os === 'android');
  const arrOf = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);
  const NI = 'data-noi18n';

  /* ---------- GLIFOS (24x24, traco, como os do Icons.P) ----------
     Servem o icone da app (em grande, no degrade) e os icones dos separadores dos modulos. Ficam tambem no Icons.P como
     'cap_<nome>' para o UI.tabbar, o UI.empty e a barra direita do PearPhone Fold os desenharem sem nada de especial. */
  const P0 = (window.Icons && Icons.P) || {};
  const GLYPHS = {
    shield: P0.shield || '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>',
    badge: '<path d="M12 2 4 5v6c0 5 3.4 9.4 8 11 4.6-1.6 8-6 8-11V5z"/><path d="m12 7.6 1.3 2.7 2.9.4-2.1 2 .5 2.9-2.6-1.4-2.6 1.4.5-2.9-2.1-2 2.9-.4z"/>',
    siren: '<path d="M7 18v-6a5 5 0 0 1 10 0v6"/><path d="M4 21v-2a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v2z"/><path d="M12 2v2M4.2 5.2l1.4 1.4M19.8 5.2l-1.4 1.4M2 12h2M20 12h2"/>',
    medical: '<path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6z"/>',
    heartPulse: '<path d="M19.5 12.6 12 20l-7.5-7.4A5 5 0 1 1 12 6.1a5 5 0 1 1 7.5 6.5z"/><path d="M4 12h4l1.5-3 3 6 1.5-3h6"/>',
    stethoscope: '<path d="M5 3H4a1 1 0 0 0-1 1v5a5 5 0 0 0 10 0V4a1 1 0 0 0-1-1h-1"/><path d="M8 14v1a6 6 0 0 0 12 0v-3"/><circle cx="20" cy="10" r="2"/>',
    hospital: '<path d="M12 7v4M10 9h4"/><path d="M6 22V5a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v17"/><path d="M2 22h20M3 22V12h3M21 22V12h-3M10 22v-4h4v4"/>',
    pill: '<path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7z"/><path d="m8.5 8.5 7 7"/>',
    syringe: '<path d="m18 2 4 4M17 7l3-3M19 9 8.7 19.3a2.4 2.4 0 0 1-3.4 0l-.6-.6a2.4 2.4 0 0 1 0-3.4L15 5M9 11l4 4M5 19l-3 3M14 4l6 6"/>',
    dna: '<path d="M2 15c6.7-6 13.3 0 20-6M9 22c1.8-2 2.5-4 2.8-6M15 2c-1.8 2-2.5 4-2.8 6"/><path d="m17 6-2.5-2.5M14 8l-1-1M7 18l2.5 2.5M3.5 14.5l.5.5M20 9l.5.5M6.5 12.5l1 1M16.5 10.5l1 1M10 16l1.5 1.5"/>',
    wrench: P0.wrench || '<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.8-3.8a6 6 0 0 1-7.9 7.9l-6.9 6.9a2.1 2.1 0 0 1-3-3l6.9-6.9a6 6 0 0 1 7.9-7.9z"/>',
    hammer: '<path d="m15 12-8.4 8.4a2.1 2.1 0 1 1-3-3L12 9"/><path d="M17.6 15 22 10.6M20.9 11.7l-1.2-1.2c-.6-.6-.9-1.4-.9-2.3v-.9L16 4.6A5.6 5.6 0 0 0 12.1 3H9l.9.8A6.2 6.2 0 0 1 12 8.4V10l2 2h2.5l2.3 1.9"/>',
    car: '<path d="M5 17h14M6 17v2H4v-6l2-5h12l2 5v6h-2v-2M3 13h18"/><path d="M7.5 14.5h.01M16.5 14.5h.01"/>',
    towTruck: '<path d="M2 16V9h6l3 4h7a2 2 0 0 1 2 2v1"/><path d="M8 17h7"/><circle cx="5.5" cy="17" r="2"/><circle cx="17.5" cy="17" r="2"/><path d="M13 13 20 6v3"/>',
    taxi: '<rect x="9" y="2.5" width="6" height="3" rx="1"/><path d="M5 17h14M6 17v2H4v-6l2-5h12l2 5v6h-2v-2M3 13h18"/>',
    truck: '<path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2M15 18H9M19 18h2a1 1 0 0 0 1-1v-3.6a1 1 0 0 0-.2-.6l-3.5-4.4a1 1 0 0 0-.8-.4H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/>',
    bus: '<path d="M8 6v6M15 6v6M2 12h19.6M18 18h3s.5-1.7.8-2.8c.1-.4.2-.8.2-1.2s-.1-.8-.2-1.2l-1.4-5C20.1 6.8 19.1 6 18 6H4a2 2 0 0 0-2 2v10h3"/><circle cx="7" cy="18" r="2"/><path d="M9 18h5"/><circle cx="16" cy="18" r="2"/>',
    fireTruck: '<path d="M2 17v-7h11v7M13 12h4l3 3v2h-1M3 7h10M3 5h10M6 5v2M9 5v2"/><circle cx="6" cy="17.5" r="2"/><circle cx="16" cy="17.5" r="2"/><path d="M8 17.5h6"/>',
    plane: P0.airplane || '<path d="M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z"/>',
    boat: '<path d="M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1s1.2 1 2.5 1c2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1"/><path d="M19.4 20A11.6 11.6 0 0 0 21 14l-9-4-9 4c0 2.9.9 5.3 2.8 7.8M19 13V7a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v6M12 10v4M12 2v3"/>',
    fuel: P0.fuel || '<path d="M3 22V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v16M3 22h10M13 10h2a2 2 0 0 1 2 2v3a1.5 1.5 0 0 0 3 0V9l-3-3"/><path d="M5 8h6"/>',
    scale: '<path d="m16 16 3-8 3 8c-.9.6-1.9 1-3 1s-2.1-.4-3-1z"/><path d="m2 16 3-8 3 8c-.9.6-1.9 1-3 1s-2.1-.4-3-1z"/><path d="M7 21h10M12 3v18M3 7h2c2 0 5-1 7-2 2 1 5 2 7 2h2"/>',
    gavel: '<path d="m14.5 12.5-8 8a2.1 2.1 0 1 1-3-3l8-8"/><path d="m16 16 6-6M8 8l6-6M9 7l8 8M21 11l-8-8"/>',
    handcuffs: '<circle cx="6.5" cy="16" r="4.5"/><circle cx="17.5" cy="16" r="4.5"/><path d="M4.5 11.6V9.5h4v2.1M15.5 11.6V9.5h4v2.1M8.5 9.5l1.6-2h3.8l1.6 2"/>',
    idCard: '<rect x="2" y="5" width="20" height="14" rx="2"/><circle cx="8" cy="11" r="2"/><path d="M5 16a3 3 0 0 1 6 0M14 10h5M14 14h3"/>',
    document: '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6M8 13h8M8 17h5"/>',
    clipboard: P0.clipboard || '<rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>',
    newspaper: P0.newspaper || '<path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0V6"/><path d="M18 14h-8M15 18h-5M10 6h8v4h-8z"/>',
    megaphone: '<path d="m3 11 18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/>',
    mic: P0.mic || '<rect x="9" y="2" width="6" height="12" rx="3"/><path d="M5 10a7 7 0 0 0 14 0M12 17v4M8 21h8"/>',
    camera: P0.camera || '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/>',
    tv: P0.tv || '<rect x="2" y="4" width="20" height="14" rx="2"/><path d="M8 22h8"/>',
    radio: '<rect x="6" y="7" width="12" height="15" rx="2"/><path d="M9 7V2M10 12h4M10 16h4"/>',
    flame: P0.flame || '<path d="M12 2c1.5 4 5 5.5 5 11a5 5 0 0 1-10 0c0-2.5 1-4 2-5 .5 2 1.5 3 2.5 3.5C12 9 11 6 12 2z"/>',
    building: '<rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4M8 6h.01M12 6h.01M16 6h.01M8 10h.01M12 10h.01M16 10h.01M8 14h.01M12 14h.01M16 14h.01"/>',
    house: P0.home || '<path d="m3 11 9-8 9 8v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 22V12h6v10"/>',
    bank: P0.bank || '<path d="M3 9.5 12 4l9 5.5M5 10v8M9.5 10v8M14.5 10v8M19 10v8M3 20.5h18"/>',
    briefcase: P0.briefcase || '<rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2M2 13h20"/>',
    store: '<path d="M3 9 4.5 4h15L21 9M4 9v11h16V9M3 9a3 3 0 0 0 6 0 3 3 0 0 0 6 0 3 3 0 0 0 6 0M9 20v-5h6v5"/>',
    bag: P0.bag2 || '<path d="M6 8h12l1 12H5z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
    cart: P0.cart || '<circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2 2h2l2.7 12.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L22 7H5.1"/>',
    food: '<path d="M3 2v7a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2V2M7 2v20M21 15V2a5 5 0 0 0-5 5v6a2 2 0 0 0 2 2h3zm0 0v7"/>',
    coffee: '<path d="M17 8h1a4 4 0 1 1 0 8h-1M3 8h14v9a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4zM6 2v2M10 2v2M14 2v2"/>',
    wine: '<path d="M8 22h8M7 10h10M12 15v7M12 15a5 5 0 0 0 5-5c0-2-.5-4-2-8H9c-1.5 4-2 6-2 8a5 5 0 0 0 5 5z"/>',
    scissors: '<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><path d="M20 4 8.1 15.9M14.5 14.5 20 20M8.1 8.1 12 12"/>',
    dumbbell: '<path d="M6.5 6.5 17.5 17.5M2.5 13.5l2-2M9.5 20.5l2-2M13.5 2.5l-2 2M20.5 9.5l-2 2"/><path d="m4 15 5 5M3 14l7 7M15 4l5 5M14 3l7 7"/>',
    school: '<path d="M22 10 12 5 2 10l10 5 10-5z"/><path d="M6 12v5c3 3 9 3 12 0v-5M22 10v6"/>',
    hardHat: '<path d="M2 18a1 1 0 0 0 1 1h18a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1zM10 10V5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v5M4 15v-3a6 6 0 0 1 6-6M14 6a6 6 0 0 1 6 6v3"/>',
    key: P0.key || '<circle cx="8" cy="15" r="4"/><path d="m10.9 12.1 8.1-8.1M21 6l-2-2M17 8l-2-2"/>',
    lock: P0.lock || '<rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
    eye: P0.eye || '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/>',
    calendar: P0.calendar || '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>',
    clock: P0.clock || '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    mapPin: P0.pin || '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/>',
    globe: P0.globe || '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>',
    phone: P0.phone || '<path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1.9.4 1.9.7 2.8a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.8.6 2.8.7a2 2 0 0 1 1.7 2z"/>',
    chat: P0.chat || '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
    bell: P0.bell || '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
    star: P0.star || '<path d="m12 2 3.1 6.3 6.9 1-5 4.9 1.2 6.8L12 17.8 5.8 21l1.2-6.8-5-4.9 6.9-1z"/>',
    trophy: '<path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6M18 9h1.5a2.5 2.5 0 0 0 0-5H18M4 22h16M10 14.7V17c0 .6-.5 1-1 1.2C7.9 18.8 7 20.2 7 22M14 14.7V17c0 .6.5 1 1 1.2 1.1.6 2 2 2 3.8M18 2H6v7a6 6 0 0 0 12 0z"/>',
    ticket: '<path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"/><path d="M13 5v2M13 17v2M13 11v2"/>',
    users: P0.users || '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8"/>',
    user: P0.person || '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
    wifi: P0.wifi || '<path d="M5 12.6a11 11 0 0 1 14.1 0M1.4 9a16 16 0 0 1 21.2 0M8.5 16.1a6 6 0 0 1 7 0M12 20h.01"/>',
    bolt: P0.bolt || '<path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z"/>',
    leaf: '<path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.5 19 2c1 2 2 4.2 2 8 0 5.5-4.8 10-10 10z"/><path d="M2 21c0-3 1.9-5.4 5.1-6C9.5 14.5 12 13 13 12"/>',
    paw: '<circle cx="11" cy="4" r="2"/><circle cx="18" cy="8" r="2"/><circle cx="20" cy="16" r="2"/><path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.8 1C6.5 17.5 4.5 16.8 4.5 16.8A3.5 3.5 0 0 1 5.5 10z"/>',
    gear: P0.gear || '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M4.2 4.2l2.1 2.1M17.7 17.7l2.1 2.1M2 12h3M19 12h3M4.2 19.8l2.1-2.1M17.7 6.3l2.1-2.1"/>',
    music: P0.music || '<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>',
    gamepad: P0.gamepad || '<path d="M6 12h4M8 10v4M15 13h.01M18 11h.01"/><path d="M17.3 5H6.7a4 4 0 0 0-4 3.6l-.6 6.8A2.7 2.7 0 0 0 6.8 17l2-2.5h6.4l2 2.5a2.7 2.7 0 0 0 4.7-1.6l-.6-6.8a4 4 0 0 0-4-3.6z"/>',
    film: P0.film || '<rect x="2" y="2" width="20" height="20" rx="2"/><path d="M7 2v20M17 2v20M2 12h20M2 7h5M2 17h5M17 17h5M17 7h5"/>',
    book: P0.book || '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>',
    coins: '<circle cx="8" cy="8" r="6"/><path d="M18.1 10.4A6 6 0 1 1 10.3 18M7 6h1v4M16.7 13.9l.7.7-2.8 2.8"/>',
    chart: P0.chart || '<path d="M3 3v18h18M7 15l4-5 4 3 5-7"/>',
    flag: P0.flag || '<path d="M4 22V4a1 1 0 0 1 1-1h11l-2 4 2 4H5"/>',
    lifebuoy: P0.lifebuoy || '<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="4"/><path d="m4.9 4.9 4.3 4.3M14.8 9.2l4.3-4.3M14.8 14.8l4.3 4.3M9.2 14.8l-4.3 4.3"/>',
    info: P0.info || '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>',
    list: P0.list || '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
  };
  /* nomes que os modelos do painel admin (admin.js) usam e que faltavam: desenho proprio, tambem escolhiveis no painel */
  Object.assign(GLYPHS, {
    heart: '<path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8l1 1.1L12 21l7.8-7.5 1-1.1a5.5 5.5 0 0 0 0-7.8z"/>',
    bag2: '<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18M16 10a4 4 0 0 1-8 0"/>',
    grid: '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/>',
    send: '<path d="M22 2 11 13M22 2l-7 20-4-9-9-4z"/>',
    tag: '<path d="M20.6 13.4 13.4 20.6a2 2 0 0 1-2.8 0L2 12V2h10l8.6 8.6a2 2 0 0 1 0 2.8z"/><path d="M7 7h.01"/>',
    speaker: '<path d="M11 5 6 9H2v6h4l5 4z"/><path d="M15.5 8.5a5 5 0 0 1 0 7M19 5a10 10 0 0 1 0 14"/>',
    drop: '<path d="M12 2.7 6.3 8.4a8 8 0 1 0 11.4 0z"/>',
  });
  const GLYPH_NAMES = Object.keys(GLYPHS);
  if (window.Icons && Icons.P) GLYPH_NAMES.forEach(k => { Icons.P['cap_' + k] = GLYPHS[k]; });
  const glyphOk = n => (typeof n === 'string' && GLYPHS[n]) ? n : null;
  function glyphSvg(name, size) {
    const s = size ? ` width="${+size || 24}" height="${+size || 24}"` : '';
    return `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"${s}>${GLYPHS[glyphOk(name) || 'star']}</svg>`;
  }
  const gi = (name, size) => UI.g('cap_' + (glyphOk(name) || 'star'), size);

  /* ---------- cores (sem color-mix: o CEF do jogo nao o tem) ---------- */
  const hexOk = h => (typeof h === 'string' && /^#[0-9a-f]{6}$/i.test(h.trim())) ? h.trim() : null;
  const rgb = h => { const n = parseInt(String(h).slice(1, 7), 16); return [n >> 16 & 255, n >> 8 & 255, n & 255]; };
  const rgba = (h, a) => { const [r, g, b] = rgb(h); return `rgba(${r},${g},${b},${a})`; };
  const mix = (a, b, t) => { const x = rgb(a), y = rgb(b); return '#' + x.map((v, i) => Math.round(v + (y[i] - v) * t).toString(16).padStart(2, '0')).join(''); };
  const lum = h => { const [r, g, b] = rgb(h); return (.2126 * r + .7152 * g + .0722 * b) / 255; };
  const hash = s => { let h = 0; for (const c of String(s)) h = (h * 31 + c.charCodeAt(0)) | 0; return Math.abs(h).toString(36); };

  /* ---------- icone da app ----------
     O MESMO caminho dos icones de outros resources: App.define({ icon: { svg } }) -> Icons.custom (lista branca de SVG).
     O SVG leva o fundo em degrade, o glifo com a sombra suave dos glifos do sistema (Icons.GL) e o vidro (Icons.SVG): na
     home, na dock, na AppShop e no alternador fica igual a uma app de origem, nos dois sistemas (a mascara e do aparelho). */
  function colors(def) {
    const ic = (def && def.icon) || {};
    const bg = hexOk(ic.bg) || hexOk(def && def.accent) || '#1F5EFF';
    return { bg, bg2: hexOk(ic.bg2) || mix(bg, '#000000', .38), fg: hexOk(ic.fg) || '#FFFFFF' };
  }
  function iconSvg(def) {
    const c = colors(def), glyph = GLYPHS[glyphOk(def && def.icon && def.icon.glyph) || 'star'];
    const gid = 'gCap' + hash((def && def.id) + c.bg + c.bg2);
    const inner = Icons.G(gid, mix(c.bg, '#ffffff', .1), c.bg, c.bg2) + Icons.GL(`<g transform="translate(21.2 21.2) scale(2.4)" fill="none" stroke="${c.fg}" color="${c.fg}" stroke-width="2.05" stroke-linecap="round" stroke-linejoin="round">${glyph}</g>`);
    return Icons.SVG(inner);
  }
  function iconFor(def) {
    const img = def && def.icon && def.icon.image;
    if (typeof img === 'string' && /^(https:\/\/|nui:\/\/)/i.test(img.trim()) && img.length < 400) return { url: img.trim() };
    return { svg: iconSvg(def || {}) };
  }
  /* mini-icone (cabecalho das vistas): quadradinho com o degrade e o glifo, sem o SVG inteiro do icone */
  const miniIcon = (def, size = 22) => { const c = colors(def); return `<span class="cap-mini" style="width:${size}px;height:${size}px;background:linear-gradient(160deg,${c.bg},${c.bg2});color:${c.fg}">${glyphSvg(def.icon && def.icon.glyph, Math.round(size * .62))}</span>`; };

  /* ---------- estado ---------- */
  let DEFS = {}, ORDER = [], CATS = ['Serviços públicos', 'Emprego', 'Empresas'], SERVER = 'Servidor', REV = null;
  let ACC = null;                       /* { [id]: { member, staff, civil, grade, onduty } } vindo do servidor (capps.access) */
  const SIDE = {};                      /* lado escolhido por app nesta sessao */
  const WINS = {};                      /* janelas abertas: id -> estado da janela */
  const appId = id => 'capp_' + id;
  const MOD_GLYPH = { form: 'document', appointments: 'calendar', dispatch: 'siren', records: 'clipboard', posts: 'megaphone', roster: 'users', info: 'info', catalog: 'bag2', billing: 'coins', duty: 'clock' };
  /* modulos so da equipa (o cidadao nunca tem lado neles) */
  const STAFF_ONLY = { roster: true, billing: true, duty: true };
  const modGlyph = m => glyphOk(m && m.icon) || MOD_GLYPH[m && m.type] || 'star';

  /* pedidos: rpcRaw (o rpc normal troca { error } por null no jogo e perdia-se o motivo) */
  const rpc = (name, data) => Promise.resolve(Bridge.rpcRaw(name, data || {})).then(r => (r == null || r === false) ? { error: 'net' } : r, () => ({ error: 'net' }));
  const ERR = {
    net: 'Sem resposta do servidor. Tenta novamente.', app: 'Esta app foi desativada.', module: 'Esta secção já não está disponível.',
    forbidden: 'Não tens acesso a esta secção.', offduty: 'Entra em serviço para usar a área da equipa.', notfound: 'Este registo já não existe.',
    toomany: 'Atingiste o limite de pedidos em aberto.', open: 'Já tens um pedido em curso.', full: 'Esse horário acabou de ficar cheio. Escolhe outro.',
    slot: 'Esse horário já não está disponível.', service: 'Escolhe um serviço.', type: 'Escolhe o tipo de pedido.', empty: 'Preenche o formulário antes de enviar.',
    photo: 'A ligação da imagem tem de começar por https://', gone: 'Este pedido já foi tratado por outra pessoa.', grade: 'O teu cargo não permite fazer isto.',
    location: 'Não foi possível obter a tua localização.', phone: 'Não existe nenhum cidadão com esse número.', subject: 'Indica o assunto da ficha.',
    closed: 'Este registo está fechado.', status: 'Estado inválido.', db: 'O servidor ainda está a arrancar. Tenta daqui a pouco.', noplayer: 'Sem sessão. Tenta novamente.', ratelimit: 'Demasiados pedidos seguidos. Espera um pouco.',
    unavailable: 'Um dos artigos já não está disponível. Revê a encomenda.', reason: 'Indica o motivo da fatura.', far: 'Essa pessoa já não está perto de ti.',
    self: 'Não podes faturar-te a ti próprio.', society: 'O teu emprego não pode faturar em nome da empresa.', billed: 'Esta encomenda já foi faturada.',
    duty: 'O serviço é gerido pelo servidor.', target: 'Escolhe a quem faturar.', amount: 'Valor inválido. Usa um número inteiro.', billing: 'As faturas não estão disponíveis neste servidor.',
  };
  const errMsg = r => { if (!r) return T(ERR.net); if (r.error === 'cooldown') return TF('Espera %s s antes de tentares outra vez.', Math.max(1, Math.ceil(+r.wait || 1)));
    if (r.error === 'qty') return TF('Máximo de %s unidades por artigo.', +r.max || 1);
    if (r.error === 'pinlimit') return TF('Só podes ter %s comunicados fixados.', +r.max || 1);
    if (r.error === 'amount' && r.max) return TF('O valor máximo é %s.', UI.money(+r.max));
    if (r.error === 'required' || r.error === 'field' || r.error === 'range') return T('Revê os campos do formulário.'); return T(ERR[r.error] || 'Não foi possível concluir. Tenta novamente.'); };
  const fail = (r, title) => { Sound.play && Sound.play('error'); UI.alert({ title: T(title || 'Não foi possível concluir'), msg: errMsg(r) }); };

  /* ---------- quem ve o que (espelho do server/capps.lua; o servidor decide sempre) ---------- */
  const job = () => (window.System && System.player && System.player.job) || {};
  /* antes de o servidor responder (capps.access): pelo nome do emprego. O escalao nao chega a NUI (thirdparty.js explica). */
  function guessAcc(def) {
    const j = job(), aud = def.audience || {};
    const member = arrOf(aud.jobs).some(x => x && x.name === j.name);
    return { member, staff: member && (aud.onDutyOnly !== true || j.onduty !== false), civil: aud.public !== false, grade: 0, onduty: j.onduty !== false, job: j.name, guess: true };
  }
  const accOf = def => (ACC && ACC[def.id]) || (ACC ? null : guessAcc(def));
  /* por modulo: a resposta do servidor (capps.access.mods) manda; sem ela (palpite antes da resposta, servidor antigo)
     faz-se o espelho das regras do server/capps.lua */
  const modAcc = (acc, m) => (acc && !acc.guess && acc.mods && typeof acc.mods === 'object') ? (acc.mods[m.id] || false) : null;
  const staffMod = (acc, m) => { if (!acc || m.enabled === false || m.staff === false) return false; const x = modAcc(acc, m); if (x !== null) return !!(x && x.staff);
    const jobs = arrOf(m.jobs); if (jobs.length && !acc.guess && !jobs.includes(acc.job)) return false;
    if (m.type === 'duty') return !!acc.member;
    return !!(acc.staff && (acc.guess || (acc.grade || 0) >= (+m.staffMinGrade || 0))); };
  const civilMod = (acc, m) => { if (!acc || m.enabled === false) return false; const x = modAcc(acc, m); if (x !== null) return !!(x && x.civil);
    const o = m.options || {}; return !!(acc.civil && m.civil !== false && !STAFF_ONLY[m.type] && (m.type !== 'records' || o.civilSeesOwn === true) && (m.type !== 'posts' || o.audience !== 'staff')); };
  /* acao da equipa permitida pelo escalao neste modulo (view, reply, status, assign, delete, create). Enquanto o servidor
     nao responde so se mostra o que nao altera nada. */
  function can(W, m, action) {
    if (!W || W.side !== 'staff') return false;
    const acc = accOf(DEFS[W.id]); if (!acc) return false;
    if (acc.guess) return action === 'view';
    const x = modAcc(acc, m);
    if (x && x.can) return !!x.can[action];
    if (x === null) return true;          /* servidor sem a v2: decide ele */
    return false;
  }
  function visible(def) {
    if (!def || def.enabled === false) return false;
    const a = accOf(def); if (!a || !(a.member || a.civil)) return false;
    /* fora da AppShop e sem pre-instalacao ninguem a teria: nao aparece */
    if (def.listed === false && !def.preinstalled) return false;
    return true;
  }

  /* ---------- registo das apps no telemovel ---------- */
  const sigs = {};
  function register(def) {
    const id = appId(def.id);
    const sig = JSON.stringify([def.name, def.icon, def.accent, def.category, def.description, def.subtitle, def.preinstalled, def.listed, SERVER]);
    const cur = App.get(id);
    if (sigs[id] === sig && cur && !cur.hidden) return false;
    sigs[id] = sig;
    App.define(id, {
      name: String(def.name || def.id).slice(0, 40), icon: iconFor(def), category: CATS.includes(def.category) ? def.category : (CATS[0] || 'Serviços públicos'),
      description: def.description || def.subtitle || '', author: SERVER,
      /* external: instalada de origem (defaultInstalled) e "do servidor" na Biblioteca de Apps; a janela nao e um iframe
         (a classe .external sai ao abrir). Fora da AppShop (listed = false) fica como app de origem: sempre instalada. */
      external: true, core: def.listed === false, hidden: false, defaultInstalled: !!def.preinstalled, statusBar: 'auto', capp: def.id,
      open(win) { openWin(win, def.id); },
      resume(win) { const W = WINS[def.id]; if (W) { if (W.stale) { W.stale = false; refreshLive(W); } takePending(W); } },
    });
    return true;
  }
  function unregister(id) {
    const d = App.get(id); if (!d || !d.capp) return false;
    try { System.killApp(id); } catch (e) {}
    d.hidden = true; delete sigs[id];
    if (window.Home && Home.removeApp && System.ready) Home.removeApp(id);
    return true;
  }
  function apply() {
    let changed = false;
    ORDER.forEach(def => { if (visible(def)) { if (register(def)) changed = true; } else if (unregister(appId(def.id))) changed = true; });
    App.ids().concat(Object.keys(App.all ? App.all() : {})).forEach(id => { const d = App.get(id); if (d && d.capp && !DEFS[d.capp] && !d.hidden) { unregister(id); changed = true; } });
    if (changed && window.System && System.ready) Bridge.emit('apps:changed');
    /* janelas abertas: definicao ou acesso diferentes refazem a janela (mudanca rara, vinda do painel ou do emprego) */
    Object.keys(WINS).forEach(id => { const W = WINS[id]; const def = DEFS[id]; if (!def || !visible(def)) { try { System.killApp(appId(id)); } catch (e) {} return; }
      const s = JSON.stringify([def, accOf(def)]); if (s !== W.sig) build(W, true); });
    badges();
  }

  function loadDefs(v) {
    if (!v || typeof v !== 'object') return;
    if (v.rev != null && v.rev === REV) return; REV = v.rev;
    const list = arrOf(v.apps).filter(a => a && typeof a.id === 'string' && /^[a-z0-9_]{2,32}$/.test(a.id));
    DEFS = {}; ORDER = []; list.forEach(a => { a.modules = arrOf(a.modules).filter(m => m && typeof m.id === 'string'); a.modules.forEach(m => { m.options = m.options && typeof m.options === 'object' ? m.options : {}; }); a.audience = a.audience || {}; DEFS[a.id] = a; ORDER.push(a); });
    const cats = arrOf(v.categories).filter(c => typeof c === 'string'); if (cats.length) CATS = cats;
    if (typeof v.server === 'string' && v.server) SERVER = v.server;
    apply();
    if (window.System && System.ready) refreshAccess();
  }
  let accSeq = 0;
  async function refreshAccess() {
    const my = ++accSeq; const r = await rpc('capps.access', {});
    if (my !== accSeq || !r || r.error) return;
    ACC = r.apps && typeof r.apps === 'object' && !Array.isArray(r.apps) ? r.apps : {};
    apply();
  }
  /* emblema no icone (equipa): o que espera resposta (novos, pendentes, a espera) */
  let badgeT = null;
  function badges() { clearTimeout(badgeT); badgeT = setTimeout(async () => { if (!window.System || !System.ready || !System.badge) return;
    for (const def of ORDER) { const a = accOf(def); if (!visible(def) || !a || !a.staff || a.guess) { System.badge(appId(def.id), 0); continue; }
      const r = await rpc('capps.counts', { app: def.id }); if (!r || r.error) continue; const c = r.counts || {}; let n = 0; Object.keys(c).forEach(k => { n += +c[k] || 0; });
      System.badge(appId(def.id), n); const W = WINS[def.id]; if (W && W.tabs && W.mods) W.mods.forEach((m, i) => { if (i < W.tabCount) W.tabs.badge(i, W.side === 'staff' ? (+c[m.id] || 0) : 0); }); } }, 400); }

  /* ---------- janela da app ---------- */
  function openWin(win, id) {
    win.classList.remove('external'); win.classList.add('cap-win');
    /* Nova UI: a app de trabalho e do sistema do servidor - barras, listas e separadores Nova UI, como as apps de origem */
    if (isA()) win.classList.add('ou-app');
    const W = { win, id, side: SIDE[id] || null, mods: [], tabs: null, live: null, details: new Set(), stale: false, sig: '' };
    WINS[id] = W;
    win.onClose = () => { if (WINS[id] === W) delete WINS[id]; };
    build(W, false);
    takePending(W);
  }
  function paint(W, def) { paintEl(W.win, def); }
  /* as folhas (UI.sheet) vivem fora da janela: levam as mesmas variaveis e a classe .cap-tint para terem a cor da app */
  function tint(el, def) { if (!el || !def) return; paintEl(el, def); el.classList.add('cap-tint'); }
  function paintEl(el, def) {
    const c = colors(def), acc = hexOk(def.accent) || c.bg;
    const s = el.style;
    s.setProperty('--cap-acc', acc);
    s.setProperty('--cap-tx-l', lum(acc) > .62 ? mix(acc, '#000000', .45) : acc);
    s.setProperty('--cap-tx-d', lum(acc) < .3 ? mix(acc, '#ffffff', .45) : acc);
    s.setProperty('--cap-soft-l', rgba(acc, .11)); s.setProperty('--cap-soft-d', rgba(acc, .2));
    s.setProperty('--cap-ink', lum(acc) > .7 ? '#111111' : '#FFFFFF');
    s.setProperty('--cap-g1', c.bg); s.setProperty('--cap-g2', c.bg2);
  }
  const SPLIT = { icon: 'cap_document', title: 'Nada aberto', sub: 'Escolhe um registo da lista para o ver aqui.', row: '.cap-row' };
  /* dobravel aberto: lista | detalhe so nos modulos com listas; a pagina (info), a equipa e o pedido rapido ocupam a largura toda */
  function setSplit(W, on) {
    const win = W.win;
    if (on) { if (!win._split) UI.split(win, Object.assign({}, SPLIT, { title: T(SPLIT.title), sub: T(SPLIT.sub) })); return; }
    if (!win._split) return;
    delete win._split; win.classList.remove('has-split', 'split-on');
    const st = win.querySelector(':scope > .nav-stack'); if (st) st.classList.remove('split');
    if (win._splitPh) { win._splitPh.remove(); win._splitPh = null; }
  }
  function sideMods(def, acc, side) { return def.modules.filter(m => side === 'staff' ? staffMod(acc, m) : civilMod(acc, m)); }
  function build(W, keep) {
    const def = DEFS[W.id]; const win = W.win; if (!def) return;
    const acc = accOf(def) || {};
    W.sig = JSON.stringify([def, acc]);
    paint(W, def);
    const sm = sideMods(def, acc, 'staff'), cm = sideMods(def, acc, 'civil');
    W.canStaff = sm.length > 0; W.canCivil = cm.length > 0; W.offduty = acc.member && !acc.staff;
    if (!W.side || (W.side === 'staff' && !W.canStaff) || (W.side === 'civil' && !W.canCivil)) W.side = W.canStaff ? 'staff' : 'civil';
    SIDE[W.id] = W.side;
    const mods = W.side === 'staff' ? sm : cm;
    const prev = keep && W.live ? W.live.mod : null;
    W.mods = mods; W.live = null; W.details.clear();
    const old = win.querySelector(':scope > .tabbar'); if (old) old.remove();
    win.classList.remove('tb-win', 'tb-vis', 'plain-tabbar'); W.tabs = null; win._tbApi = null;
    if (!mods.length) { setSplit(W, false); UI.setRoot(win, emptyView(W, def)); return; }
    /* ate 5 separadores; com mais, o 5.o e "Mais" (lista dos restantes) */
    const many = mods.length > 5, shown = many ? mods.slice(0, 4) : mods;
    W.tabCount = shown.length;
    if (mods.length === 1) { UI.setRoot(win, makeView(W, mods[0])); return; }
    const tabs = shown.map(m => ({ icon: 'cap_' + modGlyph(m), label: String(m.title || m.id).slice(0, 18), view: () => makeView(W, m) }));
    if (many) tabs.push({ icon: 'more', label: T('Mais'), view: () => moreView(W, mods.slice(4)) });
    let at = prev ? shown.findIndex(m => m.id === prev) : 0, pushMore = null;
    /* o modulo aberto foi parar ao "Mais" (ex.: entrou em servico e a equipa ganhou os outros separadores): fica nele */
    if (at < 0) { at = 0; const k = prev ? mods.findIndex(m => m.id === prev) : -1; if (many && k >= 4) { at = 4; pushMore = mods[k]; } }
    W.tabs = UI.tabbar(win, tabs, at);
    if (pushMore) setTimeout(() => { if (WINS[W.id] === W && W.win.isConnected) UI.push(win, makeView(W, pushMore, true)); }, 40);
    W.tabs.el.querySelectorAll('.tab span').forEach((s, i) => { if (i < shown.length) s.setAttribute(NI, ''); });
    badges();
  }
  function emptyView(W, def) {
    const v = UI.view({ title: def.name, large: true }); head(W, def, v);
    v.content.appendChild(UI.empty('cap_' + (glyphOk(def.icon && def.icon.glyph) || 'lock'), W.offduty ? T('Fora de serviço') : T('Sem acesso'), W.offduty ? T('Entra em serviço para usar esta app.') : T('Esta app não tem nada disponível para ti.')));
    return v;
  }
  function moreView(W, rest) {
    const def = DEFS[W.id]; setSplit(W, false);
    const v = UI.view({ title: T('Mais'), large: true }); head(W, def, v, true);
    const g = UI.el('<div class="group cap-more"></div>');
    rest.forEach(m => { const r = UI.el(`<div class="li cap-more-li"><div class="cap-tile">${gi(modGlyph(m), 20)}</div><div class="li-body"><div class="li-label" ${NI}>${esc(m.title || m.id)}</div></div><div class="li-chev">${UI.g('chevR')}</div></div>`); r.onclick = () => UI.push(W.win, makeView(W, m, true)); g.appendChild(r); });
    v.content.appendChild(g); return v;
  }

  /* cabecalho de cada vista: o nome da app por cima do titulo grande (PearOS) ou por baixo dele (Nova UI, zona de leitura)
     e o seletor "Cidadão / Equipa" para quem e da equipa */
  function head(W, def, v, noSeg) {
    v.navbar.querySelector('.nb-title').setAttribute(NI, '');
    const lt = v.content.querySelector(':scope > .large-title');
    if (lt) {
      lt.setAttribute(NI, '');
      if (isA()) lt.insertAdjacentHTML('beforeend', `<small ${NI}>${esc(def.name)}${def.subtitle ? ' · ' + esc(def.subtitle) : ''}</small>`);
      else lt.insertAdjacentHTML('beforebegin', `<div class="cap-eyebrow">${miniIcon(def, 20)}<span ${NI}>${esc(def.name)}</span>${def.subtitle ? `<i ${NI}>${esc(def.subtitle)}</i>` : ''}</div>`);
    }
    if (!noSeg && W.canStaff && W.canCivil) {
      const s = UI.seg([T('Cidadão'), T('Equipa')], W.side === 'staff' ? 1 : 0, i => { const want = i === 1 ? 'staff' : 'civil'; if (want === W.side) return; W.side = want; SIDE[W.id] = want; Sound.play && Sound.play('click'); setTimeout(() => build(W, false), 120); });
      s.classList.add('cap-side'); v.content.appendChild(s);
    } else if (!noSeg && W.offduty && W.canCivil) {
      v.content.appendChild(UI.el(`<div class="cap-note">${UI.g('info', 16)}<span>${esc(T('Estás fora de serviço: a área da equipa volta quando entrares em serviço.'))}</span></div>`));
    }
  }
  function navRight(def) {
    const r = [];
    const c = def.contact || {};
    if (c.phone && /^[\w+\-() .#*]{2,20}$/.test(String(c.phone))) r.push({ icon: 'phone', label: T('Ligar'), onTap: () => call(c.phone, c.label || def.name) });
    return r;
  }
  const call = (n, name) => { if (window.PhoneApp && PhoneApp.call) PhoneApp.call(String(n), name ? String(name) : undefined); else UI.toast(T('Não foi possível ligar.')); };
  const message = (n, name) => { if (window.Msgs && Msgs.open) Msgs.open(String(n), name ? String(name) : undefined); else UI.toast(T('Não foi possível abrir as mensagens.')); };
  const waypoint = (x, y, name) => { if (!isFinite(+x) || !isFinite(+y)) return; Bridge.call('setWaypoint', { x: +x, y: +y, name: String(name || '').slice(0, 60) }); Sound.play && Sound.play('tick'); UI.toast(T('Marcado no GPS')); };

  /* vista de um modulo (raiz de um separador, ou empilhada a partir de "Mais") */
  function makeView(W, m, pushed) {
    const def = DEFS[W.id];
    const LISTY = { form: true, appointments: true, dispatch: W.side === 'staff', records: true, posts: true, billing: true, catalog: W.side === 'staff' && m.options.orderable !== false };
    if (!pushed) setSplit(W, !!LISTY[m.type]);
    const v = UI.view({ title: m.title || m.id, large: true, right: navRight(def), back: pushed ? T('Mais') : undefined, cls: 'cap-view cap-v-' + m.type });
    head(W, def, v, pushed);
    const body = UI.el('<div class="cap-body"></div>'); v.content.appendChild(body);
    const R = { form: vForm, appointments: vAppt, dispatch: vDispatch, records: vRecords, posts: vPosts, roster: vRoster, info: vInfo, catalog: vCatalog, billing: vBilling, duty: vDuty }[m.type];
    let live = null;
    try { live = R ? R(W, def, m, v, body) : null; } catch (e) { console.error('[apex_phone] capps vista', m.type, e); }
    /* PearOS: os botoes da barra flutuam ao lado do nome da app; com dois ou mais o subtitulo corta antes deles */
    const nbn = v.navbar.querySelectorAll('.nb-right > .nb-btn').length, eb = v.content.querySelector('.cap-eyebrow');
    if (eb && nbn > 1) eb.style.setProperty('--cap-eb-pr', (24 + nbn * 50) + 'px');
    if (!pushed) W.live = { mod: m.id, kind: m.type, refresh: live && live.refresh ? live.refresh : null };
    return v;
  }

  /* ---------- pecas comuns ---------- */
  const STC = { pending: '#FF9F0A', confirmed: '#30A46C', cancelled: '#8E8E93', done: '#0A84FF', waiting: '#FF9F0A', accepted: '#0A84FF', open: '#30A46C', archived: '#8E8E93', published: '#0A84FF', paid: '#30A46C', refused: '#FF453A', closed: '#8E8E93' };
  /* rotulos por tipo (marcacao e ficha no feminino, pedido no masculino) */
  const STL = { pending: 'Pendente', confirmed: 'Confirmada', cancelled: 'Cancelada', done: 'Concluída', waiting: 'À espera', accepted: 'Aceite', open: 'Ativa', archived: 'Arquivada', published: 'Publicado' };
  const STL_CALL = { waiting: 'À espera', accepted: 'Aceite', done: 'Concluído', cancelled: 'Cancelado' };
  const STL_BILL = { pending: 'Pendente', paid: 'Paga', refused: 'Recusada', cancelled: 'Anulada' };
  const STL_SHIFT = { open: 'Em serviço', closed: 'Terminado' };
  const stLabel = (kind, st) => (kind === 'call' && STL_CALL[st]) || (kind === 'bill' && STL_BILL[st]) || (kind === 'shift' && STL_SHIFT[st]) || STL[st] || st;
  const DEFAULT_ST = [{ id: 'new', label: 'Nova', color: '#0A84FF' }, { id: 'progress', label: 'Em análise', color: '#FF9F0A' }, { id: 'closed', label: 'Fechada', color: '#8E8E93', closed: true }];
  const DEFAULT_ORDER_ST = [{ id: 'new', label: 'Recebida', color: '#0A84FF' }, { id: 'preparing', label: 'Em preparação', color: '#FF9F0A' }, { id: 'ready', label: 'Pronta', color: '#30A46C' }, { id: 'delivered', label: 'Entregue', color: '#8E8E93', closed: true }, { id: 'cancelled', label: 'Cancelada', color: '#FF453A', closed: true }];
  const customSt = m => arrOf(m.options.statuses).filter(s => s && typeof s.id === 'string');
  const statusesOf = m => { const l = customSt(m); return l.length ? l : (m.type === 'catalog' ? DEFAULT_ORDER_ST : DEFAULT_ST); };
  /* { label, color, admin (texto do painel: nao se traduz), closed } */
  function stInfo(m, kind, st) {
    if (kind === 'form' || kind === 'order') { const s = statusesOf(m).find(x => x.id === st) || { id: st, label: st }; return { label: String(s.label || s.id), color: hexOk(s.color) || '#8E8E93', admin: customSt(m).length > 0, closed: !!s.closed }; }
    if (kind === 'bill') return { label: stLabel(kind, st), color: STC[st] || '#8E8E93', admin: false, closed: st !== 'pending' };
    return { label: stLabel(kind, st), color: STC[st] || '#8E8E93', admin: false, closed: st === 'cancelled' || st === 'done' || st === 'archived' || st === 'closed' };
  }
  const pill = (info, extra = '') => `<span class="cap-pill ${extra}" style="--c:${info.color};--cb:${rgba(info.color, .15)}" ${info.admin ? NI : ''}>${esc(info.admin ? info.label : T(info.label))}</span>`;
  const kindOf = m => ({ form: 'form', appointments: 'appt', dispatch: 'call', records: 'record', posts: 'post', catalog: 'order', billing: 'bill', duty: 'shift' })[m.type];
  /* dinheiro: inteiros sem casas ("12 €"), o resto com duas ("8,50 €"); a moeda e a do catalogo */
  /* o símbolo é o do catálogo (vazio = Config.Currency); a posição e o formato dos números são os do telemóvel (UI.money) */
  const money = (n, cur) => { n = +n || 0; return UI.money(n, { symbol: cur || UI.cur(), int: Number.isInteger(n) }); };
  const fmtMins = n => { n = Math.max(0, Math.round(+n || 0)); const h = Math.floor(n / 60), mm = n % 60; return h ? (mm ? TF('%s h %s min', h, mm) : TF('%s h', h)) : TF('%s min', mm); };
  const ago = ts => UI.timeAgo(+ts || Date.now());
  const sk = () => UI.skeleton('list', 4);
  const section = (t, admin) => UI.el(`<div class="cap-sec" ${admin ? NI : ''}>${esc(admin ? t : T(t))}</div>`);

  /* lista com chave: cada linha so muda (troca de nó) quando os dados dela mudam; nada de innerHTML na lista inteira */
  function keyed(box, render, sigOf) {
    const map = new Map();
    return {
      set(items) {
        const seen = new Set(); let prev = null;
        items.forEach(it => { const k = String(it.id); seen.add(k); const s = sigOf(it); let e = map.get(k);
          if (!e) { e = render(it); e._sig = s; map.set(k, e); }
          else if (e._sig !== s) { const n = render(it); n._sig = s; if (e.classList.contains('split-sel')) n.classList.add('split-sel'); e.replaceWith(n); map.set(k, n); e = n; }
          const want = prev ? prev.nextSibling : box.firstChild; if (want !== e) box.insertBefore(e, want); prev = e; });
        map.forEach((e, k) => { if (!seen.has(k)) { e.remove(); map.delete(k); } });
      },
      get size() { return map.size; },
    };
  }
  const rowSig = it => JSON.stringify([it.status, it.title, it.preview, it.updated, it.assignee_name, it.assigned, it.pinned, it.day, it.time, it.tags, it.total, it.amount, it.billId]);

  /* ---------- construtor de campos (formularios e fichas) ---------- */
  const pad2 = n => String(n).padStart(2, '0');
  const isoDay = d => d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
  const parseDay = s => { const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(s || '')); return m ? new Date(+m[1], +m[2] - 1, +m[3]) : null; };
  const fmtDay = s => { const d = parseDay(s); return d ? UI.fmtDayMonth(d, d.getFullYear() !== new Date().getFullYear()) : String(s || ''); };
  function pickDate(title, cur) { return new Promise(res => {
    let sel = parseDay(cur) || new Date(); let view = new Date(sel.getFullYear(), sel.getMonth(), 1); let done = false;
    const body = UI.el(`<div class="cap-cal"><div class="cap-cal-h"><b></b><span class="cap-cal-nav"><i class="p">${UI.g('chevL')}</i><i class="n">${UI.g('chevR')}</i></span></div><div class="cap-cal-wd"></div><div class="cap-cal-g"></div></div>`);
    const wd = body.querySelector('.cap-cal-wd'); [1, 2, 3, 4, 5, 6, 0].forEach(i => wd.insertAdjacentHTML('beforeend', `<span>${esc(UI.wdNarrow(i))}</span>`));
    const grid = body.querySelector('.cap-cal-g');
    const draw = () => { body.querySelector('b').textContent = UI.monthName(view.getMonth()).replace(/^./, c => c.toUpperCase()) + ' ' + view.getFullYear(); grid.innerHTML = '';
      const first = (view.getDay() + 6) % 7, n = new Date(view.getFullYear(), view.getMonth() + 1, 0).getDate(), today = isoDay(new Date());
      for (let i = 0; i < first; i++) grid.appendChild(UI.el('<span class="x"></span>'));
      for (let d = 1; d <= n; d++) { const dt = new Date(view.getFullYear(), view.getMonth(), d), k = isoDay(dt); const c = UI.el(`<span class="${k === isoDay(sel) ? 'on' : ''} ${k === today ? 'td' : ''}">${d}</span>`); c.onclick = () => { sel = dt; draw(); }; grid.appendChild(c); } };
    body.querySelector('.p').onclick = () => { view = new Date(view.getFullYear(), view.getMonth() - 1, 1); draw(); };
    body.querySelector('.n').onclick = () => { view = new Date(view.getFullYear(), view.getMonth() + 1, 1); draw(); };
    draw();
    UI.sheet({ title, left: T('Cancelar'), right: T('OK'), body, cls: 'cap-sheet', onDone: () => { done = true; res(isoDay(sel)); }, onClose: () => { if (!done) res(undefined); } });
  }); }
  /* hora (HH:MM): duas colunas, horas e minutos de 5 em 5, como o seletor de horas do sistema */
  function pickTime(title, cur) { return new Promise(res => {
    const m0 = /^(\d{2}):(\d{2})$/.exec(String(cur || '')); let h = m0 ? +m0[1] : new Date().getHours(), mi = m0 ? +m0[2] - (+m0[2] % 5) : 0; let done = false;
    const body = UI.el(`<div class="cap-tp"><div class="cap-tp-big"><b></b></div><div class="cap-tp-cols"><div class="cap-tp-c h"></div><div class="cap-tp-c m"></div></div></div>`);
    const big = body.querySelector('b'), ch = body.querySelector('.h'), cm = body.querySelector('.m');
    const show = () => { big.textContent = pad2(h) + ':' + pad2(mi); ch.querySelectorAll('span').forEach(s => s.classList.toggle('on', +s.dataset.v === h)); cm.querySelectorAll('span').forEach(s => s.classList.toggle('on', +s.dataset.v === mi)); };
    for (let i = 0; i < 24; i++) { const s = UI.el(`<span data-v="${i}">${pad2(i)}</span>`); s.onclick = () => { h = i; show(); }; ch.appendChild(s); }
    for (let i = 0; i < 60; i += 5) { const s = UI.el(`<span data-v="${i}">${pad2(i)}</span>`); s.onclick = () => { mi = i; show(); }; cm.appendChild(s); }
    show(); setTimeout(() => { [ch, cm].forEach(c => { const on = c.querySelector('.on'); if (on) c.scrollTop = Math.max(0, on.offsetTop - c.clientHeight / 2 + on.offsetHeight / 2); }); }, 30);
    UI.sheet({ title, left: T('Cancelar'), right: T('OK'), body, cls: 'cap-sheet', onDone: () => { done = true; res(pad2(h) + ':' + pad2(mi)); }, onClose: () => { if (!done) res(undefined); } });
  }); }

  /* ---------- construtor de campos v2 (formularios, fichas, formulario da encomenda) ----------
     tipos: text textarea number select multiselect checkbox date time phone plate email url rating photo + section/info
     (titulo de grupo e texto fixo, sem valor). min/max = intervalo do numero, comprimento do texto, n.o de escolhas;
     default = valor de partida; help = texto de ajuda por baixo; showIf = { key, equals }: o campo so aparece (e so e
     obrigatorio) quando o outro campo vale `equals` ('true'/'false' nas caixas; nas escolhas multiplas, "contem"). */
  const FTYPES = ['text', 'textarea', 'number', 'select', 'multiselect', 'checkbox', 'date', 'time', 'phone', 'plate', 'email', 'url', 'rating', 'photo', 'section', 'info'];
  const FMAX = { text: 200, textarea: 1500, select: 100, date: 10, time: 5, phone: 20, plate: 8, email: 120, url: 400, photo: 400, number: 16 };
  const optList = f => arrOf(f.options).map(o => { const v = typeof o === 'object' && o ? String(o.value != null ? o.value : (o.id != null ? o.id : o.label)) : String(o); const l = typeof o === 'object' && o ? String(o.label != null ? o.label : v) : String(o); return { v, l }; });
  const numOr = (x, d) => (x === '' || x == null || !isFinite(+x)) ? d : +x;
  /* foto da galeria: so serve uma ligacao https (as fotos so locais ficam no telemovel e o servidor recusa-as) */
  async function galleryUrl(title) {
    if (!window.Photos || !Photos.pick) { UI.toast(T('Fotos indisponíveis')); return null; }
    const p = await Photos.pick(title); if (!p) return null;
    let url = typeof p.url === 'string' ? p.url : null;
    if (!url && Photos.data) { try { url = await Photos.data(p, true); } catch (e) { url = null; } }
    if (typeof url === 'string' && /^https:\/\//i.test(url)) return url;
    UI.toast(T('Esta foto não tem uma ligação https. Cola a ligação da imagem.')); return null;
  }
  function fieldEl(f, val, onChange) {
    const type = FTYPES.includes(f.type) ? f.type : 'text';
    const label = String(f.label || f.key || '');
    const ch = () => { if (onChange) onChange(); };
    if (type === 'section') return { el: UI.el(`<div class="cap-fsec" ${NI}><b>${esc(label)}</b>${f.help ? `<span>${esc(String(f.help).slice(0, 200))}</span>` : ''}</div>`), key: f.key, label, type, f, section: true, get: () => null };
    if (type === 'info') return { el: UI.el(`<div class="cap-f cap-f-info" ${NI}><i>${UI.g('info', 18)}</i><div>${label ? `<b>${esc(label)}</b>` : ''}${(f.help || f.placeholder) ? `<span>${esc(String(f.help || f.placeholder).slice(0, 500))}</span>` : ''}</div></div>`), key: f.key, label, type, f, fixed: true, get: () => null };
    if (val === undefined && f.default !== undefined && f.default !== null && f.default !== '') val = f.default;
    const wrap = UI.el(`<div class="cap-f cap-f-${type}" ${NI}><div class="cap-f-l">${esc(label)}${f.required ? '<em>*</em>' : ''}</div><div class="cap-f-in"></div>${f.help ? `<div class="cap-f-help">${esc(String(f.help).slice(0, 200))}</div>` : ''}</div>`);
    const box = wrap.querySelector('.cap-f-in'); const ph = f.placeholder ? esc(String(f.placeholder).slice(0, 80)) : '';
    const hi = numOr(f.max, null), maxLen = Math.min(FMAX[type] || 200, (hi != null && ['text', 'textarea', 'email', 'url', 'phone', 'plate'].includes(type)) ? Math.max(1, hi) : 1e9);
    let get = () => null;
    if (type === 'textarea') { const t = UI.el(`<textarea class="ta cap-ta" rows="3" maxlength="${maxLen}" placeholder="${ph}"></textarea>`); t.value = val == null ? '' : String(val); box.appendChild(t); const fit = () => { t.style.height = 'auto'; t.style.height = Math.min(220, t.scrollHeight + 2) + 'px'; }; t.addEventListener('input', () => { fit(); ch(); }); setTimeout(fit, 0); get = () => t.value.trim(); }
    else if (type === 'select') { const s = UI.el(`<select class="cap-sel"><option value="">${esc(T('Escolher…'))}</option></select>`); optList(f).forEach(o => s.insertAdjacentHTML('beforeend', `<option value="${esc(o.v)}">${esc(o.l)}</option>`)); s.value = val == null ? '' : String(val); const ph2 = () => s.classList.toggle('ph', !s.value); ph2(); s.addEventListener('change', () => { ph2(); ch(); }); box.appendChild(s); box.insertAdjacentHTML('beforeend', `<i class="cap-sel-ic">${UI.g('chevD', 16)}</i>`); get = () => s.value; }
    else if (type === 'multiselect') {
      const sel = new Set(Array.isArray(val) ? val.map(String) : (typeof val === 'string' && val ? val.split(',').map(x => x.trim()) : []));
      const g = UI.el('<div class="cap-ms"></div>');
      optList(f).forEach(o => { const c = UI.el(`<span class="${sel.has(o.v) ? 'on' : ''}"><i>${UI.g('check', 13)}</i>${esc(o.l)}</span>`); c.onclick = () => { if (sel.has(o.v)) sel.delete(o.v); else sel.add(o.v); c.classList.toggle('on', sel.has(o.v)); Sound.play && Sound.play('tick'); ch(); }; g.appendChild(c); });
      box.appendChild(g); wrap.classList.add('cap-f-stack'); get = () => optList(f).map(o => o.v).filter(v => sel.has(v));
    }
    else if (type === 'checkbox') { let on = val === true || val === 'true'; const tg = UI.toggle(on, v => { on = v; ch(); }); box.appendChild(tg); wrap.classList.add('cap-f-row'); get = () => on; }
    else if (type === 'date' || type === 'time') { let cur = val == null ? '' : String(val); const b = UI.el(`<div class="cap-date ${cur ? '' : 'ph'}">${UI.g(type === 'date' ? 'calendar' : 'clock', 18)}<span></span></div>`); const sp = b.querySelector('span');
      const show = () => { sp.textContent = cur ? (type === 'date' ? fmtDay(cur) : cur) : (f.placeholder ? String(f.placeholder) : T(type === 'date' ? 'Escolher data' : 'Escolher hora')); b.classList.toggle('ph', !cur); }; show();
      b.onclick = async () => { const d = type === 'date' ? await pickDate(label, cur) : await pickTime(label, cur); if (d) { cur = d; show(); ch(); } }; box.appendChild(b); get = () => cur; }
    else if (type === 'rating') { let n = Math.max(0, Math.min(5, Math.round(+val || 0))); const g = UI.el('<div class="cap-stars"></div>');
      const draw = () => { [...g.children].forEach((s, i) => { s.classList.toggle('on', i < n); s.innerHTML = UI.g(i < n ? 'starFill' : 'star', 26); }); };
      for (let i = 1; i <= 5; i++) { const s = UI.el('<i></i>'); s.onclick = () => { n = n === i ? 0 : i; draw(); Sound.play && Sound.play('tick'); ch(); }; g.appendChild(s); }
      draw(); box.appendChild(g); get = () => n || null; }
    else if (type === 'photo') { let cur = typeof val === 'string' ? val : '';
      const g = UI.el(`<div class="cap-ph"><div class="cap-ph-img"></div><div class="cap-ph-b"><input type="text" class="cap-in" maxlength="400" placeholder="${ph || 'https://'}"><div class="cap-mini-btn">${UI.g('photo', 15)}<span>${esc(T('Galeria'))}</span></div></div></div>`);
      const img = g.querySelector('.cap-ph-img'), inp = g.querySelector('input');
      const show = () => { const ok = /^https:\/\//i.test(cur); img.innerHTML = ok ? `<img src="${esc(cur)}" alt="">` : UI.g('image', 22); img.classList.toggle('has', ok); };
      inp.value = cur; show(); inp.addEventListener('input', () => { cur = inp.value.trim(); show(); ch(); });
      g.querySelector('.cap-mini-btn').onclick = async () => { const u = await galleryUrl(label); if (u) { cur = u; inp.value = u; show(); ch(); } };
      box.appendChild(g); wrap.classList.add('cap-f-stack'); get = () => cur.trim(); }
    else { const it = type === 'phone' ? 'tel' : 'text'; const im = { number: 'decimal', email: 'email', url: 'url', phone: 'tel' }[type];
      const i = UI.el(`<input type="${it}" class="cap-in ${type === 'plate' ? 'cap-plate' : ''}" maxlength="${maxLen}" placeholder="${ph || (type === 'url' ? 'https://' : '')}" ${im ? `inputmode="${im}"` : ''} autocomplete="off" spellcheck="false">`); i.value = val == null ? '' : String(val);
      if (type === 'plate') i.addEventListener('input', () => { const p = i.selectionStart; i.value = i.value.toUpperCase().replace(/[^A-Z0-9 -]/g, ''); try { i.setSelectionRange(p, p); } catch (e) {} });
      i.addEventListener('input', ch);
      box.appendChild(i); get = () => { const v = i.value.trim(); if (type === 'number') { if (v === '') return null; const n = Number(v.replace(',', '.')); return isFinite(n) ? n : NaN; } return v; }; }
    return { el: wrap, key: f.key, label, required: !!f.required, type, f, get };
  }
  /* visivel/escondido pelo showIf (a mesma regra do server/capps.lua) */
  const cmpTxt = v => v == null || v === '' ? null : (typeof v === 'boolean' ? (v ? 'true' : 'false') : String(v));
  function visOf(list, vals) {
    const by = {}; list.forEach(f => { by[f.key] = f; }); const memo = {};
    const vis = (f, d) => { if (f.key in memo) return memo[f.key]; const s = f.showIf; let r = true;
      if (s && typeof s === 'object' && typeof s.key === 'string' && s.key !== f.key && by[s.key] && d < 8) { const ref = by[s.key];
        if (!vis(ref, d + 1)) r = false;
        else { const want = s.equals == null ? '' : String(s.equals); const v = vals[s.key];
          if (Array.isArray(v)) r = v.map(String).includes(want);
          else { let t = cmpTxt(v); if (t == null && ref.type === 'checkbox') t = 'false'; r = (t || '') === want; } } }
      memo[f.key] = r; return r; };
    const out = {}; list.forEach(f => { out[f.key] = vis(f, 0); }); return out;
  }
  function formOf(fields, values) {
    const list = arrOf(fields).filter(f => f && typeof f.key === 'string' && f.key);
    const root = UI.el('<div class="cap-formwrap"></div>');
    const els = []; let grp = null;
    const vals = () => { const o = {}; els.forEach(x => { if (!x.section && !x.fixed) o[x.key] = x.get(); }); return o; };
    /* so os campos que mudam de estado mexem; o primeiro visivel de cada grupo perde a linha de cima; um grupo sem nada
       visivel esconde-se (e a secao que o abre tambem, quando e ela a estar escondida) */
    let ready = false;
    const sync = () => { if (!ready) return; const vm = visOf(list, vals());
      els.forEach(x => { const on = vm[x.key] !== false; if (x.el.hidden === on) { x.el.hidden = !on; if (on) { x.el.classList.remove('cap-reveal'); void x.el.offsetWidth; x.el.classList.add('cap-reveal'); } } });
      root.querySelectorAll(':scope > .cap-form').forEach(g => { let first = true; [...g.children].forEach(c => { c.classList.toggle('cap-first', !c.hidden && first); if (!c.hidden) first = false; }); g.hidden = first; }); };
    list.forEach(f => { const x = fieldEl(f, values ? values[f.key] : undefined, sync); els.push(x);
      if (x.section) { root.appendChild(x.el); grp = null; return; }
      if (!grp) { grp = UI.el('<div class="group cap-form"></div>'); root.appendChild(grp); }
      grp.appendChild(x.el); });
    ready = true; sync();
    const bad = (x, msg) => ({ error: msg, el: x.el });
    const read = () => { const vm = visOf(list, vals()); const out = {};
      for (const x of els) {
        if (x.section || x.fixed || vm[x.key] === false) continue;
        const v = x.get(); const lo = numOr(x.f.min, null), hi = numOr(x.f.max, null);
        if (x.type === 'number' && Number.isNaN(v)) return bad(x, TF('O campo "%s" tem de ser um número.', x.label));
        const empty = v == null || v === '' || v === false || (Array.isArray(v) && !v.length);
        if (x.required && empty) return bad(x, TF('Preenche o campo "%s".', x.label));
        if (empty) continue;
        if (x.type === 'email' && !/^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i.test(v)) return bad(x, TF('O campo "%s" tem de ser um email.', x.label));
        if ((x.type === 'url' || x.type === 'photo') && !/^https:\/\/\S+$/i.test(v)) return bad(x, TF('O campo "%s" tem de começar por https://', x.label));
        if (x.type === 'time' && !/^([01]\d|2[0-3]):[0-5]\d$/.test(v)) return bad(x, TF('O campo "%s" tem de ser uma hora.', x.label));
        const n = x.type === 'number' ? v : x.type === 'multiselect' ? v.length : ['text', 'textarea', 'email', 'url', 'phone', 'plate'].includes(x.type) ? [...String(v)].length : null;
        if (n != null && ((lo != null && n < lo) || (hi != null && n > hi))) {
          if (x.type === 'number') return bad(x, lo != null && hi != null ? TF('O campo "%s" tem de estar entre %s e %s.', x.label, lo, hi) : lo != null ? TF('O campo "%s" tem de ser pelo menos %s.', x.label, lo) : TF('O campo "%s" pode ir até %s.', x.label, hi));
          if (x.type === 'multiselect') return bad(x, lo != null && n < lo ? TF('Escolhe pelo menos %s opções em "%s".', lo, x.label) : TF('Escolhe no máximo %s opções em "%s".', hi, x.label));
          return bad(x, lo != null && n < lo ? TF('O campo "%s" precisa de pelo menos %s caracteres.', x.label, lo) : TF('O campo "%s" aceita no máximo %s caracteres.', x.label, hi));
        }
        out[x.key] = v; }
      return { values: out }; };
    return { el: root, read, size: els.filter(x => !x.section && !x.fixed).length };
  }
  const flash = el => { if (!el) return; el.classList.remove('cap-err'); void el.offsetWidth; el.classList.add('cap-err'); try { el.scrollIntoView({ block: 'center', behavior: 'smooth' }); } catch (e) {} };

  /* valores de um formulario (detalhe): rotulo por cima, valor por baixo; as secoes partem os grupos */
  function fieldValHtml(f, v) {
    if (f.type === 'checkbox') return esc(v ? T('Sim') : T('Não'));
    if (f.type === 'date') return esc(fmtDay(v));
    if (f.type === 'select') { const o = optList(f).find(o => o.v === String(v)); return esc(o ? o.l : String(v)); }
    if (f.type === 'multiselect') { const L = optList(f); return `<span class="cap-msv">${arrOf(v).map(x => { const o = L.find(o => o.v === String(x)); return `<i>${esc(o ? o.l : String(x))}</i>`; }).join('')}</span>`; }
    if (f.type === 'rating') { const n = Math.max(0, Math.min(5, +v || 0)); return `<span class="cap-starv">${[1, 2, 3, 4, 5].map(i => UI.g(i <= n ? 'starFill' : 'star', 17)).join('')}</span>`; }
    if (f.type === 'photo' && /^https:\/\//i.test(String(v))) return `<span class="cap-phv"><img src="${esc(String(v))}" alt=""></span>`;
    if (f.type === 'url' && /^https:\/\//i.test(String(v))) return `<span class="cap-urlv" data-url="${esc(String(v))}">${esc(String(v).replace(/^https:\/\//i, ''))}</span>`;
    return esc(String(v));
  }
  function valuesEl(m, data, fieldsOverride) {
    const fields = arrOf(fieldsOverride || m.options.fields); const vals = (data && data.fields) || {};
    const has = f => f && vals[f.key] !== undefined && vals[f.key] !== '' && !(Array.isArray(vals[f.key]) && !vals[f.key].length);
    const box = UI.el('<div class="cap-kvwrap"></div>'); let grp = null, sec = null, n = 0;
    fields.forEach(f => { if (!f) return;
      if (f.type === 'section') { sec = f; grp = null; return; }
      if (!has(f)) return;
      if (!grp) { if (sec && sec.label) box.insertAdjacentHTML('beforeend', `<div class="cap-fsec" ${NI}><b>${esc(String(sec.label))}</b></div>`); sec = null; grp = UI.el('<div class="group cap-kvs"></div>'); box.appendChild(grp); }
      grp.insertAdjacentHTML('beforeend', `<div class="cap-kv cap-kv-${esc(f.type || 'text')}"><span ${NI}>${esc(f.label || f.key)}</span><b ${NI} class="${f.type === 'plate' ? 'cap-plate-v' : ''}">${fieldValHtml(f, vals[f.key])}</b></div>`); n++; });
    if (!n) return null;
    box.querySelectorAll('.cap-urlv').forEach(e => { e.onclick = () => { if (System.openURL) System.openURL(e.dataset.url); }; });
    return box;
  }

  /* detalhe: o titulo so passa para a barra quando o grande sai de vista (como no PearOS) */
  function scrollTitle(v) { const nb = v.navbar; nb.classList.remove('show-title'); v.content.addEventListener('scroll', () => { const on = v.content.scrollTop > 70; if (nb.classList.contains('show-title') !== on) nb.classList.toggle('show-title', on); }, { passive: true }); }

  /* ---------- botoes de acao do detalhe (circulo com glifo + rotulo, como nos Contactos) ---------- */
  function actBar(list) {
    const a = list.filter(Boolean); if (!a.length) return null;
    const bar = UI.el(`<div class="cap-acts n${a.length}"></div>`);
    a.forEach(b => { const e = UI.el(`<div class="cap-act ${b.on ? 'on' : ''} ${b.danger ? 'danger' : ''} ${b.dis ? 'dis' : ''}"><i>${b.glyph ? gi(b.glyph, 22) : UI.g(b.icon, 22)}</i><span>${esc(T(b.label))}</span></div>`); e.onclick = () => { if (!b.dis) b.onTap(e); }; bar.appendChild(e); });
    return bar;
  }

  /* ---------- conversa / notas ---------- */
  function thread(notes, opts) {
    const box = UI.el('<div class="cap-thread"></div>');
    const k = keyed(box, n => { const own = n.mine; const cls = n.private ? 'priv' : (n.staff ? 'staff' : 'civil');
      return UI.el(`<div class="cap-msg ${cls} ${own ? 'me' : ''}"><div class="cap-msg-h">${n.private ? UI.g('lock', 12) + `<span>${esc(T('Nota interna'))}</span> · ` : ''}<b ${NI}>${esc(n.author_name || (n.staff ? T('Equipa') : T('Cidadão')))}</b><span>${esc(ago(n.created))}</span></div><div class="cap-msg-t" ${NI}>${esc(n.text)}</div></div>`); }, n => String(n.id));
    const emptyEl = UI.el(`<div class="cap-thread-empty">${esc(T(opts.empty || 'Ainda sem mensagens.'))}</div>`);
    const set = list => { k.set(list); if (!list.length) box.appendChild(emptyEl); else emptyEl.remove(); };
    set(notes || []);
    return { el: box, set };
  }
  function composer(opts) {
    /* opts: { modes: [{ id, label, private }], placeholder, onSend(text, private) -> Promise<bool> } */
    const el = UI.el(`<div class="cap-comp">${opts.modes.length > 1 ? '<div class="cap-comp-m"></div>' : ''}<div class="cap-comp-r"><textarea class="ta" rows="1" maxlength="1000" placeholder="${esc(T(opts.placeholder || 'Escreve uma mensagem'))}"></textarea><div class="cap-send">${UI.g('arrowUp', 20)}</div></div></div>`);
    let mode = opts.modes[0];
    if (opts.modes.length > 1) { const s = UI.seg(opts.modes.map(x => T(x.label)), 0, i => { mode = opts.modes[i]; el.classList.toggle('priv', !!mode.private); }); el.querySelector('.cap-comp-m').appendChild(s); }
    el.classList.toggle('priv', !!mode.private);
    const ta = el.querySelector('textarea'), btn = el.querySelector('.cap-send');
    const fit = () => { ta.style.height = 'auto'; ta.style.height = Math.min(140, ta.scrollHeight) + 'px'; btn.classList.toggle('on', !!ta.value.trim()); };
    ta.addEventListener('input', fit);
    let busy = false;
    btn.onclick = async () => { const t = ta.value.trim(); if (!t || busy) return; busy = true; btn.classList.add('busy'); const ok = await opts.onSend(t, !!mode.private); busy = false; btn.classList.remove('busy'); if (ok) { ta.value = ''; fit(); } };
    return el;
  }

  /* ---------- carregamento paginado de uma lista ---------- */
  function pagedList(W, m, side, opts) {
    /* opts: { box, render, empty: [glyph, title, sub], params: () => ({}) , onItems } */
    const holder = UI.el('<div class="cap-list"></div>');
    const grp = UI.el('<div class="group cap-rows"></div>'); const more = UI.el(`<div class="cap-more-btn">${esc(T('Carregar mais'))}</div>`);
    const emptyBox = UI.el('<div class="cap-empty"></div>');
    holder.append(grp, more, emptyBox); more.hidden = true; grp.hidden = true;
    const k = keyed(grp, opts.render, rowSig);
    let items = [], page = 0, pages = 1, seq = 0, first = true;
    const skel = sk(); holder.insertBefore(skel, grp);
    const load = async (reset) => {
      const my = ++seq;
      const want = reset ? 0 : page + 1;
      const r = await rpc('capps.list', Object.assign({ app: W.id, module: m.id, side, page: reset ? 0 : want }, opts.params ? opts.params() : {}));
      if (my !== seq) return;
      if (skel.isConnected) skel.remove();
      if (!r || r.error) { if (first) { emptyBox.innerHTML = ''; emptyBox.appendChild(UI.empty('info', T('Não foi possível carregar'), errMsg(r))); } return; }
      first = false;
      const got = arrOf(r.items);
      if (reset) { /* recarregar mantendo as paginas ja vistas: pede so a primeira e junta por baixo o resto que ja se tinha */
        const tail = page > 0 ? items.slice(got.length).filter(x => !got.some(g => g.id === x.id)) : [];
        items = got.concat(tail);
      } else { items = items.concat(got.filter(x => !items.some(i => i.id === x.id))); page = +r.page || want; }
      pages = +r.pages || 1;
      k.set(items); grp.hidden = !items.length; more.hidden = !(page < pages - 1);
      emptyBox.innerHTML = ''; if (!items.length) emptyBox.appendChild(UI.empty('cap_' + opts.empty[0], T(opts.empty[1]), T(opts.empty[2] || '')));
      if (opts.onItems) opts.onItems(items);
    };
    more.onclick = () => load(false);
    load(true);
    return { el: holder, reload: () => load(true), reset: () => { items = []; page = 0; load(true); }, get items() { return items; } };
  }

  /* linha de uma lista (formularios, pedidos, fichas, marcacoes) */
  function itemRow(W, m, it, lead) {
    const kind = kindOf(m); const st = stInfo(m, kind, it.status);
    const who = it.anonymous ? T('Anónimo') : (it.owner_name || '');
    const r = UI.el(`<div class="cap-row ${st.closed ? 'closed' : ''}" data-id="${+it.id}">
      ${lead || `<div class="cap-dot" style="--c:${st.color}"></div>`}
      <div class="cap-row-m"><div class="cap-row-t"><b ${NI}>${esc(it.title || '')}</b><span class="cap-row-time">${esc(ago(it.updated || it.created))}</span></div>
      ${it.preview ? `<div class="cap-row-p" ${NI}>${esc(it.preview)}</div>` : ''}
      <div class="cap-row-x">${pill(st)}${who ? `<span class="cap-row-w ${it.anonymous ? 'anon' : ''}" ${it.anonymous ? '' : NI}>${esc(who)}</span>` : ''}${it.assignee_name && W.side === 'staff' && kind !== 'record' ? `<span class="cap-row-a">${UI.g('person', 12)}<span ${NI}>${esc(it.assigned ? T('Eu') : it.assignee_name)}</span></span>` : ''}</div></div></div>`);
    return r;
  }

  /* ===================== MODULO: FORMULARIO ===================== */
  function vForm(W, def, m, v, body) {
    const o = m.options;
    if (W.side === 'staff') {
      const sts = statusesOf(m);
      const F = [{ id: 'open', label: 'Abertos' }, { id: 'all', label: 'Todos' }, { id: 'mine', label: 'Atribuídos a mim' }].concat(sts.map(s => ({ id: s.id, label: s.label, admin: true })));
      let filter = 'open', q = '';
      const search = UI.search(T('Pesquisar'), t => { q = t; list.reload(); }); search.classList.add('cap-search'); body.appendChild(search);
      const ch = UI.chips(F.map(f => f.admin ? f.label : T(f.label)), 0, i => { filter = F[i].id; list.reset(); }); ch.classList.add('cap-chips');
      [...ch.children].forEach((c, i) => { if (F[i].admin) c.setAttribute(NI, ''); }); body.appendChild(ch);
      const list = pagedList(W, m, 'staff', { render: it => { const r = itemRow(W, m, it); r.onclick = () => openItem(W, m, it.id, 'staff'); return r; }, empty: ['document', 'Sem registos', 'Os envios dos cidadãos aparecem aqui.'], params: () => ({ filter, q }) });
      body.appendChild(list.el);
      return { refresh: () => list.reload() };
    }
    /* cidadao: o formulario e, por baixo, os envios dele */
    if (o.intro) body.appendChild(UI.el(`<div class="cap-intro" ${NI}>${esc(String(o.intro))}</div>`));
    const formBox = UI.el('<div class="cap-formbox"></div>'); body.appendChild(formBox);
    let form = formOf(o.fields); formBox.appendChild(form.el);
    let anon = false, loc = !!o.location, photo = '';
    const extras = [];
    if (o.anonymous) extras.push({ label: T('Enviar como anónimo'), toggle: false, onToggle: x => { anon = x; } });
    if (o.location) extras.push({ label: T('Enviar a minha localização'), toggle: true, onToggle: x => { loc = x; } });
    if (extras.length) { const l = UI.list([{ items: extras }]); l.classList.add('cap-opts'); body.appendChild(l); }
    let photoIn = null;
    if (o.photo) { const pg = UI.el(`<div class="group cap-form"><div class="cap-f"><div class="cap-f-l">${esc(T('Imagem (ligação https)'))}</div><div class="cap-f-in"><input type="text" class="cap-in" maxlength="400" placeholder="https://"></div></div></div>`); photoIn = pg.querySelector('input'); body.appendChild(pg); }
    if (o.anonymous) body.appendChild(UI.el(`<div class="group-footer">${esc(T('Como anónimo, a equipa não vê o teu nome nem o teu número.'))}</div>`));
    const send = UI.el(`<div class="btn-p cap-cta">${esc(o.submitLabel ? String(o.submitLabel) : T('Enviar'))}</div>`); if (o.submitLabel) send.setAttribute(NI, '');
    body.appendChild(send);
    let mine = null;
    if (o.civilSeesOwn !== false) {
      body.appendChild(section('Os teus envios'));
      mine = pagedList(W, m, 'civil', { render: it => { const r = itemRow(W, m, it); r.onclick = () => openItem(W, m, it.id, 'civil'); return r; }, empty: ['document', 'Ainda não enviaste nada', 'O estado dos teus envios e as respostas da equipa aparecem aqui.'] });
      body.appendChild(mine.el);
    }
    let busy = false;
    send.onclick = async () => {
      if (busy) return;
      const r = form.read(); if (r.error) { UI.toast(r.error); flash(r.el); return; }
      if (!Object.keys(r.values).length) { UI.toast(T(ERR.empty)); return; }
      photo = photoIn ? photoIn.value.trim() : '';
      if (photo && !/^https:\/\//i.test(photo)) { UI.toast(T(ERR.photo)); return; }
      busy = true; send.classList.add('dis');
      const coords = loc ? await Bridge.call('getCoords') : null;
      const res = await rpc('capps.create', { app: W.id, module: m.id, side: 'civil', fields: r.values, anonymous: anon, location: loc, coords, photo: photo || undefined });
      busy = false; send.classList.remove('dis');
      if (!res || !res.ok) { fail(res, 'Não foi enviado'); return; }
      Sound.play && Sound.play('success');
      UI.banner({ iconHtml: Icons.tile(appId(W.id)), title: def.name, msg: T('Enviado. Vais ser avisado quando houver novidades.') });
      /* formulario limpo: volta a ser desenhado vazio (so ele; as opcoes e a lista ficam) */
      formBox.innerHTML = ''; form = formOf(o.fields); formBox.appendChild(form.el); if (photoIn) photoIn.value = '';
      if (mine) mine.reload();
    };
    return { refresh: () => { if (mine) mine.reload(); } };
  }

  /* ===================== DETALHE GENERICO (formulario, marcacao, pedido, ficha, encomenda, fatura) =====================
     As acoes da equipa seguem o escalao de cada uma (capps.access: can.status / assign / reply / delete / create): o
     botao que o cargo nao permite nao aparece (o servidor recusa na mesma). */
  async function openItem(W, m, id, side, opts = {}) {
    const def = DEFS[W.id]; const kind = kindOf(m); const o = m.options;
    const canDel = side === 'staff' && can(W, m, 'delete');
    const canSt = side === 'staff' && can(W, m, 'status');
    const right = [];
    if (canDel) right.push({ icon: 'trash', label: T('Apagar'), onTap: async () => {
      const bill = kind === 'bill';
      if (!await UI.confirm(T(bill ? 'Apagar fatura' : 'Apagar registo'), T(bill ? 'Uma fatura ainda por pagar é anulada. Não dá para desfazer.' : 'Isto apaga o registo e as notas. Não dá para desfazer.'), T('Apagar'), true)) return;
      const r = await rpc('capps.delete', { id, side }); if (!r || !r.ok) { fail(r); return; } UI.toast(T('Apagado')); UI.pop(v); refreshLive(W); } });
    if (kind === 'record' && side === 'staff' && can(W, m, 'create')) right.unshift({ label: T('Editar'), onTap: () => editRecord(W, m, cur) });
    const v = UI.view({ title: '', back: m.title || T('Voltar'), right, cls: 'cap-detail' });
    v.navbar.querySelector('.nb-title').setAttribute(NI, ''); scrollTitle(v);
    const nbBack = v.navbar.querySelector('.nb-back span'); if (nbBack) nbBack.setAttribute(NI, '');
    const parts = { head: null, acts: null, body: null };
    const box = UI.el('<div class="cap-dbody"></div>'); v.content.appendChild(box);
    box.appendChild(UI.skeleton('list', 3));
    let cur = null, th = null, comp = null;
    const swap = (k, el) => { if (parts[k] && parts[k].isConnected) { if (el) parts[k].replaceWith(el); else parts[k].remove(); } else if (el) { const order = ['head', 'acts', 'body']; const after = order.slice(0, order.indexOf(k)).map(x => parts[x]).filter(x => x && x.isConnected).pop(); if (after) after.after(el); else box.prepend(el); } parts[k] = el; };
    const setStatus = async st => { const r = await rpc('capps.status', { id, side, status: st }); if (!r || !r.ok) { fail(r); load(); return null; } Sound.play && Sound.play('success'); draw(r.item, null); refreshLive(W); return r; };
    /* faturar a encomenda: com um modulo de faturacao na app, quem o pode usar; sem ele, so com options.billing */
    const billable = () => { const bm = def.modules.find(x => x.type === 'billing' && x.enabled !== false);
      if (bm) { const x = modAcc(accOf(def), bm); return x === null ? side === 'staff' : !!(x && x.staff && x.can && x.can.create); }
      return o.billing === true && canSt; };
    const billOrder = async it => { const d = it.data || {}; const amt = Math.round(+d.total || 0);
      if (!await UI.confirm(T('Faturar encomenda'), TF('Enviar uma fatura de %s a %s?', money(amt), it.owner_name || T('quem encomendou')), T('Faturar'))) return;
      const r = await rpc('capps.bill', { id }); if (!r || !r.ok) { fail(r, 'Fatura não enviada'); if (r && r.error === 'billed') load(); return; }
      Sound.play && Sound.play('success'); UI.toast(T('Fatura enviada')); draw(r.item, null); refreshLive(W); };
    function headEl(it) {
      const st = stInfo(m, kind, it.status); const tap = canSt && kind !== 'post' && kind !== 'bill';
      const meta = [];
      meta.push(esc(TF('Criado %s', UI.rel(it.created))));
      if (side === 'staff' && kind !== 'record') meta.push(it.anonymous ? esc(T('Anónimo')) : `<span ${NI}>${esc(it.owner_name || (kind === 'bill' ? UI.phone(it.owner_phone || '') : ''))}</span>`);
      if (kind === 'record' && it.data && it.data.author) meta.push(`<span ${NI}>${esc(it.data.author)}</span>`);
      if (kind === 'bill' && it.assignee_name) meta.push(`<span ${NI}>${esc(TF('por %s', it.assignee_name))}</span>`);
      const h = UI.el(`<div class="cap-dh"><div class="cap-dh-top">${pill(st, tap ? 'tap' : '')}${it.assignee_name && kind !== 'record' && kind !== 'bill' ? `<span class="cap-dh-as">${UI.g('person', 13)}<span ${NI}>${esc(it.assigned ? T('Atribuído a mim') : it.assignee_name)}</span></span>` : ''}<span class="cap-dh-id">#${+it.id}</span></div>
        <div class="cap-dh-t" ${NI}>${esc(it.title || '')}</div><div class="cap-dh-m">${meta.filter(Boolean).join(' · ')}</div>
        ${kind === 'record' && arrOf(it.tags).length ? `<div class="cap-tags">${arrOf(it.tags).map(t => { const tg = arrOf(o.tags).find(x => x && x.id === t) || { label: t, color: '#8E8E93' }; const c = hexOk(tg.color) || '#8E8E93'; return `<span class="cap-tag" style="--c:${c};--cb:${rgba(c, .15)}" ${NI}>${esc(tg.label || t)}</span>`; }).join('')}</div>` : ''}</div>`);
      if (tap) h.querySelector('.cap-pill').onclick = async () => {
        let opts2 = [];
        if (kind === 'form' || kind === 'order') opts2 = statusesOf(m).map(s => ({ label: customSt(m).length ? String(s.label || s.id) : T(String(s.label || s.id)), value: s.id }));
        else if (kind === 'appt') opts2 = ['pending', 'confirmed', 'done', 'cancelled'].map(s => ({ label: T(STL[s]), value: s }));
        else if (kind === 'call') opts2 = ['accepted', 'done', 'cancelled'].map(s => ({ label: T(stLabel('call', s)), value: s }));
        else if (kind === 'record') opts2 = ['open', 'archived'].map(s => ({ label: T(STL[s]), value: s }));
        const pick = await UI.actionSheet({ title: T('Mudar estado'), buttons: opts2.filter(x => x.value !== it.status) });
        if (pick) setStatus(pick);
      };
      return h;
    }
    function actsEl(it) {
      const ph = it.owner_phone, name = it.owner_name; const hasXY = it.x != null && it.y != null;
      const closed = stInfo(m, kind, it.status).closed;
      if (side === 'civil') {
        if ((kind === 'appt' || kind === 'call') && !closed) return actBar([{ icon: 'xCircle', label: kind === 'appt' ? 'Cancelar marcação' : 'Cancelar pedido', danger: true, onTap: async () => { if (!await UI.confirm(T(kind === 'appt' ? 'Cancelar marcação' : 'Cancelar pedido'), T('A equipa é avisada.'), T('Cancelar'), true)) return; setStatus('cancelled'); } }]);
        if (kind === 'order') { const sts = statusesOf(m); if (sts[0] && it.status === sts[0].id && sts.some(s => s.id === 'cancelled')) return actBar([{ icon: 'xCircle', label: 'Cancelar encomenda', danger: true, onTap: async () => { if (!await UI.confirm(T('Cancelar encomenda'), T('A equipa é avisada.'), T('Cancelar'), true)) return; setStatus('cancelled'); } }]); }
        return null;
      }
      const L = [];
      if (kind === 'call' && canSt) {
        if (it.status === 'waiting') L.push({ icon: 'check', label: 'Aceitar', on: true, onTap: async () => { const r = await setStatus('accepted'); if (r && r.coords) waypoint(r.coords.x, r.coords.y, it.title); } });
        else if (it.status === 'accepted') L.push({ icon: 'checkCircle', label: 'Concluir', on: true, onTap: () => setStatus('done') });
      }
      if (kind === 'appt' && canSt) {
        if (it.status === 'pending') L.push({ icon: 'check', label: 'Confirmar', on: true, onTap: () => setStatus('confirmed') });
        else if (it.status === 'confirmed') L.push({ icon: 'checkCircle', label: 'Concluir', on: true, onTap: () => setStatus('done') });
        if (!closed) L.push({ glyph: 'calendar', label: 'Remarcar', onTap: () => reschedule(W, m, it, () => load()) });
      }
      if (kind === 'record' && canSt) L.push({ icon: it.status === 'archived' ? 'update' : 'storage', label: it.status === 'archived' ? 'Reativar' : 'Arquivar', onTap: () => setStatus(it.status === 'archived' ? 'open' : 'archived') });
      if (kind === 'order' && billable()) L.push({ icon: 'receipt', label: it.billId ? 'Faturada' : 'Faturar', on: !it.billId, dis: !!it.billId, onTap: () => billOrder(it) });
      if (kind === 'bill' && it.status === 'pending' && canSt) L.push({ icon: 'xCircle', label: 'Anular', danger: true, onTap: async () => { if (!await UI.confirm(T('Anular fatura'), T('O cliente deixa de a ver e é avisado.'), T('Anular'), true)) return; setStatus('cancelled'); } });
      if (hasXY) L.push({ icon: 'nav', label: 'GPS', onTap: () => waypoint(it.x, it.y, it.title) });
      if (ph) { L.push({ icon: 'phone', label: 'Ligar', onTap: () => call(ph, name) }); if (kind !== 'record') L.push({ icon: 'message', label: 'Mensagem', onTap: () => message(ph, name) }); }
      if ((kind === 'form' || kind === 'order') && can(W, m, 'assign')) L.push({ icon: 'person', label: it.assigned ? 'Largar' : 'Atribuir', on: !!it.assigned, onTap: async () => { const r = await rpc('capps.assign', { id }); if (!r || !r.ok) { fail(r); return; } draw(r.item, null); refreshLive(W); } });
      return actBar(L.slice(0, 5));
    }
    function bodyEl(it) {
      const b = UI.el('<div class="cap-dsecs"></div>'); const d = it.data || {};
      if (kind === 'form' || kind === 'record') { const kv = valuesEl(m, d); if (kv) b.appendChild(kv); }
      if (kind === 'order') {
        const cur$ = d.currency || o.currency || UI.cur();
        b.appendChild(UI.el(`<div class="group cap-lines">${arrOf(d.lines).map(l => `<div class="cap-ln"><span class="cap-ln-q">${+l.qty || 1}×</span><b ${NI}>${esc(String(l.label || l.id))}</b><em>${esc(money((+l.price || 0) * (+l.qty || 1), cur$))}</em></div>`).join('')}<div class="cap-ln cap-ln-tot"><span></span><b>${esc(T('Total'))}</b><em>${esc(money(d.total, cur$))}</em></div></div>`));
        if (d.billId) b.appendChild(UI.el(`<div class="cap-note">${UI.g('receipt', 16)}<span>${esc(TF('Fatura de %s enviada.', money(d.billAmount || Math.round(+d.total || 0))))}</span></div>`));
        const kv = valuesEl(m, d); if (kv) b.appendChild(kv);
      }
      if (kind === 'bill') {
        b.appendChild(UI.el(`<div class="cap-amount"><span>${esc(T('Valor'))}</span><b>${esc(money(d.amount))}</b>${d.society ? `<em>${esc(T('Paga à conta da empresa'))}</em>` : ''}</div>`));
        const rows = [[T('Cliente'), it.owner_name || '', true], [T('Telefone'), it.owner_phone ? UI.phone(it.owner_phone) : '', true], [T('Motivo'), d.reason || '', true], [T('Emitida por'), it.assignee_name || '', true]].filter(r => r[1]);
        if (rows.length) b.appendChild(UI.el(`<div class="group cap-kvs">${rows.map(([k, x, a]) => `<div class="cap-kv"><span>${esc(k)}</span><b ${a ? NI : ''}>${esc(x)}</b></div>`).join('')}</div>`));
      }
      if (kind === 'appt') { const dd = parseDay(it.day);
        if (dd) b.appendChild(UI.el(`<div class="cap-when"><div class="cap-when-d"><span>${esc(UI.monthName(dd.getMonth(), true))}</span><b>${dd.getDate()}</b></div><div class="cap-when-b"><b>${esc(UI.wdLong(dd))}, ${esc(UI.fmtDayMonth(dd))}</b><span>${esc(it.time || '')}${d.minutes ? ' · ' + esc(TF('%s min', d.minutes)) : ''}</span><em ${NI}>${esc(it.service_label || it.title || '')}</em></div></div>`));
        const rows = [d.notes ? [T('Notas'), d.notes, true] : null, side === 'staff' && it.owner_phone ? [T('Telefone'), UI.phone(it.owner_phone), true] : null].filter(Boolean);
        if (rows.length) b.appendChild(UI.el(`<div class="group cap-kvs">${rows.map(([k, x, a]) => `<div class="cap-kv"><span>${esc(k)}</span><b ${a ? NI : ''}>${esc(x || '--')}</b></div>`).join('')}</div>`)); }
      if (kind === 'call') {
        const rows = [d.message ? [T('Mensagem'), d.message, true] : null].filter(Boolean);
        if (rows.length) b.appendChild(UI.el(`<div class="group cap-kvs">${rows.map(([k, x, a]) => `<div class="cap-kv"><span>${esc(k)}</span><b ${a ? NI : ''}>${esc(x)}</b></div>`).join('')}</div>`));
        if (it.x != null && side === 'staff') { const loc = UI.el(`<div class="cap-loc"><i>${gi('mapPin', 22)}</i><div><b>${esc(T('Localização do pedido'))}</b><span>${Math.round(it.x)}, ${Math.round(it.y)}<em class="cap-dist"></em></span></div></div>`); b.appendChild(loc);
          Promise.resolve(Bridge.call('getCoords')).then(p => { if (p && isFinite(p.x)) { const dkm = Math.hypot(p.x - it.x, p.y - it.y); loc.querySelector('.cap-dist').textContent = ' · ' + (dkm < 1000 ? Math.round(dkm) + ' m' : (dkm / 1000).toFixed(1).replace('.', ',') + ' km'); } }); } }
      if (d.photo) b.appendChild(UI.el(`<div class="cap-photo"><img src="${esc(d.photo)}" alt=""></div>`));
      if ((kind === 'form' || kind === 'order') && it.x != null && side === 'civil') b.appendChild(UI.el(`<div class="cap-note">${UI.g('pin', 16)}<span>${esc(T('Enviado com a tua localização.'))}</span></div>`));
      return b;
    }
    /* que conversa ha: formularios e encomendas com respostas (publicas e internas), fichas com entradas, marcacoes e
       pedidos com notas internas. Sem o escalao de responder a equipa le, mas nao escreve. */
    const reply = side === 'staff' && can(W, m, 'reply');
    const threadMode = () => {
      if (kind === 'bill' || kind === 'post' || kind === 'shift') return null;
      if (kind === 'form' || kind === 'order') { if (side === 'staff') return { title: 'Conversa', modes: !reply ? [] : (o.replies !== false ? [{ id: 'pub', label: 'Resposta' }, { id: 'priv', label: 'Nota interna', private: true }] : [{ id: 'priv', label: 'Nota interna', private: true }]), placeholder: 'Escreve uma resposta' };
        if (o.replies === false) return null; return { title: 'Conversa com a equipa', modes: [{ id: 'pub', label: 'Resposta' }], placeholder: 'Escreve à equipa', closedOk: false }; }
      if (kind === 'record') return side === 'staff' ? { title: 'Histórico', modes: reply ? [{ id: 'pub', label: 'Entrada' }, { id: 'priv', label: 'Interna', private: true }] : [], placeholder: 'Nova entrada no histórico', empty: 'Ainda sem entradas.' } : { title: 'Histórico', modes: [], empty: 'Ainda sem entradas.' };
      if (side === 'staff') return { title: 'Notas da equipa', modes: reply ? [{ id: 'priv', label: 'Nota interna', private: true }] : [], placeholder: 'Nota só para a equipa', empty: 'Sem notas.' };
      return null; };
    function draw(it, notes) {
      cur = it;
      if (box.firstElementChild && box.firstElementChild.classList.contains('skeleton')) box.firstElementChild.remove();
      v.navbar.querySelector('.nb-title').textContent = it.title || '';
      swap('head', headEl(it)); swap('acts', actsEl(it)); swap('body', bodyEl(it));
      const tm = threadMode();
      if (tm && notes) {
        if (!th) { box.appendChild(section(tm.title)); th = thread(notes, tm); box.appendChild(th.el); }
        else th.set(notes);
        const closed = stInfo(m, kind, it.status).closed;
        const canWrite = tm.modes.length && !(side === 'civil' && closed);
        if (canWrite && !comp) { comp = composer({ modes: tm.modes, placeholder: tm.placeholder, onSend: async (t, priv) => { const r = await rpc('capps.note', { id, side, text: t, private: priv }); if (!r || !r.ok) { fail(r, 'Não foi enviado'); return false; } Sound.play && Sound.play('send'); load(); return true; } }); box.appendChild(comp); }
        else if (!canWrite && comp) { comp.remove(); comp = null; }
      }
    }
    async function load() { const r = await rpc('capps.get', { id, side }); if (!v.isConnected) return; if (!r || r.error) { if (!cur) { box.innerHTML = ''; box.appendChild(UI.empty('info', T('Não foi possível abrir'), errMsg(r))); } else if (r && r.error === 'notfound') { UI.toast(T(ERR.notfound)); UI.pop(v); } return; } draw(r.item, arrOf(r.notes)); }
    const det = { id, refresh: load }; W.details.add(det);
    v.opts.onPop = () => W.details.delete(det);
    UI.push(W.win, v); load();
    return v;
  }

  /* remarcar (equipa): dia + horario numa folha */
  async function reschedule(W, m, it, after) {
    const body = UI.el('<div class="cap-resch"></div>');
    let day = it.day, time = null;
    const strip = UI.el('<div class="cap-days"></div>'), slots = UI.el('<div class="cap-slots"></div>');
    body.append(strip, slots);
    const loadDay = async d => { slots.innerHTML = ''; slots.appendChild(UI.spinner()); const r = await rpc('capps.slots', { app: W.id, module: m.id, side: 'staff', day: d }); slots.innerHTML = ''; if (!r || r.error) { slots.appendChild(UI.el(`<div class="cap-thread-empty">${esc(errMsg(r))}</div>`)); return; }
      day = r.day; drawDays(strip, arrOf(r.days), day, x => { loadDay(x); }); drawSlots(slots, arrOf(r.slots), null, t => { time = t; }); };
    loadDay(day);
    UI.sheet({ title: T('Remarcar'), left: T('Cancelar'), right: T('Guardar'), body, cls: 'cap-sheet', onDone: () => { if (!time) { UI.toast(T('Escolhe um horário')); return false; } (async () => { const r = await rpc('capps.update', { id: it.id, side: 'staff', day, time }); if (!r || !r.ok) { fail(r); return; } UI.toast(T('Marcação alterada')); after && after(); refreshLive(W); })(); } });
  }
  function drawDays(strip, days, sel, onPick) {
    strip.innerHTML = '';
    days.forEach(d => { const c = UI.el(`<div class="cap-day ${d.open ? '' : 'off'} ${d.day === sel ? 'on' : ''}"><span>${esc(UI.wdShortI(+d.wd % 7))}</span><b>${+d.d}</b><i>${esc(UI.monthName((+d.m || 1) - 1, true))}</i></div>`); if (d.open) c.onclick = () => { strip.querySelectorAll('.on').forEach(x => x.classList.remove('on')); c.classList.add('on'); onPick(d.day); }; strip.appendChild(c); });
    const on = strip.querySelector('.on'); if (on) setTimeout(() => { strip.scrollLeft = Math.max(0, on.offsetLeft - 16); }, 0);
  }
  function drawSlots(box, slots, sel, onPick) {
    box.innerHTML = '';
    if (!slots.length) { box.appendChild(UI.el(`<div class="cap-thread-empty">${esc(T('Sem horários livres neste dia.'))}</div>`)); return; }
    slots.forEach(s => { const c = UI.el(`<div class="cap-slot ${s.free > 0 ? '' : 'full'} ${s.time === sel ? 'on' : ''}">${esc(s.time)}</div>`); if (s.free > 0) c.onclick = () => { box.querySelectorAll('.on').forEach(x => x.classList.remove('on')); c.classList.add('on'); onPick(s.time); }; box.appendChild(c); });
  }

  /* ===================== MODULO: MARCACOES ===================== */
  function vAppt(W, def, m, v, body) {
    if (W.side === 'staff') {
      let day = null, filter = 'all';
      const strip = UI.el('<div class="cap-days"></div>'); body.appendChild(strip);
      const ch = UI.chips([T('Todas'), T('Pendentes'), T('Confirmadas')], 0, i => { filter = ['all', 'pending', 'confirmed'][i]; list.reset(); }); ch.classList.add('cap-chips'); body.appendChild(ch);
      const lead = it => `<div class="cap-time"><b>${esc(it.time || '')}</b><span>${esc(TF('%s min', (it.data && it.data.minutes) || m.options.slot || 30))}</span></div>`;
      const list = pagedList(W, m, 'staff', { render: it => { const r = itemRow(W, m, Object.assign({}, it, { title: it.owner_name || it.title, preview: it.service_label || it.preview, owner_name: null, anonymous: false }), lead(it)); r.onclick = () => openItem(W, m, it.id, 'staff'); return r; }, empty: ['calendar', 'Sem marcações', 'As marcações deste dia aparecem aqui.'], params: () => ({ filter, day }) });
      body.appendChild(list.el);
      rpc('capps.slots', { app: W.id, module: m.id, side: 'staff' }).then(r => { if (!r || r.error) return; const days = arrOf(r.days); day = isoDay(new Date()); if (!days.some(d => d.day === day)) day = days[0] && days[0].day; drawDays(strip, days.map(d => Object.assign({}, d, { open: true })), day, x => { day = x; list.reset(); }); list.reset(); });
      return { refresh: () => list.reload() };
    }
    /* cidadao: escolher servico, dia e horario; por baixo, as marcacoes dele */
    let svc = null, day = null, time = null;
    const card = UI.el('<div class="cap-book"></div>'); body.appendChild(card);
    const svcBox = UI.el('<div class="group cap-svcs"></div>'), strip = UI.el('<div class="cap-days"></div>'), slots = UI.el('<div class="cap-slots"></div>');
    const notesWrap = UI.el(`<div class="group cap-form"><div class="cap-f"><div class="cap-f-l">${esc(T('Notas (opcional)'))}</div><div class="cap-f-in"><textarea class="ta cap-ta" rows="2" maxlength="300" placeholder="${esc(T('Algo que a equipa deva saber'))}"></textarea></div></div></div>`);
    const go = UI.el(`<div class="btn-p cap-cta dis">${esc(T('Pedir marcação'))}</div>`);
    const sumEl = UI.el('<div class="cap-sum"></div>');
    let svcs = [];
    const upd = () => { go.classList.toggle('dis', !(day && time && (svc || !svcs.length))); sumEl.textContent = day && time ? TF('%s às %s', fmtDay(day), time) : T('Escolhe o dia e a hora'); };
    const loadDay = async d => { slots.innerHTML = ''; slots.appendChild(UI.spinner()); time = null; upd(); const r = await rpc('capps.slots', { app: W.id, module: m.id, side: 'civil', day: d }); slots.innerHTML = '';
      if (!r || r.error) { slots.appendChild(UI.el(`<div class="cap-thread-empty">${esc(errMsg(r))}</div>`)); return; }
      day = r.day; svcs = arrOf(r.services);
      if (!svcBox.childElementCount && svcs.length) { svcs.forEach((s, i) => { const row = UI.el(`<div class="cap-svc ${i === 0 ? 'on' : ''}"><div class="cap-svc-r"></div><div class="cap-svc-b"><b ${NI}>${esc(s.label)}</b><span>${esc(TF('%s min', s.minutes))}</span></div></div>`); row.onclick = () => { svcBox.querySelectorAll('.on').forEach(x => x.classList.remove('on')); row.classList.add('on'); svc = s.id; upd(); }; svcBox.appendChild(row); }); svc = svcs[0].id; }
      if (!svcs.length) svcBox.hidden = true;
      if (r.notes === false) notesWrap.hidden = true;
      drawDays(strip, arrOf(r.days), day, x => loadDay(x)); drawSlots(slots, arrOf(r.slots), null, t => { time = t; upd(); }); upd(); };
    card.append(section('Serviço'), svcBox, section('Dia'), strip, section('Hora'), slots, notesWrap, sumEl, go);
    let busy = false;
    go.onclick = async () => { if (busy || go.classList.contains('dis')) return; busy = true; go.classList.add('dis');
      const r = await rpc('capps.create', { app: W.id, module: m.id, side: 'civil', service: svc, day, time, notes: notesWrap.querySelector('textarea').value.trim() });
      busy = false; upd();
      if (!r || !r.ok) { fail(r, 'Marcação não enviada'); if (r && (r.error === 'full' || r.error === 'slot')) loadDay(day); return; }
      Sound.play && Sound.play('success'); UI.banner({ iconHtml: Icons.tile(appId(W.id)), title: def.name, msg: T('Pedido de marcação enviado. A equipa vai confirmar.') });
      notesWrap.querySelector('textarea').value = ''; loadDay(day); mine.reload(); };
    body.appendChild(section('As tuas marcações'));
    const lead = it => `<div class="cap-time"><b>${esc(it.time || '')}</b><span>${esc(it.day ? fmtDay(it.day) : '')}</span></div>`;
    const mine = pagedList(W, m, 'civil', { render: it => { const r = itemRow(W, m, it, lead(it)); r.onclick = () => openItem(W, m, it.id, 'civil'); return r; }, empty: ['calendar', 'Sem marcações', 'As tuas marcações aparecem aqui.'] });
    body.appendChild(mine.el);
    loadDay(null);
    return { refresh: () => mine.reload() };
  }

  /* ===================== MODULO: PEDIDOS (dispatch) ===================== */
  function typeOf(m, id) { return arrOf(m.options.types).find(t => t && t.id === id) || null; }
  function vDispatch(W, def, m, v, body) {
    const types = arrOf(m.options.types).filter(t => t && typeof t.id === 'string');
    if (W.side === 'staff') {
      const F = [['open', 'Ativos'], ['mine', 'Aceites por mim'], ['closed', 'Fechados'], ['all', 'Todos']]; let filter = 'open';
      const ch = UI.chips(F.map(f => T(f[1])), 0, i => { filter = F[i][0]; list.reset(); }); ch.classList.add('cap-chips'); body.appendChild(ch);
      let me = null; Promise.resolve(Bridge.call('getCoords')).then(p => { if (p && isFinite(p.x)) me = p; });
      const dist = it => { if (!me || it.x == null) return ''; const d = Math.hypot(me.x - it.x, me.y - it.y); return d < 1000 ? Math.round(d) + ' m' : (d / 1000).toFixed(1).replace('.', ',') + ' km'; };
      const lead = it => { const tp = typeOf(m, it.type); const st = stInfo(m, 'call', it.status); return `<div class="cap-tile" style="--c:${st.color};--cb:${rgba(st.color, .15)}">${gi((tp && tp.icon) || 'siren', 20)}</div>`; };
      const list = pagedList(W, m, 'staff', { render: it => { const dd = dist(it); const r = itemRow(W, m, Object.assign({}, it, { preview: [it.preview, dd].filter(Boolean).join(' · ') }), lead(it)); r.onclick = () => openItem(W, m, it.id, 'staff'); return r; }, empty: ['siren', 'Sem pedidos', 'Os pedidos dos cidadãos aparecem aqui em tempo real.'], params: () => ({ filter }) });
      body.appendChild(list.el);
      return { refresh: () => list.reload() };
    }
    /* cidadao: pedido num toque, ou o estado ao vivo do pedido em curso */
    let sel = types[0] ? types[0].id : null;
    const live = UI.el('<div class="cap-live" hidden></div>'); body.appendChild(live);
    const req = UI.el('<div class="cap-req"></div>'); body.appendChild(req);
    if (m.options.intro) req.appendChild(UI.el(`<div class="cap-intro" ${NI}>${esc(String(m.options.intro))}</div>`));
    if (types.length) {
      req.appendChild(section('O que se passa?'));
      const grid = UI.el(`<div class="cap-types n${Math.min(types.length, 4)}"></div>`);
      types.forEach(t => { const e = UI.el(`<div class="cap-type ${t.id === sel ? 'on' : ''}"><i>${gi(t.icon || 'siren', 24)}</i><span ${NI}>${esc(t.label || t.id)}</span></div>`); e.onclick = () => { grid.querySelectorAll('.on').forEach(x => x.classList.remove('on')); e.classList.add('on'); sel = t.id; Sound.play && Sound.play('tick'); }; grid.appendChild(e); });
      req.appendChild(grid);
    }
    const msg = UI.el(`<div class="group cap-form"><div class="cap-f"><div class="cap-f-l">${esc(T('Mensagem (opcional)'))}</div><div class="cap-f-in"><textarea class="ta cap-ta" rows="2" maxlength="200" placeholder="${esc(T('Ex.: perto do posto de gasolina'))}"></textarea></div></div></div>`);
    req.appendChild(msg);
    if (m.options.location !== false) req.appendChild(UI.el(`<div class="cap-note">${UI.g('pin', 16)}<span>${esc(T('A tua localização é enviada com o pedido.'))}</span></div>`));
    const go = UI.el(`<div class="btn-p cap-cta cap-big">${gi(modGlyph(m), 22)}<span>${esc(T('Pedir agora'))}</span></div>`); req.appendChild(go);
    const histTitle = section('Pedidos anteriores'); body.appendChild(histTitle);
    const hist = UI.el('<div class="group cap-rows"></div>'); body.appendChild(hist); histTitle.hidden = hist.hidden = true;
    const hk = keyed(hist, it => { const r = itemRow(W, m, it); r.onclick = () => openItem(W, m, it.id, 'civil'); return r; }, rowSig);
    let openIt = null, seq = 0;
    const drawLive = it => {
      const tp = typeOf(m, it.type); const st = stInfo(m, 'call', it.status);
      const line = it.status === 'waiting' ? T('À espera de resposta') : it.status === 'accepted' ? (it.assignee_name ? TF('%s aceitou e está a caminho', it.assignee_name) : T('Aceite: a caminho')) : T(stLabel('call', it.status));
      live.innerHTML = `<div class="cap-live-ic" style="--c:${st.color};--cb:${rgba(st.color, .16)}">${gi((tp && tp.icon) || 'siren', 30)}</div>
        <div class="cap-live-t" ${NI}>${esc(it.title || '')}</div><div class="cap-live-s"></div>
        <div class="cap-steps"><span class="on"></span><span class="${it.status !== 'waiting' ? 'on' : ''}"></span><span class="${it.status === 'done' ? 'on' : ''}"></span></div>
        <div class="cap-live-lb"><span>${esc(T('Enviado'))}</span><span>${esc(T('Aceite'))}</span><span>${esc(T('Concluído'))}</span></div>
        <div class="cap-live-m">${esc(TF('Pedido %s', UI.timeAgo(it.created) === 'agora' ? T('agora mesmo') : TF('há %s', UI.timeAgo(it.created))))}</div>`;
      live.querySelector('.cap-live-s').textContent = line; if (it.status === 'accepted' && it.assignee_name) live.querySelector('.cap-live-s').setAttribute(NI, '');
      const cancel = UI.el(`<div class="cap-live-x">${esc(T('Cancelar pedido'))}</div>`); cancel.onclick = async () => { if (!await UI.confirm(T('Cancelar pedido'), T('A equipa é avisada.'), T('Cancelar'), true)) return; const r = await rpc('capps.status', { id: it.id, side: 'civil', status: 'cancelled' }); if (!r || !r.ok) { fail(r); } load(); };
      live.appendChild(cancel);
    };
    const load = async () => { const my = ++seq; const r = await rpc('capps.list', { app: W.id, module: m.id, side: 'civil' }); if (my !== seq || !r || r.error) return; const items = arrOf(r.items);
      openIt = items.find(x => x.status === 'waiting' || x.status === 'accepted') || null;
      live.hidden = !openIt; req.hidden = !!openIt; if (openIt) drawLive(openIt);
      const past = items.filter(x => x !== openIt).slice(0, 8); hk.set(past); hist.hidden = histTitle.hidden = !past.length; };
    let busy = false;
    go.onclick = async () => { if (busy) return; if (types.length && !sel) { UI.toast(T(ERR.type)); return; } busy = true; go.classList.add('dis');
      const coords = await Bridge.call('getCoords');
      const r = await rpc('capps.create', { app: W.id, module: m.id, side: 'civil', type: sel, message: msg.querySelector('textarea').value.trim(), coords });
      busy = false; go.classList.remove('dis');
      if (!r || !r.ok) { fail(r, 'Pedido não enviado'); load(); return; }
      Sound.play && Sound.play('success'); msg.querySelector('textarea').value = '';
      if (r.nobody) UI.alert({ title: T('Pedido enviado'), msg: T('Neste momento não há ninguém em serviço. O pedido fica registado e é visto assim que alguém entrar.') });
      load(); };
    load();
    return { refresh: load };
  }

  /* ===================== MODULO: FICHAS ===================== */
  function vRecords(W, def, m, v, body) {
    const o = m.options; const subj = o.subject === 'vehicle' ? 'vehicle' : o.subject === 'free' ? 'free' : 'person';
    const lead = it => subj === 'vehicle' ? `<div class="cap-plate-ic">${esc(String(it.subject || it.title || '').slice(0, 8))}</div>` : subj === 'person' ? UI.avatar({ name: it.subject || it.title, seed: (String(it.subject || '').length * 7) }, 'sm cap-av') : `<div class="cap-tile">${gi('document', 20)}</div>`;
    const render = side => it => { const tags = arrOf(it.tags); const tg = tags.map(t => arrOf(o.tags).find(x => x && x.id === t)).filter(Boolean);
      const r = itemRow(W, m, Object.assign({}, it, { owner_name: null, anonymous: false }), lead(it));
      if (tg.length) { const x = r.querySelector('.cap-row-x'); x.innerHTML = tg.slice(0, 3).map(t => { const c = hexOk(t.color) || '#8E8E93'; return `<span class="cap-tag" style="--c:${c};--cb:${rgba(c, .15)}" ${NI}>${esc(t.label || t.id)}</span>`; }).join('') + (it.status === 'archived' ? pill(stInfo(m, 'record', 'archived')) : ''); }
      else if (it.status !== 'archived') { const p = r.querySelector('.cap-pill'); if (p) p.remove(); }
      r.onclick = () => openItem(W, m, it.id, side); return r; };
    if (W.side === 'staff') {
      if (can(W, m, 'create')) v.navbar.querySelector('.nb-right').appendChild((() => { const b = UI.el(`<div class="nb-btn nb-ico" data-ic="plus" data-lb="${esc(T('Nova ficha'))}">${UI.g('plus')}</div>`); b.onclick = () => editRecord(W, m, null); return b; })());
      let q = '', filter = 'open';
      const search = UI.search(T(subj === 'vehicle' ? 'Pesquisar matrícula' : subj === 'person' ? 'Pesquisar nome' : 'Pesquisar'), t => { q = t; list.reload(); }); search.classList.add('cap-search'); body.appendChild(search);
      const ch = UI.chips([T('Ativas'), T('Arquivadas'), T('Todas')], 0, i => { filter = ['open', 'archived', 'all'][i]; list.reset(); }); ch.classList.add('cap-chips'); body.appendChild(ch);
      const list = pagedList(W, m, 'staff', { render: render('staff'), empty: ['clipboard', 'Sem fichas', 'Toca em + para criar a primeira ficha.'], params: () => ({ q, filter: filter === 'open' ? 'open' : filter === 'archived' ? 'archived' : 'all' }) });
      body.appendChild(list.el);
      return { refresh: () => list.reload() };
    }
    body.appendChild(UI.el(`<div class="cap-intro">${esc(T('As fichas que a equipa tem sobre ti.'))}</div>`));
    const list = pagedList(W, m, 'civil', { render: render('civil'), empty: ['clipboard', 'Sem fichas', 'Não há nenhuma ficha em teu nome.'] });
    body.appendChild(list.el);
    return { refresh: () => list.reload() };
  }
  /* criar / editar uma ficha (equipa) */
  function editRecord(W, m, it) {
    const o = m.options; const subj = o.subject === 'vehicle' ? 'vehicle' : o.subject === 'free' ? 'free' : 'person';
    const v = UI.view({ title: it ? T('Editar ficha') : T('Nova ficha'), back: T('Cancelar'), right: [{ label: it ? T('Guardar') : T('Criar'), bold: true, onTap: () => save() }], cls: 'cap-detail' });
    const g = UI.el('<div class="group cap-form"></div>');
    const sl = subj === 'vehicle' ? 'Matrícula' : subj === 'person' ? 'Nome' : 'Assunto';
    const sf = fieldEl({ key: '_s', label: T(sl), type: subj === 'vehicle' ? 'plate' : 'text', required: true }, it ? it.subject : ''); sf.el.removeAttribute(NI); g.appendChild(sf.el);
    let pf = null; if (subj === 'person' && !it) { pf = fieldEl({ key: '_p', label: T('Telefone do cidadão (opcional)'), type: 'phone', placeholder: '555-0000' }, ''); pf.el.removeAttribute(NI); g.appendChild(pf.el); }
    v.content.appendChild(g);
    if (pf) v.content.appendChild(UI.el(`<div class="group-footer">${esc(T('Com o número, o cidadão vê esta ficha na app (se a secção o permitir).'))}</div>`));
    const tags = arrOf(o.tags).filter(t => t && t.id); const on = new Set(arrOf(it && it.tags));
    if (tags.length) { v.content.appendChild(section('Etiquetas')); const tb = UI.el('<div class="cap-tagpick"></div>'); tags.forEach(t => { const c = hexOk(t.color) || '#8E8E93'; const e = UI.el(`<span class="cap-tag ${on.has(t.id) ? 'on' : ''}" style="--c:${c};--cb:${rgba(c, .15)}" ${NI}>${esc(t.label || t.id)}</span>`); e.onclick = () => { if (on.has(t.id)) on.delete(t.id); else on.add(t.id); e.classList.toggle('on', on.has(t.id)); }; tb.appendChild(e); }); v.content.appendChild(tb); }
    let form = null; if (arrOf(o.fields).length) { v.content.appendChild(section('Dados')); form = formOf(o.fields, it && it.data && it.data.fields); v.content.appendChild(form.el); }
    let busy = false;
    async function save() {
      if (busy) return; const s = sf.get(); if (!s) { UI.toast(T(ERR.subject)); flash(sf.el); return; }
      const fr = form ? form.read() : { values: {} }; if (fr.error) { UI.toast(fr.error); flash(fr.el); return; }
      busy = true;
      const r = it ? await rpc('capps.update', { id: it.id, side: 'staff', subject: s, fields: fr.values, tags: [...on] })
        : await rpc('capps.create', { app: W.id, module: m.id, side: 'staff', subject: s, phone: pf ? pf.get() : undefined, fields: fr.values, tags: [...on] });
      busy = false;
      if (!r || !r.ok) { fail(r, 'Ficha não guardada'); return; }
      Sound.play && Sound.play('success'); UI.pop(v); refreshLive(W);
      if (!it && r.id) setTimeout(() => openItem(W, m, r.id, 'staff'), 380); else W.details.forEach(d => { if (d.id === (it && it.id)) d.refresh(); });
    }
    UI.push(W.win, v);
  }

  /* ===================== MODULO: COMUNICADOS ===================== */
  function vPosts(W, def, m, v, body) {
    const canPost = W.side === 'staff' && can(W, m, 'create');
    if (canPost) v.navbar.querySelector('.nb-right').appendChild((() => { const b = UI.el(`<div class="nb-btn nb-ico" data-ic="compose" data-lb="${esc(T('Novo comunicado'))}">${UI.g('compose')}</div>`); b.onclick = () => composePost(W, m, null); return b; })());
    const card = it => { const e = UI.el(`<div class="cap-row cap-post ${it.pinned ? 'pin' : ''}" data-id="${+it.id}">
      ${it.image ? `<div class="cap-post-img"><img src="${esc(it.image)}" alt="" loading="lazy"></div>` : ''}
      <div class="cap-post-b">${it.pinned ? `<div class="cap-post-pin">${UI.g('pin', 13)}<span>${esc(T('Fixado'))}</span></div>` : ''}<div class="cap-post-t" ${NI}>${esc(it.title || '')}</div>
      ${it.preview ? `<div class="cap-post-p" ${NI}>${esc(it.preview)}</div>` : ''}<div class="cap-post-m"><span ${NI}>${esc(it.assignee_name || def.name)}</span> · <span>${esc(UI.rel(it.created))}</span></div></div></div>`);
      e.onclick = () => openPost(W, m, it.id); return e; };
    const list = pagedList(W, m, W.side, { render: card, empty: ['megaphone', 'Sem comunicados', canPost ? 'Toca no lápis para publicar o primeiro.' : 'Os avisos da equipa aparecem aqui.'] });
    list.el.querySelector('.cap-rows').classList.add('cap-feed');
    body.appendChild(list.el);
    return { refresh: () => list.reload() };
  }
  async function openPost(W, m, id) {
    const def = DEFS[W.id];
    const edit = can(W, m, 'create'), del = can(W, m, 'delete');
    const right = (edit || del) ? [{ icon: 'more', label: T('Mais'), onTap: async b => { if (!cur) return;
      const btns = edit ? [{ label: cur.pinned ? T('Desafixar') : T('Fixar no topo'), value: 'pin' }, { label: T('Editar'), value: 'edit' }] : [];
      if (del) btns.push({ label: T('Apagar'), value: 'del', danger: true });
      const pick = await UI.actionSheet({ buttons: btns });
      if (pick === 'pin') { const r = await rpc('capps.update', { id, side: 'staff', pinned: !cur.pinned }); if (!r || !r.ok) { fail(r); return; } draw(r.item); refreshLive(W); }
      else if (pick === 'edit') composePost(W, m, cur, it => draw(it));
      else if (pick === 'del') { if (!await UI.confirm(T('Apagar comunicado'), T('Deixa de aparecer para toda a gente.'), T('Apagar'), true)) return; const r = await rpc('capps.delete', { id, side: 'staff' }); if (!r || !r.ok) { fail(r); return; } UI.pop(v); refreshLive(W); } } }] : [];
    const v = UI.view({ title: '', back: m.title || T('Voltar'), right, cls: 'cap-detail' });
    v.navbar.querySelector('.nb-title').setAttribute(NI, ''); scrollTitle(v); const nbb = v.navbar.querySelector('.nb-back span'); if (nbb) nbb.setAttribute(NI, '');
    const box = UI.el('<div class="cap-article"></div>'); v.content.appendChild(box); box.appendChild(UI.skeleton('feed', 1));
    let cur = null;
    function draw(it) { cur = it; const d = it.data || {};
      box.innerHTML = `${d.image ? `<div class="cap-post-img big"><img src="${esc(d.image)}" alt=""></div>` : ''}<div class="cap-art-h">${miniIcon(def, 26)}<div><b ${NI}>${esc(d.author || def.name)}</b><span>${esc(UI.fmtDate(new Date(it.created), true))} · ${esc(UI.fmtTime(new Date(it.created)))}</span></div>${it.pinned ? `<em>${UI.g('pin', 13)}${esc(T('Fixado'))}</em>` : ''}</div>
        <h2 ${NI}>${esc(it.title || '')}</h2><div class="cap-art-b" ${NI}>${esc(d.body || '')}</div>`; }
    const load = async () => { const r = await rpc('capps.get', { id, side: W.side }); if (!r || r.error) { box.innerHTML = ''; box.appendChild(UI.empty('info', T('Não foi possível abrir'), errMsg(r))); return; } draw(r.item); };
    const det = { id, refresh: load }; W.details.add(det); v.opts.onPop = () => W.details.delete(det);
    UI.push(W.win, v); load();
  }
  function composePost(W, m, it, after) {
    const body = UI.el('<div class="cap-compose"></div>');
    const g = UI.el(`<div class="group cap-form"><div class="cap-f"><div class="cap-f-in"><input type="text" class="cap-in cap-in-t" maxlength="120" placeholder="${esc(T('Título'))}"></div></div><div class="cap-f"><div class="cap-f-in"><textarea class="ta cap-ta" rows="6" maxlength="2000" placeholder="${esc(T('Escreve o comunicado'))}"></textarea></div></div><div class="cap-f"><div class="cap-f-l">${esc(T('Imagem (ligação https, opcional)'))}</div><div class="cap-f-in"><input type="text" class="cap-in cap-in-i" maxlength="400" placeholder="https://"></div></div></div>`);
    body.appendChild(g);
    let pinned = !!(it && it.pinned);
    body.appendChild(UI.list([{ items: [{ label: T('Fixar no topo'), toggle: pinned, onToggle: x => { pinned = x; } }] }]));
    const ti = g.querySelector('.cap-in-t'), ta = g.querySelector('textarea'), ii = g.querySelector('.cap-in-i');
    if (it) { ti.value = it.title || ''; ta.value = (it.data && it.data.body) || ''; ii.value = (it.data && it.data.image) || ''; }
    UI.sheet({ title: it ? T('Editar comunicado') : T('Novo comunicado'), left: T('Cancelar'), right: it ? T('Guardar') : T('Publicar'), body, cls: 'cap-sheet', onDone: () => {
      const t = ti.value.trim(), b = ta.value.trim(), im = ii.value.trim();
      if (!t || !b) { UI.toast(T('Escreve o título e o texto.')); return false; }
      if (im && !/^https:\/\//i.test(im)) { UI.toast(T(ERR.photo)); return false; }
      (async () => { const r = it ? await rpc('capps.update', { id: it.id, side: 'staff', title: t, body: b, image: im || '', pinned }) : await rpc('capps.create', { app: W.id, module: m.id, side: 'staff', title: t, body: b, image: im || undefined, pinned });
        if (!r || !r.ok) { fail(r, 'Não foi publicado'); return; } Sound.play && Sound.play('success'); UI.toast(it ? T('Comunicado atualizado') : T('Publicado')); if (after && r.item) after(r.item); refreshLive(W); })();
    } });
  }

  /* ===================== MODULO: EQUIPA ===================== */
  function vRoster(W, def, m, v, body) {
    const sum = UI.el('<div class="cap-roster-sum"></div>'); body.appendChild(sum);
    const holder = UI.el('<div></div>'); body.appendChild(holder); holder.appendChild(sk());
    const load = async () => { const r = await rpc('capps.roster', { app: W.id, module: m.id }); holder.innerHTML = '';
      if (!r || r.error) { holder.appendChild(UI.empty('info', T('Não foi possível carregar'), errMsg(r))); return; }
      const list = arrOf(r.members); const on = list.filter(x => x.onduty).length;
      sum.innerHTML = `<div class="cap-stat"><b>${on}</b><span>${esc(T('em serviço'))}</span></div><div class="cap-stat off"><b>${list.length - on}</b><span>${esc(T('fora de serviço'))}</span></div><div class="cap-stat all"><b>${list.length}</b><span>${esc(T('online'))}</span></div>`;
      if (!list.length) { holder.appendChild(UI.empty('cap_users', T('Ninguém online'), T('Os colegas aparecem aqui quando entrarem.'))); return; }
      const byJob = {}; list.forEach(p => { (byJob[p.job || p.jobName || ''] = byJob[p.job || p.jobName || ''] || []).push(p); });
      Object.keys(byJob).forEach(jn => { if (Object.keys(byJob).length > 1) holder.appendChild(section(jn, true));
        const g = UI.el('<div class="group cap-rows"></div>');
        byJob[jn].forEach(p => { const e = UI.el(`<div class="cap-row cap-mate ${p.onduty ? '' : 'off'}">${UI.avatar({ name: p.name, seed: String(p.name).length * 3 + (p.level || 0) }, 'sm cap-av')}<div class="cap-row-m"><div class="cap-row-t"><b ${NI}>${esc(p.name)}${p.me ? ` <em>${esc(T('(eu)'))}</em>` : ''}</b></div><div class="cap-row-p"><i class="cap-duty"></i><span ${NI}>${esc(p.grade || '')}</span></div></div><div class="cap-mate-a"></div></div>`);
          const a = e.querySelector('.cap-mate-a');
          if (p.phone && !p.me) { const c = UI.el(`<i>${UI.g('phone', 18)}</i>`); c.onclick = ev => { ev.stopPropagation(); call(p.phone, p.name); }; const ms = UI.el(`<i>${UI.g('message', 18)}</i>`); ms.onclick = ev => { ev.stopPropagation(); message(p.phone, p.name); }; a.append(ms, c); }
          g.appendChild(e); });
        holder.appendChild(g); }); };
    load();
    return { refresh: load };
  }

  /* ===================== MODULO: PAGINA (info) ===================== */
  const WD = [1, 2, 3, 4, 5, 6, 7];
  /* horario: { from, to, days = {1..7} } (1 = segunda), ou uma lista de 7 textos (segunda a domingo), ou { mon..sun } */
  function hoursOf(h) {
    const out = WD.map(() => null);
    if (Array.isArray(h)) { h.slice(0, 7).forEach((x, i) => { out[i] = x == null || x === '' ? null : String(x); }); return out; }
    if (h && typeof h === 'object') {
      const K = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
      if (K.some(k => k in h)) { K.forEach((k, i) => { out[i] = h[k] ? String(h[k]) : null; }); return out; }
      const f = typeof h.from === 'string' ? h.from : pad2(+h.from || 0) + ':00', t = typeof h.to === 'string' ? h.to : pad2(+h.to || 0) + ':00';
      const days = arrOf(h.days).length ? arrOf(h.days).map(Number) : WD;
      WD.forEach((d, i) => { out[i] = days.includes(d) ? f + ' - ' + t : null; }); }
    return out;
  }
  function openNow(rows) {
    const n = new Date(), i = (n.getDay() + 6) % 7, s = rows[i]; if (!s) return false;
    const m = /(\d{1,2}):?(\d{2})?\s*[-a]\s*(\d{1,2}):?(\d{2})?/.exec(s); if (!m) return null;
    const a = +m[1] * 60 + (+m[2] || 0), b = +m[3] * 60 + (+m[4] || 0), c = n.getHours() * 60 + n.getMinutes();
    return b > a ? (c >= a && c < b) : (c >= a || c < b);
  }
  function vInfo(W, def, m, v, body) {
    const o = m.options;
    const wrap = UI.el('<div class="cap-info"></div>'); body.appendChild(wrap);
    if (o.hero && /^(https:\/\/|nui:\/\/)/i.test(String(o.hero))) wrap.appendChild(UI.el(`<div class="cap-hero"><img src="${esc(String(o.hero))}" alt=""></div>`));
    else wrap.appendChild(UI.el(`<div class="cap-hero art"><div class="cap-hero-g"></div><div class="cap-hero-ic">${glyphSvg((def.icon && def.icon.glyph) || 'star', 44)}</div><div class="cap-hero-tx"><b ${NI}>${esc(def.name)}</b>${def.subtitle ? `<span ${NI}>${esc(def.subtitle)}</span>` : ''}</div></div>`));
    if (def.description) wrap.appendChild(UI.el(`<div class="cap-card"><div class="cap-card-x" ${NI}>${esc(def.description)}</div></div>`));
    arrOf(o.blocks).forEach(b => { if (!b || typeof b !== 'object') return; const title = b.title ? String(b.title) : '';
      if (b.type === 'text') wrap.appendChild(UI.el(`<div class="cap-card">${title ? `<div class="cap-card-h" ${NI}>${esc(title)}</div>` : ''}<div class="cap-card-x" ${NI}>${esc(String(b.text || ''))}</div></div>`));
      else if (b.type === 'hours') { const rows = hoursOf(b.hours); const now = openNow(rows); const ti = (new Date().getDay() + 6) % 7;
        wrap.appendChild(UI.el(`<div class="cap-card"><div class="cap-card-h">${title ? `<span ${NI}>${esc(title)}</span>` : esc(T('Horário'))}${now === null ? '' : `<em class="${now ? 'open' : 'shut'}">${esc(T(now ? 'Aberto agora' : 'Fechado agora'))}</em>`}</div>
          <div class="cap-hours">${rows.map((r, i) => `<div class="${i === ti ? 'today' : ''}"><span>${esc(UI.wdLong(new Date(2026, 0, 5 + i)))}</span><b ${r ? NI : ''}>${esc(r || T('Fechado'))}</b></div>`).join('')}</div>${b.text ? `<div class="cap-card-f" ${NI}>${esc(String(b.text))}</div>` : ''}</div>`)); }
      else if (b.type === 'location') { const ok = isFinite(+b.x) && isFinite(+b.y) && b.x !== '' && b.y !== '';
        const e = UI.el(`<div class="cap-card cap-locc"><div class="cap-map"><i>${gi('mapPin', 26)}</i></div><div class="cap-locc-b"><div class="cap-card-h" ${title ? NI : ''}>${esc(title || T('Localização'))}</div>${b.text ? `<div class="cap-card-x" ${NI}>${esc(String(b.text))}</div>` : ''}${ok ? `<div class="cap-mini-btn">${UI.g('nav', 15)}<span>${esc(T('Marcar no GPS'))}</span></div>` : ''}</div></div>`);
        if (ok) e.querySelector('.cap-mini-btn').onclick = () => waypoint(b.x, b.y, title || def.name); wrap.appendChild(e); }
      else if (b.type === 'contact') { const ph = b.phone || b.text; const e = UI.el(`<div class="cap-card cap-contact"><i>${UI.g('phone', 20)}</i><div><div class="cap-card-h" ${title ? NI : ''}>${esc(title || T('Contacto'))}</div><div class="cap-card-x" ${NI}>${esc(String(ph || ''))}</div></div><div class="cap-contact-a"></div></div>`);
        if (ph) { const a = e.querySelector('.cap-contact-a'); const c1 = UI.el(`<span>${UI.g('message', 18)}</span>`), c2 = UI.el(`<span class="on">${UI.g('phone', 18)}</span>`); c1.onclick = () => message(ph, title || def.name); c2.onclick = () => call(ph, title || def.name); a.append(c1, c2); } wrap.appendChild(e); }
      else if (b.type === 'link' && /^https:\/\//i.test(String(b.url || ''))) { const e = UI.el(`<div class="cap-card cap-link"><i>${UI.g('link', 20)}</i><div><div class="cap-card-h" ${NI}>${esc(title || String(b.url))}</div>${b.text ? `<div class="cap-card-x" ${NI}>${esc(String(b.text))}</div>` : ''}</div><span class="li-chev">${UI.g('chevR')}</span></div>`); e.onclick = () => System.openURL ? System.openURL(String(b.url)) : null; wrap.appendChild(e); }
      else if (b.type === 'image' && /^(https:\/\/|nui:\/\/)/i.test(String(b.url || ''))) wrap.appendChild(UI.el(`<div class="cap-card cap-imgc"><img src="${esc(String(b.url))}" alt="">${title || b.text ? `<div class="cap-imgc-c" ${NI}>${esc(title || String(b.text))}</div>` : ''}</div>`));
    });
    if (def.contact && def.contact.phone) { const c = def.contact; const e = UI.el(`<div class="btn-p cap-cta cap-callbtn">${UI.g('phone', 20)}<span>${esc(TF('Ligar %s', c.label || c.phone))}</span></div>`); e.querySelector('span').setAttribute(NI, ''); e.onclick = () => call(c.phone, c.label || def.name); wrap.appendChild(e); }
    return null;
  }

  /* ===================== MODULO: CATALOGO (menu, tabela de precos, encomendas) =====================
     Cidadao: o menu por categorias, linhas com imagem (ou o glifo da app), preco e "+"; o carrinho vive numa barra que se
     cola ao fundo (sticky, por cima dos separadores) e abre a folha da encomenda (linhas e quantidades, formulario extra,
     localizacao, total). O total aqui e so uma previa: o servidor recalcula com os precos atuais e devolve o verdadeiro.
     Equipa: as encomendas (estados da definicao, notas, GPS, faturar no detalhe); o menu fica no botao da barra. */
  const catItems = m => arrOf(m.options.items).filter(it => it && typeof it.id === 'string');
  function catCats(m) { const cats = arrOf(m.options.categories).filter(c => typeof c === 'string' && c); catItems(m).forEach(it => { if (it.category && !cats.includes(String(it.category))) cats.push(String(it.category)); }); return cats; }
  const itemThumb = (def, it) => { const img = typeof it.image === 'string' && /^(https:\/\/|nui:\/\/)/i.test(it.image.trim()) ? it.image.trim() : null;
    return img ? `<div class="cap-mi-img"><img src="${esc(img)}" alt="" loading="lazy"></div>` : `<div class="cap-mi-img art">${glyphSvg((def.icon && def.icon.glyph) || 'bag2', 30)}</div>`; };
  function orderRow(W, m, it) {
    const st = stInfo(m, 'order', it.status);
    const r = itemRow(W, m, it, `<div class="cap-tile" style="--c:${st.color};--cb:${rgba(st.color, .15)}">${gi('bag2', 20)}</div>`);
    r.querySelector('.cap-row-x').insertAdjacentHTML('beforeend', `<span class="cap-row-tot">${esc(money(it.total, it.currency))}</span>`);
    return r;
  }
  function vCatalog(W, def, m, v, body) {
    const o = m.options;
    if (W.side === 'staff' && o.orderable !== false) {
      v.navbar.querySelector('.nb-right').appendChild((() => { const b = UI.el(`<div class="nb-btn nb-ico" data-ic="list" data-lb="${esc(T('Ver menu'))}">${UI.g('list')}</div>`); b.onclick = () => { const mv = UI.view({ title: m.title || T('Menu'), back: m.title || T('Voltar'), cls: 'cap-detail cap-v-catalog' }); mv.navbar.querySelector('.nb-title').setAttribute(NI, ''); const bb = UI.el('<div class="cap-body"></div>'); mv.content.appendChild(bb); menuBody(W, def, m, bb, false); UI.push(W.win, mv); }; return b; })());
      const sts = statusesOf(m); const adm = customSt(m).length > 0;
      const F = [{ id: 'open', label: 'Abertas' }, { id: 'all', label: 'Todas' }, { id: 'mine', label: 'Atribuídas a mim' }].concat(sts.map(s => ({ id: s.id, label: s.label, admin: adm })));
      let filter = 'open', q = '';
      const search = UI.search(T('Pesquisar'), t => { q = t; list.reload(); }); search.classList.add('cap-search'); body.appendChild(search);
      const ch = UI.chips(F.map(f => f.admin ? f.label : T(f.label)), 0, i => { filter = F[i].id; list.reset(); }); ch.classList.add('cap-chips');
      [...ch.children].forEach((c, i) => { if (F[i].admin) c.setAttribute(NI, ''); }); body.appendChild(ch);
      const list = pagedList(W, m, 'staff', { render: it => { const r = orderRow(W, m, it); r.onclick = () => openItem(W, m, it.id, 'staff'); return r; }, empty: ['bag2', 'Sem encomendas', 'As encomendas dos clientes aparecem aqui.'], params: () => ({ filter, q }) });
      body.appendChild(list.el);
      return { refresh: () => list.reload() };
    }
    return menuBody(W, def, m, body, W.side === 'civil' && o.orderable !== false);
  }
  function menuRow(def, it, cur$, canOrder) {
    const off = it.available === false;
    const el = UI.el(`<div class="cap-mi ${off ? 'off' : ''}"><div class="cap-mi-b"><b ${NI}>${esc(String(it.label || it.id))}</b>${it.desc ? `<span ${NI}>${esc(String(it.desc))}</span>` : ''}<em>${esc(money(it.price, cur$))}${off ? `<i>${esc(T('Esgotado'))}</i>` : ''}</em></div><div class="cap-mi-r">${itemThumb(def, it)}${canOrder && !off ? '<div class="cap-qty"><i class="m">' + UI.g('minus', 16) + '</i><b>0</b><i class="p">' + UI.g('plus', 17) + '</i></div>' : ''}</div></div>`);
    const api = { el, onQty: null, set: () => {} };
    const qbox = el.querySelector('.cap-qty');
    if (qbox) {
      let q = 0; const n = qbox.querySelector('b');
      qbox.onclick = e => { e.stopPropagation(); const t = e.target.closest('i'); if (!t) return; Sound.play && Sound.play('tick'); if (api.onQty) api.onQty(q + (t.classList.contains('m') ? -1 : 1)); };
      el.onclick = () => { if (!q && api.onQty) { Sound.play && Sound.play('tick'); api.onQty(1); } };
      api.set = x => { if (x === q) return; q = x; n.textContent = q; qbox.classList.toggle('on', q > 0); };
    }
    return api;
  }
  function menuBody(W, def, m, body, canOrder) {
    const o = m.options; const cur$ = String(o.currency || UI.cur()).slice(0, 4); const maxQ = Math.max(1, Math.min(99, +o.maxQty || 10));
    const items = catItems(m), cats = catCats(m);
    const cart = new Map();
    if (o.intro) body.appendChild(UI.el(`<div class="cap-intro" ${NI}>${esc(String(o.intro))}</div>`));
    let cat = null; const groups = []; const rows = {};
    if (cats.length > 1) { const ch = UI.chips([T('Tudo')].concat(cats), 0, i => { cat = i ? cats[i - 1] : null; groups.forEach(g => { const on = !cat || g.c === cat; g.grp.hidden = !on; if (g.head) g.head.hidden = !on; }); }); ch.classList.add('cap-chips'); [...ch.children].forEach((c, i) => { if (i) c.setAttribute(NI, ''); }); body.appendChild(ch); }
    const menu = UI.el('<div class="cap-menu"></div>'); body.appendChild(menu);
    const setQty = (it, q) => { q = Math.max(0, Math.min(maxQ, q)); if (q) cart.set(it.id, q); else cart.delete(it.id); if (rows[it.id]) rows[it.id].set(q); syncBar(); };
    const blocks = cats.length ? cats.map(c => [c, items.filter(it => String(it.category || '') === c)]) : [];
    const loose = items.filter(it => !cats.includes(String(it.category || ''))); if (loose.length) blocks.push([null, loose]);
    blocks.forEach(([c, list]) => { if (!list.length) return;
      const head = c ? UI.el(`<div class="cap-sec cap-msec" ${NI}>${esc(c)}</div>`) : null; const grp = UI.el('<div class="group cap-mis"></div>');
      list.forEach(it => { const r = menuRow(def, it, cur$, canOrder); r.onQty = q => setQty(it, q); rows[it.id] = r; grp.appendChild(r.el); });
      if (head) menu.appendChild(head); menu.appendChild(grp); groups.push({ c, head, grp }); });
    if (!items.length) menu.appendChild(UI.empty('cap_bag2', T('Menu vazio'), T('Ainda não há nada nesta lista.')));
    let bar = null, mine = null;
    const syncBar = () => { if (!bar) return; let t = 0, n = 0; cart.forEach((q, id) => { const it = items.find(x => x.id === id); if (it) { t += (+it.price || 0) * q; n += q; } });
      bar.hidden = !n; bar.querySelector('.cap-cb-n').textContent = n; bar.querySelector('.cap-cb-t').textContent = money(Math.round(t * 100) / 100, cur$); };
    if (canOrder) {
      if (o.civilSeesOwn !== false) { body.appendChild(section('As tuas encomendas')); mine = pagedList(W, m, 'civil', { render: it => { const r = orderRow(W, m, it); r.onclick = () => openItem(W, m, it.id, 'civil'); return r; }, empty: ['bag2', 'Ainda sem encomendas', 'As tuas encomendas e o estado delas aparecem aqui.'] }); body.appendChild(mine.el); }
      bar = UI.el(`<div class="cap-cartbar" hidden><span class="cap-cb-n">0</span><b>${esc(T('Ver encomenda'))}</b><span class="cap-cb-t"></span></div>`);
      bar.onclick = () => cartSheet(W, def, m, items, cart, cur$, maxQ, { setQty, done: () => { [...cart.keys()].forEach(id => { if (rows[id]) rows[id].set(0); }); cart.clear(); syncBar(); if (mine) mine.reload(); } });
      body.appendChild(bar);
    }
    return { refresh: () => { if (mine) mine.reload(); } };
  }
  /* folha da encomenda: as linhas mudam no lugar (sem repintar a lista); o formulario extra e o do painel (campos v2) */
  function cartSheet(W, def, m, items, cart, cur$, maxQ, h) {
    const o = m.options;
    const body = UI.el('<div class="cap-cart"></div>');
    const lines = UI.el('<div class="group cap-lines"></div>'); body.appendChild(lines);
    const totEl = UI.el(`<div class="cap-ln cap-ln-tot"><span></span><b>${esc(T('Total'))}</b><em></em></div>`);
    const lineRows = new Map();
    const total = () => { let t = 0; cart.forEach((q, id) => { const it = items.find(x => x.id === id); if (it) t += (+it.price || 0) * q; }); return Math.round(t * 100) / 100; };
    const sync = () => { totEl.querySelector('em').textContent = money(total(), cur$); };
    cart.forEach((q, id) => { const it = items.find(x => x.id === id); if (!it) return;
      const r = UI.el(`<div class="cap-ln cap-cl"><div class="cap-step"><i class="m">${UI.g('minus', 15)}</i><b>${q}</b><i class="p">${UI.g('plus', 15)}</i></div><b ${NI}>${esc(String(it.label || it.id))}</b><em></em></div>`);
      const draw = () => { const n = cart.get(id) || 0; r.querySelector('.cap-step b').textContent = n; r.querySelector('em').textContent = money((+it.price || 0) * n, cur$); };
      r.querySelector('.cap-step').onclick = e => { const t = e.target.closest('i'); if (!t) return; const n = (cart.get(id) || 0) + (t.classList.contains('m') ? -1 : 1); h.setQty(it, n); Sound.play && Sound.play('tick'); if (!cart.get(id)) { r.remove(); lineRows.delete(id); } else draw(); sync(); };
      lineRows.set(id, r); draw(); lines.appendChild(r); });
    lines.appendChild(totEl); sync();
    let form = null;
    if (arrOf(o.fields).length) { body.appendChild(section('Detalhes')); form = formOf(o.fields); body.appendChild(form.el); }
    let loc = !!o.location;
    if (o.location) { const l = UI.list([{ items: [{ label: T('Enviar a minha localização'), toggle: true, onToggle: x => { loc = x; } }] }]); l.classList.add('cap-opts'); body.appendChild(l); }
    body.appendChild(UI.el(`<div class="group-footer cap-cart-foot">${esc(T('Nada é cobrado agora. A equipa pode enviar-te uma fatura pelo telemóvel.'))}</div>`));
    let busy = false;
    const sh = UI.sheet({ title: T('A tua encomenda'), left: T('Fechar'), right: T('Encomendar'), body, cls: 'cap-sheet', onDone: () => { submit(); return false; } }); tint(sh.el, def);
    async function submit() {
      if (busy) return;
      if (!cart.size) { UI.toast(T('A encomenda está vazia.')); return; }
      const fr = form ? form.read() : { values: {} }; if (fr.error) { UI.toast(fr.error); flash(fr.el); return; }
      busy = true;
      const coords = loc ? await Bridge.call('getCoords') : null;
      const r = await rpc('capps.create', { app: W.id, module: m.id, side: 'civil', lines: [...cart].map(([id, qty]) => ({ id, qty })), fields: fr.values, location: loc, coords });
      busy = false;
      if (!r || !r.ok) { fail(r, 'Encomenda não enviada'); return; }
      Sound.play && Sound.play('success'); sh.close(); h.done();
      UI.banner({ iconHtml: Icons.tile(appId(W.id)), title: def.name, msg: TF('Encomenda enviada: %s.', money(r.item && r.item.data ? r.item.data.total : total(), cur$)) });
    }
  }

  /* ===================== MODULO: FATURACAO =====================
     Equipa (escalao de 'create' para emitir): "Nova fatura" abre uma folha (a quem: quem esta a 10 m ou um numero; valor
     com os atalhos do painel; motivo). Por baixo, as faturas emitidas pelo modulo com o estado lido da app Faturas
     (pendente, paga, recusada, anulada). O cidadao paga na app Faturas: este modulo nao tem lado do cidadao. */
  function vBilling(W, def, m, v, body) {
    const o = m.options;
    let list = null;
    if (can(W, m, 'create')) {
      const card = UI.el(`<div class="cap-newbill"><i>${UI.g('receipt', 24)}</i><div><b>${esc(T('Nova fatura'))}</b><span>${esc(T(o.society !== false ? 'Paga à conta da empresa' : 'Paga diretamente a ti'))}</span></div><em>${UI.g('plus', 20)}</em></div>`);
      card.onclick = () => billSheet(W, def, m, () => { if (list) list.reset(); });
      body.appendChild(card);
    }
    const F = [['all', 'Todas'], ['pending', 'Pendentes'], ['paid', 'Pagas'], ['mine', 'Emitidas por mim']]; let filter = 'all', q = '';
    const search = UI.search(T('Pesquisar'), t => { q = t; list.reload(); }); search.classList.add('cap-search'); body.appendChild(search);
    const ch = UI.chips(F.map(f => T(f[1])), 0, i => { filter = F[i][0]; list.reset(); }); ch.classList.add('cap-chips'); body.appendChild(ch);
    const lead = it => { const st = stInfo(m, 'bill', it.status); return `<div class="cap-tile" style="--c:${st.color};--cb:${rgba(st.color, .15)}">${UI.g('receipt', 20)}</div>`; };
    list = pagedList(W, m, 'staff', { render: it => {
      const who = it.owner_name ? it.owner_name + (it.owner_phone ? ' · ' + UI.phone(it.owner_phone) : '') : (it.owner_phone ? UI.phone(it.owner_phone) : '');
      const r = itemRow(W, m, Object.assign({}, it, { preview: who || it.preview, owner_name: null, anonymous: false }), lead(it));
      r.querySelector('.cap-row-x').insertAdjacentHTML('beforeend', `<span class="cap-row-tot">${esc(money(it.amount))}</span>`);
      r.onclick = () => openItem(W, m, it.id, 'staff'); return r; }, empty: ['coins', 'Sem faturas', 'As faturas emitidas aqui aparecem nesta lista.'], params: () => ({ filter, q }) });
    body.appendChild(list.el);
    return { refresh: () => list.reload() };
  }
  function billSheet(W, def, m, after) {
    const o = m.options; const max = +o.maxAmount || 0;
    const body = UI.el('<div class="cap-billf"></div>');
    let mode = 'near', target = null, busy = false;
    const seg = UI.seg([T('Por perto'), T('Número')], 0, i => { mode = i ? 'num' : 'near'; near.hidden = mode !== 'near'; numG.hidden = mode !== 'num'; }); seg.classList.add('cap-side'); body.appendChild(seg);
    const near = UI.el('<div class="cap-near"></div>'); body.appendChild(near);
    const numG = UI.el(`<div class="group cap-form" hidden><div class="cap-f"><div class="cap-f-l">${esc(T('Número de telefone'))}</div><div class="cap-f-in"><input type="tel" class="cap-in" maxlength="20" inputmode="tel" placeholder="555-0000" autocomplete="off"></div></div></div>`); body.appendChild(numG);
    body.appendChild(section('Valor'));
    const g = UI.el(`<div class="group cap-form"><div class="cap-f"><div class="cap-f-in cap-amt"><input type="text" class="cap-in" maxlength="9" inputmode="numeric" placeholder="0" autocomplete="off"><span>${esc(UI.cur())}</span></div>${max ? `<div class="cap-f-help">${esc(TF('Máximo %s', money(max)))}</div>` : ''}</div><div class="cap-f"><div class="cap-f-l">${esc(T('Motivo'))}${o.reasonRequired !== false ? '<em>*</em>' : ''}</div><div class="cap-f-in"><input type="text" class="cap-in" maxlength="160" placeholder="${esc(T('Ex.: reparação do motor'))}" autocomplete="off"></div></div></div>`);
    const [amtIn, rsIn] = g.querySelectorAll('input'); const numIn = numG.querySelector('input');
    amtIn.addEventListener('input', () => { const p = amtIn.value.replace(/\D/g, ''); if (p !== amtIn.value) amtIn.value = p; });
    const presets = arrOf(o.presets).filter(p => p && +p.amount > 0);
    if (presets.length) { const pc = UI.el('<div class="cap-presets"></div>'); let last = null;
      presets.forEach(p => { const c = UI.el(`<span><b ${NI}>${esc(String(p.label || ''))}</b><i>${esc(money(+p.amount))}</i></span>`); c.onclick = () => { amtIn.value = String(Math.round(+p.amount)); if (!rsIn.value.trim() || rsIn.value === last) { rsIn.value = String(p.label || ''); last = rsIn.value; } pc.querySelectorAll('.on').forEach(x => x.classList.remove('on')); c.classList.add('on'); Sound.play && Sound.play('tick'); }; pc.appendChild(c); });
      body.appendChild(pc); }
    body.appendChild(g);
    body.appendChild(UI.el(`<div class="group-footer">${esc(T(o.society !== false ? 'A fatura é paga à conta da empresa. O cliente paga na app Faturas.' : 'A fatura é paga diretamente a ti. O cliente paga na app Faturas.'))}</div>`));
    const loadNear = async () => {
      near.innerHTML = ''; near.appendChild(UI.spinner());
      let ids = []; if (Bridge.inFiveM) { try { const r0 = await Bridge.call('capps:nearby'); ids = (r0 && r0.ids) || []; } catch (e) {} }
      const r = await rpc('capps.nearby', { app: W.id, module: m.id, ids }); near.innerHTML = '';
      if (!r || r.error) { near.appendChild(UI.el(`<div class="cap-near-e"><span>${esc(errMsg(r))}</span></div>`)); return; }
      const ps = arrOf(r.players);
      if (!ps.length) { const e = UI.el(`<div class="cap-near-e">${UI.g('people', 22)}<span>${esc(T('Ninguém a menos de 10 m. Usa o número de telefone.'))}</span><b>${esc(T('Procurar outra vez'))}</b></div>`); e.querySelector('b').onclick = loadNear; near.appendChild(e); return; }
      const grp = UI.el('<div class="group cap-rows"></div>');
      ps.forEach(p => { const row = UI.el(`<div class="cap-row cap-np ${target === p.id ? 'on' : ''}">${UI.avatar({ name: p.name, seed: String(p.name).length * 5 }, 'sm cap-av')}<div class="cap-row-m"><div class="cap-row-t"><b ${NI}>${esc(p.name)}</b></div>${p.dist != null ? `<div class="cap-row-p">${esc(TF('a %s m', Math.max(1, Math.round(p.dist))))}</div>` : ''}</div><i class="cap-np-r">${UI.g('check', 15)}</i></div>`);
        row.onclick = () => { target = p.id; grp.querySelectorAll('.cap-np').forEach(x => x.classList.toggle('on', x === row)); Sound.play && Sound.play('tick'); }; grp.appendChild(row); });
      near.appendChild(grp); };
    loadNear();
    const sh = UI.sheet({ title: T('Nova fatura'), left: T('Cancelar'), right: T('Emitir'), body, cls: 'cap-sheet', onDone: () => { submit(); return false; } }); tint(sh.el, def);
    async function submit() {
      if (busy) return;
      const amt = amtIn.value.trim(); const n = Number(amt);
      if (!/^\d+$/.test(amt) || n < 1) { UI.toast(T(ERR.amount)); flash(amtIn.closest('.cap-f')); return; }
      if (max && n > max) { UI.toast(TF('O valor máximo é %s.', money(max))); flash(amtIn.closest('.cap-f')); return; }
      const reason = rsIn.value.trim(); if (o.reasonRequired !== false && !reason) { UI.toast(T(ERR.reason)); flash(rsIn.closest('.cap-f')); return; }
      const d = { app: W.id, module: m.id, side: 'staff', amount: n, reason };
      if (mode === 'near') { if (target == null) { UI.toast(T(ERR.target)); return; } d.target = target; }
      else { const to = numIn.value.trim(); if (!to) { UI.toast(T(ERR.target)); flash(numIn.closest('.cap-f')); return; } d.to = to; }
      busy = true; const r = await rpc('capps.create', d); busy = false;
      if (!r || !r.ok) { fail(r, 'Fatura não enviada'); return; }
      Sound.play && Sound.play('success'); UI.toast(T('Fatura enviada')); sh.close(); if (after) after();
    }
  }

  /* ===================== MODULO: SERVICO =====================
     O estado vem do servidor (capps.duty): em servico ou nao (o do framework), desde quando, horas desta semana, os
     ultimos turnos e quem esta em servico agora. O botao troca pelo FW.SetDuty (QBCore, QBox, ESX ou o hook do
     standalone); quando o servidor gere o servico de outra maneira, o modulo so mostra o estado. Construido uma vez e
     atualizado no lugar (o "desde" recalcula-se a cada 30 s, so o texto). */
  function vDuty(W, def, m, v, body) {
    const hero = UI.el(`<div class="cap-dc"><div class="cap-dc-ic">${gi('clock', 30)}</div><div class="cap-dc-t"></div><div class="cap-dc-s"></div><div class="btn-p cap-cta cap-dc-btn" hidden></div><div class="cap-dc-ro" hidden>${UI.g('info', 15)}<span>${esc(T('O serviço é gerido pelo servidor.'))}</span></div></div>`);
    body.appendChild(hero);
    const stats = UI.el(`<div class="cap-roster-sum"><div class="cap-stat"><b class="w">--</b><span>${esc(T('esta semana'))}</span></div><div class="cap-stat off"><b class="n">--</b><span>${esc(T('turnos recentes'))}</span></div><div class="cap-stat all"><b class="t">--</b><span>${esc(T('em serviço'))}</span></div></div>`);
    body.appendChild(stats);
    const teamSec = section('Em serviço agora'), teamG = UI.el('<div class="group cap-rows"></div>'), teamE = UI.el(`<div class="cap-thread-empty">${esc(T('Ninguém em serviço neste momento.'))}</div>`);
    const shSec = section('Turnos recentes'), shG = UI.el('<div class="group cap-rows"></div>');
    body.append(teamSec, teamG, teamE, shSec, shG);
    [teamSec, teamG, teamE, shSec, shG].forEach(e => { e.hidden = true; });
    const kTeam = keyed(teamG, p => { const e = UI.el(`<div class="cap-row cap-mate">${UI.avatar({ name: p.name, seed: String(p.name).length * 3 + (p.level || 0) }, 'sm cap-av')}<div class="cap-row-m"><div class="cap-row-t"><b ${NI}>${esc(p.name)}${p.me ? ` <em>${esc(T('(eu)'))}</em>` : ''}</b></div><div class="cap-row-p"><i class="cap-dc-dot"></i><span ${NI}>${esc(p.grade || '')}</span>${p.since ? `<span class="cap-since">${esc(TF('desde as %s', UI.fmtTime(new Date(p.since))))}</span>` : ''}</div></div><div class="cap-mate-a"></div></div>`);
      const a = e.querySelector('.cap-mate-a');
      if (p.phone && !p.me) { const c = UI.el(`<i>${UI.g('phone', 18)}</i>`); c.onclick = ev => { ev.stopPropagation(); call(p.phone, p.name); }; const ms = UI.el(`<i>${UI.g('message', 18)}</i>`); ms.onclick = ev => { ev.stopPropagation(); message(p.phone, p.name); }; a.append(ms, c); }
      return e; }, p => JSON.stringify([p.name, p.grade, p.since, p.phone, p.me]));
    const kSh = keyed(shG, s => { const a = new Date(s.at), b = s.stop ? new Date(s.stop) : null;
      return UI.el(`<div class="cap-row cap-shift"><div class="cap-time"><b>${a.getDate()}</b><span>${esc(UI.monthName(a.getMonth(), true))}</span></div><div class="cap-row-m"><div class="cap-row-t"><b>${esc(String(UI.wdLong(a)).replace(/^./, x => x.toUpperCase()))}</b><span class="cap-row-time">${esc(fmtMins(s.minutes))}</span></div><div class="cap-row-p">${esc(UI.fmtTime(a))}${b ? ' - ' + esc(UI.fmtTime(b)) : ''}</div></div></div>`); }, s => JSON.stringify([s.at, s.stop, s.minutes]));
    const btn = hero.querySelector('.cap-dc-btn'), sub = hero.querySelector('.cap-dc-s');
    let st = null, busy = false;
    const draw = () => { if (!st) return;
      hero.classList.toggle('on', !!st.onduty);
      hero.querySelector('.cap-dc-t').textContent = T(st.onduty ? 'Em serviço' : 'Fora de serviço');
      if (st.onduty && st.since) { sub.removeAttribute(NI); sub.textContent = TF('Desde as %s · %s', UI.fmtTime(new Date(st.since)), fmtMins((Date.now() - st.since) / 60000)); }
      else if (st.job) { sub.setAttribute(NI, ''); sub.textContent = st.job; }
      else { sub.removeAttribute(NI); sub.textContent = T('Entra em serviço para receber pedidos.'); }
      btn.textContent = T(st.onduty ? 'Sair de serviço' : 'Entrar em serviço'); btn.classList.toggle('off', !!st.onduty);
      btn.hidden = !st.supported; hero.querySelector('.cap-dc-ro').hidden = !!st.supported;
      const team = Array.isArray(st.team) ? st.team : null;
      const wk = Math.max(0, Math.round(+st.week || 0)); stats.querySelector('.w').textContent = wk >= 60 ? Math.floor(wk / 60) + 'h' + pad2(wk % 60) : wk + ' min';
      stats.querySelector('.n').textContent = arrOf(st.shifts).length;
      stats.querySelector('.t').textContent = team ? team.length : '--';
      teamSec.hidden = !team; teamG.hidden = !team || !team.length; teamE.hidden = !team || !!team.length;
      if (team) kTeam.set(team.map(p => Object.assign({ id: (p.name || '') + '|' + (p.phone || '') }, p)));
      const shs = arrOf(st.shifts); shSec.hidden = shG.hidden = !shs.length; kSh.set(shs.map(s => Object.assign({ id: s.id || s.at }, s)));
    };
    const load = async () => { const r = await rpc('capps.duty', { app: W.id, module: m.id });
      if (!r || r.error) { if (!st) { hero.querySelector('.cap-dc-t').textContent = T('Não foi possível carregar'); sub.textContent = errMsg(r); } return; }
      st = r; draw(); };
    btn.onclick = async () => { if (busy || !st) return; busy = true; btn.classList.add('dis');
      const r = await rpc('capps.duty', { app: W.id, module: m.id, on: !st.onduty }); busy = false; btn.classList.remove('dis');
      if (!r || r.error) { fail(r); return; }
      Sound.play && Sound.play('success'); st = r; draw(); UI.toast(T(r.onduty ? 'Estás em serviço' : 'Saíste de serviço')); refreshAccess(); };
    const tick = setInterval(() => { if (!hero.isConnected) { clearInterval(tick); return; } if (st && st.onduty && st.since) draw(); }, 30000);
    load();
    return { refresh: load };
  }

  /* ---------- ao vivo ---------- */
  function refreshLive(W) { if (!W) return; try { if (W.live && W.live.refresh) W.live.refresh(); } catch (e) { console.error('[apex_phone] capps refresh', e); } }
  const pendingCh = {}; let chT = null;
  Bridge.on('capps:changed', d => {
    if (!d || typeof d.app !== 'string') return;
    (pendingCh[d.app] = pendingCh[d.app] || []).push(d);
    clearTimeout(chT); chT = setTimeout(() => {
      Object.keys(pendingCh).forEach(app => { const list = pendingCh[app]; delete pendingCh[app]; const W = WINS[app]; if (!W) return;
        const front = System.currentApp && System.currentApp() === appId(app);
        if (list.some(x => x.purged || (W.live && x.module === W.live.mod))) { if (front) refreshLive(W); else W.stale = true; }
        W.details.forEach(det => { if (list.some(x => +x.id === +det.id)) det.refresh(); }); });
      badges();
    }, 250);
    /* um turno abriu/fechou (servico mudado aqui, num ponto de servico ou noutro telemovel): o lado da equipa pode ter mudado */
    if (d.kind === 'shift') dutySoon();
  });
  let dutyT = null;
  const dutySoon = () => { clearTimeout(dutyT); dutyT = setTimeout(() => { if (window.System && System.ready) refreshAccess();
    Object.keys(WINS).forEach(id => { const W = WINS[id]; if (W.live && W.live.kind === 'duty') refreshLive(W); }); }, 350); };
  /* o servico mudou fora do telemovel (client/capps.lua: QBCore:Client:SetDuty) */
  Bridge.on('capps:duty', dutySoon);
  /* notificacao tocada: abrir o separador do modulo e o registo */
  let pending = null;
  Bridge.on('notif:open', n => { if (!n || typeof n.app !== 'string' || n.app.indexOf('capp_') !== 0 || !n.data || typeof n.data !== 'object') return; pending = { app: n.app.slice(5), module: n.data.module, id: n.data.id, at: Date.now() };
    /* a app ja esta a frente: o openApp nao volta a correr o open/resume, por isso trata-se ja aqui */
    setTimeout(() => { const W = WINS[pending && pending.app]; if (W && System.currentApp && System.currentApp() === appId(W.id)) takePending(W); }, 50); });
  function takePending(W) {
    const p = pending; if (!p || p.app !== W.id || Date.now() - p.at > 8000) return; pending = null;
    const def = DEFS[W.id]; const m = def && def.modules.find(x => x.id === p.module); if (!m) return;
    const acc = accOf(def); const side = staffMod(acc, m) ? 'staff' : 'civil';
    if (W.side !== side && ((side === 'staff' && W.canStaff) || (side === 'civil' && W.canCivil))) { W.side = side; SIDE[W.id] = side; build(W, false); }
    const i = W.mods.findIndex(x => x.id === m.id);
    setTimeout(() => { if (W.tabs && i > -1 && i < W.tabCount) W.tabs.go(i);
      if (p.id) setTimeout(() => { if (m.type === 'posts') openPost(W, m, +p.id); else if (kindOf(m)) openItem(W, m, +p.id, side); }, 160); }, 60);
  }

  /* ---------- arranque ---------- */
  Bridge.on('capps:defs', loadDefs);
  let lastJob = null;
  Bridge.on('player:update', p => { const j = p && p.job ? [p.job.name, p.job.grade, p.job.gradeLevel, p.job.onduty].join('|') : ''; if (j === lastJob) return; lastJob = j; if (ORDER.length) { apply(); if (System.ready) refreshAccess(); } });
  Bridge.on('ready', () => { if (Bridge.inFiveM) Promise.resolve(Bridge.call('capps:get')).then(v => { if (v) loadDefs(v); }); refreshAccess(); });
  Bridge.on('session:changed', () => { ACC = null; REV = null; Object.keys(SIDE).forEach(k => delete SIDE[k]); if (Bridge.inFiveM) Promise.resolve(Bridge.call('capps:get')).then(v => { if (v) loadDefs(v); }); });
  /* no jogo: pede ja as definicoes (antes do 'ready', para a home as encontrar no primeiro desenho) */
  if (Bridge.inFiveM) Promise.resolve(Bridge.call('capps:get')).then(v => { if (v) loadDefs(v); }).catch(() => {});

  /* ===================== MOCKS (browser / harness, sem FiveM) =====================
     Quatro apps de demonstracao (policia, hospital, mecanico, restaurante) e um servidor em memoria com o mesmo contrato
     dos capps.* (incluindo v2: mods/can no capps.access, encomendas, faturas, servico, capps.bill/nearby/duty).
     CApps.mock.job('police', 3) muda o emprego do jogador de teste; CApps.mock.side(id, 'civil'|'staff') muda o lado. */
  let mock = null;
  if (!Bridge.inFiveM && window.LocalDB && LocalDB.register) {
    const now = Date.now(), H = 36e5, Mi = 6e4;
    const DEMO = [
      { id: 'lspd', name: 'LSPD', subtitle: 'Polícia de Los Santos', description: 'Denúncias, ocorrências e comunicados da polícia da cidade.', icon: { glyph: 'badge', bg: '#2F6BFF', bg2: '#0B2A8A', fg: '#FFFFFF' }, accent: '#2F6BFF', category: 'Serviços públicos', enabled: true, listed: true, preinstalled: true,
        audience: { public: true, jobs: [{ name: 'police', minGrade: 0 }], onDutyOnly: false }, contact: { phone: '911', label: 'Emergência' }, notify: { staff: true },
        modules: [
          { id: 'reports', type: 'form', title: 'Denúncias', icon: 'flag', enabled: true, civil: true, staff: true, staffMinGrade: 0, perms: { delete: 3, assign: 1 }, options: { intro: 'Viste alguma coisa? Conta-nos. Podes enviar como anónimo.', anonymous: true, location: true, photo: false, civilSeesOwn: true, replies: true, submitLabel: 'Enviar denúncia', deleteGrade: 3,
            fields: [{ key: 'tipo', label: 'Tipo de ocorrência', type: 'select', required: true, options: ['Roubo', 'Agressão', 'Vandalismo', 'Tráfico', 'Outro'] }, { key: 'outro', label: 'Qual?', type: 'text', required: true, placeholder: 'Descreve o tipo', showIf: { key: 'tipo', equals: 'Outro' } }, { key: 'local', label: 'Local', type: 'text', required: true, placeholder: 'Ex.: Vinewood Boulevard' }, { key: 'quando', label: 'Data', type: 'date' }, { key: 'hora', label: 'Hora aproximada', type: 'time' }, { key: 'matricula', label: 'Matrícula envolvida', type: 'plate' }, { key: 'descricao', label: 'O que aconteceu', type: 'textarea', required: true, min: 10, placeholder: 'Descreve com o máximo de detalhe', help: 'Quanto mais detalhe, mais depressa conseguimos agir.' }, { key: 'testemunhas', label: 'Há testemunhas', type: 'checkbox' }, { key: 'quem', label: 'Contacto das testemunhas', type: 'textarea', showIf: { key: 'testemunhas', equals: 'true' } }],
            statuses: [{ id: 'new', label: 'Nova', color: '#0A84FF' }, { id: 'review', label: 'Em investigação', color: '#FF9F0A' }, { id: 'solved', label: 'Resolvida', color: '#30A46C', closed: true }, { id: 'archived', label: 'Arquivada', color: '#8E8E93', closed: true, notify: false }] } },
          { id: 'calls', type: 'dispatch', title: 'Ocorrências', icon: 'siren', enabled: true, civil: true, staff: true, options: { location: true, cooldown: 60, types: [{ id: 'robbery', label: 'Assalto', icon: 'handcuffs' }, { id: 'crash', label: 'Acidente', icon: 'car' }, { id: 'fight', label: 'Agressão', icon: 'siren' }, { id: 'other', label: 'Outro', icon: 'bell' }] } },
          { id: 'records', type: 'records', title: 'Fichas', icon: 'idCard', enabled: true, civil: false, staff: true, staffMinGrade: 1, options: { subject: 'person', civilSeesOwn: false, tags: [{ id: 'warrant', label: 'Mandado ativo', color: '#FF3B30' }, { id: 'danger', label: 'Perigoso', color: '#FF9F0A' }, { id: 'watch', label: 'Sob vigilância', color: '#AF52DE' }],
            fields: [{ key: 'nascimento', label: 'Data de nascimento', type: 'date' }, { key: 'telefone', label: 'Telefone', type: 'phone' }, { key: 'antecedentes', label: 'Antecedentes', type: 'textarea' }] } },
          { id: 'news', type: 'posts', title: 'Comunicados', icon: 'megaphone', enabled: true, civil: true, staff: true, options: { postGrade: 2, notifyAll: true } },
          { id: 'team', type: 'roster', title: 'Equipa', icon: 'users', enabled: true, civil: false, staff: true, options: { showOffDuty: true } },
          { id: 'station', type: 'info', title: 'Esquadra', icon: 'building', enabled: true, civil: true, staff: true, options: { blocks: [{ type: 'hours', title: 'Atendimento ao público', hours: { from: 8, to: 22, days: [1, 2, 3, 4, 5, 6, 7] } }, { type: 'location', title: 'Mission Row', text: 'Esquadra central, Mission Row 1', x: 441.2, y: -981.9 }, { type: 'contact', title: 'Linha não urgente', phone: '555-0110' }, { type: 'text', title: 'Perdidos e achados', text: 'Objetos encontrados ficam 30 dias na receção. Traz um documento de identificação.' }] } },
          { id: 'board', type: 'posts', title: 'Quadro interno', icon: 'clipboard', enabled: true, civil: false, staff: true, options: { audience: 'staff', postGrade: 1, pinLimit: 2 } },
          { id: 'fines', type: 'billing', title: 'Multas', icon: 'ticket', enabled: true, civil: false, staff: true, options: { society: true, maxAmount: 5000, reasonRequired: true, presets: [{ label: 'Excesso de velocidade', amount: 250 }, { label: 'Estacionamento proibido', amount: 80 }, { label: 'Condução sem carta', amount: 1000 }] } },
          { id: 'duty', type: 'duty', title: 'Em serviço', icon: 'clock', enabled: true, civil: false, staff: true, options: { showTeam: true } },
        ] },
      { id: 'pillbox', name: 'Pillbox', subtitle: 'Hospital Central', description: 'Consultas, ambulância e fichas clínicas do Pillbox Medical.', icon: { glyph: 'heartPulse', bg: '#FF4D6D', bg2: '#A3123A', fg: '#FFFFFF' }, accent: '#E8364F', category: 'Serviços públicos', enabled: true, listed: true, preinstalled: true,
        audience: { public: true, jobs: [{ name: 'ambulance', minGrade: 0 }], onDutyOnly: true }, contact: { phone: '912', label: 'Urgência' }, notify: { staff: true },
        modules: [
          { id: 'appts', type: 'appointments', title: 'Consultas', icon: 'stethoscope', enabled: true, civil: true, staff: true, options: { services: [{ id: 'gp', label: 'Consulta geral', minutes: 30 }, { id: 'triage', label: 'Triagem', minutes: 15 }, { id: 'exams', label: 'Exames', minutes: 45 }], hours: { from: 9, to: 21 }, days: [1, 2, 3, 4, 5, 6], slot: 30, maxPerSlot: 2, notes: true } },
          { id: 'ems', type: 'dispatch', title: 'Ambulância', icon: 'siren', enabled: true, civil: true, staff: true, options: { location: true, cooldown: 90, types: [{ id: 'hurt', label: 'Ferido', icon: 'medical' }, { id: 'down', label: 'Inconsciente', icon: 'heartPulse' }, { id: 'other', label: 'Outro', icon: 'bell' }] } },
          { id: 'charts', type: 'records', title: 'Fichas clínicas', icon: 'clipboard', enabled: true, civil: true, staff: true, options: { subject: 'person', civilSeesOwn: true, tags: [{ id: 'allergy', label: 'Alergias', color: '#FF3B30' }, { id: 'chronic', label: 'Crónico', color: '#0A84FF' }], fields: [{ key: 'sangue', label: 'Grupo sanguíneo', type: 'select', options: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'] }, { key: 'notas', label: 'Notas clínicas', type: 'textarea' }] } },
          { id: 'crew', type: 'roster', title: 'Equipa', icon: 'users', enabled: true, civil: false, staff: true, options: {} },
          { id: 'about', type: 'info', title: 'Hospital', icon: 'hospital', enabled: true, civil: true, staff: true, options: { blocks: [{ type: 'hours', title: 'Consultas', hours: { from: 9, to: 21, days: [1, 2, 3, 4, 5, 6] } }, { type: 'location', title: 'Pillbox Hill', text: 'Entrada das urgências pela rua de trás.', x: 298.6, y: -584.4 }] } },
          { id: 'shift', type: 'duty', title: 'Em serviço', icon: 'clock', enabled: true, civil: false, staff: true, options: { showTeam: true } },
        ] },
      { id: 'bennys', name: "Benny's", subtitle: 'Oficina e reboque', description: 'Pede reboque e marca a revisão do teu carro.', icon: { glyph: 'wrench', bg: '#FF9F0A', bg2: '#B4380B', fg: '#FFFFFF' }, accent: '#F07B12', category: 'Empresas', enabled: true, listed: true, preinstalled: false,
        audience: { public: true, jobs: [{ name: 'mechanic', minGrade: 0 }], onDutyOnly: true }, contact: { phone: '555-0177', label: "Benny's" },
        modules: [
          { id: 'tow', type: 'dispatch', title: 'Reboque', icon: 'towTruck', enabled: true, civil: true, staff: true, options: { location: true, cooldown: 60, types: [{ id: 'tow', label: 'Reboque', icon: 'towTruck' }, { id: 'repair', label: 'Reparação no local', icon: 'wrench' }] } },
          { id: 'book', type: 'appointments', title: 'Marcações', icon: 'calendar', enabled: true, civil: true, staff: true, options: { services: [{ id: 'service', label: 'Revisão', minutes: 60 }, { id: 'tune', label: 'Tuning', minutes: 120 }], hours: { from: 10, to: 20 }, days: [1, 2, 3, 4, 5], slot: 60, maxPerSlot: 1 } },
          { id: 'prices', type: 'catalog', title: 'Preçário', icon: 'tag', enabled: true, civil: true, staff: true, options: { orderable: false, currency: '',categories: ['Manutenção', 'Tuning'], items: [{ id: 'oil', label: 'Mudança de óleo', desc: 'Óleo sintético e filtro novo.', price: 120, category: 'Manutenção' }, { id: 'brakes', label: 'Travões', desc: 'Pastilhas e discos, eixo da frente.', price: 340, category: 'Manutenção' }, { id: 'tint', label: 'Vidros fumados', price: 260, category: 'Tuning' }, { id: 'turbo', label: 'Turbo', desc: 'Instalação e afinação.', price: 4500, category: 'Tuning' }] } },
          { id: 'history', type: 'records', title: 'Histórico', icon: 'car', enabled: true, civil: false, staff: true, options: { subject: 'vehicle', fields: [{ key: 'modelo', label: 'Modelo', type: 'text' }, { key: 'km', label: 'Quilómetros', type: 'number' }, { key: 'trabalho', label: 'Trabalho feito', type: 'textarea' }] } },
        ] },
      { id: 'burgershot', name: 'Burger Shot', subtitle: 'Hambúrgueres em Vespucci', description: 'Faz a tua encomenda e levanta ao balcão ou recebe em casa.', icon: { glyph: 'food', bg: '#FF7A2E', bg2: '#B3260B', fg: '#FFFFFF' }, accent: '#F2551D', category: 'Empresas', enabled: true, listed: true, preinstalled: true,
        audience: { public: true, jobs: [{ name: 'burgershot', minGrade: 0 }], onDutyOnly: false }, contact: { phone: '555-0420', label: 'Burger Shot' }, notify: { staff: true },
        modules: [
          { id: 'menu', type: 'catalog', title: 'Menu', icon: 'food', enabled: true, civil: true, staff: true, options: { orderable: true, maxQty: 10, location: true, currency: '',billing: true, intro: '',
            categories: ['Hambúrgueres', 'Acompanhamentos', 'Bebidas', 'Sobremesas'],
            items: [{ id: 'bleeder', label: 'The Bleeder', desc: 'Carne dupla, cheddar, cebola caramelizada e molho da casa.', price: 8.5, category: 'Hambúrgueres' }, { id: 'heart', label: 'Heart Stopper', desc: 'Quatro carnes, bacon e três queijos. Só para corajosos.', price: 12.9, category: 'Hambúrgueres' }, { id: 'money', label: 'Money Shot', desc: 'Frango crocante, alface e maionese de alho.', price: 7.2, category: 'Hambúrgueres' }, { id: 'veggie', label: 'Torpedo Vegetariano', desc: 'Hambúrguer de grão com abacate.', price: 7.9, category: 'Hambúrgueres', available: false },
              { id: 'fries', label: 'Batatas fritas', desc: 'Grandes e estaladiças, com sal marinho.', price: 3.2, category: 'Acompanhamentos' }, { id: 'rings', label: 'Aros de cebola', price: 3.6, category: 'Acompanhamentos' }, { id: 'cola', label: 'eCola', desc: '33 cl, bem fresca.', price: 2, category: 'Bebidas' }, { id: 'shake', label: 'Batido de baunilha', price: 4.5, category: 'Sobremesas' }],
            fields: [{ key: 'entrega', label: 'Como queres receber?', type: 'select', required: true, options: ['Levantar ao balcão', 'Entrega ao domicílio'] }, { key: 'morada', label: 'Morada', type: 'text', required: true, placeholder: 'Rua e número', showIf: { key: 'entrega', equals: 'Entrega ao domicílio' } }, { key: 'notas', label: 'Notas', type: 'textarea', placeholder: 'Sem cebola, molho à parte...' }],
            statuses: [{ id: 'new', label: 'Recebida', color: '#0A84FF' }, { id: 'kitchen', label: 'Na cozinha', color: '#FF9F0A' }, { id: 'ready', label: 'Pronta', color: '#30A46C' }, { id: 'done', label: 'Entregue', color: '#8E8E93', closed: true }, { id: 'cancelled', label: 'Cancelada', color: '#FF453A', closed: true }] } },
          { id: 'fat', type: 'billing', title: 'Faturação', icon: 'coins', enabled: true, civil: false, staff: true, options: { society: true, maxAmount: 2000, reasonRequired: true, presets: [{ label: 'Menu do dia', amount: 12 }, { label: 'Catering', amount: 250 }] } },
          { id: 'svc', type: 'duty', title: 'Em serviço', icon: 'clock', enabled: true, civil: false, staff: true, options: { showTeam: true } },
          { id: 'jobs', type: 'form', title: 'Candidaturas', icon: 'briefcase', enabled: true, civil: true, staff: true, staffMinGrade: 1, perms: { delete: 3 }, options: { intro: 'Queres trabalhar connosco? Preenche a candidatura e respondemos em 48 horas.', civilSeesOwn: true, replies: true, submitLabel: 'Enviar candidatura',
            fields: [{ key: 's1', label: 'Sobre ti', type: 'section' }, { key: 'nome', label: 'Nome completo', type: 'text', required: true, min: 3, max: 40 }, { key: 'idade', label: 'Idade', type: 'number', required: true, min: 16, max: 80 }, { key: 'email', label: 'Email', type: 'email', placeholder: 'nome@exemplo.com' },
              { key: 's2', label: 'Disponibilidade', type: 'section', help: 'Turnos de 6 horas.' }, { key: 'dias', label: 'Dias', type: 'multiselect', required: true, min: 1, options: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'] }, { key: 'hora', label: 'A partir das', type: 'time', default: '18:00' }, { key: 'exp', label: 'Já trabalhaste num restaurante?', type: 'checkbox' }, { key: 'onde', label: 'Onde e quanto tempo?', type: 'textarea', required: true, showIf: { key: 'exp', equals: 'true' } }, { key: 'nota', label: 'Como avalias o teu atendimento?', type: 'rating' }, { key: 'foto', label: 'Fotografia', type: 'photo', help: 'Opcional. Uma ligação https da imagem.' }, { key: 'cv', label: 'Currículo (ligação)', type: 'url' }, { key: 'i1', label: 'Importante', type: 'info', help: 'Os dados ficam só com a gerência do Burger Shot.' }],
            statuses: [{ id: 'new', label: 'Nova', color: '#0A84FF' }, { id: 'interview', label: 'Entrevista', color: '#FF9F0A' }, { id: 'hired', label: 'Contratado', color: '#30A46C', closed: true }, { id: 'no', label: 'Recusada', color: '#8E8E93', closed: true }] } },
          { id: 'about', type: 'info', title: 'Restaurante', icon: 'store', enabled: true, civil: true, staff: true, options: { blocks: [{ type: 'hours', title: 'Aberto', hours: { from: 11, to: 23, days: [1, 2, 3, 4, 5, 6, 7] } }, { type: 'location', title: 'Del Perro', text: 'Prosperity Street, ao lado do cais.', x: -1183.7, y: -884.3 }, { type: 'contact', title: 'Encomendas por telefone', phone: '555-0420' }] } },
        ] },
    ];
    let MJOB = { name: 'unemployed', label: 'Desempregado', grade: 0, onduty: true };
    let seq = 1000, nseq = 5000, bseq = 70010;
    const ME = () => LocalDB.cid || 'DEV0000';
    const meName = () => { const p = LocalDB.player() || {}; return ((p.firstname || 'Jogador') + ' ' + (p.lastname || '')).trim(); };
    const today = new Date(); const dayK = off => isoDay(new Date(today.getFullYear(), today.getMonth(), today.getDate() + off));
    const at = (off, hm) => { const [h, mm] = hm.split(':').map(Number); return new Date(today.getFullYear(), today.getMonth(), today.getDate() + off, h, mm).getTime(); };
    const ITEMS = [], NOTES = [];
    const add = r => { r.id = r.id || ++seq; r.created = r.created || now; r.updated = r.updated || r.created; ITEMS.push(r); return r; };
    /* LSPD */
    add({ app: 'lspd', module: 'reports', kind: 'form', owner: 'C1', owner_name: 'Marta Ribeiro', owner_phone: '555-2041', status: 'new', title: 'Roubo', data: { fields: { tipo: 'Roubo', local: 'Loja 24/7 de Strawberry', descricao: 'Dois indivíduos encapuzados levaram a caixa registadora e fugiram num Sultan preto.', matricula: '46EEK572', testemunhas: true, quem: 'O dono da loja, Sr. Abel, 555-7781.', hora: '22:40' }, order: ['tipo', 'local', 'hora', 'descricao', 'matricula', 'testemunhas', 'quem'] }, x: 25.7, y: -1347.3, created: now - 9 * Mi });
    add({ app: 'lspd', module: 'reports', kind: 'form', owner: 'C2', anonymous: true, status: 'new', title: 'Tráfico', data: { fields: { tipo: 'Tráfico', local: 'Grove Street', descricao: 'Movimento estranho todas as noites junto à garagem azul.' }, order: ['tipo', 'local', 'descricao'] }, created: now - 42 * Mi });
    add({ app: 'lspd', module: 'reports', kind: 'form', owner: 'DEV0000', owner_name: 'Jogador Teste', owner_phone: '555-0142', status: 'review', title: 'Vandalismo', assignee: 'P2', assignee_name: 'Sgt. Rui Costa', data: { fields: { tipo: 'Vandalismo', local: 'Parque de Vespucci', descricao: 'Grafitis no mural novo do parque.', quando: dayK(-1) }, order: ['tipo', 'local', 'quando', 'descricao'] }, created: now - 5 * H, updated: now - 2 * H });
    add({ app: 'lspd', module: 'reports', kind: 'form', owner: 'C3', owner_name: 'Luís Almeida', owner_phone: '555-3377', status: 'review', title: 'Agressão', assignee: 'DEV0000', assignee_name: 'Jogador Teste', data: { fields: { tipo: 'Agressão', local: 'Bahama Mamas', descricao: 'Fui agredido à saída da discoteca por um segurança.' }, order: ['tipo', 'local', 'descricao'] }, created: now - 26 * H, updated: now - 20 * H });
    add({ app: 'lspd', module: 'reports', kind: 'form', owner: 'C4', owner_name: 'Inês Pinto', owner_phone: '555-8890', status: 'solved', title: 'Roubo', data: { fields: { tipo: 'Roubo', local: 'Del Perro Pier', descricao: 'Roubaram-me a bicicleta.' }, order: ['tipo', 'local', 'descricao'] }, created: now - 3 * 24 * H });
    NOTES.push({ id: ++nseq, item: 1003, author: 'P2', author_name: 'Sgt. Rui Costa', staff: true, private: false, text: 'Obrigado pela denúncia. Já temos uma patrulha a verificar as câmaras da zona.', created: now - 3 * H });
    NOTES.push({ id: ++nseq, item: 1003, author: 'DEV0000', author_name: 'Jogador Teste', staff: false, private: false, text: 'Obrigado! Vi um carro cinzento parado lá perto nessa noite.', created: now - 2.5 * H });
    NOTES.push({ id: ++nseq, item: 1003, author: 'P2', author_name: 'Sgt. Rui Costa', staff: true, private: true, text: 'Cruzar com o relatório do turno da noite.', created: now - 2 * H });
    add({ app: 'lspd', module: 'calls', kind: 'call', owner: 'C5', owner_name: 'Tiago Matos', owner_phone: '555-1010', status: 'waiting', title: 'Assalto', data: { type: 'robbery', type_label: 'Assalto', message: 'Estão a assaltar a joalharia agora!' }, x: -630.4, y: -236.7, created: now - 2 * Mi });
    add({ app: 'lspd', module: 'calls', kind: 'call', owner: 'C6', owner_name: 'Sofia Lopes', owner_phone: '555-4420', status: 'accepted', assignee: 'P3', assignee_name: 'Agente Ana Reis', title: 'Acidente', data: { type: 'crash', type_label: 'Acidente', message: 'Colisão na autoestrada, dois carros.' }, x: 1102.1, y: -1540.2, created: now - 14 * Mi });
    add({ app: 'lspd', module: 'calls', kind: 'call', owner: 'C7', owner_name: 'Pedro Nunes', owner_phone: '555-6600', status: 'done', title: 'Agressão', data: { type: 'fight', type_label: 'Agressão', message: 'Briga à porta do bar.' }, x: 120, y: -1290, created: now - 3 * H });
    add({ app: 'lspd', module: 'records', kind: 'record', owner: null, status: 'open', title: 'Carlos Mendes', subject: 'Carlos Mendes', assignee: 'P2', assignee_name: 'Sgt. Rui Costa', data: { fields: { nascimento: '1991-04-12', telefone: '555-3912', antecedentes: 'Furto qualificado (2025). Condução sem carta.' }, order: ['nascimento', 'telefone', 'antecedentes'], tags: ['warrant', 'danger'], author: 'Sgt. Rui Costa' }, created: now - 4 * 24 * H, updated: now - 6 * H });
    add({ app: 'lspd', module: 'records', kind: 'record', owner: null, status: 'open', title: 'Joana Freitas', subject: 'Joana Freitas', assignee: 'P3', assignee_name: 'Agente Ana Reis', data: { fields: { telefone: '555-7781' }, order: ['telefone'], tags: ['watch'], author: 'Agente Ana Reis' }, created: now - 9 * 24 * H, updated: now - 2 * 24 * H });
    add({ app: 'lspd', module: 'records', kind: 'record', owner: null, status: 'archived', title: 'Bruno Sá', subject: 'Bruno Sá', data: { fields: { antecedentes: 'Excesso de velocidade.' }, order: ['antecedentes'], tags: [], author: 'Cap. Helena Duarte' }, created: now - 30 * 24 * H });
    NOTES.push({ id: ++nseq, item: 1009, author: 'P2', author_name: 'Sgt. Rui Costa', staff: true, private: false, text: 'Mandado emitido pelo juiz Moreira. Abordar com reforço.', created: now - 6 * H });
    add({ app: 'lspd', module: 'news', kind: 'post', status: 'published', pinned: true, title: 'Operação Stop este fim de semana', assignee_name: 'Cap. Helena Duarte', data: { body: 'Durante o fim de semana vão estar operações stop na Great Ocean Highway e em Vinewood. Tenham os documentos em dia e conduzam com cuidado.', author: 'Cap. Helena Duarte' }, created: now - 20 * H });
    add({ app: 'lspd', module: 'news', kind: 'post', status: 'published', title: 'Recrutamento aberto', assignee_name: 'Cap. Helena Duarte', data: { body: 'A LSPD está a recrutar novos agentes. Candidaturas na receção da esquadra de Mission Row até ao fim do mês.', author: 'Cap. Helena Duarte' }, created: now - 3 * 24 * H });
    add({ app: 'lspd', module: 'news', kind: 'post', status: 'published', title: 'Bicicletas roubadas recuperadas', assignee_name: 'Agente Ana Reis', data: { body: 'Recuperámos 12 bicicletas no armazém de La Mesa. Se te roubaram uma, passa na esquadra com a fatura ou uma foto.', author: 'Agente Ana Reis' }, created: now - 6 * 24 * H });
    add({ app: 'lspd', module: 'board', kind: 'post', status: 'published', pinned: true, title: 'Briefing às 20:00', assignee_name: 'Cap. Helena Duarte', data: { body: 'Toda a gente do turno da noite na sala de briefing. Vamos rever a operação de sábado.', author: 'Cap. Helena Duarte' }, created: now - 3 * H });
    add({ app: 'lspd', module: 'board', kind: 'post', status: 'published', title: 'Viatura 12 na oficina', assignee_name: 'Sgt. Rui Costa', data: { body: 'A viatura 12 fica na Benny\'s até quinta. Usem a 15.', author: 'Sgt. Rui Costa' }, created: now - 26 * H });
    add({ app: 'lspd', module: 'fines', kind: 'bill', owner: 'C5', owner_name: 'Tiago Matos', owner_phone: '555-1010', status: 'pending', title: 'Excesso de velocidade', assignee: 'DEV0000', assignee_name: 'Jogador Teste', data: { billId: ++bseq, amount: 250, reason: 'Excesso de velocidade', to: '555-1010', society: 'police' }, created: now - 25 * Mi });
    add({ app: 'lspd', module: 'fines', kind: 'bill', owner: 'C6', owner_name: 'Sofia Lopes', owner_phone: '555-4420', status: 'paid', title: 'Estacionamento proibido', assignee: 'P3', assignee_name: 'Agente Ana Reis', data: { billId: ++bseq, amount: 80, reason: 'Estacionamento proibido', to: '555-4420', society: 'police' }, created: now - 5 * H });
    add({ app: 'lspd', module: 'fines', kind: 'bill', owner: 'C8', owner_name: 'Rui Pereira', owner_phone: '555-6612', status: 'refused', title: 'Condução sem carta', assignee: 'P2', assignee_name: 'Sgt. Rui Costa', data: { billId: ++bseq, amount: 1000, reason: 'Condução sem carta', to: '555-6612', society: 'police' }, created: now - 2 * 24 * H });
    /* Pillbox */
    add({ app: 'pillbox', module: 'appts', kind: 'appt', owner: 'C8', owner_name: 'Rita Sousa', owner_phone: '555-2290', status: 'pending', title: 'Consulta geral', at: at(0, '15:00'), data: { day: dayK(0), time: '15:00', service: 'gp', service_label: 'Consulta geral', minutes: 30, notes: 'Dores de cabeça frequentes.' }, created: now - 3 * H });
    add({ app: 'pillbox', module: 'appts', kind: 'appt', owner: 'C9', owner_name: 'Hugo Ferreira', owner_phone: '555-9012', status: 'confirmed', title: 'Exames', at: at(0, '16:30'), assignee_name: 'Dra. Clara Neves', data: { day: dayK(0), time: '16:30', service: 'exams', service_label: 'Exames', minutes: 45 }, created: now - 26 * H });
    add({ app: 'pillbox', module: 'appts', kind: 'appt', owner: 'C10', owner_name: 'Daniela Cruz', owner_phone: '555-4545', status: 'confirmed', title: 'Triagem', at: at(0, '18:00'), data: { day: dayK(0), time: '18:00', service: 'triage', service_label: 'Triagem', minutes: 15 }, created: now - 8 * H });
    add({ app: 'pillbox', module: 'appts', kind: 'appt', owner: 'DEV0000', owner_name: 'Jogador Teste', owner_phone: '555-0142', status: 'confirmed', title: 'Consulta geral', at: at(2, '10:00'), data: { day: dayK(2), time: '10:00', service: 'gp', service_label: 'Consulta geral', minutes: 30 }, created: now - 30 * Mi });
    add({ app: 'pillbox', module: 'ems', kind: 'call', owner: 'C11', owner_name: 'André Lima', owner_phone: '555-3131', status: 'waiting', title: 'Inconsciente', data: { type: 'down', type_label: 'Inconsciente', message: 'Homem caído na paragem de autocarro.' }, x: 200.4, y: -800.2, created: now - 4 * Mi });
    add({ app: 'pillbox', module: 'charts', kind: 'record', owner: 'DEV0000', owner_name: 'Jogador Teste', status: 'open', title: 'Jogador Teste', subject: 'Jogador Teste', data: { fields: { sangue: 'O+', notas: 'Alergia à penicilina.' }, order: ['sangue', 'notas'], tags: ['allergy'], author: 'Dra. Clara Neves' }, created: now - 12 * 24 * H, updated: now - 5 * 24 * H });
    /* Burger Shot */
    const BS = DEMO.find(d => d.id === 'burgershot'); const bsMenu = BS.modules[0].options.items;
    const lines = list => { const ls = list.map(([id, qty]) => { const it = bsMenu.find(x => x.id === id); return { id, label: it.label, price: it.price, qty }; }); const total = Math.round(ls.reduce((s, l) => s + l.price * l.qty, 0) * 100) / 100; return { lines: ls, total, count: ls.reduce((s, l) => s + l.qty, 0), currency: UI.cur() }; };
    add({ app: 'burgershot', module: 'menu', kind: 'order', owner: 'C21', owner_name: 'Marta Ribeiro', owner_phone: '555-2041', status: 'new', title: 'The Bleeder +2', data: Object.assign(lines([['bleeder', 2], ['fries', 2], ['cola', 2]]), { fields: { entrega: 'Entrega ao domicílio', morada: 'Grove Street 12, 2.º esq.', notas: 'Sem cebola no segundo hambúrguer.' }, order: ['entrega', 'morada', 'notas'] }), x: 104.2, y: -1938.6, created: now - 3 * Mi });
    add({ app: 'burgershot', module: 'menu', kind: 'order', owner: 'C22', owner_name: 'Hugo Ferreira', owner_phone: '555-9012', status: 'kitchen', title: 'Heart Stopper +2', assignee: 'B2', assignee_name: 'Lena Prado', data: Object.assign(lines([['heart', 1], ['rings', 1], ['shake', 1]]), { fields: { entrega: 'Levantar ao balcão' }, order: ['entrega'] }), created: now - 11 * Mi });
    add({ app: 'burgershot', module: 'menu', kind: 'order', owner: 'C23', owner_name: 'Rita Sousa', owner_phone: '555-2290', status: 'ready', title: 'Money Shot +1', data: Object.assign(lines([['money', 3], ['cola', 3]]), { fields: { entrega: 'Levantar ao balcão' }, order: ['entrega'], billId: 70020, billAmount: 28 }), created: now - 24 * Mi });
    add({ app: 'burgershot', module: 'menu', kind: 'order', owner: 'DEV0000', owner_name: 'Jogador Teste', owner_phone: '555-0142', status: 'kitchen', title: 'The Bleeder +2', data: Object.assign(lines([['bleeder', 1], ['fries', 1], ['cola', 1]]), { fields: { entrega: 'Levantar ao balcão' }, order: ['entrega'] }), created: now - 7 * Mi });
    add({ app: 'burgershot', module: 'menu', kind: 'order', owner: 'DEV0000', owner_name: 'Jogador Teste', owner_phone: '555-0142', status: 'done', title: 'Heart Stopper', data: Object.assign(lines([['heart', 1]]), { fields: { entrega: 'Levantar ao balcão' }, order: ['entrega'] }), created: now - 2 * 24 * H });
    add({ app: 'burgershot', module: 'fat', kind: 'bill', owner: 'C23', owner_name: 'Rita Sousa', owner_phone: '555-2290', status: 'paid', title: 'Burger Shot · Menu #1013', assignee: 'B2', assignee_name: 'Lena Prado', data: { billId: 70020, amount: 28, reason: 'Burger Shot · Menu #1013', to: '555-2290', society: 'burgershot' }, created: now - 20 * Mi });
    add({ app: 'burgershot', module: 'fat', kind: 'bill', owner: 'C30', owner_name: 'Weazel News', owner_phone: '555-0303', status: 'pending', title: 'Catering', assignee: 'DEV0000', assignee_name: 'Jogador Teste', data: { billId: 70021, amount: 250, reason: 'Catering', to: '555-0303', society: 'burgershot' }, created: now - 3 * H });
    add({ app: 'burgershot', module: 'jobs', kind: 'form', owner: 'C31', owner_name: 'Beatriz Lobo', owner_phone: '555-8123', status: 'new', title: 'Beatriz Lobo', data: { fields: { nome: 'Beatriz Lobo', idade: 22, email: 'bia.lobo@mail.ls', dias: ['Sex', 'Sáb', 'Dom'], hora: '18:00', exp: true, onde: 'Dois anos no Up-n-Atom de Vinewood.', nota: 4, cv: 'https://docs.ls/cv/beatriz-lobo' }, order: ['nome', 'idade', 'email', 'dias', 'hora', 'exp', 'onde', 'nota', 'cv'] }, created: now - 50 * Mi });
    add({ app: 'burgershot', module: 'jobs', kind: 'form', owner: 'C32', owner_name: 'Nuno Faria', owner_phone: '555-4477', status: 'interview', title: 'Nuno Faria', data: { fields: { nome: 'Nuno Faria', idade: 19, dias: ['Seg', 'Ter'], exp: false, nota: 3 }, order: ['nome', 'idade', 'dias', 'exp', 'nota'] }, created: now - 26 * H });
    const ROSTER = { police: [['Cap. Helena Duarte', 'Capitã', 4, true, '555-0201'], ['Sgt. Rui Costa', 'Sargento', 3, true, '555-0202'], ['Agente Ana Reis', 'Agente', 1, true, '555-0203'], ['Agente Nuno Faria', 'Agente', 1, false, '555-0204'], ['Cadete Bia Mota', 'Cadete', 0, true, '555-0205']], ambulance: [['Dra. Clara Neves', 'Diretora', 4, true, '555-0301'], ['Enf. Paulo Vaz', 'Enfermeiro', 2, true, '555-0302'], ['Param. Joana Leal', 'Paramédica', 1, false, '555-0303']], mechanic: [['Benny', 'Dono', 4, true, '555-0401']], burgershot: [['Lena Prado', 'Gerente', 3, true, '555-0421'], ['Duarte Gil', 'Cozinheiro', 1, true, '555-0422'], ['Sara Moniz', 'Caixa', 0, false, '555-0423']] };
    const LABEL = { police: 'LSPD', ambulance: 'EMS', mechanic: "Benny's", burgershot: 'Burger Shot' };
    const JLABEL = { police: 'Polícia', ambulance: 'EMS', mechanic: 'Mecânico', burgershot: 'Burger Shot' };
    const mDef = id => DEMO.find(d => d.id === id);
    /* o mesmo calculo do server/capps.lua (permNeed, staffOn, civilOn) */
    const permNeedM = (m, a) => { const base = +m.staffMinGrade || 0; const o = m.options || {}; let d = base;
      if (a === 'delete') { const g = o.deleteGrade != null ? o.deleteGrade : (m.type === 'posts' ? o.postGrade : null); if (g != null) d = +g; }
      else if (a === 'create' && m.type === 'posts' && o.postGrade != null) d = +o.postGrade;
      const P = m.perms || {}; return P[a] != null && isFinite(+P[a]) ? +P[a] : d; };
    const mAcc = def => { const member = def.audience.jobs.some(j => j.name === MJOB.name && MJOB.grade >= (j.minGrade || 0)); const staff = member && (!def.audience.onDutyOnly || MJOB.onduty); const civil = def.audience.public !== false;
      const a = { member, staff, civil, grade: MJOB.grade, onduty: MJOB.onduty, job: member ? MJOB.name : undefined, mods: {} };
      def.modules.forEach(m => { if (m.enabled === false) return; const jobs = arrOf(m.jobs); const o = m.options || {};
        const s = member && m.staff !== false && (!jobs.length || jobs.includes(MJOB.name)) && MJOB.grade >= permNeedM(m, 'view') && (m.type === 'duty' || staff);
        const c = civil && m.civil !== false && !STAFF_ONLY[m.type] && (m.type !== 'records' || o.civilSeesOwn === true) && (m.type !== 'posts' || o.audience !== 'staff');
        if (!s && !c) return; const e = { staff: s, civil: c }; if (s) { e.can = {}; ['view', 'reply', 'status', 'assign', 'delete', 'create'].forEach(k => { e.can[k] = MJOB.grade >= permNeedM(m, k); }); } a.mods[m.id] = e; });
      return a; };
    const mCtx = (d, side) => { const def = mDef(d.app); if (!def) return { error: 'app' }; const m = def.modules.find(x => x.id === d.module); if (!m) return { error: 'module' }; const a = mAcc(def); side = side === 'staff' ? 'staff' : 'civil';
      const x = a.mods[m.id]; if (!(x && x[side])) return { error: side === 'staff' && a.member && !a.staff ? 'offduty' : 'forbidden' }; return { def, m, a, side, kind: kindOf(m) }; };
    const mCan = (c, k) => c.side === 'staff' && c.a.grade >= permNeedM(c.m, k);
    const closedOf = (m, k, s) => stInfo(m, k, s).closed;
    const out = (r, c, full) => { const o = { id: r.id, app: r.app, module: r.module, kind: r.kind, status: r.status, title: r.title, subject: r.subject, anonymous: !!r.anonymous, mine: r.owner === ME() || undefined, pinned: !!r.pinned, created: r.created, updated: r.updated, at: r.at, assignee_name: r.assignee_name, assigned: r.assignee === ME() || undefined };
      if (!r.anonymous) o.owner_name = r.owner_name; if (c.side === 'staff' && !r.anonymous) o.owner_phone = r.owner_phone; if (c.side === 'staff' || r.owner === ME()) { o.x = r.x; o.y = r.y; }
      const d = r.data || {}; if (r.kind === 'appt') Object.assign(o, { day: d.day, time: d.time, service: d.service, service_label: d.service_label }); if (r.kind === 'call') o.type = d.type; if (r.kind === 'post') o.image = d.image; if (r.kind === 'record') o.tags = d.tags;
      if (r.kind === 'order') Object.assign(o, { total: d.total, count: d.count, currency: d.currency, billId: d.billId }); if (r.kind === 'bill') Object.assign(o, { amount: d.amount, billId: d.billId });
      if (full) o.data = JSON.parse(JSON.stringify(d)); else { const f = d.fields || {}; o.preview = r.kind === 'post' ? String(d.body || '').slice(0, 160) : r.kind === 'call' ? d.message : r.kind === 'appt' ? d.service_label : r.kind === 'order' ? arrOf(d.lines).slice(0, 4).map(l => l.qty + 'x ' + l.label).join(' · ') : r.kind === 'bill' ? d.reason : (d.order || []).filter(k => { const md = (mDef(r.app) || { modules: [] }).modules.find(x => x.id === r.module); const fd = md && arrOf(md.options.fields).find(x => x.key === k); return !fd || ['text', 'textarea', 'select', 'plate'].includes(fd.type || 'text'); }).map(k => f[k]).filter(v => typeof v === 'string' && v !== r.title).slice(0, 2).join(' · ') || undefined; }
      return o; };
    const push = r => setTimeout(() => Bridge.emit('capps:changed', { app: r.app, module: r.module, id: r.id, kind: r.kind, status: r.status }), 30);
    const days = def => { const m = def; const o = m.options; const dl = arrOf(o.days).length ? arrOf(o.days) : WD; return Array.from({ length: 14 }, (_, i) => { const d = new Date(today.getFullYear(), today.getMonth(), today.getDate() + i, 12); const wd = d.getDay() === 0 ? 7 : d.getDay(); return { day: isoDay(d), wd, d: d.getDate(), m: d.getMonth() + 1, open: dl.includes(wd) }; }); };
    const slotsOf = (def, m, day) => { const o = m.options; const h = o.hours || {}; const from = (+h.from || 9) * 60, to = (+h.to || 21) * 60, step = +o.slot || 30, max = +o.maxPerSlot || 1; const d = parseDay(day); if (!d) return [];
      const outS = []; for (let t = from; t <= to - step; t += step) { const a = new Date(d.getFullYear(), d.getMonth(), d.getDate(), Math.floor(t / 60), t % 60).getTime(); if (a < Date.now() + 15 * Mi) continue; const n = ITEMS.filter(x => x.app === def.id && x.module === m.id && x.at === a && (x.status === 'pending' || x.status === 'confirmed')).length; outS.push({ time: pad2(Math.floor(t / 60)) + ':' + pad2(t % 60), free: Math.max(0, max - n - ((t / step) % 5 === 2 ? 1 : 0)) }); } return outS; };
    const R = LocalDB.register;
    R('capps.access', () => { const o = {}; DEMO.forEach(def => { o[def.id] = mAcc(def); }); return { apps: o }; });
    R('capps.list', d => { const c = mCtx(d, d.side); if (c.error) return c; if (c.kind === 'shift') return { error: 'module' }; let l = ITEMS.filter(r => r.app === d.app && r.module === d.module && r.kind === c.kind);
      if (c.side === 'civil' && c.kind !== 'post') l = l.filter(r => r.owner === ME());
      if (c.side === 'staff') { const f = d.filter || 'all'; if (f === 'open') l = l.filter(r => !closedOf(c.m, c.kind, r.status)); else if (f === 'closed') l = l.filter(r => closedOf(c.m, c.kind, r.status)); else if (f === 'mine') l = l.filter(r => r.assignee === ME()); else if (f !== 'all') l = l.filter(r => r.status === f);
        if (c.kind === 'appt' && d.day) l = l.filter(r => (r.data || {}).day === d.day);
        const q = String(d.q || '').toLowerCase(); if (q) l = l.filter(r => [r.title, r.subject, r.owner_name, JSON.stringify(r.data || {})].some(x => x && String(x).toLowerCase().includes(q))); }
      l = l.slice().sort((a, b) => c.kind === 'post' ? ((b.pinned ? 1 : 0) - (a.pinned ? 1 : 0) || b.created - a.created) : c.kind === 'appt' ? (c.side === 'staff' ? a.at - b.at : b.at - a.at) : (c.kind === 'call' || c.kind === 'order' || c.kind === 'bill') ? b.created - a.created : b.updated - a.updated);
      const page = +d.page || 0; return { items: l.slice(page * 30, page * 30 + 30).map(r => out(r, c, false)), total: l.length, page, pages: Math.max(1, Math.ceil(l.length / 30)) }; });
    const byId = (id, side) => { const r = ITEMS.find(x => x.id === +id); if (!r) return { error: 'notfound' }; const c = mCtx({ app: r.app, module: r.module }, side); if (c.error) return c; if (c.side === 'civil' && r.kind !== 'post' && r.owner !== ME()) return { error: 'notfound' }; return { r, c }; };
    R('capps.get', d => { const x = byId(d.id, d.side); if (x.error) return x; return { item: out(x.r, x.c, true), notes: NOTES.filter(n => n.item === x.r.id && (x.c.side === 'staff' || !n.private)).map(n => Object.assign({}, n, { mine: n.author === ME() || undefined })) }; });
    R('capps.create', d => { const c = mCtx(d, d.side); if (c.error) return c; const r = { app: d.app, module: d.module, kind: c.kind, created: Date.now() }; const o = c.m.options;
      if ((c.kind === 'record' || c.kind === 'post' || c.kind === 'bill') && !mCan(c, 'create')) return { error: 'grade' };
      if (c.kind === 'form') { const f = d.fields || {}; const tf = (o.fields || []).find(x => (x.type === 'text' || x.type === 'select') && f[x.key]); Object.assign(r, { owner: ME(), anonymous: !!(o.anonymous && d.anonymous), status: statusesOf(c.m)[0].id, title: (tf && f[tf.key]) || c.m.title, data: { fields: f, order: Object.keys(f), photo: d.photo } }); if (!r.anonymous) { r.owner_name = meName(); r.owner_phone = '555-0142'; } if (d.location && d.coords) { r.x = d.coords.x; r.y = d.coords.y; } }
      else if (c.kind === 'appt') { const s = slotsOf(c.def, c.m, d.day).find(x => x.time === d.time); if (!s) return { error: 'slot' }; if (s.free <= 0) return { error: 'full' }; const svc = (o.services || []).find(x => x.id === d.service); const [h, mm] = d.time.split(':').map(Number); const dd = parseDay(d.day);
        Object.assign(r, { owner: ME(), owner_name: meName(), owner_phone: '555-0142', status: 'pending', title: svc ? svc.label : c.m.title, at: new Date(dd.getFullYear(), dd.getMonth(), dd.getDate(), h, mm).getTime(), data: { day: d.day, time: d.time, service: d.service, service_label: svc && svc.label, minutes: svc ? svc.minutes : o.slot, notes: d.notes || undefined } }); }
      else if (c.kind === 'call') { if (ITEMS.some(x => x.app === d.app && x.module === d.module && x.owner === ME() && (x.status === 'waiting' || x.status === 'accepted'))) return { error: 'open' }; const tp = (o.types || []).find(x => x.id === d.type);
        Object.assign(r, { owner: ME(), owner_name: meName(), owner_phone: '555-0142', status: 'waiting', title: tp ? tp.label : c.m.title, data: { type: d.type, type_label: tp && tp.label, message: d.message || undefined }, x: d.coords && d.coords.x, y: d.coords && d.coords.y }); }
      else if (c.kind === 'record') Object.assign(r, { status: 'open', title: d.subject, subject: d.subject, assignee: ME(), assignee_name: meName(), data: { fields: d.fields || {}, order: Object.keys(d.fields || {}), tags: d.tags || [], author: meName() } });
      else if (c.kind === 'post') { if (d.pinned && ITEMS.filter(x => x.app === d.app && x.module === d.module && x.pinned).length >= (+o.pinLimit || 3)) return { error: 'pinlimit', max: +o.pinLimit || 3 }; Object.assign(r, { status: 'published', title: d.title, pinned: !!d.pinned, assignee: ME(), assignee_name: meName(), data: { body: d.body, image: d.image, author: meName() } }); }
      else if (c.kind === 'order') { const its = arrOf(o.items); const ls = []; for (const l of arrOf(d.lines)) { const it = its.find(x => x.id === l.id); if (!it || it.available === false) return { error: 'unavailable' }; if (!(+l.qty >= 1 && +l.qty <= (+o.maxQty || 10))) return { error: 'qty', max: +o.maxQty || 10 }; ls.push({ id: it.id, label: it.label, price: +it.price || 0, qty: +l.qty }); }
        if (!ls.length) return { error: 'empty' }; const total = Math.round(ls.reduce((s, l) => s + l.price * l.qty, 0) * 100) / 100;
        Object.assign(r, { owner: ME(), owner_name: meName(), owner_phone: '555-0142', status: statusesOf(c.m)[0].id, title: ls[0].label + (ls.length > 1 ? ' +' + (ls.length - 1) : ''), data: { lines: ls, total, count: ls.reduce((s, l) => s + l.qty, 0), currency: o.currency || UI.cur(), fields: d.fields || {}, order: Object.keys(d.fields || {}) } }); if (d.location && d.coords) { r.x = d.coords.x; r.y = d.coords.y; } }
      else if (c.kind === 'bill') { const n = +d.amount; if (!Number.isInteger(n) || n < 1) return { error: 'amount' }; if (o.maxAmount && n > +o.maxAmount) return { error: 'amount', max: +o.maxAmount }; if (o.reasonRequired !== false && !d.reason) return { error: 'reason' };
        const np = d.target != null ? NEAR.find(p => p.id === d.target) : null; if (d.target != null && !np) return { error: 'target' }; if (d.target == null && !/^[\d\s+()-]{3,}$/.test(String(d.to || ''))) return { error: 'phone' };
        Object.assign(r, { owner: 'CX', owner_name: np ? np.name : undefined, owner_phone: np ? np.phone : String(d.to), status: 'pending', title: d.reason || money(n), assignee: ME(), assignee_name: meName(), data: { billId: ++bseq, amount: n, reason: d.reason, to: np ? np.phone : d.to, society: o.society !== false ? MJOB.name : undefined } }); }
      add(r); push(r); return { ok: true, id: r.id, item: out(r, c, true) }; });
    R('capps.status', d => { const x = byId(d.id, d.side); if (x.error) return x; const r = x.r; if (x.c.side === 'staff' && !mCan(x.c, 'status')) return { error: 'grade' };
      if (r.status === 'waiting' && d.status === 'accepted' || (r.kind === 'appt' && d.status === 'confirmed')) { r.assignee = ME(); r.assignee_name = meName(); } r.status = d.status; r.updated = Date.now(); push(r); return { ok: true, item: out(r, x.c, true), coords: r.x != null ? { x: r.x, y: r.y } : undefined }; });
    R('capps.assign', d => { const x = byId(d.id, 'staff'); if (x.error) return x; if (!mCan(x.c, 'assign')) return { error: 'grade' }; const r = x.r; if (r.assignee === ME()) { r.assignee = null; r.assignee_name = null; } else { r.assignee = ME(); r.assignee_name = meName(); } r.updated = Date.now(); push(r); return { ok: true, item: out(r, x.c, true) }; });
    R('capps.note', d => { const x = byId(d.id, d.side); if (x.error) return x; if (x.c.side === 'staff' && !mCan(x.c, 'reply')) return { error: 'grade' }; const n = { id: ++nseq, item: x.r.id, author: ME(), author_name: meName(), staff: x.c.side === 'staff', private: x.c.side === 'staff' && !!d.private, text: String(d.text || '').slice(0, 1000), created: Date.now() }; NOTES.push(n); x.r.updated = n.created; push(x.r); return { ok: true, note: Object.assign({ mine: true }, n) }; });
    R('capps.update', d => { const x = byId(d.id, 'staff'); if (x.error) return x; const r = x.r; const dd = r.data = r.data || {};
      if (d.pinned && !r.pinned && ITEMS.filter(y => y.app === r.app && y.module === r.module && y.pinned).length >= (+x.c.m.options.pinLimit || 3)) return { error: 'pinlimit', max: +x.c.m.options.pinLimit || 3 };
      if (d.fields) { dd.fields = d.fields; dd.order = Object.keys(d.fields); } if (d.tags) dd.tags = d.tags; if (d.subject) r.subject = r.title = d.subject; if (d.title) r.title = d.title; if (d.body) dd.body = d.body; if (d.image !== undefined) dd.image = d.image || undefined; if (d.pinned !== undefined) r.pinned = !!d.pinned; if (d.day && d.time) { dd.day = d.day; dd.time = d.time; }
      r.updated = Date.now(); push(r); return { ok: true, item: out(r, x.c, true) }; });
    R('capps.delete', d => { const x = byId(d.id, 'staff'); if (x.error) return x; if (!mCan(x.c, 'delete')) return { error: 'grade' }; ITEMS.splice(ITEMS.indexOf(x.r), 1); push(x.r); return { ok: true }; });
    R('capps.slots', d => { const c = mCtx(d, d.side); if (c.error) return c; const o = c.m.options; const ds = days(c.m); let day = ds.find(x => x.day === d.day && x.open) ? d.day : (ds.find(x => x.open && slotsOf(c.def, c.m, x.day).length) || {}).day;
      return { days: ds, day, slots: day ? slotsOf(c.def, c.m, day) : [], services: (o.services || []).map(s => ({ id: s.id, label: s.label, minutes: s.minutes || 30 })), notes: o.notes !== false, slot: o.slot || 30 }; });
    const team = def => def.audience.jobs.flatMap(j => (ROSTER[j.name] || []).map(([name, grade, level, onduty, phone]) => ({ name, job: LABEL[j.name], jobName: j.name, grade, level, onduty, phone })));
    R('capps.roster', d => { const def = mDef(d.app); if (!def) return { error: 'app' }; const a = mAcc(def); if (!a.staff) return { error: 'forbidden' };
      return { members: team(def).concat([{ name: meName(), job: LABEL[MJOB.name] || MJOB.label, grade: MJOB.label, level: MJOB.grade, onduty: MJOB.onduty, phone: '555-0142', me: true }]).sort((a, b) => (b.onduty - a.onduty) || (b.level - a.level)) }; });
    R('capps.mine', d => ({ items: ITEMS.filter(r => r.app === d.app && r.owner === ME()).map(r => out(r, { side: 'civil' }, false)) }));
    R('capps.counts', d => { const def = mDef(d.app); if (!def) return { error: 'app' }; const a = mAcc(def); if (!a.staff) return { counts: {} }; const o = {}; ITEMS.filter(r => r.app === d.app).forEach(r => { const m = def.modules.find(x => x.id === r.module); if (!m || !staffMod(a, m) || !['form', 'appt', 'call', 'order'].includes(r.kind)) return; const first = (r.kind === 'form' || r.kind === 'order') ? statusesOf(m)[0].id : r.kind === 'appt' ? 'pending' : 'waiting'; if (r.status === first) o[r.module] = (o[r.module] || 0) + 1; }); return { counts: o }; });
    R('capps.bill', d => { const x = byId(d.id, 'staff'); if (x.error) return x; const r = x.r; if (r.kind !== 'order') return { error: 'forbidden' }; const dd = r.data || {}; if (dd.billId) return { error: 'billed' };
      const amount = Math.round(+dd.total || 0); const bid = ++bseq; dd.billId = bid; dd.billAmount = amount; r.updated = Date.now();
      const bm = x.c.def.modules.find(m => m.type === 'billing'); if (bm) add({ app: r.app, module: bm.id, kind: 'bill', owner: r.owner, owner_name: r.owner_name, owner_phone: r.owner_phone, status: 'pending', title: x.c.def.name + ' · ' + (x.c.m.title || '') + ' #' + r.id, assignee: ME(), assignee_name: meName(), data: { billId: bid, amount, reason: x.c.def.name + ' · #' + r.id, to: r.owner_phone, order: r.id } });
      push(r); return { ok: true, bill: { id: bid, amount, status: 'pending' }, item: out(r, x.c, true) }; });
    const NEAR = [{ id: 12, name: 'Marta Ribeiro', dist: 2.4, phone: '555-2041' }, { id: 15, name: 'Luís Almeida', dist: 6.1, phone: '555-3377' }];
    R('capps.nearby', d => { const c = mCtx(d, 'staff'); if (c.error) return c; return { players: NEAR.map(p => ({ id: p.id, name: p.name, dist: p.dist })), onesync: true }; });
    let since = now - 75 * Mi;
    R('capps.duty', d => { const c = mCtx(d, 'staff'); if (c.error) return c; if (c.kind !== 'shift') return { error: 'module' };
      if (d.on !== undefined && !!d.on !== MJOB.onduty) { MJOB.onduty = !!d.on; if (System.player && System.player.job) System.player.job.onduty = MJOB.onduty; if (MJOB.onduty) since = Date.now(); setTimeout(() => Bridge.emit('capps:changed', { app: c.def.id, module: c.m.id, kind: 'shift' }), 30); }
      const shifts = [[1, '18:02', 312], [2, '17:45', 284], [4, '20:10', 196], [6, '09:00', 480]].map(([off, hm, mins], i) => { const a = new Date(today.getFullYear(), today.getMonth(), today.getDate() - off, +hm.slice(0, 2), +hm.slice(3)).getTime(); return { id: 9000 + i, at: a, stop: a + mins * Mi, minutes: mins }; });
      const tm = c.def.audience.jobs.flatMap(j => (ROSTER[j.name] || []).filter(p => p[3]).map(([name, grade, level, , phone], i) => ({ name, grade, level, phone, since: now - (40 + i * 37) * Mi })));
      if (MJOB.onduty) tm.unshift({ name: meName(), grade: MJOB.label, level: MJOB.grade, phone: '555-0142', since, me: true });
      return { ok: true, supported: true, mode: 'qb', onduty: MJOB.onduty, since: MJOB.onduty ? since : undefined, job: LABEL[MJOB.name] || MJOB.label, week: 21 * 60 + 12 + (MJOB.onduty ? Math.round((Date.now() - since) / Mi) : 0), shifts, team: c.m.options.showTeam !== false && mCan(c, 'view') ? tm : undefined }; });
    mock = {
      defs: DEMO, items: ITEMS, notes: NOTES,
      /* emprego do jogador de teste (como o push 'player' do jogo) */
      job(name, grade = 0, onduty = true) { MJOB = { name, label: JLABEL[name] || name, grade, onduty }; if (System.player) { System.player.job = { name, label: MJOB.label, grade: String(grade), onduty }; } lastJob = null; Bridge.emit('player:update', System.player || {}); return refreshAccess(); },
      side(id, s) { SIDE[id] = s; const W = WINS[id]; if (W) { W.side = s; build(W, false); } },
      /* abre um modulo pelo id (separador ou "Mais") */
      tab(id, mod) { const W = WINS[id]; if (!W) return false; const i = W.mods.findIndex(x => x.id === mod); if (i < 0) return false; if (W.tabs && i < W.tabCount) W.tabs.go(i); else UI.push(W.win, makeView(W, W.mods[i], true)); return true; },
    };
    /* o 'ready' do mock chega depois deste ficheiro: as definicoes entram ja (como o capps:get no jogo) */
    loadDefs({ rev: 'mock-1', categories: ['Serviços públicos', 'Emprego', 'Empresas'], server: 'Los Santos RP', apps: DEMO });
  }

  return {
    glyphs: GLYPHS, glyphNames: GLYPH_NAMES, glyphSvg, iconFor, iconSvg, colors,
    defs: () => ORDER.slice(), access: () => ACC, refresh: refreshAccess,
    open: id => System.openApp(appId(id)), get mock() { return mock; },
  };
})();
