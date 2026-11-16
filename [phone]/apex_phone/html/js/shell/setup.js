/* ============================================================
   SETUP - configuração inicial (first boot), como no PearPhone:
   "olá" a rodar de idioma → lista de idiomas → conta, número, código,
   avatar, nome do dispositivo, fundo, aparência, notificações, Vera → pronto.
   ⚠️ Os índices 0-9 (até ao Avatar) são usados pelo harness (Setup.goTo(5)/(7)):
   passos novos entram DEPOIS do Avatar.
   Todo o texto passa por L.t (traduções): escolher um idioma no 2.º ecrã
   traduz os passos seguintes (cada passo é construído na hora).
   ============================================================ */
/* NOVA UI (Android, 2026-10-01): os MESMOS passos, dados e RPC (account.create, account.usernameFree...) com o aspeto do
   assistente de configuração da Nova UI: "Bem-vindo!" grande com o idioma numa pílula e o botão redondo azul "Iniciar";
   nos passos, título grande à esquerda em cima, conteúdo e uma barra em baixo com "Anterior" e "Seguinte". Os textos de
   sistema falam do telemóvel NOVA / Nova UI (System.osInfo) em vez do PearPhone. O idioma escolhe-se na pílula do
   "Bem-vindo!" (o passo 1 só abre por ela e volta ao "Bem-vindo!"); os índices dos passos não mudam. */
