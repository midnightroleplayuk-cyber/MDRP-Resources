'use strict';

/* Vinewood Gangs tablet. All user-supplied text is inserted with textContent, never innerHTML. */

const IN_GAME = typeof window.GetParentResourceName === 'function';
const RESOURCE = IN_GAME ? window.GetParentResourceName() : 'vinewood_gangs';

const state = {
  mode: 'tablet',
  static: null,
  gang: null,
  tab: 'home',
  selectedZone: null,
  renderId: 0,
};

const $ = (id) => document.getElementById(id);

/* DOM helpers ----------------------------------------------------------- */

function h(tag, props, ...children) {
  const el = document.createElement(tag);
  for (const [key, value] of Object.entries(props || {})) {
    if (value === null || value === undefined || value === false) continue;
    if (key === 'class') el.className = value;
    else if (key === 'text') el.textContent = value;
    else if (key.startsWith('on')) el.addEventListener(key.slice(2).toLowerCase(), value);
    else if (key in el && typeof value !== 'string') el[key] = value;
    else el.setAttribute(key, value === true ? '' : value);
  }
  for (const child of children.flat()) {
    if (child === null || child === undefined || child === false) continue;
    el.append(child instanceof Node ? child : document.createTextNode(String(child)));
  }
  return el;
}

function svg(tag, attrs) {
  const el = document.createElementNS('http://www.w3.org/2000/svg', tag);
  for (const [k, v] of Object.entries(attrs || {})) el.setAttribute(k, v);
  return el;
}

/* NUI bridge ------------------------------------------------------------ */

async function request(action, ...args) {
  if (!IN_GAME) return Mock.request(action, args);
  try {
    const res = await fetch(`https://${RESOURCE}/request`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ action, args }),
    });
    return await res.json();
  } catch (err) {
    return { ok: false, error: 'The tablet lost connection. Close it and try again.' };
  }
}

function postNui(endpoint, payload) {
  if (!IN_GAME) return Promise.resolve();
  return fetch(`https://${RESOURCE}/${endpoint}`, { method: 'POST', body: JSON.stringify(payload || {}) });
}

function closeTablet() {
  hideModal();
  $('device').hidden = true;
  if (IN_GAME) fetch(`https://${RESOURCE}/close`, { method: 'POST', body: '{}' });
}

/* Formatting ------------------------------------------------------------ */

function money(n) {
  const cur = state.static ? state.static.currency : '£';
  const sign = n < 0 ? '-' : '';
  return sign + cur + Math.abs(Math.round(n || 0)).toLocaleString('en-GB');
}

function joinList(items, word) {
  if (items.length <= 1) return items.join('');
  return items.slice(0, -1).join(', ') + ` ${word || 'and'} ` + items[items.length - 1];
}

function timeAgo(ts) {
  const diff = Math.max(0, Date.now() / 1000 - ts);
  if (diff < 60) return 'Just now';
  if (diff < 3600) return `${Math.floor(diff / 60)} min ago`;
  if (diff < 86400) return `${Math.floor(diff / 3600)} hr ago`;
  return new Date(ts * 1000).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' });
}

const TX_TYPES = {
  deposit: 'Deposit',
  withdrawal: 'Withdrawal',
  withdrawal_reversed: 'Withdrawal reversed',
  disband_refund: 'Paid out on disband',
};
function txType(type) {
  if (TX_TYPES[type]) return TX_TYPES[type];
  const s = String(type || '').replace(/_/g, ' ');
  return s.charAt(0).toUpperCase() + s.slice(1);
}

/* Gang colour as the accent, kept readable on the dark screen ------------- */

function hexToRgb(hex) {
  const n = parseInt(hex.slice(1), 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
}
function luminance([r, g, b]) {
  const f = (c) => { c /= 255; return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4; };
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
}
function hexToSoft(hex, alpha) {
  const m = /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(hex || '');
  return m ? `rgba(${parseInt(m[1], 16)}, ${parseInt(m[2], 16)}, ${parseInt(m[3], 16)}, ${alpha})` : null;
}

function applyAccent(hex) {
  const root = document.documentElement.style;
  root.setProperty('--accent-soft', hexToSoft(hex, 0.18) || 'rgba(91, 141, 239, 0.16)');
  if (!/^#[0-9a-f]{6}$/i.test(hex || '')) {
    root.removeProperty('--accent');
    root.removeProperty('--on-accent');
    return;
  }
  const base = hexToRgb(hex);
  let rgb = base;
  for (let t = 0.1; luminance(rgb) < 0.16 && t <= 0.9; t += 0.1) {
    rgb = base.map((c) => Math.round(c + (255 - c) * t));
  }
  root.setProperty('--accent', `rgb(${rgb.join(',')})`);
  root.setProperty('--on-accent', luminance(rgb) > 0.4 ? '#1C2127' : '#FFFFFF');
}

/* Permissions ----------------------------------------------------------- */

function can(permission) {
  const perms = state.gang ? state.gang.permissions || [] : [];
  return perms.includes('*') || perms.includes(permission);
}

/* Toast and modal ------------------------------------------------------- */

let toastTimer;
function toast(message, isError) {
  const el = $('toast');
  el.textContent = message;
  el.classList.toggle('error', !!isError);
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 3200);
}

function showModal(...content) {
  const sheet = $('sheet');
  sheet.replaceChildren(...content);
  $('modal').hidden = false;
  const focusable = sheet.querySelector('input, button.primary, button.danger, button');
  if (focusable) focusable.focus();
}
function hideModal() {
  $('modal').hidden = true;
  $('sheet').classList.remove('wide');
}

function confirmModal({ title, body, confirmLabel, danger, typeToConfirm, onConfirm }) {
  const input = typeToConfirm ? h('input', { type: 'text', 'aria-label': `Type ${typeToConfirm} to confirm` }) : null;
  const confirmBtn = h('button', {
    class: danger ? 'btn danger' : 'btn primary',
    type: 'button',
    disabled: !!typeToConfirm,
    onclick: async () => {
      confirmBtn.disabled = true;
      await onConfirm();
      hideModal();
    },
  }, confirmLabel);
  if (input) input.addEventListener('input', () => { confirmBtn.disabled = input.value.trim() !== typeToConfirm; });

  showModal(
    h('h2', { text: title }),
    h('p', { text: body }),
    input ? h('label', { class: 'field' }, `Type ${typeToConfirm} to confirm`, input) : null,
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      confirmBtn),
  );
}

/* Runs an action, shows the result, then redraws the current tab */
async function act(action, args, successMessage) {
  const res = await request(action, ...(args || []));
  if (res.ok) {
    if (successMessage) toast(successMessage);
    renderTab();
  } else {
    toast(res.error || 'That didn\'t work.', true);
  }
  return res.ok;
}

/* Logo ------------------------------------------------------------------ */

function setLogo(url) {
  const img = $('logo');
  if (!url) { img.hidden = true; img.removeAttribute('src'); return; }
  img.onerror = () => { img.hidden = true; };
  img.onload = () => { img.hidden = false; };
  img.src = url;
}

/* Logo prompt: the boss sees where the logo goes until one is approved */
function openLogoSettings() {
  state.tab = 'settings';
  renderFrame();
  // The settings page renders asynchronously; jump to the logo form once it's there
  setTimeout(() => {
    const block = document.getElementById('logo-block');
    if (block) { block.scrollIntoView({ behavior: 'smooth', block: 'start' }); const input = block.querySelector('input'); if (input) input.focus(); }
  }, 120);
}

function logoPrompt(gang) {
  const btn = $('logo-add');
  const show = state.static.logos && gang.isBoss && !gang.logo;
  btn.hidden = !show;
  if (!show) return;
  const pending = gang.logoStatus === 'pending';
  btn.textContent = pending ? 'Waiting for staff' : 'Add logo';
  btn.classList.toggle('pending', pending);
  btn.title = pending ? 'Your logo is waiting for staff approval' : 'Add a logo for your gang';
  btn.onclick = openLogoSettings;
}

/* Frame ----------------------------------------------------------------- */

const TABS = [
  { id: 'overview', label: 'Overview', icon: 'overview', tint: '#7AA2FF', show: () => true },
  { id: 'members', label: 'Members', icon: 'members', tint: '#5EC2A0', show: () => true },
  { id: 'ranks', label: 'Ranks', icon: 'ranks', tint: '#D2AE5C', show: () => can('manage_ranks') },
  { id: 'territory', label: 'Territory', icon: 'territory', tint: '#5FB4E8', show: () => true },
  { id: 'treasury', label: 'Treasury', icon: 'treasury', tint: '#6CC070', show: () => can('treasury_view') || can('treasury_deposit') || can('treasury_withdraw') },
  { id: 'shop', label: 'Shop', icon: 'shop', tint: '#E39A6B', show: () => state.static.shop },
  { id: 'contracts', label: 'Contracts', icon: 'contracts', tint: '#B793F0', show: () => state.static.contracts },
  { id: 'heists', label: 'Heists', icon: 'vault', tint: '#E88686', show: () => state.static.heists },
  { id: 'airdrop', label: 'Air drop', icon: 'parachute', tint: '#8FB3FF', show: () => state.static.airdrops },
  { id: 'rackets', label: 'Rackets', icon: 'rackets', tint: '#E2BE5A', show: () => state.static.rackets && can('rackets') },
  { id: 'safehouses', label: 'Safehouses', icon: 'safehouses', tint: '#E88686', show: () => state.static.safehouses },
  { id: 'business', label: 'Business', icon: 'business', tint: '#6FD0C0', show: () => state.static.enterprises },
  { id: 'diplomacy', label: 'Diplomacy', icon: 'diplomacy', tint: '#8FB3FF', show: () => state.static.diplomacy },
  { id: 'market', label: 'Black market', icon: 'market', tint: '#D592D2', show: () => state.static.auctions },
  { id: 'tags', label: 'Tags', icon: 'tags', tint: '#F0AD4E', show: () => state.static.graffiti && can('graffiti') },
  { id: 'settings', label: 'Settings', icon: 'settings', tint: '#A6AEB9', show: () => true },
];

/* Tablet shell: home screen and app view (shared with the admin panel) ---- */

function appIcon(app, onOpen, locked) {
  const tile = h('span', { class: 'app-tile', style: `color:${app.tint}` }, icon(app.icon));
  if (locked) tile.append(h('span', { class: 'app-lock' }, icon('lock')));
  return h('button', { type: 'button', class: locked ? 'app-icon is-locked' : 'app-icon', onclick: onOpen, 'aria-label': locked ? `${app.label} (locked)` : app.label },
    tile, h('span', { class: 'app-label', text: app.label }));
}

function showHome(apps) {
  $('app').hidden = true;
  $('home').hidden = false;
  $('apps').replaceChildren(...apps);
}

function showApp(title, canGoHome = true) {
  $('home').hidden = true;
  $('app').hidden = false;
  $('app-title').textContent = title;
  $('back').hidden = !canGoHome;
  $('homebar').hidden = !canGoHome;
}

function goHome() {
  if (!$('modal').hidden) hideModal();
  if (state.mode === 'admin') { admin.tab = 'home'; admin.gangId = null; renderAdminFrame(); return; }
  if (!state.gang) return;
  state.tab = 'home';
  renderFrame();
}

// An app's first heading usually just repeats the name in the bar above: hide it (any buttons beside it stay)
function hideRepeatedTitle() {
  const first = $('view').querySelector('.section-head h2, h2');
  if (!first) return;
  const title = $('app-title').textContent.trim().toLowerCase();
  const text = (first.firstChild && first.firstChild.nodeType === 3 ? first.firstChild.textContent : first.textContent).trim().toLowerCase();
  if (text === title || text.startsWith(title)) first.classList.add('repeated-title');
}

function updateClock() {
  const d = new Date();
  $('clock').textContent = `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
}
setInterval(updateClock, 15000);

function renderFrame() {
  const gang = state.gang;
  updateClock();
  $('home-badge').hidden = true;

  if (!gang) {
    setLogo(null);
    $('logo-add').hidden = true;
    applyAccent(null);
    $('status-title').textContent = '';
    $('tag').textContent = 'Start a crew';
    $('sub').textContent = 'You\'re not in a gang yet.';
    showApp('Start a crew', false);
    renderCreate();
    return;
  }

  applyAccent(gang.colour);
  setLogo(state.static.logos ? gang.logo : null);
  logoPrompt(gang);
  $('status-title').textContent = gang.label;
  $('tag').textContent = gang.label;
  const tier = (state.static.tiers || [])[(gang.tier || 1) - 1];
  $('sub').textContent = tier && state.static.progression ? `${gang.rank}  ·  ${tier.label}` : gang.rank;

  const visible = TABS.filter((t) => t.show());
  if (state.tab !== 'home' && !visible.some((t) => t.id === state.tab)) state.tab = 'home';

  if (state.tab === 'home') {
    showHome(visible.map((t) => appIcon(t, () => { state.tab = t.id; renderFrame(); }, isLocked(TAB_FEATURE[t.id]))));
    return;
  }
  showApp(visible.find((t) => t.id === state.tab).label);
  renderTab();
}

const TAB_FEATURE = { heists: 'heists', rackets: 'rackets', safehouses: 'safehouses', business: 'enterprises', diplomacy: 'diplomacy', market: 'auctions' };

const FEATURE_NAMES = {
  rackets: 'protection rackets', safehouses: 'safehouses', contracts_medium: 'medium-risk contracts',
  enterprises: 'businesses and supply runs', diplomacy: 'diplomacy', second_safehouse: 'a second safehouse',
  auctions: 'the black market', contracts_high: 'high-risk contracts', heists: 'heists',
};
const capitalise = (t) => t.charAt(0).toUpperCase() + t.slice(1);

function tierFor(feature) {
  const tiers = state.static.tiers || [];
  for (let i = 0; i < tiers.length; i += 1) if (tiers[i].unlocks.includes(feature)) return { n: i + 1, label: tiers[i].label };
  return null;
}

function isLocked(feature) {
  return !!(state.static.progression && feature && state.gang && state.gang.unlocks && state.gang.unlocks[feature] === false);
}

function lockedPanel(feature) {
  const t = tierFor(feature);
  return h('div', { class: 'locked' },
    h('div', { class: 'lock-mark', 'aria-hidden': 'true' }),
    h('h2', { text: capitalise(FEATURE_NAMES[feature] || 'Not open yet') }),
    h('p', { text: t ? `Not open to you yet. This opens up when your gang becomes ${/^[AEIOU]/.test(t.label) ? 'an' : 'a'} ${t.label}, and the Overview shows what's still needed.` : 'Not open to you yet. Your gang needs more standing first.' }),
    h('button', { class: 'btn', type: 'button', onclick: () => { state.tab = 'overview'; renderFrame(); } }, 'See what\'s needed in Overview'));
}

async function renderTab() {
  if (state.mode !== 'tablet' || !state.gang) return;
  const id = ++state.renderId;
  if (isLocked(TAB_FEATURE[state.tab])) {
    $('view').replaceChildren(lockedPanel(TAB_FEATURE[state.tab]));
    return;
  }
  const render = {
    overview: renderOverview,
    members: renderMembers,
    ranks: renderRanks,
    territory: renderTerritory,
    treasury: renderTreasury,
    shop: renderShop,
    contracts: renderContracts,
    heists: renderHeists,
    airdrop: renderAirdrop,
    rackets: renderRackets,
    safehouses: renderSafehouses,
    business: renderBusiness,
    diplomacy: renderDiplomacy,
    market: renderMarket,
    tags: renderTags,
    settings: renderSettings,
  }[state.tab];
  const content = await render();
  // Ignore stale renders if the player switched tab while waiting
  if (id !== state.renderId || !content) return;
  $('view').replaceChildren(content);
  hideRepeatedTitle();
}

function loadError(res) {
  return h('p', { class: 'empty', text: res.error || 'Couldn\'t load this page. Close the tablet and try again.' });
}

/* Create ---------------------------------------------------------------- */

