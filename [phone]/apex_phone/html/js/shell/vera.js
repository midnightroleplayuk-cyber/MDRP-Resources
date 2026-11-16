/* ============================================================
   VERA - assistente (estilo Siri PearOS 17), 100% offline.
   NLU por regras em pt-PT: normalização sem acentos, correção de
   gafes (Levenshtein), números por extenso, horas e durações.
   Executa tudo pelos módulos reais (System, PhoneApp, Msgs, Player,
   Store, Hardware, Lock, Notify, Wallpapers, Bridge…).
   API pública: Vera.open/close/toggle/run/register/isOpen
   ============================================================ */
window.Vera = (() => {
  const g = UI.g;
  let el, edge, sheet, log, inp, chipsEl, orb, statusEl, sendBtn, liveT = null, busy = false, kbT = null;
  /* NOVA UI (Android, 2026-10-01): a MESMA Vera (motor, intents, voz, cartões) com o aspeto de assistente da Nova UI:
     sem orbe na Dynamic Island, um cartão de respostas em vidro e por baixo uma barra flutuante com o gradiente de IA
     (ciano para verde) nas bordas. O DOM é o mesmo: no Android a cabeça, a conversa e as sugestões passam para dentro
     de um invólucro (.ave-card) e voltam ao sítio no PearOS (ver layout()). */
  const isA = () => !!(window.System && System.os === 'android');
  const fcName = () => isA() && window.App && App.name ? App.name('facetime') : 'FaceCall';
  let card0 = null;   /* o invólucro .ave-card (só existe no Android) */
  /* a barra de 3 botões está à vista? (o SysUI esconde-a no ecrã bloqueado): sem ela a Vera assenta mais em baixo */
  const navOn = () => { if (window.SysUI && typeof SysUI.navVisible === 'function') return !!SysUI.navVisible();
    const nb = UI.screen().querySelector('.anb'); return nb ? (nb.classList.contains('anb-on') || nb.classList.contains('on')) : document.body.dataset.nav !== 'gesture'; };
  const ext = [];        /* comandos registados por terceiros (Vera.register) - têm prioridade */
  const intents = [];    /* intents nativos, por ordem */
  const CHIPS = ['Que horas são?', 'Liga à Mãe', 'Temporizador 5 min', 'Onde está o meu carro?', 'Saldo', 'Lanterna', 'Modo escuro'];
  const SUGGEST = ['Que horas são?', 'Como está o tempo?', 'Liga à Mãe', 'Manda mensagem à Mãe a dizer estou a chegar', 'Temporizador de 5 minutos', 'Alarme às 7:30', 'Onde está o meu carro?', 'Leva-me ao hospital', 'Quanto dinheiro tenho?', 'Quanto é 12 × 7?', '25% de 300', 'Toma nota: comprar pão', 'Lembra-me de pagar a renda às 18:00', 'Toca música', 'Qual é o número do Rui?', 'Tenho mensagens novas?', 'Abre a calculadora', 'Liga a lanterna', 'Ativa o modo escuro', 'Volume a 50%', 'Muda o fundo para azul', 'Quanta bateria tenho?', 'Tira uma foto', 'Bloqueia o telemóvel', 'Conta-me uma piada', 'O que sabes fazer?'];

  /* ---------- texto: normalização, fuzzy, números ---------- */
  const strip = s => String(s == null ? '' : s).normalize('NFD').replace(/[̀-ͯ]/g, '');
  const norm = s => strip(s).toLowerCase().replace(/[’‘`´]/g, "'").replace(/[?!¿¡;"“”]+/g, ' ').replace(/\s+/g, ' ').trim();
  const lev = (a, b) => { if (a === b) return 0; const m = a.length, n = b.length; if (!m || !n) return m || n; let prev = Array.from({ length: n + 1 }, (_, i) => i); for (let i = 1; i <= m; i++) { const cur = [i]; for (let j = 1; j <= n; j++) cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1)); prev = cur; } return prev[n]; };
  const sim = (a, b) => { a = norm(a); b = norm(b); if (!a || !b) return 0; if (a === b) return 1; return 1 - lev(a, b) / Math.max(a.length, b.length); };
  const cap = s => s ? s[0].toUpperCase() + s.slice(1) : s;
  const VOCAB = 'abre abrir liga ligar telefona chama chamar mensagem envia enviar manda mandar temporizador cronometro alarme acorda horas dia hoje amanha tempo meteorologia chover chuva saldo dinheiro banco carteira leva navegar navega direcoes carro veiculo garagem lanterna escuro claro modo silencio silencioso incomodar volume brilho fundo papel parede bateria quanto calcula raiz nota toma cria lembra lembrete toca tocar pausa pausar proxima anterior musica numero contacto mensagens notificacoes novas foto fotografia camara bloqueia bloquear quem ajuda sabes fazer piada anedota obrigado obrigada desliga desligar ativa ativar desativa desativar aumenta baixa diminui define poe mete coloca facetime videochamada calculadora definicoes mapas relogio calendario notas lembretes fotos loja telemovel minutos minuto segundos segundo hora onde esta estao hospital policia oficina casino praia aeroporto apaga acende'.split(' ');
  const known = () => { const s = new Set(VOCAB); (window.Contacts && Contacts.cache || []).forEach(c => norm(c.name).split(' ').forEach(w => s.add(w))); (window.App ? App.ids() : []).forEach(id => norm(App.name(id)).split(' ').forEach(w => s.add(w))); return s; };
  function fix(t) { /* corrige gafes de escrita palavra a palavra (só palavras de 4+ letras, distância 1, ou 2 em palavras longas) */
    const k = known();
    return t.split(' ').map(w => { if (!/^[a-z]{4,}$/.test(w) || k.has(w)) return w; let best = null, bd = 9; for (const v of VOCAB) { if (Math.abs(v.length - w.length) > 2 || v[0] !== w[0]) continue; const d = lev(w, v); if (d < bd) { bd = d; best = v; } } return best && bd <= (w.length >= 8 ? 2 : 1) ? best : w; }).join(' ');
  }
  const NUMW = { zero: 0, um: 1, uma: 1, dois: 2, duas: 2, tres: 3, quatro: 4, cinco: 5, seis: 6, sete: 7, oito: 8, nove: 9, dez: 10, onze: 11, doze: 12, treze: 13, catorze: 14, quatorze: 14, quinze: 15, dezasseis: 16, dezesseis: 16, dezassete: 17, dezessete: 17, dezoito: 18, dezanove: 19, dezenove: 19, vinte: 20, trinta: 30, quarenta: 40, cinquenta: 50, sessenta: 60, setenta: 70, oitenta: 80, noventa: 90, cem: 100, cento: 100, mil: 1000 };
  const NUMRE = new RegExp(`\\b((?:${Object.keys(NUMW).join('|')})(?:\\s+e\\s+(?:${Object.keys(NUMW).join('|')}))*)\\b`, 'g');
  const numify = t => t.replace(NUMRE, m => String(m.split(/\s+e\s+/).reduce((a, w) => a + NUMW[w], 0)));
  function parseDur(s) {
    s = norm(s); let ms = 0, hit = false;
    s = s.replace(/\b(\d+|uma|um)\s*(?:h|hora|horas)\s+e\s+meia\b/g, (m, n) => `${NUMW[n] || n} horas 30 minutos`).replace(/\bmeia hora\b/g, '30 minutos').replace(/\bum quarto de hora\b/g, '15 minutos').replace(/\b(\d+|um|uma)\s*(?:min|minuto|minutos)\s+e\s+meio\b/g, (m, n) => `${NUMW[n] || n} minutos 30 segundos`);
    s = numify(s);
    const re = /(\d+(?:[.,]\d+)?)\s*(h\b|horas?\b|hrs?\b|m\b|min\b|mins\b|minutos?\b|s\b|seg\b|segs\b|segundos?\b)/g; let m;
    while ((m = re.exec(s))) { hit = true; const n = parseFloat(m[1].replace(',', '.')); const u = m[2][0]; ms += n * (u === 'h' ? 36e5 : u === 'm' ? 6e4 : 1e3); }
    if (!hit) { const b = s.match(/\b(\d+)\b/); if (b) { ms = +b[1] * 6e4; hit = true; } }
    return hit && ms > 0 ? Math.round(ms) : null;
  }
  function parseTime(s) {
    s = norm(s); const half = /\be meia\b/.test(s), quarter = /\be um quarto\b|\be quinze\b/.test(s), less = /\bmenos um quarto\b/.test(s);
    s = numify(s.replace(/\be meia\b|\be um quarto\b|\bmenos um quarto\b/g, ''));
    let m = s.match(/\b(\d{1,2})\s*(?::|h|horas?)\s*(\d{1,2})?\b/); if (!m) m = s.match(/\b(\d{1,2})\b/); if (!m) return null;
    let h = +m[1], min = +(m[2] || 0); if (half) min = 30; if (quarter) min = 15; if (less) { h -= 1; min = 45; }
    if (/\bda tarde\b|\bda noite\b/.test(s) && h < 12) h += 12; if (/\bda manha\b/.test(s) && h === 12) h = 0; if (h === 24) h = 0;
    if (h < 0 || h > 23 || min > 59) return null; return { h, m: min };
  }
  const fmtHM = (h, m) => `${UI.pad(h)}:${UI.pad(m)}`;
  const fmtMs = ms => { const s = Math.max(0, Math.ceil(ms / 1000)); return (s >= 3600 ? Math.floor(s / 3600) + ':' : '') + UI.pad(Math.floor(s % 3600 / 60)) + ':' + UI.pad(s % 60); };
  const durText = ms => { const s = Math.round(ms / 1000); const h = Math.floor(s / 3600), m = Math.floor(s % 3600 / 60), x = s % 60; const p = []; if (h) p.push(h + (h === 1 ? ' hora' : ' horas')); if (m) p.push(m + (m === 1 ? ' minuto' : ' minutos')); if (x) p.push(x + (x === 1 ? ' segundo' : ' segundos')); return p.join(' e ') || '0 segundos'; };
  const fmtNum = n => { if (!isFinite(n)) return 'Erro'; const r = Math.abs(n) >= 1e12 ? n.toExponential(4) : String(+n.toPrecision(12)); return r.replace('.', ','); };

  /* ---------- apps / contactos / lugares ---------- */
  const APP_ALIAS = { calculadora: 'calculator', calc: 'calculator', mapa: 'maps', mapas: 'maps', gps: 'maps', fotos: 'photos', fotografias: 'photos', galeria: 'photos', camara: 'camera', camera: 'camera', definicoes: 'settings', ajustes: 'settings', configuracoes: 'settings', loja: 'appstore', 'app store': 'appstore', appstore: 'appstore', relogio: 'clock', alarmes: 'clock', tempo: 'weather', meteorologia: 'weather', clima: 'weather', banco: 'wallet', carteira: 'wallet', wallet: 'wallet', sms: 'messages', mensagens: 'messages', imessage: 'messages', musica: 'music', notas: 'notes', lembretes: 'reminders', calendario: 'calendar', agenda: 'calendar', garagem: 'garage', mail: 'mail', email: 'mail', correio: 'mail', telefone: 'phone', chamadas: 'phone', contactos: 'contacts', browser: 'safari', internet: 'safari', safari: 'safari', navegador: 'safari', facetime: 'facetime', videochamada: 'facetime', servicos: 'services', faturas: 'billing', 'dark chat': 'darkchat', darkchat: 'darkchat', marketplace: 'marketplace', anuncios: 'marketplace', match: 'match' };
  function findApp(q) {
    q = norm(q).replace(/^(?:a |o |as |os |app |aplicacao |a app |a aplicacao )+/, '').replace(/\s+(?:app|aplicacao)$/, '').trim(); if (!q) return null;
    const ids = System.installed(); const all = App.ids();
    if (APP_ALIAS[q] && all.includes(APP_ALIAS[q])) return APP_ALIAS[q];
    const by = f => ids.find(id => f(norm(App.name(id)), id)) || all.find(id => f(norm(App.name(id)), id));
    return by((n, id) => n === q || id === q) || by(n => n.startsWith(q)) || by(n => n.includes(q) || q.includes(n)) || by(n => sim(n, q) >= .72) || null;
  }
  function findContact(q) {
    q = norm(q).replace(/^(?:a |o |ao |à |para |para a |para o |com |com a |com o |do |da |de |minha |meu |a minha |o meu )+/, '').trim(); if (!q) return null;
    const cs = (window.Contacts && Contacts.cache) || [];
    if (/^[\d\s\-+]{4,}$/.test(q)) { const n = q.replace(/\s/g, ''); return (window.Contacts && Contacts.byNumber(n)) || { name: n, number: n, raw: true }; }
    return cs.find(c => norm(c.name) === q) || cs.find(c => norm(c.name).startsWith(q)) || cs.find(c => norm(c.name).split(' ').some(w => w === q)) || cs.find(c => norm(c.name).includes(q)) || cs.find(c => norm(c.name).split(' ').some(w => sim(w, q) >= .75)) || cs.find(c => sim(c.name, q) >= .7) || null;
  }
  function splitContact(rest) { /* "Mãe estou a chegar" → { c, text } (nome mais longo primeiro) */
    const cs = ((window.Contacts && Contacts.cache) || []).slice().sort((a, b) => b.name.length - a.name.length); const r = norm(rest);
    for (const c of cs) { const n = norm(c.name); if (r === n || r.startsWith(n + ' ')) return { c, text: rest.trim().slice(n.length).trim() }; }
    const num = r.match(/^([\d\-+]{4,})\s*(.*)$/); if (num) return { c: findContact(num[1]), text: num[2] };
    const parts = rest.trim().split(' '); return { c: findContact(parts[0]), text: parts.slice(1).join(' ') };
  }
  const PLACE_ALIAS = [[/hospital|medic|clinica|urgencia|ferid|farmacia/, 'Hospital Pillbox'], [/policia|esquadra|lspd|comissariado|prisao/, 'LSPD Mission Row'], [/banco|fleeca|multibanco|atm/, 'Fleeca Bank'], [/oficina|mecanic|customs|tuning|pintar/, 'Los Santos Customs'], [/benny/, "Benny's"], [/casino|apostas|roleta/, 'Diamond Casino'], [/praia|beach|mar\b/, 'Vespucci Beach'], [/pier|cais|molhe|del perro/, 'Del Perro Pier'], [/aeroporto|aviao|voo/, 'Aeroporto LSIA'], [/camara|prefeitura|city hall/, 'Câmara Municipal'], [/docas|porto|docks/, 'Elysian Docks'], [/legion|praca/, 'Legion Square'], [/parque|mirror/, 'Mirror Park'], [/sandy|deserto/, 'Sandy Shores'], [/paleto|norte/, 'Paleto Bay']];
  /* os locais guardados são os da CONTA (Maps.places lê System.state.places): a chave local 'places' só
     existia como cache e ficava para trás quando o jogador guardava um local noutro dispositivo/sessão.
     O Store.get fica como recurso para um Mapas que ainda não tenha carregado. */
  function places() { const base = (window.Maps && Maps.poi && Maps.poi.length) ? Maps.poi : (typeof DEFAULT_POI !== 'undefined' ? DEFAULT_POI : []); const saved = (window.Maps && Array.isArray(Maps.places) ? Maps.places : Store.get('places', [])) || []; const gs = System.garages || {}; const gl = Object.keys(gs).map(id => ({ name: cap(id.replace(/garage/i, '').trim() || id), x: gs[id].x, y: gs[id].y, garage: true })); return [...base, ...saved, ...gl]; }
  function findPlace(q) {
    q = norm(q).replace(/^(?:o |a |ao |à |para |ate |até |no |na |de |do |da |mais proximo |mais proxima )+/, '').replace(/\s+mais (?:proximo|proxima|perto)$/, '').trim(); const ps = places(); if (!q) return null;
    const hit = ps.find(p => norm(p.name) === q) || ps.find(p => norm(p.name).startsWith(q)) || ps.find(p => norm(p.name).includes(q)) || ps.find(p => q.includes(norm(p.name)));
    if (hit) return hit; const al = PLACE_ALIAS.find(([re]) => re.test(q)); if (al) { const p = ps.find(x => norm(x.name).includes(norm(al[1]))); if (p) return p; }
    if (/garagem|garage/.test(q)) return ps.find(p => p.garage) || null;
    return ps.find(p => norm(p.name).split(' ').some(w => w.length > 3 && sim(w, q) >= .75)) || ps.find(p => sim(p.name, q) >= .6) || null;
  }
  const vehName = v => v.nickname || v.label || cap(String(v.model || 'Veículo').toLowerCase());
  const WP_COLORS = { laranja: 'orange', cosmic: 'orange', azul: 'blue', 'azul escuro': 'blue', prateado: 'silver', prata: 'silver', cinzento: 'silver', preto: 'black', escuro: 'black', gelo: 'blue', bordo: 'wine', vinho: 'wine', 'azul claro': 'sky', ceu: 'sky', dourado: 'gold', ouro: 'gold', amarelo: 'gold', lavanda: 'lavender', roxo: 'lavender', lilas: 'lavender', violeta: 'lavender', verde: 'sage', salvia: 'sage', nevoa: 'mist', mist: 'mist', branco: 'white', claro: 'white' };
  function findWallpaper(q) { q = norm(q || ''); const list = window.Wallpapers ? Wallpapers.list() : []; if (!list.length) return null; if (!q || /aleatori|outro|outra|qualquer|diferente|novo|nova/.test(q)) { const cur = System.state.wallpaper; const alt = list.filter(w => w.id !== cur); return alt[Math.floor(Math.random() * alt.length)]; }
    /* com ficheiros oficiais os ids da lista são 'file:…': passa-se pelo Wallpapers.resolve (black → file:black.jpg, silver → file:white.jpg); 'auto' fica para o nome */
    const key = Object.keys(WP_COLORS).sort((a, b) => b.length - a.length).find(k => q.includes(k)); if (key) { const rid = Wallpapers.resolve ? Wallpapers.resolve(WP_COLORS[key]) : WP_COLORS[key]; const w = list.find(x => x.id === rid && !x.auto); if (w) return w; }
    return list.find(w => norm(w.name) === q) || list.find(w => norm(w.name).includes(q) || q.includes(norm(w.name))) || list.find(w => sim(w.name, q) >= .6) || null; }
  /* meteorologia: a MESMA fonte de todos (WX, shell/lock.js) - o tempo real do jogo, não um valor inventado */
  const weatherNow = () => (window.WX ? WX.now() : Object.assign({ t: 26, c: 'sunny', cond: 'sunny', icon: 'sun', label: 'Céu limpo', city: 'Los Santos', hi: 26, lo: 21, night: false }, window.WX_FALLBACK || {}));
  const WX_LABEL = { sunny: 'Céu limpo', cloudy: 'Nublado', rain: 'Chuva', storm: 'Trovoada', snow: 'Neve', fog: 'Nevoeiro', night: 'Céu limpo' }, WX_ICON = { sunny: 'sun', cloudy: 'cloud', rain: 'rain', storm: 'storm', snow: 'snow', fog: 'fog', night: 'moon' };

  /* ---------- temporizador da Vera (partilha window.TimerState com o Relógio / Ilha) ---------- */
  let timer = null;
  function startTimer(ms) { if (timer) cancelTimer(); const end = Date.now() + ms; timer = { end, total: ms, t: setTimeout(fireTimer, ms) }; window.TimerState = { running: true, end, cancel: () => cancelTimer() }; }
  function fireTimer() { timer = null; window.TimerState = { running: false }; Sound.play('timer'); UI.alert({ title: 'Temporizador', msg: 'O tempo terminou.', buttons: [{ label: 'Parar', bold: true, value: true }] }); if (window.Notify) Notify.push({ app: 'clock', title: 'Temporizador', msg: 'O tempo terminou.', silent: true }); }
  function cancelTimer() { const any = !!timer || !!(window.TimerState && TimerState.running); if (timer) { clearTimeout(timer.t); timer = null; } if (window.TimerState && TimerState.running && TimerState.cancel && !timer) { try { const c = TimerState.cancel; window.TimerState = { running: false }; c(); } catch (e) {} } window.TimerState = { running: false }; return any; }
  const timerEnd = () => timer ? timer.end : (window.TimerState && TimerState.running ? TimerState.end : 0);

  /* ---------- UI ---------- */
  function init() {
    el = UI.el(`<div id="vera" role="dialog" aria-label="Vera"><div class="vera-scrim"></div><div class="vera-sheet">
      <div class="vera-head"><div class="vera-orb"></div><div class="vera-name">Vera<span class="vera-status"></span></div><div class="vera-vu" data-st="off"><i></i><i></i><i></i><i></i><i></i><span></span></div><div class="vera-x">${g('x', 21)}</div></div>
      <div class="vera-log"></div><div class="vera-chips"></div>
      <div class="vera-in"><input type="text" placeholder="Pergunta à Vera…" autocomplete="off" spellcheck="false" maxlength="140"><div class="vera-send">${g('mic', 23)}</div></div></div></div>`);
    edge = UI.el('<div class="vera-edge"></div>'); UI.screen().append(edge, el);
    sheet = el.querySelector('.vera-sheet'); log = el.querySelector('.vera-log'); inp = el.querySelector('input'); chipsEl = el.querySelector('.vera-chips'); orb = el.querySelector('.vera-orb'); statusEl = el.querySelector('.vera-status'); sendBtn = el.querySelector('.vera-send');
    /* INDICADOR DE VOZ (2026-09-18): mostra se o microfone está a ouvir, se está a APANHAR voz (barras pelo nível) e quando
       a frase foi enviada para perceber. Vem do js/shell/veravoice.js ('vera:voice'). */
    const vu = el.querySelector('.vera-vu'), vuTxt = vu.querySelector('span'), vuBars = [...vu.querySelectorAll('i')];
    const VU_TXT = { listen: 'A ouvir', speech: 'A ouvir-te', think: 'A perceber…', nomic: 'Sem microfone', quota: 'Voz indisponível hoje', off: '' };
    Bridge.on('vera:voice', d => { if (!d) return; vu.dataset.st = d.st; vuTxt.textContent = VU_TXT[d.st] || '';
      const lv = d.st === 'speech' ? d.lvl : d.st === 'listen' ? d.lvl * .45 : 0;
      vuBars.forEach((b, i) => { const k = [.55, .85, 1, .85, .55][i]; b.style.transform = 'scaleY(' + Math.max(.18, Math.min(1, lv * k * 1.6)).toFixed(2) + ')'; }); });
    inp.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); submit(); } if (e.key === 'Escape') { e.stopPropagation(); close(); } };
    inp.oninput = () => sendBtn.innerHTML = g(inp.value.trim() ? 'arrowUp' : 'mic', 20);
    inp.addEventListener('focus', () => { clearTimeout(kbT); kbT = setTimeout(kbFit, 90); });
    inp.addEventListener('blur', () => { clearTimeout(kbT); kbT = setTimeout(kbFit, 160); });
    sendBtn.onclick = () => { if (inp.value.trim()) submit(); else listen(); };
    el.querySelector('.vera-x').onclick = close; el.querySelector('.vera-scrim').onclick = close;
    UI.swipe(el.querySelector('.vera-head'), { down: close, threshold: 40 }); UI.swipe(el.querySelector('.vera-scrim'), { down: close, threshold: 40 });
    addEventListener('keydown', e => { if (!isOpen()) return; if (e.key === 'Escape' && !(document.activeElement && document.activeElement === inp)) { e.stopPropagation(); close(); } }, true);
    if (!Bridge.inFiveM) addEventListener('keydown', e => { if (e.key === 'F2') { e.preventDefault(); toggle(); } });
    Bridge.on('vera', () => toggle()); Bridge.on('phone:close', () => { if (isOpen()) close(); }); Bridge.on('lock', () => { if (isOpen()) close(); });
    /* trocar de aparelho: a Vera fecha (System.setOS) e o DOM passa ao arranjo do outro sistema, sem restos */
    Bridge.on('os:changed', () => { if (isOpen()) close(); try { Island.stop('vera'); } catch (e) {} layout(); });
    layout();
    builtins();
  }
  /* Nova UI: cabeça + conversa + sugestões dentro do cartão de vidro, a barra de escrita fica à parte, por baixo.
     PearOS: tudo de volta à folha, pela ordem original (o DOM fica igual ao de sempre). */
  function layout() {
    if (!el) return; const head = el.querySelector('.vera-head'), bar = el.querySelector('.vera-in');
    /* Nova UI: a tecla de ação do teclado NOVA é "Enviar" (no PearOS fica como sempre, sem atributo) */
    if (isA()) inp.setAttribute('enterkeyhint', 'send'); else inp.removeAttribute('enterkeyhint');
    if (isA()) {
      el.classList.add('ave');
      if (!card0) { card0 = UI.el('<div class="ave-card"></div>'); sheet.insertBefore(card0, bar); card0.append(head, log, chipsEl); }
    } else {
      el.classList.remove('ave');
      if (card0) { sheet.insertBefore(head, card0); sheet.insertBefore(log, card0); sheet.insertBefore(chipsEl, card0); card0.remove(); card0 = null; }
    }
  }
  const isOpen = () => !!(el && el.classList.contains('in'));
  function kbFit() { const kb = document.getElementById('kb'); const vis = !!(window.Keyboard && Keyboard.visible && kb); el.style.setProperty('--vera-kb', vis ? kb.offsetHeight + 'px' : '0px'); el.classList.toggle('kb', vis); if (vis) scrollLog(); }
  /* PearOS 27: o contorno luminoso a toda a volta do ecrã (Siri do PearOS 18/26) deu lugar a um ORBE a rodopiar na
     Dynamic Island, com a interface compacta à volta dela. O orbe é uma atividade da ilha ('vera') enquanto a
     Vera está aberta; o estado ("A ouvir…", "A pensar…") vai para a subtítulo da pílula. O .vera-edge fica no
     DOM (sem 'on': nada anima) para quem quiser voltar ao anel - ver ISLAND_ORB. */
  const ISLAND_ORB = true;
  const ORB_IMG = 'data:image/svg+xml;utf8,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 40"><defs><radialGradient id="a" cx="35%" cy="30%" r="75%"><stop offset="0" stop-color="#FFD6E8"/><stop offset=".35" stop-color="#FF5E8A"/><stop offset=".62" stop-color="#7D7AFF"/><stop offset=".85" stop-color="#5AC8FA"/><stop offset="1" stop-color="#34C759"/></radialGradient><radialGradient id="b" cx="70%" cy="75%" r="55%"><stop offset="0" stop-color="#FFD60A" stop-opacity=".9"/><stop offset="1" stop-color="#FFD60A" stop-opacity="0"/></radialGradient></defs><circle cx="20" cy="20" r="19" fill="url(#a)"/><circle cx="20" cy="20" r="19" fill="url(#b)"/><circle cx="20" cy="20" r="18.5" fill="none" stroke="#fff" stroke-opacity=".55"/></svg>');
  function islandOrb(on, sub) {
    if (!ISLAND_ORB || !window.Island || !Island.activity) return;
    /* Nova UI: não há orbe na ilha (a Vera vive no cartão e na barra de baixo) */
    try { if (!on) { Island.stop('vera'); return; } if (isA()) return; if (Island.update('vera', { subtitle: sub || '' })) return; Island.activity('vera', { app: 'settings', title: 'Vera', subtitle: sub || '', icon: ORB_IMG, onTap: () => { if (!isOpen()) open(); } }); } catch (e) {}
  }
  function open(opts = {}) {
    if (!el) return; if (!System.state.vera) { UI.toast('A Vera está desativada nas Definições'); return; }
    if (window.CC && CC.isOpen && CC.isOpen()) CC.close(); if (window.Notify && Notify.isOpen && Notify.isOpen()) Notify.close();
    if (!isOpen()) { log.innerHTML = ''; const who = System.account && System.account.username ? ', ' + System.account.username : ''; const h = new Date().getHours(); const hi = h < 6 ? 'Boa noite' : h < 13 ? 'Bom dia' : h < 20 ? 'Boa tarde' : 'Boa noite'; say(`${hi}${who}! Em que posso ajudar?`, { silent: true }); setChips(CHIPS); }
    el.classList.add('in'); if (!ISLAND_ORB) edge.classList.add('on'); el.classList.toggle('orb-island', ISLAND_ORB && !isA()); if (isA()) el.classList.toggle('ave-nonav', !navOn()); islandOrb(true, ''); setStatus(''); Sound.play('siri_on');   /* era o som de chamada ligada ('connect'): abrir a Vera soava a uma chamada */ Bridge.emit('overlay', 'vera');
    clearInterval(liveT); liveT = setInterval(paintLive, 500);
    if (window.VeraVoice && VeraVoice.announce) VeraVoice.announce();   /* o indicador de voz mostra já o estado atual */
    setTimeout(() => { if (isOpen() && !opts.noFocus) inp.focus(); }, 380);
    if (opts.ask) setTimeout(() => run(opts.ask), 420);
  }
  function close() { if (!el || !isOpen()) return; el.classList.remove('in', 'listening', 'kb'); edge.classList.remove('on', 'listening'); islandOrb(false); inp.blur(); inp.value = ''; sendBtn.innerHTML = g('mic', 23); setStatus(''); clearInterval(liveT); liveT = null; el.style.setProperty('--vera-kb', '0px'); }
  function toggle() { isOpen() ? close() : open(); }
  /* microfone: ouve UMA frase a sério (js/shell/veravoice.js → transcrição no servidor) e executa-a.
     Antes só mostrava "A ouvir…" 2 s e punha o cursor na caixa. Sem microfone/servidor volta a esse comportamento. */
  function listen() {
    if (!isOpen()) return;
    /* já a ouvir? o segundo toque cancela (como no iPhone) */
    if (window.VeraVoice && VeraVoice.listening && VeraVoice.listening()) { VeraVoice.cancelOnce(); return; }
    const stopUi = () => { if (!busy) { el.classList.remove('listening'); edge.classList.remove('listening'); setStatus(''); } };
    el.classList.add('listening'); edge.classList.add('listening'); setStatus('A ouvir…'); Sound.play('pop');
    const ok = window.VeraVoice && VeraVoice.listenOnce((text, err) => {
      stopUi();
      if (text && text.trim()) { run(text); return; }
      if (err === 'denied' || err === 'nomic') { setStatus('Sem microfone: escreve o pedido'); inp.focus(); }
      else if (err === 'cancel') setStatus('');
      else if (err === 'silence' || !err) setStatus('Não ouvi nada');
      else if (err === 'limit') setStatus('Demasiados pedidos de voz, espera um minuto');
      else if (err === 'quota') setStatus('A voz esgotou por hoje: escreve o pedido');
      else setStatus('Não percebi, tenta outra vez');
    });
    if (!ok) { inp.focus(); setTimeout(stopUi, 2200); }
  }
  /* Nova UI: os textos da Vera saem sem travessões (no PearOS ficam como sempre) */
  const nd = s => (isA() && typeof s === 'string') ? s.replace(/\s*[\u2014\u2013]\s*/g, ', ') : s;
  function setStatus(t) { t = nd(t); if (statusEl) statusEl.textContent = t || ''; if (isOpen()) islandOrb(true, t || ''); }
  function submit() { const t = inp.value; inp.value = ''; sendBtn.innerHTML = g('mic', 23); run(t); }
  function scrollLog() { if (log) requestAnimationFrame(() => { log.scrollTop = log.scrollHeight; }); }
  function add(node) { log.appendChild(node); scrollLog(); return node; }
  function say(text, o = {}) { const n = UI.el(`<div class="vera-msg vera">${UI.esc(nd(text))}</div>`); add(n); if (!o.silent) Sound.play('pop'); return n; }
  function user(text) { return add(UI.el(`<div class="vera-msg user">${UI.esc(text)}</div>`)); }
  function card(html, cls = '') { const c = UI.el(`<div class="vera-card ${cls}">${nd(html)}</div>`); add(c); return c; }
  function btns(c, list) { const row = UI.el('<div class="vera-btns"></div>'); list.forEach(b => { const x = UI.el(`<div class="vera-btn ${b.primary ? 'primary' : ''} ${b.danger ? 'danger' : ''}">${b.icon ? g(b.icon, 16) : ''}<span>${UI.esc(b.label)}</span></div>`); x.onclick = e => { e.stopPropagation(); Sound.play('click'); b.onTap && b.onTap(x); }; row.appendChild(x); }); c.appendChild(row); return row; }
  function setChips(list) { chipsEl.innerHTML = ''; (list || []).forEach(t => { const s = UI.el(`<span>${UI.esc(t)}</span>`); s.onclick = () => run(t); chipsEl.appendChild(s); }); chipsEl.classList.toggle('empty', !list || !list.length); }
  function paintLive() { if (!isOpen()) return; log.querySelectorAll('[data-live]').forEach(n => { try { n._paint && n._paint(); } catch (e) {} }); }
  const later = (fn, ms = 520) => setTimeout(fn, ms);
  const closeAnd = (fn, ms) => { later(() => { close(); try { fn && fn(); } catch (e) { console.error('[vera]', e); } }, ms); };
  /* executa algo que precisa do telemóvel desbloqueado */
  function guarded(fn) { if (System.locked) { closeAnd(() => Lock.requestUnlock(fn), 200); return isA() ? 'Desbloqueia o telemóvel para continuar.' : 'Desbloqueia o PearPhone para continuar.'; } fn(); return null; }
  const pick = a => a[Math.floor(Math.random() * a.length)];
  const rndSuggest = n => { const a = SUGGEST.slice(); const out = []; while (out.length < n && a.length) out.push(a.splice(Math.floor(Math.random() * a.length), 1)[0]); return out; };

  /* ---------- motor ---------- */
  function register(pattern, fn, hint) { ext.push({ re: pattern instanceof RegExp ? pattern : new RegExp(pattern, 'i'), fn, hint }); }
  function intent(id, res, fn) { intents.push({ id, res: (Array.isArray(res) ? res : [res]), fn }); }
  async function run(text, opts = {}) {
    const raw = String(text || '').trim(); if (!raw) return null; if (!el) return null;
    if (!isOpen() && !opts.quiet) open({ noFocus: true });
    busy = true; user(raw); setStatus('A pensar…'); el.classList.add('listening'); edge.classList.add('listening');
    let t0 = norm(raw).replace(/^(?:ei|ola|hey|oi|o|ok|okay|e ai)?\s*vera[,:\s]*/, '').replace(/^por favor\s+/, '').replace(/\s+por favor$/, '').replace(/[.]+$/, '').trim();
    const t = fix(t0);
    let out = null;
    try {
      for (const c of ext) { const m = t.match(c.re) || raw.match(c.re); if (m) { out = await c.fn(m, raw); break; } }
      if (out === null || out === undefined) for (const it of intents) { let m = null; for (const re of it.res) { m = t.match(re); if (m) break; } if (m) { out = await it.fn(m, raw, t); if (out !== null && out !== undefined) break; } }
    } catch (e) { console.error('[vera]', e); out = 'Ocorreu um erro ao executar isso.'; }
    if (out === null || out === undefined) { const s = rndSuggest(3); out = `Não percebi. Experimenta: "${s[0]}", "${s[1]}" ou "${s[2]}".`; setChips(s); }
    const textOut = typeof out === 'string' ? out : (out && out.text) || '';
    if (textOut) say(textOut);
    busy = false; setStatus(''); el.classList.remove('listening'); edge.classList.remove('listening');
    if (out && typeof out === 'object' && out.chips) setChips(out.chips);
    return textOut;
  }

  /* ---------- cartões ---------- */
  const tileHtml = id => `<div class="vera-tile">${window.Icons ? Icons.tile(id) : ''}</div>`;
  function cardApp(id, sub) { return card(`<div class="vera-row">${tileHtml(id)}<div class="vera-body"><div class="t">${UI.esc(App.name(id))}</div><div class="s">${UI.esc(sub || 'A abrir…')}</div></div>${g('chevR', 21)}</div>`, 'tap'); }
  function cardContact(c, sub) {
    const cc = card(`<div class="vera-row"><div class="vera-av">${UI.avatar(c)}</div><div class="vera-body"><div class="t">${UI.esc(c.name)}</div><div class="s">${UI.esc(sub || c.number)}</div></div></div>`);
    btns(cc, [{ label: 'Ligar', icon: 'phone', primary: true, onTap: () => guarded(() => closeAnd(() => PhoneApp.call(c.number, c.name), 0)) }, { label: 'Mensagem', icon: 'message', onTap: () => guarded(() => closeAnd(() => Msgs.open(c.number, c.name), 0)) }, { label: fcName(), icon: 'video', onTap: () => guarded(() => closeAnd(() => PhoneApp.facetime(c.number, c.name), 0)) }]);
    return cc;
  }
  function cardWeather(w) { const c = card(`<div class="vera-wx ${w.cond}"><div class="l"><div class="city">${UI.esc(w.city)}</div><div class="temp">${w.t}°</div><div class="cond">${WX_LABEL[w.cond]}</div><div class="hl">Máx. ${w.hi}°  Mín. ${w.lo}°</div></div><div class="ic">${g(WX_ICON[w.cond], 54)}</div></div>`, 'vwx tap');
    /* 'vwx' e não 'wx': a .wx é a vista da app Meteorologia (apps.css: position:absolute; inset:0) e o cartão tapava a folha
       inteira da Vera. O padding/borda que a .vera-card.wx tirava (vera.css) vão em linha. */
    c.style.padding = '0'; c.style.border = 'none'; c.onclick = () => guarded(() => closeAnd(() => System.openApp('weather'), 0)); return c; }
  function cardTimer() {
    const c = card(`<div class="vera-row"><div class="vera-ring"><svg viewBox="0 0 48 48"><circle cx="24" cy="24" r="20" fill="none" stroke="var(--fill2)" stroke-width="4"/><circle class="arc" cx="24" cy="24" r="20" fill="none" stroke="var(--orange)" stroke-width="4" stroke-linecap="round" stroke-dasharray="125.7" stroke-dashoffset="0" transform="rotate(-90 24 24)"/></svg>${g('timer', 21)}</div><div class="vera-body"><div class="t big"></div><div class="s">Temporizador</div></div></div>`);
    c.dataset.live = '1'; const big = c.querySelector('.t'), arc = c.querySelector('.arc'); const total = timer ? timer.total : 1;
    c._paint = () => { const end = timerEnd(); if (!end) { big.textContent = 'Terminado'; arc.setAttribute('stroke-dashoffset', 125.7); c.classList.add('done'); delete c.dataset.live; return; } const left = end - Date.now(); big.textContent = fmtMs(left); arc.setAttribute('stroke-dashoffset', 125.7 * (1 - Math.max(0, Math.min(1, left / total)))); };
    c._paint(); btns(c, [{ label: 'Cancelar', icon: 'x', danger: true, onTap: () => { cancelTimer(); c._paint(); say('Temporizador cancelado.'); } }, { label: 'Abrir Relógio', icon: 'clock', onTap: () => guarded(() => closeAnd(() => System.openApp('clock'), 0)) }]);
    return c;
  }
  function cardNav(p) {
    const c = card(`<div class="vera-row"><div class="vera-map">${g(p.garage ? 'car' : 'pin', 22)}</div><div class="vera-body"><div class="t">${UI.esc(p.name)}</div><div class="s">${p.sub ? UI.esc(p.sub) : `Destino marcado no GPS · ${Math.round(p.x)}, ${Math.round(p.y)}`}</div></div></div>`);
    btns(c, [{ label: 'Abrir Mapas', icon: 'map', primary: true, onTap: () => guarded(() => closeAnd(() => { if (window.Maps && Maps.showAt) Maps.showAt({ x: p.x, y: p.y, name: p.name }); System.openApp('maps'); }, 0)) }, { label: 'Parar', icon: 'x', onTap: b => { Bridge.call('removeWaypoint'); b.parentNode.remove(); say('Navegação terminada.'); } }]);
    return c;
  }
  function cardMoney(info) { const c = card(`<div class="vera-money"><div><span class="k">Banco</span><b>${UI.money(info.bank)}</b></div><div><span class="k">Dinheiro</span><b>${UI.money(info.cash)}</b></div></div>`, 'tap'); c.onclick = () => guarded(() => closeAnd(() => System.openApp('wallet'), 0)); return c; }
  function cardMath(expr, result) { return card(`<div class="vera-math"><div class="e">${UI.esc(expr)}</div><div class="r">= ${UI.esc(result)}</div></div>`); }
  function cardNote(title, body, app) { const c = card(`<div class="vera-row">${tileHtml(app)}<div class="vera-body"><div class="t">${UI.esc(title)}</div><div class="s">${UI.esc(body)}</div></div></div>`, 'tap'); c.onclick = () => guarded(() => closeAnd(() => System.openApp(app), 0)); return c; }
  function cardMusic() {
    const c = card(`<div class="vera-row"><div class="vera-art"></div><div class="vera-body"><div class="t"></div><div class="s"></div></div><div class="vera-mctl"><span class="p">${g('prev', 21)}</span><span class="pp">${g('pause', 23)}</span><span class="n">${g('next', 21)}</span></div></div>`);
    c.dataset.live = '1'; c._paint = () => { const t = window.Player && Player.cur(); if (!t) { c.querySelector('.t').textContent = 'Nada a tocar'; c.querySelector('.s').textContent = ''; return; } c.querySelector('.vera-art').style.background = `linear-gradient(135deg,${t.c[0]},${t.c[1]})`; c.querySelector('.t').textContent = t.title; c.querySelector('.s').textContent = `${t.artist} · ${UI.fmtDur(Player.pos)} / ${UI.fmtDur(t.dur)}`; c.querySelector('.pp').innerHTML = g(Player.playing ? 'pause' : 'play', 20); };
    c.querySelector('.p').onclick = () => { Player.prev(); c._paint(); }; c.querySelector('.n').onclick = () => { Player.next(); c._paint(); }; c.querySelector('.pp').onclick = () => { Player.toggle(); c._paint(); }; c._paint(); return c;
  }
  function cardList(items, o = {}) { const c = card(`<div class="vera-list"></div>`); const l = c.firstElementChild; items.forEach(it => { const r = UI.el(`<div class="vera-li">${it.avatar ? `<div class="vera-av sm">${UI.avatar(it.avatar)}</div>` : it.app ? `<div class="vera-tile sm">${Icons.tile(it.app)}</div>` : it.icon ? `<div class="vera-ico" style="background:${it.color || 'var(--blue)'}">${g(it.icon, 16)}</div>` : ''}<div class="vera-body"><div class="t">${UI.esc(it.label)}</div>${it.sub ? `<div class="s">${UI.esc(it.sub)}</div>` : ''}</div>${it.right ? `<div class="r">${UI.esc(it.right)}</div>` : ''}${it.onTap ? g('chevR', 21) : ''}</div>`); if (it.onTap) { r.classList.add('tap'); r.onclick = it.onTap; } l.appendChild(r); }); if (o.buttons) btns(c, o.buttons); return c; }

  /* ---------- intents ---------- */
  function builtins() {
    const A = '(?:a |o |as |os |ao |à |para |para a |para o |na |no |em |de |do |da )?';
    /* saudações / social */
    /* uma saudação só é saudação se não trouxer um pedido atrás: "como está o tempo?" e "bom dia, liga à mãe" seguem para
       os outros intents (devolver null passa ao seguinte). Antes "Como está o tempo?" respondia "Estou ótima, obrigada!". */
    intent('hello', /^(?:ola|oi|bom dia|boa tarde|boa noite|hey|viva|olá|tudo bem|como estas|como vais|como esta)\b/, (m, r, t) => {
      const rest = t.replace(/\b(?:ola|oi|bom dia|boa tarde|boa noite|hey|viva|tudo bem|como estas|como vais|como esta|como te sentes)\b/g, ' ').replace(/\b(?:vera|tu|voce|hoje|contigo|por ai|tudo|bem|entao|e|a|o|ai)\b/g, ' ').replace(/[,.!?]/g, ' ').trim();
      if (rest.split(/\s+/).some(w => w.length > 2)) return null;
      if (/como (?:estas|vais|esta)|tudo bem/.test(t)) return pick(['Estou ótima, obrigada! E tu?', 'Tudo bem por aqui. Em que posso ajudar?', 'Sempre a postos!']); const h = new Date().getHours(); return `${h < 6 ? 'Boa noite' : h < 13 ? 'Bom dia' : h < 20 ? 'Boa tarde' : 'Boa noite'}! Diz-me o que precisas.`; });
    intent('thanks', /^(?:obrigad[oa]|brigad[oa]|valeu|thanks|obg)\b/, () => pick(['De nada!', 'Sempre às ordens.', 'Quando quiseres.']));
    intent('who', /(?:quem es|quem és|o que es tu|como te chamas|qual e o teu nome|es a siri|es um robo|es real)/, () => isA() ? `Sou a Vera, a assistente do teu ${System.osInfo().model}. Funciono sem internet: percebo pedidos em português e trato de chamadas, mensagens, apps, alarmes, mapas e mais.` : 'Sou a Vera, a assistente do teu PearPhone. Funciono sem internet: percebo pedidos em português e trato de chamadas, mensagens, apps, alarmes, mapas e mais.');
    intent('help', /(?:^ajuda\b|o que sabes|o que podes|que comandos|comandos|que consegues|como funciona|o que fazes|instrucoes|lista de comandos)/, () => {
      cardList([{ icon: 'phone', color: 'var(--green)', label: 'Chamadas e mensagens', sub: '"Liga à Mãe", "Manda mensagem ao Rui a dizer olá"' }, { icon: 'timer', color: 'var(--orange)', label: 'Relógio', sub: '"Temporizador de 5 minutos", "Alarme às 7:30"' }, { icon: 'map', color: 'var(--blue)', label: 'Navegação', sub: '"Leva-me ao hospital", "Onde está o meu carro?"' }, { icon: 'gear', color: 'var(--gray)', label: 'Telemóvel', sub: '"Lanterna", "Modo escuro", "Volume a 50%", "Bloqueia"' }, { icon: 'calc', color: 'var(--purple)', label: 'Cálculos e notas', sub: '"Quanto é 12×7?", "Toma nota: …", "Lembra-me de …"' }, { icon: 'music', color: 'var(--pink)', label: 'Música e informação', sub: '"Toca música", "Tempo", "Saldo", "Bateria"' }]);
      return { text: 'Aqui tens algumas coisas que posso fazer. Toca numa sugestão para experimentar.', chips: rndSuggest(6) }; });
    intent('joke', /(?:piada|anedota|faz-me rir|conta-me algo|diz algo engracado|graca)/, () => pick(['Porque é que o telemóvel foi ao médico? Tinha um vírus… e pouca bateria para o aguentar.', 'O meu GPS disse "vira à direita". Virei. Era o mar. Ele também não é perfeito.', 'Sabes qual é a app preferida dos peixes? O Insta-grão.', 'Fui pôr um alarme para as 7 e o telemóvel perguntou "tens a certeza?". Até ele sabe.', 'Um Blista e um Sultan entram numa garagem. O mecânico diz: "isto vai ficar caro".']));
    intent('mood', /(?:gosto de ti|amo-te|es linda|es gira|casas comigo|es fixe)/, () => pick(['Que querido! Mas eu sou só software… muito bem programado.', 'Obrigada! Vamos manter isto profissional.']));

    /* hora / data */
    intent('time', [/^(?:que horas|horas sao|que hora|sao que horas|diz-me as horas|as horas|horas)\b/, /^hora$/], () => `São ${UI.fmtTime(new Date())}.`);
    intent('date', [/(?:que dia e hoje|que dia|dia e hoje|qual e a data|data de hoje|em que dia|dia da semana|que mes|que ano|estamos em)/], (m, r, t) => { const d = new Date(); if (/que ano/.test(t)) return `Estamos em ${d.getFullYear()}.`; return `Hoje é ${UI.fmtDate(d)} de ${d.getFullYear()}.`; });
    intent('agenda', /(?:o que tenho (?:hoje|amanha|marcado|na agenda)|agenda de hoje|eventos de hoje|compromissos|tenho algum evento|proximo evento)/, (m, r, t) => { const d = new Date(); if (/amanha/.test(t)) d.setDate(d.getDate() + 1); const iso = d.toISOString().slice(0, 10); const ev = (Store.get('events', []) || []).filter(e => e.date === iso).sort((a, b) => String(a.time).localeCompare(String(b.time))); if (!ev.length) return `Não tens nada marcado ${/amanha/.test(t) ? 'para amanhã' : 'para hoje'}.`; cardList(ev.slice(0, 5).map(e => ({ icon: 'calendar', color: e.color || 'var(--red)', label: e.title, sub: e.time, onTap: () => guarded(() => closeAnd(() => System.openApp('calendar'), 0)) }))); return `Tens ${ev.length} evento${ev.length === 1 ? '' : 's'} ${/amanha/.test(t) ? 'amanhã' : 'hoje'}.`; });

    /* temporizador */
    intent('timer.left', /(?:quanto (?:tempo )?falta|tempo restante|falta muito|quanto falta)/, () => { const end = timerEnd(); if (!end) return 'Não há nenhum temporizador a contar.'; cardTimer(); return `Faltam ${durText(end - Date.now())}.`; });
    intent('timer.cancel', /(?:cancela|cancelar|para|parar|desliga|apaga|remove)\s+(?:o |a )?(?:temporizador|contagem|timer|cronometro)/, () => cancelTimer() ? 'Temporizador cancelado.' : 'Não há nenhum temporizador ativo.');
    intent('timer', [/(?:temporizador|timer|cronometro|contagem(?: decrescente)?)\s*(?:de |para |com |em |a |:)?\s*(.+)?$/, /^(?:conta|contar|avisa-me daqui a|avisa me daqui a|daqui a|espera|acorda-me daqui a|acorda me daqui a|chama-me daqui a)\s+(.+)$/, /(?:poe|por|mete|coloca|define|cria|inicia|comeca|liga|ativa|comecar|iniciar)\s+(?:um |uma |o |a )?(?:temporizador|timer|contagem|cronometro)\s*(?:de |para |com |em |a )?\s*(.*)$/], (m, r, t) => {
      const rest = m[1] || ''; if (/temporizador|timer|cronometro/.test(rest) && !/\d/.test(numify(rest))) return null;
      const ms = parseDur(rest || t); if (!ms) { if (/cronometro/.test(t)) return guarded(() => closeAnd(() => System.openApp('clock'), 0)) || 'A abrir o Cronómetro.'; return { text: 'Quanto tempo? Por exemplo: "temporizador de 5 minutos".', chips: ['Temporizador 1 min', 'Temporizador 5 min', 'Temporizador 30 segundos'] }; }
      if (ms > 24 * 36e5) return 'O máximo é 24 horas.'; startTimer(ms); cardTimer(); return `Temporizador de ${durText(ms)} a contar.`; });
    /* alarme */
    intent('alarm.list', /(?:que alarmes|alarmes (?:tenho|ativos|definidos)|tenho alarmes?|mostra os alarmes|proximo alarme)/, () => { const l = (Store.get('alarms', [{ id: 1, h: 7, m: 30, label: 'Trabalho', on: true }]) || []).filter(a => a.on).sort((a, b) => a.h * 60 + a.m - b.h * 60 - b.m); if (!l.length) return 'Não tens alarmes ativos.'; cardList(l.slice(0, 5).map(a => ({ icon: 'alarm', color: 'var(--orange)', label: fmtHM(a.h, a.m), sub: a.label || 'Alarme', onTap: () => guarded(() => closeAnd(() => System.openApp('clock'), 0)) }))); return `Tens ${l.length} alarme${l.length === 1 ? '' : 's'} ativo${l.length === 1 ? '' : 's'}.`; });
    /* o `kick` é o `pace` do Agenda (apps/clock.js): a Vera escreve os alarmes com Store.update direto, por
       fora do Agenda.edit, e sem isto o relógio dos avisos só passava ao ritmo de 20 s no tick seguinte -
       até um minuto depois, tempo que chegava para um alarme marcado para já não chegar a tocar. */
    intent('alarm.off', /(?:desliga|desativa|apaga|remove|cancela|tira)\s+(?:o |os |todos os )?(?:alarme|alarmes|despertador)/, () => { let n = 0; Store.update('alarms', [{ id: 1, h: 7, m: 30, label: 'Trabalho', on: true }], l => l.forEach(a => { if (a.on) { a.on = false; n++; } })); if (window.Agenda) Agenda.kick(); if (window.Lock) Lock.renderWidgets(); return n ? `Desliguei ${n} alarme${n === 1 ? '' : 's'}.` : 'Não havia alarmes ativos.'; });
    intent('alarm', [/(?:alarme|despertador|desperta-me|desperta me|acorda-me|acorda me|acordar)\b\s*(?:para |as |às |a |ao |pelas |para as |de |:)?\s*(.+)?$/, /(?:poe|por|mete|coloca|define|cria|marca|ativa)\s+(?:um |o )?(?:alarme|despertador)\s*(?:para |as |às |pelas |para as )?\s*(.*)$/], (m, r, t) => {
      const tm = parseTime(m[1] || ''); if (!tm) return { text: 'Para que horas? Por exemplo: "alarme às 7:30".', chips: ['Alarme às 7:00', 'Alarme às 7:30', 'Acorda-me às 8'] };
      const a = { id: Date.now(), h: tm.h, m: tm.m, label: 'Vera', on: true }; Store.update('alarms', [{ id: 1, h: 7, m: 30, label: 'Trabalho', on: true }], l => { const same = l.find(x => x.h === a.h && x.m === a.m); if (same) same.on = true; else l.push(a); }); if (window.Agenda) Agenda.kick(); if (window.Lock) Lock.renderWidgets();
      const c = card(`<div class="vera-row"><div class="vera-ico lg" style="background:var(--orange)">${g('alarm', 24)}</div><div class="vera-body"><div class="t big">${fmtHM(a.h, a.m)}</div><div class="s">Alarme ativo · toca todos os dias</div></div></div>`); btns(c, [{ label: 'Abrir Relógio', icon: 'clock', onTap: () => guarded(() => closeAnd(() => System.openApp('clock'), 0)) }, { label: 'Remover', icon: 'trash', danger: true, onTap: b => { Store.update('alarms', [], l => { const i = l.findIndex(x => x.h === a.h && x.m === a.m); if (i > -1) l.splice(i, 1); }); if (window.Agenda) Agenda.kick(); if (window.Lock) Lock.renderWidgets(); b.parentNode.parentNode.classList.add('done'); say('Alarme removido.'); } }]);
      return `Alarme definido para as ${fmtHM(a.h, a.m)}.`; });

    /* meteorologia */
    intent('weather', /(?:\btempo\b(?! restante)|meteorologia|clima|chover|chuva|chove|temperatura|graus|esta frio|esta calor|previsao|faz sol|esta sol|ha sol|guarda-chuva|nublado)/, (m, r, t) => { const w = weatherNow(); cardWeather(w); const rain = w.c === 'rain' || w.c === 'storm'; const est = w.measured ? '' : ' (ainda sem medição do jogo)'; if (/chov|chuva|guarda-chuva/.test(t)) return rain ? `Sim, ${w.c === 'storm' ? 'há trovoada' : 'está a chover'} em ${w.city}. Leva o guarda-chuva!` : `Não está a chover em ${w.city}: ${(WX_LABEL[w.cond] || w.label).toLowerCase()} e cerca de ${w.t}°${est}.`; const D = { rain: 'chove', storm: 'há trovoada', cloudy: 'está nublado', snow: 'neva', fog: 'há nevoeiro', night: 'o céu está limpo', sunny: 'o céu está limpo' }; return `Em ${w.city} estão cerca de ${w.t}° e ${D[w.cond] || 'o céu está limpo'}${w.blackout ? ', e há um apagão na cidade' : ''}. Hoje a máxima foi ${w.hi}° e a mínima ${w.lo}°${est}.`; });

    /* ---------- rede ----------
       Os interruptores do Centro de controlo mandam mesmo (CC.online): o que precisa do servidor recusa com
       a razão certa em vez de fingir uma resposta. Antes o modo de voo não impedia nada. */
    const noNet = o => (window.CC && CC.online && !CC.online()) ? (System.state.airplane ? `Estás em modo de voo: sem rede não consigo ${o}.` : `Não tens rede: liga o Wi-Fi ou os dados móveis para eu ${o}.`) : null;
    /* dinheiro */
    intent('money', /(?:saldo|quanto dinheiro|quanto tenho|conta bancaria|no banco|dinheiro tenho|dinheiro vivo|carteira|quanto e que tenho|financas)/, async () => { const off = noNet('consultar o banco'); if (off) return off; let info = null; try { info = await Bridge.rpc('bank.info'); } catch (e) {} const p = System.player || {}; const bank = info && info.bank != null ? info.bank : (p.money && p.money.bank) || 0, cash = info && info.cash != null ? info.cash : (p.money && p.money.cash) || 0; cardMoney({ bank, cash }); return `Tens ${UI.money(bank)} no banco e ${UI.money(cash)} em dinheiro.`; });
    intent('battery', /(?:bateria|quanta carga|carga tenho|percentagem da bateria|preciso de carregar)/, () => { const b = System.state.battery, lp = System.state.lowPower; const c = card(`<div class="vera-row"><div class="vera-ico lg" style="background:${b <= 20 ? 'var(--red)' : 'var(--green)'}">${g('battery', 24)}</div><div class="vera-body"><div class="t big">${b}%</div><div class="s">${lp ? 'Modo de poupança ativo' : b <= 20 ? 'Bateria fraca, convém carregar' : 'Bateria em bom estado'}</div></div></div>`); btns(c, [{ label: lp ? 'Desativar poupança' : 'Ativar poupança', icon: 'battery', onTap: () => { System.setState({ lowPower: !System.state.lowPower }); say(`Modo de poupança ${System.state.lowPower ? 'ativado' : 'desativado'}.`); } }]); return `A bateria está a ${b}%${lp ? ', com o modo de poupança ativo' : ''}.`; });
    intent('me', /(?:quem sou eu|o meu numero|meu numero|qual e o meu numero|numero de telefone do meu|o meu telefone)/, () => `És ${System.account && System.account.username ? '@' + System.account.username : (System.player.firstname + ' ' + System.player.lastname)} e o teu número é ${UI.phone(System.player.phone)}.`);

    /* garagem / navegação */
    intent('car', [/(?:onde (?:esta|estao|deixei|tenho|para|estacionei|ficou|fica) (?:o |a )?(?:meu |minha )?(?:carro|veiculo|mota|moto|viatura|carrinha|sultan|blista))/, /(?:localiza|localizar|encontra|encontrar|procura|procurar|acha|achar|marca)\s+(?:o |a )?(?:meu |minha )?(?:carro|veiculo|mota|moto|viatura|carrinha)/, /(?:leva-me|leva me|vai|navega)\s+(?:ao |a |ate ao |para o )(?:meu )?(?:carro|veiculo|mota)/, /(?:os meus|meus) (?:carros|veiculos)|que (?:carros|veiculos) tenho/], async (m, r, t) => {
      const off = noNet('consultar a tua garagem'); if (off) return off;
      let list = []; try { list = (await Bridge.rpc('garage.vehicles')) || []; } catch (e) {}
      if (!list.length) return 'Não encontrei veículos em teu nome.';
      if (/os meus|meus (?:carros|veiculos)|que (?:carros|veiculos)/.test(t)) { cardList(list.slice(0, 6).map(v => ({ icon: 'car', color: v.state === 1 ? 'var(--green)' : v.state === 2 ? 'var(--red)' : 'var(--orange)', label: vehName(v), sub: `${v.plate} · ${v.state === 1 ? (v.garage || 'Na garagem') : v.state === 2 ? 'Apreendido' : 'Fora da garagem'}`, onTap: () => guarded(() => closeAnd(() => System.openApp('garage'), 0)) }))); return `Tens ${list.length} veículo${list.length === 1 ? '' : 's'}.`; }
      const named = list.find(v => t.includes(norm(vehName(v)))) ; const v = named || list.find(x => x.favorite) || list.find(x => x.state === 0) || list[0];
      const st = v.state === 1 ? `Na garagem${v.garage ? ' · ' + cap(v.garage.replace(/garage/i, '')) : ''}` : v.state === 2 ? 'Apreendido: no depósito' : 'Fora da garagem';
      let msg;
      if (v.state === 1 && v.coords) { Bridge.call('setWaypoint', { x: v.coords.x, y: v.coords.y, name: v.garage || 'Garagem' }); cardNav({ name: vehName(v), sub: `${v.plate} · ${st} · GPS marcado`, x: v.coords.x, y: v.coords.y, garage: true }); msg = `O teu ${vehName(v)} está na garagem. Marquei-a no GPS.`; }
      else if (v.state === 2) { cardNav({ name: vehName(v), sub: `${v.plate} · ${st}`, x: 0, y: 0, garage: true }); msg = `O teu ${vehName(v)} foi apreendido. Tens de o recuperar no depósito da polícia.`; }
      else { let res = null; try { res = await Bridge.call('locateVehicle', { plate: v.plate }); } catch (e) {} if (res && res.x !== undefined) { cardNav({ name: vehName(v), sub: `${v.plate} · Localizado · GPS marcado`, x: res.x, y: res.y, garage: true }); msg = `Encontrei o teu ${vehName(v)} e marquei-o no GPS.`; } else { cardNav({ name: vehName(v), sub: `${v.plate} · ${st}`, x: 0, y: 0, garage: true }); msg = `O teu ${vehName(v)} está fora da garagem, mas não o encontrei perto de ti.`; } }
      return msg; });
    intent('nav', [/^(?:leva-me|leva me|levar-me|levar me|leva|vai|guia-me|guia me|navega|navegar|navegacao|direcoes|direccoes|caminho|rota|marca (?:no )?gps|gps para|gps ate|ir)\s+(?:para |ate |ate ao |ate a |a |ao |à |o |a |de |em )?(.+)$/, /(?:como (?:chego|vou|ir|posso ir|e que vou|e que chego)|qual e o caminho|onde fica|onde e|onde esta)\s+(?:a |ao |à |para |ate |o |a |de )?(.+)$/], (m, r, t) => {
      const q = m[1]; const p = findPlace(q); if (!p) return `Não conheço "${q.trim()}". Experimenta "hospital", "banco", "oficina" ou "garagem".`;
      Bridge.call('setWaypoint', { x: p.x, y: p.y, name: p.name }); if (window.Maps && Maps.showAt) Maps.showAt({ x: p.x, y: p.y, name: p.name }); cardNav(p); return `${/onde/.test(t) ? p.name + ' está marcado no GPS.' : 'A caminho de ' + p.name + '. Marquei o destino no GPS.'}`; });
    intent('where', /^(?:onde estou|onde e que estou|a minha localizacao|localizacao atual|mostra o mapa|mostra-me o mapa)/, () => guarded(() => closeAnd(() => System.openApp('maps'), 0)) || 'A abrir Mapas com a tua localização.');

    /* toggles de sistema */
    const TOG = [[/wifi|wi-fi|wi fi/, 'wifi', 'Wi-Fi'], [/bluetooth/, 'bt', 'Bluetooth'], [/modo de voo|modo aviao|modo de aviao|avião/, 'airplane', 'Modo de voo'], [/lanterna|luz do telemovel|flash/, 'torch', 'Lanterna'], [/nao incomodar|nao perturbar|foco|concentracao/, 'dnd', 'Não incomodar'], [/hotspot|partilha de internet/, 'hotspot', 'Hotspot'], [/modo escuro|tema escuro|modo noturno|aparencia escura|dark mode/, 'dark', 'Modo escuro'], [/modo claro|tema claro|aparencia clara|light mode/, 'light', 'Modo claro'], [/silencio|silencioso|sem som|mudo|vibracao|som do telemovel|toque/, 'silent', 'Modo de silêncio'], [/poupanca|baixo consumo|low power/, 'lowPower', 'Modo de poupança'], [/localizacao|gps\b/, 'locationOn', 'Localização'], [/dados moveis|dados/, 'cellular', 'Dados móveis'], [/vpn/, 'vpn', 'VPN']];
    /* o "Bloqueio de rotação" saiu (2026-09-16): o ecrã do telemóvel é fixo, não há modo horizontal - a Vera
       dizia "Bloqueio de rotação ativado" sobre algo que nunca acontece (o mosaico do CC saiu pela mesma razão) */
    const isOn = k => k === 'dark' ? !!System.state.dark : k === 'light' ? !System.state.dark : k === 'torch' ? !!System.state.torch : !!System.state[k];
    function toggleKey(k, on, label) {
      if (k === 'torch') { System.torch(on); return `Lanterna ${on ? 'ligada' : 'desligada'}.`; }
      if (k === 'dark' || k === 'light') { const dark = k === 'dark' ? on : !on; System.setState({ theme: dark ? 'dark' : 'light' }); return `Modo ${dark ? 'escuro' : 'claro'} ativado.`; }
      if (k === 'silent') { if (window.Hardware && Hardware.silent) Hardware.silent(on); else { System.setState({ silent: on }, { noApply: true }); System.renderStatus(); } return `Modo de silêncio ${on ? 'ativado' : 'desativado'}.`; }
      /* modo de voo: o mesmo patch do Centro de controlo (desliga Wi-Fi, dados e hotspot) e a consequência
         é real - o que precisa do servidor recusa enquanto estiver ligado */
      if (k === 'airplane') { System.setState({ airplane: on, wifi: !on, cellular: !on, hotspot: on ? false : System.state.hotspot }); return on ? 'Modo de voo ligado. Ficas sem Wi-Fi nem dados móveis.' : 'Modo de voo desligado. Wi-Fi e dados móveis ligados.'; }
      /* hotspot: honesto - só o indicador na barra de estado, não partilha ligação com ninguém */
      if (k === 'hotspot') { System.setState({ hotspot: on, airplane: on ? false : System.state.airplane }); return on ? 'Hotspot ligado. Aparece na barra de estado, mas não partilha ligação com ninguém.' : 'Hotspot desligado.'; }
      /* Wi-Fi / dados com o modo de voo ligado: desliga-se o modo de voo, como no Centro de controlo - não se
         grava um estado impossível (dados ligados dentro do modo de voo) nem se anuncia o que não aconteceu */
      if ((k === 'wifi' || k === 'cellular') && on && System.state.airplane) { System.setState({ [k]: on, airplane: false }); return `${label} ligado. Desliguei o modo de voo.`; }
      if (k === 'bt' && !on && System.state.earbuds && window.Earbuds && Earbuds.disconnect) Earbuds.disconnect();   /* sem Bluetooth não há earbuds */
      System.setState({ [k]: on }); return `${label} ${on ? 'ativado' : 'desativado'}${k === 'dnd' && on ? ': não vais receber notificações' : ''}.`;
    }
    const findTog = t => TOG.find(([re]) => re.test(t));
    intent('tog.on', /^(?:ativa|ativar|liga|ligar|acende|acender|poe|por|mete|meter|coloca|colocar|abre|ligar o|ativa o|quero|entra em|entrar em|passa para|muda para)\s+(?:o |a |os |as |em |para |no |na |o modo |modo )?(.+)$/, (m, r, t) => { const tg = findTog(m[1]); if (!tg) return null; if (/^(?:abre)/.test(t) && !/lanterna/.test(m[1])) return null; return toggleKey(tg[1], true, tg[2]); });
    intent('tog.off', /^(?:desativa|desativar|desliga|desligar|apaga|apagar|tira|tirar|remove|remover|sai de|sair de|fecha|para)\s+(?:o |a |os |as |em |do |da |o modo |modo )?(.+)$/, (m, r, t) => { const tg = findTog(m[1]); if (!tg) return null; return toggleKey(tg[1], false, tg[2]); });
    intent('tog.bare', /^(?:o |a |modo )?(?:lanterna|modo escuro|modo claro|tema escuro|tema claro|dark mode|light mode|silencio|modo silencioso|modo de silencio|nao incomodar|modo de voo|modo aviao|wifi|wi-fi|bluetooth|hotspot|poupanca de bateria|modo de poupanca|vpn)$/, (m, r, t) => { const tg = findTog(t); if (!tg) return null; return toggleKey(tg[1], !isOn(tg[1]), tg[2]); });
    intent('tog.ask', /(?:esta|está|tenho)\s+(?:a |o )?(lanterna|wifi|bluetooth|modo escuro|modo de voo|nao incomodar|silencio)\s+(?:ligad[oa]|ativ[oa]|ativad[oa])/, m => { const tg = findTog(m[1]); if (!tg) return null; return `${tg[2]}: ${isOn(tg[1]) ? 'ligado' : 'desligado'}.`; });

    /* volume / brilho */
    const level = (t, key, label, hud) => {
      const cur = System.state[key] || 0; let v = null; const n = t.match(/(\d{1,3})\s*(?:%|por cento|porcento)?/);
      if (/maximo|no max|ao maximo|todo|tudo/.test(t)) v = 100; else if (/minimo|zero|sem som|mudo|desliga/.test(t)) v = 0; else if (/metade|meio/.test(t)) v = 50;
      else if (/aumenta|sobe|mais alto|mais forte|mais|sube|para cima|aumentar/.test(t)) v = Math.min(100, cur + 15); else if (/baixa|desce|diminui|menos|mais baixo|mais fraco|para baixo|reduz/.test(t)) v = Math.max(0, cur - 15);
      else if (n) v = Math.max(0, Math.min(100, +n[1]));
      if (v === null) return `${label} está a ${cur}%.`;
      if (key === 'volume' && window.Hardware && Hardware.volume) Hardware.volume(v - cur); else System.setState({ [key]: v });
      return `${label} a ${System.state[key]}%.`; };
    intent('volume', /\bvolume\b|\bsom\b(?! do)|mais alto|mais baixo/, (m, r, t) => level(t, 'volume', 'Volume'));
    intent('bright', /\bbrilho\b|luminosidade|ecra mais (?:claro|escuro)/, (m, r, t) => level(t.replace(/mais escuro/, 'baixa').replace(/mais claro/, 'aumenta'), 'brightness', 'Brilho'));

    /* fundo */
    intent('wallpaper', [/(?:muda|mudar|troca|trocar|altera|alterar|poe|por|define|definir|mete|escolhe)\s+(?:o |a |um |uma )?(?:fundo|imagem de fundo|papel de parede|wallpaper|fundo de ecra)(?:\s+(?:para|a|em|de|do|por|pelo)\s+(.+))?/, /^(?:fundo|papel de parede|wallpaper)\s*(?:para |em |de |do )?(.*)$/], m => { const w = findWallpaper(m[1] || ''); if (!w) return `Não tenho um fundo "${(m[1] || '').trim()}". Tenho: ${(Wallpapers.SETS || []).map(s => s.name).slice(0, 6).join(', ')}…`; System.setState({ wallpaper: w.id, wallpaperCustom: null, lockWallpaper: null }); const c = card(`<div class="vera-row"><div class="vera-wp" style="background-image:${w.css}"></div><div class="vera-body"><div class="t">${UI.esc(w.name)}</div><div class="s">Fundo aplicado ao ecrã principal e bloqueado</div></div></div>`, 'tap'); c.onclick = () => guarded(() => closeAnd(() => System.openApp('settings'), 0)); return `Fundo alterado para ${w.name}.`; });

    /* matemática */
    function calc(t) {
      let s = numify(t.replace(/^(?:quanto (?:e|sao|da|faz|e que e|e que da)|calcula|calcular|resultado de|qual e o resultado de|qual e|conta)\s*/, '').replace(/[?=]+$/, '').trim());
      s = s.replace(/(\d+(?:[.,]\d+)?)\s*(?:%|por cento|porcento)\s*(?:de|do|da|dos|das)\s*(\d+(?:[.,]\d+)?)/g, '(($2)*($1)/100)').replace(/(\d+(?:[.,]\d+)?)\s*(?:%|por cento)/g, '(($1)/100)');
      s = s.replace(/raiz(?: quadrada)?\s*(?:de|do|da)?\s*(\d+(?:[.,]\d+)?)/g, 'sqrt($1)').replace(/raiz(?: quadrada)?\s*(?:de|do|da)?\s*\(/g, 'sqrt(').replace(/raiz cubica\s*(?:de)?\s*(\d+(?:[.,]\d+)?)/g, 'cbrt($1)');
      s = s.replace(/(\d+(?:[.,]\d+)?)\s*ao quadrado/g, '(($1)**2)').replace(/(\d+(?:[.,]\d+)?)\s*ao cubo/g, '(($1)**3)').replace(/(\d+)\s*fatorial|fatorial de\s*(\d+)/g, (m, a, b) => 'fact(' + (a || b) + ')');
      s = s.replace(/\bvezes\b|\bmultiplicado por\b|×|\*/g, '*').replace(/\ba dividir por\b|\bdividir por\b|\bdividido por\b|\bsobre\b|÷|:/g, '/').replace(/\bmais\b|\bsomar\b/g, '+').replace(/\bmenos\b|\bsubtrair\b/g, '-').replace(/\belevado a\b|\bpotencia\b|\^/g, '**').replace(/\bpi\b/g, '3.141592653589793').replace(/\bx(?=\s*[\d(])/g, '*');
      s = s.replace(/(\d)\.(\d{3})(?!\d)/g, '$1$2').replace(/(\d),(\d)/g, '$1.$2').replace(/\s+/g, '');
      const clean = s.replace(/sqrt|cbrt|fact/g, ''); if (!/\d/.test(clean) || !/^[\d.+\-*/()%]+$/.test(clean) || !/[+\-*/%]|sqrt|cbrt|fact/.test(s)) return null;
      try { const fact = n => { n = Math.round(n); if (n < 0 || n > 170) return NaN; let r = 1; for (let i = 2; i <= n; i++) r *= i; return r; }; const v = new Function('sqrt', 'cbrt', 'fact', 'return (' + s + ')')(Math.sqrt, Math.cbrt, fact); if (typeof v !== 'number' || !isFinite(v)) return { s, err: /\/0/.test(s) ? 'Não dá para dividir por zero.' : 'Não consegui calcular isso.' }; return { s, v }; } catch (e) { return null; }
    }
    intent('math', [/^(?:quanto (?:e|sao|da|faz|e que e|e que da)|calcula|calcular|resultado de|qual e o resultado de|conta)\b(.*)$/, /(?:raiz(?: quadrada| cubica)? de|por cento de|% de|ao quadrado|ao cubo|fatorial)/, /^[\d\s.,+\-*/×÷x^()%]+$/, /^\d[\d\s.,]*\s*(?:mais|menos|vezes|a dividir por|dividido por|elevado a)\s*\d/], (m, r, t) => { const c = calc(t); if (!c) return null; const shown = r.replace(/^(?:quanto (?:é|e|são|sao|dá|da|faz)|calcula|calcular)\s*/i, '').replace(/[?=]+$/, '').trim(); if (c.err) return c.err; cardMath(shown, fmtNum(c.v)); return `${shown} = ${fmtNum(c.v)}`; });

    /* chamadas / facetime / mensagens */
    intent('facetime', [/(?:facecall|facetime|videochamada|chamada de video|video chamada)\s+(?:com |a |ao |à |para |para o |para a |o |a )?(.+)$/, /(?:liga|ligar|chama|chamar|telefona)\s+(?:a |ao |à |para |para o |para a )?(.+?)\s+(?:por|via|no|pelo|em|com)\s+(?:facecall|facetime|video|videochamada)$/], m => { const c = findContact(m[1]); if (!c) return `Não tenho o contacto "${m[1].trim()}".`; if (!window.PhoneApp) return 'As chamadas não estão disponíveis.'; cardContact(c, fcName()); return guarded(() => closeAnd(() => PhoneApp.facetime(c.number, c.name))) || `A ligar por ${fcName()} a ${c.name}.`; });
    intent('call', [/^(?:liga|ligar|telefona|telefonar|chama|chamar|faz uma chamada|fazer uma chamada|marca|marcar|telefonema)\s+(?:a |ao |à |para |para a |para o |o |a |com |uma chamada a |uma chamada para )?(.+)$/, /^(?:quero falar com|fala com|falar com)\s+(?:o |a )?(.+)$/], (m, r, t) => { const q = m[1].trim(); if (findTog(q) && !findContact(q)) return null; const c = findContact(q); if (!c) return { text: `Não tenho o contacto "${q}". Queres abrir os Contactos?`, chips: ['Abrir Contactos', 'Liga à Mãe'] }; if (!window.PhoneApp) return 'As chamadas não estão disponíveis.'; if (c.raw) { return guarded(() => closeAnd(() => PhoneApp.call(c.number))) || `A ligar para ${c.number}.`; } cardContact(c, 'A ligar…'); return guarded(() => closeAnd(() => PhoneApp.call(c.number, c.name))) || `A ligar a ${c.name}.`; });
    function parseMsg(rest, rawRest) {
      const low = strip(rawRest).toLowerCase(); const seps = [' a dizer que ', ' a dizer-lhe que ', ' a dizer ', ' a perguntar se ', ' a perguntar ', ' a avisar que ', ' dizendo que ', ' dizendo ', ' com o texto ', ' que diga ', ': ', ' que '];
      for (const s of seps) { const i = low.indexOf(s); if (i > 0) return { c: findContact(rawRest.slice(0, i)), text: rawRest.slice(i + s.length).trim() }; }
      return splitContact(rawRest);
    }
    intent('msg', [/^(?:envia|enviar|manda|mandar|escreve|escrever|mandar uma|envia uma)\s+(?:uma |um )?(?:mensagem|sms|texto|msg|whatsapp)\s+(?:a |ao |à |para |para a |para o |pro |pra )?(.+)$/, /^(?:diz|dizer|avisa|avisar|pergunta|perguntar)\s+(?:a |ao |à |para |para a |para o )?(.+)$/, /^(?:mensagem|sms|msg)\s+(?:a |ao |à |para |para a |para o )?(.+)$/, /^(?:responde|responder)\s+(?:a |ao |à )?(.+)$/], async (m, raw, t) => {
      const rawRest = raw.slice(raw.length - m[1].length); const { c, text } = parseMsg(m[1], rawRest);
      if (!c) return { text: `A quem queres enviar? Não encontrei "${m[1].split(/ a dizer| que |:/)[0].trim()}" nos contactos.`, chips: ['Manda mensagem à Mãe a dizer estou a chegar'] };
      if (!text) { cardContact(c, 'Abrir conversa'); return guarded(() => closeAnd(() => Msgs.open(c.number, c.name))) || `A abrir a conversa com ${c.name}. O que queres dizer?`; }
      if (System.locked) return guarded(() => Msgs.open(c.number, c.name));
      /* enviar é anunciar um efeito ("Mensagem enviada a X"): sem rede não se anuncia nem se envia, como no
         saldo e na garagem. Abrir a conversa (acima) continua a funcionar - isso é local. */
      const offMsg = noNet('enviar mensagens'); if (offMsg) return offMsg;
      let r = null; try { r = await Bridge.rpc('messages.send', { to: c.number, type: 'text', content: text }); } catch (e) {}
      if (r === null) return `Não consegui enviar a mensagem a ${c.name}.`;
      Sound.play('send'); const cc = card(`<div class="vera-row"><div class="vera-av">${UI.avatar(c)}</div><div class="vera-body"><div class="t">${UI.esc(c.name)}</div><div class="s">${UI.esc(c.number)}</div></div></div><div class="vera-bubble">${UI.esc(text)}</div>`); btns(cc, [{ label: 'Abrir conversa', icon: 'message', onTap: () => guarded(() => closeAnd(() => Msgs.open(c.number, c.name), 0)) }]);
      if (window.Msgs && Msgs.badge) Msgs.badge(); return `Mensagem enviada a ${c.name}.`; });
    intent('contact', [/(?:qual e o|qual o|diz-me o|diz me o|sabes o|mostra o|mostra-me o|da-me o|preciso do)\s+(?:numero|telefone|contacto|telemovel)\s+(?:de |do |da |dos |das |d)?(.+)$/, /^(?:numero|contacto|telefone)\s+(?:de |do |da )(.+)$/, /^(?:procura|procurar|pesquisa|pesquisar|encontra|mostra|mostrar|ver)\s+(?:o |a )?(?:contacto|contato)\s+(?:de |do |da )?(.+)$/], m => { const c = findContact(m[1]); if (!c || c.raw) return `Não tenho nenhum contacto chamado "${m[1].trim()}".`; cardContact(c); return `O número de ${c.name} é ${c.number}.`; });
    intent('contacts.all', /^(?:os meus contactos|meus contactos|lista de contactos|quantos contactos tenho|contactos favoritos)/, () => { const cs = (window.Contacts && Contacts.cache) || []; const fav = cs.filter(c => c.favorite); const l = (fav.length ? fav : cs).slice(0, 5); if (!cs.length) return 'Não tens contactos guardados.'; cardList(l.map(c => ({ avatar: c, label: c.name, sub: c.number, onTap: () => guarded(() => closeAnd(() => PhoneApp.call(c.number, c.name), 0)) }))); return `Tens ${cs.length} contacto${cs.length === 1 ? '' : 's'}${fav.length ? `, ${fav.length} favorito${fav.length === 1 ? '' : 's'}` : ''}. Toca num para ligar.`; });

    /* mensagens / notificações por ler */
    intent('inbox', [/(?:tenho|ha|existem|recebi|chegaram)\s+(?:alguma |algumas |novas |mensagens |notificacoes |sms )*(?:mensagens?|notificacoes|notificacao|sms|novidades)\b/, /(?:le|ler|mostra|mostrar|ve|ver)\s+(?:as |os |minhas |meus |ultimas |novas )*(?:mensagens|notificacoes|sms)/, /^(?:mensagens|notificacoes|novidades)(?: novas| por ler| nao lidas)?$/, /(?:ultimas|novas) (?:mensagens|notificacoes)/, /perdi alguma coisa/], async (m, r, t) => {
      if (/notific|novidades|perdi/.test(t)) { const all = (window.Notify && Notify.all()) || []; const un = all.filter(n => !n.read); if (!un.length) return 'Não tens notificações por ler.'; /* pré-visualização da app ('never' ou 'unlocked' com o telemóvel bloqueado) esconde o texto também aqui */ const hid = n => { const p = window.Notify && Notify.appSettings ? Notify.appSettings(n.app).preview : 'always'; return p === 'never' || (p === 'unlocked' && System.locked); }; cardList(un.slice(0, 4).map(n => ({ app: n.app, label: hid(n) ? 'Notificação' : n.title, sub: hid(n) ? '' : n.msg, right: UI.rel(n.ts), onTap: () => closeAnd(() => Notify.open(n), 0) }))); return `Tens ${un.length} notificaç${un.length === 1 ? 'ão' : 'ões'} por ler${un.length > 4 ? ', mostro as 4 mais recentes' : ''}.`; }
      /* as notificações acima são locais e continuam a ser lidas sem rede; a caixa de entrada vem do servidor.
         O saldo e a garagem também são LEITURAS e já recusam sem rede: recusar aqui é a mesma regra, não uma
         nova. (A app Mensagens continua a abrir e a ler - essa é outra conversa, registada no control.js.) */
      const offInbox = noNet('ver as tuas mensagens'); if (offInbox) return offInbox;
      /* sem conversas o Lua manda {} (não []): o .filter rebentava. Os grupos (Fase 2) vêm com number 'g:<id>' e name = título: o Msgs.open abre o grupo */
      let th = []; try { th = await Bridge.rpc('messages.threads', { app: 'sms' }); } catch (e) {} th = Array.isArray(th) ? th : (window.Msgs && Msgs.arr ? Msgs.arr(th) : []); const un = th.filter(x => x && x.unread > 0);
      if (!un.length) return 'Não tens mensagens novas.'; cardList(un.slice(0, 4).map(x => { const nm = x.name || (window.Contacts ? Contacts.name(x.number) : x.number); return { avatar: (window.Contacts && Contacts.byNumber(x.number)) || { name: nm }, label: nm, sub: x.last ? (window.Msgs ? Msgs.label(x.last) : x.last.content) : '', right: x.unread + (x.unread === 1 ? ' nova' : ' novas'), onTap: () => guarded(() => closeAnd(() => Msgs.open(x.number, nm), 0)) }; }));
      const total = un.reduce((a, x) => a + x.unread, 0); return `Tens ${total} mensage${total === 1 ? 'm nova' : 'ns novas'} de ${un.length} conversa${un.length === 1 ? '' : 's'}.`; });

    /* música */
    /* biblioteca do jogador (app Música = TubeMusic via apex_carplay): gostos, guardadas, recentes e playlists */
    const tracks = () => { if (!window.Music || !Music.MU) return []; const MU = Music.MU; const ids = new Set(); [].concat(MU.lib || [], MU.likes || [], MU.recents || [], ...(MU.playlists || []).map(p => p.tracks || [])).forEach(id => ids.add(id)); return [...ids].map(id => Music.song(id)).filter(Boolean).map(s => ({ id: s.id, title: s.t, artist: s.a || '', album: s.alb || '' })); };
    intent('music.pause', /^(?:pausa|pausar|para a musica|parar a musica|para de tocar|stop|silencia a musica|desliga a musica|para a musica)/, () => { if (window.Player && Player.playing) { Player.toggle(); cardMusic(); return 'Música em pausa.'; } return 'Não está a tocar nada.'; });
    intent('music.next', /^(?:proxima|seguinte|next|salta|passa a frente|passa a musica|muda de musica|outra musica)/, () => { if (!window.Player || !Player.cur()) return 'Não está a tocar nada.'; Player.next(); cardMusic(); return `A tocar ${Player.cur().title}.`; });
    intent('music.prev', /^(?:anterior|volta atras|musica anterior|repete|repetir|outra vez|de novo)/, () => { if (!window.Player || !Player.cur()) return 'Não está a tocar nada.'; Player.prev(); cardMusic(); return `A tocar ${Player.cur().title}.`; });
    intent('music.what', /(?:que musica e esta|o que esta a tocar|que musica esta a tocar|que esta a dar|qual e esta musica|que musica e)/, () => { const t = window.Player && Player.cur(); if (!t) return 'Não está a tocar nada.'; cardMusic(); return `Está a tocar ${t.title}, de ${t.artist}.`; });
    intent('music', [/^(?:toca|tocar|play|reproduz|reproduzir|poe|por|mete|coloca|ouvir|quero ouvir|da-me|da me)\s+(?:a |o |uma |um |alguma |as |os )?(?:musica|musicas|som|album|playlist|banda|artista)?\s*(?:d[eoa]s? |do |da |de )?(.*)$/, /^(?:continua|retoma|retomar|continuar|resume)\b/, /^musica$/], (m, r, t) => {
      if (!window.Player || !window.Music) return 'A Música não está disponível.'; const q = norm(m[1] || '').replace(/^(?:a |o |um |uma )/, '').trim();
      if (/^(?:continua|retoma|resume)/.test(t) || (!q && Player.cur())) { if (!Player.cur()) return 'Não há nada para retomar.'; if (!Player.playing) Player.toggle(); cardMusic(); return `A tocar ${Player.cur().title}.`; }
      const all = tracks(); const generic = !q || /^(?:musica|alguma coisa|qualquer coisa|algo|som)$/.test(q); const who = x => x.artist || 'artista desconhecido';
      if (generic) {
        if (!all.length) return guarded(() => closeAnd(() => System.openApp('music'), 0)) || 'A abrir a Música.';
        const i = Math.floor(Math.random() * all.length); Player.shuffle = false; Music.start(all.map(x => x.id), { k: 'lib', label: 'Biblioteca' }, all[i].id); cardMusic(); return `A tocar ${all[i].title}, de ${who(all[i])}.`;
      }
      /* 1.º na biblioteca do jogador… */
      const hit = all.find(x => norm(x.title) === q) || all.find(x => norm(x.title).includes(q)) || all.find(x => norm(x.artist).includes(q)) || all.find(x => norm(x.album).includes(q)) || all.find(x => sim(x.title, q) >= .6) || all.find(x => sim(x.artist, q) >= .6);
      if (hit) { const list = hit.album ? all.filter(x => x.album === hit.album) : all; Player.shuffle = false; Music.start(list.map(x => x.id), { k: 'lib', label: 'Biblioteca' }, hit.id); cardMusic(); return `A tocar ${hit.title}, de ${who(hit)}.`; }
      /* …senão pesquisa no TubeMusic (mesma API do CarLink) e toca o 1.º resultado */
      const raw = (m[1] || '').trim(); Player.shuffle = false;
      return Music.playQuery(raw).then(s => { if (!s) return `Não encontrei "${raw}" no TubeMusic.`; cardMusic(); return `A tocar ${s.t}, de ${s.a || 'artista desconhecido'}.`; }).catch(() => `Não consegui pesquisar "${raw}" agora. Vê se o apex_carradio está ligado.`); });

    /* notas / lembretes */
    intent('note', [/^(?:toma nota|tomar nota|anota|anotar|aponta|apontar|nota|escreve|escrever|regista|guarda)\s*(?:que |de |isto |isto: |: |:)?\s*(.+)$/, /^(?:cria|criar|faz|fazer|nova|adiciona)\s+(?:uma |a )?nota\s*(?:com |a dizer |que diga |: |:)?\s*(.*)$/], (m, raw) => { const text = raw.slice(raw.length - m[1].length).replace(/^[:\s]+/, '').trim(); if (!text) return { text: 'O que queres anotar?', chips: ['Toma nota: comprar pão', 'Cria uma nota lista de compras'] }; const n = { id: Date.now(), text: cap(text), ts: Date.now() }; Store.update('notes', [], l => l.push(n)); cardNote(cap(text).split('\n')[0], 'Nota guardada · ' + UI.fmtTime(new Date()), 'notes'); return 'Nota guardada.'; });
    intent('notes.list', /(?:as minhas notas|minhas notas|ultima nota|le a nota|que notas tenho|mostra as notas)/, () => { const l = (Store.get('notes', []) || []).slice().sort((a, b) => b.ts - a.ts); if (!l.length) return 'Ainda não tens notas.'; cardList(l.slice(0, 4).map(n => ({ app: 'notes', label: n.text.split('\n')[0].slice(0, 40), sub: UI.rel(n.ts), onTap: () => guarded(() => closeAnd(() => System.openApp('notes'), 0)) }))); return `Tens ${l.length} nota${l.length === 1 ? '' : 's'}.`; });
    intent('reminder.list', /(?:os meus lembretes|meus lembretes|que lembretes|lembretes (?:tenho|de hoje|pendentes)|o que tenho para fazer|tarefas)/, () => { const l = (Store.get('reminders', []) || []).filter(x => !x.done); if (!l.length) return 'Não tens lembretes pendentes.'; cardList(l.slice(0, 5).map(x => ({ icon: 'checkCircle', color: 'var(--blue)', label: x.text, sub: x.due ? 'Às ' + UI.fmtTime(new Date(x.due)) : (x.flag ? 'Sinalizado' : ''), onTap: () => guarded(() => closeAnd(() => System.openApp('reminders'), 0)) }))); return `Tens ${l.length} lembrete${l.length === 1 ? '' : 's'} pendente${l.length === 1 ? '' : 's'}.`; });
    intent('reminder', [/^(?:lembra-me|lembra me|lembrar-me|lembrar me|lembrete|lembrar|recorda-me|recorda me|nao me deixes esquecer|avisa-me|avisa me)\s*(?:de |para |que |: |:)?\s*(.+)$/, /^(?:cria|criar|adiciona|novo|poe|mete)\s+(?:um |o )?lembrete\s*(?:para |de |: |:)?\s*(.+)$/], (m, raw, t) => {
      let text = raw.slice(raw.length - m[1].length).trim(); let due = null; const n = norm(text);
      const tm = n.match(/\b(?:as|às|a|pelas|para as)\s+(\d{1,2}(?:\s*[:h]\s*\d{0,2})?(?:\s+e\s+(?:meia|um quarto))?(?:\s+da (?:manha|tarde|noite))?)\s*$/); const dq = n.match(/\bdaqui a\s+(.+)$/); const tomorrow = /\bamanha\b/.test(n);
      if (dq && parseDur(dq[1])) { due = Date.now() + parseDur(dq[1]); text = text.slice(0, strip(text).toLowerCase().lastIndexOf('daqui a')).trim(); }
      else if (tm && parseTime(tm[1])) { const p = parseTime(tm[1]); const d = new Date(); d.setHours(p.h, p.m, 0, 0); if (tomorrow || d.getTime() < Date.now()) d.setDate(d.getDate() + 1); due = d.getTime(); text = text.slice(0, strip(text).toLowerCase().lastIndexOf(strip(tm[0]).trim())).trim(); }
      else if (tomorrow) { const d = new Date(); d.setDate(d.getDate() + 1); d.setHours(9, 0, 0, 0); due = d.getTime(); }
      text = text.replace(/\bamanha\b/i, '').replace(/\s+/g, ' ').replace(/[,:\s]+$/, '').trim(); if (!text) return { text: 'Do que te lembro?', chips: ['Lembra-me de pagar a renda às 18:00', 'Lembra-me de ligar à Mãe amanhã'] };
      const rem = { id: Date.now(), text: cap(text), done: false, ts: Date.now(), due }; Store.update('reminders', [], l => l.push(rem));
      /* quem avisa é o relógio da agenda (apps/clock.js): este ficheiro só GRAVA. O setTimeout que aqui
         estava dava DOIS avisos ao mesmo lembrete (dois cartões no Centro de Notificações e dois sons
         diferentes) e, ainda por cima, só cobria as 12 h seguintes. O Agenda avisa a qualquer distância. */
      if (window.Agenda) Agenda.kick();
      if (window.Lock) Lock.renderWidgets(); const when = due ? (tomorrow ? `amanhã às ${UI.fmtTime(new Date(due))}` : `às ${UI.fmtTime(new Date(due))}`) : 'sem hora';
      cardNote(cap(text), `Lembrete · ${when}`, 'reminders'); return `Lembrete criado: "${cap(text)}"${due ? ', ' + when : ''}.`; });

    /* câmara / bloquear / apps */
    intent('photo', /(?:tira|tirar|faz|fazer|saca|sacar|captura)\s+(?:uma |um |a )?(?:foto|fotografia|selfie|fotos|imagem)|abre a camara|abrir camara|camara$/, (m, r, t) => { const selfie = /selfie/.test(t); if (!App.get('camera')) return 'A Câmara não está disponível.'; const snap = /tira|tirar|faz|fazer|saca|sacar|captura/.test(t); return guarded(() => closeAnd(() => { /* A Vera ABRE a Câmara - não dispara: a fotografia é só no botão redondo do telemóvel (pedido do
   utilizador). O `camera:shutter` que aqui estava não tinha ouvinte nenhum, era um gesto morto.
   Numa selfie ainda vira a lente, que é enquadrar e não disparar; espera-se pelo evento da app
   (o pedido de permissão pode meter-se à frente de qualquer prazo fixo). */
const offOpen = Bridge.on('app:open', id => { if (id !== 'camera') return; offOpen(); if (selfie) Bridge.emit('camera:front'); });
setTimeout(offOpen, 20000); System.openApp('camera'); })) || (snap ? `A abrir a Câmara para ${selfie ? 'a selfie' : 'a foto'}.` : 'A abrir a Câmara.'); });
    intent('lock', /(?:bloqueia|bloquear|tranca|trancar|desliga o ecra|apaga o ecra|fecha o telemovel|bloqueia o telemovel|bloquear o ecra)/, () => { closeAnd(() => { if (window.Hardware && Hardware.sleep) Hardware.sleep(); else Lock.lock(); }); return isA() ? 'A bloquear o telemóvel.' : 'A bloquear o PearPhone.'; });
    intent('close', /^(?:fecha|fechar|sai|sair|adeus|tchau|xau|ate logo|bye|dispensada|obrigado vera)\b/, () => { closeAnd(null, 600); return pick(['Até já!', 'Sempre que precisares.', 'Até logo!']); });
    intent('home', /^(?:vai para o ecra principal|ecra principal|home|fecha a app|fechar app|sai da app)/, () => { closeAnd(() => System.closeApp()); return 'A ir para o ecrã principal.'; });
    intent('open', /^(?:abre|abrir|abre-me|abre me|vai para|vai a|mostra|mostrar|lanca|lancar|inicia|iniciar|entra em|entra no|entra na|corre|executa)\s+(?:a |o |as |os |app |a app |o app |aplicacao |a aplicacao )?(.+)$/, m => { const q = m[1].trim(); const id = findApp(q); if (!id) { if (findTog(q)) return null; return { text: `Não encontrei a app "${q}".`, chips: ['Abrir Mapas', 'Abrir Mensagens', 'Abrir Definições'] }; } if (!System.isInstalled(id)) return { text: `A app ${App.name(id)} não está instalada. Podes instalá-la na AppShop.`, chips: ['Abrir AppShop'] }; cardApp(id); return guarded(() => closeAnd(() => System.openApp(id))) || `A abrir ${App.name(id)}.`; });
    intent('open.bare', /^(.+)$/, (m, r, t) => { const q = t; if (q.split(' ').length > 3) return null; const id = findApp(q); if (!id || !System.isInstalled(id)) return null; if (sim(App.name(id), q) < .6 && !APP_ALIAS[q]) return null; cardApp(id); return guarded(() => closeAnd(() => System.openApp(id))) || `A abrir ${App.name(id)}.`; });
  }

  return { init, open, close, toggle, run, register, isOpen, ask: run, get timerEnd() { return timerEnd(); }, _norm: norm, _parseDur: parseDur, _parseTime: parseTime };
})();
