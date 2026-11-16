/* ============================================================
   RECADO · Atualizações (estados), Canais e Comunidades - pacote RE
   Contrato: docs/ARQUITETURA.md 9.5 (RecadoUpdates) e 9.6 (recado.status.*, recado.channel.*, recado.community.*).

   RecadoUpdates = { updatesView(win), communitiesView(win), statusComposer(win, opts), openStatus(win, owner, opts),
                     openChannel(win, id), openCommunity(win, id), channelDirectory(win) }
   Regista-se no Recado (RA) com Recado.register('updates', …) e os separadores 'updates' e 'communities'.
   O recado.js carrega DEPOIS deste ficheiro: o registo tenta já e volta a tentar no DOMContentLoaded.

   Media (fotos/áudios dos estados, imagens de canais e comunidades): desce pelo RPC recado.social.media, que o
   servidor autoriza com as regras destes ecrãs (o media.get só conhece mensagens e mail). Sobe pelo
   VoiceMsg.uploadData (media.begin/upload/finish da Fase 2), como as fotos das conversas.
   Regras do CEF: sem backdrop-filter, só transform/opacity animam, imagens base64 SEMPRE por CSSOM.
   ============================================================ */
window.RecadoUpdates = (() => {
  const g = (n, s) => Icons.g(n, s);
  const esc = UI.esc;
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const R = () => window.Recado || null;
  /* o json.encode do FiveM manda uma tabela Lua VAZIA como {} e não []: todas as listas passam por aqui */
  const toArr = r => Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error && r.ok !== false ? Object.values(r).filter(x => x && typeof x === 'object') : []);
  const bad = r => !r || !!r.error || r.ok === false;
  const rpc = (name, data) => Promise.resolve().then(() => Bridge.rpcRaw(name, data || {})).then(r => (r === undefined ? null : r), () => ({ error: 'rpc' }));
  /* janela do Recado à frente? Com a app em segundo plano o Escape é do sistema (fechar o telemóvel): os ecrãs
     inteiros deste ficheiro só o apanham quando estão mesmo à vista */
  const winShown = w => !!(w && w.isConnected && w.classList.contains('open'));

  /* ---------- textos de erro (PT-PT) ---------- */
  const ERR = {
    invalid: 'Pedido inválido.', noidentity: 'Esta personagem não tem número de telefone.', nophone: 'Precisas de ter o telemóvel contigo.',
    notfound: 'Já não existe ou não tens acesso.', notadmin: 'Só administradores podem fazer isto.', notowner: 'Só quem criou pode fazer isto.',
    empty: 'Escreve alguma coisa primeiro.', media: 'A imagem ou o áudio não é válido.', badtype: 'Tipo não suportado.', badbg: 'Fundo inválido.',
    privacy: 'Escolhe pelo menos um contacto.', cooldown: 'Espera um instante antes de repetir.', db: 'O servidor ainda está a arrancar. Tenta daqui a pouco.',
    blocked: 'Bloqueaste este contacto.', notmentioned: 'Só quem foi mencionado pode repartilhar.', nosend: 'Não foi possível enviar a resposta.',
    full: 'Já não há vagas.', name: 'Escolhe um nome (até 40 carateres).', busy: 'Ocupado. Tenta outra vez.', already: 'Já está feito.',
    badnumber: 'Esse número não tem telemóvel.', notfollowing: 'Segue o canal para reagir e votar.', badreaction: 'Reação não permitida.',
    incommunity: 'Esse grupo já pertence a outra comunidade.', notgroupadmin: 'Tens de ser administrador desse grupo.', toomany: 'Demasiadas opções.',
    ratelimit: 'Demasiados pedidos seguidos. Tenta daqui a pouco.', rpc: 'O servidor não respondeu.', internal: 'Erro no servidor.', toolarge: 'O ficheiro é demasiado grande.',
    lastadmin: 'A comunidade não pode ficar sem administradores.', notmember: 'Essa pessoa já não é membro.', disabled: 'O Zapp está desligado neste servidor.'
  };
  function errText(r, fb) {
    const c = r && r.error ? String(r.error).split(':')[0] : 'rpc';
    if (c === 'limit') return r && r.max ? `Chegaste ao limite (${r.max}).` : 'Chegaste ao limite.';
    if (ERR[c]) return ERR[c];
    try { const t = R() && typeof R().errorText === 'function' ? R().errorText(c) : null; if (t) return t; } catch (e) {}
    try { if (window.VoiceMsg && VoiceMsg.errorText) return VoiceMsg.errorText(c, fb); } catch (e) {}
    return fb || 'Não foi possível concluir a operação.';
  }

  /* ---------- quem sou e nomes ---------- */
  function me() {
    try { const m = R() && typeof R().me === 'function' ? R().me() : null; if (m && m.number) return m; } catch (e) {}
    const acc = (window.System && System.account) || {};
    const pl = (window.System && System.player) || {};
    return { number: String(acc.phone || pl.phone || ''), name: acc.username || 'Eu' };
  }
  function nameOf(number, fb) {
    if (!number) return fb || '';
    try { const n = R() && typeof R().nameOf === 'function' ? R().nameOf(number) : null; if (n && n !== number) return n; } catch (e) {}
    try { const c = window.Contacts && Contacts.name(number); if (c && c !== number) return c; } catch (e) {}
    return fb || number;
  }
  const fmtCount = n => { n = Math.max(0, Math.floor(+n || 0)); if (n < 1000) return String(n); if (n < 1e6) return (n / 1000).toFixed(n < 1e4 ? 1 : 0).replace('.', ',').replace(/,0$/, '') + ' mil'; return (n / 1e6).toFixed(1).replace('.', ',').replace(/,0$/, '') + ' M'; };
  const plural = (n, one, many) => `${fmtCount(n)} ${n === 1 ? one : many}`;
  const dayLabel = ts => { const d = new Date(+ts), n = new Date(); if (d.toDateString() === n.toDateString()) return 'Hoje'; const y = new Date(n); y.setDate(n.getDate() - 1); if (d.toDateString() === y.toDateString()) return 'Ontem'; return UI.fmtDate(d, true); };

  /* ---------- refresco por push (servidor) ----------
     As vistas abertas registam aqui a função de repintar e largam-na no onPop (setRoot/killApp chamam-no). */
  const live = new Set();
  const emitLive = (kind, data) => live.forEach(fn => { try { fn(kind, data); } catch (e) { console.error('[apex_phone] recado-updates', e); } });
  Bridge.on('recadoStatus', d => emitLive('status', d));
  Bridge.on('recadoChannel', d => emitLive('channel', d));
  Bridge.on('recadoCommunity', d => emitLive('community', d));
  Bridge.on('groupUpdate', d => emitLive('community', d));

  /* ============================================================
     MEDIA
     ============================================================ */
  const mcache = new Map();
  const remember = (id, p) => { mcache.delete(id); mcache.set(id, p); while (mcache.size > 24) mcache.delete(mcache.keys().next().value); return p; };
  function fetchMedia(id) {
    id = Math.floor(+id);
    if (!(id > 0)) return Promise.resolve(null);
    if (mcache.has(id)) return remember(id, mcache.get(id));
    const p = (async () => {
      let out = '', total = 1, head = null;
      for (let i = 1; i <= total && i <= 512; i++) {
        let r = await rpc('recado.social.media', { id, i });
        for (let k = 0; k < 3 && r && r.error === 'ratelimit'; k++) { await sleep(600 * (k + 1)); r = await rpc('recado.social.media', { id, i }); }
        if (!r || r.error || typeof r.data !== 'string') { out = ''; break; }
        if (!head) { head = r; total = Math.max(1, Math.floor(+r.total) || 1); }
        out += r.data;
        if (!r.data.length) break;
      }
      if (!out) {
        /* a media de uma mensagem que o media.get já autoriza (ex.: a minha própria, noutro ecrã) */
        if (window.VoiceMsg && VoiceMsg.fetchMedia) { const v = await VoiceMsg.fetchMedia(id); if (v && v.dataUrl) return { url: v.dataUrl, kind: v.kind, mime: v.mime, duration: v.duration, meta: v.meta }; }
        return null;
      }
      const mime = String(head.mime || '').slice(0, 60);
      return { url: /^data:/i.test(out) ? out : 'data:' + (mime || 'image/jpeg') + ';base64,' + out, kind: head.kind, mime, duration: +head.duration || 0, meta: head.meta || null };
    })().catch(() => null);
    remember(id, p);
    p.then(v => { if (!v && mcache.get(id) === p) mcache.delete(id); });
    return p;
  }
  const primeMedia = (id, url, kind, mime) => remember(Math.floor(+id), Promise.resolve({ url, kind, mime }));
  /* pinta a imagem por CSSOM (nunca dentro de uma string de HTML) */
  function paintMedia(el, id) {
    if (!el || !(+id > 0)) return;
    el.classList.add('rcu-loading');
    fetchMedia(id).then(m => { el.classList.remove('rcu-loading'); if (m && m.url && el.isConnected !== false) { el.style.backgroundImage = UI.img(m.url); el.classList.add('has-img'); } else el.classList.add('rcu-broken'); });
  }

  const imgCfg = () => { try { return VoiceMsg.util.cfg(); } catch (e) { return { maxImageBytes: 260000, maxSec: 60 }; } };
  async function uploadImage(url, onProgress) {
    if (!window.VoiceMsg || !VoiceMsg.uploadData) return { error: 'media' };
    const max = imgCfg().maxImageBytes;
    /* a lista branca do server/media.lua é jpeg/png/webp: outro formato ou acima do limite passa primeiro por JPEG */
    if (url.length > max || !/^data:image\/(jpeg|png|webp);base64,/i.test(url)) {
      let small = null; try { small = await Photos.shrink(url, 1280, 0, Math.max(20000, max - 2048)); } catch (e) { small = null; }
      if (!small || small === Photos.BLACK) return { error: 'media' };
      url = small;
    }
    const mime = ((/^data:(image\/[a-z0-9.+-]+);/i.exec(url) || [])[1] || 'image/jpeg').toLowerCase();
    const up = await VoiceMsg.uploadData(url, { kind: 'image', mime }, onProgress);
    if (!up || !up.mediaId) return { error: (up && up.error) || 'media' };
    primeMedia(up.mediaId, url, 'image', mime);
    return { mediaId: up.mediaId, url };
  }

  /* foto da galeria só com "seed" (gradiente antigo): desenha-se o gradiente num canvas para ter bytes a sério */
  function seedToDataUrl(seed) {
    try {
      seed = +seed || 1;
      const c = document.createElement('canvas'); c.width = 540; c.height = 960; const x = c.getContext('2d');
      const ang = ((seed * 37) % 360) * Math.PI / 180, cx = 270, cy = 480, r = 560;
      const gr = x.createLinearGradient(cx - Math.sin(ang) * r, cy + Math.cos(ang) * r, cx + Math.sin(ang) * r, cy - Math.cos(ang) * r);
      gr.addColorStop(0, `hsl(${(seed * 53) % 360},70%,58%)`); gr.addColorStop(1, `hsl(${(seed * 53 + 110) % 360},65%,32%)`);
      x.fillStyle = gr; x.fillRect(0, 0, 540, 960);
      return c.toDataURL('image/jpeg', .8);
    } catch (e) { return null; }
  }

  /* ---------- câmara (o mesmo visor da app Câmara, CamView) ---------- */
  function openCamera(win, title) {
    return new Promise(async done => {
      if (!window.CamView || typeof CamView.mount !== 'function') { UI.toast('Câmara indisponível'); done(null); return; }
      if (window.Perm && !(await Perm.request('recado', 'camera'))) { done(null); return; }
      const lay = UI.el(`<div class="rcu-cam"><div class="rcu-cam-view"></div><div class="rcu-cam-still"></div><div class="rcu-cam-top"><div class="rcu-cam-b x">${g('x', 22)}</div><div class="rcu-cam-ttl"></div><div class="rcu-cam-b fl off">${g('bolt', 22)}</div></div><div class="rcu-cam-bot"><div class="rcu-cam-retake">Repetir</div><div class="rcu-cam-shut"><div></div></div><div class="rcu-cam-use">${g('check')}</div><div class="rcu-cam-flip">${g('repeat', 22)}</div></div></div>`);
      lay.querySelector('.rcu-cam-ttl').textContent = title || 'Câmara';
      const view = lay.querySelector('.rcu-cam-view'), still = lay.querySelector('.rcu-cam-still');
      let cam = null, dead = false, raw = null, busy = false;
      /* ⚠️ sem o stopPropagation o system.js também ouve o Escape e fecha o TELEMÓVEL inteiro */
      const onKey = e => { if (dead || e.key !== 'Escape' || !winShown(win)) return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offs = [Bridge.on('app:close', id => { if (id === 'recado') close(null); }), Bridge.on('phone:close', () => close(null)), Bridge.on('app:kill', id => { if (id === 'recado') close(null); })];
      function close(v) { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offs.forEach(f => { try { f(); } catch (e) {} }); try { if (cam) cam.destroy(); } catch (e) {} lay.remove(); done(v); }
      document.addEventListener('keydown', onKey, true);
      win.appendChild(lay);
      try { cam = CamView.mount(view, { chrome: 'bare', aspect: (view.clientWidth || 440) / (view.clientHeight || 956), autoActivate: false, aimInside: true }); cam.setActive(true); }
      catch (e) { console.error('[apex_phone] CamView', e); close(null); UI.toast('Não foi possível abrir a câmara'); return; }
      requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); }); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 120);
      lay.querySelector('.x').onclick = () => close(null);
      lay.querySelector('.rcu-cam-flip').onclick = () => { if (!raw && cam) cam.flip(); };
      lay.querySelector('.fl').onclick = e => { if (!cam) return; cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };
      lay.querySelector('.rcu-cam-shut').onclick = async () => {
        if (busy || dead || raw || !cam) return; busy = true;
        let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
        busy = false; if (dead) return;
        if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não foi possível tirar a fotografia', 3000); return; }
        raw = r.raw; still.style.backgroundImage = UI.img(raw); lay.classList.add('shot'); cam.setActive(false);
      };
      lay.querySelector('.rcu-cam-retake').onclick = () => { if (dead || !cam) return; raw = null; still.style.backgroundImage = ''; lay.classList.remove('shot'); cam.setActive(true); };
      lay.querySelector('.rcu-cam-use').onclick = () => { if (raw && !dead) close(raw); };
    });
  }

  async function pickImage(win, title) {
    const how = await UI.actionSheet({ title, buttons: [{ label: 'Escolher da galeria', icon: 'photo', value: 'gal' }, { label: 'Tirar fotografia', icon: 'camera', value: 'cam' }] });
    if (how === 'cam') return openCamera(win, title);
    if (how !== 'gal') return null;
    if (!window.Photos || !Photos.pick) { UI.toast('Fotos indisponíveis'); return null; }
    const p = await Photos.pick(title); if (!p) return null;
    let url = null; try { url = await Photos.data(p, true); } catch (e) { url = null; }
    if (typeof url === 'string' && /^data:image\//i.test(url)) return url;
    if (p.seed != null) return seedToDataUrl(p.seed);
    UI.toast('Não foi possível ler a foto'); return null;
  }

  /* ---------- contactos (várias escolhas, com as já escolhidas marcadas) ---------- */
  async function pickContacts(title, selected, max) {
    try { if (window.Contacts && !Contacts.cache.length) await Contacts.load(); } catch (e) {}
    const list = ((window.Contacts && Contacts.cache) || []).filter(c => c && c.number && c.number !== me().number);
    return new Promise(res => {
      const sel = new Set((selected || []).map(String));
      const body = UI.el('<div class="rcu-pick"></div>');
      const count = UI.el('<div class="rcu-pick-n"></div>');
      const holder = UI.el('<div></div>');
      const s = UI.search('Pesquisar contactos', q => paint(q));
      body.append(s, count, holder);
      const paintCount = () => { count.textContent = sel.size ? `${sel.size} selecionado${sel.size === 1 ? '' : 's'}${max ? ' · máx. ' + max : ''}` : 'Ninguém selecionado'; };
      function paint(q) {
        holder.innerHTML = '';
        const l = list.filter(c => !q || c.name.toLowerCase().includes(q) || c.number.includes(q));
        if (!l.length) { holder.appendChild(UI.empty('person', 'Sem contactos', 'Adiciona contactos na app Telefone.')); return; }
        holder.appendChild(UI.list([{ items: l.map(c => ({ avatar: c, label: c.name, sub: c.number, chevron: false, check: sel.has(c.number),
          onCheck: on => { if (on) { if (max && sel.size >= max) { UI.toast(`No máximo ${max}`); paint(q); return; } sel.add(c.number); } else sel.delete(c.number); paintCount(); } })) }]));
      }
      let finished = false;
      const sh = UI.sheet({ title, left: 'Cancelar', right: 'OK', body, onDone: () => { finished = true; res([...sel]); }, onClose: () => { if (!finished) res(null); } });
      paintCount(); paint('');
      return sh;
    });
  }

  /* ---------- autocolantes (packs próprios do RD; sem o RD, o mesmo id com um emoji) ---------- */
  const STK_EMOJI = {
    basicos: { ola: '👋', obrigado: '🙏', ok: '👌', riso: '😂', triste: '😢', uau: '😮', amor: '😍', dormir: '😴', festa: '🥳', pensar: '🤔', zangado: '😠', fixe: '😎' },
    cidade: { por_do_sol: '🌇', palmeira: '🌴', taxi: '🚕', praia: '🏖️', skyline: '🏙️', sirene: '🚨', hamburguer: '🍔', cafe: '☕', dinheiro: '💸', roda_gigante: '🎡', semaforo: '🚦', los_santos: '🌆' },
    reacoes: { boa: '👍', lol: '🤣', nao: '🙅', sim: '✅', ups: '🙈', top: '🔝', obrigado: '💐', ja_volto: '⏳', fogo: '🔥', mais_um: '☝️', hein: '❓', coracao: '❤️' }
  };
  function renderSticker(el, pack, id) {
    el.innerHTML = ''; el.classList.add('rcu-stk');
    try { if (window.RecadoExtras && typeof RecadoExtras.render === 'function' && RecadoExtras.render({ type: 'sticker', content: '', payload: { pack, id } }, el) === true) return el; } catch (e) {}
    const e = (STK_EMOJI[pack] || {})[id] || '✨';
    el.appendChild(UI.el(`<span class="rcu-stk-emo">${esc(e)}</span>`));
    return el;
  }
  function pickSticker(win) {
    return new Promise(res => {
      let done = false; const fin = v => { if (done) return; done = true; res(v); };
      try {
        if (window.RecadoExtras && typeof RecadoExtras.stickerPicker === 'function') {
          const r = RecadoExtras.stickerPicker(win, s => fin(s && s.pack && s.id ? { pack: String(s.pack), id: String(s.id) } : null));
          if (r && typeof r.then === 'function') r.then(v => { if (v && v.pack) fin({ pack: String(v.pack), id: String(v.id) }); else setTimeout(() => fin(null), 50); });
          return;
        }
      } catch (e) { console.error('[apex_phone] stickerPicker', e); }
      const body = UI.el('<div class="rcu-stkgrid"></div>');
      Object.keys(STK_EMOJI).forEach(pack => {
        body.appendChild(UI.el(`<div class="rcu-stkgrid-h">${esc({ basicos: 'Básicos', cidade: 'Cidade', reacoes: 'Reações' }[pack])}</div>`));
        const grid = UI.el('<div class="rcu-stkgrid-g"></div>');
        Object.keys(STK_EMOJI[pack]).forEach(id => { const c = renderSticker(UI.el('<div class="rcu-stkgrid-c"></div>'), pack, id); c.onclick = () => { fin({ pack, id }); sh.close(); }; grid.appendChild(c); });
        body.appendChild(grid);
      });
      const sh = UI.sheet({ title: 'Autocolantes', right: 'Cancelar', body, onClose: () => fin(null) });
    });
  }

  /* ---------- avatares ---------- */
  const seedOf = s => [...String(s || '?')].reduce((h, ch) => (h * 31 + ch.charCodeAt(0)) % 997, 7);
  /* o: { number?, conversation?, mediaId?, name?, square? } - número → o avatar do Recado (RA); imagem de canal/comunidade → a nossa media */
  function avatarEl(o, cls) {
    const el = UI.el(`<div class="rcu-av ${o.square ? 'sq' : ''} ${cls || ''}"></div>`);
    let done = false;
    if (!o.mediaId && (o.number || o.conversation) && R() && typeof R().avatar === 'function') {
      try { R().avatar(el, { number: o.number, conversation: o.conversation, name: o.name }); done = el.childNodes.length > 0 || !!el.style.backgroundImage; } catch (e) { done = false; }
    }
    if (!done) {
      const name = o.name || (o.number ? nameOf(o.number) : '?');
      el.textContent = /^[\d\s+\-().]+$/.test(name) ? '' : UI.initials(name);
      if (!el.textContent) el.innerHTML = g('person');
      const [a, b] = ['#128C7E,#25D366', '#22C55E,#0EA5E9', '#0F9D6B,#128C7E', '#7C3AED,#25D366', '#2563EB,#14B8A6'][seedOf(o.number || name) % 5].split(',');
      /* backgroundImage e não o atalho `background`: o atalho repõe background-size a auto e a foto por cima ficava cortada ao canto */
      el.style.backgroundImage = `linear-gradient(150deg,${a},${b})`;
      if (o.mediaId) paintMedia(el, o.mediaId);
    }
    return el;
  }

  /* ---------- leitor de áudio compacto (estados e canais) ----------
     O VoiceMsg.player desce a media pelo media.get, que não autoriza estes ecrãs: este usa o fetchMedia acima.
     Progresso SÓ por transform (camada das barras cheias desliza, o conteúdo dela desliza ao contrário). */
  let activeAudio = null;
  const placeholderWave = seed => { let s = (Math.floor(+seed) || 7) >>> 0; return Array.from({ length: 36 }, () => { s = (Math.imul(s, 1103515245) + 12345) >>> 0; return .18 + ((s >>> 16) % 100) / 100 * .6; }); };
  function audioPlayer(mediaId, duration, wave, opts = {}) {
    const w = (Array.isArray(wave) && wave.length ? wave : placeholderWave(mediaId)).slice(0, 40).map(v => clamp(+v || 0, .1, 1));
    const bars = w.map(v => `<i style="transform:scaleY(${v.toFixed(2)})"></i>`).join('');
    const el = UI.el(`<div class="rcu-ap ${opts.cls || ''}"><div class="rcu-ap-btn">${g('play')}${g('pause')}<span class="rcu-spin"></span></div><div class="rcu-ap-w"><div class="rcu-ap-bars">${bars}</div><div class="rcu-ap-rev"><div class="rcu-ap-bars">${bars}</div></div></div><span class="rcu-ap-t"></span></div>`);
    const rev = el.querySelector('.rcu-ap-rev'), revIn = rev.firstElementChild, tEl = el.querySelector('.rcu-ap-t');
    let audio = null, url = null, raf = 0, dur = Math.max(0, +duration || 0), loading = null;
    const setProg = f => { const pct = ((1 - clamp(f, 0, 1)) * 100).toFixed(2); rev.style.transform = `translateX(-${pct}%)`; revIn.style.transform = `translateX(${pct}%)`; };
    const fmt = ms => UI.fmtDur(Math.max(0, ms) / 1000);
    tEl.textContent = fmt(dur);
    const tick = () => { raf = 0; if (!audio) return; const d = isFinite(audio.duration) && audio.duration > 0 ? audio.duration * 1000 : dur; const t = audio.currentTime * 1000; setProg(d ? t / d : 0); tEl.textContent = fmt(audio.paused && t < 50 ? d : t); if (opts.onTime) opts.onTime(t, d, !audio.paused); if (!el.isConnected) { api.pause(); return; } if (!audio.paused) raf = requestAnimationFrame(tick); };
    function ensure() {
      if (audio) return Promise.resolve(true);
      if (loading) return loading;
      el.classList.add('is-loading');
      loading = fetchMedia(mediaId).then(m => {
        el.classList.remove('is-loading'); loading = null;
        if (!m || !m.url) { el.classList.add('is-error'); tEl.textContent = 'Indisponível'; return false; }
        try { const b = VoiceMsg.util.dataUrlToBlob(m.url); url = URL.createObjectURL(b); } catch (e) { url = m.url; }
        audio = new Audio(url); audio.preload = 'auto';
        audio.addEventListener('playing', () => { el.classList.add('is-playing'); if (!raf) raf = requestAnimationFrame(tick); });
        audio.addEventListener('pause', () => { el.classList.remove('is-playing'); tick(); });
        audio.addEventListener('ended', () => { el.classList.remove('is-playing'); setProg(1); if (opts.onEnd) opts.onEnd(); });
        if (!dur && m.duration) { dur = m.duration; tEl.textContent = fmt(dur); }
        return true;
      });
      return loading;
    }
    const api = {
      el,
      async play() { if (activeAudio && activeAudio !== api) activeAudio.pause(); activeAudio = api; if (!(await ensure()) || activeAudio !== api) return false; try { audio.volume = clamp((+((window.System && System.state) || {}).volume || 60) / 100, 0, 1); await audio.play(); return true; } catch (e) { return false; } },
      pause() { if (audio && !audio.paused) audio.pause(); if (activeAudio === api) activeAudio = null; },
      toggle() { if (audio && !audio.paused) api.pause(); else api.play(); },
      release() { api.pause(); if (raf) cancelAnimationFrame(raf); raf = 0; if (audio) { try { audio.removeAttribute('src'); audio.load(); } catch (e) {} audio = null; } if (url && url.startsWith('blob:')) URL.revokeObjectURL(url); url = null; },
      get playing() { return !!(audio && !audio.paused); }
    };
    el.querySelector('.rcu-ap-btn').onclick = e => { e.stopPropagation(); api.toggle(); };
    el.addEventListener('pointerdown', e => e.stopPropagation());
    setProg(0); el.rcuAudio = api;
    return api;
  }
  Bridge.on('phone:close', () => { if (activeAudio) activeAudio.pause(); });
  Bridge.on('incomingCall', () => { if (activeAudio) activeAudio.pause(); });

  /* ============================================================
     ATUALIZAÇÕES - lista
     ============================================================ */
  /* chaves iguais às do servidor (STATUS_BG / STATUS_FONT); as cores vivem no CSS (.rcu-bg-*) */
  const BGS = ['indigo', 'aurora', 'ciano', 'oceano', 'menta', 'ambar', 'coral', 'rosa', 'ameixa', 'grafite'];
  const FONTS = ['sans', 'serif', 'round', 'bold', 'mono'];
  const PRIV_LABEL = { contacts: 'Os meus contactos', except: 'Os meus contactos, exceto…', only: 'Partilhar só com…' };
  const cache = { status: null, prefs: { privacy: 'contacts', audience: [] } };

  const textSize = t => { const n = [...String(t || '')].length; return n < 30 ? 'xl' : n < 90 ? 'lg' : n < 220 ? 'md' : 'sm'; };
  /* miniatura de um estado (cartões e cabeçalho da lista) */
  function statusThumb(el, it) {
    el.innerHTML = ''; el.className = el.className.replace(/\brcu-bg-\S+/g, '').trim();
    if (!it) return el;
    if (it.kind === 'image') { paintMedia(el, it.mediaId); return el; }
    el.classList.add('rcu-bg-' + (BGS.includes(it.bg) ? it.bg : (it.kind === 'text' ? 'indigo' : 'grafite')));
    if (it.kind === 'text') { const t = UI.el(`<div class="rcu-thumb-t rcu-f-${FONTS.includes(it.font) ? it.font : 'sans'}"></div>`); t.textContent = String(it.content || '').slice(0, 90); el.appendChild(t); }
    else if (it.kind === 'audio') el.appendChild(UI.el(`<div class="rcu-thumb-i">${g('mic')}</div>`));
    else if (it.kind === 'sticker') { const [p, s] = String(it.content || '').split(':'); el.appendChild(renderSticker(UI.el('<div class="rcu-thumb-s"></div>'), p, s)); }
    return el;
  }
  function ring(o, seen, cls) {
    const r = UI.el(`<div class="rcu-ring ${seen ? 'seen' : ''} ${cls || ''}"><div class="rcu-ring-in"></div></div>`);
    r.firstElementChild.appendChild(avatarEl(o));
    return r;
  }

  function updatesView(win) {
    const st = { dead: false, showMuted: false, t: null, data: null, channels: [], suggest: [] };
    const v = UI.view({ title: 'Atualizações', large: true, cls: 'rcu-root',
      right: [{ icon: 'camera', onTap: () => statusComposer(win, { mode: 'photo' }) }, { icon: 'pen', onTap: () => statusComposer(win, { mode: 'text' }) }],
      onPop: () => { st.dead = true; live.delete(refresh); clearTimeout(st.t); } });
    const body = UI.el('<div class="rcu-body"></div>');
    v.content.appendChild(body);
    body.appendChild(UI.skeleton('list', 5));
    const refresh = (kind, d) => { if (st.dead || (kind !== 'status' && kind !== 'channel')) return; clearTimeout(st.t); st.t = setTimeout(load, 350); };
    live.add(refresh);
    v.rcuRefresh = () => load();

    async function load() {
      const [s, fol, mine, dir] = await Promise.all([rpc('recado.status.list'), rpc('recado.channel.list', { scope: 'following' }), rpc('recado.channel.list', { scope: 'mine' }), rpc('recado.channel.list', { scope: 'directory' })]);
      if (st.dead) return;
      st.err = bad(s) ? s : null;
      st.data = bad(s) ? null : s;
      if (st.data) { cache.status = st.data; if (st.data.mine && st.data.mine.prefs) cache.prefs = { privacy: st.data.mine.prefs.privacy || 'contacts', audience: toArr(st.data.mine.prefs.audience).length ? st.data.mine.prefs.audience : [] }; }
      const seen = new Set(), chans = [];
      toArr(mine).concat(toArr(fol)).forEach(c => { if (c && c.id && !seen.has(c.id)) { seen.add(c.id); chans.push(c); } });
      chans.sort((a, b) => ((b.last && b.last.created) || b.lastPost || 0) - ((a.last && a.last.created) || a.lastPost || 0));
      st.channels = chans;
      st.suggest = toArr(dir).filter(c => !seen.has(c.id)).slice(0, 8);
      paint();
    }

    function paint() {
      const top = v.content.scrollTop;
      body.innerHTML = '';
      body.appendChild(statusSection());
      body.appendChild(channelsSection());
      v.content.scrollTop = top;
    }

    function statusSection() {
      const sec = UI.el(`<section class="rcu-sec"><div class="rcu-sec-h"><h3>Estado</h3><div class="rcu-iconbtn">${g('more')}</div></div></section>`);
      sec.querySelector('.rcu-iconbtn').onclick = e => UI.ctxMenu(e.currentTarget, [
        { label: 'Privacidade do estado', icon: 'lock', onTap: () => privacySheet(cache.prefs).then(p => { if (p) { cache.prefs = p; UI.toast('Aplica-se às próximas atualizações'); } }) },
        { label: 'Criar estado de texto', icon: 'pen', onTap: () => statusComposer(win, { mode: 'text' }) }]);
      if (st.err && !st.data) { sec.appendChild(UI.el(`<div class="rcu-note err">${esc(errText(st.err, 'Não foi possível carregar as atualizações.'))}</div>`)); return sec; }
      const data = st.data || { mine: { items: [] }, updates: [] };
      const mineItems = toArr(data.mine && data.mine.items), ups = toArr(data.updates).map(u => Object.assign(u, { items: toArr(u.items) })).filter(u => u.items.length);
      const my = me();
      const last = mineItems[mineItems.length - 1];
      const views = mineItems.reduce((a, x) => a + (+x.views || 0), 0);
      const row = UI.el(`<div class="rcu-me"><div class="rcu-me-av"></div><div class="rcu-me-t"><b>O meu estado</b><span></span></div><div class="rcu-me-b cam">${g('camera')}</div><div class="rcu-me-b pen">${g('pen')}</div></div>`);
      const avHost = row.querySelector('.rcu-me-av');
      if (mineItems.length) { const th = statusThumb(UI.el('<div class="rcu-me-thumb"></div>'), last); const r = UI.el('<div class="rcu-ring"><div class="rcu-ring-in"></div></div>'); r.firstElementChild.appendChild(th); avHost.appendChild(r); }
      else { avHost.appendChild(avatarEl({ number: my.number, name: my.name })); avHost.appendChild(UI.el(`<div class="rcu-plus">${g('plus')}</div>`)); }
      row.querySelector('span').textContent = mineItems.length ? `${UI.timeAgo(last.created)} · ${plural(views, 'visualização', 'visualizações')}` : `Partilha uma atualização · ${Math.floor(+data.hours) || 24} h`;   /* as horas vêm do servidor (Config.Recado.statusHours) */
      row.onclick = e => { if (e.target.closest('.rcu-me-b')) return; if (mineItems.length) openStatus(win, my.number, { data, onClose: load }); else statusComposer(win, { mode: 'text' }); };
      row.querySelector('.cam').onclick = () => statusComposer(win, { mode: 'photo' });
      row.querySelector('.pen').onclick = () => statusComposer(win, { mode: 'text' });
      sec.appendChild(row);

      const recent = ups.filter(u => !u.allSeen && !u.muted), seenL = ups.filter(u => u.allSeen && !u.muted), muted = ups.filter(u => u.muted);
      const order = recent.concat(seenL);
      const strip = (title, list, seenFlag, pool) => {
        const wrap = UI.el(`<div class="rcu-strip-w"><div class="rcu-strip-h">${esc(title)}</div><div class="rcu-strip"></div></div>`);
        const s = wrap.querySelector('.rcu-strip');
        list.forEach(u => {
          const it = u.items[u.items.length - 1];
          const card = UI.el(`<div class="rcu-card ${seenFlag ? 'seen' : ''}"><div class="rcu-card-bg"></div><div class="rcu-card-shade"></div><div class="rcu-card-av"></div><div class="rcu-card-n"></div>${u.items.some(x => x.mentionedMe) ? `<div class="rcu-card-at">${g('at')}</div>` : ''}</div>`);
          statusThumb(card.querySelector('.rcu-card-bg'), it);
          card.querySelector('.rcu-card-av').appendChild(ring({ number: u.number, name: u.name }, seenFlag, 'sm'));
          card.querySelector('.rcu-card-n').textContent = nameOf(u.number, u.name || u.number);
          card.onclick = () => openStatus(win, u.number, { data, list: pool, onClose: load });
          UI.longPress(card, () => muteOwner(u, load));
          s.appendChild(card);
        });
        return wrap;
      };
      if (recent.length) sec.appendChild(strip('Recentes', recent, false, order));
      if (seenL.length) sec.appendChild(strip('Vistas', seenL, true, order));
      if (!recent.length && !seenL.length) sec.appendChild(UI.el('<div class="rcu-note">Quando os teus contactos partilharem atualizações, aparecem aqui. Só vês as de quem também te tem nos contactos.</div>'));
      if (muted.length) {
        const m = UI.el(`<div class="rcu-muted-t"><span>Silenciadas (${muted.length})</span>${g(st.showMuted ? 'chevU' : 'chevD')}</div>`);
        m.onclick = () => { st.showMuted = !st.showMuted; paint(); };
        sec.appendChild(m);
        if (st.showMuted) sec.appendChild(strip('', muted, true, muted));
      }
      return sec;
    }

    function channelsSection() {
      const sec = UI.el(`<section class="rcu-sec"><div class="rcu-sec-h"><h3>Canais</h3><div class="rcu-link">Explorar</div></div></section>`);
      sec.querySelector('.rcu-link').onclick = () => channelDirectory(win);
      if (st.channels.length) {
        const list = UI.el('<div class="rcu-chlist"></div>');
        st.channels.forEach(c => list.appendChild(channelRow(c, () => openChannel(win, c.id))));
        sec.appendChild(list);
      } else {
        sec.appendChild(UI.el('<div class="rcu-note">Segue canais para receberes novidades de quem te interessa. Só os administradores publicam; ninguém vê quem segue.</div>'));
      }
      if (st.suggest.length) {
        const w = UI.el('<div class="rcu-strip-w"><div class="rcu-strip-h">Encontrar canais</div><div class="rcu-strip rcu-sug"></div></div>');
        const s = w.querySelector('.rcu-strip');
        st.suggest.forEach(c => s.appendChild(suggestCard(win, c, load)));
        sec.appendChild(w);
      }
      const acts = UI.el(`<div class="rcu-acts"><div class="rcu-act create">${g('plus')}<span>Criar canal</span></div><div class="rcu-act code">${g('link')}<span>Entrar com código</span></div></div>`);
      acts.querySelector('.create').onclick = () => channelForm(win, null);
      acts.querySelector('.code').onclick = () => joinByCode(win);
      sec.appendChild(acts);
      return sec;
    }

    load();
    return v;
  }

  async function muteOwner(u, after) {
    const on = !u.muted;
    const ok = await UI.confirm(on ? `Silenciar ${nameOf(u.number, u.name)}?` : `Deixar de silenciar ${nameOf(u.number, u.name)}?`, on ? 'As atualizações passam para "Silenciadas" e deixam de aparecer em Recentes.' : 'As atualizações voltam a aparecer em Recentes.', on ? 'Silenciar' : 'Mostrar');
    if (!ok) return;
    const r = await rpc('recado.status.mute', { number: u.number, on });
    if (bad(r)) { UI.toast(errText(r)); return; }
    if (after) after();
  }

  function channelRow(c, onTap) {
    const row = UI.el(`<div class="rcu-chrow"><div class="rcu-chrow-av"></div><div class="rcu-chrow-b"><div class="rcu-chrow-n"><b></b></div><div class="rcu-chrow-p"></div></div><div class="rcu-chrow-r"><span class="t"></span></div></div>`);
    row.querySelector('.rcu-chrow-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name }));
    row.querySelector('b').textContent = c.name;
    if (c.verified) row.querySelector('.rcu-chrow-n').appendChild(UI.el(`<span class="rcu-verif">${g('check', 10)}</span>`));
    if (c.myRole) row.querySelector('.rcu-chrow-n').appendChild(UI.el('<span class="rcu-tag">Admin</span>'));
    const l = c.last;
    row.querySelector('.rcu-chrow-p').textContent = l ? ({ image: '📷 ' + (l.preview || 'Foto'), audio: '🎤 Mensagem de voz', sticker: '✨ Autocolante', poll: '📊 ' + (l.preview || 'Sondagem') }[l.type] || l.preview || '') : plural(c.followers, 'seguidor', 'seguidores');
    row.querySelector('.t').textContent = l && l.created ? UI.rel(l.created) : '';
    if (c.unread > 0) row.querySelector('.rcu-chrow-r').appendChild(UI.el(`<span class="rcu-badge">${c.unread > 99 ? '99+' : c.unread}</span>`));
    if (c.following && !c.muted) row.querySelector('.rcu-chrow-r').appendChild(UI.el(`<span class="rcu-bell">${g('bell', 12)}</span>`));
    row.onclick = onTap;
    return row;
  }

  function suggestCard(win, c, after) {
    /* o nome vai num span próprio: o <b> é flex (para o visto ficar ao lado) e num contentor flex o
       text-overflow:ellipsis não se aplica - sem o span o nome era cortado a meio dos dois lados */
    const card = UI.el(`<div class="rcu-sgc"><div class="rcu-sgc-av"></div><b><span class="rcu-sgc-nm"></span></b><span></span><div class="rcu-btn sm">Seguir</div></div>`);
    card.querySelector('.rcu-sgc-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name }));
    card.querySelector('.rcu-sgc-nm').textContent = c.name;
    /* o span do subtítulo é o irmão do <b>, não o do visto que fica DENTRO dele: sem o ':scope >' o
       querySelector apanhava o .rcu-verif e trocava o SVG do visto pelo texto dos seguidores */
    card.querySelector(':scope > span').textContent = plural(c.followers, 'seguidor', 'seguidores');
    if (c.verified) card.querySelector('b').appendChild(UI.el(`<span class="rcu-verif">${g('check', 10)}</span>`));
    const btn = card.querySelector('.rcu-btn');
    btn.onclick = async e => { e.stopPropagation(); if (btn.classList.contains('busy')) return; btn.classList.add('busy'); const r = await rpc('recado.channel.follow', { id: c.id }); btn.classList.remove('busy'); if (bad(r)) { UI.toast(errText(r)); return; } btn.textContent = 'A seguir'; btn.classList.add('on'); UI.toast(`Estás a seguir ${c.name}`); if (after) setTimeout(after, 500); };
    card.onclick = () => openChannel(win, c.id);
    return card;
  }

  /* ============================================================
     VISUALIZADOR DE ESTADOS (ecrã inteiro)
     Tocar à esquerda/direita: anterior/seguinte · segurar: pausa · arrastar para baixo: fechar.
     ============================================================ */
  let openViewer = null;
  async function openStatus(win, owner, opts = {}) {
    if (!win) win = R() && R().win;
    if (!win) return null;
    if (openViewer) openViewer.close();
    let data = opts.data || null;
    if (!data) { const r = await rpc('recado.status.list'); if (bad(r)) { UI.toast(errText(r)); return null; } data = r; cache.status = r; }
    const my = me();
    let groups;
    if (owner === my.number) groups = [{ number: my.number, name: 'O meu estado', items: toArr(data.mine && data.mine.items), mine: true }];
    else groups = (opts.list || toArr(data.updates)).map(u => Object.assign({}, u, { items: toArr(u.items) })).filter(u => u.items.length);
    /* dono sem estados visíveis (expirou, foi apagado, ou chegou por uma notificação antiga): avisa em vez de abrir
       o PRIMEIRO da lista - antes o findIndex dava -1, o max(0) fazia dele 0 e abria os estados de outra pessoa */
    let gi = owner == null ? 0 : groups.findIndex(u => String(u.number) === String(owner));
    if (gi < 0 || !groups[gi] || !groups[gi].items.length) { UI.toast(owner === my.number ? 'Ainda não partilhaste nenhuma atualização' : 'Esta atualização já não está disponível'); return null; }
    let ii = opts.mine || groups[gi].mine ? 0 : Math.max(0, groups[gi].items.findIndex(x => !x.viewed));

    const lay = UI.el(`<div class="rcu-viewer">
      <div class="rcu-v-stage"></div>
      <div class="rcu-v-top"><div class="rcu-v-bars"></div>
        <div class="rcu-v-head"><div class="rcu-v-x">${g('chevL', 26)}</div><div class="rcu-v-av"></div><div class="rcu-v-who"><b></b><span></span></div><div class="rcu-v-more">${g('more', 24)}</div></div></div>
      <div class="rcu-v-cap"></div>
      <div class="rcu-v-foot"></div>
      <div class="rcu-v-pause">${g('pause', 34)}</div>
    </div>`);
    const $ = s => lay.querySelector(s);
    const stage = $('.rcu-v-stage'), barsEl = $('.rcu-v-bars'), foot = $('.rcu-v-foot'), cap = $('.rcu-v-cap');
    let dead = false, raf = 0, dur = 5000, elapsed = 0, lastT = 0, player = null, fills = [];
    const pauses = new Set();
    const paused = () => pauses.size > 0;
    const setPause = (why, on) => { if (on) pauses.add(why); else pauses.delete(why); lay.classList.toggle('is-paused', pauses.has('hold')); if (player) { if (paused()) player.pause(); else if (player.wantPlay) player.play(); } };

    function close() {
      if (dead) return; dead = true;
      cancelAnimationFrame(raf); if (player) player.release();
      document.removeEventListener('keydown', onKey, true); offs.forEach(f => { try { f(); } catch (e) {} });
      if (openViewer === api) openViewer = null;
      lay.classList.remove('in'); setTimeout(() => lay.remove(), 260);
      if (opts.onClose) { try { opts.onClose(); } catch (e) {} }
    }
    const onKey = e => { if (dead || e.key !== 'Escape' || !winShown(win)) return; if (document.activeElement && document.activeElement.closest && document.activeElement.closest('.rcu-v-foot')) { document.activeElement.blur(); } e.preventDefault(); e.stopPropagation(); close(); };
    const offs = [Bridge.on('app:close', id => { if (id === 'recado') setPause('app', true); }), Bridge.on('app:open', id => { if (id === 'recado') setPause('app', false); }),
      Bridge.on('phone:close', () => setPause('app', true)), Bridge.on('app:kill', id => { if (id === 'recado') close(); })];
    document.addEventListener('keydown', onKey, true);

    function frame(t) {
      raf = 0; if (dead) return;
      const dt = lastT ? Math.min(100, t - lastT) : 0; lastT = t;
      if (!paused()) {
        if (player && player.el.classList.contains('is-playing')) { /* áudio: o tempo é o do próprio áudio (onTime) */ }
        else elapsed += dt;
      }
      const f = fills[ii]; if (f) f.style.transform = `scaleX(${clamp(elapsed / dur, 0, 1).toFixed(4)})`;
      if (elapsed >= dur) { next(); return; }
      raf = requestAnimationFrame(frame);
    }
    const loop = () => { if (!raf && !dead) { lastT = 0; raf = requestAnimationFrame(frame); } };

    function show() {
      const grp = groups[gi], it = grp.items[ii];
      if (player) { player.release(); player = null; }
      elapsed = 0;
      barsEl.innerHTML = ''; fills = grp.items.map((x, k) => { const b = UI.el('<div class="rcu-v-bar"><i></i></div>'); barsEl.appendChild(b); const i = b.firstElementChild; i.style.transform = `scaleX(${k < ii ? 1 : 0})`; return i; });
      const av = $('.rcu-v-av'); av.innerHTML = ''; av.appendChild(avatarEl(grp.mine ? { number: grp.number, name: my.name } : { number: grp.number, name: grp.name }));
      $('.rcu-v-who b').textContent = grp.mine ? 'O meu estado' : nameOf(grp.number, grp.name || grp.number);
      $('.rcu-v-who span').textContent = UI.timeAgo(it.created) + (it.reshareOf ? ' · repartilhado' : '');
      stage.innerHTML = ''; stage.className = 'rcu-v-stage'; stage.style.backgroundImage = ''; cap.textContent = ''; cap.classList.toggle('on', false);
      if (it.kind === 'text') {
        stage.classList.add('rcu-bg-' + (BGS.includes(it.bg) ? it.bg : 'indigo'));
        const t = UI.el(`<div class="rcu-v-text rcu-f-${FONTS.includes(it.font) ? it.font : 'sans'} s-${textSize(it.content)}"></div>`); t.textContent = it.content || ''; stage.appendChild(t);
        dur = 5000 + Math.min(4000, [...String(it.content || '')].length * 35);
      } else if (it.kind === 'image') {
        stage.classList.add('is-img');
        const img = UI.el('<div class="rcu-v-img"></div>'); stage.appendChild(img); paintMedia(img, it.mediaId);
        if (it.content) { cap.textContent = it.content; cap.classList.add('on'); }
        dur = 6500;
      } else if (it.kind === 'audio') {
        stage.classList.add('rcu-bg-' + (BGS.includes(it.bg) ? it.bg : 'grafite'), 'is-audio');
        const box = UI.el(`<div class="rcu-v-audio"><div class="rcu-v-mic">${g('mic', 44)}</div></div>`); stage.appendChild(box);
        dur = clamp(+it.duration || 8000, 2000, 65000) + 400;
        player = audioPlayer(it.mediaId, it.duration, null, { cls: 'big', onTime: (t, d) => { if (d > 0) { dur = d + 400; elapsed = t; } }, onEnd: () => { elapsed = dur; } });
        player.wantPlay = true;
        box.appendChild(player.el);
        player.play().then(ok => { if (!ok && !dead) { player.wantPlay = false; UI.toast('Toca no ▶ para ouvir'); } });
        if (it.content) { cap.textContent = it.content; cap.classList.add('on'); }
      } else {
        stage.classList.add('rcu-bg-' + (BGS.includes(it.bg) ? it.bg : 'grafite'));
        const [p, s] = String(it.content || '').split(':');
        stage.appendChild(renderSticker(UI.el('<div class="rcu-v-stk"></div>'), p, s));
        dur = 4500;
      }
      paintFoot(grp, it);
      if (!grp.mine && !it.viewed) { it.viewed = true; rpc('recado.status.view', { id: it.id }); if (grp.items.every(x => x.viewed)) grp.allSeen = true; }
      loop();
    }

    function paintFoot(grp, it) {
      foot.innerHTML = '';
      if (grp.mine) {
        const b = UI.el(`<div class="rcu-v-views">${g('eye', 22)}<span>${esc(plural(+it.views || 0, 'visualização', 'visualizações'))}${it.likes ? ' · ♥ ' + fmtCount(it.likes) : ''}</span>${g('chevU', 16)}</div>`);
        b.onclick = () => viewersSheet(it);
        foot.appendChild(b);
        return;
      }
      const f = UI.el(`<div class="rcu-v-reply"><input type="text" maxlength="1000" placeholder="Responder…"><div class="rcu-v-send">${g('send', 22)}</div><div class="rcu-v-like ${it.liked ? 'on' : ''}">${g(it.liked ? 'heartFill' : 'heart', 26)}</div></div>`);
      const inp = f.querySelector('input'), like = f.querySelector('.rcu-v-like'), send = f.querySelector('.rcu-v-send');
      inp.addEventListener('focus', () => { setPause('input', true); f.classList.add('typing'); });
      inp.addEventListener('blur', () => { if (!inp.value.trim()) { setPause('input', false); f.classList.remove('typing'); } });
      inp.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); send.click(); } });
      send.onclick = async () => {
        const text = inp.value.trim(); if (!text || send.classList.contains('busy')) return;
        send.classList.add('busy');
        const r = await rpc('recado.status.reply', { id: it.id, text });
        send.classList.remove('busy');
        if (bad(r)) { UI.toast(errText(r, 'A resposta não foi enviada')); return; }
        inp.value = ''; inp.blur(); f.classList.remove('typing'); setPause('input', false);
        UI.toast(`Resposta enviada a ${nameOf(grp.number, grp.name)}`);
      };
      like.onclick = async () => {
        const on = !it.liked; it.liked = on; like.classList.toggle('on', on); like.innerHTML = g(on ? 'heartFill' : 'heart', 26);
        if (on) { like.classList.remove('pop'); void like.offsetWidth; like.classList.add('pop'); }
        const r = await rpc('recado.status.like', { id: it.id, on });
        if (bad(r)) { it.liked = !on; like.classList.toggle('on', !on); like.innerHTML = g(!on ? 'heartFill' : 'heart', 26); UI.toast(errText(r)); }
      };
      foot.appendChild(f);
      if (it.mentionedMe) {
        const rs = UI.el(`<div class="rcu-v-reshare">${g('at', 16)}<span>Mencionou-te · Repartilhar</span></div>`);
        rs.onclick = async () => { rs.classList.add('busy'); const r = await rpc('recado.status.reshare', { id: it.id }); rs.classList.remove('busy'); if (bad(r)) { UI.toast(r && r.error === 'already' ? 'Já repartilhaste esta atualização' : errText(r)); return; } UI.toast('Repartilhado no teu estado'); emitLive('status', { action: 'add' }); };
        foot.insertBefore(rs, foot.firstChild);
      }
    }

    async function viewersSheet(it) {
      setPause('sheet', true);
      const body = UI.el('<div class="rcu-viewers"></div>'); body.appendChild(UI.skeleton('list', 3));
      const sh = UI.sheet({ title: 'Visualizações', right: 'OK', body, onClose: () => setPause('sheet', false) });
      const r = await rpc('recado.status.viewers', { id: it.id });
      body.innerHTML = '';
      if (bad(r)) { body.appendChild(UI.empty('eye', 'Indisponível', errText(r))); return sh; }
      const items = toArr(r.items);
      body.appendChild(UI.el(`<div class="rcu-viewers-h">${esc(plural(items.length, 'visualização', 'visualizações'))}${r.likes ? ' · ' + esc(plural(r.likes, 'gosto', 'gostos')) : ''}</div>`));
      if (!items.length) { body.appendChild(UI.empty('eye', 'Ainda ninguém viu', 'As visualizações aparecem aqui.')); return sh; }
      body.appendChild(UI.list([{ items: items.map(x => ({ label: nameOf(x.number, x.name || x.number), sub: x.at ? UI.timeAgo(x.at) : '', chevron: false, right: x.liked ? `<div class="rcu-liked">${g('heartFill', 18)}</div>` : undefined, icon: '<span></span>', iconBg: 'transparent' })) }]));
      body.querySelectorAll('.li').forEach((li, k) => { const ic = li.querySelector('.li-icon'); if (ic) { ic.innerHTML = ''; ic.appendChild(avatarEl({ number: items[k].number, name: items[k].name })); ic.classList.add('rcu-li-av'); } });
      return sh;
    }

    function next() { const grp = groups[gi]; if (fills[ii]) fills[ii].style.transform = 'scaleX(1)'; if (ii < grp.items.length - 1) { ii++; show(); return; } if (gi < groups.length - 1) { gi++; ii = Math.max(0, groups[gi].items.findIndex(x => !x.viewed)); show(); return; } close(); }
    function prev() { if (ii > 0) { ii--; show(); return; } if (gi > 0) { gi--; ii = 0; show(); return; } elapsed = 0; show(); }

    /* gestos: tocar (anterior/seguinte), segurar (pausa), arrastar para baixo (fechar). Só transform no arrasto. */
    let ps = null;
    lay.addEventListener('pointerdown', e => {
      if (e.target.closest('.rcu-v-foot, .rcu-v-head, .rcu-ap')) return;
      if (document.activeElement && document.activeElement.tagName === 'INPUT') { document.activeElement.blur(); return; }
      ps = { x: e.clientX, y: e.clientY, t: performance.now(), held: false, dy: 0 };
      ps.timer = setTimeout(() => { if (ps) { ps.held = true; setPause('hold', true); } }, 200);
      try { lay.setPointerCapture(e.pointerId); } catch (x) {}
    });
    lay.addEventListener('pointermove', e => { if (!ps) return; const z = UI.zoom(); ps.dy = (e.clientY - ps.y) / z; if (ps.dy > 12) { clearTimeout(ps.timer); if (!ps.held) { ps.held = true; setPause('hold', true); } lay.style.transition = 'none'; lay.style.transform = `translateY(${ps.dy.toFixed(1)}px) scale(${(1 - Math.min(.12, ps.dy / 2500)).toFixed(4)})`; } });
    const up = e => {
      if (!ps) return; const p = ps; ps = null; clearTimeout(p.timer);
      lay.style.transition = ''; lay.style.transform = '';
      if (p.dy > 130) { close(); return; }
      if (p.held) { setPause('hold', false); return; }
      if (e.type === 'pointercancel') return;
      const r = lay.getBoundingClientRect();
      if (e.clientX - r.left < r.width * .33) prev(); else next();
    };
    lay.addEventListener('pointerup', up); lay.addEventListener('pointercancel', up);
    $('.rcu-v-x').onclick = close;
    $('.rcu-v-more').onclick = async () => {
      const grp = groups[gi], it = grp.items[ii];
      setPause('menu', true);
      const buttons = grp.mine ? [{ label: 'Ver visualizações', value: 'views' }, { label: 'Apagar atualização', danger: true, value: 'del' }]
        : [{ label: 'Abrir conversa', value: 'chat' }, { label: grp.muted ? 'Deixar de silenciar' : 'Silenciar atualizações', value: 'mute' }];
      const a = await UI.actionSheet({ title: grp.mine ? 'O meu estado' : nameOf(grp.number, grp.name), buttons });
      setPause('menu', false);
      if (a === 'views') viewersSheet(it);
      if (a === 'chat') { close(); if (R() && R().openChat) R().openChat({ number: grp.number }); }
      if (a === 'mute') { close(); muteOwner(grp, () => emitLive('status', {})); }
      if (a === 'del') {
        setPause('menu', true);
        const ok = await UI.confirm('Apagar esta atualização?', 'Deixa de estar visível para todos.', 'Apagar', true);
        setPause('menu', false);
        if (!ok) return;
        const r = await rpc('recado.status.delete', { id: it.id });
        if (bad(r)) { UI.toast(errText(r)); return; }
        grp.items.splice(ii, 1); UI.toast('Atualização apagada');
        if (!grp.items.length) { close(); emitLive('status', {}); return; }
        ii = Math.min(ii, grp.items.length - 1); show(); emitLive('status', {});
      }
    };

    win.appendChild(lay);
    requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); }); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 60);
    const api = { el: lay, close, pause: () => setPause('api', true), resume: () => setPause('api', false), next, prev, get index() { return { group: gi, item: ii }; } };
    openViewer = api;
    show();
    return api;
  }

  /* ---------- privacidade do estado ---------- */
  function privacySheet(cur) {
    cur = { privacy: (cur && cur.privacy) || 'contacts', audience: ((cur && cur.audience) || []).slice() };
    return new Promise(res => {
      let result = null;
      const body = UI.el('<div class="rcu-priv"><div class="rcu-priv-h">Quem pode ver as tuas próximas atualizações</div><div class="rcu-priv-l"></div><div class="rcu-priv-f">As alterações não afetam as atualizações que já partilhaste. Só vê quem também te tem nos contactos, e a opção «Atualizações» da tua privacidade do Zapp (e os bloqueios) aplica-se por cima desta escolha.</div></div>');
      const holder = body.querySelector('.rcu-priv-l');
      const paint = () => {
        holder.innerHTML = '';
        holder.appendChild(UI.list([{ items: ['contacts', 'except', 'only'].map(k => ({
          label: PRIV_LABEL[k], chevron: k !== 'contacts',
          sub: k === 'except' && cur.privacy === 'except' ? `${cur.audience.length} excluído${cur.audience.length === 1 ? '' : 's'}` : k === 'only' && cur.privacy === 'only' ? `${cur.audience.length} incluído${cur.audience.length === 1 ? '' : 's'}` : undefined,
          right: cur.privacy === k ? `<div class="rcu-checkmark">${g('check', 18)}</div>` : undefined,
          onTap: async () => {
            if (k === 'contacts') { cur = { privacy: 'contacts', audience: [] }; paint(); return; }
            const picked = await pickContacts(k === 'except' ? 'Ocultar de…' : 'Partilhar só com…', cur.privacy === k ? cur.audience : [], 256);
            if (picked === null) return;
            if (k === 'only' && !picked.length) { UI.toast('Escolhe pelo menos um contacto'); return; }
            cur = { privacy: k, audience: picked }; paint();
          }
        })) }]));
      };
      paint();
      UI.sheet({ title: 'Privacidade do estado', left: 'Cancelar', right: 'Concluído', body, onDone: () => { result = cur; }, onClose: () => res(result) });
    });
  }

  /* ============================================================
     CRIAR ESTADO (texto com fundo e letra, foto, voz, autocolante; privacidade; menções)
     ============================================================ */
  function statusComposer(win, opts = {}) {
    if (!win) win = R() && R().win;
    if (!win) return Promise.resolve(null);
    return new Promise(done => {
      const st = { mode: ['text', 'photo', 'voice', 'sticker'].includes(opts.mode) ? opts.mode : 'text', bg: Math.floor(Math.random() * 4), font: 0,
        image: null, sticker: null, priv: { privacy: cache.prefs.privacy || 'contacts', audience: (cache.prefs.audience || []).slice() }, mentions: [], busy: false, rec: null };
      const lay = UI.el(`<div class="rcu-comp">
        <div class="rcu-c-stage"></div>
        <div class="rcu-c-top"><div class="rcu-c-b x">${g('x', 22)}</div><div class="rcu-c-sp"></div><div class="rcu-c-b font"><span>Aa</span></div><div class="rcu-c-b pal"><i></i></div><div class="rcu-c-b stk">${g('smile', 22)}</div></div>
        <div class="rcu-c-cap"><input type="text" maxlength="700" placeholder="Adiciona uma legenda…"></div>
        <div class="rcu-c-bot">
          <div class="rcu-c-chip priv">${g('lock', 16)}<span></span>${g('chevD', 14)}</div>
          <div class="rcu-c-chip ment">${g('at', 16)}<span>Mencionar</span></div>
          <div class="rcu-c-send">${g('send', 24)}<span class="rcu-spin"></span></div>
        </div>
        <div class="rcu-c-modes"><span data-m="text">Texto</span><span data-m="photo">Foto</span><span data-m="voice">Voz</span><span data-m="sticker">Autocolante</span></div>
      </div>`);
      const $ = s => lay.querySelector(s);
      const stage = $('.rcu-c-stage'), capIn = $('.rcu-c-cap input'), send = $('.rcu-c-send');
      let dead = false, ta = null;
      const onKey = e => { if (dead || e.key !== 'Escape' || !winShown(win)) return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offs = [Bridge.on('app:kill', id => { if (id === 'recado') close(null); }), Bridge.on('phone:close', () => { if (st.rec) { try { st.rec.cancel('closed'); } catch (e) {} } })];
      function close(v) {
        if (dead) return; dead = true;
        if (st.rec) { try { st.rec.cancel('closed'); } catch (e) {} st.rec = null; }
        document.removeEventListener('keydown', onKey, true); offs.forEach(f => { try { f(); } catch (e) {} });
        lay.classList.remove('in'); setTimeout(() => lay.remove(), 260);
        done(v);
      }
      document.addEventListener('keydown', onKey, true);

      const paintChips = () => {
        $('.priv span').textContent = PRIV_LABEL[st.priv.privacy] + (st.priv.privacy !== 'contacts' ? ` (${st.priv.audience.length})` : '');
        const m = $('.ment'); m.classList.toggle('on', st.mentions.length > 0);
        m.querySelector('span').textContent = st.mentions.length ? (st.mentions.length === 1 ? nameOf(st.mentions[0]) : `${st.mentions.length} mencionados`) : 'Mencionar';
      };
      const ready = () => (st.mode === 'text' && ta && ta.value.trim()) || (st.mode === 'photo' && st.image) || (st.mode === 'sticker' && st.sticker);
      const paintSend = () => send.classList.toggle('off', !ready() || st.busy);

      function paint() {
        lay.dataset.mode = st.mode;
        lay.className = lay.className.replace(/\brcu-bg-\S+/g, '').trim();
        if (st.mode === 'text' || st.mode === 'voice' || st.mode === 'sticker') lay.classList.add('rcu-bg-' + BGS[st.bg]);
        lay.querySelectorAll('.rcu-c-modes span').forEach(s => s.classList.toggle('on', s.dataset.m === st.mode));
        if (st.rec && st.mode !== 'voice') { try { st.rec.cancel('user'); } catch (e) {} st.rec = null; }
        stage.innerHTML = ''; ta = null;
        if (st.mode === 'text') {
          ta = UI.el(`<textarea class="rcu-c-ta rcu-f-${FONTS[st.font]}" maxlength="700" placeholder="Escreve uma atualização"></textarea>`);
          ta.value = st.text || '';
          const fit = () => { ta.className = ta.className.replace(/\bs-\S+/g, '').trim() + ' s-' + textSize(ta.value); st.text = ta.value; paintSend(); };
          ta.addEventListener('input', fit); fit();
          stage.appendChild(ta); setTimeout(() => { if (!dead && ta) ta.focus(); }, 280);
        } else if (st.mode === 'photo') {
          if (st.image) { const im = UI.el('<div class="rcu-c-img"></div>'); im.style.backgroundImage = UI.img(st.image); stage.appendChild(im);
            const ch = UI.el(`<div class="rcu-c-change">${g('photo', 16)}<span>Trocar</span></div>`); ch.onclick = () => choosePhoto(); stage.appendChild(ch); }
          else { const p = UI.el(`<div class="rcu-c-pick"><div class="rcu-c-pbtn gal">${g('photo', 30)}<span>Galeria</span></div><div class="rcu-c-pbtn cam">${g('camera', 30)}<span>Câmara</span></div><p>Escolhe uma fotografia para a tua atualização</p></div>`);
            p.querySelector('.gal').onclick = () => choosePhoto('gal'); p.querySelector('.cam').onclick = () => choosePhoto('cam'); stage.appendChild(p); }
        } else if (st.mode === 'voice') {
          const box = UI.el(`<div class="rcu-c-voice"><div class="rcu-c-mic">${g('mic', 46)}</div><b>Atualização de voz</b><p></p><div class="rcu-c-rec"></div></div>`);
          const p = box.querySelector('p'), host = box.querySelector('.rcu-c-rec'), mic = box.querySelector('.rcu-c-mic');
          const supported = window.VoiceMsg && VoiceMsg.supported();
          p.textContent = supported ? 'Toca no microfone para gravar (até 30 s). Revês antes de publicar.' : (Bridge.inFiveM ? VoiceMsg.MIC_UNAVAILABLE : 'Este browser não permite gravar áudio') + '. Podes publicar texto, foto ou autocolante.';
          box.classList.toggle('off', !supported);
          mic.onclick = () => {
            if (!supported || st.rec || st.busy) return;
            box.classList.add('recording');
            st.rec = VoiceMsg.recorder(host, { maxSec: Math.min(30, imgCfg().maxSec || 30), app: 'recado',
              onCancel: () => { st.rec = null; box.classList.remove('recording'); },
              onSend: (blob, ms, wave) => { st.rec = null; return publishVoice(blob, ms, wave).finally(() => box.classList.remove('recording')); } });
          };
          stage.appendChild(box);
        } else {
          const box = UI.el(`<div class="rcu-c-stkbox"></div>`);
          if (st.sticker) { box.appendChild(renderSticker(UI.el('<div class="rcu-c-stk"></div>'), st.sticker.pack, st.sticker.id)); box.onclick = () => chooseSticker(); }
          else { const b = UI.el(`<div class="rcu-c-pbtn">${g('smile', 30)}<span>Escolher autocolante</span></div>`); b.onclick = () => chooseSticker(); box.appendChild(b); }
          stage.appendChild(box);
        }
        $('.font').style.visibility = st.mode === 'text' ? '' : 'hidden';
        $('.pal').style.visibility = st.mode === 'photo' ? 'hidden' : '';
        $('.stk').style.visibility = st.mode === 'sticker' ? '' : 'hidden';
        $('.pal i').className = 'rcu-bg-' + BGS[st.bg];
        lay.classList.toggle('has-cap', st.mode === 'photo' && !!st.image);
        paintChips(); paintSend();
      }

      async function choosePhoto(how) {
        let url = null;
        if (how === 'cam') url = await openCamera(win, 'Nova atualização');
        else if (how === 'gal') { if (!window.Photos || !Photos.pick) { UI.toast('Fotos indisponíveis'); return; } const p = await Photos.pick('Nova atualização'); if (p) { try { url = await Photos.data(p, true); } catch (e) {} if (!(typeof url === 'string' && /^data:image\//.test(url)) && p.seed != null) url = seedToDataUrl(p.seed); } }
        else url = await pickImage(win, 'Nova atualização');
        if (dead || !url) return;
        st.image = url; st.mode = 'photo'; paint();
      }
      async function chooseSticker() { const s = await pickSticker(win); if (dead || !s) return; st.sticker = s; st.mode = 'sticker'; paint(); }

      async function publish(payload) {
        const r = await rpc('recado.status.add', Object.assign({ privacy: st.priv.privacy, list: st.priv.privacy === 'contacts' ? [] : st.priv.audience, mentions: st.mentions }, payload));
        if (bad(r)) { UI.toast(errText(r, 'A atualização não foi publicada'), 2600); return null; }
        cache.prefs = { privacy: st.priv.privacy, audience: st.priv.audience.slice() };
        UI.toast('Atualização partilhada');
        emitLive('status', { action: 'add', id: r.id });
        return r;
      }
      async function publishVoice(blob, ms, wave) {
        if (st.busy || dead) return;
        st.busy = true; send.classList.add('busy'); paintSend();
        const up = await VoiceMsg.upload(blob, ms, wave);
        if (!up || !up.mediaId) { st.busy = false; send.classList.remove('busy'); paintSend(); UI.toast(VoiceMsg.errorText(up && up.error, 'O áudio não foi enviado')); return; }
        const r = await publish({ kind: 'audio', mediaId: up.mediaId, bg: BGS[st.bg] });
        st.busy = false; send.classList.remove('busy');
        if (r) close(r); else paintSend();
      }

      send.onclick = async () => {
        if (st.busy || dead) return;
        if (st.mode === 'voice') { if (st.rec && st.rec.send) st.rec.send(); else UI.toast('Grava primeiro a atualização de voz'); return; }
        if (!ready()) { UI.toast(st.mode === 'text' ? 'Escreve alguma coisa primeiro' : st.mode === 'photo' ? 'Escolhe uma fotografia' : 'Escolhe um autocolante'); return; }
        st.busy = true; send.classList.add('busy'); paintSend();
        let r = null;
        if (st.mode === 'text') r = await publish({ kind: 'text', content: ta.value.trim(), bg: BGS[st.bg], font: FONTS[st.font] });
        else if (st.mode === 'sticker') r = await publish({ kind: 'sticker', content: st.sticker.pack + ':' + st.sticker.id, bg: BGS[st.bg] });
        else {
          const up = await uploadImage(st.image, f => send.style.setProperty('--p', f.toFixed(2)));
          if (up.error) UI.toast(errText(up, 'A foto não foi enviada'));
          else r = await publish({ kind: 'image', mediaId: up.mediaId, content: capIn.value.trim() || undefined });
        }
        st.busy = false; send.classList.remove('busy');
        if (r) close(r); else paintSend();
      };
      $('.x').onclick = () => close(null);
      $('.font').onclick = () => { st.font = (st.font + 1) % FONTS.length; if (ta) { ta.className = ta.className.replace(/\brcu-f-\S+/, 'rcu-f-' + FONTS[st.font]); } };
      $('.pal').onclick = () => { st.bg = (st.bg + 1) % BGS.length; lay.className = lay.className.replace(/\brcu-bg-\S+/g, '').trim() + ' rcu-bg-' + BGS[st.bg]; $('.pal i').className = 'rcu-bg-' + BGS[st.bg]; };
      $('.stk').onclick = () => chooseSticker();
      $('.priv').onclick = async () => { const p = await privacySheet(st.priv); if (p && !dead) { st.priv = p; paintChips(); } };
      $('.ment').onclick = async () => { const p = await pickContacts('Mencionar contactos', st.mentions, 10); if (p && !dead) { st.mentions = p; paintChips(); } };
      lay.querySelectorAll('.rcu-c-modes span').forEach(s => { s.onclick = () => { if (st.busy) return; const m = s.dataset.m; if (m === st.mode) return; if (st.mode === 'text' && ta) st.text = ta.value; st.mode = m; paint(); if (m === 'photo' && !st.image) choosePhoto(); if (m === 'sticker' && !st.sticker) chooseSticker(); }; });

      win.appendChild(lay);
      requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); }); setTimeout(() => { if (!dead) lay.classList.add('in'); }, 60);
      paint();
      if (st.mode === 'photo' && !opts.noPick) choosePhoto();
      if (st.mode === 'sticker' && !opts.noPick) chooseSticker();
    });
  }

  /* ============================================================
     CANAIS
     ============================================================ */
  function channelDirectory(win) {
    if (!win) win = R() && R().win;
    const st = { dead: false, q: '', t: null, seq: 0 };
    const v = UI.view({ title: 'Canais', back: true, cls: 'rcu-root', right: [{ icon: 'plus', onTap: async () => { const a = await UI.actionSheet({ buttons: [{ label: 'Criar canal', icon: 'plus', value: 'new' }, { label: 'Entrar com código', icon: 'link', value: 'code' }] }); if (a === 'new') channelForm(win, null); if (a === 'code') joinByCode(win); } }],
      onPop: () => { st.dead = true; live.delete(refresh); } });
    const s = UI.search('Pesquisar canais', q => { st.q = q; clearTimeout(st.t); st.t = setTimeout(load, 250); });
    const body = UI.el('<div class="rcu-body"></div>');
    v.content.append(s, body);
    body.appendChild(UI.skeleton('list', 6));
    const refresh = kind => { if (kind === 'channel' && !st.dead) { clearTimeout(st.t); st.t = setTimeout(load, 400); } };
    live.add(refresh);
    async function load() {
      const seq = ++st.seq;
      const [mine, fol, dir] = await Promise.all([rpc('recado.channel.list', { scope: 'mine' }), rpc('recado.channel.list', { scope: 'following' }), rpc('recado.channel.list', { scope: 'directory', q: st.q || undefined })]);
      if (st.dead || seq !== st.seq) return;
      body.innerHTML = '';
      const q = st.q;
      const match = c => !q || String(c.name).toLowerCase().includes(q);
      const sec = (title, list, withFollow) => {
        if (!list.length) return;
        const w = UI.el(`<section class="rcu-sec"><div class="rcu-sec-h"><h3>${esc(title)}</h3></div><div class="rcu-chlist"></div></section>`);
        const l = w.querySelector('.rcu-chlist');
        list.forEach(c => { const row = channelRow(c, () => openChannel(win, c.id)); if (withFollow && !c.following && !c.myRole) row.classList.add('dir'), row.appendChild(followBtn(c, load)); l.appendChild(row); });
        body.appendChild(w);
      };
      if (bad(dir) && bad(fol)) { body.appendChild(UI.empty('newspaper', 'Sem ligação', errText(dir))); return; }
      const m = toArr(mine).filter(match), f = toArr(fol).filter(c => match(c) && !c.myRole), d = toArr(dir).filter(c => !c.following && !c.myRole);
      sec('Os meus canais', m, false);
      sec('A seguir', f, false);
      sec(q ? 'Resultados' : 'Diretório', d, true);
      if (!m.length && !f.length && !d.length) body.appendChild(UI.empty('search', q ? 'Nenhum canal encontrado' : 'Ainda não há canais', q ? 'Experimenta outro nome.' : 'Cria o primeiro canal da cidade.'));
    }
    load();
    return UI.push(win, v);
  }

  function followBtn(c, after) {
    const b = UI.el('<div class="rcu-btn sm">Seguir</div>');
    b.onclick = async e => { e.stopPropagation(); if (b.classList.contains('busy')) return; b.classList.add('busy'); const r = await rpc('recado.channel.follow', { id: c.id }); b.classList.remove('busy'); if (bad(r)) { UI.toast(errText(r)); return; } b.textContent = 'A seguir'; b.classList.add('on'); if (after) setTimeout(after, 400); };
    return b;
  }

  async function joinByCode(win) {
    const code = await UI.prompt('Entrar num canal', 'Cola o código ou a ligação que te enviaram.', 'Código (ex.: K7QX2M9A)');
    if (!code) return;
    const r = await rpc('recado.channel.join', { code });
    if (bad(r)) { UI.toast(r && r.error === 'notfound' ? 'Código inválido' : errText(r)); return; }
    UI.toast(`Estás a seguir ${r.name}`); emitLive('channel', { id: r.id });
    openChannel(win, r.id);
  }

  function openChannel(win, id) {
    if (!win) win = R() && R().win;
    if (!win) return null;
    /* players: um leitor de áudio por publicação, REUTILIZADO entre repinturas (uma reação ou uma publicação nova
       repinta o feed e não pode cortar o áudio que está a tocar) e largado no onPop (pausa + revoga o blob: URL) */
    const st = { dead: false, ch: null, posts: [], more: false, t: null, loadingOlder: false, players: new Map(), rec: null };
    const v = UI.view({ title: '', back: true, full: true, cls: 'rcu-chv', right: [{ icon: 'info', onTap: () => st.ch && channelInfo(win, st.ch, reload) }],
      onPop: () => {
        st.dead = true; live.delete(refresh); clearTimeout(st.t);
        win.querySelectorAll('.rcu-react-pop, .rcu-react-shield').forEach(x => x.remove());
        st.players.forEach(p => { try { p.release(); } catch (e) {} }); st.players.clear();
        if (st.rec) { try { st.rec.cancel('closed'); } catch (e) {} st.rec = null; }
      } });
    const titleEl = v.querySelector('.nb-title');
    titleEl.textContent = '';
    const head = UI.el('<div class="rcu-chv-head"><div class="rcu-chv-av"></div><div class="rcu-chv-t"><div class="rcu-chv-n"><b></b></div><span></span></div></div>');
    titleEl.appendChild(head);
    head.onclick = () => st.ch && channelInfo(win, st.ch, reload);
    const feed = UI.el('<div class="rcu-feed"></div>');
    v.content.classList.add('rcu-feed-scroll');
    v.content.appendChild(feed);
    feed.appendChild(UI.skeleton('feed', 2));
    const bar = UI.el('<div class="rcu-chv-bar"></div>');
    v.appendChild(bar);

    const refresh = (kind, d) => {
      if (st.dead || kind !== 'channel' || !d || +d.id !== +id) return;
      if (d.action === 'delete') {
        /* só se tira a vista se for a de cima: com as Informações (ou outra) por cima, o pop tirava a vista errada */
        st.deleted = true; clearTimeout(st.t);
        if (v.parentElement && v.parentElement.lastElementChild === v) { UI.toast('Este canal foi apagado'); UI.pop(win); }
        else { feed.innerHTML = ''; feed.appendChild(UI.empty('newspaper', 'Canal apagado', 'Este canal já não existe.')); bar.innerHTML = ''; }
        return;
      }
      clearTimeout(st.t); st.t = setTimeout(() => loadPosts(true), 250);
    };
    live.add(refresh);

    async function reload() {
      const r = await rpc('recado.channel.get', { id });
      if (st.dead) return;
      if (bad(r)) { feed.innerHTML = ''; feed.appendChild(UI.empty('newspaper', 'Canal indisponível', errText(r))); bar.innerHTML = ''; return; }
      st.ch = r;
      paintHead(); paintBar();
      await loadPosts(true);
    }
    function paintHead() {
      const c = st.ch;
      const av = head.querySelector('.rcu-chv-av'); av.innerHTML = ''; av.appendChild(avatarEl({ mediaId: c.avatar, name: c.name }));
      head.querySelector('b').textContent = c.name;
      const old = head.querySelector('.rcu-verif'); if (old) old.remove();
      if (c.verified) head.querySelector('.rcu-chv-n').appendChild(UI.el(`<span class="rcu-verif">${g('check', 9)}</span>`));
      head.querySelector('.rcu-chv-t > span').textContent = plural(c.followers, 'seguidor', 'seguidores');
    }
    async function loadPosts(fresh) {
      const r = await rpc('recado.channel.posts', fresh ? { id } : { id, before: st.posts.length ? st.posts[0].id : undefined });
      if (st.dead) return;
      if (bad(r)) { if (fresh) { feed.innerHTML = ''; feed.appendChild(UI.empty('newspaper', 'Sem publicações', errText(r))); } return; }
      const items = toArr(r.items);
      const atBottom = v.content.scrollHeight - v.content.scrollTop - v.content.clientHeight < 80;
      const prevH = v.content.scrollHeight;
      st.posts = fresh ? items : items.concat(st.posts);
      st.more = !!r.more;
      paintFeed();
      if (fresh && (atBottom || !st.painted)) v.content.scrollTop = v.content.scrollHeight;
      else if (!fresh) v.content.scrollTop = v.content.scrollHeight - prevH;
      st.painted = true;
    }
    function paintFeed() {
      feed.innerHTML = '';
      if (st.more) { const b = UI.el('<div class="rcu-older">Carregar publicações anteriores</div>'); b.onclick = () => loadPosts(false); feed.appendChild(b); }
      if (!st.posts.length) {
        const c = st.ch || {};
        const e = UI.el(`<div class="rcu-chv-empty"><div class="rcu-chv-empty-av"></div><b></b><p></p></div>`);
        e.querySelector('.rcu-chv-empty-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name }));
        e.querySelector('b').textContent = c.name || '';
        e.querySelector('p').textContent = c.myRole ? 'Ainda não publicaste nada. Tudo o que publicares chega a quem segue o canal.' : 'Ainda não há publicações neste canal.';
        feed.appendChild(e); UI.emptyFit(e); return;
      }
      let lastDay = '';
      st.posts.forEach(p => {
        const day = dayLabel(p.created);
        if (day !== lastDay) { lastDay = day; feed.appendChild(UI.el(`<div class="rcu-day"><span>${esc(day)}</span></div>`)); }
        feed.appendChild(postEl(p));
      });
      /* leitores de publicações que já não estão no feed (apagadas) */
      st.players.forEach((pl, pid) => { if (!st.posts.some(x => x.id === pid)) { try { pl.release(); } catch (e) {} st.players.delete(pid); } });
    }

    function postEl(p) {
      const c = st.ch || {};
      const el = UI.el(`<div class="rcu-post"><div class="rcu-post-card"><div class="rcu-post-body"></div><div class="rcu-post-meta"><span class="t"></span></div></div><div class="rcu-post-side">${g('smile', 18)}</div></div>`);
      const card = el.querySelector('.rcu-post-card'), b = el.querySelector('.rcu-post-body');
      el.querySelector('.t').textContent = UI.fmtTime(new Date(+p.created));
      if (p.type === 'image') {
        card.classList.add('has-img');
        const im = UI.el('<div class="rcu-post-img"></div>'); b.appendChild(im); paintMedia(im, p.mediaId);
        im.onclick = () => viewImage(win, p.mediaId, p.content);
        if (p.content) { const t = UI.el('<div class="rcu-post-txt"></div>'); t.textContent = p.content; b.appendChild(t); }
      } else if (p.type === 'audio') {
        let pl = st.players.get(p.id);
        if (!pl) { pl = audioPlayer(p.mediaId, p.payload && p.payload.duration, p.payload && p.payload.waveform); st.players.set(p.id, pl); }
        b.appendChild(pl.el);
      } else if (p.type === 'sticker') {
        card.classList.add('is-stk');
        b.appendChild(renderSticker(UI.el('<div class="rcu-post-stk"></div>'), p.payload && p.payload.pack, p.payload && p.payload.id));
      } else if (p.type === 'poll' && p.poll) {
        b.appendChild(pollEl(p));
      } else {
        const t = UI.el('<div class="rcu-post-txt"></div>'); t.textContent = p.content || ''; b.appendChild(t);
      }
      const reacts = toArr(p.reactions);
      if (reacts.length) {
        const rw = UI.el('<div class="rcu-post-reacts"></div>');
        reacts.slice(0, 4).forEach(x => rw.appendChild(UI.el(`<span class="${p.myReaction === x.emoji ? 'mine' : ''}">${esc(x.emoji)}<em>${fmtCount(x.n)}</em></span>`)));
        rw.onclick = () => reactPop(el, p);
        el.appendChild(rw);
      }
      el.querySelector('.rcu-post-side').onclick = () => reactPop(el, p);
      UI.longPress(card, () => reactPop(el, p));
      return el;
    }

    function pollEl(p) {
      const poll = p.poll, opts = toArr(poll.options), mine = new Set(toArr(poll.mine).map(Number)), total = Math.max(0, +poll.total || 0);
      const w = UI.el(`<div class="rcu-poll"><div class="rcu-poll-q"></div><div class="rcu-poll-s"></div><div class="rcu-poll-o"></div><div class="rcu-poll-f"></div></div>`);
      w.querySelector('.rcu-poll-q').textContent = poll.question || '';
      w.querySelector('.rcu-poll-s').textContent = poll.multi ? 'Escolhe uma ou mais opções' : 'Escolhe uma opção';
      const holder = w.querySelector('.rcu-poll-o');
      opts.forEach((o, i) => {
        /* percentagem de quem votou (numa sondagem de várias respostas a soma pode passar de 100%) */
        const frac = total ? clamp((+o.votes || 0) / total, 0, 1) : 0, pct = Math.round(frac * 100);
        const row = UI.el(`<div class="rcu-poll-opt ${mine.has(i) ? 'on' : ''}"><div class="rcu-poll-c">${g('check', 12)}</div><div class="rcu-poll-m"><div class="rcu-poll-l"><span></span><em>${pct}%</em></div><div class="rcu-poll-bar"><i style="transform:scaleX(${frac.toFixed(3)})"></i></div></div></div>`);
        row.querySelector('span').textContent = o.text;
        row.onclick = async () => {
          const c = st.ch || {};
          if (!c.following && !c.myRole) { UI.toast(ERR.notfollowing); return; }
          let next;
          if (poll.multi) { next = new Set(mine); if (next.has(i)) next.delete(i); else next.add(i); } else next = mine.has(i) ? new Set() : new Set([i]);
          const r = await rpc('recado.channel.vote', { postId: p.id, options: [...next] });
          if (bad(r)) { UI.toast(errText(r)); return; }
          p.poll = r.poll; paintFeed();
        };
        holder.appendChild(row);
      });
      w.querySelector('.rcu-poll-f').textContent = `${plural(total, 'voto', 'votos')} · votação anónima`;
      return w;
    }

    function reactPop(postNode, p) {
      if (st.dead) return;
      win.querySelectorAll('.rcu-react-pop, .rcu-react-shield').forEach(x => x.remove());
      const c = st.ch || {};
      const EMO = ['❤️', '👍', '😂', '😮', '😢', '🙏', '🔥', '👏'];
      const pop = UI.el(`<div class="rcu-react-pop"><div class="rcu-react-row"></div></div>`);
      const row = pop.querySelector('.rcu-react-row');
      EMO.forEach(e => { const s = UI.el(`<span class="${p.myReaction === e ? 'on' : ''}">${esc(e)}</span>`); s.onclick = async ev => { ev.stopPropagation(); pop.remove();
        if (!c.following && !c.myRole) { UI.toast(ERR.notfollowing); return; }
        const r = await rpc('recado.channel.react', { postId: p.id, emoji: p.myReaction === e ? null : e });
        if (bad(r)) { UI.toast(errText(r)); return; }
        p.reactions = toArr(r.reactions); p.myReaction = r.myReaction || null; paintFeed(); }; row.appendChild(s); });
      if (c.myRole) { const del = UI.el(`<div class="rcu-react-del">${g('trash', 16)}<span>Apagar publicação</span></div>`); del.onclick = async ev => { ev.stopPropagation(); pop.remove(); if (!(await UI.confirm('Apagar publicação?', 'Deixa de estar visível para os seguidores.', 'Apagar', true))) return; const r = await rpc('recado.channel.unpost', { postId: p.id }); if (bad(r)) { UI.toast(errText(r)); return; } st.posts = st.posts.filter(x => x.id !== p.id); paintFeed(); }; pop.appendChild(del); }
      /* montado na JANELA do Recado (e não no #screen): se a app for para segundo plano ou morrer com o menu
         aberto, o menu vai com ela em vez de ficar a flutuar por cima do ecrã principal */
      const sr = win.getBoundingClientRect(), z = UI.zoom(), pr = postNode.getBoundingClientRect();
      let top = (pr.top - sr.top) / z - 64; if (top < 110) top = (pr.bottom - sr.top) / z + 8;
      pop.style.top = Math.min(840, top) + 'px';
      const shield = UI.el('<div class="rcu-react-shield"></div>');
      shield.onclick = () => { shield.remove(); pop.remove(); };
      pop.addEventListener('click', () => shield.remove());
      win.append(shield, pop);
      requestAnimationFrame(() => pop.classList.add('in'));
    }

    function paintBar() {
      const c = st.ch; bar.innerHTML = ''; v.classList.toggle('is-admin', !!c.myRole);
      if (c.myRole) {
        const comp = UI.el(`<div class="rcu-cbar"><div class="rcu-cbar-b plus">${g('plus', 22)}</div><div class="rcu-cbar-in"><textarea rows="1" maxlength="2000" placeholder="Publicar no canal"></textarea></div><div class="rcu-cbar-b send">${g('send', 20)}</div></div>`);
        const ta = comp.querySelector('textarea'), sendB = comp.querySelector('.send');
        const grow = () => { ta.style.height = 'auto'; ta.style.height = Math.min(120, ta.scrollHeight) + 'px'; sendB.classList.toggle('on', !!ta.value.trim()); };
        ta.addEventListener('input', grow);
        ta.addEventListener('keydown', e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendB.click(); } });
        sendB.onclick = async () => { const text = ta.value.trim(); if (!text || sendB.classList.contains('busy')) return; sendB.classList.add('busy'); const r = await post({ type: 'text', content: text }); sendB.classList.remove('busy'); if (r) { ta.value = ''; grow(); } };
        comp.querySelector('.plus').onclick = () => attach();
        bar.appendChild(comp); grow();
      } else if (c.following) {
        const f = UI.el(`<div class="rcu-fbar"><div class="rcu-fbar-b bell ${c.muted ? '' : 'on'}">${g(c.muted ? 'bellOff' : 'bell', 20)}<span>${c.muted ? 'Notificações desativadas' : 'Notificações ativadas'}</span></div></div>`);
        f.querySelector('.bell').onclick = async () => { const r = await rpc('recado.channel.mute', { id, on: !c.muted }); if (bad(r)) { UI.toast(errText(r)); return; } c.muted = !!r.muted; UI.toast(c.muted ? 'Notificações do canal desativadas' : 'Vais receber notificações deste canal'); paintBar(); };
        bar.appendChild(f);
      } else {
        const f = UI.el(`<div class="rcu-fbar"><div class="rcu-btn wide">${g('plus', 18)}<span>Seguir canal</span></div></div>`);
        f.querySelector('.rcu-btn').onclick = async e => { const b = e.currentTarget; b.classList.add('busy'); const r = await rpc('recado.channel.follow', { id }); b.classList.remove('busy'); if (bad(r)) { UI.toast(errText(r)); return; } UI.toast(`Estás a seguir ${c.name}`); emitLive('channel', { id: -1 }); reload(); };
        bar.appendChild(f);
      }
    }

    async function post(payload) {
      const r = await rpc('recado.channel.post', Object.assign({ id }, payload));
      if (bad(r)) { UI.toast(errText(r, 'Não foi publicado')); return null; }
      /* um envio que acaba depois de sair do canal (áudio/foto a subir) publica na mesma, só não repinta */
      if (!st.dead) { st.posts.push(r); paintFeed(); v.content.scrollTop = v.content.scrollHeight; }
      emitLive('channel', { id: -1 });
      return r;
    }
    async function attach() {
      const a = await UI.actionSheet({ title: 'Publicar', buttons: [{ label: 'Foto', icon: 'photo', value: 'photo' }, { label: 'Mensagem de voz', icon: 'mic', value: 'voice' }, { label: 'Autocolante', icon: 'smile', value: 'sticker' }, { label: 'Sondagem', icon: 'chart', value: 'poll' }] });
      if (a === 'photo') {
        const url = await pickImage(win, 'Publicar foto'); if (!url || st.dead) return;
        const caption = await UI.prompt('Legenda', 'Opcional', 'Escreve uma legenda', '');
        UI.toast('A enviar a foto…');
        const up = await uploadImage(url); if (up.error) { UI.toast(errText(up, 'A foto não foi enviada')); return; }
        post({ type: 'image', mediaId: up.mediaId, content: caption || undefined });
      } else if (a === 'voice') recordVoice();
      else if (a === 'sticker') { const s = await pickSticker(win); if (s) post({ type: 'sticker', payload: s }); }
      else if (a === 'poll') { const p = await pollComposer(); if (p) post({ type: 'poll', payload: p }); }
    }
    function recordVoice() {
      if (!window.VoiceMsg || !VoiceMsg.supported()) { UI.alert({ title: 'Voz indisponível', msg: (Bridge.inFiveM ? VoiceMsg.MIC_UNAVAILABLE : 'Este browser não permite gravar áudio') + '. Podes publicar texto, fotos, autocolantes e sondagens.' }); return; }
      if (st.rec || st.dead) return;
      const host = UI.el('<div class="rcu-cbar-rec"></div>'); bar.appendChild(host); bar.classList.add('recording');
      const end = () => { st.rec = null; bar.classList.remove('recording'); host.remove(); };
      /* guardado em st.rec: sair do canal a meio da gravação larga o microfone no onPop */
      st.rec = VoiceMsg.recorder(host, { maxSec: imgCfg().maxSec || 60, app: 'recado', onCancel: end,
        onSend: async (blob, ms, wave) => { const up = await VoiceMsg.upload(blob, ms, wave); end(); if (!up || !up.mediaId) { UI.toast(VoiceMsg.errorText(up && up.error, 'O áudio não foi enviado')); return; } await post({ type: 'audio', mediaId: up.mediaId }); } });
    }

    reload();
    return UI.push(win, v);
  }

  function pollComposer() {
    return new Promise(res => {
      let result = null;
      const max = 12;
      const body = UI.el(`<div class="rcu-pollc"><div class="rcu-field"><label>Pergunta</label><input class="q" type="text" maxlength="200" placeholder="Faz uma pergunta"></div><label class="rcu-lbl">Opções</label><div class="rcu-pollc-opts"></div><div class="rcu-pollc-add">${g('plus', 16)}<span>Adicionar opção</span></div><div class="rcu-pollc-multi"></div></div>`);
      const opts = body.querySelector('.rcu-pollc-opts');
      let multi = false;
      const addOpt = (val) => { if (opts.children.length >= max) { UI.toast(`No máximo ${max} opções`); return; } const i = UI.el(`<div class="rcu-field"><input type="text" maxlength="80" placeholder="Opção ${opts.children.length + 1}"></div>`); i.querySelector('input').value = val || ''; opts.appendChild(i); };
      addOpt(); addOpt();
      body.querySelector('.rcu-pollc-add').onclick = () => addOpt();
      body.querySelector('.rcu-pollc-multi').appendChild(UI.list([{ items: [{ label: 'Permitir várias respostas', toggle: false, onToggle: on => { multi = on; } }] }]));
      UI.sheet({ title: 'Sondagem', left: 'Cancelar', right: 'Publicar', body,
        onDone: () => {
          const question = body.querySelector('.q').value.trim();
          const options = [...opts.querySelectorAll('input')].map(x => x.value.trim()).filter(Boolean);
          if (!question) { UI.toast('Escreve a pergunta'); return false; }
          if (options.length < 2) { UI.toast('Precisas de pelo menos duas opções'); return false; }
          result = { question, options, multi };
        }, onClose: () => res(result) });
    });
  }

  function viewImage(win, mediaId, caption) {
    const lay = UI.el(`<div class="rcu-imgview"><div class="rcu-imgview-i"></div><div class="rcu-imgview-x">${g('x', 22)}</div><div class="rcu-imgview-c"></div></div>`);
    paintMedia(lay.querySelector('.rcu-imgview-i'), mediaId);
    lay.querySelector('.rcu-imgview-c').textContent = caption || '';
    let dead = false;
    /* a app morta (ou o Recado reposto) leva a imagem e o ouvinte do Escape: sem isto o ouvinte ficava vivo e
       engolia o Escape seguinte, que devia fechar o telemóvel */
    const offs = [Bridge.on('app:kill', id => { if (id === 'recado') close(); })];
    const close = () => { if (dead) return; dead = true; offs.forEach(f => { try { f(); } catch (e) {} }); lay.classList.remove('in'); setTimeout(() => lay.remove(), 220); document.removeEventListener('keydown', onKey, true); };
    const onKey = e => { if (e.key === 'Escape' && winShown(win)) { e.preventDefault(); e.stopPropagation(); close(); } };
    document.addEventListener('keydown', onKey, true);
    lay.onclick = close;
    win.appendChild(lay); requestAnimationFrame(() => lay.classList.add('in'));
  }

  /* ---------- informação do canal ---------- */
  function channelInfo(win, ch, after) {
    const st = { ch, dead: false };
    const v = UI.view({ title: 'Informações', back: true, cls: 'rcu-root rcu-info', onPop: () => { st.dead = true; if (after) after(); } });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body);
    async function reload() { const r = await rpc('recado.channel.get', { id: ch.id }); if (st.dead) return; if (!bad(r)) st.ch = r; paint(); }
    function paint() {
      const c = st.ch; body.innerHTML = '';
      const hero = UI.el(`<div class="rcu-hero"><div class="rcu-hero-av"></div><h2></h2><div class="rcu-hero-s"></div><div class="rcu-hero-d"></div><div class="rcu-hero-acts"></div></div>`);
      hero.querySelector('.rcu-hero-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name }, 'xl'));
      hero.querySelector('h2').textContent = c.name;
      if (c.verified) hero.querySelector('h2').appendChild(UI.el(`<span class="rcu-verif">${g('check', 11)}</span>`));
      hero.querySelector('.rcu-hero-s').textContent = `Canal · ${plural(c.followers, 'seguidor', 'seguidores')}`;
      hero.querySelector('.rcu-hero-d').textContent = c.description || (c.myRole ? 'Sem descrição. Toca em Editar para acrescentar.' : '');
      const acts = hero.querySelector('.rcu-hero-acts');
      const act = (icon, label, fn, cls) => { const a = UI.el(`<div class="rcu-hact ${cls || ''}">${g(icon, 22)}<span>${esc(label)}</span></div>`); a.onclick = fn; acts.appendChild(a); };
      if (c.following) act(c.muted ? 'bellOff' : 'bell', c.muted ? 'Silenciado' : 'Notificações', async () => { const r = await rpc('recado.channel.mute', { id: c.id, on: !c.muted }); if (bad(r)) { UI.toast(errText(r)); return; } c.muted = !!r.muted; paint(); });
      else if (!c.myRole) act('plus', 'Seguir', async () => { const r = await rpc('recado.channel.follow', { id: c.id }); if (bad(r)) { UI.toast(errText(r)); return; } reload(); });
      act('share', 'Partilhar', () => shareChannel(c));
      if (c.myRole) act('pen', 'Editar', () => channelForm(win, c, reload));
      body.appendChild(hero);
      const items = [];
      if (c.myRole) {
        items.push({ label: 'Administradores', icon: 'shield', iconBg: 'linear-gradient(150deg,#128C7E,#25D366)', onTap: () => adminsView(win, c) });
        items.push({ label: 'Seguidores', value: fmtCount(c.followers), icon: 'users', iconBg: 'linear-gradient(150deg,#0F9D6B,#128C7E)', onTap: () => followersView(win, c) });
        items.push({ label: 'Código do canal', value: c.code || '--', icon: 'link', iconBg: 'var(--gray)', onTap: () => shareChannel(c, true) });
      }
      if (items.length) body.appendChild(UI.list([{ header: 'Gestão', items }]));
      if (c.myRole === 'owner') body.appendChild(UI.list([{ items: [{ label: 'Aparecer no diretório', toggle: c.listed !== false, onToggle: async on => { const r = await rpc('recado.channel.update', { id: c.id, listed: on }); if (bad(r)) { UI.toast(errText(r)); reload(); return; } c.listed = on; } }], footer: 'Desligado, só entra quem tiver o código. Quem já segue continua a seguir.' }]));
      const danger = [];
      if (c.following) danger.push({ label: 'Deixar de seguir', cls: 'rcu-danger', chevron: false, onTap: async () => { if (!(await UI.confirm(`Deixar de seguir ${c.name}?`, '', 'Deixar de seguir', true))) return; const r = await rpc('recado.channel.unfollow', { id: c.id }); if (bad(r)) { UI.toast(errText(r)); return; } emitLive('channel', { id: -1 }); UI.pop(win); } });
      if (c.myRole === 'owner') danger.push({ label: 'Apagar canal', cls: 'rcu-danger', chevron: false, onTap: async () => { if (!(await UI.confirm(`Apagar ${c.name}?`, 'As publicações e os seguidores são apagados. Não dá para desfazer.', 'Apagar', true))) return; const r = await rpc('recado.channel.delete', { id: c.id }); if (bad(r)) { UI.toast(errText(r)); return; } emitLive('channel', { id: c.id, action: 'delete' }); UI.toast('Canal apagado');
        /* tira as Informações e, por baixo, o próprio canal (que já mostra "Canal apagado") */
        const stack = v.parentElement; UI.pop(win); setTimeout(() => { const top = stack && stack.lastElementChild; if (top && top.classList.contains('rcu-chv')) UI.pop(win); }, 560); } });
      if (danger.length) body.appendChild(UI.list([{ items: danger }]));
      body.appendChild(UI.el('<div class="rcu-note small">Os seguidores não veem quem mais segue o canal nem os números de telefone uns dos outros.</div>'));
    }
    paint(); reload();
    return UI.push(win, v);
  }

  async function shareChannel(c, admin) {
    let code = c.code;
    if (!code) { UI.alert({ title: c.name, msg: 'Só os administradores têm o código do canal. Pede-lhes a ligação.' }); return; }
    const buttons = [{ label: 'Copiar código', value: 'copy' }];
    if (admin) buttons.push({ label: 'Gerar código novo', danger: true, value: 'reset' });
    buttons.push({ label: 'OK', bold: true, value: false });
    const a = await UI.alert({ title: c.name, msg: `Código do canal: ${code}\nQuem o tiver pode seguir o canal em Canais › Entrar com código.`, buttons });
    if (a.value === 'copy') { try { if (window.Msgs && Msgs.clipboard !== undefined) Msgs.clipboard = code; } catch (e) {} try { navigator.clipboard && navigator.clipboard.writeText(code).catch(() => {}); } catch (e) {} UI.toast('Código copiado'); }
    if (a.value === 'reset') { const r = await rpc('recado.channel.code', { id: c.id, reset: true }); if (bad(r)) { UI.toast(errText(r)); return; } c.code = r.code; UI.toast('Código novo: ' + r.code, 3000); }
  }

  /* criar / editar canal */
  function channelForm(win, c, after) {
    const st = { image: null, busy: false };
    const v = UI.view({ title: c ? 'Editar canal' : 'Novo canal', back: true, cls: 'rcu-root rcu-form', right: [{ label: c ? 'Guardar' : 'Criar', bold: true, onTap: () => save() }] });
    const f = UI.el(`<div class="rcu-body"><div class="rcu-form-av"><div class="rcu-form-img"></div><span>${c ? 'Mudar imagem' : 'Adicionar imagem'}</span></div>
      <div class="rcu-field"><label>Nome do canal</label><input class="n" type="text" maxlength="40" placeholder="Ex.: Notícias de Vinewood"></div>
      <div class="rcu-field"><label>Descrição</label><textarea class="d" maxlength="300" rows="3" placeholder="Sobre o que é este canal?"></textarea></div>
      <div class="rcu-note small">Canais servem para difundir: só os administradores publicam e ninguém vê a lista de seguidores. As notificações ficam desligadas para quem segue até cada pessoa as ativar.</div>
      <div class="rcu-btn wide go">${c ? 'Guardar alterações' : 'Criar canal'}</div></div>`);
    v.content.appendChild(f);
    const img = f.querySelector('.rcu-form-img'), n = f.querySelector('.n'), d = f.querySelector('.d');
    if (c) { n.value = c.name || ''; d.value = c.description || ''; if (c.avatar) paintMedia(img, c.avatar); }
    img.innerHTML = c && c.avatar ? '' : g('camera', 28);
    f.querySelector('.rcu-form-av').onclick = async () => { const url = await pickImage(win, 'Imagem do canal'); if (!url) return; let sq = url; try { sq = await Photos.square(url, 512, .82) || url; } catch (e) {} st.image = sq; img.innerHTML = ''; img.style.backgroundImage = UI.img(sq); img.classList.add('has-img'); };
    f.querySelector('.go').onclick = () => save();
    async function save() {
      if (st.busy) return;
      const name = n.value.trim(); if (!name) { UI.toast(ERR.name); return; }
      st.busy = true; v.classList.add('busy');
      let avatar;
      if (st.image) { const up = await uploadImage(st.image); if (up.error) { st.busy = false; v.classList.remove('busy'); UI.toast(errText(up)); return; } avatar = up.mediaId; }
      const r = await rpc(c ? 'recado.channel.update' : 'recado.channel.create', c ? { id: c.id, name, description: d.value.trim(), avatar } : { name, description: d.value.trim() || undefined, avatar });
      st.busy = false; v.classList.remove('busy');
      if (bad(r)) { UI.toast(errText(r)); return; }
      emitLive('channel', { id: -1 });
      UI.pop(win);
      if (c) { if (after) after(); UI.toast('Canal atualizado'); }
      else setTimeout(() => openChannel(win, r.id), 430);
    }
    return UI.push(win, v);
  }

  function adminsView(win, c) {
    const v = UI.view({ title: 'Administradores', back: true, cls: 'rcu-root' });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body);
    const paint = r => {
      body.innerHTML = '';
      if (bad(r)) { body.appendChild(UI.empty('shield', 'Indisponível', errText(r))); return; }
      const items = toArr(r.items).map(x => ({ label: x.number === me().number ? 'Tu' : nameOf(x.number, x.name || x.number), sub: x.role === 'owner' ? 'Criador do canal' : 'Administrador', chevron: false,
        onTap: r.myRole === 'owner' && x.role !== 'owner' ? async () => { if (!(await UI.confirm('Retirar administrador?', nameOf(x.number, x.name), 'Retirar', true))) return; paint(await rpc('recado.channel.admins', { id: c.id, remove: x.number })); } : undefined }));
      if (r.myRole === 'owner') items.push({ label: 'Adicionar administrador', icon: 'personPlus', iconBg: 'linear-gradient(150deg,#128C7E,#25D366)', chevron: false, onTap: async () => { const p = await Contacts.pick('Novo administrador'); if (!p || !p.number) return; const x = await rpc('recado.channel.admins', { id: c.id, add: p.number }); if (bad(x)) { UI.toast(errText(x)); return; } paint(x); } });
      body.appendChild(UI.list([{ items, footer: `Até ${r.max || 8} administradores. Administradores publicam, editam o canal e veem os seguidores.` }]));
    };
    rpc('recado.channel.admins', { id: c.id }).then(paint);
    return UI.push(win, v);
  }

  function followersView(win, c) {
    const v = UI.view({ title: 'Seguidores', back: true, cls: 'rcu-root' });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body); body.appendChild(UI.skeleton('list', 5));
    rpc('recado.channel.followers', { id: c.id }).then(r => {
      body.innerHTML = '';
      if (bad(r)) { body.appendChild(UI.empty('users', 'Indisponível', errText(r))); return; }
      const items = toArr(r.items);
      if (!items.length) { body.appendChild(UI.empty('users', 'Ainda sem seguidores', 'Partilha o código do canal.')); return; }
      body.appendChild(UI.list([{ header: plural(r.count, 'seguidor', 'seguidores'), items: items.map(x => ({ label: nameOf(x.number, x.name || x.number), sub: x.since ? 'Desde ' + UI.fmtDate(new Date(+x.since), true) : '', chevron: false })), footer: 'Só os administradores veem esta lista.' }]));
    });
    return UI.push(win, v);
  }

  /* ============================================================
     COMUNIDADES
     ============================================================ */
  const openChatConv = (conversation, title) => {
    try { if (R() && typeof R().openChat === 'function') { R().openChat({ conversation }); return; } } catch (e) { console.error('[apex_phone] Recado.openChat', e); }
    UI.toast(`Abre «${title || 'o grupo'}» no separador Conversas`);
  };
  /* ilustração própria (SVG de formas simples, sem imagens externas) */
  const HERO_ART = `<svg viewBox="0 0 160 110" class="rcu-art"><defs><linearGradient id="rcuA" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient></defs><rect x="46" y="16" width="68" height="68" rx="22" fill="url(#rcuA)"/><rect x="8" y="42" width="48" height="48" rx="16" fill="#25D366" opacity=".35"/><rect x="104" y="42" width="48" height="48" rx="16" fill="#128C7E" opacity=".3"/><path d="M66 42h28a6 6 0 0 1 6 6v14a6 6 0 0 1-6 6H80l-9 7v-7h-5a6 6 0 0 1-6-6V48a6 6 0 0 1 6-6z" fill="#fff"/><circle cx="32" cy="66" r="7" fill="#fff" opacity=".9"/><circle cx="128" cy="66" r="7" fill="#fff" opacity=".9"/></svg>`;

  function communitiesView(win) {
    const st = { dead: false, t: null };
    const v = UI.view({ title: 'Comunidades', large: true, cls: 'rcu-root', right: [{ icon: 'plus', onTap: () => communityForm(win, null) }],
      onPop: () => { st.dead = true; live.delete(refresh); } });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body);
    body.appendChild(UI.skeleton('list', 4));
    const refresh = kind => { if (!st.dead && kind === 'community') { clearTimeout(st.t); st.t = setTimeout(load, 400); } };
    live.add(refresh);
    v.rcuRefresh = () => load();
    async function load() {
      const r = await rpc('recado.community.list');
      if (st.dead) return;
      body.innerHTML = '';
      const list = toArr(r);
      const hero = UI.el(`<div class="rcu-cmhero ${list.length ? 'compact' : ''}"><div class="rcu-cmhero-art">${HERO_ART}</div><div class="rcu-cmhero-t"><b>Junta os teus grupos numa comunidade</b><p>Anúncios para todos num só sítio e grupos organizados por tema. Só os administradores enviam anúncios.</p></div><div class="rcu-btn">Criar comunidade</div></div>`);
      hero.querySelector('.rcu-btn').onclick = () => communityForm(win, null);
      body.appendChild(hero);
      if (!list.length) UI.emptyFit(hero);   /* sem comunidades o cartao e o estado vazio: fica ao centro do espaco livre */
      if (bad(r) && !Array.isArray(r)) { body.appendChild(UI.el(`<div class="rcu-note err">${esc(errText(r, 'Não foi possível carregar as comunidades.'))}</div>`)); return; }
      list.forEach(c => body.appendChild(communityBlock(win, c)));
    }
    load();
    return v;
  }

  function communityBlock(win, c) {
    const el = UI.el(`<section class="rcu-cm"><div class="rcu-cm-h"><div class="rcu-cm-av"></div><div class="rcu-cm-t"><b></b><span></span></div>${g('chevR', 16)}</div><div class="rcu-cm-rows"></div></section>`);
    el.querySelector('.rcu-cm-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name, square: true }));
    el.querySelector('b').textContent = c.name;
    const groups = toArr(c.groups);
    el.querySelector('.rcu-cm-t span').textContent = `${plural(+c.memberCount || 0, 'membro', 'membros')} · ${plural(groups.length, 'grupo', 'grupos')}`;
    el.querySelector('.rcu-cm-h').onclick = () => openCommunity(win, c.id);
    const rows = el.querySelector('.rcu-cm-rows');
    if (c.announce) rows.appendChild(announceRow(c));
    groups.filter(x => x.joined).slice(0, 3).forEach(x => rows.appendChild(groupRow(x)));
    const others = groups.length - Math.min(3, groups.filter(x => x.joined).length);
    if (others > 0) { const m = UI.el(`<div class="rcu-cm-more">${g('chevR', 14)}<span>Ver todos os grupos</span></div>`); m.onclick = () => openCommunity(win, c.id); rows.appendChild(m); }
    return el;
  }
  function announceRow(c) {
    const a = c.announce;
    const row = UI.el(`<div class="rcu-cm-row ann"><div class="rcu-cm-ic">${g('bell', 20)}</div><div class="rcu-cm-rb"><b>Anúncios</b><span></span></div><div class="rcu-cm-rr"></div></div>`);
    /* as mensagens de sistema do servidor levam números ("555-0303 passou a administrar…"): mostram-se com o nome
       que EU dei ao contacto, como no resto do Recado */
    const withNames = t => String(t || '').replace(/\+?\d[\d\-.() ]{2,18}\d/g, n => nameOf(n.trim(), n));
    const KIND = { image: '📷 Foto', audio: '🎤 Mensagem de voz', sticker: '✨ Autocolante', poll: '📊 Sondagem', event: '🗓️ Evento', document: '📄 Documento', location: '📍 Localização', contact: '👤 Contacto', gif: 'GIF' };
    row.querySelector('span').textContent = a.last ? (a.last.type === 'system' ? withNames(a.last.content) : `${nameOf(a.last.sender)}: ${a.last.type === 'text' ? a.last.content : (KIND[a.last.type] || '📎 Anexo')}`) : 'Só os administradores enviam mensagens';
    if (a.last && a.last.created) row.querySelector('.rcu-cm-rr').appendChild(UI.el(`<span class="t">${esc(UI.rel(a.last.created))}</span>`));
    if (a.unread > 0) row.querySelector('.rcu-cm-rr').appendChild(UI.el(`<span class="rcu-badge">${a.unread > 99 ? '99+' : a.unread}</span>`));
    row.onclick = e => { e.stopPropagation(); openChatConv(a.id, 'Anúncios'); };
    return row;
  }
  function groupRow(x, opts = {}) {
    const row = UI.el(`<div class="rcu-cm-row ${x.joined ? '' : 'out'}"><div class="rcu-cm-gav"></div><div class="rcu-cm-rb"><b></b><span></span></div><div class="rcu-cm-rr"></div></div>`);
    row.querySelector('.rcu-cm-gav').appendChild(avatarEl({ conversation: x.id, name: x.title }));
    row.querySelector('b').textContent = x.title;
    row.querySelector('span').textContent = x.joined ? plural(x.memberCount, 'membro', 'membros') + (x.role === 'admin' ? ' · és admin' : '') : `${plural(x.memberCount, 'membro', 'membros')} · não és membro`;
    row.onclick = e => { e.stopPropagation(); if (x.joined) openChatConv(x.id, x.title); else UI.alert({ title: x.title, msg: 'Ainda não és membro deste grupo. Pede a um administrador que te adicione ou que te envie o convite do grupo.' }); };
    if (opts.onLong) UI.longPress(row, () => opts.onLong(x));
    return row;
  }

  function openCommunity(win, id) {
    if (!win) win = R() && R().win;
    if (!win) return null;
    const st = { dead: false, c: null, t: null };
    const v = UI.view({ title: 'Comunidade', back: true, cls: 'rcu-root rcu-info', right: [{ icon: 'more', onTap: e => st.c && menu() }], onPop: () => { st.dead = true; live.delete(refresh); } });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body); body.appendChild(UI.skeleton('list', 4));
    const refresh = kind => { if (!st.dead && kind === 'community') { clearTimeout(st.t); st.t = setTimeout(reload, 400); } };
    live.add(refresh);
    async function reload() {
      const r = await rpc('recado.community.get', { id });
      if (st.dead) return;
      if (bad(r)) { body.innerHTML = ''; body.appendChild(UI.empty('users', 'Comunidade indisponível', errText(r))); return; }
      st.c = r; paint();
    }
    function paint() {
      const c = st.c, admin = c.myRole === 'admin', groups = toArr(c.groups);
      body.innerHTML = '';
      const hero = UI.el(`<div class="rcu-hero"><div class="rcu-hero-av sq"></div><h2></h2><div class="rcu-hero-s"></div><div class="rcu-hero-d"></div><div class="rcu-hero-acts"></div></div>`);
      hero.querySelector('.rcu-hero-av').appendChild(avatarEl({ mediaId: c.avatar, name: c.name, square: true }, 'xl'));
      hero.querySelector('h2').textContent = c.name;
      hero.querySelector('.rcu-hero-s').textContent = `Comunidade · ${plural(+c.memberCount || 0, 'membro', 'membros')}`;
      hero.querySelector('.rcu-hero-d').textContent = c.description || '';
      const acts = hero.querySelector('.rcu-hero-acts');
      const act = (icon, label, fn) => { const a = UI.el(`<div class="rcu-hact">${g(icon, 22)}<span>${esc(label)}</span></div>`); a.onclick = fn; acts.appendChild(a); };
      if (c.announce) act('bell', 'Anúncios', () => openChatConv(c.announce.id, 'Anúncios'));
      if (admin) act('plus', 'Adicionar grupo', () => addGroup());
      if (admin) act('pen', 'Editar', () => communityForm(win, c, reload));
      act('users', 'Membros', () => membersView(win, c));
      body.appendChild(hero);
      if (c.announce) { const w = UI.el('<section class="rcu-cm flat"><div class="rcu-cm-rows"></div></section>'); w.firstElementChild.appendChild(announceRow(c)); body.appendChild(w); }
      const joined = groups.filter(x => x.joined), out = groups.filter(x => !x.joined);
      const sec = (title, list) => { if (!list.length) return; const w = UI.el(`<section class="rcu-cm flat"><div class="rcu-cm-sh">${esc(title)}</div><div class="rcu-cm-rows"></div></section>`); list.forEach(x => w.querySelector('.rcu-cm-rows').appendChild(groupRow(x, { onLong: x.role === 'admin' || admin ? removeGroup : null }))); body.appendChild(w); };
      sec('Grupos em que estás', joined);
      sec('Outros grupos', out);
      if (!groups.length) body.appendChild(UI.el(`<div class="rcu-note">${admin ? 'Ainda sem grupos. Adiciona grupos do Zapp de que és administrador ou cria um novo.' : 'Esta comunidade ainda não tem grupos.'}</div>`));
      if (admin) body.appendChild(UI.list([{ header: 'Administração', items: [
        { label: 'Adicionar grupo existente', icon: 'plus', iconBg: 'linear-gradient(150deg,#128C7E,#25D366)', onTap: () => addGroup() },
        { label: 'Criar grupo novo', icon: 'users', iconBg: 'linear-gradient(150deg,#0F9D6B,#128C7E)', onTap: () => createGroup() },
        { label: 'Editar comunidade', icon: 'pen', iconBg: 'var(--gray)', onTap: () => communityForm(win, c, reload) }
      ], footer: `Até ${c.maxGroups || 20} grupos. Toca sem largar num grupo para o retirar da comunidade.` }]));
      const danger = [{ label: 'Sair da comunidade', cls: 'rcu-danger', chevron: false, onTap: () => leave() }];
      if (c.owner) danger.push({ label: 'Apagar comunidade', cls: 'rcu-danger', chevron: false, onTap: () => destroy() });
      body.appendChild(UI.list([{ items: danger, footer: 'Sair da comunidade tira-te do grupo de anúncios e de todos os grupos dela.' }]));
    }
    async function menu() {
      const c = st.c, admin = c.myRole === 'admin';
      const buttons = [{ label: 'Membros', value: 'members' }];
      if (admin) buttons.unshift({ label: 'Adicionar grupo', value: 'add' }, { label: 'Editar comunidade', value: 'edit' });
      buttons.push({ label: 'Sair da comunidade', danger: true, value: 'leave' });
      const a = await UI.actionSheet({ title: c.name, buttons });
      if (a === 'members') membersView(win, c); if (a === 'add') addGroup(); if (a === 'edit') communityForm(win, c, reload); if (a === 'leave') leave();
    }
    async function addGroup() {
      const r = await rpc('recado.community.candidates', { id });
      if (bad(r) && !Array.isArray(r)) { UI.toast(errText(r)); return; }
      const list = toArr(r);
      const body2 = UI.el('<div></div>');
      let sh = null;
      if (!list.length) body2.appendChild(UI.empty('users', 'Sem grupos disponíveis', 'Só aparecem grupos do Zapp de que és administrador e que ainda não estão numa comunidade.'));
      else body2.appendChild(UI.list([{ items: list.map(x => ({ label: x.title, sub: plural(x.memberCount, 'membro', 'membros'), chevron: false, icon: 'users', iconBg: 'linear-gradient(150deg,#128C7E,#25D366)',
        onTap: async () => { sh.close(); const a = await rpc('recado.community.addGroup', { id, conversation: x.id }); if (bad(a)) { UI.toast(errText(a)); return; } UI.toast(`«${x.title}» adicionado`); st.c = a; paint(); emitLive('community', {}); } })) }]));
      const create = UI.el(`<div class="rcu-btn wide ghost">${g('plus', 16)}<span>Criar grupo novo</span></div>`);
      create.onclick = () => { sh.close(); createGroup(); };
      body2.appendChild(create);
      sh = UI.sheet({ title: 'Adicionar grupo', right: 'Cancelar', body: body2 });
    }
    async function createGroup() {
      const rp = window.RecadoPeople;
      if (!rp || typeof rp.createGroup !== 'function') { UI.toast('Cria o grupo no separador Conversas e depois adiciona-o aqui'); return; }
      let g2 = null; try { g2 = await rp.createGroup(win); } catch (e) { g2 = null; }
      const gid = g2 && (g2.id || g2.conversation);
      if (!gid || st.dead) return;
      const a = await rpc('recado.community.addGroup', { id, conversation: gid });
      if (bad(a)) { UI.toast(errText(a)); return; }
      st.c = a; paint(); emitLive('community', {});
    }
    async function removeGroup(x) {
      if (!(await UI.confirm(`Retirar «${x.title}»?`, 'O grupo continua a existir, só deixa de pertencer a esta comunidade.', 'Retirar', true))) return;
      const r = await rpc('recado.community.removeGroup', { id, conversation: x.id });
      if (bad(r)) { UI.toast(errText(r)); return; }
      if (r.left) { UI.pop(win); emitLive('community', {}); return; }
      st.c = r; paint(); emitLive('community', {});
    }
    async function leave() {
      if (!(await UI.confirm(`Sair de ${st.c.name}?`, 'Sais do grupo de anúncios e de todos os grupos desta comunidade.', 'Sair', true))) return;
      const r = await rpc('recado.community.leave', { id });
      if (bad(r)) { UI.toast(errText(r)); return; }
      UI.toast(r.deleted ? 'Comunidade apagada (ficou sem membros)' : 'Saíste da comunidade'); emitLive('community', {}); UI.pop(win);
    }
    async function destroy() {
      if (!(await UI.confirm(`Apagar ${st.c.name}?`, 'O grupo de anúncios é apagado. Os outros grupos continuam a existir, fora da comunidade.', 'Apagar', true))) return;
      const r = await rpc('recado.community.delete', { id });
      if (bad(r)) { UI.toast(errText(r)); return; }
      UI.toast('Comunidade apagada'); emitLive('community', {}); UI.pop(win);
    }
    reload();
    return UI.push(win, v);
  }

  function membersView(win, c) {
    const v = UI.view({ title: 'Membros', back: true, cls: 'rcu-root' });
    const body = UI.el('<div class="rcu-body"></div>'); v.content.appendChild(body); body.appendChild(UI.skeleton('list', 5));
    let dead = false;
    v.opts.onPop = () => { dead = true; };
    const paint = r => {
      if (dead) return;
      body.innerHTML = '';
      if (bad(r)) { body.appendChild(UI.empty('users', 'Indisponível', errText(r))); return; }
      const items = toArr(r.items);
      if (!items.length) { body.appendChild(UI.empty('users', plural(+r.count || 0, 'membro', 'membros'), 'Só os administradores veem a lista de membros da comunidade.')); return; }
      const adm = items.filter(x => x.role === 'admin'), mem = items.filter(x => x.role !== 'admin');
      /* administradores gerem administradores (recado.community.admin): tocar num membro nomeia, num administrador retira */
      const row = x => ({ label: x.isMe ? 'Tu' : nameOf(x.number, x.name || x.number), sub: x.owner ? `${x.number} · criou a comunidade` : x.number, chevron: false,
        value: x.role === 'admin' ? 'Admin' : '', onTap: () => manage(x) });
      const sections = [{ header: 'Administradores', items: adm.map(row) }];
      if (mem.length) sections.push({ header: plural(mem.length, 'membro', 'membros'), items: mem.map(row) });
      sections[sections.length - 1].footer = 'Membros = quem está nos grupos da comunidade. Os administradores escrevem os anúncios, editam a comunidade e juntam grupos. Toca numa pessoa para mudar o papel dela.';
      body.appendChild(UI.list(sections));
    };
    async function manage(x) {
      const isAdm = x.role === 'admin';
      const label = x.isMe ? (isAdm ? 'Deixar de ser administrador' : null) : (isAdm ? 'Retirar administrador' : 'Tornar administrador');
      if (!label) return;
      const a = await UI.actionSheet({ title: x.isMe ? 'Tu' : nameOf(x.number, x.name || x.number), buttons: [{ label, danger: isAdm, value: 'role' }] });
      if (a !== 'role' || dead) return;
      const r = await rpc('recado.community.admin', { id: c.id, number: x.number, on: !isAdm });
      if (bad(r)) { UI.toast(errText(r)); return; }
      UI.toast(isAdm ? (x.isMe ? 'Deixaste de ser administrador' : 'Deixou de ser administrador') : 'Agora é administrador da comunidade');
      paint(r); emitLive('community', {});
    }
    rpc('recado.community.members', { id: c.id }).then(paint);
    return UI.push(win, v);
  }

  function communityForm(win, c, after) {
    const st = { image: null, busy: false };
    const v = UI.view({ title: c ? 'Editar comunidade' : 'Nova comunidade', back: true, cls: 'rcu-root rcu-form', right: [{ label: c ? 'Guardar' : 'Criar', bold: true, onTap: () => save() }] });
    const f = UI.el(`<div class="rcu-body"><div class="rcu-form-av sq"><div class="rcu-form-img"></div><span>${c ? 'Mudar imagem' : 'Adicionar imagem'}</span></div>
      <div class="rcu-field"><label>Nome da comunidade</label><input class="n" type="text" maxlength="40" placeholder="Ex.: Moradores de Mirror Park"></div>
      <div class="rcu-field"><label>Descrição</label><textarea class="d" maxlength="300" rows="3" placeholder="Para que serve esta comunidade?"></textarea></div>
      <div class="rcu-note small">Ao criar, nasce um grupo de <b>Anúncios</b> onde só os administradores escrevem. Depois podes juntar grupos do Zapp de que és administrador.</div>
      <div class="rcu-btn wide go">${c ? 'Guardar alterações' : 'Criar comunidade'}</div></div>`);
    v.content.appendChild(f);
    const img = f.querySelector('.rcu-form-img'), n = f.querySelector('.n'), d = f.querySelector('.d');
    if (c) { n.value = c.name || ''; d.value = c.description || ''; if (c.avatar) paintMedia(img, c.avatar); }
    if (!(c && c.avatar)) img.innerHTML = g('users', 28);
    f.querySelector('.rcu-form-av').onclick = async () => { const url = await pickImage(win, 'Imagem da comunidade'); if (!url) return; let sq = url; try { sq = await Photos.square(url, 512, .82) || url; } catch (e) {} st.image = sq; img.innerHTML = ''; img.style.backgroundImage = UI.img(sq); img.classList.add('has-img'); };
    f.querySelector('.go').onclick = () => save();
    async function save() {
      if (st.busy) return;
      const name = n.value.trim(); if (!name) { UI.toast(ERR.name); return; }
      st.busy = true; v.classList.add('busy');
      let avatar;
      if (st.image) { const up = await uploadImage(st.image); if (up.error) { st.busy = false; v.classList.remove('busy'); UI.toast(errText(up)); return; } avatar = up.mediaId; }
      const r = await rpc(c ? 'recado.community.update' : 'recado.community.create', c ? { id: c.id, name, description: d.value.trim(), avatar } : { name, description: d.value.trim() || undefined, avatar });
      st.busy = false; v.classList.remove('busy');
      if (bad(r)) { UI.toast(errText(r)); return; }
      emitLive('community', {});
      UI.pop(win);
      if (c) { if (after) after(); UI.toast('Comunidade atualizada'); }
      else setTimeout(() => openCommunity(win, r.id), 430);
    }
    return UI.push(win, v);
  }

  /* ============================================================
     API e registo no Recado
     ============================================================ */
  const api = { updatesView, communitiesView, statusComposer, openStatus, openChannel, openCommunity, channelDirectory,
    /* extras para os outros pacotes (RA/RB): anel de estado de um número e refrescar */
    hasStatus: number => { const d = cache.status; if (!d) return null; if (number === me().number) return toArr(d.mine && d.mine.items).length ? 'seen' : null; const u = toArr(d.updates).find(x => x.number === number); return u ? (u.allSeen ? 'seen' : 'new') : null; },
    refresh: () => emitLive('status', {}), fetchMedia, _cache: cache };

  let registered = false;
  function register() {
    if (registered || !window.Recado) return;
    const Rc = window.Recado;
    try { if (typeof Rc.register === 'function') Rc.register('updates', api); } catch (e) { console.error('[apex_phone] Recado.register updates', e); }
    try {
      if (typeof Rc.registerTab === 'function') {
        Rc.registerTab('updates', { icon: 'sparkles', label: 'Atualizações', order: 10, view: win => updatesView(win) });
        Rc.registerTab('communities', { icon: 'users', label: 'Comunidades', order: 20, view: win => communitiesView(win) });
      }
    } catch (e) { console.error('[apex_phone] Recado.registerTab', e); }
    registered = true;
  }
  /* ---------- notificações do servidor destes ecrãs ----------
     Menção num estado (data { status, owner }, ação 'recado_status_view') e publicação de canal (data { channel, post }).
     O recado.js só encaminha conversas (data.conversation/number) e ignora estas; o Notify abre a app no notif:open
     e aqui espera-se pela janela do Recado para abrir o estado ou o canal por cima. */
  function routeNotif(data, openApp) {
    if (!data || typeof data !== 'object') return;
    const owner = data.owner != null ? String(data.owner).slice(0, 20) : '', channel = Math.floor(+data.channel) || 0;
    if (!(data.status && owner) && !(channel > 0)) return;
    /* no notif:open quem abre a app é o Notify (logo a seguir ao evento); o botão da notificação não abre nada */
    if (openApp) { try { if (window.System && System.currentApp && System.currentApp() !== 'recado' && App.get('recado')) System.openApp('recado'); } catch (e) {} }
    let tries = 0;
    const t = setInterval(() => {
      const w = R() && R().win;
      if (w && winShown(w) && w.querySelector('.nav-stack')) {
        clearInterval(t);
        if (data.status && owner) openStatus(w, owner); else openChannel(w, channel);
      } else if (++tries > 30) clearInterval(t);
    }, 150);
  }
  Bridge.on('notif:open', n => { if (n && n.app === 'recado' && n.data) routeNotif(n.data, false); });
  Bridge.on('notif:action', d => { if (d && d.app === 'recado' && d.action === 'recado_status_view') routeNotif(d.data, true); });

  /* o recado.js avisa com 'recado:ready' quando define o Recado; o DOMContentLoaded é a rede de segurança */
  if (window.Recado) register();
  else { Bridge.on('recado:ready', register); document.addEventListener('DOMContentLoaded', register); window.addEventListener('load', register); }

  return api;
})();