function renderCreate() {
  const s = state.static;
  if (!s.allowCreation) {
    $('view').replaceChildren(h('p', { class: 'empty', text: 'Gangs are set up by staff on this server. Speak to them, or get invited by an existing gang.' }));
    return;
  }

  const name = h('input', { type: 'text', maxlength: s.nameMax, autocomplete: 'off', spellcheck: false });
  const label = h('input', { type: 'text', maxlength: 64, autocomplete: 'off' });
  const colour = h('input', { type: 'color', value: '#F2A93B' });
  colour.addEventListener('input', () => applyAccent(colour.value));
  label.addEventListener('input', () => { $('tag').textContent = label.value.trim() || 'Start a crew'; });

  const submit = h('button', {
    class: 'btn primary',
    type: 'button',
    onclick: async () => {
      submit.disabled = true;
      const res = await request('createGang', name.value.trim(), label.value.trim(), colour.value);
      submit.disabled = false;
      if (res.ok) toast('Gang created.');
      else toast(res.error, true);
    },
  }, 'Create gang');

  $('view').replaceChildren(h('div', { class: 'form' },
    h('h2', { text: 'Start your own gang' }),
    h('label', { class: 'field' }, 'Gang name', label,
      h('span', { class: 'hint', text: 'What everyone sees on the tablet and the map.' })),
    h('label', { class: 'field' }, 'Short name', name,
      h('span', { class: 'hint', text: `${s.nameMin} to ${s.nameMax} letters, numbers or underscores. Staff use this to find your gang.` })),
    h('label', { class: 'field' }, 'Colour', colour),
    h('p', { class: 'hint', text: s.creationCost > 0
      ? `Costs ${money(s.creationCost)} from your ${s.creationAccount === 'cash' ? 'cash' : 'bank'}. You'll be the boss.`
      : 'Free to start. You\'ll be the boss.' }),
    h('div', {}, submit),
  ));
  name.focus();
}

/* Overview -------------------------------------------------------------- */

async function renderOverview() {
  const res = await request('getOverview');
  if (!res.ok) return loadError(res);
  const o = res.data;
  if (!o.inGang) return null;

  const lines = [
    h('p', {}, 'You\'re ', h('strong', { text: o.rank }), ' in ', h('strong', { text: o.gang.label }), '.'),
    h('p', {}, h('span', { class: 'fig', text: o.memberCount }), ` of ${o.maxMembers} members, `,
      h('span', { class: 'fig', text: o.onlineCount }), ' online right now.'),
    o.territory.length
      ? h('p', {}, 'You hold ', h('strong', { text: joinList(o.territory) }), '.')
      : h('p', {}, 'You don\'t hold any territory yet.'),
  ];

  if (o.treasury) {
    lines.push(h('p', {},
      h('span', { class: 'fig', text: money(o.treasury.clean) }), ' clean and ',
      h('span', { class: 'fig', text: money(o.treasury.dirty) }), ' dirty in the treasury.'));
  }

  lines.push(h('p', {}, 'Street reputation ', h('span', { class: 'fig', text: o.gang.reputation }), '.'));

  const g = state.gang;
  if (state.static.logos && g && g.isBoss && !g.logo && g.logoStatus !== 'pending') {
    lines.push(h('div', { class: 'nudge' },
      h('span', { text: g.logoStatus === 'rejected' ? 'Staff turned down your last logo. Try another image.' : 'Your gang doesn\'t have a logo yet. It shows at the top of everyone\'s tablet.' }),
      h('button', { class: 'btn small', type: 'button', onclick: openLogoSettings }, 'Add a logo')));
  }

  if (!o.territory.length) {
    lines.push(h('p', { class: 'small', text: 'Influence comes from what you do in an area: tagging walls, dealing and finishing contracts. Build enough and the area becomes yours.' }));
  }

  const news = (o.news || []).map((n) => h('div', { class: 'news-item' },
    h('p', { text: n.text }),
    h('div', { class: 'hint', style: 'margin:0' },
      `${n.minutesLeft} min left`,
      n.progress !== undefined ? h('span', {}, `. Crew pushed back ${n.progress}%`) : null),
    n.progress !== undefined ? h('div', { class: 'bar', style: 'margin-top:6px' }, h('span', { style: `width:${n.progress}%` })) : null));

  return h('div', {},
    h('div', { class: 'brief' }, lines),
    o.progress ? progressBlock(o.progress) : null,
    h('div', { class: 'news' },
      h('h3', { text: 'On the street' }),
      news.length ? news : h('p', { class: 'hint', text: 'Quiet for now.' })));
}

/* Progress -------------------------------------------------------------- */

const MILESTONE_TEXT = {
  reputation: (n) => `Reputation of ${n}`,
  contracts: (n) => `Finish ${n} contracts`,
  tags: (n) => `Spray ${n} tags`,
  members: (n) => `Have ${n} members`,
  areas: (n) => `Hold ${n} ${n === 1 ? 'hex' : 'hexes'} of turf`,
  area_hours: (n) => `${n} hex-hours of turf held`,
  safehouses: (n) => `Own ${n} ${n === 1 ? 'safehouse' : 'safehouses'}`,
  racket_income: (n) => `Collect ${money(n)} from rackets`,
  enterprise_income: (n) => `Make ${money(n)} from business sales`,
};
const MONEY_MILESTONES = { racket_income: true, enterprise_income: true };

function progressBlock(p) {
  const tierLine = h('p', {}, 'The gang is ', h('strong', { text: `${/^[AEIOU]/.test(p.label) ? 'an' : 'a'} ${p.label}` }),
    `, tier ${p.tier} of ${p.max}.`);
  const parts = [h('h3', { text: 'Standing' }), tierLine];

  if (p.slipping && p.regain) {
    parts.push(h('p', { class: 'debit', text: `You've slipped back from ${p.regain.label}. Get your reputation back to ${p.regain.need} to regain it.` }));
  }

  if (!p.next) {
    parts.push(h('p', { class: 'hint', text: 'As high as it goes. Keep your reputation up to stay there.' }));
  } else {
    const done = p.next.requirements.filter((r) => r.done).length;
    parts.push(h('p', { class: 'hint', style: 'margin:0 0 10px', text: `To become ${/^[AEIOU]/.test(p.next.label) ? 'an' : 'a'} ${p.next.label} (${done} of ${p.next.requirements.length} done):` }));
    parts.push(h('div', { class: 'milestones' }, p.next.requirements.map((r) => {
      const pct = Math.min(100, r.need ? (r.have / r.need) * 100 : 100);
      const fmt = MONEY_MILESTONES[r.type] ? money : (n) => n;
      return h('div', { class: r.done ? 'milestone done' : 'milestone' },
        h('div', { class: 'row', style: 'justify-content:space-between' },
          h('span', { text: (MILESTONE_TEXT[r.type] || ((n) => `${r.type} ${n}`))(r.need) }),
          h('span', { class: 'fig', text: r.done ? 'Done' : `${fmt(r.have)} / ${fmt(r.need)}` })),
        h('div', { class: 'bar' }, h('span', { style: `width:${pct}%` })));
    })));
    parts.push(h('p', { class: 'hint', style: 'margin-top:10px', text: `Unlocks ${joinList(p.next.unlocks.map((f) => FEATURE_NAMES[f] || f))}.` }));
  }
  return h('div', { class: 'standing' }, parts);
}

/* Members --------------------------------------------------------------- */

async function renderMembers() {
  const res = await request('getMembers');
  if (!res.ok) return loadError(res);
  const { members, ranks, myGrade, topGrade, maxMembers } = res.data;
  const grades = ranks.map((r) => r.grade).sort((a, b) => a - b);
  const manage = can('manage_members');
  const isBoss = myGrade === topGrade;

  const nextGrade = (g, dir) => {
    const options = dir > 0 ? grades.filter((x) => x > g) : grades.filter((x) => x < g).reverse();
    return options.length ? options[0] : null;
  };

  const rows = members.map((m) => {
    const canManage = manage && !m.me && myGrade > m.grade;
    const up = nextGrade(m.grade, 1);
    const down = nextGrade(m.grade, -1);
    const actions = [];

    if (canManage && up !== null && up < myGrade) {
      actions.push(h('button', { class: 'btn small', type: 'button', onclick: () => act('setGrade', [m.citizenid, up], `${m.name} promoted.`) }, 'Promote'));
    }
    if (canManage && down !== null) {
      actions.push(h('button', { class: 'btn small', type: 'button', onclick: () => act('setGrade', [m.citizenid, down], `${m.name} moved down a rank.`) }, 'Demote'));
    }
    if (isBoss && !m.me) {
      actions.push(h('button', {
        class: 'btn small', type: 'button',
        onclick: () => confirmModal({
          title: `Hand the gang to ${m.name}?`,
          body: 'They become the boss and you drop to the rank below. Only they can undo this.',
          confirmLabel: 'Make boss',
          onConfirm: () => act('transfer', [m.citizenid], `${m.name} is now the boss.`),
        }),
      }, 'Make boss'));
    }
    if (canManage) {
      actions.push(h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Kick ${m.name}?`,
          body: 'They lose access to the tablet and everything the gang owns straight away.',
          confirmLabel: 'Kick member',
          danger: true,
          onConfirm: () => act('kick', [m.citizenid], `${m.name} kicked.`),
        }),
      }, 'Kick'));
    }

    return h('tr', {},
      h('td', {}, m.name, m.me ? h('span', { class: 'you', text: 'you' }) : null),
      h('td', { text: m.rank }),
      h('td', {}, h('span', { class: m.online ? 'status on' : 'status', text: m.online ? 'Online' : 'Offline' })),
      h('td', { class: 'actions' }, actions));
  });

  const security = state.static.informants ? await securitySection() : null;

  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', {}, 'Members ', h('span', { class: 'muted fig', text: `${members.length}/${maxMembers}` })),
      manage ? h('button', { class: 'btn primary', type: 'button', onclick: openInvite, disabled: members.length >= maxMembers }, 'Invite someone') : null),
    h('table', {},
      h('thead', {}, h('tr', {}, h('th', { text: 'Name' }), h('th', { text: 'Rank' }), h('th', { text: 'Status' }), h('th', {}))),
      h('tbody', {}, rows)),
    security);
}

/* Leaders only: things the police knew that they shouldn't have */
async function securitySection() {
  const res = await request('getLeaks');
  if (!res.ok || !res.data.canSee) return null;
  const v = res.data;
  const items = v.leaks.map((l) => h('div', { class: 'news-item' },
    h('p', { text: `The police seemed to know about ${l.detail}.` }),
    h('div', { class: 'hint', style: 'margin:0' }, `${since(l.ago)}.`),
    l.suspects
      ? h('p', { class: 'hint', style: 'margin:6px 0 0;color:var(--chalk)', text: l.suspects.length
        ? `Your contact's shortlist: ${joinList(l.suspects)}. They could be wrong.`
        : 'Your contact came back with nothing.' })
      : h('button', {
        class: 'btn small', type: 'button', style: 'margin-top:8px',
        onclick: () => confirmModal({
          title: 'Look into this?',
          body: `${money(v.cost)} from dirty money buys a shortlist of people who were around when it happened. It usually, but not always, includes whoever talked.`,
          confirmLabel: 'Pay and look into it',
          onConfirm: () => act('investigateLeak', [l.id], 'Shortlist in.'),
        }),
      }, `Look into it (${money(v.cost)})`)));
  return h('div', { class: 'news', style: 'max-width:none' },
    h('h3', { text: 'Security' }),
    items.length ? items : h('p', { class: 'hint', text: 'Nothing suspicious so far.' }));
}

async function openInvite() {
  showModal(h('h2', { text: 'Invite someone' }), h('p', { text: 'Looking for people nearby…' }));
  const res = await request('getNearby');
  if (!res.ok) { hideModal(); toast(res.error, true); return; }

  const people = res.data.map((p) => h('button', {
    class: 'btn', type: 'button',
    onclick: async () => {
      const r = await request('invite', p.id);
      hideModal();
      if (r.ok) toast('Invite sent. They have a minute to accept.');
      else toast(r.error, true);
    },
  }, h('span', { text: p.name || `Person (ID ${p.id})` }), h('span', { class: 'muted', text: `${p.distance}m away` })));

  showModal(
    h('h2', { text: 'Invite someone' }),
    people.length
      ? h('p', { text: 'Pick who to invite. They\'ll get a prompt to join.' })
      : h('p', { text: 'Nobody\'s close enough. Stand within a few metres of the person you want to invite, then try again.' }),
    people.length ? h('div', { class: 'people' }, people) : null,
    h('div', { class: 'buttons' }, h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Close')),
  );
}

/* Ranks ----------------------------------------------------------------- */

async function renderRanks() {
  const res = await request('getMembers');
  if (!res.ok) return loadError(res);
  const { ranks, myGrade, topGrade } = res.data;
  const isBoss = myGrade === topGrade;

  const blocks = ranks.map((rank) => {
    const editable = rank.grade < myGrade || (isBoss && rank.grade === myGrade);
    const isTop = rank.grade === topGrade;
    const label = h('input', { type: 'text', value: rank.label, maxlength: 48, disabled: !editable, 'aria-label': 'Rank name' });

    let permsEl;
    const boxes = [];
    if (isTop) {
      permsEl = h('p', { class: 'muted', text: 'The boss can do everything. This can\'t be changed.' });
    } else {
      permsEl = h('div', { class: 'perms' }, state.static.permissions.map((p) => {
        const owns = can(p.key);
        const box = h('input', { type: 'checkbox', checked: rank.permissions.includes(p.key), disabled: !editable || !owns });
        boxes.push({ key: p.key, box });
        return h('label', { class: editable && owns ? 'check' : 'check locked', title: owns ? '' : 'You can only give out permissions you have yourself.' }, box, p.label);
      }));
    }

    const save = editable ? h('button', {
      class: 'btn', type: 'button',
      onclick: () => act('editRank', [rank.grade, label.value.trim(), boxes.filter((b) => b.box.checked).map((b) => b.key)], 'Rank saved.'),
    }, 'Save rank') : null;

    return h('div', { class: 'rank' },
      h('div', {}, label, !editable ? h('p', { class: 'hint', text: 'Only higher ranks can change this.' }) : null),
      permsEl,
      save);
  });

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Ranks' })),
    h('p', { class: 'hint', text: 'Highest rank first. New members join at the bottom.' }),
    h('div', { class: 'ranks' }, blocks));
}

/* Territory ------------------------------------------------------------- */

let mapDragHandlers = null;
window.addEventListener('mousemove', (e) => { if (mapDragHandlers) mapDragHandlers.move(e); });
window.addEventListener('mouseup', () => { if (mapDragHandlers) mapDragHandlers.up(); });

async function renderTerritory() {
  const res = await request('getTerritory');
  if (!res.ok) return loadError(res);
  return renderHexTerritory(res.data);
}

/* Treasury -------------------------------------------------------------- */

async function renderTreasury() {
  const [res, lres] = await Promise.all([request('getTreasury'), request('getLaundering')]);
  if (!res.ok) return loadError(res);
  const t = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Treasury' }))];

  if (t.balances) {
    parts.push(h('div', { class: 'balances' },
      h('div', { class: 'balance' }, h('div', { class: 'amount', text: money(t.balances.clean) }), h('div', { class: 'what', text: 'Clean money' })),
      h('div', { class: 'balance' }, h('div', { class: 'amount', text: money(t.balances.dirty) }), h('div', { class: 'what', text: 'Dirty money' }))));
  }

  const moves = [];
  const amountInput = () => h('input', { type: 'number', min: 1, max: state.static.maxTransaction, step: 1, inputmode: 'numeric', 'aria-label': 'Amount' });

  if (t.canDeposit) {
    const amount = amountInput();
    moves.push(h('div', {},
      h('h3', { text: 'Pay in' }),
      h('div', { class: 'row' }, amount,
        h('button', { class: 'btn primary', type: 'button', onclick: () => act('deposit', [Number(amount.value)], 'Paid into the treasury.') }, 'Deposit')),
      h('p', { class: 'hint', text: `You've got ${money(t.cash)} on you.` })));
  }
  if (t.canWithdraw) {
    const amount = amountInput();
    moves.push(h('div', {},
      h('h3', { text: 'Take out' }),
      h('div', { class: 'row' }, amount,
        h('button', { class: 'btn', type: 'button', onclick: () => act('withdraw', [Number(amount.value)], 'Taken from the treasury.') }, 'Withdraw')),
      h('p', { class: 'hint', text: 'Comes out as cash. Every withdrawal is logged.' })));
  }
  if (moves.length) parts.push(h('div', { class: 'moves' }, moves));
  if (lres && lres.ok && lres.data.canSee) parts.push(launderSection(lres.data));

  if (t.history) {
    parts.push(h('h3', { text: 'Recent activity' }));
    parts.push(t.history.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'When' }), h('th', { text: 'Who' }), h('th', { text: 'What' }), h('th', { class: 'num', text: 'Amount' }))),
        h('tbody', {}, t.history.map((tx) => h('tr', {},
          h('td', { class: 'muted', text: timeAgo(tx.ts) }),
          h('td', { text: tx.name || 'The gang' }),
          h('td', { text: txType(tx.type) + (tx.account === 'dirty' ? ' (dirty)' : '') }),
          h('td', { class: `num fig ${tx.amount >= 0 ? 'credit' : 'debit'}`, text: (tx.amount >= 0 ? '+' : '') + money(tx.amount) })))))
      : h('p', { class: 'empty', text: 'Nothing has gone in or out yet.' }));
  } else if (!moves.length) {
    parts.push(h('p', { class: 'empty', text: 'Your rank can\'t use the treasury.' }));
  }

  return h('div', {}, parts);
}



/* Laundering ------------------------------------------------------------ */

