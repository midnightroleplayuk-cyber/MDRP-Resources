/* ===================== DEFINIÇÕES ===================== */
App.define('settings', {
  name: 'Definições', core: true, category: 'Utilitários',
  /* a janela fechada fica viva no LRU e o estado muda por fora (Centro de controlo, Vera, o item dos
     earbuds): ao voltar à app a raiz repinta-se, senão via-se o Wi-Fi e o hotspot de há dez minutos */
  resume(win) { try { win._paintRoot && win._paintRoot(); } catch (e) {} },
  open(win) {
    const S = System.state, set = p => System.setState(p), g = UI.g;
    /* rede: a regra dos quatro interruptores é a do Centro de controlo (CC.netPatch) - o modo de voo desliga
       Wi-Fi/dados/hotspot, desligá-lo devolve os dados, ligar Wi-Fi/dados/hotspot desliga o modo de voo e
       desligar os dados leva o hotspot atrás. Estava copiada à mão em três sítios daqui e a cópia do modo de
       voo não devolvia os dados: desligá-lo nas Definições deixava o telemóvel sem rede nenhuma e sem o dizer. */
    const netPatch = (k, v) => (window.CC && CC.netPatch) ? CC.netPatch(k, v) : { [k]: v };
    /* CHAVES DE REDE: as que obrigam uma lista já desenhada a mudar de cara. O modo de voo desliga Wi-Fi,
       dados e hotspot de uma vez - sem repintar, as linhas continuavam a mostrar o estado antigo. */
    const NETK = ['airplane', 'wifi', 'wifiNet', 'cellular', 'bt', 'earbuds', 'airpodsWorn', 'hotspot', 'vpn'];
    const touches = (p, keys) => !p || typeof p !== 'object' || keys.some(k => k in p);
    /* repintar ADIADO e coalescido: dá tempo ao interruptor de acabar de deslizar antes de a lista ser
       refeita (refazê-la no mesmo instante fazia o botão saltar para o fim sem animação) e dez mudanças
       seguidas dão um repintar só. O timer vai para win.timers - morre com a janela. */
    const soon = fn => { let t = null; return () => { if (t != null) return;
      t = setTimeout(() => { const id = t; t = null; const i = win.timers.indexOf(id); if (i > -1) win.timers.splice(i, 1); fn(); }, 320); win.timers.push(t); }; };
    /* ANDROID (Nova UI 8.5, docs/ANDROID.md): as MESMAS paginas, chaves e RPC; muda a estrutura (grupos da Nova UI), os nomes
       (NOVA / Nova UI, System.osInfo()) e o desenho (titulo grande na zona de leitura, cartoes r26, valores em azul).
       O sistema nao muda com a janela aberta: o setOS mata as janelas, por isso basta ler uma vez. */
    const A = System.os === 'android', OSI = () => System.osInfo();
    const NA = 'Desconhecido';   /* valor em falta, escrito por extenso nos dois sistemas (nunca um travessão) */
    /* Android: cada pagina tem o titulo grande (zona de leitura) e o conteudo vive num invólucro proprio (.aset-body), para
       os repintar com innerHTML = '' nunca levarem o titulo atras */
    /* opts.from: a vista (ou um nó dela) de onde a página sai. Com o dobrável aberto um push sem origem troca o detalhe; com ela
       empilha-se por cima dessa vista (ex.: a página do par por cima do Bluetooth, quando os dois se abrem seguidos) */
    const sub = (title, build, opts = {}) => { const { from, ...vo } = opts; const v = UI.view(Object.assign({ title, back: vo.back || 'Definições' }, A ? { large: true } : {}, vo));
      let c = v.content; if (A) { c = UI.el('<div class="aset-body"></div>'); v.content.appendChild(c); }
      build(c, v); UI.push(from && from.nodeType === 1 && win.contains(from) ? from : win, v); return v; };
    const pick = (title, options, cur, onPick, back) => sub(title, c => c.appendChild(UI.list([{ items: options.map(o => (A ? { label: o, right: UI.radio(o === cur), chevron: false, onTap: () => { onPick(o); UI.pop(win); } } : { label: o, value: o === cur ? g('check', 21) : '', valueHtml: true, chevron: false, onTap: () => { onPick(o); UI.pop(win); } })) }])), { back });   /* visto do sistema em azul, não o carácter "✓"; na Nova UI, botões de opção */
    const acc = () => System.account || {}; const p = () => System.player;
    /* ---------- Notificações por app (Fase 1: System.state.notifApps[app]) ----------
       Lê pelo Notify.appSettings (notify.js) quando existe - é quem aplica as regras - e cai nos mesmos
       valores por omissão quando não. Escreve no estado (a fonte do contrato) e mantém o antigo
       notif[app] === false coerente com `allow`, para quem ainda o lê. */
    const PREVIEW = [['always', 'Sempre'], ['unlocked', 'Quando desbloqueado'], ['never', 'Nunca']];
    const pvLabel = v => (PREVIEW.find(x => x[0] === v) || PREVIEW[0])[1];
    const nDefaults = id => ({ allow: !(S.notif && S.notif[id] === false), sound: true, badge: true, lock: true, banner: true, preview: 'always' });
    const nCfg = id => { if (window.Notify && typeof Notify.appSettings === 'function') { try { const r = Notify.appSettings(id); if (r && typeof r === 'object') return Object.assign(nDefaults(id), r); } catch (e) {} } return Object.assign(nDefaults(id), (S.notifApps || {})[id] || {}); };
    const nPatch = (all, legacy, id, patch) => { const nx = Object.assign(nCfg(id), patch); all[id] = { allow: !!nx.allow, sound: !!nx.sound, badge: !!nx.badge, lock: !!nx.lock, banner: !!nx.banner, preview: PREVIEW.some(x => x[0] === nx.preview) ? nx.preview : 'always' }; if (nx.allow === false) legacy[id] = false; else delete legacy[id]; };
    const nSet = (id, patch) => { const all = Object.assign({}, S.notifApps || {}), legacy = Object.assign({}, S.notif || {}); nPatch(all, legacy, id, patch); set({ notifApps: all, notif: legacy }); };
    const nSummary = id => { const n = nCfg(id); if (!n.allow) return 'Desativadas'; const l = [n.banner && 'Banners', n.sound && 'Sons', n.badge && 'Emblemas'].filter(Boolean); return l.length ? l.join(', ') : 'Silenciosas'; };
    /* nome do dispositivo (Fase 1: S.deviceName; o antigo S.name continua a ser o NOME DA PESSOA em Conta) */
    const renameDevice = async after => { const n = A ? await UI.prompt('Nome do telefone', 'Como o teu telemóvel aparece', OSI().model, System.deviceName()) : await UI.prompt('Nome do dispositivo', 'Como o teu PearPhone aparece', 'PearPhone', System.deviceName()); if (n === null) return; const v = n.replace(/[<>]/g, '').trim().slice(0, 32); set({ deviceName: v }); if (after) after(); };
    /* código: o servidor já não manda o pin (Fase 1) - só hasPin/pinLen. Sem o campo (servidor antigo) assume-se que há código. */
    const hasPin = () => acc().hasPin !== false;
    const secs = ms => { const s = Math.max(1, Math.ceil(ms / 1000)); return s >= 60 ? Math.ceil(s / 60) + ' min' : s + ' s'; };
    /* o servidor manda `wait` (segundos que faltam) e `lockedUntil` (ms no relógio DELE): usa-se o `wait` primeiro,
       porque o relógio do PC do jogador pode não bater com o do servidor; lockedUntil < 1e12 vem em segundos */
    const pinFail = r => { const d = (r && r.data) || {};
      if (+d.wait > 0 || +d.lockedUntil > 0) { const ms = +d.wait > 0 ? +d.wait * 1000 : (+d.lockedUntil < 1e12 ? +d.lockedUntil * 1000 : +d.lockedUntil) - Date.now(); return `Demasiadas tentativas. Tenta outra vez dentro de ${secs(ms)}.`; }
      if (typeof d.attempts === 'number' && d.attempts > 0) return d.attempts === 1 ? 'Resta 1 tentativa.' : `Restam ${d.attempts} tentativas.`; return ''; };
    /* resposta do servidor a dizer "código errado" ({ ok:false }) ≠ não haver resposta (rate limit, servidor em baixo) */
    const pinWrong = r => !!(r && r.data && r.data.ok === false);

    /* ---------- Conta ---------- */
    /* Foto da conta (§10.3): `System.account.avatarPhoto` é a data URL que o servidor guarda (account.setAvatarPhoto);
       sem ela o avatar é a cor `avatar` com as iniciais, como sempre. O UI.avatar já pinta o <img> redondo com o `url`. */
    const myAvatar = (a, cls) => UI.avatar({ name: a.username || (S.name || `${p().firstname} ${p().lastname}`).trim(), avatar: a.avatar, url: a.avatarPhoto || null }, cls);
    const AV_MAX = 120000;   /* o teto do servidor (como o account.setFace) */
    /* Escolher das Fotos → quadrado de 240 px (≈ 20 KB); se ainda passar do teto tenta-se mais pequeno, e só depois se desiste.
       O rpcRaw é de propósito: um { error } do servidor (badimage, rate limit) tem de chegar aqui e não virar null em silêncio. */
    const pickAvatarPhoto = async () => {
      if (window.CC && CC.requireNet && !CC.requireNet('mudar a foto da conta')) return false;
      if (!window.Photos || !Photos.pick) { UI.toast(A ? App.name('photos') + ' indisponível' : 'Fotos indisponíveis'); return false; }
      const ph = await Photos.pick('Foto da conta'); if (!ph) return false;
      const src = await Photos.data(ph, true); if (!src) { UI.toast('Esta foto não tem imagem'); return false; }
      let out = await Photos.square(src, 240, .8);
      if (out && out.length > AV_MAX) out = await Photos.square(src, 160, .7);
      if (!out) { UI.toast('Não foi possível preparar a foto'); return false; }
      if (out.length > AV_MAX) { UI.toast('A foto é demasiado grande'); return false; }
      const r = await Bridge.rpcRaw('account.setAvatarPhoto', { photo: out });
      if (!r || !r.ok) { UI.toast(r && r.error === 'badimage' ? 'Foto recusada' : 'Não foi possível guardar a foto'); Sound.play('error'); return false; }
      if (System.account) System.account.avatarPhoto = out;
      Sound.play('success'); return true;
    };
    const removeAvatarPhoto = async () => {
      if (window.CC && CC.requireNet && !CC.requireNet('remover a foto da conta')) return false;
      const r = await Bridge.rpcRaw('account.setAvatarPhoto', { photo: '' });
      if (!r || !r.ok) { UI.toast('Não foi possível remover a foto'); return false; }
      if (System.account) System.account.avatarPhoto = null;
      return true;
    };
    /* cicla as 12 cores (o account.update de sempre); com foto a cor continua guardada e volta a ver-se ao remover a foto */
    const cycleAvatarColor = async a => { const n = ((a.avatar || 1) % 12) + 1; await Bridge.rpc('account.update', { avatar: n }); a.avatar = n; if (System.account && System.account !== a) System.account.avatar = n; };
    /* Toque no avatar grande ou na linha "Avatar": folha com Escolher das Fotos · Cor · Remover foto (só com foto).
       Devolve true quando algo mudou - quem chama repinta a página Conta e a raiz (a linha de topo também mostra a foto). */
    const avatarMenu = async a => {
      const buttons = [{ label: A ? 'Escolher da ' + App.name('photos') : 'Escolher das Fotos', value: 'pick', icon: 'photo' }, { label: 'Cor', value: 'color', icon: 'sparkles' }];
      if (a.avatarPhoto) buttons.push({ label: 'Remover foto', value: 'rm', danger: true });
      const v = await UI.actionSheet({ title: 'Foto da conta', buttons });
      if (v === 'pick') return pickAvatarPhoto();
      if (v === 'rm') return removeAvatarPhoto();
      if (v === 'color') { await cycleAvatarColor(a); Sound.play('click'); return true; }
      return false;
    };
    const account = () => sub(A ? 'Conta ' + OSI().brand : 'Conta', c => {
      const a = acc(); const head = UI.el(`<div class="profile" style="justify-content:center;flex-direction:column;padding-top:20px">${myAvatar(a, 'lg')}<div class="name" style="margin-top:8px">@${UI.esc(a.username || '')}</div><div class="sub">${UI.esc(UI.phone(p().phone || ''))}</div></div>`);
      const big = head.querySelector('.avatar'); big.style.cursor = 'pointer';
      const afterAv = changed => { if (!changed) return; UI.pop(win); account(); win._paintRoot && win._paintRoot(); };
      big.onclick = async () => afterAv(await avatarMenu(a));
      c.appendChild(head);
      c.appendChild(UI.list([
        { header: 'Conta', items: [{ label: 'Nome de utilizador', value: '@' + (a.username || ''), onTap: async () => { const n = await UI.prompt('Nome de utilizador', '3-16 caracteres', 'username', a.username); if (!n) return; const u = n.trim().toLowerCase(); if (!/^[a-z0-9_.]{3,16}$/.test(u)) { UI.toast('Nome inválido'); return; } const r = await Bridge.rpc('account.usernameFree', { username: u }); if (r && r.ok === false) { UI.toast('Nome em uso'); return; } await Bridge.rpc('account.update', { username: u }); a.username = u; UI.pop(win); account(); } },
          { label: 'Avatar', value: a.avatarPhoto ? 'Foto' : 'Cor ' + (a.avatar || 1), right: myAvatar(a, 'xs'), onTap: async () => afterAv(await avatarMenu(a)) },   /* sem `nostop`: tocar no avatar pequeno também abre a folha */
          { label: 'Nome', value: (S.name || `${p().firstname} ${p().lastname}`).trim(), onTap: async () => { const n = await UI.prompt('Nome', 'Como te chamas', 'Nome', S.name); if (n !== null) { set({ name: n }); UI.pop(win); account(); } } }] },
        { header: 'Identificadores', items: [{ label: 'Account ID', value: a.account_id || NA }, { label: 'Device ID', value: a.device_id ? System.serial() : NA }, { label: 'SIM ID', value: a.sim_id || NA }, { label: 'Criada em', value: a.created ? UI.fmtDate(new Date(a.created), true) : NA }] },
        { header: 'Jogador', footer: 'A conta está ligada ao teu personagem: não há sessão para terminar.', items: [{ label: 'Personagem', value: `${p().firstname} ${p().lastname}` }, { label: 'Profissão', value: (p().job && p().job.label) || NA }, { label: 'Citizen ID', value: p().citizenid || NA }] }
        /* "Terminar sessão" retirado (auditoria 2026-09-17): só abria um alerta a dizer "Indisponível" */
      ]));
    });
    /* eSIM e linhas (2026-10-04): com o js/apps/esim.js carregado, a página é a do ESim (Serviço móvel no PearOS, Gestor de SIM
       na Nova UI: linhas, linha predefinida, Adicionar eSIM com o leitor de QR). Sem ele fica a página antiga (Trocar SIM).
       `from`: o nó tocado (onTap passa a linha), para a página empilhar por cima da vista certa no dobrável aberto */
    const sim = from => (window.ESim && ESim.page) ? ESim.page({ win, sub, from: from && from.nodeType === 1 ? from : null }) : simLegacy();
    const simVal = () => (window.ESim && ESim.noSim && ESim.noSim()) ? 'Sem SIM' : '';
    const simLegacy = () => sub(A ? 'Gestor de SIM' : 'SIM e número', c => { const a = acc(); c.appendChild(UI.list([
      { header: 'SIM atual', items: [{ label: 'Número', value: UI.phone(p().phone) }, { label: 'SIM ID', value: a.sim_id || NA }, { label: 'Operadora', value: 'Apex Mobile' }, { label: 'Estado', value: 'Ativo' }] },
      /* Roaming e VoLTE retirados: eram interruptores sem efeito nenhum. Os dados móveis ficaram e passaram a
         ter efeito: com eles (e o Wi-Fi) desligados, ou em modo de voo, o que precisa do servidor recusa (CC.online) */
      { header: 'Rede', footer: 'Sem dados móveis nem Wi-Fi os pedidos que precisam da rede recusam e dizem porquê.',
        items: [{ label: 'Dados móveis', toggle: S.cellular, onToggle: v => set(netPatch('cellular', v)) }] },
      { footer: 'Trocar de SIM gera um número novo. Os contactos que tinham o teu número antigo deixam de conseguir ligar-te.', items: [{ label: 'Trocar SIM', cls: 'danger center', chevron: false, onTap: async () => {
        /* a troca é um pedido ao servidor: com o modo de voo ligado (ou sem Wi-Fi nem dados) não sai daqui -
           os interruptores da rede têm efeito mesmo, e o CC.online é a fonte única disso */
        if (window.CC && CC.requireNet && !CC.requireNet('trocar o SIM')) return;
        if (!await UI.confirm('Trocar SIM', 'Vais receber um número novo. Esta ação não pode ser anulada.', 'Trocar', true)) return;
        /* rpcRaw e não rpc: o rpc engole o { error } e o 'busy' do servidor (5 números novos seguidos já ocupados, com o número ÚNICO)
           aparecia como "desativada". Resposta vazia (nil/false) ou RPC inexistente ('unknown:…') continua a ser desativada; qualquer
           outro erro (busy, ratelimit, db, internal, timeout) é passageiro e pede-se para tentar outra vez. */
        const r = await Bridge.rpcRaw('account.swapSim'); if (r && r.phone) { System.setPlayer({ phone: r.phone }); if (System.account) { System.account.phone = r.phone; System.account.sim_id = r.sim_id; } if (A && win._paintRoot) win._paintRoot(); UI.alert({ title: 'SIM trocado', msg: 'O teu novo número é ' + r.phone }); UI.pop(win); sim(); } else if (r && r.error && !String(r.error).startsWith('unknown')) UI.alert({ title: 'Trocar SIM', msg: 'Não foi possível obter um número novo. Tenta outra vez.' }); else UI.alert({ title: 'Indisponível', msg: 'A troca de SIM está desativada neste servidor.' }); } }] }
    ])); });

    /* ---------- Geral ---------- */
    const about = () => sub('Acerca', c => { const a = acc(); c.appendChild(UI.list([
      /* só dados REAIS deste telemóvel (spec 37): sem capacidade, MACs ou números de modelo inventados */
      { items: [{ label: 'Nome', value: System.deviceName(), onTap: () => renameDevice(() => { UI.pop(win); about(); }) }, { label: 'Versão do PearOS', value: (System.osInfo ? System.osInfo().osVersion : '27.2') }, { label: 'Nome do modelo', value: 'PearPhone 18 Pro' }, { label: 'Número de série', value: a.device_id || 'RK' + (p().citizenid || 'DEV0000').slice(-6).toUpperCase() }] },
      { items: [{ label: 'Número de telefone', value: UI.phone(p().phone) || NA }, { label: 'Rede', value: 'Apex Mobile' }, { label: 'SIM', value: a.sim_id || NA }, { label: 'Utilizador', value: a.username ? '@' + a.username : NA }] },
      { items: [{ label: 'Apps instaladas', value: String(System.installed().length) }, { label: 'Fotos', value: String((window.Photos && Photos.cache || []).length) }, { label: 'Contactos', value: String((window.Contacts && Contacts.cache || []).length) }, { label: 'Notas', value: String((Store.get('notes', []) || []).length) }] }
    ])); }, { back: 'Geral' });
    const update = () => sub('Atualização de Software', c => { c.appendChild(UI.el(`<div class="about-hero"><div style="display:flex;justify-content:center;margin-bottom:10px"><div class="tile" style="width:64px;height:64px">${Icons.tile('settings')}</div></div><div class="dev">PearOS 27.0</div><div class="muted small" style="margin-top:6px">O PearOS está atualizado</div></div>`)); c.appendChild(UI.list([{ footer: 'O telemóvel é atualizado pelo servidor: não há nada a descarregar aqui.' }])); }, { back: 'Geral' });   /* "Atualizações automáticas/beta" retirados: interruptores sem efeito */
    /* conteúdo REAL deste telemóvel (contagens do que existe): fotos, notas, lembretes, apps; barra proporcional entre categorias, sem capacidade inventada */
    const storage = () => sub('Armazenamento', c => { const cnt = { photos: (window.Photos && Photos.cache || []).length, notes: (Store.get('notes', []) || []).length, reminders: (Store.get('reminders', []) || []).length, apps: System.installed().length };
      const mb = { photos: cnt.photos * 2.4, notes: cnt.notes * .02, reminders: cnt.reminders * .01, apps: cnt.apps * 38 }; const tot = Object.values(mb).reduce((a, b) => a + b, 0) || 1; const fmt = v => v >= 1024 ? (v / 1024).toFixed(1).replace('.', ',') + ' GB' : Math.max(1, Math.round(v)) + ' MB';
      const COL = { photos: 'var(--yellow)', apps: 'var(--blue)', notes: 'var(--orange)', reminders: 'var(--red)' };
      c.appendChild(UI.el(`<div class="card" style="margin-top:14px"><div class="row between"><b>${A ? 'Conteúdo neste telemóvel' : 'Conteúdo neste PearPhone'}</b><span class="muted small">${fmt(tot)}</span></div><div style="display:flex;height:16px;border-radius:5px;overflow:hidden;margin-top:10px;background:var(--fill3)">${Object.keys(mb).map(k => `<span style="width:${(mb[k] / tot * 100).toFixed(1)}%;background:${COL[k]}"></span>`).join('')}</div></div>`));
      c.appendChild(UI.list([{ items: [['photos', cnt.photos + (cnt.photos === 1 ? ' foto' : ' fotos'), mb.photos], ['settings', cnt.apps + ' apps', mb.apps], ['notes', cnt.notes + (cnt.notes === 1 ? ' nota' : ' notas'), mb.notes], ['reminders', cnt.reminders + (cnt.reminders === 1 ? ' lembrete' : ' lembretes'), mb.reminders]].map(([id, l, v]) => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: id === 'settings' ? 'Apps' : App.name(id), sub: l, value: fmt(v), onTap: () => System.openApp(id === 'settings' ? 'appstore' : id) })) }])); }, { back: 'Geral' });
    /* Idioma: os 15 idiomas do L.ORDER estão traduzidos por inteiro (i18n.js + js/i18n-<código>.js, 2026-10-03), por isso é uma
       lista só, sem secções nem avisos de tradução parcial. Cada idioma aparece com o nome na própria língua (L.name) */
    const language = () => sub(L.t('Idioma'), c => { const cur = L.norm(S.lang || 'pt');
      const row = code => Object.assign({ label: L.name(code), chevron: false, onTap: () => { if (code === cur) return; L.set(code); set({ lang: code }); UI.pop(win); setTimeout(() => { UI.pop(win); if (A) generalA(); else general(); }, 460); } },   /* a lista Geral é refeita no idioma novo */
        A ? { right: UI.radio(cur === code) } : { value: cur === code ? g('check', 21) : '', valueHtml: true });
      c.appendChild(UI.list([{ items: L.ORDER.map(row) }])); }, { back: 'Geral' });   /* o título da página já diz "Idioma" */
    /* Data e hora, Teclado e Repor: as mesmas paginas no PearOS (Geral) e na Nova UI (Gestao geral) */
    const dateTimePage = () => sub(A ? 'Data e hora' : 'Data e Hora', cc => cc.appendChild(UI.list([{ items: [{ label: 'Formato 24 horas', toggle: S.clock24 !== false, onToggle: v => set({ clock24: v }) }, { label: 'Fonte da hora', value: 'Relógio do computador' }], footer: 'A hora da barra de estado vem do relógio do teu computador. O modo escuro automático segue a hora do jogo.' }])), { back: 'Geral' });
    const keyboardPage = () => sub('Teclado', cc => cc.appendChild(UI.list([{ footer: 'O teclado no ecrã aparece ao tocar num campo de texto. Podes escrever também com o teclado físico.', items: [{ label: 'Teclado no ecrã', toggle: S.kb === null || S.kb === undefined ? Bridge.inFiveM : !!S.kb, onToggle: v => set({ kb: v }) }] }])), { back: 'Geral' });
    const resetPage = () => sub('Repor', cc => cc.appendChild(UI.list([{ footer: 'Repor todas as definições mantém a conta, contactos e mensagens.', items: [{ label: 'Repor todas as definições', cls: 'blue', chevron: false, onTap: async () => { if (await UI.confirm('Repor definições', '', 'Repor', true)) { const keep = { installed: S.installed, perms: S.perms, deviceName: S.deviceName, setupDone: S.setupDone }; if (A) keep.fpEnrolled = S.fpEnrolled;   /* Nova UI: repor as definicoes nao apaga as impressoes digitais (no PearOS o rosto tambem fica) */ System.setState(Object.assign(JSON.parse(JSON.stringify(System.DEFAULTS)), keep));   /* cópia: os objetos dos DEFAULTS (notif, notifApps, cc…) não podem passar a ser o estado vivo; e repor as definições não volta a marcar o assistente como por fazer */ UI.toast('Definições repostas'); } } }] }, { footer: 'Apaga a conta e todos os dados deste telemóvel. Volta à configuração inicial.', items: [{ label: 'Apagar todo o conteúdo e definições', cls: 'danger', chevron: false, onTap: () => Setup.reset() }] }])), { back: 'Geral' });
    const general = () => sub('Geral', c => c.appendChild(UI.list([
      { items: [{ label: 'Acerca', onTap: about }, { label: 'Nome do dispositivo', value: System.deviceName(), onTap: () => renameDevice(() => { UI.pop(win); setTimeout(general, 0); }) }, { label: 'Atualização de Software', onTap: update }] },
      /* AirShare (pacote AD): a linha abre AirDrop.page e, ao voltar, acerta o valor no sítio (a lista Geral não se refaz); AirPlay e "Atualização em 2.º plano" continuam retirados: linhas que abriam nada */
      { items: [{ label: 'AirShare', value: window.AirDrop ? AirDrop.label() : 'Desligado', onTap: () => { if (!window.AirDrop) return; AirDrop.page(win, { onBack: () => { const li = [...c.querySelectorAll('.li')].find(x => { const l = x.querySelector('.li-label'); return l && String(window.I18N && I18N.source ? I18N.source(l) : l.textContent).trim() === 'AirShare'; }); const val = li && li.querySelector('.li-value'); if (val) val.textContent = AirDrop.label(); } }); } }, { label: 'Armazenamento do PearPhone', onTap: storage }] },
      { items: [{ label: 'Data e Hora', value: S.clock24 !== false ? '24 horas' : '12 horas', onTap: dateTimePage },
                { label: 'Teclado', onTap: keyboardPage },   /* "Maiúsculas automáticas" e "Emojis" retirados: sem efeito */
                { label: L.t('Idioma e Região'), value: L.name(S.lang || 'pt'), onTap: language }] },
      { items: [{ label: 'Transferir ou repor o PearPhone', cls: 'danger', chevron: true, onTap: resetPage }] }
    ])));

    /* ---------- Acessibilidade (PearOS, 1.5.0): texto, movimento e Liquid Glass. As chaves reduceTransparency / increaseContrast
       vivem no state e o System.apply() põe body.reduce-transparency / body.increase-contrast (glass27.css). ---------- */
    const access = () => sub('Acessibilidade', c => c.appendChild(UI.list([
      { header: 'Visibilidade', items: [{ label: 'Tamanho do texto', value: ({ small: 'Pequeno', normal: 'Normal', medium: 'Médio', large: 'Grande' })[S.textSize] || 'Normal', onTap: () => pick('Tamanho do texto', ['Pequeno', 'Normal', 'Médio', 'Grande'], ({ small: 'Pequeno', normal: 'Normal', medium: 'Médio', large: 'Grande' })[S.textSize] || 'Normal', v => set({ textSize: ({ Pequeno: 'small', Normal: 'normal', Médio: 'medium', Grande: 'large' })[v] || 'normal' }), 'Acessibilidade') }, { label: 'Etiquetas dos ícones', toggle: S.showLabels !== false, onToggle: v => set({ showLabels: v }) }] },
      { header: 'Liquid Glass', items: [{ label: 'Reduzir transparência', toggle: !!S.reduceTransparency, onToggle: v => set({ reduceTransparency: v }) }, { label: 'Aumentar contraste', toggle: !!S.increaseContrast, onToggle: v => set({ increaseContrast: v }) }], footer: 'Reduzir transparência: o vidro das barras, botões, notificações e Centro de controlo fica fosco e opaco, sem lente. Aumentar contraste: contorno forte e fundos opacos.' },
      { header: 'Movimento', items: [{ label: 'Reduzir movimento', toggle: !!S.reduceMotion, onToggle: v => set({ reduceMotion: v }) }], footer: 'As apps e os menus aparecem por desvanecimento, sem crescer do ícone nem efeito de mola.' }])), { back: 'Ecrã e brilho' });
    /* ---------- Ecrã ---------- */
    const display = () => sub('Ecrã e brilho', c => {
      c.appendChild(UI.el('<div class="group-header">Aparência</div>')); const opts = UI.el('<div class="group" style="display:flex;padding:16px;gap:14px;justify-content:center"></div>');
      [['Claro', 'light', '#F2F2F7', '#fff'], ['Escuro', 'dark', '#000', '#333'], ['Automático', 'auto', 'linear-gradient(135deg,#F2F2F7 50%,#000 50%)', '#888']].forEach(([l, v, bg, cc]) => { const o = UI.el(`<div style="text-align:center;cursor:pointer"><div style="width:84px;height:150px;border-radius:16px;background:${bg};border:3px solid ${S.theme === v ? 'var(--blue)' : 'transparent'};box-shadow:0 0 0 .5px var(--sep);padding:10px"><div style="height:8px;border-radius:4px;background:${cc};margin-bottom:6px"></div><div style="height:8px;border-radius:4px;background:${cc};width:70%"></div></div><div style="margin-top:8px;font-size:var(--t-subhead)">${l}</div><div class="check ${S.theme === v ? 'on' : ''}" style="margin:6px auto 0">${g('check')}</div></div>`); o.onclick = () => { set({ theme: v }); UI.pop(win); display(); }; opts.appendChild(o); });
      c.appendChild(opts); c.appendChild(UI.el('<div class="group-footer">Automático: escuro entre as 20h e as 7h (hora do jogo).</div>'));
      const glSlot = UI.el('<div class="lg-slot"></div>'); c.appendChild(glSlot);   /* PearOS 27.2: o Liquid Glass vive na secção Aparência, logo a seguir ao tema */
      const bright = UI.el(`<div class="group" style="padding:12px 16px;display:flex;align-items:center;gap:10px;margin-top:18px">${g('sun', 21)}<input type="range" min="10" max="100" value="${S.brightness}" style="flex:1;accent-color:var(--blue)" class="no-kb">${g('sun', 26)}</div>`); /* a arrastar só se mexe no overlay do brilho; System.apply() por evento (60x/s) invalidava o estilo do documento inteiro dentro do CEF */
      bright.querySelector('input').oninput = e => { S.brightness = +e.target.value; if (window.CC && CC.applyBrightness) CC.applyBrightness(S.brightness); }; bright.querySelector('input').onchange = () => set({});
      c.appendChild(UI.el('<div class="group-header">Brilho</div>')); c.appendChild(bright);
      /* PearOS 27: Liquid Glass afinável - de ultra-transparente a totalmente tingido. Arrastar mexe só nas variáveis --lg-*
         (System.apply é pesado); o valor grava-se ao largar. Pré-visualização: uma pílula de vidro por cima de um fundo colorido. */
      /* 1.5.0: a pré-visualização é o material novo (glass27.css .lg.lg-wp: cópia do fundo colorido por baixo, lente nas arestas, aresta e
         reflexo); o glass.js mede a posição das peças dentro da caixa (root = a própria pré-visualização) e o tom (a pílula troca de
         polaridade conforme a zona do gradiente). As peças são só peças: tocar nelas mostra o brilho e o crescer ao toque. */
      const gl = UI.el(`<div class="group lg-group"><div class="lg-pv"><div class="lg-pv-bg"></div><div class="lg-pv-pill lg lg-wp lg-tone">${g('search', 16)}<span>Liquid Glass</span></div><div class="lg-pv-row"><div class="lg-pv-dot lg lg-wp lg-tone">${g('flashlight', 17)}</div><div class="lg-pv-dot lg lg-wp lg-tone">${g('camera', 17)}</div><div class="lg-pv-dot lg lg-wp lg-tone">${g('plus', 17)}</div></div></div>
        <div class="lg-row lg-row27"><input type="range" min="0" max="100" value="${S.glassTint == null ? 50 : S.glassTint}" class="no-kb" style="flex:1;accent-color:var(--blue)"></div><div class="lg-marks"><span class="lg-lbl">Mais transparente</span><span class="lg-lbl">Predefinido</span><span class="lg-lbl">Mais tingido</span></div></div>`);   /* PearOS 27.2: as três marcas do cursor (o cursor não prende em nenhuma) */
      const pv = gl.querySelector('.lg-pv'); const pvSync = () => { if (!pv.isConnected || !pv.offsetWidth) return; pv.style.setProperty('--pv-w', pv.offsetWidth + 'px'); pv.style.setProperty('--pv-h', pv.offsetHeight + 'px'); pv.querySelectorAll('.lg-wp').forEach(n => { n.dataset.lgSrc = 'pv'; if (window.Glass) Glass.sync(n, { root: pv }); }); };
      requestAnimationFrame(pvSync); setTimeout(pvSync, 450);
      const glIn = gl.querySelector('input'); const glLive = v => { if (window.System && System.glassLive) System.glassLive(v); };
      glIn.oninput = e => glLive(e.target.value); glIn.onchange = e => set({ glassTint: Math.round(+e.target.value) });
      glSlot.appendChild(UI.el('<div class="group-header">Liquid Glass</div>')); glSlot.appendChild(gl); glSlot.appendChild(UI.el('<div class="group-footer">Ajusta a transparência do vidro em barras, botões, Centro de controlo, notificações e ecrã bloqueado. No meio fica como o PearOS de fábrica.</div>'));
      /* Acessibilidade do vidro (PearOS: Definições › Acessibilidade › Ecrã e tamanho do texto): aqui ao lado do cursor e numa página própria */
      c.appendChild(UI.list([{ header: 'Acessibilidade', items: [
        { label: 'Reduzir transparência', sub: 'Vidro fosco e opaco, sem lente nem desfoque', toggle: !!S.reduceTransparency, onToggle: v => set({ reduceTransparency: v }) },
        { label: 'Aumentar contraste', sub: 'Contorno forte e fundos opacos nas barras e botões', toggle: !!S.increaseContrast, onToggle: v => set({ increaseContrast: v }) },
        { label: 'Acessibilidade', sub: 'Texto, movimento e vidro', onTap: () => access() }], footer: 'Com qualquer uma destas opções o cursor Liquid Glass deixa de ter efeito: o vidro fica sempre opaco.' }]));
      const idx = ['small', 'normal', 'medium', 'large'].indexOf(S.textSize); c.appendChild(UI.el('<div class="group-header">Tamanho do texto</div>')); c.appendChild(UI.seg(['Pequeno', 'Normal', 'Médio', 'Grande'], idx < 0 ? 1 : idx, i => set({ textSize: ['small', 'normal', 'medium', 'large'][i] })));
      /* True Tone e "Levantar para ativar" retirados: guardavam o valor e nada os lia. O Night Shift passou a ser real (véu âmbar do system.js). */
      c.appendChild(UI.list([{ items: [{ label: 'Night Shift', toggle: S.nightShift, onToggle: v => set({ nightShift: v }) }], footer: 'Tinge o ecrã de âmbar, mais confortável à noite.' },
        { header: 'Movimento e hora', items: [{ label: 'Reduzir movimento', toggle: !!S.reduceMotion, onToggle: v => set({ reduceMotion: v }) }, { label: 'Formato 24 horas', toggle: S.clock24 !== false, onToggle: v => set({ clock24: v }) }], footer: 'Reduzir movimento: as apps e os menus aparecem por desvanecimento, sem crescer do ícone nem efeito de mola. Desligar as 24 horas mostra "9:41" em vez de "09:41".' },
        { items: [{ label: 'Bloqueio automático', value: S.autoLock, onTap: () => pick('Bloqueio automático', ['30 segundos', '1 minuto', '2 minutos', '5 minutos', '10 minutos', 'Nunca'], S.autoLock, v => set({ autoLock: v }), 'Ecrã') }, { label: 'Bloquear ao fechar o telemóvel', toggle: S.lockOnClose, onToggle: v => set({ lockOnClose: v }) }, { label: 'Etiquetas dos ícones', toggle: S.showLabels !== false, onToggle: v => set({ showLabels: v }) },
          /* PearOS 27 (1.4.0): estilo dos ícones (Predefinido/Escuro/Transparente/Colorido), cor e tamanho - a folha Personalizar vive por
             cima do ecrã principal (é lá que se vê o resultado), por isso fecha-se as Definições primeiro */
          ...(System.os !== 'android' && window.HomeCustom ? [{ label: L.t('Ícones'), sub: L.t('Estilo, cor e tamanho'), onTap: () => { System.closeApp(true); setTimeout(() => { if (window.Home && Home.openCustomize) Home.openCustomize(); }, 500); } }] : [])], footer: 'O bloqueio automático também conta com uma app aberta; uma chamada em curso e a câmara mantêm o ecrã aceso.' },
        { header: 'Tamanho do telemóvel no ecrã', footer: 'Só no jogo. Pequeno ocupa menos espaço.', items: [{ html: '<div class="seg scale-seg" style="margin:0;flex:1"></div>', cls: 'static' }] }]));
      /* classe própria: um querySelector('.seg') apanhava o seletor de "Tamanho do texto" criado acima e trocava os dois controlos */
      /* tamanhos subidos com o Config.Scale (0.6 → 0.68): o "Médio" tem de bater certo com o
         valor por omissão, senão a conta que nunca escolheu nada mostrava a opção errada */
      const segEl = c.querySelector('.scale-seg'); const SC = [['Pequeno', 0.72], ['Médio', 0.84], ['Grande', 0.98]]; const curI = Math.max(0, SC.findIndex(x => Math.abs((S.phoneScaleV2 || 0.84) - x[1]) < .03));
      segEl.replaceWith(UI.seg(SC.map(x => x[0]), curI < 0 ? 1 : curI, i => set({ phoneScaleV2: SC[i][1] })));
    });
    const accent = () => sub('Cor de destaque', c => { const row = UI.el('<div class="accent-row"></div>'); ['#0088FF', '#5E5CE6', '#BF5AF2', '#FF375F', '#FF453A', '#FF9F0A', '#FFD60A', '#30D158', '#00C7BE', '#64D2FF', '#AC8E68', '#8E8E93'].forEach(h => { const d = UI.el(`<div class="${S.accent === h ? 'on' : ''}" style="background:${h}"></div>`); d.onclick = () => { set({ accent: h }); [...row.children].forEach(x => x.classList.toggle('on', x === d)); }; row.appendChild(d); }); c.appendChild(UI.el('<div class="group-header">Cor do sistema</div>')); c.appendChild(row);
      c.appendChild(UI.list([{ footer: 'A cor aplica-se a botões, ligações, seleções, widgets, Centro de controlo e ecrã bloqueado.', items: [{ label: 'Interruptores com a cor de destaque', toggle: S.accentToggles, onToggle: v => set({ accentToggles: v }) }, { label: 'Cor personalizada (hex)', value: S.accent, onTap: async () => { const h = await UI.prompt('Cor', 'Formato #RRGGBB', '#0088FF', S.accent); if (h && /^#[0-9a-f]{6}$/i.test(h)) { set({ accent: h.toUpperCase() }); UI.pop(win); accent(); } } }] }])); });
    /* ---------- Fundo (PearOS 17+) ----------
       O PAR atual lado a lado - ecrã bloqueado (com o relógio dele) e ecrã principal (com os ícones verdadeiros) - com "Personalizar"
       por baixo de cada um e "+ Adicionar novo fundo". Os pares são os ecrãs da galeria do bloqueado (LockGallery): desliza-se entre
       eles e "Usar este fundo" torna um deles o atual. Antes esta página escrevia `wallpaper` direto e o bloqueado ficava para trás;
       agora tudo passa pela galeria, que aplica SEMPRE os dois ecrãs de uma vez. */
    const wallpaper = () => sub(A ? 'Fundos' : 'Fundo', (c, v) => {
      const LG = window.LockGallery;
      /* Personalizar: sai das Definições para o editor (o PearPhone também o mostra em ecrã inteiro) e volta aqui no fim */
      const customize = (ls, kind) => { if (ls.id !== S.lockCurrent) LG.use(ls.id); System.closeApp(true); Lock.lock(); setTimeout(() => LG.openEditor(kind, 'settings'), 650); };   /* mesmo caminho do "Personalizar ecrã bloqueado" (Ecrã bloqueado) */
      const paint = () => {
        c.innerHTML = ''; LG.sync(); const l = LG.list(); const curI = Math.max(0, l.findIndex(x => x.id === S.lockCurrent));
        const linkOn = !!(LG.addFromLink && (!System.config || !System.config.wallpaperLinks || System.config.wallpaperLinks.enabled !== false));
        const card = UI.el(`<div class="lsg-set"><div class="lsg-set-car"></div>${l.length > 1 ? '<div class="lsg-set-dots"></div>' : ''}<div class="lsg-set-add">${g('plus', 20)}<span>Adicionar novo fundo</span></div>${linkOn ? `<div class="lsg-set-add lsg-set-link">${g('link', 18)}<span>Adicionar imagem por link</span></div>` : ''}</div>`);
        const car = card.querySelector('.lsg-set-car'), dots = card.querySelector('.lsg-set-dots');
        /* dobráveis: o bloqueado e o principal têm a largura do ecrã do estado atual (670 fechado, 1340 aberto: System.SW), por isso
           as miniaturas ficam com essa forma em vez da do telemóvel (440×956). A caixa de dentro passa a ter essa largura
           (apps.css, .lsg-thumb.fold, --fold-w) e reduz-se à largura pedida. */
        const fold = !!(UI.isFold && UI.isFold()), TW = fold ? 176 : 144, FW = (fold && System.SW) || 880;
        /* os cantos são os do ecrã do aparelho (PearPhone Fold: fechado 6/74/74/6, aberto 54; system.css --scr-*), reduzidos */
        const bcs = getComputedStyle(document.body), scrR = ['--scr-tl', '--scr-tr', '--scr-br', '--scr-bl'].map(n => parseFloat(bcs.getPropertyValue(n)));
        const mkThumb = (kind, ls) => { const th = LG.thumb(kind, ls, TW); if (!fold) return th; const k = TW / FW;
          th.classList.add('fold'); th.style.height = Math.round(956 * k) + 'px'; th.style.borderRadius = scrR.every(x => isFinite(x)) ? scrR.map(x => Math.round(x * k * 10) / 10 + 'px').join(' ') : Math.round(57 * k) + 'px';
          if (th.firstElementChild) th.firstElementChild.style.transform = `scale(${k.toFixed(4)})`; return th; };
        /* o atual primeiro (é o que se vê ao entrar, como no PearPhone); os outros a seguir, pela ordem da galeria */
        const order = [curI].concat(l.map((_, i) => i).filter(i => i !== curI));
        order.forEach(i => { const ls = l[i], isCur = i === curI;
          const pg = UI.el(`<div class="lsg-set-page"><div class="lsg-set-state ${isCur ? '' : 'use'}">${isCur ? g('check', 14) + '<span>Atual</span>' : '<span>Usar este fundo</span>'}</div><div class="lsg-set-pair"><div class="lsg-set-col"></div><div class="lsg-set-col"></div></div></div>`);
          if (!isCur) pg.querySelector('.lsg-set-state').onclick = () => { LG.use(ls.id); Sound.play('click'); UI.toast('Fundo aplicado'); paint(); };
          [['lock', 'Ecrã bloqueado'], ['home', 'Ecrã principal']].forEach(([kind, cap], j) => { const col = pg.querySelectorAll('.lsg-set-col')[j];
            const th = mkThumb(kind, ls); th.onclick = () => customize(ls, kind); col.appendChild(th);
            col.appendChild(UI.el(`<div class="lsg-set-cap">${UI.esc(cap)}</div>`));
            const b = UI.el('<div class="lsg-set-btn">Personalizar</div>'); b.onclick = () => customize(ls, kind); col.appendChild(b); });
          car.appendChild(pg); });
        if (dots) { dots.innerHTML = order.map((_, k) => `<span class="${k ? '' : 'on'}"></span>`).join(''); car.addEventListener('scroll', () => { const k = Math.round(car.scrollLeft / Math.max(1, car.clientWidth)); [...dots.children].forEach((d, n) => d.classList.toggle('on', n === k)); }, { passive: true }); }
        /* + Adicionar novo fundo: o seletor abre aqui mesmo; o fundo escolhido nasce como PAR e fica logo nos dois ecrãs */
        card.querySelector('.lsg-set-add').onclick = () => { Sound.play('click'); LG.addNew(() => { UI.toast('Fundo definido no ecrã bloqueado e no principal'); paint(); }); };
        /* "upload image" (1.1.4): link direto (Discord, Imgur…) ou imagem colada; nasce também como par */
        const lk = card.querySelector('.lsg-set-link'); if (lk) lk.onclick = () => { Sound.play('click'); LG.addFromLink(() => { UI.toast('Fundo definido no ecrã bloqueado e no principal'); paint(); }); };
        c.appendChild(card);
        c.appendChild(A ? UI.el('<div class="group-footer" style="text-align:center;padding-top:10px">Um fundo novo aplica-se ao ecrã bloqueado e ao ecrã principal. Em Personalizar podes mudar cada um: cor, gradiente, uma foto ou desfocar o ecrã principal.</div>')
          : UI.el('<div class="group-footer" style="text-align:center;padding-top:10px">Um fundo novo aplica-se ao ecrã bloqueado e ao ecrã principal. Em Personalizar podes mudar cada um: cor, gradiente, uma foto ou desfocar o ecrã principal.</div>'));
        c.appendChild(UI.list([{ footer: 'Também podes manter pressionado o ecrã bloqueado para ver e trocar todos os fundos.', items: [{ label: 'Ecrã bloqueado', icon: 'lock', iconBg: 'var(--gray)', onTap: () => A ? lockA() : lockscreen() }] }]));
      };
      if (!LG || !LG.thumb) { c.appendChild(UI.el('<div class="group-footer">A personalização de fundos não está disponível.</div>')); return; }
      paint();
      /* os fundos mudam com a página aberta (editor, Fotos, Vera): com as Definições à vista repinta já; em segundo plano só
         marca e repinta quando a app volta - cada pintura copia a home, não vale a pena fazê-la a cada toque no editor */
      let dirty = false; const repaint = () => { clearTimeout(paint._t); paint._t = setTimeout(() => { dirty = false; if (c.isConnected) paint(); }, 120); };
      const off1 = Bridge.on('wallpaper:changed', () => { if (System.currentApp() === 'settings') repaint(); else dirty = true; });
      const off2 = Bridge.on('app:open', id => { if (id === 'settings' && dirty) repaint(); });
      /* trocar de aparelho, abrir ou fechar o dobrável com a página aberta: as miniaturas mudam de forma e de cantos (espera-se a
         home refazer-se, a cópia vem dela) */
      const reshape = () => { clearTimeout(paint._t); paint._t = setTimeout(() => { dirty = false; if (c.isConnected) paint(); }, 450); };
      const off3 = Bridge.on('form:changed', reshape), off4 = Bridge.on('fold:state', reshape);
      v.opts.onPop = () => { if (off1) off1(); if (off2) off2(); if (off3) off3(); if (off4) off4(); };
    });
    /* abre o editor do ecrã bloqueado do PearOS já na folha pedida ('clock' = Fonte e cor, 'widgets' = Adicionar widgets); no fim volta-se às Definições */
    const openLG = k => { System.closeApp(true); Lock.lock(); setTimeout(() => { const LGx = window.LockGallery; if (LGx && LGx.openEditor) LGx.openEditor(k, 'settings'); else if (LGx) LGx.open(true); }, 650); };
    const lockscreen = () => sub('Ecrã bloqueado', c => {
      c.appendChild(UI.list([{ items: [{ label: 'Personalizar ecrã bloqueado', cls: 'blue', chevron: false, onTap: () => { System.closeApp(true); Lock.lock(); setTimeout(() => window.LockGallery && LockGallery.open(true), 650); } }], footer: 'Ou mantém pressionado o ecrã bloqueado.' }, { header: 'Relógio', footer: 'Compacto (PearOS 27): a hora fica pequena ao lado da data e dos widgets, no topo, e o fundo aparece inteiro.', items: [{ label: 'Relógio compacto', toggle: !!S.clockCompact, onToggle: v => set({ clockCompact: v }) }, { label: 'Fonte e cor', value: ((((window.LockGallery && LockGallery.FONTS) || []).find(f => f[0] === S.clockFont) || [0, S.clockFont === 'thin' ? 'Fina' : 'Padrão'])[1]), onTap: () => openLG('clock') }] }]));   /* a folha "Fonte e cor" do editor do bloqueado (grava no ecrã bloqueado atual, como a galeria) */
      const row = UI.el('<div class="accent-row"></div>'); ['#FFFFFF', '#FFD60A', '#FF9F0A', '#FF375F', '#BF5AF2', '#64D2FF', '#30D158', '#000000'].forEach(h => { const d = UI.el(`<div class="${S.clockColor === h ? 'on' : ''}" style="background:${h}"></div>`); d.onclick = () => { set({ clockColor: h }); [...row.children].forEach(x => x.classList.toggle('on', x === d)); }; row.appendChild(d); }); c.appendChild(UI.el('<div class="group-header">Cor do relógio</div>')); c.appendChild(row);
      const W = [['weather', 'Meteorologia'], ['battery', 'Bateria'], ['calendar', 'Calendário'], ['alarm', 'Alarme'], ['reminders', 'Lembretes']]; c.appendChild(UI.list([{ header: 'Always-On Display', footer: 'Desligado, o botão lateral apaga mesmo o ecrã. Ligado, mantém a hora esbatida sobre o fundo escurecido.', items: [{ label: 'Sempre ligado', toggle: S.alwaysOn === true, onToggle: v => set({ alwaysOn: v }) }] }, { header: 'Widgets', items: [{ label: 'Adicionar widgets', value: String(window.Lock && Lock.widgets ? Lock.widgets.fit(S.lockWidgetsV2).length : (S.lockWidgetsV2 || []).length), onTap: () => openLG('widgets') }] }, { header: 'Notificações', items: [{ label: 'Notificações no ecrã bloqueado', value: 'Por app', onTap: () => notifs() }], footer: 'Em Notificações escolhes, app a app, se aparecem no ecrã bloqueado e se mostram o conteúdo.' }]));   /* os dois interruptores que aqui estavam não faziam nada */
    });
    const sounds = () => sub('Sons e háptica', c => { const sl = (label, key, icon) => { const e = UI.el(`<div class="group" style="padding:10px 16px;display:flex;align-items:center;gap:10px;margin-top:8px">${g(icon, 18)}<input type="range" min="0" max="100" value="${S[key]}" class="no-kb" style="flex:1;accent-color:var(--blue)"><span class="muted small" style="width:36px;text-align:right">${S[key]}%</span></div>`); e.querySelector('input').oninput = ev => { S[key] = +ev.target.value; e.querySelector('span').textContent = S[key] + '%'; }; e.querySelector('input').onchange = () => { set({}); Sound.play(key === 'callVolume' ? 'connect' : 'notify'); }; c.appendChild(UI.el(`<div class="group-header">${label}</div>`)); c.appendChild(e); };
      sl('Volume geral', 'volume', 'speaker'); sl('Notificações', 'notifVolume', 'bell'); sl('Toque e chamadas', 'callVolume', 'phone');
      c.appendChild(UI.list([{ items: [{ label: 'Sons do sistema', toggle: S.sounds, onToggle: v => set({ sounds: v }) }, { label: 'Som das notificações', toggle: S.notifSound, onToggle: v => set({ notifSound: v }) }] },   /* "Háptica" retirada: não há vibração num PC e nada lia a chave */
        { header: 'Toques', items: [{ label: 'Toque', value: S.ringtone, onTap: () => sub('Toque', cc => cc.appendChild(UI.list([{ items: Sound.RING.map(r => ({ label: r, value: r === S.ringtone ? g('check', 21) : '', valueHtml: true, chevron: false, onTap: () => { set({ ringtone: r }); const stop = Sound.ring(r); setTimeout(stop, 2500); UI.pop(win); } })) }])), { back: 'Sons' }) }] }])); });   /* "Som de mensagem" retirado (auditoria 2026-09-17): o notify.js toca sempre 'message', a escolha não mudava nada */
    /* página de UMA app: Permitir, Ecrã bloqueado, Banners, Sons, Emblemas e Pré-visualizações (notifApps[app]) */
    const notifApp = (id, back, onChange) => sub(App.name(id), (c, v) => {
      const paint = () => { c.innerHTML = ''; const n = nCfg(id); const ch = (patch, repaint) => { nSet(id, patch); if (repaint) paint(); };
        c.appendChild(UI.list([{ items: [{ label: 'Permitir notificações', toggle: n.allow, onToggle: x => ch({ allow: x }, true) }], footer: n.allow ? '' : `${App.name(id)} não mostra notificações, nem no centro de notificações.` }].concat(n.allow ? [
          { header: 'Alertas', items: [{ label: 'Ecrã bloqueado', toggle: n.lock, onToggle: x => ch({ lock: x }) }, { label: 'Banners', toggle: n.banner, onToggle: x => ch({ banner: x }) }], footer: 'Sem banners, a notificação entra só no centro de notificações (o som segue o interruptor Sons). Sem Ecrã bloqueado, não aparece no ecrã bloqueado.' },
          { items: [{ label: 'Sons', toggle: n.sound, onToggle: x => ch({ sound: x }) }, { label: 'Emblemas', toggle: n.badge, onToggle: x => ch({ badge: x }) }], footer: 'Emblemas: o número vermelho no ícone da app no ecrã principal.' },
          { header: 'Aparência no ecrã bloqueado', items: [{ label: 'Pré-visualizações', value: pvLabel(n.preview), onTap: () => pick('Pré-visualizações', PREVIEW.map(x => x[1]), pvLabel(n.preview), lbl => { ch({ preview: (PREVIEW.find(x => x[1] === lbl) || PREVIEW[0])[0] }); setTimeout(() => { if (c.isConnected) paint(); }, 0); }, App.name(id)) }], footer: A ? 'Nunca: o cartão mostra só o nome da app, sem o texto. Quando desbloqueado: o texto só aparece com o telemóvel desbloqueado.' : 'Nunca: o cartão mostra só o nome da app, sem o texto. Quando desbloqueado: o texto só aparece com o PearPhone desbloqueado.' }] : []))); };
      paint(); v.opts.onPop = () => { if (onChange) onChange(); };
    }, { back });
    const notifs = () => sub('Notificações', c => {
      const paint = () => { c.innerHTML = ''; const ids = System.installed(); const on = S.notifAll !== false;
        const pvs = ids.map(id => nCfg(id).preview); const same = pvs.length && pvs.every(x => x === pvs[0]);
        c.appendChild(UI.list([{ items: [{ label: 'Permitir notificações', toggle: on, onToggle: v => { set({ notifAll: v }); paint(); } }], footer: on ? '' : 'Nenhuma app mostra notificações. As chamadas continuam a tocar.' }]));
        if (!on) return;
        /* Nova UI: sem a Dynamic Island nem os mini-telemoveis do "Mostrar como" (sao do PearOS); o Nao incomodar vive nos Modos */
        if (A) { const ids2 = ids; c.appendChild(UI.list([
          { items: [{ label: 'Não incomodar', value: S.dnd ? 'Ligado' : 'Desligado', onTap: () => { const fv = focus(); const prev = fv.opts.onPop; fv.opts.onPop = () => { if (prev) prev(); if (c.isConnected) paint(); }; } },
            { label: 'Pré-visualizações', value: same ? pvLabel(pvs[0]) : 'Varia por app', onTap: () => pick('Pré-visualizações', PREVIEW.map(x => x[1]), same ? pvLabel(pvs[0]) : '', lbl => { const val = (PREVIEW.find(x => x[1] === lbl) || PREVIEW[0])[0]; const all = Object.assign({}, S.notifApps || {}), legacy = Object.assign({}, S.notif || {}); ids2.forEach(id => nPatch(all, legacy, id, { preview: val })); set({ notifApps: all, notif: legacy }); setTimeout(() => { if (c.isConnected) paint(); }, 0); }, 'Notificações') },
            { label: 'Histórico de notificações', onTap: () => Notify.openNC() }] },
          { header: 'Notificações das apps', items: ids2.map(id => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), sub: nSummary(id), onTap: () => notifApp(id, 'Notificações', () => { if (c.isConnected) paint(); }) })) }])); return; }
        /* "Mostrar como" (iOS 16+): Contagem · Pilha · Lista - como aparecem no ecrã bloqueado (notify.js lê S.notifDisplay) */
        const cur = ['count', 'stack', 'list'].includes(S.notifDisplay) ? S.notifDisplay : 'stack';
        const mini = k => `<div class="nd-ph"><i class="t"></i>${k === 'count' ? '<i class="c"></i>' : k === 'stack' ? '<i class="s1"></i><i class="s2"></i>' : '<i class="l"></i><i class="l"></i><i class="l"></i>'}</div>`;
        const disp = UI.el(`<div><div class="group-header">Mostrar como</div><div class="group nd-pick">${[['count', 'Contagem'], ['stack', 'Pilha'], ['list', 'Lista']].map(([k, l]) => `<div class="nd-opt ${k === cur ? 'on' : ''}" data-k="${k}">${mini(k)}<span>${l}</span></div>`).join('')}</div><div class="group-footer">Escolhe como as notificações aparecem no ecrã bloqueado.</div></div>`);
        disp.querySelectorAll('.nd-opt').forEach(o => o.onclick = () => { set({ notifDisplay: o.dataset.k }); disp.querySelectorAll('.nd-opt').forEach(x => x.classList.toggle('on', x === o)); Sound.play('click'); if (window.Notify && Notify.collapseLock) Notify.collapseLock(); });
        c.appendChild(disp);
        c.appendChild(UI.list([
          { items: [{ label: 'Mostrar na Dynamic Island', toggle: S.islandNotifs, onToggle: v => set({ islandNotifs: v }) },
            /* pré-visualização GERAL = aplicar a todas as apps de uma vez (cada app pode depois ter a sua) */
            { label: 'Pré-visualizações', value: same ? pvLabel(pvs[0]) : 'Varia por app', onTap: () => pick('Pré-visualizações', PREVIEW.map(x => x[1]), same ? pvLabel(pvs[0]) : '', lbl => { const val = (PREVIEW.find(x => x[1] === lbl) || PREVIEW[0])[0]; const all = Object.assign({}, S.notifApps || {}), legacy = Object.assign({}, S.notif || {}); ids.forEach(id => nPatch(all, legacy, id, { preview: val })); set({ notifApps: all, notif: legacy }); setTimeout(() => { if (c.isConnected) paint(); }, 0); }, 'Notificações') },
            { label: 'Histórico', onTap: () => Notify.openNC() }] },
          { header: 'Por app', items: ids.map(id => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), sub: nSummary(id), onTap: () => notifApp(id, 'Notificações', () => { if (c.isConnected) paint(); }) })) }])); };
      paint(); });
    /* Foco (Fase 1: S.focus none/dnd/work/sleep). Um de cada vez; o System mantém o antigo `dnd` a par, que é o que silencia as notificações */
    const focus = () => sub(A ? 'Modos e rotinas' : 'Foco', c => { const F = [['dnd', 'Não incomodar', 'moon', 'var(--indigo)'], ['work', 'Trabalho', 'briefcase', 'var(--teal)'], ['sleep', 'Dormir', 'moon', 'var(--purple)']];
      /* o `dnd` é o interruptor mestre (como no control.js e no notify.js): sem ele não há foco, com ele o foco é o escolhido ou "Não incomodar" */
      const paint = () => { c.innerHTML = ''; const f = !S.dnd ? 'none' : (S.focus && S.focus !== 'none' && F.some(x => x[0] === S.focus) ? S.focus : 'dnd');
        c.appendChild(UI.list([{ items: F.map(([k, l, ic, bg]) => ({ label: l, icon: ic, iconBg: bg, toggle: f === k, onToggle: v => { set({ focus: v ? k : 'none' }); paint(); } })) }, { footer: A ? 'Só um modo de cada vez. Com qualquer modo ligado as notificações ficam silenciosas e sem avisos flutuantes, como no "Não incomodar"; Trabalho e Dormir ainda não têm listas de apps permitidas.' : 'Só um foco de cada vez. Com qualquer foco ligado as notificações ficam silenciosas e sem banners, como no "Não incomodar"; Trabalho e Dormir ainda não têm listas de apps permitidas.' }])); };
      paint(); });
    /* a lista é o CC.TILES: os mosaicos que saíram (Rotação, Espelhar ecrã, "Reconhecer") desapareceram daqui
       sozinhos, e uma conta que os tivesse escolhidos deixa de os ver no Centro de controlo */
    const cc = () => sub('Centro de controlo', c => { const all = Object.keys(CC.TILES); c.appendChild(UI.list([{ header: 'Controlos incluídos', footer: 'Ativa ou desativa atalhos. A ordem segue a ordem desta lista.', items: all.map(k => ({ icon: CC.TILES[k].icon, iconBg: 'var(--gray)', label: CC.TILES[k].label, toggle: (S.cc || []).includes(k), onToggle: v => { let l = (S.cc || []).filter(x => x !== k); if (v) l.push(k); set({ cc: l }); } })) }, { items: [{ label: 'Abrir Centro de controlo', cls: 'center', chevron: false, onTap: () => CC.open() }] }])); });
    /* Apps externas - autorizações GRAVADAS NO SERVIDOR (apps.grants). As listas por tipo acima mostram o que o Perm deste
       telemóvel sabe; o servidor pode ter mais: um "uma vez" de antes de o NUI recarregar (o servidor guarda-o até a personagem
       sair), ou um "Permitir" cujo apps.revoke não chegou lá. Sem isto não havia forma de o ver nem de o tirar.
       A secção só aparece quando o servidor tem alguma. items/once podem chegar como {} (tabela vazia do Lua).
       Revogar:
         - o Perm ainda a dá (Permitir ou "uma vez" desta sessão) → Perm.set(app, tipo, false), como o interruptor da lista por
           tipo: o thirdparty.js vê o Perm mudar, manda o apps.revoke e esquece a sua cache (um apps.revoke direto deixava essa
           cache a dizer que existia e o próximo "Permitir" não voltava a gravar no servidor);
           confirma-se 1,5 s depois e, se o servidor ainda a tiver (cache do thirdparty vazia porque o apps.grants do arranque
           falhou), pede-se direto;
         - o Perm não a conhece ou já a recusa → apps.revoke direto (com once:true numa "uma vez", que não mexe no "Permitir"). */
    const extGrants = async c => {
      const host = UI.el('<div class="ext-grants"></div>'); c.appendChild(host);
      const vals = v => Array.isArray(v) ? v : (v && typeof v === 'object' ? Object.values(v) : []);
      const valid = x => x && typeof x.app === 'string' && typeof x.perm === 'string' && x.app !== '' && x.perm !== '';
      const load = async () => { let r = null; try { r = await Bridge.rpcRaw('apps.grants', {}); } catch (e) {} if (!r || typeof r !== 'object' || r.error) return null;
        const rows = vals(r.items).filter(valid).map(x => ({ app: x.app, perm: x.perm, once: false }));
        vals(r.once).filter(valid).forEach(x => { if (!rows.some(y => y.app === x.app && y.perm === x.perm)) rows.push({ app: x.app, perm: x.perm, once: true }); });
        return rows; };
      /* o id vem do servidor (validado lá, mas pode ser "__proto__"): um ícone que rebentasse não pode levar a página inteira */
      const tile = id => { try { return Icons.tile(id); } catch (e) { return Icons.tile('settings'); } };
      let rows = await load();
      if (!rows || !host.isConnected) return;
      const direct = row => Bridge.rpc('apps.revoke', row.once ? { app: row.app, perm: row.perm, once: true } : { app: row.app, perm: row.perm });
      const revoke = row => {
        const allowed = Perm.get(row.app, row.perm) === true || !!(Perm.isOnce && Perm.isOnce(row.app, row.perm));
        if (allowed) {
          Perm.set(row.app, row.perm, false);
          setTimeout(async () => { const again = await load(); if (again && again.some(y => y.app === row.app && y.perm === row.perm) && Perm.get(row.app, row.perm) !== true) direct(row); }, 1500);
        } else direct(row);
        rows = rows.filter(y => y !== row); paint(); UI.toast('Autorização revogada');
      };
      const paint = () => { host.innerHTML = ''; if (!rows.length) return;
        host.appendChild(UI.list([{ header: A ? 'Apps externas: autorizações no servidor' : 'Apps externas: autorizações no servidor', footer: A ? 'O que o servidor aceita que cada app externa faça em teu nome. "Uma vez" termina quando a app é fechada nas apps recentes ou quando sais.' : 'O que o servidor aceita que cada app externa faça em teu nome. "Uma vez" termina quando a app é fechada no alternador ou quando sais.',
          items: rows.map(row => { const b = UI.el('<div class="pill-btn red nostop">Revogar</div>'); b.onclick = e => { e.stopPropagation(); revoke(row); };
            return { icon: tile(row.app), tile: true, iconBg: 'transparent', label: App.name(row.app), sub: (Perm.KINDS[row.perm] || row.perm) + (row.once ? ' · uma vez' : ''), right: b }; }) }])); };
      paint();
    };
    /* uma permissao (Camara, Localizacao...): as apps que a pediram, com o interruptor de cada uma */
    const permKind = k => sub(Perm.KINDS[k], cc2 => { const apps = Perm.apps(k); if (k === 'location') cc2.appendChild(UI.list([{ items: [{ label: 'Serviços de localização', toggle: S.locationOn, onToggle: v => set({ locationOn: v }) }] }])); cc2.appendChild(apps.length ? UI.list([{ header: 'Apps que pediram acesso', footer: k === 'location' && !S.locationOn ? 'Com os serviços de localização desligados nenhuma app recebe a tua posição, mesmo as que têm acesso.' : (apps.some(a => a.once) ? (A ? '"Permitido uma vez" dura até a app ser fechada nas apps recentes.' : '"Permitido uma vez" dura até a app ser fechada no alternador.') : ''), items: apps.map(a => ({ icon: Icons.tile(a.app), tile: true, iconBg: 'transparent', label: App.name(a.app), sub: a.once ? 'Permitido uma vez' : '', toggle: a.allowed, onToggle: v => Perm.set(a.app, k, v) })) }]) : UI.el('<div class="group-footer">Nenhuma app pediu acesso ainda.</div>')); }, { back: 'Privacidade' });
    const permItems = () => Object.keys(Perm.KINDS).map(k => ({ label: Perm.KINDS[k], icon: Perm.ICON[k], iconBg: ({ camera: 'var(--gray)', mic: 'var(--orange)', photos: 'var(--blue)', location: 'var(--blue)', contacts: 'var(--gray)', notifications: 'var(--red)', sms: 'var(--green)', bank: 'var(--green)' })[k], value: k === 'location' ? (S.locationOn ? 'Ativado' : 'Desativado') : '', onTap: () => permKind(k) }));
    const privacy = () => sub('Privacidade e segurança', (c, pv) => { c.appendChild(UI.list([{ items: permItems() }, { items: [{ label: 'Relatório de privacidade', onTap: privReport }] }])); msgPrivacy(c, pv); extGrants(c); });
    /* Fase 2 - Mensagens e chamadas. O servidor (server/messages.lua) lê settings.readReceipts e settings.lastSeen da conta
       (o System.setState grava o estado inteiro no account.update); sem estes interruptores ficavam sempre ligados.
       Por omissão ligados: só um false explícito desliga. Os bloqueados são os do phone.js (Contacts / blockedView). */
    const msgPrivacy = (c, pv) => {
      const nBlocked = () => { try { return window.Contacts && Array.isArray(Contacts.blocked) ? Contacts.blocked.length : 0; } catch (e) { return 0; } };
      const box = UI.el('<div></div>'); c.appendChild(box);
      const paint = () => { box.innerHTML = ''; const n = nBlocked();
        box.appendChild(UI.list([{ header: 'Mensagens e chamadas',
          footer: 'Recibos de leitura: desligados, quem te escreve deixa de ver "Lida" nas conversas contigo e tu também deixas de o ver nas tuas. Nos grupos as tuas leituras continuam a contar para quem enviou. Visto por último e online: desligado, ninguém vê se estás online nem quando estiveste pela última vez.',
          items: [{ label: 'Enviar recibos de leitura', icon: 'check', iconBg: 'var(--blue)', toggle: S.readReceipts !== false, onToggle: v => set({ readReceipts: v }) },
            { label: 'Visto por último e online', icon: 'eye', iconBg: 'var(--green)', toggle: S.lastSeen !== false, onToggle: v => set({ lastSeen: v }) },
            { label: 'Contactos bloqueados', icon: 'ban', iconBg: 'var(--red)', value: n ? String(n) : '', onTap: () => { if (typeof blockedView === 'function') blockedView(win, 'Privacidade'); else UI.toast('Contactos indisponíveis'); } }] }])); };
      paint();
      /* a contagem acompanha um bloqueio feito noutro sítio (a lista dos bloqueados, uma conversa). O ouvinte sai no
         onPop da vista (voltar, setRoot, killApp) ou sozinho no aviso seguinte, se a vista já não estiver no ecrã. */
      const off = Bridge.on('blocks', () => { if (!box.isConnected) { off(); return; } paint(); });
      if (pv && pv.opts) { const prevPop = pv.opts.onPop; pv.opts.onPop = () => { off(); if (prevPop) prevPop(); }; }
      if (window.Contacts && typeof Contacts.loadBlocks === 'function') Promise.resolve(Contacts.loadBlocks()).then(() => { if (box.isConnected) paint(); }).catch(() => {});
    };
    /* Relatório de privacidade REAL: o que o Perm registou (pedidos e utilizações) nos últimos 7 dias */
    const privReport = () => sub('Relatório de privacidade', c => { const RES = { allow: 'permitido', once: 'permitido uma vez', deny: 'recusado', off: 'localização desligada' };
      const l = (Perm.report ? Perm.report() : []).filter(x => App.get(x.app)); if (!l.length) { c.appendChild(UI.list([{ footer: 'Nenhuma app pediu acesso a dados sensíveis nos últimos 7 dias.' }])); return; }
      const by = {}; l.forEach(x => { const kk = by[x.kind] = by[x.kind] || {}; const a = kk[x.app] = kk[x.app] || { n: 0, t: 0, last: '' }; a.n++; if (x.t >= a.t) { a.t = x.t; a.last = x.result; } });
      c.appendChild(UI.list(Object.keys(by).map(k => ({ header: Perm.KINDS[k] || k, items: Object.keys(by[k]).sort((a, b) => by[k][b].t - by[k][a].t).map(app => { const a = by[k][app]; return { icon: Icons.tile(app), tile: true, iconBg: 'transparent', label: App.name(app), sub: `${a.n} ${a.n === 1 ? 'vez' : 'vezes'} · último: ${RES[a.last] || a.last}`, value: UI.timeAgo(a.t), chevron: false }; }) }))
        .concat([{ footer: A ? 'Cada vez que uma app pediu ou usou uma permissão neste telemóvel, nos últimos 7 dias.' : 'Cada vez que uma app pediu ou usou uma permissão neste PearPhone, nos últimos 7 dias.' }]))); }, { back: 'Privacidade' });
    /* Face Key e código. O PIN nunca passa pelo cliente (Fase 1): verifica-se no servidor, com tentativas e
       bloqueio, e Ativar / Alterar / Desativar vão pelo account.setPin. Sem código não se pergunta nada. */
    /* verificar o codigo atual (no servidor). Devolve o codigo ('' quando nao ha), ou null se o jogador desistiu ou falhou.
       Partilhado pelo PearOS (Face Key e codigo) e pela Nova UI (Tipo de bloqueio do ecra, Biometria). */
    const verifyCurrent = async () => { if (!hasPin()) return '';
      const len = acc().pinLen === 4 ? '••••' : '••••••'; const cur = await UI.prompt(A ? 'PIN' : 'Código', A ? 'Introduz o PIN atual' : 'Introduz o código atual', len, '', 'password'); if (cur === null) return null;
      const r = await Bridge.request('account.verifyPin', { pin: cur }); if (!r.success || !(r.data && r.data.ok)) { UI.alert(pinWrong(r) ? { title: A ? 'PIN incorreto' : 'Código incorreto', msg: pinFail(r) } : { title: A ? 'Não foi possível verificar o PIN' : 'Não foi possível verificar o código', msg: 'Tenta outra vez dentro de instantes.' }); Sound.play('error'); return null; }
      return cur; };
    const askNewCode = async () => { const n1 = await UI.prompt(A ? 'Novo PIN' : 'Novo código', A ? 'Introduz um PIN de 6 dígitos (ou 4)' : 'Introduz um código de 6 dígitos (ou 4)', '••••••', '', 'password'); if (n1 === null) return null; if (!/^(\d{4}|\d{6})$/.test(n1)) { UI.alert({ title: A ? 'PIN inválido' : 'Código inválido', msg: A ? 'O PIN tem de ter 4 ou 6 dígitos.' : 'O código tem de ter 4 ou 6 dígitos.' }); return null; }
      const n2 = await UI.prompt('Confirmar', A ? 'Volta a introduzir o PIN' : 'Volta a introduzir o código', n1.length === 6 ? '••••••' : '••••', '', 'password'); if (n2 === null) return null; if (n1 !== n2) { UI.alert({ title: A ? 'Os PIN não coincidem' : 'Os códigos não coincidem' }); return null; } return n1; };
    /* aplica o resultado do servidor à conta em memória (o lock.js lê System.account.hasPin / pinLen) */
    const applyPin = async (cur, nw) => { const r = await Bridge.request('account.setPin', { old: cur, new: nw });
      if (!r.success || !(r.data && r.data.ok)) { const e = r.data && r.data.error; UI.alert({ title: A ? (nw ? 'Erro ao alterar o PIN' : 'Erro ao remover o PIN') : (nw ? 'Erro ao alterar código' : 'Erro ao desativar o código'), msg: e === 'badpin' || e === 'locked' ? ((A ? 'O PIN atual já não é válido. ' : 'O código atual já não é válido. ') + pinFail(r)).trim() : e === 'invalid' ? (A ? 'O PIN tem de ter 4 ou 6 dígitos.' : 'O código tem de ter 4 ou 6 dígitos.') : 'Tenta outra vez.' }); Sound.play('error'); return false; }
      const a = System.account; if (a) { a.hasPin = !!nw; a.pinLen = !nw ? 0 : nw.length === 6 ? 6 : 4; delete a.pin; } Sound.play('success'); return true; };
    /* devolve a página aberta, ou null se o código foi cancelado ou falhou (o settings:goto só marca a linha quando ela abre) */
    const passcode = async () => { let cur = await verifyCurrent(); if (cur === null) return null;
      const askNew = askNewCode;
      const setPin = async nw => { const ok = await applyPin(cur, nw); if (ok) cur = nw; return ok; };
      return sub('Face Key e código', c => { const paint = () => { c.innerHTML = ''; if (hasPin()) c.appendChild(faceList()); c.appendChild(codeList()); };
        /* miniatura da cara guardada (só existe depois de uma inscrição a sério) */
        const faceThumb = () => { const f = FaceID.stored(); if (!f) return null; const d = UI.el('<div class="fid-shot"></div>'); d.style.backgroundImage = `url("${f}")`; return d; };
        const faceList = () => UI.list([
        /* ---------- A cara guardada (fotografia REAL tirada na inscrição) ---------- */
        { header: 'Face Key', footer: FaceID.stored() ? 'A fotografia foi tirada com a câmara do telemóvel durante a inscrição.' : 'Ainda não há nenhuma cara configurada neste PearPhone.',
          items: [{ label: FaceID.stored() ? 'Repor o Face Key' : 'Configurar o Face Key', cls: 'blue', chevron: false, right: faceThumb(),
            onTap: async () => { const f = await FaceID.run(); if (f === null) return; await FaceID.save(f); if (f) { set({ faceIdUnlock: true }); Sound.play('success'); } paint(); } }]
            .concat(FaceID.stored() ? [{ label: 'Apagar a cara', cls: 'red', chevron: false, onTap: async () => { if (!await UI.confirm('Apagar o Face Key', 'Vais voltar a precisar do código para desbloquear.', 'Apagar', true)) return; await FaceID.save(''); set({ faceIdUnlock: false }); paint(); } }] : []) },
        /* "Wallet e pagamentos" e "AppShop" retirados: interruptores sem efeito */
        { header: 'Usar Face Key para', footer: 'Com o Face Key ligado, deslizar para cima no ecrã bloqueado desbloqueia sem pedir o código.', items: [{ label: 'Desbloquear o PearPhone', toggle: !!S.faceIdUnlock, onToggle: v => { if (v && !FaceID.stored()) { UI.toast('Configura primeiro o Face Key'); paint(); return; } set({ faceIdUnlock: v }); } }] }]);
        /* 4 OU 6 dígitos (o PearOS usa 6 por omissão e mantém os códigos de 4 já existentes) */
        const codeList = () => UI.list(hasPin() ? [
          { items: [{ label: 'Alterar código', cls: 'blue', chevron: false, onTap: async () => { const n1 = await askNew(); if (n1 && await setPin(n1)) UI.alert({ title: 'Código alterado' }); } },
            { label: 'Desativar código', cls: 'danger', chevron: false, onTap: async () => { if (!await UI.confirm('Desativar o código?', 'Qualquer pessoa com o telemóvel consegue abri-lo. O desbloqueio com Face Key também deixa de ser usado.', 'Desativar', true)) return; if (await setPin('')) { set({ faceIdUnlock: false }); UI.toast('Código desativado'); paint(); } } }] },
          { footer: 'O código é pedido logo que o telemóvel bloqueia.' }]   /* a linha estática "Exigir código: Imediatamente" saiu (auditoria 2026-09-17): não se tocava nem mudava */
          : [{ header: 'Código', footer: 'Sem código, deslizar para cima no ecrã bloqueado abre o telemóvel. Ativa um código para o proteger e usar o Face Key.', items: [{ label: 'Ativar código', cls: 'blue', chevron: false, onTap: async () => { const n1 = await askNew(); if (n1 && await setPin(n1)) { UI.toast('Código ativado'); paint(); } } }] }]);
        paint(); }); };
    const battery = () => sub('Bateria', c => { c.appendChild(UI.list([{ items: [{ label: 'Nível', value: S.battery + '%' }, { label: 'Percentagem da bateria', toggle: S.battPercent === true, onToggle: v => set({ battPercent: v }) }, { label: 'Modo de poupança', toggle: S.lowPower, onToggle: v => set({ lowPower: v }) }] }, { footer: 'Nesta versão a bateria não descarrega nem carrega: o nível é fixo. O modo de poupança só pinta o ícone da bateria de amarelo.' }])); });   /* sem gráfico inventado (spec 37); o rodapé antigo prometia escurecer o ecrã e reduzir a atividade, e nada o fazia */
    /* Vera: a tecla é a REAL (Config.VeraKey, vinda no `ready`); sem tecla a linha não aparece. "Vera no ecrã bloqueado" retirado (sem efeito). */
    const vera = () => sub('Vera', c => { const key = (System.config && System.config.veraKey) || ''; c.appendChild(UI.list([{ items: [{ label: 'Ativar Vera', toggle: S.vera, onToggle: v => set({ vera: v }) }].concat((System.config && System.config.ai && System.config.ai.wake === false) ? [] : [{ label: 'Ouvir "Vera"', sub: 'Diz "Vera" ou "Olá Vera, abre os Mapas" (o microfone fica a ouvir com o telemóvel aberto)', toggle: S.veraWake !== false, onToggle: v => { set({ veraWake: v }); if (window.VeraVoice) VeraVoice.refresh(); } }]).concat(key ? [{ label: 'Tecla de atalho', value: key }] : []) }   /* "Voz" (Vera/Nova/Sol/Lua) retirada (auditoria 2026-09-17): a Vera nunca lia a escolha */, { items: [{ label: 'Experimentar Vera', cls: 'center', chevron: false, onTap: () => Vera.open() }] }, { footer: 'Comandos: "abrir Mapas", "ligar à Mãe", "enviar mensagem a Rui olá", "tocar música", "ativar modo escuro", "lembra-me de…"' }])); });
    /* Apps › (app): "Notificações" abre as definições da app (notifApps); as permissões "uma vez" aparecem marcadas; "Dados móveis" retirado (sem efeito) */
    /* pagina de UMA app (Apps › app); tambem aberta pelo "Informacoes da app" do menu de um icone (settings:appinfo) */
    const appPage = (id, from) => sub(App.name(id), (cc2, v2) => { const d = App.get(id); const nm = A ? App.name(id) : d.name;
      const paint = () => { cc2.innerHTML = ''; cc2.appendChild(UI.list([{ header: 'Permitir acesso', items: [{ label: 'Notificações', value: nSummary(id), onTap: () => notifApp(id, App.name(id), () => { if (cc2.isConnected) paint(); }) }, ...Object.keys(Perm.KINDS).filter(k => Perm.get(id, k) !== undefined || (Perm.isOnce && Perm.isOnce(id, k))).map(k => ({ label: Perm.KINDS[k], sub: Perm.get(id, k) === undefined ? 'Permitido uma vez' : '', toggle: !!Perm.get(id, k), onToggle: v => Perm.set(id, k, v) }))] }, { items: [{ label: 'Abrir ' + nm, cls: 'center', chevron: false, onTap: () => System.openApp(id) }, ...(!d.core ? [{ label: 'Desinstalar', cls: 'danger center', chevron: false, onTap: async () => { if (await UI.confirm('Desinstalar ' + nm, '', 'Desinstalar', true)) { await System.uninstall(id); UI.pop(win); } } }] : [])] }])); };
      paint(); }, { back: 'Apps', from });
    const appsList = () => { const v = sub(A ? 'Aplicações' : 'Apps', c => c.appendChild(UI.list((A ? [{ items: [{ label: OSI().store, sub: 'Instalar e atualizar apps', icon: Icons.tile('appstore'), tile: true, iconBg: 'transparent', onTap: () => System.openApp('appstore') }] }] : []).concat([{ header: A ? 'As tuas apps' : undefined, items: System.installed().sort((a, b) => App.name(a).localeCompare(App.name(b))).map(id => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), onTap: () => appPage(id) })) }]))));
      v._asetApps = true; return v; };
    /* "Informacoes da app" (menu de um icone, pacote C): abre Apps › essa app; se a lista de Apps ainda nao estiver por baixo, abre-a primeiro */
    const appInfo = id => { if (typeof id !== 'string' || !App.get(id)) return false; const st = win.querySelector('.nav-stack'); const top = st && st.lastElementChild; appPage(id, top && top._asetApps ? top : appsList()); return true; };   /* a app por cima da lista de Apps (aberto, a lista não é trocada pela app) */
    /* tempo de ecrã REAL: System.usage() acumula segundos por app e por dia (openApp/closeApp) - hoje, últimos 7 dias e apps mais usadas */
    const screentime = () => sub(A ? 'Bem-estar digital' : 'Tempo de ecrã', c => { const u = System.usage(); const fmt = s => s >= 3600 ? Math.floor(s / 3600) + 'h ' + Math.round(s % 3600 / 60) + 'm' : Math.round(s / 60) + 'm'; const key = new Date().toISOString().slice(0, 10); const today = u[key] || {}; const tot = Object.values(today).reduce((a, b) => a + b, 0);
      const days = []; for (let i = 6; i >= 0; i--) { const d = new Date(); d.setDate(d.getDate() - i); const k = d.toISOString().slice(0, 10); days.push([UI.DIAS_C[d.getDay()][0], Object.values(u[k] || {}).reduce((a, b) => a + b, 0)]); } const max = Math.max(60, ...days.map(x => x[1]));
      c.appendChild(UI.el(`<div class="card" style="margin-top:18px"><div class="card-title">Hoje</div><div style="font-size:var(--t-title1);font-weight:500">${tot ? fmt(tot) : '0m'}</div><div class="bars">${days.map(([l, s]) => `<div style="height:${Math.round(8 + 88 * s / max)}%;background:${s ? 'var(--blue)' : 'var(--fill)'}"><span>${l}</span></div>`).join('')}</div></div>`));
      const top = Object.entries(today).filter(([id]) => App.get(id)).sort((a, b) => b[1] - a[1]).slice(0, 5);
      c.appendChild(UI.list([{ header: 'Mais usadas hoje', items: top.length ? top.map(([id, s]) => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), value: fmt(s) })) : [{ label: 'Ainda sem utilização hoje', chevron: false }] }])); });
    /* coerência com o modo de voo: a regra é a do Centro de controlo (ver netPatch, no topo).
       O Bluetooth leva os earbuds atrás, como no Centro de controlo e na Vera - o rodapé desta página
       promete-o por escrito ("Desligar o Bluetooth desliga também os earbuds") e daqui não acontecia. */
    const connSet = (key, v) => { if (key === 'bt' && !v && S.earbuds && window.Earbuds && Earbuds.disconnect) Earbuds.disconnect(); set(netPatch(key, v)); };
    /* A página repinta-se a si própria em vez de se fechar e reabrir (era `UI.pop` + `setTimeout(conn…)`,
       que piscava a navegação inteira). E repinta-se também quando a mudança vem de FORA: desligar o
       Bluetooth no Centro de controlo deixava aqui a secção «Dispositivos» desenhada, com os earbuds
       listados por baixo de um interruptor já desligado. O ouvinte sai no onPop da vista e, se a janela
       for morta sem onPop, sozinho no aviso seguinte. */
    const conn = (title, key, header, footer) => sub(title, (c, pv) => {
      /* a lista de redes falsas (com palavra-passe) saiu (auditoria 2026-09-17): só mudava o nome mostrado; fica a rede da cidade como informação */
      const paint = () => { c.innerHTML = ''; c.appendChild(UI.list([{ header, footer, items: [{ label: title, toggle: S[key], onToggle: v => connSet(key, v) }] }, ...(key === 'wifi' && S.wifi ? [{ header: 'Rede', footer: 'A rede da cidade. Com o Wi-Fi ou os dados móveis ligados, o que precisa do servidor funciona.', items: [{ label: 'ApexNet 5G', icon: 'wifi', iconBg: 'transparent', iconColor: 'var(--label2)', value: g('check', 21), valueHtml: true, chevron: false, cls: 'static' }] }] : []),
      /* O estado dos earbuds é ressincronizado com o servidor no arranque (shell/permissions.js, Earbuds.sync):
         antes esta linha podia dizer "Ligado" com o servidor a dizer o contrário. */
      /* AirBuds / Slate Buds: aparecem como dispositivo para LIGAR só quando estão postos (item usado); sem eles postos a linha
         explica-o. Como no PearOS: tocar na linha liga ou desliga, o "i" à direita abre a página do par (budsPage) */
      ...(key === 'bt' && S.bt ? [{ header: 'Dispositivos', footer: budsFoot(), items: [{ label: EBN(), value: !S.airpodsWorn ? 'Fora de alcance' : S.earbuds ? 'Ligado' : 'Não ligado', right: budsInfo(), chevron: false, cls: S.airpodsWorn ? '' : 'static', onTap: S.airpodsWorn ? () => Earbuds.toggle() : undefined }, { label: 'Carro · CarLink', value: 'Não ligado', chevron: false }] }] : [])]));   /* CarLink: linha só informativa (o toque não fazia nada) */
      };
      paint(); const later = soon(() => { if (c.isConnected) paint(); });
      const off = Bridge.on('state', p => { if (!c.isConnected) { off(); return; } if (touches(p, NETK)) later(); });
      if (pv && pv.opts) { const prev = pv.opts.onPop; pv.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); }; }
    });
    /* ---------- a página do par (AirBuds / Slate Buds), nos dois sistemas ----------
       PearOS: o "i" da linha em Bluetooth. Nova UI: a roda dentada da linha em Bluetooth e a linha em Dispositivos ligados.
       O desenho e a bateria (Earbuds.hero, css/earbuds.css) constroem-se uma vez e só se acertam; por baixo, ligar ou desligar
       e o nome. Repinta-se quando o estado muda por fora (cartão, Centro de controlo, painel rápido), como o Bluetooth.
       Os textos com o nome são frases inteiras com %s (o motor de traduções casa o padrão). */
    /* o rodapé segue o estado: ligados (S.earbuds), postos mas por ligar, ou nem postos (antes só via se estavam postos e dizia
       "Ligados" por baixo de "Não ligados") */
    const budsFoot = () => (S.earbuds ? 'Ligados, a Música toca só para ti, mesmo com o telemóvel fechado. Desligar o Bluetooth desliga também os %s.' : S.airpodsWorn ? 'Liga os %s para ouvires a Música só tu, mesmo com o telemóvel fechado.' : 'Usa o item %s no inventário para os colocares; depois aparecem aqui para ligar.').replace('%s', EBN());
    const budsInfo = () => { const b = UI.el(`<div class="eb-info nostop" role="button" aria-label="Definições do dispositivo">${A ? g('gear', 22) : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"><circle cx="12" cy="12" r="9.3"/><path d="M12 10.8v5.6"/><circle cx="12" cy="7.7" r=".9" fill="currentColor" stroke="none"/></svg>'}</div>`);
      b.onclick = e => { e.stopPropagation(); budsPage(b); }; return b; };
    /* from: de onde sai (a linha tocada ou a vista do Bluetooth), para ficar por cima dela com o dobrável aberto */
    const budsPage = from => sub(EBN(), (c, pv) => {
      const h = Earbuds.hero(), box = UI.el('<div class="ebh-list"></div>'); c.appendChild(h); c.appendChild(box);
      const paint = () => { h._paint(); box.innerHTML = '';
        box.appendChild(UI.list([
          ...(S.airpodsWorn && S.bt ? [{ items: [{ label: S.earbuds ? 'Desligar' : 'Ligar', cls: A ? '' : 'blue', chevron: false, onTap: () => Earbuds.toggle() }] }] : []),
          { items: [{ label: 'Nome', value: EBN(), chevron: false, cls: 'static' }, { label: 'Modelo', value: Earbuds.KIND === 'slate' ? 'NOVA Buds 4 Pro' : 'AirPods Pro 3', chevron: false, cls: 'static' }],
            footer: !S.bt ? 'Liga o Bluetooth para usares os %s com este telemóvel.'.replace('%s', EBN()) : budsFoot() }])); };
      paint(); const later = soon(() => { if (c.isConnected) paint(); });
      const off = Bridge.on('state', p => { if (!c.isConnected) { off(); return; } if (touches(p, NETK)) later(); });
      if (pv && pv.opts) { const prev = pv.opts.onPop; pv.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); }; }
    }, Object.assign(A ? { back: 'Bluetooth', large: false } : { back: 'Bluetooth' }, { from }));

    /* =====================================================================
       ANDROID · DEFINICOES NOVA UI 8.5
       Os grupos e os nomes da Nova UI por cima das MESMAS chaves de estado e dos MESMOS RPC do PearOS
       (a conta e o servidor sao um so). Paginas novas so para o que o PearOS nao tem: Ligacoes, Dispositivos
       ligados, Barra de navegacao, Paineis Edge, Biometria com impressoes digitais, Localizacao, Gestao geral,
       Acessibilidade, Acerca do telefone. Classes `aset-` (oneui-ui.css).
       ===================================================================== */
    /* glifos que o icons.js nao tem (mesmo traco de 2 px dos outros) */
    const GA = {
      fingerprint: '<path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"/><path d="M14 13.12c0 2.38 0 6.38-1 8.88"/><path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"/><path d="M2 12a10 10 0 0 1 18-6"/><path d="M2 16h.01"/><path d="M21.8 16c.2-2 .131-5.354 0-6"/><path d="M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2"/><path d="M8.65 22c.21-.66.45-1.32.57-2"/><path d="M9 6.8a6 6 0 0 1 9 5.2v2"/>',
      palette: '<circle cx="13.5" cy="6.5" r="1.3"/><circle cx="17.5" cy="10.5" r="1.3"/><circle cx="8.5" cy="7.5" r="1.3"/><circle cx="6.5" cy="12.5" r="1.3"/><path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10c.93 0 1.65-.75 1.65-1.69 0-.44-.18-.84-.44-1.13-.29-.29-.44-.65-.44-1.13a1.64 1.64 0 0 1 1.67-1.67h2c3.05 0 5.56-2.5 5.56-5.55C21.97 6.01 17.46 2 12 2z"/>',
      devices: '<rect x="2.5" y="5" width="12" height="14" rx="2.2"/><rect x="17" y="8" width="4.5" height="11" rx="1.4"/>',
      routines: '<circle cx="12" cy="12" r="9"/><path d="m8.4 12.2 2.4 2.4 4.8-5"/>',
      access: '<circle cx="12" cy="4.6" r="1.8"/><path d="M5 8.6l7 1.6 7-1.6"/><path d="M12 10.2v4.6l-3 6.2"/><path d="M12 14.8l3 6.2"/>',
      leaf: '<path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z"/><path d="M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12"/>',
      apps: '<circle cx="7" cy="7" r="2.3"/><circle cx="17" cy="7" r="2.3"/><circle cx="7" cy="17" r="2.3"/><circle cx="17" cy="17" r="2.3"/>',
      hotspot: '<circle cx="12" cy="12" r="1.8"/><path d="M8.6 8.6a4.8 4.8 0 0 0 0 6.8M15.4 8.6a4.8 4.8 0 0 1 0 6.8M5.6 5.6a9 9 0 0 0 0 12.8M18.4 5.6a9 9 0 0 1 0 12.8"/>',
      qshare: '<path d="M7 7.5a7 7 0 0 1 11.4 2"/><path d="M17 16.5a7 7 0 0 1-11.4-2"/><path d="m18.6 5.6-.2 3.9-3.9-.4"/><path d="m5.4 18.4.2-3.9 3.9.4"/>',
      navbar: '<rect x="4" y="2.5" width="16" height="19" rx="3"/><path d="M8 17.5h8"/>',
      edge: '<rect x="4" y="2.5" width="16" height="19" rx="3"/><path d="M17 9v6"/>'
    };
    const ga = (k, size) => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"${size ? ` width="${size}" height="${size}"` : ''}>${GA[k] || ''}</svg>`;
    /* cores dos icones redondos da raiz (tons da Nova UI) */
    const OUC = { conn: '#3E7BFA', devices: '#2A9FE3', modes: '#2DB36B', sound: '#8A63F5', notif: '#F2753A', display: '#34B467', battery: '#1FAE8C', style: '#EC5A8B', home: '#4C7CF3', lock: '#7E62F2', security: '#3F7DF6', location: '#2DAE68', wellbeing: '#26A97A', apps: '#4C86F5', general: '#7D8794', access: '#2B9FBF', update: '#7A5CF0', about: '#8A9099', vera: 'linear-gradient(135deg,#3FB2E6,#3FCFA2)' };
    const EBN = () => (window.Earbuds && Earbuds.NAME) || 'Auriculares';
    const TXT = { small: 'Pequeno', normal: 'Normal', medium: 'Médio', large: 'Grande' };
    const TXTK = { 'Pequeno': 'small', 'Normal': 'normal', 'Médio': 'medium', 'Grande': 'large' };
    const AUTOL = ['30 segundos', '1 minuto', '2 minutos', '5 minutos', '10 minutos', 'Nunca'];
    /* volta de uma pagina filha: quem a abriu acerta os seus valores (sem fechar e reabrir a navegacao) */
    const onBack = (v, fn) => { if (!v || !v.opts) return v; const prev = v.opts.onPop; v.opts.onPop = () => { try { if (prev) prev(); } catch (e) {} try { fn(); } catch (e) {} }; return v; };
    /* pagina que se repinta quando o estado muda por fora (painel rapido, Vera, outra pagina). Adiada e agrupada como o
       PearOS faz (o interruptor acaba de deslizar antes de a lista ser refeita); o ouvinte sai com a vista */
    const liveA = (title, paint, keys, opts) => sub(title, (c, v) => {
      const run = () => { c.innerHTML = ''; paint(c, v); };
      v._repaint = () => { if (c.isConnected) run(); };
      paint(c, v);
      if (keys && keys.length) { const later = soon(() => { if (c.isConnected) run(); });
        const off = Bridge.on('state', pt => { if (!c.isConnected) { off(); return; } if (touches(pt, keys)) later(); });
        const prev = v.opts.onPop; v.opts.onPop = () => { try { off(); } catch (e) {} if (prev) prev(); }; }
    }, opts);
    /* interruptor principal da Nova UI (cartao com "Ligado" / "Desligado" no topo da pagina) */
    const master = (on, onSet) => { let li = null, lab = null;
      const l = UI.list([{ items: [{ label: on ? 'Ligado' : 'Desligado', toggle: !!on, cls: 'aset-master', onToggle: v => { if (lab) lab.textContent = v ? 'Ligado' : 'Desligado'; if (li) li.classList.toggle('on', v); onSet(v); } }] }]);
      li = l.querySelector('.li'); lab = li && li.querySelector('.li-label'); if (li) li.classList.toggle('on', !!on); return l; };

    /* ---------- Ligacoes ---------- */
    const netVal = () => S.airplane ? 'Modo de voo ligado' : S.wifi ? (S.wifiNet || 'ApexNet 5G') : 'Desligado';
    const btVal = () => !S.bt ? 'Desligado' : S.earbuds ? 'Ligado a %s'.replace('%s', EBN()) : 'Ligado';
    const qsLabel = () => window.AirDrop && AirDrop.label ? AirDrop.label() : 'Desligado';
    /* a pagina e a do AirDrop (pacote F2a); o valor volta certo porque a escolha grava `airdrop` no estado e a pagina de baixo e viva */
    const quickShareA = () => { if (!window.AirDrop || !AirDrop.page) { UI.toast('A partilha rápida não está disponível'); return; } AirDrop.page(win, {}); };
    /* eSIM: a linha "Gestor de SIM" mostra "Sem SIM" ou o número da linha ativa; a página repinta-se quando isso muda (trocar de linha, ativar) */
    const connectionsA = () => { const v = connA(); let was = simVal() + '|' + (p().phone || '');
      const off = Bridge.on('esim:state', () => { if (!v.isConnected) { off(); return; } const now = simVal() + '|' + (p().phone || ''); if (now !== was) { was = now; if (v._repaint) v._repaint(); } }); return v; };
    const connA = () => liveA('Ligações', c => c.appendChild(UI.list([
      { items: [{ label: 'Wi-Fi', value: netVal(), toggle: !!S.wifi, onToggle: v => connSet('wifi', v), onTap: wifiA },
        { label: 'Bluetooth', value: btVal(), toggle: !!S.bt, onToggle: v => connSet('bt', v), onTap: btA }] },
      { items: [{ label: 'Modo de voo', sub: 'Desliga o Wi-Fi, os dados móveis e o ponto de acesso', toggle: !!S.airplane, onToggle: v => connSet('airplane', v) }] },
      { items: [{ label: 'Gestor de SIM', value: simVal() || UI.phone(p().phone) || NA, onTap: sim }, { label: 'Dados móveis', sub: 'Rede móvel da Apex Mobile', toggle: !!S.cellular, onToggle: v => connSet('cellular', v) }] },
      { items: [{ label: 'Ponto de acesso móvel', value: S.hotspot && !S.airplane ? 'Ligado' : 'Desligado', toggle: !!S.hotspot && !S.airplane, onToggle: v => connSet('hotspot', v), onTap: hotspotA },
        { label: 'VPN', value: S.vpn ? 'Ligada' : 'Desligada', toggle: !!S.vpn, onToggle: v => set({ vpn: v }), onTap: vpnA },
        { label: 'Partilha rápida', value: qsLabel(), onTap: quickShareA }] },
      { footer: 'Sem Wi-Fi nem dados móveis, ou com o modo de voo ligado, o que precisa do servidor recusa e diz porquê.' }])), NETK.concat(['airdrop']));
    const wifiA = () => liveA('Wi-Fi', c => {
      c.appendChild(master(!!S.wifi, v => connSet('wifi', v)));
      if (S.wifi) c.appendChild(UI.list([{ header: 'Rede atual', items: [{ label: S.wifiNet || 'ApexNet 5G', sub: 'Ligado', icon: 'wifi', iconBg: OUC.conn, chevron: false, cls: 'static aset-cur' }], footer: 'A rede da cidade. Com o Wi-Fi ou os dados móveis ligados, o que precisa do servidor funciona.' }]));
      else c.appendChild(UI.list([{ footer: S.airplane ? 'O modo de voo está ligado. Ligar o Wi-Fi desliga o modo de voo.' : 'Liga o Wi-Fi para te ligares à rede da cidade.' }]));
    }, NETK);
    const btA = () => liveA('Bluetooth', c => {
      c.appendChild(master(!!S.bt, v => connSet('bt', v)));
      if (!S.bt) { c.appendChild(UI.list([{ footer: 'Liga o Bluetooth para usares os %s com este telemóvel.'.replace('%s', EBN()) }])); return; }
      /* a linha do par: tocar liga ou desliga (só postos); a roda dentada à direita abre a página dele (budsPage) */
      c.appendChild(UI.list([{ header: 'Dispositivos emparelhados', footer: budsFoot(),
        items: [S.airpodsWorn ? { label: EBN(), icon: 'earbuds', iconBg: OUC.devices, sub: S.earbuds ? 'Ligado · áudio só para ti' : 'Toca para ligar', cls: S.earbuds ? 'aset-cur' : '', chevron: false, right: budsInfo(), onTap: () => Earbuds.toggle() } : { label: EBN(), icon: 'earbuds', iconBg: 'var(--gray)', sub: 'Fora de alcance', chevron: false, right: budsInfo(), cls: 'static' },
          { label: 'Carro · CarLink', icon: 'car', iconBg: 'var(--gray)', sub: 'Não ligado', chevron: false, cls: 'static' }] }]));
    }, NETK);
    const hotspotA = () => liveA('Ponto de acesso móvel', c => {
      c.appendChild(master(!!S.hotspot && !S.airplane, v => connSet('hotspot', v)));
      c.appendChild(UI.list([{ items: [{ label: 'Nome da rede', value: System.deviceName(), chevron: false }], footer: 'Com o ponto de acesso ligado aparece o indicador na barra de estado. Precisa dos dados móveis: desligá-los, ou ligar o modo de voo, desliga-o também.' }]));
    }, NETK.concat(['deviceName']));
    const vpnA = () => liveA('VPN', c => {
      c.appendChild(master(!!S.vpn, v => set({ vpn: v })));
      c.appendChild(UI.list([{ items: [{ label: 'Perfil', value: 'Apex VPN', chevron: false }], footer: 'Com a VPN ligada aparece o indicador na barra de estado. A ligação ao servidor do jogo continua a mesma.' }]));
    }, ['vpn']);
    const devicesA = () => liveA('Dispositivos ligados', c => c.appendChild(UI.list([
      { items: [{ label: EBN(), icon: 'earbuds', iconBg: OUC.devices, value: !S.bt ? 'Bluetooth desligado' : S.earbuds ? 'Ligado' : S.airpodsWorn ? 'Não ligado' : 'Fora de alcance', onTap: budsPage }] },   /* a página do par (antes abria o Bluetooth) */
      { items: [{ label: 'Partilha rápida', icon: ga('qshare'), iconBg: OUC.conn, value: qsLabel(), onTap: quickShareA }] },
      { items: [{ label: 'Bluetooth', value: btVal(), toggle: !!S.bt, onToggle: v => connSet('bt', v), onTap: btA }] }])), NETK.concat(['airdrop']));

    /* ---------- Sons e vibracao ---------- */
    const ringtonePage = () => sub('Toque', cc => cc.appendChild(UI.list([{ items: Sound.RING.map(r => ({ label: r, right: UI.radio(r === S.ringtone), chevron: false, onTap: li => { set({ ringtone: r }); const stop = Sound.ring(r); setTimeout(stop, 2500); cc.querySelectorAll('.ou-radio').forEach(x => x.classList.toggle('on', li.contains(x))); } })) }])), { back: 'Sons' });
    /* cursor Nova UI: pista grossa com o preenchimento azul (--p), sem animar nada: so acompanha o dedo */
    const slider = (min, max, val, cls) => { const i = UI.el(`<input type="range" class="ou-range no-kb ${cls || ''}" min="${min}" max="${max}" value="${val}">`); const fill = () => i.style.setProperty('--p', ((i.value - min) / (max - min) * 100).toFixed(1) + '%'); fill(); i.addEventListener('input', fill); return i; };
    const soundsA = () => liveA('Sons e vibração', (c, v) => {
      const silent = !!S.silent;
      const modes = UI.list([{ header: 'Modo de som', items: [['Som', false, 'Toca nas chamadas e nas notificações'], ['Silêncio', true, 'Sem toque nem som das notificações']].map(([l, val, sb]) => ({ label: l, sub: sb, right: UI.radio(silent === val), chevron: false, onTap: () => { if (!!S.silent === val) return; Sound.play('click'); set({ silent: val }); } })) }]);
      c.appendChild(modes);
      c.appendChild(UI.el('<div class="group-header">Volume</div>'));
      const vg = UI.el('<div class="group aset-vols"></div>');
      [['Toque e chamadas', 'callVolume', 'phone', 'connect'], ['Notificações', 'notifVolume', 'bell', 'notify'], ['Multimédia', 'volume', 'speaker', 'notify']].forEach(([l, key, ic, snd]) => {
        const row = UI.el(`<div class="aset-vol"><div class="aset-vol-h"><span>${l}</span><b>${S[key]}%</b></div><div class="aset-vol-r">${g(ic, 20)}</div></div>`);
        const inp = slider(0, 100, S[key]); row.querySelector('.aset-vol-r').appendChild(inp);
        inp.addEventListener('input', () => { S[key] = +inp.value; row.querySelector('b').textContent = S[key] + '%'; });
        inp.addEventListener('change', () => { set({}); Sound.play(snd); }); vg.appendChild(row); });
      c.appendChild(vg);
      c.appendChild(UI.list([{ items: [{ label: 'Toque', value: S.ringtone, onTap: () => onBack(ringtonePage(), () => v._repaint()) }] },
        { items: [{ label: 'Sons do sistema', sub: 'Toques, teclado e bloqueio', toggle: S.sounds, onToggle: x => set({ sounds: x }) }, { label: 'Som das notificações', toggle: S.notifSound, onToggle: x => set({ notifSound: x }) }], footer: 'Em silêncio o telemóvel não toca nas chamadas nem nas notificações, e o modo aparece na barra de estado.' }]));
    }, ['silent', 'ringtone']);

    /* ---------- Ecra ---------- */
    const displayA = () => liveA('Ecrã', c => {
      const cur = S.dark ? 'dark' : 'light';
      const modes = UI.el(`<div class="group aset-modes">${[['light', 'Claro'], ['dark', 'Escuro']].map(([k, l]) => `<div class="aset-mode" data-v="${k}"><div class="aset-mode-pv ${k}"><i></i><i></i><i></i><i></i></div><span>${l}</span><div class="ou-radio ${cur === k ? 'on' : ''}"></div></div>`).join('')}</div>`);
      modes.querySelectorAll('.aset-mode').forEach(m => m.onclick = () => { if (S.theme === m.dataset.v) return; Sound.play('click'); set({ theme: m.dataset.v }); });
      c.appendChild(modes);
      c.appendChild(UI.list([{ items: [{ label: 'Modo escuro automático', sub: 'Escuro entre as 20h e as 7h, pela hora do jogo', toggle: S.theme === 'auto', onToggle: v => set({ theme: v ? 'auto' : (S.dark ? 'dark' : 'light') }) }] }]));
      /* brilho: a arrastar so mexe no veu do brilho; grava-se ao largar (System.apply por evento pesava no CEF) */
      c.appendChild(UI.el('<div class="group-header">Brilho</div>'));
      const br = UI.el(`<div class="group aset-slrow">${g('sun', 18)}<span class="aset-sl"></span>${g('sun', 24)}</div>`);
      const bi = slider(10, 100, S.brightness); br.querySelector('.aset-sl').replaceWith(bi);
      bi.addEventListener('input', () => { S.brightness = +bi.value; if (window.CC && CC.applyBrightness) CC.applyBrightness(S.brightness); }); bi.addEventListener('change', () => set({}));
      c.appendChild(br);
      c.appendChild(UI.list([
        { items: [{ label: 'Conforto visual', sub: 'Tons mais quentes para descansar a vista à noite', toggle: !!S.nightShift, onToggle: v => set({ nightShift: v }) }] },
        { items: [{ label: 'Tamanho do texto', value: TXT[S.textSize] || 'Normal', onTap: () => pick('Tamanho do texto', Object.values(TXT), TXT[S.textSize] || 'Normal', v => set({ textSize: TXTK[v] }), 'Ecrã') },
          { label: 'Tempo limite do ecrã', value: S.autoLock, onTap: () => pick('Tempo limite do ecrã', AUTOL, S.autoLock, v => set({ autoLock: v }), 'Ecrã') }] },
        { items: [{ label: 'Barra de navegação', value: S.navMode === 'gesture' ? 'Gestos de deslizar' : 'Botões', onTap: navbarA },
          { label: 'Painéis Edge', sub: 'Atalhos para as tuas apps na borda do ecrã', toggle: S.edgePanel !== false, onToggle: v => set({ edgePanel: v }), onTap: edgeA }] },
        { header: 'Tamanho do telemóvel no ecrã', footer: 'Só no jogo. Pequeno ocupa menos espaço.', items: [{ html: '<div class="seg aset-scale" style="margin:0;flex:1"></div>', cls: 'static' }] }]));
      const SC = [['Pequeno', 0.72], ['Médio', 0.84], ['Grande', 0.98]]; const curI = Math.max(0, SC.findIndex(x => Math.abs((S.phoneScaleV2 || 0.84) - x[1]) < .03));
      const segEl = c.querySelector('.aset-scale'); if (segEl) segEl.replaceWith(UI.seg(SC.map(x => x[0]), curI, i => set({ phoneScaleV2: SC[i][1] })));
    }, ['theme', 'textSize', 'autoLock', 'navMode', 'edgePanel']);
    /* barra de navegacao: o mesmo desenho dos botoes do SysUI (Recentes ||| · Inicio · Voltar <) */
    const NAVG = { recents: '<path d="M7.5 7v10M12 7v10M16.5 7v10"/>', home: '<rect x="6.5" y="6.5" width="11" height="11" rx="4.2"/>', back: '<path d="m14.2 6.4-5.6 5.6 5.6 5.6"/>' };
    const navKeys = order => (order === 'back-home-recents' ? ['back', 'home', 'recents'] : ['recents', 'home', 'back']).map(k => `<span class="aset-nk"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">${NAVG[k]}</svg></span>`).join('');
    const navbarA = () => sub('Barra de navegação', c => {
      const pv = UI.el('<div class="aset-navpv"><div class="aset-navpv-scr"><i></i><i></i><i></i><i></i><i></i></div><div class="aset-navpv-bar"></div></div>');
      const types = UI.el(`<div class="group aset-navtypes"><div class="aset-navtype" data-v="buttons"><div class="aset-navtype-ic"><span class="aset-nk-row">${navKeys('recents-home-back')}</span></div><span>Botões</span><div class="ou-radio"></div></div><div class="aset-navtype" data-v="gesture"><div class="aset-navtype-ic"><b class="aset-pill"></b></div><span>Gestos de deslizar</span><div class="ou-radio"></div></div></div>`);
      const orderH = UI.el('<div class="group-header">Ordem dos botões</div>');
      const order = UI.el(`<div class="group aset-navorder">${['recents-home-back', 'back-home-recents'].map(o => `<div class="aset-ord" data-v="${o}"><div class="aset-nk-row">${navKeys(o)}</div><div class="ou-radio"></div></div>`).join('')}</div>`);
      const foot = UI.el('<div class="group-footer"></div>');
      /* atualiza no sitio: nada se reconstroi nem pisca */
      const sync = () => { const m = S.navMode === 'gesture' ? 'gesture' : 'buttons', o = S.navOrder === 'back-home-recents' ? 'back-home-recents' : 'recents-home-back';
        const bar = pv.querySelector('.aset-navpv-bar'); const sig = m + o; if (bar.dataset.sig !== sig) { bar.dataset.sig = sig; bar.innerHTML = m === 'gesture' ? '<b class="aset-pill"></b>' : `<span class="aset-nk-row">${navKeys(o)}</span>`; }
        pv.classList.toggle('gesture', m === 'gesture');
        types.querySelectorAll('.aset-navtype').forEach(t => t.querySelector('.ou-radio').classList.toggle('on', t.dataset.v === m));
        order.querySelectorAll('.aset-ord').forEach(t => t.querySelector('.ou-radio').classList.toggle('on', t.dataset.v === o));
        orderH.style.display = order.style.display = m === 'buttons' ? '' : 'none';
        foot.textContent = m === 'buttons' ? 'Recentes, Início e Voltar ficam sempre no fundo do ecrã. Escolhe de que lado fica o Voltar.' : 'Desliza para cima a partir do fundo para ires ao ecrã principal; desliza para cima e segura para veres as apps recentes; desliza para dentro a partir de uma borda lateral para voltares.'; };
      types.querySelectorAll('.aset-navtype').forEach(t => t.onclick = () => { if ((S.navMode === 'gesture' ? 'gesture' : 'buttons') === t.dataset.v) return; Sound.play('click'); set({ navMode: t.dataset.v }); sync(); });
      order.querySelectorAll('.aset-ord').forEach(t => t.onclick = () => { if (S.navOrder === t.dataset.v) return; Sound.play('click'); set({ navOrder: t.dataset.v }); sync(); });
      c.append(pv, UI.el('<div class="group-header">Tipo de navegação</div>'), types, orderH, order, foot); sync();
    });
    const edgeA = () => liveA('Painéis Edge', c => { const on = S.edgePanel !== false;
      c.appendChild(master(on, v => set({ edgePanel: v })));
      c.appendChild(UI.el(`<div class="aset-edgepv ${on ? 'on' : ''}"><div class="aset-edgepv-ph"><div class="aset-edgepv-p">${['phone', 'messages', 'camera', 'photos', 'music'].map(id => `<i>${Icons.tile(id)}</i>`).join('')}</div><b class="aset-edgepv-h"></b></div></div>`));
      c.appendChild(UI.list([{ header: 'Painéis', items: [{ label: 'Apps', sub: 'As tuas apps preferidas, sempre à mão', icon: ga('apps'), iconBg: OUC.apps, chevron: false, onTap: () => { if (!on) { UI.toast('Liga os painéis Edge primeiro'); return; } if (!window.EdgePanel || !EdgePanel.open) { UI.toast('O painel Edge não está disponível'); return; } System.closeApp(); setTimeout(() => { try { EdgePanel.open(); } catch (e) {} }, 560); } }] },
        { items: [{ label: 'Posição da pega', value: 'Direita', chevron: false }], footer: 'Arrasta a pega na borda direita do ecrã para abrires o painel. Com os painéis desligados a pega desaparece.' }]));
    }, ['edgePanel']);

    /* ---------- Funcionalidades avancadas: tecla lateral e paineis Edge ----------
       A tecla lateral mostra o que o hardware.js faz de facto (premir duas vezes = Camara, manter = menu de desligar);
       nao ha escolha porque nada a leria (pedido ao nucleo no relatorio). */
    const sidekeyA = () => sub('Tecla lateral', c => c.appendChild(UI.list([
      { header: 'Premir duas vezes', items: [{ label: 'Abrir a câmara', sub: 'A partir de qualquer ecrã, mesmo bloqueado', right: UI.radio(true), chevron: false, cls: 'static' }] },
      { header: 'Premir e manter', items: [{ label: 'Menu de desligar', sub: 'Desligar, reiniciar e modo de emergência', right: UI.radio(true), chevron: false, cls: 'static' }], footer: 'Um toque curto na tecla lateral apaga o ecrã; com o Always On Display ligado a hora fica à vista.' }])), { back: 'Funcionalidades avançadas' });
    const advancedA = () => liveA('Funcionalidades avançadas', c => c.appendChild(UI.list([{ items: [
      { label: 'Tecla lateral', sub: 'Premir duas vezes: câmara • Manter: menu de desligar', onTap: sidekeyA },
      { label: 'Painéis Edge', sub: 'Atalhos para as tuas apps na borda do ecrã', toggle: S.edgePanel !== false, onToggle: v => set({ edgePanel: v }), onTap: edgeA }] }])), ['edgePanel']);

    /* ---------- Bateria, fundo e estilo, ecra principal ---------- */
    const batteryA = () => liveA('Bateria', c => { const b = Math.max(0, Math.min(100, +S.battery || 0));
      c.appendChild(UI.el(`<div class="aset-batt ${S.lowPower ? 'saver' : ''}"><div class="aset-batt-num">${b}<small>%</small></div><div class="aset-batt-bar"><i style="width:${b}%"></i></div><span>${S.lowPower ? 'Poupança de energia ligada' : 'Nível fixo nesta versão'}</span></div>`));
      c.appendChild(UI.list([{ items: [{ label: 'Poupança de energia', sub: 'Muda o ícone da bateria na barra de estado', toggle: !!S.lowPower, onToggle: v => set({ lowPower: v }) }, { label: 'Mostrar a percentagem da bateria', toggle: S.battPercent === true, onToggle: v => set({ battPercent: v }) }], footer: 'Nesta versão a bateria não descarrega nem carrega: o nível é fixo.' }]));
    }, ['lowPower', 'battPercent', 'battery']);
    const PAL = [['#0088FF', 'Azul Nova', '#3E7BFA'], ['#5866F2', 'Índigo'], ['#9B5CF2', 'Violeta'], ['#F5476E', 'Rosa'], ['#F2453D', 'Vermelho'], ['#FF8A1F', 'Laranja'], ['#E3A80B', 'Âmbar'], ['#2DBE60', 'Verde'], ['#11A9C0', 'Petróleo'], ['#21B6E8', 'Ciano'], ['#A47A5A', 'Castanho'], ['#7E8794', 'Grafite']];
    const palName = () => { const h = String(S.accent || '#0088FF').toUpperCase(); const f = PAL.find(x => x[0] === h); return f ? f[1] : h; };
    const paletteA = () => liveA('Paleta de cores', c => { const curHex = String(S.accent || '#0088FF').toUpperCase(); const known = PAL.some(x => x[0] === curHex);
      const grid = UI.el(`<div class="group aset-pal">${PAL.map(([h, l, show]) => `<div class="aset-sw ${curHex === h ? 'on' : ''}" data-h="${h}"><i style="background:${show || h}"></i><span>${UI.esc(l)}</span></div>`).join('')}</div>`);
      grid.querySelectorAll('.aset-sw').forEach(d => d.onclick = () => { if (String(S.accent || '').toUpperCase() === d.dataset.h) return; Sound.play('click'); grid.querySelectorAll('.aset-sw').forEach(x => x.classList.toggle('on', x === d)); set({ accent: d.dataset.h }); });
      c.appendChild(grid);
      c.appendChild(UI.list([{ items: [{ label: 'Cor personalizada', value: known ? 'Nenhuma' : curHex, onTap: async () => { const h = await UI.prompt('Cor personalizada', 'Formato #RRGGBB', '#3E7BFA', known ? '' : curHex); if (h && /^#[0-9a-f]{6}$/i.test(h)) set({ accent: h.toUpperCase() }); else if (h) UI.toast('Cor inválida'); } }], footer: 'A cor aplica-se aos interruptores, botões, ligações e seleções do sistema.' }]));
    }, ['accent']);
    /* editores do pacote B: 'lock' = ecra bloqueado Nova UI, 'home' = fundo do ecra principal; voltam as Definicoes no fim */
    const editLG = kind => { const LGx = window.LockGallery; if (!LGx || !LGx.openEditor) { wallpaper(); return; } System.closeApp(true); Lock.lock(); setTimeout(() => LGx.openEditor(kind, 'settings'), 650); };
    const styleA = () => liveA('Fundo e estilo', c => c.appendChild(UI.list([{ items: [
      { label: 'Fundos', sub: 'Ecrã bloqueado e ecrã principal', icon: 'photo', iconBg: OUC.style, onTap: wallpaper },
      { label: 'Paleta de cores', value: palName(), icon: ga('palette'), iconBg: OUC.lock, onTap: paletteA }] },
      { header: 'Personalizar', items: [{ label: 'Ecrã bloqueado', sub: 'Relógio, fundo e atalhos', onTap: () => editLG('lock') }, { label: 'Ecrã principal', sub: 'Fundo do ecrã principal', onTap: () => editLG('home') }] }])), ['accent']);
    const homeA = () => liveA('Ecrã principal', c => c.appendChild(UI.list([
      { items: [{ label: 'Etiquetas dos ícones', sub: 'O nome por baixo de cada app', toggle: S.showLabels !== false, onToggle: v => set({ showLabels: v }) },
        { label: 'Ordenar a gaveta de apps', value: S.drawerSort === 'alpha' ? 'Ordem alfabética' : 'Ordem personalizada', onTap: () => pick('Ordenar a gaveta de apps', ['Ordem personalizada', 'Ordem alfabética'], S.drawerSort === 'alpha' ? 'Ordem alfabética' : 'Ordem personalizada', v => set({ drawerSort: v === 'Ordem alfabética' ? 'alpha' : 'custom' }), 'Ecrã principal') }] },
      { items: [{ label: 'Editar ecrã principal', cls: 'blue', chevron: false, onTap: () => { System.closeApp(); setTimeout(() => { if (window.Home && Home.enterEdit) Home.enterEdit(); }, 500); } },
        { label: 'Repor disposição', cls: 'danger', chevron: false, onTap: async () => { if (await UI.confirm('Repor disposição', 'As apps voltam à ordem original.', 'Repor', true)) { set({ hiddenApps: [] }); Home.load(null); UI.toast('Disposição reposta'); } } }] }])), ['showLabels', 'drawerSort']);

    /* ---------- Ecra bloqueado e seguranca ---------- */
    const lockTypeLabel = () => hasPin() ? 'PIN' : 'Deslizar';
    /* Tipo de bloqueio do ecra: Deslizar (sem codigo) ou PIN. O PIN nunca passa pelo cliente: verifica-se e muda-se no servidor */
    const lockTypeA = async () => { const cur0 = await verifyCurrent(); if (cur0 === null) return null; let code = cur0;
      return sub('Tipo de bloqueio do ecrã', c => { const paint = () => { c.innerHTML = ''; const pin = hasPin();
        c.appendChild(UI.list([{ items: [
          { label: 'Deslizar', sub: 'Sem segurança', right: UI.radio(!pin), chevron: false, onTap: async () => { if (!hasPin()) return; if (!await UI.confirm('Remover o PIN?', 'Qualquer pessoa com o telemóvel consegue abri-lo. O rosto e as impressões digitais deixam de o desbloquear.', 'Remover', true)) return; if (await applyPin(code, '')) { code = ''; set({ faceIdUnlock: false, fpUnlock: false }); UI.toast('PIN removido'); paint(); } } },
          { label: 'PIN', sub: pin ? (acc().pinLen === 4 ? '4 dígitos' : '6 dígitos') : 'Segurança média', right: UI.radio(pin), chevron: false, onTap: async () => { if (hasPin()) return; const n = await askNewCode(); if (n && await applyPin(code, n)) { code = n; UI.toast('PIN ativado'); paint(); } } }] }]
          .concat(pin ? [{ items: [{ label: 'Alterar PIN', cls: 'blue', chevron: false, onTap: async () => { const n = await askNewCode(); if (n && await applyPin(code, n)) { code = n; UI.toast('PIN alterado'); paint(); } } }] }] : [])
          .concat([{ footer: 'O PIN é pedido logo que o telemóvel bloqueia. O rosto e as impressões digitais precisam de um PIN como alternativa.' }]))); };
        paint(); }, { back: 'Segurança' }); };
    const lockA = () => liveA('Ecrã bloqueado e AOD', (c, v) => {
      const FONTS = { default: 'Padrão', rounded: 'Arredondada', mono: 'Mono', thin: 'Fina', bold: 'Negrito' };
      c.appendChild(UI.list([
        { items: [{ label: 'Tipo de bloqueio do ecrã', value: lockTypeLabel(), onTap: async () => { const tv = await lockTypeA(); if (tv) onBack(tv, () => v._repaint()); } }] },
        /* o editor Nova UI do ecra bloqueado (pacote B); sem ele, a galeria de sempre */
        { items: [{ label: 'Personalizar ecrã bloqueado', sub: 'Relógio, fundo e atalhos', onTap: () => { const LGx = window.LockGallery; System.closeApp(true); Lock.lock(); setTimeout(() => { if (!LGx) return; if (LGx.openEditor) LGx.openEditor('lock', 'settings'); else LGx.open(true); }, 650); } }] },
        { items: [{ label: 'Always On Display', sub: 'A hora fica à vista com o ecrã apagado', toggle: S.alwaysOn === true, onToggle: x => set({ alwaysOn: x }) }, { label: 'Bloquear ao fechar o telemóvel', toggle: S.lockOnClose, onToggle: x => set({ lockOnClose: x }) }], footer: 'Sem o Always On Display, o botão lateral apaga mesmo o ecrã.' },
        { header: 'Relógio', items: [{ label: 'Estilo do relógio', value: FONTS[S.clockFont] || 'Padrão', onTap: () => pick('Estilo do relógio', Object.values(FONTS), FONTS[S.clockFont] || 'Padrão', x => set({ clockFont: Object.keys(FONTS).find(k => FONTS[k] === x) || 'default' }), 'Ecrã bloqueado') }] }]));
      const sw = UI.el('<div class="group aset-swrow"></div>'); ['#FFFFFF', '#FFD60A', '#FF9F0A', '#FF375F', '#BF5AF2', '#64D2FF', '#30D158', '#000000'].forEach(h => { const d = UI.el(`<i class="${String(S.clockColor || '').toUpperCase() === h ? 'on' : ''}" style="background:${h}"></i>`); d.onclick = () => { sw.querySelectorAll('i').forEach(x => x.classList.toggle('on', x === d)); set({ clockColor: h }); }; sw.appendChild(d); });
      c.appendChild(UI.el('<div class="group-header">Cor do relógio</div>')); c.appendChild(sw);
      const W = [['weather', 'Meteorologia'], ['battery', 'Bateria'], ['calendar', 'Calendário'], ['alarm', 'Alarme'], ['reminders', 'Lembretes']];
      c.appendChild(UI.list([{ header: 'Widgets (máx. 3)', items: W.map(([k, l]) => ({ label: l, toggle: (S.lockWidgetsV2 || []).includes(k), onToggle: x => { let lw = (S.lockWidgetsV2 || []).filter(y => y !== k); if (x) lw.push(k); if (lw.length > 3) lw = lw.slice(-3); set({ lockWidgetsV2: lw }); if (window.Lock && Lock.renderWidgets) Lock.renderWidgets(); } })) },
        { items: [{ label: 'Notificações no ecrã bloqueado', value: 'Por app', onTap: notifs }] }]));
    }, ['alwaysOn', 'lockOnClose', 'clockFont', 'lockWidgetsV2']);
    const permsA = () => sub('Permissões', c => c.appendChild(UI.list([{ items: permItems(), footer: 'Toca numa permissão para veres as apps que a pediram e mudares o acesso de cada uma.' }])), { back: 'Privacidade' });
    const securityA = () => sub('Segurança e privacidade', (c, v) => {
      const top = UI.el('<div class="aset-sec"></div>'); c.appendChild(top);
      const paintTop = () => { top.innerHTML = ''; const f = !!(window.FaceID && FaceID.stored()), n = +S.fpEnrolled || 0;
        top.appendChild(UI.list([
          { header: 'Bloqueio', items: [{ label: 'Tipo de bloqueio do ecrã', value: lockTypeLabel(), onTap: async () => { const tv = await lockTypeA(); if (tv) onBack(tv, paintTop); } },
            { label: 'Biometria', sub: [f ? 'Rosto registado' : 'Reconhecimento facial', n ? (n === 1 ? '1 impressão digital' : n + ' impressões digitais') : 'Impressões digitais'].join(' • '), onTap: async () => { const bv = await biometricsA(); if (bv) onBack(bv, paintTop); } }] },
          { header: 'Privacidade', items: [{ label: 'Permissões', sub: 'Câmara • Microfone • Localização', onTap: permsA }, { label: 'Relatório de privacidade', sub: 'Pedidos e acessos dos últimos 7 dias', onTap: privReport }] }])); };
      paintTop(); msgPrivacy(c, v); extGrants(c);
    });
    /* Biometria: pede o PIN como a Nova UI (e e preciso um PIN para a haver) */
    const biometricsA = async then => {
      if (!hasPin()) { const r = await UI.alert({ title: 'Define primeiro um PIN', msg: 'O rosto e as impressões digitais precisam de um PIN para quando não te reconhecerem.', buttons: [{ label: 'Cancelar', value: false }, { label: 'Definir PIN', bold: true, value: true }] }); if (!r.value) return null; return lockTypeA(); }   /* com o PIN definido, a Biometria abre no toque seguinte (pede o PIN, como a Nova UI) */
      else { const ok = await verifyCurrent(); if (ok === null) return null; }
      const v = liveA('Biometria', (c, v2) => { const f = !!(window.FaceID && FaceID.stored()), n = +S.fpEnrolled || 0;
        c.appendChild(UI.el(`<div class="aset-hero sm"><div class="aset-hero-ic">${ga('fingerprint', 40)}</div><span>Desbloqueia o telemóvel com o rosto ou com um dedo, sem escreveres o PIN.</span></div>`));
        c.appendChild(UI.list([{ items: [
          { label: 'Reconhecimento facial', icon: 'faceid', iconBg: OUC.security, sub: f ? (S.faceIdUnlock ? 'Registado · desbloqueia o telemóvel' : 'Registado') : 'Não registado', onTap: () => onBack(faceA(), () => v2._repaint()) },
          { label: 'Impressões digitais', icon: ga('fingerprint'), iconBg: OUC.security, sub: n ? (n === 1 ? '1 impressão digital' : n + ' impressões digitais') + (S.fpUnlock ? ' · desbloqueia o telemóvel' : '') : 'Nenhuma registada', onTap: () => onBack(fingerprintA(), () => v2._repaint()) }] },
          { footer: 'O PIN continua sempre a funcionar no ecrã bloqueado.' }]));
      }, ['fpEnrolled', 'fpUnlock', 'faceIdUnlock'], { back: 'Segurança' });
      /* a página pedida (atalho) abre POR CIMA da Biometria (from): com o NOVA Fold8 aberto um push sem origem trocava o detalhe
         e a Biometria saía da pilha (o voltar já não a encontrava), como quando se toca na linha dela */
      if (then === 'face') onBack(faceA(v), () => v._repaint()); else if (then === 'fp') onBack(fingerprintA(v), () => v._repaint());
      return v; };
    const faceA = from => liveA('Reconhecimento facial', (c, v) => { const f = window.FaceID && FaceID.stored();
      const enroll = async () => { if (!window.FaceID || !FaceID.run) { UI.toast('O registo do rosto não está disponível'); return; } const shot = await FaceID.run(); if (shot === null) return; await FaceID.save(shot); if (shot) { set({ faceIdUnlock: true }); Sound.play('success'); } v._repaint(); };
      const hero = UI.el(`<div class="aset-hero"><div class="aset-hero-ic ${f ? 'shot' : ''}">${f ? '' : g('faceid', 44)}</div><b>${f ? 'O teu rosto está registado' : 'Desbloqueia com o teu rosto'}</b><span>${f ? 'A fotografia foi tirada com a câmara do telemóvel durante o registo.' : 'O registo usa a câmara do telemóvel: segue o anel com a cabeça até ficar completo.'}</span></div>`);
      if (f) hero.querySelector('.aset-hero-ic').style.backgroundImage = `url("${f}")`;
      c.appendChild(hero);
      c.appendChild(UI.list(f ? [{ items: [{ label: 'Desbloquear com reconhecimento facial', sub: 'Olha para o ecrã bloqueado e desliza para cima', toggle: !!S.faceIdUnlock, onToggle: x => set({ faceIdUnlock: x }) }] },
        { items: [{ label: 'Registar o rosto de novo', cls: 'blue', chevron: false, onTap: enroll }, { label: 'Remover dados de rosto', cls: 'danger', chevron: false, onTap: async () => { if (!await UI.confirm('Remover dados de rosto?', 'Vais voltar a precisar do PIN para desbloquear.', 'Remover', true)) return; await FaceID.save(''); set({ faceIdUnlock: false }); v._repaint(); } }] }]
        : [{ items: [{ label: 'Registar rosto', cls: 'blue center', chevron: false, onTap: enroll }] }]));
    }, ['faceIdUnlock'], { back: 'Biometria', from });
    const fingerprintA = from => liveA('Impressões digitais', c => { const n = Math.max(0, Math.min(4, +S.fpEnrolled || 0));
      if (n) c.appendChild(UI.list([{ header: 'Registadas', items: Array.from({ length: n }, (_, i) => ({ label: 'Impressão digital ' + (i + 1), icon: ga('fingerprint'), iconBg: OUC.security, chevron: false,
        onTap: async () => { const r = await UI.actionSheet({ title: 'Impressão digital ' + (i + 1), buttons: [{ label: 'Remover', value: 'rm', danger: true, icon: 'trash' }] }); if (r !== 'rm') return;
          if (!await UI.confirm('Remover impressão digital?', 'Deixas de poder desbloquear o telemóvel com este dedo.', 'Remover', true)) return;
          const left = Math.max(0, (+S.fpEnrolled || 0) - 1); set(left ? { fpEnrolled: left } : { fpEnrolled: 0, fpUnlock: false }); UI.toast('Impressão digital removida'); } })) }]));
      else c.appendChild(UI.el(`<div class="aset-hero"><div class="aset-hero-ic">${ga('fingerprint', 44)}</div><b>Desbloqueia com um dedo</b><span>Toca no sensor no fundo do ecrã com um dedo registado para abrires o telemóvel sem o PIN.</span></div>`));
      c.appendChild(UI.list([{ items: [{ label: 'Adicionar impressão digital', cls: n >= 4 ? 'aset-dis' : 'blue', chevron: false, onTap: () => { if ((+S.fpEnrolled || 0) >= 4) { UI.toast('Já tens 4 impressões digitais registadas'); return; } fpEnrollA(); } }], footer: n >= 4 ? 'Podes registar até 4 impressões digitais. Remove uma para adicionares outra.' : '' }]));
      if (n) c.appendChild(UI.list([{ items: [{ label: 'Desbloquear com impressões digitais', toggle: !!S.fpUnlock, onToggle: x => set({ fpUnlock: x }) }], footer: 'No ecrã bloqueado, toca no sensor no fundo do ecrã com um dedo registado.' }]));
    }, ['fpEnrolled', 'fpUnlock'], { back: 'Biometria', from });
    /* registo de uma impressao digital: tocar no sensor (no fundo do ecra, onde esta o sensor do S26) e levantar o dedo,
       varias vezes, ate aos 100 %. Cada toque conta uma vez e so ao levantar; o desenho grande enche-se aresta a aresta. */
    const fpEnrollA = () => {
      const v = UI.view({ title: 'Adicionar impressão digital', back: 'Impressões digitais', full: true, cls: 'aset-fpv' });
      /* as arestas acendem do centro para fora (a ordem do desenho original e outra) */
      const all = (GA.fingerprint.match(/<path [^>]*\/>/g) || []); const paths = [0, 1, 7, 8, 6, 2, 3, 5, 4].map(i => all[i]).filter(Boolean);
      const fp = UI.el(`<div class="aset-fp"><div class="aset-fp-top"><div class="aset-fp-pct"><b>0</b><i>%</i></div><div class="aset-fp-msg">Toca no sensor</div><div class="aset-fp-sub">Coloca o dedo no sensor, no fundo do ecrã, e levanta-o. Repete até chegares aos 100%.</div></div>
        <div class="aset-fp-art"><svg viewBox="0 0 24 24" fill="none" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">${paths.map(x => x.replace('<path ', '<path class="g" ')).join('')}${paths.map(x => x.replace('<path ', '<path class="r" ')).join('')}</svg></div>
        <div class="aset-fp-sensor"><svg class="aset-fp-ring" viewBox="0 0 100 100"><circle class="t" cx="50" cy="50" r="46"/><circle class="b" cx="50" cy="50" r="46"/></svg><div class="aset-fp-btn">${ga('fingerprint', 38)}</div></div>
        <div class="aset-fp-end"><div class="btn-p aset-fp-ok">Concluído</div></div></div>`);
      v.content.appendChild(fp);
      const pctB = fp.querySelector('.aset-fp-pct b'), msg = fp.querySelector('.aset-fp-msg'), subT = fp.querySelector('.aset-fp-sub'), ring = fp.querySelector('.aset-fp-ring .b'), rs = [...fp.querySelectorAll('.aset-fp-art .r')], sensor = fp.querySelector('.aset-fp-sensor');
      const C = 2 * Math.PI * 46; ring.style.strokeDasharray = C.toFixed(2); ring.style.strokeDashoffset = C.toFixed(2);
      let p = 0, done = false, downT = 0;
      const paint = () => { pctB.textContent = p; ring.style.strokeDashoffset = (C * (1 - p / 100)).toFixed(2); const k = Math.round(p / 100 * rs.length); rs.forEach((r, i) => r.classList.toggle('on', i < k));
        if (!done) { msg.textContent = p === 0 ? 'Toca no sensor' : p < 50 ? 'Levanta o dedo e toca outra vez' : 'Agora toca com as bordas do dedo'; subT.textContent = p === 0 ? 'Coloca o dedo no sensor, no fundo do ecrã, e levanta-o. Repete até chegares aos 100%.' : p < 50 ? 'Muda ligeiramente a posição do dedo de cada vez.' : 'Inclina o dedo para registar também as bordas.'; } };
      const finish = () => { done = true; fp.classList.add('done'); Sound.play('success'); msg.textContent = 'Impressão digital adicionada'; subT.textContent = 'Já podes usar este dedo para desbloquear o telemóvel.';
        const n = +S.fpEnrolled || 0; set(n === 0 ? { fpEnrolled: 1, fpUnlock: true } : { fpEnrolled: Math.min(4, n + 1) }); };
      const down = e => { if (done) return; if (e.button && e.pointerType === 'mouse') return; downT = Date.now(); sensor.classList.add('press'); try { sensor.setPointerCapture(e.pointerId); } catch (x) {} };
      const up = () => { if (!downT) return; const held = Date.now() - downT; downT = 0; sensor.classList.remove('press'); if (done || held < 70) return;
        p = Math.min(100, p + 8 + Math.floor(Math.random() * 8)); Sound.play(p >= 100 ? 'click' : 'tick'); paint(); if (p >= 100) finish(); };
      sensor.addEventListener('pointerdown', down); sensor.addEventListener('pointerup', up); sensor.addEventListener('pointercancel', up);
      fp.querySelector('.aset-fp-ok').onclick = () => UI.pop(win);
      paint(); UI.push(win, v); return v; };
    const locationA = () => liveA('Localização', c => { const on = S.locationOn !== false; const apps = window.Perm && Perm.apps ? Perm.apps('location') : [];
      c.appendChild(master(on, v => set({ locationOn: v })));
      c.appendChild(apps.length ? UI.list([{ header: 'Permissões das apps', footer: on ? (apps.some(a => a.once) ? '"Permitido uma vez" dura até a app ser fechada nas apps recentes.' : '') : 'Com a localização desligada nenhuma app recebe a tua posição, mesmo as que têm acesso.', items: apps.map(a => ({ icon: Icons.tile(a.app), tile: true, iconBg: 'transparent', label: App.name(a.app), sub: a.once ? 'Permitido uma vez' : '', toggle: a.allowed, onToggle: x => Perm.set(a.app, 'location', x) })) }])
        : UI.list([{ footer: 'Nenhuma app pediu acesso à localização ainda.' }]));
    }, ['locationOn']);

    /* ---------- Gestao geral, acessibilidade, atualizacao, acerca ---------- */
    const kbOn = () => S.kb === null || S.kb === undefined ? Bridge.inFiveM : !!S.kb;
    const generalA = () => liveA('Gestão geral', c => c.appendChild(UI.list([
      { items: [{ label: L.t('Idioma'), value: L.name(S.lang || 'pt'), onTap: language }, { label: 'Teclado', value: kbOn() ? 'Teclado no ecrã' : 'Só o teclado físico', onTap: keyboardPage }, { label: 'Data e hora', value: S.clock24 !== false ? '24 horas' : '12 horas', onTap: dateTimePage }] },
      { items: [{ label: 'Armazenamento', sub: 'Fotos, apps, notas e lembretes', onTap: storage }] },
      { items: [{ label: 'Repor', sub: 'Repor as definições ou apagar todos os dados', onTap: resetPage }] }])), ['lang', 'kb', 'clock24']);
    const accessA = () => liveA('Acessibilidade', c => c.appendChild(UI.list([
      { header: 'Visibilidade', items: [{ label: 'Tamanho do texto', value: TXT[S.textSize] || 'Normal', onTap: () => pick('Tamanho do texto', Object.values(TXT), TXT[S.textSize] || 'Normal', v => set({ textSize: TXTK[v] }), 'Acessibilidade') }, { label: 'Etiquetas dos ícones', toggle: S.showLabels !== false, onToggle: v => set({ showLabels: v }) }] },
      { header: 'Movimento', items: [{ label: 'Reduzir movimento', sub: 'As apps e os menus aparecem por desvanecimento, sem deslizar nem efeito de mola', toggle: !!S.reduceMotion, onToggle: v => set({ reduceMotion: v }) }] }])), ['textSize', 'showLabels', 'reduceMotion']);
    const updateA = () => sub('Atualização de software', c => { const o = OSI();
      c.appendChild(UI.el(`<div class="aset-hero"><div class="aset-hero-ic upd">${g('update', 42)}</div><b>O software está atualizado</b><span>${UI.esc(o.osName + ' ' + o.osVersion)}</span></div>`));
      c.appendChild(UI.list([{ items: [{ label: 'Versão atual', value: o.osName + ' ' + o.osVersion, chevron: false }, { label: 'Modelo', value: o.model, chevron: false }], footer: 'O telemóvel é atualizado pelo servidor: não há nada a transferir aqui.' }])); });
    const aboutA = () => liveA('Acerca do telefone', c => { const a = acc(), o = OSI();
      const hero = UI.el(`<div class="aset-about"><b>${UI.esc(System.deviceName())}</b><span>${UI.esc(o.model)}</span><div class="aset-about-btn">Editar</div></div>`);
      hero.querySelector('.aset-about-btn').onclick = () => renameDevice();
      c.appendChild(hero);
      c.appendChild(UI.list([
        { items: [{ label: 'Número de telefone', value: UI.phone(p().phone) || NA }, { label: 'Nome do modelo', value: o.model }, { label: 'Número do modelo', value: 'NV-S948B/DS' }, { label: 'Número de série', value: System.serial() }, { label: 'IMEI', value: System.imei() }] },
        { items: [{ label: 'Operadora', value: 'Apex Mobile' }, { label: 'SIM', value: a.sim_id || NA }, { label: 'Conta', value: a.username ? '@' + a.username : NA }, { label: 'Versão da ' + o.osName, value: o.osVersion }] },
        { header: 'Neste telemóvel', items: [{ label: 'Apps instaladas', value: String(System.installed().length) }, { label: 'Fotos', value: String((window.Photos && Photos.cache || []).length) }, { label: 'Contactos', value: String((window.Contacts && Contacts.cache || []).length) }, { label: 'Notas', value: String((Store.get('notes', []) || []).length) }] },
        { items: [{ label: 'Atualização de software', value: o.osName + ' ' + o.osVersion, onTap: updateA }] }]));
    }, ['deviceName']);
    const qpA = () => sub('Painel rápido', c => c.appendChild(UI.list([{ items: [{ label: 'Abrir o painel rápido', cls: 'blue', chevron: false, onTap: () => { if (window.QuickPanel && QuickPanel.open) QuickPanel.open('qs'); else if (window.CC && CC.open) CC.open(); } }], footer: 'Desliza para baixo a partir do topo do ecrã: a metade esquerda abre as notificações e a direita as definições rápidas.' }])));

    /* ---------- Pesquisa (Nova UI): pagina propria com o campo na barra e o caminho de cada resultado ---------- */
    const fold = s => String(s || '').normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
    const IDX = () => [
      ['Wi-Fi', 'Ligações', wifiA], ['Bluetooth', 'Ligações', btA], ['Modo de voo', 'Ligações', connectionsA], ['Dados móveis', 'Ligações', connectionsA], ['Gestor de SIM', 'Ligações', sim], ['Trocar SIM', 'Ligações › Gestor de SIM', sim], ['Adicionar eSIM', 'Ligações › Gestor de SIM', sim], ['SIM preferido', 'Ligações › Gestor de SIM', sim],
      ['Ponto de acesso móvel', 'Ligações', hotspotA], ['VPN', 'Ligações', vpnA], ['Partilha rápida', 'Ligações', quickShareA], [EBN(), 'Dispositivos ligados', btA], ['Dispositivos ligados', '', devicesA],
      ['Não incomodar', 'Modos e rotinas', () => focus()], ['Modos e rotinas', '', () => focus()], ['Modo de som', 'Sons e vibração', soundsA], ['Silêncio', 'Sons e vibração', soundsA], ['Volume', 'Sons e vibração', soundsA], ['Toque', 'Sons e vibração', ringtonePage], ['Sons do sistema', 'Sons e vibração', soundsA],
      ['Notificações', '', notifs], ['Histórico de notificações', 'Notificações', () => Notify.openNC()],
      ['Modo escuro', 'Ecrã', displayA], ['Brilho', 'Ecrã', displayA], ['Conforto visual', 'Ecrã', displayA], ['Tamanho do texto', 'Ecrã', displayA], ['Tempo limite do ecrã', 'Ecrã', displayA], ['Barra de navegação', 'Ecrã', navbarA], ['Gestos de deslizar', 'Ecrã › Barra de navegação', navbarA], ['Painéis Edge', 'Ecrã', edgeA], ['Tamanho do telemóvel no ecrã', 'Ecrã', displayA], ['Tecla lateral', 'Funcionalidades avançadas', sidekeyA], ['Funcionalidades avançadas', '', advancedA],
      ['Bateria', '', batteryA], ['Poupança de energia', 'Bateria', batteryA], ['Percentagem da bateria', 'Bateria', batteryA],
      ['Fundos', 'Fundo e estilo', wallpaper], ['Paleta de cores', 'Fundo e estilo', paletteA], ['Cor de destaque', 'Fundo e estilo', paletteA],
      ['Ecrã principal', '', homeA], ['Etiquetas dos ícones', 'Ecrã principal', homeA], ['Gaveta de apps', 'Ecrã principal', homeA],
      ['Ecrã bloqueado', '', lockA], ['Always On Display', 'Ecrã bloqueado e AOD', lockA], ['Tipo de bloqueio do ecrã', 'Ecrã bloqueado e AOD', lockTypeA], ['PIN', 'Segurança e privacidade', lockTypeA],
      ['Biometria', 'Segurança e privacidade', () => biometricsA()], ['Reconhecimento facial', 'Segurança e privacidade › Biometria', () => biometricsA('face')], ['Impressões digitais', 'Segurança e privacidade › Biometria', () => biometricsA('fp')],
      ['Segurança e privacidade', '', securityA], ['Permissões', 'Segurança e privacidade', permsA], ['Relatório de privacidade', 'Segurança e privacidade', privReport], ['Recibos de leitura', 'Segurança e privacidade', securityA], ['Contactos bloqueados', 'Segurança e privacidade', securityA],
      ['Localização', '', locationA], ['Tempo de ecrã', 'Bem-estar digital', screentime], ['Aplicações', '', appsList], [OSI().store, 'Aplicações', () => System.openApp('appstore')], ['Vera', '', vera],
      ['Idioma', 'Gestão geral', language], ['Teclado', 'Gestão geral', keyboardPage], ['Data e hora', 'Gestão geral', dateTimePage], ['Formato 24 horas', 'Gestão geral › Data e hora', dateTimePage], ['Armazenamento', 'Gestão geral', storage], ['Repor', 'Gestão geral', resetPage],
      ['Reduzir movimento', 'Acessibilidade', accessA], ['Atualização de software', '', updateA], ['Acerca do telefone', '', aboutA], ['Nome do telefone', 'Acerca do telefone', aboutA], ['Número de telefone', 'Acerca do telefone', aboutA],
      ['Conta ' + OSI().brand, '', account], ['Painel rápido', '', qpA]];
    const searchA = () => {
      const v = UI.view({ title: '', back: 'Definições', cls: 'aset-search' });
      const res = UI.el('<div class="aset-sres"></div>'); v.content.appendChild(res);
      const hint = t => { res.innerHTML = ''; res.appendChild(UI.el(`<div class="aset-shint">${UI.esc(t)}</div>`)); };
      const run = q => { const f = fold(q); if (!f) { hint('Escreve para pesquisar nas definições.'); return; }
        /* primeiro os que tem a palavra no nome (e quanto mais cedo melhor), depois os que so a tem no caminho */
        const score = x => { const i = fold(x[0]).indexOf(f); return i >= 0 ? i : 100 + fold(x[1]).indexOf(f); };
        const hits = IDX().filter(x => fold(x[0]).includes(f) || fold(x[1]).includes(f)).sort((a, b) => score(a) - score(b)).slice(0, 40);
        if (!hits.length) { hint('Sem resultados para "' + q + '".'); return; }
        const mark = s => { const i = fold(s).indexOf(f); return i < 0 ? UI.esc(s) : UI.esc(s.slice(0, i)) + '<span class="aset-hl">' + UI.esc(s.slice(i, i + f.length)) + '</span>' + UI.esc(s.slice(i + f.length)); };
        res.innerHTML = ''; res.appendChild(UI.list([{ items: hits.map(([l, crumb, fn]) => ({ html: mark(l), sub: crumb || 'Definições', chevron: false, onTap: () => fn() })) }])); };
      const s = UI.search('Pesquisar', run); s.classList.add('aset-q');
      v.navbar.querySelector('.nb-title').replaceWith(s);
      hint('Escreve para pesquisar nas definições.');
      UI.push(win, v); setTimeout(() => { try { s.input.focus(); } catch (e) {} }, 380); return v; };

    /* settings:goto (pesquisa, atalhos, Vera): a linha da página só fica marcada quando ela abriu MESMO. As que pedem o código
       (Face Key e código, Biometria) esperam pelo pedido: cancelado ou errado não abre nada e a marca fica na página que continua
       aberta. A função da chave devolve a página que abriu (marca se ainda estiver na pilha), null (não abriu) ou nada (marca se a
       vista de cima mudou). Dobrável aberto ou fechado (fechado fica guardada para quando abrir); nos outros não se vê */
    const gotoMark = (fn, done) => {
      const live = v => !!v && v.nodeType === 1 && v.classList.contains('view') && !!v.parentNode && v.parentNode === win.querySelector(':scope > .nav-stack') && !v.classList.contains('leave') && !v.classList.contains('pane-out');
      const top = () => { const st = win.querySelector(':scope > .nav-stack'); return st ? [...st.children].filter(live).pop() || null : null; };
      const t0 = top();
      Promise.resolve(fn()).then(v => { if (v === null || v === false) return; if (v && v.nodeType === 1 ? live(v) : top() !== t0) done(); }, e => console.error('[apex_phone] settings:goto', e)); };

    /* ---------- Raiz (Nova UI) ---------- */
    const openAndroid = () => {
      const root = UI.view({ title: 'Definições', large: true, right: [{ icon: 'search', onTap: () => searchA() }] });
      const body = UI.el('<div class="aset-body"></div>'); root.content.appendChild(body);
      const paintRoot = () => { const a = acc(); const name = (S.name || `${p().firstname} ${p().lastname}`).trim(); const o = OSI();
        body.innerHTML = '';
        const prof = UI.el(`<div class="aset-prof"><div class="aset-prof-av">${myAvatar(a, '')}</div><div class="aset-prof-tx"><b>${UI.esc(name || (a.username ? '@' + a.username : ''))}</b><span>${UI.esc('Conta ' + o.brand)}</span><span>${UI.esc(UI.phone(p().phone || ''))}</span></div></div>`);
        prof.onclick = () => { Sound.play('click'); account(); };
        const find = UI.el(`<div class="aset-find">${g('search', 20)}<span>Pesquisar definições</span></div>`); find.onclick = () => searchA();
        body.append(prof, find);
        const R = (label, sb, ic, color, fn) => ({ label, sub: sb, icon: GA[ic] ? ga(ic) : ic, iconBg: color, chevron: false, onTap: () => fn() });
        const l = UI.list([
          { items: [R('Ligações', 'Wi-Fi • Bluetooth • Modo de voo', 'wifi', OUC.conn, connectionsA), R('Dispositivos ligados', EBN() + ' • Partilha rápida', 'devices', OUC.devices, devicesA)] },
          { items: [R('Modos e rotinas', 'Não incomodar • Trabalho • Dormir', 'routines', OUC.modes, () => focus()), R('Sons e vibração', 'Modo de som • Toque • Volume', 'speaker', OUC.sound, soundsA), R('Notificações', 'Notificações das apps • Histórico', 'bell', OUC.notif, notifs)] },
          { items: [R('Ecrã', 'Brilho • Conforto visual • Barra de navegação', 'sun', OUC.display, displayA), R('Bateria', 'Poupança de energia', 'battery', OUC.battery, batteryA), R('Fundo e estilo', 'Fundos • Paleta de cores', 'palette', OUC.style, styleA)] },
          { items: [R('Ecrã principal', 'Etiquetas dos ícones • Gaveta de apps', 'grid', OUC.home, homeA), R('Ecrã bloqueado e AOD', 'Tipo de bloqueio • Always On Display', 'lock', OUC.lock, lockA)] },
          { items: [R('Segurança e privacidade', 'Biometria • Permissões', 'shield', OUC.security, securityA), R('Localização', 'Apps com acesso à localização', 'location', OUC.location, locationA)] },
          { items: [R('Funcionalidades avançadas', 'Tecla lateral • Painéis Edge', 'star', '#F28A1E', advancedA), R('Bem-estar digital', 'Tempo de ecrã', 'leaf', OUC.wellbeing, screentime), R('Aplicações', 'As tuas apps • ' + o.store, 'apps', OUC.apps, appsList), R('Vera', 'Assistente • Ouvir "Vera"', 'sparkles', OUC.vera, vera)] },
          { items: [R('Gestão geral', 'Idioma • Teclado • Data e hora', 'sliders', OUC.general, generalA), R('Acessibilidade', 'Tamanho do texto • Reduzir movimento', 'access', OUC.access, accessA), R('Atualização de software', o.osName + ' ' + o.osVersion, 'update', OUC.update, updateA), R('Acerca do telefone', 'Modelo • Nome do telefone', 'info', OUC.about, aboutA)] }]);
        l.classList.add('aset-root'); body.appendChild(l);
        if (UI.splitResel) UI.splitResel(win); };   /* NOVA Fold8 aberto: a página aberta à direita continua marcada depois de repintar (voltar à app) */
      paintRoot(); UI.setRoot(win, root);
      /* NOVA Fold8 aberto: a lista à esquerda e a página escolhida à direita, como nas Definições de um ecrã grande (ui.js UI.split);
         abre logo em "Ligações" (a primeira linha), nunca com o aviso vazio */
      UI.split(win, { icon: 'gear', title: 'Definições', sub: 'Escolhe uma opção na lista para a abrir aqui.', first: true });
      win._paintRoot = () => { if (body.isConnected) paintRoot(); };
      const rootSoonA = soon(win._paintRoot);
      const offStateA = Bridge.on('state', pt => { if (System.currentApp() !== 'settings') return; if (touches(pt, ['name', 'airdrop'])) rootSoonA(); });
      /* chaves do settings:goto (pesquisa global, Painel rapido, Vera): as do PearOS levam a pagina equivalente da Nova UI */
      const GOTO_A = { cc: qpA, account, wallpaper, notifications: notifs, sounds: soundsA, focus: () => focus(), modes: () => focus(), screentime, wellbeing: screentime, general: generalA, display: displayA, accent: paletteA, palette: paletteA, style: styleA,
        lockscreen: lockA, vera, passcode: securityA, security: securityA, privacy: securityA, permissions: permsA, biometrics: () => biometricsA(), face: () => biometricsA('face'), fingerprint: () => biometricsA('fp'), battery: batteryA, apps: appsList,
        wifi: wifiA, bt: btA, buds: () => budsPage(btA()), connections: connectionsA, sim: () => sim(), devices: devicesA, hotspot: hotspotA, vpn: vpnA, quickshare: quickShareA, homescreen: homeA, navbar: navbarA, edge: edgeA, sidekey: sidekeyA, advanced: advancedA, location: locationA, accessibility: accessA, update: updateA, about: aboutA, language, search: searchA };
      /* a linha da lista de cada chave (o rótulo em português, ui.js splitMark): com o dobrável aberto fica marcada a da página aberta
         e nenhuma quando a página não tem linha (Conta, Painel rápido, Pesquisa) */
      const ROW_A = { wifi: 'Ligações', bt: 'Ligações', buds: 'Ligações', connections: 'Ligações', sim: 'Ligações', hotspot: 'Ligações', vpn: 'Ligações', quickshare: 'Ligações', devices: 'Dispositivos ligados',
        focus: 'Modos e rotinas', modes: 'Modos e rotinas', sounds: 'Sons e vibração', notifications: 'Notificações', display: 'Ecrã', navbar: 'Ecrã', edge: 'Ecrã', battery: 'Bateria',
        wallpaper: 'Fundo e estilo', accent: 'Fundo e estilo', palette: 'Fundo e estilo', style: 'Fundo e estilo', homescreen: 'Ecrã principal', lockscreen: 'Ecrã bloqueado e AOD',
        passcode: 'Segurança e privacidade', security: 'Segurança e privacidade', privacy: 'Segurança e privacidade', permissions: 'Segurança e privacidade', biometrics: 'Segurança e privacidade',
        face: 'Segurança e privacidade', fingerprint: 'Segurança e privacidade', location: 'Localização', advanced: 'Funcionalidades avançadas', sidekey: 'Funcionalidades avançadas',
        screentime: 'Bem-estar digital', wellbeing: 'Bem-estar digital', apps: 'Aplicações', vera: 'Vera', general: 'Gestão geral', language: 'Gestão geral', accessibility: 'Acessibilidade',
        update: 'Atualização de software', about: 'Acerca do telefone' };
      const markA = k => { if (UI.splitMark) UI.splitMark(win, Object.prototype.hasOwnProperty.call(ROW_A, k) ? ROW_A[k] : ''); };
      const offGoto = Bridge.on('settings:goto', k => { if (System.currentApp() !== 'settings') return; if (typeof k === 'string' && k.startsWith('app:')) { if (appInfo(k.slice(4))) markA('apps'); return; } const fn = typeof k === 'string' && Object.prototype.hasOwnProperty.call(GOTO_A, k) ? GOTO_A[k] : null; if (fn) gotoMark(fn, () => markA(k)); });
      const offInfo = Bridge.on('settings:appinfo', id => { if (System.currentApp() === 'settings' && appInfo(id)) markA('apps'); });
      win.onClose = () => { try { offGoto(); } catch (e) {} try { offInfo(); } catch (e) {} try { offStateA(); } catch (e) {} };
    };

    /* ---------- Raiz ---------- */
    if (A) { openAndroid(); return; }
    const root = UI.view({ title: 'Definições', large: true });
    const c = root.content;
    let q = '';   /* a pesquisa é reaplicada a cada repintar: senão um repintar devolvia as linhas escondidas */
    let shownSim = '';   /* o valor "Sem SIM" que a linha Serviço móvel mostra: só se repinta a raiz quando ele muda */
    const filtrar = () => holder.querySelectorAll('.li').forEach(li => { li.style.display = !q || li.textContent.toLowerCase().includes(q) ? '' : 'none'; });
    c.appendChild(UI.search('Pesquisar', s => { q = s; filtrar(); }));
    const holder = UI.el('<div></div>');
    /* A RAIZ REPINTA-SE. Era construída uma vez e nada lhe tocava: agora que o «Modo de voo» desliga mesmo o
       Wi-Fi e o hotspot, ligá-lo aqui deixava as linhas «Wi-Fi» e «Hotspot pessoal» com o valor antigo até
       se sair e voltar às Definições - e o mesmo acontecia com o que muda no Centro de controlo ou na Vera. */
    const paintRoot = () => {
    const a = acc(); const name = (S.name || `${p().firstname} ${p().lastname}`).trim();
    holder.innerHTML = '';
    const prof = UI.el(`<div class="group" style="margin-bottom:22px"><div class="li has-icon" style="padding:10px 16px">${myAvatar(a, '')}<div class="li-body"><div class="name" style="font-size:var(--t-title3);font-weight:500">${UI.esc(a.username ? '@' + a.username : name)}</div><div class="sub" style="font-size:var(--t-foot);color:var(--label2)">Conta, número, SIM e dispositivo</div></div><div class="li-chev">${g('chevR')}</div></div></div>`); prof.onclick = account;
    holder.appendChild(prof);
    holder.appendChild(UI.list([
      /* Modo de voo: desliga MESMO Wi-Fi, dados e hotspot (e o que precisa do servidor recusa enquanto estiver
         ligado - CC.online). Hotspot: o efeito é o indicador na barra de estado e o rodapé di-lo sem rodeios. */
      { items: [{ label: 'Modo de voo', icon: 'airplane', iconBg: 'var(--orange)', toggle: S.airplane, onToggle: v => set(netPatch('airplane', v)) }, { label: 'Wi-Fi', icon: 'wifi', iconBg: 'var(--blue)', value: S.airplane ? 'Modo de voo' : S.wifi ? (S.wifiNet || 'ApexNet 5G') : 'Desligado', onTap: () => conn('Wi-Fi', 'wifi') }, { label: 'Bluetooth', icon: 'bluetooth', iconBg: 'var(--blue)', value: S.bt ? 'Ativado' : 'Desativado', onTap: () => conn('Bluetooth', 'bt', undefined, 'Serve para ligar os earbuds a este telemóvel.') }, { label: window.ESim ? 'Serviço móvel' : 'Rede móvel e SIM', icon: 'cellular', iconBg: 'var(--green)', value: (shownSim = simVal()), cls: 'set-sim', onTap: sim }] },   /* "Hotspot pessoal" e "VPN" retirados (auditoria 2026-09-17): só acendiam um ícone na barra de estado */
      { items: [{ label: 'Notificações', icon: 'bell', iconBg: 'var(--red)', onTap: notifs }, { label: 'Sons e háptica', icon: 'speaker', iconBg: 'var(--pink)', onTap: sounds }, { label: 'Foco', icon: 'moon', iconBg: 'var(--indigo)', onTap: focus }, { label: 'Tempo de ecrã', icon: 'hourglass', iconBg: 'var(--indigo)', onTap: screentime }] },
      { items: [{ label: 'Geral', icon: 'gear', iconBg: 'var(--gray)', cls: 'set-geral', onTap: general },{ label: 'Centro de controlo', icon: 'sliders', iconBg: 'var(--gray)', onTap: cc }, { label: 'Ecrã e brilho', icon: 'sun', iconBg: 'var(--blue)', onTap: display }, { label: 'Cor de destaque', icon: 'sparkles', iconBg: S.accent, onTap: accent }, { label: 'Ecrã bloqueado', icon: 'lock', iconBg: 'var(--gray)', onTap: lockscreen }, { label: 'Ecrã principal', icon: 'grid', iconBg: 'var(--indigo)', onTap: () => sub('Ecrã principal', cc2 => cc2.appendChild(UI.list([{ items: [{ label: 'Mostrar etiquetas', toggle: S.showLabels !== false, onToggle: v => set({ showLabels: v }) }, { label: 'Editar ecrã principal', cls: 'blue', chevron: false, onTap: () => { System.closeApp(); setTimeout(() => Home.enterEdit(), 500); } }, { label: 'Repor disposição', cls: 'danger', chevron: false, onTap: async () => { if (await UI.confirm('Repor disposição', 'As apps voltam à ordem original.', 'Repor', true)) { set({ hiddenApps: [] }); Home.load(null); UI.toast('Disposição reposta'); } } }] }]))) }, { label: 'Fundo', icon: 'photo', iconBg: 'var(--cyan)', onTap: wallpaper }, { label: 'Vera', icon: 'sparkles', iconBg: 'linear-gradient(135deg,#FF2D55,#5E5CE6)', onTap: vera }, { label: 'Face Key e código', icon: 'faceid', iconBg: 'var(--green)', onTap: () => gotoMark(passcode, () => mark('passcode')) }, { label: 'Privacidade e segurança', icon: 'hand', iconBg: 'var(--blue)', onTap: privacy }, { label: 'Bateria', icon: 'battery', iconBg: 'var(--green)', value: S.battery + '%', onTap: battery }] },
      { items: [{ label: 'Apps', icon: 'grid', iconBg: 'var(--indigo)', onTap: appsList }, { label: 'AppShop', icon: Icons.tile('appstore'), tile: true, iconBg: 'transparent', onTap: () => System.openApp('appstore') }] },
      { items: [{ label: 'Bloquear ecrã', cls: 'center', chevron: false, onTap: () => Lock.lock() }] }
    ]));
    filtrar();
    if (UI.splitResel) UI.splitResel(win);   /* PearPhone Fold: a página aberta à direita continua marcada depois de repintar */
    };
    paintRoot(); c.appendChild(holder); UI.setRoot(win, root);
    /* PearPhone Fold aberto: lista à esquerda, a página escolhida à direita (ui.js UI.split); como o Duo, abre logo em "Geral" */
    UI.split(win, { icon: 'gear', title: 'Definições', sub: 'Escolhe uma opção na lista para a abrir aqui.', first: '.li.set-geral' });
    /* o repintar é adiado (soon) e só acontece com as Definições à FRENTE: uma janela fechada continua viva
       no LRU e não vale a pena refazê-la às escuras - o `resume` da app trata disso ao voltar. */
    win._paintRoot = () => { if (holder.isConnected) paintRoot(); };
    const rootSoon = soon(win._paintRoot);
    const offState = Bridge.on('state', pt => { if (System.currentApp() !== 'settings') return; if (touches(pt, NETK.concat(['accent', 'battery', 'name']))) rootSoon(); });
    const offSim = Bridge.on('esim:state', () => { if (simVal() !== shownSim && holder.isConnected) rootSoon(); });
    /* chaves da pesquisa global (home.js SETTINGS_INDEX) e do CC: cada uma abre a página certa. Antes só cc/account/wallpaper
       tinham destino e as outras deixavam o jogador na raiz. O "Ecrã principal" é uma entrada sem função própria: toca-se na linha. */
    /* a linha procura-se pelo rótulo de ORIGEM (I18N.source): noutra língua o texto à vista já não é o português do código */
    const rowTap = label => { const li = [...holder.querySelectorAll('.li')].find(x => { const l = x.querySelector('.li-label'); return l && String(window.I18N && I18N.source ? I18N.source(l) : l.textContent).trim() === label; }); if (li) li.click(); };
    const GOTO = { cc, account, wallpaper, notifications: notifs, sounds, focus, screentime, general, display, accent, lockscreen, vera, passcode, privacy, battery, apps: appsList, sim: () => sim(),
      wifi: () => conn('Wi-Fi', 'wifi'), bt: () => conn('Bluetooth', 'bt', undefined, 'Serve para ligar os earbuds a este telemóvel.'),
      buds: () => budsPage(conn('Bluetooth', 'bt', undefined, 'Serve para ligar os earbuds a este telemóvel.')), homescreen: () => rowTap('Ecrã principal') };   /* buds: a página do par (cartão dos auriculares) por cima do Bluetooth */
    /* a linha da lista de cada chave (rótulo em português, ui.js splitMark): PearPhone Fold aberto, fica marcada a da página aberta
       (antes ficava "Geral", a primeira aberta). O cartão da conta (Conta) é uma linha sem rótulo: marca-se o próprio cartão,
       como quando se toca nele (antes o atalho tirava todas as marcas) */
    const ROW = { cc: 'Centro de controlo', wallpaper: 'Fundo', notifications: 'Notificações', sounds: 'Sons e háptica', focus: 'Foco', screentime: 'Tempo de ecrã', general: 'Geral',
      display: 'Ecrã e brilho', accent: 'Cor de destaque', lockscreen: 'Ecrã bloqueado', vera: 'Vera', passcode: 'Face Key e código', privacy: 'Privacidade e segurança', battery: 'Bateria',
      apps: 'Apps', wifi: 'Wi-Fi', bt: 'Bluetooth', buds: 'Bluetooth', homescreen: 'Ecrã principal', sim: () => holder.querySelector('.li.set-sim'), account: () => holder.querySelector('.li') };
    const mark = k => { if (!UI.splitMark) return; const t = Object.prototype.hasOwnProperty.call(ROW, k) ? ROW[k] : ''; UI.splitMark(win, typeof t === 'function' ? t() : t); };
    /* 'app:<id>' (Informações da app nos Recentes) abre Apps › essa app, como o settings:appinfo */
    const off = Bridge.on('settings:goto', k => { if (System.currentApp() !== 'settings') return; if (typeof k === 'string' && k.startsWith('app:')) { if (appInfo(k.slice(4))) mark('apps'); return; } const fn = typeof k === 'string' && Object.prototype.hasOwnProperty.call(GOTO, k) ? GOTO[k] : null; if (fn) gotoMark(fn, () => mark(k)); });
    const offInfo = Bridge.on('settings:appinfo', id => { if (System.currentApp() === 'settings' && appInfo(id)) mark('apps'); });   /* "Informações da app" do menu de um ícone */
    win.onClose = () => { try { off(); } catch (e) {} try { offInfo(); } catch (e) {} try { offState(); } catch (e) {} try { offSim(); } catch (e) {} };   /* os ouvintes morrem com a janela (antes acumulavam a cada reabertura) */
  }
});
