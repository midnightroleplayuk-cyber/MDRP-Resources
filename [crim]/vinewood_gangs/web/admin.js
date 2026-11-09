'use strict';

/* Staff panel opened with /gangadmin. Reuses the helpers and styles from app.js. */

const admin = {
  tab: 'home',
  gangId: null, // open gang detail
  renderId: 0,
};

async function adminRequest(action, ...args) {
  if (!IN_GAME) return AdminMock.request(action, args);
  try {
    const res = await fetch(`https://${RESOURCE}/adminRequest`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ action, args }),
    });
    return await res.json();
  } catch (err) {
    return { ok: false, error: 'The panel lost connection. Close it and try again.' };
  }
}

async function adminAct(action, args, successMessage) {
  const res = await adminRequest(action, ...(args || []));
  if (res.ok) {
    if (successMessage) toast(successMessage);
    renderAdminTab();
  } else {
    toast(res.error || 'That didn\'t work.', true);
  }
  return res.ok;
}

const ADMIN_TABS = [
  { id: 'gangs', label: 'Gangs', icon: 'gangs', tint: '#5EC2A0' },
  { id: 'turf', label: 'Turf', icon: 'territory', tint: '#5FB4E8' },
  { id: 'rackets', label: 'Rackets', icon: 'rackets', tint: '#E2BE5A' },
  { id: 'safehouses', label: 'Safehouses', icon: 'safehouses', tint: '#E88686' },
  { id: 'enterprises', label: 'Businesses', icon: 'business', tint: '#6FD0C0' },
  { id: 'spots', label: 'Contract spots', icon: 'pin', tint: '#B793F0' },
  { id: 'jobs', label: 'Contracts', icon: 'contracts', tint: '#B793F0' },
  { id: 'heists', label: 'Heists', icon: 'vault', tint: '#E88686' },
  { id: 'drugs', label: 'Street dealing', icon: 'pill', tint: '#6CC070' },
  { id: 'diplomacy', label: 'Diplomacy', icon: 'diplomacy', tint: '#8FB3FF' },
  { id: 'director', label: 'Street events', icon: 'bolt', tint: '#F0AD4E' },
  { id: 'informants', label: 'Informants', icon: 'phone', tint: '#A6AEB9' },
  { id: 'auctions', label: 'Black market', icon: 'market', tint: '#D592D2' },
  { id: 'reviews', label: 'Reviews', icon: 'check', tint: '#6CC070' },
  { id: 'tags', label: 'Tags in world', icon: 'tags', tint: '#E39A6B' },
  { id: 'staff', label: 'Staff access', icon: 'shield', tint: '#7AA2FF', needs: 'management' },
];

const APP_NEEDS = { informants: 'informants', reviews: 'reviews' };

function adminCan(group) {
  const a = state.static.access;
  if (!a) return true; // browser preview
  if (a.role === 'management') return true;
  if (group === 'management') return false;
  return !!(a.perms && a.perms[group]);
}

function visibleAdminApps() {
  return ADMIN_TABS.filter((t) => (!t.show || t.show()) && adminCan(t.needs || APP_NEEDS[t.id] || 'view'));
}

function renderAdminFrame() {
  applyAccent(null);
  setLogo(null);
  updateClock();
  $('logo-add').hidden = true;
  $('home-badge').replaceChildren(icon('shield'));
  $('home-badge').hidden = false;
  $('status-title').textContent = 'Staff';
  $('tag').textContent = 'Gang admin';
  const access = state.static.access;
  $('sub').textContent = access && access.role === 'staff'
    ? 'Staff access. Some tools are management only. Every change is logged.'
    : 'Management. Every change here is logged.';
  if (admin.tab === 'home') {
    showHome(visibleAdminApps().map((t) => appIcon(t, () => { admin.tab = t.id; admin.gangId = null; admin.heist = null; admin.drugDraft = null; admin.turfDraft = null; admin.job = null; admin.contractDraft = null; admin.bmDraft = null; admin.auctionTab = null; renderAdminFrame(); })));
    return;
  }
  showApp(ADMIN_TABS.find((t) => t.id === admin.tab).label);
  renderAdminTab();
}

async function renderAdminTab() {
  if (state.mode !== 'admin') return;
  const id = ++admin.renderId;
  let content;
  if (admin.tab === 'gangs') content = admin.gangId ? await renderGangDetail(admin.gangId) : await renderGangList();
  else if (admin.tab === 'rackets') content = await renderAdminRackets();
  else if (admin.tab === 'safehouses') content = await renderAdminSafehouses();
  else if (admin.tab === 'enterprises') content = await renderAdminEnterprises();
  else if (admin.tab === 'spots') content = await renderAdminSpots();
  else if (admin.tab === 'heists') content = admin.heist ? renderHeistEditor() : await renderHeistList();
  else if (admin.tab === 'drugs') content = await renderAdminDrugs();
  else if (admin.tab === 'staff') content = await renderStaffAccess();
  else if (admin.tab === 'turf') content = await renderTurfSettings();
  else if (admin.tab === 'jobs') content = admin.job ? renderJobEditor() : (admin.jobTab === 'standard' ? await renderContractSettings() : await renderJobList());
  else if (admin.tab === 'diplomacy') content = await renderAdminDiplomacy();
  else if (admin.tab === 'director') content = h('div', {}, await renderAdminDirector(), await renderAdminAirdrops(), await renderAirdropSchedules());
  else if (admin.tab === 'informants') content = await renderAdminInformants();
  else if (admin.tab === 'auctions') content = admin.auctionTab === 'settings' ? await renderBlackmarketSettings() : await renderAdminAuctions();
  else if (admin.tab === 'reviews') content = await renderReviews();
  else if (admin.tab === 'tags') content = await renderWorldTags();
  if (id !== admin.renderId || !content) return;
  $('view').replaceChildren(content);
  hideRepeatedTitle();
}

function swatchLabel(colour, label) {
  return h('span', { class: 'owner', style: 'color:var(--chalk);font-size:15px' },
    h('span', { class: 'swatch', style: `background:${colour || '#8A949E'}` }), label);
}

function select(options, value) {
  const el = h('select', {});
  options.forEach((o) => el.append(h('option', { value: String(o.value), selected: String(o.value) === String(value) }, o.label)));
  return el;
}

async function playerSelect(filter) {
  const res = await adminRequest('onlinePlayers');
  const players = (res.ok ? res.data : []).filter(filter || (() => true));
  if (!players.length) return null;
  return select(players.map((p) => ({ value: p.id, label: `${p.name} (ID ${p.id})${p.gang ? `, in ${p.gang}` : ''}` })));
}

/* Gangs ----------------------------------------------------------------- */

async function renderGangList() {
  const res = await adminRequest('listGangs');
  if (!res.ok) return loadError(res);

  const rows = res.data.map((g) => h('tr', { class: 'clickable', onclick: () => { admin.gangId = g.id; renderAdminTab(); } },
    h('td', {}, g.logo ? h('img', { class: 'thumb', src: g.logo, alt: '', onerror: (e) => e.target.remove() }) : null, swatchLabel(g.colour, g.label)),
    h('td', { class: 'muted', text: g.name }),
    h('td', { class: 'num fig', text: g.members }),
    h('td', { class: 'num fig', text: g.zones }),
    h('td', { class: 'num fig', text: g.heat })));

  const creation = await adminRequest('gangCreation');
  return h('div', {},
    creation.ok ? creationCard(creation.data) : null,
    h('div', { class: 'section-head' },
      h('h2', {}, 'Gangs ', h('span', { class: 'muted fig', text: res.data.length })),
      h('button', { class: 'btn primary', type: 'button', onclick: openCreateGang }, 'New gang')),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Gang' }), h('th', { text: 'Short name' }), h('th', { class: 'num', text: 'Members' }), h('th', { class: 'num', text: 'Areas held' }), h('th', { class: 'num', text: 'Heat' }))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No gangs yet. Create one and pick an online player to lead it.' }));
}

async function openCreateGang() {
  const boss = await playerSelect((p) => !p.gang);
  if (!boss) { toast('Nobody online who isn\'t already in a gang.', true); return; }
  const name = h('input', { type: 'text', maxlength: state.static.nameMax, spellcheck: false });
  const label = h('input', { type: 'text', maxlength: 64 });
  const colour = h('input', { type: 'color', value: '#F2A93B' });

  showModal(
    h('h2', { text: 'New gang' }),
    h('p', { text: 'Free of charge. The player you pick becomes the boss.' }),
    h('div', { class: 'form' },
      h('label', { class: 'field' }, 'Boss', boss),
      h('label', { class: 'field' }, 'Gang name', label),
      h('label', { class: 'field' }, 'Short name', name,
        h('span', { class: 'hint', text: 'Letters, numbers and underscores only.' })),
      h('label', { class: 'field' }, 'Colour', colour)),
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: async () => {
          const ok = await adminAct('createGang', [Number(boss.value), name.value.trim(), label.value.trim() || name.value.trim(), colour.value], 'Gang created.');
          if (ok) hideModal();
        },
      }, 'Create gang')),
  );
}

async function renderGangDetail(gangId) {
  const res = await adminRequest('gangDetail', gangId);
  if (!res.ok) { admin.gangId = null; return loadError(res); }
  const { gang, members, ranks, maxMembers } = res.data;
  const gradeOptions = ranks.map((r) => ({ value: r.grade, label: r.label }));

  const rows = members.map((m) => {
    const grade = select(gradeOptions, m.grade);
    grade.setAttribute('aria-label', `Rank for ${m.name}`);
    grade.addEventListener('change', () => adminAct('setGrade', [m.citizenid, Number(grade.value)], `${m.name} moved to ${grade.selectedOptions[0].textContent}.`));
    return h('tr', {},
      h('td', {}, m.name),
      h('td', {}, grade),
      h('td', {}, h('span', { class: m.online ? 'status on' : 'status', text: m.online ? 'Online' : 'Offline' })),
      h('td', { class: 'actions' }, h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Remove ${m.name}?`,
          body: `They'll be taken out of ${gang.label} straight away.`,
          confirmLabel: 'Remove from gang',
          danger: true,
          onConfirm: () => adminAct('removeMember', [m.citizenid], `${m.name} removed.`),
        }),
      }, 'Remove')));
  });

  return h('div', {},
    h('button', { class: 'back', type: 'button', onclick: () => { admin.gangId = null; renderAdminTab(); } }, 'All gangs'),
    h('div', { class: 'section-head' },
      h('h2', {}, swatchLabel(gang.colour, gang.label), ' ', h('span', { class: 'muted', text: gang.name })),
      h('button', { class: 'btn', type: 'button', onclick: () => openAddMember(gang, gradeOptions) }, 'Add player')),
    gang.tier && (state.static.tiers || []).length ? h('div', { class: 'row', style: 'align-items:center;margin-bottom:14px' },
      h('span', { class: 'muted', text: 'Tier' }),
      (() => {
        const sel = select(state.static.tiers.map((t, i) => ({ value: i + 1, label: `${i + 1}. ${t.label}` })), gang.tier);
        sel.addEventListener('change', () => confirmModal({
          title: `Set ${gang.label} to ${sel.selectedOptions[0].textContent}?`,
          body: 'Their milestones are treated as met up to that tier, and their reputation is raised to its requirement if it\'s lower.',
          confirmLabel: 'Set tier', onConfirm: () => adminAct('setTier', [gang.id, Number(sel.value)], 'Tier set.'),
        }));
        return sel;
      })()) : null,
    h('div', { class: 'brief compact' },
      h('p', {}, h('span', { class: 'fig', text: `${members.length}/${maxMembers}` }), ' members. Heat ', h('span', { class: 'fig', text: gang.heat }), ', reputation ', h('span', { class: 'fig', text: gang.reputation }), '.'),
      h('p', {}, gang.zoneNames.length ? `Holds ${joinList(gang.zoneNames)}.` : 'Holds no areas.'),
      h('p', {}, h('span', { class: 'fig', text: money(gang.clean) }), ' clean and ', h('span', { class: 'fig', text: money(gang.dirty) }), ' dirty in the treasury.')),
    h('table', {},
      h('thead', {}, h('tr', {}, h('th', { text: 'Name' }), h('th', { text: 'Rank' }), h('th', { text: 'Status' }), h('th', {}))),
      h('tbody', {}, rows)),
    reputationBlock(gang),
    await turfBlock(gang),
    h('div', { class: 'block', style: 'margin-top:28px' },
      h('h3', { text: 'Disband this gang' }),
      h('p', { text: 'Removes every member, clears their territory and takes their tags off the walls.' }),
      h('button', {
        class: 'btn danger', type: 'button',
        onclick: () => confirmModal({
          title: `Disband ${gang.label}?`,
          body: 'This can\'t be undone.',
          confirmLabel: 'Disband gang',
          danger: true,
          typeToConfirm: gang.name,
          onConfirm: async () => { if (await adminAct('disband', [gang.id], 'Gang disbanded.')) { admin.gangId = null; renderAdminTab(); } },
        }),
      }, 'Disband gang')));
}

/* Gangs app: who can start a gang and what it costs */
function creationCard(r) {
  const edit = () => {
    const allow = h('input', { type: 'checkbox', checked: r.allow });
    const cost = h('input', { type: 'number', min: 0, step: 1000, value: r.cost, style: 'width:140px' });
    const account = select([{ value: 'bank', label: 'Bank' }, { value: 'cash', label: 'Cash' }], r.account);
    showModal(
      h('h2', { text: 'Starting a gang' }),
      h('label', { class: 'toggle', style: 'margin-bottom:14px' }, allow, ' Players can start their own gang from the tablet'),
      h('p', { class: 'hint', text: 'Turned off, only staff can create gangs (New gang, here in Gangs).' }),
      h('div', { class: 'row', style: 'align-items:end;margin-top:8px' },
        h('label', { class: 'field' }, 'Price (0 = free)', cost),
        h('label', { class: 'field' }, 'Paid from', account)),
      h('div', { class: 'buttons' },
        !r.fromConfig ? h('button', { class: 'btn', type: 'button', style: 'margin-right:auto', onclick: async () => { if (await adminAct('gangCreationReset', [], 'Back to the config settings.')) hideModal(); } }, 'Reset to config') : null,
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn primary', type: 'button', onclick: async () => {
          if (await adminAct('gangCreationSave', [{ allow: allow.checked, cost: Math.max(0, Math.floor(Number(cost.value) || 0)), account: account.value }], 'Saved. It applies straight away.')) hideModal();
        } }, 'Save')));
  };
  const summary = !r.allow ? 'Only staff can create gangs.'
    : (r.cost > 0 ? `Players can start a gang from the tablet for ${money(r.cost)} from their ${r.account}.` : 'Players can start a gang from the tablet for free.');
  return h('div', { class: 'heist-edit-start', style: 'margin-bottom:18px' },
    h('div', {}, h('strong', { text: 'Starting a gang' }), h('div', { class: 'hint', style: 'margin:0', text: summary })),
    h('button', { class: 'btn small', type: 'button', onclick: edit }, 'Change'));
}

/* Gang page: add or take away reputation */
function reputationBlock(gang) {
  const amount = h('input', { type: 'number', step: 1, value: 25, style: 'width:100px', 'aria-label': 'Reputation amount' });
  const go = (sign) => {
    const n = Math.abs(Math.floor(Number(amount.value) || 0));
    if (!n) return toast('Enter an amount.', true);
    adminAct('adjustReputation', [gang.id, sign * n], `${sign > 0 ? 'Added' : 'Took away'} ${n} reputation.`);
  };
  return h('div', { class: 'block', style: 'margin-top:28px' },
    h('h3', { text: 'Reputation' }),
    h('p', {}, h('span', { class: 'fig', style: 'color:var(--chalk);font-size:20px', text: gang.reputation }),
      gang.tierLabel ? ` reputation, so the gang is ${/^[AEIOU]/.test(gang.tierLabel) ? 'an' : 'a'} ${gang.tierLabel}. Changing it moves them up or down a tier straight away if they cross a line.` : ' reputation.'),
    h('div', { class: 'row' }, amount,
      h('button', { class: 'btn primary', type: 'button', onclick: () => go(1) }, 'Add'),
      h('button', { class: 'btn danger', type: 'button', onclick: () => go(-1) }, 'Remove')));
}

/* Gang page: their hex turf */
async function turfBlock(gang) {
  const res = await adminRequest('hexGang', gang.id);
  const v = res.ok ? res.data : { hexes: [], startHexes: 2 };
  const setControl = (x) => {
    const input = h('input', { type: 'number', min: 0, max: 100, value: Math.round(x.control), style: 'width:100px' });
    showModal(
      h('h2', { text: `${x.label}: control` }),
      h('p', { text: 'Set the control %. A hex that isn\'t part of the compound is lost at 0%.' }),
      h('div', { class: 'row', style: 'align-items:center' }, input, h('span', { text: '%' })),
      h('div', { class: 'buttons' },
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn primary', type: 'button', onclick: async () => { if (await adminAct('hexControl', [x.key, Number(input.value)], 'Control set.')) hideModal(); } }, 'Set')));
  };
  const rows = v.hexes.map((x) => h('tr', {},
    h('td', {}, h('strong', { text: x.label }), x.main ? h('span', { class: 'you', text: 'main' }) : (x.compound ? h('span', { class: 'you', style: 'opacity:.7', text: 'compound' }) : null)),
    h('td', { class: 'num fig', text: `${Math.round(x.control)}%` }),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', onclick: () => setControl(x) }, 'Set %'),
      !x.main ? h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('hexMain', [x.key], 'Main hex changed.') }, 'Make main') : null,
      h('button', { class: 'btn small danger', type: 'button', onclick: () => confirmModal({ title: `Take ${x.label} off them?`, body: 'The hex becomes free ground. Tags on it stay up.', confirmLabel: 'Remove', danger: true, onConfirm: () => adminAct('hexRemove', [x.key], 'Hex removed.') }) }, 'Remove'))));
  const left = Math.max(0, v.startHexes - v.hexes.length);
  return h('div', { class: 'block' },
    h('h3', { text: 'Turf' }),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: v.hexes.length
      ? `${v.hexes.length} ${v.hexes.length === 1 ? 'hex' : 'hexes'}. ${left ? `Give them ${left} more for their starting compound.` : 'After the compound, they buy new ground themselves from the tablet.'}`
      : `They have no turf yet. Stand in the hex that should be their main compound and press the button, then do the same for the rest of their compound (${v.startHexes} hexes).` }),
    rows.length ? h('table', {}, h('tbody', {}, rows)) : null,
    h('div', { class: 'row', style: 'margin-top:10px' },
      h('button', { class: 'btn primary', type: 'button', onclick: () => hexMapPicker(gang, v.hexes) }, 'Pick on the map'),
      h('button', { class: 'btn', type: 'button', onclick: async () => {
        const r = await adminRequest('hexGive', gang.id);
        if (!r.ok) return toast(r.error, true);
        toast(`Gave them ${r.data}.`);
        renderAdminTab();
      } }, 'Give them the hex I\'m standing in')));
}

