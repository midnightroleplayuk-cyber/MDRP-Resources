
var resourceName = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName() : "tw-builderjob";

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            console.error(`HTTP error: ${response.status}`);
            return null;
        }

        const text = await response.text();
        if (!text) {
            return null;
        }

        try {
            return JSON.parse(text);
        } catch (error) {
            console.error("Invalid JSON format:", text);
            return null;
        }
    } catch (error) {
        return null;
    }
};

window.applyAccent = (hex) => {
    const m = /^\s*#?([0-9a-f]{6})\s*$/i.exec(typeof hex === 'string' ? hex : '');
    if (!m || m[1].toLowerCase() === 'e5b93b') return false;
    const n = parseInt(m[1], 16);
    const rgb = [n >> 16, (n >> 8) & 255, n & 255];
    const mix = (to, k) => rgb.map(c => Math.round(c + (to - c) * k)).join(', ');
    const s = document.documentElement.style;
    s.setProperty('--primary-color', `rgba(${rgb.join(', ')}, 1)`);
    s.setProperty('--primary-color-rgb', rgb.join(', '));
    s.setProperty('--primary-color-transparent', `rgba(${rgb.join(', ')}, 0.1)`);
    s.setProperty('--accent', `rgb(${mix(255, 0.3)})`);
    s.setProperty('--accent-rgb', mix(255, 0.3));
    s.setProperty('--accent-dark', `rgb(${rgb.join(', ')})`);
    s.setProperty('--primary-color-hover', `rgb(${mix(60, 0.45)})`);
    return true;
};