function launderSection(l) {
  const parts = [h('h3', { text: 'Wash dirty money' }),
    h('p', { class: 'hint', style: 'margin:0 0 12px', text: `Turn dirty money into clean for safehouses, set-up costs and anything legit. You have ${money(l.dirty)} dirty. Washing draws a little heat, and big amounts can catch the police's eye.` })];

  parts.push(h('div', { class: 'offers' }, l.methods.map((m) => {
    const amount = h('input', { type: 'number', min: m.min, max: Math.min(m.left, l.dirty), step: 500, style: 'width:120px', 'aria-label': `Amount to wash with ${m.label}` });
    const result = h('span', { class: 'hint', style: 'margin:0' });
    const update = () => {
      const n = Math.floor(Number(amount.value) || 0);
      result.textContent = n > 0 ? `You get ${money(Math.floor(n * (1 - m.cut)))} clean.` : '';
    };
    amount.addEventListener('input', update);

    let control;
    if (m.blocked === 'tier_locked') {
      const tier = (state.static.tiers || [])[(m.tierNeeded || 1) - 1];
      control = h('span', { class: 'muted', text: `Opens up at ${tier ? tier.label : 'a higher tier'}` });
    } else if (m.blocked) {
      control = h('span', { class: 'muted', style: 'max-width:24ch;text-align:right', text: 'No shops pay you protection yet.' });
    } else if (!l.canWash) {
      control = h('span', { class: 'muted', text: 'Your rank can\'t do this' });
    } else {
      control = h('div', { class: 'bid' },
        h('div', { class: 'row' }, amount, h('button', {
          class: 'btn primary', type: 'button', disabled: m.left < m.min,
          onclick: () => act('launder', [m.key, Number(amount.value)], `Washing. It'll be clean in about ${m.minutes} minutes.`),
        }, 'Wash')),
        result);
    }

    return h('div', { class: m.blocked ? 'offer lot locked-item' : 'offer lot' },
      h('div', {},
        h('h3', { text: m.label }),
        h('p', { text: m.description }),
        h('p', { class: 'hint', text: `Takes a ${Math.round(m.cut * 100)}% cut and about ${m.minutes} minutes. ${m.limit ? `${money(m.left)} of ${money(m.limit)} left today.` : ''}` })),
      control);
  })));

  if (l.washing.length) {
    parts.push(h('p', { class: 'hint', style: 'margin:14px 0 6px', text: 'Being washed now:' }));
    parts.push(h('table', {}, h('tbody', {}, l.washing.map((b) => h('tr', {},
      h('td', { text: b.method }),
      h('td', { class: 'num fig', text: `${money(b.amountIn)} in` }),
      h('td', { class: 'num fig credit', text: `${money(b.amountOut)} out` }),
      h('td', { class: 'num' }, countdown(b.secondsLeft)))))));
  }
  return h('div', { style: 'margin:0 0 26px' }, parts);
}

/* Shop ------------------------------------------------------------------ */

const PAY_TEXT = { cash: 'from your cash', bank: 'from your bank', clean: 'from clean treasury money', dirty: 'from dirty treasury money' };

function itemImage(src) {
  // Plain file names live in web/images; full links (nui://, https://) are used as they are
  if (!src) return null;
  const url = /^(nui|https?):\/\//.test(src) ? src : `images/${src}`;
  return h('img', { class: 'item-img', src: url, alt: '', onerror: (e) => { e.target.style.visibility = 'hidden'; } });
}

async function renderShop() {
  const res = await request('getShop');
  if (!res.ok) return loadError(res);
  const v = res.data;

  const wallet = [`You have ${money(v.cash)} cash and ${money(v.bank)} in the bank.`];
  if (v.canTreasury) wallet.push(`The treasury holds ${money(v.clean)} clean and ${money(v.dirty)} dirty.`);

  const cards = v.items.map((it) => {
    const qty = h('input', { type: 'number', min: 1, max: it.max, step: 1, value: 1, style: 'width:70px', 'aria-label': `How many ${it.label}` });
    const count = () => Math.max(1, Math.min(it.max, Math.floor(Number(qty.value) || 1)));
    const buy = h('button', {
      class: 'btn primary', type: 'button',
      onclick: () => act('shopBuy', [it.item, count()], `Bought ${count() > 1 ? `${count()}x ` : ''}${it.label.toLowerCase()}.`),
    }, `Buy for ${money(it.price)}`);
    qty.addEventListener('input', () => { buy.textContent = `Buy for ${money(it.price * count())}`; });

    let action;
    if (it.blocked === 'tier_locked') {
      const t = (state.static.tiers || [])[it.tier - 1];
      action = h('p', { class: 'hint', style: 'margin:0', text: `Your gang needs to be ${t ? `${/^[AEIOU]/.test(t.label) ? 'an' : 'a'} ${t.label}` : 'bigger'} first.` });
    } else if (it.blocked) {
      action = h('p', { class: 'hint', style: 'margin:0', text: 'Your rank can\'t buy this.' });
    } else {
      action = h('div', { class: 'row', style: 'align-items:center' }, it.max > 1 ? qty : null, buy);
    }

    return h('div', { class: it.blocked ? 'item-card locked-item' : 'item-card' },
      itemImage(it.image),
      h('div', {},
        h('h3', { text: it.label }),
        it.description ? h('p', { class: 'hint', style: 'margin:0 0 6px', text: it.description }) : null,
        h('p', { style: 'margin:0' }, h('span', { class: 'fig', text: money(it.price) }),
          h('span', { class: 'muted', text: ` ${it.max > 1 ? `each (up to ${it.max}), ` : ''}${PAY_TEXT[it.pay] || ''}` }))),
      action);
  });

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Shop' })),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: wallet.join(' ') }),
    cards.length ? h('div', { class: 'item-grid' }, cards) : h('p', { class: 'empty', text: 'Nothing for sale right now.' }));
}

/* Contracts ------------------------------------------------------------- */

const STAGE_TEXT = {
  courier: { pickup: 'Collect the package. It\'s marked on the map.', deliver: 'Get the package to the drop-off.' },
  transport: { steal: 'Find the car and get in. It\'s marked on the map.', deliver: 'Drive the car to the drop-off. Damage cuts the pay.' },
  collect: { find: 'Find the debtor and lean on him.', chase: 'He ran. Catch him before he gets away.', fight: 'He\'s fighting back. Put him down.' },
};

const TIER_TEXT = { 1: 'Low-risk jobs only', 2: 'Trusts you with medium-risk jobs', 3: 'Trusts you with any job' };

function clock(seconds) {
  const m = Math.floor(seconds / 60), sec = seconds % 60;
  return `${m}:${String(sec).padStart(2, '0')}`;
}

/* Hex turf --------------------------------------------------------------- */

const SQ3 = Math.sqrt(3);
function hexCentre(q, r) {
  const o = state.static.hexOrigin || { x: 0, y: 0 };
  const R = state.static.hexSize || 150;
  return [o.x + R * SQ3 * (q + r / 2), o.y + R * 1.5 * r];
}
function hexCorners(q, r) {
  const [cx, cy] = hexCentre(q, r);
  const R = state.static.hexSize || 150;
  return Array.from({ length: 6 }, (_, i) => { const a = (Math.PI / 180) * (60 * i - 30); return [cx + R * Math.cos(a), cy + R * Math.sin(a)]; });
}

function renderHexTerritory(v) {
  const mine = v.hexes.filter((x) => x.mine);
  const rivals = v.hexes.filter((x) => !x.mine);
  const accent = (state.gang && state.gang.colour) || '#5B8DEF';
  let picked = null;

  // Map: the atlas, our hexes shaded by control, rivals we've found, and ground we could buy
  const map = svg('svg', { class: 'map has-picture', role: 'img', 'aria-label': 'Turf map' });
  const tm = state.static.tabletMap;
  if (tm && tm.image) {
    const left = (0 - tm.offsetX) / tm.scaleX + (tm.nudgeX || 0);
    const top = (0 - tm.offsetY) / tm.scaleY + (tm.nudgeY || 0);
    map.append(svg('image', { href: tm.image, x: left, y: -top, width: tm.size / tm.scaleX, height: tm.size / Math.abs(tm.scaleY), preserveAspectRatio: 'none' }));
  }
  const all = [...v.hexes, ...v.options];
  const pts = all.flatMap((x) => hexCorners(x.q, x.r));
  const xs = pts.map((p) => p[0]), ys = pts.map((p) => p[1]);
  const fit = pts.length
    ? { cx: (Math.min(...xs) + Math.max(...xs)) / 2, cy: (Math.min(...ys) + Math.max(...ys)) / 2, half: Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys), 600) / 2 * 1.25 }
    : { cx: 0, cy: -800, half: 2500 };
  let view = { ...fit };
  const apply = () => map.setAttribute('viewBox', `${view.cx - view.half} ${-view.cy - view.half} ${view.half * 2} ${view.half * 2}`);
  const polys = {};
  const draw = (x, kind) => {
    const colour = kind === 'option' ? '#ffffff' : (x.owner ? x.owner.colour : accent);
    const poly = svg('polygon', {
      points: hexCorners(x.q, x.r).map(([px, py]) => `${px},${-py}`).join(' '),
      fill: kind === 'option' ? 'rgba(255,255,255,0.08)' : colour,
      'fill-opacity': kind === 'mine' ? 0.2 + 0.55 * ((x.control || 0) / 100) : (kind === 'rival' ? 0.45 : 1),
      stroke: kind === 'option' ? '#ffffff' : '#1C2127', 'stroke-width': kind === 'option' ? 1.5 : 1.2,
      'stroke-dasharray': kind === 'option' ? '6 5' : '', 'vector-effect': 'non-scaling-stroke', class: `hex hex-${kind}`,
    });
    const [cx, cy] = hexCentre(x.q, x.r);
    const label = svg('text', { x: cx, y: -cy, 'text-anchor': 'middle', 'dominant-baseline': 'middle', class: 'hex-label' });
    label.textContent = kind === 'mine' ? `${x.main ? '★ ' : ''}${Math.round(x.control)}%` : (kind === 'rival' ? (x.owner ? x.owner.label : '?') : '+');
    poly.addEventListener('click', () => { if (!dragged) pick(x, kind); });
    map.append(poly, label);
    polys[x.key] = poly;
  };
  v.options.forEach((x) => draw(x, 'option'));
  rivals.forEach((x) => draw(x, 'rival'));
  mine.forEach((x) => draw(x, 'mine'));
  map.querySelectorAll('.hex-label').forEach((t) => t.setAttribute('font-size', (state.static.hexSize || 150) * 0.32));

  // Scroll to zoom, drag to move (same feel as the area map)
  let drag = null, dragged = false;
  map.addEventListener('wheel', (e) => {
    e.preventDefault();
    const r = map.getBoundingClientRect();
    const fx = (e.clientX - r.left) / (r.width || 1), fy = (e.clientY - r.top) / (r.height || 1);
    const wx = view.cx - view.half + fx * 2 * view.half, wy = -view.cy - view.half + fy * 2 * view.half;
    const half = Math.min(6000, Math.max(250, view.half * (e.deltaY > 0 ? 1.25 : 0.8)));
    view = { cx: wx - fx * 2 * half + half, cy: -(wy - fy * 2 * half + half), half };
    apply();
  }, { passive: false });
  map.addEventListener('mousedown', (e) => { drag = { x: e.clientX, y: e.clientY, view: { ...view } }; dragged = false; });
  mapDragHandlers = {
    move: (e) => {
      if (!drag || !map.isConnected) return;
      const r = map.getBoundingClientRect();
      if (Math.abs(e.clientX - drag.x) + Math.abs(e.clientY - drag.y) > 4) dragged = true;
      view = { cx: drag.view.cx - (e.clientX - drag.x) / (r.width || 1) * 2 * drag.view.half, cy: drag.view.cy + (e.clientY - drag.y) / (r.height || 1) * 2 * drag.view.half, half: drag.view.half };
      apply();
    },
    up: () => { drag = null; setTimeout(() => { dragged = false; }, 0); },
  };
  apply();

  // Side panel
  const cost = v.cost;
  const costText = [cost.money ? `${money(cost.money)} ${cost.account === 'clean' ? 'clean' : 'dirty'} money` : null, cost.item && cost.count ? `${cost.count} x ${cost.item} from your pockets` : null].filter(Boolean).join(' and ') || 'nothing';
  const buyBox = h('div', { class: 'hex-buy' });
  const showBuy = () => {
    if (!picked || picked.kind !== 'option') {
      buyBox.replaceChildren(h('p', { class: 'hint', style: 'margin:0', text: v.options.length
        ? 'Tap a dashed hex on the map to buy that ground.'
        : `Get one of your hexes to ${v.expandAt}% control and the ground around it opens up to buy.` }));
      return;
    }
    const x = picked.x;
    buyBox.replaceChildren(
      h('div', { style: 'font-weight:600', text: x.label }),
      h('p', { class: 'hint', style: 'margin:2px 0 10px', text: `Costs ${costText}. It starts at a low control %, so sell there straight away. If someone already runs it, you'll find out who.` }),
      v.canExpand
        ? h('button', { class: 'btn primary', type: 'button', onclick: () => confirmModal({ title: `Buy ${x.label}?`, body: `This costs ${costText}.`, confirmLabel: 'Buy it', onConfirm: () => act('hexExpand', [x.q, x.r], 'It\'s yours. Sell there to build it up.') }) }, 'Buy this ground')
        : h('p', { class: 'hint debit', style: 'margin:0', text: 'Your rank can\'t buy new turf.' }));
  };
  const pick = (x, kind) => {
    picked = { x, kind };
    Object.values(polys).forEach((p) => p.classList.remove('picked'));
    if (polys[x.key]) polys[x.key].classList.add('picked');
    showBuy();
  };
  showBuy();

  const rows = mine.sort((a, b) => (b.main ? 1 : 0) - (a.main ? 1 : 0) || b.control - a.control).map((x) => h('button', {
    class: 'hex-row', type: 'button', onclick: () => { pick(x, 'mine'); const [cx, cy] = hexCentre(x.q, x.r); view = { cx, cy, half: 700 }; apply(); },
  },
    h('span', { class: 'hex-row-head' },
      h('strong', { text: x.label }),
      x.main ? h('span', { class: 'badge', text: 'Main' }) : (x.compound ? h('span', { class: 'badge muted', text: 'Compound' }) : null),
      h('span', { class: 'fig', text: `${Math.round(x.control)}%` })),
    h('span', { class: 'bar' }, h('span', { style: `width:${Math.min(100, x.control)}%;background:${x.control >= v.expandAt ? '#6CC070' : (x.control < 25 ? '#E5484D' : accent)}` }))));

  const sprays = v.sprays;
  const side = h('div', { class: 'hex-side' },
    h('div', { class: 'hex-stats' },
      h('div', {}, h('div', { class: 'eyebrow', text: 'Turf' }), h('div', { class: 'big fig', text: `${mine.length} ${mine.length === 1 ? 'hex' : 'hexes'}` })),
      h('div', {}, h('div', { class: 'eyebrow', text: 'Tags' }), h('div', { class: 'big fig', text: `${sprays.used} of ${sprays.slots}` }))),
    h('p', { class: 'hint', style: 'margin:0', text: `Sell ${joinList(v.turfDrugs, 'or')} on your turf to build control (+${v.controlPerSale}% each). Every hex loses ${v.decayPerHour}% an hour, and rivals dealing on it cost you. Your first tag goes on your main hex, and you get another for every ${sprays.every} hexes.` }),
    h('div', { class: 'hex-list' }, rows.length ? rows : [h('p', { class: 'empty', text: 'Your gang has no turf yet. Staff set up your compound.' })]),
    h('h3', { style: 'margin:6px 0 0', text: 'Buy new ground' }),
    buyBox,
    rivals.length ? h('div', {}, h('h3', { style: 'margin:6px 0 6px', text: 'Rival turf you\'ve found' }),
      h('div', { class: 'hex-list' }, rivals.map((x) => h('div', { class: 'hex-rival' }, h('span', { class: 'swatch', style: `background:${x.owner ? x.owner.colour : '#888'}` }), h('span', { text: x.label }), h('span', { class: 'muted', text: x.owner ? x.owner.label : '' }))))) : null);

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Territory' })),
    h('div', { class: 'territory' },
      h('div', { class: 'map-box' }, map,
        h('div', { class: 'map-tools' },
          h('span', { class: 'hint', style: 'margin:0', text: 'Scroll to zoom, drag to move. Rival turf only shows once your gang has dealt on it.' }),
          h('button', { class: 'btn small', type: 'button', onclick: () => { view = { ...fit }; apply(); } }, 'Our turf'))),
      side));
}

/* Air drop -------------------------------------------------------------- */

