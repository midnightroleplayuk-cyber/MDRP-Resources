'use strict';

const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'vinewood_police';

// Optional parts of forms are passed as null; skip them rather than printing "null".
const nativeAppend = Element.prototype.append;
Element.prototype.append = function (...nodes) {
  return nativeAppend.apply(this, nodes.filter((n) => n !== null && n !== undefined && n !== false));
};
const $ = (id) => document.getElementById(id);
const TONES = { ok: 'var(--ok)', busy: 'var(--busy)', away: 'var(--away)' };

const state = { data: null, tab: 'duty', task: null, signingOff: false, summary: null, notebook: null, correcting: null, locker: null, roster: null };

/* ---------- helpers ---------- */

function h(tag, attrs, ...children) {
  const el = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs || {})) {
    if (v === undefined || v === null || v === false) continue;
    if (k === 'class') el.className = v;
    else if (k === 'style') el.style.cssText = v;
    else if (k.startsWith('on')) el.addEventListener(k.slice(2), v);
    else if (v === true) el.setAttribute(k, '');
    else el.setAttribute(k, v);
  }
  for (const c of children.flat()) {
    if (c === undefined || c === null || c === false) continue;
    el.append(c instanceof Node ? c : document.createTextNode(String(c)));
  }
  return el;
}

// Lua sends lists and objects as the same kind of table, so an empty list can arrive as {} and a list
// with gaps as { "1": .., "3": .. }. Turn those back into arrays so every list on the page can be looped.
function fixLua(v) {
  if (Array.isArray(v)) return v.map(fixLua);
  if (!v || typeof v !== 'object') return v;
  const keys = Object.keys(v);
  if (keys.length === 0) return [];
  if (keys.every((k) => /^\d+$/.test(k))) return keys.map(Number).sort((a, b) => a - b).map((k) => fixLua(v[k]));
  const out = {};
  for (const k of keys) out[k] = fixLua(v[k]);
  return out;
}

async function request(action, data) {
  try {
    const res = await fetch(`https://${resource}/request`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ action, data }),
    });
    return fixLua(await res.json());
  } catch (e) {
    return { error: 'The game did not answer. Try again.' };
  }
}

const pad = (n) => String(n).padStart(2, '0');
function ukDateTime(t) {
  if (!t) return '';
  const d = new Date(t * 1000);
  return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}
function ukTime(t) { const d = new Date(t * 1000); return `${pad(d.getHours())}:${pad(d.getMinutes())}`; }
function duration(minutes) {
  minutes = Math.max(0, Math.floor(minutes || 0));
  const hrs = Math.floor(minutes / 60), mins = minutes % 60;
  return hrs ? `${hrs}h ${pad(mins)}m` : `${mins}m`;
}
const since = (t) => duration((Date.now() / 1000 - t) / 60);

const list = (v) => (Array.isArray(v) ? v : []);
function statusById(id) { return list(state.data && state.data.statuses).find((s) => s.id === id); }

function message(container, text, kind = 'error') {
  container.querySelectorAll('.error, .success').forEach((n) => n.remove());
  if (text) container.append(h('div', { class: kind, role: kind === 'error' ? 'alert' : 'status' }, text));
}

async function busy(button, fn) {
  button.disabled = true;
  try { await fn(); } finally { if (button.isConnected) button.disabled = false; }
}

/* ---------- header and tabs ---------- */

function renderHeader() {
  const d = state.data;
  $('force').textContent = d.force;
  $('officer').textContent = d.officer.label;
  const cs = $('callsign'), chip = $('statusChip');
  if (d.duty) {
    cs.textContent = d.duty.callsign || 'On duty';
    cs.className = 'callsign';
    const s = statusById(d.duty.status);
    chip.textContent = s ? s.label : d.duty.status;
    chip.style.setProperty('--tone', TONES[s && s.tone] || TONES.away);
    chip.hidden = false;
  } else {
    cs.textContent = 'Off duty';
    cs.className = 'callsign off';
    chip.hidden = true;
  }
}

function tabLabels() {
  const forms = document.querySelector('.tabs button[data-tab="forms"]');
  const n = state.data && state.data.uofPending;
  if (forms) forms.textContent = n ? `Forms (${n})` : 'Forms';
}

function selectTab(tab) {
  tabLabels();
  state.tab = tab;
  document.querySelectorAll('.tabs button').forEach((b) => b.setAttribute('aria-selected', String(b.dataset.tab === tab)));
  render();
}

// Panels shown as a desk computer rather than the side panel
const COMPUTER = { custody: 'Custody system', evidence: 'Property and exhibits store' };
let pcClockTimer = null;

function render() {
  renderHeader();
  const body = $('body');
  body.replaceChildren();
  const pc = state.task && COMPUTER[state.task.name];
  $('hub').classList.toggle('computer', !!pc);
  if (pc) {
    $('pcTitle').textContent = `${state.data && state.data.force ? `${state.data.force} · ` : ''}${pc}`;
    const tick = () => { $('pcClock').textContent = new Date().toLocaleString('en-GB', { weekday: 'short', day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' }); };
    tick();
    if (!pcClockTimer) pcClockTimer = setInterval(tick, 15000);
  } else if (pcClockTimer) { clearInterval(pcClockTimer); pcClockTimer = null; }
  document.querySelector('.tabs').hidden = !!state.task;
  if (pc && state.task.name !== 'custody') {
    // Other desk screens: one scrolling column on the computer
    const inner = h('div', { class: 'pc-main', style: 'flex:1' });
    body.append(inner);
    return TASKS[state.task.name](inner, state.task);
  }
  if (state.task) return TASKS[state.task.name](body, state.task);
  ({ duty: renderDuty, notebook: renderNotebook, locker: renderLocker, roster: renderRoster, forms: renderForms })[state.tab](body);
}

/* ---------- duty ---------- */

function renderDuty(body) {
  const d = state.data;
  if (!d.duty) return renderSignOn(body);
  if (state.signingOff) return renderSignOff(body);

  body.append(h('h2', {}, 'Status'));
  const grid = h('div', { class: 'statuses', role: 'group', 'aria-label': 'Status' });
  for (const s of list(d.statuses)) {
    grid.append(h('button', {
      type: 'button', style: `--tone:${TONES[s.tone] || TONES.away}`, 'aria-pressed': String(d.duty.status === s.id),
      onclick: async (e) => {
        await busy(e.currentTarget, async () => {
          const res = await request('duty:setStatus', { status: s.id });
          if (res.error) return message(body, res.error);
          d.duty = res.duty; render();
        });
      },
    }, s.label));
  }
  body.append(grid);

  body.append(h('h3', {}, 'This shift'));
  body.append(h('dl', { class: 'facts' },
    h('dt', {}, 'Unit'), h('dd', {}, d.duty.unitLabel || '-'),
    h('dt', {}, 'Vehicle'), h('dd', {}, d.duty.vehicle || 'On foot'),
    h('dt', {}, 'Signed on'), h('dd', {}, `${d.duty.station ? d.duty.station + ', ' : ''}${ukTime(d.duty.since)} (${since(d.duty.since)} ago)`),
    h('dt', {}, 'Collar'), h('dd', {}, d.duty.collar || '-'),
  ));

  body.append(h('button', {
    class: 'secondary', type: 'button',
    onclick: async (e) => {
      await busy(e.currentTarget, async () => {
        const res = await request('duty:summary');
        if (res.error) return message(body, res.error);
        state.summary = res.summary || {};
        state.signingOff = true; render();
      });
    },
  }, 'Sign off'));
}

function renderSignOn(body) {
  const d = state.data;
  const blocked = d.signOnAtStation && !d.station;
  body.append(h('h2', {}, 'Sign on'));
  if (blocked) body.append(h('p', { class: 'warn' }, 'Go to a sign-on point at a station to sign on.'));
  else if (d.station) body.append(h('p', { class: 'note' }, `Signing on at ${d.station}.`));

  const form = h('form', { novalidate: true });
  const callsign = h('input', { id: 'f-callsign', maxlength: d.callsignMax || 8, value: d.officer.callsign || '', placeholder: 'e.g. 1A-12', autocomplete: 'off' });
  form.append(h('label', { for: 'f-callsign' }, 'Callsign'), callsign);
  if (d.dispatch) form.append(h('p', { class: 'note', style: 'margin-top:4px' }, 'Saved to dispatch, so it shows on calls and the MDT.'));

  let collar = null;
  if (d.officer.collar) {
    form.append(h('label', { for: 'f-collar' }, 'Collar number'), h('input', { id: 'f-collar', value: d.officer.collar, readonly: true }));
  } else if (d.selfCollar) {
    collar = h('input', { id: 'f-collar', inputmode: 'numeric', maxlength: 5, placeholder: 'Digits only', autocomplete: 'off' });
    form.append(h('label', { for: 'f-collar' }, 'Collar number'), collar,
      h('p', { class: 'note', style: 'margin-top:4px' }, 'Pick carefully: after this, only a sergeant can change it.'));
  } else {
    form.append(h('p', { class: 'warn', style: 'margin-top:12px' }, 'You need a collar number. Ask a sergeant to set one.'));
  }

  const unit = h('select', { id: 'f-unit' });
  for (const u of d.units) {
    unit.append(h('option', { value: u.id, disabled: !u.allowed }, u.allowed ? u.label : `${u.label} (needs ${u.needs})`));
  }
  form.append(h('label', { for: 'f-unit' }, 'Unit'), unit);

  const vehicle = h('input', { id: 'f-vehicle', maxlength: 24, placeholder: 'Fleet number or registration. Leave blank if on foot.', autocomplete: 'off' });
  form.append(h('label', { for: 'f-vehicle' }, 'Vehicle'), vehicle);

  const submit = h('button', { class: 'primary', type: 'submit', disabled: blocked }, 'Sign on');
  form.append(submit);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(submit, async () => {
      const res = await request('duty:signOn', {
        callsign: callsign.value, collar: collar ? collar.value : undefined, unit: unit.value, vehicle: vehicle.value,
      });
      if (res.error) return message(form, res.error);
      d.duty = res.duty;
      if (collar && res.duty.collar) d.officer.collar = res.duty.collar;
      d.officer.callsign = res.duty.callsign;
      render();
    });
  });
  body.append(form);
  (callsign.value ? unit : callsign).focus();
}

function renderSignOff(body) {
  const d = state.data, s = state.summary || {};
  body.append(h('h2', {}, 'Sign off'));
  const facts = h('dl', { class: 'facts' },
    h('dt', {}, 'Time on duty'), h('dd', {}, duration(s.minutes)),
    h('dt', {}, 'Notebook entries'), h('dd', {}, s.notebook || 0),
    h('dt', {}, 'Status changes'), h('dd', {}, s.statusChanges || 0),
  );
  for (const [key, label] of [['restraints', 'People handcuffed'], ['arrests', 'Arrests'], ['searches', 'Stop and searches']]) {
    if (s[key]) facts.append(h('dt', {}, label), h('dd', {}, s[key]));
  }
  body.append(facts);
  if (s.outstanding) {
    body.append(h('p', { class: 'warn', style: 'margin-top:12px' },
      `You have ${s.outstanding} item${s.outstanding === 1 ? '' : 's'} of kit out. It's taken back when you sign off; anything you no longer have is recorded as missing.`));
  }

  const form = h('form', { novalidate: true });
  const report = h('textarea', { id: 'f-report', maxlength: d.reportMax || 2000, rows: 6, placeholder: 'What you dealt with, anything handed over, anything the next shift needs to know.' });
  form.append(h('label', { for: 'f-report' }, d.reportRequired ? 'End-of-shift report' : 'End-of-shift report (optional)'), report);
  const confirm = h('button', { class: 'primary danger', type: 'submit' }, 'Sign off');
  const cancel = h('button', { class: 'secondary', type: 'button', onclick: () => { state.signingOff = false; render(); } }, 'Stay on duty');
  form.append(h('div', { class: 'actions' }, confirm, cancel));
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(confirm, async () => {
      const res = await request('duty:signOff', { report: report.value });
      if (res.error) return message(form, res.error);
      d.duty = null; state.signingOff = false; render();
      message($('body'), `Signed off after ${duration(res.summary && res.summary.minutes)}.`, 'success');
    });
  });
  body.append(form);
  report.focus();
}

/* ---------- notebook ---------- */

async function loadNotebook(beforeId) {
  const res = await request('notebook:list', beforeId ? { beforeId } : {});
  if (res.error) return res;
  if (!beforeId || !state.notebook) state.notebook = { entries: [], more: false };
  state.notebook.entries.push(...(res.entries || []));
  state.notebook.more = !!res.more;
  return res;
}

function renderNotebook(body) {
  const d = state.data;
  body.append(h('h2', {}, 'Pocket notebook'));
  body.append(h('p', { class: 'note' }, 'Entries are permanent. To fix a mistake, add a correction.'));

  const form = h('form', { novalidate: true });
  if (state.correcting) {
    form.append(h('div', { class: 'banner' },
      h('span', {}, `Correcting entry ${state.correcting}`),
      h('button', { type: 'button', class: 'linkish', onclick: () => { state.correcting = null; render(); } }, 'Cancel')));
  }
  const text = h('textarea', { id: 'f-note', maxlength: d.notebookMax || 1000, rows: 4, placeholder: 'Time, place, who, what happened.' });
  const ref = h('input', { id: 'f-ref', maxlength: 32, placeholder: 'Incident or custody reference, if there is one', autocomplete: 'off' });
  const add = h('button', { class: 'primary', type: 'submit' }, state.correcting ? 'Add correction' : 'Add entry');
  form.append(h('label', { for: 'f-note' }, 'Entry'), text, h('label', { for: 'f-ref' }, 'Reference'), ref, add);
  const submit = async () => {
    await busy(add, async () => {
      const res = await request('notebook:add', { text: text.value, ref: ref.value, correctsId: state.correcting || undefined });
      if (res.error) return message(form, res.error);
      state.correcting = null; state.notebook = null;
      await loadNotebook(); render();
    });
  };
  form.addEventListener('submit', (e) => { e.preventDefault(); submit(); });
  text.addEventListener('keydown', (e) => { if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) { e.preventDefault(); submit(); } });
  body.append(form);

  const list = h('div', { 'aria-live': 'polite' });
  body.append(h('h3', {}, 'Entries'), list);

  const fill = () => {
    list.replaceChildren();
    const nb = state.notebook;
    if (!nb.entries.length) return list.append(h('p', { class: 'note' }, 'No entries yet.'));
    for (const e of nb.entries) {
      list.append(h('article', { class: `entry${e.corrects_id ? ' correction' : ''}` },
        h('div', { class: 'entry-meta' },
          h('span', {}, `#${e.id}  ${ukDateTime(e.created_at)}${e.ref ? '  ' + e.ref : ''}${e.corrects_id ? `  corrects #${e.corrects_id}` : ''}`),
          h('button', { type: 'button', class: 'linkish', onclick: () => { state.correcting = e.id; render(); } }, 'Correct')),
        h('div', { class: 'entry-text' }, e.text)));
    }
    if (nb.more) {
      list.append(h('button', {
        class: 'secondary', type: 'button',
        onclick: async (ev) => { await busy(ev.currentTarget, async () => { await loadNotebook(nb.entries[nb.entries.length - 1].id); fill(); }); },
      }, 'Show older entries'));
    }
  };

  if (state.notebook) fill();
  else {
    list.append(h('p', { class: 'note' }, 'Loading…'));
    loadNotebook().then((res) => {
      if (state.tab !== 'notebook') return;
      if (res.error) { list.replaceChildren(); return message(list, res.error); }
      fill();
    });
  }
  text.focus();
}

/* ---------- locker ---------- */

async function loadLocker() {
  const res = await request('equipment:locker');
  state.locker = res;
  return res;
}

function renderLocker(body) {
  const fill = () => {
    body.replaceChildren();
    const l = state.locker;
    if (!l) return body.append(h('p', { class: 'note' }, 'Loading…'));
    if (l.error) {
      body.append(h('h2', {}, 'Equipment locker'));
      return message(body, l.error);
    }
    body.append(h('h2', {}, `Locker, ${l.station}`));

    if (l.outfits && l.outfits.length) {
      body.append(h('h3', {}, 'Uniform'));
      const row = h('div', { class: 'uniforms' });
      for (const o of [...l.outfits, { id: 'own', label: 'Own clothes' }]) {
        row.append(h('button', {
          class: 'small', type: 'button',
          onclick: async (e) => { await busy(e.currentTarget, async () => {
            const res = await request('equipment:uniform', { id: o.id });
            if (res.error) message(body, res.error);
          }); },
        }, o.label));
      }
      body.append(row);
    }

    body.append(h('h3', {}, 'Equipment'));
    const items = h('ul', { class: 'rows' });
    for (const it of l.items) {
      const full = it.held >= it.max;
      items.append(h('li', {},
        h('span', {}, it.label),
        it.allowed
          ? h('button', {
              class: 'small', type: 'button', disabled: full,
              onclick: async (e) => { await busy(e.currentTarget, async () => {
                const res = await request('equipment:draw', { item: it.item });
                if (res.error) return message(body, res.error);
                await loadLocker(); fill();
                message(body, res.issued.serial ? `${res.issued.label} issued, serial ${res.issued.serial}.` : `${res.issued.label} issued.`, 'success');
              }); },
            }, full ? 'Drawn' : 'Draw')
          : h('span', { class: 'count' }, '-'),
        h('span', { class: 'sub' }, it.allowed ? `You have ${it.held} of ${it.max}` : it.needs)));
    }
    body.append(items);

    body.append(h('h3', {}, 'Issued to you'));
    if (l.armouryOut) body.append(h('p', { class: 'note' }, 'You also have kit from the armoury: hand that in at the armoury.'));
    if (!l.outstanding.length) body.append(h('p', { class: 'note' }, 'Nothing out. Everything is back in the locker.'));
    else {
      const out = h('ul', { class: 'rows' });
      for (const r of l.outstanding) {
        out.append(h('li', {},
          h('span', {}, `${r.label || r.item}${r.count > 1 ? ` x${r.count}` : ''}`),
          h('button', {
            class: 'small', type: 'button',
            onclick: async (e) => { await busy(e.currentTarget, async () => {
              const res = await request('equipment:return', { id: r.id });
              if (res.error) return message(body, res.error);
              await loadLocker(); fill();
              message(body, `${r.label || r.item} returned.`, 'success');
            }); },
          }, 'Return'),
          h('span', { class: 'sub' }, `${r.serial ? `Serial ${r.serial}. ` : ''}Issued ${ukDateTime(r.issued_at)}`)));
      }
      body.append(out);
    }
  };
  state.locker = null;
  fill();
  loadLocker().then(() => { if (state.tab === 'locker') fill(); });
}

/* ---------- roster ---------- */

function renderRoster(body) {
  body.append(h('h2', {}, 'On duty'));
  const holder = h('div', {}, h('p', { class: 'note' }, 'Loading…'));
  body.append(holder);
  request('duty:roster').then((res) => {
    if (state.tab !== 'roster') return;
    holder.replaceChildren();
    if (res.error) return message(holder, res.error);
    if (!res.roster.length) return holder.append(h('p', { class: 'note' }, 'Nobody is signed on.'));
    const tbody = h('tbody');
    for (const r of res.roster) {
      const s = statusById(r.status);
      tbody.append(h('tr', {},
        h('td', { class: 'cs' }, r.callsign || '-'),
        h('td', {}, r.name, h('div', { class: 'note' }, r.unitLabel || '')),
        h('td', {}, h('span', { class: 'dot', style: `--tone:${TONES[s && s.tone] || TONES.away}` }, s ? s.label : r.status)),
        h('td', { class: 'count' }, since(r.since))));
    }
    holder.append(h('table', {},
      h('thead', {}, h('tr', {}, h('th', {}, 'Callsign'), h('th', {}, 'Officer'), h('th', {}, 'Status'), h('th', {}, 'On'))),
      tbody));
  });
}


/* ---------- shared form pieces ---------- */

function field(id, label, input, hint) {
  const wrap = h('div', {}, h('label', { for: id }, label), input);
  if (hint) wrap.append(h('p', { class: 'note', style: 'margin-top:4px' }, hint));
  return wrap;
}

function select(id, options, placeholder) {
  const el = h('select', { id });
  if (placeholder) el.append(h('option', { value: '' }, placeholder));
  for (const o of options) {
    const value = typeof o === 'string' ? o : o.value;
    const label = typeof o === 'string' ? o : o.label;
    el.append(h('option', { value }, label));
  }
  return el;
}

