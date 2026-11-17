/* ============================================================
   STORE - persistência (localStorage) + ponte NUI para o FiveM
   ------------------------------------------------------------
   Chaves por PERSONAGEM: depois de Store.setNamespace(citizenid) tudo
   o que se lê/escreve fica em `apexphone:<cid>:<chave>`. Antes disso
   (browser sem conta, arranque) usa-se o prefixo antigo `apexphone:`.
   Store.global.* lê/escreve SEMPRE no prefixo raiz - é onde o mock do
   servidor (localdb.js) guarda a "base de dados", que no jogo é
   partilhada por todas as personagens e não pertence a nenhuma.
   ============================================================ */
window.Store = (() => {
  const ROOT = 'apexphone:';
  const META_NS = ROOT + '__ns';          /* lista de citizenids que já tiveram namespace neste PC */
  const META_LAST = ROOT + '__last';      /* última personagem ativa (reaplicada ao carregar a página) */
  const META_LEGACY = ROOT + '__legacy';  /* quem recebeu a cópia única das chaves antigas */
  /* chaves da raiz que são do MOCK DO SERVIDOR (browser): nunca se copiam para uma personagem */
  const SERVER_KEY = /^(db:|account$|account:|mock:)/;
  const cache = {};
  let ns = null, PREFIX = ROOT;

  const safeCid = cid => String(cid == null ? '' : cid).replace(/[^A-Za-z0-9_-]/g, '').slice(0, 64);
  const readJSON = (k, def) => { try { const raw = localStorage.getItem(k); return raw === null ? def : JSON.parse(raw); } catch (e) { return def; } };
  /* a personagem da última sessão volta logo ao carregar: o System lê as definições no arranque do
     módulo, antes de haver conta, e sem isto pintava o tema/fundo da chave antiga até chegar a conta */
  try { const last = safeCid(localStorage.getItem(META_LAST)); if (last) { ns = last; PREFIX = ROOT + last + ':'; } } catch (e) {}

  // Só guarda em cache valores que existem de facto no storage -
  // o default nunca é cacheado (senão um get(key, null) prematuro "envenena" a chave).
  function get(key, def) {
    if (key in cache) return cache[key];
    try {
      const raw = localStorage.getItem(PREFIX + key);
      if (raw === null) return def;
      cache[key] = JSON.parse(raw);
      return cache[key];
    } catch (e) { return def; }
  }
  function set(key, val) {
    cache[key] = val;
    try { localStorage.setItem(PREFIX + key, JSON.stringify(val)); } catch (e) {}
    if (SYNC.has(key) && !applying) queueSync(key);
    return val;
  }

  /* ---- SINCRONIZAÇÃO COM O SERVIDOR (server/userdata.lua) ----
     Estas chaves viviam SÓ no localStorage do CEF: mudar de PC, limpar a cache do FiveM ou "Apagar todo o
     conteúdo" perdia notas, alarmes, lembretes, eventos, relógios, lugares e recordes. Agora cada escrita numa
     chave desta lista vai para a base de dados (RPC userdata.set, 800 ms depois da última alteração dessa
     chave; o que estiver pendente sai ao guardar o telemóvel) e, ao entrar, `pull()` lê tudo de lá:
       · o servidor manda - o que lá estiver substitui o local (é o mesmo jogador noutro PC, ou a cache limpa);
       · o que só existir aqui (instalação de antes da sincronização) sobe uma vez e fica a valer.
     O valor viaja como JSON já serializado, para os `null` dos arrays sobreviverem ao Lua. Quem quiser saber
     que uma chave mudou por fora ouve `Bridge.on('store:sync', { keys })`. `pull()` só faz sentido com uma
     personagem (namespace) e no jogo; no browser o localdb.js responde ao mesmo RPC. */
  const SYNC = new Set(['notes', 'reminders', 'events', 'alarms', 'cities', 'places', 'arcade', 'arcadeOpt', 'arcadeStats', 'usage']);
  const syncT = {}; let applying = false, warnedBig = 0;
  const rpc = (name, data) => (window.Bridge && Bridge.rpcRaw) ? Promise.resolve(Bridge.rpcRaw(name, data)).catch(() => null) : Promise.resolve(null);
  function pushKey(key) {
    clearTimeout(syncT[key]); delete syncT[key];
    if (!ns) return Promise.resolve(null);
    let v = null; try { const raw = localStorage.getItem(PREFIX + key); v = raw === null ? (key in cache ? JSON.stringify(cache[key]) : null) : raw; } catch (e) { try { v = key in cache ? JSON.stringify(cache[key]) : null; } catch (e2) { v = null; } }
    /* um evento de rede do FiveM acima de ~260 KB é descartado sem resposta: não vale a pena mandar, e o jogador tem de saber */
    if (v && v.length > 240000) { if (Date.now() - warnedBig > 60000) { warnedBig = Date.now(); try { window.UI && UI.toast('Não gravado no servidor: ' + key + ' é grande demais'); } catch (e) {} } return Promise.resolve({ error: 'toolarge' }); }
    return rpc('userdata.set', { k: key, v }).then(r => {
      if (r && r.error === 'toolarge' && Date.now() - warnedBig > 60000) { warnedBig = Date.now(); try { window.UI && UI.toast('Não gravado no servidor: ' + key + ' é grande demais'); } catch (e) {} }
      return r;
    });
  }
  function queueSync(key) { if (!ns) return; clearTimeout(syncT[key]); syncT[key] = setTimeout(() => pushKey(key), 800); }
  /* despeja o que estiver à espera (guardar o telemóvel, sair da página) */
  function flush() { Object.keys(syncT).forEach(k => pushKey(k)); }
  addEventListener('pagehide', flush); addEventListener('beforeunload', flush);
  /* lê do servidor e aplica; devolve as chaves que mudaram localmente */
  async function pull() {
    if (!ns) return [];
    const r = await rpc('userdata.get');
    if (!r || r.error || !r.items || typeof r.items !== 'object') return [];
    const changed = [];
    applying = true;
    try {
      SYNC.forEach(key => {
        if (syncT[key]) return;   /* o jogador já mexeu nesta chave enquanto a leitura vinha: o que ele escreveu é que sobe */
        const remote = r.items[key];
        let local = null; try { local = localStorage.getItem(PREFIX + key); } catch (e) {}
        if (typeof remote === 'string') {
          if (remote !== local) { try { const v = JSON.parse(remote); delete cache[key]; set(key, v); changed.push(key); } catch (e) {} }
        } else if (local !== null) queueSync(key);   /* só existe aqui: sobe */
      });
    } finally { applying = false; }
    if (changed.length) { try { window.Bridge && Bridge.emit('store:sync', { keys: changed }); } catch (e) {} }
    return changed;
  }
  function update(key, def, fn) { const v = get(key, def); fn(v); return set(key, v); }
  function remove(key) { delete cache[key]; try { localStorage.removeItem(PREFIX + key); } catch (e) {} if (SYNC.has(key) && !applying) queueSync(key); }

  /* ---- raiz (sem personagem): mock do servidor no browser ---- */
  const gcache = {};
  const global = {
    get(key, def) { if (key in gcache) return gcache[key]; try { const raw = localStorage.getItem(ROOT + key); if (raw === null) return def; gcache[key] = JSON.parse(raw); return gcache[key]; } catch (e) { return def; } },
    set(key, val) { gcache[key] = val; try { localStorage.setItem(ROOT + key, JSON.stringify(val)); } catch (e) {} return val; },
    update(key, def, fn) { const v = global.get(key, def); fn(v); return global.set(key, v); },
    remove(key) { delete gcache[key]; try { localStorage.removeItem(ROOT + key); } catch (e) {} }
  };

  const knownNs = () => { const l = readJSON(META_NS, []); return Array.isArray(l) ? l : []; };
  /* chave antiga = raiz sem personagem, sem metadados e sem dados do mock do servidor */
  function legacyKeys(list) {
    const out = [];
    try { Object.keys(localStorage).forEach(k => { if (!k.startsWith(ROOT)) return; const rest = k.slice(ROOT.length);
      if (!rest || rest.startsWith('__') || SERVER_KEY.test(rest) || list.some(n => rest.startsWith(n + ':'))) return; out.push(rest); }); } catch (e) {}
    return out;
  }
  /* CÓPIA ÚNICA das chaves antigas (notas, alarmes, notificações, definições…) para a primeira
     personagem. Se a chave antiga `player` diz de quem eram, só essa personagem as recebe - assim
     uma personagem nova no mesmo PC não herda as notas da outra. As antigas ficam onde estão
     (volta atrás possível); só se o armazenamento estiver cheio é que a cópia passa a MOVER. */
  function migrate(cid, list) {
    if (localStorage.getItem(META_LEGACY)) return;
    const owner = safeCid((readJSON(ROOT + 'player', null) || {}).citizenid);
    if (owner && owner !== cid) return;
    legacyKeys(list).forEach(rest => { const v = localStorage.getItem(ROOT + rest); if (v === null || localStorage.getItem(ROOT + cid + ':' + rest) !== null) return;
      try { localStorage.setItem(ROOT + cid + ':' + rest, v); } catch (e) { try { localStorage.removeItem(ROOT + rest); localStorage.setItem(ROOT + cid + ':' + rest, v); } catch (e2) {} } });
    try { localStorage.setItem(META_LEGACY, cid); } catch (e) {}
  }
  /* muda a personagem ativa; devolve true se mudou (quem chama tem de voltar a ler o que tinha em memória) */
  function setNamespace(cid) {
    const c = safeCid(cid); if (!c) return false;
    const list = knownNs(); if (!list.includes(c)) { list.push(c); try { localStorage.setItem(META_NS, JSON.stringify(list)); } catch (e) {} }
    try { migrate(c, list); } catch (e) {}
    try { localStorage.setItem(META_LAST, c); } catch (e) {}
    if (c === ns) return false;
    Object.keys(cache).forEach(k => delete cache[k]);   /* o cache era da personagem anterior */
    ns = c; PREFIX = ROOT + c + ':';
    return true;
  }
  /* apaga as chaves da personagem ativa (reposição de fábrica). Sem personagem mantém o
     comportamento antigo: tudo o que está na raiz, exceto os metadados. */
  function clear() {
    Object.keys(cache).forEach(k => delete cache[k]);
    try { const list = knownNs(); Object.keys(localStorage).forEach(k => {
      if (ns) { if (k.startsWith(PREFIX)) localStorage.removeItem(k); return; }
      if (!k.startsWith(ROOT)) return; const rest = k.slice(ROOT.length); if (rest.startsWith('__') || list.some(n => rest.startsWith(n + ':'))) return;
      localStorage.removeItem(k); if (rest in gcache) delete gcache[rest]; }); } catch (e) {}
  }
  /* a lista de personagens lê-se UMA vez (antes era um JSON.parse por cada chave do localStorage) */
  function keys() { const out = []; try { const list = ns ? [] : knownNs(); Object.keys(localStorage).forEach(k => { if (!k.startsWith(PREFIX)) return; const rest = k.slice(PREFIX.length); if (!ns && (rest.startsWith('__') || list.some(n => rest.startsWith(n + ':')))) return; out.push(rest); }); } catch (e) {} return out; }

  /* ---- FiveM ---- */
  const inFiveM = typeof window.GetParentResourceName === 'function';
  const resName = inFiveM ? window.GetParentResourceName() : 'apex_phone';

  // POST para o client.lua (NUI callback). No browser resolve com null.
  function nui(name, data) {
    if (!inFiveM) return Promise.resolve(null);
    return fetch(`https://${resName}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data || {})
    }).then(r => r.json()).catch(() => null);
  }

  return { get, set, update, remove, nui, inFiveM, global, setNamespace, clear, keys, pull, flush, SYNC, get namespace() { return ns; } };
})();
