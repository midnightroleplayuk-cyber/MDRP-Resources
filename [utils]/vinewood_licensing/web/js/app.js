(() => {
    'use strict';

    const App = {
        locale: {},
        state: {
            currentScreen: null,
            categories: {},
            licences: {},
            theoryPassed: {},
            practicalPassed: {},
            selectedCategory: null,
            theory: {
                questions: [],
                answers: {},
                currentIndex: 0,
                total: 0,
                maxMistakes: 0,
                categoryLabel: ''
            },
            lastResult: null
        },

        el: {},

        init() {
            this.cacheDOM();
            this.bindEvents();
            this.showScreen(null);
        },

        cacheDOM() {
            this.el.app = document.getElementById('app');
            this.el.screens = {
                menu: document.getElementById('menu-screen'),
                theory: document.getElementById('theory-screen'),
                result: document.getElementById('result-screen'),
                fail: document.getElementById('fail-screen')
            };
            this.el.hud = document.getElementById('practical-hud');
            this.el.categoryList = document.getElementById('category-list');
            this.el.categoryHint = document.getElementById('category-hint');
            this.el.btnProvisional = document.getElementById('btn-provisional');
            this.el.btnReplacement = document.getElementById('btn-replacement');
            this.el.btnPhoto = document.getElementById('btn-photo');
            this.el.menuTitle = document.getElementById('menu-title');
            this.el.menuSubtitle = document.getElementById('menu-subtitle');
            this.el.provisionalHint = document.getElementById('provisional-hint');
            this.el.licenceTitle = document.getElementById('licence-title');

            this.el.btnCloseMenu = document.getElementById('btn-close-menu');
            this.el.btnTheoryPrev = document.getElementById('btn-theory-prev');
            this.el.btnTheoryNext = document.getElementById('btn-theory-next');
            this.el.btnTheorySubmit = document.getElementById('btn-theory-submit');

            this.el.theorySubtitle = document.getElementById('theory-subtitle');
            this.el.progressFill = document.getElementById('progress-fill');
            this.el.progressText = document.getElementById('progress-text');
            this.el.progressMistakes = document.getElementById('progress-mistakes');
            this.el.questionNumber = document.getElementById('question-number');
            this.el.questionImageWrap = document.getElementById('question-image-wrap');
            this.el.questionImage = document.getElementById('question-image');
            this.el.questionText = document.getElementById('question-text');
            this.el.questionOptions = document.getElementById('question-options');

            this.el.resultScreen = document.getElementById('result-screen');
            this.el.resultIcon = document.getElementById('result-icon');
            this.el.resultTitle = document.getElementById('result-title');
            this.el.resultSubtitle = document.getElementById('result-subtitle');
            this.el.resultScore = document.getElementById('result-score');
            this.el.resultMistakes = document.getElementById('result-mistakes');
            this.el.resultTime = document.getElementById('result-time');
            this.el.resultMessage = document.getElementById('result-message');
            this.el.btnResultPractical = document.getElementById('btn-result-practical');
            this.el.btnResultClose = document.getElementById('btn-result-close');

            this.el.failScreen = document.getElementById('fail-screen');
            this.el.failSubtitle = document.getElementById('fail-subtitle');
            this.el.failScore = document.getElementById('fail-score');
            this.el.failMistakes = document.getElementById('fail-mistakes');
            this.el.failTime = document.getElementById('fail-time');
            this.el.failReason = document.getElementById('fail-reason');
            this.el.btnRetryExam = document.getElementById('btn-retry-exam');
            this.el.btnFailMenu = document.getElementById('btn-fail-menu');

            this.el.licenceScreen = document.getElementById('licence-screen');
            this.el.licencePhoto = document.getElementById('licence-photo');
            this.el.licencePhotoFoot = document.getElementById('licence-issued-foot');
            this.el.licenceF1 = document.getElementById('licence-f1');
            this.el.licenceF2 = document.getElementById('licence-f2');
            this.el.licenceF3a = document.getElementById('licence-f3a');
            this.el.licenceF3b = document.getElementById('licence-f3b');
            this.el.licenceF4a = document.getElementById('licence-f4a');
            this.el.licenceF4c = document.getElementById('licence-f4c');
            this.el.licenceF4b = document.getElementById('licence-f4b');
            this.el.licenceF5 = document.getElementById('licence-f5');
            this.el.licenceF8 = document.getElementById('licence-f8');
            this.el.licenceF9 = document.getElementById('licence-f9');
            this.el.licenceSignature = document.getElementById('licence-signature');
            this.el.licenceMrz = document.getElementById('licence-mrz');
            this.el.licenceOwner = document.getElementById('licence-owner');
            this.el.btnLicenceClose = document.getElementById('btn-licence-close');

            this.el.hudCategory = document.getElementById('hud-category');
            this.el.hudCheckpointsValue = document.getElementById('hud-checkpoints-value');
            this.el.hudCheckpointsProgress = document.getElementById('hud-checkpoints-progress');
            this.el.hudTimeValue = document.getElementById('hud-time-value');
            this.el.hudSpeedValue = document.getElementById('hud-speed-value');
            this.el.hudMaxSpeedValue = document.getElementById('hud-max-speed-value');
            this.el.hudMistakesValue = document.getElementById('hud-mistakes-value');
            this.el.hudNotification = document.getElementById('hud-notification');
        },

        bindEvents() {
            this.el.btnCloseMenu.addEventListener('click', () => this.closeMenu());

            this.el.btnTheoryPrev.addEventListener('click', () => this.prevQuestion());
            this.el.btnTheoryNext.addEventListener('click', () => this.nextQuestion());
            this.el.btnTheorySubmit.addEventListener('click', () => this.submitTheory());

            this.el.btnResultPractical.addEventListener('click', () => this.continueToPractical());
            this.el.btnResultClose.addEventListener('click', () => this.closeApp());

            this.el.btnRetryExam.addEventListener('click', () => this.retryExam());
            this.el.btnFailMenu.addEventListener('click', () => this.renderMenu());

            if (this.el.btnLicenceClose) {
                this.el.btnLicenceClose.addEventListener('click', () => this.closeLicence());
            }

            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    if (this.el.licenceScreen && this.el.licenceScreen.style.display !== 'none') {
                        this.closeLicence();
                        return;
                    }
                    if (this.state.currentScreen === 'menu' || this.state.currentScreen === 'result' || this.state.currentScreen === 'fail') {
                        this.closeMenu();
                    }
                }
            });
        },

        post(type, data = {}) {
            const payload = JSON.stringify(Object.assign({ type }, data));
            if (window.GetParentResourceName && window.fetch) {
                fetch(`https://${GetParentResourceName()}/nuiEvent`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                    body: payload
                }).catch(() => {});
            }
        },

        hideLicence() {
            if (this.el.licenceScreen) this.el.licenceScreen.style.display = 'none';
        },

        closeLicence() {
            this.hideLicence();
            if (window.GetParentResourceName && window.fetch) {
                fetch(`https://${GetParentResourceName()}/closeLicence`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                    body: '{}'
                }).catch(() => {});
            }
        },

        // Crops the screenshot to a passport shape and shrinks it, so what goes
        // to the server is tens of KB rather than megabytes.
        processPhoto(msg) {
            const reply = (data) => {
                if (!window.GetParentResourceName || !window.fetch) return;
                fetch(`https://${GetParentResourceName()}/photoProcessed`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                    body: JSON.stringify({ photo: data || null })
                }).catch(() => {});
            };

            try {
                const outW = msg.width || 420;
                const outH = msg.height || 540;
                const img = new Image();
                img.onload = () => {
                    try {
                        const canvas = document.createElement('canvas');
                        canvas.width = outW;
                        canvas.height = outH;
                        const ctx = canvas.getContext('2d');

                        // centre crop to the output aspect ratio
                        const targetRatio = outW / outH;
                        let sw = img.width;
                        let sh = Math.round(sw / targetRatio);
                        if (sh > img.height) {
                            sh = img.height;
                            sw = Math.round(sh * targetRatio);
                        }
                        const sx = Math.round((img.width - sw) / 2);
                        const sy = Math.round((img.height - sh) / 2);

                        ctx.drawImage(img, sx, sy, sw, sh, 0, 0, outW, outH);
                        reply(canvas.toDataURL('image/jpeg', msg.quality || 0.85));
                    } catch (e) {
                        reply(null);
                    }
                };
                img.onerror = () => reply(null);
                img.src = msg.photo;
            } catch (e) {
                reply(null);
            }
        },

        setLicencePhoto(url) {
            const src = url || 'assets/licence/placeholder-photo.svg';
            if (this.el.licencePhoto) this.el.licencePhoto.src = src;
            const ghost = document.getElementById('licence-ghost');
            if (ghost) ghost.src = src;
        },

        showLicence(data) {
            if (!this.el.licenceScreen) return;
            const m = (data && data.metadata) ? data.metadata : {};
            const def = (v, fallback) => (v != null && String(v).trim() !== '') ? String(v) : fallback;
            const set = (el, v) => { if (el) el.textContent = v; };

            const card = this.el.licenceScreen.querySelector('.dl-card');
            const isProvisional = !!m.provisional;
            if (card) card.classList.toggle('provisional', isProvisional);
            if (this.el.licenceTitle) {
                this.el.licenceTitle.textContent = isProvisional ? 'PROVISIONAL LICENCE' : 'DRIVING LICENCE';
            }

            this.setLicencePhoto((data && data.photo) || (typeof m.photo === 'string' && /^https?:/.test(m.photo) ? m.photo : null));
            this.el.licenceSignature.src = def(m.signature, 'assets/licence/placeholder-signature.svg');

            set(this.el.licenceF1, def(m.lastname, '—'));
            set(this.el.licenceF2, def(m.firstname, '—'));
            set(this.el.licenceF3a, def(m.dob, '—'));
            set(this.el.licenceF3b, def(m.country, 'UNITED KINGDOM'));
            set(this.el.licenceF4a, def(m.issued, '—'));
            set(this.el.licenceF4c, def(m.authority, 'DVLA'));
            set(this.el.licenceF4b, def(m.expiry, '—'));
            set(this.el.licenceF5, def(m.number, '—'));
            set(this.el.licenceF9, def(m.categories, '—'));
            if (this.el.licenceF8) {
                this.el.licenceF8.textContent = '';
                def(m.address, 'NO ADDRESS ON FILE').split('\n').forEach((line, i) => {
                    if (i) this.el.licenceF8.appendChild(document.createElement('br'));
                    this.el.licenceF8.appendChild(document.createTextNode(line));
                });
            }
            set(this.el.licencePhotoFoot, def(m.issued, ''));
            set(this.el.licenceMrz, def(m.mrz, ''));
            if (this.el.licenceOwner) {
                const who = data && data.ownerLabel ? ('Shown by ' + data.ownerLabel) : '';
                this.el.licenceOwner.textContent = who;
                this.el.licenceOwner.style.display = who ? '' : 'none';
            }

            // restart the entrance + sheen animation each time
            this.el.licenceScreen.style.display = 'none';
            void this.el.licenceScreen.offsetWidth;
            this.el.licenceScreen.style.display = 'flex';
        },

        showScreen(id) {
            Object.entries(this.el.screens).forEach(([name, node]) => {
                if (node) {
                    node.classList.toggle('active', name === id);
                }
            });
            if (id) {
                this.el.app.classList.add('active');
                this.state.currentScreen = id;
            } else {
                this.el.app.classList.remove('active');
                this.state.currentScreen = null;
            }
        },

        showHud(show) {
            this.el.hud.classList.toggle('active', !!show);
        },

        t(key, ...args) {
            let str = this.locale[key] || `!!MISSING:${key}!!`;
            if (args.length > 0) {
                args.forEach((v, i) => {
                    str = str.replace(`%s`, String(v));
                });
                let idx = 0;
                str = str.replace(/%s/g, () => args[idx++] || '');
            }
            return str;
        },

        applyLocaleToDOM() {
            document.querySelectorAll('[data-locale]').forEach((el) => {
                const key = el.getAttribute('data-locale');
                const v = this.t(key);
                if (v && !v.startsWith('!!MISSING')) el.textContent = v;
            });
        },

        formatTime(totalSeconds) {
            const s = Math.max(0, Math.floor(Number(totalSeconds) || 0));
            const m = Math.floor(s / 60);
            const ss = s % 60;
            return `${String(m).padStart(2, '0')}:${String(ss).padStart(2, '0')}`;
        },

        onOpenMenu(data) {
            this.locale = data.locale || {};
            this.state.categories = data.categories || {};
            this.state.licences = data.licences || {};
            this.state.theoryPassed = data.theoryPassed || {};
            this.state.practicalPassed = data.practicalPassed || {};
            this.state.provisional = data.provisional || { enabled: false, held: false, entitled: false, required: false, price: 0 };
            this.state.mode = data.mode === 'desk' ? 'desk' : 'exam';
            this.state.replacement = data.replacement || { enabled: false, eligible: false, price: 0 };
            this.state.photoUpdate = data.photoUpdate || { enabled: false, eligible: false, price: 0 };
            this.applyLocaleToDOM();
            this.renderMenu();
        },

        renderProvisional() {
            const btn = this.el.btnProvisional;
            const p = this.state.provisional || {};
            if (!btn) return;
            if (!p.enabled || this.state.mode !== 'desk' || (p.entitled && !p.held)) {
                btn.style.display = 'none';
                if (this.el.provisionalHint) {
                    const p2 = this.state.provisional || {};
                    const needed = p2.enabled && p2.required && !p2.entitled;
                    this.el.provisionalHint.textContent = needed ? this.t('menu_provisional_elsewhere') : '';
                }
                return;
            }
            btn.style.display = '';
            if (p.held) {
                btn.textContent = this.t('menu_provisional_held');
                btn.classList.add('disabled');
                btn.disabled = true;
                if (this.el.provisionalHint) this.el.provisionalHint.textContent = '';
            } else {
                const fee = p.price > 0 ? ` (${p.price})` : '';
                btn.textContent = this.t('menu_provisional_btn') + fee;
                btn.classList.remove('disabled');
                btn.disabled = false;
                if (this.el.provisionalHint) this.el.provisionalHint.textContent = this.t('menu_provisional_photo');
            }
            btn.onclick = () => {
                if (btn.disabled) return;
                this.post('applyProvisional', {});
            };
        },

        renderReplacement() {
            const btn = this.el.btnReplacement;
            if (!btn) return;
            const r = this.state.replacement || {};
            if (!r.enabled || this.state.mode !== 'desk') {
                btn.style.display = 'none';
                return;
            }
            btn.style.display = '';
            const fee = r.price > 0 ? ` (${r.price})` : '';
            btn.textContent = this.t('menu_replacement_btn') + fee;
            const blocked = !r.eligible;
            btn.disabled = blocked;
            btn.classList.toggle('disabled', blocked);
            if (blocked) {
                btn.title = r.held ? this.t('menu_replacement_held') : this.t('menu_replacement_none');
            } else {
                btn.title = '';
            }
            btn.onclick = () => {
                if (btn.disabled) return;
                this.post('replaceLicence', { needsPhoto: !!r.needsPhoto });
            };
        },

        renderPhotoUpdate() {
            const btn = this.el.btnPhoto;
            if (!btn) return;
            const p = this.state.photoUpdate || {};
            if (!p.enabled || this.state.mode !== 'desk') {
                btn.style.display = 'none';
                return;
            }
            btn.style.display = '';
            const fee = p.price > 0 ? ` (${p.price})` : '';
            btn.textContent = this.t('menu_photo_btn') + fee;
            btn.disabled = !p.eligible;
            btn.classList.toggle('disabled', !p.eligible);
            btn.title = p.eligible ? '' : this.t('menu_photo_none');
            btn.onclick = () => {
                if (btn.disabled) return;
                this.post('updatePhoto', {});
            };
        },

        renderMenu() {
            const desk = this.state.mode === 'desk';
            if (this.el.menuTitle) {
                this.el.menuTitle.textContent = this.t(desk ? 'menu_desk_title' : 'menu_title');
            }
            if (this.el.menuSubtitle) {
                this.el.menuSubtitle.textContent = this.t(desk ? 'menu_desk_subtitle' : 'menu_subtitle');
            }
            this.renderProvisional();
            this.renderReplacement();
            this.renderPhotoUpdate();
            this.el.categoryList.innerHTML = '';
            this.el.categoryList.style.display = desk ? 'none' : '';
            if (desk) {
                this.el.categoryHint.textContent = '';
                this.showScreen('menu');
                return;
            }
            const entries = Object.values(this.state.categories || {});
            if (entries.length === 0) {
                this.el.categoryHint.textContent = this.t('error_invalid_category');
                this.showScreen('menu');
                return;
            }
            this.el.categoryHint.textContent = '';

            entries.forEach((cat) => {
                const catKey = cat.key;
                const alreadyLicensed = !!this.state.licences[catKey];
                const theoryPassed = !!this.state.theoryPassed[catKey] || alreadyLicensed;
                const practicalPassed = !!this.state.practicalPassed[catKey] || alreadyLicensed;

                const card = document.createElement('div');
                card.className = 'category-card';
                if (alreadyLicensed) card.classList.add('completed');

                const badgeText = alreadyLicensed
                    ? this.t('menu_license_held')
                    : (practicalPassed ? this.t('menu_category_status_passed') : (theoryPassed ? 'Theory Passed' : ''));
                const badgeClass = alreadyLicensed || practicalPassed ? 'badge-completed' : (theoryPassed ? 'badge-pending' : '');

                const info = `
                    <div class="category-info">
                        <span>${this.t('menu_theory_btn')}: ${this.t('result_mistakes')} &le; ${cat.maxMistakesTheory}</span>
                        <span>${this.t('menu_practical_btn')}: ${this.t('hud_max_speed')} ${cat.maxSpeed} mph</span>
                    </div>
                `;

                const p = this.state.provisional || {};
                const needsProvisional = p.enabled && p.required && !p.entitled && !alreadyLicensed;
                const theoryDisabled = (alreadyLicensed || needsProvisional) ? 'disabled' : '';
                const practicalDisabled = (alreadyLicensed || needsProvisional || !theoryPassed) ? 'disabled' : '';
                const practicalTitle = needsProvisional
                    ? `title="${this.t('error_provisional_required')}"`
                    : (!theoryPassed ? `title="${this.t('menu_theory_required')}"` : '');

                card.innerHTML = `
                    <div class="category-label">
                        <span>${cat.label}</span>
                        ${badgeText ? `<span class="category-status-badge ${badgeClass}">${badgeText}</span>` : ''}
                    </div>
                    ${info}
                    <div class="category-buttons">
                        <button class="btn ${theoryDisabled}" data-action="start-theory" data-cat="${catKey}" ${theoryDisabled ? 'disabled' : ''}>
                            ${this.t('menu_theory_btn')}
                        </button>
                        <button class="btn btn-secondary ${practicalDisabled}" data-action="start-practical" data-cat="${catKey}" ${practicalDisabled ? 'disabled' : ''} ${practicalTitle}>
                            ${this.t('menu_practical_btn')}
                        </button>
                    </div>
                `;

                card.querySelectorAll('button[data-action]').forEach((btn) => {
                    btn.addEventListener('click', (e) => {
                        const action = btn.getAttribute('data-action');
                        const category = btn.getAttribute('data-cat');
                        if (action === 'start-theory') this.startTheory(category);
                        if (action === 'start-practical') this.startPractical(category);
                    });
                });

                this.el.categoryList.appendChild(card);
            });

            this.showScreen('menu');
        },

        startTheory(category) {
            this.state.selectedCategory = category;
            this.post('startTheory', { category });
        },

        onStartTheory(data) {
            if (!data.ok) {
                this.notifyError(data.error);
                return;
            }
            const t = this.state.theory;
            t.questions = data.questions || [];
            t.answers = {};
            t.currentIndex = 0;
            t.total = data.totalQuestions || t.questions.length;
            t.maxMistakes = data.maxMistakes || 0;
            t.categoryLabel = data.categoryLabel || this.state.categories[category]?.label || category;

            this.el.theorySubtitle.textContent = this.t('theory_subtitle', String(t.maxMistakes));
            this.renderTheoryQuestion();
            this.showScreen('theory');
        },

        renderTheoryQuestion() {
            const t = this.state.theory;
            const idx = t.currentIndex;
            const q = t.questions[idx];
            if (!q) return;

            const selected = t.answers[q.id];

            this.el.questionNumber.textContent = `QUESTION ${idx + 1}`;

            if (q.image) {
                this.el.questionImageWrap.style.display = '';
                this.el.questionImage.src = q.image;
            } else {
                this.el.questionImageWrap.style.display = 'none';
                this.el.questionImage.removeAttribute('src');
            }

            this.el.questionText.textContent = q.question;

            const total = t.total;
            const answered = Object.keys(t.answers).length;
            const pct = total > 0 ? Math.round(((idx + 1) / total) * 100) : 0;
            this.el.progressFill.style.width = `${pct}%`;
            this.el.progressText.textContent = this.t('theory_question', String(idx + 1), String(total));
            this.el.progressMistakes.textContent = `${this.t('result_mistakes')}: — / ${t.maxMistakes}  (${this.t('result_score')}: ${answered}/${total} answered)`;

            this.el.questionOptions.innerHTML = '';
            (q.options || []).forEach((opt, i) => {
                const node = document.createElement('div');
                node.className = 'option';
                if (selected === i) node.classList.add('selected');
                node.innerHTML = `
                    <div class="option-radio"><div class="option-radio-inner"></div></div>
                    <div class="option-text"></div>
                `;
                node.querySelector('.option-text').textContent = opt;
                node.addEventListener('click', () => {
                    t.answers[q.id] = i;
                    this.renderTheoryQuestion();
                });
                this.el.questionOptions.appendChild(node);
            });

            this.el.btnTheoryPrev.disabled = idx <= 0;
            const atEnd = idx >= t.total - 1;
            const allAnswered = Object.keys(t.answers).length >= t.total;
            this.el.btnTheorySubmit.classList.toggle('disabled', !allAnswered);
            this.el.btnTheorySubmit.disabled = !allAnswered;
            this.el.btnTheoryNext.disabled = atEnd;
        },

        prevQuestion() {
            if (this.state.theory.currentIndex > 0) {
                this.state.theory.currentIndex--;
                this.renderTheoryQuestion();
            }
        },

        nextQuestion() {
            if (this.state.theory.currentIndex < this.state.theory.total - 1) {
                this.state.theory.currentIndex++;
                this.renderTheoryQuestion();
            }
        },

        submitTheory() {
            const t = this.state.theory;
            if (Object.keys(t.answers).length < t.total) return;
            this.post('submitTheory', {
                category: this.state.selectedCategory,
                answers: t.answers
            });
        },

        onTheoryResult(data) {
            if (!data.ok) {
                this.notifyError(data.error);
                return;
            }
            this.state.lastResult = {
                examType: 'theory',
                category: this.state.selectedCategory,
                data
            };
            if (data.passed) {
                this.showResultScreen({
                    isTheory: true,
                    passed: true,
                    score: data.score,
                    mistakes: data.mistakes,
                    total: data.total,
                    time: data.timeTaken,
                    categoryLabel: data.categoryLabel,
                    canContinue: true
                });
                if (this.state.theoryPassed) this.state.theoryPassed[this.state.selectedCategory] = true;
            } else {
                this.showFailScreen({
                    score: data.score,
                    mistakes: data.mistakes,
                    total: data.total,
                    time: data.timeTaken,
                    maxMistakes: data.maxMistakes,
                    categoryLabel: data.categoryLabel,
                    examType: 'theory'
                });
            }
        },

        startPractical(category) {
            this.state.selectedCategory = category;
            this.closeApp();
            this.post('startPractical', { category });
        },

        continueToPractical() {
            const category = this.state.selectedCategory;
            if (!category) return;
            this.closeApp();
            this.post('startPractical', { category });
        },

        showResultScreen(r) {
            const s = this.el.resultScreen;
            const icon = this.el.resultIcon;
            const title = this.el.resultTitle;

            s.classList.add('result-screen', 'pass');
            s.classList.remove('fail');
            icon.className = 'result-icon pass';
            icon.innerHTML = '&#10003;';
            title.className = 'result-title pass';
            title.textContent = this.t('result_pass_title');
            this.el.resultSubtitle.textContent = this.t('result_pass_subtitle');

            this.el.resultScore.textContent = `${r.score || 0}%`;
            this.el.resultScore.className = 'stat-value success';
            this.el.resultMistakes.textContent = `${r.mistakes || 0}`;
            this.el.resultMistakes.className = 'stat-value info';
            this.el.resultTime.textContent = this.formatTime(r.time || 0);

            if (r.isTheory) {
                this.el.resultMessage.textContent = this.t('result_pass_theory_msg');
                this.el.btnResultPractical.style.display = '';
                this.el.btnResultPractical.classList.remove('disabled');
            } else {
                this.el.resultMessage.textContent = this.t('result_pass_practical_msg', r.categoryLabel || '');
                this.el.btnResultPractical.style.display = 'none';
            }

            this.showScreen('result');
        },

        showFailScreen(r) {
            const s = this.el.failScreen;
            s.classList.add('result-screen', 'fail');
            s.classList.remove('pass');

            this.el.failScore.textContent = `${r.score || 0}%`;
            this.el.failMistakes.textContent = `${r.mistakes || 0} / ${r.maxMistakes || r.total || '—'}`;
            this.el.failTime.textContent = this.formatTime(r.time || 0);
            if (r.failReason) {
                this.el.failReason.textContent = r.failReason;
            } else if (r.mistakes != null && r.maxMistakes != null && r.mistakes > r.maxMistakes) {
                this.el.failReason.textContent = this.t('result_fail_mistakes_msg');
            } else {
                this.el.failReason.textContent = this.t('result_fail_subtitle');
            }

            this.state.lastResult = {
                examType: r.examType,
                category: this.state.selectedCategory,
                data: r
            };

            this.showScreen('fail');
        },

        retryExam() {
            const last = this.state.lastResult;
            if (!last) { this.renderMenu(); return; }
            this.post('retryExam', {
                examType: last.examType,
                category: last.category
            });
            if (last.examType === 'theory') {
                this.startTheory(last.category);
            } else {
                this.closeApp();
                this.post('startPractical', { category: last.category });
            }
        },

        onPracticalStarted(data) {
            if (!data.ok) {
                this.notifyError(data.error);
                return;
            }
            this.state.selectedCategory = data.category;
            this.showHud(true);
            this.el.hudCategory.textContent = data.categoryLabel || '';
            this.el.hudMaxSpeedValue.textContent = String(data.maxSpeed || '—');
            this.el.hudCheckpointsValue.textContent = `0 / ${data.totalCheckpoints || 0}`;
            this.el.hudCheckpointsProgress.style.width = '0%';
            this.el.hudTimeValue.textContent = '00:00';
            this.el.hudSpeedValue.textContent = '0';
            this.el.hudMistakesValue.textContent = `0 / ${data.maxMistakes || 0}`;
            this.clearHudNotification();
        },

        onUpdateHud(data) {
            if (!this.el.hud.classList.contains('active')) this.showHud(true);
            const cur = data.currentCheckpoint || 0;
            const tot = data.totalCheckpoints || 1;
            this.el.hudCheckpointsValue.textContent = `${cur} / ${tot}`;
            this.el.hudCheckpointsProgress.style.width = `${Math.min(100, (cur / tot) * 100)}%`;
            this.el.hudTimeValue.textContent = this.formatTime(data.elapsed || 0);
            const speed = Math.round(Number(data.speed) || 0);
            const maxSpeed = Number(data.maxSpeed || 0);
            this.el.hudSpeedValue.textContent = String(speed);
            this.el.hudSpeedValue.className = 'hud-value' + (speed > maxSpeed ? ' danger' : '');
            const mistakes = data.mistakes || 0;
            const maxMistakes = data.maxMistakes || 5;
            this.el.hudMistakesValue.textContent = `${mistakes} / ${maxMistakes}`;
            this.el.hudMistakesValue.parentElement.querySelector('.hud-value').className =
                'hud-value' + (mistakes >= maxMistakes ? ' danger' : (mistakes > maxMistakes / 2 ? ' warning' : ''));

            if (data.notification) {
                this.showHudNotification(data.notification.text, data.notification.kind || 'warning');
            }
        },

        showHudNotification(text, kind) {
            const n = this.el.hudNotification;
            n.textContent = text;
            n.className = `hud-notification ${kind || 'warning'}`;
            n.style.display = 'block';
            clearTimeout(this._hudNotifTimer);
            this._hudNotifTimer = setTimeout(() => {
                n.style.display = 'none';
            }, 2200);
        },

        clearHudNotification() {
            this.el.hudNotification.style.display = 'none';
            clearTimeout(this._hudNotifTimer);
        },

        onPracticalResult(data) {
            this.showHud(false);
            if (!data.ok) {
                this.notifyError(data.error);
                this.showScreen('menu');
                this.renderMenu();
                return;
            }
            const r = data;
            if (data.passed) {
                this.showResultScreen({
                    isTheory: false,
                    passed: true,
                    score: r.mistakes && r.totalCheckpoints ? Math.max(0, Math.floor(((r.totalCheckpoints - r.mistakes) / r.totalCheckpoints) * 100)) : (r.mistakes == null ? 100 : 100 - r.mistakes * 10),
                    mistakes: r.mistakes,
                    total: r.totalCheckpoints,
                    time: r.timeTaken,
                    categoryLabel: r.categoryLabel,
                    canContinue: false
                });
                if (this.state.practicalPassed) this.state.practicalPassed[this.state.selectedCategory] = true;
                if (this.state.licences && r.licenceGranted) this.state.licences[this.state.selectedCategory] = true;
            } else {
                this.showFailScreen({
                    score: r.mistakes && r.totalCheckpoints ? Math.max(0, Math.floor(((r.totalCheckpoints - r.mistakes) / r.totalCheckpoints) * 100)) : 0,
                    mistakes: r.mistakes,
                    total: r.totalCheckpoints,
                    time: r.timeTaken,
                    maxMistakes: r.maxMistakes,
                    categoryLabel: r.categoryLabel,
                    examType: 'practical'
                });
            }
        },

        closeMenu() {
            this.post('closeMenu');
            this.closeApp();
        },

        closeApp() {
            this.showScreen(null);
            this.showHud(false);
            this.post('closeApp');
        },

        notifyError(msg) {
            this.post('notify', { kind: 'error', message: msg || 'Error' });
        },

        handleMessage(event) {
            const msg = event.data || {};
            switch (msg.action) {
                case 'openMenu':
                    this.onOpenMenu(msg.data || {});
                    break;
                case 'startTheory':
                    this.onStartTheory(msg.data || {});
                    break;
                case 'theoryResult':
                    this.onTheoryResult(msg.data || {});
                    break;
                case 'startPractical':
                    this.onPracticalStarted(msg.data || {});
                    break;
                case 'updateHud':
                    this.onUpdateHud(msg.data || {});
                    break;
                case 'practicalResult':
                    this.onPracticalResult(msg.data || {});
                    break;
                case 'hideLicence':
                    this.hideLicence();
                    break;
                case 'processPhoto':
                    this.processPhoto(msg);
                    break;
                case 'licencePhoto':
                    this.setLicencePhoto(msg.photo);
                    break;
                case 'showLicence':
                    this.showLicence({ metadata: msg.metadata, ownerLabel: msg.ownerLabel, photo: msg.photo });
                    break;
                case 'close':
                    this.closeApp();
                    break;
            }
        }
    };

    window.addEventListener('message', (e) => App.handleMessage(e));

    window.addEventListener('load', () => {
        App.init();
    });

    window.__CITYDRIVING_NUI__ = App;
})();