/* ============================================================
   MOCKS DO BROWSER (LocalDB) - as mesmas regras e respostas do server/recado_social.lua, com estados,
   canais ("LSPD Informa", "Weazel News"…) e uma comunidade de exemplo. As imagens de exemplo são
   desenhadas num canvas (nada vem da internet) e ficam na tabela 'media' do mock do messages.js.
   ============================================================ */
(() => {
  if (!window.LocalDB || typeof LocalDB.register !== 'function') return;
  const T = LocalDB.T, G = Store.global || Store, now = () => Date.now();
  const my = () => LocalDB.me().number, cid = () => LocalDB.cid;
  const int = v => { const n = Math.floor(+v); return isFinite(n) && n > 0 ? n : 0; };
  const fail = (error, extra) => Object.assign({ ok: false, error }, extra || {});
  const str = (v, max) => (typeof v === 'string' || typeof v === 'number') ? [...String(v).trim()].slice(0, max).join('') : '';
  const seq = key => { const n = (+G.get('mock:rcu:' + key, 0) || 0) + 1; G.set('mock:rcu:' + key, n); return n; };
  const HOURS = 24, MAXDAY = 30, CH_MAX_ADMINS = 8, CH_PER_OWNER = 5, CM_MAX_GROUPS = 20, CM_PER_OWNER = 3;
  const BG = ['indigo', 'ciano', 'aurora', 'coral', 'menta', 'ambar', 'grafite', 'ameixa', 'oceano', 'rosa'], FONT = ['sans', 'serif', 'mono', 'bold', 'round'];
  const REACT = ['❤️', '👍', '😂', '😮', '😢', '🙏', '🔥', '👏', '🎉', '💯'];
  const cleanNum = v => { const s = str(v, 20); return /^[\d+\-.() ]{3,20}$/.test(s) && (s.match(/\d/g) || []).length >= 3 ? s : null; };
  const nums = (raw, max, self) => { if (raw == null) return []; if (!Array.isArray(raw)) return null; const out = []; for (const v of raw) { const n = cleanNum(v); if (!n) return null; if (n !== self && !out.includes(n)) out.push(n); if (out.length > max) return null; } return out; };
  const contactsOf = () => T('contacts').all();
  const cname = n => (contactsOf().find(c => c.number === n) || {}).name || null;
  const blockedByMe = n => T('blocks').all().some(b => b.number === n);
  const mediaOwn = (v, kind) => { const id = int(v); const m = id && T('media').all().find(x => x.id === id && x.complete && x.owner === cid()); return m && (!kind || m.kind === kind) ? m : null; };

  /* ---------- imagens de exemplo (canvas) ---------- */
  const DEMO = { 910001: 'sunset', 910002: 'news', 910003: 'garage', 910004: 'park' };
  function demoImage(kind) {
    const c = document.createElement('canvas'); c.width = 360; c.height = 640; const x = c.getContext('2d');
    const lg = (y0, y1, a, b) => { const gr = x.createLinearGradient(0, y0, 0, y1); gr.addColorStop(0, a); gr.addColorStop(1, b); return gr; };
    if (kind === 'sunset' || kind === 'park') {
      x.fillStyle = kind === 'park' ? lg(0, 640, '#7DD3FC', '#BBF7D0') : lg(0, 640, '#F97316', '#6D28D9'); x.fillRect(0, 0, 360, 640);
      x.fillStyle = kind === 'park' ? 'rgba(255,255,255,.9)' : '#FDE68A'; x.beginPath(); x.arc(250, 250, 70, 0, Math.PI * 2); x.fill();
      x.fillStyle = kind === 'park' ? '#166534' : '#1E1B4B';
      [[0, 420, 60, 220], [55, 360, 50, 280], [100, 450, 40, 190], [135, 300, 58, 340], [190, 400, 45, 240], [230, 340, 55, 300], [282, 430, 78, 210]].forEach(r => x.fillRect(...r));
    } else if (kind === 'news') {
      x.fillStyle = lg(0, 640, '#0F172A', '#1E3A8A'); x.fillRect(0, 0, 360, 640);
      x.fillStyle = '#F97316'; x.globalAlpha = .85; x.beginPath(); x.moveTo(60, 380); x.quadraticCurveTo(120, 180, 180, 330); x.quadraticCurveTo(240, 200, 300, 380); x.fill(); x.globalAlpha = 1;
      x.fillStyle = '#0B1120'; x.fillRect(0, 380, 360, 260);
      x.fillStyle = '#DC2626'; x.fillRect(0, 520, 360, 58); x.fillStyle = '#fff'; x.font = 'bold 26px sans-serif'; x.fillText(window.L && L.t ? L.t('ÚLTIMA HORA') : 'ÚLTIMA HORA', 20, 558);   /* na tela: traduz-se aqui */
    } else {
      x.fillStyle = lg(0, 640, '#111827', '#374151'); x.fillRect(0, 0, 360, 640);
      x.fillStyle = '#25D366'; x.beginPath(); x.moveTo(40, 400); x.lineTo(90, 330); x.lineTo(260, 320); x.lineTo(320, 400); x.lineTo(320, 440); x.lineTo(40, 440); x.fill();
      x.fillStyle = '#0F172A'; [[95, 440], [265, 440]].forEach(([cx, cy]) => { x.beginPath(); x.arc(cx, cy, 30, 0, Math.PI * 2); x.fill(); });
      x.fillStyle = 'rgba(255,255,255,.08)'; for (let i = 0; i < 8; i++) x.fillRect(0, 80 + i * 26, 360, 3);
    }
    return c.toDataURL('image/jpeg', .72);
  }
  function ensureDemo(id) {
    if (!DEMO[id]) return;
    const rows = T('media').all(); if (rows.some(r => r.id === id)) return;
    let data = null; try { data = demoImage(DEMO[id]); } catch (e) { return; }
    rows.push({ id, owner: 'npc:demo', kind: 'image', mime: 'image/jpeg', data, size: data.length, duration: null, meta: null, complete: 1, created: now() });
    T('media').set(rows);
  }

  /* ---------- sementes ---------- */
  const convs = () => T('conversations'), members = () => T('conversation_members');
  const nextConv = () => [convs().all().map(x => +x.id), members().all().map(x => +x.conversation_id), T('messages').all().map(x => +x.conversation_id || 0)].reduce((mx, l) => l.reduce((a, n) => (n > a ? n : a), mx), 0) + 1;
  const sysMsg = (conv, by, text, type, extra) => { const r = T('messages').insert(Object.assign({ app: 'recado', sender: by, receiver: 'g:' + conv, type: type || 'system', content: text, payload: null, read: false, created: now(), reply_to: null, conversation_id: conv, delivered_at: null, read_at: null, edited_at: null, deleted_sender: 0, deleted_receiver: 0, deleted_all: null }, extra || {})); const all = convs().all(); const c = all.find(x => +x.id === conv); if (c) { c.last_id = r.id; convs().set(all); } return r; };
  function seed() {
    const t = now(), me = my();
    if (t - (+G.get('mock:rcu:seededAt', 0) || 0) < 20 * 3600000 && G.get('mock:rcu:v', 0) === 2) return;
    const first = G.get('mock:rcu:v', 0) !== 2;
    T('rc_status').set(T('rc_status').all().filter(s => s.owner === me && s.expires > t));
    const add = (owner, kind, extra, agoMin) => T('rc_status').insert(Object.assign({ id: seq('status'), owner, owner_cid: 'npc:' + owner, kind, content: null, media_id: null, bg: null, font: null, duration: null, privacy: 'contacts', audience: [], mentions: [], reshare_of: null, created: t - agoMin * 60000, expires: t - agoMin * 60000 + HOURS * 3600000 }, extra));
    add('555-0101', 'text', { content: 'Bom dia, família! ☀️ Almoço de domingo cá em casa às 13h.', bg: 'coral', font: 'round' }, 95);
    add('555-0101', 'text', { content: 'Não se esqueçam da sobremesa 🍰', bg: 'ambar', font: 'sans' }, 61);
    add('555-0303', 'image', { media_id: 910001, content: 'Fim de turno com esta vista 🌇' }, 40);
    add('555-0177', 'text', { content: 'O teu Sultan já está pronto! Passa cá quando quiseres 🔧', bg: 'indigo', font: 'bold', mentions: [me] }, 12);
    add('555-0666', 'sticker', { content: 'cidade:taxi', bg: 'grafite' }, 22);
    const seen = add('555-0420', 'text', { content: 'Consultas gratuitas esta semana no escritório de Rockford Hills.', bg: 'oceano', font: 'serif' }, 300);
    T('rc_status_views').insert({ status_id: seen.id, viewer: me, liked: false, created: t - 3600000 });
    if (first) {
      T('rc_channels').set([]); T('rc_channel_admins').set([]); T('rc_channel_followers').set([]); T('rc_channel_posts').set([]); T('rc_channel_reactions').set([]); T('rc_channel_votes').set([]); T('rc_communities').set([]);
      const ch = (name, description, owner, verified, followers, extra) => { const c = { id: seq('channel'), name, description, avatar: null, owner, owner_cid: 'npc:' + owner, code: Math.random().toString(36).slice(2, 10).toUpperCase(), listed: true, verified, followers, created: t - 90 * 864e5, updated: t, last_post: null }; Object.assign(c, extra || {}); T('rc_channels').insert(c); T('rc_channel_admins').insert({ channel_id: c.id, number: owner, role: 'owner', added: c.created }); return c; };
      const post = (c, type, content, payload, agoMin, media) => { const p = T('rc_channel_posts').insert({ id: seq('post'), channel_id: c.id, author: c.owner, type, content, payload: payload || null, media_id: media || null, created: t - agoMin * 60000, edited: null }); const all = T('rc_channels').all(); const x = all.find(y => y.id === c.id); if (x) { x.last_post = Math.max(x.last_post || 0, p.created); T('rc_channels').set(all); } return p; };
      const lspd = ch('LSPD Informa', 'Avisos oficiais do departamento de polícia de Los Santos. Em emergência liga 911.', '555-0100', true, 12840);
      const weazel = ch('Weazel News', 'Notícias 24/7 de Los Santos e Blaine County.', '555-0800', true, 48210);
      const custom = ch('Los Santos Customs', 'Kits, pinturas e novidades da oficina.', '555-0666', false, 3120);
      ch('Rádio Vinewood FM', 'A música que se ouve em Vinewood, com passatempos semanais.', '555-0880', false, 890);
      ch('Câmara Municipal de Los Santos', 'Obras, eventos e serviços da cidade.', '555-0311', true, 22150);
      post(lspd, 'text', '⚠️ Corte de estrada na Vinewood Blvd entre as 21h e as 23h por operação policial. Usem a Hawick Ave.', null, 180);
      post(lspd, 'text', 'Recuperámos 3 veículos roubados em Davis. Obrigado a quem ligou 🙏', null, 75);
      const poll = post(lspd, 'poll', null, { question: 'Que horário preferem para as sessões de esclarecimento no bairro?', options: ['Manhã', 'Tarde', 'Noite'], multi: false }, 30);
      post(weazel, 'image', 'ÚLTIMA HORA: incêndio controlado em La Mesa. Sem feridos.', null, 50, 910002);
      post(weazel, 'text', 'Previsão: sol e 27 °C em toda a cidade este fim de semana ☀️', null, 20);
      post(custom, 'image', 'Chegaram os novos kits de performance 🏁', null, 240, 910003);
      T('rc_channel_followers').insert({ channel_id: lspd.id, number: me, muted: true, last_read: 0, created: t - 5 * 864e5 });
      T('rc_channel_followers').insert({ channel_id: weazel.id, number: me, muted: false, last_read: 0, created: t - 9 * 864e5 });
      [['555-0101', '❤️'], ['555-0303', '👍'], ['555-0420', '👍']].forEach(([n, e], i) => T('rc_channel_reactions').insert({ post_id: poll.id - 1 - (i % 2), number: n, emoji: e, created: t }));
      [['555-0101', '1'], ['555-0303', '2'], ['555-0420', '1'], ['555-0177', '0']].forEach(([n, o]) => T('rc_channel_votes').insert({ post_id: poll.id, number: n, options: o, created: t }));
      /* comunidade de exemplo: anúncios + dois grupos (num deles estou eu) */
      const ann = nextConv();
      convs().insert({ id: ann, app: 'recado', title: 'Bairro de Mirror Park', avatar: null, created_by: '555-0420', created: t - 20 * 864e5, last_id: null, kind: 'announce', send_policy: 'admins', edit_policy: 'admins', community_id: 1, description: null });
      const g1 = ann + 1, g2 = ann + 2;
      convs().insert({ id: g1, app: 'recado', title: 'Segurança do bairro', avatar: null, created_by: '555-0420', created: t - 19 * 864e5, last_id: null, kind: 'group', send_policy: 'all', edit_policy: 'admins', community_id: 1 });
      convs().insert({ id: g2, app: 'recado', title: 'Mercado de sábado', avatar: null, created_by: '555-0420', created: t - 18 * 864e5, last_id: null, kind: 'group', send_policy: 'all', edit_policy: 'admins', community_id: 1 });
      const mem = (conv, member, role) => members().insert({ conversation_id: conv, member, role, joined: t - 18 * 864e5, last_read_id: null, left_at: null });
      mem(ann, '555-0420', 'admin'); mem(ann, me, 'member'); mem(ann, '555-0101', 'member'); mem(ann, '555-0303', 'member');
      mem(g1, '555-0420', 'admin'); mem(g1, me, 'member'); mem(g1, '555-0303', 'member');
      mem(g2, '555-0420', 'admin'); mem(g2, '555-0101', 'member');
      T('rc_communities').insert({ id: 1, name: 'Bairro de Mirror Park', description: 'Moradores, eventos e segurança do bairro.', avatar: 910004, owner: '555-0420', owner_cid: 'npc:555-0420', announce_id: ann, created: t - 20 * 864e5, updated: t });
      G.set('mock:rcu:community', 1);
      sysMsg(ann, '555-0420', 'Comunidade «Bairro de Mirror Park» criada. Só administradores enviam anúncios.');
      sysMsg(ann, '555-0420', 'Reunião de moradores quinta-feira às 20h no parque 🌳', 'text');
      sysMsg(g1, '555-0303', 'Alguém viu a carrinha branca parada na esquina?', 'text');
      G.set('mock:rcu:v', 2);
    }
    G.set('mock:rcu:seededAt', t);
  }

  /* ---------- estados ---------- */
  const prefsOf = n => T('rc_status_prefs').all().find(p => p.number === n) || { number: n, privacy: 'contacts', audience: [], muted: [] };
  const savePrefs = p => { const all = T('rc_status_prefs').all().filter(x => x.number !== p.number); all.push(p); T('rc_status_prefs').set(all); };
  /* "o dono tem-me nos contactos": no browser os contactos semeados fazem de conta que sim */
  const visible = (s, me) => {
    if (s.owner === me) return true;
    if (blockedByMe(s.owner)) return false;
    const mentioned = (s.mentions || []).includes(me);
    if (s.privacy === 'only') return (s.audience || []).includes(me) || mentioned;
    if (s.privacy === 'except' && (s.audience || []).includes(me)) return false;
    return !!cname(s.owner) || mentioned;
  };
  const shapeS = (s, mine) => { const o = { id: s.id, owner: s.owner, kind: s.kind, content: s.content, mediaId: s.media_id || null, bg: s.bg, font: s.font, duration: s.duration, created: s.created, expires: s.expires, reshareOf: s.reshare_of || null }; if (mine) { o.mine = true; o.privacy = s.privacy; if ((s.audience || []).length) o.audience = s.audience; if ((s.mentions || []).length) o.mentions = s.mentions; } return o; };
  const liveStatus = id => T('rc_status').all().find(s => s.id === int(id) && s.expires > now());

  LocalDB.register('recado.status.list', () => {
    seed();
    const t = now(), me = my(), views = T('rc_status_views').all(), prefs = prefsOf(me);
    const all = T('rc_status').all().filter(s => s.expires > t).sort((a, b) => a.id - b.id);
    const mine = all.filter(s => s.owner === me).map(s => Object.assign(shapeS(s, true), { views: views.filter(v => v.status_id === s.id).length, likes: views.filter(v => v.status_id === s.id && v.liked).length }));
    const groups = {}, order = [];
    all.filter(s => s.owner !== me && (cname(s.owner) || (s.mentions || []).includes(me)) && visible(s, me)).forEach(s => {
      let gr = groups[s.owner];
      if (!gr) { gr = groups[s.owner] = { number: s.owner, name: cname(s.owner), items: [], allSeen: true, last: 0 }; if ((prefs.muted || []).includes(s.owner)) gr.muted = true; order.push(gr); }
      const v = views.find(x => x.status_id === s.id && x.viewer === me);
      const o = shapeS(s, false); o.viewed = !!v; if (v && v.liked) o.liked = true; if ((s.mentions || []).includes(me)) o.mentionedMe = true;
      if (!v) gr.allSeen = false; gr.last = Math.max(gr.last, s.created); gr.items.push(o);
    });
    order.sort((a, b) => (a.allSeen !== b.allSeen ? (a.allSeen ? 1 : -1) : b.last - a.last));
    return { ok: true, mine: { items: mine, prefs: { privacy: prefs.privacy, audience: prefs.audience || [] } }, updates: order, hours: HOURS, maxPerDay: MAXDAY };
  });

  LocalDB.register('recado.status.add', d => {
    seed();
    const me = my(), t = now();
    const kind = ['text', 'image', 'audio', 'sticker'].includes(d.kind) ? d.kind : null; if (!kind) return fail('badtype');
    const privacy = d.privacy == null ? 'contacts' : d.privacy; if (!['contacts', 'except', 'only'].includes(privacy)) return fail('privacy');
    let audience = nums(d.list, 256, me); if (!audience) return fail('privacy'); if (privacy === 'contacts') audience = []; if (privacy === 'only' && !audience.length) return fail('privacy');
    let mentions = nums(d.mentions, 10, me); if (!mentions) return fail('invalid');
    mentions = mentions.filter(n => !!cname(n));   /* como no servidor: só se mencionam contactos */
    const row = { kind, content: null, media_id: null, bg: null, font: null, duration: null };
    if (kind === 'text') { row.content = str(d.content, 700); if (!row.content) return fail('empty'); row.bg = d.bg == null ? 'indigo' : d.bg; if (!BG.includes(row.bg)) return fail('badbg'); row.font = d.font == null ? 'sans' : d.font; if (!FONT.includes(row.font)) return fail('invalid'); }
    else if (kind === 'image' || kind === 'audio') { const m = mediaOwn(d.mediaId, kind); if (!m) return fail('media'); row.media_id = m.id; if (kind === 'audio') { row.duration = m.duration; row.bg = BG.includes(d.bg) ? d.bg : 'grafite'; } if (d.content) row.content = str(d.content, 700); }
    else { const c = str(d.content, 40); if (!/^[\w-]+:[\w-]+$/.test(c)) return fail('invalid'); row.content = c; row.bg = BG.includes(d.bg) ? d.bg : 'grafite'; }
    if (T('rc_status').all().filter(s => s.owner === me && s.created > t - 864e5).length >= MAXDAY) return fail('limit', { max: MAXDAY });
    const s = T('rc_status').insert(Object.assign({ id: seq('status'), owner: me, owner_cid: cid(), privacy, audience, mentions, reshare_of: null, created: t, expires: t + HOURS * 3600000 }, row));
    const p = prefsOf(me); p.privacy = privacy; p.audience = audience; savePrefs(p);
    if (mentions.length) mentions.forEach(n => Bridge.dbg('recado', 'menção (mock) a', n));
    return Object.assign(shapeS(s, true), { ok: true, views: 0, likes: 0 });
  });
  LocalDB.register('recado.status.view', d => { const s = liveStatus(d.id), me = my(); if (!s || !visible(s, me)) return fail('notfound'); if (s.owner !== me && !T('rc_status_views').all().some(v => v.status_id === s.id && v.viewer === me)) T('rc_status_views').insert({ status_id: s.id, viewer: me, liked: false, created: now() }); return { ok: true, id: s.id }; });
  LocalDB.register('recado.status.like', d => { const s = liveStatus(d.id), me = my(); if (!s || !visible(s, me)) return fail('notfound'); if (s.owner === me) return fail('invalid'); const on = d.on === true || d.on === 1; const all = T('rc_status_views').all(); const v = all.find(x => x.status_id === s.id && x.viewer === me); if (v) v.liked = on; else all.push({ id: LocalDB.uid(), status_id: s.id, viewer: me, liked: on, created: now() }); T('rc_status_views').set(all); return { ok: true, id: s.id, liked: on }; });
  LocalDB.register('recado.status.viewers', d => { const s = liveStatus(d.id); if (!s || s.owner !== my()) return fail('notfound'); const v = T('rc_status_views').all().filter(x => x.status_id === s.id).sort((a, b) => b.created - a.created); return { ok: true, id: s.id, items: v.map(x => ({ number: x.viewer, name: cname(x.viewer), liked: x.liked || undefined, at: x.created })), count: v.length, likes: v.filter(x => x.liked).length }; });
  LocalDB.register('recado.status.delete', d => { const s = liveStatus(d.id); if (!s || s.owner !== my()) return fail('notfound'); T('rc_status').remove(x => x.id === s.id); T('rc_status_views').remove(x => x.status_id === s.id); return { ok: true, id: s.id }; });
  LocalDB.register('recado.status.reply', d => {
    const s = liveStatus(d.id), me = my(); const text = str(d.text, 1000);
    if (!int(d.id)) return fail('invalid'); if (!text) return fail('empty'); if (!s || !visible(s, me)) return fail('notfound'); if (s.owner === me) return fail('invalid'); if (blockedByMe(s.owner)) return fail('blocked');
    const quote = { id: s.id, owner: s.owner, kind: s.kind, bg: s.bg, preview: s.kind === 'text' ? String(s.content || '').slice(0, 90) : ({ image: '📷 Foto', audio: '🎤 Áudio', sticker: '✨ Autocolante' }[s.kind] || '') };
    let r = LocalDB.rpc('recado.send', { number: s.owner, type: 'text', content: text, payload: { status: quote } });
    if (r && typeof r.error === 'string' && r.error.startsWith('unknown')) r = LocalDB.rpc('messages.send', { app: 'recado', to: s.owner, type: 'text', content: text, payload: { status: quote } });
    if (!r || r.error || r.ok === false) return fail((r && r.error) || 'nosend');
    if (!T('rc_status_views').all().some(v => v.status_id === s.id && v.viewer === me)) T('rc_status_views').insert({ status_id: s.id, viewer: me, liked: false, created: now() });
    return { ok: true, id: s.id, number: s.owner, message: r.message || r };
  });
  LocalDB.register('recado.status.reshare', d => {
    const s = liveStatus(d.id), me = my(), t = now(); if (!s || !visible(s, me)) return fail('notfound'); if (!(s.mentions || []).includes(me)) return fail('notmentioned');
    if (T('rc_status').all().some(x => x.owner === me && x.reshare_of === s.id && x.expires > t)) return fail('already');
    const p = prefsOf(me);
    const n = T('rc_status').insert({ id: seq('status'), owner: me, owner_cid: cid(), kind: s.kind, content: s.content, media_id: s.media_id, bg: s.bg, font: s.font, duration: s.duration, privacy: p.privacy, audience: p.audience || [], mentions: [], reshare_of: s.id, created: t, expires: t + HOURS * 3600000 });
    return Object.assign(shapeS(n, true), { ok: true, views: 0, likes: 0 });
  });
  LocalDB.register('recado.status.mute', d => { const n = cleanNum(d.number), me = my(); if (!n || n === me) return fail('invalid'); const p = prefsOf(me); const on = d.on === true || d.on === 1; p.muted = (p.muted || []).filter(x => x !== n); if (on) p.muted.push(n); savePrefs(p); return { ok: true, number: n, muted: on }; });

  /* ---------- canais ---------- */
  const chRow = id => T('rc_channels').all().find(c => c.id === int(id));
  const roleOf = (id, n) => { const a = T('rc_channel_admins').all().find(x => x.channel_id === id && x.number === n); return a ? (a.role === 'owner' ? 'owner' : 'admin') : null; };
  const follOf = (id, n) => T('rc_channel_followers').all().find(x => x.channel_id === id && x.number === n) || null;
  const canView = (c, role, f) => c.listed || !!role || !!f;
  const lastOf = id => { const p = T('rc_channel_posts').all().filter(x => x.channel_id === id).sort((a, b) => b.id - a.id)[0]; return p ? { type: p.type, preview: String(p.content || (p.payload && p.payload.question) || '').slice(0, 90), created: p.created } : undefined; };
  const shapeC = (c, me, extra) => { const role = roleOf(c.id, me), f = follOf(c.id, me); const o = { id: c.id, name: c.name, description: c.description, avatar: c.avatar || null, verified: c.verified || undefined, listed: !!c.listed, followers: c.followers, created: c.created, lastPost: c.last_post, myRole: role, following: !!f }; if (f && f.muted) o.muted = true; if (role) o.code = c.code; if (f) o.unread = T('rc_channel_posts').all().filter(p => p.channel_id === c.id && p.id > (f.last_read || 0)).length; return Object.assign(o, extra || {}); };
  const shapeP = (p, me) => {
    const rs = T('rc_channel_reactions').all().filter(r => r.post_id === p.id), counts = {};
    rs.forEach(r => { counts[r.emoji] = (counts[r.emoji] || 0) + 1; });
    const o = { id: p.id, channel: p.channel_id, type: p.type, content: p.content, mediaId: p.media_id || null, created: p.created, edited: p.edited, myReaction: (rs.find(r => r.number === me) || {}).emoji };
    const list = Object.keys(counts).map(e => ({ emoji: e, n: counts[e] })).sort((a, b) => b.n - a.n); if (list.length) o.reactions = list;
    if (p.type === 'poll') { const vs = T('rc_channel_votes').all().filter(v => v.post_id === p.id); const c = {}; let mine; vs.forEach(v => String(v.options).split(',').forEach(k => { c[+k] = (c[+k] || 0) + 1; if (v.number === me) (mine = mine || []).push(+k); })); o.poll = { question: p.payload.question, options: p.payload.options.map((t, i) => ({ text: t, votes: c[i] || 0 })), multi: p.payload.multi || undefined, total: vs.length, mine }; }
    else if (p.payload && (p.type === 'audio' || p.type === 'sticker')) o.payload = p.payload;
    return o;
  };
  const access = (id, me) => { const c = chRow(id); if (!int(id)) return { err: fail('invalid') }; if (!c) return { err: fail('notfound') }; const role = roleOf(c.id, me), f = follOf(c.id, me); if (!canView(c, role, f)) return { err: fail('notfound') }; return { c, role, f }; };
  const patchCh = (id, patch) => { const all = T('rc_channels').all(); const c = all.find(x => x.id === id); if (c) Object.assign(c, patch); T('rc_channels').set(all); return c; };
  const code8 = () => Array.from({ length: 8 }, () => 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[Math.floor(Math.random() * 32)]).join('');

  LocalDB.register('recado.channel.create', d => {
    seed(); const me = my(), t = now();
    const name = str(d.name, 40); if (!name) return fail('name');
    const avatar = d.avatar ? mediaOwn(d.avatar, 'image') : null; if (d.avatar && !avatar) return fail('media');
    if (T('rc_channel_admins').all().filter(a => a.number === me && a.role === 'owner').length >= CH_PER_OWNER) return fail('limit', { max: CH_PER_OWNER });
    const c = T('rc_channels').insert({ id: seq('channel'), name, description: str(d.description, 300) || null, avatar: avatar ? avatar.id : null, owner: me, owner_cid: cid(), code: code8(), listed: true, verified: false, followers: 0, created: t, updated: t, last_post: null });
    T('rc_channel_admins').insert({ channel_id: c.id, number: me, role: 'owner', added: t });
    return Object.assign(shapeC(c, me), { ok: true });
  });
  LocalDB.register('recado.channel.update', d => {
    const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); const role = roleOf(c.id, me); if (!role) return fail('notadmin');
    const patch = { updated: now() };
    if (d.name != null) { const n = str(d.name, 40); if (!n) return fail('name'); patch.name = n; }
    if (d.description != null) patch.description = str(d.description, 300) || null;
    if (d.avatar != null) { if (d.avatar === false || d.avatar === 0 || d.avatar === '') patch.avatar = null; else { const m = mediaOwn(d.avatar, 'image'); if (!m && int(d.avatar) !== c.avatar) return fail('media'); if (m) patch.avatar = m.id; } }
    if (d.listed != null) { if (role !== 'owner') return fail('notowner'); patch.listed = !!d.listed; }
    return Object.assign(shapeC(patchCh(c.id, patch), me), { ok: true });
  });
  LocalDB.register('recado.channel.delete', d => { const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); if (roleOf(c.id, me) !== 'owner') return fail('notowner'); const pids = T('rc_channel_posts').all().filter(p => p.channel_id === c.id).map(p => p.id); T('rc_channel_reactions').remove(r => pids.includes(r.post_id)); T('rc_channel_votes').remove(r => pids.includes(r.post_id)); T('rc_channel_posts').remove(p => p.channel_id === c.id); T('rc_channel_followers').remove(f => f.channel_id === c.id); T('rc_channel_admins').remove(a => a.channel_id === c.id); T('rc_channels').remove(x => x.id === c.id); return { ok: true, id: c.id }; });
  LocalDB.register('recado.channel.get', d => { seed(); const me = my(), a = access(d.id, me); if (a.err) return a.err; const extra = {}; if (a.role) extra.admins = T('rc_channel_admins').all().filter(x => x.channel_id === a.c.id).map(x => ({ number: x.number, role: x.role, name: cname(x.number), added: x.added })); return Object.assign(shapeC(a.c, me, extra), { ok: true }); });
  LocalDB.register('recado.channel.list', d => {
    seed(); const me = my(), scope = ['mine', 'following', 'directory'].includes(d.scope) ? d.scope : 'following';
    let list = T('rc_channels').all();
    if (scope === 'mine') list = list.filter(c => roleOf(c.id, me));
    else if (scope === 'following') list = list.filter(c => follOf(c.id, me));
    else { const q = str(d.q, 40).toLowerCase(); list = list.filter(c => c.listed && (!q || c.name.toLowerCase().includes(q) || String(c.description || '').toLowerCase().includes(q))).sort((a, b) => (b.verified ? 1 : 0) - (a.verified ? 1 : 0) || b.followers - a.followers).slice(0, 50); }
    if (scope !== 'directory') list.sort((a, b) => (b.last_post || 0) - (a.last_post || 0));
    return list.map(c => shapeC(c, me, { last: lastOf(c.id) }));
  });
  const follow = (c, me) => { if (follOf(c.id, me)) return; const last = T('rc_channel_posts').all().filter(p => p.channel_id === c.id).reduce((m, p) => Math.max(m, p.id), 0); T('rc_channel_followers').insert({ channel_id: c.id, number: me, muted: true, last_read: last, created: now() }); patchCh(c.id, { followers: c.followers + 1 }); };
  LocalDB.register('recado.channel.follow', d => { const me = my(), a = access(d.id, me); if (a.err) return a.err; follow(a.c, me); return Object.assign(shapeC(chRow(a.c.id), me), { ok: true }); });
  LocalDB.register('recado.channel.unfollow', d => { const me = my(), c = chRow(d.id); if (!int(d.id)) return fail('invalid'); if (c && follOf(c.id, me)) { T('rc_channel_followers').remove(f => f.channel_id === c.id && f.number === me); patchCh(c.id, { followers: Math.max(0, c.followers - 1) }); } return { ok: true, id: int(d.id), following: false }; });
  LocalDB.register('recado.channel.mute', d => { const me = my(), id = int(d.id); const all = T('rc_channel_followers').all(); const f = all.find(x => x.channel_id === id && x.number === me); if (!f) return fail('notfound'); f.muted = d.on === true || d.on === 1; T('rc_channel_followers').set(all); return { ok: true, id, muted: f.muted }; });
  LocalDB.register('recado.channel.post', d => {
    const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); if (!roleOf(c.id, me)) return fail('notadmin');
    const type = ['text', 'image', 'audio', 'sticker', 'poll'].includes(d.type) ? d.type : null; if (!type) return fail('badtype');
    let content = null, payload = null, media = null;
    if (type === 'text') { content = str(d.content, 2000); if (!content) return fail('empty'); }
    else if (type === 'image' || type === 'audio') { const m = mediaOwn(d.mediaId, type); if (!m) return fail('media'); media = m.id; if (d.content) content = str(d.content, 1000); if (type === 'audio') payload = { duration: m.duration, waveform: m.meta && m.meta.waveform }; }
    else if (type === 'sticker') { const p = d.payload || {}; if (!/^[\w-]{1,20}$/.test(p.pack || '') || !/^[\w-]{1,20}$/.test(p.id || '')) return fail('invalid'); payload = { pack: p.pack, id: p.id }; }
    else { const p = d.payload || {}; const q = str(p.question, 200); if (!q) return fail('empty'); const o = (Array.isArray(p.options) ? p.options : []).map(x => str(x, 80)).filter(Boolean); if (o.length > 12) return fail('toomany', { max: 12 }); if (o.length < 2) return fail('invalid'); payload = { question: q, options: o, multi: p.multi === true }; }
    const post = T('rc_channel_posts').insert({ id: seq('post'), channel_id: c.id, author: me, type, content, payload, media_id: media, created: now(), edited: null });
    patchCh(c.id, { last_post: post.created });
    return Object.assign(shapeP(post, me), { ok: true });
  });
  LocalDB.register('recado.channel.posts', d => {
    const me = my(), a = access(d.id, me); if (a.err) return a.err;
    const before = int(d.before);
    const rows = T('rc_channel_posts').all().filter(p => p.channel_id === a.c.id && (!before || p.id < before)).sort((x, y) => y.id - x.id);
    const page = rows.slice(0, 30).reverse();
    if (a.f && !before && page.length) { const all = T('rc_channel_followers').all(); const f = all.find(x => x.channel_id === a.c.id && x.number === me); if (f) { f.last_read = Math.max(f.last_read || 0, page[page.length - 1].id); T('rc_channel_followers').set(all); } }
    return { ok: true, id: a.c.id, items: page.map(p => shapeP(p, me)), more: rows.length > 30, myRole: a.role, following: !!a.f };
  });
  const postAccess = (pid, me) => { const p = T('rc_channel_posts').all().find(x => x.id === int(pid)); if (!p) return { err: fail(int(pid) ? 'notfound' : 'invalid') }; const a = access(p.channel_id, me); return a.err ? a : Object.assign(a, { p }); };
  LocalDB.register('recado.channel.react', d => {
    const me = my(), a = postAccess(d.postId, me); if (a.err) return a.err; if (!a.f && !a.role) return fail('notfollowing');
    T('rc_channel_reactions').remove(r => r.post_id === a.p.id && r.number === me);
    if (d.emoji != null && d.emoji !== '' && d.emoji !== false) { if (!REACT.includes(d.emoji)) return fail('badreaction'); T('rc_channel_reactions').insert({ post_id: a.p.id, number: me, emoji: d.emoji, created: now() }); }
    const s = shapeP(a.p, me); return { ok: true, postId: a.p.id, reactions: s.reactions || [], myReaction: s.myReaction };
  });
  LocalDB.register('recado.channel.vote', d => {
    const me = my(), a = postAccess(d.postId, me); if (a.err) return a.err; if (!a.f && !a.role) return fail('notfollowing'); if (a.p.type !== 'poll') return fail('badtype');
    const n = a.p.payload.options.length; const ch = [];
    if (d.options != null && !Array.isArray(d.options)) return fail('invalid');
    for (const v of d.options || []) { const k = Math.floor(+v); if (!(k >= 0 && k < n)) return fail('invalid'); if (!ch.includes(k)) ch.push(k); }
    if (ch.length > 1 && !a.p.payload.multi) return fail('invalid');
    T('rc_channel_votes').remove(v => v.post_id === a.p.id && v.number === me);
    if (ch.length) T('rc_channel_votes').insert({ post_id: a.p.id, number: me, options: ch.sort((x, y) => x - y).join(','), created: now() });
    return { ok: true, postId: a.p.id, poll: shapeP(a.p, me).poll };
  });
  LocalDB.register('recado.channel.unpost', d => { const me = my(), a = postAccess(d.postId, me); if (a.err) return a.err; if (!a.role) return fail('notadmin'); T('rc_channel_reactions').remove(r => r.post_id === a.p.id); T('rc_channel_votes').remove(r => r.post_id === a.p.id); T('rc_channel_posts').remove(x => x.id === a.p.id); return { ok: true, postId: a.p.id }; });
  LocalDB.register('recado.channel.admins', d => {
    const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); const role = roleOf(c.id, me); if (!role) return fail(c.listed ? 'notadmin' : 'notfound');
    if (d.add != null || d.remove != null) {
      if (role !== 'owner') return fail('notowner');
      if (d.add != null) { const n = cleanNum(d.add); if (!n || n === me) return fail('invalid'); if (!roleOf(c.id, n)) { if (T('rc_channel_admins').all().filter(x => x.channel_id === c.id).length >= CH_MAX_ADMINS) return fail('full', { max: CH_MAX_ADMINS }); T('rc_channel_admins').insert({ channel_id: c.id, number: n, role: 'admin', added: now() }); } }
      if (d.remove != null) { const n = cleanNum(d.remove); if (!n) return fail('invalid'); if (roleOf(c.id, n) === 'owner') return fail('notowner'); T('rc_channel_admins').remove(x => x.channel_id === c.id && x.number === n); }
    }
    return { ok: true, id: c.id, items: T('rc_channel_admins').all().filter(x => x.channel_id === c.id).sort((x, y) => (x.role === 'owner' ? -1 : 1) - (y.role === 'owner' ? -1 : 1)).map(x => ({ number: x.number, role: x.role, name: cname(x.number), added: x.added })), max: CH_MAX_ADMINS, myRole: role };
  });
  LocalDB.register('recado.channel.followers', d => { const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); if (!roleOf(c.id, me)) return fail('notadmin'); const items = T('rc_channel_followers').all().filter(f => f.channel_id === c.id).map(f => ({ number: f.number, name: cname(f.number), since: f.created })); return { ok: true, id: c.id, items, count: c.followers }; });
  LocalDB.register('recado.channel.code', d => { const me = my(), c = chRow(d.id); if (!c) return fail('notfound'); if (!roleOf(c.id, me)) return fail('notadmin'); if (d.reset || !c.code) patchCh(c.id, { code: code8() }); return { ok: true, id: c.id, code: chRow(c.id).code }; });
  LocalDB.register('recado.channel.join', d => { seed(); const me = my(); const m = /([A-Za-z0-9]+)[^A-Za-z0-9]*$/.exec(typeof d.code === 'string' ? d.code : ''); const code = m ? m[1].toUpperCase() : ''; if (code.length < 6 || code.length > 12) return fail('invalid'); const c = T('rc_channels').all().find(x => x.code === code); if (!c) return fail('notfound'); if (!roleOf(c.id, me)) follow(c, me); return Object.assign(shapeC(chRow(c.id), me), { ok: true }); });

  /* ---------- comunidades ---------- */
  const cmRow = id => T('rc_communities').all().find(c => c.id === int(id));
  const activeIn = conv => members().all().filter(m => +m.conversation_id === conv && !m.left_at);
  const memberOf = (conv, n) => activeIn(conv).find(m => m.member === n) || null;
  const linked = c => convs().all().filter(g => +g.community_id === c.id && +g.id !== c.announce_id);
  const cmRole = (c, n) => { const m = memberOf(c.announce_id, n); if (m) return m.role === 'admin' ? 'admin' : 'member'; return linked(c).some(g => memberOf(+g.id, n)) ? 'member' : null; };
  function sync(c) {
    const want = new Set(); linked(c).forEach(g => activeIn(+g.id).forEach(m => want.add(m.member)));
    const all = members().all(), t = now();
    const cur = all.filter(m => +m.conversation_id === c.announce_id && !m.left_at);
    want.forEach(n => { if (!cur.some(m => m.member === n)) { const old = all.find(m => +m.conversation_id === c.announce_id && m.member === n); if (old) Object.assign(old, { left_at: null, role: 'member', joined: t }); else all.push({ id: LocalDB.uid(), conversation_id: c.announce_id, member: n, role: 'member', joined: t, last_read_id: null, left_at: null }); } });
    cur.forEach(m => { if (m.role !== 'admin' && !want.has(m.member)) m.left_at = t; });
    members().set(all);
  }
  function shapeCm(c, me) {
    const role = cmRole(c, me), ann = convs().all().find(g => +g.id === c.announce_id);
    const out = { ok: true, id: c.id, name: c.name, description: c.description, avatar: c.avatar || null, owner: c.owner === me || undefined, myRole: role, created: c.created, maxGroups: CM_MAX_GROUPS };
    if (ann) {
      const mine = memberOf(c.announce_id, me), msgs = T('messages').all().filter(m => +m.conversation_id === c.announce_id).sort((a, b) => a.id - b.id), last = msgs[msgs.length - 1];
      out.announce = { id: c.announce_id, title: ann.title, member: !!mine, unread: mine ? msgs.filter(m => m.id > (+mine.last_read_id || 0) && m.sender !== me && m.type !== 'system').length : 0,
        last: last ? { sender: last.sender, type: last.type, content: String(last.content || '').slice(0, 120), created: last.created } : undefined };
      out.memberCount = activeIn(c.announce_id).length;
    }
    out.groups = linked(c).map(g => { const m = memberOf(+g.id, me); return { id: +g.id, title: g.title, avatar: g.avatar || null, memberCount: activeIn(+g.id).length, joined: !!m || undefined, role: m ? (m.role === 'admin' ? 'admin' : 'member') : undefined }; });
    return out;
  }
  const cmAccess = (id, me) => { if (!int(id)) return { err: fail('invalid') }; const c = cmRow(id); if (!c) return { err: fail('notfound') }; sync(c); const role = cmRole(c, me); if (!role) return { err: fail('notfound') }; return { c, role }; };

  LocalDB.register('recado.community.create', d => {
    seed(); const me = my(), t = now();
    const name = str(d.name, 40); if (!name) return fail('name');
    const avatar = d.avatar ? mediaOwn(d.avatar, 'image') : null; if (d.avatar && !avatar) return fail('media');
    if (T('rc_communities').all().filter(c => c.owner === me).length >= CM_PER_OWNER) return fail('limit', { max: CM_PER_OWNER });
    const id = Math.max(+G.get('mock:rcu:community', 0) || 0, ...T('rc_communities').all().map(c => c.id), 0) + 1; G.set('mock:rcu:community', id);
    const ann = nextConv();
    convs().insert({ id: ann, app: 'recado', title: name, avatar: avatar ? avatar.id : null, created_by: me, created: t, last_id: null, kind: 'announce', send_policy: 'admins', edit_policy: 'admins', community_id: id, description: str(d.description, 300) || null });
    members().insert({ conversation_id: ann, member: me, role: 'admin', joined: t, last_read_id: null, left_at: null });
    const c = T('rc_communities').insert({ id, name, description: str(d.description, 300) || null, avatar: avatar ? avatar.id : null, owner: me, owner_cid: cid(), announce_id: ann, created: t, updated: t });
    sysMsg(ann, me, `Comunidade «${name}» criada. Só administradores enviam anúncios.`);
    return shapeCm(c, me);
  });
  LocalDB.register('recado.community.get', d => { seed(); const me = my(), a = cmAccess(d.id, me); return a.err || shapeCm(a.c, me); });
  LocalDB.register('recado.community.list', () => { seed(); const me = my(); return T('rc_communities').all().filter(c => { sync(c); return cmRole(c, me); }).sort((a, b) => b.id - a.id).map(c => { const s = shapeCm(c, me); delete s.ok; return s; }); });
  LocalDB.register('recado.community.update', d => {
    const me = my(), a = cmAccess(d.id, me); if (a.err) return a.err; if (a.role !== 'admin') return fail('notadmin');
    const all = T('rc_communities').all(), c = all.find(x => x.id === a.c.id), cv = convs().all(), ann = cv.find(g => +g.id === c.announce_id);
    if (d.name != null) { const n = str(d.name, 40); if (!n) return fail('name'); c.name = n; if (ann) ann.title = n; }
    if (d.description != null) c.description = str(d.description, 300) || null;
    if (d.avatar != null) { if (!d.avatar) { c.avatar = null; if (ann) ann.avatar = null; } else { const m = mediaOwn(d.avatar, 'image'); if (!m && int(d.avatar) !== c.avatar) return fail('media'); if (m) { c.avatar = m.id; if (ann) ann.avatar = m.id; } } }
    c.updated = now(); T('rc_communities').set(all); convs().set(cv);
    return shapeCm(c, me);
  });
  LocalDB.register('recado.community.addGroup', d => {
    const me = my(), a = cmAccess(d.id, me); if (a.err) return a.err; if (a.role !== 'admin') return fail('notadmin');
    const cv = convs().all(), g = cv.find(x => +x.id === int(d.conversation)); if (!int(d.conversation)) return fail('invalid');
    if (!g || g.app !== 'recado') return fail('notfound'); const m = memberOf(+g.id, me); if (!m || m.role !== 'admin') return fail('notgroupadmin');
    if (g.kind === 'announce') return fail('invalid'); if (g.community_id) return fail(+g.community_id === a.c.id ? 'already' : 'incommunity');
    if (linked(a.c).length >= CM_MAX_GROUPS) return fail('full', { max: CM_MAX_GROUPS });
    g.community_id = a.c.id; convs().set(cv);
    sysMsg(+g.id, me, `Este grupo passou a fazer parte da comunidade «${a.c.name}»`);
    sync(a.c); return shapeCm(a.c, me);
  });
  LocalDB.register('recado.community.removeGroup', d => {
    const me = my(), c = cmRow(d.id); if (!c) return fail('notfound');
    const cv = convs().all(), g = cv.find(x => +x.id === int(d.conversation)); if (!g || +g.community_id !== c.id) return fail('notfound');
    const role = cmRole(c, me), gm = memberOf(+g.id, me); if (role !== 'admin' && !(gm && gm.role === 'admin')) return fail('notadmin');
    g.community_id = null; convs().set(cv); sysMsg(+g.id, me, `Este grupo saiu da comunidade «${c.name}»`); sync(c);
    return cmRole(c, me) ? shapeCm(c, me) : { ok: true, id: c.id, left: true };
  });
  const cmMembers = (c, me, role) => {
    const rows = activeIn(c.announce_id); if (role !== 'admin') return { ok: true, id: c.id, count: rows.length };
    return { ok: true, id: c.id, count: rows.length, myRole: role, items: rows.slice().sort((x, y) => (x.role === 'admin' ? 0 : 1) - (y.role === 'admin' ? 0 : 1)).map(m => ({ number: m.member, role: m.role === 'admin' ? 'admin' : 'member', name: cname(m.member), isMe: m.member === me || undefined, owner: m.member === c.owner || undefined })) };
  };
  LocalDB.register('recado.community.members', d => { const me = my(), a = cmAccess(d.id, me); if (a.err) return a.err; return cmMembers(a.c, me, a.role); });
  LocalDB.register('recado.community.admin', d => {
    const me = my(), a = cmAccess(d.id, me); if (a.err) return a.err; if (a.role !== 'admin') return fail('notadmin');
    const target = cleanNum(d.number); if (!target) return fail('invalid');
    const on = d.on === true || d.on === 1, want = on ? 'admin' : 'member';
    const all = members().all(), row = all.find(m => +m.conversation_id === a.c.announce_id && m.member === target && !m.left_at);
    if (!row) return fail('notmember');
    if ((row.role === 'admin' ? 'admin' : 'member') !== want) {
      if (!on) { if (target === a.c.owner && me !== a.c.owner) return fail('notowner'); if (activeIn(a.c.announce_id).filter(m => m.role === 'admin').length <= 1) return fail('lastadmin'); }
      row.role = want; members().set(all);
      sysMsg(a.c.announce_id, me, on ? `${target} passou a administrar a comunidade` : `${target} deixou de administrar a comunidade`);
    }
    return cmMembers(a.c, me, cmRole(a.c, me));
  });
  LocalDB.register('recado.community.candidates', () => { const me = my(); return convs().all().filter(g => g.app === 'recado' && (g.kind == null || g.kind === 'group') && !g.community_id && (memberOf(+g.id, me) || {}).role === 'admin').map(g => ({ id: +g.id, title: g.title, avatar: g.avatar || null, memberCount: activeIn(+g.id).length })); });
  LocalDB.register('recado.community.leave', d => {
    const me = my(), c = cmRow(d.id); if (!c) return fail('notfound'); if (!cmRole(c, me)) return fail('notfound');
    const all = members().all(), t = now();
    all.forEach(m => { const conv = +m.conversation_id; if (m.member === me && !m.left_at && (conv === c.announce_id || linked(c).some(g => +g.id === conv))) { m.left_at = t; m.role = 'member'; } });
    members().set(all);
    const rest = activeIn(c.announce_id);
    if (!rest.length) { const cv = convs().all(); cv.forEach(g => { if (+g.community_id === c.id) g.community_id = null; }); convs().set(cv.filter(g => +g.id !== c.announce_id)); T('rc_communities').remove(x => x.id === c.id); return { ok: true, id: c.id, deleted: true }; }
    if (!rest.some(m => m.role === 'admin')) { const all2 = members().all(); const first = all2.find(m => +m.conversation_id === c.announce_id && m.member === rest[0].member && !m.left_at); if (first) first.role = 'admin'; members().set(all2); }
    return { ok: true, id: c.id, left: true };
  });
  LocalDB.register('recado.community.delete', d => {
    const me = my(), c = cmRow(d.id); if (!c) return fail('notfound'); if (c.owner !== me) return fail('notowner');
    const cv = convs().all(); cv.forEach(g => { if (+g.community_id === c.id && +g.id !== c.announce_id) g.community_id = null; }); convs().set(cv.filter(g => +g.id !== c.announce_id));
    members().remove(m => +m.conversation_id === c.announce_id); T('messages').remove(m => +m.conversation_id === c.announce_id); T('rc_communities').remove(x => x.id === c.id);
    return { ok: true, id: c.id, deleted: true };
  });

  /* ---------- media destes ecrãs ---------- */
  function canSeeMedia(md, me) {
    if (md.owner === cid()) return true;
    if (T('rc_status').all().some(s => s.media_id === md.id && s.expires > now() && visible(s, me))) return true;
    if (T('rc_channel_posts').all().concat(T('rc_channels').all().map(c => ({ media_id: c.avatar, channel_id: c.id }))).some(p => p.media_id === md.id && (() => { const c = chRow(p.channel_id); return c && canView(c, roleOf(c.id, me), follOf(c.id, me)); })())) return true;
    return T('rc_communities').all().some(c => c.avatar === md.id && cmRole(c, me));
  }
  LocalDB.register('recado.social.media', d => {
    seed();
    const id = int(d.id); if (!id) return fail('notfound');
    ensureDemo(id);
    const md = T('media').all().find(x => x.id === id && x.complete);
    if (!md || !canSeeMedia(md, my())) return fail('notfound');
    const chunk = 48000, total = Math.max(1, Math.ceil(md.data.length / chunk)), i = d.i == null ? 1 : int(d.i);
    if (i < 1 || i > total) return fail('badchunk', { total });
    return { id, kind: md.kind, mime: md.mime, duration: md.duration, meta: md.meta, i, total, size: md.data.length, data: md.data.slice((i - 1) * chunk, i * chunk) };
  });
})();
