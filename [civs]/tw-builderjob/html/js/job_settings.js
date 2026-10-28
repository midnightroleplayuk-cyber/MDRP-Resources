(function () {
    const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'tw-builderjob';

    function t(key, fallback) {
        const L = window.TW_LOCALES;
        return (L && L[key]) || fallback || key;
    }

    const GRADED = [
        { value: 'performans', lKey: 'lodPresetPerformance', lFb: 'Performance',
          dKey: 'lodDescPerformance', dFb: 'Weak PC — smooth up to 25 m, distant machines simplify early.' },
        { value: 'dengeli', lKey: 'lodPresetBalanced', lFb: 'Balanced',
          dKey: 'lodDescBalanced', dFb: 'Recommended — smooth up to 30 m, matches the server default.' },
        { value: 'yuksek', lKey: 'lodPresetHigh', lFb: 'High',
          dKey: 'lodDescHigh', dFb: 'Good PC — smooth up to 50 m, alive up to 200 m.' },
        { value: 'ultra', lKey: 'lodPresetUltra', lFb: 'Ultra',
          dKey: 'lodDescUltra', dFb: 'No FPS worries — FULLY smooth within 50 m, smooth up to 100 m.' },
    ];
    const LEVELS = [
        { value: 'dusuk',  lKey: 'visLvlLow',  lFb: 'Low',
          dKey: 'visLvlDescLow',  dFb: 'Weak PC — sling ropes, hook marker, hydraulics and particles off; 2 machines animate.' },
        { value: 'orta',   lKey: 'visLvlMid',  lFb: 'Medium',
          dKey: 'visLvlDescMid',  dFb: 'Everything on; up to 4 machines animate at once.' },
        { value: 'yuksek', lKey: 'visLvlHigh', lFb: 'High',
          dKey: 'visLvlDescHigh', dFb: 'Everything on, no machine cap.' },
        { value: 'otomatik', lKey: 'lodPresetAuto', lFb: '⚡ Auto' },
    ];
    const MODES = [
        { value: 'sinematik', lKey: 'lodPresetCinematic', lFb: '🎬 Cinematic',
          dKey: 'lodDescCinematic', dFb: 'VIDEO MODE — every machine fully smooth at every distance. Expensive on FPS.' },
    ];
    const ALL = GRADED.concat(MODES);
    const VIS = [
        { key: 'marker', lKey: 'visMarker', lFb: 'Hook ground marker',
          hKey: 'visMarkerHint', hFb: 'Target circle on the ground + ground scan (operator). ~16 us/frame.' },
        { key: 'sling', lKey: 'visSling', lFb: 'Sling ropes',
          hKey: 'visSlingHint', hFb: 'The ropes tying the load to the hook (operator). ~16 us/frame while carrying.' },
        { key: 'hyd', lKey: 'visHyd', lFb: 'Hydraulic animation',
          hKey: 'visHydHint', hFb: 'Your crane cylinders. Off = they freeze. ~20 us/frame while the boom moves.' },
        { key: 'sway', lKey: 'visSway', lFb: 'Rope sway',
          hKey: 'visSwayHint', hFb: 'Hook pendulum motion. Off = the rope hangs straight. VISUAL ONLY — 0 us (the swing is simulated either way for the broadcast).' },
        { key: 'sound', lKey: 'visSound', lFb: 'Machine sounds',
          hKey: 'visSoundHint', hFb: 'Engine / hydraulic / winch loop sounds. ~10 us/frame.' },
        { key: 'mirrorHyd', lKey: 'visMirrorHyd', lFb: 'Mirrored hydraulics',
          hKey: 'visMirrorHydHint', hFb: "Cylinders on someone else's crane — only matters with other machines nearby. Scales with machine count." },
        { key: 'pumpHyd', lKey: 'visPumpHyd', lFb: 'Pump hydraulics',
          hKey: 'visPumpHydHint', hFb: 'Pump only: 26 cylinders — the single heaviest item while pumping.' },
        { key: 'fx', lKey: 'visFx', lFb: 'Particle effects',
          hKey: 'visFxHint', hFb: 'Concrete pour / dust particles. Only during a pour; GPU-heavy on weak cards.' },
        { key: 'outline', lKey: 'visOutline', lFb: 'Green outlines',
          hKey: 'visOutlineHint', hFb: 'Highlight shader on piles/slots. GPU only, ~0 script cost. Needed to see what you can grab.' },
        { key: 'badge3d', lKey: 'visBadge3d', lFb: '3D [E] badge on the load',
          hKey: 'visBadge3dHint', hFb: 'Off = the hint shows as a line in the crane HUD instead. ~40 us/frame while a badge is shown.' },
        { key: 'truckGuard', lKey: 'visTruckGuard', lFb: 'Boom-vs-truck guard',
          hKey: 'visTruckGuardHint', hFb: 'Off = no per-frame box test; the boom may clip through the truck bed (visual only). ~20 us/frame while moving.' },
    ];
    const PLAY = [
        { key: 'route', lKey: 'visRoute', lFb: 'Ground route arrows',
          hKey: 'visRouteHint', hFb: 'Arrows on the ground toward the next slot or pile while you work on foot. ~30 us/frame while shown.' },
        { key: 'hints', lKey: 'visHints', lFb: 'Hint cards',
          hKey: 'visHintsHint', hFb: 'Short cards that explain a job and its next step. Off = no cards are shown.' },
        { key: 'stageCam', lKey: 'visStageCam', lFb: 'Finished build camera',
          hKey: 'visStageCamHint', hFb: 'When the job is done, the camera slowly circles the finished build for a few seconds. Skipped while you control a crane or pump.' },
    ];

    const CODE_VK = {
        Space: 32, Enter: 13, Tab: 9, Backspace: 8, ShiftLeft: 16, ShiftRight: 16,
        ControlLeft: 17, ControlRight: 17, AltLeft: 18, AltRight: 18, CapsLock: 20,
        ArrowLeft: 37, ArrowUp: 38, ArrowRight: 39, ArrowDown: 40, Insert: 45, Delete: 46,
        Home: 36, End: 35, PageUp: 33, PageDown: 34, Semicolon: 186, Equal: 187, Comma: 188,
        Minus: 189, Period: 190, Slash: 191, Backquote: 192, BracketLeft: 219, Backslash: 220,
        BracketRight: 221, Quote: 222, NumpadMultiply: 106, NumpadAdd: 107, NumpadSubtract: 109,
        NumpadDecimal: 110, NumpadDivide: 111,
    };
    function codeToVk(code) {
        if (CODE_VK[code] !== undefined) return CODE_VK[code];
        let m = /^Key([A-Z])$/.exec(code); if (m) return m[1].charCodeAt(0);
        m = /^Digit([0-9])$/.exec(code); if (m) return 48 + parseInt(m[1], 10);
        m = /^F([1-9]|1[0-2])$/.exec(code); if (m) return 111 + parseInt(m[1], 10);
        m = /^Numpad([0-9])$/.exec(code); if (m) return 96 + parseInt(m[1], 10);
        return null;
    }
    const BTN_VK = { 0: 1, 2: 2 };

    const ICON = {
        senkron: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 2v6h-6M3 12a9 9 0 0 1 15-6.7L21 8M3 22v-6h6M21 12a9 9 0 0 1-15 6.7L3 16"/></svg>',
        keys: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="6" width="20" height="12" rx="2"/><path d="M6 10h0M10 10h0M14 10h0M18 10h0M8 14h8"/></svg>',
        chev: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg>',
        gameplay: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/></svg>',
        info: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>',
    };
    const SECTIONS = [
        { id: 'jobsettings', lKey: 'jsNavSync', lFb: 'Sync',
          tKey: 'jsTitleSync', tFb: 'Sync Quality',
          sKey: 'jsSubSync', sFb: 'Visual smoothness and distance settings' },
        { id: 'gameplay', lKey: 'jsNavGameplay', lFb: 'Gameplay',
          tKey: 'jsTitleGameplay', tFb: 'Gameplay',
          sKey: 'jsSubGameplay', sFb: 'On-screen guidance while you work' },
        { id: 'keys', lKey: 'jsNavKeys', lFb: 'Keys',
          tKey: 'jsTitleKeys', tFb: 'Key Bindings',
          sKey: 'jsSubKeys', sFb: 'Reassign crane and general controls' },
    ];

    let root = null, activeTab = 'jobsettings';
    let current = 'dengeli', vis = {};
    let level = 'ozel', nums = { maxAnim: 0 }, auto = false, suggested = null, suggestedFps = null;
    function applyState(d) {
        if (!d) return;
        if (d.quality) current = d.quality;
        if (d.vis) vis = Object.assign({}, d.vis);
        if (d.level) level = d.level;
        if (d.nums) nums = Object.assign({}, d.nums);
        if (typeof d.auto === 'boolean') auto = d.auto;
        if (d.suggested) { suggested = d.suggested; suggestedFps = d.fps || null; }
    }
    let pages = [], rows = [], activePage = null, capturing = null, captureAt = 0;

    function post(name, data, cb) {
        fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data || {}) })
            .then(r => r.json()).then(d => { if (cb) cb(d); }).catch(() => {});
    }
    function setQuality(v) { current = v; post('lodSetQuality', { value: v }); }
    function setLevel(v) {
        if (v === 'otomatik') auto = true; else { auto = false; level = v; }
        post('visSetLevel', { value: v }, (d) => { applyState(d); if (activeTab === 'jobsettings') render(); });
    }

    const CSS = `
#twJobSettings{position:fixed;top:50%;left:50%;width:calc(46 * var(--u));height:calc(31.25 * var(--u));min-width:660px;
  font-family:GilroyMedium;color:#fff;z-index:9999;
  opacity:0;transform:translate(-50%,-50%) scale(0.94);
  transition:opacity 0.24s ease,transform 0.3s cubic-bezier(0.22,1,0.36,1);}
#twJobSettings.jsOpen{opacity:1;transform:translate(-50%,-50%) scale(1);}
#twJobSettings .jsPanel{position:absolute;inset:0;display:flex;background:var(--background);
  border-radius:calc(1.354 * var(--u));overflow:hidden;}
#twJobSettings .newTitleBox{top:-1.3vw;left:-1vw;}
#twJobSettings .jsSide{flex:0 0 calc(13.23 * var(--u));display:flex;flex-direction:column;padding:calc(5.4 * var(--u)) calc(0.9 * var(--u)) calc(0.9 * var(--u));
  background:rgba(32,32,30,0.7);border-radius:calc(1.354 * var(--u)) calc(0.3125 * var(--u)) calc(0.3125 * var(--u)) calc(1.354 * var(--u));}
#twJobSettings .jsNav{position:relative;display:flex;flex-direction:column;gap:calc(0.35 * var(--u));margin-right:-0.9vw;}
#twJobSettings .jsNavInd{position:absolute;left:0;right:0;top:0;height:calc(2.083 * var(--u));background:var(--primary-color);
  border-radius:calc(0.573 * var(--u)) 0 0 calc(0.573 * var(--u));transition:top 0.28s cubic-bezier(0.22,1,0.36,1),height 0.28s cubic-bezier(0.22,1,0.36,1);z-index:0;}
#twJobSettings .jsNavItem{position:relative;z-index:1;display:flex;align-items:center;gap:calc(0.5 * var(--u));height:calc(2.083 * var(--u));
  padding:0 calc(0.6 * var(--u));cursor:pointer;color:rgba(255,255,255,0.5);font-family:GilroySBold;font-size:calc(0.9375 * var(--u));
  border-radius:calc(0.573 * var(--u)) 0 0 calc(0.573 * var(--u));transition:color .18s;}
#twJobSettings .jsNavItem svg{width:calc(1.15 * var(--u));height:calc(1.15 * var(--u));}
#twJobSettings .jsNavItem .jsChev{width:calc(1 * var(--u));height:calc(1 * var(--u));margin-left:auto;opacity:0.7;}
#twJobSettings .jsNavItem:hover{color:rgba(255,255,255,0.85);}
#twJobSettings .jsNavItem.on{color:#141210;}
#twJobSettings .jsNavItem.on .jsChev{opacity:1;}
#twJobSettings .jsMain{flex:1;display:flex;flex-direction:column;min-width:0;padding:calc(1.35 * var(--u)) calc(1.55 * var(--u)) 0;}
#twJobSettings .jsTop{display:flex;align-items:flex-start;justify-content:space-between;}
#twJobSettings .jsTopTitle{font-family:GilroyBold;font-size:calc(1.25 * var(--u));}
#twJobSettings .jsTopSub{font-family:GilroyMedium;font-size:calc(0.833 * var(--u));color:rgba(255,255,255,0.35);margin-top:calc(0.35 * var(--u));}
#twJobSettings .jsClose{cursor:pointer;flex:0 0 auto;width:calc(1.2 * var(--u));height:calc(1.2 * var(--u));display:flex;align-items:center;
  justify-content:center;border-radius:calc(0.19 * var(--u));background:linear-gradient(171deg,#ff5454 7%,#d12929 95%);
  color:#fff;font-size:calc(0.7 * var(--u));}
#twJobSettings .jsDivider{height:2px;background:rgba(255,255,255,0.05);margin:calc(0.95 * var(--u)) 0 calc(0.7 * var(--u));}
#twJobSettings .jsBody{flex:1;overflow-y:auto;padding-bottom:calc(1.1 * var(--u));}
#twJobSettings .jsBody::-webkit-scrollbar{width:calc(0.3 * var(--u));}
#twJobSettings .jsBody::-webkit-scrollbar-thumb{background:rgba(255,255,255,0.15);border-radius:calc(0.2 * var(--u));}
#twJobSettings .jsPane{animation:jsPaneIn 0.28s cubic-bezier(0.22,1,0.36,1);}
@keyframes jsPaneIn{from{opacity:0;transform:translateY(calc(0.7 * var(--u)));}to{opacity:1;transform:none;}}
#twJobSettings .jsSub{font-family:GilroySBold;font-size:calc(0.833 * var(--u));color:#fff;margin:calc(1 * var(--u)) 0 calc(0.55 * var(--u));}
#twJobSettings .jsSegs{display:flex;gap:calc(0.32 * var(--u));margin-top:calc(0.25 * var(--u));}
#twJobSettings .jsSeg{flex:1;cursor:pointer;text-align:center;}
#twJobSettings .jsSegBar{position:relative;height:calc(0.62 * var(--u));border-radius:calc(0.35 * var(--u));background:rgba(255,255,255,0.1);overflow:hidden;}
#twJobSettings .jsSegFill{position:absolute;left:0;top:0;height:100%;width:0;background:var(--primary-color);
  border-radius:calc(0.35 * var(--u));transition:width 0.16s ease;}
#twJobSettings .jsSegLabel{margin-top:calc(0.45 * var(--u));font-size:calc(0.68 * var(--u));color:rgba(255,255,255,0.5);transition:color .18s;}
#twJobSettings .jsSeg.on .jsSegLabel,#twJobSettings .jsSegLabel.on{color:#fff;font-family:GilroySBold;}
#twJobSettings .jsQualDesc{margin-top:calc(0.55 * var(--u));font-size:calc(0.68 * var(--u));color:rgba(255,255,255,0.5);line-height:1.35;min-height:calc(1.5 * var(--u));}
#twJobSettings .jsModes{display:flex;gap:calc(0.4 * var(--u));margin-top:calc(0.5 * var(--u));align-items:center;}
#twJobSettings .jsLvlLine{margin-top:calc(0.3 * var(--u));font-size:calc(0.66 * var(--u));color:rgba(255,255,255,0.62);line-height:1.35;}
#twJobSettings .jsLvlLine b{color:#fff;font-family:GilroySBold;font-weight:normal;}
#twJobSettings .jsSuggest{margin-left:auto;font-size:calc(0.68 * var(--u));color:rgba(255,255,255,0.7);cursor:pointer;padding:calc(0.35 * var(--u)) calc(0.6 * var(--u));
  border:1px dashed rgba(255,255,255,0.25);border-radius:calc(0.35 * var(--u));}
#twJobSettings .jsSuggest:hover{color:#fff;border-color:var(--primary-color);}
#twJobSettings .jsNumCtl{display:flex;align-items:center;gap:calc(0.45 * var(--u));flex:0 0 auto;}
#twJobSettings .jsNumBtn{width:calc(1.35 * var(--u));height:calc(1.35 * var(--u));border-radius:calc(0.3 * var(--u));border:1px solid var(--primary-border-color);
  display:flex;align-items:center;justify-content:center;cursor:pointer;font-family:GilroySBold;font-size:calc(0.9 * var(--u));user-select:none;}
#twJobSettings .jsNumBtn:hover{border-color:var(--primary-color);}
#twJobSettings .jsNumVal{min-width:calc(2.2 * var(--u));text-align:center;font-family:GilroySBold;font-size:calc(0.8 * var(--u));}
#twJobSettings .jsMode{padding:calc(0.35 * var(--u)) calc(0.75 * var(--u));border:1px solid var(--primary-border-color);border-radius:calc(0.35 * var(--u));
  cursor:pointer;font-size:calc(0.7 * var(--u));color:rgba(255,255,255,0.6);background:rgba(255,255,255,0.03);transition:all .12s;}
#twJobSettings .jsMode.on{border-color:var(--primary-color);background:var(--primary-color-transparent);color:#fff;}
#twJobSettings .jsVisGrid{display:grid;grid-template-columns:1fr 1fr;gap:calc(0.32 * var(--u));}
#twJobSettings .jsVis{display:flex;align-items:center;justify-content:space-between;gap:calc(0.6 * var(--u));
  padding:calc(0.7 * var(--u)) calc(0.75 * var(--u));border-radius:calc(0.47 * var(--u));background:rgba(255,255,255,0.03);cursor:pointer;transition:opacity .12s;}
#twJobSettings .jsVis:not(.on){opacity:0.5;}
#twJobSettings .jsVisText{min-width:0;}
#twJobSettings .jsVisLabel{font-family:GilroySBold;font-size:calc(0.73 * var(--u));color:#fff;}
#twJobSettings .jsVisHint{font-family:GilroyMedium;font-size:calc(0.62 * var(--u));color:rgba(255,255,255,0.37);margin-top:calc(0.28 * var(--u));line-height:1.25;}
#twJobSettings .jsSwitch{flex:0 0 auto;width:calc(2.19 * var(--u));height:calc(1.04 * var(--u));border-radius:calc(0.55 * var(--u));background:#4d4d4d;position:relative;transition:background .15s;}
#twJobSettings .jsSwitch::after{content:'';position:absolute;top:calc(0.105 * var(--u));left:calc(0.105 * var(--u));width:calc(0.83 * var(--u));height:calc(0.83 * var(--u));border-radius:50%;background:#fff;transition:left .15s;}
#twJobSettings .jsVis.on .jsSwitch{background:var(--primary-color);}
#twJobSettings .jsVis.on .jsSwitch::after{left:calc(1.255 * var(--u));}
#twJobSettings .jsNote{display:flex;align-items:flex-start;gap:calc(0.4 * var(--u));margin-top:calc(0.9 * var(--u));opacity:0.3;}
#twJobSettings .jsNote svg{flex:0 0 auto;width:calc(1.04 * var(--u));height:calc(1.04 * var(--u));color:#fff;}
#twJobSettings .jsNote span{font-family:GilroyMedium;font-size:calc(0.625 * var(--u));line-height:1.25;}
#twJobSettings .jsPills{position:relative;display:flex;gap:calc(0.35 * var(--u));margin-bottom:calc(0.7 * var(--u));}
#twJobSettings .jsPillInd{position:absolute;left:0;top:0;height:100%;background:var(--primary-color);
  border-radius:calc(0.32 * var(--u));transition:left 0.26s cubic-bezier(0.22,1,0.36,1),width 0.26s cubic-bezier(0.22,1,0.36,1);z-index:0;}
#twJobSettings .jsPill{position:relative;z-index:1;padding:calc(0.32 * var(--u)) calc(0.85 * var(--u));cursor:pointer;font-size:calc(0.72 * var(--u));
  border-radius:calc(0.32 * var(--u));color:rgba(255,255,255,0.55);transition:color .18s;}
#twJobSettings .jsPill.on{color:#fff;}
#twJobSettings .jsKeys{display:grid;grid-template-columns:1fr 1fr;gap:calc(0.32 * var(--u));}
#twJobSettings .jsFade{animation:jsFadeIn 0.24s cubic-bezier(0.22,1,0.36,1);}
@keyframes jsFadeIn{from{opacity:0;transform:translateY(calc(0.55 * var(--u)));}to{opacity:1;transform:none;}}
#twJobSettings .jsKey{display:flex;align-items:center;justify-content:space-between;padding:calc(0.45 * var(--u)) calc(0.65 * var(--u));cursor:pointer;
  border-radius:calc(0.47 * var(--u));background:rgba(255,255,255,0.03);transition:background .12s;}
#twJobSettings .jsKey.cap{background:var(--primary-color-transparent);box-shadow:inset 0 0 0 1px var(--primary-color);}
#twJobSettings .jsKeyLabel{font-family:GilroySBold;font-size:calc(0.73 * var(--u));color:#fff;}
#twJobSettings .jsKeyMod{font-size:calc(0.56 * var(--u));color:rgba(255,255,255,0.4);margin-left:calc(0.3 * var(--u));}
#twJobSettings .jsChip{min-width:calc(3.6 * var(--u));text-align:center;padding:calc(0.2 * var(--u)) calc(0.5 * var(--u));font-family:GilroyBold;font-size:calc(0.7 * var(--u));border-radius:calc(0.25 * var(--u));background:#f3f543;color:#000;}
#twJobSettings .jsChip.empty{background:#ff6b5c;color:#2a0806;}
#twJobSettings .jsChip.cap{background:var(--primary-color);color:#1a1509;}
#twJobSettings .jsMsg{font-size:calc(0.66 * var(--u));color:var(--primary-color);min-height:calc(0.9 * var(--u));margin-top:calc(0.5 * var(--u));}
#twJobSettings .jsFoot{display:flex;justify-content:space-between;align-items:center;margin-top:calc(0.3 * var(--u));}
#twJobSettings .jsFootHint{font-size:calc(0.62 * var(--u));color:rgba(255,255,255,0.4);}
#twJobSettings .jsReset{cursor:pointer;padding:calc(0.35 * var(--u)) calc(0.75 * var(--u));border:1px solid var(--primary-border-color);border-radius:calc(0.32 * var(--u));font-size:calc(0.68 * var(--u));color:rgba(255,255,255,0.7);transition:all .12s;}
#twJobSettings .jsReset:hover{border-color:var(--primary-color);color:#fff;}
#twJobSettings .jsEmpty{font-size:calc(0.72 * var(--u));color:rgba(255,255,255,0.4);padding:calc(0.8 * var(--u));text-align:center;}`;

    function inject() {
        if (root) return;
        const style = document.createElement('style');
        style.id = 'twJobSettingsCss';
        style.textContent = CSS;
        document.head.appendChild(style);

        root = document.createElement('div');
        root.id = 'twJobSettings';
        root.style.display = 'none';
        const nav = SECTIONS.map(s =>
            `<div class="jsNavItem" data-tab="${s.id}">${ICON[s.id] || ''}<span>${t(s.lKey, s.lFb)}</span><span class="jsChev">${ICON.chev}</span></div>`
        ).join('');
        root.innerHTML = `
            <div class="newTitleBox">
                <div class="newTitleIcon"><img src="./img/newLogo.png" alt="" class="newLogo"></div>
                <div class="newTitleTextBox">
                    <h2 class="newTitleText">Tworst</h2>
                    <p class="newTitleSubText">Settings</p>
                </div>
            </div>
            <div class="jsPanel">
                <div class="jsSide">
                    <div class="jsNav"><div class="jsNavInd"></div>${nav}</div>
                </div>
                <div class="jsMain">
                    <div class="jsTop">
                        <div><div class="jsTopTitle"></div><div class="jsTopSub"></div></div>
                        <div class="jsClose">✕</div>
                    </div>
                    <div class="jsDivider"></div>
                    <div class="jsBody"></div>
                </div>
            </div>`;
        document.body.appendChild(root);

        root.querySelector('.jsClose').addEventListener('click', close);
        root.querySelectorAll('.jsNavItem').forEach(n => n.addEventListener('click', () => { activeTab = n.dataset.tab; render(); }));
        document.addEventListener('keydown', onKey, true);
        document.addEventListener('mousedown', onMouse, true);
    }

    function render() {
        if (!root) return;
        const sec = SECTIONS.find(s => s.id === activeTab) || SECTIONS[0];
        let active = null;
        root.querySelectorAll('.jsNavItem').forEach(n => { const on = n.dataset.tab === sec.id; n.classList.toggle('on', on); if (on) active = n; });
        const ind = root.querySelector('.jsNavInd');
        if (ind && active) requestAnimationFrame(() => { ind.style.top = active.offsetTop + 'px'; ind.style.height = active.offsetHeight + 'px'; });
        root.querySelector('.jsTopTitle').textContent = t(sec.tKey, sec.tFb);
        root.querySelector('.jsTopSub').textContent = t(sec.sKey, sec.sFb);
        const body = root.querySelector('.jsBody');
        body.innerHTML = '';
        const pane = document.createElement('div');
        pane.className = 'jsPane';
        if (sec.id === 'jobsettings') renderSenkron(pane);
        else if (sec.id === 'gameplay') renderGameplay(pane);
        else renderKeys(pane);
        body.appendChild(pane);
    }

    function renderSenkron(body) {
        const segs = document.createElement('div'); segs.className = 'jsSegs';
        const fillEls = [], stepEls = [];
        GRADED.forEach((g, i) => {
            const seg = document.createElement('div'); seg.className = 'jsSeg';
            seg.innerHTML = `<div class="jsSegBar"><div class="jsSegFill"></div></div><div class="jsSegLabel">${t(g.lKey, g.lFb)}</div>`;
            seg.addEventListener('click', () => { setQuality(g.value); updateQual(); });
            fillEls.push(seg.querySelector('.jsSegFill'));
            stepEls.push(seg.querySelector('.jsSegLabel'));
            segs.appendChild(seg);
        });
        body.appendChild(segs);

        const desc = document.createElement('div'); desc.className = 'jsQualDesc'; body.appendChild(desc);

        const modes = document.createElement('div'); modes.className = 'jsModes';
        const modeEls = MODES.map((m) => {
            const el = document.createElement('div'); el.className = 'jsMode'; el.textContent = t(m.lKey, m.lFb);
            el.addEventListener('click', () => { setQuality(m.value); updateQual(); });
            modes.appendChild(el);
            return el;
        });
        body.appendChild(modes);

        const STEP = 0.09;
        let prevGi = GRADED.findIndex(g => g.value === current);
        function updateQual() {
            const gi = GRADED.findIndex(g => g.value === current);
            const up = gi >= prevGi, lo = Math.min(prevGi, gi), hi = Math.max(prevGi, gi);
            fillEls.forEach((el, i) => {
                const changing = i > lo && i <= hi;
                el.style.transitionDelay = (changing ? (up ? (i - (lo + 1)) : (hi - i)) * STEP : 0) + 's';
                el.style.width = (gi >= 0 && i <= gi) ? '100%' : '0%';
            });
            prevGi = gi;
            stepEls.forEach((el, i) => el.classList.toggle('on', i === gi));
            modeEls.forEach((el, i) => el.classList.toggle('on', MODES[i].value === current));
            const cur = ALL.find(p => p.value === current);
            desc.textContent = cur ? t(cur.dKey, cur.dFb) : '';
        }
        updateQual();

        const sub = document.createElement('div'); sub.className = 'jsSub'; sub.textContent = t('lodVisTitle', 'Visual Detail'); body.appendChild(sub);

        const LV_GRADED = LEVELS.filter(l => l.value !== 'otomatik');
        const lsegs = document.createElement('div'); lsegs.className = 'jsSegs';
        const lFill = [], lStep = [];
        LV_GRADED.forEach((l) => {
            const seg = document.createElement('div'); seg.className = 'jsSeg';
            seg.innerHTML = `<div class="jsSegBar"><div class="jsSegFill"></div></div><div class="jsSegLabel">${t(l.lKey, l.lFb)}</div>`;
            seg.addEventListener('click', () => { setLevel(l.value); updateLevel(); });
            lFill.push(seg.querySelector('.jsSegFill'));
            lStep.push(seg.querySelector('.jsSegLabel'));
            lsegs.appendChild(seg);
        });
        body.appendChild(lsegs);
        const lvlDesc = document.createElement('div'); lvlDesc.className = 'jsQualDesc'; body.appendChild(lvlDesc);
        const lvlRow = document.createElement('div'); lvlRow.className = 'jsModes';
        const autoEl = document.createElement('div'); autoEl.className = 'jsMode'; autoEl.textContent = t('lodPresetAuto', '⚡ Auto');
        autoEl.addEventListener('click', () => { setLevel('otomatik'); updateLevel(); });
        lvlRow.appendChild(autoEl);
        const sugEl = document.createElement('div'); sugEl.className = 'jsSuggest';
        sugEl.addEventListener('click', () => { if (suggested) { setLevel(suggested); updateLevel(); } });
        lvlRow.appendChild(sugEl);
        body.appendChild(lvlRow);
        const lvlLine = document.createElement('div'); lvlLine.className = 'jsLvlLine'; body.appendChild(lvlLine);
        let lPrev = auto ? -1 : LV_GRADED.findIndex(l => l.value === level);

        function levelText() {
            const off = VIS.filter(v => vis[v.key] === false).map(v => t(v.lKey, v.lFb));
            const cap = nums.maxAnim > 0 ? String(nums.maxAnim) : t('lodLvlUnlimited', 'unlimited');
            const line = `<b>${t('lodLvlOff', 'Off:')}</b> ${off.length ? off.join(', ') : t('lodLvlNone', 'nothing')} · <b>${t('lodLvlCap', 'Machines animating:')}</b> ${cap}`;
            return line;
        }
        function updateLevel() {
            const gi = auto ? -1 : LV_GRADED.findIndex(l => l.value === level);
            const up = gi >= lPrev, lo = Math.min(lPrev, gi), hi = Math.max(lPrev, gi);
            lFill.forEach((el, i) => {
                const changing = i > lo && i <= hi;
                el.style.transitionDelay = (changing ? (up ? (i - (lo + 1)) : (hi - i)) * STEP : 0) + 's';
                el.style.width = (gi >= 0 && i <= gi) ? '100%' : '0%';
            });
            lPrev = gi;
            lStep.forEach((el, i) => el.classList.toggle('on', i === gi));
            autoEl.classList.toggle('on', auto);
            lvlLine.innerHTML = levelText();
            const cur = LV_GRADED.find(l => l.value === level);
            lvlDesc.textContent = auto
                ? t('lodDescAuto', 'Measures your FPS for 3 s and picks the detail level for you — re-checked every time this panel opens.')
                : (cur ? t(cur.dKey, cur.dFb) : t('lodLvlCustom', 'Layers hand-tuned — pick a level above to reset them.'));
            const sg = suggested ? LEVELS.find(l => l.value === suggested) : null;
            sugEl.style.display = sg ? '' : 'none';
            if (sg) sugEl.textContent = `${t('lodSuggested', 'Suggested:')} ${t(sg.lKey, sg.lFb)}${suggestedFps ? ' (' + suggestedFps + ' FPS)' : ''}`;
        }
        updateLevel();

        const grid = document.createElement('div'); grid.className = 'jsVisGrid'; body.appendChild(grid);
        VIS.forEach(v => {
            const row = document.createElement('div');
            row.className = 'jsVis' + (vis[v.key] !== false ? ' on' : '');
            row.innerHTML = `<div class="jsVisText"><div class="jsVisLabel">${t(v.lKey, v.lFb)}</div><div class="jsVisHint">${t(v.hKey, v.hFb)}</div></div><div class="jsSwitch"></div>`;
            row.addEventListener('click', () => {
                vis[v.key] = !(vis[v.key] !== false);
                post('lodSetVisual', { key: v.key, on: vis[v.key] });
                row.classList.toggle('on', vis[v.key]);
                level = 'ozel'; updateLevel();
            });
            grid.appendChild(row);
        });
        const nrow = document.createElement('div'); nrow.className = 'jsVis on';
        nrow.innerHTML = `<div class="jsVisText"><div class="jsVisLabel">${t('visMaxAnim', 'Machines animating at once')}</div><div class="jsVisHint">${t('visMaxAnimHint', '0 = all. On a crowded site the farthest machines beyond this count freeze until you get close.')}</div></div>
            <div class="jsNumCtl"><div class="jsNumBtn" data-d="-1">−</div><div class="jsNumVal"></div><div class="jsNumBtn" data-d="1">+</div></div>`;
        const nval = nrow.querySelector('.jsNumVal');
        function showNum() { nval.textContent = nums.maxAnim > 0 ? String(nums.maxAnim) : '∞'; }
        showNum();
        nrow.querySelectorAll('.jsNumBtn').forEach(b => b.addEventListener('click', () => {
            const v = Math.max(0, Math.min(8, (nums.maxAnim || 0) + parseInt(b.dataset.d, 10)));
            nums.maxAnim = v; showNum(); level = 'ozel'; updateLevel();
            post('lodSetNum', { key: 'maxAnim', value: v });
        }));
        grid.appendChild(nrow);
        const STRIDE_LBL = { 1: t('visOpStride1', 'every frame'), 2: '30 Hz', 3: '20 Hz' };
        const srow = document.createElement('div'); srow.className = 'jsVis on';
        srow.innerHTML = `<div class="jsVisText"><div class="jsVisLabel">${t('visOpStride', 'Own crane render rate')}</div><div class="jsVisHint">${t('visOpStrideHint', 'Every frame / 30 Hz / 20 Hz — only YOUR screen; others still see your crane at full rate.')}</div></div>
            <div class="jsNumCtl"><div class="jsNumBtn" data-d="-1">−</div><div class="jsNumVal"></div><div class="jsNumBtn" data-d="1">+</div></div>`;
        const sval = srow.querySelector('.jsNumVal');
        function showStride() { const v = nums.opStride || 1; sval.textContent = STRIDE_LBL[v] || String(v); }
        showStride();
        srow.querySelectorAll('.jsNumBtn').forEach(b => b.addEventListener('click', () => {
            const v = Math.max(1, Math.min(3, (nums.opStride || 1) + parseInt(b.dataset.d, 10)));
            nums.opStride = v; showStride(); level = 'ozel'; updateLevel();
            post('lodSetNum', { key: 'opStride', value: v });
        }));
        grid.appendChild(srow);

        const note = document.createElement('div'); note.className = 'jsNote';
        note.innerHTML = `${ICON.info}<span>${t('lodVisSub', 'Every layer you turn off buys FPS and costs visuals. Affects only your own view.')}</span>`;
        body.appendChild(note);
    }

    function renderGameplay(body) {
        const grid = document.createElement('div'); grid.className = 'jsVisGrid'; body.appendChild(grid);
        PLAY.forEach(v => {
            const row = document.createElement('div');
            row.className = 'jsVis' + (vis[v.key] !== false ? ' on' : '');
            row.innerHTML = `<div class="jsVisText"><div class="jsVisLabel">${t(v.lKey, v.lFb)}</div><div class="jsVisHint">${t(v.hKey, v.hFb)}</div></div><div class="jsSwitch"></div>`;
            row.addEventListener('click', () => {
                vis[v.key] = !(vis[v.key] !== false);
                post('lodSetVisual', { key: v.key, on: vis[v.key] });
                row.classList.toggle('on', vis[v.key]);
            });
            grid.appendChild(row);
        });
    }

    function renderKeys(body) {
        const pills = document.createElement('div'); pills.className = 'jsPills';
        const ind = document.createElement('div'); ind.className = 'jsPillInd'; pills.appendChild(ind);
        const pillEls = pages.map(p => {
            const b = document.createElement('div');
            b.className = 'jsPill'; b.textContent = p.label; b.dataset.page = p.id;
            b.addEventListener('click', () => { activePage = p.id; capturing = null; updatePills(); renderRows(true); });
            pills.appendChild(b);
            return b;
        });
        body.appendChild(pills);

        const rowsWrap = document.createElement('div'); body.appendChild(rowsWrap);
        const msg = document.createElement('div'); msg.className = 'jsMsg'; msg.id = 'jsMsg'; body.appendChild(msg);
        const foot = document.createElement('div'); foot.className = 'jsFoot';
        foot.innerHTML = `<div class="jsFootHint">${t('jsKeysFootHint', 'Click a row, then press the new key. ESC = cancel.')}</div><div class="jsReset">${t('jsKeysReset', 'Restore defaults')}</div>`;
        foot.querySelector('.jsReset').addEventListener('click', () => post('keysReset', { page: activePage }, refresh));
        body.appendChild(foot);

        function updatePills() {
            pillEls.forEach(b => b.classList.toggle('on', b.dataset.page === activePage));
            const a = pillEls.find(b => b.dataset.page === activePage);
            if (a) { ind.style.left = a.offsetLeft + 'px'; ind.style.top = a.offsetTop + 'px'; ind.style.width = a.offsetWidth + 'px'; ind.style.height = a.offsetHeight + 'px'; }
        }
        function renderRows(anim) {
            rowsWrap.innerHTML = '';
            const list = rows.filter(r => r.page === activePage);
            if (!list.length) {
                const e = document.createElement('div'); e.className = 'jsEmpty' + (anim ? ' jsFade' : ''); e.textContent = t('jsKeysEmptyPage', 'No keys defined on this page.'); rowsWrap.appendChild(e);
                return;
            }
            const grid = document.createElement('div'); grid.className = 'jsKeys' + (anim ? ' jsFade' : ''); rowsWrap.appendChild(grid);
            list.forEach(r => {
                if (r.kind === 'toggle') {
                    const on = !!r.on;
                    const row = document.createElement('div');
                    row.className = 'jsKey jsPref';
                    row.innerHTML = `
                        <div class="jsKeyLabel">${r.label}</div>
                        <div class="jsChip${on ? '' : ' empty'}">${on ? t('jsPrefOn', 'ON') : t('jsPrefOff', 'OFF')}</div>`;
                    row.addEventListener('click', () => {
                        post('keysToggle', { id: r.id }, (d) => {
                            if (!d || !d.rows) return;
                            pages = d.pages || pages; rows = d.rows;
                            renderRows(false);
                        });
                    });
                    grid.appendChild(row);
                    return;
                }
                const cap = capturing === r.id, empty = !r.vk;
                const row = document.createElement('div');
                row.className = 'jsKey' + (cap ? ' cap' : '');
                row.innerHTML = `
                    <div class="jsKeyLabel">${r.label}${r.isDefault ? '' : '<span class="jsKeyMod">(' + t('jsKeyChanged', 'changed') + ')</span>'}</div>
                    <div class="jsChip${empty ? ' empty' : ''}${cap ? ' cap' : ''}">${cap ? t('jsKeyPress', 'press…') : (empty ? t('jsKeyEmpty', 'EMPTY') : r.keyName)}</div>`;
                row.addEventListener('click', () => { capturing = r.id; captureAt = Date.now(); setMsg(t('jsKeyPrompt', 'Press a new key or click a mouse button (ESC = cancel).')); renderRows(false); });
                grid.appendChild(row);
            });
        }

        renderRows(false);
        requestAnimationFrame(updatePills);
    }

    function setMsg(t) { const m = root && root.querySelector('#jsMsg'); if (m) m.textContent = t || ''; }

    function onKey(e) {
        if (!root || root.style.display === 'none') return;
        if (activeTab !== 'keys' || !capturing) { if (e.key === 'Escape') { e.preventDefault(); close(); } return; }
        e.preventDefault(); e.stopPropagation();
        if (e.key === 'Escape') { capturing = null; setMsg(''); render(); return; }
        const vk = codeToVk(e.code);
        if (vk === null) { setMsg(t('jsKeyUnsupported', 'That key is not supported — try a different one.')); return; }
        const id = capturing; capturing = null;
        post('keysSet', { id, vk }, (res) => { setMsg(res && res.cleared ? '“' + res.cleared + '” ' + t('jsKeyCleared', 'used the same key and was cleared.') : ''); refresh(); });
    }
    function onMouse(e) {
        if (activeTab !== 'keys' || !capturing) return;
        if (Date.now() - captureAt < 250) return;
        const vk = BTN_VK[e.button];
        if (vk === undefined) return;
        e.preventDefault(); e.stopPropagation();
        const id = capturing; capturing = null;
        post('keysSet', { id, vk }, (res) => { setMsg(res && res.cleared ? '“' + res.cleared + '” ' + t('jsKeyCleared', 'used the same key and was cleared.') : ''); refresh(); });
    }
    function refresh() {
        post('keysGet', {}, (d) => {
            if (!d) return;
            pages = d.pages || []; rows = d.rows || [];
            if (!activePage || !pages.some(p => p.id === activePage)) activePage = pages.length ? pages[0].id : null;
            if (activeTab === 'keys') render();
        });
    }

    let hideTimer = null;
    function open(tab) {
        inject();
        activeTab = tab || activeTab || 'jobsettings';
        clearTimeout(hideTimer);
        root.style.display = 'block';
        render();
        requestAnimationFrame(() => root.classList.add('jsOpen'));
        refresh();
    }
    function hideAnim() {
        if (!root) return;
        root.classList.remove('jsOpen');
        clearTimeout(hideTimer);
        hideTimer = setTimeout(() => { if (root && !root.classList.contains('jsOpen')) root.style.display = 'none'; }, 320);
    }
    function close() { capturing = null; hideAnim(); post('lodMenuClose'); post('keysClose'); }

    window.addEventListener('message', (event) => {
        const d = event.data || {};
        switch (d.action) {
            case 'lodMenuShow':
                applyState(d);
                open('jobsettings'); break;
            case 'lodMenuState':
            case 'lodSuggest':
                applyState(d);
                if (root && root.classList.contains('jsOpen') && activeTab === 'jobsettings') render();
                break;
            case 'keysMenuShow':
                pages = d.pages || []; rows = d.rows || [];
                activePage = pages.length ? pages[0].id : null; capturing = null;
                open('keys'); break;
            case 'jobSettingsShow':
                applyState(d);
                if (d.pages) pages = d.pages;
                if (d.rows) rows = d.rows;
                if (pages.length && (!activePage || !pages.some(p => p.id === activePage))) activePage = pages[0].id;
                open(d.tab || 'jobsettings'); break;
            case 'lodMenuHide':
            case 'keysMenuHide':
            case 'jobSettingsHide':
                hideAnim(); break;
        }
    });
})();