/* Pick hexes on the map to give a gang (staff see every gang's turf here) */
async function hexMapPicker(gang, theirs) {
  const res = await adminRequest('hexMap');
  if (!res.ok) return toast(res.error, true);
  let claimed = res.data;
  const byKey = () => Object.fromEntries(claimed.map((x) => [x.key, x]));
  const R = state.static.hexSize || 150;
  const tm = state.static.tabletMap;

  const map = svg('svg', { class: 'map has-picture hex-picker', role: 'img', 'aria-label': 'Pick a hex' });
  if (tm && tm.image) {
    const left = (0 - tm.offsetX) / tm.scaleX + (tm.nudgeX || 0);
    const top = (0 - tm.offsetY) / tm.scaleY + (tm.nudgeY || 0);
    map.append(svg('image', { href: tm.image, x: left, y: -top, width: tm.size / tm.scaleX, height: tm.size / Math.abs(tm.scaleY), preserveAspectRatio: 'none' }));
  }
  const grid = svg('g', { class: 'hex-grid' });
  const owned = svg('g', {});
  const hover = svg('polygon', { class: 'hex-hover', points: '' });
  const picked = svg('polygon', { class: 'hex-picked', points: '' });
  map.append(grid, owned, hover, picked);
  const pts = (q, r) => hexCorners(q, r).map(([x, y]) => `${x},${-y}`).join(' ');

  const drawOwned = () => owned.replaceChildren(...claimed.map((x) => svg('polygon', {
    points: pts(x.q, x.r), fill: x.colour, 'fill-opacity': x.gangId === gang.id ? 0.6 : 0.4,
    stroke: x.gangId === gang.id ? '#ffffff' : '#1C2127', 'stroke-width': x.gangId === gang.id ? 2 : 1, 'vector-effect': 'non-scaling-stroke' })));

  // Start on their turf, or Los Santos
  const mine = claimed.filter((x) => x.gangId === gang.id);
  let view = { cx: 0, cy: -900, half: 2200 };
  if (mine.length) { const [cx, cy] = hexCentre(mine[0].q, mine[0].r); view = { cx, cy, half: 900 }; }
  // The grid is only drawn zoomed in (otherwise it's thousands of hexes)
  const drawGrid = () => {
    if (view.half > 1600) { grid.replaceChildren(); return; }
    const [q0, r0] = hexFromCoords(view.cx, view.cy);
    const hx = view.half * aspect();
    const n = Math.ceil(Math.max(hx, view.half) / (R * 1.4)) + 2;
    const cells = [];
    for (let dr = -n; dr <= n; dr += 1) for (let dq = -n - Math.ceil(n / 2); dq <= n + Math.ceil(n / 2); dq += 1) {
      const q = q0 + dq, r = r0 + dr;
      const [x, y] = hexCentre(q, r);
      if (Math.abs(x - view.cx) < hx + R && Math.abs(y - view.cy) < view.half + R) cells.push(svg('polygon', { points: pts(q, r) }));
    }
    grid.replaceChildren(...cells);
  };
  // view.half is half the visible height; the width follows the map's real shape on screen
  const aspect = () => { const r = map.getBoundingClientRect(); return r.height ? r.width / r.height : 1; };
  const apply = () => {
    const hx = view.half * aspect();
    map.setAttribute('viewBox', `${view.cx - hx} ${-view.cy - view.half} ${hx * 2} ${view.half * 2}`);
    drawGrid();
  };
  const toWorld = (e) => {
    const r = map.getBoundingClientRect();
    const fx = (e.clientX - r.left) / (r.width || 1), fy = (e.clientY - r.top) / (r.height || 1);
    const hx = view.half * aspect();
    return [view.cx - hx + fx * 2 * hx, view.cy + view.half - fy * 2 * view.half];
  };

  // Details of the picked hex and the Give button
  const info = h('div', { class: 'hex-pick-info' });
  let sel = null;
  const showInfo = () => {
    if (!sel) { info.replaceChildren(h('p', { class: 'hint', style: 'margin:0', text: 'Zoom in and click a hex. Your gang\'s hexes have a white outline; other colours are other gangs.' })); return; }
    const owner = byKey()[`h:${sel[0]}:${sel[1]}`];
    const label = owner ? owner.label : hexLabel(sel[0], sel[1]);
    info.replaceChildren(...[
      h('strong', { text: label }),
      h('div', { class: 'hint', style: 'margin:2px 0 8px', text: owner
        ? (owner.gangId === gang.id ? `Already theirs (${owner.control}% control${owner.main ? ', main hex' : ''}).` : `Held by ${owner.gang}. Remove it from them first if you want to move it.`)
        : 'Free ground.' }),
      !owner ? h('button', { class: 'btn primary', type: 'button', onclick: async () => {
        const r = await adminRequest('hexGive', gang.id, sel[0], sel[1]);
        if (!r.ok) return toast(r.error, true);
        toast(`Gave ${gang.label} ${r.data}.`);
        const again = await adminRequest('hexMap');
        if (again.ok) claimed = again.data;
        drawOwned(); showInfo();
      } }, `Give ${gang.label} this hex`) : null].filter(Boolean));
  };

  let drag = null, dragged = false;
  map.addEventListener('mousemove', (e) => {
    if (drag) return;
    const [x, y] = toWorld(e);
    const [q, r] = hexFromCoords(x, y);
    hover.setAttribute('points', pts(q, r));
  });
  map.addEventListener('mouseleave', () => hover.setAttribute('points', ''));
  map.addEventListener('click', (e) => {
    if (dragged) return;
    const [x, y] = toWorld(e);
    sel = hexFromCoords(x, y);
    picked.setAttribute('points', pts(sel[0], sel[1]));
    if (view.half > 1600) { const [cx, cy] = hexCentre(sel[0], sel[1]); view = { cx, cy, half: 900 }; apply(); }
    showInfo();
  });
  map.addEventListener('wheel', (e) => {
    e.preventDefault();
    const r = map.getBoundingClientRect();
    const fx = (e.clientX - r.left) / (r.width || 1), fy = (e.clientY - r.top) / (r.height || 1);
    const [wx, wy] = toWorld(e);
    const half = Math.min(6000, Math.max(300, view.half * (e.deltaY > 0 ? 1.25 : 0.8)));
    view = { cx: wx - (fx * 2 - 1) * half * aspect(), cy: wy + (fy * 2 - 1) * half, half };
    apply();
  }, { passive: false });
  map.addEventListener('mousedown', (e) => { drag = { x: e.clientX, y: e.clientY, view: { ...view } }; dragged = false; });
  mapDragHandlers = {
    move: (e) => {
      if (!drag || !map.isConnected) return;
      const r = map.getBoundingClientRect();
      if (Math.abs(e.clientX - drag.x) + Math.abs(e.clientY - drag.y) > 4) dragged = true;
      if (!dragged) return;
      view = { cx: drag.view.cx - (e.clientX - drag.x) / (r.width || 1) * 2 * drag.view.half * aspect(), cy: drag.view.cy + (e.clientY - drag.y) / (r.height || 1) * 2 * drag.view.half, half: drag.view.half };
      apply();
    },
    up: () => { drag = null; setTimeout(() => { dragged = false; }, 0); },
  };

  drawOwned(); showInfo();
  $('sheet').classList.add('xwide');
  showModal(
    h('h2', { text: `Give ${gang.label} turf` }),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: `Scroll to zoom, drag to move, click a hex. Their first ${theirs.length ? 'hexes were' : 'two hexes are'} their compound; the first is their main hex.` }),
    h('div', { class: 'hex-pick' }, map, info),
    h('div', { class: 'buttons' }, h('button', { class: 'btn primary', type: 'button', onclick: () => { hideModal(); renderAdminTab(); } }, 'Done')));
  requestAnimationFrame(apply);
}

/* Turf settings */
async function renderTurfSettings() {
  const res = await adminRequest('hexSettings');
  if (!res.ok) return loadError(res);
  const v = admin.turfDraft || (admin.turfDraft = JSON.parse(JSON.stringify(res.data)));
  const rerender = () => renderAdminTab();
  const num = (obj, key, min, max, width = 90) => {
    const el = h('input', { type: 'number', min, max, step: 'any', value: obj[key] ?? '', style: `width:${width}px` });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };
  v.expandCost = v.expandCost || { money: 0, account: 'dirty' };
  const drugs = (v.turfDrugItems || []).map((d, i) => {
    // This drug's own control per unit (blank = the default below)
    const rate = h('input', { type: 'number', min: 0.01, max: 100, step: 'any', value: d.perUnit ?? '', placeholder: String(v.controlPerSale ?? ''), style: 'width:90px' });
    rate.addEventListener('change', () => { d.perUnit = rate.value === '' ? null : Number(rate.value); });
    return h('div', {},
    h('div', { class: 'row turf-drug-row' },
      h('div', { class: 'field', style: 'flex:1 1 auto;min-width:0;max-width:520px' }, i === 0 ? 'Drug' : '',
        itemPicker(d.name ? { item: d.name, label: d.label, image: d.image } : null, (it) => { if (it) { v.turfDrugItems[i] = { name: it.name, label: it.label, image: it.image, exists: true, perUnit: d.perUnit }; rerender(); } }, { allowClear: false, openNow: !d.name, emptyText: 'No item chosen yet' })),
      h('label', { class: 'field', style: 'width:140px;flex:none' }, i === 0 ? '% control per unit' : '', rate),
      h('button', { class: 'btn small danger', type: 'button', style: 'align-self:end;margin-bottom:6px', onclick: () => { v.turfDrugItems.splice(i, 1); rerender(); } }, 'Remove')),
    d.name && d.exists === false ? h('p', { class: 'hint debit', style: 'margin:4px 0 0', text: `There's no item called "${d.name}" on your server, so nothing builds control. Use Change to pick your real one.` })
      : (d.name && d.sellable === false ? h('p', { class: 'hint debit', style: 'margin:4px 0 0', text: `${d.label} isn't on the Street dealing list, so it can't be sold. Add it there.` }) : null));
  });
  const anyDrug = h('input', { type: 'checkbox', checked: v.anyDrugCounts === true });
  anyDrug.addEventListener('change', () => { v.anyDrugCounts = anyDrug.checked; rerender(); });
  const accountSel = select([{ value: 'dirty', label: 'Dirty money' }, { value: 'clean', label: 'Clean money' }], v.expandCost.account || 'dirty');
  accountSel.addEventListener('change', () => { v.expandCost.account = accountSel.value; });

  const save = async () => {
    const data = { ...v, turfDrugs: (v.turfDrugItems || []).filter((d) => d.name).map((d) => ({ item: d.name, perUnit: d.perUnit ?? null })) };
    const r = await adminRequest('hexSettingsSave', data);
    if (!r.ok) return toast(r.error, true);
    admin.turfDraft = null;
    toast('Turf settings saved. They apply straight away.');
    rerender();
  };

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Turf' }), h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save')),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: `The map is split into hexes (${v.size} m). Gangs start with a compound you give them (open a gang in Gangs), build control by selling the turf drug there, and buy the ground next to a hex at full control. Rival turf stays hidden until a gang deals on it.` }),
    h('h3', { text: 'Turf drug' }),
    h('label', { class: 'toggle', style: 'margin:0 0 10px' }, anyDrug, ' Any drug builds control (not just the ones below)'),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: v.anyDrugCounts
      ? 'Every drug builds control when sold on your own hex: the ones below at their own rate, any others at the default rate (under Control).'
      : 'Selling these on your own hex builds its control, each at its own rate per unit (leave it blank to use the default under Control). They also need to be on the Street dealing list so they can be sold.' }),
    h('div', { style: 'display:grid;gap:8px' }, drugs),
    h('button', { class: 'btn small', type: 'button', style: 'margin-top:8px', onclick: () => { v.turfDrugItems = v.turfDrugItems || []; v.turfDrugItems.push({ name: null, label: null, perUnit: null }); rerender(); } }, 'Add a turf drug'),
    h('h3', { style: 'margin-top:22px', text: 'Control' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Default % per unit (drugs without their own)', num(v, 'controlPerSale', 0.1, 100)),
      h('label', { class: 'field' }, '% lost per unit a rival sells', num(v, 'rivalLoss', 0, 100)),
      h('label', { class: 'field' }, '% every hex loses per hour', num(v, 'decayPerHour', 0, 100)),
      (() => { const c = h('input', { type: 'checkbox', checked: v.decayOnlyOnline !== false }); c.addEventListener('change', () => { v.decayOnlyOnline = c.checked; });
        return h('label', { class: 'toggle', style: 'align-self:end;padding-bottom:8px' }, c, ' Only while a member of that gang is online'); })(),
      h('label', { class: 'field' }, 'New hexes start at (%)', num(v, 'startControl', 0, 100))),
    h('h3', { style: 'margin-top:8px', text: 'Buying new ground' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'A touching hex needs (%)', num(v, 'expandAt', 1, 100)),
      h('label', { class: 'field' }, 'Money', num(v.expandCost, 'money', 0, 100000000, 120)),
      h('label', { class: 'field' }, 'From', accountSel)),
    // The item and how many of it, side by side on their own line
    h('div', { class: 'heist-settings', style: 'flex-wrap:nowrap;align-items:flex-start' },
      h('div', { class: 'field', style: 'flex:0 1 460px;min-width:0' }, 'Plus this item from their pockets',
        itemPicker(v.expandCost.item ? { item: v.expandCost.item, label: v.expandItemLabel } : null, (it) => { v.expandCost.item = it ? it.name : null; v.expandItemLabel = it ? it.label : null; }, { emptyText: 'No item needed' })),
      h('label', { class: 'field' }, 'How many', num(v.expandCost, 'count', 0, 10000))),
    h('h3', { style: 'margin-top:8px', text: 'Tags' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'One extra tag for every … hexes', num(v, 'sprayEvery', 1, 50))),
    h('h3', { style: 'margin-top:8px', text: 'Map' }),
    (() => {
      const on = h('input', { type: 'checkbox', checked: v.mapEnabled !== false });
      const mini = h('input', { type: 'checkbox', checked: v.mapMinimap === true, disabled: v.mapEnabled === false });
      const who = select([{ value: 'gangs', label: 'Gang members' }, { value: 'everyone', label: 'Everyone' }], v.mapShowTo || 'gangs');
      who.disabled = v.mapEnabled === false;
      on.addEventListener('change', () => { v.mapEnabled = on.checked; mini.disabled = !on.checked; who.disabled = !on.checked; });
      mini.addEventListener('change', () => { v.mapMinimap = mini.checked; });
      who.addEventListener('change', () => { v.mapShowTo = who.value; });
      return h('div', {},
        h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'Turf shaded in each gang\'s colour on the pause map (players only ever see their own turf and rival turf their gang has found). Changes apply straight away for everyone.' }),
        h('div', { class: 'row', style: 'align-items:center;gap:22px' },
          h('label', { class: 'toggle' }, on, ' Show turf on the pause map'),
          h('label', { class: 'toggle' }, mini, ' Also on the minimap'),
          h('label', { class: 'field', style: 'flex-direction:row;align-items:center;gap:8px;display:flex' }, 'Who sees it', who)));
    })(),
    hexSizeSection(v));
}

/* Resizing the hex grid, live */
function hexSizeSection(v) {
  const size = h('input', { type: 'number', min: 20, max: 500, step: 5, value: v.size, style: 'width:100px' });
  const mode = select([
    { value: 'centre', label: 'Keep the same number of hexes (each becomes the one at its centre)' },
    { value: 'fill', label: 'Keep the same ground (each becomes every hex inside it)' },
  ], v.onResize || 'centre');
  const resize = () => {
    const to = Number(size.value);
    if (!to || to === v.size) return toast('Enter a new size first.', true);
    const ratio = (v.size / to) ** 2;
    const fill = mode.value === 'fill';
    const what = to < v.size
      ? (fill ? `Each gang's turf stays the same ground but becomes about ${Math.round(ratio * 0.85)} times as many hexes.` : `Each gang keeps the same number of hexes, each about ${Math.round(ratio)} times smaller, centred where the old ones were. Tags near the edge of a hex may end up off their turf.`)
      : (fill ? 'Hexes get bigger; turf that overlaps merges into the bigger hexes.' : 'Each gang keeps the same number of hexes, bigger, centred where the old ones were. Turf that overlaps merges.');
    confirmModal({
      title: `Resize hexes from ${v.size} m to ${to} m?`,
      body: `${what} Control, main and compound hexes, found rival hexes and tags all carry over. It happens straight away for everyone on the server.`,
      confirmLabel: 'Resize now', danger: true,
      onConfirm: async () => {
        const r = await adminRequest('hexResize', to, mode.value);
        if (!r.ok) return toast(r.error, true);
        toast(`Hexes are now ${r.data.to} m: ${r.data.before} became ${r.data.after}.`);
        admin.turfDraft = null;
        renderAdminTab();
      },
    });
  };
  return h('div', { style: 'margin-top:22px' },
    h('h3', { text: 'Hex size' }),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: `Hexes are ${v.size} m from the centre to a corner${v.configSize && v.configSize !== v.size ? ` (config/hexes.lua says ${v.configSize} m; the size set here is kept until someone changes the config)` : ''}. Resizing moves every gang's turf onto the new grid in the same place.` }),
    h('div', { class: 'row', style: 'align-items:end' },
      h('label', { class: 'field' }, 'New size (m)', size),
      h('label', { class: 'field', style: 'flex:1;min-width:280px' }, 'Existing turf', mode),
      h('button', { class: 'btn danger', type: 'button', style: 'margin-bottom:2px', onclick: resize }, 'Resize')));
}

async function openAddMember(gang, gradeOptions) {
  const player = await playerSelect();
  if (!player) { toast('Nobody online to add.', true); return; }
  const grade = select(gradeOptions, gradeOptions[gradeOptions.length - 1].value);
  showModal(
    h('h2', { text: `Add to ${gang.label}` }),
    h('p', { text: 'If they\'re already in another gang, they\'re moved across.' }),
    h('div', { class: 'form' },
      h('label', { class: 'field' }, 'Player', player),
      h('label', { class: 'field' }, 'Rank', grade)),
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: async () => { if (await adminAct('addMember', [Number(player.value), gang.id, Number(grade.value)], 'Player added.')) hideModal(); },
      }, 'Add player')),
  );
}


/* Auctions -------------------------------------------------------------- */

function auctionTabs() {
  const tab = admin.auctionTab || 'auctions';
  return h('div', { class: 'choices', role: 'radiogroup', style: 'margin-bottom:16px' },
    [['auctions', 'Auctions'], ['settings', 'Black market settings']].map(([key, label]) => h('button', {
      type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(tab === key),
      onclick: () => { admin.auctionTab = key; admin.bmDraft = null; renderAdminTab(); },
    }, label)));
}

/* Black market settings: contraband, lot types, timings (config/auctions.lua, changed in game) */
async function renderBlackmarketSettings() {
  if (!admin.bmDraft) {
    const res = await adminRequest('blackmarketSettings');
    if (!res.ok) return loadError(res);
    admin.bmDraft = res.data;
  }
  const v = admin.bmDraft;
  const rerender = () => renderAdminTab();
  const num = (obj, key, min, max, width = 90, step = 'any') => {
    const el = h('input', { type: 'number', min, max, step, value: obj[key] ?? '', style: `width:${width}px` });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };
  const pct = (obj, key) => {
    const el = h('input', { type: 'number', min: 0, max: 100, value: Math.round((obj[key] || 0) * 100), style: 'width:80px' });
    el.addEventListener('change', () => { obj[key] = Math.max(0, Math.min(100, Number(el.value))) / 100; });
    return el;
  };
  const range = (obj, key, label, width = 90) => {
    const lo = h('input', { type: 'number', min: 0, value: obj[key][0], style: `width:${width}px` });
    const hi = h('input', { type: 'number', min: 0, value: obj[key][1], style: `width:${width}px` });
    lo.addEventListener('change', () => { obj[key][0] = Number(lo.value); });
    hi.addEventListener('change', () => { obj[key][1] = Number(hi.value); });
    return h('label', { class: 'field' }, label, h('span', { class: 'row', style: 'flex-wrap:nowrap;align-items:center;gap:6px' }, lo, h('span', { class: 'muted', text: 'to' }), hi));
  };

  const items = v.items.map((it, i) => h('div', { class: 'loot-entry' },
    itemPicker(it.item ? { item: it.item, label: it.itemLabel || it.item } : null, (p) => { it.item = p ? p.name : null; it.itemLabel = p ? p.label : null; if (p && !it.label) { it.label = p.label; rerender(); } }, { allowClear: false, openNow: !it.item, emptyText: 'No item chosen yet' }),
    h('div', { class: 'loot-fields' },
      h('label', { class: 'field' }, 'Name on the lot', (() => { const t = h('input', { type: 'text', value: it.label || '', maxlength: 40, style: 'width:200px' }); t.addEventListener('input', () => { it.label = t.value; }); return t; })()),
      h('label', { class: 'field' }, 'How many in the lot', num(it, 'count', 1, 1000, 90, 1)),
      h('label', { class: 'field' }, 'Reserve price (£)', num(it, 'reserve', 100, 100000000, 120, 500)),
      h('button', { class: 'btn small danger', type: 'button', style: 'margin-left:auto;align-self:end', onclick: () => { v.items.splice(i, 1); rerender(); } }, 'Remove'))));

  const L = v.lots;
  const lot = (title, desc, body) => h('div', { class: 'loot-entry' }, h('strong', { text: title }), h('div', { class: 'hint', style: 'margin:0', text: desc }), h('div', { class: 'loot-fields' }, body));

  const save = async () => {
    if (v.items.some((it) => !it.item)) return toast('Pick an item for every contraband row, or remove it.', true);
    const r = await adminRequest('blackmarketSave', v);
    if (!r.ok) return toast(r.error, true);
    admin.bmDraft = r.data;
    toast('Saved. The next auction uses these settings.');
    rerender();
  };

  return h('div', {},
    auctionTabs(),
    h('div', { class: 'section-head' }, h('h2', { text: 'Black market settings' }),
      h('div', { class: 'row' },
        h('button', { class: 'btn small', type: 'button', onclick: () => confirmModal({ title: 'Go back to config/auctions.lua?', body: 'Your contraband list and settings here are replaced with the config ones.', confirmLabel: 'Reset', danger: true, onConfirm: async () => { const r = await adminRequest('blackmarketReset'); if (r.ok) { admin.bmDraft = r.data; toast('Back to the config settings.'); rerender(); } } }) }, 'Reset to config'),
        h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save'))),
    h('h3', { text: 'Contraband' }),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'Items auctioned as lots. The winner collects them from a dead drop, and rival gangs may be tipped off where it is.' }),
    items.length ? h('div', { style: 'display:grid;gap:8px' }, items) : h('p', { class: 'empty', text: 'No contraband yet, so item lots never come up.' }),
    h('button', { class: 'btn small', type: 'button', style: 'margin-top:8px', onclick: () => { v.items.push({ item: null, label: '', count: 1, reserve: 10000 }); rerender(); } }, 'Add an item'),
    h('h3', { style: 'margin-top:22px', text: 'Lot types' }),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'How often each kind of lot comes up (a higher number is likelier, 0 turns it off).' }),
    h('div', { style: 'display:grid;gap:8px' },
      lot('Contraband', 'One of the items above.', [h('label', { class: 'field' }, 'How often', num(L.items, 'weight', 0, 100, 80, 1))]),
      lot('Business supplies', 'Supplies for a gang business; the reserve is the amount times the supply cost times this.', [
        h('label', { class: 'field' }, 'How often', num(L.supplies, 'weight', 0, 100, 80, 1)), range(L.supplies, 'amount', 'Amount', 80),
        h('label', { class: 'field' }, 'Reserve per unit (×)', num(L.supplies, 'reservePerUnit', 0.01, 100, 80, 0.1))]),
      lot('An exclusive contract', 'A one-off job paying several times the usual reward.', [
        h('label', { class: 'field' }, 'How often', num(L.contract, 'weight', 0, 100, 80, 1)),
        h('label', { class: 'field' }, 'Reward (× usual)', num(L.contract, 'rewardMultiplier', 1, 20, 80, 0.5)), range(L.contract, 'reserve', 'Reserve (£)', 100)]),
      lot('A bent copper', 'Wipes some of the winning gang\'s heat.', [
        h('label', { class: 'field' }, 'How often', num(L.copper, 'weight', 0, 100, 80, 1)),
        h('label', { class: 'field' }, 'Heat wiped', num(L.copper, 'heat', 1, 1000, 80, 1)), range(L.copper, 'reserve', 'Reserve (£)', 100)]),
      lot('Connections', 'Adds control to the winner\'s weakest hex.', [
        h('label', { class: 'field' }, 'How often', num(L.connections, 'weight', 0, 100, 80, 1)),
        h('label', { class: 'field' }, 'Control added (%)', num(L.connections, 'influence', 1, 100, 80, 1)), range(L.connections, 'reserve', 'Reserve (£)', 100)])),
    h('h3', { style: 'margin-top:22px', text: 'Auctions' }),
    h('div', { class: 'heist-settings' },
      range(v, 'intervalMinutes', 'Time between auctions (min)', 70),
      h('label', { class: 'field' }, 'Bidding lasts (min)', num(v, 'biddingMinutes', 2, 120, 80, 1)),
      range(v, 'lotsPerAuction', 'Lots per auction', 60),
      h('label', { class: 'field' }, 'Players online needed', num(v, 'minPlayers', 0, 200, 80, 1)),
      h('label', { class: 'field' }, 'Each bid beats the last by (%)', pct(v, 'increment')),
      h('label', { class: 'field' }, 'Late bids extend by (s)', num(v, 'antiSnipe', 0, 600, 80, 1)),
      h('label', { class: 'field' }, 'Buy now (× reserve)', num(v, 'buyNowMultiplier', 1, 20, 80, 0.5))),
    h('h3', { style: 'margin-top:8px', text: 'Dead drops' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Time to collect (min)', num(v, 'dropMinutes', 5, 240, 80, 1)),
      h('label', { class: 'field' }, 'Rivals tipped off (%)', pct(v, 'tipChance')),
      h('label', { class: 'field' }, 'Winner\'s head start (s)', num(v, 'headStart', 0, 1800, 80, 10)),
      h('label', { class: 'field' }, 'Refund if nobody collects (%)', pct(v, 'unclaimedRefund'))));
}

