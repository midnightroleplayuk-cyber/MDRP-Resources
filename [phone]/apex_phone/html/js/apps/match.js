/* ===================== MATCH - encontros entre jogadores =====================
   · Descobrir: pilha de cartões com física a sério - o cartão segue o dedo, roda a partir do ponto
     onde foi agarrado, os carimbos GOSTO / NÃO / SUPER LIKE "aterram" à medida que se arrasta, o
     cartão de trás cresce por baixo e os botões reagem ao gesto. Lançar com velocidade conta (um
     gesto rápido e curto chega), largar a meio volta com mola. Tocar nas metades muda de foto.
   · Perfil personalizável: o meu hino (música pesquisada no TubeMusic e tocável), artistas
     favoritos, interesses, básicos (altura, signo, trabalho…) e perguntas com resposta.
   · Match: ecrã de celebração com as duas fotos, corações e resposta rápida.
   Só transform/opacity animam (regra CEF); imagens por CSSOM (base64 nunca dentro de HTML). */
/* 2026-10-01 (pedido do dono: icones mais parecidos com as apps reais): a chama branca inteira sobre o degradê rosa e
   coral, como o do Tinder */
Icons.app.match = () => Icons.SVG(`<defs><linearGradient id="gMt" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FD2A7B"/><stop offset="1" stop-color="#FF6A4C"/></linearGradient></defs><rect width="100" height="100" fill="url(#gMt)"/>` + Icons.GL(`<path d="M53 16c1.6 10.2-2.2 16.6-7.8 22.6C38.9 45.3 31 52.6 31 63.2 31 75 40.2 84 51.5 84S71 75.4 71 63.6c0-9-4.4-15-8.6-19.4-.5 5.9-3.2 9.8-7 11 2.8-12.2-.6-28.4-2.4-39.2z" fill="#fff"/>`));

