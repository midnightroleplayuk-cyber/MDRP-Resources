/* ============================================================
   WIDGETS - registo + render (home 2×2 / 4×2 / 4×4), API para externos
   · cada registo declara `sizes` (o `size` antigo continua a valer como tamanho único)
   · render(size) recebe o tamanho; hydrate(el) pinta pelo CSSOM o que não pode ir numa string de HTML (capas, fotos)
   · widgets EXTERNOS (iframes de apps de terceiros, resources): NUNCA HTML cru no documento do telemóvel -
     template (stat/list/progress/text) + data escritos com textContent, ou HTML passado por um sanitizador
   ============================================================ */
window.Widgets = (() => {
  const g = UI.g; const reg = {};
  const SIZES = ['2x2', '4x2', '4x4'];
  const SIZE_LABEL = { '2x2': 'Pequeno · 2×2', '4x2': 'Médio · 4×2', '4x4': 'Grande · 4×4' };
  const sizesOf = d => { const l = (Array.isArray(d && d.sizes) ? d.sizes : [d && d.size]).filter(s => SIZES.includes(s)); return l.length ? l : ['2x2']; };
  /* "hoje" na data LOCAL (o toISOString é UTC: perto da meia-noite o widget mostrava o dia errado; a app Calendário usa a local) */
  const localDay = (d = new Date()) => `${d.getFullYear()}-${UI.pad(d.getMonth() + 1)}-${UI.pad(d.getDate())}`;
  const safeColor = c => /^#[0-9a-f]{3,8}$/i.test(String(c || '').trim()) ? String(c).trim() : null;

  /* ---------- widgets externos ---------- */
  const TEMPLATES = ['stat', 'list', 'progress', 'text'];
  const isExternal = def => !!def && (def.external === true || /^ext_/.test(String(def.id || '')) || def.template != null || def.html != null);
  /* dados: só JSON simples e pequeno (sem funções nem nós do DOM a viajar para o render) */
  const cleanData = d => { try { const s = JSON.stringify(d == null ? {} : d); return s && s.length <= 8000 ? JSON.parse(s) : {}; } catch (e) { return {}; } };
  const mk = (tag, cls, text, max = 200) => { const n = document.createElement(tag); if (cls) n.className = cls; if (text != null) n.textContent = String(text).slice(0, max); return n; };
  /* templates: tudo por textContent; cores só em #hex; ícones só por nome (o SVG vem do Icons, não de fora) */
  function tplNode(t, d, size) {
    d = d && typeof d === 'object' ? d : {}; const box = mk('div', 'wx-tpl t-' + t); const col = safeColor(d.color);
    if (d.title != null) box.appendChild(mk('div', 'wt', d.title, 60));
    if (t === 'stat') {
      const v = mk('div', 'wb', (d.value != null ? d.value : '--') + (d.unit != null ? ' ' + d.unit : ''), 40); if (col) v.style.color = col; box.appendChild(v);
      if (d.sub != null) box.appendChild(mk('div', 'ws', d.sub, 120));
      if (/^[a-zA-Z0-9]{1,24}$/.test(String(d.icon || ''))) { const i = mk('div', 'wx-ic'); i.innerHTML = g(d.icon); box.appendChild(i); }
    } else if (t === 'list') {
      const max = size === '4x4' ? 8 : size === '4x2' ? 3 : 4; const ul = mk('div', 'wx-list');
      (Array.isArray(d.items) ? d.items : []).slice(0, max).forEach(it => { const o = it && typeof it === 'object' ? it : { text: it }; const row = mk('div', 'wx-row'); row.appendChild(mk('span', 'wx-tx', o.text != null ? o.text : '', 80)); if (o.right != null) row.appendChild(mk('span', 'wx-rt', o.right, 20)); ul.appendChild(row); });
      box.appendChild(ul);
    } else if (t === 'progress') {
      let v = +d.value || 0; if (v > 1) v /= 100; v = Math.max(0, Math.min(1, v));
      box.appendChild(mk('div', 'wb', d.label != null ? d.label : Math.round(v * 100) + '%', 40));
      const bar = mk('div', 'wx-bar'), fill = mk('i'); fill.style.transform = `scaleX(${v.toFixed(3)})`; if (col) fill.style.background = col; bar.appendChild(fill); box.appendChild(bar);
      if (d.sub != null) box.appendChild(mk('div', 'ws', d.sub, 120));
    } else box.appendChild(mk('div', 'wx-text', d.text != null ? d.text : '', 600));
    return box;
  }
  /* HTML de fora (o antigo m.html dos iframes): lista branca de etiquetas e atributos, sem on*, sem javascript:, sem url() no style,
     src só http(s)/nui/imagens data:. O <template> é inerte - nada corre nem carrega enquanto se limpa. */
  const OK_TAGS = new Set(['DIV', 'SPAN', 'P', 'B', 'STRONG', 'I', 'EM', 'SMALL', 'BR', 'UL', 'OL', 'LI', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'IMG', 'SVG', 'PATH', 'CIRCLE', 'RECT', 'LINE', 'POLYLINE', 'POLYGON', 'G', 'ELLIPSE']);
  const OK_ATTR = new Set(['class', 'style', 'src', 'alt', 'title', 'width', 'height', 'viewbox', 'd', 'fill', 'stroke', 'stroke-width', 'stroke-linecap', 'stroke-linejoin', 'stroke-opacity', 'fill-opacity', 'opacity', 'cx', 'cy', 'r', 'rx', 'ry', 'x', 'y', 'x1', 'y1', 'x2', 'y2', 'points', 'transform']);
  /* style: o CSS aceita escapes (`\75rl(`, `fi\78ed`), comentários a meio de uma propriedade e var() - um filtro por palavras fugia com eles.
     Qualquer um destes deita fora o atributo inteiro. Sem `fixed`/`sticky` o conteúdo fica preso ao .wg (overflow:hidden). */
  const BAD_STYLE = /[\\<>]|\/\*|url\s*\(|image-set|expression|@import|binding|behavior|fixed|sticky|var\s*\(/i;
  /* class: só as classes dos widgets (wt/wb/ws/wm/wrow/grow/art e wx-*) - uma classe do sistema (sheet-wrap, lock-clockwrap…) enganava os
     querySelector do telemóvel e herdava estilos de ecrã inteiro */
  const OK_CLASS = /^(wt|wb|ws|wm|wrow|grow|art|wx-[a-z0-9-]{1,30})$/;
  function sanitize(html) {
    const t = document.createElement('template'); t.innerHTML = String(html || '').slice(0, 20000);
    const walk = root => [...root.childNodes].forEach(n => {
      if (n.nodeType === 8) { n.remove(); return; }   /* comentários fora: nada que o serializador possa reabrir */
      if (n.nodeType !== 1) return;
      if (!OK_TAGS.has(n.tagName.toUpperCase())) { n.remove(); return; }
      [...n.attributes].forEach(a => { const k = a.name.toLowerCase(), v = String(a.value || '');
        const bad = !OK_ATTR.has(k) || /^on/.test(k) || /(java|vb)script\s*:/i.test(v) || (k === 'style' && BAD_STYLE.test(v)) || (k === 'src' && !/^(https?:|nui:|data:image\/(png|jpe?g|gif|webp);)/i.test(v.trim()));
        if (bad) { n.removeAttribute(a.name); return; }
        if (k === 'class') { const keep = v.split(/\s+/).filter(c => OK_CLASS.test(c)); if (keep.length) n.setAttribute('class', keep.join(' ')); else n.removeAttribute('class'); } });
      walk(n); });
    walk(t.content); return t.innerHTML;
  }
  function externalDef(def) {
    const out = { id: def.id, name: String(def.name || 'Widget').slice(0, 40), app: typeof def.app === 'string' ? def.app : null, external: true, sizes: sizesOf(def), template: TEMPLATES.includes(def.template) ? def.template : null, data: cleanData(def.data) };
    const raw = typeof def.render === 'function' ? def.render : (typeof def.html === 'string' ? () => def.html : null);
    /* outerHTML de um nó construído com textContent: o serializador escapa o texto, por isso a string é segura */
    out.render = size => { if (out.template) return tplNode(out.template, out.data, size).outerHTML; let h = ''; try { h = raw ? raw(size) : ''; } catch (e) { h = ''; } return sanitize(typeof h === 'string' ? h : ''); };
    return out;
  }
  const register = def => { if (!def || !def.id) return; const id = String(def.id).slice(0, 64);
    /* um widget externo nunca substitui um do sistema (um iframe a registar id 'bank' mostrava um saldo falso no widget do Banco) */
    if (isExternal(def) && reg[id] && !reg[id].external) return;
    if (isExternal(def)) reg[id] = externalDef(Object.assign({}, def, { id })); else { def.sizes = sizesOf(def); reg[id] = def; }
    refreshType(id); };
  /* dados novos de um widget externo (sem voltar a registar); devolve false se não existir */
  function update(id, data) { const d = reg[id]; if (!d || !d.external) return false; d.data = cleanData(data); refreshType(id); return true; }
  function unregister(id) { if (!reg[id]) return; delete reg[id]; refreshType(id); }
  const list = () => Object.values(reg);
  const analog = () => { let t = ''; for (let i = 0; i < 12; i++) t += `<line x1="50" y1="8" x2="50" y2="${i % 3 === 0 ? 16 : 12}" stroke="currentColor" stroke-width="${i % 3 === 0 ? 4 : 2}" stroke-linecap="round" transform="rotate(${i * 30} 50 50)"/>`;
    return `<svg viewBox="0 0 100 100" class="analog"><circle cx="50" cy="50" r="46" fill="none" stroke="currentColor" stroke-opacity=".15" stroke-width="3"/>${t}<line class="hh" x1="50" y1="50" x2="50" y2="26" stroke="currentColor" stroke-width="5" stroke-linecap="round"/><line class="mh" x1="50" y1="50" x2="50" y2="14" stroke="currentColor" stroke-width="4" stroke-linecap="round"/><line class="sh" x1="50" y1="58" x2="50" y2="12" stroke="#FF9F0A" stroke-width="1.8" stroke-linecap="round"/><circle cx="50" cy="50" r="3" fill="currentColor"/></svg>`; };

  /* Relógio Nova UI: mostrador redondo (marcas, ponteiros arredondados, segundos a laranja) sobre o cartão; os ponteiros já
     nascem na hora certa (o refresh do minuto redesenhava-os ao meio-dia até ao tick seguinte) e o Icons.tickClocks move-os.
     O 4×2 junta a hora digital, a data e a cidade. */
  function clockA(size) { const d = new Date(); const h = (d.getHours() % 12) * 30 + d.getMinutes() * .5, m = d.getMinutes() * 6 + d.getSeconds() * .1, s = d.getSeconds() * 6; let t = '';
    for (let i = 0; i < 12; i++) t += i % 3 === 0 ? `<line x1="50" y1="7" x2="50" y2="14" stroke-width="3.2" transform="rotate(${i * 30} 50 50)"/>` : `<circle cx="50" cy="10" r="1.7" class="aw-dial-m" transform="rotate(${i * 30} 50 50)"/>`;
    const dial = `<svg class="aw-dial" viewBox="0 0 100 100" aria-hidden="true"><circle cx="50" cy="50" r="49" class="aw-dial-f"/><g stroke="currentColor" stroke-linecap="round" fill="currentColor">${t}</g><line class="hh" x1="50" y1="50" x2="50" y2="28" stroke="currentColor" stroke-width="6" stroke-linecap="round" transform="rotate(${h} 50 50)"/><line class="mh" x1="50" y1="50" x2="50" y2="15" stroke="currentColor" stroke-width="4" stroke-linecap="round" transform="rotate(${m} 50 50)"/><line class="sh" x1="50" y1="60" x2="50" y2="11" stroke="#FF7A1A" stroke-width="1.7" stroke-linecap="round" transform="rotate(${s} 50 50)"/><circle cx="50" cy="50" r="4.4" fill="currentColor"/><circle cx="50" cy="50" r="2" fill="#FF7A1A"/></svg>`;
    if (size !== '4x2') return `<div class="aw-clk s2">${dial}<div class="aw-clk-c">Los Santos</div></div>`;
    return `<div class="aw-clk s42">${dial}<div class="aw-clk-r"><div class="aw-clk-t tm">${UI.fmtTime(d)}</div><div class="aw-clk-d">${UI.esc(dayLong(d))}<span>${UI.esc(notPt() ? intlD(d, { day: 'numeric', month: 'long' }) : d.getDate() + ' de ' + UI.MESES[d.getMonth()])}</span></div><div class="aw-clk-c">${PIN}<span>Los Santos</span></div></div></div>`; }
  register({ id: 'clock', name: 'Relógio', sizes: ['2x2', '4x2'], app: 'clock', render: size => isA() ? clockA(size) : `<div class="wt">Los Santos</div><div class="wb tm">${UI.fmtTime(new Date())}</div><div class="ws">${UI.fmtDate(new Date(), true)}</div>${analog()}`, tick: (el, d) => { const t = el.querySelector('.tm'); if (t) { const v = UI.fmtTime(d); if (t.textContent !== v) t.textContent = v; } } });   /* PERFUI: só escreve quando muda (o mesmo texto 1x/s sujava o layout e acordava o i18n) */
  /* NOVA UI: o sistema do aparelho (para os widgets que diferem entre o PearOS e a Nova UI; o PearOS fica exatamente como era) */
  const isA = () => !!(window.System && System.os === 'android');
  /* UMA fonte para a meteorologia: `WX.now()` (shell/lock.js), o tempo REAL do jogo que o client/main.lua manda. A fila de
     horas do widget largo era inventada (Math.sin): agora mostra o que JÁ esteve hoje (WX.hist, as últimas mudanças de tempo). */
  const wxNow = () => (window.WX ? WX.now() : Object.assign({ t: 26, c: 'sunny', icon: 'sun', label: 'Céu limpo', city: 'Los Santos', hi: 26, lo: 21 }, window.WX_FALLBACK || {}));
  /* ---------- NOVA UI: meteorologia ----------
     Glifos a cores em SVG (viewBox 64) com volume por gradientes: sol amarelo-laranja com halo, nuvem branca com sombra
     suave por baixo, lua, chuva, trovoada, neve e nevoeiro. Ids dos gradientes únicos por desenho (dois widgets na mesma
     página iam buscar os gradientes um do outro). Sem `filter` (no CEF pinta preto). */
  let gseq = 0;
  const CLOUD = '<circle cx="20" cy="40" r="10"/><circle cx="32" cy="30" r="14"/><circle cx="45" cy="39" r="11"/><rect x="20" y="37" width="25" height="13"/>';
  const MOON = 'M52 33.8A20 20 0 1 1 30.2 12 15.6 15.6 0 0 0 52 33.8z';
  function wxGlyph(k, px) {
    const id = 'awg' + (++gseq).toString(36), u = s => `url(#${id}${s})`; let defs = '', body = '';
    const sun = (cx, cy, r) => { defs += `<radialGradient id="${id}s" cx=".36" cy=".32" r=".75"><stop offset="0" stop-color="#FFF4B0"/><stop offset=".42" stop-color="#FFCD38"/><stop offset="1" stop-color="#FF961A"/></radialGradient><radialGradient id="${id}h"><stop offset=".5" stop-color="#FFD54F" stop-opacity=".5"/><stop offset="1" stop-color="#FFD54F" stop-opacity="0"/></radialGradient>`;
      return `<circle cx="${cx}" cy="${cy}" r="${r * 1.55}" fill="${u('h')}"/><circle cx="${cx}" cy="${cy}" r="${r}" fill="${u('s')}"/>`; };
    const moon = tf => { defs += `<linearGradient id="${id}m" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FFF8DC"/><stop offset="1" stop-color="#F2C94C"/></linearGradient>`;
      return `<path d="${MOON}" fill="${u('m')}"${tf ? ` transform="${tf}"` : ''}/>`; };
    const cloud = (tf, a, b, key = 'c') => { if (defs.indexOf(`${id}d"`) < 0) defs += `<radialGradient id="${id}d"><stop offset="0" stop-color="#0A2864" stop-opacity=".3"/><stop offset="1" stop-color="#0A2864" stop-opacity="0"/></radialGradient>`;
      defs += `<linearGradient id="${id}${key}" x1="0" y1="16" x2="0" y2="50" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${a}"/><stop offset="1" stop-color="${b}"/></linearGradient>`;
      return `<g${tf ? ` transform="${tf}"` : ''}><ellipse cx="33" cy="51" rx="23" ry="4.5" fill="${u('d')}"/><g fill="${u(key)}">${CLOUD}</g></g>`; };
    const W = ['#FFFFFF', '#D2DEEE'], G = ['#F4F7FB', '#AEBCD0'], D = ['#E2E7EF', '#7F8CA2'];
    if (k === 'moon') body = moon();
    else if (k === 'psun') body = sun(22, 21, 11.5) + cloud('translate(5 6) scale(.92)', ...W);
    else if (k === 'pmoon') body = moon('translate(0 -2) scale(.6)') + cloud('translate(5 6) scale(.92)', ...W);
    else if (k === 'cloud') body = cloud('translate(22 -3) scale(.68)', ...G, 'b') + cloud('translate(-3 6) scale(.94)', ...W);
    else if (k === 'rain') body = cloud('translate(0 -6)', ...G) + '<path d="M22 50l-3.5 8M33 50l-3.5 8M44 50l-3.5 8" stroke="#7FD3FF" stroke-width="3.6" stroke-linecap="round"/>';
    else if (k === 'storm') body = cloud('translate(0 -7)', ...D) + '<path d="M35 40l-9 12h7l-4 10 12-14h-7l4-8z" fill="#FFD43B"/>';
    else if (k === 'snow') body = cloud('translate(0 -7)', ...G) + '<g fill="#fff"><circle cx="22" cy="52" r="3"/><circle cx="33" cy="57" r="3"/><circle cx="44" cy="52" r="3"/></g>';
    else if (k === 'fog') body = cloud('translate(0 -9)', ...G) + '<path d="M14 48h34M20 56h32" stroke="#fff" stroke-opacity=".92" stroke-width="3.6" stroke-linecap="round"/>';
    else body = sun(32, 32, 17);
    return `<svg class="aw-g" viewBox="0 0 64 64" width="${px}" height="${px}" aria-hidden="true"><defs>${defs}</defs>${body}</svg>`; }
  /* tipo de tempo do jogo → glifo; de noite o sol passa a lua */
  const WXK = { EXTRASUNNY: 'sun', CLEAR: 'sun', NEUTRAL: 'psun', CLEARING: 'psun', CLOUDS: 'cloud', OVERCAST: 'cloud', SMOG: 'fog', FOGGY: 'fog', HALLOWEEN: 'fog', RAIN: 'rain', THUNDER: 'storm', SNOW: 'snow', BLIZZARD: 'snow', SNOWLIGHT: 'snow', XMAS: 'snow' };
  const WXC = { sunny: 'sun', night: 'moon', cloudy: 'psun', rain: 'rain', storm: 'storm', snow: 'snow', fog: 'fog' };
  const wxKind = (w, c) => WXK[w] || WXC[c] || 'sun';
  const wxNightK = k => k === 'sun' ? 'moon' : k === 'psun' ? 'pmoon' : k;
  const wxT = (w, h, wx) => (window.WX && WX.tempFor && WXK[w]) ? WX.tempFor(w, h) : Math.round((+wx.t || 0) + (h < 6 || h >= 20 ? -5 : h >= 13 && h <= 16 ? 2 : 0));
  /* previsão ESTIMADA (o jogo não tem previsão): o tipo de cada dia sai de uma semente da data, com o clima de Los Santos
     (sobretudo sol) e o tempo de agora a pesar no dia seguinte. Estável durante o dia: o refresh do minuto não a baralha. */
  const LS_DAYS = ['CLEAR', 'EXTRASUNNY', 'NEUTRAL', 'CLEAR', 'CLOUDS', 'EXTRASUNNY', 'CLEAR', 'NEUTRAL', 'OVERCAST', 'CLEAR', 'RAIN', 'CLEARING', 'EXTRASUNNY', 'SMOG', 'CLOUDS', 'THUNDER'];
  const SNOW_DAYS = ['SNOW', 'SNOWLIGHT', 'SNOW', 'BLIZZARD', 'SNOWLIGHT', 'XMAS'];
  const seedOf = s => { let h = 2166136261; for (let i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); } return h >>> 0; };
  function wxDays(n, wx) {
    const out = [], list = wx.c === 'snow' ? SNOW_DAYS : LS_DAYS;
    for (let k = 1; k <= n; k++) { const d = new Date(); d.setHours(12, 0, 0, 0); d.setDate(d.getDate() + k); const h = seedOf(localDay(d));
      const w = (k === 1 && WXK[wx.w] && h % 3 === 0) ? wx.w : list[h % list.length];
      const hi = wxT(w, 14, wx) + (h >>> 5) % 3 - 1; const lo = Math.min(hi - 3, wxT(w, 2, wx) + (h >>> 9) % 3 - 1);
      out.push({ d, w, k: WXK[w], hi, lo, label: (window.WX && WX.TYPES && WX.TYPES[w]) ? WX.TYPES[w][1] : '' }); }
    return out; }
  /* máx./mín. de hoje: o que já esteve (WX.hist) alargado à estimativa do dia (início da tarde / madrugada), senão sem
     histórico ficava "26° / 26°" */
  const wxHiLo = wx => [Math.max(+wx.hi || 0, +wx.t || 0, wxT(wx.w, 14, wx)), Math.min(wx.lo != null ? +wx.lo : 99, +wx.t || 0, wxT(wx.w, 2, wx))];
  const wxIcoK = wx => { const k = wxKind(wx.w, wx.c); return wx.night ? wxNightK(k) : k; };
  /* dia da semana curto (Dom Seg Ter Qua Qui Sex Sáb; noutra língua o do Intl) */
  const dayC = d => { if (window.L && L.code !== 'pt') { try { const s = new Intl.DateTimeFormat(L.intl(), { weekday: 'short' }).format(d).replace('.', ''); return s.charAt(0).toUpperCase() + s.slice(1); } catch (e) {} } return UI.DIAS_C[d.getDay()]; };
  const PIN = '<svg viewBox="0 0 24 24" width="12" height="12" aria-hidden="true"><path fill="currentColor" fill-rule="evenodd" d="M12 2a7 7 0 0 0-7 7c0 5.2 7 13 7 13s7-7.8 7-13a7 7 0 0 0-7-7zm0 9.6a2.6 2.6 0 1 1 0-5.2 2.6 2.6 0 0 1 0 5.2z"/></svg>';
  /* Meteorologia Nova UI: cartão opaco azul-céu (cinzento-azulado com chuva, azul-noite de noite). À esquerda o glifo grande,
     a temperatura, o estado, máx./mín. e o sítio; no 4×2 um painel claro com os próximos 4 dias; no 4×4 também sensação,
     humidade e vento, e 5 dias com o estado por extenso */
  function wxA(size) {
    const wx = wxNow(), k0 = wxKind(wx.w, wx.c), k = wx.night ? wxNightK(k0) : k0; const [hi, lo] = wxHiLo(wx);
    const tone = wx.night ? 'n' : /rain|storm|fog|snow/.test(k0) ? 'g' : 'd', big = size === '4x4';
    const left = `<div class="aw-wx-l">${wxGlyph(k, big ? 62 : 58)}<div class="aw-wx-tx"><div class="aw-wx-t">${UI.esc(wx.t)}°</div><div class="aw-wx-c">${UI.esc(T(wx.label || ''))}</div><div class="aw-wx-hl">↑${hi}° / ↓${lo}°</div><div class="aw-wx-loc">${PIN}<span>${UI.esc(wx.city || 'Los Santos')}</span></div></div></div>`;
    if (size !== '4x2' && !big) return `<div class="aw-wx s2 t-${tone}">${left}</div>`;
    const rows = wxDays(big ? 5 : 4, wx).map(x => `<div class="aw-wx-r"><b>${UI.esc(dayC(x.d))}</b>${big ? `<span class="aw-wx-lb">${UI.esc(T(x.label))}</span>` : ''}<i>${wxGlyph(x.k, 22)}${wxGlyph(wxNightK(x.k), 22)}</i><span>${x.hi}°</span><em>${x.lo}°</em></div>`).join('');
    if (!big) return `<div class="aw-wx s42 t-${tone}">${left}<div class="aw-wx-f">${rows}</div></div>`;
    const feel = (+wx.t || 0) + (wx.wind >= 35 ? -3 : wx.c === 'sunny' && !wx.night ? 2 : -1);
    const st = [[T('Sensação'), feel + '°'], [T('Humidade'), wx.hum != null ? wx.hum + '%' : '--'], [T('Vento'), wx.wind != null ? wx.wind + ' km/h' : '--']].map(([a, b]) => `<div><span>${UI.esc(a)}</span><b>${UI.esc(b)}</b></div>`).join('');
    return `<div class="aw-wx s44 t-${tone}"><div class="aw-wx-top">${left}<div class="aw-wx-st">${st}</div></div><div class="aw-wx-f">${rows}</div></div>`; }
  /* "Máx. 26° Mín. 18°": em português com espaços que não partem; nos outros idiomas pelo L.tf (o tradutor do DOM não casava a
     frase com os espaços que não partem e ficava em português) */
  const hiLo = wx => (window.L && L.code && L.code !== 'pt' && L.tf) ? UI.esc(L.tf('Máx. %s° Mín. %s°', wx.hi, wx.lo)) : `Máx.&nbsp;${UI.esc(wx.hi)}° Mín.&nbsp;${UI.esc(wx.lo)}°`;
  const wxWide = size => { if (isA()) return wxA(size); const wx = wxNow(); const big = size === '4x4'; const hist = (window.WX ? WX.hist() : []).slice(-6); let hr = '';
    if (hist.length > 1) hist.forEach(x => { hr += `<div style="text-align:center;font-size:${big ? 13 : 11}px"><div style="opacity:.8">${UI.pad(x.hour)}h</div>${g(WX.icon(x.c), big ? 26 : 21)}<div>${x.t}°</div></div>`; });
    else hr = `<div style="font-size:${big ? 13 : 11}px;opacity:.85">${wx.measured ? 'Vento ' + wx.wind + ' km/h · Humidade ' + wx.hum + '%' : 'À espera do tempo do jogo'}</div>`;
    return `<div class="wrow"><div class="grow"><div class="wt" style="opacity:.9">${UI.esc(wx.city)}</div><div class="wb"${big ? ' style="font-size:64px;font-weight:300"' : ''}>${UI.esc(wx.t)}°</div></div><div style="text-align:right">${big ? g(wx.icon, 40) : ''}<div class="wm">${UI.esc(wx.label)}</div><div class="ws">${hiLo(wx)}</div></div></div><div class="wrow" style="justify-content:space-between;margin-top:auto">${hr}</div>`; };
  register({ id: 'weather', name: 'Meteorologia', sizes: ['2x2', '4x2', '4x4'], app: 'weather', glass: true, render: size => { if (isA()) return wxA(size || '2x2'); if (size && size !== '2x2') return wxWide(size); const wx = wxNow(); return `<div class="wt" style="opacity:.9">${UI.esc(wx.city)}</div><div class="wb">${UI.esc(wx.t)}°</div><div class="wrow" style="margin-top:auto">${g(wx.icon, 26)}<div><div class="wm">${UI.esc(wx.label)}</div><div class="ws">${hiLo(wx)}</div></div></div>`; }, style: 'background:linear-gradient(180deg,#3F8FE8,#7DBBF5);color:#fff' });
  /* "Tempo e relógio" (Nova UI): a hora grande e a data à esquerda, o tempo do jogo à direita, sem cartão (texto sobre o fundo,
     com sombra suave), como o widget de origem do ecrã principal da Nova UI. `os: 'android'`: só aparece no seletor do NOVA, mas
     desenha-se nos dois sistemas (a disposição é da conta e pode ser aberta num PearPhone). O tick só troca a hora. */
  const dShort = d => (window.L && L.code !== 'pt') ? UI.fmtDate(d, true) : `${UI.DIAS_C[d.getDay()]}., ${d.getDate()} ${UI.MESES[d.getMonth()].slice(0, 3)}.`;
  /* Nova UI 4×2: "Qui., 1 de outubro" (a data longa não cabia ao lado do tempo e ficava cortada) */
  const dMid = d => (notPt() && cap1(intlD(d, { weekday: 'short', day: 'numeric', month: 'long' }))) || `${UI.DIAS_C[d.getDay()]}., ${d.getDate()} de ${UI.MESES[d.getMonth()]}`;
  register({ id: 'clockwx', name: 'Tempo e relógio', sizes: ['4x2', '2x2'], app: 'clock', os: 'android', clear: true,
    render: size => { const d = new Date(); const wx = wxNow(); const ic = isA() ? wxGlyph(wxIcoK(wx), size === '2x2' ? 26 : 34) : g(wx.icon || 'sun', size === '2x2' ? 26 : 34);
      if (isA()) { const hl = wxHiLo(wx); wx.hi = hl[0]; wx.lo = hl[1]; }   /* na Nova UI o mesmo máx./mín. do widget da Meteorologia */
      if (size === '2x2') return `<div class="ah-cw s2"><div class="ah-cw-t tm">${UI.fmtTime(d)}</div><div class="ah-cw-d">${UI.esc(dShort(d))}</div><div class="ah-cw-w">${ic}<b>${UI.esc(wx.t)}°</b><span>${UI.esc(wx.city)}</span></div></div>`;
      return `<div class="ah-cw"><div class="ah-cw-l"><div class="ah-cw-t tm">${UI.fmtTime(d)}</div><div class="ah-cw-d">${UI.esc(isA() ? dMid(d) : UI.fmtDate(d))}</div></div><div class="ah-cw-r"><div class="ah-cw-i">${ic}<b>${UI.esc(wx.t)}°</b></div><div class="ah-cw-c">${UI.esc(wx.city)}</div><div class="ah-cw-hl">${UI.esc(wx.label)} · ${UI.esc(wx.hi)}° / ${UI.esc(wx.lo)}°</div></div></div>`; },
    tick: (el, d) => { const t = el.querySelector('.tm'); if (t) { const v = UI.fmtTime(d); if (t.textContent !== v) t.textContent = v; } } });
  /* o antigo "Meteorologia (largo)" continua a desenhar-se nas disposições gravadas; no seletor passou a ser Meteorologia › Médio */
  register({ id: 'weather4', name: 'Meteorologia (largo)', sizes: ['4x2'], hidden: true, app: 'weather', render: () => wxWide('4x2'), style: 'background:linear-gradient(180deg,#3F8FE8,#7DBBF5);color:#fff' });
  /* Calendário (PearOS): dia da semana a vermelho, número grande; sem eventos hoje → o PRÓXIMO com o dia ("Sex 12 · 09:00 …") */
  const evRow = (e, today) => { const nd = new Date(e.date + 'T12:00:00'); const pre = e.date === today ? '' : `${UI.DIAS_C[nd.getDay()]} ${nd.getDate()} · `; return `<div class="wrow" style="gap:6px"><span style="width:4px;height:14px;border-radius:2px;background:${safeColor(e.color) || 'var(--red)'};flex:none"></span><span style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-size:13px">${UI.esc(pre + (e.time || '') + ' ' + (e.title || ''))}</span></div>`; };
  /* Calendário Nova UI: dia da semana pequeno, número grande (tipo de letra de ecrã) e os próximos eventos com a cor de cada um */
  const T = s => (window.L && L.t ? L.t(s) : s);
  /* cartão de superfície (branco / escuro): o dia da semana a azul e o número grande; 4×2 com a semana (segunda primeiro, hoje
     num círculo azul, ponto nos dias com eventos) e os próximos eventos à direita; 4×4 com o mês inteiro e os próximos eventos */
  const intlD = (d, o) => { try { return new Intl.DateTimeFormat(L.intl(), o).format(d); } catch (e) { return ''; } };
  const notPt = () => !!(window.L && L.code !== 'pt' && L.intl);
  const cap1 = s => s ? s.charAt(0).toUpperCase() + s.slice(1) : s;
  const dayLong = d => cap1(notPt() && intlD(d, { weekday: 'long' })) || UI.DIAS[d.getDay()];
  const WKL = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  const dayL = d => (notPt() && intlD(d, { weekday: 'narrow' })) || WKL[d.getDay()];
  const monthL = d => (notPt() && intlD(d, { month: 'long' })) || UI.MESES[d.getMonth()];
  const calA = size => { const d = new Date(); const today = localDay(d); const all = (Store.get('events', []) || []).filter(e => e && typeof e.date === 'string');
    const up = all.filter(e => e.date >= today).sort((a, b) => (a.date + (a.time || '')).localeCompare(b.date + (b.time || ''))); const has = new Set(all.map(e => e.date));
    const row = e => { const nd = new Date(e.date + 'T12:00:00'); const when = e.date === today ? (e.time || T('Todo o dia')) : `${dayC(nd)} ${nd.getDate()}${e.time ? ' · ' + e.time : ''}`;
      return `<div class="aw-cal-ev"><i style="background:${safeColor(e.color) || '#3E7BFA'}"></i><div><b>${UI.esc(e.title || '')}</b><span>${UI.esc(when)}</span></div></div>`; };
    const list = n => up.length ? up.slice(0, n).map(row).join('') : `<div class="aw-cal-none"><b>${UI.esc(T('Sem eventos'))}</b><span>${UI.esc(T('Toca para abrir o Calendário'))}</span></div>`;
    const cell = (x, extra = '') => { const k = localDay(x); return `<div class="${k === today ? 'on' : ''}${x.getDay() === 0 ? ' su' : ''}${extra}"><b>${x.getDate()}</b>${has.has(k) ? '<u></u>' : ''}</div>`; };
    if (size === '4x4') { const y = d.getFullYear(), m = d.getMonth(), off = (new Date(y, m, 1).getDay() + 6) % 7, weeks = Math.ceil((off + new Date(y, m + 1, 0).getDate()) / 7);
      let grid = ''; for (let i = 0; i < 7; i++) { const x = new Date(y, m, 1 - off + i); grid += `<i${x.getDay() === 0 ? ' class="su"' : ''}>${UI.esc(dayL(x))}</i>`; }
      for (let c = 0; c < weeks * 7; c++) { const x = new Date(y, m, 1 - off + c); grid += cell(x, x.getMonth() !== m ? ' out' : ''); }
      const mn = monthL(d);
      return `<div class="aw-cal s44"><div class="aw-cal-mh"><b>${UI.esc(mn.charAt(0).toUpperCase() + mn.slice(1))}</b><span>${y}</span></div><div class="aw-cal-mo">${grid}</div><div class="aw-cal-l">${list(weeks > 5 ? 2 : 3)}</div></div>`; }
    const nToday = all.filter(e => e.date === today).length;
    /* sem nada marcado, à direita já diz "Sem eventos": aqui só se conta quando há eventos a vir */
    const cnt = !up.length ? '' : nToday ? (nToday === 1 ? T('1 evento hoje') : nToday + ' ' + T('eventos hoje')) : T('Sem eventos hoje');
    const head = `<div class="aw-cal-d"><span>${UI.esc(dayLong(d))}</span><b>${d.getDate()}</b>${size === '4x2' ? `<em>${UI.esc(monthL(d))}</em>${cnt ? `<small>${UI.esc(cnt)}</small>` : ''}` : ''}</div>`;
    if (size !== '4x2') return `<div class="aw-cal s2">${head}<div class="aw-cal-l">${list(2)}</div></div>`;
    const mon = new Date(d.getFullYear(), d.getMonth(), d.getDate() - (d.getDay() + 6) % 7); let wk = '';
    for (let i = 0; i < 7; i++) { const x = new Date(mon.getFullYear(), mon.getMonth(), mon.getDate() + i); wk += cell(x).replace('<b>', `<i>${UI.esc(dayL(x))}</i><b>`); }
    return `<div class="aw-cal s42">${head}<div class="aw-cal-r"><div class="aw-cal-wk">${wk}</div><div class="aw-cal-l">${list(2)}</div></div></div>`; };
  register({ id: 'calendar', name: 'Calendário', sizes: ['2x2', '4x2', '4x4'], app: 'calendar', render: size => { if (isA()) return calA(size); const d = new Date(); const today = localDay(d); const all = (Store.get('events', []) || []).filter(e => e && typeof e.date === 'string');
    const byTime = (a, b) => (a.date + (a.time || '')).localeCompare(b.date + (b.time || ''));
    const head = (n = 42) => `<div class="wt" style="color:var(--red);opacity:1;font-size:13px;letter-spacing:.3px">${UI.DIAS[d.getDay()].toUpperCase()}</div><div class="wb" style="font-size:${n}px;font-weight:500;margin-top:2px">${d.getDate()}</div>`;
    const none = '<span style="color:var(--label2)">Nenhum evento</span>';
    if (size === '4x2' || size === '4x4') { const up = all.filter(e => e.date >= today).sort(byTime).slice(0, size === '4x4' ? 7 : 3); const rows = up.length ? up.map(e => evRow(e, today)).join('') : none;
      if (size === '4x2') return `<div class="wrow" style="align-items:stretch;gap:16px;height:100%"><div style="flex:none;width:86px">${head()}</div><div class="grow" style="display:flex;flex-direction:column;justify-content:center;gap:8px;font-size:15px">${rows}</div></div>`;
      return `${head(48)}<div class="ws" style="margin-top:2px">${UI.esc(UI.monthName ? UI.monthName(d.getMonth()) : UI.MESES[d.getMonth()])}</div><div style="margin-top:auto;display:flex;flex-direction:column;gap:9px;font-size:15px">${rows}</div>`; }
    let ev = all.filter(e => e.date === today).sort(byTime);
    if (!ev.length) { const nx = all.filter(e => e.date > today).sort(byTime)[0]; if (nx) ev = [nx]; }
    return `${head()}<div style="margin-top:auto;font-size:15px;line-height:1.3">${ev.length ? ev.slice(0, 2).map(e => evRow(e, today)).join('') : none}</div>`; } });
  /* Música: a capa é pintada no hydrate (CSSOM); o tick repinta quando a faixa/estado muda */
  const musicSig = () => { const c = window.Player && Player.cur(); return c ? `${c.id}|${c.img || ''}|${Player.playing ? 1 : 0}` : ''; };
  /* Música Nova UI: capa grande com raio, estado a cor, título e artista; sem faixa, um convite para abrir a app */
  const MUSIC_IC = '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M9 17.5V6.8l10-2.3v10.9a3 3 0 1 1-2-2.8V8.1l-6 1.4v8a3 3 0 1 1-2-2.8z"/></svg>';
  function musicA(size) { const c = window.Player && Player.cur();
    if (!c) return `<div class="aw-mu none ${size === '4x2' ? 's42' : 's2'}"><span class="aw-mu-ic">${MUSIC_IC}</span><div class="aw-mu-tx"><b>${UI.esc(T('Nada a tocar'))}</b><span>${UI.esc(T('Toca para abrir a Música'))}</span></div></div>`;
    const st = `<div class="aw-mu-st">${MUSIC_IC}<span>${UI.esc(T(Player.playing ? 'A tocar' : 'Em pausa'))}</span></div>`;
    return `<div class="aw-mu ${size === '4x2' ? 's42' : 's2'}"><div class="art"></div><div class="aw-mu-tx">${st}<b>${UI.esc(c.title || '')}</b><span>${UI.esc(c.artist || '')}</span></div></div>`; }
  register({ id: 'music', name: 'Música', sizes: ['2x2', '4x2'], app: 'music',
    render: size => { if (isA()) return musicA(size); const c = window.Player && Player.cur(); if (!c) return `<div class="wt">Música</div><div class="wrow" style="margin-top:auto">${g('music', 28)}<div class="ws">Nada a tocar</div></div>`;
      if (size === '4x2') return `<div class="wrow" style="gap:14px;height:100%"><div class="art" style="width:120px;height:120px;border-radius:16px;flex:none"></div><div class="grow"><div class="wt">${Player.playing ? 'A tocar' : 'Em pausa'}</div><div class="wm" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-top:6px;font-size:17px">${UI.esc(c.title)}</div><div class="ws">${UI.esc(c.artist)}</div></div></div>`;
      return `<div class="wt">${Player.playing ? 'A tocar' : 'Em pausa'}</div><div class="art" style="width:60px;height:60px;border-radius:12px;margin:6px 0"></div><div class="wm" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${UI.esc(c.title)}</div><div class="ws">${UI.esc(c.artist)}</div>`; },
    hydrate: el => { el.dataset.sig = musicSig(); const a = el.querySelector('.art'); const c = window.Player && Player.cur(); if (!a || !c) return; const cc = Array.isArray(c.c) ? c.c.map(safeColor) : []; const grad = cc[0] ? `linear-gradient(135deg,${cc[0]},${cc[1] || cc[0]})` : '';
      /* uma declaração com UMA camada inválida é rejeitada inteira (ficava sem capa nem gradiente): nesse caso fica só o gradiente */
      a.style.backgroundImage = [typeof c.img === 'string' && c.img ? UI.img(c.img) : '', grad].filter(Boolean).join(','); if (!a.style.backgroundImage && grad) a.style.backgroundImage = grad; a.style.backgroundSize = 'cover'; a.style.backgroundPosition = 'center'; },
    tick: el => { if (el.dataset.sig !== musicSig()) { el.innerHTML = html('music', el.dataset.size); hydrateOne(el); } } });
  /* Fotos Nova UI: a foto a encher o cartão com um véu escuro em baixo para a legenda (sem sombra de texto); sem fotos, um
     cartão de cor com o glifo da Galeria. Mesmo contrato do hydrate (.wph[data-pi]). */
  function photosA(size, ph) { const n = ph.length;
    /* a foto em destaque fica a mesma durante a hora (o refresh do minuto trocava-a de repente); muda à hora seguinte */
    const pick = () => seedOf(localDay() + '|' + new Date().getHours()) % n;
    if (!n) return `<div class="aw-ph none"><span class="aw-ph-ic">${g('image', 26)}</span><b>${UI.esc(T('Sem fotos'))}</b><span>${UI.esc(T('As tuas fotos aparecem aqui'))}</span></div>`;
    if (size === '4x4' && n > 1) { const idx = [], b = pick(); for (let i = 0; i < Math.min(4, n); i++) idx.push((b + i) % n); return `<div class="aw-ph-g n${idx.length}">${idx.map(i => `<div class="wph" data-pi="${i}"></div>`).join('')}</div>`; }
    const i = pick(), p = ph[i];
    return `<div class="aw-ph"><div class="wph" data-pi="${i}"></div><div class="aw-ph-cap"><b>${UI.esc(T('Em destaque'))}</b><span>${UI.esc(UI.fmtDate(new Date((p && p.created) || Date.now()), true))}</span></div></div>`; }
  /* Fotos: a string só leva o lugar (data-pi = índice); a imagem (pode ser um data: URL) entra pelo CSSOM no hydrate */
  register({ id: 'photos', name: 'Fotos', sizes: ['2x2', '4x2', '4x4'], app: 'photos', style: 'padding:0',
    render: size => { const ph = Store.get('photosCache', []) || []; const n = ph.length; const pick = () => Math.floor(Math.random() * n);
      if (isA()) return photosA(size, ph);
      if (size === '4x4' && n > 1) { const idx = [], b = pick(); for (let i = 0; i < Math.min(4, n); i++) idx.push((b + i) % n); return `<div style="position:absolute;inset:0;display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:2px">${idx.map(i => `<div class="wph" data-pi="${i}" style="background-size:cover;background-position:center"></div>`).join('')}</div>`; }
      const i = n ? pick() : -1; const p = ph[i];
      return `<div class="wph" data-pi="${i}" style="position:absolute;inset:0;background:linear-gradient(135deg,#888,#333);background-size:cover;background-position:center"></div><div style="position:absolute;left:14px;bottom:12px;color:#fff;text-shadow:0 1px 4px rgba(0,0,0,.6)"><div class="wt" style="opacity:.9;color:#fff">Em destaque</div><div class="wm">${p ? UI.fmtDate(new Date(p.created || Date.now()), true) : 'Sem fotos'}</div></div>`; },
    hydrate: el => { const ph = Store.get('photosCache', []) || []; el.querySelectorAll('.wph[data-pi]').forEach(x => { const p = ph[+x.dataset.pi]; if (!p) return; x.style.backgroundImage = p.url ? UI.img(p.url) : (window.photoBg ? photoBg(p.seed || 1) : ''); }); } });
  /* Notas (PearOS): faixa amarela com pasta + "Notas", picotado, corpo com a última nota (a grande lista as mais recentes) */
  /* Notas Nova UI: cabeçalho com o ícone laranja, o nome e o total; 2×2 as duas últimas notas em lista, 4×2 duas fichas lado a
     lado e 4×4 quatro fichas (título, início do texto e quando foi mexida), como a grelha das Notas */
  const wHead = (cls, ic, name, n) => `<div class="aw-hd"><span class="aw-hic ${cls}">${g(ic, 15)}</span><b>${UI.esc(T(name))}</b>${n ? `<em>${n}</em>` : ''}</div>`;
  const wNone = (ic, txt) => `<div class="aw-none">${g(ic, 26)}<span>${UI.esc(T(txt))}</span></div>`;
  const notesA = (all, txt, size) => { const first = n => txt(n)[0] || T('Nova nota'), rest = n => txt(n).slice(1).join(' ');
    let body;
    if (!all.length) body = wNone('compose', 'Nenhuma nota');
    else if (size === '2x2') body = `<div class="aw-nt-l">${all.slice(0, 2).map(n => `<div class="aw-nt-r"><b>${UI.esc(first(n))}</b><span>${UI.esc(rest(n) || UI.rel(n.ts || Date.now()))}</span></div>`).join('')}</div>`;
    else body = `<div class="aw-nt-g">${all.slice(0, size === '4x4' ? 4 : 2).map(n => `<div class="aw-nt-c"><b>${UI.esc(first(n))}</b><span>${UI.esc(rest(n))}</span><em>${UI.esc(UI.rel(n.ts || Date.now()))}</em></div>`).join('')}</div>`;
    return `<div class="aw-nt ${size === '4x4' ? 's44' : size === '4x2' ? 's42' : 's2'}">${wHead('o', 'pen', 'Notas', all.length)}${body}</div>`; };
  register({ id: 'notes', name: 'Notas', sizes: ['2x2', '4x2', '4x4'], app: 'notes', style: 'padding:0', render: size => { const all = (Store.get('notes', []) || []).filter(n => n && typeof n === 'object').sort((a, b) => (b.ts || 0) - (a.ts || 0)); const txt = n => String(n.text || '').split('\n');
    if (isA()) return notesA(all, txt, size);
    const body = size === '4x4' && all.length ? all.slice(0, 5).map(n => `<div style="padding:6px 0;border-bottom:.5px solid var(--sep)"><div class="t">${UI.esc(txt(n)[0] || 'Nova nota')}</div><div class="s" style="-webkit-line-clamp:1">${UI.esc(txt(n).slice(1).join(' '))}</div></div>`).join('')
      : all[0] ? `<div class="t">${UI.esc(txt(all[0])[0])}</div><div class="s">${UI.esc(txt(all[0]).slice(1).join(' '))}</div>` : '<div class="s">Nenhuma nota</div>';
    return `<div class="wg-notes"><div class="hd">${g('folder', 23)}<span>Notas</span>${size === '4x4' ? `<span style="margin-left:auto;font-size:15px;opacity:.9">${all.length}</span>` : ''}</div><div class="bd">${body}</div></div>`; } });
  /* Bateria Nova UI: anel grande com o telemóvel ao centro, a percentagem e o modelo; verde, amarelo em poupança, vermelho abaixo de 20 % */
  function batteryA() { const b = Math.max(0, Math.min(100, +System.state.battery || 0)); const r = 42, L2 = 2 * Math.PI * r;
    const col = b <= 20 ? '#F2453D' : System.state.lowPower ? '#F5B400' : '#2DBE60';
    return `<div class="aw-bt"><div class="aw-bt-ring"><svg viewBox="0 0 100 100" aria-hidden="true"><circle cx="50" cy="50" r="${r}" class="aw-bt-tr" fill="none" stroke-width="9"/><circle cx="50" cy="50" r="${r}" fill="none" stroke="${col}" stroke-width="9" stroke-linecap="round" stroke-dasharray="${L2.toFixed(2)}" stroke-dashoffset="${(L2 * (1 - b / 100)).toFixed(2)}" transform="rotate(-90 50 50)"/><rect x="40" y="31" width="20" height="38" rx="5" fill="none" stroke="currentColor" stroke-width="3.4"/><path d="M46.5 36h7" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"/></svg></div><b>${b}%</b><span>${UI.esc(System.osInfo().model)}</span></div>`; }
  register({ id: 'battery', name: 'Bateria', sizes: ['2x2'], app: 'settings', render: () => { if (isA()) return batteryA(); const b =Math.max(0, Math.min(100, +System.state.battery || 0)); return `<div class="wt">Bateria</div><div class="wrow" style="margin-top:8px"><svg viewBox="0 0 100 100" style="width:70px;height:70px"><circle cx="50" cy="50" r="40" fill="none" stroke="currentColor" stroke-opacity=".12" stroke-width="10"/><circle cx="50" cy="50" r="40" fill="none" stroke="${b < 20 ? '#FF453A' : '#30D158'}" stroke-width="10" stroke-linecap="round" stroke-dasharray="${2 * Math.PI * 40}" stroke-dashoffset="${2 * Math.PI * 40 * (1 - b / 100)}" transform="rotate(-90 50 50)"/></svg><div><div class="wb" style="font-size:26px">${b}%</div><div class="ws">${isA() ? UI.esc(System.osInfo().model) : 'PearPhone'}</div></div></div>`; } });
  /* Lembretes Nova UI: cabeçalho com o ícone azul e o total, e a lista com o círculo por marcar à esquerda, separada por linhas finas */
  function remindersA(size, open) { const l = open.slice(0, size === '4x4' ? 8 : 3);
    const body = l.length ? `<div class="aw-rm-l">${l.map(x => `<div class="aw-rm-r"><i></i><span>${UI.esc(x.text || '')}</span></div>`).join('')}</div>` : wNone('checkCircle', 'Tudo feito');
    return `<div class="aw-rm ${size === '4x4' ? 's44' : size === '4x2' ? 's42' : 's2'}">${wHead('b', 'list', 'Lembretes', open.length)}${body}</div>`; }
  register({ id: 'reminders', name: 'Lembretes', sizes: ['2x2', '4x2', '4x4'], app: 'reminders', render: size => { const open = (Store.get('reminders', []) || []).filter(x => x && !x.done); if (isA()) return remindersA(size, open); const l =open.slice(0, size === '4x4' ? 10 : 4); return `<div class="wrow"><div class="wt grow" style="color:var(--blue)">Lembretes</div>${size !== '2x2' ? `<div class="wb" style="font-size:22px;color:var(--blue)">${open.length}</div>` : ''}</div><div style="margin-top:6px;font-size:${size === '2x2' ? 12 : 14}px;line-height:1.6">${l.length ? l.map(x => `<div class="wrow" style="gap:6px"><span style="width:12px;height:12px;border-radius:50%;border:1.5px solid var(--blue);flex:none"></span><span style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${UI.esc(x.text)}</span></div>`).join('') : '<span class="ws">Tudo feito 🎉</span>'}</div>`; } });
  /* Banco Nova UI: cabeçalho verde com o banco, o saldo grande em tipo de letra de ecrã e o dinheiro vivo numa ficha à parte */
  function bankA(size, m) { const bal = UI.money(m.bank || 0), cash = UI.money(m.cash || 0);
    const cashCard = `<div class="aw-bk-c">${g('card', 18)}<div><span>${UI.esc(T('Dinheiro'))}</span><b>${UI.esc(cash)}</b></div></div>`;
    return `<div class="aw-bk ${size === '4x2' ? 's42' : 's2'}">${wHead('g', 'bank', 'Fleeca', 0)}<div class="aw-bk-m"><div class="aw-bk-v"><span>${UI.esc(T('Saldo disponível'))}</span><b class="${bal.length > 11 ? 'sm' : ''}">${UI.esc(bal)}</b></div>${cashCard}</div></div>`; }
  register({ id: 'bank', name: 'Banco', sizes: ['2x2', '4x2'], app: 'wallet', render: size => { const m = (System.player && System.player.money) || {}; if (isA()) return bankA(size, m); return size === '4x2'
    ? `<div class="wrow"><div class="grow"><div class="wt" style="color:#30D158">Fleeca</div><div class="wb" style="font-size:30px;margin-top:4px">${UI.money(m.bank || 0)}</div><div class="ws">Saldo disponível</div></div><div style="text-align:right">${g('card', 30)}<div class="ws" style="margin-top:6px">Dinheiro</div><div class="wm">${UI.money(m.cash || 0)}</div></div></div>`
    : `<div class="wt" style="color:#30D158">Fleeca</div><div class="wb" style="font-size:24px;margin-top:4px">${UI.money(m.bank || 0)}</div><div class="ws">Saldo disponível</div><div class="wrow" style="margin-top:auto;gap:6px">${g('card', 21)}<span class="ws">Dinheiro: ${UI.money(m.cash || 0)}</span></div>`; } });

  /* ---------- VISTA HOJE (a página só de widgets à esquerda da 1.a página, home.js): widgets novos ----------
     Cripto (cotação e linha do preço, a MESMA RPC da app Cripto), Calendário mensal (o mês inteiro com hoje marcado e um ponto
     nos dias com eventos) e Mapas (o destino da rota ou o sítio mais perto, e o total de marcadores, os mesmos da app Mapas).
     Também entram no seletor do ecrã principal. A mesma marcação nos dois sistemas: o aspeto PearOS / Nova UI é só CSS
     (shell.css e oneui-widgets.css, classes tdv-). */
  const tdvNf = (v, d = 2) => { try { return new Intl.NumberFormat((window.L && L.intl) ? L.intl() : 'pt-PT', { minimumFractionDigits: d, maximumFractionDigits: d }).format(v); } catch (e) { return (+v || 0).toFixed(d); } };
  const tdvTf = (s, v) => (window.L && L.tf) ? L.tf(s, v) : String(s).replace('%s', v);
  /* Cripto: a série chega por RPC (assíncrona) e fica em memória; o render é síncrono e usa a última que chegou. Pede outra no
     máximo a cada 90 s (o refresh do minuto não manda uma RPC por minuto) e só repinta se ela mudou */
  let cyS = null, cyT = 0, cyBusy = false;
  function cyPull() {
    if (cyBusy || Date.now() - cyT < 90000 || !window.Bridge || !Bridge.rpc) return; cyBusy = true;
    Promise.resolve().then(() => Bridge.rpc('crypto.state')).then(r => { cyBusy = false; cyT = Date.now(); if (!r || !Array.isArray(r.series)) return;
      const s = r.series.map(Number).filter(v => isFinite(v)).slice(-40), p = +r.price || s[s.length - 1] || 0, sig = p + '|' + s.length + '|' + s[0] + '|' + s[s.length - 1];
      if (cyS && cyS.sig === sig) return; cyS = { s, p, sig }; refreshType('crypto'); }).catch(() => { cyBusy = false; cyT = Date.now(); });
  }
  /* linha do preço: um caminho SVG normalizado (sem eixos), a área por baixo e a linha tracejada do valor de abertura */
  function cySpark(s, w, h) {
    if (!s || s.length < 2) return `<svg class="tdv-cy-g" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none" aria-hidden="true"><path class="b" d="M0 ${h / 2}H${w}" vector-effect="non-scaling-stroke"/></svg>`;
    const mn = Math.min(...s), mx = Math.max(...s), sp = (mx - mn) || 1, Y = v => (h - 3 - (v - mn) / sp * (h - 6)).toFixed(2);
    const d = s.map((v, i) => (i ? 'L' : 'M') + (i / (s.length - 1) * w).toFixed(2) + ' ' + Y(v)).join(' ');
    return `<svg class="tdv-cy-g" viewBox="0 0 ${w} ${h}" preserveAspectRatio="none" aria-hidden="true"><path class="a" d="${d} L${w} ${h} L0 ${h}Z"/><path class="b" d="M0 ${Y(s[0])}H${w}" vector-effect="non-scaling-stroke"/><path class="l" d="${d}" vector-effect="non-scaling-stroke"/></svg>`;
  }
  function cryptoW(size) {
    setTimeout(cyPull, 0);
    const s = cyS ? cyS.s : [], p = cyS ? cyS.p : 0, a = s.length > 1 ? s[0] : p, ch = p - a, pc = a ? ch / a * 100 : 0, up = ch >= 0;
    const sg = v => (v > 0 ? '+' : v < 0 ? '-' : '') + tdvNf(Math.abs(v));
    const chg = cyS ? `${sg(ch)} (${sg(pc)}%)` : '--', price = cyS ? tdvNf(p) : '--';
    const head = `<div class="tdv-cy-h"><div><b>BTC</b><span>${UI.esc(T('Cripto'))}</span></div><i>&#8383;</i></div>`;
    if (size === '4x2') return `<div class="tdv-cy s42 ${up ? 'up' : 'dn'}"><div class="tdv-cy-l">${head}<div class="tdv-cy-v"><em class="tdv-cy-c">${UI.esc(chg)}</em><b class="tdv-cy-p">${UI.esc(price)}</b></div></div><div class="tdv-cy-r">${cySpark(s, 200, 100)}</div></div>`;
    return `<div class="tdv-cy s2 ${up ? 'up' : 'dn'}">${head}<em class="tdv-cy-c">${UI.esc(chg)}</em>${cySpark(s, 100, 40)}<b class="tdv-cy-p">${UI.esc(price)}</b></div>`;
  }
  register({ id: 'crypto', name: 'Cripto', sizes: ['2x2', '4x2'], app: 'crypto', style: 'padding:0', render: cryptoW });
  /* Calendário mensal: o nome do mês, as iniciais dos dias (segunda primeiro) e os dias; hoje num círculo (vermelho no PearOS,
     azul na Nova UI) e um ponto por baixo dos dias com eventos (Store 'events', o mesmo da app Calendário) */
  function calMonthW() {
    const d = new Date(), y = d.getFullYear(), m = d.getMonth(), today = localDay(d), off = (new Date(y, m, 1).getDay() + 6) % 7, n = new Date(y, m + 1, 0).getDate();
    const has = new Set((Store.get('events', []) || []).filter(e => e && typeof e.date === 'string').map(e => e.date));
    let h = ''; for (let i = 0; i < 7; i++) h += `<i>${UI.esc(dayL(new Date(y, m, 1 - off + i)))}</i>`;
    for (let i = 0; i < off; i++) h += '<span></span>';
    for (let k = 1; k <= n; k++) { const key = localDay(new Date(y, m, k)); h += `<span class="${key === today ? 'on' : ''}${has.has(key) ? ' ev' : ''}">${k}</span>`; }
    return `<div class="tdv-cm r${Math.ceil((off + n) / 7)}"><div class="tdv-cm-h">${UI.esc(monthL(d))}</div><div class="tdv-cm-g">${h}</div></div>`;
  }
  register({ id: 'calmonth', name: 'Calendário mensal', sizes: ['2x2'], app: 'calendar', style: 'padding:0', render: calMonthW });
  /* Mapas: fundo de mapa desenhado (ruas e quarteirões), o glifo da app e em baixo o destino da rota com a distância, ou o
     sítio mais perto de onde o jogador está (Maps.me) com o total de marcadores (os sítios do servidor e os guardados) */
  const MAP_GLYPH = '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M3 6.6 9 4.2l6 2.4 6-2.4v13.2L15 19.8l-6-2.4-6 2.4z"/><path d="M9 4.2v13.2M15 6.6v13.2" fill="none" stroke="#2F7CF6" stroke-width="1.5"/></svg>';
  const MAP_BG = '<svg class="tdv-mp-bg" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><path class="pk" d="M118 18h52v40h-52zM24 122h44v52H24z"/><path class="wt" d="M0 150c30-8 50 10 80 2s40-24 70-18 40 18 50 16v50H0z"/><g class="st"><path d="M0 46h200M0 98h200M40 0v200M100 0v200M156 0v200M0 72h120M70 0v120"/></g><g class="hw"><path d="M-10 196 210 8"/><path d="M0 120c40-6 80-30 120-34s60 6 80 2"/></g></svg>';
  function mapsW(size) {
    const M = window.Maps, me = (M && M.me) || { x: 0, y: 0 };
    const poi = (M && Array.isArray(M.poi) && M.poi.length) ? M.poi : (typeof DEFAULT_POI !== 'undefined' && Array.isArray(DEFAULT_POI) ? DEFAULT_POI : []);
    const all = poi.concat((M && Array.isArray(M.places)) ? M.places : []).filter(p => p && p.name && isFinite(+p.x) && isFinite(+p.y));
    const far = p => Math.hypot(+p.x - me.x, +p.y - me.y), dtx = v => v >= 1000 ? tdvNf(v / 1000, 1) + ' km' : Math.round(v) + ' m';
    const r = M && M.route; let title, sub;
    if (r) { title = r.name; sub = dtx(far(r)); }
    else { let best = null, bd = Infinity; all.forEach(p => { const k = far(p); if (k < bd) { bd = k; best = p; } }); title = best ? best.name : 'Los Santos'; sub = all.length === 1 ? T('1 marcador') : tdvTf('%s marcadores', all.length); }
    return `<div class="tdv-mp ${size === '4x2' ? 's42' : 's2'}${r ? ' rt' : ''}">${MAP_BG}<span class="tdv-mp-ic">${MAP_GLYPH}</span><div class="tdv-mp-t"><b>${UI.esc(title)}</b><span>${r ? g('nav', 12) : ''}${UI.esc(sub)}</span></div></div>`;
  }
  register({ id: 'maps', name: 'Mapas', sizes: ['2x2', '4x2'], app: 'maps', style: 'padding:0', render: mapsW });
  if (window.Bridge && Bridge.on) Bridge.on('maps:route', () => { try { refreshType('maps'); } catch (e) {} });

  /* Widget sem registo: o de uma app EXTERNA só existe enquanto essa app viver (o registo é em memória),
     por isso a célula gravada na home sobrevive-lhe. Em vez de uma caixa anónima a dizer "Widget
     indisponível", mostra-se o nome que ficou gravado com a célula e diz-se o que se passa - sem
     prometer que volta (só volta quando o resource dono a registar outra vez). */
  const gone = o => `<div class="wt">${UI.esc((o && o.name) || 'Widget')}</div><div class="ws" style="margin-top:auto">Indisponível</div>`;
  function html(type, size, opts) { const d = reg[type]; if (!d) return gone(opts); try { return d.render(SIZES.includes(size) ? size : sizesOf(d)[0]) || ''; } catch (e) { return ''; } }
  /* tamanho no data-size: o refresh e o tick voltam a desenhar com o mesmo; os externos não recebem `style` de fora.
     data-wname = nome de reserva para quando o registo desaparecer (o refresh/tick não recebem `opts`) */
  function render(type, size, opts) { const d = reg[type] || {}; const sz = SIZES.includes(size) ? size : sizesOf(d)[0]; const nm = d.name || (opts && opts.name) || '';
    return `<div class="wg ${d.glass ? 'glass' : ''} ${d.external ? 'ext' : ''}${d.clear ? ' clear' : ''}" data-type="${UI.esc(type)}" data-size="${sz}"${nm ? ` data-wname="${UI.esc(nm)}"` : ''} style="${d.external ? '' : (d.style || '')}">${html(type, sz, { name: nm })}</div>`; }
  function hydrateOne(w) { const d = reg[w.dataset.type]; if (d && d.hydrate) { try { d.hydrate(w, w.dataset.size); } catch (e) {} } }
  /* depois de o widget entrar no DOM: pinta as imagens (capa, fotos) pelo CSSOM */
  function hydrate(root) { if (!root) return; if (root.matches && root.matches('.wg[data-type]')) hydrateOne(root); root.querySelectorAll('.wg[data-type]').forEach(hydrateOne); }
  /* PERFUI (2026-10-05): corre a cada minuto com a home à vista. Um widget cujo HTML não mudou (notas, meteorologia, fotos...)
     já não é reconstruído: antes TODOS levavam innerHTML novo (estilo, layout, pintura, imagens e a tradução do i18n outra vez),
     um soluço por minuto. O hydrate corre sempre (só escreve propriedades: as fotos/capa novas entram na mesma). */
  function refresh(el) { el.querySelectorAll('.wg[data-type]').forEach(w => { const h = html(w.dataset.type, w.dataset.size, { name: w.dataset.wname }); if (w._wgh !== h) { w.innerHTML = h; w._wgh = h; } hydrateOne(w); }); }
  function refreshType(id) { const home = document.getElementById('home'); if (!home) return; home.querySelectorAll('.wg[data-type]').forEach(w => { if (w.dataset.type === id) { const h = html(id, w.dataset.size, { name: w.dataset.wname }); w.innerHTML = h; w._wgh = h; hydrateOne(w); } }); }
  /* corre a cada segundo: os widgets só existem na home, por isso procura-se lá dentro e não no documento inteiro (com as janelas das apps retidas) */
  function tick(d) { const home = document.getElementById('home'); if (!home) return; home.querySelectorAll('.wg[data-type]').forEach(w => { const def = reg[w.dataset.type]; if (def && def.tick) { try { def.tick(w, d); } catch (e) {} } }); if (d.getSeconds() === 0) refresh(home); }
  /* `app` de reserva (gravado na célula da home): sem registo o toque ainda abre a app dona, se ela existir */
  function tap(type, app) { const d = reg[type];
    if (d && !d.external && d.onTap) { d.onTap(); return; }
    const a = (d && d.app) || (typeof app === 'string' ? app : null);
    if (a && window.App && App.get(a)) { System.openApp(a); return; }
    if (!d) UI.toast('Widget indisponível');   /* honesto: quem o fornecia já não está no telemóvel */
  }
  /* seletor: uma secção por tamanho; onPick recebe uma cópia do registo com o `size` escolhido (opts.only = só esse tipo, para "Editar widget") */
  /* ---------- seletor de widgets Nova UI ----------
     Como na One UI: uma pesquisa em cima e um cartão por app ("3 widgets"); tocar no cartão abre a fila de pré-visualizações
     (o widget a sério, desenhado uma vez e encolhido com `zoom`, que no CEF fica nítido) com o tamanho por baixo; tocar numa
     pré-visualização adiciona. As pré-visualizações só se desenham quando o cartão abre (e uma vez). Mesmo contrato do PearOS. */
  const SZ_TXT = s => s.replace('x', ' × ');
  function pickerA(onPick, opts = {}) {
    const all = list().filter(w => !w.hidden && (!w.os || w.os === System.os) && (!opts.only || w.id === opts.only)); let sh = null;
    const groups = {}; all.forEach(w => { const k = w.app && window.App && App.get(w.app) ? w.app : '_'; (groups[k] = groups[k] || []).push(w); });
    const gname = k => k === '_' ? T('Sistema') : App.name(k);
    const keys = Object.keys(groups).sort((a, b) => gname(a).localeCompare(gname(b), 'pt'));
    const body = document.createElement('div'); body.className = 'ah-wp';
    const sb = UI.el(`<div class="ah-wp-s">${g('search', 20)}<input type="text" spellcheck="false" autocomplete="off" maxlength="30"></div>`); const q = sb.querySelector('input'); q.placeholder = T('Pesquisar widgets'); body.appendChild(sb);
    const cards = [];
    keys.forEach(k => { const ws = groups[k]; const n = ws.reduce((s, w) => s + sizesOf(w).length, 0);
      const card = UI.el(`<div class="ah-wp-app"><div class="ah-wp-hd">${k !== '_' ? Icons.tileBox(k) : `<div class="tile ah-wp-gen">${g('grid', 22)}</div>`}<div class="ah-wp-t"><b></b><span></span></div><div class="ah-wp-ch">${g('chevD', 20)}</div></div><div class="ah-wp-sc"></div></div>`);
      card.querySelector('.ah-wp-t b').textContent = gname(k); card.querySelector('.ah-wp-t span').textContent = n + ' ' + (n === 1 ? 'widget' : 'widgets');
      const sc = card.querySelector('.ah-wp-sc'); let built = false;
      const fill = () => { if (built) return; built = true;
        ws.forEach(w => sizesOf(w).forEach(s => { const pv = UI.el(`<div class="ah-wp-pv s${s}"><div class="ah-wp-box"><div class="hi widget w${s} ah-wp-hi">${render(w.id, s, { name: w.name })}</div></div><div class="ah-wp-lb"><b></b><span>${SZ_TXT(s)}</span></div></div>`);
          pv.querySelector('.ah-wp-lb b').textContent = T(w.name); hydrate(pv);
          pv.onclick = e => { e.stopPropagation(); Sound.play('click'); sh.close(); onPick(Object.assign({}, w, { size: s })); }; sc.appendChild(pv); })); };
      card._toggle = on => { if (on) fill(); card.classList.toggle('open', on); };
      /* abrir um cartão perto do fundo: a folha desliza o necessário para as pré-visualizações ficarem à vista (sem scrollIntoView, que mexia no #screen) */
      card.querySelector('.ah-wp-hd').onclick = () => { const on = !card.classList.contains('open'); card._toggle(on); Sound.play('click');
        if (on) { const sc = card.closest('.content'); if (sc) { const z = UI.zoom ? UI.zoom() : 1, cr = card.getBoundingClientRect(), sr = sc.getBoundingClientRect(); if (cr.bottom > sr.bottom) sc.scrollTop += Math.min(cr.top - sr.top - 8, cr.bottom - sr.bottom + 12) / z; } } };
      card._words = (gname(k) + ' ' + ws.map(w => T(w.name) + ' ' + w.name).join(' ')).toLowerCase(); cards.push(card); body.appendChild(card); });
    const none = UI.el('<div class="ah-wp-none"></div>'); none.textContent = all.length ? T('Sem resultados') : T('Nenhum widget disponível.'); body.appendChild(none); none.hidden = !!all.length;
    /* pesquisa: filtra os cartões pelo nome da app e dos widgets (só mostra/esconde, não refaz nada) */
    q.addEventListener('input', () => { const v = q.value.trim().toLowerCase(); let vis = 0; cards.forEach(c => { const ok = !v || c._words.includes(v); c.hidden = !ok; if (ok) vis++; }); none.hidden = vis > 0; });
    /* com um só cartão (Editar widget, "only") abre-se logo */
    if (cards.length === 1) cards[0]._toggle(true);
    sh = UI.sheet({ title: opts.title || T('Widgets'), right: T('Cancelar'), body, cls: 'ah-wpick' }); return sh;
  }
  function pickerSheet(onPick, opts = {}) {
    if (isA()) return pickerA(onPick, opts);
    const all = list().filter(w => !w.hidden && (!w.os || w.os === System.os) && (!opts.only || w.id === opts.only)); let sh = null;
    const sections = SIZES.map(s => ({ header: SIZE_LABEL[s], items: all.filter(w => sizesOf(w).includes(s)).map(w => ({ icon: App.get(w.app) ? Icons.tile(w.app) : 'grid', tile: true, iconBg: 'transparent', label: w.name, sub: SIZE_LABEL[s], chevron: false, onTap: () => { sh.close(); onPick(Object.assign({}, w, { size: s })); } })) })).filter(s => s.items.length);
    const body = UI.list(sections.length ? sections : [{ footer: 'Nenhum widget disponível.' }]); sh = UI.sheet({ title: opts.title || 'Adicionar widget', right: 'Cancelar', body }); return sh; }
  /* o tempo do jogo mudou (client/main.lua → WX.set): o widget repinta já, sem esperar pelo minuto */
  if (window.Bridge && Bridge.on) Bridge.on('wx:changed', () => { try { refreshType('weather'); refreshType('weather4'); refreshType('clockwx');   /* o "Tempo e relógio" da Nova UI também mostra o tempo do jogo */ if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } catch (e) {} });
  return { register, update, unregister, list, render, hydrate, refresh, refreshType, tick, tap, pickerSheet, sanitize, sizesOf, SIZES, get: id => reg[id] };
})();