window.Setup = (() => {
  const g = UI.g, T = s => L.t(s); let el, cur = -1, data = { lang: 'pt', username: '', pin: '', pin2: '', pinLen: 6, noPin: false, avatar: 1, wallpaper: 'auto', theme: 'light', textSize: 'normal', vera: true, faceId: true, face: null, deviceName: '', notifAll: true, islandNotifs: false }, stepEls = [];
  const isA = () => !!(window.System && System.os === 'android');
  /* texto do PearOS ou da Nova UI (os dois passam pelas traduções) */
  const TA = (ios, and) => T(isA() ? and : ios);
  const model = () => (window.System && System.osInfo ? System.osInfo().model : 'NOVA S26 Ultra');
  /* dobráveis: o modelo do aparelho em uso (o PearPhone 18 continua a mostrar o nome de sempre) */
  const fold = () => !!(window.System && System.form === 'fold');
  const iosModel = () => fold() ? (System.deviceModel || 'PearPhone Fold') : 'PearPhone 18 Pro';
  /* idioma e tema iniciais: os DEFAULTS do System, que já trazem o Config.DefaultLanguage / DefaultTheme do `ready` */
  const defLang = () => (window.System && System.DEFAULTS && System.DEFAULTS.lang) || 'pt';
  const defTheme = () => (window.System && System.DEFAULTS && ['light', 'dark', 'auto'].includes(System.DEFAULTS.theme) ? System.DEFAULTS.theme : 'light');
  /* passo condicional: a fábrica leva .skip() (ver skipAt) */
  const withSkip = (fn, skip) => { fn.skip = skip; return fn; };
  /* o mesmo formato do System.deviceName (system.js) na língua escolhida */
  const defaultDeviceName = () => { const m = isA() ? model() : 'PearPhone', u = data.username || (System.player || {}).firstname || '', lc = window.L && L.code;
    if (lc && lc !== 'pt') return lc === 'en' ? u + "'s " + m : m + ' (' + u + ')'; return m + ' de ' + u; };
  const KEYS = [['1',''],['2','ABC'],['3','DEF'],['4','GHI'],['5','JKL'],['6','MNO'],['7','PQRS'],['8','TUV'],['9','WXYZ'],['0','']]; /* o "0" centra-se por CSS (grid-column:2) */
  /* sem `style="margin:0"`: o estilo em linha ganhava a `.stp .btn-p{ margin:0 -8px }` e o botão ficava
     a 28 px das bordas (o padding do passo) em vez dos 20 px do PearOS */
  const btn = (label, cls = '') => UI.el(`<div class="btn-p ${cls}">${UI.esc(label)}</div>`);
  /* stp e nao st: .st e a classe dos EMBLEMAS de estado das apps (Faturas, Servicos, Garagem, Casa) e as regras
     de ecra inteiro do assistente aplicavam-se a eles, esticando cada emblema por cima do conteudo todo. */
  function step(o) { const s = UI.el(`<div class="stp">${o.hero ? `<div class="hero">${g(o.hero)}</div>` : ''}${o.h1 ? `<h1>${UI.esc(o.h1)}</h1>` : ''}${o.sub ? `<div class="sub">${UI.esc(o.sub)}</div>` : ''}<div class="body"></div><div class="foot"></div></div>`); s.body = s.querySelector('.body'); s.foot = s.querySelector('.foot'); return s; }
  const STEPS = [
    /* 0 · "olá" (PearOS): fundo abstrato, palavra em cursiva a rodar de idioma a cada 2,6 s, dica em baixo no mesmo idioma; toque ou deslizar para cima avança.
       Nova UI: "Bem-vindo!" (welcomeA) */
    () => { if (isA()) return welcomeA(); const s = step({}); s.classList.add('hello-step'); const hw = UI.el('<div class="hello" lang="pt"></div>'); const hh = UI.el('<div class="hello-hint"></div>'); const info = UI.el(`<div class="hello-info">${g('info')}</div>`); s.body.appendChild(hw); s.prepend(UI.el('<div class="hello-shape a"></div>'), UI.el('<div class="hello-shape b"></div>'), UI.el('<div class="hello-shape c"></div>')); s.append(hh, info); s.foot.remove();
      let i = 0; const paint = () => { const [c, word, hint] = L.HELLO[i % L.HELLO.length]; hw.textContent = word; hw.setAttribute('lang', c); hh.textContent = hint; };
      /* a palavra nunca quebra nem sai do ecrã: a caixa é a da própria palavra (largura auto) e tem de ficar 28 px dentro do ecrã (o blur da entrada
         estende a superfície); se o texto for mais largo do que 440 − 56 − 48 (padding), o tamanho da letra encolhe na proporção (só no DOM, com a fonte carregada) */
      const fit = () => { hw.style.fontSize = ''; try { const r = document.createRange(); r.selectNodeContents(hw); const w = r.getBoundingClientRect().width, avail = (hw.parentElement ? hw.parentElement.clientWidth : 440) - 56 - 48; if (w > avail && avail > 0) hw.style.fontSize = Math.floor(parseFloat(getComputedStyle(hw).fontSize) * avail / w) + 'px'; } catch (e) {} };
      paint(); requestAnimationFrame(() => requestAnimationFrame(() => { fit(); hw.classList.add('in'); }));
      if (document.fonts && document.fonts.ready) document.fonts.ready.then(() => { if (hw.isConnected) fit(); });
      /* cada palavra: .25 s de atraso, entra (1,3 s: fade + blur + subida + revelação), fica ~1,9 s, desvanece (.3 s) e a seguinte começa */
      const iv = setInterval(() => { hw.classList.remove('in'); hw.classList.add('out'); setTimeout(() => { i++; paint(); fit(); hw.classList.remove('out'); void hw.offsetWidth; hw.classList.add('in'); }, 340); }, 3800);
      s.onLeave = () => clearInterval(iv); s.onclick = () => next(); UI.swipe(s, { up: () => next(), threshold: 40 });
      info.onclick = e => { e.stopPropagation(); UI.alert({ title: iosModel(), msg: 'Apex Mobile · PearOS 26' }); };
      return s; },
    /* 1 · idioma (PearOS): globo + sugestões e, por baixo, "Mostrar mais idiomas" - a lista corrida de 15 entradas enchia o ecrã e obrigava a scroll cego */
    /* Nova UI: o idioma escolhe-se na pílula do "Bem-vindo!": este passo só abre por ela (salta-se no Seguinte e no Anterior) */
    withSkip(() => { const s = step({ hero: 'globe', h1: T('Idioma'), sub: TA('Escolhe o idioma do teu PearPhone.', 'Escolhe o idioma do telemóvel.') }); s.classList.add('lang-step');
      /* sugeridos = os idiomas SUPORTADOS (pt, en, es - docs/ARQUITETURA.md). Os outros continuam
         escolhíveis em "Mostrar mais", mas marcados: só o assistente e o código estão traduzidos neles. */
      const SUG = ['pt', 'en', 'es'];
      /* SEM linha de região: a lista de idiomas do PearOS é de uma só linha (a região escolhe-se noutro passo),
         e cada idioma daqui tem uma variante única - "Portugal" por baixo de "Português" não desambiguava
         nada e era a segunda linha espremida que fazia o cartão parecer uma tabela. */
      const wrap = UI.el('<div class="st-langs"></div>'); s.body.appendChild(wrap);
      const row = c => ({ label: L.name(c), cls: data.lang === c ? 'lang-on' : '', chevron: false, onTap: () => { data.lang = c; data.langPicked = true; L.set(c); if (isA()) go(0, true); else next(); } });
      const rest = L.ORDER.filter(c => !SUG.includes(c));
      const paint = all => { wrap.innerHTML = '';
        wrap.appendChild(UI.list([{ items: SUG.map(row) }].concat(all ? [{ header: T('Outros idiomas'), items: rest.map(row) }] : [])));
        if (!all) { const more = UI.el(`<div class="st-more"><span>${UI.esc(T('Mostrar mais idiomas'))}</span>${g('chevD', 20)}</div>`); more.onclick = () => { Sound.play('click'); paint(true); wrap.querySelector('.group-header') && wrap.querySelector('.group-header').scrollIntoView({ block: 'nearest' }); }; wrap.appendChild(more); } };
      paint(false); s.foot.remove(); return s; }, () => isA()),
    /* 2 · Aparência (PearOS 26): tamanho do texto e dos ícones - Predefinido / Médio / Grande com pré-visualização ao vivo */
    () => { const s = step({ h1: T('Aparência'), sub: T('Escolhe o tamanho do texto e dos ícones.') }); s.classList.add('ap-step'); if (!data.textSize) data.textSize = 'normal';
      /* mini-PearPhone: ilha, relógio, duas notificações COM linhas de texto, atalhos e indicador.
         Classes próprias (.n1/.n2) em vez de :nth-of-type - acrescentar a ilha teria partido a contagem. */
      const mock = UI.el(`<div class="ap-mock"><div class="ap-wp"></div><div class="ap-isl"></div><div class="ap-clock">${UI.fmtTime(new Date())}</div>
        <div class="ap-n n1"><i></i><span class="ap-nt"><span></span><span></span></span></div>
        <div class="ap-n n2"><i></i><span class="ap-nt"><span></span><span></span></span></div>
        <div class="ap-btn l">${g('flashlight', 17)}</div><div class="ap-btn r">${g('camera', 17)}</div><div class="ap-hb"></div></div>`); mock.querySelector('.ap-wp').style.backgroundImage = Wallpapers.css(data.wallpaper);
      const opts = UI.el('<div class="ap-opts"></div>'); const OPT = [['normal', T('Predefinido'), 1], ['medium', T('Médio'), 1.12], ['large', T('Grande'), 1.26]];
      const paint = () => { const o = OPT.find(x => x[0] === data.textSize) || OPT[0]; mock.style.setProperty('--k', o[2]); [...opts.children].forEach((c, i) => c.classList.toggle('on', OPT[i][0] === data.textSize)); };
      /* `.check` é o círculo de seleção do sistema (ui.css) - não se faz outro só para este ecrã */
      OPT.forEach(([v, l]) => { const o = UI.el(`<div class="ap-opt"><div class="check">${g('check')}</div><span>${UI.esc(l)}</span></div>`); o.onclick = () => { data.textSize = v; Sound.play('click'); System.setState({ textSize: v }, { noSave: true }); paint(); }; opts.appendChild(o); });
      s.body.append(mock, opts); paint(); const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    () => { const s = step({ hero: 'personCircle', h1: T('Criar conta'), sub: T('Escolhe um nome de utilizador. Vai ser o teu identificador no Apex Mobile.') }); s.classList.add('acc-step');
      /* campo PearOS: invólucro com o @ fixo à esquerda e o botão de limpar à direita (só com texto) */
      const field = UI.el(`<div class="st-field"><span class="st-at">@</span><input class="st-input" placeholder="${UI.esc(T('Nome de utilizador'))}" maxlength="16" autocapitalize="off" autocomplete="off" spellcheck="false"><div class="st-clear" title="${UI.esc(T('Apagar'))}">${g('xCircle', 21)}</div></div>`);
      const inp = field.querySelector('.st-input'), clr = field.querySelector('.st-clear'); inp.value = data.username;
      const err = UI.el('<div class="st-err"></div>'); s.body.append(field, err);
      /* estado por baixo do campo, sem alertas do browser: a verificar → Disponível ✓ / Nome já utilizado */
      let seq = 0, chk = null, free = null;
      const setState = (cls, txt) => { err.className = 'st-err' + (cls ? ' ' + cls : ''); err.textContent = txt; };
      const validate = () => { const u = inp.value.trim().toLowerCase();
        clr.classList.toggle('show', !!inp.value.length); free = null;
        clearTimeout(chk); const my = ++seq;
        if (!u) { setState('', ''); return; }
        if (!/^[a-z0-9_.]{3,16}$/.test(u)) { setState('bad', T('Entre 3 e 16 letras ou números.')); return; }
        setState('wait', T('A verificar…'));
        chk = setTimeout(async () => { const r = await Bridge.rpc('account.usernameFree', { username: u });
          if (my !== seq || !inp.isConnected) return;                       /* resposta atrasada de um texto antigo */
          free = !(r && r.ok === false); setState(free ? 'ok' : 'bad', free ? T('Disponível') : T('Esse nome já está em uso.')); }, 420); };
      inp.oninput = validate; clr.onclick = () => { inp.value = ''; validate(); inp.focus(); };
      const b = btn(T('Continuar')); b.onclick = async () => { const u = inp.value.trim().toLowerCase(); if (!/^[a-z0-9_.]{3,16}$/.test(u)) { setState('bad', T('Entre 3 e 16 letras ou números.')); Sound.play('error'); return; } const r = free === null ? await Bridge.rpc('account.usernameFree', { username: u }) : { ok: free }; if (r && r.ok === false) { setState('bad', T('Esse nome já está em uso.')); Sound.play('error'); return; } data.username = u; next(); }; inp.onkeydown = e => { if (e.key === 'Enter') b.click(); }; s.foot.appendChild(b);
      s.onLeave = () => { clearTimeout(chk); seq++; };
      validate(); setTimeout(() => inp.focus(), 500); return s; },
    /* 4 · Número / serviço móvel. Com o SIM obrigatório (painel admin › SIM e linhas › "Exigir um eSIM", Config.Sim.required)
       a conta nova NÃO tem número: aqui escolhe-se "Usar um cartão eSIM" (o leitor abre logo depois do assistente, com o
       cartão do inventário) ou "Continuar sem SIM" (sem chamadas, SMS nem Zapp: o servidor recusa com 'nosim' até ativar um
       eSIM nas Definições). Sem a exigência fica o ecrã de sempre, com o número automático. O servidor responde ao
       sim.config sem tocar em linhas (a conta ainda não existe). */
    () => { const p = System.player || {}; const s = step({ hero: 'sim', h1: T('Número de telefone'), sub: T('Este é o número associado ao teu SIM. Podes trocar de SIM mais tarde nas Definições.') }); s.classList.add('sim-step');
      const plain = () => {
        s.body.innerHTML = '';
        s.body.appendChild(UI.el(`<div class="st-card sim"><div class="sim-chip"></div><div class="sim-num">${UI.esc(UI.phone(p.phone) || (isA() ? T('Sem número') : '--'))}</div><div class="sim-row"><span>${UI.esc(T('Operadora'))}</span><b>Apex Mobile</b></div><div class="sim-row"><span>${UI.esc(T('Dispositivo'))}</span><b>${isA() ? UI.esc(model()) : 'PearPhone 18 Pro'}</b></div></div>`));
        /* dobráveis: o modelo do aparelho em uso (o PearPhone 18 continua igual) */
        if (!isA() && fold()) { const mb = s.body.querySelector('.st-card.sim .sim-row:last-child b'); if (mb) mb.textContent = iosModel(); }
      };
      const choose = (cfg) => {
        data.simReq = true;
        const h1 = s.querySelector('h1'), sub = s.querySelector('.sub');
        if (h1) h1.textContent = T('Serviço móvel');
        if (sub) sub.textContent = cfg.hasCard ? T('Encontrámos um cartão eSIM no teu inventário. Escolhe como queres continuar.') : T('Não encontrámos nenhum cartão eSIM no teu inventário. Podes continuar sem número e adicionar um eSIM mais tarde.');
        if (!data.sim) data.sim = cfg.hasCard ? 'esim' : 'none';
        if (data.sim === 'esim' && !cfg.hasCard) data.sim = 'none';
        const opt = (id, ic, title, desc, off, badge) => `<div class="st-simopt${data.sim === id ? ' on' : ''}${off ? ' off' : ''}" data-sim="${id}" role="button"><div class="st-simic">${g(ic, 22)}</div><div class="st-simtx"><b>${UI.esc(title)}</b>${badge ? `<em class="st-simok">${g('check', 12)}${UI.esc(badge)}</em>` : ''}<span>${UI.esc(desc)}</span></div><div class="st-chk">${g('check')}</div></div>`;
        s.body.innerHTML = `<div class="st-simopts">
          ${opt('esim', 'sim', T('Usar um cartão eSIM'), cfg.hasCard ? T('Lês o código QR do cartão a seguir e ficas com um número.') : T('Não tens nenhum cartão eSIM. Compra um numa loja de telemóveis.'), !cfg.hasCard, cfg.hasCard ? T('Detetado no inventário') : '')}
          ${opt('none', 'phoneDown', T('Continuar sem SIM'), T('Sem número: não fazes chamadas nem envias SMS ou Zapp. Podes adicionar um eSIM mais tarde nas Definições.'), false)}
        </div>`;
        s.body.querySelectorAll('[data-sim]').forEach(o => o.onclick = () => {
          if (o.classList.contains('off')) { Sound.play('error'); return; }
          data.sim = o.dataset.sim; Sound.play('click');
          s.body.querySelectorAll('[data-sim]').forEach(x => x.classList.toggle('on', x === o));
        });
      };
      data.simReq = false;
      plain();
      /* a escolha aparece SEMPRE (pedido do dono): deteta o cartão no inventário; \"sem SIM\" = sem número atribuído */
      Bridge.rpcRaw('sim.config', {}).then(cfg => { if (s.isConnected && cfg && cfg.ok) choose(cfg); }).catch(() => {});
      const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    /* L.tf com %s e NÃO T('...' + n + '...'): texto colado nunca coincide com a chave do dicionário
       (a chave teria de existir para cada número) e saía sempre em português */
    /* Nova UI: o código chama-se PIN (os mesmos 4 ou 6 dígitos, o mesmo account.create) */
    () => pinStep(TA('Criar código', 'Definir PIN'), () => L.tf(isA() ? 'Introduz um PIN de %s dígitos para proteger o telemóvel.' : 'Cria um código de %s dígitos para proteger o telemóvel.', data.pinLen), v => { data.pin = v; data.noPin = false; next(); }, { options: true }),
    /* "Sem código" salta a confirmação e o Face Key (o Face Key sem código não tem nada a proteger) */
    withSkip(() => pinStep(TA('Confirmar código', 'Confirmar PIN'), TA('Volta a introduzir o código.', 'Volta a introduzir o PIN.'), v => { if (v !== data.pin) { Sound.play('error'); return TA('Os códigos não coincidem', 'Os PIN não coincidem'); } data.pin2 = v; next(); }), () => data.noPin),
    /* Face Key (pedido do utilizador): escolhe-se AQUI como se abre o telemóvel. Com Face Key basta carregar no lateral: o glifo aparece na ilha e desbloqueia.
       Nova UI: "Reconhecimento facial" (a mesma chave faceIdUnlock) */
    withSkip(() => { const s = step({ hero: 'faceid', h1: TA('Face Key', 'Reconhecimento facial'), sub: TA('Escolhe como queres abrir o PearPhone. O código funciona sempre como alternativa.', 'Escolhe como queres desbloquear o telemóvel. O PIN funciona sempre como alternativa.') });
      s.classList.add('fidopt-step'); const opt = UI.el('<div class="opt fid"></div>');
      const MOCK = { face: `<div class="fid-mock"><div class="fid-glyph">${g('faceid')}</div><div class="fid-lb">${isA() ? UI.esc(T('Rosto')) : 'Face Key'}</div></div>`,
        pin: `<div class="fid-mock pin"><div class="fid-dots ${data.pinLen === 6 ? 'six' : ''}">${Array.from({ length: data.pinLen }, () => '<i></i>').join('')}</div><div class="fid-keys">${Array.from({ length: 9 }, () => '<i></i>').join('')}</div></div>` };
      (isA() ? [['face', T('Rosto'), T('Olha para o ecrã e desbloqueia.')], ['pin', T('Só PIN'), L.tf('%s dígitos de cada vez.', data.pinLen)]]
        : [['face', T('Face Key'), T('Olha e abre.')], ['pin', T('Só código'), L.tf('%s dígitos de cada vez.', data.pinLen)]]).forEach(([v, l, d]) => {
        const o = UI.el(`<div class="o ${(data.faceId ? 'face' : 'pin') === v ? 'on' : ''}"><div class="pv">${MOCK[v]}</div><div class="lb">${UI.esc(l)}</div><div class="lb2">${UI.esc(d)}</div></div>`);
        o.onclick = () => { data.faceId = v === 'face'; Sound.play('click'); [...opt.children].forEach(x => x.classList.toggle('on', x === o)); }; opt.appendChild(o); });
      s.body.appendChild(opt); const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; }, () => data.noPin),
    /* Configuração do Face Key (PearOS): anel de traços à volta da cara que se acende à medida que se roda a cabeça,
       duas análises seguidas e um visto no fim. Sem câmara no jogo, a progressão é encenada - o ecrã é o mesmo. */
    faceEnrollStep,
    () => { const s = step({ h1: T('Avatar'), sub: T('Escolhe a cor do teu avatar. Aparece nos Contactos, nas Mensagens e nas Definições.') }); s.classList.add('av-step'); if (!data.avatar) data.avatar = 1;
      const name = displayName(), ini = UI.initials(name);
      const pv = UI.el(`<div class="av-preview"><div class="avatar" style="${UI.avatarStyle(data.avatar)}">${UI.esc(ini)}</div><div class="nm">${UI.esc(name)}</div><div class="hn">@${UI.esc(data.username || 'utilizador')}</div></div>`); const big = pv.querySelector('.avatar');
      const av = UI.el('<div class="avatars"></div>');
      for (let i = 1; i <= 12; i++) { const a = UI.el(`<div class="av ${data.avatar === i ? 'on' : ''}" data-i="${i}" style="${UI.avatarStyle(i)}">${g('check')}</div>`);
        a.onclick = () => { if (data.avatar === i) return; data.avatar = i; Sound.play('click'); [...av.children].forEach(x => x.classList.toggle('on', x === a)); big.style.cssText = UI.avatarStyle(i); big.classList.remove('pop'); void big.offsetWidth; big.classList.add('pop'); }; av.appendChild(a); }
      s.body.append(pv, av, UI.el(`<div class="av-later">${UI.esc(T('Podes escolher uma fotografia mais tarde em Definições › Conta.'))}</div>`));
      const b = btn(T('Continuar')); b.onclick = () => { if (!data.avatar) data.avatar = 1; next(); }; s.foot.appendChild(b); return s; },
    /* 10 · Nome do dispositivo (Fase 1): por omissão "PearPhone de <username>"; aparece em Definições › Geral › Acerca */
    () => { const s = step({ hero: 'phone', h1: T('Nome do dispositivo'), sub: TA('É assim que o teu PearPhone aparece para ti e para os outros. Podes mudá-lo em Definições › Geral.', 'É assim que o teu telemóvel aparece para ti e para os outros. Podes mudá-lo em Definições › Acerca do telefone.') }); s.classList.add('acc-step', 'dev-step');
      const field = UI.el(`<div class="st-field"><input class="st-input" style="padding-left:17px" maxlength="32" autocomplete="off" spellcheck="false" placeholder="${UI.esc(defaultDeviceName())}"><div class="st-clear" title="${UI.esc(T('Apagar'))}">${g('xCircle', 21)}</div></div>`);
      const inp = field.querySelector('.st-input'), clr = field.querySelector('.st-clear'); inp.value = data.deviceName || defaultDeviceName();
      const err = UI.el('<div class="st-err"></div>'); s.body.append(field, err);
      const sync = () => clr.classList.toggle('show', !!inp.value.length); inp.oninput = sync; sync();
      clr.onclick = () => { inp.value = ''; sync(); inp.focus(); };
      /* vazio volta ao nome por omissão (nunca fica um telemóvel sem nome); sem < > para não haver HTML num sítio onde o nome é mostrado */
      const b = btn(T('Continuar')); b.onclick = () => { const v = inp.value.replace(/[<>]/g, '').trim().slice(0, 32); data.deviceName = v || defaultDeviceName(); next(); };
      inp.onkeydown = e => { if (e.key === 'Enter') b.click(); }; s.foot.appendChild(b);
      setTimeout(() => { if (inp.isConnected) inp.focus(); }, 500); return s; },
    /* Imagem de fundo (2026-09-20): CARROSSEL como a galeria de fundos do PearOS. Antes eram colunas `flex-wrap:nowrap` a 118 px
       feitas para TRÊS fundos; com cinco (a cor do aparelho + os quatro oficiais) o flex esmagava-as em tiras de 45 px. Agora
       cada fundo é um cartão com a proporção do ecrã, com o relógio do ecrã bloqueado por cima (é assim que o PearOS mostra
       um fundo), deslizam na horizontal com paragem ao centro e o escolhido fica centrado ao entrar no passo. */
    () => { const s = step({ hero: 'photo', h1: T('Imagem de fundo'), sub: TA('Escolhe um fundo para o teu PearPhone. Podes alterá-lo mais tarde nas Definições.', 'Escolhe um fundo para o teu telemóvel. Podes alterá-lo mais tarde nas Definições.') }); s.classList.add('wp-step'); const opt = UI.el('<div class="opt wp-car"></div>');
      /* "Cor do aparelho" JÁ É o fundo da cor do aparelho: o mesmo fundo outra vez com o nome da cor (Preto num S26 preto,
         Bordô num PearPhone bordô) era um cartão repetido. Fica só o "Cor do aparelho", que ainda acompanha o aparelho. */
      const all = Wallpapers.list(), autoCss = (all.find(w => w.auto) || {}).css;
      const wps = all.filter(w => w.auto || !autoCss || w.css !== autoCss).slice(0, 9);
      const cur0 = Wallpapers.resolve ? Wallpapers.resolve(data.wallpaper) : data.wallpaper, curId = wps.some(w => w.id === cur0) ? cur0 : 'auto';
      /* offsetLeft conta a partir do carrossel (position:relative no CSS): o escolhido para no centro do ecrã */
      const center = (o, smooth) => { if (!o || !opt.isConnected) return; const x = o.offsetLeft + o.offsetWidth / 2 - opt.clientWidth / 2; try { opt.scrollTo({ left: x, behavior: smooth ? 'smooth' : 'auto' }); } catch (e) { opt.scrollLeft = x; } };
      wps.forEach(w => { const o = UI.el(`<div class="o ${curId === w.id ? 'on' : ''}"><div class="pv ${w.dark ? 'pv-dark' : 'pv-light'}"><i class="pv-isl"></i><div class="pv-date">${UI.esc(UI.DIAS_C[new Date().getDay()] + ' ' + UI.fmtDate(new Date(), true))}</div><div class="pv-time">9:41</div><i class="pv-hb"></i></div><div class="lb">${UI.esc(w.name)}</div></div>`); const pv = o.querySelector('.pv'); pv.style.backgroundImage = w.css;
        o.onclick = () => { data.wallpaper = w.id; [...opt.children].forEach(x => x.classList.toggle('on', x === o)); System.setState({ wallpaper: w.id }, { noSave: true }); Sound.play('click'); center(o, true); }; opt.appendChild(o); });
      s.body.appendChild(opt); s.onEnter = () => center(opt.querySelector('.o.on') || opt.firstElementChild, false);
      const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    () => { const s = step({ hero: 'sun', h1: T('Claro ou escuro'), sub: T('Claro, escuro ou automático (segue a hora do dia).') }); s.classList.add('th-step'); const opt = UI.el('<div class="opt"></div>');
      /* O MESMO mini-ecrã nos três previews, só com o tema trocado. O "Automático" era um
         `linear-gradient(135deg,claro 50%,preto 50%)` por baixo de uma lista sempre clara - daí o
         triângulo preto solto. Agora são duas cópias reais: a clara por baixo e a escura recortada
         à direita por um contentor de 50 % com overflow:hidden (sem clip-path, que o CEF não gosta). */
      const face = t => `<div class="th-face ${t}"><div class="th-sb"></div><div class="th-list"><i></i><i></i><i></i></div><div class="th-hb"></div></div>`;
      [['light', T('Claro')], ['dark', T('Escuro')], ['auto', T('Automático')]].forEach(([v, l]) => {
        const inner = v === 'auto' ? `${face('light')}<div class="th-half">${face('dark')}</div>` : face(v);
        const o = UI.el(`<div class="o ${data.theme === v ? 'on' : ''}"><div class="pv th-mock ${v}">${inner}</div><div class="lb">${UI.esc(l)}</div></div>`); o.onclick = () => { data.theme = v; [...opt.children].forEach(x => x.classList.toggle('on', x === o)); System.setState({ theme: v }, { noSave: true }); }; opt.appendChild(o); }); s.body.appendChild(opt); const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    /* Notificações (Fase 1): interruptor geral (notifAll) e a Dynamic Island (islandNotifs) - os mesmos das Definições › Notificações */
    () => { const s = step({ hero: 'bell', h1: T('Notificações'), sub: T('Escolhe se as apps te podem avisar. Podes afinar app a app em Definições › Notificações.') }); s.classList.add('vera-step', 'notif-step');
      /* Nova UI: não há Dynamic Island (as notificações saem em cartão flutuante): só o interruptor geral */
      /* PearPhone Fold: também não há ilha (só a câmara): as notificações saem sempre em banner */
      const paint = () => { const A = isA(), F = !A && fold(); s.body.innerHTML = ''; s.body.appendChild(UI.list([{ items: [{ label: T('Permitir notificações'), toggle: data.notifAll !== false, onToggle: v => { data.notifAll = v; paint(); } }]
        .concat(data.notifAll !== false && !A && !F ? [{ label: T('Mostrar na Dynamic Island'), toggle: !!data.islandNotifs, onToggle: v => { data.islandNotifs = v; } }] : []) },
        { footer: data.notifAll !== false ? (A ? T('As notificações aparecem num cartão flutuante no topo do ecrã e ficam no painel de notificações.') : F ? T('As notificações aparecem num banner no topo do ecrã e ficam no Centro de notificações.') : T('Na Dynamic Island, as notificações aparecem na ilha em vez de num banner quando ela está livre.')) : T('Nenhuma app mostra notificações. As chamadas continuam a tocar.') }])); };
      paint(); const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    /* Vera: a tecla mostrada é a REAL (Config.VeraKey vem no `ready`); sem tecla configurada a linha não aparece */
    () => { const s = step({ hero: 'sparkles', h1: T('Vera'), sub: T('A Vera é a tua assistente. Abre apps, faz chamadas, envia mensagens e controla o telemóvel por comandos.') }); s.classList.add('vera-step'); const key = (System.config && System.config.veraKey) || '';
      s.body.appendChild(UI.list([{ items: [{ label: T('Ativar Vera'), toggle: data.vera, onToggle: v => data.vera = v }].concat(key ? [{ label: T('Tecla de atalho'), value: key }] : []) }, { footer: T('Podes mudar isto em Definições > Vera.') }])); const b = btn(T('Continuar')); b.onclick = next; s.foot.appendChild(b); return s; },
    () => { const s = step({ hero: 'checkCircle', h1: T('Tudo pronto'), sub: isA() ? L.tf('Bem-vindo, %s. O teu %s está pronto a usar.', data.username, model()) : L.tf('Bem-vindo, %s. O teu PearPhone está configurado.', data.username) }); s.classList.add('done-step');
      /* resumo: rótulo minúsculo em maiúsculas + valor, como um cartão agrupado do PearOS.
         O código mostra tantos pontos quantos os dígitos escolhidos (4 ou 6) - nunca o código real. */
      /* com o SIM obrigatório a conta ainda não tem número: diz-se o que vem a seguir */
      const numTxt = data.simReq ? (data.sim === 'esim' ? T('Ativar o eSIM a seguir') : T('Sem SIM')) : (UI.phone((System.player || {}).phone) || (isA() ? T('Sem número') : '--'));
      const rows = [[T('Utilizador'), '@' + data.username], [T('Número'), numTxt],
        [TA('Código', 'PIN'), data.noPin ? TA('Sem código', 'Sem PIN') : '•'.repeat(data.pin.length || data.pinLen)], [TA('Face Key', 'Reconhecimento facial'), data.faceId && !data.noPin ? T('Configurado') : T('Não configurado')],
        [T('Nome do dispositivo'), data.deviceName || defaultDeviceName()]];   /* no fim: a linha [3] (Face Key) recebe a fotografia logo abaixo */
      const card = UI.el(`<div class="st-card">${rows.map(([k, v]) => `<div class="sim-row"><span>${UI.esc(k)}</span><b>${UI.esc(v)}</b></div>`).join('')}</div>`);
      /* a fotografia da cara tirada na inscrição: prova, num relance, que o Face Key leu mesmo o personagem */
      if (data.face && !data.noPin) { const row = card.querySelectorAll('.sim-row')[3]; const ph = UI.el('<div class="fid-shot"></div>'); ph.style.backgroundImage = `url("${data.face}")`; row.insertBefore(ph, row.querySelector('b')); }
      s.body.appendChild(card);
      const fin = isA() ? T('Concluir') : T('Começar a usar');
      const b = btn(fin === 'Concluir' && window.L && L.code && L.code !== 'pt' ? T('Começar a usar') : fin); b.onclick = finish; s.foot.appendChild(b); return s; },
  ];
  /* ---------- Nova UI: "Bem-vindo!" ----------
     A saudação está no idioma escolhido (o primeiro ecrã tem de se ler na língua de quem o escolhe), a pílula abre a lista
     de idiomas e o botão redondo azul avança. Sem animações em ciclo: entra uma vez com o passo. */
  const HELLO_A = { pt: 'Bem-vindo!', en: 'Welcome!', es: '¡Bienvenido!', fr: 'Bienvenue !', de: 'Willkommen!', it: 'Benvenuto!', nl: 'Welkom!', pl: 'Witamy!', tr: 'Hoş geldiniz!', sv: 'Välkommen!', ru: 'Добро пожаловать!', ja: 'ようこそ！', ko: '환영합니다!', 'zh-Hans': '欢迎！', 'zh-Hant': '歡迎！' };
  const START_A = { pt: 'Iniciar', en: 'Start', es: 'Empezar', fr: 'Commencer', de: 'Starten', it: 'Inizia', nl: 'Starten', pl: 'Rozpocznij', tr: 'Başla', sv: 'Starta', ru: 'Начать', ja: '開始', ko: '시작', 'zh-Hans': '开始', 'zh-Hant': '開始' };
  const SVA = (d, sw = 1.9) => `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="${sw}" stroke-linecap="round" stroke-linejoin="round">${d}</svg>`;
  function welcomeA() {
    const s = step({}); s.classList.add('asu-welcome'); s.foot.remove();
    const lc = data.lang || 'pt';
    const hi = UI.el(`<div class="asu-hi">${UI.esc(HELLO_A[lc] || HELLO_A.pt)}</div>`);
    const pill = UI.el(`<div class="asu-lang" role="button">${SVA('<circle cx="12" cy="12" r="8.6"/><path d="M3.4 12h17.2M12 3.4c2.4 2.4 3.6 5.3 3.6 8.6s-1.2 6.2-3.6 8.6c-2.4-2.4-3.6-5.3-3.6-8.6S9.6 5.8 12 3.4z"/>', 1.6)}<span>${UI.esc(L.name ? L.name(lc) : lc)}</span>${SVA('<path d="m7 10 5 5 5-5"/>', 2)}</div>`);
    const start = UI.el(`<div class="asu-start"><div class="asu-go" role="button" aria-label="${UI.esc(START_A[lc] || START_A.pt)}">${SVA('<path d="M5 12h13.6M13 6.4 18.6 12 13 17.6"/>', 2.2)}</div><span>${UI.esc(START_A[lc] || START_A.pt)}</span></div>`);
    const info = UI.el(`<div class="asu-info" role="button">${SVA('<circle cx="12" cy="12" r="8.6"/><path d="M12 11v5.2M12 7.8h.01"/>', 1.8)}</div>`);
    s.body.append(hi, pill); s.append(start, info);
    pill.onclick = () => { Sound.play('click'); go(1); };
    start.querySelector('.asu-go').onclick = e => { e.stopPropagation(); next(); };
    info.onclick = e => { e.stopPropagation(); const o = System.osInfo ? System.osInfo() : { model: 'NOVA S26 Ultra', osName: 'Nova UI', osVersion: '9' }; UI.alert({ title: o.model, msg: `Apex Mobile · ${o.osName} ${o.osVersion}` }); };
    return s;
  }
  /* Nova UI: a barra de baixo de cada passo ("Anterior" à esquerda, o botão principal à direita como "Seguinte").
     Os links do passo (Apagar, Opções de PIN, Configurar mais tarde) ficam por cima dela. */
  function decorateA(s) {
    s.classList.add('asu-stp');
    /* os campos do assistente avançam com a tecla de ação do teclado NOVA (seta azul) */
    s.querySelectorAll('.st-input').forEach(i => i.setAttribute('enterkeyhint', 'next'));
    /* campo contornado da Nova UI: rotulo flutuante por cima do texto (depois do input, para o CSS o pintar de azul com
       foco) e contorno vermelho enquanto a ajuda por baixo mostra um erro */
    s.querySelectorAll('.st-field').forEach(f => {
      const i = f.querySelector('.st-input'); if (!i || f.querySelector('.asu-flab')) return;
      i.after(UI.el(`<span class="asu-flab">${UI.esc(s.classList.contains('dev-step') ? T('Nome') : T('Nome de utilizador'))}</span>`));
      const e = f.nextElementSibling; if (!e || !e.classList.contains('st-err')) return;
      const bad = () => f.classList.toggle('asu-bad', e.classList.contains('bad')); bad();
      try { new MutationObserver(bad).observe(e, { attributes: true, attributeFilter: ['class'] }); } catch (x) {}
    });
    const back = s.querySelector(':scope > .st-back'); const foot = s.querySelector(':scope > .foot'); const main = foot && foot.querySelector(':scope > .btn-p');
    if (!back && !main) return;
    const nav = UI.el('<div class="asu-nav"><div class="asu-l"></div><div class="asu-r"></div></div>');
    if (back) nav.firstElementChild.appendChild(back);
    /* "Seguinte" ainda sem tradução nalgum idioma: fica o "Continuar" desse idioma (nunca português no meio de inglês) */
    if (main) { if (main.textContent === T('Continuar')) { const nx = T('Seguinte'); main.textContent = nx === 'Seguinte' && window.L && L.code && L.code !== 'pt' ? T('Continuar') : nx; } nav.lastElementChild.appendChild(main); }
    s.appendChild(nav); s.classList.add('asu-hasnav');
  }
  /* Código de 4 ou 6 dígitos (o PearOS pede 6 por omissão e oferece "Opções de código"):
     opts.options mostra o botão só no passo de CRIAR - no de confirmar o comprimento já está decidido. */
  function pinStep(h1, sub, onDone, opts = {}) {
    const s = step({ hero: 'lock', h1, sub: typeof sub === 'function' ? sub() : sub }); s.classList.add('pin-step'); let entry = '';
    const dots = UI.el('<div class="dots pin-dots"></div>');
    const subEl = s.querySelector('.sub');
    /* sem estilos em linha: os pontos do assistente são desenhados por CSS (.stp .pin-dots .dot) -
       o .dot global tem contorno BRANCO, que serve ao ecrã bloqueado mas some no fundo claro do assistente */
    const buildDots = () => { dots.innerHTML = '<span class="dot"></span>'.repeat(data.pinLen); dots.classList.toggle('six', data.pinLen === 6); };
    const lbl = UI.el('<div class="pc-label" style="min-height:22px"></div>'); const kp = UI.el(`<div class="keypad">${KEYS.map(([n, l]) => `<div class="key" data-n="${n}"><span class="num">${n}</span>${l ? `<span class="abc">${l}</span>` : ''}</div>`).join('')}</div>`);
    /* "Apagar" só existe quando já há dígitos (no PearPhone o botão aparece com o primeiro toque) */
    const del = UI.el(`<div class="link st-del">${UI.esc(T('Apagar'))}</div>`);
    const paint = () => { [...dots.children].forEach((d, i) => d.classList.toggle('on', i < entry.length)); del.classList.toggle('show', entry.length > 0); };
    buildDots(); paint();
    kp.onclick = e => { const k = e.target.closest('.key[data-n]'); if (!k || entry.length >= data.pinLen) return; Sound.play('keypad'); entry += k.dataset.n; paint();
      const d = dots.children[entry.length - 1]; if (d) { d.classList.remove('pop'); void d.offsetWidth; d.classList.add('pop'); }   /* o ponto acende com um toque de mola (~130 ms) */
      if (entry.length === data.pinLen) setTimeout(() => { const err = onDone(entry); if (err) { lbl.textContent = err; lbl.classList.add('err'); dots.classList.add('shake'); setTimeout(() => { dots.classList.remove('shake'); entry = ''; paint(); }, 500); } }, 130); };
    s.body.append(dots, lbl, kp); del.onclick = () => { entry = entry.slice(0, -1); paint(); }; s.foot.appendChild(del);
    /* Nova UI: o teclado do PIN tem a sua tecla de apagar (à direita do 0), como no ecrã de bloqueio */
    if (isA()) { const dk = UI.el(`<div class="key asu-del" role="button" aria-label="${UI.esc(T('Apagar'))}"><svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M9 5.6h10.2a1.8 1.8 0 0 1 1.8 1.8v9.2a1.8 1.8 0 0 1-1.8 1.8H9L3.2 12z"/><path d="m11.6 9.4 5.2 5.2M16.8 9.4l-5.2 5.2"/></svg></div>`);
      dk.onclick = e => { e.stopPropagation(); if (!entry) return; Sound.play('keypad'); del.onclick(); }; kp.appendChild(dk); }
    if (opts.options) {
      const ob = UI.el(`<div class="link st-pinopt">${UI.esc(TA('Opções de código', 'Opções de PIN'))}</div>`);
      ob.onclick = async () => { Sound.play('click');
        const pick = await UI.actionSheet({ title: TA('Opções de código', 'Opções de PIN'), cancel: T('Cancelar'), buttons: [
          { label: TA('Código de 6 dígitos', 'PIN de 6 dígitos'), value: 6 }, { label: TA('Código de 4 dígitos', 'PIN de 4 dígitos'), value: 4 }, { label: TA('Sem código', 'Sem PIN'), value: 'none', danger: true }] });
        /* "Sem código" (Fase 1): qualquer pessoa com o telemóvel na mão o abre - pede-se confirmação e
           seguem-se os passos sem confirmar código nem Face Key; a conta é criada com pin '' */
        if (pick === 'none') {
          if (!await UI.confirm(TA('Continuar sem código?', 'Continuar sem PIN?'), TA('Sem código, qualquer pessoa com o telemóvel consegue abri-lo. Podes ativar um código mais tarde em Definições › Face Key e código.', 'Sem PIN, qualquer pessoa com o telemóvel consegue abri-lo. Podes definir um PIN mais tarde em Definições › Ecrã de bloqueio.'), TA('Sem código', 'Sem PIN'), true)) return;
          data.noPin = true; data.pin = ''; data.pin2 = ''; data.faceId = false; data.face = null; entry = ''; paint(); next(); return;
        }
        if (!pick || pick === data.pinLen) return;
        data.noPin = false; data.pinLen = pick; data.pin = ''; entry = ''; buildDots(); paint(); lbl.textContent = ''; lbl.classList.remove('err');
        if (subEl) subEl.textContent = L.tf(isA() ? 'Introduz um PIN de %s dígitos para proteger o telemóvel.' : 'Cria um código de %s dígitos para proteger o telemóvel.', pick); };
      s.foot.appendChild(ob);
    }
    s.onkey = e => { if (/^[0-9]$/.test(e.key)) kp.querySelector(`[data-n="${e.key}"]`).click(); else if (e.key === 'Backspace') del.click(); };
    return s;
  }
  /* ---------- Configurar o Face Key (só se o utilizador o escolheu; senão o passo salta-se) ----------
     No JOGO isto é a sério: a câmara scriptada prende-se à cara do personagem e essa vista entra
     numa <canvas> WebGL no círculo do meio do anel (js/gamerender.js) - o telemóvel FICA no ecrã,
     no sítio dele, e a cara aparece lá dentro. Os 32 traços só acendem nos ângulos que forem MESMO
     cobertos (o Lua manda-os no evento `faceCoverage`), mexendo a cabeça com o rato. São duas
     leituras, como no PearPhone, e no fim guarda-se uma fotografia da cara - tirada do próprio visor.
     Toda a mecânica vive em js/shell/faceid.js; fora do jogo o anel enche-se pelo relógio para os
     ecrãs continuarem a poder ser vistos. */
  function faceEnrollStep() {
    /* O anel vive DENTRO deste passo: nada de painéis por cima nem de esconder o aparelho. */
    const s = step({ h1: TA('Configurar o Face Key', 'Registar o rosto'), sub: T('A abrir a câmara…') });
    s.classList.add('fid-step');
    const ring = FaceID.buildRing(); s.body.appendChild(ring);
    const subEl = s.querySelector('.sub');
    const b = btn(T('Continuar'), 'dim'); const later = UI.el(`<div class="link">${UI.esc(T('Configurar mais tarde'))}</div>`);
    s.foot.append(b, later);
    let gone = false, saving = false;
    /* `accept` e `skip` são chamados pelo CLIQUE e pela TECLA (Enter / Backspace, que o Lua manda
       por Push('faceKey')): os dois caminhos entram aqui, e as guardas garantem que só o primeiro
       a chegar conta. */
    const accept = async () => {
      if (gone || saving) return;
      if (ctl.state === 'scan1done') { ctl.next(); return; }
      if (ctl.state !== 'success') return;
      saving = true; b.classList.add('dim'); subEl.textContent = T('A guardar…');
      const face = await ctl.finishUp();
      if (gone) return;
      data.faceId = true; data.face = face || null;
      next();
    };
    const skip = () => { if (gone || saving) return; ctl.stop(); data.faceId = false; data.face = null; Sound.play('click'); next(); };
    const ctl = FaceID.engine(ring, {
      onKey: k => { if (k === 'accept') accept(); else if (k === 'later') skip(); },
      onProgress: (n, t, c) => { if (c.state === 'scan1' || c.state === 'scan2') subEl.textContent = FaceID.hint(n, t); },
      onState: (st, c) => {
        if (st === 'scan1' || st === 'scan2') { subEl.textContent = FaceID.hint(0, FaceID.TICKS); b.classList.add('dim'); }
        else if (st === 'scan1done') { subEl.textContent = T('Primeira leitura concluída.'); c.el.classList.add('flash'); Sound.play('tap'); b.classList.remove('dim'); setTimeout(() => c.el.classList.remove('flash'), 520); }
        else if (st === 'success') { subEl.textContent = TA('O Face Key está configurado.', 'O reconhecimento facial está configurado.'); c.el.classList.add('ok'); Sound.play('success'); b.classList.remove('dim'); }
      }
    });
    b.onclick = accept;
    later.onclick = skip;
    s.onLeave = () => { gone = true; ctl.stop(); };   /* voltar atrás desliga a câmara a meio */
    setTimeout(() => { if (!gone) ctl.start(); }, 260);
    return s;
  }
  faceEnrollStep.skip = () => !data.faceId || data.noPin;   /* escolheu "Só código" ou "Sem código" → o passo nem aparece (nem ao voltar atrás) */
  /* nome para as iniciais do avatar: o nome de utilizador escolhido (joao_silva → "Joao Silva"), senão o nome do personagem */
  function displayName() { const p = System.player || {}; const u = (data.username || '').replace(/[._]+/g, ' ').replace(/\d+/g, '').trim().replace(/(^|\s)\S/g, c => c.toUpperCase()); const full = [p.firstname, p.lastname].filter(Boolean).join(' ').trim(); return u || full || 'Eu'; }
  /* passos condicionais: uma fábrica com .skip() a devolver true é saltada nos dois sentidos (ex.: configurar o Face Key) */
  const skipAt = i => { const f = STEPS[i]; return !!(f && f.skip && f.skip()); };
  function next() { let i = cur + 1; while (i < STEPS.length && skipAt(i)) i++; if (i > STEPS.length - 1) return; go(i); }
  /* "Anterior" (pedido do utilizador): todos os passos a partir do idioma têm um botão de voltar; a animação é a inversa (o anterior entra pela esquerda) */
  function back() { if (cur <= 0 || busy) return; let i = cur - 1; while (i > 0 && skipAt(i)) i--; go(i, true); }
  let busy = false;
  function go(i, isBack) {
    const prev = stepEls[cur]; const s = STEPS[i](); stepEls[i] = s; cur = i; const A = isA(); UI.screen().classList.toggle('hello-bg', i === 0 && !A);
    if (el) el.classList.toggle('asu', A);
    if (i > 0) { const b = UI.el(`<div class="st-back">${g('chevL')}<span>${UI.esc(T('Anterior'))}</span></div>`); b.onclick = e => { e.stopPropagation(); back(); }; b.addEventListener('pointerdown', e => e.stopPropagation()); s.prepend(b); }
    if (A) decorateA(s);
    s.classList.add(isBack ? 'enter-back' : 'enter'); el.appendChild(s); busy = true;
    try { s.onEnter && s.onEnter(); } catch (e) {}   /* já no DOM (medidas disponíveis): o passo pode centrar o que tem escolhido */
    requestAnimationFrame(() => requestAnimationFrame(() => { s.classList.remove('enter', 'enter-back'); if (prev) { prev.classList.add(isBack ? 'leave-back' : 'leave'); try { prev.onLeave && prev.onLeave(); } catch (e) {} setTimeout(() => prev.remove(), 450); } setTimeout(() => { busy = false; }, 380); }));
    Sound.play('click');
  }
  let runSeq = 0;   /* muda a cada start/stop: respostas atrasadas de um assistente anterior não arrancam o telemóvel */
  function start() {
    runSeq++;
    /* o assistente pode ser recomeçado a meio de um passo (reposição de fábrica, /phonereset): sem isto
       o passo do Face Key era apagado do DOM sem desligar a câmara e o telemóvel ficava INVISÍVEL */
    try { const s = stepEls[cur]; s && s.onLeave && s.onLeave(); } catch (e) {}
    try { System.seeThrough(false); } catch (e) {}
    el = document.getElementById('setup') || UI.el('<div id="setup"></div>'); if (!el.parentNode) UI.screen().appendChild(el); el.innerHTML = ''; el.classList.add('in'); UI.screen().classList.add('light-sb', 'hide-hb', 'setup-mode');
    if (window.Island && !Island._inited) { Island.init(); Island._inited = true; } if (window.Hardware && !Hardware._inited) { Hardware.init(); Hardware._inited = true; }
    /* o teclado também: sem isto o passo "Criar conta" dava foco ao campo e não aparecia teclado nenhum (no jogo não há teclado físico para a NUI) */
    if (window.Keyboard && !Keyboard._inited) { Keyboard.init(); Keyboard._inited = true; }
    data.username = ''; data.pin = ''; data.pin2 = ''; data.pinLen = 6; data.noPin = false; data.avatar = 1; data.faceId = true; data.face = null; data.deviceName = '';
    data.notifAll = true; data.islandNotifs = false; data.sim = null; data.simReq = false;
    data.lang = defLang(); data.theme = defTheme(); data.langPicked = false; if (window.L) L.set(data.lang); cur = -1; stepEls = []; go(0);
    removeEventListener('keydown', onKey); addEventListener('keydown', onKey);
  }
  /* o idioma/tema por omissão mudou (painel admin, System.setDefaults) com o assistente a decorrer: enquanto o jogador
     não tiver escolhido um idioma, o assistente segue o novo; o passo em curso volta a desenhar-se nessa língua */
  function defaultsChanged() {
    const host = el || document.getElementById('setup'); if (!host || !host.classList.contains('in') || cur < 0) return false;
    if (data.langPicked) return false;
    const lang = defLang(), theme = defTheme(); if (lang === data.lang && theme === data.theme) return false;
    data.lang = lang; data.theme = theme; if (window.L) L.set(lang);
    if (cur <= 1 && !busy) go(cur);   /* o "olá" e a lista de idiomas mostram o idioma escolhido; os outros passos traduzem-se pelo DOM */
    return true;
  }
  /* parar o assistente sem terminar (troca de personagem com uma conta já criada): desliga a câmara do
     Face Key se estiver a meio, larga o teclado e devolve o ecrã ao estado normal */
  function stop() {
    runSeq++;   /* um finish() à espera do account.create deixa de contar */
    removeEventListener('keydown', onKey);
    try { const s = stepEls[cur]; s && s.onLeave && s.onLeave(); } catch (e) {}
    const host = el || document.getElementById('setup'); if (!host || !host.classList.contains('in')) { cur = -1; stepEls = []; return false; }
    host.classList.remove('in', 'asu'); host.innerHTML = ''; cur = -1; stepEls = [];
    try { UI.screen().classList.remove('light-sb', 'hide-hb', 'setup-mode', 'hello-bg', 'boot-in'); } catch (e) {}
    try { System.seeThrough(false); } catch (e) {}
    return true;
  }
  function onKey(e) { const s = stepEls[cur]; if (s && s.onkey && !e.target.matches('input,textarea')) s.onkey(e); }
  async function finish() {
    const settings = Object.assign({}, System.state, { wallpaper: data.wallpaper, theme: data.theme, textSize: data.textSize || 'normal', vera: data.vera, lang: data.lang, faceIdUnlock: data.faceId !== false && !data.noPin, setupDone: true,
      /* o nome por omissão grava-se VAZIO: assim segue o aparelho em uso ("PearPhone de X" no iPhone, "NOVA S26 Ultra de X" no S26) */
      deviceName: data.deviceName && data.deviceName !== defaultDeviceName() ? data.deviceName : '', notifAll: data.notifAll !== false, islandNotifs: !!data.islandNotifs });
    /* "Sem código" → pin '' (o servidor guarda vazio: hasPin false) */
    const run = runSeq;
    /* rpcRaw: no jogo o Bridge.rpc troca { error } por null e o 'taken'/'badpin' nunca chegava a este alerta */
    /* nosim: o passo do serviço móvel foi mostrado (cartão eSIM ou sem SIM): a conta não recebe o número automático */
    const acc = await Bridge.rpcRaw('account.create', { username: data.username, pin: data.noPin ? '' : data.pin, avatar: data.avatar, settings, face: data.noPin ? '' : (data.face || ''), nosim: !!data.simReq });
    /* o assistente foi parado ou recomeçado enquanto a conta era criada (troca de personagem, reposição): esta resposta
       já não é de quem está ao telemóvel - arrancar com ela punha a conta anterior no espaço da personagem nova */
    if (run !== runSeq) return;
    /* 'exists': esta personagem JÁ tem conta (o arranque não a viu a tempo, ou outro assistente terminou primeiro). O servidor
       nunca a reescreve (antes o ON DUPLICATE KEY UPDATE punha este nome/código por cima). Em vez de um erro, carrega-se a
       conta que existe e o telemóvel arranca com ela - bloqueado, com o código DELA. */
    if (acc && acc.error === 'exists') {
      let existing = null; try { existing = await Bridge.rpcRaw('account.get'); } catch (e) {}
      if (run !== runSeq) return;
      if (existing && !existing.error && existing.username) {
        stop(); System.boot(existing);
        UI.toast(T('Esta personagem já tinha conta: telemóvel restaurado.'));
        return;
      }
      UI.alert({ title: T('Erro'), msg: T('Esta personagem já tem conta, mas não foi possível carregá-la. Fecha e volta a abrir o telemóvel.') });
      return;
    }
    if (!acc || acc.error) { const why = { taken: 'Nome de utilizador já existe.', badpin: 'O código tem de ter 4 ou 6 dígitos.', invalid: 'Nome de utilizador inválido (3 a 16 letras, números, _ ou .).' }; UI.alert({ title: T('Erro'), msg: T((acc && why[acc.error]) || 'Não foi possível criar a conta. Tenta outra vez.') }); return; }
    removeEventListener('keydown', onKey); Sound.play('success');
    const last = stepEls[cur]; try { last && last.onLeave && last.onLeave(); } catch (e) {}
    /* ---------- O assistente TRANSFORMA-SE na Home (não são duas páginas trocadas) ----------
       1. o cartão e o título dissolvem-se e o fundo do passo fica transparente → aparece o wallpaper escolhido;
       2. a meio (340 ms) o telemóvel arranca por baixo e a Home entra com mola (páginas, widgets, dock);
       3. a camada do assistente só é retirada no fim. A ilha e a barra de estado nunca saltam: a ilha vive
          fora do #setup e a cor da barra tem a sua própria transição (.25 s) ao sair de .setup-mode. */
    const scr = UI.screen();
    if (last) last.classList.add('finishing');
    scr.classList.add('boot-in');
    setTimeout(() => {
      if (run !== runSeq) return;
      el.classList.remove('in'); scr.classList.remove('hide-hb', 'setup-mode', 'hello-bg');
      System.boot(acc); Lock.unlock();
    }, 340);
    setTimeout(() => { scr.classList.remove('boot-in'); if (run === runSeq) el.innerHTML = ''; }, 1100);   /* um assistente novo entretanto aberto não é apagado */
    /* SIM obrigatório e escolheu "Usar um cartão eSIM": o leitor abre já com a Home montada (o servidor escolhe o
       cartão do inventário). Sem cartão, o próprio leitor avisa e o telemóvel fica Sem SIM até ativar um nas Definições. */
    if (data.simReq && data.sim === 'esim' && window.ESim && ESim.scan) {
      setTimeout(() => { if (run !== runSeq) return; ESim.refresh && ESim.refresh(true); setTimeout(() => { if (run === runSeq) ESim.scan({ from: 'settings' }); }, 400); }, 1500);
    }
    setTimeout(() => Notify.push({ app: 'mail', title: 'Apex Mobile', msg: 'Bem-vindo! A tua conta está ativa.' }), 2500);
  }
  /* repor: apaga no servidor e localmente e volta ao "Olá" no próprio sítio (sem recarregar a página - o telemóvel fica onde está) */
  async function reset() { if (!await UI.confirm(isA() ? T('Repor o telemóvel') : 'Repor PearPhone', 'Isto apaga a conta, contactos, mensagens, fotos e definições deste telemóvel.', 'Apagar tudo', true)) return; await Bridge.rpc('account.reset'); System.factoryReset(); }
  /* trocar de aparelho a meio do assistente: o passo atual volta a desenhar-se já no aspeto do outro sistema (os dados
     escritos ficam; o passo 1 do Android só existe pela pílula, por isso no Android volta-se ao "Bem-vindo!") */
  /* Nova UI: com o teclado aberto (criar conta, nome do dispositivo) a barra Anterior / Seguinte sobe para cima dele */
  Bridge.on('kb:show', d => { if (!el || !el.classList.contains('in') || !isA()) return; el.style.setProperty('--asu-kb', ((d && d.h) || 0) + 'px'); el.classList.add('kbup'); });
  Bridge.on('kb:hide', () => { if (!el) return; el.classList.remove('kbup'); });
  Bridge.on('os:changed', () => {
    if (!el || !el.classList.contains('in') || cur < 0) return;
    try { Keyboard.hide(); } catch (e) {}
    let i = cur; if (isA() && i === 1) i = 0;
    go(i);
  });
  return { start, stop, reset, defaultsChanged, goTo: i => { if (el && i >= 0 && i < STEPS.length) go(i); }, get data() { return data; }, get running() { return !!(el && el.classList.contains('in')); } };
})();
