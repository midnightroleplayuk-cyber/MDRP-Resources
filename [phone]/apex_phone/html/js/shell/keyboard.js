/* ============================================================
   KEYBOARD - teclado virtual PearOS (letras, números, símbolos, emoji,
   shift/caps, backspace, enter, auto-maiúsculas)

   NOVA UI (Android, 2026-10-01): o MESMO motor (inserir, apagar, Enter,
   maiúsculas automáticas, campo ativo, deslocar a janela) com o teclado NOVA:
   barra de ferramentas em cima (emoji, área de transferência, definições,
   recolher), teclas arredondadas, fila de números opcional (sem ela a fila
   de cima mostra os números, que saem com um toque longo), acentos no toque
   longo (á à â ã...), duas páginas de símbolos, teclado numérico nos campos de
   números e telefone, barra de espaço com o idioma e a tecla de ação a azul.
   Fica acima da barra de navegação de 3 botões. As preferências do teclado
   (fila de números, pré-visualização, maiúsculas automáticas) vivem no Store
   da personagem ('akb'), como as outras preferências locais.
   ============================================================ */
window.Keyboard = (() => {
  const g = UI.g; let el, rows, emo, target = null, shift = true, caps = false, mode = 'abc', bsT = null, hideT = null, lastShift = 0, lastSpace = 0, noCap = false;
  let ptrDown = false, hideWait = false;   /* ponteiro em baixo / descida do teclado à espera do largar (init, focusout) */
  const RET = { search: 'Pesquisar', send: 'Enviar', go: 'Ir', done: 'OK', next: 'Seguinte' };   /* rótulo do Enter por enterkeyhint / contexto (PearOS) */
  const ABC = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'], NUM = ['1234567890', '-/:;()€&@"', '.,?!\''], SYM = ['[]{}#%^*+=', '_\\|~<>$£¥', '.,?!\''];
  const EMOJI = ['😀','😂','😍','😎','😭','😡','🥳','🤔','😴','😈','👻','💀','🤡','🤑','🫡','👍','👎','🙏','👋','💪','👀','🔥','❤️','💔','✨','🎉','🎂','🚗','🚓','🚑','🏠','💰','💳','📱','📞','💬','📷','🎵','🎮','🍔','🍕','☕','🍺','⚽','🏀','🎯','🔑','💎','🧨','💣','🌮','🍟','🥤','🎤','🎧','🕶️','👑','💊','🚬','🔧','⛽','🏦','🚨','📍','✅','❌','⚠️','💤','🙈','🤝'];
  const enabled = () => System.state.kb === null || System.state.kb === undefined ? Bridge.inFiveM : !!System.state.kb;
  const isA = () => !!(window.System && System.os === 'android');
  let built = null;   /* 'ios' | 'android': o DOM do teclado é de um sistema de cada vez (troca a quente no 'os:changed') */
  function init() {
    el = UI.el('<div id="kb"></div>'); UI.screen().appendChild(el);
    el.addEventListener('pointerdown', e => e.preventDefault()); /* mantém o foco no input */
    document.addEventListener('focusin', e => { const t = e.target; if (!t.matches('input,textarea') || t.closest('.no-kb') || ['checkbox', 'range', 'file'].includes(t.type)) return; clearTimeout(hideT); hideWait = false; if (!enabled()) return; show(t); });
    /* O TECLADO NÃO DESCE COM UM DEDO NO ECRÃ (4 nov 2026, "não consigo publicar nada no Tweeter"). Premir um botão que não é campo
       (o Enviar dos comentários, a linha "Marcar pessoas", o Foto do compositor) tira o foco ao campo; 120 ms depois o teclado descia
       e levava consigo a folha ou a janela que tinha subido - o botão fugia de baixo do rato ainda premido e o largar caía noutro
       sítio (o click ia para o antepassado comum: nada acontecia ou a folha fechava). Com o ponteiro em baixo a descida espera pelo
       largar (pointerup/pointercancel, em captura na window para nenhum stopPropagation a esconder) e corre 60 ms depois dele, já
       com o click entregue ao botão certo. */
    const ptrUp = () => { ptrDown = false; if (!hideWait) return; hideWait = false; clearTimeout(hideT);
      hideT = setTimeout(() => { if (!document.activeElement || !document.activeElement.matches('input,textarea')) hide(); }, 60); };
    window.addEventListener('pointerdown', () => { ptrDown = true; }, true);
    window.addEventListener('pointerup', ptrUp, true); window.addEventListener('pointercancel', ptrUp, true);
    window.addEventListener('blur', ptrUp);   /* a janela perdeu o foco (NUI fechada a meio do clique): o largar pode nunca chegar */
    document.addEventListener('focusout', () => { clearTimeout(hideT); hideT = setTimeout(() => { if (ptrDown) { hideWait = true; return; } if (!document.activeElement || !document.activeElement.matches('input,textarea')) hide(); }, 120); });
    /* tocar no campo que JÁ tem o foco com o teclado em baixo (o botão de recolher, abrir ou fechar o dobrável): o focusin não volta
       a disparar, por isso o próprio toque abre o teclado */
    document.addEventListener('click', e => { const t = e.target; if (!t || !t.matches || !t.matches('input,textarea') || t !== document.activeElement || el.classList.contains('in')) return;
      if (t.closest('.no-kb') || ['checkbox', 'range', 'file'].includes(t.type) || !enabled()) return; clearTimeout(hideT); show(t); }, true);
    build();
    /* trocar de aparelho com o teclado aberto: esconde-se e o DOM passa a ser o do outro sistema, sem restos */
    Bridge.on('os:changed', () => { hide(); build(); });
  }
  function build() { const os = isA() ? 'android' : 'ios'; if (built === os) return; built = os; if (os === 'android') buildA(); else buildI(); }
  /* PearOS: exatamente o DOM de sempre */
  function buildI() {
    el.className = ''; el.innerHTML = `<div class="kb-rows"></div><div class="kb-emoji"></div><div class="kb-tools"><span class="abc-back">ABC</span><span></span><span class="hide">${g('chevD', 21)}</span></div>`;
    rows = el.querySelector('.kb-rows'); emo = el.querySelector('.kb-emoji');
    el.querySelector('.hide').onclick = hide; el.querySelector('.abc-back').onclick = () => { Sound.play('key_modifier'); mode = 'abc'; render(); };
    EMOJI.forEach(x => { const s = UI.el(`<span>${x}</span>`); s.onclick = () => insert(x); emo.appendChild(s); });
    render();
  }
  function render() { if (built === 'android') { renderA(); return; }
    const R = mode === 'abc' ? ABC : mode === '123' ? NUM : SYM;
    rows.innerHTML = '';
    R.forEach((r, i) => { const row = UI.el('<div class="kb-row"></div>');
      /* shift PearOS: um toque liga/desliga; dois toques rápidos (<300 ms) = caps lock; com caps, um toque desliga */
      if (i === 2) { if (mode === 'abc') { const sk = UI.el(`<div class="kb-key fn shift ${shift || caps ? 'on' : ''}">${g(caps ? 'lock' : 'shiftKey')}</div>`); sk.onclick = () => { Sound.play('key_modifier'); const now = Date.now(); const dbl = now - lastShift < 300; lastShift = now;
          /* o caps lock troca o GLIFO da tecla (cadeado), por isso aí ainda se re-renderiza;
             um toque simples é só uma classe - não reconstrói o teclado (ver setShift) */
          if (caps) { caps = false; shift = false; render(); } else if (dbl) { caps = true; shift = true; render(); } else setShift(!shift); }; row.appendChild(sk); }
        else { const sk = UI.el(`<div class="kb-key fn">${mode === '123' ? '#+=' : '123'}</div>`); sk.onclick = () => { Sound.play('key_modifier'); mode = mode === '123' ? 'sym' : '123'; render(); }; row.appendChild(sk); } }
      /* a letra fica em MINÚSCULA no HTML (classe `ltr`): quem a levanta é o CSS `#kb.up .kb-key.ltr`
         e a caixa do carácter inserido decide-se no CLIQUE. Assim mudar de maiúsculas não toca no DOM. */
      [...r].forEach(ch => { const key = UI.el(`<div class="kb-key${mode === 'abc' ? ' ltr' : ''}">${UI.esc(ch)}</div>`); key.onclick = () => insert(mode === 'abc' && (shift || caps) ? ch.toUpperCase() : ch);
        /* popup da letra por cima da tecla enquanto está pressionada (PearOS) */
        key.addEventListener('pointerdown', () => { key.classList.add('pressed'); if (!key.querySelector('.kb-pop')) key.appendChild(UI.el(`<div class="kb-pop">${UI.esc(ch)}</div>`)); });
        const rel = () => { key.classList.remove('pressed'); const p = key.querySelector('.kb-pop'); if (p) p.remove(); }; ['pointerup', 'pointercancel', 'pointerleave'].forEach(ev => key.addEventListener(ev, rel));

        row.appendChild(key); });
      if (i === 2) { const bs = UI.el(`<div class="kb-key fn">${g('backspace')}</div>`); bs.onclick = backspace; bs.addEventListener('pointerdown', () => { bsT = setInterval(backspace, 90); }); ['pointerup', 'pointerleave', 'pointercancel'].forEach(ev => bs.addEventListener(ev, () => clearInterval(bsT))); row.appendChild(bs); }
      rows.appendChild(row); });
    const last = UI.el('<div class="kb-row"></div>');
    const sw = UI.el(`<div class="kb-key fn abc">${mode === 'abc' ? '123' : 'ABC'}</div>`); sw.onclick = () => { Sound.play('key_modifier'); mode = mode === 'abc' ? '123' : 'abc'; render(); };
    const em = UI.el(`<div class="kb-key fn">${g('smile')}</div>`); em.onclick = () => { Sound.play('key_modifier'); el.classList.add('emoji'); };
    /* espaço duplo rápido = ". " (PearOS) */
    const sp = UI.el('<div class="kb-key space">espaço</div>'); sp.onclick = () => { const now = Date.now(); const v = target ? target.value : ''; if (mode === 'abc' && now - lastSpace < 350 && /[^\s.!?] $/.test(v)) { backspace(); insert('. '); } else insert(' '); lastSpace = now; };
    const hint = target ? (target.getAttribute('enterkeyhint') || (target.closest('.search') ? 'search' : target.closest('.composer') ? 'send' : '')) : '';
    const ret = UI.el(`<div class="kb-key ret ${RET[hint] ? 'act' : ''}">${UI.esc(RET[hint] || 'enter')}</div>`); ret.onclick = enter;
    last.append(sw, em, sp, ret); rows.appendChild(last);
    el.classList.remove('emoji');
    el.classList.toggle('up', mode === 'abc' && (shift || caps));
  }

  /* ================= NOVA UI: teclado NOVA ================= */
  const SV = (d, sw = 1.8) => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${sw}" stroke-linecap="round" stroke-linejoin="round">${d}</svg>`;
  const AI = {
    emoji: SV('<circle cx="12" cy="12" r="8.6"/><path d="M8.6 14.2a4.2 4.2 0 0 0 6.8 0"/><path d="M9.2 9.6h.01M14.8 9.6h.01" stroke-width="2.6"/>'),
    clip: SV('<rect x="6" y="4.6" width="12" height="15.8" rx="2.6"/><path d="M9.4 4.6V3.8a1 1 0 0 1 1-1h3.2a1 1 0 0 1 1 1v.8"/><path d="M9.3 10h5.4M9.3 13.6h5.4M9.3 17.2h3"/>'),
    gear: SV('<circle cx="12" cy="12" r="3"/><path d="M12 2.8v2.4M12 18.8v2.4M2.8 12h2.4M18.8 12h2.4M5.5 5.5l1.7 1.7M16.8 16.8l1.7 1.7M5.5 18.5l1.7-1.7M16.8 7.2l1.7-1.7"/>'),
    down: SV('<path d="m6.5 9.5 5.5 5.5 5.5-5.5"/>', 2),
    shift: SV('<path d="M12 4.2 4.6 12.4h4.2V19.4h6.4V12.4h4.2z"/>', 1.7),
    shiftOn: '<svg class="gl" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"><path d="M12 4.2 4.6 12.4h4.2V19.4h6.4V12.4h4.2z"/></svg>',
    caps: '<svg class="gl" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"><path d="M12 3.2 4.6 11.2h4.2V16.2h6.4V11.2h4.2z"/><rect x="8.4" y="18.6" width="7.2" height="1.8" rx=".6" stroke-width=".6"/></svg>',
    bs: SV('<path d="M9 5.6h10.2a1.8 1.8 0 0 1 1.8 1.8v9.2a1.8 1.8 0 0 1-1.8 1.8H9L3.2 12z"/><path d="m11.6 9.4 5.2 5.2M16.8 9.4l-5.2 5.2"/>', 1.6),
    enter: SV('<path d="M19.4 5.6v5.6a2.6 2.6 0 0 1-2.6 2.6H5.2"/><path d="m9.2 9.6-4.2 4.2 4.2 4.2"/>', 1.8),
    search: SV('<circle cx="10.6" cy="10.6" r="6.2"/><path d="m15.4 15.4 4.6 4.6"/>', 2),
    send: SV('<path d="M4.2 12.2 19.6 4.6l-4.4 15.2-3.4-6.4z"/><path d="m11.8 13.4 7.8-8.8"/>', 1.8),
    go: SV('<path d="M4.6 12h14.2M13.6 6.6 19 12l-5.4 5.4"/>', 2),
    done: SV('<path d="m5 12.6 4.4 4.4L19 7.4"/>', 2.2),
  };
  const RET_A = { search: 'search', send: 'send', go: 'go', done: 'done', next: 'go' };
  /* a barra de 3 botões está à vista? (o SysUI esconde-a no assistente e no ecrã bloqueado; sem ela o teclado desce ao fundo) */
  const navOn = () => { if (window.SysUI && typeof SysUI.navVisible === 'function') return !!SysUI.navVisible();
    const nb = UI.screen().querySelector('.anb'); return nb ? (nb.classList.contains('anb-on') || nb.classList.contains('on')) : document.body.dataset.nav !== 'gesture'; };
  const ROW1_HINT = '1234567890';
  /* acentos do toque longo (pt, es, fr): o primeiro é o que sai se se largar sem escolher */
  const ACC = { a: 'áàâãä', e: 'éèêë', i: 'íìîï', o: 'óòôõö', u: 'úùûü', c: 'ç', n: 'ñ', s: 'ß', y: 'ý' };
  const SYM1 = ['1234567890', '+×÷=/_<>[]', '!@#$%^&*()', '-\'":;,?'], SYM2 = ['`~\\|{}€£¥₩', '°•○●□■♤♡◇♧', '☆▪¤«»¡¿§¶©', '-\'":;,?'];
  const LANGS = { pt: 'Português (PT)', en: 'English (UK)', es: 'Español (ES)', fr: 'Français (FR)', de: 'Deutsch (DE)', it: 'Italiano (IT)', nl: 'Nederlands', pl: 'Polski', tr: 'Türkçe', sv: 'Svenska', ru: 'Русский', ja: '日本語', ko: '한국어', 'zh-Hans': '简体中文', 'zh-Hant': '繁體中文' };
  const TA = s => (window.L && L.t ? L.t(s) : s);
  /* preferências do teclado NOVA (Store da personagem) */
  const PREF_DEF = { numRow: false, preview: true, autoCap: true };
  const pref = () => { let p = null; try { p = Store.get('akb', null); } catch (e) { p = null; } return Object.assign({}, PREF_DEF, p && typeof p === 'object' ? p : {}); };
  const setPref = (k, v) => { const p = pref(); p[k] = v; try { Store.set('akb', p); } catch (e) {} };
  let panel = '';   /* '' (teclas) | 'emoji' | 'clip' | 'set' */
  let mainA, panelA, barA, lpT = null, lp = null;
  const clipHist = [];   /* textos copiados nesta sessão (o mais recente primeiro) */
  function buildA() {
    el.className = 'akb';
    el.innerHTML = `<div class="akb-bar"><span class="akb-tb" data-t="emoji">${AI.emoji}</span><span class="akb-tb" data-t="clip">${AI.clip}</span><span class="akb-tb" data-t="set">${AI.gear}</span><span class="akb-gap"></span><span class="akb-tb" data-t="hide">${AI.down}</span></div><div class="akb-main"></div><div class="akb-panel"></div>`;
    barA = el.querySelector('.akb-bar'); mainA = el.querySelector('.akb-main'); panelA = el.querySelector('.akb-panel'); rows = mainA; emo = null;
    barA.onclick = e => { const b = e.target.closest('.akb-tb'); if (!b) return; Sound.play('key_modifier'); const t = b.dataset.t; if (t === 'hide') { hide(); return; } openPanel(panel === t ? '' : t); };
    panel = ''; render();
  }
  function openPanel(p) {
    panel = p; el.classList.toggle('panel', !!p);
    barA.querySelectorAll('.akb-tb').forEach(b => b.classList.toggle('on', b.dataset.t === p));
    /* o painel cobre exatamente a zona das teclas (que fica no sítio, invisível): o teclado não salta nem tapa mais da app */
    panelA.innerHTML = '';
    if (p === 'emoji') {
      const grid = UI.el('<div class="akb-emo"></div>'); EMOJI.forEach(x => { const s = UI.el(`<span>${x}</span>`); s.onclick = () => insert(x); grid.appendChild(s); });
      const foot = UI.el(`<div class="akb-pfoot"><div class="akb-key fn akb-abc">ABC</div><div class="akb-key fn akb-bs">${AI.bs}</div></div>`);
      foot.querySelector('.akb-abc').onclick = () => { Sound.play('key_modifier'); openPanel(''); };
      bindBs(foot.querySelector('.akb-bs')); panelA.append(grid, foot);
    } else if (p === 'clip') {
      syncClip();
      const head = UI.el(`<div class="akb-ph"><b>${UI.esc(TA('Área de transferência'))}</b>${clipHist.length ? `<span class="akb-clr">${UI.esc(TA('Limpar'))}</span>` : ''}</div>`);
      const list = UI.el('<div class="akb-clips"></div>');
      if (!clipHist.length) list.appendChild(UI.el(`<div class="akb-empty">${UI.esc(TA('Os textos que copiares aparecem aqui.'))}</div>`));
      clipHist.forEach(t => { const c = UI.el(`<div class="akb-clip">${UI.esc(t)}</div>`); c.onclick = () => { insert(t); }; list.appendChild(c); });
      const clr = head.querySelector('.akb-clr'); if (clr) clr.onclick = () => { Sound.play('click'); clipHist.length = 0; try { if (window.Msgs) Msgs.clipboard = ''; } catch (e) {} openPanel('clip'); };
      panelA.append(head, list);
    } else if (p === 'set') {
      const pf = pref();
      const head = UI.el(`<div class="akb-ph"><b>${UI.esc(TA('Definições do teclado'))}</b></div>`);
      const list = UI.el('<div class="akb-sets"></div>');
      [['numRow', TA('Fila de números')], ['preview', TA('Pré-visualizar ao tocar')], ['autoCap', TA('Maiúsculas automáticas')]].forEach(([k, l]) => {
        const r = UI.el(`<div class="akb-set ${pf[k] ? 'on' : ''}"><span>${UI.esc(l)}</span><i class="akb-tog"><i></i></i></div>`);
        r.onclick = () => { Sound.play('click'); const v = !pref()[k]; setPref(k, v); r.classList.toggle('on', v); if (k === 'numRow') renderA(); };
        list.appendChild(r); });
      panelA.append(head, list);
    }
  }
  /* a área de transferência do telemóvel é a do Msgs (no CEF o navigator.clipboard falha): guarda-se o histórico da sessão */
  function syncClip() { let c = ''; try { c = window.Msgs && typeof Msgs.clipboard === 'string' ? Msgs.clipboard : ''; } catch (e) { c = ''; } c = String(c || '').trim(); if (!c) return; const i = clipHist.indexOf(c); if (i === 0) return; if (i > 0) clipHist.splice(i, 1); clipHist.unshift(c); while (clipHist.length > 8) clipHist.pop(); }
  function bindBs(bs) { bs.onclick = backspace; bs.addEventListener('pointerdown', () => { clearInterval(bsT); bsT = setInterval(backspace, 90); }); ['pointerup', 'pointerleave', 'pointercancel'].forEach(ev => bs.addEventListener(ev, () => clearInterval(bsT))); }
  const keyA = (ch, cls = '') => UI.el(`<div class="akb-key ${cls}">${ch}</div>`);
  function renderA() {
    const pf = pref(); mainA.innerHTML = ''; clearTimeout(lpT); lp = null;
    el.classList.toggle('numrow', !!pf.numRow && mode === 'abc');
    const row = (cls = '') => { const r = UI.el(`<div class="akb-row ${cls}"></div>`); mainA.appendChild(r); return r; };
    const fn = (html, cls, onTap) => { const k = keyA(html, 'fn ' + (cls || '')); k.onclick = () => { Sound.play('key_modifier'); onTap(); }; return k; };
    const chKey = (ch, opts = {}) => { const k = keyA(`<span class="akb-ch">${UI.esc(ch)}</span>${opts.hint ? `<sub>${UI.esc(opts.hint)}</sub>` : ''}`, opts.ltr ? 'ltr' : '');
      k.onclick = () => { if (k._skip) { k._skip = false; return; } insert(opts.ltr && (shift || caps) ? ch.toUpperCase() : ch); };
      pressA(k, ch, opts); return k; };
    if (mode === 'num') {
      /* campos de números e de telefone: teclado numérico grande */
      const tel = !!(target && target.type === 'tel');
      const r1 = row('akb-numpad'), r2 = row('akb-numpad'), r3 = row('akb-numpad'), r4 = row('akb-numpad');
      '123'.split('').forEach(c => r1.appendChild(chKey(c))); r1.appendChild(chKey('-', {}));
      '456'.split('').forEach(c => r2.appendChild(chKey(c))); { const sp = keyA(`<span class="akb-spl">${UI.esc(TA('Espaço'))}</span>`, 'fn'); sp.onclick = () => insert(' '); r2.appendChild(sp); }
      '789'.split('').forEach(c => r3.appendChild(chKey(c))); { const bs = keyA(AI.bs, 'fn akb-bs'); bindBs(bs); r3.appendChild(bs); }
      r4.appendChild(chKey(tel ? '+' : ',')); r4.appendChild(chKey('0')); r4.appendChild(chKey(tel ? '#' : '.')); r4.appendChild(retKey());
      el.classList.remove('up'); return;
    }
    if (mode === 'abc') {
      if (pf.numRow) { const r0 = row('akb-nums'); [...ROW1_HINT].forEach(c => r0.appendChild(chKey(c))); }
      const r1 = row(); [...ABC[0]].forEach((c, i) => r1.appendChild(chKey(c, { ltr: true, hint: pf.numRow ? '' : ROW1_HINT[i], alt: pf.numRow ? '' : ROW1_HINT[i] })));
      const r2 = row('akb-r2'); [...ABC[1]].forEach(c => r2.appendChild(chKey(c, { ltr: true })));
      const r3 = row();
      /* shift NOVA: um toque liga/desliga, dois toques rápidos = maiúsculas fixas; o glifo troca por CSS (sem reconstruir) */
      const sk = keyA(`<i class="s0">${AI.shift}</i><i class="s1">${AI.shiftOn}</i><i class="s2">${AI.caps}</i>`, 'fn shift wide');
      sk.onclick = () => { Sound.play('key_modifier'); const now = Date.now(); const dbl = now - lastShift < 300; lastShift = now;
        if (caps) { caps = false; shift = false; } else if (dbl) { caps = true; shift = true; } else { setShift(!shift); return; } paintShift(); };
      r3.appendChild(sk);
      [...ABC[2]].forEach(c => r3.appendChild(chKey(c, { ltr: true })));
      const bs = keyA(AI.bs, 'fn wide akb-bs'); bindBs(bs); r3.appendChild(bs);
      lastRow(row('akb-last'), '!#1', () => { mode = 'sym1'; renderA(); });
      paintShift(); return;
    }
    /* símbolos: duas páginas (1/2 e 2/2) */
    const S = mode === 'sym2' ? SYM2 : SYM1;
    S.slice(0, 3).forEach(r => { const rr = row(); [...r].forEach(c => rr.appendChild(chKey(c))); });
    const r4 = row(); r4.appendChild(fn(mode === 'sym2' ? '2/2' : '1/2', 'wide akb-pg', () => { mode = mode === 'sym2' ? 'sym1' : 'sym2'; renderA(); }));
    [...S[3]].forEach(c => r4.appendChild(chKey(c)));
    const bs = keyA(AI.bs, 'fn wide akb-bs'); bindBs(bs); r4.appendChild(bs);
    lastRow(row('akb-last'), 'ABC', () => { mode = 'abc'; renderA(); });
    el.classList.remove('up');
    function lastRow(r, lbl, onSw) {
      r.appendChild(fn(lbl, 'wide akb-mode', onSw));
      r.appendChild(chKey(','));
      const lc = (window.L && L.code) || 'pt';
      const sp = keyA(`<span class="akb-spl">${UI.esc(LANGS[lc] || (window.L && L.name ? L.name(lc) : 'Português (PT)'))}</span>`, 'space');
      /* espaço duplo rápido = ". " (o mesmo do PearOS) */
      sp.onclick = () => { const now = Date.now(); const v = target ? target.value : ''; if (mode === 'abc' && now - lastSpace < 350 && /[^\s.!?] $/.test(v)) { backspace(); insert('. '); } else insert(' '); lastSpace = now; };
      r.appendChild(sp); r.appendChild(chKey('.')); r.appendChild(retKey());
    }
  }
  function retKey() {
    const hint = target ? (target.getAttribute('enterkeyhint') || (target.closest('.search') ? 'search' : target.closest('.composer') ? 'send' : '')) : '';
    const ic = RET_A[hint]; const k = keyA(ic ? AI[ic] : AI.enter, 'fn wide ret' + (ic ? ' act' : '')); k.onclick = enter; return k;
  }
  /* pré-visualização da tecla e toque longo (número da fila de cima ou acentos a escolher) */
  function pressA(k, ch, opts) {
    /* fila de cima sem a fila de números: o número vem primeiro e, havendo acentos (e, u, i, o, y), aparecem a seguir */
    const accs = opts.ltr ? (ACC[ch] || '') : ''; const alts = (opts.alt || '') + accs;
    k.addEventListener('pointerdown', e => {
      k.classList.add('pressed'); k._skip = false; clearTimeout(lpT);
      if (pref().preview && !k.querySelector('.akb-pop')) k.appendChild(UI.el(`<div class="akb-pop">${UI.esc(opts.ltr && (shift || caps) ? ch.toUpperCase() : ch)}</div>`));
      if (!alts) return;
      try { k.setPointerCapture(e.pointerId); } catch (x) {}
      lpT = setTimeout(() => {
        const up = opts.ltr && (shift || caps); const list = [...alts].map(c => up && !/\d/.test(c) ? c.toUpperCase() : c);
        const pop = k.querySelector('.akb-pop'); if (pop) pop.remove();
        if (list.length === 1 && opts.alt) { k._skip = true; insert(list[0]); Sound.play('key_modifier'); lp = null; return; }   /* número da fila de cima: sai logo */
        const box = UI.el(`<div class="akb-alt">${list.map((c, i) => `<span class="${i ? '' : 'on'}" data-c="${UI.esc(c)}">${UI.esc(c)}</span>`).join('')}</div>`);
        k.appendChild(box); lp = { k, box, pick: list[0] }; Sound.play('key_modifier');
        /* a caixa não sai do ecrã: encosta à esquerda ou à direita conforme a tecla */
        try { const sr = UI.screen().getBoundingClientRect(), W = System.SW || 440, z = sr.width / W, kr = k.getBoundingClientRect(); const kx = (kr.left - sr.left) / z; const w = list.length * 38 + 8; let left = (kr.width / z - w) / 2; if (kx + left < 4) left = 4 - kx; if (kx + left + w > W - 4) left = W - 4 - kx - w; box.style.left = left + 'px'; } catch (x) {}   /* W: 880 no fold aberto */
      }, 420);
    });
    /* escolher deslizando na horizontal (a altura não conta, como no teclado a sério): a opção debaixo do dedo, ou a da ponta */
    k.addEventListener('pointermove', e => { if (!lp || lp.k !== k) return; const sp = [...lp.box.querySelectorAll('span')]; if (!sp.length) return;
      let s = sp.find(x => { const r = x.getBoundingClientRect(); return e.clientX >= r.left && e.clientX <= r.right; });
      if (!s) { const r0 = sp[0].getBoundingClientRect(), rl = sp[sp.length - 1].getBoundingClientRect(); s = e.clientX < r0.left ? sp[0] : e.clientX > rl.right ? sp[sp.length - 1] : null; }
      if (s) { sp.forEach(x => x.classList.toggle('on', x === s)); lp.pick = s.dataset.c; } });
    const rel = () => { clearTimeout(lpT); k.classList.remove('pressed'); const p = k.querySelector('.akb-pop'); if (p) p.remove();
      if (lp && lp.k === k) { const pick = lp.pick; lp.box.remove(); lp = null; k._skip = true; insert(pick); } };
    ['pointerup', 'pointercancel'].forEach(ev => k.addEventListener(ev, rel));
    k.addEventListener('pointerleave', () => { if (lp && lp.k === k) return; rel(); });
  }
  function paintShift() {
    if (built !== 'android' || !el) return;
    el.classList.toggle('up', mode === 'abc' && (shift || caps));
    const sk = mainA && mainA.querySelector('.akb-key.shift'); if (sk) { sk.classList.toggle('on', shift && !caps); sk.classList.toggle('caps', caps); }
  }

  /* MUDAR DE CAIXA NÃO RECONSTRÓI O TECLADO.
     A caixa das letras é CSS (`#kb.up .kb-key.ltr`) e o carácter inserido decide-se no clique, por
     isso passar de minúsculas a maiúsculas é uma classe no #kb e outra na tecla de shift. Antes
     cada tecla premida em modo abc corria o render() inteiro - innerHTML='' + 32 teclas + ~140
     ouvintes novos - e isso acontece várias vezes por frase (depois da primeira letra, depois de
     cada ponto, e a cada Backspace que esvazia o campo). O render() fica para o que muda de facto:
     o MODO (abc/123/#+=), o caps lock e o campo que ganha o foco. */
  function setShift(v) {
    v = !!v; if (shift === v) return; shift = v;
    if (!el) return;
    if (built === 'android') { paintShift(); return; }
    el.classList.toggle('up', mode === 'abc' && (shift || caps));
    const sk = rows.querySelector('.kb-key.shift'); if (sk) sk.classList.toggle('on', shift || caps);
  }
  /* Nova UI: "Maiúsculas automáticas" desligadas nas definições do teclado = sem maiúscula sozinha */
  const autoCapOff = () => built === 'android' && !pref().autoCap;
  function insert(ch) {
    if (!target) return; const s = target.selectionStart ?? target.value.length, e = target.selectionEnd ?? s;
    if (target.maxLength > 0 && target.value.length - (e - s) + ch.length > target.maxLength) return;
    target.value = target.value.slice(0, s) + ch + target.value.slice(e); const p = s + ch.length; try { target.setSelectionRange(p, p); } catch (x) {}
    target.dispatchEvent(new Event('input', { bubbles: true })); Sound.play(ch === ' ' || ch === '\n' ? 'key_modifier' : 'tap');
    if (mode === 'abc' && shift && !caps) setShift(false);
    if (!caps && !noCap && !autoCapOff() && mode === 'abc' && /[.!?]\s$/.test(target.value.slice(0, p)) && !shift) setShift(true);
  }
  function backspace() { if (!target) return; const s = target.selectionStart ?? target.value.length, e = target.selectionEnd ?? s; if (s === 0 && e === 0) return; const a = s === e ? s - 1 : s; target.value = target.value.slice(0, a) + target.value.slice(e); try { target.setSelectionRange(a, a); } catch (x) {} target.dispatchEvent(new Event('input', { bubbles: true })); Sound.play('key_delete'); if (!target.value && mode === 'abc' && !shift && !noCap && !autoCapOff()) setShift(true); }
  function enter() { if (!target) return; if (target.tagName === 'TEXTAREA') { insert('\n'); return; } target.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', bubbles: true })); target.dispatchEvent(new Event('change', { bubbles: true })); Sound.play('key_modifier'); }
  function show(t) {
    build();
    /* CAMPO A ESCREVER (2026-09-20): no jogo o teclado é o nosso, e o `:focus` do CEF nem sempre pinta o campo - sem sinal
       nenhum o jogador não percebia que já tinha tocado ("tem de desaparecer o texto para dar a entender que cliquei").
       A classe marca o campo ativo: o CSS esconde o texto de exemplo e acende o aro (ui.css). */
    document.querySelectorAll('.kb-on').forEach(e => e.classList.remove('kb-on')); t.classList.add('kb-on');
    const A = built === 'android';
    const numeric = t.type === 'tel' || t.type === 'number' || t.inputMode === 'numeric';
    target = t; mode = numeric ? (A ? 'num' : '123') : 'abc';
    noCap = /^(off|none|characters)$/i.test(t.getAttribute('autocapitalize') || '') || ['email', 'url', 'password'].includes(t.type);   /* nomes de utilizador, emails, palavras-passe: sem maiúscula automática */
    shift = !t.value && !noCap && !autoCapOff(); caps = false;
    if (A) { if (panel) openPanel(''); el.classList.toggle('nonav', !navOn()); }
    render(); el.classList.add('in');
    /* quem tem barras em baixo (o assistente da Nova UI) ouve isto para as subir acima do teclado */
    if (A) Bridge.emit('kb:show', { h: el.offsetHeight });
    setTimeout(() => place(t), 50);
  }
  /* sobe o que for preciso (a janela, a folha ou, no PearPhone Fold, só a vista dona do campo) para o campo ficar acima do teclado.
     instant: sem animação (refit, ao abrir ou fechar o dobrável) */
  /* PearPhone Fold: o campo pode estar no conteúdo com zoom (ui.css, --az) e o ecrã não. Retângulos em px reais nos dois motores
     (UI.vrect: o Chromium do jogo devolve o getBoundingClientRect dividido pelo zoom do próprio elemento) e o que se escreve num
     elemento com zoom (a subida, a folga, a altura) vai nos px DELE: kz = o zoom dele a dividir pelo do ecrã (1 sem zoom) */
  const vr = n => UI.vrect ? UI.vrect(n) : n.getBoundingClientRect();
  const kz = n => { if (!UI.vrect) return 1; const a = UI.zoom(n), b = UI.zoom(UI.screen()); return a > 0 && b > 0 ? a / b : 1; };
  function place(t, instant) {
    const A = built === 'android';
    const s = vr(UI.screen()), k = s.width / (System.SW || 440), r = vr(t); const bottom = (r.bottom - s.top) / k, top = (r.top - s.top) / k;
    /* Nova UI: o teclado assenta em cima da barra de navegação de 3 botões (o `bottom` dele) */
    const off = A ? (parseFloat(getComputedStyle(el).bottom) || 0) : 0;
    const kbTop = 956 - el.offsetHeight - off; let shift2 = bottom > kbTop - 12 ? -(bottom - kbTop + 24) : 0;
    if (A && paneFit(t, kbTop, instant)) return;   /* NOVA Fold8 aberto com duas colunas: só a coluna do campo */
    /* CAMPO ALTO (editor das Notas, corpo de um email): o fundo dele está muito abaixo do teclado e a conta acima empurrava a
       janela inteira para cima - a barra de navegação e o início do texto saíam do ecrã (visto nas capturas de 2026-09-19).
       O topo do campo nunca sobe acima da barra (≈110 px); em troca o conteúdo ganha folga em baixo para se poder rolar. */
    const MIN_TOP = 110;
    if (shift2 < 0 && top + shift2 < MIN_TOP) { shift2 = Math.min(0, MIN_TOP - top); const sc = t.closest('.content'); if (sc && !padded.has(sc)) { padded.set(sc, sc.style.paddingBottom); sc.style.paddingBottom = (el.offsetHeight + 24) / kz(sc) + 'px'; } }
    const win = t.closest('.app-window,.sheet'); if (!win) return;
    /* FOLHA (26 out 2026, "quando o teclado sobe não dá para ver tudo"): a conta de cima só sobe o que o CAMPO precisa, e o que
       a folha tem POR BAIXO do campo (a linha Foto/contador do compositor do Tweeter, os botões de uma folha de edição) ficava
       atrás das teclas. Uma folha assenta INTEIRA em cima do teclado, como no PearOS, desde que o topo dela não passe a barra
       de estado (MIN_TOP); uma folha mais alta do que o espaço ENCOLHE até ele (.kb-tall: max-height e o conteúdo passa a
       rolar, ui.css) e o campo rola para a vista. As medidas descontam a subida já aplicada (segundo campo na mesma folha: o
       rect vem deslocado e a folha descia outra vez) e são feitas com a folha na altura natural (sem o encolher anterior). */
    if (win.classList.contains('sheet')) {
      if (win.classList.contains('kb-tall')) { clearTimeout(win._kbTallT); win.classList.remove('kb-tall'); win.style.removeProperty('--kb-max'); void win.offsetWidth; }
      const cur = (parseFloat(win.style.getPropertyValue('--kb-shift')) || 0) * kz(win);
      const wr = vr(win), wTop = (wr.top - s.top) / k - cur, wBottom = (wr.bottom - s.top) / k - cur;
      const avail = kbTop - MIN_TOP;
      if (wBottom - wTop > avail + 1) {
        win.style.setProperty('--kb-max', avail / kz(win) + 'px'); win.classList.add('kb-tall');
        requestAnimationFrame(() => { if (target === t) { try { t.scrollIntoView({ block: 'nearest' }); } catch (e) {} } });
      }
      shift2 = -(wBottom - kbTop);   /* o fundo da folha assenta no topo do teclado */
    }
    /* PearPhone Fold: a JANELA não sobe (ao lado das teclas a coluna da barra direita mostrava o fundo do ecrã e o canto redondo da
       janela ficava a meio do ecrã). Sobe só a vista dona do campo (ou o painel dela nas duas colunas, ou a camada da app); a
       janela, a barra e a outra coluna ficam quietas. A pesquisa presa ao fundo da lista (duas colunas) não sobe: a lista encolhe
       até ao teclado (kb-short) e o título dela fica no sítio */
    let box = win;
    const foldRail = win.classList.contains('app-window') && !!(window.Rail && Rail.active);
    if (foldRail) {
      box = t.closest('.nav-stack > .view');
      if (!box || !win.contains(box)) { box = t; while (box && box.parentElement && box.parentElement !== win) box = box.parentElement; if (!box || box.parentElement !== win) box = win; }
    }
    if (foldRail) [...shifted].forEach(w => { if (w !== box) unlift(w); });   /* outro campo noutra coluna: a anterior desce */
    if (instant) still(box);
    if (foldRail && box !== win) {
      if (box.matches('.nav-stack.split > .view:first-child') && t.closest(PANE_SEARCH)) {
        clearTimeout(box._kbT); box.classList.remove('kb-lift'); box.style.removeProperty('--kb-shift');   /* subida de antes (outra geometria) sai */
        box.style.setProperty('--kb-h', (el.offsetHeight + off) / kz(box) + 'px'); box.classList.add('kb-short'); shifted.add(box); return; }
      clearTimeout(box._kbT); box.classList.add('kb-lift');
    }
    box.style.setProperty('--kb-shift', shift2 / kz(box) + 'px'); shifted.add(box);
  }
  /* NOVA Fold8 aberto, duas colunas (UI.split): a JANELA não sobe (a lista do lado ia para baixo da barra de estado e o título e a
     pesquisa dela saíam do ecrã). Só a coluna dona do campo ENCOLHE até ao topo do teclado (.kb-short, oneui-ui.css): o cabeçalho
     dela fica à vista, o compositor assenta em cima das teclas e a conversa por cima dele continua a acabar junto a ele. Um campo
     dentro do que rola (formulário, editor) rola para a vista; se mesmo assim ficar tapado, a coluna sobe o que falta (.kb-lift).
     false = o campo não está numa coluna (segue o caminho de sempre) */
  function paneFit(t, kbTop, instant) {
    const win = t.closest('.app-window'), pane = win ? t.closest('.nav-stack.split > .view') : null;
    if (!pane || !win.contains(pane)) return false;
    /* o que estava subido ou encolhido (a outra coluna, a janela, esta coluna noutro campo) volta já, sem animar, e mede-se de novo */
    const moved = [...shifted]; if (instant) moved.push(pane); moved.forEach(still); moved.forEach(unlift); void UI.screen().offsetWidth;
    const s = UI.screen().getBoundingClientRect(), k = s.width / (System.SW || 440), Y = y => (y - s.top) / k;
    const done = () => { void UI.screen().offsetWidth; moved.forEach(n => n.style.removeProperty('transition')); return true; };
    if (Y(t.getBoundingClientRect().bottom) <= kbTop - 12) return done();   /* o teclado não chega ao campo: nada mexe */
    /* quem rola por cima do campo: o próprio contentor dele (formulário, editor) ou, num compositor, a conversa da coluna */
    let fsc = null; for (let n = t.parentElement; n && n !== pane; n = n.parentElement) { if (/auto|scroll/.test(getComputedStyle(n).overflowY)) { fsc = n; break; } }
    const conv = fsc ? null : pane.querySelector(':scope > .content');
    const dist = conv ? Math.max(0, conv.scrollHeight - conv.scrollTop - conv.clientHeight) : 0;
    const cut = Math.round(Y(pane.getBoundingClientRect().bottom) - kbTop);
    if (cut > 0) { pane.style.setProperty('--kb-h', cut + 'px'); pane.classList.add('kb-short'); shifted.add(pane); }
    /* a conversa fica à mesma distância do fim (a última mensagem continua junto ao compositor) */
    if (conv && cut > 0) { conv.scrollTop = Math.max(0, conv.scrollHeight - conv.clientHeight - dist); pane._kbSc = conv; }
    let r = t.getBoundingClientRect();
    if (fsc && Y(r.bottom) > kbTop - 12) {
      /* cabe por cima das teclas: rola até ele ficar todo à vista. Campo ALTO (o editor das Notas, o corpo de um email) com o início
         já à vista: não rola (o título da nota fica); se começar junto às teclas, o início sobe para o topo do que rola */
      const top0 = Y(fsc.getBoundingClientRect().top), room = Y(r.top) - top0 - 8, fits = Y(r.bottom) - Y(r.top) + 32 <= kbTop - top0;
      const need = fits ? Math.min(Y(r.bottom) - kbTop + 24, Math.max(0, room)) : (Y(r.top) > kbTop - 120 ? Math.max(0, room) : 0);
      if (need > 0) { fsc.scrollTop += need; r = t.getBoundingClientRect(); } }
    const left = Y(r.bottom) - kbTop + 24;
    if (left > 12 && !(fsc && Y(r.top) < kbTop - 60)) {   /* ainda tapado (e não é um campo alto já à vista): a coluna sobe o resto */
      clearTimeout(pane._kbT); pane.classList.add('kb-lift'); pane.style.setProperty('--kb-shift', -Math.round(left) + 'px'); shifted.add(pane); }
    return done();
  }
  /* a pesquisa da lista nas duas colunas (presa ao fundo dela, ui.css): direta no conteúdo ou dentro de um invólucro .pane-wrap */
  const PANE_SEARCH = '.content > .search, .content > .pane-wrap > .search';
  const still = n => { if (n && n.style) n.style.setProperty('transition', 'none', 'important'); };
  /* o dobrável abriu ou fechou com o teclado aberto (system.js keepKb): o teclado fica; o que ele tinha subido volta ao sítio de uma
     vez, o campo mede-se outra vez na geometria nova e sobe o que for preciso, também de uma vez (sem animação: nada mexe à vista
     além da própria troca de geometria). false = não havia nada para acertar */
  function refit(t) {
    if (!el || !el.classList.contains('in')) return false;
    if (t && t !== target) { show(t); return true; }
    if (!target || !target.isConnected) return false;
    const moved = [...shifted]; moved.forEach(still); moved.forEach(unlift); shifted.clear();
    padded.forEach((old, sc) => { sc.style.paddingBottom = old || ''; }); padded.clear();
    if (built === 'android') { el.classList.toggle('nonav', !navOn()); Bridge.emit('kb:show', { h: el.offsetHeight }); }
    place(target, true);
    void UI.screen().offsetWidth;   /* o valor novo fica calculado sem transição; tirar o 'none' depois já não anima nada */
    new Set([...moved, ...shifted]).forEach(n => n.style.removeProperty('transition'));
    return true;
  }
  /* devolve ao sítio o que subiu (ou encolheu) por causa do teclado; a classe da vista que subiu sai depois de ela descer */
  function unlift(w) {
    shifted.delete(w); w.style.removeProperty('--kb-shift');
    if (w.classList.contains('kb-short')) {
      /* coluna encolhida com uma conversa (paneFit): volta a crescer com a conversa a acabar no mesmo sítio junto ao campo */
      const sc = w._kbSc && w._kbSc.isConnected && w.contains(w._kbSc) ? w._kbSc : null, d = sc ? Math.max(0, sc.scrollHeight - sc.scrollTop - sc.clientHeight) : 0;
      w.classList.remove('kb-short'); w.style.removeProperty('--kb-h'); w._kbSc = null;
      if (sc) sc.scrollTop = Math.max(0, sc.scrollHeight - sc.clientHeight - d); }
    if (w.classList.contains('kb-lift')) { clearTimeout(w._kbT); w._kbT = setTimeout(() => { if (!shifted.has(w)) w.classList.remove('kb-lift'); }, 520); }
    /* folha encolhida por causa do teclado: volta à altura natural depois de descer (o place() tira-a já se voltar a subir) */
    if (w.classList.contains('kb-tall')) { clearTimeout(w._kbTallT); w._kbTallT = setTimeout(() => { if (!shifted.has(w)) { w.classList.remove('kb-tall'); w.style.removeProperty('--kb-max'); } }, 400); }
  }
  const padded = new Map();   /* .content que ganhou folga por causa do teclado → o padding-bottom que tinha antes */
  /* quem recebeu --kb-shift fica registado aqui. O hide() corre em CADA focusout (120 ms depois) e
     fazia `document.querySelectorAll('[style*="--kb-shift"]')`: um seletor de substring no atributo
     style de TODOS os nós do documento (com as janelas retidas são milhares), o que ainda obriga o
     Chromium a serializar o estilo em linha de cada nó mexido por CSSOM. Só este ficheiro o escreve. */
  const shifted = new Set();
  function hide() { hideWait = false; if (!el) return; const was = el.classList.contains('in'); el.classList.remove('in', 'emoji'); if (was && built === 'android') Bridge.emit('kb:hide'); [...shifted].forEach(unlift); shifted.clear(); padded.forEach((old, sc) => { sc.style.paddingBottom = old || ''; }); padded.clear();
    clearInterval(bsT); clearTimeout(lpT); if (lp) { try { lp.box.remove(); } catch (e) {} lp = null; }
    if (built === 'android' && panel) openPanel('');
    document.querySelectorAll('.kb-on').forEach(e => e.classList.remove('kb-on')); target = null; }
  return { init, show, hide, refit, close: hide, get visible() { return el && el.classList.contains('in'); } };
})();
