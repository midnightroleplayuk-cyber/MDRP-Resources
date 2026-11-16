/* ============================================================
   PAINEL ADMIN (/phoneadmin) - centro de controlo do telemóvel, 2026-10-03
   Camada fora do telemóvel (js/overlay.js). Desde 11 nov é uma JANELA de vidro por cima do jogo (css/ovkit.css,
   linguagem do Apex Inventory): rail à esquerda dentro da janela, faixa de cabeçalho com o título da secção,
   palco ao centro e barra de guardar em baixo. Desenho a 1920x1080 escalado por zoom (fit), janela de 1660x920.
   A raiz é .pad.ovk: as cores vêm dos tokens --k-* que o OvTheme escreve (Aparência).
   Secções: Visão geral · Telemóvel (definições do AdminSchema) · Apps (ligar/desligar) · Loja · Apps de trabalho
   (construtor com pré-visualização ao vivo) · Webhooks · Registo.
   Regras desta casa (CEF do FiveM):
   · cada secção constrói-se UMA vez (na primeira visita) e depois só se atualiza no sítio; editar um campo nunca
     redesenha o formulário (só a pré-visualização, que é pequena e não anima)
   · só transform/opacity animam, só na entrada/saída; hover muda só a cor; sem backdrop-filter, filter, color-mix, :has
   · textos da interface em português (o I18N traduz o DOM); o que o admin escreveu vai em data-noi18n
   · os pedidos vão a Overlay.rpc('admin.*') (server/admin.lua; a loja e os dados das apps são dos outros módulos)
   ============================================================ */
window.AdminPanel = (() => {
  'use strict';
  /* ---------- utilitários ---------- */
  const T = s => (window.L && L.t) ? L.t(s) : s;
  const TF = (s, ...a) => (window.L && L.tf) ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : ''));
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  function h(html) { const t = document.createElement('template'); t.innerHTML = String(html).trim(); return t.content.firstElementChild; }
  const ic = (n, s) => (window.Icons && Icons.g) ? Icons.g(n, s || 18) : '';
  const clone = o => (o == null ? o : JSON.parse(JSON.stringify(o)));
  const isObj = o => o && typeof o === 'object' && !Array.isArray(o);
  const arr = v => (Array.isArray(v) ? v : (isObj(v) && Object.keys(v).length === 0 ? [] : (isObj(v) ? Object.keys(v).sort((a, b) => a - b).map(k => v[k]) : [])));
  const obj = v => (isObj(v) ? v : {});
  const clamp = (v, a, b) => Math.min(b, Math.max(a, v));
  const debounce = (fn, ms) => { let t = null; return (...a) => { clearTimeout(t); t = setTimeout(() => fn(...a), ms); }; };
  const slugify = s => String(s || '').normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '').slice(0, 24);
  const HEX = /^#[0-9a-fA-F]{6}$/;
  const fmtN = n => { const v = Math.round(Number(n) || 0); return (v < 0 ? '-' : '') + String(Math.abs(v)).replace(/\B(?=(\d{3})+(?!\d))/g, ' '); };
  /* moeda por omissão = Config.Currency (vem no `ready` do telemóvel); a loja pode ter a sua (boot.shop.currency) */
  const defCur = () => Object.assign({}, (window.UI && UI.currency) ? UI.currency() : { symbol: '$', position: 'before' });
  let currency = defCur();
  const money = n => (n == null || isNaN(n)) ? '-' : (currency.position === 'before' ? currency.symbol + fmtN(n) : fmtN(n) + ' ' + currency.symbol);
  const pad2 = n => String(n).padStart(2, '0');
  const fmtDate = ms => { const d = new Date(Number(ms) || 0); return `${pad2(d.getDate())}/${pad2(d.getMonth() + 1)}/${d.getFullYear()} ${pad2(d.getHours())}:${pad2(d.getMinutes())}`; };
  const ago = ms => {
    ms = Number(ms) || 0; if (!ms) return '-';
    const s = Math.max(0, (Date.now() - ms) / 1000);
    if (s < 60) return T('agora');
    if (s < 3600) return TF('há %s min', Math.floor(s / 60));
    if (s < 86400) return TF('há %s h', Math.floor(s / 3600));
    if (s < 86400 * 7) return TF('há %s d', Math.floor(s / 86400));
    return fmtDate(ms).slice(0, 10);
  };
  const empty = v => v === undefined || v === null || v === '';
  /* diferenças entre o guardado e o rascunho (contador da barra de guardar). Listas de objetos com id
     comparam-se por id: mudar a ordem conta como UMA alteração e não uma por linha. */
  function countDiff(a, b) {
    if (a === b) return 0;
    if (empty(a) && empty(b)) return 0;
    if (typeof a === 'number' && typeof b === 'number') return Math.abs(a - b) < 1e-9 ? 0 : 1;
    if (a && b && typeof a === 'object' && typeof b === 'object') {
      const aa = Array.isArray(a), ab = Array.isArray(b);
      if (aa && ab) {
        const key = x => (x && typeof x === 'object') ? (x.id !== undefined ? 'i:' + x.id : (x.key !== undefined ? 'k:' + x.key : (x.item !== undefined ? 't:' + x.item : null))) : null;
        const ka = a.map(key), kb = b.map(key);
        if (a.length && ka.every(k => k) && kb.every(k => k) && new Set(ka).size === ka.length && new Set(kb).size === kb.length) {
          let n = 0; const mb = new Map(b.map((x, i) => [kb[i], x]));
          ka.forEach((k, i) => { n += mb.has(k) ? countDiff(a[i], mb.get(k)) : 1; });
          kb.forEach(k => { if (!ka.includes(k)) n += 1; });
          const sa = ka.filter(k => kb.includes(k)), sb = kb.filter(k => ka.includes(k));
          if (sa.join('|') !== sb.join('|')) n += 1;
          return n;
        }
        let n = a.length !== b.length ? 1 : 0;
        for (let i = 0; i < Math.min(a.length, b.length); i++) n += countDiff(a[i], b[i]);
        return n;
      }
      if (aa !== ab) return (aa ? a.length : Object.keys(a).length) || (ab ? b.length : Object.keys(b).length) ? 1 : 0;
      let n = 0; new Set([...Object.keys(a), ...Object.keys(b)]).forEach(k => { n += countDiff(a[k], b[k]); });
      return n;
    }
    return 1;
  }

  /* ---------- glifos das apps de trabalho (os do js/apps/capps.js, ou um conjunto próprio quando falta) ---------- */
  const FALLBACK_GLYPHS = ['shield', 'flag', 'briefcase', 'wrench', 'car', 'phone', 'calendar', 'newspaper', 'users', 'person', 'clipboard', 'receipt', 'bolt', 'flame', 'heart', 'star',
    'home', 'pin', 'map', 'bag2', 'cart', 'card', 'bank', 'dollar', 'book', 'chat', 'mail', 'bell', 'clock', 'gauge', 'fuel', 'tag', 'key', 'lock', 'globe', 'music', 'camera', 'tv',
    'lifebuoy', 'info', 'checkCircle', 'activity', 'layers', 'garage', 'hourglass', 'sparkles', 'gamepad', 'headphones', 'bulb', 'drop', 'plug', 'speaker', 'eye', 'hand', 'send', 'grid', 'list', 'chart', 'compass', 'ban', 'storage', 'film'];
  const capps = () => (window.CApps && CApps.glyphs && typeof CApps.glyphs === 'object' && Object.keys(CApps.glyphs).length) ? CApps : null;
  const glyphNames = () => { const c = capps(); return c ? Object.keys(c.glyphs) : FALLBACK_GLYPHS.filter(n => window.Icons && Icons.has && Icons.has(n)); };
  function glyph(name, size) {
    const c = capps();
    if (c && typeof c.glyphSvg === 'function' && c.glyphs[name]) { try { const s = c.glyphSvg(name, size); if (s) return s; } catch (e) { /* cai para o conjunto do telemóvel */ } }
    if (window.Icons && Icons.has && Icons.has(name)) return Icons.g(name, size);
    if (c && typeof c.glyphSvg === 'function') { try { const s = c.glyphSvg(name, size); if (s) return s; } catch (e) { /* idem */ } }
    return ic('grid', size);
  }
  /* ícone de uma app de trabalho: o mesmo desenho do telemóvel (gradiente bg → bg2 + glifo, ou imagem) */
  function cappIconHTML(def, size) {
    const i = obj(def && def.icon), bg = HEX.test(i.bg) ? i.bg : '#1F5EFF', bg2 = HEX.test(i.bg2) ? i.bg2 : bg, fg = HEX.test(i.fg) ? i.fg : '#FFFFFF';
    const img = typeof i.image === 'string' && /^(https|nui):\/\//.test(i.image) ? i.image : '';
    return `<span class="pad-capic" style="width:${size}px;height:${size}px;border-radius:${Math.round(size * 0.24)}px;background:${img ? '#0F1218' : `linear-gradient(160deg,${bg},${bg2})`};color:${fg}">${img ? `<img src="${esc(img)}" alt="">` : glyph(i.glyph || 'grid', Math.round(size * 0.54))}</span>`;
  }
  function paintCappIcon(el, def) {
    const i = obj(def && def.icon), bg = HEX.test(i.bg) ? i.bg : '#1F5EFF', bg2 = HEX.test(i.bg2) ? i.bg2 : bg, fg = HEX.test(i.fg) ? i.fg : '#FFFFFF';
    const img = typeof i.image === 'string' && /^(https|nui):\/\//.test(i.image) ? i.image : '';
    const size = parseInt(el.style.width, 10) || 48;
    el.style.background = img ? '#0F1218' : `linear-gradient(160deg,${bg},${bg2})`; el.style.color = fg;
    const key = img ? 'img:' + img : 'g:' + (i.glyph || 'grid');
    if (el.dataset.k !== key) { el.dataset.k = key; el.innerHTML = img ? `<img src="${esc(img)}" alt="">` : glyph(i.glyph || 'grid', Math.round(size * 0.54)); }
  }
  /* ícone REAL de uma app do telemóvel (o mesmo do ecrã principal: Icons.tileUrl / Icons.tile) */
  function appTileHTML(id, size) {
    const st = `width:${size}px;height:${size}px;border-radius:${Math.round(size * 0.235)}px`;
    try {
      if (window.Icons && Icons.tileUrl) { const u = Icons.tileUrl(id); if (u) return `<span class="pad-tile" style="${st};background-image:${u}"></span>`; }
      if (window.Icons && Icons.tile) return `<span class="pad-tile" style="${st}">${Icons.tile(id)}</span>`;
    } catch (e) { /* cai para as iniciais */ }
    const n = (window.App && App.name) ? App.name(id) : id;
    return `<span class="pad-tile pad-tile-txt" style="${st}" data-noi18n>${esc(String(n).slice(0, 2))}</span>`;
  }

  /* ---------- estado ---------- */
  let root = null, zoomBox = null, railNav = null, crumbEl = null, searchIn = null, viewsEl = null, saveBar = null, toastsEl = null, layerEl = null;
  let boot = null, cur = 'overview', opening = false, closeT = null, busy = false;
  const views = {}, built = {};
  const docs = {};   /* id -> { label, saved, draft, count(), save(), discard() } */
  const SECTIONS = [
    { id: 'overview', label: 'Visão geral', icon: 'activity', group: 'Painel', live: true },
    { id: 'phone', label: 'Telemóvel', icon: 'sliders', group: 'Configuração', doc: 'settings' },
    { id: 'apps', label: 'Apps', icon: 'grid', group: 'Configuração', doc: 'settings' },
    { id: 'shop', label: 'Loja', icon: 'bag2', group: 'Configuração', doc: 'shop' },
    { id: 'capps', label: 'Apps de trabalho', icon: 'briefcase', group: 'Configuração', doc: 'capp' },
    { id: 'theme', label: 'Aparência', icon: 'drop', group: 'Configuração', doc: 'theme' },
    { id: 'webhooks', label: 'Webhooks', icon: 'link', group: 'Sistema', doc: 'webhooks' },
    { id: 'log', label: 'Registo', icon: 'list', group: 'Sistema', live: true },
  ];
  const SEC = {};   /* id -> { build(view), show(), filter(q), crumbs(), refresh() } (preenchido mais abaixo) */

  /* ============================================================
     CONTROLOS (cada um tem .sync() para voltar a ler o valor sem se reconstruir)
     ============================================================ */
  function sw(get, set, o = {}) {
    const b = h(`<button type="button" class="pad-sw ovk-sw" role="switch"><i></i></button>`);
    const sync = () => { const v = !!get(); b.classList.toggle('on', v); b.setAttribute('aria-checked', v ? 'true' : 'false'); };
    b.onclick = e => { e.stopPropagation(); if (b.disabled) return; set(!get()); sync(); };
    if (o.disabled) b.disabled = true;
    b.sync = sync; sync(); return b;
  }

  const decOf = step => { const s = String(step || 1); return s.includes('.') ? s.split('.')[1].length : 0; };
  /* número: campo exato + -/+ + barra (opcional). Setas = passo, Shift = 10 passos. Fora dos limites o campo fica a
     vermelho e só se corrige ao sair dele (nunca muda sozinho enquanto se escreve). */
  function numCtl(o) {
    const get = o.get, set = o.set;
    const step = o.step || 1, dec = o.dec != null ? o.dec : decOf(step), min = o.min != null ? o.min : -1e9, max = o.max != null ? o.max : 1e9;
    const hasSl = o.slider !== false && o.min != null && o.max != null;
    const w = h(`<div class="pad-num${hasSl ? ' has-sl' : ''}${o.compact ? ' compact' : ''}">${hasSl ? '<div class="pad-sl" tabindex="0"><div class="pad-sl-tr"><div class="pad-sl-fill"></div></div><div class="pad-sl-kn"></div></div>' : ''}<div class="pad-step"><button type="button" class="pad-step-b" data-d="-1" tabindex="-1">${ic('minus', 14)}</button><input class="pad-step-in" spellcheck="false" inputmode="decimal"${o.placeholder ? ` placeholder="${esc(o.placeholder)}"` : ''}>${o.unit ? `<span class="pad-unit">${esc(o.unit)}</span>` : ''}<button type="button" class="pad-step-b" data-d="1" tabindex="-1">${ic('plus', 14)}</button></div></div>`);
    const inp = w.querySelector('input'), sl = w.querySelector('.pad-sl');
    const fmt = v => (v == null || v === '' || isNaN(v)) ? '' : Number(v).toFixed(dec);
    const round = v => Number((Math.round(v / step) * step).toFixed(Math.max(dec, 0)));
    const val = () => { const v = get(); return (v == null || v === '' || isNaN(v)) ? null : Number(v); };
    const put = v => { v = clamp(round(v), min, max); set(v); sync(); };
    const paintSl = () => { if (!sl) return; const v = val(); const p = v == null ? 0 : clamp((v - min) / (max - min), 0, 1) * 100; sl.querySelector('.pad-sl-fill').style.transform = `scaleX(${p / 100})`; sl.querySelector('.pad-sl-kn').style.left = p + '%'; };
    const sync = () => { if (document.activeElement !== inp) inp.value = fmt(val()); inp.classList.remove('bad'); paintSl(); };
    inp.addEventListener('input', () => {
      const raw = inp.value.trim().replace(',', '.');
      if (raw === '' && o.allowEmpty) { set(null); inp.classList.remove('bad'); paintSl(); return; }
      const v = Number(raw);
      if (raw === '' || isNaN(v) || v < min || v > max) { inp.classList.add('bad'); return; }
      inp.classList.remove('bad'); set(v); paintSl();
    });
    inp.addEventListener('blur', () => {
      const raw = inp.value.trim().replace(',', '.');
      if (raw === '' && o.allowEmpty) { set(null); sync(); return; }
      const v = Number(raw);
      if (raw === '' || isNaN(v)) { sync(); return; }
      put(v);
    });
    inp.addEventListener('keydown', e => {
      if (e.key === 'ArrowUp' || e.key === 'ArrowDown') { e.preventDefault(); const base = val() != null ? val() : (o.min != null ? o.min : 0); put(base + (e.key === 'ArrowUp' ? 1 : -1) * step * (e.shiftKey ? 10 : 1)); inp.value = fmt(val()); }
      else if (e.key === 'Enter') inp.blur();
    });
    w.querySelectorAll('.pad-step-b').forEach(b => b.addEventListener('click', e => { e.stopPropagation(); const base = val() != null ? val() : (o.min != null ? o.min : 0); put(base + Number(b.dataset.d) * step * (e.shiftKey ? 10 : 1)); inp.value = fmt(val()); }));
    if (sl) {
      const fromX = x => { const r = sl.querySelector('.pad-sl-tr').getBoundingClientRect(); const z = r.width ? (x - r.left) / r.width : 0; return min + clamp(z, 0, 1) * (max - min); };
      sl.addEventListener('pointerdown', e => {
        e.preventDefault(); sl.focus(); sl.setPointerCapture(e.pointerId); sl.classList.add('drag'); put(fromX(e.clientX)); inp.value = fmt(val());
        const mv = ev => { put(fromX(ev.clientX)); inp.value = fmt(val()); };
        const up = () => { sl.classList.remove('drag'); sl.removeEventListener('pointermove', mv); sl.removeEventListener('pointerup', up); sl.removeEventListener('pointercancel', up); };
        sl.addEventListener('pointermove', mv); sl.addEventListener('pointerup', up); sl.addEventListener('pointercancel', up);
      });
      sl.addEventListener('keydown', e => {
        const d = (e.key === 'ArrowRight' || e.key === 'ArrowUp') ? 1 : (e.key === 'ArrowLeft' || e.key === 'ArrowDown') ? -1 : (e.key === 'PageUp' ? 10 : e.key === 'PageDown' ? -10 : 0);
        if (!d) return; e.preventDefault(); const base = val() != null ? val() : min; put(base + d * step * (e.shiftKey ? 10 : 1)); inp.value = fmt(val());
      });
    }
    w.sync = sync; sync(); return w;
  }

  function seg(opts, get, set, o = {}) {
    const w = h(`<div class="pad-seg ovk-seg${o.small ? ' sm' : ''}"${o.noi18n ? ' data-noi18n' : ''}></div>`);
    const btns = opts.map(op => { const b = h(`<button type="button">${op.icon ? ic(op.icon, 14) : ''}<span></span></button>`); b.querySelector('span').textContent = op.l; b.onclick = e => { e.stopPropagation(); set(op.v); sync(); }; w.appendChild(b); return b; });
    const sync = () => { const v = get(); btns.forEach((b, i) => b.classList.toggle('on', opts[i].v === v)); };
    w.sync = sync; sync(); return w;
  }

  /* lista de escolha (popover próprio: o <select> nativo abre fora do sítio no CEF) */
  function dd(opts, get, set, o = {}) {
    const b = h(`<button type="button" class="pad-dd${o.small ? ' sm' : ''}"><span class="pad-dd-v"${o.noi18n ? ' data-noi18n' : ''}></span>${ic('chevD', 14)}</button>`);
    const lab = b.querySelector('.pad-dd-v');
    const list = () => (typeof opts === 'function' ? opts() : opts);
    const sync = () => { const v = get(); const op = list().find(x => x.v === v); lab.textContent = op ? op.l : (o.placeholder || (v == null ? '' : String(v))); b.classList.toggle('ph', !op); };
    b.onclick = e => {
      e.stopPropagation();
      const v = get();
      menu(b, list().map(op => ({ label: op.l, icon: op.icon, on: op.v === v, sub: op.sub, noi18n: o.noi18n, act: () => { set(op.v); sync(); } })), { width: Math.max(b.offsetWidth, 180) });
    };
    b.sync = sync; sync(); return b;
  }

  /* O texto que o config.lua traz (cargo e saudação do vendedor, nomes das categorias, slogans, legendas de blip)
     está escrito em português e é traduzido no sítio onde se mostra (o I18N traduz o DOM da loja). Um input nunca é
     traduzido pelo motor (é o valor de origem), por isso um admin noutro idioma via aqui o português do config ao
     lado de uma interface toda na língua dele. Agora o campo MOSTRA a tradução do valor quando a há, e guarda o
     valor de origem enquanto o admin não o mudar: ao escrever outra coisa, é essa outra coisa que fica. Campos
     mono (identificadores, modelos, URLs) ficam de fora. */
  const shown = (v, o) => { const s = v == null ? '' : String(v); if (o.mono || o.raw || !s || !window.I18N || !I18N.t) return s; try { return I18N.t(s); } catch (e) { return s; } };
  function txt(get, set, o = {}) {
    const el = o.area ? h(`<textarea class="ovk-in pad-in pad-ta" rows="${o.rows || 3}" spellcheck="false"></textarea>`) : h(`<input class="ovk-in pad-in${o.mono ? ' mono' : ''}" spellcheck="false">`);
    if (o.ph) el.placeholder = o.ph;
    if (o.max) el.maxLength = o.max;
    if (o.disabled) el.disabled = true;
    const sync = () => { if (document.activeElement !== el) { const v = get(); el.value = shown(v, o); } check(); };
    const check = () => { if (o.valid) el.classList.toggle('bad', el.value !== '' && !o.valid(el.value)); };
    el.addEventListener('input', () => {
      let v = el.value;
      if (o.filter) { const f = o.filter(v); if (f !== v) { const p = el.selectionStart; el.value = f; try { el.setSelectionRange(p, p); } catch (e) {} v = f; } }
      /* a tradução mostrada, intacta, continua a ser o valor de origem */
      const src = get(); if (src != null && v === shown(src, o)) v = String(src);
      set(v); check();
    });
    el.addEventListener('keydown', e => { if (e.key === 'Enter' && !o.area) el.blur(); });
    el.sync = sync; sync(); return el;
  }

  const SWATCHES = ['#1F5EFF', '#0B2A8A', '#5B8CFF', '#0EA5E9', '#06B6D4', '#14B8A6', '#10B981', '#065F46', '#84CC16', '#FACC15', '#F59E0B', '#EA580C',
    '#E5484D', '#8E1A1F', '#EC4899', '#A855F7', '#6D28D9', '#475569', '#334155', '#0F172A', '#111111', '#FFFFFF', '#E2E8F0', '#8A8F98'];
  /* ---------- seletor de cor próprio (o <input type=color> não abre no CEF do FiveM) ----------
     quadrado de saturação/brilho + barra de matiz, arrastados com o ponteiro (frações do retângulo: o zoom da janela não conta) */
  const rgbOfHex = x => { const n = parseInt(String(x).slice(1), 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
  const hexOfRgb = a => '#' + a.map(v => Math.round(clamp(v, 0, 255)).toString(16).padStart(2, '0')).join('').toUpperCase();
  function hsvOf(hex) {
    const [r, g, b] = rgbOfHex(hex).map(v => v / 255), mx = Math.max(r, g, b), mn = Math.min(r, g, b), d = mx - mn;
    let hh = 0;
    if (d) { hh = mx === r ? ((g - b) / d) % 6 : mx === g ? (b - r) / d + 2 : (r - g) / d + 4; hh *= 60; if (hh < 0) hh += 360; }
    return [hh, mx ? d / mx : 0, mx];
  }
  function hexOfHsv(hh, s, v) {
    const c = v * s, x = c * (1 - Math.abs(((hh / 60) % 2) - 1)), m = v - c;
    const p = hh < 60 ? [c, x, 0] : hh < 120 ? [x, c, 0] : hh < 180 ? [0, c, x] : hh < 240 ? [0, x, c] : hh < 300 ? [x, 0, c] : [c, 0, x];
    return hexOfRgb(p.map(q => (q + m) * 255));
  }
  function picker(get, set, fallback) {
    const w = h(`<div class="pad-cp"><div class="pad-cp-sv"><i class="pad-cp-k"></i></div><div class="pad-cp-hue"><i class="pad-cp-k"></i></div><div class="pad-cp-f"><span class="pad-cp-now"></span><b class="ovk-mono" data-noi18n></b></div></div>`);
    const sv = w.querySelector('.pad-cp-sv'), hue = w.querySelector('.pad-cp-hue'), svK = sv.firstChild, hueK = hue.firstChild, now = w.querySelector('.pad-cp-now'), lab = w.querySelector('.pad-cp-f b');
    let hsv = hsvOf(HEX.test(get()) ? get() : (fallback || '#1F5EFF'));
    const paint = () => {
      sv.style.background = `linear-gradient(0deg,#000,rgba(0,0,0,0)),linear-gradient(90deg,#fff,rgba(255,255,255,0)),hsl(${Math.round(hsv[0])},100%,50%)`;
      svK.style.left = (hsv[1] * 100) + '%'; svK.style.top = ((1 - hsv[2]) * 100) + '%';
      hueK.style.left = (hsv[0] / 360 * 100) + '%';
      const x = hexOfHsv(hsv[0], hsv[1], hsv[2]); now.style.background = x; lab.textContent = x;
    };
    const drag = (el, fn) => el.addEventListener('pointerdown', e => {
      e.preventDefault(); e.stopPropagation();
      try { el.setPointerCapture(e.pointerId); } catch (x) {}
      const at = ev => { const r = el.getBoundingClientRect(); fn(r.width ? clamp((ev.clientX - r.left) / r.width, 0, 1) : 0, r.height ? clamp((ev.clientY - r.top) / r.height, 0, 1) : 0); paint(); set(hexOfHsv(hsv[0], hsv[1], hsv[2])); };
      at(e);
      const up = () => { el.removeEventListener('pointermove', at); el.removeEventListener('pointerup', up); el.removeEventListener('pointercancel', up); };
      el.addEventListener('pointermove', at); el.addEventListener('pointerup', up); el.addEventListener('pointercancel', up);
    });
    drag(sv, (fx, fy) => { hsv[1] = fx; hsv[2] = 1 - fy; });
    drag(hue, fx => { hsv[0] = Math.min(359.9, fx * 360); });
    w.sync = () => { if (HEX.test(get())) hsv = hsvOf(get()); paint(); };
    paint();
    return w;
  }
  /* cor: amostra + campo hex; a amostra abre o seletor (quadrado + matiz) e a grelha de cores.
     o.ph = cor mostrada quando o valor está vazio (a de origem); o.tones = tons rápidos sempre à vista por baixo */
  function colorCtl(get, set, o = {}) {
    const w = h(`<div class="pad-color${o.compact ? ' compact' : ''}${o.tones ? ' wide' : ''}"><div class="pad-color-r"><button type="button" class="pad-color-chip" title="Escolher cor"><i></i></button><input class="ovk-in pad-in mono pad-hex" maxlength="7" spellcheck="false"></div></div>`);
    const chip = w.querySelector('.pad-color-chip'), dot = chip.querySelector('i'), inp = w.querySelector('input');
    if (o.ph) inp.placeholder = o.ph;
    let tones = null;
    const paintTones = () => { if (tones) [...tones.children].forEach(b => b.classList.toggle('on', b.dataset.c === get())); };
    /* o.valid(hex): uma cor bem escrita mas que não serve (fundo claro demais) também fica a vermelho */
    const bad = v => !!v && !!o.valid && !o.valid(v);
    const sync = () => { const v = get(); dot.style.background = HEX.test(v) ? v : (o.ph || 'transparent'); w.classList.toggle('ph', !HEX.test(v)); if (document.activeElement !== inp) inp.value = v || ''; inp.classList.toggle('bad', bad(v)); paintTones(); };
    const put = v => { set(v); sync(); };
    inp.addEventListener('input', () => { let v = inp.value.trim(); if (v && v[0] !== '#') v = '#' + v; if (HEX.test(v)) { v = v.toUpperCase(); inp.classList.toggle('bad', bad(v)); set(v); dot.style.background = v; paintTones(); } else if (v === '' && o.allowEmpty) { inp.classList.remove('bad'); set(''); dot.style.background = o.ph || 'transparent'; paintTones(); } else inp.classList.add('bad'); });
    inp.addEventListener('blur', sync);
    inp.addEventListener('keydown', e => { if (e.key === 'Enter') inp.blur(); });
    chip.onclick = e => {
      e.stopPropagation();
      const box = h('<div class="pad-cpbox"></div>');
      const pk = picker(get, x => { inp.classList.toggle('bad', bad(x)); set(x); dot.style.background = x; if (document.activeElement !== inp) inp.value = x; paintTones(); }, o.ph);
      box.appendChild(pk);
      if (!o.tones) {
        const g = h(`<div class="pad-swg"></div>`);
        (o.swatches || SWATCHES).forEach(c => { const s = h(`<button type="button" class="pad-swatch${c === get() ? ' on' : ''}" title="${c}"><i style="background:${c}"></i></button>`); s.onclick = () => { put(c); closePop(); }; g.appendChild(s); });
        box.appendChild(g);
      }
      pop(chip, box, { cls: 'pad-pop-sw' });
    };
    if (o.tones) {
      tones = h('<div class="pad-tones"></div>');
      o.tones.forEach(c => { const b = h(`<button type="button" class="pad-tone" title="${c}" data-c="${c}"><i style="background:${c}"></i></button>`); b.onclick = e => { e.stopPropagation(); put(c); }; tones.appendChild(b); });
      w.appendChild(tones);
    }
    w.sync = sync; sync(); return w;
  }

  /* botão de glifo + grelha com pesquisa */
  function glyphCtl(get, set, o = {}) {
    const b = h(`<button type="button" class="pad-gbtn${o.small ? ' sm' : ''}"><span class="pad-gbtn-i"></span>${o.small ? '' : '<span class="pad-gbtn-l" data-noi18n></span>'}${ic('chevD', 13)}</button>`);
    const sync = () => { const v = get() || 'grid'; b.querySelector('.pad-gbtn-i').innerHTML = glyph(v, o.small ? 16 : 18); const l = b.querySelector('.pad-gbtn-l'); if (l) l.textContent = v; };
    b.onclick = e => {
      e.stopPropagation();
      const box = h(`<div class="pad-gpick"><div class="pad-gpick-s">${ic('search', 14)}<input class="ovk-in pad-in" placeholder="Pesquisar ícone" spellcheck="false"></div><div class="pad-gpick-g"></div></div>`);
      const grid = box.querySelector('.pad-gpick-g'), q = box.querySelector('input');
      const cells = glyphNames().map(n => { const c = h(`<button type="button" class="pad-gcell${n === get() ? ' on' : ''}" title="${esc(n)}">${glyph(n, 20)}</button>`); c.dataset.n = n.toLowerCase(); c.onclick = () => { set(n); sync(); closePop(); }; grid.appendChild(c); return c; });
      q.addEventListener('input', () => { const s = q.value.trim().toLowerCase(); cells.forEach(c => { c.hidden = !!s && !c.dataset.n.includes(s); }); });
      pop(b, box, { cls: 'pad-pop-g' });
      setTimeout(() => q.focus(), 30);
    };
    b.sync = sync; sync(); return b;
  }

  /* linha de definição: rótulo + (caminho/ajuda) à esquerda, controlo à direita */
  function row(label, ctl, o = {}) {
    const r = h(`<div class="pad-row${o.cls ? ' ' + o.cls : ''}"><div class="pad-row-l"><div class="pad-row-t"><span class="pad-row-lab"></span></div>${o.hint ? '<div class="pad-row-h"></div>' : ''}</div><div class="pad-row-c"></div></div>`);
    r.querySelector('.pad-row-lab').textContent = label;
    if (o.hint) r.querySelector('.pad-row-h').textContent = o.hint;
    if (ctl) r.querySelector('.pad-row-c').appendChild(ctl);
    return r;
  }
  /* campo de formulário: rótulo por cima */
  function fld(label, ctl, o = {}) {
    const f = h(`<div class="pad-fld${o.span ? ' span' + o.span : ''}"><span class="pad-fld-l"></span></div>`);
    f.querySelector('.pad-fld-l').textContent = label;
    if (o.req) f.querySelector('.pad-fld-l').appendChild(h('<em>*</em>'));
    f.appendChild(ctl);
    /* controlos de largura própria (número, cor, interruptor, glifo pequeno) não esticam numa linha */
    if (!ctl.matches('input,textarea,.pad-dd,.pad-gbtn:not(.sm),.pad-seg,.pad-jctl')) f.classList.add('fit');
    if (o.hint) { const x = h('<span class="pad-fld-h"></span>'); x.textContent = o.hint; f.appendChild(x); }
    return f;
  }
  function card(title, o = {}) {
    const c = h(`<section class="pad-card${o.cls ? ' ' + o.cls : ''}">${title != null ? `<header class="pad-card-h">${o.icon ? `<span class="pad-card-ic">${ic(o.icon, 16)}</span>` : ''}<div class="pad-card-tt"><h3></h3>${o.sub ? '<p></p>' : ''}</div><div class="pad-card-act"></div></header>` : ''}<div class="pad-card-b"></div></section>`);
    if (title != null) { c.querySelector('h3').textContent = title; if (o.sub) c.querySelector('p').textContent = o.sub; }
    return { el: c, body: c.querySelector('.pad-card-b'), act: c.querySelector('.pad-card-act') };
  }
  /* botões do ovkit: o normal é o relevo escuro, 'primary' = .pri (escuro tingido com contorno da marca), 'danger' e
     'ghost danger' = .danger, 'link' = texto da marca sem caixa. O tipo antigo fica como pad-k-* (só marca). */
  const BTN_KIND = { primary: 'pri', danger: 'danger', link: 'flat pad-link', ghost: '' };
  function btn(label, o = {}) {
    const kinds = String(o.kind || '').split(/\s+/).filter(Boolean);
    const cls = kinds.includes('danger') ? 'danger' : kinds.map(k => BTN_KIND[k] || '').filter(Boolean).join(' ');
    const b = h(`<button type="button" class="pad-btn ovk-btn${cls ? ' ' + cls : ''}${kinds.map(k => ' pad-k-' + k).join('')}${o.sm || kinds.includes('link') ? ' sm' : ''}${label ? '' : ' icon'}">${o.icon ? ic(o.icon, o.sm ? 14 : 16) : ''}${label ? '<span></span>' : ''}</button>`);
    if (label) b.querySelector('span').textContent = label;
    if (o.title) b.title = o.title;
    if (o.on) b.onclick = e => { e.stopPropagation(); o.on(b, e); };
    return b;
  }
  /* introdução da secção: o título vai na faixa de cabeçalho da janela; aqui fica a frase que explica e as ações */
  function head(title, sub, actions) {
    const el = h(`<div class="pad-head"><div class="pad-head-t">${sub ? '<p></p>' : ''}</div><div class="pad-head-a"></div></div>`);
    el.dataset.t = title;
    if (sub) el.querySelector('p').textContent = sub;
    (actions || []).forEach(a => a && el.querySelector('.pad-head-a').appendChild(a));
    return el;
  }
  /* estado vazio ao centro (ovkit): ícone num círculo, título e frase */
  function emptyBox(text, icon, o = {}) {
    const e = h(`<div class="pad-empty big ovk-empty"${o.hidden ? ' hidden' : ''}><span class="ic">${ic(icon || 'search', 22)}</span><b></b>${o.sub ? '<span class="pad-empty-s"></span>' : ''}</div>`);
    e.querySelector('b').textContent = text; if (o.sub) e.querySelector('.pad-empty-s').textContent = o.sub;
    return e;
  }
  function chip(text, o = {}) {
    const c = h(`<span class="pad-chip${o.kind ? ' ' + o.kind : ''}"${o.noi18n ? ' data-noi18n' : ''}>${o.dot ? `<i style="background:${o.dot}"></i>` : ''}<b></b></span>`);
    c.querySelector('b').textContent = text; return c;
  }
  /* separadores sublinhados (constroem-se uma vez; trocar só muda classes) */
  function tabs(list, onPick) {
    const w = h('<div class="pad-tabs" role="tablist"></div>');
    const bs = list.map(t => { const b = h(`<button type="button" role="tab" class="ovk-chip"><span></span><em class="n" hidden></em></button>`); b.querySelector('span').textContent = t.label; b.onclick = () => { pick(t.id); }; w.appendChild(b); return b; });
    let curT = null;
    const pick = id => { curT = id; bs.forEach((b, i) => b.classList.toggle('on', list[i].id === id)); onPick(id); };
    w.pick = pick; w.cur = () => curT;
    w.badge = (id, n) => { const i = list.findIndex(t => t.id === id); if (i < 0) return; const e = bs[i].querySelector('em'); e.hidden = !n; e.textContent = n || ''; };
    return w;
  }

  /* reordenar com a pega (rato) - o item segue o ponteiro e troca de lugar com o vizinho a meio caminho */
  function sortable(list, o) {
    list.addEventListener('pointerdown', e => {
      const hd = e.target.closest(o.handle); if (!hd || !list.contains(hd)) return;
      const item = hd.closest(o.item); if (!item || item.parentElement !== list) return;
      e.preventDefault(); e.stopPropagation();
      const items = () => [...list.children].filter(c => c.matches(o.item));
      const from = items().indexOf(item);
      const k = kOf(list);   /* px do ecrã -> px do CSS (zoom da casca a 1440p) */
      let startY = e.clientY * k;
      try { hd.setPointerCapture(e.pointerId); } catch (x) {}
      item.classList.add('pad-dragging'); list.classList.add('pad-sorting');
      const mv = ev => {
        let dy = ev.clientY * k - startY;
        const its = items(), i = its.indexOf(item), nx = its[i + 1], pv = its[i - 1];
        if (nx && dy > nx.offsetHeight / 2) { const b0 = item.offsetTop; list.insertBefore(nx, item); startY += item.offsetTop - b0; }
        else if (pv && dy < -pv.offsetHeight / 2) { const b0 = item.offsetTop; list.insertBefore(item, pv); startY += item.offsetTop - b0; }
        dy = ev.clientY * k - startY;
        item.style.transform = `translateY(${dy}px)`;
      };
      const up = () => {
        hd.removeEventListener('pointermove', mv); hd.removeEventListener('pointerup', up); hd.removeEventListener('pointercancel', up);
        item.style.transform = ''; item.classList.remove('pad-dragging'); list.classList.remove('pad-sorting');
        const to = items().indexOf(item); if (to !== from && to >= 0) o.onMove(from, to);
      };
      hd.addEventListener('pointermove', mv); hd.addEventListener('pointerup', up); hd.addEventListener('pointercancel', up);
    });
  }
  const moveIn = (a, from, to) => { if (from === to || from < 0 || to < 0 || from >= a.length || to >= a.length) return false; a.splice(to, 0, a.splice(from, 1)[0]); return true; };

  /* editor de lista genérico: linhas com pega, subir/descer e apagar. A linha nova entra sozinha (nada se redesenha).
     o: { get: () => array, row: (item, api) => elemento, make: () => novo, max, addLabel, empty, onChange } */
  function listEd(o) {
    const w = h(`<div class="pad-led"><div class="pad-led-rows"></div><div class="pad-led-foot"></div></div>`);
    const rows = w.querySelector('.pad-led-rows'), foot = w.querySelector('.pad-led-foot');
    const emptyEl = o.empty ? h('<div class="pad-led-empty"></div>') : null;
    if (emptyEl) { emptyEl.textContent = o.empty; rows.before(emptyEl); }
    const idx = r => [...rows.children].indexOf(r);
    const refresh = () => { const a = o.get(); if (emptyEl) emptyEl.hidden = a.length > 0; addB.disabled = o.max != null && a.length >= o.max; [...rows.children].forEach((r, i) => { const u = r.querySelector('.pad-led-up'), d = r.querySelector('.pad-led-dn'); if (u) u.disabled = i === 0; if (d) d.disabled = i === rows.children.length - 1; }); };
    const changed = () => { refresh(); o.onChange && o.onChange(); };
    function mk(item) {
      const r = h(`<div class="pad-led-row">${o.sortable === false ? '' : `<span class="pad-grip" title="Arrastar para reordenar">${ic('moreV', 14)}</span>`}<div class="pad-led-body"></div><div class="pad-led-act">${o.sortable === false ? '' : `<button type="button" class="pad-ib pad-led-up" title="Subir">${ic('chevU', 14)}</button><button type="button" class="pad-ib pad-led-dn" title="Descer">${ic('chevD', 14)}</button>`}<button type="button" class="pad-ib danger pad-led-x" title="Remover">${ic('x', 14)}</button></div></div>`);
      const api = { index: () => idx(r), set: v => { o.get()[idx(r)] = v; changed(); }, changed, el: r };
      r.querySelector('.pad-led-body').appendChild(o.row(item, api));
      if (o.lock && o.lock(item)) { r.classList.add('locked'); r.querySelector('.pad-led-x').hidden = true; }
      r.querySelector('.pad-led-x').onclick = e => { e.stopPropagation(); const a = o.get(); a.splice(idx(r), 1); r.remove(); changed(); };
      const up = r.querySelector('.pad-led-up'), dn = r.querySelector('.pad-led-dn');
      if (up) up.onclick = e => { e.stopPropagation(); const i = idx(r); if (moveIn(o.get(), i, i - 1)) { rows.insertBefore(r, rows.children[i - 1]); changed(); } };
      if (dn) dn.onclick = e => { e.stopPropagation(); const i = idx(r); if (moveIn(o.get(), i, i + 1)) { rows.insertBefore(rows.children[i + 1], r); changed(); } };
      return r;
    }
    const addB = btn(o.addLabel || 'Adicionar', { icon: 'plus', sm: true, kind: 'ghost', on: () => { const a = o.get(); if (o.max != null && a.length >= o.max) return; const it = o.make(); a.push(it); const r = mk(it); rows.appendChild(r); changed(); const f = r.querySelector('input,textarea'); if (f) f.focus(); } });
    foot.appendChild(addB);
    if (o.extraFoot) foot.appendChild(o.extraFoot);
    if (o.sortable !== false) sortable(rows, { handle: '.pad-grip', item: '.pad-led-row', onMove: (a, b) => { moveIn(o.get(), a, b); changed(); } });
    o.get().forEach(it => rows.appendChild(mk(it)));
    refresh();
    w.refresh = refresh;
    return w;
  }

  /* ============================================================
     CAMADAS: popover, menu, diálogo, folha lateral, avisos
     ============================================================ */
  let popEl = null, popAnchor = null;
  function closePop() { if (!popEl) return; const p = popEl; popEl = null; popAnchor = null; p.classList.add('out'); setTimeout(() => p.remove(), 140); }
  function pop(anchor, content, o = {}) {
    closePop();
    const p = h(`<div class="pad-pop${o.cls ? ' ' + o.cls : ''}"></div>`);
    p.appendChild(content);
    if (o.width) p.style.minWidth = o.width + 'px';
    layerEl.appendChild(p);
    const Lr = layerEl.getBoundingClientRect(), k = kOf(layerEl), a = anchor.getBoundingClientRect();
    const W = layerEl.offsetWidth, H = layerEl.offsetHeight;
    const ax = (a.left - Lr.left) * k, ay = (a.top - Lr.top) * k, ab = (a.bottom - Lr.top) * k, ar = (a.right - Lr.left) * k;
    const pw = p.offsetWidth;
    let ph = p.offsetHeight;
    /* por baixo da âncora se couber; senão por cima; senão no lado com mais espaço, com a altura limitada a esse espaço
       (nunca por cima da própria âncora: a janela é mais baixa do que o ecrã inteiro de antes) */
    const below = H - ab - 18, above = ay - 18;
    let x = o.alignRight ? ar - pw : ax, y;
    if (ph <= below) y = ab + 6;
    else if (ph <= above) y = ay - ph - 6;
    else if (below >= above) { p.style.maxHeight = below + 'px'; ph = below; y = ab + 6; }
    else { p.style.maxHeight = above + 'px'; ph = above; y = ay - ph - 6; }
    x = clamp(x, 12, W - pw - 12);
    p.style.left = x + 'px'; p.style.top = y + 'px';
    popEl = p; popAnchor = anchor;
    return p;
  }
  function menu(anchor, items, o = {}) {
    const m = h('<div class="pad-menu"></div>');
    items.forEach(it => {
      if (it.sep) { m.appendChild(h('<div class="pad-menu-sep"></div>')); return; }
      const b = h(`<button type="button" class="pad-menu-i${it.on ? ' on' : ''}${it.danger ? ' danger' : ''}">${it.icon ? `<span class="pad-menu-ic">${it.iconHTML || ic(it.icon, 16)}</span>` : ''}<span class="pad-menu-t"><b${it.noi18n ? ' data-noi18n' : ''}></b>${it.sub ? '<small></small>' : ''}</span>${it.on ? ic('check', 14) : ''}</button>`);
      b.querySelector('b').textContent = it.label; if (it.sub) b.querySelector('small').textContent = it.sub;
      if (it.disabled) b.disabled = true;
      b.onclick = e => { e.stopPropagation(); closePop(); it.act && it.act(); };
      m.appendChild(b);
    });
    return pop(anchor, m, Object.assign({ cls: 'pad-pop-menu' }, o));
  }

  let dlgEl = null, dlgDone = null;
  /* confirmação: Promise<boolean>. o: { title, text, ok, cancel, danger, noi18nText } */
  function confirmBox(o) {
    return new Promise(res => {
      closeDlg(false);
      const d = h(`<div class="pad-dlg-wrap"><div class="pad-dlg" role="dialog"><div class="pad-dlg-ic${o.danger ? ' danger' : ''}">${ic(o.icon || (o.danger ? 'trash' : 'info'), 20)}</div><h3></h3><p${o.noi18nText ? ' data-noi18n' : ''}></p><div class="pad-dlg-a"></div></div></div>`);
      d.querySelector('h3').textContent = o.title;
      d.querySelector('p').textContent = o.text || '';
      const a = d.querySelector('.pad-dlg-a');
      a.appendChild(btn(o.cancel || 'Cancelar', { kind: 'ghost', on: () => closeDlg(false) }));
      const ok = btn(o.ok || 'Confirmar', { kind: o.danger ? 'danger' : 'primary', on: () => closeDlg(true) });
      a.appendChild(ok);
      d.addEventListener('pointerdown', e => { if (e.target === d) closeDlg(false); });
      layerEl.appendChild(d); dlgEl = d; dlgDone = res;
      setTimeout(() => ok.focus(), 40);
    });
  }
  function closeDlg(v) { if (!dlgEl) return; const d = dlgEl, r = dlgDone; dlgEl = null; dlgDone = null; d.classList.add('out'); setTimeout(() => d.remove(), 160); if (r) r(v); }

  let sheetEl = null;
  function sheet(title, content, o = {}) {
    closeSheet();
    const s = h(`<div class="pad-sheet-wrap"><aside class="pad-sheet"><header class="pad-sheet-h"><div class="pad-sheet-tt"><h3${o.noi18n ? ' data-noi18n' : ''}></h3>${o.sub ? '<p data-noi18n></p>' : ''}</div><button type="button" class="pad-ib" title="Fechar">${ic('x', 16)}</button></header><div class="pad-sheet-b"></div><footer class="pad-sheet-f" hidden></footer></aside></div>`);
    s.querySelector('h3').textContent = title; if (o.sub) s.querySelector('p').textContent = o.sub;
    s.querySelector('.pad-sheet-b').appendChild(content);
    if (o.foot) { const f = s.querySelector('.pad-sheet-f'); f.hidden = false; o.foot.forEach(b => f.appendChild(b)); }
    s.querySelector('.pad-sheet-h .pad-ib').onclick = () => closeSheet();
    s.addEventListener('pointerdown', e => { if (e.target === s) closeSheet(); });
    layerEl.appendChild(s); sheetEl = s;
    return s;
  }
  function closeSheet() { if (!sheetEl) return; const s = sheetEl; sheetEl = null; s.classList.add('out'); setTimeout(() => s.remove(), 220); }

  function toast(msg, kind, o = {}) {
    if (!toastsEl) return;
    const t = h(`<div class="pad-toast ${kind || 'ok'}"><span class="pad-toast-ic">${ic(kind === 'err' ? 'xCircle' : kind === 'info' ? 'info' : 'checkCircle', 16)}</span><span class="pad-toast-t"${o.noi18n ? ' data-noi18n' : ''}></span></div>`);
    t.querySelector('.pad-toast-t').textContent = msg;
    toastsEl.appendChild(t);
    while (toastsEl.children.length > 4) toastsEl.firstElementChild.remove();
    setTimeout(() => { t.classList.add('out'); setTimeout(() => t.remove(), 220); }, o.ms || 3200);
  }
  const ERR = {
    forbidden: 'Sem permissão de administrador.', ratelimit: 'Demasiados pedidos. Espera um pouco.', timeout: 'O servidor não respondeu a tempo.', server: 'Erro no servidor. Vê a consola do servidor.',
    db: 'A base de dados não guardou a alteração.', unavailable: 'Esta parte do servidor não está disponível.', unknown: 'Pedido desconhecido no servidor.', nomock: 'Sem resposta (modo de teste).',
    invalid: 'Há um valor inválido.', id: 'O identificador não é válido (2 a 32 letras minúsculas, números ou _).', name: 'A app precisa de um nome.', modules: 'A app precisa de pelo menos um módulo.',
    fields: 'Um formulário precisa de pelo menos um campo.', services: 'As marcações precisam de pelo menos um serviço.', types: 'Os pedidos precisam de pelo menos um tipo.', hours: 'O horário não é válido (a hora de fim tem de ser depois da de início).',
    days: 'Escolhe pelo menos um dia.', webhook: 'Um URL de webhook não é válido (tem de começar por https://).', exists: 'Já existe uma app com este identificador.', limit: 'Chegaste ao limite de apps de trabalho.',
    contact: 'O número de contacto só pode ter algarismos, espaços e + - # *.', missing: 'Já não existe.', queue: 'A fila deste webhook está cheia. Tenta daqui a pouco.', busy: 'Ainda a teletransportar.',
    items: 'Um catálogo precisa de pelo menos um artigo.', price: 'Um artigo do catálogo tem um preço inválido.', preset: 'Um valor rápido passa o valor máximo da fatura.', amount: 'Um valor rápido da faturação não é válido.',
    prefix: 'O prefixo de fora de serviço só pode ter letras minúsculas, números e _ (até 12).', range: 'Um campo tem o mínimo maior do que o máximo.',
    showif: 'Uma condição "Mostrar" aponta para um campo que não existe, que vem depois, ou para um valor que não é uma das opções.',
  };
  const errMsg = r => { const e = r && r.error; const m = ERR[e] || 'Não foi possível concluir.'; return r && r.field && e !== 'exists' ? `${T(m)} (${r.field})` : T(m); };
  /* pedido ao servidor com aviso de erro */
  async function call(name, data, o = {}) {
    let r;
    try { r = await Overlay.rpc(name, data || {}, o.timeout || 15000); } catch (e) { r = { ok: false, error: 'server' }; }
    /* Uma mensagem vinda do servidor ("Valor inválido em categories[6].icon.", "ID repetido: x.") é uma frase da
       interface com um valor lá dentro, não texto do admin: traduz-se aqui pelo motor de padrões (o %s apanha o
       valor) e só depois vai para o toast como texto fixo. Antes ia em data-noi18n e saía sempre em português. */
    if (!r || !r.ok) { if (!o.quiet) toast(r && r.message ? serverMsg(r.message) : errMsg(r), 'err', { noi18n: !!(r && r.message) }); return r || { ok: false }; }
    return r;
  }
  function serverMsg(m) { try { return (window.I18N && I18N.t) ? I18N.t(String(m)) : String(m); } catch (e) { return String(m); } }

  /* ============================================================
     CASCA: rail, barra de topo, vistas, barra de guardar
     ============================================================ */
  const zoomOf = () => parseFloat(zoomBox && zoomBox.style.zoom) || 1;
  /* fator px do ecrã -> px do CSS dentro da casca (o zoom a 1440p) */
  const kOf = el => { const r = el.getBoundingClientRect(); return r.width ? el.offsetWidth / r.width : 1; };
  /* a janela desenha-se a 1920x1080 e escala por zoom para caber no ecrã (1280x720 a 4K); abaixo de 0,78 não encolhe mais:
     a janela é que fica mais estreita (min() no CSS). Centrada por flex (zoom + left:50% descentra no CEF). */
  function fit() {
    if (!zoomBox) return;
    const W = window.innerWidth, H = window.innerHeight;
    const z = Math.max(0.78, Math.min(W / 1920, H / 1080));
    zoomBox.style.zoom = Math.abs(z - 1) < 0.002 ? '' : z.toFixed(3);
    root.classList.toggle('pad-narrow', W / z < 1560);
  }
  function ensure() {
    if (root) return;
    root = h(`<div class="pad ovk no-kb" tabindex="-1" hidden>
      <div class="pad-z">
        <div class="pad-win ovk-win">
          <aside class="pad-rail">
            <div class="pad-brand"><span class="ovk-badge pad-mark">${ic('phone', 20)}</span><div class="pad-brand-t"><b>Apex Phone</b><small>Centro de controlo</small></div></div>
            <nav class="pad-nav"></nav>
            <div class="pad-rail-foot"><span class="pad-av" data-noi18n></span><div class="pad-me"><b data-noi18n></b><small>Administrador</small></div><span class="pad-me-dot" title="Online"></span></div>
          </aside>
          <main class="pad-main">
            <header class="pad-top ovk-head">
              <div class="pad-top-t"><div class="pad-top-tt"><b class="ovk-title pad-title"></b><span class="ovk-live ok pad-live" hidden>Ao vivo</span></div><div class="pad-crumbs"></div></div>
              <label class="pad-search ovk-search">${ic('search', 15)}<input class="ovk-in" spellcheck="false" placeholder="Pesquisar nesta secção"><button type="button" class="pad-search-x" title="Limpar" hidden>${ic('x', 13)}</button></label>
              <div class="pad-top-r"><span class="pad-online"><i></i><b class="ovk-mono" data-noi18n>0</b><span>online</span></span><button type="button" class="pad-x ovk-close" title="Fechar">${ic('x', 16)}<span class="ovk-key">ESC</span></button></div>
            </header>
            <div class="pad-views"><div class="pad-state" hidden><div class="pad-state-t"></div><div class="pad-state-s"></div></div></div>
            <div class="pad-save" role="status">
              <span class="pad-save-dot"></span>
              <div class="pad-save-t"><b></b><small></small></div>
              <div class="pad-save-a"></div>
            </div>
          </main>
          <div class="pad-layer"></div>
          <div class="pad-toasts"></div>
        </div>
      </div>
    </div>`);
    document.body.appendChild(root);
    zoomBox = root.querySelector('.pad-z'); railNav = root.querySelector('.pad-nav'); crumbEl = root.querySelector('.pad-crumbs');
    searchIn = root.querySelector('.pad-search input'); viewsEl = root.querySelector('.pad-views'); saveBar = root.querySelector('.pad-save');
    toastsEl = root.querySelector('.pad-toasts'); layerEl = root.querySelector('.pad-layer');
    /* rail */
    let grp = null;
    SECTIONS.forEach(s => {
      if (s.group !== grp) { grp = s.group; const g = h('<div class="pad-nav-g"><span></span></div>'); g.firstChild.textContent = s.group; railNav.appendChild(g); }
      const b = h(`<button type="button" class="pad-nav-i" data-sec="${s.id}"><span class="pad-nav-ic">${ic(s.icon, 16)}</span><span class="pad-nav-l"></span><em class="pad-nav-n ovk-mono" hidden></em><i class="pad-nav-dot" hidden></i></button>`);
      b.querySelector('.pad-nav-l').textContent = s.label;
      b.onclick = () => go(s.id);
      railNav.appendChild(b);
    });
    /* barra de guardar */
    const sa = saveBar.querySelector('.pad-save-a');
    sa.appendChild(btn('Descartar', { kind: 'ghost', on: () => discardCur() }));
    const sv = btn('Guardar', { kind: 'primary', icon: 'check', on: () => saveCur() }); sv.classList.add('pad-save-go'); sv.appendChild(h('<span class="ovk-key pad-kbd">Ctrl S</span>'));
    sa.appendChild(sv);
    /* topo */
    root.querySelector('.pad-x').onclick = () => requestClose();
    const sx = root.querySelector('.pad-search-x');
    const runQ = debounce(() => { const s = SEC[cur]; if (s && s.filter) s.filter(searchIn.value.trim().toLowerCase()); }, 120);
    searchIn.addEventListener('input', () => { sx.hidden = !searchIn.value; runQ(); });
    sx.onclick = e => { e.preventDefault(); searchIn.value = ''; sx.hidden = true; runQ(); searchIn.focus(); };
    /* teclado: tudo o que nasce aqui dentro fica aqui (o telemóvel por baixo não vê as teclas) */
    ['keydown', 'keyup', 'keypress'].forEach(t => root.addEventListener(t, e => e.stopPropagation()));
    window.addEventListener('keydown', e => {
      if (!isOpen()) return;
      if (e.key === 'Escape') { e.preventDefault(); e.stopImmediatePropagation(); onEsc(); return; }
      if ((e.ctrlKey || e.metaKey) && String(e.key).toLowerCase() === 's') { e.preventDefault(); e.stopImmediatePropagation(); saveCur(); }
    }, true);
    root.addEventListener('pointerdown', e => { if (popEl && !popEl.contains(e.target) && !(popAnchor && popAnchor.contains(e.target))) closePop(); }, true);
    root.addEventListener('wheel', () => { if (popEl) closePop(); }, { passive: true });
    window.addEventListener('resize', fit);
  }
  const isOpen = () => !!(root && root.classList.contains('on'));
  function onEsc() {
    if (popEl) { closePop(); return; }
    if (dlgEl) { closeDlg(false); return; }
    if (sheetEl) { closeSheet(); return; }
    if (SEC.capps && SEC.capps.closeLayer && SEC.capps.closeLayer()) return;   /* modelos, biblioteca de módulos, JSON */
    const a = document.activeElement;
    if (a && root.contains(a) && a.matches('input,textarea')) { a.blur(); return; }
    requestClose();
  }

  /* ---------- documentos (o que tem "por guardar") ---------- */
  const docCount = id => { const d = docs[id]; if (!d) return 0; try { return d.count ? d.count() : countDiff(d.saved, d.draft); } catch (e) { return 0; } };
  const anyDirty = () => Object.keys(docs).some(id => docCount(id) > 0);
  function curDoc() {
    if (cur === 'capps') return (SEC.capps && SEC.capps.editing && SEC.capps.editing()) ? 'capp' : null;
    const s = SECTIONS.find(x => x.id === cur); return s && s.doc && docs[s.doc] ? s.doc : null;
  }
  function touch() {
    if (!root) return;
    const id = curDoc(), n = id ? docCount(id) : 0;
    saveBar.classList.toggle('on', n > 0);
    if (n > 0) {
      const custom = docs[id].text ? docs[id].text(n) : null;
      saveBar.querySelector('b').textContent = custom || (n === 1 ? T('1 alteração por guardar') : TF('%s alterações por guardar', n));
      saveBar.querySelector('small').textContent = docs[id].label;
    }
    root.classList.toggle('pad-has-save', n > 0);
    railNav.querySelectorAll('.pad-nav-i').forEach(b => { const s = SECTIONS.find(x => x.id === b.dataset.sec); b.querySelector('.pad-nav-dot').hidden = !(s && s.doc && docCount(s.doc) > 0); });
  }
  async function saveCur() {
    const id = curDoc(); if (!id || busy || !docCount(id)) return;
    busy = true; saveBar.classList.add('busy');
    const sv = saveBar.querySelector('.pad-save-go span'); const old = sv.textContent; sv.textContent = T('A guardar');
    try { await docs[id].save(); } catch (e) { console.error('[apex_phone] admin save', e); toast('Não foi possível guardar.', 'err'); }
    sv.textContent = old; busy = false; saveBar.classList.remove('busy'); touch();
  }
  function discardCur() { const id = curDoc(); if (!id || busy) return; docs[id].discard(); touch(); toast('Alterações descartadas.', 'info'); }

  /* ---------- navegação ---------- */
  function go(id) {
    if (!SEC[id] || !boot) return;
    closePop();
    if (!built[id]) {
      const v = h(`<section class="pad-view" data-v="${id}"><div class="pad-scroll"><div class="pad-page"></div></div></section>`);
      viewsEl.appendChild(v); views[id] = v;
      try { SEC[id].build(v.querySelector('.pad-page'), v); } catch (e) { console.error('[apex_phone] admin build', id, e); }
      built[id] = true;
    }
    const prev = cur; cur = id;
    Object.keys(views).forEach(k => { views[k].hidden = k !== id; });
    if (prev !== id) { searchIn.value = ''; root.querySelector('.pad-search-x').hidden = true; }
    if (SEC[id].filter) SEC[id].filter(searchIn.value.trim().toLowerCase());
    searchIn.disabled = !SEC[id].filter; searchIn.parentElement.classList.toggle('off', !SEC[id].filter);
    railNav.querySelectorAll('.pad-nav-i').forEach(b => b.classList.toggle('on', b.dataset.sec === id));
    if (SEC[id].show) SEC[id].show();
    crumbs(); touch();
  }
  function crumbs() {
    if (!crumbEl) return;
    crumbEl.textContent = '';
    const s = SECTIONS.find(x => x.id === cur);
    /* faixa de cabeçalho: título da secção + "Ao vivo" nas secções de dados em tempo real */
    const tt = root.querySelector('.pad-title'); if (tt) tt.textContent = s ? s.label : '';
    const lv = root.querySelector('.pad-live'); if (lv) lv.hidden = !(s && s.live);
    const parts = [{ t: 'Centro de controlo' }, { t: s ? s.label : '', act: SEC[cur] && SEC[cur].crumbs ? () => SEC[cur].home && SEC[cur].home() : null }].concat(SEC[cur] && SEC[cur].crumbs ? SEC[cur].crumbs() : []);
    parts.forEach((p, i) => {
      if (i) crumbEl.appendChild(h(`<span class="pad-crumb-sep">${ic('chevR', 12)}</span>`));
      const last = i === parts.length - 1;
      const e = h(`<span class="pad-crumb${last ? ' on' : ''}${p.act && !last ? ' link' : ''}"${p.noi18n ? ' data-noi18n' : ''}></span>`);
      e.textContent = p.t; if (p.act && !last) e.onclick = p.act;
      crumbEl.appendChild(e);
    });
  }
  function navCount(id, n) { const b = railNav && railNav.querySelector(`[data-sec="${id}"] .pad-nav-n`); if (!b) return; b.hidden = !n; b.textContent = n || ''; }

  /* ---------- abrir / fechar ---------- */
  function setState(kind, err) {
    const st = viewsEl.querySelector('.pad-state');
    st.hidden = !kind;
    if (!kind) return;
    st.querySelector('.pad-state-t').textContent = kind === 'load' ? T('A carregar o painel') : T('O painel não abriu');
    const s = st.querySelector('.pad-state-s'); s.textContent = '';
    if (kind === 'err') { s.appendChild(document.createTextNode(errMsg(err))); s.appendChild(h('<br>')); s.appendChild(btn('Tentar outra vez', { kind: 'ghost', icon: 'update', on: () => load() })); }
  }
  function reset() {
    Object.keys(views).forEach(k => { views[k].remove(); delete views[k]; delete built[k]; });
    Object.keys(docs).forEach(k => delete docs[k]);
    Object.keys(SEC).forEach(k => SEC[k].reset && SEC[k].reset());
  }
  async function load() {
    if (opening) return;
    opening = true; reset(); setState('load');
    const r = await call('admin.bootstrap', {}, { quiet: true, timeout: 20000 });
    opening = false;
    if (!r || !r.ok) { setState('err', r); return; }
    ingest(r); setState(null);
    go(SEC[cur] ? cur : 'overview');
  }
  function ingest(r) {
    boot = r;
    boot.schema = obj(r.schema); boot.schema.groups = arr(boot.schema.groups); boot.schema.settings = arr(boot.schema.settings);
    boot.settings = obj(r.settings); boot.capps = arr(r.capps).filter(isObj); boot.categories = arr(r.categories); boot.limits = obj(r.limits);
    boot.webhooks = obj(r.webhooks); boot.stats = obj(r.stats); boot.shop = obj(r.shop); boot.shopDefaults = obj(r.shopDefaults);
    currency = Object.assign(defCur(),obj(boot.shop.currency));
    const me = String(r.me || 'Admin');
    root.querySelector('.pad-me b').textContent = me;
    root.querySelector('.pad-av').textContent = me.split(/\s+/).map(x => x[0] || '').join('').slice(0, 2).toUpperCase();
    /* retrato do admin (headshot do GTA, client/admin.lua 'admin.me.photo'), como no apex_bossmenu; sem retrato ficam as iniciais */
    Overlay.rpc('admin.me.photo').then(p => { const av = root.querySelector('.pad-av'); if (!p || !p.ok || !p.url || !av) return; const im = new Image(); im.alt = ''; im.onload = () => { av.textContent = ''; av.appendChild(im); av.classList.add('ph'); }; im.src = p.url; });
    paintOnline();
    makeSettingsDoc(); makeShopDoc(); makeHooksDoc(); makeThemeDoc();
    navCount('capps', boot.capps.length);
  }
  function paintOnline() { const n = obj(boot && boot.stats).online; root.querySelector('.pad-online b').textContent = n == null ? '-' : fmtN(n); }
  let enterT = null;
  function open() {
    ensure(); clearTimeout(closeT); clearTimeout(enterT);
    root.hidden = false; root.classList.remove('closing');
    const win = root.querySelector('.pad-win');
    win.classList.remove('ovk-leave', 'ovk-enter');
    void root.offsetWidth;
    root.classList.add('on'); win.classList.add('ovk-enter');
    /* a entrada usa transform: scale; tira-se a classe no fim para o texto parado não ficar numa camada desfocada */
    enterT = setTimeout(() => win.classList.remove('ovk-enter'), 380);
    if (window.Overlay) Overlay.open('admin');
    fit();
    try { root.focus({ preventScroll: true }); } catch (e) {}
    load();
  }
  function hide(fromUI) {
    if (!root || root.hidden) return;
    closePop(); closeDlg(false); closeSheet();
    clearTimeout(enterT);
    const win = root.querySelector('.pad-win'); win.classList.remove('ovk-enter'); win.classList.add('ovk-leave');
    root.classList.remove('on'); root.classList.add('closing');
    clearTimeout(closeT);
    clearTimeout(thLiveT); thLiveT = null;
    if (window.OvTheme) OvTheme.restore();   /* cores em pré-visualização que não foram guardadas saem com o painel */
    /* a saída anima ANTES de largar o foco (com o telemóvel guardado, o body esconde-se quando a camada fecha) */
    closeT = setTimeout(() => { root.classList.remove('closing'); win.classList.remove('ovk-leave'); root.hidden = true; if (fromUI && window.Overlay) Overlay.close('admin'); }, 220);
  }
  async function requestClose() {
    if (dlgEl) return;
    if (anyDirty()) {
      const ok = await confirmBox({ title: 'Sair sem guardar?', text: 'Tens alterações por guardar. Se saíres agora, perdes essas alterações.', ok: 'Sair sem guardar', cancel: 'Continuar a editar', danger: true, icon: 'info' });
      if (!ok) return;
    }
    hide(true);
  }

  /* ============================================================
     1. VISÃO GERAL
     ============================================================ */
  const ACTIONS = {
    'settings.save': 'Definições guardadas', 'settings.reset': 'Definições repostas', 'shop.save': 'Loja guardada', 'shop.reset': 'Loja reposta',
    'capps.save': 'App de trabalho guardada', 'capps.remove': 'App de trabalho apagada', 'capps.order': 'Apps de trabalho reordenadas', 'capps.purge': 'Dados de uma app apagados',
    'capps.delete': 'Registo de uma app apagado', 'webhooks.save': 'Webhooks guardados', 'theme.save': 'Cores guardadas',
  };
  const ACCOUNTS = { bank: 'Banco', cash: 'Dinheiro', black_money: 'Dinheiro sujo', crypto: 'Cripto' };
  const shopLabel = id => { const s = arr(boot && boot.shop && boot.shop.shops).find(x => x && x.id === id); return s ? s.label : (id || '-'); };
  SEC.overview = (() => {
    let k = {}, salesBody, topBox, appsBox, logBox;
    function kpi(key, label, icon) {
      const e = h(`<div class="pad-kpi"><div class="pad-kpi-l"><span class="pad-kpi-ic">${ic(icon, 16)}</span><span></span></div><div class="pad-kpi-v ovk-mono" data-noi18n>-</div><div class="pad-kpi-s"></div></div>`);
      e.querySelector('.pad-kpi-l span:last-child').textContent = label;
      k[key] = { v: e.querySelector('.pad-kpi-v'), s: e.querySelector('.pad-kpi-s') };
      return e;
    }
    function update() {
      const s = obj(boot.stats), sh = isObj(s.shop) ? s.shop : null, today = obj(sh && sh.today);
      k.online.v.textContent = s.online == null ? '-' : fmtN(s.online); k.online.s.textContent = T('jogadores no servidor agora');
      k.accounts.v.textContent = s.accounts == null ? '-' : fmtN(s.accounts); k.accounts.s.textContent = T('contas de telemóvel criadas');
      k.today.v.textContent = sh ? money(today.total || 0) : '-'; k.today.s.textContent = sh ? (today.count === 1 ? T('1 venda hoje') : TF('%s vendas hoje', fmtN(today.count || 0))) : T('sem dados da loja');
      k.total.v.textContent = sh ? money(sh.salesTotal || 0) : '-'; k.total.s.textContent = sh ? TF('%s vendas no total', fmtN(sh.salesCount || 0)) : T('sem dados da loja');
      /* vendas recentes */
      salesBody.textContent = '';
      const rec = arr(sh && sh.recent).slice(0, 6);   /* a visão geral cabe na janela sem rolar; o resto está na Loja e no Registo */
      if (!rec.length) salesBody.appendChild(h(`<tr class="pad-tr-empty"><td colspan="6">Ainda não há vendas.</td></tr>`));
      rec.forEach(x => {
        const tr = h(`<tr><td data-noi18n class="strong"></td><td data-noi18n></td><td data-noi18n class="muted"></td><td class="muted"></td><td class="num" data-noi18n></td><td class="muted nowrap"></td></tr>`);
        const c = tr.children; c[0].textContent = x.name || '-'; c[1].textContent = x.label || x.item || '-'; c[2].textContent = shopLabel(x.shop); c[3].textContent = ACCOUNTS[x.account] || x.account || '-';
        c[4].textContent = money(x.price); c[5].textContent = ago(x.at); c[5].title = fmtDate(x.at);
        salesBody.appendChild(tr);
      });
      /* mais vendidos (uma só série: barras na cor de destaque, valor ao lado) */
      topBox.textContent = '';
      const top = arr(sh && sh.top).slice(0, 6), mx = Math.max(1, ...top.map(t => Number(t.total) || 0));
      if (!top.length) topBox.appendChild(h('<div class="pad-empty">Sem vendas para mostrar.</div>'));
      top.forEach(t => {
        const e = h(`<div class="pad-bar" title=""><div class="pad-bar-t"><b data-noi18n></b><span data-noi18n></span></div><div class="pad-bar-tr"><i></i></div><div class="pad-bar-s"></div></div>`);
        e.querySelector('b').textContent = t.label || t.item; e.querySelector('.pad-bar-t span').textContent = money(t.total);
        e.querySelector('i').style.transform = `scaleX(${Math.max(0.02, (Number(t.total) || 0) / mx)})`;
        e.querySelector('.pad-bar-s').textContent = t.count === 1 ? T('1 venda') : TF('%s vendas', fmtN(t.count || 0));
        e.title = `${t.label || t.item}: ${money(t.total)} · ${t.count}`;
        topBox.appendChild(e);
      });
      /* apps de trabalho */
      appsBox.textContent = '';
      const cs = obj(s.capps);
      if (!boot.capps.length) appsBox.appendChild(h('<div class="pad-empty">Ainda não há apps de trabalho.</div>'));
      boot.capps.slice(0, 3).forEach(a => {
        const st = obj(cs[a.id]);
        const e = h(`<button type="button" class="pad-ovapp">${cappIconHTML(a, 34)}<span class="pad-ovapp-t"><b data-noi18n></b><small></small></span><span class="pad-ovapp-n${st.open ? ' hot' : ''}"><b data-noi18n></b><small>em aberto</small></span></button>`);
        e.querySelector('.pad-ovapp-t b').textContent = a.name;
        e.querySelector('.pad-ovapp-t small').textContent = st.last ? TF('%s registos · último %s', fmtN(st.total || 0), ago(st.last)) : (a.enabled === false ? T('Desligada') : T('Sem registos'));
        e.querySelector('.pad-ovapp-n b').textContent = fmtN(st.open || 0);
        e.onclick = () => { go('capps'); SEC.capps.edit(a.id); };
        appsBox.appendChild(e);
      });
      /* alterações */
      logBox.textContent = '';
      const lg = arr(s.log);
      if (!lg.length) logBox.appendChild(h('<div class="pad-empty">Ainda não há alterações registadas.</div>'));
      lg.slice(0, 3).forEach(x => logBox.appendChild(logItem(x)));
    }
    return {
      reset() { k = {}; },
      build(v) {
        v.appendChild(head('Visão geral', 'O telemóvel no servidor, num relance: jogadores, vendas da loja, apps de trabalho e as últimas alterações.', [btn('Atualizar', { kind: 'ghost', icon: 'update', on: b => this.refresh(b) })]));
        const kp = h('<div class="pad-kpis"></div>');
        kp.appendChild(kpi('online', 'Jogadores online', 'users')); kp.appendChild(kpi('accounts', 'Contas de telemóvel', 'phone'));
        kp.appendChild(kpi('today', 'Vendas da loja hoje', 'bag2')); kp.appendChild(kpi('total', 'Receita total da loja', 'chart'));
        v.appendChild(kp);
        const r1 = h('<div class="pad-cols pad-cols-21"></div>');
        const c1 = card('Vendas recentes', { icon: 'receipt', sub: 'As últimas compras nas lojas de telemóveis.' });
        const tb = h(`<div class="pad-tblw"><table class="pad-tbl"><thead><tr><th>${T('Jogador')}</th><th>${T('Produto')}</th><th>${T('Loja')}</th><th>${T('Pagamento')}</th><th class="num">${T('Valor')}</th><th>${T('Quando')}</th></tr></thead><tbody></tbody></table></div>`);
        salesBody = tb.querySelector('tbody'); c1.body.appendChild(tb);
        c1.act.appendChild(btn('Ver a loja', { kind: 'link', sm: true, on: () => { go('shop'); SEC.shop.tab('sales'); } }));
        const c2 = card('Mais vendidos', { icon: 'chart', sub: 'Receita por produto.' });
        topBox = h('<div class="pad-bars"></div>'); c2.body.appendChild(topBox);
        r1.appendChild(c1.el); r1.appendChild(c2.el); v.appendChild(r1);
        const r2 = h('<div class="pad-cols pad-cols-11"></div>');
        const c3 = card('Apps de trabalho', { icon: 'briefcase', sub: 'Pedidos em aberto por app.' });
        appsBox = h('<div class="pad-ovapps"></div>'); c3.body.appendChild(appsBox);
        c3.act.appendChild(btn('Gerir', { kind: 'link', sm: true, on: () => go('capps') }));
        const c4 = card('Alterações recentes', { icon: 'list', sub: 'Quem mudou o quê no painel.' });
        logBox = h('<div class="pad-logs"></div>'); c4.body.appendChild(logBox);
        c4.act.appendChild(btn('Ver tudo', { kind: 'link', sm: true, on: () => go('log') }));
        r2.appendChild(c3.el); r2.appendChild(c4.el); v.appendChild(r2);
        update();
      },
      async refresh(b) {
        if (b) b.disabled = true;
        const r = await call('admin.stats', {});
        if (b) b.disabled = false;
        if (r && r.ok) { boot.stats = obj(r.stats); update(); paintOnline(); toast('Dados atualizados.', 'info'); }
      },
      update,
    };
  })();
  function logItem(x) {
    const e = h(`<div class="pad-logi"><span class="pad-logi-ic">${ic(String(x.action || '').startsWith('shop') ? 'bag2' : String(x.action || '').startsWith('capps') ? 'briefcase' : String(x.action || '').startsWith('webhooks') ? 'link' : String(x.action || '').startsWith('theme') ? 'drop' : 'sliders', 14)}</span><div class="pad-logi-t"><b></b><small data-noi18n></small></div><div class="pad-logi-r"><span data-noi18n></span><small></small></div></div>`);
    const lab = ACTIONS[x.action];
    const b = e.querySelector('b'); b.textContent = lab || x.action || '-'; if (!lab) b.setAttribute('data-noi18n', '');
    e.querySelector('.pad-logi-t small').textContent = x.detail || '';
    e.querySelector('.pad-logi-r span').textContent = x.admin || '-';
    const t = e.querySelector('.pad-logi-r small'); t.textContent = ago(x.at); t.title = fmtDate(x.at);
    return e;
  }

  /* ============================================================
     2. TELEMÓVEL (definições do AdminSchema)
     ============================================================ */
  const sameV = (a, b) => (typeof a === 'number' && typeof b === 'number') ? Math.abs(a - b) < 1e-9 : (empty(a) && empty(b)) || a === b;
  const LANG_NAME = c => (window.L && L.NAMES && L.NAMES[c]) || c;
  const THEME_NAME = { light: 'Claro', dark: 'Escuro', auto: 'Automático' };
  function makeSettingsDoc() {
    const st = obj(boot.settings), vals = obj(st.values);
    const saved = { config: {}, disabled: arr(boot.disabledApps).filter(x => typeof x === 'string').sort() };
    boot.schema.settings.forEach(s => { saved.config[s.path] = vals[s.path]; });
    docs.settings = {
      label: T('Definições do telemóvel e apps'),
      saved, draft: clone(saved),
      count() { let n = 0; Object.keys(this.saved.config).forEach(p => { if (!sameV(this.saved.config[p], this.draft.config[p])) n++; }); const a = new Set(this.saved.disabled), b = new Set(this.draft.disabled); a.forEach(x => { if (!b.has(x)) n++; }); b.forEach(x => { if (!a.has(x)) n++; }); return n; },
      async save() {
        const defs = obj(obj(boot.settings).defaults), cfg = {};
        boot.schema.settings.forEach(s => { const v = this.draft.config[s.path]; if (v !== undefined && v !== null && !sameV(v, defs[s.path])) cfg[s.path] = v; });
        const r = await call('admin.settings.save', { config: cfg, disabledApps: this.draft.disabled.slice() });
        if (r.ok) { ingestSettings(r); toast('Definições guardadas. Já estão a valer para toda a gente.'); }
      },
      discard() { this.draft = clone(this.saved); syncSettingsUI(); },
    };
  }
  function ingestSettings(r) {
    boot.settings = obj(r.settings); boot.disabledApps = arr(r.disabledApps);
    makeSettingsDoc(); syncSettingsUI();
  }
  const settingsSyncers = [];
  function syncSettingsUI() { settingsSyncers.forEach(f => { try { f(); } catch (e) { console.error(e); } }); touch(); }
  const fmtSetting = (s, v) => s.type === 'bool' ? (v ? T('Ligado') : T('Desligado')) : s.path === 'DefaultLanguage' ? LANG_NAME(v) : s.path === 'DefaultTheme' ? T(THEME_NAME[v] || v) : /* RADIO2: */ (s.labels && v != null && s.labels[v]) ? T(s.labels[v]) : (v == null || v === '' ? T('vazio') : String(v));

  SEC.phone = (() => {
    let rows = [], cards = [], none = null;
    return {
      reset() { rows = []; cards = []; settingsSyncers.length = 0; },
      build(v) {
        v.appendChild(head('Telemóvel', 'Definições do telemóvel para todo o servidor. O que mudares aqui passa por cima do config.lua e vale logo para toda a gente.', [
          btn('Repor tudo', { kind: 'ghost danger', icon: 'update', on: async () => {
            const ok = await confirmBox({ title: 'Repor todas as definições?', text: 'Todas as definições e as apps desligadas voltam ao que está no config.lua. Isto não se pode desfazer.', ok: 'Repor tudo', danger: true, icon: 'update' });
            if (!ok) return;
            const r = await call('admin.settings.reset', {});
            if (r.ok) { ingestSettings(r); toast('Definições repostas no config.lua.'); }
          } }),
        ]));
        const legend = h(`<div class="pad-legend"><span><i class="pad-dot mod"></i>Diferente do config.lua</span><span><i class="pad-dot dirty"></i>Por guardar</span></div>`);
        v.appendChild(legend);
        const wrap = h('<div class="pad-masonry"></div>'); v.appendChild(wrap);
        none = emptyBox('Nenhuma definição corresponde à pesquisa.', 'search', { hidden: true }); v.appendChild(none);
        const D = () => docs.settings.draft, S = () => docs.settings.saved, DEF = () => obj(obj(boot.settings).defaults);
        boot.schema.groups.forEach(g => {
          const list = boot.schema.settings.filter(s => s.group === g.id);
          if (!list.length) return;
          const c = card(g.label, { icon: Icons && Icons.has && Icons.has(g.icon) ? g.icon : 'sliders', sub: list.length === 1 ? T('1 definição') : TF('%s definições', list.length) });
          list.forEach(s => {
            const get = () => D().config[s.path];
            let r;
            const mark = () => {
              const d = get(), unsaved = !sameV(d, S().config[s.path]), mod = DEF()[s.path] !== undefined && !sameV(d, DEF()[s.path]);
              r.classList.toggle('dirty', unsaved); r.classList.toggle('mod', mod);
              rb.style.visibility = mod ? 'visible' : 'hidden'; rb.title = TF('Repor o valor do config.lua (%s)', fmtSetting(s, DEF()[s.path]));
            };
            const set = val => { D().config[s.path] = val; mark(); touch(); };
            let ctl;
            if (s.type === 'bool') ctl = sw(get, set);
            else if (s.type === 'int' || s.type === 'num') ctl = numCtl({ get, set, min: s.min, max: s.max, step: s.step || 1, slider: s.min != null && s.max != null });
            else if (s.type === 'select') {
              const opts = arr(s.options).map(o => ({ v: o, l: s.path === 'DefaultLanguage' ? LANG_NAME(o) : s.path === 'DefaultTheme' ? T(THEME_NAME[o] || o) : /* RADIO2: */ (s.labels && s.labels[o]) ? T(s.labels[o]) : String(o), sub: s.path === 'DefaultLanguage' ? o : '' }));
              ctl = opts.length <= 3 ? seg(opts, get, set) : dd(opts, get, set, { noi18n: s.path === 'DefaultLanguage' });
            } else ctl = txt(get, set, { max: s.max || 64, mono: true });
            const rb = h(`<button type="button" class="pad-ib pad-rst" style="visibility:hidden">${ic('update', 14)}</button>`);
            rb.onclick = e => { e.stopPropagation(); D().config[s.path] = clone(DEF()[s.path]); ctl.sync && ctl.sync(); mark(); touch(); };
            const cc = h('<div class="pad-ctlw"></div>'); cc.appendChild(ctl); cc.appendChild(rb);
            r = row(s.label, cc, { cls: 'pad-srow' });
            const t = r.querySelector('.pad-row-t');
            t.appendChild(h('<i class="pad-dot mod" title="Diferente do config.lua"></i>'));
            if (s.restart) t.appendChild(chip('Para quem entrar depois', { kind: 'warn' }));
            const p = h('<code class="pad-path"></code>'); p.textContent = 'Config.' + s.path; r.querySelector('.pad-row-l').appendChild(p);
            r.dataset.q = (s.label + ' ' + s.path).toLowerCase();
            c.body.appendChild(r); rows.push({ r, c: c.el });
            settingsSyncers.push(() => { ctl.sync && ctl.sync(); mark(); });
            mark();
          });
          wrap.appendChild(c.el); cards.push(c.el);
        });
      },
      filter(q) {
        rows.forEach(x => { x.r.hidden = !!q && !(x.r.dataset.q.includes(q) || x.r.textContent.toLowerCase().includes(q)); });
        cards.forEach(c => { c.hidden = ![...c.querySelectorAll('.pad-srow')].some(r => !r.hidden); });
        if (none) none.hidden = !q || cards.some(c => !c.hidden);
      },
    };
  })();

  /* ============================================================
     3. APPS (ligar/desligar as apps do telemóvel para toda a gente)
     ============================================================ */
  SEC.apps = (() => {
    let cardsEl = [], mode = 'all', q = '', sum = null, none = null;
    const D = () => docs.settings.draft;
    const isOn = id => !D().disabled.includes(id);
    function apply() {
      cardsEl.forEach(x => {
        const on = isOn(x.id);
        x.el.classList.toggle('off', !on);
        x.el.hidden = (mode === 'on' && !on) || (mode === 'off' && on) || (!!q && !x.el.textContent.toLowerCase().includes(q) && !x.id.includes(q));
      });
      const off = cardsEl.filter(x => !isOn(x.id)).length;
      if (sum) sum.textContent = `${cardsEl.length === 1 ? T('1 app') : TF('%s apps', cardsEl.length)} · ${off === 1 ? T('1 desligada') : TF('%s desligadas', off)}`;
      if (none) none.hidden = cardsEl.some(x => !x.el.hidden);
    }
    return {
      reset() { cardsEl = []; mode = 'all'; q = ''; },
      build(v) {
        const segm = seg([{ v: 'all', l: 'Todas' }, { v: 'on', l: 'Ligadas' }, { v: 'off', l: 'Desligadas' }], () => mode, x => { mode = x; apply(); }, { small: true });
        v.appendChild(head('Apps', 'Liga e desliga as apps do telemóvel para toda a gente. Uma app desligada sai do ecrã principal, da pesquisa e da AppShop, e não abre.', [segm]));
        sum = h('<div class="pad-sum"></div>'); v.appendChild(sum);
        const grid = h('<div class="pad-appgrid"></div>'); v.appendChild(grid);
        none = emptyBox('Nenhuma app corresponde.', 'grid', { hidden: true }); v.appendChild(none);
        const savedOff = new Set(docs.settings.saved.disabled);
        const all = (window.App && App.all) ? App.all() : {};
        const ids = Object.keys(all).filter(id => !/^capp_/.test(id) && all[id] && (!all[id].hidden || savedOff.has(id)));
        ids.sort((a, b) => String(App.name(a)).localeCompare(String(App.name(b)), 'pt'));
        ids.forEach(id => {
          /* só Definições, Telefone e AppShop ficam sempre ligadas (o servidor recusa as mesmas três); as outras apps de origem também se desligam */
          const d = all[id], core = id === 'settings' || id === 'phone' || id === 'store';
          const e = h(`<div class="pad-app ovk-tile${core ? ' core' : ''}"><span class="ovk-corners"></span>${appTileHTML(id, 44)}<div class="pad-app-t"><b></b><small></small></div><div class="pad-app-c"></div></div>`);
          e.querySelector('b').textContent = App.name(id); e.querySelector('small').textContent = d.category || '';
          if (d.external) e.querySelector('b').setAttribute('data-noi18n', '');
          const c = e.querySelector('.pad-app-c');
          if (core) { const l = h(`<span class="pad-lock" title="As apps essenciais não se podem desligar">${ic('lock', 13)}<span>Essencial</span></span>`); c.appendChild(l); }
          else {
            const s = sw(() => isOn(id), on => { const set = new Set(D().disabled); if (on) set.delete(id); else set.add(id); D().disabled = [...set].sort(); apply(); touch(); });
            c.appendChild(s); settingsSyncers.push(() => s.sync());
            e.addEventListener('click', ev => { if (ev.target.closest('.pad-sw')) return; s.click(); });
          }
          grid.appendChild(e); cardsEl.push({ id, el: e });
        });
        settingsSyncers.push(apply);
        apply();
      },
      filter(x) { q = x; apply(); },
    };
  })();

  /* ============================================================
     4. LOJA (o motor é o server/shop.lua; aqui edita-se a loja inteira e guarda-se de uma vez)
     ============================================================ */
  const SHOP_KEYS = ['enabled', 'currency', 'payment', 'blip', 'interaction', 'closeDistance', 'serverDistance', 'camera', 'hidePlayer', 'ped', 'shops', 'categories', 'products'];
  const SPEC_KEYS = [['screen', 'Ecrã'], ['camera', 'Câmara'], ['chip', 'Processador'], ['battery', 'Bateria'], ['audio', 'Áudio']];
  function normShop(src) {
    const s = {};
    SHOP_KEYS.forEach(k => { if (src[k] !== undefined) s[k] = clone(src[k]); });
    s.enabled = s.enabled !== false;
    s.currency = Object.assign(defCur(),obj(s.currency));
    s.payment = obj(s.payment); s.payment.accounts = arr(s.payment.accounts).filter(x => typeof x === 'string');
    s.blip = obj(s.blip); s.interaction = obj(s.interaction); s.camera = obj(s.camera); s.ped = obj(s.ped);
    s.categories = arr(s.categories).filter(isObj);
    s.shops = arr(s.shops).filter(isObj).map(x => { x.coords = Object.assign({ x: 0, y: 0, z: 0, w: 0 }, obj(x.coords)); x.vendor = obj(x.vendor); x.blip = x.blip !== false; return x; });
    s.products = arr(s.products).filter(isObj).map(p => {
      p.enabled = p.enabled !== false; p.features = arr(p.features); p.categories = arr(p.categories); p.specs = obj(p.specs);
      p.variants = arr(p.variants).filter(isObj).map(v => { v.enabled = v.enabled !== false; return v; });
      return p;
    });
    return s;
  }
  function makeShopDoc() {
    const s = normShop(obj(boot.shop));
    docs.shop = {
      label: T('Loja de telemóveis'),
      saved: s, draft: clone(s),
      async save() {
        if (!boot.shopReady) { toast(ERR.unavailable, 'err'); return; }
        const sent = clone(this.draft);
        const r = await call('admin.shop.save', { shop: sent });
        if (!r.ok) return;
        boot.shop = obj(r.shop || sent); currency = Object.assign(defCur(),obj(boot.shop.currency));
        makeShopDoc();
        /* o servidor limpou alguma coisa? então mostra-se o que ficou guardado */
        if (countDiff(docs.shop.saved, normShop(sent))) SEC.shop.rebuild();
        toast('Loja guardada. Vendedores e preços atualizados para toda a gente.');
      },
      discard() { this.draft = clone(this.saved); SEC.shop.rebuild(); },
    };
  }
  const uniqId = (base, taken) => { let i = 1, id = base; while (taken.includes(id)) id = base + '_' + (++i); return id; };

  SEC.shop = (() => {
    let pageEl = null, tabsEl = null, panes = {}, curTab = 'products', prodCatSync = [], enSw = null;
    const D = () => docs.shop.draft;
    function rebuild() { if (!pageEl) return; pageEl.textContent = ''; panes = {}; prodCatSync = []; build(pageEl); }
    function build(v) {
      pageEl = v;
      enSw = sw(() => D().enabled, x => { D().enabled = x; enLab.textContent = x ? T('Loja aberta') : T('Loja fechada'); touch(); });
      const enWrap = h('<label class="pad-bigsw"><span></span></label>'); const enLab = enWrap.querySelector('span'); enLab.textContent = D().enabled ? T('Loja aberta') : T('Loja fechada'); enWrap.prepend(enSw);
      v.appendChild(head('Loja', 'Os telemóveis à venda, os vendedores no mapa e o pagamento. O que mudares aqui passa por cima do config.lua.', [
        enWrap,
        btn('Repor loja', { kind: 'ghost danger', icon: 'update', on: async () => {
          const ok = await confirmBox({ title: 'Repor a loja?', text: 'Produtos, preços, lojas e definições voltam ao que está no config.lua. Isto não se pode desfazer.', ok: 'Repor a loja', danger: true, icon: 'update' });
          if (!ok) return;
          const r = await call('admin.shop.reset', {});
          if (r.ok) { boot.shop = obj(r.shop); currency = Object.assign(defCur(),obj(boot.shop.currency)); makeShopDoc(); rebuild(); touch(); toast('Loja reposta no config.lua.'); }
        } }),
      ]));
      if (!boot.shopReady) v.appendChild(h('<div class="pad-banner">O motor da loja não respondeu no servidor. Podes ver tudo, mas as alterações não se podem guardar.</div>'));
      tabsEl = tabs([{ id: 'products', label: 'Produtos' }, { id: 'shops', label: 'Lojas e vendedores' }, { id: 'cats', label: 'Categorias' }, { id: 'settings', label: 'Definições' }, { id: 'sales', label: 'Vendas e ferramentas' }], id => showTab(id));
      v.appendChild(tabsEl);
      const host = h('<div class="pad-panes"></div>'); v.appendChild(host);
      v._host = host;
      tabsEl.badge('products', D().products.length); tabsEl.badge('shops', D().shops.length);
      tabsEl.pick(curTab);
    }
    function showTab(id) {
      curTab = id;
      if (!panes[id]) { const p = h(`<div class="pad-pane" data-p="${id}"></div>`); pageEl._host.appendChild(p); panes[id] = p; PANES[id](p); }
      Object.keys(panes).forEach(k => { panes[k].hidden = k !== id; });
      if (id === 'products') prodCatSync.forEach(f => f());
      if (SEC.shop._q != null) filter(SEC.shop._q);
    }

    /* ---------- produtos ---------- */
    function prodRow(p) {
      const e = h(`<div class="pad-prod"><div class="pad-prod-h"><span class="pad-grip" title="Arrastar para reordenar">${ic('moreV', 14)}</span><span class="pad-prod-sw"></span><div class="pad-prod-t"><b data-noi18n></b><small data-noi18n></small></div><div class="pad-prod-chips" data-noi18n></div><div class="pad-prod-price"></div><div class="pad-prod-en"></div><button type="button" class="pad-ib pad-exp" title="Editar">${ic('chevD', 16)}</button></div><div class="pad-prod-b" hidden></div></div>`);
      const hd = e.querySelector('.pad-prod-h'), body = e.querySelector('.pad-prod-b');
      const paintHead = () => {
        e.querySelector('.pad-prod-t b').textContent = p.name || p.id;
        e.querySelector('.pad-prod-t small').textContent = [p.brand, p.os, p.variants.length === 1 ? T('1 cor') : TF('%s cores', p.variants.length)].filter(Boolean).join(' · ');
        const sws = e.querySelector('.pad-prod-sw'); sws.textContent = '';
        p.variants.slice(0, 4).forEach(v => { const i = h('<i></i>'); i.style.background = HEX.test(v.swatch) ? v.swatch : '#444'; if (v.enabled === false) i.classList.add('off'); sws.appendChild(i); });
        const cs = e.querySelector('.pad-prod-chips'); cs.textContent = '';
        if (p.badge) cs.appendChild(chip(p.badge, { kind: 'acc', noi18n: true }));
        p.categories.slice(0, 3).forEach(c => { const cat = D().categories.find(x => x.id === c); cs.appendChild(chip(cat ? cat.label : c, { noi18n: true })); });
        e.classList.toggle('off', !p.enabled);
      };
      e.querySelector('.pad-prod-price').appendChild(numCtl({ get: () => p.price, set: v => { p.price = v; touch(); }, min: 0, max: 10000000, step: 1, slider: false, compact: true, unit: currency.symbol }));
      e.querySelector('.pad-prod-en').appendChild(sw(() => p.enabled, x => { p.enabled = x; paintHead(); touch(); }));
      const toggle = () => { const open = body.hidden; if (open && !body.firstChild) prodBody(p, body, paintHead); body.hidden = !open; e.classList.toggle('open', open); };
      hd.addEventListener('click', ev => { if (ev.target.closest('.pad-num,.pad-sw,.pad-grip,input,button:not(.pad-exp)')) return; toggle(); });
      paintHead();
      e._p = p;
      return e;
    }
    function prodBody(p, body, paintHead) {
      const g = h('<div class="pad-grid g3"></div>');
      const t = (key, lab, o = {}) => fld(lab, txt(() => p[key], x => { if (x === '' && o.optional) delete p[key]; else p[key] = x; paintHead(); touch(); }, o), o);
      g.appendChild(t('name', 'Nome', { max: 40 })); g.appendChild(t('brand', 'Marca', { max: 24 })); g.appendChild(t('os', 'Sistema', { max: 24 }));
      g.appendChild(t('tagline', 'Slogan', { max: 120, span: 2 })); g.appendChild(t('badge', 'Etiqueta', { max: 14, ph: 'Novo', optional: true, hint: 'Vazio = sem etiqueta.' }));
      g.appendChild(t('usage', 'Como se usa', { max: 200, span: 3, area: true, rows: 2 }));
      body.appendChild(g);
      /* categorias (as da loja, sem "Todos") */
      const cw = h('<div class="pad-sub"><div class="pad-sub-h">Categorias</div><div class="pad-chiptg" data-noi18n></div></div>');
      const cg = cw.querySelector('.pad-chiptg');
      const paintCats = () => {
        cg.textContent = '';
        D().categories.filter(c => c.id !== 'all').forEach(c => {
          const b = h(`<button type="button" class="pad-tgl"><span></span></button>`); b.querySelector('span').textContent = c.label || c.id;
          b.classList.toggle('on', p.categories.includes(c.id));
          b.onclick = () => { const i = p.categories.indexOf(c.id); if (i >= 0) p.categories.splice(i, 1); else p.categories.push(c.id); b.classList.toggle('on', i < 0); paintHead(); touch(); };
          cg.appendChild(b);
        });
      };
      paintCats(); prodCatSync.push(paintCats);
      body.appendChild(cw);
      const two = h('<div class="pad-cols pad-cols-11 tight"></div>');
      /* características */
      const fw = h('<div class="pad-sub"><div class="pad-sub-h">Características</div></div>');
      fw.appendChild(listEd({ get: () => p.features, max: 6, addLabel: 'Adicionar linha', empty: 'Sem características.', make: () => '', onChange: touch,
        row: (it, api) => txt(() => { const i = api.index(); return i >= 0 ? p.features[i] : it; }, x => { p.features[api.index()] = x; touch(); }, { max: 80, ph: 'Ex.: Ecrã OLED de 6,1 polegadas' }) }));
      /* especificações */
      const sp = h('<div class="pad-sub"><div class="pad-sub-h">Especificações</div><div class="pad-grid g2 tight"></div></div>');
      const keys = SPEC_KEYS.concat(Object.keys(p.specs).filter(k => !SPEC_KEYS.some(x => x[0] === k)).map(k => [k, k]));
      keys.forEach(([k, lab]) => sp.querySelector('.pad-grid').appendChild(fld(lab, txt(() => p.specs[k], x => { if (x === '') delete p.specs[k]; else p.specs[k] = x; touch(); }, { max: 24, ph: 'Vazio = não mostra' }))));
      two.appendChild(fw); two.appendChild(sp); body.appendChild(two);
      /* cores (variantes) */
      const vw = h(`<div class="pad-sub"><div class="pad-sub-h">Cores e itens</div><div class="pad-vtbl"><div class="pad-vrow head"><span>Cor</span><span>Nome</span><span>Item do inventário</span><span>Preço próprio</span><span>À venda</span></div></div></div>`);
      const tb = vw.querySelector('.pad-vtbl');
      p.variants.forEach(v => {
        const r = h(`<div class="pad-vrow"><span class="c1"></span><span class="c2"></span><span class="c3"><code data-noi18n></code></span><span class="c4"></span><span class="c5"></span></div>`);
        r.querySelector('.c1').appendChild(colorCtl(() => v.swatch, x => { v.swatch = x; paintHead(); touch(); }, { compact: true }));
        r.querySelector('.c2').appendChild(txt(() => v.color, x => { v.color = x; touch(); }, { max: 24 }));
        r.querySelector('code').textContent = v.item || '-';
        r.querySelector('.c4').appendChild(numCtl({ get: () => v.price, set: x => { if (x == null) delete v.price; else v.price = x; touch(); }, min: 0, max: 10000000, step: 1, slider: false, compact: true, allowEmpty: true, placeholder: String(p.price != null ? p.price : ''), unit: currency.symbol }));
        r.querySelector('.c5').appendChild(sw(() => v.enabled, x => { v.enabled = x; r.classList.toggle('off', !x); paintHead(); touch(); }));
        r.classList.toggle('off', !v.enabled);
        tb.appendChild(r);
      });
      vw.appendChild(h('<div class="pad-note">Preço próprio vazio = o preço do produto. Uma cor desligada não aparece na loja.</div>'));
      body.appendChild(vw);
    }
    const PANES = {
      products(p) {
        p.appendChild(h('<div class="pad-note">Arrasta pela pega para mudar a ordem na loja. Clica num produto para editar os textos, as categorias e as cores.</div>'));
        const list = h('<div class="pad-prods"></div>');
        D().products.forEach(x => list.appendChild(prodRow(x)));
        if (!D().products.length) list.appendChild(emptyBox('A loja não tem produtos.', 'bag2'));
        sortable(list, { handle: '.pad-grip', item: '.pad-prod', onMove: (a, b) => { moveIn(D().products, a, b); touch(); } });
        p.appendChild(list);
        p._list = list;
      },
      shops(p) {
        const bar = h('<div class="pad-toolbar"></div>');
        bar.appendChild(btn('Nova loja aqui', { kind: 'primary', sm: true, icon: 'pin', on: async () => {
          const r = await call('admin.here', {}); if (!r.ok) return;
          const taken = D().shops.map(x => x.id);
          const s = { id: uniqId('loja_' + (D().shops.length + 1), taken), label: 'Nova loja', coords: { x: r.x, y: r.y, z: r.z, w: r.w }, vendor: { name: 'Vendedor', role: 'Vendedor', greeting: 'Olá! Em que posso ajudar?' }, blip: true };
          D().shops.push(s); const c = shopCard(s); list.appendChild(c); tabsEl.badge('shops', D().shops.length); touch();
          setTimeout(() => c.scrollIntoView({ block: 'nearest' }), 30);
          toast('Loja criada na tua posição. Guarda para o vendedor aparecer.', 'info');
        } }));
        bar.appendChild(h('<span class="pad-note inline">Cria um vendedor onde estás agora. Podes afinar as coordenadas à mão.</span>'));
        p.appendChild(bar);
        const list = h('<div class="pad-shops"></div>');
        D().shops.forEach(s => list.appendChild(shopCard(s)));
        p.appendChild(list); p._list = list;
      },
      cats(p) {
        p.appendChild(h('<div class="pad-note">As abas no topo da loja. "Todos" fica sempre em primeiro e não se apaga.</div>'));
        const c = card(null);
        c.body.appendChild(listEd({
          get: () => D().categories, max: 12, addLabel: 'Nova categoria', onChange: () => { touch(); prodCatSync.forEach(f => f()); },
          lock: it => it.id === 'all',
          make: () => ({ id: uniqId('categoria', D().categories.map(x => x.id)), label: 'Nova categoria', icon: 'grid' }),
          row: (it) => {
            const g = h('<div class="ovk-in pad-inline"></div>');
            g.appendChild(fld('Nome', txt(() => it.label, x => { it.label = x; touch(); }, { max: 24 })));
            g.appendChild(fld('Identificador', txt(() => it.id, x => { it.id = x; touch(); }, { max: 24, mono: true, disabled: it.id === 'all', filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, '') })));
            g.appendChild(fld('Ícone', txt(() => it.icon, x => { it.icon = x; touch(); }, { max: 24, mono: true, ph: 'grid' })));
            return g;
          },
        }));
        p.appendChild(c.el);
      },
      settings(p) {
        const s = D();
        const N = (o, k, opt) => numCtl(Object.assign({ get: () => o()[k], set: v => { o()[k] = v; touch(); } }, opt));
        const wrap = h('<div class="pad-masonry"></div>');
        /* preço e pagamento */
        const c1 = card('Preço e pagamento', { icon: 'card' });
        c1.body.appendChild(row('Símbolo da moeda', txt(() => D().currency.symbol, x => { D().currency.symbol = x; touch(); }, { max: 4 })));
        c1.body.appendChild(row('Posição do símbolo', seg([{ v: 'before', l: 'Antes' }, { v: 'after', l: 'Depois' }], () => D().currency.position, x => { D().currency.position = x; touch(); })));
        const accW = h('<div class="pad-chiptg"></div>');
        const defW = h('<div></div>');
        const paintAcc = () => {
          accW.textContent = '';
          const all = [...new Set(['bank', 'cash'].concat(D().payment.accounts))];
          all.forEach(a => {
            const b = h(`<button type="button" class="pad-tgl"><span></span></button>`); b.querySelector('span').textContent = ACCOUNTS[a] || a;
            b.classList.toggle('on', D().payment.accounts.includes(a));
            b.onclick = () => { const L2 = D().payment.accounts, i = L2.indexOf(a); if (i >= 0) { if (L2.length === 1) { toast('Tem de ficar pelo menos uma forma de pagamento.', 'err'); return; } L2.splice(i, 1); } else L2.push(a); if (!L2.includes(D().payment.default)) D().payment.default = L2[0]; paintAcc(); touch(); };
            accW.appendChild(b);
          });
          defW.textContent = '';
          defW.appendChild(seg(D().payment.accounts.map(a => ({ v: a, l: ACCOUNTS[a] || a })), () => D().payment.default, x => { D().payment.default = x; touch(); }, { small: true }));
        };
        paintAcc();
        c1.body.appendChild(row('Formas de pagamento', accW, { hint: 'O jogador escolhe na compra.' }));
        c1.body.appendChild(row('Escolhida por omissão', defW));
        wrap.appendChild(c1.el);
        /* interação */
        const c2 = card('Falar com o vendedor', { icon: 'hand' });
        c2.body.appendChild(row('Como se abre', seg([{ v: 'auto', l: 'Automático' }, { v: 'target', l: 'ox_target' }, { v: 'key', l: 'Tecla' }], () => D().interaction.mode, x => { D().interaction.mode = x; touch(); }), { hint: 'Automático usa o ox_target se estiver a correr.' }));
        c2.body.appendChild(row('Distância para abrir', N(() => D().interaction, 'distance', { min: 0.5, max: 6, step: 0.1, unit: 'm' })));
        c2.body.appendChild(row('Tecla mostrada', txt(() => D().interaction.keyLabel, x => { D().interaction.keyLabel = x; touch(); }, { max: 6, mono: true })));
        c2.body.appendChild(row('Código da tecla', N(() => D().interaction, 'key', { min: 0, max: 360, step: 1, slider: false }), { hint: '38 = E. Lista de controlos do FiveM.' }));
        c2.body.appendChild(row('Fecha a mais de', numCtl({ get: () => D().closeDistance, set: v => { D().closeDistance = v; touch(); }, min: 2, max: 40, step: 0.5, unit: 'm' }), { hint: 'A loja fecha se o jogador se afastar.' }));
        c2.body.appendChild(row('O servidor recusa a mais de', numCtl({ get: () => D().serverDistance, set: v => { D().serverDistance = v; touch(); }, min: 2, max: 60, step: 0.5, unit: 'm' })));
        wrap.appendChild(c2.el);
        /* mapa */
        const c3 = card('Mapa', { icon: 'map' });
        c3.body.appendChild(row('Mostrar as lojas no mapa', sw(() => D().blip.enabled !== false, x => { D().blip.enabled = x; touch(); })));
        c3.body.appendChild(row('Ícone do blip', N(() => D().blip, 'sprite', { min: 1, max: 1000, step: 1, slider: false }), { hint: '817 = telefone. Funciona com qualquer minimapa.' }));
        c3.body.appendChild(row('Ícone nos jogos recentes', N(() => D().blip, 'spriteModern', { min: 1, max: 1000, step: 1, slider: false }), { hint: '899 = telemóvel, só se nenhum HUD substituir o minimapa (senão fica uma bola).' }));
        c3.body.appendChild(row('Cor do blip', N(() => D().blip, 'color', { min: 0, max: 85, step: 1 })));
        c3.body.appendChild(row('Tamanho do blip', N(() => D().blip, 'scale', { min: 0.3, max: 2, step: 0.05 })));
        wrap.appendChild(c3.el);
        /* vendedor e câmara */
        const c4 = card('Vendedor e câmara', { icon: 'camera' });
        c4.body.appendChild(row('Modelo do vendedor', txt(() => D().ped.model, x => { D().ped.model = x; touch(); }, { max: 40, mono: true }), { hint: 'Cada loja pode ter o seu.' }));
        c4.body.appendChild(row('Animação do vendedor', txt(() => D().ped.scenario, x => { D().ped.scenario = x; touch(); }, { max: 48, mono: true })));
        c4.body.appendChild(row('Aparece a menos de', N(() => D().ped, 'spawnDistance', { min: 20, max: 300, step: 5, unit: 'm' })));
        c4.body.appendChild(row('Esconder o jogador na loja', sw(() => D().hidePlayer !== false, x => { D().hidePlayer = x; touch(); })));
        c4.body.appendChild(row('Câmara de cinema', sw(() => D().camera.enabled !== false, x => { D().camera.enabled = x; touch(); })));
        c4.body.appendChild(row('Distância da câmara', N(() => D().camera, 'distance', { min: 0.8, max: 4, step: 0.05, unit: 'm' })));
        c4.body.appendChild(row('Altura da câmara', N(() => D().camera, 'height', { min: -1, max: 2, step: 0.05, unit: 'm' })));
        c4.body.appendChild(row('Campo de visão', N(() => D().camera, 'fov', { min: 20, max: 90, step: 1, unit: '°' })));
        wrap.appendChild(c4.el);
        p.appendChild(wrap);
        void s;
      },
      sales(p) {
        const k = h('<div class="pad-kpis k3"></div>');
        const mk = (lab, icon) => { const e = h(`<div class="pad-kpi"><div class="pad-kpi-l"><span class="pad-kpi-ic">${ic(icon, 16)}</span><span></span></div><div class="pad-kpi-v ovk-mono" data-noi18n>-</div><div class="pad-kpi-s"></div></div>`); e.querySelector('.pad-kpi-l span:last-child').textContent = lab; k.appendChild(e); return e; };
        const kT = mk('Hoje', 'clock'), kA = mk('Receita total', 'chart'), kN = mk('Vendas', 'receipt');
        const cols = h('<div class="pad-cols pad-cols-21"></div>');
        const c1 = card('Vendas recentes', { icon: 'receipt' });
        const tb = h(`<div class="pad-tblw"><table class="pad-tbl"><thead><tr><th>${T('Jogador')}</th><th>${T('Produto')}</th><th>${T('Loja')}</th><th>${T('Pagamento')}</th><th class="num">${T('Valor')}</th><th>${T('Quando')}</th></tr></thead><tbody></tbody></table></div>`);
        c1.body.appendChild(tb);
        c1.act.appendChild(btn('Atualizar', { kind: 'link', sm: true, icon: 'update', on: () => refresh() }));
        const side = h('<div class="pad-stack"></div>');
        const c2 = card('Ferramentas', { icon: 'wrench' });
        const tools = h('<div class="pad-tools"></div>');
        const t1 = h(`<div class="pad-tool"><div class="pad-tool-t"><b>Abrir a loja aqui</b><small>Abre a loja onde estás, para testar, sem ires ao vendedor. Usa o que está guardado.</small></div></div>`);
        t1.appendChild(btn('Abrir', { sm: true, kind: 'ghost', icon: 'bag2', on: async () => {
          if (anyDirty()) { const ok = await confirmBox({ title: 'Sair sem guardar?', text: 'Tens alterações por guardar. A loja abre com o que já está guardado e o painel fecha.', ok: 'Abrir a loja', danger: true, icon: 'info' }); if (!ok) return; }
          hide(true); setTimeout(() => call('admin.shop.open', {}), 260);
        } }));
        const t2 = h(`<div class="pad-tool"><div class="pad-tool-t"><b>Verificar itens</b><small>Confirma que cada cor tem o item no inventário do servidor.</small></div></div>`);
        const res = h('<div class="pad-toolres" hidden></div>');
        t2.appendChild(btn('Verificar', { sm: true, kind: 'ghost', icon: 'checkCircle', on: async b => {
          b.disabled = true; const r = await call('admin.shop.recheck', {}); b.disabled = false; if (!r.ok) return;
          const miss = arr(r.missing); res.hidden = false; res.textContent = '';
          if (!miss.length) { res.className = 'pad-toolres ok'; res.appendChild(document.createTextNode(T('Todos os itens existem no inventário.'))); return; }
          res.className = 'pad-toolres bad';
          res.appendChild(document.createTextNode(miss.length === 1 ? T('Falta 1 item no inventário:') : TF('Faltam %s itens no inventário:', miss.length)));
          const cl = h('<div class="pad-chiptg" data-noi18n></div>'); miss.forEach(m => cl.appendChild(chip(String(m), { kind: 'bad', noi18n: true }))); res.appendChild(cl);
        } }));
        tools.appendChild(t1); tools.appendChild(t2); c2.body.appendChild(tools); c2.body.appendChild(res);
        const c3 = card('Mais vendidos', { icon: 'chart' });
        const bars = h('<div class="pad-bars"></div>'); c3.body.appendChild(bars);
        side.appendChild(c2.el); side.appendChild(c3.el);
        cols.appendChild(c1.el); cols.appendChild(side);
        p.appendChild(k); p.appendChild(cols);
        const paint = st => {
          st = isObj(st) ? st : null; const td = obj(st && st.today);
          kT.querySelector('.pad-kpi-v').textContent = st ? money(td.total || 0) : '-'; kT.querySelector('.pad-kpi-s').textContent = st ? (td.count === 1 ? T('1 venda hoje') : TF('%s vendas hoje', fmtN(td.count || 0))) : T('sem dados da loja');
          kA.querySelector('.pad-kpi-v').textContent = st ? money(st.salesTotal || 0) : '-'; kA.querySelector('.pad-kpi-s').textContent = T('desde que a loja abriu');
          kN.querySelector('.pad-kpi-v').textContent = st ? fmtN(st.salesCount || 0) : '-'; kN.querySelector('.pad-kpi-s').textContent = T('compras no total');
          const body = tb.querySelector('tbody'); body.textContent = '';
          const rec = arr(st && st.recent).slice(0, 14);
          if (!rec.length) body.appendChild(h(`<tr class="pad-tr-empty"><td colspan="6">Ainda não há vendas.</td></tr>`));
          rec.forEach(x => { const tr = h(`<tr><td data-noi18n class="strong"></td><td data-noi18n></td><td data-noi18n class="muted"></td><td class="muted"></td><td class="num" data-noi18n></td><td class="muted nowrap"></td></tr>`); const c = tr.children; c[0].textContent = x.name || '-'; c[1].textContent = x.label || x.item || '-'; c[2].textContent = shopLabel(x.shop); c[3].textContent = ACCOUNTS[x.account] || x.account || '-'; c[4].textContent = money(x.price); c[5].textContent = ago(x.at); c[5].title = fmtDate(x.at); body.appendChild(tr); });
          bars.textContent = '';
          const top = arr(st && st.top).slice(0, 5), mx = Math.max(1, ...top.map(t => Number(t.total) || 0));
          if (!top.length) bars.appendChild(h('<div class="pad-empty">Sem vendas para mostrar.</div>'));
          top.forEach(t => { const e = h(`<div class="pad-bar"><div class="pad-bar-t"><b data-noi18n></b><span data-noi18n></span></div><div class="pad-bar-tr"><i></i></div><div class="pad-bar-s"></div></div>`); e.querySelector('b').textContent = t.label || t.item; e.querySelector('.pad-bar-t span').textContent = money(t.total); e.querySelector('i').style.transform = `scaleX(${Math.max(0.02, (Number(t.total) || 0) / mx)})`; e.querySelector('.pad-bar-s').textContent = t.count === 1 ? T('1 venda') : TF('%s vendas', fmtN(t.count || 0)); e.title = `${t.label || t.item}: ${money(t.total)} · ${t.count}`; bars.appendChild(e); });
        };
        const refresh = async () => { const r = await call('admin.shop.stats', {}); if (r && r.ok !== false) { const st = isObj(r.stats) ? r.stats : r; boot.stats.shop = st; paint(st); } };
        paint(obj(boot.stats).shop);
      },
    };

    /* ---------- lojas ---------- */
    function shopCard(s) {
      const c = h(`<section class="pad-card pad-shop"><header class="pad-card-h"><span class="pad-card-ic">${ic('pin', 16)}</span><div class="pad-card-tt"><h3 data-noi18n></h3><p data-noi18n></p></div><div class="pad-card-act"></div></header><div class="pad-card-b"></div></section>`);
      const paint = () => { c.querySelector('h3').textContent = s.label || s.id; const k = s.coords; c.querySelector('p').textContent = `${s.id} · ${Number(k.x).toFixed(1)}, ${Number(k.y).toFixed(1)}, ${Number(k.z).toFixed(1)}`; };
      const act = c.querySelector('.pad-card-act');
      const coordCtls = [];
      act.appendChild(btn('Teletransportar', { sm: true, kind: 'ghost', icon: 'nav', on: async () => { const r = await call('admin.tp', Object.assign({ front: true }, s.coords)); if (r.ok) toast(TF('A caminho de %s.', s.label || s.id), 'info', { noi18n: true }); } }));
      act.appendChild(btn('Usar a minha posição', { sm: true, kind: 'ghost', icon: 'location', on: async () => { const r = await call('admin.here', {}); if (!r.ok) return; s.coords = { x: r.x, y: r.y, z: r.z, w: r.w }; coordCtls.forEach(x => x.sync()); paint(); touch(); toast('Coordenadas atualizadas. O vendedor fica virado para onde estás virado.', 'info'); } }));
      act.appendChild(btn('', { sm: true, kind: 'ghost danger', icon: 'trash', title: 'Apagar loja', on: async () => {
        const ok = await confirmBox({ title: 'Apagar esta loja?', text: TF('O vendedor de %s deixa de aparecer depois de guardares.', s.label || s.id), ok: 'Apagar', danger: true });
        if (!ok) return; const i = D().shops.indexOf(s); if (i >= 0) D().shops.splice(i, 1); c.remove(); tabsEl.badge('shops', D().shops.length); touch();
      } }));
      const b = c.querySelector('.pad-card-b');
      const g = h('<div class="pad-grid g4"></div>');
      g.appendChild(fld('Nome da loja', txt(() => s.label, x => { s.label = x; paint(); touch(); }, { max: 60 }), { span: 2 }));
      g.appendChild(fld('Identificador', txt(() => s.id, x => { s.id = x; paint(); touch(); }, { max: 32, mono: true, filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, '') })));
      const bl = h('<div class="pad-swl"></div>'); bl.appendChild(sw(() => s.blip, x => { s.blip = x; touch(); })); bl.appendChild(h('<span>No mapa</span>'));
      g.appendChild(fld('Blip', bl));
      [['x', 'X'], ['y', 'Y'], ['z', 'Z'], ['w', 'Direção']].forEach(([k, lab]) => { const n = numCtl({ get: () => s.coords[k], set: v => { s.coords[k] = v; paint(); touch(); }, min: k === 'w' ? 0 : -20000, max: k === 'w' ? 360 : 20000, step: k === 'w' ? 0.1 : 0.01, slider: false, compact: true }); coordCtls.push(n); g.appendChild(fld(lab, n)); });
      b.appendChild(g);
      const g2 = h('<div class="pad-grid g4"></div>');
      g2.appendChild(fld('Nome do vendedor', txt(() => s.vendor.name, x => { s.vendor.name = x; touch(); }, { max: 24 })));
      g2.appendChild(fld('Papel', txt(() => s.vendor.role, x => { s.vendor.role = x; touch(); }, { max: 24, ph: 'Vendedor' })));
      const pm = () => obj(s.ped), setPed = (k, x) => { const pp = Object.assign({}, obj(s.ped)); if (x === '') delete pp[k]; else pp[k] = x; if (Object.keys(pp).length) s.ped = pp; else delete s.ped; touch(); };
      g2.appendChild(fld('Modelo do NPC', txt(() => pm().model, x => setPed('model', x), { max: 40, mono: true, ph: D().ped.model || 's_m_m_lifeinvad_01' })));
      g2.appendChild(fld('Animação', txt(() => pm().scenario, x => setPed('scenario', x), { max: 48, mono: true, ph: D().ped.scenario || '' })));
      g2.appendChild(fld('Saudação', txt(() => s.vendor.greeting, x => { s.vendor.greeting = x; touch(); }, { max: 240, area: true, rows: 2 }), { span: 4 }));
      b.appendChild(g2);
      paint();
      c._s = s;
      return c;
    }
    function filter(q) {
      SEC.shop._q = q;
      const p = panes[curTab]; if (!p || !p._list) return;
      [...p._list.children].forEach(e => { if (!e._p && !e._s) return; e.hidden = !!q && !e.textContent.toLowerCase().includes(q) && !JSON.stringify(e._p || e._s).toLowerCase().includes(q); });
    }
    return {
      reset() { pageEl = null; panes = {}; prodCatSync = []; curTab = 'products'; SEC.shop._q = null; },
      build, rebuild, filter,
      tab(id) { if (tabsEl) tabsEl.pick(id); else curTab = id; },
    };
  })();

  /* ============================================================
     5. APPS DE TRABALHO (construtor). O motor é o server/capps.lua + js/apps/capps.js.
     ============================================================ */
  const MTYPES = {
    form: { label: 'Formulário', icon: 'flag', desc: 'Denúncias, candidaturas, reclamações: o cidadão preenche e a equipa trata.' },
    appointments: { label: 'Marcações', icon: 'calendar', desc: 'Consultas e reservas por serviço, dia e hora.' },
    dispatch: { label: 'Pedidos de serviço', icon: 'bolt', desc: 'Um toque para pedir ajuda; a equipa em serviço aceita.' },
    records: { label: 'Fichas', icon: 'clipboard', desc: 'Registos por pessoa ou veículo, com notas e etiquetas.' },
    posts: { label: 'Comunicados', icon: 'newspaper', desc: 'Avisos e notícias publicados pela equipa.' },
    catalog: { label: 'Catálogo', icon: 'cart', desc: 'Menu ou tabela de preços, com carrinho e encomendas.' },
    billing: { label: 'Faturação', icon: 'receipt', desc: 'A equipa passa faturas pelo número de telefone. Só para a equipa.' },
    duty: { label: 'Em serviço', icon: 'clock', desc: 'Entrar e sair de serviço, com as horas de cada um. Só para a equipa.' },
    roster: { label: 'Equipa', icon: 'users', desc: 'Colegas online, com cargo e contacto. Só para a equipa.' },
    info: { label: 'Página de informação', icon: 'info', desc: 'Texto, horário, morada, contactos e ligações.' },
  };
  /* tipos sem lado do cidadão (o motor e o validador do servidor também os tratam assim) */
  const STAFF_ONLY = new Set(['billing', 'duty', 'roster']);
  const FTYPES = [['text', 'Texto curto'], ['textarea', 'Texto longo'], ['number', 'Número'], ['select', 'Lista de opções'], ['multiselect', 'Escolha múltipla'], ['checkbox', 'Caixa de confirmação'],
    ['date', 'Data'], ['time', 'Hora'], ['phone', 'Telefone'], ['plate', 'Matrícula'], ['email', 'Email'], ['url', 'Endereço web'], ['rating', 'Avaliação (1 a 5)'], ['photo', 'Fotografia'],
    ['section', 'Secção (título)'], ['info', 'Texto informativo']];
  const NOVAL = new Set(['section', 'info']);
  /* comprimento máximo por tipo de texto (o mesmo do server/admin.lua) */
  const TEXT_LEN = { text: 200, textarea: 1500, phone: 32, plate: 16, email: 120, url: 300 };
  const BTYPES = [['text', 'Texto', 'list'], ['hours', 'Horário', 'clock'], ['location', 'Morada', 'pin'], ['contact', 'Contacto', 'phone'], ['link', 'Ligação', 'link'], ['image', 'Imagem', 'photo']];
  const HOOK_EVENTS = [['item.created', 'Pedido novo', 'Um cidadão enviou um formulário, uma marcação ou um pedido.'], ['item.status', 'Estado mudou', 'A equipa mudou o estado de um pedido.'], ['item.reply', 'Resposta nova', 'Alguém respondeu na conversa de um pedido.'],
    ['dispatch.accepted', 'Pedido aceite', 'Alguém da equipa aceitou um pedido de serviço.'], ['bill.created', 'Fatura passada', 'A equipa passou uma fatura a um cidadão.'], ['duty.changed', 'Entrada ou saída de serviço', 'Alguém da equipa entrou ou saiu de serviço.'], ['post.created', 'Comunicado publicado', 'A equipa publicou um comunicado.'], ['record.created', 'Ficha criada', 'Foi criada uma ficha nova.'], ['record.updated', 'Ficha atualizada', 'Uma ficha recebeu uma nota ou mudou.']];
  const DAYS = [[1, 'Seg'], [2, 'Ter'], [3, 'Qua'], [4, 'Qui'], [5, 'Sex'], [6, 'Sáb'], [7, 'Dom']];
  /* permissões por módulo (grau mínimo por ação). Só aparecem as ações que o tipo tem. */
  const PERMS = { view: 'Ver', reply: 'Responder e notas', status: 'Mudar o estado', assign: 'Atribuir a alguém', delete: 'Apagar', create: 'Criar' };
  const PERM_BY_TYPE = { form: ['view', 'reply', 'status', 'assign', 'delete'], appointments: ['view', 'reply', 'status', 'delete'], dispatch: ['view', 'status', 'assign', 'delete'],
    records: ['view', 'create', 'reply', 'delete'], posts: ['create', 'delete'], roster: ['view'], catalog: ['view', 'reply', 'status', 'assign', 'delete'], billing: ['view', 'create'], duty: ['view'] };
  const PERM_LABEL = { 'posts.create': 'Publicar', 'billing.create': 'Passar faturas', 'billing.view': 'Ver as faturas passadas', 'records.create': 'Criar fichas', 'dispatch.status': 'Aceitar e fechar',
    'duty.view': 'Ver quem está de serviço', 'roster.view': 'Ver a equipa', 'appointments.status': 'Confirmar e cancelar', 'catalog.status': 'Mudar o estado da encomenda' };
  /* valores por omissão das permissões (as mesmas regras do motor quando o módulo não tem perms) */
  function permDefaults(m) {
    const o = obj(m.options), base = Number(m.staffMinGrade) || 0, c = v => Math.min(99, Math.max(0, Number(v) || 0));
    return { view: c(base), reply: c(base), status: c(base), assign: c(base), create: c(m.type === 'posts' ? (o.postGrade != null ? o.postGrade : base) : base), delete: c(o.deleteGrade != null ? o.deleteGrade : base) };
  }
  const ST = (id, label, color, closed, notify) => Object.assign({ id, label, color }, closed ? { closed: true } : {}, { notify: notify !== false });
  const DEF_STATUSES = () => [ST('novo', 'Novo', '#5B8CFF'), ST('curso', 'Em curso', '#F5A524'), ST('fechado', 'Fechado', '#10B981', true)];
  const ORDER_STATUSES = () => [ST('recebida', 'Recebida', '#5B8CFF'), ST('preparar', 'Em preparação', '#F5A524'), ST('pronta', 'Pronta', '#10B981'), ST('entregue', 'Entregue', '#8A8F98', true, false), ST('cancelada', 'Cancelada', '#E5484D', true)];
  const HOOKS = () => ({ url: '', events: { 'item.created': true, 'item.status': true, 'item.reply': false, 'post.created': true, 'record.created': true, 'record.updated': false, 'dispatch.accepted': true, 'bill.created': true, 'duty.changed': false }, urls: {} });

  /* ---------- peças de partida (tudo em português, com estados, campos e horários a sério) ---------- */
  const F = (key, label, type, o = {}) => {
    const f = { key, label, type: type || 'text', required: !!o.req };
    if (o.options) f.options = o.options; if (o.ph) f.placeholder = o.ph; if (o.help) f.help = o.help;
    if (o.min != null) f.min = o.min; if (o.max != null) f.max = o.max; if (o.def != null) f.default = o.def;
    if (o.if) f.showIf = { key: o.if[0], equals: o.if[1] };
    return f;
  };
  const M = (id, type, title, icon, options, x = {}) => ({ id, type, title, icon, enabled: true, civil: x.civil !== false && !STAFF_ONLY.has(type), staff: x.staff !== false, staffMinGrade: x.grade || 0, options });
  const W17 = [1, 2, 3, 4, 5, 6, 7], W15 = [1, 2, 3, 4, 5], W16 = [1, 2, 3, 4, 5, 6];
  const cur$ = () => (currency && currency.symbol) || defCur().symbol;
  const billMax = () => Number(boot && boot.limits && boot.limits.billMax) || 1000000;
  const I = (id, label, price, category, desc) => ({ id, label, desc: desc || '', price, image: '', category, available: true });
  /* módulos prontos (a biblioteca do "Adicionar módulo" e os modelos de app usam os mesmos) */
  const P = {
    denuncia: (x = {}) => M('denuncias', 'form', 'Denúncias', 'flag', { intro: 'Conta-nos o que aconteceu. Uma denúncia falsa também é crime.', submitLabel: 'Enviar denúncia', anonymous: true, location: true, photo: true, civilSeesOwn: true, replies: true, deleteGrade: x.deleteGrade != null ? x.deleteGrade : 3,
      fields: [F('tipo', 'Tipo de ocorrência', 'select', { req: true, options: ['Furto', 'Roubo', 'Agressão', 'Vandalismo', 'Burla', 'Ameaças', 'Outro'] }), F('qual', 'Qual?', 'text', { req: true, if: ['tipo', 'Outro'], ph: 'Diz-nos o tipo de ocorrência' }),
        F('local', 'Onde aconteceu', 'text', { ph: 'Rua, bairro ou ponto de referência' }), F('quando', 'Quando', 'date'), F('hora', 'A que horas', 'time'), F('matricula', 'Matrícula envolvida', 'plate'), F('descricao', 'O que aconteceu', 'textarea', { req: true, ph: 'Descreve com o máximo de detalhe', min: 20 })],
      statuses: [ST('nova', 'Nova', '#5B8CFF'), ST('analise', 'Em análise', '#F5A524'), ST('investigacao', 'Em investigação', '#A855F7'), ST('resolvida', 'Resolvida', '#10B981', true), ST('arquivada', 'Arquivada', '#8A8F98', true)] }),
    candidatura: () => M('candidaturas', 'form', 'Candidaturas', 'briefcase', { intro: 'Queres trabalhar connosco? Deixa os teus dados.', submitLabel: 'Enviar candidatura', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 2,
      fields: [F('s_tu', 'Sobre ti', 'section'), F('nome', 'Nome completo', 'text', { req: true }), F('idade', 'Idade', 'number', { req: true, min: 16, max: 99 }), F('telefone', 'Telefone', 'phone', { req: true }), F('email', 'Email', 'email'),
        F('s_exp', 'Experiência', 'section'), F('experiencia', 'Onde já trabalhaste', 'textarea'), F('disponibilidade', 'Disponibilidade', 'multiselect', { options: ['Manhãs', 'Tardes', 'Noites', 'Fins de semana'] }),
        F('carta', 'Tenho carta de condução', 'checkbox'), F('carta_tipo', 'Que carta?', 'select', { if: ['carta', 'true'], options: ['Ligeiros', 'Pesados', 'Motociclos'] })],
      statuses: [ST('recebida', 'Recebida', '#5B8CFF'), ST('entrevista', 'Entrevista', '#F5A524'), ST('aceite', 'Aceite', '#10B981', true), ST('recusada', 'Recusada', '#8A8F98', true)] }),
    reclamacao: () => M('reclamacoes', 'form', 'Reclamações', 'flag', { intro: 'Diz-nos o que correu mal. Respondemos aqui.', submitLabel: 'Enviar reclamação', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 2,
      fields: [F('assunto', 'Assunto', 'text', { req: true }), F('quando', 'Quando', 'date'), F('nota', 'Como avalias o serviço', 'rating'), F('oque', 'O que aconteceu', 'textarea', { req: true })],
      statuses: [ST('recebida', 'Recebida', '#5B8CFF'), ST('analise', 'Em análise', '#F5A524'), ST('resolvida', 'Resolvida', '#10B981', true)] }),
    documento: () => M('documentos', 'form', 'Pedir documento', 'document', { intro: 'Pede aqui licenças, certidões e declarações. Avisamos quando estiver pronto.', submitLabel: 'Fazer pedido', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 2,
      fields: [F('documento', 'Documento', 'select', { req: true, options: ['Licença de condução', 'Licença de porte de arma', 'Certificado de registo criminal', 'Declaração de residência', 'Outro'] }),
        F('outro', 'Que documento?', 'text', { req: true, if: ['documento', 'Outro'] }), F('nome', 'Nome completo', 'text', { req: true }), F('nascimento', 'Data de nascimento', 'date', { req: true }), F('motivo', 'Para que precisas', 'textarea')],
      statuses: [ST('pedido', 'Pedido', '#5B8CFF'), ST('tratamento', 'Em tratamento', '#F5A524'), ST('pronto', 'Pronto a levantar', '#10B981'), ST('entregue', 'Entregue', '#8A8F98', true, false), ST('recusado', 'Recusado', '#E5484D', true)] }),
    consultas: () => M('consultas', 'appointments', 'Consultas', 'calendar', { services: [{ id: 'geral', label: 'Consulta geral', minutes: 30 }, { id: 'exame', label: 'Exame médico', minutes: 45 }, { id: 'aptidao', label: 'Atestado de aptidão', minutes: 20 }, { id: 'psicologia', label: 'Psicologia', minutes: 60 }], hours: { from: 9, to: 21 }, days: W16.slice(), slot: 30, maxPerSlot: 2, notes: true }),
    marcacoes: () => M('marcacoes', 'appointments', 'Marcações', 'calendar', { services: [{ id: 'revisao', label: 'Revisão geral', minutes: 60 }, { id: 'diagnostico', label: 'Diagnóstico', minutes: 30 }, { id: 'pintura', label: 'Pintura', minutes: 90 }, { id: 'motor', label: 'Afinação de motor', minutes: 60 }], hours: { from: 10, to: 20 }, days: W16.slice(), slot: 30, maxPerSlot: 2, notes: true }),
    reboque: () => M('reboque', 'dispatch', 'Pedir reboque', 'car', { types: [{ id: 'reboque', label: 'Reboque', icon: 'towTruck' }, { id: 'avaria', label: 'Avaria na estrada', icon: 'wrench' }, { id: 'pneu', label: 'Pneu furado', icon: 'lifebuoy' }, { id: 'combustivel', label: 'Sem combustível', icon: 'fuel' }], location: true, cooldown: 120 }),
    ambulancia: () => M('ambulancia', 'dispatch', 'Pedir ambulância', 'bell', { types: [{ id: 'ferido', label: 'Pessoa ferida', icon: 'drop' }, { id: 'inconsciente', label: 'Pessoa inconsciente', icon: 'eye' }, { id: 'acidente', label: 'Acidente de viação', icon: 'car' }, { id: 'outro', label: 'Outra emergência', icon: 'info' }], location: true, cooldown: 120 }),
    patrulha: () => M('ocorrencias', 'dispatch', 'Ocorrências', 'bolt', { types: [{ id: 'patrulha', label: 'Pedir patrulha', icon: 'car' }, { id: 'assalto', label: 'Assalto em curso', icon: 'bolt' }, { id: 'acidente', label: 'Acidente', icon: 'flame' }, { id: 'ruido', label: 'Barulho excessivo', icon: 'speaker' }, { id: 'suspeito', label: 'Pessoa suspeita', icon: 'eye' }], location: true, cooldown: 90 }),
    criminal: () => M('fichas', 'records', 'Registo criminal', 'clipboard', { subject: 'person', civilSeesOwn: false, fields: [F('crime', 'Crime', 'text', { req: true }), F('artigo', 'Artigo', 'text', { ph: 'Ex.: Art. 12' }), F('multa', 'Multa', 'number', { min: 0 }), F('pena', 'Pena (meses)', 'number', { min: 0, max: 600 }), F('notas', 'Notas', 'textarea')],
      tags: [{ id: 'procurado', label: 'Procurado', color: '#E5484D' }, { id: 'perigoso', label: 'Perigoso', color: '#EA580C' }, { id: 'cadastrado', label: 'Cadastrado', color: '#8A8F98' }] }, { civil: false }),
    clinica: () => M('fichas', 'records', 'Fichas clínicas', 'clipboard', { subject: 'person', civilSeesOwn: true, fields: [F('sangue', 'Grupo sanguíneo', 'select', { options: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'] }), F('alergias', 'Alergias', 'text'), F('diagnostico', 'Diagnóstico', 'textarea', { req: true }), F('tratamento', 'Tratamento', 'textarea')],
      tags: [{ id: 'cronico', label: 'Doença crónica', color: '#F59E0B' }, { id: 'seguro', label: 'Com seguro', color: '#10B981' }] }, { civil: false }),
    veiculo: () => M('historico', 'records', 'Histórico do veículo', 'clipboard', { subject: 'vehicle', civilSeesOwn: true, fields: [F('servico', 'Serviço', 'select', { req: true, options: ['Reparação', 'Revisão', 'Pintura', 'Peças', 'Reboque'] }), F('km', 'Quilómetros', 'number', { min: 0 }), F('valor', 'Valor cobrado', 'number', { min: 0 }), F('notas', 'Notas', 'textarea')],
      tags: [{ id: 'garantia', label: 'Em garantia', color: '#10B981' }, { id: 'porpagar', label: 'Por pagar', color: '#E5484D' }] }, { civil: false }),
    comunicados: (x = {}) => M(x.id || 'comunicados', 'posts', x.title || 'Comunicados', 'newspaper', { postGrade: x.postGrade != null ? x.postGrade : 2, notifyAll: !!x.notifyAll, audience: 'all', pinLimit: 3 }),
    quadro: () => M('quadro', 'posts', 'Quadro interno', 'megaphone', { postGrade: 1, notifyAll: false, audience: 'staff', pinLimit: 3 }, { civil: false }),
    menu: () => M('menu', 'catalog', 'Menu', 'food', { orderable: true, billing: true, location: true, maxQty: 10, currency: cur$(),
      categories: ['Hambúrgueres', 'Acompanhamentos', 'Bebidas', 'Sobremesas'],
      items: [I('classico', 'Clássico', 9, 'Hambúrgueres', 'Pão brioche, carne de vaca, queijo e o molho da casa.'), I('bacon', 'Duplo bacon', 12, 'Hambúrgueres', 'Duas carnes, bacon estaladiço e cheddar.'), I('vegetariano', 'Vegetariano', 10, 'Hambúrgueres', 'Grão, cogumelos e maionese de ervas.'),
        I('batatas', 'Batatas fritas', 4, 'Acompanhamentos'), I('aneis', 'Anéis de cebola', 4, 'Acompanhamentos'), I('refrigerante', 'Refrigerante', 2, 'Bebidas'), I('batido', 'Batido de morango', 4, 'Bebidas'), I('gelado', 'Gelado', 3, 'Sobremesas')],
      fields: [F('entrega', 'Entrega', 'select', { req: true, options: ['Levantar no balcão', 'Entrega em casa'], def: 'Levantar no balcão' }), F('morada', 'Morada', 'text', { req: true, if: ['entrega', 'Entrega em casa'], ph: 'Rua e número' }), F('notas', 'Notas', 'textarea', { ph: 'Sem cebola, molho à parte...' })],
      statuses: [ST('recebida', 'Recebida', '#5B8CFF'), ST('preparar', 'Em preparação', '#F5A524'), ST('pronta', 'Pronta a levantar', '#10B981'), ST('caminho', 'A caminho', '#0EA5E9'), ST('entregue', 'Entregue', '#8A8F98', true, false), ST('cancelada', 'Cancelada', '#E5484D', true)] }),
    servicos: () => M('servicos', 'catalog', 'Tabela de serviços', 'tag', { orderable: true, billing: true, location: false, maxQty: 4, currency: cur$(),
      categories: ['Manutenção', 'Reparação', 'Estética'],
      items: [I('revisao', 'Revisão geral', 450, 'Manutenção', 'Óleo, filtros, travões e pneus verificados.'), I('oleo', 'Mudança de óleo', 120, 'Manutenção'), I('pneus', 'Pneus (jogo de 4)', 600, 'Manutenção'),
        I('diagnostico', 'Diagnóstico', 80, 'Reparação'), I('motor', 'Reparação de motor', 900, 'Reparação'), I('pintura', 'Pintura completa', 1500, 'Estética'), I('vidros', 'Vidros escurecidos', 350, 'Estética')],
      fields: [F('matricula', 'Matrícula', 'plate', { req: true }), F('notas', 'O que se passa com o carro', 'textarea')],
      statuses: [ST('pedido', 'Pedido', '#5B8CFF'), ST('oficina', 'Na oficina', '#F5A524'), ST('pronto', 'Pronto', '#10B981'), ST('entregue', 'Entregue', '#8A8F98', true, false), ST('cancelado', 'Cancelado', '#E5484D', true)] }),
    faturacao: (x = {}) => M(x.id || 'faturacao', 'billing', x.title || 'Faturação', 'receipt', { society: true, maxAmount: Math.min(x.max || 100000, billMax()), presets: (x.presets || []).map(([label, amount]) => ({ label, amount })), reasonRequired: true }),
    servico: () => M('servico', 'duty', 'Em serviço', 'clock', { esxOffPrefix: 'off', showTeam: true }),
    equipa: (x = {}) => M('equipa', 'roster', 'Equipa', 'users', { showOffDuty: !!x.offDuty }),
    sobre: (x = {}) => M(x.id || 'sobre', 'info', x.title || 'Sobre nós', 'info', { hero: '', blocks: [{ type: 'text', title: 'Quem somos', text: x.text || 'Escreve aqui a apresentação.' }, { type: 'hours', title: 'Horário', text: '', hours: { from: x.from || 10, to: x.to || 22, days: (x.days || W16).slice() } }, { type: 'location', title: 'Onde estamos', text: x.where || 'Los Santos' }, { type: 'contact', title: 'Contacto', text: 'Fala connosco.', phone: '' }] }),
  };
  /* biblioteca de módulos ("Adicionar módulo"): por tipo, por esta ordem */
  const PRESETS = [
    ['form', 'denuncia', 'Denúncia', 'Tipo, local, hora, matrícula e descrição. Pode ser anónima e leva o GPS.'],
    ['form', 'candidatura', 'Candidatura de emprego', 'Dados pessoais, experiência, disponibilidade e carta de condução.'],
    ['form', 'reclamacao', 'Reclamação', 'O que correu mal, com avaliação e conversa com o autor.'],
    ['form', 'documento', 'Pedido de documento', 'Licenças, certidões e declarações, com aviso quando estiver pronto.'],
    ['appointments', 'consultas', 'Consultas', 'Quatro especialidades, de segunda a sábado.'],
    ['appointments', 'marcacoes', 'Marcações', 'Revisões, diagnósticos e pinturas na oficina.'],
    ['dispatch', 'reboque', 'Pedido de reboque', 'Reboque, avaria, pneu furado ou sem combustível.'],
    ['dispatch', 'ambulancia', 'Pedir ambulância', 'Feridos, inconscientes e acidentes, com GPS.'],
    ['dispatch', 'patrulha', 'Patrulha', 'Pedir patrulha, assaltos, acidentes, barulho e suspeitos.'],
    ['records', 'criminal', 'Registo criminal', 'Crimes, artigos, multas e penas, com etiquetas.'],
    ['records', 'clinica', 'Ficha clínica', 'Grupo sanguíneo, alergias, diagnóstico e tratamento.'],
    ['records', 'veiculo', 'Histórico do veículo', 'Reparações e revisões por matrícula.'],
    ['posts', 'comunicados', 'Comunicados', 'Avisos públicos da equipa para os cidadãos.'],
    ['posts', 'quadro', 'Quadro interno', 'Avisos só para a equipa: escalas, ordens e lembretes.'],
    ['catalog', 'menu', 'Menu do restaurante', 'Hambúrgueres, acompanhamentos, bebidas e sobremesas, com entrega.'],
    ['catalog', 'servicos', 'Tabela de serviços', 'Preços da oficina, com marcação pela matrícula.'],
    ['billing', 'faturacao', 'Faturação', 'Faturas à conta da empresa, com valores rápidos.'],
    ['duty', 'servico', 'Em serviço', 'Entrar e sair de serviço e as horas da semana.'],
    ['roster', 'equipa', 'Equipa', 'Quem está online, com cargo e contacto.'],
    ['info', 'sobre', 'Sobre nós', 'Apresentação, horário, morada e contacto.'],
  ];
  function appBase(o) {
    const cats = boot && boot.categories.length ? boot.categories : ['Serviços públicos', 'Emprego', 'Empresas'];
    return {
      id: o.id, name: o.name, subtitle: o.subtitle || '', description: o.description || '',
      icon: { glyph: o.glyph, bg: o.bg, bg2: o.bg2, fg: o.fg || '#FFFFFF', image: '' }, accent: o.accent || o.bg,
      category: cats.includes(o.category) ? o.category : cats[0],
      enabled: true, listed: true, preinstalled: !!o.preinstalled,
      audience: { public: true, jobs: o.jobs || [], onDutyOnly: false },
      contact: o.contact || { phone: '', label: '' }, notify: { staff: true },
      modules: o.modules, webhooks: HOOKS(),
    };
  }
  const TEMPLATES = [
    { key: 'police', name: 'Polícia', desc: 'Denúncias, ocorrências, fichas, multas, comunicados, quadro interno, serviço e a equipa.', make: () => appBase({
      id: 'lspd', name: 'LSPD', subtitle: 'Polícia de Los Santos', description: 'Faz denúncias, pede uma patrulha e acompanha os comunicados da polícia.', glyph: 'shield', bg: '#1F5EFF', bg2: '#0B2A8A', category: 'Serviços públicos',
      jobs: [{ name: 'police', minGrade: 0 }], contact: { phone: '911', label: 'Emergência' }, preinstalled: true,
      modules: [P.denuncia(), P.patrulha(), P.criminal(), P.faturacao({ id: 'multas', title: 'Multas', presets: [['Excesso de velocidade', 250], ['Estacionamento proibido', 100], ['Condução perigosa', 750], ['Desobediência', 1000]] }),
        P.comunicados(), P.quadro(), P.servico(), P.equipa()] }) },
    { key: 'hospital', name: 'Hospital', desc: 'Consultas, pedir ambulância, fichas clínicas, faturação, serviço e a equipa.', make: () => appBase({
      id: 'pillbox', name: 'Pillbox', subtitle: 'Hospital Pillbox Hill', description: 'Marca uma consulta, pede uma ambulância e consulta a tua ficha clínica.', glyph: 'heart', bg: '#E5484D', bg2: '#8E1A1F', category: 'Serviços públicos',
      jobs: [{ name: 'ambulance', minGrade: 0 }], contact: { phone: '911', label: 'Emergência médica' }, preinstalled: true,
      modules: [P.consultas(), P.ambulancia(), P.clinica(), P.faturacao({ presets: [['Consulta', 150], ['Tratamento de feridas', 300], ['Transporte em ambulância', 400], ['Cirurgia', 2500]] }), P.servico(), P.equipa({ offDuty: true })] }) },
    { key: 'mechanic', name: 'Mecânico', desc: 'Reboque, marcações, tabela de serviços, histórico, faturação e serviço.', make: () => appBase({
      id: 'oficina', name: 'Oficina', subtitle: 'Mecânica e reboques', description: 'Pede um reboque, marca a revisão e vê o histórico do teu carro.', glyph: 'wrench', bg: '#F59E0B', bg2: '#92400E', category: 'Empresas',
      jobs: [{ name: 'mechanic', minGrade: 0 }],
      modules: [P.reboque(), P.servicos(), P.marcacoes(), P.veiculo(), P.faturacao({ presets: [['Reboque', 200], ['Reparação no local', 350]] }), P.servico(), P.equipa()] }) },
    { key: 'restaurant', name: 'Restaurante', desc: 'Menu com encomendas e entregas, faturação, serviço e a página do restaurante.', make: () => appBase({
      id: 'burgershot', name: 'Burger Shot', subtitle: 'Restaurante', description: 'Vê o menu, faz a tua encomenda e acompanha-a até chegar.', glyph: 'food', bg: '#EA580C', bg2: '#9A3412', category: 'Empresas',
      jobs: [{ name: 'burgershot', minGrade: 0 }], contact: { phone: '', label: '' },
      modules: [P.menu(), P.faturacao({ presets: [['Menu completo', 15], ['Serviço de catering', 500]] }), P.servico(), P.sobre({ text: 'Hambúrgueres feitos na hora, desde 1998.', from: 11, to: 24, days: W17, where: 'Del Perro, Los Santos' }), P.equipa()] }) },
    { key: 'taxi', name: 'Táxi', desc: 'Pedir táxi, reservas, reclamações, avisos, faturação e serviço.', make: () => appBase({
      id: 'taxi', name: 'Downtown Cab', subtitle: 'Táxis de Los Santos', description: 'Chama um táxi onde estiveres ou reserva uma viagem.', glyph: 'taxi', bg: '#FACC15', bg2: '#CA8A04', fg: '#111111', category: 'Empresas',
      jobs: [{ name: 'taxi', minGrade: 0 }],
      modules: [
        M('pedir', 'dispatch', 'Pedir táxi', 'car', { types: [{ id: 'normal', label: 'Táxi', icon: 'taxi' }, { id: 'grande', label: 'Táxi grande', icon: 'users' }, { id: 'encomenda', label: 'Entrega de encomenda', icon: 'bag2' }], location: true, cooldown: 60 }),
        M('reservas', 'appointments', 'Reservas', 'calendar', { services: [{ id: 'aeroporto', label: 'Transfer para o aeroporto', minutes: 45 }, { id: 'longa', label: 'Viagem longa', minutes: 60 }, { id: 'evento', label: 'Evento ou festa', minutes: 120 }], hours: { from: 6, to: 24 }, days: W17.slice(), slot: 30, maxPerSlot: 3, notes: true }),
        P.reclamacao(), P.comunicados({ id: 'avisos', title: 'Avisos', postGrade: 1 }), P.faturacao({ presets: [['Viagem curta', 30], ['Viagem longa', 80], ['Transfer para o aeroporto', 120]] }), P.servico(), P.equipa(),
      ] }) },
    { key: 'lawyers', name: 'Advogados', desc: 'Consultas, pedidos de apoio jurídico, processos e página do escritório.', make: () => appBase({
      id: 'advogados', name: 'Advogados', subtitle: 'Escritório de advocacia', description: 'Marca uma consulta ou pede apoio jurídico.', glyph: 'gavel', bg: '#334155', bg2: '#0F172A', category: 'Empresas',
      jobs: [{ name: 'lawyer', minGrade: 0 }],
      modules: [
        M('consultas', 'appointments', 'Consultas', 'calendar', { services: [{ id: 'primeira', label: 'Primeira consulta', minutes: 30 }, { id: 'defesa', label: 'Defesa em tribunal', minutes: 60 }, { id: 'contratos', label: 'Contratos e documentos', minutes: 45 }], hours: { from: 9, to: 19 }, days: W15.slice(), slot: 30, maxPerSlot: 1, notes: true }),
        M('apoio', 'form', 'Pedir apoio', 'chat', { intro: 'Explica a tua situação. Um advogado responde-te aqui.', submitLabel: 'Enviar pedido', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 2,
          fields: [F('area', 'Área', 'select', { req: true, options: ['Criminal', 'Civil', 'Família', 'Empresas', 'Trânsito'] }), F('assunto', 'Assunto', 'text', { req: true }), F('descricao', 'Descreve a situação', 'textarea', { req: true }), F('contacto', 'Telefone para contacto', 'phone')],
          statuses: [ST('recebido', 'Recebido', '#5B8CFF'), ST('aceite', 'Aceite', '#10B981'), ST('recusado', 'Recusado', '#8A8F98', true), ST('concluido', 'Concluído', '#0EA5E9', true)] }),
        M('processos', 'records', 'Processos', 'book', { subject: 'person', civilSeesOwn: true, fields: [F('processo', 'Número do processo', 'text', { req: true }), F('tribunal', 'Tribunal', 'text'), F('estado', 'Estado', 'select', { options: ['Em curso', 'Recurso', 'Ganho', 'Perdido', 'Arquivado'] }), F('notas', 'Notas', 'textarea')],
          tags: [{ id: 'urgente', label: 'Urgente', color: '#E5484D' }, { id: 'probono', label: 'Pro bono', color: '#10B981' }] }, { civil: false }),
        P.faturacao({ presets: [['Primeira consulta', 200], ['Defesa em tribunal', 1500]] }),
        M('escritorio', 'info', 'O escritório', 'info', { hero: '', blocks: [{ type: 'text', title: 'Quem somos', text: 'Defendemos os teus direitos, em tribunal e fora dele.' }, { type: 'hours', title: 'Horário', text: '', hours: { from: 9, to: 19, days: W15.slice() } }, { type: 'location', title: 'Morada', text: 'Rockford Hills, Los Santos', x: -614.5, y: -30.1 }, { type: 'contact', title: 'Contacto', text: 'Liga para marcar.', phone: '' }] }),
        P.equipa({ offDuty: true }),
      ] }) },
    { key: 'news', name: 'Notícias', desc: 'Notícias, dicas dos cidadãos e pedidos de publicidade.', make: () => appBase({
      id: 'weazel', name: 'Weazel News', subtitle: 'As notícias de Los Santos', description: 'Lê as últimas notícias e envia uma dica à redação.', glyph: 'newspaper', bg: '#DC2626', bg2: '#7F1D1D', category: 'Empresas',
      jobs: [{ name: 'reporter', minGrade: 0 }], preinstalled: true,
      modules: [
        P.comunicados({ id: 'noticias', title: 'Notícias', postGrade: 0, notifyAll: true }),
        M('dica', 'form', 'Enviar uma dica', 'send', { intro: 'Viste alguma coisa? Conta à redação. Podes ficar anónimo.', submitLabel: 'Enviar dica', anonymous: true, location: true, photo: true, civilSeesOwn: true, replies: false, deleteGrade: 1,
          fields: [F('titulo', 'Título', 'text', { req: true }), F('oque', 'O que se passou', 'textarea', { req: true }), F('onde', 'Onde', 'text')],
          statuses: [ST('recebida', 'Recebida', '#5B8CFF'), ST('analise', 'Em análise', '#F5A524'), ST('publicada', 'Publicada', '#10B981', true), ST('descartada', 'Descartada', '#8A8F98', true, false)] }),
        M('publicidade', 'form', 'Publicidade', 'tag', { intro: 'Anuncia a tua empresa no próximo bloco de notícias.', submitLabel: 'Pedir anúncio', anonymous: false, location: false, photo: true, civilSeesOwn: true, replies: true, deleteGrade: 1,
          fields: [F('empresa', 'Empresa', 'text', { req: true }), F('texto', 'Texto do anúncio', 'textarea', { req: true, max: 600 }), F('dias', 'Durante quantos dias', 'number', { min: 1, max: 30 })],
          statuses: [ST('pedido', 'Pedido', '#5B8CFF'), ST('aprovado', 'Aprovado', '#10B981', true), ST('recusado', 'Recusado', '#8A8F98', true)] }),
        P.equipa(),
      ] }) },
    { key: 'company', name: 'Empresa', desc: 'Página da empresa, candidaturas, encomendas e novidades.', make: () => appBase({
      id: 'empresa', name: 'Empresa', subtitle: 'A tua empresa no telemóvel', description: 'Conhece a empresa, candidata-te a uma vaga ou faz uma encomenda.', glyph: 'bag2', bg: '#10B981', bg2: '#065F46', category: 'Empresas',
      jobs: [{ name: 'empresa', minGrade: 0 }],
      modules: [
        P.sobre({ text: 'Escreve aqui a apresentação da empresa.' }), P.candidatura(),
        M('encomendas', 'form', 'Encomendas', 'cart', { intro: 'Diz-nos o que precisas e onde entregar.', submitLabel: 'Fazer encomenda', anonymous: false, location: true, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 1,
          fields: [F('produto', 'O que queres encomendar', 'textarea', { req: true }), F('quantidade', 'Quantidade', 'number', { min: 1 }), F('entrega', 'Local de entrega', 'text')],
          statuses: [ST('pedida', 'Pedida', '#5B8CFF'), ST('preparar', 'Em preparação', '#F5A524'), ST('entregue', 'Entregue', '#10B981', true), ST('cancelada', 'Cancelada', '#8A8F98', true)] }),
        P.comunicados({ id: 'novidades', title: 'Novidades' }), P.equipa(),
      ] }) },
    { key: 'blank', name: 'Em branco', desc: 'Só um formulário simples, para construíres à tua maneira.', make: () => appBase({
      id: 'nova_app', name: 'Nova app', subtitle: '', description: '', glyph: 'grid', bg: '#1F5EFF', bg2: '#0B2A8A', category: 'Serviços públicos', jobs: [],
      modules: [M('pedidos', 'form', 'Pedidos', 'flag', { intro: '', submitLabel: 'Enviar', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 0, fields: [F('assunto', 'Assunto', 'text', { req: true }), F('mensagem', 'Mensagem', 'textarea', { req: true })], statuses: DEF_STATUSES() })],
    }) },
  ];
  /* módulo vazio de um tipo (o botão "Em branco" de cada tipo na biblioteca) */
  function newModule(type, taken) {
    const base = { form: 'formulario', appointments: 'marcacoes', dispatch: 'pedidos', records: 'fichas', posts: 'comunicados', roster: 'equipa', info: 'pagina', catalog: 'catalogo', billing: 'faturacao', duty: 'servico' }[type] || type;
    const id = uniqId(base, taken);
    const t = MTYPES[type];
    const o = {
      form: () => ({ intro: '', submitLabel: 'Enviar', anonymous: false, location: false, photo: false, civilSeesOwn: true, replies: true, deleteGrade: 0, fields: [F('assunto', 'Assunto', 'text', { req: true }), F('mensagem', 'Mensagem', 'textarea', { req: true })], statuses: DEF_STATUSES() }),
      appointments: () => ({ services: [{ id: 'consulta', label: 'Consulta', minutes: 30 }], hours: { from: 9, to: 18 }, days: W15.slice(), slot: 30, maxPerSlot: 1, notes: true }),
      dispatch: () => ({ types: [{ id: 'ajuda', label: 'Pedir ajuda', icon: 'bolt' }], location: true, cooldown: 60 }),
      records: () => ({ subject: 'person', civilSeesOwn: false, fields: [F('notas', 'Notas', 'textarea')], tags: [] }),
      posts: () => ({ postGrade: 0, notifyAll: false, audience: 'all', pinLimit: 3 }),
      roster: () => ({ showOffDuty: false }),
      info: () => ({ hero: '', blocks: [{ type: 'text', title: 'Sobre nós', text: '' }] }),
      catalog: () => ({ orderable: true, billing: false, location: false, maxQty: 10, currency: cur$(), categories: [], items: [I('artigo', 'Artigo', 10, '')], fields: [], statuses: ORDER_STATUSES() }),
      billing: () => ({ society: true, maxAmount: Math.min(100000, billMax()), presets: [], reasonRequired: true }),
      duty: () => ({ esxOffPrefix: 'off', showTeam: true }),
    }[type]();
    return M(id, type, t.label === 'Página de informação' ? 'Informações' : t.label, t.icon, o, { civil: type !== 'records' });
  }
  SEC.capps = (() => {
    let pageEl = null, listView = null, edView = null, grid = null, emptyEl = null, ed = null, q = '';
    const apps = () => boot.capps;
    const stats = id => obj(obj(obj(boot.stats).capps)[id]);
    const maxApps = () => Number(boot.limits.maxApps) || 40, maxMods = () => Number(boot.limits.maxModules) || 10;

    /* ---------- empregos e graus do framework (OVRPC admin.capps.jobs, server/capps.lua).
       Sem resposta, o construtor continua: nome do emprego em texto livre e grau numérico. ---------- */
    let JOBS = null, jobsP = null;   /* null = ainda não chegou, false = falhou, [] = lista */
    function normJob(j) {
      const name = String(j.name || '').trim(); if (!name) return null;
      const grades = arr(j.grades).map((g, i) => isObj(g) ? { level: Number(g.level != null ? g.level : (g.grade != null ? g.grade : i)) || 0, label: String(g.label || g.name || '') } : { level: i, label: String(g || '') })
        .filter(g => g.level >= 0 && g.level <= 99).sort((a, b) => a.level - b.level);
      return { name, label: String(j.label || name), grades };
    }
    function loadJobs() {
      if (JOBS !== null) return Promise.resolve(JOBS);
      if (!jobsP) jobsP = call('admin.capps.jobs', {}, { quiet: true, timeout: 8000 }).then(r => {
        JOBS = r && r.ok && (Array.isArray(r.jobs) || isObj(r.jobs)) ? arr(r.jobs).filter(isObj).map(normJob).filter(Boolean).sort((a, b) => a.label.localeCompare(b.label)) : false;
        jobsP = null;
        if (ed && ed.jobSync) ed.jobSync.forEach(f => { try { f(); } catch (e) { console.error('[apex_phone] admin jobs', e); } });
        return JOBS;
      });
      return jobsP;
    }
    const jobOf = name => (JOBS ? JOBS.find(j => j.name === name) : null) || null;
    const jobSync = fn => { if (ed) (ed.jobSync = ed.jobSync || []).push(fn); };
    /* graus de uma lista de empregos: os níveis de todos, com os nomes de cada emprego. null = sem dados (campo numérico) */
    function gradeOpts(names) {
      if (!JOBS) return null;
      const known = names.map(jobOf).filter(Boolean); if (!known.length) return null;
      const lv = new Map();
      known.forEach(j => j.grades.forEach(g => { const l = lv.get(g.level) || []; if (g.label && !l.includes(g.label)) l.push(g.label); lv.set(g.level, l); }));
      if (!lv.size) return null;
      return [...lv.keys()].sort((a, b) => a - b).map(k => ({ v: k, l: `${k} · ${lv.get(k).join(' / ') || T('Grau')}` }));
    }
    /* grau mínimo: lista com os nomes reais quando o framework os dá; senão número (0 a 99) */
    function gradeCtl(get, set, names, o = {}) {
      const w = h('<div class="pad-gctl"></div>');
      let sig = null, inner = null;
      const opts = () => { const op = gradeOpts(names()) || []; const v = get(); if (v != null && op.length && !op.some(x => x.v === v)) op.push({ v, l: TF('%s · não existe neste emprego', v) }); return op; };
      const sync = () => {
        const op = gradeOpts(names());
        const s = op ? op.map(x => x.v + x.l).join('|') : 'num';
        if (s !== sig) {
          sig = s; w.textContent = '';
          inner = op ? dd(opts, get, v => set(v), { noi18n: true, small: !!o.small }) : numCtl({ get, set, min: 0, max: 99, step: 1, slider: false, compact: true });
          w.appendChild(inner);
        } else if (inner && inner.sync) inner.sync();
      };
      w.sync = sync; sync(); jobSync(sync);
      return w;
    }
    /* emprego: botão com pesquisa na lista do framework, ou texto livre quando a lista não veio */
    function jobCtl(get, set) {
      const w = h('<div class="pad-jctl"></div>');
      let mode = null, inner = null;
      const paintB = () => {
        const n = get(), j = jobOf(n);
        inner.querySelector('b').textContent = n ? (j ? j.label : n) : T('Escolher emprego');
        inner.querySelector('code').textContent = n ? (j ? n : T('não está no framework')) : '';
        inner.classList.toggle('ph', !n); inner.classList.toggle('warn', !!n && !j);
      };
      const sync = () => {
        const m = JOBS ? 'list' : 'text';
        if (m !== mode) {
          mode = m; w.textContent = '';
          if (m === 'text') inner = txt(get, x => set(x), { max: 40, mono: true, ph: 'police', filter: x => x.replace(/[^\w-]/g, '') });
          else {
            inner = h(`<button type="button" class="pad-dd pad-jbtn"><span class="pad-jbtn-v" data-noi18n><b></b><code></code></span>${ic('chevD', 14)}</button>`);
            inner.onclick = e => { e.stopPropagation(); jobPick(inner, get(), v => { set(v); paintB(); }); };
          }
          w.appendChild(inner);
        }
        if (mode === 'list') paintB(); else inner.sync();
      };
      w.sync = sync; sync(); jobSync(sync);
      return w;
    }
    function jobPick(anchor, curName, onPick) {
      const box = h(`<div class="pad-jpick"><div class="pad-gpick-s">${ic('search', 14)}<input class="ovk-in pad-in" placeholder="Pesquisar emprego" spellcheck="false"></div><div class="pad-jpick-l"></div></div>`);
      const list = box.querySelector('.pad-jpick-l'), q2 = box.querySelector('input');
      const taken = new Set(ed ? ed.draft.audience.jobs.map(j => j.name) : []);
      const rows = (JOBS || []).map(j => {
        const b = h(`<button type="button" class="pad-jrow${j.name === curName ? ' on' : ''}"><span class="pad-jrow-t" data-noi18n><b></b><code></code></span><small></small></button>`);
        b.querySelector('b').textContent = j.label; b.querySelector('code').textContent = j.name;
        b.querySelector('small').textContent = j.grades.length === 1 ? T('1 grau') : TF('%s graus', j.grades.length);
        if (taken.has(j.name) && j.name !== curName) { b.disabled = true; b.querySelector('small').textContent = T('Já está na app'); }
        b.dataset.q = (j.label + ' ' + j.name).toLowerCase();
        b.onclick = () => { onPick(j.name); closePop(); };
        list.appendChild(b); return b;
      });
      const custom = h(`<button type="button" class="pad-jrow custom" hidden><span class="pad-jrow-t"><b data-noi18n></b></span><small>Usar este nome</small></button>`);
      list.appendChild(custom);
      const none = h('<div class="pad-empty" hidden>Nenhum emprego encontrado.</div>'); list.appendChild(none);
      q2.addEventListener('input', () => {
        const s = q2.value.trim().toLowerCase(); let n = 0;
        rows.forEach(r => { r.hidden = !!s && !r.dataset.q.includes(s); if (!r.hidden) n++; });
        const raw = q2.value.trim().replace(/[^\w-]/g, '').slice(0, 40);
        custom.hidden = !raw || (JOBS || []).some(j => j.name === raw);
        custom.querySelector('b').textContent = raw; custom.onclick = () => { onPick(raw); closePop(); };
        none.hidden = n > 0 || !custom.hidden;
      });
      pop(anchor, box, { cls: 'pad-pop-j', width: Math.max(anchor.offsetWidth, 300) });
      setTimeout(() => q2.focus(), 30);
    }

    /* ---------- lista ---------- */
    function appCard(a) {
      const e = h(`<div class="pad-ca" data-id="${esc(a.id)}"><span class="pad-grip" title="Arrastar para reordenar">${ic('moreV', 14)}</span><span class="pad-ca-ic"></span><div class="pad-ca-t"><b data-noi18n></b><small data-noi18n></small><div class="pad-ca-chips"></div></div><div class="pad-ca-n"><b data-noi18n></b><small>em aberto</small></div><span class="pad-ca-go">${ic('chevR', 16)}</span></div>`);
      e._id = a.id; paintCard(e, a);
      e.addEventListener('click', ev => { if (ev.target.closest('.pad-grip')) return; edit(e._id); });
      return e;
    }
    function paintCard(e, a) {
      e.querySelector('.pad-ca-ic').innerHTML = cappIconHTML(a, 48);
      e.querySelector('.pad-ca-t b').textContent = a.name;
      e.querySelector('.pad-ca-t small').textContent = a.subtitle || a.id;
      const ch = e.querySelector('.pad-ca-chips'); ch.textContent = '';
      ch.appendChild(a.enabled === false ? chip('Desligada', { kind: 'bad' }) : chip('Ligada', { kind: 'ok', dot: 'var(--k-ok)' }));
      ch.appendChild(chip(a.category || '', {}));
      const mods = arr(a.modules); ch.appendChild(chip(mods.length === 1 ? T('1 módulo') : TF('%s módulos', mods.length)));
      const jobs = arr(obj(a.audience).jobs).map(j => j.name).filter(Boolean);
      if (jobs.length) ch.appendChild(chip(jobs.join(', '), { noi18n: true, kind: 'mono' }));
      if (obj(a.audience).public === false) ch.appendChild(chip('Só a equipa', { kind: 'warn' }));
      const s = stats(a.id); e.querySelector('.pad-ca-n b').textContent = fmtN(s.open || 0); e.querySelector('.pad-ca-n').classList.toggle('hot', (s.open || 0) > 0);
    }
    function paintList() {
      emptyEl.hidden = apps().length > 0;
      grid.hidden = !apps().length;
      if (listView && listView._more) listView._more.hidden = !apps().length;
      if (listView && listView._sum) listView._sum.textContent = TF('%s de %s apps', apps().length, maxApps());
      navCount('capps', apps().length);
      applyQ();
    }
    function applyQ() { if (!grid) return; [...grid.children].forEach(e => { e.hidden = !!q && !e.textContent.toLowerCase().includes(q) && !String(e._id).includes(q); }); }
    function gallery(onPick, compact) {
      const g = h(`<div class="pad-tpls${compact ? ' compact' : ''}"></div>`);
      TEMPLATES.forEach(t => {
        const d = t.make();
        /* div e não <button>: a grelha dentro de um <button> mede mal a altura no Chromium e os módulos saíam do cartão */
        const c = h(`<div role="button" tabindex="0" class="pad-tpl ovk-tile"><span class="ovk-corners"></span><span class="pad-tpl-ic">${cappIconHTML(d, 44)}</span><b></b><small></small><span class="pad-tpl-mods"></span></div>`);
        c.querySelector('b').textContent = t.name; c.querySelector('small').textContent = t.desc;
        const ms = c.querySelector('.pad-tpl-mods');
        d.modules.slice(0, 6).forEach(m => { const x = h(`<span class="pad-tpl-m">${glyph(m.icon, 12)}<span></span></span>`); x.querySelector('span').textContent = m.title; ms.appendChild(x); });
        if (d.modules.length > 6) { const x = h('<span class="pad-tpl-m more" data-noi18n></span>'); x.textContent = '+' + (d.modules.length - 6); x.title = d.modules.slice(6).map(m => m.title).join(', '); ms.appendChild(x); }
        c.onclick = () => onPick(t);
        c.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onPick(t); } });
        g.appendChild(c);
      });
      return g;
    }
    /* os modelos estao escritos em portugues (a fonte do dicionario): uma app criada com o jogo noutro idioma nasce ja traduzida
       (titulos, perguntas, estados, servicos, blocos). Ids, cores, icones, categorias, moeda, empregos e permissoes ficam como estao. */
    const TPL_KEEP = new Set(['id', 'key', 'glyph', 'icon', 'bg', 'bg2', 'fg', 'accent', 'color', 'image', 'url', 'hero', 'type', 'category', 'name', 'phone', 'value', 'subject', 'currency', 'esxOffPrefix']);
    function trDeep(v, k) {
      if (typeof v === 'string') return (k && TPL_KEEP.has(k)) || !(window.L && L.t) ? v : L.t(v);
      if (Array.isArray(v)) return v.map(x => trDeep(x, k === 'options' || k === 'days' ? k : null));
      if (v && typeof v === 'object') { const o = {}; Object.keys(v).forEach(x => { o[x] = (x === 'audience' || x === 'webhooks' || x === 'jobs' || x === 'perms') ? v[x] : trDeep(v[x], x); }); return o; }
      return v;
    }
    /* catálogo: a categoria de cada artigo é o mesmo texto da lista de categorias (traduz-se igual) */
    function trMod(m) {
      const t = trDeep(m);
      if (t.type === 'catalog' && window.L && L.t) arr(obj(t.options).items).forEach(it => { if (it.category) it.category = L.t(it.category); });
      return t;
    }
    async function newFrom(t) {
      closeDlg(false); closeTpl();
      if (apps().length >= maxApps()) { toast(ERR.limit, 'err'); return; }
      if (!(await guard())) return;
      const src = t.make();
      const d = trDeep(src); d.modules = src.modules.map(trMod);
      d.name = window.L && L.t ? L.t(d.name) : d.name;
      const taken = apps().map(a => a.id);
      d.id = uniqId(d.id, taken);
      if (taken.length && d.id !== src.id) d.name = d.name.slice(0, 20) + ' ' + d.id.split('_').pop();
      open(d, true);
    }
    /* camadas grandes desta secção (modelos, biblioteca de módulos, JSON): uma de cada vez, o Esc fecha */
    let tplEl = null;
    function closeTpl() { if (!tplEl) return false; const x = tplEl; tplEl = null; x.classList.add('out'); setTimeout(() => x.remove(), 160); return true; }
    function bigDlg(title, sub, body, o = {}) {
      closeTpl();
      const d = h(`<div class="pad-dlg-wrap"><div class="pad-dlg ${o.cls || 'wide'}"><header class="pad-dlg-h"><div><h3></h3>${sub ? '<p></p>' : ''}</div><button type="button" class="pad-ib" title="Fechar">${ic('x', 16)}</button></header></div></div>`);
      d.querySelector('h3').textContent = title; if (sub) d.querySelector('.pad-dlg-h p').textContent = sub;
      d.querySelector('.pad-dlg').appendChild(body);
      if (o.foot) { const f = h('<footer class="pad-dlg-f"></footer>'); o.foot.forEach(b => b && f.appendChild(b)); d.querySelector('.pad-dlg').appendChild(f); }
      d.querySelector('.pad-dlg-h .pad-ib').onclick = closeTpl;
      d.addEventListener('pointerdown', e => { if (e.target === d) closeTpl(); });
      layerEl.appendChild(d); tplEl = d;
      return d;
    }
    function pickTemplate() {
      const body = gallery(newFrom);
      bigDlg(T('Nova app de trabalho'), T('Escolhe um modelo para começar. Fica tudo editável: módulos, campos, estados, cores e quem a vê.'), body);
    }

    /* ---------- importar e exportar (JSON). Os webhooks nunca saem; o validador do servidor confere tudo ao guardar ---------- */
    function exportDef(def) {
      const out = clone(def); delete out.webhooks; delete out.created; delete out.updated;
      return JSON.stringify(out, null, 2);
    }
    function showExport() {
      const body = h('<div class="pad-json"><textarea class="ovk-in pad-in pad-ta mono" readonly spellcheck="false" data-noi18n></textarea></div>');
      const ta = body.querySelector('textarea'); ta.value = exportDef(ed.draft);
      const copyB = btn('Copiar', { kind: 'primary', icon: 'copy', on: () => {
        ta.focus(); ta.select();
        let ok = false; try { ok = document.execCommand('copy'); } catch (e) { ok = false; }
        if (!ok && navigator.clipboard) { navigator.clipboard.writeText(ta.value).then(() => toast('JSON copiado.'), () => toast('Seleciona o texto e copia com Ctrl C.', 'info')); return; }
        toast(ok ? 'JSON copiado.' : 'Seleciona o texto e copia com Ctrl C.', ok ? 'ok' : 'info');
      } });
      bigDlg(T('Exportar a app'), T('A definição completa em JSON, sem webhooks. Cola-a noutro servidor em Importar.'), body, { cls: 'mid', foot: [btn('Fechar', { kind: 'ghost', on: closeTpl }), copyB] });
      setTimeout(() => { ta.scrollTop = 0; }, 30);
    }
    /* intoEditor = substitui o rascunho da app aberta (mantém o identificador); senão cria uma app nova */
    function showImport(intoEditor) {
      const body = h('<div class="pad-json"><textarea class="ovk-in pad-in pad-ta mono" spellcheck="false" placeholder="{ &quot;name&quot;: &quot;...&quot;, &quot;modules&quot;: [ ... ] }" data-noi18n></textarea></div>');
      const ta = body.querySelector('textarea');
      const go = btn('Importar', { kind: 'primary', icon: 'download', on: async () => {
        let def;
        try { def = JSON.parse(ta.value); } catch (e) { toast('O texto não é JSON válido.', 'err'); return; }
        if (!isObj(def) || !Array.isArray(def.modules) || !def.modules.length) { toast('O texto não é uma app de trabalho (falta a lista de módulos).', 'err'); return; }
        delete def.webhooks; delete def.created; delete def.updated;
        if (intoEditor && ed) {
          if (docCount('capp') > 0 && !ed.isNew) { const ok = await confirmBox({ title: 'Substituir o rascunho?', text: 'As alterações por guardar desta app são trocadas pelo JSON importado.', ok: 'Substituir', danger: true, icon: 'info' }); if (!ok) return; }
          closeTpl(); loadDraft(def, { keepHooks: true }); toast('JSON importado. Revê e guarda.', 'info'); return;
        }
        if (apps().length >= maxApps()) { toast(ERR.limit, 'err'); return; }
        if (!(await guard())) return;
        closeTpl();
        def.id = uniqId(slugify(def.id || def.name || '') || 'app_importada', apps().map(a => a.id)).slice(0, 32);
        if (!String(def.name || '').trim()) def.name = T('App importada');
        def.webhooks = HOOKS();
        open(def, true); toast('JSON importado. Revê e guarda para criar a app.', 'info');
      } });
      bigDlg(intoEditor ? T('Importar para esta app') : T('Importar uma app'), intoEditor ? T('Cola o JSON de uma app exportada. Substitui o rascunho desta app (o identificador fica o mesmo); os webhooks ficam como estão.') : T('Cola o JSON de uma app exportada. Nasce uma app nova, por guardar.'), body, { cls: 'mid', foot: [btn('Cancelar', { kind: 'ghost', on: closeTpl }), go] });
      setTimeout(() => ta.focus(), 40);
    }

    function buildList(v) {
      listView = h('<div class="pad-capps-list"></div>');
      listView.appendChild(head('Apps de trabalho', 'Apps do servidor para os empregos: denúncias, marcações, pedidos, fichas, menus e encomendas, faturas, serviço e a equipa. Aparecem na AppShop para quem as pode ver.', [
        btn('Importar', { kind: 'ghost', icon: 'download', on: () => showImport(false) }),
        btn('Nova app', { kind: 'primary', icon: 'plus', on: () => pickTemplate() }),
      ]));
      const note = h('<div class="pad-sum"></div>'); listView._sum = note;
      listView.appendChild(note);
      grid = h('<div class="pad-cas"></div>');
      apps().forEach(a => grid.appendChild(appCard(a)));
      sortable(grid, { handle: '.pad-grip', item: '.pad-ca', onMove: async (a, b) => {
        moveIn(boot.capps, a, b);
        const r = await call('admin.capps.order', { ids: boot.capps.map(x => x.id) });
        if (r.ok) toast('Ordem guardada.', 'info');
      } });
      listView.appendChild(grid);
      emptyEl = h('<div class="pad-capps-empty"><div class="pad-capps-empty-t"><h2>Cria a primeira app de trabalho</h2><p>Começa por um modelo. Depois mudas tudo: nomes, cores, módulos, campos e quem a vê.</p></div></div>');
      emptyEl.appendChild(gallery(newFrom, true));
      listView.appendChild(emptyEl);
      /* com apps já criadas, os modelos ficam por baixo da lista (a mesma galeria do "Nova app") */
      const more = h('<div class="pad-capps-more"><div class="pad-sub-h">Começar a partir de um modelo</div></div>');
      more.appendChild(gallery(newFrom, true)); listView.appendChild(more); listView._more = more;
      v.appendChild(listView);
      paintList();
    }

    /* ---------- editor ---------- */
    async function guard() {
      if (!ed || docCount('capp') === 0) return true;
      return confirmBox({ title: 'Descartar as alterações?', text: TF('A app %s tem alterações por guardar.', ed.draft.name || ed.draft.id), ok: 'Descartar', cancel: 'Continuar a editar', danger: true, icon: 'info' });
    }
    async function edit(id) {
      const a = apps().find(x => x.id === id); if (!a) return;
      if (ed && ed.draft.id === id && !ed.isNew) { show(); return; }
      if (!(await guard())) return;
      open(clone(a), false);
    }
    async function home() { if (!(await guard())) return; close(); }
    function close() {
      ed = null; delete docs.capp;
      if (edView) { edView.remove(); edView = null; }
      listView.hidden = false;
      const sc = pageEl.closest('.pad-scroll'); if (sc) sc.scrollTop = 0;
      crumbs(); touch();
    }
    function show() { if (listView) listView.hidden = !!ed; if (edView) edView.hidden = !ed; crumbs(); touch(); }
    function normFields(o) {
      o.fields = arr(o.fields).filter(isObj);
      o.fields.forEach(f => {
        if (f.type === 'select' || f.type === 'multiselect') f.options = arr(f.options);
        if (f.type === 'multiselect' && f.default != null) f.default = arr(f.default);
        if (f.showIf != null && !isObj(f.showIf)) delete f.showIf;
      });
    }
    function normStatuses(o) { o.statuses = arr(o.statuses).filter(isObj); o.statuses.forEach(s => { if (s.notify === undefined) s.notify = true; }); }
    function normDef(d) {
      d.icon = Object.assign({ glyph: 'grid', bg: '#1F5EFF', bg2: '#0B2A8A', fg: '#FFFFFF', image: '' }, obj(d.icon));
      d.audience = Object.assign({ public: true, jobs: [], onDutyOnly: false }, obj(d.audience)); d.audience.jobs = arr(d.audience.jobs).filter(isObj);
      d.contact = Object.assign({ phone: '', label: '' }, obj(d.contact)); d.notify = Object.assign({ staff: true }, obj(d.notify));
      d.webhooks = Object.assign(HOOKS(), obj(d.webhooks)); d.webhooks.events = Object.assign(HOOKS().events, obj(d.webhooks.events)); d.webhooks.urls = obj(d.webhooks.urls);
      ['enabled', 'listed'].forEach(k => { d[k] = d[k] !== false; }); d.preinstalled = !!d.preinstalled;
      d.modules = arr(d.modules).filter(m => isObj(m) && MTYPES[m.type]).map(m => {
        m.options = obj(m.options); m.enabled = m.enabled !== false; m.civil = m.civil !== false; m.staff = m.staff !== false; m.staffMinGrade = Number(m.staffMinGrade) || 0;
        if (m.type === 'billing' || m.type === 'duty') m.civil = false;
        if (m.jobs != null) { m.jobs = arr(m.jobs).filter(x => typeof x === 'string' && x); if (!m.jobs.length) delete m.jobs; }
        if (m.perms != null && !isObj(m.perms)) delete m.perms;
        const o = m.options;
        if (m.type === 'form' || m.type === 'records' || m.type === 'catalog') normFields(o);
        if (m.type === 'form' || m.type === 'catalog') normStatuses(o);
        if (m.type === 'records') o.tags = arr(o.tags).filter(isObj);
        if (m.type === 'appointments') { o.services = arr(o.services).filter(isObj); o.hours = Object.assign({ from: 9, to: 18 }, obj(o.hours)); o.days = arr(o.days); }
        if (m.type === 'dispatch') o.types = arr(o.types).filter(isObj);
        if (m.type === 'posts') { o.audience = o.audience === 'staff' ? 'staff' : 'all'; if (o.pinLimit == null) o.pinLimit = 3; if (o.audience === 'staff') m.civil = false; }
        if (m.type === 'catalog') { o.items = arr(o.items).filter(isObj); o.categories = arr(o.categories).filter(x => typeof x === 'string'); if (!o.currency) o.currency = cur$(); if (o.maxQty == null) o.maxQty = 10; }
        if (m.type === 'billing') { o.presets = arr(o.presets).filter(isObj); if (o.maxAmount == null) o.maxAmount = Math.min(100000, billMax()); }
        if (m.type === 'duty' && o.esxOffPrefix == null) o.esxOffPrefix = 'off';
        if (m.type === 'info') { o.blocks = arr(o.blocks).filter(isObj); o.blocks.forEach(b => { if (b.type === 'hours') { b.hours = Object.assign({ from: 9, to: 18 }, obj(b.hours)); b.hours.days = arr(b.hours.days); } }); }
        return m;
      });
      return d;
    }
    function open(def, isNew) {
      normDef(def);
      const saved = clone(def);
      ed = { draft: def, orig: isNew ? null : saved, isNew, tab: ed && ed.tab && !isNew ? ed.tab : 'identity', pvRole: 'civil', pvMod: 0, pvDark: false };
      docs.capp = {
        get label() { return ed ? (ed.isNew ? T('Nova app de trabalho') : TF('App de trabalho · %s', ed.draft.name || ed.draft.id)) : ''; },
        saved, get draft() { return ed ? ed.draft : saved; },
        count() { if (!ed) return 0; const n = countDiff(this.saved, ed.draft); return ed.isNew ? Math.max(1, n) : n; },
        text: () => (ed && ed.isNew ? T('App nova, ainda por criar') : null),
        save: () => saveApp(),
        discard: () => { if (!ed) return; if (ed.isNew) { close(); return; } const tab = ed.tab; open(clone(ed.orig), false); ed.tab = tab; },
      };
      buildEditor();
    }
    /* troca o rascunho por outra definição (versão antiga ou JSON importado) sem mexer no que está guardado:
       o contador mostra a diferença e o admin guarda quando quiser */
    function loadDraft(def, o = {}) {
      def = normDef(clone(def));
      def.id = ed.isNew ? ed.draft.id : ed.orig.id;
      ['created', 'updated'].forEach(k => { if (ed.draft[k] !== undefined) def[k] = ed.draft[k]; else delete def[k]; });
      if (o.keepHooks) def.webhooks = clone(ed.draft.webhooks);
      ed.draft = def; ed.pvMod = 0;
      buildEditor();
    }
    async function saveApp() {
      const d = clone(ed.draft);
      const r = await call('admin.capps.save', { app: d, isNew: ed.isNew });
      if (!r.ok) {
        if (r.error === 'id' || r.error === 'exists' || r.error === 'name') pickEdTab('identity');
        else if (['fields', 'services', 'types', 'hours', 'days', 'modules', 'items', 'price', 'preset', 'amount', 'prefix', 'range', 'showif'].includes(r.error)) pickEdTab('modules');
        else if (r.error === 'webhook') pickEdTab('hooks');
        return;
      }
      const clean = obj(r.app && r.app.id ? r.app : d);
      const i = boot.capps.findIndex(x => x.id === clean.id);
      if (i >= 0) boot.capps[i] = clean; else boot.capps.push(clean);
      const card0 = grid && [...grid.children].find(e => e._id === clean.id);
      if (card0) paintCard(card0, clean); else if (grid) grid.appendChild(appCard(clean));
      paintList();
      const strip = x => { const c = normDef(clone(x)); delete c.created; delete c.updated; return c; };
      const tab = ed.tab, wasNew = ed.isNew, differs = countDiff(strip(clean), strip(d)) > 0;
      if (differs || wasNew) { open(clone(clean), false); ed.tab = tab; pickEdTab(tab); }
      else { ed.draft.created = clean.created; ed.draft.updated = clean.updated; ed.orig = clone(ed.draft); docs.capp.saved = clone(ed.draft); paintHead(); }
      toast(wasNew ? 'App criada. Já aparece na AppShop para quem a pode ver.' : 'App guardada. Os telemóveis atualizam-se sozinhos.');
    }
    function pickEdTab(t) { if (ed && ed.tabs) ed.tabs.pick(t); }

    /* histórico de versões (as últimas guardadas no servidor); restaurar = carregar no editor por guardar */
    async function showHistory() {
      const box = h('<div class="pad-hist"><div class="pad-empty">A carregar as versões...</div></div>');
      sheet(T('Histórico de versões'), box, { sub: TF('%s · as últimas %s versões guardadas', ed.draft.name || ed.draft.id, Number(boot.limits.histKeep) || 10) });
      const id = ed.orig.id;
      const r = await call('admin.capps.history', { id }, { quiet: true });
      if (!ed || ed.isNew || ed.orig.id !== id) return;
      box.textContent = '';
      if (!r.ok) { const e = h('<div class="pad-empty"></div>'); e.textContent = errMsg(r); box.appendChild(e); return; }
      const items = arr(r.items).filter(isObj);
      if (!items.length) { box.appendChild(h('<div class="pad-empty">Ainda não há versões guardadas desta app. Cada vez que guardas, fica aqui uma versão.</div>')); return; }
      items.forEach((it, i) => {
        const e = h(`<div class="pad-hist-i${i === 0 ? ' cur' : ''}"><span class="pad-hist-dot"></span><div class="pad-hist-t"><b data-noi18n></b><small data-noi18n></small></div><div class="pad-hist-a"></div></div>`);
        e.querySelector('b').textContent = fmtDate(it.at) + ' · ' + ago(it.at);
        e.querySelector('small').textContent = [it.by || T('Antes do histórico'), Number(it.modules) === 1 ? T('1 módulo') : TF('%s módulos', fmtN(it.modules || 0)), it.name || ''].filter(Boolean).join(' · ');
        const a = e.querySelector('.pad-hist-a');
        if (i === 0) a.appendChild(chip('Versão atual', { kind: 'ok', dot: 'var(--k-ok)' }));
        else a.appendChild(btn('Restaurar', { kind: 'ghost', sm: true, icon: 'update', on: async b => {
          if (docCount('capp') > 0) { const ok = await confirmBox({ title: 'Substituir as alterações por guardar?', text: 'O rascunho desta app passa a ser a versão escolhida.', ok: 'Restaurar', danger: true, icon: 'update' }); if (!ok) return; }
          b.disabled = true;
          const rr = await call('admin.capps.restore', { id, at: it.at });
          b.disabled = false;
          if (!rr.ok || !isObj(rr.app) || !ed || ed.orig.id !== id) return;
          closeSheet(); loadDraft(rr.app);
          toast(TF('Versão de %s carregada. Guarda para a repor.', fmtDate(it.at)), 'info');
        } }));
        box.appendChild(e);
      });
    }

    function buildEditor() {
      if (edView) edView.remove();
      listView.hidden = true;
      closeTpl();
      const d = ed.draft;
      ed.jobSync = []; ed.modJobSync = [];
      edView = h(`<div class="pad-ed"><div class="pad-ed-main"><div class="pad-ed-head"><button type="button" class="pad-back">${ic('chevL', 16)}<span>Apps de trabalho</span></button><div class="pad-ed-id"><span class="pad-ed-ic"></span><div class="pad-ed-tt"><h1 data-noi18n></h1><p></p></div></div><div class="pad-ed-act"></div></div><div class="pad-ed-tabs"></div><div class="pad-ed-panes"></div></div><aside class="pad-ed-side"></aside></div>`);
      pageEl.appendChild(edView);
      edView.querySelector('.pad-back').onclick = () => home();
      const act = edView.querySelector('.pad-ed-act');
      if (!ed.isNew) {
        act.appendChild(btn('Histórico', { kind: 'ghost', sm: true, icon: 'clock', on: () => showHistory() }));
        act.appendChild(btn('Duplicar', { kind: 'ghost', sm: true, icon: 'copy', on: async () => {
          if (apps().length >= maxApps()) { toast(ERR.limit, 'err'); return; }
          if (!(await guard())) return;
          const c = clone(ed.orig); c.id = uniqId(c.id.slice(0, 28) + '_2', apps().map(x => x.id)); c.name = String(c.name).slice(0, 18) + ' 2'; delete c.created; delete c.updated;
          open(c, true); toast('Cópia criada. Guarda para ficar.', 'info');
        } }));
      }
      const more = h(`<button type="button" class="pad-ib pad-ed-more" title="Mais ações">${ic('more', 16)}</button>`);
      more.onclick = e => {
        e.stopPropagation();
        menu(more, [
          { label: T('Exportar JSON'), sub: T('Copiar a definição da app (sem webhooks).'), icon: 'share', act: () => showExport() },
          { label: T('Importar JSON'), sub: T('Substituir o rascunho por uma app exportada.'), icon: 'download', act: () => showImport(true) },
        ].concat(ed.isNew ? [] : [{ sep: true }, { label: T('Apagar a app'), icon: 'trash', danger: true, act: () => removeApp() }]), { alignRight: true, width: 300 });
      };
      act.appendChild(more);
      paintHead();
      const panes = {}, host = edView.querySelector('.pad-ed-panes');
      ed.tabs = tabs([{ id: 'identity', label: 'Identidade' }, { id: 'access', label: 'Acesso' }, { id: 'modules', label: 'Módulos' }, { id: 'hooks', label: 'Webhooks' }].concat(ed.isNew ? [] : [{ id: 'data', label: 'Dados' }]), id => {
        ed.tab = id;
        if (!panes[id]) { const p = h(`<div class="pad-pane" data-p="${id}"></div>`); host.appendChild(p); panes[id] = p; ED[id](p); }
        Object.keys(panes).forEach(k => { panes[k].hidden = k !== id; });
        if (id === 'modules') syncModJobs();
      });
      edView.querySelector('.pad-ed-tabs').appendChild(ed.tabs);
      ed.tabs.badge('modules', d.modules.length);
      buildPreview(edView.querySelector('.pad-ed-side'));
      ed.tabs.pick(ed.tab || 'identity');
      const sc = pageEl.closest('.pad-scroll'); if (sc) sc.scrollTop = 0;
      crumbs(); touch();
      loadJobs();
    }
    async function removeApp() {
      const ok = await confirmBox({ title: TF('Apagar %s?', ed.orig.name), text: 'A app desaparece de todos os telemóveis. Os registos que já existem ficam na base de dados até os apagares nos Dados. O histórico de versões desta app também é apagado.', ok: 'Apagar app', danger: true });
      if (!ok) return;
      const id = ed.orig.id;
      const r = await call('admin.capps.remove', { id }); if (!r.ok) return;
      boot.capps = boot.capps.filter(x => x.id !== id);
      const c0 = grid && [...grid.children].find(e => e._id === id); if (c0) c0.remove();
      paintList();
      close(); toast('App apagada.');
    }
    function paintHead() {
      if (!edView) return;
      const d = ed.draft;
      const icw = edView.querySelector('.pad-ed-ic');
      if (!icw.firstChild) icw.innerHTML = cappIconHTML(d, 44);
      paintCappIcon(icw.firstChild, d);
      edView.querySelector('.pad-ed-tt h1').textContent = d.name || T('Sem nome');
      const p = edView.querySelector('.pad-ed-tt p'); p.textContent = '';
      p.appendChild(h(`<code data-noi18n>${esc(d.id)}</code>`));
      p.appendChild(chip(ed.isNew ? 'Por criar' : (d.enabled ? 'Ligada' : 'Desligada'), { kind: ed.isNew ? 'warn' : d.enabled ? 'ok' : 'bad', dot: ed.isNew ? null : d.enabled ? 'var(--k-ok)' : null }));
    }
    /* qualquer alteração no editor: conta, cabeçalho e pré-visualização (a pré-visualização refaz-se aos poucos) */
    const pvLater = debounce(() => paintPreview(), 60);
    function changed(o = {}) { touch(); if (o.head) { paintHead(); crumbs(); } pvLater(); }
    /* os módulos dependem dos empregos da app (chips e graus): repinta-se ao mudar os empregos e ao abrir o separador */
    function syncModJobs() { if (ed && ed.modJobSync) ed.modJobSync.forEach(f => { try { f(); } catch (e) { console.error(e); } }); }
    const modJobNames = m => (m.jobs && m.jobs.length ? m.jobs : ed.draft.audience.jobs.map(j => j.name)).filter(Boolean);

    const ED = {
      identity(p) {
        const d = ed.draft;
        const c1 = card('Identidade', { icon: 'info', sub: 'Como a app aparece no ecrã principal e na AppShop.' });
        const g = h('<div class="pad-grid g2"></div>');
        g.appendChild(fld('Nome', txt(() => d.name, x => { d.name = x; changed({ head: true }); }, { max: 24, ph: 'Ex.: LSPD' }), { req: true, hint: 'Até 24 letras. É o nome por baixo do ícone.' }));
        g.appendChild(fld('Identificador', txt(() => d.id, x => { d.id = x; changed({ head: true }); }, { max: 32, mono: true, disabled: !ed.isNew, filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, ''), valid: x => /^[a-z0-9_]{2,32}$/.test(x) }), { req: true, hint: ed.isNew ? 'Letras minúsculas, números e _. Não muda depois de criada.' : 'Não muda depois de criada.' }));
        g.appendChild(fld('Subtítulo', txt(() => d.subtitle, x => { d.subtitle = x; changed(); }, { max: 60, ph: 'Ex.: Polícia de Los Santos' })));
        g.appendChild(fld('Categoria na AppShop', seg(boot.categories.map(c => ({ v: c, l: c })), () => d.category, x => { d.category = x; changed(); }, { small: true })));
        g.appendChild(fld('Descrição', txt(() => d.description, x => { d.description = x; changed(); }, { max: 300, area: true, rows: 3, ph: 'O que a app faz, em duas linhas. Aparece na AppShop.' }), { span: 2 }));
        c1.body.appendChild(g); p.appendChild(c1.el);
        const c2 = card('Ícone e cores', { icon: 'sparkles', sub: 'O ícone usa o glifo sobre um gradiente. A cor de destaque pinta botões e separadores.' });
        const ig = h('<div class="pad-icoed"><div class="pad-icoed-pv"></div><div class="pad-grid g3"></div></div>');
        const big = ig.querySelector('.pad-icoed-pv'); big.innerHTML = cappIconHTML(d, 96);
        const repaint = () => { paintCappIcon(big.firstChild, d); changed({ head: true }); };
        const gg = ig.querySelector('.pad-grid');
        gg.appendChild(fld('Glifo', glyphCtl(() => d.icon.glyph, x => { d.icon.glyph = x; repaint(); })));
        gg.appendChild(fld('Fundo', colorCtl(() => d.icon.bg, x => { d.icon.bg = x; repaint(); })));
        gg.appendChild(fld('Fundo (fim do gradiente)', colorCtl(() => d.icon.bg2, x => { d.icon.bg2 = x; repaint(); })));
        gg.appendChild(fld('Cor do glifo', colorCtl(() => d.icon.fg, x => { d.icon.fg = x; repaint(); })));
        gg.appendChild(fld('Cor de destaque', colorCtl(() => d.accent, x => { d.accent = x; changed(); })));
        gg.appendChild(fld('Imagem (opcional)', txt(() => d.icon.image, x => { d.icon.image = x.trim(); if (/^(https|nui):\/\/\S+$/.test(d.icon.image) || !d.icon.image) repaint(); else changed(); }, { max: 300, mono: true, ph: 'https://...', valid: x => /^(https|nui):\/\/[^\s"'<>]+$/.test(x) }), { hint: 'Substitui o glifo. Só https:// ou nui://.' }));
        c2.body.appendChild(ig); p.appendChild(c2.el);
        const c3 = card('Contacto', { icon: 'phone', sub: 'Mostra um botão "Ligar" no topo da app. Vazio = sem botão.' });
        const g3 = h('<div class="pad-grid g2"></div>');
        g3.appendChild(fld('Número', txt(() => d.contact.phone, x => { d.contact.phone = x; changed(); }, { max: 16, mono: true, ph: '911', filter: x => x.replace(/[^\d+\-#* ]/g, '') })));
        g3.appendChild(fld('Texto do botão', txt(() => d.contact.label, x => { d.contact.label = x; changed(); }, { max: 30, ph: 'Emergência' })));
        c3.body.appendChild(g3); p.appendChild(c3.el);
      },
      access(p) {
        const d = ed.draft;
        const c1 = card('Estado', { icon: 'power' });
        c1.body.appendChild(row('App ligada', sw(() => d.enabled, x => { d.enabled = x; changed({ head: true }); }), { hint: 'Desligada, desaparece de todos os telemóveis (os dados ficam).' }));
        c1.body.appendChild(row('Aparece na AppShop', sw(() => d.listed, x => { d.listed = x; changed(); }), { hint: 'Para quem a pode ver. Desligado, só por pré-instalação.' }));
        c1.body.appendChild(row('Pré-instalada', sw(() => d.preinstalled, x => { d.preinstalled = x; changed(); }), { hint: 'Instala-se sozinha em quem a pode ver.' }));
        p.appendChild(c1.el);
        const c2 = card('Quem vê', { icon: 'eye' });
        c2.body.appendChild(row('Cidadãos', sw(() => d.audience.public, x => { d.audience.public = x; changed(); }), { hint: 'Qualquer jogador pode instalar e usar o lado do cidadão (denúncias, marcações, pedidos, menus).' }));
        c2.body.appendChild(row('Equipa só em serviço', sw(() => d.audience.onDutyOnly, x => { d.audience.onDutyOnly = x; changed(); }), { hint: 'O lado da equipa só aparece a quem está de serviço (o módulo Serviço continua visível para poder entrar).' }));
        c2.body.appendChild(row('Avisar a equipa', sw(() => d.notify.staff, x => { d.notify.staff = x; changed(); }), { hint: 'A equipa em serviço recebe uma notificação quando chega um pedido novo.' }));
        p.appendChild(c2.el);
        const c3 = card('Empregos da equipa', { icon: 'briefcase', sub: 'Quem tem um destes empregos (e o grau mínimo) vê o lado da equipa. A lista e os graus vêm do framework.' });
        const note = h('<div class="pad-jnote" hidden></div>'); c3.body.appendChild(note);
        const paintNote = () => {
          note.hidden = JOBS !== false && JOBS !== null;
          note.classList.toggle('warn', JOBS === false);
          note.textContent = JOBS === false ? T('A lista de empregos do framework não respondeu. Escreve o nome do emprego e o grau à mão.') : T('A carregar os empregos do framework...');
        };
        jobSync(paintNote); paintNote();
        c3.body.appendChild(listEd({
          get: () => d.audience.jobs, max: 20, addLabel: 'Adicionar emprego', empty: 'Sem empregos: a app não tem lado da equipa.', onChange: () => { changed(); syncModJobs(); },
          make: () => ({ name: '', minGrade: 0 }),
          row: j => {
            const g = h('<div class="ovk-in pad-inline pad-jobrow"></div>');
            let gc = null;
            g.appendChild(fld('Emprego', jobCtl(() => j.name, x => { j.name = x; if (gc) gc.sync(); changed(); syncModJobs(); })));
            gc = gradeCtl(() => j.minGrade, x => { j.minGrade = x; changed(); }, () => [j.name]);
            g.appendChild(fld('Grau mínimo', gc));
            return g;
          },
        }));
        p.appendChild(c3.el);
      },
      modules(p) {
        const d = ed.draft;
        const bar = h('<div class="pad-toolbar"></div>');
        const cnt = h('<span class="pad-sum inline"></span>');
        const paintCnt = () => { cnt.textContent = TF('%s de %s módulos', d.modules.length, maxMods()); addB.disabled = d.modules.length >= maxMods(); ed.tabs.badge('modules', d.modules.length); };
        const addMod = m => {
          if (d.modules.length >= maxMods()) { toast(TF('Chegaste ao limite de %s módulos.', maxMods()), 'err'); return; }
          m.id = uniqId(String(m.id).slice(0, 21), d.modules.map(x => x.id)).slice(0, 24);
          d.modules.push(m);
          const c = modCard(m, paintCnt); list.appendChild(c); c._toggle(true); paintCnt(); paintArrows(); changed();
          ed.pvMod = d.modules.length - 1; ed.pvRole = m.civil ? 'civil' : 'staff';
          setTimeout(() => c.scrollIntoView({ block: 'nearest' }), 30);
          toast(TF('Módulo %s adicionado.', m.title), 'info', { noi18n: true });
        };
        const addB = btn('Adicionar módulo', { kind: 'primary', sm: true, icon: 'plus', on: () => modLibrary(addMod) });
        bar.appendChild(addB); bar.appendChild(cnt);
        bar.appendChild(h('<span class="pad-note inline">Cada módulo é um separador na app. Arrasta para mudar a ordem.</span>'));
        p.appendChild(bar);
        const list = h('<div class="pad-mods"></div>');
        d.modules.forEach(m => list.appendChild(modCard(m, paintCnt)));
        sortable(list, { handle: '.pad-grip', item: '.pad-mod', onMove: (a, b) => { moveIn(d.modules, a, b); paintArrows(); changed(); } });
        const paintArrows = () => [...list.children].forEach((c, i) => { c.querySelector('.pad-mod-up').disabled = i === 0; c.querySelector('.pad-mod-dn').disabled = i === list.children.length - 1; });
        list._arrows = paintArrows; list._cnt = paintCnt;
        p.appendChild(list);
        paintCnt(); paintArrows();
      },
      hooks(p) {
        const d = ed.draft, w = d.webhooks;
        const c1 = card('Webhook da app', { icon: 'link', sub: 'Mensagens para um canal do Discord (ou compatível) quando acontece alguma coisa nesta app. Os autores anónimos nunca aparecem.' });
        const row1 = h('<div class="pad-hookrow"></div>');
        const urlIn = txt(() => w.url, x => { w.url = x.trim(); changed(); }, { max: 300, mono: true, ph: 'https://discord.com/api/webhooks/...', valid: x => /^https:\/\/[\w.-]+\//.test(x) });
        row1.appendChild(fld('URL base', urlIn));
        row1.appendChild(btn('Testar', { kind: 'ghost', icon: 'send', on: async b => {
          if (!/^https:\/\/[\w.-]+\//.test(w.url || '')) { toast(ERR.webhook, 'err'); return; }
          b.disabled = true; const r = await call('admin.capps.testWebhook', { app: d.id, url: w.url }); b.disabled = false;
          if (r.ok) toast('Mensagem de teste enviada.');
        } }));
        c1.body.appendChild(row1);
        p.appendChild(c1.el);
        const c2 = card('Eventos', { icon: 'bell', sub: 'Escolhe o que é enviado. Cada evento pode ir para outro canal.' });
        const tb = h('<div class="pad-hooks"></div>');
        HOOK_EVENTS.forEach(([ev, lab, desc]) => {
          const r = h(`<div class="pad-hook"><div class="pad-hook-t"><b></b><small></small><code data-noi18n></code></div><div class="pad-hook-u"></div><div class="pad-hook-s"></div></div>`);
          r.querySelector('b').textContent = lab; r.querySelector('small').textContent = desc; r.querySelector('code').textContent = ev;
          r.querySelector('.pad-hook-u').appendChild(txt(() => w.urls[ev], x => { x = x.trim(); if (x) w.urls[ev] = x; else delete w.urls[ev]; changed(); }, { max: 300, mono: true, ph: 'Usa o URL base', valid: x => /^https:\/\/[\w.-]+\//.test(x) }));
          r.querySelector('.pad-hook-s').appendChild(sw(() => !!w.events[ev], x => { w.events[ev] = x; r.classList.toggle('off', !x); changed(); }));
          r.classList.toggle('off', !w.events[ev]);
          tb.appendChild(r);
        });
        c2.body.appendChild(tb); p.appendChild(c2.el);
      },
      data(p) { dataPane(p); },
    };

    /* ---------- biblioteca de módulos ---------- */
    function modLibrary(onAdd) {
      const lib = h('<div class="pad-mlib"></div>');
      Object.keys(MTYPES).forEach(type => {
        const t = MTYPES[type];
        const g = h(`<section class="pad-mlib-g"><header class="pad-mlib-h"><span class="pad-mlib-ic">${glyph(t.icon, 16)}</span><div class="pad-mlib-tt"><b></b><small></small></div></header><div class="pad-mlib-l"></div></section>`);
        g.querySelector('b').textContent = t.label; g.querySelector('small').textContent = t.desc;
        const blank = btn('Em branco', { kind: 'ghost', sm: true, icon: 'plus', on: () => { closeTpl(); onAdd(trMod(newModule(type, []))); } });
        g.querySelector('.pad-mlib-h').appendChild(blank);
        const l = g.querySelector('.pad-mlib-l');
        PRESETS.filter(x => x[0] === type).forEach(([, key, name, desc]) => {
          const c = h(`<button type="button" class="pad-mlib-c"><b></b><small></small></button>`);
          c.querySelector('b').textContent = name; c.querySelector('small').textContent = desc;
          c.onclick = () => { closeTpl(); const m = trMod(P[key]()); onAdd(m); };
          l.appendChild(c);
        });
        lib.appendChild(g);
      });
      bigDlg(T('Adicionar módulo'), T('Escolhe um módulo pronto ou começa um vazio. Depois mudas tudo: campos, estados, textos e permissões.'), lib);
    }

    /* ---------- módulo ---------- */
    function modCard(m, paintCnt) {
      const d = ed.draft;
      const e = h(`<div class="pad-mod"><div class="pad-mod-h"><span class="pad-grip" title="Arrastar para reordenar">${ic('moreV', 14)}</span><span class="pad-mod-ic"></span><div class="pad-mod-t"><b data-noi18n></b><small></small></div><div class="pad-mod-sides"></div><div class="pad-mod-en"></div><div class="pad-mod-act"><button type="button" class="pad-ib pad-mod-up" title="Subir">${ic('chevU', 14)}</button><button type="button" class="pad-ib pad-mod-dn" title="Descer">${ic('chevD', 14)}</button><button type="button" class="pad-ib pad-mod-cp" title="Duplicar módulo">${ic('copy', 14)}</button><button type="button" class="pad-ib danger pad-mod-x" title="Apagar módulo">${ic('trash', 14)}</button><button type="button" class="pad-ib pad-exp" title="Editar">${ic('chevD', 16)}</button></div></div><div class="pad-mod-b" hidden></div></div>`);
      const body = e.querySelector('.pad-mod-b');
      const paint = () => {
        const icn = e.querySelector('.pad-mod-ic'); icn.innerHTML = glyph(m.icon || 'grid', 18); icn.style.color = HEX.test(d.accent) ? d.accent : '#F2F3F5';
        e.querySelector('.pad-mod-t b').textContent = m.title || MTYPES[m.type].label;
        e.querySelector('.pad-mod-t small').textContent = T(MTYPES[m.type].label) + (m.type === 'posts' && m.options.audience === 'staff' ? ' · ' + T('Só a equipa') : '');
        const s = e.querySelector('.pad-mod-sides'); s.textContent = '';
        if (m.civil) s.appendChild(chip('Cidadão', { kind: 'side' }));
        if (m.staff) s.appendChild(chip(m.staffMinGrade ? TF('Equipa %s+', m.staffMinGrade) : T('Equipa'), { kind: 'side' }));
        if (m.staff && m.jobs && m.jobs.length) s.appendChild(chip(m.jobs.join(', '), { kind: 'mono', noi18n: true }));
        if (m.staff && m.perms) s.appendChild(chip('Permissões próprias', { kind: 'side' }));
        e.classList.toggle('off', !m.enabled);
      };
      e._paint = paint;
      e.querySelector('.pad-mod-en').appendChild(sw(() => m.enabled, x => { m.enabled = x; paint(); changed(); }));
      const list = () => e.parentElement;
      const idx = () => [...list().children].indexOf(e);
      e.querySelector('.pad-mod-up').onclick = ev => { ev.stopPropagation(); const i = idx(); if (moveIn(d.modules, i, i - 1)) { list().insertBefore(e, list().children[i - 1]); list()._arrows(); changed(); } };
      e.querySelector('.pad-mod-dn').onclick = ev => { ev.stopPropagation(); const i = idx(); if (moveIn(d.modules, i, i + 1)) { list().insertBefore(list().children[i + 1], e); list()._arrows(); changed(); } };
      e.querySelector('.pad-mod-cp').onclick = ev => {
        ev.stopPropagation();
        if (d.modules.length >= maxMods()) { toast(TF('Chegaste ao limite de %s módulos.', maxMods()), 'err'); return; }
        const c = clone(m);
        c.id = uniqId(String(m.id).slice(0, 21) + '_2', d.modules.map(x => x.id)).slice(0, 24);
        c.title = String(m.title || '').slice(0, 37) + ' 2';
        const i = d.modules.indexOf(m); d.modules.splice(i + 1, 0, c);
        const ce = modCard(c, paintCnt); e.after(ce); list()._arrows(); paintCnt(); changed();
        toast('Módulo duplicado. Muda o título e o identificador se quiseres.', 'info');
      };
      e.querySelector('.pad-mod-x').onclick = async ev => {
        ev.stopPropagation();
        const ok = await confirmBox({ title: TF('Apagar o módulo %s?', m.title), text: 'O separador sai da app quando guardares. Os registos que já existem ficam na base de dados.', ok: 'Apagar módulo', danger: true });
        if (!ok) return;
        const i = d.modules.indexOf(m); if (i >= 0) d.modules.splice(i, 1);
        const L2 = list(); e.remove(); if (L2 && L2._arrows) L2._arrows(); paintCnt(); ed.pvMod = 0; changed();
      };
      const toggle = force => { const open = force != null ? force : body.hidden; if (open && !body.firstChild) modBody(m, body, paint); body.hidden = !open; e.classList.toggle('open', open); if (open) { const i = d.modules.indexOf(m); if (i >= 0) { ed.pvMod = i; if (ed.pvRole === 'civil' && !m.civil && m.staff) ed.pvRole = 'staff'; else if (ed.pvRole === 'staff' && !m.staff && m.civil) ed.pvRole = 'civil'; pvLater(); } } };
      e._toggle = toggle;
      e.querySelector('.pad-mod-h').addEventListener('click', ev => { if (ev.target.closest('.pad-sw,.pad-grip,.pad-mod-up,.pad-mod-dn,.pad-mod-x,.pad-mod-cp')) return; toggle(); });
      paint();
      return e;
    }
    function modBody(m, body, paint) {
      const d = ed.draft, o = m.options;
      const ctx = { paint, sides: null, perms: null, grade: null };
      const g = h('<div class="pad-grid g3"></div>');
      g.appendChild(fld('Título do separador', txt(() => m.title, x => { m.title = x; paint(); changed(); }, { max: 40 })));
      g.appendChild(fld('Ícone', glyphCtl(() => m.icon, x => { m.icon = x; paint(); changed(); })));
      g.appendChild(fld('Identificador', txt(() => m.id, x => { m.id = x; changed(); }, { max: 24, mono: true, filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, ''), valid: x => /^[a-z0-9_]{1,24}$/.test(x) && d.modules.filter(y => y.id === x).length === 1 }), { hint: 'Único nesta app. Mudar depois separa os registos antigos.' }));
      body.appendChild(g);
      /* lados: o do cidadão não existe nos módulos só da equipa (faturação, serviço, equipa, quadro interno) */
      const sides = h('<div class="pad-sides"></div>');
      const civilOk = () => !STAFF_ONLY.has(m.type) && !(m.type === 'posts' && o.audience === 'staff');
      const civR = row('Lado do cidadão', sw(() => m.civil, x => { m.civil = x; paint(); changed(); }), { hint: 'Aparece a quem instala a app.' });
      const staffSw = sw(() => m.staff, x => { m.staff = x; paint(); staffBox.hidden = !x; changed(); });
      const stR = row('Lado da equipa', staffSw, { hint: 'Aparece a quem tem um dos empregos.' });
      ctx.grade = gradeCtl(() => m.staffMinGrade, x => { m.staffMinGrade = x; paint(); if (ctx.perms) ctx.perms.sync(); changed(); }, () => modJobNames(m));
      const grR = row('Grau mínimo da equipa', ctx.grade, { hint: 'Além do grau do emprego na app.' });
      sides.appendChild(civR); sides.appendChild(stR); sides.appendChild(grR);
      ctx.sides = () => { civR.hidden = !civilOk(); sides.classList.toggle('two', !civilOk()); civR.querySelector('.pad-sw').sync(); };
      ctx.sides();
      body.appendChild(sides);
      /* equipa: empregos deste módulo + permissões por ação */
      const staffBox = h('<div class="pad-staffbox"></div>');
      staffBox.appendChild(subBox('Empregos com acesso', null, modJobsEd(m, ctx)));
      if (PERM_BY_TYPE[m.type]) { ctx.perms = permsEd(m, ctx); staffBox.appendChild(subBox('Permissões da equipa', 'O grau mínimo para cada ação neste módulo. O servidor confere tudo.', ctx.perms)); }
      staffBox.hidden = !m.staff;
      body.appendChild(staffBox);
      const opt = h('<div class="pad-modopt"></div>'); body.appendChild(opt);
      OPTS[m.type] && OPTS[m.type](o, opt, m, ctx);
    }
    function modJobsEd(m, ctx) {
      const d = ed.draft;
      const w = h('<div class="pad-mjobs"><div class="pad-chiptg"></div><div class="pad-fld-h"></div></div>');
      const tg = w.querySelector('.pad-chiptg'), hint = w.querySelector('.pad-fld-h');
      const after = () => { ctx.paint(); if (ctx.grade) ctx.grade.sync(); if (ctx.perms) ctx.perms.sync(); paintW(); changed(); };
      const paintW = () => {
        tg.textContent = '';
        const names = d.audience.jobs.map(j => j.name).filter(Boolean), sel = arr(m.jobs);
        names.forEach(n => {
          const j = jobOf(n), b = h(`<button type="button" class="pad-tgl${sel.includes(n) ? ' on' : ''}" data-noi18n></button>`);
          b.textContent = j ? j.label : n; b.title = n;
          b.onclick = () => { let s = arr(m.jobs).filter(x => x !== n); if (!arr(m.jobs).includes(n)) s.push(n); if (s.length) m.jobs = s; else delete m.jobs; after(); };
          tg.appendChild(b);
        });
        sel.filter(n => !names.includes(n)).forEach(n => {
          const b = h(`<button type="button" class="pad-tgl stale" title="Já não está na app: tocar para tirar"><span data-noi18n></span>${ic('x', 12)}</button>`);
          b.querySelector('span').textContent = n;
          b.onclick = () => { const s = arr(m.jobs).filter(x => x !== n); if (s.length) m.jobs = s; else delete m.jobs; after(); };
          tg.appendChild(b);
        });
        hint.textContent = !names.length ? T('A app ainda não tem empregos (separador Acesso).') : (sel.length ? T('Só os empregos escolhidos veem o lado da equipa deste módulo.') : T('Nenhum escolhido: todos os empregos da app.'));
      };
      const full = () => { paintW(); if (ctx.grade) ctx.grade.sync(); if (ctx.perms) ctx.perms.sync(); };
      paintW(); ed.modJobSync.push(full); jobSync(paintW);
      return w;
    }
    function permsEd(m, ctx) {
      const acts = PERM_BY_TYPE[m.type] || [];
      const w = h('<div class="pad-perms"><div class="pad-perms-b"></div><div class="pad-perms-f"><span class="pad-perms-st"></span></div></div>');
      const eff = () => (m.perms ? m.perms : permDefaults(m));
      const rows = acts.map(a => {
        const r = h('<div class="pad-perm"><div class="pad-perm-t"><b></b></div><div class="pad-perm-c"></div></div>');
        r.querySelector('b').textContent = PERM_LABEL[m.type + '.' + a] || PERMS[a];
        const gc = gradeCtl(() => eff()[a], v => { if (!m.perms) m.perms = permDefaults(m); m.perms[a] = v; paintSt(); ctx.paint(); changed(); }, () => modJobNames(m), { small: true });
        r.querySelector('.pad-perm-c').appendChild(gc);
        w.querySelector('.pad-perms-b').appendChild(r);
        return gc;
      });
      const st = w.querySelector('.pad-perms-st');
      const rst = btn('Repor as regras por omissão', { kind: 'link', sm: true, on: () => { delete m.perms; rows.forEach(x => x.sync()); paintSt(); ctx.paint(); changed(); } });
      w.querySelector('.pad-perms-f').appendChild(rst);
      const paintSt = () => { st.textContent = m.perms ? T('Permissões próprias deste módulo.') : T('Regras por omissão, a partir do grau mínimo do módulo. Muda um valor para este módulo ter permissões próprias.'); rst.hidden = !m.perms; w.classList.toggle('own', !!m.perms); };
      paintSt();
      w.sync = () => { rows.forEach(x => x.sync()); paintSt(); };
      return w;
    }

    /* ---------- construtor de campos v2 (formulários, fichas e o formulário das encomendas) ---------- */
    function fieldsEd(o, max) {
      const auto = new WeakSet(), conds = new Map();
      const prevFields = f => { const i = o.fields.indexOf(f); return o.fields.slice(0, Math.max(0, i)).filter(x => !NOVAL.has(x.type) && x.type !== 'photo' && x.key); };
      const renameRefs = (from, to) => { if (!from || from === to) return; o.fields.forEach(x => { if (x.showIf && x.showIf.key === from) x.showIf.key = to; }); };
      const syncConds = () => { conds.forEach((fn, f) => { if (!o.fields.includes(f)) conds.delete(f); else fn(); }); };
      return listEd({
        get: () => o.fields, max: max || 24, addLabel: 'Adicionar campo', empty: 'Sem campos.', onChange: () => { syncConds(); changed(); },
        make: () => { const f = { key: uniqId('campo', o.fields.map(x => x.key)), label: '', type: 'text', required: false }; auto.add(f); return f; },
        row: f => {
          const w = h('<div class="pad-fb"></div>');
          let keyIn = null, open = auto.has(f), paintSum = () => {};
          const setDef = v => { if (v === '' || v == null || (Array.isArray(v) && !v.length)) delete f.default; else f.default = v; changed(); };
          /* valor inicial conforme o tipo */
          const defCtl = () => {
            switch (f.type) {
              case 'number': return numCtl({ get: () => f.default, set: setDef, min: -1e9, max: 1e9, step: 1, slider: false, compact: true, allowEmpty: true });
              case 'checkbox': return seg([{ v: '', l: 'Nenhum' }, { v: 'y', l: 'Marcada' }, { v: 'n', l: 'Desmarcada' }], () => (f.default === true ? 'y' : f.default === false ? 'n' : ''), x => setDef(x === 'y' ? true : x === 'n' ? false : null), { small: true });
              case 'select': return dd(() => [{ v: '', l: T('Nenhum') }].concat(arr(f.options).map(x => ({ v: x, l: x }))), () => f.default || '', x => setDef(x), { noi18n: true });
              case 'multiselect': {
                const c = h('<div class="pad-chiptg sm"></div>');
                const paintC = () => { c.textContent = ''; const opts = arr(f.options); if (!opts.length) { c.appendChild(h('<span class="pad-fld-h">Escreve primeiro as opções.</span>')); return; } opts.forEach(x => { const b = h(`<button type="button" class="pad-tgl sm${arr(f.default).includes(x) ? ' on' : ''}" data-noi18n></button>`); b.textContent = x; b.onclick = () => { const s = arr(f.default).filter(y => y !== x && opts.includes(y)); if (!arr(f.default).includes(x)) s.push(x); setDef(s); paintC(); }; c.appendChild(b); }); };
                c.sync = paintC; paintC(); return c;
              }
              case 'rating': return seg([0, 1, 2, 3, 4, 5].map(v => ({ v, l: v ? String(v) : T('Nenhum') })), () => f.default || 0, x => setDef(x || null), { small: true });
              case 'date': return txt(() => f.default, x => setDef(x), { max: 10, mono: true, ph: 'AAAA-MM-DD', filter: x => x.replace(/[^\d-]/g, ''), valid: x => /^\d{4}-\d{2}-\d{2}$/.test(x) });
              case 'time': return txt(() => f.default, x => setDef(x), { max: 5, mono: true, ph: 'HH:MM', filter: x => x.replace(/[^\d:]/g, ''), valid: x => /^([01]\d|2[0-3]):[0-5]\d$/.test(x) });
              case 'photo': case 'section': case 'info': return null;
              default: return txt(() => f.default, x => setDef(x), { max: TEXT_LEN[f.type] || 200, area: false, ph: 'Vazio' });
            }
          };
          const paint = () => {
            w.textContent = '';
            const nov = NOVAL.has(f.type);
            /* linha 1: pergunta, tipo, obrigatório */
            const l1 = h('<div class="pad-fb-1"></div>');
            l1.appendChild(fld(f.type === 'section' ? 'Título da secção' : f.type === 'info' ? 'Título' : 'Pergunta', txt(() => f.label, x => {
              f.label = x;
              if (auto.has(f)) { const old = f.key; f.key = uniqId(slugify(x) || 'campo', o.fields.filter(y => y !== f).map(y => y.key)); keyIn.sync(); renameRefs(old, f.key); syncConds(); }
              changed();
            }, { max: 60, ph: f.type === 'section' ? 'Ex.: Sobre ti' : 'Ex.: O que aconteceu' })));
            l1.appendChild(fld('Tipo', dd(FTYPES.map(([v, l]) => ({ v, l })), () => f.type, x => {
              if (x === f.type) return;
              f.type = x;
              if (x === 'select' || x === 'multiselect') f.options = arr(f.options); else delete f.options;
              if (NOVAL.has(x)) { f.required = false; delete f.placeholder; }
              delete f.default; delete f.min; delete f.max;
              paint(); syncConds(); changed();
            })));
            if (!nov) { const rq = h('<div class="pad-swl"></div>'); rq.appendChild(sw(() => f.required, x => { f.required = x; changed(); })); rq.appendChild(h('<span>Obrigatório</span>')); l1.appendChild(fld('', rq)); }
            else l1.appendChild(h('<span></span>'));
            /* o resto do campo (chave, ajuda, opções, intervalo, valor inicial, condição) abre-se no botão; fechado mostra um resumo */
            const tg = h(`<button type="button" class="pad-ib pad-fb-tg" title="Mais opções do campo">${ic('sliders', 15)}</button>`);
            l1.appendChild(fld('', tg));
            w.appendChild(l1);
            const sum = h('<div class="pad-fb-sum"></div>'), more = h('<div class="pad-fb-more"></div>');
            w.appendChild(sum); w.appendChild(more);
            paintSum = () => {
              sum.textContent = '';
              sum.appendChild(chip(f.key || '-', { kind: 'mono', noi18n: true }));
              if ((f.type === 'select' || f.type === 'multiselect')) sum.appendChild(chip(TF('%s opções', arr(f.options).length)));
              if (f.min != null || f.max != null) sum.appendChild(chip(f.type === 'number' ? TF('de %s a %s', f.min != null ? f.min : '...', f.max != null ? f.max : '...') : TF('%s a %s letras', f.min || 0, f.max != null ? f.max : TEXT_LEN[f.type] || '...'), { noi18n: true }));
              if (f.default != null && f.default !== '') sum.appendChild(chip('Valor inicial'));
              if (f.help) sum.appendChild(chip(f.type === 'info' ? 'Com texto' : 'Com ajuda'));
              if (f.showIf) {
                const t = prevFields(f).find(x => x.key === f.showIf.key);
                sum.appendChild(t ? chip(TF('Só quando %s = %s', t.label || t.key, f.showIf.equals), { kind: 'warn', noi18n: true }) : chip('Condição inválida', { kind: 'bad' }));
              }
            };
            const applyOpen = () => { more.hidden = !open; sum.hidden = open; tg.classList.toggle('on', open); if (!open) paintSum(); };
            tg.onclick = e => { e.stopPropagation(); open = !open; applyOpen(); };
            /* linha 2: chave, texto dentro do campo, ajuda (no texto informativo: o texto) */
            const l2 = h(`<div class="pad-fb-2${nov || f.type === 'checkbox' || f.type === 'rating' || f.type === 'photo' ? ' two' : ''}"></div>`);
            keyIn = txt(() => f.key, x => { const old = f.key; f.key = x; auto.delete(f); renameRefs(old, x); syncConds(); changed(); }, { max: 24, mono: true, filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, ''), valid: x => /^[a-z0-9_]{1,24}$/.test(x) && o.fields.filter(y => y.key === x).length === 1 });
            l2.appendChild(fld('Chave', keyIn));
            if (f.type === 'info') l2.appendChild(fld('Texto', txt(() => f.help, x => { if (x) f.help = x; else delete f.help; changed(); }, { max: 600, area: true, rows: 2, ph: 'O texto que aparece no formulário' })));
            else {
              if (!nov && f.type !== 'checkbox' && f.type !== 'rating' && f.type !== 'photo') l2.appendChild(fld('Texto dentro do campo', txt(() => f.placeholder, x => { if (x) f.placeholder = x; else delete f.placeholder; changed(); }, { max: 80, ph: 'Aparece no campo vazio' })));
              l2.appendChild(fld(f.type === 'section' ? 'Subtítulo' : 'Ajuda', txt(() => f.help, x => { if (x) f.help = x; else delete f.help; changed(); }, { max: 120, ph: f.type === 'section' ? 'Uma linha por baixo do título' : 'Aparece por baixo do campo' })));
            }
            more.appendChild(l2);
            /* linha 3: opções, intervalo e valor inicial */
            if (!nov && f.type !== 'photo') {
              const l3 = h('<div class="pad-fb-3"></div>');
              let dvW = null;
              if (f.type === 'select' || f.type === 'multiselect') {
                l3.appendChild(fld('Opções (separadas por vírgulas)', txt(() => arr(f.options).join(', '), x => {
                  f.options = x.split(',').map(s => s.trim()).filter(Boolean).slice(0, 20);
                  if (dvW && dvW.firstElementChild && dvW.lastElementChild.sync) dvW.lastElementChild.sync();
                  syncConds(); changed();
                }, { max: 900, ph: 'Furto, Roubo, Outro' }), { span: 2 }));
              }
              if (f.type === 'number') {
                l3.appendChild(fld('Mínimo', numCtl({ get: () => f.min, set: x => { if (x == null) delete f.min; else f.min = x; changed(); }, min: -1e9, max: 1e9, step: 1, slider: false, compact: true, allowEmpty: true })));
                l3.appendChild(fld('Máximo', numCtl({ get: () => f.max, set: x => { if (x == null) delete f.max; else f.max = x; changed(); }, min: -1e9, max: 1e9, step: 1, slider: false, compact: true, allowEmpty: true })));
              } else if (TEXT_LEN[f.type]) {
                l3.appendChild(fld('Mínimo de letras', numCtl({ get: () => f.min, set: x => { if (!x) delete f.min; else f.min = x; changed(); }, min: 0, max: TEXT_LEN[f.type], step: 1, slider: false, compact: true, allowEmpty: true })));
                l3.appendChild(fld('Máximo de letras', numCtl({ get: () => f.max, set: x => { if (x == null) delete f.max; else f.max = x; changed(); }, min: 1, max: TEXT_LEN[f.type], step: 1, slider: false, compact: true, allowEmpty: true, placeholder: String(TEXT_LEN[f.type]) })));
              }
              const dc = defCtl();
              if (dc) { dvW = fld('Valor inicial', dc); l3.appendChild(dvW); }
              if (l3.children.length) more.appendChild(l3);
            }
            /* linha 4: condição "mostrar só quando" (só campos com valor que venham antes) */
            const l4 = h(`<div class="pad-fb-c"><span class="pad-fb-c-i">${ic('eye', 14)}</span><span class="pad-fb-c-l">Mostrar</span><div class="pad-fb-c-f"></div><span class="pad-fb-c-eq"></span><div class="pad-fb-c-v"></div><span class="pad-fb-c-err"></span></div>`);
            const fPick = dd(() => [{ v: '', l: T('Sempre') }].concat(prevFields(f).map(x => ({ v: x.key, l: x.label || x.key, sub: x.key }))), () => (f.showIf && f.showIf.key) || '', x => {
              if (!x) delete f.showIf;
              else { const t = o.fields.find(y => y.key === x); f.showIf = { key: x, equals: t && t.type === 'checkbox' ? 'true' : (t && arr(t.options)[0]) || '' }; }
              sig = null; condSync(); changed();
            }, { noi18n: true, small: true, placeholder: T('Campo que já não existe') });
            l4.querySelector('.pad-fb-c-f').appendChild(fPick);
            let sig = null;
            const condSync = () => {
              const si = f.showIf, t = si ? prevFields(f).find(x => x.key === si.key) : null;
              const s = !si ? 'none' : (t ? t.type + '|' + arr(t.options).join(',') : 'gone');
              fPick.sync();
              l4.classList.toggle('on', !!si);
              l4.querySelector('.pad-fb-c-l').textContent = si ? T('Mostrar só quando') : T('Mostrar');
              if (!open) paintSum();
              const vEl = l4.querySelector('.pad-fb-c-v'), eq = l4.querySelector('.pad-fb-c-eq'), err = l4.querySelector('.pad-fb-c-err');
              if (s !== sig) {
                sig = s; vEl.textContent = '';
                eq.textContent = !si ? '' : t && t.type === 'multiselect' ? T('incluir') : T('for igual a');
                if (si && t) {
                  const setEq = x => { f.showIf.equals = String(x); condSync(); changed(); };
                  let c;
                  if (t.type === 'checkbox') c = seg([{ v: 'true', l: 'Marcada' }, { v: 'false', l: 'Desmarcada' }], () => f.showIf.equals, setEq, { small: true });
                  else if (t.type === 'select' || t.type === 'multiselect') c = dd(() => arr(t.options).map(x => ({ v: x, l: x })), () => f.showIf.equals, setEq, { noi18n: true, small: true, placeholder: T('Escolhe uma opção') });
                  else c = txt(() => f.showIf.equals, x => { f.showIf.equals = x; changed(); errPaint(); }, { max: 60, ph: t.type === 'number' || t.type === 'rating' ? '0' : T('Valor') });
                  vEl.appendChild(c);
                }
              } else { const c = vEl.firstElementChild; if (c && c.sync) c.sync(); }
              errPaint();
            };
            const errPaint = () => {
              const si = f.showIf, t = si ? prevFields(f).find(x => x.key === si.key) : null, err = l4.querySelector('.pad-fb-c-err');
              let bad = '';
              if (si && !t) bad = T('O campo da condição já não existe ou ficou depois deste.');
              else if (si && t && (t.type === 'select' || t.type === 'multiselect') && !arr(t.options).includes(si.equals)) bad = T('Escolhe uma das opções.');
              else if (si && t && !String(si.equals || '').trim()) bad = T('Escreve o valor.');
              else if (si && t && (t.type === 'number' || t.type === 'rating') && isNaN(Number(si.equals))) bad = T('Tem de ser um número.');
              err.textContent = bad; l4.classList.toggle('bad', !!bad);
            };
            conds.set(f, condSync); condSync();
            more.appendChild(l4);
            applyOpen();
          };
          paint();
          return w;
        },
      });
    }
    /* estados v2: cor, nome, chave, "fecha o pedido" e "avisa o autor" */
    function statusEd(o) {
      const auto = new WeakSet();
      return listEd({
        get: () => o.statuses, max: 10, addLabel: 'Adicionar estado', onChange: () => changed(),
        make: () => { const s = { id: uniqId('estado', o.statuses.map(x => x.id)), label: '', color: SWATCHES[o.statuses.length % 12], notify: true }; auto.add(s); return s; },
        row: s => {
          const g = h('<div class="ovk-in pad-inline st"></div>');
          let idIn = null;
          g.appendChild(fld('Cor', colorCtl(() => s.color, x => { s.color = x; changed(); }, { compact: true })));
          g.appendChild(fld('Nome', txt(() => s.label, x => { s.label = x; if (auto.has(s)) { s.id = uniqId(slugify(x) || 'estado', o.statuses.filter(y => y !== s).map(y => y.id)); idIn.sync(); } changed(); }, { max: 24, ph: 'Ex.: Em análise' })));
          idIn = txt(() => s.id, x => { s.id = x; auto.delete(s); changed(); }, { max: 24, mono: true, filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, ''), valid: x => /^[a-z0-9_]{1,24}$/.test(x) });
          g.appendChild(fld('Chave', idIn));
          const cl = h('<div class="pad-swl"></div>'); cl.appendChild(sw(() => !!s.closed, x => { if (x) s.closed = true; else delete s.closed; changed(); })); cl.appendChild(h('<span>Fecha</span>'));
          g.appendChild(fld('', cl));
          const nt = h('<div class="pad-swl" title="O autor recebe uma notificação quando o pedido passa para este estado."></div>'); nt.appendChild(sw(() => s.notify !== false, x => { s.notify = x; changed(); })); nt.appendChild(h('<span>Avisa o autor</span>'));
          g.appendChild(fld('', nt));
          return g;
        },
      });
    }
    function subBox(title, hint, content) {
      const s = h('<div class="pad-sub"><div class="pad-sub-h"></div></div>');
      s.querySelector('.pad-sub-h').textContent = title;
      if (hint) { const x = h('<div class="pad-sub-n"></div>'); x.textContent = hint; s.appendChild(x); }
      s.appendChild(content); return s;
    }
    const swRow = (o, k, lab, hint, after) => row(lab, sw(() => !!o[k], x => { o[k] = x; if (after) after(x); changed(); }), { hint });
    const OPTS = {
      form(o, p) {
        const g = h('<div class="pad-grid g2"></div>');
        g.appendChild(fld('Introdução', txt(() => o.intro, x => { o.intro = x; changed(); }, { max: 500, area: true, rows: 2, ph: 'Aparece por cima do formulário.' }), { span: 2 }));
        g.appendChild(fld('Texto do botão', txt(() => o.submitLabel, x => { o.submitLabel = x; changed(); }, { max: 30, ph: 'Enviar' })));
        p.appendChild(g);
        const sws = h('<div class="pad-sides two"></div>');
        sws.appendChild(swRow(o, 'anonymous', 'Permitir anónimo', 'O autor pode esconder o nome.'));
        sws.appendChild(swRow(o, 'location', 'Anexar localização', 'Junta o GPS do cidadão.'));
        sws.appendChild(swRow(o, 'photo', 'Anexar fotografia', 'Uma foto da galeria.'));
        sws.appendChild(swRow(o, 'civilSeesOwn', 'O cidadão vê os seus pedidos', 'Com o estado e as respostas.'));
        sws.appendChild(swRow(o, 'replies', 'Conversa com o autor', 'A equipa e o autor trocam mensagens.'));
        p.appendChild(sws);
        p.appendChild(subBox('Campos do formulário', 'O que o cidadão preenche, por esta ordem. Secções e textos informativos arrumam o formulário; "Mostrar" esconde um campo até outro ter um valor.', fieldsEd(o, 24)));
        p.appendChild(subBox('Estados', 'O primeiro é o estado de um pedido novo. Os que fecham saem da lista em aberto. "Avisa o autor" manda uma notificação ao cidadão.', statusEd(o)));
      },
      appointments(o, p) {
        p.appendChild(subBox('Serviços', 'O que se pode marcar e quanto tempo dura.', listEd({
          get: () => o.services, max: 12, addLabel: 'Adicionar serviço', onChange: () => changed(),
          make: () => ({ id: uniqId('servico', o.services.map(x => x.id)), label: '', minutes: 30 }),
          row: s => { const g = h('<div class="ovk-in pad-inline"></div>'); g.appendChild(fld('Serviço', txt(() => s.label, x => { s.label = x; changed(); }, { max: 40, ph: 'Ex.: Consulta geral' }))); g.appendChild(fld('Duração', numCtl({ get: () => s.minutes, set: x => { s.minutes = x; changed(); }, min: 5, max: 480, step: 5, slider: false, compact: true, unit: 'min' }))); return g; },
        })));
        const g = h('<div class="pad-grid g4"></div>');
        g.appendChild(fld('Abre às', numCtl({ get: () => o.hours.from, set: x => { o.hours.from = x; changed(); }, min: 0, max: 23, step: 1, slider: false, compact: true, unit: 'h' })));
        g.appendChild(fld('Fecha às', numCtl({ get: () => o.hours.to, set: x => { o.hours.to = x; changed(); }, min: 1, max: 24, step: 1, slider: false, compact: true, unit: 'h' })));
        g.appendChild(fld('Cada vaga', seg([15, 20, 30, 45, 60].map(v => ({ v, l: v + ' min' })), () => o.slot, x => { o.slot = x; changed(); }, { small: true })));
        g.appendChild(fld('Marcações por vaga', numCtl({ get: () => o.maxPerSlot, set: x => { o.maxPerSlot = x; changed(); }, min: 1, max: 20, step: 1, slider: false, compact: true })));
        p.appendChild(subBox('Horário', null, g));
        p.appendChild(subBox('Dias abertos', null, daysCtl(() => o.days, x => { o.days = x; changed(); })));
        const sws = h('<div class="pad-sides two"></div>'); sws.appendChild(swRow(o, 'notes', 'Notas na marcação', 'O cidadão pode escrever uma nota.')); p.appendChild(sws);
      },
      dispatch(o, p) {
        p.appendChild(subBox('Tipos de pedido', 'Os botões grandes que o cidadão toca.', listEd({
          get: () => o.types, max: 12, addLabel: 'Adicionar tipo', onChange: () => changed(),
          make: () => ({ id: uniqId('tipo', o.types.map(x => x.id)), label: '', icon: 'bolt' }),
          row: t => { const g = h('<div class="ovk-in pad-inline"></div>'); g.appendChild(fld('Ícone', glyphCtl(() => t.icon, x => { t.icon = x; changed(); }, { small: true }))); g.appendChild(fld('Texto', txt(() => t.label, x => { t.label = x; changed(); }, { max: 40, ph: 'Ex.: Pedir reboque' }))); return g; },
        })));
        const sws = h('<div class="pad-sides two"></div>');
        sws.appendChild(swRow(o, 'location', 'Anexar localização', 'A equipa recebe o GPS de quem pede.'));
        sws.appendChild(row('Intervalo entre pedidos', numCtl({ get: () => o.cooldown, set: x => { o.cooldown = x; changed(); }, min: 0, max: 3600, step: 5, slider: false, compact: true, unit: 's' }), { hint: 'Por cidadão, contra pedidos repetidos.' }));
        p.appendChild(sws);
      },
      records(o, p) {
        p.appendChild(subBox('Sobre quem', null, seg([{ v: 'person', l: 'Pessoa' }, { v: 'vehicle', l: 'Veículo' }, { v: 'free', l: 'Livre' }], () => o.subject, x => { o.subject = x; changed(); })));
        const sws = h('<div class="pad-sides two"></div>'); sws.appendChild(swRow(o, 'civilSeesOwn', 'O cidadão vê as suas fichas', 'Só leitura, sem as notas privadas.')); p.appendChild(sws);
        p.appendChild(subBox('Campos da ficha', 'Além do nome ou matrícula e da linha do tempo de notas.', fieldsEd(o, 24)));
        p.appendChild(subBox('Etiquetas', 'Marcas rápidas para as fichas.', listEd({
          get: () => o.tags, max: 16, addLabel: 'Adicionar etiqueta', empty: 'Sem etiquetas.', onChange: () => changed(),
          make: () => ({ id: uniqId('etiqueta', o.tags.map(x => x.id)), label: '', color: '#8A8F98' }),
          row: t => { const g = h('<div class="ovk-in pad-inline"></div>'); g.appendChild(fld('Cor', colorCtl(() => t.color, x => { t.color = x; changed(); }, { compact: true }))); g.appendChild(fld('Nome', txt(() => t.label, x => { t.label = x; changed(); }, { max: 24, ph: 'Ex.: Procurado' }))); return g; },
        })));
      },
      posts(o, p, m, ctx) {
        const g = h('<div class="pad-grid g2"></div>');
        g.appendChild(fld('Quem lê', seg([{ v: 'all', l: 'Toda a gente' }, { v: 'staff', l: 'Só a equipa' }], () => o.audience, x => { o.audience = x; m.civil = x !== 'staff'; ctx.sides(); ctx.paint(); changed(); }), { hint: '"Só a equipa" faz um quadro interno: os cidadãos não veem este separador.' }));
        g.appendChild(fld('Afixados no topo', numCtl({ get: () => o.pinLimit, set: x => { o.pinLimit = x; changed(); }, min: 0, max: 10, step: 1, slider: false, compact: true }), { hint: 'Quantos comunicados podem ficar afixados ao mesmo tempo.' }));
        p.appendChild(g);
        const sws = h('<div class="pad-sides two"></div>');
        sws.appendChild(swRow(o, 'notifyAll', 'Avisar toda a gente', 'Notificação a quem tem a app (e pode ler o separador), a cada publicação.'));
        p.appendChild(sws);
      },
      roster(o, p) {
        const sws = h('<div class="pad-sides two"></div>'); sws.appendChild(swRow(o, 'showOffDuty', 'Mostrar quem está fora de serviço', 'Senão, só aparece quem está de serviço.')); p.appendChild(sws);
      },
      catalog(o, p) {
        const g = h('<div class="pad-grid g4"></div>');
        g.appendChild(fld('Moeda', txt(() => o.currency, x => { o.currency = x; changed(); }, { max: 4, ph: defCur().symbol || '$' })));
        g.appendChild(fld('Máximo por artigo', numCtl({ get: () => o.maxQty, set: x => { o.maxQty = x; changed(); }, min: 1, max: 99, step: 1, slider: false, compact: true }), { hint: 'Unidades de cada artigo numa encomenda.' }));
        p.appendChild(g);
        const orderBox = h('<div></div>');
        const sws = h('<div class="pad-sides"></div>');
        sws.appendChild(swRow(o, 'orderable', 'Aceita encomendas', 'Carrinho e botão de encomendar. Desligado, é só uma tabela de preços.', x => { orderBox.hidden = !x; }));
        sws.appendChild(swRow(o, 'billing', 'Botão "Faturar"', 'A equipa passa uma fatura com o total da encomenda.'));
        sws.appendChild(swRow(o, 'location', 'Anexar localização', 'Junta o GPS de quem encomenda (para entregas).'));
        p.appendChild(sws);
        const catSync = [];
        p.appendChild(subBox('Categorias', 'Os separadores do menu, por esta ordem.', listEd({
          get: () => o.categories, max: 12, addLabel: 'Adicionar categoria', empty: 'Sem categorias: todos os artigos aparecem juntos.', onChange: () => { catSync.forEach(f => f()); changed(); },
          make: () => { let n = T('Nova categoria'), i = 1; while (o.categories.includes(n)) n = T('Nova categoria') + ' ' + (++i); return n; },
          row: (c, api) => {
            const g2 = h('<div class="ovk-in pad-inline"></div>');
            /* a linha ainda não está na lista quando o campo nasce (index = -1): lê o valor que veio */
            g2.appendChild(fld('Categoria', txt(() => (api.index() >= 0 ? o.categories[api.index()] : c), x => {
              const i = api.index(), old = o.categories[i]; o.categories[i] = x;
              o.items.forEach(it => { if (it.category === old) it.category = x; });
              catSync.forEach(f => f()); changed();
            }, { max: 30, ph: 'Ex.: Bebidas' })));
            return g2;
          },
        })));
        p.appendChild(subBox('Artigos', 'O que aparece no menu. O total de uma encomenda é sempre calculado no servidor com estes preços.', listEd({
          get: () => o.items, max: 60, addLabel: 'Adicionar artigo', empty: 'Sem artigos.', onChange: () => changed(),
          make: () => ({ id: uniqId('artigo', o.items.map(x => x.id)), label: '', desc: '', price: 0, image: '', category: o.categories[0] || '', available: true }),
          row: it => {
            const w = h('<div class="pad-cit"><div class="pad-cit-img"></div><div class="pad-cit-f"><div class="pad-cit-1"></div><div class="pad-cit-2"></div></div></div>');
            const img = w.querySelector('.pad-cit-img');
            const paintImg = () => {
              const u = /^(https|nui):\/\/[^\s"'<>]+$/.test(it.image || '') ? it.image : '';
              if (img.dataset.u === u) return; img.dataset.u = u; img.textContent = '';
              if (!u) { img.innerHTML = ic('photo', 18); return; }
              const im = new Image(); im.alt = ''; im.onerror = () => { img.innerHTML = ic('photo', 18); }; im.src = u; img.appendChild(im);
            };
            const l1 = w.querySelector('.pad-cit-1'), l2 = w.querySelector('.pad-cit-2');
            l1.appendChild(fld('Artigo', txt(() => it.label, x => { it.label = x; changed(); }, { max: 40, ph: 'Ex.: Hambúrguer clássico' })));
            l1.appendChild(fld('Preço', numCtl({ get: () => it.price, set: x => { it.price = x; changed(); }, min: 0, max: 10000000, step: 1, slider: false, compact: true, unit: o.currency || cur$() })));
            const cdd = dd(() => [{ v: '', l: T('Sem categoria') }].concat(o.categories.map(c => ({ v: c, l: c }))), () => it.category || '', x => { it.category = x; changed(); }, { noi18n: true });
            catSync.push(() => cdd.sync());
            l1.appendChild(fld('Categoria', cdd));
            const av = h('<div class="pad-swl"></div>'); av.appendChild(sw(() => it.available !== false, x => { it.available = x; w.classList.toggle('off', !x); changed(); })); av.appendChild(h('<span>Disponível</span>'));
            l1.appendChild(fld('', av));
            l2.appendChild(fld('Descrição', txt(() => it.desc, x => { it.desc = x; changed(); }, { max: 200, ph: 'Uma linha sobre o artigo' })));
            l2.appendChild(fld('Imagem', txt(() => it.image, x => { it.image = x.trim(); paintImg(); changed(); }, { max: 300, mono: true, ph: 'https://...', valid: x => /^(https|nui):\/\/[^\s"'<>]+$/.test(x) })));
            w.classList.toggle('off', it.available === false);
            paintImg();
            return w;
          },
        })));
        orderBox.appendChild(subBox('Formulário da encomenda', 'Perguntas extra na encomenda (entrega, morada, notas). Pode ficar vazio.', fieldsEd(o, 12)));
        orderBox.appendChild(subBox('Estados da encomenda', 'O primeiro é o de uma encomenda nova. "Avisa o autor" manda uma notificação a quem encomendou.', statusEd(o)));
        orderBox.hidden = !o.orderable;
        p.appendChild(orderBox);
      },
      billing(o, p) {
        const presetSync = [];
        const g = h('<div class="pad-grid g2"></div>');
        g.appendChild(fld('Valor máximo por fatura', numCtl({ get: () => o.maxAmount, set: x => { o.maxAmount = x; presetSync.forEach(f => f()); changed(); }, min: 1, max: billMax(), step: 1, slider: false, compact: true, unit: cur$() }), { hint: TF('O teto das faturas do servidor é %s.', money(billMax())) }));
        p.appendChild(g);
        const sws = h('<div class="pad-sides two"></div>');
        sws.appendChild(swRow(o, 'society', 'Paga à conta da empresa', 'O dinheiro vai para a conta do emprego, como nas faturas de empresa do Faturas.'));
        sws.appendChild(swRow(o, 'reasonRequired', 'Motivo obrigatório', 'Quem passa a fatura tem de escrever o motivo.'));
        p.appendChild(sws);
        p.appendChild(subBox('Valores rápidos', 'Botões com motivo e valor já preenchidos (por exemplo, multas). O cidadão paga no Faturas.', listEd({
          get: () => o.presets, max: 12, addLabel: 'Adicionar valor', empty: 'Sem valores rápidos.', onChange: () => changed(),
          make: () => ({ label: '', amount: 100 }),
          row: pr => {
            const g2 = h('<div class="ovk-in pad-inline"></div>');
            g2.appendChild(fld('Motivo', txt(() => pr.label, x => { pr.label = x; changed(); }, { max: 40, ph: 'Ex.: Excesso de velocidade' })));
            const n = numCtl({ get: () => pr.amount, set: x => { pr.amount = x; mark(); changed(); }, min: 1, max: billMax(), step: 1, slider: false, compact: true, unit: cur$() });
            const mark = () => { n.classList.toggle('over', Number(pr.amount) > Number(o.maxAmount)); };
            presetSync.push(mark); mark();
            g2.appendChild(fld('Valor', n));
            return g2;
          },
        })));
      },
      duty(o, p) {
        const g = h('<div class="pad-grid g2"></div>');
        g.appendChild(fld('Prefixo fora de serviço (ESX)', txt(() => o.esxOffPrefix, x => { o.esxOffPrefix = x; changed(); }, { max: 12, mono: true, ph: 'off', filter: x => x.toLowerCase().replace(/[^a-z0-9_]/g, '') }), { hint: 'No ESX, sair de serviço troca o emprego para prefixo + emprego (ex.: offpolice) com o mesmo grau. Vazio: no ESX o serviço fica com o servidor.' }));
        p.appendChild(g);
        const sws = h('<div class="pad-sides two"></div>');
        sws.appendChild(swRow(o, 'showTeam', 'Mostrar a equipa em serviço', 'Quem está de serviço e desde quando (para quem tem a permissão Ver).'));
        p.appendChild(sws);
        p.appendChild(h('<div class="pad-note pad-note-box">No QBCore e no QBox o botão usa o serviço do próprio framework. Cada entrada e saída fica registada como um turno, com as horas da semana.</div>'));
      },
      info(o, p) {
        p.appendChild(fld('Imagem de topo (opcional)', txt(() => o.hero, x => { o.hero = x.trim(); changed(); }, { max: 300, mono: true, ph: 'https://...', valid: x => /^(https|nui):\/\/[^\s"'<>]+$/.test(x) })));
        p.appendChild(subBox('Blocos', 'A página, de cima para baixo.', listEd({
          get: () => o.blocks, max: 16, addLabel: 'Adicionar bloco', onChange: () => changed(),
          make: () => ({ type: 'text', title: '', text: '' }),
          row: b => {
            const w = h('<div class="pad-blk"><div class="ovk-in pad-inline"></div><div class="pad-blk-b"></div></div>');
            const bb = w.querySelector('.pad-blk-b');
            w.querySelector('.pad-inline').appendChild(fld('Tipo', dd(BTYPES.map(([v, l, i]) => ({ v, l, icon: i })), () => b.type, x => {
              b.type = x; ['url', 'x', 'y', 'hours', 'phone'].forEach(k => delete b[k]);
              if (x === 'hours') b.hours = { from: 9, to: 18, days: W15.slice() };
              paintB(); changed();
            })));
            w.querySelector('.pad-inline').appendChild(fld('Título', txt(() => b.title, x => { b.title = x; changed(); }, { max: 60 })));
            const paintB = () => {
              bb.textContent = '';
              const g = h('<div class="pad-grid g3"></div>');
              if (b.type === 'hours') {
                b.hours = Object.assign({ from: 9, to: 18, days: [] }, obj(b.hours)); b.hours.days = arr(b.hours.days);
                g.appendChild(fld('Abre às', numCtl({ get: () => b.hours.from, set: x => { b.hours.from = x; changed(); }, min: 0, max: 23, step: 1, slider: false, compact: true, unit: 'h' })));
                g.appendChild(fld('Fecha às', numCtl({ get: () => b.hours.to, set: x => { b.hours.to = x; changed(); }, min: 1, max: 24, step: 1, slider: false, compact: true, unit: 'h' })));
                bb.appendChild(g); bb.appendChild(daysCtl(() => b.hours.days, x => { b.hours.days = x; changed(); }));
                return;
              }
              if (b.type === 'link' || b.type === 'image') g.appendChild(fld(b.type === 'link' ? 'Endereço' : 'Imagem', txt(() => b.url, x => { b.url = x.trim(); changed(); }, { max: 300, mono: true, ph: 'https://...', valid: x => (b.type === 'link' ? /^https:\/\/[^\s"'<>]+$/ : /^(https|nui):\/\/[^\s"'<>]+$/).test(x) }), { span: 2 }));
              if (b.type === 'contact') g.appendChild(fld('Telefone', txt(() => b.phone, x => { b.phone = x; changed(); }, { max: 16, mono: true, filter: x => x.replace(/[^\d+\-#* ]/g, '') })));
              if (b.type === 'location') {
                const nx = numCtl({ get: () => b.x, set: x => { b.x = x; changed(); }, min: -20000, max: 20000, step: 0.01, slider: false, compact: true, allowEmpty: true });
                const ny = numCtl({ get: () => b.y, set: x => { b.y = x; changed(); }, min: -20000, max: 20000, step: 0.01, slider: false, compact: true, allowEmpty: true });
                g.appendChild(fld('X', nx)); g.appendChild(fld('Y', ny));
                g.appendChild(fld('', btn('Usar a minha posição', { kind: 'ghost', sm: true, icon: 'location', on: async () => { const r = await call('admin.here', {}); if (!r.ok) return; b.x = r.x; b.y = r.y; nx.sync(); ny.sync(); changed(); } })));
              }
              g.appendChild(fld('Texto', txt(() => b.text, x => { b.text = x; changed(); }, { max: 1000, area: b.type === 'text', rows: 3 }), { span: 3 }));
              bb.appendChild(g);
            };
            paintB();
            return w;
          },
        })));
      },
    };
    function daysCtl(get, set) {
      const w = h('<div class="pad-days"></div>');
      DAYS.forEach(([n, l]) => {
        const b = h(`<button type="button" class="pad-tgl"><span></span></button>`); b.querySelector('span').textContent = l;
        const paint = () => b.classList.toggle('on', get().includes(n));
        b.onclick = () => { const s = new Set(get()); if (s.has(n)) { if (s.size === 1) { toast('Tem de ficar pelo menos um dia.', 'err'); return; } s.delete(n); } else s.add(n); set([...s].sort((a, c) => a - c)); paint(); };
        paint(); w.appendChild(b);
      });
      return w;
    }

    /* ---------- pré-visualização ao vivo ---------- */
    function buildPreview(side) {
      const pv = h(`<div class="pad-pv">
        <div class="pad-pv-top"><span>Pré-visualização</span></div>
        <div class="pad-pv-home"><div class="pad-pv-tiles"></div></div>
        <div class="pad-pv-phone"><div class="pad-pv-scr">
          <div class="pad-pv-sb"><span>9:41</span><i></i><span class="pad-pv-sbr">${ic('wifi', 11)}${ic('battery', 13)}</span></div>
          <div class="pad-pv-hd"><span class="pad-pv-ic"></span><div class="pad-pv-tt"><b data-noi18n></b><small data-noi18n></small></div><span class="pad-pv-call" hidden>${ic('phoneFill', 13)}<span data-noi18n></span></span></div>
          <div class="pad-pv-role"></div>
          <div class="pad-pv-body" data-noi18n></div>
          <div class="pad-pv-tabbar" data-noi18n></div>
        </div></div>
      </div>`);
      const top = pv.querySelector('.pad-pv-top');
      top.appendChild(seg([{ v: false, l: 'Claro' }, { v: true, l: 'Escuro' }], () => ed.pvDark, x => { ed.pvDark = x; paintPreview(); }, { small: true }));
      const tiles = pv.querySelector('.pad-pv-tiles');
      ['phone', 'messages', 'CAPP', 'maps'].forEach(id => {
        const t = h(`<div class="pad-pv-tile"><span class="pad-pv-tic"></span><small></small></div>`);
        if (id === 'CAPP') { t.classList.add('me'); t.querySelector('.pad-pv-tic').innerHTML = cappIconHTML(ed.draft, 46); t.querySelector('small').setAttribute('data-noi18n', ''); }
        else { t.querySelector('.pad-pv-tic').innerHTML = appTileHTML(id, 46); t.querySelector('small').textContent = (window.App && App.name) ? App.name(id) : id; }
        tiles.appendChild(t);
      });
      const role = pv.querySelector('.pad-pv-role');
      ed.pvRoleSeg = seg([{ v: 'civil', l: 'Cidadão' }, { v: 'staff', l: 'Equipa' }], () => ed.pvRole, x => { ed.pvRole = x; ed.pvMod = 0; paintPreview(); }, { small: true });
      role.appendChild(ed.pvRoleSeg);
      side.appendChild(pv);
      ed.pv = pv;
      paintPreview();
    }
    function visMods() { const d = ed.draft; return d.modules.filter(m => m.enabled && (ed.pvRole === 'civil' ? m.civil : m.staff)); }
    function paintPreview() {
      if (!ed || !ed.pv) return;
      const d = ed.draft, pv = ed.pv, acc = HEX.test(d.accent) ? d.accent : '#1F5EFF';
      pv.classList.toggle('dark', !!ed.pvDark);
      const me = pv.querySelector('.pad-pv-tile.me');
      paintCappIcon(me.querySelector('.pad-capic'), d); me.querySelector('small').textContent = d.name || '';
      const hi = pv.querySelector('.pad-pv-ic'); if (!hi.firstChild) hi.innerHTML = cappIconHTML(d, 34); paintCappIcon(hi.firstChild, d);
      pv.querySelector('.pad-pv-tt b').textContent = d.name || '';
      pv.querySelector('.pad-pv-tt small').textContent = d.subtitle || '';
      const call0 = pv.querySelector('.pad-pv-call'); call0.hidden = !d.contact.phone; call0.style.background = acc; call0.style.color = readable(acc); call0.querySelector('span').textContent = d.contact.label || d.contact.phone;
      const hasStaff = d.audience.jobs.length > 0, hasCivil = d.audience.public;
      if (!hasStaff && ed.pvRole === 'staff') ed.pvRole = 'civil';
      if (!hasCivil && hasStaff && ed.pvRole === 'civil') ed.pvRole = 'staff';
      pv.querySelector('.pad-pv-role').hidden = !(hasStaff && hasCivil);
      ed.pvRoleSeg.sync();
      /* separadores */
      const mods = visMods(); if (ed.pvMod >= d.modules.length) ed.pvMod = 0;
      const want = d.modules[ed.pvMod]; const act = mods.includes(want) ? want : mods[0];
      const tb = pv.querySelector('.pad-pv-tabbar'); tb.textContent = '';
      const shown = mods.length > 5 ? mods.slice(0, 4) : mods;
      shown.forEach(m => { const t = h(`<button type="button" class="pad-pv-tab${m === act ? ' on' : ''}">${glyph(m.icon || 'grid', 18)}<span></span></button>`); t.querySelector('span').textContent = m.title; if (m === act) t.style.color = acc; t.onclick = () => { ed.pvMod = d.modules.indexOf(m); paintPreview(); }; tb.appendChild(t); });
      if (mods.length > 5) {
        const t = h(`<button type="button" class="pad-pv-tab${shown.includes(act) ? '' : ' on'}">${ic('more', 18)}<span></span></button>`); t.querySelector('span').textContent = T('Mais');
        if (!shown.includes(act)) t.style.color = acc;
        t.onclick = () => { const rest = mods.slice(4); const i = rest.indexOf(act); const nx = rest[(i + 1) % rest.length]; ed.pvMod = d.modules.indexOf(nx); paintPreview(); };
        tb.appendChild(t);
      }
      /* corpo */
      const body = pv.querySelector('.pad-pv-body'); body.textContent = '';
      if (!act) { body.appendChild(h(`<div class="pv-empty">${esc(T(ed.pvRole === 'civil' ? 'Sem módulos para o cidadão.' : 'Sem módulos para a equipa.'))}</div>`)); return; }
      body.appendChild(h(`<div class="pv-h1">${esc(act.title || '')}</div>`));
      PV[act.type] && PV[act.type](act.options, body, acc, ed.pvRole, act);
    }
    const readable = hex => { const c = parseInt(String(hex).slice(1), 16); const r = (c >> 16) & 255, g = (c >> 8) & 255, b = c & 255; return (0.299 * r + 0.587 * g + 0.114 * b) > 165 ? '#111111' : '#FFFFFF'; };
    const pvBtn = (label, acc) => `<div class="pv-btn" style="background:${acc};color:${readable(acc)}">${esc(label)}</div>`;
    const skel = (w) => `<i class="pv-sk" style="width:${w}%"></i>`;
    const pvMoney = (n, cur) => { const v = Number(n) || 0; const s = Number.isInteger(v) ? fmtN(v) : v.toFixed(2).replace('.', ','); return currency.position === 'before' ? (cur || cur$()) + s : s + ' ' + (cur || cur$()); };
    /* um campo do formulário como o telemóvel o desenha (simplificado) */
    function pvField(f, acc) {
      const cond = f.showIf && f.showIf.key ? ' cond' : '';
      const help = f.help && f.type !== 'info' ? `<small class="pv-help">${esc(f.help)}</small>` : '';
      const lab = `<span class="pv-fl">${esc(f.label)}${f.required ? '<em>*</em>' : ''}</span>`;
      switch (f.type) {
        case 'section': return `<div class="pv-sec${cond}"><b>${esc(f.label)}</b>${f.help ? `<small>${esc(f.help)}</small>` : ''}</div>`;
        case 'info': return `<div class="pv-info${cond}" style="border-left-color:${acc}"><b>${esc(f.label)}</b>${f.help ? `<small>${esc(f.help)}</small>` : ''}</div>`;
        case 'checkbox': return `<div class="pv-f${cond}"><div class="pv-in cb"><span class="pv-cb"${f.default === true ? ` style="background:${acc};border-color:${acc}"` : ''}></span><span>${esc(f.label)}${f.required ? '<em class="pv-req">*</em>' : ''}</span></div>${help}</div>`;
        case 'multiselect': { const def = arr(f.default); return `<div class="pv-f${cond}">${lab}<div class="pv-chips">${arr(f.options).slice(0, 4).map(x => `<span class="pv-chip"${def.includes(x) ? ` style="border-color:${acc};color:${acc}"` : ''}>${esc(x)}</span>`).join('')}</div>${help}</div>`; }
        case 'rating': return `<div class="pv-f${cond}">${lab}<div class="pv-stars">${[1, 2, 3, 4, 5].map(i => `<i style="color:${i <= (Number(f.default) || 0) ? acc : '#C7C7CC'}">${ic('star', 17)}</i>`).join('')}</div>${help}</div>`;
        case 'photo': return `<div class="pv-f${cond}">${lab}<div class="pv-photo">${ic('camera', 15)}<span>${esc(T('Escolher da galeria'))}</span></div>${help}</div>`;
      }
      let inner = `<span class="pv-ph">${esc(f.default != null ? f.default : (f.placeholder || ''))}</span>`;
      if (f.type === 'select') inner = `<span>${esc(f.default || arr(f.options)[0] || '')}</span>${ic('chevD', 12)}`;
      else if (f.type === 'date') inner = `<span class="pv-ph">${esc(f.default || f.placeholder || '--/--/----')}</span>${ic('calendar', 12)}`;
      else if (f.type === 'time') inner = `<span class="pv-ph">${esc(f.default || f.placeholder || '--:--')}</span>${ic('clock', 12)}`;
      return `<div class="pv-f${cond}">${lab}<div class="pv-in${f.type === 'textarea' ? ' ta' : ''}">${inner}</div>${help}</div>`;
    }
    const PV = {
      form(o, b, acc, role) {
        if (role === 'staff') {
          const sts = arr(o.statuses);
          b.appendChild(h(`<div class="pv-chips">${sts.slice(0, 4).map((s, i) => `<span class="pv-chip${i === 0 ? ' on' : ''}" style="${i === 0 ? `border-color:${s.color};color:${s.color}` : ''}">${esc(s.label)}</span>`).join('')}</div>`));
          [0, 1, 2].forEach(i => { const s = sts[i % Math.max(1, sts.length)] || { color: acc, label: '' }; b.appendChild(h(`<div class="pv-item"><div class="pv-item-t">${skel(70 - i * 12)}${skel(40)}</div><span class="pv-st" style="color:${s.color};border-color:${s.color}">${esc(s.label)}</span></div>`)); });
          return;
        }
        if (o.intro) b.appendChild(h(`<div class="pv-p">${esc(o.intro)}</div>`));
        const fs = arr(o.fields);
        fs.slice(0, 5).forEach(f => b.appendChild(h(pvField(f, acc))));
        if (fs.length > 5) b.appendChild(h(`<div class="pv-more">+${fs.length - 5}</div>`));
        const ex = [o.anonymous ? ic('eye', 12) : '', o.location ? ic('pin', 12) : '', o.photo ? ic('camera', 12) : ''].join('');
        if (ex) b.appendChild(h(`<div class="pv-ex">${ex}</div>`));
        b.appendChild(h(pvBtn(o.submitLabel || T('Enviar'), acc)));
      },
      appointments(o, b, acc, role) {
        const days = arr(o.days), dn = [1, 2, 3, 4, 5, 6, 0].map(i => (window.UI && UI.wdNarrow) ? UI.wdNarrow(i) : 'STQQSSD'[(i + 6) % 7]);   /* iniciais no idioma do jogo (UI.wdNarrow: 0 = domingo) */
        if (role === 'staff') { [0, 1, 2, 3].forEach(i => b.appendChild(h(`<div class="pv-item"><span class="pv-time" style="color:${acc}">${pad2(o.hours.from + i)}:00</span><div class="pv-item-t">${skel(65)}${skel(35)}</div></div>`))); return; }
        b.appendChild(h(`<div class="pv-chips">${arr(o.services).slice(0, 4).map((s, i) => `<span class="pv-chip${i === 0 ? ' on' : ''}" style="${i === 0 ? `border-color:${acc};color:${acc}` : ''}">${esc(s.label)}</span>`).join('')}</div>`));
        b.appendChild(h(`<div class="pv-days">${[1, 2, 3, 4, 5, 6, 7].map(n => `<span class="${days.includes(n) ? '' : 'off'}${n === days[0] ? ' on' : ''}" style="${n === days[0] ? `background:${acc};color:${readable(acc)}` : ''}">${dn[n - 1]}</span>`).join('')}</div>`));
        const slots = []; for (let m = o.hours.from * 60; m < o.hours.to * 60 && slots.length < 9; m += (o.slot || 30)) slots.push(`${pad2(Math.floor(m / 60))}:${pad2(m % 60)}`);
        b.appendChild(h(`<div class="pv-slots">${slots.map((s, i) => `<span class="${i === 1 ? 'on' : ''}" style="${i === 1 ? `border-color:${acc};color:${acc}` : ''}">${s}</span>`).join('')}</div>`));
        b.appendChild(h(pvBtn(T('Marcar'), acc)));
      },
      dispatch(o, b, acc, role) {
        if (role === 'staff') { [0, 1, 2].forEach(i => { const t = arr(o.types)[i % Math.max(1, arr(o.types).length)] || {}; b.appendChild(h(`<div class="pv-item"><span class="pv-tic" style="color:${acc}">${glyph(t.icon || 'bolt', 16)}</span><div class="pv-item-t"><b>${esc(t.label || '')}</b>${skel(45)}</div></div>`)); }); return; }
        b.appendChild(h(`<div class="pv-types">${arr(o.types).slice(0, 6).map(t => `<span class="pv-type"><i style="color:${acc}">${glyph(t.icon || 'bolt', 20)}</i><b>${esc(t.label)}</b></span>`).join('')}</div>`));
        b.appendChild(h(`<div class="pv-in"><span class="pv-ph"></span></div>`));
        b.appendChild(h(pvBtn(T('Pedir'), acc)));
      },
      records(o, b, acc) {
        b.appendChild(h(`<div class="pv-search">${ic('search', 12)}${skel(40)}</div>`));
        [0, 1, 2, 3].forEach(i => { const t = arr(o.tags)[i]; b.appendChild(h(`<div class="pv-item"><span class="pv-av">${ic(o.subject === 'vehicle' ? 'car' : o.subject === 'free' ? 'clipboard' : 'person', 14)}</span><div class="pv-item-t">${skel(60 - i * 8)}${skel(30)}</div>${t ? `<span class="pv-st" style="color:${t.color};border-color:${t.color}">${esc(t.label)}</span>` : ''}</div>`)); });
      },
      posts(o, b, acc) {
        if (o.audience === 'staff') b.appendChild(h(`<div class="pv-badge">${ic('lock', 11)}<span>${esc(T('Só a equipa'))}</span></div>`));
        [0, 1].forEach(i => b.appendChild(h(`<div class="pv-post"><div class="pv-post-img" style="background:linear-gradient(135deg,${acc},${acc}55)"></div><div class="pv-item-t">${skel(80 - i * 20)}${skel(95)}${skel(60)}</div></div>`)));
      },
      roster(o, b, acc) {
        [0, 1, 2, 3, 4].forEach(i => b.appendChild(h(`<div class="pv-item"><span class="pv-av round">${ic('person', 14)}</span><div class="pv-item-t">${skel(55 - (i % 3) * 8)}${skel(30)}</div><span class="pv-dot${i < 3 || o.showOffDuty ? '' : ' off'}" style="${i < 3 ? 'background:#10B981' : ''}"></span><span class="pv-tic" style="color:${acc}">${ic('phone', 14)}</span></div>`)));
      },
      catalog(o, b, acc, role) {
        const cur = o.currency, sts = arr(o.statuses);
        if (role === 'staff') {
          b.appendChild(h(`<div class="pv-chips">${sts.slice(0, 4).map((s, i) => `<span class="pv-chip${i === 0 ? ' on' : ''}" style="${i === 0 ? `border-color:${s.color};color:${s.color}` : ''}">${esc(s.label)}</span>`).join('')}</div>`));
          const its = arr(o.items);
          [0, 1, 2].forEach(i => {
            const s = sts[i % Math.max(1, sts.length)] || { color: acc, label: '' };
            const tot = its.slice(i, i + 2).reduce((a, x) => a + (Number(x.price) || 0) * (i + 1), 0);
            b.appendChild(h(`<div class="pv-item"><span class="pv-ord" style="color:${acc}">#${1042 - i}</span><div class="pv-item-t">${skel(62 - i * 10)}<small>${esc(pvMoney(tot, cur))}</small></div><span class="pv-st" style="color:${s.color};border-color:${s.color}">${esc(s.label)}</span></div>`));
          });
          if (o.billing) b.appendChild(h(`<div class="pv-ex">${ic('receipt', 12)}<span>${esc(T('Faturar a encomenda'))}</span></div>`));
          return;
        }
        const cats = arr(o.categories);
        if (cats.length) b.appendChild(h(`<div class="pv-chips">${cats.slice(0, 4).map((c, i) => `<span class="pv-chip${i === 0 ? ' on' : ''}" style="${i === 0 ? `border-color:${acc};color:${acc}` : ''}">${esc(c)}</span>`).join('')}</div>`));
        const first = cats.length ? arr(o.items).filter(x => x.category === cats[0]) : arr(o.items);
        const list = (first.length ? first : arr(o.items)).slice(0, 4);
        b.appendChild(h(`<div class="pv-cards">${list.map(x => `<div class="pv-card${x.available === false ? ' off' : ''}"><div class="pv-card-img" style="${/^(https|nui):\/\//.test(x.image || '') ? '' : `background:linear-gradient(150deg,${acc}33,${acc}0D)`}">${/^(https|nui):\/\//.test(x.image || '') ? `<img src="${esc(x.image)}" alt="">` : `<i style="color:${acc}">${glyph('food', 20)}</i>`}</div><b>${esc(x.label)}</b><div class="pv-card-p"><span>${esc(x.available === false ? T('Esgotado') : pvMoney(x.price, cur))}</span>${o.orderable && x.available !== false ? `<em style="background:${acc};color:${readable(acc)}">${ic('plus', 11)}</em>` : ''}</div></div>`).join('')}</div>`));
        if (o.orderable) {
          const tot = list.slice(0, 2).reduce((a, x) => a + (Number(x.price) || 0), 0);
          b.appendChild(h(`<div class="pv-cart" style="background:${acc};color:${readable(acc)}">${ic('cart', 14)}<span>${esc(TF('%s artigos', 2))}</span><b>${esc(pvMoney(tot, cur))}</b></div>`));
        }
      },
      billing(o, b, acc) {
        b.appendChild(h(`<div class="pv-bill"><span class="pv-fl">${esc(T('Valor'))}</span><div class="pv-amt">${esc(pvMoney(arr(o.presets)[0] ? arr(o.presets)[0].amount : 0))}</div></div>`));
        if (arr(o.presets).length) b.appendChild(h(`<div class="pv-chips">${arr(o.presets).slice(0, 3).map((x, i) => `<span class="pv-chip"${i === 0 ? ` style="border-color:${acc};color:${acc}"` : ''}>${esc(x.label)}</span>`).join('')}</div>`));
        b.appendChild(h(`<div class="pv-in"><span class="pv-ph">${esc(T('Número de telefone'))}</span>${ic('person', 12)}</div>`));
        b.appendChild(h(`<div class="pv-in"><span class="pv-ph">${esc(T('Motivo'))}${o.reasonRequired ? ' *' : ''}</span></div>`));
        b.appendChild(h(pvBtn(T('Passar fatura'), acc)));
        [[T('Paga'), '#10B981'], [T('Pendente'), '#F5A524']].forEach(([l, c], i) => b.appendChild(h(`<div class="pv-item"><span class="pv-tic" style="color:${acc}">${ic('receipt', 15)}</span><div class="pv-item-t">${skel(58 - i * 12)}${skel(30)}</div><span class="pv-st" style="color:${c};border-color:${c}">${esc(l)}</span></div>`)));
      },
      duty(o, b, acc) {
        b.appendChild(h(`<div class="pv-duty"><div class="pv-item-t"><b>${esc(T('Em serviço'))}</b><small>${esc(TF('desde %s', '14:02'))}</small></div><span class="pv-tog" style="background:${acc}"><i></i></span></div>`));
        b.appendChild(h(`<div class="pv-stat"><b>12 h 30 min</b><small>${esc(T('esta semana'))}</small></div>`));
        if (o.showTeam) {
          b.appendChild(h(`<div class="pv-sub">${esc(T('Em serviço agora'))}</div>`));
          [0, 1, 2].forEach(i => b.appendChild(h(`<div class="pv-item"><span class="pv-av round">${ic('person', 14)}</span><div class="pv-item-t">${skel(55 - i * 8)}${skel(28)}</div><span class="pv-dot" style="background:#10B981"></span></div>`)));
        }
      },
      info(o, b, acc) {
        if (o.hero) b.appendChild(h(`<div class="pv-hero"><img src="${esc(o.hero)}" alt=""></div>`));
        arr(o.blocks).slice(0, 5).forEach(x => {
          const bt = BTYPES.find(t => t[0] === x.type) || BTYPES[0];
          let sub = esc(x.text || '');
          if (x.type === 'hours' && x.hours) { const ds = arr(x.hours.days); sub = `${ds.length ? DAYS.filter(d2 => ds.includes(d2[0])).map(d2 => T(d2[1])).join(' ') : ''} · ${pad2(x.hours.from)}:00 - ${pad2(x.hours.to)}:00`; }
          if (x.type === 'contact' && x.phone) sub = esc(x.phone) + (x.text ? ' · ' + esc(x.text) : '');
          b.appendChild(h(`<div class="pv-blk"><span class="pv-tic" style="color:${acc}">${ic(bt[2], 15)}</span><div class="pv-item-t"><b>${esc(x.title || '')}</b><small>${sub}</small></div></div>`));
        });
      },
    };

    /* ---------- dados (registos desta app) ---------- */
    const STATUS_FALLBACK = { pending: 'Pendente', confirmed: 'Confirmada', cancelled: 'Cancelada', done: 'Concluído', waiting: 'À espera', accepted: 'Aceite', paid: 'Paga', unpaid: 'Por pagar', open: 'Em curso', closed: 'Terminado', active: 'Em serviço', ended: 'Terminado' };
    function dataPane(p) {
      const d = ed.draft, id = d.id;
      const f = { module: '', status: '', q: '', page: 0 };
      const hasSt = m => m && (m.type === 'form' || m.type === 'catalog');
      const bar = h('<div class="pad-toolbar"></div>');
      const modOpts = () => [{ v: '', l: T('Todos os módulos') }].concat(d.modules.filter(m => ['form', 'appointments', 'dispatch', 'records', 'posts', 'catalog', 'billing', 'duty'].includes(m.type)).map(m => ({ v: m.id, l: m.title })));
      const stOpts = () => { const m = d.modules.find(x => x.id === f.module); const s = hasSt(m) ? arr(m.options.statuses) : m && m.type === 'billing' ? [{ id: 'pending', label: T('Pendente') }, { id: 'paid', label: T('Paga') }] : []; return [{ v: '', l: T('Todos os estados') }].concat(s.map(x => ({ v: x.id, l: x.label }))); };
      const stDD = dd(stOpts, () => f.status, x => { f.status = x; load(true); }, { small: true, noi18n: true });
      bar.appendChild(dd(modOpts, () => f.module, x => { f.module = x; f.status = ''; stDD.sync(); load(true); }, { small: true, noi18n: true }));
      bar.appendChild(stDD);
      const qs = h(`<label class="pad-search ovk-search sm">${ic('search', 14)}<input class="ovk-in" spellcheck="false" placeholder="Procurar nos registos"></label>`);
      qs.querySelector('input').addEventListener('input', debounce(e => { f.q = e.target.value.trim(); load(true); }, 300));
      bar.appendChild(qs);
      bar.appendChild(btn('Atualizar', { kind: 'ghost', sm: true, icon: 'update', on: () => load(true) }));
      const sp = h('<span class="pad-grow"></span>'); bar.appendChild(sp);
      bar.appendChild(btn('Apagar todos os dados', { kind: 'ghost danger', sm: true, icon: 'trash', on: async () => {
        const ok = await confirmBox({ title: 'Apagar todos os dados?', text: TF('Todos os pedidos, marcações, fichas, encomendas, faturas, turnos e comunicados de %s são apagados de vez.', d.name), ok: 'Apagar tudo', danger: true });
        if (!ok) return; const r = await call('admin.capps.purge', { app: id }); if (r.ok) { toast('Dados apagados.'); load(true); }
      } }));
      p.appendChild(bar);
      const tw = h(`<div class="pad-card flat"><div class="pad-tblw"><table class="pad-tbl click"><thead><tr><th>#</th><th>Módulo</th><th>Assunto</th><th>Autor</th><th>Estado</th><th>Atualizado</th></tr></thead><tbody></tbody></table></div></div>`);
      const tbody = tw.querySelector('tbody');
      const foot = h('<div class="pad-tblfoot"><span class="pad-sum inline"></span></div>');
      const more = btn('Mostrar mais', { kind: 'ghost', sm: true, on: () => { f.page++; load(false); } }); foot.appendChild(more);
      tw.appendChild(foot);
      p.appendChild(tw);
      const statusOf = (it) => {
        const m = d.modules.find(x => x.id === it.module);
        const s = hasSt(m) ? arr(m.options.statuses).find(x => x.id === it.status) : null;
        return s ? { label: s.label, color: s.color, noi18n: true } : { label: STATUS_FALLBACK[it.status] || it.status || '-', color: it.status === 'paid' ? '#3FB97F' : '#8A8F98' };
      };
      let total = 0, shown = 0, seq = 0;
      async function load(reset) {
        if (reset) { f.page = 0; }
        const my = ++seq;
        const r = await call('admin.capps.items', { app: id, module: f.module || undefined, status: f.status || undefined, q: f.q || undefined, page: f.page }, { quiet: !reset });
        if (my !== seq) return;
        if (reset) { tbody.textContent = ''; shown = 0; }
        if (!r.ok) { if (reset) tbody.appendChild(h(`<tr class="pad-tr-empty"><td colspan="6">${esc(errMsg(r))}</td></tr>`)); more.hidden = true; return; }
        const items = arr(r.items); total = Number(r.total) || items.length;
        if (reset && !items.length) tbody.appendChild(h('<tr class="pad-tr-empty"><td colspan="6">Sem registos.</td></tr>'));
        items.forEach(it => {
          const m = d.modules.find(x => x.id === it.module);
          const st = statusOf(it);
          const tr = h(`<tr><td class="muted mono" data-noi18n></td><td data-noi18n></td><td class="strong" data-noi18n></td><td data-noi18n></td><td></td><td class="muted nowrap"></td></tr>`);
          const c = tr.children;
          c[0].textContent = it.id; c[1].textContent = m ? m.title : it.module; c[2].textContent = it.title || it.subject || '-';
          if (Number(it.anonymous) === 1 || it.anonymous === true) { c[3].textContent = T('Anónimo'); c[3].removeAttribute('data-noi18n'); c[3].className = 'muted'; } else c[3].textContent = it.owner_name || it.ownerName || '-';
          c[4].appendChild(chip(st.label, { dot: st.color, noi18n: st.noi18n }));
          c[5].textContent = ago(it.updated || it.created); c[5].title = fmtDate(it.updated || it.created);
          tr.onclick = () => openItem(it, tr);
          tbody.appendChild(tr); shown++;
        });
        more.hidden = shown >= total || !items.length;
        foot.querySelector('.pad-sum').textContent = TF('%s de %s registos', fmtN(shown), fmtN(total));
      }
      async function openItem(it, tr) {
        const r = await call('admin.capps.item', { id: it.id }); if (!r.ok) return;
        const x = obj(r.item || it), notes = arr(r.notes);
        const m = d.modules.find(y => y.id === x.module);
        let data = x.data; if (typeof data === 'string') { try { data = JSON.parse(data); } catch (e) { data = {}; } } data = obj(data);
        const anon = Number(x.anonymous) === 1 || x.anonymous === true;
        const box = h('<div class="pad-item"></div>');
        const meta = h('<div class="pad-meta"></div>');
        const mrow = (k, v, noi) => { if (v == null || v === '') return; const e = h(`<div><span></span><b${noi ? ' data-noi18n' : ''}></b></div>`); e.querySelector('span').textContent = k; e.querySelector('b').textContent = v; meta.appendChild(e); };
        mrow(T('Módulo'), m ? m.title : x.module, true); mrow(T('Estado'), statusOf(x).label, statusOf(x).noi18n);
        mrow(T('Autor'), anon ? T('Anónimo') : (x.owner_name || '-'), !anon);
        if (!anon) mrow(T('Telefone'), x.owner_phone, true);
        mrow(T('Atribuído a'), x.assignee_name, true); mrow(T('Sobre'), x.subject, true);
        if (x.at) mrow(T('Marcado para'), fmtDate(x.at), true);
        mrow(T('Criado'), fmtDate(x.created), true); mrow(T('Atualizado'), fmtDate(x.updated), true);
        if (x.x != null && x.y != null) mrow(T('Localização'), `${Number(x.x).toFixed(1)}, ${Number(x.y).toFixed(1)}`, true);
        box.appendChild(meta);
        /* encomenda: linhas e total (o total foi calculado no servidor) */
        const cur = m && m.type === 'catalog' ? m.options.currency : cur$();
        if (Array.isArray(data.lines) && data.lines.length) {
          const tb = h('<div class="pad-lines"></div>');
          data.lines.forEach(l => { const e = h('<div class="pad-line"><span class="pad-line-q" data-noi18n></span><span class="pad-line-l" data-noi18n></span><b data-noi18n></b></div>'); e.children[0].textContent = (Number(l.qty) || 1) + '×'; e.children[1].textContent = l.label || l.id || '-'; e.children[2].textContent = pvMoney((Number(l.price) || 0) * (Number(l.qty) || 1), cur); tb.appendChild(e); });
          const t = h('<div class="pad-line total"><span></span><span class="pad-line-l">Total</span><b data-noi18n></b></div>'); t.querySelector('b').textContent = pvMoney(data.total, cur); tb.appendChild(t);
          box.appendChild(subBox('Encomenda', null, tb));
        }
        /* fatura */
        if (data.billId != null || data.amount != null) {
          const bm = h('<div class="pad-meta"></div>');
          const add = (k, v) => { if (v == null || v === '') return; const e = h('<div><span></span><b data-noi18n></b></div>'); e.querySelector('span').textContent = k; e.querySelector('b').textContent = v; bm.appendChild(e); };
          add(T('Valor'), data.amount != null ? pvMoney(data.amount) : null); add(T('Motivo'), data.reason); add(T('Para'), data.to); add(T('Fatura'), data.billId != null ? '#' + data.billId : null);
          box.appendChild(subBox('Fatura', null, bm));
        }
        const fields = m ? arr(m.options.fields) : [];
        const answers = isObj(data.fields) ? data.fields : data;
        const skip = new Set(['lines', 'total', 'fields', 'billId', 'amount', 'reason', 'to']);
        const keys = Object.keys(answers).filter(k => !skip.has(k) && answers[k] !== '' && answers[k] != null);
        if (keys.length) {
          const dl = h('<div class="pad-dl"></div>');
          keys.forEach(k => { const fd = fields.find(y => y.key === k); const e = h('<div><span data-noi18n></span><p data-noi18n></p></div>'); e.querySelector('span').textContent = fd ? fd.label : k; const v = answers[k]; e.querySelector('p').textContent = typeof v === 'boolean' ? (v ? T('Sim') : T('Não')) : Array.isArray(v) ? v.join(', ') : (typeof v === 'object' ? JSON.stringify(v) : String(v)); dl.appendChild(e); });
          box.appendChild(subBox('Respostas', null, dl));
        }
        const nl = h('<div class="pad-notes"></div>');
        if (!notes.length) nl.appendChild(h('<div class="pad-empty">Sem notas nem respostas.</div>'));
        notes.forEach(n => { const e = h(`<div class="pad-note-i${n.staff ? ' staff' : ''}${n.private ? ' priv' : ''}"><div class="pad-note-h"><b data-noi18n></b><small></small></div><p data-noi18n></p></div>`); e.querySelector('b').textContent = n.author_name || '-'; const s = e.querySelector('small'); s.textContent = `${n.private ? T('Privada') + ' · ' : ''}${ago(n.created)}`; e.querySelector('p').textContent = n.text || ''; nl.appendChild(e); });
        box.appendChild(subBox('Notas e respostas', null, nl));
        const del = btn('Apagar registo', { kind: 'ghost danger', icon: 'trash', on: async () => {
          const ok = await confirmBox({ title: 'Apagar este registo?', text: 'Sai da app para toda a gente. Isto não se pode desfazer.', ok: 'Apagar', danger: true }); if (!ok) return;
          const rr = await call('admin.capps.delete', { id: x.id }); if (rr.ok) { closeSheet(); tr.remove(); shown--; total--; foot.querySelector('.pad-sum').textContent = TF('%s de %s registos', fmtN(shown), fmtN(total)); toast('Registo apagado.'); }
        } });
        sheet(x.title || x.subject || ('#' + x.id), box, { noi18n: true, sub: `#${x.id} · ${m ? m.title : x.module}`, foot: [del] });
      }
      load(true);
    }

    return {
      reset() { pageEl = null; listView = null; edView = null; ed = null; q = ''; JOBS = null; jobsP = null; closeTpl(); },
      build(v) { pageEl = v; buildList(v); },
      show() { show(); },
      editing: () => !!ed,
      edit, home: () => home(),
      closeLayer: () => closeTpl(),
      crumbs: () => (ed ? [{ t: ed.draft.name || ed.draft.id || T('Nova app'), noi18n: true }] : []),
      filter(x) { q = x; applyQ(); },
    };
  })();

  /* ============================================================
     6. WEBHOOKS (globais: registo do painel e compras na loja)
     ============================================================ */
  const hookSync = [];
  const okUrl = x => /^https:\/\/[\w.-]+\//.test(String(x || ''));
  function makeHooksDoc() {
    const s = { admin: String(boot.webhooks.admin || ''), shop: String(boot.webhooks.shop || '') };
    docs.webhooks = {
      label: T('Webhooks globais'),
      saved: s, draft: clone(s),
      async save() {
        const bad = ['admin', 'shop'].find(k => this.draft[k] && !okUrl(this.draft[k]));
        if (bad) { toast(ERR.webhook, 'err'); return; }
        const r = await call('admin.webhooks.save', { admin: this.draft.admin, shop: this.draft.shop });
        if (!r.ok) return;
        boot.webhooks = obj(r.webhooks || this.draft); makeHooksDoc(); hookSync.forEach(f => f());
        toast('Webhooks guardados.');
      },
      discard() { this.draft = clone(this.saved); hookSync.forEach(f => f()); },
    };
  }
  SEC.webhooks = (() => {
    let appsBox = null;
    function paintApps() {
      if (!appsBox) return;
      appsBox.textContent = '';
      if (!boot.capps.length) { appsBox.appendChild(h('<div class="pad-empty">Ainda não há apps de trabalho.</div>')); return; }
      boot.capps.forEach(a => {
        const w = obj(a.webhooks), ev = Object.keys(obj(w.events)).filter(k => w.events[k]).length, on = okUrl(w.url) || Object.keys(obj(w.urls)).length > 0;
        const e = h(`<div class="pad-hookapp">${cappIconHTML(a, 32)}<div class="pad-hookapp-t"><b data-noi18n></b><small></small></div></div>`);
        e.querySelector('b').textContent = a.name;
        e.querySelector('small').textContent = on ? (ev === 1 ? T('1 evento ligado') : TF('%s eventos ligados', ev)) : T('Sem webhook');
        e.appendChild(chip(on ? 'Ligado' : 'Desligado', { kind: on ? 'ok' : '', dot: on ? 'var(--k-ok)' : null }));
        e.appendChild(btn('Configurar', { kind: 'ghost', sm: true, on: () => { go('capps'); SEC.capps.edit(a.id).then(() => { const t = root.querySelector('.pad-ed-tabs .pad-tabs'); if (t && t.pick && SEC.capps.editing()) t.pick('hooks'); }); } }));
        appsBox.appendChild(e);
      });
    }
    return {
      reset() { hookSync.length = 0; appsBox = null; },
      build(v) {
        v.appendChild(head('Webhooks', 'Mensagens automáticas para canais do Discord (ou compatíveis). Cada app de trabalho tem também os seus webhooks.', []));
        const cols = h('<div class="pad-cols pad-cols-11"></div>');
        const one = (k, title, sub, icon) => {
          const c = card(title, { icon, sub });
          const st = h('<span></span>');
          const paintSt = () => { st.textContent = ''; const v2 = docs.webhooks.draft[k]; st.appendChild(v2 ? (okUrl(v2) ? chip('Ligado', { kind: 'ok', dot: 'var(--k-ok)' }) : chip('URL inválido', { kind: 'bad' })) : chip('Desligado')); };
          c.act.appendChild(st);
          const inp = txt(() => docs.webhooks.draft[k], x => { docs.webhooks.draft[k] = x.trim(); paintSt(); touch(); }, { max: 300, mono: true, ph: 'https://discord.com/api/webhooks/...', valid: okUrl });
          const r = h('<div class="pad-hookrow"></div>'); r.appendChild(fld('URL do webhook', inp));
          r.appendChild(btn('Testar', { kind: 'ghost', icon: 'send', on: async b => {
            const u = docs.webhooks.draft[k]; if (!okUrl(u)) { toast(ERR.webhook, 'err'); return; }
            b.disabled = true; const res = await call('admin.webhooks.test', { url: u }); b.disabled = false;
            if (res.ok) toast('Mensagem de teste enviada.');
          } }));
          c.body.appendChild(r);
          hookSync.push(() => { inp.sync(); paintSt(); });
          paintSt();
          return c.el;
        };
        cols.appendChild(one('admin', 'Registo do painel', 'Cada alteração guardada aqui (definições, loja, apps) é enviada com o nome de quem a fez.', 'list'));
        cols.appendChild(one('shop', 'Compras na loja', 'Cada telemóvel vendido: jogador, produto, preço, forma de pagamento e loja.', 'bag2'));
        v.appendChild(cols);
        const c3 = card('Apps de trabalho', { icon: 'briefcase', sub: 'Os webhooks de cada app configuram-se no editor da app, no separador Webhooks.' });
        appsBox = h('<div class="pad-hookapps"></div>'); c3.body.appendChild(appsBox);
        v.appendChild(c3.el);
        paintApps();
      },
      show() { paintApps(); },
    };
  })();

  /* ============================================================
     6b. APARÊNCIA (4 out; refeita a 11 nov com o ovkit): para a LOJA e para este PAINEL, a cor de marca, a cor de
     fundo, a opacidade do vidro e se o jogo fica desfocado por trás. A paleta inteira sai daqui no html/js/overlay.js
     (OvTheme.vars). Este painel muda já enquanto se escolhe (OvTheme.preview); cada cartão tem uma mini janela feita
     com as peças do ovkit e os tokens do rascunho. Guardar = server/admin.lua 'admin.theme.save' → GlobalState →
     todos os jogadores (o desfoque é do client/overlay.lua).
     ============================================================ */
  const themeSync = [];
  let thLiveT = null;   /* pré-visualização ao vivo pendente (SEC.theme.live); o hide() e o discard cancelam-na */
  const OVT = () => window.OvTheme || null;
  const TH_DEF = { acc: '#1F5EFF', bg: '#131314', glass: 86 };
  const TH_BLUR = { shop: false, admin: true };
  const thDef = () => (OVT() && OVT().DEF) || TH_DEF;
  const thBlurDef = k => { const b = OVT() && OVT().BLUR_DEF; return b && typeof b[k] === 'boolean' ? b[k] : TH_BLUR[k]; };
  const G_MIN = () => (OVT() && OVT().GLASS_MIN) || 60, G_MAX = () => (OVT() && OVT().GLASS_MAX) || 100;
  /* tons rápidos (marca: claros o bastante para se lerem; fundo: todos escuros o bastante para o texto claro) */
  const TH_ACC = ['#1F5EFF', '#4C7DFF', '#0EA5E9', '#14C3D6', '#22C55E', '#84CC16', '#F59E0B', '#F43F5E', '#EC4899', '#8B5CF6'];
  const TH_BG = ['#131314', '#0A0A0B', '#1A1A1B', '#0B1430', '#071826', '#07140D', '#110C22', '#180A10', '#15100A', '#141821'];
  const thOkAcc = x => !x || (OVT() ? OVT().okAcc(x) : HEX.test(x));
  const thOkBg = x => !x || (OVT() ? OVT().okBg(x) : HEX.test(x));
  const thOkGlass = g => g == null || (OVT() ? OVT().okGlass(Number(g)) : (Number(g) >= 60 && Number(g) <= 100));
  /* uma camada como o painel a edita: { acc, bg, glass (null = origem), blur (sempre boolean) } */
  function thPart(p, k) {
    if (OVT() && OVT().part) return OVT().part(p, k);
    p = obj(p);
    return { acc: HEX.test(p.acc) ? String(p.acc).toUpperCase() : '', bg: HEX.test(p.bg) ? String(p.bg).toUpperCase() : '', glass: typeof p.glass === 'number' ? Math.round(p.glass) : null, blur: typeof p.blur === 'boolean' ? p.blur : TH_BLUR[k] };
  }
  const thOk = p => thOkAcc(p.acc) && thOkBg(p.bg) && thOkGlass(p.glass);
  /* o que vai para o servidor: só o que não é de origem (glass vazio e blur igual ao de origem ficam de fora) */
  function thSend(p, k) {
    const o = { acc: p.acc || '', bg: p.bg || '' };
    if (p.glass != null) o.glass = Math.round(p.glass);
    if (typeof p.blur === 'boolean' && p.blur !== thBlurDef(k)) o.blur = p.blur;
    return o;
  }
  function makeThemeDoc() {
    const t = obj(boot.theme), s = { shop: thPart(t.shop, 'shop'), admin: thPart(t.admin, 'admin') };
    if (OVT()) OVT().set(s);
    docs.theme = {
      label: T('Aparência'),
      saved: s, draft: clone(s),
      async save() {
        if (!thOk(this.draft.shop) || !thOk(this.draft.admin)) { toast('Há uma cor que não serve: o fundo tem de ser escuro e a cor de marca não pode ser quase preta.', 'err'); return; }
        const r = await call('admin.theme.save', { shop: thSend(this.draft.shop, 'shop'), admin: thSend(this.draft.admin, 'admin') });
        if (!r.ok) return;
        boot.theme = obj(r.theme || this.draft); makeThemeDoc(); themeSync.forEach(f => f());
        toast('Aparência guardada. Os jogadores já veem as cores novas.');
      },
      discard() { clearTimeout(thLiveT); thLiveT = null; this.draft = clone(this.saved); if (OVT()) OVT().restore(); themeSync.forEach(f => f()); },
    };
  }
  SEC.theme = (() => {
    /* o OvTheme.preview reescreve uma <style> e reestiliza o documento inteiro: a arrastar o vidro ou o seletor de cor
       chegam 60 eventos por segundo, por isso o painel e a loja só se repintam no máximo a cada 60 ms (a mini janela
       de cada cartão segue o rato, é pequena) */
    const live = () => { if (thLiveT) return; thLiveT = setTimeout(() => { thLiveT = null; if (OVT() && docs.theme && isOpen()) OVT().preview(docs.theme.draft); }, 60); };
    const decl = o => Object.keys(o).map(x => `${x}:${o[x]}`).join(';');
    /* mini janela da camada, feita com as peças do ovkit: os tokens --k-* do rascunho vão no style (o .ovk dela
       volta a derivar os outros tokens a partir destes). Por trás, uma rua em gradientes faz de jogo: com o desfoque
       ligado passa a uma versão suave (o CEF não tem filter). */
    function mini(k) {
      const shop = k === 'shop';
      const w = h(`<div class="pad-thpv-bg"><div class="pad-thpv ovk ovk-win" aria-hidden="true">
        <div class="ovk-head pad-thpv-h"><span class="ovk-badge sm">${ic(shop ? 'phone' : 'sliders', 16)}</span><div class="pad-thpv-tt"><b class="ovk-title"></b><span class="ovk-sub"></span></div><span class="ovk-live ok"></span><span class="ovk-close pad-thpv-x">${ic('x', 14)}<span class="ovk-key">ESC</span></span></div>
        <div class="pad-thpv-b"><div class="pad-thpv-chips"></div><div class="ovk-tray pad-thpv-tray"></div><div class="pad-thpv-f"><span class="ovk-btn sm"></span><span class="ovk-btn pri sm"></span></div></div>
      </div></div>`);
      const tt = w.querySelector('.pad-thpv-tt b'), st = w.querySelector('.pad-thpv-tt .ovk-sub');
      if (shop) { tt.textContent = 'Digital Den'; tt.setAttribute('data-noi18n', ''); st.textContent = T('Loja de telemóveis'); w.querySelector('.ovk-live').textContent = T('Loja aberta'); }   /* 'Aberta' sozinho já é uma chave noutro sentido (mensagem aberta) */
      else { tt.textContent = T('Centro de controlo'); st.textContent = 'Apex Phone'; st.setAttribute('data-noi18n', ''); w.querySelector('.ovk-live').textContent = T('Ao vivo'); }
      const chips = w.querySelector('.pad-thpv-chips');
      (shop ? [['Todos', 6, 1], ['PearPhone', 2, 0, 1], ['NOVA', 2, 0, 1]] : [['Visão geral', 0, 1], ['Loja', 0], ['Apps', 0]]).forEach(([l, n, on, raw]) => {
        const c = h(`<span class="ovk-chip${on ? ' on' : ''}"><span${raw ? ' data-noi18n' : ''}></span>${n ? `<span class="n" data-noi18n>${n}</span>` : ''}</span>`);
        c.firstChild.textContent = l; chips.appendChild(c);
      });
      const tray = w.querySelector('.pad-thpv-tray');
      (shop ? [['PearPhone 18', 1499], ['NOVA S26', 1399], ['AirPods Pro 3', 279]] : [['Telemóvel', 'sliders'], ['Apps', 'grid'], ['Loja', 'bag2']]).forEach(([l, x], i) => {
        const t = h(`<span class="ovk-tile pad-thpv-tile${i === 0 ? ' on' : ''}"><span class="ovk-corners"></span>${shop ? '' : `<span class="pad-thpv-ti">${ic(x, 18)}</span>`}<b${shop ? ' data-noi18n' : ''}></b>${shop ? `<span class="ovk-mono" data-noi18n>${esc(money(x))}</span>` : ''}</span>`);
        t.querySelector('b').textContent = l; tray.appendChild(t);
      });
      const f = w.querySelectorAll('.pad-thpv-f .ovk-btn');
      f[0].textContent = shop ? T('Cancelar') : T('Descartar');
      f[1].innerHTML = ic(shop ? 'bag2' : 'check', 14); f[1].appendChild(document.createElement('span')).textContent = shop ? T('Comprar') : T('Guardar');
      return w;
    }
    function part(k, title, sub, icon) {
      const other = k === 'shop' ? 'admin' : 'shop';
      const c = card(title, { icon, sub, cls: 'pad-thcard' });
      const P = () => docs.theme.draft[k];
      const reset = btn('Repor', { kind: 'ghost', sm: true, icon: 'update', title: T('Volta às cores de origem'), on: () => { docs.theme.draft[k] = thPart({}, k); syncAll(); } });
      /* copiar para a outra camada (as quatro coisas: marca, fundo, vidro e desfoque) */
      c.act.appendChild(btn(k === 'shop' ? 'Usar o mesmo no painel' : 'Usar o mesmo na loja', { icon: 'copy', sm: true, on: () => { docs.theme.draft[other] = clone(P()); syncAll(); toast(k === 'shop' ? 'O painel fica com a mesma aparência da loja.' : 'A loja fica com a mesma aparência do painel.', 'info'); } }));
      c.act.appendChild(reset);
      /* pré-visualização ao vivo */
      const pv = mini(k), win = pv.querySelector('.pad-thpv');
      c.body.appendChild(pv);
      /* paletas prontas */
      const pre = h('<div class="pad-thsec"><div class="ovk-label">Paletas prontas</div><div class="pad-presets"></div></div>');
      const pg = pre.querySelector('.pad-presets');
      const PRE = (OVT() && OVT().PRESETS) || [{ id: 'apex', label: 'Apex', brand: true, acc: TH_DEF.acc, bg: TH_DEF.bg }];
      const preEls = PRE.map(x => {
        const b = h(`<button type="button" class="ovk-tile pad-preset" title="${esc(x.acc + ' / ' + x.bg)}"><span class="ovk-corners"></span><span class="pad-preset-sw" style="background:${x.bg}"><i style="background:${x.acc}"></i><i style="background:${x.acc}"></i></span><b${x.brand ? ' data-noi18n' : ''}></b></button>`);
        b.querySelector('b').textContent = x.label;
        b.onclick = e => { e.stopPropagation(); const p = P(), isDef = x.acc.toUpperCase() === thDef().acc.toUpperCase() && x.bg.toUpperCase() === thDef().bg.toUpperCase(); p.acc = isDef ? '' : x.acc.toUpperCase(); p.bg = isDef ? '' : x.bg.toUpperCase(); syncAll(); };
        pg.appendChild(b); return { x, b };
      });
      c.body.appendChild(pre);
      /* cor de marca e cor de fundo */
      const cols = h('<div class="pad-thsec"><div class="ovk-label">Cores<span class="pad-thnote"></span></div><div class="pad-thcols"></div><div class="pad-thwarn" hidden></div></div>');
      const accC = colorCtl(() => P().acc, v => { P().acc = v; paint(); live(); touch(); }, { ph: thDef().acc, tones: TH_ACC, allowEmpty: true, valid: x => thOkAcc(x) });
      const bgC = colorCtl(() => P().bg, v => { P().bg = v; paint(); live(); touch(); }, { ph: thDef().bg, tones: TH_BG, allowEmpty: true, valid: x => thOkBg(x) });
      const cc = cols.querySelector('.pad-thcols');
      cc.appendChild(fld('Cor de marca', accC));
      cc.appendChild(fld('Cor de fundo (escura)', bgC));
      const warn = cols.querySelector('.pad-thwarn'), fnote = cols.querySelector('.pad-thnote');
      c.body.appendChild(cols);
      /* vidro e jogo */
      const gl = h(`<div class="pad-thsec"><div class="ovk-label">Vidro e jogo</div><div class="pad-thcols">
        <div class="pad-thcell"><div class="pad-thcell-h"><span>Opacidade do vidro</span><b class="ovk-mono" data-noi18n></b></div><input type="range" class="ovk-range no-kb" step="1"><small>Menos opaco, mais se vê o jogo por trás.</small></div>
        <div class="pad-thcell"><div class="pad-thcell-h"><span>Desfocar o jogo por trás</span></div><div class="pad-thsw"></div><small></small></div>
      </div></div>`);
      const rg = gl.querySelector('input'), gv = gl.querySelector('.pad-thcell-h b');
      rg.min = G_MIN(); rg.max = G_MAX();
      const glassOf = () => (P().glass != null ? P().glass : thDef().glass);
      rg.addEventListener('input', () => { const v = Math.round(Number(rg.value)); P().glass = v; paintGlass(); paint(); live(); touch(); });
      const paintGlass = () => { const v = glassOf(); if (Number(rg.value) !== v) rg.value = v; rg.style.setProperty('--p', ((v - G_MIN()) / (G_MAX() - G_MIN()) * 100).toFixed(1)); gv.textContent = v + ' %'; };
      const bsw = sw(() => P().blur, x => { P().blur = x; paint(); live(); touch(); });
      gl.querySelector('.pad-thsw').appendChild(bsw);
      const bh = gl.querySelector('.pad-thcell:last-child small');
      c.body.appendChild(gl);
      function paint() {
        const p = P(), accOk = thOkAcc(p.acc), bgOk = thOkBg(p.bg);
        accC.querySelector('input').classList.toggle('bad', !accOk); bgC.querySelector('input').classList.toggle('bad', !bgOk);
        const msg = !bgOk ? T('Fundo claro demais: escolhe uma cor escura (o texto da camada é claro).') : !accOk ? T('Cor de marca escura demais: no fundo escuro não se vê.') : '';
        warn.hidden = !msg; warn.textContent = msg;
        /* a mini janela: rascunho válido, ou o de origem no que não serve */
        const ok = { acc: accOk ? p.acc : '', bg: bgOk ? p.bg : '', glass: p.glass };
        if (OVT()) win.setAttribute('style', decl(OVT().vars(ok)));
        pv.classList.toggle('blur', !!p.blur);
        const ea = (accOk && p.acc ? p.acc : thDef().acc).toUpperCase(), eb = (bgOk && p.bg ? p.bg : thDef().bg).toUpperCase();
        preEls.forEach(({ x, b }) => b.classList.toggle('on', x.acc.toUpperCase() === ea && x.bg.toUpperCase() === eb));
        bh.textContent = p.blur === thBlurDef(k) ? T('Como vem de origem.') : (p.blur ? T('Ligado nesta camada.') : T('Desligado nesta camada.'));
        const isDef = !p.acc && !p.bg && p.glass == null && p.blur === thBlurDef(k);
        reset.disabled = isDef;
        fnote.textContent = isDef ? T('De origem: azul Apex sobre cinza escuro') : '';
      }
      function sync() { accC.sync(); bgC.sync(); bsw.sync(); paintGlass(); paint(); }
      themeSync.push(sync); sync();
      return c.el;
    }
    function syncAll() { themeSync.forEach(f => f()); live(); touch(); }
    return {
      reset() { themeSync.length = 0; },
      build(v) {
        v.appendChild(head('Aparência', 'Cor de marca, cor de fundo, vidro e desfoque da loja e deste painel. O painel muda já enquanto escolhes; os jogadores só veem depois de guardares.', []));
        const cols = h('<div class="pad-cols pad-cols-11 pad-thwrap"></div>');
        cols.appendChild(part('shop', 'Loja de telemóveis', 'A janela onde se compram os telemóveis.', 'bag2'));
        cols.appendChild(part('admin', 'Painel admin', 'Este centro de controlo (/phoneadmin).', 'sliders'));
        v.appendChild(cols);
      },
      show() { themeSync.forEach(f => f()); live(); },
    };
  })();

  /* ============================================================
     7. REGISTO (alterações feitas no painel)
     ============================================================ */
  SEC.log = (() => {
    let tbody = null, more = null, sum = null, page = 0, q = '', seq = 0, rows = 0;
    async function load(reset) {
      if (!tbody) return;
      if (reset) page = 0;
      const my = ++seq;
      const r = await call('admin.log', { page, q }, { quiet: !reset });
      if (my !== seq) return;
      if (reset) { tbody.textContent = ''; rows = 0; }
      if (!r.ok) { if (reset) tbody.appendChild(h(`<tr class="pad-tr-empty"><td colspan="4">${esc(errMsg(r))}</td></tr>`)); more.hidden = true; return; }
      const list = arr(r.rows);
      if (reset && !list.length) tbody.appendChild(h(`<tr class="pad-tr-empty"><td colspan="4">${q ? 'Nada encontrado.' : 'Ainda não há alterações registadas.'}</td></tr>`));
      list.forEach(x => {
        const lab = ACTIONS[x.action];
        const tr = h(`<tr><td class="muted nowrap"></td><td class="strong" data-noi18n></td><td><span class="pad-act"></span></td><td class="pad-td-detail" data-noi18n></td></tr>`);
        const c = tr.children; c[0].textContent = ago(x.at); c[0].title = fmtDate(x.at); c[1].textContent = x.admin || '-';
        const a = c[2].querySelector('.pad-act'); a.textContent = lab || x.action || '-'; if (!lab) a.setAttribute('data-noi18n', '');
        a.dataset.k = String(x.action || '').split('.')[0];
        c[3].textContent = x.detail || ''; c[3].title = x.detail || '';
        tbody.appendChild(tr); rows++;
      });
      more.hidden = !r.more;
      sum.textContent = rows === 1 ? T('1 alteração') : TF('%s alterações', fmtN(rows));
    }
    const qLater = debounce(() => load(true), 300);
    return {
      reset() { tbody = null; q = ''; page = 0; },
      build(v) {
        v.appendChild(head('Registo', 'Tudo o que foi guardado neste painel, por quem e quando. Usa a pesquisa em cima para filtrar por nome, ação ou detalhe.', [btn('Atualizar', { kind: 'ghost', icon: 'update', on: () => load(true) })]));
        const c = h(`<div class="pad-card flat"><div class="pad-tblw"><table class="pad-tbl"><thead><tr><th style="width:130px">Quando</th><th style="width:200px">Quem</th><th style="width:240px">Ação</th><th>Detalhe</th></tr></thead><tbody></tbody></table></div></div>`);
        tbody = c.querySelector('tbody');
        const foot = h('<div class="pad-tblfoot"><span class="pad-sum inline"></span></div>'); sum = foot.querySelector('.pad-sum');
        more = btn('Mostrar mais', { kind: 'ghost', sm: true, on: () => { page++; load(false); } }); foot.appendChild(more);
        c.appendChild(foot);
        v.appendChild(c);
        load(true);
      },
      filter(x) { if (x === q) return; q = x; qLater(); },
    };
  })();

  /* ============================================================
     LIGAÇÕES
     ============================================================ */
  if (window.Bridge && Bridge.on) {
    Bridge.on('admin:open', () => open());
    Bridge.on('admin:close', () => hide(false));
  }
  if (window.Overlay && Overlay.onClose) Overlay.onClose('admin', () => hide(false));

  /* ============================================================
     MODO DE TESTE (browser / _shot.html): respostas falsas mas realistas para cada pedido admin.*
     ============================================================ */
  if (window.Bridge && !Bridge.inFiveM && window.Overlay) {
    const now = Date.now(), MIN = 60000, H = 3600000, DAY = 86400000;
    const SCHEMA = {
      groups: [{ id: 'general', label: 'Geral', icon: 'gear' }, { id: 'calls', label: 'Chamadas', icon: 'phone' }, { id: 'number', label: 'Número e SIM', icon: 'sim' }, { id: 'social', label: 'Redes e extras', icon: 'users' }, { id: 'limits', label: 'Limites', icon: 'gauge' }],
      settings: [
        { path: 'DefaultLanguage', group: 'general', type: 'select', label: 'Idioma das contas novas', options: ['en', 'pt', 'es', 'fr', 'de', 'it', 'nl', 'pl', 'sv', 'da', 'tr', 'ru', 'ja', 'ko', 'zh-Hans', 'zh-Hant'] },
        { path: 'DefaultTheme', group: 'general', type: 'select', label: 'Tema das contas novas', options: ['light', 'dark', 'auto'] },
        { path: 'Scale', group: 'general', type: 'num', label: 'Tamanho do telemóvel no ecrã', min: 0.4, max: 1.2, step: 0.01 },
        { path: 'AllowWalking', group: 'general', type: 'bool', label: 'Andar com o telemóvel aberto' },
        { path: 'ShowCursor', group: 'general', type: 'bool', label: 'Mostrar o ponteiro do rato' },
        { path: 'BlockWhenDead', group: 'general', type: 'bool', label: 'Bloquear o telemóvel quando morto' },
        { path: 'RequireItem', group: 'general', type: 'bool', label: 'Precisa do item do telemóvel no inventário' },
        { path: 'PeekSeconds', group: 'general', type: 'int', label: 'Segundos da pré-visualização de avisos', min: 1, max: 15 },
        { path: 'AutoMails', group: 'general', type: 'bool', label: 'Emails automáticos do servidor' },
        { path: 'AutoOpenOnCall', group: 'calls', type: 'bool', label: 'Abrir o telemóvel ao receber uma chamada' },
        { path: 'CallTimeout', group: 'calls', type: 'int', label: 'Segundos a tocar antes de não atendida', min: 5, max: 120 },
        { path: 'UseVoice', group: 'calls', type: 'bool', label: 'Voz nas chamadas' },
        { path: 'ServiceCooldown', group: 'calls', type: 'int', label: 'Segundos entre pedidos a serviços', min: 0, max: 3600 },
        { path: 'NumberPrefix', group: 'number', type: 'text', label: 'Indicativo mostrado antes do número', max: 8 },
        { path: 'AllowSimSwap', group: 'number', type: 'bool', label: 'Permitir trocar de SIM' },
        { path: 'SyncNumberToCharInfo', group: 'number', type: 'bool', label: 'Escrever o número no framework' },
        { path: 'Social.instashot', group: 'social', type: 'bool', label: 'Instashot' },
        { path: 'Social.twix', group: 'social', type: 'bool', label: 'Twix' },
        { path: 'Social.reels', group: 'social', type: 'bool', label: 'Reels' },
        { path: 'Social.darkchat', group: 'social', type: 'bool', label: 'Dark Chat' },
        { path: 'Onion.enabled', group: 'social', type: 'bool', label: 'Mercado anónimo (Onion)' },
        { path: 'Onion.crypto', group: 'social', type: 'bool', label: 'Carteira de cripto' },
        { path: 'Marketplace.transferItems', group: 'social', type: 'bool', label: 'Marketplace entrega itens' },
        { path: 'AI.enabled', group: 'social', type: 'bool', label: 'Assistente Vera Chat' },
        { path: 'Browser.enabled', group: 'social', type: 'bool', label: 'Navegador' },
        { path: 'MaxPhotos', group: 'limits', type: 'int', label: 'Fotografias por jogador', min: 10, max: 500 },
        { path: 'DarkChatTTL', group: 'limits', type: 'int', label: 'Minutos até apagar o Dark Chat (0 = nunca)', min: 0, max: 10080 },
        { path: 'Notifications.keepDays', group: 'limits', type: 'int', label: 'Dias que as notificações ficam guardadas', min: 1, max: 90 },
        { path: 'Notifications.maxPerPlayer', group: 'limits', type: 'int', label: 'Notificações guardadas por jogador', min: 20, max: 1000 },
      ],
    };
    const DEFAULTS = { DefaultLanguage: 'en', DefaultTheme: 'light', Scale: 0.82, AllowWalking: true, ShowCursor: true, BlockWhenDead: true, RequireItem: true, PeekSeconds: 4, AutoMails: true, AutoOpenOnCall: false, CallTimeout: 30, UseVoice: true, ServiceCooldown: 60,
      NumberPrefix: '', AllowSimSwap: true, SyncNumberToCharInfo: true, 'Social.instashot': true, 'Social.twix': true, 'Social.reels': true, 'Social.darkchat': true, 'Onion.enabled': true, 'Onion.crypto': true, 'Marketplace.transferItems': true,
      'AI.enabled': true, 'Browser.enabled': true, MaxPhotos: 150, DarkChatTTL: 1440, 'Notifications.keepDays': 14, 'Notifications.maxPerPlayer': 200 };
    const V = (item, color, swatch, extra) => Object.assign({ item, color, swatch, model: item + '.glb' }, extra || {});
    const SHOP = {
      enabled: true, currency: defCur(), payment: { accounts: ['bank', 'cash'], default: 'bank' },
      interaction: { mode: 'auto', distance: 2.0, key: 38, keyLabel: 'E', icon: 'fa-solid fa-mobile-screen-button' }, closeDistance: 6.0, serverDistance: 10.0,
      camera: { enabled: true, distance: 1.85, height: 0.55, shift: 0.78, fov: 42.0, ease: 700 }, hidePlayer: true,
      ped: { model: 's_m_m_lifeinvad_01', scenario: 'WORLD_HUMAN_STAND_MOBILE', spawnDistance: 70.0, snapToPavement: true, snapMax: 6.0 },
      blip: { enabled: true, sprite: 817, spriteModern: 817, modernBuild: 3570, color: 3, scale: 0.85 },
      shops: [
        { id: 'vinewood', label: 'Store · West Vinewood', coords: { x: -505.32, y: 288.64, z: 83.29, w: 95.58 }, vendor: { name: 'Tom', role: 'Vendedor', greeting: 'Hi! We have the PearPhone, the NOVA and the foldables. Spin them around as much as you like before you buy.' }, ped: { snapToPavement: false } },
      ],
      categories: [{ id: 'all', label: 'Todos', icon: 'grid' }, { id: 'pearphone', label: 'PearPhone', icon: 'pear' }, { id: 'nova', label: 'NOVA', icon: 'nova' }, { id: 'foldables', label: 'Dobráveis', icon: 'fold' }, { id: 'audio', label: 'Auriculares', icon: 'buds' }],
      products: [
        { id: 'pear18', name: 'PearPhone 18 Pro Max', brand: 'PearPhone', os: 'PearOS 27', categories: ['pearphone'], price: 1499, tagline: 'O PearPhone mais avançado de sempre.',
          features: ['Ecrã OLED de 6,9 polegadas a 120 Hz', 'Sistema de câmaras Pro de 48 MP', 'PearOS 27 com a assistente Vera', 'Bateria para um dia inteiro'], specs: { screen: '6,9"', camera: '48 MP', chip: 'P19 Pro', battery: '4 685 mAh' },
          usage: 'Usa-o no inventário para abrir o PearOS. Fala com qualquer PearPhone ou NOVA.', variants: [V('pear18_black', 'Preto', '#2C2D31'), V('pear18_white', 'Branco', '#E7E5E0'), V('pear18_ice', 'Azul-gelo', '#AFC7DA'), V('pear18_wine', 'Bordô', '#6A2433')] },
        { id: 's26', name: 'NOVA S26 Ultra', brand: 'NOVA', os: 'Nova UI 9', categories: ['nova'], price: 1399, tagline: 'Potência sem limites, com a Nova UI 9.',
          features: ['Ecrã de 6,8 polegadas a 120 Hz', 'Câmara de 200 MP com zoom de 10x', 'Nova UI 9 com a assistente Vera', 'As mesmas apps e conta do PearPhone'], specs: { screen: '6,8"', camera: '200 MP', chip: 'Nova X5', battery: '5 000 mAh' },
          usage: 'Usa-o no inventário para abrir a Nova UI.', variants: [V('s26_black', 'Preto', '#25272C'), V('s26_white', 'Branco', '#E6E5E1'), V('s26_violet', 'Violeta', '#8576B0'), V('s26_sky', 'Azul-celeste', '#9DBFE0')] },
        { id: 'pearfold', name: 'PearPhone Fold', brand: 'PearPhone', os: 'PearOS 27', categories: ['pearphone', 'foldables'], price: 2199, badge: 'Novo', tagline: 'Um ecrã grande que se fecha no bolso.',
          features: ['Ecrã interior dobrável de 7,8 polegadas', 'Dobradiça que fecha totalmente plana', 'Duas apps lado a lado no ecrã aberto', 'PearOS 27 com a assistente Vera'], specs: { screen: '7,8"', camera: '48 MP', chip: 'P19 Pro', battery: '4 400 mAh' },
          usage: 'Usa-o no inventário para abrir o PearOS.', variants: [V('pearfold_night', 'Azul-noite', '#27344E'), V('pearfold_star', 'Branco-estrela', '#D9DEE4')] },
        { id: 'novaflip', name: 'NOVA Fold8', brand: 'NOVA', os: 'Nova UI 9', categories: ['nova', 'foldables'], price: 1199, badge: 'Novo', tagline: 'Abre como um livro, com um ecrã interior largo.',
          features: ['Dobradiça lateral para abrir como um livro', 'Ecrã exterior para usar o aparelho fechado', 'Ecrã interior largo para as tuas aplicações', 'Nova UI 9 com a assistente Vera'], specs: { screen: '8,0"', camera: '200 MP', chip: 'Nova X5', battery: '4 400 mAh' },
          usage: 'Usa-o no inventário para abrir a Nova UI.', variants: [V('novaflip_lavender', 'Lavanda', '#BBAED8'), V('novaflip_grey', 'Cinzento', '#5D6266', { enabled: false }), V('novaflip_cream', 'Creme', '#E8DDB9'), V('novaflip_pistachio', 'Pistácio', '#AEC08A')] },
        { id: 'airpods', name: 'AirPods Pro 3', brand: 'PearPhone', os: 'Bluetooth', categories: ['audio'], price: 279, tagline: 'Som envolvente, sem fios nenhuns.',
          features: ['Ligam-se ao telemóvel por Bluetooth', 'Música só para ti, com o telemóvel fechado', 'Atendes chamadas sem tirar o telemóvel', 'Cancelamento ativo de ruído'], specs: { battery: '30 h', audio: 'ANC' },
          usage: 'Usa o item para os pores e liga-os em Definições > Bluetooth.', variants: [V('airpods', 'Branco', '#F2F2F0')] },
        { id: 'slate_buds', name: 'NOVA Buds 4 Pro', brand: 'NOVA', os: 'Bluetooth', categories: ['audio'], price: 229, enabled: false, tagline: 'Ligam-se a qualquer telemóvel por Bluetooth',
          features: ['Estojo de carregamento', 'Cancelamento ativo de ruído', 'Música só para ti, com o telemóvel no bolso', 'Chamadas em mãos livres'], specs: { battery: '28 h', audio: 'ANC' },
          usage: 'Usa o item para os pores e liga-os em Definições > Bluetooth.', variants: [V('slate_buds', 'Preto', '#202124')] },
      ],
    };
    const NAMES = ['Tiago Marques', 'Inês Carvalho', 'Rafael Sousa', 'Beatriz Lopes', 'Duarte Nunes', 'Matilde Freitas', 'Gustavo Reis', 'Leonor Pinto', 'Afonso Cunha', 'Carolina Matos'];
    const PICKS = [['pear18_black', 'PearPhone 18 Pro Max · Preto', 1499], ['s26_violet', 'NOVA S26 Ultra · Violeta', 1399], ['airpods', 'AirPods Pro 3', 279], ['pearfold_night', 'PearPhone Fold · Azul-noite', 2199], ['novaflip_cream', 'NOVA Fold8 · Creme', 1199], ['pear18_ice', 'PearPhone 18 Pro Max · Azul-gelo', 1499]];
    const recent = [4, 19, 47, 95, 160, 290, 410, 720, 1300, 2200].map((m, i) => { const p = PICKS[i % PICKS.length]; return { at: now - m * MIN, name: NAMES[i], item: p[0], label: p[1], price: p[2], account: i % 3 === 2 ? 'cash' : 'bank', shop: 'vinewood' }; });
    const MS = {
      overrides: { CallTimeout: 45, 'Social.reels': false, MaxPhotos: 200 }, disabled: ['darkchat', 'onion'],
      shop: null, capps: null, hooks: { admin: 'https://discord.com/api/webhooks/120394/painel-apex', shop: '' },
      log: [
        { id: 9, at: now - 6 * MIN, admin: 'Apex Scripts', action: 'shop.save', detail: 'Loja ligada · 6 produtos · 1 loja' },
        { id: 8, at: now - 52 * MIN, admin: 'Apex Scripts', action: 'capps.save', detail: 'LSPD (lspd) · 5 módulos' },
        { id: 7, at: now - 3 * H, admin: 'Marta Silva', action: 'settings.save', detail: '3 definições alteradas, 2 apps desligadas' },
        { id: 6, at: now - 5 * H, admin: 'Marta Silva', action: 'capps.save', detail: 'Pillbox (pillbox) · 4 módulos' },
        { id: 5, at: now - 26 * H, admin: 'Apex Scripts', action: 'webhooks.save', detail: 'Registo: ligado · Loja: desligado' },
        { id: 4, at: now - 2 * DAY, admin: 'Marta Silva', action: 'capps.order', detail: '2 apps reordenadas' },
        { id: 3, at: now - 3 * DAY, admin: 'Apex Scripts', action: 'shop.reset', detail: 'Loja reposta no config.lua' },
        { id: 2, at: now - 4 * DAY, admin: 'consola', action: 'settings.reset', detail: 'Definições repostas no config.lua' },
      ],
      items: [], hist: {},
    };
    const ensureMock = () => {
      if (MS.shop) return;
      MS.shop = clone(SHOP);
      const lspd = TEMPLATES[0].make(), pill = TEMPLATES[1].make();
      lspd.created = now - 9 * DAY; lspd.updated = now - 52 * MIN; pill.created = now - 6 * DAY; pill.updated = now - 5 * H;
      pill.webhooks.url = 'https://discord.com/api/webhooks/99/pillbox';
      MS.capps = [lspd, pill];
      const SUBJ = ['Furto de carteira no parque', 'Carro riscado à porta de casa', 'Ameaças por mensagem', 'Assalto à loja de conveniência', 'Burla na venda de um carro', 'Barulho na rua às 3h', 'Vandalismo na paragem', 'Agressão no bar Vanilla'];
      const STS = ['nova', 'analise', 'investigacao', 'resolvida', 'arquivada'];
      for (let i = 0; i < 26; i++) {
        const mod = i % 4 === 3 ? 'ocorrencias' : 'denuncias';
        MS.items.push({ id: 1040 - i, app: 'lspd', module: mod, kind: mod === 'ocorrencias' ? 'call' : 'form', owner_name: NAMES[i % NAMES.length], owner_phone: '555-0' + (110 + i), anonymous: i % 5 === 1 ? 1 : 0,
          status: mod === 'ocorrencias' ? ['waiting', 'accepted', 'done'][i % 3] : STS[i % STS.length], title: mod === 'ocorrencias' ? ['Pedir patrulha', 'Acidente', 'Pessoa suspeita'][i % 3] : SUBJ[i % SUBJ.length],
          data: mod === 'denuncias' ? { tipo: ['Furto', 'Vandalismo', 'Ameaças', 'Roubo'][i % 4], local: 'Vinewood Boulevard', descricao: 'Estava a sair do trabalho quando aconteceu. Tenho testemunhas.', matricula: i % 2 ? '46EEK572' : '' } : { mensagem: 'Preciso de ajuda aqui.' },
          x: 215.4 + i, y: -810.2 - i, assignee_name: i % 3 === 0 ? 'Agente Costa' : null, created: now - (i * 3 + 1) * H, updated: now - (i * 3) * H - 20 * MIN });
      }
      MS.items.push({ id: 2001, app: 'pillbox', module: 'consultas', kind: 'appt', owner_name: 'Leonor Pinto', status: 'confirmed', title: 'Consulta geral', at: now + DAY, created: now - 2 * H, updated: now - H });
      /* v2: restaurante (catálogo com encomendas, faturas e turnos) */
      const rest = TEMPLATES.find(t => t.key === 'restaurant').make(); rest.created = now - 2 * DAY; rest.updated = now - 3 * H;
      MS.capps.push(rest);
      const ORD = [[['classico', 'Clássico', 9, 2], ['batatas', 'Batatas fritas', 4, 2], ['refrigerante', 'Refrigerante', 2, 2]], [['bacon', 'Duplo bacon', 12, 1], ['batido', 'Batido de morango', 4, 1]], [['vegetariano', 'Vegetariano', 10, 3]]];
      ['recebida', 'preparar', 'caminho', 'entregue', 'pronta', 'cancelada'].forEach((st, i) => {
        const lines = ORD[i % 3].map(([id, label, price, qty]) => ({ id, label, price, qty })), total = lines.reduce((a, l) => a + l.price * l.qty, 0);
        MS.items.push({ id: 3010 - i, app: 'burgershot', module: 'menu', kind: 'order', owner_name: NAMES[(i + 3) % NAMES.length], owner_phone: '555-0' + (140 + i), anonymous: 0, status: st, title: `Encomenda de ${NAMES[(i + 3) % NAMES.length].split(' ')[0]}`,
          data: { lines, total, fields: { entrega: i % 2 ? 'Entrega em casa' : 'Levantar no balcão', morada: i % 2 ? 'Rua Grove, 14' : '', notas: i === 0 ? 'Sem cebola, por favor.' : '' } }, x: i % 2 ? -120.4 : null, y: i % 2 ? -1590.2 : null, created: now - (i * 2 + 1) * H, updated: now - i * 2 * H });
      });
      MS.items.push({ id: 3101, app: 'burgershot', module: 'faturacao', kind: 'bill', owner_name: 'Rafael Sousa', status: 'paid', title: 'Serviço de catering', data: { billId: 881, amount: 500, reason: 'Serviço de catering', to: '555-0182' }, created: now - DAY, updated: now - 20 * H });
      MS.items.push({ id: 3102, app: 'burgershot', module: 'servico', kind: 'shift', owner_name: 'Carolina Matos', status: 'ended', title: 'Turno de 4 h 10 min', data: { start: now - 30 * H, end: now - 26 * H, minutes: 250 }, created: now - 30 * H, updated: now - 26 * H });
      /* histórico de versões: a LSPD tem três versões (a mais antiga ainda sem multas, quadro interno nem serviço) */
      const v1 = clone(lspd); v1.modules = v1.modules.filter(m => !['multas', 'quadro', 'servico'].includes(m.id)); v1.updated = now - 9 * DAY;
      const v2 = clone(lspd); v2.modules = v2.modules.filter(m => m.id !== 'servico'); v2.updated = now - 2 * DAY;
      MS.hist = { lspd: [{ at: lspd.updated, by: 'Apex Scripts', def: clone(lspd) }, { at: v2.updated, by: 'Marta Silva', def: v2 }, { at: v1.updated, by: '', def: v1 }] };
    };
    const settingsPayload = () => {
      const values = {}; Object.keys(DEFAULTS).forEach(p => { values[p] = MS.overrides[p] !== undefined ? MS.overrides[p] : DEFAULTS[p]; });
      return { values, defaults: clone(DEFAULTS), overrides: clone(MS.overrides) };
    };
    const shopStats = () => ({ salesTotal: 184320, salesCount: 131, today: { count: 7, total: 9871 },
      top: [{ item: 'pear18', label: 'PearPhone 18 Pro Max', count: 52, total: 77948 }, { item: 's26', label: 'NOVA S26 Ultra', count: 31, total: 43369 }, { item: 'pearfold', label: 'PearPhone Fold', count: 12, total: 26388 }, { item: 'novaflip', label: 'NOVA Fold8', count: 14, total: 16786 }, { item: 'airpods', label: 'AirPods Pro 3', count: 22, total: 6138 }],
      recent: recent.slice() });
    const stats = () => ({ online: 47, accounts: 1284, shop: shopStats(), capps: { lspd: { open: 9, total: 26, last: now - 40 * MIN }, pillbox: { open: 2, total: 11, last: now - 2 * H }, burgershot: { open: 4, total: 8, last: now - H } }, log: MS.log.slice(0, 8) });
    const addLog = (action, detail) => MS.log.unshift({ id: (MS.log[0] ? MS.log[0].id : 0) + 1, at: Date.now(), admin: 'Apex Scripts', action, detail });
    const M2 = Overlay.mock;
    M2['admin.bootstrap'] = () => { ensureMock(); return { ok: true, me: 'Apex Scripts', schema: clone(SCHEMA), settings: settingsPayload(), disabledApps: MS.disabled.slice(), shop: clone(MS.shop), shopDefaults: clone(SHOP), shopReady: true,
      capps: clone(MS.capps), categories: ['Serviços públicos', 'Emprego', 'Empresas'], limits: { maxApps: 40, maxModules: 10, billMax: 1000000, histKeep: 10 }, webhooks: clone(MS.hooks), theme: themePay(), stats: stats() }; };
    /* retrato do admin na demonstração (no jogo é o headshot do ped, client/admin.lua): ilustração ao estilo das capas do
       GTA V, contorno grosso e cores chapadas, num SVG embutido (nada vem da internet) */
    const DEMO_AV = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">'
      + '<defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFC24A"/><stop offset=".55" stop-color="#F0782F"/><stop offset="1" stop-color="#B8322A"/></linearGradient></defs>'
      + '<rect width="128" height="128" fill="url(#s)"/>'
      + '<g fill="#000" opacity=".12"><path d="M-12 128 L70 -10 L84 -10 L2 128Z"/><path d="M40 128 L122 -10 L136 -10 L54 128Z"/></g>'
      + '<circle cx="98" cy="30" r="16" fill="#FFE7A3" opacity=".75"/>'
      + '<g stroke="#141414" stroke-width="3" stroke-linejoin="round">'
      + '<path d="M14 128 C16 102 34 92 64 90 C94 92 112 102 114 128Z" fill="#2F4A3A"/>'
      + '<path d="M50 90 L64 108 L78 90" fill="#E9E2D0"/>'
      + '<path d="M54 76 L54 94 C58 99 70 99 74 94 L74 76Z" fill="#B97A50"/>'
      + '<path d="M38 54 C38 30 52 22 64 22 C78 22 90 30 90 54 C90 72 80 86 64 88 C48 86 38 72 38 54Z" fill="#C98B5E"/>'
      + '<path d="M38 52 C34 52 33 62 39 64Z" fill="#B97A50"/><path d="M90 52 C94 52 95 62 89 64Z" fill="#B97A50"/>'
      + '<path d="M41 66 C44 80 54 88 64 88 C74 88 84 80 87 66 C82 72 76 74 64 74 C52 74 46 72 41 66Z" fill="#3B2619"/>'
      + '<path d="M56 78 C60 80 68 80 72 78" fill="none" stroke-width="2.5"/>'
      + '<path d="M36 40 C38 22 52 14 66 14 C82 14 92 24 92 40Z" fill="#1E1E22"/>'
      + '<path d="M34 41 L94 41 C97 41 98 45 94 46 L34 46 C30 45 31 41 34 41Z" fill="#1E1E22"/>'
      + '<path d="M40 50 L60 50 C60 60 56 63 49 63 C43 63 40 58 40 50Z" fill="#101114"/><path d="M68 50 L88 50 C88 58 85 63 79 63 C72 63 68 60 68 50Z" fill="#101114"/>'
      + '<path d="M60 52 L68 52" fill="none" stroke-width="3"/>'
      + '</g>'
      + '<path d="M44 53 L50 53" stroke="#fff" stroke-width="2" opacity=".7"/><path d="M72 53 L78 53" stroke="#fff" stroke-width="2" opacity=".7"/>'
      + '<path d="M58 22 C62 19 70 19 74 22" fill="none" stroke="#3A3A42" stroke-width="2"/>'
      + '</svg>');
    M2['admin.me.photo'] = () => ({ ok: true, url: DEMO_AV });
    /* a mesma conta do server/admin.lua: { acc, bg, glass (60 a 100 ou nada), blur (boolean ou nada) } por camada */
    const themePay = () => { const t = obj(MS.theme), o = {}; ['shop', 'admin'].forEach(k => { const s = obj(t[k]); o[k] = { acc: s.acc || '', bg: s.bg || '', blur: typeof s.blur === 'boolean' ? s.blur : TH_BLUR[k] }; if (s.glass != null) o[k].glass = s.glass; }); return o; };
    M2['admin.theme.save'] = d => {
      const out = {};
      for (const k of ['shop', 'admin']) {
        const x = obj(d[k]), p = {};
        for (const f of ['acc', 'bg']) { const v = x[f]; if (v == null || v === '') continue; if (!HEX.test(v) || !(f === 'acc' ? thOkAcc(v) : thOkBg(v))) return { ok: false, error: 'invalid', field: k + '.' + f }; p[f] = String(v).toUpperCase(); }
        if (x.glass != null && x.glass !== '') { const g = Math.round(Number(x.glass)); if (!(g >= 60 && g <= 100)) return { ok: false, error: 'invalid', field: k + '.glass' }; p.glass = g; }
        if (typeof x.blur === 'boolean') p.blur = x.blur;
        if (Object.keys(p).length) out[k] = p;
      }
      MS.theme = out;
      const t = themePay(), desc = p => `${p.acc || 'origem'} / ${p.bg || 'origem'} · vidro ${p.glass != null ? p.glass + ' %' : 'origem'} · desfoque ${p.blur ? 'sim' : 'não'}`;
      addLog('theme.save', `Loja: ${desc(t.shop)} · Painel: ${desc(t.admin)}`);
      return { ok: true, theme: t };
    };
    M2['admin.stats'] = () => ({ ok: true, stats: stats() });
    M2['admin.settings.save'] = d => { MS.overrides = clone(obj(d.config)); MS.disabled = arr(d.disabledApps).slice(); addLog('settings.save', `${Object.keys(MS.overrides).length} definições alteradas, ${MS.disabled.length} apps desligadas`); return { ok: true, settings: settingsPayload(), disabledApps: MS.disabled.slice() }; };
    M2['admin.settings.reset'] = () => { MS.overrides = {}; MS.disabled = []; addLog('settings.reset', 'Definições repostas no config.lua'); return { ok: true, settings: settingsPayload(), disabledApps: [] }; };
    M2['admin.shop.save'] = d => { MS.shop = clone(d.shop); addLog('shop.save', `Loja ${MS.shop.enabled ? 'ligada' : 'desligada'} · ${arr(MS.shop.products).length} produtos · ${arr(MS.shop.shops).length} lojas`); return { ok: true, shop: clone(MS.shop) }; };
    M2['admin.shop.reset'] = () => { MS.shop = clone(SHOP); addLog('shop.reset', 'Loja reposta no config.lua'); return { ok: true, shop: clone(MS.shop) }; };
    M2['admin.shop.stats'] = () => Object.assign({ ok: true }, shopStats());
    M2['admin.shop.open'] = () => ({ ok: true });
    M2['admin.shop.recheck'] = () => ({ ok: true, missing: ['slate_buds', 'novaflip_pistachio'] });
    M2['admin.capps.save'] = d => {
      const a = clone(d.app); if (!a || !/^[a-z0-9_]{2,32}$/.test(a.id || '')) return { ok: false, error: 'id' };
      if (!String(a.name || '').trim()) return { ok: false, error: 'name' };
      const i = MS.capps.findIndex(x => x.id === a.id);
      if (d.isNew && i >= 0) return { ok: false, error: 'exists', field: a.id };
      a.updated = Date.now(); a.created = i >= 0 ? MS.capps[i].created : Date.now();
      if (i >= 0) MS.capps[i] = a; else MS.capps.push(a);
      const hl = MS.hist[a.id] = MS.hist[a.id] || [];
      hl.unshift({ at: Math.max(a.updated, hl[0] ? hl[0].at + 1 : 0), by: 'Apex Scripts', def: clone(a) }); hl.length = Math.min(hl.length, 10);
      addLog('capps.save', `${a.name} (${a.id}) · ${arr(a.modules).length} módulos`);
      return { ok: true, app: clone(a) };
    };
    M2['admin.capps.remove'] = d => { MS.capps = MS.capps.filter(x => x.id !== d.id); delete MS.hist[d.id]; addLog('capps.remove', d.id); return { ok: true }; };
    M2['admin.capps.history'] = d => ({ ok: true, items: arr(MS.hist[d.id]).map(x => ({ at: x.at, by: x.by, modules: arr(x.def.modules).length, name: x.def.name })) });
    M2['admin.capps.restore'] = d => { const x = arr(MS.hist[d.id]).find(y => y.at === Number(d.at)); return x ? { ok: true, app: clone(x.def), at: x.at } : { ok: false, error: 'missing' }; };
    /* empregos do framework (o server/capps.lua responde no servidor; aqui, um QBCore típico). Para testar o modo
       sem lista: Overlay.mock['admin.capps.jobs'] = () => ({ ok: false, error: 'unknown' }) antes de abrir o painel. */
    const G = (...l) => l.map((label, level) => ({ level, label }));
    M2['admin.capps.jobs'] = () => ({ ok: true, jobs: [
      { name: 'police', label: 'LSPD', grades: G('Cadete', 'Agente', 'Sargento', 'Tenente', 'Comandante') },
      { name: 'sheriff', label: 'BCSO', grades: G('Recruta', 'Deputy', 'Sargento', 'Xerife') },
      { name: 'ambulance', label: 'EMS', grades: G('Estagiário', 'Paramédico', 'Médico', 'Cirurgião', 'Diretor') },
      { name: 'mechanic', label: 'Mecânico', grades: G('Aprendiz', 'Mecânico', 'Chefe de oficina', 'Dono') },
      { name: 'burgershot', label: 'Burger Shot', grades: G('Empregado', 'Cozinheiro', 'Gerente', 'Dono') },
      { name: 'taxi', label: 'Táxi', grades: G('Motorista', 'Chefe de turno', 'Dono') },
      { name: 'lawyer', label: 'Advogado', grades: G('Estagiário', 'Advogado', 'Sócio') },
      { name: 'reporter', label: 'Weazel News', grades: G('Repórter', 'Editor', 'Diretor') },
      { name: 'realestate', label: 'Imobiliária', grades: G('Agente', 'Gerente') },
      { name: 'unemployed', label: 'Desempregado', grades: G('Sem emprego') },
    ] });
    M2['admin.capps.order'] = d => { const ids = arr(d.ids); MS.capps.sort((a, b) => ids.indexOf(a.id) - ids.indexOf(b.id)); addLog('capps.order', `${ids.length} apps reordenadas`); return { ok: true }; };
    M2['admin.capps.items'] = d => {
      ensureMock();
      let l = MS.items.filter(x => x.app === d.app && (!d.module || x.module === d.module) && (!d.status || x.status === d.status));
      if (d.q) { const q2 = String(d.q).toLowerCase(); l = l.filter(x => JSON.stringify(x).toLowerCase().includes(q2)); }
      const page = Number(d.page) || 0;
      return { ok: true, items: l.slice(page * 12, page * 12 + 12), total: l.length };
    };
    M2['admin.capps.item'] = d => { const it = MS.items.find(x => x.id === d.id); if (!it) return { ok: false, error: 'missing' }; return { ok: true, item: clone(it), notes: [{ author_name: 'Agente Costa', staff: 1, private: 0, text: 'Recebido. Vamos passar pelo local ainda hoje.', created: it.created + 40 * MIN }, { author_name: it.owner_name, staff: 0, text: 'Obrigado. Estou disponível a partir das 18h.', created: it.created + 70 * MIN }, { author_name: 'Sargento Lima', staff: 1, private: 1, text: 'Ligar ao caso 1031: mesmo suspeito.', created: it.created + 2 * H }] }; };
    M2['admin.capps.delete'] = d => { MS.items = MS.items.filter(x => x.id !== d.id); return { ok: true }; };
    M2['admin.capps.purge'] = d => { MS.items = MS.items.filter(x => x.app !== d.app); return { ok: true }; };
    M2['admin.capps.stats'] = () => ({ ok: true, apps: stats().capps });
    M2['admin.capps.testWebhook'] = () => ({ ok: true });
    M2['admin.webhooks.save'] = d => { MS.hooks = { admin: d.admin || '', shop: d.shop || '' }; addLog('webhooks.save', `Registo: ${MS.hooks.admin ? 'ligado' : 'desligado'} · Loja: ${MS.hooks.shop ? 'ligado' : 'desligado'}`); return { ok: true, webhooks: clone(MS.hooks) }; };
    M2['admin.webhooks.test'] = () => ({ ok: true });
    M2['admin.log'] = d => { let l = MS.log; if (d.q) { const q2 = String(d.q).toLowerCase(); l = l.filter(x => JSON.stringify(x).toLowerCase().includes(q2)); } const p = Number(d.page) || 0; return { ok: true, rows: clone(l.slice(p * 40, p * 40 + 40)), more: l.length > (p + 1) * 40, page: p }; };
    M2['admin.here'] = () => ({ ok: true, x: 215.76, y: -810.12, z: 30.73, w: 157.3 });
    M2['admin.tp'] = () => ({ ok: true });
    M2['admin.close'] = () => ({ ok: true });
  }

  return { open, close: () => hide(true), isOpen, go: id => go(id), _test: { SEC, docs, get boot() { return boot; } } };
})();