const store = Vuex.createStore({
    components: {},
    getters: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    components: {},
    data: () => ({
        isActive: false,
        isLodActive: false,
        lodQuality: 'dengeli',
        lodLabel: 'Sync: Balanced',
        lodPresets: [
            { value: 'performans', label: 'Sync: Performance' },
            { value: 'dengeli',    label: 'Sync: Balanced' },
            { value: 'yuksek',     label: 'Sync: High' },
            { value: 'ultra',      label: 'Sync: Ultra' },
            { value: 'ozel',       label: 'Sync: Custom (/builderjobsettings)' },
        ],
        notifyShow: false,
        jobReveal: false,
        teamReveal: false,
        inviteReveal: false,
        invitePicked: null,
        rentalMenu: null,
        rentalHover: null,
        leaderboardData: [],
        leaderboardSort: 'money',
        leaderboardLoaded: false,
        leaderboardEnabled: true,
        soundPanelOpen: false,
        soundSettings: [
            { key: 'ui',      label: 'Menu / UI Sounds', enabled: true, volume: 80 },
            { key: 'machine', label: 'Machine Sounds',   enabled: true, volume: 10 },
        ],
        craneCtl: {
            show: false,
            hint: '',
            hudMode: 0,
            layout: [],
            model: true,
            hideKey: '',
            keys: {
                slewL: false, slewR: false,
                boomU: false, boomD: false,
                knuckL: false, knuckR: false,
                teleU: false, teleD: false,
                winchD: false, winchU: false,
                grab: false,
                slow: false,
                jkey: false,
                exit: false,
            },
            fill: -1,
            pourState: '',
        },
        infoPanelVisible: false,
        keyInfoVisible: false,
        hidePagination: false,
        hideArrows: false,
        hideConfirm: false,
        trunkOpen: true,
        notifications: [],

        progressbar: 0,
        progressbarLabel: "",
        localeValue: 'Turkce',
        state: {
            mainShow: false,
            teamShow: false,
            finishShow: false,
            jobIsActive: false,
            currentPage: 'home',
            missionScoreData: {
                "Players": [
                    {
                        "scoreAmount": 0,
                        "playerName": "Player 1",
                        "playerLevel": 1,
                        "playerIdentifier": "ID001",
                        "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                        "bonusScoreAmount": 0,
                        "source": 1
                    },
                ],
                "regionJobTask": [
                    {
                        "jobLabel": "Test Job 1",
                        "madeAmount": 0,
                        "finish": false,
                        "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                        "jobName": "lawnmowing",
                        "invisible": false,
                        "jobCount": 2
                    },
                ],
            },
            jobProgress: null,
            languageTitle: [],
            defaultLogo: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png',
            serverName: 'TWORST',
            scriptName: "Builder",
            serverCurrencySymbol: '$',
            selectedRegion: false,
            expandedRegion: null,
            heroPhase: null,
            gridPaging: null,
            invitePlayerModal: false,
            displayedRegions: [],
            displayedDailyMission: [],
            currentRegionIndex: 0,
            regionsPerPage: 4,
            currentDailyMissionIndex: 0,
            dailyMissionsPerPage: 2,
            slideDirection: 'right',
            settings: {
                Sounds: true,
                Language: 'en',
                moveUI: false,
                uiPositions: {
                    teamList: { top: '77.22vh', left: '85.94vw' },
                    scoreList: { top: '2.64vh', left: '1.61vw' },
                    inviteSide: { top: '2.85vh', right: '1.5625vw' },
                    notificationDiv: { top: '40.48vh', left: '81.54vw' },
                    keyInfoSide: { top: '50%', right: '2.0833vw' },
                    dumpsterInfo: { top: '1.3542vw', left: '50%' }
                },
            },
            nearbyPlayers: [],
            requestData: {
                show: false,
                hostIdentifier: '',
                hostName: '',
            },
            finishJobData: false,
            locales: {},
            trainingStep: null,
            trainingProgress: 0,
            trainingDone: null,
            hintCard: null,
            trainingStatus: {},
            showTrainingBadge: false,
            tutorialPolicy: 'off',
            tutorialSuggest: null
        },
        trainingModules: [
            { id: 'cranev2', nameKey: 'tutorial_card_cranev2', descKey: 'tutorial_card_cranev2_desc' },
            { id: 'pumpv2',  nameKey: 'tutorial_card_pumpv2',  descKey: 'tutorial_card_pumpv2_desc' },
            { id: 'tower',   nameKey: 'tutorial_card_tower',   descKey: 'tutorial_card_tower_desc' },
        ],
        tutorialGuides: [
            { id: 'g1', open: false, titleKey: 'guide_clothes_t',  descKey: 'guide_clothes_d',  video: 'https://file.tworst.com/u/tw-builder/tutovideo1.webm' },
            { id: 'g2', open: false, titleKey: 'guide_rent_t',     descKey: 'guide_rent_d',     video: 'https://file.tworst.com/u/tw-builder/tutovideo2.webm' },
            { id: 'g3', open: false, titleKey: 'guide_remote_t',   descKey: 'guide_remote_d',   video: 'https://file.tworst.com/u/tw-builder/tutovideo3.webm' },
            { id: 'g4', open: false, titleKey: 'guide_carry_t',    descKey: 'guide_carry_d',    video: 'https://file.tworst.com/u/tw-builder/tutovideo4.webm' },
            { id: 'g5', open: false, titleKey: 'guide_stow_t',     descKey: 'guide_stow_d',     video: 'https://file.tworst.com/u/tw-builder/tutovideo5.webm' },
            { id: 'g6', open: false, titleKey: 'guide_return_t',   descKey: 'guide_return_d',   video: 'https://file.tworst.com/u/tw-builder/tutovideo6.webm' },
        ],
        playerData: {
            playerLevel: 1,
            playerXp: 1000,
            playerNextXp: 2000,
            playerIdentifier: '1234567890',
            owner: false,
            dailymission: [],
            playerDailyMission: [],
            soundEffect: true,
            locale: 'tr',
        },
        rewardSplit: {},
        rewardDragging: null,
        rewardOpen: false,
        playerListData: [
            {
                playerName: 'Brenden Randall',
                playerLevel: 1,
                playerIdentifier: '1234567890',
                playerImage: './img/regionBg.png',
                playerOwner: true,
            },
        ],
        regionData: [
            {
                regionName: 'Los santos Department',
                regionID: 1,
                regionImage: 'region.png',
                regionLevel: 1,
                regionXP: 1000,
                regionMoney: 1000,
            },
        ],
        historyData: [
            {
                historyRegionID: 1,
                historyTaskCount: 16,
                historyRewardMoney: 56000,
                historyRewardXP: 2500,
                historyTime: '01-01-1999 16:50',
                historyPlayer: [
                    'Brenden Randall',
                    'Brenden Randall 2',
                    'Brenden Randall 3',
                ]
            }
        ],
        dailyMission: false,

        playerInventory: [],

        inventoryImagePath: 'nui://qb-inventory/html/images/',

        textUIItems: [],

        drawtext: { visible: false, expanded: false, cards: [] },

        finishReveal: false,

        taskExpand: false,
        taskHold: false,
        taskHoldMs: 2000,
        _taskHoldTimer: null,
    }),

    watch: {
        'state.teamShow'(val) {
            if (val) {
                this.jobReveal = false;
                this.teamReveal = false;
                this.$nextTick(() => {
                    setTimeout(() => { this.jobReveal = true; }, 560);
                    setTimeout(() => { this.teamReveal = true; }, 450);
                });
            } else {
                this.jobReveal = false;
                this.teamReveal = false;
            }
        },
        'state.requestData.show'(val) {
            if (val) {
                this.invitePicked = null;
                this.inviteReveal = false;
                this.$nextTick(() => {
                    setTimeout(() => { this.inviteReveal = true; }, 560);
                });
            } else {
                this.inviteReveal = false;
                this.invitePicked = null;
            }
        },
        'craneCtl.show'(val) {
            if (val && this.craneCtl.model && this.craneCtl.hudMode === 0) {
                this.$nextTick(() => {
                    const host = document.querySelector('.crane3dHost');
                    if (host && window.Crane3D) window.Crane3D.show(host, this.craneCtl.keys);
                });
            } else if (window.Crane3D) {
                window.Crane3D.hide();
            }
        },
        'craneCtl.hudMode'(mode) {
            if (!window.Crane3D) return;
            if (this._c3dHideTimer) { clearTimeout(this._c3dHideTimer); this._c3dHideTimer = null; }
            if (mode !== 0 || !this.craneCtl.show || !this.craneCtl.model) {
                this._c3dHideTimer = setTimeout(() => {
                    this._c3dHideTimer = null;
                    if (this.craneCtl.hudMode !== 0 || !this.craneCtl.show
                        || !this.craneCtl.model) {
                        window.Crane3D.hide();
                    }
                }, 380);
            } else {
                this.$nextTick(() => {
                    const host = document.querySelector('.crane3dHost');
                    if (host) window.Crane3D.show(host, this.craneCtl.keys);
                });
            }
        },
        'craneCtl.keys'(keys) {
            if (window.Crane3D) window.Crane3D.setKeys(keys);
        },
        'state.finishShow'(val) {
            if (val) {
                this.finishReveal = false;
                this.$nextTick(() => { setTimeout(() => { this.finishReveal = true; }, 420); });
            } else {
                this.finishReveal = false;
            }
        },
    },

    beforeDestroy() {
        document.removeEventListener("click", this.handleClickOutside);
    },
    mounted() {
        window.addEventListener("keyup", this.keyHandler);
        window.addEventListener("message", this.eventHandler);
        document.addEventListener("click", this.handleClickOutside);
        this._nfyId = 0;
        this._nfyTimers = {};
        this._heroSeq = 0;
        this._dtExpandTimer = null;
        this._dtHideTimer = null;
    },

    methods: {
        toggleDropdown() {
            this.isActive = !this.isActive;
        },

        tl(key, fallback) {
            const L = this.state && this.state.locales;
            return (L && L[key]) || fallback || key;
        },

        refreshLocaleLabels() {
            window.TW_LOCALES = (this.state && this.state.locales) || {};

            const lodNames = {
                performans: this.tl('lodPresetPerformance', 'Performance'),
                dengeli:    this.tl('lodPresetBalanced', 'Balanced'),
                yuksek:     this.tl('lodPresetHigh', 'High'),
                ultra:      this.tl('lodPresetUltra', 'Ultra'),
                ozel:       this.tl('lodPresetCustom', 'Custom'),
            };
            const lodPrefix = this.tl('lodPrefix', 'Sync');
            this.lodPresets.forEach(p => {
                const name = lodNames[p.value] || p.value;
                p.label = p.value === 'ozel'
                    ? `${lodPrefix}: ${name} (/builderjobsettings)`
                    : `${lodPrefix}: ${name}`;
            });
            const active = this.lodPresets.find(p => p.value === this.lodQuality);
            if (active) this.lodLabel = active.label;

            const soundNames = {
                ui:      this.tl('soundGroupUi', 'Menu / UI Sounds'),
                machine: this.tl('soundGroupMachine', 'Machine Sounds'),
            };
            this.soundSettings.forEach(s => {
                if (soundNames[s.key]) s.label = soundNames[s.key];
            });
        },

        showDrawText(cards) {
            if (this._dtHideTimer) { clearTimeout(this._dtHideTimer); this._dtHideTimer = null; }
            const wasVisible = this.drawtext.visible;
            this.drawtext.cards = Array.isArray(cards) ? cards : [];
            this.drawtext.visible = true;
            if (!wasVisible) {
                this.drawtext.expanded = false;
                if (this._dtExpandTimer) clearTimeout(this._dtExpandTimer);
                this._dtExpandTimer = setTimeout(() => { this.drawtext.expanded = true; }, 240);
            }
        },
        hideDrawText() {
            if (this._dtHideTimer) clearTimeout(this._dtHideTimer);
            this._dtHideTimer = setTimeout(() => {
                this.drawtext.visible = false;
                this.drawtext.expanded = false;
                if (this._dtExpandTimer) { clearTimeout(this._dtExpandTimer); this._dtExpandTimer = null; }
                this._dtHideTimer = null;
            }, 50);
        },
        regionImgSrc(info) {
            const v = info && (info.regionMedia || info.regionImage);
            if (!v) return './img/region.png';
            return /^(https?:)?\/\//.test(v) ? v : './img/' + v;
        },
        cbOn(item) {
            const flags = item && item.on;
            if (!flags || !flags.length) return false;
            for (let i = 0; i < flags.length; i++) {
                if (this.craneCtl.keys[flags[i]]) return true;
            }
            return false;
        },
        toggleLodDropdown() {
            this.soundPanelOpen = false;
            this.isLodActive = !this.isLodActive;
        },
        selectLodOption(option) {
            this.isLodActive = false;
            this.lodQuality = option.value;
            this.lodLabel = option.label;
        },
        selectOption(option) {
            this.isActive = false;
            this.playerData.locale = option.value;
            this.localeValue = option.label
        },
        handleClickOutside(event) {
            const t = event.target;
            if (!t || !t.closest) return;

            if (!t.closest('.newSettingLanguageBox')) this.isActive = false;
            if (this.soundPanelOpen && !t.closest('.newSoundOpener')) this.soundPanelOpen = false;
            if (this.isLodActive && !t.closest('.newSyncOpener')) this.isLodActive = false;
            if (this.rewardOpen) this.rewardOpen = false;
        },
        prevRegion() {
            if (this.state.currentRegionIndex > 0) {
                clicksound("click.wav", this.playerData.soundEffect);
                this.state.slideDirection = 'left';
                this.state.currentRegionIndex -= this.state.regionsPerPage;
                this.pageAnim('left');
            }
        },
        nextRegion() {
            if (this.state.currentRegionIndex + this.state.regionsPerPage < this.regionData.length) {
                clicksound("click.wav", this.playerData.soundEffect);
                this.state.slideDirection = 'right';
                this.state.currentRegionIndex += this.state.regionsPerPage;
                this.pageAnim('right');
            }
        },
        pageAnim(direction) {
            this.state.gridPaging = direction;
            clearTimeout(this._pagingTimer);
            this._pagingTimer = setTimeout(() => { this.state.gridPaging = null; }, 550);
        },
        crewLabel(region) {
            const info = region && region.regionInfo;
            if (!info || info.crewMin == null) return this.state.locales['1-4Players'];
            const min = info.crewMin || 1;
            const max = info.crewMax || 0;
            const people = this.state.locales['crewPeople'] || 'Players';
            if (min === 1 && max === 1) return this.state.locales['crewSolo'] || 'SOLO';
            if (max === 0) return `${min}+ ${people}`;
            if (min === max) return `${min} ${people}`;
            return `${min}-${max} ${people}`;
        },
        crewIncompatible(region) {
            const info = region && region.regionInfo;
            if (!info || info.crewMin == null) return false;
            const crew = this.playerListData.length;
            const min = info.crewMin || 1;
            const max = info.crewMax || 0;
            return crew < min || (max > 0 && crew > max);
        },
        shareSlots(region) {
            const s = region && region.crewShare;
            if (!s || !s.total) return 0;
            const crew = Math.max(1, this.playerListData.length);
            return crew >= s.fullFromCrew ? s.total : Math.min(s.total, s.perWorker * crew);
        },
        shareOf(region, value) {
            const s = region && region.crewShare;
            if (!s || !s.total) return value;
            return Math.floor((Number(value) || 0) * this.shareSlots(region) / s.total);
        },
        openTrainingTab() {
            if (this.state.showTrainingBadge) {
                this.state.showTrainingBadge = false;
                postNUI("trainingBadgeSeen");
            }
            this.changePage('training');
        },
        toggleGuide(i) {
            clicksound("click.wav", this.playerData.soundEffect);
            const willOpen = !this.tutorialGuides[i].open;
            this.tutorialGuides.forEach((g, k) => { g.open = (k === i) ? willOpen : false; });
        },
        startTraining(module) {
            clicksound("click.wav", this.playerData.soundEffect);
            if (this.state.jobIsActive) {
                this.pushNotify({ message: this.state.locales['tutorial_busy_in_job'] || 'Finish or leave your job first. Training is solo.', type: 'error' });
                return;
            }
            postNUI("startTraining", module);
        },
        onRegionClick(region, event) {
            if (region == null) return;
            if (this.isLobbyMember) {
                clicksound("errorclick.mp3", this.playerData.soundEffect);
                this.pushNotify({
                    message: this.state.locales['ownerPicksRegion'] || 'Only the crew leader picks the region.',
                    type: 'error',
                });
                return;
            }
            this.expandRegion(region, event.currentTarget);
            const alreadySelected = this.state.selectedRegion
                && this.state.selectedRegion.regionID === region.regionID;
            if (!alreadySelected) {
                this.selectRegion(region);
                this.maybeSuggestTutorial(region);
            }
        },
        taskText(row) {
            if (!row) return '';
            const L = this.state.locales || {};
            let base = row.jobLabel || '';
            if (row.jobLabelKey && L[row.jobLabelKey]) {
                base = L[row.jobLabelKey];
                const loc = (v) => (typeof v === 'string' && L[v]) ? L[v] : v;
                const args = row.jobLabelArgs;
                if (args && args.length) {
                    let i = 0;
                    base = base.replace(/%[sd]/g, () => {
                        const v = args[i++];
                        if (v === undefined || v === null) return '';
                        if (Array.isArray(v)) return v.map(loc).join(' + ');
                        return String(loc(v));
                    });
                }
            }
            return base + (row.jobLabelSuffix || '');
        },
        missingTutorials(region) {
            if (this.state.tutorialPolicy !== 'suggest') return [];
            const need = region && region.regionInfo && region.regionInfo.tutorialModules;
            if (!need || !need.length) return [];
            return need.filter(m => !this.state.trainingStatus[m]);
        },
        maybeSuggestTutorial(region) {
            const missing = this.missingTutorials(region);
            if (!missing.length) return;
            const nameKey = { cranev2: 'tutorial_card_cranev2', pumpv2: 'tutorial_card_pumpv2', tower: 'tutorial_card_tower' };
            this.state.tutorialSuggest = {
                modules: missing,
                moduleNames: missing.map(m => this.state.locales[nameKey[m]] || m).join(' + '),
                regionName: (region.regionInfo && region.regionInfo.regionName) || '',
            };
        },
        dismissTutorialSuggest() {
            clicksound("click.wav", this.playerData.soundEffect);
            this.state.tutorialSuggest = null;
        },
        acceptTutorialSuggest() {
            const s = this.state.tutorialSuggest;
            this.state.tutorialSuggest = null;
            if (s && s.modules && s.modules.length) this.startTraining(s.modules[0]);
        },
        syncHeroToSelection(opts) {
            opts = opts || {};
            const sel = this.state.selectedRegion;
            if (!sel) {
                this.state.expandedRegion = null;
                if (this.state.heroPhase !== 'restoring') this.state.heroPhase = null;
                return;
            }
            const local = (this.regionData || []).find(r => r.regionID === sel.regionID);
            const target = local || sel;
            const same = this.state.expandedRegion
                && this.state.expandedRegion.regionID === sel.regionID;
            if (same) {
                this.state.expandedRegion = target;
                return;
            }
            if (opts.animate && this.isLobbyMember) {
                this.revealHeroForMember(target);
                return;
            }
            this.state.expandedRegion = target;
            this.state.heroPhase = null;
        },
        revealHeroForMember(target) {
            this.state.expandedRegion = null;
            this.state.heroPhase = null;

            const all = this.regionData || [];
            const idx = all.findIndex(r => r.regionID === target.regionID);
            if (idx >= 0) {
                const per = this.state.regionsPerPage || 1;
                this.state.currentRegionIndex = Math.floor(idx / per) * per;
            }
            if (this.state.currentPage !== 'home') this.state.currentPage = 'home';

            this.$nextTick(() => {
                const list = this.$refs.regionList;
                const card = list && list.querySelector('[data-region-id="' + target.regionID + '"]');
                if (!card) {
                    this.state.expandedRegion = target;
                    this.state.heroPhase = null;
                    return;
                }
                this.expandRegion(target, card);
            });
        },
        heroRects(cardEl, hero) {
            const parent = hero.offsetParent.getBoundingClientRect();
            const from = cardEl.getBoundingClientRect();
            const to = hero.getBoundingClientRect();
            return {
                from: { top: `${from.top - parent.top}px`, left: `${from.left - parent.left}px`, width: `${from.width}px`, height: `${from.height}px` },
                to: { top: `${to.top - parent.top}px`, left: `${to.left - parent.left}px`, width: `${to.width}px`, height: `${to.height}px` },
            };
        },
        expandRegion(region, cardEl) {
            this.state.expandedRegion = region;
            this.state.heroPhase = 'expanding';
            const seq = (this._heroSeq = (this._heroSeq || 0) + 1);
            this.$nextTick(() => {
                if (seq !== this._heroSeq) return;
                const hero = this.$refs.heroCard;
                if (!hero || !cardEl || !hero.offsetParent || !cardEl.offsetParent) {
                    this.state.heroPhase = null;
                    return;
                }
                const r = this.heroRects(cardEl, hero);
                hero.animate([r.from, r.to], { duration: 680, easing: 'cubic-bezier(0.16, 1, 0.3, 1)' });
                setTimeout(() => {
                    if (seq !== this._heroSeq) return;
                    if (this.state.heroPhase === 'expanding') this.state.heroPhase = null;
                }, 180);
            });
        },
        collapseHero() {
            if (!this.state.expandedRegion) { this.state.heroPhase = null; return; }
            if (this.isLobbyMember && this.state.selectedRegion) {
                clicksound("errorclick.mp3", this.playerData.soundEffect);
                return;
            }
            clicksound("click.wav", this.playerData.soundEffect);
            this.state.expandedRegion = null;
            this.state.heroPhase = 'restoring';
            if (this.isPlayerOwner && this.state.selectedRegion) postNUI("selectRegion", false);
            setTimeout(() => { if (this.state.heroPhase === 'restoring') this.state.heroPhase = null; }, 700);
        },
        prevDailyMission() {
            if (this.state.currentDailyMissionIndex > 0) {
                clicksound("click.wav", this.playerData.soundEffect);
                this.state.currentDailyMissionIndex -= this.state.dailyMissionsPerPage;
            }
        },
        nextDailyMission() {
            if (this.state.currentDailyMissionIndex + this.state.dailyMissionsPerPage < this.playerData.playerDailyMission.length) {
                clicksound("click.wav", this.playerData.soundEffect);
                this.state.currentDailyMissionIndex += this.state.dailyMissionsPerPage;
            }
        },
        invitePlayer(playerID) {
            if (playerID == null || playerID < 0) return;
            clicksound("click.wav", this.playerData.soundEffect);
            postNUI("invitePlayer", playerID);
        },
        changePage(page) {
            if (this.state.currentPage == page) return;
            clicksound("click.wav", this.playerData.soundEffect);
            this.state.expandedRegion = null;
            this.state.currentPage = page;
            this.syncHeroToSelection();
        },
        setLeaderboardSort(metric) {
            if (this.leaderboardSort === metric) return;
            clicksound("click.wav", this.playerData.soundEffect);
            this.leaderboardSort = metric;
        },
        toggleSoundPanel() {
            clicksound("click.wav", this.playerData.soundEffect);
            this.isLodActive = false;
            this.soundPanelOpen = !this.soundPanelOpen;
        },
        closeSoundPanel() {
            this.soundPanelOpen = false;
        },
        updateSound(s) {
            if (s.key === 'ui') this.playerData.soundEffect = s.enabled;
            AudioBus.setChannels({ [s.key]: { enabled: s.enabled, volume: s.volume } });
            postNUI("updateSoundSetting", { key: s.key, enabled: s.enabled, volume: s.volume });
        },
        pushNotify(payload) {
            payload = payload || {};
            if (!payload.message) return;

            const NFY_MAX = 3;
            const msg = String(payload.message);

            if (payload.key) {
                const cur = this.notifications.find(n => n.key === payload.key);
                if (cur) {
                    cur.message = msg;
                    cur.type = payload.type || cur.type;
                    if (this._nfyTimers[cur.id]) clearTimeout(this._nfyTimers[cur.id]);
                    this._nfyTimers[cur.id] = setTimeout(() => this.removeNotify(cur.id),
                        Math.max(1200, Number(payload.duration) || 5000));
                    return;
                }
            } else if (this.notifications.some(n => n.message === msg)) {
                return;
            }

            while (this.notifications.length >= NFY_MAX) {
                this.removeNotify(this.notifications[0].id);
            }

            const id = ++this._nfyId;
            const item = {
                id, expanded: false,
                key: payload.key || null,
                type: payload.type || 'info',
                message: msg,
                duration: Math.max(1200, Number(payload.duration) || 5000),
            };
            this.notifications.push(item);
            this.notifyShow = true;
            const EXPAND = 180;
            setTimeout(() => { const it = this.notifications.find(x => x.id === id); if (it) it.expanded = true; }, EXPAND);
            this._nfyTimers[id] = setTimeout(() => this.removeNotify(id), EXPAND + item.duration);
        },
        removeNotify(id) {
            const i = this.notifications.findIndex(x => x.id === id);
            if (i !== -1) this.notifications.splice(i, 1);
            if (this._nfyTimers && this._nfyTimers[id]) { clearTimeout(this._nfyTimers[id]); delete this._nfyTimers[id]; }
            if (this.notifications.length === 0) this.notifyShow = false;
        },
        beforeNfyLeave(el) {
            el.style.left = el.offsetLeft + 'px';
            el.style.top = el.offsetTop + 'px';
            el.style.width = el.offsetWidth + 'px';
        },
        requestActionButton(action) {
            if (action == "accept") {
                clicksound("click.wav", this.playerData.soundEffect);
                postNUI("acceptInvite", this.state.requestData.identifier);
                this.state.requestData.show = false;
            } else if (action == "deny") {
                postNUI("declineInvite", this.state.requestData.identifier);
                this.state.requestData.show = false;
            }
        },
        acceptInvite() {
            this.pickInvite('accept');
        },
        denyInvite() {
            this.pickInvite('reject');
        },
        pickInvite(type) {
            if (this.invitePicked) return;
            this.invitePicked = type;
            clicksound("click.wav", this.playerData.soundEffect);
            setTimeout(() => { this.inviteReveal = false; }, 450);
            setTimeout(() => {
                postNUI(type === 'accept' ? 'acceptInvite' : 'declineInvite', this.state.requestData.identifier);
                this.state.requestData.show = false;
                this.invitePicked = null;
            }, 1150);
        },
        rewardPctOf(identifier) {
            const v = this.rewardSplit[identifier];
            return typeof v === 'number' ? Math.round(v) : 0;
        },
        setRewardPct(identifier, raw) {
            let v = Math.round(Number(raw));
            if (!isFinite(v)) return;
            v = Math.max(0, Math.min(100, v));

            const others = this.playerListData
                .map(p => p.playerIdentifier)
                .filter(id => id && id !== identifier);
            if (!others.length) { this.rewardSplit = { [identifier]: 100 }; return; }

            const rest = 100 - v;
            const cur = others.map(id => this.rewardPctOf(id));
            const curSum = cur.reduce((a, b) => a + b, 0);

            const next = {};
            next[identifier] = v;
            let given = 0;
            others.forEach((id, i) => {
                const share = curSum > 0 ? (cur[i] / curSum) * rest : rest / others.length;
                const val = Math.floor(share);
                next[id] = val;
                given += val;
            });
            const leftover = rest - given;
            if (leftover > 0) next[others[0]] += leftover;

            this.rewardSplit = next;
        },
        toggleReward(e) {
            this.rewardOpen = !this.rewardOpen;
            if (this.rewardOpen) {
                const btn = e && e.currentTarget;
                this.$nextTick(() => requestAnimationFrame(() => this.positionRewardPanel(btn)));
            }
        },
        positionRewardPanel(btn) {
            const panel = document.querySelector('.rewardPanel');
            if (!btn || !panel) return;
            const r = btn.getBoundingClientRect();
            const ph = panel.offsetHeight, pw = panel.offsetWidth;
            let top = r.top - ph - 8;
            if (top < 8) top = r.bottom + 8;
            let left = r.right - pw;
            if (left < 8) left = 8;
            panel.style.top = top + 'px';
            panel.style.left = left + 'px';
            panel.style.right = 'auto';
            panel.style.bottom = 'auto';
        },
        stepReward(identifier, delta) {
            this.setRewardPct(identifier, this.rewardPctOf(identifier) + delta);
            this.commitRewardSplit();
        },
        equalSplit() {
            const ids = this.playerListData.map(p => p.playerIdentifier).filter(Boolean);
            const n = ids.length;
            if (!n) return;
            const base = Math.floor(100 / n), rem = 100 - base * n;
            const next = {};
            ids.forEach((id, i) => { next[id] = base + (i < rem ? 1 : 0); });
            this.rewardSplit = next;
            this.commitRewardSplit();
        },
        commitRewardSplit() {
            this.rewardDragging = null;
            const payload = {};
            this.playerListData.forEach(p => {
                if (p.playerIdentifier) payload[p.playerIdentifier] = this.rewardPctOf(p.playerIdentifier);
            });
            postNUI("updateRewardSplit", payload);
        },
        kickPlayer(playerIdentifier) {
            if (!playerIdentifier) {
                return;
            }

            const targetPlayer = this.playerListData.find(x => x.playerIdentifier === playerIdentifier);
            const ownerPlayer = this.playerListData.find(x => x.playerOwner === true);

            if (!targetPlayer || !ownerPlayer) {
                return;
            }


            if (playerIdentifier === this.playerData.playerIdentifier) {
                postNUI("leaveLobby", ownerPlayer.playerIdentifier);
                return;
            }

            if (targetPlayer.playerIdentifier === ownerPlayer.playerIdentifier) {
                clicksound("errorclick.mp3", this.playerData.soundEffect);
                return;
            }

            clicksound("click.wav", this.playerData.soundEffect);
            postNUI("kickPlayer", {
                lobbyID: ownerPlayer.playerIdentifier,
                identifier: playerIdentifier,
                targetID: targetPlayer.source
            });
        },
        selectRegion(regionValue) {
            if (regionValue == null || this.playerData.playerIdentifier == null) return;
            const identifierData = this.playerListData.findIndex(x => x.playerIdentifier == this.playerData.playerIdentifier);
            const playerOwner = this.playerListData.findIndex(x => x.playerOwner == true)
            if (this.playerListData[identifierData].playerIdentifier === this.playerListData[playerOwner].playerIdentifier) {
                if (this.state.selectedRegion != false && this.state.selectedRegion != null) {
                    if (regionValue.regionID == this.state.selectedRegion.regionID) {
                        clicksound("click.wav", this.playerData.soundEffect);
                        postNUI("selectRegion", false);
                        return;
                    }
                }
                if (regionValue && regionValue.regionID) {
                    const regionID = regionValue.regionID;

                    if (regionID == -1) return;
                    if (regionValue.regionInfo.regionMinimumLevel > this.playerData.playerLevel) {
                        clicksound("errorclick.mp3", this.playerData.soundEffect);
                        return;
                    }
                    clicksound("click.wav", this.playerData.soundEffect);
                    postNUI("selectRegion", regionValue);
                }
            }

        },
        startJob() {
            if (this.startBlocked) {
                clicksound("errorclick.mp3", this.playerData.soundEffect);
                return;
            }
            if (this.state.jobIsActive) {
                clicksound("click.wav", this.playerData.soundEffect);

                if (!this.isPlayerOwner) {
                    const ownerPlayer = this.playerListData.find(x => x.playerOwner === true);
                    if (ownerPlayer) {
                        postNUI("leaveLobby", ownerPlayer.playerIdentifier);
                    }
                } else {
                    postNUI("resetJob");
                }
            } else {
                if (this.isLobbyMember) {
                    clicksound("errorclick.mp3", this.playerData.soundEffect);
                    this.pushNotify({
                        message: this.state.locales['waitingForLeader'] || 'WAITING FOR THE CREW LEADER',
                        type: 'error',
                    });
                    return;
                }
                if (this.state.selectedRegion) {
                    clicksound("click.wav", this.playerData.soundEffect);
                    postNUI("startJob", this.state.selectedRegion);
                }
            }
        },
        closeNUI() {
            this.rewardDragging = null;
            this.state.mainShow = false;
            this.state.expandedRegion = null;
            postNUI("closeNUI");
        },
        closeInviteNUI() {
            this.state.mainShow = false;
            this.state.requestData.show = false;
            postNUI("closeInviteNUI");
        },
        rentalPick(opt) {
            if (!opt || !opt.allowed || !opt.bayFree) return;
            clicksound("click.wav", this.playerData.soundEffect);
            this.rentalMenu = null;
            postNUI("rentalPick", { spotKey: opt.spotKey });
        },
        rentalClose() {
            this.rentalMenu = null;
            postNUI("rentalClose");
        },
        keyHandler(event) {
            if (this.rentalMenu && event.keyCode == 27) { this.rentalClose(); return; }
            if (this.state.requestData && this.state.requestData.show && !this.invitePicked) {
                if (event.keyCode === 89) { this.acceptInvite(); return; }
                if (event.keyCode === 78) { this.denyInvite(); return; }
            }
            if (event.keyCode == 27) {
                if (this.state.expandedRegion && !this.isLobbyMember) { this.collapseHero(); return; }
                {
                    if (!this.state.settings.moveUI) {
                        this.closeNUI();
                    } else {
                        this.state.settings.moveUI = false;
                        this.state.teamShow = false;
                        this.state.requestData.show = false;
                        this.keyInfoVisible = false;
                        this.infoPanelVisible = false;
                        this.state.mainShow = true;
                        this.state.currentPage = 'settings';
                        $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo").removeClass("movable");
                        $("body").find(".ui-moving-info").remove();

                        if (this.notifications.length === 1 && this.notifications[0].message === "You can move the notification") {
                            this.notifications = [];
                            this.notifyShow = false;
                        }
                    }
                }
            }

            if (event.keyCode == 13 && this.state.settings.moveUI) {
                this.state.settings.moveUI = false;
                this.state.teamShow = false;
                this.state.requestData.show = false;
                this.keyInfoVisible = false;
                this.infoPanelVisible = false;
                this.state.mainShow = true;
                this.state.currentPage = 'settings';
                $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo").removeClass("movable");
                $("body").find(".ui-moving-info").remove();

                if (this.notifications.length === 1 && this.notifications[0].message === "You can move the notification") {
                    this.notifications = [];
                    this.notifyShow = false;
                }
            }
        },
        historyOwnMoney(history) {
            if (!history) return 0;
            const me = this.playerData && this.playerData.playerIdentifier;
            const list = history.historyPlayers;
            if (me && Array.isArray(list)) {
                for (let i = 0; i < list.length; i++) {
                    const hp = list[i];
                    if (hp && hp.playerIdentifier === me && hp.moneyPaid != null) {
                        return hp.moneyPaid;
                    }
                }
            }
            return history.historyRewardMoney;
        },
        formatNumber(number) {
            if (number == null) return 0;
            return number.toLocaleString("tr-TR");
        },
        calculateProgress(mission, complete) {
            return (mission / complete) * 100;
        },
        mergeData(sqlData, configData) {
            if (!Array.isArray(configData)) {
                if (!Array.isArray(this.playerData.playerDailyMission)) {
                    this.playerData.playerDailyMission = [];
                    this.totalCompleted = 0;
                }
                return;
            }
            if (sqlData == null) sqlData = {};
            const mergedData = configData.map(mission => {
                const sqlMissionData = sqlData[mission.name];
                return {
                    ...mission,
                    complete: sqlMissionData ? sqlMissionData.complete : false,
                    currentCount: sqlMissionData ? sqlMissionData.count : 0,
                    progressbar: sqlMissionData ? this.calculateProgress(sqlMissionData.count, mission.count) : 0
                };
            });
            this.totalCompleted = mergedData.filter(mission => mission.complete).length;
            this.playerData.playerDailyMission = mergedData;
        },
        moveUI() {
            if (!this.state.jobIsActive) {
                clicksound("click.wav", this.playerData.soundEffect);
                this.state.settings.moveUI = true;
                this.state.mainShow = false;
                this.state.teamShow = true;
                this.state.requestData.show = true;
                this.state.requestData.lobbyOwner = "Brenden Randall";

                this.notifyShow = true;
                this.keyInfoVisible = true;
                this.infoPanelVisible = true;

                if (this.notifications.length === 0) {
                    this.pushNotify({
                        message: "You can move the notification",
                        type: "info",
                        duration: 10000
                    });
                }

                this.$nextTick(() => {
                    this.applyUIPositions();

                    setTimeout(() => {
                        this.makeAllUIDraggable();
                    }, 100);
                });
            }
        },
        applyPos(selector, pos) {
            $(selector).css({ left: '', right: '', top: '', bottom: '' }).css(pos);
        },
        applyUIPositions() {

            if (this.state.settings.uiPositions.teamList) {
                this.applyPos(".newTeamList", this.state.settings.uiPositions.teamList);
            }
            if (this.state.settings.uiPositions.scoreList) {
                this.applyPos(".allScoreList", this.state.settings.uiPositions.scoreList);
            }
            if (this.state.settings.uiPositions.inviteSide) {
                let iv = this.state.settings.uiPositions.inviteSide;
                if (iv.left !== undefined && iv.right === undefined) {
                    iv = { top: iv.top || '2.85vh', right: '1.5625vw' };
                    this.state.settings.uiPositions.inviteSide = iv;
                }
                this.applyPos(".newInviteSide", iv);
            }
            if (this.state.settings.uiPositions.notificationDiv) {
                this.applyPos(".notifyList", this.state.settings.uiPositions.notificationDiv);
            }
            if (this.state.settings.uiPositions.keyInfoSide) {
                this.applyPos(".keyInfoSide", this.state.settings.uiPositions.keyInfoSide);
            } else {
                this.state.settings.uiPositions.keyInfoSide = { top: '50%', right: '2.0833vw' };
                this.applyPos(".keyInfoSide", this.state.settings.uiPositions.keyInfoSide);
            }
            if (this.state.settings.uiPositions.dumpsterInfo) {
                this.applyPos(".dumpsterInfo", this.state.settings.uiPositions.dumpsterInfo);
            } else {
                this.state.settings.uiPositions.dumpsterInfo = { top: '1.3542vw', left: '50%' };
                this.applyPos(".dumpsterInfo", this.state.settings.uiPositions.dumpsterInfo);
            }



            if (this.state.settings.moveUI) {
                $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo").css({
                    'position': 'absolute',
                    'z-index': '999'
                });

                $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo")
                    .css('animation', 'none');
            } else {
                $(".newTeamList").css({
                    'position': '',
                    'z-index': ''
                });
                $(".allScoreList").css({
                    'position': '',
                    'z-index': ''
                });
                $(".newInviteSide").css({
                    'position': '',
                    'z-index': ''
                });
                $(".notifyList").css({
                    'position': '',
                    'z-index': ''
                });
                $(".keyInfoSide").css({
                    'position': '',
                    'z-index': '',
                    'transform': ''
                });
                $(".dumpsterInfo").css({
                    'position': '',
                    'z-index': '',
                    'transform': ''
                });
                $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo")
                    .css('animation', '');
            }
        },

        pinToRect(selector) {
            const $e = $(selector);
            if ($e.length === 0) return null;
            const r = $e[0].getBoundingClientRect();
            $e.css({
                position: 'absolute',
                left: r.left + 'px',
                top: r.top + 'px',
                right: 'auto',
                bottom: 'auto',
                transform: 'none'
            });
            return r;
        },
        makeElementDraggable(selector, positionKey) {

            try {
                $(selector).draggable("instance") && $(selector).draggable("destroy");
            } catch (e) {
                console.log('[Draggable] No previous instance:', selector);
            }

            $(selector).addClass("movable");

            const $elem = $(selector);

            if ($elem.length === 0) {
                console.error('[Draggable] Element not found:', selector);
                return;
            }

            const currentPos = this.state.settings.uiPositions[positionKey];
            const cs = window.getComputedStyle($elem[0]);
            const usesRight = currentPos
                ? currentPos.right !== undefined
                : (cs.right !== 'auto' && cs.left === 'auto');
            const usesCenterX = currentPos
                ? currentPos.left === '50%'
                : /translateX?\(-50%/.test(cs.transform || '');

            this.pinToRect(selector);

            try {
                $(selector).draggable({
                    containment: "body",
                    scroll: false,
                    start: (event, ui) => {
                    },
                    stop: (event, ui) => {
                        const windowWidth = window.innerWidth;
                        const windowHeight = window.innerHeight;

                        const topVh = (ui.position.top / windowHeight * 100).toFixed(2) + 'vh';

                        if (usesRight) {
                            const elemWidth = $(selector).outerWidth();
                            const rightPx = windowWidth - (ui.position.left + elemWidth);
                            const rightVw = (rightPx / windowWidth * 100).toFixed(4) + 'vw';

                            this.state.settings.uiPositions[positionKey] = { top: topVh, right: rightVw };
                        } else if (usesCenterX) {
                            const leftVw = (ui.position.left / windowWidth * 100).toFixed(2) + '%';
                            this.state.settings.uiPositions[positionKey] = { top: topVh, left: leftVw };
                        } else {
                            const leftVw = (ui.position.left / windowWidth * 100).toFixed(2) + 'vw';
                            this.state.settings.uiPositions[positionKey] = { top: topVh, left: leftVw };
                        }
                    }
                });
            } catch (e) {
                console.error('[Draggable] Failed to initialize:', selector, e);
            }
        },
        makeAllUIDraggable() {
            this.makeElementDraggable(".newTeamList", "teamList");
            this.makeElementDraggable(".allScoreList", "scoreList");
            this.makeElementDraggable(".newInviteSide", "inviteSide");
            this.makeElementDraggable(".notifyList", "notificationDiv");
            this.makeElementDraggable(".keyInfoSide", "keyInfoSide");
            this.makeElementDraggable(".dumpsterInfo", "dumpsterInfo");
        },
        saveSettings() {
            clicksound("click.wav", this.playerData.soundEffect);
            this.state.settings.moveUI = false;
            postNUI("saveSettings", {
                uiPositions: this.state.settings.uiPositions,
                soundEffect: this.playerData.soundEffect,
                locale: this.playerData.locale,
                lodQuality: this.lodQuality,
            });

            $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo")
                .removeClass("movable");
            $("body").find(".ui-moving-info").remove();

            $(".newTeamList, .allScoreList, .newInviteSide, .notifyList, .keyInfoSide, .dumpsterInfo")
                .css({ position: '', 'z-index': '', transform: '', animation: '',
                       left: '', right: '', top: '', bottom: '' });
            this.applyUIPositions();

            if (this.notifications.length === 1 && this.notifications[0].message === "You can move the notification") {
                this.notifications = [];
                this.notifyShow = false;
            }
        },
        resetSettings() {
            clicksound("click.wav", this.playerData.soundEffect);
            this.state.settings.uiPositions = {
                teamList: { top: '77.22vh', left: '85.94vw' },
                scoreList: { top: '0vh', left: '1.30vw' },
                inviteSide: { top: '0vh', right: '1.5625vw' },
                notificationDiv: { top: '20vh', left: '1vw' },
                keyInfoSide: { top: '50%', right: '2.0833vw' },
                dumpsterInfo: { top: '1.3542vw', left: '50%' }
            };

            this.applyUIPositions()
        },
        getItemLabel(itemName) {
            const inventoryItem = this.playerInventory.find(i => i.name === itemName);
            if (inventoryItem && inventoryItem.label) {
                return inventoryItem.label;
            }

            return itemName;
        },
        getItemImage(itemName) {
            const inventoryItem = this.playerInventory.find(i => i.name === itemName);
            if (inventoryItem && inventoryItem.image) {
                return `${this.inventoryImagePath}${inventoryItem.image}`;
            }

            return `${this.inventoryImagePath}${itemName}.png`;
        },
        startProgress(label, time) {
            this.progressbarLabel = label;
            this.progressbar = 0;
            this._pbToken = (this._pbToken || 0) + 1;
            const token = this._pbToken;
            const duration = time * 1000;
            let startTime = null;

            const animate = (timestamp) => {
                if (token !== this._pbToken) return;
                if (!startTime) startTime = timestamp;
                const elapsed = timestamp - startTime;
                this.progressbar = Math.min((elapsed / duration) * 100, 100);

                if (elapsed < duration) {
                    requestAnimationFrame(animate);
                } else {
                    setTimeout(() => {
                        stopsound();
                        this.progressbar = 0;
                        this.progressbarLabel = "";
                    }, 100);
                }
            };

            requestAnimationFrame(animate);
        },
        endProgress() {
            this._pbToken = (this._pbToken || 0) + 1;
            this.progressbar = 0;
            this.progressbarLabel = "";
            try { stopsound(); } catch (e) {}
        },
        startTaskHold(ms) {
            this.cancelTaskHold();
            this.taskHoldMs = ms;
            this.taskHold = true;
            this._taskHoldTimer = setTimeout(() => {
                this._taskHoldTimer = null;
                this.taskHold = false;
                this.taskExpand = !this.taskExpand;
            }, ms);
        },
        cancelTaskHold() {
            if (this._taskHoldTimer) { clearTimeout(this._taskHoldTimer); this._taskHoldTimer = null; }
            this.taskHold = false;
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "taskExpand":
                    this.taskExpand = !!event.data.show;
                    this.cancelTaskHold();
                    break;
                case "taskHoldStart":
                    this.startTaskHold(event.data.holdTime || 350);
                    break;
                case "taskHoldRelease":
                    this.cancelTaskHold();
                    break;
                case "CHECK_NUI":
                    postNUI("checkNUI");
                    break;
                case "SET_THEME":
                    window.applyAccent(event.data.payload);
                    break;
                case "CLOSENUI":
                    this.closeNUI();
                    break;
                case "OPEN_MENU":
                    this.state.mainShow = true;
                    this.playerData = event.data.payload;
                    if (event.data.payload.lodQuality) {
                        this.lodQuality = event.data.payload.lodQuality;
                        const lp = this.lodPresets.find(p => p.value === this.lodQuality);
                        if (lp) this.lodLabel = lp.label;
                    }
                    if (event.data.payload.uiSettings) {
                        if (event.data.payload.uiSettings.uiPositions) {
                            this.state.settings.uiPositions = event.data.payload.uiSettings.uiPositions;
                        }
                        this.$nextTick(() => {
                            this.applyUIPositions();
                        });
                    }
                    this.mergeData(this.playerData.dailymission, this.dailyMission);

                    this.state.languageTitle.forEach(item => {
                        if (item.value == this.playerData.locale) {
                            this.localeValue = item.label;
                        }
                    });

                    this.state.showTrainingBadge = !!event.data.payload.showTrainingBadge;
                    if (event.data.payload.trainingStatus) {
                        this.state.trainingStatus = event.data.payload.trainingStatus;
                    }

                    this.syncHeroToSelection();
                    break;
                case "LOBBY_REWARDS":
                    if (!this.rewardDragging) this.rewardSplit = event.data.payload || {};
                    break;
                case "LOAD_LOBBY":
                    this.playerListData = [...event.data.payload];
                    break;
                case "LOAD_HISTORY":
                    this.historyData = event.data.payload;
                    break;
                case "LOAD_LEADERBOARD":
                    this.leaderboardData = event.data.payload || [];
                    this.leaderboardLoaded = true;
                    break;
                case "LEADERBOARD_ENABLED":
                    this.leaderboardEnabled = event.data.payload !== false;
                    if (!this.leaderboardEnabled && this.state.currentPage === 'leaderboard') {
                        this.state.currentPage = 'home';
                    }
                    break;
                case "JOB_IS_ACTIVE":
                    this.state.jobIsActive = event.data.payload;
                    break;
                case "REFRESH_LOBBY":
                    if (!event.data.payload) {
                        this.state.selectedRegion = false;
                    } else {
                        this.state.selectedRegion = event.data.payload;
                    }
                    this.syncHeroToSelection({ animate: true });
                    break;
                case "STATE":
                    this.state.serverName = event.data.payload.serverName;
                    this.state.serverCurrencySymbol = event.data.payload.serverCurrencySymbol;
                    this.state.tebexAccess = event.data.payload.tebexAccess;
                    this.dailyMission = event.data.payload.dailyMission;
                    this.regionData = event.data.payload.regionData;
                    this.state.tutorialPolicy = event.data.payload.tutorialPolicy || 'off';
                    this.state.locales = event.data.payload.locales;
                    this.refreshLocaleLabels();
                    this.state.settings.uiPositions = event.data.payload.uiPositions;
                    if (event.data.payload.uiPositions && event.data.payload.uiPositions) {
                        this.state.settings.uiPositions = event.data.payload.uiPositions;
                        this.$nextTick(() => {
                            this.applyUIPositions();
                        });
                    }
                    this.state.languageTitle = event.data.payload.languageTitle;
                    this.state.defaultLogo = event.data.payload.defaultLogo;

                    if (event.data.payload.inventoryImagePath) {
                        this.inventoryImagePath = event.data.payload.inventoryImagePath;
                    }
                    break;
                case "UPDATE_LOCALES":
                    this.state.locales = event.data.payload
                    this.refreshLocaleLabels();
                    break;
                case "UPDATE_REGIONS":
                    this.regionData = event.data.payload.regionData || this.regionData;
                    if (event.data.payload.dailyMission) {
                        this.dailyMission = event.data.payload.dailyMission;
                        this.mergeData(this.playerData.dailymission, this.dailyMission);
                    }
                    if (this.state.expandedRegion && Array.isArray(this.regionData)) {
                        const id = this.state.expandedRegion.regionID;
                        const fresh = this.regionData.find(r => r.regionID === id);
                        if (fresh) this.state.expandedRegion = fresh;
                    }
                    break;
                case "NEARBY_PLAYERS":
                    this.state.nearbyPlayers = event.data.payload;
                    break;
                case "INVITE_MENU":
                    this.state.requestData = event.data.payload
                    this.state.requestData.show = true;
                    break;
                case "INVITE_PICK":
                    this.pickInvite(event.data.payload && event.data.payload.type === 'reject' ? 'reject' : 'accept');
                    break;
                case "START_JOB":
                    this.state.mainShow = false;
                    this.state.missionScoreData = event.data.payload;
                    this.state.teamShow = true;
                    break;
                case "RECONNECT_TO_JOB":
                    this.state.mainShow = false;
                    this.state.missionScoreData = event.data.payload.jobTask;
                    this.state.teamShow = true;
                    this.state.jobIsActive = true;
                    break;
                case "REFRESH_JOBTASK":
                    this.state.missionScoreData = event.data.payload;
                    break;
                case "UPDATE_PROGRESS": {
                    const p = event.data.payload;
                    if (!p) break;
                    const cur = this.state.jobProgress;
                    if (cur && typeof p.version === 'number' && typeof cur.version === 'number'
                        && p.version < cur.version) break;
                    this.state.jobProgress = p;
                    break;
                }
                case "HIDE_PROGRESS":
                    this.state.jobProgress = null;
                    break;
                case "FINISH_JOB":
                    this.state.finishJobData = event.data.payload;
                    this.state.finishShow = true;
                    this.state.teamShow = false;
                    this.state.mainShow = false;
                    this.state.selectedRegion = false;
                    this.state.jobIsActive = false;
                    this.state.currentPage = 'home';
                    this.state.expandedRegion = null;
                    this.state.heroPhase = null;
                    this.state.missionScoreData = {
                        "Players": [
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 1",
                                "playerLevel": 1,
                                "playerIdentifier": "ID001",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 2",
                                "playerLevel": 2,
                                "playerIdentifier": "ID002",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 3",
                                "playerLevel": 3,
                                "playerIdentifier": "ID003",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 4",
                                "playerLevel": 4,
                                "playerIdentifier": "ID004",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            }
                        ],
                        "regionJobTask": [
                            {
                                "jobLabel": "Test Job 1",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "lawnmowing",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 2",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "prunegrass",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 3",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "branch",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 4",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "plantflower",
                                "invisible": false,
                                "jobCount": 2
                            }
                        ],
                    }
                    break;
                case "RESET_JOB":
                    this.state.finishJobData = false;
                    this.state.finishShow = true;
                    this.state.teamShow = false;
                    this.state.mainShow = false;
                    this.state.selectedRegion = false;
                    this.state.jobIsActive = false;
                    this.state.currentPage = 'home';
                    this.state.expandedRegion = null;
                    this.state.heroPhase = null;

                    this.state.missionScoreData = {
                        "Players": [
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 1",
                                "playerLevel": 1,
                                "playerIdentifier": "ID001",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 2",
                                "playerLevel": 2,
                                "playerIdentifier": "ID002",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 3",
                                "playerLevel": 3,
                                "playerIdentifier": "ID003",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            },
                            {
                                "scoreAmount": 0,
                                "playerName": "Player 4",
                                "playerLevel": 4,
                                "playerIdentifier": "ID004",
                                "playerImage": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "bonusScoreAmount": 0,
                                "source": 1
                            }
                        ],
                        "regionJobTask": [
                            {
                                "jobLabel": "Test Job 1",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "lawnmowing",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 2",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "prunegrass",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 3",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "branch",
                                "invisible": false,
                                "jobCount": 2
                            },
                            {
                                "jobLabel": "Test Job 4",
                                "madeAmount": 0,
                                "finish": false,
                                "img": "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
                                "jobName": "plantflower",
                                "invisible": false,
                                "jobCount": 2
                            }
                        ],
                    }
                    this.closeNUI();
                    break;
                case "OPEN_RENTAL":
                    this.rentalMenu = event.data.payload || null;
                    break;
                case "CLOSE_INVITE_MENU":
                    clicksound("click.wav", this.playerData.soundEffect);
                    this.invitePicked = null;
                    this.state.requestData.show = false;
                    this.state.requestData.show = false;
                    break;
                case "CLOSE_FINISH_JOB":
                    this.state.finishShow = false;
                    this.state.finishJobData = false;
                    break;
                case "LOAD_SETTINGS":
                    this.state.settings.uiPositions = event.data.payload.uiPositions;
                    this.$nextTick(() => {
                        this.applyUIPositions();
                    });
                    break;
                case "EDIT_SETTINGS":
                    this.state.settings.moveUI = true;
                    this.state.mainShow = false;
                    this.state.teamShow = true;

                    this.$nextTick(() => {
                        this.applyUIPositions();
                        this.makeAllUIDraggable();
                    });
                    break;
                case "NOTIFICATION":
                    this.pushNotify(event.data.payload);
                    break;
                case "CRANE_CONTROL": {
                    const p = event.data.payload || {};
                    if (p.layout) {
                        this.craneCtl.layout = p.layout;
                        const hide = p.layout.find(x => x.hide);
                        this.craneCtl.hideKey = hide ? hide.key : '';
                    }
                    if (p.model !== undefined) this.craneCtl.model = !!p.model;
                    if (p.show !== undefined) {
                        this.craneCtl.show = p.show;
                        if (!p.show) {
                            this.craneCtl.hudMode = 0;
                            this.craneCtl.hint = '';
                            this.craneCtl.fill = -1;
                            this.craneCtl.pourState = '';
                            for (const k in this.craneCtl.keys) this.craneCtl.keys[k] = false;
                        }
                    }
                    if (p.hint !== undefined) this.craneCtl.hint = p.hint || '';
                    if (p.hudMode !== undefined) this.craneCtl.hudMode = p.hudMode | 0;
                    if (p.keys) this.craneCtl.keys = { ...this.craneCtl.keys, ...p.keys };
                    if (p.fill !== undefined) this.craneCtl.fill = p.fill;
                    if (p.pourState !== undefined) this.craneCtl.pourState = p.pourState;
                    break;
                }
                case "showProgressBar":
                    this.startProgress(event.data.payload.label, event.data.payload.time);
                    break;
                case "endProgressBar":
                    this.endProgress();
                    break;
                case "playSound":
                    clicksound(event.data.payload.sound, this.playerData.soundEffect);
                    break;
                case "playJobSound":
                    AudioBus.play(event.data.sound, event.data.volume,
                        event.data.channel || 'machine');
                    break;
                case "playLoopSound":
                    AudioBus.startLoop(event.data.handle || event.data.sound,
                        event.data.sound, event.data.volume, event.data.channel || 'machine');
                    break;
                case "setLoopVolume":
                    AudioBus.setLoopVolume(event.data.handle || event.data.sound, event.data.volume);
                    break;
                case "stopLoopSound":
                    AudioBus.stopLoop(event.data.handle || event.data.sound);
                    break;
                case "stopAllLoopSounds":
                    AudioBus.stopAllLoops();
                    break;
                case "soundChannels": {
                    const chs = event.data.channels;
                    if (!chs) break;
                    AudioBus.setChannels(chs);
                    this.soundSettings.forEach(row => {
                        const c = chs[row.key];
                        if (!c) return;
                        if (typeof c.enabled === 'boolean') row.enabled = c.enabled;
                        if (typeof c.volume === 'number') row.volume = c.volume;
                    });
                    if (chs.ui && typeof chs.ui.enabled === 'boolean') {
                        this.playerData.soundEffect = chs.ui.enabled;
                    }
                    break;
                }
                case "TUTORIAL_STEP":
                    this.state.trainingDone = null;
                    this.state.trainingStep = event.data.payload;
                    this.state.trainingProgress = 0;
                    break;
                case "TUTORIAL_PROGRESS":
                    this.state.trainingProgress = (event.data.payload && event.data.payload.pct) || 0;
                    break;
                case "TUTORIAL_DONE":
                    this.state.trainingStep = null;
                    this.state.trainingProgress = 0;
                    this.state.trainingDone = event.data.payload;
                    if (event.data.payload && event.data.payload.module) {
                        this.state.trainingStatus[event.data.payload.module] = true;
                    }
                    clearTimeout(this._trainingDoneTimer);
                    this._trainingDoneTimer = setTimeout(() => { this.state.trainingDone = null; }, 6000);
                    break;
                case "HINT_CARD_SHOW":
                    this.state.hintCard = event.data.payload || null;
                    break;
                case "HINT_CARD_HIDE":
                    this.state.hintCard = null;
                    break;
                case "TUTORIAL_RESET":
                    this.state.trainingStep = null;
                    this.state.trainingProgress = 0;
                    this.state.trainingDone = null;
                    break;
                case "SET_INVENTORY":
                    this.playerInventory = event.data.payload;
                    break;
                case "SHOW_INFO_PANEL":
                    if (typeof event.data.payload === 'object') {
                        this.infoPanelVisible = event.data.payload.visible;
                        this.hidePagination = event.data.payload.hidePagination || false;
                        this.trunkOpen = event.data.payload.trunkOpen !== undefined ? event.data.payload.trunkOpen : true;
                    } else {
                        this.infoPanelVisible = event.data.payload;
                        this.hidePagination = false;
                        this.trunkOpen = true;
                    }
                    break;
                case "SHOW_KEY_INFO":
                    if (typeof event.data.payload === 'object') {
                        this.keyInfoVisible = event.data.payload.visible;
                        this.hidePagination = event.data.payload.hidePagination || false;
                        this.hideArrows = event.data.payload.hideArrows || false;
                        this.hideConfirm = event.data.payload.hideConfirm || false;
                    } else {
                        this.keyInfoVisible = event.data.payload;
                        this.hidePagination = false;
                        this.hideArrows = false;
                        this.hideConfirm = false;
                    }
                    break;
                case "TEXTUI_SHOW":
                    this.textUIItems = event.data.payload;
                    break;
                case "TEXTUI_HIDE":
                    this.textUIItems = [];
                    break;
                case "SHOW_DRAWTEXT":
                    this.showDrawText(event.data.payload);
                    break;
                case "HIDE_DRAWTEXT":
                    this.hideDrawText();
                    break;
                default:
                    break;
            }
        },

    },
    computed: {
        pfLevel() {
            const f = this.craneCtl.fill;
            if (f >= 0.66) return 'high';
            if (f >= 0.33) return 'mid';
            return 'low';
        },
        pourText() {
            const st = this.craneCtl.pourState || '';
            const L = this.state.locales || {};
            if (st === 'on') return L['pv2_hud_pouring'] || 'POURING';
            if (st === 'pending') return L['pv2_hud_pour_pending'] || 'POURING IN 2s...';
            if (st.startsWith('blocked:')) {
                const why = st.slice(8);
                return (L['pv2_hud_pour_blocked_short'] || 'No E: %s').replace('%s', why);
            }
            return '';
        },
        pourLevel() {
            const st = this.craneCtl.pourState || '';
            if (st === 'on') return 'ok';
            if (st === 'pending') return 'wait';
            return 'blocked';
        },
        cpDashoffset() {
            const c = 2 * Math.PI * 18;
            const p = Math.min(Math.max(this.progressbar, 0), 100);
            return c * (1 - p / 100);
        },
        sortedLeaderboard() {
            const key = this.leaderboardSort === 'tasks' ? 'tasksDone' : 'moneyEarned';
            return [...(this.leaderboardData || [])].sort((a, b) => (b[key] || 0) - (a[key] || 0));
        },
        getRegionAwards(region) {
            if (region && region.regionAwards) {
                return region.regionAwards.newMoney || region.regionAwards.money;
            }
            return 0;
        },
        progressPercentage() {
            if (this.playerData.playerXp == null || this.playerData.playerNextXp == null) return 0;
            let percentage = (this.playerData.playerXp / this.playerData.playerNextXp) * 100;
            if (percentage > 100) {
                return 100;
            }
            return percentage;
        },
        displayedRegions() {
            return this.regionData.slice(
                this.state.currentRegionIndex,
                this.state.currentRegionIndex + this.state.regionsPerPage
            );
        },
        heroMedia() {
            const region = this.state.expandedRegion;
            return this.regionImgSrc(region && region.regionInfo);
        },
        startBlocked() {
            if (this.state.jobIsActive) return false;
            if (this.isLobbyMember) return true;
            const region = this.state.selectedRegion;
            if (!region) return false;
            return this.crewIncompatible(region);
        },
        startBlockedText() {
            if (!this.state.jobIsActive && this.isLobbyMember) {
                return this.state.locales['waitingForLeader'] || 'WAITING FOR THE CREW LEADER';
            }
            const region = this.state.selectedRegion;
            if (!region) return '';
            const requireText = this.state.locales['crewRequire'] || 'THIS REGION REQUIRES';
            return `${requireText} ${this.crewLabel(region)}`;
        },
        visibleJobTasks() {
            const rows = (this.state.missionScoreData && this.state.missionScoreData.regionJobTask) || [];
            if (!rows.length) return [];
            const open = rows.filter(r => !r.finish);
            if (!open.length) return rows.slice(-1);
            if (this.taskExpand) return open;
            const MAX = 3;
            const out = open.slice(0, MAX);
            if (out.length < MAX) {
                const from = rows.indexOf(out[out.length - 1]);
                for (let i = from + 1; i < rows.length && out.length < MAX; i++) out.push(rows[i]);
            }
            return out;
        },
        displayedDailyMission() {
            return this.playerData.playerDailyMission.slice(
                this.state.currentDailyMissionIndex,
                this.state.currentDailyMissionIndex + this.state.dailyMissionsPerPage
            );
        },
        canGoNext() {
            return this.state.currentRegionIndex + this.state.regionsPerPage < this.regionData.length;
        },
        canGoPrev() {
            return this.state.currentRegionIndex > 0;
        },
        canGoNextDailyMission() {
            return this.state.currentDailyMissionIndex + this.state.dailyMissionsPerPage < this.playerData.playerDailyMission.length;
        },
        canGoPrevDailyMission() {
            return this.state.currentDailyMissionIndex > 0;
        },
        inviteSlots() {
            const totalPlayers = this.playerListData.length + Object.values(this.state.nearbyPlayers).length;
            const missing = 4 - totalPlayers;
            return missing > 0 ? missing : 0;
        },
        isPlayerOwner() {
            const ownerPlayer = this.playerListData.find(x => x.playerOwner === true);
            if (!ownerPlayer) return false;
            return this.playerData.playerIdentifier === ownerPlayer.playerIdentifier;
        },
        canSplitRewards() {
            return this.isPlayerOwner && !this.state.jobIsActive && this.playerListData.length > 1;
        },
        rewardTotal() {
            return this.playerListData.reduce((s, p) => s + this.rewardPctOf(p.playerIdentifier), 0);
        },
        myRewardPct() {
            const id = this.playerData && this.playerData.playerIdentifier;
            if (!id) return null;
            const v = this.rewardSplit[id];
            return typeof v === 'number' ? Math.round(v) : null;
        },
        isLobbyMember() {
            return this.playerListData.length > 0 && !this.isPlayerOwner;
        },
        startButtonText() {
            if (this.state.jobIsActive) {
                if (!this.isPlayerOwner) {
                    return this.state.locales['leaveLobby'] || 'Leave Lobby';
                }
                return this.state.locales['jobReset'];
            }
            return this.state.locales['jobStart'];
        },
    }
});