async function renderAdminAuctions() {
  const res = await adminRequest('auctions');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const rows = v.lots.map((l) => h('tr', {},
    h('td', {}, h('strong', { text: l.title }), h('div', { class: 'hint', style: 'margin:0', text: l.status === 'open' ? `${l.bids} bids` : `Waiting at the dead drop near ${l.place}` })),
    h('td', {}, l.gang ? swatchLabel(l.colour, l.gang) : h('span', { class: 'muted', text: 'No bids' })),
    h('td', { class: 'num fig', text: l.topBid ? money(l.topBid) : '' }),
    h('td', { class: 'num fig', text: `${Math.ceil(l.secondsLeft / 60)} min` }),
    h('td', { class: 'actions' }, h('button', {
      class: 'btn small danger', type: 'button',
      onclick: () => confirmModal({
        title: 'Cancel this lot?', body: l.status === 'open' ? 'The leading bid is refunded.' : 'The contraband disappears and nobody is refunded.',
        confirmLabel: 'Cancel lot', danger: true, onConfirm: () => adminAct('auctionCancel', [l.id], 'Lot cancelled.'),
      }),
    }, 'Cancel'))));
  const bm = await adminRequest('blackmarketSettings');
  const on = bm.ok ? bm.data.enabled : true;
  return h('div', {},
    auctionTabs(),
    h('div', { class: 'heist-edit-start', style: 'margin-bottom:18px' },
      h('div', {},
        h('strong', { text: on ? 'The black market is open' : 'The black market is closed' }),
        h('div', { class: 'hint', style: 'margin:0', text: on
          ? 'Auctions run on their own, and gangs see the Black market app on their tablet.'
          : 'No new auctions, and the Black market app is hidden from gang tablets. Anything already running finishes as normal.' })),
      h('button', {
        class: on ? 'btn small danger' : 'btn small primary', type: 'button',
        onclick: () => (on
          ? confirmModal({ title: 'Close the black market?', body: 'No new auctions start, and gangs lose the Black market app until you open it again. Auctions already running finish normally.', confirmLabel: 'Close it', danger: true, onConfirm: () => adminAct('blackmarketOpen', [false], 'The black market is closed.') })
          : adminAct('blackmarketOpen', [true], 'The black market is open again.')),
      }, on ? 'Close it' : 'Open it')),
    h('div', { class: 'section-head' },
      h('h2', {}, 'Auctions ', h('span', { class: 'muted fig', text: v.lots.length })),
      h('button', { class: 'btn primary', type: 'button', onclick: () => adminAct('auctionOpen', [], 'Auction opened.') }, 'Hold an auction now')),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: `Next automatic auction in about ${v.nextIn} min. ${v.hasItems ? '' : 'No contraband items yet, so item lots never come up: add some in Black market settings.'}` }),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Lot' }), h('th', { text: 'Leading / won by' }), h('th', { class: 'num', text: 'Price' }), h('th', { class: 'num', text: 'Left' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'Nothing up for auction.' }));
}

/* Informants ------------------------------------------------------------ */

async function renderAdminInformants() {
  const res = await adminRequest('informants');
  if (!res.ok) return loadError(res);
  const rows = res.data.map((i) => h('tr', {},
    h('td', {}, h('strong', { class: 'fig', text: i.code })),
    h('td', {}, i.name, i.gang ? h('div', { class: 'hint', style: 'margin:0', text: i.gang }) : null),
    h('td', { class: 'num fig', text: i.tips }),
    h('td', { class: 'num fig', text: money(i.earned) }),
    h('td', { class: i.active ? '' : 'debit', text: i.active ? 'Active' : 'Cut off' }),
    h('td', { class: 'actions' }, h('button', {
      class: i.active ? 'btn small danger' : 'btn small', type: 'button',
      onclick: () => adminAct('informantActive', [i.citizenid, !i.active], i.active ? 'Informant cut off.' : 'Informant reinstated.'),
    }, i.active ? 'Cut off' : 'Reinstate'))));
  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Informants ', h('span', { class: 'muted fig', text: res.data.length }))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Staff only. Police see these people only by their code on the MDT, and gangs never see who they are. Keep it that way.' }),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Code' }), h('th', { text: 'Character' }), h('th', { class: 'num', text: 'Tips' }), h('th', { class: 'num', text: 'Paid' }), h('th', { text: 'Status' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'Nobody has called the handler yet.' }));
}

/* Street events (director) ---------------------------------------------- */

const EVENT_NAMES = {
  shortage: 'Supplier shortage', boom: 'Market boom', crash: 'Market crash', crackdown: 'Police crackdown',
  crew: 'Outside crew', drop: 'Lost shipment', undercover: 'Undercover operation', hotwork: 'Hot work',
};

/* Air drop loot tables: several named tables (the first is the default); each crate draws picks from one */
async function editAirdropLoot() {
  const res = await adminRequest('airdropLoot');
  if (!res.ok) return toast(res.error, true);
  const v = res.data;
  let cur = 0;
  const body = h('div', { style: 'display:grid;gap:10px' });
  const numIn = (obj, key, min, width = 90) => { const el = h('input', { type: 'number', min, value: obj[key], style: `width:${width}px` }); el.addEventListener('change', () => { obj[key] = Number(el.value); draw(); }); return el; };

  const draw = () => {
    const t = v.tables[cur];
    const total = t.loot.reduce((n, l) => n + (Number(l.chance) || 0), 0) || 1;
    const name = h('input', { type: 'text', maxlength: 32, value: t.name, style: 'width:220px' });
    name.addEventListener('input', () => { t.name = name.value; });
    name.addEventListener('change', draw);
    const tabs = h('div', { class: 'choices', role: 'radiogroup', style: 'flex-wrap:wrap' },
      ...v.tables.map((x, i) => h('button', { type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(i === cur), onclick: () => { cur = i; draw(); } }, `${x.name || 'Untitled'}${i === 0 ? ' (default)' : ''}`)),
      h('button', { class: 'btn small', type: 'button', onclick: () => { v.tables.push({ name: `Loot table ${v.tables.length + 1}`, rolls: 3, loot: [{ money: true, min: 5000, max: 15000, chance: 20 }] }); cur = v.tables.length - 1; draw(); } }, '+ New table'));
    const rows = h('div', { style: 'display:grid;gap:8px;max-height:38vh;overflow-y:auto;padding-right:4px' },
      ...t.loot.map((l, i) => h('div', { class: 'loot-entry' },
        l.money ? h('strong', { text: 'Money (£)' }) : itemPicker(l.item ? { item: l.item, label: l.label } : null, (it) => { l.item = it ? it.name : null; l.label = it ? it.label : null; }, { allowClear: false, openNow: !l.item, emptyText: 'No item chosen yet' }),
        h('div', { class: 'loot-fields' },
          h('label', { class: 'field' }, 'Min', numIn(l, 'min', 1, 90)),
          h('label', { class: 'field' }, 'Max', numIn(l, 'max', 1, 90)),
          h('label', { class: 'field' }, 'Weight', h('span', { class: 'row', style: 'flex-wrap:nowrap;align-items:center;gap:8px' }, numIn(l, 'chance', 1, 80), h('span', { class: 'muted', text: `about ${Math.round((l.chance || 0) / total * 100)}% of picks` }))),
          h('button', { class: 'btn small danger', type: 'button', style: 'margin-left:auto;align-self:end', onclick: () => { t.loot.splice(i, 1); draw(); } }, 'Remove')))));
    body.replaceChildren(
      tabs,
      h('div', { class: 'row', style: 'align-items:end' },
        h('label', { class: 'field' }, 'Name', name),
        h('label', { class: 'field' }, 'Picks per crate', numIn(t, 'rolls', 1, 80)),
        h('span', { style: 'margin-left:auto' }),
        cur > 0 ? h('button', { class: 'btn small', type: 'button', onclick: () => { v.tables.unshift(v.tables.splice(cur, 1)[0]); cur = 0; draw(); } }, 'Make default') : h('span', {}),
        v.tables.length > 1 ? h('button', { class: 'btn small danger', type: 'button', onclick: () => { v.tables.splice(cur, 1); cur = 0; draw(); } }, 'Delete table') : h('span', {})),
      rows,
      h('div', { class: 'row' },
        h('button', { class: 'btn small', type: 'button', onclick: () => { t.loot.push({ item: null, min: 1, max: 1, chance: 10 }); draw(); } }, 'Add an item'),
        h('button', { class: 'btn small', type: 'button', onclick: () => { t.loot.push({ money: true, min: 5000, max: 15000, chance: 20 }); draw(); } }, 'Add money')));
  };
  draw();
  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: 'Air drop loot tables' }),
    h('p', { text: 'Each crate makes a number of picks from one table; each pick takes one entry (the higher its weight, the likelier). Choose a table when calling a drop in or in a schedule; the default is used for anything else. Money goes to the opener\'s gang treasury (dirty), or as cash if they\'re not in a gang.' }),
    body,
    h('div', { class: 'buttons' },
      !v.fromConfig ? h('button', { class: 'btn', type: 'button', style: 'margin-right:auto', onclick: async () => { if (await adminAct('airdropLootReset', [], 'Back to the config loot.')) hideModal(); } }, 'Reset to config') : null,
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', { class: 'btn primary', type: 'button', onclick: async () => {
        for (const [i, t] of v.tables.entries()) {
          if (!t.loot.length) { cur = i; draw(); return toast(`"${t.name}" needs at least one entry.`, true); }
          if (t.loot.some((l) => !l.money && !l.item)) { cur = i; draw(); return toast('Pick an item for every row, or remove it.', true); }
        }
        const data = { tables: v.tables.map((t) => ({ id: t.id, name: t.name, rolls: Number(t.rolls), loot: t.loot.map((l) => (l.money ? { money: true, min: l.min, max: l.max, chance: l.chance } : { item: l.item, min: l.min, max: l.max, chance: l.chance })) })) };
        if (await adminAct('airdropLootSave', [data], 'Loot tables saved. New crates use them straight away.')) hideModal();
      } }, 'Save')));
}

/* "What's in the crate" choices: each loot table, or exact contents */
async function lootChoices() {
  const r = await adminRequest('airdropLoot');
  const tables = r.ok ? r.data.tables : [];
  return [...tables.map((t, i) => ({ value: `t${t.id}`, label: `Random from "${t.name}"${i === 0 ? ' (default)' : ''}` })), { value: 'exact', label: 'Exactly what I choose' }];
}

/* Scheduled air drops */
function inMinutes(sec) {
  if (sec == null) return 'not scheduled';
  const m = Math.round(sec / 60);
  if (m < 1) return 'any moment';
  if (m < 60) return `in ${m} min`;
  const hrs = Math.floor(m / 60), mins = m % 60;
  return hrs < 48 ? `in ${hrs} h${mins ? ` ${mins} min` : ''}` : `in ${Math.round(hrs / 24)} days`;
}

function scheduleSummary(s) {
  const when = s.kind === 'every' ? `Every ${s.minutes % 60 === 0 ? `${s.minutes / 60} h` : `${s.minutes} min`}`
    : (s.kind === 'daily' ? `Daily at ${s.times.join(', ')}` : `Once, ${new Date(s.at * 1000).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' })}`);
  const who = { all: 'all gangs', everyone: 'everyone', tier: 'a tier and up', gang: s.gangLabel || 'one gang' }[(s.who || {}).kind] || 'all gangs';
  return `${when} · ${s.spots.length} ${s.spots.length === 1 ? 'spot' : 'spots'} · for ${who}${s.minPlayers ? ` · needs ${s.minPlayers} players` : ''}${s.contents ? ' · set contents' : ''}`;
}

async function renderAirdropSchedules() {
  const res = await adminRequest('airdropSchedules');
  if (!res.ok) return h('div', {});
  const v = res.data;
  const rows = v.schedules.map((s) => {
    const on = h('input', { type: 'checkbox', checked: s.enabled });
    on.addEventListener('change', () => adminAct('airdropScheduleToggle', [s.id, on.checked], on.checked ? 'Schedule on.' : 'Schedule off.'));
    return h('tr', {},
      h('td', {}, h('strong', { text: s.name }), h('div', { class: 'hint', style: 'margin:0', text: scheduleSummary(s) })),
      h('td', { class: 'muted', text: s.enabled ? inMinutes(s.nextIn) : 'off' }),
      h('td', {}, h('label', { class: 'toggle' }, on, ' On')),
      h('td', { class: 'actions' },
        h('button', { class: 'btn small', type: 'button', onclick: () => editAirdropSchedule(JSON.parse(JSON.stringify(s)), v) }, 'Edit'),
        h('button', { class: 'btn small danger', type: 'button', onclick: () => confirmModal({ title: `Delete "${s.name}"?`, body: 'No more drops from this schedule. Drops already on their way still arrive.', confirmLabel: 'Delete', danger: true, onConfirm: () => adminAct('airdropScheduleDelete', [s.id], 'Deleted.') }) }, 'Delete')));
  });
  return h('div', { style: 'margin-top:28px' },
    h('div', { class: 'section-head' }, h('h3', { style: 'margin:0', text: 'Scheduled air drops' }),
      h('button', { class: 'btn small primary', type: 'button', onclick: () => editAirdropSchedule(null, v) }, 'New schedule')),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: `Drops that call themselves in. Server time is ${v.serverTime}; daily times use the server's clock. A drop that comes due while the server's off is skipped, not fired late.` }),
    rows.length ? h('table', {}, h('tbody', {}, rows)) : h('p', { class: 'empty', text: 'No schedules yet.' }));
}

async function editAirdropSchedule(existing, meta) {
  const gr = await adminRequest('listGangs');
  const gangs = gr.ok ? gr.data : [];
  const s = existing || { name: '', kind: 'every', minutes: 180, times: ['20:00'], spots: [], who: { kind: 'all' }, delay: 2, minPlayers: 0, enabled: true };
  s.times = s.times || ['20:00'];
  s.spots = s.spots || [];
  const name = h('input', { type: 'text', value: s.name, maxlength: 40, placeholder: 'e.g. Evening drops', style: 'width:100%' });

  // When
  const kind = select([{ value: 'every', label: 'Every few hours' }, { value: 'daily', label: 'Daily at set times' }, { value: 'once', label: 'Once, at a date and time' }], s.kind);
  const hours = h('input', { type: 'number', min: 0.25, max: 168, step: 0.25, value: (s.minutes || 180) / 60, style: 'width:90px' });
  const timesBox = h('div', { class: 'row', style: 'align-items:center' });
  const drawTimes = () => timesBox.replaceChildren(...s.times.map((t, i) => {
    const el = h('input', { type: 'time', value: t, style: 'width:120px' });
    el.addEventListener('change', () => { s.times[i] = el.value; });
    return h('span', { class: 'row', style: 'flex-wrap:nowrap;gap:4px' }, el, s.times.length > 1 ? h('button', { class: 'btn small', type: 'button', 'aria-label': 'Remove time', onclick: () => { s.times.splice(i, 1); drawTimes(); } }, '×') : null);
  }), h('button', { class: 'btn small', type: 'button', onclick: () => { s.times.push('22:00'); drawTimes(); } }, 'Add a time'));
  drawTimes();
  const pad = (n) => String(n).padStart(2, '0');
  const at = s.at ? new Date(s.at * 1000) : new Date(Date.now() + 3600000);
  const once = h('input', { type: 'datetime-local', value: `${at.getFullYear()}-${pad(at.getMonth() + 1)}-${pad(at.getDate())}T${pad(at.getHours())}:${pad(at.getMinutes())}` });
  const whenBox = h('div', {});
  const drawWhen = () => whenBox.replaceChildren(
    kind.value === 'every' ? h('label', { class: 'field' }, 'Every (hours)', hours)
      : kind.value === 'daily' ? h('div', { class: 'field' }, `Times (server time, now ${meta.serverTime})`, timesBox)
        : h('label', { class: 'field' }, 'Date and time', once));
  kind.addEventListener('change', drawWhen);
  drawWhen();

  // Where: one or more spots, one picked at random each time
  const spotsBox = h('div', { style: 'display:grid;gap:6px' });
  const drawSpots = () => spotsBox.replaceChildren(
    ...s.spots.map((p, i) => h('div', { class: 'row', style: 'align-items:center' },
      h('span', { style: 'flex:1', text: `Spot ${i + 1}: ${Math.round(p.x)}, ${Math.round(p.y)}` }),
      h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoPoint', [p]) }, 'Go to'),
      h('button', { class: 'btn small danger', type: 'button', onclick: () => { s.spots.splice(i, 1); drawSpots(); } }, 'Remove'))),
    h('div', { class: 'row' },
      h('button', { class: 'btn small', type: 'button', onclick: async () => {
        const r = await adminRequest('heistHere');
        if (!r.ok) return toast(r.error, true);
        s.spots.push({ x: r.data.x, y: r.data.y, z: r.data.z }); drawSpots();
      } }, 'Add where I\'m standing'),
      h('button', { class: 'btn small', type: 'button', onclick: async () => {
        const spot = await mapPointPicker({ title: 'Add a drop spot', start: s.spots[s.spots.length - 1] });
        if (spot) { s.spots.push({ x: spot.x, y: spot.y, z: 0 }); drawSpots(); }
      } }, 'Pick on the map'),
      h('button', { class: 'btn small', type: 'button', onclick: async () => {
        if (!IN_GAME) { s.spots.push({ x: 1700 + s.spots.length * 50, y: 3300, z: 40 }); return drawSpots(); }
        const r = await postNui('airdropWaypoint');
        const w = r && r.json ? await r.json() : null;
        if (w && w.ok) { s.spots.push({ x: w.x, y: w.y, z: 0 }); drawSpots(); } else toast('Set a waypoint on your map first.', true);
      } }, 'Add my waypoint')),
    s.spots.length > 1 ? h('p', { class: 'hint', style: 'margin:0', text: 'Each drop picks one of these at random.' }) : null);
  drawSpots();

  // Who, and the rest
  const tiers = (state.static.tiers || []).map((t, i) => ({ value: i + 1, label: `${t.label} and up` }));
  const whoKind = select([{ value: 'all', label: 'All gangs' }, { value: 'tier', label: 'Gangs of a tier and up' }, { value: 'gang', label: 'One gang' }, { value: 'everyone', label: 'Everyone (in a gang or not)' }], (s.who || {}).kind || 'all');
  const whoTier = select(tiers.length ? tiers : [{ value: 1, label: 'Any tier' }], (s.who || {}).tier || 3);
  const whoGang = select(gangs.map((g) => ({ value: g.id, label: g.label })), (s.who || {}).gangId || (gangs[0] || {}).id || '');
  const showWho = () => { whoTier.hidden = whoKind.value !== 'tier'; whoGang.hidden = whoKind.value !== 'gang'; };
  whoKind.addEventListener('change', showWho);
  showWho();
  const delay = h('input', { type: 'number', min: 0, max: 30, value: s.delay ?? 2, style: 'width:80px' });
  const minPlayers = h('input', { type: 'number', min: 0, max: 200, value: s.minPlayers ?? 0, style: 'width:80px' });
  const loot = select(await lootChoices(), s.contents ? 'exact' : (s.lootTable ? `t${s.lootTable}` : ''));
  s.contentsDraft = (s.contents || []).map((c) => ({ ...c }));
  const contentsBox = h('div', { style: 'display:grid;gap:8px' });
  const drawContents = () => {
    contentsBox.hidden = loot.value !== 'exact';
    contentsBox.replaceChildren(...s.contentsDraft.map((c, i) => h('div', { class: 'row', style: 'align-items:center;flex-wrap:nowrap' },
      c.money ? h('span', { style: 'flex:1', text: 'Money' }) : h('div', { style: 'flex:1;min-width:0' }, itemPicker(c.item ? { item: c.item, label: c.label } : null, (it) => { c.item = it ? it.name : null; c.label = it ? it.label : null; }, { allowClear: false, openNow: !c.item, emptyText: 'No item chosen yet' })),
      (() => { const n = h('input', { type: 'number', min: 1, value: c.count || 1, style: 'width:100px' }); n.addEventListener('change', () => { c.count = Number(n.value); }); return n; })(),
      h('button', { class: 'btn small danger', type: 'button', onclick: () => { s.contentsDraft.splice(i, 1); drawContents(); } }, 'Remove'))),
    h('div', { class: 'row' },
      h('button', { class: 'btn small', type: 'button', onclick: () => { s.contentsDraft.push({ item: null, count: 1 }); drawContents(); } }, 'Add an item'),
      h('button', { class: 'btn small', type: 'button', onclick: () => { s.contentsDraft.push({ money: true, count: 10000 }); drawContents(); } }, 'Add money')));
  };
  loot.addEventListener('change', drawContents);
  drawContents();

  const save = async () => {
    if (loot.value === 'exact' && !s.contentsDraft.some((c) => c.money || c.item)) return toast('Add something to the crate, or use the usual loot.', true);
    const data = {
      id: s.id, name: name.value, enabled: s.enabled !== false, kind: kind.value,
      minutes: Math.round(Number(hours.value) * 60), times: s.times,
      at: Math.floor(new Date(once.value).getTime() / 1000),
      spots: s.spots, delay: Number(delay.value), minPlayers: Number(minPlayers.value),
      who: whoKind.value === 'tier' ? { kind: 'tier', tier: Number(whoTier.value) } : whoKind.value === 'gang' ? { kind: 'gang', gangId: Number(whoGang.value) } : { kind: whoKind.value },
      contents: loot.value === 'exact' ? s.contentsDraft.filter((c) => c.money || c.item).map((c) => (c.money ? { money: true, count: c.count } : { item: c.item, count: c.count })) : null,
      lootTable: loot.value.startsWith('t') ? Number(loot.value.slice(1)) : null,
    };
    if (await adminAct('airdropScheduleSave', [data], existing ? 'Schedule saved.' : 'Schedule created.')) hideModal();
  };

  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: existing ? `Edit "${s.name}"` : 'New air drop schedule' }),
    h('div', { class: 'sched-form' },
      h('label', { class: 'field' }, 'Name', name),
      h('label', { class: 'field' }, 'When', kind), whenBox,
      h('div', { class: 'field' }, 'Where', spotsBox),
      h('div', { class: 'field' }, 'Who can get it', h('div', { class: 'row', style: 'flex-wrap:nowrap' }, whoKind, whoTier, whoGang)),
      h('div', { class: 'row', style: 'align-items:end' },
        h('label', { class: 'field' }, 'Plane arrives after (min)', delay),
        h('label', { class: 'field' }, 'Only if this many players are on', minPlayers)),
      h('label', { class: 'field' }, 'What\'s in the crate', loot), contentsBox),
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', { class: 'btn primary', type: 'button', onclick: save }, existing ? 'Save' : 'Create schedule')));
}

