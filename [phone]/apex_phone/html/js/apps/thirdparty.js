/* ===================== APPS DE TERCEIROS - registadas por outros resources (iframe nui://) =====================
   exports['apex_phone']:RegisterApp({ id, name, icon = 'nui://res/icon.png' | {label,color}, url = 'nui://res/html/index.html',
     category, description, defaultInstalled, notifications, job = 'police', minGrade = 2 })
     · id só com letras, números, _ - . : (até 64), o mesmo filtro do servidor; outro id é RECUSADO
     · job/jobs + minGrade (opcionais): o ícone só aparece a quem tem esse emprego. O minGrade só é
       avaliado se o telemóvel receber o NÚMERO do escalão (player.job.gradeLevel) - ver jobOk abaixo
   Dentro da app (iframe): window.parent.postMessage({ apexphone:'notify', title, msg }, '*')
     apexphone: 'close' | 'openApp' {id} | 'setWaypoint' {x,y} | 'rpc' {name,data,id} → resposta {apexphone:'rpc', id, result}
     'getContacts' → {apexphone:'contacts', list} · 'getPlayer' → {apexphone:'player', player} · 'toast' {msg}
     'activity' { op:'start'|'update'|'stop', id, title, subtitle, icon, progress 0..1, eta, state }
       - atividade ao vivo na Dynamic Island (também em window.RKPhone.startActivity/updateActivity/stopActivity)
     'typing' { on } (1.2.0) - um campo de texto da app tem/perdeu o foco: o jogo deixa de receber o teclado só nesses
       momentos. Sem esta mensagem o teclado é todo da app enquanto o iframe tiver o foco (ver wantsTyping).
     Contactos, fotos, localização, banco e messages.send pedem autorização ao jogador na 1.ª vez; recusado → {error:'denied'}.
     Os RPCs de um iframe vão marcados com data.__ext = <id da app>: o servidor só aceita os da lista (Config.ExternalApps)
     e os sensíveis só com a autorização GRAVADA LÁ (apps.grant, escrito aqui depois de o jogador responder) → {error:'nogrant'}.
     O player (init/getPlayer/player.get) só leva money depois de o jogador autorizar "Banco" (pedido pelo bank.info).
     'widget' {id, name, size|sizes, template: 'stat'|'list'|'progress'|'text', data: {title, value, unit, sub, items, text, label, color, icon}}
       - só texto/estrutura; um html antigo é reduzido a texto (template 'text').
   A app recebe {apexphone:'init', theme, accent, dark, player, account} ao abrir e {apexphone:'theme'} quando muda.
   ---- SDK 1.5.0 (sdk/apexphone-sdk.js do lado da página, server/sdk.lua do lado do servidor, docs/SDK.md) ----
     'ready'                      → o telemóvel volta a mandar o 'init' (a página carregou o SDK depois do onload)
     'appcall' { name, data, id } → RPC app.call para os handlers do PRÓPRIO recurso do comprador (RegisterAppRPC); 'call' é ligar
                                    → resposta {apexphone:'rpc', id, result: { ok, result } | { error }}
     'kv' { op:'get'|'set'|'remove'|'keys', k, v, id } → RPC app.kv.* (KV por app e personagem no servidor) → {apexphone:'rpc', id, result}
     'setBadge' { n }             → emblema no ícone da app (System.badge; respeita as definições de notificações da app)
     'haptic' { kind }            → som curto de toque · 'sound' { name } → Sound.play de uma lista (click, tap, success, error, notify, pop, send, lock, unlock)
     'keyboard' { on, value, type, hint, maxLength, noCap } → teclado do telemóvel para um campo DENTRO do iframe (ver extKeyboard)
                                    → {apexphone:'keyboard', shown, height} · {value} a cada tecla · {enter:true, value} · {hidden:true}
     'openURL' { url }            → só phone://app/caminho (System.openURL)
     init/theme levam também lang e glassTint; {apexphone:'lang', lang} quando o idioma muda;
     Push do servidor 'app:event' { app, event, data } (export PushToApp) → {apexphone:'event', name, data} no iframe;
     Push 'app:badge' { app, n } (export SetAppBadge) → emblema.
   ============================================================================================================ */
