/* Rex Pool NUI - Rex Studio */
'use strict';

const isGame = typeof GetParentResourceName === 'function';
const RES = isGame ? GetParentResourceName() : 'rex_pool';
const $ = (s, el) => (el || document).querySelector(s);
const $$ = (s, el) => Array.from((el || document).querySelectorAll(s));

const S = {
  L: {}, modes: {}, formats: ['1v1', '2v2'], powerMode: 'drag', currency: '£',
  view: null, data: null, me: null, adminTab: 'sessions', form: null,
};

function t(key, ...args) {
  let s = S.L[key] || key;
  let i = 0;
  s = s.replace(/%[sd]/g, () => (args[i++] ?? ''));
  return s.replace(/%%/g, '%');
}
function esc(v) {
  return String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}
function money(n) { const v = Number(n || 0); return (v < 0 ? '-' : '') + S.currency + Math.abs(v).toLocaleString('en-GB'); }

async function post(name, data) {
  if (!isGame) return Mock.post(name, data);
  try {
    const r = await fetch(`https://${RES}/${name}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data || {}),
    });
    return await r.json();
  } catch (e) { return null; }
}

/* ------------------------------------------------------------------ SVG assets */
const BALL_COLORS = {
  0: '#ece6d8', 1: '#e9b627', 2: '#1d4aa8', 3: '#c42a26', 4: '#4f2a85', 5: '#e0701c', 6: '#16784a', 7: '#6e1d22', 8: '#141414',
};
function ballColor(id) { return BALL_COLORS[id > 8 ? id - 8 : id]; }
(function injectDefs() {
  const d = document.createElement('div');
  d.innerHTML = `<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
    <radialGradient id="rpShade" cx="34%" cy="28%" r="78%">
      <stop offset="0" stop-color="#fff" stop-opacity=".55"/><stop offset=".22" stop-color="#fff" stop-opacity=".08"/>
      <stop offset=".62" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".5"/></radialGradient>
    <clipPath id="rpClip" clipPathUnits="userSpaceOnUse"><circle cx="10" cy="10" r="9.5"/></clipPath></defs></svg>`;
  document.body.appendChild(d.firstChild);
})();
/** Crisp SVG pool ball. o: { size: 'sm'|'lg', potted, hl } */
function ball(id, o) {
  o = o || {};
  const cls = `bsvg ${o.size || ''} ${o.potted ? 'potted' : ''} ${o.hl ? 'hl' : ''}`;
  const fs = id > 9 ? 4.5 : 5.3;
  if (o.potted) {
    return `<svg class="${cls}" viewBox="0 0 20 20" aria-hidden="true"><circle cx="10" cy="10" r="8.8" fill="none" stroke="currentColor" stroke-opacity=".28" stroke-width="1"/>
      ${id ? `<text x="10" y="10" dy="1.85" text-anchor="middle" font-size="${fs}" font-weight="600" font-family="RP Text, Inter, sans-serif" fill="currentColor" fill-opacity=".38">${id}</text>` : ''}</svg>`;
  }
  const c = ballColor(id);
  const body = id > 8
    ? `<circle cx="10" cy="10" r="9.5" fill="#efe9dc"/><rect x="0" y="5.1" width="20" height="9.8" fill="${c}" clip-path="url(#rpClip)"/>`
    : `<circle cx="10" cy="10" r="9.5" fill="${c}"/>`;
  const num = id ? `<circle cx="10" cy="10" r="4.4" fill="#f7f3ea"/><text x="10" y="10" dy="1.9" text-anchor="middle" font-size="${fs}" font-weight="700"
      font-family="RP Text, Inter, sans-serif" fill="#151515">${id}</text>` : '';
  return `<svg class="${cls}" viewBox="0 0 20 20" aria-hidden="true">${body}${num}<circle cx="10" cy="10" r="9.5" fill="url(#rpShade)"/>
    <circle cx="10" cy="10" r="9.45" fill="none" stroke="#000" stroke-opacity=".35" stroke-width=".4"/></svg>`;
}
const ICON = {
  x: '<svg viewBox="0 0 16 16" aria-hidden="true"><path d="M3 3l10 10M13 3L3 13" stroke="currentColor" stroke-width="1.4" stroke-linecap="square"/></svg>',
  mark: '<svg viewBox="0 0 20 20" aria-hidden="true"><circle cx="10" cy="10" r="8.6" fill="none" stroke="#c6a25a" stroke-width="1"/><circle cx="10" cy="10" r="3.6" fill="none" stroke="#c6a25a" stroke-width="1"/><path d="M10 1.4v3M10 15.6v3M1.4 10h3M15.6 10h3" stroke="#c6a25a" stroke-width="1"/></svg>',
  clock: '<svg viewBox="0 0 12 12" aria-hidden="true"><circle cx="6" cy="6" r="5" fill="none" stroke="currentColor" stroke-width="1.1"/><path d="M6 3v3.2l2 1.3" fill="none" stroke="currentColor" stroke-width="1.1"/></svg>',
  trophy: '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="#dcc187" stroke-width="1.3"><path d="M7 3h10v5a5 5 0 0 1-10 0V3z"/><path d="M7 5H3.5a3.5 3.5 0 0 0 3.8 4.2M17 5h3.5a3.5 3.5 0 0 1-3.8 4.2"/><path d="M12 13v4M8 21h8M9 17h6v4H9z"/></svg>',
};

/* ------------------------------------------------------------------ modal */
function openModal(html, cls) {
  $('#window').className = 'window ' + (cls || '');
  $('#window').innerHTML = html;
  $('#modal').classList.remove('hidden');
}
function closeModal(notify) {
  $('#modal').classList.add('hidden');
  S.view = null;
  if (notify) post('close');
}
document.addEventListener('keydown', e => {
  if (e.key === 'Escape' && !$('#modal').classList.contains('hidden')) closeModal(true);
});

/* ------------------------------------------------------------------ helpers */
function modeName(m) { return t('mode_' + m); }
function teamNames(team) { return team.map(p => esc(p.name)).join(' & ') || '—'; }
function isMine(session, me) {
  return ['A', 'B'].some(k => session.teams[k].some(p => p.src === me));
}
function myTeam(session, me) {
  for (const k of ['A', 'B']) if (session.teams[k].some(p => p.src === me)) return k;
  return null;
}
function header(title, sub, over) {
  return `<div class="win-head"><div class="mark">${ICON.mark}</div><div class="ttl"><div class="over">${esc(over || t('title'))}</div>
    <h1>${esc(title)}</h1>${sub ? `<p>${sub}</p>` : ''}</div>
    <button class="x" data-act="close" aria-label="${esc(t('close'))}">${ICON.x}</button></div>`;
}
function bind(root, handlers) {
  $$('[data-act]', root).forEach(el => {
    el.addEventListener('click', ev => {
      if (el.disabled) return;
      const fn = handlers[el.dataset.act];
      RexAudio.play('click', 0.6);
      if (fn) fn(el, ev);
    });
  });
}
/** Segmented control. opts: [{ v, label, on, disabled }] */
function seg(act, opts, extra) {
  const i = opts.findIndex(o => o.on);
  return `<div class="seg ${i < 0 ? 'none' : ''}" data-seg="${act}" style="--n:${opts.length};--i:${Math.max(0, i)}">${opts.map(o =>
    `<button class="${o.on ? 'on' : ''}" data-act="${act}" data-v="${esc(o.v)}" ${extra || ''} ${o.disabled ? 'disabled' : ''}>${esc(o.label)}</button>`).join('')}</div>`;
}
function setSeg(el, onValue, disabledFn) {
  const btns = $$('button', el);
  let idx = -1;
  btns.forEach((b, k) => {
    const on = String(b.dataset.v) === String(onValue);
    b.classList.toggle('on', on);
    if (on) idx = k;
    b.disabled = disabledFn ? !!disabledFn(b.dataset.v) : false;
  });
  el.classList.toggle('none', idx < 0);
  el.style.setProperty('--i', Math.max(0, idx));
}

/* ------------------------------------------------------------------ lobby: create (fixed layout) */
function defaultForm() {
  const modes = Object.keys(S.modes).filter(m => S.modes[m].enabled);
  const mode = modes.includes('eightball') ? 'eightball' : modes[0];
  return { mode, rules: mode !== 'free', format: '1v1', assist: S.modes[mode].assist, wager: 0, callPocket: false, targetScore: 25 };
}
function targetOptions() { return (S.modes.straight && S.modes.straight.targetScores) || [25]; }

/** Every option is always rendered at the same place; options that do not apply are disabled with a reason. */
function renderCreate(info) {
  const f = S.form || (S.form = defaultForm());
  const order = ['eightball', 'nineball', 'straight', 'free'];
  const modes = Object.keys(S.modes).filter(m => S.modes[m].enabled)
    .sort((a, b) => (order.indexOf(a) + 1 || 99) - (order.indexOf(b) + 1 || 99));
  const icons = { eightball: 8, nineball: 9, straight: 14, free: 0 };
  const formats = ['solo', ...S.formats];
  return `
  ${header(info.label || t('title'), t('lobby_new'))}
  <div class="win-body" id="createForm">
    <div class="cap">${t('choose_mode')}</div>
    <div class="modes">${modes.map(m => `<button class="mode" data-act="mode" data-mode="${m}">
        ${ball(icons[m] ?? 0, { size: 'lg' })}<b>${modeName(m)}</b><small>${t('mode_' + m + '_desc')}</small></button>`).join('')}</div>
    <div class="opts">
      <div class="field" id="fRules"><label class="cap">${t('rules_engine')}</label>
        ${seg('rules', [{ v: 'on', label: t('rules_on') }, { v: 'off', label: t('rules_off') }])}<small></small></div>
      <div class="field" id="fFormat"><label class="cap">${t('format')}</label>
        ${seg('format', formats.map(v => ({ v, label: t('format_' + v) })))}<small>${t('format_desc')}</small></div>
      <div class="field" id="fAssist"><label class="cap">${t('aim_assist')}</label>
        ${seg('assist', [0, 1, 2, 3].map(i => ({ v: i, label: t('assist_' + i) })))}<small></small></div>
      <div class="field" id="fCall"><label class="cap">${t('call_pocket')}</label>
        ${seg('call', [{ v: 'on', label: t('rules_on') }, { v: 'off', label: t('rules_off') }])}<small></small></div>
      <div class="field" id="fTarget"><label class="cap">${t('target_score')}</label>
        ${seg('target', targetOptions().map(v => ({ v, label: String(v) })))}<small></small></div>
      <div class="field" id="fWager"><label class="cap">${t('wager')}</label>
        <div class="wager"><span>${S.currency}</span><input id="wager" type="number" min="${info.minWager || 0}" max="${info.maxWager || 0}" step="50" value="${f.wager}"></div><small></small></div>
    </div>
    <div class="win-foot">
      <div class="rent">${info.rental > 0 ? t('rental_fee', `<b>${money(info.rental)}</b>`) : t('rental_free')}</div>
      <button class="ghost" data-act="leaderboard">${t('leaderboard')}</button>
      <button class="primary" data-act="create">${t('create_table')}</button>
    </div>
  </div>`;
}

/** Applies S.form to the create view in place (no re-render: no reflow, CSS transitions run). */
function syncCreate(info) {
  const f = S.form;
  const mc = S.modes[f.mode] || { maxAssist: 3, assist: 2 };
  if (f.mode === 'free') f.rules = false;
  const rulesOn = f.mode !== 'free' && f.rules;
  const maxA = mc.maxAssist ?? 3;
  if (f.assist > maxA) f.assist = maxA;
  if (rulesOn && f.format === 'solo') f.format = S.formats[0];
  const callOk = rulesOn && f.mode !== 'nineball';
  const targetOk = f.mode === 'straight';
  if (targetOk && !targetOptions().includes(f.targetScore)) f.targetScore = targetOptions()[0];
  const wagerOk = !!info.wagers && rulesOn;

  $$('.mode').forEach(el => el.classList.toggle('on', el.dataset.mode === f.mode));
  const field = (id, ok, reason, desc) => {
    const el = $('#' + id);
    el.classList.toggle('na', !ok);
    $('small', el).textContent = ok ? desc : reason;
  };
  setSeg($('[data-seg="rules"]'), rulesOn ? 'on' : 'off', () => f.mode === 'free');
  field('fRules', f.mode !== 'free', t('na_free_rules'), rulesOn ? t('rules_on_desc') : t('rules_off_desc'));
  setSeg($('[data-seg="format"]'), f.format, v => v === 'solo' && rulesOn);
  setSeg($('[data-seg="assist"]'), f.assist, v => Number(v) > maxA);
  field('fAssist', true, '', t('assist_desc', t('assist_' + maxA)));
  setSeg($('[data-seg="call"]'), callOk && f.callPocket ? 'on' : 'off');
  field('fCall', callOk, f.mode === 'nineball' ? t('na_nineball_call') : t('na_needs_rules'), t('call_pocket_desc'));
  setSeg($('[data-seg="target"]'), targetOk ? f.targetScore : null);
  field('fTarget', targetOk, t('na_straight_only'), t('target_desc'));
  const w = $('#wager');
  w.disabled = !wagerOk;
  field('fWager', wagerOk, !info.wagers ? t('na_wagers_off') : t('na_needs_rules'),
    t('wager_desc', money(info.maxWager), Math.round((info.houseCut || 0) * 100)));
}

function renderSessionLobby(info, s, me) {
  const mine = isMine(s, me);
  const host = s.host === me;
  const cap = s.slots;
  const set = s.settings;
  const col = k => {
    const list = s.teams[k];
    let rows = list.map(p => `<div class="slot filled"><span class="avatar">${esc(p.name).slice(0, 1)}</span><span class="nm">${esc(p.name)}</span>${p.src === s.host ? `<em>${t('host')}</em>` : ''}</div>`).join('');
    for (let i = list.length; i < cap; i++) {
      rows += `<div class="slot empty"><span class="avatar">+</span><span class="nm">${!mine && s.state === 'lobby' ? '' : t('waiting_player')}</span>
        ${!mine && s.state === 'lobby' ? `<button class="mini" data-act="join" data-team="${k}">${t('join_team')}</button>` : ''}</div>`;
    }
    return `<div class="team team${k}"><div class="team-head"><i></i><b>${t('team')} ${k}</b></div>${rows}</div>`;
  };
  const specs = [
    [t('choose_mode'), modeName(set.mode)], [t('rules_engine'), set.rules ? t('rules_on') : t('rules_off')], [t('format'), t('format_' + set.format)],
    [t('aim_assist'), t('assist_' + set.assist)],
    set.mode === 'straight' ? [t('target_score'), set.targetScore] : [t('call_pocket'), set.callPocket ? t('rules_on') : t('rules_off')],
    [t('wager'), set.wager > 0 ? money(set.wager) : '—', set.wager > 0],
  ];
  const full = !set.rules || (s.teams.A.length >= cap && s.teams.B.length >= cap);
  return `
  ${header(s.label || info.label || t('title'), t('lobby_waiting'))}
  <div class="win-body">
    <div class="specs">${specs.map(([k, v, g]) => `<div><span>${esc(k)}</span><b class="${g ? 'gold' : ''}">${esc(v)}</b></div>`).join('')}</div>
    <div class="teams">${col('A')}<div class="vs">VS</div>${col('B')}</div>
    ${set.wager > 0 ? `<div class="note gold">${t('escrow_note', money(set.wager * (cap * 2)))}</div>` : ''}
    <div class="win-foot">
      <div class="rent">${s.rental > 0 ? t('rental_fee', `<b>${money(s.rental)}</b>`) : t('rental_free')}</div>
      ${mine ? `<button class="ghost" data-act="leave">${t('leave')}</button>` : ''}
      ${host ? `<button class="primary" data-act="start" ${full ? '' : 'disabled'}>${full ? t('start_match') : t('waiting_players')}</button>` : ''}
      ${!mine && !host ? `<button class="ghost" data-act="close">${t('close')}</button>` : ''}
    </div>
  </div>`;
}

function renderSessionPlaying(info, s, me) {
  const mine = isMine(s, me);
  const dropIn = !s.settings.rules && !mine;
  return `
  ${header(s.label || info.label || t('title'), modeName(s.settings.mode) + ' · ' + (s.settings.rules ? t('rules_on') : t('rules_off')))}
  <div class="win-body">
    ${scoreboardHtml(s, me, true)}
    ${s.pot > 0 ? `<div class="note gold">${t('pot')}: <b>${money(s.pot)}</b></div>` : ''}
    ${s.resetVote ? `<div class="note">${t('vote_pending', esc(s.resetVote.by))}</div>` : ''}
    <div class="win-foot">
      <div class="sp"></div>
      ${dropIn ? `<button class="primary" data-act="join" data-team="">${t('join_free')}</button>` : ''}
      <button class="ghost" data-act="spectate">${t('spectate')}</button>
      ${mine ? `<button class="ghost" data-act="reset">${s.pot > 0 ? t('reset_vote') : t('reset_rack')}</button>` : ''}
      ${mine ? `<button class="danger" data-act="leave">${s.pot > 0 && s.settings.rules ? t('forfeit') : t('leave')}</button>` : ''}
    </div>
  </div>`;
}

function renderLobby(data) {
  S.data = data;
  S.me = data.me;
  const s = data.session;
  if (!s) {
    // build the create form once, then only update it in place
    if (!S.form || !($('#createForm') && S.view === 'lobby' && !$('#modal').classList.contains('hidden'))) {
      openModal(renderCreate(data), 'lobby');
      bindCreate(data);
    }
    syncCreate(data);
    return;
  }
  const html = s.state === 'lobby' ? renderSessionLobby(data, s, data.me) : renderSessionPlaying(data, s, data.me);
  openModal(html, 'lobby');
  bind($('#window'), {
    close: () => closeModal(true),
    leaderboard: () => openLeaderboard(),
    join: async el => { await post('join', { id: s.id, team: el.dataset.team || null }); },
    leave: async () => { await post('leave', { id: s.id }); },
    start: async () => { await post('start', { id: s.id }); },
    spectate: async () => { await post('spectate', { id: s.id }); closeModal(false); },
    reset: async () => { await post('reset', { id: s.id }); },
  });
}

function bindCreate(info) {
  const upd = () => syncCreate(info);
  bind($('#window'), {
    close: () => closeModal(true),
    mode: el => { S.form.mode = el.dataset.mode; S.form.assist = S.modes[el.dataset.mode].assist; S.form.rules = el.dataset.mode !== 'free'; upd(); },
    rules: el => { S.form.rules = el.dataset.v === 'on'; upd(); },
    format: el => { S.form.format = el.dataset.v; upd(); },
    assist: el => { S.form.assist = Number(el.dataset.v); upd(); },
    target: el => { S.form.targetScore = Number(el.dataset.v); upd(); },
    call: el => { S.form.callPocket = el.dataset.v === 'on'; upd(); },
    create: async () => {
      const w = $('#wager');
      const f = S.form;
      const rulesOn = f.mode !== 'free' && f.rules;
      f.wager = w && !w.disabled ? Math.max(0, Math.floor(Number(w.value) || 0)) : 0;
      const payload = { ...f, rules: rulesOn, callPocket: rulesOn && f.mode !== 'nineball' && f.callPocket };
      await post('create', payload);
    },
    leaderboard: () => openLeaderboard(),
  });
  const w = $('#wager');
  if (w) w.addEventListener('input', () => { S.form.wager = Math.max(0, Math.floor(Number(w.value) || 0)); });
}

/* ------------------------------------------------------------------ scorebug */
function remainingBalls(s) {
  return new Set((s.snapshot || []).filter(b => b.id !== 0 && !b.p).map(b => b.id));
}
function rail(ids, on, size, hlId) {
  return `<span class="brail">${ids.map(id => `<span class="${id === hlId ? 'on-ball' : ''}">${ball(id, { size, potted: !on.has(id) })}</span>`).join('')}</span>`;
}
const SOLIDS = [1, 2, 3, 4, 5, 6, 7];
const STRIPES = [9, 10, 11, 12, 13, 14, 15];
function shooterName(s, src) {
  const p = [...s.teams.A, ...s.teams.B].find(x => x.src === src);
  return p ? p.name : '—';
}
function scoreboardHtml(s, me, inWindow) {
  const m = s.match || {};
  const on = remainingBalls(s);
  const mode = s.settings.mode;
  const pot = s.pot > 0 ? money(s.pot) : '';
  const chips = [];
  if (m.isBreak && !m.winner) chips.push(['', t('tag_break')]);
  if (m.ballInHand && !m.winner) chips.push(['bih', t('tag_ball_in_hand')]);
  if (m.last && m.last.foul && !m.winner) chips.push(['foul', t('tag_foul')]);
  if (m.run > 1) chips.push(['', t('tag_run', m.run)]);
  let msg;
  if (m.winner) msg = `<span class="bug-msg you">${t('winner_is', teamNames(s.teams[m.winner]))}</span>`;
  else if (!m.rules) msg = '';
  else if (m.shooter === me) msg = `<span class="bug-msg you">${t('your_turn')}</span>`;
  else msg = `<span class="bug-msg">${t('turn_of', esc(shooterName(s, m.shooter)))}</span>`;
  const status = `<div class="bug-status ${msg || chips.length ? '' : 'empty'}">${msg}${chips.map(([c, x]) => `<span class="chip ${c}">${esc(x)}</span>`).join('')}</div>`;
  const clock = `<div class="bug-clock" data-deadline="${s.deadline || 0}"><i></i></div>`;
  const metaParts = [m.shotNo ? t('shot_no', m.shotNo) : null, pot || null].filter(Boolean);
  const meta = `<div class="bug-meta">${esc(metaParts.join('  ·  '))}</div>`;

  if (!m.rules) {
    const names = [...s.teams.A, ...s.teams.B].map(p => esc(p.name));
    return `<div class="bug free ${inWindow ? 'in-window' : ''}"><div class="bug-main">
      <div class="bug-side A turn"><div class="bug-name">${modeName(mode)}</div><div class="bug-sub">${t('anyone_shoots')}${m.shotNo ? ' · ' + t('shot_no', m.shotNo) : ''}</div></div>
      <div class="bug-mid">${rail([...Array(15).keys()].map(i => i + 1), on, 'sm')}</div>
      <div class="bug-side B"><div class="bug-name">${names.slice(0, 3).join(', ') || '—'}${names.length > 3 ? ` +${names.length - 3}` : ''}</div>
        <div class="bug-sub">${t('at_table')} · ${names.length}</div></div>
    </div>${clock}${status}</div>`;
  }

  const side = k => {
    const turn = m.turnTeam === k && !m.winner;
    let sub = '';
    if (mode === 'eightball') {
      const g = m.groups && m.groups[k];
      sub = g ? `<span class="grp">${t('group_' + g)}</span>${rail(g === 'solids' ? SOLIDS : STRIPES, on, 'sm')}` : `<span class="grp">${t('open_table')}</span>`;
    } else if (mode === 'straight') {
      sub = `<span class="grp">${t('race_to', m.targetScore || s.settings.targetScore)}</span>`;
    } else {
      sub = `<span class="grp">${t('team')} ${k}</span>`;
    }
    return `<div class="bug-side ${k} ${turn ? 'turn' : ''}"><div class="bug-name">${k === 'A' && turn ? '<span class="tri"></span>' : ''}${teamNames(s.teams[k])}${k === 'B' && turn ? '<span class="tri"></span>' : ''}</div>
      <div class="bug-sub">${sub}</div></div>`;
  };
  let center;
  if (mode === 'straight') {
    center = `<div class="bug-score">${(m.scores && m.scores.A) || 0}<i></i>${(m.scores && m.scores.B) || 0}</div>`;
  } else if (mode === 'nineball') {
    const ids = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    const low = ids.find(i => on.has(i));
    center = `<div class="bug-score">${rail(ids, on, 'sm', low)}</div>`;
    metaParts.unshift(low ? t('on_ball', low) : '');
  } else {
    const g = m.groups;
    if (g && g.A) {
      const left = k => (g[k] === 'solids' ? SOLIDS : STRIPES).filter(id => on.has(id)).length;
      center = `<div class="bug-score">${left('A')}<i></i>${ball(8, { size: 'sm', potted: !on.has(8) })}<i></i>${left('B')}</div>`;
    } else {
      center = `<div class="bug-score txt">${t('open_table')}</div>`;
    }
  }
  const meta2 = `<div class="bug-meta">${esc(metaParts.filter(Boolean).join('  ·  '))}</div>`;
  return `<div class="bug mode-${mode} ${inWindow ? 'in-window' : ''}"><div class="bug-main">
    ${side('A')}
    <div class="bug-mid"><div class="bug-mode">${modeName(mode)}</div>${center}${mode === 'nineball' ? meta2 : meta}</div>
    ${side('B')}
  </div>${clock}${status}</div>`;
}

/* shot clock: the server sends the remaining ms, the bar drains locally */
const Clock = { end: 0, total: 0, raf: 0 };
function tickClock() {
  const bars = $$('.bug-clock');
  const left = Math.max(0, Clock.end - performance.now());
  const k = Clock.total > 0 ? left / Clock.total : 0;
  bars.forEach(b => { $('i', b).style.transform = `scaleX(${k.toFixed(4)})`; b.classList.toggle('low', left > 0 && left < 10000); });
  Clock.raf = left > 0 ? requestAnimationFrame(tickClock) : 0;
}
function startClock(deadline) {
  if (Clock.raf) cancelAnimationFrame(Clock.raf);
  Clock.raf = 0;
  if (!deadline) { Clock.end = 0; tickClock(); return; }
  Clock.total = (S.shotClock || 0) * 1000 || Math.max(deadline, Clock.total);
  Clock.end = performance.now() + deadline;
  tickClock();
}
function renderScoreboard(data) {
  const el = $('#scoreboard');
  if (!data || !data.session) { el.classList.add('hidden'); startClock(0); return; }
  el.innerHTML = scoreboardHtml(data.session, data.me, false);
  el.classList.remove('hidden');
  const m = data.session.match || {};
  startClock(m.rules && !m.winner ? data.session.deadline : 0);
}

/* ------------------------------------------------------------------ aim HUD */
function renderHud(d) {
  const el = $('#hud');
  if (!d) { el.classList.add('hidden'); return; }
  el.classList.remove('hidden');
  $$('[data-l]', el).forEach(x => { x.textContent = t(x.dataset.l); });
  el.classList.toggle('placing', d.phase === 'place');
  if (d.phase === 'place') {
    $('#hudPhase').innerHTML = `${esc(t('hud_place'))}<span class="${d.ok ? 'okc' : 'bad'}">${esc(d.ok ? t('hud_place_ok') : t('hud_place_bad'))}</span>`;
    $('#hudTags').innerHTML = d.zone === 'kitchen' ? `<span class="chip bih">${esc(t('hud_kitchen'))}</span>` : '';
    $('#hudKeys').innerHTML = keys([['MOUSE', t('key_move')], ['ENTER', t('key_place')], ['BACK', t('key_stand')]]);
    $('#powerFill').style.width = '0%';
    $('#powerValue').textContent = '';
    return;
  }
  const p = Math.round((d.power || 0) * 100);
  $('#powerFill').style.width = p + '%';
  $('#powerFill').classList.toggle('hot', p > 80);
  $('#powerValue').textContent = p + '%';
  const dot = $('#spinDot');
  dot.style.left = (50 + (d.spinX || 0) * 38) + '%';
  dot.style.top = (50 - (d.spinY || 0) * 38) + '%';
  const sy = d.spinY || 0, sx = d.spinX || 0;
  const parts = [];
  if (sy > 0.15) parts.push(t('spin_top')); else if (sy < -0.15) parts.push(t('spin_back'));
  if (sx > 0.15) parts.push(t('spin_right')); else if (sx < -0.15) parts.push(t('spin_left'));
  $('#spinLabel').textContent = parts.length ? parts.join(' + ') : t('spin_center');
  $('#hudPhase').textContent = d.mode === 'hold' ? t('hud_aim_hold') : t('hud_aim_drag');
  const tags = [`<span class="chip">${esc(t('aim_assist'))}: ${esc(t('assist_' + d.assist))}</span>`];
  if (d.top) tags.push(`<span class="chip">${esc(t('hud_top'))}</span>`);
  if (d.call) tags.push(`<span class="chip bih">${esc(t('hud_call', d.call))}</span>`);
  if (d.deadline) tags.push(`<span class="chip">${ICON.clock}${Math.ceil(d.deadline / 1000)}s</span>`);
  $('#hudTags').innerHTML = tags.join('');
  const k = [['MOUSE', t('key_aim')], ['SHIFT', t('key_fine')], [d.mode === 'hold' ? 'SPACE' : 'LMB', t('key_power')],
    ['← ↑ → ↓', t('key_spin')], ['C', t('key_top')], ['BACK', t('key_stand')]];
  if (d.call) k.splice(5, 0, ['Q', t('key_call')]);
  $('#hudKeys').innerHTML = keys(k);
}
function keys(list) { return list.map(([k, l]) => `<div class="key"><kbd>${esc(k)}</kbd><span>${esc(l)}</span></div>`).join(''); }

/* ------------------------------------------------------------------ results */
function renderResults(d) {
  const won = d.winner && d.winner === d.myTeam;
  const title = !d.winner ? t('results_cleared') : (won ? t('results_win') : t('results_lose'));
  const reason = d.reason === 'forfeit' ? t('results_forfeit') : '';
  const rows = d.players.map(p => `<tr class="${p.won ? 'w' : ''}"><td><span class="tdot team${p.team}"></span>${esc(p.name)}</td>
    <td>${p.potted}</td><td>${p.fouls}</td><td>${p.bestBreak}</td><td>${p.bestRun}</td><td class="gold">${p.paid ? money(p.paid) : '—'}</td></tr>`).join('');
  openModal(`
    <div class="result-banner ${d.winner ? (won ? 'win' : 'lose') : ''}">
      <div class="trophy">${won ? ICON.trophy : ball(8, { size: 'lg' })}</div>
      <div><div class="over">${esc(modeName(d.mode))} · ${esc(t('shots', d.shots))}${reason ? ' · ' + esc(reason) : ''}</div><h1>${esc(title)}</h1></div>
      ${d.pot > 0 ? `<div class="pot"><span class="cap">${t('pot')}</span><b>${money(d.pot)}</b>${d.cut > 0 ? `<small>${t('house_cut')} ${money(d.cut)}</small>` : ''}</div>` : '<div></div>'}
    </div>
    <table class="tbl"><thead><tr><th>${t('player')}</th><th>${t('st_potted')}</th><th>${t('st_fouls')}</th><th>${t('st_break')}</th><th>${t('st_run')}</th><th>${t('st_won')}</th></tr></thead>
    <tbody>${rows}</tbody></table>
    <div class="win-foot">
      <div class="sp"></div>
      <button class="ghost" data-act="leave">${t('leave')}</button>
      <button class="ghost" data-act="close">${t('close')}</button>
      ${d.isHost ? `<button class="primary" data-act="rematch">${t('rematch')}</button>` : ''}
    </div>`, 'results');
  bind($('#window'), {
    close: () => closeModal(true),
    leave: () => post('leave', { id: d.id }),
    rematch: () => post('rematch', { id: d.id }),
  });
}

/* ------------------------------------------------------------------ leaderboard */
async function openLeaderboard() {
  openModal(`${header(t('leaderboard'), t('leaderboard_sub'))}<div class="loading">…</div>`, 'board');
  bind($('#window'), { close: () => closeModal(true) });
  const res = await post('leaderboard');
  if (!res) return;
  const rows = (res.rows || []).map((r, i) => {
    const wr = r.games > 0 ? Math.round(r.wins / r.games * 100) : 0;
    return `<tr><td class="rank r${i + 1}">${String(i + 1).padStart(2, '0')}</td><td>${esc(r.name)}</td><td>${r.wins}</td><td>${r.losses}</td><td>${wr}%</td>
      <td>${r.potted}</td><td>${r.best_break}</td><td>${r.best_run}</td><td class="gold">${money(r.earnings)}</td></tr>`;
  }).join('');
  const me = res.me;
  openModal(`${header(t('leaderboard'), t('leaderboard_sub'))}
    ${me ? `<div class="mystats">
      <div><b>${me.wins}</b><span>${t('st_wins')}</span></div><div><b>${me.losses}</b><span>${t('st_losses')}</span></div>
      <div><b>${me.games > 0 ? Math.round(me.wins / me.games * 100) : 0}%</b><span>${t('st_winrate')}</span></div>
      <div><b>${me.potted}</b><span>${t('st_potted')}</span></div><div><b>${me.best_break}</b><span>${t('st_break')}</span></div>
      <div><b>${me.best_run}</b><span>${t('st_run')}</span></div></div>` : ''}
    ${res.enabled === false ? `<div class="note">${t('stats_disabled')}</div>` : ''}
    <div class="scroll"><table class="tbl"><thead><tr><th>#</th><th>${t('player')}</th><th>${t('st_wins')}</th><th>${t('st_losses')}</th><th>${t('st_winrate')}</th>
    <th>${t('st_potted')}</th><th>${t('st_break')}</th><th>${t('st_run')}</th><th>${t('st_earnings')}</th></tr></thead><tbody>${rows}</tbody></table></div>`, 'board');
  bind($('#window'), { close: () => closeModal(true) });
}

/* ------------------------------------------------------------------ vote */
function renderVote(d) {
  openModal(`${header(t('vote_title'), t('vote_desc', esc(d.by)))}
    <div class="win-foot"><div class="sp"></div><button class="danger" data-act="no">${t('vote_no')}</button><button class="primary" data-act="yes">${t('vote_yes')}</button></div>`, 'vote');
  bind($('#window'), {
    close: () => closeModal(true),
    yes: async () => { await post('voteReset', { id: d.id, yes: true }); closeModal(true); },
    no: async () => { await post('voteReset', { id: d.id, yes: false }); closeModal(true); },
  });
}

/* ------------------------------------------------------------------ admin */
async function renderAdmin() {
  const d = await post('adminData');
  if (!d) { closeModal(true); return; }
  const tab = S.adminTab;
  const tabs = ['sessions', 'settings', 'matches', 'spawned'];
  let body = '';
  if (tab === 'sessions') {
    body = d.sessions.length ? `<table class="tbl"><thead><tr><th>#</th><th>${t('adm_table')}</th><th>${t('adm_mode')}</th><th>${t('adm_state')}</th>
      <th>${t('adm_players')}</th><th>${t('pot')}</th><th></th></tr></thead><tbody>${d.sessions.map(s => `<tr>
      <td>${s.id}</td><td>${esc(s.label || s.key)}</td><td>${modeName(s.settings.mode)}</td><td><span class="state ${s.state}">${t('state_' + s.state)}</span></td>
      <td>${teamNames(s.teams.A)} <i>vs</i> ${teamNames(s.teams.B)}</td><td class="gold">${money(s.pot)}</td>
      <td class="acts"><button class="mini" data-act="goto" data-id="${s.id}">${t('adm_goto')}</button>
      <button class="mini" data-act="rerack" data-id="${s.id}">${t('adm_rerack')}</button>
      <button class="mini danger" data-act="closeS" data-id="${s.id}">${t('adm_close')}</button>
      <button class="mini danger" data-act="disable" data-id="${s.id}">${t('adm_disable')}</button></td></tr>`).join('')}</tbody></table>`
      : `<div class="empty-state">${t('adm_no_sessions')}</div>`;
  } else if (tab === 'settings') {
    const r = d.runtime;
    body = `<div class="opts">
      <div class="field"><label class="cap">${t('adm_rental')}</label>${seg('rt', ['on', 'off'].map(v => ({ v, label: t('rules_' + v), on: (v === 'on') === r.rentalEnabled })), 'data-k="rentalEnabled"')}</div>
      <div class="field"><label class="cap">${t('adm_rental_mult')}</label><div class="wager"><span>×</span><input data-k="rentalMultiplier" type="number" step="0.1" value="${r.rentalMultiplier}"></div></div>
      <div class="field"><label class="cap">${t('adm_wagers')}</label>${seg('rt', ['on', 'off'].map(v => ({ v, label: t('rules_' + v), on: (v === 'on') === r.wagersEnabled })), 'data-k="wagersEnabled"')}</div>
      <div class="field"><label class="cap">${t('adm_max_wager')}</label><div class="wager"><span>${S.currency}</span><input data-k="maxWager" type="number" step="100" value="${r.maxWager}"></div></div>
      <div class="field"><label class="cap">${t('adm_house_cut')}</label><div class="wager"><span>%</span><input data-k="houseCut" type="number" step="1" value="${Math.round(r.houseCut * 100)}"></div></div>
      <div class="field"><label class="cap">${t('adm_info')}</label><small>Framework: <b>${esc(d.framework)}</b> · Stats: <b>${d.statsEnabled ? 'oxmysql' : 'off'}</b></small>
        ${d.disabled.length ? `<small>${t('adm_disabled_tables')}: ${d.disabled.map(k => `<button class="mini" data-act="enable" data-k="${esc(k)}">${esc(k)} ✕</button>`).join(' ')}</small>` : ''}</div>
    </div><div class="win-foot"><div class="sp"></div><button class="primary" data-act="saveRt">${t('adm_save')}</button></div>`;
  } else if (tab === 'matches') {
    body = d.matches.length ? `<div class="scroll"><table class="tbl"><thead><tr><th>#</th><th>${t('adm_mode')}</th><th>${t('adm_table')}</th><th>${t('adm_players')}</th><th>${t('adm_winner')}</th><th>${t('pot')}</th><th>${t('adm_date')}</th></tr></thead><tbody>
      ${d.matches.map(m => { let pl = []; try { pl = JSON.parse(m.players); } catch (e) { pl = []; }
        return `<tr><td>${m.id}</td><td>${modeName(m.mode)}</td><td>${esc(m.location)}</td><td>${pl.map(p => `<span class="tdot team${p.team}"></span>${esc(p.name)}`).join(' ')}</td>
        <td>${m.winner_team ? t('team') + ' ' + m.winner_team : '—'}</td><td class="gold">${money(m.pot)}</td><td>${esc(String(m.created_at).slice(0, 16))}</td></tr>`; }).join('')}</tbody></table></div>`
      : `<div class="empty-state">${t('adm_no_matches')}</div>`;
  } else {
    body = d.spawned.length ? `<table class="tbl"><thead><tr><th>#</th><th>Model</th><th>Coords</th><th>${t('adm_type')}</th><th></th></tr></thead><tbody>
      ${d.spawned.map(s => `<tr><td>${s.index}</td><td>${esc(s.model)}</td><td><code>vec3(${s.x.toFixed(2)}, ${s.y.toFixed(2)}, ${s.z.toFixed(2)}) · ${s.heading.toFixed(1)}°</code></td>
      <td>${s.temp ? '/poolspawn' : 'Config'}</td><td><button class="mini danger" data-act="despawn" data-id="${s.index}">${t('adm_remove')}</button></td></tr>`).join('')}</tbody></table>`
      : `<div class="empty-state">${t('adm_no_spawned')}</div>`;
  }
  openModal(`${header(t('admin_title'), t('admin_sub', d.sessions.length))}
    <div class="tabs">${tabs.map(x => `<button class="${tab === x ? 'on' : ''}" data-act="tab" data-tab="${x}">${t('adm_tab_' + x)}</button>`).join('')}</div>
    <div class="admin-body">${body}</div>`, 'admin');
  const act = async (action, arg, value) => { await post('adminAction', { action, arg, value }); renderAdmin(); };
  bind($('#window'), {
    close: () => closeModal(true),
    tab: el => { S.adminTab = el.dataset.tab; renderAdmin(); },
    goto: el => act('goto', Number(el.dataset.id)),
    rerack: el => act('rerack', Number(el.dataset.id)),
    closeS: el => act('close', Number(el.dataset.id)),
    disable: el => act('disable', Number(el.dataset.id)),
    enable: el => act('enable', el.dataset.k),
    despawn: el => act('despawn', Number(el.dataset.id)),
    rt: el => act('runtime', el.dataset.k, el.dataset.v === 'on'),
    saveRt: async () => {
      for (const inp of $$('input[data-k]')) {
        let v = Number(inp.value);
        if (inp.dataset.k === 'houseCut') v = v / 100;
        await post('adminAction', { action: 'runtime', arg: inp.dataset.k, value: v });
      }
      renderAdmin();
    },
  });
}

/* ------------------------------------------------------------------ toasts */
function toast(lines) {
  const box = $('#toasts');
  lines.forEach((l, i) => {
    const el = document.createElement('div');
    el.className = 'toast ' + (l.kind || 'info');
    el.textContent = l.text;
    setTimeout(() => {
      box.appendChild(el);
      setTimeout(() => el.classList.add('out'), 3200);
      setTimeout(() => el.remove(), 3700);
    }, i * 160);
  });
}

/* ------------------------------------------------------------------ calibration panel */
function renderCalib(d) {
  const el = document.getElementById('calib');
  if (!d) { el.classList.add('hidden'); el.innerHTML = ''; return; }
  el.classList.remove('hidden');
  const rows = (d.rows || []).map(r =>
    `<div class="crow${r.sel ? ' sel' : ''}"><span>${esc(r.label)}</span><b>${esc(r.value)}</b></div>`).join('');
  const keys = (d.keys || []).map(k => `<div class="ckey"><kbd>${esc(k[0])}</kbd><span>${esc(k[1])}</span></div>`).join('');
  el.innerHTML = `<div class="ctitle">${esc(d.title)}${d.dirty ? ' <i>UNSAVED</i>' : ''}</div>
    <div class="cmodel">${esc(d.model)}</div>${rows}
    <div class="cinfo"><span>${esc(t('calib_step'))}: <b>${esc(d.step)}</b></span><span>${esc(t('calib_shot'))}: <b>${esc(d.shot)}</b></span></div>
    <div class="ckeys">${keys}</div>${d.msg ? `<div class="cmsg">${esc(d.msg)}</div>` : ''}`;
}

/* ------------------------------------------------------------------ messages */
function handle(msg) {
  const { action, data } = msg;
  switch (action) {
    case 'init':
      S.L = data.locale || {}; S.modes = data.modes || {}; S.formats = data.formats || S.formats;
      S.powerMode = data.powerMode; S.currency = data.currency || '£'; S.shotClock = data.shotClock || 0;
      break;
    case 'open':
      S.view = data.view;
      if (data.view === 'lobby') { S.form = null; renderLobby(data.data); }
      else if (data.view === 'results') renderResults(data.data);
      else if (data.view === 'leaderboard') openLeaderboard();
      else if (data.view === 'admin') renderAdmin();
      else if (data.view === 'vote') renderVote(data.data);
      break;
    case 'close': closeModal(false); break;
    case 'lobby':
      if (S.view === 'lobby' && S.data) { S.data.session = data.session; S.data.me = data.me; renderLobby(S.data); }
      break;
    case 'scoreboard': renderScoreboard(data); break;
    case 'hud': renderHud(data); break;
    case 'toast': toast(data); break;
    case 'sound': RexAudio.play(data.kind, data.v); break;
    case 'calib': renderCalib(data); break;
    default: break;
  }
}
window.addEventListener('message', e => handle(e.data || {}));
window.RexPool = { handle };
