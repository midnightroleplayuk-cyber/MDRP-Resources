(function () {
    const state = {
        deptId: null,
        deptLabel: 'Los Santos Police Department',
        deptPalette: null,
        playerName: '',
        page: 'home'
    };

    function esc(value) {
        return String(value ?? '').replace(/[&<>"']/g, (ch) => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        }[ch]));
    }

    function getResourceName() {
        return typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'plt_departments';
    }

    function updateClock() {
        const clock = document.getElementById('form-mac-clock');
        if (!clock) return;
        const now = new Date();
        const date = now.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        const time = now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
        clock.textContent = `${date}  ${time}`;
    }

    function updateScale() {
        const computer = document.querySelector('#department-form-computer .form-computer-mac');
        if (!computer) return;
        const scale = Math.min(window.innerWidth / 1820, window.innerHeight / 1050, 1);
        computer.style.setProperty('--ui-scale', String(Math.max(scale, 0.5)));
    }

    function normalizeHexColor(value, fallback) {
        const raw = String(value || '').trim();
        if (/^#[0-9a-f]{6}$/i.test(raw)) return raw;
        if (/^[0-9a-f]{6}$/i.test(raw)) return `#${raw}`;
        return fallback;
    }

    function hexToRgb(hex) {
        const clean = normalizeHexColor(hex, '#003366').slice(1);
        return {
            r: parseInt(clean.slice(0, 2), 16),
            g: parseInt(clean.slice(2, 4), 16),
            b: parseInt(clean.slice(4, 6), 16)
        };
    }

    function rgbToHex(r, g, b) {
        return `#${[r, g, b].map((part) => Math.max(0, Math.min(255, Math.round(part))).toString(16).padStart(2, '0')).join('')}`;
    }

    function shadeHexColor(hex, percent) {
        const rgb = hexToRgb(hex);
        const target = percent < 0 ? 0 : 255;
        const amount = Math.abs(percent) / 100;
        return rgbToHex(
            rgb.r + (target - rgb.r) * amount,
            rgb.g + (target - rgb.g) * amount,
            rgb.b + (target - rgb.b) * amount
        );
    }

    function readableTextColor(hex) {
        const { r, g, b } = hexToRgb(hex);
        const luminance = ((0.299 * r) + (0.587 * g) + (0.114 * b)) / 255;
        return luminance > 0.62 ? '#07111f' : '#ffffff';
    }

    function applyDepartmentPalette() {
        const container = document.getElementById('department-form-computer');
        if (!container) return;

        const primary = '#003366';
        const primaryMid = '#002b5c';
        const primaryDark = '#001f45';
        const primarySoft = '#e8f0fa';
        const accent = '#f2b705';
        const accentDark = '#b98700';
        const emergency = '#b5121b';
        const rgb = hexToRgb(primary);

        container.style.setProperty('--dept-primary', primary);
        container.style.setProperty('--dept-primary-mid', primaryMid);
        container.style.setProperty('--dept-primary-dark', primaryDark);
        container.style.setProperty('--dept-primary-soft', primarySoft);
        container.style.setProperty('--dept-primary-rgb', `${rgb.r}, ${rgb.g}, ${rgb.b}`);
        container.style.setProperty('--dept-accent', accent);
        container.style.setProperty('--dept-accent-dark', accentDark);
        container.style.setProperty('--dept-emergency', emergency);
        container.style.setProperty('--dept-on-primary', '#ffffff');
        container.style.setProperty('--dept-on-accent', '#07111f');
    }

    function slugifyDepartmentName(value) {
        return String(value || 'LSPD')
            .trim()
            .toLowerCase()
            .replace(/&/g, ' and ')
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/^-+|-+$/g, '') || 'lspd';
    }

    function pagePath(page) {
        const deptSlug = slugifyDepartmentName(state.deptLabel);
        const path = {
            home: 'home',
            services: 'services',
            records: 'records',
            community: 'community',
            form: 'services/online-report',
            gunLicense: 'permits/firearm-license'
        }[page] || 'home';
        return `intranet.${deptSlug}.local/${path}`;
    }

    function renderHeader(activePage) {
        const nav = [
            ['home', 'Home'],
            ['services', 'Services'],
            ['records', 'Records'],
            ['community', 'Community'],
            ['form', 'File a Form'],
            ['gunLicense', 'Gun License']
        ].map(([page, label]) => `
            <button class="${activePage === page ? 'active' : ''}" type="button" data-page="${page}">${label}</button>
        `).join('');

        return `
            <div class="lapd-site-top">
                <div class="lapd-official-strip">
                    <span>${esc(state.deptLabel)} Official Intranet</span>
                    <span>Emergency: 911 | Non-Emergency Services</span>
                </div>
                <div class="lapd-brand-row">
                    <div class="lapd-brand">
                        <div class="lapd-badge-mark"><i class="fas fa-shield-halved"></i></div>
                        <div>
                            <h1>${esc(state.deptLabel)}</h1>
                            <p>To Protect and to Serve | ${esc(state.deptLabel)} Public Service Portal</p>
                        </div>
                    </div>
                    <nav class="lapd-nav">${nav}</nav>
                </div>
            </div>
        `;
    }

    function renderHomePage() {
        return `
            <section class="lapd-hero lapd-hero-home">
                <h2>${esc(state.deptLabel)} Intranet</h2>
                <p>Access department services, public safety information, records guidance, community resources, and secure online police service forms from this station terminal.</p>
                <div class="lapd-hero-actions">
                    <button type="button" data-page="form">Submit a Service Form</button>
                    <button type="button" data-page="services">View Services</button>
                </div>
            </section>
            <main class="lapd-page">
                <div class="lapd-home-grid">
                    <section class="lapd-panel lapd-wide">
                        <h3>How Can We Help?</h3>
                        <div class="lapd-service-cards">
                            <button type="button" data-page="form"><i class="fas fa-file-signature"></i><strong>Online Forms</strong><span>Submit tips, complaints, follow-up information, and service requests.</span></button>
                            <button type="button" data-page="gunLicense"><i class="fas fa-id-card"></i><strong>Gun License Application</strong><span>Apply for command review of a civilian firearm license request.</span></button>
                            <button type="button" data-page="records"><i class="fas fa-folder-open"></i><strong>Records</strong><span>Learn how to request reports, case references, and documentation.</span></button>
                            <button type="button" data-page="community"><i class="fas fa-users"></i><strong>Community</strong><span>View outreach, neighborhood safety, and public assistance programs.</span></button>
                        </div>
                    </section>
                    <aside class="lapd-panel">
                        <h3>Public Safety Notices</h3>
                        <div class="lapd-alert-list">
                            <div class="lapd-alert"><strong>Emergency incidents</strong><span>Call 911 immediately. Do not use this terminal for active threats.</span></div>
                            <div class="lapd-alert"><strong>Station access</strong><span>This intranet terminal is monitored and intended for police services only.</span></div>
                            <div class="lapd-alert"><strong>Accurate reporting</strong><span>False reports may delay emergency response and may be investigated.</span></div>
                        </div>
                    </aside>
                </div>
                <section class="lapd-panel lapd-news-panel">
                    <h3>Department Updates</h3>
                    <div class="lapd-news-grid">
                        <article><span>COMMUNITY</span><strong>Neighborhood safety briefings available this week</strong><p>Residents can request information about patrol zones, crime prevention, and reporting procedures.</p></article>
                        <article><span>TRAFFIC</span><strong>Collision follow-up desk accepting online details</strong><p>Use the service form to add witness information, photos, or updated contact details.</p></article>
                        <article><span>RECORDS</span><strong>Case number required for report lookups</strong><p>Records staff can process requests faster when the date, location, and case reference are included.</p></article>
                    </div>
                </section>
            </main>
        `;
    }

    function renderServicesPage() {
        return `
            <section class="lapd-subhero">
                <h2>Police Services</h2>
                <p>Common department services available from the station intranet terminal.</p>
            </section>
            <main class="lapd-page">
                <div class="lapd-directory">
                    <article class="lapd-panel"><h3>Online Police Service Form</h3><p>Submit non-emergency service requests, incident follow-ups, community concerns, and tips.</p><button type="button" data-page="form">Open Form</button></article>
                    <article class="lapd-panel"><h3>Firearm License Application</h3><p>Submit a structured request for civilian firearm licensing review by authorized command staff.</p><button type="button" data-page="gunLicense">Apply Now</button></article>
                    <article class="lapd-panel"><h3>Incident Follow-Up</h3><p>Provide additional witness statements, vehicle descriptions, timelines, or supporting information.</p><button type="button" data-page="form">Add Details</button></article>
                    <article class="lapd-panel"><h3>Personnel Complaint</h3><p>Document a concern involving department conduct for supervisor review.</p><button type="button" data-page="form">Start Complaint</button></article>
                    <article class="lapd-panel"><h3>Community Concern</h3><p>Report recurring neighborhood issues, traffic hazards, or patrol visibility requests.</p><button type="button" data-page="community">Learn More</button></article>
                </div>
            </main>
        `;
    }

    function renderRecordsPage() {
        return `
            <section class="lapd-subhero">
                <h2>Records and Reports</h2>
                <p>Information for report requests, case references, and official documentation.</p>
            </section>
            <main class="lapd-page">
                <div class="lapd-two-column">
                    <section class="lapd-panel">
                        <h3>Before You Request Records</h3>
                        <div class="lapd-checklist">
                            <span><i class="fas fa-check"></i> Include the case number if known.</span>
                            <span><i class="fas fa-check"></i> Provide date, time, and incident location.</span>
                            <span><i class="fas fa-check"></i> Use legal names and accurate contact details.</span>
                            <span><i class="fas fa-check"></i> Do not submit emergency information here.</span>
                        </div>
                    </section>
                    <section class="lapd-panel">
                        <h3>Records Desk</h3>
                        <p class="lapd-copy">Records staff reviews public-service submissions and routes requests to the correct unit. Complex reports may require in-person verification or supervisor approval.</p>
                        <button class="lapd-inline-action" type="button" data-page="form">Request Records Assistance</button>
                    </section>
                </div>
            </main>
        `;
    }

    function renderCommunityPage() {
        return `
            <section class="lapd-subhero">
                <h2>Community Resources</h2>
                <p>Programs and guidance for residents, businesses, and visitors.</p>
            </section>
            <main class="lapd-page">
                <div class="lapd-community-grid">
                    <article><i class="fas fa-house-user"></i><strong>Neighborhood Support</strong><span>Report quality-of-life concerns, suspicious activity patterns, or recurring safety issues.</span></article>
                    <article><i class="fas fa-road"></i><strong>Traffic Safety</strong><span>Request review of dangerous intersections, speeding concerns, or parking problems.</span></article>
                    <article><i class="fas fa-school"></i><strong>Youth and Schools</strong><span>Ask about outreach, safety talks, and department-led community engagement.</span></article>
                    <article><i class="fas fa-store"></i><strong>Business Assistance</strong><span>Submit concerns involving theft trends, trespassing, or security planning.</span></article>
                </div>
            </main>
        `;
    }

    function renderFormPage() {
        return `
            <section class="lapd-subhero">
                <h2>Online Police Service Request</h2>
                <p>Use this secure department intranet terminal to submit non-emergency requests, tips, complaints, records assistance, or follow-up information.</p>
            </section>
            <main class="lapd-page">
                <div class="lapd-grid">
                    <aside class="lapd-panel">
                        <h3>Submission Notices</h3>
                        <div class="lapd-alert-list">
                            <div class="lapd-alert"><strong>Emergency incidents</strong><span>Call 911 immediately. Do not use this form for active threats.</span></div>
                            <div class="lapd-alert"><strong>Accurate reporting</strong><span>False reports may delay real police services and may be investigated.</span></div>
                            <div class="lapd-alert"><strong>Department review</strong><span>Submissions are visible to authorized command staff.</span></div>
                        </div>
                    </aside>
                    <section class="lapd-panel">
                        <h3>Submit a Department Form</h3>
                        <form id="lapd-service-form" class="lapd-form">
                            <input type="hidden" name="applicationType" value="police_service">
                            <div class="lapd-form-row">
                                <label>Full Name<input name="fullName" maxlength="96" value="${esc(state.playerName)}" required></label>
                                <label>Phone Number<input name="phone" maxlength="40" required></label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Email Address<input name="email" maxlength="120" type="email"></label>
                                <label>Form Type
                                    <select name="formType">
                                        <option>General Police Service Request</option>
                                        <option>Incident Follow-Up</option>
                                        <option>Community Concern</option>
                                        <option>Personnel Complaint</option>
                                        <option>Records Assistance</option>
                                        <option>Anonymous Tip</option>
                                    </select>
                                </label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Priority
                                    <select name="priority">
                                        <option>Routine</option>
                                        <option>Important</option>
                                        <option>Urgent</option>
                                    </select>
                                </label>
                                <label>Brief Summary<input name="summary" maxlength="160" required></label>
                            </div>
                            <label>Detailed Information<textarea name="details" maxlength="3000" required placeholder="Include dates, locations, people involved, vehicle descriptions, case numbers, and any other relevant details."></textarea></label>
                            <div class="lapd-submit-row">
                                <span id="lapd-form-status" class="lapd-form-status">Secure intranet connection ready.</span>
                                <button class="lapd-submit" type="submit">Submit Form</button>
                            </div>
                        </form>
                    </section>
                </div>
            </main>
        `;
    }

    function renderGunLicensePage() {
        return `
            <section class="lapd-subhero">
                <h2>Firearm License Application</h2>
                <p>Submit a civilian firearm license request for ${esc(state.deptLabel)} command review. Applications may require interview, records review, and firearms training verification.</p>
            </section>
            <main class="lapd-page">
                <div class="lapd-grid">
                    <aside class="lapd-panel">
                        <h3>Eligibility Notices</h3>
                        <div class="lapd-alert-list">
                            <div class="lapd-alert"><strong>Truthful disclosure</strong><span>False statements may result in refusal and further investigation.</span></div>
                            <div class="lapd-alert"><strong>Command review</strong><span>Submitting this form does not grant permission to carry or purchase a firearm.</span></div>
                            <div class="lapd-alert"><strong>Safety requirement</strong><span>Applicants should be prepared to provide training, storage, and background information.</span></div>
                        </div>
                    </aside>
                    <section class="lapd-panel">
                        <h3>Submit Gun License Application</h3>
                        <form id="lapd-gun-license-form" class="lapd-form">
                            <input type="hidden" name="applicationType" value="gun_license">
                            <input type="hidden" name="formType" value="Gun License Application">
                            <input type="hidden" name="priority" value="Important">
                            <input type="hidden" name="summary" value="Civilian firearm license application">
                            <div class="lapd-form-row">
                                <label>Full Legal Name<input name="fullName" maxlength="96" value="${esc(state.playerName)}" required></label>
                                <label>Date of Birth<input name="dateOfBirth" maxlength="40" placeholder="MM/DD/YYYY" required></label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Phone Number<input name="phone" maxlength="40" required></label>
                                <label>Email Address<input name="email" maxlength="120" type="email"></label>
                            </div>
                            <label>Residential Address<input name="address" maxlength="180" required></label>
                            <div class="lapd-form-row">
                                <label>Occupation<input name="occupation" maxlength="96" required></label>
                                <label>Requested License
                                    <select name="licenseClass">
                                        <option>Firearm Possession License</option>
                                        <option>Concealed Carry Permit</option>
                                        <option>Security Employment Firearm Permit</option>
                                        <option>Business Protection Firearm Permit</option>
                                    </select>
                                </label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Training Provider<input name="trainingProvider" maxlength="120" placeholder="Academy, instructor, or N/A" required></label>
                                <label>Training Completion Date<input name="trainingDate" maxlength="40" placeholder="MM/DD/YYYY or N/A" required></label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Prior License Denial
                                    <select name="priorDenial">
                                        <option>No</option>
                                        <option>Yes</option>
                                    </select>
                                </label>
                                <label>Criminal History
                                    <select name="criminalHistory">
                                        <option>No disqualifying history</option>
                                        <option>Pending case or prior conviction</option>
                                        <option>Prefer to discuss with licensing officer</option>
                                    </select>
                                </label>
                            </div>
                            <div class="lapd-form-row">
                                <label>Mental Health Restriction
                                    <select name="mentalHealth">
                                        <option>No</option>
                                        <option>Yes</option>
                                        <option>Prefer to discuss with licensing officer</option>
                                    </select>
                                </label>
                                <label>Domestic Violence Restriction
                                    <select name="domesticViolence">
                                        <option>No</option>
                                        <option>Yes</option>
                                        <option>Prefer to discuss with licensing officer</option>
                                    </select>
                                </label>
                            </div>
                            <label>Safe Storage Plan<textarea name="storagePlan" maxlength="1200" required placeholder="Describe how firearms and ammunition will be secured, stored, and protected from unauthorized access."></textarea></label>
                            <label>Reason for Application<textarea name="details" maxlength="3000" required placeholder="Explain why you are requesting a firearm license, relevant training, employment need, prior experience, and any supporting facts for review."></textarea></label>
                            <div class="lapd-submit-row">
                                <span id="lapd-form-status" class="lapd-form-status">Firearm licensing portal ready.</span>
                                <button class="lapd-submit" type="submit">Submit Application</button>
                            </div>
                        </form>
                    </section>
                </div>
            </main>
        `;
    }

    function renderWebsite(page = state.page || 'home') {
        const root = document.getElementById('lapd-form-root');
        if (!root) return;

        state.page = page;
        const body = {
            home: renderHomePage,
            services: renderServicesPage,
            records: renderRecordsPage,
            community: renderCommunityPage,
            form: renderFormPage,
            gunLicense: renderGunLicensePage
        }[page] || renderHomePage;

        root.innerHTML = renderHeader(page) + body();
        const url = document.getElementById('lapd-form-url');
        if (url) url.textContent = pagePath(page);

        const form = document.getElementById('lapd-service-form') || document.getElementById('lapd-gun-license-form');
        if (form) form.addEventListener('submit', submitForm);

        root.querySelectorAll('[data-page]').forEach((button) => {
            button.addEventListener('click', () => renderWebsite(button.dataset.page || 'home'));
        });
    }

    async function submitForm(event) {
        event.preventDefault();
        const form = event.currentTarget;
        const status = document.getElementById('lapd-form-status');
        const button = form.querySelector('button[type="submit"]');
        const data = Object.fromEntries(new FormData(form).entries());
        data.deptId = state.deptId;

        if (button) button.disabled = true;
        if (status) status.textContent = 'Submitting to department records...';

        try {
            const response = await fetch(`https://${getResourceName()}/submitDepartmentForm`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            const result = await response.json();
            if (result && result.ok) {
                form.reset();
                if (status) status.textContent = `Submitted successfully. Reference #${result.id}`;
            } else if (status) {
                status.textContent = (result && result.message) || 'Submission failed.';
            }
        } catch (error) {
            if (status) status.textContent = 'Unable to contact the form service.';
        } finally {
            if (button) button.disabled = false;
        }
    }

    function closeFormComputer() {
        const container = document.getElementById('department-form-computer');
        if (container) container.classList.add('hidden');
        fetch(`https://${getResourceName()}/closeDepartmentFormComputer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }

    window.addEventListener('message', (event) => {
        if (!event.data || event.data.action !== 'openDepartmentFormComputer') return;
        state.deptId = event.data.deptId;
        state.deptLabel = event.data.deptLabel || 'Los Santos Police Department';
        state.deptPalette = event.data.deptPalette || null;
        state.playerName = event.data.playerName || '';
        state.page = 'home';
        const container = document.getElementById('department-form-computer');
        if (container) container.classList.remove('hidden');
        applyDepartmentPalette(state.deptPalette);
        updateClock();
        updateScale();
        renderWebsite('home');
    });

    document.addEventListener('DOMContentLoaded', () => {
        const closeBtn = document.getElementById('lapd-form-close');
        if (closeBtn) closeBtn.addEventListener('click', closeFormComputer);
        applyDepartmentPalette(state.deptPalette);
        updateClock();
        updateScale();
        setInterval(updateClock, 30000);
    });

    window.addEventListener('resize', updateScale);

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            const container = document.getElementById('department-form-computer');
            if (container && !container.classList.contains('hidden')) closeFormComputer();
        }
    });
}());
