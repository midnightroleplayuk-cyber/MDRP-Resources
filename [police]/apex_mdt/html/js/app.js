/* ============================================================
   Apex MDT - NUI
   Dual-mode (police / EMS) tablet. Boot → auth → OS with a
   mode-aware app rail. Live map uses the apex_bossmenu method.
   ============================================================ */
const RES = (() => { try { return window.GetParentResourceName ? window.GetParentResourceName() : 'apex_mdt'; } catch { return 'apex_mdt'; } })();

const $  = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
const h  = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c]));
const post = (name, data = {}) => fetch(`https://${RES}/${name}`, { method:'POST', body: JSON.stringify(data) }).catch(() => {});
const postR = (name, data = {}) => fetch(`https://${RES}/${name}`, { method:'POST', body: JSON.stringify(data) }).then(r => r.json()).catch(() => null);
async function call(name, ...args) {
    try {
        const r = await fetch(`https://${RES}/cb`, { method:'POST', body: JSON.stringify({ name, args }) });
        const j = await r.json();
        return (j && j.ret) ? j.ret : [];
    } catch { return []; }
}
const money = (n) => (STATE.cfg?.currency?.symbol || '$') + Number(n || 0).toLocaleString('en-US');
const initials = (name) => String(name || '?').trim().split(/\s+/).slice(0,2).map(w => w[0] || '').join('').toUpperCase() || '?';
const ago = (ts) => { if (!ts) return ''; const d = new Date(String(ts).replace(' ','T') + (String(ts).includes('Z')?'':'')); const s = Math.max(0,(Date.now()-d.getTime())/1000); if (isNaN(s)) return String(ts); if (s<60) return 'just now'; if (s<3600) return Math.floor(s/60)+'m ago'; if (s<86400) return Math.floor(s/3600)+'h ago'; return Math.floor(s/86400)+'d ago'; };
const L = (k, fb) => (STATE.cfg?.locale?.[k]) || fb || k;
const feat = (k) => STATE.cfg?.features?.[k] !== false;
const debounce = (fn, ms = 250) => { let t; return (...a) => { clearTimeout(t); t = setTimeout(() => fn(...a), ms); }; };
// Resolve the palette + identity for the active mode (police vs ems),
// merged over the shared base theme. Drives the whole tablet's retint.
const modeTheme = () => { const t = STATE.cfg?.theme || {}; const m = t[STATE.mode] || t.police || {}; return { ...t, ...m }; };
// Profile photo source: a captured photo wins, otherwise the configured
// default image (img/perfil.png) is used for EVERY profile photo slot.
const avatarUrl = (u) => u || (STATE.cfg && STATE.cfg.avatar && STATE.cfg.avatar.defaultUrl) || 'img/perfil.png';
// Localise static markup: [data-i18n] → textContent, [data-i18n-ph] → placeholder.
// The current (English) content is used as the fallback so nothing ever blanks.
function applyStaticI18n(){
    document.querySelectorAll('[data-i18n]').forEach(el => { el.textContent = L(el.getAttribute('data-i18n'), el.textContent); });
    document.querySelectorAll('[data-i18n-ph]').forEach(el => { el.setAttribute('placeholder', L(el.getAttribute('data-i18n-ph'), el.getAttribute('placeholder') || '')); });
}

let STATE = {
    open: false, mode: 'police', officer: {}, cfg: {}, duty: false,
    activeApp: null, calls: [], units: [], map: null, mapBuilt: false, markers: [],
    selected: {}, batt: 100, lastInput: Date.now(), favs: [],
};

/* ── Device preferences (control center): brightness, notifications, sounds ── */
const Prefs = (() => {
    const KEY = 'apex_mdt_prefs_v1';
    const defaults = { notifications: true, sounds: true, brightness: 1 };
    let state = { ...defaults };
    try { const r = localStorage.getItem(KEY); if (r) state = { ...defaults, ...JSON.parse(r) }; } catch {}
    function apply(){ document.documentElement.style.setProperty('--screen-bright', state.brightness); }
    function get(k){ return state[k]; }
    function set(k, v){ state[k] = v; try { localStorage.setItem(KEY, JSON.stringify(state)); } catch {} apply(); }
    apply();
    return { get, set, get state(){ return state; } };
})();

/* ============================================================
   SETTINGS - theme (brand + bg + opacity + scale), persisted
   ============================================================ */
const Settings = (() => {
    const KEY = 'apex_mdt_settings_v2';   // v2: brand/bg persisted PER MODE
    const root = document.documentElement;
    const defaults = { brand: '#1F5EFF', bg: '#0A0A0B', opacity: 1.0, scale: 1.0, theme: 'dark' };
    let state = { ...defaults };
    // persisted: global opacity/scale + per-mode { brand, bg } overrides
    let saved = { opacity: 1.0, scale: 1.0, modes: {} };
    let curMode = 'police';
    const hexToRgb = (hex) => { const m = hex.replace('#',''); const n = parseInt(m,16); return m.length===6 ? [n>>16&255,n>>8&255,n&255] : [31,94,255]; };
    const shade = (hex,p) => { const [r,g,b]=hexToRgb(hex); const f=p<0?0:255,t=Math.abs(p),s=c=>Math.round((f-c)*t+c); return `rgb(${s(r)},${s(g)},${s(b)})`; };
    const mixWhite = (hex,p) => { const [r,g,b]=hexToRgb(hex); const m=c=>Math.round(c+(255-c)*p); return `rgb(${m(r)},${m(g)},${m(b)})`; };
    function applyBackground(bg){
        root.style.setProperty('--surface-0', bg);
        root.style.setProperty('--surface-1', mixWhite(bg,0.05));
        root.style.setProperty('--surface-2', mixWhite(bg,0.095));
        root.style.setProperty('--surface-3', mixWhite(bg,0.15));
        root.style.setProperty('--surface-4', mixWhite(bg,0.22));
        root.style.setProperty('--surface-5', mixWhite(bg,0.30));
        root.style.setProperty('--line-1', mixWhite(bg,0.085));
        root.style.setProperty('--line-2', mixWhite(bg,0.14));
        root.style.setProperty('--line-3', mixWhite(bg,0.24));
        root.style.setProperty('--line-4', mixWhite(bg,0.33));
    }
    function apply(){
        applyBackground(state.bg);
        const [r,g,b]=hexToRgb(state.brand);
        root.style.setProperty('--brand-500', state.brand);
        root.style.setProperty('--brand-400', shade(state.brand,0.18));
        root.style.setProperty('--brand-300', shade(state.brand,0.36));
        root.style.setProperty('--brand-600', shade(state.brand,-0.10));
        root.style.setProperty('--brand-700', shade(state.brand,-0.20));
        ['08','12','18','25','40','60'].forEach(a => root.style.setProperty(`--brand-a${a}`, `rgba(${r},${g},${b},.${a})`));
        root.style.setProperty('--ui-opacity', state.opacity);
        root.style.setProperty('--ui-scale', state.scale);
    }
    function loadSaved(){ try { const raw = localStorage.getItem(KEY); if (raw){ const o = JSON.parse(raw)||{}; saved = { opacity: o.opacity != null ? o.opacity : 1.0, scale: o.scale != null ? o.scale : 1.0, modes: o.modes || {} }; } } catch {} }
    function persist(){ try { localStorage.setItem(KEY, JSON.stringify(saved)); } catch {} }
    // Apply the job's theme (police vs ems). Per-mode user overrides win;
    // otherwise the Config palette for that mode is the default.
    function applyServerTheme(theme, mode){
        curMode = mode || 'police';
        const ov = saved.modes[curMode] || {};
        state.brand   = ov.brand || (theme && theme.brand) || defaults.brand;
        state.bg      = ov.bg    || (theme && theme.bg)    || defaults.bg;
        state.opacity = saved.opacity != null ? saved.opacity : 1.0;
        state.scale   = saved.scale   != null ? saved.scale   : 1.0;
        apply();
    }
    function set(k,v){
        state[k]=v;
        if (k==='brand' || k==='bg'){ if (!saved.modes[curMode]) saved.modes[curMode] = {}; saved.modes[curMode][k]=v; }
        else if (k==='opacity' || k==='scale'){ saved[k]=v; }
        apply(); persist();
    }
    loadSaved(); apply();
    return { apply, applyServerTheme, set, get state(){ return state; } };
})();

/* ============================================================
   NOTIFY
   ============================================================ */
const Notify = (() => {
    const root = $('#notify-container');
    return ({ title='MDT', message='', type='info', duration=5000 }) => {
        if (!root || Prefs.get('notifications') === false) return;   // control-center mute
        const icon = type==='error'?'fa-circle-xmark':type==='success'?'fa-circle-check':type==='warning'?'fa-triangle-exclamation':'fa-circle-info';
        const el = document.createElement('div');
        el.className = `notify-card ${type}`;
        el.innerHTML = `
            <div class="notify-header"><i class="notify-icon fa-solid ${icon}"></i><span class="notify-title">${h(title)}</span></div>
            <div class="notify-body">${h(message)}</div>
            <div class="notify-progress"><div class="notify-progress-bar"></div></div>`;
        root.appendChild(el);
        el.querySelector('.notify-progress-bar').animate([{transform:'scaleX(1)'},{transform:'scaleX(0)'}],{duration,easing:'linear'});
        setTimeout(() => el.remove(), duration);
    };
})();

/* ============================================================
   MODAL
   ============================================================ */
const Modal = (() => {
    const root = $('#modal-root');
    function open({ title, body, footer, wide }){
        root.innerHTML = `<div class="modal-overlay"><div class="modal ${wide?'modal-wide':''}">
            <div class="modal-head"><h2>${h(title||'')}</h2><button class="icon-btn" data-mclose><i class="fa-solid fa-xmark"></i></button></div>
            <div class="modal-body">${body||''}</div>${footer?`<div class="modal-foot">${footer}</div>`:''}</div></div>`;
        root.querySelector('[data-mclose]').onclick = close;
        root.querySelector('.modal-overlay').addEventListener('mousedown', e => { if (e.target.classList.contains('modal-overlay')) close(); });
        return root.querySelector('.modal');
    }
    function close(){ root.innerHTML = ''; }
    function confirm(msg, onYes){
        open({ title:'Confirm', body:`<p style="font-size:13.5px;color:var(--text-2);line-height:1.6">${h(msg)}</p>`,
            footer:`<button class="btn btn-ghost" data-no>${L('ui_cancel','Cancel')}</button><button class="btn btn-danger" data-yes>${L('ui_confirm','Confirm')}</button>` });
        root.querySelector('[data-no]').onclick = close;
        root.querySelector('[data-yes]').onclick = () => { close(); onYes && onYes(); };
    }
    return { open, close, confirm };
})();

/* ============================================================
   DISPATCH BANNER - on-screen incoming-call alert (in the tablet)
   ============================================================ */
const DispatchBanner = (() => {
    const el = $('#dispatch-banner'); let timer, current;
    function hide(){ if (el) el.hidden = true; clearTimeout(timer); }
    function show(c){
        if (!el || !c) return; current = c;
        const ct = (STATE.cfg.callTypes || []).find(t => t.id === c.type) || {};
        el.classList.toggle('crit', c.priority === 'critical');
        const ic = el.querySelector('.db-ic');
        ic.style.setProperty('--_c', c.color || prioColor(c.priority));
        ic.innerHTML = `<i class="fa-solid ${ct.icon || 'fa-tower-broadcast'}"></i>`;
        $('#db-title').textContent = `${c.label || c.type || 'Call'}${c.code ? ' · ' + c.code : ''}`;
        $('#db-sub').textContent = `${c.location || 'Unknown'}${c.caller ? ' · ' + c.caller : ''}`;
        $('#db-respond').hidden = !c.coords;
        el.hidden = false;
        clearTimeout(timer); timer = setTimeout(hide, 9000);
    }
    if (el) {
        $('#db-dismiss').onclick = hide;
        $('#db-respond').onclick = () => { if (current) call('respondCall', current.id); hide(); };
    }
    return { show, hide };
})();

/* ============================================================
   DEVICE controller - boot → lock → OS
   ============================================================ */