async function renderAdminAirdrops() {
  const res = await adminRequest('airdrops');
  if (!res.ok) return h('div', {});
  const stage = { called: 'Plane on its way', flying: 'Falling', landed: 'On the ground' };
  const callIn = async () => {
    const gr = await adminRequest('listGangs');
    const gangs = gr.ok ? gr.data : [];
    // Who can get it: all gangs, gangs of a tier and up, or one gang
    const tiers = (state.static.tiers || []).map((t, i) => ({ value: i + 1, label: `${t.label} and up` }));
    const whoKind = select([{ value: 'all', label: 'All gangs' }, { value: 'tier', label: 'Gangs of a tier and up' }, { value: 'gang', label: 'One gang' }, { value: 'everyone', label: 'Everyone (in a gang or not)' }], 'all');
    const whoTier = select(tiers.length ? tiers : [{ value: 1, label: 'Any tier' }], 3 <= tiers.length ? 3 : 1);
    const whoGang = select(gangs.map((g) => ({ value: g.id, label: g.label })), gangs[0] ? gangs[0].id : '');
    const whoHint = h('p', { class: 'hint', style: 'margin:4px 0 0' });
    const showWho = () => {
      whoTier.hidden = whoKind.value !== 'tier';
      whoGang.hidden = whoKind.value !== 'gang';
      whoHint.textContent = whoKind.value === 'everyone' ? 'Every player on the server is told, sees it on the map and can go for it, gang or not.'
        : whoKind.value === 'all' ? 'Every gang member sees it and can go for it. Players who aren\'t in a gang aren\'t told.'
        : 'Only they see it on the map and are told it\'s coming. Nobody else can open it.';
    };
    whoKind.addEventListener('change', showWho);
    showWho();
    const minutes = h('input', { type: 'number', min: 0, max: 30, value: 1, style: 'width:80px' });
    // What's in the crate: the usual loot table, or an exact list
    const contents = [];
    const contentsBox = h('div', { style: 'display:grid;gap:8px' });
    const drawContents = () => contentsBox.replaceChildren(...contents.map((c, i) => h('div', { class: 'row', style: 'align-items:center;flex-wrap:nowrap' },
      c.money
        ? h('span', { style: 'flex:1', text: 'Money (to the opener\'s gang treasury, or cash)' })
        : h('div', { style: 'flex:1;min-width:0' }, itemPicker(c.item ? { item: c.item, label: c.label } : null, (it) => { c.item = it ? it.name : null; c.label = it ? it.label : null; }, { allowClear: false, openNow: !c.item, emptyText: 'No item chosen yet' })),
      (() => { const n = h('input', { type: 'number', min: 1, value: c.count, style: 'width:100px' }); n.addEventListener('change', () => { c.count = Number(n.value); }); return n; })(),
      h('button', { class: 'btn small danger', type: 'button', onclick: () => { contents.splice(i, 1); drawContents(); } }, 'Remove'))),
      h('div', { class: 'row' },
        h('button', { class: 'btn small', type: 'button', onclick: () => { contents.push({ item: null, count: 1 }); drawContents(); } }, 'Add an item'),
        h('button', { class: 'btn small', type: 'button', onclick: () => { contents.push({ money: true, count: 10000 }); drawContents(); } }, 'Add money')));
    const kind = select(await lootChoices(), '');
    kind.addEventListener('change', () => { contentsBox.hidden = kind.value !== 'exact'; if (kind.value === 'exact' && !contents.length) { contents.push({ item: null, count: 1 }); } drawContents(); });
    contentsBox.hidden = true;
    const send = async (x, y) => {
      let exact = null;
      if (kind.value === 'exact') {
        exact = contents.filter((c) => c.money || c.item).map((c) => (c.money ? { money: true, count: c.count } : { item: c.item, count: c.count }));
        if (!exact.length) return toast('Add at least one item or some money, or use the usual loot.', true);
      }
      if (whoKind.value === 'gang' && !whoGang.value) return toast('There are no gangs to choose from yet.', true);
      const who = whoKind.value === 'tier' ? { kind: 'tier', tier: Number(whoTier.value) }
        : (whoKind.value === 'gang' ? { kind: 'gang', gangId: Number(whoGang.value) } : { kind: whoKind.value === 'everyone' ? 'everyone' : 'all' });
      const lootTable = kind.value.startsWith('t') ? Number(kind.value.slice(1)) : null;
      if (await adminAct('airdropAdminCall', [{ x: x ?? null, y: y ?? null, minutes: Number(minutes.value), contents: exact, who, lootTable }], 'Air drop called in.')) { hideModal(); renderAdminTab(); }
    };
    $('sheet').classList.add('wide');
    showModal(
      h('h2', { text: 'Call in an air drop' }),
      h('p', { text: 'A smuggler\'s plane drops a crate wherever you choose. No cost, no cooldown. Breaking it open takes 2 minutes and stops if the opener gets hurt or moves away, so others can fight for it.' }),
      h('div', { class: 'field' }, 'Who can get it', h('div', { class: 'row', style: 'flex-wrap:nowrap' }, whoKind, whoTier, whoGang), whoHint),
      h('label', { class: 'field', style: 'margin-top:12px' }, 'Plane arrives in (minutes)', minutes),
      h('label', { class: 'field', style: 'margin-top:12px' }, 'What\'s in the crate', kind),
      contentsBox,
      h('div', { class: 'buttons' },
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn', type: 'button', onclick: async () => {
          const spot = await mapPointPicker({ title: 'Where should the crate land?' });
          if (spot) send(spot.x, spot.y);
        } }, 'Pick on the map'),
        h('button', { class: 'btn', type: 'button', onclick: async () => {
          if (!IN_GAME) return send(1700, 3300);
          const r = await postNui('airdropWaypoint');
          const w = r && r.json ? await r.json() : null;
          if (w && w.ok) send(w.x, w.y); else toast('Set a waypoint on your map first.', true);
        } }, 'At my waypoint'),
        h('button', { class: 'btn primary', type: 'button', onclick: () => send() }, 'Where I\'m standing')));
  };

  return h('div', { style: 'margin-top:28px' },
    h('div', { class: 'section-head' }, h('h3', { style: 'margin:0', text: 'Air drops' }),
      h('div', { class: 'row' },
        h('button', { class: 'btn small', type: 'button', onclick: editAirdropLoot }, 'Loot'),
        h('button', { class: 'btn primary small', type: 'button', onclick: callIn }, 'Call in an air drop'))),
    res.data.length ? h('table', {}, h('tbody', {}, res.data.map((d) => h('tr', {},
      h('td', {}, h('strong', { text: d.gang }), h('div', { class: 'hint', style: 'margin:0', text: `${Math.round(d.x)}, ${Math.round(d.y)}` })),
      h('td', {}, stage[d.state] || d.state, d.state === 'called' ? h('span', { class: 'muted' }, ' · ', countdown(d.arrivesIn)) : null),
      h('td', { class: 'actions' },
        waypointButton(d.x, d.y),
        h('button', { class: 'btn small danger', type: 'button', onclick: () => adminAct('airdropCancel', [d.id], 'Air drop cancelled.') }, 'Cancel'))))))
      : h('p', { class: 'empty', text: 'No air drops right now.' }));
}

async function renderAdminDirector() {
  const res = await adminRequest('director');
  if (!res.ok) return loadError(res);
  const v = res.data;

  const detail = (e) => [
    e.zone && `Area: ${e.zone}`, e.type && `Type: ${e.type}`, e.gang && `Target: ${e.gang}`,
    e.strength !== null && e.strength !== undefined && `Crew strength left: ${e.strength}`, e.value && `Worth ${money(e.value)}`,
  ].filter(Boolean).join('. ');

  const rows = v.events.map((e) => h('tr', {},
    h('td', {}, h('strong', { text: EVENT_NAMES[e.kind] || e.kind }), h('div', { class: 'hint', style: 'margin:0', text: e.public || '' })),
    h('td', { class: 'hint', text: detail(e) }),
    h('td', { class: 'num fig', text: `${e.minutesLeft} min` }),
    h('td', { class: 'actions' }, h('button', { class: 'btn small danger', type: 'button', onclick: () => adminAct('directorEnd', [e.id], 'Event ended.') }, 'End'))));

  const kind = select(v.kinds.map((k) => ({ value: k, label: EVENT_NAMES[k] || k })));
  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', {}, 'Street events ', h('span', { class: 'muted fig', text: v.events.length })),
      h('div', { class: 'row' }, kind, h('button', { class: 'btn primary', type: 'button', onclick: () => adminAct('directorStart', [kind.value], 'Event started.') }, 'Start now'))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: v.enabled
      ? `The director starts events on its own every so often. Next one is considered in about ${v.nextIn} min. Players only see the public line; the details here are staff only.`
      : 'The director is switched off in config (Config.Modules.director). You can still start events by hand.' }),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Event' }), h('th', { text: 'Details' }), h('th', { class: 'num', text: 'Left' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'Nothing happening right now.' }));
}

/* Diplomacy ------------------------------------------------------------- */

