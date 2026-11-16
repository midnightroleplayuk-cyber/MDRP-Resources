/* ===================== DICAS =====================
   A app Dicas do PearOS adaptada ao telemóvel: coleções com quatro a seis dicas cada, uma ilustração em SVG por dica
   (formas simples e um ou dois glifos do Icons.P, desenhadas em código) e um botão "Experimentar" que abre o ecrã
   certo (System.openApp, CC.open, Home.spotlight, LockGallery.open, Drawer.open, QuickPanel.open, EdgePanel.open),
   sempre em try/catch. No Android as dicas falam da gaveta, do painel rápido e do Edge panel; no PearOS do Centro de
   controlo e do Liquid Glass. Sem servidor: as dicas lidas ficam no Store ('tipsRead'). "Dica do dia" na raiz e um
   widget 2×2 com a mesma dica. Texto curto em PT (vai ser traduzido para 14 línguas). */
(() => {
  const g = UI.g;
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf) ? L.tf(s, ...v) : String(s).replace(/%s/g, () => String(v.shift()));
  const isA = () => !!(System.isAndroid && System.isAndroid());
  const OS = () => (isA() ? 'android' : 'ios');

  /* ---------- coleções ---------- */
  const COLS = [
    { id: 'start', label: 'Primeiros passos', icon: 'sparkles', c1: '#3E8BFF', c2: '#6D5CFF' },
    { id: 'lock', label: 'Ecrã bloqueado e personalização', icon: 'lock', c1: '#9B5CF2', c2: '#F2457A' },
    { id: 'cc', label: 'Centro de controlo', icon: 'sliders', c1: '#5B6B80', c2: '#2F7CF6', os: 'ios' },
    { id: 'glass', label: 'Liquid Glass', icon: 'layers', c1: '#2BB6D9', c2: '#1E5BFF', os: 'ios' },
    { id: 'camera', label: 'Câmara e fotos', icon: 'camera', c1: '#FF8A1F', c2: '#FFC400' },
    { id: 'msg', label: 'Mensagens e chamadas', icon: 'message', c1: '#2DBE60', c2: '#1FC7B4' },
    { id: 'social', label: 'Redes sociais', icon: 'heart', c1: '#F5476E', c2: '#FF8A1F' },
    { id: 'wallet', label: 'Carteira e faturas', icon: 'card', c1: '#1E9E53', c2: '#0B6E4F' },
    { id: 'games', label: 'Jogos', icon: 'gamepad', c1: '#F2453D', c2: '#9B5CF2' },
    { id: 'work', label: 'Apps de trabalho', icon: 'briefcase', c1: '#4A5A75', c2: '#2F3F5C' },
    { id: 'android', label: 'Android', icon: 'grid', c1: '#11A9C0', c2: '#2DBE60', os: 'android' },
  ];
  /* ---------- as dicas (os: só nesse sistema; act: o que o Experimentar faz; art: a ilustração) ---------- */
  const TIPS = [
    { c: 'start', id: 'open', title: 'Abre e fecha apps', body: 'Toca num ícone para abrir a app. Desliza de baixo para cima para voltar ao ecrã principal.', art: 'home', os: 'ios' },
    { c: 'start', id: 'open_a', title: 'Abre e fecha apps', body: 'Toca num ícone para abrir a app. Desliza de baixo para cima, ou toca no botão do meio, para voltar ao ecrã principal.', art: 'home', os: 'android' },
    { c: 'start', id: 'search', title: 'Procura em todo o lado', body: 'Desliza para baixo no ecrã principal para abrir a pesquisa. Encontra apps, contactos e mensagens.', art: 'search', act: 'spotlight', os: 'ios' },
    { c: 'start', id: 'search_a', title: 'Procura em todo o lado', body: 'Desliza para cima no ecrã principal para abrir a gaveta. A pesquisa está no topo.', art: 'search', act: 'drawer', os: 'android' },
    { c: 'start', id: 'switch', title: 'Troca de app depressa', body: 'Arrasta a barra em baixo para o lado para saltar entre as apps abertas. Mantém para veres todas.', art: 'switcher', act: 'switcher', os: 'ios' },
    { c: 'start', id: 'switch_a', title: 'Troca de app depressa', body: 'Toca no botão dos recentes, ou desliza para cima e segura, para veres as apps abertas.', art: 'switcher', act: 'recents', os: 'android' },
    { c: 'start', id: 'store', title: 'Instala apps novas', body: 'A AppShop tem redes sociais, jogos e ferramentas. Toca em Obter e o ícone aparece no ecrã principal.', art: 'store', act: 'app:appstore', os: 'ios' },
    { c: 'start', id: 'store_a', title: 'Instala apps novas', body: 'A NOVA Store tem redes sociais, jogos e ferramentas. Toca em Instalar e o ícone aparece na gaveta.', art: 'store', act: 'app:appstore', os: 'android' },
    { c: 'start', id: 'vera', title: 'Fala com a Vera', body: 'Mantém o botão lateral e pede uma chamada, um lembrete ou o tempo. Também podes escrever.', art: 'vera', act: 'vera' },
    { c: 'start', id: 'notif', title: 'Não percas nada', body: 'As notificações ficam no centro de notificações. Desliza do topo para as veres todas e limpa-as com um toque.', art: 'notif', act: 'nc' },
    { c: 'lock', id: 'wall', title: 'Muda o fundo', body: 'Mantém o dedo no ecrã bloqueado para abrires a galeria. Escolhe um fundo, a cor da hora e os widgets.', art: 'wallpaper', act: 'lockgallery', os: 'ios' },
    { c: 'lock', id: 'wall_a', title: 'Muda o fundo', body: 'Mantém o dedo numa zona vazia do ecrã principal para mudares o fundo, os widgets e a grelha.', art: 'wallpaper', act: 'homeedit', os: 'android' },
    { c: 'lock', id: 'widgets', title: 'Widgets no ecrã principal', body: 'Mantém o dedo num ícone e escolhe Editar ecrã principal. Toca no mais para juntares um widget.', art: 'widgets', act: 'homeedit' },
    { c: 'lock', id: 'folders', title: 'Pastas e arrumação', body: 'Arrasta um ícone para cima de outro para criares uma pasta. Os ícones da dock seguem-te em todas as páginas.', art: 'folder' },
    { c: 'lock', id: 'clock', title: 'A hora à tua maneira', body: 'Na galeria do ecrã bloqueado toca na hora para mudares o tipo de letra e a cor.', art: 'clock', act: 'lockgallery', os: 'ios' },
    { c: 'lock', id: 'clock_a', title: 'Relógio e Now Bar', body: 'O relógio do ecrã bloqueado muda de estilo nas Definições. A Now Bar mostra a chamada, a rota e a música.', art: 'clock', act: 'app:settings', os: 'android' },
    { c: 'lock', id: 'theme', title: 'Modo escuro e cor de destaque', body: 'Em Definições, Ecrã e brilho, escolhes claro ou escuro e a cor dos botões.', art: 'theme', act: 'app:settings' },
    { c: 'lock', id: 'code', title: 'Código e Face Key', body: 'Define um código de 4 ou 6 dígitos em Definições. Com o Face Key o telemóvel reconhece-te.', art: 'lock', act: 'app:settings' },
    { c: 'cc', id: 'cc_open', title: 'Abre o Centro de controlo', body: 'Desliza para baixo a partir do canto superior direito. Lanterna, modo de voo, brilho e música num só sítio.', art: 'cc', act: 'cc' },
    { c: 'cc', id: 'cc_edit', title: 'Arruma os controlos', body: 'Em Definições, Centro de controlo, escolhes que mosaicos aparecem e a ordem.', art: 'tiles', act: 'app:settings' },
    { c: 'cc', id: 'torch', title: 'Lanterna com um toque', body: 'A lanterna está no Centro de controlo e no ecrã bloqueado. Fica acesa mesmo com o telemóvel guardado.', art: 'torch', act: 'cc' },
    { c: 'cc', id: 'dnd', title: 'Não incomodar', body: 'Liga o Foco para silenciares os avisos. O que perderes fica no centro de notificações.', art: 'moon', act: 'cc' },
    { c: 'cc', id: 'sliders', title: 'Brilho e volume', body: 'Arrasta os dois cursores grandes do Centro de controlo. Enquanto arrastas, o cursor fica em vidro.', art: 'sliders', act: 'cc' },
    { c: 'glass', id: 'glass_what', title: 'O que é o Liquid Glass', body: 'As barras, os botões e os menus são de vidro: deixam ver o que está por baixo e refletem a luz nas arestas.', art: 'glass' },
    { c: 'glass', id: 'glass_tint', title: 'Mais ou menos transparente', body: 'Em Definições, Ecrã e brilho, Liquid Glass, arrasta o cursor de ultra transparente a tingido.', art: 'slider', act: 'app:settings' },
    { c: 'glass', id: 'glass_press', title: 'Toca e vê o vidro acender', body: 'Ao premir um botão de vidro ele ilumina-se a partir do dedo e cresce um pouco. Experimenta na barra de separadores.', art: 'press' },
    { c: 'glass', id: 'glass_reduce', title: 'Reduzir transparência', body: 'Se preferires superfícies opacas, liga Reduzir transparência em Definições, Acessibilidade.', art: 'contrast', act: 'app:settings' },
    { c: 'glass', id: 'glass_icons', title: 'Ícones em camadas', body: 'Os ícones têm vidro por cima. Em Personalizar escolhes Predefinido, Escuro, Transparente ou Colorido.', art: 'icons', act: 'customize' },
    { c: 'camera', id: 'shoot', title: 'Tira uma foto', body: 'Abre a Câmara e toca no obturador. A foto fica nas Fotos e podes partilhá-la nas Mensagens ou no Instashot.', art: 'camera', act: 'app:camera' },
    { c: 'camera', id: 'selfie', title: 'Selfies e vídeo', body: 'Toca no botão de rodar para a câmara da frente. Desliza para mudares de foto para vídeo.', art: 'selfie', act: 'app:camera' },
    { c: 'camera', id: 'edit', title: 'Edita antes de partilhar', body: 'Nas Fotos toca em Editar: recorta, roda e ajusta a luz. O original fica guardado.', art: 'edit', act: 'app:photos' },
    { c: 'camera', id: 'favs', title: 'Favoritas e álbuns', body: 'Toca na estrela numa foto para a marcares como favorita. As favoritas têm o seu próprio álbum.', art: 'star', act: 'app:photos' },
    { c: 'camera', id: 'link', title: 'Fotos por link', body: 'Nas Fotos podes juntar uma imagem por link, para a usares de fundo ou numa publicação.', art: 'link', act: 'app:photos' },
    { c: 'msg', id: 'send', title: 'Envia uma mensagem', body: 'Nas Mensagens toca em compor, escolhe um contacto e escreve. Mantém uma mensagem para reagir.', art: 'bubble', act: 'app:messages' },
    { c: 'msg', id: 'groups', title: 'Grupos', body: 'Cria um grupo com vários contactos. Todos veem as mensagens e as fotos no mesmo sítio.', art: 'group', act: 'app:messages' },
    { c: 'msg', id: 'calls', title: 'Chamadas e videochamadas', body: 'Com os auriculares ligados podes guardar o telemóvel durante a chamada.', art: 'call', act: 'app:phone' },
    { c: 'msg', id: 'loc', title: 'Partilha a tua localização', body: 'Numa conversa toca no mais e envia onde estás. Quem recebe abre o sítio nos Mapas.', art: 'pin', act: 'app:messages' },
    { c: 'msg', id: 'voice', title: 'Mensagens de voz', body: 'Mantém o microfone numa conversa e fala. Larga para enviar, desliza para cancelar.', art: 'mic', act: 'app:messages' },
    { c: 'social', id: 'profile', title: 'Cria o teu perfil', body: 'Instala o Instashot ou o Tweeter e escolhe um nome de utilizador. Depois publica a tua primeira foto.', art: 'profile', act: 'app:instashot' },
    { c: 'social', id: 'stories', title: 'Stories que desaparecem', body: 'As stories duram 24 horas. Junta texto, uma sondagem ou música antes de publicar.', art: 'story', act: 'app:instashot' },
    { c: 'social', id: 'react', title: 'Reage e comenta', body: 'Toca duas vezes numa foto para gostares. Os comentários ficam por baixo e podes responder a cada um.', art: 'heart' },
    { c: 'social', id: 'dm', title: 'Mensagens diretas', body: 'No Instashot, o avião de papel abre as conversas privadas. Partilha publicações por lá.', art: 'dm', act: 'app:instashot' },
    { c: 'wallet', id: 'balance', title: 'O teu saldo', body: 'A Carteira mostra o dinheiro em mão e a conta do banco. O extrato junta tudo o que entrou e saiu.', art: 'wallet', act: 'app:wallet' },
    { c: 'wallet', id: 'transfer', title: 'Transfere dinheiro', body: 'Toca em Enviar, escolhe um contacto ou escreve o número e o valor. Chega na hora.', art: 'send', act: 'app:wallet' },
    { c: 'wallet', id: 'bills', title: 'Paga as faturas', body: 'As faturas da oficina, da polícia ou da câmara chegam à app Faturas. Paga ou recusa com um toque.', art: 'receipt', act: 'app:billing' },
    { c: 'wallet', id: 'invoice', title: 'Emite uma fatura', body: 'Com um emprego podes faturar outro jogador pelo número de telefone, em teu nome ou da empresa.', art: 'invoice', act: 'app:billing' },
    { c: 'games', id: 'arcade', title: 'O Arcade', body: 'A app Arcade junta todos os jogos. Cada um guarda o teu recorde e a tua posição no servidor.', art: 'arcade', act: 'app:arcade' },
    { c: 'games', id: 'duo', title: 'Joga a dois', body: 'Convida um contacto ou alguém perto de ti para uma partida por turnos. Cada jogada chega por notificação.', art: 'duo', act: 'app:arcade' },
    { c: 'games', id: 'landscape', title: 'Deita o telemóvel', body: 'Nos jogos de ação podes rodar o telemóvel para jogares em ecrã largo. Volta sozinho ao sair.', art: 'landscape' },
    { c: 'games', id: 'controls', title: 'Controlos', body: 'Toca, desliza ou usa as setas do teclado. Todos os jogos começam com um toque, nunca sozinhos.', art: 'controls' },
    { c: 'work', id: 'notes', title: 'Notas e lembretes', body: 'Escreve notas rápidas e marca lembretes com hora. Avisam-te mesmo com a app fechada.', art: 'notes', act: 'app:notes' },
    { c: 'work', id: 'cal', title: 'Calendário', body: 'Marca eventos com hora e cor. O widget do ecrã principal mostra o que vem a seguir.', art: 'calendar', act: 'app:calendar' },
    { c: 'work', id: 'maps', title: 'Mapas e rotas', body: 'Procura um sítio e toca em Direções. O destino fica marcado no mapa do jogo.', art: 'map', act: 'app:maps' },
    { c: 'work', id: 'health', title: 'Fitness e Diário', body: 'O Fitness conta passos e calorias enquanto te mexes. No Diário guardas o teu dia com foto e sítio.', art: 'rings', act: 'app:fitness' },
    { c: 'work', id: 'mail', title: 'Mail e serviços', body: 'O Mail recebe faturas e avisos. Em Serviços chamas a polícia, o hospital ou um mecânico.', art: 'mail', act: 'app:mail' },
    { c: 'android', id: 'drawer', title: 'A gaveta de apps', body: 'Desliza para cima no ecrã principal para veres todas as apps. A pesquisa está no topo.', art: 'drawer', act: 'drawer' },
    { c: 'android', id: 'qs', title: 'Painel rápido', body: 'Desliza para baixo a partir do topo para abrires o painel rápido. Desliza outra vez para o veres todo.', art: 'qs', act: 'qs' },
    { c: 'android', id: 'qs_edit', title: 'Arruma o painel rápido', body: 'Toca no lápis do painel rápido para escolheres e ordenares os botões.', art: 'tiles', act: 'qs' },
    { c: 'android', id: 'edge', title: 'Edge panel', body: 'Desliza a partir da aresta direita para abrires o Edge panel com as tuas apps favoritas.', art: 'edge', act: 'edge' },
    { c: 'android', id: 'nav', title: 'Botões ou gestos', body: 'Em Definições, Ecrã, escolhes a barra de três botões ou os gestos de deslizar.', art: 'navbar', act: 'app:settings' },
    { c: 'android', id: 'nowbar', title: 'Now Bar', body: 'A pílula no fundo do ecrã bloqueado mostra a chamada, a rota, o temporizador e a música. Desliza para trocar.', art: 'nowbar' },
  ];
  const colOf = id => COLS.find(c => c.id === id);
  const visibleCols = () => COLS.filter(c => !c.os || c.os === OS());
  const tipsOf = c => TIPS.filter(t => t.c === c && (!t.os || t.os === OS()));
  const allVisible = () => visibleCols().flatMap(c => tipsOf(c.id));
  const readMap = () => Store.get('tipsRead', {}) || {};
  const isRead = id => !!readMap()[id];
  const markRead = id => { const m = Object.assign({}, readMap()); if (m[id]) return false; m[id] = 1; Store.set('tipsRead', m); return true; };
  /* dica do dia: a mesma durante o dia, outra no seguinte */
  const dayNum = () => { const d = new Date(); return Math.floor(new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime() / 864e5); };
  const tipOfDay = () => { const l = allVisible(); return l.length ? l[(dayNum() * 7919) % l.length] : null; };

  /* ---------- ilustrações: 320×180, formas brancas translúcidas sobre o degradê da coleção; glifos do Icons.P ---------- */
  const P = () => (window.Icons && Icons.P) || {};
  const gl = (name, x, y, s, op = 1, sw = 2) => `<svg x="${x}" y="${y}" width="${s}" height="${s}" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-opacity="${op}" stroke-width="${sw}" stroke-linecap="round" stroke-linejoin="round">${P()[name] || ''}</svg>`;
  const rr = (x, y, w, h, r, op = .18, extra = '') => `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${r}" fill="#fff" fill-opacity="${op}" ${extra}/>`;
  const line = (x1, y1, x2, y2, w = 4, op = .35) => `<path d="M${x1} ${y1}L${x2} ${y2}" stroke="#fff" stroke-opacity="${op}" stroke-width="${w}" stroke-linecap="round"/>`;
  const dot = (x, y, r, op = .9) => `<circle cx="${x}" cy="${y}" r="${r}" fill="#fff" fill-opacity="${op}"/>`;
  const phone = (x, y, w = 86, h = 150, op = .16) => rr(x, y, w, h, 14, op, 'stroke="#fff" stroke-opacity=".5" stroke-width="2"') + rr(x + w / 2 - 14, y + 8, 28, 5, 2.5, .5);
  const icons4 = (x, y, s = 16, gap = 8) => [0, 1, 2, 3].map(i => rr(x + (i % 2) * (s + gap), y + Math.floor(i / 2) * (s + gap), s, s, 5, .55)).join('');
  const ART = {
    home: () => phone(117, 15) + icons4(134, 40, 18, 10) + icons4(134, 96, 18, 10) + rr(142, 150, 36, 4, 2, .8),
    search: () => phone(117, 15) + rr(128, 34, 64, 18, 9, .55) + gl('search', 131, 36, 14, 1, 2.4) + icons4(134, 64, 18, 10) + icons4(134, 120, 18, 10),
    switcher: () => rr(40, 40, 70, 110, 12, .22) + rr(125, 25, 70, 110, 12, .4) + rr(210, 40, 70, 110, 12, .22) + rr(145, 160, 30, 4, 2, .8),
    store: () => rr(60, 30, 200, 120, 18, .16) + rr(76, 46, 44, 44, 12, .6) + rr(132, 52, 110, 10, 5, .6) + rr(132, 70, 70, 8, 4, .35) + rr(196, 104, 48, 20, 10, .9) + gl('download', 86, 56, 24, 1, 2.2),
    vera: () => `<circle cx="160" cy="88" r="46" fill="#fff" fill-opacity=".18"/><circle cx="160" cy="88" r="30" fill="#fff" fill-opacity=".3"/>` + gl('sparkles', 142, 70, 36) + rr(60, 140, 200, 22, 11, .25) + rr(74, 148, 120, 6, 3, .6),
    notif: () => rr(50, 36, 220, 46, 14, .35) + rr(50, 92, 220, 46, 14, .22) + rr(66, 48, 24, 24, 7, .8) + rr(100, 50, 110, 8, 4, .7) + rr(100, 66, 70, 6, 3, .4) + rr(66, 104, 24, 24, 7, .5) + rr(100, 106, 110, 8, 4, .4) + rr(100, 122, 60, 6, 3, .3),
    wallpaper: () => phone(117, 15, 86, 150, .1) + `<circle cx="145" cy="60" r="12" fill="#fff" fill-opacity=".9"/><path d="M119 150c14-30 28-44 42-30 12-16 26-16 40 10v20z" fill="#fff" fill-opacity=".45"/>` + rr(132, 112, 56, 10, 5, .7),
    widgets: () => phone(117, 15) + rr(130, 36, 60, 44, 10, .55) + icons4(134, 92, 18, 10) + rr(140, 44, 36, 6, 3, .9) + rr(140, 58, 24, 6, 3, .6),
    folder: () => rr(96, 44, 128, 100, 22, .25) + icons4(116, 62, 26, 12) + icons4(176, 62, 14, 8),
    clock: () => phone(117, 15, 86, 150, .1) + `<text x="160" y="74" text-anchor="middle" font-family="Inter,sans-serif" font-size="36" font-weight="300" fill="#fff">9:41</text>` + rr(142, 86, 36, 5, 2.5, .6) + gl('pen', 190, 100, 22, .9),
    theme: () => rr(60, 36, 95, 108, 16, .9) + rr(165, 36, 95, 108, 16, .18) + rr(76, 56, 60, 8, 4, .25) + rr(76, 74, 40, 8, 4, .25) + rr(181, 56, 60, 8, 4, .7) + rr(181, 74, 40, 8, 4, .5) + `<circle cx="120" cy="124" r="9" fill="#2F7CF6"/><circle cx="225" cy="124" r="9" fill="#2F7CF6"/>`,
    lock: () => `<circle cx="160" cy="90" r="50" fill="#fff" fill-opacity=".16"/>` + gl('lock', 136, 66, 48, 1, 1.8) + [0, 1, 2, 3].map(i => dot(124 + i * 24, 158, 5, i < 3 ? .9 : .35)).join(''),
    cc: () => rr(70, 30, 180, 120, 20, .14) + rr(82, 42, 76, 50, 14, .45) + rr(166, 42, 72, 22, 11, .6) + rr(166, 70, 72, 22, 11, .3) + rr(82, 100, 36, 40, 12, .3) + rr(126, 100, 36, 40, 12, .3) + rr(170, 100, 68, 40, 12, .3) + gl('flashlight', 92, 108, 16) + gl('airplane', 136, 108, 16),
    tiles: () => [0, 1, 2, 3, 4, 5].map(i => rr(70 + (i % 3) * 64, 40 + Math.floor(i / 3) * 56, 52, 44, 12, i === 1 ? .7 : .3)).join('') + gl('move', 236, 150, 22, .9),
    torch: () => `<path d="M160 70l-70 100h140z" fill="#fff" fill-opacity=".18"/>` + rr(146, 20, 28, 50, 8, .85) + rr(150, 14, 20, 10, 4, .6) + dot(160, 74, 8, .95),
    moon: () => gl('moon', 120, 50, 80, .95, 1.5) + dot(96, 50, 3, .6) + dot(226, 40, 2.5, .6) + dot(240, 120, 3, .5) + dot(80, 130, 2, .5),
    sliders: () => rr(100, 30, 44, 120, 22, .22) + rr(176, 30, 44, 120, 22, .22) + rr(100, 86, 44, 64, 22, .8) + rr(176, 64, 44, 86, 22, .8) + gl('sun', 110, 118, 24, 1, 2) + gl('speaker', 186, 118, 24, 1, 2),
    glass: () => rr(40, 50, 240, 80, 24, .12) + rr(56, 66, 70, 48, 16, .35, 'stroke="#fff" stroke-opacity=".8" stroke-width="2"') + rr(136, 66, 70, 48, 16, .2) + rr(216, 66, 48, 48, 16, .2) + line(60, 70, 110, 70, 2, .9) + rr(160, 140, 0, 0, 0, 0),
    slider: () => rr(50, 82, 220, 16, 8, .25) + rr(50, 82, 150, 16, 8, .85) + `<circle cx="200" cy="90" r="18" fill="#fff"/>` + rr(96, 40, 128, 24, 12, .2) + rr(108, 48, 104, 8, 4, .7),
    press: () => rr(60, 118, 200, 44, 22, .22) + rr(76, 126, 56, 28, 14, .85) + rr(148, 126, 46, 28, 14, .25) + rr(206, 126, 40, 28, 14, .25) + `<circle cx="104" cy="140" r="30" fill="#fff" fill-opacity=".18"/>` + gl('hand', 150, 40, 56, .95, 1.6),
    contrast: () => rr(60, 36, 95, 108, 16, .12, 'stroke="#fff" stroke-opacity=".6" stroke-width="2"') + rr(165, 36, 95, 108, 16, .92) + rr(76, 56, 60, 8, 4, .5) + rr(181, 56, 60, 8, 4, .25) + rr(76, 74, 40, 8, 4, .35) + rr(181, 74, 40, 8, 4, .2),
    icons: () => [0, 1, 2, 3].map(i => rr(56 + i * 58, 64, 48, 48, 13, [.9, .5, .18, .7][i], i === 2 ? 'stroke="#fff" stroke-opacity=".8" stroke-width="2"' : '')).join('') + gl('star', 66, 74, 28, .9) + gl('star', 124, 74, 28, .9) + gl('star', 182, 74, 28, .9) + gl('star', 240, 74, 28, .9),
    camera: () => rr(70, 48, 180, 100, 20, .22) + rr(128, 36, 64, 20, 8, .5) + `<circle cx="160" cy="98" r="30" fill="#fff" fill-opacity=".9"/><circle cx="160" cy="98" r="18" fill="#fff" fill-opacity=".3"/>` + dot(224, 70, 6, .8),
    selfie: () => phone(117, 15, 86, 150, .12) + `<circle cx="160" cy="72" r="18" fill="#fff" fill-opacity=".85"/><path d="M132 124c0-16 12-26 28-26s28 10 28 26z" fill="#fff" fill-opacity=".8"/>` + gl('rotate', 176, 138, 20, .95),
    edit: () => rr(70, 40, 180, 100, 14, .25) + `<path d="M70 140c30-40 50-50 80-20 20-24 40-30 100-4v24H70z" fill="#fff" fill-opacity=".45"/>` + [0, 1, 2].map(i => rr(96 + i * 48, 152, 36, 6, 3, i === 1 ? .9 : .4)).join('') + gl('sliders', 220, 50, 22, .95),
    star: () => rr(60, 36, 90, 90, 14, .25) + rr(170, 36, 90, 90, 14, .25) + gl('starFill', 92, 70, 26) + gl('star', 202, 70, 26, .6) + rr(60, 140, 190, 8, 4, .5),
    link: () => rr(60, 70, 200, 40, 20, .25) + gl('link', 74, 78, 24) + rr(108, 86, 130, 8, 4, .7) + rr(96, 124, 128, 30, 15, .9),
    bubble: () => `<path d="M60 50a16 16 0 0 1 16-16h110a16 16 0 0 1 16 16v34a16 16 0 0 1-16 16H92l-24 18V100a16 16 0 0 1-8-16z" fill="#fff" fill-opacity=".9"/>` + rr(78, 50, 90, 8, 4, .3) + rr(78, 66, 60, 8, 4, .3) + `<path d="M260 120a14 14 0 0 1-14 14h-72a14 14 0 0 1-14-14v-10a14 14 0 0 1 14-14h72a14 14 0 0 1 14 14z" fill="#fff" fill-opacity=".35"/>`,
    group: () => [[110, 70, .9], [160, 60, .6], [210, 70, .9]].map(([x, y, o]) => `<circle cx="${x}" cy="${y}" r="20" fill="#fff" fill-opacity="${o}"/><path d="M${x - 32} ${y + 62}c0-20 14-32 32-32s32 12 32 32z" fill="#fff" fill-opacity="${o * .8}"/>`).join(''),
    call: () => `<circle cx="160" cy="90" r="52" fill="#fff" fill-opacity=".2"/>` + gl('phoneFill', 134, 64, 52, .95) + `<path d="M226 60a40 40 0 0 1 0 60" stroke="#fff" stroke-opacity=".6" stroke-width="4" fill="none" stroke-linecap="round"/><path d="M244 44a64 64 0 0 1 0 92" stroke="#fff" stroke-opacity=".35" stroke-width="4" fill="none" stroke-linecap="round"/>`,
    pin: () => rr(50, 30, 220, 120, 18, .14) + line(50, 90, 270, 90, 3, .25) + line(160, 30, 160, 150, 3, .25) + gl('pin', 130, 40, 60, .95, 1.8) + dot(160, 64, 6, 1),
    mic: () => rr(60, 118, 200, 40, 20, .22) + `<circle cx="80" cy="138" r="14" fill="#fff" fill-opacity=".9"/>` + gl('mic', 70, 128, 20, 1, 2.2) + [0, 1, 2, 3, 4, 5, 6, 7, 8].map(i => rr(106 + i * 15, 138 - [6, 12, 18, 10, 22, 14, 8, 16, 6][i] / 2, 6, [6, 12, 18, 10, 22, 14, 8, 16, 6][i], 3, .8)).join(''),
    profile: () => `<circle cx="160" cy="68" r="32" fill="#fff" fill-opacity=".9"/>` + rr(96, 112, 128, 12, 6, .7) + rr(116, 134, 88, 8, 4, .4) + rr(60, 152, 200, 10, 5, .25),
    story: () => `<circle cx="160" cy="88" r="56" fill="none" stroke="#fff" stroke-opacity=".9" stroke-width="5"/><circle cx="160" cy="88" r="44" fill="#fff" fill-opacity=".3"/>` + rr(140, 60, 40, 56, 10, .85),
    heart: () => rr(70, 30, 180, 110, 16, .2) + gl('heartFill', 134, 58, 52, .95) + dot(110, 60, 4, .5) + dot(216, 54, 3, .5),
    dm: () => `<circle cx="160" cy="90" r="50" fill="#fff" fill-opacity=".16"/>` + gl('send', 132, 62, 56, .95, 1.6),
    wallet: () => rr(70, 50, 180, 100, 16, .25) + rr(70, 70, 180, 16, 0, .35) + rr(196, 104, 40, 26, 8, .9) + rr(86, 110, 60, 8, 4, .5),
    send: () => `<circle cx="100" cy="90" r="26" fill="#fff" fill-opacity=".85"/><circle cx="220" cy="90" r="26" fill="#fff" fill-opacity=".45"/>` + line(132, 90, 188, 90, 5, .9) + `<path d="M176 76l14 14-14 14" stroke="#fff" stroke-opacity=".9" stroke-width="5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`,
    receipt: () => `<path d="M100 30h120v120l-12-8-12 8-12-8-12 8-12-8-12 8-12-8-12 8-12-8-12 8z" fill="#fff" fill-opacity=".9"/>` + rr(118, 54, 84, 8, 4, .3) + rr(118, 72, 84, 8, 4, .3) + rr(118, 90, 52, 8, 4, .3) + rr(166, 108, 36, 12, 6, .5),
    invoice: () => rr(60, 44, 120, 92, 14, .9) + rr(76, 62, 60, 8, 4, .3) + rr(76, 80, 88, 8, 4, .3) + rr(76, 98, 40, 8, 4, .3) + gl('arrowR', 190, 74, 32, .9) + `<circle cx="248" cy="90" r="22" fill="#fff" fill-opacity=".5"/>`,
    arcade: () => rr(84, 50, 152, 90, 24, .25) + `<circle cx="124" cy="94" r="18" fill="#fff" fill-opacity=".85"/>` + dot(196, 84, 8, .9) + dot(216, 100, 8, .6) + dot(196, 108, 8, .6) + dot(176, 96, 8, .6),
    duo: () => `<circle cx="104" cy="80" r="22" fill="#fff" fill-opacity=".9"/><circle cx="216" cy="80" r="22" fill="#fff" fill-opacity=".9"/>` + rr(132, 72, 56, 16, 8, .3) + `<path d="M150 64l10-10 10 10M170 96l-10 10-10-10" stroke="#fff" stroke-opacity=".9" stroke-width="4" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`,
    landscape: () => rr(50, 42, 220, 110, 18, .16, 'stroke="#fff" stroke-opacity=".5" stroke-width="2"') + rr(64, 56, 192, 82, 10, .35) + gl('rotate', 236, 20, 28, .9),
    controls: () => `<path d="M90 110h50M115 85v50" stroke="#fff" stroke-opacity=".9" stroke-width="10" stroke-linecap="round"/>` + dot(206, 92, 11, .9) + dot(236, 112, 11, .6) + dot(176, 112, 11, .6) + dot(206, 132, 11, .6),
    notes: () => rr(80, 30, 160, 124, 14, .9) + rr(80, 30, 160, 26, 0, .35) + rr(98, 74, 124, 8, 4, .3) + rr(98, 92, 124, 8, 4, .3) + rr(98, 110, 80, 8, 4, .3) + gl('checkCircle', 196, 110, 30, .9),
    calendar: () => rr(80, 30, 160, 124, 16, .22) + rr(80, 30, 160, 32, 0, .5) + [0, 1, 2, 3, 4, 5, 6, 7].map(i => rr(96 + (i % 4) * 34, 74 + Math.floor(i / 4) * 34, 24, 24, 7, i === 5 ? .95 : .35)).join(''),
    map: () => rr(50, 30, 220, 120, 18, .14) + `<path d="M50 120c40-30 70-10 110-40s60-20 110-10" stroke="#fff" stroke-opacity=".6" stroke-width="10" fill="none" stroke-linecap="round"/>` + gl('pin', 196, 36, 40, .95, 1.8) + dot(90, 112, 8, .9),
    rings: () => [[52, .9], [38, .7], [24, .5]].map(([r, o]) => `<circle cx="160" cy="90" r="${r}" fill="none" stroke="#fff" stroke-opacity=".18" stroke-width="11"/><circle cx="160" cy="90" r="${r}" fill="none" stroke="#fff" stroke-opacity="${o}" stroke-width="11" stroke-linecap="round" stroke-dasharray="${(2 * Math.PI * r * .72).toFixed(1)} 999" transform="rotate(-90 160 90)"/>`).join(''),
    mail: () => rr(70, 50, 180, 100, 16, .9) + `<path d="M74 58l86 60 86-60" stroke="#2F3F5C" stroke-opacity=".55" stroke-width="4" fill="none" stroke-linejoin="round"/>` + dot(244, 56, 10, 1),
    drawer: () => phone(117, 15) + rr(126, 36, 68, 14, 7, .5) + [0, 1, 2, 3, 4, 5, 6, 7, 8].map(i => rr(128 + (i % 3) * 22, 58 + Math.floor(i / 3) * 24, 18, 18, 6, .6)).join('') + `<path d="M150 150l10-10 10 10" stroke="#fff" stroke-opacity=".9" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`,
    qs: () => phone(117, 15, 86, 150, .12) + rr(126, 30, 68, 50, 12, .3) + [0, 1, 2, 3, 4, 5].map(i => `<circle cx="${139 + (i % 3) * 21}" cy="${46 + Math.floor(i / 3) * 20}" r="7" fill="#fff" fill-opacity="${i === 0 ? .95 : .55}"/>`).join('') + rr(126, 88, 68, 10, 5, .5) + rr(126, 104, 68, 10, 5, .3) + `<path d="M150 20l10 10 10-10" stroke="#fff" stroke-opacity=".9" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`,
    edge: () => phone(100, 15, 86, 150, .12) + rr(196, 30, 60, 120, 18, .5) + [0, 1, 2, 3].map(i => rr(214, 44 + i * 26, 24, 20, 7, .9)).join('') + `<path d="M190 78l-10 12 10 12" stroke="#fff" stroke-opacity=".9" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`,
    navbar: () => phone(117, 15, 86, 150, .12) + `<path d="M138 146l6 6 6-6" stroke="#fff" stroke-opacity=".9" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>` + `<circle cx="160" cy="149" r="4" fill="#fff" fill-opacity=".9"/>` + rr(170, 145, 8, 8, 2, .9),
    nowbar: () => phone(117, 15, 86, 150, .12) + `<text x="160" y="70" text-anchor="middle" font-family="Inter,sans-serif" font-size="30" font-weight="300" fill="#fff">9:41</text>` + rr(128, 134, 64, 18, 9, .9) + `<circle cx="138" cy="143" r="5" fill="#2DBE60"/>` + rr(148, 141, 34, 4, 2, .45),
  };
  const artSvg = (tip, col) => `<div class="tip-art" style="background:linear-gradient(135deg,${col.c1},${col.c2})"><svg viewBox="0 0 320 180" preserveAspectRatio="xMidYMid meet" aria-hidden="true">${(ART[tip.art] || ART.home)()}</svg></div>`;

  /* ---------- o que o Experimentar faz ---------- */
  const closeThen = fn => { try { System.closeApp(); } catch (e) {} setTimeout(() => { try { fn(); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } }, 480); };
  const openOr = id => { try { if (App.get(id) && (!System.isInstalled || System.isInstalled(id))) System.openApp(id); else System.openApp('appstore'); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } };
  const ACT = {
    spotlight: () => closeThen(() => Home.spotlight()),
    drawer: () => closeThen(() => Drawer.open()),
    switcher: () => closeThen(() => Switcher.open()),
    recents: () => closeThen(() => (window.SysUI && SysUI.recents ? SysUI.recents() : Switcher.open())),
    vera: () => { try { Vera.open(); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } },
    nc: () => { try { Notify.openNC(); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } },
    lockgallery: () => closeThen(() => LockGallery.open(true)),
    homeedit: () => closeThen(() => Home.enterEdit()),
    customize: () => closeThen(() => (Home.openCustomize ? Home.openCustomize() : Home.enterEdit())),
    cc: () => { try { CC.open(); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } },
    qs: () => { try { QuickPanel.open(); } catch (e) { UI.toast(T('Indisponível neste telemóvel')); } },
    edge: () => closeThen(() => EdgePanel.open()),
  };
  const runAct = tip => { if (!tip.act) return; markRead(tip.id); Sound.play('click'); if (tip.act.startsWith('app:')) { openOr(tip.act.slice(4)); return; } const f = ACT[tip.act]; if (f) f(); };
  const actLabel = tip => { if (!tip.act) return null; if (tip.act.startsWith('app:')) { const id = tip.act.slice(4); return App.get(id) ? TF('Abrir %s', App.name(id)) : T('Experimentar'); } return T('Experimentar'); };

  /* ---------- a app ---------- */
  App.define('tips', {
    name: 'Dicas', category: 'Utilitários', core: false, statusBar: 'auto',
    description: 'Aprende o telemóvel por coleções curtas: ecrã bloqueado, câmara, mensagens, carteira, jogos e mais. Cada dica tem um botão para experimentar.',
    resume(win) { try { win._tipsPaint && win._tipsPaint(); } catch (e) {} },
    open(win) {
      const A = isA();
      const root = UI.view({ title: 'Dicas', large: true, cls: 'tip-v tip-root' });
      const hero = UI.el('<div class="tip-hero"></div>');
      const colsH = UI.el('<div class="tip-sh"><span>Coleções</span></div>');
      const cols = UI.el('<div class="tip-cols"></div>');
      root.content.append(hero, colsH, cols);
      root.content.appendChild(UI.el('<div class="group-footer tip-foot">As dicas lidas ficam marcadas neste telemóvel. A dica do dia muda à meia-noite.</div>'));
      const colCards = {};
      visibleCols().forEach(c => { const n = tipsOf(c.id).length; const el = UI.el(`<div class="tip-col" style="--c1:${c.c1};--c2:${c.c2}"><div class="tip-ci">${g(c.icon, 24)}</div><div class="tip-ct"><b>${UI.esc(c.label)}</b><span></span><div class="tip-prog"><i></i></div></div><div class="tip-chev">${g('chevR', 18)}</div></div>`); el.querySelector('span').textContent = n === 1 ? T('1 dica') : TF('%s dicas', n); el.onclick = () => { Sound.play('click'); UI.push(win, colView(c)); }; colCards[c.id] = el; cols.appendChild(el); });
      function paintHero() {
        const t = tipOfDay(); if (!t) { hero.hidden = true; return; } const c = colOf(t.c);
        hero.innerHTML = `<div class="tip-hl">${g('bulb', 16)}<span>Dica do dia</span></div>${artSvg(t, c)}<div class="tip-hb"><small>${UI.esc(c.label)}</small><b>${UI.esc(t.title)}</b><p>${UI.esc(t.body)}</p><div class="tip-acts"></div></div>`;
        const acts = hero.querySelector('.tip-acts');
        const al = actLabel(t); if (al) { const b = UI.el(`<div class="tip-btn">${UI.esc(al)}</div>`); b.onclick = e => { e.stopPropagation(); runAct(t); }; acts.appendChild(b); }
        const more = UI.el(`<div class="tip-btn tip-btn2">${UI.esc(T('Ver coleção'))}</div>`); more.onclick = e => { e.stopPropagation(); Sound.play('click'); UI.push(win, colView(c, t.id)); }; acts.appendChild(more);
        hero.onclick = () => { markRead(t.id); paint(); };
      }
      function paint() {
        paintHero();
        Object.keys(colCards).forEach(id => { const l = tipsOf(id), n = l.filter(t => isRead(t.id)).length; const el = colCards[id]; el.querySelector('.tip-prog i').style.transform = `scaleX(${l.length ? (n / l.length).toFixed(3) : 0})`; el.classList.toggle('done', l.length > 0 && n === l.length); });
      }
      function colView(c, focusId) {
        const v = UI.view({ title: c.label, back: 'Dicas', large: true, cls: 'tip-v tip-colv' });
        v.content.style.setProperty('--c1', c.c1); v.content.style.setProperty('--c2', c.c2);
        const list = UI.el('<div class="tip-list"></div>'); v.content.appendChild(list);
        tipsOf(c.id).forEach(t => {
          const card = UI.el(`<div class="tip-card ${isRead(t.id) ? 'read' : ''}" data-id="${t.id}">${artSvg(t, c)}<div class="tip-cb"><div class="tip-ctt"><b>${UI.esc(t.title)}</b><i class="tip-rd">${g('check', 14)}</i></div><p>${UI.esc(t.body)}</p><div class="tip-acts"></div></div></div>`);
          const al = actLabel(t); if (al) { const b = UI.el(`<div class="tip-btn">${UI.esc(al)}</div>`); b.onclick = e => { e.stopPropagation(); runAct(t); card.classList.add('read'); paint(); }; card.querySelector('.tip-acts').appendChild(b); } else card.querySelector('.tip-acts').remove();
          card.onclick = () => { if (markRead(t.id)) { card.classList.add('read'); Sound.play('tick'); paint(); } };
          list.appendChild(card);
        });
        if (focusId) setTimeout(() => { const el = list.querySelector(`.tip-card[data-id="${focusId}"]`); if (el && v.content) v.content.scrollTop = Math.max(0, el.offsetTop - 120); }, 450);
        return v;
      }
      win._tipsPaint = () => { if (root.isConnected) paint(); };
      paint(); UI.setRoot(win, root);
    }
  });
  App.alias('android', { tips: 'Dicas' });

  /* ---------- ícones (desenho original): lâmpada em fundo amarelo (PearOS); lâmpada em fundo índigo (Nova UI) ---------- */
  const BULB = '<path d="M50 20a21 21 0 0 0-12.5 37.9c2.6 2 4 4.7 4 7.6V68h17v-2.5c0-2.9 1.4-5.6 4-7.6A21 21 0 0 0 50 20z"/>';
  Icons.app.tips = () => Icons.SVG(Icons.G('gTp', '#FFD54A', '#FF9500') + Icons.GL(`<g fill="#fff">${BULB}<rect x="41.5" y="71" width="17" height="5" rx="2.5"/><rect x="44" y="78.5" width="12" height="4.5" rx="2.25"/></g>`) + `<path d="M44 46l6 7 6-7" fill="none" stroke="#FFB300" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>`);
  Icons.registerOS('android', { tips: () => Icons.SVG(`<defs><linearGradient id="nvTpB" gradientUnits="userSpaceOnUse" x1="38" y1="0" x2="62" y2="100"><stop offset="0" stop-color="#6F8CFF"/><stop offset="1" stop-color="#3B55E6"/></linearGradient><radialGradient id="nvTpL" gradientUnits="userSpaceOnUse" cx="30" cy="0" r="80"><stop offset="0" stop-color="#fff" stop-opacity=".18"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></radialGradient></defs><rect width="100" height="100" fill="url(#nvTpB)"/><rect width="100" height="100" fill="url(#nvTpL)"/><g fill="#fff" fill-opacity=".96">${BULB}<rect x="41.5" y="71" width="17" height="5" rx="2.5"/><rect x="44" y="78.5" width="12" height="4.5" rx="2.25"/></g><path d="M50 32v12M44 42l6 6 6-6" fill="none" stroke="#3B55E6" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>`, true) });

  /* ---------- widget 2×2: Dica do dia ---------- */
  if (window.Widgets && Widgets.register) {
    Widgets.register({ id: 'tips', name: 'Dica do dia', sizes: ['2x2'], app: 'tips', style: 'padding:0',
      render: () => { const t = tipOfDay(); if (!t) return `<div class="tip-w"><div class="tip-wh">${g('bulb', 14)}<span>${UI.esc(T('Dica do dia'))}</span></div></div>`; const c = colOf(t.c);
        return `<div class="tip-w" style="--c1:${c.c1};--c2:${c.c2}"><div class="tip-wh">${g('bulb', 14)}<span>${UI.esc(T('Dica do dia'))}</span></div><div class="tip-wi">${g(c.icon, 26)}</div><b>${UI.esc(T(t.title))}</b><span class="tip-wc">${UI.esc(T(c.label))}</span></div>`; } });
  }
  window.Tips = { tipOfDay, TIPS, COLS, isRead, markRead };
})();
