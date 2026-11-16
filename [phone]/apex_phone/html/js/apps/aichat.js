/* ===================== VERA CHAT - assistente de IA (Gemini no servidor: server/ai.lua) =====================
   Pergunta → RPC ai.ask { id, text, history, hour } → { ok } já; a resposta chega depois por push 'ai:reply'
   (o Gemini pode passar dos 10 s de um RPC). A conversa fica guardada neste telemóvel (Store 'aichat', por
   personagem, máx. 60 mensagens) e as últimas vão como contexto. A chave e as regras de âmbito vivem no servidor. */
App.define('aichat', {
  name: 'Vera Chat', core: true, category: 'Utilidades',
  description: 'Assistente com IA: dúvidas sobre o servidor e o telemóvel, contas, tempo e mais.',
  open(win) {
    const g = UI.g, esc = UI.esc;
    const cfg = () => (window.System && System.config && System.config.ai) || {};
    const title = () => String(cfg().name || 'Vera Chat').slice(0, 30);
    const KEY = 'aichat', MAX_KEEP = 60;
    let msgs = (() => { const l = Store.get(KEY, []); return Array.isArray(l) ? l.filter(m => m && (m.role === 'user' || m.role === 'model') && typeof m.text === 'string').slice(-MAX_KEEP) : []; })();
    let pending = null, seq = Date.now() % 1e9;
    const save = () => Store.set(KEY, msgs.slice(-MAX_KEEP));

    /* NOVA UI (Android): a mesma conversa, o mesmo RPC e a mesma memória; o desenho é o de um assistente de IA da Nova UI
       (o gradiente ciano/verde só onde é a IA: orbe, ícone das respostas e anel do campo enquanto pensa) */
    const A = !!(System.isAndroid && System.isAndroid());
    const v = UI.view({ title: title(), cls: A ? 'aai-v' : 'aic', right: [{ icon: 'trash', onTap: async () => { if (!msgs.length) return; if (await UI.confirm('Apagar conversa', 'As mensagens desta conversa saem deste telemóvel.', 'Apagar', true)) { msgs = []; save(); paint(); } } }] });
    const list = v.content; list.classList.add(A ? 'aai-list' : 'aic-list');
    const bar = A ? UI.el(`<div class="aai-bar"><div class="aai-field"><input type="text" class="aai-in" maxlength="600" enterkeyhint="send" placeholder="Pergunta qualquer coisa à Vera"></div><div class="aai-send">${g('send', 20)}</div></div>`)
      : UI.el(`<div class="aic-bar"><input type="text" class="aic-in" maxlength="600" enterkeyhint="send" placeholder="Pergunta qualquer coisa…"><div class="aic-send">${g('arrowUp', 20)}</div></div>`);
    v.appendChild(bar);
    const inp = bar.querySelector(A ? '.aai-in' : '.aic-in'), send = bar.querySelector(A ? '.aai-send' : '.aic-send');
    const SUGG = ['Como peço um táxi?', 'Quanto é 15% de 240?', 'Que tempo está na cidade?', A ? 'Como funciona a Partilha rápida?' : 'Como funciona o AirShare?'];
    const ORB = '<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9z"/><path d="M19 15l.8 2.2L22 18l-2.2.8L19 21l-.8-2.2L16 18l2.2-.8z"/></svg>';

    const bubble = m => { if (A) { const b = UI.el(`<div class="aai-msg ${m.role === 'user' ? 'me' : 'ai'}${m.err ? ' err' : ''}">${m.role === 'user' ? '' : `<div class="aai-av">${ORB}</div>`}<div class="aai-b"></div></div>`); b.querySelector('.aai-b').textContent = m.text; return b; }
      const b = UI.el(`<div class="aic-msg ${m.role === 'user' ? 'me' : 'ai'}${m.err ? ' err' : ''}"><div class="aic-b"></div></div>`); b.querySelector('.aic-b').textContent = m.text; return b; };
    function paint() {
      if (A) return paintA();
      list.innerHTML = '';
      if (cfg().enabled === false) { list.appendChild(UI.empty('sparkles', 'Assistente desligada', 'O dono do servidor desligou o ' + title() + '.')); bar.classList.add('hidden'); return; }
      if (!msgs.length) {
        const hero = UI.el(`<div class="aic-hero"><div class="aic-orb">${g('sparkles', 34)}</div><b></b><span>Pergunta sobre o servidor, o telemóvel, contas ou o tempo. Não ajudo com nada ilegal.</span><div class="aic-sugg"></div></div>`);
        hero.querySelector('b').textContent = 'Olá! Sou a ' + title() + '.';
        SUGG.forEach(s => { const c = UI.el('<div class="aic-chip"></div>'); c.textContent = s; c.onclick = () => ask(s); hero.querySelector('.aic-sugg').appendChild(c); });
        list.appendChild(hero);
      } else msgs.forEach(m => list.appendChild(bubble(m)));
      if (pending) list.appendChild(UI.el('<div class="aic-msg ai typing"><div class="aic-b"><i></i><i></i><i></i></div></div>'));
      send.classList.toggle('dis', !!pending);
      requestAnimationFrame(() => { list.scrollTop = list.scrollHeight; });
    }
    function paintA() {
      list.innerHTML = '';
      if (cfg().enabled === false) { const o = UI.el('<div class="aai-off"><b>Assistente desligada</b><span></span></div>'); o.querySelector('span').textContent = 'O dono do servidor desligou o ' + title() + '.'; list.appendChild(o); bar.classList.add('hidden'); return; }
      if (!msgs.length) {
        const hero = UI.el(`<div class="aai-hero"><div class="aai-orb">${ORB}</div><b></b><span>Pergunta sobre o servidor, o telemóvel, contas ou o tempo. Não ajudo com nada ilegal.</span><div class="aai-sugg"></div></div>`);
        hero.querySelector('b').textContent = 'Olá! Sou a ' + title() + '.';
        SUGG.forEach(s => { const c = UI.el(`<div class="aai-chip">${g('sparkles', 16)}<span></span></div>`); c.querySelector('span').textContent = s; c.onclick = () => ask(s); hero.querySelector('.aai-sugg').appendChild(c); });
        list.appendChild(hero);
      } else msgs.forEach(m => list.appendChild(bubble(m)));
      if (pending) list.appendChild(UI.el(`<div class="aai-msg ai typing"><div class="aai-av">${ORB}</div><div class="aai-b"><i></i><i></i><i></i></div></div>`));
      send.classList.toggle('dis', !!pending); bar.classList.toggle('busy', !!pending);
      requestAnimationFrame(() => { list.scrollTop = list.scrollHeight; });
    }

    async function ask(text) {
      text = String(text || '').trim().slice(0, 600); if (!text || pending) return;
      if (window.CC && CC.requireNet && !CC.requireNet('o ' + title())) return;
      const history = msgs.filter(m => !m.err).slice(-12).map(m => ({ role: m.role, text: m.text }));
      msgs.push({ role: 'user', text }); save(); inp.value = '';
      const id = ++seq; pending = { id, t: setTimeout(() => done({ id, error: 'timeout' }), 45000) };
      paint(); Sound.play('click');
      /* lang: a IA responde no idioma do telemóvel (server/ai.lua põe-no nas instruções do Gemini) */
      let r = null; try { r = await Bridge.rpcRaw('ai.ask', { id, text, history, hour: System.gameHour, lang: window.L ? L.code : 'pt' }); } catch (e) { r = null; }
      if (!r || r.error) done({ id, error: (r && r.error) || 'rpc' });
    }
    /* Os erros chegam como CÓDIGOS (do RPC ou do push 'ai:reply'). As bolhas da Vera Chat estão fora do tradutor do DOM
       (são conversa: .aic-b / .aai-b em I18N.USER_CONTENT), por isso o texto do erro é traduzido aqui com o L.t , 
       antes o servidor mandava o erro em português e ficava em português em qualquer idioma. */
    const E = { cooldown: 'Espera uns segundos antes de perguntar outra vez.', limit: 'Chegaste ao limite de perguntas desta hora.', busy: 'Ainda estou a responder à anterior.', disabled: 'A assistente está desligada neste servidor.', nokey: 'A assistente não está configurada no servidor.', ratelimit: 'Demasiados pedidos. Espera um pouco.',
      blocked: 'Não posso ajudar com isso. Pergunta-me sobre o servidor, contas, o tempo ou o telemóvel.', key: 'A assistente não está configurada no servidor.', nomodel: 'A assistente não está disponível neste momento.', timeout: 'A resposta está a demorar demasiado. Tenta outra vez.', rpc: 'Não consegui falar com o servidor.', http: 'Não consegui responder agora. Tenta outra vez.' };
    const tr = s => (window.L && L.t ? L.t(s) : s);
    function done(d) {
      if (!pending || +d.id !== pending.id) return;
      clearTimeout(pending.t); pending = null;
      const text = d.error ? tr(E[d.error] || d.text || E.http) : d.text;
      msgs.push({ role: 'model', text: String(text || '').slice(0, 4000) || '…', err: !!d.error }); save(); paint();
      if (!d.error) Sound.play('message');
    }
    const off = Bridge.on('ai:reply', d => { if (d && typeof d === 'object') done(d); });
    inp.onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); ask(inp.value); } };
    send.onclick = () => ask(inp.value);
    const prevClose = win.onClose; win.onClose = () => { off(); if (pending) clearTimeout(pending.t); if (prevClose) prevClose(); };
    UI.setRoot(win, v); paint();
  }
});

/* browser (harness): sem servidor, responde a demonstração - contas simples a sério, o resto diz que é demo */
if (window.LocalDB && LocalDB.register) LocalDB.register('ai.ask', d => {
  const q = String(d.text || '');
  let text = 'Modo de demonstração (browser): no jogo esta resposta vem da IA do servidor.';
  const m = q.replace(',', '.').match(/(\d+(?:\.\d+)?)\s*%\s*de\s*(\d+(?:\.\d+)?)/i);
  if (m) text = `${m[1]}% de ${m[2]} = ${+(m[1] * m[2] / 100).toFixed(2)}`;
  if (/ilegal|droga|arma|hack/i.test(q)) text = 'Não posso ajudar com isso. Pergunta-me sobre o servidor, contas, o tempo ou o telemóvel.';
  setTimeout(() => Bridge.emit('ai:reply', { id: d.id, text }), 500);
  return { ok: true, id: d.id };
});