async function renderAdminDiplomacy() {
  const res = await adminRequest('agreements');
  if (!res.ok) return loadError(res);
  const rows = res.data.map((d) => h('tr', {},
    h('td', {}, h('strong', { text: d.zone ? `${d.label} (${d.zone})` : d.label }),
      h('div', { class: 'hint', style: 'margin:0', text: d.status === 'proposed' ? 'Proposed, not answered' : (d.secondsLeft ? `${duration(d.secondsLeft)} left` : 'Until broken') })),
    h('td', {}, swatchLabel(d.aColour, d.a)),
    h('td', {}, swatchLabel(d.bColour, d.b)),
    h('td', { class: 'num fig', text: d.payment ? money(d.payment) : '' }),
    h('td', { class: 'actions' }, h('button', {
      class: 'btn small danger', type: 'button',
      onclick: () => confirmModal({
        title: 'Cancel this deal?', body: 'Both gangs are told staff cancelled it. Nobody loses reputation and any payment isn\'t refunded.',
        confirmLabel: 'Cancel deal', danger: true, onConfirm: () => adminAct('cancelAgreement', [d.id], 'Deal cancelled.'),
      }),
    }, 'Cancel'))));
  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Diplomacy ', h('span', { class: 'muted fig', text: res.data.length }))),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Deal' }), h('th', { text: 'Proposed by' }), h('th', { text: 'With' }), h('th', { class: 'num', text: 'Payment' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No deals proposed or running.' }));
}

/* Placing NPCs in the game: the panel steps aside, staff place the NPC, the panel comes back -------- */

const placeWaits = {};
function placeInGame({ model, multi = false, max = 1 }) {
  if (!IN_GAME) {
    // Browser preview: pretend some spots were placed
    const n = multi ? Math.min(max, 3) : 1;
    return Promise.resolve(Array.from({ length: n }, (_, i) => ({ x: 152.4 + i * 2.5, y: -1041.2 + i, z: 29.4, w: 90 + i * 30 })));
  }
  const token = `${Date.now()}${Math.random()}`;
  return new Promise((resolve) => {
    placeWaits[token] = resolve;
    postNui('placeNpc', { token, model, multi, max });
  });
}
window.addEventListener('message', (event) => {
  const msg = event.data || {};
  if (msg.action === 'adminHide') {
    hideModal();
    $('device').hidden = true;
  } else if (msg.action === 'adminPlaced') {
    $('device').hidden = false;
    const done = placeWaits[msg.token];
    delete placeWaits[msg.token];
    if (done) done(Array.isArray(msg.points) && msg.points.length ? msg.points : null);
  }
});

/* Pick a spot on the San Andreas map: opens over whatever's on screen, resolves to { x, y } or null */
function mapPointPicker({ title = 'Pick a spot on the map', hint = 'Scroll to zoom, drag to move, click to drop a pin.', start } = {}) {
  return new Promise((resolve) => {
    const tm = state.static.tabletMap;
    const map = svg('svg', { class: 'map has-picture mappick-map', role: 'img', 'aria-label': title });
    if (tm && tm.image) {
      const left = (0 - tm.offsetX) / tm.scaleX + (tm.nudgeX || 0);
      const top = (0 - tm.offsetY) / tm.scaleY + (tm.nudgeY || 0);
      map.append(svg('image', { href: tm.image, x: left, y: -top, width: tm.size / tm.scaleX, height: tm.size / Math.abs(tm.scaleY), preserveAspectRatio: 'none' }));
    }
    const pin = svg('g', { class: 'mappick-pin' });
    map.append(pin);
    let view = start ? { cx: start.x, cy: start.y, half: 900 } : { cx: 0, cy: 1500, half: 5200 };
    let picked = null;
    const aspect = () => { const r = map.getBoundingClientRect(); return r.height ? r.width / r.height : 1; };
    const drawPin = () => {
      if (!picked) { pin.replaceChildren(); return; }
      const r = view.half * 0.018;
      pin.replaceChildren(
        svg('circle', { cx: picked.x, cy: -picked.y, r: r * 2.2, fill: 'rgba(229,72,77,0.25)' }),
        svg('circle', { cx: picked.x, cy: -picked.y, r, fill: '#E5484D', stroke: '#ffffff', 'stroke-width': r * 0.35 }));
    };
    const apply = () => {
      const hx = view.half * aspect();
      map.setAttribute('viewBox', `${view.cx - hx} ${-view.cy - view.half} ${hx * 2} ${view.half * 2}`);
      drawPin();
    };
    const toWorld = (e) => {
      const r = map.getBoundingClientRect();
      const fx = (e.clientX - r.left) / (r.width || 1), fy = (e.clientY - r.top) / (r.height || 1);
      const hx = view.half * aspect();
      return [view.cx - hx + fx * 2 * hx, view.cy + view.half - fy * 2 * view.half];
    };
    const where = h('span', { class: 'hint', style: 'margin:0', text: 'No spot picked yet.' });
    const useBtn = h('button', { class: 'btn primary', type: 'button', disabled: true }, 'Use this spot');
    let drag = null, dragged = false;
    map.addEventListener('click', (e) => {
      if (dragged) return;
      const [x, y] = toWorld(e);
      picked = { x: Math.round(x * 10) / 10, y: Math.round(y * 10) / 10 };
      where.textContent = `${Math.round(picked.x)}, ${Math.round(picked.y)}${state.static.hexDistricts ? ` (${hexLabel(...hexFromCoords(picked.x, picked.y)).replace(/ \(.*/, '')})` : ''}`;
      useBtn.disabled = false;
      drawPin();
    });
    map.addEventListener('wheel', (e) => {
      e.preventDefault();
      const r = map.getBoundingClientRect();
      const fx = (e.clientX - r.left) / (r.width || 1), fy = (e.clientY - r.top) / (r.height || 1);
      const [wx, wy] = toWorld(e);
      const half = Math.min(6000, Math.max(150, view.half * (e.deltaY > 0 ? 1.25 : 0.8)));
      view = { cx: wx - (fx * 2 - 1) * half * aspect(), cy: wy + (fy * 2 - 1) * half, half };
      apply();
    }, { passive: false });
    map.addEventListener('mousedown', (e) => { drag = { x: e.clientX, y: e.clientY, view: { ...view } }; dragged = false; });
    const prevDrag = mapDragHandlers;
    mapDragHandlers = {
      move: (e) => {
        if (!drag || !map.isConnected) return;
        const r = map.getBoundingClientRect();
        if (Math.abs(e.clientX - drag.x) + Math.abs(e.clientY - drag.y) > 4) dragged = true;
        if (!dragged) return;
        view = { cx: drag.view.cx - (e.clientX - drag.x) / (r.width || 1) * 2 * drag.view.half * aspect(), cy: drag.view.cy + (e.clientY - drag.y) / (r.height || 1) * 2 * drag.view.half, half: drag.view.half };
        apply();
      },
      up: () => { drag = null; setTimeout(() => { dragged = false; }, 0); },
    };
    const overlay = h('div', { class: 'mappick-overlay' });
    const finish = (result) => { mapDragHandlers = prevDrag; overlay.remove(); resolve(result); };
    useBtn.addEventListener('click', () => finish(picked));
    overlay.append(h('div', { class: 'mappick-panel', role: 'dialog', 'aria-label': title },
      h('h2', { style: 'margin:0', text: title }),
      h('p', { class: 'hint', style: 'margin:0', text: hint }),
      map,
      h('div', { class: 'row', style: 'align-items:center' }, where,
        h('span', { style: 'margin-left:auto' }),
        h('button', { class: 'btn', type: 'button', onclick: () => finish(null) }, 'Cancel'), useBtn)));
    ($('device') || document.body).append(overlay);
    requestAnimationFrame(apply);
  });
}

/* Heist builder: the heist's doors, picked in game */
function pickDoorsInGame() {
  if (!IN_GAME) return Promise.resolve([{ model: 1234567, x: 255.2, y: 223.9, z: 102.4 }, { model: 1234567, x: 252.1, y: 220.6, z: 106.9 }]);
  const token = `${Date.now()}${Math.random()}`;
  return new Promise((resolve) => {
    placeWaits[token] = (pts) => resolve(pts && pts.length ? pts : null);
    postNui('pickDoors', { token });
  });
}

function doorsSection(d, { goTo, rerender }) {
  d.doors = d.doors || [];
  const rows = d.doors.map((door, i) => {
    const name = h('input', { type: 'text', maxlength: 32, value: door.label || `Door ${i + 1}`, style: 'width:200px' });
    name.addEventListener('input', () => { door.label = name.value; });
    name.addEventListener('change', rerender); // the steps' "Opens these doors" use the new name
    const used = (d.steps || []).filter((st) => (st.opens || []).includes(i + 1)).map((st) => st.label || 'a step');
    return h('div', { class: 'row', style: 'align-items:center' },
      h('span', { class: 'muted fig', style: 'width:22px', text: i + 1 }), name,
      h('span', { class: used.length ? 'hint' : 'hint debit', style: 'margin:0;flex:1', text: used.length ? `Opened by: ${used.join(', ')}` : 'No step opens this yet, so it stays locked' }),
      h('button', { class: 'btn small', type: 'button', onclick: () => goTo(door) }, 'Go to'),
      h('button', { class: 'btn small danger', type: 'button', onclick: () => {
        d.doors.splice(i, 1);
        // Keep the steps pointing at the right doors
        (d.steps || []).forEach((st) => { if (st.opens) st.opens = st.opens.filter((n) => n !== i + 1).map((n) => (n > i + 1 ? n - 1 : n)); });
        rerender();
      } }, 'Remove'));
  });
  return h('div', { class: 'heist-start-box', style: 'margin-top:4px' },
    h('div', { class: 'row', style: 'align-items:center' },
      h('div', { style: 'flex:1' }, h('strong', { text: 'Doors' }),
        h('div', { class: 'hint', style: 'margin:0', text: 'Locked for everyone while the heist is on. Each step can open some of them when it\'s done (thermite the gate, hack the panel for the office, the inside man lets you in…). They lock again a minute after the job ends.' })),
      h('button', { class: 'btn small primary', type: 'button', onclick: async () => {
        const got = await pickDoorsInGame();
        if (got) { got.forEach((x) => d.doors.push({ ...x, label: `Door ${d.doors.length + 1}` })); toast(`${got.length} ${got.length === 1 ? 'door' : 'doors'} added. Name them, then choose which step opens each.`); rerender(); }
      } }, 'Add doors in game')),
    rows.length ? h('div', { style: 'display:grid;gap:6px;margin-top:8px' }, rows) : null);
}

/* Heist builder: pick a spot on the map and go there (the panel keeps its place and comes back with where you landed) */
async function goToPicked(start) {
  const spot = await mapPointPicker({ title: 'Pick a spot and go there', hint: 'You\'re taken to this spot and land on the ground; the panel comes back with it filled in. Then fine-tune it with Place in game or Where I stand.', start });
  if (!spot) return null;
  if (!IN_GAME) return { x: spot.x, y: spot.y, z: 30, w: 0 };
  const token = `${Date.now()}${Math.random()}`;
  return new Promise((resolve) => {
    placeWaits[token] = (pts) => resolve(pts ? pts[0] : null);
    postNui('goPicked', { token, x: spot.x, y: spot.y });
  });
}

/* Heist builder: how the job starts (tablet, a contact at the start point, or either) */
function startSection(d, meta, { here, goTo, point, rerender }) {
  d.startMode = d.startMode || 'tablet';
  const usesNpc = d.startMode !== 'tablet';
  if (usesNpc) d.startNpc = d.startNpc || { ped: (meta.npc || {}).ped || 'a_m_m_business_01', name: '', say: '' };
  if (d.startMode === 'both') d.startMode = 'npc';
  const mode = select([
    { value: 'tablet', label: 'Press E at the start point' },
    { value: 'npc', label: 'Talk to a contact at the start point' },
  ], d.startMode);
  mode.addEventListener('change', () => { d.startMode = mode.value; rerender(); });
  const name = h('input', { type: 'text', maxlength: 32, placeholder: 'e.g. Lester', value: (d.startNpc || {}).name || '', style: 'width:180px' });
  name.addEventListener('input', () => { d.startNpc.name = name.value; });
  const say = h('textarea', { rows: 2, maxlength: 200, placeholder: 'What they say when the job starts, e.g. "Right, you\'re on. The vault opens at midnight."', style: 'width:100%' });
  say.value = (d.startNpc || {}).say || '';
  say.addEventListener('input', () => { d.startNpc.say = say.value; });
  return h('div', { class: 'heist-start-box' },
    h('div', { class: 'heist-edit-start' },
      h('div', {}, h('strong', { text: 'Start point' }), h('div', { class: 'hint', style: 'margin:0', text: usesNpc
        ? 'Where the contact stands. The crew walks up and presses E to start the job; crew within 40 m count.'
        : 'Where the crew gathers; whoever starts it presses E at the marker there. Crew within 40 m count.' })),
      h('span', { class: 'heist-pos' },
        h('span', { class: d.start ? 'fig' : 'debit', text: point(d.start) }),
        usesNpc ? h('button', { class: 'btn small primary', type: 'button', onclick: async () => {
          const pts = await placeInGame({ model: d.startNpc.ped });
          if (pts) { d.start = pts[0]; toast('Placed.'); rerender(); }
        } }, 'Place in game') : null,
        h('button', { class: 'btn small', type: 'button', onclick: async () => { const p = await goToPicked(d.start); if (p) { d.start = p; toast('You\'re there. Fine-tune it if you need to.'); rerender(); } } }, 'Pick on map'),
        h('button', { class: 'btn small', type: 'button', onclick: () => here((p) => { d.start = p; }) }, usesNpc ? 'Where I stand' : 'Set here'),
        h('button', { class: 'btn small', type: 'button', onclick: () => goTo(d.start) }, 'Go to'))),
    h('div', { class: 'heist-settings', style: 'margin:10px 0 0' },
      h('label', { class: 'field' }, 'How it starts', mode),
      h('label', { class: 'field' }, 'Who can do it', (() => {
        const who = select([{ value: 'gangs', label: 'Gangs only' }, { value: 'anyone', label: 'Anyone (in a gang or not)' }], d.openTo || 'gangs');
        who.addEventListener('change', () => { d.openTo = who.value; rerender(); });
        return who;
      })()),
      usesNpc ? h('label', { class: 'field' }, 'Contact\'s name', name) : null),
    usesNpc ? h('div', { class: 'field' }, 'Who they are', pedPicker(d.startNpc.ped, (m) => { d.startNpc.ped = m; }, meta.peds || [])) : null,
    usesNpc ? h('label', { class: 'field', style: 'margin-top:8px' }, 'What they say', say) : null,
    d.openTo === 'anyone' ? h('p', { class: 'hint', style: 'margin:8px 0 0', text: 'Players with no gang can do it too: their crew is whoever with no gang is at the start with them, loot money goes to whoever grabs it, and gang tiers and rank permissions don\'t apply to them.' }) : null);
}

/* NPC picker: categories with pictures, search, or any custom model ------------------ */

const PED_IMAGE = (model) => `https://docs-backend.fivem.net/peds/${model}.webp`; // FiveM's ped reference pictures

function pedThumb(model, big) {
  const box = h('span', { class: big ? 'ped-thumb big' : 'ped-thumb' });
  const img = h('img', { src: PED_IMAGE(model), alt: '', loading: 'lazy' });
  img.addEventListener('error', () => { img.remove(); box.classList.add('none'); });
  box.append(img);
  return box;
}

function pedLabel(model, categories) {
  for (const c of categories) for (const p of c.peds) if (p.model === model) return p.label;
  return null;
}

function pedPicker(value, onPick, categories) {
  const wrap = h('div', { class: 'ped-picker' });
  let current = value;
  let cat = 0;
  const findCat = () => { categories.forEach((c, i) => { if (c.peds.some((p) => p.model === current)) cat = i; }); };
  findCat();

  const closed = () => {
    const label = pedLabel(current, categories);
    wrap.replaceChildren(h('div', { class: 'ped-current' },
      pedThumb(current),
      h('span', { class: 'ped-name' }, h('strong', { text: label || 'Custom NPC' }), h('span', { class: 'muted', text: current })),
      h('button', { class: 'btn small', type: 'button', onclick: open }, 'Change')));
  };

  const choose = (model) => { current = model; onPick(model); closed(); };

  const open = () => {
    const search = h('input', { type: 'search', placeholder: 'Search every NPC…', style: 'flex:1' });
    const tabs = h('div', { class: 'choices ped-tabs', role: 'radiogroup' });
    const grid = h('div', { class: 'ped-grid' });
    const custom = h('input', { type: 'text', placeholder: 'any ped model, e.g. my_addon_ped', value: pedLabel(current, categories) ? '' : current, style: 'flex:1;min-width:0' });
    const draw = () => {
      const q = search.value.trim().toLowerCase();
      tabs.hidden = !!q;
      tabs.replaceChildren(...categories.map((c, i) => h('button', { type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(i === cat), onclick: () => { cat = i; draw(); } }, c.category)));
      const list = q
        ? categories.flatMap((c) => c.peds.map((p) => ({ ...p, category: c.category }))).filter((p) => p.label.toLowerCase().includes(q) || p.model.includes(q))
        : (categories[cat] || { peds: [] }).peds;
      grid.replaceChildren(...(list.length ? list.map((p) => h('button', { type: 'button', class: `ped-card${p.model === current ? ' on' : ''}`, onclick: () => choose(p.model) },
        pedThumb(p.model, true), h('strong', { text: p.label }), h('span', { class: 'muted', text: p.model })))
        : [h('p', { class: 'empty', style: 'grid-column:1/-1', text: 'Nothing matches. Use a custom model below.' })]));
    };
    search.addEventListener('input', draw);
    draw();
    wrap.replaceChildren(h('div', { class: 'ped-open' },
      h('div', { class: 'row', style: 'flex-wrap:nowrap' }, search, h('button', { class: 'btn small', type: 'button', onclick: closed }, 'Cancel')),
      tabs, grid,
      h('div', { class: 'row', style: 'flex-wrap:nowrap;align-items:center' },
        h('span', { class: 'muted', style: 'white-space:nowrap', text: 'Not listed?' }), custom,
        h('button', { class: 'btn small', type: 'button', onclick: () => {
          const m = custom.value.trim().toLowerCase();
          if (!/^[a-z0-9_]+$/.test(m)) return toast('Ped model names are letters, numbers and underscores.', true);
          choose(m);
        } }, 'Use this model'))));
    search.focus();
  };

  closed();
  return wrap;
}

/* Custom contracts --------------------------------------------------------- */

const JOB_SPOTS = {
  courier: [['pickup', 'Pickup'], ['drop', 'Drop-off']],
  transport: [['pickup', 'Where the car is parked (face the way it should point)'], ['drop', 'Drop-off']],
  collect: [['spot', 'Where the debtor waits (face the way he should face)']],
};

function rewardSummary(j) {
  const parts = [];
  if (j.money > 0) parts.push(`${money(j.money)} ${j.account === 'clean' ? 'clean' : 'dirty'}`);
  (j.items || []).forEach((it) => parts.push(`${it.count} x ${it.label || it.item}`));
  if (j.reputation > 0) parts.push(`+${j.reputation} rep`);
  return parts.join(', ') || 'No reward';
}

function contractTabs() {
  const tab = admin.jobTab || 'custom';
  return h('div', { class: 'choices', role: 'radiogroup', style: 'margin-bottom:16px' },
    [['custom', 'Custom jobs'], ['standard', 'Job types & board']].map(([key, label]) => h('button', {
      type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(tab === key),
      onclick: () => { admin.jobTab = key; admin.contractDraft = null; renderAdminTab(); },
    }, label)));
}

/* Job types & board: config/contracts.lua, editable in game */
async function renderContractSettings() {
  if (!admin.contractDraft) {
    const res = await adminRequest('contractSettings');
    if (!res.ok) return loadError(res);
    admin.contractDraft = res.data;
  }
  const v = admin.contractDraft;
  const rerender = () => renderAdminTab();
  const num = (obj, key, min, max, width = 90, step = 'any') => {
    const el = h('input', { type: 'number', min, max, step, value: obj[key] ?? '', style: `width:${width}px` });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };
  // A 0-1 chance shown as a percentage
  const pct = (obj, key) => {
    const el = h('input', { type: 'number', min: 0, max: 100, value: Math.round((obj[key] || 0) * 100), style: 'width:80px' });
    el.addEventListener('change', () => { obj[key] = Math.max(0, Math.min(100, Number(el.value))) / 100; });
    return el;
  };
  // Seconds shown as minutes
  const mins = (obj, key) => {
    const el = h('input', { type: 'number', min: 3, max: 120, value: Math.round((obj[key] || 0) / 60), style: 'width:80px' });
    el.addEventListener('change', () => { obj[key] = Number(el.value) * 60; });
    return el;
  };
  const txt = (obj, key, width = 200, max = 40) => {
    const el = h('input', { type: 'text', value: obj[key] || '', maxlength: max, style: `width:${width}px` });
    el.addEventListener('input', () => { obj[key] = el.value; });
    return el;
  };
  const list = (obj, key, ph) => {
    const el = h('textarea', { rows: 2, placeholder: ph, style: 'width:100%' });
    el.value = (obj[key] || []).join(', ');
    el.addEventListener('change', () => { obj[key] = el.value.split(/[\s,]+/).map((x) => x.trim()).filter(Boolean); });
    return el;
  };
  const acct = (obj) => {
    const el = select([{ value: 'dirty', label: 'Dirty money' }, { value: 'clean', label: 'Clean money' }], obj.account);
    el.addEventListener('change', () => { obj.account = el.value; });
    return el;
  };

  const typeNames = Object.fromEntries(v.templateKeys.map((k) => [k, v.templates[k].title]));
  const types = v.templateKeys.map((key) => {
    const t = v.templates[key];
    return h('div', { class: 'heist-edit-step' },
      h('div', { class: 'heist-edit-head' }, h('strong', { text: key === 'courier' ? 'Courier run' : (key === 'transport' ? 'Stolen car' : (key === 'collect' ? 'Debt collection' : key)) }),
        h('span', { class: 'muted', text: ' (how it plays is fixed; everything here is yours to change)' })),
      h('div', { class: 'heist-settings', style: 'margin:0' },
        h('label', { class: 'field' }, 'Title on the board', txt(t, 'title', 220)),
        h('label', { class: 'field' }, 'Base reward (£)', num(t, 'reward', 0, 10000000, 120, 50)),
        h('label', { class: 'field' }, 'Paid as', acct(t)),
        h('label', { class: 'field' }, 'Time to finish (min)', mins(t, 'timeLimit')),
        t.payChance != null ? h('label', { class: 'field' }, 'Debtor pays up (%)', pct(t, 'payChance')) : null,
        t.fightChance != null ? h('label', { class: 'field' }, 'Non-payers who fight (%)', pct(t, 'fightChance')) : null),
      t.vehicles ? h('label', { class: 'field' }, 'Car models (one is picked each time)', list(t, 'vehicles', 'sultan, felon, baller')) : null,
      t.peds ? h('label', { class: 'field' }, 'Debtor models (one is picked each time)', list(t, 'peds', 'a_m_m_business_01')) : null);
  });

  const risks = v.difficulty.map((d, i) => h('tr', {},
    h('td', {}, txt(d, 'label', 130, 24)),
    h('td', {}, num(d, 'reward', 0.1, 10, 80, 0.1)),
    h('td', {}, num(d, 'trust', 0, 100, 70, 1)),
    h('td', {}, num(d, 'reputation', 0, 100, 70, 1)),
    h('td', {}, num(d, 'failTrust', -100, 0, 70, 1))));

  const contacts = v.contacts.map((c, i) => h('div', { class: 'heist-edit-step' },
    h('div', { class: 'heist-edit-head' },
      h('label', { class: 'field', style: 'margin:0' }, 'Name', txt(c, 'label', 200, 32)),
      h('div', { class: 'row', style: 'align-items:center;gap:14px' }, v.templateKeys.map((key) => {
        const box = h('input', { type: 'checkbox', checked: c.templates.includes(key) });
        box.addEventListener('change', () => {
          c.templates = box.checked ? [...new Set([...c.templates, key])] : c.templates.filter((k) => k !== key);
        });
        return h('label', { class: 'toggle' }, box, ` ${typeNames[key]}`);
      })),
      h('button', { class: 'btn small danger', type: 'button', style: 'margin-left:auto', onclick: () => { v.contacts.splice(i, 1); rerender(); } }, 'Remove'))));

  const save = async () => {
    const r = await adminRequest('contractSettingsSave', v);
    if (!r.ok) return toast(r.error, true);
    admin.contractDraft = r.data;
    toast('Saved. New jobs use these settings straight away.');
    rerender();
  };
  const reset = () => confirmModal({ title: 'Go back to config/contracts.lua?', body: 'Your changes here are thrown away. Trust gangs have built with each contact is kept.', confirmLabel: 'Reset', danger: true,
    onConfirm: async () => { const r = await adminRequest('contractSettingsReset'); if (r.ok) { admin.contractDraft = r.data; toast('Back to the config settings.'); rerender(); } } });

  return h('div', {},
    contractTabs(),
    h('div', { class: 'section-head' }, h('h2', { text: 'Job types & board' }),
      h('div', { class: 'row' }, h('button', { class: 'btn small', type: 'button', onclick: reset }, 'Reset to config'), h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save'))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'The standard jobs that fill gangs\' Contracts boards. A job\'s pay is its base reward times its risk level\'s multiplier (give or take 15%), and street events can move it.' }),
    h('h3', { text: 'Job types' }),
    h('div', { style: 'display:grid;gap:10px' }, types),
    h('h3', { style: 'margin-top:22px', text: 'Risk levels' }),
    h('table', {},
      h('thead', {}, h('tr', {}, h('th', { text: 'Name' }), h('th', { text: 'Reward ×' }), h('th', { text: 'Trust gained' }), h('th', { text: 'Reputation gained' }), h('th', { text: 'Trust lost if failed' }))),
      h('tbody', {}, risks)),
    h('h3', { style: 'margin-top:22px', text: 'Trust tiers' }),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'How much trust with a contact unlocks each risk level from them.' }),
    h('div', { class: 'heist-settings' }, v.difficulty.slice(1).map((d, i) => h('label', { class: 'field' }, `${d.label} from`, num(v.tiers, i + 1, 0, 100000, 100, 1)))),
    h('h3', { style: 'margin-top:8px', text: 'Contacts' }),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'Who offers jobs, and which kinds. Removing a contact stops their jobs; the trust gangs built with them is kept if you add them back with the same name.' }),
    h('div', { style: 'display:grid;gap:8px' }, contacts),
    h('button', { class: 'btn small', type: 'button', style: 'margin-top:8px', onclick: () => { v.contacts.push({ key: '', label: '', templates: [...v.templateKeys] }); rerender(); } }, 'Add a contact'),
    h('h3', { style: 'margin-top:22px', text: 'The board' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Jobs on each gang\'s board', num(v, 'offersPerGang', 1, 10, 80, 1)),
      h('label', { class: 'field' }, 'Offers stay up for (min)', num(v, 'offerMinutes', 5, 600, 80, 1)),
      h('label', { class: 'field' }, 'Top up boards every (min)', num(v, 'refreshMinutes', 1, 60, 80, 1)),
      h('label', { class: 'field' }, 'Shortest route (m)', num(v, 'minRouteDistance', 100, 5000, 90, 50)),
      h('label', { class: 'field' }, 'Stolen car reported to police (%)', pct(v, 'policeAlertChance'))));
}

