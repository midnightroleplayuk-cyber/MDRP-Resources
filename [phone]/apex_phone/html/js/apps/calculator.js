/* ===================== CALCULADORA ===================== */
App.define('calculator', {
  name: 'Calculadora', statusBar: 'dark',
  /* Voltar do Android (SysUI): com o histórico aberto, fecha-o em vez de fechar a app */
  back(win) { try { return !!(win && win._novaBack && win._novaBack()); } catch (e) { return false; } },
  open(win) {
    /* Android: calculadora de expressão da Nova UI (CalcNova, no fim deste ficheiro) */
    if (window.System && System.os === 'android' && window.CalcNova) return CalcNova.open(win);
    const v = UI.el('<div class="calc"><div class="calc-display">0</div><div class="calc-sci"></div><div class="calc-keys"></div></div>');
    const disp = v.querySelector('.calc-display'), keys = v.querySelector('.calc-keys'), sci = v.querySelector('.calc-sci');
    let cur = '0', acc = null, op = null, fresh = true;
    const KEYS = [['AC', 'fn'], ['±', 'fn'], ['%', 'fn'], ['÷', 'op'], ['7'], ['8'], ['9'], ['×', 'op'], ['4'], ['5'], ['6'], ['−', 'op'], ['1'], ['2'], ['3'], ['+', 'op'], ['0', 'zero'], [','], ['=', 'op']];
    KEYS.forEach(([k, cls]) => { const b = UI.el(`<div class="ck ${cls || ''}" data-k="${k}">${k}</div>`); keys.appendChild(b); });
    /* PearPhone Fold aberto: teclas científicas na metade esquerda, como a calculadora de um telemóvel deitado. Constroem-se
       sempre (uma vez) e o CSS só as mostra com body.form-fold; nos telemóveis normais ficam escondidas e nada muda. */
    const SCI = [['mc'], ['m+'], ['m−'], ['mr', 'mr'], ['e'], ['x²'], ['x³'], ['xʸ', 'bin'], ['eˣ'], ['10ˣ'], ['1/x'], ['√x'], ['∛x'], ['ʸ√x', 'bin'], ['ln'], ['x!'], ['sin'], ['cos'], ['tan'], ['log₁₀'], ['Rad', 'rad'], ['sinh'], ['cosh'], ['tanh'], ['π']];
    SCI.forEach(([k, cls]) => { const b = UI.el(`<div class="ck sk ${cls || ''}" data-k="${k}"></div>`); b.textContent = k; sci.appendChild(b); });
    const radTag = UI.el('<span class="calc-rad">Rad</span>'); disp.before(radTag);
    let mem = 0, rad = false;
    const fmt = s => {
      if (s === 'Erro') return s;
      let [i, d] = s.split('.');
      const neg = i.startsWith('-'); if (neg) i = i.slice(1);
      if (i.length > 9) return Number(s).toExponential(3).replace('.', ',');
      i = i.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
      return (neg ? '-' : '') + i + (d !== undefined ? ',' + d : '');
    };
    /* terceiro degrau: com 12 dígitos significativos mais expoente o texto era cortado À ESQUERDA e mostrava um número diferente do real */
    const paint = () => { disp.textContent = fmt(cur); disp.classList.toggle('small', disp.textContent.length > 9); disp.classList.toggle('tiny', disp.textContent.length > 12); v.querySelectorAll('.op, .bin').forEach(b => b.classList.toggle('on', op === b.dataset.k && fresh && b.dataset.k !== '=')); keys.querySelector('[data-k="AC"]').textContent = cur === '0' && acc === null ? 'AC' : 'C';
      sci.querySelector('.mr').classList.toggle('on', mem !== 0); sci.querySelector('.rad').textContent = rad ? 'Deg' : 'Rad'; radTag.classList.toggle('on', rad); };
    const calc = (a, b, o) => { a = +a; b = +b; const r = o === '+' ? a + b : o === '−' ? a - b : o === '×' ? a * b : o === 'xʸ' ? Math.pow(a, b) : o === 'ʸ√x' ? (b === 0 ? NaN : (a < 0 && Math.abs(b % 2) === 1 ? -Math.pow(-a, 1 / b) : Math.pow(a, 1 / b))) : b === 0 ? NaN : a / b; return isFinite(r) ? String(+r.toPrecision(12)) : 'Erro'; };
    /* funções de um só número (teclas científicas): o resultado substitui o número à vista, como no PearOS */
    const fact = n => { if (n < 0 || n > 170 || Math.floor(n) !== n) return NaN; let r = 1; for (let i = 2; i <= n; i++) r *= i; return r; };
    const ang = x => rad ? x : x * Math.PI / 180;
    const UN = { 'x²': x => x * x, 'x³': x => x * x * x, 'eˣ': x => Math.exp(x), '10ˣ': x => Math.pow(10, x), '1/x': x => x === 0 ? NaN : 1 / x, '√x': x => x < 0 ? NaN : Math.sqrt(x), '∛x': x => Math.cbrt(x),
      'ln': x => x <= 0 ? NaN : Math.log(x), 'log₁₀': x => x <= 0 ? NaN : Math.log10(x), 'x!': fact, 'sin': x => Math.sin(ang(x)), 'cos': x => Math.cos(ang(x)), 'tan': x => { const a = ang(x); return Math.abs(Math.cos(a)) < 1e-12 ? NaN : Math.tan(a); },
      'sinh': x => Math.sinh(x), 'cosh': x => Math.cosh(x), 'tanh': x => Math.tanh(x) };
    const num = r => { if (!isFinite(r)) return 'Erro'; if (Math.abs(r) < 1e-12) r = 0; return String(+r.toPrecision(12)); };
    sci.onclick = e => {
      const b = e.target.closest('.ck'); if (!b) return; const k = b.dataset.k; const x = cur === 'Erro' ? 0 : +cur;
      if (UN[k]) { cur = num(UN[k](x)); fresh = true; }
      else if (k === 'π' || k === 'e') { cur = num(k === 'π' ? Math.PI : Math.E); fresh = true; }
      else if (k === 'mc') mem = 0; else if (k === 'm+') { mem += x; fresh = true; } else if (k === 'm−') { mem -= x; fresh = true; } else if (k === 'mr') { cur = num(mem); fresh = true; }
      else if (k === 'Rad') rad = !rad;
      else if (b.classList.contains('bin')) { if (op && acc !== null && !fresh) cur = calc(acc, cur, op); acc = cur; op = k; fresh = true; }
      paint();
    };
    keys.onclick = e => {
      const b = e.target.closest('.ck'); if (!b) return; const k = b.dataset.k;
      if (/\d/.test(k)) { if (fresh || cur === '0') cur = k; else if (cur.replace(/[-.]/g, '').length < 9) cur += k; fresh = false; }
      else if (k === ',') { if (fresh) cur = '0'; if (!cur.includes('.')) cur += '.'; fresh = false; }
      else if (k === 'AC') { if (cur !== '0' && !fresh) { cur = '0'; } else { cur = '0'; acc = null; op = null; } fresh = true; }
      else if (k === '±') { cur = cur.startsWith('-') ? cur.slice(1) : (cur === '0' ? cur : '-' + cur); }
      else if (k === '%') { cur = String(+cur / 100); }
      else if (k === '=') { if (op && acc !== null) { cur = calc(acc, cur, op); acc = null; op = null; } fresh = true; }
      else { if (op && acc !== null && !fresh) cur = calc(acc, cur, op); acc = cur; op = k; fresh = true; }
      paint();
    };
    win.querySelector('.nav-stack').appendChild(v); paint();
  }
});

