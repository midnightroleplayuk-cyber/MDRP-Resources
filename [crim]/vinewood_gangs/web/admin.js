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
  { id: 'areas', label: 'Areas', icon: 'territory', tint: '#5FB4E8', show: () => !state.static.hexMode },
  { id: 'turf', label: 'Turf', icon: 'territory', tint: '#5FB4E8', show: () => !!state.static.hexMode },
  { id: 'rackets', label: 'Rackets', icon: 'rackets', tint: '#E2BE5A' },
  { id: 'safehouses', label: 'Safehouses', icon: 'safehouses', tint: '#E88686' },
  { id: 'enterprises', label: 'Businesses', icon: 'business', tint: '#6FD0C0' },
  { id: 'spots', label: 'Contract spots', icon: 'pin', tint: '#B793F0' },
  { id: 'heists', label: 'Heists', icon: 'vault', tint: '#E88686' },
  { id: 'drugs', label: 'Street dealing', icon: 'pill', tint: '#6CC070' },
  { id: 'diplomacy', label: 'Diplomacy', icon: 'diplomacy', tint: '#8FB3FF' },
  { id: 'director', label: 'Street events', icon: 'bolt', tint: '#F0AD4E' },
  { id: 'informants', label: 'Informants', icon: 'phone', tint: '#A6AEB9' },
  { id: 'auctions', label: 'Auctions', icon: 'market', tint: '#D592D2' },
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
    showHome(visibleAdminApps().map((t) => appIcon(t, () => { admin.tab = t.id; admin.gangId = null; admin.heist = null; admin.drugDraft = null; admin.turfDraft = null; renderAdminFrame(); })));
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
  else if (admin.tab === 'areas') content = await renderAreas();
  else if (admin.tab === 'rackets') content = await renderAdminRackets();
  else if (admin.tab === 'safehouses') content = await renderAdminSafehouses();
  else if (admin.tab === 'enterprises') content = await renderAdminEnterprises();
  else if (admin.tab === 'spots') content = await renderAdminSpots();
  else if (admin.tab === 'heists') content = admin.heist ? renderHeistEditor() : await renderHeistList();
  else if (admin.tab === 'drugs') content = await renderAdminDrugs();
  else if (admin.tab === 'staff') content = await renderStaffAccess();
  else if (admin.tab === 'turf') content = await renderTurfSettings();
  else if (admin.tab === 'diplomacy') content = await renderAdminDiplomacy();
  else if (admin.tab === 'director') content = h('div', {}, await renderAdminDirector(), await renderAdminAirdrops());
  else if (admin.tab === 'informants') content = await renderAdminInformants();
  else if (admin.tab === 'auctions') content = await renderAdminAuctions();
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

  return h('div', {},
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
    state.static.hexMode ? await turfBlock(gang) : influenceBlock(gang),
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

/* Gang page: their hex turf (hex mode) */
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
    h('button', { class: 'btn primary', type: 'button', style: 'margin-top:10px', onclick: async () => {
      const r = await adminRequest('hexGive', gang.id);
      if (!r.ok) return toast(r.error, true);
      toast(`Gave them ${r.data}.`);
      renderAdminTab();
    } }, 'Give them the hex I\'m standing in'));
}

