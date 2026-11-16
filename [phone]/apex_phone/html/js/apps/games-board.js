/* ===================== JOGOS DE TABULEIRO (apex_phone 1.5.0, ronda 2) =====================
   Xadrez, Damas, Quatro em Linha e Jogo do Galo (com o modo Ultimate), sobre a casca comum do
   games.js (Arcade.shell + extensões 1.5.0: A.ready, A.options, A.flash, A.haptic, A.sfx, A.end,
   Arcade.match, Arcade.matchUI; ronda 2: A.celebrate, A.countdown, A.toast, A.howto, chamadas de
   forma defensiva). Carrega DEPOIS de games.js. Os puzzles (Sudoku, Palavras, Solitário, Luzes,
   Deslizante) vivem em games-puzzle.js.

   Regras cumpridas em todos os jogos:
     · nada arranca sem o "Toca para começar" (A.ready);
     · tabuleiros em DOM construídos UMA vez, peças em SVG próprio (nunca Unicode nem emoji), a mexer
       só com transform/opacity; a posição é o transform do nó exterior e a animação (salto, entrada,
       saída, ressalto) é do nó interior, para nunca se pisarem;
     · zero requestAnimationFrame (tudo por eventos); cronómetros com setInterval que morrem em
       pause()/onClose; zero getBoundingClientRect (toques por eventos nas casas);
     · inteligência artificial em pedaços (await entre jogadas de raiz) para a interface não bloquear;
     · texto visível em português (chaves de tradução), classes CSS com prefixo por jogo (.gch-, .gdm-,
       .gc4-, .gtt-) e .gbd- para o que é partilhado.
   ============================================================================================ */