/* ===================== CALCULADORA NO ANDROID (Nova UI 8.5) =====================
   Calculadora de EXPRESSÃO, como a da Nova UI: a conta inteira fica escrita em cima e o resultado
   aparece por baixo, a cinzento, enquanto se escreve; "=" passa o resultado para cima e guarda a
   conta no histórico. Parênteses inteligentes, percentagem (50+10% = 55, 50×10% = 5), mudar o sinal,
   apagar o último carácter, e o teclado físico também conta (com a calculadora à frente e sem
   nenhum campo de texto focado). As contas passam por um analisador próprio, nunca por eval.
   O histórico fica no Store da personagem ('calcHistory', as últimas 50 contas).
   No PearOS a calculadora é preta (statusBar 'dark'); aqui segue o tema: a barra de estado acompanha.
   ============================================================================== */
window.CalcNova = (() => {
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const OPS = '+−×÷', MAXLEN = 100, MAXDIG = 15, HKEY = 'calcHistory';
  const isOp = c => OPS.includes(c);
  const isDig = c => c >= '0' && c <= '9';
  /* a barra de estado segue o tema no Android (a calculadora deixa de ser sempre preta) */
  Bridge.on('os:changed', d => { const def = App.get('calculator'); if (def) def.statusBar = d && d.to === 'android' ? 'auto' : 'dark'; });

  /* ---------- analisador ---------- */
  function tokens(ex) {
    const out = []; let i = 0;
    while (i < ex.length) {
      const c = ex[i];
      if (isDig(c) || c === ',') {
        let j = i; while (j < ex.length && (isDig(ex[j]) || ex[j] === ',')) j++;
        /* um resultado muito grande volta à conta em notação científica ("1,5E+20") */
        if (ex[j] === 'E') { let k = j + 1; if (ex[k] === '+' || ex[k] === '−') k++; if (isDig(ex[k] || '')) { while (isDig(ex[k] || '')) k++; j = k; } }
        const s = ex.slice(i, j).replace(',', '.').replace('−', '-'); if ((s.match(/\./g) || []).length > 1 || s === '.') return null;
        out.push({ t: 'n', v: parseFloat(s) }); i = j; continue;
      }
      if (isOp(c) || c === '(' || c === ')' || c === '%') { out.push({ t: c }); i++; continue; }
      return null;
    }
    return out;
  }
  /* devolve { ok, v } ou { err: 'fmt' | 'div0' } */
  function evaluate(ex) {
    const tk = tokens(ex); if (!tk || !tk.length) return { err: 'fmt' };
    /* multiplicação implícita: 2(3) · (2)(3) · (2)3 · 5%(2) */
    const t2 = [];
    tk.forEach((x, i) => { const p = t2[t2.length - 1]; if (p && (p.t === 'n' || p.t === ')' || p.t === '%') && (x.t === '(' || (x.t === 'n' && (p.t === ')' || p.t === '%')))) t2.push({ t: '×' }); t2.push(x); });
    /* parênteses por fechar fecham-se sozinhos */
    let open = 0; t2.forEach(x => { if (x.t === '(') open++; else if (x.t === ')') open--; if (open < 0) open = -99; });
    if (open < 0) return { err: 'fmt' };
    while (open-- > 0) t2.push({ t: ')' });
    /* shunting-yard; − unário vira 'u' */
    const prec = { '+': 1, '−': 1, '×': 2, '÷': 2, u: 3 }, out = [], st = [];
    let prev = null;
    for (const x of t2) {
      if (x.t === 'n') out.push(x);
      else if (x.t === '%') { if (!prev || (prev.t !== 'n' && prev.t !== ')')) return { err: 'fmt' }; out.push({ t: '%' }); }
      else if (x.t === '(') st.push(x);
      else if (x.t === ')') { while (st.length && st[st.length - 1].t !== '(') out.push(st.pop()); if (!st.length) return { err: 'fmt' }; st.pop(); }
      else {
        let op = x.t;
        if (op === '−' && (!prev || prev.t === '(' || isOp(prev.t) || prev.t === 'u')) op = 'u';
        else if (!prev || prev.t === '(' || isOp(prev.t) || prev.t === 'u') return { err: 'fmt' };
        while (st.length) { const top = st[st.length - 1].t; if (top === '(' || prec[top] < prec[op] || (op === 'u' && top === 'u')) break; out.push(st.pop()); }
        st.push({ t: op }); x.t2 = op;
      }
      prev = x.t2 ? { t: x.t2 } : x;
    }
    if (prev && (isOp(prev.t) || prev.t === 'u' || prev.t === '(')) return { err: 'fmt' };
    while (st.length) { const s = st.pop(); if (s.t === '(') return { err: 'fmt' }; out.push(s); }
    /* avaliação: cada valor sabe se veio de uma percentagem (50+10% = 50 + 50×10%) */
    const vs = [];
    for (const x of out) {
      if (x.t === 'n') { vs.push({ v: x.v, p: false }); continue; }
      if (x.t === '%') { const a = vs.pop(); if (!a) return { err: 'fmt' }; vs.push({ v: a.v / 100, p: true }); continue; }
      if (x.t === 'u') { const a = vs.pop(); if (!a) return { err: 'fmt' }; vs.push({ v: -a.v, p: a.p }); continue; }
      const b = vs.pop(), a = vs.pop(); if (!a || !b) return { err: 'fmt' };
      let r;
      if (x.t === '+' || x.t === '−') { const bv = b.p ? a.v * b.v : b.v; r = x.t === '+' ? a.v + bv : a.v - bv; }
      else if (x.t === '×') r = a.v * b.v;
      else { if (b.v === 0) return { err: 'div0' }; r = a.v / b.v; }
      vs.push({ v: r, p: false });
    }
    if (vs.length !== 1 || !isFinite(vs[0].v)) return { err: vs.length === 1 ? 'big' : 'fmt' };
    return { ok: true, v: +vs[0].v.toPrecision(15) };
  }
  /* número → texto da calculadora ("1 234,5", "−3", "1,2E+20") */
  function fmtNum(v) {
    if (Object.is(v, -0)) v = 0;
    const neg = v < 0, a = Math.abs(v);
    let s;
    /* expoente negativo com o sinal da calculadora (U+2212): o analisador só aceita + ou esse sinal depois do E, e "1,5E-10" dava "Formato inválido" ao continuar a conta */
    if (a !== 0 && (a >= 1e15 || a < 1e-9)) s = a.toExponential(12).replace(/\.?0+e/, 'e').replace('e', 'E').replace('.', ',').replace('E-', 'E−');
    else { s = String(+a.toPrecision(15)); if (/e/i.test(s)) s = a.toFixed(12).replace(/\.?0+$/, ''); s = s.replace('.', ','); }
    return (neg ? '−' : '') + s;
  }
  /* a expressão com espaços nos milhares e os operadores marcados (só apresentação) */
  function pretty(ex) {
    return UI.esc(ex).replace(/\d+(,\d*)?/g, m => { const [i, d] = m.split(','); return i.replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + (d !== undefined ? ',' + d : ''); })
      .replace(/([+−×÷%()])/g, '<i>$1</i>');
  }

  function open(win) {
    win.classList.add('acalc-win');
    const v = UI.el(`<div class="acalc"><div class="acalc-sb"></div>
      <div class="acalc-disp"><div class="acalc-ex"></div><div class="acalc-pv"></div></div>
      <div class="acalc-tools"><div class="acalc-tl" data-a="hist" role="button" aria-label="${UI.esc(T('Histórico'))}">${UI.g('clock')}</div><div class="acalc-gap"></div><div class="acalc-tl" data-a="back" role="button" aria-label="${UI.esc(T('Apagar'))}">${UI.g('backspace')}</div></div>
      <div class="acalc-pad"><div class="acalc-keys"></div><div class="acalc-hist hidden"><div class="acalc-hh">${UI.esc(T('Histórico'))}</div><div class="acalc-hl"></div><div class="acalc-hc" role="button">${UI.esc(T('Limpar histórico'))}</div></div></div></div>`);
    const exEl = v.querySelector('.acalc-ex'), pvEl = v.querySelector('.acalc-pv'), keys = v.querySelector('.acalc-keys'), hist = v.querySelector('.acalc-hist'), hl = v.querySelector('.acalc-hl'), hBtn = v.querySelector('[data-a="hist"]');
    const KEYS = [['C', 'red'], ['( )', 'op', 'paren'], ['%', 'op'], ['÷', 'op'], ['7'], ['8'], ['9'], ['×', 'op'], ['4'], ['5'], ['6'], ['−', 'op'], ['1'], ['2'], ['3'], ['+', 'op'], ['+/−', '', 'sign'], ['0'], [','], ['=', 'eq']];
    KEYS.forEach(([k, cls, id]) => { const b = document.createElement('div'); b.className = 'acalc-k ' + (cls || ''); b.dataset.k = id || k; b.textContent = k; b.setAttribute('role', 'button'); keys.appendChild(b); });
    let ex = '', done = false, err = '';

    const lastNumStart = () => { let i = ex.length; while (i > 0 && (isDig(ex[i - 1]) || ex[i - 1] === ',')) i--; return i; };
    const curNum = () => ex.slice(lastNumStart());
    const last = () => ex[ex.length - 1] || '';
    const paint = () => {
      exEl.innerHTML = pretty(ex) || '<span class="acalc-ph">0</span>';
      const n = ex.length; exEl.className = 'acalc-ex ' + (n <= 9 ? 's1' : n <= 13 ? 's2' : n <= 19 ? 's3' : 's4');
      exEl.scrollTop = exEl.scrollHeight;
      let pv = '';
      if (err) pv = err;
      else if (ex && !done && /[+−×÷%]/.test(ex.replace(/^−/, ''))) { const r = evaluate(ex); if (r.ok) pv = fmtNum(r.v).replace(/\d+/, m => m.replace(/\B(?=(\d{3})+(?!\d))/g, ' ')); }
      pvEl.textContent = pv; pvEl.classList.toggle('err', !!err);
    };
    const toast = s => UI.toast(s, 2200);
    const add = s => { if (ex.length + s.length > MAXLEN) { toast(TF('Não é possível introduzir mais de %s caracteres.', MAXLEN)); return false; } ex += s; return true; };

    const press = k => {
      err = '';
      if (isDig(k)) {
        if (done) { ex = ''; done = false; }
        const n = curNum();
        if (n.replace(',', '').length >= MAXDIG) { toast(TF('Não é possível introduzir mais de %s dígitos.', MAXDIG)); return; }
        if (last() === ')' || last() === '%') add('×');
        if (n === '0') ex = ex.slice(0, -1);
        add(k);
      } else if (k === ',') {
        if (done) { ex = ''; done = false; }
        const n = curNum();
        if (n.includes(',')) return;
        if (last() === ')' || last() === '%') add('×');
        add(n ? ',' : '0,');
      } else if (isOp(k)) {
        done = false;
        const l = last();
        if (!ex) { if (k === '−') add('−'); return; }
        if (l === '(') { if (k === '−') add('−'); return; }
        if (l === ',') ex = ex.slice(0, -1);
        if (isOp(last())) { if (ex.length === 1 || ex[ex.length - 2] === '(') { if (k !== '−') return; } ex = ex.slice(0, -1); }
        add(k);
      } else if (k === '%') {
        done = false;
        const l = last(); if (l === ',') ex = ex.slice(0, -1);
        if (isDig(last()) || last() === ')') add('%');
      } else if (k === 'paren') {
        done = false;
        const opens = (ex.match(/\(/g) || []).length - (ex.match(/\)/g) || []).length, l = last();
        if (l === ',') ex = ex.slice(0, -1);
        const after = isDig(last()) || last() === ')' || last() === '%';
        if (opens > 0 && after) add(')'); else add(after ? '×(' : '(');
      } else if (k === '(' || k === ')') {
        done = false;
        const opens = (ex.match(/\(/g) || []).length - (ex.match(/\)/g) || []).length, after = isDig(last()) || last() === ')' || last() === '%';
        if (k === ')') { if (opens > 0 && after) add(')'); } else add(after ? '×(' : '(');
      } else if (k === 'sign') {
        done = false;
        const i = lastNumStart();
        if (i >= 2 && ex.slice(i - 2, i) === '(−') ex = ex.slice(0, i - 2) + ex.slice(i);
        else if (i === 1 && ex[0] === '−') ex = ex.slice(1);                       /* resultado negativo: tira o sinal */
        else if (i === ex.length) { if (last() !== ')') add('(−'); }
        else if (ex.length + 2 <= MAXLEN) ex = ex.slice(0, i) + '(−' + ex.slice(i);
      } else if (k === 'C') { ex = ''; done = false; }
      else if (k === 'back') { if (done) done = false; ex = ex.slice(0, -1); }
      else if (k === '=') {
        if (!ex) return;
        const r = evaluate(ex);
        if (!r.ok) { err = r.err === 'div0' ? T('Não é possível dividir por zero.') : r.err === 'big' ? T('Valor demasiado grande.') : T('Formato inválido.'); paint(); return; }
        const res = fmtNum(r.v);
        if (!done && /[+−×÷%()]/.test(ex.replace(/^−/, ''))) pushHist(ex, res);
        ex = res; done = true;
      }
      paint();
    };

    /* ---------- histórico ---------- */
    const getHist = () => { const h = Store.get(HKEY, []); return Array.isArray(h) ? h : []; };
    /* NOVA Fold8 aberto: o histórico fica sempre à vista numa coluna à esquerda do teclado (oneui-apps3.css) */
    const histPane = () => !!(window.System && System.form === 'fold' && System.foldOpen);
    const pushHist = (e, r) => { const h = getHist().slice(-49); h.push({ e, r }); Store.set(HKEY, h); if (!hist.classList.contains('hidden') || histPane()) paintHist(); };
    const paintHist = () => {
      hl.textContent = ''; const h = getHist();
      if (!h.length) { hl.appendChild(UI.el(`<div class="acalc-he">${UI.esc(T('Sem histórico'))}</div>`)); }
      h.slice().reverse().forEach(x => { const it = UI.el(`<div class="acalc-hi" role="button"><div class="acalc-hx">${pretty(String(x.e || ''))}</div><div class="acalc-hr">=${UI.esc(String(x.r || ''))}</div></div>`); it.onclick = () => { Sound.play('click'); ex = String(x.r || '').replace(/ /g, ''); done = true; err = ''; showHist(false); paint(); }; hl.appendChild(it); });
      v.querySelector('.acalc-hc').classList.toggle('hidden', !h.length);
    };
    const showHist = on => { hist.classList.toggle('hidden', !on); hBtn.innerHTML = on ? UI.g('keypad') : UI.g('clock'); hBtn.classList.toggle('on', on); if (on) { paintHist(); hl.scrollTop = 0; } };
    v.querySelector('.acalc-hc').onclick = () => { Sound.play('click'); Store.set(HKEY, []); paintHist(); };
    hBtn.onclick = () => { Sound.play('click'); showHist(hist.classList.contains('hidden')); };
    win._novaBack = () => { if (hist.classList.contains('hidden') || histPane()) return false; showHist(false); return true; };   /* aberto o histórico é uma coluna fixa: Voltar sai da app */
    v.querySelector('[data-a="back"]').onclick = () => { Sound.play('click'); press('back'); };
    UI.longPress(v.querySelector('[data-a="back"]'), () => { ex = ''; done = false; err = ''; paint(); });
    keys.onclick = e => { const b = e.target.closest('.acalc-k'); if (!b) return; Sound.play('click'); press(b.dataset.k); };

    /* ---------- teclado físico ---------- */
    const KMAP = { '+': '+', '-': '−', '*': '×', x: '×', X: '×', '/': '÷', '%': '%', ',': ',', '.': ',', '(': '(', ')': ')', Enter: '=', '=': '=', Backspace: 'back', Delete: 'C' };
    const flash = k => { const b = keys.querySelector(`[data-k="${k === '(' || k === ')' ? 'paren' : k}"]`); if (!b) return; b.classList.add('kd'); setTimeout(() => b.classList.remove('kd'), 120); };
    const onKey = e => {
      if (!v.isConnected || System.currentApp() !== 'calculator' || win.classList.contains('bg') || document.body.classList.contains('hidden')) return;
      const t = e.target; if (t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable)) return;
      if (document.querySelector('#screen .overlay, #screen .sheet-wrap, #screen .as-wrap, #screen .ctx-wrap')) return;
      if (e.ctrlKey || e.altKey || e.metaKey) return;
      const k = isDig(e.key) ? e.key : KMAP[e.key]; if (!k) return;
      e.preventDefault(); flash(k); press(k);
    };
    document.addEventListener('keydown', onKey);
    /* abrir o dobrável com a app aberta: a coluna do histórico aparece já preenchida */
    const offFold = window.Bridge && Bridge.on ? Bridge.on('fold:state', () => { if (histPane() && v.isConnected) paintHist(); }) : null;
    win.onClose = () => { document.removeEventListener('keydown', onKey); try { offFold && offFold(); } catch (e) {} };

    win.querySelector('.nav-stack').appendChild(v); paint(); if (histPane()) paintHist();
  }
  return { open, evaluate, fmtNum };
})();