/* Turf settings (hex mode) */
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
  const drugs = (v.turfDrugItems || []).map((d, i) => h('div', { class: 'row', style: 'align-items:center' },
    h('div', { style: 'flex:1;max-width:420px' }, itemPicker({ item: d.name, label: d.label, image: d.image }, (it) => { if (it) { v.turfDrugItems[i] = { name: it.name, label: it.label, image: it.image }; } }, { allowClear: false })),
    h('button', { class: 'btn small danger', type: 'button', onclick: () => { v.turfDrugItems.splice(i, 1); rerender(); } }, 'Remove')));
  const accountSel = select([{ value: 'dirty', label: 'Dirty money' }, { value: 'clean', label: 'Clean money' }], v.expandCost.account || 'dirty');
  accountSel.addEventListener('change', () => { v.expandCost.account = accountSel.value; });

  const save = async () => {
    const data = { ...v, turfDrugs: (v.turfDrugItems || []).map((d) => d.name).filter(Boolean) };
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
    h('p', { class: 'hint', style: 'margin:0 0 8px', text: 'Selling these on your own hex builds its control. (They also need to be on the Street dealing list so they can be sold.)' }),
    h('div', { style: 'display:grid;gap:8px' }, drugs),
    h('button', { class: 'btn small', type: 'button', style: 'margin-top:8px', onclick: () => { v.turfDrugItems = v.turfDrugItems || []; v.turfDrugItems.push({ name: null, label: null }); rerender(); } }, 'Add a turf drug'),
    h('h3', { style: 'margin-top:22px', text: 'Control' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, '% per unit sold on own turf', num(v, 'controlPerSale', 0.1, 100)),
      h('label', { class: 'field' }, '% lost per unit a rival sells', num(v, 'rivalLoss', 0, 100)),
      h('label', { class: 'field' }, '% every hex loses per hour', num(v, 'decayPerHour', 0, 100)),
      h('label', { class: 'field' }, 'New hexes start at (%)', num(v, 'startControl', 0, 100))),
    h('h3', { style: 'margin-top:8px', text: 'Buying new ground' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'A touching hex needs (%)', num(v, 'expandAt', 1, 100)),
      h('label', { class: 'field' }, 'Money', num(v.expandCost, 'money', 0, 100000000, 120)),
      h('label', { class: 'field' }, 'From', accountSel),
      h('div', { class: 'field', style: 'min-width:300px' }, 'Plus this item from their pockets',
        itemPicker(v.expandCost.item ? { item: v.expandCost.item, label: v.expandItemLabel } : null, (it) => { v.expandCost.item = it ? it.name : null; v.expandItemLabel = it ? it.label : null; }, { emptyText: 'No item needed' })),
      h('label', { class: 'field' }, 'How many', num(v.expandCost, 'count', 0, 10000))),
    h('h3', { style: 'margin-top:8px', text: 'Tags' }),
    h('div', { class: 'heist-settings' },
      h('label', { class: 'field' }, 'One extra tag for every … hexes', num(v, 'sprayEvery', 1, 50))));
}

