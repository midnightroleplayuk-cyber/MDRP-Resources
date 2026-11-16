/* ============================================================================================================
   Apex Phone SDK 1.5.0 (apexphone-sdk.js)
   Drop this file into the page of your own phone app (the one you register with exports['apex_phone']:RegisterApp)
   and talk to the phone through window.ApexPhone. Full guide: docs/SDK.md in the apex_phone resource.

   Quick start:
     ApexPhone.ready().then(function (init) { ... });       // init = { theme, dark, accent, player, account, screen, os, ... }
     ApexPhone.on('theme', function (t) { ... });            // theme | size | resume | pause | player | event | lang | keyboard
     ApexPhone.call('list', { page: 1 }).then(...)           // your own server handler (exports['apex_phone']:RegisterAppRPC)
     ApexPhone.storage.set('settings', { sound: true });     // per app, per character, stored on the server
     ApexPhone.notify({ title: 'Taxi Rank', msg: 'New ride' });

   The file is plain ES5 on purpose (no arrow functions, no optional chaining, no template strings): the game's CEF is an
   old Chromium. It has no dependencies. It works outside the phone too (every call fails softly with code 'nophone').
   ============================================================================================================ */
(function (global) {
  'use strict';
  if (global.ApexPhone && global.ApexPhone.__sdk) return;

  var PHONE = (global.parent && global.parent !== global) ? global.parent : null;
  var TIMEOUT = 12000;
  var listeners = {}, pending = {}, seq = 0, info = null, readyQ = [], veraFns = {};
  var waiting = { contacts: [], player: [], location: [] };
  var config = { autoTheme: true, autoTyping: true, autoKeyboard: false };
  var kbField = null, kbShown = false, kbHeight = 0;

  /* ---------- helpers ---------- */
  function post(msg) { if (!PHONE) return false; try { PHONE.postMessage(msg, '*'); return true; } catch (e) { return false; } }
  function makeErr(code, detail) { var e = new Error(String(code)); e.code = String(code); if (detail !== undefined) e.detail = detail; return e; }
  function emit(ev, data) {
    var l = listeners[ev]; if (!l) return;
    l = l.slice();
    for (var i = 0; i < l.length; i++) { try { l[i](data); } catch (e) { if (global.console) console.error('[ApexPhone] listener "' + ev + '"', e); } }
  }
  function on(ev, fn) {
    if (typeof fn !== 'function') return function () {};
    (listeners[ev] = listeners[ev] || []).push(fn);
    return function () { off(ev, fn); };
  }
  function off(ev, fn) { var l = listeners[ev]; if (!l) return; var i = l.indexOf(fn); if (i > -1) l.splice(i, 1); }
  function isObj(v) { return !!v && typeof v === 'object'; }
  /* a Lua table with keys 1..n arrives as an array, an EMPTY table as {} : this always gives you an array */
  function list(v) { if (Array.isArray(v)) return v; if (isObj(v)) { var out = []; for (var k in v) if (Object.prototype.hasOwnProperty.call(v, k)) out.push(v[k]); return out; } return []; }
  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function el(html) { var d = global.document.createElement('div'); d.innerHTML = String(html).trim(); return d.firstElementChild || d.firstChild; }

  /* one request → one reply matched by id ({ apexphone:'rpc', id, result }) */
  function request(msg, kind) {
    return new Promise(function (resolve, reject) {
      var id = 'ap' + (++seq);
      var t = setTimeout(function () { delete pending[id]; reject(makeErr('timeout')); }, TIMEOUT);
      pending[id] = { resolve: resolve, reject: reject, t: t, kind: kind };
      msg.id = id;
      if (!post(msg)) { clearTimeout(t); delete pending[id]; reject(makeErr('nophone')); }
    });
  }
  function settle(p, r) {
    var kind = p.kind;
    if (r && isObj(r) && r.error) { p.reject(makeErr(r.error, r)); return; }
    if (kind === 'call') {
      /* envelope from server/sdk.lua: { ok, result }. A handler result with an `error` field rejects too, so your Lua can
         `return { error = 'notfound' }` and your page can catch it. */
      if (!r || !r.ok) { p.reject(makeErr('internal', r)); return; }
      var res = r.result === undefined ? null : r.result;
      if (isObj(res) && res.error) { p.reject(makeErr(res.error, res)); return; }
      p.resolve(res);
      return;
    }
    if (kind === 'kv.get') { var v = r && typeof r.v === 'string' ? r.v : null; if (v === null) { p.resolve(null); return; } try { p.resolve(JSON.parse(v)); } catch (e) { p.resolve(null); } return; }
    if (kind === 'kv.keys') { p.resolve(list(r && r.keys)); return; }
    if (kind === 'kv.set' || kind === 'kv.remove') { p.resolve(true); return; }
    p.resolve(r);
  }
  /* replies that carry no id (contacts, player, location): first asked, first served */
  function waitFor(type, msg) {
    return new Promise(function (resolve, reject) {
      var w = { resolve: resolve, reject: reject };
      w.t = setTimeout(function () { var i = waiting[type].indexOf(w); if (i > -1) waiting[type].splice(i, 1); reject(makeErr('timeout')); }, TIMEOUT);
      waiting[type].push(w);
      if (!post(msg)) { clearTimeout(w.t); waiting[type].pop(); reject(makeErr('nophone')); }
    });
  }
  function takeWaiting(type) { var w = waiting[type].shift(); if (w) clearTimeout(w.t); return w; }

  /* ---------- theme ---------- */
  var COLOR_OK = /^(#[0-9a-fA-F]{3,8}|rgba?\([\d .,%]+\))$/;
  function applyTheme(doc) {
    doc = doc || global.document;
    if (!doc || !doc.documentElement || !info) return false;
    var root = doc.documentElement, android = info.os === 'android';
    root.setAttribute('data-os', android ? 'android' : 'ios');
    root.setAttribute('data-theme', info.dark ? 'dark' : 'light');
    if (info.form) root.setAttribute('data-form', String(info.form));
    /* the phone shows the Nova UI blue when the accent is the PearOS default */
    var accent = String(info.accent || '');
    if (android && (!accent || accent.toUpperCase() === '#0088FF')) accent = '#3E7BFA';
    if (COLOR_OK.test(accent)) root.style.setProperty('--accent', accent);
    var tint = Number(info.glassTint);
    if (isFinite(tint)) root.style.setProperty('--ap-tint', String(Math.max(0, Math.min(100, tint)) / 100));
    if (info.screen && isFinite(info.screen.w)) { root.style.setProperty('--ap-screen-w', info.screen.w + 'px'); root.style.setProperty('--ap-screen-h', info.screen.h + 'px'); }
    if (info.lang) root.setAttribute('lang', String(info.lang).slice(0, 12));
    return true;
  }

  /* ---------- keyboard bridge (the phone's own keyboard typing into a field of THIS page) ----------
     The phone cannot reach into your document (other origin). ApexPhone.keyboard.show(field) asks the phone for its keyboard;
     the phone types into a hidden proxy and sends every change here, and the SDK writes it into `field` and fires 'input'.
     Enter fires 'change' and a keydown with key 'Enter'. The field gets the class 'ap-kb-on' while the phone keyboard is up
     (apexphone-ui.css draws the focus ring and hides the placeholder). The physical keyboard keeps working as usual. */
  function kbType(f) { var t = (f.getAttribute && f.getAttribute('type')) || ''; t = String(t).toLowerCase(); return ['tel', 'number', 'password', 'email', 'url', 'search'].indexOf(t) > -1 ? t : 'text'; }
  function fire(f, type) { try { f.dispatchEvent(new Event(type, { bubbles: true })); } catch (e) {} }
  /* the ring goes on the field and on its kit wrapper (.ap-li / .ap-field / .ap-search): the CEF has no :has() */
  function kbMark(f, on) { if (!f || !f.classList) return; f.classList[on ? 'add' : 'remove']('ap-kb-on'); var w = f.closest ? f.closest('.ap-li, .ap-field, .ap-search') : null; if (w) w.classList[on ? 'add' : 'remove']('ap-kb-on'); }
  var keyboard = {
    show: function (field, opts) {
      if (!field || typeof field !== 'object') return false;
      opts = opts || {};
      if (kbField && kbField !== field) kbMark(kbField, false);
      kbField = field; kbMark(field, true);
      var ml = Number(field.getAttribute && field.getAttribute('maxlength')) || Number(opts.maxLength) || 0;
      return post({ apexphone: 'keyboard', on: true, value: String(field.value == null ? '' : field.value), type: opts.type || kbType(field),
        hint: opts.hint || (field.getAttribute && field.getAttribute('enterkeyhint')) || (field.tagName === 'TEXTAREA' ? 'enter' : ''), maxLength: ml > 0 ? ml : 0,
        noCap: !!opts.noCap || /^(off|none|characters)$/i.test((field.getAttribute && field.getAttribute('autocapitalize')) || '') });
    },
    hide: function () { if (kbField) kbMark(kbField, false); kbField = null; return post({ apexphone: 'keyboard', on: false }); },
    /* every input/textarea under `root` (default: the document) asks for the phone keyboard when it gets the focus */
    attach: function (root) {
      root = root || global.document;
      root.addEventListener('focusin', function (e) { var t = e.target; if (t && t.matches && t.matches('input, textarea') && !t.matches('[type=checkbox], [type=range], [type=file], .ap-no-kb')) keyboard.show(t); });
      return keyboard;
    },
    get visible() { return kbShown; },
    get height() { return kbHeight; },
    get field() { return kbField; }
  };
  function handleKeyboard(m) {
    if ('shown' in m) { kbShown = !!m.shown; kbHeight = kbShown ? (Number(m.height) || 0) : 0; }
    if (kbField) {
      if (typeof m.value === 'string' && !m.hidden && kbField.value !== m.value) { kbField.value = m.value; fire(kbField, 'input'); }
      if (m.enter) {
        fire(kbField, 'change');
        try { kbField.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', bubbles: true })); } catch (e) {}
      }
      if (m.hidden) { kbMark(kbField, false); kbField = null; kbShown = false; kbHeight = 0; }
    }
    emit('keyboard', { shown: kbShown, height: kbHeight, enter: !!m.enter, hidden: !!m.hidden, value: m.value });
  }

  /* ---------- typing lock (the game must not get the letters you type) ----------
     Sent automatically on focusin/focusout of any field (config.autoTyping). Call ApexPhone.typing(true|false) yourself if you
     draw your own text editor. */
  function isField(t) { return !!(t && t.matches && (t.matches('input, textarea, select') || t.isContentEditable) && !t.matches('[type=checkbox], [type=range], [type=file]')); }
  function hookTyping() {
    var doc = global.document; if (!doc || hookTyping.done) return; hookTyping.done = true;
    doc.addEventListener('focusin', function (e) { if (!config.autoTyping) return; if (isField(e.target)) post({ apexphone: 'typing', on: true }); });
    doc.addEventListener('focusout', function () { if (!config.autoTyping) return; setTimeout(function () { post({ apexphone: 'typing', on: isField(doc.activeElement) }); }, 50); });
  }

  /* ---------- messages from the phone ---------- */
  function handleInit(m) {
    var first = !info;
    info = {};
    for (var k in m) if (Object.prototype.hasOwnProperty.call(m, k) && k !== 'apexphone') info[k] = m[k];
    if (config.autoTheme) applyTheme();
    if (config.autoKeyboard) keyboard.attach();
    if (first) { var q = readyQ; readyQ = []; for (var i = 0; i < q.length; i++) { try { q[i](info); } catch (e) { if (global.console) console.error('[ApexPhone] ready', e); } } }
    emit('init', info);
  }
  global.addEventListener('message', function (e) {
    var m = e.data; if (!m || typeof m !== 'object' || !m.apexphone) return;
    if (PHONE && e.source && e.source !== PHONE) return;   /* only the phone talks to us */
    switch (m.apexphone) {
      case 'init': handleInit(m); break;
      case 'theme': if (!info) info = {}; ['theme', 'dark', 'accent', 'lang', 'glassTint'].forEach(function (k) { if (k in m) info[k] = m[k]; }); if (config.autoTheme) applyTheme(); emit('theme', { theme: info.theme, dark: !!info.dark, accent: info.accent, lang: info.lang, glassTint: info.glassTint }); break;
      case 'size': if (!info) info = {}; ['screen', 'form', 'foldOpen', 'os', 'model'].forEach(function (k) { if (k in m) info[k] = m[k]; }); if (config.autoTheme) applyTheme(); emit('size', { screen: info.screen, form: info.form, foldOpen: !!info.foldOpen, os: info.os, model: info.model }); break;
      case 'lang': if (!info) info = {}; info.lang = m.lang; if (config.autoTheme) applyTheme(); emit('lang', m.lang); break;
      case 'resume': emit('resume'); break;
      case 'pause': emit('pause'); break;
      case 'player': if (!info) info = {}; info.player = m.player; (function () { var w = takeWaiting('player'); if (w) w.resolve(m.player); })(); emit('player', m.player); break;
      case 'rpc': (function () { var p = pending[m.id]; if (!p) return; clearTimeout(p.t); delete pending[m.id]; settle(p, m.result); })(); break;
      case 'contacts': (function () { var w = takeWaiting('contacts'); if (!w) return; if (m.error) w.reject(makeErr(m.error)); else w.resolve(list(m.list)); })(); break;
      case 'location': (function () { var w = takeWaiting('location'); if (!w) return; if (m.error || !m.coords) w.reject(makeErr(m.error || 'nolocation')); else w.resolve(m.coords); })(); break;
      case 'event': emit('event', { name: m.name, data: m.data }); emit('event:' + m.name, m.data); break;
      case 'keyboard': handleKeyboard(m); break;
      case 'auraCommand': (function () { var fn = veraFns[m.pattern]; if (fn) { try { fn(m.pattern); } catch (e) {} } emit('vera', m.pattern); })(); break;
    }
  });

  /* ---------- public API ---------- */
  var activity = {
    start: function (id, data) { return post(merge({ apexphone: 'activity', op: 'start', id: String(id) }, data)); },
    update: function (id, data) { return post(merge({ apexphone: 'activity', op: 'update', id: String(id) }, data)); },
    stop: function (id) { return post({ apexphone: 'activity', op: 'stop', id: String(id) }); }
  };
  function merge(a, b) { if (isObj(b)) for (var k in b) if (Object.prototype.hasOwnProperty.call(b, k) && !(k in a)) a[k] = b[k]; return a; }
  var storage = {
    get: function (k) { return request({ apexphone: 'kv', op: 'get', k: String(k) }, 'kv.get'); },
    set: function (k, v) { var s; try { s = JSON.stringify(v === undefined ? null : v); } catch (e) { return Promise.reject(makeErr('invalid')); } return request({ apexphone: 'kv', op: 'set', k: String(k), v: s }, 'kv.set'); },
    remove: function (k) { return request({ apexphone: 'kv', op: 'remove', k: String(k) }, 'kv.remove'); },
    keys: function () { return request({ apexphone: 'kv', op: 'keys' }, 'kv.keys'); }
  };
  var theme = {
    apply: applyTheme,
    get dark() { return !!(info && info.dark); },
    get accent() { return info ? info.accent : null; },
    get os() { return info ? info.os : null; }
  };

  var ApexPhone = {
    __sdk: '1.5.0',
    version: '1.5.0',
    config: config,
    /* resolves with the init payload (immediately if it already arrived) */
    ready: function () { return new Promise(function (resolve) { if (info) resolve(info); else readyQ.push(resolve); }); },
    get info() { return info; },
    get inPhone() { return !!PHONE; },
    on: on, off: off,
    /* actions on the phone */
    notify: function (o) { o = isObj(o) ? o : { msg: String(o) }; return post({ apexphone: 'notify', title: o.title, msg: o.msg }); },
    toast: function (msg) { return post({ apexphone: 'toast', msg: String(msg) }); },
    close: function () { return post({ apexphone: 'close' }); },
    openApp: function (id) { return post({ apexphone: 'openApp', id: String(id) }); },
    openURL: function (url) { return post({ apexphone: 'openURL', url: String(url) }); },
    setWaypoint: function (x, y, name) { return post({ apexphone: 'setWaypoint', x: Number(x), y: Number(y), name: name }); },
    /* phone call and Messages thread (the old 'call' and 'message' messages) */
    dial: function (number, name) { return post({ apexphone: 'call', number: String(number), name: name }); },
    message: function (number, name) { return post({ apexphone: 'message', number: String(number), name: name }); },
    /* data from the phone (contacts and location ask the player for permission the first time) */
    getPlayer: function () { return waitFor('player', { apexphone: 'getPlayer' }); },
    getContacts: function () { return waitFor('contacts', { apexphone: 'getContacts' }); },
    getLocation: function () { return waitFor('location', { apexphone: 'getLocation' }); },
    /* phone RPCs allowed to external apps (Config.ExternalApps.rpc) */
    rpc: function (name, data) { return request({ apexphone: 'rpc', name: String(name), data: data }, 'rpc'); },
    /* YOUR server: exports['apex_phone']:RegisterAppRPC(appId, name, function(src, data) ... end) */
    call: function (name, data) { return request({ apexphone: 'appcall', name: String(name), data: data === undefined ? null : data }, 'call'); },
    storage: storage,
    widget: function (def) { return post(merge({ apexphone: 'widget' }, def)); },
    activity: activity,
    /* Vera: when the player says something that matches `pattern`, the phone answers `reply` and calls fn (optional) */
    vera: function (pattern, reply, fn) { if (typeof fn === 'function') veraFns[String(pattern)] = fn; return post({ apexphone: 'vera', pattern: String(pattern), reply: String(reply) }); },
    typing: function (on) { return post({ apexphone: 'typing', on: !!on }); },
    setBadge: function (n) { return post({ apexphone: 'setBadge', n: Number(n) || 0 }); },
    haptic: function (kind) { return post({ apexphone: 'haptic', kind: kind || 'light' }); },
    sound: function (name) { return post({ apexphone: 'sound', name: String(name) }); },
    keyboard: keyboard,
    theme: theme,
    util: { list: list, esc: esc, el: el }
  };
  global.ApexPhone = ApexPhone;

  /* say hello: if the phone already sent 'init' before this script ran, it sends it again */
  if (global.document && global.document.readyState !== 'loading') hookTyping(); else global.document.addEventListener('DOMContentLoaded', hookTyping);
  post({ apexphone: 'ready' });
})(typeof window !== 'undefined' ? window : this);