App.define('match', {
  name: 'Match', category: 'Redes sociais', needs: ['photos'],
  open(win) {
    const g = UI.g, esc = UI.esc, APP = 'match';
    let me = null, tabs = null, cards = [], chatOpen = null, dead = false, deck = null;
    const rpc = Bridge.rpc; const myPhone = () => System.player.phone;
    const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

    /* ---------- dados de personalização ---------- */
    const INTERESTS = ['Música', 'Viagens', 'Carros', 'Motas', 'Fitness', 'Gaming', 'Cinema', 'Séries', 'Fotografia', 'Café', 'Praia', 'Surf', 'Festas', 'Cozinhar', 'Arte', 'Moda', 'Animais', 'Leitura', 'Tatuagens', 'Dança', 'Natureza', 'Futebol', 'Basquetebol', 'Karaoke', 'Anime', 'Golfe', 'Pesca', 'Caminhadas', 'Vinho', 'Skate'];
    const PROMPTS = ['O meu plano perfeito em Los Santos é…', 'Não consigo viver sem…', 'A música que me define é…', 'Um facto aleatório sobre mim…', 'Vamos dar-nos bem se…', 'O meu sítio favorito da cidade é…'];
    const PICK = {
      want: { label: 'Procuro', emoji: '💘', opts: ['Relação séria', 'Algo casual', 'Novas amizades', 'Ainda a descobrir'] },
      zodiac: { label: 'Signo', emoji: '✨', opts: ['Carneiro', 'Touro', 'Gémeos', 'Caranguejo', 'Leão', 'Virgem', 'Balança', 'Escorpião', 'Sagitário', 'Capricórnio', 'Aquário', 'Peixes'] },
      workout: { label: 'Exercício', emoji: '🏋️', opts: ['Todos os dias', 'Às vezes', 'Nunca'] },
      drinks: { label: 'Bebidas', emoji: '🍷', opts: ['Não bebo', 'Socialmente', 'Frequentemente'] },
      smoke: { label: 'Fumar', emoji: '🚬', opts: ['Não fumo', 'Socialmente', 'Fumo'] },
      pets: { label: 'Animais', emoji: '🐾', opts: ['Cão', 'Gato', 'Outro', 'Nenhum'] },
    };
    const NONE = 'Prefiro não dizer';
    /* o json.encode do servidor manda tabelas vazias como [] ou {} - normalizar antes de usar */
    const X = p => { if (!p) return {}; let x = p.extras; if (!x || typeof x !== 'object' || Array.isArray(x)) x = p.extras = {}; ['artists', 'interests', 'prompts'].forEach(k => { if (!Array.isArray(x[k])) x[k] = []; }); return x; };
    const photosOf = p => (p && p.photos && p.photos.length) ? p.photos : [((p && p.name) || 'x').length];
    const dist = p => p.distance != null ? p.distance : ((Number(p.id) || (p.name || '').length) * 7) % 14 + 1;
    const basics = x => [x.want && ['💘', x.want], x.height && ['📏', x.height + ' cm'], x.zodiac && ['✨', x.zodiac], x.job && ['💼', x.job], x.school && ['🎓', x.school], x.workout && ['🏋️', x.workout], x.drinks && ['🍷', x.drinks], x.smoke && ['🚬', x.smoke], x.pets && ['🐾', x.pets]].filter(Boolean);
    const completion = p => { const x = X(p); const c = [(p.photos || []).length >= 2, (p.bio || '').length >= 20, !!x.song, (x.interests || []).length >= 3, (x.artists || []).length >= 1, (x.prompts || []).length >= 1, !!x.want, !!(x.job || x.school), !!(x.height || x.zodiac)]; return Math.round(c.filter(Boolean).length / c.length * 100); };
    const common = p => { const a = X(me).interests || [], b = X(p).interests || []; return b.filter(t => a.includes(t)); };
    /* ---------- FOTOS DO PERFIL: só o ID ANDA NA REDE ----------
       Uma foto do jogo tem ~150 000 caracteres e o perfil só aceita 512 por foto (server/match.lua: o deck manda 30
       perfis num evento de rede). Guardar o base64 no perfil dava sempre 'As fotos são grandes demais' - agora a foto
       sobe pelo media.* (aos bocados) e o perfil guarda 'm:<id>'; quem vê descarrega-a pelo media.get. Os perfis
       antigos com data: URL ou com semente (número) continuam a funcionar. */
    const mediaRef = s => { const m = /^m:(\d+)$/.exec(String(s || '')); return m ? +m[1] : 0; };
    const mediaCache = new Map();
    function mediaUrl(id) {
      if (mediaCache.has(id)) return mediaCache.get(id);
      const p = (window.Msgs && Msgs.media ? Msgs.media(id).then(r => (r && r.url) || null)
        : window.VoiceMsg && VoiceMsg.fetchMedia ? VoiceMsg.fetchMedia(id).then(r => (r && !r.error && r.dataUrl) || null)
        : Promise.resolve(null)).catch(() => null);
      mediaCache.set(id, p); p.then(u => { if (!u) mediaCache.delete(id); });
      return p;
    }
    const setBg = (el, src) => { if (!el) return el; const mid = mediaRef(src);
      if (mid) { el.style.backgroundImage = 'none'; mediaUrl(mid).then(u => { if (u && el.isConnected) el.style.backgroundImage = UI.img(u); }); return el; }
      el.style.backgroundImage = src ? UI.img(src) : 'none'; return el; };
    const av = (p, cls) => { const f = p.photos && p.photos[0]; const mid = mediaRef(f);
      const el = UI.el(UI.avatar({ name: p.name, avatar: typeof f === 'number' ? f % 12 + 1 : p.name.length, url: (!mid && typeof f === 'string') ? f : null }, cls));
      if (mid) mediaUrl(mid).then(u => { if (!u || !el.isConnected) return; el.style.backgroundImage = UI.img(u); el.style.backgroundSize = 'cover'; el.style.backgroundPosition = 'center'; el.textContent = ''; });
      return el.outerHTML; };
    /* escolher foto → media.* (begin/upload/finish) → 'm:<id>'. A foto é reduzida ao teto do media (Config.Media) para
       a subida não ser recusada; um URL externo (link) continua a ir tal como está e a semente é um número. */
    async function uploadPhoto(x) {
      if (!x) return null;
      if (!x.url && x.seed != null && !x.len) return x.seed;   /* gradiente de demonstração: cabe no perfil */
      if (window.CC && CC.requireNet && !CC.requireNet('guardar a foto')) return null;
      let src = null; try { src = await Photos.data(x, true); } catch (e) { src = null; }
      if (!src) { UI.toast('Não foi possível abrir esta foto'); return null; }
      if (!/^data:image\//i.test(src)) return src.length <= 480 ? src : null;   /* link externo curto */
      if (!window.VoiceMsg || !VoiceMsg.uploadData) { UI.toast('Não foi possível enviar a foto'); return null; }
      const cap = (System.config && System.config.media && +System.config.media.maxImageBytes) || 260000;
      let out = src;
      if (out.length > cap - 2048) { try { out = await Photos.shrink(src, 1100, 0, cap - 2048); } catch (e) { out = null; } }
      if (!out || out === Photos.BLACK) { UI.toast('Esta foto não pode ser usada'); return null; }
      UI.toast('A enviar a foto…');
      const up = await VoiceMsg.uploadData(out, { kind: 'image', mime: 'image/jpeg' });
      if (!up || !up.mediaId) { UI.toast(window.VoiceMsg ? VoiceMsg.errorText(up && up.error, 'Não foi possível enviar a foto.') : 'Não foi possível enviar a foto.'); return null; }
      return 'm:' + up.mediaId;
    }
    const chipHtml = (t, cls = '') => `<span class="mt-chip ${cls}">${esc(t)}</span>`;
    const coverOf = (el, song) => { if (song && song.img) el.style.backgroundImage = `url('${String(song.img).replace(/'/g, '%27')}')`; else { el.classList.add('none'); el.innerHTML = g('music'); } return el; };
    const eq = (cls = '') => `<div class="mt-eq ${cls}"><i></i><i></i><i></i><i></i></div>`;
    /* barra de estado clara (texto branco) por cima da foto do perfil completo e do ecrã "É um Match!" */
    const sbSync = () => { const d = App.get(APP); if (!d || !System.updateSbTheme) return; const st = win.querySelector('.nav-stack'), tv = st && [...st.children].filter(x => !x.classList.contains('leave')).pop();
      d.statusBar = (win.querySelector(':scope > .mt-match:not(.out)') || (tv && tv.classList.contains('mt-full') && !tv.classList.contains('mt-scrolled'))) ? 'dark' : undefined; System.updateSbTheme(); };
    const flame = `<svg class="mt-flame" viewBox="0 0 100 100"><defs><linearGradient id="mtFl" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FD267A"/><stop offset="1" stop-color="#FF7A3D"/></linearGradient></defs><path d="M50 6c6 18 22 26 22 50 0 9-4 15-9 18 1-9-3-15-9-19-3 9-12 12-12 24 0 4 1 7 4 10C30 84 20 72 20 57 20 36 38 30 50 6z" fill="url(#mtFl)"/></svg>`;

    /* O meu hino: capa, título, artista e reprodução pela app Música (mesmo player do telemóvel) */
    function songCard(song, o = {}) {
      const c = UI.el(`<div class="mt-song ${o.cls || ''}"><div class="mt-cover"></div><div class="mt-song-t"><small>${esc(o.label || 'O meu hino')}</small><b>${esc(song.t)}</b><span>${esc(song.a || '')}</span></div>${eq()}<div class="mt-play">${g('play')}</div></div>`);
      coverOf(c.querySelector('.mt-cover'), song);
      const pl = c.querySelector('.mt-play');
      const mine = () => !!(window.Music && Music.now && song.vid && Music.now.vid === song.vid);
      const paint = () => { const on = mine() && Music.MU.playing; c.classList.toggle('playing', on); pl.innerHTML = g(on ? 'pause' : 'play'); };
      if (song.vid && window.Music && Music.put) {
        pl.onclick = e => { e.stopPropagation(); if (mine()) Music.pauseResume(); else { const s = Music.put({ id: 'yt:' + song.vid, t: song.t, a: song.a, img: song.img }); if (s) Music.start([s.id], { k: 'match', label: 'Match' }, s.id); } [120, 700, 1600].forEach(ms => setTimeout(paint, ms)); };
        paint();
      } else pl.remove();
      if (o.onRemove) { const x = UI.el(`<div class="mt-song-x">${g('x')}</div>`); x.onclick = e => { e.stopPropagation(); o.onRemove(); }; c.appendChild(x); }
      return c;
    }

    /* =====================================================================
       CARTÃO
       ===================================================================== */
    function cardEl(p) {
      const x = X(p), ph = photosOf(p), shared = common(p);
      const c = UI.el(`<div class="mt-card">
        <div class="mt-imgs">${ph.map((_, i) => `<div class="mt-img ${i === 0 ? 'on' : ''}"></div>`).join('')}</div>
        <div class="mt-shade"></div>
        ${ph.length > 1 ? `<div class="mt-bars">${ph.map((_, i) => `<i class="${i === 0 ? 'on' : ''}"></i>`).join('')}</div>` : ''}
        <div class="mt-tint like"></div><div class="mt-tint nope"></div><div class="mt-tint sup"></div>
        <div class="mt-stamp like">GOSTO</div><div class="mt-stamp nope">NÃO</div><div class="mt-stamp sup">SUPER LIKE</div>
        ${p.superMe ? `<div class="mt-superme">${g('starFill')}<span>Deu-te um Super Like</span></div>` : ''}
        <div class="mt-info"><div class="mt-name"><b>${esc(p.name)}</b><span>${p.age}</span></div><div class="mt-page"></div></div>
        <div class="mt-ibtn">${g('arrowUp')}</div>
      </div>`);
      c._p = p; c._ph = ph; c._pi = 0;
      c.querySelectorAll('.mt-img').forEach((e, i) => setBg(e, ph[i]));
      const loc = `<div class="mt-loc">${g('pin')}<span>${esc(p.location || 'Los Santos')} · a ${dist(p)} km</span></div>`;
      const songPill = x.song ? `<div class="mt-songpill">${eq('sm')}<span><b>${esc(x.song.t)}</b>${x.song.a ? ' · ' + esc(x.song.a) : ''}</span></div>` : '';
      const ints = (x.interests || []).length ? `<div class="mt-chips">${x.interests.slice(0, 4).map(t => chipHtml(t, shared.includes(t) ? 'common' : '')).join('')}</div>` : '';
      const bs = basics(x).slice(0, 4), bsH = bs.length ? `<div class="mt-chips">${bs.map(([e, t]) => `<span class="mt-chip">${e} ${esc(t)}</span>`).join('')}</div>` : '';
      const bio = p.bio ? `<div class="mt-bio">${esc(p.bio)}</div>` : '';
      /* cada foto tem a sua "página" de informação, como na app original; com menos fotos junta-se tudo */
      const pages = ph.length === 1 ? [loc + songPill + (ints || bio || bsH)] : ph.length === 2 ? [loc + songPill + bio, (ints + bsH) || bio || loc] : [loc + songPill + bio, ints || bsH || loc, bsH || ints || loc];
      const pg = c.querySelector('.mt-page');
      c._page = i => { pg.innerHTML = pages[Math.min(i, pages.length - 1)] || loc; };
      c._page(0);
      return c;
    }
    /* mudar de foto a tocar; na primeira/última o cartão dá um pequeno "encosto" */
    function photoNav(c, d) {
      const i = c._pi + d;
      if (i < 0 || i >= c._ph.length) { c.classList.remove('bump-l', 'bump-r'); void c.offsetWidth; c.classList.add(d < 0 ? 'bump-l' : 'bump-r'); return; }
      c._pi = i; c.querySelectorAll('.mt-img').forEach((e, k) => e.classList.toggle('on', k === i)); c.querySelectorAll('.mt-bars i').forEach((e, k) => e.classList.toggle('on', k === i)); c._page(i); Sound.play('tick');
    }

    /* =====================================================================
       DESCOBRIR
       ===================================================================== */
    const discover = () => {
      const v = UI.view({ title: '', cls: 'mt-disc', right: [{ icon: 'sliders', onTap: filters }] });
      v.navbar.querySelector('.nb-left').appendChild(UI.el(`<div class="mt-brand">${flame}<b>match</b></div>`));
      const stack = UI.el('<div class="mt-stack"></div>');
      const btns = UI.el(`<div class="mt-btns"><div class="mt-b nope">${g('x')}</div><div class="mt-b sup">${g('starFill')}</div><div class="mt-b like">${g('heartFill')}</div></div>`);
      v.content.classList.add('mt-disc-c'); v.content.append(stack, btns);
      const B = { nope: btns.querySelector('.nope'), sup: btns.querySelector('.sup'), like: btns.querySelector('.like') };
      let busy = false;
      const top = () => stack.querySelector('.mt-card.top'), back = () => stack.querySelector('.mt-card.back');

      const radar = (title, sub, action) => { const e = UI.el(`<div class="mt-empty"><div class="mt-radar ${action ? 'few' : ''}"><i></i><i></i><i></i><div class="mt-radar-av"></div></div><b>${esc(title)}</b><span>${esc(sub)}</span>${action ? '<div class="mt-pill">Procurar outra vez</div>' : ''}</div>`); if (me) setBg(e.querySelector('.mt-radar-av'), photosOf(me)[0]); if (action) e.querySelector('.mt-pill').onclick = load; return e; };
      function fill() {
        stack.querySelectorAll('.mt-empty').forEach(e => e.remove());
        btns.classList.toggle('off', !cards.length);
        if (!cards.length) { if (!stack.querySelector('.mt-card:not(.gone)')) stack.appendChild(radar('Não há mais ninguém por perto', 'Volta mais tarde ou alarga as tuas preferências.', true)); return; }
        if (!top()) { const b = back(); if (b && b._p === cards[0]) promote(b); else { const t = cardEl(cards[0]); t.classList.add('top'); bind(t); stack.appendChild(t); } }
        if (cards[1] && !back()) { const b = cardEl(cards[1]); b.classList.add('back', 'enter'); bind(b); stack.insertBefore(b, stack.firstChild); requestAnimationFrame(() => requestAnimationFrame(() => b.classList.remove('enter'))); }
      }
      const promote = b => { b.style.transform = ''; b.classList.remove('back', 'enter'); b.classList.add('top'); };
      function load() { stack.innerHTML = ''; btns.classList.add('off'); stack.appendChild(radar('A procurar pessoas perto de ti…', 'Los Santos está cheia de gente interessante.', false)); rpc('match.cards').then(l => { if (dead || !stack.isConnected && !v.isConnected) return; cards = l || []; stack.innerHTML = ''; fill(); }); }

      /* resposta visual ao gesto: carimbos, véus de cor, cartão de trás e botões */
      function feedback(c, dx, dy, release) {
        const kx = clamp(dx / 120, -1, 1), ku = clamp(-dy / 150, 0, 1) * (1 - Math.abs(kx)), lk = Math.max(0, kx), nk = Math.max(0, -kx);
        const q = s => c.querySelector(s), st = (el, o, tr) => { if (el) { el.style.opacity = o.toFixed(3); el.style.transform = tr; } };
        st(q('.mt-stamp.like'), lk, `rotate(-16deg) scale(${(1.3 - .3 * lk).toFixed(3)})`);
        st(q('.mt-stamp.nope'), nk, `rotate(16deg) scale(${(1.3 - .3 * nk).toFixed(3)})`);
        st(q('.mt-stamp.sup'), ku, `translateX(-50%) rotate(-8deg) scale(${(1.3 - .3 * ku).toFixed(3)})`);
        q('.mt-tint.like').style.opacity = (lk * .85).toFixed(3); q('.mt-tint.nope').style.opacity = (nk * .85).toFixed(3); q('.mt-tint.sup').style.opacity = (ku * .85).toFixed(3);
        const sm = q('.mt-superme'); if (sm) sm.style.opacity = release ? '' : Math.max(0, 1 - Math.max(lk, nk, ku) * 1.6).toFixed(3);   /* o selo "Deu-te um Super Like" sai da frente do carimbo */
        const b = back(); if (b) { const pr = clamp(Math.hypot(dx, dy) / 140, 0, 1); b.style.transform = release ? '' : `translate3d(0,${(14 * (1 - pr)).toFixed(1)}px,0) scale(${(.95 + .05 * pr).toFixed(4)})`; }
        B.like.style.transform = release ? '' : `scale(${(1 + .18 * lk).toFixed(3)})`; B.nope.style.transform = release ? '' : `scale(${(1 + .18 * nk).toFixed(3)})`; B.sup.style.transform = release ? '' : `scale(${(1 + .18 * ku).toFixed(3)})`;
        B.like.classList.toggle('lit', !release && lk > .95); B.nope.classList.toggle('lit', !release && nk > .95); B.sup.classList.toggle('lit', !release && ku > .95);
      }

      function bind(c) {
        let s = null, raf = 0;
        const paint = () => { raf = 0; if (!s) return; c.style.transform = `translate3d(${s.dx.toFixed(1)}px,${s.dy.toFixed(1)}px,0) rotate(${(s.dx / 18 * s.dir).toFixed(2)}deg)`; feedback(c, s.dx, s.dy, false); };
        c.addEventListener('pointerdown', e => {
          if (busy || !c.classList.contains('top') || (e.button && e.pointerType === 'mouse') || e.target.closest('.mt-ibtn')) return;
          /* retângulo em px reais e o zoom do próprio cartão (o aparelho e, no PearPhone Fold, o do conteúdo): ui.js UI.vrect / UI.zoom(el) */
          const r = UI.vrect ? UI.vrect(c) : c.getBoundingClientRect(), now = performance.now();
          s = { x: e.clientX, y: e.clientY, dx: 0, dy: 0, lx: e.clientX, ly: e.clientY, lt: now, vx: 0, vy: 0, moved: false, dir: (e.clientY - r.top) / r.height < .62 ? 1 : -1, fx: (e.clientX - r.left) / r.width, z: UI.vrect ? UI.zoom(c) || 1 : UI.zoom() };
          c.classList.remove('bump-l', 'bump-r'); c.classList.add('drag'); stack.classList.add('live'); btns.classList.add('live');
          try { c.setPointerCapture(e.pointerId); } catch (x) {}
        });
        c.addEventListener('pointermove', e => {
          if (!s) return; const z = s.z, now = performance.now(), dt = Math.max(1, now - s.lt);
          s.dx = (e.clientX - s.x) / z; s.dy = (e.clientY - s.y) / z;
          s.vx = s.vx * .5 + ((e.clientX - s.lx) / z / dt) * .5; s.vy = s.vy * .5 + ((e.clientY - s.ly) / z / dt) * .5; s.lx = e.clientX; s.ly = e.clientY; s.lt = now;
          if (!s.moved && Math.hypot(s.dx, s.dy) > 8) s.moved = true;
          if (s.moved && !raf) raf = requestAnimationFrame(paint);
        });
        const end = cancel => () => {
          if (!s) return; const t = s; s = null; if (raf) { cancelAnimationFrame(raf); raf = 0; }
          c.classList.remove('drag'); stack.classList.remove('live'); btns.classList.remove('live');
          if (!t.moved) { if (!cancel) photoNav(c, t.fx < .45 ? -1 : 1); return; }
          if (performance.now() - t.lt > 90) { t.vx = 0; t.vy = 0; }   /* o dedo parou antes de largar: sem impulso */
          const k = cancel ? null : (t.dx > 120 || (t.vx > .45 && t.dx > 36)) ? 'like' : (t.dx < -120 || (t.vx < -.45 && t.dx < -36)) ? 'nope' : ((t.dy < -150 || (t.vy < -.55 && t.dy < -56)) && Math.abs(t.dx) < 110) ? 'sup' : null;
          if (k) { fling(c, k, t); return; }
          c.style.transform = ''; feedback(c, 0, 0, true);   /* volta com a mola do CSS */
        };
        c.addEventListener('pointerup', end(false)); c.addEventListener('pointercancel', end(true));
        c._pose = (dx, dy) => { c.classList.add('drag'); c.style.transform = `translate3d(${dx}px,${dy}px,0) rotate(${(dx / 18).toFixed(2)}deg)`; feedback(c, dx, dy, false); };   /* capturas (_shot.html): fixa o cartão a meio de um gesto */
        c.querySelector('.mt-ibtn').onclick = e => { e.stopPropagation(); if (c.classList.contains('top')) openFull(c._p, { deck: true }); };
      }

      function hit(b) { b.classList.remove('hit'); void b.offsetWidth; b.classList.add('hit'); }
      function fling(c, k, t) {
        const p = c._p; if (!p || !c.isConnected) return;
        /* deslizar GRAVA no servidor (match.swipe) e pode dar match: sem rede o cartão desaparecia para o
           nada e a pessoa voltava a aparecer na carga seguinte. Volta ao lugar com o aviso.
           O `busy = false` é preciso porque o byButton já o tinha posto a true antes deste atraso. */
        if (window.CC && CC.requireNet && !CC.requireNet('deslizar')) { busy = false; c.style.transition = ''; c.style.transform = ''; feedback(c, 0, 0, true); return; }
        busy = true;
        const dx = t ? t.dx : 0, dy = t ? t.dy : 0, vx = t ? t.vx : 0, vy = t ? t.vy : 0, dir = t ? t.dir : 1;
        feedback(c, k === 'like' ? 140 : k === 'nope' ? -140 : 0, k === 'sup' ? -170 : 0, false);
        c.classList.remove('top', 'drag'); c.classList.add('gone');
        let tx, ty, rot;
        if (k === 'sup') { tx = dx * 1.3; ty = -1150; rot = dx / 18; }
        else { const sg = k === 'like' ? 1 : -1; tx = sg * (640 + Math.min(420, Math.abs(vx) * 220)); ty = clamp(dy + vy * 200, -420, 420) - 20; rot = sg * (24 + Math.min(16, Math.abs(vx) * 12)) * dir; }
        const dur = t ? clamp(.5 - Math.hypot(vx, vy) * .12, .3, .5) : .5;
        c.style.transition = `transform ${dur.toFixed(2)}s cubic-bezier(.3,.55,.4,1), opacity .18s ease-in ${(dur - .16).toFixed(2)}s`;
        requestAnimationFrame(() => { c.style.transform = `translate3d(${tx.toFixed(0)}px,${ty.toFixed(0)}px,0) rotate(${rot.toFixed(1)}deg)`; c.style.opacity = '0'; });
        hit(B[k]); Sound.play(k === 'like' ? 'like' : k === 'sup' ? 'superlike' : 'nope');
        cards = cards.filter(x => x !== p);
        const b = back(); B.like.style.transform = B.nope.style.transform = B.sup.style.transform = ''; ['like', 'nope', 'sup'].forEach(n => B[n].classList.remove('lit'));
        if (b && b._p === cards[0]) promote(b);
        setTimeout(() => { busy = false; if (!dead) fill(); }, 160);
        setTimeout(() => c.remove(), Math.round(dur * 1000) + 60);
        /* o cartão do deck já NÃO traz `phone` (server/match.lua:201-209 tirou-o das colunas): quem tem o
           número é o `r.profile` que só vem com o match feito. Juntam-se os dois para o ecrã de
           celebração ter foto e nome mesmo se o perfil completo faltar - e a caixa de "diz olá" só
           aparece quando há mesmo número para onde escrever (ver celebrate). */
        rpc('match.swipe', { target: p.id, like: k !== 'nope', super: k === 'sup' }).then(r => { if (r && r.matched && !dead) setTimeout(() => celebrate(Object.assign({}, p, r.profile || {})), 420); });
      }
      /* botões: o cartão inclina-se primeiro para o lado (com o carimbo) e só depois sai */
      function byButton(k) {
        const c = top(); if (!c || busy) return; busy = true;
        const dx = k === 'like' ? 34 : k === 'nope' ? -34 : 0, dy = k === 'sup' ? -40 : -6;
        c.style.transition = 'transform .13s cubic-bezier(.3,.7,.4,1)';
        c.style.transform = `translate3d(${dx}px,${dy}px,0) rotate(${(dx / 9).toFixed(1)}deg)`;
        feedback(c, dx * 3.2, dy * 3.2, false);
        setTimeout(() => { c.style.transition = ''; fling(c, k, { dx, dy, vx: k === 'sup' ? 0 : dx / 40, vy: k === 'sup' ? -.8 : 0, dir: 1 }); }, 120);
      }
      B.nope.onclick = () => byButton('nope'); B.like.onclick = () => byButton('like'); B.sup.onclick = () => byButton('sup');
      deck = { swipe: k => byButton(k), reload: load };
      load();
      return v;
    };

    function filters() {
      if (!me) return;
      const opts = ['Homens', 'Mulheres', 'Todos']; let pick = me.seeking;
      const body = UI.el('<div class="mt-filters"><div class="mt-f-h">Mostrar-me</div></div>');
      const sg = UI.seg(opts, Math.max(0, opts.indexOf(me.seeking)), i => { pick = opts[i]; }); body.appendChild(sg);
      body.appendChild(UI.el('<div class="mt-f-foot">Só aparecem pessoas que também procuram alguém como tu.</div>'));
      UI.sheet({ title: 'Preferências', left: 'Cancelar', right: 'Aplicar', body, cls: 'mt-sheet', onDone: () => { if (pick === me.seeking) return; if (window.CC && CC.requireNet && !CC.requireNet('guardar as preferências')) return false;   /* a folha fica aberta: a escolha não se perde */
        rpc('match.updateProfile', { seeking: pick }).then(r => { if (r && !r.error) { me = r; deck && deck.reload(); } }); } });
    }

    /* =====================================================================
       PERFIL COMPLETO (ao tocar na seta do cartão, nos matches e na pré-visualização)
       ===================================================================== */
    function openFull(p, o = {}) {
      const x = X(p), ph = photosOf(p), shared = p === me ? [] : common(p), bs = basics(x).filter(([e]) => !(x.want && e === '💘'));   /* "Procuro" já tem secção própria */
      const v = UI.view({ title: '', cls: 'mt-full', full: true, onPop: () => setTimeout(sbSync, 0) });
      v.appendChild(UI.el('<div class="mt-sbar"></div>'));
      v.content.addEventListener('scroll', () => { const on = v.content.scrollTop > 500; if (on !== v.classList.contains('mt-scrolled')) { v.classList.toggle('mt-scrolled', on); sbSync(); } }, { passive: true });
      const gal = UI.el(`<div class="mt-gal"><div class="mt-imgs">${ph.map((_, i) => `<div class="mt-img ${i === 0 ? 'on' : ''}"></div>`).join('')}</div>${ph.length > 1 ? `<div class="mt-bars">${ph.map((_, i) => `<i class="${i === 0 ? 'on' : ''}"></i>`).join('')}</div>` : ''}<div class="mt-close">${g('chevD')}</div></div>`);
      gal.querySelectorAll('.mt-img').forEach((e, i) => setBg(e, ph[i]));
      let pi = 0; gal.onclick = e => { if (e.target.closest('.mt-close')) return; const r = UI.vrect ? UI.vrect(gal) : gal.getBoundingClientRect(); const d = (e.clientX - r.left) / r.width < .45 ? -1 : 1; const i = pi + d; if (i < 0 || i >= ph.length) return; pi = i; gal.querySelectorAll('.mt-img').forEach((el, k) => el.classList.toggle('on', k === i)); gal.querySelectorAll('.mt-bars i').forEach((el, k) => el.classList.toggle('on', k === i)); Sound.play('tick'); };
      gal.querySelector('.mt-close').onclick = () => UI.pop(v);
      const body = UI.el(`<div class="mt-fbody"><div class="mt-fhead"><div class="mt-name"><b>${esc(p.name)}</b><span>${p.age}</span></div><div class="mt-loc">${g('pin')}<span>${esc(p.location || 'Los Santos')}${p === me ? '' : ' · a ' + dist(p) + ' km'}</span></div></div></div>`);
      const sec = (title, inner, cls = '') => { const s = UI.el(`<div class="mt-sec ${cls}"><h4>${title}</h4></div>`); if (typeof inner === 'string') s.insertAdjacentHTML('beforeend', inner); else if (inner) s.appendChild(inner); body.appendChild(s); return s; };
      if (x.want) sec('Procuro', `<div class="mt-want"><span>💘</span><b>${esc(x.want)}</b></div>`);
      if (p.bio) sec('Sobre mim', `<p>${esc(p.bio)}</p>`);
      if (bs.length) sec('Básicos', `<div class="mt-chips light">${bs.map(([e, t]) => `<span class="mt-chip">${e} ${esc(t)}</span>`).join('')}</div>`);
      if (x.song || (x.artists || []).length) { const s = sec('Música', null); if (x.song) s.appendChild(songCard(x.song)); if ((x.artists || []).length) s.insertAdjacentHTML('beforeend', `<div class="mt-chips light">${x.artists.map(a => `<span class="mt-chip">🎤 ${esc(a)}</span>`).join('')}</div>`); }
      if ((x.interests || []).length) sec(`Interesses${shared.length ? ` <em>${shared.length} em comum</em>` : ''}`, `<div class="mt-chips light">${x.interests.map(t => chipHtml(t, shared.includes(t) ? 'common' : '')).join('')}</div>`);
      (x.prompts || []).forEach(q => sec(esc(q.q), `<p class="big">${esc(q.a)}</p>`, 'prompt'));
      v.content.append(gal, body);
      if (o.deck) { const fb = UI.el(`<div class="mt-fbtns"><div class="mt-b nope">${g('x')}</div><div class="mt-b sup">${g('starFill')}</div><div class="mt-b like">${g('heartFill')}</div></div>`); ['nope', 'sup', 'like'].forEach(k => { fb.querySelector('.' + k).onclick = () => { UI.pop(v); setTimeout(() => deck && deck.swipe(k), 320); }; }); v.appendChild(fb); v.content.classList.add('has-btns'); }
      else if (o.chat) { const b = UI.el(`<div class="mt-fbtns one"><div class="btn-p mt-grad">${g('message')}<span>Enviar mensagem</span></div></div>`); b.firstElementChild.onclick = () => { UI.pop(v); setTimeout(() => chat(p), 300); }; v.appendChild(b); v.content.classList.add('has-btns'); }
      UI.push(win, v); sbSync();
    }

    /* =====================================================================
       É UM MATCH!
       ===================================================================== */
    function celebrate(p) {
      if (dead || !me) return; win.querySelectorAll(':scope > .mt-match').forEach(e => e.remove());
      const shared = common(p), songA = X(me).song, songB = X(p).song, sameSong = songA && songB && ((songA.vid && songA.vid === songB.vid) || songA.t === songB.t);
      const artistsA = (X(me).artists || []).map(a => a.toLowerCase()), sameArtist = (X(p).artists || []).find(a => artistsA.includes(a.toLowerCase()));
      const bond = sameSong ? `🎵 Os dois têm o mesmo hino: ${songB.t}` : sameArtist ? `🎤 Os dois ouvem ${sameArtist}` : shared.length ? `✨ ${shared.length} ${shared.length === 1 ? 'interesse' : 'interesses'} em comum: ${shared.slice(0, 3).join(', ')}` : '';
      const heart = '<svg viewBox="0 0 24 24"><path d="M12 21s-7.5-4.6-9.6-9.2C.9 8.4 3 4.5 6.8 4.5c2.2 0 3.6 1.2 5.2 3 1.6-1.8 3-3 5.2-3 3.8 0 5.9 3.9 4.4 7.3C19.5 16.4 12 21 12 21z" fill="currentColor"/></svg>';
      /* sem número não há conversa: melhor não mostrar a caixa do que mandar a mensagem para `to: undefined`.
         O botão "Continuar a descobrir" fica, e o match aparece na lista de Matches com o número certo. */
      const canSend = !!p.phone;
      const o = UI.el(`<div class="mt-match"><div class="mt-m-bg"></div><div class="mt-m-veil"></div>
        <div class="mt-hearts">${Array.from({ length: 12 }, (_, i) => `<i style="left:${(i * 37 + 7) % 96}%;animation-delay:${((i * 7) % 12) * .16}s;--s:${(.55 + (i % 4) * .2).toFixed(2)}">${heart}</i>`).join('')}</div>
        <div class="mt-m-body"><div class="mt-m-title">É um Match!</div><div class="mt-m-sub">Tu e ${esc(p.name)} gostaram um do outro.</div>
          <div class="mt-m-avs"><div class="mt-m-av a"></div><div class="mt-m-heart">${g('heartFill')}</div><div class="mt-m-av b"></div></div>
          ${bond ? `<div class="mt-m-bond">${esc(bond)}</div>` : ''}
          ${canSend ? `<div class="mt-m-send"><input type="text" maxlength="400" placeholder="Diz olá a ${esc(p.name)}…"><div class="mt-m-go">${g('arrowUp')}</div></div>` : ''}
          <div class="mt-m-later">Continuar a descobrir</div></div></div>`);
      setBg(o.querySelector('.mt-m-bg'), photosOf(p)[0]); setBg(o.querySelector('.mt-m-av.a'), photosOf(me)[0]); setBg(o.querySelector('.mt-m-av.b'), photosOf(p)[0]);
      const close = () => { o.classList.remove('in'); o.classList.add('out'); sbSync(); setTimeout(() => o.remove(), 320); };
      const inp = o.querySelector('input');
      const send = async () => { if (!inp || !p.phone) return; const t = inp.value.trim(); if (!t) { inp.focus(); return; } if (window.CC && CC.requireNet && !CC.requireNet('enviar a mensagem')) return; inp.value = ''; const m = await rpc('messages.send', { to: p.phone, type: 'text', content: t, app: APP }); if (m && !m.error) { Sound.play('send'); close(); setTimeout(() => chat(p), 200); } else UI.toast('Não foi possível enviar'); };
      if (inp) { o.querySelector('.mt-m-go').onclick = send; inp.onkeydown = e => { if (e.key === 'Enter') send(); }; }
      o.querySelector('.mt-m-later').onclick = close;
      win.appendChild(o); sbSync(); Sound.play('match'); requestAnimationFrame(() => requestAnimationFrame(() => o.classList.add('in')));
    }

    /* =====================================================================
       MATCHES + CHAT
       ===================================================================== */
    const matches = () => {
      const v = UI.view({ title: 'Matches', large: true, cls: 'mt-matches' }); const holder = UI.el('<div></div>'); v.content.appendChild(holder); holder.appendChild(UI.spinner());
      rpc('match.matches').then(l => {
        if (dead) return; holder.innerHTML = ''; l = l || []; System.badge(APP, l.reduce((a, m) => a + (m.unread || 0), 0));
        if (!l.length) { const e = UI.el(`<div class="mt-nomatch"><div class="mt-nm-art"><i></i><i></i><div>${g('heartFill')}</div></div><b>Ainda sem matches</b><span>Quando alguém gostar de ti de volta, aparece aqui.</span><div class="mt-pill">Descobrir pessoas</div></div>`); e.querySelector('.mt-pill').onclick = () => tabs && tabs.go(0); holder.appendChild(e); return; }
        const fresh = l.filter(m => !m.last), convo = l.filter(m => m.last);
        if (fresh.length) {
          holder.appendChild(UI.el(`<div class="mt-h">Novos matches <span>${fresh.length}</span></div>`));
          const row = UI.el('<div class="mt-row"></div>');
          fresh.forEach(m => { const e = UI.el(`<div class="mt-tile"><div class="mt-tile-img"></div><span>${esc(m.profile.name)}</span></div>`); setBg(e.querySelector('.mt-tile-img'), photosOf(m.profile)[0]); e.onclick = () => chat(m.profile); UI.longPress(e, () => openFull(m.profile, { chat: true })); row.appendChild(e); });
          holder.appendChild(row);
        }
        holder.appendChild(UI.el('<div class="mt-h">Mensagens</div>'));
        if (!convo.length) { holder.appendChild(UI.el('<div class="mt-hint-line">Toca num match para dizer olá 👋</div>')); return; }
        const list = UI.el('<div class="mt-convos"></div>');
        convo.forEach(m => {
          const mine = m.last.sender === myPhone();
          const e = UI.el(`<div class="mt-convo ${m.unread ? 'unread' : ''}"><div class="mt-convo-av"></div><div class="mt-convo-t"><b>${esc(m.profile.name)}</b><span>${mine ? '<i>Tu:</i> ' : ''}${esc(m.last.content || '')}</span></div><div class="mt-convo-r"><small>${esc(UI.rel(m.last.created))}</small>${m.unread ? '<em></em>' : ''}</div></div>`);
          setBg(e.querySelector('.mt-convo-av'), photosOf(m.profile)[0]);
          e.onclick = () => chat(m.profile);
          UI.longPress(e, () => UI.ctxMenu(e, [{ label: 'Ver perfil', icon: 'personCircle', onTap: () => openFull(m.profile, { chat: true }) }, { label: 'Desfazer match', icon: 'heart', danger: true, onTap: async () => { if (await UI.confirm('Desfazer match', m.profile.name, 'Desfazer', true)) { await rpc('match.unmatch', { id: m.id }); tabs.go(1); } } }]));
          list.appendChild(e);
        });
        holder.appendChild(list);
      });
      return v;
    };
    function chat(p) {
      const other = p.phone;
      const v = UI.view({ title: '', back: 'Matches', full: true, solid: true, cls: 'mt-chat', right: [{ icon: 'info', onTap: () => openFull(p, {}) }], onPop: () => { chatOpen = null; } });
      const head = UI.el(`<div class="mt-chat-head"><div class="mt-chat-av"></div><b>${esc(p.name)}</b></div>`); setBg(head.querySelector('.mt-chat-av'), photosOf(p)[0]); head.onclick = () => openFull(p, {}); v.navbar.querySelector('.nb-title').appendChild(head);
      const th = UI.el('<div class="thread"></div>'); const comp = UI.el(`<div class="composer"><input type="text" placeholder="Mensagem…" maxlength="400"><div class="send">${g('arrowUp')}</div></div>`); const inp = comp.querySelector('input');
      const intro = UI.el(`<div class="mt-chat-intro"><div class="mt-ci-avs"><div class="a"></div><div class="b"></div></div><b>Deram match com ${esc(p.name)}</b><span>Começa com algo sobre os interesses ou a música dele(a).</span></div>`);
      if (me) setBg(intro.querySelector('.a'), photosOf(me)[0]); setBg(intro.querySelector('.b'), photosOf(p)[0]);
      const append = m => { if (intro.isConnected) intro.remove(); th.appendChild(UI.el(`<div class="bubble ${m.sender === myPhone() ? 'me' : 'them'}">${esc(m.content)}</div>`)); v.content.scrollTop = 1e6; };
      const send = async () => { const t = inp.value.trim(); if (!t) return; inp.value = ''; const m = await rpc('messages.send', { to: other, type: 'text', content: t, app: APP }); if (m && !m.error) { append(m); Sound.play('send'); } };
      comp.querySelector('.send').onclick = send; inp.onkeydown = e => { if (e.key === 'Enter') send(); };
      v.content.append(intro, th); v.content.style.paddingBottom = '0'; v.appendChild(comp); UI.push(win, v); chatOpen = { other, append };
      rpc('messages.get', { number: other, app: APP }).then(ms => { if (dead) return; (ms || []).forEach(append); rpc('messages.read', { number: other, app: APP }); });
    }

    /* =====================================================================
       O MEU PERFIL
       ===================================================================== */
    const profile = () => {
      const v = UI.view({ title: 'Perfil', large: true, cls: 'mt-prof' });
      const x = X(me), pct = completion(me), C = 2 * Math.PI * 56;
      const hero = UI.el(`<div class="mt-me"><div class="mt-ring"><svg viewBox="0 0 124 124"><defs><linearGradient id="mtRg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FD267A"/><stop offset="1" stop-color="#FF7A3D"/></linearGradient></defs><circle class="trk" cx="62" cy="62" r="56"/><circle class="val" cx="62" cy="62" r="56" stroke-dasharray="${(C * pct / 100).toFixed(1)} ${C.toFixed(1)}"/></svg><div class="mt-me-av"></div><span class="mt-pct">${pct}%</span></div>
        <div class="mt-me-name">${esc(me.name)}, ${me.age}</div><div class="mt-me-sub">${pct < 100 ? 'Perfis completos têm muito mais matches' : 'Perfil completo ✨'}</div>
        <div class="mt-me-btns"><div class="mt-act edit">${g('sparkles')}<span>Editar perfil</span></div><div class="mt-act prev">${g('eye')}<span>Pré-visualizar</span></div></div></div>`);
      setBg(hero.querySelector('.mt-me-av'), photosOf(me)[0]);
      const edit = focus => profileForm(me, () => tabs.go(2), false, focus);
      hero.querySelector('.edit').onclick = () => edit(); hero.querySelector('.prev').onclick = () => openFull(me, {});
      v.content.appendChild(hero);
      /* sugestões para completar */
      const tips = [!x.song && ['song', '🎵', 'Escolhe o teu hino', 'A música que te define, no teu cartão'], (x.interests || []).length < 3 && ['interests', '✨', 'Adiciona interesses', 'Mostra em que têm coisas em comum'], !(x.prompts || []).length && ['prompts', '💬', 'Responde a uma pergunta', 'Dá tema de conversa a quem te vê'], (me.photos || []).length < 2 && ['photos', '📸', 'Adiciona mais fotos', 'Perfis com várias fotos destacam-se'], !x.want && ['basics', '💘', 'Diz o que procuras', 'Relação, algo casual ou amizade']].filter(Boolean);
      if (tips.length) { const row = UI.el('<div class="mt-tips"></div>'); tips.forEach(([k, e, t, s]) => { const d = UI.el(`<div class="mt-tip"><span class="mt-tip-e">${e}</span><b>${esc(t)}</b><small>${esc(s)}</small></div>`); d.onclick = () => edit(k); row.appendChild(d); }); v.content.appendChild(row); }
      if (x.song || (x.artists || []).length) { v.content.appendChild(UI.el('<div class="mt-h">Música</div>')); const w = UI.el('<div class="mt-pad mt-music"></div>'); if (x.song) w.appendChild(songCard(x.song)); if ((x.artists || []).length) w.insertAdjacentHTML('beforeend', `<div class="mt-chips light">${x.artists.map(a => `<span class="mt-chip">🎤 ${esc(a)}</span>`).join('')}</div>`); v.content.appendChild(w); }
      if ((x.interests || []).length) { v.content.appendChild(UI.el('<div class="mt-h">Interesses</div>')); v.content.appendChild(UI.el(`<div class="mt-pad"><div class="mt-chips light">${x.interests.map(t => chipHtml(t)).join('')}</div></div>`)); }
      v.content.appendChild(UI.list([{ header: 'Descoberta', items: [
        { label: 'Mostrar-me', value: me.seeking, onTap: async li => { const s = await UI.picker('Mostrar-me', ['Homens', 'Mulheres', 'Todos'], me.seeking); if (s && s !== me.seeking) { const r = await rpc('match.updateProfile', { seeking: s }); if (r && !r.error) { me = r; const vv = li.querySelector('.li-value'); if (vv) vv.textContent = s; } } } },
        { label: 'Pausar perfil', sub: 'Deixas de aparecer a outras pessoas', toggle: !!me.paused, onToggle: async on => { await rpc('match.updateProfile', { paused: on }); me.paused = on; } }] },
        { items: [{ label: 'Apagar perfil', cls: 'danger center', chevron: false, onTap: async () => { if (await UI.confirm('Apagar perfil', 'Perdes os teus matches e conversas.', 'Apagar', true)) { await rpc('match.deleteProfile'); me = null; start(); } } }] }]));
      return v;
    };

    /* =====================================================================
       CRIAR / EDITAR PERFIL
       ===================================================================== */
    function profileForm(p, onDone, asRoot, focus) {
      const px = X(p);
      /* assinatura das fotos como vieram do servidor: se ninguém lhes tocou, o Guardar não as reenvia
         (ver save). O match.updateProfile mantém as que já lá estão quando `photos` não vem. */
      const photos0 = p ? JSON.stringify(p.photos || []) : null;
      const d = { name: p ? p.name : (System.player.firstname || ''), age: p ? p.age : 24, gender: p ? p.gender : 'Homem', seeking: p ? p.seeking : 'Todos', bio: p ? (p.bio || '') : '', location: p ? (p.location || '') : 'Los Santos', photos: p ? [...(p.photos || [])] : [],
        extras: Object.assign({}, px, { interests: [...(px.interests || [])], artists: [...(px.artists || [])], prompts: (px.prompts || []).map(q => ({ q: q.q, a: q.a })) }) };
      const e = d.extras;
      const v = UI.view({ title: p ? 'Editar perfil' : 'Criar perfil', back: p ? 'Perfil' : undefined, cls: 'mt-edit', full: true, right: [{ label: 'OK', bold: true, onTap: () => save() }] });
      const C = v.content;
      const head = (key, title, sub) => C.appendChild(UI.el(`<div class="mt-sec-h" data-sec="${key}"><b>${esc(title)}</b>${sub ? `<span>${esc(sub)}</span>` : ''}</div>`));

      /* fotos: uma principal grande + duas */
      head('photos', 'Fotos', 'A primeira é a principal');
      const ph = UI.el('<div class="mt-photos"></div>'); C.appendChild(ph);
      const paintPhotos = () => { ph.innerHTML = ''; for (let i = 0; i < 3; i++) { const s = d.photos[i]; const el = UI.el(`<div class="mt-ph ${i === 0 ? 'main' : ''} ${s ? 'has' : ''}">${s ? (i === 0 ? '<span class="mt-ph-tag">Principal</span>' : '') + `<div class="mt-ph-x">${g('x')}</div>` : `<div class="mt-ph-add">${g('plus')}</div>`}</div>`); if (s) setBg(el, s);
        el.onclick = async ev => { if (s) { if (ev.target.closest('.mt-ph-x')) { d.photos.splice(i, 1); paintPhotos(); Sound.play('delete'); return; } const a = await UI.actionSheet({ buttons: [i > 0 ? { label: 'Tornar principal', value: 'main' } : null, { label: 'Substituir', value: 'swap' }, { label: 'Remover', value: 'del', danger: true }].filter(Boolean) }); if (a === 'main') { d.photos.splice(i, 1); d.photos.unshift(s); paintPhotos(); } else if (a === 'del') { d.photos.splice(i, 1); paintPhotos(); } else if (a === 'swap') { const x = await Photos.pick('Foto de perfil'); if (x) { d.photos[i] = x.url || x.seed; paintPhotos(); } } return; }
          const x = await Photos.pick('Foto de perfil'); if (!x) return;
          /* sobe a foto e guarda só o id: é isto que permite fotos do jogo (ver mediaRef acima) */
          const ref = await uploadPhoto(x); if (ref) { d.photos.push(ref); paintPhotos(); } };
        ph.appendChild(el); } };
      paintPhotos();

      head('about', 'Sobre ti');
      const basicsList = UI.list([{ items: [
        { html: `<span class="mt-lbl">Nome</span><input type="text" class="f-name" placeholder="O teu nome" maxlength="24" value="${esc(d.name)}">`, cls: 'static' },
        { html: `<span class="mt-lbl">Idade</span><input type="number" class="f-age" min="18" max="99" value="${d.age}">`, cls: 'static' },
        { label: 'Género', value: d.gender, onTap: async li => { const x = await UI.picker('Género', ['Homem', 'Mulher', 'Outro'], d.gender); if (x) { d.gender = x; li.querySelector('.li-value').textContent = x; } } },
        { label: 'Mostrar-me', value: d.seeking, onTap: async li => { const x = await UI.picker('Mostrar-me', ['Homens', 'Mulheres', 'Todos'], d.seeking); if (x) { d.seeking = x; li.querySelector('.li-value').textContent = x; } } },
        { html: `<span class="mt-lbl">Zona</span><input type="text" class="f-loc" placeholder="Ex.: Vinewood" maxlength="30" value="${esc(d.location)}">`, cls: 'static' }] }]);
      C.appendChild(basicsList);

      head('bio', 'Sobre mim');
      const bioW = UI.el(`<div class="mt-bio-w"><textarea class="f-bio" maxlength="160" placeholder="Fala um pouco de ti…">${esc(d.bio)}</textarea><span class="mt-count">${d.bio.length}/160</span></div>`); C.appendChild(bioW);
      const ta = bioW.querySelector('textarea'); ta.addEventListener('input', () => { bioW.querySelector('.mt-count').textContent = ta.value.length + '/160'; });

      /* música */
      head('song', 'Música', 'O teu hino e os artistas que mais ouves');
      const mus = UI.el('<div class="mt-pad mt-music"></div>'); C.appendChild(mus);
      const paintMusic = () => {
        mus.innerHTML = '';
        if (e.song) { const sc = songCard(e.song, { onRemove: () => { e.song = null; paintMusic(); } }); sc.onclick = () => songPicker(s => { e.song = s; paintMusic(); }); mus.appendChild(sc); }
        else { const add = UI.el(`<div class="mt-song add"><div class="mt-cover none">${g('music')}</div><div class="mt-song-t"><small>O meu hino</small><b>Escolher música</b><span>Pesquisa no TubeMusic</span></div><div class="mt-play plus">${g('plus')}</div></div>`); add.onclick = () => songPicker(s => { e.song = s; paintMusic(); }); mus.appendChild(add); }
        const ar = UI.el(`<div class="mt-chips edit">${e.artists.map((a, i) => `<span class="mt-chip on" data-i="${i}">🎤 ${esc(a)}<i>${g('x')}</i></span>`).join('')}${e.artists.length < 5 ? `<span class="mt-chip addc">${g('plus')} Artista favorito</span>` : ''}</div>`);
        ar.onclick = async ev => { const c = ev.target.closest('.mt-chip'); if (!c) return; if (c.classList.contains('addc')) { const t = await UI.prompt('Artista favorito', 'Até 5 artistas', 'Ex.: The Weeknd'); if (t && t.trim()) { e.artists.push(t.trim().slice(0, 30)); paintMusic(); } return; } e.artists.splice(+c.dataset.i, 1); paintMusic(); };
        mus.appendChild(ar);
      };
      paintMusic();

      /* interesses: grelha de chips, até 5 */
      head('interests', 'Interesses', 'Escolhe até 5');
      const ig = UI.el('<div class="mt-pad"><div class="mt-chips pick"></div></div>'); C.appendChild(ig);
      const igc = ig.firstElementChild, ih = C.querySelector('[data-sec="interests"] span');
      const paintInts = () => { ih.textContent = window.L && L.tf ? L.tf('%s de %s', e.interests.length, 5) : `${e.interests.length} de 5`; igc.innerHTML = INTERESTS.map(t => chipHtml(t, e.interests.includes(t) ? 'on' : '')).join(''); };
      igc.onclick = ev => { const c = ev.target.closest('.mt-chip'); if (!c) return; const t = INTERESTS[[...igc.children].indexOf(c)]; if (t == null) return; /* pela posição, não pelo texto: o chip pode estar traduzido ("Café" → "Coffee") e o interesse guarda-se em português */ const i = e.interests.indexOf(t); if (i >= 0) e.interests.splice(i, 1); else { if (e.interests.length >= 5) { UI.toast('Máximo de 5 interesses'); Sound.play('error'); return; } e.interests.push(t); } paintInts(); const n = igc.children[INTERESTS.indexOf(t)]; if (n) { n.classList.add('pop'); } };
      paintInts();

      /* básicos */
      head('basics', 'Básicos');
      const pickRow = key => { const P = PICK[key]; return { icon: undefined, html: `<span class="mt-emo">${P.emoji}</span>${esc(P.label)}`, value: e[key] || '--', onTap: async li => { const x = await UI.picker(P.label, [...P.opts, NONE], e[key] || NONE); if (!x) return; e[key] = x === NONE ? null : x; li.querySelector('.li-value').textContent = e[key] || '--'; } }; };
      const heights = []; for (let h = 150; h <= 210; h++) heights.push(h + ' cm');
      C.appendChild(UI.list([{ items: [
        pickRow('want'),
        { html: '<span class="mt-emo">📏</span>Altura', value: e.height ? e.height + ' cm' : '--', onTap: async li => { const x = await UI.picker('Altura', [NONE, ...heights], e.height ? e.height + ' cm' : NONE, 'mt-tall'); if (!x) return; e.height = x === NONE ? null : parseInt(x, 10); li.querySelector('.li-value').textContent = e.height ? e.height + ' cm' : '--'; } },
        pickRow('zodiac'),
        { html: `<span class="mt-emo">💼</span><input type="text" class="f-job" placeholder="Trabalho" maxlength="40" value="${esc(e.job || '')}">`, cls: 'static' },
        { html: `<span class="mt-emo">🎓</span><input type="text" class="f-school" placeholder="Estudos" maxlength="40" value="${esc(e.school || '')}">`, cls: 'static' },
        pickRow('workout'), pickRow('drinks'), pickRow('smoke'), pickRow('pets')] }]));

      /* perguntas */
      head('prompts', 'Perguntas', 'Até 3: dão tema de conversa');
      const pr = UI.el('<div class="mt-pad mt-prompts"></div>'); C.appendChild(pr);
      const paintPrompts = () => {
        pr.innerHTML = '';
        e.prompts.forEach((q, i) => { const c = UI.el(`<div class="mt-prompt-card"><small>${esc(q.q)}</small><b>${esc(q.a)}</b></div>`); c.onclick = async () => { const a = await UI.actionSheet({ title: q.q, buttons: [{ label: 'Editar resposta', value: 'edit' }, { label: 'Remover', value: 'del', danger: true }] }); if (a === 'edit') { const t = await UI.prompt(q.q, '', 'A tua resposta', q.a); if (t && t.trim()) { q.a = t.trim().slice(0, 120); paintPrompts(); } } else if (a === 'del') { e.prompts.splice(i, 1); paintPrompts(); } }; pr.appendChild(c); });
        if (e.prompts.length < 3) { const add = UI.el(`<div class="mt-prompt-card add">${g('plus')}<b>Adicionar pergunta</b></div>`); add.onclick = async () => { const free = PROMPTS.filter(q => !e.prompts.some(x => x.q === q)); const q = await UI.picker('Escolhe uma pergunta', free, null); if (!q) return; const t = await UI.prompt(q, '', 'A tua resposta'); if (t && t.trim()) { e.prompts.push({ q, a: t.trim().slice(0, 120) }); paintPrompts(); } }; pr.appendChild(add); }
      };
      paintPrompts();

      const b = UI.el(`<div class="btn-p mt-grad mt-save">${p ? 'Guardar' : 'Criar perfil'}</div>`); C.appendChild(b);
      let saving = false;
      async function save() {
        if (saving) return;
        d.name = C.querySelector('.f-name').value.trim(); d.age = clamp(+C.querySelector('.f-age').value || 18, 18, 99); d.location = C.querySelector('.f-loc').value.trim(); d.bio = ta.value.trim();
        e.job = C.querySelector('.f-job').value.trim() || null; e.school = C.querySelector('.f-school').value.trim() || null;
        if (!d.name) { UI.toast('Escreve o teu nome'); Sound.play('error'); return; }
        if (!d.photos.length) { UI.toast('Adiciona pelo menos uma foto'); Sound.play('error'); C.scrollTop = 0; return; }
        if (window.CC && CC.requireNet && !CC.requireNet('guardar o perfil')) return;
        saving = true; b.classList.add('busy');
        /* NÃO reenviar as fotos quando ninguém lhes tocou: o servidor mede-as sempre que vêm
           (server/match.lua:178-181) e um perfil antigo com uma referência grande demais deixava de
           conseguir gravar QUALQUER alteração - mudar a bio dava "Não foi possível guardar o perfil". */
        const payload = Object.assign({}, d);
        if (p && photos0 !== null && JSON.stringify(d.photos) === photos0) delete payload.photos;
        const r = await Bridge.rpcRaw(p ? 'match.updateProfile' : 'match.createProfile', payload);
        saving = false; b.classList.remove('busy');
        /* rpcRaw: o 'toolarge' explica-se, em vez de mandar o jogador tentar outra vez para sempre */
        if (!r || r.error) { UI.alert({ title: 'Erro', msg: r && r.error === 'toolarge' ? 'As fotos são grandes demais para guardar. Remove uma ou escolhe outra.' : 'Não foi possível guardar o perfil.' }); return; }
        me = r; Sound.play('success'); onDone(r);
      }
      b.onclick = save;
      if (asRoot) UI.setRoot(win, v); else UI.push(win, v);
      if (focus) setTimeout(() => { const h = C.querySelector(`[data-sec="${focus}"]`); if (h) C.scrollTo({ top: Math.max(0, h.offsetTop - 70), behavior: 'smooth' }); }, 380);
    }

    /* pesquisa do hino no TubeMusic (a mesma pesquisa da app Música) */
    function songPicker(onPick) {
      const v = UI.view({ title: 'O meu hino', back: 'Editar', cls: 'mt-songpick', full: true });
      const res = UI.el('<div class="mt-results"></div>'); let seq = 0, qT = null;
      const s = UI.search('Música ou artista', q => run(q)); v.content.append(s, res);
      const row = it => { const el = UI.el(`<div class="mt-res"><div class="mt-cover"></div><div class="mt-res-t"><b>${esc(it.t)}</b><span>${esc(it.a || '')}</span></div><div class="mt-res-add">${g('plus')}</div></div>`); coverOf(el.querySelector('.mt-cover'), it); el.onclick = () => { onPick({ vid: it.vid || null, t: String(it.t).slice(0, 80), a: String(it.a || '').slice(0, 60), img: it.img || null }); Sound.play('pop'); UI.pop(v); }; return el; };
      const manual = () => { const m = UI.el(`<div class="mt-manual">Escrever título e artista</div>`); m.onclick = async () => { const t = await UI.prompt('Música', '', 'Título'); if (!t || !t.trim()) return; const a = await UI.prompt('Artista', t.trim(), 'Artista'); onPick({ t: t.trim().slice(0, 80), a: (a || '').trim().slice(0, 60) }); UI.pop(v); }; return m; };
      const hint = (title, sub) => UI.el(`<div class="mt-hint">${g('music')}<b>${esc(title)}</b><span>${esc(sub)}</span></div>`);
      const idle = () => { res.innerHTML = ''; const now = window.Music && Music.now; if (now && now.t) { res.appendChild(UI.el('<div class="mt-h">A tocar agora</div>')); res.appendChild(row({ vid: now.vid, t: now.t, a: now.a, img: now.img })); } res.appendChild(hint('Qual é a música que te define?', 'Aparece no teu cartão e quem te vê pode ouvi-la.')); res.appendChild(manual()); };
      function run(q) {
        clearTimeout(qT); if (!q) { seq++; idle(); return; }
        qT = setTimeout(async () => {
          const my = ++seq; res.innerHTML = ''; res.appendChild(UI.spinner());
          /* o UI.search passa o texto em minúsculas; um link colado do YouTube tem o id do vídeo, que distingue maiúsculas */
          const raw = s.input.value.trim();
          const r = await rpc('music.search', { q: raw || q }); if (my !== seq || dead) return;
          const items = [], seen = new Set(); const add = it => { if (it && it.vid && it.t && !seen.has(it.vid)) { seen.add(it.vid); items.push(it); } };
          if (r && r.top) add(r.top); ((r && r.shelves) || []).forEach(sh => (sh.items || []).forEach(add));
          res.innerHTML = '';
          if (!items.length) { res.appendChild(hint(r && r.error ? 'Pesquisa indisponível' : 'Sem resultados', r && r.error ? 'Podes escrever a música à mão.' : 'Tenta outro nome.')); res.appendChild(manual()); return; }
          items.slice(0, 20).forEach(it => res.appendChild(row(it))); res.appendChild(manual());
        }, 350);
      }
      idle(); UI.push(win, v);
    }

    /* =====================================================================
       ARRANQUE
       ===================================================================== */
    async function start() {
      me = await rpc('match.profile'); if (dead) return;
      if (!me || !me.name) {
        const old = win.querySelector(':scope > .tabbar'); old && old.remove();
        const w = UI.view({ title: '', cls: 'mt-welcome-v' });
        const hero = UI.el(`<div class="mt-welcome"><div class="mt-w-art"><div class="c c1"></div><div class="c c2"></div><div class="c c3"><div class="mt-w-stamp">GOSTO</div></div><div class="mt-w-heart">${g('heartFill')}</div></div><div class="mt-w-brand">${flame}<b>match</b></div><p>Conhece pessoas em Los Santos. Mostra quem és (a tua música, os teus interesses) e desliza.</p></div>`);
        [311, 503, 705].forEach((s, i) => setBg(hero.querySelector('.c' + (i + 1)), s));
        const b = UI.el('<div class="btn-p mt-grad mt-w-btn">Criar perfil</div>'); b.onclick = () => profileForm(null, () => build(), false);
        w.content.append(hero, b, UI.el('<div class="mt-w-legal">Ao continuar confirmas que tens 18 anos ou mais.</div>')); UI.setRoot(win, w); return;
      }
      build();
    }
    function build() { const old = win.querySelector(':scope > .tabbar'); old && old.remove(); tabs = UI.tabbar(win, [{ icon: 'flame', label: 'Descobrir', view: discover }, { icon: 'message', label: 'Matches', view: matches }, { icon: 'personCircle', label: 'Perfil', view: profile }], 0); }
    start();
    const off1 = Bridge.on('message', m => { if (!m || m.app !== APP) return; if (chatOpen && chatOpen.other === m.sender && System.currentApp() === APP) { chatOpen.append(m); rpc('messages.read', { number: m.sender, app: APP }); } else { Notify.push({ app: APP, title: 'Nova mensagem', msg: m.content, onTap: () => { System.openApp(APP); setTimeout(() => tabs && tabs.go(1), 300); } }); rpc('match.matches').then(l => System.badge(APP, (l || []).reduce((a, x) => a + (x.unread || 0), 0))); } });
    const off2 = Bridge.on('match', d => { if (d && d.profile && me) celebrate(d.profile); });
    win.onClose = () => { dead = true; off1(); off2(); const d = App.get(APP); if (d) d.statusBar = undefined; };
  }
});
Bridge.on('match', d => { if (d && d.profile && System.currentApp() !== 'match') Notify.push({ app: 'match', title: 'É um Match! 💘', msg: `Tu e ${d.profile.name} gostaram um do outro`, onTap: () => System.openApp('match') }); });

/* ---------- fallback browser ---------- */
if (window.LocalDB && LocalDB.register) (() => {
  const P = () => LocalDB.T('match_profiles'), S = () => LocalDB.T('match_swipes'), M = () => LocalDB.T('match_matches');
  const me = () => LocalDB.player();
  const EX = [
    { want: 'Relação séria', height: 168, zodiac: 'Leão', job: 'Fotógrafa', song: { vid: 'JGwWNGJdvx8', t: 'Shape of You', a: 'Ed Sheeran', img: 'https://i.ytimg.com/vi/JGwWNGJdvx8/mqdefault.jpg' }, artists: ['Ed Sheeran', 'Dua Lipa'], interests: ['Praia', 'Fotografia', 'Café', 'Viagens'], prompts: [{ q: 'O meu sítio favorito da cidade é…', a: 'O pontão de Del Perro ao pôr-do-sol.' }], drinks: 'Socialmente', pets: 'Cão' },
    { want: 'Algo casual', height: 182, job: 'Mecânico', song: { vid: 'OPf0YbXqDm0', t: 'Uptown Funk', a: 'Mark Ronson', img: 'https://i.ytimg.com/vi/OPf0YbXqDm0/mqdefault.jpg' }, artists: ['Bruno Mars'], interests: ['Carros', 'Música', 'Festas'], workout: 'Às vezes' },
    { want: 'Ainda a descobrir', zodiac: 'Peixes', interests: ['Café', 'Fitness', 'Leitura', 'Cinema'], prompts: [{ q: 'Não consigo viver sem…', a: 'Um bom café e uma corrida de manhã.' }] },
    { want: 'Novas amizades', height: 178, job: 'Piloto', interests: ['Carros', 'Motas', 'Viagens'], song: { vid: 'RgKAFK5djSk', t: 'See You Again', a: 'Wiz Khalifa', img: 'https://i.ytimg.com/vi/RgKAFK5djSk/mqdefault.jpg' } },
    { want: 'Relação séria', zodiac: 'Balança', school: 'Direito', interests: ['Leitura', 'Arte', 'Moda', 'Séries'], artists: ['Taylor Swift'] },
    { height: 185, interests: ['Surf', 'Praia', 'Natureza'], song: { vid: 'kJQP7kiw5Fk', t: 'Despacito', a: 'Luis Fonsi', img: 'https://i.ytimg.com/vi/kJQP7kiw5Fk/mqdefault.jpg' } },
  ];
  const seed = () => { if (P().all().length) return; [['Sofia', 24, 'Mulher', 'Todos', 'Amo pôr-do-sol em Del Perro 🌅', 'Del Perro', [311, 77, 45]], ['Miguel', 29, 'Homem', 'Mulheres', 'Mecânico de dia, DJ à noite 🎧', 'Vinewood', [402, 88]], ['Carla', 27, 'Mulher', 'Homens', 'Café, corridas e bons planos ☕', 'Mirror Park', [503, 21]], ['Rafael', 31, 'Homem', 'Todos', 'Piloto de Sultan. Procuro copiloto.', 'Sandy Shores', [604]], ['Inês', 22, 'Mulher', 'Todos', 'Estudante de direito 👩‍⚖️', 'Rockford Hills', [705, 33, 12]], ['Tomás', 26, 'Homem', 'Mulheres', 'Surf em Vespucci 🏄', 'Vespucci', [806]]].forEach(([name, age, gender, seeking, bio, location, photos], i) => P().insert({ owner: 'npc' + i, phone: '555-09' + (10 + i), name, age, gender, seeking, bio, location, photos, extras: EX[i], superMe: i === 0, created: Date.now() - i * 864e5 })); };
  const clean = x => { x = x || {}; const s = (v, n) => (typeof v === 'string' || typeof v === 'number') && String(v).trim() ? String(v).slice(0, n) : null; const arr = (a, n, l) => (Array.isArray(a) ? a : []).map(v => s(v, l)).filter(Boolean).slice(0, n); const o = { artists: arr(x.artists, 5, 30), interests: arr(x.interests, 5, 24), prompts: (Array.isArray(x.prompts) ? x.prompts : []).filter(q => q && s(q.q, 60) && s(q.a, 120)).slice(0, 3).map(q => ({ q: s(q.q, 60), a: s(q.a, 120) })) }; if (x.song && s(x.song.t, 80)) o.song = { t: s(x.song.t, 80), a: s(x.song.a, 60) || '', img: /^https:\/\//.test(x.song.img || '') ? x.song.img : null, vid: /^[\w-]+$/.test(x.song.vid || '') ? x.song.vid : null }; ['job', 'school', 'zodiac', 'want', 'drinks', 'smoke', 'pets', 'workout'].forEach(k => { o[k] = s(x[k], 40); }); const h = +x.height; if (h >= 120 && h <= 230) o.height = Math.floor(h); return o; };
  const mine = () => P().all().find(p => p.owner === 'DEV0000') || null;
  LocalDB.register('match.profile', () => { seed(); return mine(); });
  LocalDB.register('match.createProfile', d => { seed(); return P().insert({ owner: 'DEV0000', phone: me().phone, name: d.name, age: d.age, gender: d.gender, seeking: d.seeking, bio: d.bio || '', location: d.location || '', photos: d.photos || [], extras: clean(d.extras), created: Date.now() }); });
  LocalDB.register('match.updateProfile', d => { const p = mine(); if (!p) return { error: 'noprofile' }; const up = Object.fromEntries(Object.entries(d).filter(([k]) => ['name', 'age', 'gender', 'seeking', 'bio', 'location', 'photos', 'paused'].includes(k))); if (d.extras !== undefined) up.extras = clean(d.extras); return P().update(p.id, up); });
  LocalDB.register('match.deleteProfile', () => { const p = mine(); if (p) P().remove(p.id); return { ok: true }; });
  /* como o servidor (match.lua:201-209): o cartão do deck NÃO leva o número nem o citizenid de ninguém
     - só o match mútuo é que traz o `phone`, no `profile` do match.swipe. A cópia rasa serve ainda para
     o telemóvel não escrever por cima das linhas da base de dados de mentira. */
  const cardOf = x => { const c = Object.assign({}, x); delete c.phone; delete c.owner; return c; };
  LocalDB.register('match.cards', () => { seed(); const p = mine(); if (!p) return []; const sw = S().all().filter(s => s.owner === 'DEV0000').map(s => s.target); return P().all().filter(x => x.owner !== 'DEV0000' && !x.paused && !sw.includes(x.id) && (p.seeking === 'Todos' || (p.seeking === 'Homens' && x.gender === 'Homem') || (p.seeking === 'Mulheres' && x.gender === 'Mulher'))).map(cardOf); });
  LocalDB.register('match.swipe', d => { S().insert({ owner: 'DEV0000', target: d.target, liked: d.like ? (d.super ? 2 : 1) : 0, created: Date.now() }); const t = P().all().find(x => x.id === d.target); if (d.like && t && (d.super || S().all().filter(s => s.owner === 'DEV0000').length % 3 === 0)) { M().insert({ a: 'DEV0000', b: t.owner, profile: t.id, created: Date.now() }); return { matched: true, profile: t }; } return { matched: false }; });
  LocalDB.register('match.matches', () => { const msgs = LocalDB.T('messages').all().filter(m => m.app === 'match'); const my = me().phone; return M().all().map(m => { const p = P().all().find(x => x.id === m.profile); if (!p) return null; const th = msgs.filter(x => (x.sender === my && x.receiver === p.phone) || (x.sender === p.phone && x.receiver === my)).sort((a, b) => a.created - b.created); return { id: m.id, profile: p, last: th.at(-1) || null, unread: th.filter(x => x.receiver === my && !x.read).length, created: m.created }; }).filter(Boolean).sort((a, b) => ((b.last && b.last.created) || b.created) - ((a.last && a.last.created) || a.created)); });
  LocalDB.register('match.unmatch', d => { M().remove(d.id); return { ok: true }; });
})();