// Map picture pixel <-> world coordinates, from the Territory map calibration
function mapToWorld(px, py) {
  const tm = state.static.tabletMap;
  return { x: (px - tm.offsetX) / tm.scaleX - (tm.nudgeX || 0), y: (py - tm.offsetY) / tm.scaleY - (tm.nudgeY || 0) };
}
function worldToMap(x, y) {
  const tm = state.static.tabletMap;
  return { px: (x + (tm.nudgeX || 0)) * tm.scaleX + tm.offsetX, py: (y + (tm.nudgeY || 0)) * tm.scaleY + tm.offsetY };
}

async function renderAirdrop() {
  const res = await request('getAirdrop');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const tm = state.static.tabletMap;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Air drop' }))];

  if (v.active) {
    const a = v.active;
    const label = { called: 'Plane on its way', flying: 'Plane overhead, crate falling', landed: 'Crate on the ground' }[a.state] || a.state;
    parts.push(h('div', { class: 'heist-active' },
      h('div', { class: 'row', style: 'justify-content:space-between;align-items:center' },
        h('div', {}, h('div', { class: 'eyebrow', text: 'Your drop' }), h('h3', { style: 'margin:2px 0 0', text: label })),
        a.state === 'called' ? h('div', { style: 'text-align:right' }, h('div', { class: 'eyebrow', text: 'Arrives in' }), countdown(a.arrivesIn)) : null),
      h('div', { class: 'row', style: 'justify-content:space-between;align-items:center' },
        h('span', { class: 'hint', style: 'margin:0', text: 'Look for the red circle on your map and the red smoke. Anyone can open it, so get there first.' }),
        waypointButton(a.x, a.y))));
  }

  const costText = `Costs ${money(v.cost)} ${v.account === 'clean' ? 'clean' : 'dirty'} money${v.item ? ` and ${v.item.count} x ${v.item.label}` : ''}. The treasury has ${money(v.balance)}.`;
  parts.push(h('p', { class: 'hint', style: 'margin:0 0 14px', text: `A smuggler flies in low and drops a crate of gear wherever you choose. ${costText} One drop every ${Math.round(v.cooldownMins / 60 * 10) / 10} hours.` }));

  if (!v.canCall) {
    parts.push(h('p', { class: 'empty', text: 'Only gang management can call in air drops.' }));
    return h('div', {}, parts);
  }
  if (v.active) return h('div', {}, parts);

  // Where: tap the map (zoom in for detail) or use the waypoint
  let pick = null;
  let zoom = 1;
  const marker = h('span', { class: 'drop-marker', hidden: true });
  const img = h('img', { class: 'drop-map-img', src: tm && tm.image ? tm.image : '', alt: 'Map of San Andreas', draggable: 'false' });
  const inner = h('div', { class: 'drop-map-inner' }, img, marker);
  const frame = h('div', { class: 'drop-map' }, inner);
  const where = h('span', { class: 'hint', style: 'margin:0', text: 'Tap the map where you want it, or use your waypoint.' });
  const call = h('button', { class: 'btn primary', type: 'button', disabled: true }, 'Call it in');

  const place = (x, y) => {
    const b = v.bounds;
    if (x < b.minX || x > b.maxX || y < b.minY || y > b.maxY) { toast('The plane can\'t drop there.', true); return; }
    pick = { x, y };
    const m = worldToMap(x, y);
    marker.style.left = `${(m.px / tm.size) * 100}%`;
    marker.style.top = `${(m.py / tm.size) * 100}%`;
    marker.hidden = false;
    where.textContent = `Dropping at ${Math.round(x)}, ${Math.round(y)}.`;
    call.disabled = v.waitFor > 0 || v.busy;
  };
  img.addEventListener('click', (e) => {
    const r = img.getBoundingClientRect();
    const px = ((e.clientX - r.left) / r.width) * tm.size;
    const py = ((e.clientY - r.top) / r.height) * tm.size;
    const w = mapToWorld(px, py);
    place(w.x, w.y);
  });
  const setZoom = (z) => {
    zoom = Math.max(1, Math.min(4, z));
    inner.style.width = `${zoom * 100}%`;
    // Keep the picked spot (or the middle) in view
    requestAnimationFrame(() => {
      const fx = pick ? worldToMap(pick.x, pick.y).px / tm.size : 0.5;
      const fy = pick ? worldToMap(pick.x, pick.y).py / tm.size : 0.5;
      frame.scrollLeft = fx * frame.scrollWidth - frame.clientWidth / 2;
      frame.scrollTop = fy * frame.scrollHeight - frame.clientHeight / 2;
    });
  };

  call.addEventListener('click', () => confirmModal({
    title: 'Call in the air drop?', body: `${costText} The plane arrives in a few minutes, and the area shows on the map${state.static.airdropShowTo === 'caller' ? ' for your gang' : ' for everyone'}.`,
    confirmLabel: 'Call it in',
    onConfirm: async () => {
      if (IN_GAME) {
        const r = await postNui('airdropCheck', pick);
        const check = r && r.json ? await r.json() : { ok: true };
        if (!check.ok) { toast('That\'s water. Pick a spot on land.', true); return; }
      }
      act('airdropCall', [pick.x, pick.y], 'Called in. Watch the sky.');
    },
  }));

  parts.push(h('div', { class: 'drop-wrap' },
    frame,
    h('div', { class: 'drop-side' },
      h('h3', { style: 'margin:0', text: 'Where should it land?' }),
      where,
      h('div', { class: 'row' },
        h('button', { class: 'btn small', type: 'button', 'aria-label': 'Zoom out', onclick: () => setZoom(zoom / 2) }, '−'),
        h('button', { class: 'btn small', type: 'button', 'aria-label': 'Zoom in', onclick: () => setZoom(zoom * 2) }, '+'),
        h('button', {
          class: 'btn small', type: 'button',
          onclick: async () => {
            if (!IN_GAME) return place(1700, 3300);
            const r = await postNui('airdropWaypoint');
            const data = r && r.json ? await r.json() : null;
            if (data && data.ok) place(data.x, data.y); else toast('Set a waypoint on your map first.', true);
          },
        }, 'Use my waypoint')),
      h('p', { class: 'hint', style: 'margin:0', text: 'The plane arrives a few minutes after you call it. The crate lands inside a red circle on the map, with red smoke so you can spot it. Whoever opens it first gets everything inside.' }),
      v.waitFor > 0 ? h('p', { class: 'hint debit', style: 'margin:0' }, 'Not yet. Ready in ', countdown(v.waitFor), '.') : null,
      v.busy ? h('p', { class: 'hint debit', style: 'margin:0', text: 'Another drop is already in the air. Try again soon.' }) : null,
      h('div', {}, call))));
  return h('div', {}, parts);
}

/* Heists ---------------------------------------------------------------- */

const HEIST_BLOCKED = {
  heist_in_progress: 'Another crew is on this one right now.',
  heist_already_running: 'Your gang is already on a heist.',
  heist_cooldown: 'Still on lockdown after the last job.',
  heist_gang_cooldown: 'Your gang needs to lie low first.',
  heist_not_enough_police: 'Not enough police around to make it worth it.',
  tier_locked: 'Your gang isn\'t big enough for this yet.',
  no_permission: 'Your rank can\'t start heists.',
};

async function renderHeists() {
  const res = await request('getHeists');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const parts = [];

  // The job in progress
  if (v.active) {
    const a = v.active;
    const steps = a.steps.map((s) => h('li', { class: s.done ? 'heist-step done' : (s.available ? 'heist-step now' : 'heist-step') },
      h('span', { class: 'heist-dot' }),
      h('span', { text: s.label }),
      s.done ? h('span', { class: 'muted', text: 'Done' }) : (s.available ? h('span', { class: 'heist-now', text: s.busy ? 'Someone\'s on it' : 'Now' }) : null)));
    if (a.escape) steps.push(h('li', { class: 'heist-step now' }, h('span', { class: 'heist-dot' }), h('span', { text: 'Get clear of the area' }), h('span', { class: 'heist-now', text: 'Now' })));
    parts.push(h('div', { class: 'heist-active' },
      h('div', { class: 'row', style: 'justify-content:space-between;align-items:center' },
        h('div', {}, h('div', { class: 'eyebrow', text: 'In progress' }), h('h3', { style: 'margin:2px 0 0', text: a.label })),
        h('div', { style: 'text-align:right' }, h('div', { class: 'eyebrow', text: 'Time left' }), countdown(a.endsAt))),
      h('ol', { class: 'heist-steps' }, steps),
      h('div', { class: 'row', style: 'justify-content:space-between;align-items:center' },
        h('span', { class: 'hint', style: 'margin:0', text: `${a.alarm === 'loud' ? 'The alarm is going off. ' : (a.alarm === 'silent' ? 'A silent alarm may have been tripped. ' : '')}Loot so far: ${money(a.loot)} to the treasury.` }),
        v.canStart ? h('button', {
          class: 'btn small danger', type: 'button',
          onclick: () => confirmModal({ title: 'Call it off?', body: 'The heist ends now. Anything already taken is kept, but the place goes on lockdown.', confirmLabel: 'Call it off', danger: true, onConfirm: () => act('heistAbandon', [], 'Called off.') }),
        }, 'Call it off') : null)));
  }

  // What's out there
  parts.push(h('p', { class: 'hint', style: 'margin:0 0 14px', text: v.canStart
    ? 'Get the crew together at the start point and press E there. Each job needs enough police on duty to be worth it.'
    : 'Someone with the right rank starts a heist; then anyone in the gang can help with the steps.' }));
  if (!v.heists.length) parts.push(h('p', { class: 'empty', text: 'No heists are set up on this server yet.' }));
  parts.push(h('div', { class: 'heist-list' }, v.heists.map((x) => h('div', { class: 'heist-row' },
    h('div', {},
      h('div', { style: 'font-weight:600', text: x.label }),
      h('div', { class: 'hint', style: 'margin:0', text: `${x.area || 'No area'}  ·  ${x.crew} crew  ·  ${x.steps} steps` }),
      x.blocked ? h('div', { class: 'hint debit', style: 'margin:2px 0 0' }, HEIST_BLOCKED[x.blocked] || 'Not available right now.', x.readyIn ? h('span', {}, ' Ready in ', countdown(x.readyIn)) : null)
        : h('div', { class: 'hint credit', style: 'margin:2px 0 0', text: 'Ready when you are.' })),
    waypointButton(x.x, x.y)))));
  return h('div', {}, h('div', { class: 'section-head' }, h('h2', { text: 'Heists' })), ...parts);
}

async function renderContracts() {
  const res = await request('getContracts');
  if (!res.ok) return loadError(res);
  const { offers, active, contacts, canAccept } = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Contracts' }))];

  if (active) {
    const stage = (STAGE_TEXT[active.template] || {})[active.stage] || '';
    const timer = h('span', { class: 'fig', text: clock(active.secondsLeft) });
    // Count down locally while the page is open
    let left = active.secondsLeft;
    const tick = setInterval(() => {
      if (!timer.isConnected) return clearInterval(tick);
      left = Math.max(0, left - 1);
      timer.textContent = clock(left);
    }, 1000);

    parts.push(h('div', { class: 'job-now' },
      h('h3', { text: active.title }),
      h('p', { class: 'lead', text: stage }),
      h('p', { class: 'hint', text: active.description }),
      h('div', { class: 'row', style: 'margin-top:14px' },
        h('p', { style: 'margin:0' }, active.isRunner ? 'You\'re running this. ' : `${active.runner} is running this. `, timer, ' left, pays up to ', h('span', { class: 'fig', text: money(active.reward) }), '.'),
        (active.isRunner || canAccept) ? h('button', {
          class: 'btn danger small', type: 'button',
          onclick: () => confirmModal({
            title: 'Abandon this job?',
            body: 'It counts as a failure, and the contact will trust you less.',
            confirmLabel: 'Abandon job',
            danger: true,
            onConfirm: () => act('abandonContract', [], 'Job abandoned.'),
          }),
        }, 'Abandon') : null)));
  }

  parts.push(h('h3', { text: 'On the board' }));
  if (!offers.length) {
    parts.push(h('p', { class: 'empty', style: 'margin-bottom:30px', text: 'No work right now. New jobs come in every few minutes while someone in the gang is online.' }));
  } else {
    parts.push(h('div', { class: 'offers' }, offers.map((o) => h('div', { class: 'offer' },
      h('div', {},
        h('h3', {}, o.title, h('span', { class: 'from', text: ` from ${o.contact}` }), o.special ? h('span', { class: 'badge', style: 'margin-left:8px', text: 'Special' }) : null),
        h('p', { text: o.description }),
        o.extras ? h('p', { class: 'hint credit', style: 'margin:0', text: `Also: ${o.extras.join(', ')}` }) : null,
        h('p', { class: 'hint' },
          h('span', { class: `risk-${o.level}`, text: o.difficulty }),
          `. ${o.minutes} minutes to finish. Offer ends in ${Math.max(1, Math.round(o.expiresIn / 60))} min.`)),
      h('div', { class: 'pay' }, o.reward > 0 ? money(o.reward) : h('span', { text: 'Gear' }), h('small', { text: o.reward > 0 ? (o.account === 'dirty' ? 'dirty money' : 'clean money') : 'see below' })),
      h('button', {
        class: 'btn primary', type: 'button',
        disabled: !!active || !canAccept,
        title: !canAccept ? 'Your rank can\'t take contracts.' : (active ? 'Finish the current job first.' : ''),
        onclick: () => act('acceptContract', [o.id], 'Job taken. It\'s marked on your map.'),
      }, 'Take job')))));
  }
  if (!canAccept) parts.push(h('p', { class: 'hint', style: 'margin:-18px 0 30px', text: 'Your rank can see the board but can\'t take jobs.' }));

  parts.push(h('h3', { text: 'Contacts' }));
  parts.push(h('div', { class: 'contacts' }, contacts.map((c) => {
    const pct = c.nextAt ? Math.min(100, (c.trust / c.nextAt) * 100) : 100;
    return h('div', { class: 'contact' },
      h('div', { class: 'name', text: c.label }),
      h('div', { class: 'hint', style: 'margin:2px 0 0', text: TIER_TEXT[c.tier] || '' }),
      h('div', { class: 'bar' }, h('span', { style: `width:${pct}%` })),
      h('div', { class: 'hint', text: c.nextAt ? `Trust ${c.trust} of ${c.nextAt} for the next level` : `Trust ${c.trust}, highest level` }));
  })));

  return h('div', {}, parts);
}


/* Rackets --------------------------------------------------------------- */

function since(seconds) {
  if (seconds < 120) return 'just now';
  if (seconds < 3600) return `${Math.floor(seconds / 60)} min ago`;
  const hours = Math.floor(seconds / 3600);
  return `${hours} ${hours === 1 ? 'hour' : 'hours'} ago`;
}

function waypointButton(x, y) {
  return h('button', { class: 'btn small', type: 'button', onclick: () => { postNui('waypoint', { x, y }); toast('Waypoint set.'); } }, 'Waypoint');
}

const ODDS_TEXT = { good: 'They look like they\'ll listen.', fair: 'Could go either way.', slim: 'They don\'t look scared of you yet.' };
const BLOCKED_TEXT = {
  racket_cooldown: 'Turned you down recently.',
  racket_rival_stronger: 'The gang they pay has more pull here.',
};

async function renderRackets() {
  const res = await request('getRackets');
  if (!res.ok) return loadError(res);
  const r = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Rackets' }))];

  const owedTotal = r.mine.reduce((sum, b) => sum + b.owed, 0);
  parts.push(h('p', { class: 'hint', style: 'margin-bottom:18px', text: r.mine.length
    ? `${r.mine.length} ${r.mine.length === 1 ? 'business pays' : 'businesses pay'} you. ${money(owedTotal)} is waiting to be collected. Each one adds its rate every ${r.minutes} minutes, up to ${r.maxPeriods} times over, and stops paying if nobody calls round.`
    : `Nobody pays you yet. Build at least ${r.minInfluence} influence in an area, then walk into a shop there and talk business.` }));

  if (r.mine.length) {
    parts.push(h('table', {},
      h('thead', {}, h('tr', {}, h('th', { text: 'Business' }), h('th', { class: 'num', text: 'Rate' }), h('th', { class: 'num', text: 'Waiting' }), h('th', { text: 'Last collected' }), h('th', {}))),
      h('tbody', {}, r.mine.map((b) => h('tr', {},
        h('td', {}, h('strong', { text: b.label }), h('div', { class: 'hint', style: 'margin:0', text: b.area || 'Outside any area' })),
        h('td', { class: 'num fig', text: money(b.income) }),
        h('td', { class: `num fig ${b.full ? 'credit' : ''}`, text: money(b.owed) + (b.full ? ' (full)' : '') }),
        h('td', {}, since(b.lastCollected),
          b.lapsesIn < 3600 ? h('div', { class: 'hint debit', style: 'margin:0', text: 'Will stop paying soon' }) : null),
        h('td', { class: 'actions' },
          waypointButton(b.x, b.y),
          r.canWork ? h('button', {
            class: 'btn small danger', type: 'button',
            onclick: () => confirmModal({
              title: `Stop protecting ${b.label}?`,
              body: 'Anything they owe is lost, and another gang can move in.',
              confirmLabel: 'Stop protecting',
              danger: true,
              onConfirm: () => act('dropRacket', [b.key], 'Protection dropped.'),
            }),
          }, 'Drop') : null))))));
  }

  parts.push(h('h3', { style: 'margin-top:28px', text: 'Businesses in your areas' }));
  if (!r.prospects.length) {
    parts.push(h('p', { class: 'empty', text: 'No other businesses where your gang has enough pull. Grow your influence to open up more.' }));
  } else {
    parts.push(h('div', { class: 'offers' }, r.prospects.map((b) => h('div', { class: 'offer' },
      h('div', {},
        h('h3', { text: b.label }),
        h('p', { class: 'hint', text: `${b.area}. ${b.protectedBy ? `Pays ${b.protectedBy}.` : 'Not paying anyone.'} ${BLOCKED_TEXT[b.blocked] || ODDS_TEXT[b.odds] || ''}` })),
      h('div', { class: 'pay' }, money(b.income), h('small', { text: `every ${r.minutes} min` })),
      waypointButton(b.x, b.y)))));
  }
  return h('div', {}, parts);
}