window.ThirdParty = (() => {
  const frames = {}, sigs = {}, defs = {};
  /* O servidor só aceita pedidos de uma app externa com um id simples (letras, números, _ - . : e até 64 -
     extAppId no server/main.lua). Esse id entra TAMBÉM em atributos (data-id, data-app) e dentro de
     seletores (tileOf e badge no system.js, home.js, switcher.js): com aspas ou "]" partia o HTML do ícone
     e fazia o querySelectorAll atirar SyntaxError a meio da passagem dos emblemas. Antes só se avisava na
     consola e registava-se; agora recusa-se, com o motivo na consola de quem a regista. */
  const ID_OK = /^[\w.:-]{1,64}$/;
  /* def.job (ou def.jobs = {...}) e def.minGrade: a app só aparece a quem tem esse emprego. O servidor
     difunde o registerApp só a esses jogadores (server/exports.lua), mas o apps.registry entrega o registo
     todo a quem entra - por isso o telemóvel também verifica. Não é autorização (essa é do servidor, nos
     grants dos rpc): é quem VÊ o ícone. */
  /* ⚠️ O `job.grade` que chega à NUI é o NOME do escalão ('boss', 'Recruta'…): quem o normaliza
     (client/framework.lua:103-117, server/framework.lua:59-63) põe o NÚMERO em `gradeLevel`, e os dois
     BuildPlayer (client/main.lua:137 e server/main.lua:719) não o mandam - ver `pedidosCruzados`.
     Com Number('boss') = NaN, um minGrade escondia a app de TODA a gente com esse emprego, chefes
     incluídos: uma restrição que restringe o que não devia. Por isso: nível conhecido → compara-se;
     nível desconhecido → o minGrade NÃO se aplica (o filtro do emprego fica de pé) e diz-se porquê na
     consola, em vez de fingir um escalão que não se sabe ler. A autorização continua a ser a do
     servidor (os grants dos rpc): isto é só quem VÊ o ícone. */
  const gradeOf = j => { for (const v of [j.gradeLevel, j.grade]) { if (v === null || v === undefined || v === '') continue; const n = Number(v); if (isFinite(n)) return n; } return null; };
  let warnedGrade = false;
  function jobOk(def) {
    const want = typeof def.job === 'string' ? [def.job] : (Array.isArray(def.jobs) ? def.jobs.filter(x => typeof x === 'string') : []);
    if (!want.length) return true;
    const j = (System.player && System.player.job) || {};
    if (!want.includes(String(j.name || ''))) return false;
    const min = Number(def.minGrade);
    if (!isFinite(min)) return true;
    const lv = gradeOf(j);
    if (lv === null) { if (!warnedGrade) { warnedGrade = true; console.warn('[apex_phone] minGrade não aplicado: o telemóvel só recebe o NOME do escalão ("' + String(j.grade) + '"), não o número (player.job.gradeLevel). O filtro do emprego continua a valer.'); } return true; }
    return lv >= min;
  }
  function register(def) {
    if (!def || !def.id || !def.url) return;
    const id = String(def.id);
    if (!ID_OK.test(id)) { console.warn('[apex_phone] app externa "' + id.slice(0, 80) + '" RECUSADA: o id só pode ter letras, números, _ - . : (até 64), o mesmo filtro que o servidor exige nos rpc'); return; }
    defs[id] = def;
    if (!jobOk(def)) { if (App.get(id)) unregister(id); return; }
    /* o mesmo registo outra vez (arranque: registo por RPC + reenvio do Lua 600 ms depois; resources que repetem RegisterApp): ignora-se por completo -
       sem App.define, sem 'apps:changed', sem re-render da home */
    const s = JSON.stringify([def.name, def.icon, def.color, def.url, def.category, def.description, def.author, def.defaultInstalled, def.statusBar, def.media, def.shots]); const cur = App.get(id);
    if (sigs[id] === s && cur && !cur.hidden) return; sigs[id] = s;
    /* media (URL nui:// ou https) = imagem do cartão na AppShop; shots = capturas (array de URLs).
       O `icon` é filtrado no Icons.custom (SVG por lista branca, URL só nui/http/data:image): vem de outro
       resource e é injetado por innerHTML no documento do telemóvel. */
    App.define(id, { name: def.name || id, icon: def.icon || { label: (def.name || id).slice(0, 2), color: def.color || '#0A84FF' }, category: def.category || 'Terceiros', description: def.description, author: def.author, external: true, hidden: false, url: def.url, defaultInstalled: def.defaultInstalled !== false, statusBar: def.statusBar || 'auto', media: typeof def.media === 'string' ? def.media : undefined, shots: Array.isArray(def.shots) ? def.shots : undefined,
      /* 1.1.8: def.wide = a app dispõe-se em largura (no dobrável leva a zona do conteúdo toda em vez dos 440 px ao centro,
         apps.css .ext-wide). O 'init' leva o tamanho real do iframe (px CSS: a escala do telemóvel é um transform e não muda
         isto), o formato e o estado da dobra; 'size' avisa quando mudam (ver geometry abaixo). */
      open(win) { if (def.wide === true) win.classList.add('ext-wide'); const f = UI.el(`<iframe src="${UI.esc(safeUrl(def.url))}" sandbox="allow-scripts allow-same-origin allow-forms"></iframe>`); win.querySelector('.nav-stack').appendChild(f); frames[id] = f; f.onload = () => send(f, initMsg(id, f)); win.onClose = () => { delete frames[id]; delete typingAware[id]; delete typingWant[id]; delete kbProxy[id]; Bridge.emit('ext:typing'); }; },
      resume(win) { const f = frames[id]; if (f) send(f, { apexphone: 'resume' }); }, pause(win) { const f = frames[id]; if (f) send(f, { apexphone: 'pause' }); } });
    if (System.ready) Bridge.emit('apps:changed');
  }
  function unregister(id) { const d = App.get(id); if (!d || !d.external) return; System.killApp(id); d.hidden = true; delete sigs[id];
    /* o widget que esta app registou ficava no registo, na home (com os últimos dados) e no seletor de
       widgets - e tocar nele tentava abrir uma app morta. Sai com ela; a célula da home degrada-se para o
       nome gravado (home.js / widgets.js). */
    try { if (window.Widgets) Widgets.list().forEach(w => { if (w && w.external && w.app === id) Widgets.unregister(w.id); }); } catch (e) { console.error('[apex_phone] widgets de ' + id, e); }
    try { dropActs(id); } catch (e) { console.error('[apex_phone] atividades de ' + id, e); }
    if (window.Home) Home.removeApp(id); Bridge.emit('apps:changed'); }
  /* o emprego do jogador mudou: uma app com def.job aparece ou desaparece sem ser preciso reentrar */
  let lastJob = null;
  Bridge.on('player:update', p => {
    const j = p && p.job ? String(p.job.name) + '|' + String(p.job.grade) + '|' + String(p.job.gradeLevel) : '';
    if (j === lastJob) return; lastJob = j;
    Object.keys(defs).forEach(id => { try { register(defs[id]); } catch (e) { console.error('[apex_phone] app externa ' + id, e); } });
  });
  const send = (f, msg) => { try { f.contentWindow.postMessage(msg, '*'); } catch (e) {} };
  const broadcast = msg => Object.values(frames).forEach(f => send(f, msg));
  /* ---------- teclado dentro de uma app externa (1.2.0) ----------
     O iframe é de outra origem (nui://<resource do comprador>): o telemóvel não vê os campos de texto lá dentro, e com o jogo a
     receber o teclado (Config.AllowWalking / KeepVoice) cada letra escrita na app ia TAMBÉM para os key mappings do jogo. Duas vias:
       · por omissão, enquanto o iframe tiver o foco o telemóvel diz ao Lua "a escrever" (system.js editable → wantsTyping):
         teclado só para a app; andar volta assim que se toca fora dela ou se fecha;
       · a app pode mandar window.parent.postMessage({ apexphone:'typing', on:true|false }, '*') nos focusin/focusout dos seus
         campos: a partir da primeira mensagem o telemóvel confia nela e só bloqueia o teclado quando ela o pedir (fica a
         andar-se com a app aberta). O estado esquece-se quando a app fecha (window do iframe destruída). */
  const typingAware = {}, typingWant = {};
  function wantsTyping(el) {
    const id = Object.keys(frames).find(k => frames[k] === el);
    if (!id) return false;
    return typingAware[id] ? !!typingWant[id] : true;
  }
  /* tamanho do contentor da app em px CSS (o que a app vê em window.innerWidth/Height), formato e dobra */
  const geometry = f => ({ screen: { w: f ? f.clientWidth : 440, h: f ? f.clientHeight : 956 }, form: System.form, foldOpen: !!System.foldOpen, os: System.os, model: System.deviceModel || null });
  /* o 'init' inteiro (abrir a janela, e outra vez quando a página pede 'ready'); 1.5.0: também lang e glassTint */
  const themeBits = () => ({ theme: System.state.theme, dark: System.state.dark, accent: System.state.accent, lang: System.state.lang || 'pt', glassTint: System.state.glassTint == null ? 50 : System.state.glassTint });
  const initMsg = (id, f) => Object.assign({ apexphone: 'init', player: playerFor(id, System.player), account: System.account && { username: System.account.username, phone: System.account.phone, avatar: System.account.avatar }, app: id }, themeBits(), geometry(f));
  const sendSizes = () => requestAnimationFrame(() => Object.values(frames).forEach(f => send(f, Object.assign({ apexphone: 'size' }, geometry(f)))));
  Bridge.on('fold:state', sendSizes); Bridge.on('form:changed', sendSizes);
  const txt = (v, max) => String(v == null ? '' : v).slice(0, max);
  /* javascript:/data:/blob: no src do iframe correriam com a origem do telemóvel (allow-same-origin) e com acesso ao Bridge */
  /* o browser ignora tabs, quebras de linha e controlos dentro do esquema ("java\tscript:" é javascript:): tiram-se antes de testar */
  const safeUrl = u => /^(javascript|data|blob|vbscript|filesystem):/i.test(String(u || '').replace(/[\u0000-\u0020\u007f]/g, '')) ? 'about:blank' : String(u || '');

  /* ---------- consentimento do jogador ----------
     Uma app externa (iframe de outro resource) não lê contactos, fotos, localização ou banco nem envia
     mensagens em nome do jogador sem ele autorizar - antes bastava pedir. Na primeira vez aparece o pedido
     de permissão; a resposta fica em Perm (Definições > Privacidade). sms e bank já estão no Perm.KINDS;
     o diálogo próprio abaixo só serve um tipo que o Perm não conheça. Pedidos repetidos enquanto o diálogo está
     aberto partilham a mesma resposta (sem 10 alertas empilhados). */
  const RPC_KIND = { 'contacts.list': 'contacts', 'photos.list': 'photos', 'messages.send': 'sms', 'bank.info': 'bank' };
  const EXTRA_KINDS = { sms: ['Mensagens', 'Para enviar mensagens em teu nome.'], bank: ['Banco', 'Para ver o teu saldo e movimentos.'] };
  const asking = {}, veraCount = {};
  /* "Permitir uma vez" dos tipos extra: igual ao Perm - só em memória e só enquanto a app estiver viva */
  const onceExtra = new Set();
  Bridge.on('app:kill', id => [...onceExtra].forEach(k => { if (k.startsWith(id + ':')) onceExtra.delete(k); }));
  Bridge.on('session:changed', () => onceExtra.clear());
  function consent(app, kind) {
    const key = app + ':' + kind; if (asking[key]) return asking[key];
    const p = (async () => {
      if (!window.Perm) return false;
      if (Perm.KINDS && Perm.KINDS[kind]) return !!(await Perm.request(app, kind));
      if (onceExtra.has(key)) return true;
      const prev = Perm.get(app, kind);
      if (prev !== undefined) { if (!prev) UI.toast(`Sem acesso a ${(EXTRA_KINDS[kind] || [kind])[0]}. Ativa em Definições > Privacidade.`); return !!prev; }
      const [label, why] = EXTRA_KINDS[kind] || [kind, ''];
      const r = await UI.alert({ title: `"${App.name(app)}" gostaria de aceder a: ${label}`, msg: why, buttons: [{ label: 'Não permitir', value: 'deny' }, { label: 'Permitir uma vez', value: 'once' }, { label: 'Permitir', bold: true, value: true }] });
      const v = r && r.value;
      if (v === 'once') { onceExtra.add(key); return true; }
      /* guardar o telemóvel com o pedido aberto (UI.dismissAll → value false) não é "Não permitir": não se grava
         nada e volta a perguntar (antes ficava recusado para sempre) */
      if (v !== true && v !== 'deny') return false;
      Perm.set(app, kind, v === true); return v === true;
    })().catch(() => false).finally(() => { delete asking[key]; });
    return asking[key] = p;
  }
  /* ---------- autorização gravada no SERVIDOR ----------
     O consentimento acima vive no NUI (Perm, nas definições da conta). O servidor não confia nisso: um RPC sensível
     marcado com __ext só passa com uma linha em apex_phone_app_grants ("Permitir") ou uma concessão em memória
     ("Permitir uma vez", até o jogador sair). Depois de o jogador dizer que sim, grava-se aqui com apps.grant.
     `granted` = o que já se sabe que o servidor tem (app, perm e modo 'perm' | 'once'), para não repetir o apps.grant a cada pedido:
       - carrega-se do apps.grants no 'ready' (depois de o boot aplicar as definições da conta, onde está o Perm);
       - troca de personagem esquece tudo (o servidor também: as "uma vez" são do src e da personagem);
       - o Perm deixou de dizer true (Definições › Privacidade, ou recusado noutro pedido) → apps.revoke;
       - a app morreu → as "uma vez" dela saem também no servidor (o Perm esquece-as nesse momento). */
  const EXT_RPC = new Set(['contacts.list', 'photos.list', 'messages.send', 'bank.info', 'player.get', 'services.list']);
  const granted = new Set(); let grantSeq = 0;
  /* separador escrito como escape, como no permissions.js (era um carácter de controlo invisível no código: um editor que o
     apagasse partia as chaves letra a letra no split sem ninguém ver) */
  const gkey = (app, perm, mode) => app + '\u0001' + perm + '\u0001' + mode;
  async function ensureGrant(app, perm) {
    const mode = window.Perm && Perm.get(app, perm) === true ? 'perm' : 'once', k = gkey(app, perm, mode);
    if (granted.has(k)) return true;
    let r = null; try { r = await Bridge.rpcRaw('apps.grant', { app, perm, once: mode === 'once' }); } catch (e) {}
    if (r && r.ok) { granted.add(k); return true; }
    return false;
  }
  function reconcile() {
    if (!window.Perm) return;
    [...granted].forEach(k => { const [app, perm, mode] = k.split('\u0001');
      if (mode === 'perm' && Perm.get(app, perm) !== true) { granted.delete(k); Bridge.rpc('apps.revoke', { app, perm }); }
      /* "uma vez" que o Perm já esqueceu (Definições › Privacidade mudou esse tipo com a app ainda viva): antes só saía do
         servidor quando a app morria, e até lá o servidor continuava a aceitar o que o telemóvel já recusava */
      else if (mode === 'once' && !(Perm.isOnce && Perm.isOnce(app, perm)) && !onceExtra.has(app + ':' + perm)) { granted.delete(k); Bridge.rpc('apps.revoke', { app, perm, once: true }); }
    });
  }
  async function loadGrants() {
    const my = ++grantSeq; granted.clear();
    let r = null; try { r = await Bridge.rpcRaw('apps.grants', {}); } catch (e) {}
    if (my !== grantSeq || !r || typeof r !== 'object' || r.error) return;
    const items = Array.isArray(r.items) ? r.items : (r.items && typeof r.items === 'object' ? Object.values(r.items) : []);   /* tabela vazia do Lua = {} */
    items.forEach(it => { if (it && typeof it.app === 'string' && typeof it.perm === 'string') granted.add(gkey(it.app, it.perm, 'perm')); });
    reconcile();   /* uma autorização gravada que o Perm já não tem (revogada sem o servidor saber) sai agora */
  }
  /* adiado um ciclo: o Perm.set emite o 'state' ANTES de esquecer o "uma vez" desse tipo (permissions.js), e o reconcile
     síncrono ainda o via como válido */
  Bridge.on('state', p => { if (p && typeof p === 'object' && 'perms' in p) setTimeout(reconcile, 0); });
  Bridge.on('session:changed', () => { grantSeq++; granted.clear(); });
  /* reposição de fábrica: o servidor já apagou as autorizações desta personagem (ResetAccount); nada do que se sabia vale */
  Bridge.on('factory:reset', () => { grantSeq++; granted.clear(); });
  Bridge.on('app:kill', id => { let had = false; [...granted].forEach(k => { const [a, , m] = k.split('\u0001'); if (a === id && m === 'once') { granted.delete(k); had = true; } }); if (had) Bridge.rpc('apps.revoke', { app: id, once: true }); });
  /* Um RPC de app externa: lista branca, consentimento, autorização no servidor e só então o pedido, marcado com __ext.
     Serve os iframes (postMessage 'rpc') e o window.RKPhone.rpc. */
  async function extRpc(app, name, data) {
    if (typeof name !== 'string' || !EXT_RPC.has(name)) return { error: 'forbidden' };
    const kind = RPC_KIND[name];
    if (kind && !(await consent(app, kind))) return { error: 'denied' };
    if (kind && !(await ensureGrant(app, kind))) return { error: 'nogrant' };
    const body = name === 'messages.send' ? cleanMessage(data) : (data && typeof data === 'object' && !Array.isArray(data) ? Object.assign({}, data) : {});
    body.__ext = app;
    let result = await Bridge.rpc(name, body);
    if (name === 'player.get') result = playerFor(app, result);
    return result;
  }
  /* O jogador enviado ao iframe leva money (banco e dinheiro): sem a autorização "Banco" o saldo não sai -
     senão o pedido de acesso ao bank.info era só fachada (bastava ler player.money no init/getPlayer). */
  function playerFor(app, p) {
    if (!p || typeof p !== 'object') return p;
    /* "Permitir uma vez" também conta (antes só o Permitir gravado: o bank.info respondia e o player seguia sem money).
       isOnce cobre o dia em que o Perm conhecer o tipo 'bank'; onceExtra é o diálogo próprio deste ficheiro */
    if (window.Perm && (Perm.get(app, 'bank') === true || (Perm.isOnce && Perm.isOnce(app, 'bank')) || onceExtra.has(app + ':bank'))) return p;
    const o = Object.assign({}, p); delete o.money; return o;
  }
  /* messages.send vindo de um iframe: só SMS para um número (não DMs das redes sociais nem grupos em nome do jogador), sem imagens
     e com payload só de valores simples - o resto do objeto nunca chega ao servidor */
  function cleanMessage(d) {
    d = d || {}; const type = ['text', 'location', 'contact'].includes(d.type) ? d.type : 'text'; let payload = null;
    if (type !== 'text' && d.payload && typeof d.payload === 'object') { payload = {}; Object.keys(d.payload).slice(0, 8).forEach(k => { const v = d.payload[k]; if (typeof v === 'number' && isFinite(v)) payload[txt(k, 16)] = v; else if (typeof v === 'string') payload[txt(k, 16)] = txt(v, 120); }); }
    /* `to` só como número: "g:<id>" (grupos da Fase 2) mandaria para um grupo em nome do jogador */
    const to = txt(d.to, 40);
    return { app: 'sms', to: /^[\w \-+().]+$/.test(to) ? to : '', type, content: txt(d.content, 1000), payload };
  }
  /* widget de iframe: NUNCA HTML vindo de fora (antes m.html ia direto para innerHTML na home - script na origem do
     telemóvel com acesso a Bridge.rpc). Daqui só sai ESTRUTURA: um template do widgets.js (stat/list/progress/text,
     pintados por textContent) com dados de texto/número cortados. O m.html antigo é reduzido a texto num documento
     inerte (DOMParser não corre scripts nem onerror) e vai como template 'text'. O render() é só o recurso para um
     widgets.js sem templates, e escapa tudo. */
  const TPL = ['stat', 'list', 'progress', 'text'];
  function safeWidget(m) {
    const s = m.data && typeof m.data === 'object' ? m.data : m;
    const plain = m.html ? (new DOMParser().parseFromString(String(m.html).slice(0, 20000), 'text/html').body.textContent || '').replace(/\s+/g, ' ').trim() : '';
    const template = TPL.includes(m.template) ? m.template : s.value != null ? 'stat' : Array.isArray(s.items) ? 'list' : 'text';
    const data = { title: txt(s.title != null ? s.title : m.name, 60) };
    if (/^#[0-9a-f]{3,8}$/i.test(String(s.color || ''))) data.color = String(s.color);
    if (template === 'stat') { data.value = txt(s.value, 40); if (s.unit != null) data.unit = txt(s.unit, 12); if (s.sub != null) data.sub = txt(s.sub, 120); if (/^[a-zA-Z0-9]{1,24}$/.test(String(s.icon || ''))) data.icon = String(s.icon); }
    else if (template === 'list') data.items = (Array.isArray(s.items) ? s.items : []).slice(0, 8).map(it => it && typeof it === 'object' ? (it.right != null ? { text: txt(it.text, 80), right: txt(it.right, 20) } : { text: txt(it.text, 80) }) : { text: txt(it, 80) });
    else if (template === 'progress') { const v = Number(s.value); data.value = isFinite(v) ? v : 0; if (s.label != null) data.label = txt(s.label, 40); if (s.sub != null) data.sub = txt(s.sub, 120); }
    else data.text = txt(s.text != null ? s.text : plain, 600);
    const body = template === 'list' ? data.items.map(i => i.text).join(' · ') : template === 'text' ? data.text : String(data.label || data.value) + (data.unit ? ' ' + data.unit : '');
    const render = () => `<div class="wt">${UI.esc(data.title)}</div><div class="ws">${UI.esc(body)}</div>`;
    return { template, data, render };
  }
  /* registo de um widget externo (iframe ou export do Lua). `app` = a app dona, só se existir: sem isso o
     toque no widget tentava abrir uma app que não está no telemóvel. */
  function putWidget(app, m) {
    if (!window.Widgets || !m || !m.id || !m.name) return false;
    const w = safeWidget(m);
    const sizes = (Array.isArray(m.sizes) ? m.sizes : [m.size]).filter(z => ['2x2', '4x2', '4x4'].includes(z));
    Widgets.register({ id: 'ext_' + txt(m.id, 32), name: txt(m.name, 40), size: sizes[0] || '2x2', sizes: sizes.length ? sizes : ['2x2'], app: app || null, external: true, template: w.template, data: w.data, render: w.render });
    return true;
  }
  /* ---------- WIDGETS DE RESOURCES EM LUA (Fase 6) ----------
     exports['apex_phone']:RegisterWidget{...} / UnregisterWidget(id) → push 'widget' (client/exports.lua).
     O registo do widgets.js é em MEMÓRIA e morre com o NUI, por isso o telemóvel volta a pedir a lista ao
     cliente em cada arranque ('ready' → Bridge.call('widgetsRegistry')); até lá a célula da home mostra o
     nome gravado e "Indisponível" - não promete dados que não tem. */
  function luaWidget(d) {
    if (!d || typeof d !== 'object' || !d.id) return;
    const wid = 'ext_' + txt(d.id, 32);
    if (d.op === 'remove') { if (window.Widgets) Widgets.unregister(wid); return; }
    putWidget(typeof d.app === 'string' && App.get(d.app) ? d.app : null, d);
  }
  Bridge.on('widget', luaWidget);

  /* ---------- ATIVIDADES AO VIVO na Dynamic Island (Fase 6) ----------
     O island.js tem activity/update/stop e o modo de navegação desenhados desde o início e ninguém os
     chamava: não havia via nem para um resource em Lua nem para uma app externa. Agora há duas:
       · Lua   → exports StartActivity / UpdateActivity / StopActivity (client/exports.lua), push 'activity';
       · app externa → postMessage { apexphone:'activity', op, id, title, … } ou RKPhone.startActivity(…).
     NADA do que vem de fora entra como HTML: o texto é cortado e a ilha escapa-o; o `icon` só pode ser um
     glifo do telemóvel, o id de uma app instalada ou um URL (nui/http(s)/data:image) - a ilha pinta URLs
     por CSSOM. Sem `title` recusa-se (a pílula não teria o que mostrar). Máximo de ACT_MAX ao mesmo tempo:
     a ilha ordena e repinta a lista inteira, e 200 atividades de um resource distraído davam nisso. */
  const ACT_MAX = 8, acts6 = new Set();
  const ACT_KEY = /^[\w.:@+-]{1,64}$/;
  const actIcon = v => {
    const s = typeof v === 'string' ? v.trim() : '';
    if (!s || s.startsWith('<')) return '';
    if (/^(https?:\/\/|nui:\/\/|data:image\/)/i.test(s)) return s.length <= 200000 ? s : '';
    if (/^[\w.:-]{1,64}$/.test(s) && (App.get(s) || (Icons.has && Icons.has(s)))) return s;
    return '';
  };
  function actData(d, defApp, start) {
    const o = {}; if (!d || typeof d !== 'object') d = {};
    if (start || 'app' in d) { const a = txt(d.app, 64); o.app = App.get(a) ? a : (App.get(defApp) ? defApp : 'settings'); }
    if ('title' in d) o.title = txt(d.title, 60);
    if ('subtitle' in d) o.subtitle = txt(d.subtitle, 90);
    if ('state' in d) o.state = txt(d.state, 24);
    if ('icon' in d) o.icon = actIcon(d.icon);
    if ('progress' in d) { const p = Number(d.progress); o.progress = isFinite(p) ? Math.max(0, Math.min(1, p)) : null; }
    if ('eta' in d) { const e = Number(d.eta); o.eta = (typeof d.eta === 'number' && isFinite(e)) ? e : (d.eta == null || d.eta === '' ? null : txt(d.eta, 24)); }
    return o;
  }
  function runActivity(key, op, data, defApp) {
    if (!window.Island || !ACT_KEY.test(String(key || ''))) return false;
    if (op === 'stop') { acts6.delete(key); return Island.stop(key); }
    if (op === 'update') return acts6.has(key) ? Island.update(key, actData(data, defApp, false)) : false;
    const o = actData(data, defApp, true);
    if (!o.title) { console.warn('[apex_phone] atividade ao vivo "' + key + '" sem title: recusada'); return false; }
    if (!acts6.has(key) && acts6.size >= ACT_MAX) { console.warn('[apex_phone] atividades ao vivo: já há ' + ACT_MAX + ': "' + key + '" recusada'); return false; }
    acts6.add(key); Island.activity(key, o); return true;
  }
  Bridge.on('activity', d => { if (!d || typeof d !== 'object') return; runActivity(String(d.id == null ? '' : d.id), d.op === 'update' ? 'update' : d.op === 'stop' ? 'stop' : 'start', d.data, null); });
  /* a app externa saiu MESMO (o resource parou, ou UnregisterApp): as atividades dela saem com ela.
     ⚠️ não se usa o 'app:kill': esse também dispara quando o LRU fecha a janela ao fim de 7 apps - e uma
     atividade ao vivo existe precisamente para continuar com a app fechada.
     As do Lua são do resource e saem no onResourceStop do client/exports.lua. */
  function dropActs(app) { const p = 'x:' + app + ':'; [...acts6].forEach(k => { if (k.indexOf(p) === 0) { acts6.delete(k); if (window.Island) Island.stop(k); } }); }
  /* troca de personagem / reposição de fábrica: a ilha limpa-se sozinha, aqui só se larga a contagem */
  Bridge.on('session:changed', () => acts6.clear());
  Bridge.on('factory:reset', () => acts6.clear());
  const extActivity = (app, op, id, data) => runActivity(('x:' + app + ':' + txt(id, 24)).slice(0, 64), op, data, app);

  /* ---------- SDK 1.5.0: pedidos ao PRÓPRIO recurso do comprador e KV no servidor ----------
     'appcall' → RPC app.call { name, data } e 'kv' → RPC app.kv.<op>, sempre marcados com __ext (o servidor só os aceita assim e
     põe o id da app no pedido). Não passam pela lista branca EXT_RPC (são do SDK, não do telemóvel) nem pedem consentimento: a
     app fala com o SEU servidor sobre os SEUS dados. O que vem do iframe é cortado: nome curto, dados só JSON até 48 KB. */
  const NAME_OK = /^[\w.:-]{1,64}$/;
  const KV_OPS = ['get', 'set', 'remove', 'keys'];
  /* false = não é JSON ou passa do limite (um objeto com ciclos, uma função, 2 MB de texto) */
  const plainData = (v, max) => { if (v === undefined) return null; try { const s = JSON.stringify(v); if (s === undefined) return null; if (s.length > (max || 48000)) return false; return JSON.parse(s); } catch (e) { return false; } };
  async function extCall(app, m) {
    const name = typeof m.name === 'string' ? m.name : '';
    if (!NAME_OK.test(name)) return { error: 'invalid' };
    const data = plainData(m.data);
    if (data === false) return { error: 'toolarge' };
    return Bridge.rpc('app.call', { name, data, __ext: app });
  }
  async function extKv(app, m) {
    const op = KV_OPS.includes(m.op) ? m.op : null;
    if (!op) return { error: 'invalid' };
    const body = { __ext: app };
    if (op !== 'keys') { const k = typeof m.k === 'string' ? m.k : ''; if (!NAME_OK.test(k)) return { error: 'key' }; body.k = k; }
    if (op === 'set') { if (typeof m.v !== 'string') return { error: 'invalid' }; if (m.v.length > 60000) return { error: 'toolarge' }; body.v = m.v; }
    return Bridge.rpc('app.kv.' + op, body);
  }
  const EXT_SOUNDS = new Set(['click', 'tap', 'success', 'error', 'notify', 'pop', 'send', 'lock', 'unlock']);
  const badgeN = n => Math.max(0, Math.min(9999, Math.floor(Number(n) || 0)));

  /* ---------- TECLADO DO TELEMÓVEL para um campo DENTRO do iframe (SDK 1.5.0) ----------
     O teclado (shell/keyboard.js) escreve em elementos do documento do telemóvel; o campo da app vive noutro documento (outra
     origem) e ele não lhe toca. Ponte: um <input> "procurador" invisível na janela da app recebe o foco (o teclado abre como para
     qualquer campo) e cada tecla escrita nele segue para o iframe em { apexphone:'keyboard', value }; o Enter vai como
     { enter:true } e a descida do teclado como { hidden:true }. Quem escreve o valor no campo real é o SDK na página
     (apexphone-sdk.js, keyboard.show). O procurador fica no TOPO da janela (apps.css .ext-kb, y 80) para o keyboard.js não
     subir a janela inteira: a app arruma o seu conteúdo com a altura que recebe em { shown:true, height }. No browser (sem o
     teclado do telemóvel) o procurador continua a receber o teclado físico e a reencaminhar: a ponte serve na mesma. */
  const kbProxy = {};
  const KB_TYPES = ['text', 'tel', 'number', 'password', 'email', 'url', 'search'];
  function extKeyboard(id, f, m) {
    const win = f.closest('.app-window'); if (!win) return;
    let p = kbProxy[id];
    if (!m.on) { if (p && document.activeElement === p) p.blur(); if (window.Keyboard && Keyboard.visible && (!document.activeElement || !document.activeElement.matches('input,textarea'))) Keyboard.hide(); return; }
    if (!p || !p.isConnected) {
      p = UI.el('<input class="ext-kb" autocomplete="off" spellcheck="false">'); win.appendChild(p); kbProxy[id] = p;
      p.addEventListener('input', () => send(f, { apexphone: 'keyboard', value: p.value }));
      p.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); send(f, { apexphone: 'keyboard', enter: true, value: p.value }); } });
      /* o foco saiu do procurador (toque na página, noutro campo do telemóvel, teclado recolhido): 150 ms para o keyboard.js decidir */
      p.addEventListener('blur', () => setTimeout(() => { if (document.activeElement !== p && kbProxy[id] === p) send(f, { apexphone: 'keyboard', hidden: true, value: p.value }); }, 150));
    }
    p.type = KB_TYPES.includes(m.type) ? m.type : 'text';
    if (typeof m.hint === 'string' && /^[a-z]{1,10}$/.test(m.hint)) p.setAttribute('enterkeyhint', m.hint); else p.removeAttribute('enterkeyhint');
    const ml = Math.floor(Number(m.maxLength) || 0); if (ml > 0 && p.type !== 'number') p.maxLength = Math.min(5000, ml); else p.removeAttribute('maxlength');
    if (m.noCap) p.setAttribute('autocapitalize', 'off'); else p.removeAttribute('autocapitalize');
    p.value = txt(m.value, 5000);
    if (document.activeElement === p) p.click(); else p.focus();   /* já com o foco: o keyboard.js só abre no focusin, mas um click reabre (listener em captura) */
    setTimeout(() => { const kb = document.getElementById('kb'); const on = !!(window.Keyboard && Keyboard.visible); send(f, { apexphone: 'keyboard', shown: on, height: on && kb ? kb.offsetHeight : 0 }); }, 80);
  }

  window.addEventListener('message', async e => {
    const m = e.data; if (!m || !m.apexphone) return; const src = e.source; const id = Object.keys(frames).find(k => frames[k].contentWindow === src); if (!id) return; const f = frames[id];
    switch (m.apexphone) {
      case 'notify': Notify.push({ app: id, title: txt(m.title, 80), msg: txt(m.msg, 255), onTap: () => System.openApp(id) }); break;
      case 'toast': UI.toast(txt(m.msg, 120)); break;
      case 'close': System.closeApp(); break;
      case 'openApp': if (typeof m.id === 'string') System.openApp(m.id); break;
      case 'setWaypoint': if (isFinite(+m.x) && isFinite(+m.y)) Bridge.call('setWaypoint', { x: +m.x, y: +m.y, name: txt(m.name, 60) }); break;
      case 'rpc': { const result = await extRpc(id, typeof m.name === 'string' ? m.name : '', m.data); send(f, { apexphone: 'rpc', id: m.id, result }); break; }
      case 'getContacts': send(f, (await consent(id, 'contacts')) ? { apexphone: 'contacts', list: Contacts.cache } : { apexphone: 'contacts', list: [], error: 'denied' }); break;
      case 'getPlayer': send(f, { apexphone: 'player', player: playerFor(id, System.player) }); break;
      case 'getLocation': { if (!(await consent(id, 'location'))) { send(f, { apexphone: 'location', coords: null, error: 'denied' }); break; } const c = await Bridge.call('getCoords'); send(f, { apexphone: 'location', coords: c }); break; }
      case 'call': PhoneApp.call(txt(m.number, 20), m.name != null ? txt(m.name, 64) : undefined); break;
      case 'message': Msgs.open(txt(m.number, 40), m.name != null ? txt(m.name, 64) : undefined); break;
      /* o padrão vira RegExp na Vera: regex inválida não rebenta o handler, quantificadores aninhados ("(a+)+") são
         recusados (backtracking catastrófico congelava a Vera a cada frase) e cada app regista no máx. 20 comandos */
      case 'vera': if (typeof m.pattern === 'string' && m.pattern.length <= 80 && m.reply && !/\([^)]*[+*}][^)]*\)\s*[+*{]/.test(m.pattern) && (veraCount[id] || 0) < 20) { try { new RegExp(m.pattern, 'i'); } catch (e) { break; } veraCount[id] = (veraCount[id] || 0) + 1; const pat = m.pattern, reply = txt(m.reply, 300); Vera.register(pat, () => { send(f, { apexphone: 'auraCommand', pattern: pat }); return reply; }); } break;
      case 'widget': putWidget(id, m); break;
      /* { on } - a app diz quando um campo de texto dela tem o foco (ver wantsTyping); a partir daqui manda ela */
      case 'typing': typingAware[id] = true; typingWant[id] = !!m.on; Bridge.emit('ext:typing'); break;
      /* { op:'start'|'update'|'stop', id, title, subtitle, icon, progress, eta, state } - a chave fica
         no espaço desta app ('x:<app>:<id>'), por isso uma app externa nunca toca na atividade de outra */
      case 'activity': extActivity(id, m.op === 'update' ? 'update' : m.op === 'stop' ? 'stop' : 'start', m.id, m); break;
      /* ---- SDK 1.5.0 ---- */
      case 'ready': send(f, initMsg(id, f)); break;
      case 'appcall': { const result = await extCall(id, m); send(f, { apexphone: 'rpc', id: m.id, result }); break; }   /* 'call' (sem "app") é ligar para um número, acima */
      case 'kv': { const result = await extKv(id, m); send(f, { apexphone: 'rpc', id: m.id, result }); break; }
      case 'setBadge': if (System.badge) System.badge(id, badgeN(m.n)); break;
      case 'haptic': Sound.play(m.kind === 'heavy' ? 'pop' : 'tap'); break;
      case 'sound': if (EXT_SOUNDS.has(m.name)) Sound.play(m.name); break;
      case 'keyboard': extKeyboard(id, f, m); break;
      case 'openURL': if (typeof m.url === 'string' && /^phone:\/\//i.test(m.url)) System.openURL(m.url.slice(0, 512)); break;
    }
  });
  /* servidor → iframe (exports PushToApp / SetAppBadge, server/sdk.lua). Só a app aberta recebe eventos: para o que tem de
     chegar com a app fechada há notificações (SendNotification) e o KV. */
  Bridge.on('app:event', d => { if (!d || typeof d !== 'object' || typeof d.app !== 'string' || typeof d.event !== 'string') return; const f = frames[d.app]; if (f) send(f, { apexphone: 'event', name: d.event.slice(0, 64), data: d.data === undefined ? null : d.data }); });
  Bridge.on('app:badge', d => { if (!d || typeof d !== 'object' || typeof d.app !== 'string' || !ID_OK.test(d.app) || !App.get(d.app)) return; if (System.badge) System.badge(d.app, badgeN(d.n)); });
  Bridge.on('registerApp', register);
  /* sai de vez: também se esquece a definição, para o ouvinte do emprego não a ressuscitar */
  Bridge.on('unregisterApp', d => { const id = d && d.id != null ? String(d.id) : ''; if (!id) return; delete defs[id]; unregister(id); });
  /* 1.5.0: o 'theme' leva também lang e glassTint; uma mudança de idioma sai ainda como 'lang' à parte */
  Bridge.on('state', p => { broadcast(Object.assign({ apexphone: 'theme' }, themeBits())); if (p && typeof p === 'object' && 'lang' in p) broadcast({ apexphone: 'lang', lang: System.state.lang || 'pt' }); });
  Bridge.on('player:update', p => Object.keys(frames).forEach(k => send(frames[k], { apexphone: 'player', player: playerFor(k, p) })));
  Bridge.on('ready', async () => { loadGrants(); const r = await Bridge.rpc('apps.registry');
    /* tabela vazia do Lua chega como {} (não é array): sem isto o forEach rebentava e os widgets abaixo nunca se pediam */
    const reg = Array.isArray(r) ? r : (r && typeof r === 'object' && !r.error ? Object.values(r) : []);
    reg.forEach(d => { try { register(d); } catch (e) { console.error('[apex_phone] app externa', d && d.id, e); } });
    /* widgets dos resources em Lua: o registo do NUI é em memória e este arranque é novo (ver luaWidget) */
    let ws = null; try { ws = await Bridge.call('widgetsRegistry'); } catch (e) { ws = null; }
    (Array.isArray(ws) ? ws : (ws && typeof ws === 'object' ? Object.values(ws) : [])).forEach(luaWidget); });
  /* handlers "do recurso do comprador" para o browser e o harness (ThirdParty.mockRPC): app → { nome → fn(data) } */
  const mockH = {};
  const mockRPC = (app, name, fn) => { if (typeof app !== 'string' || typeof name !== 'string' || typeof fn !== 'function') return false; (mockH[app] = mockH[app] || {})[name] = fn; return true; };
  /* Mocks do browser (sem FiveM) dos RPCs de autorização - o mesmo contrato do server/main.lua */
  if (window.LocalDB && LocalDB.register) {
    const GT = () => LocalDB.T('app_grants'), onceM = new Set(), KNOWN = new Set(Object.values(RPC_KIND));
    const okApp = a => typeof a === 'string' && /^[\w.:-]{1,64}$/.test(a);
    const hit = (r, d) => r.owner === LocalDB.cid && r.app === d.app && (d.perm == null || r.perm === d.perm);
    LocalDB.register('apps.grant', d => {
      if (!okApp(d.app) || !KNOWN.has(d.perm)) return { ok: false, error: 'invalid' };
      if (d.once === true) { onceM.add([LocalDB.cid, d.app, d.perm].join('\u0001')); return { ok: true, once: true }; }
      if (!GT().all().some(r => hit(r, d))) GT().insert({ owner: LocalDB.cid, app: d.app, perm: d.perm, created: Date.now() });
      return { ok: true };
    });
    LocalDB.register('apps.revoke', d => {
      if (!okApp(d.app) || (d.perm != null && !KNOWN.has(d.perm))) return { ok: false, error: 'invalid' };
      [...onceM].forEach(k => { const [c, a, p] = k.split('\u0001'); if (c === LocalDB.cid && a === d.app && (d.perm == null || p === d.perm)) onceM.delete(k); });
      if (d.once !== true) GT().remove(r => hit(r, d));
      return { ok: true };
    });
    LocalDB.register('apps.grants', () => ({ items: GT().all().filter(r => r.owner === LocalDB.cid).map(r => ({ app: r.app, perm: r.perm, created: r.created })),
      once: [...onceM].map(k => k.split('\u0001')).filter(x => x[0] === LocalDB.cid).map(x => ({ app: x[1], perm: x[2] })) }));
    /* ---- SDK 1.5.0: o mesmo contrato do server/sdk.lua. Os handlers do "recurso do comprador" registam-se com
       ThirdParty.mockRPC(app, name, fn) (harness/browser); o KV vive na tabela app_kv do mock, por personagem. ---- */
    LocalDB.register('app.call', d => {
      const app = d.__ext; if (!okApp(app)) return { error: 'forbidden' };
      if (typeof d.name !== 'string' || !NAME_OK.test(d.name)) return { error: 'invalid' };
      const h = mockH[app] && mockH[app][d.name]; if (!h) return { error: 'nohandler' };
      try { const r = h(d.data === undefined ? null : d.data); return { ok: true, result: r === undefined ? null : r }; } catch (e) { console.error('[apex_phone] mock app.call', app, d.name, e); return { error: 'internal' }; }
    });
    const KV = () => LocalDB.T('app_kv'), KV_MAX_KEYS = 200, KV_MAX_BYTES = 16000;
    const kvRow = (r, d) => r.owner === LocalDB.cid && r.app === d.__ext && r.k === d.k;
    const kvCheck = d => !okApp(d.__ext) ? { error: 'forbidden' } : (typeof d.k !== 'string' || !NAME_OK.test(d.k)) ? { error: 'key' } : null;
    LocalDB.register('app.kv.get', d => { const bad = kvCheck(d); if (bad) return bad; const r = KV().all().find(x => kvRow(x, d)); return { v: r ? r.v : null }; });
    LocalDB.register('app.kv.set', d => {
      const bad = kvCheck(d); if (bad) return bad;
      if (d.v == null) { KV().remove(x => kvRow(x, d)); return { ok: true }; }
      if (typeof d.v !== 'string') return { error: 'invalid' };
      if (d.v.length > KV_MAX_BYTES) return { error: 'toolarge' };
      try { JSON.parse(d.v); } catch (e) { return { error: 'invalid' }; }
      const rows = KV().all(); const r = rows.find(x => kvRow(x, d));
      if (r) { r.v = d.v; r.updated = Date.now(); KV().set(rows); return { ok: true }; }
      if (rows.filter(x => x.owner === LocalDB.cid && x.app === d.__ext).length >= KV_MAX_KEYS) return { error: 'limit' };
      KV().insert({ owner: LocalDB.cid, app: d.__ext, k: d.k, v: d.v, updated: Date.now() }); return { ok: true };
    });
    LocalDB.register('app.kv.remove', d => { const bad = kvCheck(d); if (bad) return bad; KV().remove(x => kvRow(x, d)); return { ok: true }; });
    LocalDB.register('app.kv.keys', d => !okApp(d.__ext) ? { error: 'forbidden' } : { keys: KV().all().filter(x => x.owner === LocalDB.cid && x.app === d.__ext).map(x => x.k).sort() });
  }
  /* API global para apps na mesma origem.
     account: só o que o init dos iframes também leva - a conta inteira trazia o `face` (base64 da cara do Face Key)
     rpc: a mesma lista branca, consentimento e autorização no servidor dos iframes; a app que pede é a externa aberta
     (sem nenhuma aberta fica 'rkphone', e os sensíveis pedem autorização em nome desse id) */
  const currentExt = () => { const c = System.currentApp && System.currentApp(), d = c && App.get(c); return d && d.external ? c : null; };
  window.RKPhone = { notify: o => Notify.push(o), openApp: id => System.openApp(id), close: () => System.closeApp(), rpc: (n, d) => extRpc(currentExt() || 'rkphone', n, d), call: (n, name) => PhoneApp.call(n, name), message: (n, name) => Msgs.open(n, name), toast: UI.toast, registerApp: register, unregisterApp: unregister, registerWidget: def => Widgets.register(def), vera: (p, fn) => Vera.register(p, fn),
    /* atividades ao vivo na Dynamic Island (Fase 6): a chave fica no espaço da app aberta */
    startActivity: (id, data) => extActivity(currentExt() || 'rkphone', 'start', id, data),
    updateActivity: (id, data) => extActivity(currentExt() || 'rkphone', 'update', id, data),
    stopActivity: id => extActivity(currentExt() || 'rkphone', 'stop', id, null),
    get player() { return System.player; }, get account() { const a = System.account; return a ? { username: a.username, phone: a.phone, avatar: a.avatar } : null; }, get state() { return System.state; } };
  /* SDK 1.5.0: mockRPC (handlers de browser/harness) e send (mandar uma mensagem a uma app aberta, para testes) */
  return { register, unregister, frames, activity: extActivity, widget: putWidget, wantsTyping, mockRPC, send: (id, msg) => { const f = frames[id]; if (f) send(f, msg); return !!f; } };
})();