async function renderJobList() {
  const res = await adminRequest('customContracts');
  if (!res.ok) return loadError(res);
  admin.jobMeta = res.data;
  const { jobs, types, gangs } = res.data;
  const typeLabel = Object.fromEntries(types.map((t) => [t.key, t.label]));

  const offerNow = (j) => {
    const pick = select(gangs.map((g) => ({ value: g.id, label: g.label })), j.gangId || (gangs[0] || {}).id);
    showModal(
      h('h2', { text: `Offer "${j.title}" now` }),
      h('p', { text: 'It goes straight onto that gang\'s Contracts board for three hours, and they\'re told about it.' }),
      h('label', { class: 'field' }, 'Gang', pick),
      h('div', { class: 'buttons' },
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn primary', type: 'button', onclick: async () => { if (await adminAct('customContractOffer', [j.id, Number(pick.value)], 'Offered.')) hideModal(); } }, 'Offer it')));
  };

  const rows = jobs.map((j) => h('tr', {},
    h('td', { class: 'clickable', onclick: () => { admin.job = JSON.parse(JSON.stringify(j)); renderAdminTab(); } },
      h('strong', { text: j.title }),
      h('div', { class: 'hint', style: 'margin:0', text: `${typeLabel[j.type] || j.type} from ${j.contact}  ·  ${rewardSummary(j)}` })),
    h('td', {}, !j.enabled ? h('span', { class: 'muted', text: j.once && j.done ? 'Done' : 'Off' })
      : h('span', { class: 'credit', text: j.gangId ? `For ${j.gangLabel || 'one gang'}` : `All gangs, ${j.chance}%` })),
    h('td', { class: 'actions' },
      gangs.length ? h('button', { class: 'btn small', type: 'button', onclick: () => offerNow(j) }, 'Offer now') : null,
      h('button', { class: 'btn small', type: 'button', onclick: () => { admin.job = JSON.parse(JSON.stringify(j)); renderAdminTab(); } }, 'Edit'))));

  const blank = () => ({ title: '', description: '', contact: '', type: types.some((t) => t.key === 'courier') ? 'courier' : (types[0] || {}).key, difficulty: 1, timeLimit: 15,
    money: 5000, account: 'dirty', items: [], reputation: 0, chance: 25, once: false, enabled: true, minTier: 1, gangId: null });

  return h('div', {},
    contractTabs(),
    h('div', { class: 'section-head' }, h('h2', { text: 'Custom jobs' }),
      h('button', { class: 'btn primary', type: 'button', onclick: () => { admin.job = blank(); renderAdminTab(); } }, 'New contract')),
    h('p', { class: 'hint', style: 'margin-bottom:14px', text: 'Jobs you make here turn up on gangs\' Contracts boards alongside the usual ones, or you can offer one straight to a gang. You choose the reward: money, items and reputation. Jobs from a regular contact build trust with them like their usual work.' }),
    jobs.length ? h('table', {}, h('tbody', {}, rows)) : h('p', { class: 'empty', text: 'No custom contracts yet. Press New contract to make one.' }));
}

function renderJobEditor() {
  const j = admin.job;
  const meta = admin.jobMeta || { types: [], difficulty: [], tiers: [], gangs: [] };
  const rerender = () => renderAdminTab();
  const input = (key, ph, width = 260, max = 48) => {
    const el = h('input', { type: 'text', value: j[key] || '', placeholder: ph, maxlength: max, style: `width:${width}px;max-width:100%` });
    el.addEventListener('input', () => { j[key] = el.value; });
    return el;
  };
  const num = (obj, key, min, max, width = 100) => {
    const el = h('input', { type: 'number', min, max, value: obj[key] ?? '', style: `width:${width}px` });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };
  const choose = (key, options, after) => {
    const el = select(options, j[key] ?? '');
    el.addEventListener('change', () => { j[key] = /^\d+$/.test(el.value) ? Number(el.value) : (el.value === '' ? null : el.value); if (after) after(); });
    return el;
  };
  // From: one of the regular contacts (the job builds trust with them) or someone else, typed in
  const contacts = meta.contacts || [];
  if (j.contactKey === undefined) j.contactKey = j.id ? null : (contacts[0] ? contacts[0].key : null);
  const isOther = !j.contactKey || !contacts.some((c) => c.key === j.contactKey);
  const contactSel = select([...contacts.map((c) => ({ value: c.key, label: c.label })), { value: '__other', label: 'Someone else…' }], isOther ? '__other' : j.contactKey);
  contactSel.addEventListener('change', () => { j.contactKey = contactSel.value === '__other' ? null : contactSel.value; rerender(); });
  const contactPick = h('div', { class: 'row', style: 'flex-wrap:nowrap' }, contactSel,
    isOther ? input('contact', 'Their name', 170, 32) : null);
  const description = h('textarea', { rows: 2, maxlength: 200, placeholder: 'Optional. Left blank, it describes the route for you.', style: 'width:100%' });
  description.value = j.description || '';
  description.addEventListener('input', () => { j.description = description.value; });

  // Where: each spot set where staff stand, or random from the contract spot lists
  const spots = (JOB_SPOTS[j.type] || []).map(([key, label]) => {
    const p = j[key];
    return h('div', { class: 'heist-edit-start' },
      h('div', {}, h('strong', { text: label }), h('div', { class: 'hint', style: 'margin:0', text: p ? `Fixed: ${Math.round(p.x)}, ${Math.round(p.y)}` : 'Random from the Contract spots list each time' })),
      h('span', { class: 'heist-pos' },
        h('button', { class: 'btn small', type: 'button', onclick: async () => { const r = await adminRequest('heistHere'); if (!r.ok) return toast(r.error, true); j[key] = { ...r.data, label: j.title || 'Marked spot' }; toast('Set to where you\'re standing.'); rerender(); } }, 'Set here'),
        p ? h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoPoint', [p]) }, 'Go to') : null,
        p ? h('button', { class: 'btn small', type: 'button', onclick: () => { j[key] = null; rerender(); } }, 'Make random') : null));
  });

  // Reward items
  j.items = j.items || [];
  const items = j.items.map((it, i) => h('div', { class: 'row', style: 'align-items:center' },
    h('div', { style: 'flex:1;max-width:400px' }, itemPicker(it.item ? { item: it.item, label: it.label, image: it.image } : null,
      (picked) => { if (picked) { it.item = picked.name; it.label = picked.label; it.image = picked.image; } }, { allowClear: false, openNow: !it.item, emptyText: 'No item chosen yet' })),
    h('label', { class: 'field' }, 'How many', num(it, 'count', 1, 500, 80)),
    h('button', { class: 'btn small danger', type: 'button', style: 'align-self:end', onclick: () => { j.items.splice(i, 1); rerender(); } }, 'Remove')));

  const save = async () => {
    if (j.items.some((it) => !it.item)) return toast('Pick an item for every reward row, or remove it.', true);
    const r = await adminRequest('customContractSave', j);
    if (!r.ok) return toast(r.error, true);
    toast('Saved.');
    admin.job = null;
    rerender();
  };

  const enabled = h('input', { type: 'checkbox', checked: j.enabled !== false });
  enabled.addEventListener('change', () => { j.enabled = enabled.checked; });
  const once = h('input', { type: 'checkbox', checked: j.once === true });
  once.addEventListener('change', () => { j.once = once.checked; });

  return h('div', {},
    h('div', { class: 'section-head' },
      h('button', { class: 'btn small', type: 'button', onclick: () => { admin.job = null; rerender(); } }, 'All contracts'),
      j.id ? h('button', { class: 'btn small danger', type: 'button', onclick: () => confirmModal({ title: `Delete "${j.title}"?`, body: 'Gangs won\'t be offered it again. Any already on a board stay until they run out.', confirmLabel: 'Delete', danger: true, onConfirm: async () => { if (await adminAct('customContractDelete', [j.id], 'Deleted.')) { admin.job = null; rerender(); } } }) }, 'Delete') : null),
    h('h3', { style: 'margin-top:6px', text: j.id ? j.title : 'New contract' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Title', input('title', 'e.g. Bring me the Pegasus files')),
      h('label', { class: 'field' }, 'From (contact)', contactPick),
      h('label', { class: 'field' }, 'Job type', choose('type', meta.types.map((t) => ({ value: t.key, label: t.label })), rerender)),
      h('label', { class: 'field' }, 'Risk', choose('difficulty', meta.difficulty.map((d, i) => ({ value: i + 1, label: d })))),
      h('label', { class: 'field' }, 'Time to finish (minutes)', num(j, 'timeLimit', 3, 120))),
    h('label', { class: 'field', style: 'max-width:640px' }, 'Description', description),
    j.type === 'transport' ? h('label', { class: 'field', style: 'margin-top:10px' }, 'Car model (blank for a random one)', input('model', 'e.g. sultan', 200, 32)) : null,
    h('h3', { style: 'margin:22px 0 8px', text: 'Where' }),
    h('div', { style: 'display:grid;gap:8px' }, spots),
    h('h3', { style: 'margin:22px 0 8px', text: 'Reward' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Money (£)', num(j, 'money', 0, 10000000, 130)),
      h('label', { class: 'field' }, 'Paid into', choose('account', [{ value: 'dirty', label: 'Dirty money' }, { value: 'clean', label: 'Clean money' }])),
      h('label', { class: 'field' }, 'Bonus reputation', num(j, 'reputation', 0, 500))),
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'Items go to whoever completes the job.' }),
    h('div', { style: 'display:grid;gap:8px' }, items),
    h('button', { class: 'btn small', type: 'button', style: 'margin-top:8px', onclick: () => { j.items.push({ item: null, count: 1 }); rerender(); } }, 'Add an item'),
    h('h3', { style: 'margin:22px 0 8px', text: 'Who gets it' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'Offered to', choose('gangId', [{ value: '', label: 'Every gang' }, ...meta.gangs.map((g) => ({ value: g.id, label: g.label }))])),
      h('label', { class: 'field' }, 'From tier', choose('minTier', meta.tiers.map((t, i) => ({ value: i + 1, label: t })))),
      h('label', { class: 'field' }, 'Chance on each new board job (%)', num(j, 'chance', 0, 100))),
    h('div', { class: 'row', style: 'gap:22px;margin-top:6px' },
      h('label', { class: 'toggle' }, enabled, ' On (turns up on boards)'),
      h('label', { class: 'toggle' }, once, ' Once only (switches off after someone completes it)')),
    h('div', { class: 'heist-save' }, h('span', { class: 'hint', style: 'margin:0', text: 'Set chance to 0 to only ever hand it out with Offer now.' }),
      h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save')));
}

/* Staff access (management only) ----------------------------------------- */

async function renderStaffAccess() {
  const res = await adminRequest('staffAccess');
  if (!res.ok) return loadError(res);
  const v = res.data;

  const people = v.users.map((u) => h('tr', {},
    h('td', {}, h('strong', { text: u.name || 'Unknown' }), h('div', { class: 'hint', style: 'margin:0', text: u.license })),
    h('td', { text: u.role === 'management' ? 'Management' : 'Staff' }),
    h('td', { class: 'actions' }, h('button', {
      class: 'btn small danger', type: 'button',
      onclick: () => confirmModal({ title: `Remove ${u.name || 'this person'}?`, body: 'They lose access to /gangadmin given here. Access from ACE permissions in server.cfg isn\'t affected.', confirmLabel: 'Remove', danger: true, onConfirm: () => adminAct('staffRevoke', [u.license], 'Access removed.') }),
    }, 'Remove'))));

  const grant = async () => {
    const pick = await playerSelect();
    const role = select([{ value: 'staff', label: 'Staff' }, { value: 'management', label: 'Management' }], 'staff');
    showModal(
      h('h2', { text: 'Give access' }),
      h('p', { text: 'Pick an online player. Access is tied to their game licence, so it carries across characters.' }),
      h('label', { class: 'field' }, 'Player', pick),
      h('label', { class: 'field', style: 'margin-top:12px' }, 'Level', role),
      h('div', { class: 'buttons' },
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn primary', type: 'button', onclick: async () => { if (await adminAct('staffGrant', [Number(pick.value), role.value], 'Access given.')) hideModal(); } }, 'Give access')));
  };

  const boxes = v.groups.map((g) => {
    const box = h('input', { type: 'checkbox', checked: g.on, value: g.key });
    return h('label', { class: 'perm-row' }, box, h('span', { text: g.label }));
  });
  const savePerms = () => adminAct('staffPerms', [boxes.map((b) => b.querySelector('input')).filter((i) => i.checked).map((i) => i.value)], 'Staff permissions saved.');

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Staff access' }), h('button', { class: 'btn primary', type: 'button', onclick: grant }, 'Give access')),
    h('p', { class: 'hint', style: 'margin-bottom:14px', text: 'Management can do everything here. Staff can only do what\'s ticked below. Your server admins (Config.Admin.group) are always management; you can also grant access with the ACEs vinewood_gangs.staff and vinewood_gangs.management.' }),
    v.users.length ? h('table', {}, h('tbody', {}, people)) : h('p', { class: 'empty', text: 'Nobody has been given access in game yet.' }),
    h('h3', { style: 'margin:24px 0 8px', text: 'What Staff can do' }),
    h('div', { class: 'perm-list' }, boxes),
    h('button', { class: 'btn primary', type: 'button', style: 'margin-top:14px', onclick: savePerms }, 'Save'));
}

/* Item picker: search the server's inventory items ------------------------ */

function itemImage(src, size = 28) {
  const img = h('img', { class: 'pick-img', src: src || '', alt: '', style: `width:${size}px;height:${size}px` });
  img.addEventListener('error', () => { img.style.visibility = 'hidden'; });
  return img;
}

/* value = { item, label, image } or null. onPick(item|null) runs when staff choose or clear.
   Stays compact until staff press Choose or Change; then it searches as they type. */
function itemPicker(value, onPick, { placeholder = 'Search items…', allowClear = true, emptyText = 'Nothing chosen', openNow = false } = {}) {
  const box = h('div', { class: 'picker' });
  const idle = () => {
    if (value && value.item) {
      box.replaceChildren(h('div', { class: 'pick-chosen' },
        itemImage(value.image),
        h('span', {}, h('strong', { text: value.label || value.item }), h('span', { class: 'muted', text: ` ${value.item}` })),
        h('button', { class: 'btn small', type: 'button', onclick: () => searching() }, 'Change'),
        allowClear ? h('button', { class: 'btn small', type: 'button', onclick: () => { value = null; onPick(null); idle(); } }, 'Clear') : null));
    } else {
      box.replaceChildren(h('div', { class: 'pick-chosen' },
        h('span', { class: 'muted', text: emptyText }),
        h('button', { class: 'btn small', type: 'button', onclick: () => searching() }, 'Choose')));
    }
  };
  const searching = () => {
    const input = h('input', { type: 'search', placeholder, style: 'flex:1;min-width:0', 'aria-label': 'Search items' });
    const results = h('div', { class: 'pick-results' });
    let timer;
    const run = async () => {
      const res = await adminRequest('searchItems', input.value.trim());
      const list = res.ok ? res.data : [];
      results.replaceChildren(...(list.length ? list.map((it) => h('button', {
        class: 'pick-row', type: 'button',
        onclick: () => { value = { item: it.name, label: it.label, image: it.image }; onPick(it); idle(); },
      }, itemImage(it.image, 24), h('span', { text: it.label }), h('span', { class: 'muted', text: it.name }))) : [h('p', { class: 'hint', style: 'margin:6px 8px', text: 'No items match.' })]));
    };
    input.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(run, 180); });
    input.addEventListener('keydown', (e) => { if (e.key === 'Escape') { e.stopPropagation(); idle(); } });
    box.replaceChildren(h('div', { class: 'row', style: 'flex-wrap:nowrap' }, input, h('button', { class: 'btn small', type: 'button', onclick: idle }, 'Cancel')), results);
    setTimeout(() => input.focus(), 0);
    run();
  };
  if (openNow && !(value && value.item)) searching(); else idle();
  return box;
}

/* Street dealing ---------------------------------------------------------- */

async function renderAdminDrugs() {
  const res = await adminRequest('drugItems');
  if (!res.ok) return loadError(res);
  const v = res.data;
  const list = admin.drugDraft || (admin.drugDraft = v.items.map((d) => ({ ...d })));
  const businesses = [{ value: '', label: 'None' }, ...v.businesses.map((b) => ({ value: b.key, label: b.label }))];
  const rerender = () => renderAdminTab();
  const num = (obj, key, min, max) => {
    const el = h('input', { type: 'number', min, max, value: obj[key] ?? '', style: 'width:96px' });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };

  const rows = list.map((d, i) => {
    const label = h('input', { type: 'text', value: d.label || '', maxlength: 32, placeholder: 'e.g. weed', style: 'width:150px' });
    label.addEventListener('input', () => { d.label = label.value; });
    const biz = select(businesses, d.enterprise || '');
    biz.addEventListener('change', () => { d.enterprise = biz.value || null; });
    return h('div', { class: 'drug-row' },
      h('div', { class: 'drug-item' }, itemPicker(d.item ? { item: d.item, label: d.itemLabel || d.item, image: d.image } : null, (it) => {
        d.item = it ? it.name : null; d.itemLabel = it ? it.label : null; d.image = it ? it.image : null;
        if (it && !d.label) { d.label = it.label.toLowerCase(); rerender(); }
      }, { allowClear: false, emptyText: 'No item chosen yet', openNow: !d.item })),
      h('div', { class: 'drug-fields' },
        h('label', { class: 'field' }, 'Called', label),
        h('label', { class: 'field' }, 'Price from', num(d, 'min', 1, 1000000)),
        h('label', { class: 'field' }, 'to', num(d, 'max', 1, 1000000)),
        h('label', { class: 'field' }, 'Most per sale', num(d, 'maxPer', 1, 20)),
        h('label', { class: 'field' }, 'Bagged up by', biz),
        h('button', { class: 'btn small danger', type: 'button', style: 'align-self:end', onclick: () => { list.splice(i, 1); rerender(); } }, 'Remove')));
  });

  const save = async () => {
    if (list.some((d) => !d.item)) return toast('Pick an item for every row first.', true);
    const r = await adminRequest('drugItemsSave', list);
    if (!r.ok) return toast(r.error, true);
    admin.drugDraft = null;
    toast('Saved. Dealers use the new list straight away.');
    rerender();
  };

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Street dealing' }),
      h('div', { class: 'row' },
        !v.fromConfig ? h('button', { class: 'btn small', type: 'button', onclick: () => confirmModal({ title: 'Go back to the config list?', body: 'Replaces this list with the one in config/drugs.lua.', confirmLabel: 'Reset', danger: true, onConfirm: async () => { const r = await adminRequest('drugItemsReset'); if (r.ok) { admin.drugDraft = null; toast('Back to the config list.'); rerender(); } } }) }, 'Reset to config') : null,
        h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save'))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: `What gang members can sell to people on the street. Price is per unit, before the area's value and market events. ${v.fromConfig ? 'Currently using the list from config/drugs.lua; saving here replaces it.' : 'Saved here (config/drugs.lua is no longer used for this).'}` }),
    rows.length ? h('div', { class: 'drug-list' }, rows) : h('p', { class: 'empty', text: 'Nothing can be sold. Add an item below.' }),
    h('button', { class: 'btn', type: 'button', style: 'margin-top:12px', onclick: () => { list.push({ item: null, label: '', min: 80, max: 140, maxPer: 2, enterprise: null }); rerender(); } }, 'Add an item'));
}

/* Heists builder ---------------------------------------------------------- */

const ALERT_OPTIONS = [{ value: 'none', label: 'No alarm' }, { value: 'silent', label: 'Silent alarm' }, { value: 'loud', label: 'Loud alarm' }];
const DIFFICULTY = [{ value: 1, label: 'Easy' }, { value: 2, label: 'Medium' }, { value: 3, label: 'Hard' }];
const point = (p) => (p && p.x != null ? `${Math.round(p.x)}, ${Math.round(p.y)}` : 'Not set');

async function renderHeistList() {
  const res = await adminRequest('heists');
  if (!res.ok) return loadError(res);
  admin.heistMeta = res.data;
  const { heists, templates } = res.data;

  const rows = heists.map((x) => h('tr', { class: 'clickable', onclick: () => { admin.heist = JSON.parse(JSON.stringify(x)); renderAdminTab(); } },
    h('td', {}, h('strong', { text: x.label }), h('div', { class: 'hint', style: 'margin:0', text: `${x.data.steps.length} steps  ·  needs ${x.data.police} police, ${x.data.crew} crew` })),
    h('td', {}, x.running ? h('span', { class: 'debit', text: `${x.running} on it now` })
      : (x.enabled ? h('span', { class: 'credit', text: 'Live' }) : h('span', { class: 'muted', text: 'Draft' }))),
    h('td', { class: 'num' }, x.cooldownLeft > 0 ? countdown(x.cooldownLeft) : h('span', { class: 'muted', text: 'Ready' }))));

  const newHeist = () => showModal(
    h('h2', { text: 'New heist' }),
    h('p', { text: 'Pick a starting point. It lays out the usual steps; you set where each one happens in game, and can change anything.' }),
    h('div', { class: 'template-grid' }, templates.map((t) => h('button', {
      class: 'template', type: 'button',
      onclick: async () => {
        const r = await adminRequest('heistCreate', t.key);
        if (!r.ok) return toast(r.error, true);
        hideModal();
        admin.heist = r.data;
        renderAdminTab();
      },
    }, h('strong', { text: t.label }), h('span', { class: 'hint', style: 'margin:0', text: t.steps ? `${t.steps} steps to start with` : 'Build it from scratch' })))),
    h('div', { class: 'buttons' }, h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel')));

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Heists' }), h('button', { class: 'btn primary', type: 'button', onclick: newHeist }, 'New heist')),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Heists you build here appear in gangs\' tablets once they\'re live. Gangs need to reach the Organisation tier first (config/progression.lua).' }),
    heists.length ? h('table', {}, h('tbody', {}, rows)) : h('p', { class: 'empty', text: 'No heists yet. Press New heist to build one.' }));
}

function renderHeistEditor() {
  const x = admin.heist;           // the draft being edited
  const meta = admin.heistMeta || {};
  if (!x || typeof x !== 'object' || !x.data) {
    admin.heist = null;
    toast('Couldn\'t open that heist. Try again.', true);
    return h('p', { class: 'empty', text: 'Couldn\'t open that heist.' });
  }
  const d = x.data;
  const rerender = () => renderAdminTab();

  const here = async (assign) => {
    const r = await adminRequest('heistHere');
    if (!r.ok) return toast(r.error, true);
    assign(r.data);
    toast('Set to where you\'re standing.');
    rerender();
  };
  const goTo = (p) => (p && p.x != null ? adminAct('gotoPoint', [p]) : toast('Not set yet.', true));

  const num = (obj, key, min, max, width = 80) => {
    const el = h('input', { type: 'number', min, max, value: obj[key] ?? '', style: `width:${width}px` });
    el.addEventListener('change', () => { obj[key] = Number(el.value); });
    return el;
  };
  const text = (obj, key, width = 220, ph = '') => {
    const el = h('input', { type: 'text', value: obj[key] || '', placeholder: ph, maxlength: 64, style: `width:${width}px` });
    el.addEventListener('input', () => { obj[key] = el.value; });
    return el;
  };
  const pick = (obj, key, options) => {
    const el = select(options, obj[key]);
    el.addEventListener('change', () => { obj[key] = /^\d+$/.test(el.value) ? Number(el.value) : el.value; rerender(); });
    return el;
  };

  // Settings
  const enabled = h('input', { type: 'checkbox', checked: x.enabled });
  enabled.addEventListener('change', () => { x.enabled = enabled.checked; });
  const tiers = (meta.tiers || []).map((t, i) => ({ value: i + 1, label: t }));
  if (!d.tier) d.tier = meta.defaultTier || 1;
  const settings = h('div', { class: 'heist-settings' },
    h('label', { class: 'field' }, 'Name', text(x, 'label', 260)),
    h('label', { class: 'field' }, 'Police on duty needed', num(d, 'police', 0, 20)),
    h('label', { class: 'field' }, 'Crew needed', num(d, 'crew', 1, 10)),
    h('label', { class: 'field' }, 'Time limit (minutes)', num(d, 'timeLimit', 3, 120)),
    h('label', { class: 'field' }, 'Cooldown (minutes)', num(d, 'cooldown', 5, 1440)),
    h('label', { class: 'field' }, 'Gang tier needed', pick(d, 'tier', tiers)));

  const truckJob = d.steps[0] && d.steps[0].type === 'truck';
  const followsTruck = (s) => truckJob && (s.type === 'truck_doors' || s.type === 'loot');

  // Steps
  const typeOptions = (meta.stepTypes || []).map((t) => ({ value: t.key, label: t.label }));
  const lootOptions = (meta.lootTypes || []).map((t) => ({ value: t.key, label: t.label }));
  const move = (i, by) => { const j = i + by; if (j < 0 || j >= d.steps.length) return; [d.steps[i], d.steps[j]] = [d.steps[j], d.steps[i]]; rerender(); };

  const steps = d.steps.map((s, i) => {
    const type = (meta.stepTypes || []).find((t) => t.key === s.type) || {};
    const extra = [];
    if (type.game) extra.push(h('label', { class: 'field' }, 'Difficulty', pick(s, 'difficulty', DIFFICULTY)));
    if (type.game || s.type === 'loot' || s.type === 'wait') extra.push(h('label', { class: 'field' }, type.game ? 'Time to solve (s)' : 'Takes (s)', num(s, 'time', 3, 600)));
    if (s.type === 'loot') {
      if (s.loot && !s.loot.kind) { // older loot from config names: the server converts these, but be safe here too
        s.loot = s.loot.type === 'cash' ? { kind: 'money', account: 'dirty', min: s.loot.min, max: s.loot.max } : { kind: 'item', item: null, min: 1, max: 3 };
      }
      s.loot = s.loot || { kind: 'money', account: 'dirty', min: 1000, max: 2000 };
      const l = s.loot;
      const kind = select([{ value: 'money', label: 'Money to the treasury' }, { value: 'item', label: 'An item' }], l.kind);
      kind.addEventListener('change', () => {
        l.kind = kind.value;
        // Amounts that suit the new kind: a handful of items, or a sensible sum of money
        if (l.kind === 'item') { l.min = 1; l.max = 3; } else { l.account = l.account || 'dirty'; l.min = 1000; l.max = 2000; }
        rerender();
      });
      extra.push(h('label', { class: 'field' }, 'Loot', kind));
      if (l.kind === 'money') {
        extra.push(h('label', { class: 'field' }, 'Into', pick(l, 'account', [{ value: 'dirty', label: 'Dirty money' }, { value: 'clean', label: 'Clean money' }])));
      } else {
        extra.push(h('div', { class: 'field', style: 'min-width:280px' }, 'Item', itemPicker(l.item ? { item: l.item, label: l.label, image: l.image } : null,
          (it) => { l.item = it ? it.name : null; l.label = it ? it.label : null; l.image = it ? it.image : null; }, { allowClear: false, emptyText: 'No item chosen yet' })));
      }
      extra.push(h('label', { class: 'field' }, l.kind === 'money' ? 'Min (£)' : 'Min', num(l, 'min', 1, 10000000, 100)),
        h('label', { class: 'field' }, l.kind === 'money' ? 'Max (£)' : 'Max', num(l, 'max', 1, 10000000, 100)));
    }
    // Something the crew must carry for this step (otherwise the config default for the step type)
    if (type.game || s.type === 'wait') {
      const def = (meta.tools || {})[s.type];
      const consume = h('input', { type: 'checkbox', checked: s.item ? s.consume === true : !!(def && def.consume) });
      consume.addEventListener('change', () => { s.consume = consume.checked; });
      extra.push(h('div', { class: 'field', style: 'min-width:280px' }, 'Needs',
        itemPicker(s.item ? { item: s.item, label: s.itemLabel, image: s.itemImage } : null,
          (it) => { s.item = it ? it.name : null; s.itemLabel = it ? it.label : null; s.itemImage = it ? it.image : null; if (it && s.consume == null) s.consume = true; rerender(); },
          { placeholder: def ? `Search to replace ${def.label}…` : 'Search for a required item…', emptyText: def ? `${def.label} (default)` : 'Nothing needed' })));
      if (s.item) extra.push(h('label', { class: 'toggle', style: 'align-self:end;padding-bottom:8px' }, consume, ' Used up'));
    }
    // NPC steps (fill in the defaults so staff can see them)
    const npc = meta.npc || {};
    if (s.type === 'talk' && s.pay == null) s.pay = 0;
    if (s.type === 'guards') { if (s.count == null) s.count = 4; if (s.armour == null) s.armour = 50; if (s.accuracy == null) s.accuracy = 40; if (s.radius == null) s.radius = 10; }
    if (s.type === 'talk' || s.type === 'hostage' || s.type === 'guards') {
      const fallback = s.type === 'guards' ? (npc.guardPed || 's_m_m_security_01') : (npc.ped || 'a_m_m_business_01');
      extra.push(h('div', { class: 'field', style: 'flex:1 1 100%' }, s.type === 'guards' ? 'Guards look like' : 'Who they are',
        pedPicker(s.ped || fallback, (model) => { s.ped = model; }, meta.peds || [])));
    }
    if (s.type === 'talk') {
      const say = h('textarea', { rows: 2, maxlength: 200, placeholder: 'What they say, e.g. "The manager has the vault code. Get to him before he leaves."', style: 'width:100%' });
      say.value = s.say || '';
      say.addEventListener('input', () => { s.say = say.value; });
      extra.push(h('label', { class: 'field', style: 'flex:1 1 100%' }, 'What they say', say));
      extra.push(h('label', { class: 'field' }, 'They want paying (£, 0 = nothing)', num(s, 'pay', 0, 10000000, 120)));
      const def = (meta.tools || {})[s.type];
      extra.push(h('div', { class: 'field', style: 'min-width:280px' }, 'Needs (optional)',
        itemPicker(s.item ? { item: s.item, label: s.itemLabel, image: s.itemImage } : null,
          (it) => { s.item = it ? it.name : null; s.itemLabel = it ? it.label : null; s.itemImage = it ? it.image : null; if (it && s.consume == null) s.consume = true; rerender(); },
          { placeholder: 'Search for an item they want…', emptyText: 'Nothing needed' })));
      if (s.item) {
        const consume = h('input', { type: 'checkbox', checked: s.consume === true });
        consume.addEventListener('change', () => { s.consume = consume.checked; });
        extra.push(h('label', { class: 'toggle', style: 'align-self:end;padding-bottom:8px' }, consume, ' They keep it'));
      }
    }
    if (s.type === 'hostage') {
      // A new step comes with 30 s (right for a hack); 8 s at gunpoint suits this better. Only set once.
      if (!s.hostageSet) { if (s.time == null || s.time === 30 || s.time > 60) s.time = 8; s.hostageSet = true; }
      extra.push(h('label', { class: 'field' }, 'Keep them at gunpoint for (s)', num(s, 'time', 3, 60)));
    }
    if (s.type === 'guards' && s.spots && s.spots.length) {
      extra.push(h('div', { class: 'field', style: 'flex:1 1 100%' }, 'Where they stand',
        h('div', { class: 'row', style: 'align-items:center' },
          h('span', { text: `${s.spots.length} ${s.spots.length === 1 ? 'guard' : 'guards'} placed one by one, each facing the way you set.` }),
          h('button', { class: 'btn small', type: 'button', onclick: () => { s.spots = null; rerender(); } }, 'Spread them out randomly instead'))));
    }
    if (s.type === 'guards') {
      extra.push(s.spots && s.spots.length ? h('span', {}) : h('label', { class: 'field' }, 'How many', num(s, 'count', 1, 12, 70)),
        h('label', { class: 'field' }, 'Weapon', text(s, 'weapon', 160, npc.guardWeapon || 'weapon_pistol')),
        h('label', { class: 'field' }, 'Armour (0-100)', num(s, 'armour', 0, 100, 80)),
        h('label', { class: 'field' }, 'Accuracy (1-100)', num(s, 'accuracy', 1, 100, 80)),
        s.spots && s.spots.length ? h('span', {}) : h('label', { class: 'field' }, 'Spread out over (m)', num(s, 'radius', 2, 40, 80)));
    }
    if ((d.doors || []).length) {
      s.opens = s.opens || [];
      extra.push(h('div', { class: 'field', style: 'flex:1 1 100%' }, 'Opens these doors when done',
        h('div', { class: 'row', style: 'gap:14px' }, d.doors.map((door, di) => {
          const box = h('input', { type: 'checkbox', checked: s.opens.includes(di + 1) });
          box.addEventListener('change', () => {
            s.opens = box.checked ? [...new Set([...s.opens, di + 1])] : s.opens.filter((n) => n !== di + 1);
            rerender();
          });
          return h('label', { class: 'toggle' }, box, ` ${door.label || `Door ${di + 1}`}`);
        }))));
    }
    extra.push(h('label', { class: 'field' }, s.type === 'hostage' ? 'Alarm (if they comply)' : 'Alarm', pick(s, 'alert', ALERT_OPTIONS)));
    if (s.type !== 'truck' && s.type !== 'loot' && s.type !== 'wait' && s.type !== 'guards') extra.push(h('label', { class: 'field' }, 'ox_doorlock / qb-doorlock door (optional)', text(s, 'doorId', 160, 'its door ID or name')));

    return h('div', { class: 'heist-edit-step' },
      h('div', { class: 'heist-edit-head' },
        h('span', { class: 'step-no', text: String(i + 1) }),
        pick(s, 'type', typeOptions),
        text(s, 'label', 200, 'Label, e.g. Vault door'),
        h('span', { class: 'heist-pos' }, followsTruck(s) ? h('span', { class: 'muted', text: 'At the truck' }) : [
          h('span', { class: s.x != null ? 'fig' : 'debit', text: point(s) }),
          (s.type === 'talk' || s.type === 'hostage')
            ? h('button', { class: 'btn small primary', type: 'button', onclick: async () => {
              const pts = await placeInGame({ model: s.ped || (meta.npc || {}).ped });
              if (pts) { Object.assign(s, pts[0]); toast('Placed.'); rerender(); }
            } }, 'Place in game')
            : null,
          s.type === 'guards'
            ? h('button', { class: 'btn small primary', type: 'button', onclick: async () => {
              const pts = await placeInGame({ model: s.ped || (meta.npc || {}).guardPed, multi: true, max: 12 });
              if (pts) {
                s.spots = pts; s.count = pts.length;
                // The step's own position: the middle of the guards
                const c = pts.reduce((a, p) => ({ x: a.x + p.x / pts.length, y: a.y + p.y / pts.length, z: a.z + p.z / pts.length }), { x: 0, y: 0, z: 0 });
                Object.assign(s, c, { w: pts[0].w });
                toast(`${pts.length} ${pts.length === 1 ? 'guard' : 'guards'} placed.`); rerender();
              }
            } }, 'Place guards one by one')
            : null,
          h('button', { class: 'btn small', type: 'button', onclick: async () => { const p = await goToPicked(s.x != null ? s : d.start); if (p) { Object.assign(s, p); toast('You\'re there. Fine-tune it if you need to.'); rerender(); } } }, 'Pick on map'),
          h('button', { class: 'btn small', type: 'button', onclick: () => here((p) => Object.assign(s, p)) },
            { truck: 'Truck starts here', talk: 'Where I stand', hostage: 'Where I stand', guards: 'Spread around me' }[s.type] || 'Set here'),
          h('button', { class: 'btn small', type: 'button', onclick: () => goTo(s) }, 'Go to')]),
        h('span', { class: 'heist-step-tools' },
          h('button', { class: 'btn small', type: 'button', title: 'Move up', onclick: () => move(i, -1) }, '↑'),
          h('button', { class: 'btn small', type: 'button', title: 'Move down', onclick: () => move(i, 1) }, '↓'),
          h('button', { class: 'btn small danger', type: 'button', onclick: () => { d.steps.splice(i, 1); rerender(); } }, 'Remove'))),
      h('div', { class: 'heist-edit-extra' }, extra));
  });

  const addType = select(typeOptions, 'hack');
  const add = h('div', { class: 'row', style: 'align-items:center;margin-top:10px' },
    addType,
    h('button', {
      class: 'btn small', type: 'button',
      onclick: () => {
        const t = addType.value;
        const game = ((meta.stepTypes || []).find((x) => x.key === t) || {}).game;
        const step = { type: t, label: '', difficulty: 2, alert: 'none', time: game ? 30 : (t === 'wait' ? 60 : 15) };
        if (t === 'loot') step.loot = { kind: 'money', account: 'dirty', min: 1000, max: 2000 };
        d.steps.push(step);
        rerender();
      },
    }, 'Add step'));

  const save = async () => {
    const r = await adminRequest('heistSave', x.id, { label: x.label, kind: x.kind, enabled: x.enabled, ...d });
    if (!r.ok) return toast(r.error, true);
    admin.heist = r.data;
    toast(r.data.enabled ? 'Saved. It\'s live for gangs.' : 'Saved as a draft.');
    rerender();
  };

  return h('div', {},
    h('div', { class: 'section-head' },
      h('button', { class: 'btn small', type: 'button', onclick: () => { admin.heist = null; rerender(); } }, 'All heists'),
      h('div', { class: 'row' },
        x.running ? h('button', { class: 'btn small danger', type: 'button', onclick: () => confirmModal({ title: 'Stop this heist?', body: `${x.running} are on it now. It ends immediately.`, confirmLabel: 'Stop it', danger: true, onConfirm: async () => { await adminAct('heistStop', [x.id], 'Stopped.'); admin.heist = null; rerender(); } }) }, 'Stop the run') : null,
        x.cooldownLeft > 0 ? h('button', { class: 'btn small', type: 'button', onclick: async () => { if (await adminAct('heistReset', [x.id], 'Cooldown cleared.')) { x.cooldownLeft = 0; rerender(); } } }, 'Clear cooldown') : null,
        h('button', { class: 'btn small danger', type: 'button', onclick: () => confirmModal({ title: `Delete ${x.label}?`, body: 'It\'s gone for good, and any run in progress stops.', confirmLabel: 'Delete heist', danger: true, onConfirm: async () => { if (await adminAct('heistDelete', [x.id], 'Deleted.')) { admin.heist = null; rerender(); } } }) }, 'Delete'))),
    h('h3', { style: 'margin-top:6px', text: x.label || 'New heist' }),
    settings,
    startSection(d, meta, { here, goTo, point, rerender }),
    doorsSection(d, { goTo, rerender }),
    h('h3', { style: 'margin:22px 0 4px', text: 'Steps' }),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: 'Done in order. Loot steps next to each other can be grabbed at the same time by different crew. Place NPCs in game, or stand at each spot and press Set here.' }),
    steps.length ? h('div', { class: 'heist-edit-steps' }, steps) : h('p', { class: 'empty', text: 'No steps yet.' }),
    add,
    h('div', { class: 'heist-save' },
      h('label', { class: 'toggle' }, enabled, ' Live (gangs can see and start it)'),
      h('button', { class: 'btn primary', type: 'button', onclick: save }, 'Save')));
}

/* Contract spots -------------------------------------------------------- */

const SPOT_POOLS = [
  { key: 'general', label: 'Pickups and drop-offs', help: 'Courier runs, stolen-car drop-offs, supply van pickups, dead drops and lost shipments. Stand where the marker should be.' },
  { key: 'vehicles', label: 'Stolen-car spots', help: 'Where the car is parked for "Move a stolen car". Stand where the car should be, facing the way it should point.' },
  { key: 'debtors', label: 'Debtor spots', help: 'Where the debtor waits for "Collect a debt". Stand where he should stand, facing the way he should face.' },
];

async function renderAdminSpots() {
  const res = await adminRequest('contractSpots');
  if (!res.ok) return loadError(res);
  const { spots, minRoute } = res.data;
  admin.spotPool = admin.spotPool || 'general';
  const pool = SPOT_POOLS.find((p) => p.key === admin.spotPool);
  const list = spots[pool.key] || [];

  const tabs = h('div', { class: 'choices', role: 'radiogroup', style: 'margin-bottom:14px' }, SPOT_POOLS.map((p) => h('button', {
    type: 'button', role: 'radio', class: 'choice', 'aria-checked': String(p.key === pool.key),
    onclick: () => { admin.spotPool = p.key; renderAdminTab(); },
  }, `${p.label} (${(spots[p.key] || []).length})`)));

  const label = h('input', { type: 'text', maxlength: 64, placeholder: 'Name, e.g. Davis car wash', style: 'flex:1;min-width:220px', 'aria-label': 'Spot name' });
  const add = h('div', { class: 'house' },
    h('h3', { text: 'Add a spot where you\'re standing' }),
    h('p', { class: 'hint', style: 'margin:2px 0 12px', text: pool.help }),
    h('div', { class: 'row' }, label, h('button', {
      class: 'btn primary', type: 'button',
      onclick: async () => {
        if (await adminAct('addContractSpot', [pool.key, label.value.trim()], 'Spot added. New jobs can use it straight away.')) label.value = '';
      },
    }, 'Add spot here')));

  const rows = list.map((sp) => h('tr', {},
    h('td', {}, h('strong', { text: sp.label }), h('div', { class: 'hint', style: 'margin:0', text: `${sp.area ? `${sp.area}. ` : ''}${sp.added ? 'Added in game' : 'Built in (config/contracts.lua)'}` })),
    h('td', { class: 'muted fig', text: `${Math.round(sp.x)}, ${Math.round(sp.y)}` }),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoContractSpot', [pool.key, sp.index]) }, 'Go to'),
      sp.added ? h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Delete ${sp.label}?`, body: 'New jobs stop using it. Jobs already running there carry on.',
          confirmLabel: 'Delete spot', danger: true, onConfirm: () => adminAct('deleteContractSpot', [pool.key, sp.id], 'Spot deleted.'),
        }),
      }, 'Delete') : null)));

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', { text: 'Contract spots' })),
    h('p', { class: 'hint', style: 'margin-bottom:14px', text: `Places jobs send gangs to. Pickups and drop-offs are paired at least ${minRoute}m apart, so spread them around the map.` }),
    tabs, add,
    h('table', {}, h('tbody', {}, rows)));
}