/* Safehouses ------------------------------------------------------------ */

function duration(seconds) {
  const s = Math.abs(seconds);
  if (s < 3600) return `${Math.max(1, Math.round(s / 60))} min`;
  if (s < 86400) return `${Math.round(s / 3600)} hr`;
  const d = Math.round(s / 86400);
  return `${d} ${d === 1 ? 'day' : 'days'}`;
}

function upgradeRow(label, detail, price, owned, onBuy, isBoss) {
  return h('div', { class: 'upgrade' },
    h('div', {}, h('div', { class: 'name', text: label }), h('div', { class: 'hint', style: 'margin:0', text: detail })),
    owned ? h('span', { class: 'muted', text: 'Fitted' })
      : (isBoss && price ? h('button', { class: 'btn small', type: 'button', onclick: onBuy }, `Buy for ${money(price)}`) : h('span', { class: 'muted', text: price ? money(price) : '' })));
}

async function renderSafehouses() {
  const res = await request('getSafehouses');
  if (!res.ok) return loadError(res);
  const s = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', {}, 'Safehouses ', h('span', { class: 'muted fig', text: `${s.mine.length}/${s.max}` })))];

  if (!s.mine.length) {
    parts.push(h('p', { class: 'empty', style: 'margin-bottom:24px', text: s.isBoss
      ? 'Your gang doesn\'t have a safehouse yet. Buy one below with money from the clean treasury.'
      : 'Your gang doesn\'t have a safehouse yet. The boss can buy one from here.' }));
  }

  s.mine.forEach((h_) => {
    const u = h_.upgrades;
    const overdue = h_.paidFor < 0;
    const stashDetail = u.stash.nextPrice ? `${u.stash.slots} slots now, ${u.stash.nextSlots} with the next upgrade` : `${u.stash.slots} slots, the biggest it gets`;
    parts.push(h('div', { class: 'house' },
      h('div', { class: 'house-head' },
        h('div', {},
          h('h3', { text: h_.label }),
          h('p', { class: 'hint', style: 'margin:0', text: `${h_.address}${h_.area ? `, ${h_.area}` : ''}` })),
        h('div', { class: 'design-actions' },
          waypointButton(h_.x, h_.y),
          s.isBoss ? h('button', {
            class: 'btn small danger', type: 'button',
            onclick: () => confirmModal({
              title: `Sell ${h_.label}?`,
              body: `${money(h_.refund)} goes back into the clean treasury. Anything left in the stash is lost to you.`,
              confirmLabel: 'Sell safehouse',
              danger: true,
              typeToConfirm: h_.label,
              onConfirm: () => act('sellSafehouse', [h_.id], 'Safehouse sold.'),
            }),
          }, 'Sell') : null)),
      h_.breached ? h('p', { class: 'debit', style: 'margin:10px 0 0', text: 'Police have breached the door. It\'s open to them for a few more minutes.' }) : null,
      h('p', { class: overdue ? 'debit' : 'hint', style: 'margin:10px 0 14px', text: overdue
        ? `Upkeep of ${money(h_.upkeep)} a day is ${duration(h_.paidFor)} overdue. It will be repossessed after ${s.graceDays} days unpaid.`
        : `Upkeep ${money(h_.upkeep)} a day from the clean treasury. Paid for the next ${duration(h_.paidFor)}.` }),
      h('div', { class: 'upgrades' },
        upgradeRow('Stash', stashDetail, u.stash.nextPrice, !u.stash.nextPrice, () => act('upgradeSafehouse', [h_.id, 'stash'], 'Stash upgraded.'), s.isBoss),
        upgradeRow('CCTV', 'Warns everyone in the gang when police start a raid', u.cctv.price, u.cctv.owned, () => act('upgradeSafehouse', [h_.id, 'cctv'], 'CCTV fitted.'), s.isBoss),
        upgradeRow('Reinforced door', 'Takes police twice as long to breach', u.door.price, u.door.owned, () => act('upgradeSafehouse', [h_.id, 'door'], 'Door reinforced.'), s.isBoss))));
  });

  parts.push(h('h3', { style: 'margin-top:28px', text: 'On the market' }));
  if (!s.available.length) {
    parts.push(h('p', { class: 'empty', text: 'Nothing for sale right now.' }));
  } else {
    const full = s.mine.length >= s.max;
    parts.push(h('div', { class: 'offers' }, s.available.map((a) => h('div', { class: 'offer' },
      h('div', {}, h('h3', { text: a.label }), h('p', { class: 'hint', text: `${a.address}${a.area ? `, ${a.area}` : ''}. Upkeep ${money(a.upkeep)} a day.` })),
      h('div', { class: 'pay' }, money(a.price)),
      h('div', { class: 'design-actions' },
        waypointButton(a.x, a.y),
        s.isBoss ? h('button', {
          class: 'btn primary', type: 'button', disabled: full, title: full ? 'Your gang already has the most safehouses it can own.' : '',
          onclick: () => confirmModal({
            title: `Buy ${a.label}?`,
            body: `${money(a.price)} comes out of the clean treasury now, then ${money(a.upkeep)} a day.`,
            confirmLabel: 'Buy safehouse',
            onConfirm: () => act('buySafehouse', [a.id], 'Safehouse bought.'),
          }),
        }, 'Buy') : null)))));
  }
  return h('div', {}, parts);
}


/* Business (enterprises and supplies) ------------------------------------ */

const MARKET_TEXT = { high: 'Wholesale prices are high right now.', low: 'Wholesale prices are low right now.', normal: 'Wholesale prices are normal.' };
const SHIPMENT_STATUS = {
  waiting: 'On its way', ready: 'Waiting to be collected', in_transit: 'Van on the road',
  delivered: 'Delivered', stolen: 'Hijacked', lost: 'Lost', seized: 'Seized by police', expired: 'Never collected',
};

function stockBar(value, max) {
  const pct = max ? Math.min(100, (value / max) * 100) : 0;
  return h('div', { class: 'bar' }, h('span', { style: `width:${pct}%` }));
}

function numberInput(max) {
  return h('input', { type: 'number', min: 1, max, step: 1, inputmode: 'numeric', style: 'width:110px', 'aria-label': 'Amount' });
}

function enterpriseCard(e, b) {
  const manage = b.canManage;
  const runsDry = e.rate > 0 ? Math.floor((e.supplies / e.suppliesPerUnit) / e.rate * 60) : 0;
  const card = h('div', { class: 'house' });

  const head = h('div', { class: 'house-head' },
    h('div', {}, h('h3', { text: e.label }), h('p', { class: 'hint', style: 'margin:0', text: `At ${e.safehouse}. Makes about ${e.rate} ${e.product} an hour.` })),
    manage ? h('button', {
      class: 'btn small danger', type: 'button',
      onclick: () => confirmModal({
        title: `Shut down the ${e.label.toLowerCase()}?`,
        body: 'All stock and supplies are lost and any orders on the way are cancelled. The set-up cost isn\'t refunded.',
        confirmLabel: 'Shut it down', danger: true, typeToConfirm: e.label,
        onConfirm: () => act('closeEnterprise', [e.id], 'Shut down.'),
      }),
    }, 'Shut down') : null);

  const stocks = h('div', { class: 'stocks' },
    h('div', {},
      h('div', { class: 'row', style: 'justify-content:space-between' }, h('span', { text: e.suppliesName.charAt(0).toUpperCase() + e.suppliesName.slice(1) }), h('span', { class: 'fig', text: `${e.supplies}/${e.maxSupplies}` })),
      stockBar(e.supplies, e.maxSupplies),
      h('div', { class: 'hint', style: 'margin:4px 0 0', text: e.supplies > 0 ? `Enough for about ${runsDry >= 120 ? `${Math.floor(runsDry / 60)} hours` : `${runsDry} minutes`}.` : 'Out of supplies. Nothing is being made.' })),
    h('div', {},
      h('div', { class: 'row', style: 'justify-content:space-between' }, h('span', { text: `Stock (${e.product})` }), h('span', { class: 'fig', text: `${e.stock}/${e.maxProduct}` })),
      stockBar(e.stock, e.maxProduct),
      h('div', { class: 'hint', style: 'margin:4px 0 0', text: e.stock >= e.maxProduct ? 'Full. Sell some or production stops.' : (e.distribute ? `On the street: sold ${e.lastSold} for ${money(e.lastEarned)} last round.` : 'Not on the street.') })));

  const controls = [];
  if (manage) {
    // Staff
    const staff = h('select', { 'aria-label': 'Staff' });
    for (let i = 0; i <= e.maxStaff; i += 1) staff.append(h('option', { value: String(i), selected: i === e.staff }, i === 0 ? 'No staff' : `${i} staff`));
    staff.addEventListener('change', () => act('setStaff', [e.id, Number(staff.value)], 'Staff updated.'));
    controls.push(h('div', { class: 'control' },
      h('div', { class: 'name', text: 'Staff' }),
      h('div', { class: 'hint', style: 'margin:0', text: `Each adds a quarter more output and costs ${money(e.staffWage)} an hour from dirty money.` }),
      staff));

    // Equipment
    controls.push(h('div', { class: 'control' },
      h('div', { class: 'name', text: `Equipment, level ${e.level} of ${e.maxLevel}` }),
      h('div', { class: 'hint', style: 'margin:0', text: e.nextPrice ? 'Better kit makes more per hour.' : 'Fully kitted out.' }),
      e.nextPrice ? h('button', { class: 'btn small', type: 'button', onclick: () => act('upgradeEnterprise', [e.id], 'Equipment upgraded.') }, `Upgrade for ${money(e.nextPrice)}`) : h('span', { class: 'muted', text: 'Maxed' })));

    // Street
    if (e.street) {
      controls.push(h('div', { class: 'control' },
        h('div', { class: 'name', text: 'Street distribution' }),
        h('div', { class: 'hint', style: 'margin:0', text: b.areasHeld
          ? `Sells about ${b.streetPerArea * b.areasHeld} an hour across your ${b.areasHeld} ${b.areasHeld === 1 ? 'hex' : 'hexes'} at ${money(e.street)} each. Draws heat.`
          : 'You need to hold an area to sell on the street.' }),
        h('button', { class: e.distribute ? 'btn small' : 'btn small primary', type: 'button', disabled: !b.areasHeld && !e.distribute,
          onclick: () => act('setDistribution', [e.id, !e.distribute], e.distribute ? 'Pulled off the street.' : 'Out on the street.') },
          e.distribute ? 'Stop' : 'Start')));
    }

    // Wholesale
    const sellAmount = numberInput(e.stock);
    controls.push(h('div', { class: 'control' },
      h('div', { class: 'name', text: 'Sell wholesale' }),
      h('div', { class: 'hint', style: 'margin:0', text: `${money(e.wholesale)} each, paid now into dirty money. ${MARKET_TEXT[e.market]}` }),
      h('div', { class: 'row' }, sellAmount, h('button', {
        class: 'btn small', type: 'button', disabled: e.stock < 1,
        onclick: async () => {
          const res = await request('sellWholesale', e.id, Number(sellAmount.value));
          if (res.ok) { toast(`Sold for ${money(res.data)}.`); renderTab(); } else toast(res.error, true);
        },
      }, 'Sell'))));

    // Bag up stock to deal on the street
    if (e.bagItem) {
      const bagAmount = numberInput(Math.min(50, e.stock));
      controls.push(h('div', { class: 'control' },
        h('div', { class: 'name', text: 'Bag up for the street' }),
        h('div', { class: 'hint', style: 'margin:0', text: `Takes stock out as ${e.bagItem} in your own pockets to deal by hand. Pays more than wholesale, but it's riskier.` }),
        h('div', { class: 'row' }, bagAmount, h('button', {
          class: 'btn small', type: 'button', disabled: e.stock < 1,
          onclick: async () => {
            const res = await request('bagUpStock', e.id, Number(bagAmount.value));
            if (res.ok) { toast(`Bagged up ${res.data}. Find a buyer in one of your areas.`); renderTab(); } else toast(res.error, true);
          },
        }, 'Bag up'))));
    }

    // Supplies
    const orderAmount = numberInput(e.maxSupplies);
    const method = select2([{ value: 'collect', label: `Collect it (${money(e.supplyCost)} each)` }, { value: 'delivery', label: `Delivered (${money(Math.floor(e.supplyCost * b.supply.markup))} each)` }]);
    controls.push(h('div', { class: 'control' },
      h('div', { class: 'name', text: 'Order supplies' }),
      h('div', { class: 'hint', style: 'margin:0', text: `Collecting is cheaper but someone has to drive the van home, and rivals may hear about it. Delivery takes ${b.supply.minutes} minutes and the police sometimes seize it.` }),
      h('div', { class: 'row' }, orderAmount, method, h('button', {
        class: 'btn small primary', type: 'button',
        onclick: () => act('orderSupplies', [e.id, Number(orderAmount.value), method.value], method.value === 'collect' ? 'Ordered. Start the run below when you\'re ready.' : 'Ordered for delivery.'),
      }, 'Order'))));
  }

  card.append(head, stocks, manage ? h('div', { class: 'upgrades' }, controls) : h('p', { class: 'hint', text: 'Your rank can\'t manage this.' }));
  return card;
}

function select2(options) {
  const el = h('select', {});
  options.forEach((o) => el.append(h('option', { value: o.value }, o.label)));
  return el;
}

async function renderBusiness() {
  const res = await request('getEnterprises');
  if (!res.ok) return loadError(res);
  const b = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Business' }))];

  if (!b.enterprises.length) {
    parts.push(h('p', { class: 'empty', style: 'margin-bottom:22px', text: b.freeSafehouses.length
      ? 'Nothing running yet. Set something up in one of your safehouses below.'
      : 'Businesses run inside safehouses. Get a safehouse first, then set one up here.' }));
  }
  b.enterprises.forEach((e) => parts.push(enterpriseCard(e, b)));

  // Shipments
  const ship = b.shipments || { active: [], recent: [] };
  if (ship.active.length || ship.recent.length) {
    parts.push(h('h3', { style: 'margin-top:24px', text: 'Supplies on order' }));
    const rows = ship.active.map((s) => h('tr', {},
      h('td', { text: `${s.amount} ${s.supplies}` }),
      h('td', { text: s.method === 'collect' ? `Collect${s.pickup ? ` from ${s.pickup}` : ''}` : 'Delivery' }),
      h('td', { text: SHIPMENT_STATUS[s.status] || s.status }),
      h('td', { class: 'muted', text: s.status === 'ready' ? `${Math.ceil(s.secondsLeft / 60)} min to start` : `${Math.ceil(s.secondsLeft / 60)} min` }),
      h('td', { class: 'actions' }, s.status === 'ready' ? h('button', {
        class: 'btn small primary', type: 'button',
        onclick: () => act('startSupplyRun', [s.id], 'The van\'s waiting. Check your map.'),
      }, 'Start the run') : null)));
    const recent = ship.recent.map((s) => h('tr', {},
      h('td', { class: 'muted', text: `${s.amount} supplies` }),
      h('td', { class: 'muted', text: s.method === 'collect' ? 'Collect' : 'Delivery' }),
      h('td', { class: ['delivered'].includes(s.status) ? 'credit' : 'debit', text: SHIPMENT_STATUS[s.status] || s.status }),
      h('td', {}), h('td', {})));
    parts.push(h('table', {}, h('tbody', {}, rows, recent)));
  }

  // Setting up
  if (b.canManage && b.freeSafehouses.length) {
    const where = select2(b.freeSafehouses.map((x) => ({ value: x.id, label: x.label })));
    parts.push(h('h3', { style: 'margin-top:28px', text: 'Set something up' }));
    parts.push(h('div', { class: 'row', style: 'margin-bottom:12px' }, h('label', { class: 'field' }, 'In', where)));
    parts.push(h('div', { class: 'offers' }, b.types.map((t) => h('div', { class: 'offer' },
      h('div', {}, h('h3', { text: t.label }), h('p', { class: 'hint', text: `Makes ${t.product}, about ${t.rate} an hour to start. ${t.street ? 'Sells wholesale or on the street.' : 'Wholesale only.'}` })),
      h('div', { class: 'pay' }, money(t.setup), h('small', { text: 'clean money' })),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: () => confirmModal({
          title: `Set up a ${t.label.toLowerCase()}?`,
          body: `${money(t.setup)} comes out of the clean treasury. It runs in ${where.selectedOptions[0].textContent}, and a police raid there will seize the stock.`,
          confirmLabel: 'Set it up',
          onConfirm: () => act('setupEnterprise', [Number(where.value), t.key], 'Up and running.'),
        }),
      }, 'Set up')))));
  }
  return h('div', {}, parts);
}


