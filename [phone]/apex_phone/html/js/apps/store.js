/* ===================== APP STORE - PearOS 18/26 no PearPhone 18 Pro (Hoje · Jogos · Apps · Arcade · Pesquisar) =====================
   Redesenho de 2026-09-15 ("está muito feia ainda, melhora bastante"), feito contra a AppShop real:
   · Hoje: data em maiúsculas por cima de "Hoje" + avatar; cartões-história altos (App do dia, Jogo do dia, parede de ícones,
     cartões-lista numerados), todos com arte desenhada (gradiente + formas + o ícone em grande) - sem imagens externas.
   · Jogos / Apps: carrossel 16:10 com a faixa seguinte a espreitar, prateleiras de linhas em colunas de 3, top numerado, categorias.
   · Arcade: cartão escuro de apresentação (decorativo, sem subscrição real) + grelha de jogos.
   · Pesquisar: "Descobrir", "Sugestões para ti", categorias em gradiente; resultados com capturas desenhadas.
   · Página da app: ícone 118, faixa de informação que desliza, Novidades, Pré-visualização, avaliações, Informações.
   Instalar/desinstalar continua a ser System.install/uninstall (OBTER → anel → ABRIR).
   ⚠️ O botão chama-se .as-get e NÃO .as-btn: .as-btn é a classe dos botões da folha de ações do sistema (ui.css) e as regras
   antigas da loja vazavam para TODAS as action sheets do telemóvel (botões em pílula de 32 px).
   DESEMPENHO: cada separador constrói-se só quando é aberto e fica guardado (voltar a ele não reconstrói nada); instalar ou
   desinstalar pinta SÓ os botões dessa app (nunca se reconstrói o separador); cliques por delegação (um ouvinte na janela em vez de
   um closure por botão/linha); pesquisa com espera e guarda de sequência; sombras estáticas; content-visibility nos cartões.
   1.5.0 (2026-11-11, Liquid Glass): vidro (.lg, com o brilho do toque do glass.js) só na camada de controlo que flutua sobre o
   conteúdo: avatar da conta, voltar e partilhar na página da app (a partilha passou para a barra), campo de pesquisa fixo e as
   pastilhas "Descobrir", "Jogar grátis" e a faixa da app dos cartões-história (vidro clear sobre a arte). As cápsulas OBTER/ABRIR
   têm o material desenhado no ::before delas (é ele que encolhe até ao anel). Luz ambiente no topo de cada separador e da página
   da app (.as-amb, com a paleta da app do topo). Categorias em mosaicos com o rótulo em vidro clear. NOVA Store: só CSS
   (oneui-apps3.css), mais o fundo ambiente da página da app e a faixa translúcida dos destaques. */
