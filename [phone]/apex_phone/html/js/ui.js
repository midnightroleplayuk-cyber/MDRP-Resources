/* ============================================================
   UI - mini-framework PearOS: views, navegação, listas, toggles,
   tab bar, alerts, sheets, action sheets, menus de contexto,
   banners, gestos utilitários
   ============================================================ */
window.UI = (() => {
  const g = Icons.g;
  const T = s => (window.L && L.t ? L.t(s) : s);   /* strings do próprio mini-framework também mudam com o idioma escolhido */
  const el = html => { const t = document.createElement('template'); t.innerHTML = html.trim(); return t.content.firstElementChild; };
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const pad = n => String(n).padStart(2, '0');
  /* Formato 24 horas (System.state.clock24, Definições › Ecrã / Data e Hora). Ligado é o "09:41" de
     sempre; desligado é o relógio de 12 h do PearPhone, "9:41", sem AM/PM (como na barra de estado e no
     ecrã bloqueado). Lido na hora de formatar: o ui.js carrega antes do system.js. */
  const fmtTime = d => { const s = window.System && System.state; const h = d.getHours();
    if (s && s.clock24 === false) return `${(h % 12) || 12}:${pad(d.getMinutes())}`;
    return `${pad(h)}:${pad(d.getMinutes())}`; };
  const DIAS = ['Domingo','Segunda-feira','Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sábado'];
  const DIAS_C = ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb'];
  const MESES = ['janeiro','fevereiro','março','abril','maio','junho','julho','agosto','setembro','outubro','novembro','dezembro'];
  /* datas no idioma escolhido (L) via Intl; em português mantém-se o formato próprio */
  /* lower = como o PearOS escreve a data no ecrã bloqueado: em português tudo em minúsculas ("terça-feira, 8 de setembro"); nos outros idiomas fica a forma nativa do Intl */
  const fmtDate = (d, short, lower) => { if (window.L && L.code !== 'pt') { try { const s = new Intl.DateTimeFormat(L.intl(), short ? { day: 'numeric', month: 'short' } : { weekday: 'long', day: 'numeric', month: 'long' }).format(d); return lower ? s : s.charAt(0).toUpperCase() + s.slice(1); } catch (e) {} }
    const dia = lower ? DIAS[d.getDay()].toLowerCase() : DIAS[d.getDay()];
    return short ? `${d.getDate()} ${MESES[d.getMonth()].slice(0, 3)}` : `${dia}, ${d.getDate()} de ${MESES[d.getMonth()]}`; };
  /* nomes de dias e meses no idioma escolhido (2026-10-03, idiomas: o EN passou a ser o de origem). Em português ficam as listas
     de cima (o formato próprio de sempre); nos outros idiomas é o Intl. Usar estes e nunca DIAS/DIAS_C/MESES colados com "de". */
  const notPt = () => !!(window.L && L.code && L.code !== 'pt' && L.intl);
  const intlFmt = (d, o) => { try { return new Intl.DateTimeFormat(L.intl(), o).format(d); } catch (e) { return ''; } };
  const cap1 = s => s ? s.charAt(0).toUpperCase() + s.slice(1) : s;
  const wdShort = d => (notPt() && cap1(intlFmt(d, { weekday: 'short' }).replace(/\.$/, ''))) || DIAS_C[d.getDay()];
  const wdLong = d => (notPt() && cap1(intlFmt(d, { weekday: 'long' }))) || DIAS[d.getDay()];
  /* letra do dia i (0 = domingo, como o getDay): "D S T Q Q S S" em português, "S M T W T F S" em inglês. 4 jan 2026 é um domingo */
  const wdNarrow = i => (notPt() && intlFmt(new Date(2026, 0, 4 + i), { weekday: 'narrow' }).toUpperCase()) || ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][i];
  const wdShortI = i => wdShort(new Date(2026, 0, 4 + i));
  const monthName = (m, short) => (notPt() && intlFmt(new Date(2026, m, 1), { month: short ? 'short' : 'long' }).replace(/\.$/, '')) || (short ? MESES[m].slice(0, 3) : MESES[m]);
  /* "3 de outubro" (com o ano se for outro: "3 de outubro de 2025") */
  const fmtDayMonth = (d, withYear) => (notPt() && intlFmt(d, withYear ? { day: 'numeric', month: 'long', year: 'numeric' } : { day: 'numeric', month: 'long' })) || (`${d.getDate()} de ${MESES[d.getMonth()]}` + (withYear ? ` de ${d.getFullYear()}` : ''));
  /* "Seg, 3 out" */
  const fmtWdDayMon = d => (notPt() && cap1(intlFmt(d, { weekday: 'short', day: 'numeric', month: 'short' }))) || `${DIAS_C[d.getDay()]}, ${d.getDate()} ${MESES[d.getMonth()].slice(0, 3)}`;
  const fmtDur = s => { s = Math.max(0, Math.floor(s)); const h = Math.floor(s / 3600), m = Math.floor(s % 3600 / 60), x = s % 60; return (h ? h + ':' + pad(m) : m) + ':' + pad(x); };
  /* Moeda: símbolo e posição vêm do Config.Currency (payload `ready`); o formato do número segue o idioma do telemóvel.
     Antes era 'pt-PT' + ' €' fixo: num servidor americano a Carteira, as Faturas e a loja mostravam euros. */
  const currency = () => { const c = window.System && System.config && System.config.currency; return (c && typeof c === 'object') ? c : { symbol: '$', position: 'before' }; };
  const cur = () => String(currency().symbol || '$');
  const numLocale = () => { try { return window.L && L.code && L.code !== 'pt' && L.intl ? L.intl() : 'pt-PT'; } catch (e) { return 'pt-PT'; } };
  const fmtNum = (n, min = 0, max = 2) => { try { return (+n || 0).toLocaleString(numLocale(), { minimumFractionDigits: min, maximumFractionDigits: max }); } catch (e) { return String(+n || 0); } };
  /* opts.int = sem casas decimais; opts.symbol = outro símbolo (catálogos das apps de trabalho) */
  const money = (n, opts) => { const c = currency(); const v = Math.round((+n || 0) * 100) / 100; const s = fmtNum(Math.abs(v), opts && opts.int ? 0 : 2, 2); const sym = String((opts && opts.symbol) || c.symbol || '$'); const before = c.position !== 'after'; const sp = c.space != null ? (c.space ? ' ' : '') : (before ? '' : ' '); return (v < 0 ? '-' : '') + (before ? sym + sp + s : s + sp + sym); };
  const rel = ts => { const d = new Date(+ts), n = new Date(); if (d.toDateString() === n.toDateString()) return fmtTime(d); const y = new Date(n); y.setDate(n.getDate() - 1); if (d.toDateString() === y.toDateString()) return 'Ontem'; if (n - d < 6 * 864e5) return wdShort(d); return fmtDate(d, true); };
  const timeAgo = ts => { const s = Math.floor((Date.now() - +ts) / 1000); if (s < 60) return 'agora'; if (s < 3600) return Math.floor(s / 60) + ' min'; if (s < 86400) return Math.floor(s / 3600) + ' h'; if (s < 7 * 86400) return Math.floor(s / 86400) + ' d'; return fmtDate(new Date(+ts), true); };
  const screen = () => document.getElementById('screen');
  /* escala do ecrã (px do rato → px do telemóvel), em CACHE 250 ms: os arrastos liam getBoundingClientRect em cada pointermove, o que força um
     layout por frame (com 7 janelas retidas era o que engasgava os gestos no CEF). Agora no máximo 4 leituras por segundo. */
  let kz = 1, kzT = -1e9;
  /* largura do ecrã em px do telemóvel: 440, ou 880 no PearPhone Fold aberto (System.SW). Dividir sempre por 440 dava
     uma escala a dobrar no fold: os arrastos andavam metade e os menus caíam no sítio errado. */
  const SWpx = () => (window.System && System.SW) || 440;
  /* ZOOM NOS DOIS MOTORES (2026-10-03). O conteúdo das apps no PearPhone Fold tem zoom próprio (ui.css, --az) por cima do zoom do
     aparelho (.stage, no jogo). O clientX/clientY dos eventos é sempre em px reais do ecrã, mas o getBoundingClientRect NÃO:
     o Chromium do jogo (CEF 103, como qualquer Chromium antes do 128) devolve-o dividido pelo zoom EFETIVO do próprio elemento, o
     browser dos testes (Chromium 128+) devolve px reais. Por isso, para contas que misturam contextos (ponteiro com retângulos, um
     elemento com zoom e outro sem):
       UI.vrect(el)  retângulo em px REAIS do ecrã nos dois motores
       UI.zoom(el)   px reais do ecrã por px do próprio el (o produto dos zoom de el e dos antepassados: aparelho × app)
       UI.zoom()     sem argumento é o de sempre (a escala do ecrã medida pelo retângulo dele, em cache)
     Um arrasto: delta do ponteiro / UI.zoom(elemento que se mexe). Uma posição: (UI.vrect(a).left - UI.vrect(b).left) / UI.zoom(b). */
  let zsemV = '';
  const zsem = () => { if (zsemV) return zsemV;
    try { const a = document.createElement('div'); a.style.cssText = 'position:absolute;left:0;top:0;zoom:2;visibility:hidden;pointer-events:none'; const b = document.createElement('div'); b.style.cssText = 'width:10px;height:10px'; a.appendChild(b); (document.body || document.documentElement).appendChild(a); const w = b.getBoundingClientRect().width; a.remove(); zsemV = w > 15 ? 'new' : 'old'; } catch (e) { zsemV = 'new'; }
    return zsemV; };
  /* o zoom de cada elemento lê-se do estilo calculado (os dois motores dão o valor declarado: "1.45"); em cache 250 ms por elemento,
     para os arrastos que perguntam a cada pointermove */
  const zc = new WeakMap();
  const zoomOf = el => { if (!el || el.nodeType !== 1) return 1; const now = performance.now(), c = zc.get(el); if (c && now - c.t < 250) return c.z;
    let z = 1; for (let n = el; n && n.nodeType === 1; n = n.parentElement) { const v = parseFloat(getComputedStyle(n).zoom); if (v > 0 && v !== 1) z *= v; }
    zc.set(el, { z, t: now }); return z; };
  const vrect = el => { const r = el.getBoundingClientRect(); if (zsem() === 'new') return r; const z = zoomOf(el); if (z === 1) return r;
    return { left: r.left * z, top: r.top * z, right: r.right * z, bottom: r.bottom * z, width: r.width * z, height: r.height * z, x: r.left * z, y: r.top * z }; };
  const zoom = el => { if (el && el.nodeType === 1) return zoomOf(el);
    const now = performance.now(); if (now - kzT > 250) { const w = screen().getBoundingClientRect().width; kz = w > 0 ? w / SWpx() : 1; kzT = now; } return kz; };
  const initials = n => String(n || '?').trim().split(/\s+/).map(x => x[0] || '').join('').slice(0, 2).toUpperCase();
  /* Paleta dos avatares no espírito dos Contact Posters do PearOS: tons compostos, não fluorescentes
     (pedido do utilizador 2026-09-09 no passo Avatar do assistente; é a mesma paleta usada em
     Contactos, Mensagens e Definições, por isso a mudança é global e intencional). */
  const AVC = ['#7C818C,#A9AEB8', '#D9526B,#E08A57', '#3B7FD4,#63B4E0', '#4FA86A,#3FA79A', '#9A6BC4,#6C65C0', '#DD9A47,#E0C05F', '#D25A52,#D97A76', '#7E8288,#4A4D52', '#3FA79A,#3B7FD4', '#9C8465,#6B5843', '#6C65C0,#9A6BC4', '#D6B44F,#DD9A47'];
  const avatarStyle = seed => { const [a, b] = AVC[Math.abs(+seed || 0) % AVC.length].split(','); return `background:linear-gradient(160deg,${a},${b})`; };
  const avatar = (o, cls = '') => { const name = typeof o === 'string' ? o : (o && (o.name || o.username)) || '?'; const url = o && o.url; const seed = (o && (o.avatar || o.seed)) || 0;
    if (url && /^(https?:|data:|nui:)/.test(url)) return `<div class="avatar ${cls}"><img src="${esc(url)}" alt=""></div>`;
    return `<div class="avatar ${cls}" style="${avatarStyle(typeof seed === 'number' ? seed : name.length)}">${esc(initials(name))}</div>`; };
  /* ⚠️ ASPAS SIMPLES: este valor é quase sempre injetado dentro de style="…" por innerHTML e, com
     aspas duplas, o parser de HTML fecha o atributo no primeiro `"` do url(…) - a imagem
     desaparecia e o base64 virava dezenas de atributos de lixo (Mensagens, Onion, Match,
     Marketplace, DarkChat). O `'` que não pode aparecer dentro do url() vai escapado. */
  const img = src => !src ? '' : (typeof src === 'number' ? (window.photoBg ? photoBg(src) : '#555') : `url('${String(src).replace(/'/g, '%27')}')`);
  const linkify = t => esc(t).replace(/(^|\s)(#[\wÀ-ÿ]+)/g, '$1<span class="hashtag" data-tag="$2">$2</span>').replace(/(^|\s)(@[\w.]+)/g, '$1<span class="hashtag" data-user="$2">$2</span>');

  /* ---------- Nova UI (telemovel Android, docs/ANDROID.md) ----------
     A API e a MESMA nos dois sistemas: so muda o desenho. Tudo o que e Android passa por isA() e o CSS vive em
     oneui-ui.css, sempre debaixo de body.os-android. As janelas das apps do SISTEMA levam `.ou-app` (barras, listas,
     interruptores e separadores Nova UI); as apps de terceiros (Instashot, Zapp, Match, Eats...) ficam iguais nos
     dois telemoveis, como no mundo real, e levam `.ou-3p`. Folhas, dialogos, menus e toasts sao do sistema: levam
     sempre o desenho Nova UI no Android (`.ou-dlg`, `.ou-sheet`, `.ou-as`, `.ou-ctx`, `.ou-toast`). */
  const isA = () => !!(window.System && System.os === 'android');
  /* o texto da Nova UI nao usa travessoes: os avisos partilhados com o PearOS (erros do servidor, toasts das apps) passam por aqui no Android */
  const ouTxt = s => typeof s === 'string' ? s.replace(/\s+[\u2013\u2014]\s+/g, ', ') : s;
  const OU_APPS = new Set(['settings', 'phone', 'contacts', 'messages', 'facetime', 'photos', 'camera', 'clock', 'calculator', 'notes', 'reminders', 'calendar', 'weather', 'mail', 'music', 'wallet', 'maps', 'findmy', 'safari', 'appstore', 'aichat', 'home']);
  const ouMark = node => { if (!node || !isA()) return; const w = node.classList && node.classList.contains('app-window') ? node : (node.closest ? node.closest('.app-window') : null);
    if (!w || w.classList.contains('ou-app') || w.classList.contains('ou-3p')) return;
    w.classList.add(!w.classList.contains('external') && OU_APPS.has(w.dataset.app || '') ? 'ou-app' : 'ou-3p'); };
  const inOU = node => !!(node && node.closest && node.closest('.ou-app'));
  /* camadas (dialogo, folha, lista de acoes, menu, seletor): no Android levam a Nova UI, o desenho da plataforma. A
     excecao sao as apps de TERCEIROS (Dark Chat, Onion, Zapp, Instashot...): sao iguais nos dois telemoveis e muitas
     tingem as camadas com o tema delas (cls, ou uma classe posta logo a seguir, como o Dark Chat), por isso as camadas
     abertas com uma delas a frente ficam como no PearOS. O menu decide pelo elemento tocado (o ecra principal e o painel
     sao do sistema). O toast simples e sempre do sistema; so um toast com o tema de uma app de terceiros fica como e. */
  const thirdWin = w => !!w && !w.classList.contains('ou-app') && (w.classList.contains('ou-3p') || w.classList.contains('external') || !OU_APPS.has(w.dataset.app || ''));
  const thirdFront = () => { try { const id = window.System && System.currentApp && System.currentApp(); if (!id) return false; const w = System.windows && System.windows[id]; return w ? thirdWin(w) : !OU_APPS.has(id); } catch (e) { return false; } };
  /* ecra de chamada do sistema a vista (por cima de qualquer app): as camadas dele (saida de audio, respostas rapidas) sao do sistema */
  const callUp = () => { try { const c = window.PhoneApp && PhoneApp.current; return !!(c && ((c.el && c.el.isConnected && !c.min) || (c.ui && c.ui.nodeType === 1 && c.ui.isConnected))); } catch (e) { return false; } };
  const ouLayer = (cls, node) => { if (!isA()) return false;
    if (node && node.closest) { const w = node.closest('.app-window'); return !thirdWin(w); }
    if (callUp()) return true;
    return !thirdFront(); };
  /* barra de 3 botoes por baixo (a de origem): camadas e menus ficam acima dela. Sem o atributo conta como botoes. */
  const navOff = () => isA() && document.body.dataset.nav !== 'gesture' ? 48 : 0;
  /* abrir uma app do sistema no Android marca a janela logo (ha apps que desenham listas antes do setRoot) */
  if (window.Bridge && Bridge.on) Bridge.on('app:open', id => { try { const w = window.System && System.windows && System.windows[id]; if (w) ouMark(w); } catch (e) {} });

  /* ---------- View ---------- */
  function view(o = {}) {
    const v = el(`<div class="view ${o.cls || ''} ${o.full ? 'full' : ''}"><div class="navbar"><div class="nb-left"></div><div class="nb-title">${esc(o.title || '')}</div><div class="nb-right"></div></div><div class="content"></div></div>`);
    const nav = v.querySelector('.navbar'), left = v.querySelector('.nb-left'), right = v.querySelector('.nb-right'), content = v.querySelector('.content');
    v.content = content; v.navbar = nav; v.opts = o;
    if (o.back) { const b = el(`<div class="nb-back lg">${g('chevL')}<span>${esc(o.back === true ? T('Anterior') : o.back)}</span></div>`); b.onclick = () => o.onBack ? o.onBack(v) : pop(v); left.appendChild(b); }
    (o.left || []).forEach(btn => left.appendChild(navBtn(btn)));
    (o.right || []).forEach(btn => right.appendChild(navBtn(btn)));
    if (o.large) content.appendChild(el(`<div class="large-title">${esc(o.title || '')}</div>`)); else nav.classList.add('show-title');
    if (o.transparent) nav.classList.add('transparent');
    if (o.solid) nav.classList.add('solid');
    /* Nova UI: o titulo grande vive na "zona de leitura" (terco de cima) e, ao fazer scroll, sobe mais devagar do que
       a lista, desvanece e passa para a barra. So opacity/transform (regra do CEF), lidos uma vez e escritos por evento. */
    const A = isA(); if (A) v.classList.add('ou-view');
    let ouLt = null, ouH = 0, ouOn = null;
    const ouScroll = y => { if (ouOn === null) { ouOn = inOU(v); ouLt = ouOn ? content.querySelector(':scope > .large-title') : null; if (ouLt) ouH = ouLt.offsetHeight || 168; }
      if (!ouLt) return false; const k = Math.max(0, Math.min(1, y / (ouH * .62)));
      ouLt.style.opacity = (1 - k).toFixed(3); ouLt.style.transform = y > 0 ? `translateY(${Math.min(y, ouH) * .38}px)` : '';
      nav.classList.toggle('show-title', y > ouH - 34); nav.classList.toggle('solid', y > ouH - 6); return true; };
    /* scroll: barra sólida + título inline (Large Title → inline); a tab bar flutuante compacta-se ao descer e expande ao subir */
    let lastY = 0, tbEl = null;
    content.addEventListener('scroll', () => { const y = content.scrollTop;
      if (!(A && o.large && ouScroll(y))) { if (!o.transparent && !o.solid) nav.classList.toggle('solid', y > 6); if (o.large) nav.classList.toggle('show-title', y > 38); }
      if (tbEl === null) { const w = v.closest('.app-window'); tbEl = (w && w.querySelector(':scope > .tabbar')) || false; }
      if (tbEl) { const dy = y - lastY; if (dy > 4 && y > 60) tbEl.classList.add('compact'); else if (dy < -4 || y < 20) tbEl.classList.remove('compact'); } lastY = y; }, { passive: true });
    v.setTitle = t => { v.querySelector('.nb-title').textContent = t; const lt = content.querySelector('.large-title'); if (lt) lt.textContent = t; };
    /* PearPhone Fold: os botões da barra vão para a barra direita (railSync); o.rail = botões próprios desta vista. A barra só é
       vigiada com a barra direita ligada (as que já existiam passam a sê-lo quando se troca para o PearPhone Fold, foldRelayout) */
    v._rid = ++ridSeq; if (o.rail) v.rail = o.rail; if (railOn()) navWatch(nav);
    return v;
  }
  /* .nb-ico: botão só com glifo (o círculo de 40 do liquid27.css; o CEF não tem :has() para o descobrir sozinho).
     data-key: o rótulo de ORIGEM de um botão de texto, para a barra direita escolher o glifo pela chave e não pelo texto à vista
     (traduzido pelo i18n.js: "Editar" vira "Bearbeiten" e o glifo deixava de ser encontrado) */
  function navBtn(btn) { const b = el(`<div class="nb-btn lg ${btn.icon ? 'nb-ico' : ''} ${btn.bold ? 'bold' : ''} ${btn.cls || ''}">${btn.icon ? g(btn.icon) : esc(btn.label || '')}</div>`); b.onclick = e => btn.onTap && btn.onTap(b, e);
    if (btn.icon) { b.dataset.ic = btn.icon; if (btn.label) b.dataset.lb = btn.label; }   /* o glifo e o nome viajam para a barra direita do PearPhone Fold */
    else if (btn.label) b.dataset.key = btn.label;
    if (btn.ref) btn.ref(b); return b; }

  /* ---------- Navegação ---------- */
  /* Vista de título grande com a barra VAZIA (sem voltar e sem botões): o PearOS encosta o título grande à barra de estado.
     Nós reservávamos na mesma os 44 px da barra e ficava uma faixa branca por cima do título em quase todas as apps.
     A marcação é feita aqui (e não em view()) porque há apps que acrescentam botões DEPOIS de a vista ser criada. */
  const markBare = v => { if (!v || !v.classList) return; const nb = v.querySelector(':scope > .navbar'); if (!nb) return;
    /* Nova UI: a barra nunca se sobrepoe ao titulo grande (ele vive na zona de leitura, por baixo da barra) */
    if (inOU(v)) { v.classList.remove('lg-bare'); return; }
    const vis = el => { const cs = getComputedStyle(el); return cs.display !== 'none' && cs.visibility !== 'hidden' && parseFloat(cs.opacity) > .01; };
    /* PearPhone Fold: voltar e botões estão na barra direita; só o que não é botão (cabeçalho de conversa, marca) segura a linha */
    if (railOn()) { const rn = [...nb.querySelectorAll('.nb-right > :not(.nb-btn)')].filter(vis).length; v.style.setProperty('--lg-btnw', (rn ? rn * 52 + 16 : 20) + 'px');
      v.classList.toggle('lg-bare', !!v.querySelector(':scope > .content > .large-title') && ![...nb.querySelectorAll('.nb-left > :not(.nb-btn):not(.nb-back)')].some(vis)); return; }
    /* Botões À DIREITA não impedem o colapso: passam a ficar ao NÍVEL do título grande, como na Wallet e na AppShop da Apple.
       Só o botão de voltar (e algo à esquerda) obriga a manter a linha, senão ficaria por cima do título.
       Botões invisíveis não contam (o avatar da AppShop só aparece depois do scroll). */
    const left = [...nb.querySelectorAll('.nb-back, .nb-left > *')].some(vis);
    const right = [...nb.querySelectorAll('.nb-right > *')].filter(vis).length;
    v.style.setProperty('--lg-btnw', (right ? right * 52 + 16 : 20) + 'px');   /* o título nunca corre por baixo dos botões */
    v.classList.toggle('lg-bare', !!v.querySelector(':scope > .content > .large-title') && !left); };
  const stackOf = node => node.classList && node.classList.contains('nav-stack') ? node : (node.closest('.nav-stack') || node.querySelector('.nav-stack'));
  /* ⚠️ `cur` é a vista que fica POR BAIXO: nunca uma que esteja a sair (.leave), senão empurrar uma página
     logo a seguir a voltar deixava a que sai com .behind e a de baixo deslocada para a esquerda.
     E o duplo rAF corre um ou dois frames depois: entretanto um setRoot (trocar de separador) ou um pop
     podem ter mudado a pilha - sem estas guardas, o rAF voltava a pôr .behind na vista que já é raiz
     (é a faixa branca com o conteúdo deslocado 28% que se via na AppShop). */
  function push(from, v) { const stack = stackOf(from); let cur = stack.lastElementChild;
    while (cur && (cur.classList.contains('leave') || cur.classList.contains('pane-out'))) cur = cur.previousElementSibling;
    ouMark(stack);
    if (stack.classList.contains('split') && splitSwap(stack, from, v)) { Sound.play('click'); railSoon(stack.closest('.app-window')); return v; }
    rootSel(stack);
    v.classList.add('enter'); stack.appendChild(v); markBare(v); updateTabbar(stack); paneMark(stack); railSoon(stack.closest('.app-window'));
    requestAnimationFrame(() => requestAnimationFrame(() => {
      if (v.parentNode !== stack) return;   /* a vista já saiu da pilha */
      v.classList.remove('enter');
      if (cur && cur.parentNode === stack && stack.lastElementChild !== cur && !(stack.classList.contains('split') && cur === stack.firstElementChild)) cur.classList.add('behind');
    })); Sound.play('click'); return v; }
  function pop(from) { const stack = stackOf(from); if (!stack) return false; const v = stack.lastElementChild; let prev = v && v.previousElementSibling;
    while (prev && prev.classList.contains('pane-out')) prev = prev.previousElementSibling;   /* dobrável: o detalhe trocado ainda a desvanecer não conta */
    if (!prev) return false;
    v.classList.add('leave'); prev.classList.remove('behind'); setTimeout(() => { v.remove(); updateTabbar(stack); }, 420); updateTabbar(stack, prev); paneMark(stack); railSoon(stack.closest('.app-window')); v.opts && v.opts.onPop && v.opts.onPop(); return true; }
  /* troca a vista de CIMA por outra sem empilhar (o email anterior/seguinte da barra direita): a nova aparece por cima (opacidade e um
     deslize curto) e a antiga sai depois. Sem nada empilhado por cima da raiz é um push normal. */
  function replace(from, v) { const stack = stackOf(from); if (!stack) return v; const lv = liveViews(stack), old = lv[lv.length - 1];
    if (!old || lv.length < 2) return push(from, v);
    ouMark(stack);
    try { const f = old.opts && old.opts.onPop; if (old.opts) old.opts.onPop = null; if (f) f(); } catch (e) { console.error('[apex_phone] onPop', e); }
    old.classList.add('pane-out'); v.classList.add('v-swap', 'v-in'); stack.appendChild(v); markBare(v); updateTabbar(stack); paneMark(stack);
    requestAnimationFrame(() => requestAnimationFrame(() => v.classList.remove('v-in')));
    setTimeout(() => { old.remove(); v.classList.remove('v-swap'); }, 340);
    railSoon(stack.closest('.app-window')); Sound.play('click'); return v; }

  /* ---------- Dobráveis: lista | detalhe (contrato v2, 2026-10-02) ----------
     Os dois dobráveis (PearPhone Fold e NOVA Fold8) têm o ecrã de fora (670, fechado) e o de dentro (1340, aberto). Uma app
     pode chamar UI.split(win, { icon, title, sub, row }): ABERTO a pilha passa a duas colunas, a RAIZ (a lista, --split-l de
     largura, ui.css) à esquerda e o resto da pilha à direita; FECHADO é uma pilha de uma coluna, como num telemóvel.
     - um toque na RAIZ troca o detalhe (não empilha); dentro do detalhe empilha-se como sempre;
     - sem detalhe aberto vê-se o aviso (icon/title/sub) na coluna da direita;
     - `row` é o seletor da linha da raiz que fica marcada (por omissão .li);
     - `first` (true ou um seletor): aberto e sem detalhe, abre logo a primeira linha (ou a primeira que case com o seletor), como as
       Definições dos dois sistemas; sem ele fica o aviso (Mensagens, Email, Contactos e Notas podem ficar vazios);
     - abrir, fechar ou trocar de aparelho com a app aberta refaz a pilha (Bridge 'fold:state' / 'form:changed').
     Larguras (ui.css): --split-l = lista 520 no NOVA Fold8 (com a barra lateral, a lista começa a seguir a ela) e 456 no PearPhone
     Fold. No NOVA as barras das duas colunas são COMPACTAS (64 px, título 22/700 à esquerda; oneui-ui.css).
     No PearPhone Fold os botões das barras vão para a BARRA DIREITA (railSync, mais abaixo). */
  const isFold = () => !!(window.System && System.form === 'fold');
  /* duas colunas: só com o dobrável ABERTO */
  const isSplit = () => !!(window.System && System.form === 'fold' && System.foldOpen);
  /* onde caiu o último toque: um push vindo da janela (UI.push(win, v)) não diz de que vista veio. Um toque fora das vistas
     (folha, lista de ações, alerta) conta como o da última vista tocada, a que abriu essa camada. */
  let lastTap = null, lastViewTap = null;
  if (typeof document !== 'undefined') document.addEventListener('pointerdown', e => { const t = e.target; if (!t || !t.closest) return; lastTap = { at: performance.now(), el: t, view: t.closest('.app-window .view') }; if (lastTap.view) lastViewTap = lastTap; }, true);
  const liveViews = stack => [...stack.children].filter(x => x.classList.contains('view') && !x.classList.contains('leave') && !x.classList.contains('pane-out'));
  /* a linha marcada guarda-se pelo TEXTO do rótulo: as listas que se repintam (innerHTML) pedem-na de volta com UI.splitResel(win).
     O texto de ORIGEM (I18N.source): o mesmo em todas as línguas, e trocar de idioma a meio não perde a marca */
  const rowText = r => { const l = r && (r.querySelector('.li-label') || r); return l ? String(window.I18N && I18N.source ? I18N.source(l) : l.textContent).trim() : ''; };
  const splitSel = (stack, row) => { const root = stack.firstElementChild; if (!root) return; root.querySelectorAll('.split-sel').forEach(x => { if (x !== row) x.classList.remove('split-sel'); }); if (row) row.classList.add('split-sel'); stack._selText = row ? rowText(row) : ''; };
  /* a linha marcada por fora da lista (settings:goto, o dobrável a abrir com um detalhe aberto) fica à vista na lista: o scrollTop do
     que rola salta de uma vez para a pôr ao meio, só se ela estiver tapada (pelo topo, ou pela pesquisa presa ao fundo). Sem animação
     e sem scrollIntoView (que também mexia nos antepassados) */
  function selShow(row) {
    if (!row || !row.isConnected) return; let sc = row.parentElement;
    while (sc && sc.nodeType === 1 && !(sc.scrollHeight > sc.clientHeight + 1 && /auto|scroll/.test(getComputedStyle(sc).overflowY))) { if (sc.classList.contains('view')) { sc = null; break; } sc = sc.parentElement; }
    if (!sc || sc.nodeType !== 1 || !sc.clientHeight) return;
    const z = zoom(sc) || 1, y = (vrect(row).top - vrect(sc).top) / z + sc.scrollTop, h = row.offsetHeight;
    const v = sc.closest('.view'), nb = v && v.classList.contains('lg-bare') ? v.querySelector(':scope > .navbar') : null;
    const top = (nb ? nb.offsetHeight : 0) + 8, bot = v && v.classList.contains('pane-search') ? 120 : 24;   /* a barra por cima (título grande) e a pesquisa presa ao fundo tapam */
    if (y >= sc.scrollTop + top && y + h <= sc.scrollTop + sc.clientHeight - bot) return;
    sc.scrollTop = Math.max(0, Math.min(sc.scrollHeight - sc.clientHeight, Math.round(y - (sc.clientHeight - h) / 2))); }
  function splitResel(win, show) { const st = win && win.querySelector(':scope > .nav-stack'); if (!st || !st.classList.contains('split') || !st._selText || liveViews(st).length < 2) return;
    const root = st.firstElementChild, sel = (win._split && win._split.row) || '.li';
    const r = [...root.querySelectorAll(sel)].find(x => rowText(x) === st._selText); if (r) { r.classList.add('split-sel'); if (show) selShow(r); } }
  /* uma coluna (fechado): a linha da raiz que abriu o detalhe fica guardada pelo texto, para ficar marcada quando o dobrável abrir
     em duas colunas com esse detalhe aberto (splitApply → splitResel) */
  function rootSel(stack) { const win = stack.closest('.app-window'); if (!win || !win._split || stack.classList.contains('split')) return;
    const lv = liveViews(stack); if (lv.length !== 1) return; const root = lv[0], now = performance.now();
    const row = lastTap && now - lastTap.at < 2500 && root.contains(lastTap.el) ? lastTap.el.closest(win._split.row || '.li') : null;
    stack._selText = row && root.contains(row) ? rowText(row) : ''; }
  /* o 1.º detalhe (logo a seguir à raiz) não mostra o "voltar": a lista está ao lado */
  function paneMark(stack) { if (!stack) return; const on = stack.classList.contains('split'); const lv = liveViews(stack);
    lv.forEach((x, i) => x.classList.toggle('pane-first', on && i === 1));
    if (on && lv.length < 2) splitSel(stack, null); }
  /* push numa pilha dividida: devolve true se TROCOU o detalhe (o push normal já não corre) */
  function splitSwap(stack, from, v) {
    const root = stack.firstElementChild, win = stack.closest('.app-window'), o = (win && win._split) || {};
    let src = from && from.nodeType === 1 && from !== win && from !== stack && from.closest ? from.closest('.view') : null;
    if (src && src.parentNode !== stack) src = null;
    const now = performance.now(); let tap = lastTap && now - lastTap.at < 30000 ? lastTap : null;
    if (tap && !tap.view) tap = lastViewTap && now - lastViewTap.at < 30000 ? lastViewTap : null;
    if (!src && tap && tap.view && tap.view.parentNode === stack) src = tap.view;
    const lv = liveViews(stack);
    /* veio do detalhe (ou de uma camada aberta por ele): empilha na metade direita. Da lista, ou sem origem
       conhecida (notificação, atalho, Vera), troca o detalhe */
    if (lv.length > 1 && src && src !== root) return false;
    const old = lv.slice(1);
    /* o onPop corre JÁ e uma vez só (um setRoot ou o killApp nos 340 ms seguintes não o repetem) */
    old.forEach(x => { x.classList.add('pane-out'); try { const f = x.opts && x.opts.onPop; if (x.opts) x.opts.onPop = null; if (f) f(); } catch (e) { console.error('[apex_phone] onPop', e); } });
    v.classList.add('pane-in'); stack.appendChild(v); paneMark(stack); markBare(v); updateTabbar(stack);
    /* aberto pelo splitFirst (nos 2 s a seguir e sem um toque verdadeiro pelo meio): detalhe automático (autoDrop) */
    if (stack._autoAt) { if (now - stack._autoAt < 2000 && !(lastTap && lastTap.at > stack._autoAt)) v._auto = true; stack._autoAt = 0; }
    /* marca a linha tocada (só um toque acabado de dar na lista; um atalho não marca nada) */
    const fresh = lastTap && now - lastTap.at < 2500 && root && root.contains(lastTap.el) ? lastTap.el.closest(o.row || '.li') : null;
    splitSel(stack, fresh && root.contains(fresh) ? fresh : null);
    requestAnimationFrame(() => requestAnimationFrame(() => { v.classList.remove('pane-in'); }));
    /* o detalhe antigo fica por baixo enquanto o novo aparece (só opacidade) e sai depois */
    setTimeout(() => old.forEach(x => x.remove()), 340);
    return true; }
  function splitApply(win) { const o = win && win._split; if (!o) return; const st = win.querySelector(':scope > .nav-stack'); if (!st) return; const on = isSplit();
    win.classList.toggle('split-on', on); st.classList.toggle('split', on);
    if (on && !win._splitPh) { const ph = el(`<div class="split-ph"><div class="sp-ic">${o.icon ? g(o.icon) : ''}</div><b></b><span></span></div>`); ph.querySelector('b').textContent = o.title || ''; ph.querySelector('span').textContent = o.sub || ''; win.insertBefore(ph, st); win._splitPh = ph; }
    if (!on) autoDrop(st);
    /* a vista de baixo de cada uma fica "por trás"; com duas colunas a raiz nunca fica (está sempre à vista) */
    const lv = liveViews(st); lv.forEach((x, i) => x.classList.toggle('behind', i < lv.length - 1 && !(on && i === 0)));
    paneMark(st); if (on) splitResel(win, true);   /* abriu com um detalhe já aberto: a linha dele fica marcada na lista, e à vista */
    updateTabbar(st); railSoon(win); if (on && o.first) splitFirst(win); }
  /* o detalhe que o splitFirst abriu SOZINHO (a 1.ª linha das Definições, o 1.º email) e em que ninguém tocou sai quando as duas colunas
     acabam (fechar o dobrável, trocar de aparelho): o ecrã de fora mostra a lista, como num telemóvel. Um detalhe aberto pelo jogador
     (ou tocado, rolado, escrito) fica. Volta a abrir sozinho quando o dobrável abrir outra vez (splitFirst) */
  function autoDrop(st) {
    const lv = liveViews(st); if (lv.length !== 2) return; const d = lv[1];
    if (!d._auto || d._autoTouched) return;
    try { const f = d.opts && d.opts.onPop; if (d.opts) d.opts.onPop = null; if (f) f(); } catch (e) { console.error('[apex_phone] onPop', e); }
    d.remove(); splitSel(st, null); lv[0].classList.remove('behind'); updateTabbar(st); }
  /* tocar, rolar ou escrever no detalhe aberto sozinho torna-o do jogador */
  if (typeof document !== 'undefined') ['pointerdown', 'wheel', 'keydown'].forEach(t => document.addEventListener(t, e => { const v = e.target && e.target.closest ? e.target.closest('.app-window .view') : null; if (v && v._auto) v._autoTouched = true; }, { capture: true, passive: true }));
  /* o.first (true ou o seletor da linha): com as duas colunas e o detalhe vazio abre-se logo a primeira linha da lista (as Definições
     abrem em "Ligações" / "Geral", nunca com o aviso). Depois de a app desenhar a lista; conta como um toque nessa linha (fica marcada) */
  function splitFirst(win, n = 0) { clearTimeout(win._spFirstT);
    win._spFirstT = setTimeout(() => { const o = win._split, st = win.querySelector(':scope > .nav-stack');
      if (!o || !o.first || !isSplit() || !st || !st.classList.contains('split') || !win.isConnected || liveViews(st).length !== 1) return;
      const root = liveViews(st)[0], sel = typeof o.first === 'string' ? o.first : (o.row || '.li');
      const r = [...root.querySelectorAll(sel)].find(x => x.offsetParent !== null && !x.classList.contains('static'));
      if (!r) { if (n < 6) splitFirst(win, n + 1); return; }   /* a lista ainda não chegou (pedido ao servidor): tenta de novo */
      /* o toque fingido só serve ao click dele: depois voltam os toques verdadeiros (antes, um settings:goto nos 2,5 s seguintes
         contava como um toque nesta linha e deixava "Ligações" / "Geral" marcada com outra página aberta) */
      const was = [lastTap, lastViewTap]; lastTap = lastViewTap = { at: performance.now(), el: r, view: root };
      /* o detalhe que este toque abrir é "automático" (autoDrop): marcado aqui se abrir já, ou no push que chegar nos 2 s seguintes */
      st._autoAt = performance.now();
      try { r.click(); } finally { lastTap = was[0]; lastViewTap = was[1]; }
      const lv = liveViews(st); if (lv.length === 2) { lv[1]._auto = true; st._autoAt = 0; } }, n ? 160 : 60); }
  /* marca na lista a linha cujo rótulo de origem (o português do código, I18N.source) é `label`, ou nenhuma (label vazio ou sem
     linha): para quem abre uma página por fora da lista (settings:goto, atalhos) e quer marcada a linha dessa página. `label` também
     pode ser a própria linha (um elemento da raiz), para as linhas sem rótulo (o cartão da conta das Definições). Numa coluna
     só (fechado) fica guardada para quando o dobrável abrir (splitApply → splitResel) */
  function splitMark(win, label) { const st = win && win._split && win.querySelector(':scope > .nav-stack'); if (!st) return; const root = liveViews(st)[0]; if (!root) return;
    const sel = win._split.row || '.li', own = label && label.nodeType === 1 && root.contains(label) ? label.closest(sel) : null;
    const r = own && root.contains(own) ? own : typeof label === 'string' && label ? [...root.querySelectorAll(sel)].find(x => rowText(x) === label) || null : null;
    if (st.classList.contains('split')) { splitSel(st, r); selShow(r); } else st._selText = r ? rowText(r) : ''; }
  function split(win, o = {}) { if (!win) return win; win._split = o; win.classList.add('has-split'); splitApply(win); return win; }

  /* ---------- PearPhone Fold: a BARRA DIREITA (Rail, system.js) para as apps ----------
     No dobrável do PearOS (Rail.active) o "cromado" das apps sai das barras e vai para a coluna da direita, como no aparelho
     de referência: o VOLTAR em círculo por baixo do estado; os botões da ESQUERDA da barra numa pílula por baixo dele; os da
     DIREITA (compor, +, partilhar, OK) em baixo; os SEPARADORES numa pílula vertical a meio. O título grande fica no conteúdo.
     Duas colunas (aberto): os botões da lista ficam em cima e os do detalhe em baixo; o voltar só aparece dentro do detalhe.
     Tudo sai do DOM das barras (as apps acrescentam botões depois de criar a vista e mudam-nos com classes e estilos): os
     botões originais ficam na barra, invisíveis (ui.css), e cada círculo da coluna toca no seu (o onTap da app corre igual).
     Uma vista pode dar os seus próprios botões: UI.view({ rail }) ou v.rail = spec | (auto, papel) => spec, juntos aos
     automáticos (as chaves que der substituem as dele). Uma camada que tape a app inteira (leitor, player) usa
     UI.railFor(win, spec | null). Só corre com a barra ativa; nos outros aparelhos nada muda. */
  const railOn = () => !!(window.Rail && Rail.active);
  /* PearPhone Fold: uma camada aberta POR UMA APP (folha, lista de ações, menu, toast, a lista de um <select>) leva o zoom do conteúdo
     dela (.az, ui.css); as do sistema (ecrã principal, bloqueado, Centro de controlo, notificações, alternador) ficam como estão.
     node: o elemento de onde a camada sai (o tocado, o <select>); sem ele conta a app que está à frente */
  const appCtx = node => { if (!railOn()) return false;
    if (node && node.nodeType === 1 && node.closest) return !!node.closest('.app-window, .rail-apps');
    const s = screen(); if (!s || !s.classList.contains('app-open') || !(window.System && System.currentApp && System.currentApp())) return false;
    return !document.querySelector('#cc.in, #nc.in, #switcher.in'); };
  let ridSeq = 0, railT = 0, navMo = null, lastRail = null;
  const railQ = new Set();
  /* o último círculo da barra tocado: um menu aberto por um botão escondido abre ao lado dele (ctxMenu) */
  if (typeof document !== 'undefined') document.addEventListener('pointerdown', e => { const b = e.target && e.target.closest && e.target.closest('.rail-apps .rl-pb, .rail-apps .rl-p'); if (b) lastRail = { at: performance.now(), el: b }; }, true);
  function railSoon(win) { if (!win || !railOn()) return; railQ.add(win); if (railT) return;
    railT = setTimeout(() => { railT = 0; const l = [...railQ]; railQ.clear(); l.forEach(w => { try { railSync(w); } catch (e) { console.error('[apex_phone] rail', e); } }); }, 0); }
  /* as apps mexem nos botões das barras depois (classes, estilo, conteúdo): a barra direita acompanha */
  function navWatch(nav) {
    if (!window.MutationObserver || !nav) return;
    if (!navMo) navMo = new MutationObserver(recs => { if (!railOn()) return; const ws = new Set();
      recs.forEach(r => { const t = r.target.nodeType === 1 ? r.target : r.target.parentElement; if (!t || (r.type === 'attributes' && t.classList.contains('navbar'))) return; const w = t.closest('.app-window'); if (w) ws.add(w); });
      ws.forEach(railSoon); });
    navMo.observe(nav, { subtree: true, childList: true, characterData: true, attributes: true, attributeFilter: ['class', 'style', 'hidden'] });
  }
  /* rótulos de texto das barras: na coluna são círculos, por isso cada palavra conhecida tem o seu glifo */
  const NB_IC = [[/^(editar|edit)/i, 'checkCircle'], [/^(ok|concluído|concluido|concluir|feito|pronto|guardar|confirmar|aplicar|done|save)$/i, 'check'], [/^(cancelar|fechar|cancel|close)$/i, 'x'],
    [/^(adicionar|novo|nova|criar|add|new)/i, 'plus'], [/^(enviar|publicar|send|post)/i, 'send'], [/^(selecionar|select)/i, 'checkCircle'], [/^(limpar|apagar|eliminar|clear|delete)/i, 'trash'],
    [/^(partilhar|share)/i, 'share'], [/^(filtr|ordenar|filter|sort)/i, 'sliders'], [/^(mais|opções|opcoes|more)/i, 'more'], [/^(pesquisar|procurar|search)/i, 'search'],
    [/^(seguinte|próximo|proximo|next)/i, 'chevR'], [/^(anterior|prev)/i, 'chevL'], [/^(ligar|chamar|call)/i, 'phone'], [/^(sair|terminar sessão|logout)/i, 'logout'], [/^(info|informações|detalhes)/i, 'info']];
  const icFor = lb => { for (const [re, ic] of NB_IC) if (re.test(lb)) return ic; return ''; };
  /* e o contrário: o nome de um botão só com glifo (para quem lê o ecrã e para o menu "Mais") */
  const IC_LB = { compose: 'Escrever', pen: 'Editar', plus: 'Adicionar', plusCircle: 'Adicionar', trash: 'Apagar', share: 'Partilhar', search: 'Pesquisar', more: 'Mais', moreV: 'Mais', ellipsisCircle: 'Mais',
    x: 'Fechar', check: 'Concluído', send: 'Enviar', reply: 'Responder', forward: 'Reencaminhar', flag: 'Assinalar', folder: 'Mover', heart: 'Gosto', bookmark: 'Guardar', gear: 'Definições', info: 'Informações',
    phone: 'Ligar', video: 'Videochamada', message: 'Mensagem', camera: 'Câmara', photo: 'Fotografia', list: 'Lista', grid: 'Grelha', sliders: 'Filtros', filter: 'Filtros', personPlus: 'Adicionar contacto',
    update: 'Recomeçar', pause: 'Pausa', play: 'Reproduzir', rotate: 'Rodar', map: 'Mapa', pin: 'Localização', calendar: 'Calendário', bell: 'Notificações', download: 'Transferir', link: 'Ligação', copy: 'Copiar',
    users: 'Pessoas', people: 'Pessoas', person: 'Perfil', personCircle: 'Perfil', chevL: 'Anterior', chevR: 'Seguinte', chevU: 'Anterior', chevD: 'Seguinte', storage: 'Arquivar', mail: 'Mail', cart: 'Carrinho', tag: 'Etiqueta' };
  /* o nome do glifo de um <svg> desenhado pelas apps sem passar pelo navBtn (jogos, por exemplo): compara-se o desenho com o
     dos glifos do Icons, escrito como o browser o escreve (feito uma vez) */
  let icByHtml = null;
  const icOfSvg = svg => { if (!svg || !window.Icons || !Icons.P) return '';
    if (!icByHtml) { icByHtml = new Map(); const t = document.createElement('div'); Object.keys(Icons.P).forEach(k => { t.innerHTML = `<svg>${Icons.P[k]}</svg>`; const s = t.firstElementChild; if (s && !icByHtml.has(s.innerHTML)) icByHtml.set(s.innerHTML, k); }); }
    return icByHtml.get(svg.innerHTML) || ''; };
  /* um botão da barra está à vista? Os originais estão escondidos pelo ui.css (visibility), por isso conta o que a APP faz:
     display none (classe ou estilo), opacidade, o atributo hidden e o visibility que ela escreveu no estilo */
  const nbShown = b => { if (!b || b.hidden || b.classList.contains('hidden')) return false; const s = b.style; if (s.display === 'none' || s.visibility === 'hidden') return false;
    const cs = getComputedStyle(b); return cs.display !== 'none' && parseFloat(cs.opacity) > .05; };
  /* círculo da coluna a partir de um botão da barra: glifo (o svg dele, ou o da palavra), rótulo, estado, emblema; tocar = tocar nele */
  function nbItem(b) {
    const own = [...b.childNodes].filter(n => !(n.nodeType === 1 && n.matches('.badge,.tb-badge,.nb-badge')));
    const txt = own.map(n => n.textContent).join('').replace(/\s+/g, ' ').trim();
    const svg = b.querySelector('svg'), pic = b.querySelector('img,.avatar,.as-av');
    const lb = b.getAttribute('aria-label') || b.getAttribute('title') || b.dataset.lb || txt || T(IC_LB[b.dataset.ic || (svg && !txt ? icOfSvg(svg) : '')] || '');
    let icon = svg && !pic ? svg.outerHTML : pic ? b.innerHTML : '';
    /* o glifo escolhe-se pelo texto de ORIGEM (o português do código, I18N.source), nunca pelo traduzido: a barra fica igual em todas
       as línguas. Depois a chave posta pelo navBtn, e por fim o rótulo à vista (as palavras em inglês do NB_IC) */
    if (!icon) { const src = txt && window.I18N && I18N.source ? own.map(n => I18N.source(n)).join('').replace(/\s+/g, ' ').trim() : '';
      const ic = icFor(src) || icFor(b.dataset.key || '') || icFor(lb); icon = ic || `<b class="rl-word">${esc(lb.slice(0, 9))}</b>`; }
    const bd = b.querySelector('.badge,.tb-badge,.nb-badge'); const bn = bd ? (parseInt(bd.textContent, 10) || true) : null;
    return { id: 'b' + (b._rid || (b._rid = ++ridSeq)), icon, label: lb || T('Botão'), disabled: b.classList.contains('dis') || b.classList.contains('disabled'),
      active: b.classList.contains('on') || b.classList.contains('active'), tint: b.classList.contains('bold') ? 'blue' : '', badge: bn, onTap: () => b.click() };
  }
  /* os botões automáticos de uma vista: voltar, esquerda e direita (só os que estão à vista) */
  function viewAuto(v) {
    const nb = v && v.querySelector(':scope > .navbar'); const out = { back: null, left: [], right: [] }; if (!nb) return out;
    const bk = nb.querySelector('.nb-back'); if (bk && nbShown(bk)) { const s = bk.querySelector('span'); out.back = { onTap: () => bk.click(), label: (s && s.textContent.trim()) || T('Voltar') }; }
    nb.querySelectorAll('.nb-left > .nb-btn').forEach(b => { if (nbShown(b)) out.left.push(nbItem(b)); });
    nb.querySelectorAll('.nb-right > .nb-btn').forEach(b => { if (nbShown(b)) out.right.push(nbItem(b)); });
    return out;
  }
  /* o que a vista quer na coluna: os automáticos com os próprios por cima (papel: 'single', 'list' ou 'detail') */
  function viewRail(v, role, deep) {
    const a = viewAuto(v); let sp;
    if (role === 'list') sp = { back: null, groups: a.left.concat(a.right).length ? [a.left.concat(a.right)] : [], primary: [] };
    else if (role === 'detail') sp = { back: deep ? a.back : null, groups: [], primary: a.left.concat(a.right).length ? [a.left.concat(a.right)] : [] };
    else sp = { back: a.back, groups: a.left.length ? [a.left] : [], primary: a.right.length ? [a.right] : [] };
    const r = v && v.rail; if (!r) return sp;
    let own = null; try { own = typeof r === 'function' ? r(sp, role) : r; } catch (e) { console.error('[apex_phone] rail da vista', e); }
    return own && typeof own === 'object' ? Object.assign(sp, own) : sp;
  }
  /* a coluna tem altura para um número de círculos. Primeiro: se os botões de cima ou de baixo chegam aos separadores (a meio),
     os separadores descem para uma pílula em baixo. Depois, o que ainda não cabe vai para um "Mais" (menu) no fim das ações */
  function railFit(sp) {
    /* medidas dos círculos no Rail.metrics (system.js, as do liquid27.css): botão, intervalo entre pílulas, fundo do grupo de baixo, centro dos separadores */
    const M = (window.Rail && Rail.metrics) || {};
    const BT = +M.bt || 54, GAP = +M.gap || 12, H = 956 - (+M.bot || 26), top0 = (window.Rail && Rail.top) || 176, MID = +M.mid || (956 + 38) / 2;
    const n = gs => gs.reduce((s, x) => s + x.length, 0), hg = (gs, extra) => n(gs) * BT + Math.max(0, gs.length - 1 + extra) * GAP;
    const topH = () => (sp.back ? BT : 0) + hg(sp.groups, sp.back ? 1 : 0);
    if (sp.tabs.length) { const th = sp.tabs.length * BT;
      if (top0 + topH() > MID - th / 2 - GAP || H - hg(sp.primary, 0) < MID + th / 2 + GAP) { sp.primary.push(sp.tabs.map(t => Object.assign({}, t, { id: 'x' + t.id }))); sp.tabs = []; } }
    const tabsH = sp.tabs.length * BT; const midTop = tabsH ? MID - tabsH / 2 : H, midBot = tabsH ? MID + tabsH / 2 : null;
    const topMax = (tabsH ? midTop - GAP : H - GAP) - top0;
    const over = [];
    while (sp.groups.length && topH() > topMax) { const g = sp.groups[sp.groups.length - 1]; over.unshift(g.pop()); if (!g.length) sp.groups.pop(); }
    const botMax = H - (tabsH ? midBot + GAP : top0 + topH() + GAP);
    const botH = extra => hg(sp.primary, 0) + (extra ? BT : 0);
    while (sp.primary.length && botH(over.length) > botMax) { const g = sp.primary[0]; over.unshift(g.shift()); if (!g.length) sp.primary.shift(); }
    if (over.length) { const more = { id: 'more', icon: 'more', label: T('Mais'), onTap: () => ctxMenu(lastRail && lastRail.el, over.map(x => ({ label: x.label, onTap: x.onTap }))) };
      if (sp.primary.length) sp.primary[sp.primary.length - 1].push(more); else sp.primary.push([more]); }
    return sp;
  }
  function tabsRail(win, st) {
    const tb = win._tbApi; if (!tb) return [];
    const root = st.classList.contains('split') ? st.firstElementChild : liveViews(st).pop();
    if (root && root.classList.contains('full')) return [];   /* vistas .full (conversas) escondem os separadores, como a barra de baixo */
    /* tocar no círculo = tocar no separador escondido: as apps que trocam o onclick de um separador (Reels e Mensagens do Instashot
       abrem uma camada ou empilham uma vista sem trocar de separador) fazem o mesmo nas duas barras */
    return tb.tabs.map((t, i) => ({ id: 't' + i, icon: t.icon, label: t.label, active: i === tb.cur(), badge: tb.badges[i] || null, onTap: () => { const b = tb.btn && tb.btn(i); if (b) b.click(); else tb.go(i); } }));
  }
  /* a cor de fundo de um elemento ('' se for transparente) */
  const bgOf = x => { if (!x) return ''; const c = getComputedStyle(x).backgroundColor; return c && c !== 'transparent' && !/rgba\([^)]*,\s*0\)$/.test(c) ? c : ''; };
  /* FUNDO DE PONTA A PONTA (ui.css): o que vai de uma ponta à outra da zona do conteúdo leva o fundo até à aresta, por baixo da
     barra: as camadas da janela (.fb-wide) e os filhos de cada raiz da pilha (.fb-x: barras, fundos, o leitor da Música). Mede-se
     pelo layout (offset e o left calculado, sem os transforms das entradas); uma camada ainda escondida conta pelo estilo
     (absolute com left e right a 0). Depois de marcar confirma-se que chegou mesmo à aresta: uma largura fixa não estica e a
     borda comia o conteúdo, por isso a marca sai e não volta a ser tentada. Botões e cartões a flutuar nunca são marcados */
  /* medidas de layout (offsets, estilo calculado) são em px do PRÓPRIO elemento: com o zoom do conteúdo (ui.css, --az) uma camada mede
     menos do que a janela. k = px da referência por px de c (o zoom de c a dividir pelo da referência); R vem em px da referência */
  function fbFit(c, cls, inner, full, R, k) {
    if (c._fbNo) return;
    const cs = getComputedStyle(c), pos = /absolute|fixed/.test(cs.position), L = (pos ? parseFloat(cs.left) || 0 : c.offsetLeft) * k, shown = cs.display !== 'none' && c.offsetWidth > 0;
    if (!c.classList.contains(cls)) {
      if (shown ? !(L <= 1 && L + c.offsetWidth * k >= inner - 2) : !(pos && Math.abs(parseFloat(cs.left) || 0) < .5 && (Math.abs(parseFloat(cs.right) || 0) < .5 || Math.abs((parseFloat(cs.right) || 0) * k - R) < 1))) return;
      c.classList.add(cls); if (!shown) return;
    } else if (!shown || c._fbOk) return;
    /* (a largura lê-se DEPOIS de pôr a marca: com ela a borda da barra já conta) */
    if (L + c.offsetWidth * k >= full - 2) c._fbOk = true; else { c.classList.remove(cls); c._fbNo = true; }
  }
  function fbScan(win) {
    const R = Math.round((window.Rail && Rail.width) || 0); if (!R || !win || !win.isConnected) return;
    const W = win.offsetWidth; if (!W) return; const zw = zoom(win);
    layerKids(win).forEach(c => fbFit(c, 'fb-wide', W - R, W, R, zoom(c) / zw));
    const st = win.querySelector(':scope > .nav-stack'); if (!st) return;
    /* só as raízes com a borda (a lista das duas colunas não chega à barra). Uma raiz que recorta (overflow hidden: Música, Mapas)
       passa a recortar com a margem da barra (.fb-clip), senão o que vai até à aresta (fundo, mapa) ficava cortado nela.
       As raízes e os filhos delas estão no mesmo zoom (o da pilha): contas em px da raiz, com a barra nesses px */
    const Rs = R * zw / zoom(st);
    [...st.children].forEach(r => { const rs = getComputedStyle(r); if (parseFloat(rs.borderRightWidth) < Rs - 1) return; const inner = r.clientWidth, full = r.offsetWidth;
      if (rs.overflowX === 'hidden' && rs.overflowY === 'hidden') r.classList.add('fb-clip');
      [...r.children].forEach(c => { if (!c.matches('.navbar,.content')) fbFit(c, 'fb-x', inner, full, Rs, 1); }); });
  }
  /* camada vertical em coluna (440 ao centro, liquid27.css): a sombra larga dela pinta o resto do ecrã e a coluna da barra; a cor
     dessa sombra ('' se não houver) é a que conta para a coluna e para o tom da hora e do anel */
  const wideShadow = x => { if (!x) return ''; const m = /^(rgba?\([^)]*\))\s+0px\s+0px\s+0px\s+(\d+(?:\.\d+)?)px/.exec(getComputedStyle(x).boxShadow || ''); return m && +m[2] >= 300 ? m[1] : ''; };
  const setVar = (n, k, v) => { if (n.style.getPropertyValue(k) === v) return; if (v) n.style.setProperty(k, v); else n.style.removeProperty(k); };
  /* luminância de uma cor 'rgb(...)' (0 escuro, 1 claro); null se não se ler */
  const lumC = c => { const m = /rgba?\(([\d.]+),\s*([\d.]+),\s*([\d.]+)/.exec(c || ''); return m ? (.2126 * m[1] + .7152 * m[2] + .0722 * m[3]) / 255 : null; };
  /* grupos sempre como listas de listas (uma lista simples é uma pílula), cópias para o railFit poder mexer */
  const railGl = v => !Array.isArray(v) || !v.length ? [] : (Array.isArray(v[0]) ? v : [v]).map(g => (Array.isArray(g) ? g : [g]).filter(i => i && typeof i === 'object')).filter(g => g.length);
  /* uma camada da app que tapa a janela inteira (story, câmara, editor, "É um Match!"...), posta por ela fora da pilha */
  const layerKids = win => [...win.children].filter(c => !c.matches('.nav-stack,.tabbar,.split-ph'));
  /* (alturas em px reais: as camadas com o zoom do conteúdo e a janela sem ele, nos dois motores) */
  const winLayer = win => { const H = vrect(win).height; if (!H) return null;
    return layerKids(win).reverse().find(c => { const cs = getComputedStyle(c);
      if (cs.display === 'none' || cs.visibility === 'hidden' || parseFloat(cs.opacity) < .05 || !/absolute|fixed/.test(cs.position)) return false;
      return vrect(c).height >= H * .9; }) || null; };
  function railSync(win) {
    if (!win || !win.isConnected || !railOn() || !window.Rail) return;
    /* as camadas que a app põe na janela (por cima da pilha) entram e saem sem passar pelo push/pop: a janela é vigiada. Uma camada
       entra quase sempre a desvanecer (opacidade 0 no momento em que é posta): volta-se a ver depois da entrada */
    /* (a camada nova ganha o fundo de ponta a ponta já aqui, antes de ser pintada: o observador corre antes do frame) */
    if (!win._railMo && window.MutationObserver) { win._railMo = new MutationObserver(() => { try { fbScan(win); } catch (e) { console.error('[apex_phone] rail', e); } railSoon(win); clearTimeout(win._railT2); win._railT2 = setTimeout(() => railSoon(win), 360); }); win._railMo.observe(win, { childList: true }); }
    fbScan(win);
    const st = win.querySelector(':scope > .nav-stack'); const lv = st ? liveViews(st) : [];
    const top = lv[lv.length - 1] || null, split = !!(st && st.classList.contains('split'));
    const layer = winLayer(win), lsh = wideShadow(layer);
    /* com uma camada a ecrã inteiro o tom da coluna é o da cor dela (visualizador preto = hora e botões claros), não o do tema; numa
       camada em coluna é o da sombra que pinta a barra (o editor de estado do Zapp tem um degradê, a hora ficava preta no preto) */
    const lb = layer ? lumC(lsh || bgOf(layer)) : null, tone = lb == null ? '' : lb < .45 ? 'dark' : 'light';
    /* barra de cima vazia (sem título à vista nem nada que não seja botão): a coluna tem os botões, o conteúdo sobe (ui.css
       .nb-empty). O título da barra só se vê com .show-title (como no telemóvel: as raízes dos separadores não o mostram) */
    lv.forEach(v => { const nb = v.querySelector(':scope > .navbar'); if (!nb) return; const t = nb.querySelector('.nb-title');
      const tVis = !!(t && (t.textContent.trim() || t.children.length) && (nb.classList.contains('show-title') || parseFloat(getComputedStyle(t).opacity) > .05));
      const empty = !tVis && !nb.querySelector('.nb-left > :not(.nb-btn):not(.nb-back), .nb-right > :not(.nb-btn)') && !v.querySelector(':scope > .content > .large-title');
      if (v.classList.contains('nb-empty') !== empty) v.classList.toggle('nb-empty', empty); });
    /* duas colunas: a lista com pesquisa leva-a para o fundo (ui.css) e desvanece por baixo dela na cor da própria lista */
    if (split && lv[0]) { const L0 = lv[0], ps = !!L0.querySelector(':scope > .content > .search, :scope > .content > .pane-wrap > .search');if (L0.classList.contains('pane-search') !== ps) L0.classList.toggle('pane-search', ps); setVar(L0, '--pane-bg', bgOf(L0)); }
    let sp;
    /* os botões pedidos por UI.railFor valem enquanto a camada que os pediu (ou o conteúdo, sem camada) estiver à frente: outra
       camada aberta por cima dela (o editor por cima do visualizador) esconde-os, e voltam quando essa sai */
    let ovEl = win._railOvEl;
    if (ovEl && !ovEl.isConnected) { win._railOv = null; win._railOvEl = ovEl = null; }   /* a camada dona saiu sem avisar: os botões dela saem também */
    if (win._railOv && (!layer || (ovEl && ovEl.isConnected && (ovEl === layer || ovEl.contains(layer) || (layer.compareDocumentPosition(ovEl) & 4))))) {
      try { sp = typeof win._railOv === 'function' ? win._railOv() : win._railOv; } catch (e) { console.error('[apex_phone] rail', e); sp = {}; }
      /* as mesmas regras de arrumação dos botões automáticos (separadores que não cabem descem, o que sobra vai para "Mais") */
      sp = Object.assign({}, sp || {}); sp.tabs = (Array.isArray(sp.tabs) ? sp.tabs : []).filter(i => i && typeof i === 'object'); sp.groups = railGl(sp.groups); sp.primary = railGl(sp.primary);
      if (!sp.hidden) railFit(sp);
      if (tone && !sp.tone) sp.tone = tone;
      Rail.setApp(win, sp); win._railSig = null; return; }
    /* camada por cima de tudo sem botões próprios na coluna: os da app por baixo não se veem (tocá-los mexia no que está tapado) */
    if (layer) { if (win._railSig !== 'layer' + tone) { win._railSig = 'layer' + tone; Rail.setApp(win, { hidden: true, tone }); } return; }
    if (!top) sp = { back: null, groups: [], tabs: [], primary: [] };
    else if (split) {
      const L = viewRail(lv[0], 'list'), D = lv.length > 1 ? viewRail(top, 'detail', lv.length > 2) : null;
      sp = { back: D ? D.back : null, groups: (L.groups || []).concat(D ? D.groups || [] : []), primary: (L.primary || []).concat(D ? D.primary || [] : []), hidden: !!(D ? D.hidden : L.hidden) };
      const tb = D && D.tabs ? D.tabs : L.tabs; if (tb) sp.tabs = tb;
    } else sp = viewRail(top, 'single');
    sp.tabs = (Array.isArray(sp.tabs) ? sp.tabs : (st ? tabsRail(win, st) : [])).filter(i => i && typeof i === 'object'); sp.groups = railGl(sp.groups); sp.primary = railGl(sp.primary);
    railFit(sp);
    /* só volta a desenhar quando muda alguma coisa (vista, botões, estado); os toques vão sempre para os botões novos */
    const sig = JSON.stringify([lv.map(x => x._rid), split, !!sp.back, sp.hidden, [sp.groups, sp.tabs, sp.primary].map(gs => (gs || []).map(g => Array.isArray(g) ? g.map(i => [i.id, i.icon, i.label, i.disabled, i.active, i.badge, i.tint]) : [g.id, g.icon, g.label, g.disabled, g.active, g.badge]))]);
    if (sig === win._railSig) return; win._railSig = sig;
    Rail.setApp(win, sp);
  }
  /* uma camada da app por cima de tudo (leitor de fotos, player, chamada): os botões dela na coluna enquanto existir.
     owner: a camada dona dos botões (por omissão a última posta na janela, fora da pilha); false = o conteúdo da app (sem camada:
     qualquer camada que abra por cima esconde-os). Voltar a chamar com a mesma dona só atualiza os botões. */
  function railFor(win, spec, owner) { if (!win) return;
    if (!spec) win._railOvEl = null;
    else if (owner !== undefined) win._railOvEl = owner || null;
    else if (!win._railOvEl || !win._railOvEl.isConnected) { const k = layerKids(win); win._railOvEl = k[k.length - 1] || null; }
    win._railOv = spec || null; win._railSig = null; if (railOn()) railSync(win); }
  /* abrir, fechar ou trocar de aparelho: as pilhas, os títulos grandes e a coluna refazem-se em todas as janelas */
  function foldRelayout() {
    /* sem barra direita (outro aparelho) os observadores dela param: o das barras e o de cada janela (voltam com o navWatch e o
       railSync quando ela voltar) */
    const on = railOn(); if (!on && navMo) { navMo.disconnect(); navMo = null; }
    document.querySelectorAll('#apps .app-window').forEach(w => {
      try { if (!on && w._railMo) { w._railMo.disconnect(); w._railMo = null; clearTimeout(w._railT2); }
        if (w._split) splitApply(w); w.querySelectorAll(':scope > .nav-stack > .view').forEach(v => { markBare(v); if (on && v.navbar) navWatch(v.navbar); }); w._railSig = null; railSoon(w);
        if (w._tbTone) { tbSync(w); w._tbTone(); } } catch (e) { console.error('[apex_phone] fold', e); } });
  }
  if (window.Bridge && Bridge.on) { ['form:changed', 'fold:state', 'os:changed'].forEach(ev => Bridge.on(ev, foldRelayout));
    Bridge.on('app:open', id => { const w = window.System && System.windows && System.windows[id]; if (w) { w._railSig = null; railSoon(w); } });
    /* a pilha de estado da barra cresceu ou encolheu (uma atividade entrou ou saiu): os botões da app à vista voltam a ser
       arrumados com o topo novo, senão os de cima desciam por cima dos separadores */
    Bridge.on('rail:top', () => { if (!railOn() || !window.System || !System.currentApp) return; const id = System.currentApp(), w = id && System.windows && System.windows[id]; if (w) { w._railSig = null; railSoon(w); } });
    /* tema claro/escuro: a cor que a janela pinta por baixo da coluna volta a ser lida */
    Bridge.on('state', p => { if (p && ('theme' in p || 'dark' in p) && railOn()) setTimeout(() => document.querySelectorAll('#apps .app-window').forEach(railSoon), 40); }); }
  /* ⚠️ as vistas que SAEM levam o `onPop`: é lá que cada app larga observers, timers e ouvintes.
     O setRoot é o caminho da barra de separadores (e de quem repõe a raiz), e sem isto cada visita
     a um separador deixava atrás um IntersectionObserver - com tudo o que ele agarra - vivo até a
     app ser morta. O `pop()` já o fazia; o setRoot não. */
  function setRoot(win, v) { const stack = stackOf(win); ouMark(stack);
    [...stack.children].forEach(old => { if (old === v) return; try { old.opts && old.opts.onPop && old.opts.onPop(); } catch (e) { console.error('[apex_phone] onPop', e); } });
    /* a vista pode ser REUTILIZADA (a AppShop guarda as vistas dos separadores): se ficou por trás de uma página
       empurrada levava `.behind` (translateX(-28%)) e voltava deslocada para a esquerda com uma faixa vazia à direita */
    v.classList.remove('behind', 'leave', 'enter', 'swiping'); v.style.transform = ''; v.style.transition = '';
    /* volta sempre no topo do scroll: a barra tinha ficado sólida/com o título pequeno da visita anterior */
    if (v.navbar) v.navbar.classList.remove('solid', 'show-title');
    /* Nova UI: a vista reutilizada volta com o titulo grande no sitio (o scroll anterior tinha-o desvanecido) */
    if (v.content && inOU(stack)) { const lt = v.content.querySelector(':scope > .large-title'); if (lt) { lt.style.opacity = ''; lt.style.transform = ''; } if (v.opts && !v.opts.large && v.navbar) v.navbar.classList.add('show-title'); }
    stack.innerHTML = ''; stack.appendChild(v); markBare(v); updateTabbar(stack); paneMark(stack); railSoon(stack.closest('.app-window')); return v; }
  function depth(win) { const s = stackOf(win); return s ? s.children.length : 0; }
  function updateTabbar(stack, top) { const win = stack.closest('.app-window'); if (!win) return; const tb = win.querySelector(':scope > .tabbar'); if (!tb) return; top = top || stack.lastElementChild;
    if (stack.classList.contains('split')) top = stack.firstElementChild;   /* duas colunas: a barra é da lista (metade esquerda) */
    const full = !!(top && top.classList.contains('full')); tb.classList.toggle('hidden', full); tb.classList.remove('compact'); if (top && top.content) top.content.classList.toggle('has-tabbar', !full);   /* vistas .full (conversas) não reservam espaço para a barra escondida */
    tbSync(win, top); }

  /* ---------- NOVA Fold8 ABERTO: os separadores numa coluna à ESQUERDA (oneui-ui.css, "barra lateral") ----------
     A janela leva .tb-win (tem separadores) e .tb-vis (a barra está à vista; as vistas .full e as classes das apps que a escondem
     tiram-na e a pilha volta a ocupar a largura toda). A coluna pinta-se com o fundo da vista à frente (--ou-rail-bg, na janela)
     para a app continuar sem costura. Só mexe com o dobrável aberto no Android; nos outros aparelhos as classes não pintam nada. */
  const railMode = () => isA() && isSplit();
  function tbSync(win, top) { const tb = win && win.querySelector(':scope > .tabbar'); if (!tb || !railMode()) return;
    const vis = getComputedStyle(tb).display !== 'none'; if (win.classList.contains('tb-vis') !== vis) win.classList.toggle('tb-vis', vis);
    const st = win.querySelector(':scope > .nav-stack'), lv = st ? liveViews(st) : [];
    const v = st && st.classList.contains('split') ? lv[0] : (top && top.parentNode === st && !top.classList.contains('leave') ? top : lv[lv.length - 1]);
    setVar(win, '--ou-rail-bg', bgOf(v) || bgOf(win));
    if (win._tbTone) win._tbTone(); }

  /* ---------- Tab bar ---------- */
  /* PearOS 26: pílula de vidro flutuante (.tb-pill); um separador com search:true vive num círculo à parte, à direita (.tab-search), como na AppShop / Música */
  /* opts.plain - barra ao estilo do Instagram: encostada às bordas, sem a pílula de vidro e
     SEM rótulos, só os ícones espalhados pela largura toda. Medida na captura real do
     Instagram (896 px de largura): 5 ícones de ~27pt, centros a 44/132/222/307/397 pt,
     a ~28pt do fundo. O resto do telemóvel continua com a pílula flutuante do PearOS. */
  function tabbar(win, tabs, active = 0, opts = {}) {
    ouMark(win);   /* Nova UI: barra de separadores flutuante (oneui-ui.css, so nas apps do sistema) */
    const tb = el(`<div class="tabbar ${opts.plain ? 'plain' : ''}"><div class="tb-pill lg"></div></div>`); const pill = tb.firstElementChild; let cur = -1; const btns = [];
    /* `force` distingue os dois usos: tocar no separador que já está ativo só volta ao topo (PearOS), mas as apps que chamam tabs.go(n)
       depois de publicar/apagar/editar querem SEMPRE reconstruir a vista. Sem isto, `tabs.go(tabs.cur)` era um no-op silencioso
       e as listas ficavam desatualizadas em meia dúzia de apps (Marketplace, Faturas, Serviços, Garagem, Instashot, Tweeter, Dark Chat). */
    /* ⚠️ tocar num separador com vistas EMPILHADAS por cima tem de voltar à raiz (é o que o PearOS faz).
       Sem isto, uma app que empurre uma vista fora dos separadores - as Mensagens do Instashot, por
       exemplo - ficava presa: tocar noutro separador via `i === cur` (a pilha nunca mudou o `cur`),
       fazia só scroll, e a vista empurrada continuava por cima. Voltar lá acrescentava OUTRA por
       cima dessa, com tudo o que ela tem dentro. */
    /* Android (2026-10-01, pedido do dono: "esta UI nao deve trocar de cor"): o separador ativo NAO leva a cor de destaque da
       app (o verde do Dark Chat, o rosa de outra...), fica branco sobre barras escuras e preto sobre barras claras. Mede-se a
       barra (ou a janela, se a barra for transparente) e marca-se .tb-dark / .tb-light; o resto e CSS (oneui-ui.css). */
    const lumOf = c => { const m = /rgba?\(([\d.]+),\s*([\d.]+),\s*([\d.]+)(?:,\s*([\d.]+))?/.exec(c || ''); if (!m || (m[4] != null && +m[4] < .35)) return null; return (.2126 * m[1] + .7152 * m[2] + .0722 * m[3]) / 255; };
    const tone = () => { if (!isA() || !tb.isConnected) return;
      let lv = lumOf(getComputedStyle(pill).backgroundColor); if (lv == null) lv = lumOf(getComputedStyle(tb).backgroundColor);
      if (lv == null) { const v = win.querySelector('.nav-stack > .view'); lv = lumOf(getComputedStyle(v || win).backgroundColor); }
      if (lv == null) lv = (window.System && System.state && System.state.dark) ? 0 : 1;
      tb.classList.toggle('tb-dark', lv < .5); tb.classList.toggle('tb-light', lv >= .5); };
    const go = (i, force) => { const st = stackOf(win); const fundo = !st || st.children.length <= 1;
      if (i === cur && !force && fundo) { const c = win.querySelector('.view .content'); if (c) c.scrollTo({ top: 0, behavior: 'smooth' }); return; } cur = i; api.cur = i;
      const apart = !!(btns[i] && btns[i].classList.contains('tab-search'));   /* separador de pesquisa num círculo à parte (Nova UI, ou PearOS com prominent) */
      btns.forEach((t, k) => t.classList.toggle('on', k === i)); tb.classList.toggle('searching', apart); if (window.Glass && Glass.tabMorph && !opts.plain) Glass.tabMorph(pill, apart ? null : btns[i]);   /* PearOS 27: a cápsula do separador ativo desliza como gel */ const v = tabs[i].view(); v.classList.add('tab-in'); setRoot(win, v); v.content && v.content.classList.add('has-tabbar'); tone(); railSoon(win); };
    /* tema claro/escuro mudado com a app aberta: volta a medir; a janela morta larga o ouvinte */
    if (window.Bridge && Bridge.on) { const off = Bridge.on('state', p => { if (!tb.isConnected) { off && off(); return; } if (p && ('theme' in p || 'dark' in p)) setTimeout(() => { tone(); tbSync(win); }, 30); }); }
    if (opts.plain) win.classList.add('plain-tabbar');
    /* PearOS 27.2: a pesquisa voltou para DENTRO da barra (um separador igual aos outros, estilo "separador normal" das regras do
       sistema); o círculo à parte fica para quem o pede (t.prominent: "separador em destaque", sempre à vista) e para a Nova UI */
    const A0 = isA(); if (!A0 && !opts.plain) { tb.classList.add('tb27'); if (tabs.length >= 5) tb.classList.add('tb-5'); }
    tabs.forEach((t, i) => { const apart = !!t.search && (A0 || !!t.prominent); const b = el(`<div class="tab ${apart ? 'tab-search lg' : ''}${t.search && !apart ? ' tab-find' : ''}">${g(t.icon)}<span>${esc(t.label)}</span></div>`); b.onclick = () => go(i); btns.push(b); (apart ? tb : pill).appendChild(b); });
    /* NOVA Fold8 aberto: barra lateral (tbSync). Uma app que esconda a barra com uma classe ou um estilo (a Galeria, .agal-tb-off)
       devolve a largura à pilha: a barra é vigiada, mas só se faz alguma coisa com o dobrável aberto no Android */
    win.classList.add('tb-win'); win._tbTone = tone;
    if (window.MutationObserver) { let k0 = ''; new MutationObserver(() => { if (!railMode() || !tb.isConnected) return; const k = tb.className.replace(/\b(compact|tb-dark|tb-light|searching)\b/g, '') + '|' + (tb.getAttribute('style') || '') + tb.hidden; if (k === k0) return; k0 = k; tbSync(win); }).observe(tb, { attributes: true, attributeFilter: ['class', 'style', 'hidden'] }); }
    win.appendChild(tb);
    /* badge(i, n): n numérico mostra a contagem; `true` mostra só o PONTO vermelho (é o que o
       Instagram faz no avião das mensagens - um ponto, sem número) */
    /* PearPhone Fold: os separadores são uma pílula vertical na barra direita (railSync); tocar lá é tocar no separador daqui
       (btn: o onclick dele, que a app pode ter trocado) */
    const badges = [];
    win._tbApi = { tabs, cur: () => cur, go: i => go(i), btn: i => btns[i] || null, badges };
    const api = { go: i => go(i, true), el: tb, cur: 0, refresh: () => go(cur < 0 ? 0 : cur, true), badge: (i, n) => { badges[i] = n || null; railSoon(win); const t = btns[i]; if (!t) return; let b = t.querySelector('.tb-badge'); if (!n) { b && b.remove(); return; } if (!b) { b = el('<div class="tb-badge"></div>'); t.appendChild(b); } b.classList.toggle('dot', n === true); b.textContent = n === true ? '' : (n > 99 ? '99+' : n); } };
    go(active); return api;
  }

  /* ---------- Listas ---------- */
  function list(sections) { const wrap = el('<div class="list"></div>');
    /* uma secção só com rodapé não gera cartão: um .group vazio tem altura 0 mas continua a somar a margem de 18 px e afastava o rodapé do bloco que descreve */
    sections.forEach(s => { if (s.header) wrap.appendChild(el(`<div class="group-header">${esc(s.header)}</div>`)); if ((s.items || []).length) { const grp = el('<div class="group"></div>'); s.items.forEach(it => grp.appendChild(item(it))); wrap.appendChild(grp); } if (s.footer) wrap.appendChild(el(`<div class="group-footer">${esc(s.footer)}</div>`)); });
    return wrap; }
  function item(it) {
    const li = el(`<div class="li ${it.cls || ''}"></div>`);
    const A = isA();
    if (it.avatar) { li.classList.add('has-icon', 'has-big'); li.appendChild(el(avatar(it.avatar, 'sm'))); }
    else if (it.icon) { li.classList.add('has-icon'); if (it.big) li.classList.add('has-big'); const raw = typeof it.icon === 'string' && it.icon.trim().startsWith('<');
      /* Nova UI: icone TONAL nas apps do sistema (oneui-ui.css). --ic = a cor do circulo (a 10 %), --icc = a do simbolo
         (num degrade e a primeira cor dele). O fundo solido fica no style para as apps de terceiros, que o mantem. */
      const bg = it.iconBg || 'var(--gray)', icc = /gradient/i.test(bg) ? ((/#[0-9a-f]{3,8}\b|rgba?\([^)]*\)/i.exec(bg) || [])[0] || '') : bg;
      const ton = A && !it.tile && !it.big && !/^(transparent|none)$/i.test(String(bg).trim()) ? `--ic:${bg};${icc ? '--icc:' + icc + ';' : ''}` : '';
      /* .ou-tic marca o icone tonal para o oneui-ui.css (antes era [style*="--ic:"], um seletor de atributo que obrigava o Chromium a refazer subarvores inteiras) */
      li.appendChild(el(`<div class="li-icon ${it.big ? 'big' : ''} ${it.tile ? 'tile' : ''}${ton ? ' ou-tic' : ''}" style="background:${bg};${it.iconColor ? 'color:' + it.iconColor : ''}${ton ? ';' + ton : ''}">${raw ? it.icon : g(it.icon)}</div>`)); }
    if (it.check !== undefined) li.appendChild(check(it.check, it.onCheck));
    li.appendChild(el(`<div class="li-body"><div class="li-label">${it.html != null ? it.html : esc(it.label)}</div>${it.sub ? `<div class="li-sub">${it.subHtml ? it.sub : esc(it.sub)}</div>` : ''}</div>`));
    if (it.value !== undefined && it.value !== null && it.value !== '') li.appendChild(el(`<div class="li-value">${it.valueHtml ? it.value : esc(it.value)}</div>`));
    /* Nova UI: o valor de texto vai POR BAIXO do rotulo (azul quando a linha abre uma escolha, cinzento quando so informa).
       Desenha-se uma copia la dentro e o CSS mostra uma ou outra: nas apps de terceiros fica o valor a direita, como no PearOS. */
    if (A) { const hasV = it.value !== undefined && it.value !== null && it.value !== '';
      if (hasV && !it.valueHtml && !it.sub && !it.avatar) { li.querySelector('.li-body').appendChild(el(`<div class="ou-val">${esc(it.value)}</div>`)); li.classList.add('ou-hv'); }
      if (it.onTap) li.classList.add('ou-tap'); if (it.toggle !== undefined) li.classList.add('ou-sw');
      /* caixa ou botao de opcao a esquerda: a divisoria comeca no texto (64 = 24 + 24 + 16), como no components.html */
      if (it.check !== undefined || (it.right && it.right.classList && it.right.classList.contains('ou-radio'))) li.classList.add('ou-lead'); }
    if (it.right) li.appendChild(typeof it.right === 'string' ? el(it.right) : it.right);
    if (it.toggle !== undefined) { li.appendChild(toggle(it.toggle, it.onToggle)); li.classList.add('static'); }
    else if (it.chevron === true || (it.onTap && it.chevron !== false)) li.appendChild(el(`<div class="li-chev">${g('chevR')}</div>`));
    /* Nova UI: linha de navegacao com icone que pediu chevron:false (raiz das Definicoes) leva uma seta escondida; o CSS so a
       mostra onde a lista da referencia a tem (.aset-root). No PearOS nada muda. */
    else if (A && it.onTap && it.icon && !it.big && !it.tile && !it.right && it.check === undefined) li.appendChild(el(`<div class="li-chev ou-chev-auto">${g('chevR')}</div>`));
    if (it.onTap) li.onclick = e => { if (e.target.closest('.toggle,.check,input,.pill-btn,.nostop')) return; it.onTap(li, e); };
    else if (it.toggle === undefined) li.classList.add('static');
    if (it.onLong) longPress(li, e => it.onLong(li, e));
    return li;
  }
  function toggle(on, onChange) { const t = el(`<label class="toggle"><input type="checkbox" ${on ? 'checked' : ''}><span></span></label>`); t.querySelector('input').onchange = e => { Sound.play('click'); onChange && onChange(e.target.checked); }; return t; }
  function check(on, onChange) { const c = el(`<div class="check ${on ? 'on' : ''}">${g('check')}</div>`); c.onclick = e => { e.stopPropagation(); c.classList.toggle('on'); onChange && onChange(c.classList.contains('on')); }; return c; }
  /* campo de pesquisa do sistema: lupa + campo + X para limpar (aparece quando há texto) */
  /* Cada chamada ao onInput reconstrói uma lista inteira (a Biblioteca de Apps refaz ~35 tiles SVG,
     os Contactos um UI.list por letra). A escrever depressa num teclado a sério isso era um rebuild
     por tecla. Agora: uma tecla com o campo PARADO (≥ QUIET ms desde a anterior) responde logo, como
     antes - é o caso do teclado virtual, toque a toque; numa rajada as teclas do meio juntam-se e só
     a última filtra, QUIET ms depois de parar. Limpar o campo responde sempre de imediato. */
  const QUIET = 120;
  function search(placeholder, onInput) { const s = el(`<div class="search">${g('search')}<input type="text" placeholder="${esc(placeholder || 'Pesquisar')}"><div class="s-clr">${g('x', 10)}</div></div>`); s.input = s.querySelector('input');
    let qT = null, lastKey = 0;
    const run = () => { qT = null; onInput && onInput(s.input.value.trim().toLowerCase()); };
    const fire = () => { s.classList.toggle('has', !!s.input.value); const now = performance.now(), calm = now - lastKey >= QUIET; lastKey = now; clearTimeout(qT);
      if (!onInput) return; if (calm || !s.input.value.trim()) run(); else qT = setTimeout(run, QUIET); }; s.input.oninput = fire;
    s.querySelector('.s-clr').onclick = e => { e.stopPropagation(); s.input.value = ''; fire(); s.input.focus(); }; return s; }
  function seg(opts, active, onChange) { const s = el('<div class="seg"></div>'); opts.forEach((o, i) => { const d = el(`<div class="${i === active ? 'on' : ''}">${esc(o)}</div>`); d.onclick = () => { [...s.children].forEach((c, k) => c.classList.toggle('on', k === i)); onChange && onChange(i); }; s.appendChild(d); }); return s; }
  function chips(opts, active, onChange) { const s = el('<div class="chips"></div>'); opts.forEach((o, i) => { const d = el(`<span class="${i === active ? 'on' : ''}">${esc(o)}</span>`); d.onclick = () => { [...s.children].forEach((c, k) => c.classList.toggle('on', k === i)); onChange && onChange(i, o); }; s.appendChild(d); }); return s; }
  function empty(icon, title, sub) { const e = el(`<div class="empty">${g(icon)}<b>${esc(title)}</b><span>${esc(sub || '')}</span></div>`); emptyFit(e); return e; }
  /* estado vazio AO CENTRO (pedido do dono: "coisas do genero devem estar sempre ao centro"). O .empty ja ocupa o espaco que
     sobra quando e filho direto da .content (ui.css), mas a maior parte das apps poe-no dentro de um holder COM classe
     (.ea-list, .notes-list, .aph-rec...): um bloco normal, e o aviso colava-se ao topo. Esse holder leva .ui-isempty so enquanto
     for o ULTIMO filho da .content, o aviso for o UNICO filho dele e ele nao tiver fundo, contorno nem sombra (um cartao nao
     estica). Um observador (so childList) tira a marca quando a app repinta o holder ou lhe junta irmaos, e larga-se logo. */
  function emptyFit(e, tries) {
    const ok = h => { const c = h && h.parentElement; return !!(c && c.classList.contains('content') && c.lastElementChild === h && h.childElementCount === 1 && h.firstElementChild === e); };
    Promise.resolve().then(() => { const h = e.parentElement; if (!ok(h)) return;
      if (!h.isConnected) { if ((tries || 0) < 3) setTimeout(() => emptyFit(e, (tries || 0) + 1), 60); return; }
      const cs = getComputedStyle(h), bg = cs.backgroundColor;
      if ((bg && bg !== 'transparent' && !/rgba\([^)]*,\s*0\)$/.test(bg)) || cs.backgroundImage !== 'none' || cs.boxShadow !== 'none' || parseFloat(cs.borderTopWidth) > 0 || parseFloat(cs.borderBottomWidth) > 0) return;
      if (!window.MutationObserver) return;
      h.classList.add('ui-isempty');
      const mo = new MutationObserver(() => { if (ok(h)) return; h.classList.remove('ui-isempty'); mo.disconnect(); });
      mo.observe(h, { childList: true }); mo.observe(h.parentElement, { childList: true }); });
  }
  const spinner = () => el('<div class="spinner"></div>');
  /* ---------- Skeletons (marcas de carregamento) ----------
     UI.skeleton('list' | 'grid' | 'feed', n) → um elemento para pôr no lugar do conteúdo enquanto o RPC
     não responde; quem chama troca-o pelo conteúdo real (el.replaceWith / innerHTML = '').
     Só a OPACIDADE do invólucro pulsa (uma única camada composta) - nada de gradientes a correr por
     transform em cada bloco nem de filter: no CEF eram N camadas por frame. */
  function skeleton(kind = 'list', n) {
    const k = kind === 'grid' || kind === 'feed' ? kind : 'list';
    const cnt = Math.max(1, Math.min(k === 'grid' ? 30 : 12, Math.floor(+n || (k === 'grid' ? 12 : k === 'feed' ? 3 : 6))));
    const rep = (s, i = cnt) => Array.from({ length: i }, (_, x) => s(x)).join('');
    let inner;
    /* `sk-cells` e não `sk-grid`: o invólucro já leva `sk-grid` e, com a mesma classe dentro, a grelha de 3 colunas
       aplicava-se aos dois - o bloco de dentro ficava metido na 1.ª coluna, com um terço da largura */
    if (k === 'grid') inner = `<div class="sk-cells">${rep(() => '<div class="sk sk-cell"></div>')}</div>`;
    else if (k === 'feed') inner = rep(x => `<div class="sk-post"><div class="sk-head"><div class="sk sk-av"></div><div class="sk-lines"><div class="sk sk-l1"></div><div class="sk sk-l2"></div></div></div><div class="sk sk-media"></div><div class="sk sk-l1 w${x % 3}"></div><div class="sk sk-l2 w${(x + 1) % 3}"></div></div>`);
    else inner = `<div class="group sk-group">${rep(x => `<div class="sk-row"><div class="sk sk-av"></div><div class="sk-lines"><div class="sk sk-l1 w${x % 3}"></div><div class="sk sk-l2 w${(x + 2) % 3}"></div></div></div>`)}</div>`;
    const s = el(`<div class="skeleton sk-${k}" aria-busy="true" aria-label="${esc(T('A carregar…'))}">${inner}</div>`);
    return s;
  }

  /* ---------- Alert / prompt / confirm ---------- */
  /* ---------- Camadas passageiras abertas (folhas, alertas, menus) ----------
     Guardar o telemóvel com uma folha aberta deixava-a lá para quando se voltasse a abrir
     (bug in-game: criar anúncio no Marketplace → fechar → abrir e o menu ainda estava lá).
     Cada camada regista aqui a SUA função de fecho - não se apaga do DOM à força, porque
     quem está à espera (`await UI.actionSheet(...)`, `UI.prompt`, os pickers) ficaria
     pendurado para sempre. Dispensar é sempre pelo caminho normal, com a promessa a
     resolver-se em "cancelado". */
  const OPEN = new Set();
  const track = fn => { OPEN.add(fn); return () => OPEN.delete(fn); };
  function dismissAll() {
    const l = [...OPEN].reverse(); OPEN.clear();
    l.forEach(fn => { try { fn(); } catch (e) {} });
    try { if (window.Keyboard) Keyboard.hide(); } catch (e) {}
    return l.length;
  }
  /* só os MENUS presos a um ponto do ecrã (menu de contexto, lista de um <select>): abrir ou fechar o dobrável muda a geometria
     e eles ficavam no sítio antigo; as folhas, os alertas e as listas de ações ficam (o CSS volta a centrá-los) */
  const MENUS = new Set();
  function dismissMenus() { const l = [...MENUS]; MENUS.clear(); l.forEach(fn => { try { fn(); } catch (e) {} }); return l.length; }
  /* so a camada de CIMA (a ultima aberta): e o botao Voltar do Android (folha, alerta, menu de contexto...).
     Devolve true se fechou alguma, para quem chama saber que o Voltar ja foi gasto. */
  function dismissTop() {
    const l = [...OPEN]; const fn = l[l.length - 1]; if (!fn) return false;
    OPEN.delete(fn); try { fn(); } catch (e) {}
    return true;
  }
  const openCount = () => OPEN.size;

  function alert(o) { return new Promise(res => {
    /* Nova UI: dialogo em baixo, titulo a esquerda e botoes de TEXTO lado a lado (com divisoria); so empilha
       quando sao mais de tres ou os rotulos nao cabem numa linha */
    const A = ouLayer(o.cls), nb = (o.buttons || []).length;
    if (isA()) o = Object.assign({}, o, { title: ouTxt(o.title), msg: ouTxt(o.msg) });
    /* PearOS 27: botões em cápsula. Dois lado a lado (cancelar à esquerda, ação à direita) só enquanto os rótulos cabem em meia largura;
       senão empilham com a ação em cima e o cancelar em baixo (.rev inverte a ordem em que as apps os dão: [Cancelar, Ação]) */
    const lens = (o.buttons || []).map(b => String(b.label || '').length), lsum = lens.reduce((s, n) => s + n, 0);
    const P27 = !A && !isA();   /* só o PearOS: as apps de terceiros no Android continuam como estavam */
    const stack = A ? (nb > 3 || (nb > 1 && lsum > (nb === 3 ? 26 : 30))) : (nb > 2 || (P27 && nb === 2 && (Math.max.apply(null, lens) > 12 || lsum > 22)));
    const rev = P27 && stack && nb === 2;
    /* `foot` (4 nov 2026): o CÓDIGO da recusa do servidor ('noprofile', 'ratelimit', 'timeout'...) por baixo da frase, num nó à
       parte com data-noi18n - a frase continua igual à chave do dicionário e o código nunca é traduzido. Antes o "Não publicado ·
       Tenta novamente." escondia o motivo e quem dava suporte não tinha nada para pedir ao jogador. */
    const ov = el(`<div class="overlay ${A ? 'ou-dlg' : ''} ${o.input ? 'al-input' : ''} ${o.cls || ''}"><div class="alert lg"><div class="alert-body">${o.head || ''}<div class="alert-title">${esc(o.title || '')}</div>${o.msg ? `<div class="alert-msg">${esc(o.msg)}</div>` : ''}${o.foot ? `<div class="alert-foot" data-noi18n>${esc(o.foot)}</div>` : ''}${o.input ? `<input type="${o.input.type || 'text'}" placeholder="${esc(o.input.placeholder || '')}" value="${esc(o.input.value || '')}" maxlength="${o.input.maxlength || 80}" ${o.input.type === 'password' || o.input.numeric ? 'inputmode="numeric"' : ''}>` : ''}</div><div class="alert-btns ${stack ? 'stack' : ''}${rev ? ' rev' : ''}"></div></div></div>`);
    const btns = ov.querySelector('.alert-btns'), inp = ov.querySelector('input');
    let untrack = null;
    let finish = v => { if (untrack) { untrack(); untrack = null; } ov.classList.remove('in'); setTimeout(() => ov.remove(), 200); res(v); };
    untrack = track(() => finish({ value: false, text: '' }));   /* guardar o telemóvel = cancelar */
    (o.buttons || [{ label: 'OK', bold: true, value: true }]).forEach(b => { const d = el(`<div class="${b.bold ? 'bold' : ''} ${b.danger ? 'danger' : ''}">${esc(b.label)}</div>`); d.onclick = () => finish({ value: b.value, text: inp ? inp.value.trim() : '' }); btns.appendChild(d); });
    /* Nova UI: tocar fora do dialogo cancela - só se o toque COMEÇOU fora. Com o teclado virtual o diálogo desce quando o campo
       perde o foco e o largar caía no fundo: o Chromium entrega o click ao antepassado comum (o fundo) = cancelado sem querer */
    if (A) { let downOnOv = false; ov.addEventListener('pointerdown', e => { downOnOv = e.target === ov; }, true);
      ov.addEventListener('click', e => { if (e.target === ov && downOnOv && untrack) finish({ value: false, text: '' }); }); }
    /* Nova UI: o dialogo vive em baixo, onde o teclado aparece; o teclado avisa (kb:show / kb:hide, shell/keyboard.js)
       e o dialogo sobe a altura dele (so transform). Os ouvintes saem com o dialogo. */
    if (A && inp && window.Bridge && Bridge.on) { const k1 = Bridge.on('kb:show', d => { if (ov.isConnected) ov.style.setProperty('--ou-kb', Math.max(0, +(d && d.h) || 0) + 'px'); });
      const k2 = Bridge.on('kb:hide', () => ov.style.removeProperty('--ou-kb'));
      const f0 = finish; finish = v => { try { k1(); k2(); } catch (e) {} f0(v); }; }
    /* ALERTA SEM CAMPO com um campo de outra camada ainda com o foco (4 nov 2026): desde que os botões do cabeçalho das folhas
       deixaram de tirar o foco (preventDefault no pointerdown, UI.sheet), um onDone que mantém a folha aberta e depois mostra um
       alerta (fatura ou encomenda recusada nas apps de empresa, contacto que não guardou, foto de grupo que não subiu) abria-o com
       o teclado ainda em cima: na Nova UI o diálogo vive em baixo, ATRÁS das teclas (#kb z 250 > .overlay 200) e o OK ficava
       escondido; no PearOS as teclas iam para o campo por trás do alerta. O alerta é modal: o campo larga-se aqui, num sítio só
       para todas as apps, e o focusout do teclado (shell/keyboard.js) recolhe-o. O rascunho fica no campo. */
    if (!o.input) { const a = document.activeElement; if (a && a.matches && a.matches('input,textarea')) { try { a.blur(); } catch (e) {} } }
    screen().appendChild(ov); requestAnimationFrame(() => { ov.classList.add('in'); if (inp) inp.focus(); });
    if (inp) inp.onkeydown = e => { if (e.key === 'Enter') { const last = btns.lastElementChild; last && last.click(); } };
  }); }
  const prompt = (title, msg, placeholder, value, type) => alert({ title, msg, input: { placeholder, value, type }, buttons: [{ label: T('Cancelar'), value: false }, { label: T('OK'), bold: true, value: true }] }).then(r => r.value ? r.text : null);
  /* `cls` viaja até ao invólucro do overlay: alertas, folhas e menus são montados no #screen, FORA da janela da app,
     por isso uma app com tema próprio (Onion, Cripto) via-os aparecer com as cores do sistema. */
  const confirm = (title, msg, ok = 'OK', danger = false, cls = '') => alert({ title, msg, cls, buttons: [{ label: T('Cancelar'), value: false }, { label: ok === 'OK' ? T('OK') : ok, bold: !danger, danger, value: true }] }).then(r => !!r.value);

  /* ---------- Sheet ---------- */
  /* PearOS 27: os botões do cabeçalho de uma folha são peças de vidro. Fechar / cancelar = círculo com o X; concluir = círculo tingido com o
     visto; qualquer outro rótulo fica em cápsula de texto (a da direita tingida: é a ação principal). O texto continua no DOM (é a chave de
     tradução e o que as apps mudam com textContent): o glifo é desenhado pelo CSS (pear27-kit.css, .sh-x / .sh-ok). */
  const shKind = (label, right) => { if (!label) return '';
    const is = keys => keys.some(k => label === k || label === T(k));
    if (is(['Cancelar', 'Fechar'])) return 'sh-x';
    if (right && is(['OK', 'Concluído', 'Concluir', 'Guardar', 'Feito'])) return 'sh-ok';
    return right ? 'sh-t sh-pro' : 'sh-t'; };
  function sheet(o) {
    const OS = ouLayer(o.cls), P27 = !OS && !isA(), rl = o.right || 'OK', kl = P27 ? shKind(o.left || '', false) : '', kr = P27 ? shKind(rl, true) : '';
    const w = el(`<div class="sheet-wrap ${OS ? 'ou-sheet' : ''} ${P27 ? 'sh27' : ''} ${appCtx() ? 'az' : ''} ${o.cls || ''}"><div class="sheet lg"><div class="grabber"></div><div class="sheet-head"><span class="sh-l ${kl}"${kl === 'sh-x' ? ' role="button" aria-label="' + esc(o.left) + '"' : ''}>${esc(o.left || '')}</span><b>${esc(o.title || '')}</b><span class="sh-r ${kr}"${kr === 'sh-x' || kr === 'sh-ok' ? ' role="button" aria-label="' + esc(rl) + '"' : ''}>${esc(rl)}</span></div><div class="content"></div></div></div>`);
    const content = w.querySelector('.content'); if (o.body) content.appendChild(o.body);
    /* `foot` (4 nov 2026): o que fica PRESO ao fundo da folha, fora do que rola (o compositor dos comentários). Dentro do
       .content ficava no fim de uma lista comprida e saía da vista; aqui a lista rola por cima dele e o teclado, que sobe a
       folha inteira (shell/keyboard.js place), deixa-o assente em cima das teclas. */
    if (o.foot) { const f = document.createElement('div'); f.className = 'sheet-foot'; f.appendChild(o.foot); w.querySelector('.sheet').appendChild(f); w.querySelector('.sheet').classList.add('has-foot'); }
    let closed = false;
    let untrack = null;
    /* fechar com um campo da folha ainda com o foco: o Chromium não dispara focusout num nó que sai do DOM e o teclado virtual
       (que só ouve focusout) ficava aberto por cima do nada. Agora que os botões do cabeçalho já não tiram o foco ao campo
       (pointerdown mais abaixo), é o fecho que o larga. */
    const close = () => { if (closed) return; closed = true; if (untrack) { untrack(); untrack = null; } const a = document.activeElement; if (a && a !== document.body && w.contains(a)) { try { a.blur(); } catch (e) {} } w.classList.add('closing'); w.classList.remove('in'); setTimeout(() => w.remove(), 380); o.onClose && o.onClose(); };
    untrack = track(close);
    /* um onDone que rebenta deixava a folha PRESA aberta (e o erro só na consola): o botão Guardar/Concluir
       ficava mudo para sempre e a única saída era guardar o telemóvel. Agora o erro é registado e a folha
       fecha na mesma - só um `return false` explícito a mantém aberta. */
    w.querySelector('.sh-r').onclick = () => { let manter = false; if (o.onDone) { try { manter = o.onDone() === false; } catch (e) { console.error('[apex_phone] folha onDone', e); } } if (!manter) close(); };
    /* TOCAR NO FUNDO fecha a folha, mas só se o toque COMEÇOU no fundo (4 nov 2026, "não consigo publicar nada no Tweeter").
       Com o teclado virtual em cima a folha está subida a altura dele; um clique lento no Publicar tirava o foco ao campo, o
       teclado descia 120 ms depois, a folha descia com ele por baixo do rato ainda premido e o largar caía no fundo. O Chromium
       entrega o click ao antepassado comum do premir e do largar - o próprio fundo - e a folha fechava sem publicar, com o texto
       perdido. Um click cujo premir foi num botão nunca é lido como um toque no fundo. */
    let downOnWrap = false;
    w.addEventListener('pointerdown', e => { downOnWrap = e.target === w; }, true);
    w.querySelector('.sh-l').onclick = close; w.onclick = e => { if (e.target === w && downOnWrap) close(); };
    /* arrastar a folha para baixo (pega/cabeçalho) fecha-a, como no PearOS; abaixo do limiar volta com mola */
    const sh = w.querySelector('.sheet'); let ds = null;
    /* ESCURECIMENTO DURANTE O ARRASTO por OPACIDADE, não por cor de fundo. Mudar o `background` do
       invólucro (ecrã inteiro) a cada pointermove obrigava a repintar 440×956 por frame. No primeiro
       movimento o invólucro fica transparente e um véu preto por baixo da folha (camada própria,
       will-change) faz o mesmo escurecimento só com opacity - composto na GPU. .4 × preto é
       exatamente o rgba(0,0,0,.4) do ui.css, por isso nada muda à vista; no fim sai e tudo volta ao CSS. */
    let dim = null, dimA = .4;
    /* o véu de partida é o do CSS (.4; .25 no PearPhone Fold, como o Duo): lido uma vez no primeiro movimento */
    const dimTo = k => { if (!dim) { const m = /^rgba\(.*,\s*([\d.]+)\)$/.exec(getComputedStyle(w).backgroundColor || ''); dimA = m ? +m[1] : .4; dim = document.createElement('div'); dim.style.cssText = 'position:absolute;inset:0;border-radius:inherit;background:#000;pointer-events:none;will-change:opacity'; w.insertBefore(dim, w.firstChild); w.style.background = 'transparent'; } dim.style.opacity = (dimA * k).toFixed(3); };
    const dimOff = () => { if (!dim) return; dim.remove(); dim = null; w.style.background = ''; };
    const dragFrom = h => {
      /* ⚠️ O cabeçalho da folha é a pega de arrastar E onde vivem os botões (Cancelar /
         Publicar / Adicionar / Concluir). Ao capturar o ponteiro aqui, o pointerup passa a
         ser entregue à PEGA e o `click` nunca chega ao botão - no CEF do jogo isso deixava
         os botões das folhas mudos em TODAS as apps. Um toque num botão não arrasta nada. */
      /* px do ponteiro → px da própria folha (UI.zoom(sh): o aparelho e, no PearPhone Fold, o zoom da app), lido uma vez por arrasto */
      /* e o premir num botão do cabeçalho NÃO tira o foco ao campo da folha (preventDefault no pointerdown, o mesmo truque das teclas
         do teclado virtual): sem isto o campo perdia o foco, o teclado descia a meio do clique e a folha fugia de baixo do rato
         (ver o downOnWrap acima). O click continua a chegar ao botão - cancelar o pointerdown só suprime o mousedown/mouseup. */
      h.addEventListener('pointerdown', e => { if (e.button && e.pointerType === 'mouse') return; if (e.target.closest('.sh-l, .sh-r')) { e.preventDefault(); return; } ds = { y: e.clientY, t: Date.now(), ly: e.clientY, lt: Date.now(), v: 0, z: zoom(sh) || 1 }; try { h.setPointerCapture(e.pointerId); } catch (x) {} sh.style.transition = 'none'; });
      h.addEventListener('pointermove', e => { if (!ds) return; const z = ds.z; let dy = (e.clientY - ds.y) / z; const now = Date.now(); ds.v = (e.clientY - ds.ly) / z / Math.max(1, now - ds.lt); ds.ly = e.clientY; ds.lt = now; if (dy < 0) dy = -(1 - 1 / (-dy * .55 / 60 + 1)) * 60; sh.style.transform = `translateY(${dy}px)`; dimTo(Math.max(0, 1 - Math.max(0, dy) / 600)); });
      const up = e => { if (!ds) return; const z = ds.z; const dy = (e.clientY - ds.y) / z, v = ds.v; ds = null; sh.style.transition = ''; dimOff(); if (dy > 140 || v > .7) { sh.style.transform = ''; if (o.onCancel) o.onCancel(); close(); } else sh.style.transform = ''; };
      h.addEventListener('pointerup', up); h.addEventListener('pointercancel', up);
    };
    dragFrom(w.querySelector('.grabber')); dragFrom(w.querySelector('.sheet-head'));
    screen().appendChild(w); requestAnimationFrame(() => w.classList.add('in'));
    return { close, content, el: w };
  }
  /* ---------- Action sheet ---------- */
  /* último toque dentro do ecrã, em px do ecrã (440 × 956): é de onde "nasce" a lista de ações do PearOS 27 */
  let tapAt = null;
  if (typeof document !== 'undefined') document.addEventListener('pointerdown', e => { try { const sc = screen(); if (!sc || !e.target || !sc.contains(e.target)) return;
    const s = vrect(sc), z = s.width > 0 ? s.width / SWpx() : 1; tapAt = { x: (e.clientX - s.left) / z, y: (e.clientY - s.top) / z, t: performance.now() }; } catch (x) {} }, true);
  function actionSheet(o) { return new Promise(res => {
    /* Nova UI: um so cartao em baixo, opcoes em linhas (icone a esquerda) e o Cancelar como botao de texto no fundo */
    const OA = ouLayer(o.cls);
    /* PearOS 27 (.as27): UM cartão de vidro com as ações em cápsulas empilhadas. Nasce do sítio tocado (.anch: sem Cancelar, tocar fora
       cancela); sem toque recente (aberto por um temporizador, uma resposta do servidor) fica ao centro, com o Cancelar no fim do cartão.
       No PearPhone Fold (conteúdo com zoom próprio) fica sempre ao centro. */
    const P27 = !OA && !isA(), tap = P27 && !appCtx() && SWpx() === 440 && tapAt && performance.now() - tapAt.t < 900 ? tapAt : null;   /* as apps de terceiros no Android ficam como estavam */
    const w = OA
      ? el(`<div class="as-wrap ou-as ${o.cls || ''}"><div class="as-group main">${o.title ? `<div class="as-title">${esc(o.title)}</div>` : ''}<div class="ou-as-list"></div><div class="ou-as-foot"><div class="as-btn bold cancel">${esc(o.cancel || T('Cancelar'))}</div></div></div></div>`)
      : el(`<div class="as-wrap ${P27 ? 'as27' : ''} ${tap ? 'anch' : ''} ${appCtx() ? 'az' : ''} ${o.cls || ''}"><div class="as-group main">${o.title ? `<div class="as-title">${esc(o.title)}</div>` : ''}</div><div class="as-group ${P27 ? 'as-cgrp' : ''}"><div class="as-btn bold cancel">${esc(o.cancel || 'Cancelar')}</div></div></div>`);
    const main = w.querySelector('.ou-as-list') || w.querySelector('.main');
    let untrack = null;
    const done = v => { if (untrack) { untrack(); untrack = null; } w.classList.remove('in'); setTimeout(() => w.remove(), 250); res(v); };
    untrack = track(() => done(null));
    (o.buttons || []).forEach(b => { const d = el(OA ? `<div class="as-btn ${b.danger ? 'danger' : ''} ${b.bold ? 'bold' : ''}">${b.icon ? g(b.icon, 22) : ''}<span>${esc(b.label)}</span></div>` : `<div class="as-btn ${b.danger ? 'danger' : ''} ${b.bold ? 'bold' : ''}">${b.icon ? g(b.icon, 20) + ' ' : ''}${esc(b.label)}</div>`); d.onclick = () => done(b.value !== undefined ? b.value : b.label); main.appendChild(d); });
    /* o fundo só cancela um toque que COMEÇOU no fundo (o mesmo do UI.sheet): premir uma opção e largar fora não é "cancelar" */
    let downOnWrap = false; w.addEventListener('pointerdown', e => { downOnWrap = e.target === w; }, true);
    w.querySelector('.cancel').onclick = () => done(null); w.onclick = e => { if (e.target === w && downOnWrap) done(null); };
    if (P27) { const mg = w.querySelector('.as-group.main'), cg = w.querySelector('.as-cgrp');
      if (!tap) { mg.appendChild(cg.firstElementChild); cg.remove(); }   /* ao centro: o Cancelar é a última cápsula do mesmo cartão */
      else { /* medidas de layout (nunca rects): 52 por ação + 8 entre elas, 15 de margem interior, o título conta pelas linhas que ocupa */
        const n = (o.buttons || []).length, W = 286, tl = o.title ? 26 + Math.ceil(String(o.title).length / 30) * 20 : 0, H = 30 + tl + n * 52 + Math.max(0, n - 1) * 8;
        const x = Math.round(Math.max(14, Math.min(440 - W - 14, tap.x - W / 2))), up = tap.y > 500 && tap.y - 18 - H > 60;
        let y = up ? tap.y - 18 - H : tap.y + 18; y = Math.round(Math.max(64, Math.min(956 - 40 - H, y)));
        mg.style.left = x + 'px'; mg.style.top = y + 'px'; mg.style.width = W + 'px';
        mg.style.setProperty('--ox', Math.max(0, Math.min(W, tap.x - x)).toFixed(0) + 'px'); mg.style.setProperty('--oy', (up ? H : 0) + 'px'); } }
    screen().appendChild(w); requestAnimationFrame(() => w.classList.add('in'));
  }); }
  /* ---------- Menu de contexto (long press) ---------- */
  function ctxMenu(target, items, opts = {}) {
    /* Nova UI: menu flutuante r26 com o icone a ESQUERDA do rotulo; linhas de 52 px e o menu nunca desce para a barra de navegacao */
    /* PearOS 27: linhas de 48 px num menu de 262, glifo ANTES do rótulo (o CSS inverte a linha; .no-ic alinha os rótulos sem glifo pelos outros) */
    const A = ouLayer(opts.cls, target), P27 = !A && !isA(), IH = A ? 52 : (P27 ? 48 : 44), MW = A ? 240 : (P27 ? 262 : 250), YMAX = A ? 956 - navOff() - 12 : 940;
    const anyIc = P27 && items.some(it => it && it.icon);
    const wrap = el(`<div class="ctx-wrap ${A ? 'ou-ctx' : ''} ${opts.cls || ''}"></div>`); const menu = el(`<div class="ctx ${A ? '' : 'lg'}"></div>`);
    items.forEach(it => { const d = el(A ? `<div class="${it.danger ? 'danger' : ''}">${it.icon ? g(it.icon) : ''}<span>${esc(it.label)}</span></div>` : `<div class="${it.danger ? 'danger' : ''}${anyIc && !it.icon ? ' no-ic' : ''}"><span>${esc(it.label)}</span>${it.icon ? g(it.icon) : ''}</div>`); d.onclick = e => { e.stopPropagation(); close(); it.onTap && it.onTap(); }; menu.appendChild(d); });
    let untrack = null;
    const close = () => { MENUS.delete(close); if (untrack) { untrack(); untrack = null; } wrap.classList.remove('in'); setTimeout(() => wrap.remove(), 200); };
    untrack = track(close); MENUS.add(close);
    wrap.onclick = close; wrap.appendChild(menu); screen().appendChild(wrap);
    /* escala real do ecrã (zoom no jogo / harness): retângulos em px REAIS (UI.vrect, os dois motores) e contas em px do ecrã (SW = 440,
       ou 670 / 1340 nos dobráveis). PearPhone Fold: o menu fica à esquerda da barra direita (CW = a zona do conteúdo); o menu de uma app
       leva o zoom do conteúdo (.az): as medidas dele (MW, IH) crescem k vezes e a posição escreve-se nos px do invólucro (÷ k) */
    const SW = SWpx(), RW = railOn() ? (Rail.width || 0) : 0, CW = SW - RW;
    let x = 20, y = 200;
    /* aberto por um botão que está na barra direita (o da barra de cima está escondido, ou sem origem nenhuma): ao lado do círculo tocado */
    const fromRail = RW && lastRail && performance.now() - lastRail.at < 1500 && lastRail.el.isConnected;
    if (fromRail && !(target && target.closest && target.closest('.rail-apps')) && (!target || !target.getBoundingClientRect || (target.closest && target.closest('.navbar')) || !target.getBoundingClientRect().width)) target = lastRail.el;
    if (appCtx(target && target.nodeType === 1 ? target : null)) wrap.classList.add('az');
    const s = vrect(screen()), z = s.width > 0 ? s.width / SW : 1, k = (zoom(wrap) / (zoom(screen()) || 1)) || 1, mw = MW * k, ih = IH * k;
    if (RW && target && target.closest && target.closest('.rail-apps')) { const r = vrect(target); x = CW - mw - 8; y = Math.max(40, Math.min((r.top - s.top) / z, YMAX - items.length * ih - 20)); }
    /* dobrável: um menu sem elemento de origem (nem posição) abre ao centro da zona do conteúdo, não no canto esquerdo */
    else if (!(target && target.getBoundingClientRect) && opts.x === undefined && SW > 440) x = Math.round((CW - mw) / 2);
    if (target && target.getBoundingClientRect && !(RW && target.closest && target.closest('.rail-apps'))) { const r = vrect(target); x = (r.left - s.left) / z; y = (r.bottom - s.top) / z + 8; if (x + mw > CW - 10) x = CW - 10 - mw; if (y + items.length * ih + 40 > YMAX) y = (r.top - s.top) / z - items.length * ih - 12; if (y < 80) y = 80;
      /* PearOS: o ícone tocado fica nítido e "levantado" por cima do desfoque */
      const tile = target.classList && target.classList.contains('hi') ? target.querySelector('.tile') : null;
      if (tile) { const tr = vrect(tile); const pv = el('<div class="ctx-preview"></div>'); pv.appendChild(tile.cloneNode(true)); pv.style.cssText = `left:${(tr.left - s.left) / z / k}px;top:${(tr.top - s.top) / z / k}px;width:${tr.width / z / k}px;height:${tr.height / z / k}px`; wrap.appendChild(pv); y = (tr.bottom - s.top) / z + 14; if (y + items.length * ih + 40 > YMAX) y = (tr.top - s.top) / z - items.length * ih - 16; } }
    if (opts.x !== undefined) { x = Math.min(opts.x, A ? SW - mw - 10 : CW - mw - 10); y = Math.min(opts.y, YMAX - items.length * ih - 20); }
    if (A) { x = Math.max(10, x); y = Math.max(56, y); }
    menu.style.left = (x / k) + 'px'; menu.style.top = (y / k) + 'px';
    /* PearOS 27: o menu "abre" a partir do botão (ou do ícone) que o chamou: origem da escala no centro dele, em coordenadas do menu */
    if (!A) { let ox = mw / 2, oy = 0; const src = (target && target.classList && target.classList.contains('hi') && target.querySelector('.tile')) || (target && target.getBoundingClientRect ? target : null);
      if (src) { const r = vrect(src); ox = (r.left + r.width / 2 - s.left) / z - x; oy = (r.top + r.height / 2 - s.top) / z - y; }
      else if (opts.x !== undefined) { ox = Math.min(mw, Math.max(0, opts.x - x)); oy = Math.min(items.length * ih, Math.max(0, opts.y - y)); }
      ox = Math.min(mw + 20, Math.max(-20, ox)); oy = Math.min(items.length * ih + 40, Math.max(-60, oy));
      menu.style.setProperty('--ox', (ox / k).toFixed(1) + 'px'); menu.style.setProperty('--oy', (oy / k).toFixed(1) + 'px'); }
    requestAnimationFrame(() => wrap.classList.add('in')); return close;
  }

  /* ---------- Banner / toast ---------- */
  function banner(o) {
    const b = el(`<div class="banner lg ${isA() ? 'ou-banner' : ''}"><div class="tile">${o.iconHtml || Icons.tile(o.app || 'settings')}</div><div style="min-width:0"><div class="b-title">${esc(isA() ? ouTxt(o.title) : o.title)}</div><div class="b-msg">${esc((isA() ? ouTxt(o.msg) : o.msg) || '')}</div></div><div class="b-time">${esc(o.time || 'agora')}</div></div>`);
    let hidden = false; const hide = () => { if (hidden) return; hidden = true; b.classList.remove('in'); setTimeout(() => b.remove(), 500); };
    b.onclick = () => { hide(); o.onTap && o.onTap(); };
    swipe(b, { up: hide, left: hide, right: hide, threshold: 30 });
    screen().appendChild(b); requestAnimationFrame(() => b.classList.add('in')); setTimeout(hide, o.duration || 4500); return hide;
  }
  function toast(msg, ms = 1800, cls = '') {
    /* Nova UI: pilula em baixo, acima da barra de navegacao; entra com opacidade e um pequeno deslize (classe .in) */
    if (isA() && !(cls && thirdFront())) { screen().querySelectorAll(':scope > .ou-toast').forEach(x => x.remove());   /* um toast de cada vez: o novo substitui o anterior */
      const t = el(`<div class="toast ou-toast ${cls}">${esc(ouTxt(msg))}</div>`); screen().appendChild(t); requestAnimationFrame(() => t.classList.add('in'));
      setTimeout(() => { t.classList.remove('in'); setTimeout(() => t.remove(), 260); }, ms); return; }
    const t = el(`<div class="toast lg ${appCtx() ? 'az' : ''} ${cls}">${esc(msg)}</div>`); screen().appendChild(t); requestAnimationFrame(() => t.style.opacity = 1); setTimeout(() => { t.style.opacity = 0; setTimeout(() => t.remove(), 250); }, ms); }   /* estilos em ui.css (.toast) - no jogo sem backdrop-filter (motion.css) */

  /* ---------- Gestos utilitários ---------- */
  function longPress(elm, fn, ms = 480) {
    let t = null, sx = 0, sy = 0, fired = false;
    /* fired volta a false em QUALQUER pointerdown (também o do botão direito): antes só depois do teste do botão, e o
       contextmenu de um clique direito deixava fired = true - o segundo clique direito no mesmo elemento era ignorado */
    elm.addEventListener('pointerdown', e => { fired = false; if (e.button !== 0 && e.pointerType === 'mouse') return; sx = e.clientX; sy = e.clientY; t = setTimeout(() => { fired = true; fn(e); }, ms); });
    const cancel = () => { clearTimeout(t); t = null; };
    elm.addEventListener('pointermove', e => { if (t && Math.hypot(e.clientX - sx, e.clientY - sy) > 8) cancel(); });
    elm.addEventListener('pointerup', cancel); elm.addEventListener('pointercancel', cancel); elm.addEventListener('pointerleave', cancel);
    elm.addEventListener('click', e => { if (fired) { e.stopPropagation(); e.preventDefault(); fired = false; } }, true);
    elm.addEventListener('contextmenu', e => { e.preventDefault(); if (!fired) { fired = true; fn(e); } });
  }
  function swipe(elm, o) {
    let sx = 0, sy = 0, st = 0, on = false; const th = o.threshold || 50;
    elm.addEventListener('pointerdown', e => { sx = e.clientX; sy = e.clientY; st = Date.now(); on = true; });
    elm.addEventListener('pointerup', e => { if (!on) return; on = false; const dx = e.clientX - sx, dy = e.clientY - sy; if (Date.now() - st > 800) return;
      if (Math.abs(dx) > Math.abs(dy)) { if (dx > th && o.right) o.right(e); else if (dx < -th && o.left) o.left(e); } else { if (dy > th && o.down) o.down(e); else if (dy < -th && o.up) o.up(e); } });
  }
  /* Picker de opções (sheet com lista) */
  function picker(title, options, cur, cls = '') { return new Promise(res => { const A = ouLayer(cls); const body = list([{ items: options.map(o => { const v = typeof o === 'string' ? o : o.value, l = typeof o === 'string' ? o : o.label; return A ? { label: l, right: radio(v === cur), chevron: false, onTap: () => { res(v); sh.close(); } } : { label: l, value: v === cur ? '✓' : '', chevron: false, onTap: () => { res(v); sh.close(); } }; }) }]); const sh = sheet({ title, right: A ? T('Cancelar') : 'Cancelar', body, cls, onClose: () => res(undefined) }); }); }
  /* botao de opcao Nova UI (circulo; ligado = anel azul com ponto). So o Android o usa (escolhas unicas em listas). */
  function radio(on) { return el(`<div class="ou-radio ${on ? 'on' : ''}"></div>`); }
  /* NOTA: res(v) TEM de vir antes de sh.close(). O close() chama o onClose de forma síncrona, que resolve undefined -
     com a ordem inversa a promessa resolvia sempre undefined e TODOS os pickers do telemóvel ficavam sem efeito. */

  /* ---------- <select> SEM a lista nativa (2026-09-18) ----------
     No FiveM a lista de um <select> é desenhada pelo Windows por cima do jogo (caixa branca com barra de scroll, fora
     do aparelho). Tocar num <select> dentro do telemóvel abre agora uma lista própria, ancorada ao campo, e o valor
     escolhido é escrito no <select> com um evento 'change' - as apps (Calendário, Relógio, Zapp…) não mudam nada. */
  (function selectPop() {
    if (typeof document === 'undefined' || window.__selPop) return; window.__selPop = true;
    let pop = null, back = null, watch = null, untrack = null;
    /* Nova UI: a lista entra no registo das camadas, para o Voltar do Android a fechar a ela (e nao a folha por baixo) */
    const shut = () => { clearInterval(watch); MENUS.delete(shut); if (untrack) { const u = untrack; untrack = null; u(); } if (back) { back.remove(); back = null; } if (!pop) return; const p = pop; pop = null; p.classList.remove('in'); setTimeout(() => p.remove(), 160); };
    document.addEventListener('mousedown', e => {
      const s = e.target && e.target.closest && e.target.closest('select');
      if (!s || !s.closest('.device') || s.disabled) return;
      e.preventDefault(); e.stopPropagation(); if (pop) { shut(); return; }
      const scr = document.getElementById('screen') || document.body;
      /* PearPhone Fold: o <select> de uma app abre a lista com o zoom do conteúdo (.az). Retângulos em px reais (UI.vrect) e contas em
         px do ecrã; o tamanho e a posição escrevem-se nos px da própria lista (÷ k) */
      pop = el(`<div class="sel-pop ${appCtx(s) ? 'az' : ''}"><div class="sel-list"></div></div>`);
      const list = pop.querySelector('.sel-list');
      [...s.options].forEach((o, i) => { const it = el('<div class="sel-it"></div>'); it.textContent = o.textContent; if (i === s.selectedIndex) it.classList.add('on');
        it.onclick = ev => { ev.stopPropagation(); s.selectedIndex = i; s.dispatchEvent(new Event('change', { bubbles: true })); s.dispatchEvent(new Event('input', { bubbles: true })); if (window.Sound) Sound.play('tick'); shut(); }; list.appendChild(it); });
      back = el('<div class="sel-back"></div>'); back.onclick = ev => { ev.stopPropagation(); shut(); };
      scr.append(back, pop);
      const sr = vrect(scr), r = vrect(s), z = sr.width > 0 ? sr.width / SWpx() : 1, k = (zoom(pop) / (zoom(scr) || 1)) || 1;
      /* Nova UI: lista mais larga (linhas de 48 px, texto a esquerda) e nunca por cima da barra de navegacao */
      const A = isA(), W = Math.max((A ? 168 : 90) * k, r.width / z), left = Math.min(Math.max(8, (r.left - sr.left) / z), SWpx() - (railOn() ? Rail.width || 0 : 0) - W - 8);
      const IH = A ? 50 : 40, YB = A ? 956 - navOff() - 12 : 940;
      const H = Math.min(A ? 300 : 260, s.options.length * IH + (A ? 16 : 12)), Hs = H * k, below = (r.bottom - sr.top) / z + 6, top = below + Hs > YB ? Math.max(40, (r.top - sr.top) / z - Hs - 6) : below;
      pop.style.cssText = `left:${left / k}px;top:${top / k}px;width:${W / k}px;max-height:${H}px`;
      requestAnimationFrame(() => { if (pop) pop.classList.add('in'); const on = list.querySelector('.on'); if (on) list.scrollTop = on.offsetTop - H / 2 + 20; });
      watch = setInterval(() => { if (!s.isConnected) shut(); }, 400);   /* a folha que tinha o <select> fechou: a lista vai com ela */
      if (A) untrack = track(shut);
      MENUS.add(shut);   /* abrir ou fechar o dobrável fecha-a (UI.dismissMenus) */
    }, true);
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && pop) { e.stopPropagation(); shut(); } }, true);
  })();

  /* indicativo do país (Config.NumberPrefix, ex. '+351'): só visual. phone() acrescenta-o a um número guardado; unphone() tira-o (e os espaços)
     do que o jogador escreveu, para marcar/guardar sempre como o servidor conhece o número (555-1234) */
  const numPrefix = () => { const c = window.System && System.config; return (c && typeof c.numberPrefix === 'string') ? c.numberPrefix : ''; };
  const phone = n => { n = n == null ? '' : String(n); const pre = numPrefix(); return (!pre || !n || n.charAt(0) === '+' || !/\d/.test(n)) ? n : pre + ' ' + n; };
  const unphone = n => { n = n == null ? '' : String(n).trim(); const pre = numPrefix(); if (pre && n.startsWith(pre)) n = n.slice(pre.length); return n.trim(); };
  return { el, esc, g, pad, fmtTime, fmtDate, fmtDur, money, cur, currency, fmtNum, rel, timeAgo, DIAS, DIAS_C, MESES, wdShort, wdLong, wdNarrow, wdShortI, monthName, fmtDayMonth, fmtWdDayMon, initials, avatar, avatarStyle, img, linkify, phone, unphone,
    view, push, pop, replace, setRoot, depth, split, tabbar, list, item, toggle, check, search, seg, chips, empty, emptyFit, spinner, skeleton, alert, prompt, confirm, sheet, actionSheet, ctxMenu, banner, toast, longPress, swipe, dismissAll, dismissTop, dismissMenus, openCount, picker, screen, zoom,
    /* zoom nos dois motores (ver no topo): vrect(el) = retângulo em px reais; zoom(el) = px reais por px de el */
    vrect,
    /* Nova UI (Android): radio(on) · isAndroid() · OU_APPS (ids das apps do sistema que levam o desenho Nova UI)
       track(fn): regista a funcao de fecho de uma camada propria (menus de outros modulos) no mesmo conjunto das folhas e
       dialogos, para fechar com UI.dismissTop() (Voltar do Android) e UI.dismissAll(); devolve a funcao que a retira */
    radio, isAndroid: isA, OU_APPS, track,
    /* dobráveis: isFold() (um dos dobráveis, fechado ou aberto) · isSplit() (aberto: lista | detalhe) · split(win, { icon, title,
       sub, row, first }) (ver acima) · splitResel(win) volta a marcar a linha aberta depois de a lista ser repintada ·
       splitMark(win, rótulo | linha) marca a linha com esse rótulo em português, ou essa linha (ou nenhuma), quando a página foi
       aberta por fora da lista
       NOVA Fold8 aberto: os separadores do UI.tabbar ficam numa barra lateral à esquerda sozinhos (classes e variáveis no
       oneui-ui.css, bloco "BARRA LATERAL"); sideTabs() diz se é o caso agora; grelhas responsivas .ugrid no ui.css
       barra direita do PearPhone Fold: railOn() · railSync(win) (refaz já) · railFor(win, spec | null) (camada por cima da app) */
    isFold, isSplit, splitResel, splitMark, railOn, railSync: w => { if (w) { w._railSig = null; railSync(w); } }, railFor, sideTabs: () => railMode() };
})();