/* Diplomacy ------------------------------------------------------------- */

const DEAL_TEXT = {
  alliance: 'Neither side crosses out the other\'s tags, takes their rackets or touches their supply vans.',
  ceasefire: 'Same protection as an alliance, for a set time.',
  trade: 'Both gangs get money off supply orders while it runs.',
  neutral_zone: 'Neither side can hit the other inside the chosen area.',
};
const STATE_TEXT = { neutral: 'Neutral', rival: 'Declared rivals', allied: 'Allied' };

function hoursText(hrs) {
  if (!hrs) return 'Until broken';
  return hrs % 24 === 0 ? `${hrs / 24} ${hrs / 24 === 1 ? 'day' : 'days'}` : `${hrs} hours`;
}

function trustText(t) {
  if (t >= 40) return 'Trusted';
  if (t >= 10) return 'Some trust';
  if (t > -10) return 'No history';
  if (t > -40) return 'Wary of you';
  return 'Don\'t trust you';
}

function dealTerms(d) {
  const bits = [d.zone ? `${d.label} in ${d.zone}` : d.label, hoursText(d.hours)];
  if (d.payment > 0) bits.push(d.theyPay ? `they pay ${money(d.payment)}` : `you pay ${money(d.payment)}`);
  return bits.join(', ');
}

function openProposal(g, v) {
  const terms = { type: v.types[0].key };
  const typeChoices = h('div', { class: 'choices', role: 'radiogroup' });
  const hours = h('select', { 'aria-label': 'How long' });
  const zone = select2(v.zones.map((z) => ({ value: z.key, label: z.label })));
  const zoneField = h('label', { class: 'field' }, 'Area', zone);
  const explain = h('p', { class: 'hint', style: 'margin:0' });
  const payment = h('input', { type: 'number', min: 0, max: v.maxPayment, step: 100, value: 0, style: 'width:140px' });
  const payer = select2([{ value: 'proposer', label: 'We pay them' }, { value: 'target', label: 'They pay us' }]);
  const message = h('input', { type: 'text', maxlength: v.messageLength, placeholder: 'Optional message' });

  const refresh = () => {
    const t = v.types.find((x) => x.key === terms.type);
    hours.replaceChildren(...t.hours.map((x) => h('option', { value: String(x) }, hoursText(x))));
    zoneField.hidden = terms.type !== 'neutral_zone';
    explain.textContent = DEAL_TEXT[terms.type] || '';
  };
  const buttons = v.types.map((t) => {
    const b = h('button', {
      type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(t.key === terms.type),
      onclick: () => { terms.type = t.key; buttons.forEach((x) => x.setAttribute('aria-checked', String(x === b))); refresh(); },
    }, t.label);
    return b;
  });
  typeChoices.append(...buttons);
  refresh();

  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: `Propose a deal to ${g.label}` }),
    h('div', { class: 'designer' },
      h('div', { class: 'field' }, 'Deal', typeChoices, explain),
      h('label', { class: 'field' }, 'How long', hours),
      zoneField,
      h('div', { class: 'field' }, 'One-off payment on signing (clean money)', h('div', { class: 'row' }, payment, payer)),
      h('label', { class: 'field' }, 'Message', message)),
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: async () => {
          const ok = await act('proposeDeal', [g.id, terms.type, {
            hours: Number(hours.value), zone: terms.type === 'neutral_zone' ? zone.value : null,
            payment: Number(payment.value) || 0, payer: payer.value, message: message.value.trim(),
          }], `Proposal sent to ${g.label}.`);
          if (ok) hideModal();
        },
      }, 'Send proposal')),
  );
}

async function renderDiplomacy() {
  const res = await request('getDiplomacy');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Diplomacy' }))];

  parts.push(h('p', { class: 'hint', style: 'margin-bottom:18px', text: [
    v.discount > 0 ? `Trade deals give you ${Math.round(v.discount * 100)}% off supplies.` : '',
    v.myBroken > 0 ? `Other gangs can see you've broken ${v.myBroken} ${v.myBroken === 1 ? 'deal' : 'deals'}.` : 'You haven\'t broken a deal yet. Other gangs can see that.',
  ].filter(Boolean).join(' ') }));

  if (v.incoming.length) {
    parts.push(h('h3', { text: 'Proposals for you' }));
    parts.push(h('div', { class: 'offers', style: 'margin-bottom:24px' }, v.incoming.map((d) => h('div', { class: 'offer' },
      h('div', {},
        h('h3', {}, d.other),
        h('p', { text: dealTerms(d) }),
        d.message ? h('p', { class: 'hint quote', text: `"${d.message}"` }) : null,
        h('p', { class: 'hint', text: `Lapses in ${duration(d.secondsLeft)}.` })),
      h('div', {}),
      v.canDeal ? h('div', { class: 'design-actions' },
        h('button', { class: 'btn primary', type: 'button', onclick: () => act('respondDeal', [d.id, true], 'Deal signed.') }, 'Accept'),
        h('button', { class: 'btn danger', type: 'button', onclick: () => act('respondDeal', [d.id, false], 'Turned down.') }, 'Reject'))
        : h('span', { class: 'muted', text: 'Your rank can\'t answer' })))));
  }

  if (v.outgoing.length) {
    parts.push(h('h3', { text: 'Waiting on an answer' }));
    parts.push(h('div', { class: 'offers', style: 'margin-bottom:24px' }, v.outgoing.map((d) => h('div', { class: 'offer' },
      h('div', {}, h('h3', {}, d.other), h('p', { class: 'hint', text: `${dealTerms(d)}. Lapses in ${duration(d.secondsLeft)}.` })),
      h('div', {}),
      v.canDeal ? h('button', { class: 'btn small', type: 'button', onclick: () => act('withdrawDeal', [d.id], 'Proposal withdrawn.') }, 'Withdraw') : null))));
  }

  parts.push(h('h3', { text: 'Other gangs' }));
  if (!v.gangs.length) parts.push(h('p', { class: 'empty', text: 'No other gangs yet.' }));
  v.gangs.forEach((g) => {
    const deals = g.deals.map((d) => h('div', { class: 'upgrade' },
      h('div', {}, h('div', { class: 'name', text: dealTerms(d) }), h('div', { class: 'hint', style: 'margin:0', text: d.secondsLeft ? `${duration(d.secondsLeft)} left` : 'Runs until someone breaks it' })),
      v.canDeal ? h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Break your ${d.label.toLowerCase()} with ${g.label}?`,
          body: 'They\'ll be told straight away, every gang hears about it, you lose reputation, and every gang you have deals with trusts you less.',
          confirmLabel: 'Break the deal', danger: true, typeToConfirm: 'BREAK',
          onConfirm: () => act('breakDeal', [d.id], 'Deal broken.'),
        }),
      }, 'Break') : null));

    parts.push(h('div', { class: 'house' },
      h('div', { class: 'house-head' },
        h('div', { class: 'row', style: 'align-items:center;flex-wrap:nowrap' },
          g.logo ? h('img', { class: 'thumb', src: g.logo, alt: '', onerror: (e) => e.target.remove() }) : h('span', { class: 'swatch', style: `background:${g.colour};width:14px;height:14px` }),
          h('div', {},
            h('h3', { text: g.label }),
            h('p', { class: 'hint', style: 'margin:0', text: `${g.state === 'rival' ? 'Declared rivals. ' : ''}${trustText(g.trust)}. Reputation ${g.reputation}.${g.broken ? ` Has broken ${g.broken} ${g.broken === 1 ? 'deal' : 'deals'}.` : ''}` }))),
        v.canDeal ? h('div', { class: 'design-actions' },
          h('button', { class: 'btn small primary', type: 'button', onclick: () => openProposal(g, v) }, 'Propose a deal'),
          g.state === 'rival'
            ? h('button', { class: 'btn small', type: 'button', onclick: () => act('declareRelation', [g.id, 'neutral'], 'Rivalry dropped.') }, 'Drop rivalry')
            : h('button', {
              class: 'btn small danger', type: 'button', disabled: g.deals.length > 0,
              title: g.deals.length ? 'Break your deals with them first.' : '',
              onclick: () => confirmModal({
                title: `Declare ${g.label} rivals?`,
                body: `Hits against them earn ${Math.round((v.rivalBonus - 1) * 100)}% more influence. They'll be told.`,
                confirmLabel: 'Declare rivals', danger: true,
                onConfirm: () => act('declareRelation', [g.id, 'rival'], 'Rivals declared.'),
              }),
            }, 'Declare rivals')) : null),
      deals.length ? h('div', { class: 'upgrades', style: 'margin-top:12px' }, deals) : null));
  });
  return h('div', {}, parts);
}


/* Black market ---------------------------------------------------------- */

function countdown(seconds) {
  const el = h('span', { class: 'fig', text: clock(seconds) });
  let left = seconds;
  const tick = setInterval(() => {
    if (!el.isConnected) return clearInterval(tick);
    left = Math.max(0, left - 1);
    el.textContent = clock(left);
    if (left === 0) { clearInterval(tick); if (state.tab === 'market') setTimeout(renderTab, 1500); }
  }, 1000);
  return el;
}

async function renderMarket() {
  const res = await request('getAuctions');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const parts = [h('div', { class: 'section-head' }, h('h2', { text: 'Black market' }))];

  if (v.drops.length) {
    parts.push(h('h3', { text: 'Dead drops' }));
    v.drops.forEach((d) => parts.push(h('div', { class: 'job-now' },
      h('h3', { text: d.title }),
      h('p', { class: 'lead', text: d.ours ? `Yours. It's waiting near ${d.place}.` : `Someone else won this. It's near ${d.place} if you're quick.` }),
      h('div', { class: 'row', style: 'justify-content:space-between;align-items:center' },
        h('p', { style: 'margin:0' }, countdown(d.secondsLeft), ' until it\'s gone.'),
        waypointButton(d.x, d.y)))));
  }

  if (!v.open.length) {
    parts.push(h('p', { class: 'empty', text: v.nextIn !== null && v.nextIn !== undefined
      ? `No auction running. The broker usually holds the next one within ${v.nextIn >= 60 ? `${Math.round(v.nextIn / 60)} hours` : `${v.nextIn} minutes`}. Everyone gets told when it opens.`
      : 'No auction running.' }));
  } else {
    parts.push(h('p', { class: 'hint', style: 'margin-bottom:12px', text: 'Bids come out of dirty money straight away and are returned if someone beats you. Nobody sees who\'s bidding. A bid in the last minute adds a minute.' }));
    parts.push(h('div', { class: 'offers' }, v.open.map((l) => {
      const input = h('input', { type: 'number', min: l.minBid, step: 100, value: l.minBid, style: 'width:130px', 'aria-label': 'Your bid' });
      const status = l.topBid
        ? (l.leading ? h('span', { class: 'credit', text: `Your bid of ${money(l.topBid)} leads` }) : h('span', { text: `Another gang leads at ${money(l.topBid)}` }))
        : h('span', { class: 'muted', text: `No bids yet. Reserve ${money(l.reserve)}` });
      return h('div', { class: 'offer lot' },
        h('div', {},
          h('h3', { text: l.title }),
          h('p', { text: l.detail }),
          h('p', { class: 'hint' }, status, '. Ends in ', countdown(l.secondsLeft), '.'),
          !l.eligible ? h('p', { class: 'hint debit', text: 'You\'d need a matching business to use this.' }) : null),
        v.canBid && l.eligible ? h('div', { class: 'bid' },
          h('div', { class: 'row' }, input, h('button', {
            class: 'btn primary', type: 'button', disabled: l.leading,
            onclick: () => act('auctionBid', [l.id, Number(input.value)], 'Bid placed.'),
          }, 'Bid')),
          h('button', {
            class: 'btn small', type: 'button',
            onclick: () => confirmModal({
              title: `Buy ${l.title} outright?`,
              body: `${money(l.buyNow)} from dirty money ends the bidding now and it's yours.`,
              confirmLabel: `Pay ${money(l.buyNow)}`,
              onConfirm: () => act('auctionBuyNow', [l.id], 'Bought.'),
            }),
          }, `Buy now for ${money(l.buyNow)}`)) : h('span', { class: 'muted', text: v.canBid ? '' : 'Your rank can\'t bid' }));
    })));
  }

  if (v.recent.length) {
    parts.push(h('h3', { style: 'margin-top:26px', text: 'Recent sales' }));
    parts.push(h('table', {}, h('tbody', {}, v.recent.map((r) => h('tr', {},
      h('td', { text: r.title }),
      h('td', { class: 'num fig', text: r.sold ? money(r.price) : '' }),
      h('td', { class: 'muted', text: r.sold ? 'Sold' : 'No buyer' }))))));
  }
  return h('div', {}, parts);
}

/* Tags ------------------------------------------------------------------ */

const DESIGN_STATUS = {
  approved: 'Ready to spray',
  pending: 'Waiting for staff to approve it',
  rejected: 'Turned down by staff. Delete it and try something different.',
};

function tagCanvas(spec, width) {
  const canvas = h('canvas', { width: 512, height: 256, class: 'tag-canvas', style: `width:${width || 200}px` });
  drawTag(canvas, spec);
  return canvas;
}

async function renderTags() {
  const res = await request('getTags');
  if (!res.ok) return loadError(res);
  const t = res.data;
  const full = t.designs.length >= t.maxDesigns;

  const intro = t.activeTags
    ? `${t.activeTags} of your tags are up across ${t.activeZones} ${t.activeZones === 1 ? 'hex' : 'hexes'}. Tags mark your turf; selling there is what builds control.`
    : 'None of your tags are up yet. Every tag adds influence to the area it\'s in, and keeps adding a little while it stays up.';
  const areaNote = t.onlyInAreas ? ' Tags can only go up inside a gang area, so check the Territory map for where they count.' : '';

  const rows = t.designs.map((d) => {
    const actions = [];
    if (d.status === 'approved' && t.canSpray) {
      actions.push(h('button', {
        class: 'btn primary', type: 'button',
        onclick: () => postNui('spray', { id: d.id, spec: d.spec }),
      }, 'Spray it'));
    }
    if (d.inUse === 0) {
      actions.push(h('button', {
        class: 'btn danger', type: 'button',
        onclick: () => confirmModal({
          title: `Delete ${d.name}?`,
          body: 'You can make a new design afterwards.',
          confirmLabel: 'Delete design',
          danger: true,
          onConfirm: () => act('deleteDesign', [d.id], 'Design deleted.'),
        }),
      }, 'Delete'));
    }
    return h('div', { class: 'design' },
      h('div', { class: 'wall' }, tagCanvas(d.spec, 220)),
      h('div', {},
        h('h3', { text: d.name }),
        h('p', { class: d.status === 'rejected' ? 'hint debit' : 'hint', text: DESIGN_STATUS[d.status] || d.status }),
        d.inUse > 0 ? h('p', { class: 'hint', text: `On ${d.inUse} ${d.inUse === 1 ? 'wall' : 'walls'} right now.` }) : null),
      h('div', { class: 'design-actions' }, actions));
  });

  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', { text: 'Tags' }),
      t.canDesign ? h('button', { class: 'btn', type: 'button', disabled: full, onclick: () => openDesigner(t) }, 'New design') : null),
    h('p', { class: 'hint', style: 'margin-bottom:18px', text: intro + areaNote }),
    rows.length ? h('div', { class: 'designs' }, rows)
      : h('p', { class: 'empty', text: 'Design your gang\'s tag first. Once it\'s ready you can spray it on any wall.' }),
    t.sprayItem ? h('p', { class: 'hint', style: 'margin-top:18px', text: 'You need a spray can on you to tag or cross out a wall.' }) : null,
    full ? h('p', { class: 'hint', text: `Your gang can keep ${t.maxDesigns} designs. Delete one to make another.` }) : null,
    wallsSection(t));
}