/* Incident: existing open one, a new one, or (when allowed) none. */
function incidentPicker(data, allowNone) {
  const options = [];
  options.push({ value: '', label: allowNone ? 'Not linked to an incident' : 'Choose an incident' });
  options.push({ value: 'new', label: 'Start a new incident' });
  for (const i of data.incidents || []) options.push({ value: String(i.id), label: `${i.ref}: ${i.type}${i.location ? ', ' + i.location : ''}` });
  const pick = select('f-incident', options);
  const type = select('f-incident-type', data.incidentTypes || [], 'Choose the incident type');
  const typeWrap = field('f-incident-type', 'New incident type', type);
  const sync = () => { typeWrap.hidden = pick.value !== 'new'; };
  pick.addEventListener('change', sync);
  if (!allowNone && (data.incidents || []).length === 0) pick.value = 'new';
  sync();
  return {
    el: h('div', {}, field('f-incident', 'Incident', pick), typeWrap),
    value() {
      if (pick.value === 'new') return { newIncidentType: type.value || undefined };
      if (pick.value) return { incidentId: Number(pick.value) };
      return {};
    },
  };
}

function taskTitle(body, title, subject, basis) {
  body.append(h('h2', {}, title));
  if (subject) body.append(h('p', { class: 'subject' }, subject));
  if (basis) body.append(h('span', { class: 'basis' }, basis));
}

function backToHub() { close(); }

function done(body, text, then) {
  body.replaceChildren(h('h2', {}, 'Done'));
  message(body, text, 'success');
  body.append(h('div', { class: 'actions' },
    then || null,
    h('button', { class: 'secondary', type: 'button', onclick: backToHub }, 'Close')));
}

/* ---------- arrest ---------- */

function renderArrest(body, task) {
  const d = task.data;
  taskTitle(body, 'Arrest', d.subject.name);
  const form = h('form', { novalidate: true });

  const filter = h('input', { id: 'f-offfilter', placeholder: 'Filter offences', autocomplete: 'off' });
  const picker = h('div', { class: 'picker', role: 'group', 'aria-label': 'Offences' });
  for (const act of d.offences || []) {
    const group = h('div', { 'data-act': act.act }, h('h4', {}, act.act));
    for (const item of act.items) {
      const value = `${item}, ${act.act}`;
      group.append(h('label', { class: 'check', 'data-text': value.toLowerCase() }, h('input', { type: 'checkbox', value }), item));
    }
    picker.append(group);
  }
  filter.addEventListener('input', () => {
    const q = filter.value.trim().toLowerCase();
    picker.querySelectorAll('[data-act]').forEach((g) => {
      let any = false;
      g.querySelectorAll('label.check').forEach((l) => {
        const show = !q || l.dataset.text.includes(q) || l.querySelector('input').checked;
        l.hidden = !show; any = any || show;
      });
      g.hidden = !any;
    });
  });
  form.append(h('label', { for: 'f-offfilter' }, 'Offences'), filter, h('div', { style: 'margin-top:6px' }, picker));

  const counter = h('span', { class: 'counter' }, `0 / ${d.groundsMin}`);
  const grounds = h('textarea', { id: 'f-grounds', rows: 4, maxlength: 2000, placeholder: 'What you saw or were told that makes you suspect them of these offences.' });
  grounds.addEventListener('input', () => { counter.textContent = `${grounds.value.trim().length} / ${d.groundsMin}`; });
  form.append(h('label', { for: 'f-grounds' }, 'Grounds for arrest ', counter), grounds);

  const nec = h('div', { role: 'group', 'aria-label': 'Necessity' });
  (d.necessity || []).forEach((n, i) => nec.append(h('label', { class: 'check' }, h('input', { type: 'checkbox', value: String(i + 1) }), n)));
  form.append(h('label', {}, 'Why the arrest is necessary'), nec);

  let incident = null, incidentRef = null;
  if (d.mdt) { incident = incidentPicker(d, true); form.append(incident.el); }
  else {
    incidentRef = h('input', { id: 'f-incref', maxlength: 32, placeholder: 'Optional', autocomplete: 'off' });
    form.append(field('f-incref', 'Incident reference', incidentRef));
  }

  const cautioned = h('input', { type: 'checkbox', id: 'f-cautioned' });
  form.append(h('label', {}, 'Caution'), h('p', { class: 'caution' }, d.caution),
    h('div', { class: 'actions', style: 'margin-top:0' },
      h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('arrest:showCaution', { target: task.target });
        if (res.error) message(form, res.error); else message(form, 'Caution shown to them.', 'success');
      }); } }, 'Show the caution to them')),
    h('label', { class: 'check', style: 'margin-top:10px' }, cautioned, "I've cautioned them"));

  const submit = h('button', { class: 'primary', type: 'submit' }, 'Arrest');
  form.append(submit);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(submit, async () => {
      const res = await request('arrest:submit', Object.assign({
        target: task.target,
        offences: [...picker.querySelectorAll('input:checked')].map((i) => i.value),
        grounds: grounds.value,
        necessity: [...nec.querySelectorAll('input:checked')].map((i) => Number(i.value)),
        cautioned: cautioned.checked,
        location: task.location,
        incidentRef: incidentRef ? incidentRef.value : undefined,
      }, incident ? incident.value() : {}));
      if (res.error) return message(form, res.error);
      done(body, `Arrested. Custody reference ${res.ref}.${d.mdt ? ' The record is on the MDT.' : ''}`);
    });
  });
  body.append(form);
  filter.focus();
}

/* ---------- person search ---------- */

const BASIS = { cuffed: 'Handcuffed', custody: 'Under arrest', consent: 'With their consent' };

function renderSearch(body, task) {
  const d = task.data;
  taskTitle(body, 'Search', d.subject.name, BASIS[d.subject.basis]);

  if (d.canOpen) {
    body.append(h('div', { class: 'actions', style: 'margin-top:4px' },
      h('button', { class: 'secondary', style: 'margin-top:0', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('search:openInventory', { target: task.target });
        if (res.error) message(body, res.error);
      }); } }, 'Open their pockets')));
  }

  body.append(h('h3', {}, 'Found on them'));
  const list = h('ul', { class: 'rows items' });
  const fill = (items) => {
    list.replaceChildren();
    if (!items.length) return list.append(h('li', {}, h('span', { class: 'note' }, 'Nothing.')));
    for (const it of items) {
      const tick = h('input', { type: 'checkbox', 'aria-label': `Seize ${it.label}`, 'data-slot': it.slot });
      const count = h('input', { type: 'number', min: 1, max: it.count, value: it.count, 'aria-label': 'How many' });
      list.append(h('li', {},
        d.canSeize ? tick : h('span'),
        h('span', {}, it.label, it.note ? h('div', { class: 'note' }, it.note) : null),
        d.canSeize && it.count > 1 ? count : h('span', { class: 'count' }, `x${it.count}`)));
      tick._count = () => (it.count > 1 ? Math.min(it.count, Math.max(1, Number(count.value) || 1)) : 1);
    }
  };
  fill(d.items || []);
  body.append(list);

  if (d.canSeize) {
    body.append(h('h3', {}, 'Seize into evidence'));
    const form = h('form', { novalidate: true });
    const type = select('f-ev-type', d.evidenceTypes, 'Choose the exhibit type');
    const incident = d.localEvidence ? { el: null, value: () => ({}) } : incidentPicker(d, false);
    const desc = h('input', { id: 'f-ev-desc', maxlength: 255, placeholder: 'Leave blank to list the items', autocomplete: 'off' });
    const seize = h('button', { class: 'primary', type: 'submit' }, 'Seize ticked items');
    form.append(field('f-ev-type', 'Exhibit type', type), incident.el, field('f-ev-desc', 'Description', desc), seize);
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      await busy(seize, async () => {
        const items = [...list.querySelectorAll('input[type=checkbox]:checked')].map((t) => ({ slot: Number(t.dataset.slot), count: t._count() }));
        const res = await request('search:seize', Object.assign({
          target: task.target, items, type: type.value, description: desc.value, location: task.location,
        }, incident.value()));
        if (res.error) return message(form, res.error);
        fill(res.items || []);
        message(form, `Seized as exhibit ${res.ref}: ${(res.moved || []).join(', ')}.`, 'success');
      });
    });
    body.append(form);
  } else {
    body.append(h('p', { class: 'note', style: 'margin-top:12px' }, 'Seizing into evidence bags needs vinewood-mdt 2.18+ or ox_inventory.'));
  }

  if (d.ssEnabled && !d.inCustody) {
    body.append(h('button', { class: 'secondary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('stopsearch:prepare', { target: task.target });
      if (res.error) return message(body, res.error);
      state.task = { name: 'stopsearch', target: task.target, data: res, location: task.location };
      render();
    }); } }, 'Record stop and search'));
  }
}

/* ---------- stop and search ---------- */

const GOWISELY = [
  ['G', 'Grounds for the search'], ['O', 'Object of the search'], ['W', 'Warrant card shown (if not in uniform)'],
  ['I', 'Identity: your name and collar number'], ['S', 'Station you work from'],
  ['E', 'Entitlement to a copy of the record'], ['L', 'Legal power used'], ['Y', "You are detained for the purpose of a search"],
];

function renderStopSearch(body, task) {
  const d = task.data;
  taskTitle(body, 'Stop and search record', d.subject ? d.subject.name : null);
  const form = h('form', { novalidate: true });

  let description = null;
  if (!d.subject) {
    description = h('input', { id: 'f-ss-desc', maxlength: 255, value: d.prefillDescription || '', placeholder: 'e.g. male, 20s, grey hoodie, would not give name', autocomplete: 'off' });
    form.append(field('f-ss-desc', 'Person searched', description));
  }

  const power = select('f-ss-power', (d.powers || []).map((p) => ({ value: p.id, label: p.label })), 'Choose the power used');
  const object = select('f-ss-object', d.objects || [], 'What you were looking for');
  const grounds = h('textarea', { id: 'f-ss-grounds', rows: 3, maxlength: 2000, placeholder: 'What gave you reasonable grounds to suspect they had it.' });
  const auth = h('input', { id: 'f-ss-auth', maxlength: 160, placeholder: 'Authorising officer and area', autocomplete: 'off' });
  const authWrap = field('f-ss-auth', 'Authorisation', auth);
  const groundsWrap = field('f-ss-grounds', 'Grounds', grounds);
  const sync = () => {
    const p = (d.powers || []).find((x) => x.id === power.value);
    authWrap.hidden = !(p && p.authorisation);
    groundsWrap.querySelector('label').textContent = p && p.authorisation ? 'Grounds (optional under this power)' : 'Grounds';
  };
  power.addEventListener('change', sync);
  sync();

  const found = h('textarea', { id: 'f-ss-found', rows: 2, maxlength: 1000, placeholder: 'Leave blank if nothing was found.' });
  const outcome = select('f-ss-outcome', d.outcomes || [], 'Choose the outcome');
  const location = h('input', { id: 'f-ss-loc', maxlength: 160, value: task.location || '', autocomplete: 'off' });

  const gw = h('ul', { class: 'gowisely' });
  for (const [k, v] of GOWISELY) gw.append(h('li', {}, h('b', {}, k), ` ${v}`));
  const gave = h('input', { type: 'checkbox', id: 'f-ss-gw' });

  const submit = h('button', { class: 'primary', type: 'submit' }, 'Save record');
  form.append(field('f-ss-power', 'Power', power), field('f-ss-object', 'Object of search', object), groundsWrap, authWrap,
    field('f-ss-found', 'Found', found), field('f-ss-outcome', 'Outcome', outcome), field('f-ss-loc', 'Location', location),
    h('label', {}, 'GOWISELY'), gw, h('label', { class: 'check', style: 'margin-top:8px' }, gave, 'I gave them all of this'), submit);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(submit, async () => {
      const res = await request('stopsearch:submit', {
        target: task.target, description: description ? description.value : undefined, power: power.value, object: object.value,
        grounds: grounds.value, authorisation: auth.value, found: found.value, outcome: outcome.value, location: location.value,
        gowisely: gave.checked,
      });
      if (res.error) return message(form, res.error);
      done(body, `Saved as ${res.ref}.${d.mdt ? ' They have been given their copy through the MDT.' : ' They have been shown their copy.'}`);
    });
  });
  body.append(form);
  power.focus();
}

/* ---------- release from arrest ---------- */

function renderRelease(body, task) {
  const d = task.data, c = d.custody || {};
  taskTitle(body, 'Release from arrest', d.subject.name);
  body.append(h('dl', { class: 'facts' },
    h('dt', {}, 'Reference'), h('dd', {}, c.ref || '-'),
    h('dt', {}, 'Arrested'), h('dd', {}, `${ukDateTime(c.at)}${c.byLabel ? ' by ' + c.byLabel : ''}`),
    h('dt', {}, 'Offences'), h('dd', {}, (c.offences || []).join('; ') || '-')));
  const form = h('form', { novalidate: true });
  const reason = h('textarea', { id: 'f-rel', rows: 3, maxlength: 255, placeholder: 'e.g. grounds no longer exist after speaking to the witness.' });
  const submit = h('button', { class: 'primary danger', type: 'submit' }, 'Release from arrest');
  form.append(field('f-rel', 'Reason', reason, 'Their handcuffs stay on until you remove them.'), submit);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(submit, async () => {
      const res = await request('arrest:release', { target: task.target, reason: reason.value });
      if (res.error) return message(form, res.error);
      done(body, res.message || 'Released.');
    });
  });
  body.append(form);
  reason.focus();
}



/* Offences grouped by act, with a filter box. Returns { el, values() }. */
function offencePicker(offences, id) {
  const filter = h('input', { id, placeholder: 'Filter offences', autocomplete: 'off' });
  const picker = h('div', { class: 'picker', role: 'group', 'aria-label': 'Offences' });
  for (const act of offences || []) {
    const group = h('div', { 'data-act': act.act }, h('h4', {}, act.act));
    for (const item of act.items) {
      const value = `${item}, ${act.act}`;
      group.append(h('label', { class: 'check', 'data-text': value.toLowerCase() }, h('input', { type: 'checkbox', value }), item));
    }
    picker.append(group);
  }
  filter.addEventListener('input', () => {
    const q = filter.value.trim().toLowerCase();
    picker.querySelectorAll('[data-act]').forEach((g) => {
      let any = false;
      g.querySelectorAll('label.check').forEach((l) => {
        const show = !q || l.dataset.text.includes(q) || l.querySelector('input').checked;
        l.hidden = !show; any = any || show;
      });
      g.hidden = !any;
    });
  });
  return {
    el: h('div', {}, filter, h('div', { style: 'margin-top:6px' }, picker)),
    values: () => [...picker.querySelectorAll('input:checked')].map((i) => i.value),
  };
}

/* ---------- NPC driver (vehicle stops) ---------- */

const NPC_STATE_LEVEL = { stopped: '', out: '', stopping: 'amber', surrendered: 'ok', arrested: 'ok', fleeing_vehicle: 'red', fleeing_foot: 'red', hostile: 'red' };

function renderNpc(box, task) {
  const stop = task.data.stop;
  const draw = () => {
    const n = task.data.npc;
    box.replaceChildren();
    box.append(h('p', {}, chip(n.stateText, NPC_STATE_LEVEL[n.state] || '')));
    if (task.said) box.append(h('p', { class: 'caution', style: 'font-style:italic' }, task.said));

    const act = async (action, btn, extra) => {
      await busy(btn, async () => {
        const res = await request(action, Object.assign({ stop: stop.id }, extra || {}));
        if (res.error) return message(box, res.error);
        if (res.npc) task.data.npc = res.npc;
        task.said = res.said || null;
        draw();
        return res;
      });
    };
    const btn = (label, action, show) => show ? h('button', { class: 'small', type: 'button', onclick: (e) => act(action, e.currentTarget) }, label) : null;
    const talkable = ['stopped', 'out', 'surrendered', 'arrested'].includes(n.state);
    box.append(h('div', { class: 'actions', style: 'margin-top:4px' },
      btn('Ask for their details', 'roads:npcAsk', talkable && !n.given),
      btn('Warn them', 'roads:npcWarn', talkable && !n.given),
      btn('Ask them to step out', 'roads:npcStepOut', n.state === 'stopped'),
      btn('Check details on PNC', 'roads:npcPnc', !!n.given),
      btn('Mobile fingerprint check', 'roads:npcFingerprint', n.canFingerprint && talkable && !n.fingerprint)));

    if (n.given) {
      box.append(h('h3', {}, 'Details given'), h('dl', { class: 'facts' },
        h('dt', {}, 'Name'), h('dd', {}, n.given.name), h('dt', {}, 'Date of birth'), h('dd', {}, n.given.dob),
        h('dt', {}, 'Address'), h('dd', {}, n.given.address || '-')));
    }
    if (n.pnc) {
      box.append(h('h3', {}, 'PNC'));
      if (!n.pnc.found) box.append(h('p', {}, chip('No trace', 'amber'), ` No record for ${n.pnc.name}, born ${n.pnc.dob}.`));
      else {
        const lic = LICENCE[n.pnc.licence] || (n.pnc.licence === 'expired' ? ['Licence expired', 'amber'] : null);
        box.append(h('dl', { class: 'facts' },
          h('dt', {}, 'Licence'), h('dd', {}, lic ? chip(lic[0], lic[1]) : chip('No data'), n.pnc.points ? chip(`${n.pnc.points} points`, n.pnc.points >= 9 ? 'amber' : '') : null),
          h('dt', {}, 'Insured to drive'), h('dd', {}, n.pnc.insured ? chip('Yes', 'ok') : chip('No', 'red')),
          h('dt', {}, 'Wanted'), h('dd', {}, n.pnc.wanted ? chip(n.pnc.wanted, 'red') : chip('No', 'ok')),
          h('dt', {}, 'Address'), h('dd', {}, n.pnc.address || '-')));
      }
    }
    if (n.fingerprint) {
      box.append(h('h3', {}, 'Mobile fingerprint'));
      if (!n.fingerprint.match) box.append(h('p', {}, chip('No match', ''), ' Their prints are not on file.'));
      else box.append(h('p', {}, chip('Identified', 'ok'), ` ${n.fingerprint.name}, born ${n.fingerprint.dob}`,
        n.fingerprint.mismatch ? h('div', {}, chip('Does not match the details given', 'red')) : null,
        n.fingerprint.wanted ? h('div', {}, chip(`Wanted: ${n.fingerprint.wanted}`, 'red')) : null));
    }

    // Arrest
    if (n.state === 'arrested') {
      box.append(h('h3', {}, 'Prisoner'), h('p', { class: 'note' }, 'Transport takes them to the nearest custody suite to be booked in.'),
        h('button', { class: 'primary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('roads:npcHandover', { stop: stop.id });
          if (res.error) return message(box, res.error);
          done($('body'), `Prisoner transport is taking them to ${res.suite || 'custody'}. Stop ${res.ref} recorded.`);
        }); } }, 'Hand over to transport'));
    } else if (['stopped', 'out', 'surrendered'].includes(n.state)) {
      const form = h('form', { novalidate: true });
      const offences = offencePicker(n.offences, 'f-npc-off');
      const grounds = h('textarea', { id: 'f-npc-grounds', rows: 3, maxlength: 2000, placeholder: 'Why you suspect them.' });
      const cautioned = h('input', { type: 'checkbox' });
      const go = h('button', { class: 'primary', type: 'submit' }, 'Arrest');
      form.append(h('label', { for: 'f-npc-off' }, 'Offences'), offences.el, field('f-npc-grounds', 'Grounds', grounds),
        h('p', { class: 'caution' }, n.caution), h('label', { class: 'check' }, cautioned, "I've cautioned them"), go);
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        await busy(go, async () => {
          const res = await request('roads:npcArrest', { stop: stop.id, offences: offences.values(), grounds: grounds.value, cautioned: cautioned.checked });
          if (res.error) return message(form, res.error);
          task.data.npc = res.npc; task.said = res.said; draw();
        });
      });
      const det = h('details', {}, h('summary', { style: 'cursor:pointer;margin-top:16px;font:600 16px var(--head)' }, 'Arrest'), form);
      box.append(det);
    }
  };
  draw();
}

/* ---------- roadside ---------- */

const LICENCE = { valid: ['Full licence', 'ok'], provisional: ['Provisional only', 'amber'], disqualified: ['Disqualified', 'red'], none: ['No licence', 'red'] };
const chip = (text, level) => h('span', { class: `chip ${level || ''}` }, text);
const statusChip = (row) => row ? chip(row.text, row.ok ? 'ok' : (row.status === 'none' || row.status === 'void' || row.status === 'dangerous' ? 'red' : 'amber')) : chip('No data');

