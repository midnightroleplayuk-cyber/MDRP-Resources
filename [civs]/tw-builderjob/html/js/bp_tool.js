(function () {
    const RESOURCE_NAME = (typeof GetParentResourceName === 'function')
        ? GetParentResourceName() : 'tw-builderjob';

    let blueprints = {};
    let store = { sites: [], zones: [], health: [], designs: [], locked: { site1: true }, settings: {} };
    let view = 'sites';
    let designFilter = 'all';
    let infoOpen = false;
    let saveCtx = null;
    let designs = [];
    let lastCmd = 0;
    let toastTimer = null;

    function fetchAPI(name, body) {
        return fetch(`https://${RESOURCE_NAME}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {}),
        }).catch(() => {});
    }

    function T(key, fallback) {
        const tbl = window.TW_LOCALES;
        return (tbl && tbl[key]) || fallback || key;
    }

    const fmt = (n, d) => (typeof n === 'number' ? n.toFixed(d === undefined ? 2 : d) : '—');
    const esc = (s) => String(s === undefined || s === null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    const g = (id) => document.getElementById(id);

    const FAMILY_NOTE = {
        U: null,
        L: 'bp_note_l',
        L_REV: 'bp_note_l',
        PLUS: 'bp_note_plus',
        T: 'bp_note_t',
    };
    const FAMILY_NOTE_EN = {
        bp_note_l: 'Wing joint: 3 slabs overlap by 0.24 m · 5 props stacked · 1 mesh column off-grid',
        bp_note_plus: '4 slabs overlap by 0.24 m · 2 props stacked · 2 mesh columns off-grid',
        bp_note_t: 'Body does not sit on the main lattice (Y off by 0.04 m) · mesh grid irregular',
    };

    function badge(kind, text, title) {
        return `<span class="tw-badge ${kind}"${title ? ` title="${esc(title)}"` : ''}>${esc(text)}</span>`;
    }

    function confirmBtn(btn, label, fn) {
        if (btn.dataset.armed === '1') { fn(); return; }
        btn.dataset.armed = '1';
        const old = btn.textContent;
        btn.textContent = T('bp_sure', 'Sure?');
        btn.classList.add('armed');
        setTimeout(() => {
            btn.dataset.armed = '0';
            btn.textContent = old || label;
            btn.classList.remove('armed');
        }, 4000);
    }

    function bindRowActions(root) {
        root.querySelectorAll('[data-act]').forEach((b) => {
            b.addEventListener('click', () => {
                const act = b.dataset.act;
                const id = b.dataset.id;
                const anchor = b.dataset.anchor ? JSON.parse(b.dataset.anchor) : null;
                if (act === 'edit') fetchAPI('editSite', { id });
                else if (act === 'copy') fetchAPI('copySite', { id });
                else if (act === 'wp') fetchAPI('waypointSite', { anchor });
                else if (act === 'tp') fetchAPI('tpSite', { anchor, id });
                else if (act === 'del') confirmBtn(b, T('bp_delete', 'Delete'), () => fetchAPI('deleteSite', { id }));
                else if (act === 'zshow') fetchAPI('showZone', { name: id });
                else if (act === 'zwp') fetchAPI('waypointSite', { anchor });
                else if (act === 'zdel') confirmBtn(b, T('bp_delete', 'Delete'), () => fetchAPI('deleteZone', { name: id }));
                else if (act === 'design') fetchAPI('selectBlueprint', { designId: id });
                else if (act === 'toggle') fetchAPI('setSiteEnabled', { id: id, enabled: b.dataset.on !== '1' });
                else if (act === 'toreset') fetchAPI('setSiteEnabled', { id: id });
                else if (act === 'rnd') fetchAPI('setRandomSite', { on: b.dataset.on !== '1' });
                else if (act === 'rndreset') fetchAPI('setRandomSite', {});
            });
        });
    }

    function medianGap(values) {
        const u = Array.from(new Set(values.map((v) => Math.round(v * 100) / 100))).sort((a, b) => a - b);
        if (u.length < 2) return 4;
        const gaps = [];
        for (let i = 1; i < u.length; i++) gaps.push(u[i] - u[i - 1]);
        gaps.sort((a, b) => a - b);
        return gaps[Math.floor(gaps.length / 2)] || 4;
    }

    function planSvg(pts) {
        if (!Array.isArray(pts) || !pts.length) {
            return `<div class="tw-dim" style="font-size:var(--t-xs)">${esc(T('bp_no_plan', 'no plan'))}</div>`;
        }
        const cw = medianGap(pts.map((p) => p[0]));
        const ch = medianGap(pts.map((p) => p[1]));
        let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
        pts.forEach((p) => {
            if (p[0] - cw / 2 < minX) minX = p[0] - cw / 2;
            if (p[0] + cw / 2 > maxX) maxX = p[0] + cw / 2;
            if (p[1] - ch / 2 < minY) minY = p[1] - ch / 2;
            if (p[1] + ch / 2 > maxY) maxY = p[1] + ch / 2;
        });
        const w = Math.max(0.001, maxX - minX);
        const h = Math.max(0.001, maxY - minY);
        const rects = pts.map((p) => {
            const x = p[0] - cw / 2 - minX;
            const y = maxY - (p[1] + ch / 2);
            return `<rect x="${x.toFixed(2)}" y="${y.toFixed(2)}" width="${cw.toFixed(2)}" height="${ch.toFixed(2)}" rx="0.15"/>`;
        }).join('');
        return `<svg viewBox="0 0 ${w.toFixed(2)} ${h.toFixed(2)}" preserveAspectRatio="xMidYMid meet">
            <g class="tw-plan-fill" fill="rgba(255,255,255,0.09)"
               stroke="var(--primary-color)" stroke-width="0.12" stroke-linejoin="round">${rects}</g>
        </svg>`;
    }

    function renderSites() {
        const list = store.sites || [];
        const rows = list.map((s) => {
            const a = s.anchor || [];
            const locked = !!store.locked[s.id];
            const canEdit = !locked && a[0] !== undefined && (s.designId || false);
            const anchorTxt = a[0] === undefined
                ? `<span class="tw-dim">${esc(T('bp_anchor_none', 'no anchor — blueprint absolute position'))}</span>`
                : `<span class="tw-mono">${fmt(a[0])}, ${fmt(a[1])}, ${fmt(a[2])} · ${fmt(a[3], 1)}°</span>`;
            const tgt = s.target || null;
            const aJson = tgt ? ` data-anchor='${JSON.stringify(tgt)}'` : '';
            const shared = list.filter((o) => o.zoneId && o.zoneId === s.zoneId).length > 1;

            let status;
            if (s.pendingRestart) status = badge('pend', T('bp_needs_restart', 'RESTART NEEDED'), T('bp_needs_restart_t', 'Overwrite or delete — those still need restart tw-builderjob. New sites go live immediately.'));
            else if (s.built) status = badge('lock', T('bp_built', 'HOUSE BUILT'), T('bp_built_t', 'Finished house standing here — this plot is spent'));
            else if (s.active) status = badge('busy', `${T('bp_busy', 'BUSY')} · ${s.members || 0}${s.phase ? ' · ' + s.phase : ''}`);
            else status = badge('free', T('bp_free', 'FREE'));

            const permBadge = s.permanent
                ? badge('f2', T('bp_r14', 'REGION 14'), T('bp_r14_t', 'Permanent plot — the finished house stays'))
                : '';

            const cfgSet = store.settings || {};
            const isOn = (cfgSet.enabled && cfgSet.enabled[s.id] !== undefined)
                ? !!cfgSet.enabled[s.id] : true;
            const fromPanel = !!(cfgSet.enabledFromPanel && cfgSet.enabledFromPanel[s.id]);
            const offBadge = isOn ? '' : badge('lock', T('bp_disabled', 'DISABLED'),
                T('bp_disabled_t', 'Crews are never assigned to this site'));
            const srcBadge = fromPanel
                ? badge('json', T('bp_from_panel', 'PANEL'),
                    T('bp_from_panel_t', 'Set from this panel — overrides config/jobs/plank.lua'))
                : '';

            return `
            <div class="tw-row${s.pendingRestart ? ' pend' : ''}${locked ? ' locked' : ''}">
                <div class="tw-row-main">
                    <div class="tw-row-title">
                        <strong>${esc(s.id)}</strong>
                        <span class="tw-label">${esc(s.label || '')}</span>
                        ${badge(s.fromJson ? 'json' : 'cfg', s.fromJson ? 'JSON' : 'CONFIG')}
                        ${locked ? badge('lock', T('bp_locked', 'LOCKED'), T('bp_locked_t', 'Field-proven flagship — not editable from the panel')) : ''}
                        ${permBadge}
                        ${offBadge}
                        ${srcBadge}
                        ${status}
                    </div>
                    <div class="tw-row-meta">
                        ${s.permanent ? `<span><i>${esc(T('bp_ext_model', 'Finished house'))}</i>${(() => {
                            // An empty override is the NORMAL case now — the design
                            // maps to a house. Printing "NONE" for that would be a lie.
                            if (s.exteriorModel) return `<span class="tw-mono">${esc(s.exteriorModel)}</span>`;
                            if (s.autoModel) return `<span class="tw-mono tw-dim">${esc(s.autoModel)}</span>`;
                            return `<b class="bad">${esc(T('bp_none', 'NONE'))}</b>`;
                        })()}</span>` : ''}
                        <span><i>${esc(T('bp_design', 'Design'))}</i>${s.designId
                            ? esc(s.designId)
                            : `<span class="tw-dim">${esc(T('bp_design_manual', 'none (hand-measured slots)'))}</span>`}</span>
                        <span><i>${esc(T('bp_zone', 'Zone'))}</i>${s.zoneId
                            ? esc(s.zoneId) + (shared ? ` <b class="bad">${esc(T('bp_zone_shared', 'shared'))}</b>` : '')
                            : `<b class="bad">${esc(T('bp_none', 'NONE'))}</b>`}</span>
                        <span><i>${esc(T('bp_position', 'Position'))}</i>${anchorTxt}</span>
                        ${typeof s.dist === 'number' ? `<span><i>${esc(T('bp_distance', 'Distance'))}</i>${fmt(s.dist, 0)} m</span>` : ''}
                    </div>
                </div>
                <div class="tw-row-act">
                    <button class="tw-btn" data-act="edit" data-id="${esc(s.id)}" ${canEdit ? '' : 'disabled'}
                        title="${locked ? esc(T('bp_locked_t', 'Field-proven flagship — not editable from the panel'))
                                        : (s.designId ? '' : esc(T('bp_no_bp_t', 'No blueprint (hand-measured slots) — cannot be edited visually')))}"
                        >${esc(T('bp_edit', 'Edit'))}</button>
                    <button class="tw-btn" data-act="copy" data-id="${esc(s.id)}" ${s.designId ? '' : 'disabled'}>${esc(T('bp_copy', 'Copy'))}</button>
                    <button class="tw-btn" data-act="wp" data-id="${esc(s.id)}"${aJson} ${tgt ? '' : 'disabled'}>${esc(T('bp_waypoint', 'Waypoint'))}</button>
                    <button class="tw-btn" data-act="tp" data-id="${esc(s.id)}"${aJson} ${tgt ? '' : 'disabled'}>${esc(T('bp_teleport', 'Teleport'))}</button>
                    <button class="tw-btn" data-act="toggle" data-id="${esc(s.id)}" data-on="${isOn ? '1' : '0'}"
                        title="${esc(T('bp_toggle_t', 'Disabled sites are skipped when a crew is assigned'))}"
                        >${esc(isOn ? T('bp_disable', 'Disable') : T('bp_enable', 'Enable'))}</button>
                    ${fromPanel ? `<button class="tw-btn" data-act="toreset" data-id="${esc(s.id)}"
                        title="${esc(T('bp_toreset_t', 'Drop the panel override and follow config/jobs/plank.lua again'))}"
                        >${esc(T('bp_toreset', 'Use config'))}</button>` : ''}
                    <button class="tw-btn danger" data-act="del" data-id="${esc(s.id)}" ${s.fromJson ? '' : 'disabled'}>${esc(T('bp_delete', 'Delete'))}</button>
                </div>
            </div>`;
        }).join('');

        return {
            title: T('bp_tab_sites', 'Sites'),
            lead: T('bp_sites_lead', 'Every crew is assigned one free site. Pick a design to create a new one.'),
            info: T('bp_sites_info',
                'Records badged <b>CONFIG</b> come from <code>config/jobs/plank.lua</code>, <b>JSON</b> ones from <code>config/data/plank_sites.json</code>. A saved change only goes live after <code>restart tw-builderjob</code>, because <code>files{}</code> is handed to the client when the resource starts.'
                + '<b>JSON</b> ones from <code>config/data/plank_sites.json</code>. A saved change only goes live '
                + 'after <code>restart tw-builderjob</code>, because <code>files{}</code> is handed to the '
                + 'client when the resource starts.'),
            body: (() => {
                const cs = store.settings || {};
                const rnd = !!cs.randomSite;
                const rndPanel = !!cs.randomFromPanel;
                const bar = `
            <div class="tw-row">
                <div class="tw-row-main">
                    <div class="tw-row-title">
                        <strong>${esc(T('bp_random', 'Random site'))}</strong>
                        ${badge(rnd ? 'free' : 'cfg', rnd ? T('bp_on', 'ON') : T('bp_off', 'OFF'))}
                        ${rndPanel ? badge('json', T('bp_from_panel', 'PANEL'),
                            T('bp_from_panel_t', 'Set from this panel — overrides config/jobs/plank.lua')) : ''}
                    </div>
                    <div class="tw-row-meta"><span>${esc(T('bp_random_t',
                        'ON: a free site is picked at random. OFF: crews always get the first free one.'))}</span></div>
                </div>
                <div class="tw-row-act">
                    <button class="tw-btn" data-act="rnd" data-on="${rnd ? '1' : '0'}"
                        >${esc(rnd ? T('bp_off', 'OFF') : T('bp_on', 'ON'))}</button>
                    ${rndPanel ? `<button class="tw-btn" data-act="rndreset"
                        title="${esc(T('bp_toreset_t', 'Drop the panel override and follow config/jobs/plank.lua again'))}"
                        >${esc(T('bp_toreset', 'Use config'))}</button>` : ''}
                </div>
            </div>`;
                return list.length
                    ? `<div class="tw-rows">${bar}${rows}</div>`
                    : `<div class="tw-rows">${bar}</div><div class="tw-empty">${esc(T('bp_no_sites', 'No sites yet — open Designs and place one'))}</div>`;
            })(),
            bind: bindRowActions,
        };
    }

    function renderZones() {
        const list = store.zones || [];
        const rows = list.map((z) => {
            const c = z.center || [];
            const aJson = ` data-anchor='${JSON.stringify(c)}'`;
            const users = z.users || [];
            return `
            <div class="tw-row${users.length > 1 ? ' pend' : ''}">
                <div class="tw-row-main">
                    <div class="tw-row-title">
                        <strong>${esc(z.name)}</strong>
                        ${badge(z.fromJson ? 'json' : 'cfg', z.fromJson ? 'JSON' : 'CONFIG')}
                        ${users.length > 1 ? badge('bad', `${users.length} ${T('bp_zone_users', 'SITES SHARE THIS')}`) : ''}
                    </div>
                    <div class="tw-row-meta">
                        <span><i>${esc(T('bp_zone_used_by', 'Used by'))}</i>${users.length
                            ? esc(users.join(', ')) : `<span class="tw-dim">${esc(T('bp_nobody', 'nobody'))}</span>`}</span>
                        <span><i>${esc(T('bp_polygon', 'Polygon'))}</i>${z.points} ${esc(T('bp_points', 'points'))} · ~${fmt(z.radius, 0)} m</span>
                        <span><i>${esc(T('bp_center', 'Centre'))}</i><span class="tw-mono">${fmt(c[0])}, ${fmt(c[1])}</span></span>
                        ${typeof z.dist === 'number' ? `<span><i>${esc(T('bp_distance', 'Distance'))}</i>${fmt(z.dist, 0)} m</span>` : ''}
                    </div>
                </div>
                <div class="tw-row-act">
                    <button class="tw-btn" data-act="zshow" data-id="${esc(z.name)}">${esc(T('bp_show_world', 'Show in world'))}</button>
                    <button class="tw-btn" data-act="zwp" data-id="${esc(z.name)}"${aJson}>${esc(T('bp_waypoint', 'Waypoint'))}</button>
                    <button class="tw-btn danger" data-act="zdel" data-id="${esc(z.name)}"
                        ${z.fromJson && users.length === 0 ? '' : 'disabled'}
                        title="${z.fromJson ? (users.length ? esc(T('bp_zone_in_use', 'A site still uses this zone')) : '')
                                            : esc(T('bp_zone_cfg', 'Config zones cannot be deleted from the panel'))}"
                        >${esc(T('bp_delete', 'Delete'))}</button>
                </div>
            </div>`;
        }).join('');

        return {
            title: T('bp_tab_zones', 'Zones'),
            lead: T('bp_zones_lead', 'A zone is the sync/watcher area of a site. New zones are generated automatically when you save.'),
            info: T('bp_zones_info',
                'A site with <b>no zone dies silently</b> -- the scene is never built. If <b>two sites land in the same zone</b> the server can resolve to the wrong one and swallow <code>requestSync</code>; that happened in the field on 07-29.'
                + 'the same zone</b> the server can resolve to the wrong one and swallow <code>requestSync</code>; '
                + 'that happened in the field on 07-29.'),
            body: list.length ? `<div class="tw-rows">${rows}</div>`
                : `<div class="tw-empty">${esc(T('bp_no_zones', 'No zones'))}</div>`,
            bind: bindRowActions,
        };
    }

    const fam = (id) => id.replace(/^DESIGN_/, '').replace(/_(1F|2F)$/, '');

    function renderDesigns() {
        const ids = Object.keys(blueprints).sort();
        const families = Array.from(new Set(ids.map(fam))).sort();

        const shown = ids.filter((id) => {
            if (designFilter === 'all') return true;
            if (designFilter === '1f') return id.indexOf('_2F') < 0;
            if (designFilter === '2f') return id.indexOf('_2F') >= 0;
            return fam(id) === designFilter;
        });

        const chips = [['all', T('bp_all', 'All')], ['1f', T('bp_1f', '1 Floor')], ['2f', T('bp_2f', '2 Floors')]]
            .concat(families.map((f) => [f, f]))
            .map(([k, lbl]) => `<div class="tw-chip${k === designFilter ? ' on' : ''}" data-filter="${esc(k)}">${esc(lbl)}</div>`)
            .join('');

        const cards = shown.map((id) => {
            const bp = blueprints[id] || {};
            const sz = bp.size || { x: 0, y: 0 };
            const is2F = id.indexOf('_2F') >= 0;
            const notes = [];
            const famKey = FAMILY_NOTE[fam(id)];
            if (famKey) notes.push(T(famKey, FAMILY_NOTE_EN[famKey]));
            if (!is2F) notes.push(T('bp_note_1f_poles', 'Columns spawn at 2x height in game (Blender scale 0.5, FiveM ignores scale)'));
            const shot = `./img/designs/${id}.webp`;
            return `
            <div class="tw-card" data-act="design" data-id="${esc(id)}">
                <div class="tw-card-plan">
                    <img class="tw-card-shot" src="${esc(shot)}" alt="" loading="lazy"
                         onerror="this.remove()"
                         onload="this.parentNode.classList.add('has-shot')">
                    ${planSvg(bp.plan)}
                    <div class="tw-card-floors">${badge(is2F ? 'f2' : 'f1', is2F ? T('bp_2f_short', '2F') : T('bp_1f_short', '1F'))}</div>
                </div>
                <div class="tw-card-body">
                    <div class="tw-card-name">${esc(id.replace(/^DESIGN_/, ''))}</div>
                    <div class="tw-card-stats">
                        <span>${bp.object_count || 0} ${esc(T('bp_objects', 'objects'))}</span>
                        <span>${sz.x.toFixed(1)}×${sz.y.toFixed(1)} m</span>
                    </div>
                    ${notes.map((t) => `<div class="tw-card-note warn-note">${esc(t)}</div>`).join('')}
                </div>
            </div>`;
        }).join('');

        return {
            title: T('bp_tab_designs', 'Designs'),
            lead: T('bp_designs_lead', 'Click a card to start placing it in the world.'),
            info: T('bp_designs_info',
                'Badges come from the 2026-07-29 blueprint audit. <b>No design has windows</b> -- site1\'s <code>tworst_buildwindow</code> never made it into the exports. The thumbnail is the real slab footprint, drawn from the blueprint itself.'
                + 'site1\'s <code>tworst_buildwindow</code> never made it into the exports. Pictures are '
                + 'the real site, shot in-game by /permshoot; the footprint plan is drawn only where a picture is missing.'),
            body: `<div class="tw-filters">${chips}</div>`
                + (shown.length ? `<div class="tw-grid">${cards}</div>`
                    : `<div class="tw-empty">${esc(T('bp_no_match', 'No matching design'))}</div>`),
            bind: (root) => {
                root.querySelectorAll('[data-filter]').forEach((el) => {
                    el.addEventListener('click', () => { designFilter = el.dataset.filter; render(); });
                });
                bindRowActions(root);
            },
        };
    }

    function renderHealth() {
        const list = store.health || [];
        const ICON = { error: '✕', warn: '!', pending: '⏳' };
        const rows = list.map((h) => `
            <div class="tw-health ${esc(h.level)}">
                <span class="tw-h-ico">${ICON[h.level] || '•'}</span>
                <span>${esc(h.text)}</span>
            </div>`).join('');

        return {
            title: T('bp_tab_health', 'Health'),
            lead: T('bp_health_lead', 'Problems that would break a job silently.'),
            info: T('bp_health_info',
                'The checks are the same ones in <code>server/core/config_validator.lua</code> -- one truth, not two. <b>&#10005;</b> the job breaks silently &middot; <b>!</b> visual or logic risk &middot; <b>&#8987;</b> saved to file but not live this session.'
                + '<b>✕</b> the job breaks silently · <b>!</b> visual or logic risk · <b>⏳</b> saved to file but not live this session.'),
            body: list.length ? `<div class="tw-rows">${rows}</div>`
                : `<div class="tw-empty">${esc(T('bp_all_good', 'All good'))}</div>`,
        };
    }

    const VIEWS = [
        ['sites', () => T('bp_tab_sites', 'Sites'), renderSites],
        ['zones', () => T('bp_tab_zones', 'Zones'), renderZones],
        ['designs', () => T('bp_tab_designs', 'Designs'), renderDesigns],
        ['health', () => T('bp_tab_health', 'Health'), renderHealth],
    ];

    function render() {
        if (!g('tw-root')) return;

        const counts = {
            sites: (store.sites || []).length,
            zones: (store.zones || []).length,
            designs: Object.keys(blueprints).length,
            health: (store.health || []).filter((h) => h.level === 'error').length,
        };

        const nav = g('tw-nav');
        nav.querySelectorAll('.tw-nav-item').forEach((e) => e.remove());
        if (!g('tw-nav-ind')) {
            const ind = document.createElement('div');
            ind.className = 'tw-nav-ind';
            ind.id = 'tw-nav-ind';
            nav.insertBefore(ind, nav.firstChild);
        }
        VIEWS.forEach(([key, label]) => {
            const el = document.createElement('div');
            el.className = 'tw-nav-item' + (key === view ? ' on' : '')
                + (key === 'health' && counts.health ? ' alert' : '');
            el.innerHTML = `<span>${esc(label())}</span><span class="tw-nav-n">${counts[key]}</span>`;
            el.addEventListener('click', () => { view = key; infoOpen = false; render(); });
            nav.appendChild(el);
        });

        const def = (VIEWS.find((v) => v[0] === view) || VIEWS[0])[2]();
        g('tw-head-title').textContent = def.title;
        g('tw-head-lead').textContent = def.lead;

        const info = g('tw-info');
        const infoBtn = g('tw-info-btn');
        if (def.info) {
            infoBtn.style.display = '';
            info.innerHTML = def.info;
            info.classList.toggle('on', infoOpen);
            infoBtn.classList.toggle('on', infoOpen);
        } else {
            infoBtn.style.display = 'none';
            info.classList.remove('on');
        }

        const body = g('tw-body');
        body.innerHTML = def.body;
        if (def.bind) def.bind(body);
        body.classList.remove('tw-pane');
        void body.offsetWidth;
        body.classList.add('tw-pane');
        moveNavInd();

        const pend = (store.sites || []).filter((s) => s.pendingRestart).length
            + (store.health || []).filter((h) => h.level === 'pending').length;
        const pendEl = g('tw-pending');
        pendEl.classList.toggle('on', pend > 0);
        if (pend > 0) {
            pendEl.innerHTML = `<span>⏳</span><span>${esc(T('bp_pending_n', '%s record(s) waiting').replace('%s', pend))}<br>
                <code>restart tw-builderjob</code></span>`;
        }
    }

    function moveNavInd() {
        const nav = g('tw-nav');
        if (!nav) return;
        const on = nav.querySelector('.tw-nav-item.on');
        const ind = g('tw-nav-ind');
        if (!on || !ind) return;
        ind.style.top = on.offsetTop + 'px';
        ind.style.height = on.offsetHeight + 'px';
    }

    function injectMarkup() {
        if (g('tw-root')) return;

        const root = document.createElement('div');
        root.id = 'tw-root';
        root.innerHTML = `
            <div class="tw-shell">
                <div class="newTitleBox">
                    <div class="newTitleIcon"><img src="./img/newLogo.png" alt="" class="newLogo"></div>
                    <div class="newTitleTextBox">
                        <h2 class="newTitleText">Tworst</h2>
                        <p class="newTitleSubText">Site</p>
                    </div>
                </div>
                <div class="tw-panel">
                    <aside class="tw-side">
                        <div class="tw-nav" id="tw-nav"><div class="tw-nav-ind" id="tw-nav-ind"></div></div>
                        <div class="tw-side-foot">
                        <div class="tw-pending" id="tw-pending"></div>
                        <button class="tw-btn danger" id="tw-clearall" type="button">${esc(T('bp_clear_all', 'Clear placed houses'))}</button>
                    </div>
                </aside>
                <section class="tw-main">
                    <div class="tw-head">
                        <div>
                            <h3 id="tw-head-title"></h3>
                            <p id="tw-head-lead"></p>
                        </div>
                        <div class="tw-head-act">
                            <button class="tw-icon-btn" id="tw-info-btn" type="button"
                                title="${esc(T('bp_why', 'Why this matters'))}">?</button>
                            <button id="tw-close" type="button" title="${esc(T('bp_close', 'Close'))}">✕</button>
                        </div>
                    </div>
                    <div class="tw-info" id="tw-info"></div>
                    <div class="tw-body" id="tw-body"></div>
                </section>
                </div>
            </div>`;
        document.body.appendChild(root);

        g('tw-close').addEventListener('click', () => fetchAPI('closeMenu'));
        g('tw-info-btn').addEventListener('click', () => { infoOpen = !infoOpen; render(); });
        g('tw-clearall').addEventListener('click', (e) =>
            confirmBtn(e.currentTarget, T('bp_clear_all', 'Clear placed houses'), () => fetchAPI('clearAll')));

        ['bp-save', 'bp-ctl-root', 'bp-hud', 'bp-toast'].forEach((id) => {
            const el = document.createElement('div');
            el.id = id;
            el.className = id;
            document.body.appendChild(el);
        });
    }

    function showMenu(d) {
        injectMarkup();
        blueprints = d.blueprints || {};
        const r = g('tw-root');
        r.style.display = 'block';
        render();
        requestAnimationFrame(() => requestAnimationFrame(() => {
            if (g('tw-root')) { g('tw-root').classList.add('visible'); moveNavInd(); }
        }));
        fetchAPI('requestSites');
    }

    function hideMenu() {
        const r = g('tw-root');
        if (!r) return;
        r.classList.remove('visible');
        setTimeout(() => {
            if (r && !r.classList.contains('visible')) r.style.display = 'none';
        }, 260);
    }

    const MODE_LABEL = () => ({
        walk: T('bp_mode_walk', 'WALK'),
        orbit: T('bp_mode_orbit', 'ORBIT'),
        free: T('bp_mode_free', 'FREE CAM'),
    });

    function keysFor(mode) {
        const rot = ['◄ ►', T('bp_k_rotate', 'Rotate')];
        const tab = ['TAB', T('bp_k_panel', 'Panel')];
        const enter = ['ENTER', T('bp_k_confirm', 'Confirm'), 'go'];
        const back = ['⌫', T('bp_k_cancel', 'Cancel'), 'stop'];
        if (mode === 'free') {
            return [['Mouse', T('bp_k_look', 'Look')], ['WASD', T('bp_k_fly', 'Fly camera')],
                ['F', T('bp_k_bring', 'House to cursor')], rot,
                ['V', T('bp_k_orbit_back', 'Orbit')], tab, enter, back];
        }
        if (mode === 'orbit') {
            return [['Mouse', T('bp_k_orbit', 'Orbit')], ['Wheel', T('bp_k_zoom', 'Zoom')],
                ['WASD', T('bp_k_move', 'Move house')], rot,
                ['↑ ↓', T('bp_k_height', 'Height')], ['G', T('bp_k_snap', 'Snap to ground')], tab, enter, back];
        }
        return [['WASD', T('bp_k_walk', 'Walk')], rot, ['↑ ↓', T('bp_k_height', 'Height')],
            ['SPACE', T('bp_k_camera', 'Camera')], tab, enter, back];
    }

    function verdict(s) {
        const gr = s.ground;
        const groundLvl = gr ? gr.level : 1;
        return {
            ground: groundLvl,
            zone: s.zoneOk ? 0 : 1,
            near: s.nearWarn ? 1 : 0,
        };
    }

    function stepRail(s) {
        const v = verdict(s);
        const worst = Math.max(v.ground, v.zone, v.near);
        const steps = [
            [1, T('bp_step_design', 'Design'), 'done'],
            [2, T('bp_step_place', 'Position'), 'on'],
            [3, T('bp_step_check', 'Checks'), worst === 0 ? 'done' : ''],
            [4, T('bp_step_save', 'Save'), ''],
        ];
        return `<div class="bp-steps">${steps.map(([n, lbl, cls], i) => `
            ${i ? '<div class="bp-step-sep"></div>' : ''}
            <div class="bp-step ${cls}"><span class="bp-step-n">${cls === 'done' ? '✓' : n}</span>${esc(lbl)}</div>`).join('')}</div>`;
    }

    function tile(cls, k, v, sub) {
        return `<div class="bp-tile ${cls}">
            <span class="bp-tile-k">${esc(k)}</span>
            <span class="bp-tile-v">${esc(v)}</span>
            ${sub ? `<span class="bp-tile-sub">${esc(sub)}</span>` : ''}
        </div>`;
    }

    function buildHUD(state) {
        const hud = g('bp-hud');
        if (!hud) return;
        if (!state) { hud.classList.remove('visible'); return; }

        const s = state;
        const mode = s.mode || 'orbit';
        const gr = s.ground;
        const LVL = ['ok', 'warn', 'bad'];

        const groundTile = gr
            ? tile(LVL[gr.level] || 'warn', T('bp_t_ground', 'Ground'),
                `${gr.verdict} · Δ${fmt(gr.delta)} m`,
                `${T('bp_t_sunk', 'sunk')} ${fmt(gr.gomulu)} · ${T('bp_t_air', 'air')} ${fmt(gr.bosta)}`)
            : tile('warn', T('bp_t_ground', 'Ground'), T('bp_measuring', 'measuring…'));

        const zoneTile = s.zoneOk
            ? tile('ok', T('bp_t_zone', 'Zone'), s.zone)
            : tile('warn', T('bp_t_zone', 'Zone'), T('bp_zone_auto', 'will be generated'));

        const nearTile = (s.nearId && typeof s.nearDist === 'number')
            ? tile(s.nearWarn ? 'bad' : 'ok', T('bp_t_nearest', 'Nearest'), s.nearId, `${fmt(s.nearDist, 0)} m`)
            : tile('ok', T('bp_t_nearest', 'Nearest'), T('bp_none_near', 'clear'));

        hud.innerHTML = `
            ${stepRail(s)}
            <div class="bp-status">
                <div class="bp-hud-design">
                    <strong>${esc((s.designId || '?').replace(/^DESIGN_/, ''))}</strong>
                    <span class="bp-hud-mode">${esc(MODE_LABEL()[mode] || mode)}</span>
                </div>
                ${groundTile}
                ${zoneTile}
                ${nearTile}
                ${tile('', T('bp_t_pos', 'Position'), `${fmt(s.x, 1)}  ${fmt(s.y, 1)}`,
                    `${fmt(s.heading, 0)}° · Z${fmt(s.zOffset, 2)}`)}
            </div>
            <div class="bp-keys">${(() => {
                const keys = keysFor(mode);
                return keys.map(([k, d, cls], i) => {
                    // One divider where the plain keys end and the two
                    // commit keys begin — confirm/cancel read as a decision,
                    // not as two more entries in a list.
                    const sep = (cls && i > 0 && !keys[i - 1][2]) ? '<div class="bp-key-sep"></div>' : '';
                    return `${sep}<span class="bp-key ${cls || ''}"><kbd>${k}</kbd>${esc(d)}</span>`;
                }).join('');
            })()}</div>`;
        hud.classList.add('visible');
    }

    function cmd(action, value) { fetchAPI('placeCmd', { action, value }); }
    function cmdThrottled(action, value) {
        const now = Date.now();
        if (now - lastCmd < 60) return;
        lastCmd = now; cmd(action, value);
    }

    function grp(label, value, inner) {
        return `<div class="bp-grp">
            <div class="bp-grp-k"><span>${esc(label)}</span>${value !== undefined && value !== null
                ? `<span class="bp-grp-v">${esc(value)}</span>` : ''}</div>
            ${inner}
        </div>`;
    }


    let stageTab = false;
    let stageData = [];

    const STAGE_LABEL = {
        plank: 'Formwork', wire: 'Mesh', pole: 'Column', rebar: 'Rebar',
        ground: 'Wall', ceiling: 'Ceiling',
        upperWall: 'Upper wall', upperCeiling: 'Upper ceiling',
    };

    function stageNum(key, field, val, step, title) {
        const v = (val === null || val === undefined) ? '' : fmt(val, 3);
        return `<label class="bp-sf" title="${esc(title || '')}">`
            + `<span>${esc(field)}</span>`
            + `<input type="number" step="${step}" value="${v}"`
            + ` data-sset="${esc(key)}" data-sfield="${esc(field)}"></label>`;
    }

    function stageVec(key, field, arr) {
        const a = arr || [0, 0, 0];
        return ['x', 'y', 'z'].map((ax, i) =>
            `<label class="bp-sf"><span>${esc(field)}.${ax}</span>`
            + `<input type="number" step="0.01" value="${fmt(a[i], 3)}"`
            + ` data-svec="${esc(key)}" data-sfield="${esc(field)}" data-saxis="${ax}"></label>`
        ).join('');
    }

    function stageRow(st) {
        const sel = st.sel ? ' sel' : '';
        const edited = st.edited
            ? badge('pend', T('bp_st_edited', 'CHANGED'), T('bp_st_edited_t', 'This stage differs from the default'))
            : '';
        const geo = st.hand ? '' : (
            stageNum(st.key, 'dx', st.dx, '0.1', 'Offset west of the house (m)')
            + stageNum(st.key, 'dy', st.dy, '0.1', 'Offset along Y from the house centre (m)')
            + stageNum(st.key, 'dz', st.dz, '0.05', 'Ground offset (m)')
            + stageNum(st.key, 'points', st.points, '1', 'How many SEPARATE piles')
            + stageNum(st.key, 'spread', st.spread, '0.1', 'Distance between the outermost piles (m)')
        );
        return `<div class="bp-stage${sel}" data-ssel="${esc(st.key)}">
            <div class="bp-stage-h">
                <b>${st.step}. ${esc(STAGE_LABEL[st.key] || st.key)}</b>
                <span class="tw-dim tw-mono">${st.count} ${esc(T('bp_st_pieces', 'pieces'))}</span>
                ${edited}
                <button type="button" class="tw-btn" data-sreset="${esc(st.key)}">${esc(T('bp_st_reset', 'Reset'))}</button>
            </div>
            <div class="bp-stage-b">
                ${geo}
                ${stageNum(st.key, 'perStack', st.perStack, '1', 'Pieces stacked per pile')}
                ${stageVec(st.key, 'stackStep', st.stackStep)}
                ${stageVec(st.key, 'rot', st.rot)}
            </div>
        </div>`;
    }

    function stageKeys() {
        const k = (key, what) => `<span><b>${esc(key)}</b>${esc(what)}</span>`;
        return `<div class="bp-stage-keys">
            ${k('SOL TIK', T('bp_gz_drag', 'drag the pile'))}
            ${k('SAG TIK', T('bp_gz_cam', 'orbit camera'))}
            ${k('TEKERLEK', T('bp_gz_dz', 'height'))}
            ${k('SHIFT+TEK', T('bp_gz_spread', 'spacing'))}
            ${k('CTRL+TEK', T('bp_gz_stack', 'stack count'))}
        </div>`;
    }

    function stageMarkup() {
        if (!stageData.length) {
            return `<div class="tw-empty">${esc(T('bp_st_none', 'Place a design first'))}</div>`;
        }
        return `<div class="bp-stage-lead">${esc(T('bp_st_lead',
            'The selected stage is shown translucent in the world. An empty field = default.'))}</div>`
            + stageKeys()
            + stageData.map(stageRow).join('')
            + `<div class="bp-stage-foot">
                 <button type="button" class="tw-btn" data-sreset="">${esc(T('bp_st_reset_all', 'Reset all'))}</button>
               </div>`;
    }

    function bindStages(root) {
        root.querySelectorAll('[data-ssel]').forEach((el) => {
            el.addEventListener('click', (ev) => {
                if (ev.target.closest('input,button')) return;
                cmd('stageSel', el.getAttribute('data-ssel'));
                stageData.forEach((s) => { s.sel = (s.key === el.getAttribute('data-ssel')); });
                el.parentNode.querySelectorAll('.bp-stage').forEach((n) => n.classList.remove('sel'));
                el.classList.add('sel');
            });
        });
        root.querySelectorAll('[data-sset]').forEach((el) => {
            el.addEventListener('change', () => {
                const raw = el.value.trim();
                cmd('stageSet', {
                    key: el.getAttribute('data-sset'),
                    field: el.getAttribute('data-sfield'),
                    value: raw === '' ? '' : Number(raw),
                });
            });
        });
        root.querySelectorAll('[data-svec]').forEach((el) => {
            el.addEventListener('change', () => {
                cmd('stageVec', {
                    key: el.getAttribute('data-svec'),
                    field: el.getAttribute('data-sfield'),
                    axis: el.getAttribute('data-saxis'),
                    value: Number(el.value || 0),
                });
            });
        });
        root.querySelectorAll('[data-sreset]').forEach((el) => {
            el.addEventListener('click', () => cmd('stageReset', el.getAttribute('data-sreset')));
        });
    }

    function panelMarkup(s) {
        const mode = s.mode || 'orbit';
        const opts = designs.map((d) =>
            `<option value="${esc(d)}" ${d === s.designId ? 'selected' : ''}>${esc(d.replace(/^DESIGN_/, ''))}</option>`).join('');
        const seg = (id, list, cur) => list.map(([v, lbl]) =>
            `<button type="button" class="bp-seg${String(cur) === String(v) ? ' on' : ''}" data-seg="${id}" data-v="${v}">${esc(lbl)}</button>`).join('');
        const btns = (attr, list) => `<div class="bp-btns">${list.map(([v, lbl]) =>
            `<button type="button" ${attr}="${v}">${esc(lbl)}</button>`).join('')}</div>`;

        return `
        <div class="bp-ctl">
            <div class="bp-ctl-head">
                <strong>${esc(T('bp_ctl_title', 'Placement'))}</strong>
                <span class="bp-hud-mode">${esc(MODE_LABEL()[mode] || mode)}</span>
            </div>
            <div class="bp-ctl-tabs">
                <button type="button" class="bp-tab on" data-ptab="pos">${esc(T('bp_tab_pos', 'POSITION'))}</button>
                <button type="button" class="bp-tab" data-ptab="stage">${esc(T('bp_tab_stage', 'STAGES'))}</button>
            </div>
            <div class="bp-ctl-body" id="bp-ctl-pos">
                ${grp(T('bp_design', 'Design'), null, `<select class="bp-sel" id="bp-c-design">${opts}</select>`)}
                ${grp(T('bp_ctl_rotate', 'Rotation'), `${(s.heading || 0).toFixed(1)}°`,
                    btns('data-rot', [[-90, '−90'], [-15, '−15'], [-1, '−1'], [1, '+1'], [15, '+15'], [90, '+90']])
                    + `<input id="bp-c-head" class="bp-num" type="number" step="1" value="${(s.heading || 0).toFixed(1)}" style="margin-top:calc(.2083 * var(--u))">`)}
                ${grp(T('bp_ctl_z', 'Height offset'), `${(s.zOffset || 0).toFixed(2)} m`,
                    btns('data-dz', [[-0.5, '−0.50'], [-0.05, '−0.05'], [0.05, '+0.05'], [0.5, '+0.50']]))}
                ${grp(T('bp_ctl_snap', 'Snap to ground'), null,
                    `<div class="bp-btns">${seg('snap', [[0, T('bp_snap_off', 'FREE (manual Z)')], [1, T('bp_snap_median', 'ON GROUND')], [2, T('bp_snap_high', 'ON GROUND (no sinking)')]], s.snapMode)}</div>`)}
                ${grp(T('bp_ctl_camera', 'Camera'), null,
                    `<div class="bp-btns">${seg('mode', [['walk', T('bp_mode_walk', 'WALK')], ['orbit', T('bp_mode_orbit', 'ORBIT')], ['free', T('bp_mode_free', 'FREE CAM')]], mode)}</div>`)}
                ${grp(T('bp_ctl_zoom', 'Zoom'), `${fmt(s.camDist, 0)} m`,
                    `<input id="bp-c-zoom" class="bp-range" type="range" min="8" max="120" step="1" value="${Math.round(s.camDist || 45)}">`)}
                ${mode === 'free'
                    ? grp(T('bp_ctl_camz', 'Camera height'), `${fmt(s.camZ, 1)} m`,
                        btns('data-camz', [[-5, '−5'], [-1, '−1'], [1, '+1'], [5, '+5']]))
                    : grp(T('bp_ctl_pitch', 'Pitch'), `${fmt(s.camPitch, 0)}°`,
                        `<input id="bp-c-pitch" class="bp-range" type="range" min="-10" max="88" step="1" value="${Math.round(s.camPitch || 35)}">`)}
                <div class="bp-save-note">${T('bp_ctl_legend',
                    'In the world: <b>blue</b> outline = other sites, <b>cyan</b> = zone borders, <b>green</b> square = the zone that will be created on save.'
                    + '<b>green</b> square = the zone that will be created on save.')}</div>
            </div>
            <div class="bp-ctl-body bp-stage-body" id="bp-ctl-stages" style="display:none">
                ${stageMarkup()}
            </div>
            <div class="bp-ctl-foot">
                <button type="button" class="tw-btn" id="bp-c-cam">${esc(T('bp_ctl_back', 'Back to camera'))}</button>
                <button type="button" class="tw-btn danger" id="bp-c-cancel">${esc(T('bp_cancel', 'Cancel'))}</button>
                <button type="button" class="tw-btn primary" id="bp-c-confirm">${esc(T('bp_confirm', 'Confirm'))}</button>
            </div>
        </div>`;
    }

    function bindPanel() {
        const box = g('bp-ctl-root');
        if (!box) return;
        box.querySelectorAll('[data-rot]').forEach((b) => b.addEventListener('click', () => cmd('rotate', parseFloat(b.dataset.rot))));
        box.querySelectorAll('[data-dz]').forEach((b) => b.addEventListener('click', () => cmd('zoffset', parseFloat(b.dataset.dz))));
        box.querySelectorAll('[data-camz]').forEach((b) => b.addEventListener('click', () => cmd('camz', parseFloat(b.dataset.camz))));
        box.querySelectorAll('[data-seg]').forEach((b) => b.addEventListener('click', () => {
            if (b.dataset.seg === 'snap') cmd('snap', parseInt(b.dataset.v, 10));
            else if (b.dataset.v === 'walk') cmd('walk');
            else cmd('cammode', b.dataset.v);
        }));
        if (g('bp-c-design')) g('bp-c-design').addEventListener('change', (e) => cmd('design', e.target.value));
        if (g('bp-c-head')) g('bp-c-head').addEventListener('change', (e) => cmd('setheading', parseFloat(e.target.value)));
        if (g('bp-c-zoom')) g('bp-c-zoom').addEventListener('input', (e) => cmdThrottled('zoom', parseFloat(e.target.value)));
        if (g('bp-c-pitch')) g('bp-c-pitch').addEventListener('input', (e) => cmdThrottled('pitch', parseFloat(e.target.value)));
        box.querySelectorAll('[data-ptab]').forEach((b) => b.addEventListener('click', () => {
            const stage = b.dataset.ptab === 'stage';
            box.querySelectorAll('[data-ptab]').forEach((n) => n.classList.toggle('on', n === b));
            const pos = g('bp-ctl-pos'), stg = g('bp-ctl-stages');
            if (pos) pos.style.display = stage ? 'none' : '';
            if (stg) stg.style.display = stage ? '' : 'none';
            stageTab = stage;
            cmd('stageGhosts', stage);
        }));
        const stageBox = g('bp-ctl-stages');
        if (stageBox) bindStages(stageBox);
        const panel = box.querySelector('.bp-ctl');
        (panel || box).addEventListener('mouseenter', () => cmd('stageHover', true));
        (panel || box).addEventListener('mouseleave', () => cmd('stageHover', false));

        g('bp-c-cam').addEventListener('click', () => cmd('closePanel'));
        g('bp-c-cancel').addEventListener('click', () => cmd('cancel'));
        g('bp-c-confirm').addEventListener('click', () => cmd('confirm'));
    }

    function showPanel(d) {
        stageData = Array.isArray(d.stages) ? d.stages : [];
        injectMarkup();
        const root = g('bp-ctl-root');
        const s = d.state || {};
        if (d.designs) designs = d.designs;
        root.innerHTML = panelMarkup(s);
        root.classList.add('visible');
        bindPanel();
    }

    let panelMode = null;
    function panelState(s) {
        const root = g('bp-ctl-root');
        if (!root || !root.classList.contains('visible')) return;
        if (s.mode !== panelMode) {
            panelMode = s.mode;
            root.innerHTML = panelMarkup(s);
            bindPanel();
            return;
        }
        const vals = root.querySelectorAll('.bp-grp-v');
        if (vals[0]) vals[0].textContent = `${(s.heading || 0).toFixed(1)}°`;
        if (vals[1]) vals[1].textContent = `${(s.zOffset || 0).toFixed(2)} m`;
        root.querySelectorAll('[data-seg="snap"]').forEach((b) => b.classList.toggle('on', String(s.snapMode) === b.dataset.v));
        root.querySelectorAll('[data-seg="mode"]').forEach((b) => b.classList.toggle('on', s.mode === b.dataset.v));
    }

    function hidePanel() {
        const root = g('bp-ctl-root');
        if (root) { root.classList.remove('visible'); root.innerHTML = ''; }
        panelMode = null;
    }

    function houseCard(h, selected, recommended) {
        const png = h.img || `./img/houses/${h.model}.webp`;
        const jpg = `./img/houses/${h.model}.jpg`;
        const onerr = h.img
            ? "this.style.display='none';this.parentNode.classList.add('noimg')"
            : `if(!this.dataset.f){this.dataset.f=1;this.src='${jpg}';}`
              + `else{this.style.display='none';this.parentNode.classList.add('noimg');}`;
        const src = png;
        const cls = ['bp-house']
            .concat(selected ? ['on'] : [])
            .concat(recommended ? ['rec'] : [])
            .concat(h.valid ? [] : ['bad'])
            .join(' ');
        const badge = recommended
            ? `<span class="tw-badge f2">${esc(T('bp_house_rec', 'RECOMMENDED'))}</span>`
            : (h.ours
                ? `<span class="tw-badge f2">${esc(T('bp_house_ours', 'OURS'))}</span>`
                : (h.valid ? '' : `<span class="tw-badge bad">${esc(T('bp_house_missing', 'NOT STREAMED'))}</span>`));
        return `
        <div class="${cls}" data-house="${esc(h.model)}"
             title="${esc(h.valid ? h.model : T('bp_house_missing_t', 'This server cannot stream that model'))}">
            <div class="bp-house-img">
                <img src="${esc(src)}" alt="" loading="lazy" onerror="${onerr}">
                <span class="bp-house-fallback">${esc(h.label)}</span>
                ${badge}
            </div>
            <div class="bp-house-name">${esc(h.label)}</div>
            <div class="bp-house-model">${esc(h.model)}</div>
            <button type="button" class="tw-btn bp-house-eye" data-preview="${esc(h.model)}"
                ${h.valid ? '' : 'disabled'}>${esc(T('bp_house_preview', 'Preview'))}</button>
        </div>`;
    }

    function matchedRow(auto, override) {
        if (!auto) {
            return `<div class="bp-check-row bad"><span class="ico">✕</span><span>${esc(
                T('bp_no_house_match', 'This design has no finished house mapped — pick one below'))}</span></div>`;
        }
        const overridden = !!override && override !== auto;
        return `
        <div class="bp-matched${overridden ? ' off' : ''}">
            <div class="bp-matched-l">
                <div class="k">${esc(overridden
                    ? T('bp_matched_off', 'Design match (overridden)')
                    : T('bp_matched', 'Design match — used automatically'))}</div>
                <div class="v tw-mono">${esc(auto)}</div>
            </div>
            <button type="button" class="tw-btn" data-preview="${esc(auto)}">${esc(T('bp_house_preview', 'Preview'))}</button>
            ${overridden ? `<button type="button" class="tw-btn" id="bp-f-clearover">${esc(T('bp_use_match', 'Use match'))}</button>` : ''}
        </div>`;
    }

    function houseGrid(list, selected, auto) {
        if (!Array.isArray(list) || !list.length) return '';
        const missing = list.filter((h) => !h.valid).length;

        const rank = (h) => (h.model === auto ? 0 : (h.ours ? 1 : 2));
        const sorted = list.slice().sort((a, b) => rank(a) - rank(b));

        return `
        <div class="bp-house-wrap">
            <div class="bp-house-head">
                <span>${esc(T('bp_house_pick', 'Or pick a different one'))}</span>
                ${missing ? `<span class="bad">${esc(T('bp_house_n_missing', '%d not streamed').replace('%d', missing))}</span>` : ''}
            </div>
            <div class="bp-house-grid">${sorted.map((h) =>
                houseCard(h, h.model === selected, h.model === auto)).join('')}</div>
            <div class="bp-house-hint">${esc(T('bp_house_hint',
                'Preview puts the real model on the plot. Pictures come from /permshoot.'))}</div>
        </div>`;
    }

    function showSave(d) {
        injectMarkup();
        saveCtx = d || {};
        const s = saveCtx.site || {};
        const az = saveCtx.autoZone;
        const editing = !!saveCtx.editing;
        const modal = g('bp-save');
        const zoneOpts = (saveCtx.zones || []).map((z) =>
            `<option value="${esc(z)}" ${z === s.zoneId ? 'selected' : ''}>${esc(z)}</option>`).join('');

        const checks = [];
        if (saveCtx.zoneOk) {
            checks.push(['ok', '✓', T('bp_chk_zone_ok', 'Inside zone %s').replace('%s', s.zoneId || '')]);
        } else if (az) {
            checks.push(['warn', '!', T('bp_chk_zone_auto', 'No zone here — one will be created (%s m across)').replace('%s', fmt(az.radius * 2, 0))]);
        } else {
            checks.push(['bad', '✕', T('bp_chk_zone_none', 'Not inside any zone and none could be computed — pick one below')]);
        }
        if (saveCtx.nearWarn) {
            checks.push(['bad', '✕', T('bp_chk_near', 'Only %d m from %s — the houses will overlap')
                .replace('%d', fmt(saveCtx.nearDist, 1)).replace('%s', saveCtx.nearId || '')]);
        } else {
            checks.push(['ok', '✓', T('bp_chk_near_ok', 'No site too close')]);
        }
        if (saveCtx.groundBad) {
            checks.push(['warn', '!', T('bp_chk_ground', 'Sloped ground (Δ %s m) — one side sunk, the other in the air')
                .replace('%s', fmt(saveCtx.groundDelta))]);
        } else {
            checks.push(['ok', '✓', T('bp_chk_ground_ok', 'Ground is flat enough')]);
        }
        if (editing) {
            checks.push(['warn', '!', T('bp_chk_editing', 'Updating %s. A config site moves to JSON as an override — delete the record and the config value returns.')
                .replace('%s', saveCtx.editing)]);
        }

        const perm = saveCtx.perm || { enabled: false, known: [] };
        const permOn = !!saveCtx.permanent;
        const known = (perm.known || []);
        const permBlock = !perm.enabled ? '' : `
            <label class="bp-toggle${permOn ? ' on' : ''}" id="bp-f-permwrap">
                <input id="bp-f-perm" type="checkbox" ${permOn ? 'checked' : ''}>
                <span>${esc(T('bp_perm_tick', 'Permanent house (region 14) — the finished house stays here'))}</span>
            </label>
            <div class="bp-auto-body" id="bp-f-permbody">
                ${matchedRow(saveCtx.autoModel, saveCtx.exteriorModel)}
                <label class="bp-field"><span>${esc(T('bp_ext_override', 'Override (leave empty to use the match)'))}</span>
                    <input id="bp-f-extmodel" type="text" list="bp-f-extlist" spellcheck="false" maxlength="64"
                        placeholder="${esc(saveCtx.autoModel || '')}" value="${esc(saveCtx.exteriorModel || '')}"></label>
                <datalist id="bp-f-extlist">${known.map((m) => `<option value="${esc(m)}"></option>`).join('')}</datalist>
                ${houseGrid(saveCtx.houses, saveCtx.exteriorModel, saveCtx.autoModel)}
                <div class="bp-auto-info">${esc(T('bp_perm_info',
                    'The single prop that replaces the ~100 construction pieces at 100%. Its offsets are measured once per model in config/systems/permanent_house.lua.'))}</div>
            </div>`;

        const a = s.anchor || [];
        modal.innerHTML = `
            <div class="bp-save-box">
                <div class="bp-save-head">
                    <h3>${esc(editing ? T('bp_save_update', 'Update site') : T('bp_save_new', 'Save as site'))}</h3>
                    <p>${esc(s.designId || '')} · ${fmt(a[0])}, ${fmt(a[1])}, ${fmt(a[2])} · ${fmt(a[3], 1)}°</p>
                </div>
                <div class="bp-save-body">
                    <div class="bp-checks">
                        ${checks.map(([lvl, ico, txt]) =>
                            `<div class="bp-check-row ${lvl}"><span class="ico">${ico}</span><span>${esc(txt)}</span></div>`).join('')}
                    </div>
                    ${!az && saveCtx.insideZone ? `
                    <div class="bp-check-row warn"><span class="ico">!</span><span>${esc(
                        T('bp_no_autozone', 'You are standing inside zone "%z" — no zone can be created here. Move the house outside it, or build one in the Zones tab. Two sites sharing a zone will not load.')
                        .replace('%z', saveCtx.insideZone))}</span></div>` : ''}
                    ${az ? `
                    <label class="bp-toggle on" id="bp-f-autowrap">
                        <input id="bp-f-autozone" type="checkbox" checked>
                        <span>${esc(T('bp_auto_zone', 'Create a zone here automatically'))}</span>
                    </label>
                    <div class="bp-auto-body">
                        <label class="bp-field"><span>${esc(T('bp_zone_name', 'Zone name'))}</span>
                            <input id="bp-f-zname" type="text" value="${esc(az.name)}" maxlength="32" spellcheck="false"></label>
                        <div class="bp-auto-info">${esc(T('bp_auto_info', '%r m across · site spread %s m + %m m margin, following the house heading')
                            .replace('%r', fmt(az.radius * 2, 0)).replace('%s', fmt(az.siteSpan, 0))
                            .replace('%m', fmt(az.margin != null ? az.margin : (az.radius - az.siteSpan / 2), 0)))}</div>
                    </div>` : ''}
                    ${permBlock}
                    <label class="bp-field"><span>${esc(T('bp_f_id', 'Identifier'))}</span>
                        <input id="bp-f-id" type="text" value="${esc(s.id || '')}" maxlength="24" spellcheck="false" ${editing ? 'readonly' : ''}></label>
                    <label class="bp-field"><span>${esc(T('bp_f_label', 'Label'))}</span>
                        <input id="bp-f-label" type="text" value="${esc(s.label || '')}" maxlength="48"></label>
                    <label class="bp-field${az ? ' dim' : ''}" id="bp-f-zonerow"><span>${esc(T('bp_zone', 'Zone'))}</span>
                        <select id="bp-f-zone"><option value="">— ${esc(T('bp_pick', 'pick'))} —</option>${zoneOpts}</select></label>
                    <div class="bp-check-row bad" id="bp-f-zonetaken" style="display:none"><span class="ico">x</span><span id="bp-f-zonetaken-t"></span></div>
                    ${saveCtx.nearWarn ? `
                    <label class="bp-toggle"><input id="bp-f-force" type="checkbox">
                        <span>${esc(T('bp_accept_overlap', 'Accept the overlap and save anyway'))}</span></label>` : ''}
                    <div class="bp-save-foot">
                        <button type="button" class="tw-btn" id="bp-f-cancel">${esc(T('bp_dont_save', 'Don\'t save'))}</button>
                        <button type="button" class="tw-btn primary" id="bp-f-save">${esc(editing ? T('bp_update', 'Update') : T('bp_save', 'Save'))}</button>
                    </div>
                    <div class="bp-save-note">${T('bp_save_note',
                        'Written to <code>config/data/plank_sites.json</code> &middot; goes live after <code>restart tw-builderjob</code>')}</div>
                </div>
            </div>`;
        modal.classList.add('visible');

        const autoBox = g('bp-f-autozone');
        if (autoBox) {
            const sync = () => {
                g('bp-f-zonerow').classList.toggle('dim', autoBox.checked);
                const body = modal.querySelector('.bp-auto-body');
                if (body) body.style.display = autoBox.checked ? '' : 'none';
                g('bp-f-autowrap').classList.toggle('on', autoBox.checked);
            };
            autoBox.addEventListener('change', sync); sync();
        }

        const zoneSel = g('bp-f-zone');
        if (zoneSel) {
            const warnRow = g('bp-f-zonetaken');
            const warnTxt = g('bp-f-zonetaken-t');
            const myId = (saveCtx.site && saveCtx.site.id) || '';
            const zoneTaken = () => {
                const useAuto = !!(autoBox && autoBox.checked && az);
                const zid = useAuto ? '' : zoneSel.value;
                let owner = null;
                if (zid) {
                    (store.sites || []).forEach((o) => {
                        if (o.zoneId === zid && o.id !== myId) owner = owner || o.id;
                    });
                }
                if (owner) {
                    warnTxt.textContent = T('bp_zone_taken',
                        'Zone "%z" already belongs to %s. Two sites in one zone cannot both load — give this one its own zone.')
                        .replace('%z', zid).replace('%s', owner);
                    warnRow.style.display = '';
                } else {
                    warnRow.style.display = 'none';
                }
            };
            zoneSel.addEventListener('change', zoneTaken);
            if (autoBox) autoBox.addEventListener('change', zoneTaken);
            zoneTaken();
        }

        const anchor = saveCtx.site && saveCtx.site.anchor;
        modal.querySelectorAll('[data-house]').forEach((el) => {
            el.addEventListener('click', (ev) => {
                if (ev.target.closest('[data-preview]')) return;
                if (el.classList.contains('bad')) return;
                const m = el.dataset.house;
                const input = g('bp-f-extmodel');
                if (input) input.value = m;
                modal.querySelectorAll('[data-house]').forEach((o) => o.classList.remove('on'));
                el.classList.add('on');
            });
        });
        modal.querySelectorAll('[data-preview]').forEach((b) => {
            b.addEventListener('click', () => {
                fetchAPI('previewHouse', { model: b.dataset.preview, anchor: anchor });
                modal.querySelectorAll('[data-preview]').forEach((o) => o.classList.remove('on'));
                b.classList.toggle('on');
            });
        });

        const clearOver = g('bp-f-clearover');
        if (clearOver) {
            clearOver.addEventListener('click', () => {
                const input = g('bp-f-extmodel');
                if (input) input.value = '';
                modal.querySelectorAll('[data-house]').forEach((o) => o.classList.remove('on'));
                clearOver.remove();
            });
        }

        const permBox = g('bp-f-perm');
        if (permBox) {
            const syncPerm = () => {
                g('bp-f-permwrap').classList.toggle('on', permBox.checked);
                g('bp-f-permbody').style.display = permBox.checked ? '' : 'none';
            };
            permBox.addEventListener('change', syncPerm); syncPerm();
        }

        g('bp-f-cancel').addEventListener('click', () => fetchAPI('closeSave'));
        g('bp-f-save').addEventListener('click', () => {
            const force = g('bp-f-force');
            const useAuto = !!(autoBox && autoBox.checked && az);
            const zname = g('bp-f-zname');
            const extEl = g('bp-f-extmodel');
            const wantPerm = !!(permBox && permBox.checked);
            if (wantPerm && !(extEl && extEl.value.trim()) && !saveCtx.autoModel) {
                saveResult({ ok: false, msg: T('bp_perm_need_model',
                    'A permanent plot needs the name of the finished-house model.') });
                if (extEl) extEl.focus();
                return;
            }
            fetchAPI('saveSite', {
                site: {
                    id: (g('bp-f-id').value || '').trim(),
                    label: g('bp-f-label').value,
                    zoneId: useAuto ? '' : g('bp-f-zone').value,
                    designId: s.designId,
                    anchor: s.anchor,
                    permanent: wantPerm,
                    exteriorModel: wantPerm && extEl ? extEl.value.trim() : null,
                },
                newZone: useAuto ? {
                    name: ((zname && zname.value) || az.name).trim(),
                    coords: az.coords, points: az.points,
                } : null,
                force: !!(force && force.checked),
            });
        });

        const idEl = g('bp-f-id');
        if (idEl && !editing) { idEl.focus(); idEl.select(); }
    }

    function hideSave() {
        const modal = g('bp-save');
        if (modal) { modal.classList.remove('visible'); modal.innerHTML = ''; }
        saveCtx = null;
    }

    function toast(ok, text) {
        const el = g('bp-toast');
        if (!el) return;
        el.className = 'bp-toast visible ' + (ok ? 'ok' : 'bad');
        el.innerHTML = `<span class="${ok ? 'ok' : 'bad'}">${ok ? '✓' : '✕'}</span><span>${esc(text)}</span>`;
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => { el.className = 'bp-toast'; }, 5000);
    }

    function saveResult(d) {
        const modal = g('bp-save');
        const open = modal && modal.classList.contains('visible');
        if (open) {
            const box = modal.querySelector('.bp-save-body');
            if (box) {
                let el = box.querySelector('.bp-save-msg');
                if (!el) { el = document.createElement('div'); el.className = 'bp-save-msg'; box.appendChild(el); }
                el.className = 'bp-save-msg ' + (d.ok ? 'ok' : 'bad');
                el.textContent = (d.ok ? '✓ ' : '✕ ') + (d.msg || '');
            }
            return;
        }
        toast(d.ok, `${d.id ? d.id + ': ' : ''}${d.msg || ''}`);
    }

    window.addEventListener('message', (event) => {
        const d = event.data || {};
        switch (d.action) {
            case 'showMenu': showMenu(d); break;
            case 'hideMenu': hideMenu(); break;
            case 'sites': {
                injectMarkup();
                const arr = (v) => (Array.isArray(v) ? v : []);
                store = {
                    sites: arr(d.sites), zones: arr(d.zones), health: arr(d.health),
                    designs: arr(d.designs), locked: d.locked || { site1: true },
                    settings: d.settings || store.settings || {},
                };
                render();
                break;
            }
            case 'updateHUD': injectMarkup(); buildHUD(d.state); break;
            case 'hideHUD': buildHUD(null); break;
            case 'placeInit': designs = d.designs || []; break;
            case 'showPanel': showPanel(d); break;
            case 'panelState': panelState(d.state || {}); break;
            case 'hidePanel': hidePanel(); break;
            case 'showSave': showSave(d); break;
            case 'hideSave': hideSave(); break;
            case 'saveResult': saveResult(d); break;
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Tab') {
            const p = g('bp-ctl-root');
            if (p && p.classList.contains('visible')) { e.preventDefault(); cmd('closePanel'); }
            return;
        }
        if (e.key !== 'Escape') return;
        const modal = g('bp-save');
        if (modal && modal.classList.contains('visible')) { fetchAPI('closeSave'); return; }
        const panel = g('bp-ctl-root');
        if (panel && panel.classList.contains('visible')) { cmd('closePanel'); return; }
        const root = g('tw-root');
        if (root && root.classList.contains('visible')) fetchAPI('closeMenu');
    });
})();