function ageText(seconds) {
  if (seconds < 3600) return `${Math.max(1, Math.round(seconds / 60))} min ago`;
  if (seconds < 86400) { const h_ = Math.round(seconds / 3600); return `${h_} ${h_ === 1 ? 'hour' : 'hours'} ago`; }
  const d = Math.round(seconds / 86400);
  return `${d} ${d === 1 ? 'day' : 'days'} ago`;
}

/* Every tag the gang has up, by area, with a waypoint and a remove button */
function wallsSection(t) {
  const areas = t.onWalls || [];
  const total = areas.reduce((n, a) => n + a.tags.length, 0);
  const parts = [h('h3', { style: 'margin-top:28px' }, 'On the walls ', h('span', { class: 'muted fig', text: total }))];
  if (!total) {
    parts.push(h('p', { class: 'empty', text: 'None of your tags are up right now.' }));
    return h('div', {}, parts);
  }

  areas.forEach((a) => {
    parts.push(h('div', { class: 'wall-area' },
      h('span', { class: 'name', text: a.area }),
      a.limit ? h('span', { class: a.active >= a.limit ? 'fig debit' : 'fig muted', text: `${a.active} of ${a.limit} up` })
        : h('span', { class: 'hint', style: 'margin:0', text: 'Not in an area, so these earn no influence' })));

    a.tags.forEach((tag) => {
      parts.push(h('div', { class: 'wall-tag' },
        tag.spec ? h('div', { class: 'wall' }, tagCanvas(tag.spec, 120)) : h('div', {}),
        h('div', {},
          h('div', { style: 'font-weight:600', text: tag.design }),
          h('div', { class: tag.status === 'crossed' ? 'hint debit' : 'hint', style: 'margin:0', text: tag.status === 'crossed'
            ? `Crossed out${tag.crossedBy ? ` by ${tag.crossedBy}` : ''}. It's not earning anything; remove it or spray over it.`
            : `Sprayed ${ageText(tag.age)}.` })),
        h('div', { class: 'design-actions' },
          waypointButton(tag.x, tag.y),
          t.canRemove ? h('button', {
            class: 'btn small danger', type: 'button',
            onclick: () => confirmModal({
              title: 'Take this tag down?',
              body: 'It comes off the wall for everyone. Influence it already earned stays, but it stops earning more.',
              confirmLabel: 'Remove tag', danger: true,
              onConfirm: () => act('removeOwnTag', [tag.id], 'Tag removed.'),
            }),
          }, 'Remove') : null)));
    });
  });
  return h('div', {}, parts);
}

function openDesigner(t) {
  const spec = {
    text: state.gang.label.slice(0, t.maxTextLength),
    font: t.fonts[0].key,
    style: 'outline',
    fill: state.gang.colour || '#F2A93B',
    outline: '#111418',
  };
  const preview = h('canvas', { width: 1024, height: 512, class: 'tag-canvas large' });
  const redraw = () => drawTag(preview, spec);

  const text = h('input', { type: 'text', value: spec.text, maxlength: t.maxTextLength, spellcheck: false, 'aria-label': 'Tag text' });
  text.addEventListener('input', () => { spec.text = text.value; redraw(); });

  const name = h('input', { type: 'text', maxlength: 48, placeholder: 'Optional', 'aria-label': 'Design name' });

  const choice = (items, key, labelFor, styleFor) => {
    const group = h('div', { class: 'choices', role: 'radiogroup' });
    const buttons = items.map((item) => {
      const value = item.key || item;
      const b = h('button', {
        type: 'button', role: 'radio', class: 'choice', style: styleFor ? styleFor(item) : null,
        'aria-checked': String(spec[key] === value),
        onclick: () => {
          spec[key] = value;
          buttons.forEach((x) => x.setAttribute('aria-checked', String(x === b)));
          redraw();
        },
      }, labelFor(item));
      return b;
    });
    group.append(...buttons);
    return group;
  };

  const fonts = choice(t.fonts, 'font', (f) => f.label, (f) => `font-family:'${f.family}', Impact, sans-serif;font-size:17px`);
  const styleLabels = { plain: 'Plain', outline: 'Outline', shadow: 'Shadow' };
  const styles = choice(t.styles, 'style', (s) => styleLabels[s] || s);

  const fill = h('input', { type: 'color', value: spec.fill });
  fill.addEventListener('input', () => { spec.fill = fill.value; redraw(); });
  const outline = h('input', { type: 'color', value: spec.outline });
  outline.addEventListener('input', () => { spec.outline = outline.value; redraw(); });

  // Picture tags: an image link (or the gang's own logo), always checked by staff
  let mode = 'lettering';
  const picture = { kind: 'image', url: '' };
  const url = h('input', { type: 'url', placeholder: 'https://i.imgur.com/yourimage.png', spellcheck: false, 'aria-label': 'Image link' });
  const pictureNote = h('span', { class: 'hint' });
  const setPicture = (value) => {
    picture.url = value.trim();
    url.value = picture.url;
    pictureNote.textContent = '';
    drawTag(preview, picture).then(() => {
      if (picture.url && !imageCacheHas(picture.url)) pictureNote.textContent = 'That link didn\'t load as an image. Use the direct image link.';
    });
  };
  url.addEventListener('change', () => setPicture(url.value));

  const letteringPanel = h('div', { class: 'designer' },
    h('label', { class: 'field' }, 'Tag', text,
      h('span', { class: 'hint', text: `Up to ${t.maxTextLength} letters, numbers and simple punctuation.` })),
    h('div', { class: 'field' }, 'Lettering', fonts),
    h('div', { class: 'field' }, 'Style', styles),
    h('div', { class: 'row' },
      h('label', { class: 'field' }, 'Paint', fill),
      h('label', { class: 'field' }, 'Outline and shadow', outline)));

  const picturePanel = h('div', { class: 'designer', hidden: true },
    t.logo ? h('div', { class: 'row', style: 'align-items:center' },
      h('img', { class: 'thumb', src: t.logo, alt: '' }),
      h('button', { class: 'btn small', type: 'button', onclick: () => setPicture(t.logo) }, 'Use our gang logo')) : null,
    h('label', { class: 'field' }, 'Image link', url,
      h('span', { class: 'hint', text: t.anyHost
        ? 'A direct link to the image, from any website, starting with https://. Transparent PNGs look best on a wall.'
        : `A direct link to a PNG, JPG, WebP or GIF on ${joinList(t.hosts || [], 'or')}. Transparent PNGs look best on a wall.` }),
      pictureNote));

  const modeSwitch = h('div', { class: 'choices', role: 'radiogroup' });
  const modeButtons = [['lettering', 'Lettering'], ['picture', 'Picture']].map(([key, label]) => {
    const b = h('button', {
      type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(key === mode),
      onclick: () => {
        mode = key;
        modeButtons.forEach((x) => x.setAttribute('aria-checked', String(x === b)));
        letteringPanel.hidden = mode !== 'lettering';
        picturePanel.hidden = mode !== 'picture';
        approvalNote.hidden = !(t.requireApproval || mode === 'picture');
        submit.textContent = (t.requireApproval || mode === 'picture') ? 'Send for approval' : 'Save design';
        if (mode === 'picture') drawTag(preview, picture); else redraw();
      },
    }, label);
    return b;
  });
  modeSwitch.append(...modeButtons);

  const approvalNote = h('p', { class: 'hint', hidden: !t.requireApproval, text: 'Staff check every design before it can go on a wall.' });

  const submit = h('button', {
    class: 'btn primary', type: 'button',
    onclick: async () => {
      if (mode === 'picture' && !picture.url) { toast('Paste an image link first.', true); return; }
      submit.disabled = true;
      const design = mode === 'picture' ? { kind: 'image', url: picture.url } : { ...spec, text: spec.text.trim() };
      const ok = await act('submitDesign', [name.value.trim(), design],
        (t.requireApproval || mode === 'picture') ? 'Sent to staff for approval.' : 'Design saved.');
      submit.disabled = false;
      if (ok) hideModal();
    },
  }, t.requireApproval ? 'Send for approval' : 'Save design');

  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: 'New tag design' }),
    h('div', { class: 'wall large' }, preview),
    t.allowPictures ? h('div', { class: 'field', style: 'margin-bottom:14px' }, 'Type', modeSwitch) : null,
    letteringPanel,
    picturePanel,
    h('div', { class: 'designer', style: 'margin-top:16px' }, h('label', { class: 'field' }, 'Design name', name)),
    approvalNote,
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      submit),
  );
  redraw();
}

/* Settings -------------------------------------------------------------- */

const LOGO_STATUS = {
  none: 'No logo set.',
  pending: 'Waiting for staff to approve it. Your old logo, if any, is hidden until then.',
  approved: 'Showing on your tablet.',
  rejected: 'Staff turned this logo down. Try a different image.',
};

function logoBlock(gang) {
  const s = state.static;
  const preview = h('img', { class: 'logo-preview', alt: 'Logo preview' });
  const showPreview = (url) => {
    preview.hidden = !url;
    if (url) preview.src = url;
  };
  preview.onerror = () => { preview.hidden = true; };
  showPreview(gang.logoUrl);

  const input = h('input', { type: 'url', value: gang.logoUrl || '', placeholder: 'https://i.imgur.com/yourlogo.png', spellcheck: false, style: 'flex:1;min-width:260px' });
  input.addEventListener('change', () => showPreview(input.value.trim()));

  const hosts = joinList(s.logoHosts || [], 'or');
  return h('div', { class: 'block', id: 'logo-block' },
    h('h3', { text: 'Gang logo' }),
    h('p', { text: s.logoAnyHost
      ? 'Paste a direct link to a square image. Any website works as long as the link starts with https://. Staff check it before it shows.'
      : `Paste a direct link to a square image (PNG, JPG, WebP or GIF). Links must be from ${hosts}.` }),
    h('div', { class: 'row', style: 'align-items:center;margin-bottom:12px' },
      preview,
      h('p', { class: gang.logoStatus === 'rejected' ? 'hint debit' : 'hint', style: 'margin:0;max-width:40ch', text: LOGO_STATUS[gang.logoStatus] || '' })),
    h('div', { class: 'row' },
      input,
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: () => act('setLogo', [input.value.trim()], s.logoApproval ? 'Logo sent to staff for approval.' : 'Logo saved.'),
      }, 'Save logo'),
      gang.logoUrl ? h('button', { class: 'btn', type: 'button', onclick: () => act('setLogo', [''], 'Logo removed.') }, 'Remove') : null));
}


function renderSettings() {
  const gang = state.gang;
  const blocks = [];

  if (gang.isBoss) {
    const label = h('input', { type: 'text', value: gang.label, maxlength: 64 });
    const colour = h('input', { type: 'color', value: gang.colour });
    colour.addEventListener('input', () => applyAccent(colour.value));
    label.addEventListener('input', () => { $('tag').textContent = label.value || gang.label; });

    blocks.push(h('div', { class: 'block' },
      h('h3', { text: 'Name and colour' }),
      h('p', { text: 'Shown on the tablet, the territory map and your tags.' }),
      h('div', { class: 'row' },
        h('label', { class: 'field', style: 'flex:1;min-width:220px' }, 'Gang name', label),
        h('label', { class: 'field' }, 'Colour', colour),
        h('button', { class: 'btn primary', type: 'button', onclick: () => act('updateDetails', [label.value.trim(), colour.value], 'Changes saved.') }, 'Save changes'))));
  }

  if (gang.isBoss && state.static.logos) blocks.push(logoBlock(gang));

  blocks.push(h('div', { class: 'block' },
    h('h3', { text: 'Leave the gang' }),
    h('p', { text: gang.isBoss
      ? 'As boss, hand leadership to another member first. If you\'re the only member, leaving disbands the gang.'
      : 'You\'ll lose access to the tablet and the gang\'s treasury.' }),
    h('button', {
      class: 'btn danger', type: 'button',
      onclick: () => confirmModal({
        title: `Leave ${gang.label}?`,
        body: 'You\'ll need a new invite to come back.',
        confirmLabel: 'Leave gang',
        danger: true,
        onConfirm: () => act('leave', [], 'You left the gang.'),
      }),
    }, 'Leave gang')));

  if (gang.isBoss) {
    blocks.push(h('div', { class: 'block' },
      h('h3', { text: 'Disband the gang' }),
      h('p', { text: 'Removes every member and gives up all territory. Clean money in the treasury is paid to your bank. This can\'t be undone.' }),
      h('button', {
        class: 'btn danger', type: 'button',
        onclick: () => confirmModal({
          title: `Disband ${gang.label}?`,
          body: 'Every member is removed and all territory is lost.',
          confirmLabel: 'Disband gang',
          danger: true,
          typeToConfirm: gang.label,
          onConfirm: () => act('disband', [], 'Gang disbanded.'),
        }),
      }, 'Disband gang')));
  }

  return Promise.resolve(h('div', {}, h('div', { class: 'section-head' }, h('h2', { text: 'Settings' })), blocks));
}

/* Messages from Lua ----------------------------------------------------- */

window.addEventListener('message', (event) => {
  const msg = event.data || {};
  if (msg.action === 'open') {
    state.mode = 'tablet';
    state.static = msg.static;
    state.gang = msg.gang || null;
    state.tab = 'home';
    const device = $('device');
    device.hidden = false;
    device.classList.remove('opening');
    void device.offsetWidth; // restart the wake animation
    device.classList.add('opening');
    renderFrame();
  } else if (msg.action === 'gang' && state.mode === 'tablet') {
    const hadGang = !!state.gang;
    state.gang = msg.gang || null;
    if (hadGang && !state.gang) hideModal();
    renderFrame();
  } else if (msg.action === 'close') {
    hideModal();
    $('device').hidden = true;
  }
});

window.addEventListener('keydown', (e) => {
  if (e.key !== 'Escape' || $('device').hidden) return;
  if (!$('modal').hidden) hideModal();
  else if (!$('app').hidden && !$('back').hidden) goHome();
  else closeTablet();
});

$('close').addEventListener('click', closeTablet);
$('close').append(icon('close'));
$('back').append(icon('back'), document.createTextNode('Home'));
$('back').addEventListener('click', goHome);
$('homebar').addEventListener('click', goHome);
$('status-icons').append(icon('wifi'), icon('battery'));
$('modal').addEventListener('click', (e) => { if (e.target === $('modal')) hideModal(); });

/* Browser preview: open index.html directly to work on the UI without the game. */