function renderRoadside(body, task) {
  const d = task.data, stop = d.stop;
  body.append(h('h2', {}, 'Vehicle stop'));
  body.append(h('p', { class: 'note' }, `${stop.ref}, started ${ukTime(stop.startedAt)}`));
  body.append(h('div', { class: 'plate-row' }, h('span', { class: 'plate' }, stop.plate), h('span', {}, d.modelLabel && d.modelLabel !== 'NULL' ? d.modelLabel : '')));

  const reason = select('f-rs-reason', d.reasons, 'Why did you stop it?');
  if (stop.reason) reason.value = stop.reason;
  reason.addEventListener('change', () => { if (reason.value) request('roads:reason', { stop: stop.id, reason: reason.value }); });
  body.append(field('f-rs-reason', 'Reason for the stop', reason));

  // Vehicle
  const v = d.vehicle || {};
  body.append(h('h3', {}, 'Vehicle'));
  const vf = h('dl', { class: 'facts' });
  if (!v.registered) vf.append(h('dt', {}, 'Keeper'), h('dd', {}, chip('No registered keeper', 'amber')));
  else if (v.keeper) {
    const lic = LICENCE[v.keeper.licence];
    vf.append(h('dt', {}, 'Keeper'), h('dd', {}, v.keeper.name || '-', h('br'),
      lic ? chip(lic[0], lic[1]) : null, v.keeper.points ? chip(`${v.keeper.points} points`, v.keeper.points >= 9 ? 'amber' : '') : null,
      v.keeper.wanted ? chip('Wanted', 'red') : null, v.keeper.bail ? chip('On bail', 'amber') : null));
  }
  if (v.insurance || v.mot || v.tax) {
    vf.append(h('dt', {}, 'Insurance'), h('dd', {}, statusChip(v.insurance), v.insurance && v.insurance.detail ? h('div', { class: 'note' }, v.insurance.detail) : null));
    vf.append(h('dt', {}, 'MOT'), h('dd', {}, statusChip(v.mot), v.mot && v.mot.detail ? h('span', { class: 'note' }, v.mot.detail) : null));
    vf.append(h('dt', {}, 'Tax'), h('dd', {}, statusChip(v.tax), v.tax && v.tax.detail ? h('span', { class: 'note' }, v.tax.detail) : null));
  }
  body.append(vf);
  if ((v.flags || []).length) body.append(h('div', { style: 'margin-top:8px' }, v.flags.map((f) => chip(f.label, f.level === 'red' ? 'red' : 'amber'))));
  if ((v.markers || []).length) body.append(h('div', {}, v.markers.map((m) => chip(m, 'red'))));
  if (d.npc && d.npc.defect) body.append(h('p', { style: 'margin-top:8px' }, chip('You notice', 'amber'), ` ${d.npc.defect}`));
  if (!d.npc) body.append(h('p', { class: 'note', style: 'margin-top:8px' },
    d.mdt ? 'From the MDT.' : (d.vehicleServices || d.licensing) ? `From ${[d.licensing && 'Licensing', d.vehicleServices && 'Vehicle Services'].filter(Boolean).join(' and ')}.` : 'No vehicle records system is running: only the keeper is shown.'));

  // Driver
  body.append(h('h3', {}, 'Driver'));
  const driverBox = h('div');
  if (d.npc) renderNpc(driverBox, task);
  else if (!d.candidates.length) driverBox.append(h('p', { class: 'note' }, 'Nobody at the vehicle to check.'));
  else {
    const who = select('f-rs-driver', d.candidates.map((c) => ({ value: String(c.src), label: c.note ? `${c.name} (${c.note})` : c.name })));
    const result = h('div');
    const check = h('button', { class: 'small', type: 'button', style: 'margin-top:8px', onclick: async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('roads:checkDriver', { stop: stop.id, target: Number(who.value) });
      result.replaceChildren();
      if (res.error) return message(result, res.error);
      const r = res.driver, lic = LICENCE[r.licence];
      const f = h('dl', { class: 'facts', style: 'margin-top:10px' });
      f.append(h('dt', {}, 'Name'), h('dd', {}, r.name || '-'));
      f.append(h('dt', {}, 'Licence'), h('dd', {}, lic ? chip(lic[0], lic[1]) : chip('No data'), r.categories ? h('span', { class: 'note' }, r.categories) : null,
        r.ban && r.ban.reason ? h('div', { class: 'note' }, `Disqualified: ${r.ban.reason}`) : null));
      f.append(h('dt', {}, 'Points'), h('dd', {}, r.points != null ? String(r.points) : '-'));
      f.append(h('dt', {}, 'Insured to drive'), h('dd', {}, r.insured === true ? chip('Yes', 'ok') : r.insured === false ? chip('No', 'red') : chip('No data')));
      if (r.wanted !== undefined) f.append(h('dt', {}, 'Wanted'), h('dd', {}, r.wanted ? chip('Wanted', 'red') : chip('No', 'ok')));
      if (r.bail) f.append(h('dt', {}, 'Bail'), h('dd', {}, chip('On bail', 'amber'), r.bailConditions ? h('div', { class: 'note' }, String(r.bailConditions)) : null));
      result.append(f);
      state.task.driverChecked = true;
    }); } }, 'Check driver');
    driverBox.append(field('f-rs-driver', 'Person', who), check, result);
  }
  body.append(driverBox);

  renderRoadsideKit(body, task);

  // Tickets
  if (d.fines) {
    body.append(h('h3', {}, 'Ticket'));
    const tform = h('form', { novalidate: true });
    let kind = 'FPN';
    const list = h('div', { class: 'picker', role: 'group', 'aria-label': 'Offences' });
    const other = h('input', { id: 'f-rs-other', maxlength: 160, placeholder: 'Any other offence, in words', autocomplete: 'off' });
    const otherWrap = field('f-rs-other', 'Other offence', other);
    const fill = () => {
      list.replaceChildren();
      for (const o of d.fines.filter((f) => kind === 'TOR' ? f.type !== 'PND' : f.type === 'FPN')) {
        const meta = kind === 'TOR' ? '' : ` (${d.currency}${o.amount}${o.points ? `, ${o.points} pts` : ''})`;
        list.append(h('label', { class: 'check' }, h('input', { type: 'checkbox', value: o.code }), `${o.code} ${o.label}${meta}`));
      }
      otherWrap.hidden = kind !== 'TOR';
    };
    const seg = h('div', { class: 'seg', role: 'group', 'aria-label': 'Type' });
    for (const [k, label] of [['FPN', 'Fixed penalty'], ['TOR', 'Traffic offence report']]) {
      seg.append(h('button', { type: 'button', 'aria-pressed': String(k === kind), onclick: (e) => {
        kind = k; seg.querySelectorAll('button').forEach((b) => b.setAttribute('aria-pressed', String(b === e.currentTarget))); fill();
      } }, label));
    }
    fill();
    const issue = h('button', { class: 'primary', type: 'submit' }, 'Issue');
    const issued = h('ul', { class: 'rows tickets' });
    for (const t of stop.tickets || []) issued.append(h('li', {}, `${t.ref} (${t.kind})`));
    tform.append(seg, h('div', { style: 'margin-top:8px' }, list), otherWrap, issue, issued);
    tform.addEventListener('submit', async (e) => {
      e.preventDefault();
      if (!d.npc && !state.task.driverChecked) return message(tform, 'Check the driver first, so the ticket goes to the right person.');
      if (d.npc && !d.npc.given) return message(tform, 'Get their details first, so the ticket goes to the right person.');
      await busy(issue, async () => {
        const res = await request('roads:ticket', {
          stop: stop.id, kind, codes: [...list.querySelectorAll('input:checked')].map((i) => i.value), other: other.value,
        });
        if (res.error) return message(tform, res.error);
        list.querySelectorAll('input:checked').forEach((i) => { i.checked = false; });
        other.value = '';
        issued.append(h('li', {}, `${res.ref} (${kind}${kind === 'FPN' ? `, ${res.currency || d.currency}${res.amount}` : ''})`,
          ...(res.endorsed || []).map((x) => h('div', { class: 'note' }, x))));
        message(tform, `${kind === 'TOR' ? 'Traffic offence report' : 'Fixed penalty'} ${res.ref} issued.`, 'success');
      });
    });
    body.append(tform);
  } else if (d.mdt) {
    body.append(h('h3', {}, 'Ticket'), h('p', { class: 'note' }, 'Issue fixed penalties from the MDT on this server (update the MDT to 2.18.1 to issue them here).'));
  }

  // End the stop
  body.append(h('h3', {}, 'End the stop'));
  const cform = h('form', { novalidate: true });
  const outcome = select('f-rs-outcome', d.outcomes, 'Choose the outcome');
  const notes = h('textarea', { id: 'f-rs-notes', rows: 3, maxlength: 1000, placeholder: 'Anything worth recording: advice given, defects, what the driver said.' });
  const end = h('button', { class: 'primary', type: 'submit' }, 'End stop');
  cform.append(field('f-rs-outcome', 'Outcome', outcome), field('f-rs-notes', 'Notes', notes), end);
  cform.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(end, async () => {
      const res = await request('roads:close', { stop: stop.id, outcome: outcome.value, reason: reason.value || undefined, notes: notes.value });
      if (res.error) return message(cform, res.error);
      done(body, `Stop ${res.ref} recorded.`);
    });
  });
  body.append(cform);
}


/* Search, tests and seizure, added to the roadside panel. */
function renderRoadsideKit(body, task) {
  const d = task.data, stop = d.stop;

  // Search
  body.append(h('h3', {}, 'Search'));
  const sbox = h('div');
  if (!d.npc) {
    const force = h('div', { hidden: true });
    const reason = h('input', { id: 'f-rs-force', maxlength: 255, placeholder: 'Why you need to get in', autocomplete: 'off' });
    force.append(field('f-rs-force', 'Reason for forcing entry', reason),
      h('button', { class: 'small', type: 'button', style: 'margin-top:8px', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('roads:forceEntry', { stop: stop.id, reason: reason.value });
        if (res.error) return message(sbox, res.error);
        force.hidden = true; message(sbox, res.message, 'success');
      }); } }, 'Force entry'));
    const open = (part) => async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('roads:searchVehicle', { stop: stop.id, part });
      if (res.error) { if (/locked/i.test(res.error)) force.hidden = false; return message(sbox, res.error); }
    }); };
    sbox.append(h('div', { class: 'actions', style: 'margin-top:0' },
      h('button', { class: 'small', type: 'button', disabled: !d.oxInventory, onclick: open('boot') }, 'Open the boot'),
      h('button', { class: 'small', type: 'button', disabled: !d.oxInventory, onclick: open('glovebox') }, 'Open the glovebox')), force);
    sbox.append(h('p', { class: 'note', style: 'margin-top:6px' }, 'Glovebox: sit in the vehicle first.'));
  } else {
    const results = h('div');
    const show = (what, finds) => {
      results.replaceChildren(h('p', { class: 'note' }, what === 'person' ? 'On them:' : 'In the vehicle:'));
      if (!finds.length) return results.append(h('p', {}, 'Nothing of note.'));
      const ul = h('ul', { class: 'rows' });
      finds.forEach((f, i) => ul.append(h('li', {}, h('span', {}, f.label, f.exhibit ? h('div', { class: 'note' }, `Exhibit ${f.exhibit}`) : null),
        f.seized ? chip('Seized', 'ok') : h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('roads:npcSeize', { stop: stop.id, what, index: i + 1 });
          if (res.error) return message(results, res.error);
          show(what, res.finds);
        }); } }, 'Seize'))));
      results.append(ul);
    };
    const search = (what) => async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('roads:npcSearch', { stop: stop.id, what });
      if (res.error) return message(sbox, res.error);
      show(what, res.finds);
    }); };
    sbox.append(h('div', { class: 'actions', style: 'margin-top:0' },
      h('button', { class: 'small', type: 'button', onclick: search('vehicle') }, 'Search the vehicle'),
      h('button', { class: 'small', type: 'button', onclick: search('person') }, 'Search them'),
      h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('stopsearch:prepare', {});
        if (res.error) return message(sbox, res.error);
        res.prefillDescription = (d.npc && d.npc.given && d.npc.given.name) || '';
        state.task = { name: 'stopsearch', target: null, data: res, location: task.location };
        render();
      }); } }, 'Record stop and search')), results);
  }
  body.append(sbox);

  // Tests
  body.append(h('h3', {}, 'Breath and drug tests'));
  const tbox = h('div');
  const tlist = h('ul', { class: 'rows' });
  const drawTests = () => {
    tlist.replaceChildren();
    for (const t of d.tests || []) {
      let text;
      if (t.outcome === 'refused') text = chip('Refused', 'red');
      else if (t.kind === 'breath') text = chip(`${t.outcome === 'fail' ? 'Fail' : 'Pass'}: ${t.reading} µg (limit ${t.limit})`, t.outcome === 'fail' ? 'red' : 'ok');
      else text = chip(t.outcome === 'fail' ? `Positive: ${t.substance}` : 'Negative', t.outcome === 'fail' ? 'red' : 'ok');
      tlist.append(h('li', {}, h('span', {}, t.kind === 'breath' ? 'Breath test' : 'Drug wipe', h('div', { class: 'note' }, ukTime(t.at))), text));
    }
  };
  drawTests();
  const test = (kind) => async (e) => { await busy(e.currentTarget, async () => {
    if (!d.npc) message(tbox, kind === 'breath' ? 'Waiting for them to provide a specimen…' : 'Waiting for them to give a sample…', 'success');
    const res = await request('roads:test', { stop: stop.id, kind });
    message(tbox, null);
    if (res.error) return message(tbox, res.error);
    d.tests = [...(d.tests || []), res.result];
    drawTests();
  }); };
  tbox.append(h('div', { class: 'actions', style: 'margin-top:0' },
    h('button', { class: 'small', type: 'button', onclick: test('breath') }, 'Breath test'),
    h('button', { class: 'small', type: 'button', onclick: test('drug') }, 'Drug wipe')), tlist);
  body.append(tbox);

  // Seizure
  if (d.canSeize) {
    body.append(h('h3', {}, 'Seize vehicle'));
    const sz = h('form', { novalidate: true });
    if (d.seizure) sz.append(h('p', {}, chip(`Seized: ${d.seizure}`, 'ok')));
    else {
      const power = select('f-rs-power', (d.seizurePowers || []).map((p) => ({ value: p.id, label: p.label })), 'Choose the power');
      const reason = h('textarea', { id: 'f-rs-szreason', rows: 2, maxlength: 1000, placeholder: 'e.g. driver has no insurance; keeper not present to take the vehicle.' });
      const go = h('button', { class: 'primary danger', type: 'submit' }, 'Seize and request recovery');
      sz.append(field('f-rs-power', 'Power', power), field('f-rs-szreason', 'Reason', reason), go);
      sz.addEventListener('submit', async (e) => {
        e.preventDefault();
        await busy(go, async () => {
          const res = await request('roads:seize', { stop: stop.id, power: power.value, reason: reason.value });
          if (res.error) return message(sz, res.error);
          d.seizure = res.ref;
          sz.replaceChildren(h('p', {}, chip(`Seized: ${res.ref}`, 'ok')), h('p', { class: 'note' }, `Recovery will collect it in about ${res.delay} seconds. Get everyone out of it.`));
        });
      });
    }
    body.append(sz);
  }
}


/* ---------- scene kit ---------- */

function renderScene(body, task) {
  const d = task.data;
  body.append(h('h2', {}, 'Scene kit'));
  body.append(h('p', { class: 'note' }, `You have ${d.count} of ${d.max} out. Choose one to place: Enter puts it down, Q and E turn it, Backspace stops.`));
  const groups = [];
  for (const p of d.props) {
    let g = groups.find((x) => x.name === (p.group || 'Kit'));
    if (!g) { g = { name: p.group || 'Kit', items: [] }; groups.push(g); }
    g.items.push(p);
  }
  for (const g of groups) {
    body.append(h('h3', {}, g.name));
    const grid = h('div', { class: 'statuses' });
    for (const p of g.items) {
      grid.append(h('button', { type: 'button', style: '--tone:var(--blue)', onclick: () => {
        fetch(`https://${resource}/scenePick`, { method: 'POST', body: JSON.stringify({ id: p.id }) }).catch(() => {});
        $('hub').hidden = true; state.task = null;
      } }, p.label));
    }
    body.append(grid);
  }

  body.append(h('h3', {}, 'Traffic'));
  const seg = h('div', { class: 'seg', role: 'group', 'aria-label': 'Traffic' });
  for (const [m, label] of [['none', 'Normal'], ['slow', 'Slow past the scene'], ['closed', 'Road closed']]) {
    seg.append(h('button', { type: 'button', 'aria-pressed': String(d.mode === m), onclick: async () => {
      const res = await request('scene:traffic', { mode: m });
      if (res.error) return message(body, res.error);
      d.mode = res.mode;
      seg.querySelectorAll('button').forEach((b, i) => b.setAttribute('aria-pressed', String(['none', 'slow', 'closed'][i] === d.mode)));
    } }, label));
  }
  body.append(seg, h('p', { class: 'note', style: 'margin-top:6px' }, 'Applies to local traffic around the props you have out.'));

  body.append(h('button', { class: 'secondary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
    const res = await request('scene:clear');
    if (res.error) return message(body, res.error);
    d.count = 0; d.mode = 'none'; render();
    message($('body'), 'All your scene kit has been picked up.', 'success');
  }); } }, 'Pick everything up'));
}


/* ---------- custody ---------- */

function custodySide(side, d, reload) {
  const people = list(d.detainees);
  const booked = people.filter((p) => p.booked).length;
  const overdue = people.filter((p) => p.welfareOverdue).length;
  side.append(h('h3', {}, d.suite.label),
    h('div', { class: 'pc-stats' },
      h('div', {}, h('b', {}, String(people.length)), h('span', {}, 'in custody')),
      h('div', {}, h('b', {}, String(list(d.cells).filter((c) => c.free).length)), h('span', {}, 'cells free')),
      h('div', { style: overdue ? 'border-color:var(--danger)' : '' }, h('b', { style: overdue ? 'color:#ffb3b1' : '' }, String(overdue)), h('span', {}, 'welfare overdue'))),
    d.cameraCount ? h('button', { class: 'primary', type: 'button', style: 'width:100%;margin:0 0 4px', onclick: () => nui('custodyCctv', {}) }, `Watch CCTV (${d.cameraCount} cameras)`) : null,
    h('h3', {}, 'Cells'));
  const board = h('div', { class: 'cellboard' });
  for (const c of list(d.cells)) {
    const tile = h('div', { class: `celltile${c.free ? '' : ' occupied'}${c.welfareOverdue ? ' overdue' : ''}${c.out ? ' out' : ''}` },
      h('div', { class: 'cn' }, c.label, c.risk ? chip(c.risk, c.risk === 'high' ? 'red' : c.risk === 'medium' ? 'amber' : '') : null),
      h('div', { class: `who${c.free ? ' free' : ''}` }, c.free ? 'Free' : `${c.occupant || 'Occupied'}${c.npc ? ' (NPC)' : ''}`),
      c.out ? h('div', { class: 'note', style: 'font-size:12px' }, `Out: ${c.out}`) : null);
    const tools = h('div', { class: 'tiletools' });
    if (c.buzzing) {
      tile.classList.add('buzzing');
      tools.append(h('button', { class: 'doorbtn call', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('custody:buzzer', { suite: d.suite.id, cell: c.id, op: 'answer' });
        if (res.error) return message(side, res.error);
        await reload();
      }); } }, 'Answer call'));
    }
    if (d.buzzer) {
      tools.append(h('button', { class: `iconbtn${c.muted ? ' on' : ''}`, type: 'button', title: c.muted ? 'Buzzer muted: unmute' : 'Mute this cell\'s buzzer',
        onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('custody:buzzer', { suite: d.suite.id, cell: c.id, op: 'mute', muted: !c.muted });
          if (res.error) return message(side, res.error);
          await reload();
        }); } }, c.muted ? '🔕' : '🔔'));
    }
    if (c.camera) tools.append(h('button', { class: 'iconbtn', type: 'button', title: 'Watch this cell', onclick: () => nui('custodyCctv', { camera: c.camera }) }, '📹'));
    if (c.door) {
      tile.append(h('button', { class: `doorbtn ${c.door}`, type: 'button', title: 'Door release',
        onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('custody:door', { suite: d.suite.id, cell: c.id, desk: true });
          if (res.error) return message(side, res.error);
          await reload();
        }); } }, c.door === 'locked' ? 'Locked · release' : 'Open · lock'));
    }
    if (tools.childNodes.length) tile.append(tools);
    board.append(tile);
  }
  if (!list(d.cells).length) board.append(h('p', { class: 'note' }, 'No cells set up.'));
  side.append(board);
  const calls = list(d.cells).filter((c) => c.buzzing).length;
  if (calls) side.prepend(h('div', { class: 'callbanner' }, `${calls} cell call${calls > 1 ? 's' : ''} waiting`));
}