/* Businesses ------------------------------------------------------------ */

async function renderAdminEnterprises() {
  const res = await adminRequest('enterprises');
  if (!res.ok) return loadError(res);
  const rows = res.data.map((e) => h('tr', {},
    h('td', {}, h('strong', { text: e.label }), h('div', { class: 'hint', style: 'margin:0', text: `At ${e.safehouse}` })),
    h('td', {}, swatchLabel(e.colour, e.gang)),
    h('td', { class: 'num fig', text: `${e.stock}/${e.maxProduct}` }),
    h('td', { class: 'num fig', text: `${e.rate}/hr` }),
    h('td', { text: e.distribute ? 'On the street' : '' }),
    h('td', { class: 'actions' }, h('button', {
      class: 'btn small danger', type: 'button',
      onclick: () => confirmModal({
        title: `Shut down this ${e.label.toLowerCase()}?`, body: `${e.gang} lose all stock and supplies. They're told staff shut it down.`,
        confirmLabel: 'Shut down', danger: true, onConfirm: () => adminAct('closeEnterprise', [e.id], 'Shut down.'),
      }),
    }, 'Shut down'))));
  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Businesses ', h('span', { class: 'muted fig', text: res.data.length }))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Gangs set these up inside their safehouses. Types, rates and prices are in config/enterprises.lua.' }),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Business' }), h('th', { text: 'Gang' }), h('th', { class: 'num', text: 'Stock' }), h('th', { class: 'num', text: 'Output' }), h('th', {}), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No gang businesses running.' }));
}

/* Safehouses ------------------------------------------------------------ */

async function renderAdminSafehouses() {
  const res = await adminRequest('safehouses');
  if (!res.ok) return loadError(res);
  const rows = res.data.map((x) => h('tr', {},
    h('td', {}, h('strong', { text: x.label }), h('div', { class: 'hint', style: 'margin:0', text: x.shell ? `${x.address}  ·  Shell: ${x.shell}` : x.address })),
    h('td', {}, x.gang ? swatchLabel(x.colour, x.gang) : h('span', { class: 'muted', text: 'For sale' }),
      x.breached ? h('div', { class: 'hint debit', style: 'margin:0', text: 'Breached by police' }) : null,
      x.gang && x.paidFor < 0 ? h('div', { class: 'hint debit', style: 'margin:0', text: 'Upkeep overdue' }) : null),
    h('td', { class: 'num fig', text: money(x.price) }),
    h('td', { class: 'num fig', text: money(x.upkeep) }),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoSafehouse', [x.id]) }, 'Go to'),
      x.gang ? h('button', {
        class: 'btn small', type: 'button',
        onclick: () => confirmModal({
          title: `Evict ${x.gang}?`, body: `${x.label} goes back on the market. ${x.gang} lose access to the stash.`,
          confirmLabel: 'Evict', danger: true, onConfirm: () => adminAct('evictSafehouse', [x.id], 'Gang evicted.'),
        }),
      }, 'Evict') : null,
      h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Delete ${x.label}?`, body: 'Removes the safehouse completely. Anyone inside is put outside.',
          confirmLabel: 'Delete', danger: true, onConfirm: () => adminAct('deleteSafehouse', [x.id], 'Safehouse deleted.'),
        }),
      }, 'Delete'))));

  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', {}, 'Safehouses ', h('span', { class: 'muted fig', text: res.data.length })),
      h('button', { class: 'btn primary', type: 'button', onclick: chooseSafehouseKind }, 'Set up a safehouse')),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Use an MLO the gang walks into through its own locked doors, any building entered by teleporting into a private copy, or a shell from a shell pack (spawned only while someone is inside).' }),
    rows.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Safehouse' }), h('th', { text: 'Owner' }), h('th', { class: 'num', text: 'Price' }), h('th', { class: 'num', text: 'Upkeep/day' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No safehouses yet.' }));
}

/* Setting up a safehouse: an interior on the map, or a shell */
async function chooseSafehouseKind() {
  const res = await adminRequest('safehouseShells');
  const shells = res.ok ? res.data : [];
  const start = (shell, mode) => { hideModal(); $('device').hidden = true; postNui('setupSafehouse', shell ? { shell } : (mode ? { mode } : {})); };
  const pick = shells.length ? select(shells.map((x) => ({ value: x.model, label: `${x.label} (${x.model})` }))) : null;
  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: 'Set up a safehouse' }),
    h('div', { class: 'template-grid' },
      h('button', { class: 'template', type: 'button', onclick: () => start(null, 'walkin') },
        h('strong', { text: 'An MLO you walk into' }),
        h('span', { class: 'hint', style: 'margin:0', text: 'The gang walks in through the building\'s real doors, which the script locks; members lock and unlock them at any door. Stand outside the front door (where police breach), then at the stash, then aim at each door and press E.' })),
      h('button', { class: 'template', type: 'button', onclick: () => start(null) },
        h('strong', { text: 'An interior on the map, teleport in' }),
        h('span', { class: 'hint', style: 'margin:0', text: 'Any building already in the world, entered by pressing E at the door (its own private copy, so several safehouses can share one interior). Stand at the outside door, then the spawn, the stash and the inside door.' })),
      h('div', { class: 'template', style: 'cursor:default' },
        h('strong', { text: 'A shell' }),
        h('span', { class: 'hint', style: 'margin:0', text: 'A shell prop, spawned only while someone\'s inside. Mark the outside door, then you\'re put inside a private copy of the shell to mark the spawn, stash and inside door.' }),
        pick ? h('div', { class: 'shell-pick' }, pick,
          h('button', { class: 'btn primary small', type: 'button', onclick: () => start(pick.value) }, 'Use this shell'))
          : h('span', { class: 'hint debit', style: 'margin:6px 0 0', text: 'No shells listed. Add your shell models to config/safehouses.lua > shells.' }))),
    h('p', { class: 'hint', text: 'Backspace cancels at any point. The shell must be streamed by a shell pack on your server.' }),
    h('div', { class: 'buttons' }, h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel')));
}

/* Rackets --------------------------------------------------------------- */

async function renderAdminRackets() {
  const res = await adminRequest('rackets');
  if (!res.ok) return loadError(res);
  const shops = res.data;

  const rows = shops.map((b) => h('tr', {},
    h('td', {}, h('strong', { text: b.label }),
      h('div', { class: b.area ? 'hint' : 'hint debit', style: 'margin:0', text: `${b.area || 'Not inside any area, so gangs can\'t work it'}${b.added ? '. Added in game' : ''}` })),
    h('td', {}, b.gang ? swatchLabel(b.colour, b.gang) : h('span', { class: 'muted', text: 'Nobody' })),
    h('td', { class: 'num fig', text: money(b.income) }),
    h('td', { class: 'num fig', text: b.gang ? money(b.owed) : '' }),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoRacketShop', [b.key]) }, 'Go to'),
      b.gang ? h('button', {
        class: 'btn small', type: 'button',
        onclick: () => confirmModal({
          title: `Release ${b.label}?`,
          body: `${b.gang} lose this business and anything it owes. They're told staff released it.`,
          confirmLabel: 'Release', danger: true,
          onConfirm: () => adminAct('releaseRacket', [b.key], 'Business released.'),
        }),
      }, 'Release') : null,
      b.added ? h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Delete ${b.label}?`,
          body: b.gang ? `It's removed for good, and ${b.gang} lose it along with anything it owes.` : 'It\'s removed for good.',
          confirmLabel: 'Delete shop', danger: true,
          onConfirm: () => adminAct('deleteRacketShop', [b.key], 'Shop deleted.'),
        }),
      }, 'Delete') : null)));

  // Add a shop at the counter you're standing at
  const name = h('input', { type: 'text', maxlength: 64, placeholder: 'Name, e.g. Bean Machine, Vinewood', style: 'flex:1;min-width:220px', 'aria-label': 'Shop name' });
  const rate = h('input', { type: 'number', min: 50, max: 5000, step: 50, value: 350, style: 'width:110px', 'aria-label': 'Hourly rate' });
  const add = h('div', { class: 'house' },
    h('h3', { text: 'Add a shop where you\'re standing' }),
    h('p', { class: 'hint', style: 'margin:2px 0 12px', text: 'Stand at the counter, where a gang member would talk to the owner. The shop needs to be inside an area for gangs to work it. The rate is what it adds to what it owes each hour.' }),
    h('div', { class: 'row', style: 'align-items:end' },
      h('label', { class: 'field', style: 'flex:1;min-width:220px' }, 'Shop name', name),
      h('label', { class: 'field' }, 'Rate per hour', rate),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: async () => {
          const r = await adminRequest('addRacketShop', name.value.trim(), Number(rate.value));
          if (!r.ok) return toast(r.error, true);
          name.value = '';
          toast(typeof r.data === 'string'
            ? `Shop added in ${r.data}. Gangs can talk business there straight away.`
            : 'Shop added, but it\'s outside every area, so gangs can\'t work it until you draw one around it.');
          renderAdminTab();
        },
      }, 'Add shop here')));

  const unworkable = shops.filter((b) => !b.area).length;
  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Rackets ', h('span', { class: 'muted fig', text: shops.length }))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: unworkable
      ? `${unworkable} of these shops sit outside every area, so gangs can't work them until you draw an area around them.`
      : 'Every shop sits inside an area.' }),
    add,
    h('table', {},
      h('thead', {}, h('tr', {}, h('th', { text: 'Business' }), h('th', { text: 'Protected by' }), h('th', { class: 'num', text: 'Rate' }), h('th', { class: 'num', text: 'Waiting' }), h('th', {}))),
      h('tbody', {}, rows)));
}

/* Tag reviews ----------------------------------------------------------- */

async function renderReviews() {
  const [res, logos] = await Promise.all([adminRequest('pendingDesigns'), adminRequest('pendingLogos')]);
  if (!res.ok) return loadError(res);
  const logoItems = (logos.ok ? logos.data : []).map((l) => h('div', { class: 'logo-review' },
    h('img', { class: 'logo-preview', src: l.url, alt: `${l.label} logo`, onerror: (e) => { e.target.replaceWith(h('div', { class: 'logo-preview hint', style: 'display:grid;place-items:center;text-align:center', text: 'Won\'t load' })); } }),
    h('div', {},
      h('h3', {}, swatchLabel(l.colour, l.label)),
      h('p', { class: 'url', text: l.url })),
    h('div', { class: 'design-actions' },
      h('button', { class: 'btn primary', type: 'button', onclick: () => adminAct('reviewLogo', [l.gangId, true], 'Logo approved.') }, 'Approve'),
      h('button', { class: 'btn danger', type: 'button', onclick: () => adminAct('reviewLogo', [l.gangId, false], 'Logo rejected.') }, 'Reject'))));

  const items = res.data.map((d) => h('div', { class: 'design' },
    h('div', { class: 'wall' }, tagCanvas(d.spec, 220)),
    h('div', {},
      h('h3', { text: d.name }),
      h('p', {}, swatchLabel(d.colour, d.gang)),
      d.spec.kind === 'image'
        ? h('p', { class: 'hint url', text: `Picture: ${d.spec.url}` })
        : h('p', { class: 'hint', text: `Reads: "${d.spec.text}"` })),
    h('div', { class: 'design-actions' },
      h('button', { class: 'btn primary', type: 'button', onclick: () => adminAct('reviewDesign', [d.id, true], 'Design approved.') }, 'Approve'),
      h('button', { class: 'btn danger', type: 'button', onclick: () => adminAct('reviewDesign', [d.id, false], 'Design rejected.') }, 'Reject'))));

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Logos ', h('span', { class: 'muted fig', text: logoItems.length }))),
    logoItems.length ? h('div', { style: 'margin-bottom:30px' }, logoItems)
      : h('p', { class: 'empty', style: 'margin-bottom:30px', text: 'No logos waiting. Gang bosses submit a logo link from Settings in their tablet, or the "Add logo" button at the top of it.' }),
    h('div', { class: 'section-head' }, h('h2', {}, 'Tag designs ', h('span', { class: 'muted fig', text: res.data.length }))),
    items.length ? h('div', { class: 'designs' }, items)
      : h('p', { class: 'empty', text: 'Nothing waiting. New designs from gangs show up here before they can be sprayed.' }));
}