/* Gang page: influence in every area, adjustable */
function influenceBlock(gang) {
  const adjust = (zoneKey, zoneLabel, current) => {
    const amount = h('input', { type: 'number', step: 1, value: 25, style: 'width:110px', 'aria-label': 'Influence amount' });
    const go = async (sign) => {
      const n = Math.abs(Math.floor(Number(amount.value) || 0));
      if (!n) return toast('Enter an amount.', true);
      if (await adminAct('addInfluence', [zoneKey, gang.id, sign * n], `${sign > 0 ? 'Added' : 'Took away'} ${n} influence in ${zoneLabel}.`)) hideModal();
    };
    showModal(
      h('h2', { text: `${gang.label} in ${zoneLabel}` }),
      h('p', { text: `They have ${current} influence here. ${gang.captureThreshold} takes an area. Who owns it updates on the next tick (or run one from Areas).` }),
      h('div', { class: 'row' }, amount),
      h('div', { class: 'buttons' },
        h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
        h('button', { class: 'btn danger', type: 'button', onclick: () => go(-1) }, 'Remove'),
        h('button', { class: 'btn primary', type: 'button', onclick: () => go(1) }, 'Add')),
    );
  };

  const rows = (gang.influence || []).map((z) => h('tr', {},
    h('td', {}, h('strong', { text: z.label }), z.owned ? h('span', { class: 'you', text: 'holds it' }) : null),
    h('td', { class: 'num fig', text: z.amount }),
    h('td', { class: 'actions' }, h('button', { class: 'btn small', type: 'button', onclick: () => adjust(z.key, z.label, z.amount) }, 'Adjust'))));

  const others = gang.otherZones || [];
  const pick = others.length ? select(others.map((z) => ({ value: z.key, label: z.label }))) : null;

  return h('div', { class: 'block' },
    h('h3', { text: 'Influence' }),
    rows.length
      ? h('table', {}, h('tbody', {}, rows))
      : h('p', { text: 'No influence anywhere yet.' }),
    pick ? h('div', { class: 'row', style: 'margin-top:12px;align-items:center' },
      h('span', { class: 'muted', text: 'Add influence in' }), pick,
      h('button', { class: 'btn small', type: 'button', onclick: () => adjust(pick.value, pick.selectedOptions[0].textContent, 0) }, 'Adjust')) : null);
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

/* Areas ----------------------------------------------------------------- */

async function renderAreas() {
  const res = await adminRequest('zones');
  if (!res.ok) return loadError(res);
  const { zones, gangs, captureThreshold, tickMinutes } = res.data;

  const rows = zones.map((z) => h('tr', {},
    h('td', {}, h('strong', { text: z.label }),
      h('div', { class: 'hint', text: z.drawn ? `Drawn in game${z.value !== 1 ? `, worth ${z.value}x` : ''}` : `Set in config${z.value !== 1 ? `, worth ${z.value}x` : ''}` })),
    h('td', {}, z.owner ? swatchLabel(z.owner.colour, z.owner.label) : h('span', { class: 'muted', text: 'Unclaimed' })),
    h('td', {}, z.breakdown.length
      ? h('div', { class: 'breakdown' }, z.breakdown.map((b) => h('div', {},
        h('span', { class: 'swatch', style: `background:${b.colour}` }),
        h('span', { text: b.label }),
        h('span', { class: 'fig', text: b.influence }))))
      : h('span', { class: 'muted', text: 'No influence' })),
    h('td', { class: 'actions' },
      h('button', { class: 'btn small', type: 'button', disabled: !gangs.length, onclick: () => openAdjust(z, gangs) }, 'Adjust'),
      z.drawn ? h('button', {
        class: 'btn small danger', type: 'button',
        onclick: () => confirmModal({
          title: `Delete ${z.label}?`,
          body: 'All influence and ownership in this area is wiped. Tags already sprayed there stay up but stop counting.',
          confirmLabel: 'Delete area',
          danger: true,
          onConfirm: () => adminAct('deleteZone', [z.key], 'Area deleted.'),
        }),
      }, 'Delete') : null)));

  const outlines = h('button', {
    class: 'btn', type: 'button',
    onclick: async () => {
      if (!IN_GAME) return toast('Outlines only show in game.');
      const res = await (await fetch(`https://${RESOURCE}/toggleOutlines`, { method: 'POST', body: '{}' })).json();
      outlines.textContent = res.on ? 'Hide outlines' : 'Show outlines';
    },
  }, 'Show outlines');

  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', { text: 'Areas' }),
      h('div', { class: 'row' },
        outlines,
        h('button', { class: 'btn', type: 'button', onclick: () => adminAct('tick', [], 'Tick run. Decay and ownership updated.') }, 'Run tick now'),
        h('button', { class: 'btn primary', type: 'button', onclick: () => { hideModal(); $('device').hidden = true; postNui('drawZone'); } }, 'Draw new area'))),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: `A gang needs ${captureThreshold} influence to take an area. Ticks run every ${tickMinutes} minutes. To draw an area, walk to each corner in turn and press E, then Enter to finish.` }),
    zones.length
      ? h('table', {},
        h('thead', {}, h('tr', {}, h('th', { text: 'Area' }), h('th', { text: 'Held by' }), h('th', { text: 'Influence' }), h('th', {}))),
        h('tbody', {}, rows))
      : h('p', { class: 'empty', text: 'No areas yet. Draw one in game to get started.' }));
}

function openAdjust(zone, gangs) {
  const gang = select(gangs.map((g) => ({ value: g.id, label: g.label })));
  const amount = h('input', { type: 'number', step: 1, value: 50 });
  showModal(
    h('h2', { text: `Adjust influence in ${zone.label}` }),
    h('p', { text: 'Use a negative number to take influence away. Ownership updates on the next tick.' }),
    h('div', { class: 'form' },
      h('label', { class: 'field' }, 'Gang', gang),
      h('label', { class: 'field' }, 'Amount', amount)),
    h('div', { class: 'buttons' },
      h('button', { class: 'btn', type: 'button', onclick: hideModal }, 'Cancel'),
      h('button', {
        class: 'btn primary', type: 'button',
        onclick: async () => { if (await adminAct('addInfluence', [zone.key, Number(gang.value), Number(amount.value)], 'Influence updated.')) hideModal(); },
      }, 'Apply')),
  );
}