function renderCustody(root, task) {
  const d = task.data;
  task.open = task.open || {};
  // Desk computer: cells board on the left, detainees on the right
  const side = h('aside', { class: 'pc-side' });
  const body = h('div', { class: 'pc-main' });
  root.append(h('div', { class: 'pc-layout' }, side, body));
  const reload = async () => {
    const res = await request('custody:panel');
    if (res.error) return message(body, res.error);
    task.data = res; state.data = res; render();
  };
  custodySide(side, d, reload);
  body.append(h('h2', {}, 'Detainees'));
  if (!d.canBook) body.append(h('p', { class: 'warn' }, `You can't book people in: ${(d.canBookWhy || 'not allowed for your rank').replace(/\.+$/, '')}. Cells and welfare checks still work.`));
  for (const n of list(d.notArrested)) {
    body.append(h('div', { class: 'card alert' }, h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, n.name), chip('Not under arrest', 'amber')),
      h('p', { class: 'note', style: 'margin:4px 0' }, 'They\'re handcuffed here but haven\'t been arrested, so they can\'t be booked in yet.'),
      h('button', { class: 'small', type: 'button', onclick: async () => {
        const res = await request('arrest:prepare', { target: n.src });
        if (res.error) return message(body, res.error);
        state.task = { name: 'arrest', data: res }; state.data = res; render();
      } }, 'Arrest them')));
  }
  if (d.mdt) body.append(h('p', { class: 'note' }, 'Record charge, bail, NFA and remand on the MDT. People are released from here automatically.'));
  if (!d.detainees.length && !list(d.notArrested).length) body.append(h('p', { class: 'note' }, 'Nobody in custody here. People you\'ve arrested show here once they\'re in the custody suite.'));

  for (const p of d.detainees) {
    if (p.npc) { body.append(npcCustodyCard(d, task, p, reload)); continue; }
    const card = h('div', { class: `card${p.welfareOverdue ? ' alert' : ''}` });
    const chips = [];
    if (!p.booked) chips.push(chip('Not booked in', 'amber'));
    else {
      chips.push(chip(p.cell ? p.cell : 'Not in a cell', p.cell ? '' : 'amber'));
      if (p.out) chips.push(chip(`Out: ${p.out}`, 'amber'));
      chips.push(chip(`Risk ${p.booked.risk}`, p.booked.risk === 'high' ? 'red' : p.booked.risk === 'medium' ? 'amber' : ''));
      chips.push(chip(`Obs ${p.booked.observation}`));
      if (p.welfareDue && !p.out) chips.push(chip(p.welfareOverdue ? 'Welfare OVERDUE' : `Welfare due ${ukTime(p.welfareDue)}`, p.welfareOverdue ? 'red' : 'ok'));
    }
    if (p.cuffed) chips.push(chip('Handcuffed'));
    chips.push(chip(`${p.hours} / ${p.limit} custody hrs`, p.hours >= p.limit ? 'red' : p.hours >= p.limit * 0.75 ? 'amber' : ''));
    card.append(h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, p.name), h('span', { class: 'note' }, p.ref || '')),
      h('p', { class: 'note', style: 'margin:2px 0 6px' }, `${(p.offences || []).join('; ')}. Arrested ${ukTime(p.at)} by ${p.byLabel || '?'}`),
      h('div', {}, chips));

    const act = (action, extra, okText) => async (e) => { await busy(e.currentTarget, async () => {
      const res = await request(action, Object.assign({ target: p.src }, extra ? extra() : {}));
      if (res.error) return message(card, res.error);
      task.open[p.src] = null;
      await reload();
      if (okText || res.message) message($('body'), res.message || okText, 'success');
    }); };
    const toggle = (name) => () => { task.open[p.src] = task.open[p.src] === name ? null : name; render(); };
    const btn = (label, fn, show) => show ? h('button', { class: 'small', type: 'button', onclick: fn }, label) : null;
    const free = d.cells.filter((c) => c.free || c.id === p.cellId);

    card.append(h('div', { class: 'actions', style: 'margin-top:8px' },
      !p.booked ? h('button', { class: 'small', type: 'button', disabled: !d.canBook, title: d.canBook ? '' : (d.canBookWhy || ''), onclick: toggle('book'), style: d.canBook ? 'border-color:var(--blue)' : '' }, 'Book in') : null,
      btn('Take property', act('custody:takeProperty', null, 'Property taken and bagged.'), p.booked && d.canStash && !p.property),
      btn('Open property bag', act('custody:openProperty'), p.property),
      btn(p.cell ? 'Move cell' : 'Place in cell', toggle('cell'), p.booked && !p.out),
      btn('Take out of cell', toggle('out'), p.cell && !p.out),
      btn('Return to cell', act('custody:back', null, 'Back in the cell.'), p.cell && p.out),
      btn('Welfare check', toggle('welfare'), p.booked),
      btn('Release', toggle('release'), d.canBook),
      btn('Custody log', toggle('log'), true)));

    const open = task.open[p.src];
    const f = h('div', { class: 'inline-form' });
    if (open === 'book') {
      const grounds = select(`g-${p.src}`, d.grounds, 'Grounds for detention');
      const risk = select(`r-${p.src}`, [{ value: 'low', label: 'Low' }, { value: 'medium', label: 'Medium' }, { value: 'high', label: 'High' }]);
      const obs = select(`o-${p.src}`, d.observation.map((o) => ({ value: String(o.level), label: o.label })));
      const rights = h('input', { type: 'checkbox' });
      const notes = h('textarea', { rows: 2, maxlength: 500, placeholder: 'Anything else from the booking in (injuries seen, requests made).' });
      f.append(field(`g-${p.src}`, 'Grounds', grounds), field(`r-${p.src}`, 'Risk assessment', risk), field(`o-${p.src}`, 'Observation level', obs),
        h('label', { class: 'check', style: 'margin-top:10px' }, rights, 'Rights given: free legal advice, someone informed, codes of practice'),
        h('label', {}, 'Notes'), notes,
        h('div', { class: 'actions' },
          h('button', { class: 'primary', type: 'button', onclick: act('custody:bookIn', () => ({ grounds: grounds.value, risk: risk.value, observation: Number(obs.value), rights: rights.checked, notes: notes.value }), 'Booked in.') }, 'Authorise detention'),
          h('button', { class: 'secondary', type: 'button', onclick: act('custody:bookIn', () => ({ authorise: false, notes: notes.value }), 'Detention not authorised: released.') }, 'Not authorised')));
    } else if (open === 'cell') {
      const cell = select(`c-${p.src}`, free.map((c) => ({ value: c.id, label: c.label })));
      f.append(field(`c-${p.src}`, 'Cell', cell), h('button', { class: 'primary', type: 'button', onclick: act('custody:cell', () => ({ cell: cell.value }), 'In the cell.') }, 'Put them in'));
    } else if (open === 'out') {
      const why = select(`w-${p.src}`, d.outReasons);
      f.append(field(`w-${p.src}`, 'Reason', why), h('button', { class: 'primary', type: 'button', onclick: act('custody:out', () => ({ reason: why.value }), 'Out of the cell.') }, 'Take them out'));
    } else if (open === 'welfare') {
      const rousable = h('input', { type: 'checkbox', checked: true });
      const note = h('input', { maxlength: 500, placeholder: 'e.g. asked for water, given', autocomplete: 'off' });
      let obs = null;
      if (d.canBook) {
        obs = select(`ob-${p.src}`, d.observation.map((o) => ({ value: String(o.level), label: o.label })));
        obs.value = String(p.booked.observation);
      }
      f.append(h('label', { class: 'check' }, rousable, 'Roused and responsive'), field(`n-${p.src}`, 'Note', note), obs ? field(`ob-${p.src}`, 'Observation level', obs) : null,
        h('button', { class: 'primary', type: 'button', onclick: act('custody:welfare', () => ({ rousable: rousable.checked, note: note.value, observation: obs ? Number(obs.value) : undefined }), 'Welfare check recorded.') }, 'Record check'));
    } else if (open === 'release') {
      const outcome = select(`x-${p.src}`, d.outcomes, 'Outcome');
      const notes = h('input', { maxlength: 500, placeholder: 'Optional', autocomplete: 'off' });
      f.append(field(`x-${p.src}`, 'Outcome', outcome), field(`xn-${p.src}`, 'Notes', notes),
        d.mdt ? h('p', { class: 'note' }, 'Use this when the MDT can\'t release them, e.g. detention not authorised.') : null,
        h('button', { class: 'primary danger', type: 'button', onclick: act('custody:release', () => ({ outcome: outcome.value, notes: notes.value }), 'Released.') }, 'Release'));
    } else if (open === 'log') {
      const ul = h('ul', { class: 'log' }, h('li', { class: 'note' }, 'Loading…'));
      f.append(ul);
      request('custody:log', { target: p.src }).then((res) => {
        ul.replaceChildren();
        if (res.error) return ul.append(h('li', {}, res.error));
        for (const r of res.log) ul.append(h('li', {}, h('span', { class: 'when' }, ukDateTime(r.created_at)), r.text, r.officer ? h('span', { class: 'note' }, ` (${r.officer})`) : null));
        if (!res.log.length) ul.append(h('li', { class: 'note' }, 'Nothing logged yet.'));
      });
    }
    if (open) card.append(f);
    body.append(card);
  }

  if ((d.nearProperty || []).length) {
    body.append(h('h3', {}, 'Property to return'));
    const ul = h('ul', { class: 'rows' });
    for (const p of d.nearProperty) {
      ul.append(h('li', {}, h('span', {}, p.name, h('div', { class: 'note' }, `${p.bags} property bag${p.bags === 1 ? '' : 's'} held`)),
        h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('custody:returnProperty', { target: p.src });
          if (res.error) return message(body, res.error);
          await reload(); message($('body'), res.message, 'success');
        }); } }, 'Return property')));
    }
    body.append(ul);
  }
  body.append(h('button', { class: 'secondary', type: 'button', onclick: (e) => busy(e.currentTarget, reload) }, 'Refresh'));
}


/* An NPC detainee's card: same actions, sent to custody:npc, with interview and NPC outcomes. */
function npcCustodyCard(d, task, p, reload) {
  const key = p.key;
  const card = h('div', { class: `card${p.welfareOverdue ? ' alert' : ''}` });
  const chips = [chip('NPC')];
  if (!p.booked) chips.push(chip('Awaiting booking in', 'amber'));
  else {
    chips.push(chip(p.cell ? p.cell : 'Not in a cell', p.cell ? '' : 'amber'));
    if (p.out) chips.push(chip(`Out: ${p.out}`, 'amber'));
    chips.push(chip(`Risk ${p.booked.risk}`, p.booked.risk === 'high' ? 'red' : p.booked.risk === 'medium' ? 'amber' : ''));
    if (p.welfareDue && !p.out) chips.push(chip(p.welfareOverdue ? 'Welfare OVERDUE' : `Welfare due ${ukTime(p.welfareDue)}`, p.welfareOverdue ? 'red' : 'ok'));
  }
  chips.push(chip(`${p.hours} / ${p.limit} custody hrs`, p.hours >= p.limit ? 'red' : p.hours >= p.limit * 0.75 ? 'amber' : ''));
  card.append(h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, p.name), h('span', { class: 'note' }, p.ref || '')),
    h('p', { class: 'note', style: 'margin:2px 0 6px' }, `${(p.offences || []).join('; ')}. Arrested ${ukTime(p.at)} by ${p.byLabel || '?'}`),
    h('div', {}, chips));

  // Evidence carried over from the stop
  const ev = p.evidence || {};
  const evLines = [];
  for (const x of ev.exhibits || []) evLines.push(`Exhibit ${x.ref}: ${x.label}`);
  for (const t of ev.tests || []) {
    if (t.outcome === 'refused') evLines.push(`${t.kind === 'breath' ? 'Breath test' : 'Drug wipe'}: refused`);
    else if (t.outcome === 'fail') evLines.push(t.kind === 'breath' ? `Breath test: fail, ${t.reading} µg` : `Drug wipe: positive, ${t.substance}`);
  }
  if (ev.fingerprint && ev.fingerprint.match && ev.fingerprint.mismatch) evLines.push('Gave false details (identified by fingerprints)');
  if (evLines.length) card.append(h('ul', { class: 'log', style: 'max-height:none' }, evLines.map((x) => h('li', {}, x))));
  if (p.interview) card.append(h('p', { style: 'margin:8px 0 0' }, chip(p.interview.result === 'admits' ? 'Admitted' : p.interview.result === 'denies' ? 'Denied' : 'No comment',
    p.interview.result === 'admits' ? 'ok' : ''), ` ${p.interview.summary}`));

  const act = (action, extra, okText) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request('custody:npc', Object.assign({ id: p.id, action }, extra ? extra() : {}));
    if (res.error) return message(card, res.error);
    task.open[key] = null;
    await reload();
    if (okText) message($('body'), okText, 'success');
  }); };
  const toggle = (name) => () => { task.open[key] = task.open[key] === name ? null : name; render(); };
  const btn = (label, fn, show) => show ? h('button', { class: 'small', type: 'button', onclick: fn }, label) : null;
  const free = d.cells.filter((c) => c.free || c.id === p.cellId);

  card.append(h('div', { class: 'actions', style: 'margin-top:8px' },
    btn('Book in', toggle('book'), !p.booked && d.canBook),
    btn(p.cell ? 'Move cell' : 'Place in cell', toggle('cell'), p.booked && !p.out),
    btn('Take out of cell', toggle('out'), p.cell && !p.out),
    btn('Interview', act('interview', null, 'Interview recorded.'), p.out === 'Interview' && !p.interview),
    btn('Return to cell', act('back', null, 'Back in the cell.'), p.cell && p.out),
    btn('Welfare check', toggle('welfare'), p.booked),
    btn('Outcome', toggle('outcome'), d.canBook),
    btn('Custody log', toggle('log'), true)));

  const open = task.open[key];
  const f = h('div', { class: 'inline-form' });
  if (open === 'book') {
    const grounds = select(`g-${key}`, d.grounds, 'Grounds for detention');
    const risk = select(`r-${key}`, [{ value: 'low', label: 'Low' }, { value: 'medium', label: 'Medium' }, { value: 'high', label: 'High' }]);
    const obs = select(`o-${key}`, d.observation.map((o) => ({ value: String(o.level), label: o.label })));
    const rights = h('input', { type: 'checkbox' });
    f.append(field(`g-${key}`, 'Grounds', grounds), field(`r-${key}`, 'Risk assessment', risk), field(`o-${key}`, 'Observation level', obs),
      h('label', { class: 'check', style: 'margin-top:10px' }, rights, 'Rights given: free legal advice, someone informed, codes of practice'),
      h('div', { class: 'actions' },
        h('button', { class: 'primary', type: 'button', onclick: act('bookIn', () => ({ grounds: grounds.value, risk: risk.value, observation: Number(obs.value), rights: rights.checked }), 'Booked in.') }, 'Authorise detention'),
        h('button', { class: 'secondary', type: 'button', onclick: act('bookIn', () => ({ authorise: false }), 'Detention not authorised: released.') }, 'Not authorised')));
  } else if (open === 'cell') {
    const cell = select(`c-${key}`, free.map((c) => ({ value: c.id, label: c.label })));
    f.append(field(`c-${key}`, 'Cell', cell), h('button', { class: 'primary', type: 'button', onclick: act('cell', () => ({ cell: cell.value }), 'In the cell.') }, 'Put them in'));
  } else if (open === 'out') {
    const why = select(`w-${key}`, d.outReasons);
    f.append(field(`w-${key}`, 'Reason', why), h('button', { class: 'primary', type: 'button', onclick: act('out', () => ({ reason: why.value }), 'Out of the cell.') }, 'Take them out'));
  } else if (open === 'welfare') {
    const note = h('input', { maxlength: 500, placeholder: 'e.g. asked for water, given', autocomplete: 'off' });
    let obs = null;
    if (d.canBook) { obs = select(`ob-${key}`, d.observation.map((o) => ({ value: String(o.level), label: o.label }))); obs.value = String(p.booked.observation); }
    f.append(field(`n-${key}`, 'Note', note), obs ? field(`ob-${key}`, 'Observation level', obs) : null,
      h('button', { class: 'primary', type: 'button', onclick: act('welfare', () => ({ note: note.value, observation: obs ? Number(obs.value) : undefined }), 'Welfare check recorded.') }, 'Record check'));
  } else if (open === 'outcome') {
    const outcome = select(`x-${key}`, d.npcOutcomes || [], 'Outcome');
    f.append(field(`x-${key}`, 'Outcome', outcome), h('p', { class: 'note' }, 'A caution or community resolution needs an admission in interview.'),
      h('button', { class: 'primary danger', type: 'button', onclick: act('outcome', () => ({ outcome: outcome.value }), 'Outcome recorded.') }, 'Record outcome'));
  } else if (open === 'log') {
    const ul = h('ul', { class: 'log' }, h('li', { class: 'note' }, 'Loading…'));
    f.append(ul);
    request('custody:log', { npc: p.id }).then((res) => {
      ul.replaceChildren();
      if (res.error) return ul.append(h('li', {}, res.error));
      for (const r of res.log) ul.append(h('li', {}, h('span', { class: 'when' }, ukDateTime(r.created_at)), r.text, r.officer ? h('span', { class: 'note' }, ` (${r.officer})`) : null));
      if (!res.log.length) ul.append(h('li', { class: 'note' }, 'Nothing logged yet.'));
    });
  }
  if (open) card.append(f);
  return card;
}

/* ---------- evidence store ---------- */

const EV_STATUS = { seized: ['Seized', 'amber'], 'property store': ['In property store', 'ok'], forensics: ['At forensics', 'amber'], returned: ['Returned', ''], destroyed: ['Destroyed', ''] };

function renderEvidence(body, task) {
  const d = task.data;
  body.append(h('h2', {}, 'Evidence store'));
  const form = h('form', { novalidate: true });
  const q = h('input', { id: 'f-ev-q', value: d.q || '', placeholder: 'Reference, description, person or custody ref', autocomplete: 'off' });
  form.append(q);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const res = await request('evidence:list', { q: q.value });
    if (res.error) return message(body, res.error);
    task.data = res; state.data = res; render();
  });
  body.append(form);
  if (!d.exhibits.length) body.append(h('p', { class: 'note', style: 'margin-top:12px' }, d.q ? 'Nothing found.' : 'No exhibits yet.'));
  for (const x of d.exhibits) {
    const st = EV_STATUS[x.status] || [x.status, ''];
    const card = h('div', { class: 'card', style: 'margin-top:10px' });
    card.append(h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, x.ref), chip(st[0], st[1])),
      h('p', { style: 'margin:4px 0' }, x.description),
      h('p', { class: 'note', style: 'margin:0' }, [x.type, x.from && `from ${x.from}`, x.linked && `linked to ${x.linked}`].filter(Boolean).join(', ')),
      h('p', { class: 'note', style: 'margin:0' }, `Seized ${ukDateTime(x.at)} by ${x.officer || '?'}`));
    const set = (status, label) => async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('evidence:status', { id: x.id, status });
      if (res.error) return message(card, res.error);
      const again = await request('evidence:list', { q: d.q });
      task.data = again; state.data = again; render();
      message($('body'), `${x.ref}: ${label}.`, 'success');
    }); };
    const closed = x.status === 'returned' || x.status === 'destroyed';
    card.append(h('div', { class: 'actions', style: 'margin-top:8px' },
      x.bag && !closed ? h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const res = await request('evidence:open', { id: x.id }); if (res.error) message(card, res.error);
      }); } }, 'Open bag') : null,
      !closed && x.status !== 'property store' ? h('button', { class: 'small', type: 'button', onclick: set('property store', 'booked into the property store') }, 'Property store') : null,
      !closed && x.status !== 'forensics' ? h('button', { class: 'small', type: 'button', onclick: set('forensics', 'sent to forensics') }, 'Send to forensics') : null,
      !closed && d.canManage && x.bag ? h('button', { class: 'small', type: 'button', onclick: set('returned', 'returned to owner') }, 'Return to owner') : null,
      !closed && d.canManage ? h('button', { class: 'small', type: 'button', onclick: set('destroyed', 'destroyed') }, 'Destroy') : null));
    if ((x.continuity || []).length) {
      const det = h('details', { style: 'margin-top:8px' }, h('summary', { class: 'note', style: 'cursor:pointer' }, 'Continuity'),
        h('ul', { class: 'log' }, x.continuity.slice().reverse().map((c) => h('li', {}, h('span', { class: 'when' }, ukDateTime(c.at)), c.text, c.by ? h('span', { class: 'note' }, ` (${c.by})`) : null))));
      card.append(det);
    }
    body.append(card);
  }
}


