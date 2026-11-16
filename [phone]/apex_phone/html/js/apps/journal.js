/* ===================== DIÁRIO =====================
   Entradas com texto, estado de espírito, UMA foto da galeria (por id: a imagem nunca viaja com a entrada), o
   sítio onde foi escrita (o lugar conhecido mais perto, senão coordenadas arredondadas) e o tempo do jogo nesse
   momento (WX.now). Tudo no servidor (server/journal.lua: journal.list / save / delete / fav); a lista pede-se às
   páginas (journal.list { before, limit }). Sugestões como no Diário do PearOS: "Escreve sobre o teu dia",
   "Fotos de hoje" e "Lugares". A mesma marcação no Android com o desenho da Nova UI (app-journal.css). */
(() => {
  const g = UI.g;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf) ? L.tf(s, ...v) : String(s).replace(/%s/g, () => String(v.shift()));
  const isA = () => !!(System.isAndroid && System.isAndroid());
  const MOODS = [
    { id: 'happy', label: 'Feliz', c: '#FFB300', p: '<circle cx="12" cy="12" r="9"/><path d="M8.3 14.3a4.6 4.6 0 0 0 7.4 0M9 10h.01M15 10h.01"/>' },
    { id: 'excited', label: 'Entusiasmado', c: '#FF2D55', p: '<path d="m12 3 1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9zM5 3v4M3 5h4M19 17v4M17 19h4"/>' },
    { id: 'calm', label: 'Calmo', c: '#34C759', p: '<path d="M5 19c0-8 5-13 14-14-1 9-6 14-14 14z"/><path d="M5 19c2-5 5-8 9-10"/>' },
    { id: 'neutral', label: 'Normal', c: '#8E8E93', p: '<circle cx="12" cy="12" r="9"/><path d="M8.5 15h7M9 10h.01M15 10h.01"/>' },
    { id: 'tired', label: 'Cansado', c: '#5E5CE6', p: '<path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/><path d="M17 3h4l-4 4h4"/>' },
    { id: 'sad', label: 'Triste', c: '#0A84FF', p: '<circle cx="12" cy="12" r="9"/><path d="M15.7 16a4.6 4.6 0 0 0-7.4 0M9 10h.01M15 10h.01"/>' },
  ];
  const moodOf = id => MOODS.find(m => m.id === id) || null;
  const moodSvg = (m, size) => `<svg viewBox="0 0 24 24" width="${size}" height="${size}" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${m.p}</svg>`;
  const monthKey = ts => { const d = new Date(+ts); return d.getFullYear() + '-' + UI.pad(d.getMonth() + 1); };
  const monthLabel = k => { const [y, m] = k.split('-').map(Number); const d = new Date(y, m - 1, 1); if (window.L && L.code && L.code !== 'pt' && L.intl) { try { const s = new Intl.DateTimeFormat(L.intl(), { month: 'long', year: 'numeric' }).format(d); return s.charAt(0).toUpperCase() + s.slice(1); } catch (e) {} } const n = UI.MESES[m - 1] || ''; return n.charAt(0).toUpperCase() + n.slice(1) + ' ' + y; };
  const localDay = (d = new Date()) => `${d.getFullYear()}-${UI.pad(d.getMonth() + 1)}-${UI.pad(d.getDate())}`;
  const whenText = ts => { const d = new Date(+ts); return (UI.fmtWdDayMon ? UI.fmtWdDayMon(d) : UI.fmtDate(d, true)) + ' · ' + UI.fmtTime(d); };
  /* tempo gravado: "TIPO|temperatura" → { icon, label, t } */
  const wxParse = s => { const m = /^([A-Z_]+)\|(-?\d+)$/.exec(String(s || '')); if (!m || !window.WX || !WX.TYPES || !WX.TYPES[m[1]]) return null; const t = WX.TYPES[m[1]]; return { icon: WX.icon(t[0]), label: t[1], t: +m[2] }; };
  const wxNow = () => { try { const w = WX.now(); return w.w + '|' + w.t; } catch (e) { return null; } };
  /* o sítio: o lugar conhecido mais perto (Mapas) a menos de 800 m, senão as coordenadas arredondadas */
  async function placeNow() {
    let c = null; try { c = await Bridge.call('getCoords'); } catch (e) { c = null; }
    if (!c || !isFinite(+c.x) || !isFinite(+c.y)) return null;
    const M = window.Maps; const poi = (M && Array.isArray(M.poi) && M.poi.length) ? M.poi : (typeof DEFAULT_POI !== 'undefined' && Array.isArray(DEFAULT_POI) ? DEFAULT_POI : []);
    const all = poi.concat((M && Array.isArray(M.places)) ? M.places : []).filter(p => p && p.name && isFinite(+p.x) && isFinite(+p.y));
    let best = null, bd = Infinity; all.forEach(p => { const d = Math.hypot(+p.x - +c.x, +p.y - +c.y); if (d < bd) { bd = d; best = p; } });
    if (best && bd <= 800) return String(best.name).slice(0, 60);
    return 'X ' + Math.round(+c.x) + ', Y ' + Math.round(+c.y);
  }
  const photoOf = id => { if (!id || !window.Photos) return null; return (Photos.cache || []).find(p => p && p.id === +id && !p.video) || null; };
  const paintPhoto = (el, p) => { if (!el) return; if (!p) { el.hidden = true; return; } el.hidden = false; el.style.backgroundImage = Photos.bg(p); Photos.lazy(el, p); };

  const S = { cfg: null, items: [], more: false, total: 0, loaded: false, err: null };
  async function load(more) {
    if (!S.cfg) { S.cfg = (await Bridge.rpc('journal.config')) || { enabled: true, maxChars: 8000, photos: true, pageSize: 40 }; }
    const d = { limit: S.cfg.pageSize || 40 }; if (more && S.items.length) d.before = S.items[S.items.length - 1].created;
    let r = null; try { r = await Bridge.rpcRaw('journal.list', d); } catch (e) { r = null; }
    if (!r || r.error) { S.err = (r && r.error) || 'rpc'; S.loaded = true; return; }
    S.err = null;
    const items = Array.isArray(r.items) ? r.items : [];
    if (more) { const have = new Set(S.items.map(x => x.id)); items.forEach(x => { if (!have.has(x.id)) S.items.push(x); }); } else S.items = items;
    S.more = !!r.more; if (r.total != null) S.total = +r.total || 0; S.loaded = true;
  }
  if (window.Bridge && Bridge.on) Bridge.on('session:changed', () => { S.items = []; S.loaded = false; S.more = false; S.total = 0; });

  App.define('journal', {
    name: 'Diário', category: 'Produtividade', core: false, statusBar: 'auto', needs: ['location'],
    description: 'Escreve sobre o teu dia com o estado de espírito, uma foto, o sítio onde estás e o tempo que faz. Guardado no servidor, só teu.',
    resume(win) { try { win._jnlPaint && win._jnlPaint(); } catch (e) {} },
    open(win) {
      const A = isA();
      let q = '', filter = 'all', tl = null;
      const root = UI.view({ title: 'Diário', large: true, cls: 'jnl-v jnl-root', right: [{ icon: 'search', onTap: () => { sbox.classList.toggle('on'); if (sbox.classList.contains('on')) setTimeout(() => sbox.input.focus(), 60); else { sbox.input.value = ''; q = ''; paint(); } } }] });
      const sbox = UI.search('Pesquisar no diário', s => { q = s; paint(); }); sbox.classList.add('jnl-search');
      const chips = UI.chips(['Todos', 'Favoritos', 'Com fotos'], 0, i => { filter = ['all', 'fav', 'photo'][i]; Sound.play('click'); paint(); }); chips.classList.add('jnl-chips');
      const sugg = UI.el(`<div class="jnl-sh"><span>Sugestões</span></div>`);
      const sgRow = UI.el(`<div class="jnl-sugg"><div class="jnl-sg sg-write"><div class="jnl-sgi">${g('pen', 22)}</div><b>Escreve sobre o teu dia</b><span>Um momento, uma ideia, o que te apetecer.</span></div><div class="jnl-sg sg-photos"><div class="jnl-sgp"></div><b>Fotos de hoje</b><span></span></div><div class="jnl-sg sg-place"><div class="jnl-sgi">${g('pin', 22)}</div><b>Lugares</b><span></span></div></div>`);
      const holder = UI.el('<div class="jnl-tl"></div>');
      const foot = UI.el('<div class="jnl-foot"></div>');
      root.content.append(sbox, chips, sugg, sgRow, holder, foot);
      const fab = UI.el(`<div class="jnl-fab">${g(A ? 'pen' : 'plus', A ? 26 : 30)}</div>`); root.appendChild(fab); fab.onclick = () => { Sound.play('click'); edit(null); };
      sgRow.querySelector('.sg-write').onclick = () => edit(null);
      sgRow.querySelector('.sg-photos').onclick = () => { const ph = recentPhotos(); edit(null, ph[0] ? { photoId: ph[0].id } : null); };
      sgRow.querySelector('.sg-place').onclick = () => edit(null, { place: true });
      const recentPhotos = () => { const cache = (window.Photos && Photos.cache) || []; const today = localDay(); const list = cache.filter(p => p && !p.video); const todays = list.filter(p => localDay(new Date(+p.created || 0)) === today); return (todays.length ? todays : list).slice(0, 3); };
      const paintSugg = () => {
        const ph = recentPhotos(), box = sgRow.querySelector('.jnl-sgp'), sub = sgRow.querySelector('.sg-photos span');
        box.innerHTML = ''; if (!ph.length) { box.innerHTML = `<div class="jnl-sgi">${g('photo', 22)}</div>`; sub.textContent = T('Sem fotos recentes'); }
        else { ph.forEach(p => { const t = UI.el('<i></i>'); paintPhoto(t, p); box.appendChild(t); }); const today = localDay(ph[0] && new Date(+ph[0].created || 0)) === localDay(); sub.textContent = today ? T('Guarda uma foto de hoje') : T('Começa por uma das últimas fotos'); }
        const last = S.items.find(x => x.place); sgRow.querySelector('.sg-place span').textContent = last ? last.place : T('Marca onde estás agora');
      };
      /* a linha do tempo: constrói-se do zero só quando a lista muda (filtro, pesquisa, gravar, apagar); o favorito muda no sítio */
      function paint() {
        paintSugg();
        holder.innerHTML = '';
        if (!S.loaded) { holder.appendChild(UI.skeleton ? UI.skeleton('list', 3) : UI.spinner()); return; }
        if (S.err && !S.items.length) { holder.appendChild(UI.empty('book', S.err === 'disabled' ? 'Diário desligado' : 'Sem resposta', S.err === 'disabled' ? 'O servidor desligou o Diário.' : 'Tenta outra vez daqui a pouco.')); foot.textContent = ''; return; }
        const items = S.items.filter(it => (filter === 'all' || (filter === 'fav' ? it.fav : !!it.photoId)) && (!q || String(it.text || '').toLowerCase().includes(q) || String(it.place || '').toLowerCase().includes(q)));
        if (!items.length) { holder.appendChild(UI.empty('book', q ? 'Sem resultados' : filter === 'fav' ? 'Sem favoritos' : filter === 'photo' ? 'Sem entradas com foto' : 'Sem entradas', q ? 'Tenta outra palavra.' : filter !== 'all' ? 'Muda o filtro para veres tudo.' : A ? 'Toca no lápis para escrever a primeira.' : 'Toca no botão em baixo para escrever a primeira.')); foot.textContent = ''; return; }
        let curM = null, grp = null;
        items.forEach(it => { const k = monthKey(it.created); if (k !== curM) { curM = k; holder.appendChild(UI.el(`<div class="jnl-mh">${UI.esc(monthLabel(k))}</div>`)); grp = UI.el('<div class="jnl-grp"></div>'); holder.appendChild(grp); } grp.appendChild(card(it)); });
        if (S.more && !q && filter === 'all') { const b = UI.el('<div class="btn-p btn-s jnl-more">Carregar mais</div>'); b.onclick = async () => { b.classList.add('dis'); await load(true); paint(); }; holder.appendChild(b); }
        foot.textContent = S.total === 1 ? T('1 entrada') : S.total > 1 ? TF('%s entradas', S.total) : '';
      }
      function card(it) {
        const m = moodOf(it.mood), wx = wxParse(it.weather);
        const c = UI.el(`<div class="jnl-card" data-id="${it.id}"><div class="jnl-ch"><span class="jnl-when"></span><i class="jnl-fav ${it.fav ? 'on' : ''}">${g(it.fav ? 'starFill' : 'star', 18)}</i></div><div class="jnl-ph" hidden></div><p class="jnl-tx" data-noi18n></p><div class="jnl-meta">${m ? `<span class="jnl-chip jnl-mood" style="--c:${m.c}">${moodSvg(m, 15)}<em>${UI.esc(m.label)}</em></span>` : ''}${it.place ? `<span class="jnl-chip">${g('pin', 14)}<em data-noi18n>${UI.esc(it.place)}</em></span>` : ''}${wx ? `<span class="jnl-chip">${g(wx.icon, 14)}<em>${wx.t}° · ${UI.esc(wx.label)}</em></span>` : ''}</div></div>`);
        c.querySelector('.jnl-when').textContent = whenText(it.created);
        const tx = c.querySelector('.jnl-tx'); if (it.text) tx.textContent = it.text; else tx.remove();
        if (it.photoId) { const p = photoOf(it.photoId); const ph = c.querySelector('.jnl-ph'); if (p) paintPhoto(ph, p); else if (window.Photos) Photos.load().then(() => { const p2 = photoOf(it.photoId); if (p2 && c.isConnected) paintPhoto(ph, p2); }); }
        c.querySelector('.jnl-fav').onclick = e => { e.stopPropagation(); toggleFav(it, c); };
        c.onclick = () => edit(it);
        UI.longPress(c, () => UI.ctxMenu(c, [{ label: it.fav ? 'Tirar dos favoritos' : 'Favorito', icon: 'star', onTap: () => toggleFav(it, c) }, { label: 'Editar', icon: 'pen', onTap: () => edit(it) }, { label: 'Apagar', icon: 'trash', danger: true, onTap: () => del(it) }]));
        return c;
      }
      async function toggleFav(it, c) {
        const r = await Bridge.rpcRaw('journal.fav', { id: it.id, fav: !it.fav });
        if (!r || !r.ok) { Sound.play('error'); UI.toast(T('Não foi possível guardar')); return; }
        it.fav = !!r.fav; Sound.play('click');
        const i = c && c.querySelector('.jnl-fav'); if (i) { i.classList.toggle('on', it.fav); i.innerHTML = g(it.fav ? 'starFill' : 'star', 18); }
        if (filter === 'fav' && !it.fav) paint();
      }
      async function del(it) {
        if (!(await UI.confirm(T('Apagar entrada'), T('Esta ação não pode ser anulada.'), T('Apagar'), true))) return;
        const r = await Bridge.rpcRaw('journal.delete', { id: it.id });
        if (!r || !r.ok) { Sound.play('error'); UI.toast(T('Não foi possível apagar')); return; }
        S.items = S.items.filter(x => x.id !== it.id); S.total = Math.max(0, S.total - 1); paint();
      }
      /* ----- editor: texto, estado de espírito, foto, sítio e tempo ----- */
      function edit(it, preset) {
        const fresh = !it; const cfg = S.cfg || { maxChars: 8000, photos: true };
        const draft = { text: it ? it.text || '' : '', mood: it ? it.mood : null, photoId: it ? it.photoId : (preset && preset.photoId) || null, place: it ? it.place : null, weather: it ? it.weather : wxNow(), fav: it ? !!it.fav : false };
        const v = UI.view({ title: fresh ? 'Nova entrada' : 'Editar', back: 'Diário', cls: 'jnl-v jnl-ed', right: [{ label: 'Guardar', bold: true, onTap: () => save() }] });
        const ed = UI.el(`<div class="jnl-edit"><div class="jnl-edate"></div><textarea class="jnl-ta" placeholder="O que te vai na cabeça?"></textarea><div class="jnl-count"></div>
          <div class="jnl-sec">Estado de espírito</div><div class="jnl-moods">${MOODS.map(m => `<div class="jnl-mo" data-id="${m.id}" style="--c:${m.c}"><i>${moodSvg(m, 24)}</i><span>${UI.esc(m.label)}</span></div>`).join('')}</div>
          <div class="jnl-sec">Detalhes</div><div class="jnl-tools">
            <div class="jnl-tool t-photo ${cfg.photos === false ? 'hidden' : ''}"><div class="jnl-ti">${g('photo', 20)}</div><div class="jnl-tb"><b>Foto</b><span></span></div><div class="jnl-thumb" hidden></div><div class="jnl-tx2">${g('chevR', 18)}</div></div>
            <div class="jnl-tool t-place"><div class="jnl-ti">${g('pin', 20)}</div><div class="jnl-tb"><b>Localização</b><span></span></div></div>
            <div class="jnl-tool t-wx"><div class="jnl-ti">${g('cloudSun', 20)}</div><div class="jnl-tb"><b>Tempo</b><span></span></div></div>
          </div>${fresh ? '' : '<div class="jnl-del">Apagar entrada</div>'}</div>`);
        const ta = ed.querySelector('.jnl-ta'), count = ed.querySelector('.jnl-count');
        ta.value = draft.text; ta.maxLength = +cfg.maxChars || 8000;
        ed.querySelector('.jnl-edate').textContent = whenText(it ? it.created : Date.now());
        const paintCount = () => { const n = ta.value.length, max = +cfg.maxChars || 8000; count.textContent = n > max * 0.8 ? TF('%s de %s caracteres', n, max) : ''; count.classList.toggle('over', n >= max); };
        ta.oninput = () => { draft.text = ta.value; paintCount(); }; paintCount();
        const paintMood = () => ed.querySelectorAll('.jnl-mo').forEach(m => m.classList.toggle('on', m.dataset.id === draft.mood));
        ed.querySelectorAll('.jnl-mo').forEach(m => { m.onclick = () => { draft.mood = draft.mood === m.dataset.id ? null : m.dataset.id; Sound.play('tick'); paintMood(); }; }); paintMood();
        const tPhoto = ed.querySelector('.t-photo'), tPlace = ed.querySelector('.t-place'), tWx = ed.querySelector('.t-wx');
        const paintTools = () => {
          const p = photoOf(draft.photoId); tPhoto.querySelector('span').textContent = draft.photoId ? T('Toca para trocar ou tirar') : T('Escolhe uma foto da galeria'); paintPhoto(tPhoto.querySelector('.jnl-thumb'), p); tPhoto.classList.toggle('on', !!draft.photoId);
          tPlace.querySelector('span').textContent = draft.place ? draft.place : T('Toca para marcar onde estás'); tPlace.classList.toggle('on', !!draft.place);
          const wx = wxParse(draft.weather); tWx.querySelector('span').textContent = wx ? wx.t + '° · ' + T(wx.label) : T('Sem registo do tempo'); tWx.classList.toggle('on', !!wx); tWx.querySelector('.jnl-ti').innerHTML = g(wx ? wx.icon : 'cloudSun', 20);
        };
        tPhoto.onclick = async () => { if (draft.photoId) { const a = await UI.actionSheet({ title: T('Foto'), buttons: [{ label: T('Trocar foto'), value: 'swap', icon: 'photo' }, { label: T('Tirar foto da entrada'), value: 'rm', icon: 'trash', danger: true }] }); if (a === 'rm') { draft.photoId = null; paintTools(); return; } if (a !== 'swap') return; }
          const p = await Photos.pick(T('Escolher foto')); if (p) { draft.photoId = p.id; paintTools(); } };
        tPlace.onclick = async () => { if (draft.place) { draft.place = null; paintTools(); return; } tPlace.querySelector('span').textContent = T('A localizar'); const pl = await placeNow(); draft.place = pl; if (!pl) UI.toast(T('Sem localização')); paintTools(); };
        tWx.onclick = () => { draft.weather = draft.weather ? null : wxNow(); paintTools(); };
        const delBtn = ed.querySelector('.jnl-del'); if (delBtn) delBtn.onclick = async () => { const before = S.items.length; await del(it); if (S.items.length < before) UI.pop(win); };
        v.content.appendChild(ed); UI.push(win, v);
        let saving = false;
        async function save() {
          if (saving) return;
          const text = ta.value.trim();
          if (!text && !draft.photoId) { UI.toast(T('Escreve alguma coisa ou junta uma foto')); return; }
          saving = true;
          const d = { text, mood: draft.mood, photoId: draft.photoId || null, place: draft.place, weather: draft.weather, fav: draft.fav }; if (it) d.id = it.id;
          const r = await Bridge.rpcRaw('journal.save', d); saving = false;
          if (!r || r.error) { Sound.play('error'); const E = { full: 'O diário está cheio: apaga entradas antigas.', toolong: 'O texto é demasiado longo.', photo: 'Essa foto já não existe na galeria.', empty: 'Escreve alguma coisa ou junta uma foto.', disabled: 'O servidor desligou o Diário.' }; UI.toast(T(E[r && r.error] || 'Não foi possível guardar')); return; }
          if (it) { const i = S.items.findIndex(x => x.id === it.id); if (i > -1) S.items[i] = r; } else { S.items.unshift(r); S.total++; }
          S.items.sort((a, b) => b.created - a.created);
          Sound.play('success'); UI.pop(win); paint();
        }
        if (preset && preset.place && !draft.place) tPlace.click();
        paintTools();
        setTimeout(() => ta.focus(), 420);
      }
      win._jnlPaint = () => { if (root.isConnected) paint(); };
      UI.setRoot(win, root);
      paint();
      const run = async () => { if (window.Photos && !(Photos.cache || []).length) { try { await Photos.load(); } catch (e) {} } await load(false); paint(); };
      run();
      const off = (window.Bridge && Bridge.on) ? Bridge.on('photos', () => { if (System.currentApp() === 'journal') paintSugg(); }) : null;
      const prev = win.onClose; win.onClose = () => { try { off && off(); } catch (e) {} prev && prev(); };
    }
  });
  App.alias('android', { journal: 'Diário' });

  /* ---------- ícones (desenho original): PearOS, caderno com a fita colorida; Nova UI, livro aberto em fundo azul-ardósia ---------- */
  Icons.app.journal = () => Icons.SVG(Icons.G('gJn', '#FFFFFF', '#F0EFF4') + `<defs><linearGradient id="gJn2" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FF9F0A"/><stop offset=".5" stop-color="#FF375F"/><stop offset="1" stop-color="#8E5CFF"/></linearGradient></defs>` + Icons.GL(`<rect x="22" y="18" width="56" height="64" rx="10" fill="url(#gJn2)"/><rect x="22" y="18" width="12" height="64" rx="6" fill="#000" fill-opacity=".14"/>`) + `<g stroke="#fff" stroke-width="4" stroke-linecap="round" stroke-opacity=".92"><path d="M44 36h22M44 48h22M44 60h14"/></g>`);
  Icons.registerOS('android', { journal: () => Icons.SVG(`<defs><linearGradient id="nvJnB" gradientUnits="userSpaceOnUse" x1="38" y1="0" x2="62" y2="100"><stop offset="0" stop-color="#7C8CFF"/><stop offset="1" stop-color="#4455D6"/></linearGradient><radialGradient id="nvJnL" gradientUnits="userSpaceOnUse" cx="30" cy="0" r="80"><stop offset="0" stop-color="#fff" stop-opacity=".18"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient></defs><rect width="100" height="100" fill="url(#nvJnB)"/><rect width="100" height="100" fill="url(#nvJnL)"/><path d="M50 30c-8-6-18-7-28-5v46c10-2 20-1 28 5 8-6 18-7 28-5V25c-10-2-20-1-28 5z" fill="#fff" fill-opacity=".96"/><path d="M50 30v46" stroke="#4455D6" stroke-width="3" stroke-linecap="round"/><path d="M30 40c6-1 10 0 14 2M30 50c6-1 10 0 14 2M56 42c4-2 8-3 14-2M56 52c4-2 8-3 14-2" fill="none" stroke="#4455D6" stroke-width="3" stroke-linecap="round" stroke-opacity=".7"/>`, true) });

  /* ---------- mock do browser ---------- */
  if (window.LocalDB && LocalDB.register && LocalDB.T) {
    const TB = LocalDB.T('journal');
    const seed = () => {
      if (TB.all().length || (Store.global || Store).get('db:journal:seeded', false)) return;
      const now = Date.now(), h = 36e5, d = 864e5;
      const rows = [
        { created: now - 2 * h, text: 'Manhã calma no cais. O mar estava liso e o café do Rui continua o melhor da cidade. Hoje apetece-me andar a pé até Vinewood e deixar o carro na garagem.', mood: 'calm', photo_id: 2, place: 'Del Perro Pier', weather: 'CLEAR|24', fav: 1 },
        { created: now - 1 * d - 5 * h, text: 'Dia longo na oficina. O motor da carrinha finalmente pegou à terceira. A Ana ligou a lembrar a renovação da carta.', mood: 'tired', photo_id: null, place: "Benny's Garage", weather: 'CLOUDS|20', fav: 0 },
        { created: now - 3 * d - 9 * h, text: 'Fomos ver o pôr do sol em Vespucci. Levámos o rádio velho e ficámos até ficar frio.', mood: 'happy', photo_id: 5, place: 'Vespucci Beach', weather: 'EXTRASUNNY|29', fav: 1 },
        { created: now - 9 * d - 2 * h, text: 'Primeira corrida da época: 5 km à volta de Mirror Park. As pernas queixam-se mas a cabeça agradece.', mood: 'excited', photo_id: null, place: 'Mirror Park', weather: 'NEUTRAL|22', fav: 0 },
        { created: now - 20 * d - 6 * h, text: 'Chuva o dia todo. Fiquei em casa a arrumar papéis e a ouvir a rádio.', mood: 'neutral', photo_id: null, place: null, weather: 'RAIN|15', fav: 0 },
        { created: now - 35 * d - 4 * h, text: 'Perdi o telemóvel no cais e um desconhecido devolveu-o. Ainda há gente boa nesta cidade.', mood: 'sad', photo_id: 8, place: 'Elysian Docks', weather: 'FOGGY|16', fav: 0 },
        { created: now - 50 * d - 7 * h, text: 'Mudei-me para o apartamento novo em Grove Street. Caixas por todo o lado, mas a vista compensa.', mood: 'happy', photo_id: null, place: 'Grove Street 12', weather: 'CLEAR|26', fav: 1 },
      ];
      rows.forEach((r, i) => TB.insert(Object.assign({ owner: 'DEV0000', updated: r.created }, r, { id: 1000 + i })));
      (Store.global || Store).set('db:journal:seeded', true);
    };
    const pub = r => ({ id: r.id, created: r.created, updated: r.updated || r.created, text: r.text || '', mood: r.mood || null, photoId: r.photo_id || null, place: r.place || null, weather: r.weather || null, fav: !!(+r.fav) });
    LocalDB.register('journal.config', () => ({ enabled: true, maxEntries: 500, maxChars: 8000, photos: true, pageSize: 40, moods: MOODS.map(m => m.id) }));
    LocalDB.register('journal.list', d => { seed(); const lim = Math.max(1, Math.min(100, Math.floor(+d.limit || 40))); let rows = TB.all().filter(r => r.owner === 'DEV0000').sort((a, b) => b.created - a.created || b.id - a.id); const total = rows.length; if (+d.before > 0) rows = rows.filter(r => r.created < +d.before); return { items: rows.slice(0, lim).map(pub), more: rows.length > lim, total: d.before ? undefined : total }; });
    LocalDB.register('journal.save', d => { seed(); const text = String(d.text == null ? '' : d.text).trim(); if (text.length > 8000) return { error: 'toolong', max: 8000 }; const mood = MOODS.some(m => m.id === d.mood) ? d.mood : null; let photo = null;
      if (d.photoId) { const p = LocalDB.T('photos').all().find(x => x.id === +d.photoId); if (!p || p.video) return { error: 'photo' }; photo = p.id; }
      if (!text && !photo) return { error: 'empty' };
      const place = d.place ? String(d.place).slice(0, 80) : null, weather = /^[A-Z_]+\|-?\d+$/.test(String(d.weather || '')) ? String(d.weather) : null, now = Date.now();
      if (d.id) { const cur = TB.all().find(r => r.id === +d.id); if (!cur) return { error: 'notfound' }; return pub(TB.update(cur.id, { text, mood, photo_id: photo, place, weather, fav: d.fav == null ? cur.fav : (d.fav ? 1 : 0), updated: now })); }
      if (TB.all().length >= 500) return { error: 'full', max: 500 };
      return pub(TB.insert({ owner: 'DEV0000', created: now, updated: now, text, mood, photo_id: photo, place, weather, fav: d.fav ? 1 : 0 })); });
    LocalDB.register('journal.delete', d => { const had = TB.all().some(r => r.id === +d.id); TB.remove(+d.id); return { ok: had }; });
    LocalDB.register('journal.fav', d => { const cur = TB.all().find(r => r.id === +d.id); if (!cur) return { ok: false, error: 'notfound' }; TB.update(cur.id, { fav: d.fav ? 1 : 0, updated: Date.now() }); return { ok: true, fav: !!d.fav }; });
  }
})();