App.define('appstore', {
  name: 'AppShop', core: true, category: 'Utilitários',
  open(win) {
    const g = UI.g, esc = UI.esc; let tabs = null;
    /* NOVA UI (Android) = NOVA Store: a mesma loja (catálogo, instalar, classificações, avaliações), outro desenho. A = Android;
       os ganchos dos botões e das secções de avaliação vêm daqui para a mesma lógica servir os dois desenhos. */
    const A = !!(System.isAndroid && System.isAndroid());
    const GET = A ? 'astore-get' : 'as-get', RING = A ? '.astore-prog' : '.as-ring', IFINST = A ? '.astore-ifinst' : '.as-ifinst';
    const labelOf = s => A ? (s === 'open' ? 'Abrir' : s === 'loading' ? 'A instalar' : 'Instalar') : (s === 'open' ? 'ABRIR' : 'OBTER');
    /* insertAdjacentHTML em vez de UI.el: o UI.el devolve só o PRIMEIRO elemento raiz e as secções da loja são sequências de blocos */
    const add = (node, html) => { node.insertAdjacentHTML('beforeend', html); if (html.indexOf('data-media') > -1 || html.indexOf('data-shot') > -1) hydrate(node); return node; };

    /* ---------- catálogo ---------- */
    const catalog = () => App.ids().filter(id => { const d = App.get(id); return d && !d.core && !d.hidden; });
    /* cor + glifo por categoria (arte dos cartões, mosaicos de categorias, capturas desenhadas) */
    const CAT = {
      'Top Apps': { c: '#5AA0F2', c2: '#2D6FD1', icon: 'star' }, 'Jogos': { c: '#FF9F5A', c2: '#E0692A', icon: 'rocket' },
      'Redes sociais': { c: '#FF6B8A', c2: '#D93A75', icon: 'users' }, 'Compras': { c: '#5FCB86', c2: '#23905A', icon: 'cart' }, 'Finanças': { c: '#4FC1C9', c2: '#1B7F9E', icon: 'card' },
      'Comunicação': { c: '#7C8CF8', c2: '#4A48C8', icon: 'message' }, 'Utilitários': { c: '#8FA3B8', c2: '#4E6078', icon: 'gear' }, 'Produtividade': { c: '#A98BF7', c2: '#6446C9', icon: 'briefcase' },
      'Entretenimento': { c: '#FF7A66', c2: '#C93A4E', icon: 'tv' }, 'Navegação': { c: '#5AC8FA', c2: '#1F7FD0', icon: 'map' }, 'Criatividade': { c: '#F4C542', c2: '#D9822B', icon: 'photo' },
      'Estilo de vida': { c: '#FF8FB1', c2: '#C94A8C', icon: 'home' }, 'Anónimo': { c: '#6E6AE8', c2: '#23214F', icon: 'ghost' }, 'Comida': { c: '#FFA95A', c2: '#E4502E', icon: 'bag2' },
      'Terceiros': { c: '#C7B299', c2: '#7E6749', icon: 'globe' },
      /* apps de trabalho criadas no painel admin (capps.js; Config.CustomApps.categories) */
      'Serviços públicos': { c: '#4C8DFF', c2: '#1D3FA8', icon: 'shield' }, 'Emprego': { c: '#2FC6A0', c2: '#127A6A', icon: 'briefcase' }, 'Empresas': { c: '#FFB547', c2: '#D2661E', icon: 'bank' },
    };
    const catOf = id => (App.get(id) || {}).category || 'Terceiros';
    const colOf = id => CAT[catOf(id)] || CAT.Terceiros;
    const isGame = id => /jogo|game|arcade/i.test(catOf(id));
    const FEAT_ORDER = ['recado', 'instashot', 'marketplace', 'match', 'services', 'garage'];
    const ordered = () => { const ids = catalog(); return FEAT_ORDER.filter(id => ids.includes(id)).concat(ids.filter(id => !FEAT_ORDER.includes(id))); };
    const games = () => catalog().filter(isGame);
    const appsOnly = () => ordered().filter(id => !isGame(id));
    /* números "de loja" estáveis por app (a mesma app mostra sempre a mesma classificação, tamanho, posição na tabela…) */
    const num = (id, m, o = 0) => { let h = 0; for (const ch of String(id)) h = (h * 31 + ch.charCodeAt(0)) | 0; return Math.abs(h) % m + o; };
    /* CLASSIFICAÇÕES A SÉRIO (2026-09-20, server/appstore.lua): média e contagem por app vêm do servidor (apps.ratingsAll,
       lido ao abrir a loja e depois de cada classificação). Antes eram números tirados do nome da app ("4,7 · 3,2 mil") e seis
       críticas assinadas por jogadores inexistentes. Sem classificações mostra-se "Sem avaliações" - não se inventa nenhuma. */
    let RAT = {}; const R = id => RAT[id] || { avg: 0, count: 0 };
    const loadRatings = async () => { const r = await Bridge.rpc('apps.ratingsAll'); if (r && typeof r === 'object' && !r.error) RAT = r; return RAT; };
    /* "tabela": as mais classificadas primeiro (contagem, depois média); empates numa ordem estável mas diferente da editorial */
    const rank = ids => ids.slice().sort((a, b) => (R(b).count - R(a).count) || (R(b).avg - R(a).avg) || (num(b + '#', 1000) - num(a + '#', 1000)));
    const rateN = id => R(id).avg;
    const rating = id => R(id).count ? R(id).avg.toFixed(1).replace('.', ',') : '--';
    const ratings = id => { const n = R(id).count; return !n ? 'Sem avaliações' : n >= 1000 ? (n / 1000).toFixed(1).replace('.', ',') + ' mil' : String(n); };
    const dev = id => (App.get(id) || {}).author || 'Apex Studios';
    const media = id => (App.get(id) || {}).media;
    const shotsOf = id => { const s = (App.get(id) || {}).shots; return Array.isArray(s) ? s.filter(x => typeof x === 'string') : []; };

    /* ---------- cores ---------- */
    /* os tons claro/escuro de cada cartão são calculados AQUI: color-mix() não existe no CEF do jogo (o relógio do lock já
       desapareceu por causa disso) */
    const hex = h => { let s = String(h || '').trim().replace('#', ''); if (s.length === 3) s = s.replace(/./g, c => c + c); const n = parseInt(s.slice(0, 6), 16); return isNaN(n) ? [128, 128, 128] : [n >> 16 & 255, n >> 8 & 255, n & 255]; };
    const mix = (a, b, t) => { const x = hex(a), y = hex(b); return '#' + x.map((v, i) => Math.round(v + (y[i] - v) * t).toString(16).padStart(2, '0')).join(''); };
    const palC = new Map();
    const palOf = k => `--c1:${k.c};--c2:${k.c2};--c3:${mix(k.c, '#ffffff', .42)};--c4:${mix(k.c2, '#000000', .45)}`;
    /* os jogos partilham a categoria "Jogos": sem isto a grelha do Arcade eram 7 cartões iguais cor de laranja. Cada jogo ganha um
       par de cores néon estável (hash do id) - é o que dá variedade às artes escuras */
    const GAME_PAL = [['#FF375F', '#7638FA'], ['#30D158', '#0A84FF'], ['#FF9F0A', '#FF375F'], ['#64D2FF', '#5E5CE6'], ['#BF5AF2', '#FF2D55'], ['#FFD60A', '#FF6B00'], ['#32D74B', '#00C7BE']];
    const pal = id => { let p = palC.get(id); if (!p) { const gp = isGame(id) ? GAME_PAL[num(id + 'pal', GAME_PAL.length)] : null; p = palOf(gp ? { c: gp[0], c2: gp[1] } : colOf(id)); palC.set(id, p); } return p; };
    /* TOM DO ÍCONE (luz ambiente, 1.5.0): a paleta da categoria nem sempre é a cor da app (o Zapp é verde e a "Comunicação" é
       índigo; com `media` o cartão mostra a imagem real). O ícone é uma imagem data: (mesma origem, o canvas não fica "sujo"):
       desenha-se a 12×12 e faz-se a média pesada pela saturação (o glifo branco e o fundo cinzento quase não contam).
       Uma vez por app (cache); se falhar (ícone vivo, transparente, imagem externa) fica a paleta da categoria. */
    const TONE = new Map();
    const toneOf = id => { let p = TONE.get(id); if (p) return p;
      p = new Promise(res => { let u = ''; try { u = (Icons.tileUrl && Icons.tileUrl(id)) || ''; } catch (e) {}
        const src = String(u).replace(/^url\(\s*['"]?/, '').replace(/['"]?\s*\)$/, ''); if (!src) { res(null); return; }
        let done = false; const fin = v => { if (!done) { done = true; res(v); } };
        const im = new Image();
        im.onload = () => { try { const c = document.createElement('canvas'); c.width = c.height = 12; const x = c.getContext('2d'); x.drawImage(im, 0, 0, 12, 12);
            const d = x.getImageData(0, 0, 12, 12).data; let r = 0, gg = 0, b = 0, w = 0;
            for (let i = 0; i < d.length; i += 4) { if (d[i + 3] < 128) continue; const mx = Math.max(d[i], d[i + 1], d[i + 2]), mn = Math.min(d[i], d[i + 1], d[i + 2]); const s = (mx - mn) / 255; const k = s * s + .002; r += d[i] * k; gg += d[i + 1] * k; b += d[i + 2] * k; w += k; }
            if (!w) { fin(null); return; }
            fin('#' + [r / w, gg / w, b / w].map(v => Math.round(v).toString(16).padStart(2, '0')).join('')); } catch (e) { fin(null); } };
        im.onerror = () => fin(null); setTimeout(() => fin(null), 1500); im.src = src; });
      TONE.set(id, p); return p; };

    /* ---------- textos ---------- */
    const DESC = { instashot: 'Partilha fotos, stories e mensagens com a cidade.', twix: 'O que se passa em Los Santos, em 280 caracteres.', reels: 'Vídeos curtos, feed vertical infinito.', darkchat: 'Salas anónimas por alcunha. As mensagens ficam guardadas no servidor.', services: 'Pede polícia, EMS, mecânico, táxi e mais.', billing: 'Recebe e paga faturas de empresas e do estado.', facetime: 'Chamadas de vídeo com os teus contactos.', reminders: 'Lembretes e listas de tarefas.', marketplace: 'Compra e vende veículos, casas e mais.', garage: 'Os teus veículos, localização e garagem.', match: 'Conhece pessoas em Los Santos.' };
    const desc = id => (App.get(id) || {}).description || DESC[id] || 'App para Los Santos.';
    /* subtítulo curto de loja (o da Apple tem ~30 caracteres); sem um próprio usa a 1.ª frase se for curta, senão a categoria.
       Nos jogos, em vez da categoria, os géneros ("Arcade · Ação"): com "Jogos" repetido em todas as linhas, na grelha do Arcade e na
       pesquisa não se distinguia nada (o bigH já fazia isto). genresOf é definido mais abaixo, mas sub só corre na construção. */
    const SUB = { recado: 'Conversas, grupos e chamadas', instashot: 'Fotos, stories e mensagens', twix: 'A cidade em tempo real', reels: 'Vídeos curtos sem fim', darkchat: 'Salas anónimas', services: 'Polícia, EMS e mecânico', billing: 'Paga faturas num toque', facetime: 'Videochamadas', reminders: 'Listas e tarefas', marketplace: 'Compra e vende na cidade', garage: 'Os teus veículos', match: 'Conhece pessoas', eats: 'Comida à tua porta', onion: 'Mercado sem nomes', crypto: 'Carteira de criptomoedas', findmy: 'Família e amigos no mapa' };
    /* 1.5.2: a 1.ª frase de uma descrição do PRÓPRIO telemóvel (a descrição é uma chave do dicionário) não é uma chave, e
       ficava em português em todos os idiomas ("Deixa cair os discos e alinha quatro"). Só serve de subtítulo quando ela
       própria tem tradução, ou quando a descrição não é do telemóvel (app de terceiros, já escrita no idioma dela). */
    const hasTr = x => !(window.I18N && I18N.t) || I18N.t(x, 'en') !== x;
    const sub = id => { if (SUB[id]) return SUB[id]; const d = desc(id), s = d.split(/[.!?](\s|$)/)[0]; return s && s.length <= 40 && (s === d || hasTr(s) || !hasTr(d)) ? s : isGame(id) ? genresOf(id).join(' · ') : catOf(id); };
    /* título/subtítulo editorial dos cartões-história */
    const TITLES = { recado: ['Conversas que ficam na cidade', 'Grupos, voz, fotos e muito mais.'], instashot: ['A cidade em fotos e stories', 'Publica o teu dia, segue quem importa.'], marketplace: ['Compra e vende com quem está online', 'Carros, casas e tudo o resto, num toque.'], match: ['Conhece pessoas em Los Santos', 'Desliza, combina, conversa.'], services: ['Polícia, EMS e mecânico num toque', 'Pede ajuda com a tua localização.'], reels: ['Vídeos curtos, sem fim', 'O feed vertical da cidade.'], twix: ['O que se passa, em 280 caracteres', 'Segue a cidade em tempo real.'], darkchat: ['Salas anónimas', 'Por alcunha. As mensagens ficam no servidor.'], garage: ['Os teus carros, sempre à mão', 'Localiza, favorita, dá alcunhas.'], billing: ['Faturas sem filas', 'Paga ou recusa num toque.'], facetime: ['Vê quem te liga', 'Chamadas de vídeo com os teus contactos.'], reminders: ['Nunca mais te esqueças', 'Lembretes e listas de tarefas.'] };
    const titleOf = id => TITLES[id] || [App.name(id), desc(id)];
    /* 1.5.2 (cliente: "some of the app descriptions are not in english"): a descrição e o subtítulo editorial iam colados num
       só nó de texto, que nunca é uma chave do dicionário (ficava em português em todos os idiomas), e sem subtítulo próprio
       o titleOf devolve a própria descrição, que aparecia duas vezes. Agora um <span> por frase (cada uma é uma chave e o
       tradutor do DOM troca-as, também ao mudar de idioma) e a segunda só quando é diferente. */
    const descH = id => { const a = desc(id), b = titleOf(id)[1]; return `<span>${esc(a)}</span>` + (b && b !== a ? ` <span>${esc(b)}</span>` : ''); };
    /* Informações > Idioma: o idioma do telemóvel, com o nome na própria língua ("English", "Deutsch"; os nomes dos idiomas
       nunca se traduzem). Era 'Português' fixo. */
    const langName = () => { try { return (window.L && L.name && L.name(L.code || 'pt')) || 'Português'; } catch (e) { return 'Português'; } };
    const langCode = () => String((window.L && L.code) || 'pt').split('-')[0].toUpperCase();
    const COLL = { 'Redes sociais': ['A cidade está a falar', 'As apps sociais que toda a gente usa em Los Santos.'], 'Comunicação': ['Sempre em contacto', 'Mensagens, chamadas e tudo pelo meio.'], 'Utilitários': ['Pequenas apps, grandes ajudas', 'Ferramentas que resolvem o dia a dia.'], 'Anónimo': ['Longe dos olhares', 'Privacidade primeiro, perguntas nunca.'] };
    const CAPS = ['Tudo num só lugar', 'Rápido e sem filas', 'Fala com quem importa', 'Feito para Los Santos'];
    /* as "Novidades" (três textos de changelog inventados) e as seis críticas de jogadores inexistentes saíram (2026-09-20):
       a secção Novidades só aparece quando a app declara `news`/`version` no App.define; as críticas são as dos jogadores */
    const GLY = ['sparkles', 'heart', 'star', 'bolt', 'flame', 'bell'];

    /* ---------- estado instalado (OBTER → anel → ABRIR) ---------- */
    /* System.isInstalled filtra o catálogo inteiro em cada chamada: uma prateleira com 20 botões fazia 20 filtros. Um Set por
       construção chega - é deitado fora sempre que o estado pode ter mudado (apps:changed, retoma, nova construção). */
    let instCache = null;
    const isInst = id => { if (!instCache) instCache = new Set(System.installed()); return instCache.has(id); };
    const busy = new Map();   /* id → início da transferência (ms): botões criados a meio mostram o anel já adiantado */
    const DUR = 1200;
    const stOf = id => isInst(id) ? 'open' : busy.has(id) ? 'loading' : 'get';
    /* anel de progresso só com transform: duas meias-luas rodam dentro de metades com overflow:hidden (regra CEF - nada de
       animar stroke-dashoffset). --d é um atraso NEGATIVO para um botão criado a meio da transferência entrar no ponto certo. */
    const ringH = id => `<i class="as-ring" style="--d:${busy.has(id) ? -(Date.now() - busy.get(id)) : 0}ms"><i class="h r"><i></i></i><i class="h l"><i></i></i><b></b></i>`;
    const getH = (id, cls = '') => { const s = stOf(id); return `<div class="as-get nostop ${cls} is-${s}" data-id="${esc(id)}"><span>${s === 'open' ? 'ABRIR' : 'OBTER'}</span>${s === 'loading' ? ringH(id) : ''}</div>`; };
    /* "Compras integradas" saiu: era um sorteio pelo nome da app; todas as apps são gratuitas e sem compras */
    const bcH = (id, cls = '') => `<div class="as-bc">${getH(id, cls)}</div>`;
    const paint = (b, s) => { if (b.classList.contains('is-' + s)) return;
      b.classList.remove('is-get', 'is-open', 'is-loading'); b.classList.add('is-' + s);
      const lb = b.firstElementChild; if (lb && lb.tagName === 'SPAN') lb.textContent = labelOf(s);
      const r = b.querySelector(RING); if (s === 'loading') { if (!r) b.insertAdjacentHTML('beforeend', A ? progH(b.dataset.id) : ringH(b.dataset.id)); } else if (r) r.remove(); };
    /* raízes a pintar: a janela (separador visível + páginas empilhadas) e os separadores guardados que estão fora do DOM */
    const cache = [];
    const roots = () => { const r = [win]; cache.forEach(v => { if (v && !v.isConnected) r.push(v); }); return r; };
    const sel = id => `[data-id="${window.CSS && CSS.escape ? CSS.escape(id) : id}"]`;
    const btnsOf = id => roots().flatMap(r => [...r.querySelectorAll('.' + GET + sel(id))]);
    /* pinta SÓ os botões (e o "Desinstalar") de uma app - é isto que corre ao instalar, nunca uma reconstrução do separador */
    const sync1 = id => { const s = stOf(id), on = isInst(id); roots().forEach(r => { r.querySelectorAll('.' + GET + sel(id)).forEach(b => paint(b, s)); r.querySelectorAll(IFINST + sel(id)).forEach(e => { e.hidden = !on; }); }); };
    /* pinta TODOS os botões de uma raiz que o roots() não apanha (a home e os resultados da pesquisa, trocados TIRANDO-OS do DOM)
       antes de voltar a pô-la à vista. Sem isto voltavam como estavam: OBTER preso no anel, ABRIR numa app já desinstalada.
       Acerta também o atraso do anel: as animações CSS recomeçam do zero quando um nó volta ao DOM. */
    const repaint = root => { instCache = null;
      root.querySelectorAll('.' + GET).forEach(b => { const id = b.dataset.id, s = stOf(id); paint(b, s); const r = s === 'loading' && b.querySelector(RING); if (r) r.style.setProperty('--d', -(Date.now() - busy.get(id)) + 'ms'); });
      root.querySelectorAll(IFINST).forEach(e => { e.hidden = !isInst(e.dataset.id); }); };
    /* apps:changed não diz QUAL app mudou (instalar aqui, remover nas Definições ou no ecrã principal): compara-se com o último
       estado conhecido e só se pintam as que mudaram. O catálogo também pode ter mudado SEM app:defined (unregisterApp de outro
       resource só esconde a definição): compara-se a lista e, se mudou, os separadores guardados são refeitos como numa app nova. */
    let known = new Set(System.installed());
    let catSig = catalog().join('|');
    const onApps = () => { instCache = null; const now = new Set(System.installed()); const ch = []; now.forEach(x => { if (!known.has(x)) ch.push(x); }); known.forEach(x => { if (!now.has(x)) ch.push(x); }); known = now; ch.forEach(sync1);
      const sg = catalog().join('|'); if (sg !== catSig) { catSig = sg; refreshCatalog(); } };
    let dlOwner = null;   /* a ilha só tem UMA atividade de transferência ('dl'): id da instalação que a está a usar */
    async function obter(b) {
      const id = b.dataset.id; if (!id || busy.has(id)) return;
      /* app removida por outro resource enquanto a linha estava à vista (a definição fica, escondida): não há nada para instalar */
      if (!catalog().includes(id)) { UI.toast('Esta app já não está disponível'); return; }
      instCache = null; if (isInst(id)) { System.openApp(id); return; }
      busy.set(id, Date.now()); sync1(id); Sound.play('click');
      /* o progresso vai também para a Dynamic Island (PearOS 17+); se estiver ocupada (chamada, música…) Island.download devolve
         null e no fim aparece o banner de sempre. Só a 1.ª transferência a usa: uma 2.ª substituía a atividade e o ciclo da 1.ª
         escrevia no anel da 2.ª (nome errado, visto antes do tempo e a 1.ª sem aviso) - as seguintes acabam com o banner. */
      const dl = !dlOwner && window.Island ? Island.download({ id, name: App.name(id) }) : null;
      if (dl) dlOwner = id;
      let raf = null; const t0 = Date.now();
      /* o anel da ilha tem 22 px: 16 degraus (75 ms cada) chegam, e cada chamada repinta o traço (stroke-dashoffset) - a cada frame
         era quase o dobro do trabalho da thread principal durante a instalação */
      if (dl) { let last = -1; const step = () => { const p = Math.min(1, (Date.now() - t0) / DUR), q = Math.round(p * 16); if (q !== last) { last = q; dl.progress(q / 16); } raf = p < 1 ? requestAnimationFrame(step) : null; }; step(); }
      await new Promise(r => setTimeout(r, DUR));
      if (raf) cancelAnimationFrame(raf);
      if (catalog().includes(id)) { try { await System.install(id); } catch (e) { console.error('[apex_phone] AppShop install', e); } }
      busy.delete(id); instCache = null; sync1(id); known = new Set(System.installed());
      const ok = isInst(id); const bs = btnsOf(id);
      if (ok) { bs.forEach(x => x.classList.add('pop')); setTimeout(() => bs.forEach(x => x.classList.remove('pop')), 520); Sound.play('success'); }
      /* o visto da ilha só quando instalou mesmo */
      if (dl) { if (dlOwner === id) dlOwner = null; if (ok) dl.done(); else dl.cancel(); }
      else if (ok) UI.banner({ app: 'appstore', title: 'Instalada', msg: App.name(id), iconHtml: Icons.tile(id) });
      if (!ok) UI.toast('Não foi possível instalar ' + App.name(id));
    }
    const uninstall = async id => { if (!App.get(id)) return; if (await UI.confirm('Desinstalar ' + App.name(id), 'Os dados da app são mantidos no servidor.', 'Desinstalar', true)) await System.uninstall(id); };

    /* ---------- imagens reais (media/shots de RegisterApp) ---------- */
    /* ⚠️ nunca dentro da string de HTML: um base64 lá dentro partia o atributo. Marca-se o elemento e o URL entra por style. */
    const hydrate = root => {
      root.querySelectorAll('[data-media]').forEach(e => { e.style.backgroundImage = UI.img(media(e.dataset.media)); e.removeAttribute('data-media'); });
      root.querySelectorAll('[data-shot]').forEach(e => { const p = e.dataset.shot.split('|'); const u = shotsOf(p[0])[+p[1]]; if (u) e.style.backgroundImage = UI.img(u); e.removeAttribute('data-shot'); });
    };

    /* ---------- peças ---------- */
    /* ÍCONE COMO IMAGEM, não como SVG inserido (2026-09-20): a loja mostra o mesmo ícone em muitos sítios e cada SVG no DOM
       custava 20-30 nós (eram ~1060 dos ~1250 nós desta app, e é isso que a fazia abrir devagar). Como background-image é
       UM nó e o Chromium decodifica cada ícone uma só vez. */
    const tileH = id => Icons.tileBox(id, 'as-tile');
    /* sombra de profundidade do ícone (1.5.0): o .tile.img leva máscara em squircle (shell.css) e a máscara cortava qualquer
       box-shadow dele; a sombra vive num invólucro <i class="as-tw"> (um nó a mais por ícone) */
    const tileW = id => `<i class="as-tw">${tileH(id)}</i>`;
    const starsH = (id, cls = '') => `<span class="as-stars ${cls}${R(id).count ? '' : ' none'}"><i><b style="width:${Math.round(rateN(id) / 5 * 100)}%">★★★★★</b>★★★★★</i><em>${ratings(id)}</em></span>`;
    /* linha de app (ícone 62, nome, subtítulo, OBTER); o número vai entre o ícone e o nome, como no top da Apple */
    const rowH = (id, o = {}) => `<div class="as-row${o.n != null ? ' num' : ''}" data-go="app:${esc(id)}">${tileW(id)}${o.n != null ? `<b class="as-n">${o.n}</b>` : ''}<div class="as-rb"><b>${esc(App.name(id))}</b><span>${esc(o.sub || sub(id))}</span>${o.stars ? starsH(id) : ''}</div>${bcH(id)}</div>`;
    const shH = (title, go, label = 'Ver tudo') => `<div class="as-sh"><b>${esc(title)}</b>${go ? `<a data-go="${esc(go)}">${esc(label)}</a>` : ''}</div>`;
    const secH = (title, go, inner, cls = '') => `<section class="as-sec ${cls}">${shH(title, go)}${inner}</section>`;
    /* prateleira: colunas de 3 linhas que deslizam na horizontal (a coluna seguinte espreita) */
    const shelfH = (ids, o = {}) => `<div class="as-shelf${ids.length <= 3 ? ' one' : ''}">${ids.map((id, i) => rowH(id, { n: o.num ? i + 1 : null })).join('')}</div>`;
    /* jogos: o género (Puzzle, Arcade…) em vez de "Jogos" repetido em todos; genresOf é definido mais abaixo, mas bigH só corre na construção dos separadores */
    const bigH = ids => `<div class="as-big">${ids.map(id => `<div class="as-bi" data-go="app:${esc(id)}">${tileW(id)}<b>${esc(App.name(id))}</b><span>${esc(isGame(id) ? genresOf(id)[0] : catOf(id))}</span></div>`).join('')}</div>`;
    /* arte desenhada: anel, quadrado rodado, grelha de pontos, brilho, o ícone em grande e três "bolhas" de glifos */
    const artH = id => { const k = num(id, GLY.length); return `<i class="d1"></i><i class="d2"></i><i class="d3"></i><i class="glow"></i><div class="as-aic">${tileH(id)}</div><i class="gl g1">${g(colOf(id).icon)}</i><i class="gl g2">${g(GLY[k])}</i><i class="gl g3">${g(GLY[(k + 2) % GLY.length])}</i>`; };
    const mediaH = id => `<div class="as-media" data-media="${esc(id)}"></div>`;
    /* linha da app por cima da arte: nos cartões-história é uma faixa de VIDRO clear (.lg) e o OBTER lá dentro é só tinta (.onglass,
       nunca vidro sobre vidro); no carrossel (feat) é um véu e o OBTER é a cápsula de vidro clear diretamente sobre a arte */
    const stripH = (id, cls) => cls === 'feat'
      ? `<div class="as-strip feat">${tileW(id)}<div class="as-sb"><b>${esc(App.name(id))}</b><span>${esc(sub(id))}</span></div>${getH(id, 'onart')}</div>`
      : `<div class="as-strip lg">${tileW(id)}<div class="as-sb"><b>${esc(App.name(id))}</b><span>${esc(sub(id))}</span></div>${bcH(id, 'onart onglass')}</div>`;
    /* luz ambiente no topo da vista (app-store.css .as-amb): a paleta da app do topo; sem app, as cores fixas da classe */
    /* nasce invisível e acende (.on, transição de opacidade) quando o tom do ícone chega: as cores mudam no sítio, nunca à vista */
    const ambient = (v, id, k, base = 'as-amb') => { const el = UI.el(`<i class="${base}${k ? ' ' + k : ''}"${id ? ` style="${pal(id)}"` : ''}></i>`); v.content.insertBefore(el, v.content.firstChild);
      if (!id) { el.classList.add('on'); return v; }
      toneOf(id).then(t => { if (t) { el.style.setProperty('--c1', t); el.style.setProperty('--c2', mix(t, '#000000', .3)); el.style.setProperty('--c3', mix(t, '#ffffff', .4)); } el.classList.add('on'); });
      return v; };
    const storyH = (id, o) => { const t = titleOf(id), m = !!media(id);
      return `<div class="as-story as-art v${o.k || 0}${o.top ? ' top' : ''}${o.dark ? ' dark' : ''}${m ? ' has-media' : ''}" style="${pal(id)}" data-go="app:${esc(id)}">${m ? mediaH(id) : artH(id)}<div class="as-stx"><em>${esc(o.eye)}</em><b>${esc(o.title || t[0])}</b><span>${esc(o.sub || t[1])}</span></div>${stripH(id)}</div>`; };
    const lcardH = (eye, title, ids, go, numbered) => `<div class="as-lcard" data-go="${esc(go)}"><div class="as-lch"><em>${esc(eye)}</em><b>${esc(title)}</b></div><div class="as-lrows">${ids.map((id, i) => rowH(id, { n: numbered ? i + 1 : null })).join('')}</div></div>`;
    /* parede de ícones inclinada (cartão de coleção): repete os ícones até encher 12 lugares */
    const wallH = ids => { const p = []; for (let i = 0; i < 12 && ids.length; i++) p.push(ids[i % ids.length]); return `<div class="as-wall">${p.map(tileW).join('')}</div>`; };
    const ccardH = (eye, title, subT, ids, go) => `<div class="as-ccard as-art" style="${pal(ids[0])}" data-go="${esc(go)}">${wallH(ids)}<div class="as-stx"><em>${esc(eye)}</em><b>${esc(title)}</b><span>${esc(subT)}</span></div></div>`;
    const fcH = (id, eye, k) => { const t = titleOf(id), m = !!media(id);
      return `<div class="as-fc" data-go="app:${esc(id)}"><div class="as-fch"><em>${esc(eye)}</em><b>${esc(t[0])}</b><span>${esc(t[1])}</span></div><div class="as-fart as-art v${k % 3}${isGame(id) ? ' dark' : ''}${m ? ' has-media' : ''}" style="${pal(id)}">${m ? mediaH(id) : artH(id)}${stripH(id, 'feat')}</div></div>`; };
    const catIds = c => c === 'Top Apps' ? rank(appsOnly()) : c === 'Jogos' ? rank(games()) : catalog().filter(id => catOf(id) === c);   /* "Top Jogos" é numerado: tem de seguir a mesma tabela que o "Top jogos gratuitos" */
    const catsIn = ids => { const n = {}; ids.forEach(id => { const c = catOf(id); n[c] = (n[c] || 0) + 1; }); return Object.keys(n).sort((a, b) => n[b] - n[a]); };
    /* categorias em mosaicos: a arte da categoria (paleta), o glifo grande e o rótulo numa cápsula de vidro clear */
    const catlH = cats => `<div class="as-catl">${cats.map(c => { const k = CAT[c] || CAT.Terceiros; return `<div class="as-cl" style="${palOf(k)}" data-go="cat:${esc(c)}">${g(k.icon)}<b>${esc(c)}</b></div>`; }).join('')}</div>`;
    /* os jogos são todos da categoria "Jogos": as categorias do separador Jogos são géneros (decorativos, mas cada um filtra de verdade) */
    const GENRE = { snake: ['Arcade', 'Clássicos'], g2048: ['Puzzle'], blocks: ['Puzzle', 'Clássicos'], mines: ['Puzzle', 'Estratégia'], brick: ['Arcade', 'Ação'], memory: ['Casual', 'Família'], arcade: ['Casual', 'Família'] };
    const GENRE_IC = { 'Arcade': 'joystick', 'Puzzle': 'grid', 'Clássicos': 'star', 'Estratégia': 'flag', 'Ação': 'bolt', 'Casual': 'smile', 'Família': 'users' };
    const genresOf = id => GENRE[id] || ['Casual'];
    const genreIds = n => games().filter(id => genresOf(id).includes(n));
    /* os géneros não têm categoria própria: cada um ganha um par néon estável dos jogos (hash do nome) */
    const genPal = n => { const gp = GAME_PAL[num(n + 'gen', GAME_PAL.length)]; return palOf({ c: gp[0], c2: gp[1] }); };
    const genlH = ids => { const gs = [...new Set(ids.flatMap(genresOf))]; return `<div class="as-catl">${gs.map(n => `<div class="as-cl" style="${genPal(n)}" data-go="genre:${esc(n)}">${g(GENRE_IC[n] || 'gamepad')}<b>${esc(n)}</b></div>`).join('')}</div>`; };
    const cattH = cats => `<div class="as-cats">${cats.map(c => `<div class="as-ct" style="${palOf(CAT[c] || CAT.Terceiros)}" data-go="cat:${esc(c)}"><b>${esc(c === 'Jogos' ? 'Top Jogos' : c)}</b>${g((CAT[c] || CAT.Terceiros).icon)}</div>`).join('')}</div>`;
    /* capturas desenhadas: fundo da app, frase de marketing e um ecrã de telemóvel com blocos de interface falsos (4 modelos) */
    const SHOT_BODY = [
      '<i class="hero"></i><i class="ln w1"></i><i class="ln w2"></i><i class="rw"></i><i class="rw"></i><i class="rw"></i>',
      '<i class="grid"><i></i><i></i><i></i><i></i></i><i class="ln w1"></i><i class="ln w3"></i><i class="rw"></i>',
      '<i class="bub"></i><i class="bub r"></i><i class="bub s"></i><i class="bub r s"></i><i class="bub"></i><i class="bar"></i>',
      '<i class="crd"></i><i class="ln w2"></i><i class="ln w3"></i><i class="rw"></i><i class="btn"></i>',
    ];
    const shotH = (id, k) => { const real = shotsOf(id);
      if (real.length) return `<div class="as-shot real" data-shot="${esc(id)}|${k % real.length}"></div>`;
      const cap = k === 0 && TITLES[id] ? TITLES[id][0] : CAPS[k % CAPS.length];
      return `<div class="as-shot k${k % 4}" style="${pal(id)}"><b class="cap">${esc(cap)}</b><div class="scr"><div class="hd">${k === 0 ? tileH(id) : '<i class="ic"></i>'}<i class="t"></i></div>${SHOT_BODY[k % 4]}</div></div>`; };

    /* ---------- conta (avatar) ---------- */
    const me = () => System.account ? Object.assign({}, System.account, { url: System.account.avatarPhoto || null }) : { name: 'Eu' };   /* foto da conta (§10.3): UI.avatar lê `url` */
    /* o avatar vive num círculo de vidro (.lg: brilho do toque do glass.js) ao nível do título grande, e um mais pequeno na barra */
    const withAvatar = v => { const lt = v.content.querySelector('.large-title');
      if (lt) { lt.classList.add('as-lt'); add(lt, `<div class="as-av lg" data-go="acct">${UI.avatar(me(), '')}</div>`); }
      add(v.querySelector('.nb-right'), `<div class="as-av sm lg" data-go="acct">${UI.avatar(me(), '')}</div>`); return v; };

    /* ---------- construção adiada ---------- */
    /* A vista é construída dentro de def.open(), ANTES da animação de abertura: tudo o que for pesado atrasa o primeiro frame
       da loja (era a causa do "abri a AppShop e travou tudo"). `later` guarda um lugar e enche-o dois frames depois.
       ⚠️ O rAF NÃO é garantia: se a janela não pintar (app tapada, ecrã apagado, harness) a cadeia nunca corre - o setTimeout
       é a rede de segurança e `done` garante uma só construção. Os separadores ficam guardados FORA do DOM quando se muda de
       separador, por isso não se pode exigir slot.isConnected: só se desiste de vistas deitadas fora (_dead). */
    const later = (v, fn) => {
      const slot = UI.el('<div class="as-slot"></div>'); v.content.appendChild(slot);
      let done = false;
      const run = () => { if (done || v._dead) return; done = true; instCache = null; fn(slot); };
      requestAnimationFrame(() => requestAnimationFrame(run));
      setTimeout(run, 220);
      return slot;
    };
    const view = (title, extra) => withAvatar(UI.view(Object.assign({ title, large: true, cls: 'as-v' }, extra || {})));
    const emptyPromoH = (eye, title, subT, icon, k) => `<div class="as-story as-art v1 top nostrip" style="${palOf(k)}"><i class="d1"></i><i class="d2"></i><i class="d3"></i><i class="glow"></i><div class="as-aglyph">${g(icon)}</div><div class="as-stx"><em>${esc(eye)}</em><b>${esc(title)}</b><span>${esc(subT)}</span></div></div>`;

    /* ---------- separadores ---------- */
    const today = () => {
      const v = view('Hoje'); v.classList.add('as-today');   /* PearPhone Fold aberto: os cartões em duas colunas (app-store.css) */
      v.content.insertBefore(UI.el(`<div class="as-date">${esc(UI.fmtDate(new Date()).toUpperCase())}</div>`), v.content.firstChild);   /* data por cima de "Hoje", como no PearOS */
      const all = ordered(), apps = appsOnly(), gms = games();
      if (!all.length) { v.content.appendChild(UI.empty('grid', 'Sem apps', 'Ainda não há apps opcionais nesta loja.')); return v; }
      const hero = apps[0] || all[0];
      ambient(v, hero);
      /* à cabeça só o que se vê: o cartão do dia e o cartão-lista (é também onde o harness procura a 1.ª .as-row) */
      const fav = all.filter(id => id !== hero).slice(0, 4);
      add(v.content, storyH(hero, { eye: 'App do dia', k: 0 }) + (fav.length ? lcardH('Coleção', 'Os nossos favoritos', fav, 'list:fav') : ''));
      later(v, slot => { let h = '';
        if (gms[0]) h += storyH(gms[0], { eye: 'Jogo do dia', k: 1, top: true, dark: true });
        const cat = catsIn(apps).find(c => catIds(c).length >= 3);
        if (cat) { const t = COLL[cat] || ['O melhor de ' + cat.toLowerCase(), 'Uma seleção feita pela equipa da AppShop.']; h += ccardH('Coleção', t[0], t[1], catIds(cat), 'cat:' + cat); }
        else if (all.length >= 3) h += ccardH('Coleção', 'Tudo o que precisas na cidade', 'Uma seleção feita pela equipa da AppShop.', all, 'list:fav');
        if (apps[1]) h += storyH(apps[1], { eye: 'Em destaque', k: 2, top: true });
        h += lcardH('Top gratuitas', 'As mais transferidas hoje', rank(all).slice(0, 4), 'list:today-top', true);
        if (apps[2]) h += storyH(apps[2], { eye: 'Novidade', k: 0 });
        if (gms.length > 1) h += lcardH('Jogos', 'Para jogar numa pausa', gms.slice(1, 5), 'list:ess-games');
        add(slot, h); });
      return v; };
    const EYE_G = ['Jogo do dia', 'Novidade', 'Atualização importante', 'Em destaque', 'Clássico'];
    const EYE_A = ['App do dia', 'Em destaque', 'Novidade', 'O que estamos a usar', 'Imprescindível'];
    const gamesView = () => {
      const v = view('Jogos'); const ids = games();
      if (!ids.length) { add(v.content, emptyPromoH('Jogos', 'Jogar em Los Santos', 'Ainda não há jogos nesta loja. Os jogos registados por outros resources (RegisterApp com category "Jogos") aparecem aqui.', 'rocket', CAT.Jogos)); return v; }
      /* só o carrossel à cabeça; as prateleiras entram 2 frames depois (com 7 jogos esta vista era a mais pesada da loja) */
      ambient(v, ids[0]);
      add(v.content,`<div class="as-fcar">${ids.slice(0, 5).map((id, i) => fcH(id, EYE_G[i], i)).join('')}</div>`);
      later(v, slot => add(slot, secH('Jogos a experimentar', 'list:ess-games', shelfH(ids))
        + secH('Top jogos gratuitos', 'list:top-games', shelfH(rank(ids), { num: true }))
        + secH('Categorias', null, genlH(ids))
        + secH('Os favoritos dos jogadores', null, bigH(ids.slice().reverse()))));
      return v; };
    const appsView = () => {
      const v = view('Apps'); const ids = appsOnly();
      if (!ids.length) { v.content.appendChild(UI.empty('grid', 'Sem apps', 'Ainda não há apps opcionais nesta loja.')); return v; }
      ambient(v, ids[0]);
      add(v.content, `<div class="as-fcar">${ids.slice(0, 5).map((id, i) => fcH(id, EYE_A[i], i)).join('')}</div>`);
      later(v, slot => add(slot, secH('Apps essenciais', 'list:ess-apps', shelfH(ids))
        + secH('Top apps gratuitas', 'list:top-apps', shelfH(rank(ids), { num: true }))
        + secH('Categorias principais', null, catlH(catsIn(ids).slice(0, 8)))
        + secH('Novas e dignas de nota', 'list:new-apps', bigH(ids.slice().reverse()))));
      return v; };
    const arcadeView = () => {
      const v = view('Arcade'); const ids = games();
      /* o hub Arcade tem categoria 'Jogos' de propósito (aparece nas prateleiras), mas é a ESTANTE:
         sem isto o cartão dizia "7 jogos" com 6 jogos + o hub. O `hub: true` vem do App.define('arcade'). */
      const nJogos = ids.filter(id => !(App.get(id) || {}).hub).length;
      /* cartão escuro de apresentação: decorativo (não há subscrição), o botão (vidro clear sobre a arte) só explica que os jogos estão incluídos */
      ambient(v, null, 'arc');
      add(v.content, `<div class="as-arch">${ids.length ? wallH(ids) : ''}<i class="fade"></i><div class="as-artx"><div class="as-arlogo">${g('joystick')}<span>Arcade</span></div><b>Jogos sem anúncios nem compras integradas</b><p>${nJogos ? nJogos + (nJogos === 1 ? ' jogo incluído' : ' jogos incluídos') + ' na tua conta Apex. Joga quando quiseres.' : 'Os jogos com a categoria "Jogos" aparecem aqui, sem anúncios nem compras integradas.'}</p><div class="as-arbtn lg" data-go="toast:Os jogos Arcade estão incluídos na tua conta">Jogar grátis</div><span>Incluído na tua conta · sem subscrição</span></div></div>`);
      if (ids.length) later(v, slot => add(slot, secH('Jogar agora', 'list:arcade', shelfH(ids))
        + secH('Todos os jogos', null, `<div class="as-agrid">${ids.map(id => `<div class="as-ac" data-go="app:${esc(id)}"><div class="as-acart as-art dark" style="${pal(id)}"><i class="d1"></i><i class="glow"></i>${tileW(id)}</div><b>${esc(App.name(id))}</b><span>${esc(sub(id))}</span></div>`).join('')}</div>`)));
      return v; };
    /* pesquisa: sem acentos nem maiúsculas ("anonimo" encontra "Anónimo") */
    const norm = s => String(s || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    const score = (id, q) => { const n = norm(App.name(id)); if (n.startsWith(q)) return 4; if (n.includes(q)) return 3; if (norm(catOf(id)).includes(q)) return 2; return norm(sub(id) + ' ' + desc(id) + ' ' + titleOf(id).join(' ')).includes(q) ? 1 : 0; };
    const searchView = () => {
      const v = view('Pesquisar'); ambient(v, null, 'sea');
      /* cápsula de vidro flutuante (sticky: fica presa por baixo da barra quando se desce) e o círculo de vidro de fechar */
      const field = UI.el(`<div class="as-search"><div class="as-sf lg">${g('search')}<input type="text" placeholder="Jogos, apps, histórias e mais" enterkeyhint="search"><div class="as-clr">${g('x')}</div><div class="as-mic">${g('mic')}</div></div><div class="as-cancel lg">${g('x')}</div></div>`);
      const body = UI.el('<div class="as-sbody"><div class="as-shome"></div></div>');
      v.content.appendChild(field); v.content.appendChild(body);
      const inp = field.querySelector('input'), homeEl = body.firstElementChild, resEl = UI.el('<div class="as-sres"></div>');
      const ids = ordered();
      /* o ecrã inicial da pesquisa é construído UMA vez e fica escondido enquanto há resultados (limpar o campo não reconstrói nada) */
      later(v, () => {
        const terms = [];
        [...ids.slice(0, 3).map(id => App.name(id).toLowerCase()), 'jogos', 'redes sociais', 'faturas', 'carros', 'anónimo', 'comida'].forEach(t => { if (terms.length < 6 && !terms.includes(t) && ids.some(id => score(id, norm(t)) > 0)) terms.push(t); });
        /* "Top Apps" só com apps: sem nenhuma o único mosaico abria uma lista vazia */
        const cats = [...(appsOnly().length ? ['Top Apps'] : []), ...(games().length ? ['Jogos'] : []), ...catsIn(appsOnly())];
        if (!ids.length && !cats.length) { homeEl.appendChild(UI.empty('search', 'Sem apps', 'Ainda não há apps nesta loja.')); return; }
        add(homeEl, (terms.length ? secH('Descobrir', null, `<div class="as-disc">${terms.map(t => `<div class="as-chip lg" data-go="q:${esc(t)}">${g('search')}<span>${esc(t)}</span></div>`).join('')}</div>`) : '')
          + (ids.length ? secH('Sugestões para ti', null, `<div class="as-plist">${rank(ids).slice(0, 4).map(id => rowH(id)).join('')}</div>`) : '')
          + (cats.length ? secH('Explorar categorias', null, cattH(cats)) : ''));
      });
      let timer = null, seq = 0, lastQ = null;
      const results = q => {
        const hits = ids.map(id => [id, score(id, q)]).filter(x => x[1] > 0).sort((a, b) => b[1] - a[1]).map(x => x[0]);
        instCache = null;
        if (!hits.length) { resEl.replaceChildren(UI.empty('search', 'Sem resultados', `Nada encontrado para "${inp.value.trim()}". Experimenta outro termo.`)); return; }
        /* capturas só nos primeiros 6 resultados: são ~15 nós cada e ninguém faz scroll até ao 20.º */
        const h = `<div class="as-rcount">${hits.length} ${hits.length === 1 ? 'resultado' : 'resultados'}</div>` + hits.slice(0, 24).map((id, i) => `<div class="as-res${i < 6 ? ' sh' : ''}">${rowH(id, { stars: true })}${i < 6 ? `<div class="as-mshots" data-go="app:${esc(id)}">${[0, 1, 2].map(k => shotH(id, k)).join('')}</div>` : ''}</div>`).join('');
        const t = document.createElement('template'); t.innerHTML = h; hydrate(t.content); resEl.replaceChildren(t.content); };
      /* ⚠️ trocar home/resultados TIRANDO do DOM, nunca com display:none: os ícones repetem os ids dos gradientes SVG e o Chrome
         resolve url(#id) no PRIMEIRO do documento - se esse estiver num ramo display:none o ícone dos resultados pinta-se BRANCO
         (apanhado com o Snake: estava nas "Sugestões" escondidas e aparecia vazio na lista de resultados).
         O que volta ao DOM é repintado (repaint): enquanto esteve fora nenhuma instalação/desinstalação lhe chegou. Compara-se o
         pai (parentNode === body) e não isConnected: com a vista guardada noutro separador os dois estão "desligados". */
      const show = q => { if (!q) { if (homeEl.parentNode !== body) { repaint(homeEl); body.replaceChildren(homeEl); } return; }
        if (q !== lastQ) { lastQ = q; results(q); } else if (resEl.parentNode !== body) repaint(resEl);
        if (resEl.parentNode !== body) body.replaceChildren(resEl); };
      /* a pesquisa espera 180 ms e só a ÚLTIMA tecla conta (seq): cada letra reconstruía o corpo inteiro na thread principal */
      inp.oninput = () => { const q = norm(inp.value.trim()); field.classList.toggle('has', !!q); clearTimeout(timer); const my = ++seq; timer = setTimeout(() => { if (my === seq) show(q); }, q ? 180 : 0); };
      v._search = t => { inp.value = t; field.classList.add('focus'); inp.oninput(); };
      field.querySelector('.as-clr').onclick = () => { inp.value = ''; inp.oninput(); inp.focus(); };
      field.querySelector('.as-cancel').onclick = () => { inp.value = ''; inp.oninput(); inp.blur(); field.classList.remove('focus'); };
      inp.onfocus = () => field.classList.add('focus'); inp.onblur = () => { if (!inp.value) field.classList.remove('focus'); };
      v.opts.onPop = () => { clearTimeout(timer); seq++; };
      /* saiu do separador a meio da espera (a pesquisa pendente foi cancelada no onPop): ao voltar corre com o texto que lá está */
      v._resume = () => { if (inp.value.trim() && norm(inp.value.trim()) !== lastQ) inp.oninput(); };
      return v; };

    /* ===================== NOVA STORE (Android) =====================
       Separadores em baixo (Descobrir · Apps · Jogos · Arcade · Menu), pesquisa em pílula no topo de cada separador, destaques em
       cartões grandes r26, linhas com o botão Instalar/Abrir em pílula, página da app com capturas, classificação e avaliações.
       Tudo o que instala, classifica e avalia é a lógica de cima (obter, rateFlow, apps.*). */
    const progH = id => `<i class="astore-prog" style="--d:${busy.has(id) ? -(Date.now() - busy.get(id)) : 0}ms"></i>`;
    const getHA = (id, cls = '') => { const s = stOf(id); return `<div class="astore-get nostop ${cls} is-${s}" data-id="${esc(id)}"><span>${labelOf(s)}</span>${s === 'loading' ? progH(id) : ''}</div>`; };
    const subA = id => isGame(id) ? genresOf(id).join(' · ') : catOf(id);
    const rateA = id => R(id).count ? `<em class="astore-st">${g('starFill', 12)}${rating(id)}</em>` : '';
    const rowA = (id, o = {}) => `<div class="astore-row${o.n != null ? ' num' : ''}" data-go="app:${esc(id)}">${o.n != null ? `<b class="astore-n">${o.n}</b>` : ''}${Icons.tileBox(id, 'astore-ic')}<div class="astore-rb"><b>${esc(App.name(id))}</b><span>${esc(o.sub || subA(id))}</span>${rateA(id)}</div>${getHA(id)}</div>`;
    const cardRowsA = (ids, numbered) => `<div class="astore-card">${ids.map((id, i) => rowA(id, { n: numbered ? i + 1 : null })).join('')}</div>`;
    const secA = (title, go, inner) => `<section class="astore-sec"><div class="astore-sh"><b>${esc(title)}</b>${go ? `<a data-go="${esc(go)}">${g('chevR', 20)}</a>` : ''}</div>${inner}</section>`;
    const artA = id => `<i class="astore-b1"></i><i class="astore-b2"></i><div class="astore-bigic">${Icons.tileBox(id, 'astore-bic')}</div><i class="astore-gl a">${g(colOf(id).icon, 22)}</i><i class="astore-gl b">${g(GLY[num(id, GLY.length)], 18)}</i>`;
    const featA = (id, eye) => { const t = titleOf(id), m = !!media(id);
      return `<div class="astore-feat" data-go="app:${esc(id)}"><div class="astore-fart${isGame(id) ? ' dark' : ''}" style="${pal(id)}">${m ? `<div class="astore-media" data-media="${esc(id)}"></div>` : artA(id)}<div class="astore-ftx"><em>${esc(eye)}</em><b>${esc(t[0])}</b></div></div><div class="astore-fbar">${Icons.tileBox(id, 'astore-ic')}<div class="astore-rb"><b>${esc(App.name(id))}</b><span>${esc(subA(id))}</span></div>${getHA(id)}</div></div>`; };
    const carA = (ids, eyes) => `<div class="astore-car">${ids.map((id, i) => featA(id, eyes[i % eyes.length])).join('')}</div>`;
    const tilesA = ids => `<div class="astore-tiles">${ids.map(id => `<div class="astore-tile" data-go="app:${esc(id)}">${Icons.tileBox(id, 'astore-tic')}<b>${esc(App.name(id))}</b><span>${R(id).count ? g('starFill', 11) + rating(id) : esc(isGame(id) ? genresOf(id)[0] : catOf(id))}</span></div>`).join('')}</div>`;
    const chipsA = (items, kind) => `<div class="astore-chips">${items.map(c => `<div class="astore-chip" data-go="${kind}:${esc(c)}">${g(kind === 'genre' ? (GENRE_IC[c] || 'gamepad') : (CAT[c] || CAT.Terceiros).icon, 18)}<span>${esc(c === 'Jogos' ? 'Top Jogos' : c)}</span></div>`).join('')}</div>`;
    const pillA = () => `<div class="astore-sp" data-go="search">${g('search', 20)}<span>Pesquisar apps e jogos</span></div>`;
    const viewA = (title, extra) => UI.view(Object.assign({ title, large: true, cls: 'astore-v' }, extra || {}));
    const emptyA = (t, s) => `<div class="astore-empty"><b>${esc(t)}</b><span>${esc(s)}</span></div>`;
    const discoverA = () => {
      const v = viewA('Descobrir'); add(v.content, pillA());
      const all = ordered(), apps = appsOnly(), gms = games();
      if (!all.length) { add(v.content, emptyA('Sem apps', 'Ainda não há apps opcionais nesta loja.')); return v; }
      add(v.content, carA(all.slice(0, 5), ['App do dia', 'Em destaque', 'Novidade', 'O que estamos a usar', 'Imprescindível']));
      later(v, slot => add(slot, secA('Escolhas para ti', 'list:fav', cardRowsA(rank(all).slice(0, 4)))
        + (gms.length ? secA('Jogos populares', 'list:top-games', tilesA(rank(gms))) : '')
        + secA('Top gratuitas', 'list:today-top', cardRowsA(rank(all).slice(0, 5), true))
        + (apps.length ? secA('Categorias', null, chipsA(catsIn(apps), 'cat')) : '')));
      return v; };
    const appsA = () => {
      const v = viewA('Apps'); add(v.content, pillA()); const ids = appsOnly();
      if (!ids.length) { add(v.content, emptyA('Sem apps', 'Ainda não há apps opcionais nesta loja.')); return v; }
      add(v.content, carA(ids.slice(0, 5), EYE_A));
      later(v, slot => add(slot, secA('Apps essenciais', 'list:ess-apps', cardRowsA(ids.slice(0, 6)))
        + secA('Top apps gratuitas', 'list:top-apps', cardRowsA(rank(ids).slice(0, 5), true))
        + secA('Categorias principais', null, chipsA(catsIn(ids).slice(0, 8), 'cat'))
        + secA('Novas e dignas de nota', 'list:new-apps', tilesA(ids.slice().reverse()))));
      return v; };
    const gamesA = () => {
      const v = viewA('Jogos'); add(v.content, pillA()); const ids = games();
      if (!ids.length) { add(v.content, emptyA('Ainda não há jogos', 'Os jogos registados por outros resources (RegisterApp com a categoria "Jogos") aparecem aqui.')); return v; }
      add(v.content, carA(ids.slice(0, 5), EYE_G));
      later(v, slot => add(slot, secA('Jogos a experimentar', 'list:ess-games', cardRowsA(ids.slice(0, 6)))
        + secA('Top jogos gratuitos', 'list:top-games', cardRowsA(rank(ids).slice(0, 5), true))
        + secA('Géneros', null, chipsA([...new Set(ids.flatMap(genresOf))], 'genre'))
        + secA('Os favoritos dos jogadores', null, tilesA(ids.slice().reverse()))));
      return v; };
    const arcadeA = () => {
      const v = viewA('Arcade'); const ids = games(); const nJogos = ids.filter(id => !(App.get(id) || {}).hub).length;
      add(v.content, `<div class="astore-arc"><div class="astore-arcic">${g('joystick', 30)}</div><b>Jogos sem anúncios nem compras integradas</b><p>${nJogos ? nJogos + (nJogos === 1 ? ' jogo incluído' : ' jogos incluídos') + ' na tua conta. Joga quando quiseres.' : 'Os jogos com a categoria "Jogos" aparecem aqui, sem anúncios nem compras integradas.'}</p><div class="astore-arcb" data-go="toast:Os jogos Arcade estão incluídos na tua conta">Jogar grátis</div><span>Incluído na tua conta, sem subscrição</span></div>`);
      if (ids.length) later(v, slot => add(slot, secA('Jogar agora', 'list:arcade', cardRowsA(ids.slice(0, 5)))
        + secA('Todos os jogos', null, `<div class="astore-agrid">${ids.map(id => `<div class="astore-ag" data-go="app:${esc(id)}"><div class="astore-agart" style="${pal(id)}">${Icons.tileBox(id, 'astore-tic')}</div><b>${esc(App.name(id))}</b><span>${esc(subA(id))}</span></div>`).join('')}</div>`)));
      return v; };
    /* Menu: a conta, as apps instaladas (com Abrir e Desinstalar) e as definições da loja; refaz-se a cada visita (fresh) */
    const menuA = () => {
      const v = viewA('Menu'); instCache = null; const acc = me(); const inst = catalog().filter(isInst);
      const head = UI.el(`<div class="astore-acc">${UI.avatar(acc, 'lg')}<div><b></b><span></span></div></div>`); head.querySelector('b').textContent = acc.username || acc.name || 'Eu'; head.querySelector('span').textContent = UI.phone(acc.phone || ''); v.content.appendChild(head);
      add(v.content, secA('As tuas apps', null, inst.length ? `<div class="astore-card">${inst.map(id => `<div class="astore-row" data-go="app:${esc(id)}">${Icons.tileBox(id, 'astore-ic')}<div class="astore-rb"><b>${esc(App.name(id))}</b><span>${esc(subA(id))}</span><a class="astore-un nostop" data-go="uninst:${esc(id)}">Desinstalar</a></div>${getHA(id)}</div>`).join('')}</div>` : emptyA('Sem apps opcionais instaladas', 'Instala apps nos separadores Descobrir, Apps e Jogos.')));
      v.content.appendChild(UI.el('<div class="astore-sec astore-sh"><b>Definições</b></div>'));
      v.content.appendChild(UI.list([{ items: [{ label: 'Notificações de apps novas', sub: 'Avisar quando chega uma app à loja', toggle: newAppsNotif(), onToggle: on => System.setState({ asNewAppsNotif: !!on }, { noApply: true }) }, { label: 'Compras', value: 'Todas as apps são gratuitas', chevron: false, cls: 'static' }, { label: 'Subscrições', value: 'Nenhuma', chevron: false, cls: 'static' }], footer: 'Os dados das apps ficam guardados no servidor quando as desinstalas.' }]));
      return v; };
    /* lista (Ver tudo, categorias, géneros) */
    function listViewA(title, ids, numbered) {
      instCache = null;
      const v = UI.view({ title, back: backLabel(), large: true, cls: 'astore-v', onPop: pageOnPop });
      if (!ids.length) add(v.content, emptyA('Sem apps', 'Ainda não há apps nesta lista.'));
      else add(v.content, cardRowsA(ids, numbered));
      pushPage(v);
    }
    /* pesquisa (página): sem acentos nem maiúsculas, espera 180 ms e só a última tecla conta (como no PearOS) */
    function searchViewA() {
      const v = UI.view({ title: 'Pesquisar', back: backLabel(), cls: 'astore-v astore-sv', onPop: pageOnPop });
      const field = UI.el(`<div class="astore-sf">${g('search', 20)}<input type="text" placeholder="Pesquisar apps e jogos" enterkeyhint="search"><div class="astore-sx hidden">${g('x', 16)}</div></div>`);
      const body = UI.el('<div class="astore-sbody"></div>'), inp = field.querySelector('input'), x = field.querySelector('.astore-sx');
      v.content.append(field, body);
      const ids = ordered();
      const home = () => { const terms = []; [...ids.slice(0, 3).map(id => App.name(id).toLowerCase()), 'jogos', 'redes sociais', 'faturas', 'carros', 'anónimo', 'comida'].forEach(t => { if (terms.length < 6 && !terms.includes(t) && ids.some(id => score(id, norm(t)) > 0)) terms.push(t); });
        body.innerHTML = ''; add(body, (terms.length ? secA('Pesquisas sugeridas', null, `<div class="astore-chips">${terms.map(t => `<div class="astore-chip" data-go="q:${esc(t)}">${g('search', 16)}<span>${esc(t)}</span></div>`).join('')}</div>`) : '')
          + (ids.length ? secA('Sugestões para ti', null, cardRowsA(rank(ids).slice(0, 5))) : emptyA('Sem apps', 'Ainda não há apps nesta loja.'))); };
      let timer = null, seq = 0;
      const run = () => { const q = norm(inp.value.trim()); x.classList.toggle('hidden', !q); if (!q) { home(); return; }
        const hits = ids.map(id => [id, score(id, q)]).filter(h => h[1] > 0).sort((a, b) => b[1] - a[1]).map(h => h[0]); instCache = null;
        body.innerHTML = '';
        if (!hits.length) { add(body, emptyA('Sem resultados', `Nada encontrado para "${inp.value.trim()}". Experimenta outro termo.`)); if (body.firstElementChild) UI.emptyFit(body.firstElementChild); return; }
        add(body, `<div class="astore-rcount">${hits.length} ${hits.length === 1 ? 'resultado' : 'resultados'}</div>` + `<div class="astore-shots sm" data-go="app:${esc(hits[0])}">${[0, 1, 2].map(k => shotA(hits[0], k)).join('')}</div>` + cardRowsA(hits.slice(0, 24))); };
      inp.oninput = () => { clearTimeout(timer); const my = ++seq; timer = setTimeout(() => { if (my === seq) run(); }, inp.value.trim() ? 180 : 0); };
      x.onclick = () => { inp.value = ''; inp.oninput(); inp.focus(); };
      v._search = t => { inp.value = t; inp.oninput(); };
      const prevPop = v.opts.onPop; v.opts.onPop = () => { clearTimeout(timer); seq++; if (prevPop) prevPop(); };
      home(); pushPage(v); setTimeout(() => inp.focus(), 420);
    }
    /* capturas: as reais (RegisterApp shots) ou desenhadas (fundo da app, frase e um ecrã com blocos) */
    const shotA = (id, k) => { const real = shotsOf(id);
      if (real.length) return `<div class="astore-shot real" data-shot="${esc(id)}|${k % real.length}"></div>`;
      const cap = k === 0 && TITLES[id] ? TITLES[id][0] : CAPS[k % CAPS.length];
      return `<div class="astore-shot k${k % 3}" style="${pal(id)}"><b>${esc(cap)}</b><div class="astore-scr"><div class="astore-sch">${k === 0 ? Icons.tileBox(id, 'astore-sic') : '<i class="c"></i>'}<i class="t"></i></div><i class="l w1"></i><i class="l w2"></i><i class="r"></i><i class="r"></i><i class="r"></i></div></div>`; };
    function detailA(id) {
      const d = App.get(id); if (!d) return; instCache = null;
      const v = UI.view({ title: '', back: backLabel(), cls: 'astore-v astore-dv', onPop: pageOnPop }); v.opts.backName = App.name(id);   /* App.name: o nome da Nova UI (Videochamada, Internet), nao o de origem */
      ambient(v, id, '', 'astore-amb');   /* luz suave da cor da app atrás do cabeçalho (oneui-apps3.css .astore-amb) */
      const t = titleOf(id), cat = catOf(id), ver = d.version ? String(d.version) : null, news = typeof d.news === 'string' ? d.news : null;
      add(v.content, `<div class="astore-dh">${Icons.tileBox(id, 'astore-dic')}<div class="astore-dht"><h1>${esc(App.name(id))}</h1><a data-go="toast:${esc(dev(id))}">${esc(dev(id))}</a><span>${esc(isGame(id) ? genresOf(id).join(' · ') : cat)}</span></div></div>`
        + `<div class="astore-strip"><div><b>${R(id).count ? rating(id) + ' ' + g('starFill', 14) : 'Novo'}</b><span>${R(id).count ? ratings(id) + ' avaliações' : 'Sem avaliações'}</span></div><div><b>${g(colOf(id).icon, 18)}</b><span>${esc(isGame(id) ? genresOf(id)[0] : cat)}</span></div><div><b>Grátis</b><span>Sem compras</span></div><div><b>${esc(langCode())}</b><span>${esc(langName())}</span></div></div>`
        + `<div class="astore-dget">${getHA(id, 'wide')}<div class="astore-shr" data-go="sharelink:${esc(id)}">${g('share', 20)}</div></div>`
        + `<div class="astore-shots">${[0, 1, 2, 3].map(k => shotA(id, k)).join('')}</div>`
        + `<section class="astore-dsec"><div class="astore-sh"><b>Acerca desta app</b></div><div class="astore-clamp"><p>${descH(id)}</p><a data-go="more">Mais</a></div></section>`
        + (ver || news ? `<section class="astore-dsec"><div class="astore-sh"><b>Novidades</b></div>${ver ? `<div class="astore-ver">Versão ${esc(ver)}</div>` : ''}${news ? `<div class="astore-clamp"><p>${esc(news)}</p><a data-go="more">Mais</a></div>` : ''}</section>` : ''));
      later(v, slot => {
        const also = catalog().filter(x => x !== id).sort((a, b) => (catOf(b) === cat) - (catOf(a) === cat)).slice(0, 8);
        const info = [['Programador', dev(id)], ['Categoria', cat], ['Compatibilidade', 'Funciona neste telemóvel'], ['Idioma', langName()], ['Preço', 'Grátis, sem compras integradas'], ['Copyright', '© 2026 ' + dev(id)]];
        add(slot, `<section class="astore-dsec astore-ratsec" data-app="${esc(id)}"><div class="astore-sh"><b>Classificações e avaliações</b></div><div class="astore-ratbody"><div class="astore-load"></div></div></section>`
          + `<section class="astore-dsec"><div class="astore-sh"><b>Informações</b></div><div class="astore-card astore-info">${info.map(r => `<div><span>${esc(r[0])}</span><b>${esc(r[1])}</b></div>`).join('')}</div></section>`
          + `<div class="astore-uninst astore-ifinst" data-id="${esc(id)}" data-go="uninst:${esc(id)}"${isInst(id) ? '' : ' hidden'}>${g('trash', 18)}<span>Desinstalar app</span></div>`
          + (also.length ? secA('Também poderás gostar', null, tilesA(also)) : ''));
        const ld = slot.querySelector('.astore-load'); if (ld) ld.appendChild(UI.spinner());
        paintRatingsA(slot.querySelector('.astore-ratsec'), id);
      });
      pushPage(v);
    }
    async function paintRatingsA(sec, id) {
      if (!sec) return; const body = sec.querySelector('.astore-ratbody'); if (!body) return;
      const r = await Bridge.rpc('apps.ratings', { app: id }); if (!body.isConnected) return;
      const ok = r && !r.error; const count = ok ? (r.count || 0) : 0, avg = ok ? (r.avg || 0) : 0; const dist = ok && Array.isArray(r.dist) ? r.dist : [0, 0, 0, 0, 0];
      if (ok) RAT[id] = { avg, count };
      const mine = ok && r.mine ? r.mine : null; const revs = ok && Array.isArray(r.reviews) ? r.reviews : [];
      const bars = [5, 4, 3, 2, 1].map(s => `<div><span>${s}</span><s><u style="transform:scaleX(${count ? ((dist[s - 1] || 0) / count).toFixed(3) : 0})"></u></s></div>`).join('');
      const when = ts => ts ? UI.fmtDate(new Date(ts), true) : '';
      const stars = n => `<i class="astore-sts">${[1, 2, 3, 4, 5].map(k => `<i class="${k <= n ? 'on' : ''}">${g('starFill', 13)}</i>`).join('')}</i>`;
      if (!ok) { body.innerHTML = emptyA('Sem ligação', 'Não foi possível ler as avaliações.'); return; }
      body.innerHTML = (count ? `<div class="astore-rat"><div class="astore-ratbig"><b>${avg.toFixed(1).replace('.', ',')}</b>${stars(Math.round(avg))}<span>${count} classificaç${count === 1 ? 'ão' : 'ões'}</span></div><div class="astore-bars">${bars}</div></div>` : emptyA('Ainda sem avaliações', 'Sê o primeiro a classificar esta app.'))
        + `<div class="astore-tap"><span>${mine ? 'A tua classificação' : 'Toca para classificar'}</span><div>${[1, 2, 3, 4, 5].map(n => `<i data-go="rate:${n}"${mine && n <= mine.stars ? ' class="on"' : ''}>${g('starFill', 26)}</i>`).join('')}</div></div>`
        + (mine ? `<div class="astore-myrev"><a data-go="review:${esc(id)}">${mine.text || mine.title ? 'Editar a tua avaliação' : 'Escrever uma avaliação'}</a><a data-go="unrate:${esc(id)}">Remover</a></div>` : '')
        + (revs.length ? `<div class="astore-revs">${revs.map(x => `<div class="astore-rev"><div class="astore-revh">${UI.avatar({ name: x.username || 'jogador' }, 'sm')}<div><b>${esc(x.username || 'jogador')}</b><span>${stars(x.stars)}${esc(when(x.created))}</span></div></div>${x.title ? `<b class="astore-revt">${esc(x.title)}</b>` : ''}${x.text ? `<p>${esc(x.text)}</p>` : ''}</div>`).join('')}</div>` : '');
    }

    const TABS = A ? [
      { icon: 'sparkles', label: 'Descobrir', build: discoverA }, { icon: 'grid', label: 'Apps', build: appsA }, { icon: 'gamepad', label: 'Jogos', build: gamesA },
      { icon: 'joystick', label: 'Arcade', build: arcadeA }, { icon: 'personCircle', label: 'Menu', build: menuA, fresh: true },
    ] : [
      { icon: 'today', label: 'Hoje', build: today }, { icon: 'rocket', label: 'Jogos', build: gamesView }, { icon: 'tabs', label: 'Apps', build: appsView },
      { icon: 'joystick', label: 'Arcade', build: arcadeView }, { icon: 'search', label: 'Pesquisar', build: searchView, search: true },
    ];
    /* separador guardado: construído na 1.ª visita; voltar a ele devolve a MESMA vista (e a posição do scroll, como no PearOS).
       · a posição guarda-se quando a vista sai (onPop) E quando é reposta ainda ligada: o setRoot NÃO chama o onPop da vista que
         repõe (tocar no separador ativo com uma página aberta) e ficava a posição de uma visita antiga. Lê-se o scrollTop e não um
         ouvinte de scroll: o evento só chega no frame seguinte e um toque logo a seguir ao scroll guardava a posição anterior.
       · content-visibility: a altura "auto" lembrada perde-se quando a vista sai do DOM (medido: as secções voltam com a estimativa)
         e o restauro do scroll caía ao lado. Antes de sair fixa-se a altura real de cada bloco (pin), só se houver scroll a repor.
       · a barra volta sem 'solid'/'show-title': a vista regressa com scrollTop 0 e, com as classes antigas, o avatar pequeno contava
         como botão visível no markBare do setRoot (--lg-btnw 68 px) e empurrava o avatar do título 48 px para a esquerda.
       · uma construção nova é sempre do catálogo atual: o refresh adiado (_dirty) deixa de ser preciso. */
    const leaving = v => { v._y = v.content.scrollTop; if (v._y > 0) pin(v); };
    const tabView = i => { let v = cache[i];
      /* separador marcado resh (o Menu da NOVA Store, com a lista das apps instaladas) refaz-se a cada visita */
      if (v && TABS[i].fresh) { v._dead = true; v = cache[i] = null; }
      if (!v) { instCache = null; win._dirty = false; v = cache[i] = TABS[i].build();
        const prev = v.opts.onPop; v.opts.onPop = () => { leaving(v); if (prev) prev(); }; }
      else {
        if (v.isConnected) leaving(v);   /* ainda na pilha, por baixo de uma página (toque no separador ativo) */
        v.navbar.classList.remove('solid', 'show-title');
        if (busy.size) repaint(v);   /* anéis a meio: acertar o atraso antes de as animações recomeçarem */
        /* microtarefa e não rAF: corre logo a seguir ao setRoot (que é síncrono no toque do separador), antes do 1.º frame; o rAF
           podia nem chegar (janela sem pintar) e a vista ficava no topo com o _y guardado */
        if (v._y > 0) { const y = v._y; Promise.resolve().then(() => { if (v.isConnected) v.content.scrollTop = y; }); }
        if (v._resume) v._resume(); }
      return v; };
    const PADS = {};
    const pin = v => v.content.querySelectorAll('.as-sec,.as-lcard,.as-res').forEach(e => { const h = e.offsetHeight; if (!h) return;
      const k = e.classList[0]; if (PADS[k] == null) { const cs = getComputedStyle(e); PADS[k] = parseFloat(cs.paddingTop) + parseFloat(cs.paddingBottom) || 0; }
      e.style.containIntrinsicSize = 'auto ' + Math.max(0, Math.round(h - PADS[k])) + 'px'; });
    const invalidate = () => { cache.forEach(v => { if (v) v._dead = true; }); cache.length = 0; palC.clear(); instCache = null; };

    /* ---------- listas (Ver tudo, categorias) ---------- */
    const LISTS = {
      'fav': ['Os nossos favoritos', () => ordered()], 'today-top': ['Top gratuitas', () => rank(catalog()), true],
      'top-apps': ['Top apps gratuitas', () => rank(appsOnly()), true], 'top-games': ['Top jogos gratuitos', () => rank(games()), true],
      'ess-apps': ['Apps essenciais', appsOnly], 'ess-games': ['Jogos a experimentar', games], 'new-apps': ['Novas e dignas de nota', () => appsOnly().reverse()], 'arcade': ['Jogos Arcade', games],
    };
    /* o "voltar" da página seguinte tem o nome da vista de onde se veio (PearOS), não "AppShop" fixo */
    /* vista do topo SEM a que está a sair: o pop() deixa-a na pilha 420 ms com .leave, e abrir outra página nesse intervalo punha
       no "voltar" o nome da página que acabou de fechar */
    const topView = () => { const s = win.querySelector('.nav-stack'); if (!s) return null; for (let x = s.lastElementChild; x; x = x.previousElementSibling) if (!x.classList.contains('leave')) return x; return null; };
    const backLabel = () => { const top = topView(); return (top && top.opts && (top.opts.backName || top.opts.title)) || App.name('appstore'); };
    /* abrir uma página durante esses 420 ms: o push() do ui.js toma a vista que está a SAIR por "vista de baixo" e é a ela que põe o
       .behind 2 frames depois - a página que saía saltava para -30% (escurecida) por baixo da nova e a raiz ficava sem o recuo.
       O app-store.css segura a que sai a ir para a direita; aqui passa-se o .behind para a vista certa, no mesmo frame (este duplo
       rAF é pedido depois do do push, por isso corre a seguir a ele). Sem vistas a sair não faz nada. */
    const pushPage = v => { const s = win.querySelector('.nav-stack'), under = topView(), out = s ? [...s.children].filter(x => x.classList.contains('leave')) : [];
      UI.push(win, v);
      if (out.length && under) requestAnimationFrame(() => requestAnimationFrame(() => { out.forEach(x => x.classList.remove('behind'));
        if (under.parentNode === s && v.parentNode === s && !under.classList.contains('leave')) under.classList.add('behind'); })); };
    /* ao fechar uma página: se o catálogo mudou enquanto ela estava aberta (_dirty), a raiz que fica à vista é uma vista deitada
       fora - refaz-se o separador depois da animação de saída (420 ms), só se já não houver outra página por cima */
    const pageOnPop = () => { if (win._dirty) setTimeout(() => { if (win._dirty && UI.depth(win) <= 1 && System.currentApp() === 'appstore') refreshNow(); }, 450); };
    /* refaz o separador atual com o catálogo novo. Na Pesquisa o texto escrito passa para a vista nova: um resource que parava ou
       arrancava (registerApp/unregisterApp) com resultados à vista apagava o campo e os resultados */
    const refreshNow = () => { const r = win.querySelector('.nav-stack > .view'), inp = r && r._search ? r.querySelector('.as-sf input') : null, q = inp ? inp.value : '';
      win._dirty = false; tabs.refresh();
      if (q.trim()) { const nv = win.querySelector('.nav-stack > .view'); if (nv && nv !== r && nv._search) nv._search(q); } };
    function listView(title, ids, numbered) {
      if (A) return listViewA(title, ids, numbered);
      instCache = null;
      const v = UI.view({ title, back: backLabel(), large: true, cls: 'as-v', onPop: pageOnPop });
      if (!ids.length) v.content.appendChild(UI.empty('grid', 'Sem apps', 'Ainda não há apps nesta lista.'));
      else add(v.content, `<div class="as-plist big">${ids.map((id, i) => rowH(id, { n: numbered ? i + 1 : null, stars: true })).join('')}</div>`);
      pushPage(v);
    }

    /* ---------- página de uma app ---------- */
    function detail(id) {
      if (A) return detailA(id);
      const d = App.get(id); if (!d) return; instCache = null;
      const v = UI.view({ title: '', back: backLabel(), cls: 'as-v as-dv', onPop: pageOnPop }); v.opts.backName = d.name;
      /* depois de passar o cabeçalho a barra mostra o ícone pequeno e o OBTER (PearOS); a classe só muda quando cruza o limite */
      v.querySelector('.nb-title').innerHTML = tileH(id);
      /* partilhar: círculo de vidro na barra, ao lado do voltar (iOS 26/27); data-ic/data-lb levam-no para a barra direita do PearPhone Fold */
      add(v.querySelector('.nb-right'), getH(id, 'fill nav') + `<div class="nb-btn lg nb-ico as-nshare" data-ic="share" data-lb="Partilhar" data-go="sharelink:${esc(id)}">${g('share')}</div>`);
      ambient(v, id, 'big');
      let navOn = false; v.content.addEventListener('scroll', () => { const on = v.content.scrollTop > 150; if (on !== navOn) { navOn = on; v.classList.toggle('as-dnav', on); } }, { passive: true });
      const t = titleOf(id), cat = catOf(id), rn = rateN(id);
      /* faixa de informação: só o que é verdade - classificação dos jogadores, programador, categoria, idioma da app.
         "Idade 12+", "Tabela N.º x" e "Tamanho x MB" eram sorteios pelo nome da app */
      const strip = [
        [R(id).count ? ratings(id) + ' avaliações' : 'Avaliações', rating(id), `<span class="as-stars sm${R(id).count ? '' : ' none'}"><i><b style="width:${Math.round(rn / 5 * 100)}%">★★★★★</b>★★★★★</i></span>`],
        ['Programador', g('personCircle'), `<span>${esc(dev(id))}</span>`], ['Categoria', g(colOf(id).icon), `<span>${esc(isGame(id) ? genresOf(id)[0] : cat)}</span>`], ['Idioma', esc(langCode()), `<span>${esc(langName())}</span>`],
      ];
      const ver = d.version ? String(d.version) : null, news = typeof d.news === 'string' ? d.news : null;
      add(v.content, `<div class="as-dhead">${tileW(id)}<div class="as-dhb"><h1>${esc(d.name)}</h1><span>${esc(sub(id))}</span><div class="as-dact">${bcH(id, 'fill')}</div></div></div>`
        + `<div class="as-infow"><div class="as-info">${strip.map(c => `<div><em>${esc(c[0])}</em><b>${c[1]}</b>${c[2]}</div>`).join('')}</div></div>`
        + (ver || news ? `<section class="as-dsec">${shH('Novidades')}${ver ? `<div class="as-ver"><span>Versão ${esc(ver)}</span></div>` : ''}${news ? `<div class="as-clamp"><p>${esc(news)}</p><a data-go="more">mais</a></div>` : ''}</section>` : '')
        + `<section class="as-dsec">${shH('Pré-visualização')}<div class="as-shots">${[0, 1, 2, 3].map(k => shotH(id, k)).join('')}</div><div class="as-dev">${g('phone')}<span>PearPhone</span></div></section>`);
      /* o resto (avaliações, informações, sugestões) fica abaixo da dobra: entra depois, para a página deslizar logo */
      later(v, slot => {
        const also = catalog().filter(x => x !== id).sort((a, b) => (catOf(b) === cat) - (catOf(a) === cat)).slice(0, 8);
        const info = [['Fornecedor', dev(id)], ['Categoria', cat], ['Compatibilidade', 'Funciona neste PearPhone'], ['Idioma', langName()], ['Preço', 'Grátis, sem compras integradas'], ['Copyright', '© 2026 ' + dev(id)]];
        add(slot, `<section class="as-dsec"><div class="as-clamp"><p>${descH(id)}</p><a data-go="more">mais</a></div><div class="as-devrow" data-go="toast:${esc(dev(id))}"><div><b>${esc(dev(id))}</b><span>Programador</span></div>${g('chevR')}</div></section>`
          + `<section class="as-dsec as-ratsec" data-app="${esc(id)}">${shH('Classificações e avaliações')}<div class="as-ratbody">${UI.spinner().outerHTML}</div></section>`
          + `<section class="as-dsec">${shH('Informações')}<div class="as-infol">${info.map(r => `<div><span>${esc(r[0])}</span><b>${esc(r[1])}</b></div>`).join('')}</div></section>`
          + `<div class="as-uninst as-ifinst" data-id="${esc(id)}" data-go="uninst:${esc(id)}"${isInst(id) ? '' : ' hidden'}>${g('trash')}<span>Desinstalar app</span></div>`
          + (also.length ? `<section class="as-dsec">${shH('Também poderás gostar')}${bigH(also)}</section>` : ''));
        paintRatings(slot.querySelector('.as-ratsec'), id);
      });
      pushPage(v);
    }
    /* ---------- classificações a sério (apps.ratings): média, barras por estrela, críticas dos jogadores, a minha ---------- */
    async function paintRatings(sec, id) {
      if (A) return paintRatingsA(sec, id);
      if (!sec) return; const body = sec.querySelector('.as-ratbody'); if (!body) return;
      const r = await Bridge.rpc('apps.ratings', { app: id }); if (!body.isConnected) return;
      const ok = r && !r.error; const count = ok ? (r.count || 0) : 0, avg = ok ? (r.avg || 0) : 0; const dist = ok && Array.isArray(r.dist) ? r.dist : [0, 0, 0, 0, 0];
      if (ok) RAT[id] = { avg, count };
      const mine = ok && r.mine ? r.mine : null; const revs = ok && Array.isArray(r.reviews) ? r.reviews : [];
      /* dist vem [n1,n2,n3,n4,n5] (índice = estrelas−1); as barras mostram de 5 para 1 */
      const bars = [5, 4, 3, 2, 1].map(s => `<div><i>${'★'.repeat(s)}</i><s><u style="width:${count ? Math.round((dist[s - 1] || 0) / count * 100) : 0}%"></u></s></div>`).join('');
      const when = ts => ts ? UI.fmtDate(new Date(ts), true) : '';
      body.innerHTML = (count ? `<div class="as-rat"><div class="as-ratbig"><b>${avg.toFixed(1).replace('.', ',')}</b><span>de 5</span></div><div class="as-bars">${bars}<em>${count} classificaç${count === 1 ? 'ão' : 'ões'}</em></div></div>` : `<div class="as-norat">${g('star', 22)}<b>Ainda sem avaliações</b><span>Sê o primeiro a classificar esta app.</span></div>`)
        + (revs.length ? `<div class="as-revs">${revs.map(x => `<div class="as-rev"><div class="as-revh"><b>${esc(x.title || 'Sem título')}</b><span>${when(x.created)}</span></div><div class="as-revs2"><i>${'★'.repeat(x.stars)}<s>${'★'.repeat(5 - x.stars)}</s></i><span>${esc(x.username || 'jogador')}</span></div>${x.text ? `<p>${esc(x.text)}</p>` : ''}</div>`).join('')}</div>` : '')
        + `<div class="as-tap"><span>${mine ? 'A tua classificação:' : 'Toca para classificar:'}</span><div>${[1, 2, 3, 4, 5].map(n => `<i data-go="rate:${n}"${mine && n <= mine.stars ? ' class="on"' : ''}>${g('star')}</i>`).join('')}</div></div>`
        + (mine ? `<div class="as-myrev"><a data-go="review:${esc(id)}">${mine.text || mine.title ? 'Editar a tua avaliação' : 'Escrever uma avaliação'}</a><a data-go="unrate:${esc(id)}">Remover</a></div>` : '');
      if (!ok) body.innerHTML = `<div class="as-norat">${g('star', 22)}<b>Sem ligação</b><span>Não foi possível ler as avaliações.</span></div>`;
    }
    /* classificar (estrelas) e, opcionalmente, escrever: título + texto numa folha; grava pelo apps.rate e repinta a secção */
    async function rateFlow(sec, id, stars, withText) {
      const body = sec && sec.querySelector('.as-ratbody, .astore-ratbody');
      let title = '', text = '';
      const cur = await Bridge.rpc('apps.ratings', { app: id }); const mine = cur && cur.mine ? cur.mine : null;
      if (withText) {
        const f = A ? UI.el(`<div class="astore-revform"><div class="astore-tap big"><div>${[1, 2, 3, 4, 5].map(n => `<i${n <= stars ? ' class="on"' : ''}>${g('starFill', 30)}</i>`).join('')}</div></div><input type="text" class="rt astore-in" placeholder="Título (opcional)" maxlength="60" value="${esc(mine && mine.title || '')}"><textarea class="rx astore-in" placeholder="O que achas desta app? (opcional)" maxlength="300" rows="4">${esc(mine && mine.text || '')}</textarea></div>`)
          : UI.el(`<div class="as-revform"><div class="group"><div class="li static"><input type="text" class="rt" placeholder="Título (opcional)" maxlength="60" value="${esc(mine && mine.title || '')}"></div><div class="li static"><textarea class="rx" placeholder="O que achas desta app? (opcional)" maxlength="300" rows="4">${esc(mine && mine.text || '')}</textarea></div></div><div class="as-tap"><span>Classificação</span><div>${[1, 2, 3, 4, 5].map(n => `<i${n <= stars ? ' class="on"' : ''}>${g('star')}</i>`).join('')}</div></div></div>`);
        f.querySelectorAll(A ? '.astore-tap i' : '.as-tap i').forEach((el, i) => el.onclick = () => { stars = i + 1; f.querySelectorAll(A ? '.astore-tap i' : '.as-tap i').forEach((x, j) => x.classList.toggle('on', j < stars)); Sound.play('click'); });
        /* onClose corre em todos os fechos (também logo a seguir ao onDone): a flag diz se foi "Publicar" */
        const done = await new Promise(res => { let ok = false; UI.sheet({ title: 'Avaliar ' + App.name(id), left: 'Cancelar', right: 'Publicar', body: f, onDone: () => { title = f.querySelector('.rt').value.trim(); text = f.querySelector('.rx').value.trim(); ok = true; }, onClose: () => res(ok) }); });
        if (!done) return;
      } else if (mine) { title = mine.title || ''; text = mine.text || ''; }
      const r = await Bridge.rpcRaw('apps.rate', { app: id, stars, title, text });
      if (!r || !r.ok) { Sound.play('error'); UI.toast('Não foi possível classificar'); return; }
      RAT[id] = { avg: r.avg || stars, count: r.count || 1 }; Sound.play('success'); UI.toast(withText ? 'Avaliação publicada' : 'Obrigado pela classificação');
      if (body) paintRatings(sec, id);
      /* as estrelas das listas guardadas ficam desatualizadas: reconstroem-se na próxima passagem */
      invalidate();
    }
    /* ---------- conta (avatar): apps instaladas, compras, subscrições ---------- */
    function account() {
      const acc = me(); instCache = null; const inst = catalog().filter(isInst); const body = UI.el('<div></div>');
      body.appendChild(UI.el(`<div class="as-acc">${UI.avatar(acc, 'lg')}<b>${esc(acc.username || acc.name || 'Eu')}</b><span>${esc(UI.phone(acc.phone || ''))}</span></div>`));
      const sh = UI.sheet({ title: 'Conta', right: 'OK', body });
      /* remover daqui já não reconstrói o separador: o apps:changed pinta só os botões dessa app */
      body.appendChild(UI.list([{ header: 'Apps instaladas', items: inst.length ? inst.map(id => ({ icon: Icons.tile(id), tile: true, iconBg: 'transparent', label: App.name(id), sub: catOf(id), value: 'Remover', chevron: false, onTap: async () => { if (await UI.confirm('Desinstalar ' + App.name(id), 'Os dados da app são mantidos no servidor.', 'Desinstalar', true)) { await System.uninstall(id); sh.close(); } } })) : [{ label: 'Sem apps opcionais instaladas', chevron: false }] },
        { items: [{ icon: 'card', iconBg: 'var(--green)', label: 'Compras', value: inst.length + ' apps', onTap: () => UI.toast('Todas as apps são gratuitas') }, { icon: 'update', iconBg: 'var(--blue)', label: 'Subscrições', value: 'Nenhuma', onTap: () => UI.toast('Sem subscrições ativas') }, { icon: 'bell', iconBg: 'var(--red)', label: 'Notificações de apps novas', toggle: newAppsNotif(), onToggle: on => System.setState({ asNewAppsNotif: !!on }, { noApply: true }) }] }]));
    }
    /* "Notificações de apps novas" (Conta): era um interruptor decorativo, fixo em ligado. Agora fica gravado no estado e, ligado,
       uma app que entra no catálogo com a loja aberta em segundo plano gera uma notificação da AppShop. `seen` evita repetir a
       mesma app (um resource que reinicia volta a registar-se). */
    const newAppsNotif = () => System.state.asNewAppsNotif !== false;
    const seen = new Set(catalog());

    /* ---------- cliques por delegação ---------- */
    /* OBTER/ABRIR em fase de CAPTURA: o toque no botão nunca chega à linha/cartão por baixo (que abriria a página da app) */
    win.addEventListener('click', e => { const b = e.target && e.target.closest ? e.target.closest('.' + GET) : null; if (!b || !win.contains(b)) return; e.stopPropagation(); obter(b); }, true);
    win.addEventListener('click', e => {
      const t = e.target && e.target.closest ? e.target.closest('[data-go]') : null; if (!t || !win.contains(t)) return;
      /* só a vista do topo navega: a página nova só tapa a de baixo 2 frames depois (rAF do push) e um 2.º clique nesse intervalo
         empilhava outra página igual (e construía-a outra vez). A vista que está a sair (.leave) não conta como topo. */
      const tv = t.closest('.view'); if (tv && tv.parentElement && tv.parentElement.classList.contains('nav-stack') && tv !== topView()) return;
      const s = t.dataset.go, i = s.indexOf(':'), k = i < 0 ? s : s.slice(0, i), a = i < 0 ? '' : s.slice(i + 1);
      if (k === 'app') detail(a);
      else if (k === 'cat') listView(a === 'Jogos' ? 'Top Jogos' : a, catIds(a), true);
      else if (k === 'list') { const L = LISTS[a]; if (L) listView(L[0], L[1](), !!L[2]); }
      else if (k === 'genre') listView(a, genreIds(a), true);
      else if (k === 'q') { const sv = t.closest('.view'); if (sv && sv._search) sv._search(a); }
      else if (k === 'more') { const c = t.closest('.as-clamp, .astore-clamp'); if (c) c.classList.add('open'); }
      else if (k === 'search') searchViewA();
      else if (k === 'acct') account();
      else if (k === 'sharelink') shareApp(a);
      else if (k === 'toast') UI.toast(a);
      else if (k === 'uninst') uninstall(a);
      else if (k === 'rate') { const sec = t.closest('.as-ratsec, .astore-ratsec'); const n = +a; t.parentElement.querySelectorAll('i').forEach((x, j) => x.classList.toggle('on', j < n)); Sound.play('click'); if (sec) rateFlow(sec, sec.dataset.app, n, false); }
      else if (k === 'review') { const sec = t.closest('.as-ratsec, .astore-ratsec'); const on = sec ? sec.querySelectorAll('.as-tap i.on, .astore-tap i.on').length : 0; rateFlow(sec, a, on || 5, true); }
      else if (k === 'unrate') { const sec = t.closest('.as-ratsec, .astore-ratsec'); Bridge.rpc('apps.unrate', { app: a }).then(() => { delete RAT[a]; UI.toast('Classificação removida'); if (sec) (A ? paintRatingsA : paintRatings)(sec, a); invalidate(); }); }
    });
    /* partilhar uma app = recomendá-la por mensagem a um contacto (o "Ligação copiada" de antes não copiava nada) */
    async function shareApp(id) { const c = await Contacts.pick('Partilhar ' + App.name(id) + ' com'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: A ? `📱 Vê a app «${App.name(id)}» na ${App.name('appstore')}: ${sub(id)}.` : `📱 Vê a app «${App.name(id)}» na AppShop: ${sub(id)}.` }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('Enviado a ' + (c.name || c.number)); }

    tabs = UI.tabbar(win, TABS.map((t, i) => ({ icon: t.icon, label: t.label, search: t.search, view: () => tabView(i) })), 0);
    win._tabs = tabs; win._syncInst = onApps; win._invalidate = invalidate; win._refresh = refreshNow; win._openDetail = detail;
    /* classificações dos jogadores: chegam depois do primeiro pintar (a loja abre já); se algo mudou, o separador atual refaz-se */
    let ratSig = JSON.stringify(RAT);
    loadRatings().then(() => { const s = JSON.stringify(RAT); if (s === ratSig) return; ratSig = s; invalidate(); if (System.currentApp() === 'appstore' && UI.depth(win) <= 1) refreshNow(); else win._dirty = true; });
    /* catálogo mudou (app nova registada, ou removida por unregisterApp - ver onApps): deita fora os separadores guardados e
       reconstrói o atual, agrupado (250 ms) e só na raiz (nunca por cima de uma página de detalhe); se a loja não estiver à frente
       fica marcada e atualiza-se no resume, ou ao fechar a página (pageOnPop), ou na próxima troca de separador (tabView) */
    let refT = null;
    function refreshCatalog() { clearTimeout(refT); refT = setTimeout(() => { catSig = catalog().join('|'); invalidate(); if (System.currentApp() === 'appstore' && UI.depth(win) <= 1) refreshNow(); else win._dirty = true; }, 250); }
    const offDef = Bridge.on('app:defined', id => { catSig = catalog().join('|'); refreshCatalog();
      if (id && !seen.has(id) && catalog().includes(id)) { seen.add(id);
        if (newAppsNotif() && System.currentApp() !== 'appstore' && window.Notify) Notify.push({ app: 'appstore', title: 'Nova na ' + App.name('appstore'), msg: App.name(id), onTap: () => System.openApp('appstore') }); } });
    const offApps = Bridge.on('apps:changed', onApps);
    win.onClose = () => { clearTimeout(refT); offDef(); offApps(); busy.clear(); };
  },
  resume(win) {
    if (win._syncInst) win._syncInst();   /* instalada/removida noutro sítio enquanto a loja estava escondida */
    if (win._dirty && win._tabs && UI.depth(win) <= 1) { if (win._refresh) win._refresh(); else { win._dirty = false; win._tabs.refresh(); } }
  }
});
/* deep link phone://appstore/app/<id> (Lua: Push('openURL', …) ou System.openURL): abre a página dessa app */
if (window.System && typeof System.route === 'function') System.route('appstore', d => { const w = System.windows && System.windows.appstore; if (w && w._openDetail && d && d.parts && d.parts[0] === 'app' && d.parts[1]) w._openDetail(d.parts[1]); });