/* ---------- callouts: person, call, call list ---------- */

const ENC_STATE = { idle: ['Calm', ''], armed: ['Armed', 'red'], fleeing: ['Running off', 'red'], hostile: ['Violent', 'red'], surrendered: ['Detained', 'ok'],
  arrested: ['Under arrest', 'ok'], released: ['Let go', ''], gone: ['Gone', ''] };

function renderPerson(body, task) {
  const p = task.data.person;
  body.append(h('h2', {}, p.roleLabel));
  if (p.call) body.append(h('p', { class: 'note' }, `${p.call.title} (${p.call.ref}) `,
    h('button', { class: 'linkish', type: 'button', onclick: async () => {
      const res = await request('call:open', { id: p.call.id });
      if (res.error) return message(body, res.error);
      state.task = { name: 'call', data: res }; state.data = res; render();
    } }, 'Open call')));
  const st = ENC_STATE[p.state] || [p.state, ''];
  body.append(h('p', {}, chip(st[0], st[1]), p.injured ? chip('Injured', 'amber') : null));
  if (p.statement) body.append(h('p', { class: 'caution' }, p.statement));
  if (task.said) body.append(h('p', { class: 'caution', style: 'border-left-color:var(--blue)' }, task.said));

  const act = (action, extra) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request(action, Object.assign({ id: p.id }, extra || {}));
    if (res.error) return message(body, res.error);
    if (action === 'enc:release') return done(body, 'You let them go.');
    if (action === 'enc:handover') return done(body, `Prisoner transport is taking them to ${res.suite || 'custody'}.`);
    task.data.person = res.person; task.said = res.said || null; render();
  }); };
  const btn = (label, action, show, extra) => show ? h('button', { class: 'small', type: 'button', onclick: act(action, extra) }, label) : null;
  const talk = ['idle', 'surrendered', 'arrested'].includes(p.state);
  body.append(h('div', { class: 'actions', style: 'margin-top:4px' },
    btn('Ask for their details', 'enc:ask', talk && !p.given),
    btn('Warn them', 'enc:warn', talk && !p.given),
    btn('Check details on PNC', 'enc:pnc', !!p.given),
    btn('Mobile fingerprint check', 'enc:fingerprint', p.canFingerprint && talk && !p.fingerprint),
    btn('Search them', 'enc:search', talk && !p.finds),
    btn('Breath test', 'enc:test', talk, { kind: 'breath' }),
    btn('Drug wipe', 'enc:test', talk, { kind: 'drug' }),
    btn('Let them go', 'enc:release', p.state !== 'arrested')));

  if (p.given) body.append(h('h3', {}, 'Details given'), h('dl', { class: 'facts' },
    h('dt', {}, 'Name'), h('dd', {}, p.given.name), h('dt', {}, 'Date of birth'), h('dd', {}, p.given.dob), h('dt', {}, 'Address'), h('dd', {}, p.given.address || '-')));
  if (p.pnc) {
    body.append(h('h3', {}, 'PNC'));
    if (!p.pnc.found) body.append(h('p', {}, chip('No trace', 'amber'), ` No record for ${p.pnc.name}, born ${p.pnc.dob}.`));
    else body.append(h('dl', { class: 'facts' },
      h('dt', {}, 'Address'), h('dd', {}, p.pnc.address || '-'),
      h('dt', {}, 'Licence'), h('dd', {}, (LICENCE[p.pnc.licence] && chip(LICENCE[p.pnc.licence][0], LICENCE[p.pnc.licence][1])) || chip(p.pnc.licence || 'No data')),
      h('dt', {}, 'Wanted'), h('dd', {}, p.pnc.wanted ? chip(p.pnc.wanted, 'red') : chip('No', 'ok'))));
  }
  if (p.fingerprint) {
    body.append(h('h3', {}, 'Mobile fingerprint'));
    body.append(p.fingerprint.match
      ? h('p', {}, chip('Identified', 'ok'), ` ${p.fingerprint.name}, born ${p.fingerprint.dob}`,
          p.fingerprint.mismatch ? h('div', {}, chip('Does not match the details given', 'red')) : null,
          p.fingerprint.wanted ? h('div', {}, chip(`Wanted: ${p.fingerprint.wanted}`, 'red')) : null)
      : h('p', {}, chip('No match'), ' Their prints are not on file.'));
  }
  if (p.finds) {
    body.append(h('h3', {}, 'Found on them'));
    if (!p.finds.length) body.append(h('p', {}, 'Nothing of note.'));
    else {
      const ul = h('ul', { class: 'rows' });
      p.finds.forEach((f, i) => ul.append(h('li', {}, h('span', {}, f.label, f.exhibit ? h('div', { class: 'note' }, `Exhibit ${f.exhibit}`) : null),
        f.seized ? chip('Seized', 'ok') : h('button', { class: 'small', type: 'button', onclick: act('enc:seize', { index: i + 1 }) }, 'Seize'))));
      body.append(ul);
    }
  }
  if ((p.tests || []).length) {
    body.append(h('h3', {}, 'Tests'));
    const ul = h('ul', { class: 'rows' });
    for (const t of p.tests) {
      const text = t.outcome === 'refused' ? chip('Refused', 'red') : t.kind === 'breath'
        ? chip(`${t.outcome === 'fail' ? 'Fail' : 'Pass'}: ${t.reading} µg`, t.outcome === 'fail' ? 'red' : 'ok')
        : chip(t.outcome === 'fail' ? `Positive: ${t.substance}` : 'Negative', t.outcome === 'fail' ? 'red' : 'ok');
      ul.append(h('li', {}, h('span', {}, t.kind === 'breath' ? 'Breath test' : 'Drug wipe'), text));
    }
    body.append(ul);
  }

  if (p.state === 'arrested') {
    body.append(h('h3', {}, 'Prisoner'), h('button', { class: 'primary', type: 'button', onclick: act('enc:handover') }, 'Hand over to transport'));
  } else if (p.state === 'idle' || p.state === 'surrendered') {
    const form = h('form', { novalidate: true });
    const offences = offencePicker(p.offences, 'f-enc-off');
    offences.el.querySelectorAll('input[type=checkbox]').forEach((i) => { if ((p.suggested || []).includes(i.value)) i.checked = true; });
    const grounds = h('textarea', { id: 'f-enc-grounds', rows: 3, maxlength: 2000, placeholder: 'Why you suspect them.' });
    const cautioned = h('input', { type: 'checkbox' });
    const go = h('button', { class: 'primary', type: 'submit' }, 'Arrest');
    form.append(h('label', { for: 'f-enc-off' }, 'Offences'), offences.el, field('f-enc-grounds', 'Grounds', grounds),
      h('p', { class: 'caution' }, p.caution), h('label', { class: 'check' }, cautioned, "I've cautioned them"), go);
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      await busy(go, async () => {
        const res = await request('enc:arrest', { id: p.id, offences: offences.values(), grounds: grounds.value, cautioned: cautioned.checked });
        if (res.error) return message(form, res.error);
        task.data.person = res.person; task.said = res.said || null; render();
      });
    });
    body.append(h('details', { open: p.role === 'suspect' && p.state === 'surrendered' }, h('summary', { style: 'cursor:pointer;margin-top:16px;font:600 16px var(--head)' }, 'Arrest'), form));
  }
}

function renderCall(body, task) {
  const c = task.data.call;
  body.append(h('h2', {}, c.title), h('p', { class: 'note' }, `${c.ref}, ${c.location}. Received ${ukTime(c.createdAt)}.`));
  if (c.description) body.append(h('p', {}, c.description));
  body.append(h('h3', {}, 'People'));
  if (!c.people.length) body.append(h('p', { class: 'note' }, c.status === 'pending' ? 'Not attended yet.' : 'Nobody left at the scene.'));
  else {
    const ul = h('ul', { class: 'rows' });
    for (const x of c.people) {
      const st = ENC_STATE[x.state] || [x.state, ''];
      ul.append(h('li', {}, h('span', {}, x.role, x.name ? h('div', { class: 'note' }, x.name) : null), chip(st[0], st[1])));
    }
    body.append(ul);
  }
  if (c.attending) {
    const backup = (urgent) => async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('call:backup', { id: c.id, urgent });
      if (res.error) return message(body, res.error);
      message(body, res.message, 'success');
    }); };
    body.append(h('div', { class: 'actions', style: 'margin-top:10px' },
      h('button', { class: 'small', type: 'button', onclick: backup(false) }, 'Request backup'),
      h('button', { class: 'small', type: 'button', style: 'border-color:var(--danger)', onclick: backup(true) }, 'Urgent assistance')));
  }
  if ((c.notes || []).length) body.append(h('h3', {}, 'Log'), h('ul', { class: 'log' },
    c.notes.slice().reverse().map((n) => h('li', {}, h('span', { class: 'when' }, ukTime(n.at)), n.text))));
  body.append(h('h3', {}, 'Close the call'));
  const form = h('form', { novalidate: true });
  const outcome = select('f-call-out', c.outcomes || [], 'Choose the outcome');
  const notes = h('textarea', { id: 'f-call-notes', rows: 3, maxlength: 1000, placeholder: 'What happened and what was done.' });
  const go = h('button', { class: 'primary', type: 'submit' }, 'Close call');
  const refer = h('input', { type: 'checkbox' });
  form.append(field('f-call-out', 'Outcome', outcome), field('f-call-notes', 'Notes', notes),
    h('label', { class: 'check', style: 'margin-top:10px' }, refer, 'Refer to CID (opens a case file with this call and any arrests linked)'), go);
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(go, async () => {
      const res = await request('call:close', { id: c.id, outcome: outcome.value, notes: notes.value, referCid: refer.checked });
      if (res.error) return message(form, res.error);
      done(body, `Call ${res.ref} closed.${res.mdt ? ` MDT incident ${res.mdt} created.` : ''}${res.case ? ` CID case ${res.case} opened.` : ''}`);
    });
  });
  body.append(form);
}

function renderCalls(body, task) {
  const d = task.data;
  body.append(h('h2', {}, 'Calls'));
  if (d.dispatch) body.append(h('p', { class: 'note' }, 'Calls also come through dispatch. Respond there or attach here.'));
  if (!d.calls.length) body.append(h('p', { class: 'note' }, 'No open calls.'));
  for (const c of d.calls) {
    const card = h('div', { class: 'card' });
    card.append(h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, c.title), chip(`P${c.priority}`, c.priority <= 1 ? 'red' : c.priority === 2 ? 'amber' : '')),
      h('p', { class: 'note', style: 'margin:2px 0' }, `${c.location}${c.distance != null ? `, ${c.distance} m away` : ''}. ${c.ref}`),
      c.description ? h('p', { style: 'margin:4px 0' }, c.description) : null,
      h('div', { class: 'actions', style: 'margin-top:6px' },
        h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
          const res = await request('call:attach', { id: c.id });
          if (res.error) return message(card, res.error);
          message(card, 'Attached. Route set.', 'success');
        }); } }, c.attending ? 'Set route' : 'Attach and set route'),
        h('button', { class: 'small', type: 'button', onclick: async () => {
          const res = await request('call:open', { id: c.id });
          if (res.error) return message(card, res.error);
          state.task = { name: 'call', data: res }; state.data = res; render();
        } }, 'Open')));
    body.append(card);
  }
}


/* ---------- location editor (admins) ---------- */

const nui = (name, body) => fetch(`https://${resource}/${name}`, { method: 'POST', body: JSON.stringify(body || {}) }).then((r) => r.json()).catch(() => ({}));
const fmtPos = (c) => c ? `${c.x.toFixed(1)}, ${c.y.toFixed(1)}, ${c.z.toFixed(1)}${c.w != null ? ` (${Math.round(c.w)}°)` : ''}` : 'Not set';
const LOC_SECTIONS = [['stations', 'Stations'], ['custody', 'Custody'], ['callouts', 'Callout places'], ['hostileZones', 'No-hostile zones'], ['uniforms', 'Uniforms']];
const POOL_LABELS = { shops: 'Shops', streets: 'Streets and parks', houses: 'Houses', roads: 'Roads' };

function locPreview(task) {
  const w = task.work, pts = [];
  const add = (c, label, kind) => { if (c) pts.push({ x: c.x, y: c.y, z: c.z, label, kind }); };
  if (task.section === 'stations') for (const st of w.stations || []) {
    if (st.signOn) add(st.signOn.coords, `${st.label}: sign on`);
    (st.lockers || []).forEach((l, i) => add(l.coords, `${st.label}: locker ${i + 1}`));
    (st.armouries || []).forEach((a, i) => add(a.coords, `${st.label}: armoury ${i + 1}`, 'cell'));
    (st.changingRooms || []).forEach((a, i) => add(a.coords, `${st.label}: changing room ${i + 1}`));
  }
  if (task.section === 'custody') for (const su of w.custody || []) {
    if (su.desk) add(su.desk.coords, `${su.label}: desk`);
    add(su.release, `${su.label}: release`);
    for (const c of su.cells || []) {
      add(c.coords, `${su.label}: ${c.label}`, 'cell');
      if (c.door) add(c.door.coords, `${c.label} door`);
    }
  }
  if (task.section === 'callouts') for (const [pool, list] of Object.entries(w.callouts || {})) for (const l of list) add(l.coords, `${POOL_LABELS[pool] || pool}: ${l.label}`);
  if (task.section === 'hostileZones') for (const z of w.hostileZones || []) add(z.coords, `${z.label || 'Zone'} (${Math.round(z.radius)} m)`, 'zone');
  nui('locPreview', { points: pts });
}

