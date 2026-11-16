/* Taxi Rank: the page of the example app. Everything that talks to the phone goes through window.ApexPhone (apexphone-sdk.js).
   The DOM is built once and updated in place (no flashing re-renders); only transform and opacity animate. */
(function () {
  'use strict';
  var $ = function (id) { return document.getElementById(id); };
  var esc = ApexPhone.util.esc, list = ApexPhone.util.list;

  /* state the harness can read: window.__apExample */
  var S = { init: null, rides: [], me: null, filter: 'all', settings: { driver: false, sound: true, compact: false }, tab: 'rides', open: null, errors: [], events: [], listOk: false };
  window.__apExample = S;

  var pages = { rides: $('pageRides'), new: $('pageNew'), settings: $('pageSettings') };
  var titles = { rides: 'Rides', new: 'New ride', settings: 'Settings' };
  var rows = {};   /* ride id → row element */

  /* ---------- small helpers ---------- */
  function toast(msg) { var t = $('toast'); t.textContent = msg; t.classList.add('in'); clearTimeout(toast.t); toast.t = setTimeout(function () { t.classList.remove('in'); }, 1800); }
  function fail(e) { var code = e && e.code ? e.code : String(e); S.errors.push(code); toast(MSG[code] || ('Error: ' + code)); if (S.settings.sound) ApexPhone.sound('error'); }
  var MSG = { fields: 'Fill in the pickup and the destination.', taken: 'Someone already took this ride.', own: 'This is your own ride.', notfound: 'This ride is gone.', forbidden: 'Only the requester or the driver can remove it.', nohandler: 'The server side of Taxi Rank is not running.', ratelimit: 'Too fast. Try again in a moment.', timeout: 'The phone did not answer.', nophone: 'Open this page inside the phone.' };
  function timeAgo(ms) { var d = Math.max(0, Date.now() - ms); if (d < 60e3) return 'just now'; if (d < 3600e3) return Math.floor(d / 60e3) + ' min ago'; if (d < 86400e3) return Math.floor(d / 3600e3) + ' h ago'; return Math.floor(d / 86400e3) + ' d ago'; }
  function initials(name) { return String(name || '?').split(/\s+/).slice(0, 2).map(function (w) { return w.charAt(0); }).join('').toUpperCase() || '?'; }
  function press(el, e) { /* glass press glow: --px/--py from the finger, class for 400 ms */ var r = el.getBoundingClientRect(); el.style.setProperty('--px', (e.clientX - r.left) + 'px'); el.style.setProperty('--py', (e.clientY - r.top) + 'px'); el.classList.remove('ap-press'); void el.offsetWidth; el.classList.add('ap-press'); }

  /* ---------- tabs ---------- */
  function go(tab) {
    if (!pages[tab]) return;
    S.tab = tab;
    Object.keys(pages).forEach(function (k) { pages[k].hidden = k !== tab; });
    Array.prototype.forEach.call(document.querySelectorAll('.ap-tab'), function (t) { t.classList.toggle('on', t.getAttribute('data-tab') === tab); });
    $('navTitle').textContent = titles[tab];
    onScroll();
    if (S.settings.sound) ApexPhone.sound('click');
  }
  $('tabbar').addEventListener('click', function (e) { var t = e.target.closest('.ap-tab'); if (t) go(t.getAttribute('data-tab')); });
  $('tabbar').addEventListener('pointerdown', function (e) { var p = e.target.closest('.ap-tb-pill'); if (p) press(p, e); });
  /* the small title fades in when the large one scrolls away */
  function onScroll() { var p = pages[S.tab]; $('nav').classList.toggle('ap-show-title', p.scrollTop > 38); $('nav').classList.toggle('ap-solid', p.scrollTop > 6); }
  Object.keys(pages).forEach(function (k) { pages[k].addEventListener('scroll', onScroll, { passive: true }); });

  /* ---------- rides list: build once, update in place ---------- */
  function visible(r) { if (S.filter === 'open') return r.status === 'open'; if (S.filter === 'mine') return r.by === S.me || r.driver === S.me; return true; }
  function rowHTML() {
    return '<div class="ap-li ride"><div class="ap-avatar"></div><div class="ap-li-body"><div class="ap-li-label"></div><div class="ap-li-sub ride-line"></div><div class="ap-li-sub ride-note"></div></div><div class="ride-right"><span class="ride-time"></span><span class="ap-pill"></span></div><svg class="ap-chev" viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg></div>';
  }
  function fillRow(el, r) {
    var mine = r.by === S.me;
    el.querySelector('.ap-avatar').textContent = initials(r.byName);
    el.querySelector('.ap-li-label').textContent = r.from;
    el.querySelector('.ride-line').textContent = 'to ' + r.to + ' · ' + r.pax + (r.pax === 1 ? ' passenger' : ' passengers') + (r.status === 'taken' ? ' · driver ' + (r.driverName || '') : mine ? ' · your ride' : ' · ' + (r.byName || ''));
    el.querySelector('.ride-note').textContent = r.note ? r.note : '';
    el.querySelector('.ride-time').textContent = timeAgo(r.created);
    var pill = el.querySelector('.ap-pill'); pill.textContent = r.status === 'taken' ? 'taken' : 'open'; pill.className = 'ap-pill ' + (r.status === 'taken' ? '' : 'ap-green');
    el.classList.toggle('taken', r.status === 'taken'); el.classList.toggle('mine', mine);
    el.hidden = !visible(r);
  }
  function render() {
    var box = $('rideList'), seen = {}, order = S.rides.slice().sort(function (a, b) { return b.created - a.created; });
    order.forEach(function (r, i) {
      seen[r.id] = true;
      var el = rows[r.id];
      if (!el) { el = ApexPhone.util.el(rowHTML()); el.onclick = function () { openSheet(r.id); }; rows[r.id] = el; }
      fillRow(el, r);
      /* keep the DOM in the sorted order without rebuilding: move only when the position is wrong */
      var ref = box.children[i]; if (ref !== el) box.insertBefore(el, ref || null);
    });
    Object.keys(rows).forEach(function (id) { if (!seen[id]) { rows[id].remove(); delete rows[id]; } });
    var shown = order.filter(visible).length, open = S.rides.filter(function (r) { return r.status === 'open'; }).length;
    $('ridesEmpty').hidden = shown > 0; box.hidden = shown === 0;
    $('ridesSub').textContent = open === 0 ? 'No open rides' : open === 1 ? '1 open ride' : open + ' open rides';
    $('tabBadge').textContent = open > 0 ? String(open) : '';
    ApexPhone.setBadge(open);
    document.body.classList.toggle('compact', !!S.settings.compact);
  }
  $('filters').addEventListener('click', function (e) { var c = e.target.closest('span'); if (!c) return; S.filter = c.getAttribute('data-f'); Array.prototype.forEach.call($('filters').children, function (x) { x.classList.toggle('on', x === c); }); render(); if (S.settings.sound) ApexPhone.sound('click'); });

  function load() {
    return ApexPhone.call('list').then(function (r) {
      S.rides = list(r && r.items); S.me = r && r.me != null ? r.me : S.me; S.listOk = true;
      render();
    }).catch(fail);
  }
  $('btnRefresh').addEventListener('pointerdown', function (e) { press(e.currentTarget, e); });
  $('btnRefresh').addEventListener('click', function () { ApexPhone.haptic(); load().then(function () { toast('Updated'); }); });

  /* ---------- live pushes from the server (exports['apex_phone']:PushToApp) ---------- */
  function upsert(r) { if (!r || r.id == null) return; var i = -1; S.rides.forEach(function (x, k) { if (x.id === r.id) i = k; }); if (i > -1) S.rides[i] = r; else S.rides.push(r); }
  ApexPhone.on('event', function (ev) { S.events.push(ev.name); });
  ApexPhone.on('event:ride:new', function (r) { upsert(r); render(); if (rows[r.id]) { rows[r.id].classList.add('ap-new'); setTimeout(function () { rows[r.id] && rows[r.id].classList.remove('ap-new'); }, 400); } if (r.by !== S.me) { toast((r.byName || 'Someone') + ' needs a taxi'); if (S.settings.sound) ApexPhone.sound('notify'); } });
  ApexPhone.on('event:ride:update', function (r) { upsert(r); render(); if (S.open === r.id) fillSheet(r); });
  ApexPhone.on('event:ride:remove', function (d) { S.rides = S.rides.filter(function (x) { return x.id !== d.id; }); render(); if (S.open === d.id) closeSheet(); });
  ApexPhone.on('resume', function () { load(); });   /* came back from the app switcher: refresh */

  /* ---------- new ride ---------- */
  var pax = 1;
  $('segPax').addEventListener('click', function (e) { var d = e.target.closest('div'); if (!d || d.parentNode !== $('segPax')) return; pax = Number(d.textContent) || 1; Array.prototype.forEach.call($('segPax').children, function (x) { x.classList.toggle('on', x === d); }); if (S.settings.sound) ApexPhone.sound('click'); });
  $('btnSave').addEventListener('click', function () {
    var from = $('fFrom').value.trim(), to = $('fTo').value.trim(), note = $('fNote').value.trim();
    if (!from || !to) { fail({ code: 'fields' }); return; }
    var btn = $('btnSave'); btn.classList.add('ap-dis');
    var pos = $('fShare').checked ? ApexPhone.getLocation().catch(function () { return null; }) : Promise.resolve(null);
    pos.then(function (c) {
      return ApexPhone.call('save', { from: from, to: to, note: note, pax: pax, x: c ? c.x : null, y: c ? c.y : null });
    }).then(function (r) {
      $('fFrom').value = ''; $('fTo').value = ''; $('fNote').value = '';
      if (r && r.ride) upsert(r.ride);
      render(); if (S.settings.sound) ApexPhone.sound('success');
      toast('Ride requested'); go('rides');
    }).catch(fail).then(function () { btn.classList.remove('ap-dis'); });
  });

  /* ---------- ride sheet ---------- */
  function rideById(id) { for (var i = 0; i < S.rides.length; i++) if (S.rides[i].id === id) return S.rides[i]; return null; }
  function fillSheet(r) {
    $('dAvatar').textContent = initials(r.byName); $('dName').textContent = r.byName || 'Someone';
    $('dMeta').textContent = timeAgo(r.created) + (r.number ? ' · ' + r.number : '');
    var st = $('dStatus'); st.textContent = r.status === 'taken' ? 'taken by ' + (r.driverName || 'a driver') : 'open'; st.className = 'ap-pill ' + (r.status === 'taken' ? '' : 'ap-green');
    $('dFrom').textContent = r.from; $('dTo').textContent = r.to; $('dPax').textContent = r.pax;
    $('dNoteRow').hidden = !r.note; $('dNote').textContent = r.note || '';
    var mine = r.by === S.me, driver = r.driver === S.me;
    $('btnTake').hidden = r.status !== 'open' || mine;
    $('btnWaypoint').classList.toggle('ap-dis', !(isFinite(r.x) && isFinite(r.y)) || r.x === null);
    $('btnMessage').classList.toggle('ap-dis', !r.number || mine);
    $('btnDelete').classList.toggle('ap-dis', !(mine || driver));
  }
  function openSheet(id) { var r = rideById(id); if (!r) return; S.open = id; fillSheet(r); $('sheetWrap').classList.add('in'); if (S.settings.sound) ApexPhone.sound('click'); }
  function closeSheet() { S.open = null; $('sheetWrap').classList.remove('in'); }
  $('sheetClose').addEventListener('click', closeSheet);
  $('sheetWrap').addEventListener('click', function (e) { if (e.target === $('sheetWrap')) closeSheet(); });
  $('btnTake').addEventListener('click', function () { var r = rideById(S.open); if (!r) return; ApexPhone.call('take', { id: r.id }).then(function (res) { if (res && res.ride) { upsert(res.ride); render(); fillSheet(res.ride); } if (S.settings.sound) ApexPhone.sound('success'); toast('You took this ride'); }).catch(fail); });
  $('btnWaypoint').addEventListener('click', function () { var r = rideById(S.open); if (!r || !isFinite(r.x)) return; ApexPhone.setWaypoint(r.x, r.y, 'Taxi: ' + r.from); toast('Waypoint set'); });
  $('btnMessage').addEventListener('click', function () { var r = rideById(S.open); if (!r || !r.number) return; ApexPhone.message(r.number, r.byName); });
  $('btnDelete').addEventListener('click', function () { var r = rideById(S.open); if (!r) return; ApexPhone.call('delete', { id: r.id }).then(function () { S.rides = S.rides.filter(function (x) { return x.id !== r.id; }); render(); closeSheet(); toast('Ride removed'); }).catch(fail); });

  /* ---------- settings: stored on the server with ApexPhone.storage (per app, per character) ---------- */
  var SET = { driver: 'sDriver', sound: 'sSound', compact: 'sCompact' };
  function showSettings() { Object.keys(SET).forEach(function (k) { $(SET[k]).checked = !!S.settings[k]; }); document.body.classList.toggle('compact', !!S.settings.compact); }
  Object.keys(SET).forEach(function (k) { $(SET[k]).addEventListener('change', function () { S.settings[k] = $(SET[k]).checked; showSettings(); ApexPhone.storage.set('settings', S.settings).then(function () { if (S.settings.sound) ApexPhone.sound('click'); }).catch(fail); }); });
  $('btnTestNotify').addEventListener('click', function () { ApexPhone.notify({ title: 'Taxi Rank', msg: 'This is how a new ride looks.' }); });

  /* ---------- boot ---------- */
  function about(init) {
    var p = init.player || {};
    $('aboutName').textContent = ((p.firstname || '') + ' ' + (p.lastname || '')).trim() || (init.account && init.account.username) || 'you';
    $('aboutOS').textContent = (init.os === 'android' ? 'Nova UI' : 'PearOS') + (init.dark ? ' dark' : ' light') + (init.screen ? ' · ' + init.screen.w + 'x' + init.screen.h : '');
    $('aboutSdk').textContent = ApexPhone.version;
  }
  ApexPhone.ready().then(function (init) {
    S.init = init; about(init);
    ApexPhone.keyboard.attach();   /* the phone's own keyboard for our fields (physical keyboard works as well) */
    ApexPhone.storage.get('settings').then(function (v) { if (v && typeof v === 'object') Object.keys(SET).forEach(function (k) { if (k in v) S.settings[k] = !!v[k]; }); showSettings(); }).catch(function () {});
    return load();
  });
  ApexPhone.on('theme', function () { if (S.init) about(S.init); });
  ApexPhone.on('size', function (g) { if (S.init) { S.init.screen = g.screen; about(S.init); } });
  /* refresh the "x min ago" lines once a minute, in place */
  setInterval(function () { S.rides.forEach(function (r) { if (rows[r.id]) fillRow(rows[r.id], r); }); }, 60000);
})();
