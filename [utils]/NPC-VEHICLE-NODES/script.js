const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'npc_blocker';
const $ = (id) => document.getElementById(id);

function post(name, data = {}) {
  return fetch(`https://${RES}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
    .then((r) => r.json())
    .catch(() => ({}));
}

const NUMS = ['z', 'height'];
const FLAGS = ['blockPeds', 'blockScenarios', 'blockVehicles', 'clearPeds', 'clearVehicles'];
const DEFAULTS = {
  id: null, name: '', z: 0, height: 10, points: [],
  blockPeds: true, blockScenarios: true, blockVehicles: false,
  clearPeds: false, clearVehicles: false,
};

let zones = [];
let editingId = null;
let pins = [];
let inited = false;

const round = (n) => Math.round(n * 100) / 100;

function readForm() {
  const d = { id: editingId, name: $('name').value.trim() || 'Zone' };
  NUMS.forEach((k) => { d[k] = parseFloat($(k).value) || 0; });
  FLAGS.forEach((k) => { d[k] = $(k).checked; });
  d.points = pins.map((p) => ({ x: p.x, y: p.y }));
  return d;
}

function fillForm(d) {
  editingId = d.id ?? null;
  $('name').value = d.name || '';
  NUMS.forEach((k) => { $(k).value = round(d[k] ?? 0); });
  FLAGS.forEach((k) => { $(k).checked = !!d[k]; });
  pins = (d.points || []).map((p) => ({ x: p.x, y: p.y, z: d.z ?? 0 }));
  $('formTitle').textContent = editingId ? 'Edit zone' : 'New zone';
  refresh();
}

function preview() {
  post('preview', readForm());
}

function refresh() {
  renderPins();
  renderList();
  preview();
}

function say(text) {
  $('msg').textContent = text;
}

function addPin(x, y, z) {
  pins.push({ x: round(x), y: round(y), z: round(z) });
  $('z').value = Math.min(...pins.map((p) => p.z));
  say('Green = zone being edited, red = saved zones.');
  refresh();
}

function renderPins() {
  const ul = $('pins');
  ul.innerHTML = '';
  $('pinCount').textContent = pins.length ? `(${pins.length})` : '';

  pins.forEach((p, i) => {
    const li = document.createElement('li');
    const label = document.createElement('span');
    label.textContent = `#${i + 1}  ${p.x}, ${p.y}`;
    const del = document.createElement('button');
    del.textContent = '✕';
    del.onclick = () => { pins.splice(i, 1); refresh(); };
    li.append(label, del);
    ul.appendChild(li);
  });
}

async function pinFrom(mode) {
  const r = await post('place', { mode });
  if (r.ok) addPin(r.x, r.y, r.z);
}

$('pinPed').onclick = () => pinFrom('ped');
$('pinCross').onclick = () => pinFrom('crosshair');
$('walk').onclick = () => post('walk');
$('undo').onclick = () => { pins.pop(); refresh(); };
$('clearPins').onclick = () => { pins = []; refresh(); };

function renderList() {
  const ul = $('list');
  ul.innerHTML = '';
  $('count').textContent = zones.length ? `(${zones.length})` : '';

  if (!zones.length) {
    const li = document.createElement('li');
    li.innerHTML = '<span class="empty">No zones yet.</span>';
    ul.appendChild(li);
    return;
  }

  zones.forEach((z) => {
    const li = document.createElement('li');
    if (z.id === editingId) li.classList.add('editing');

    const name = document.createElement('span');
    name.className = 'name';
    name.textContent = z.name;

    const btns = document.createElement('span');
    btns.className = 'btns';

    const edit = document.createElement('button');
    edit.textContent = 'Edit';
    edit.onclick = () => fillForm(z);

    const tp = document.createElement('button');
    tp.textContent = 'TP';
    tp.title = 'Teleport to this zone';
    tp.onclick = () => post('teleport', { id: z.id });

    const del = document.createElement('button');
    del.textContent = '🗑';
    del.className = 'danger';
    let armed = false;
    del.onclick = () => {
      if (!armed) {
        armed = true;
        del.textContent = 'Sure?';
        setTimeout(() => { armed = false; del.textContent = '🗑'; }, 2500);
        return;
      }
      post('delete', { id: z.id });
      if (editingId === z.id) fillForm(DEFAULTS);
    };

    btns.append(edit, tp, del);
    li.append(name, btns);
    ul.appendChild(li);
  });
}

[...NUMS, ...FLAGS, 'name'].forEach((k) => {
  $(k).addEventListener('input', preview);
  $(k).addEventListener('change', preview);
});

document.querySelectorAll('.nudgeBtns button').forEach((b) => {
  b.addEventListener('click', () => {
    const k = b.dataset.k;
    const step = parseFloat($('step').value) || 0.5;
    $(k).value = round((parseFloat($(k).value) || 0) + parseFloat(b.dataset.d) * step);
    preview();
  });
});

$('save').onclick = () => {
  if (pins.length < 3) {
    say('Need at least 3 pins before saving.');
    return;
  }
  say('Green = zone being edited, red = saved zones.');
  post('save', readForm());
};

$('reset').onclick = () => fillForm(DEFAULTS);

$('close').onclick = () => post('close');
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') post('close');
});

window.addEventListener('message', (e) => {
  const m = e.data;
  switch (m.action) {
    case 'open':
      zones = m.zones || [];
      $('app').classList.remove('hidden');
      if (!inited) { inited = true; fillForm(DEFAULTS); } else refresh();
      break;
    case 'zones':
      zones = m.zones || [];
      if (editingId === null && zones.length) {
        const last = zones[zones.length - 1];
        if (last.name === readForm().name) editingId = last.id;
      }
      $('formTitle').textContent = editingId ? 'Edit zone' : 'New zone';
      renderList();
      preview();
      break;
    case 'pin':
      addPin(m.x, m.y, m.z);
      break;
    case 'undo':
      pins.pop();
      refresh();
      break;
    case 'hide':
      $('app').classList.add('hidden');
      break;
    case 'show':
      $('app').classList.remove('hidden');
      break;
    case 'close':
      $('app').classList.add('hidden');
      break;
  }
});