function renderLocations(body, task) {
  const d = task.data;
  task.work = task.work || JSON.parse(JSON.stringify(d.locations));
  task.section = task.section || d.section || 'stations';
  const w = task.work;

  body.append(h('h2', {}, 'Locations'));
  body.append(h('p', { class: 'note' }, 'Stand where it should go and press Here. Markers show what you\'re editing. Save applies it for everyone straight away.'));
  body.append(h('button', { class: 'secondary', type: 'button', style: 'margin:0 0 10px', onclick: () => nui('locWalk') }, 'Walk around (F7 to come back)'));
  const seg = h('div', { class: 'seg', role: 'group', 'aria-label': 'Section', style: 'flex-wrap:wrap' });
  for (const [key, label] of LOC_SECTIONS) {
    seg.append(h('button', { type: 'button', 'aria-pressed': String(task.section === key), onclick: () => { task.section = key; render(); } }, label));
  }
  body.append(seg);
  const saved = d.saved && d.saved[task.section];
  body.append(h('p', { class: 'note', style: 'margin-top:6px' }, saved ? `Set in game by ${saved.by || '?'}, ${ukDateTime(saved.at)}.` : 'Using the config file.'));

  const here = (apply) => async (e) => { await busy(e.currentTarget, async () => { const p = await nui('locMyPos'); if (p && p.x != null) { apply(p); render(); } }); };
  const go = (c) => () => nui('locTp', c);
  const posRow = (label, c, setFn, withHeading) => h('li', {},
    h('span', {}, label, h('div', { class: 'note' }, fmtPos(c))),
    h('span', { class: 'actions', style: 'margin:0' },
      h('button', { class: 'small', type: 'button', onclick: here((p) => setFn(withHeading ? { x: p.x, y: p.y, z: p.z, w: p.w } : { x: p.x, y: p.y, z: p.z }, p)) }, 'Here'),
      c ? h('button', { class: 'small', type: 'button', onclick: go(c) }, 'Go') : null));
  const labelInput = (obj, key, placeholder) => {
    const i = h('input', { value: obj[key] || '', maxlength: 80, placeholder, autocomplete: 'off' });
    i.addEventListener('change', () => { obj[key] = i.value; locPreview(task); });
    return i;
  };
  const remove = (list, item, label = 'Remove') => h('button', { class: 'linkish', type: 'button', onclick: () => { list.splice(list.indexOf(item), 1); render(); } }, label);

  const box = h('div', { style: 'margin-top:12px' });
  if (task.section === 'stations') {
    w.stations = w.stations || [];
    for (const st of w.stations) {
      st.lockers = st.lockers || [];
      const ul = h('ul', { class: 'rows' },
        posRow('Sign-on point', st.signOn && st.signOn.coords, (c, p) => { st.signOn = { coords: c, rotation: p.w, size: (st.signOn && st.signOn.size) || { x: 1.6, y: 1.0, z: 2.0 } }; }),
        ...st.lockers.map((l, i) => posRow(`Locker ${i + 1}`, l.coords, (c, p) => { l.coords = c; l.rotation = p.w; })),
        ...(st.armouries || []).map((a, i) => posRow(`Armoury ${i + 1}`, a.coords, (c, p) => { a.coords = c; a.rotation = p.w; })),
        ...(st.changingRooms || []).map((a, i) => posRow(`Changing room ${i + 1}`, a.coords, (c, p) => { a.coords = c; a.rotation = p.w; })));
      box.append(h('div', { class: 'card' }, labelInput(st, 'label', 'Station name'), ul,
        h('div', { class: 'actions' },
          h('button', { class: 'small', type: 'button', onclick: here((p) => st.lockers.push({ coords: { x: p.x, y: p.y, z: p.z }, rotation: p.w, size: { x: 2.0, y: 1.0, z: 2.0 } })) }, 'Add locker here'),
          st.lockers.length ? h('button', { class: 'small', type: 'button', onclick: () => { st.lockers.pop(); render(); } }, 'Remove last locker') : null,
          h('button', { class: 'small', type: 'button', onclick: here((p) => { st.armouries = st.armouries || []; st.armouries.push({ coords: { x: p.x, y: p.y, z: p.z }, rotation: p.w, size: { x: 2.0, y: 1.2, z: 2.0 } }); }) }, 'Add armoury here'),
          (st.armouries || []).length ? h('button', { class: 'small', type: 'button', onclick: () => { st.armouries.pop(); render(); } }, 'Remove last armoury') : null,
          h('button', { class: 'small', type: 'button', onclick: here((p) => { st.changingRooms = st.changingRooms || []; st.changingRooms.push({ coords: { x: p.x, y: p.y, z: p.z }, rotation: p.w, size: { x: 2.0, y: 2.0, z: 2.0 } }); }) }, 'Add changing room here'),
          (st.changingRooms || []).length ? h('button', { class: 'small', type: 'button', onclick: () => { st.changingRooms.pop(); render(); } }, 'Remove last changing room') : null,
          remove(w.stations, st, 'Remove station'))));
    }
    box.append(h('button', { class: 'secondary', type: 'button', onclick: here((p) => w.stations.push({ label: p.street || 'New station', signOn: { coords: { x: p.x, y: p.y, z: p.z }, rotation: p.w, size: { x: 1.6, y: 1.0, z: 2.0 } }, lockers: [] })) }, 'Add station (sign-on point here)'));
  }

  if (task.section === 'custody') {
    w.custody = w.custody || [];
    for (const su of w.custody) {
      su.cells = su.cells || [];
      const ul = h('ul', { class: 'rows' },
        posRow('Custody desk', su.desk && su.desk.coords, (c, p) => { su.desk = { coords: c, rotation: p.w, size: (su.desk && su.desk.size) || { x: 2.0, y: 1.2, z: 2.0 } }; }),
        posRow('Release point', su.release, (c) => { su.release = c; }, true));
      su.cells.forEach((cell) => {
        const name = labelInput(cell, 'label', 'Cell name');
        ul.append(h('li', { style: 'grid-template-columns:1fr' },
          h('div', { style: 'display:flex;gap:8px;align-items:center' }, name),
          h('div', { class: 'note' }, `${fmtPos(cell.coords)}. Door: ${cell.door ? 'set' : 'none (held without a door)'}`),
          h('div', { class: 'actions', style: 'margin:4px 0 0' },
            h('button', { class: 'small', type: 'button', onclick: here((p) => { cell.coords = { x: p.x, y: p.y, z: p.z, w: p.w }; }) }, 'Here'),
            h('button', { class: 'small', type: 'button', onclick: go(cell.coords) }, 'Go'),
            cell.door ? h('button', { class: 'linkish', type: 'button', onclick: () => { delete cell.door; render(); } }, 'Clear door') : null,
            remove(su.cells, cell))));
      });
      box.append(h('div', { class: 'card' }, labelInput(su, 'label', 'Suite name'), ul,
        su.id ? h('div', { class: 'actions' },
          h('button', { class: 'primary', style: 'margin-top:0', type: 'button', onclick: () => nui('locWorld', { mode: 'cells', suite: su.id }) }, 'Place cells in the world'),
          h('button', { class: 'secondary', style: 'margin-top:0', type: 'button', disabled: !su.cells.length, onclick: () => nui('locWorld', { mode: 'doors', suite: su.id }) }, 'Set cell doors in the world'),
          h('button', { class: 'secondary', style: 'margin-top:0', type: 'button', onclick: () => nui('locWorld', { mode: 'cameras', suite: su.id }) }, `Place cameras in the world (${(su.cameras || []).length})`),
          (su.cameras || []).length ? h('button', { class: 'linkish', type: 'button', onclick: () => { su.cameras = []; render(); } }, 'Remove all cameras') : null)
          : h('p', { class: 'note' }, 'Save this suite first, then place its cells and doors in the world.'),
        h('p', { class: 'note' }, 'In the world: walk the suite and keep going. Cells: E where the detainee should stand, facing their way. Doors: walk up to a cell door (it lights up), E. Cameras: fly the camera into the corner (WASD, mouse, scroll to zoom), E saves the view; one in a cell becomes that cell\'s camera. Z undoes, Enter saves and brings you back here, Backspace leaves without saving. Save anything else you changed here first.'),
        h('div', { class: 'actions' },
          h('button', { class: 'small', type: 'button', onclick: here((p) => {
            let n = su.cells.length + 1;
            while (su.cells.some((c) => c.id === `C${n}`)) n += 1;
            su.cells.push({ id: `C${n}`, label: `Cell ${n}`, coords: { x: p.x, y: p.y, z: p.z, w: p.w } });
          }) }, 'Add cell here'),
          remove(w.custody, su, 'Remove suite'))));
    }
    box.append(h('button', { class: 'secondary', type: 'button', onclick: here((p) => w.custody.push({
      label: 'New custody suite', desk: { coords: { x: p.x, y: p.y, z: p.z }, rotation: p.w, size: { x: 2.0, y: 1.2, z: 2.0 } },
      release: { x: p.x, y: p.y, z: p.z, w: p.w }, cells: [] })) }, 'Add custody suite (desk here)'));
    box.append(h('p', { class: 'note' }, 'A new suite starts with its release point at the desk: move it to the front door.'));
  }

  if (task.section === 'callouts') {
    if (!w.callouts || Array.isArray(w.callouts)) w.callouts = {};
    for (const pool of Object.keys(POOL_LABELS)) {
      const list = (w.callouts[pool] = w.callouts[pool] || []);
      const ul = h('ul', { class: 'rows' });
      for (const l of list) {
        ul.append(h('li', {}, h('span', {}, labelInput(l, 'label', 'Name'), h('div', { class: 'note' }, fmtPos(l.coords))),
          h('span', { class: 'actions', style: 'margin:0' },
            h('button', { class: 'small', type: 'button', onclick: here((p) => { l.coords = { x: p.x, y: p.y, z: p.z, w: p.w }; }) }, 'Here'),
            h('button', { class: 'small', type: 'button', onclick: go(l.coords) }, 'Go'),
            remove(list, l))));
      }
      box.append(h('h3', {}, `${POOL_LABELS[pool]} (${list.length})`), ul,
        h('button', { class: 'small', type: 'button', onclick: here((p) => list.push({ label: p.street || 'New place', coords: { x: p.x, y: p.y, z: p.z, w: p.w } })) }, 'Add here'));
    }
    box.append(h('p', { class: 'note', style: 'margin-top:10px' }, 'Shops: stand at the till. Houses: at the front door. Roads: on the road, facing the traffic. The heading you face is used to lay out the scene.'));
  }

  if (task.section === 'hostileZones') {
    w.hostileZones = w.hostileZones || [];
    const ul = h('ul', { class: 'rows' });
    for (const z of w.hostileZones) {
      const r = h('input', { type: 'number', min: 10, max: 1500, value: Math.round(z.radius || 100), style: 'width:80px' });
      r.addEventListener('change', () => { z.radius = Number(r.value) || 100; locPreview(task); });
      ul.append(h('li', {}, h('span', {}, labelInput(z, 'label', 'Name'), h('div', { class: 'note' }, fmtPos(z.coords))),
        h('span', { class: 'actions', style: 'margin:0' }, r, h('span', { class: 'note' }, 'm'),
          h('button', { class: 'small', type: 'button', onclick: here((p) => { z.coords = { x: p.x, y: p.y, z: p.z }; }) }, 'Here'),
          remove(w.hostileZones, z))));
    }
    box.append(h('p', { class: 'note' }, 'NPCs never fight officers inside these zones (busy areas, stations, hospitals).'), ul,
      h('button', { class: 'small', type: 'button', onclick: here((p) => w.hostileZones.push({ label: p.street || 'Zone', coords: { x: p.x, y: p.y, z: p.z }, radius: 150 })) }, 'Add zone here'));
  }
  if (task.section === 'uniforms') {
    w.uniforms = w.uniforms || [];
    box.append(h('p', { class: 'note' }, 'Dress your character in the uniform (any clothing script), then Save my clothes as the male or female version. Officers get the version that matches their character. Try on shows it on you; Own clothes puts yours back.'));
    for (const u of w.uniforms) {
      const name = labelInput(u, 'label', 'Uniform name');
      const rank = select(`u-rank-${u.id || Math.random()}`, [{ value: '', label: 'Any rank' }, ...(d.ranks || []).map((r) => ({ value: r.id, label: `${r.label} and above` }))]);
      rank.value = u.minRank || '';
      rank.addEventListener('change', () => { u.minRank = rank.value || undefined; });
      const unitBox = h('div', { class: 'picker', style: 'max-height:120px;margin-top:6px' });
      for (const un of d.units || []) {
        const cb = h('input', { type: 'checkbox', checked: (u.units || []).includes(un.id) });
        cb.addEventListener('change', () => {
          u.units = [...unitBox.querySelectorAll('input:checked')].map((i) => i.value);
          if (!u.units.length) delete u.units;
        });
        cb.value = un.id;
        unitBox.append(h('label', { class: 'check' }, cb, un.label));
      }
      const variant = (sex, title) => {
        const set = u[sex];
        return h('li', {}, h('span', {}, title, h('div', { class: 'note' }, set ? `${(set.components || []).length} clothing items, ${(set.props || []).length} props` : 'Not set')),
          h('span', { class: 'actions', style: 'margin:0' },
            h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
              const c = await nui('locOutfit');
              if (!c || !c.components) return;
              if ((sex === 'female') !== !!c.female) message(box, `Heads up: your character isn't ${sex}. Saved anyway.`, 'error');
              u[sex] = { components: c.components, props: c.props }; render();
            }); } }, 'Save my clothes'),
            set ? h('button', { class: 'small', type: 'button', onclick: () => nui('locTryOutfit', { set }) }, 'Try on') : null,
            set ? h('button', { class: 'linkish', type: 'button', onclick: () => { delete u[sex]; render(); } }, 'Clear') : null));
      };
      box.append(h('div', { class: 'card' }, name,
        h('label', {}, 'Who can wear it'), rank,
        h('p', { class: 'note', style: 'margin:6px 0 0' }, 'Only when signed on as (none ticked = any unit):'), unitBox,
        h('ul', { class: 'rows' }, variant('male', 'Male version'), variant('female', 'Female version')),
        remove(w.uniforms, u, 'Remove uniform')));
    }
    box.append(h('div', { class: 'actions' },
      h('button', { class: 'secondary', style: 'margin-top:0', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
        const c = await nui('locOutfit');
        if (!c || !c.components) return;
        const sex = c.female ? 'female' : 'male';
        w.uniforms.push({ label: 'New uniform', [sex]: { components: c.components, props: c.props } });
        render();
      }); } }, 'New uniform from my clothes'),
      h('button', { class: 'small', type: 'button', onclick: () => nui('locTryOutfit', { own: true }) }, 'Own clothes')));
  }
  body.append(box);

  const key = task.section;
  body.append(h('div', { class: 'actions' },
    h('button', { class: 'primary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('loc:save', { key, data: w[key] });
      if (res.error) return message(body, res.error);
      w[key] = res.data; d.locations[key] = res.data;
      d.saved = d.saved || {}; d.saved[key] = { at: Math.floor(Date.now() / 1000), by: 'you' };
      render(); message($('body'), 'Saved. It applies for everyone now.', 'success');
    }); } }, 'Save'),
    h('button', { class: 'secondary', type: 'button', onclick: () => { w[key] = JSON.parse(JSON.stringify(d.locations[key])); render(); } }, 'Undo changes'),
    h('button', { class: 'secondary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('loc:reset', { key });
      if (res.error) return message(body, res.error);
      w[key] = res.data; d.locations[key] = res.data; if (d.saved) delete d.saved[key];
      render(); message($('body'), 'Back to the config file.', 'success');
    }); } }, 'Reset to config')));
  locPreview(task);
}


/* ---------- armoury ---------- */

function renderArmoury(body, task) {
  const d = task.data;
  const reload = async () => {
    const res = await request('armoury:view');
    if (res.error) return message(body, res.error);
    task.data = res; state.data = res; task.need = null; render();
  };
  body.append(h('h2', {}, `Armoury, ${d.station}`));
  body.append(h('p', { class: 'note' }, 'Sign kit out here and hand it all back here. Rounds that don\'t come back need an account.'));

  body.append(h('h3', {}, 'Sign out'));
  const items = h('ul', { class: 'rows' });
  for (const it of d.items) {
    const full = it.held >= it.max;
    items.append(h('li', {},
      h('span', {}, it.label),
      it.allowed
        ? h('button', { class: 'small', type: 'button', disabled: full, onclick: async (e) => { await busy(e.currentTarget, async () => {
            const res = await request('armoury:draw', { item: it.item });
            if (res.error) return message(body, res.error);
            await reload();
            message($('body'), res.issued.serial ? `${res.issued.label} signed out, serial ${res.issued.serial}.` : `${res.issued.count} ${res.issued.label} signed out.`, 'success');
          }); } }, full ? 'Drawn' : 'Sign out')
        : h('span', { class: 'count' }, '-'),
      h('span', { class: 'sub' }, it.allowed ? `You have ${it.held} of ${it.max}` : it.needs)));
  }
  body.append(items);

  body.append(h('h3', {}, 'Signed out to you'));
  if (!d.outstanding.length) body.append(h('p', { class: 'note' }, 'Nothing.'));
  else {
    const ul = h('ul', { class: 'rows' });
    for (const r of d.outstanding) {
      ul.append(h('li', {}, h('span', {}, `${r.label || r.item}${r.count > 1 ? ` x${r.count}` : ''}`,
        h('div', { class: 'note' }, `${r.serial ? `Serial ${r.serial}. ` : ''}Signed out ${ukDateTime(r.issued_at)}`)), h('span')));
    }
    body.append(ul);
    if ((d.rounds || []).length) {
      const f = h('dl', { class: 'facts', style: 'margin-top:8px' });
      for (const a of d.rounds) {
        f.append(h('dt', {}, a.label), h('dd', {}, `${a.issued} issued: ${a.inHand} on you, ${a.inWeapons} loaded`,
          a.short > 0 ? h('span', {}, ' ', chip(`${a.short} short`, 'red')) : chip('All accounted for', 'ok')));
      }
      body.append(f);
    }

    const form = h('form', { novalidate: true });
    if (task.need) {
      form.append(h('p', { class: 'warn' }, `Missing: ${task.need.map((x) => `${x.rounds} ${x.label}`).join(', ')}.`),
        h('label', { for: 'f-arm-acc' }, 'Account for the missing rounds'),
        h('textarea', { id: 'f-arm-acc', rows: 3, maxlength: 1000, placeholder: 'Where, when and why they were discharged (or lost).' }));
    }
    const go = h('button', { class: 'primary', type: 'submit' }, task.need ? 'Record account and hand in' : 'Hand everything in');
    form.append(go);
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      await busy(go, async () => {
        const acc = form.querySelector('#f-arm-acc');
        const res = await request('armoury:handIn', { account: acc ? acc.value : undefined });
        if (res.error) return message(form, res.error);
        if (res.needAccount) { task.need = res.short; render(); return; }
        await reload();
        const missing = (res.missing || []).length ? ` Not handed in: ${res.missing.join(', ')}.` : '';
        message($('body'), (res.short || []).length ? `Handed in. Discharge recorded for review.${missing}` : `Handed in, all accounted for.${missing}`, (res.missing || []).length ? 'error' : 'success');
      });
    });
    body.append(form);
  }
}


/* ---------- major incidents ---------- */

function renderIncident(body, task) {
  const d = task.data;
  const swap = (res) => { if (res.incident) { d.incident = res.incident; render(); } };
  const call = (action, extra, ok) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request(action, Object.assign({ id: d.incident && d.incident.id }, extra ? extra() : {}));
    if (res.error) return message(body, res.error);
    if (action === 'incident:standDown') return done(body, `Incident ${res.ref} stood down.`);
    if (action === 'incident:leave') { d.incident.member = false; render(); return; }
    swap(res); if (ok) message($('body'), ok, 'success');
  }); };

  const i = d.incident;
  if (!i) {
    body.append(h('h2', {}, 'Major incidents'));
    if (d.list.length) {
      const ul = h('ul', { class: 'rows' });
      for (const x of d.list) ul.append(h('li', {}, h('span', {}, x.label, h('div', { class: 'note' }, `${x.type}, ${x.ref}`)),
        h('button', { class: 'small', type: 'button', onclick: async () => { const res = await request('incident:panel', { id: x.id }); if (!res.error) { task.data = res; state.data = res; render(); } } }, 'Open')));
      body.append(ul);
    } else body.append(h('p', { class: 'note' }, 'No incidents running.'));
    if (d.canDeclare) {
      body.append(h('h3', {}, 'Declare an incident here'));
      const form = h('form', { novalidate: true });
      const type = select('f-mi-type', d.types, 'Type');
      const name = h('input', { id: 'f-mi-label', maxlength: 120, placeholder: 'e.g. Stabbing outside the LTD, Grove Street', autocomplete: 'off' });
      const inner = h('input', { id: 'f-mi-in', type: 'number', min: 5, max: d.defaults.max, value: d.defaults.inner });
      const outer = h('input', { id: 'f-mi-out', type: 'number', min: 10, max: d.defaults.max, value: d.defaults.outer });
      const linked = h('input', { id: 'f-mi-link', maxlength: 160, placeholder: 'CAD or MDT reference (optional)', autocomplete: 'off' });
      const go = h('button', { class: 'primary', type: 'submit' }, 'Declare');
      form.append(field('f-mi-type', 'Type', type), field('f-mi-label', 'Name', name), field('f-mi-in', 'Inner cordon (m)', inner),
        field('f-mi-out', 'Outer cordon (m)', outer), field('f-mi-link', 'Linked to', linked),
        h('p', { class: 'note' }, 'The cordons are centred where you stand. You become Bronze commander.'), go);
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        await busy(go, async () => {
          const res = await request('incident:declare', { type: type.value, label: name.value, inner: inner.value, outer: outer.value, linked: linked.value });
          if (res.error) return message(form, res.error);
          d.incident = res.incident; render();
        });
      });
      body.append(form);
    }
    return;
  }

  body.append(h('h2', {}, i.label), h('p', { class: 'note' }, `${i.type}, ${i.ref}. Declared ${ukTime(i.createdAt)} by ${i.declaredBy}${i.linked ? `. Linked to ${i.linked}` : ''}.`));
  body.append(h('p', {}, chip(`Inner ${i.inner} m`, 'red'), chip(`Outer ${i.outer} m`, 'amber'), i.distance != null ? chip(`${i.distance} m from you`) : null,
    i.role ? chip(i.role, 'ok') : null));
  const command = i.role === 'Bronze commander' || i.role === 'Silver commander' || d.canDeclare;
  body.append(h('div', { class: 'actions' },
    !i.member ? h('button', { class: 'primary', style: 'margin-top:0', type: 'button', onclick: call('incident:join', null, 'Booked on to the incident.') }, 'Book on to the incident') : null,
    i.member ? h('button', { class: 'small', type: 'button', onclick: call('incident:leave') }, 'Book off') : null,
    h('button', { class: 'small', type: 'button', onclick: async () => { const res = await request('incident:panel', { id: i.id }); if (!res.error) { task.data = res; state.data = res; render(); } } }, 'Refresh')));

  body.append(h('h3', {}, 'On the incident'));
  const ul = h('ul', { class: 'rows' });
  for (const m of i.members) {
    let control = h('span', { class: 'note' }, m.role || 'No role');
    if (command) {
      control = select(`role-${m.src}`, [{ value: '', label: 'No role' }, ...d.roles.map((r) => ({ value: r, label: r }))]);
      control.value = m.role || '';
      control.addEventListener('change', async () => {
        const res = await request('incident:role', { id: i.id, target: m.src, role: control.value });
        if (res.error) { message(body, res.error); control.value = m.role || ''; return; }
        swap(res);
      });
      control.style.width = '195px';
    }
    ul.append(h('li', {}, h('span', {}, m.label, m.inside ? h('div', { class: 'note' }, 'Inside the inner cordon') : null), control));
  }
  if (!i.members.length) ul.append(h('li', {}, h('span', { class: 'note' }, 'Nobody booked on.')));
  body.append(ul);

  if (command) {
    body.append(h('h3', {}, 'Cordons'));
    const inner = h('input', { type: 'number', min: 5, max: d.defaults.max, value: i.inner, style: 'width:90px' });
    const outer = h('input', { type: 'number', min: 10, max: d.defaults.max, value: i.outer, style: 'width:90px' });
    body.append(h('div', { class: 'actions', style: 'align-items:center;margin-top:0' }, h('span', { class: 'note' }, 'Inner'), inner, h('span', { class: 'note' }, 'Outer'), outer,
      h('button', { class: 'small', type: 'button', onclick: call('incident:cordon', () => ({ inner: inner.value, outer: outer.value }), 'Cordons updated.') }, 'Set'),
      h('button', { class: 'small', type: 'button', onclick: call('incident:cordon', () => ({ inner: inner.value, outer: outer.value, here: true }), 'Cordons moved to you.') }, 'Centre on me')));
  }

  if (i.member) {
    body.append(h('h3', {}, 'Scene log'));
    const note = h('input', { maxlength: 1000, placeholder: 'Add to the scene log', autocomplete: 'off' });
    const add = h('button', { class: 'small', type: 'button', onclick: call('incident:note', () => ({ text: note.value })) }, 'Add');
    body.append(h('div', { class: 'actions', style: 'margin-top:0;flex-wrap:nowrap' }, note, add));
  }
  body.append(h('ul', { class: 'log', style: 'max-height:260px' }, i.log.map((l) => h('li', {}, h('span', { class: 'when' }, ukTime(l.at)),
    l.kind === 'breach' ? h('strong', { style: 'color:#ffd5d3' }, l.text) : l.text, l.by ? h('span', { class: 'note' }, ` (${l.by})`) : null))));

  if (command) {
    const summary = h('textarea', { rows: 2, maxlength: 2000, placeholder: 'Summary for the record (optional)' });
    body.append(h('h3', {}, 'Stand down'), summary,
      h('button', { class: 'primary danger', type: 'button', onclick: call('incident:standDown', () => ({ summary: summary.value })) }, 'Stand down the incident'));
  }
}

/* ---------- CID case files ---------- */

function openCase(id) {
  return request('cid:open', { id }).then((res) => {
    if (res.error) return res;
    state.task = { name: 'case', data: res }; state.data = res; render();
    return res;
  });
}