/* Tags in world --------------------------------------------------------- */

async function renderWorldTags() {
  const res = await adminRequest('listTags');
  if (!res.ok) return loadError(res);
  const statusText = { active: 'Up', crossed: 'Crossed out' };

  const rows = res.data.map((t) => h('tr', {},
    h('td', {}, t.design ? tagCanvas(t.design, 110) : null),
    h('td', {}, swatchLabel(t.colour, t.gang)),
    h('td', { text: t.zone }),
    h('td', { class: t.status === 'crossed' ? 'debit' : '', text: statusText[t.status] || t.status }),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', onclick: () => adminAct('gotoTag', [t.id]) }, 'Go to'),
      h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: 'Remove this tag?',
          body: `Takes it off the wall for everyone. ${t.gang} keep any influence it already earned.`,
          confirmLabel: 'Remove tag',
          danger: true,
          onConfirm: () => adminAct('removeTag', [t.id], 'Tag removed.'),
        }),
      }, 'Remove'))));

  return h('div', {},
    h('div', { class: 'section-head' }, h('h2', {}, 'Tags in world ', h('span', { class: 'muted fig', text: res.data.length }))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Newest first. Go to puts you in front of the wall so you can see it.' }),
    rows.length
      ? h('table', { class: 'tags-table' },
        h('thead', {}, h('tr', {}, h('th', { text: 'Tag' }), h('th', { text: 'Gang' }), h('th', { text: 'Area' }), h('th', { text: 'Status' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No tags on any walls yet.' }));
}

/* Messages -------------------------------------------------------------- */

window.addEventListener('message', (event) => {
  const msg = event.data || {};
  if (msg.action !== 'openAdmin') return;
  state.mode = 'admin';
  state.static = msg.static;
  admin.tab = 'home';
  admin.gangId = null;
  const device = $('device');
  device.hidden = false;
  device.classList.remove('opening');
  void device.offsetWidth;
  device.classList.add('opening');
  renderAdminFrame();
});

/* Browser preview: open index.html?admin */

const AdminMock = {
  request(action, args = []) {
    const ok = (data) => Promise.resolve({ ok: true, data: data === undefined ? true : data });
    const spec = { text: 'GROVE KINGS', font: 'handstyle', style: 'outline', fill: '#7B3FBF', outline: '#111418' };
    switch (action) {
      case 'listGangs': return ok([
        { id: 1, name: 'grovekings', label: 'Grove Kings', colour: '#7B3FBF', members: 6, zones: 2, heat: 34.5 },
        { id: 2, name: 'vagos', label: 'Los Vagos', colour: '#E8C31E', members: 9, zones: 1, heat: 61.2 },
      ]);
      case 'gangDetail': return ok({ maxMembers: 25,
        gang: { id: 1, name: 'grovekings', label: 'Grove Kings', colour: '#7B3FBF', heat: 34.5, tier: 2, tierLabel: 'Firm', captureThreshold: 100,
          influence: [{ key: 'davis', label: 'Davis', amount: 164.2, owned: true }, { key: 'strawberry', label: 'Strawberry', amount: 38.5, owned: false }],
          otherZones: [{ key: 'rancho', label: 'Rancho' }, { key: 'paleto', label: 'Palato Bay' }], reputation: 140, zoneNames: ['Davis', 'Rancho'], clean: 48250, dirty: 12900 },
        members: [{ citizenid: 'A1', name: 'Marcus Doyle', grade: 4, online: true }, { citizenid: 'B2', name: 'Kez Williams', grade: 3, online: false }],
        ranks: [{ grade: 4, label: 'Boss' }, { grade: 3, label: 'Underboss' }, { grade: 0, label: 'Associate' }] });
      case 'auctions': return ok({ nextIn: 74, hasItems: false, lots: [{ id: 5, title: '220 grow supplies', status: 'open', topBid: 5200, bids: 3, gang: 'Los Vagos', colour: '#E8C31E', secondsLeft: 610 }] });
      case 'informants': return ok([{ citizenid: 'C3', code: 'CHIS-4F2A', name: 'Danny Price', gang: 'Grove Kings', tips: 6, earned: 13500, active: true }]);
      case 'director': return ok({ enabled: true, nextIn: 23, kinds: ['boom', 'crackdown', 'crash', 'crew', 'drop', 'hotwork', 'shortage', 'undercover'],
        events: [{ id: 3, kind: 'undercover', public: 'Word is the police have someone on the inside of one of the gangs.', gang: 'Los Vagos', minutesLeft: 88 },
          { id: 4, kind: 'crew', public: 'An outside crew has moved into Rancho.', zone: 'Rancho', strength: 39, minutesLeft: 64 }] });
      case 'agreements': return ok([{ id: 4, label: 'Trade agreement', status: 'active', a: 'Grove Kings', aColour: '#7B3FBF', b: 'East Side', bColour: '#3FA7D6', payment: 0, secondsLeft: 300000 }]);
      case 'heists': return ok({ defaultTier: 3, tools: { thermite: { item: 'thermite', label: 'Thermite', consume: true }, truck_doors: { item: 'thermite', label: 'Thermite', consume: true } }, tiers: ['Street crew', 'Firm', 'Organisation', 'Syndicate'],
        templates: [{ key: 'bank', label: 'Bank vault', steps: 5 }, { key: 'truck', label: 'Armoured truck', steps: 3 }, { key: 'store', label: 'Store robbery', steps: 3 }, { key: 'jewellery', label: 'Jewellery store', steps: 5 }, { key: 'custom', label: 'Custom heist', steps: 0 }],
        stepTypes: [{ key: 'hack', label: 'Hack a panel', game: 'hack' }, { key: 'thermite', label: 'Thermite a door', game: 'thermite' }, { key: 'drill', label: 'Drill (vault or boxes)', game: 'drill' }, { key: 'loot', label: 'Grab loot' }, { key: 'wait', label: 'Wait (time lock)' }, { key: 'truck', label: 'Armoured truck: stop it' }, { key: 'truck_doors', label: 'Armoured truck: open the back', game: 'thermite' },
          { key: 'talk', label: 'Talk to someone (NPC)' }, { key: 'guards', label: 'Deal with guards (NPCs)' }, { key: 'hostage', label: 'Intimidate someone (NPC)' }],
        npc: { ped: 'a_m_m_business_01', guardPed: 's_m_m_security_01', guardWeapon: 'weapon_pistol' },
        peds: [{ category: 'Bank & business', peds: [{ model: 'ig_bankman', label: 'Bank manager' }, { model: 'a_m_m_business_01', label: 'Businessman' }, { model: 'a_m_y_business_02', label: 'Businessman (open collar)' }, { model: 'a_f_y_business_01', label: 'Businesswoman' }] },
          { category: 'Security & guards', peds: [{ model: 's_m_m_security_01', label: 'Security guard' }, { model: 's_m_m_armoured_01', label: 'Armoured truck guard' }, { model: 'mp_m_securoguard_01', label: 'Gruppe Sechs guard' }, { model: 's_m_m_highsec_01', label: 'High-security guard' }] },
          { category: 'Criminals', peds: [{ model: 'g_m_m_armboss_01', label: 'Armenian boss' }, { model: 'g_m_m_chiboss_01', label: 'Triad boss' }, { model: 'g_m_y_lost_01', label: 'Biker' }] }],
        lootTypes: [{ key: 'cash', label: 'Cash (to dirty treasury)' }, { key: 'goldbar', label: 'Gold bars (item)' }, { key: 'jewels', label: 'Jewellery (item)' }],
        heists: [{ id: 4, label: 'Fleeca, Great Ocean', kind: 'bank', enabled: true, cooldownLeft: 0, running: 'Grove Kings',
          data: { police: 4, crew: 3, cooldown: 120, timeLimit: 20, tier: 3, start: { x: -2957, y: 481, z: 15, w: 0 }, steps: [
            { type: 'hack', label: 'Security panel', difficulty: 2, time: 30, alert: 'silent', x: -2956, y: 483, z: 15 },
            { type: 'thermite', label: 'Inner gate', difficulty: 2, time: 25, alert: 'loud', doorId: 'fleeca_gate' },
            { type: 'drill', label: 'Vault door', difficulty: 3, time: 45, alert: 'none' },
            { type: 'loot', label: 'Cash trolley', time: 20, alert: 'none', loot: { kind: 'money', account: 'dirty', min: 15000, max: 25000 } }] } },
          { id: 6, label: 'Gruppe armoured truck', kind: 'truck', enabled: false, cooldownLeft: 1880, data: { police: 3, crew: 3, cooldown: 90, timeLimit: 15, steps: [{ type: 'truck', label: 'Stop the truck' }, { type: 'truck_doors', label: 'Rear doors' }, { type: 'loot', label: 'Cash bags', loot: { kind: 'money', account: 'dirty', min: 12000, max: 20000 } }] } }] });
      case 'safehouseShells': return ok([{ model: 'shell_v16low', label: 'Low-end apartment' }, { model: 'shell_trevor', label: 'Trevor\'s trailer' }, { model: 'shell_warehouse1', label: 'Warehouse' }]);
      case 'hexGang': return ok({ startHexes: 2, hexes: [{ key: 'h:4:-7', label: 'Davis (4, -7)', control: 100, main: true, compound: true }, { key: 'h:5:-7', label: 'Rancho (5, -7)', control: 62, compound: true }, { key: 'h:3:-6', label: 'Davis (3, -6)', control: 18 }] });
      case 'hexGive': return ok(args[1] != null ? `Hex (${args[1]}, ${args[2]})` : 'Davis (4, -8)');
      case 'hexMap': return ok([{ key: 'h:4:-7', q: 4, r: -7, gangId: 1, gang: 'Grove Kings', colour: '#7B3FBF', label: 'Davis (4, -7)', control: 100, main: true },
        { key: 'h:5:-7', q: 5, r: -7, gangId: 1, gang: 'Grove Kings', colour: '#7B3FBF', label: 'Rancho (5, -7)', control: 62 },
        { key: 'h:6:-8', q: 6, r: -8, gangId: 2, gang: 'Los Vagos', colour: '#E8C31E', label: 'Rancho (6, -8)', control: 40 }]);
      case 'hexResize': return ok({ from: 150, to: args[0], before: 3, after: args[1] === 'fill' ? 25 : 3 });
      case 'hexSettings': return ok({ size: 150, configSize: 150, onResize: 'centre', mapEnabled: true, mapMinimap: false, mapShowTo: 'gangs', turfDrugs: ['weed_og_kush'], turfDrugItems: [{ name: 'kq_weed_bag_og_kush', label: 'Weed baggie (OG Kush)', exists: true, sellable: true, perUnit: 0.5 }], controlPerSale: 1.5, rivalLoss: 2, decayPerHour: 4, startControl: 10, expandAt: 100, sprayEvery: 3,
        expandCost: { money: 50000, account: 'dirty', item: 'weed_og_kush', count: 50 }, expandItemLabel: 'OG Kush' });
      case 'customContracts': return ok({ types: [{ key: 'collect', label: 'Collect a debt' }, { key: 'courier', label: 'Courier run' }, { key: 'transport', label: 'Move a stolen car' }],
        difficulty: ['Low risk', 'Medium risk', 'High risk'], tiers: ['Street crew', 'Firm', 'Organisation', 'Syndicate'], gangs: [{ id: 1, label: 'Grove Kings' }, { id: 2, label: 'Los Vagos' }],
        contacts: [{ key: 'mags', label: 'Mags' }, { key: 'ray', label: 'Ray the Fence' }, { key: 'dutchy', label: 'Dutchy' }],
        jobs: [{ id: 1, title: 'The Accountant\'s ledger', contact: 'The Accountant', type: 'courier', difficulty: 2, timeLimit: 15, money: 8000, account: 'dirty', items: [{ item: 'goldbar', label: 'Gold bar', count: 2 }], reputation: 10, chance: 20, once: false, enabled: true, minTier: 2 },
          { id: 2, title: 'Christmas Eve run', contact: 'Santa', type: 'transport', difficulty: 3, timeLimit: 20, money: 0, account: 'dirty', items: [{ item: 'weapon_pistol', label: 'Pistol', count: 1 }], reputation: 25, chance: 0, once: true, done: 1, enabled: false, gangId: 1, gangLabel: 'Grove Kings', minTier: 1 }] });
      case 'customContractSave': return ok(3);
      case 'contractSettings': return ok({ offersPerGang: 4, offerMinutes: 45, refreshMinutes: 5, minRouteDistance: 700, policeAlertChance: 0.35, templateKeys: ['collect', 'courier', 'transport'],
        difficulty: [{ label: 'Low risk', reward: 1, trust: 5, reputation: 2, failTrust: -3 }, { label: 'Medium risk', reward: 1.6, trust: 8, reputation: 4, failTrust: -6 }, { label: 'High risk', reward: 2.4, trust: 12, reputation: 7, failTrust: -10 }],
        tiers: [0, 40, 120],
        templates: { courier: { title: 'Courier run', reward: 2500, account: 'dirty', timeLimit: 900 }, transport: { title: 'Move a stolen car', reward: 4000, account: 'dirty', timeLimit: 1200, vehicles: ['sultan', 'felon', 'baller'] }, collect: { title: 'Collect a debt', reward: 3000, account: 'dirty', timeLimit: 900, peds: ['a_m_m_business_01'], payChance: 0.55, fightChance: 0.35 } },
        contacts: [{ key: 'mags', label: 'Mags', templates: ['courier', 'collect'] }, { key: 'ray', label: 'Ray the Fence', templates: ['transport', 'courier'] }] });
      case 'contractSettingsSave': return ok(args[0]);
      case 'blackmarketSettings': return ok({ enabled: true, intervalMinutes: [90, 180], biddingMinutes: 15, lotsPerAuction: [2, 3], minPlayers: 2, increment: 0.05, antiSnipe: 60, buyNowMultiplier: 2.5,
        dropMinutes: 30, headStart: 120, tipChance: 0.35, unclaimedRefund: 0.5,
        lots: { supplies: { weight: 3, amount: [150, 300], reservePerUnit: 0.6 }, contract: { weight: 2, rewardMultiplier: 2.5, reserve: [6000, 12000] }, copper: { weight: 2, heat: 40, reserve: [15000, 30000] }, connections: { weight: 2, influence: 15, reserve: [10000, 25000] }, items: { weight: 3 } },
        items: [{ item: 'weapon_pistol50', itemLabel: 'Desert Eagle', label: 'Desert Eagle', count: 1, reserve: 20000 }] });
      case 'blackmarketSave': return ok(args[0]);
      case 'blackmarketOpen': return ok(true);
      case 'airdrops': return ok([{ id: 3, gang: 'Grove Kings', state: 'called', x: 1712, y: 3290, arrivesIn: 184 }]);
      case 'airdropAdminCall': return ok(true);
      case 'airdropSchedules': return ok({ serverTime: '16:00', serverNow: 0, schedules: [
        { id: 1, name: 'Evening drops', enabled: true, kind: 'daily', times: ['18:00', '22:00'], spots: [{ x: 1700, y: 3300 }, { x: -500, y: 300 }], who: { kind: 'all' }, delay: 2, minPlayers: 6, nextIn: 7200 },
        { id: 2, name: 'Sandy regulars', enabled: false, kind: 'every', minutes: 180, spots: [{ x: 1700, y: 3300 }], who: { kind: 'everyone' }, delay: 1, minPlayers: 0 }] });
      case 'airdropScheduleSave': return ok(true);
      case 'airdropLoot': return ok({ fromConfig: false, tables: [
        { id: 1, name: 'Standard', rolls: 4, loot: [{ money: true, min: 5000, max: 15000, chance: 40 }, { item: 'weapon_pistol', label: 'Pistol', min: 1, max: 1, chance: 15 }, { item: 'armour', label: 'Body armour', min: 1, max: 2, chance: 20 }, { item: 'goldbar', label: 'Gold bar', min: 1, max: 3, chance: 10 }] },
        { id: 2, name: 'Weapons crate', rolls: 2, loot: [{ item: 'weapon_carbinerifle', label: 'Carbine rifle', min: 1, max: 1, chance: 10 }, { item: 'weapon_pistol', label: 'Pistol', min: 1, max: 2, chance: 30 }] }] });
      case 'airdropLootSave': return ok(args[0]);
      case 'gangCreation': return ok({ allow: true, cost: 50000, account: 'bank', fromConfig: true });
      case 'gangCreationSave': return ok(args[0]);
      case 'staffAccess': return ok({ users: [{ license: 'license:2b6f…91', role: 'staff', name: 'Moderator Dave' }, { license: 'license:9ac1…07', role: 'management', name: 'Kerry' }],
        groups: [['view', 'See everything (lists, details)', true], ['teleport', 'Teleport to places (Go to buttons)', true], ['reviews', 'Approve or turn down logos and tag designs', true], ['tags', 'Remove tags from walls', true], ['gangs', 'Create and disband gangs, manage members, ranks and tiers', false], ['economy', 'Change reputation and influence, run influence ticks', false], ['world', 'Build in the world: areas, safehouses, shops, contract spots, heists', false], ['events', 'Run street events, auctions and air drops; cancel deals', false], ['informants', 'See informants (sensitive)', false], ['settings', 'Change settings such as what can be sold on the street', false]].map(([key, label, on]) => ({ key, label, on })) });
      case 'searchItems': {
        const all = [['goldbar', 'Gold bar'], ['rolex', 'Rolex watch'], ['diamond', 'Diamond'], ['markedbills', 'Marked bills'], ['thermite', 'Thermite'],
          ['laptop_hack', 'Hacking laptop'], ['weed_bag', 'Bag of weed'], ['coke_bag', 'Bag of cocaine'], ['meth_bag', 'Bag of meth'], ['lockpick', 'Lockpick'], ['gold_chain', 'Gold chain']];
        const q = String(args[0] || '').toLowerCase();
        return ok(all.filter(([n, l]) => !q || n.includes(q) || l.toLowerCase().includes(q)).map(([name, label]) => ({ name, label, image: `images/${name}.png` })));
      }
      case 'drugItems': return ok({ fromConfig: true, businesses: [{ key: 'coke', label: 'Cocaine lab' }, { key: 'weed', label: 'Weed grow' }],
        items: [{ item: 'weed_bag', itemLabel: 'Bag of weed', label: 'weed', min: 90, max: 140, maxPer: 3, enterprise: 'weed', image: 'images/weed_bag.png' },
          { item: 'coke_bag', itemLabel: 'Bag of cocaine', label: 'cocaine', min: 240, max: 340, maxPer: 2, enterprise: 'coke', image: 'images/coke_bag.png' }] });
      case 'drugItemsSave': return ok({ fromConfig: false, businesses: [], items: args[0] });
      case 'heistHere': return ok({ x: -2958.4, y: 482.1, z: 15.7, w: 88.2 });
      case 'heistSave': return ok({ ...args[1], id: args[0], data: args[1], cooldownLeft: 0 });
      case 'contractSpots': return ok({ minRoute: 700, spots: {
        general: [{ index: 1, label: 'Elysian Island docks', added: false, area: null, x: 180.5, y: -3090.2 }, { index: 25, id: 3, label: 'Davis car wash', added: true, area: 'Davis', x: -120, y: -1700 }],
        vehicles: [{ index: 1, label: 'Legion Square car park', added: false, x: 215.5, y: -810.2 }], debtors: [] } });
      case 'enterprises': return ok([{ id: 1, label: 'Weed grow', safehouse: 'The Lock-up', gang: 'Grove Kings', colour: '#7B3FBF', stock: 520, maxProduct: 600, rate: 45, distribute: true }]);
      case 'safehouses': return ok([
        { id: 1, label: 'The Lock-up', address: '14 Forum Drive', price: 75000, upkeep: 1500, gang: 'Grove Kings', colour: '#7B3FBF', paidFor: -4000, breached: true },
        { id: 2, label: 'Flat above the bookies', address: '3 Grove Street', price: 60000, upkeep: 1200, gang: null, shell: 'Low-end apartment' },
      ]);
      case 'rackets': return ok([
        { key: 'ltd_grove', label: 'LTD Gasoline, Grove Street', area: 'Davis', income: 450, gang: 'Grove Kings', colour: '#7B3FBF', owed: 1350 },
        { key: '247_sandy', label: '24/7, Sandy Shores', area: null, income: 300, gang: null, owed: 0 },
        { key: 'shop_bean_machine', label: 'Bean Machine, Vinewood', area: 'Vinewood', income: 350, gang: null, owed: 0, added: true },
      ]);
      case 'pendingLogos': return ok([{ gangId: 1, label: 'Grove Kings', colour: '#7B3FBF', url: 'https://i.imgur.com/example.png' }]);
      case 'pendingDesigns': return ok([{ id: 4, name: 'Vagos throw', gang: 'Los Vagos', colour: '#E8C31E', spec: { text: 'LSV', font: 'block', style: 'shadow', fill: '#E8C31E', outline: '#1C2127' } }]);
      case 'listTags': return ok([{ id: 9, gang: 'Grove Kings', colour: '#7B3FBF', zone: 'Davis', status: 'active', design: spec }, { id: 8, gang: 'Grove Kings', colour: '#7B3FBF', zone: 'Rancho', status: 'crossed', design: spec }]);
      case 'onlinePlayers': return ok([{ id: 3, name: 'Jo Bloggs' }, { id: 7, name: 'Kez Williams', gang: 'Grove Kings' }]);
      default: return ok();
    }
  },
};

if (!IN_GAME && location.search.includes('admin')) {
  window.postMessage({ action: 'openAdmin', static: { currency: '£', nameMax: 24, hexMode: true, hexSize: 150, hexOrigin: { x: 0, y: 0 }, hexDistricts: [['Davis', 100, -1700], ['Strawberry', -150, -1400], ['Chamberlain Hills', -170, -1640], ['Rancho', 430, -1800], ['La Mesa', 800, -1100]], tabletMap: { image: 'images/map.jpg', size: 2048, scaleX: 0.16576, offsetX: 938.4, scaleY: -0.164, offsetY: 1382.4 }, zones: [], permissions: [], fonts: [],
    tiers: [{ label: 'Street crew', unlocks: [] }, { label: 'Firm', unlocks: [] }, { label: 'Organisation', unlocks: [] }, { label: 'Syndicate', unlocks: [] }] } }, '*');
}