/* Auctions -------------------------------------------------------------- */

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
  return h('div', {},
    h('div', { class: 'section-head' },
      h('h2', {}, 'Auctions ', h('span', { class: 'muted fig', text: v.lots.length })),
      h('button', { class: 'btn primary', type: 'button', onclick: () => adminAct('auctionOpen', [], 'Auction opened.') }, 'Hold an auction now')),
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: `Next automatic auction in about ${v.nextIn} min. ${v.hasItems ? '' : 'No contraband items are set up in config/auctions.lua, so item lots never appear.'}` }),
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

async function renderAdminAirdrops() {
  const res = await adminRequest('airdrops');
  if (!res.ok) return h('div', {});
  const state = { called: 'Plane on its way', flying: 'Falling', landed: 'On the ground' };
  return h('div', { style: 'margin-top:28px' },
    h('h3', { text: 'Air drops' }),
    res.data.length ? h('table', {}, h('tbody', {}, res.data.map((d) => h('tr', {},
      h('td', {}, h('strong', { text: d.gang }), h('div', { class: 'hint', style: 'margin:0', text: `${Math.round(d.x)}, ${Math.round(d.y)}` })),
      h('td', {}, state[d.state] || d.state, d.state === 'called' ? h('span', { class: 'muted' }, ' · ', countdown(d.arrivesIn)) : null),
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
        onclick: () => { value = it; onPick(it); idle(); },
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
    extra.push(h('label', { class: 'field' }, 'Alarm', pick(s, 'alert', ALERT_OPTIONS)));
    if (s.type !== 'truck' && s.type !== 'loot' && s.type !== 'wait') extra.push(h('label', { class: 'field' }, 'Door to unlock (optional)', text(s, 'doorId', 160, 'door-lock ID or name')));

    return h('div', { class: 'heist-edit-step' },
      h('div', { class: 'heist-edit-head' },
        h('span', { class: 'step-no', text: String(i + 1) }),
        pick(s, 'type', typeOptions),
        text(s, 'label', 200, 'Label, e.g. Vault door'),
        h('span', { class: 'heist-pos' }, followsTruck(s) ? h('span', { class: 'muted', text: 'At the truck' }) : [
          h('span', { class: s.x != null ? 'fig' : 'debit', text: point(s) }),
          h('button', { class: 'btn small', type: 'button', onclick: () => here((p) => Object.assign(s, p)) }, s.type === 'truck' ? 'Truck starts here' : 'Set here'),
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
    h('div', { class: 'heist-edit-start' },
      h('div', {}, h('strong', { text: 'Start point' }), h('div', { class: 'hint', style: 'margin:0', text: 'Where the crew gathers and presses E to begin. Crew within 40m count.' })),
      h('span', { class: 'heist-pos' },
        h('span', { class: d.start ? 'fig' : 'debit', text: point(d.start) }),
        h('button', { class: 'btn small', type: 'button', onclick: () => here((p) => { d.start = p; }) }, 'Set here'),
        h('button', { class: 'btn small', type: 'button', onclick: () => goTo(d.start) }, 'Go to'))),
    h('h3', { style: 'margin:22px 0 4px', text: 'Steps' }),
    h('p', { class: 'hint', style: 'margin:0 0 10px', text: 'Done in order. Loot steps next to each other can be grabbed at the same time by different crew. Stand at each spot and press Set here.' }),
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
    h('p', { class: 'hint', style: 'margin-bottom:16px', text: 'Use an interior already on the map (an MLO or any building), or a shell from a shell pack, which is spawned only while someone is inside. Every safehouse gets its own instance, so several can share the same interior or shell.' }),
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
  const start = (shell) => { hideModal(); $('device').hidden = true; postNui('setupSafehouse', shell ? { shell } : {}); };
  const pick = shells.length ? select(shells.map((x) => ({ value: x.model, label: `${x.label} (${x.model})` }))) : null;
  $('sheet').classList.add('wide');
  showModal(
    h('h2', { text: 'Set up a safehouse' }),
    h('div', { class: 'template-grid' },
      h('button', { class: 'template', type: 'button', onclick: () => start(null) },
        h('strong', { text: 'An interior on the map' }),
        h('span', { class: 'hint', style: 'margin:0', text: 'An MLO or building that\'s already in the world. Stand at the outside door, then the spawn, the stash and the inside door, pressing E at each.' })),
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
      case 'zones': return ok({ captureThreshold: 100, tickMinutes: 5,
        gangs: [{ id: 1, label: 'Grove Kings' }, { id: 2, label: 'Los Vagos' }],
        zones: [
          { key: 'davis', label: 'Davis', drawn: false, value: 1, owner: { label: 'Grove Kings', colour: '#7B3FBF' }, breakdown: [{ gangId: 1, label: 'Grove Kings', colour: '#7B3FBF', influence: 164.2 }, { gangId: 2, label: 'Los Vagos', colour: '#E8C31E', influence: 41 }] },
          { key: 'forum_drive', label: 'Forum Drive', drawn: true, value: 1.5, owner: null, breakdown: [] },
        ] });
      case 'auctions': return ok({ nextIn: 74, hasItems: false, lots: [{ id: 5, title: '220 grow supplies', status: 'open', topBid: 5200, bids: 3, gang: 'Los Vagos', colour: '#E8C31E', secondsLeft: 610 }] });
      case 'informants': return ok([{ citizenid: 'C3', code: 'CHIS-4F2A', name: 'Danny Price', gang: 'Grove Kings', tips: 6, earned: 13500, active: true }]);
      case 'director': return ok({ enabled: true, nextIn: 23, kinds: ['boom', 'crackdown', 'crash', 'crew', 'drop', 'hotwork', 'shortage', 'undercover'],
        events: [{ id: 3, kind: 'undercover', public: 'Word is the police have someone on the inside of one of the gangs.', gang: 'Los Vagos', minutesLeft: 88 },
          { id: 4, kind: 'crew', public: 'An outside crew has moved into Rancho.', zone: 'Rancho', strength: 39, minutesLeft: 64 }] });
      case 'agreements': return ok([{ id: 4, label: 'Trade agreement', status: 'active', a: 'Grove Kings', aColour: '#7B3FBF', b: 'East Side', bColour: '#3FA7D6', payment: 0, secondsLeft: 300000 }]);
      case 'heists': return ok({ defaultTier: 3, tools: { thermite: { item: 'thermite', label: 'Thermite', consume: true }, truck_doors: { item: 'thermite', label: 'Thermite', consume: true } }, tiers: ['Street crew', 'Firm', 'Organisation', 'Syndicate'],
        templates: [{ key: 'bank', label: 'Bank vault', steps: 5 }, { key: 'truck', label: 'Armoured truck', steps: 3 }, { key: 'store', label: 'Store robbery', steps: 3 }, { key: 'jewellery', label: 'Jewellery store', steps: 5 }, { key: 'custom', label: 'Custom heist', steps: 0 }],
        stepTypes: [{ key: 'hack', label: 'Hack a panel', game: 'hack' }, { key: 'thermite', label: 'Thermite a door', game: 'thermite' }, { key: 'drill', label: 'Drill (vault or boxes)', game: 'drill' }, { key: 'loot', label: 'Grab loot' }, { key: 'wait', label: 'Wait (time lock)' }, { key: 'truck', label: 'Armoured truck: stop it' }, { key: 'truck_doors', label: 'Armoured truck: open the back', game: 'thermite' }],
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
      case 'hexGive': return ok('Davis (4, -8)');
      case 'hexSettings': return ok({ size: 150, turfDrugs: ['weed_og_kush'], turfDrugItems: [{ name: 'weed_og_kush', label: 'OG Kush' }], controlPerSale: 1.5, rivalLoss: 2, decayPerHour: 4, startControl: 10, expandAt: 100, sprayEvery: 3,
        expandCost: { money: 50000, account: 'dirty', item: 'weed_og_kush', count: 50 }, expandItemLabel: 'OG Kush' });
      case 'airdrops': return ok([{ id: 3, gang: 'Grove Kings', state: 'called', x: 1712, y: 3290, arrivesIn: 184 }]);
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
  window.postMessage({ action: 'openAdmin', static: { currency: '£', nameMax: 24, hexMode: location.search.includes('hex'), hexSize: 150, hexOrigin: { x: 0, y: 0 }, zones: [], permissions: [], fonts: [],
    tiers: [{ label: 'Street crew', unlocks: [] }, { label: 'Firm', unlocks: [] }, { label: 'Organisation', unlocks: [] }, { label: 'Syndicate', unlocks: [] }] } }, '*');
}