const Mock = {
  gang: { id: 1, name: 'ballas', label: 'Grove Kings', colour: '#7B3FBF', grade: 4, rank: 'Boss', isBoss: true, permissions: ['*'], logo: null, logoUrl: null, logoStatus: 'none',
    tier: 2, unlocks: { rackets: true, safehouses: true, contracts_medium: true, enterprises: false, diplomacy: false, second_safehouse: false, auctions: false, contracts_high: false } },
  request(action, args) {
    const ok = (data) => Promise.resolve({ ok: true, data: data === undefined ? true : data });
    const now = Date.now() / 1000;
    switch (action) {
      case 'getOverview': return ok({ inGang: true, gang: { label: this.gang.label, reputation: 140 }, rank: 'Boss', memberCount: 6, onlineCount: 3, maxMembers: 25, territory: ['Davis', 'Rancho'], treasury: { clean: 48250, dirty: 12900 },
        news: [{ kind: 'crew', text: 'An outside crew has moved into Rancho and is squeezing everyone there. Push them out.', minutesLeft: 64, progress: 35 },
          { kind: 'boom', text: 'Buyers are paying over the odds for grams of cocaine.', minutesLeft: 22 }],
        progress: { tier: 2, label: 'Firm', max: 4, reputation: 212, slipping: false,
          next: { tier: 3, label: 'Organisation', unlocks: ['enterprises', 'diplomacy', 'second_safehouse'], requirements: [
            { type: 'reputation', have: 212, need: 400, done: false }, { type: 'areas', have: 1, need: 1, done: true },
            { type: 'area_hours', have: 7, need: 12, done: false }, { type: 'racket_income', have: 15600, need: 15000, done: true },
            { type: 'safehouses', have: 0, need: 1, done: false }] } } });
      case 'getMembers': return ok({ myGrade: 4, topGrade: 4, maxMembers: 25,
        members: [
          { citizenid: 'A1', name: 'Marcus Doyle', grade: 4, rank: 'Boss', online: true, me: true },
          { citizenid: 'B2', name: 'Kez Williams', grade: 3, rank: 'Underboss', online: true },
          { citizenid: 'C3', name: 'Danny Price', grade: 1, rank: 'Soldier', online: false },
          { citizenid: 'D4', name: 'Tia Morgan', grade: 0, rank: 'Associate', online: true },
        ],
        ranks: [
          { grade: 4, label: 'Boss', permissions: ['*'] },
          { grade: 3, label: 'Underboss', permissions: ['graffiti', 'treasury_view', 'manage_members'] },
          { grade: 1, label: 'Soldier', permissions: ['graffiti', 'contracts_accept'] },
          { grade: 0, label: 'Associate', permissions: ['graffiti'] },
        ] });
      case 'getTerritory': return this.request('getTerritoryHex');
      case 'getTreasury': return ok({ canView: true, canDeposit: true, canWithdraw: true, cash: 3400,
        balances: { clean: 48250, dirty: 12900 },
        history: [
          { amount: 2500, type: 'deposit', account: 'clean', ts: now - 400, name: 'Kez Williams' },
          { amount: -1200, type: 'withdrawal', account: 'clean', ts: now - 7200, name: 'Marcus Doyle' },
          { amount: 4000, type: 'contract_reward', account: 'dirty', ts: now - 90000, name: null },
        ] });
      case 'getContracts': return ok({ canAccept: true,
        active: { id: 12, template: 'collect', stage: 'chase', title: 'Collect a debt', description: 'Someone in Rancho owes money. Make him pay.', runner: 'Kez Williams', isRunner: false, secondsLeft: 512, reward: 4800 },
        offers: [
          { id: 20, title: 'Move a stolen car', contact: 'Ray the Fence', description: 'Take a car from Mirror Park and get it to Elysian Island docks without too much damage.', difficulty: 'Medium risk', level: 2, reward: 6400, account: 'dirty', minutes: 20, expiresIn: 1900 },
          { id: 21, title: 'Courier run', contact: 'Mags', description: 'Pick up a package in Davis and drop it in Del Perro Pier.', difficulty: 'Low risk', level: 1, reward: 2450, account: 'dirty', minutes: 15, expiresIn: 600 },
        ],
        contacts: [{ label: 'Mags', trust: 46, tier: 2, nextAt: 120 }, { label: 'Ray the Fence', trust: 12, tier: 1, nextAt: 40 }, { label: 'Dutchy', trust: 130, tier: 3, nextAt: null }] });
      case 'getRackets': return ok({ canWork: true, minutes: 60, maxPeriods: 3, minInfluence: 25,
        mine: [
          { key: 'ltd_grove', label: 'LTD Gasoline, Grove Street', area: 'Davis', income: 450, owed: 1350, full: true, lastCollected: 11200, lapsesIn: 10400, x: -47, y: -1758 },
          { key: 'herr_kutz_davis', label: 'Herr Kutz, Davis', area: 'Davis', income: 300, owed: 300, full: false, lastCollected: 4100, lapsesIn: 2000, x: 136, y: -1708 },
        ],
        prospects: [
          { key: 'discount_straw', label: 'Discount Store, Strawberry', area: 'Strawberry', income: 350, protectedBy: 'Los Vagos', odds: 'fair', blocked: 'racket_rival_stronger', x: 75, y: -1392 },
          { key: '247_innocence', label: '24/7, Innocence Boulevard', area: 'Strawberry', income: 400, odds: 'good', x: 25, y: -1347 },
        ] });
      case 'getSafehouses': return ok({ isBoss: true, max: 2, graceDays: 3,
        mine: [{ id: 1, label: 'The Lock-up', address: '14 Forum Drive', area: 'Davis', price: 75000, upkeep: 1500, x: -100, y: -1600, paidFor: 51000, breached: false, refund: 46000,
          upgrades: { stash: { level: 1, slots: 60, nextPrice: 35000, nextSlots: 90 }, cctv: { owned: true, price: 12000 }, door: { owned: false, price: 20000 } } }],
        available: [{ id: 2, label: 'Flat above the bookies', address: '3 Grove Street', area: 'Davis', price: 60000, upkeep: 1200, x: -50, y: -1700 }] });
      case 'getEnterprises': return ok({ canManage: true, areasHeld: 2, streetPerArea: 6, supply: { markup: 1.5, minutes: 30, seizure: 0.08 },
        enterprises: [{ id: 1, type: 'weed', label: 'Weed grow', product: 'bags of weed', suppliesName: 'grow supplies', safehouse: 'The Lock-up', level: 2, maxLevel: 3, nextPrice: 60000,
          staff: 2, maxStaff: 4, staffWage: 120, supplies: 140, maxSupplies: 400, stock: 520, maxProduct: 600, rate: 45, suppliesPerUnit: 1,
          wholesale: 121, street: 187, market: 'high', distribute: true, lastSold: 12, lastEarned: 2244, supplyCost: 35, bagItem: 'weed' }],
        freeSafehouses: [{ id: 2, label: 'Flat above the bookies' }],
        types: [{ key: 'weed', label: 'Weed grow', setup: 40000, product: 'bags of weed', street: true, rate: 20 }, { key: 'counterfeit', label: 'Counterfeit cash', setup: 60000, product: 'bundles of fake notes', street: false, rate: 10 }, { key: 'coke', label: 'Cocaine lab', setup: 90000, product: 'grams of cocaine', street: true, rate: 12 }],
        shipments: { active: [{ id: 7, amount: 200, method: 'collect', status: 'ready', supplies: 'grow supplies', secondsLeft: 2400, pickup: 'La Mesa' }, { id: 8, amount: 100, method: 'delivery', status: 'waiting', supplies: 'grow supplies', secondsLeft: 900 }],
          recent: [{ id: 5, amount: 150, method: 'collect', status: 'stolen' }] } });
      case 'getDiplomacy': return ok({ canDeal: true, myBroken: 0, discount: 0.1, rivalBonus: 1.25, maxPayment: 500000, messageLength: 160,
        types: [{ key: 'alliance', label: 'Alliance', hours: [0] }, { key: 'ceasefire', label: 'Ceasefire', hours: [24, 48, 72] }, { key: 'neutral_zone', label: 'Neutral area', hours: [48, 168, 0] }, { key: 'trade', label: 'Trade agreement', hours: [72, 168] }],
        zones: [{ key: 'davis', label: 'Davis' }, { key: 'rancho', label: 'Rancho' }],
        incoming: [{ id: 9, label: 'Ceasefire', type: 'ceasefire', other: 'Los Vagos', hours: 48, payment: 10000, theyPay: true, message: 'Enough. Let us both get paid.', secondsLeft: 70000 }],
        outgoing: [],
        gangs: [
          { id: 2, label: 'Los Vagos', colour: '#E8C31E', state: 'rival', trust: -20, broken: 1, reputation: 88, deals: [] },
          { id: 3, label: 'East Side', colour: '#3FA7D6', state: 'neutral', trust: 20, broken: 0, reputation: 40, deals: [{ id: 4, label: 'Trade agreement', type: 'trade', hours: 168, payment: 0, secondsLeft: 300000 }] },
        ] });
      case 'getLeaks': return ok({ canSee: true, cost: 10000, enabled: true, leaks: [
        { id: 2, detail: 'the supply run', ago: 5400 },
        { id: 1, detail: 'safehouse at The Lock-up', ago: 90000, suspects: ['Danny Price', 'Tia Morgan', 'Kez Williams'] }] });
      case 'getAuctions': return ok({ canBid: true, recent: [{ title: 'A bent copper', sold: true, price: 24500 }, { title: 'Connections in Rancho', sold: false }],
        drops: [{ id: 3, title: 'Desert Eagle', place: 'La Mesa', x: 730, y: -1290, secondsLeft: 1500, ours: true }],
        open: [
          { id: 5, title: '220 grow supplies', detail: 'Free load for a Weed grow, picked up by van like any collection.', kind: 'supplies', secondsLeft: 610, topBid: 5200, bids: 3, leading: false, minBid: 5500, buyNow: 11500, reserve: 4600, eligible: true },
          { id: 6, title: 'A job nobody else is offered', detail: 'A high-risk job that pays 2.5x the usual rate, straight onto your board.', kind: 'contract', secondsLeft: 610, topBid: 9000, bids: 1, leading: true, minBid: 9500, buyNow: 22500, reserve: 9000, eligible: true },
        ] });
      case 'getLaundering': return ok({ canSee: true, canWash: true, dirty: 12900,
        methods: [
          { key: 'fronts', label: 'Your protected businesses', description: 'Run it through the tills of shops that pay you. Cheaper, and less likely to be noticed.', cut: 0.12, minutes: 60, min: 1000, limit: 12000, left: 7000 },
          { key: 'cleaner', label: 'A cleaner', description: 'Someone who asks no questions. Expensive, but anyone can use them.', cut: 0.3, minutes: 30, min: 1000, limit: 25000, left: 25000 },
        ],
        washing: [{ id: 3, method: 'Your protected businesses', amountIn: 5000, amountOut: 4400, secondsLeft: 1820 }], done: [] });
      case 'getTerritoryHex': return ok({ mode: 'hexes', expandAt: 100, decayPerHour: 4, controlPerSale: 1.5, turfDrugs: ['OG Kush'], canExpand: true, balance: 48250,
        cost: { money: 50000, account: 'dirty', item: 'OG Kush', count: 50 }, sprays: { used: 1, slots: 2, every: 3, main: 'h:4:-7' },
        hexes: [{ key: 'h:4:-7', q: 4, r: -7, label: 'Davis (4, -7)', mine: true, main: true, compound: true, control: 100, owner: { label: 'Grove Kings', colour: '#7B3FBF' } },
          { key: 'h:5:-7', q: 5, r: -7, label: 'Rancho (5, -7)', mine: true, compound: true, control: 62, owner: { label: 'Grove Kings', colour: '#7B3FBF' } },
          { key: 'h:3:-6', q: 3, r: -6, label: 'Davis (3, -6)', mine: true, control: 18, owner: { label: 'Grove Kings', colour: '#7B3FBF' } },
          { key: 'h:6:-8', q: 6, r: -8, label: 'Rancho (6, -8)', mine: false, owner: { label: 'Los Vagos', colour: '#E8C31E' } }],
        options: [{ key: 'h:4:-8', q: 4, r: -8, label: 'Davis (4, -8)' }, { key: 'h:3:-7', q: 3, r: -7, label: 'Chamberlain Hills (3, -7)' }, { key: 'h:5:-8', q: 5, r: -8, label: 'Rancho (5, -8)' }, { key: 'h:4:-6', q: 4, r: -6, label: 'Davis (4, -6)' }] });
      case 'getAirdrop': return ok({ canCall: true, cost: 25000, account: 'dirty', balance: 48250, waitFor: 0, busy: false, cooldownMins: 120,
        bounds: { minX: -3800, maxX: 4300, minY: -3700, maxY: 7800 }, active: null });
      case 'getHeists': return ok({ canStart: true,
        active: { id: 4, label: 'Fleeca, Great Ocean', endsAt: 812, alarm: 'silent', loot: 0, steps: [
          { i: 1, label: 'Security panel', done: true }, { i: 2, label: 'Inner gate', available: true, busy: true },
          { i: 3, label: 'Vault door' }, { i: 4, label: 'Cash trolley' }, { i: 5, label: 'Deposit boxes' }] },
        heists: [
          { id: 4, label: 'Fleeca, Great Ocean', area: 'Banham Canyon', crew: 3, steps: 5, blocked: 'heist_already_running', x: -2957, y: 481 },
          { id: 6, label: 'Gruppe armoured truck', area: 'Downtown', crew: 3, steps: 3, blocked: 'heist_cooldown', readyIn: 1880, x: 150, y: -1040 },
          { id: 7, label: 'Vangelico jewellery', area: 'Rockford Hills', crew: 2, steps: 5, x: -630, y: -236 }] });
      case 'getShop': return ok({ cash: 1840, bank: 12500, canTreasury: true, clean: 48250, dirty: 12900, items: [
        { item: 'spraycan', label: 'Spray can', description: 'One can sprays a tag or crosses out a rival\'s.', price: 50, pay: 'cash', max: 10, image: 'spraycan.png' },
        { item: 'burner_phone', label: 'Burner phone', description: 'A cheap phone nobody can trace back to you.', price: 500, pay: 'cash', max: 1, image: 'burner_phone.png' },
        { item: 'armour', label: 'Body armour', price: 2500, pay: 'dirty', max: 2, image: 'nui://ox_inventory/web/images/armour.png', blocked: 'tier_locked', tier: 3 },
      ] });
      case 'getNearby': return ok([{ id: 14, distance: 2 }, { id: 31, distance: 4 }]);
      case 'getTags': return ok({ canSpray: true, canDesign: true, requireApproval: true, maxDesigns: 3, maxTextLength: 14, maxPerZone: 6,
        activeTags: 3, activeZones: 2, sprayItem: 'spraycan', styles: ['plain', 'outline', 'shadow'], canRemove: true,
        allowPictures: true, onlyInAreas: true, logo: 'images/gang_tablet.png', hosts: ['i.imgur.com', 'i.ibb.co', 'r2.fivemanage.com'],
        onWalls: [
          { area: 'Davis', inArea: true, active: 2, limit: 6, tags: [
            { id: 11, design: 'Main tag', spec: { text: 'GROVE KINGS', font: 'handstyle', style: 'outline', fill: '#7B3FBF', outline: '#111418' }, status: 'active', age: 2400, x: -100, y: -1700 },
            { id: 9, design: 'Main tag', spec: { text: 'GROVE KINGS', font: 'handstyle', style: 'outline', fill: '#7B3FBF', outline: '#111418' }, status: 'crossed', crossedBy: 'Los Vagos', age: 190000, x: -90, y: -1650 }] },
          { area: 'Rancho', inArea: true, active: 1, limit: 6, tags: [
            { id: 12, design: 'GK throwie', spec: { text: 'GK', font: 'block', style: 'shadow', fill: '#F2A93B', outline: '#7B3FBF' }, status: 'active', age: 9000, x: 450, y: -1850 }] }],
        fonts: [{ key: 'handstyle', label: 'Handstyle', family: 'Sedgwick Ave Display' }, { key: 'spray', label: 'Spray', family: 'Rubik Spray Paint' }, { key: 'marker', label: 'Marker', family: 'Permanent Marker' }, { key: 'block', label: 'Block', family: 'Bungee' }],
        designs: [
          { id: 1, name: 'Main tag', status: 'approved', inUse: 5, spec: { text: 'GROVE KINGS', font: 'handstyle', style: 'outline', fill: '#7B3FBF', outline: '#111418' } },
          { id: 2, name: 'GK throwie', status: 'pending', inUse: 0, spec: { text: 'GK', font: 'block', style: 'shadow', fill: '#F2A93B', outline: '#7B3FBF' } },
        ] });
      default: return ok();
    }
  },
};

if (!IN_GAME && !location.search.includes('admin') && !location.search.includes('game=')) {
  window.postMessage({
    action: 'open',
    gang: Mock.gang,
    static: {
      currency: '£', creationCost: 50000, allowCreation: true, nameMin: 3, nameMax: 24, maxTransaction: 1000000, graffiti: true, contracts: true, rackets: true, safehouses: true, enterprises: true, diplomacy: true, informants: true, auctions: true, progression: true, shop: true, heists: true, airdrops: false,
      hexMode: true, hexSize: 150, hexOrigin: { x: 0, y: 0 },
      tabletMap: { image: 'images/map.jpg', size: 2048, scaleX: 0.16576, offsetX: 938.4, scaleY: -0.164, offsetY: 1382.4, nudgeX: 0, nudgeY: 0 },
      tiers: [{ label: 'Street crew', unlocks: [] }, { label: 'Firm', unlocks: ['rackets', 'safehouses', 'contracts_medium'] }, { label: 'Organisation', unlocks: ['enterprises', 'diplomacy', 'second_safehouse'] }, { label: 'Syndicate', unlocks: ['auctions', 'contracts_high'] }], logos: true, logoApproval: true, logoHosts: ['i.imgur.com', 'i.ibb.co', 'r2.fivemanage.com'],
      zones: [
        { key: 'davis', label: 'Davis', points: [[-250, -1900], [100, -1900], [100, -1550], [-250, -1550]] },
        { key: 'strawberry', label: 'Strawberry', points: [[-350, -1550], [-100, -1550], [-100, -1250], [-350, -1250]] },
        { key: 'rancho', label: 'Rancho', points: [[250, -2050], [600, -2050], [600, -1650], [250, -1650]] },
        { key: 'paleto', label: 'Palato Bay', points: [[-250, 6200], [-50, 6200], [-50, 6400], [-250, 6400]] },
      ],
      permissions: [
        { key: 'manage_members', label: 'Invite, kick and promote members' },
        { key: 'manage_ranks', label: 'Edit ranks and permissions' },
        { key: 'treasury_view', label: 'See the treasury' },
        { key: 'treasury_withdraw', label: 'Withdraw from the treasury' },
        { key: 'treasury_deposit', label: 'Deposit into the treasury' },
        { key: 'graffiti', label: 'Spray the gang\'s tag' },
        { key: 'contracts_accept', label: 'Take on contracts' },
      ],
    },
  }, '*');
}