function renderCases(body, task) {
  const d = task.data;
  body.append(h('h2', {}, 'CID case files'));
  const form = h('form', { novalidate: true });
  const q = h('input', { value: d.q || '', placeholder: 'Search: reference, title, person, linked ref', autocomplete: 'off' });
  form.append(q);
  const search = async (extra) => {
    const res = await request('cid:list', Object.assign({ q: q.value }, extra || {}));
    if (res.error) return message(body, res.error);
    task.data = res; state.data = res; render();
  };
  form.addEventListener('submit', (e) => { e.preventDefault(); search(); });
  body.append(form, h('div', { class: 'actions', style: 'margin-top:8px' },
    h('button', { class: 'small', type: 'button', onclick: () => { q.value = ''; search({ mine: true }); } }, 'My cases'),
    h('button', { class: 'small', type: 'button', onclick: () => { q.value = ''; search(); } }, 'All open cases')));

  if ((d.myActions || []).length) {
    body.append(h('h3', {}, 'Actions for you'));
    const ul = h('ul', { class: 'rows' });
    for (const a of d.myActions) ul.append(h('li', {}, h('span', {}, a.text, h('div', { class: 'note' }, a.ref)),
      h('button', { class: 'small', type: 'button', onclick: () => openCase(a.case_id) }, 'Open')));
    body.append(ul);
  }

  body.append(h('h3', {}, d.q ? 'Results' : d.mine ? 'My cases' : 'Open cases'));
  if (!d.cases.length) body.append(h('p', { class: 'note' }, 'None.'));
  const ul = h('ul', { class: 'rows' });
  for (const c of d.cases) ul.append(h('li', {}, h('span', {}, c.title, h('div', { class: 'note' }, `${c.ref}, ${c.type || ''}. OIC ${c.oic_name || '-'}. Updated ${ukDateTime(c.updated_at)}`)),
    h('span', { class: 'actions', style: 'margin:0' }, chip(c.status, c.status === 'Charged' ? 'ok' : ''), h('button', { class: 'small', type: 'button', onclick: () => openCase(c.id) }, 'Open'))));
  body.append(ul);

  if (d.canCreate) {
    body.append(h('h3', {}, 'New case'));
    const f = h('form', { novalidate: true });
    const title = h('input', { maxlength: 160, placeholder: 'e.g. Series of burglaries, Mirror Park', autocomplete: 'off' });
    const type = select('f-case-type', d.types);
    const links = h('input', { maxlength: 300, placeholder: 'References to link, comma separated (CAD, custody, exhibits, MDT)', autocomplete: 'off' });
    const summary = h('textarea', { rows: 3, maxlength: 2000, placeholder: 'What happened and what is known so far.' });
    const go = h('button', { class: 'primary', type: 'submit' }, 'Open case');
    f.append(h('label', {}, 'Title'), title, field('f-case-type', 'Type', type), h('label', {}, 'Linked references'), links, h('label', {}, 'Summary'), summary, go);
    f.addEventListener('submit', async (e) => {
      e.preventDefault();
      await busy(go, async () => {
        const res = await request('cid:create', { title: title.value, type: type.value, links: links.value, summary: summary.value });
        if (res.error) return message(f, res.error);
        await openCase(res.case.id);
      });
    });
    body.append(f);
  }
}

function renderCase(body, task) {
  const d = task.data, c = d.case;
  const update = (op, extra, ok) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request('cid:update', Object.assign({ id: c.id, op }, extra ? extra() : {}));
    if (res.error) return message(body, res.error);
    d.case = res.case; render(); if (ok) message($('body'), ok, 'success');
  }); };
  body.append(h('button', { class: 'linkish', type: 'button', onclick: async () => {
    const res = await request('cid:list', {}); if (!res.error) { state.task = { name: 'cases', data: res }; state.data = res; render(); } } }, '‹ All cases'));
  body.append(h('h2', {}, c.title), h('p', { class: 'note' }, `${c.ref}, ${c.type || ''}. OIC ${c.oic}${c.oicMe ? ' (you)' : ''}. Opened ${ukDateTime(c.createdAt)}.`));

  if (c.canManage) {
    const st = select('f-case-status', d.statuses); st.value = c.status;
    st.addEventListener('change', update('status', () => ({ status: st.value })));
    const oic = select('f-case-oic', [{ value: '', label: 'Hand over to...' }, ...(d.officers || []).map((x) => ({ value: String(x.src), label: x.label }))]);
    oic.addEventListener('change', () => { if (oic.value) update('oic', () => ({ target: Number(oic.value) }), 'OIC changed.')({ currentTarget: oic }); });
    body.append(field('f-case-status', 'Status', st), field('f-case-oic', 'Officer in case', oic));
  } else body.append(h('p', {}, chip(c.status)));

  body.append(h('h3', {}, 'Summary'));
  if (c.canManage) {
    const sum = h('textarea', { rows: 3, maxlength: 2000 }); sum.value = c.summary || '';
    body.append(sum, h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: update('summary', () => ({ text: sum.value }), 'Summary saved.') }, 'Save summary'));
  } else body.append(h('p', { style: 'white-space:pre-wrap' }, c.summary || '-'));

  body.append(h('h3', {}, 'People'));
  const pl = h('ul', { class: 'rows' });
  c.people.forEach((p, i) => pl.append(h('li', {}, h('span', {}, `${p.name}`, h('div', { class: 'note' }, `${p.role}${p.details ? `: ${p.details}` : ''}`)),
    c.canManage ? h('button', { class: 'linkish', type: 'button', onclick: update('removePerson', () => ({ index: i + 1 })) }, 'Remove') : h('span'))));
  if (!c.people.length) pl.append(h('li', {}, h('span', { class: 'note' }, 'Nobody added.')));
  body.append(pl);
  if (c.canManage) {
    const name = h('input', { maxlength: 100, placeholder: 'Name', autocomplete: 'off' });
    const role = select('f-case-prole', d.personRoles);
    const det = h('input', { maxlength: 300, placeholder: 'Details (DOB, address, custody ref...)', autocomplete: 'off' });
    body.append(h('div', { class: 'inline-form' }, name, h('div', { style: 'margin-top:6px' }, role), h('div', { style: 'margin-top:6px' }, det),
      h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: update('person', () => ({ name: name.value, role: role.value, details: det.value })) }, 'Add person')));
  }

  body.append(h('h3', {}, 'Linked'));
  body.append(h('div', {}, c.links.length ? c.links.map((r) => h('span', { class: 'chip' }, r, c.canManage ? h('button', { class: 'linkish', type: 'button', style: 'margin-left:6px', onclick: update('unlink', () => ({ ref: r })) }, '×') : null)) : h('span', { class: 'note' }, 'Nothing linked.')));
  if (c.canManage) {
    const ref = h('input', { maxlength: 32, placeholder: 'Reference to link', autocomplete: 'off', style: 'margin-top:6px' });
    body.append(ref, h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: update('link', () => ({ ref: ref.value })) }, 'Link'));
  }
  if (c.exhibits.length) {
    body.append(h('h3', {}, 'Exhibits'));
    const ex = h('ul', { class: 'rows' });
    for (const x of c.exhibits) ex.append(h('li', {}, h('span', {}, `${x.ref}: ${x.description}`, h('div', { class: 'note' }, x.linked_ref || '')), chip(x.status)));
    body.append(ex);
  }

  body.append(h('h3', {}, 'Actions'));
  const al = h('ul', { class: 'rows' });
  for (const a of c.actions) {
    al.append(h('li', {}, h('span', {}, a.text, h('div', { class: 'note' }, `${a.assigned_name ? `For ${a.assigned_name}. ` : ''}${a.done_at ? `Done by ${a.done_by}` : 'Outstanding'}`)),
      a.done_at ? chip('Done', 'ok') : h('button', { class: 'small', type: 'button', onclick: update('actionDone', () => ({ entry: a.id })) }, 'Mark done')));
  }
  if (!c.actions.length) al.append(h('li', {}, h('span', { class: 'note' }, 'No actions.')));
  body.append(al);
  if (c.canManage) {
    const text = h('input', { maxlength: 300, placeholder: 'e.g. Get CCTV from the LTD, Grove Street', autocomplete: 'off' });
    const who = select('f-case-assign', [{ value: '', label: 'Unassigned' }, ...(d.officers || []).map((x) => ({ value: String(x.src), label: x.label }))]);
    body.append(h('div', { class: 'inline-form' }, text, h('div', { style: 'margin-top:6px' }, who),
      h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: update('action', () => ({ text: text.value, assign: who.value ? Number(who.value) : undefined }), 'Action added.') }, 'Add action')));
  }

  body.append(h('h3', {}, 'Investigation log'));
  const note = h('input', { maxlength: 2000, placeholder: 'Add to the log', autocomplete: 'off' });
  body.append(h('div', { class: 'actions', style: 'margin-top:0;flex-wrap:nowrap' }, note, h('button', { class: 'small', type: 'button', onclick: update('note', () => ({ text: note.value })) }, 'Add')));
  body.append(h('ul', { class: 'log', style: 'max-height:260px' }, c.log.map((l) => h('li', {}, h('span', { class: 'when' }, ukDateTime(l.created_at)), l.text, l.officer ? h('span', { class: 'note' }, ` (${l.officer})`) : null))));
}


/* ---------- use of force forms (hub tab) ---------- */

function uofForm(body, data, form, onDone) {
  const f = h('form', { novalidate: true });
  const pick = (list, chosen, name) => {
    const box = h('div', { class: 'picker', role: 'group', 'aria-label': name, style: 'max-height:200px' });
    for (const x of list) box.append(h('label', { class: 'check' }, h('input', { type: 'checkbox', value: x, checked: (chosen || []).includes(x) }), x));
    return { el: box, values: () => [...box.querySelectorAll('input:checked')].map((i) => i.value) };
  };
  const suggested = [];
  if (form && form.trigger === 'Handcuffing') suggested.push('Handcuffing (compliant)');
  if (form && form.trigger === 'Taser fired') suggested.push('Taser drawn', 'Taser fired');
  if (form && form.trigger === 'Firearm fired') suggested.push('Firearm aimed', 'Firearm fired');
  const tactics = pick(data.tactics, suggested, 'Tactics');
  const reasons = pick(data.reasons, [], 'Reasons');
  const subject = h('input', { maxlength: 120, value: (form && form.subject) || '', placeholder: 'Name, or a description', autocomplete: 'off' });
  const linked = h('input', { maxlength: 32, value: (form && form.linked) || '', placeholder: 'Custody, CAD or incident ref (optional)', autocomplete: 'off' });
  const si = h('input', { type: 'checkbox' }), oi = h('input', { type: 'checkbox' });
  const narrative = h('textarea', { rows: 5, maxlength: 3000, placeholder: 'What happened, what you perceived, why the force you used was necessary and proportionate.' });
  const go = h('button', { class: 'primary', type: 'submit' }, 'Submit form');
  f.append(h('label', {}, 'Subject'), subject, h('label', {}, 'Linked reference'), linked,
    h('label', {}, 'Tactics used'), tactics.el, h('label', {}, 'Reasons'), reasons.el,
    h('label', { class: 'check', style: 'margin-top:10px' }, si, 'Subject injured'), h('label', { class: 'check' }, oi, 'Officer injured'),
    h('label', {}, 'Account'), narrative, go);
  f.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(go, async () => {
      const res = await request('uof:submit', { id: form && form.id, subject: subject.value, linked: linked.value, tactics: tactics.values(), reasons: reasons.values(),
        subjectInjured: si.checked, officerInjured: oi.checked, narrative: narrative.value, location: '' });
      if (res.error) return message(f, res.error);
      onDone();
    });
  });
  body.append(f);
}

function renderForms(body) {
  body.append(h('h2', {}, 'Use of force'));
  const holder = h('div', {}, h('p', { class: 'note' }, 'Loading…'));
  body.append(holder);
  const load = () => request('uof:list').then((res) => {
    if (state.tab !== 'forms') return;
    holder.replaceChildren();
    if (res.error) return message(holder, res.error);
    const pending = res.forms.filter((x) => x.status === 'pending');
    const done = res.forms.filter((x) => x.status !== 'pending');
    if (state.uofOpen !== undefined) {
      const form = res.forms.find((x) => x.id === state.uofOpen) || null;
      holder.append(h('button', { class: 'linkish', type: 'button', onclick: () => { state.uofOpen = undefined; render(); } }, '‹ Back'),
        h('h3', {}, form ? `${form.trigger}${form.subject ? `: ${form.subject}` : ''}` : 'New use of force form'));
      uofForm(holder, res, form, () => { state.uofOpen = undefined; render(); message($('body'), 'Form submitted.', 'success'); });
      return;
    }
    holder.append(h('p', { class: 'note' }, 'A form is started for you after handcuffing someone or firing a Taser or firearm. Complete them before the end of your shift.'));
    if (pending.length) {
      const ul = h('ul', { class: 'rows' });
      for (const x of pending) ul.append(h('li', {}, h('span', {}, x.trigger, h('div', { class: 'note' }, `${x.subject || 'Subject not recorded'}, ${ukDateTime(x.createdAt)}`)),
        h('button', { class: 'small', type: 'button', onclick: () => { state.uofOpen = x.id; render(); } }, 'Complete')));
      holder.append(h('h3', {}, `To complete (${pending.length})`), ul);
    }
    holder.append(h('button', { class: 'secondary', type: 'button', onclick: () => { state.uofOpen = null; render(); } }, 'New form'));
    if (done.length) {
      const ul = h('ul', { class: 'rows' });
      for (const x of done) ul.append(h('li', {}, h('span', {}, x.tactics.join(', '), h('div', { class: 'note' }, `${x.subject || '-'}, ${ukDateTime(x.submittedAt)}${x.reviewedBy ? `. Reviewed by ${x.reviewedBy}` : ''}`)),
        chip(x.reviewedBy ? 'Reviewed' : 'Submitted', x.reviewedBy ? 'ok' : '')));
      holder.append(h('h3', {}, 'Submitted'), ul);
    }
  });
  load();
}

/* ---------- professional standards (supervisors) ---------- */

function renderStandards(body, task) {
  const d = task.data;
  task.tab = task.tab || 'reviews';
  body.append(h('h2', {}, 'Professional standards'));
  const seg = h('div', { class: 'seg', role: 'group', style: 'flex-wrap:wrap' });
  for (const [k, label] of [['reviews', `Reviews (${d.uof.length + d.discharges.length})`], ['complaints', `Complaints (${d.complaints.length})`], ['officer', 'Officer'], ['audit', 'Audit log']]) {
    seg.append(h('button', { type: 'button', 'aria-pressed': String(task.tab === k), onclick: () => { task.tab = k; render(); } }, label));
  }
  body.append(seg);
  const reload = async () => { const res = await request('standards:panel'); if (!res.error) { task.data = res; state.data = res; render(); } };
  const review = (kind, id, extra) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request('standards:review', Object.assign({ kind, id }, extra()));
    if (res.error) return message(body, res.error);
    await reload(); message($('body'), 'Recorded.', 'success');
  }); };
  const box = h('div', { style: 'margin-top:12px' });

  if (task.tab === 'reviews') {
    box.append(h('h3', {}, 'Discharges'));
    if (!d.discharges.length) box.append(h('p', { class: 'note' }, 'Nothing to review.'));
    for (const x of d.discharges) {
      const out = select(`dis-${x.id}`, d.dischargeOutcomes);
      const note = h('input', { maxlength: 500, placeholder: 'Note', autocomplete: 'off' });
      box.append(h('div', { class: 'card' }, h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, `${x.rounds} ${x.label}`), x.unaccounted === 1 ? chip('Unaccounted', 'red') : chip('Account given', 'amber')),
        h('p', { class: 'note', style: 'margin:2px 0' }, `${x.officer_name}, ${x.station || '-'}, ${ukDateTime(x.created_at)}`),
        h('p', { style: 'white-space:pre-wrap' }, x.account || '-'), out, h('div', { style: 'margin-top:6px' }, note),
        h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: review('discharge', x.id, () => ({ outcome: out.value, note: note.value })) }, 'Record review')));
    }
    box.append(h('h3', {}, 'Use of force forms'));
    if (!d.uof.length) box.append(h('p', { class: 'note' }, 'Nothing to review.'));
    for (const x of d.uof) {
      const note = h('input', { maxlength: 500, placeholder: 'Note (optional)', autocomplete: 'off' });
      box.append(h('div', { class: 'card' }, h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, x.officer), h('span', { class: 'note' }, ukDateTime(x.submittedAt))),
        h('p', { class: 'note', style: 'margin:2px 0' }, `${x.subject || '-'}${x.linked ? `, ${x.linked}` : ''}`),
        h('div', {}, x.tactics.map((t) => chip(t, /fired|used|drive-stun/i.test(t) ? 'amber' : '')), x.subjectInjured ? chip('Subject injured', 'red') : null, x.officerInjured ? chip('Officer injured', 'red') : null),
        h('p', { class: 'note' }, `Reasons: ${x.reasons.join(', ')}`), h('p', { style: 'white-space:pre-wrap' }, x.narrative || '-'), note,
        h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: review('uof', x.id, () => ({ note: note.value })) }, 'Mark reviewed')));
    }
    if ((d.pendingForms || []).length) {
      box.append(h('h3', {}, 'Forms not yet completed'), h('ul', { class: 'rows' }, d.pendingForms.map((p) => h('li', {}, h('span', {}, p.officer), chip(`${p.n} outstanding`, 'amber')))));
    }
  }

  if (task.tab === 'complaints') {
    if (!d.complaints.length) box.append(h('p', { class: 'note' }, 'No open complaints.'));
    for (const c of d.complaints) {
      const st = select(`cs-${c.id}`, d.complaintStatuses); st.value = c.status;
      const note = h('input', { maxlength: 500, placeholder: 'Note', autocomplete: 'off' });
      box.append(h('div', { class: 'card' }, h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, c.ref), chip(c.status, c.status === 'Received' ? 'amber' : '')),
        h('p', { class: 'note', style: 'margin:2px 0' }, `${c.category}. From ${c.complainant || '?'} about ${c.officer_name || c.officer_text || 'an unknown officer'}${c.happened ? `, ${c.happened}` : ''}. ${ukDateTime(c.created_at)}`),
        h('p', { style: 'white-space:pre-wrap' }, c.details), c.notes ? h('p', { class: 'note', style: 'white-space:pre-wrap' }, c.notes) : null,
        st, h('div', { style: 'margin-top:6px' }, note),
        h('button', { class: 'small', type: 'button', style: 'margin-top:6px', onclick: review('complaint', c.id, () => ({ status: st.value, note: note.value })) }, 'Update')));
    }
  }

  if (task.tab === 'officer') {
    const q = h('input', { placeholder: 'Collar number, callsign or name', autocomplete: 'off' });
    const out = h('div');
    const f = h('form', { novalidate: true }, q);
    f.addEventListener('submit', async (e) => {
      e.preventDefault();
      const res = await request('standards:officer', { q: q.value });
      out.replaceChildren();
      if (res.error) return message(out, res.error);
      const o = res.officer;
      out.append(h('h3', {}, `${o.name || '?'}${o.collar ? `, ${o.collar}` : ''}${o.callsign ? ` (${o.callsign})` : ''}`),
        h('p', {}, (o.qualifications || []).map((q) => chip(q.label, q.valid ? 'ok' : 'red'))),
        h('h3', {}, 'Use of force'), h('ul', { class: 'log' }, o.uof.map((x) => h('li', {}, h('span', { class: 'when' }, ukDateTime(x.created_at)), `${x.trigger || 'Form'}: ${x.status}${x.reviewed_by ? `, reviewed by ${x.reviewed_by}` : ''}`))),
        h('h3', {}, 'Discharges'), h('ul', { class: 'log' }, o.discharges.map((x) => h('li', {}, h('span', { class: 'when' }, ukDateTime(x.created_at)), `${x.rounds} ${x.label}${x.unaccounted === 1 ? ' (unaccounted)' : ''}${x.reviewed_by ? `, reviewed` : ''}`))),
        h('h3', {}, 'Complaints'), h('ul', { class: 'log' }, o.complaints.map((x) => h('li', {}, h('span', { class: 'when' }, ukDateTime(x.created_at)), `${x.ref}: ${x.category}, ${x.status}`))),
        h('h3', {}, 'Recent shifts'), h('ul', { class: 'log' }, o.shifts.map((x) => h('li', {}, h('span', { class: 'when' }, ukDateTime(x.started_at)), `${x.callsign || '-'} ${x.unit || ''} ${x.end_reason ? `(${x.end_reason})` : '(on duty)'}`))));
    });
    box.append(f, out);
    q.focus();
  }

  if (task.tab === 'audit') {
    const q = h('input', { placeholder: 'Search actions, officers, references', autocomplete: 'off' });
    const ul = h('ul', { class: 'log', style: 'max-height:520px' });
    let lastId = null;
    const load = async (more) => {
      const res = await request('standards:audit', { q: q.value, beforeId: more ? lastId : undefined });
      if (res.error) return message(box, res.error);
      if (!more) ul.replaceChildren();
      for (const r of res.rows) {
        ul.append(h('li', {}, h('span', { class: 'when' }, ukDateTime(r.created_at)), h('strong', {}, r.action), ` ${r.actor_name || r.source}`,
          r.target_id ? h('span', { class: 'note' }, ` on ${r.target_type || ''} ${r.target_id}`) : null, r.reason ? h('div', { class: 'note' }, r.reason) : null));
        lastId = r.id;
      }
    };
    const f = h('form', { novalidate: true }, q);
    f.addEventListener('submit', (e) => { e.preventDefault(); load(false); });
    box.append(f, ul, h('button', { class: 'secondary', type: 'button', onclick: () => load(true) }, 'Older'));
    load(false);
  }
  body.append(box);
}