const Device = (() => {
    const device = $('#device'), boot = $('#boot'), lock = $('#lock'), os = $('#os');
    function show(){ device.hidden = false; }
    function hide(){ device.hidden = true; }

    function runBoot(){
        boot.hidden = false; lock.hidden = true; os.hidden = true;
        $('#boot-title').textContent = L('boot_title','APEX MDT');
        $('#boot-sub').textContent   = L('boot_sub','Mobile Data Terminal');
        const steps = [ L('boot_loading','Establishing secure connection…'), 'Loading department database…', 'Syncing dispatch…', 'Ready.' ];
        let p = 0, si = 0;
        const fill = $('#boot-fill'), status = $('#boot-status');
        const t = setInterval(() => {
            p += Math.random()*16 + 8; if (p>100) p=100;
            fill.style.width = p + '%';
            const ns = Math.min(steps.length-1, Math.floor(p/26)); if (ns!==si){ si=ns; status.textContent = steps[si]; }
            if (p>=100){ clearInterval(t); setTimeout(showLock, 350); }
        }, 160);
    }

    function showLock(){
        if (!feat('enableLockScreen')) { enterOS(); return; }
        boot.hidden = true; lock.hidden = false;
        const o = STATE.officer;
        $('#lock-initials').textContent = initials(o.name);
        const ld = $('#lock-dept'); if (ld) ld.textContent = o.jobShort || (STATE.mode === 'ems' ? 'EMS' : 'MDT');
        $('#lock-btn-tx').textContent = L('lock_swipe','Swipe up to unlock');
        // department wallpaper behind the lock (same image as the OS background)
        const wp = STATE.cfg.wallpaper || {}, bg = $('#lock-bg');
        const wurl = (wp.enable !== false) ? (wp[STATE.mode] || '') : '';
        if (bg){ if (wurl){ bg.style.backgroundImage = `url("${wurl}")`; bg.classList.add('on'); } else bg.classList.remove('on'); }
        // player photo in the circle (only the photo - hide initials when it loads)
        const img = $('#lock-avatar-img'), ini = $('#lock-initials');
        const lurl = avatarUrl(o.avatar);
        img.onload  = () => { img.hidden = false; if (ini) ini.style.opacity = 0; };
        img.onerror = () => { img.hidden = true; if (ini) ini.style.opacity = 1; };
        img.src = lurl;
        // Lock-screen notifications (real-tablet style).
        const notes = STATE.notifications || [];
        const ln = $('#lock-notes');
        if (ln) ln.innerHTML = notes.slice(0, 1).map(n =>
            `<div class="lock-note"><div class="ln-ic" style="--_c:${n.color || 'var(--brand-500)'}"><i class="fa-solid ${n.icon || 'fa-bell'}"></i></div>
                <div class="ln-tx"><div class="ln-t"><b>${h(n.title || 'Notification')}</b><span>${h(n.time || 'now')}</span></div><div class="ln-b">${h(n.body || '')}</div></div></div>`).join('');
        updateClock();
    }
    // iOS-style unlock: slide the lock screen up, then reveal the OS.
    let unlocking = false;
    function unlock(){
        if (unlocking) return; unlocking = true;
        lock.classList.add('exit');
        setTimeout(() => { lock.classList.remove('exit'); enterOS(); unlocking = false; }, 480);
    }
    $('#lock-btn').addEventListener('click', unlock);
    $('#lock-home').addEventListener('click', unlock);
    lock.querySelector('.lock-unlock-hint').addEventListener('click', unlock);
    // swipe / scroll up to unlock
    lock.addEventListener('wheel', e => { if (e.deltaY < -8) unlock(); });
    let touchY = null;
    lock.addEventListener('mousedown', e => { touchY = e.clientY; });
    lock.addEventListener('mouseup', e => { if (touchY != null && touchY - e.clientY > 40) unlock(); touchY = null; });

    // ── First-run account setup wizard ──
    const setupEl = $('#setup');
    let sStep = 0; const sData = {};
    function showSetup(){
        boot.hidden = true; lock.hidden = true; os.hidden = true;
        setupEl.hidden = false; sStep = 0; renderSetup();
    }
    function renderSetup(){
        const o = STATE.officer, ems = STATE.mode === 'ems';
        const divisions = o.divisionList || [];
        const bloods = o.bloodTypes || [];
        const dots = [0,1,2,3].map(i => `<span class="su-dot ${i===sStep?'on':''} ${i<sStep?'done':''}"></span>`).join('');
        let body = '';
        if (sStep === 0){
            body = `<div class="su-mark"><i class="fa-solid ${ems?'fa-truck-medical':'fa-shield-halved'}"></i></div>
                <h2>${ems?h(L('setup_title_ems','Medical Terminal Setup')):h(L('setup_title_mdt','MDT Account Setup'))}</h2>
                <p class="su-sub">${h(L('setup_welcome','Welcome'))}, <b>${h(o.name||'Officer')}</b>. ${h(L('setup_welcome_lead',"Let's set up your"))} ${ems?h(L('setup_welcome_medical','medical')):h(L('setup_welcome_officer','officer'))} ${h(L('setup_welcome_tail','profile - it only takes a moment.'))}</p>
                <button class="btn btn-primary btn-block su-next"><i class="fa-solid fa-arrow-right"></i> ${h(L('setup_begin','Begin Setup'))}</button>`;
        } else if (sStep === 1){
            body = `<h2>${h(L('setup_photo_title','Profile Photo'))}</h2><p class="su-sub">${h(L('setup_photo_sub','Take a photo for your ID. Look at the camera.'))}</p>
                <div class="su-photo" id="setup-photo"><span id="setup-photo-ini">${initials(o.name)}</span><img id="setup-photo-img" alt="" hidden><span class="su-photo-ring"></span></div>
                <div class="su-row"><button class="btn btn-ghost" id="su-take"><i class="fa-solid fa-camera"></i> ${o.avatar?h(L('setup_retake','Retake')):h(L('setup_take_photo','Take Photo'))}</button>
                <button class="btn btn-primary su-next" ${o.avatar?'':'disabled'} id="su-photo-next">${h(L('setup_continue','Continue'))} <i class="fa-solid fa-arrow-right"></i></button></div>`;
        } else if (sStep === 2){
            body = `<h2>${h(L('setup_fp_title','Fingerprint'))}</h2><p class="su-sub">${h(L('setup_fp_sub','Place your finger on the scanner to register your biometric ID.'))}</p>
                <div class="su-fp ${sData.fp?'done':''}" id="su-fp"><i class="fa-solid fa-fingerprint"></i><span class="su-fp-scan"></span></div>
                <div class="su-fp-status" id="su-fp-status">${sData.fp?'<span class="ok-text"><i class="fa-solid fa-circle-check"></i> '+h(L('setup_fp_registered','Registered'))+'</span>':h(L('setup_fp_tap','Tap the scanner'))}</div>
                <button class="btn btn-primary btn-block su-next" id="su-fp-next" ${sData.fp?'':'disabled'}>${h(L('setup_continue','Continue'))} <i class="fa-solid fa-arrow-right"></i></button>`;
        } else {
            body = `<h2>${h(L('setup_details_title','Your Details'))}</h2><p class="su-sub">${h(L('setup_details_sub','Confirm your unit details.'))}</p>
                <div class="field"><label>${h(L('setup_callsign','Callsign'))}</label><input id="su-cs" value="${h(o.callsign||'')}"></div>
                <div class="field"><label>${h(L('setup_division','Division'))}</label><select id="su-div"><option value="">${h(L('setup_opt_none','- None -'))}</option>${divisions.map(d=>`<option ${o.division===d?'selected':''}>${h(d)}</option>`).join('')}</select></div>
                ${ems?`<div class="field"><label>${h(L('setup_blood','Blood Type'))}</label><select id="su-blood"><option value="">${h(L('setup_opt_unknown','- Unknown -'))}</option>${bloods.map(b=>`<option ${o.blood===b?'selected':''}>${h(b)}</option>`).join('')}</select></div>`:''}
                <div class="field"><label>${h(L('setup_phone','Phone (optional)'))}</label><input id="su-phone" value="${h(o.phone||'')}"></div>
                <button class="btn btn-primary btn-block" id="su-finish"><i class="fa-solid fa-check"></i> ${h(L('setup_finish','Finish Setup'))}</button>`;
        }
        setupEl.innerHTML = `<div class="lock-bg ${'' }" id="setup-bg"></div><div class="lock-scrim"></div>
            <div class="su-card"><div class="su-dots">${dots}</div><div class="su-body">${body}</div></div>`;
        // dept wallpaper behind the setup too
        const wp = STATE.cfg.wallpaper||{}, wurl=(wp.enable!==false)?(wp[STATE.mode]||''):''; const sbg=$('#setup-bg');
        if (sbg && wurl){ sbg.style.backgroundImage=`url("${wurl}")`; sbg.classList.add('on'); }
        if (sStep === 1) applyAvatar('#setup-photo-img', '#setup-photo-ini', o.avatar);
        wireSetup();
    }
    function wireSetup(){
        const next = () => { sStep++; renderSetup(); };
        setupEl.querySelectorAll('.su-next').forEach(b => b.onclick = next);
        const take = $('#su-take');
        // Capture is the ONLY way to satisfy the mandatory photo: setAvatarEverywhere
        // (real photo) re-enables Continue; 'photoCancelled' just frees the button.
        if (take) take.onclick = () => { requestPhoto(); take.disabled = true; take.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> '+h(L('setup_capturing','Capturing…')); };
        const fp = $('#su-fp');
        if (fp) fp.onclick = () => { if (sData.fp) return; fp.classList.add('scanning'); $('#su-fp-status').textContent=L('setup_scanning','Scanning…');
            setTimeout(() => { sData.fp = true; renderSetup(); }, 1500); };
        const finish = $('#su-finish');
        if (finish) finish.onclick = async () => {
            finish.disabled = true; finish.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> '+h(L('setup_finishing','Finishing…'));
            const payload = { callsign: $('#su-cs')?.value, division: $('#su-div')?.value, blood: $('#su-blood')?.value, phone: $('#su-phone')?.value };
            const [ok, saved] = await call('completeSetup', payload);
            if (ok && saved){ Object.assign(STATE.officer, saved); }
            STATE.officer.setupDone = true;
            setupEl.hidden = true; enterOS();
        };
    }
    function enterOS(){
        boot.hidden = true; lock.hidden = true; setupEl.hidden = true; os.hidden = false;
        Rail.build(); applyOfficerChrome();
        App.open(STATE.cfg.features?.enableDashboard !== false ? 'dashboard' : Rail.first());
    }
    function start(){
        show();
        if (!STATE.officer.setupDone) { showSetup(); return; }   // first-run account setup
        if (feat('enableBootScreen')) runBoot(); else { if (feat('enableLockScreen')) showLock(); else enterOS(); }
    }
    function lockNow(){ const cc=$('#control-center'); if(cc) cc.hidden=true; os.hidden=true; showLock(); }
    // Re-render the OS chrome in place after a live job switch (keeps the tablet
    // open; rebuilds the rail/header/theme and lands on the dashboard).
    function refresh(){
        Rail.build(); applyOfficerChrome();
        if (!STATE.officer.setupDone) return;   // still in setup → just refresh chrome
        const cc=$('#control-center'); if(cc) cc.hidden=true;
        boot.hidden = true; lock.hidden = true; setupEl.hidden = true; os.hidden = false;
        App.open(STATE.cfg.features?.enableDashboard !== false ? 'dashboard' : Rail.first());
    }
    return { show, hide, start, lock: lockNow, refresh };
})();

/* ── Photo capture: never leave the setup wizard on a dead spinner ──
   Once the booth is OPEN the client owns the deadline (its control loop
   always answers, and Config.photo.timeoutMs bounds the capture), so this
   watchdog deliberately covers only the gap before the booth opens: the
   click that the client never acknowledged at all. Anything longer would
   risk firing while the player is still framing their shot and dropping
   the tablet on top of a live camera. */
let _camWatchdog = null;
function restoreFromCapture(){
    const d = $('#device');     if (d) d.style.visibility = 'visible';
    const c = $('#camera-ui');  if (c) { c.hidden = true; c.style.visibility = 'visible'; }
    const st = $('#su-take');
    if (st) { st.disabled = false; st.innerHTML = `<i class="fa-solid fa-camera"></i> ${STATE.officer.avatar ? L('setup_retake','Retake') : L('setup_take_photo','Take Photo')}`; }
}
function clearCamWatchdog(){ if (_camWatchdog){ clearTimeout(_camWatchdog); _camWatchdog = null; } }
// Ask the client for a photo. Every button goes through here so the watchdog
// can never be forgotten at a call site.
function requestPhoto(opts){
    clearCamWatchdog();
    _camWatchdog = setTimeout(() => { _camWatchdog = null; restoreFromCapture(); }, 6000);
    post('capture_photo', opts || {});
}

// Show ONLY the photo in an avatar slot: when the image loads, hide the
// initials fallback; on error/none, keep initials. object-fit cover never
// distorts the headshot.
function applyAvatar(imgSel, iniSel, url){
    const img = $(imgSel), ini = $(iniSel);
    if (!img) return;
    url = avatarUrl(url);   // captured photo, else img/perfil.png
    img.onload  = () => { img.hidden = false; if (ini) ini.style.opacity = 0; };
    img.onerror = () => { img.hidden = true;  if (ini) ini.style.opacity = 1; };
    img.src = url;
}
// Push a freshly-captured mugshot to every avatar slot in the device.
function setAvatarEverywhere(url){
    STATE.officer.avatar = url;
    applyAvatar('#ro-avatar-img', '#ro-initials', url);       // sidebar
    applyAvatar('#lock-avatar-img', '#lock-initials', url);   // lock screen
    applyAvatar('#dh-av-img', '#dh-av-ini', url);             // dashboard hero
    applyAvatar('#setup-photo-img', '#setup-photo-ini', url); // setup wizard
    applyAvatar('#ro2-img', '#ro2-ini', url);                 // My Profile ID card
    // setup wizard: a real photo unlocks "Continue"
    const sn = $('#su-photo-next'); if (sn) sn.disabled = false;
    const st = $('#su-take'); if (st) { st.disabled = false; st.innerHTML = '<i class="fa-solid fa-camera"></i> Retake'; }
    // live-refresh apps that render the officer photo inline
    if (STATE.activeApp === 'comms'  && Renderers.comms)  Renderers.comms();
    if (STATE.activeApp === 'roster' && Renderers.roster) Renderers.roster();
}
// Downscale any image (data URI or URL) to a centered `size`² JPEG and return
// a small data URI via cb (null if blocked). Keeps the saved/persisted photo
// tiny so it fits a network event and the DB.
function downscaleImage(src, size, cb){
    const img = new Image();
    if (!String(src).startsWith('data:')) img.crossOrigin = 'anonymous';
    img.onload = () => { try {
        const s = size || 256, c = document.createElement('canvas'); c.width = s; c.height = s;
        const min = Math.min(img.naturalWidth, img.naturalHeight) || s;
        const sx = (img.naturalWidth - min) / 2, sy = (img.naturalHeight - min) / 2;
        c.getContext('2d').drawImage(img, sx, sy, min, min, 0, 0, s, s);
        cb(c.toDataURL('image/jpeg', 0.82));
    } catch { cb(null); } };
    img.onerror = () => cb(null);
    img.src = src;
}
// Full-screen capture → downscale → show everywhere + persist (small payload).
function processAndSavePhoto(dataUri){
    if (!dataUri) return;
    downscaleImage(dataUri, 256, (small) => {
        const finalUrl = small || dataUri;
        setAvatarEverywhere(finalUrl);
        post('save_photo', { data: finalUrl });
    });
}
// Persist an already-displayed avatar (headshot fallback), best-effort.
function persistAvatar(url){
    if (!url) return;
    downscaleImage(url, 256, (small) => { if (small) post('save_photo', { data: small }); });
}
// Captured photo → downscale → send into the current chat channel.
function sendChatPhoto(dataUri){
    if (!dataUri) return;
    downscaleImage(dataUri, 360, async (small) => {
        if (!small) return;
        await call('sendMessage', commsChannel, '', small);
        if (STATE.activeApp === 'comms' && Renderers.comms) Renderers.comms();
        else Notify({ message: 'Photo sent to chat.', type: 'success' });
    });
}
// Captured mugshot → downscale → store under the citizen/patient identifier → refresh.
function saveMugshot(storeId, dataUri){
    if (!storeId || !dataUri) return;
    downscaleImage(dataUri, 256, (small) => {
        const url = small || dataUri;
        post('save_mugshot', { id: storeId, data: url });
        Notify({ message: 'Mugshot saved.', type: 'success' });
        // live-refresh the open record (profiles + patients share the #p-list detail)
        setTimeout(() => _reopenCitizen(storeId), 250);
    });
}
function applyOfficerChrome(){
    const o = STATE.officer, t = modeTheme();
    // mark the root with the active mode so CSS can apply job-specific styling
    document.documentElement.setAttribute('data-mode', STATE.mode);
    document.documentElement.style.setProperty('--dept', o.deptColor || t.brand || '#1F5EFF');
    $('#sb-dept').textContent = o.jobShort || 'DEPT';
    $('#sb-callsign').textContent = o.callsign || '-';
    // sidebar brand + officer card (per-mode identity from Config.theme)
    $('#rail-brand-name').textContent = t.name || (STATE.mode === 'ems' ? 'APEX EMS' : 'APEX MDT');
    $('#rail-brand-dept').textContent = o.jobShort || t.dept || (STATE.mode === 'ems' ? 'MEDICAL' : 'TACTICAL');
    $('#roc-name').textContent = o.name || 'Officer';
    $('#roc-rank').textContent = [o.rank, o.callsign].filter(Boolean).join(' · ') || '-';
    $('#ro-initials').textContent = initials(o.name);
    applyAvatar('#ro-avatar-img', '#ro-initials', o.avatar);
    setStatusChip(o.status);
    $('#duty-btn').classList.toggle('on', STATE.duty);
    $('#rail-mark').innerHTML = `<i class="fa-solid ${t.markIcon || (STATE.mode==='ems'?'fa-truck-medical':'fa-shield-halved')}"></i>`;
    // Per-mode wallpaper (faint background image behind the UI).
    const wp = STATE.cfg.wallpaper || {};
    const ow = $('#os-wall');
    if (ow){
        const url = (wp.enable !== false) ? (wp[STATE.mode] || '') : '';
        document.documentElement.style.setProperty('--wall-op', wp.opacity != null ? wp.opacity : 0.16);
        if (url){ ow.style.backgroundImage = `url("${url}")`; ow.classList.add('on'); }
        else { ow.classList.remove('on'); ow.style.backgroundImage = ''; }
    }
    // Feature-gate the rail footer buttons.
    $('#duty-btn').hidden     = !feat('enableDutyToggle');
    $('#panic-btn').hidden    = !feat('enablePanicButton');
    $('#settings-btn').hidden = !feat('enableSettings');
    $('#statusbar').hidden    = !feat('enableStatusBar');
}
// Status picker (click the status chip to change your 10-code).
$('#sb-status-chip').addEventListener('click', () => {
    const list = STATE.cfg.statuses || [];
    Modal.open({ title:'Set Status', body:`<div class="chips">${list.map(s=>`<button class="chip" data-st="${h(s.code)}" style="--_c:${s.color}"><span class="dot" style="--_c:${s.color}"></span>${h(s.code)} · ${h(s.label)}</button>`).join('')}</div>` });
    $$('[data-st]').forEach(b => b.onclick = async () => { const [ok, st] = await call('setStatus', b.dataset.st); if (ok && st){ STATE.officer.status = st.code; setStatusChip(st.code); } Modal.close(); });
});
function setStatusChip(code){
    const list = STATE.cfg.statuses || [];
    const st = list.find(s => s.code === code) || list[0] || {};
    $('#sb-status').textContent = st.code || code || '10-8';
    document.querySelector('#sb-status-chip').style.setProperty('--_sc', st.color || 'var(--green)');
}

/* ============================================================
   STATUS BAR clock + battery + inactivity
   ============================================================ */
function updateClock(){
    const d = new Date();
    const use24 = STATE.cfg.use24h;
    let hh = d.getHours(), mm = String(d.getMinutes()).padStart(2,'0'), ap='';
    if (!use24){ ap = hh>=12?' PM':' AM'; hh = hh%12 || 12; }
    const t = `${String(hh).padStart(2,'0')}:${mm}${ap}`;
    const dateStr = d.toLocaleDateString(undefined, { weekday:'long', month:'long', day:'numeric' });
    const sbClock = $('#sb-clock'); if (sbClock) sbClock.textContent = t;
    const lc = $('#lock-clock'); if (lc) lc.textContent = use24?`${String(d.getHours()).padStart(2,'0')}:${mm}`:`${hh}:${mm}${ap}`;
    const ld = $('#lock-date'); if (ld) ld.textContent = dateStr;
    const dc = $('#dash-clock-t'); if (dc) dc.textContent = t;
    const dd = $('#dash-clock-d'); if (dd) dd.textContent = dateStr;
}
setInterval(() => { if (!STATE.open) return; updateClock(); }, 1000);
setInterval(() => {
    if (!STATE.open || !feat('enableBattery')) return;
    STATE.batt = Math.max(2, STATE.batt - 0.05);
    const pct = Math.round(STATE.batt);
    const el = $('#sb-batt-pct'); if (el) el.textContent = pct + '%';
    const ic = $('#sb-batt i'); if (ic) ic.className = `fa-solid ${pct>80?'fa-battery-full':pct>55?'fa-battery-three-quarters':pct>30?'fa-battery-half':pct>12?'fa-battery-quarter':'fa-battery-empty'}`;
}, 6000);
setInterval(() => {
    if (!STATE.open || !feat('enableInactivityLogout')) return;
    const to = (STATE.cfg.inactivityTimeout || 180) * 1000;
    if (Date.now() - STATE.lastInput > to) closeDevice();
}, 5000);
document.addEventListener('mousemove', () => STATE.lastInput = Date.now());
document.addEventListener('keydown', () => STATE.lastInput = Date.now());

/* ============================================================
   APP REGISTRY  (mode-aware + feature-gated)
   ============================================================ */
const APPS = [
    { id:'dashboard', group:'ops',     icon:'fa-table-columns',     label:'app_dashboard', mode:'both',   feature:'enableDashboard' },
    { id:'dispatch',  group:'ops',     icon:'fa-tower-broadcast',   label:'app_dispatch',  mode:'both',   feature:{police:'enableDispatch', ems:'enableEmsDispatch'} },
    { id:'map',       group:'ops',     icon:'fa-map-location-dot',  label:'app_map',       mode:'both',   feature:'enableLiveMap' },
    { id:'units',     group:'ops',     icon:'fa-users-viewfinder',  label:'app_units',     mode:'both',   feature:'enableDispatch', alt:'Units' },
    { id:'profiles',  group:'records', icon:'fa-id-card',           label:'app_profiles',  mode:'police', feature:'enablePoliceProfiles' },
    { id:'vehicles',  group:'records', icon:'fa-car',               label:'app_vehicles',  mode:'police', feature:'enablePoliceVehicles' },
    { id:'reports',   group:'records', icon:'fa-file-lines',        label:'app_reports',   mode:'both',   feature:{police:'enablePoliceReports', ems:'enableEmsReports'} },
    { id:'warrants',  group:'enforce', icon:'fa-gavel',             label:'app_warrants',  mode:'police', feature:'enablePoliceWarrants' },
    { id:'bolos',     group:'enforce', icon:'fa-bullhorn',          label:'app_bolos',     mode:'police', feature:'enablePoliceBolos' },
    { id:'charges',   group:'enforce', icon:'fa-scale-balanced',    label:'app_charges',   mode:'police', feature:'enablePoliceCharges' },
    { id:'citations', group:'enforce', icon:'fa-receipt',           label:'app_citations', mode:'police', feature:'enablePoliceCitations' },
    { id:'booking',   group:'enforce', icon:'fa-fingerprint',       label:'app_booking',   mode:'police', feature:'enablePoliceBooking' },
    { id:'evidence',  group:'invest',  icon:'fa-box-archive',       label:'app_evidence',  mode:'police', feature:'enablePoliceEvidence' },
    { id:'court',     group:'invest',  icon:'fa-landmark',          label:'app_court',     mode:'police', feature:'enablePoliceCourt' },
    { id:'patients',  group:'clinical',icon:'fa-bed-pulse',         label:'app_patients',  mode:'ems',    feature:'enableEmsPatients' },
    { id:'triage',    group:'clinical',icon:'fa-heart-pulse',       label:'app_triage',    mode:'ems',    feature:'enableEmsTriage' },
    { id:'beds',      group:'clinical',icon:'fa-bed',               label:'app_beds',      mode:'ems',    feature:'enableEmsBeds' },
    { id:'surgery',   group:'clinical',icon:'fa-user-doctor',       label:'app_surgery',   mode:'ems',    feature:'enableEmsSurgery' },
    { id:'pharmacy',  group:'admin',   icon:'fa-pills',             label:'app_pharmacy',  mode:'ems',    feature:'enableEmsPharmacy' },
    { id:'billing',   group:'admin',   icon:'fa-file-invoice-dollar',label:'app_billing',  mode:'ems',    feature:'enableEmsBilling' },
    { id:'morgue',    group:'records', icon:'fa-skull',             label:'app_deaths',    mode:'ems',    feature:'enableEmsDeaths' },
    { id:'bloodbank', group:'clinical',icon:'fa-droplet',           label:'app_bloodbank', mode:'ems',    feature:'enableEmsBloodBank', alt:'Blood Bank' },
    { id:'telemed',   group:'clinical',icon:'fa-video',             label:'app_telemed',   mode:'ems',    feature:'enableEmsTelemedicine', alt:'Telemedicine' },
    { id:'cctv',      group:'surv',    icon:'fa-video',             label:'app_cctv',      mode:'both',   feature:'enableCctv', alt:'CCTV' },
    { id:'bodycam',   group:'surv',    icon:'fa-camera',            label:'app_bodycam',   mode:'police', feature:'enableBodycamApp', alt:'Bodycam' },
    { id:'profile',   group:'dept',    icon:'fa-id-badge',          label:'app_profile',   mode:'both',   alt:'My Profile' },
    { id:'roster',    group:'dept',    icon:'fa-users',             label:'app_roster',    mode:'both',   feature:'enableRoster' },
    { id:'comms',     group:'dept',    icon:'fa-comments',          label:'app_comms',     mode:'both',   feature:'enableComms' },
    { id:'stats',     group:'dept',    icon:'fa-chart-column',      label:'app_stats',     mode:'both',   feature:'enableStats' },
    { id:'audit',     group:'dept',    icon:'fa-clipboard-list',    label:'app_audit',     mode:'both',   feature:'enableAuditLog' },
];
// Section order + titles per mode (only groups with ≥1 enabled app render).
const GROUPS = {
    police: [ {id:'ops',label:'Operations'},{id:'records',label:'Records'},{id:'enforce',label:'Enforcement'},{id:'invest',label:'Investigation'},{id:'surv',label:'Surveillance'},{id:'dept',label:'Department'} ],
    ems:    [ {id:'ops',label:'Operations'},{id:'clinical',label:'Clinical'},{id:'admin',label:'Pharmacy & Billing'},{id:'records',label:'Records'},{id:'surv',label:'Surveillance'},{id:'dept',label:'Department'} ],
};
function appLabel(a){ return L(a.label, a.alt || a.id); }
function appEnabled(a){
    if (a.mode !== 'both' && a.mode !== STATE.mode) return false;
    const f = a.feature;
    const key = (typeof f === 'object') ? f[STATE.mode] : f;
    return !key || STATE.cfg.features?.[key] !== false;
}

/* ============================================================
   RAIL
   ============================================================ */
const Rail = (() => {
    const nav = $('#rail-nav');
    const FAV_KEY = 'apex_mdt_favs_v1';
    const loadFavs = () => { try { return JSON.parse(localStorage.getItem(FAV_KEY)) || []; } catch { return []; } };
    const saveFavs = () => { try { localStorage.setItem(FAV_KEY, JSON.stringify(STATE.favs)); } catch {} };
    function toggleFav(id){ const i = STATE.favs.indexOf(id); if (i >= 0) STATE.favs.splice(i,1); else STATE.favs.push(id); saveFavs(); build(); setActive(STATE.activeApp); }
    function btnHTML(a){
        const faved = STATE.favs.includes(a.id);
        return `<button class="rail-btn" data-app="${a.id}" title="${h(appLabel(a))}">
            <span class="rb-ic"><i class="fa-solid ${a.icon}"></i></span>
            <span class="rb-label">${h(appLabel(a))}</span>
            <span class="rail-badge" data-badge="${a.id}" hidden></span>
            <span class="rb-star ${faved?'faved':''}" data-fav="${a.id}" title="Favourite"><i class="fa-${faved?'solid':'regular'} fa-star"></i></span>
        </button>`;
    }
    function build(){
        STATE.favs = loadFavs();
        let html = '';
        // Favourites - only shown if there are any.
        const favApps = STATE.favs.map(id => APPS.find(a => a.id === id)).filter(a => a && appEnabled(a));
        if (favApps.length){
            html += `<div class="rail-group-h"><i class="fa-solid fa-star" style="font-size:8px;margin-right:6px;color:var(--yellow)"></i>${h(L('ui_favourites','Favourites'))}</div>`;
            html += favApps.map(btnHTML).join('');
        }
        const groups = GROUPS[STATE.mode] || GROUPS.police;
        groups.forEach(g => {
            const apps = APPS.filter(a => appEnabled(a) && (a.group || 'dept') === g.id);
            if (!apps.length) return;
            html += `<div class="rail-group-h">${h(L('grp_'+g.id, g.label))}</div>`;
            html += apps.map(btnHTML).join('');
        });
        nav.innerHTML = html;
        $$('.rail-btn', nav).forEach(b => b.onclick = () => App.open(b.dataset.app));
        $$('.rb-star', nav).forEach(s => s.onclick = (e) => { e.stopPropagation(); toggleFav(s.dataset.fav); });
    }
    function first(){
        const groups = GROUPS[STATE.mode] || GROUPS.police;
        for (const g of groups){ const a = APPS.find(x => appEnabled(x) && (x.group||'dept')===g.id); if (a) return a.id; }
        const any = APPS.filter(appEnabled)[0]; return any ? any.id : 'dashboard';
    }
    function setActive(id){ $$('.rail-btn', nav).forEach(b => b.classList.toggle('active', b.dataset.app === id)); }
    function badge(id, n){ const el = nav.querySelector(`[data-badge="${id}"]`); if (!el) return; if (n>0){ el.textContent = n>99?'99':n; el.hidden=false; } else el.hidden = true; }
    return { build, first, setActive, badge };
})();

// ── Control center ──
(() => {
    const cc = $('#control-center'), cluster = $('#sb-cluster');
    if (!cc || !cluster) return;
    const sync = () => {
        $('#cc-notif').querySelector('.switch').classList.toggle('on', Prefs.get('notifications') !== false);
        $('#cc-dispatch').querySelector('.switch').classList.toggle('on', Prefs.get('dispatchAlerts') !== false);
        $('#cc-sounds').querySelector('.switch').classList.toggle('on', Prefs.get('sounds') !== false);
        $('#cc-bright').value = Prefs.get('brightness') || 1;
        $('#cc-duty').classList.toggle('on', STATE.duty);
    };
    const toggle = () => { cc.hidden = !cc.hidden; if (!cc.hidden) sync(); };
    cluster.onclick = (e) => { e.stopPropagation(); toggle(); };
    document.addEventListener('click', (e) => { if (!cc.hidden && !cc.contains(e.target) && !cluster.contains(e.target)) cc.hidden = true; });
    $('#cc-bright').addEventListener('input', e => Prefs.set('brightness', parseFloat(e.target.value)));
    $('#cc-notif').onclick = () => { Prefs.set('notifications', Prefs.get('notifications') === false); sync(); };
    $('#cc-dispatch').onclick = () => { const on = Prefs.get('dispatchAlerts') === false; Prefs.set('dispatchAlerts', on); post('set_dispatch_alerts', { on }); sync(); };
    $('#cc-sounds').onclick = () => { Prefs.set('sounds', Prefs.get('sounds') === false); sync(); };
    $('#cc-duty').onclick = () => { post('toggle_duty'); };
    $('#cc-lock').onclick = () => { cc.hidden = true; Device.lock(); };
    $('#cc-settings').onclick = () => { cc.hidden = true; App.open('settings_overlay'); };
})();

$('#duty-btn').onclick = () => post('toggle_duty');
$('#panic-btn').onclick = () => Modal.confirm('Broadcast a PANIC alert with your location to all on-duty units?', () => post('panic'));
$('#power-btn').onclick = () => closeDevice();
$('#settings-btn').onclick = () => App.open('settings_overlay');
$('#rail-officer').onclick = () => App.open('roster');

/* ============================================================
   APP CONTROLLER
   ============================================================ */
const App = (() => {
    const view = $('#app-view'), title = $('#app-title'), eyebrow = $('#app-eyebrow'), tools = $('#app-tools');
    let current = null;
    function setHeader(a){ title.textContent = appLabel(a); eyebrow.textContent = (STATE.officer.jobShort||'MDT') + ' · ' + (modeTheme().dept || (STATE.mode==='ems'?'MEDICAL':'TACTICAL')); }
    function spinner(){ view.innerHTML = skeletonView(); }
    async function open(id){
        if (id === 'settings_overlay') return Renderers.settings();
        const a = APPS.find(x => x.id === id) || APPS[0];
        if (!a) return;
        current = id; STATE.activeApp = id;
        Rail.setActive(id); setHeader(a); tools.innerHTML = '';
        post('play_sound', { alias:'tap' });
        spinner();
        const fn = Renderers[id] || Renderers.scaffold;
        try { await fn(a); } catch (e) { view.innerHTML = `<div class="empty"><div class="empty-ic"><i class="fa-solid fa-bug"></i></div><div class="empty-title">Render error</div><div class="empty-sub">${h(e.message||e)}</div></div>`; }
    }
    return { open, get view(){ return view; }, get tools(){ return tools; }, get current(){ return current; } };
})();

/* helper to drop content + wire */
function render(html){ App.view.innerHTML = html; return App.view; }
function tool(html){ App.tools.insertAdjacentHTML('beforeend', html); return App.tools.lastElementChild; }
function searchBox(ph, onInput){
    const el = tool(`<div class="search"><i class="fa-solid fa-magnifying-glass"></i><input placeholder="${h(ph)}"></div>`);
    el.querySelector('input').addEventListener('input', debounce(e => onInput(e.target.value.trim()), 280));
    return el.querySelector('input');
}
// icon may be passed with or without the `fa-` prefix - normalise it so the
// glyph always renders (this was why empty-state circles showed no icon).
function faIcon(name){ name = String(name || 'circle-info'); return name.startsWith('fa-') ? name : 'fa-' + name; }
function emptyState(icon, title, sub){ return `<div class="empty"><div class="empty-ic"><i class="fa-solid ${faIcon(icon)}"></i></div><div class="empty-title">${h(title)}</div><div class="empty-sub">${h(sub||'')}</div></div>`; }
/* premium shimmer skeleton shown while a view's data loads */
function skeletonView(){
    return `<div class="skel-wrap">
        <div class="grid g-4" style="margin-bottom:16px">${Array.from({length:4},()=>`<div class="skel skel-stat"></div>`).join('')}</div>
        ${Array.from({length:6},()=>`<div class="skel skel-row"></div>`).join('')}
    </div>`;
}
function prioColor(p){ return ({low:'var(--prio-low)',medium:'var(--prio-medium)',high:'var(--prio-high)',critical:'var(--prio-critical)'})[p] || 'var(--prio-medium)'; }
function avatarHTML(o, cls){ return `<span class="row-av ${cls||''}">${initials(o.name)}<img src="${h(avatarUrl(o.avatar))}" onerror="this.remove()"></span>`; }

/* ── Searchable citizen/patient picker (reused across forms) ──
   citizenPickerHTML('bk', 'Citizen') → markup;  after Modal.open call
   wireCitizenPicker('bk');  read with getCitizen('bk') → {id,name}.
   Picking from the list fills both; a free-typed value is kept as the name. */
function citizenPickerHTML(id, label, searchCb){
    return `<div class="field cpick" data-cpick="${id}" data-cb="${searchCb||'searchCitizens'}">
        <label>${h(label||'Citizen')}</label>
        <div class="cpick-box">
            <i class="fa-solid fa-magnifying-glass cpick-ic"></i>
            <input class="cpick-input" id="${id}-q" placeholder="Search name, ID or phone…" autocomplete="off" spellcheck="false">
            <input type="hidden" id="${id}-id"><input type="hidden" id="${id}-name">
            <div class="cpick-menu" id="${id}-menu" hidden></div>
        </div>
    </div>`;
}
function wireCitizenPicker(id){
    const box = $(`[data-cpick="${id}"]`); if (!box) return;
    const cb = box.dataset.cb || 'searchCitizens';
    const q = $(`#${id}-q`), menu = $(`#${id}-menu`);
    const pick = (c) => { $(`#${id}-id`).value = c.id||''; $(`#${id}-name`).value = c.name||''; q.value = c.name||''; box.classList.add('picked'); menu.hidden = true; };
    q.addEventListener('input', debounce(async () => {
        const v = q.value.trim();
        $(`#${id}-name`).value = v; $(`#${id}-id`).value = ''; box.classList.remove('picked');   // typed value is the fallback name
        if (v.length < 2) { menu.hidden = true; return; }
        menu.innerHTML = `<div class="cpick-loading"><div class="spinner" style="width:18px;height:18px"></div></div>`; menu.hidden = false;
        const [r] = await call(cb, v); const list = (r && r.results) || [];
        if (!list.length) { menu.innerHTML = `<div class="cpick-empty">No match - “${h(v)}” will be used as typed.</div>`; return; }
        menu.innerHTML = list.slice(0, 8).map(c => `<button type="button" class="cpick-item" data-pick='${JSON.stringify({ id:c.id, name:c.name })}'>${avatarHTML(c)}<div class="cpick-meta"><div class="cpick-name">${h(c.name||'Unknown')}</div><div class="cpick-sub">${h(c.id||'')}${c.dob?' · '+h(c.dob):''}</div></div></button>`).join('');
        menu.querySelectorAll('[data-pick]').forEach(b => b.onclick = () => { try { pick(JSON.parse(b.dataset.pick)); } catch {} });
    }, 280));
    document.addEventListener('click', (e) => { if (!menu.hidden && !e.target.closest(`[data-cpick="${id}"]`)) menu.hidden = true; });
}
function getCitizen(id){ return { id: ($(`#${id}-id`) || {}).value || '', name: ($(`#${id}-name`) || {}).value || ($(`#${id}-q`) || {}).value || '' }; }

/* "Nearest player" picker - a live dropdown of players physically near you
   (closest first), with a manual-entry fallback. Writes into #id-id / #id-name
   so getCitizen(id) works unchanged. Powers Billing / Pharmacy. */
function nearbyPickerHTML(id, label){
    return `<div class="field nearpick" data-near="${id}">
        <label>${h(label||'Patient')}</label>
        <select class="nearpick-sel" id="${id}-sel"><option value="">Scanning for nearby players…</option></select>
        <input type="hidden" id="${id}-id"><input type="hidden" id="${id}-name">
        <div class="nearpick-foot"><span class="muted"><i class="fa-solid fa-location-crosshairs"></i> Closest players to you</span><button type="button" class="nearpick-manual" id="${id}-manualbtn">Enter manually</button></div>
        <div class="nearpick-manual-box" id="${id}-manualbox" hidden><input id="${id}-mname" placeholder="Patient name"></div>
    </div>`;
}
async function wireNearbyPicker(id){
    const sel = $(`#${id}-sel`), hid = $(`#${id}-id`), hname = $(`#${id}-name`);
    const manualBtn = $(`#${id}-manualbtn`), manualBox = $(`#${id}-manualbox`), mname = $(`#${id}-mname`);
    const syncSel = () => { const o = sel.selectedOptions[0]; if (o){ hid.value = o.dataset.id||''; hname.value = o.dataset.name||''; } };
    sel.onchange = syncSel;
    if (manualBtn) manualBtn.onclick = () => { manualBox.hidden = !manualBox.hidden; if (!manualBox.hidden && mname) mname.focus(); };
    if (mname) mname.addEventListener('input', () => { hname.value = mname.value; hid.value = ''; });
    const players = await postR('nearby_players') || [];
    if (!players.length){
        sel.innerHTML = `<option value="">No players nearby</option>`;
        if (manualBox) manualBox.hidden = false;
        return;
    }
    sel.innerHTML = players.map((p,i)=>`<option value="${i}" data-id="${h(p.id||'')}" data-name="${h(p.name||('Player '+p.serverId))}">${h(p.name||('Player '+p.serverId))} · ${p.dist}m</option>`).join('');
    syncSel();
}

/* ============================================================
   RENDERERS
   ============================================================ */
const Renderers = {};

/* ── DASHBOARD ── */
Renderers.dashboard = async () => {
    if (STATE.officer.supervisor && feat('enableComms')) {
        const b = tool(`<button class="btn btn-ghost btn-sm" id="post-bulletin"><i class="fa-solid fa-bullhorn"></i> ${h(L('dash_bulletin','Bulletin'))}</button>`);
        b.onclick = () => {
            const prios = STATE.cfg.priorities || [];
            Modal.open({ title:L('dash_post_bulletin','Post Bulletin'), body:`<div class="field"><label>${h(L('dash_bl_title','Title'))}</label><input id="bl-title"></div><div class="field"><label>${h(L('gen_priority','Priority'))}</label><select id="bl-prio">${prios.map(p=>`<option value="${p.id}">${h(p.label)}</option>`).join('')}</select></div><div class="field"><label>${h(L('dash_bl_message','Message'))}</label><textarea id="bl-body"></textarea></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="bl-save">${h(L('dash_post','Post'))}</button>` });
            $('[data-mclose2]').onclick = Modal.close;
            $('#bl-save').onclick = async () => { await call('postBulletin', { title:$('#bl-title').value, body:$('#bl-body').value, priority:$('#bl-prio').value }); Modal.close(); App.open('dashboard'); };
        };
    }
    const [d] = await call('dashboard'); const data = d || {};
    const o = STATE.officer;
    const statTiles = STATE.mode === 'police' ? [
        { ic:'fa-users', c:'var(--green)', n:data.unitsOnDuty||0, l:L('dash_units_on_duty','Units On Duty') },
        { ic:'fa-tower-broadcast', c:'var(--orange)', n:data.activeCalls||0, l:L('dash_active_calls','Active Calls') },
        { ic:'fa-gavel', c:'var(--red)', n:data.activeWarrants||0, l:L('dash_active_warrants','Active Warrants') },
        { ic:'fa-bullhorn', c:'var(--yellow)', n:data.activeBolos||0, l:L('dash_active_bolos','Active BOLOs') },
    ] : [
        { ic:'fa-truck-medical', c:'var(--green)', n:data.unitsOnDuty||0, l:L('dash_units_on_duty','Units On Duty') },
        { ic:'fa-tower-broadcast', c:'var(--red)', n:data.activeCalls||0, l:L('dash_active_calls','Active Calls') },
        { ic:'fa-bed', c:'var(--cyan)', n:data.pendingCalls||0, l:L('dash_pending','Pending') },
        { ic:'fa-bullhorn', c:'var(--yellow)', n:data.activeBolos||0, l:L('dash_bulletins','Bulletins') },
    ];
    STATE.units = data.units || []; STATE.calls = data.calls || [];
    const actIcon = (a) => ({lookup:'fa-magnifying-glass',report:'fa-file-lines',warrant:'fa-gavel',bolo:'fa-bullhorn',citation:'fa-receipt',booking:'fa-fingerprint',duty:'fa-power-off',call:'fa-tower-broadcast',admission:'fa-bed',death:'fa-skull',billing:'fa-file-invoice-dollar',pharmacy:'fa-pills'})[a] || 'fa-circle-dot';
    // quick-action shortcuts (mode-aware, only enabled apps)
    const QA = STATE.mode === 'police'
        ? [['fa-file-lines',L('dash_qa_new_report','New Report'),'reports'],['fa-id-card',L('dash_qa_search','Search'),'profiles'],['fa-bullhorn',L('dash_qa_bolo','BOLO'),'bolos'],['fa-scale-balanced',L('dash_qa_charges','Charges'),'charges'],['fa-tower-broadcast',L('dash_qa_dispatch','Dispatch'),'dispatch'],['fa-map-location-dot',L('dash_qa_live_map','Live Map'),'map']]
        : [['fa-bed',L('dash_qa_admit','Admit'),'beds'],['fa-heart-pulse',L('dash_qa_triage','Triage'),'triage'],['fa-bed-pulse',L('dash_qa_patients','Patients'),'patients'],['fa-pills',L('dash_qa_pharmacy','Pharmacy'),'pharmacy'],['fa-file-invoice-dollar',L('dash_qa_billing','Billing'),'billing'],['fa-map-location-dot',L('dash_qa_live_map','Live Map'),'map']];
    const qaEnabled = QA.filter(q=>{ const a=APPS.find(x=>x.id===q[2]); return a && appEnabled(a); });
    const mapCard = feat('enableLiveMap')
        ? `<div class="card dash-map-card"><div class="card-h"><h3><i class="fa-solid fa-map-location-dot"></i> ${h(L('dash_qa_live_map','Live Map'))}</h3><button class="btn btn-ghost btn-sm" id="dash-open-map"><i class="fa-solid fa-up-right-and-down-left-from-center"></i> ${h(L('dash_full_map','Full map'))}</button></div>
                <div class="dash-map-wrap"><div id="dash-map"></div></div></div>`
        : `<div class="card"><div class="card-h"><h3><i class="fa-solid fa-tower-broadcast"></i> ${h(L('dash_active_calls','Active Calls'))}</h3></div>${STATE.calls.length?STATE.calls.slice(0,5).map(callRow).join(''):emptyState('tower-broadcast',L('dash_no_active_calls','No active calls'),'')}</div>`;
    render(`
        <div class="dash-hero">
            <div class="dh-av"><span id="dh-av-ini">${initials(o.name)}</span><img id="dh-av-img" alt="" hidden></div>
            <div class="dh-tx">
                <div class="dh-hi">${L('lock_welcome','Welcome back')},</div>
                <div class="dh-name">${h(o.name||'Officer')}</div>
                <div class="dh-meta"><span class="pill" style="--_c:${o.deptColor||'var(--brand-500)'}">${h(o.jobShort||'')}</span> ${h(o.rank||'')} · ${h(o.callsign||'')} · <span style="color:${STATE.duty?'var(--green)':'var(--text-3)'};font-weight:700">${STATE.duty?L('ui_on_duty','On Duty'):L('ui_off_duty','Off Duty')}</span></div>
            </div>
            <div class="dh-clock"><div class="t" id="dash-clock-t">--:--</div><div class="d" id="dash-clock-d"></div></div>
        </div>
        <div class="grid g-4 dash-stats">${statTiles.map(s => `<div class="stat"><div class="stat-ic" style="--_c:${s.c}"><i class="fa-solid ${s.ic}"></i></div><div class="stat-tx"><strong>${s.n}</strong><span>${s.l}</span></div></div>`).join('')}</div>
        ${qaEnabled.length?`<div class="card qa-card mb"><div class="qa-row">${qaEnabled.map(q=>`<button class="qa-tile" data-qa="${q[2]}"><span class="qa-ic"><i class="fa-solid ${q[0]}"></i></span><span class="qa-l">${q[1]}</span></button>`).join('')}</div></div>`:''}
        <div class="dash-grid">
            ${mapCard}
            <div class="card dash-side-card"><div class="card-h"><h3><i class="fa-solid fa-bullhorn"></i> ${h(L('dash_bulletins','Bulletins'))}</h3></div>
                <div class="dash-scroll">${(data.bulletins&&data.bulletins.length)?data.bulletins.map(b=>`<div class="bulletin" style="--_c:${prioColor(b.priority)}">${(o.supervisor&&b.id)?`<button class="bulletin-x" data-delbull="${b.id}" title="${h(L('dash_del_bulletin','Delete bulletin'))}"><i class="fa-solid fa-xmark"></i></button>`:''}<div class="bt">${h(b.title)}</div><div class="bb">${h(b.body)}</div><div class="bm">${h(b.author)} · ${ago(b.created_at)}</div></div>`).join(''):emptyState('bullhorn',L('dash_no_bulletins','No bulletins'),L('dash_no_bulletins_sub','Department announcements show here.'))}</div>
            </div>
        </div>
        <div class="card dash-feed-card"><div class="card-h"><h3><i class="fa-solid fa-clock-rotate-left"></i> ${h(L('dash_recent_activity','Recent Activity'))}</h3></div>
            <div class="dash-feed">${(data.recent&&data.recent.length)?data.recent.map(r=>`<div class="feed-row"><div class="fr-ic"><i class="fa-solid ${actIcon(r.action)}"></i></div><div class="fr-tx"><b>${h(r.actor_name||'Unit')}</b> ${h(r.detail||r.action)}</div><div class="fr-time">${ago(r.created_at)}</div></div>`).join(''):emptyState('clock-rotate-left',L('dash_no_activity','No activity yet'),L('dash_no_activity_sub','Actions across the department will appear here.'))}</div>
        </div>`);
    updateClock();
    applyAvatar('#dh-av-img', '#dh-av-ini', o.avatar);
    $$('[data-qa]').forEach(b=>b.onclick=()=>App.open(b.dataset.qa));
    $$('[data-delbull]').forEach(b=>b.onclick=()=>Modal.confirm(L('dash_del_bulletin_q','Delete this bulletin?'),async()=>{ await call('deleteBulletin', Number(b.dataset.delbull)); App.open('dashboard'); Notify({message:L('notify_deleted','Deleted.'),type:'success'}); }));
    if (feat('enableLiveMap')) {
        if (STATE.dashMap) { try { STATE.dashMap.remove(); } catch {} }
        STATE.dashMap = null; STATE.dashMarkers = STATE.dashMarkers || [];
        const dm = $('#dash-open-map'); if (dm) dm.onclick = () => App.open('map');
        ensureLeaflet().then(async ok => { if (!ok) return mapError('#dash-map');
            STATE.selfPos = await postR('my_pos');
            setTimeout(() => { STATE.dashMap = makeMap('dash-map'); plotMarkers(STATE.dashMap, STATE.dashMarkers); defaultMapView(STATE.dashMap); }, 80);
        });
    }
};

/* ── DISPATCH - full dispatch centre (police + EMS) ── */
const PRIO_RANK = { critical:0, high:1, medium:2, low:3 };
let dispatchFilter = 'all';
Renderers.dispatch = async () => {
    tool(`<button class="btn btn-ghost btn-sm" id="disp-refresh"><i class="fa-solid fa-rotate"></i></button>`);
    tool(`<button class="btn btn-ghost btn-sm" id="disp-codes"><i class="fa-solid fa-list-ol"></i> ${h(L('disp_codes_btn','Codes'))}</button>`);
    tool(`<button class="btn btn-primary btn-sm" id="new-call"><i class="fa-solid fa-plus"></i> ${L('ui_create','New Call')}</button>`);
    const [r] = await call('getCalls'); STATE.calls = (r&&r.calls)||[]; STATE.units = (r&&r.units)||[];
    paintDispatch();
    $('#new-call').onclick = dispatchCreateModal;
    $('#disp-codes').onclick = dispatchCodesModal;
    $('#disp-refresh').onclick = () => App.open('dispatch');
};
function dispatchCodesModal(){
    const types = STATE.cfg.callTypes||[], statuses = STATE.cfg.statuses||[];
    Modal.open({ wide:true, title: STATE.mode==='ems'?L('disp_ems_codes_title','EMS Codes & Quick Dispatch'):L('disp_codes_title','Dispatch Codes & Quick Dispatch'), body:`
        <div class="sec-h">${h(L('disp_call_types_h','Call Types - click to dispatch at your location'))}</div>
        <div class="grid g-2">${types.map(t=>`<button class="code-card" data-qd="${t.id}" style="--_c:${t.color||prioColor(t.priority)}"><div class="cc-ic"><i class="fa-solid ${t.icon||'fa-circle-exclamation'}"></i></div><div class="cc-tx"><div class="cc-t">${h(t.label)} <span class="code">${h(t.code||'')}</span></div><div class="cc-s">${h(String(t.priority||'').toUpperCase())}</div></div><i class="fa-solid fa-tower-broadcast cc-go"></i></button>`).join('')}</div>
        <div class="sec-h">${h(L('disp_status_codes_h','Status Codes'))}</div>
        <div class="wrap">${statuses.map(s=>`<span class="pill" style="--_c:${s.color}"><span class="dot" style="--_c:${s.color}"></span>${h(s.code)} · ${h(s.label)}</span>`).join('')}</div>`,
        footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_close','Close'))}</button>` });
    $('[data-mclose2]').onclick = Modal.close;
    $$('[data-qd]').forEach(b=>b.onclick=async()=>{ const t=types.find(x=>x.id===b.dataset.qd)||{}; const coords=await postR('my_pos'); await call('createCall',{ type:t.id, code:t.code, label:t.label, priority:t.priority, location:'Officer location', caller:STATE.officer.name, desc:'Quick dispatch', coords }); Modal.close(); Notify({message:(t.label||'Call')+' dispatched.',type:'success'}); App.open('dispatch'); });
}
function paintDispatch(){
    const allCalls = (STATE.calls||[]).slice().sort((a,b)=>{ const pa=PRIO_RANK[a.priority]??2, pb=PRIO_RANK[b.priority]??2; return pa!==pb ? pa-pb : (b.time||0)-(a.time||0); });
    const units = (STATE.units||[]).slice().sort((a,b)=>(b.available?1:0)-(a.available?1:0));
    const counts = { all: allCalls.length }; allCalls.forEach(c=>{ counts[c.priority]=(counts[c.priority]||0)+1; });
    const calls = dispatchFilter==='all' ? allCalls : allCalls.filter(c=>c.priority===dispatchFilter);
    const pending  = allCalls.filter(c=>!(c.assigned&&c.assigned.length)).length;
    const assigned = allCalls.length - pending;
    const avail    = units.filter(u=>u.available).length;
    const prios    = STATE.cfg.priorities||[];
    const ems      = STATE.mode==='ems';
    const chips = `<button class="chip ${dispatchFilter==='all'?'active':''}" data-dfilter="all">All <b>${counts.all||0}</b></button>` +
        prios.map(p=>`<button class="chip ${dispatchFilter===p.id?'active':''}" data-dfilter="${p.id}" style="--_c:${p.color}"><span class="dot" style="--_c:${p.color}"></span>${h(p.label)} <b>${counts[p.id]||0}</b></button>`).join('');
    render(`<div class="dispatch-wrap">
        <div class="grid g-4 dispatch-stats">
            <div class="stat"><div class="stat-ic" style="--_c:var(--orange)"><i class="fa-solid fa-tower-broadcast"></i></div><div class="stat-tx"><strong>${allCalls.length}</strong><span>${h(L('disp_active_calls','Active Calls'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--yellow)"><i class="fa-solid fa-circle-exclamation"></i></div><div class="stat-tx"><strong>${pending}</strong><span>${h(L('disp_unassigned','Unassigned'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--brand-500)"><i class="fa-solid fa-headset"></i></div><div class="stat-tx"><strong>${assigned}</strong><span>${h(L('disp_assigned','Assigned'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--green)"><i class="fa-solid fa-user-check"></i></div><div class="stat-tx"><strong>${avail}/${units.length}</strong><span>${h(L('disp_units_available','Units Available'))}</span></div></div>
        </div>
        <div class="dispatch-body">
            <div class="dispatch-main">
                <div class="dispatch-toolbar"><div class="chips">${chips}</div></div>
                <div class="dispatch-list">${calls.length?calls.map(callRow).join(''):emptyState('tower-broadcast', dispatchFilter==='all'?L('disp_no_calls_t','No active calls'):L('disp_no_match_t','No matching calls'), dispatchFilter==='all'?L('disp_no_calls_s','Create a call or wait for a 911.'):L('disp_no_match_s','Try a different priority filter.'))}</div>
            </div>
            <div class="card dispatch-units"><div class="card-h"><h3><i class="fa-solid ${ems?'fa-truck-medical':'fa-shield-halved'}"></i> ${h(L('disp_units','Units'))}</h3><span class="muted">${avail}/${units.length} ${h(L('disp_available','available'))}</span></div>
                <div class="units-list">${units.length?units.map(unitRow).join(''):emptyState('users',L('disp_no_units_t','No units on duty'),L('disp_no_units_s','Units appear here when they go on duty.'))}</div>
            </div>
        </div>
    </div>`);
    $$('[data-dfilter]').forEach(b=>b.onclick=()=>{ dispatchFilter=b.dataset.dfilter; paintDispatch(); });
    $$('[data-respond]').forEach(b=>b.onclick=async()=>{ const id=Number(b.dataset.respond); await call('assignCall', id); call('respondCall', id); Notify({message:L('notify_waypoint_set','Responding - waypoint set.'),type:'success'}); App.open('dispatch'); });
    $$('[data-assign]').forEach(b=>b.onclick=async()=>{ await call('assignCall', Number(b.dataset.assign)); App.open('dispatch'); });
    $$('[data-close-call]').forEach(b=>b.onclick=()=>Modal.confirm(L('disp_clear_q','Clear this call from the board?'),async()=>{ await call('setCallStatus', Number(b.dataset.closeCall),'closed'); App.open('dispatch'); }));
    $$('[data-unit-loc]').forEach(b=>b.onclick=()=>{ try{ post('waypoint',{coords:JSON.parse(b.dataset.unitLoc)}); Notify({message:L('notify_waypoint_set','Waypoint set.'),type:'success'});}catch{} });
}
function unitRow(u){
    return `<div class="row" style="cursor:default">
        <span class="dot" style="--_c:${u.statusColor||'var(--green)'}"></span>
        ${avatarHTML(u)}
        <div class="row-main"><div class="row-title">${h(u.callsign||u.name)}</div><div class="row-sub">${h(u.name)}${u.division?' · '+h(u.division):''} · ${h(u.status||'10-8')}</div></div>
        ${u.coords?`<button class="icon-btn" data-unit-loc='${JSON.stringify(u.coords)}' title="Set waypoint to unit"><i class="fa-solid fa-location-arrow"></i></button>`:''}
    </div>`;
}
function callRow(c){
    const ct = (STATE.cfg.callTypes||[]).find(t=>t.id===c.type)||{};
    const col = c.color||prioColor(c.priority);
    const myCs = STATE.officer.callsign;
    const has = c.assigned && c.assigned.length;
    return `<div class="call-card ${c.priority==='critical'?'crit':''}" style="--_c:${col}">
        <div class="call-ic"><i class="fa-solid ${ct.icon||'fa-circle-exclamation'}"></i></div>
        <div class="call-main">
            <div class="call-top"><div class="call-title">${h(c.label||c.type)} <span class="code">${h(c.code||'')}</span></div><span class="pill" style="--_c:${col}">${h(String(c.priority||'').toUpperCase())}</span></div>
            <div class="call-sub"><i class="fa-solid fa-location-dot"></i> ${h(c.location||L('disp_unknown','Unknown'))}${c.caller?` · <i class="fa-solid fa-phone-volume" style="font-size:10px"></i> ${h(c.caller)}`:''}</div>
            ${c.desc?`<div class="call-desc">${h(c.desc)}</div>`:''}
            <div class="call-foot">
                <span class="call-status"><span class="dot" style="--_c:${has?'var(--green)':'var(--yellow)'}"></span> ${has?h(L('disp_assigned','Assigned')):h(L('disp_pending','Pending'))}</span>
                ${has?`<div class="call-assigned">${c.assigned.map(a=>`<span class="call-unit ${a===myCs?'me':''}">${h(a)}</span>`).join('')}</div>`:`<span class="muted">${h(L('disp_awaiting','Awaiting units'))}</span>`}
                <span class="call-time">${ago(c.time?new Date(c.time*1000).toISOString():null)||'now'}</span>
            </div>
        </div>
        <div class="call-cta">
            ${c.coords?`<button class="btn btn-primary btn-sm" data-respond="${c.id}"><i class="fa-solid fa-location-arrow"></i> ${h(L('disp_respond','Respond'))}</button>`:''}
            <button class="btn btn-ghost btn-sm" data-assign="${c.id}"><i class="fa-solid fa-hand"></i> ${(has&&c.assigned.includes(myCs))?h(L('disp_assigned','Assigned')):h(L('disp_assign','Assign'))}</button>
            <button class="btn btn-danger btn-sm" data-close-call="${c.id}" title="${h(L('disp_clear_call_title','Clear call'))}"><i class="fa-solid fa-check"></i></button>
        </div>
    </div>`;
}
function dispatchCreateModal(){
    const types = STATE.cfg.callTypes||[], prios = STATE.cfg.priorities||[];
    Modal.open({ title: STATE.mode==='ems'?L('disp_new_ems_title','New EMS Call'):L('disp_new_call_title','New Dispatch Call'), body:`
        <div class="field-row"><div class="field"><label>${h(L('gen_type','Type'))}</label><select id="c-type">${types.map(t=>`<option value="${t.id}" data-prio="${h(t.priority||'medium')}">${h(t.label)} (${h(t.code||'')})</option>`).join('')}</select></div>
        <div class="field"><label>${h(L('gen_priority','Priority'))}</label><select id="c-prio">${prios.map(p=>`<option value="${p.id}">${h(p.label)}</option>`).join('')}</select></div></div>
        <div class="field"><label>${h(L('gen_location','Location'))}</label><input id="c-loc" placeholder="${h(L('disp_loc_ph','Street / area'))}"></div>
        <div class="field"><label>${h(L('disp_caller','Caller'))}</label><input id="c-caller" placeholder="${h(L('disp_caller_ph','Caller name (defaults to you)'))}"></div>
        <div class="field"><label>${h(L('gen_details','Details'))}</label><textarea id="c-desc" placeholder="${h(L('disp_desc_ph','Description…'))}"></textarea></div>
        <button type="button" class="toggle-row pref-row" id="c-here" style="width:100%"><span class="tr-l"><i class="fa-solid fa-location-crosshairs"></i> ${h(L('disp_attach_loc','Attach my location'))} <span class="muted" style="text-transform:none;letter-spacing:0">${h(L('disp_attach_hint','- responders get a waypoint'))}</span></span><span class="switch on"></span></button>`,
        footer:`<button class="btn btn-ghost" data-mclose2>${L('ui_cancel','Cancel')}</button><button class="btn btn-primary" id="c-save"><i class="fa-solid fa-tower-broadcast"></i> ${L('ui_create','Dispatch')}</button>` });
    const typeSel = $('#c-type');
    const syncPrio = () => { const o = typeSel.selectedOptions[0]; if (o && o.dataset.prio) $('#c-prio').value = o.dataset.prio; };
    typeSel.onchange = syncPrio; syncPrio();
    let here = true; $('#c-here').onclick = () => { here = !here; $('#c-here .switch').classList.toggle('on', here); };
    $('[data-mclose2]').onclick = Modal.close;
    $('#c-save').onclick = async () => {
        const t = types.find(x=>x.id===$('#c-type').value)||{};
        const coords = here ? await postR('my_pos') : null;
        await call('createCall', { type:t.id, code:t.code, label:t.label, priority:$('#c-prio').value, location:$('#c-loc').value, caller:$('#c-caller').value, desc:$('#c-desc').value, coords });
        Modal.close(); Notify({ message:L('notify_call_created','Call dispatched.'), type:'success' }); App.open('dispatch');
    };
}

/* ── LIVE MAP (apex_bossmenu method) ── */
// Robust Leaflet loader: if the static <script> didn't load (CEF couldn't
// reach the CDN), poll briefly then inject from fallback CDNs. Resolves
// true once window.L is ready, false if all sources fail.
let _leafletPromise = null;
function ensureLeaflet(){
    if (_leafletPromise) return _leafletPromise;
    _leafletPromise = new Promise((resolve) => {
        const ready = () => !!(window.L && window.L.map);
        if (ready()) return resolve(true);
        const cssUrls = [
            'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css',
            'https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css',
            'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css',
        ];
        const jsUrls = [
            'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js',
            'https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js',
            'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js',
        ];
        const addCss = (u) => { const l = document.createElement('link'); l.rel = 'stylesheet'; l.href = u; document.head.appendChild(l); };
        let ci = 0, ji = 0;
        const tryJs = () => {
            if (ready()) return resolve(true);
            if (ji >= jsUrls.length) return resolve(false);
            addCss(cssUrls[Math.min(ci++, cssUrls.length - 1)]);
            const s = document.createElement('script');
            s.src = jsUrls[ji++];
            s.onload = () => resolve(ready());
            s.onerror = tryJs;
            document.head.appendChild(s);
        };
        // give the static tag up to ~1.5s, otherwise inject from fallbacks
        let waited = 0;
        const poll = setInterval(() => {
            if (ready()) { clearInterval(poll); resolve(true); }
            else if ((waited += 120) >= 1500) { clearInterval(poll); tryJs(); }
        }, 120);
    });
    return _leafletPromise;
}
function mapError(sel){
    const el = $(sel); if (!el) return;
    el.innerHTML = `<div class="map-fail"><div class="empty-ic"><i class="fa-solid fa-wifi"></i></div>
        <div class="empty-title">Map unavailable</div>
        <div class="empty-sub">The map library/tiles could not be reached. The server's game client needs internet access to <b>unpkg/jsdelivr</b> and <b>gtamap.xyz</b>.</div></div>`;
}
const CENTER_X = () => STATE.cfg.map?.transform?.centerX ?? 117.3;
const CENTER_Y = () => STATE.cfg.map?.transform?.centerY ?? 172.8;
const SCALE_X  = () => STATE.cfg.map?.transform?.scaleX ?? 0.02072;
const SCALE_Y  = () => STATE.cfg.map?.transform?.scaleY ?? 0.0205;
// Build a fresh Leaflet map on `elId` (apex_bossmenu CRS + tiles). Reusable
// by the full Live Map app AND the dashboard mini-map widget.
function makeMap(elId){
    const L = window.L;   // Leaflet (the module-level `L` is the locale helper)
    const target = document.getElementById(elId); if (!target || typeof L === 'undefined') return null;
    const m = STATE.cfg.map || {};
    const CRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat, scale: z => Math.pow(2, z), zoom: s => Math.log(s)/Math.LN2,
        distance: (a,b) => { const dx=b.lng-a.lng, dy=b.lat-a.lat; return Math.sqrt(dx*dx+dy*dy); },
        transformation: new L.Transformation(SCALE_X(), CENTER_X(), -SCALE_Y(), CENTER_Y()), infinite: true,
    });
    const map = L.map(elId, { crs:CRS, minZoom:m.minZoom||2, maxZoom:m.maxZoom||5, zoom:m.zoom||3, center:[0,0],
        zoomControl:true, preferCanvas:true, attributionControl:false, maxBounds: m.maxBounds || [[8000,-5500],[-8000,5500]] });
    L.tileLayer(m.tileUrl || 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg', { minZoom:m.minZoom||2, maxZoom:m.maxZoom||5, noWrap:true }).addTo(map);
    // Recalculate size repeatedly while the open/app-launch animations settle,
    // otherwise Leaflet inits at 0×0 and tiles never paint.
    [60, 200, 400, 700, 1100].forEach(t => setTimeout(() => { try { map.invalidateSize(); } catch {} }, t));
    return map;
}
// Plot the current units + calls onto `map`, tracking the markers in `store`.
function plotMarkers(map, store){
    const L = window.L;
    if (!map) return;
    store.forEach(mk => { try { map.removeLayer(mk); } catch {} }); store.length = 0;
    (STATE.units||[]).forEach(u => {
        if (!u.coords) return;
        if (u.id ? u.id === STATE.officer.id : u.callsign === STATE.officer.callsign) return;   // self handled by the live "you" marker
        const mk = L.marker([u.coords.y, u.coords.x], { icon: L.divIcon({ className:'', html:`<div class="map-blip" style="--_c:${u.statusColor||'var(--brand-500)'}"></div>`, iconSize:[16,16] }) });
        mk.bindPopup(`<div class="mp-pop"><div class="pp-head"><strong>${h(u.callsign||u.name)}</strong></div><div class="pp-meta">${h(u.name)} · ${h(u.status||'10-8')}</div></div>`, { maxWidth:240 });
        mk.addTo(map); store.push(mk);
    });
    // the viewer's own live position (always shown, on duty or not)
    if (STATE.selfPos && STATE.selfPos.x != null) {
        const mk = L.marker([STATE.selfPos.y, STATE.selfPos.x], { icon: L.divIcon({ className:'', html:`<div class="map-blip self"></div>`, iconSize:[16,16] }), zIndexOffset:1000 });
        mk.bindPopup(`<div class="mp-pop"><div class="pp-head"><strong>${h(STATE.officer.callsign||STATE.officer.name||'You')}</strong></div><div class="pp-meta">You · ${h(STATE.officer.status||'')}</div></div>`, { maxWidth:240 });
        mk.addTo(map); store.push(mk);
    }
    (STATE.calls||[]).forEach(c => {
        if (!c.coords) return;
        const mk = L.marker([c.coords.y, c.coords.x], { icon: L.divIcon({ className:'', html:`<div class="map-blip call ${c.type==='panic'?'panic':''}" style="--_c:${c.color||prioColor(c.priority)}"></div>`, iconSize:[16,16] }) });
        mk.bindPopup(`<div class="mp-pop"><div class="pp-head"><strong>${h(c.label||c.type)}</strong><span class="muted">${h(c.code||'')}</span></div><div class="pp-meta">${h(c.location||'')}</div></div>`, { maxWidth:240 });
        mk.addTo(map); store.push(mk);
    });
    // stations / hospitals (static, mode-filtered)
    const sIcon = STATE.mode === 'ems' ? 'fa-hospital' : 'fa-building-shield';
    (STATE.cfg.stations || []).forEach(s => {
        if (s.x == null) return;
        const mk = L.marker([s.y, s.x], { icon: L.divIcon({ className:'', html:`<div class="map-station"><i class="fa-solid ${sIcon}"></i></div>`, iconSize:[28,28] }) });
        mk.bindPopup(`<div class="mp-pop"><div class="pp-head"><strong>${h(s.label)}</strong></div><div class="pp-meta">${STATE.mode==='ems'?'Hospital':'Station'}</div></div>`, { maxWidth:240 });
        mk.addTo(map); store.push(mk);
    });
}
// Centre on the player's own unit if tracked, else the configured city centre.
function defaultMapView(map){
    if (!map) return;
    const sp = STATE.selfPos;
    const me = (STATE.units || []).find(u => (u.id ? u.id === STATE.officer.id : u.callsign === STATE.officer.callsign) && u.coords);
    const dc = STATE.cfg.map && STATE.cfg.map.defaultCenter;
    const z = (STATE.cfg.map && STATE.cfg.map.defaultZoom) || 4;
    try {
        if (sp && sp.x != null) map.setView([sp.y, sp.x], z, { animate: false });
        else if (me && me.coords) map.setView([me.coords.y, me.coords.x], z, { animate: false });
        else if (dc) map.setView([dc.y, dc.x], z, { animate: false });
    } catch {}
}
function ensureMap(){
    if (STATE.mapBuilt) return STATE.map;
    STATE.map = makeMap('mdt-map'); STATE.mapBuilt = !!STATE.map; return STATE.map;
}
function renderMapMarkers(){ STATE.markers = STATE.markers || []; plotMarkers(ensureMap(), STATE.markers); }
function paintMapCalls(){
    const el = $('#map-calls'); if (!el) return;
    const u = $('#map-units'); if (u) u.textContent = (STATE.units||[]).length;
    const calls = (STATE.calls||[]).slice().sort((a,b)=>{ const pa=PRIO_RANK[a.priority]??2, pb=PRIO_RANK[b.priority]??2; return pa!==pb ? pa-pb : (b.time||0)-(a.time||0); });
    el.innerHTML = calls.length ? calls.map(c=>{ const ct=(STATE.cfg.callTypes||[]).find(t=>t.id===c.type)||{}; const col=c.color||prioColor(c.priority);
        return `<button class="map-call ${c.coords?'':'no-loc'}" data-mapcall='${h(JSON.stringify(c.coords||null))}' style="--_c:${col}">
            <div class="mc-ic"><i class="fa-solid ${ct.icon||'fa-circle-exclamation'}"></i></div>
            <div class="mc-tx"><div class="mc-t">${h(c.label||c.type)} <span class="code">${h(c.code||'')}</span></div><div class="mc-s"><i class="fa-solid fa-location-dot" style="font-size:9px"></i> ${h(c.location||L('map_unknown','Unknown'))}${(c.assigned&&c.assigned.length)?` · ${c.assigned.length} unit${c.assigned.length>1?'s':''}`:''}</div></div>
            <span class="mc-time">${ago(c.time?new Date(c.time*1000).toISOString():null)||'now'}</span></button>`; }).join('')
        : emptyState('tower-broadcast', L('map_no_calls_t','No active calls'), L('map_no_calls_s','New 911s show up here live.'));
    $$('#map-calls .map-call').forEach(b=>b.onclick=()=>{ let c=null; try{ c=JSON.parse(b.dataset.mapcall); }catch{} if (c && c.x!=null && STATE.map){ try{ STATE.map.setView([c.y,c.x], 6, {animate:true}); }catch{} } else Notify({message:L('map_no_loc','No location attached to this call.'),type:'warning'}); });
}
Renderers.map = async () => {
    const [r] = await call('getUnits'); STATE.units=(r&&r.units)||[]; STATE.calls=(r&&r.calls)||[];
    STATE.selfPos = await postR('my_pos');
    render(`<div class="map-view">
        <div class="map-wrap">
            <div id="mdt-map"></div>
            <div class="map-toolbar"><span class="map-live"><span class="rec-dot" style="background:var(--green);box-shadow:0 0 8px var(--green)"></span> ${h(L('map_live','LIVE'))}</span><button class="btn btn-ghost btn-sm" id="map-recenter"><i class="fa-solid fa-crosshairs"></i> ${h(L('map_recenter','Recenter'))}</button></div>
            <div class="map-legend"><span><span class="dot" style="--_c:var(--green)"></span> ${h(L('map_leg_you','You'))}</span><span><span class="dot" style="--_c:var(--brand-500)"></span> ${h(L('map_leg_units','Units'))}</span><span><span class="dot" style="--_c:var(--red)"></span> ${h(L('map_leg_calls','Calls'))}</span><span><span class="dot" style="--_c:var(--dept)"></span> ${STATE.mode==='ems'?h(L('map_leg_hospital','Hospital')):h(L('map_leg_station','Station'))}</span></div>
        </div>
        <div class="card map-dispatch">
            <div class="card-h"><h3><i class="fa-solid fa-tower-broadcast"></i> ${h(L('map_live_dispatch','Live Dispatch'))}</h3><span class="muted"><span id="map-units">0</span> ${h(L('map_units_suffix','units'))}</span></div>
            <div class="map-calls" id="map-calls"></div>
        </div>
    </div>`);
    if (STATE.map) { try { STATE.map.remove(); } catch {} }
    STATE.mapBuilt = false; STATE.map = null;   // rebuild against fresh DOM node
    paintMapCalls();
    const ok = await ensureLeaflet();
    if (!ok) { mapError('#mdt-map'); return; }
    setTimeout(() => { ensureMap(); renderMapMarkers();
        if (STATE._focus && STATE.map){ try { STATE.map.setView([STATE._focus.y, STATE._focus.x], 5, { animate:true }); } catch {} STATE._focus = null; }
        else defaultMapView(STATE.map);
    }, 60);
    $('#map-recenter').onclick = async () => { const map=ensureMap(); if (!map) return; STATE.selfPos = await postR('my_pos'); if (STATE.selfPos&&STATE.selfPos.x!=null) map.setView([STATE.selfPos.y,STATE.selfPos.x],5,{animate:true}); else defaultMapView(map); };
    // ── live auto-refresh (no button): re-poll units/calls every few seconds ──
    if (STATE.mapPoll) clearInterval(STATE.mapPoll);
    STATE.mapPoll = setInterval(async () => {
        if (!STATE.open || STATE.activeApp !== 'map') { clearInterval(STATE.mapPoll); STATE.mapPoll = null; return; }
        const [r2] = await call('getUnits'); STATE.units = (r2 && r2.units) || []; STATE.calls = (r2 && r2.calls) || [];
        STATE.selfPos = await postR('my_pos');
        renderMapMarkers(); paintMapCalls();
    }, (STATE.cfg.map && STATE.cfg.map.streamIntervalMs) || 3000);
};

/* ── UNITS - live on-duty units board ── */
Renderers.units = async () => {
    tool(`<button class="btn btn-ghost btn-sm" id="units-refresh"><i class="fa-solid fa-rotate"></i> ${h(L('units_refresh','Refresh'))}</button>`);
    const [r] = await call('getUnits'); const units = (r && r.units) || []; STATE.calls = (r && r.calls) || STATE.calls;
    const avail = units.filter(u => u.available).length;
    const ic = STATE.mode === 'ems' ? 'fa-truck-medical' : 'fa-shield-halved';
    render(`
      <div class="grid g-4 mb">
        <div class="stat"><div class="stat-ic" style="--_c:var(--green)"><i class="fa-solid fa-user-check"></i></div><div class="stat-tx"><strong>${avail}</strong><span>${h(L('units_available','Available'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--brand-500)"><i class="fa-solid fa-users"></i></div><div class="stat-tx"><strong>${units.length}</strong><span>${h(L('units_on_duty','On Duty'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--orange)"><i class="fa-solid fa-tower-broadcast"></i></div><div class="stat-tx"><strong>${(STATE.calls||[]).length}</strong><span>${h(L('units_active_calls','Active Calls'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--purple)"><i class="fa-solid fa-location-dot"></i></div><div class="stat-tx"><strong>${units.filter(u=>u.coords).length}</strong><span>${h(L('units_gps_tracked','GPS Tracked'))}</span></div></div>
      </div>
      <div class="list">${units.length ? units.map(u=>`
        <div class="row" style="cursor:default">
          <span class="dot" style="--_c:${u.statusColor||'var(--green)'}"></span>
          ${avatarHTML(u)}
          <div class="row-main"><div class="row-title">${h(u.callsign||u.name)} ${u.callsign?`<span class="muted" style="font-weight:500">· ${h(u.name)}</span>`:''}</div>
            <div class="row-sub">${h(u.status||'10-8')}${u.division?' · '+h(u.division):''}</div></div>
          <div class="row-aside"><span class="pill" style="--_c:${u.statusColor||'var(--green)'}">${h(u.status||'10-8')}</span>
            ${u.coords?`<button class="btn btn-ghost btn-sm" data-loc='${JSON.stringify(u.coords)}'><i class="fa-solid fa-location-arrow"></i> ${h(L('units_locate','Locate'))}</button>`:''}
            ${u.coords?`<button class="btn btn-ghost btn-sm" data-mapfocus='${JSON.stringify(u.coords)}'><i class="fa-solid fa-map-location-dot"></i></button>`:''}
          </div>
        </div>`).join('') : emptyState('users', L('units_empty_t','No units on duty'), L('units_empty_s','Units appear here when officers/medics go on duty.'))}</div>`);
    $('#units-refresh').onclick = () => App.open('units');
    $$('[data-loc]').forEach(b => b.onclick = () => { try { post('waypoint', { coords: JSON.parse(b.dataset.loc) }); Notify({ message: L('notify_waypoint_set','Waypoint set.'), type:'success' }); } catch {} });
    $$('[data-mapfocus]').forEach(b => b.onclick = () => { try { STATE._focus = JSON.parse(b.dataset.mapfocus); } catch {} App.open('map'); });
};

/* ── PROFILES (citizens) / PATIENTS share a master-detail ── */
function personApp(opts){
    return async () => {
        render(`<div class="split"><div class="split-list"><div class="split-scroll" id="p-list"><div class="loading"><div class="spinner"></div></div></div></div><div class="split-detail card" id="p-detail">${emptyState(opts.icon, L('prof_select_t','Select a record'), L('prof_select_s','Pick anyone from the list (or search) to view the full file.'))}</div></div>`);
        const load = async (q) => {
            $('#p-list').innerHTML = `<div class="loading"><div class="spinner"></div></div>`;
            const [r] = await call(opts.searchCb, q || ''); const list = (r&&r.results)||[];
            if (!list.length){ $('#p-list').innerHTML = emptyState('user-slash', L('ui_no_results','No results'), q?L('prof_try_search','Try a different search.'):L('prof_register_empty','The register is empty.')); return; }
            $('#p-list').innerHTML = list.map(c => `<div class="row" data-cid="${h(c.id)}">${avatarHTML(c)}<div class="row-main"><div class="row-title">${h(c.name||'Unknown')}</div><div class="row-sub">${h(c.dob||'')} ${c.phone?'· '+h(c.phone):''}</div></div><i class="fa-solid fa-chevron-right" style="color:var(--text-4)"></i></div>`).join('');
            $$('#p-list .row').forEach(row => row.onclick = () => { $$('#p-list .row').forEach(x=>x.classList.remove('active')); row.classList.add('active'); opts.openDetail(row.dataset.cid); });
        };
        searchBox(opts.placeholder, (q) => load(q));
        load('');                                  // show the whole register, alphabetical (no auto-focus)
    };
}
function flagsBanner(flags){
    if (!flags || !flags.length) return '';
    const defs = STATE.cfg.flags || [];
    return `<div class="flags-banner">${flags.map(f => { const d = defs.find(x=>x.id===f)||{label:f,color:'var(--red)',icon:'fa-flag'}; return `<span class="flag-chip" style="--_c:${d.color}"><i class="fa-solid ${d.icon}"></i> ${h(d.label)}</span>`; }).join('')}</div>`;
}
Renderers.profiles = personApp({
    icon:'fa-id-card', placeholder:L('prof_search_ph','Search name, ID, phone…'), searchTitle:L('prof_search_t','Search citizens'), searchSub:L('prof_search_s','Find by name, identifier or phone number.'),
    searchCb:'searchCitizens',
    openDetail: async (id) => {
        $('#p-detail').innerHTML = `<div class="loading"><div class="spinner"></div></div>`;
        const [r] = await call('getCitizen', id); if (!r||!r.ok){ $('#p-detail').innerHTML = emptyState('user-slash', L('prof_not_found','Not found'), ''); return; }
        const c = r.citizen;
        const lic = c.licenses ? (Array.isArray(c.licenses)?c.licenses:Object.keys(c.licenses)) : [];
        $('#p-detail').innerHTML = `
            ${flagsBanner(c.flags)}
            <div class="flex mb" style="gap:16px">
                <span class="row-av" style="width:92px;height:92px;border-radius:16px;font-size:30px">${initials(c.name)}<img src="${h(avatarUrl(c.avatar))}" onerror="this.remove()"></span>
                <div><div style="font-size:20px;font-weight:800">${h(c.name)}</div><div class="muted">${h(c.id)}</div></div>
                <div style="margin-left:auto" class="wrap"><button class="btn btn-ghost btn-sm" data-mug><i class="fa-solid fa-camera"></i> ${h(L('prof_mugshot','Mugshot'))}</button><button class="btn btn-ghost btn-sm" data-flag><i class="fa-solid fa-flag"></i> ${h(L('prof_flag','Flag'))}</button><button class="btn btn-ghost btn-sm" data-note><i class="fa-solid fa-note-sticky"></i> ${h(L('prof_note','Note'))}</button></div>
            </div>
            <div class="kv mb">
                <div class="kv-item"><span>${h(L('prof_dob','Date of Birth'))}</span><strong>${h(c.dob||'-')}</strong></div>
                <div class="kv-item"><span>${h(L('prof_sex','Sex'))}</span><strong>${h(c.sex||'-')}</strong></div>
                <div class="kv-item"><span>${h(L('gen_phone','Phone'))}</span><strong>${h(c.phone||'-')}</strong></div>
                <div class="kv-item"><span>${h(L('prof_height','Height'))}</span><strong>${h(c.height||'-')}</strong></div>
            </div>
            <div class="sec-h">${h(L('prof_licenses','Licenses'))}</div><div class="wrap mb">${lic.length?lic.map(l=>`<span class="tag">${h(l)}</span>`).join(''):'<span class="muted">'+h(L('prof_no_licenses','No licenses on file.'))+'</span>'}</div>
            <div class="sec-h">${h(L('prof_reg_vehicles','Registered Vehicles'))}</div><div class="list mb">${(c.vehicles&&c.vehicles.length)?c.vehicles.map(v=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid fa-car"></i></div><div class="row-main"><div class="row-title mono">${h(v.plate)}</div><div class="row-sub">${h(v.model)}</div></div></div>`).join(''):'<span class="muted">'+h(L('prof_no_vehicles','No vehicles registered.'))+'</span>'}</div>
            <div class="sec-h">${h(L('prof_criminal_record','Criminal Record'))}</div>
            <div class="grid g-3 mb">
                <div class="stat"><div class="stat-ic" style="--_c:var(--red)"><i class="fa-solid fa-gavel"></i></div><div class="stat-tx"><strong>${(c.warrants||[]).length}</strong><span>${h(L('prof_warrants','Warrants'))}</span></div></div>
                <div class="stat"><div class="stat-ic" style="--_c:var(--yellow)"><i class="fa-solid fa-receipt"></i></div><div class="stat-tx"><strong>${(c.citations||[]).length}</strong><span>${h(L('prof_citations','Citations'))}</span></div></div>
                <div class="stat"><div class="stat-ic" style="--_c:var(--brand-500)"><i class="fa-solid fa-file-lines"></i></div><div class="stat-tx"><strong>${(c.reports||[]).length}</strong><span>${h(L('prof_reports','Reports'))}</span></div></div>
            </div>
            ${(c.reports&&c.reports.length)?'<div class="sec-h">'+h(L('prof_reports','Reports'))+'</div><div class="list mb">'+c.reports.map(rp=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid ${({arrest:'fa-handcuffs',incident:'fa-file-lines',medical:'fa-notes-medical'})[rp.type]||'fa-file-lines'}"></i></div><div class="row-main"><div class="row-title">${h(rp.title||rp.type)}</div><div class="row-sub">${h(rp.type)} · ${ago(rp.created_at)} · ${h(rp.status)}</div></div></div>`).join('')+'</div>':''}
            <div class="sec-h">${h(L('prof_officer_notes','Officer Notes'))}</div><div class="list" id="notes-list">${(c.notes&&c.notes.length)?c.notes.map(n=>`<div class="row" style="cursor:default"><div class="row-main"><div class="row-title" style="font-weight:500;white-space:normal">${h(n.body)}</div><div class="row-sub">${h(n.author)} · ${ago(n.created_at)}</div></div>${n.id?`<button class="btn btn-ghost btn-sm" data-delnote="${n.id}" style="margin-left:auto" title="${h(L('prof_del_note','Delete note'))}"><i class="fa-solid fa-trash"></i></button>`:''}</div>`).join(''):'<span class="muted">'+h(L('gen_no_notes','No notes.'))+'</span>'}</div>`;
        $('[data-note]').onclick = () => Modal.open({ title:L('gen_add_note','Add Note'), body:`<div class="field"><label>${h(L('prof_note','Note'))}</label><textarea id="note-body"></textarea></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="note-save">${h(L('ui_save','Save'))}</button>` }) && ($('[data-mclose2]').onclick=Modal.close, $('#note-save').onclick=async()=>{ await call('addNote','citizen',id,$('#note-body').value); Modal.close(); _reopenCitizen(id); Notify({message:L('notify_saved','Saved.'),type:'success'}); });
        $('[data-flag]').onclick = () => { const defs=(STATE.cfg.flags||[]).filter(f=>f.mode!=='ems'); const has=(fid)=>(c.flags||[]).includes(fid); Modal.open({ title:L('prof_manage_flags','Manage Flags'), body:`<p class="muted mb">${h(L('prof_manage_flags_sub','Click to add; click an active flag to remove it.'))}</p><div class="chips">${defs.map(f=>`<button class="chip ${has(f.id)?'active':''}" data-f="${f.id}" style="--_c:${f.color}"><span class="dot" style="--_c:${f.color}"></span>${h(f.label)}${has(f.id)?' <i class="fa-solid fa-check"></i>':''}</button>`).join('')}</div>` }); $$('[data-f]').forEach(b=>b.onclick=async()=>{ const fid=b.dataset.f; await call(has(fid)?'removeFlag':'addFlag',id,fid); Modal.close(); _reopenCitizen(id); Notify({message:L('notify_saved','Saved.'),type:'success'}); }); };
        $$('[data-delnote]').forEach(b=>b.onclick=()=>Modal.confirm(L('prof_del_note_q','Delete this note?'),async()=>{ await call('deleteNote', Number(b.dataset.delnote)); _reopenCitizen(id); Notify({message:L('notify_deleted','Deleted.'),type:'success'}); }));
        $('[data-mug]').onclick = () => requestPhoto({ purpose:'mugshot', storeId:id });
    },
});
// Re-open a citizen file in place (used after adding a note/flag) by
// re-triggering its list row, which re-fetches + re-renders the detail.
function _reopenCitizen(id){ $$('#p-list .row').forEach(r => { if (r.dataset.cid === String(id)) r.click(); }); }

Renderers.patients = personApp({
    icon:'fa-bed-pulse', placeholder:L('prof_pat_search_ph','Search patient name, ID…'), searchTitle:L('prof_pat_search_t','Search patients'), searchSub:L('prof_pat_search_s','Find a patient by name or identifier.'),
    searchCb:'searchPatients',
    openDetail: async (id) => {
        $('#p-detail').innerHTML = `<div class="loading"><div class="spinner"></div></div>`;
        const [r] = await call('getPatient', id); if (!r||!r.ok){ $('#p-detail').innerHTML = emptyState('user-slash', L('prof_not_found','Not found'), ''); return; }
        const c = r.patient;
        $('#p-detail').innerHTML = `
            ${flagsBanner(c.flags)}
            <div class="flex mb" style="gap:16px"><span class="row-av" style="width:92px;height:92px;border-radius:16px;font-size:30px">${initials(c.name)}<img src="${h(avatarUrl(c.avatar))}" onerror="this.remove()"></span>
                <div><div style="font-size:20px;font-weight:800">${h(c.name)}</div><div class="muted">${h(c.id)}</div></div>
                <div style="margin-left:auto" class="wrap"><button class="btn btn-ghost btn-sm" data-mug><i class="fa-solid fa-camera"></i> ${h(L('prof_mugshot','Mugshot'))}</button><button class="btn btn-success btn-sm" data-treat><i class="fa-solid fa-kit-medical"></i> ${h(L('prof_treat','Treat'))}</button><button class="btn btn-primary btn-sm" data-admit><i class="fa-solid fa-bed"></i> ${h(L('prof_admit','Admit'))}</button></div></div>
            <div class="kv mb">
                <div class="kv-item"><span>${h(L('prof_dob','Date of Birth'))}</span><strong>${h(c.dob||'-')}</strong></div>
                <div class="kv-item"><span>${h(L('prof_blood_type','Blood Type'))}</span><strong>${h(c.blood||L('prof_blood_unknown','Unknown'))}</strong></div>
                <div class="kv-item"><span>${h(L('prof_sex','Sex'))}</span><strong>${h(c.sex||'-')}</strong></div>
                <div class="kv-item"><span>${h(L('gen_phone','Phone'))}</span><strong>${h(c.phone||'-')}</strong></div>
            </div>
            <div class="sec-h">${h(L('prof_admission_history','Admission History'))}</div><div class="list mb">${(c.admissions&&c.admissions.length)?c.admissions.map(a=>`<div class="row" style="cursor:default"><div class="row-av" style="--_c"><i class="fa-solid fa-bed"></i></div><div class="row-main"><div class="row-title">${h(a.ward||'-')} · ${h(a.diagnosis||'')}</div><div class="row-sub">${h(a.doctor||'')} · ${ago(a.created_at)} · ${h(a.status)}</div></div></div>`).join(''):'<span class="muted">'+h(L('prof_no_admissions','No admissions.'))+'</span>'}</div>
            <div class="sec-h">${h(L('prof_prescriptions','Prescriptions'))}</div><div class="list mb">${(c.prescriptions&&c.prescriptions.length)?c.prescriptions.map(p=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid fa-pills"></i></div><div class="row-main"><div class="row-title">${h(p.medication)} ×${p.qty}</div><div class="row-sub">${h(p.prescriber)} · ${p.dispensed?h(L('prof_dispensed','dispensed')):h(L('prof_pending','pending'))}</div></div></div>`).join(''):'<span class="muted">'+h(L('prof_no_prescriptions','No prescriptions.'))+'</span>'}</div>`;
        $('[data-treat]').onclick = async () => { await call('treatPatient', null, 100); Notify({message:L('prof_treatment_logged','Treatment logged.'),type:'success'}); };
        $('[data-mug]').onclick = () => requestPhoto({ purpose:'mugshot', storeId:id });
        $('[data-admit]').onclick = () => admitModal(c);
    },
});

/* ── VEHICLES ── */
Renderers.vehicles = async () => {
    render(`<div class="split"><div class="split-list"><div class="split-scroll" id="v-list"><div class="loading"><div class="spinner"></div></div></div></div><div class="split-detail card" id="v-detail">${emptyState('car',L('veh_pick_t','Select a vehicle'),L('veh_pick_s','Pick a vehicle from the list (or search a plate) to view registration.'))}</div></div>`);
    const openVeh = async (plate) => {
        $('#v-detail').innerHTML=`<div class="loading"><div class="spinner"></div></div>`;
        const [d]=await call('getVehicle',plate); if(!d||!d.ok){$('#v-detail').innerHTML=emptyState('car',L('veh_not_found','Not found'),'');return;}
        const v=d.vehicle;
        $('#v-detail').innerHTML=`${v.bolo?`<div class="flags-banner"><span class="flag-chip"><i class="fa-solid fa-bullhorn"></i> ${h(L('veh_active_bolo','ACTIVE BOLO'))} · ${h(v.bolo.description||'')}</span></div>`:''}
            <div class="flex mb" style="gap:16px"><div class="appbar-icon" style="width:56px;height:56px;font-size:24px"><i class="fa-solid fa-car"></i></div><div><div style="font-size:22px;font-weight:800" class="mono">${h(v.plate)}</div><div class="muted">${h(v.model)}</div></div></div>
            <div class="kv mb"><div class="kv-item"><span>${h(L('veh_reg_owner','Registered Owner'))}</span><strong>${h(v.ownerName||'Unknown')}</strong></div><div class="kv-item"><span>${h(L('veh_owner_id','Owner ID'))}</span><strong>${h(v.ownerId||'-')}</strong></div><div class="kv-item"><span>${h(L('gen_status','Status'))}</span><strong>${v.stored==1?L('veh_garaged','Garaged'):L('veh_out','Out')}</strong></div><div class="kv-item"><span>${h(L('veh_garage','Garage'))}</span><strong>${h(v.garage||'-')}</strong></div></div>
            <div class="sec-h">${h(L('gen_notes','Notes'))}</div><div class="list">${(v.notes&&v.notes.length)?v.notes.map(n=>`<div class="row" style="cursor:default"><div class="row-main"><div class="row-title" style="font-weight:500;white-space:normal">${h(n.body)}</div><div class="row-sub">${h(n.author)} · ${ago(n.created_at)}</div></div></div>`).join(''):'<span class="muted">'+h(L('gen_no_notes','No notes.'))+'</span>'}</div>
            <button class="btn btn-ghost btn-sm mt" id="v-note"><i class="fa-solid fa-note-sticky"></i> ${h(L('gen_add_note','Add Note'))}</button>`;
        $('#v-note').onclick=()=>{ Modal.open({title:L('veh_note_title','Vehicle Note'),body:`<div class="field"><label>${h(L('veh_note_label','Note'))}</label><textarea id="vn"></textarea></div>`,footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="vns">${h(L('ui_save','Save'))}</button>`}); $('[data-mclose2]').onclick=Modal.close; $('#vns').onclick=async()=>{await call('addNote','vehicle',v.plate,$('#vn').value);Modal.close();Notify({message:L('notify_saved','Saved.'),type:'success'});}; };
    };
    const load = async (q) => {
        $('#v-list').innerHTML = `<div class="loading"><div class="spinner"></div></div>`;
        const [r] = await call('searchVehicles', q || ''); const list=(r&&r.results)||[];
        if (!list.length){ $('#v-list').innerHTML = emptyState('car',L('veh_none_t','No vehicles'), q?L('veh_no_match','No plate matches.'):L('veh_none_reg','No registered vehicles.')); return; }
        $('#v-list').innerHTML = list.map(v=>`<div class="row" data-plate="${h(v.plate)}"><div class="row-av"><i class="fa-solid fa-car"></i></div><div class="row-main"><div class="row-title mono">${h(v.plate)}</div><div class="row-sub">${h(v.model)}</div></div><i class="fa-solid fa-chevron-right" style="color:var(--text-4)"></i></div>`).join('');
        $$('#v-list .row').forEach(row=>row.onclick=()=>{ $$('#v-list .row').forEach(x=>x.classList.remove('active')); row.classList.add('active'); openVeh(row.dataset.plate); });
    };
    searchBox(L('veh_search_ph','Search plate…'), (q) => load(q));
    load('');
};

/* ── REPORTS ── */
Renderers.reports = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-report"><i class="fa-solid fa-plus"></i> ${L('ui_create','New Report')}</button>`);
    const [r] = await call('getReports'); const list=(r&&r.reports)||[];
    render(`<div class="list">${list.length?list.map(rp=>`<div class="row" data-rid="${rp.id}"><div class="row-av"><i class="fa-solid ${({arrest:'fa-handcuffs',incident:'fa-file-lines',medical:'fa-notes-medical'})[rp.type]||'fa-file-lines'}"></i></div><div class="row-main"><div class="row-title">${h(rp.title||L('rep_untitled','(untitled)'))}</div><div class="row-sub">${h(rp.type)} · ${h(rp.author_name||'')} · ${ago(rp.created_at)}</div></div><span class="pill" style="--_c:${rp.status==='approved'?'var(--green)':rp.status==='submitted'?'var(--yellow)':'var(--text-3)'}">${h(rp.status)}</span></div>`).join(''):emptyState('file-lines',L('rep_none_t','No reports'),L('rep_none_s','Create the first report.'))}</div>`);
    $('#new-report').onclick = () => reportEditor();
    $$('[data-rid]').forEach(row=>row.onclick=async()=>{ const [d]=await call('getReport',Number(row.dataset.rid)); if(d&&d.ok) reportEditor(d.report); });
};
function reportEditor(rep){
    rep = rep || {};
    const types = (STATE.cfg.reportTypes||[]).filter(t=>t.mode===STATE.mode);
    const sup = STATE.officer.supervisor;
    Modal.open({ wide:true, title: rep.id?L('rep_edit_title','Edit Report'):L('rep_new_title','New Report'), body:`
        <div class="field-row"><div class="field"><label>${h(L('gen_type','Type'))}</label><select id="r-type">${types.map(t=>`<option value="${t.id}" ${rep.type===t.id?'selected':''}>${h(t.label)}</option>`).join('')}</select></div>
        <div class="field"><label>${h(L('rep_title_label','Title'))}</label><input id="r-title" value="${h(rep.title||'')}"></div></div>
        <div class="field"><label>${h(L('rep_narrative','Narrative'))}</label><textarea id="r-narr" style="min-height:160px">${h(rep.narrative||'')}</textarea></div>
        <div class="field"><label>${h(L('rep_tags','Tags (comma separated)'))}</label><input id="r-tags" value="${h(rep.tags||'')}"></div>`,
        footer:`${rep.id&&sup&&rep.status!=='approved'?`<button class="btn btn-success" id="r-approve"><i class="fa-solid fa-check"></i> ${L('ui_approve','Approve')}</button>`:''}
            ${rep.id?`<button class="btn btn-danger" id="r-del"><i class="fa-solid fa-trash"></i></button>`:''}
            <button class="btn btn-ghost" id="r-draft">${h(L('rep_save_draft','Save Draft'))}</button><button class="btn btn-primary" id="r-submit"><i class="fa-solid fa-paper-plane"></i> ${L('ui_submit','Submit')}</button>` });
    const collect = (status) => ({ id:rep.id, type:$('#r-type').value, title:$('#r-title').value, narrative:$('#r-narr').value, tags:$('#r-tags').value, status, involved:rep.involved||[], charges:rep.charges||[] });
    const saveAnd = async (status) => { await call('saveReport', collect(status)); Modal.close(); Notify({message:status==='submitted'?L('notify_needs_approval','Submitted.'):L('notify_saved','Saved.'),type:'success'}); App.open('reports'); };
    $('#r-draft').onclick = () => saveAnd('draft');
    $('#r-submit').onclick = () => saveAnd('submitted');
    if ($('#r-approve')) $('#r-approve').onclick = async()=>{ await call('approveReport',rep.id); Modal.close(); Notify({message:L('notify_approved','Approved.'),type:'success'}); App.open('reports'); };
    if ($('#r-del')) $('#r-del').onclick = () => Modal.confirm(L('rep_del_q','Delete this report?'), async()=>{ await call('deleteReport',rep.id); Modal.close(); App.open('reports'); });
}

/* ── WARRANTS ── */
Renderers.warrants = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-warrant"><i class="fa-solid fa-plus"></i> ${L('ui_create','New Warrant')}</button>`);
    const [r]=await call('getWarrants'); const list=(r&&r.warrants)||[];
    render(`<div class="list">${list.length?list.map(w=>`<div class="row" style="cursor:default;--_c:${w.status==='active'?'var(--red)':'var(--text-3)'}"><div class="row-av"><i class="fa-solid fa-gavel"></i></div><div class="row-main"><div class="row-title">${h(w.citizen_name||'Unknown')} <span class="tag">${h(w.type)}</span></div><div class="row-sub">${h(w.reason||'')} · ${h(w.issued_by||'')}</div></div><div class="row-aside"><span class="pill" style="--_c:${w.status==='active'?'var(--red)':w.status==='pending'?'var(--yellow)':'var(--text-3)'}">${h(w.status)}</span>${(w.status==='pending'&&STATE.officer.supervisor)?`<button class="btn btn-success btn-sm" data-wapprove="${w.id}">${L('ui_approve','Approve')}</button>`:''}${w.status==='active'?`<button class="btn btn-ghost btn-sm" data-wexec="${w.id}">${h(L('war_execute','Execute'))}</button>`:''}</div></div>`).join(''):emptyState('gavel',L('war_none_t','No warrants'),L('war_none_s','Issue the first warrant.'))}</div>`);
    $('#new-warrant').onclick = warrantModal;
    $$('[data-wapprove]').forEach(b=>b.onclick=async()=>{ await call('approveWarrant',Number(b.dataset.wapprove)); App.open('warrants'); });
    $$('[data-wexec]').forEach(b=>b.onclick=async()=>{ await call('setWarrantStatus',Number(b.dataset.wexec),'executed'); App.open('warrants'); });
};
function warrantModal(){
    Modal.open({ title:L('war_issue_title','Issue Warrant'), body:`${citizenPickerHTML('w',L('gen_citizen','Citizen'))}
        <div class="field"><label>${h(L('gen_type','Type'))}</label><select id="w-type"><option value="arrest">${h(L('war_arrest','Arrest'))}</option><option value="search">${h(L('war_search','Search'))}</option></select></div>
        <div class="field"><label>${h(L('gen_reason','Reason'))}</label><textarea id="w-reason"></textarea></div>
        ${STATE.cfg.features.warrantsNeedApproval&&!STATE.officer.supervisor?`<p class="muted"><i class="fa-solid fa-circle-info"></i> ${h(L('war_pending_hint','This warrant will be PENDING until a supervisor approves it.'))}</p>`:''}`,
        footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="w-save">${h(L('war_issue_btn','Issue'))}</button>` });
    wireCitizenPicker('w');
    $('[data-mclose2]').onclick=Modal.close;
    $('#w-save').onclick=async()=>{ const c=getCitizen('w'); await call('createWarrant',{ citizenName:c.name, citizenId:c.id, type:$('#w-type').value, reason:$('#w-reason').value }); Modal.close(); App.open('warrants'); Notify({message:L('notify_saved','Saved.'),type:'success'}); };
}

/* ── BOLOs ── */
Renderers.bolos = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-bolo"><i class="fa-solid fa-plus"></i> ${L('ui_create','New BOLO')}</button>`);
    const [r]=await call('getBolos'); const list=(r&&r.bolos)||[];
    render(`<div class="grid g-2">${list.length?list.map(b=>`<div class="card" style="border-left:3px solid ${prioColor(b.priority)}"><div class="between mb"><div class="flex"><i class="fa-solid ${b.type==='vehicle'?'fa-car':'fa-user'}" style="color:${prioColor(b.priority)}"></i><strong>${h(b.title)}</strong></div><span class="pill" style="--_c:${prioColor(b.priority)}">${h(b.priority)}</span></div><p class="muted" style="line-height:1.5;margin-bottom:8px">${h(b.description||'')}</p>${b.plate?`<div class="mono mb">${h(L('gen_plate','Plate'))}: ${h(b.plate)}</div>`:''}${b.last_seen?`<div class="row-sub"><i class="fa-solid fa-location-dot"></i> ${h(b.last_seen)}</div>`:''}<div class="between mt"><span class="muted">${h(b.author)} · ${ago(b.created_at)}</span><button class="btn btn-ghost btn-sm" data-bclose="${b.id}">${h(L('bolo_archive','Archive'))}</button></div></div>`).join(''):emptyState('bullhorn',L('bolo_none_t','No active BOLOs'),L('bolo_none_s','Post a BOLO for a person or vehicle.'))}</div>`);
    $('#new-bolo').onclick = boloModal;
    $$('[data-bclose]').forEach(b=>b.onclick=()=>Modal.confirm(L('bolo_archive_q','Archive this BOLO?'),async()=>{ await call('closeBolo',Number(b.dataset.bclose)); App.open('bolos'); }));
};
function boloModal(){
    const prios = STATE.cfg.priorities||[];
    Modal.open({ title:L('bolo_post_title','Post BOLO'), body:`<div class="field"><label>${h(L('gen_type','Type'))}</label><select id="b-type"><option value="person">${h(L('bolo_person','Person'))}</option><option value="vehicle">${h(L('bolo_vehicle','Vehicle'))}</option></select></div>
        <div class="field"><label>${h(L('bolo_title_label','Title'))}</label><input id="b-title" placeholder="${h(L('bolo_title_ph','Subject / vehicle'))}"></div>
        <div class="field"><label>${h(L('gen_priority','Priority'))}</label><select id="b-prio">${prios.map(p=>`<option value="${p.id}">${h(p.label)}</option>`).join('')}</select></div>
        <div class="field"><label>${h(L('bolo_plate_label','Plate (if vehicle)'))}</label><input id="b-plate"></div>
        <div class="field"><label>${h(L('gen_description','Description'))}</label><textarea id="b-desc"></textarea></div>
        <div class="field"><label>${h(L('bolo_last_seen','Last Seen'))}</label><input id="b-seen" placeholder="${h(L('bolo_last_seen_ph','Location / direction'))}"></div>`,
        footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="b-save">${h(L('bolo_post_btn','Post'))}</button>` });
    $('[data-mclose2]').onclick=Modal.close;
    $('#b-save').onclick=async()=>{ await call('createBolo',{ type:$('#b-type').value, title:$('#b-title').value, priority:$('#b-prio').value, plate:$('#b-plate').value.toUpperCase(), description:$('#b-desc').value, lastSeen:$('#b-seen').value }); Modal.close(); App.open('bolos'); Notify({message:L('notify_saved','Saved.'),type:'success'}); };
}

/* ── CHARGES / sentence calculator ── */
let chargeBasket = [];
Renderers.charges = async () => {
    chargeBasket = [];
    const code = STATE.cfg.penalCode||[];
    const titles = [...new Set(code.map(c=>c.title))];
    render(`<div class="grid" style="grid-template-columns:1fr 320px;gap:16px;height:100%">
        <div class="scrolly"><div class="chips mb" id="charge-cats"><button class="chip active" data-cat="all">${h(L('chg_all','All'))}</button>${titles.map(t=>`<button class="chip" data-cat="${h(t)}">${h(t)}</button>`).join('')}</div><div id="charge-grid" class="grid g-2"></div></div>
        <div><div class="card" style="position:sticky;top:0"><div class="card-h"><h3><i class="fa-solid fa-scale-balanced"></i> ${h(L('chg_sentence','Sentence'))}</h3><button class="btn btn-ghost btn-sm" id="ch-clear">${h(L('ui_reset','Clear'))}</button></div>
            <div class="calc-tot"><div class="ct"><span>${h(L('chg_fine','Fine'))}</span><strong id="ct-fine">$0</strong></div><div class="ct"><span>${h(L('chg_months','Months'))}</span><strong id="ct-months">0</strong></div><div class="ct"><span>${h(L('chg_points','Points'))}</span><strong id="ct-points">0</strong></div></div>
            <div id="ch-basket" class="list" style="max-height:200px;overflow-y:auto"></div>
            <button class="btn btn-primary btn-block mt" id="ch-book"><i class="fa-solid fa-fingerprint"></i> ${h(L('chg_send_booking','Send to Booking'))}</button></div></div>
    </div>`);
    const paint = (cat) => { const grid=$('#charge-grid'); grid.innerHTML = code.filter(c=>cat==='all'||c.title===cat).map(c=>`<div class="charge-card ${chargeBasket.find(x=>x.id===c.id)?'sel':''}" data-charge="${c.id}"><div class="charge-top"><div class="charge-name">${h(c.label)}</div><span class="tag ${c.type}">${c.type[0].toUpperCase()}</span></div><div class="charge-meta"><span>${h(L('chg_fine','Fine'))} <b>${money(c.fine)}</b></span><span>${h(L('chg_jail','Jail'))} <b>${c.jail}mo</b></span>${c.points?`<span>${h(L('chg_pts','Pts'))} <b>${c.points}</b></span>`:''}</div><div class="charge-desc">${h(c.desc)}</div></div>`).join('');
        $$('[data-charge]').forEach(el=>el.onclick=()=>toggleCharge(code.find(c=>c.id===el.dataset.charge))); };
    $$('#charge-cats .chip').forEach(c=>c.onclick=()=>{ $$('#charge-cats .chip').forEach(x=>x.classList.remove('active')); c.classList.add('active'); paint(c.dataset.cat); });
    $('#ch-clear').onclick=()=>{ chargeBasket=[]; paint($('#charge-cats .chip.active').dataset.cat); updateCalc(); };
    $('#ch-book').onclick=bookFromCharges;
    paint('all'); updateCalc();
};
function toggleCharge(c){ if (!c) return; const i=chargeBasket.findIndex(x=>x.id===c.id); if (i>=0) chargeBasket.splice(i,1); else chargeBasket.push(c); const cat=$('#charge-cats .chip.active')?.dataset.cat||'all'; $$('[data-charge]').forEach(el=>el.classList.toggle('sel',!!chargeBasket.find(x=>x.id===el.dataset.charge))); updateCalc(); }
function updateCalc(){
    const fine=chargeBasket.reduce((a,c)=>a+(c.fine||0),0), months=chargeBasket.reduce((a,c)=>a+(c.jail||0),0), pts=chargeBasket.reduce((a,c)=>a+(c.points||0),0);
    if ($('#ct-fine')) $('#ct-fine').textContent=money(fine);
    if ($('#ct-months')) $('#ct-months').textContent=months>900?'LIFE':months;
    if ($('#ct-points')) $('#ct-points').textContent=pts;
    const bk=$('#ch-basket'); if (bk) bk.innerHTML = chargeBasket.length?chargeBasket.map(c=>`<div class="row" style="padding:8px 10px"><div class="row-main"><div class="row-title" style="font-size:12px">${h(c.label)}</div></div><button class="icon-btn" style="width:26px;height:26px" data-rm="${c.id}"><i class="fa-solid fa-xmark"></i></button></div>`).join(''):`<span class="muted">${h(L('chg_select_hint','Select charges to build a sentence.'))}</span>`;
    $$('[data-rm]').forEach(b=>b.onclick=()=>{ chargeBasket=chargeBasket.filter(x=>x.id!==b.dataset.rm); const cat=$('#charge-cats .chip.active')?.dataset.cat||'all'; $$('[data-charge]').forEach(el=>el.classList.toggle('sel',!!chargeBasket.find(x=>x.id===el.dataset.charge))); updateCalc(); });
}
function bookFromCharges(){
    if (!chargeBasket.length) return Notify({message:L('chg_add_one','Add at least one charge.'),type:'warning'});
    const fine=chargeBasket.reduce((a,c)=>a+(c.fine||0),0), months=chargeBasket.reduce((a,c)=>a+(c.jail||0),0);
    Modal.open({ title:L('chg_booking_title','Booking'), body:`${citizenPickerHTML('bk',L('gen_citizen','Citizen'))}
        <div class="calc-tot mt"><div class="ct"><span>${h(L('chg_fine','Fine'))}</span><strong>${money(fine)}</strong></div><div class="ct"><span>${h(L('chg_sentence','Sentence'))}</span><strong>${months>900?'LIFE':months+'mo'}</strong></div></div>`,
        footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="bk-go"><i class="fa-solid fa-handcuffs"></i> ${h(L('chg_book','Book'))}</button>` });
    wireCitizenPicker('bk');
    $('[data-mclose2]').onclick=Modal.close;
    $('#bk-go').onclick=async()=>{ const c=getCitizen('bk'); await call('book',{ citizenName:c.name, citizenId:c.id, charges:chargeBasket.map(x=>({id:x.id,label:x.label})), months, fine }); Modal.close(); chargeBasket=[]; Notify({message:L('chg_booked','Suspect booked.'),type:'success'}); App.open('charges'); };
}
Renderers.booking = Renderers.charges;   // booking shares the charge builder

/* ── CITATIONS ── */
Renderers.citations = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-cit"><i class="fa-solid fa-plus"></i> ${L('ui_create','New Citation')}</button>`);
    const [r]=await call('getCitations'); const list=(r&&r.citations)||[];
    render(`<div class="tableview"><table class="table"><thead><tr><th>${h(L('cit_th_citizen','Citizen'))}</th><th>${h(L('gen_plate','Plate'))}</th><th>${h(L('cit_th_amount','Amount'))}</th><th>${h(L('cit_th_officer','Officer'))}</th><th>${h(L('gen_status','Status'))}</th><th>${h(L('gen_date','Date'))}</th></tr></thead>${list.length?`<tbody>${list.map(c=>`<tr><td>${h(c.citizen_name||'-')}</td><td class="mono">${h(c.plate||'-')}</td><td><b>${money(c.amount)}</b></td><td>${h(c.officer||'')}</td><td>${c.paid?`<span class="ok-text">${h(L('cit_paid','Paid'))}</span>`:`<span class="warn-text">${h(L('cit_unpaid','Unpaid'))}</span>`}</td><td class="muted">${ago(c.created_at)}</td></tr>`).join('')}</tbody>`:''}</table>${list.length?'':emptyState('receipt',L('cit_empty_t','No citations'),L('cit_empty_s','Issue a traffic citation.'))}</div>`);
    $('#new-cit').onclick = () => {
        Modal.open({ title:L('cit_issue_title','Issue Citation'), body:`${citizenPickerHTML('ci',L('gen_citizen','Citizen'))}<div class="field"><label>${h(L('cit_plate_opt','Plate (optional)'))}</label><input id="ci-plate"></div><div class="field"><label>${h(L('gen_reason','Reason'))}</label><input id="ci-reason"></div><div class="field"><label>${h(L('cit_th_amount','Amount'))}</label><input id="ci-amt" type="number" value="500"></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="ci-save">${h(L('cit_issue','Issue'))}</button>` });
        wireCitizenPicker('ci');
        $('[data-mclose2]').onclick = Modal.close;
        $('#ci-save').onclick = async () => { const c=getCitizen('ci'); await call('createCitation',{ citizenName:c.name, citizenId:c.id, plate:$('#ci-plate').value, charges:[{label:$('#ci-reason').value}], amount:$('#ci-amt').value }); Modal.close(); App.open('citations'); };
    };
};

/* ── EVIDENCE ── */
Renderers.evidence = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-ev"><i class="fa-solid fa-plus"></i> ${L('ui_create','Log Evidence')}</button>`);
    const [r]=await call('getEvidence'); const list=(r&&r.evidence)||[];
    render(`<div class="grid g-3">${list.length?list.map(e=>`<div class="card"><div class="between mb"><span class="tag">${h(e.type)}</span><span class="muted">#${e.id}</span></div><div style="font-weight:700">${h(e.label)}</div><div class="muted mb">${h(e.description||'')}</div><div class="row-sub mb">${h(L('evi_case','Case:'))} <b>${h(e.case_ref||'-')}</b> · ${h(e.location||'')}</div><div class="sec-h">${h(L('evi_chain','Chain of Custody'))}</div>${(e.custody||[]).map(c=>`<div class="row-sub">${h(c.by)} - ${h(c.action)} · ${ago(c.at?new Date(c.at*1000).toISOString():null)}</div>`).join('')}<button class="btn btn-ghost btn-sm mt" data-touch="${e.id}"><i class="fa-solid fa-hand"></i> ${h(L('evi_access','Access'))}</button></div>`).join(''):emptyState('box-archive',L('evi_empty_t','No evidence'),L('evi_empty_s','Log the first piece of evidence.'))}</div>`);
    $('#new-ev').onclick=()=>{ const types=STATE.cfg.evidenceTypes||[]; Modal.open({ title:L('evi_log_title','Log Evidence'), body:`<div class="field"><label>${h(L('evi_case_ref','Case Ref'))}</label><input id="ev-case"></div><div class="field"><label>${h(L('gen_type','Type'))}</label><select id="ev-type">${types.map(t=>`<option value="${t.id}">${h(t.label)}</option>`).join('')}</select></div><div class="field"><label>${h(L('evi_label','Label'))}</label><input id="ev-label"></div><div class="field"><label>${h(L('evi_loc_found','Location Found'))}</label><input id="ev-loc"></div><div class="field"><label>${h(L('gen_description','Description'))}</label><textarea id="ev-desc"></textarea></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="ev-save">${h(L('evi_log','Log'))}</button>` }); $('[data-mclose2]').onclick=Modal.close; $('#ev-save').onclick=async()=>{ await call('addEvidence',{ caseRef:$('#ev-case').value, type:$('#ev-type').value, label:$('#ev-label').value, location:$('#ev-loc').value, description:$('#ev-desc').value }); Modal.close(); App.open('evidence'); }; };
    $$('[data-touch]').forEach(b=>b.onclick=async()=>{ await call('touchEvidence',Number(b.dataset.touch),'accessed'); App.open('evidence'); });
};

/* ── TRIAGE (EMS) ── */
Renderers.triage = async () => {
    const triage = STATE.cfg.triage||[], vitals = STATE.cfg.vitals||[], dx = STATE.cfg.diagnoses||[];
    let selTriage=null;
    render(`<div class="card mb"><div class="card-h"><h3><i class="fa-solid fa-heart-pulse"></i> ${h(L('tri_assessment','Triage Assessment'))}</h3></div>
        <div class="field"><label>${h(L('tri_patient','Patient'))}</label><input id="tr-patient" placeholder="${h(L('tri_patient_ph','Patient name / ID'))}"></div>
        <div class="sec-h">${h(L('tri_category','Triage Category'))}</div><div class="triage-grid">${triage.map(t=>`<div class="triage-card" data-tri="${t.id}" style="--_c:${t.color}"><div class="tc-dot"></div><div class="tc-l">${h(t.label)}</div><div class="tc-s">${h(t.desc)}</div></div>`).join('')}</div></div>
        <div class="card mb"><div class="card-h"><h3>${h(L('tri_vitals','Vital Signs'))}</h3></div><div class="vitals-grid">${vitals.map(v=>`<div class="vital" data-vital="${v.id}"><label>${h(v.label)} <span class="unit">${h(v.unit||'')}</span></label><input data-v="${v.id}" ${v.text?'':'inputmode="decimal"'} data-min="${v.min||''}" data-max="${v.max||''}"></div>`).join('')}</div></div>
        <div class="card mb"><div class="card-h"><h3>${h(L('tri_diagnosis','Diagnosis'))}</h3></div><div class="field"><select id="tr-dx">${dx.map(d=>`<option value="${d.id}">${h(d.cat)} · ${h(d.label)}</option>`).join('')}</select></div><div class="field"><label>${h(L('tri_treatment_notes','Treatment / Notes'))}</label><textarea id="tr-notes"></textarea></div></div>
        <div class="between"><button class="btn btn-success" id="tr-treat"><i class="fa-solid fa-kit-medical"></i> ${h(L('tri_treat_patient','Treat Patient'))}</button><button class="btn btn-primary" id="tr-admit"><i class="fa-solid fa-bed"></i> ${h(L('tri_admit','Admit'))}</button></div>`);
    $$('[data-tri]').forEach(c=>c.onclick=()=>{ $$('[data-tri]').forEach(x=>x.classList.remove('sel')); c.classList.add('sel'); selTriage=c.dataset.tri; });
    $$('[data-v]').forEach(inp=>inp.addEventListener('input',()=>{ const mn=parseFloat(inp.dataset.min),mx=parseFloat(inp.dataset.max),val=parseFloat(inp.value); const bad=!isNaN(val)&&((!isNaN(mn)&&val<mn)||(!isNaN(mx)&&val>mx)); inp.closest('.vital').classList.toggle('bad',bad); }));
    const collect = () => { const vit={}; $$('[data-v]').forEach(i=>{ if(i.value) vit[i.dataset.v]=i.value; }); const d=(STATE.cfg.diagnoses||[]).find(x=>x.id===$('#tr-dx').value)||{}; return { patientName:$('#tr-patient').value, triage:selTriage, vitals:vit, diagnosis:d.label, notes:$('#tr-notes').value }; };
    $('#tr-treat').onclick=async()=>{ await call('treatPatient',null,100); Notify({message:L('tri_treated','Patient treated.'),type:'success'}); };
    $('#tr-admit').onclick=()=>{ const data=collect(); admitModal({ name:data.patientName }, data); };
};
function admitModal(patient, pre){
    patient = patient || {}; pre = pre || {};
    const wards = STATE.cfg.wards||[];
    const presetBed = pre.bed != null ? pre.bed : 1;
    Modal.open({ title:L('tri_admit_title','Admit Patient'), body:`${citizenPickerHTML('ad',L('tri_patient','Patient'),'searchPatients')}
        <div class="field-row"><div class="field"><label>${h(L('tri_ward','Ward'))}</label><select id="ad-ward">${wards.map(w=>`<option value="${w.id}" ${pre.ward===w.id?'selected':''}>${h(w.label)}</option>`).join('')}</select></div><div class="field"><label>${h(L('tri_bed_num','Bed #'))}</label><input id="ad-bed" type="number" min="1" value="${h(presetBed)}"></div></div>
        <div class="field"><label>${h(L('tri_diagnosis','Diagnosis'))}</label><input id="ad-dx" value="${h(pre.diagnosis||'')}"></div>
        <div class="field"><label>${h(L('tri_notes','Notes'))}</label><textarea id="ad-notes">${h(pre.notes||'')}</textarea></div>`,
        footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="ad-save"><i class="fa-solid fa-bed"></i> ${h(L('tri_admit','Admit'))}</button>` });
    wireCitizenPicker('ad');
    if (patient.name){ const q=$('#ad-q'); if (q) q.value=patient.name; if ($('#ad-name')) $('#ad-name').value=patient.name; if (patient.id && $('#ad-id')) $('#ad-id').value=patient.id; const box=$('[data-cpick="ad"]'); if (box && patient.id) box.classList.add('picked'); }
    $('[data-mclose2]').onclick=Modal.close;
    $('#ad-save').onclick=async()=>{ const c=getCitizen('ad'); if(!c.name){ Notify({message:L('tri_select_patient','Select or enter a patient.'),type:'warning'}); return; } await call('admitPatient',{ patientId:c.id, patientName:c.name, ward:$('#ad-ward').value, bed:$('#ad-bed').value, diagnosis:$('#ad-dx').value, vitals:pre.vitals||{}, triage:pre.triage, notes:$('#ad-notes').value }); Modal.close(); Notify({message:L('tri_admitted','Patient admitted.'),type:'success'}); if(STATE.activeApp==='beds') Renderers.beds(); };
}

/* ── BEDS ── */
Renderers.beds = async () => {
    tool(`<button class="btn btn-ghost btn-sm" id="beds-refresh"><i class="fa-solid fa-rotate"></i></button>`);
    tool(`<button class="btn btn-primary btn-sm" id="beds-admit"><i class="fa-solid fa-plus"></i> ${h(L('bed_add','Add Bed'))}</button>`);
    const [r]=await call('getBeds'); const occ=(r&&r.occupied)||[];
    const wards = STATE.cfg.wards||[];
    const wLabel = (id)=>(wards.find(w=>w.id===id)||{}).label || id || 'General';
    const wColor = (id)=>(wards.find(w=>w.id===id)||{}).color || 'var(--brand-500)';
    const triColor = (id)=>((STATE.cfg.triage||[]).find(t=>t.id===id)||{}).color || 'var(--text-3)';
    // beds are dynamic: each admission IS a bed. Group by ward (any ward, even custom).
    const groups = {}; occ.forEach(o=>{ const k=o.ward||'general'; (groups[k]=groups[k]||[]).push(o); });
    const wardIds = Object.keys(groups); const total = occ.length;
    const crit = occ.filter(o=>o.triage==='critical'||o.triage==='immediate').length;
    render(`<div class="beds-view">
        <div class="grid g-4 mb">
            <div class="stat"><div class="stat-ic" style="--_c:var(--dept)"><i class="fa-solid fa-bed"></i></div><div class="stat-tx"><strong>${total}</strong><span>${h(L('bed_occupied','Occupied Beds'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--green)"><i class="fa-solid fa-bed-pulse"></i></div><div class="stat-tx"><strong>${total}</strong><span>${h(L('bed_admitted','Admitted'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--red)"><i class="fa-solid fa-heart-pulse"></i></div><div class="stat-tx"><strong>${crit}</strong><span>${h(L('bed_critical','Critical'))}</span></div></div>
            <div class="stat"><div class="stat-ic" style="--_c:var(--purple)"><i class="fa-solid fa-hospital"></i></div><div class="stat-tx"><strong>${wardIds.length}</strong><span>${h(L('bed_active_wards','Active Wards'))}</span></div></div>
        </div>
        ${total ? wardIds.map(wid=>`
            <div class="ward-block"><div class="between mb"><div class="flex"><span class="dot" style="--_c:${wColor(wid)}"></span><strong>${h(wLabel(wid))}</strong></div><span class="muted">${groups[wid].length} bed${groups[wid].length>1?'s':''}</span></div>
                <div class="beds">${groups[wid].map(b=>`<div class="bed occupied" style="--_c:${wColor(wid)}"><div class="bn">BED ${h(b.bed||'-')}</div><div class="bp">${h(b.patient_name||'-')}</div><div class="bf">${h(b.doctor||'')}${b.triage?` · <span class="tri-tag" style="--_c:${triColor(b.triage)}">${h(b.triage)}</span>`:''}</div><button class="btn btn-ghost btn-sm mt" data-disc="${b.id}"><i class="fa-solid fa-right-from-bracket"></i> ${h(L('bed_discharge','Discharge'))}</button></div>`).join('')}
                    <button class="bed bed-add" data-add-ward="${h(wid)}"><i class="fa-solid fa-plus"></i><span>${h(L('bed_add_bed','Add bed'))}</span></button>
                </div></div>`).join('')
            : emptyState('bed',L('bed_empty_t','No occupied beds'),L('bed_empty_s','Press “Add Bed” to admit a patient into any ward and bed number.'))}
    </div>`);
    $('#beds-refresh').onclick = () => Renderers.beds();
    $('#beds-admit').onclick = () => admitModal(null, {});
    $$('[data-disc]').forEach(b=>b.onclick=(e)=>{ e.stopPropagation(); Modal.confirm(L('bed_disc_q','Discharge this patient?'),async()=>{ await call('dischargePatient',Number(b.dataset.disc)); Renderers.beds(); }); });
    $$('[data-add-ward]').forEach(b=>b.onclick=()=>{ const wid=b.dataset.addWard; const used=occ.filter(o=>o.ward===wid).map(o=>Number(o.bed)); let n=1; while(used.includes(n)) n++; admitModal(null,{ ward:wid, bed:n }); });
};

/* ── SURGERY ── */
Renderers.surgery = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-surg"><i class="fa-solid fa-plus"></i> ${h(L('sur_schedule','Schedule'))}</button>`);
    const [r]=await call('getSurgeries'); const list=(r&&r.surgeries)||[];
    render(`<div class="list">${list.length?list.map(s=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid fa-user-doctor"></i></div><div class="row-main"><div class="row-title">${h(s.type)} - ${h(s.patient_name||'')}</div><div class="row-sub">${h(s.status)} ${s.outcome?'· '+h(s.outcome):''}</div></div><div class="row-aside">${s.status!=='done'?`<button class="btn btn-success btn-sm" data-surgdone="${s.id}">${h(L('sur_complete','Complete'))}</button>`:'<span class="pill" style="--_c:var(--green)">done</span>'}</div></div>`).join(''):emptyState('user-doctor',L('sur_empty_t','No surgeries'),L('sur_empty_s','Schedule a procedure.'))}</div>`);
    $('#new-surg').onclick=()=>{ const ops=STATE.cfg.surgeries||[]; Modal.open({ title:L('sur_modal_title','Schedule Surgery'), body:`<div class="field"><label>${h(L('sur_patient','Patient'))}</label><input id="su-name"></div><div class="field"><label>${h(L('sur_procedure','Procedure'))}</label><select id="su-type">${ops.map(o=>`<option value="${o.label}">${h(o.label)} (${o.minutes}min)</option>`).join('')}</select></div><div class="field"><label>${h(L('gen_notes','Notes'))}</label><textarea id="su-notes"></textarea></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="su-save">${h(L('sur_schedule','Schedule'))}</button>` }); $('[data-mclose2]').onclick=Modal.close; $('#su-save').onclick=async()=>{ await call('scheduleSurgery',{ patientName:$('#su-name').value, type:$('#su-type').value, notes:$('#su-notes').value, team:[STATE.officer.name] }); Modal.close(); App.open('surgery'); }; };
    $$('[data-surgdone]').forEach(b=>b.onclick=async()=>{ await call('setSurgeryStatus',Number(b.dataset.surgdone),'done','success'); App.open('surgery'); });
};

/* ── PHARMACY ── */
Renderers.pharmacy = async () => {
    const [r]=await call('getPharmacy'); const stock=(r&&r.stock)||[], rx=(r&&r.prescriptions)||[];
    tool(`<button class="btn btn-primary btn-sm" id="new-rx"><i class="fa-solid fa-plus"></i> ${h(L('pha_prescribe','Prescribe'))}</button>`);
    render(`<div class="grid g-2"><div class="card"><div class="card-h"><h3><i class="fa-solid fa-boxes-stacked"></i> ${h(L('pha_stock','Stock'))}</h3></div><div class="list">${stock.map(m=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid fa-pills"></i></div><div class="row-main"><div class="row-title">${h(m.label)} ${m.controlled?`<span class="tag felony">${h(L('pha_controlled','Controlled'))}</span>`:''}</div></div><strong>${m.stock}</strong></div>`).join('')}</div></div>
        <div class="card"><div class="card-h"><h3>${h(L('pha_pending_rx','Pending Prescriptions'))}</h3></div><div class="list">${rx.length?rx.map(p=>`<div class="row" style="cursor:default"><div class="row-av"><i class="fa-solid fa-prescription"></i></div><div class="row-main"><div class="row-title">${h(p.medication)} ×${p.qty}</div><div class="row-sub">${h(p.patient_name)} · ${h(p.prescriber)}</div></div><button class="btn btn-success btn-sm" data-disp="${p.id}">${h(L('pha_dispense','Dispense'))}</button></div>`).join(''):emptyState('prescription-bottle',L('pha_empty_t','No pending Rx'),'')}</div></div></div>`);
    $('#new-rx').onclick=()=>{ Modal.open({ title:L('pha_modal_title','New Prescription'), body:`${nearbyPickerHTML('rxp',L('sur_patient','Patient'))}<div class="field"><label>${h(L('pha_medication','Medication'))}</label><select id="rx-med">${stock.map(m=>`<option value="${m.id}">${h(m.label)}${m.controlled?' · controlled':''}</option>`).join('')}</select></div><div class="field"><label>${h(L('pha_quantity','Quantity'))}</label><input id="rx-qty" type="number" value="1" min="1"></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="rx-save"><i class="fa-solid fa-prescription"></i> ${h(L('pha_prescribe','Prescribe'))}</button>` }); wireNearbyPicker('rxp'); $('[data-mclose2]').onclick=Modal.close; $('#rx-save').onclick=async()=>{ const c=getCitizen('rxp'); if(!c.name){ Notify({message:'Select or enter a patient.',type:'warning'}); return; } const m=stock.find(x=>x.id===$('#rx-med').value)||{}; await call('prescribe',{ patientName:c.name, patientId:c.id, medication:m.label, qty:$('#rx-qty').value }); Modal.close(); Notify({message:'Prescription issued to '+c.name+'.',type:'success'}); App.open('pharmacy'); }; };
    $$('[data-disp]').forEach(b=>b.onclick=async()=>{ await call('dispense',Number(b.dataset.disp)); App.open('pharmacy'); });
};

/* ── BILLING ── */
Renderers.billing = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-inv"><i class="fa-solid fa-plus"></i> ${h(L('bil_new_invoice','New Invoice'))}</button>`);
    const [r]=await call('getInvoices'); const list=(r&&r.invoices)||[];
    render(`<div class="tableview"><table class="table"><thead><tr><th>${h(L('sur_patient','Patient'))}</th><th>${h(L('bil_items','Items'))}</th><th>${h(L('bil_total','Total'))}</th><th>${h(L('bil_insurance','Insurance'))}</th><th>${h(L('gen_status','Status'))}</th><th>${h(L('bil_issued','Issued'))}</th></tr></thead>${list.length?`<tbody>${list.map(i=>`<tr><td>${h(i.citizen_name||'-')}</td><td class="muted">${(i.items||[]).map(x=>h(x.label)).join(', ')}</td><td><b>${money(i.total)}</b></td><td>${i.insurance?h(L('bil_yes','Yes')):h(L('bil_no','No'))}</td><td>${i.status==='paid'?`<span class="ok-text">${h(L('bil_paid','Paid'))}</span>`:`<span class="warn-text">${h(L('bil_unpaid','Unpaid'))}</span>`}</td><td class="muted">${ago(i.created_at)}</td></tr>`).join('')}</tbody>`:''}</table>${list.length?'':emptyState('file-invoice-dollar',L('bil_empty_t','No invoices'),L('bil_empty_s','Bill a patient for services.'))}</div>`);
    $('#new-inv').onclick=()=>{ const prices=(STATE.cfg.billing?.ems)||[]; let basket=[]; Modal.open({ title:L('bil_new_invoice','New Invoice'), body:`${nearbyPickerHTML('ivp',L('sur_patient','Patient'))}<div class="sec-h">${h(L('bil_services','Services'))}</div><div class="chips" id="iv-services">${prices.map(p=>`<button class="chip" data-svc="${p.id}">${h(p.label)} · ${money(p.amount)}</button>`).join('')}</div><div class="toggle-row mt"><span class="tr-l">${h(L('bil_has_insurance','Has insurance'))}</span><div class="switch" id="iv-ins"></div></div><div class="calc-tot mt"><div class="ct"><span>${h(L('bil_total','Total'))}</span><strong id="iv-total">$0</strong></div></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="iv-save">${h(L('bil_send_invoice','Send Invoice'))}</button>` });
        wireNearbyPicker('ivp');
        const recalc=()=>{ const t=basket.reduce((a,id)=>a+(prices.find(p=>p.id===id)?.amount||0),0); $('#iv-total').textContent=money($('#iv-ins').classList.contains('on')?Math.floor(t*(1-(STATE.cfg.billing?.insuranceCoverPct||0))):t); };
        $$('[data-svc]').forEach(b=>b.onclick=()=>{ const id=b.dataset.svc; if(basket.includes(id)){basket=basket.filter(x=>x!==id);b.classList.remove('active');}else{basket.push(id);b.classList.add('active');} recalc(); });
        $('#iv-ins').onclick=()=>{ $('#iv-ins').classList.toggle('on'); recalc(); };
        $('[data-mclose2]').onclick=Modal.close; $('#iv-save').onclick=async()=>{ const c=getCitizen('ivp'); if(!c.name){ Notify({message:'Select or enter a patient.',type:'warning'}); return; } const items=basket.map(id=>prices.find(p=>p.id===id)); const total=items.reduce((a,p)=>a+(p?.amount||0),0); await call('createInvoice',{ citizenName:c.name, citizenId:c.id, items:items.map(p=>({label:p.label,amount:p.amount})), total, insurance:$('#iv-ins').classList.contains('on') }); Modal.close(); App.open('billing'); }; };
};

/* ── MORGUE / DEATHS ── */
Renderers.morgue = async () => {
    tool(`<button class="btn btn-primary btn-sm" id="new-death"><i class="fa-solid fa-plus"></i> ${h(L('mor_record_death','Record Death'))}</button>`);
    const [r]=await call('getDeaths'); const list=(r&&r.deaths)||[];
    render(`<div class="list">${list.length?list.map(d=>`<div class="row" style="cursor:default"><div class="row-av" style="background:var(--surface-3)"><i class="fa-solid fa-skull"></i></div><div class="row-main"><div class="row-title">${h(d.citizen_name||'Unknown')}</div><div class="row-sub">${h(d.cause||'')} · ${h(d.examiner||'')} ${d.shared_police?`· <span class="warn-text">${h(L('mor_shared_pd','shared with PD'))}</span>`:''}</div></div><span class="muted">${ago(d.time_of_death)}</span></div>`).join(''):emptyState('skull',L('mor_empty_t','No records'),L('mor_empty_s','Record deaths and autopsies here.'))}</div>`);
    $('#new-death').onclick=()=>{ Modal.open({ title:L('mor_modal_title','Record Death'), body:`${citizenPickerHTML('dt',L('mor_deceased','Deceased'))}<div class="field"><label>${h(L('mor_cause_of_death','Cause of Death'))}</label><input id="dt-cause"></div><div class="field"><label>${h(L('mor_autopsy_notes','Autopsy / Notes'))}</label><textarea id="dt-autopsy"></textarea></div><div class="toggle-row"><span class="tr-l">${h(L('mor_share_police','Share with Police'))}</span><div class="switch" id="dt-share"></div></div>`, footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="dt-save">${h(L('mor_record','Record'))}</button>` }); wireCitizenPicker('dt'); $('#dt-share').onclick=()=>$('#dt-share').classList.toggle('on'); $('[data-mclose2]').onclick=Modal.close; $('#dt-save').onclick=async()=>{ const c=getCitizen('dt'); await call('recordDeath',{ citizenName:c.name, citizenId:c.id, cause:$('#dt-cause').value, autopsy:$('#dt-autopsy').value, sharePolice:$('#dt-share').classList.contains('on') }); Modal.close(); App.open('morgue'); }; };
};

/* ── ROSTER ── */
Renderers.roster = async () => {
    const [r]=await call('getRoster'); const roster=(r&&r.roster)||[], onDuty=(r&&r.onDuty)||[];
    const onSet = new Set(onDuty.map(u=>u.id||u.callsign).filter(Boolean));
    render(`<div class="grid g-4 mb">
        <div class="stat"><div class="stat-ic" style="--_c:var(--green)"><i class="fa-solid fa-user-check"></i></div><div class="stat-tx"><strong>${onDuty.length}</strong><span>${h(L('ui_on_duty','On Duty'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--brand-500)"><i class="fa-solid fa-users"></i></div><div class="stat-tx"><strong>${roster.length}</strong><span>${h(L('ros_total_members','Total Members'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--yellow)"><i class="fa-solid fa-star"></i></div><div class="stat-tx"><strong>${roster.reduce((a,m)=>a+((m.stats&&(m.stats.arrests||m.stats.patients))||0),0)}</strong><span>${STATE.mode==='ems'?h(L('ros_patients','Patients')):h(L('ros_arrests','Arrests'))}</span></div></div>
        <div class="stat"><div class="stat-ic" style="--_c:var(--purple)"><i class="fa-solid fa-file-lines"></i></div><div class="stat-tx"><strong>${roster.reduce((a,m)=>a+((m.stats&&m.stats.reports)||0),0)}</strong><span>${h(L('ros_reports','Reports'))}</span></div></div></div>
        <table class="table"><thead><tr><th>${h(L('ros_member','Member'))}</th><th>${h(L('ros_callsign','Callsign'))}</th><th>${h(L('ros_division','Division'))}</th><th>${STATE.mode==='ems'?h(L('ros_patients','Patients')):h(L('ros_arrests','Arrests'))}</th><th>${h(L('ros_reports','Reports'))}</th><th>${h(L('gen_status','Status'))}</th></tr></thead><tbody>
        ${roster.length?roster.map(m=>{ const on=onSet.has(m.identifier)||onSet.has(m.callsign); const st=m.stats||{}; return `<tr><td>${h(m.identifier?.slice(-6)||'-')}</td><td class="mono">${h(m.callsign||'-')}</td><td>${h(m.division||'-')}</td><td>${STATE.mode==='ems'?(st.patients||0):(st.arrests||0)}</td><td>${st.reports||0}</td><td>${on?`<span class="pill" style="--_c:var(--green)">${h(L('ui_on_duty','On Duty'))}</span>`:`<span class="muted">${h(L('ros_off','Off'))}</span>`}</td></tr>`; }).join(''):`<tr><td colspan="6">${emptyState('users',L('ros_empty_t','Empty roster'),L('ros_empty_s','Members appear after they use the MDT.'))}</td></tr>`}</tbody></table>`);
};

/* ── COMMS ── */
let commsChannel = 'general';
Renderers.comms = async () => {
    const own = STATE.mode==='ems' ? ['general','dispatch','surgery','admin'] : ['general','dispatch','detectives','swat','admin'];
    const channels = [...own, 'interagency'];
    const chMeta = (c) => c==='interagency' ? { icon:'fa-tower-cell', label:L('cms_interagency','Interagency'), cross:true } : { icon:'fa-hashtag', label:c };
    render(`<div class="grid" style="grid-template-columns:180px 1fr;gap:16px;height:100%">
        <div class="list">${channels.map(c=>{const me=chMeta(c);return `<div class="row ${c===commsChannel?'active':''}" data-chan="${c}" style="padding:9px 12px"><i class="fa-solid ${me.icon}" style="color:${me.cross?'var(--yellow)':'var(--text-4)'}"></i><div class="row-main"><div class="row-title">${h(me.label)}</div>${me.cross?`<div class="row-sub">${h(L('cms_all_departments','All departments'))}</div>`:''}</div></div>`;}).join('')}</div>
        <div class="card" style="display:flex;flex-direction:column"><div class="card-h"><h3><i class="fa-solid fa-hashtag"></i> <span id="chan-name">${h(commsChannel)}</span></h3></div>
            <div id="msg-list" class="scrolly" style="flex:1;display:flex;flex-direction:column;gap:8px"></div>
            <div class="flex mt"><button class="btn btn-ghost" id="msg-photo" title="${h(L('cms_photo_title','Take & send photo'))}"><i class="fa-solid fa-camera"></i></button><input id="msg-input" class="field" style="flex:1;margin:0;background:var(--surface-2);border:1px solid var(--line-2);border-radius:var(--r-2);padding:9px 12px" placeholder="${h(L('cms_msg_placeholder','Message'))} #${h(commsChannel)}…"><button class="btn btn-primary" id="msg-send"><i class="fa-solid fa-paper-plane"></i></button></div>
        </div></div>`);
    const loadMsgs = async () => { const [r]=await call('getMessages',commsChannel); const msgs=((r&&r.messages)||[]).reverse(); $('#msg-list').innerHTML = msgs.length?msgs.map(m=>{return `<div class="feed-row" style="align-items:flex-start"><div class="fr-ic" style="overflow:hidden"><img src="${h(avatarUrl(STATE.officer.avatar))}" style="width:100%;height:100%;object-fit:cover" onerror="this.remove()"></div><div class="fr-tx">${m.dept?`<span class="tag" style="margin-right:5px">${h(m.dept)}</span>`:''}<b>${h(m.author)}</b> ${m.body?h(m.body):''}${m.image?`<img class="msg-img" src="${h(m.image)}">`:''}</div><div class="fr-time">${ago(m.created_at)}</div></div>`;}).join(''):emptyState('comments',L('cms_empty_t','No messages'),L('cms_empty_s','Start the conversation.')); $('#msg-list').scrollTop=$('#msg-list').scrollHeight; };
    $$('[data-chan]').forEach(c=>c.onclick=()=>{ commsChannel=c.dataset.chan; Renderers.comms(); });
    const send = async () => { const v=$('#msg-input').value.trim(); if(!v) return; $('#msg-input').value=''; await call('sendMessage',commsChannel,v); loadMsgs(); };
    $('#msg-send').onclick=send;
    $('#msg-photo').onclick=()=>requestPhoto({ purpose:'chat' });
    $('#msg-input').addEventListener('keydown',e=>{ if(e.key==='Enter') send(); });
    loadMsgs();
};

/* ── STATS ── */
Renderers.stats = async () => {
    const [s]=await call('getStats'); const d=s||{};
    const tiles = STATE.mode==='police'
        ? [['fa-file-lines',L('stats_reports','Reports'),d.reports,'var(--brand-500)'],['fa-handcuffs',L('stats_arrests','Arrests'),d.arrests,'var(--red)'],['fa-gavel',L('stats_warrants','Warrants'),d.warrants,'var(--orange)'],['fa-receipt',L('stats_citations','Citations'),d.citations,'var(--yellow)']]
        : [['fa-bed',L('stats_admissions','Admissions'),d.admissions,'var(--brand-500)'],['fa-user-doctor',L('stats_surgeries','Surgeries'),d.surgeries,'var(--purple)'],['fa-skull',L('stats_deaths','Deaths'),d.deaths,'var(--text-3)'],['fa-file-invoice-dollar',L('stats_unpaid','Unpaid'),d.invoices,'var(--yellow)']];
    render(`<div class="grid g-4 mb">${tiles.map(t=>`<div class="stat"><div class="stat-ic" style="--_c:${t[3]}"><i class="fa-solid ${t[0]}"></i></div><div class="stat-tx"><strong>${t[2]||0}</strong><span>${t[1]}</span></div></div>`).join('')}</div>
        <div class="card"><div class="card-h"><h3><i class="fa-solid fa-chart-column"></i> ${h(L('stats_last_7_days','Last 7 Days'))}</h3></div><svg class="chart" id="stat-chart"></svg></div>`);
    drawChart((d.daily||[]));
};
function drawChart(rows){
    const svg=$('#stat-chart'); if(!svg) return; const W=svg.clientWidth||600,H=170; svg.setAttribute('viewBox',`0 0 ${W} ${H}`); svg.innerHTML='';
    if(!rows.length){ svg.innerHTML=`<text x="${W/2}" y="${H/2}" fill="var(--text-4)" text-anchor="middle" font-size="12">${h(L('stats_no_data','No data yet'))}</text>`; return; }
    const max=Math.max(1,...rows.map(r=>r.n||0)); const bw=W/rows.length*0.6, gap=W/rows.length;
    rows.forEach((r,i)=>{ const bh=(r.n/max)*(H-40); const x=i*gap+(gap-bw)/2, y=H-30-bh;
        svg.innerHTML+=`<rect class="chart-bar" x="${x}" y="${y}" width="${bw}" height="${bh}" rx="3"></rect><text x="${x+bw/2}" y="${H-12}" fill="var(--text-4)" font-size="9" text-anchor="middle">${String(r.d||'').slice(5)}</text><text x="${x+bw/2}" y="${y-4}" fill="var(--text-2)" font-size="10" text-anchor="middle" font-weight="700">${r.n}</text>`; });
}

/* ── AUDIT ── */
Renderers.audit = async () => {
    const [r]=await call('getAudit');
    if (r&&r.denied){ render(emptyState('lock',L('aud_denied_t','Supervisors only'),L('aud_denied_s','You need a supervisor rank to view the audit log.'))); return; }
    const list=(r&&r.audit)||[];
    render(`<div class="tableview"><table class="table"><thead><tr><th>${h(L('aud_officer','Officer'))}</th><th>${h(L('aud_action','Action'))}</th><th>${h(L('aud_detail','Detail'))}</th><th>${h(L('aud_when','When'))}</th></tr></thead>${list.length?`<tbody>${list.map(a=>`<tr><td>${h(a.actor_name||'-')}</td><td><span class="tag">${h(a.action)}</span></td><td class="muted">${h(a.detail||'')}</td><td class="muted">${ago(a.created_at)}</td></tr>`).join('')}</tbody>`:''}</table>${list.length?'':emptyState('clipboard-list',L('aud_empty_t','No audit entries'),'')}</div>`);
};

/* ── MY PROFILE (officer/medic ID + quick actions) ── */
Renderers.profile = async () => {
    const o = STATE.officer, ems = STATE.mode === 'ems';
    const st = o.stats || {};
    const fmtDuty = (s) => { s = Math.max(0, Math.round(Number(s||0))); const hh = Math.floor(s/3600), mm = Math.floor((s%3600)/60); return hh>0 ? `${hh}h ${mm}m` : `${mm}m`; };
    const recTiles = ems
        ? [['fa-hourglass-half',fmtDuty(o.dutySeconds),L('ui_on_duty','On Duty'),'var(--dept)'],['fa-bed-pulse',st.patients||0,L('pf_patients','Patients'),'var(--green)'],['fa-user-doctor',st.surgeries||0,L('stats_surgeries','Surgeries'),'var(--purple)'],['fa-file-lines',st.reports||0,L('stats_reports','Reports'),'var(--brand-400)']]
        : [['fa-hourglass-half',fmtDuty(o.dutySeconds),L('ui_on_duty','On Duty'),'var(--dept)'],['fa-handcuffs',st.arrests||0,L('stats_arrests','Arrests'),'var(--red)'],['fa-receipt',st.citations||0,L('stats_citations','Citations'),'var(--yellow)'],['fa-file-lines',st.reports||0,L('stats_reports','Reports'),'var(--brand-400)']];
    render(`
      <div class="grid" style="grid-template-columns:340px 1fr;gap:18px;align-items:start">
        <div class="card id-card" style="--idc:${o.deptColor||'var(--brand-500)'}">
          <div class="idc-top"><span class="idc-dept">${h(o.jobShort||'')}</span><span class="idc-tag">${ems?h(L('pf_medical_id','MEDICAL ID')):h(L('pf_officer_id','OFFICER ID'))}</span></div>
          <div class="idc-photo"><span id="ro2-ini">${initials(o.name)}</span><img id="ro2-img" alt="" hidden></div>
          <div class="idc-name">${h(o.name||'')}</div>
          <div class="idc-rank">${h(o.rank||'')}</div>
          <div class="idc-cs mono">${h(o.callsign||'')}</div>
          <button class="btn btn-ghost btn-block mt" id="pf-photo"><i class="fa-solid fa-camera"></i> ${h(L('pf_retake_photo','Retake Photo'))}</button>
        </div>
        <div>
          <div class="card mb"><div class="card-h"><h3><i class="fa-solid fa-clock"></i> ${h(L('pf_service_record','Service Record'))}</h3><span class="muted">${ems?h(L('pf_medical','Medical')):h(L('pf_tactical','Tactical'))} ${h(L('pf_service','service'))}</span></div>
            <div class="grid g-4" style="gap:10px">${recTiles.map(t=>`<div class="stat"><div class="stat-ic" style="--_c:${t[3]}"><i class="fa-solid ${t[0]}"></i></div><div class="stat-tx"><strong>${t[1]}</strong><span>${t[2]}</span></div></div>`).join('')}</div>
          </div>
          <div class="card mb"><div class="card-h"><h3><i class="fa-solid fa-address-card"></i> ${h(L('pf_profile','Profile'))}</h3><button class="btn btn-primary btn-sm" id="pf-edit"><i class="fa-solid fa-pen"></i> ${h(L('ui_edit','Edit'))}</button></div>
            <div class="kv">
              <div class="kv-item"><span>${h(L('pf_department','Department'))}</span><strong>${h(o.jobLabel||'')}</strong></div>
              <div class="kv-item"><span>${h(L('pf_rank','Rank'))}</span><strong>${h(o.rank||'')}</strong></div>
              <div class="kv-item"><span>${h(L('pf_callsign','Callsign'))}</span><strong class="mono">${h(o.callsign||'-')}</strong></div>
              <div class="kv-item"><span>${h(L('pf_division','Division'))}</span><strong>${h(o.division||'-')}</strong></div>
              <div class="kv-item"><span>${h(L('pf_fingerprint_id','Fingerprint ID'))}</span><strong class="mono">${h(o.fingerprint||'-')}</strong></div>
              ${ems?`<div class="kv-item"><span>${h(L('pf_blood_type','Blood Type'))}</span><strong>${h(o.blood||'-')}</strong></div>`:''}
              <div class="kv-item"><span>${h(L('gen_phone','Phone'))}</span><strong>${h(o.phone||'-')}</strong></div>
              <div class="kv-item"><span>${h(L('gen_status','Status'))}</span><strong style="color:${STATE.duty?'var(--green)':'var(--text-3)'}">${STATE.duty?h(L('ui_on_duty','On Duty')):h(L('ui_off_duty','Off Duty'))}</strong></div>
            </div>
          </div>
          <div class="card"><div class="card-h"><h3><i class="fa-solid fa-sliders"></i> ${h(L('pf_quick_actions','Quick Actions'))}</h3></div>
            <div class="wrap">
              <button class="btn btn-ghost" id="pf-status"><i class="fa-solid fa-tower-broadcast"></i> ${h(L('pf_set_status','Set Status'))}</button>
              <button class="btn btn-ghost" id="pf-duty"><i class="fa-solid fa-power-off"></i> ${h(L('pf_toggle_duty','Toggle Duty'))}</button>
              <button class="btn btn-ghost" id="pf-settings"><i class="fa-solid fa-gear"></i> ${h(L('pf_ui_settings','UI Settings'))}</button>
            </div>
          </div>
        </div>
      </div>`);
    applyAvatar('#ro2-img', '#ro2-ini', o.avatar);
    $('#pf-photo').onclick = () => { requestPhoto(); setTimeout(() => applyAvatar('#ro2-img','#ro2-ini', STATE.officer.avatar), 900); };
    $('#pf-duty').onclick = () => post('toggle_duty');
    $('#pf-settings').onclick = () => App.open('settings_overlay');
    $('#pf-status').onclick = () => $('#sb-status-chip').click();
    $('#pf-edit').onclick = editProfileModal;
};
function editProfileModal(){
    const o = STATE.officer, ems = STATE.mode === 'ems', divs = o.divisionList || [], bloods = o.bloodTypes || [];
    Modal.open({ title:L('pf_edit_profile_title','Edit Profile'), body:`
      <div class="field"><label>${h(L('pf_callsign','Callsign'))}</label><input id="ep-cs" value="${h(o.callsign||'')}"></div>
      <div class="field"><label>${h(L('pf_division','Division'))}</label><select id="ep-div"><option value="">- ${h(L('gen_none','None'))} -</option>${divs.map(d=>`<option ${o.division===d?'selected':''}>${h(d)}</option>`).join('')}</select></div>
      ${ems?`<div class="field"><label>${h(L('pf_blood_type','Blood Type'))}</label><select id="ep-blood"><option value="">- ${h(L('pf_unknown','Unknown'))} -</option>${bloods.map(b=>`<option ${o.blood===b?'selected':''}>${h(b)}</option>`).join('')}</select></div>`:''}
      <div class="field"><label>${h(L('gen_phone','Phone'))}</label><input id="ep-phone" value="${h(o.phone||'')}"></div>`,
      footer:`<button class="btn btn-ghost" data-mclose2>${h(L('ui_cancel','Cancel'))}</button><button class="btn btn-primary" id="ep-save">${h(L('ui_save','Save'))}</button>` });
    $('[data-mclose2]').onclick = Modal.close;
    $('#ep-save').onclick = async () => {
        const [ok, saved] = await call('updateProfile', { callsign:$('#ep-cs').value, division:$('#ep-div').value, blood:$('#ep-blood')?.value, phone:$('#ep-phone').value });
        if (ok && saved) Object.assign(STATE.officer, saved);
        Modal.close(); applyOfficerChrome(); App.open('profile'); Notify({ message:L('notify_saved','Saved.'), type:'success' });
    };
}

Renderers.scaffold = async (a) => render(emptyState(a.icon, appLabel(a), L('pf_scaffold_s','This module is enabled. Configure it in Config.features.')));

/* ── COURT - docket built from warrants/charges ── */
Renderers.court = async () => {
    const [r] = await call('getWarrants'); const w = (r && r.warrants) || [];
    render(`<div class="card"><div class="card-h"><h3><i class="fa-solid fa-landmark"></i> ${h(L('crt_court_docket','Court Docket'))}</h3><span class="muted">${w.length} ${h(w.length===1?L('crt_case','case'):L('crt_cases','cases'))}</span></div>
        <table class="table"><thead><tr><th>${h(L('crt_defendant','Defendant'))}</th><th>${h(L('gen_type','Type'))}</th><th>${h(L('crt_charge_reason','Charge / Reason'))}</th><th>${h(L('gen_status','Status'))}</th><th>${h(L('crt_filed','Filed'))}</th></tr></thead><tbody>
        ${w.length ? w.map(x=>`<tr><td>${h(x.citizen_name||'-')}</td><td><span class="tag">${h(x.type)}</span></td><td class="muted">${h(x.reason||'')}</td><td><span class="pill" style="--_c:${x.status==='active'?'var(--red)':x.status==='executed'?'var(--green)':'var(--text-3)'}">${h(x.status)}</span></td><td class="muted">${ago(x.created_at)}</td></tr>`).join('') : `<tr><td colspan="5">${emptyState('landmark',L('crt_empty_t','No cases on the docket'),L('crt_empty_s','Warrants and charges appear here as cases.'))}</td></tr>`}
        </tbody></table></div>`);
};

/* ── BLOOD BANK - inventory + interagency request ── */
Renderers.bloodbank = async () => {
    const types = STATE.cfg.bloodTypes || [];
    render(`<div class="card mb"><div class="card-h"><h3><i class="fa-solid fa-droplet"></i> ${h(L('bb_blood_bank','Blood Bank'))}</h3><span class="muted">${h(L('bb_current_inventory','Current inventory'))}</span></div>
        <div class="grid g-4">${types.map((t,i)=>{ const u=6+((i*37)%32), low=u<12; return `<div class="stat"><div class="stat-ic" style="--_c:${low?'var(--red)':'var(--cyan)'}"><i class="fa-solid fa-droplet"></i></div><div class="stat-tx"><strong>${u}</strong><span>${h(t)}${low?' · '+h(L('bb_low','LOW')):''}</span></div></div>`; }).join('')}</div></div>
        <div class="card"><div class="card-h"><h3>${h(L('bb_request_units','Request Units'))}</h3></div>
            <div class="field-row"><div class="field"><label>${h(L('gen_type','Type'))}</label><select id="bb-type">${types.map(t=>`<option>${h(t)}</option>`).join('')}</select></div><div class="field"><label>${h(L('bb_units','Units'))}</label><input id="bb-qty" type="number" value="2" min="1"></div></div>
            <button class="btn btn-primary" id="bb-req"><i class="fa-solid fa-truck-medical"></i> ${h(L('bb_request_interagency','Request via Interagency'))}</button></div>`);
    $('#bb-req').onclick = async () => { await call('sendMessage','interagency',`🩸 Blood request: ${$('#bb-qty').value}× ${$('#bb-type').value}`); Notify({ message:L('bb_notify_sent','Request sent to interagency channel.'), type:'success' }); };
};

/* ── TELEMEDICINE - remote consult request ── */
Renderers.telemed = async () => {
    render(`<div class="card"><div class="card-h"><h3><i class="fa-solid fa-video"></i> ${h(L('tel_telemedicine','Telemedicine'))}</h3><span class="muted">${h(L('tel_remote_consult','Remote consult'))}</span></div>
        <p class="muted mb">${h(L('tel_intro','Request a remote consultation. It is broadcast on the interagency channel for any available specialist.'))}</p>
        <div class="field"><label>${h(L('tel_patient_subject','Patient / Subject'))}</label><input id="tm-pt"></div>
        <div class="field"><label>${h(L('tel_specialty','Specialty'))}</label><select id="tm-spec"><option>${h(L('tel_spec_general','General'))}</option><option>${h(L('tel_spec_surgery','Surgery'))}</option><option>${h(L('tel_spec_psychiatry','Psychiatry'))}</option><option>${h(L('tel_spec_toxicology','Toxicology'))}</option><option>${h(L('tel_spec_forensics','Forensics'))}</option></select></div>
        <div class="field"><label>${h(L('gen_notes','Notes'))}</label><textarea id="tm-notes"></textarea></div>
        <button class="btn btn-primary" id="tm-send"><i class="fa-solid fa-paper-plane"></i> ${h(L('tel_request_consult','Request Consult'))}</button></div>`);
    $('#tm-send').onclick = async () => { await call('sendMessage','interagency',`📹 Telemed [${$('#tm-spec').value}] for ${$('#tm-pt').value}: ${$('#tm-notes').value}`); Notify({ message:L('tel_notify_requested','Consultation requested.'), type:'success' }); };
};

/* ── CCTV - camera picker; selecting a feed opens it LIVE, FULL-SCREEN over
      the game (outside the tablet), with REC HUD + pan/tilt/zoom controls.
      The tablet hides while watching and returns on Esc. ── */
Renderers.cctv = async () => {
    const cc = STATE.cfg.cctv || {};
    const cams = (cc.enabled && cc.cameras) || [];
    if (!cams.length){
        render(emptyState('video-slash',L('cctv_no_cameras_t','No cameras'),L('cctv_no_cameras_s','Add cameras in Config.cctv.cameras.')));
        return;
    }
    // mirror the fullscreen viewer's mode filter (CCTV.Open builds list by mode)
    const filtered = cams.filter(c => !c.mode || c.mode === STATE.mode || c.mode === 'both');
    const shown = filtered.length ? filtered : cams;
    render(`<div class="cctv-hub">
        <div class="cctv-hub-bar">
            <span class="map-live"><span class="rec-dot" style="background:#ff3b3b;box-shadow:0 0 8px #ff3b3b"></span> ${shown.length} ${h(shown.length===1?L('cctv_camera_online','CAMERA ONLINE'):L('cctv_cameras_online','CAMERAS ONLINE'))}</span>
            <span class="muted"><i class="fa-solid fa-circle-info"></i> ${h(L('cctv_select_hint','Select a feed to open it live, full-screen'))}</span>
        </div>
        <div class="grid cctv-grid">${shown.map(c=>`
            <button class="card cctv-card" data-cam="${h(c.id)}" title="${h(L('cctv_open_prefix','Open'))} ${h(c.label)} ${h(L('cctv_open_suffix','live'))}">
                <div class="cctv-thumb">
                    <i class="fa-solid fa-video"></i>
                    <span class="cctv-live"><span class="rec-dot"></span> ${h(L('cctv_live','LIVE'))}</span>
                    <span class="cctv-scan2"></span>
                    <span class="cctv-expand"><i class="fa-solid fa-up-right-and-down-left-from-center"></i></span>
                </div>
                <div class="cctv-cap"><strong>${h(c.label)}</strong><span class="muted">${h(c.area||L('cctv_secure_feed','Secure feed'))}</span></div>
            </button>`).join('')}</div>
    </div>`);
    $$('.cctv-card[data-cam]').forEach(b => b.onclick = () => { post('play_sound',{ alias:'tap' }); post('cctv_open', { id: b.dataset.cam }); });
};

/* ── BODYCAM - install, activate, view live feeds ── */
Renderers.bodycam = async () => {
    const [st] = await call('bodycamStatus'); const status = st || {};
    if (!status.installed) {
        render(`<div class="card" style="text-align:center;max-width:460px;margin:8px auto 0">
            <div class="card-h" style="justify-content:center"><h3><i class="fa-solid fa-camera"></i> ${h(L('bc_bodycam','Bodycam'))}</h3></div>
            <div class="bc-big"><i class="fa-solid fa-camera"></i></div>
            <div class="bc-state"><span class="muted">${h(L('bc_not_installed','Not installed'))}</span></div>
            <p class="muted mb">${h(L('bc_install_intro','Install a bodycam on your uniform. Once installed you can record and let other units view your live feed.'))}</p>
            <button class="btn btn-primary btn-block" id="bc-install"><i class="fa-solid fa-download"></i> ${h(L('bc_install_bodycam','Install Bodycam'))}</button>
        </div>`);
        $('#bc-install').onclick = async () => { await call('bodycamInstall'); Notify({ message:L('bc_notify_installed','Bodycam installed.'), type:'success' }); App.open('bodycam'); };
        return;
    }
    const on = STATE.bodycam === true || status.active === true; STATE.bodycam = on;
    const [fr] = await call('bodycamList'); const feeds = (fr && fr.feeds) || [];
    render(`<div class="grid g-2 bc-grid">
        <div class="card bc-card" style="text-align:center">
            <div class="card-h" style="justify-content:center"><h3><i class="fa-solid fa-camera"></i> ${h(L('bc_my_bodycam','My Bodycam'))}</h3></div>
            <div class="bc-center">
                <div class="bc-big ${on?'on':''}"><i class="fa-solid fa-camera"></i></div>
                <div class="bc-state">${on?'<span class="danger-text"><span class="rec-dot" style="display:inline-block;vertical-align:middle"></span> '+h(L('bc_recording','RECORDING'))+'</span>':'<span class="muted">'+h(L('bc_standby','Standby'))+'</span>'}</div>
                <p class="muted mb">${h(L('bc_active_intro','When active, other units can watch your live feed. The REC overlay stays on screen even with the tablet closed.'))}</p>
                <button class="btn ${on?'btn-danger':'btn-primary'} btn-block" id="bc-toggle"><i class="fa-solid fa-power-off"></i> ${on?h(L('bc_stop_recording','Stop Recording')):h(L('bc_start_recording','Start Recording'))}</button>
            </div>
        </div>
        <div class="card bc-card"><div class="card-h"><h3><i class="fa-solid fa-tower-broadcast"></i> ${h(L('bc_live_feeds','Live Feeds'))}</h3><span class="muted">${feeds.length}</span></div>
            <div class="list">${feeds.length ? feeds.slice().sort((a,b)=>(b.self?1:0)-(a.self?1:0)).map(f=> f.self
                ? `<div class="row feed-self" style="cursor:default"><div class="row-av"><span class="rec-dot"></span></div><div class="row-main"><div class="row-title">${h(f.callsign||f.name)} <span class="feed-you">${h(L('bc_you','YOU'))}</span></div><div class="row-sub">${h(f.name)} · ${h(L('bc_broadcasting_live','broadcasting live'))}</div></div><i class="fa-solid fa-tower-broadcast" style="color:var(--brand-300)"></i></div>`
                : `<div class="row" data-feed="${f.serverId}"><div class="row-av"><span class="rec-dot"></span></div><div class="row-main"><div class="row-title">${h(f.callsign||f.name)}</div><div class="row-sub">${h(f.name)} · ${h(L('bc_live_lc','live'))}</div></div><i class="fa-solid fa-eye" style="color:var(--text-4)"></i></div>`
            ).join('') : emptyState('video',L('bc_empty_t','No live feeds'),L('bc_empty_s','Start recording or wait for a unit to go live.'))}</div>
        </div>
    </div>`);
    $('#bc-toggle').onclick = () => post('bodycam_toggle');
    $$('[data-feed]').forEach(b=>b.onclick=()=>post('bodycam_view',{ serverId:Number(b.dataset.feed) }));
};

/* ── overlay clocks (CCTV + bodycam timestamps) ── */
let _cctvClock = null, _bcClock = null;
const _tick = (sel) => { const el = $(sel); if (el) el.textContent = new Date().toLocaleTimeString('en-GB'); };
function startCctvClock(){ stopCctvClock(); _tick('#cctv-time'); _cctvClock = setInterval(() => _tick('#cctv-time'), 1000); }
function stopCctvClock(){ if (_cctvClock) clearInterval(_cctvClock); _cctvClock = null; }
function startBcClock(){ stopBcClock(); _tick('#bc-time'); _bcClock = setInterval(() => _tick('#bc-time'), 1000); }
function stopBcClock(){ if (_bcClock) clearInterval(_bcClock); _bcClock = null; }

/* ── SETTINGS (overlay) ── */
Renderers.settings = () => {
    const s = Settings.state;
    const ems = STATE.mode === 'ems';
    const deptName = ems ? 'Hospital' : 'Police';
    const deptColor = modeTheme().brand || (ems ? '#E5453E' : '#1F5EFF');
    // each mode keeps its own swatch first so the default reads right
    const brandSw = ems ? ['#E5453E','#E5564B','#F97316','#06B6D4','#34C77B','#A855F7','#1F5EFF']
                        : ['#1F5EFF','#06B6D4','#34C77B','#A855F7','#F97316','#E5564B','#EC4899'];
    const bgSw = ['#0A0A0B','#0E0F13','#13141A','#0A0E17','#0B1418','#101019'];
    const kb = STATE.cfg.keybind || {};
    Modal.open({ wide:true, title:L('app_settings','Settings'), body:`
        <div class="set-theme-banner" style="--_c:${deptColor}"><div class="stb-ic"><i class="fa-solid ${ems?'fa-truck-medical':'fa-shield-halved'}"></i></div><div class="stb-tx"><strong>${h(deptName)} ${h(L('set_theme','theme'))}</strong><span>${h(L('set_theme_sub','Brand & background are saved separately for Police and Hospital.'))}</span></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_brand','Brand Color'))}</div><div class="set-sub">${h(L('set_brand_sub','Accent colour for this department.'))}</div>
            <div class="swatches" id="set-brand">${brandSw.map(c=>`<button class="swatch ${s.brand.toLowerCase()===c.toLowerCase()?'active':''}" data-c="${c}" style="--c:${c}"></button>`).join('')}<span class="swatch swatch-custom"><i class="fa-solid fa-eye-dropper"></i><input type="color" id="set-brand-custom" value="${s.brand}"></span></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_bg','Background'))}</div><div class="set-sub">${h(L('set_bg_sub','Graphite surface tone.'))}</div>
            <div class="swatches" id="set-bg">${bgSw.map(c=>`<button class="swatch ${s.bg.toLowerCase()===c.toLowerCase()?'active':''}" data-c="${c}" style="--c:${c}"></button>`).join('')}<span class="swatch swatch-custom"><i class="fa-solid fa-eye-dropper"></i><input type="color" id="set-bg-custom" value="${s.bg}"></span></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_opacity','Opacity'))}</div><div class="slider-row"><input type="range" id="set-op" min="0.7" max="1" step="0.02" value="${s.opacity}"><output id="set-op-v">${Math.round(s.opacity*100)}%</output></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_scale','UI Scale'))}</div><div class="slider-row"><input type="range" id="set-sc" min="0.85" max="1.15" step="0.01" value="${s.scale}"><output id="set-sc-v">${Math.round(s.scale*100)}%</output></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_keybind','Open Keybind'))}</div><div class="set-sub">${h(L('set_keybind_sub','Key that opens the tablet.'))}</div>
            <div class="keybind-row"><span class="keybind-key"><i class="fa-solid fa-keyboard"></i> ${h(kb.key||'F6')}</span><span class="muted">Rebind in <b>FiveM → Settings → Key Bindings → “${h(kb.label||'Open MDT Tablet')}”</b>${STATE.cfg.command?` · or type <b>/${h(STATE.cfg.command)}</b>`:''}.</span></div></div>
        <div class="set-section"><div class="set-label">${h(L('set_prefs','Preferences'))}</div><div class="set-sub">${h(L('set_prefs_sub','Your personal device options.'))}</div>
            <button class="toggle-row pref-row" data-pref="notifications"><span class="tr-l"><i class="fa-solid fa-bell"></i> ${h(L('cc_notifications','Notifications'))}</span><span class="switch ${Prefs.get('notifications')!==false?'on':''}"></span></button>
            <button class="toggle-row pref-row" data-pref="dispatchAlerts"><span class="tr-l"><i class="fa-solid fa-tower-broadcast"></i> ${h(L('cc_dispatch_alerts','Dispatch Alerts'))}</span><span class="switch ${Prefs.get('dispatchAlerts')!==false?'on':''}"></span></button>
            <button class="toggle-row pref-row" data-pref="sounds"><span class="tr-l"><i class="fa-solid fa-volume-high"></i> ${h(L('cc_sounds','Sounds'))}</span><span class="switch ${Prefs.get('sounds')!==false?'on':''}"></span></button>
        </div>`,
        footer:`<button class="btn btn-ghost" id="set-reset"><i class="fa-solid fa-rotate-left"></i> ${h(L('ui_reset','Reset'))}</button><button class="btn btn-primary" data-mclose2>${h(L('ui_done','Done'))}</button>` });
    $('[data-mclose2]').onclick=Modal.close;
    $$('#set-brand .swatch[data-c]').forEach(b=>b.onclick=()=>{ Settings.set('brand',b.dataset.c); applyOfficerChrome(); $$('#set-brand .swatch').forEach(x=>x.classList.remove('active')); b.classList.add('active'); });
    $$('#set-bg .swatch[data-c]').forEach(b=>b.onclick=()=>{ Settings.set('bg',b.dataset.c); $$('#set-bg .swatch').forEach(x=>x.classList.remove('active')); b.classList.add('active'); });
    $('#set-brand-custom').oninput=e=>{ Settings.set('brand',e.target.value); applyOfficerChrome(); };
    $('#set-bg-custom').oninput=e=>Settings.set('bg',e.target.value);
    $('#set-op').oninput=e=>{ Settings.set('opacity',parseFloat(e.target.value)); $('#set-op-v').textContent=Math.round(e.target.value*100)+'%'; };
    $('#set-sc').oninput=e=>{ Settings.set('scale',parseFloat(e.target.value)); $('#set-sc-v').textContent=Math.round(e.target.value*100)+'%'; };
    $$('.pref-row').forEach(b=>b.onclick=()=>{ const k=b.dataset.pref; const on=Prefs.get(k)===false; Prefs.set(k,on); b.querySelector('.switch').classList.toggle('on',on); if(k==='dispatchAlerts') post('set_dispatch_alerts',{on}); });
    $('#set-reset').onclick=()=>{ const t=modeTheme(); Settings.set('brand',t.brand||'#1F5EFF'); Settings.set('bg',t.bg||'#0A0E17'); Settings.set('opacity',1); Settings.set('scale',1); applyOfficerChrome(); Renderers.settings(); };
};

/* ============================================================
   OPEN / CLOSE
   ============================================================ */
function openDevice(boot){
    STATE.open = true;
    STATE.mode = boot.mode || 'police';
    STATE.officer = boot.officer || {};
    STATE.cfg = boot.config || {};
    // default every profile photo to img/perfil.png when no photo was captured
    if (!STATE.officer.avatar) STATE.officer.avatar = avatarUrl(null);
    STATE.duty = !!(boot.officer && boot.officer.duty);
    STATE.notifications = boot.notifications || [];
    STATE.lastInput = Date.now();
    applyStaticI18n();
    Settings.applyServerTheme(modeTheme(), STATE.mode);   // police = blue/tactical · ems = teal/medical
    post('set_dispatch_alerts', { on: Prefs.get('dispatchAlerts') !== false });
    Device.start();
}
function closeDevice(){
    STATE.open = false;
    Device.hide();
    post('close');
}
// Live job switch (police ↔ ambulance): re-init the OPEN tablet from a fresh
// bootstrap - new mode, theme, department info and app set - without reopening.
function reinitDevice(boot){
    if (Modal && Modal.close) Modal.close();
    STATE.mode = boot.mode || 'police';
    STATE.officer = boot.officer || {};
    STATE.cfg = boot.config || STATE.cfg;
    if (!STATE.officer.avatar) STATE.officer.avatar = avatarUrl(null);
    STATE.duty = !!(boot.officer && boot.officer.duty);
    STATE.notifications = boot.notifications || [];
    Settings.applyServerTheme(modeTheme(), STATE.mode);
    Device.refresh();
    post('set_dispatch_alerts', { on: Prefs.get('dispatchAlerts') !== false });
    Notify({ title: STATE.officer.jobShort || 'MDT', message: 'Switched to ' + (STATE.officer.jobLabel || STATE.mode), type: 'info' });
}

/* ============================================================
   MESSAGE BUS
   ============================================================ */
window.addEventListener('message', (ev) => {
    const m = ev.data || {};
    switch (m.action) {
        case 'open': openDevice(m.payload || {}); break;
        case 'reinit': reinitDevice(m.payload || {}); break;
        case 'close': closeDevice(); break;
        case 'setAvatar': clearCamWatchdog(); if (m.payload && m.payload.url){ setAvatarEverywhere(m.payload.url); if (m.payload.persist) persistAvatar(m.payload.url); } break;
        // The booth acknowledged the request - from here the client owns the
        // deadline, so stand the browser-side watchdog down.
        case 'captureStart': { clearCamWatchdog(); const d=$('#device'); if (d) d.style.visibility='hidden'; break; }
        case 'captureEnd':   { clearCamWatchdog(); const d=$('#device'); if (d) d.style.visibility='visible'; break; }
        case 'cameraOpen':  { clearCamWatchdog(); const c=$('#camera-ui'); if (c){ c.hidden=false; c.style.visibility='visible'; } break; }
        case 'cameraShot':  { const c=$('#camera-ui'); if (c) c.style.visibility='hidden'; break; }
        case 'cameraClose': { clearCamWatchdog(); const c=$('#camera-ui'); if (c){ c.hidden=true; c.style.visibility='visible'; } break; }
        case 'photoCaptured': { clearCamWatchdog(); const p=m.payload||{}; if (p.purpose==='chat') sendChatPhoto(p.data); else if (p.purpose==='mugshot') saveMugshot(p.storeId, p.data); else processAndSavePhoto(p.data); break; }
        // Cancelled/failed: restore the WHOLE capture state, not just the button - // a cancel that arrives without a cameraClose would leave the tablet hidden.
        case 'photoCancelled': clearCamWatchdog(); restoreFromCapture(); break;
        case 'cctvShow':  { const d=$('#device'); if (d) d.style.visibility='hidden'; const c=$('#cctv-overlay'); if (c) c.hidden=false; startCctvClock(); break; }
        case 'cctvHide':  { const c=$('#cctv-overlay'); if (c) c.hidden=true; stopCctvClock(); const d=$('#device'); if (d) d.style.visibility='visible'; break; }
        case 'cctvCam':   { if (m.payload){ $('#cctv-name').textContent=m.payload.label||'CAMERA'; $('#cctv-idx').textContent=m.payload.index||1; $('#cctv-total').textContent=m.payload.total||1; } break; }
        case 'bodycamOn': { STATE.bodycam=true; const o=$('#bodycam-overlay'); if (o){ o.hidden=false; const cc=$('#bc-call'); if (cc) cc.textContent=STATE.officer.callsign||STATE.officer.jobShort||'UNIT'; } startBcClock(); if (STATE.activeApp==='bodycam') Renderers.bodycam(); break; }
        case 'bodycamOff':{ STATE.bodycam=false; if (!STATE.bcView){ const o=$('#bodycam-overlay'); if (o) o.hidden=true; stopBcClock(); } if (STATE.activeApp==='bodycam') Renderers.bodycam(); break; }
        case 'bodycamViewOn': { STATE.bcView=true; const o=$('#bodycam-overlay'); if (o){ o.hidden=false; const cc=$('#bc-call'); if (cc) cc.textContent='VIEW · '+((m.payload&&m.payload.name)||'Unit'); } startBcClock(); break; }
        case 'bodycamViewOff': { STATE.bcView=false; const o=$('#bodycam-overlay'); if (STATE.bodycam){ const cc=$('#bc-call'); if (cc) cc.textContent=STATE.officer.callsign||'UNIT'; } else if (o){ o.hidden=true; stopBcClock(); } break; }
        case 'notify': Notify(m.payload || {}); break;
        case 'dutyChanged':
            STATE.duty = !!(m.payload && m.payload.duty);
            $('#duty-btn')?.classList.toggle('on', STATE.duty);
            if (STATE.activeApp === 'dashboard') Renderers.dashboard();
            break;
        case 'dispatchUpdate':
            STATE.calls = (m.payload && m.payload.calls) || STATE.calls;
            STATE.units = (m.payload && m.payload.units) || STATE.units;
            if (STATE.activeApp === 'dispatch') paintDispatch();
            if (STATE.activeApp === 'map') renderMapMarkers();
            if (STATE.activeApp === 'dashboard' && STATE.dashMap) { STATE.dashMarkers = STATE.dashMarkers || []; plotMarkers(STATE.dashMap, STATE.dashMarkers); }
            Rail.badge('dispatch', STATE.calls.filter(c=>c.status==='pending').length);
            break;
        case 'newCall':
            if (m.payload) {
                if (!STATE.calls.find(c=>c.id===m.payload.id)) STATE.calls.unshift(m.payload);
                if (STATE.activeApp==='dispatch') paintDispatch();
                Rail.badge('dispatch', STATE.calls.filter(c=>c.status==='pending').length);
                if (Prefs.get('dispatchAlerts') !== false) DispatchBanner.show(m.payload);
            }
            break;
        case 'panicAlert':
            $('#bezel')?.classList.add('panic-mode'); setTimeout(()=>$('#bezel')?.classList.remove('panic-mode'),6000);
            Notify({ title:'PANIC', message:`${(m.payload&&m.payload.callsign)||'Unit'} needs help!`, type:'error', duration:8000 });
            break;
        case 'newMessage':
            if (STATE.activeApp === 'comms' && m.payload && m.payload.channel === commsChannel) Renderers.comms();
            break;
    }
});

document.addEventListener('keydown', e => { if (e.key === 'Escape' && STATE.open) { if ($('#modal-root').innerHTML) Modal.close(); else closeDevice(); } });
