const app = document.getElementById('app');
const tablet = document.getElementById('tablet');
const form = document.getElementById('form');
const citizenView = document.getElementById('citizenView');
const officerView = document.getElementById('officerView');
const list = document.getElementById('list');
const detail = document.getElementById('det');
const toast = document.getElementById('toast');
const submitButton = document.getElementById('submitButton');

let complaints = [];
let selectedId = null;
let currentMode = 'submit';
let toastTimer;

const statusLabels = {
  submitted: 'Submitted',
  reviewed: 'Under review',
  psd: 'Referred to PSD',
  iopc: 'Referred to IOPC',
  closed: 'Closed'
};

function post(endpoint, data = {}) {
  if (typeof GetParentResourceName !== 'function') {
    return Promise.resolve({ ok: true, preview: true });
  }
  return fetch(`https://${GetParentResourceName()}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  }).then((response) => response.json());
}

function showToast(message, kind = 'info') {
  toast.textContent = message;
  toast.className = `toast ${kind === 'error' ? 'error' : kind === 'success' ? 'success' : ''}`;
  window.clearTimeout(toastTimer);
  toastTimer = window.setTimeout(() => toast.classList.add('hidden'), 4200);
}

function escapeText(value) {
  return String(value ?? '');
}

function makeElement(tag, className, text) {
  const element = document.createElement(tag);
  if (className) element.className = className;
  if (text !== undefined) element.textContent = escapeText(text);
  return element;
}

function addField(parent, label, value, className = 'detail-item') {
  const wrapper = makeElement('div', className);
  wrapper.append(makeElement('label', '', label), makeElement('p', '', value || 'Not provided'));
  parent.append(wrapper);
  return wrapper;
}

function formatDate(value) {
  if (!value) return 'Date unavailable';
  const date = new Date(String(value).replace(' ', 'T'));
  if (Number.isNaN(date.getTime())) return String(value);
  return new Intl.DateTimeFormat('en-GB', {
    dateStyle: 'medium',
    timeStyle: 'short'
  }).format(date);
}

function filteredComplaints() {
  const query = document.getElementById('search').value.trim().toLowerCase();
  const status = document.getElementById('flt').value;
  return complaints.filter((item) => {
    const matchesStatus = status === 'all' || item.status === status;
    const searchable = [item.reference, item.citizen_name, item.title, item.category]
      .map((value) => String(value || '').toLowerCase())
      .join(' ');
    return matchesStatus && searchable.includes(query);
  });
}

function renderList() {
  const rows = filteredComplaints();
  list.replaceChildren();
  document.getElementById('recordCount').textContent =
    `${complaints.length} ${complaints.length === 1 ? 'record' : 'records'}`;

  if (!rows.length) {
    list.append(makeElement('p', 'empty-list', complaints.length
      ? 'No complaints match your search or status filter.'
      : 'There are no complaints to display.'));
    renderDetail(null);
    return;
  }

  rows.forEach((item) => {
    const card = makeElement('button', `complaint-card${item.id === selectedId ? ' selected' : ''}`);
    card.type = 'button';
    card.setAttribute('role', 'listitem');
    card.setAttribute('aria-pressed', String(item.id === selectedId));
    card.append(
      makeElement('strong', '', item.reference),
      makeElement('span', 'card-title', item.title),
      makeElement('span', 'meta', `${item.citizen_name || 'Anonymous'} · ${formatDate(item.submitted_at || item.created_at)}`)
    );
    const status = makeElement('span', `status ${item.status || 'submitted'}`, statusLabels[item.status] || 'Submitted');
    card.append(status);
    card.addEventListener('click', () => {
      selectedId = item.id;
      renderList();
    });
    list.append(card);
  });

  const selected = rows.find((item) => item.id === selectedId) || rows[0];
  selectedId = selected.id;
  renderDetail(selected);
}

function renderDetail(item) {
  detail.replaceChildren();
  detail.classList.toggle('empty', !item);
  if (!item) {
    const empty = makeElement('div', 'empty-detail');
    empty.append(
      makeElement('span', '', '◎'),
      makeElement('strong', '', 'Select a complaint'),
      makeElement('p', '', 'Choose a record from the list to review its details.')
    );
    detail.append(empty);
    return;
  }

  const head = makeElement('div', 'detail-head');
  head.append(
    makeElement('span', 'detail-ref', item.reference),
    makeElement('h3', '', item.title),
    makeElement('p', 'detail-sub', `${item.category} · ${formatDate(item.submitted_at || item.created_at)}`)
  );
  const status = makeElement('span', `status ${item.status || 'submitted'}`, statusLabels[item.status] || 'Submitted');
  head.append(status);
  detail.append(head);

  const grid = makeElement('div', 'detail-grid');
  addField(grid, 'Submitted by', item.citizen_name || 'Anonymous');
  addField(grid, 'Location', item.location);
  addField(grid, 'Contact details', item.contact);
  addField(grid, 'Last updated by', item.officer_name || item.updated_by || 'Unassigned');
  detail.append(grid);

  addField(detail, 'Complaint details', item.description, 'detail-section');

  const notes = makeElement('section', 'detail-section');
  notes.append(makeElement('label', '', 'Staff review notes'));
  const noteText = String(item.officer_note || '').trim();
  if (noteText) {
    notes.append(makeElement('p', 'note-box', noteText));
  } else {
    notes.append(makeElement('p', '', 'No review notes have been added.'));
  }
  const noteForm = makeElement('form', 'note-form');
  const noteInput = document.createElement('textarea');
  noteInput.name = 'note';
  noteInput.maxLength = 1000;
  noteInput.required = true;
  noteInput.placeholder = 'Add an internal review note…';
  noteInput.setAttribute('aria-label', 'Add an internal review note');
  const noteButton = makeElement('button', 'button button-secondary', 'Add note');
  noteButton.type = 'submit';
  noteForm.append(noteInput, noteButton);
  noteForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    noteButton.disabled = true;
    try {
      const result = await post('addNote', { id: item.id, note: noteInput.value });
      showToast(result.message || (result.ok ? 'Review note added.' : 'The note could not be saved.'), result.ok ? 'success' : 'error');
      if (result.ok) await refreshComplaints();
    } catch {
      showToast('Could not reach the server. Please try again.', 'error');
    } finally {
      noteButton.disabled = false;
    }
  });
  notes.append(noteForm);
  detail.append(notes);

  const actions = makeElement('div', 'detail-actions');
  const statusSelect = document.createElement('select');
  statusSelect.setAttribute('aria-label', 'Update complaint status');
  Object.entries(statusLabels).forEach(([value, label]) => {
    const option = document.createElement('option');
    option.value = value;
    option.textContent = label;
    option.selected = value === item.status;
    statusSelect.append(option);
  });
  const updateButton = makeElement('button', 'button button-primary', 'Update status');
  updateButton.type = 'button';
  updateButton.addEventListener('click', async () => {
    updateButton.disabled = true;
    try {
      const result = await post('setStatus', { id: item.id, status: statusSelect.value });
      showToast(result.message || (result.ok ? 'Complaint status updated.' : 'Status could not be updated.'), result.ok ? 'success' : 'error');
      if (result.ok) await refreshComplaints();
    } catch {
      showToast('Could not reach the server. Please try again.', 'error');
    } finally {
      updateButton.disabled = false;
    }
  });
  actions.append(statusSelect, updateButton);
  detail.append(actions);
}

async function refreshComplaints() {
  await post('refresh');
}

document.getElementById('close').addEventListener('click', () => post('close'));
document.getElementById('refr').addEventListener('click', refreshComplaints);
document.getElementById('search').addEventListener('input', renderList);
document.getElementById('flt').addEventListener('change', renderList);

document.getElementById('anon').addEventListener('change', (event) => {
  const contact = document.getElementById('contact');
  if (event.target.checked) {
    contact.value = '';
    contact.disabled = true;
    contact.placeholder = 'Not collected for anonymous submissions';
  } else {
    contact.disabled = false;
    contact.placeholder = 'Optional contact details';
  }
});

document.getElementById('title').addEventListener('input', (event) => {
  document.getElementById('titleCount').textContent = `${event.target.value.length} / 100`;
});
document.getElementById('desc').addEventListener('input', (event) => {
  document.getElementById('descCount').textContent = `${event.target.value.length} / 2000`;
});
form.addEventListener('reset', () => {
  window.setTimeout(() => {
    document.getElementById('anon').dispatchEvent(new Event('change'));
    document.getElementById('titleCount').textContent = '0 / 100';
    document.getElementById('descCount').textContent = '0 / 2000';
  });
});

form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const title = document.getElementById('title');
  const description = document.getElementById('desc');
  if (!title.value.trim() || !description.value.trim()) {
    showToast('Please add a subject and describe what happened.', 'error');
    (!title.value.trim() ? title : description).focus();
    return;
  }

  submitButton.disabled = true;
  submitButton.querySelector('span').textContent = 'Submitting…';
  try {
    const result = await post('submit', {
      category: document.getElementById('cat').value,
      title: title.value,
      location: document.getElementById('loc').value,
      contact: document.getElementById('contact').value,
      desc: description.value,
      anonymous: document.getElementById('anon').checked
    });
    showToast(result.message || (result.ok ? 'Your complaint has been lodged.' : 'The complaint could not be submitted.'), result.ok ? 'success' : 'error');
    if (result.ok) {
      form.reset();
      document.getElementById('anon').dispatchEvent(new Event('change'));
    }
  } catch {
    showToast('Could not reach the server. Please try again.', 'error');
  } finally {
    submitButton.disabled = false;
    submitButton.querySelector('span').textContent = 'Lodge complaint';
  }
});

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && !app.classList.contains('hidden')) post('close');
});

window.addEventListener('message', (event) => {
  const message = event.data || {};
  if (message.action === 'open') {
    currentMode = message.mode || 'submit';
    tablet.classList.remove('hidden');
    app.classList.remove('hidden');
    citizenView.classList.toggle('hidden', currentMode !== 'submit');
    officerView.classList.toggle('hidden', currentMode !== 'officer');
    document.getElementById('heading').textContent = currentMode === 'officer'
      ? 'Complaint register'
      : 'Complaints & enquiries';
    document.getElementById('subheading').textContent = currentMode === 'officer'
      ? 'Professional standards review'
      : 'Tell us about your experience';
    if (currentMode === 'officer') refreshComplaints();
  } else if (message.action === 'close') {
    app.classList.add('hidden');
    tablet.classList.add('hidden');
  } else if (message.action === 'data') {
    complaints = Array.isArray(message.data) ? message.data : [];
    if (!complaints.some((item) => item.id === selectedId)) selectedId = null;
    renderList();
  } else if (message.action === 'toast') {
    showToast(message.message || '', message.kind);
  }
});