(() => {
if (!window.Arcade || !window.App || !window.UI) return;
const g = UI.g, esc = UI.esc, el = UI.el;
const ENG = {};            /* motores de lógica pura (também lidos pelos testes em Node: window.__gb.eng) */
const LIVE = { game: null };

/* ---------- utilitários ---------- */
const SFX = { hit: 'pop', score: 'click', win: 'success', lose: 'error', tick: 'tick', move: 'tap', capture: 'pop', bad: 'nope', level: 'success', flip: 'tap', place: 'tap', slide: 'tap', chime: 'click', fail: 'nope', count: 'tick', pop: 'pop', bounce: 'tap' };
const snd = n => { try { Sound.play(SFX[n] || n); } catch (e) {} };
const sleep = ms => new Promise(r => setTimeout(r, ms));
const fmtT = s => { s = Math.max(0, s | 0); const m = (s / 60) | 0, x = s % 60; return m + ':' + (x < 10 ? '0' : '') + x; };
const rnd = n => (Math.random() * n) | 0;
/* dia local (o mesmo para toda a gente no mesmo fuso): semente dos puzzles do dia */
const dayIndex = () => { const d = new Date(); return Math.floor((d.getTime() - d.getTimezoneOffset() * 60000) / 864e5); };
/* gerador determinista (mulberry32) */
const seeded = s => { let a = (s >>> 0) || 1; return () => { a = (a + 0x6D2B79F5) >>> 0; let t = a; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; };
const myName = () => { try { const p = (window.System && System.player) || {}; const n = ((p.firstname || '') + ' ' + (p.lastname || '')).trim(); return n || (window.System && System.account && System.account.username) || 'Tu'; } catch (e) { return 'Tu'; } };
const myAvatar = () => { try { return UI.avatar({ name: myName(), avatar: (window.System && System.account && System.account.avatar) || 0 }, 'sm'); } catch (e) { return g('person', 18); } };
const avatarOf = (name, seed) => { try { return UI.avatar({ name: name || '?', avatar: seed || 0 }, 'sm'); } catch (e) { return g('person', 18); } };
const plural = (n, one, many) => `${n} ${n === 1 ? one : many}`;

/* ---------- ponte para as extensões da casca ----------
   O games.js dá A.ready/A.options/A.flash/A.haptic/A.sfx/A.end (1.5.0) e, nesta ronda, A.celebrate/A.countdown/A.toast/A.howto.
   Tudo o que pode faltar (casca mais antiga ou o HUB ainda a meio) tem aqui uma versão mínima, para o jogo nunca partir. */
function X(A) {
  const stage = A.el.stage;
  return {
    ready(title, sub) {
      if (A.ready) return A.ready(title, sub);
      return new Promise(res => {
        const ov = el(`<div class="gbd-ready"><b>${esc(title || '')}</b><span>Toca para começar</span></div>`);
        stage.appendChild(ov);
        ov.addEventListener('pointerdown', () => { ov.remove(); res(); }, { once: true });
      });
    },
    options(list) {
      if (A.options) return A.options(list);
      let bar = A.el.ctl.querySelector('.gbd-opts');
      if (!bar) { bar = el('<div class="gbd-opts"></div>'); A.el.ctl.appendChild(bar); }
      bar.innerHTML = '';
      list.forEach(o => {
        const b = el(`<div class="gbd-opt"><span>${esc(o.label)}</span><b></b></div>`);
        const paint = () => { const c = o.values.find(v => String(v.v) === String(o.cur)); b.querySelector('b').textContent = c ? c.label : ''; };
        b.onclick = async () => {
          const r = await UI.actionSheet({ title: o.label, buttons: o.values.map(v => ({ label: v.label, value: String(v.v) })) });
          if (r === null || r === undefined) return;
          const v = o.values.find(z => String(z.v) === r); if (!v || String(v.v) === String(o.cur)) return;
          o.cur = v.v; paint(); o.onChange && o.onChange(v.v);
        };
        paint(); bar.appendChild(b);
      });
      return { set() {}, el: bar };
    },
    flash(msg, cls) {
      if (A.flash) return A.flash(msg, cls);
      const f = el(`<div class="gbd-flash ${cls || ''}">${esc(msg)}</div>`);
      stage.appendChild(f); setTimeout(() => f.remove(), 950);
    },
    haptic(k) { if (A.haptic) return A.haptic(k || 'light'); snd('move'); },
    sfx(n) { if (A.sfx) { try { A.sfx(n); } catch (e) {} return; } snd(n); },
    end(o) { if (A.end) return A.end(o); A.gameOver(o.title, o.sub, o.score == null ? 0 : o.score); },
    celebrate(k) { if (A.celebrate) { try { A.celebrate(k || 'win'); } catch (e) {} } },
    toast(m) { if (A.toast) { try { A.toast(m); return; } catch (e) {} } UI.toast(m); },
    howto() { if (A.howto) { try { A.howto(); return true; } catch (e) {} } return false; },
  };
}

/* ---------- cronómetro pausável (segundos inteiros; cb a cada meio segundo) ---------- */
function Chrono(win, cb) {
  let t0 = 0, acc = 0, iv = null;
  const secs = () => ((acc + (t0 ? Date.now() - t0 : 0)) / 1000) | 0;
  const api = {
    secs,
    get running() { return !!t0; },
    start() { if (t0) return; t0 = Date.now(); clearInterval(iv); iv = setInterval(() => cb(secs()), 500); win.timers.push(iv); cb(secs()); },
    stop() { if (t0) { acc += Date.now() - t0; t0 = 0; } clearInterval(iv); iv = null; },
    reset() { api.stop(); acc = 0; cb(0); },
  };
  return api;
}

/* ---------- contagens locais de vitórias (contra o telemóvel por nível, e online) para o HUD e os cartões ---------- */
const WINS = 'gbWins';
const winsOf = k => { const m = Store.get(WINS, null) || {}; return (m[k] | 0) || 0; };
const addWin = k => { const m = Object.assign({}, Store.get(WINS, null) || {}); m[k] = (m[k] | 0) + 1; Store.set(WINS, m); return m[k]; };
const flagAch = k => { try { if (Arcade.flag) Arcade.flag(k); } catch (e) {} };
const maxAch = (k, n) => { try { if (Arcade.maxStat) Arcade.maxStat(k, n); } catch (e) {} };

/* ---------- cursor de teclado comum (setas movem, Enter/Espaço escolhe) ---------- */
function Cursor(cols, rows, onMove, onPick) {
  let r = -1, c = -1;
  return {
    get on() { return r >= 0; },
    get idx() { return r < 0 ? -1 : r * cols + c; },
    set(i) { r = (i / cols) | 0; c = i % cols; onMove(r * cols + c); },
    clear() { r = -1; c = -1; onMove(-1); },
    key(e) {
      const k = e.key;
      const d = { ArrowUp: [0, -1], ArrowDown: [0, 1], ArrowLeft: [-1, 0], ArrowRight: [1, 0], w: [0, -1], s: [0, 1], a: [-1, 0], d: [1, 0], W: [0, -1], S: [0, 1], A: [-1, 0], D: [1, 0] }[k];
      if (d) { e.preventDefault(); if (r < 0) { r = (rows / 2) | 0; c = (cols / 2) | 0; } else { c = Math.max(0, Math.min(cols - 1, c + d[0])); r = Math.max(0, Math.min(rows - 1, r + d[1])); } onMove(r * cols + c); return true; }
      if ((k === 'Enter' || k === ' ') && r >= 0) { e.preventDefault(); onPick(r * cols + c); return true; }
      return false;
    },
  };
}

/* ---------- ONLINE: partidas por turnos (server/arcade.lua, RPCs arcade.match.*) ----------
   Payload de uma partida (RPCs e push arcade:match): { id, game, you: 'a'|'b', turn: 'a'|'b', players: { a, b },
   opponent: { name }, state, moves, left, ended, winner: 'a'|'b'|'draw'|null, reason, last }.
   c4/ttt: o servidor valida (move = { col } / { cell }, state.board = 42/9 casas com 0/1/2, a = 1, b = 2).
   chess/checkers: o estado é dos clientes (JSON até 16 KB no `state` de cada jogada; `end.winner` = 'a'|'b'|0 acaba).
   NADA disto mudou na ronda 2: o contrato de rede é o mesmo. */
const Online = (() => {
  const pend = {};   /* convites recebidos enquanto o jogo está aberto (a faixa do games.js trata dos outros) */
  if (window.Bridge && Bridge.on) Bridge.on('arcade:invite', d => { if (d && d.game && d.id) pend[d.game] = d; });
  const parse = s => { if (!s) return null; if (typeof s === 'object') return s; try { return JSON.parse(s); } catch (e) { return null; } };
  const oppName = m => (m && m.opponent && m.opponent.name) || (m && m.players && m.players[m.you === 'a' ? 'b' : 'a']) || 'Adversário';
  const takePending = game => { const p = window.Arcade.pendingMatch; if (p && p.game === game && p.id && !p.ended) { Arcade.pendingMatch = null; return p; } return null; };
  const invite = game => pend[game] || null;
  const clearInvite = game => { delete pend[game]; };
  function join(A, m, h) {
    let applied = m.moves || 0, ended = !!m.ended;
    const ui = Arcade.matchUI ? Arcade.matchUI(A, m, { auto: false, onMove: cur => {
      if (ended) return;
      if (cur.ended) { ended = true; h.onEnd(cur); return; }
      if ((cur.moves || 0) <= applied) return;
      applied = cur.moves || 0;
      if (cur.turn === cur.you) h.onOpp(cur, parse(cur.state));
    } }) : null;
    return {
      m, you: m.you, other: m.you === 'a' ? 'b' : 'a', name: oppName(m),
      get ended() { return ended; },
      send(move, state) {
        const d = { id: m.id, move }; if (state !== undefined) d.state = typeof state === 'string' ? state : JSON.stringify(state);
        return Arcade.match.move(d).then(r => { if (r && !r.error) { applied = Math.max(applied, r.moves || 0); if (r.ended && !ended) { ended = true; h.onEnd(r); } } return r || { error: 'offline' }; });
      },
      leave() { ended = true; if (ui) ui.destroy(); return Arcade.match.leave({ id: m.id }); },
      destroy() { ended = true; if (ui) ui.destroy(); },
    };
  }
  return { parse, oppName, takePending, invite, clearInvite, join };
})();

/* ---------- retratos dos adversários (SVG próprio, viewBox 64): seis caras, cor por nível ---------- */
const FACE = {
  kid: c => `<circle cx="32" cy="34" r="13" fill="#F3C9A6"/><path d="M19 32c0-9 6-15 13-15s13 6 13 15c-3-4-7-6-13-6s-10 2-13 6z" fill="#5B3A1E"/><path d="M44 30l5-6-2 9z" fill="#5B3A1E"/><circle cx="27" cy="35" r="1.8" fill="#2B2320"/><circle cx="37" cy="35" r="1.8" fill="#2B2320"/><path d="M27 41c2 2.6 8 2.6 10 0" stroke="#A3573A" stroke-width="1.6" fill="none" stroke-linecap="round"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/>`,
  young: c => `<path d="M17 40c0-14 6-22 15-22s15 8 15 22l-3 14H20z" fill="#2A1A10"/><circle cx="32" cy="35" r="12.5" fill="#E8B894"/><path d="M20 31c2-8 6-11 12-11s10 3 12 11c-3-3-7-4-12-4s-9 1-12 4z" fill="#2A1A10"/><circle cx="27.5" cy="36" r="1.7" fill="#2B2320"/><circle cx="36.5" cy="36" r="1.7" fill="#2B2320"/><path d="M28 42c1.6 2 6.4 2 8 0" stroke="#9B4A33" stroke-width="1.5" fill="none" stroke-linecap="round"/><circle cx="20" cy="40" r="1.4" fill="#FFD60A"/><circle cx="44" cy="40" r="1.4" fill="#FFD60A"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/>`,
  glasses: c => `<circle cx="32" cy="34" r="13" fill="#D9A47E"/><path d="M19 30c1-8 6-12 13-12s12 4 13 12c-4-3-8-4-13-4s-9 1-13 4z" fill="#6E6E78"/><circle cx="27" cy="36" r="4.6" fill="none" stroke="#1C1C22" stroke-width="1.6"/><circle cx="37" cy="36" r="4.6" fill="none" stroke="#1C1C22" stroke-width="1.6"/><path d="M31.6 36h.8" stroke="#1C1C22" stroke-width="1.6"/><circle cx="27" cy="36" r="1.5" fill="#2B2320"/><circle cx="37" cy="36" r="1.5" fill="#2B2320"/><path d="M28 43h8" stroke="#8C4A33" stroke-width="1.5" stroke-linecap="round"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/><path d="M26 50l6 6 6-6" fill="#fff" opacity=".9"/>`,
  bun: c => `<circle cx="32" cy="18" r="6" fill="#3B2412"/><circle cx="32" cy="35" r="12.5" fill="#F1C7A3"/><path d="M19 33c0-9 5-14 13-14s13 5 13 14c-3-3-8-5-13-5s-10 2-13 5z" fill="#3B2412"/><circle cx="27.5" cy="36" r="1.7" fill="#2B2320"/><circle cx="36.5" cy="36" r="1.7" fill="#2B2320"/><path d="M28 41.5c1.6 2.4 6.4 2.4 8 0" stroke="#B0503B" stroke-width="1.5" fill="none" stroke-linecap="round"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/><circle cx="32" cy="55" r="2.2" fill="#fff" opacity=".85"/>`,
  beard: c => `<circle cx="32" cy="33" r="13" fill="#E3B48F"/><path d="M19 30c0-8 5-13 13-13s13 5 13 13c-3-3-8-4-13-4s-10 1-13 4z" fill="#D8D8DC"/><path d="M19 36c0 8 5 14 13 14s13-6 13-14c-2 3-5 4-7 3-2 2-4 2-6 2s-4 0-6-2c-2 1-5 0-7-3z" fill="#D8D8DC"/><circle cx="27" cy="34" r="1.7" fill="#2B2320"/><circle cx="37" cy="34" r="1.7" fill="#2B2320"/><path d="M28.5 40h7" stroke="#8C4A33" stroke-width="1.4" stroke-linecap="round"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/><path d="M22 20l3-7 4 5 3-8 3 8 4-5 3 7z" fill="#FFD60A"/>`,
  robot: c => `<rect x="19" y="22" width="26" height="24" rx="7" fill="#C9CED8"/><rect x="22" y="25" width="20" height="10" rx="4" fill="#1A1C24"/><circle cx="28" cy="30" r="2.2" fill="#5EE3FF"/><circle cx="36" cy="30" r="2.2" fill="#5EE3FF"/><rect x="26" y="39" width="12" height="3" rx="1.5" fill="#1A1C24"/><path d="M32 22v-6" stroke="#C9CED8" stroke-width="2.4" stroke-linecap="round"/><circle cx="32" cy="14" r="2.6" fill="#FF375F"/><rect x="15" y="29" width="4" height="8" rx="2" fill="#9AA0AD"/><rect x="45" y="29" width="4" height="8" rx="2" fill="#9AA0AD"/><path d="M14 64c2-9 9-14 18-14s16 5 18 14z" fill="${c}"/>`,
};
const portrait = (face, color, size) => `<svg viewBox="0 0 64 64" width="${size || 44}" height="${size || 44}" class="gbd-face"><defs><linearGradient id="gbdF${face}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${color}" stop-opacity=".55"/><stop offset="1" stop-color="${color}" stop-opacity=".18"/></linearGradient></defs><circle cx="32" cy="32" r="31" fill="url(#gbdF${face})"/><circle cx="32" cy="32" r="31" fill="none" stroke="rgba(255,255,255,.18)" stroke-width="1.5"/>${(FACE[face] || FACE.kid)(color)}</svg>`;

/* ---------- ecrã inicial comum dos jogos de dois ----------
   o = { game, name, tagline, cover, levels: [{ v, label, name, face, color }], level, extra: { key, title, sub, icon, done } }
   Devolve { mode: 'ia', level } | { mode: 'local' } | { mode: 'online', m } | { mode: <extra.key> } | null. */
async function lobby(A, o) {
  const stage = A.el.stage;
  return new Promise(res => {
    let level = o.level, done = false, offPush = null, inviteId = null, contacts = [];
    if (!o.levels.some(l => l.v === level)) level = o.levels[Math.min(1, o.levels.length - 1)].v;
    const inv = Online.invite(o.game);
    const lvOf = v => o.levels.find(l => l.v === v) || o.levels[0];
    const box = el(`<div class="gbd-lobby">
      <div class="gbd-cover">${o.cover ? o.cover() : ''}<div class="gbd-cv-txt"><b>${esc(o.name)}</b><span>${esc(o.tagline || '')}</span></div></div>
      <div class="gbd-sec"><b>Contra o telemóvel</b><span class="gbd-sec-r">Escolhe o adversário</span></div>
      <div class="gbd-opps">${o.levels.map(l => `<div class="gbd-opp ${l.v === level ? 'on' : ''}" data-v="${esc(l.v)}" style="--oc:${l.color}"><div class="gbd-port">${portrait(l.face, l.color, 44)}</div><b data-noi18n>${esc(l.name)}</b><span>${esc(l.label)}</span><i data-noi18n></i></div>`).join('')}</div>
      <div class="gbd-main"><span class="ic">${g('play', 18)}</span><span class="t">Jogar contra</span> <b class="who" data-noi18n></b></div>
      <div class="gbd-two">
        <div class="gbd-mini local"><div class="mi">${g('users', 22)}</div><div class="mb"><b>Dois jogadores</b><span>No mesmo telemóvel</span></div></div>
        ${o.extra ? `<div class="gbd-mini extra ${o.extra.done ? 'done' : ''}" data-k="${esc(o.extra.key)}"><div class="mi">${g(o.extra.icon || 'sparkles', 22)}</div><div class="mb"><b>${esc(o.extra.title)}</b><span>${esc(o.extra.sub || '')}</span></div>${o.extra.done ? `<div class="ok">${g('check', 14)}</div>` : ''}</div>` : ''}
      </div>
      <div class="gbd-online">
        <div class="gbd-sec"><b>Online</b><span class="gbd-sec-r">Contra outro jogador do servidor</span></div>
        <div class="gbd-avs"><div class="gbd-av-c near"><div class="gbd-av-ring">${g('location', 20)}</div><span>Perto</span></div><div class="gbd-av-more"><span>A carregar contactos</span></div></div>
        <div class="gbd-row"><div class="gbd-chip act pend ${inv ? '' : 'off'}" data-k="pend"></div><div class="gbd-chip act cur off" data-k="cur"></div></div>
      </div>
      <div class="gbd-wait"><div class="wav"><div class="ring"></div><div class="av"></div></div><b>À espera do adversário</b><span class="who" data-noi18n></span><div class="btn-p btn-s cancel">Cancelar</div></div>
    </div>`);
    stage.appendChild(box);
    A.el.ctl.classList.add('gbd-lob');   /* as ferramentas da partida (Desfazer, Dica...) somem enquanto o lobby está à vista */
    const main = box.querySelector('.gbd-main');
    const paintLv = () => { const l = lvOf(level); box.querySelectorAll('.gbd-opp').forEach(z => { z.classList.toggle('on', z.dataset.v === level); const w = winsOf(o.game + ':' + z.dataset.v); z.querySelector('i').textContent = w ? plural(w, 'vitória', 'vitórias') : ''; }); main.querySelector('.who').textContent = l.name; main.style.setProperty('--oc', l.color); };
    paintLv();
    const finish = r => { if (done) return; done = true; if (offPush) offPush(); box.remove(); A.el.ctl.classList.remove('gbd-lob'); res(r); };
    box.querySelectorAll('.gbd-opp').forEach(c => { c.onclick = () => { if (level !== c.dataset.v) { level = c.dataset.v; Arcade.setOpt(o.game + ':lv', level); paintLv(); snd('move'); } }; });
    main.onclick = () => { snd('move'); finish({ mode: 'ia', level }); };
    box.querySelector('.gbd-mini.local').onclick = () => { snd('move'); finish({ mode: 'local' }); };
    const ex = box.querySelector('.gbd-mini.extra'); if (ex) ex.onclick = () => { snd('move'); finish({ mode: ex.dataset.k, level }); };
    const joinM = m => { Online.clearInvite(o.game); finish({ mode: 'online', m }); };
    /* à espera de o outro aceitar: a partida chega por push (id novo, moves 0); a recusa chega com invite:true */
    const waitFor = (id, who) => {
      inviteId = id; box.classList.add('waiting'); box.querySelector('.gbd-wait .who').textContent = who || ''; box.querySelector('.gbd-wait .av').innerHTML = avatarOf(who);
      if (offPush) offPush();
      offPush = Bridge.on('arcade:match', d => {
        if (!d || d.game !== o.game) return;
        if (d.invite) { if (String(d.id) === String(inviteId)) { box.classList.remove('waiting'); inviteId = null; } return; }
        if (d.id && !d.ended) joinM(d);
      });
    };
    box.querySelector('.cancel').onclick = () => { box.classList.remove('waiting'); if (inviteId) Arcade.match.decline({ id: inviteId }); inviteId = null; if (offPush) { offPush(); offPush = null; } };
    const errText = e => e === 'offline' ? 'Esse jogador não está online' : e === 'busy' ? 'Já há uma partida deste jogo a decorrer' : e === 'self' ? 'Não te podes convidar a ti próprio' : e === 'target' ? 'Esse número não tem telemóvel' : e === 'far' ? 'Esse jogador está demasiado longe' : e === 'rate' ? 'Espera um momento antes de convidar outra vez' : 'Não foi possível convidar';
    const invite = async (target, who) => {
      const r = await Arcade.match.invite(Object.assign({ game: o.game }, target));
      if (!r || r.error || !r.id) { UI.toast(errText(r && r.error)); return; }
      waitFor(r.id, who);
    };
    const pick = async (title, rows) => {
      if (!rows.length) { UI.toast('Ninguém disponível'); return null; }
      const r = await UI.actionSheet({ title, buttons: rows.slice(0, 8).map((c, i) => ({ label: c.label, value: String(i) })) });
      return r == null ? null : rows[+r];
    };
    /* contactos com avatar (UI.avatar): os cinco primeiros na fila, o resto numa folha */
    const avs = box.querySelector('.gbd-avs'), more = box.querySelector('.gbd-av-more');
    const paintContacts = () => {
      more.remove();
      const list = contacts.filter(c => c && c.number);
      list.slice(0, 4).forEach(c => { const a = el(`<div class="gbd-av-c"><div class="gbd-av-ring">${avatarOf(c.name || c.number, c.avatar)}</div><span data-noi18n>${esc((c.name || c.number).split(' ')[0])}</span></div>`); a.onclick = () => invite({ number: c.number }, c.name || c.number); avs.appendChild(a); });
      if (list.length > 4) { const m = el(`<div class="gbd-av-c"><div class="gbd-av-ring plus">${g('more', 20)}</div><span>Mais</span></div>`); m.onclick = async () => { const c = await pick('Convidar um contacto', list.map(c => ({ label: c.name || c.number, number: c.number }))); if (c) invite({ number: c.number }, c.label); }; avs.appendChild(m); }
      if (!list.length) avs.appendChild(el('<div class="gbd-av-more"><span>Sem contactos com telemóvel</span></div>'));
    };
    (async () => { try { const cs = await Bridge.rpc('contacts.list'); contacts = Array.isArray(cs) ? cs : []; } catch (e) { contacts = []; } if (!done) paintContacts(); })();
    box.querySelector('.gbd-av-c.near').onclick = async () => {
      const list = await Arcade.match.nearby();
      const c = await pick('Quem está perto', (list || []).map(p => ({ label: (p.name || p.number || '?') + (p.dist != null ? ` · ${Math.round(p.dist)} m` : ''), src: p.src, number: p.number, name: p.name })));
      if (c) invite(c.src != null ? { src: c.src } : { number: c.number }, c.name || c.label);
    };
    const pendChip = box.querySelector('.pend');
    const paintPend = () => { const p = Online.invite(o.game); pendChip.classList.toggle('off', !p); pendChip.innerHTML = p ? `${g('bell', 14)}<span>Convite de</span> <b data-noi18n>${esc(p.from || 'Alguém')}</b>` : ''; };
    paintPend();
    pendChip.onclick = async () => {
      const p = Online.invite(o.game); if (!p) { UI.toast('Sem convites pendentes'); paintPend(); return; }
      const who = p.from || 'Alguém';
      if (!await UI.confirm('Convite pendente', `${who} convidou-te para jogar. Aceitar?`, 'Aceitar')) { Arcade.match.decline({ id: p.id }); Online.clearInvite(o.game); paintPend(); return; }
      const r = await Arcade.match.accept({ id: p.id });
      Online.clearInvite(o.game); paintPend();
      if (!r || r.error || !r.id) { UI.toast(r && r.error === 'busy' ? 'Já há uma partida deste jogo a decorrer' : 'O convite já não está disponível'); return; }
      joinM(r);
    };
    /* partida deste jogo já a decorrer no servidor (saímos a meio): o servidor diz-nos */
    let curM = null;
    const curChip = box.querySelector('.cur');
    if (window.Arcade.match && Arcade.match.pending) Arcade.match.pending(o.game).then(m => { if (done || !m) return; curM = m; curChip.classList.remove('off'); curChip.innerHTML = `${g('play', 14)}<span>Partida em curso com</span> <b data-noi18n>${esc(Online.oppName(m))}</b>`; }).catch(() => {});
    curChip.onclick = () => { if (curM) joinM(curM); };
    box._cancel = () => finish(null);
  });
}

/* só para os ganchos de teste: fecha o lobby que estiver à vista (o start do teste entra logo no jogo) */
const closeLobby = stage => { const b = stage.querySelector('.gbd-lobby'); if (b && b._cancel) b._cancel(); };

/* ---------- cartão de jogador (avatar, nome, estado, relógio ou contagem) usado pelos jogos de dois ---------- */
const playerCard = (cls, name, sub) => `<div class="gbd-pl ${cls}"><div class="gbd-av">${g('person', 18)}</div><div class="gbd-nm"><b data-noi18n>${esc(name)}</b><span>${esc(sub || '')}</span></div><div class="gbd-clk"></div></div>`;
const setCard = (card, name, sub, avatarHtml) => { card.querySelector('.gbd-nm b').textContent = name; const s = card.querySelector('.gbd-nm span'); if (sub !== undefined) s.textContent = sub; if (avatarHtml !== undefined) card.querySelector('.gbd-av').innerHTML = avatarHtml; };
/* resultado de uma partida online para o painel da casca (o servidor já registou a vitória na tabela) */
const mpEnd = (x, game, title, sub, win, stats) => x.end({ title, sub, score: null, submit: false, mp: true, win, board: game, stats });
const mpWhy = (cur, link) => cur.reason === 'timeout' ? (cur.winner === link.you ? `${link.name} ficou sem tempo` : 'Ficaste sem tempo') : cur.reason === 'left' ? (cur.winner === link.you ? `${link.name} saiu da partida` : 'Saíste da partida') : null;
/* botões da barra de controlos (texto PT + glifo) */
const tool = (cls, icon, label, off) => `<div class="gb lbl ${cls} ${off ? 'off' : ''}">${g(icon)}<span>${esc(label)}</span></div>`;
/* o adversário de nível: nome, cara e cor */
const oppOf = (LVL, v) => LVL.find(l => l.v === v) || LVL[0];

/* =====================================================================
   XADREZ: motor 0x88 (regras completas), tabela de transposição com Zobrist, negamax alfa-beta com
   ordenação de jogadas e quiescência curta; a pensar por pedaços (await entre jogadas de raiz).
   Ronda 2: cinco níveis, aberturas, notação (figurinos), puzzle "Mate em 1" determinista por dia.
   ===================================================================== */
ENG.chess = (() => {
  const N_OFF = [-33, -31, -18, -14, 14, 18, 31, 33], K_OFF = [-17, -16, -15, -1, 1, 15, 16, 17], B_OFF = [-17, -15, 15, 17], R_OFF = [-16, -1, 1, 16];
  const VAL = [0, 100, 320, 330, 500, 900, 20000], MATE = 100000, INF = 1e9;
  const to64 = s => ((s >> 4) << 3) | (s & 7), to88 = i => ((i >> 3) << 4) | (i & 7);
  const PST = {
    1: [0, 0, 0, 0, 0, 0, 0, 0, 50, 50, 50, 50, 50, 50, 50, 50, 10, 10, 20, 30, 30, 20, 10, 10, 5, 5, 10, 25, 25, 10, 5, 5, 0, 0, 0, 20, 20, 0, 0, 0, 5, -5, -10, 0, 0, -10, -5, 5, 5, 10, 10, -20, -20, 10, 10, 5, 0, 0, 0, 0, 0, 0, 0, 0],
    2: [-50, -40, -30, -30, -30, -30, -40, -50, -40, -20, 0, 0, 0, 0, -20, -40, -30, 0, 10, 15, 15, 10, 0, -30, -30, 5, 15, 20, 20, 15, 5, -30, -30, 0, 15, 20, 20, 15, 0, -30, -30, 5, 10, 15, 15, 10, 5, -30, -40, -20, 0, 5, 5, 0, -20, -40, -50, -40, -30, -30, -30, -30, -40, -50],
    3: [-20, -10, -10, -10, -10, -10, -10, -20, -10, 0, 0, 0, 0, 0, 0, -10, -10, 0, 5, 10, 10, 5, 0, -10, -10, 5, 5, 10, 10, 5, 5, -10, -10, 0, 10, 10, 10, 10, 0, -10, -10, 10, 10, 10, 10, 10, 10, -10, -10, 5, 0, 0, 0, 0, 5, -10, -20, -10, -10, -10, -10, -10, -10, -20],
    4: [0, 0, 0, 0, 0, 0, 0, 0, 5, 10, 10, 10, 10, 10, 10, 5, -5, 0, 0, 0, 0, 0, 0, -5, -5, 0, 0, 0, 0, 0, 0, -5, -5, 0, 0, 0, 0, 0, 0, -5, -5, 0, 0, 0, 0, 0, 0, -5, -5, 0, 0, 0, 0, 0, 0, -5, 0, 0, 0, 5, 5, 0, 0, 0],
    5: [-20, -10, -10, -5, -5, -10, -10, -20, -10, 0, 0, 0, 0, 0, 0, -10, -10, 0, 5, 5, 5, 5, 0, -10, -5, 0, 5, 5, 5, 5, 0, -5, 0, 0, 5, 5, 5, 5, 0, -5, -10, 5, 5, 5, 5, 5, 0, -10, -10, 0, 5, 0, 0, 0, 0, -10, -20, -10, -10, -5, -5, -10, -10, -20],
    6: [-30, -40, -40, -50, -50, -40, -40, -30, -30, -40, -40, -50, -50, -40, -40, -30, -30, -40, -40, -50, -50, -40, -40, -30, -30, -40, -40, -50, -50, -40, -40, -30, -20, -30, -30, -40, -40, -30, -30, -20, -10, -20, -20, -20, -20, -20, -20, -10, 20, 20, 0, 0, 0, 0, 20, 20, 20, 30, 10, 0, 0, 10, 30, 20],
  };
  const KEND = [-50, -40, -30, -20, -20, -30, -40, -50, -30, -20, -10, 0, 0, -10, -20, -30, -30, -10, 20, 30, 30, 20, -10, -30, -30, -10, 30, 40, 40, 30, -10, -30, -30, -10, 30, 40, 40, 30, -10, -30, -30, -10, 20, 30, 30, 20, -10, -30, -30, -30, 0, 0, 0, 0, -30, -30, -50, -30, -30, -30, -30, -30, -30, -50];
  let zs = 0x9E3779B9 >>> 0;
  const zr = () => { zs ^= zs << 13; zs >>>= 0; zs ^= zs >>> 17; zs ^= zs << 5; zs >>>= 0; return zs; };
  const Z1 = [], Z2 = [];
  for (let i = 0; i < 12; i++) { Z1.push(new Uint32Array(64)); Z2.push(new Uint32Array(64)); for (let s = 0; s < 64; s++) { Z1[i][s] = zr(); Z2[i][s] = zr(); } }
  const ZC1 = new Uint32Array(16), ZC2 = new Uint32Array(16), ZE1 = new Uint32Array(9), ZE2 = new Uint32Array(9);
  for (let i = 0; i < 16; i++) { ZC1[i] = zr(); ZC2[i] = zr(); } for (let i = 0; i < 9; i++) { ZE1[i] = zr(); ZE2[i] = zr(); }
  const ZS1 = zr(), ZS2 = zr();
  const pi = v => (v > 0 ? v - 1 : 5 - v);
  const rehash = p => {
    let h1 = 0, h2 = 0;
    for (let s = 0; s < 128; s++) { if (s & 0x88) { s += 7; continue; } const v = p.b[s]; if (v) { const k = pi(v), i = to64(s); h1 ^= Z1[k][i]; h2 ^= Z2[k][i]; } }
    h1 ^= ZC1[p.castle]; h2 ^= ZC2[p.castle];
    const ef = p.ep < 0 ? 8 : (p.ep & 7); h1 ^= ZE1[ef]; h2 ^= ZE2[ef];
    if (p.side < 0) { h1 ^= ZS1; h2 ^= ZS2; }
    p.h1 = h1 >>> 0; p.h2 = h2 >>> 0;
  };
  const keyOf = p => (p.h1 >>> 0) * 2097152 + (p.h2 >>> 11);
  const create = () => {
    const b = new Int8Array(128), back = [4, 2, 3, 5, 6, 3, 2, 4];
    for (let f = 0; f < 8; f++) { b[f] = -back[f]; b[0x10 + f] = -1; b[0x60 + f] = 1; b[0x70 + f] = back[f]; }
    const p = { b, side: 1, castle: 15, ep: -1, half: 0, full: 1, kings: [0x74, 0x04], stack: [], hist: [], h1: 0, h2: 0 };
    rehash(p); p.hist.push(keyOf(p)); return p;
  };
  const kidx = side => (side > 0 ? 0 : 1);
  const attacked = (p, sq, by) => {
    const b = p.b, pr = by > 0 ? 16 : -16;
    for (const d of [pr - 1, pr + 1]) { const s = sq + d; if (!(s & 0x88) && b[s] === by) return true; }
    for (const d of N_OFF) { const s = sq + d; if (!(s & 0x88) && b[s] === 2 * by) return true; }
    for (const d of K_OFF) { const s = sq + d; if (!(s & 0x88) && b[s] === 6 * by) return true; }
    for (const d of B_OFF) { let s = sq + d; while (!(s & 0x88)) { const v = b[s]; if (v) { if (v === 3 * by || v === 5 * by) return true; break; } s += d; } }
    for (const d of R_OFF) { let s = sq + d; while (!(s & 0x88)) { const v = b[s]; if (v) { if (v === 4 * by || v === 5 * by) return true; break; } s += d; } }
    return false;
  };
  const inCheck = (p, side) => attacked(p, p.kings[kidx(side)], -side);
  const pseudo = (p, capsOnly) => {
    const b = p.b, me = p.side, out = [];
    const add = (f, t, pc, cap, promo, flag) => out.push({ f, t, pc, cap, promo, flag });
    const addP = (f, t, pc, cap, last) => { if (last) { add(f, t, pc, cap, 5, 0); add(f, t, pc, cap, 4, 0); add(f, t, pc, cap, 3, 0); add(f, t, pc, cap, 2, 0); } else add(f, t, pc, cap, 0, 0); };
    for (let f = 0; f < 128; f++) {
      if (f & 0x88) { f += 7; continue; }
      const pc = b[f]; if (!pc || (pc > 0) !== (me > 0)) continue;
      const ty = pc * me;
      if (ty === 1) {
        const dir = me > 0 ? -16 : 16, row = f >> 4, start = me > 0 ? 6 : 1, last = me > 0 ? 1 : 6;
        const one = f + dir;
        if (!(one & 0x88) && !b[one]) {
          if (row === last) addP(f, one, pc, 0, true);
          else if (!capsOnly) { add(f, one, pc, 0, 0, 0); const two = one + dir; if (row === start && !b[two]) add(f, two, pc, 0, 0, 3); }
        }
        for (const d of [dir - 1, dir + 1]) {
          const t = f + d; if (t & 0x88) continue;
          const v = b[t];
          if (v && (v > 0) !== (me > 0)) addP(f, t, pc, v, row === last);
          else if (t === p.ep) add(f, t, pc, -me, 0, 1);
        }
      } else if (ty === 2 || ty === 6) {
        for (const d of (ty === 2 ? N_OFF : K_OFF)) {
          const t = f + d; if (t & 0x88) continue;
          const v = b[t];
          if (!v) { if (!capsOnly) add(f, t, pc, 0, 0, 0); } else if ((v > 0) !== (me > 0)) add(f, t, pc, v, 0, 0);
        }
        if (ty === 6 && !capsOnly) {
          const home = me > 0 ? 0x74 : 0x04, kb = me > 0 ? 1 : 4, qb = me > 0 ? 2 : 8;
          if (f === home && (p.castle & (kb | qb)) && !attacked(p, home, -me)) {
            if ((p.castle & kb) && !b[home + 1] && !b[home + 2] && b[home + 3] === 4 * me && !attacked(p, home + 1, -me) && !attacked(p, home + 2, -me)) add(f, home + 2, pc, 0, 0, 2);
            if ((p.castle & qb) && !b[home - 1] && !b[home - 2] && !b[home - 3] && b[home - 4] === 4 * me && !attacked(p, home - 1, -me) && !attacked(p, home - 2, -me)) add(f, home - 2, pc, 0, 0, 2);
          }
        }
      } else {
        const dirs = ty === 3 ? B_OFF : ty === 4 ? R_OFF : K_OFF;
        for (const d of dirs) {
          let t = f + d;
          while (!(t & 0x88)) { const v = b[t]; if (!v) { if (!capsOnly) add(f, t, pc, 0, 0, 0); } else { if ((v > 0) !== (me > 0)) add(f, t, pc, v, 0, 0); break; } t += d; }
        }
      }
    }
    return out;
  };
  const CMASK = new Uint8Array(128).fill(15);
  CMASK[0x74] = 12; CMASK[0x77] = 14; CMASK[0x70] = 13; CMASK[0x04] = 3; CMASK[0x07] = 11; CMASK[0x00] = 7;
  const tog = (p, v, s) => { const k = pi(v), i = to64(s); p.h1 = (p.h1 ^ Z1[k][i]) >>> 0; p.h2 = (p.h2 ^ Z2[k][i]) >>> 0; };
  const make = (p, m) => {
    const b = p.b, me = p.side;
    p.stack.push({ m, castle: p.castle, ep: p.ep, half: p.half, h1: p.h1, h2: p.h2 });
    const ef0 = p.ep < 0 ? 8 : (p.ep & 7);
    p.h1 ^= ZC1[p.castle] ^ ZE1[ef0] ^ ZS1; p.h2 ^= ZC2[p.castle] ^ ZE2[ef0] ^ ZS2;
    tog(p, m.pc, m.f); b[m.f] = 0;
    if (m.flag === 1) { const cs = m.t + (me > 0 ? 16 : -16); tog(p, b[cs], cs); b[cs] = 0; }
    else if (m.cap) tog(p, m.cap, m.t);
    const np = m.promo ? m.promo * me : m.pc; b[m.t] = np; tog(p, np, m.t);
    if (m.flag === 2) {
      const rf = m.t > m.f ? m.f + 3 : m.f - 4, rt = m.t > m.f ? m.f + 1 : m.f - 1;
      tog(p, b[rf], rf); b[rt] = b[rf]; b[rf] = 0; tog(p, b[rt], rt);
    }
    if (m.pc * me === 6) p.kings[kidx(me)] = m.t;
    p.castle &= CMASK[m.f] & CMASK[m.t];
    p.ep = m.flag === 3 ? (m.f + m.t) >> 1 : -1;
    p.half = m.cap || m.pc * me === 1 ? 0 : p.half + 1;
    if (me < 0) p.full++;
    p.side = -me;
    const ef1 = p.ep < 0 ? 8 : (p.ep & 7);
    p.h1 = (p.h1 ^ ZC1[p.castle] ^ ZE1[ef1]) >>> 0; p.h2 = (p.h2 ^ ZC2[p.castle] ^ ZE2[ef1]) >>> 0;
  };
  const unmake = p => {
    const u = p.stack.pop(), m = u.m, b = p.b, me = -p.side;
    p.side = me; if (me < 0) p.full--;
    b[m.f] = m.pc;
    if (m.flag === 1) { b[m.t] = 0; b[m.t + (me > 0 ? 16 : -16)] = -me; } else b[m.t] = m.cap;
    if (m.flag === 2) { if (m.t > m.f) { b[m.f + 3] = b[m.f + 1]; b[m.f + 1] = 0; } else { b[m.f - 4] = b[m.f - 1]; b[m.f - 1] = 0; } }
    if (m.pc * me === 6) p.kings[kidx(me)] = m.f;
    p.castle = u.castle; p.ep = u.ep; p.half = u.half; p.h1 = u.h1; p.h2 = u.h2;
  };
  const legal = (p, capsOnly) => { const me = p.side, out = []; for (const m of pseudo(p, capsOnly)) { make(p, m); if (!attacked(p, p.kings[kidx(me)], -me)) out.push(m); unmake(p); } return out; };
  const perft = (p, d) => { if (!d) return 1; let n = 0; for (const m of legal(p)) { make(p, m); n += perft(p, d - 1); unmake(p); } return n; };
  const play = (p, m) => { make(p, m); p.hist.push(keyOf(p)); };
  const unplay = p => { unmake(p); p.hist.pop(); };
  const repeated = p => { const k = keyOf(p); let n = 0; for (let i = p.hist.length - 1; i >= 0; i--) if (p.hist[i] === k) n++; return n; };
  const evaluate = p => {
    const b = p.b; let s = 0, mat = 0, queens = 0;
    for (let f = 0; f < 128; f++) { if (f & 0x88) { f += 7; continue; } const v = b[f]; if (!v) continue; const ty = v > 0 ? v : -v; if (ty !== 6 && ty !== 1) mat += VAL[ty]; if (ty === 5) queens++; }
    const endgame = queens === 0 || mat <= 1600;
    for (let f = 0; f < 128; f++) {
      if (f & 0x88) { f += 7; continue; }
      const v = b[f]; if (!v) continue;
      const ty = v > 0 ? v : -v, i = to64(f), ii = v > 0 ? i : (7 - (i >> 3)) * 8 + (i & 7);
      s += (v > 0 ? 1 : -1) * (VAL[ty] + (ty === 6 && endgame ? KEND[ii] : PST[ty][ii]));
    }
    return s;
  };
  const mscore = m => (m.cap ? 10 * VAL[Math.abs(m.cap)] - VAL[Math.abs(m.pc)] : 0) + (m.promo ? 800 + VAL[m.promo] : 0);
  const same = (a, b) => a && b && a.f === b.f && a.t === b.t && a.promo === b.promo;
  const order = (ms, tt) => ms.sort((a, b) => (same(b, tt) ? 1e6 : mscore(b)) - (same(a, tt) ? 1e6 : mscore(a)));
  let TT = new Map(), nodes = 0, budget = 0;
  const quiesce = (p, alpha, beta, qd) => {
    nodes++;
    const stand = evaluate(p) * p.side;
    if (stand >= beta) return stand;
    if (stand > alpha) alpha = stand;
    if (qd <= 0 || nodes > budget) return alpha;
    for (const m of order(legal(p, true), null)) { make(p, m); const v = -quiesce(p, -beta, -alpha, qd - 1); unmake(p); if (v >= beta) return v; if (v > alpha) alpha = v; }
    return alpha;
  };
  const negamax = (p, depth, alpha, beta, ply) => {
    nodes++;
    if (ply > 0 && (p.half >= 100 || repeated(p) >= 2)) return 0;
    const chk = inCheck(p, p.side);
    if (depth <= 0 && (!chk || ply > 24)) return quiesce(p, alpha, beta, 4);
    const key = keyOf(p), e = TT.get(key); let ttm = null;
    if (e) { ttm = e.m; if (e.d >= depth && ply > 0) { if (e.f === 0) return e.s; if (e.f === 1 && e.s >= beta) return e.s; if (e.f === 2 && e.s <= alpha) return e.s; } }
    const ms = legal(p);
    if (!ms.length) return chk ? -MATE + ply : 0;
    order(ms, ttm);
    let best = -INF, bm = null; const a0 = alpha;
    for (const m of ms) {
      play(p, m); const v = -negamax(p, depth - 1, -beta, -alpha, ply + 1); unplay(p);
      if (v > best) { best = v; bm = m; }
      if (v > alpha) alpha = v;
      if (alpha >= beta || nodes > budget) break;
    }
    if (TT.size > 200000) TT.clear();
    TT.set(key, { d: depth, s: best, f: best <= a0 ? 2 : best >= beta ? 1 : 0, m: bm });
    return best;
  };
  /* cinco níveis (os nomes antigos facil/medio/dificil continuam a ser aceites) */
  const LEVELS = {
    principiante: { d: 1, noise: 160, budget: 20000 }, clube: { d: 2, noise: 40, budget: 80000 }, avancado: { d: 3, noise: 12, budget: 200000 },
    mestre: { d: 4, noise: 0, budget: 420000 }, gm: { d: 5, noise: 0, budget: 800000 },
  };
  const normLevel = v => ({ facil: 'principiante', medio: 'clube', dificil: 'mestre' }[v] || (LEVELS[v] ? v : 'clube'));
  async function think(p, level, o) {
    o = o || {}; const cfg = LEVELS[normLevel(level)] || LEVELS.clube;
    const root = legal(p); if (!root.length) return null;
    if (root.length === 1) return root[0];
    TT = new Map(); nodes = 0; budget = o.budget || cfg.budget;
    /* com ruído a escolha é entre várias jogadas: a raiz usa janela completa para as notas serem exatas
       (com alfa-beta as outras seriam só limites, e um erro grave podia parecer quase tão bom como a melhor) */
    const wide = !!cfg.noise && !o.exact;
    let best = null, scores = null, slice = performance.now();
    for (let d = 1; d <= cfg.d; d++) {
      order(root, best);
      let alpha = -INF, bd = null, stopped = false; const sc = [];
      for (const m of root) {
        play(p, m); const v = -negamax(p, d - 1, -INF, wide ? INF : -alpha, 1); unplay(p);
        sc.push(v); if (v > alpha) { alpha = v; bd = m; }
        if (nodes > budget) { stopped = sc.length < root.length; break; }
        if (performance.now() - slice > 12) { await sleep(0); if (o.wait) await o.wait(); slice = performance.now(); if (o.cancelled && o.cancelled()) return null; }
      }
      if (!stopped) { best = bd; scores = root.map((m, i) => ({ m, v: sc[i] })); } else if (!best) best = bd;
      if (stopped || nodes > budget || Math.abs(alpha) > MATE - 200) break;
    }
    if (cfg.noise && scores && !o.exact) { const top = Math.max(...scores.map(z => z.v)); const pool = scores.filter(z => z.v >= top - cfg.noise && z.v > -MATE / 2); if (pool.length) best = pool[rnd(pool.length)].m; }
    return best;
  }
  const insufficient = p => {
    const minors = [];
    for (let f = 0; f < 128; f++) { if (f & 0x88) { f += 7; continue; } const v = p.b[f], ty = Math.abs(v); if (!v || ty === 6) continue; if (ty === 1 || ty === 4 || ty === 5) return false; minors.push({ ty, col: ((f >> 4) + (f & 7)) & 1 }); }
    if (minors.length <= 1) return true;
    return minors.every(m => m.ty === 3) && minors.every(m => m.col === minors[0].col);
  };
  const material = p => { let w = 0, k = 0; for (let f = 0; f < 128; f++) { if (f & 0x88) { f += 7; continue; } const v = p.b[f]; if (v > 0 && v !== 6) w += VAL[v]; else if (v < 0 && v !== -6) k += VAL[-v]; } return { w, b: k }; };
  const status = p => {
    if (!legal(p).length) return inCheck(p, p.side) ? 'mate' : 'stale';
    if (p.half >= 100) return 'fifty';
    if (repeated(p) >= 3) return 'rep';
    if (insufficient(p)) return 'mat';
    return 'play';
  };
  const SQ = s => 'abcdefgh'[s & 7] + (8 - (s >> 4));
  const str = m => SQ(m.f) + SQ(m.t) + (m.promo ? 'qrbn'[5 - m.promo] : '');
  const find = (p, s) => legal(p).find(m => str(m) === s) || null;
  /* notação algébrica: { pc, from, to, cap, promo, castle, check, mate, dis } e texto com letras internacionais (K Q R B N) */
  const san = (p, m, ms) => {
    const ty = Math.abs(m.pc), out = { pc: ty, from: SQ(m.f), to: SQ(m.t), cap: !!m.cap, promo: m.promo || 0, castle: m.flag === 2 ? (m.t > m.f ? 'O-O' : 'O-O-O') : '', check: false, mate: false, dis: '' };
    ms = ms || legal(p);
    if (ty !== 1 && ty !== 6) {
      const others = ms.filter(z => z !== m && Math.abs(z.pc) === ty && z.t === m.t && z.f !== m.f);
      if (others.length) { const sf = others.some(z => (z.f & 7) === (m.f & 7)), sr = others.some(z => (z.f >> 4) === (m.f >> 4)); out.dis = !sf ? out.from[0] : !sr ? out.from[1] : out.from; }
    } else if (ty === 1 && m.cap) out.dis = out.from[0];
    make(p, m); const chk = inCheck(p, p.side); if (chk) { out.check = true; out.mate = !legal(p).length; } unmake(p);
    return out;
  };
  const LET = ['', '', 'N', 'B', 'R', 'Q', 'K'];
  const sanText = s => s.castle ? s.castle + (s.mate ? '#' : s.check ? '+' : '') : LET[s.pc] + s.dis + (s.cap ? 'x' : '') + s.to + (s.promo ? '=' + LET[s.promo] : '') + (s.mate ? '#' : s.check ? '+' : '');
  /* aberturas (as mais comuns), pela sequência de lances em notação de coordenadas */
  const OPEN = {
    'e2e4': 'Abertura do peão do rei', 'd2d4': 'Abertura do peão da dama', 'c2c4': 'Abertura Inglesa', 'g1f3': 'Abertura Réti', 'b2b3': 'Abertura Larsen', 'f2f4': 'Abertura Bird', 'g2g3': 'Abertura Benko',
    'e2e4 e7e5': 'Jogo aberto', 'e2e4 c7c5': 'Defesa Siciliana', 'e2e4 e7e6': 'Defesa Francesa', 'e2e4 c7c6': 'Defesa Caro-Kann', 'e2e4 d7d5': 'Defesa Escandinava', 'e2e4 g8f6': 'Defesa Alekhine', 'e2e4 d7d6': 'Defesa Pirc', 'e2e4 g7g6': 'Defesa Moderna',
    'e2e4 e7e5 g1f3': 'Abertura do cavalo do rei', 'e2e4 e7e5 f2f4': 'Gambito do Rei', 'e2e4 e7e5 b1c3': 'Abertura Vienense', 'e2e4 e7e5 f1c4': 'Abertura do Bispo', 'e2e4 e7e5 d2d4': 'Gambito do Centro',
    'e2e4 e7e5 g1f3 b8c6': 'Jogo aberto clássico', 'e2e4 e7e5 g1f3 g8f6': 'Defesa Petrov', 'e2e4 e7e5 g1f3 d7d6': 'Defesa Philidor',
    'e2e4 e7e5 g1f3 b8c6 f1b5': 'Abertura Espanhola', 'e2e4 e7e5 g1f3 b8c6 f1b5 a7a6': 'Espanhola, Defesa Morphy', 'e2e4 e7e5 g1f3 b8c6 f1b5 g8f6': 'Espanhola, Defesa Berlim',
    'e2e4 e7e5 g1f3 b8c6 f1c4': 'Jogo Italiano', 'e2e4 e7e5 g1f3 b8c6 f1c4 f8c5': 'Giuoco Piano', 'e2e4 e7e5 g1f3 b8c6 f1c4 f8c5 b2b4': 'Gambito Evans', 'e2e4 e7e5 g1f3 b8c6 f1c4 g8f6': 'Defesa dos dois cavalos',
    'e2e4 e7e5 g1f3 b8c6 d2d4': 'Abertura Escocesa', 'e2e4 e7e5 g1f3 b8c6 b1c3': 'Abertura dos três cavalos', 'e2e4 e7e5 g1f3 b8c6 b1c3 g8f6': 'Abertura dos quatro cavalos',
    'e2e4 c7c5 g1f3': 'Siciliana aberta', 'e2e4 c7c5 b1c3': 'Siciliana Fechada', 'e2e4 c7c5 c2c3': 'Siciliana Alapin', 'e2e4 c7c5 g1f3 d7d6 d2d4 c5d4 f3d4 g8f6 b1c3 a7a6': 'Siciliana Najdorf', 'e2e4 c7c5 g1f3 d7d6 d2d4 c5d4 f3d4 g8f6 b1c3 g7g6': 'Siciliana Dragão',
    'e2e4 e7e6 d2d4 d7d5': 'Francesa clássica', 'e2e4 e7e6 d2d4 d7d5 e4e5': 'Francesa, Variante do Avanço', 'e2e4 c7c6 d2d4 d7d5': 'Caro-Kann clássica',
    'd2d4 d7d5': 'Jogo fechado', 'd2d4 d7d5 c2c4': 'Gambito da Dama', 'd2d4 d7d5 c2c4 d5c4': 'Gambito da Dama Aceite', 'd2d4 d7d5 c2c4 e7e6': 'Gambito da Dama Recusado', 'd2d4 d7d5 c2c4 c7c6': 'Defesa Eslava',
    'd2d4 d7d5 g1f3 g8f6 c1f4': 'Sistema Londres', 'd2d4 g8f6': 'Defesa Indiana', 'd2d4 g8f6 c1g5': 'Ataque Trompowsky', 'd2d4 g8f6 c2c4 e7e6 b1c3 f8b4': 'Defesa Nimzo-Índia', 'd2d4 g8f6 c2c4 e7e6 g1f3 b7b6': 'Defesa Índia da Dama',
    'd2d4 g8f6 c2c4 g7g6': 'Defesa Índia do Rei', 'd2d4 g8f6 c2c4 g7g6 b1c3 d7d5': 'Defesa Grünfeld', 'd2d4 f7f5': 'Defesa Holandesa', 'd2d4 d7d5 e2e4': 'Gambito Blackmar-Diemer',
  };
  const opening = hist => { for (let n = Math.min(hist.length, 12); n >= 1; n--) { const k = hist.slice(0, n).join(' '); if (OPEN[k]) return OPEN[k]; } return null; };
  /* "Mate em 1": todas as jogadas que dão mate nesta posição */
  const mateIn1 = p => { const out = []; for (const m of legal(p)) { make(p, m); if (inCheck(p, p.side) && !legal(p).length) out.push(m); unmake(p); } return out; };
  /* puzzle determinista (semente = dia): posição aleatória com UMA jogada de mate; `o.wait` suspende em pedaços */
  const WSETS = [[5, 4], [5, 3], [5, 2], [4, 4], [5, 4, 2], [4, 3], [5, 1, 1], [4, 4, 1], [5, 3, 1], [4, 2, 1]];
  const BSETS = [[], [1], [1, 1], [2], [3], [1, 2], [4], [1, 1, 1], [3, 1], [2, 1]];
  /* posição de reserva se a geração falhar (rei preto g8, rei branco g6, torre branca a1: Ta8 é mate) */
  const fallback = () => { const p = create(); p.b.fill(0); p.b[0x06] = -6; p.b[0x26] = 6; p.b[0x70] = 4; p.kings = [0x26, 0x06]; p.castle = 0; p.ep = -1; p.side = 1; p.stack = []; rehash(p); p.hist = [keyOf(p)]; return { p, solution: 'a1a8', attempt: -1 }; };
  async function puzzle(seed, o) {
    o = o || {}; const rand = seeded(seed * 2654435761 + 7), slice = { t: performance.now() };
    for (let attempt = 0; attempt < 900; attempt++) {
      if (performance.now() - slice.t > 12) { await sleep(0); if (o.wait) await o.wait(); if (o.cancelled && o.cancelled()) return null; slice.t = performance.now(); }
      const p = create(); p.b.fill(0); p.castle = 0; p.ep = -1; p.side = 1; p.half = 0; p.full = 1; p.stack = [];
      const free = () => { const out = []; for (let i = 0; i < 64; i++) if (!p.b[to88(i)]) out.push(i); return out; };
      const put = (v, pred) => { const cand = free().filter(i => !pred || pred(i)); if (!cand.length) return -1; const i = cand[(rand() * cand.length) | 0]; p.b[to88(i)] = v; return to88(i); };
      /* rei preto perto da borda (os mates em 1 bonitos acontecem lá), rei branco longe */
      const bk = put(-6, i => (i >> 3) <= 1 || (i >> 3) >= 6 || (i & 7) <= 1 || (i & 7) >= 6); if (bk < 0) continue;
      const wk = put(6, i => { const s = to88(i); const dr = Math.abs((s >> 4) - (bk >> 4)), dc = Math.abs((s & 7) - (bk & 7)); return Math.max(dr, dc) >= 3; }); if (wk < 0) continue;
      p.kings = [wk, bk];
      const ws = WSETS[(rand() * WSETS.length) | 0], bs = BSETS[(rand() * BSETS.length) | 0]; let bad = false;
      for (const ty of ws) { if (put(ty, i => ty !== 1 || ((i >> 3) >= 1 && (i >> 3) <= 6)) < 0) { bad = true; break; } }
      for (const ty of bs) { if (bad) break; if (put(-ty, i => ty !== 1 || ((i >> 3) >= 1 && (i >> 3) <= 6)) < 0) { bad = true; break; } }
      if (bad) continue;
      if (attacked(p, wk, -1) || attacked(p, bk, 1)) continue;
      rehash(p); p.hist = [keyOf(p)];
      const ms = legal(p); if (ms.length < 8) continue;
      const mates = mateIn1(p); if (mates.length !== 1) continue;
      /* o mate não pode ser uma captura do rei por falta de defesa trivial: pelo menos duas jogadas de xeque na posição */
      let checks = 0; for (const m of ms) { make(p, m); if (inCheck(p, p.side)) checks++; unmake(p); if (checks >= 2) break; }
      if (checks < 2) continue;
      return { p, solution: str(mates[0]), attempt };
    }
    return fallback();
  }
  const ser = p => ({ b: Array.from(p.b).filter((_, i) => !(i & 0x88)).map(v => (v + 6).toString(16)).join(''), s: p.side, c: p.castle, e: p.ep, h: p.half, f: p.full, hist: p.hist.slice(-24), n: p.hist.length - 1 });
  const des = o => {
    if (!o || typeof o.b !== 'string' || !/^[0-9a-c]{64}$/.test(o.b)) return null;
    const p = create(); p.b.fill(0); let wk = -1, bk = -1, wn = 0, bn = 0;
    for (let i = 0; i < 64; i++) { const v = parseInt(o.b[i], 16) - 6, s = to88(i); p.b[s] = v; if (v === 6) { wk = s; wn++; } else if (v === -6) { bk = s; bn++; } }
    if (wn !== 1 || bn !== 1) return null;
    p.kings = [wk, bk]; p.side = o.s === -1 ? -1 : 1;
    p.castle = Number.isInteger(o.c) && o.c >= 0 && o.c <= 15 ? o.c : 0;
    p.ep = Number.isInteger(o.e) && o.e >= 0 && o.e < 128 && !(o.e & 0x88) ? o.e : -1;
    p.half = Math.max(0, Math.min(150, o.h | 0)); p.full = Math.max(1, Math.min(999, o.f | 0));
    rehash(p); p.hist = Array.isArray(o.hist) ? o.hist.filter(x => typeof x === 'number').slice(-24) : []; if (!p.hist.length || p.hist[p.hist.length - 1] !== keyOf(p)) p.hist.push(keyOf(p));
    return p;
  };
  return { create, legal, make, unmake, play, unplay, inCheck, attacked, perft, think, evaluate, status, insufficient, material, ser, des, str, find, to64, to88, VAL, keyOf, LEVELS, normLevel, san, sanText, opening, OPEN, mateIn1, puzzle, SQ };
})();

/* ---------- peças em SVG próprio (viewBox 100): gradiente, contorno e sombra; 1 peão, 2 cavalo, 3 bispo, 4 torre, 5 dama, 6 rei ---------- */
const CH_BASE = '<path d="M27 88h46c3 0 5-2 5-5s-2-5-5-5H27c-3 0-5 2-5 5s2 5 5 5z"/>';
const CH_BODY = {
  1: '<circle cx="50" cy="30" r="11"/><path d="M39 46c0-3 3-5 6-5h10c3 0 6 2 6 5v3H39z"/><path d="M42 49h16c0 11 5 20 10 29H32c5-9 10-18 10-29z"/>' + CH_BASE,
  2: '<path d="M32 78c2-16 6-26 14-32-6 2-12 3-18 1-3-1-4-4-2-7l14-14c3-3 5-7 6-11l2-9 5 5c4 1 7 2 10 3 11 5 17 17 17 32 0 7-1 15-3 22z"/>' + CH_BASE,
  3: '<circle cx="50" cy="11" r="4.5"/><path d="M50 17c10 8 16 18 16 27 0 7-6 12-16 12s-16-5-16-12c0-9 6-19 16-27z"/><path d="M37 58h26v6H37z"/><path d="M40 64h20c0 6 3 10 7 14H33c4-4 7-8 7-14z"/>' + CH_BASE,
  4: '<path d="M29 14h10v9h7v-9h8v9h7v-9h10v17c0 3-2 5-4 6v27c3 1 5 3 5 6v8H28v-8c0-3 2-5 5-6V37c-2-1-4-3-4-6z"/>' + CH_BASE,
  5: '<circle cx="22" cy="30" r="4.5"/><circle cx="36" cy="22" r="4.5"/><circle cx="50" cy="19" r="4.5"/><circle cx="64" cy="22" r="4.5"/><circle cx="78" cy="30" r="4.5"/><path d="M25 34l9 20 4-26 9 20 3-24 3 24 9-20 4 26 9-20-6 34H31z"/><path d="M31 68h38c0 4 1 7 3 10H28c2-3 3-6 3-10z"/>' + CH_BASE,
  6: '<path d="M46 6h8v8h8v7h-8v8h-8v-8h-8v-7h8z"/><path d="M50 29c6-8 14-9 20-5 7 5 7 16 2 24l-5 20H33l-5-20c-5-8-5-19 2-24 6-4 14-3 20 5z"/><path d="M31 68h38c0 4 1 7 3 10H28c2-3 3-6 3-10z"/>' + CH_BASE,
};
const CH_DET = {
  1: '', 2: '<circle class="eye" cx="57" cy="28" r="2.6"/><path class="ln" d="M30 41c2 1.5 4 1.5 6 0M66 24c3 6 5 12 5 20"/>', 3: '<path class="ln" d="M58 31 45 44M38 61h24"/>', 4: '<path class="ln" d="M36 37h28M35 64h30"/>', 5: '<path class="ln" d="M32 61h36"/>', 6: '<path class="ln" d="M33 60h34"/>',
};
const CH_DEFS = '<svg width="0" height="0" class="gch-defs" aria-hidden="true"><defs><linearGradient id="gchGw" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFFEF8"/><stop offset=".55" stop-color="#EFE8D8"/><stop offset="1" stop-color="#CBC0A8"/></linearGradient><linearGradient id="gchGb" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#77778A"/><stop offset=".5" stop-color="#3C3C4A"/><stop offset="1" stop-color="#15151B"/></linearGradient></defs></svg>';
/* a sombra NÃO se pode chamar .sh: o Icons.tickClocks roda todos os .sh do documento (ponteiro dos segundos) */
const chPiece = v => `<svg viewBox="0 0 100 100" class="gch-sv ${v > 0 ? 'w' : 'b'}"><g class="gch-shd"><ellipse cx="50" cy="89.5" rx="27" ry="5.2"/><ellipse cx="50" cy="89" rx="19" ry="3.6"/></g><g class="bd">${CH_BODY[Math.abs(v)]}</g><g class="dt">${CH_DET[Math.abs(v)]}</g></svg>`;
/* figurino para a notação (cor do texto) */
const chFig = ty => `<svg viewBox="0 0 100 100" class="gch-fig"><g>${CH_BODY[ty]}</g></svg>`;
const chSanHtml = s => s.castle ? `<span>${s.castle}${s.mate ? '#' : s.check ? '+' : ''}</span>` : `${s.pc > 1 ? chFig(s.pc) : ''}<span>${s.dis}${s.cap ? 'x' : ''}${s.to}${s.mate ? '#' : s.check ? '+' : ''}</span>${s.promo ? chFig(s.promo) : ''}`;

/* ---------- capa 2:1 (hub e "Toca para começar") e ícone ---------- */
const COVER = {};
COVER.chess = () => `<svg viewBox="0 0 400 200" preserveAspectRatio="xMidYMid slice" class="gbd-cv"><defs><linearGradient id="gbcCh1" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#3B2D8F"/><stop offset="1" stop-color="#140F3A"/></linearGradient><linearGradient id="gbcCh2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFFEF6"/><stop offset="1" stop-color="#C9BFA6"/></linearGradient><linearGradient id="gbcCh3" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#6E6E80"/><stop offset="1" stop-color="#15151B"/></linearGradient><radialGradient id="gbcCh4" cx=".5" cy=".3"><stop offset="0" stop-color="#9C86FF" stop-opacity=".55"/><stop offset="1" stop-color="#9C86FF" stop-opacity="0"/></radialGradient></defs><rect width="400" height="200" fill="url(#gbcCh1)"/><rect width="400" height="200" fill="url(#gbcCh4)"/>${[0, 1, 2, 3, 4, 5, 6, 7].map(r => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].map(c => ((r + c) & 1) ? '' : `<rect x="${-20 + c * 42 - r * 8}" y="${96 + r * 14}" width="42" height="14" fill="#fff" opacity="${.05 + r * .012}"/>`).join('')).join('')}<g transform="translate(118 26) scale(1.3)" fill="url(#gbcCh2)" stroke="#2A2420" stroke-width="2.2" stroke-linejoin="round" paint-order="stroke">${CH_BODY[6]}</g><g transform="translate(214 44) scale(1.1)" fill="url(#gbcCh3)" stroke="#0A0A10" stroke-width="2.2" stroke-linejoin="round" paint-order="stroke">${CH_BODY[5]}</g><g transform="translate(290 70) scale(.85)" fill="url(#gbcCh2)" stroke="#2A2420" stroke-width="2.2" stroke-linejoin="round" paint-order="stroke">${CH_BODY[2]}</g><g transform="translate(40 76) scale(.8)" fill="url(#gbcCh3)" stroke="#0A0A10" stroke-width="2.2" stroke-linejoin="round" paint-order="stroke">${CH_BODY[1]}</g></svg>`;
Icons.app.chess = () => Icons.SVG(Icons.G('gCh', '#9C86FF', '#5E4BD6', '#2E2380') + Icons.GL(
  `<rect x="14" y="52" width="72" height="34" rx="6" fill="#fff" opacity=".10"/>` +
  [0, 1].map(r => [0, 1, 2, 3, 4, 5].map(c => ((r + c) & 1) ? `<rect x="${14 + c * 12}" y="${52 + r * 17}" width="12" height="17" fill="#fff" opacity=".16"/>` : '').join('')).join('') +
  `<g transform="translate(22 10) scale(.64)" fill="#1A1440" opacity=".45">${CH_BODY[6]}</g><g transform="translate(18 6) scale(.64)" fill="#fff" stroke="#2E2380" stroke-width="2.5" stroke-linejoin="round" paint-order="stroke">${CH_BODY[6]}</g>` +
  `<g transform="translate(50 22) scale(.5)" fill="#1C1A3A" stroke="#C9C0FF" stroke-width="3" stroke-linejoin="round" paint-order="stroke">${CH_BODY[2]}</g>`));

Arcade.game('chess', {
  name: 'Xadrez', color: '#7B6CF6', kind: 'board', unit: 'vitórias', scoreLabel: 'Vitórias', mp: true, tags: ['Clássico', 'Estratégia', 'Online'],
  desc: 'Xadrez completo com cinco adversários, três tabuleiros, relógio com incremento, lista de lances, dica, nome da abertura e o puzzle do dia. Dois jogadores no mesmo telemóvel ou online.',
  cover: () => COVER.chess(),
  howto: { goal: 'Dá xeque-mate ao rei adversário: um rei atacado sem escapatória.', steps: ['Toca numa peça para ver os pontos de destino', 'Toca no destino para jogar; o anel vermelho é uma captura', 'As brancas começam; a Dica mostra o melhor lance', 'O puzzle do dia pede um mate numa só jogada'], controls: [{ icon: 'hand', label: 'Toca na peça e no destino' }, { icon: 'grid', label: 'Setas ou WASD e Enter' }, { icon: 'bulb', label: 'H dá uma dica, U desfaz, F vira' }] },
  modes: [{ key: 'ia', label: 'Contra o telemóvel' }, { key: 'local', label: 'Dois jogadores' }, { key: 'online', label: 'Online' }, { key: 'puzzle', label: 'Puzzle do dia' }],
  build(win) {
    const CH = ENG.chess, GAME = 'chess';
    const LVL = [
      { v: 'principiante', label: 'Principiante', name: 'Tomás', face: 'kid', color: '#5EE39A' },
      { v: 'clube', label: 'Clube', name: 'Inês', face: 'young', color: '#5CB4FF' },
      { v: 'avancado', label: 'Avançado', name: 'Sr. Faria', face: 'glasses', color: '#FFD60A' },
      { v: 'mestre', label: 'Mestre', name: 'Helena Vaz', face: 'bun', color: '#FF9F0A' },
      { v: 'gm', label: 'Grande Mestre', name: 'Orlov', face: 'beard', color: '#FF375F' },
    ];
    const THEMES = [{ v: 'verde', label: 'Verde' }, { v: 'madeira', label: 'Madeira' }, { v: 'azul', label: 'Azul' }];
    const CLOCKS = [{ v: '0', label: 'Sem', min: 0, inc: 0 }, { v: '3+2', label: '3+2', min: 3, inc: 2 }, { v: '5+0', label: '5+0', min: 5, inc: 0 }, { v: '10+5', label: '10+5', min: 10, inc: 5 }];
    const A = Arcade.shell(win, { id: GAME, name: 'Xadrez', color: '#7B6CF6', pausable: false, scoreLabel: 'Vitórias', bestLabel: 'Recorde', onRestart: () => restart() });
    const x = X(A), stage = A.el.stage;
    const wrap = el(`<div class="gch-wrap gbd-hide">${playerCard('top', 'Pretas', '')}
      <div class="gch-frame">${CH_DEFS}<div class="gch-co">${Array.from({ length: 8 }, (_, i) => `<em class="rk" style="top:${12 + i * 46}px"></em>`).join('')}${Array.from({ length: 8 }, (_, i) => `<em class="fl" style="left:${12 + i * 46}px"></em>`).join('')}</div>
        <div class="gch-board"><div class="gch-sqs">${Array.from({ length: 64 }, (_, i) => `<div class="gch-sq ${((i >> 3) + (i & 7)) & 1 ? 'gch-dk' : 'gch-lt'}" data-i="${i}"></div>`).join('')}</div><div class="gch-pcs"></div><svg class="gch-arrow" viewBox="0 0 368 368"><path class="al"/><path class="ah"/></svg></div></div>
      <div class="gch-tick"><span class="op">Abertura por definir</span><span class="lm" data-noi18n></span><i>${g('list', 14)}</i></div>
      ${playerCard('bot', 'Brancas', '')}</div>`);
    stage.appendChild(wrap);
    const board = wrap.querySelector('.gch-board'), pcs = wrap.querySelector('.gch-pcs'), sqs = [...wrap.querySelectorAll('.gch-sq')], arrow = wrap.querySelector('.gch-arrow'), tick = wrap.querySelector('.gch-tick');
    const coRk = [...wrap.querySelectorAll('.gch-co .rk')], coFl = [...wrap.querySelectorAll('.gch-co .fl')];
    const card = { 1: wrap.querySelector('.gbd-pl.bot'), '-1': wrap.querySelector('.gbd-pl.top') };
    A.el.ctl.innerHTML = `<div class="gm-row wide gbd-tools four">${tool('undo', 'arrowL', 'Desfazer', true)}${tool('hint', 'bulb', 'Dica', true)}${tool('list', 'list', 'Lances', true)}${tool('flip', 'rotate', 'Virar', false)}</div>
      <div class="gm-row wide gbd-tools">${tool('theme', 'layers', 'Tema', false)}${tool('modes', 'grid', 'Modos', false)}${tool('resign', 'flag', 'Desistir', true)}</div>`;
    const bUndo = A.el.ctl.querySelector('.undo'), bHint = A.el.ctl.querySelector('.hint'), bList = A.el.ctl.querySelector('.list'), bFlip = A.el.ctl.querySelector('.flip'), bTheme = A.el.ctl.querySelector('.theme'), bModes = A.el.ctl.querySelector('.modes'), bResign = A.el.ctl.querySelector('.resign');

    let p = null, mode = null, level = CH.normLevel(Arcade.opt('chess:lv', 'clube')), me = 1, flip = false, sel = -1, moves = [], lastMv = null, over = true, busy = false, paused = false, gen = 0;
    let link = null, first = 'a', clockKey = String(Arcade.opt('chess:clock', '0')), clk = { 1: 0, '-1': 0 }, clkIv = null, pcAt = {}, capKey = '', theme = String(Arcade.opt('chess:theme', 'verde'));
    let hist = [], sans = [], openName = null, hintMv = null, hints = 0, puzzle = null, tries = 0, firstMount = true, chrono = Chrono(win, () => {});
    const lv = () => oppOf(LVL, level);
    const clockCfg = () => CLOCKS.find(c => c.v === clockKey) || CLOCKS[0];
    const oppName = () => (link ? link.name : mode === 'ia' ? lv().name : 'Adversário');
    const cur = Cursor(8, 8, i => sqs.forEach((s, k) => s.classList.toggle('cur', k === i)), i => tapSq(i));
    const dIdx = i => (flip ? 63 - i : i);
    const mid = html => { if (mode !== 'online') A.setMid(html); };
    const paintCoords = () => { coRk.forEach((e, i) => { e.textContent = flip ? String(i + 1) : String(8 - i); }); coFl.forEach((e, i) => { e.textContent = 'abcdefgh'[flip ? 7 - i : i]; }); };
    const place = (e, i) => { const di = dIdx(i); e.style.transform = `translate(${(di & 7) * 46}px, ${(di >> 3) * 46}px)`; };
    const mkPiece = (v, i, n) => { const e = el(`<div class="gch-p"><div class="gch-pi ${firstMount ? 'in' : ''}" style="--d:${firstMount ? (n * 18) : 0}ms">${chPiece(v)}</div></div>`); place(e, i); return e; };
    const sync = () => { pcs.innerHTML = ''; pcAt = {}; let n = 0; for (let i = 0; i < 64; i++) { const v = p.b[CH.to88(i)]; if (!v) continue; const e = mkPiece(v, i, n++); pcs.appendChild(e); pcAt[i] = e; } firstMount = false; };
    const slide = (f, t) => { const e = pcAt[f]; if (!e) return null; delete pcAt[f]; pcAt[t] = e; place(e, t); return e; };
    const moveDom = m => {
      const side = m.pc > 0 ? 1 : -1, f = CH.to64(m.f), t = CH.to64(m.t), capSq = m.flag === 1 ? CH.to64(m.t + (side > 0 ? 16 : -16)) : t;
      const dead = pcAt[capSq]; if (dead && m.cap) { delete pcAt[capSq]; dead.style.zIndex = 1; dead.firstElementChild.classList.add('gone'); const tm = setTimeout(() => dead.remove(), 300); win.timers.push(tm); }
      const e = slide(f, t); if (e) { e.style.zIndex = 3; if (m.promo) { const tm = setTimeout(() => { e.firstElementChild.innerHTML = chPiece(m.promo * side); }, 160); win.timers.push(tm); } }
      if (m.flag === 2) { const rf = m.t > m.f ? m.f + 3 : m.f - 4, rt = m.t > m.f ? m.f + 1 : m.f - 1; slide(CH.to64(rf), CH.to64(rt)); }
    };
    const names = () => {
      const L = lv();
      const wN = mode === 'online' ? (me === 1 ? myName() : oppName()) : mode === 'ia' || mode === 'puzzle' ? myName() : 'Brancas';
      const bN = mode === 'online' ? (me === -1 ? myName() : oppName()) : mode === 'ia' ? L.name : mode === 'puzzle' ? 'Puzzle' : 'Pretas';
      const wA = mode === 'local' ? g('person', 18) : (mode === 'online' && me !== 1) ? avatarOf(oppName()) : myAvatar();
      const bA = mode === 'ia' ? portrait(L.face, L.color, 34) : mode === 'online' ? (me === -1 ? myAvatar() : avatarOf(oppName())) : mode === 'puzzle' ? g('sparkles', 18) : g('person', 18);
      setCard(card[1], wN, 'Brancas', wA); setCard(card['-1'], bN, mode === 'ia' ? 'Pretas · ' + L.label : mode === 'puzzle' ? 'Mate em 1' : 'Pretas', bA);
      wrap.classList.toggle('flip', flip);
    };
    const paintCaps = () => {
      const w = [], b = []; p.stack.forEach(u => { const v = u.m.cap; if (v > 0) b.push(v); else if (v < 0) w.push(-v); });
      const key = w.join('') + '|' + b.join('');
      if (key === capKey) return; capKey = key;
      const row = (list, col) => list.sort((a, c) => c - a).map(ty => `<i>${chPiece(ty * col)}</i>`).join('');
      const subW = card[1].querySelector('.gbd-nm span'), subB = card['-1'].querySelector('.gbd-nm span');
      subB.innerHTML = `<span class="gch-caps">${row(w, 1)}</span>`; subW.innerHTML = `<span class="gch-caps">${row(b, -1)}</span>`;
      const mat = CH.material(p), d = Math.round((mat.w - mat.b) / 100); if (d) (d > 0 ? subW : subB).querySelector('.gch-caps').insertAdjacentHTML('beforeend', `<b>+${Math.abs(d)}</b>`);
      if (!w.length && !b.length) { subW.textContent = 'Brancas'; subB.textContent = mode === 'ia' ? 'Pretas · ' + lv().label : mode === 'puzzle' ? 'Mate em 1' : 'Pretas'; }
    };
    const drawArrow = (f, t) => {
      if (f < 0) { arrow.classList.remove('on'); return; }
      const cx = i => (dIdx(i) & 7) * 46 + 23, cy = i => (dIdx(i) >> 3) * 46 + 23;
      const x1 = cx(f), y1 = cy(f), x2 = cx(t), y2 = cy(t), dx = x2 - x1, dy = y2 - y1, L = Math.hypot(dx, dy) || 1, ux = dx / L, uy = dy / L;
      const hx = x2 - ux * 14, hy = y2 - uy * 14;
      arrow.querySelector('.al').setAttribute('d', `M${x1 + ux * 12} ${y1 + uy * 12}L${hx - ux * 2} ${hy - uy * 2}`);
      arrow.querySelector('.ah').setAttribute('d', `M${x2 - ux * 4} ${y2 - uy * 4}L${hx - uy * 9} ${hy + ux * 9}L${hx + uy * 9} ${hy - ux * 9}z`);
      arrow.classList.add('on');
    };
    const paintTick = () => {
      tick.querySelector('.op').textContent = mode === 'puzzle' ? 'Mate em 1: brancas jogam' : (openName || (hist.length ? 'Fora das aberturas conhecidas' : 'Abertura por definir'));
      const n = sans.length, parts = [];
      for (let i = Math.max(0, n - 2); i < n; i++) { const num = (i >> 1) + 1; parts.push(`${i % 2 === 0 ? `<em>${num}.</em>` : (i === Math.max(0, n - 2) ? `<em>${num}...</em>` : '')}${chSanHtml(sans[i])}`); }
      tick.querySelector('.lm').innerHTML = parts.join('');
    };
    const paint = () => {
      if (!p) return;
      const tg = {}; if (sel >= 0) moves.forEach(m => { if (CH.to64(m.f) === sel) tg[CH.to64(m.t)] = m.cap ? 2 : 1; });
      const chk = !over && CH.inCheck(p, p.side) ? CH.to64(p.kings[p.side > 0 ? 0 : 1]) : -1;
      for (let di = 0; di < 64; di++) { const i = dIdx(di), s = sqs[di];
        s.classList.toggle('sel', i === sel); s.classList.toggle('tgt', tg[i] === 1); s.classList.toggle('tcap', tg[i] === 2);
        s.classList.toggle('last', !!lastMv && (lastMv[0] === i || lastMv[1] === i)); s.classList.toggle('chk', i === chk);
        s.classList.toggle('hint', !!hintMv && (CH.to64(hintMv.f) === i || CH.to64(hintMv.t) === i)); }
      if (hintMv && hintMv.f !== hintMv.t) drawArrow(CH.to64(hintMv.f), CH.to64(hintMv.t)); else drawArrow(-1);
      card[1].classList.toggle('on', !over && p.side === 1); card['-1'].classList.toggle('on', !over && p.side === -1);
      let h = '';
      if (!over) { const who = p.side === 1 ? 'brancas' : 'pretas'; h = chk >= 0 ? 'Xeque!' : mode === 'puzzle' ? 'Encontra o mate' : mode === 'ia' ? (p.side === me ? 'A tua vez' : `${lv().name} está a pensar`) : `Vez das ${who}`; }
      mid(h ? `<span class="gm-hint">${esc(h)}</span>` : '');
      const human = mode === 'local' || p.side === me;
      bUndo.classList.toggle('off', mode !== 'ia' || over || busy || !p.stack.some(u => u.m.pc * me > 0));
      bHint.classList.toggle('off', over || busy || !human || mode === 'online');
      bList.classList.toggle('off', !sans.length);
      bResign.classList.toggle('off', over || mode === 'local' || mode === 'puzzle');
      paintCaps(); paintTick();
    };
    const paintClock = () => { const c = clockCfg(); [1, -1].forEach(s => { const e = card[s].querySelector('.gbd-clk'); e.textContent = c.min && mode !== 'online' && mode !== 'puzzle' ? fmtT(Math.ceil(clk[s] / 1000)) : ''; e.classList.toggle('low', !!c.min && clk[s] < 30000); e.classList.toggle('run', !!c.min && !over && p && p.side === s); }); };
    const stopClock = () => { clearInterval(clkIv); clkIv = null; };
    const startClock = () => {
      stopClock(); const c = clockCfg(); if (!c.min || over || mode === 'online' || mode === 'puzzle' || paused) return;
      let last = Date.now(), lastSec = -1;
      clkIv = setInterval(() => { const now = Date.now(); if (!paused && !over) { clk[p.side] -= now - last; const s = Math.ceil(clk[p.side] / 1000); if (s <= 10 && s !== lastSec && s > 0 && (mode === 'local' || p.side === me)) { lastSec = s; x.sfx('tick'); } if (clk[p.side] <= 0) { clk[p.side] = 0; paintClock(); finish('flag', -p.side); return; } paintClock(); } last = now; }, 250);
      win.timers.push(clkIv);
    };
    const stats = () => { const caps = p.stack.filter(u => u.m.cap).length; const out = [{ label: 'Lances', value: String(Math.ceil(p.stack.length / 2)) }, { label: 'Capturas', value: String(caps) }]; if (openName) out.push({ label: 'Abertura', value: openName }); out.push({ label: 'Tempo', value: fmtT(chrono.secs()) }); return out; };
    /* fim: why = mate|stale|rep|fifty|mat|flag|resign|left|timeout, winner = 1|-1|0 (lado), cur = payload do servidor (online) */
    const finish = (why, winner, cur2) => {
      if (over) return; over = true; busy = false; sel = -1; moves = []; hintMv = null; stopClock(); chrono.stop(); gen++;
      const iWon = mode !== 'local' && winner === me;
      const title = { mate: 'Xeque-mate', stale: 'Rei afogado', rep: 'Empate por repetição', fifty: 'Empate pelos cinquenta lances', mat: 'Material insuficiente', flag: 'Tempo esgotado', resign: 'Desistência', left: 'O adversário saiu', timeout: 'Tempo esgotado' }[why] || 'Fim de jogo';
      let sub = 'Empate';
      if (winner) {
        if (mode === 'local') sub = winner === 1 ? 'As brancas ganham' : 'As pretas ganham';
        else if (iWon) { sub = 'Ganhaste'; if (mode === 'ia') { const n = addWin('chess:' + level); A.setScore(n); sub = `Venceste ${lv().name} · ${plural(n, 'vitória', 'vitórias')}`; if (level === 'gm') flagAch('chessWinHard'); } else A.setScore(addWin('chess:online')); }
        else sub = mode === 'ia' ? `${lv().name} ganhou` : `${oppName()} ganhou`;
      }
      if (mode === 'online' && cur2 && link) sub = mpWhy(cur2, link) || sub;
      paint(); x.sfx(winner ? (iWon || mode === 'local' ? 'win' : 'lose') : 'tick');
      if (winner && (iWon || mode === 'local')) x.celebrate('win');
      if (link) { link.destroy(); }
      const win_ = mode === 'local' ? !!winner : (winner ? iWon : undefined), st = stats();
      const tm = setTimeout(() => { if (mode === 'online') mpEnd(x, GAME, title, sub, win_, st); else x.end({ title, sub, score: null, submit: false, win: win_, stats: st }); link = null; }, 800); win.timers.push(tm);
    };
    const settle = () => {
      const st = CH.status(p);
      if (st !== 'play') { finish(st, st === 'mate' ? -p.side : 0); return; }
      moves = (mode === 'local' || p.side === me) ? CH.legal(p) : [];
      paint(); startClock();
      if (mode === 'ia' && p.side !== me) aiTurn();
    };
    const slotOf = side => (side === 1 ? first : (first === 'a' ? 'b' : 'a'));
    const record = m => { const s = CH.san(p, m, moves.length ? moves : undefined); sans.push(s); hist.push(CH.str(m)); const o = CH.opening(hist); if (o) openName = o; return s; };
    const apply = (m, fromNet) => {
      const s = record(m); moveDom(m); CH.play(p, m); lastMv = [CH.to64(m.f), CH.to64(m.t)]; sel = -1; hintMv = null;
      const c = clockCfg(); if (c.inc && !fromNet && mode !== 'online' && clk[-p.side] > 0) clk[-p.side] += c.inc * 1000;
      const chk = CH.inCheck(p, p.side);
      x.sfx(m.cap ? 'capture' : 'place'); if (chk && CH.legal(p).length) { x.sfx('chime'); x.flash('Xeque!', 'big'); }
      if (s.castle) x.flash('Roque', 'pts'); else if (m.promo) x.flash('Promoção', 'pts');
      if (mode === 'online' && !fromNet && link) {
        const st = CH.ser(p); st.first = first; st.mv = CH.str(m); const s0 = CH.status(p);
        if (s0 !== 'play') st.end = { winner: s0 === 'mate' ? slotOf(-p.side) : 0, why: s0 };
        link.send(CH.str(m), st).then(r => { if (r && r.error && !over) { UI.toast(r.error === 'turn' ? 'Não é a tua vez' : 'A jogada não chegou ao servidor'); resync(); } });
      }
      settle();
    };
    const resync = async () => { if (!link || over) return; const r = await Arcade.match.state({ id: link.m.id }); if (!r || r.error || over) return; const st = Online.parse(r.state); const q = st && CH.des(st); if (q) { p = q; lastMv = null; sync(); settle(); } };
    const aiTurn = async () => {
      busy = true; paint(); const my = ++gen;
      await sleep(420);
      const m = await CH.think(p, level, { cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return;
      busy = false; if (m) apply(m); else settle();
    };
    /* puzzle do dia: só a jogada de mate conta; as outras voltam para trás com um abanão */
    const puzzleTry = m => {
      tries++;
      if (CH.str(m) === puzzle.solution) {
        moveDom(m); record(m); CH.play(p, m); lastMv = [CH.to64(m.f), CH.to64(m.t)]; sel = -1; moves = []; over = true; chrono.stop(); hintMv = null;
        x.sfx('win'); x.flash('Mate!', 'big'); x.celebrate('win'); flagAch('chessPuzzle');
        Store.set('gbChessPuzzle', { day: dayIndex(), solved: true, tries });
        paint();
        const tm = setTimeout(() => x.end({ title: 'Mate em 1 resolvido', sub: 'Puzzle do dia', score: null, submit: false, win: true, stats: [{ label: 'Tentativas', value: String(tries) }, { label: 'Tempo', value: fmtT(chrono.secs()) }, { label: 'Dicas', value: String(hints) }] }), 900); win.timers.push(tm);
        return;
      }
      sel = -1; paint(); x.sfx('fail'); x.haptic('medium'); x.flash(tries >= 2 ? 'Não é mate. Pede uma dica' : 'Não é mate', 'pts');
      const e = pcAt[CH.to64(m.f)]; if (e) { e.firstElementChild.classList.remove('nope'); void e.offsetWidth; e.firstElementChild.classList.add('nope'); }
    };
    const tapSq = async di => {
      if (over || busy || !p || paused) return;
      if (mode !== 'local' && p.side !== me) return;
      const i = dIdx(di), v = p.b[CH.to88(i)];
      if (sel >= 0) {
        const ms = moves.filter(m => CH.to64(m.f) === sel && CH.to64(m.t) === i);
        if (ms.length) {
          let m = ms[0];
          if (ms.length > 1) { const r = await UI.actionSheet({ title: 'Promover a', buttons: [{ label: 'Dama', value: '5' }, { label: 'Torre', value: '4' }, { label: 'Bispo', value: '3' }, { label: 'Cavalo', value: '2' }] }); if (r == null || over) return; m = ms.find(z => z.promo === +r) || ms[0]; }
          if (mode === 'puzzle') puzzleTry(m); else apply(m); return;
        }
      }
      if (v && (v > 0) === (p.side > 0)) { sel = sel === i ? -1 : i; hintMv = null; x.haptic('light'); paint(); return; }
      if (sel >= 0) { sel = -1; paint(); }
    };
    board.addEventListener('click', e => { const s = e.target.closest('.gch-sq'); if (s) tapSq(+s.dataset.i); });
    const applyTheme = () => { THEMES.forEach(t => wrap.classList.toggle('gch-t-' + t.v, t.v === theme)); };
    const begin = st => {
      p = (st && CH.des(st)) || CH.create(); over = false; busy = false; sel = -1; lastMv = null; capKey = ''; hintMv = null; hints = 0; hist = []; sans = []; openName = null; gen++; chrono.reset(); chrono.start();
      if (st && typeof st.mv === 'string' && st.mv.length >= 4) { const f = 'abcdefgh'.indexOf(st.mv[0]), r = 8 - +st.mv[1], f2 = 'abcdefgh'.indexOf(st.mv[2]), r2 = 8 - +st.mv[3]; if (f >= 0 && f2 >= 0 && r >= 0 && r < 8 && r2 >= 0 && r2 < 8) lastMv = [r * 8 + f, r2 * 8 + f2]; }
      const c = clockCfg(); clk = { 1: c.min * 60000, '-1': c.min * 60000 }; paintClock();
      wrap.classList.remove('gbd-hide'); applyTheme(); names(); paintCoords(); sync();
      /* partida com relógio: contagem 3, 2, 1 da casca antes de o relógio arrancar (se a casca a tiver) */
      if (c.min && (mode === 'ia' || mode === 'local') && !(p && p.stack.length) && A.countdown) {
        busy = true; paint(); const my = gen;
        Promise.resolve().then(() => A.countdown(3)).catch(() => {}).then(() => { if (my !== gen) return; busy = false; settle(); paintClock(); });
        return;
      }
      settle(); paintClock();
    };
    const onOpp = (cur2, st) => {
      if (over || !p || !st) return;
      const m = typeof st.mv === 'string' ? CH.find(p, st.mv) : null;
      if (m && p.side !== me) { moves = CH.legal(p); apply(m, true); return; }
      const q = CH.des(st); if (q) { p = q; lastMv = null; capKey = ''; sync(); settle(); }
    };
    const onEnd = cur2 => {
      if (over) return;
      const w = cur2.winner, side = (w === 'a' || w === 'b') ? (w === first ? 1 : -1) : 0;
      const st = Online.parse(cur2.state);
      if (st && st.mv && st.n != null && st.n > p.hist.length - 1 && p.side !== me) { const m = CH.find(p, st.mv); if (m) { record(m); moveDom(m); CH.play(p, m); lastMv = [CH.to64(m.f), CH.to64(m.t)]; } }
      const why = cur2.reason === 'timeout' ? 'timeout' : cur2.reason === 'left' ? 'left' : (st && st.end && st.end.why) || (side ? 'mate' : 'rep');
      finish(why, side, cur2);
    };
    const startOnline = m => {
      mode = 'online'; const st = Online.parse(m.state);
      first = (m.moves | 0) === 0 ? (m.turn === 'b' ? 'b' : 'a') : ((st && (st.first === 'a' || st.first === 'b')) ? st.first : 'a');
      me = m.you === first ? 1 : -1; flip = me === -1;
      link = Online.join(A, m, { onOpp, onEnd });
      A.setScore(winsOf('chess:online')); begin(st);
      if (m.ended) onEnd(m);
    };
    const startPuzzle = async () => {
      mode = 'puzzle'; me = 1; flip = false; tries = 0; A.setScore(winsOf('chess:puzzle'));
      wrap.classList.remove('gbd-hide'); mid(`<span class="gm-hint">A preparar o puzzle</span>`); const my = ++gen;
      const z = await CH.puzzle(dayIndex(), { cancelled: () => my !== gen });
      if (my !== gen || !z) return;
      puzzle = z; begin(CH.ser(z.p));
    };
    const start = ch => {
      if (!ch) return;
      if (ch.mode === 'online') { startOnline(ch.m); return; }
      if (ch.mode === 'puzzle') { startPuzzle(); return; }
      mode = ch.mode; level = CH.normLevel(ch.level || level); me = 1; flip = false;
      A.setScore(mode === 'ia' ? winsOf('chess:' + level) : 0); begin(null);
    };
    const puzzleDone = () => { const s = Store.get('gbChessPuzzle', null); return !!(s && s.day === dayIndex() && s.solved); };
    const toLobby = async () => {
      gen++; stopClock(); chrono.stop(); if (link) { link.destroy(); link = null; } over = true; wrap.classList.add('gbd-hide'); A.setMid(''); [bUndo, bHint, bList, bResign].forEach(b => b.classList.add('off'));
      start(await lobby(A, { game: GAME, name: 'Xadrez', tagline: 'Cinco adversários, três tabuleiros, puzzle do dia', cover: COVER.chess, levels: LVL, level, extra: { key: 'puzzle', title: 'Puzzle do dia', sub: 'Mate em 1', icon: 'sparkles', done: puzzleDone() } }));
    };
    const restart = () => { if (mode === 'online' || !mode) toLobby(); else if (mode === 'puzzle') { if (puzzleDone()) toLobby(); else startPuzzle(); } else { gen++; stopClock(); start({ mode, level }); } };
    bModes.onclick = async () => {
      if (!over && mode === 'online') { if (!await UI.confirm('Sair da partida', 'Sais da partida online e conta como derrota.', 'Sair', true)) return; if (link) link.leave(); }
      else if (!over && mode === 'ia' && p.stack.length && !await UI.confirm('Mudar de modo', 'Perdes a partida atual.', 'Mudar', true)) return;
      toLobby();
    };
    bResign.onclick = async () => { if (over || mode === 'local' || mode === 'puzzle') return; if (!await UI.confirm('Desistir', 'Dás a partida como perdida.', 'Desistir', true)) return; if (link) link.leave(); finish('resign', -me); };
    bUndo.onclick = () => { if (bUndo.classList.contains('off') || mode !== 'ia' || busy || over) return; do { CH.unplay(p); hist.pop(); sans.pop(); } while (p.stack.length && p.side !== me); openName = CH.opening(hist); const top = p.stack[p.stack.length - 1]; lastMv = top ? [CH.to64(top.m.f), CH.to64(top.m.t)] : null; sel = -1; capKey = ''; hintMv = null; sync(); x.haptic('light'); settle(); };
    bHint.onclick = async () => {
      if (bHint.classList.contains('off') || over || busy) return;
      if (mode === 'puzzle') { const m = CH.find(p, puzzle.solution); if (!m) return; hints++; sel = CH.to64(m.f); hintMv = tries >= 2 ? m : { f: m.f, t: m.f }; paint(); x.sfx('pop'); x.toast(tries >= 2 ? 'A jogada está assinalada' : 'A peça certa está assinalada'); return; }
      busy = true; paint(); const my = ++gen;
      const m = await CH.think(p, 'mestre', { exact: true, budget: 160000, cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return; busy = false;
      if (m) { hints++; hintMv = m; sel = -1; x.sfx('pop'); } paint();
    };
    const sheetMoves = () => {
      if (!sans.length) return;
      const rows = []; for (let i = 0; i < sans.length; i += 2) rows.push(`<div class="r" data-noi18n><i>${(i >> 1) + 1}.</i><span>${chSanHtml(sans[i])}</span><span>${sans[i + 1] ? chSanHtml(sans[i + 1]) : ''}</span></div>`);
      const body = el(`<div class="gch-moves"><div class="hd"><b>${esc(openName || 'Partida')}</b><span>${plural(Math.ceil(sans.length / 2), 'lance', 'lances')}</span></div>${rows.join('')}</div>`);
      UI.sheet({ title: 'Lances', right: 'Fechar', body });
      const tm = setTimeout(() => { const last = body.querySelector('.r:last-child'); if (last && last.scrollIntoView) { try { last.scrollIntoView({ block: 'end' }); } catch (e) {} } }, 60); win.timers.push(tm);
    };
    bList.onclick = sheetMoves; tick.onclick = sheetMoves;
    bFlip.onclick = () => { if (!p) return; flip = !flip; x.sfx('slide'); names(); paintCoords(); Object.keys(pcAt).forEach(i => place(pcAt[i], +i)); paint(); };
    bTheme.onclick = () => { const i = THEMES.findIndex(t => t.v === theme); theme = THEMES[(i + 1) % THEMES.length].v; Arcade.setOpt('chess:theme', theme); applyTheme(); x.sfx('slide'); x.toast(`Tabuleiro: ${THEMES.find(t => t.v === theme).label}`); };
    x.options([{ key: 'clock', label: 'Relógio', values: CLOCKS.map(c => ({ v: c.v, label: c.label })), cur: clockKey, onChange: v => { clockKey = String(v); Arcade.setOpt('chess:clock', clockKey); const c = clockCfg(); if (!p || !p.stack.length) clk = { 1: c.min * 60000, '-1': c.min * 60000 }; paintClock(); if (!over) startClock(); } }]);

    (async () => { await x.ready('Xadrez', 'Cinco adversários, puzzle do dia e partidas online'); const pm = Online.takePending(GAME); if (pm) startOnline(pm); else toLobby(); })();
    win.onClose = () => { gen++; stopClock(); chrono.stop(); if (link) link.destroy(); };
    const api = {
      pause() { paused = true; stopClock(); chrono.stop(); }, resume() { paused = false; if (!over && p) { chrono.start(); startClock(); } },
      key(e) { const k = e.key; if (k === 'u' || k === 'U') { bUndo.click(); return; } if (k === 'h' || k === 'H') { bHint.click(); return; } if (k === 'f' || k === 'F') { bFlip.click(); return; } if (k === 'l' || k === 'L') { bList.click(); return; } if (k === 't' || k === 'T') { bTheme.click(); return; } cur.key(e); },
      test: { get p() { return p; }, tap: tapSq, start: ch => { closeLobby(stage); start(ch); }, load: st => { closeLobby(stage); gen++; stopClock(); mode = 'local'; me = 1; flip = false; A.setScore(0); begin(st); }, get mode() { return mode; }, get over() { return over; }, get puzzle() { return puzzle; }, get sans() { return sans; }, get opening() { return openName; }, hint: () => bHint.click(), list: sheetMoves, flip: () => bFlip.click(), setTheme: t => { theme = t; applyTheme(); }, setLevel: v => { level = v; }, setClock: v => { clockKey = v; const c = clockCfg(); clk = { 1: c.min * 60000, '-1': c.min * 60000 }; paintClock(); startClock(); }, CH },
    };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   DAMAS (regras inglesas, 8×8): peões só para a frente, captura obrigatória (qualquer uma, com a
   sequência completa), damas andam uma casa em qualquer diagonal, promoção termina a jogada.
   Empate: 40 jogadas sem captura nem promoção, ou repetição tripla. Ronda 2: cinco níveis, dica,
   tabuleiro de madeira, peças com relevo e salto em arco.
   ===================================================================== */
ENG.checkers = (() => {
  const rc = (r, c) => r * 8 + c, MATE = 100000, INF = 1e9;
  const create = () => { const b = new Int8Array(64); for (let r = 0; r < 3; r++) for (let c = 0; c < 8; c++) if ((r + c) & 1) b[rc(r, c)] = -1; for (let r = 5; r < 8; r++) for (let c = 0; c < 8; c++) if ((r + c) & 1) b[rc(r, c)] = 1; const s = { b, side: 1, quiet: 0, hist: [] }; s.hist.push(key(s)); return s; };
  const key = s => Array.from(s.b, v => v + 2).join('') + s.side;
  const dirsOf = v => (v === 2 || v === -2) ? [[-1, -1], [-1, 1], [1, -1], [1, 1]] : v > 0 ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]];
  const jumps = (b, r, c, v, path, caps, out) => {
    let any = false;
    for (const [dr, dc] of dirsOf(v)) {
      const mr = r + dr, mc = c + dc, lr = r + 2 * dr, lc = c + 2 * dc;
      if (lr < 0 || lr > 7 || lc < 0 || lc > 7) continue;
      const mid = b[rc(mr, mc)];
      if (!mid || (mid > 0) === (v > 0) || b[rc(lr, lc)]) continue;
      any = true;
      const b2 = b.slice(); b2[rc(r, c)] = 0; b2[rc(mr, mc)] = 0;
      const promo = (v === 1 || v === -1) && (v > 0 ? lr === 0 : lr === 7);
      b2[rc(lr, lc)] = promo ? v * 2 : v;
      const p2 = path.concat(rc(lr, lc)), c2 = caps.concat(rc(mr, mc));
      if (promo) out.push({ path: p2, caps: c2, promo: true }); else jumps(b2, lr, lc, v, p2, c2, out);
    }
    if (!any && caps.length) out.push({ path, caps, promo: false });
  };
  const moves = s => {
    const b = s.b, me = s.side, caps = [], plain = [];
    for (let i = 0; i < 64; i++) {
      const v = b[i]; if (!v || (v > 0) !== (me > 0)) continue;
      const r = i >> 3, c = i & 7;
      jumps(b, r, c, v, [i], [], caps);
      if (caps.length) continue;
      for (const [dr, dc] of dirsOf(v)) { const nr = r + dr, nc = c + dc; if (nr < 0 || nr > 7 || nc < 0 || nc > 7 || b[rc(nr, nc)]) continue; plain.push({ path: [i, rc(nr, nc)], caps: [], promo: (v === 1 || v === -1) && (v > 0 ? nr === 0 : nr === 7) }); }
    }
    return caps.length ? caps : plain;
  };
  const next = (s, m) => {
    const b = s.b.slice(), f = m.path[0], t = m.path[m.path.length - 1], v = b[f];
    b[f] = 0; m.caps.forEach(i => { b[i] = 0; }); b[t] = m.promo ? v * 2 : v;
    return { b, side: -s.side, quiet: m.caps.length || m.promo ? 0 : s.quiet + 1, hist: s.hist };
  };
  const play = (s, m) => { const n = next(s, m); n.hist = s.hist.concat(key(n)); return n; };
  const repeated = s => { const k = key(s); let n = 0; for (const h of s.hist) if (h === k) n++; return n; };
  const evaluate = s => {
    const b = s.b; let e = 0, red = 0, blk = 0;
    for (let i = 0; i < 64; i++) {
      const v = b[i]; if (!v) continue;
      const r = i >> 3, c = i & 7, king = v === 2 || v === -2;
      let val = king ? 165 : 100;
      if (!king) val += v > 0 ? (7 - r) * 3 : r * 3;
      if (!king && ((v > 0 && r === 7) || (v < 0 && r === 0))) val += 9;
      if (c >= 2 && c <= 5 && r >= 2 && r <= 5) val += 4;
      if (v > 0) { e += val; red += val; } else { e -= val; blk += val; }
    }
    if (red !== blk) e += Math.round((red - blk) * 12 / (red + blk));
    return e;
  };
  let nodes = 0, budget = 0;
  const order = ms => ms.sort((a, b) => (b.caps.length * 100 + (b.promo ? 50 : 0)) - (a.caps.length * 100 + (a.promo ? 50 : 0)));
  const negamax = (s, depth, alpha, beta, ply) => {
    nodes++;
    if (s.quiet >= 80) return 0;
    const ms = moves(s);
    if (!ms.length) return -MATE + ply;
    const forced = ms[0].caps.length > 0;
    if ((depth <= 0 && !forced) || depth <= -6) return evaluate(s) * s.side;
    let best = -INF;
    for (const m of order(ms)) {
      const v = -negamax(next(s, m), depth - 1, -beta, -alpha, ply + 1);
      if (v > best) best = v; if (v > alpha) alpha = v;
      if (alpha >= beta || nodes > budget) break;
    }
    return best;
  };
  const LEVELS = { principiante: { d: 1, noise: 90, budget: 8000 }, clube: { d: 2, noise: 50, budget: 20000 }, avancado: { d: 4, noise: 12, budget: 80000 }, mestre: { d: 6, noise: 0, budget: 200000 }, gm: { d: 8, noise: 0, budget: 420000 } };
  const normLevel = v => ({ facil: 'principiante', medio: 'avancado', dificil: 'mestre' }[v] || (LEVELS[v] ? v : 'clube'));
  async function think(s, level, o) {
    o = o || {}; const cfg = LEVELS[normLevel(level)] || LEVELS.clube;
    const root = moves(s); if (!root.length) return null; if (root.length === 1) return root[0];
    nodes = 0; budget = o.budget || cfg.budget;
    const wide = !!cfg.noise && !o.exact;   /* notas exatas na raiz quando há ruído (ver o xadrez) */
    let best = null, scores = null, slice = performance.now();
    for (let d = 1; d <= cfg.d; d++) {
      order(root); if (best) { const i = root.indexOf(best); if (i > 0) { root.splice(i, 1); root.unshift(best); } }
      let alpha = -INF, bd = null, stopped = false; const sc = [];
      for (const m of root) {
        const v = -negamax(next(s, m), d - 1, -INF, wide ? INF : -alpha, 1);
        sc.push(v); if (v > alpha) { alpha = v; bd = m; }
        if (nodes > budget) { stopped = sc.length < root.length; break; }
        if (performance.now() - slice > 12) { await sleep(0); if (o.wait) await o.wait(); slice = performance.now(); if (o.cancelled && o.cancelled()) return null; }
      }
      if (!stopped) { best = bd; scores = root.map((m, i) => ({ m, v: sc[i] })); } else if (!best) best = bd;
      if (stopped || nodes > budget || Math.abs(alpha) > MATE - 200) break;
    }
    if (cfg.noise && scores && !o.exact) { const top = Math.max(...scores.map(z => z.v)); const pool = scores.filter(z => z.v >= top - cfg.noise && z.v > -MATE / 2); if (pool.length) best = pool[rnd(pool.length)].m; }
    return best;
  }
  const status = s => { if (!moves(s).length) return 'nomoves'; if (s.quiet >= 80) return 'quiet'; if (repeated(s) >= 3) return 'rep'; return 'play'; };
  const str = m => m.path.join(m.caps.length ? 'x' : '-');
  const find = (s, t) => moves(s).find(m => str(m) === t) || null;
  const ser = s => ({ b: Array.from(s.b, v => String(v + 2)).join(''), s: s.side, q: s.quiet, hist: s.hist.slice(-24), n: s.hist.length - 1 });
  const des = o => {
    if (!o || typeof o.b !== 'string' || !/^[0-4]{64}$/.test(o.b)) return null;
    const b = Int8Array.from(o.b, ch => +ch - 2);
    for (let i = 0; i < 64; i++) if (b[i] && !(((i >> 3) + (i & 7)) & 1)) return null;
    const s = { b, side: o.s === -1 ? -1 : 1, quiet: Math.max(0, Math.min(200, o.q | 0)), hist: Array.isArray(o.hist) ? o.hist.filter(x => typeof x === 'string').slice(-24) : [] };
    const k = key(s); if (!s.hist.length || s.hist[s.hist.length - 1] !== k) s.hist.push(k);
    return s;
  };
  return { create, moves, next, play, evaluate, think, status, str, find, ser, des, rc, key, LEVELS, normLevel };
})();

const DM_CROWN = `<svg viewBox="0 0 24 24" class="crown"><path d="M4 17h16l1.5-9-5 3.5L12 5l-4.5 6.5-5-3.5z" fill="#7A4A00" transform="translate(0 1)"/><path d="M4 17h16l1.5-9-5 3.5L12 5l-4.5 6.5-5-3.5z" fill="#FFD766"/><path d="M6 15h12" stroke="#B5801A" stroke-width="1.4" stroke-linecap="round"/></svg>`;
const dmDisc = v => `<div class="gdm-pc ${v > 0 ? 'red' : 'blk'} ${Math.abs(v) === 2 ? 'king' : ''}"><i class="rim"></i><i class="top"></i>${DM_CROWN}</div>`;
COVER.checkers = () => `<svg viewBox="0 0 400 200" preserveAspectRatio="xMidYMid slice" class="gbd-cv"><defs><linearGradient id="gbcDm1" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#5A2F18"/><stop offset="1" stop-color="#1E0F08"/></linearGradient><radialGradient id="gbcDm2" cx=".35" cy=".3"><stop offset="0" stop-color="#FF7A5C"/><stop offset=".7" stop-color="#C3291A"/><stop offset="1" stop-color="#7A1208"/></radialGradient><radialGradient id="gbcDm3" cx=".35" cy=".3"><stop offset="0" stop-color="#666672"/><stop offset=".7" stop-color="#26262E"/><stop offset="1" stop-color="#0D0D12"/></radialGradient></defs><rect width="400" height="200" fill="url(#gbcDm1)"/>${[0, 1, 2, 3].map(r => [0, 1, 2, 3, 4, 5, 6, 7, 8].map(c => ((r + c) & 1) ? `<rect x="${-10 + c * 50 + r * 14}" y="${60 + r * 36}" width="50" height="36" fill="#E9D4B0" opacity="${.18 + r * .06}"/>` : '').join('')).join('')}${[[110, 92, 1], [206, 128, 1], [262, 92, -1], [318, 128, -1], [150, 150, -1]].map(([x, y, v]) => `<ellipse cx="${x}" cy="${y + 10}" rx="30" ry="9" fill="#000" opacity=".35"/><ellipse cx="${x}" cy="${y + 4}" rx="30" ry="18" fill="${v > 0 ? '#8E1A0E' : '#0E0E12'}"/><ellipse cx="${x}" cy="${y}" rx="30" ry="18" fill="url(#gbcDm${v > 0 ? 2 : 3})"/><ellipse cx="${x}" cy="${y}" rx="20" ry="11" fill="none" stroke="#fff" stroke-opacity=".22" stroke-width="2"/>`).join('')}<path d="M196 112l10-16 10 16 9-9-4 21h-30l-4-21z" fill="#FFD766"/></svg>`;
Icons.app.checkers = () => Icons.SVG(Icons.G('gDm', '#FF9A7A', '#E0452F', '#8E1A0E') + Icons.GL(
  `<rect x="14" y="14" width="72" height="72" rx="10" fill="#3A1A0C" opacity=".55"/>` +
  [0, 1, 2, 3].map(r => [0, 1, 2, 3].map(c => ((r + c) & 1) ? `<rect x="${14 + c * 18}" y="${14 + r * 18}" width="18" height="18" fill="#F1DEBF" opacity=".55"/>` : '').join('')).join('') +
  `<ellipse cx="42" cy="47" rx="17" ry="10" fill="#0A0A10" opacity=".5"/><ellipse cx="42" cy="42" rx="17" ry="10" fill="#1C1C22"/><ellipse cx="42" cy="38" rx="17" ry="10" fill="#3A3A46"/>` +
  `<ellipse cx="58" cy="60" rx="17" ry="10" fill="#7A1208"/><ellipse cx="58" cy="55" rx="17" ry="10" fill="#FF6A52"/><ellipse cx="58" cy="55" rx="11" ry="6" fill="none" stroke="#fff" stroke-opacity=".35" stroke-width="2"/><path d="M52 57l3-6 3 5 3-5 3 6z" fill="#FFD766"/>`));

Arcade.game('checkers', {
  name: 'Damas', color: '#E0452F', kind: 'board', unit: 'vitórias', scoreLabel: 'Vitórias', mp: true, tags: ['Clássico', 'Online'],
  desc: 'Damas inglesas 8×8 num tabuleiro de madeira: captura obrigatória, sequências de captura, damas coroadas, dica e cinco adversários. Dois jogadores no mesmo telemóvel ou online.',
  cover: () => COVER.checkers(),
  howto: { goal: 'Captura ou bloqueia todas as peças do adversário.', steps: ['As peças andam uma casa na diagonal para a frente', 'Salta por cima de uma peça adversária para a capturar; capturar é obrigatório', 'Uma peça que chega à última linha vira dama e anda para trás', 'As vermelhas começam'], controls: [{ icon: 'hand', label: 'Toca na peça e no destino' }, { icon: 'grid', label: 'Setas ou WASD e Enter' }, { icon: 'bulb', label: 'H dá uma dica, U desfaz' }] },
  modes: [{ key: 'ia', label: 'Contra o telemóvel' }, { key: 'local', label: 'Dois jogadores' }, { key: 'online', label: 'Online' }],
  build(win) {
    const D = ENG.checkers, GAME = 'checkers';
    const LVL = [
      { v: 'principiante', label: 'Principiante', name: 'Zé', face: 'kid', color: '#5EE39A' },
      { v: 'clube', label: 'Clube', name: 'Carla', face: 'young', color: '#5CB4FF' },
      { v: 'avancado', label: 'Avançado', name: 'Tio Manel', face: 'glasses', color: '#FFD60A' },
      { v: 'mestre', label: 'Mestre', name: 'Dona Alice', face: 'bun', color: '#FF9F0A' },
      { v: 'gm', label: 'Grande Mestre', name: 'Baptista', face: 'beard', color: '#FF375F' },
    ];
    const A = Arcade.shell(win, { id: GAME, name: 'Damas', color: '#E0452F', pausable: false, scoreLabel: 'Vitórias', bestLabel: 'Recorde', onRestart: () => restart() });
    const x = X(A), stage = A.el.stage;
    const wrap = el(`<div class="gdm-wrap gbd-hide">${playerCard('top', 'Pretas', '')}<div class="gdm-frame"><div class="gdm-board"><div class="gdm-sqs">${Array.from({ length: 64 }, (_, i) => `<div class="gdm-sq ${((i >> 3) + (i & 7)) & 1 ? 'gdm-dk' : 'gdm-lt'}" data-i="${i}"></div>`).join('')}</div><div class="gdm-pcs"></div></div></div>${playerCard('bot', 'Vermelhas', '')}</div>`);
    stage.appendChild(wrap);
    const board = wrap.querySelector('.gdm-board'), pcs = wrap.querySelector('.gdm-pcs'), sqs = [...wrap.querySelectorAll('.gdm-sq')];
    const card = { 1: wrap.querySelector('.gbd-pl.bot'), '-1': wrap.querySelector('.gbd-pl.top') };
    A.el.ctl.innerHTML = `<div class="gm-row wide gbd-tools">${tool('undo', 'arrowL', 'Desfazer', true)}${tool('hint', 'bulb', 'Dica', true)}${tool('flip', 'rotate', 'Virar', false)}</div><div class="gm-row wide gbd-tools">${tool('modes', 'grid', 'Modos', false)}${tool('resign', 'flag', 'Desistir', true)}</div>`;
    const bUndo = A.el.ctl.querySelector('.undo'), bHint = A.el.ctl.querySelector('.hint'), bFlip = A.el.ctl.querySelector('.flip'), bModes = A.el.ctl.querySelector('.modes'), bResign = A.el.ctl.querySelector('.resign');

    let s = null, states = [], mode = null, level = D.normLevel(Arcade.opt('checkers:lv', 'clube')), me = 1, flip = false, sel = -1, ms = [], last = null, over = true, busy = false, paused = false, gen = 0, link = null, first = 'a', pcAt = {}, hintMv = null, firstMount = true, plies = 0, capsBy = { 1: 0, '-1': 0 }, kingsBy = { 1: 0, '-1': 0 }, chrono = Chrono(win, () => {});
    const lv = () => oppOf(LVL, level);
    const oppName = () => (link ? link.name : mode === 'ia' ? lv().name : 'Adversário');
    const cur = Cursor(8, 8, i => sqs.forEach((q, k) => q.classList.toggle('cur', k === i)), i => tapSq(i));
    const dIdx = i => (flip ? 63 - i : i);
    const mid = html => { if (mode !== 'online') A.setMid(html); };
    const place = (e, i) => { const di = dIdx(i); e.style.transform = `translate(${(di & 7) * 46}px, ${(di >> 3) * 46}px)`; };
    const pieceEl = (v, n) => { const e = el(`<div class="gdm-p"><div class="gdm-pi ${firstMount ? 'in' : ''}" style="--d:${firstMount ? n * 22 : 0}ms">${dmDisc(v)}</div></div>`); return e; };
    const sync = () => { pcs.innerHTML = ''; pcAt = {}; let n = 0; for (let i = 0; i < 64; i++) { const v = s.b[i]; if (!v) continue; const e = pieceEl(v, n++); place(e, i); pcs.appendChild(e); pcAt[i] = e; } firstMount = false; };
    const names = () => {
      const L = lv();
      const rN = mode === 'online' ? (me === 1 ? myName() : oppName()) : mode === 'ia' ? myName() : 'Vermelhas';
      const bN = mode === 'online' ? (me === -1 ? myName() : oppName()) : mode === 'ia' ? L.name : 'Pretas';
      const rA = mode === 'local' ? g('person', 18) : (mode === 'online' && me !== 1) ? avatarOf(oppName()) : myAvatar();
      const bA = mode === 'ia' ? portrait(L.face, L.color, 34) : mode === 'online' ? (me === -1 ? myAvatar() : avatarOf(oppName())) : g('person', 18);
      setCard(card[1], rN, 'Vermelhas · começam', rA); setCard(card['-1'], bN, mode === 'ia' ? 'Pretas · ' + L.label : 'Pretas', bA);
      wrap.classList.toggle('flip', flip);
    };
    const count = () => { let r = 0, b = 0, rk = 0, bk = 0; for (let i = 0; i < 64; i++) { const v = s.b[i]; if (v > 0) { r++; if (v === 2) rk++; } else if (v < 0) { b++; if (v === -2) bk++; } } card[1].querySelector('.gbd-clk').innerHTML = `<span class="gdm-cnt"><i class="red"></i>${r}${rk ? `<em>${rk}</em>` : ''}</span>`; card['-1'].querySelector('.gbd-clk').innerHTML = `<span class="gdm-cnt"><i class="blk"></i>${b}${bk ? `<em>${bk}</em>` : ''}</span>`; };
    const paint = () => {
      if (!s) return;
      const tg = {}; if (sel >= 0) ms.forEach(m => { if (m.path[0] === sel) tg[m.path[m.path.length - 1]] = m.caps.length ? 2 : 1; });
      const movable = {}; if (!over && !busy && (mode === 'local' || s.side === me)) ms.forEach(m => { movable[m.path[0]] = 1; });
      for (let di = 0; di < 64; di++) { const i = dIdx(di), q = sqs[di]; q.classList.toggle('sel', i === sel); q.classList.toggle('tgt', tg[i] === 1); q.classList.toggle('tcap', tg[i] === 2); q.classList.toggle('last', !!last && (last[0] === i || last[1] === i)); q.classList.toggle('hint', !!hintMv && (hintMv.path[0] === i || hintMv.path[hintMv.path.length - 1] === i)); }
      Object.keys(pcAt).forEach(i => pcAt[i].classList.toggle('can', !!movable[i]));
      card[1].classList.toggle('on', !over && s.side === 1); card['-1'].classList.toggle('on', !over && s.side === -1);
      let h = '';
      if (!over) { const forced = ms.length && ms[0].caps.length; h = mode === 'ia' ? (s.side === me ? (forced ? 'Tens de capturar' : 'A tua vez') : `${lv().name} está a pensar`) : forced ? (s.side === 1 ? 'Vermelhas: captura obrigatória' : 'Pretas: captura obrigatória') : (s.side === 1 ? 'Vez das vermelhas' : 'Vez das pretas'); }
      mid(h ? `<span class="gm-hint">${esc(h)}</span>` : '');
      const human = mode === 'local' || s.side === me;
      bUndo.classList.toggle('off', mode !== 'ia' || over || busy || states.length < 2);
      bHint.classList.toggle('off', over || busy || !human || mode === 'online');
      bResign.classList.toggle('off', over || mode === 'local');
      count();
    };
    const stats = () => [{ label: 'Lances', value: String(plies) }, { label: 'Capturas', value: `${capsBy[1]} : ${capsBy[-1]}` }, { label: 'Coroadas', value: `${kingsBy[1]} : ${kingsBy[-1]}` }, { label: 'Tempo', value: fmtT(chrono.secs()) }];
    const finish = (why, winner, cur2) => {
      if (over) return; over = true; busy = false; sel = -1; ms = []; hintMv = null; gen++; chrono.stop();
      const iWon = mode !== 'local' && winner === me;
      const title = { nomoves: 'Fim da partida', quiet: 'Empate por falta de progresso', rep: 'Empate por repetição', resign: 'Desistência', left: 'O adversário saiu', timeout: 'Tempo esgotado' }[why] || 'Fim da partida';
      let sub = 'Empate';
      if (winner) {
        if (mode === 'local') sub = winner === 1 ? 'As vermelhas ganham' : 'As pretas ganham';
        else if (iWon) { sub = 'Ganhaste'; if (mode === 'ia') { const n = addWin('checkers:' + level); A.setScore(n); sub = `Venceste ${lv().name} · ${plural(n, 'vitória', 'vitórias')}`; } else A.setScore(addWin('checkers:online')); }
        else sub = mode === 'ia' ? `${lv().name} ganhou` : `${oppName()} ganhou`;
      }
      if (mode === 'online' && cur2 && link) sub = mpWhy(cur2, link) || sub;
      paint(); x.sfx(winner ? (iWon || mode === 'local' ? 'win' : 'lose') : 'tick');
      if (winner && (iWon || mode === 'local')) x.celebrate('win');
      if (link) link.destroy();
      const win_ = mode === 'local' ? !!winner : (winner ? iWon : undefined), st = stats();
      const tm = setTimeout(() => { if (mode === 'online') mpEnd(x, GAME, title, sub, win_, st); else x.end({ title, sub, score: null, submit: false, win: win_, stats: st }); link = null; }, 800); win.timers.push(tm);
    };
    const settle = () => {
      const st = D.status(s);
      if (st !== 'play') { finish(st, st === 'nomoves' ? -s.side : 0); return; }
      ms = (mode === 'local' || s.side === me) ? D.moves(s) : [];
      paint();
      if (mode === 'ia' && s.side !== me) aiTurn();
    };
    const slotOf = side => (side === 1 ? first : (first === 'a' ? 'b' : 'a'));
    /* a peça salta casa a casa (o nó exterior desliza, o interior faz o arco) e as capturadas saem pelo caminho */
    const hop = e => { const pi = e.firstElementChild; pi.classList.remove('hop'); void pi.offsetWidth; pi.classList.add('hop'); };
    const animate = async m => {
      const f = m.path[0], e = pcAt[f]; if (!e) return; delete pcAt[f]; e.style.zIndex = 4;
      for (let k = 1; k < m.path.length; k++) {
        place(e, m.path[k]); if (m.caps.length) hop(e);
        if (m.caps[k - 1] != null) { const dead = pcAt[m.caps[k - 1]]; if (dead) { delete pcAt[m.caps[k - 1]]; const t1 = setTimeout(() => { dead.firstElementChild.classList.add('gone'); const t2 = setTimeout(() => dead.remove(), 260); win.timers.push(t2); }, 130); win.timers.push(t1); } }
        x.sfx(m.caps.length ? 'capture' : 'place');
        if (k < m.path.length - 1) await sleep(260);
      }
      pcAt[m.path[m.path.length - 1]] = e;
      if (m.promo) { e.querySelector('.gdm-pc').classList.add('king'); x.sfx('chime'); x.flash('Dama!', 'big'); }
      const tz = setTimeout(() => { e.style.zIndex = ''; }, 300); win.timers.push(tz);
    };
    const apply = async (m, fromNet) => {
      busy = true; sel = -1; hintMv = null; paint();
      const str = D.str(m), anim = animate(m), side = s.side;
      states.push(s); s = D.play(s, m); last = [m.path[0], m.path[m.path.length - 1]]; plies++;
      capsBy[side] += m.caps.length; if (m.promo) kingsBy[side]++;
      if (m.caps.length >= 2) x.flash(m.caps.length >= 3 ? 'Tripla!' : 'Dupla!', 'big');
      if (m.caps.length >= 3 && (mode === 'local' || side === me)) flagAch('checkersTriple');
      if (mode === 'online' && !fromNet && link) {
        const st = D.ser(s); st.first = first; st.mv = str; const s0 = D.status(s);
        if (s0 !== 'play') st.end = { winner: s0 === 'nomoves' ? slotOf(-s.side) : 0, why: s0 };
        link.send(str, st).then(r => { if (r && r.error && !over) { UI.toast(r.error === 'turn' ? 'Não é a tua vez' : 'A jogada não chegou ao servidor'); resync(); } });
      }
      await anim; await sleep(180);
      busy = false; settle();
    };
    const resync = async () => { if (!link || over) return; const r = await Arcade.match.state({ id: link.m.id }); if (!r || r.error || over) return; const q = D.des(Online.parse(r.state)); if (q) { s = q; last = null; sync(); settle(); } };
    const aiTurn = async () => {
      busy = true; paint(); const my = ++gen;
      await sleep(360);
      const m = await D.think(s, level, { cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return;
      busy = false; if (m) apply(m); else settle();
    };
    const tapSq = di => {
      if (over || busy || !s || paused) return;
      if (mode !== 'local' && s.side !== me) return;
      const i = dIdx(di), v = s.b[i];
      if (sel >= 0) { const cands = ms.filter(m => m.path[0] === sel && m.path[m.path.length - 1] === i); if (cands.length) { cands.sort((a, b) => b.caps.length - a.caps.length); apply(cands[0]); return; } }
      if (v && (v > 0) === (s.side > 0)) { if (!ms.some(m => m.path[0] === i)) { x.sfx('fail'); x.flash(ms.length && ms[0].caps.length ? 'Tens de capturar' : 'Sem jogadas', 'pts'); const e = pcAt[i]; if (e) { e.firstElementChild.classList.remove('nope'); void e.offsetWidth; e.firstElementChild.classList.add('nope'); } return; } sel = sel === i ? -1 : i; hintMv = null; x.haptic('light'); paint(); return; }
      if (sel >= 0) { sel = -1; paint(); }
    };
    board.addEventListener('click', e => { const q = e.target.closest('.gdm-sq'); if (q) { tapSq(+q.dataset.i); return; } const pc = e.target.closest('.gdm-p'); if (pc) { const i = Object.keys(pcAt).find(k => pcAt[k] === pc); if (i != null) tapSq(flip ? 63 - +i : +i); } });

    const begin = st => {
      s = (st && D.des(st)) || D.create(); states = []; over = false; busy = false; sel = -1; last = null; hintMv = null; gen++; plies = 0; capsBy = { 1: 0, '-1': 0 }; kingsBy = { 1: 0, '-1': 0 }; chrono.reset(); chrono.start();
      if (st && typeof st.mv === 'string') { const ps = st.mv.split(/[x-]/).map(Number); if (ps.length >= 2 && ps.every(n => n >= 0 && n < 64)) last = [ps[0], ps[ps.length - 1]]; }
      wrap.classList.remove('gbd-hide'); names(); sync(); settle();
    };
    const onOpp = (cur2, st) => {
      if (over || !s || !st) return;
      const m = typeof st.mv === 'string' ? D.find(s, st.mv) : null;
      if (m && s.side !== me) { apply(m, true); return; }
      const q = D.des(st); if (q) { s = q; last = null; sync(); settle(); }
    };
    const onEnd = cur2 => {
      if (over) return;
      const w = cur2.winner, side = (w === 'a' || w === 'b') ? (w === first ? 1 : -1) : 0;
      const st = Online.parse(cur2.state);
      const why = cur2.reason === 'timeout' ? 'timeout' : cur2.reason === 'left' ? 'left' : (st && st.end && st.end.why) || (side ? 'nomoves' : 'rep');
      if (st && st.mv && st.n != null && st.n > s.hist.length - 1 && s.side !== me) { const m = D.find(s, st.mv); if (m) { s = D.play(s, m); sync(); } }
      finish(why, side, cur2);
    };
    const startOnline = m => {
      mode = 'online'; const st = Online.parse(m.state);
      first = (m.moves | 0) === 0 ? (m.turn === 'b' ? 'b' : 'a') : ((st && (st.first === 'a' || st.first === 'b')) ? st.first : 'a');
      me = m.you === first ? 1 : -1; flip = me === -1;
      link = Online.join(A, m, { onOpp, onEnd });
      A.setScore(winsOf('checkers:online')); begin(st);
      if (m.ended) onEnd(m);
    };
    const start = ch => {
      if (!ch) return;
      if (ch.mode === 'online') { startOnline(ch.m); return; }
      mode = ch.mode; level = D.normLevel(ch.level || level); me = 1; flip = false;
      A.setScore(mode === 'ia' ? winsOf('checkers:' + level) : 0); begin(null);
    };
    const toLobby = async () => { gen++; chrono.stop(); if (link) { link.destroy(); link = null; } over = true; wrap.classList.add('gbd-hide'); A.setMid(''); [bUndo, bHint, bResign].forEach(b => b.classList.add('off')); start(await lobby(A, { game: GAME, name: 'Damas', tagline: 'Madeira, captura obrigatória e cinco adversários', cover: COVER.checkers, levels: LVL, level })); };
    const restart = () => { if (mode === 'online' || !mode) toLobby(); else { gen++; start({ mode, level }); } };
    bModes.onclick = async () => {
      if (!over && mode === 'online') { if (!await UI.confirm('Sair da partida', 'Sais da partida online e conta como derrota.', 'Sair', true)) return; if (link) link.leave(); }
      else if (!over && mode === 'ia' && plies && !await UI.confirm('Mudar de modo', 'Perdes a partida atual.', 'Mudar', true)) return;
      toLobby();
    };
    bResign.onclick = async () => { if (over || mode === 'local') return; if (!await UI.confirm('Desistir', 'Dás a partida como perdida.', 'Desistir', true)) return; if (link) link.leave(); finish('resign', -me); };
    bUndo.onclick = () => { if (bUndo.classList.contains('off') || busy || over || mode !== 'ia' || !states.length) return; do { s = states.pop(); plies--; } while (states.length && s.side !== me); last = null; sel = -1; hintMv = null; sync(); x.haptic('light'); settle(); };
    bHint.onclick = async () => {
      if (bHint.classList.contains('off') || over || busy) return;
      busy = true; paint(); const my = ++gen;
      const m = await D.think(s, 'mestre', { exact: true, budget: 120000, cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return; busy = false;
      if (m) { hintMv = m; sel = -1; x.sfx('pop'); } paint();
    };
    bFlip.onclick = () => { if (!s) return; flip = !flip; x.sfx('slide'); names(); Object.keys(pcAt).forEach(i => place(pcAt[i], +i)); paint(); };

    (async () => { await x.ready('Damas', 'Captura obrigatória, damas coroadas, cinco adversários'); const pm = Online.takePending(GAME); if (pm) startOnline(pm); else toLobby(); })();
    win.onClose = () => { gen++; chrono.stop(); if (link) link.destroy(); };
    const api = { pause() { paused = true; chrono.stop(); }, resume() { paused = false; if (!over && s) chrono.start(); }, key(e) { const k = e.key; if (k === 'u' || k === 'U') { bUndo.click(); return; } if (k === 'h' || k === 'H') { bHint.click(); return; } if (k === 'f' || k === 'F') { bFlip.click(); return; } cur.key(e); }, test: { get s() { return s; }, tap: tapSq, start: ch => { closeLobby(stage); start(ch); }, load: (st, md) => { closeLobby(stage); gen++; mode = md || 'local'; me = 1; flip = false; A.setScore(0); begin(st); }, get over() { return over; }, get mode() { return mode; }, hint: () => bHint.click(), get busy() { return busy; }, D } };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   QUATRO EM LINHA: minimax alfa-beta com heurística por janelas de quatro (cinco níveis), moldura
   vidrada com furos, discos com brilho, queda com ressalto, pré-visualização ao tocar, série de
   partidas e Desfazer contra o telemóvel.
   ===================================================================== */
ENG.c4 = (() => {
  const R = 6, C = 7, idx = (r, c) => r * C + c, LINES = [], AT = Array.from({ length: 42 }, () => []);
  for (let r = 0; r < R; r++) for (let c = 0; c < C; c++) {
    if (c + 3 < C) LINES.push([idx(r, c), idx(r, c + 1), idx(r, c + 2), idx(r, c + 3)]);
    if (r + 3 < R) LINES.push([idx(r, c), idx(r + 1, c), idx(r + 2, c), idx(r + 3, c)]);
    if (c + 3 < C && r + 3 < R) LINES.push([idx(r, c), idx(r + 1, c + 1), idx(r + 2, c + 2), idx(r + 3, c + 3)]);
    if (c >= 3 && r + 3 < R) LINES.push([idx(r, c), idx(r + 1, c - 1), idx(r + 2, c - 2), idx(r + 3, c - 3)]);
  }
  LINES.forEach(L => L.forEach(i => AT[i].push(L)));
  const create = () => ({ b: new Int8Array(42), turn: 1, n: 0, last: -1 });
  const rowFor = (s, c) => { for (let r = R - 1; r >= 0; r--) if (!s.b[idx(r, c)]) return r; return -1; };
  const drop = (s, c) => { const r = rowFor(s, c); if (r < 0) return -1; s.b[idx(r, c)] = s.turn; s.last = idx(r, c); s.n++; s.turn = 3 - s.turn; return r; };
  const undrop = (s, c, r, last) => { s.b[idx(r, c)] = 0; s.n--; s.turn = 3 - s.turn; s.last = last; };
  const winAt = (s, i) => { if (i < 0) return null; const v = s.b[i]; if (!v) return null; for (const L of AT[i]) if (s.b[L[0]] === v && s.b[L[1]] === v && s.b[L[2]] === v && s.b[L[3]] === v) return { p: v, line: L }; return null; };
  const winner = s => { for (const L of LINES) { const v = s.b[L[0]]; if (v && v === s.b[L[1]] && v === s.b[L[2]] && v === s.b[L[3]]) return { p: v, line: L }; } return null; };
  const evaluate = (s, me) => {
    let sc = 0;
    for (const L of LINES) { let a = 0, b = 0; for (let k = 0; k < 4; k++) { const v = s.b[L[k]]; if (v === me) a++; else if (v) b++; } if (a && b) continue; if (a === 3) sc += 40; else if (a === 2) sc += 6; else if (b === 3) sc -= 48; else if (b === 2) sc -= 6; }
    for (let r = 0; r < R; r++) { const v = s.b[idx(r, 3)]; if (v === me) sc += 5; else if (v) sc -= 5; }
    return sc;
  };
  const ORDER = [3, 2, 4, 1, 5, 0, 6], WIN = 100000;
  let nodes = 0, budget = 0;
  const negamax = (s, depth, alpha, beta) => {
    nodes++;
    const w = winAt(s, s.last); if (w) return -(WIN + depth);
    if (s.n >= 42) return 0;
    if (depth <= 0) return evaluate(s, s.turn);
    let best = -1e9;
    for (const c of ORDER) {
      const last = s.last, r = drop(s, c); if (r < 0) continue;
      const v = -negamax(s, depth - 1, -beta, -alpha); undrop(s, c, r, last);
      if (v > best) best = v; if (v > alpha) alpha = v;
      if (alpha >= beta || nodes > budget) break;
    }
    return best;
  };
  const LEVELS = { principiante: { d: 1, noise: 40, budget: 5000 }, clube: { d: 3, noise: 20, budget: 40000 }, avancado: { d: 5, noise: 0, budget: 150000 }, mestre: { d: 7, noise: 0, budget: 500000 }, gm: { d: 9, noise: 0, budget: 1200000 } };
  const normLevel = v => ({ facil: 'clube', medio: 'avancado', dificil: 'mestre' }[v] || (LEVELS[v] ? v : 'clube'));
  async function think(s, level, o) {
    o = o || {}; const cfg = LEVELS[normLevel(level)] || LEVELS.clube;
    const cols = ORDER.filter(c => rowFor(s, c) >= 0); if (!cols.length) return -1; if (cols.length === 1) return cols[0];
    nodes = 0; budget = o.budget || cfg.budget;
    const wide = !!cfg.noise && !o.exact;   /* notas exatas na raiz quando há ruído (ver o xadrez) */
    let best = cols[0], scores = null, slice = performance.now();
    for (let d = 1; d <= cfg.d; d++) {
      let alpha = -1e9, bd = cols[0], stopped = false; const sc = [];
      const ord = cols.slice(); const bi = ord.indexOf(best); if (bi > 0) { ord.splice(bi, 1); ord.unshift(best); }
      for (const c of ord) {
        const last = s.last, r = drop(s, c);
        const v = -negamax(s, d - 1, -1e9, wide ? 1e9 : -alpha); undrop(s, c, r, last);
        sc.push({ c, v }); if (v > alpha) { alpha = v; bd = c; }
        if (nodes > budget) { stopped = sc.length < ord.length; break; }
        if (performance.now() - slice > 12) { await sleep(0); if (o.wait) await o.wait(); slice = performance.now(); if (o.cancelled && o.cancelled()) return -1; }
      }
      if (!stopped) { best = bd; scores = sc; }
      if (stopped || nodes > budget || Math.abs(alpha) >= WIN) break;
    }
    if (cfg.noise && scores && !o.exact) { const top = Math.max(...scores.map(z => z.v)); const pool = scores.filter(z => z.v >= top - cfg.noise && z.v > -WIN / 2); if (pool.length) best = pool[rnd(pool.length)].c; }
    return best;
  }
  const fromBoard = (board, turn, last) => { const s = create(); if (Array.isArray(board)) for (let i = 0; i < 42; i++) { const v = +board[i]; if (v === 1 || v === 2) { s.b[i] = v; s.n++; } } s.turn = turn === 2 ? 2 : 1; s.last = Number.isInteger(last) && last >= 0 && last < 42 ? last : -1; return s; };
  return { create, drop, undrop, rowFor, winner, winAt, think, evaluate, fromBoard, R, C, idx, LEVELS, normLevel };
})();

COVER.c4 = () => `<svg viewBox="0 0 400 200" preserveAspectRatio="xMidYMid slice" class="gbd-cv"><defs><linearGradient id="gbcC41" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#0B1D4F"/><stop offset="1" stop-color="#040A1F"/></linearGradient><linearGradient id="gbcC42" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#3D7BFF"/><stop offset="1" stop-color="#1A47B8"/></linearGradient><radialGradient id="gbcC43" cx=".35" cy=".3"><stop offset="0" stop-color="#FF8A7A"/><stop offset=".65" stop-color="#E8322A"/><stop offset="1" stop-color="#9A1510"/></radialGradient><radialGradient id="gbcC44" cx=".35" cy=".3"><stop offset="0" stop-color="#FFF0A0"/><stop offset=".65" stop-color="#FFC400"/><stop offset="1" stop-color="#B07A00"/></radialGradient><radialGradient id="gbcC45" cx=".5" cy=".5"><stop offset="0" stop-color="#050B22"/><stop offset=".85" stop-color="#0A1640"/><stop offset="1" stop-color="#2A5BDA"/></radialGradient></defs><rect width="400" height="200" fill="url(#gbcC41)"/><rect x="60" y="22" width="280" height="200" rx="18" fill="url(#gbcC42)"/><rect x="62" y="24" width="276" height="6" rx="3" fill="#fff" opacity=".25"/>${[0, 1, 2, 3].map(r => [0, 1, 2, 3, 4, 5, 6].map(c => { const pick = { '3,0': 1, '3,1': 2, '3,2': 1, '3,3': 2, '2,2': 2, '2,3': 1, '1,3': 2, '2,4': 1, '3,4': 1, '0,3': 2, '2,1': 1, '3,5': 2 }[r + ',' + c]; const x = 80 + c * 38 + 16, y = 44 + r * 38 + 16; return `<circle cx="${x}" cy="${y}" r="15" fill="url(#gbcC45)"/>` + (pick ? `<circle cx="${x}" cy="${y + 2}" r="13" fill="${pick === 1 ? '#8A110C' : '#8E6200'}"/><circle cx="${x}" cy="${y}" r="13" fill="url(#gbcC4${pick === 1 ? 3 : 4})"/>` : ''); }).join('')).join('')}</svg>`;
Icons.app.c4 = () => Icons.SVG(Icons.G('gC4', '#5CB4FF', '#2070E0', '#123A9E') + Icons.GL(
  `<rect x="16" y="20" width="68" height="66" rx="12" fill="#0A1A4C" opacity=".55"/><rect x="16" y="20" width="68" height="66" rx="12" fill="#2E73F0"/><rect x="18" y="22" width="64" height="4" rx="2" fill="#fff" opacity=".3"/>` +
  [[0, 0, 0, 0], [0, 2, 0, 0], [0, 1, 2, 0], [1, 2, 1, 2]].map((row, r) => row.map((v, c) => { const cx = 29 + c * 14.2, cy = 34 + r * 14.6; return `<circle cx="${cx}" cy="${cy}" r="5.6" fill="#071235"/>` + (v ? `<circle cx="${cx}" cy="${cy + .8}" r="5" fill="${v === 1 ? '#8A110C' : '#8E6200'}"/><circle cx="${cx}" cy="${cy}" r="5" fill="${v === 1 ? '#FF4A3C' : '#FFCF1A'}"/><circle cx="${cx - 1.6}" cy="${cy - 1.8}" r="1.6" fill="#fff" opacity=".55"/>` : ''); }).join('')).join('')));

Arcade.game('c4', {
  name: 'Quatro em Linha', color: '#2070E0', kind: 'board', unit: 'vitórias', scoreLabel: 'Vitórias', mp: true, tags: ['Rápido', 'Online'],
  desc: 'Deixa cair os discos e alinha quatro. Moldura vidrada, pré-visualização ao tocar, série de partidas, Desfazer e cinco adversários. Dois jogadores no mesmo telemóvel ou online.',
  cover: () => COVER.c4(),
  howto: { goal: 'Alinha quatro discos da tua cor na horizontal, na vertical ou na diagonal.', steps: ['Toca numa coluna e larga para deixar cair o disco', 'Enquanto tocas vês onde o disco vai ficar', 'As vermelhas começam; quem começa alterna na série', 'Desfazer anula a tua jogada e a do telemóvel'], controls: [{ icon: 'hand', label: 'Toca na coluna e larga' }, { icon: 'grid', label: 'Setas e Enter, ou teclas 1 a 7' }, { icon: 'arrowL', label: 'U desfaz' }] },
  modes: [{ key: 'ia', label: 'Contra o telemóvel' }, { key: 'local', label: 'Dois jogadores' }, { key: 'online', label: 'Online' }],
  build(win) {
    const C4 = ENG.c4, GAME = 'c4', CELL = 54, TOP = 54;
    const LVL = [
      { v: 'principiante', label: 'Principiante', name: 'Lia', face: 'kid', color: '#FFD60A' },
      { v: 'clube', label: 'Clube', name: 'Rui', face: 'young', color: '#5EE39A' },
      { v: 'avancado', label: 'Avançado', name: 'Dr. Nunes', face: 'glasses', color: '#5CB4FF' },
      { v: 'mestre', label: 'Mestre', name: 'Marta', face: 'bun', color: '#FF9F0A' },
      { v: 'gm', label: 'Grande Mestre', name: 'Unidade 7', face: 'robot', color: '#FF375F' },
    ];
    const A = Arcade.shell(win, { id: GAME, name: 'Quatro em Linha', color: '#2070E0', pausable: false, scoreLabel: 'Vitórias', bestLabel: 'Recorde', onRestart: () => restart() });
    const x = X(A), stage = A.el.stage;
    const wrap = el(`<div class="gc4-wrap gbd-hide">${playerCard('top p2', 'Amarelas', '')}<div class="gc4-series"><b class="a" data-noi18n>0</b><span>série</span><b class="b" data-noi18n>0</b></div>
      <div class="gc4-board"><div class="gc4-ghost"><div class="gc4-dc p1"></div></div><div class="gc4-frame"></div><div class="gc4-discs"></div><div class="gc4-wins"></div><div class="gc4-cols">${[0, 1, 2, 3, 4, 5, 6].map(c => `<div class="gc4-col" data-c="${c}"></div>`).join('')}</div></div>${playerCard('bot p1', 'Vermelhas', '')}</div>`);
    stage.appendChild(wrap);
    const discs = wrap.querySelector('.gc4-discs'), wins = wrap.querySelector('.gc4-wins'), ghost = wrap.querySelector('.gc4-ghost'), ghostDisc = ghost.firstElementChild, card = { 1: wrap.querySelector('.gbd-pl.bot'), 2: wrap.querySelector('.gbd-pl.top') }, cols = [...wrap.querySelectorAll('.gc4-col')], colsEl = wrap.querySelector('.gc4-cols'), serA = wrap.querySelector('.gc4-series .a'), serB = wrap.querySelector('.gc4-series .b');
    A.el.ctl.innerHTML = `<div class="gm-row wide gbd-tools">${tool('undo', 'arrowL', 'Desfazer', true)}${tool('modes', 'grid', 'Modos', false)}${tool('resign', 'flag', 'Desistir', true)}</div>`;
    const bUndo = A.el.ctl.querySelector('.undo'), bModes = A.el.ctl.querySelector('.modes'), bResign = A.el.ctl.querySelector('.resign');

    let s = null, mode = null, level = C4.normLevel(Arcade.opt('c4:lv', 'clube')), me = 1, over = true, busy = false, paused = false, gen = 0, link = null, els = {}, curCol = -1, plies = [], series = { 1: 0, 2: 0 }, starter = 1, games = 0, chrono = Chrono(win, () => {});
    const lv = () => oppOf(LVL, level);
    const oppName = () => (link ? link.name : mode === 'ia' ? lv().name : 'Adversário');
    const mid = html => { if (mode !== 'online') A.setMid(html); };
    const nameOf = p => (mode === 'online' ? (p === me ? myName() : oppName()) : mode === 'ia' ? (p === me ? myName() : lv().name) : (p === 1 ? 'Vermelhas' : 'Amarelas'));
    const avOf = p => (mode === 'local' ? g('person', 18) : mode === 'ia' ? (p === me ? myAvatar() : portrait(lv().face, lv().color, 34)) : (p === me ? myAvatar() : avatarOf(oppName())));
    const names = () => { [1, 2].forEach(p => setCard(card[p], nameOf(p), (p === 1 ? 'Vermelhas' : 'Amarelas') + (mode === 'ia' && p !== me ? ' · ' + lv().label : ''), avOf(p))); wrap.querySelector('.gc4-series').classList.toggle('gbd-hide', mode === 'online'); };
    const human = () => !over && !busy && (mode === 'local' || s.turn === me);
    const showGhost = c => { curCol = c; if (c < 0 || !human() || C4.rowFor(s, c) < 0) { ghost.classList.remove('on'); cols.forEach(e => e.classList.remove('cur')); return; } ghostDisc.className = 'gc4-dc p' + s.turn; ghost.style.transform = `translate(${c * CELL}px, 0)`; ghost.classList.add('on'); cols.forEach((e, i) => e.classList.toggle('cur', i === c)); };
    const paint = () => {
      [1, 2].forEach(p => card[p].classList.toggle('on', !over && s.turn === p));
      serA.textContent = series[1]; serB.textContent = series[2];
      let h = ''; if (!over) h = mode === 'local' ? `Vez das ${s.turn === 1 ? 'vermelhas' : 'amarelas'}` : s.turn === me ? 'A tua vez' : `${oppName()} está a pensar`;
      mid(h ? `<span class="gm-hint">${esc(h)}</span>` : ''); bResign.classList.toggle('off', over || mode === 'local');
      bUndo.classList.toggle('off', mode !== 'ia' || over || busy || plies.length < 2);
      if (!human()) showGhost(-1);
    };
    const addDisc = (i, p, anim) => {
      const r = (i / 7) | 0, c = i % 7, d = el(`<div class="gc4-d"><div class="gc4-dc p${p}"></div></div>`);
      const yEnd = TOP + r * CELL;
      d.style.transform = `translate(${c * CELL}px, ${anim ? -12 : yEnd}px)`; discs.appendChild(d); els[i] = d;   /* nasce onde estava a pré-visualização */
      if (anim) {
        const ms = Math.round(150 + Math.sqrt(r + 1) * 95); d.style.transitionDuration = ms + 'ms'; void d.offsetWidth;
        d.style.transform = `translate(${c * CELL}px, ${yEnd}px)`;
        const t = setTimeout(() => { const dc = d.firstElementChild; dc.classList.add('land'); x.sfx('bounce'); }, ms); win.timers.push(t);
      }
    };
    const sync = () => { discs.innerHTML = ''; wins.innerHTML = ''; els = {}; discs.classList.remove('ended'); for (let i = 0; i < 42; i++) if (s.b[i]) addDisc(i, s.b[i], false); };
    /* os quatro vencedores: os discos estão por trás da moldura, por isso o anel vive numa camada por cima dela */
    const markLine = line => { if (!line) return; discs.classList.add('ended'); line.forEach((i, k) => { const e = els[i]; if (e) e.classList.add('won'); const r = (i / 7) | 0, c = i % 7, ring = el(`<div class="gc4-ring"><i style="--d:${k * 90}ms"></i></div>`); ring.style.transform = `translate(${c * CELL}px, ${TOP + r * CELL}px)`; wins.appendChild(ring); }); };
    const stats = () => [{ label: 'Lances', value: String(s.n) }, { label: 'Série', value: `${series[1]} : ${series[2]}` }, { label: 'Tempo', value: fmtT(chrono.secs()) }];
    const finish = (why, winner, line, cur2) => {
      if (over) return; over = true; busy = false; gen++; chrono.stop(); showGhost(-1);
      markLine(line); games++;
      const iWon = mode !== 'local' && winner === me;
      let title = winner ? 'Quatro em linha!' : 'Empate', sub = winner ? '' : 'Tabuleiro cheio';
      if (why === 'resign') title = 'Desistência'; if (why === 'left') title = 'O adversário saiu'; if (why === 'timeout') title = 'Tempo esgotado';
      if (winner && mode !== 'online') series[winner]++;
      if (winner) {
        if (mode === 'local') sub = winner === 1 ? 'As vermelhas ganham' : 'As amarelas ganham';
        else if (iWon) { sub = 'Ganhaste'; if (mode === 'ia') { const n = addWin('c4:' + level); A.setScore(n); sub = `Venceste ${lv().name} · ${plural(n, 'vitória', 'vitórias')}`; if (level === 'gm') flagAch('c4WinHard'); } else A.setScore(addWin('c4:online')); }
        else sub = mode === 'ia' ? `${lv().name} ganhou` : `${oppName()} ganhou`;
      }
      if (mode === 'online' && cur2 && link) sub = mpWhy(cur2, link) || sub;
      paint(); x.sfx(winner ? (iWon || mode === 'local' ? 'win' : 'lose') : 'tick'); if (winner && (iWon || mode === 'local')) { x.flash('Quatro em linha!', 'big'); x.celebrate('win'); }
      if (link) link.destroy();
      const win_ = mode === 'local' ? !!winner : (winner ? iWon : undefined), st = stats();
      const tm = setTimeout(() => { if (mode === 'online') mpEnd(x, GAME, title, sub, win_, st); else x.end({ title, sub, score: null, submit: false, win: win_, stats: st }); link = null; }, 1100); win.timers.push(tm);
    };
    const settle = () => {
      if (mode !== 'online') { const w = C4.winAt(s, s.last); if (w) { finish('board', w.p, w.line); return; } if (s.n >= 42) { finish('board', 0); return; } }
      paint(); if (mode === 'ia' && s.turn !== me) aiTurn();
    };
    const play = (c, fromNet) => {
      const r = C4.rowFor(s, c); if (r < 0) return false;
      const p = s.turn, last = s.last; C4.drop(s, c); plies.push({ c, r, last }); addDisc(C4.idx(r, c), p, true); x.sfx('slide'); showGhost(-1);
      if (mode === 'online' && !fromNet && link) link.send({ col: c }).then(res => { if (res && res.error && !over) { UI.toast(res.error === 'turn' ? 'Não é a tua vez' : 'Jogada recusada pelo servidor'); resync(); } });
      busy = true; paint(); const tm = setTimeout(() => { busy = false; settle(); }, 180 + Math.sqrt(r + 1) * 95); win.timers.push(tm); return true;
    };
    const resync = async () => { if (!link || over) return; const r = await Arcade.match.state({ id: link.m.id }); if (!r || r.error || over) return; fromNet(r); sync(); paint(); };
    const fromNet = cur2 => { const st = Online.parse(cur2.state) || {}; s = C4.fromBoard(st.board, cur2.turn === 'b' ? 2 : 1, cur2.last); plies = []; };
    const aiTurn = async () => {
      busy = true; paint(); const my = ++gen; await sleep(360);
      const c = await C4.think(s, level, { cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return; busy = false; if (c >= 0) play(c); else settle();
    };
    const tap = c => { if (!s || !human() || paused) return; if (C4.rowFor(s, c) < 0) { x.sfx('fail'); x.haptic('light'); return; } play(c); };
    /* toque: ao premir vê-se o disco em cima da coluna; ao largar cai (rato: também ao passar) */
    const colOf = e => { const c = e.target && e.target.closest ? e.target.closest('.gc4-col') : null; return c ? +c.dataset.c : -1; };
    colsEl.addEventListener('pointerdown', e => { const c = colOf(e); if (c >= 0 && human()) { showGhost(c); } });
    colsEl.addEventListener('pointermove', e => { const c = colOf(e); if (c >= 0 && c !== curCol && human()) showGhost(c); });
    colsEl.addEventListener('pointerup', e => { const c = colOf(e); if (c >= 0) tap(c); else showGhost(-1); });
    colsEl.addEventListener('pointerleave', () => showGhost(-1));
    colsEl.addEventListener('pointercancel', () => showGhost(-1));
    const begin = () => { over = false; busy = false; gen++; plies = []; chrono.reset(); chrono.start(); wrap.classList.remove('gbd-hide'); names(); sync(); settle(); };
    const onOpp = (cur2, st) => {
      if (over || !s) return;
      const b = st && st.board, i = cur2.last;
      if (Array.isArray(b) && Number.isInteger(i) && i >= 0 && i < 42 && !s.b[i] && (b[i] === 1 || b[i] === 2)) { s.b[i] = b[i]; s.n++; s.last = i; addDisc(i, b[i], true); x.sfx('slide'); }
      else { fromNet(cur2); sync(); }
      s.turn = me; paint();
    };
    const onEnd = cur2 => {
      if (over) return;
      const st = Online.parse(cur2.state) || {}, b = Array.isArray(st.board) ? st.board : null;
      if (b) for (let i = 0; i < 42; i++) { const v = b[i] === 1 || b[i] === 2 ? b[i] : 0; if (v && !s.b[i]) { s.b[i] = v; s.n++; s.last = i; addDisc(i, v, true); } }
      const w = C4.winner(s), wn = cur2.winner === 'a' ? 1 : cur2.winner === 'b' ? 2 : 0;
      finish(cur2.reason === 'timeout' ? 'timeout' : cur2.reason === 'left' ? 'left' : 'board', wn, w ? w.line : null, cur2);
    };
    const startOnline = m => { mode = 'online'; me = m.you === 'b' ? 2 : 1; link = Online.join(A, m, { onOpp, onEnd }); fromNet(m); A.setScore(winsOf('c4:online')); begin(); if (m.ended) onEnd(m); };
    const start = ch => { if (!ch) return; if (ch.mode === 'online') { startOnline(ch.m); return; } if (ch.mode !== mode || ch.level !== level) { series = { 1: 0, 2: 0 }; starter = 1; games = 0; } mode = ch.mode; level = C4.normLevel(ch.level || level); me = 1; s = C4.create(); s.turn = starter; A.setScore(mode === 'ia' ? winsOf('c4:' + level) : 0); begin(); };
    const toLobby = async () => { gen++; chrono.stop(); if (link) { link.destroy(); link = null; } over = true; wrap.classList.add('gbd-hide'); A.setMid(''); bResign.classList.add('off'); bUndo.classList.add('off'); series = { 1: 0, 2: 0 }; starter = 1; games = 0; mode = null; start(await lobby(A, { game: GAME, name: 'Quatro em Linha', tagline: 'Moldura vidrada, série de partidas, cinco adversários', cover: COVER.c4, levels: LVL, level })); };
    /* "Jogar outra vez" continua a série: quem começa alterna */
    const restart = () => { if (mode === 'online' || !mode) toLobby(); else { gen++; starter = 3 - starter; start({ mode, level }); } };
    bModes.onclick = async () => {
      if (!over && mode === 'online') { if (!await UI.confirm('Sair da partida', 'Sais da partida online e conta como derrota.', 'Sair', true)) return; if (link) link.leave(); }
      else if (!over && mode === 'ia' && s.n && !await UI.confirm('Mudar de modo', 'Perdes a partida e a série atual.', 'Mudar', true)) return;
      toLobby();
    };
    bResign.onclick = async () => { if (over || mode === 'local') return; if (!await UI.confirm('Desistir', 'Dás a partida como perdida.', 'Desistir', true)) return; if (link) link.leave(); finish('resign', 3 - me); };
    bUndo.onclick = () => {
      if (bUndo.classList.contains('off') || mode !== 'ia' || busy || over || plies.length < 2) return;
      let n = 0; while (plies.length && (n < 2 || s.turn !== me)) { const z = plies.pop(); const i = C4.idx(z.r, z.c); C4.undrop(s, z.c, z.r, z.last); const e = els[i]; if (e) { delete els[i]; e.firstElementChild.classList.add('gone'); const tm = setTimeout(() => e.remove(), 260); win.timers.push(tm); } n++; }
      x.haptic('light'); paint();
    };
    (async () => { await x.ready('Quatro em Linha', 'Toca na coluna, larga e vê o disco cair'); const pm = Online.takePending(GAME); if (pm) startOnline(pm); else toLobby(); })();
    win.onClose = () => { gen++; chrono.stop(); if (link) link.destroy(); };
    const api = { pause() { paused = true; chrono.stop(); }, resume() { paused = false; if (!over && s) chrono.start(); },
      key(e) { const k = e.key; if (/^[1-7]$/.test(k)) { e.preventDefault(); tap(+k - 1); return; } if (k === 'u' || k === 'U') { bUndo.click(); return; } if (k === 'ArrowLeft' || k === 'a' || k === 'A') { e.preventDefault(); showGhost(curCol < 0 ? 3 : Math.max(0, curCol - 1)); } else if (k === 'ArrowRight' || k === 'd' || k === 'D') { e.preventDefault(); showGhost(curCol < 0 ? 3 : Math.min(6, curCol + 1)); } else if ((k === 'Enter' || k === ' ' || k === 'ArrowDown' || k === 's' || k === 'S') && curCol >= 0) { e.preventDefault(); tap(curCol); } },
      test: { get s() { return s; }, tap, start: ch => { closeLobby(stage); start(ch); }, get over() { return over; }, get mode() { return mode; }, get series() { return series; }, ghost: showGhost, C4 } };
    LIVE.game = api; return api;
  },
});

/* =====================================================================
   JOGO DO GALO: IA (fácil, médio, imbatível), melhor de cinco, quadro de giz com marcas desenhadas;
   online uma partida de cada vez (o servidor valida { cell }). Modo NOVO Ultimate: nove tabuleiros
   3×3, a casa onde jogas manda o adversário para o tabuleiro com o mesmo lugar (regra do envio);
   tabuleiro ganho ou cheio = jogada livre. IA com minimax limitado e pensado por pedaços.
   ===================================================================== */
ENG.ttt = (() => {
  const LINES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
  const create = () => ({ b: new Int8Array(9), turn: 1, n: 0 });
  const winner = s => { for (const L of LINES) { const v = s.b[L[0]]; if (v && v === s.b[L[1]] && v === s.b[L[2]]) return { p: v, line: L }; } return null; };
  const put = (s, i) => { if (i < 0 || i > 8 || s.b[i]) return false; s.b[i] = s.turn; s.n++; s.turn = 3 - s.turn; return true; };
  const minimax = s => { const w = winner(s); if (w) return -10 + s.n; if (s.n >= 9) return 0; let best = -100; for (let i = 0; i < 9; i++) { if (s.b[i]) continue; s.b[i] = s.turn; s.n++; s.turn = 3 - s.turn; const v = -minimax(s); s.turn = 3 - s.turn; s.n--; s.b[i] = 0; if (v > best) best = v; } return best; };
  const best = s => { let top = -100, pool = []; for (let i = 0; i < 9; i++) { if (s.b[i]) continue; s.b[i] = s.turn; s.n++; s.turn = 3 - s.turn; const v = -minimax(s); s.turn = 3 - s.turn; s.n--; s.b[i] = 0; if (v > top) { top = v; pool = [i]; } else if (v === top) pool.push(i); } return pool.length ? pool[rnd(pool.length)] : -1; };
  const easy = s => { const free = []; for (let i = 0; i < 9; i++) if (!s.b[i]) free.push(i); if (!free.length) return -1; if (Math.random() < .45) return free[rnd(free.length)]; const me = s.turn; for (const p of [me, 3 - me]) for (const L of LINES) { const vs = L.map(i => s.b[i]); if (vs.filter(v => v === p).length === 2 && vs.includes(0)) return L[vs.indexOf(0)]; } return free[rnd(free.length)]; };
  const medium = s => (Math.random() < .62 ? best(s) : easy(s));
  const fromBoard = (board, turn) => { const s = create(); if (Array.isArray(board)) for (let i = 0; i < 9; i++) { const v = +board[i]; if (v === 1 || v === 2) { s.b[i] = v; s.n++; } } s.turn = turn === 2 ? 2 : 1; return s; };

  /* ---------- Ultimate: casa = tabuleiro * 9 + lugar ---------- */
  const smallWin = (b, k) => { const o = k * 9; for (const L of LINES) { const v = b[o + L[0]]; if (v && v === b[o + L[1]] && v === b[o + L[2]]) return v; } for (let i = 0; i < 9; i++) if (!b[o + i]) return 0; return 3; };
  const bigWin = w => { for (const L of LINES) { const v = w[L[0]]; if ((v === 1 || v === 2) && v === w[L[1]] && v === w[L[2]]) return { p: v, line: L }; } return null; };
  const uCreate = () => ({ b: new Int8Array(81), w: new Int8Array(9), turn: 1, next: -1, n: 0, last: -1, stack: [] });
  const uMoves = s => {
    const out = [];
    if (bigWin(s.w)) return out;
    if (s.next >= 0 && !s.w[s.next]) { const o = s.next * 9; for (let i = 0; i < 9; i++) if (!s.b[o + i]) out.push(o + i); return out; }
    for (let k = 0; k < 9; k++) { if (s.w[k]) continue; const o = k * 9; for (let i = 0; i < 9; i++) if (!s.b[o + i]) out.push(o + i); }
    return out;
  };
  const uPlay = (s, i) => {
    const k = (i / 9) | 0, c = i % 9;
    s.stack.push({ i, wk: s.w[k], next: s.next, last: s.last });
    s.b[i] = s.turn; s.w[k] = smallWin(s.b, k);
    s.next = s.w[c] ? -1 : c; s.last = i; s.n++; s.turn = 3 - s.turn;
  };
  const uUndo = s => { const u = s.stack.pop(); if (!u) return; const k = (u.i / 9) | 0; s.b[u.i] = 0; s.w[k] = u.wk; s.next = u.next; s.last = u.last; s.n--; s.turn = 3 - s.turn; };
  /* 'play' | 'win' | 'draw' */
  const uStatus = s => { const w = bigWin(s.w); if (w) return { st: 'win', p: w.p, line: w.line }; if (!uMoves(s).length) return { st: 'draw' }; return { st: 'play' }; };
  /* peso posicional: canto 3, lado 2, centro 4 */
  const POS = [3, 2, 3, 2, 4, 2, 3, 2, 3];
  const uEval = (s, me) => {
    const op = 3 - me, w = s.w; let sc = 0;
    for (const L of LINES) {
      let a = 0, o = 0, dead = false; for (const k of L) { const v = w[k]; if (v === me) a++; else if (v === op) o++; else if (v === 3) dead = true; }
      if (dead || (a && o)) continue; if (a === 2) sc += 300; else if (a === 1) sc += 40; if (o === 2) sc -= 300; else if (o === 1) sc -= 40;
    }
    for (let k = 0; k < 9; k++) {
      const v = w[k];
      if (v === me) { sc += 120 + POS[k] * 25; continue; } if (v === op) { sc -= 120 + POS[k] * 25; continue; } if (v) continue;
      const off = k * 9;
      for (const L of LINES) { let a = 0, o = 0; for (const c of L) { const x = s.b[off + c]; if (x === me) a++; else if (x === op) o++; } if (a && o) continue; if (a === 2) sc += 12 * POS[k] / 2; else if (a === 1) sc += 1; if (o === 2) sc -= 12 * POS[k] / 2; else if (o === 1) sc -= 1; }
      if (s.b[off + 4] === me) sc += 3; else if (s.b[off + 4] === op) sc -= 3;
    }
    /* mandar o adversário para uma jogada livre é mau */
    if (s.next < 0 && s.n > 0) sc += s.turn === me ? 25 : -25;
    return sc;
  };
  const UWIN = 1e6;
  let unodes = 0, ubudget = 0;
  const uOrder = (s, ms) => ms.map(i => { const c = i % 9; let k = POS[c]; if (s.w[c]) k -= 6; return { i, k }; }).sort((a, b) => b.k - a.k).map(z => z.i);
  const uNeg = (s, d, alpha, beta) => {
    unodes++;
    const w = bigWin(s.w); if (w) return w.p === s.turn ? UWIN + d : -(UWIN + d);
    const ms = uMoves(s); if (!ms.length) return 0;
    if (d <= 0 || unodes > ubudget) return uEval(s, s.turn);
    let bestV = -Infinity;
    for (const i of uOrder(s, ms)) { uPlay(s, i); const v = -uNeg(s, d - 1, -beta, -alpha); uUndo(s); if (v > bestV) bestV = v; if (v > alpha) alpha = v; if (alpha >= beta || unodes > ubudget) break; }
    return bestV;
  };
  const ULEVELS = { facil: { d: 2, noise: 260, budget: 8000 }, medio: { d: 3, noise: 40, budget: 40000 }, dificil: { d: 5, noise: 0, budget: 180000 } };
  async function uThink(s, level, o) {
    o = o || {}; const cfg = ULEVELS[level] || ULEVELS.medio;
    const root = uOrder(s, uMoves(s)); if (!root.length) return -1; if (root.length === 1) return root[0];
    unodes = 0; ubudget = cfg.budget; let bestM = root[0], scores = null, slice = performance.now();
    const wide = !!cfg.noise;   /* notas exatas na raiz quando há ruído: um erro grave nunca parece quase tão bom como a melhor */
    for (let d = 1; d <= cfg.d; d++) {
      let alpha = -Infinity, bd = root[0], stopped = false; const sc = [];
      const ord = root.slice(); const bi = ord.indexOf(bestM); if (bi > 0) { ord.splice(bi, 1); ord.unshift(bestM); }
      for (const i of ord) {
        uPlay(s, i); const v = -uNeg(s, d - 1, -Infinity, wide ? Infinity : -alpha); uUndo(s);
        sc.push({ i, v }); if (v > alpha) { alpha = v; bd = i; }
        if (unodes > ubudget) { stopped = sc.length < ord.length; break; }
        if (performance.now() - slice > 12) { await sleep(0); if (o.wait) await o.wait(); slice = performance.now(); if (o.cancelled && o.cancelled()) return -1; }
      }
      if (!stopped) { bestM = bd; scores = sc; } else if (sc.length) { const top = sc.reduce((a, z) => (z.v > a.v ? z : a), sc[0]); if (top.v > UWIN / 2) bestM = top.i; }
      if (stopped || Math.abs(alpha) >= UWIN) break;
    }
    if (cfg.noise && scores) { const top = Math.max(...scores.map(z => z.v)); const pool = scores.filter(z => z.v >= top - cfg.noise && z.v > -UWIN / 2); if (pool.length) bestM = pool[rnd(pool.length)].i; }
    return bestM;
  }
  const ult = { create: uCreate, moves: uMoves, play: uPlay, undo: uUndo, status: uStatus, think: uThink, bigWin, smallWin, evaluate: uEval, LEVELS: ULEVELS };
  return { create, winner, put, best, easy, medium, fromBoard, LINES, ult };
})();

/* marcas a giz (viewBox 100): duas passagens de traço para dar textura; crescem por transform */
const TT_MARK = {
  1: `<svg viewBox="0 0 100 100" class="gtt-mk x"><path class="s1" d="M28 27Q50 48 73 74"/><path class="s2" d="M73 27Q51 51 27 73"/><path class="g1" d="M30 29Q50 48 71 72"/><path class="g2" d="M71 29Q51 51 29 71"/></svg>`,
  2: `<svg viewBox="0 0 100 100" class="gtt-mk o"><path class="s1" d="M51 25C66 25 76 36 76 50C76 65 64 76 49 76C34 76 24 64 24 50C24 36 35 26 53 27"/><path class="g1" d="M51 28C64 28 73 38 73 50C73 63 63 73 49 73C36 73 27 63 27 50"/></svg>`,
};
/* traços do quadro de giz (desenhados à mão, um pouco tortos) */
const TT_GRID = `<svg viewBox="0 0 336 336" class="gtt-grid" aria-hidden="true"><path d="M113 10C111 120 115 220 112 326M224 12C226 118 222 224 225 324M10 113C120 110 224 116 326 112M12 224C118 227 222 221 324 225"/><path class="g" d="M115 14C113 120 117 220 114 322M226 16C228 118 224 224 227 320M14 115C120 112 224 118 322 114M16 226C118 229 222 223 320 227"/></svg>`;
COVER.ttt = () => `<svg viewBox="0 0 400 200" preserveAspectRatio="xMidYMid slice" class="gbd-cv"><defs><linearGradient id="gbcTt1" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#2F4A3E"/><stop offset="1" stop-color="#14231C"/></linearGradient><radialGradient id="gbcTt2" cx=".5" cy=".4"><stop offset="0" stop-color="#fff" stop-opacity=".1"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient><linearGradient id="gbcTt3" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#9A6A3C"/><stop offset="1" stop-color="#5A3518"/></linearGradient></defs><rect width="400" height="200" fill="url(#gbcTt3)"/><rect x="10" y="10" width="380" height="180" rx="8" fill="url(#gbcTt1)"/><rect x="10" y="10" width="380" height="180" rx="8" fill="url(#gbcTt2)"/><g fill="none" stroke="#EDEDE4" stroke-width="5" stroke-linecap="round" opacity=".85"><path d="M168 30C166 90 170 140 167 176M232 28C234 88 230 142 233 174M110 77C170 74 230 80 290 76M112 130C170 133 232 127 288 131"/></g><g fill="none" stroke-linecap="round" stroke-width="10"><path d="M124 36Q138 52 154 68M154 36Q139 53 123 69" stroke="#FFB27A"/><path d="M200 82C214 82 222 92 222 103C222 116 212 124 199 124C186 124 177 115 177 103C177 92 186 83 202 84" stroke="#8FD3FF"/><path d="M246 140Q262 154 276 170M276 140Q261 156 245 171" stroke="#FFB27A"/><path d="M200 140C212 140 220 148 220 157C220 167 212 173 201 173C190 173 182 166 182 157C182 148 190 141 203 142" stroke="#8FD3FF" opacity=".9"/></g><path d="M118 52Q200 106 282 158" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".35"/><rect x="40" y="168" width="60" height="9" rx="3" fill="#F4F1E6" opacity=".9" transform="rotate(-8 70 172)"/></svg>`;
Icons.app.ttt = () => Icons.SVG(Icons.G('gTt', '#FFB36B', '#FF7A1A', '#B84A05') + Icons.GL(
  `<rect x="13" y="13" width="74" height="74" rx="14" fill="#2B4A3C"/><rect x="13" y="13" width="74" height="74" rx="14" fill="none" stroke="#8A5A2E" stroke-width="4"/>` +
  `<path d="M38 20C37 45 39 64 37 80M62 20C63 45 61 64 63 80M20 38C45 37 64 39 80 37M20 62C45 63 64 61 80 63" stroke="#F1EFE6" stroke-width="3.6" stroke-linecap="round" fill="none" opacity=".9"/>` +
  `<path d="M21 21L33 33M33 21L21 33" stroke="#FFB27A" stroke-width="5" stroke-linecap="round"/><circle cx="50" cy="50" r="7" fill="none" stroke="#8FD3FF" stroke-width="5"/><path d="M67 67L79 79M79 67L67 79" stroke="#FFB27A" stroke-width="5" stroke-linecap="round"/><path d="M19 81L81 19" stroke="#fff" stroke-width="3" stroke-linecap="round" opacity=".55"/>`));

Arcade.game('ttt', {
  name: 'Jogo do Galo', color: '#FF7A1A', kind: 'board', unit: 'vitórias', scoreLabel: 'Vitórias', mp: true, tags: ['Rápido', 'Novo: Ultimate'],
  desc: 'O clássico num quadro de giz: melhor de cinco contra o telemóvel ou com um amigo, partidas online e o modo Ultimate com nove tabuleiros e a regra do envio.',
  cover: () => COVER.ttt(),
  howto: { goal: 'Faz três em linha antes do adversário. No Ultimate, ganha três tabuleiros pequenos em linha.', steps: ['Toca numa casa vazia para desenhar a tua marca', 'A série é à melhor de cinco: ganha quem chegar a três', 'Ultimate: a casa onde jogas manda o adversário para o tabuleiro com o mesmo lugar', 'Se esse tabuleiro já acabou, a jogada é livre'], controls: [{ icon: 'hand', label: 'Toca na casa' }, { icon: 'grid', label: 'Setas ou WASD e Enter, ou teclas 1 a 9' }] },
  modes: [{ key: 'ia', label: 'Contra o telemóvel' }, { key: 'local', label: 'Dois jogadores' }, { key: 'online', label: 'Online' }, { key: 'ultimate', label: 'Ultimate' }],
  build(win) {
    const T3 = ENG.ttt, U = T3.ult, GAME = 'ttt';
    const LVL = [
      { v: 'facil', label: 'Fácil', name: 'Lia', face: 'kid', color: '#5EE39A' },
      { v: 'medio', label: 'Médio', name: 'Rui', face: 'young', color: '#5CB4FF' },
      { v: 'dificil', label: 'Imbatível', name: 'Unidade 7', face: 'robot', color: '#FF375F' },
    ];
    const A = Arcade.shell(win, { id: GAME, name: 'Jogo do Galo', color: '#FF7A1A', pausable: false, scoreLabel: 'Vitórias', bestLabel: 'Recorde', onRestart: () => restart() });
    const x = X(A), stage = A.el.stage;
    const pips = cls => `<span class="gtt-pips ${cls}"><i></i><i></i><i></i></span>`;
    const wrap = el(`<div class="gtt-wrap gbd-hide">${playerCard('top p2', 'Círculos', '')}
      <div class="gtt-score">${pips('a')}<span class="lbl">Melhor de cinco</span>${pips('b')}</div>
      <div class="gtt-slate"><div class="gtt-board">${TT_GRID}${Array.from({ length: 9 }, (_, i) => `<div class="gtt-c" data-i="${i}"></div>`).join('')}<svg class="gtt-win" viewBox="0 0 336 336"><path/></svg></div>
        <div class="gtt-ult">${Array.from({ length: 9 }, (_, k) => `<div class="gtt-sb" data-k="${k}"><svg viewBox="0 0 108 108" class="gtt-sg" aria-hidden="true"><path d="M36 5C35 40 37 70 36 103M72 5C73 40 71 70 72 103M5 36C40 35 70 37 103 36M5 72C40 73 70 71 103 72"/></svg>${Array.from({ length: 9 }, (_, c) => `<div class="gtt-uc" data-i="${k * 9 + c}"></div>`).join('')}<div class="gtt-big"></div></div>`).join('')}<svg class="gtt-win u" viewBox="0 0 336 336"><path/></svg></div></div>
      ${playerCard('bot p1', 'Cruzes', '')}</div>`);
    stage.appendChild(wrap);
    const cells = [...wrap.querySelectorAll('.gtt-c')], ucells = [...wrap.querySelectorAll('.gtt-uc')], sbs = [...wrap.querySelectorAll('.gtt-sb')];
    const card = { 1: wrap.querySelector('.gbd-pl.bot'), 2: wrap.querySelector('.gbd-pl.top') }, winC = wrap.querySelector('.gtt-board .gtt-win'), winU = wrap.querySelector('.gtt-ult .gtt-win');
    const pipA = [...wrap.querySelectorAll('.gtt-pips.a i')], pipB = [...wrap.querySelectorAll('.gtt-pips.b i')];
    A.el.ctl.innerHTML = `<div class="gm-row wide gbd-tools">${tool('undo', 'arrowL', 'Desfazer', true)}${tool('modes', 'grid', 'Modos', false)}${tool('resign', 'flag', 'Desistir', true)}</div>`;
    const bUndo = A.el.ctl.querySelector('.undo'), bModes = A.el.ctl.querySelector('.modes'), bResign = A.el.ctl.querySelector('.resign');

    let s = null, u = null, mode = null, level = Arcade.opt('ttt:lv', 'medio'), me = 1, over = true, busy = false, paused = false, gen = 0, link = null, series = { 1: 0, 2: 0 }, starter = 1, seriesOver = true, rounds = 0, draws = 0, hist = [], chrono = Chrono(win, () => {});
    if (!LVL.some(l => l.v === level)) level = 'medio';
    const lv = () => oppOf(LVL, level);
    const ultimate = () => mode === 'ultimate';
    const oppName = () => (link ? link.name : (mode === 'ia' || ultimate()) ? lv().name : 'Adversário');
    const mid = h => { if (mode !== 'online') A.setMid(h); };
    const cur = Cursor(3, 3, i => cells.forEach((c, k) => c.classList.toggle('cur', k === i)), i => tap(i));
    /* o cursor anda numa grelha visual 9×9; a casa do Ultimate é tabuleiro * 9 + lugar */
    const vis2u = i => { if (i < 0) return -1; const r = (i / 9) | 0, c = i % 9; return (((r / 3) | 0) * 3 + ((c / 3) | 0)) * 9 + (r % 3) * 3 + (c % 3); };
    const ucur = Cursor(9, 9, i => { const t = vis2u(i); ucells.forEach((c, k) => c.classList.toggle('cur', k === t)); }, i => tapU(vis2u(i)));
    const vsPhone = () => mode === 'ia' || ultimate();
    const nameOf = p => (mode === 'online' ? (p === me ? myName() : oppName()) : vsPhone() ? (p === me ? myName() : lv().name) : (p === 1 ? 'Cruzes' : 'Círculos'));
    const avOf = p => (mode === 'local' ? g('person', 18) : vsPhone() ? (p === me ? myAvatar() : portrait(lv().face, lv().color, 34)) : (p === me ? myAvatar() : avatarOf(oppName())));
    const names = () => {
      [1, 2].forEach(p => setCard(card[p], nameOf(p), (p === 1 ? 'Cruzes' : 'Círculos') + (vsPhone() && p !== me ? ' · ' + lv().label : ''), avOf(p)));
      wrap.querySelector('.gtt-score').classList.toggle('gbd-hide', mode === 'online' || ultimate());
      wrap.classList.toggle('ult', ultimate());
    };
    const paintPips = () => { pipA.forEach((p, i) => p.classList.toggle('on', i < series[1])); pipB.forEach((p, i) => p.classList.toggle('on', i < series[2])); };
    const human = () => !over && !busy && (mode === 'local' || (ultimate() ? u.turn === me : s.turn === me));
    const turnOf = () => (ultimate() ? u.turn : s.turn);
    const paint = () => {
      const t = turnOf();
      [1, 2].forEach(p => card[p].classList.toggle('on', !over && t === p));
      paintPips();
      let h = '';
      if (!over) h = mode === 'local' ? `Vez ${t === 1 ? 'das cruzes' : 'dos círculos'}` : t === me ? (ultimate() ? (u.next >= 0 && !u.w[u.next] ? 'A tua vez no tabuleiro assinalado' : 'A tua vez: jogada livre') : 'A tua vez') : `${oppName()} está a pensar`;
      else if (!seriesOver && mode !== 'online' && !ultimate()) h = 'Próxima partida';
      mid(h ? `<span class="gm-hint">${esc(h)}</span>` : '');
      bUndo.classList.toggle('off', !vsPhone() || over || busy || hist.length < 2);
      bResign.classList.toggle('off', over || mode === 'local' || (mode === 'ia' && seriesOver));
      if (ultimate()) {
        const ms = new Set(!over ? U.moves(u) : []), act = {}; ms.forEach(i => { act[(i / 9) | 0] = 1; });
        sbs.forEach((b, k) => { b.classList.toggle('act', !over && !!act[k] && human()); b.classList.toggle('wait', !over && !!act[k] && !human()); });
      }
    };
    /* marca desenhada (uma vez por casa: atualiza no sítio) */
    const mark = (cellEl, v, anim) => { const h = v ? TT_MARK[v] : ''; if (cellEl._h === h) return; cellEl._h = h; cellEl.innerHTML = h; cellEl.classList.toggle('p1', v === 1); cellEl.classList.toggle('p2', v === 2); cellEl.classList.toggle('draw', !!anim && !!v); };
    const sync = () => { cells.forEach((c, i) => mark(c, s.b[i], false)); winC.classList.remove('on'); };
    const usync = () => { ucells.forEach((c, i) => mark(c, u.b[i], false)); sbs.forEach((b, k) => paintBig(k, false)); winU.classList.remove('on'); };
    const paintBig = (k, anim) => { const v = u.w[k], b = sbs[k], big = b.querySelector('.gtt-big'); const h = v === 1 || v === 2 ? TT_MARK[v] : ''; if (big._h !== h) { big._h = h; big.innerHTML = h; big.classList.toggle('draw', !!anim); } b.classList.toggle('won', v === 1 || v === 2); b.classList.toggle('p1', v === 1); b.classList.toggle('p2', v === 2); b.classList.toggle('full', v === 3); };
    /* linha da vitória: cresce do primeiro ao último centro (transform-origin no início) */
    const cxy = (i, n) => { const step = 336 / n; return [(i % n) * step + step / 2, ((i / n) | 0) * step + step / 2]; };
    const showLine = (svg, L, n) => { const [x1, y1] = cxy(L[0], n), [x2, y2] = cxy(L[2], n), dx = (x2 - x1) * .14, dy = (y2 - y1) * .14; const path = svg.querySelector('path'); path.setAttribute('d', `M${x1 - dx} ${y1 - dy}L${x2 + dx} ${y2 + dy}`); path.style.transformOrigin = `${x1 - dx}px ${y1 - dy}px`; svg.classList.remove('on'); void svg.offsetWidth; svg.classList.add('on'); };
    const stats = () => ultimate()
      ? [{ label: 'Tabuleiros ganhos', value: `${[...u.w].filter(v => v === me).length} : ${[...u.w].filter(v => v === 3 - me).length}` }, { label: 'Jogadas', value: String(u.n) }, { label: 'Tempo', value: fmtT(chrono.secs()) }]
      : [{ label: 'Partidas', value: String(rounds) }, { label: 'Série', value: `${series[1]} : ${series[2]}` }, { label: 'Empates', value: String(draws) }, { label: 'Tempo', value: fmtT(chrono.secs()) }];
    const endSeries = winner => {
      seriesOver = true; chrono.stop(); const iWon = winner === me, draw = !winner;
      let sub = '', title = draw ? 'Série empatada' : 'Fim da série';
      if (mode === 'local') sub = winner ? (winner === 1 ? 'As cruzes ganham a série' : 'Os círculos ganham a série') : 'Ninguém ganhou';
      else if (iWon) { const n = addWin('ttt:' + level); A.setScore(n); sub = `Venceste ${lv().name} ${series[me]} a ${series[3 - me]} · ${plural(n, 'série ganha', 'séries ganhas')}`; }
      else if (draw) sub = `Empatado ${series[1]} a ${series[2]}` + (level === 'dificil' ? ' · aguentaste o imbatível' : '');
      else sub = `${lv().name} ganhou ${series[3 - me]} a ${series[me]}`;
      if (winner && (iWon || mode === 'local')) x.celebrate('win');
      paint();
      const st = stats(); const tm = setTimeout(() => x.end({ title, sub, score: null, submit: false, win: mode === 'local' ? !!winner : (iWon || (draw && level === 'dificil')), stats: st }), 1000); win.timers.push(tm);
    };
    const finish = (why, winner, line, cur2) => {
      if (over) return; over = true; busy = false; gen++;
      if (line) showLine(winC, line, 3);
      const iWon = mode !== 'local' && winner === me;
      x.sfx(winner ? (iWon || mode === 'local' ? 'win' : 'lose') : 'tick');
      if (mode === 'online') {
        chrono.stop();
        let title = winner ? 'Três em linha!' : 'Empate', sub = winner ? (iWon ? 'Ganhaste' : `${oppName()} ganhou`) : 'Ninguém ganhou';
        if (why === 'left') title = 'O adversário saiu'; if (why === 'timeout') title = 'Tempo esgotado'; if (why === 'resign') title = 'Desistência';
        if (cur2 && link) sub = mpWhy(cur2, link) || sub;
        if (iWon) { A.setScore(addWin('ttt:online')); x.celebrate('win'); }
        if (link) link.destroy();
        paint(); const st = [{ label: 'Jogadas', value: String(s.n) }, { label: 'Tempo', value: fmtT(chrono.secs()) }];
        const tm = setTimeout(() => { mpEnd(x, GAME, title, sub, winner ? iWon : undefined, st); link = null; }, 1000); win.timers.push(tm); return;
      }
      rounds++;
      if (winner) { series[winner]++; x.flash(winner === me || mode === 'local' ? 'Três em linha!' : 'Perdeste esta', winner === me || mode === 'local' ? 'big' : 'pts'); } else { draws++; x.flash('Empate', 'pts'); }
      paint();
      if (series[1] >= 3 || series[2] >= 3) { endSeries(series[1] >= 3 ? 1 : 2); return; }
      /* a série segue até alguém chegar a três; com muitos empates acaba às nove partidas */
      if (rounds >= 9) { endSeries(series[1] === series[2] ? 0 : (series[1] > series[2] ? 1 : 2)); return; }
      const my = gen; const tm = setTimeout(() => { if (my !== gen || seriesOver || mode === 'online' || ultimate()) return; starter = 3 - starter; begin(starter); }, 1400); win.timers.push(tm);
    };
    const settle = () => { if (mode !== 'online') { const w = T3.winner(s); if (w) { finish('board', w.p, w.line); return; } if (s.n >= 9) { finish('board', 0); return; } } paint(); if (mode === 'ia' && s.turn !== me) aiTurn(); };
    const play = (i, fromNet) => {
      const p = s.turn; if (!T3.put(s, i)) return false; hist.push(i); mark(cells[i], p, true); x.sfx('place');
      if (mode === 'online' && !fromNet && link) link.send({ cell: i }).then(r => { if (r && r.error && !over) { UI.toast(r.error === 'turn' ? 'Não é a tua vez' : 'Jogada recusada pelo servidor'); resync(); } });
      const tm = setTimeout(settle, 220); win.timers.push(tm); busy = true; const tb = setTimeout(() => { busy = false; }, 200); win.timers.push(tb); return true;
    };
    const resync = async () => { if (!link || over) return; const r = await Arcade.match.state({ id: link.m.id }); if (!r || r.error || over) return; fromNet(r); sync(); paint(); };
    const fromNet = cur2 => { const st = Online.parse(cur2.state) || {}; s = T3.fromBoard(st.board, cur2.turn === 'b' ? 2 : 1); hist = []; };
    const aiTurn = async () => { busy = true; paint(); const my = ++gen; await sleep(480); while (paused && my === gen) await sleep(200); if (my !== gen || over) return; busy = false; const i = level === 'dificil' ? T3.best(s) : level === 'medio' ? T3.medium(s) : T3.easy(s); if (i >= 0) play(i); };
    const tap = i => { if (ultimate() || !s || !human() || paused) return; if (s.b[i]) { x.sfx('fail'); return; } play(i); };
    /* ---------- Ultimate ---------- */
    const uFinish = r => {
      if (over) return; over = true; busy = false; gen++; chrono.stop();
      if (r.line) showLine(winU, r.line, 3);
      const iWon = r.st === 'win' && r.p === me;
      x.sfx(r.st === 'win' ? (iWon ? 'win' : 'lose') : 'tick');
      let title = r.st === 'win' ? (iWon ? 'Ultimate ganho' : 'Ultimate perdido') : 'Empate', sub = r.st === 'win' ? (iWon ? `Venceste ${lv().name}` : `${lv().name} ganhou`) : 'Nenhum tabuleiro em linha';
      if (r.why === 'resign') { title = 'Desistência'; sub = `${lv().name} ganhou`; }
      if (iWon) { const n = addWin('ttt:ult:' + level); A.setScore(n); sub += ` · ${plural(n, 'vitória', 'vitórias')}`; flagAch('tttUltimate'); x.celebrate('win'); }
      paint();
      const st = stats(); const tm = setTimeout(() => x.end({ title, sub, score: null, submit: false, win: r.st === 'win' ? iWon : undefined, stats: st }), 1100); win.timers.push(tm);
    };
    const uSettle = () => { const r = U.status(u); if (r.st !== 'play') { uFinish(r); return; } paint(); if (u.turn !== me) uAi(); };
    const uPlayAt = i => {
      const p = u.turn, k = (i / 9) | 0, w0 = u.w[k]; U.play(u, i); hist.push(i); mark(ucells[i], p, true); x.sfx('place');
      if (!w0 && u.w[k]) { paintBig(k, true); if (u.w[k] !== 3) { x.sfx('chime'); x.flash(u.w[k] === me ? 'Tabuleiro ganho' : 'Tabuleiro perdido', 'pts'); } }
      busy = true; paint(); const tm = setTimeout(() => { busy = false; uSettle(); }, 240); win.timers.push(tm);
    };
    const uAi = async () => {
      busy = true; paint(); const my = ++gen; await sleep(420);
      const i = await U.think(u, level, { cancelled: () => my !== gen || over, wait: async () => { while (paused && my === gen) await sleep(200); } });
      if (my !== gen || over) return; busy = false; if (i >= 0) uPlayAt(i); else uSettle();
    };
    const tapU = i => { if (!ultimate() || !u || !human() || paused) return; if (!U.moves(u).includes(i)) { x.sfx('fail'); const b = sbs[(i / 9) | 0]; b.classList.remove('nope'); void b.offsetWidth; b.classList.add('nope'); return; } uPlayAt(i); };
    wrap.querySelector('.gtt-board').addEventListener('click', e => { const c = e.target.closest('.gtt-c'); if (c) tap(+c.dataset.i); });
    wrap.querySelector('.gtt-ult').addEventListener('click', e => { const c = e.target.closest('.gtt-uc'); if (c) tapU(+c.dataset.i); });
    const begin = first => {
      if (mode !== 'online') { s = T3.create(); s.turn = first || 1; }
      over = false; busy = false; gen++; hist = []; if (!chrono.running) chrono.start(); wrap.classList.remove('gbd-hide'); names(); sync(); settle();
    };
    const beginU = () => { u = U.create(); u.turn = 1; over = false; busy = false; gen++; hist = []; chrono.reset(); chrono.start(); wrap.classList.remove('gbd-hide'); names(); usync(); uSettle(); };
    const onOpp = (cur2, st) => {
      if (over || !s) return;
      const b = st && st.board, i = cur2.last;
      if (Array.isArray(b) && Number.isInteger(i) && i >= 0 && i < 9 && !s.b[i] && (b[i] === 1 || b[i] === 2)) { s.b[i] = b[i]; s.n++; mark(cells[i], b[i], true); x.sfx('place'); }
      else { fromNet(cur2); sync(); }
      s.turn = me; paint();
    };
    const onEnd = cur2 => {
      if (over) return;
      const st = Online.parse(cur2.state) || {}, b = Array.isArray(st.board) ? st.board : null;
      if (b) for (let i = 0; i < 9; i++) { const v = b[i] === 1 || b[i] === 2 ? b[i] : 0; if (v && !s.b[i]) { s.b[i] = v; s.n++; mark(cells[i], v, true); } }
      const w = T3.winner(s), wn = cur2.winner === 'a' ? 1 : cur2.winner === 'b' ? 2 : 0;
      finish(cur2.reason === 'timeout' ? 'timeout' : cur2.reason === 'left' ? 'left' : 'board', wn, w ? w.line : null, cur2);
    };
    const startOnline = m => { mode = 'online'; seriesOver = true; me = m.you === 'b' ? 2 : 1; link = Online.join(A, m, { onOpp, onEnd }); fromNet(m); A.setScore(winsOf('ttt:online')); chrono.reset(); begin(); if (m.ended) onEnd(m); };
    const start = ch => {
      if (!ch) return;
      if (ch.mode === 'online') { startOnline(ch.m); return; }
      mode = ch.mode; level = ch.level || level; if (!LVL.some(l => l.v === level)) level = 'medio'; me = 1;
      if (mode === 'ultimate') { seriesOver = true; A.setScore(winsOf('ttt:ult:' + level)); beginU(); return; }
      series = { 1: 0, 2: 0 }; starter = 1; rounds = 0; draws = 0; seriesOver = false; chrono.reset();
      A.setScore(mode === 'ia' ? winsOf('ttt:' + level) : 0); begin(1);
    };
    const toLobby = async () => { gen++; chrono.stop(); seriesOver = true; if (link) { link.destroy(); link = null; } over = true; wrap.classList.add('gbd-hide'); A.setMid(''); bUndo.classList.add('off'); bResign.classList.add('off'); start(await lobby(A, { game: GAME, name: 'Jogo do Galo', tagline: 'Quadro de giz, melhor de cinco e o novo Ultimate', cover: COVER.ttt, levels: LVL, level, extra: { key: 'ultimate', title: 'Ultimate', sub: 'Nove tabuleiros', icon: 'grid' } })); };
    const restart = () => { if (mode === 'online' || !mode) toLobby(); else { gen++; seriesOver = true; start({ mode, level }); } };
    bModes.onclick = async () => {
      if (!over && mode === 'online') { if (!await UI.confirm('Sair da partida', 'Sais da partida online e conta como derrota.', 'Sair', true)) return; if (link) link.leave(); }
      else if (!over && vsPhone() && hist.length && !await UI.confirm('Mudar de modo', ultimate() ? 'Perdes a partida atual.' : 'Perdes a série atual.', 'Mudar', true)) return;
      toLobby();
    };
    bResign.onclick = async () => {
      if (over || mode === 'local') return;
      if (!await UI.confirm('Desistir', ultimate() ? 'Dás a partida como perdida.' : 'Dás a série como perdida.', 'Desistir', true)) return;
      if (mode === 'online') { if (link) link.leave(); finish('resign', 3 - me); return; }
      if (ultimate()) { uFinish({ st: 'win', p: 3 - me, why: 'resign' }); return; }
      over = true; gen++; series[3 - me] = 3; endSeries(3 - me);
    };
    /* desfaz a jogada do telemóvel e a nossa */
    bUndo.onclick = () => {
      if (bUndo.classList.contains('off') || over || busy || !vsPhone()) return;
      let n = 0;
      while (hist.length && (n < 2 || turnOf() !== me)) { const i = hist.pop(); if (ultimate()) { U.undo(u); mark(ucells[i], 0); } else { s.b[i] = 0; s.n--; s.turn = 3 - s.turn; mark(cells[i], 0); } n++; }
      if (ultimate()) sbs.forEach((b, k) => paintBig(k, false));
      x.haptic('light'); paint();
    };
    (async () => { await x.ready('Jogo do Galo', 'Melhor de cinco, online e o novo Ultimate'); const pm = Online.takePending(GAME); if (pm) startOnline(pm); else toLobby(); })();
    win.onClose = () => { gen++; seriesOver = true; chrono.stop(); if (link) link.destroy(); };
    const api = { pause() { paused = true; chrono.stop(); }, resume() { paused = false; if (!over && (s || u)) chrono.start(); },
      key(e) { if (e.key === 'u' || e.key === 'U') { bUndo.click(); return; } if (ultimate()) { ucur.key(e); return; } if (/^[1-9]$/.test(e.key)) { e.preventDefault(); tap(+e.key - 1); return; } cur.key(e); },
      test: { get s() { return s; }, get u() { return u; }, tap, tapU, start: ch => { closeLobby(stage); start(ch); }, get human() { return human(); }, get over() { return over; }, get mode() { return mode; }, get series() { return series; }, get busy() { return busy; }, T3, U } };
    LIVE.game = api; return api;
  },
});

/* ---------- ganchos só para testes (harness e Node): motores puros e o jogo em primeiro plano ---------- */
window.__gb = { eng: ENG, get live() { return LIVE.game || (window.__gbp && window.__gbp.live) || null; },
  /* toca no "Toca para começar" da casca (ou no que estiver por cima do palco) */
  tapReady() { const w = window.System && System.currentApp() && System.windows[System.currentApp()]; const sh = w && w._gs; if (sh && sh.waiting && sh._go) { sh._go(); return true; }
    const st = document.querySelector('.app-window .gm-stage'); if (!st) return false; const r = UI.vrect(st); const t = document.elementFromPoint(r.left + r.width / 2, r.top + r.height / 2) || st;
    ['pointerdown', 'pointerup', 'click'].forEach(k => { try { t.dispatchEvent(new PointerEvent(k, { bubbles: true, cancelable: true, pointerId: 1, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 })); } catch (e) { t.dispatchEvent(new MouseEvent(k, { bubbles: true, cancelable: true })); } }); return true; } };
})();