app.use(store).mount("#app");

const AudioBus = {
    ctx: null,
    master: null,
    ch: {},
    state: {
        ui:      { enabled: true, volume: 80 },
        machine: { enabled: true, volume: 10 },
    },
    buffers: {},
    pending: {},
    loops: {},
    lastOneShot: null,

    ensure() {
        if (this.ctx) {
            if (this.ctx.state === 'suspended') this.ctx.resume().catch(() => {});
            return this.ctx;
        }
        const AC = window.AudioContext || window.webkitAudioContext;
        if (!AC) return null;
        try {
            this.ctx = new AC();
        } catch (e) {
            return null;
        }
        this.master = this.ctx.createGain();
        this.master.gain.value = 1;
        this.master.connect(this.ctx.destination);
        for (const k in this.state) {
            const g = this.ctx.createGain();
            g.connect(this.master);
            this.ch[k] = g;
        }
        this.applyGains();
        return this.ctx;
    },

    applyGains() {
        for (const k in this.state) {
            const g = this.ch[k];
            if (!g) continue;
            const s = this.state[k];
            const v = Math.max(0, Math.min(100, Number(s.volume) || 0)) / 100;
            g.gain.value = s.enabled ? v : 0;
        }
    },

    setChannels(next) {
        if (!next) return;
        for (const k in this.state) {
            const n = next[k];
            if (!n) continue;
            if (typeof n.enabled === 'boolean') this.state[k].enabled = n.enabled;
            if (typeof n.volume === 'number') this.state[k].volume = n.volume;
        }
        if (this.ctx) this.applyGains();
    },

    fileOf(name) { return name.includes('.') ? name : (name + '.mp3'); },

    load(name) {
        const fn = this.fileOf(name);
        if (this.buffers[fn]) return Promise.resolve(this.buffers[fn]);
        if (this.pending[fn]) return this.pending[fn];
        const ctx = this.ensure();
        if (!ctx) return Promise.reject(new Error('no audio context'));
        const p = fetch(`./sounds/${fn}`)
            .then(r => r.arrayBuffer())
            .then(b => ctx.decodeAudioData(b))
            .then(d => { this.buffers[fn] = d; delete this.pending[fn]; return d; })
            .catch(e => { delete this.pending[fn]; throw e; });
        this.pending[fn] = p;
        return p;
    },

    play(name, volume, channel) {
        if (!name) return;
        const ctx = this.ensure();
        const chGain = this.ch[channel] || this.ch.machine;
        if (!ctx || !chGain) return;
        const v = Math.min(Math.max(volume == null ? 0.5 : volume, 0), 1);
        this.load(name).then(buf => {
            const g = ctx.createGain();
            g.gain.value = v;
            g.connect(chGain);
            const s = ctx.createBufferSource();
            s.buffer = buf;
            s.connect(g);
            s.onended = () => { try { g.disconnect(); } catch (e) {} };
            s.start(0);
            this.lastOneShot = s;
        }).catch(() => {});
    },

    startLoop(handle, name, volume, channel) {
        if (!handle || !name) return;
        const ctx = this.ensure();
        const chGain = this.ch[channel] || this.ch.machine;
        if (!ctx || !chGain) return;
        const v = Math.min(Math.max(volume == null ? 0.5 : volume, 0), 1);
        const cur = this.loops[handle];
        if (cur) {
            cur.vol = v;
            if (cur.gain) cur.gain.gain.value = v;
            return;
        }
        const slot = { gain: null, src: null, vol: v, stopped: false, name };
        this.loops[handle] = slot;
        this.load(name).then(buf => {
            if (slot.stopped) return;
            const g = ctx.createGain();
            g.gain.value = slot.vol;
            g.connect(chGain);
            const s = ctx.createBufferSource();
            s.buffer = buf;
            s.loop = true;
            s.connect(g);
            s.start(0);
            slot.gain = g;
            slot.src = s;
        }).catch(() => {
            if (this.loops[handle] === slot) delete this.loops[handle];
        });
    },

    setLoopVolume(handle, volume) {
        const s = this.loops[handle];
        if (!s) return;
        const v = Math.min(Math.max(volume || 0, 0), 1);
        s.vol = v;
        if (s.gain) s.gain.gain.value = v;
    },

    stopLoop(handle) {
        const s = this.loops[handle];
        if (!s) return;
        s.stopped = true;
        if (s.src)  { try { s.src.stop(0); }    catch (e) {} }
        if (s.gain) { try { s.gain.disconnect(); } catch (e) {} }
        delete this.loops[handle];
    },

    stopAllLoops() {
        for (const k in this.loops) this.stopLoop(k);
    },
};
window.AudioBus = AudioBus;

function clicksound(val, soundEffect) {
    if (soundEffect === false || soundEffect == null) return;
    AudioBus.play(val, 0.4, 'ui');
}

function stopsound() {
    const s = AudioBus.lastOneShot;
    if (!s) return;
    try { s.stop(0); } catch (e) {}
    AudioBus.lastOneShot = null;
}