/* ---------- complaint (anyone) ---------- */

function renderComplaint(body, task) {
  const d = task.data;
  body.append(h('h2', {}, `Complain about the ${d.force}`));
  body.append(h('p', { class: 'note' }, 'Your complaint goes to the professional standards department. Give as much detail as you can.'));
  const f = h('form', { novalidate: true });
  const officer = h('input', { maxlength: 120, placeholder: 'Collar number, callsign or description', autocomplete: 'off' });
  const when = h('input', { maxlength: 120, placeholder: 'e.g. Tonight around 9pm, Grove Street', autocomplete: 'off' });
  const cat = select('f-comp-cat', d.categories);
  const details = h('textarea', { rows: 6, maxlength: 3000, placeholder: 'What happened?' });
  const go = h('button', { class: 'primary', type: 'submit' }, 'Send complaint');
  f.append(h('label', {}, 'Which officer'), officer, h('label', {}, 'When and where'), when, field('f-comp-cat', 'What is it about', cat), h('label', {}, 'Details'), details, go);
  f.addEventListener('submit', async (e) => {
    e.preventDefault();
    await busy(go, async () => {
      const res = await request('complaint:submit', { officer: officer.value, happened: when.value, category: cat.value, details: details.value });
      if (res.error) return message(f, res.error);
      done(body, `Complaint received. Your reference is ${res.ref}.`);
    });
  });
  body.append(f);
}


/* ---------- changing room ---------- */

function renderChanging(body, task) {
  const d = task.data;
  body.append(h('h2', {}, `Changing room, ${d.station}`));
  if (!d.outfits.length) body.append(h('p', { class: 'note' }, 'No uniforms for your rank and unit.'));
  const grid = h('div', { class: 'statuses' });
  for (const o of [...d.outfits, { id: 'own', label: 'Own clothes' }]) {
    grid.append(h('button', { type: 'button', style: '--tone:var(--blue)', onclick: async (e) => { await busy(e.currentTarget, async () => {
      const res = await request('equipment:uniform', { id: o.id });
      if (res.error) return message(body, res.error);
      message(body, o.id === 'own' ? 'Back in your own clothes.' : `Changed into: ${o.label}.`, 'success');
    }); } }, o.label));
  }
  body.append(grid);
}


/* ---------- management ---------- */

function renderManagement(body, task) {
  const d = task.data;
  task.open = task.open || null;
  const reload = async () => { const res = await request('manage:panel'); if (!res.error) { task.data = res; state.data = res; render(); } };
  const act = (action, extra, after) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request(action, extra());
    if (res.error) return message(body, res.error);
    task.open = null; await reload(); message($('body'), res.message || 'Done.', 'success');
    if (after) after();
  }); };

  body.append(h('h2', {}, 'Management'));
  if (d.can.hire) {
    body.append(h('h3', {}, 'Hire'));
    if (!d.nearby.length) body.append(h('p', { class: 'note' }, 'Stand next to the person you want to hire, then Refresh.'));
    else {
      const ul = h('ul', { class: 'rows' });
      for (const p of d.nearby) {
        const job = d.jobs.length > 1 ? select(`hire-${p.src}`, d.jobs.map((j) => ({ value: j.id, label: j.label }))) : null;
        if (job) job.style.width = '140px';
        ul.append(h('li', {}, h('span', {}, p.name), h('span', { class: 'actions', style: 'margin:0' }, job,
          h('button', { class: 'small', type: 'button', onclick: act('manage:hire', () => ({ target: p.src, job: job ? job.value : undefined })) }, 'Hire'))));
      }
      body.append(ul);
    }
  }

  body.append(h('h3', {}, `Officers (${d.staff.length})`));
  const filter = h('input', { placeholder: 'Filter by name, collar or rank', autocomplete: 'off', value: task.filter || '' });
  filter.addEventListener('input', () => { task.filter = filter.value; draw(); });
  const list = h('div');
  body.append(filter, list, h('button', { class: 'secondary', type: 'button', onclick: (e) => busy(e.currentTarget, reload) }, 'Refresh'));

  function draw() {
    list.replaceChildren();
    const q = (task.filter || '').toLowerCase();
    for (const m of d.staff) {
      if (q && !`${m.name} ${m.collar || ''} ${m.rankLabel} ${m.callsign || ''}`.toLowerCase().includes(q)) continue;
      const below = m.level < d.myLevel && m.identifier;
      const card = h('div', { class: `card${m.suspended ? ' alert' : ''}`, style: 'margin-top:8px' });
      card.append(h('div', { class: 'card-head' }, h('span', { class: 'card-name' }, m.name), h('span', { class: 'note' }, m.rankLabel)),
        h('p', { style: 'margin:4px 0' }, m.collar ? chip(`Collar ${m.collar}`) : chip('No collar', 'amber'), m.callsign ? chip(m.callsign) : null,
          m.onDuty ? chip('On duty', 'ok') : m.online ? chip('Online') : chip('Offline'),
          m.suspended ? chip('Suspended', 'red') : null),
        m.suspended ? h('p', { class: 'note', style: 'margin:0' }, `Suspended by ${m.suspendedBy || '?'}: ${m.suspendedReason || ''}`) : null);
      const toggle = (k) => () => { task.open = task.open === `${k}:${m.identifier}` ? null : `${k}:${m.identifier}`; draw(); };
      const btn = (label, k, show) => show ? h('button', { class: 'small', type: 'button', onclick: toggle(k) }, label) : null;
      card.append(h('div', { class: 'actions', style: 'margin-top:6px' },
        btn('Qualifications', 'quals', true),
        btn('Rank', 'rank', d.can.promote && below),
        btn('Collar', 'collar', d.can.promote),
        btn(m.suspended ? 'Lift suspension' : 'Suspend', 'suspend', d.can.discipline && below),
        btn('Dismiss', 'fire', d.can.fire && below)));
      const f = h('div', { class: 'inline-form' });
      const open = task.open && task.open.endsWith(`:${m.identifier}`) ? task.open.split(':')[0] : null;
      if (open === 'rank') {
        const rank = select(`rk-${m.identifier}`, d.ranks.filter((r) => r.level < d.myLevel).map((r) => ({ value: r.id, label: r.label })));
        rank.value = m.rank || '';
        const why = h('input', { maxlength: 255, placeholder: 'Reason (optional)', autocomplete: 'off', style: 'margin-top:6px' });
        f.append(rank, why, h('button', { class: 'primary', type: 'button', onclick: act('manage:rank', () => ({ identifier: m.identifier, rank: rank.value, reason: why.value })) }, 'Set rank'));
      } else if (open === 'collar') {
        const collar = h('input', { inputmode: 'numeric', maxlength: 5, value: m.collar || '', placeholder: 'Digits only', autocomplete: 'off' });
        f.append(collar, h('button', { class: 'primary', type: 'button', onclick: act('manage:collar', () => ({ identifier: m.identifier, collar: collar.value })) }, 'Set collar'));
      } else if (open === 'suspend') {
        if (m.suspended) f.append(h('button', { class: 'primary', type: 'button', onclick: act('manage:suspend', () => ({ identifier: m.identifier, lift: true })) }, 'Lift suspension'));
        else {
          const why = h('input', { maxlength: 255, placeholder: 'Reason (they see this)', autocomplete: 'off' });
          f.append(why, h('p', { class: 'note' }, 'They come off duty now and can\'t sign on until it\'s lifted.'),
            h('button', { class: 'primary danger', type: 'button', onclick: act('manage:suspend', () => ({ identifier: m.identifier, reason: why.value })) }, 'Suspend'));
        }
      } else if (open === 'quals') {
        const box = h('div', {}, h('p', { class: 'note' }, 'Loading…'));
        f.append(box);
        const fill = (q) => {
          box.replaceChildren();
          if (q.error) return message(box, q.error);
          const now = Date.now() / 1000;
          const ul = h('ul', { class: 'rows' });
          for (const x of q.held) {
            const status = !x.expiresAt ? chip('No expiry', 'ok') : x.valid ? chip(`Until ${ukDateTime(x.expiresAt).slice(0, 10)}`, x.expiresAt - now < 14 * 86400 ? 'amber' : 'ok') : chip('Expired', 'red');
            let revoke = null;
            if (q.canRevoke) {
              const why = h('input', { maxlength: 255, placeholder: 'Reason', autocomplete: 'off', style: 'width:130px' });
              why.style.width = 'auto'; why.style.flex = '1';
              revoke = h('div', { class: 'actions', style: 'margin:6px 0 0;flex-wrap:nowrap' }, why, h('button', { class: 'small', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
                const res = await request('manage:qualRevoke', { identifier: m.identifier, qual: x.id, reason: why.value });
                if (res.error) return message(box, res.error);
                q.held = res.held; fill(q); message(box, res.message, 'success');
              }); } }, 'Revoke'));
            }
            ul.append(h('li', { style: 'grid-template-columns:1fr' },
              h('div', { style: 'display:flex;justify-content:space-between;gap:8px;align-items:center' }, h('strong', { style: 'font-weight:500' }, x.label), status),
              x.grantedBy ? h('div', { class: 'note' }, `Signed off by ${x.grantedBy}`) : null, revoke));
          }
          if (!q.held.length) ul.append(h('li', {}, h('span', { class: 'note' }, 'None yet.')));
          box.append(ul);
          if (q.canGrant) {
            const held = new Set(q.held.filter((x) => x.valid).map((x) => x.id));
            const pick = select(`qg-${m.identifier}`, q.defs.filter((x) => !held.has(x.id)).map((x) => ({ value: x.id, label: `${x.label}${x.grantRank ? ` (${x.grantRank}+)` : ''}` })));
            const days = h('input', { type: 'number', min: 0, max: 3650, placeholder: 'Days (blank = default)', style: 'margin-top:6px' });
            const notes = h('input', { maxlength: 255, placeholder: 'Notes (optional)', autocomplete: 'off', style: 'margin-top:6px' });
            box.append(h('h3', {}, 'Sign off'), pick, days, notes, h('button', { class: 'primary', type: 'button', onclick: async (e) => { await busy(e.currentTarget, async () => {
              const res = await request('manage:qualGrant', { identifier: m.identifier, qual: pick.value, days: days.value, notes: notes.value });
              if (res.error) return message(box, res.error);
              q.held = res.held; fill(q); message(box, res.message, 'success');
            }); } }, 'Sign off qualification'));
          }
        };
        request('manage:quals', { identifier: m.identifier }).then(fill);
      } else if (open === 'fire') {
        const why = h('input', { maxlength: 255, placeholder: 'Reason (they see this)', autocomplete: 'off' });
        const sure = h('input', { type: 'checkbox' });
        const go = h('button', { class: 'primary danger', type: 'button', disabled: true, onclick: act('manage:fire', () => ({ identifier: m.identifier, reason: why.value })) }, 'Dismiss');
        sure.addEventListener('change', () => { go.disabled = !sure.checked; });
        f.append(why, h('label', { class: 'check', style: 'margin-top:8px' }, sure, `Dismiss ${m.name} from the force`), go);
      }
      if (open) card.append(f);
      list.append(card);
    }
  }
  draw();
}


/* ---------- admin panel (/vpo) ---------- */

function renderAdmin(body, task) {
  const d = task.data;
  const call = (action, extra, after) => async (e) => { await busy(e.currentTarget, async () => {
    const res = await request(action, extra ? extra() : {});
    if (res.error) return message(body, res.error);
    if (res.callouts) d.callouts = res.callouts;
    if (after) after(res);
    render();
    if (res.message) message($('body'), res.message, 'success');
  }); };

  body.append(h('h2', {}, 'Vinewood Police admin'));
  body.append(h('p', {}, chip(`v${d.version || '?'}`), d.ready ? chip('Ready', 'ok') : chip('Starting', 'amber'),
    chip(`Framework: ${d.framework || 'none'}`), chip(`Inventory: ${d.inventory || 'none'}`)));

  body.append(h('h3', {}, 'Set up'));
  body.append(h('div', { class: 'statuses' },
    h('button', { type: 'button', style: '--tone:var(--blue)', onclick: () => nui('adminLocations') }, 'Locations editor'),
    h('button', { type: 'button', style: '--tone:var(--blue)', onclick: () => nui('adminCommand', { cmd: 'management' }) }, 'Management'),
    h('button', { type: 'button', style: '--tone:var(--blue)', onclick: () => nui('adminCommand', { cmd: 'standards' }) }, 'Professional standards')));

  body.append(h('h3', {}, 'Callouts'));
  const co = d.callouts || {};
  body.append(h('p', {}, co.enabled ? chip('Automatic callouts ON', 'ok') : chip('Automatic callouts OFF', 'red'), ` ${co.open || 0} open, ${co.active || 0} with a scene running.`));
  body.append(h('div', { class: 'actions', style: 'margin-top:0' },
    co.enabled
      ? h('button', { class: 'small', type: 'button', onclick: call('admin:callouts', () => ({ on: false })) }, 'Turn off')
      : h('button', { class: 'small', type: 'button', onclick: call('admin:callouts', () => ({ on: true })) }, 'Turn on'),
    co.enabled ? h('button', { class: 'small', type: 'button', onclick: call('admin:callouts', () => ({ on: false, clear: true })) }, 'Turn off and cancel unreached calls') : null));
  const sc = select('f-adm-sc', (d.scenarios || []).map((x) => ({ value: x.id, label: `${x.id.replace(/_/g, ' ')}${x.weight ? '' : ' (weight 0)'}` })));
  sc.style.width = 'auto'; sc.style.flex = '1';
  body.append(h('div', { class: 'actions', style: 'flex-wrap:nowrap' }, sc,
    h('button', { class: 'small', type: 'button', onclick: call('admin:callout', () => ({ scenario: sc.value })) }, 'Start one near me')));

  body.append(h('h3', {}, 'Players'));
  const ul = h('ul', { class: 'rows' });
  for (const p of d.players || []) {
    ul.append(h('li', {}, h('span', {}, `${p.name}`, h('div', { class: 'note' }, `Server id ${p.src}`)),
      h('span', { class: 'actions', style: 'margin:0' },
        p.cuffed ? h('button', { class: 'small', type: 'button', onclick: call('admin:uncuff', () => ({ target: p.src }), () => { p.cuffed = false; }) }, 'Uncuff') : null,
        h('button', { class: 'small', type: 'button', onclick: call('admin:acecheck', () => ({ target: p.src }), (res) => { p.check = res.checks; }) }, 'Admin check'))));
    if (p.check) ul.append(h('li', {}, h('span', { class: 'note' }, p.check.map((c) => `${c.check}: ${c.result ? 'YES' : 'no'}`).join(' · '))));
  }
  body.append(ul);

  body.append(h('h3', {}, 'Integrations'));
  const il = h('ul', { class: 'rows' });
  for (const i of d.integrations || []) {
    il.append(h('li', {}, h('span', {}, i.name, h('div', { class: 'note' }, i.available ? `${i.resource} ${i.version || ''}${i.limited ? ' (limited)' : ''}` : (i.reason || 'not running'))),
      i.available ? chip('Running', 'ok') : chip('Not found')));
  }
  body.append(il);
}

const TASKS = { arrest: renderArrest, search: renderSearch, stopsearch: renderStopSearch, release: renderRelease, roadside: renderRoadside, scene: renderScene, custody: renderCustody, evidence: renderEvidence, person: renderPerson, call: renderCall, calls: renderCalls, locations: renderLocations, armoury: renderArmoury, incident: renderIncident, cases: renderCases, case: renderCase, standards: renderStandards, complaint: renderComplaint, changing: renderChanging, management: renderManagement, admin: renderAdmin };

/* ---------- consent prompt and notices ---------- */

let promptTimer = null;
function answerPrompt(choice) {
  if ($('prompt').hidden) return;
  $('prompt').hidden = true;
  clearInterval(promptTimer);
  fetch(`https://${resource}/prompt`, { method: 'POST', body: JSON.stringify({ choice }) }).catch(() => {});
}
function showPrompt(msg) {
  $('promptTitle').textContent = msg.title || '';
  $('promptText').textContent = msg.text || '';
  const actions = $('promptActions');
  actions.replaceChildren();
  (msg.options || []).forEach((o, i) => {
    actions.append(h('button', { class: i === 0 ? 'primary' : 'secondary', type: 'button', onclick: () => answerPrompt(o.id) }, o.label));
  });
  let left = msg.timeout || 20;
  const tick = () => { $('promptTimer').textContent = `No answer in ${left}s counts as a refusal.`; left -= 1; if (left < 0) answerPrompt(null); };
  clearInterval(promptTimer); tick(); promptTimer = setInterval(tick, 1000);
  $('prompt').hidden = false;
  const last = actions.lastElementChild;
  if (last) last.focus();
}

let noticeTimer = null;
function showNotice(msg) {
  $('noticeTitle').textContent = msg.title || '';
  $('noticeFrom').textContent = msg.from ? `From ${msg.from}` : '';
  $('noticeText').textContent = msg.text || '';
  $('notice').hidden = false;
  clearTimeout(noticeTimer);
  noticeTimer = setTimeout(() => { $('notice').hidden = true; }, 25000);
}

/* ---------- wiring ---------- */

function close() {
  $('hub').hidden = true;
  state.task = null;
  fetch(`https://${resource}/close`, { method: 'POST', body: '{}' }).catch(() => {});
}

const sounds = {};
function playSound(name, volume) {
  const a = sounds[name] || (sounds[name] = new Audio(`sounds/${name}.wav`));
  a.volume = Math.max(0, Math.min(1, volume == null ? 0.6 : volume));
  a.currentTime = 0;
  a.play().catch(() => {});
}

window.addEventListener('message', (e) => {
  const msg = fixLua(e.data || {});
  if (Array.isArray(msg)) return;
  if (msg.type === 'sound') return playSound(msg.name, msg.volume);
  if (msg.type === 'soundStop') { const a = sounds[msg.name]; if (a) a.pause(); return; }
  if (msg.type === 'custodyRefresh') {
    if (state.task && state.task.name === 'custody' && !$('hub').hidden) {
      request('custody:panel').then((res) => { if (!res.error && state.task && state.task.name === 'custody') { state.task.data = res; state.data = res; render(); } });
    }
    return;
  }
  if (msg.type === 'open') {
    state.data = msg.data; state.task = null;
    state.signingOff = false; state.notebook = null; state.correcting = null;
    $('hub').hidden = false;
    selectTab(msg.tab || 'duty');
  } else if (msg.type === 'task') {
    state.data = msg.data;
    state.task = { name: msg.task, target: msg.target, data: msg.data, location: msg.location };
    $('hub').hidden = false;
    render();
  } else if (msg.type === 'prompt') {
    showPrompt(msg);
  } else if (msg.type === 'promptClose') {
    $('prompt').hidden = true; clearInterval(promptTimer);
  } else if (msg.type === 'notice') {
    showNotice(msg);
  } else if (msg.type === 'close') {
    $('hub').hidden = true;
  } else if (msg.type === 'duty' && state.data) {
    state.data.duty = (msg.duty && !Array.isArray(msg.duty)) ? msg.duty : null;
    if (!state.data.duty) state.signingOff = false;
    if ($('hub').hidden) return;
    if (state.tab === 'duty' && !state.signingOff && !state.task && state.data.units) render(); else renderHeader();
  }
});

document.querySelectorAll('.tabs button').forEach((b) => b.addEventListener('click', () => selectTab(b.dataset.tab)));
$('close').addEventListener('click', close);
document.addEventListener('keydown', (e) => {
  if (e.key !== 'Escape') return;
  if (!$('prompt').hidden) return answerPrompt(null);
  if (!$('hub').hidden) close();
});
