/* ===================== WALLET / BANKING - cartão, saldo, transferências, histórico =====================
   2026-09-20: só cartões a sério. Havia um passe "LS Transit" com "12 viagens" inventadas, cartões "adicionados" sem saldo
   nenhum, um número de cartão feito com o telefone, validade 12/28 e um CVV - tudo adereço. Agora há o cartão do banco
   (com o IBAN a sério quando o apex_banking está ligado - server/billing.lua bank.info) e o dinheiro em mão; o histórico
   junta os movimentos do banco (extrato do apex_banking) aos do telemóvel; conta congelada e poupança aparecem quando existem. */
App.define('wallet', {
  name: 'Carteira', core: true, category: 'Finanças',
  /* botão Voltar do sistema (Nova UI): com o ecrã de "Enviado" à frente, o Voltar fecha-o (como o Concluído); true = consumido */
  back(win) { const o = win && win.querySelector(':scope > .awal-ok'); if (!o) return false; const b = o.querySelector('.awal-go'); if (b) b.click(); return true; },
  actions: [{ label: 'Transferir', icon: 'send', onTap: () => { System.openApp('wallet'); setTimeout(() => Bridge.emit('wallet:transfer'), 300); } }],
  open(win) {
    const g = UI.g; let info = { bank: 0, cash: 0, transactions: [] }, tabs;
    const load = async () => { info = (await Bridge.rpc('bank.info')) || info; return info; };
    const P = () => System.player; const holder = () => `${P().firstname} ${P().lastname}`.trim().toUpperCase();
    const BANK = 'Fleeca';
    /* dois cartões, os únicos com saldo a sério (bank.info): o do banco e o dinheiro. A ordem gravada ('cards') só diz qual
       vem à frente; cartões antigos de outros tipos (passe, "adicionados") saem da lista */
    const DEF = [{ n: BANK, t: 'DÉBITO', c: ['#F0407A', '#7B3FE4', '#3B6CFF'], k: 'bank' }, { n: 'Dinheiro', t: 'DINHEIRO', c: ['#5E5E63', '#2C2C2E', '#151517'], k: 'cash' }];
    const cardsList = () => { const l = (Store.get('cards', null) || []).filter(c => c && (c.k === 'bank' || c.k === 'cash')); const out = []; l.forEach(c => { const d = DEF.find(x => x.k === c.k); if (d && !out.includes(d)) out.push(d); }); DEF.forEach(d => { if (!out.includes(d)) out.push(d); }); return out; };
    const bal = c => c.k === 'bank' ? UI.money(info.bank) : UI.money(info.cash);
    const iban = () => (info.iban ? String(info.iban).replace(/(.{4})/g, '$1 ').trim() : '');
    const ICON = [['burger', 'bag2', '#FF9F0A'], ['fleeca', 'bank', '#30D158'], ['salário', 'briefcase', '#0A84FF'], ['salario', 'briefcase', '#0A84FF'], ['marketplace', 'cart', '#1E8CFF'], ['venda', 'tag', '#30D158'], ['fatura', 'receipt', '#FF453A'], ['multa', 'shield', '#FF453A'], ['transferência', 'send', '#5E5CE6'], ['taxa', 'receipt', '#8E8E93'], ['depósito', 'bank', '#30D158'], ['levantamento', 'bank', '#FF9F0A'], ['poupança', 'bank', '#64D2FF'], ['empréstimo', 'bank', '#BF5AF2'],
      /* as mesmas categorias em ingles (linhas dos outros recursos e do showcase) */
      ['paycheck', 'briefcase', '#0A84FF'], ['salary', 'briefcase', '#0A84FF'], ['bill', 'receipt', '#FF453A'], ['invoice', 'receipt', '#FF453A'], ['fine', 'shield', '#FF453A'], ['transfer', 'send', '#5E5CE6'], ['deposit', 'bank', '#30D158'], ['withdraw', 'bank', '#FF9F0A'], ['atm', 'bank', '#FF9F0A'], ['fee', 'receipt', '#8E8E93'], ['savings', 'bank', '#64D2FF'], ['loan', 'bank', '#BF5AF2'], ['refund', 'bank', '#30D158'], ['eats', 'bag2', '#FF9F0A'], ['fuel', 'car', '#FF9F0A'], ['sale', 'tag', '#30D158']];
    /* As linhas gravadas pelo servidor (server/billing.lua) vem em portugues: o prefixo traduz-se AO MOSTRAR, assim cada jogador
       le na lingua dele e a BD fica igual em todos os servidores. O resto (nomes, numeros, nota) fica como esta. */
    const TX_PREFIX = ['Transferência falhada para', 'Transferência para', 'Transferência de', 'Fatura paga por', 'Fatura:'];
    const txText = s => { s = String(s || ''); if (!window.L || !L.t) return s; for (const p of TX_PREFIX) { if (s.startsWith(p)) { const key = p.replace(/:$/, ''); let rest = s.slice(p.length); rest = rest.replace(' · valor retido', ' · ' + L.t('valor retido')); return L.t(key) + (p.endsWith(':') ? ':' : '') + rest; } } return s; };
    const txIcon = t => { const d = (t.description || '').toLowerCase(); const m = ICON.find(x => d.includes(x[0])); return m ? `<div class="wl-ti" style="background:${m[2]}">${g(m[1], 18)}</div>` : t.bank ? `<div class="wl-ti" style="background:#30D158">${g('bank', 18)}</div>` : `<div class="wl-ti" style="${UI.avatarStyle(d.length)}">${UI.esc((t.description || '?')[0].toUpperCase())}</div>`; };
    const txRow = t => UI.el(`<div class="wl-tx">${txIcon(t)}<div class="wl-tb"><b data-noi18n>${UI.esc(txText(t.description))}</b><span>${UI.rel(t.created)} · ${UI.fmtTime(new Date(t.created))}${t.bank ? ' · ' + BANK : ''}</span></div><div class="wl-ta ${t.amount > 0 ? 'in' : 'out'}">${t.amount > 0 ? '+' : '−'}${UI.money(Math.abs(t.amount))}</div></div>`);
    /* frente: banco + IBAN (ou "sem número": não se inventa um); verso: titular e estado da conta */
    const cardHtml = (c, cls = '') => `<div class="wl-card ${cls}" style="--c1:${c.c[0]};--c2:${c.c[1]};--c3:${c.c[2] || c.c[1]}"><div class="wl-face front"><div class="wl-row"><span class="wl-type">${c.t}</span><span class="wl-bank">${UI.esc(c.n)}</span></div><div class="wl-chip"></div><div class="wl-num">${c.k === 'bank' ? (info.iban ? `<b>${UI.esc(iban())}</b>` : '<span class="wl-noiban">Conta do banco</span>') : '<span class="wl-noiban">Dinheiro em mão</span>'}</div><div class="wl-row bottom"><span class="wl-holder">${UI.esc(holder())}</span><span class="wl-exp">${c.k === 'bank' && info.frozen ? 'CONGELADA' : ''}</span></div><div class="wl-shine"></div></div><div class="wl-face back"><div class="wl-strip"></div><div class="wl-cvv"><span>${c.k === 'bank' ? 'IBAN' : 'SALDO'}</span><b style="font-size:13px">${c.k === 'bank' ? (info.iban ? UI.esc(iban()) : '--') : UI.money(info.cash)}</b></div><div class="wl-row bottom"><span class="wl-holder">${UI.esc(c.n)}</span><span class="wl-exp"></span></div></div></div>`;
    const tilt = card => { card.addEventListener('pointermove', e => { const r = UI.vrect ? UI.vrect(card) : card.getBoundingClientRect(); const x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5; card.style.transform = `perspective(900px) rotateY(${x * 10}deg) rotateX(${-y * 8}deg)`; card.querySelector('.wl-shine').style.background = `radial-gradient(circle at ${(x + .5) * 100}% ${(y + .5) * 100}%, rgba(255,255,255,.28), transparent 45%)`; }); card.addEventListener('pointerleave', () => { card.style.transform = ''; }); };

    async function home() {
      await load();
      /* wl-home: o dobrável aberto põe os cartões à esquerda e o saldo e as transações à direita (app-wallet.css) */
      const v = UI.view({ title: 'Carteira', large: true, cls: 'wl-home' });
      /* pilha de cartões com profundidade: o principal à frente; tocar no de trás traz-o para a frente, tocar no da frente abre os cartões */
      const cs = cardsList(); const stack = UI.el(`<div class="wl-stack" style="--n:${cs.length}"></div>`);
      cs.forEach((c, i) => { const card = UI.el(cardHtml(c, 'hero')); card.style.setProperty('--i', String(cs.length - 1 - i)); if (i === 0) tilt(card);
        card.onclick = () => { if (i === 0) { cards(); return; } const l = cardsList(); const [x] = l.splice(i, 1); l.unshift(x); Store.set('cards', l.map(y => ({ k: y.k }))); Sound.play('click'); home(); }; stack.appendChild(card); });
      v.content.appendChild(stack);
      if (info.frozen) v.content.appendChild(UI.el(`<div class="wl-warn">${g('lock', 18)} Conta congelada pelo banco: não podes transferir nem pagar até ser desbloqueada ao balcão.</div>`));
      const balc = UI.el(`<div class="wl-balance"><div><div class="wl-lbl">Saldo</div><div class="wl-bal">${UI.money(info.bank)}</div><div class="wl-sub">Dinheiro em mão ${UI.money(info.cash)}${info.savings > 0 ? ' · Poupança ' + UI.money(info.savings) : ''}</div></div><div class="wl-send">Enviar</div></div>`); balc.querySelector('.wl-send').onclick = () => sendFlow(); v.content.appendChild(balc);
      const acts = UI.el(`<div class="wl-actions"><div class="a tr">${g('send')}<span>Enviar</span></div><div class="a rq">${g('arrowDown')}<span>Pedir</span></div><div class="a bl">${g('receipt')}<span>Faturas</span></div><div class="a cd">${g('card')}<span>Cartões</span></div></div>`);
      acts.querySelector('.tr').onclick = () => sendFlow(); acts.querySelector('.rq').onclick = request; acts.querySelector('.bl').onclick = () => System.openApp('billing'); acts.querySelector('.cd').onclick = cards; v.content.appendChild(acts);
      if (info.noAccount) v.content.appendChild(UI.el('<div class="group-footer">Ainda não tens conta no banco: abre uma ao balcão para teres IBAN e extrato. As transferências pelo telemóvel funcionam na mesma.</div>'));
      const hd = UI.el(`<div class="wl-head"><b>Últimas transações</b><span>Todas as transações ${g('chevR', 19)}</span></div>`); hd.querySelector('span').onclick = allTx; v.content.appendChild(hd);
      const list = UI.el('<div class="wl-list"></div>'); const tx = info.transactions.slice(0, 6); if (!tx.length) list.appendChild(UI.empty('card', 'Sem transações', 'As tuas transações aparecem aqui.')); tx.forEach(t => list.appendChild(txRow(t))); v.content.appendChild(list);
      UI.setRoot(win, v);
    }
    function allTx() { const v = UI.view({ title: 'Transações', back: 'Carteira', large: true }); const groups = {}; info.transactions.forEach(t => { const k = new Date(t.created).toDateString(); (groups[k] = groups[k] || []).push(t); }); const keys = Object.keys(groups); if (!keys.length) v.content.appendChild(UI.empty('card', 'Sem transações', 'O teu histórico bancário aparece aqui.')); keys.forEach(k => { const d = new Date(groups[k][0].created); v.content.appendChild(UI.el(`<div class="group-header">${UI.fmtDate(d)}</div>`)); const l = UI.el('<div class="wl-list"></div>'); groups[k].forEach(t => l.appendChild(txRow(t))); v.content.appendChild(l); }); if (info.provider) v.content.appendChild(UI.el(`<div class="group-footer">Os movimentos com "· ${BANK}" vêm do extrato do banco; os outros são do telemóvel (faturas, marketplace, transferências antigas).</div>`)); UI.push(win, v); }
    function cards() { const v = UI.view({ title: 'Cartões', back: 'Carteira', large: true }); const car = UI.el('<div class="wl-carousel"></div>'); const dots = UI.el('<div class="wl-dots"></div>'); const cs = cardsList();
      const rowsOf = c => [{ label: 'Saldo', value: bal(c) }, { label: 'Tipo', value: c.t }, c.k === 'bank' ? { label: 'Estado', value: info.frozen ? 'Congelada' : 'Ativa' } : null, c.k === 'bank' && info.iban ? { label: 'IBAN', value: iban() } : null, c.k === 'bank' && info.savings > 0 ? { label: 'Poupança', value: UI.money(info.savings) } : null, { label: 'Toca no cartão', value: 'ver o verso' }].filter(Boolean);
      cs.forEach((c, i) => { const e = UI.el(cardHtml(c, 'slide')); e.onclick = () => { e.classList.toggle('flip'); Sound.play('click'); }; UI.longPress(e, () => UI.ctxMenu(e, [{ label: 'Definir como principal', icon: 'star', onTap: () => { const l = cardsList(); const [x] = l.splice(i, 1); l.unshift(x); Store.set('cards', l.map(y => ({ k: y.k }))); UI.pop(win); cards(); } }])); car.appendChild(e); dots.appendChild(UI.el(`<span class="${i === 0 ? 'on' : ''}"></span>`)); });
      const det = UI.el('<div></div>'); const paintDet = c => { det.innerHTML = ''; det.appendChild(UI.list([{ items: rowsOf(c) }])); if (c.k === 'bank' && info.iban) { const b = UI.el('<div class="btn-p btn-s">Enviar IBAN por mensagem</div>'); b.onclick = shareIban; det.appendChild(b); } };
      car.addEventListener('scroll', () => { const first = car.firstElementChild; const pitch = first ? first.offsetWidth + 32 : 404; const i = Math.round(car.scrollLeft / pitch);   /* passo real do carrossel (largura + margens), não a largura do cartão */ [...dots.children].forEach((d, k) => d.classList.toggle('on', k === i)); if (cs[i] && det._i !== i) { det._i = i; paintDet(cs[i]); } });
      det._i = 0; paintDet(cs[0]);
      v.content.append(car, dots, det); UI.push(win, v); }
    async function shareIban() { const c = await Contacts.pick('Enviar IBAN a'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: `🏦 O meu IBAN: ${iban()}` }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('IBAN enviado'); }
    async function request() { if (window.CC && CC.requireNet && !CC.requireNet('pedir dinheiro')) return; const c = await Contacts.pick('Pedir dinheiro a'); if (!c) return; const amt = parseFloat((await UI.prompt('Montante', '', '50', '', 'number') || '').replace(',', '.')); if (!amt) return;
      /* rpcRaw e verificação: o messages.send recusa (bloqueado, número que não existe, sem identidade) e
         a app dizia 'Pedido enviado' na mesma - um aviso de uma mensagem que nunca saiu */
      const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: `💰 Pedido de ${UI.money(amt)}. Podes transferir pela Carteira.` });
      if (!r || r.error) { Sound.play('error'); UI.alert({ title: 'Pedido não enviado', msg: r && r.error === 'blocked' ? 'Esse contacto bloqueou-te.' : r && r.error === 'target' ? 'Número não encontrado.' : 'Tenta novamente.' }); return; }
      UI.toast('Pedido enviado'); }

    /* 1.3.0: o destinatário pode ser um NÚMERO, o ID do servidor ou o citizenid ("for banking we can use id and phone number").
       Antes de confirmar, o servidor (bank.resolve) diz quem é e o que casou; a transferência manda o TEXTO escrito e o
       servidor resolve outra vez (nunca se confia num cid escolhido do lado do cliente). `to` = { text, number?, name, kind?, cid? }:
       de um contacto vem com número; do teclado só com o texto. A SMS "Transferi-te" só sai quando o destino tem número. */
    const RES_ERR = { target: 'Não há ninguém com esse número, ID ou cidadão.', self: 'Não podes transferir para ti.', invalid: 'Escreve um número de telefone, um ID ou um cidadão.', ratelimit: 'Tenta novamente.' };
    const typed = q => (q ? { text: q, name: (Contacts.byNumber(q) || {}).name } : null);
    /* texto da linha "o que casou": o padrão (Número %s / ID %s / Cidadão %s) traduz-se pelo i18n do DOM */
    const matchLabel = r => (r.kind === 'id' ? 'ID ' + r.text : r.kind === 'cid' ? 'Cidadão ' + (r.cid || r.text) : 'Número ' + UI.phone(r.number || r.text));
    async function resolveTo(to, btn) {
      const q = String(to.text || to.number || '').trim();
      if (btn.classList.contains('busy')) return null;
      btn.classList.add('busy'); btn.style.opacity = '.55'; btn.style.pointerEvents = 'none'; btn.textContent = 'A verificar…';
      let r = null; try { r = await Bridge.rpcRaw('bank.resolve', { to: q }); } catch (e) { r = null; }
      btn.classList.remove('busy'); btn.style.opacity = ''; btn.style.pointerEvents = ''; btn.textContent = 'Continuar';
      if (!r || !r.ok) { Sound.play('error'); UI.alert({ title: 'Destinatário não encontrado', msg: RES_ERR[r && r.error] || 'Tenta novamente.' }); return null; }
      return { text: q, number: r.number || null, name: r.name || to.name || q, kind: r.kind || 'number', cid: r.cid || null };
    }

    async function sendFlow(preset) {
      if (info.frozen) { UI.alert({ title: 'Conta congelada', msg: 'O banco congelou a tua conta: não podes transferir até ser desbloqueada ao balcão.' }); return; }
      let to = preset || null, amount = 0;
      const v = UI.view({ title: 'Enviar', back: 'Carteira' });
      const who = UI.el(`<div class="wl-who"><div class="wl-whoin">${g('personCircle', 24)}<input type="text" placeholder="Nome, número ou ID" value="${to ? UI.esc(to.name || to.number) : ''}"><div class="pick">${g('personPlus')}</div></div></div>`);
      const inp = who.querySelector('input'); who.querySelector('.pick').onclick = async () => { const c = await Contacts.pick('Enviar para'); if (c) { to = { text: c.number, number: c.number, name: c.name }; inp.value = c.name || c.number; } }; inp.oninput = () => { to = typed(inp.value.trim()); };
      const amt = UI.el(`<div class="wl-amt"><div class="wl-amtv"><span class="cur">${UI.esc(UI.cur())}</span><span class="val">0</span></div><div class="wl-sub">Saldo disponível ${UI.money(info.bank)}</div><div class="wl-chips"><span>50</span><span>100</span><span>500</span><span>1 000</span></div><div class="wl-pad"></div></div>`);
      const paint = () => { amt.querySelector('.val').textContent = amount ? UI.fmtNum(amount) : '0'; amt.querySelector('.wl-amtv').classList.toggle('over', amount > info.bank); };
      amt.querySelectorAll('.wl-chips span').forEach(s => s.onclick = () => { amount = +s.textContent.replace(/\s/g, ''); paint(); Sound.play('click'); });
      const pad = amt.querySelector('.wl-pad'); ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'].forEach(k => { const b = UI.el(`<div class="k ${k === '' ? 'blank' : ''}">${k}</div>`); b.onclick = () => { if (k === '') return; Sound.play('keypad'); if (k === '⌫') amount = Math.floor(amount / 10); else if (amount < 1e7) amount = amount * 10 + +k; paint(); }; pad.appendChild(b); });
      const note = UI.el('<div class="group" style="margin:8px 16px"><div class="li static"><input type="text" class="note" placeholder="Nota (opcional)" maxlength="40"></div></div>');
      const go = UI.el('<div class="btn-p" style="margin-top:10px">Continuar</div>');
      go.onclick = async () => { if (window.CC && CC.requireNet && !CC.requireNet('transferir dinheiro')) return; if (!to || !(to.text || to.number)) { UI.toast('Escolhe um destinatário'); return; } if (!(amount > 0)) { UI.toast('Introduz um montante'); return; } if (amount > info.bank) { UI.alert({ title: 'Saldo insuficiente' }); Sound.play('error'); return; } const noteV = note.querySelector('.note').value.trim();
        const r = await resolveTo(to, go); if (!r) return;
        const body = UI.el(`<div class="wl-confirm"><div class="wl-cavatar">${UI.avatar({ name: r.name }, 'lg')}</div><div class="wl-cname" data-noi18n>${UI.esc(r.name)}</div><div class="wl-cnum">${UI.esc(matchLabel(r))}</div><div class="wl-camt">${UI.money(amount)}</div>${noteV ? `<div class="wl-cnote">“${UI.esc(noteV)}”</div>` : ''}</div>`); body.appendChild(UI.list([{ items: [{ label: 'Total', value: UI.money(amount) }, { label: 'Conta', value: info.iban ? BANK + ' ' + iban().slice(-9) : BANK }], footer: info.provider ? 'Quando as duas contas existem no banco, a transferência vai pelo banco e pode ter a taxa dele.' : null }]));
        UI.sheet({ title: 'Confirmar transferência', left: 'Cancelar', right: 'Enviar', body, onDone: () => { transfer(r, amount, noteV, () => success(amount, r)); } }); };
      v.content.append(who, amt, note, go); UI.push(win, v); paint(); if (!to) setTimeout(() => inp.focus(), 400);
    }
    /* a transferência em si (o MESMO caminho nos dois sistemas): bank.transfer e, se correu bem, a mensagem ao destinatário */
    async function transfer(to, amount, noteV, ok) {
      /* `to` = o texto escrito (número, ID ou cidadão): o servidor resolve-o outra vez; de um contacto é o número */
      const r = await Bridge.rpcRaw('bank.transfer', { to: to.text || to.number, amount, note: noteV }); /* rpcRaw: o código (funds/target/self) perdia-se no Bridge.rpc */
      if (!r || !r.ok) { UI.alert({ title: 'Transferência falhou', msg: r && r.error === 'funds' ? 'Saldo insuficiente.' : r && r.error === 'target' ? 'Destinatário não encontrado.' : r && r.error === 'self' ? 'Não podes transferir para ti.' : r && r.error === 'frozen' ? 'A tua conta está congelada.' : r && r.error === 'amount' ? 'O banco não aceita este valor (mínimo/máximo).' : r && r.error === 'invalid' ? 'Escreve um número de telefone, um ID ou um cidadão.' : 'Tenta novamente.' }); Sound.play('error'); return; }
      ok();
      /* a SMS só quando o destino tem número (um ID/cidadão sem telemóvel não tem para onde a receber) */
      const num = (r.to && r.to.number) || to.number || null;
      if (num) Bridge.rpc('messages.send', { to: num, type: 'text', content: `💸 Transferi-te ${UI.money(amount)}${noteV ? ' · ' + noteV : ''}` }).catch(() => {});
    }
    function success(amount, to) { const o = UI.el(`<div class="wl-success"><div class="wl-check"><svg viewBox="0 0 64 64"><circle cx="32" cy="32" r="28" fill="none" stroke="#fff" stroke-width="4" class="c"/><path d="M20 33l8 8 16-18" fill="none" stroke="#fff" stroke-width="5" stroke-linecap="round" stroke-linejoin="round" class="p"/></svg></div><div class="wl-stitle">Enviado</div><div class="wl-ssub">${UI.money(amount)} para ${UI.esc(to.name || to.number)}</div><div class="btn-p" style="background:#fff;color:var(--green);width:220px">Concluído</div></div>`); o.querySelector('.btn-p').onclick = () => { o.remove(); home(); }; win.appendChild(o); Sound.play('success'); requestAnimationFrame(() => o.classList.add('in')); setTimeout(() => { if (o.isConnected) { o.remove(); home(); } }, 4000); }

    /* ===================== NOVA UI (Android) =====================
       Os mesmos dados (bank.info), a mesma ordem dos cartões ('cards'), as mesmas transferências (transfer) e pedidos; só o desenho
       muda: cartões empilhados com o da frente inteiro, cartão do saldo com ações redondas, movimentos em lista Nova UI. */
    const A = !!(System.isAndroid && System.isAndroid());
    const txIconA = t => { const d = (t.description || '').toLowerCase(); const m = ICON.find(x => d.includes(x[0]));
      return m ? `<div class="awal-ti" style="background:${m[2]}">${g(m[1], 18)}</div>` : t.bank ? `<div class="awal-ti" style="background:#30D158">${g('bank', 18)}</div>` : `<div class="awal-ti" style="${UI.avatarStyle(d.length)}">${UI.esc((t.description || '?')[0].toUpperCase())}</div>`; };
    const txRowA = t => { const r = UI.el(`<div class="awal-tx">${txIconA(t)}<div class="awal-tb"><b></b><span></span></div><div class="awal-ta ${t.amount > 0 ? 'in' : 'out'}"></div></div>`);
      r.querySelector('b').textContent = txText(t.description);
      r.querySelector('span').textContent = `${UI.rel(t.created)} · ${UI.fmtTime(new Date(t.created))}${t.bank ? ' · ' + BANK : ''}`;
      r.querySelector('.awal-ta').textContent = (t.amount > 0 ? '+' : '−') + UI.money(Math.abs(t.amount)); return r; };
    const cardA = (c, cls = '') => { const e = UI.el(`<div class="awal-card ${cls}" style="background:linear-gradient(135deg,${c.c[0]} 0%,${c.c[1]} 60%,${c.c[2] || c.c[1]} 100%)"><div class="awal-cr"><b class="awal-cb"></b><span class="awal-ct"></span></div><div class="awal-cn"></div><div class="awal-cr bottom"><span class="awal-ch"></span><span class="awal-cs"></span></div></div>`);
      e.querySelector('.awal-cb').textContent = c.n; e.querySelector('.awal-ct').textContent = c.t;
      e.querySelector('.awal-cn').textContent = c.k === 'bank' ? (info.iban ? iban() : 'Conta do banco') : 'Dinheiro em mão';
      e.querySelector('.awal-ch').textContent = holder(); e.querySelector('.awal-cs').textContent = c.k === 'bank' && info.frozen ? 'CONGELADA' : bal(c); return e; };
    async function homeA() {
      await load();
      const v = UI.view({ title: App.name('wallet'), large: true, cls: 'awal-v awal-home' });   /* awal-home: duas colunas no dobrável aberto (oneui-apps3.css) */
      /* pilha: os de trás espreitam por cima e o da frente fica inteiro; tocar num de trás tra-lo para a frente, tocar no da frente abre os cartões */
      const cs = cardsList(); const stack = UI.el(`<div class="awal-stack" style="--n:${cs.length}"></div>`);
      cs.slice().reverse().forEach((c, k) => { const i = cs.length - 1 - k; const e = cardA(c, i === 0 ? 'front' : 'back'); e.style.setProperty('--k', String(k));
        e.onclick = () => { if (i === 0) { cardsA(); return; } const l = cardsList(); const [x] = l.splice(i, 1); l.unshift(x); Store.set('cards', l.map(y => ({ k: y.k }))); Sound.play('click'); homeA(); }; stack.appendChild(e); });
      v.content.appendChild(stack);
      if (info.frozen) v.content.appendChild(UI.el(`<div class="awal-warn">${g('lock', 18)}<span>Conta congelada pelo banco: não podes transferir nem pagar até ser desbloqueada ao balcão.</span></div>`));
      const bc = UI.el(`<div class="awal-bal"><em>Saldo disponível</em><b></b><span></span><div class="awal-acts"><div class="awal-a tr"><i>${g('send', 22)}</i><span>Enviar</span></div><div class="awal-a rq"><i>${g('arrowDown', 22)}</i><span>Pedir</span></div><div class="awal-a bl"><i>${g('receipt', 22)}</i><span>Faturas</span></div><div class="awal-a cd"><i>${g('card', 22)}</i><span>Cartões</span></div></div></div>`);
      bc.querySelector('b').textContent = UI.money(info.bank);
      bc.querySelector('span').textContent = 'Dinheiro em mão ' + UI.money(info.cash) + (info.savings > 0 ? ' · Poupança ' + UI.money(info.savings) : '');
      bc.querySelector('.tr').onclick = () => sendFlowA(); bc.querySelector('.rq').onclick = request; bc.querySelector('.bl').onclick = () => System.openApp('billing'); bc.querySelector('.cd').onclick = cardsA;
      v.content.appendChild(bc);
      if (info.noAccount) v.content.appendChild(UI.el('<div class="awal-note">Ainda não tens conta no banco: abre uma ao balcão para teres IBAN e extrato. As transferências pelo telemóvel funcionam na mesma.</div>'));
      const hd = UI.el(`<div class="awal-head"><b>Transações recentes</b><span>Ver tudo</span></div>`); hd.querySelector('span').onclick = allTxA; v.content.appendChild(hd);
      const tx = info.transactions.slice(0, 6);
      if (!tx.length) v.content.appendChild(UI.el('<div class="awal-empty">Sem transações. As tuas transações aparecem aqui.</div>'));
      else { const l = UI.el('<div class="awal-list"></div>'); tx.forEach(t => l.appendChild(txRowA(t))); v.content.appendChild(l); }
      UI.setRoot(win, v);
    }
    function allTxA() {
      const v = UI.view({ title: 'Transações', back: App.name('wallet'), large: true, cls: 'awal-v' }); const groups = {};
      info.transactions.forEach(t => { const k = new Date(t.created).toDateString(); (groups[k] = groups[k] || []).push(t); });
      const keys = Object.keys(groups);
      if (!keys.length) v.content.appendChild(UI.el('<div class="awal-empty">Sem transações. O teu histórico bancário aparece aqui.</div>'));
      keys.forEach(k => { const d = new Date(groups[k][0].created); v.content.appendChild(UI.el(`<div class="awal-day">${UI.esc(UI.fmtDate(d))}</div>`)); const l = UI.el('<div class="awal-list"></div>'); groups[k].forEach(t => l.appendChild(txRowA(t))); v.content.appendChild(l); });
      if (info.provider) v.content.appendChild(UI.el(`<div class="awal-note">Os movimentos com "· ${BANK}" vêm do extrato do banco; os outros são do telemóvel (faturas, marketplace, transferências antigas).</div>`));
      UI.push(win, v);
    }
    function cardsA() {
      const v = UI.view({ title: 'Cartões', back: App.name('wallet'), large: true, cls: 'awal-v' }); const cs = cardsList();
      const car = UI.el('<div class="awal-car"></div>'), dots = UI.el('<div class="awal-dots"></div>');
      cs.forEach((c, i) => { const e = cardA(c, 'slide'); UI.longPress(e, () => UI.ctxMenu(e, [{ label: 'Definir como principal', icon: 'star', onTap: () => { const l = cardsList(); const [x] = l.splice(i, 1); l.unshift(x); Store.set('cards', l.map(y => ({ k: y.k }))); UI.pop(win); homeA(); } }])); car.appendChild(e); dots.appendChild(UI.el(`<span class="${i === 0 ? 'on' : ''}"></span>`)); });
      const det = UI.el('<div></div>');
      const paintDet = c => { det.innerHTML = '';
        const rows = [['Saldo', bal(c)], ['Tipo', c.t], c.k === 'bank' ? ['Estado', info.frozen ? 'Congelada' : 'Ativa'] : null, c.k === 'bank' && info.iban ? ['IBAN', iban()] : null, c.k === 'bank' && info.savings > 0 ? ['Poupança', UI.money(info.savings)] : null].filter(Boolean);
        const card = UI.el('<div class="awal-list awal-info"></div>'); rows.forEach(([a, b]) => { const r = UI.el('<div class="awal-ir"><span></span><b></b></div>'); r.querySelector('span').textContent = a; r.querySelector('b').textContent = b; card.appendChild(r); }); det.appendChild(card);
        if (c.k === 'bank' && info.iban) { const b = UI.el(`<div class="awal-btn">${g('message', 18)}<span>Enviar IBAN por mensagem</span></div>`); b.onclick = shareIban; det.appendChild(b); }
        det.appendChild(UI.el('<div class="awal-note">Mantém o dedo num cartão para o pôr à frente na Carteira.</div>')); };
      car.addEventListener('scroll', () => { const first = car.firstElementChild; const pitch = first ? first.offsetWidth + 14 : 360; const i = Math.round(car.scrollLeft / pitch); [...dots.children].forEach((d, k) => d.classList.toggle('on', k === i)); if (cs[i] && det._i !== i) { det._i = i; paintDet(cs[i]); } }, { passive: true });
      det._i = 0; paintDet(cs[0]);
      v.content.append(car, dots, det); UI.push(win, v);
    }
    async function sendFlowA(preset) {
      if (info.frozen) { UI.alert({ title: 'Conta congelada', msg: 'O banco congelou a tua conta: não podes transferir até ser desbloqueada ao balcão.' }); return; }
      let to = preset || null, amount = 0;
      const v = UI.view({ title: 'Enviar dinheiro', back: App.name('wallet'), cls: 'awal-v' });
      const who = UI.el(`<div class="awal-who">${g('personCircle', 22)}<input type="text" placeholder="Nome, número ou ID"><div class="awal-pick">${g('personPlus', 20)}</div></div>`);
      const inp = who.querySelector('input'); if (to) inp.value = to.name || to.number;
      who.querySelector('.awal-pick').onclick = async () => { const c = await Contacts.pick('Enviar para'); if (c) { to = { text: c.number, number: c.number, name: c.name }; inp.value = c.name || c.number; } };
      inp.oninput = () => { to = typed(inp.value.trim()); };
      /* símbolo do lado que o Config.Currency diz ($ antes, € depois) */
      const curBefore = UI.currency().position !== 'after', curSpan = `<span class="cur">${UI.esc(UI.cur())}</span>`;
      const amt = UI.el(`<div class="awal-amt"><div class="awal-amtv">${curBefore ? curSpan : ''}<span class="val">0</span>${curBefore ? '' : curSpan}</div><div class="awal-avail"></div><div class="awal-chips"><span>50</span><span>100</span><span>500</span><span>1 000</span></div><div class="awal-pad"></div></div>`);
      amt.querySelector('.awal-avail').textContent = 'Saldo disponível ' + UI.money(info.bank);
      const paint = () => { amt.querySelector('.val').textContent = amount ? UI.fmtNum(amount) : '0'; amt.querySelector('.awal-amtv').classList.toggle('over', amount > info.bank); };
      amt.querySelectorAll('.awal-chips span').forEach(s => s.onclick = () => { amount = +s.textContent.replace(/\s/g, ''); paint(); Sound.play('click'); });
      const pad = amt.querySelector('.awal-pad');
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'].forEach(k => { const b = UI.el(`<div class="awal-k ${k === '' ? 'blank' : ''}">${k === 'del' ? g('backspace', 24) : k}</div>`); b.onclick = () => { if (k === '') return; Sound.play('keypad'); if (k === 'del') amount = Math.floor(amount / 10); else if (amount < 1e7) amount = amount * 10 + +k; paint(); }; pad.appendChild(b); });
      const note = UI.el('<div class="awal-noteIn"><input type="text" placeholder="Nota (opcional)" maxlength="40"></div>');
      const go = UI.el('<div class="awal-go">Continuar</div>');
      go.onclick = async () => {
        if (window.CC && CC.requireNet && !CC.requireNet('transferir dinheiro')) return;
        if (!to || !(to.text || to.number)) { UI.toast('Escolhe um destinatário'); return; }
        if (!(amount > 0)) { UI.toast('Introduz um montante'); return; }
        if (amount > info.bank) { UI.alert({ title: 'Saldo insuficiente' }); Sound.play('error'); return; }
        const noteV = note.querySelector('input').value.trim();
        const r = await resolveTo(to, go); if (!r) return;
        const body = UI.el(`<div class="awal-conf"><div class="awal-cav">${UI.avatar({ name: r.name }, 'lg')}</div><b data-noi18n></b><span></span><div class="awal-camt"></div><em></em></div>`);
        body.querySelector('b').textContent = r.name; body.querySelector('span').textContent = matchLabel(r); body.querySelector('.awal-camt').textContent = UI.money(amount);
        if (noteV) body.querySelector('em').textContent = '"' + noteV + '"'; else body.querySelector('em').remove();
        body.appendChild(UI.list([{ items: [{ label: 'Total', value: UI.money(amount) }, { label: 'Conta', value: info.iban ? BANK + ' ' + iban().slice(-9) : BANK }], footer: info.provider ? 'Quando as duas contas existem no banco, a transferência vai pelo banco e pode ter a taxa dele.' : null }]));
        UI.sheet({ title: 'Confirmar transferência', left: 'Cancelar', right: 'Enviar', body, onDone: () => { transfer(r, amount, noteV, () => successA(amount, r)); } });
      };
      v.content.append(who, amt, note, go); UI.push(win, v); paint(); if (!to) setTimeout(() => inp.focus(), 400);
    }
    function successA(amount, to) {
      const o = UI.el(`<div class="awal-ok"><div class="awal-okc">${g('check', 46)}</div><b>Enviado</b><span></span><div class="awal-go">Concluído</div></div>`);
      o.querySelector('span').textContent = UI.money(amount) + ' para ' + (to.name || to.number);
      const done = () => { if (!o.isConnected) return; o.remove(); homeA(); };
      o.querySelector('.awal-go').onclick = done; win.appendChild(o); Sound.play('success'); requestAnimationFrame(() => o.classList.add('in')); setTimeout(done, 4000);
    }

    const H = () => (A ? homeA() : home()), SEND = () => (A ? sendFlowA() : sendFlow());
    H();
    /* os três listeners TÊM de morrer com a janela: o sistema mata a app menos usada acima de 7 e, sem isto, cada ciclo abrir/fechar
       deixava mais um handler vivo a reconstruir (com RPC) uma árvore que já nem está no DOM */
    const offs = [Bridge.on('wallet:transfer', () => SEND()), Bridge.on('bank', () => { if (UI.depth(win) === 1) H(); }), Bridge.on('player:update', () => { if (System.currentApp() === 'wallet' && UI.depth(win) === 1) H(); })];
    win.onClose = () => offs.forEach(o => o());
  }
});
Bridge.on('bank', d => { if (d && d.title) Notify.push({ app: 'wallet', title: d.title, msg: d.msg || '', onTap: () => System.openApp('wallet') }); });
/* browser (sem FiveM): o bank.resolve do mock - um contacto com esse número, um "ID" de 1-5 dígitos, o resto não existe */
if (window.LocalDB && LocalDB.register) LocalDB.register('bank.resolve', d => {
  const q = String(d && d.to || '').trim(); if (!q) return { ok: false, error: 'invalid' };
  let cs = []; try { cs = LocalDB.rpc('contacts.list', {}) || []; } catch (e) { cs = []; }
  const c = Array.isArray(cs) ? cs.find(x => x && x.number === q) : null;
  if (c) return { ok: true, kind: 'number', number: c.number, name: c.name || q };
  if (/^\d{1,5}$/.test(q)) return { ok: true, kind: 'id', name: 'Jogador ' + q, number: null };
  return { ok: false, error: 'target' };
});
