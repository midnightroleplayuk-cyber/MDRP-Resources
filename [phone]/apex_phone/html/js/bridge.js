/* ============================================================
   BRIDGE - ponte NUI ⇄ client.lua ⇄ server (RPC) + eventos push
   ------------------------------------------------------------
   Bridge.call(name, data)  → NUI callback no client.lua (Promise)
   Bridge.rpc(name, data)   → 'rpc' → QBCore callback no servidor (Promise)
   Bridge.request(name, d)  → como o rpc, mas SEMPRE { success, data, error } (ver contracts.js)
   Bridge.on(event, fn)     → eventos push vindos do client.lua
   No browser (sem FiveM): rpc → LocalDB.rpc, call → Mock.call
   ============================================================ */
window.Bridge = (() => {
  const inFiveM = typeof window.GetParentResourceName === 'function';
  const res = inFiveM ? window.GetParentResourceName() : 'apex_phone';
  const handlers = {};

  function on(ev, fn) { (handlers[ev] = handlers[ev] || []).push(fn); return () => off(ev, fn); }
  function off(ev, fn) { const h = handlers[ev]; if (!h) return; const i = h.indexOf(fn); if (i > -1) h.splice(i, 1); }
  function emit(ev, data) { (handlers[ev] || []).slice().forEach(f => { try { f(data); } catch (e) { console.error('[apex_phone] handler', ev, e); } }); }

  function call(name, data) {
    if (!inFiveM) return Promise.resolve().then(() => window.Mock ? Mock.call(name, data || {}) : null);
    return fetch(`https://${res}/${name}`, {
      method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data || {})
    }).then(r => r.json()).catch(() => null);
  }
  /* call com PRAZO: um callback do client.lua que nunca chame cb() deixaria o fetch pendurado para
     sempre (obturador morto, Face Key a meio). Passado o prazo devolve {error:'timeout'} e a UI recupera. */
  function callT(name, data, ms) {
    return Promise.race([call(name, data), new Promise(r => setTimeout(() => r({ error: 'timeout' }), ms || 20000))]);
  }
  function rpc(name, data) {
    if (!inFiveM) return Promise.resolve().then(() => LocalDB.rpc(name, data || {}));
    return call('rpc', { name, data: data || {} }).then(r => (r && r.error) ? (console.warn('[apex_phone] rpc', name, r.error), null) : r);
  }
  /* igual ao rpc mas SEM engolir o erro: quem chama precisa do código ({error:'toolarge'}, …) para
     dizer ao utilizador o que falhou - o rpc() normal devolve null e perde-se a razão. */
  function rpcRaw(name, data) {
    if (!inFiveM) return Promise.resolve().then(() => LocalDB.rpc(name, data || {}));
    return call('rpc', { name, data: data || {} });
  }
  /* ---------- Bridge.request(name, data) → { success, data, error } ----------
     O contrato uniforme por cima das respostas LEGADAS, sem mexer nas ~270 que já existem:
       null / undefined / false (o client.lua devolve false quando o RPC deu nil) → { success:false, error:'empty' }
       { error:'x', … }                                                          → { success:false, error:'x', data:<objeto> }
       { ok:false, … }                                                           → { success:false, error:'failed', data:<objeto> }
       { success:bool, data?, error? } (RPCs novos já no formato)                  → tal e qual
       qualquer outra coisa (arrays, { ok:true }, linhas)                         → { success:true, data:<resposta> }
     Em falha o `data` mantém o objeto original: o account.verifyPin, por exemplo, responde
     { ok:false, attempts, lockedUntil } e quem chama precisa desses campos. Nunca rejeita. */
  function normalize(r) {
    if (r === null || r === undefined || r === false) return { success: false, data: null, error: 'empty' };
    if (typeof r === 'object' && !Array.isArray(r)) {
      if (typeof r.success === 'boolean' && ('data' in r || 'error' in r)) return { success: r.success, data: r.data === undefined ? null : r.data, error: r.success ? null : String(r.error || 'failed') };
      if (r.error) return { success: false, data: r, error: String(r.error) };
      if (r.ok === false) return { success: false, data: r, error: 'failed' };
    }
    return { success: true, data: r, error: null };
  }
  function request(name, data) {
    let p; try { p = rpcRaw(name, data); } catch (e) { return Promise.resolve({ success: false, data: null, error: 'exception' }); }
    return Promise.resolve(p).then(normalize, () => ({ success: false, data: null, error: 'exception' }));
  }

  /* ---------- Config.Debug (vem no `ready`) ----------
     Com debug ligado, Bridge.dbg escreve na consola e, no jogo, na F8 (via o mesmo 'jsError' dos
     erros, marcado [debug]). Desligado não custa nada: nem monta a string. */
  let debug = false, dbgN = 0;
  function setDebug(on) { debug = !!on; }
  function dbg(tag, ...a) {
    if (!debug) return;
    const msg = '[apex_phone:' + tag + '] ' + a.map(x => { try { return typeof x === 'object' ? JSON.stringify(x) : String(x); } catch (e) { return String(x); } }).join(' ');
    try { console.log(msg); } catch (e) {}
    if (inFiveM && dbgN++ < 400) { try { call('jsError', { msg: ('[debug] ' + msg).slice(0, 700) }); } catch (e) {} }
  }

  window.addEventListener('message', e => {
    const m = e.data || {}; if (!m.action) return;
    if (m.action === 'push') emit(m.event, m.data); else emit(m.action, m);
  });

  /* No jogo não há DevTools à mão: erros de JS (e console.error) vão para a consola F8 via NUI callback 'jsError' (client/main.lua), com limite */
  if (inFiveM) {
    let n = 0; const send = msg => { if (n++ > 40) return; try { call('jsError', { msg: String(msg).slice(0, 700) }); } catch (e) {} };
    /* "ResizeObserver loop limit exceeded / completed with undelivered notifications" e um AVISO do Chromium (as entregas
       passam para o frame seguinte), nao um erro da pagina: nao vai para a consola do jogo (2026-10-01).
       26 out: o preventDefault e que o tira da F8 - sem ele o Chromium escrevia-o na consola na mesma ("ResizeObserver loop
       limit exceeded (@apex_phone/html/index.html:0)" em rajadas, visto na F8 de um cliente); o stopImmediatePropagation so
       impedia o nosso proprio envio. */
    const BENIGN = /ResizeObserver loop (limit exceeded|completed with undelivered notifications)/i;
    window.addEventListener('error', e => { if (BENIGN.test(String(e.message || ''))) { e.preventDefault(); e.stopImmediatePropagation && e.stopImmediatePropagation(); return; } send(`${e.message} @ ${String(e.filename || '').split('/').pop()}:${e.lineno}:${e.colno}`); });
    window.addEventListener('unhandledrejection', e => send('rejection: ' + (e.reason && (e.reason.stack || e.reason.message) || e.reason)));
    const ce = console.error.bind(console); console.error = (...a) => { ce(...a); send(a.map(x => (x && x.stack) || (typeof x === 'object' ? JSON.stringify(x) : String(x))).join(' ')); };
  }

  return { inFiveM, res, on, off, emit, call, callT, rpc, rpcRaw, request, normalize, setDebug, dbg, get debug() { return debug; } };
})();
