/* ===================== RECADO - EXTRAS (pacote RD) =====================
   Contrato: docs/ARQUITETURA.md secção 9.5 (RecadoExtras) e 9.6 (RPCs do RD).

   O que vive aqui:
     · formatText(texto) → HTML SEGURO (escapa tudo primeiro e só depois aplica *negrito* _itálico_ ~riscado~
       `código` ```bloco``` listas "- " / "1. " e citações "> ")
     · emojiPicker(host, onPick) - painel com categorias, recentes (Store da personagem) e pesquisa em português
     · stickerPicker(win, onPick) - 3 packs PRÓPRIOS desenhados aqui em SVG (básicos, cidade, reações)
     · gifPicker(win, onPick) - só com fornecedor ativo no servidor; senão explica como ativar
     · pollComposer / eventComposer / documentPicker(win, target) → Promise<mensagem|null>
     · render(msg, bolhaEl) → true se tratou (poll, event, sticker, gif, document)
     · label(msg) - texto curto para listas e notificações (acrescento ao contrato)
   No fim ficam os mocks do browser (LocalDB.register) de todos os RPCs do RD.

   Regras do CEF do FiveM respeitadas: nada de filter/backdrop-filter, só transform/opacity animam (as barras
   das sondagens crescem por scaleX), imagens só por propriedade (img.src), nunca base64 dentro de HTML. */
window.RecadoExtras = (() => {
  const g = (n, s) => UI.g(n, s);
  const esc = s => UI.esc(s);
  const R = () => window.Recado || null;
  /* o json.encode do FiveM manda listas vazias como {}: tudo o que é lista passa por aqui */
  const arr = v => Array.isArray(v) ? v : (v && typeof v === 'object' && !v.error ? Object.values(v) : []);
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  const TYPES = ['poll', 'event', 'sticker', 'gif', 'document'];
  const payloadOf = m => { let p = m && m.payload; if (typeof p === 'string') { try { p = JSON.parse(p); } catch (e) { p = null; } } return p && typeof p === 'object' ? p : {}; };
  const stop = e => { if (e) { e.stopPropagation(); } };

  /* ---------- configuração (recado.extras.config) ----------
     Valores por omissão = os do config_recado.lua; o servidor é quem decide sempre. */
  let CFG = { gif: { enabled: false, provider: 'none' }, polls: { maxOptions: 12 }, events: { reminders: [0, 15, 60, 1440] }, stickers: ['basicos', 'cidade', 'reacoes'], doc: { titleMax: 80, bodyMax: 20000 } };
  let cfgAt = 0, cfgP = null;
  function loadCfg(force) {
    if (!force && cfgP && Date.now() - cfgAt < 60000) return cfgP;
    cfgAt = Date.now();
    cfgP = Promise.resolve(Bridge.rpcRaw('recado.extras.config', {})).then(r => {
      if (r && typeof r === 'object' && !r.error) {
        const re = arr(r.events && r.events.reminders).map(int).filter(n => n >= 0);
        CFG = {
          gif: { enabled: !!(r.gif && r.gif.enabled), provider: (r.gif && r.gif.provider) || 'none' },
          polls: { maxOptions: Math.max(2, Math.min(20, int(r.polls && r.polls.maxOptions) || 12)) },
          events: { reminders: re.length ? re : [0, 15, 60, 1440] },
          stickers: arr(r.stickers).filter(x => typeof x === 'string'),
          doc: { titleMax: int(r.doc && r.doc.titleMax) || 80, bodyMax: int(r.doc && r.doc.bodyMax) || 20000 }
        };
        /* quem mostra o botão GIF (RB) pode voltar a perguntar gifEnabled() quando isto chega */
        try { Bridge.emit('recadoExtras:config', CFG); } catch (e) {}
      }
      return CFG;
    }, () => CFG);
    return cfgP;
  }

  /* ---------- nomes e erros ---------- */
  const myNumber = () => { const r = R(); try { const m = r && r.me && r.me(); if (m && m.number) return String(m.number); } catch (e) {} return String((window.System && System.player && System.player.phone) || ''); };
  function nameOf(n) {
    if (n == null) return '';
    if (String(n) === myNumber()) return 'Tu';
    const r = R(); try { if (r && r.nameOf) { const x = r.nameOf(n); if (x) return x; } } catch (e) {}
    try { if (window.Contacts && Contacts.name) return Contacts.name(n) || String(n); } catch (e) {}
    return String(n);
  }
  /* cor do avatar estável por número (a paleta do UI.avatar escolhe pelo seed) */
  const seedOf = n => [...String(n)].reduce((h, c) => (h * 31 + c.charCodeAt(0)) % 9973, 7);
  const ERR = {
    question: 'Escreve a pergunta da sondagem.', options: 'A sondagem precisa de pelo menos 2 opções.', duplicate: 'Há opções repetidas.',
    toomany: 'Demasiadas opções.', single: 'Esta sondagem só aceita uma resposta.', title: 'Falta o título.', start: 'Escolhe uma data e hora no futuro.',
    location: 'Local inválido.', noperm: 'O Zapp não tem autorização para usar a tua localização.', disabled: 'O Zapp está desligado neste servidor.', reminder: 'Lembrete inválido.', body: 'O documento está vazio.', toolarge: 'O documento é demasiado grande.',
    notfound: 'Já não está disponível.', notmember: 'Já não fazes parte deste grupo.', blocked: 'Desbloqueia o contacto para lhe escrever.',
    cancelled: 'Este evento foi cancelado.', past: 'Este evento já terminou.', notcreator: 'Só quem criou o evento o pode cancelar.',
    nogif: 'Os GIF não estão ativos neste servidor.', gifdown: 'O serviço de GIF não respondeu. Tenta mais tarde.', busy: 'Ocupado, tenta de novo.',
    ratelimit: 'Demasiados pedidos. Espera um pouco.', target: 'Conversa inválida.', db: 'O servidor ainda está a arrancar.', badtype: 'Tipo de mensagem não permitido.',
    empty: 'Sem resposta do servidor.', internal: 'Erro no servidor.', unavailable: 'O Zapp não está disponível.'
  };
  function errText(code) {
    const c = String(code || '');
    const r = R(); try { if (r && r.errorText) { const t = r.errorText(c); if (t && t !== c) return t; } } catch (e) {}
    return ERR[c] || ERR[c.split(':')[0]] || 'Não foi possível concluir.';
  }
  const failed = r => !r || typeof r !== 'object' || !!r.error || r.ok === false;
  const codeOf = r => (r && typeof r === 'object' && r.error) ? r.error : (r ? 'failed' : 'empty');

  /* ============================================================
     TEXTO FORMATADO
     1) tira os marcadores internos e escapa o HTML TODO; 2) guarda blocos de código, código em linha e URLs
     em marcadores (lá dentro nada se formata); 3) linhas: citações e listas; 4) negrito/itálico/riscado só
     com fronteira de palavra (nome_de_ficheiro não fica em itálico); 5) repõe os marcadores.
     Só as NOSSAS etiquetas entram no resultado - nunca texto do utilizador por escapar.
     ============================================================ */
  const B = '(^|[\\s(\\[{.,;:!?¿¡>\\u2014-])';
  const A = '(?=$|[\\s)\\]}.,;:!?<&\\u2014-])';
  const RX = [['\\*', 'b'], ['_', 'i'], ['~', 's']].map(([m, tag]) => [new RegExp(B + m + '(?!\\s)([^' + m + '\\n]*?[^\\s' + m + '])' + m + A, 'g'), tag]);
  /* marcadores internos (zona de uso privado do Unicode). As RegExp levam \\u em texto: assim o ficheiro não
     guarda caracteres invisíveis nem de controlo (um editor ou o git podiam estragá-los sem se ver). */
  const P0 = String.fromCharCode(0xE000), P1 = String.fromCharCode(0xE001);
  const PUA_ALL = new RegExp('[\\uE000-\\uE00F]', 'g'), PUA_BACK = new RegExp('\\uE000(\\d+)\\uE001', 'g');
  const URL_RX = new RegExp('\\bhttps?:\\/\\/[^\\s<\\uE000]+', 'g');
  function inline(t) {
    let s = t;
    for (let k = 0; k < 2; k++) RX.forEach(([rx, tag]) => { s = s.replace(rx, (_, pre, body) => pre + '<' + tag + '>' + body + '</' + tag + '>'); });
    return s;
  }
  function formatText(text) {
    let s = String(text == null ? '' : text).replace(PUA_ALL, '').replace(/\r\n?/g, '\n');
    if (s.length > 20000) s = s.slice(0, 20000);
    const store = [];
    const keep = html => P0 + (store.push(html) - 1) + P1;
    s = esc(s);
    s = s.replace(/```\n?([\s\S]*?)\n?```/g, (_, code) => keep('<pre class="rcx-code">' + code + '</pre>'));
    s = s.replace(/`([^`\n]+)`/g, (_, code) => keep('<code class="rcx-icode">' + code + '</code>'));
    s = s.replace(URL_RX, u => { const m = /[.,!?:)]+$/.exec(u); const tail = m ? m[0] : ''; const url = tail ? u.slice(0, -tail.length) : u; return keep('<span class="rcx-url">' + url + '</span>') + tail; });
    const parts = []; let list = null, quote = null;
    const flushList = () => { if (!list) return; parts.push({ block: true, html: '<' + list.tag + ' class="rcx-list"' + (list.tag === 'ol' && list.start !== 1 ? ' start="' + list.start + '"' : '') + '>' + list.items.map(x => '<li>' + x + '</li>').join('') + '</' + list.tag + '>' }); list = null; };
    const flushQuote = () => { if (!quote) return; parts.push({ block: true, html: '<blockquote class="rcx-quote">' + quote.join('<br>') + '</blockquote>' }); quote = null; };
    s.split('\n').forEach(line => {
      let m;
      if ((m = /^&gt; ?(.*)$/.exec(line))) { flushList(); (quote = quote || []).push(inline(m[1])); return; }
      flushQuote();
      if ((m = /^[-•] (.+)$/.exec(line))) { if (!list || list.tag !== 'ul') { flushList(); list = { tag: 'ul', items: [] }; } list.items.push(inline(m[1])); return; }
      if ((m = /^(\d{1,3})[.)] (.+)$/.exec(line))) { if (!list || list.tag !== 'ol') { flushList(); list = { tag: 'ol', items: [], start: Math.max(1, int(m[1])) }; } list.items.push(inline(m[2])); return; }
      flushList();
      parts.push({ block: false, html: inline(line) });
    });
    flushList(); flushQuote();
    let html = '';
    /* linha em branco antes de uma lista/citação: o <br> que fecha a linha de texto some antes de um bloco e a
       linha vazia desaparecia ("Horário…\n\n1. …" ficava colado) - mais um <br> nesse caso */
    parts.forEach((p, i) => { const prev = parts[i - 1]; if (i && !p.block && prev && !prev.block) html += '<br>'; if (p.block && prev && !prev.block && prev.html === '') html += '<br>'; html += p.html; });
    return html.replace(PUA_BACK, (_, i) => store[+i] || '');
  }
  /* texto sem marcas (pré-visualizações) */
  const plain = t => String(t == null ? '' : t).replace(/```([\s\S]*?)```/g, '$1').replace(/[*_~`]/g, '').replace(/^\s*(&gt;|>|[-•]|\d{1,3}[.)])\s+/gm, '');

  /* ============================================================
     EMOJI - lista própria com nomes em português para a pesquisa ("coração", "cão", "festa"…).
     Sem bandeiras: a fonte de emoji do Windows (a do CEF) não as desenha e ficavam só letras.
     Formato: "emoji nome palavras|…" por categoria.
     ============================================================ */
  const EMOJI_CATS = [
    { id: 'rostos', label: 'Rostos', icon: '😀', list: '😀 sorriso feliz contente|😃 sorriso grande alegria|😄 riso feliz|😁 sorriso dentes|😆 gargalhada riso|😅 riso nervoso suor|🤣 rebolar a rir gargalhada|😂 lagrimas de riso chorar a rir|🙂 sorriso leve|🙃 cabeca para baixo ironia|😉 piscar olho|😊 corado feliz timido|😇 anjo inocente|🥰 apaixonado coracoes|😍 olhos de coracao amor|🤩 estrelas deslumbrado|😘 beijo|😋 delicioso lingua|😛 lingua|😜 piscar lingua brincadeira|🤪 maluco doido|🤑 dinheiro rico|🤗 abraco|🤭 mao na boca ops|🤫 silencio segredo|🤔 pensar duvida|🤐 boca fechada|🤨 sobrancelha desconfiado|😐 neutro serio|😑 sem expressao|😶 calado sem boca|😏 malicioso|😒 aborrecido|🙄 revirar olhos|😬 careta tenso|😌 aliviado calmo|😔 pensativo|😪 sono|😴 dormir|😷 mascara doente|🤒 febre doente|🤢 enjoado|🤮 vomitar|🥵 calor quente|🥶 frio gelado|😵 tonto|🤯 cabeca a explodir chocado|🤠 cowboy chapeu|🥳 festa celebrar aniversario|😎 oculos de sol fixe|🤓 nerd oculos|🧐 monoculo curioso|😕 confuso|😟 preocupado|🙁 triste|😮 surpreso boca aberta|😲 espantado|😳 envergonhado corado|🥺 por favor suplicar|😨 medo|😰 ansioso|😢 chorar lagrima|😭 chorar muito|😱 grito medo|😖 frustrado|😞 desiludido|😩 cansado exausto|😫 farto|🥱 bocejo|😤 bufar triunfo|😡 zangado raiva|😠 irritado|🤬 palavroes furioso|😈 diabinho|💀 caveira morto de riso|💩 coco|🤡 palhaco|👻 fantasma|👽 extraterrestre|🤖 robo' },
    { id: 'pessoas', label: 'Pessoas e gestos', icon: '👋', list: '👋 ola adeus acenar|🤚 mao levantada|✋ mao parar|🖖 saudacao|👌 ok perfeito|🤌 dedos juntos|🤏 pouquinho|✌️ paz vitoria|🤞 dedos cruzados sorte|🤟 amo-te|🤘 rock|🤙 liga-me|👈 apontar esquerda|👉 apontar direita|👆 apontar cima|👇 apontar baixo|☝️ atencao indicador|👍 gosto polegar sim|👎 nao gosto polegar baixo|✊ punho|👊 soco|👏 palmas aplaudir|🙌 celebrar maos ao ar|👐 maos abertas|🤲 palmas juntas|🤝 aperto de mao acordo|🙏 por favor obrigado|✍️ escrever|💪 forca musculo|🧠 cerebro|👀 olhos ver|👁️ olho|👄 boca|💋 beijo marca|👶 bebe|🧒 crianca|👦 rapaz|👧 rapariga|🧑 pessoa|👨 homem|👩 mulher|🧓 idoso|👮 policia|👷 obras trabalhador|💂 guarda|🕵️ detetive|🤵 noivo fato|👰 noiva|🤰 gravida|🎅 pai natal|🦸 super-heroi|🧟 zombie|💃 dancar|🕺 dancar homem|🚶 andar a pe|🏃 correr|🧍 de pe' },
    { id: 'simbolos', label: 'Corações e símbolos', icon: '❤️', list: '❤️ coracao amor vermelho|🧡 coracao laranja|💛 coracao amarelo|💚 coracao verde|💙 coracao azul|💜 coracao roxo|🖤 coracao preto|🤍 coracao branco|🤎 coracao castanho|💔 coracao partido|❣️ coracao exclamacao|💕 dois coracoes|💞 coracoes a girar|💓 coracao a bater|💗 coracao a crescer|💖 coracao brilhante|💘 cupido seta|💯 cem pontos|💢 raiva|💥 explosao boom|💫 tonto estrela|💦 gotas agua|💨 vento correr|💬 balao fala|💭 pensamento|💤 zzz dormir|✅ certo visto|❌ errado cruz|❓ pergunta|❗ exclamacao|⚠️ aviso atencao|🚫 proibido|⛔ sentido proibido|♻️ reciclar|✨ brilho estrelas|⭐ estrela|🌟 estrela brilhante|🔥 fogo lume|⚡ raio energia|🎵 musica nota|🔔 sino notificacao|🆗 ok|🆕 novo|🆘 socorro sos' },
    { id: 'natureza', label: 'Animais e natureza', icon: '🐶', list: '🐶 cao|🐱 gato|🐭 rato|🐹 hamster|🐰 coelho|🦊 raposa|🐻 urso|🐼 panda|🐨 coala|🐯 tigre|🦁 leao|🐮 vaca|🐷 porco|🐸 sapo|🐵 macaco|🙈 macaco nao ver|🙉 macaco nao ouvir|🙊 macaco nao falar|🐔 galinha|🐧 pinguim|🐦 passaro|🦅 aguia|🦉 coruja|🐺 lobo|🐴 cavalo|🦄 unicornio|🐝 abelha|🦋 borboleta|🐌 caracol|🐢 tartaruga|🐍 cobra|🦈 tubarao|🐬 golfinho|🐳 baleia|🐙 polvo|🌵 cato|🌴 palmeira|🌲 pinheiro arvore|🍀 trevo sorte|🌹 rosa flor|🌻 girassol|🌸 flor cerejeira|🍁 folha outono|🌈 arco-iris|☀️ sol|🌙 lua|⛅ nuvens|🌧️ chuva|⛈️ trovoada|❄️ neve|🌊 onda mar' },
    { id: 'comida', label: 'Comida e bebida', icon: '🍔', list: '🍏 maca verde|🍎 maca|🍊 laranja|🍋 limao|🍌 banana|🍉 melancia|🍇 uvas|🍓 morango|🍒 cerejas|🍑 pessego|🍍 ananas|🥥 coco|🥑 abacate|🌶️ malagueta picante|🌽 milho|🥕 cenoura|🥔 batata|🥐 croissant|🍞 pao|🧀 queijo|🥚 ovo|🍳 ovo estrelado|🥓 bacon|🍗 frango|🍔 hamburguer|🍟 batatas fritas|🍕 pizza|🌭 cachorro-quente|🌮 taco|🌯 burrito|🍝 massa esparguete|🍜 ramen sopa|🍣 sushi|🍤 camarao|🍩 donut|🍪 bolacha|🎂 bolo de aniversario|🍰 fatia de bolo|🍫 chocolate|🍿 pipocas|🍦 gelado|☕ cafe|🍵 cha|🥤 refrigerante|🧃 sumo|🍺 cerveja|🍻 brinde cervejas|🍷 vinho|🍸 cocktail|🥂 brinde champanhe|🥃 whisky' },
    { id: 'atividades', label: 'Atividades', icon: '⚽', list: '⚽ futebol bola|🏀 basquetebol|🏈 futebol americano|⚾ basebol|🎾 tenis|🏐 voleibol|🎱 bilhar|🏓 pingue-pongue|🥊 boxe luva|🥋 artes marciais|⛳ golfe|🎣 pesca|🏋️ ginasio pesos|🚴 bicicleta ciclismo|🏄 surf|🏊 nadar|🏆 trofeu vencedor|🥇 medalha ouro|🎮 videojogo comando|🕹️ joystick|🎲 dado jogo|🎯 alvo|🎳 bowling|🎰 casino|🃏 carta joker|🎤 microfone karaoke|🎧 auscultadores|🎸 guitarra|🎹 piano|🥁 bateria|🎬 cinema filme|🎨 pintura arte|🎉 festa confetis|🎊 confetis|🎁 presente prenda|🎈 balao' },
    { id: 'viagens', label: 'Viagens e lugares', icon: '🚗', list: '🚗 carro|🚕 taxi|🚙 jipe|🚌 autocarro|🚓 carro da policia|🚑 ambulancia|🚒 bombeiros|🏎️ carro de corrida|🚚 camiao|🚜 trator|🏍️ mota|🛵 scooter|🚲 bicicleta|🛴 trotinete|🚁 helicoptero|✈️ aviao|🚀 foguetao|⛵ veleiro barco|🚤 lancha|⚓ ancora|⛽ gasolina bomba|🚦 semaforo|🗺️ mapa|🏠 casa|🏡 casa jardim|🏢 escritorio predio|🏥 hospital|🏦 banco|🏨 hotel|🏪 loja|🏫 escola|⛪ igreja|🏰 castelo|🎡 roda gigante|🎢 montanha-russa|🏖️ praia|🏝️ ilha|⛰️ montanha|🌆 cidade entardecer|🌃 cidade a noite|🌉 ponte a noite' },
    { id: 'objetos', label: 'Objetos', icon: '💡', list: '⌚ relogio|📱 telemovel|💻 portatil computador|⌨️ teclado|🖥️ computador ecra|📷 camara fotografia|🎥 camara filmar|📺 televisao|📻 radio|⏰ despertador alarme|⏳ ampulheta|💡 lampada ideia|🔦 lanterna|🕯️ vela|💸 dinheiro a voar|💵 notas dinheiro|💰 saco de dinheiro|💳 cartao|💎 diamante|🔧 chave inglesa|🔨 martelo|🛠️ ferramentas|🔒 cadeado|🔑 chave|🚪 porta|🛏️ cama|🛒 carrinho compras|🎒 mochila|👜 mala|👓 oculos|🕶️ oculos de sol|👕 t-shirt|👖 calcas|👗 vestido|👟 sapatilhas tenis|👑 coroa|💍 anel|📦 caixa encomenda|✉️ envelope carta|📅 calendario|📌 pionés|📎 clipe|✂️ tesoura|📝 nota escrever|📚 livros|📖 livro aberto|🔍 lupa procurar|💊 comprimido|💉 seringa vacina|🩹 penso' }
  ].map(c => Object.assign(c, { items: c.list.split('|').map(x => { const i = x.indexOf(' '); return { e: x.slice(0, i), n: x.slice(i + 1) }; }) }));
  const MARKS = new RegExp('[\\u0300-\\u036f]', 'g');   /* acentos separados pelo NFD: "coração" encontra-se com "coracao" */
  const fold = s => String(s || '').toLowerCase().normalize('NFD').replace(MARKS, '');
  const RECENT_EMOJI = 'recado:emojiRecent';
  const recentEmoji = () => { const l = Store.get(RECENT_EMOJI, []); return Array.isArray(l) ? l.filter(x => typeof x === 'string' && x.length <= 16).slice(0, 24) : []; };
  const pushRecentEmoji = e => Store.update(RECENT_EMOJI, [], l => { if (!Array.isArray(l)) return; const i = l.indexOf(e); if (i > -1) l.splice(i, 1); l.unshift(e); l.length = Math.min(l.length, 24); });

  /* emojiPicker(host, onPick) → { el, destroy(), refresh() }. Sem host abre numa folha. */
  function emojiPicker(host, onPick) {
    if (!cfgP) loadCfg();
    let sheet = null;
    const panel = UI.el(`<div class="rcx-emoji"><div class="rcx-em-search">${g('search', 16)}<input type="text" placeholder="Pesquisar emoji" maxlength="30"><div class="rcx-em-clr">${g('x', 12)}</div></div>
      <div class="rcx-em-tabs"></div><div class="rcx-em-grid"></div></div>`);
    const input = panel.querySelector('input'), tabs = panel.querySelector('.rcx-em-tabs'), grid = panel.querySelector('.rcx-em-grid');
    const cell = e => { const b = UI.el('<button type="button" class="rcx-em-cell"></button>'); b.textContent = e; b.onclick = ev => { stop(ev); pushRecentEmoji(e); try { onPick && onPick(e); } catch (x) { console.error(x); } if (sheet) sheet.close(); }; return b; };
    const section = (id, title, list) => { const s = UI.el(`<div class="rcx-em-sec" data-sec="${esc(id)}"><div class="rcx-em-h">${esc(title)}</div><div class="rcx-em-cells"></div></div>`); const c = s.lastElementChild; list.forEach(e => c.appendChild(cell(e))); return s; };
    function paint() {
      grid.innerHTML = '';
      const q = fold(input.value.trim());
      panel.classList.toggle('has-q', !!q);
      if (q) {
        const hits = []; EMOJI_CATS.forEach(c => c.items.forEach(it => { if (fold(it.n).includes(q) && hits.length < 120) hits.push(it.e); }));
        if (!hits.length) grid.appendChild(UI.el(`<div class="rcx-em-none">Nenhum emoji para «${esc(input.value.trim())}»</div>`));
        else grid.appendChild(section('q', 'Resultados', hits));
        return;
      }
      const rec = recentEmoji();
      if (rec.length) grid.appendChild(section('recentes', 'Recentes', rec));
      EMOJI_CATS.forEach(c => grid.appendChild(section(c.id, c.label, c.items.map(x => x.e))));
    }
    const tabList = [{ id: 'recentes', icon: 'clock' }].concat(EMOJI_CATS.map(c => ({ id: c.id, emoji: c.icon })));
    tabList.forEach(t => {
      const b = UI.el(`<button type="button" class="rcx-em-tab" data-tab="${t.id}"></button>`);
      if (t.emoji) b.textContent = t.emoji; else b.innerHTML = g(t.icon, 18);
      b.onclick = ev => { stop(ev); if (input.value) { input.value = ''; paint(); } const sec = grid.querySelector(`[data-sec="${t.id}"]`); if (sec) grid.scrollTop = sec.offsetTop - grid.offsetTop; else if (t.id === 'recentes') grid.scrollTop = 0; tabs.querySelectorAll('.on').forEach(x => x.classList.remove('on')); b.classList.add('on'); };
      tabs.appendChild(b);
    });
    tabs.firstElementChild.classList.add('on');
    input.oninput = () => paint();
    panel.querySelector('.rcx-em-clr').onclick = ev => { stop(ev); input.value = ''; paint(); };
    /* a aba ativa acompanha o scroll (só lê offsetTop - não mexe em layout) */
    grid.addEventListener('scroll', () => { if (input.value) return; let cur = null; grid.querySelectorAll('.rcx-em-sec').forEach(s => { if (s.offsetTop - grid.offsetTop <= grid.scrollTop + 8) cur = s.dataset.sec; }); if (cur) tabs.querySelectorAll('.rcx-em-tab').forEach(x => x.classList.toggle('on', x.dataset.tab === cur)); }, { passive: true });
    panel.addEventListener('click', stop);
    paint();
    if (host && host.appendChild) host.appendChild(panel);
    else sheet = UI.sheet({ title: 'Emoji', right: 'OK', body: panel, cls: 'rcx-sheet' });
    return { el: panel, refresh: paint, destroy: () => { if (sheet) sheet.close(); else panel.remove(); } };
  }

  /* ============================================================
     STICKERS - três packs desenhados aqui (nada copiado de outras apps):
       basicos  - o "Reco", um bilhete com o canto dobrado nas cores do Recado, em 12 expressões
       cidade   - Los Santos em autocolantes planos (pôr do sol, táxi, praia, arranha-céus…)
       reacoes  - palavras curtas em letra gorda com contorno branco
     Aspeto de autocolante recortado: contorno branco (paint-order="stroke") e sombra por uma cópia
     deslocada - sem filter. Os ids de gradiente/recorte são únicos por desenho (o mesmo id repetido
     numa página deixava de pintar quando o primeiro SVG saía do DOM). A lista de ids tem de coincidir
     com STICKER_IDS no server/recado_extras.lua.
     ============================================================ */
  let seqId = 0;
  const nid = () => 'rcx' + (++seqId).toString(36);
  const svgWrap = inner => `<svg viewBox="0 0 120 120" class="rcx-svg" aria-hidden="true">${inner}</svg>`;
  const OUT = 'stroke="#fff" stroke-width="7" stroke-linejoin="round" stroke-linecap="round" paint-order="stroke"';
  const FONT = 'font-family="Inter,Segoe UI,Arial,sans-serif" font-weight="900" text-anchor="middle"';
  const HEART = 'M60 100C58 98 36 85 36 68A12 12 0 0 1 60 62A12 12 0 0 1 84 68C84 85 62 98 60 100Z';
  const heartAt = (x, y, s, fill, outline) => `<g transform="translate(${x} ${y}) scale(${s}) translate(-60 -80)"><path d="${HEART}" fill="${fill}"${outline ? ` stroke="#fff" stroke-width="${outline}" stroke-linejoin="round" paint-order="stroke"` : ''}/></g>`;

  /* --- o Reco --- */
  const RECO = 'M34 20H80L96 36V90A10 10 0 0 1 86 100H34A10 10 0 0 1 24 90V30A10 10 0 0 1 34 20Z';
  const EYES = '<ellipse cx="48" cy="57" rx="5.5" ry="7" fill="#fff"/><ellipse cx="72" cy="57" rx="5.5" ry="7" fill="#fff"/><circle cx="49" cy="58.5" r="3" fill="#0F172A"/><circle cx="73" cy="58.5" r="3" fill="#0F172A"/>';
  const HAPPY = '<path d="M42 60q6-8 12 0M66 60q6-8 12 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/>';
  const CLOSED = '<path d="M42 56q6 6 12 0M66 56q6 6 12 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/>';
  const CHEEKS = '<circle cx="36" cy="70" r="4.5" fill="#F9A8D4" opacity=".8"/><circle cx="84" cy="70" r="4.5" fill="#F9A8D4" opacity=".8"/>';
  const SMILE = '<path d="M50 71q10 10 20 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/>';
  const ARM = (d, c) => `<path d="${d}" fill="none" stroke="#fff" stroke-width="17" stroke-linecap="round"/><path d="${d}" fill="none" stroke="${c}" stroke-width="10" stroke-linecap="round"/>`;
  const LEFT = '#4257E4', RIGHT = '#2A8CDB';
  const reco = (face, back = '', front = '') => { const u = nid();
    return svgWrap(`<defs><linearGradient id="g${u}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient></defs>
      <path d="${RECO}" transform="translate(0 5)" fill="#0F172A" opacity=".16"/>${back}
      <path d="${RECO}" fill="url(#g${u})" stroke="#fff" stroke-width="7" stroke-linejoin="round" paint-order="stroke"/>
      <path d="M80 20V30A6 6 0 0 0 86 36H96Z" fill="#fff" opacity=".55"/>${face}${front}`); };

  /* --- autocolantes redondos da cidade --- */
  const badge = (bg, inner) => { const u = nid();
    return svgWrap(`<defs><clipPath id="c${u}"><circle cx="60" cy="60" r="46"/></clipPath></defs><circle cx="60" cy="65" r="47" fill="#0F172A" opacity=".14"/>
      <circle cx="60" cy="60" r="46" fill="${bg}" stroke="#fff" stroke-width="9" paint-order="stroke"/><g clip-path="url(#c${u})">${inner}</g><circle cx="60" cy="60" r="46" fill="none" stroke="#fff" stroke-width="4"/>`); };
  const palm = c => `<path d="M30 112Q34 82 26 56" stroke="${c}" stroke-width="5" fill="none" stroke-linecap="round"/><path d="M26 56q-14-4-22 6M26 56q-12-12-24-8M26 56q2-14 16-18M26 56q14-6 22 4M26 56q10 4 10 16" stroke="${c}" stroke-width="5" fill="none" stroke-linecap="round"/>`;
  const windows = (x, y, cols, rows, dx, dy) => { let s = ''; for (let i = 0; i < cols; i++) for (let j = 0; j < rows; j++) if ((i * 7 + j * 3) % 4) s += `<rect x="${x + i * dx}" y="${y + j * dy}" width="4" height="5" rx="1" fill="#FDE68A"/>`; return s; };
  const wheel = () => { let s = '<path d="M60 58L36 104M60 58L84 104" stroke="#334155" stroke-width="5" stroke-linecap="round"/><circle cx="60" cy="58" r="30" fill="none" stroke="#128C7E" stroke-width="5"/>';
    const cols = ['#F43F5E', '#25D366', '#F59E0B', '#22C55E'];
    for (let k = 0; k < 8; k++) { const a = k * Math.PI / 4, x = (60 + Math.cos(a) * 30).toFixed(1), y = (58 + Math.sin(a) * 30).toFixed(1);
      s += `<path d="M60 58L${x} ${y}" stroke="#22C55E" stroke-width="2.5"/><rect x="${(+x - 5).toFixed(1)}" y="${(+y - 2).toFixed(1)}" width="10" height="9" rx="3" fill="${cols[k % 4]}" stroke="#fff" stroke-width="2" paint-order="stroke"/>`; }
    return s + '<circle cx="60" cy="58" r="5" fill="#25D366" stroke="#fff" stroke-width="2"/>'; };

  /* --- palavras --- */
  const word = (lines, fill, rot, extra = '') => {
    const txt = attrs => lines.map(([t, y, s]) => `<text x="60" y="${y}" font-size="${s}" ${FONT} ${attrs}>${t}</text>`).join('');
    return svgWrap(`<g transform="rotate(${rot} 60 60)">${extra}<g transform="translate(0 4)">${txt('fill="#0F172A" opacity=".16" stroke="#0F172A" stroke-width="12" stroke-linejoin="round"')}</g>${txt(`fill="${fill}" stroke="#fff" stroke-width="12" stroke-linejoin="round" paint-order="stroke"`)}</g>`);
  };

  const STICKERS = {
    basicos: { name: 'Básicos', items: [
      { id: 'ola', name: 'Olá', emoji: '👋', svg: () => reco(EYES + CHEEKS + '<path d="M48 70q12 13 24 0z" fill="#0F172A"/>',
        ARM('M26 72Q16 80 18 90', LEFT) + ARM('M94 64Q108 58 106 40', RIGHT), `<circle cx="106" cy="38" r="8" fill="${RIGHT}" stroke="#fff" stroke-width="5" paint-order="stroke"/><path d="M112 22l5-6M116 32l4-1" stroke="#22C55E" stroke-width="4" stroke-linecap="round"/>`) },
      { id: 'obrigado', name: 'Obrigado', emoji: '🙏', svg: () => reco(HAPPY + CHEEKS + '<path d="M54 71q6 5 12 0" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round"/>', '',
        ARM('M28 70Q34 86 48 88', LEFT) + ARM('M92 70Q86 86 72 88', RIGHT) + heartAt(60, 88, .52, '#F43F5E', 12)) },
      { id: 'ok', name: 'OK', emoji: '👍', svg: () => reco('<ellipse cx="48" cy="57" rx="5.5" ry="7" fill="#fff"/><circle cx="49" cy="58.5" r="3" fill="#0F172A"/><path d="M66 58q6-6 12 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/>' + CHEEKS + SMILE, '',
        '<g transform="translate(84 64) rotate(-8)"><rect x="3" y="-12" width="11" height="28" rx="5.5" fill="#FBBF24" stroke="#fff" stroke-width="6" paint-order="stroke"/><rect x="0" y="10" width="26" height="22" rx="7" fill="#FBBF24" stroke="#fff" stroke-width="6" paint-order="stroke"/><path d="M6 18h15M6 25h15" stroke="#D97706" stroke-width="2.5" stroke-linecap="round"/></g>') },
      { id: 'riso', name: 'A rir', emoji: '😂', svg: () => reco(HAPPY + '<path d="M45 68h30a15 15 0 0 1-30 0z" fill="#0F172A"/><path d="M53 81q7-7 14 0z" fill="#FB7185"/>' +
        '<path d="M34 58q-6 8 0 12q6-4 0-12z" fill="#38BDF8" stroke="#fff" stroke-width="3" paint-order="stroke"/><path d="M86 58q-6 8 0 12q6-4 0-12z" fill="#38BDF8" stroke="#fff" stroke-width="3" paint-order="stroke"/>', '',
        '<path d="M8 50l8 3M6 64h9M112 50l-8 3M114 64h-9" stroke="#22C55E" stroke-width="4" stroke-linecap="round"/>') },
      { id: 'triste', name: 'Triste', emoji: '😢', svg: () => reco(EYES + '<path d="M41 48l12-5M79 48l-12-5" stroke="#fff" stroke-width="4" stroke-linecap="round"/><path d="M50 81q10-9 20 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/><path d="M46 67q-5 8 0 12q5-4 0-12z" fill="#7DD3FC" stroke="#fff" stroke-width="2.5" paint-order="stroke"/>') },
      { id: 'uau', name: 'Uau', emoji: '😮', svg: () => reco('<circle cx="47" cy="56" r="8" fill="#fff"/><circle cx="73" cy="56" r="8" fill="#fff"/><circle cx="47" cy="57" r="4" fill="#0F172A"/><circle cx="73" cy="57" r="4" fill="#0F172A"/><ellipse cx="60" cy="80" rx="6" ry="8" fill="#0F172A"/>', '',
        '<path d="M8 32l9 4M14 16l6 9M28 6l2 10" stroke="#F59E0B" stroke-width="4.5" stroke-linecap="round"/>') },
      { id: 'amor', name: 'Amor', emoji: '😍', svg: () => reco(heartAt(48, 60, .3, '#F43F5E') + heartAt(72, 60, .3, '#F43F5E') + CHEEKS + SMILE, '',
        heartAt(106, 24, .34, '#F43F5E', 12) + heartAt(14, 36, .24, '#FB7185', 14)) },
      { id: 'dormir', name: 'A dormir', emoji: '😴', svg: () => reco(CLOSED + '<ellipse cx="60" cy="76" rx="4" ry="3.2" fill="#0F172A"/>', '',
        `<text x="100" y="32" font-size="22" ${FONT} fill="#22C55E" stroke="#fff" stroke-width="6" stroke-linejoin="round" paint-order="stroke">Z</text><text x="112" y="14" font-size="14" ${FONT} fill="#4ADE80" stroke="#fff" stroke-width="5" stroke-linejoin="round" paint-order="stroke">z</text>`) },
      { id: 'festa', name: 'Festa', emoji: '🥳', svg: () => reco(HAPPY + CHEEKS + '<path d="M48 70q12 13 24 0z" fill="#0F172A"/>', '',
        '<path d="M34 28L47 4L62 26Z" fill="#F59E0B" stroke="#fff" stroke-width="6" stroke-linejoin="round" paint-order="stroke"/><path d="M40 18l14 3M44 11l8 2" stroke="#EF4444" stroke-width="3" stroke-linecap="round"/><circle cx="47" cy="6" r="4.5" fill="#F43F5E" stroke="#fff" stroke-width="2.5" paint-order="stroke"/>' +
        '<rect x="102" y="50" width="8" height="4" rx="1" fill="#F43F5E" transform="rotate(30 106 52)"/><rect x="8" y="46" width="8" height="4" rx="1" fill="#22C55E" transform="rotate(-25 12 48)"/><rect x="104" y="80" width="7" height="4" rx="1" fill="#F59E0B" transform="rotate(-40 107 82)"/><circle cx="12" cy="86" r="3" fill="#25D366"/><circle cx="104" cy="12" r="3" fill="#A855F7"/>') },
      { id: 'pensar', name: 'A pensar', emoji: '🤔', svg: () => reco('<ellipse cx="48" cy="57" rx="5.5" ry="7" fill="#fff"/><ellipse cx="72" cy="57" rx="5.5" ry="7" fill="#fff"/><circle cx="51" cy="54" r="3" fill="#0F172A"/><circle cx="75" cy="54" r="3" fill="#0F172A"/><path d="M41 45l12 2" stroke="#fff" stroke-width="4" stroke-linecap="round"/><path d="M52 78l16-4" stroke="#fff" stroke-width="4.5" stroke-linecap="round"/>', '',
        ARM('M92 76Q82 94 72 90', RIGHT) + `<circle cx="72" cy="90" r="7" fill="${RIGHT}" stroke="#fff" stroke-width="5" paint-order="stroke"/><text x="106" y="30" font-size="30" ${FONT} fill="#22C55E" stroke="#fff" stroke-width="7" stroke-linejoin="round" paint-order="stroke">?</text>`) },
      { id: 'zangado', name: 'Zangado', emoji: '😠', svg: () => reco(EYES + '<path d="M40 45l14 7M80 45l-14 7" stroke="#0F172A" stroke-width="5" stroke-linecap="round"/><path d="M50 81q10-8 20 0" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/><circle cx="36" cy="70" r="5" fill="#F87171" opacity=".8"/><circle cx="84" cy="70" r="5" fill="#F87171" opacity=".8"/>', '',
        '<path d="M102 8v8h-8M112 8v8h8M102 28v-8h-8M112 28v-8h8" stroke="#EF4444" stroke-width="4" fill="none" stroke-linecap="round" stroke-linejoin="round"/>') },
      { id: 'fixe', name: 'Fixe', emoji: '😎', svg: () => reco('<path d="M34 50h52v5c0 8-5 13-12 13s-11-5-12-10h-4c-1 5-5 10-12 10s-12-5-12-13z" fill="#0F172A"/><path d="M40 55l7-2.5M67 55l7-2.5" stroke="#fff" stroke-width="2.5" stroke-linecap="round" opacity=".85"/><path d="M52 77q10 6 18-3" stroke="#fff" stroke-width="4.5" fill="none" stroke-linecap="round"/>') }
    ] },
    cidade: { name: 'Cidade', items: [
      { id: 'por_do_sol', name: 'Pôr do sol', emoji: '🌅', svg: () => badge('#FB923C', '<rect width="120" height="34" fill="#8B5CF6"/><rect y="34" width="120" height="20" fill="#EC4899"/><circle cx="60" cy="76" r="21" fill="#FDE68A"/><rect y="76" width="120" height="50" fill="#1E3A8A"/><path d="M40 84h40M48 92h24M54 100h12" stroke="#FDE68A" stroke-width="3" stroke-linecap="round" opacity=".85"/>' + palm('#2E1065') + `<g transform="translate(122 18) scale(-.8 .8)">${palm('#2E1065')}</g>`) },
      { id: 'palmeira', name: 'Palmeira', emoji: '🌴', svg: () => badge('#BAE6FD', '<circle cx="88" cy="34" r="12" fill="#FDE047"/><ellipse cx="60" cy="114" rx="64" ry="22" fill="#FCD34D"/><path d="M58 106Q64 78 54 48" stroke="#92400E" stroke-width="8" fill="none" stroke-linecap="round"/><path d="M56 96h8M58 84h8M57 72h8M55 60h7" stroke="#78350F" stroke-width="2.5" stroke-linecap="round"/>' +
        '<path d="M54 48Q36 30 18 38Q38 38 54 50Z" fill="#16A34A"/><path d="M54 48Q52 26 36 16Q48 32 52 50Z" fill="#15803D"/><path d="M54 48Q70 28 92 32Q70 38 56 50Z" fill="#16A34A"/><path d="M54 48Q78 46 94 62Q74 52 55 51Z" fill="#22C55E"/><path d="M54 48Q38 54 30 72Q44 56 55 51Z" fill="#22C55E"/><circle cx="52" cy="54" r="4" fill="#78350F"/><circle cx="59" cy="55" r="4" fill="#78350F"/>') },
      { id: 'taxi', name: 'Táxi', emoji: '🚕', svg: () => badge('#FEF3C7', `<rect y="90" width="120" height="30" fill="#CBD5E1"/><path d="M8 104h20M46 104h20M84 104h20" stroke="#fff" stroke-width="3"/><path d="M16 86V74q0-6 6-7l13-2 10-13q3-3 8-3h22q5 0 8 4l10 12 10 2q6 1 6 7v12z" fill="#FACC15"/><path d="M41 64l9-11h12v11z" fill="#BAE6FD"/><path d="M66 53h10l9 11H66z" fill="#BAE6FD"/><path d="M18 76h86" stroke="#0F172A" stroke-width="4" stroke-dasharray="4 4"/><rect x="50" y="38" width="22" height="9" rx="2.5" fill="#0F172A"/><text x="61" y="45.5" font-size="7" ${FONT} fill="#FACC15">TAXI</text><circle cx="36" cy="88" r="9" fill="#111827"/><circle cx="36" cy="88" r="4" fill="#9CA3AF"/><circle cx="88" cy="88" r="9" fill="#111827"/><circle cx="88" cy="88" r="4" fill="#9CA3AF"/>`) },
      { id: 'praia', name: 'Praia', emoji: '🌊', svg: () => badge('#E0F2FE', '<circle cx="28" cy="32" r="10" fill="#FDE047"/><path d="M-2 94Q16 42 64 46Q98 50 102 80Q90 62 72 64Q56 66 60 84Q44 74 30 88Q14 100 -2 106Z" fill="#0284C7"/><path d="M102 80Q90 62 72 64Q58 66 60 82" stroke="#fff" stroke-width="5" fill="none" stroke-linecap="round"/><rect y="96" width="120" height="30" fill="#38BDF8"/><path d="M10 102q8-5 16 0t16 0t16 0t16 0t16 0t16 0" stroke="#fff" stroke-width="3" fill="none"/>') },
      { id: 'skyline', name: 'Arranha-céus', emoji: '🌃', svg: () => badge('#1E1B4B', '<circle cx="86" cy="30" r="10" fill="#FDE68A"/><circle cx="91" cy="26" r="9" fill="#1E1B4B"/><circle cx="30" cy="26" r="1.8" fill="#fff"/><circle cx="48" cy="18" r="1.4" fill="#fff"/><circle cx="66" cy="30" r="1.4" fill="#fff"/>' +
        '<rect x="12" y="62" width="18" height="60" fill="#0B7A6B"/><rect x="32" y="42" width="20" height="80" fill="#22C55E"/><rect x="54" y="54" width="16" height="68" fill="#128C7E"/><rect x="72" y="38" width="18" height="84" fill="#065F46"/><path d="M81 38V26" stroke="#065F46" stroke-width="3"/><rect x="92" y="66" width="18" height="56" fill="#0B7A6B"/>' +
        windows(15, 68, 2, 5, 7, 8) + windows(35, 48, 3, 7, 6, 8) + windows(57, 60, 2, 6, 7, 8) + windows(75, 44, 2, 8, 8, 8) + windows(95, 72, 2, 4, 7, 8) + '<rect y="104" width="120" height="16" fill="#075E54"/><path d="M14 110h20M44 112h26M82 110h22" stroke="#67E8F9" stroke-width="2" opacity=".6"/>') },
      { id: 'sirene', name: 'Sirene', emoji: '🚨', svg: () => badge('#F1F5F9', '<path d="M60 14v12M28 26l8 9M92 26l-8 9M14 54h12M94 54h12" stroke="#F59E0B" stroke-width="5" stroke-linecap="round"/><path d="M36 84V66a24 24 0 0 1 24-24V84z" fill="#EF4444"/><path d="M60 42a24 24 0 0 1 24 24v18H60z" fill="#3B82F6"/><path d="M44 66a16 16 0 0 1 10-14" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round" opacity=".7"/><rect x="26" y="82" width="68" height="15" rx="4" fill="#334155"/>') },
      { id: 'hamburguer', name: 'Hambúrguer', emoji: '🍔', svg: () => svgWrap('<ellipse cx="60" cy="108" rx="40" ry="6" fill="#0F172A" opacity=".14"/>' +
        `<path d="M20 88h80v4q0 10-10 10H30q-10 0-10-10z" fill="#F59E0B" ${OUT}/><rect x="17" y="72" width="86" height="15" rx="7.5" fill="#7C2D12" ${OUT}/><path d="M18 68h84l-9 10-8-6-10 8-10-8-10 8-10-8-10 8-8-6z" fill="#FACC15"/>` +
        `<path d="M16 62q6 8 12 0t12 0t12 0t12 0t12 0t12 0t12 0v6H16z" fill="#22C55E" ${OUT}/><path d="M20 60q0-36 40-36t40 36z" fill="#F59E0B" ${OUT}/><ellipse cx="44" cy="40" rx="3" ry="1.8" fill="#FEF3C7" transform="rotate(-20 44 40)"/><ellipse cx="60" cy="34" rx="3" ry="1.8" fill="#FEF3C7"/><ellipse cx="76" cy="41" rx="3" ry="1.8" fill="#FEF3C7" transform="rotate(20 76 41)"/><ellipse cx="54" cy="48" rx="3" ry="1.8" fill="#FEF3C7"/><ellipse cx="68" cy="50" rx="3" ry="1.8" fill="#FEF3C7" transform="rotate(15 68 50)"/>`) },
      { id: 'cafe', name: 'Café', emoji: '☕', svg: () => svgWrap('<ellipse cx="60" cy="112" rx="28" ry="5" fill="#0F172A" opacity=".14"/><path d="M46 30q-6-8 0-14t0-14M60 30q-6-8 0-14t0-14M74 30q-6-8 0-14t0-14" stroke="#94A3B8" stroke-width="4" fill="none" stroke-linecap="round"/>' +
        `<path d="M32 46h56l-7 58q-1 6-7 6H46q-6 0-7-6z" fill="#F8FAFC" ${OUT}/><rect x="27" y="34" width="66" height="13" rx="6.5" fill="#E2E8F0" ${OUT}/><path d="M35.5 62h49l-2.6 24H38.1z" fill="#128C7E"/><path d="M53 67h10l4 4v10H53z" fill="#fff" opacity=".92"/><path d="M63 67v4h4" fill="#25D366"/>`) },
      { id: 'dinheiro', name: 'Dinheiro', emoji: '💸', svg: () => svgWrap(`<g transform="rotate(10 60 60)"><rect x="22" y="36" width="80" height="42" rx="6" fill="#15803D" ${OUT}/></g><g transform="rotate(-12 60 60)"><rect x="18" y="44" width="84" height="44" rx="6" fill="#16A34A" ${OUT}/><rect x="26" y="52" width="68" height="28" rx="4" fill="none" stroke="#86EFAC" stroke-width="2.5"/><circle cx="60" cy="66" r="10" fill="#86EFAC"/><text x="60" y="71.5" font-size="15" ${FONT} fill="#14532D">$</text></g><path d="M100 26l10-6M104 40l12-2M14 96l-8 6" stroke="#22C55E" stroke-width="4" stroke-linecap="round"/>`) },
      { id: 'roda_gigante', name: 'Roda gigante', emoji: '🎡', svg: () => badge('#FECDD3', '<rect y="100" width="120" height="22" fill="#FDA4AF"/>' + wheel()) },
      { id: 'semaforo', name: 'Semáforo', emoji: '🚦', svg: () => svgWrap(`<rect x="38" y="13" width="48" height="94" rx="14" fill="#0F172A" opacity=".14"/><rect x="54" y="92" width="12" height="24" rx="3" fill="#334155" ${OUT}/><rect x="36" y="8" width="48" height="90" rx="14" fill="#1F2937" ${OUT}/><circle cx="60" cy="30" r="10" fill="#7F1D1D"/><circle cx="60" cy="53" r="10" fill="#78350F"/><circle cx="60" cy="76" r="15" fill="#22C55E" opacity=".25"/><circle cx="60" cy="76" r="10" fill="#22C55E"/><circle cx="56" cy="72" r="3" fill="#fff" opacity=".75"/>`) },
      { id: 'los_santos', name: 'Los Santos', emoji: '🌇', svg: () => { const u = nid(); return svgWrap(`<defs><linearGradient id="g${u}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#128C7E"/><stop offset="1" stop-color="#25D366"/></linearGradient></defs><g transform="rotate(-8 60 60)"><rect x="10" y="43" width="100" height="44" rx="12" fill="#0F172A" opacity=".14"/><rect x="10" y="38" width="100" height="44" rx="12" fill="url(#g${u})" stroke="#fff" stroke-width="8" paint-order="stroke"/><text x="60" y="57" font-size="14" ${FONT} fill="#fff" letter-spacing="3">LOS</text><text x="60" y="77" font-size="20" ${FONT} fill="#fff">SANTOS</text><path d="M100 26l3 7 7 1-5 5 1 7-6-3-6 3 1-7-5-5 7-1z" fill="#FDE047" ${OUT}/></g>`); } }
    ] },
    reacoes: { name: 'Reações', items: [
      { id: 'boa', name: 'Boa!', emoji: '🙌', svg: () => word([['BOA!', 74, 40]], '#16A34A', -8) },
      { id: 'lol', name: 'LOL', emoji: '😆', svg: () => word([['LOL', 76, 48]], '#F59E0B', 6) },
      { id: 'nao', name: 'Não', emoji: '🙅', svg: () => word([['NÃO', 76, 44]], '#DC2626', -5) },
      { id: 'sim', name: 'Sim!', emoji: '👌', svg: () => word([['SIM!', 76, 44]], '#128C7E', -6) },
      { id: 'ups', name: 'Ups', emoji: '🙊', svg: () => word([['UPS…', 74, 38]], '#F97316', 8) },
      { id: 'top', name: 'Top', emoji: '⭐', svg: () => word([['TOP', 73, 32]], '#0F9D6B', 0, '<path d="M60 8l13 27 29 4-21 20 5 29-26-14-26 14 5-29-21-20 29-4z" fill="#FDE68A" stroke="#fff" stroke-width="7" stroke-linejoin="round" paint-order="stroke"/>') },
      { id: 'obrigado', name: 'Obrigado', emoji: '💖', svg: () => word([['OBG!', 76, 42]], '#DB2777', -6, heartAt(98, 34, .34, '#F43F5E', 14)) },
      { id: 'ja_volto', name: 'Já volto', emoji: '⏳', svg: () => word([['JÁ', 54, 34], ['VOLTO', 88, 30]], '#475569', 4) },
      { id: 'fogo', name: 'Fogo', emoji: '🔥', svg: () => word([['FOGO', 110, 24]], '#DC2626', 0, '<path d="M60 6C66 24 88 34 88 62A28 28 0 0 1 32 62C32 44 44 38 46 24C52 34 54 40 58 42C62 32 58 20 60 6Z" fill="#F97316" stroke="#fff" stroke-width="7" stroke-linejoin="round" paint-order="stroke"/><path d="M60 38C64 50 76 56 76 70A16 16 0 0 1 44 70C44 60 52 56 54 48C57 54 60 54 60 38Z" fill="#FDE047"/>') },
      { id: 'mais_um', name: '+1', emoji: '➕', svg: () => word([['+1', 82, 64]], '#128C7E', -6) },
      { id: 'hein', name: '?!', emoji: '❓', svg: () => word([['?!', 84, 66]], '#7C3AED', 8) },
      { id: 'coracao', name: 'Coração', emoji: '❤️', svg: () => svgWrap(`<g transform="translate(60 68) scale(1.8) translate(-60 -78)"><path d="${HEART}" fill="#0F172A" opacity=".14" transform="translate(0 2.5)"/><path d="${HEART}" fill="#F43F5E" stroke="#fff" stroke-width="4.5" stroke-linejoin="round" paint-order="stroke"/><path d="M43 70a9 9 0 0 1 8-8" stroke="#fff" stroke-width="3" fill="none" stroke-linecap="round" opacity=".75"/></g>`) }
    ] }
  };
  const stickerPacks = () => { const allowed = CFG.stickers && CFG.stickers.length ? CFG.stickers : Object.keys(STICKERS); return Object.keys(STICKERS).filter(k => allowed.includes(k)).map(k => ({ id: k, name: STICKERS[k].name, items: STICKERS[k].items.map(x => ({ id: x.id, name: x.name, emoji: x.emoji })) })); };
  const findSticker = (pack, id) => { const p = STICKERS[pack]; return p ? p.items.find(x => x.id === id) || null : null; };
  /* elemento do sticker (serve também ao RE, para status com sticker) */
  function stickerEl(pack, id) {
    const s = findSticker(pack, id);
    const el = UI.el(`<div class="rcx-sticker" role="img"></div>`);
    if (!s) { el.classList.add('missing'); el.innerHTML = `<span>${g('smile', 28)}</span>`; el.title = 'Sticker indisponível'; return el; }
    el.innerHTML = s.svg(); el.title = s.name; el.setAttribute('aria-label', 'Sticker: ' + s.name);
    return el;
  }
  const RECENT_ST = 'recado:stickerRecent';
  const recentStickers = () => { const l = Store.get(RECENT_ST, []); return (Array.isArray(l) ? l : []).filter(x => x && findSticker(x.pack, x.id)).slice(0, 12); };

  /* stickerPicker(win, onPick) - folha com os packs; onPick({ pack, id }) */
  function stickerPicker(win, onPick) {
    loadCfg();
    const body = UI.el('<div class="rcx-stp"><div class="rcx-stp-tabs"></div><div class="rcx-stp-grid"></div><div class="rcx-foot-note">Stickers desenhados para o Zapp · funcionam sempre, sem internet.</div></div>');
    const tabsEl = body.querySelector('.rcx-stp-tabs'), grid = body.querySelector('.rcx-stp-grid');
    const packs = stickerPacks(); const rec = recentStickers();
    const tabs = (rec.length ? [{ id: '_rec', name: 'Recentes' }] : []).concat(packs.map(p => ({ id: p.id, name: p.name })));
    let cur = tabs[0] ? tabs[0].id : null;
    /* fechar sem escolher chama onPick(null): quem espera numa Promise (Atualizações do RE) não fica pendurado */
    let picked = false;
    const sh = UI.sheet({ title: 'Stickers', right: 'Fechar', body, cls: 'rcx-sheet', onClose: () => { if (picked) return; picked = true; try { onPick && onPick(null); } catch (x) { console.error(x); } } });
    function paint() {
      tabsEl.querySelectorAll('.rcx-pill').forEach(x => x.classList.toggle('on', x.dataset.id === cur));
      grid.innerHTML = '';
      const list = cur === '_rec' ? recentStickers() : (STICKERS[cur] ? STICKERS[cur].items.map(x => ({ pack: cur, id: x.id })) : []);
      list.forEach(it => {
        const b = UI.el('<button type="button" class="rcx-stp-cell"></button>'); const s = findSticker(it.pack, it.id);
        b.appendChild(stickerEl(it.pack, it.id)); b.appendChild(UI.el(`<span>${esc(s ? s.name : '')}</span>`));
        b.onclick = ev => { stop(ev); Store.update(RECENT_ST, [], l => { if (!Array.isArray(l)) return; const i = l.findIndex(x => x && x.pack === it.pack && x.id === it.id); if (i > -1) l.splice(i, 1); l.unshift({ pack: it.pack, id: it.id }); l.length = Math.min(l.length, 12); });
          picked = true; sh.close(); try { onPick && onPick({ pack: it.pack, id: it.id }); } catch (x) { console.error(x); } };
        grid.appendChild(b);
      });
    }
    tabs.forEach(t => { const p = UI.el(`<button type="button" class="rcx-pill" data-id="${esc(t.id)}">${esc(t.name)}</button>`); p.onclick = ev => { stop(ev); cur = t.id; paint(); }; tabsEl.appendChild(p); });
    paint();
    return sh;
  }

  /* ============================================================
     GIF - pesquisa no SERVIDOR (recado.gif.search; a chave nunca chega aqui). Só se aceitam URLs https do
     fornecedor: um URL qualquer numa mensagem era um "pixel" que dava o IP de cada leitor a terceiros.
     No browser (mock) aceitam-se também SVG em data: gerados pelo próprio mock.
     ============================================================ */
  function safeGif(u) {
    if (typeof u !== 'string') return null;
    if (!Bridge.inFiveM && u.length < 4000 && /^data:image\/svg\+xml;charset=utf-8,[^"'<>\s]*$/.test(u)) return u;
    if (u.length > 400) return null;
    const m = /^https:\/\/([a-z0-9.-]+)(\/[A-Za-z0-9\-._~/%]+)$/i.exec(u);
    if (m && !m[2].includes('..') && (m[1].toLowerCase() === 'media.tenor.com' || /^[a-z0-9-]+\.tenor\.com$/i.test(m[1]))) return u;
    return null;
  }
  function gifTile(it, big) {
    const w = Math.max(1, int(it.w) || 1), h = Math.max(1, int(it.h) || 1);
    const box = UI.el(`<div class="rcx-gif${big ? ' big' : ''}"><div class="rcx-gif-ph"></div><img alt="" decoding="async" draggable="false"><span class="rcx-gif-tag">GIF</span></div>`);
    box.style.setProperty('--ar', (w / h).toFixed(4));
    const img = box.querySelector('img');
    const src = safeGif(big ? it.url : (it.preview || it.url));
    img.onload = () => box.classList.add('ok');
    img.onerror = () => box.classList.add('fail');
    if (src) img.src = src; else box.classList.add('fail');
    return box;
  }
  function gifPicker(win, onPick) {
    const body = UI.el('<div class="rcx-gifp"></div>');
    let picked = false;   /* como no stickerPicker: fechar sem escolher = onPick(null) */
    const sh = UI.sheet({ title: 'GIF', right: 'Fechar', body, cls: 'rcx-sheet rcx-sheet-tall', onClose: () => { if (picked) return; picked = true; try { onPick && onPick(null); } catch (x) { console.error(x); } } });
    const off = () => {
      body.innerHTML = `<div class="rcx-off"><div class="rcx-off-ic">${g('film', 34)}</div><b>Os GIF não estão ativos</b>
        <p>Neste servidor não há um fornecedor de GIF configurado. Os GIF precisam de um serviço externo e de uma chave que fica só no servidor.</p>
        <div class="rcx-off-how"><div><i>1</i><span>No <code>config_recado.lua</code> muda <code>gif.provider</code> para <code>'tenor'</code>.</span></div><div><i>2</i><span>No <code>server.cfg</code> acrescenta <code>set recado_gif_key "a tua chave"</code>.</span></div><div><i>3</i><span>Reinicia o recurso <code>apex_phone</code>.</span></div></div>
        <p class="rcx-muted">Enquanto isso, os stickers do Zapp funcionam sempre.</p></div>`;
    };
    loadCfg().then(cfg => {
      if (!cfg.gif.enabled) { off(); return; }
      body.innerHTML = `<div class="rcx-gif-search">${g('search', 16)}<input type="text" maxlength="60" placeholder="Pesquisar GIF"></div><div class="rcx-gif-grid"><div class="rcx-col"></div><div class="rcx-col"></div></div><div class="rcx-foot-note">GIF fornecidos pelo serviço configurado no servidor.</div>`;
      const input = body.querySelector('input'), cols = body.querySelectorAll('.rcx-col'), grid = body.querySelector('.rcx-gif-grid');
      let seq = 0, t = null;
      const run = async () => {
        const my = ++seq; const q = input.value.trim();
        cols.forEach(c => { c.innerHTML = ''; }); grid.classList.add('loading');
        const r = await Bridge.rpcRaw('recado.gif.search', { q });
        if (my !== seq || !body.isConnected) return;
        grid.classList.remove('loading');
        if (failed(r)) { if (r && r.error === 'nogif') { off(); return; } cols[0].appendChild(UI.el(`<div class="rcx-muted rcx-pad">${esc(errText(codeOf(r)))}</div>`)); return; }
        const items = arr(r.items).filter(it => it && safeGif(it.url));
        if (!items.length) { cols[0].appendChild(UI.el(`<div class="rcx-muted rcx-pad">Sem resultados${q ? ' para «' + esc(q) + '»' : ''}.</div>`)); return; }
        const hgt = [0, 0];
        items.forEach(it => { const k = hgt[0] <= hgt[1] ? 0 : 1; hgt[k] += (int(it.h) || 1) / (int(it.w) || 1);
          const tile = gifTile(it, false); tile.classList.add('pick');
          tile.onclick = ev => { stop(ev); picked = true; sh.close(); try { onPick && onPick({ url: it.url, preview: it.preview || it.url, w: int(it.w), h: int(it.h) }); } catch (x) { console.error(x); } };
          cols[k].appendChild(tile); });
      };
      input.oninput = () => { clearTimeout(t); t = setTimeout(run, 450); };
      input.onkeydown = e => { if (e.key === 'Enter') { clearTimeout(t); run(); } };
      run();
    });
    return sh;
  }

  /* ============================================================
     Utilitários das folhas de criação
     ============================================================ */
  const targetArgs = t => { t = t || {}; const conv = int(t.conversation || (t.group && t.group.id)); if (conv > 0) return { conversation: conv }; const m = /^g:(\d+)$/.exec(String(t.number || '')); if (m) return { conversation: int(m[1]) }; return { number: String(t.number || '') }; };
  /* folha com cabeçalho Cancelar / título / Enviar; o botão fica "desligado" enquanto o formulário não é válido */
  function composeSheet(title, body, onSend) {
    return new Promise(resolve => {
      let busy = false, settled = false;
      const done = v => { if (settled) return; settled = true; resolve(v); };
      const sh = UI.sheet({ title, left: 'Cancelar', right: 'Enviar', body, cls: 'rcx-sheet rcx-sheet-tall', onClose: () => done(null),
        onDone: () => { if (busy) return false; const btn = sh.el.querySelector('.sh-r');
          if (btn.classList.contains('rcx-dis')) { const why = body.__why && body.__why(); if (why) UI.toast(why); return false; }
          busy = true; btn.textContent = 'A enviar…';
          Promise.resolve().then(onSend).then(r => {
            busy = false; btn.textContent = 'Enviar';
            if (failed(r)) { UI.toast(errText(codeOf(r)), 2400); return; }
            done(r); sh.close();
          }, e => { busy = false; btn.textContent = 'Enviar'; console.error('[recado-extras]', e); UI.toast(errText('internal')); });
          return false; } });
      body.__sheet = sh;
      body.__setValid = ok => { const b = sh.el.querySelector('.sh-r'); if (b) b.classList.toggle('rcx-dis', !ok); };
      if (body.__validate) body.__validate();
    });
  }
  const field = (label, html) => UI.el(`<div class="rcx-field"><div class="rcx-field-l">${esc(label)}</div>${html}</div>`);

  /* ============================================================
     SONDAGENS
     ============================================================ */
  function pollComposer(win, target) {
    const max = () => CFG.polls.maxOptions;
    const body = UI.el(`<div class="rcx-form">
      <div class="rcx-hero"><div class="rcx-hero-ic">${g('chart', 26)}</div><div><b>Nova sondagem</b><span>Faz uma pergunta e deixa o grupo votar.</span></div></div>
      <div class="rcx-card-in"><textarea class="rcx-q" rows="2" maxlength="300" placeholder="Pergunta"></textarea></div>
      <div class="rcx-sec-h"><span>Opções</span><span class="rcx-count"></span></div>
      <div class="rcx-card-in rcx-optlist"></div>
      <div class="rcx-card-in rcx-toggles"></div>
      <div class="rcx-foot-note">Quem vota pode mudar o voto a qualquer momento. Os resultados atualizam-se em tempo real.</div></div>`);
    const q = body.querySelector('.rcx-q'), list = body.querySelector('.rcx-optlist'), count = body.querySelector('.rcx-count'), tg = body.querySelector('.rcx-toggles');
    const state = { multi: false, showVoters: false };
    const rows = () => [...list.querySelectorAll('.rcx-opt-in input')];
    function addRow(value) {
      if (rows().length >= max()) return null;
      const r = UI.el(`<div class="rcx-opt-in"><span class="rcx-dot"></span><input type="text" maxlength="100" placeholder="Opção ${rows().length + 1}"><button type="button" class="rcx-x" aria-label="Remover">${g('x', 12)}</button></div>`);
      const inp = r.querySelector('input'); inp.value = value || '';
      inp.oninput = () => { const all = rows(); if (inp === all[all.length - 1] && inp.value.trim() && all.length < max()) addRow(''); validate(); };
      r.querySelector('.rcx-x').onclick = ev => { stop(ev); if (rows().length <= 2) { inp.value = ''; validate(); return; } r.remove(); renumber(); validate(); };
      list.appendChild(r); renumber(); return inp;
    }
    const renumber = () => rows().forEach((x, i) => { x.placeholder = 'Opção ' + (i + 1); });
    const values = () => rows().map(x => x.value.trim()).filter(Boolean);
    function why() {
      if (!q.value.trim()) return 'Escreve a pergunta.';
      const v = values(); if (v.length < 2) return 'Precisas de pelo menos 2 opções.';
      const low = v.map(x => x.toLowerCase()); if (new Set(low).size !== low.length) return 'Há opções repetidas.';
      return '';
    }
    function validate() { count.textContent = `${values().length} / ${max()}`; if (body.__setValid) body.__setValid(!why()); }
    body.__why = why; body.__validate = validate;
    [['multi', 'Permitir várias respostas', 'list'], ['showVoters', 'Mostrar quem votou', 'eye']].forEach(([k, label, ic]) => {
      const row = UI.el(`<div class="rcx-trow"><span class="rcx-tic">${g(ic, 17)}</span><span class="rcx-tl">${esc(label)}</span></div>`);
      row.appendChild(UI.toggle(state[k], on => { state[k] = on; })); tg.appendChild(row);
    });
    q.oninput = validate;
    addRow(''); addRow('');
    loadCfg().then(validate);
    const p = composeSheet('Sondagem', body, () => Bridge.rpcRaw('recado.poll.create', Object.assign(targetArgs(target), { question: q.value.trim(), options: values(), multi: state.multi, showVoters: state.showVoters })));
    setTimeout(() => { try { q.focus(); } catch (e) {} }, 420);
    return p;
  }

  /* cache e cartões vivos: o push recadoPoll atualiza todas as bolhas dessa sondagem que estejam no ecrã */
  const pollCache = new Map(), pollLive = new Map(), pollInflight = new Map();
  function fetchPoll(id, force) {
    const c = pollCache.get(id);
    if (!force && c && Date.now() - c.t < 30000) return Promise.resolve(c.data);
    if (pollInflight.has(id)) return pollInflight.get(id);
    const p = Promise.resolve(Bridge.rpcRaw('recado.poll.get', { pollId: id })).then(r => {
      pollInflight.delete(id);
      if (failed(r)) return { __error: codeOf(r) };
      pollCache.set(id, { data: r, t: Date.now() }); return r;
    }, () => { pollInflight.delete(id); return { __error: 'internal' }; });
    pollInflight.set(id, p); return p;
  }
  /* os cartões de uma conversa fechada saem do DOM mas ficavam presos nestes mapas até chegar um push DAQUELA
     sondagem (que pode nunca chegar): numa sessão longa acumulavam-se centenas de árvores soltas. De 40 em 40
     registos varre-se tudo e largam-se os que já não estão ligados - só os registados há mais de 5 s: uma bolha
     acabada de montar pode ainda não ter entrado na lista da conversa. */
  let liveAdds = 0;
  const liveSweep = () => { const t = Date.now(); [pollLive, eventLive].forEach(map => map.forEach((s, id) => { s.forEach(el => { if (!el.isConnected && t - (el.__liveAt || 0) > 5000) s.delete(el); }); if (!s.size) map.delete(id); })); };
  const liveAdd = (map, id, el) => { el.__liveAt = Date.now(); if (++liveAdds % 40 === 0) liveSweep(); let s = map.get(id); if (!s) { s = new Set(); map.set(id, s); } s.add(el); };
  const liveEach = (map, id, fn) => { const s = map.get(id); if (!s) return; [...s].forEach(el => { if (!el.isConnected) { s.delete(el); return; } try { fn(el); } catch (e) { console.error(e); } }); if (!s.size) map.delete(id); };

  function renderPoll(msg, host) {
    const id = int(payloadOf(msg).pollId);
    const card = UI.el(`<div class="rcx-card rcx-poll"><div class="rcx-kicker">${g('chart', 14)}<span>Sondagem</span></div><div class="rcx-poll-q"></div><div class="rcx-poll-hint">A carregar…</div><div class="rcx-opts"><div class="rcx-sk"></div><div class="rcx-sk"></div></div><div class="rcx-poll-foot"></div></div>`);
    card.querySelector('.rcx-poll-q').textContent = msg.content || 'Sondagem';
    host.appendChild(card);
    if (!id) { paintPollError(card, 'notfound'); return; }
    card.dataset.poll = id; liveAdd(pollLive, id, card);
    fetchPoll(id).then(d => { if (d.__error) paintPollError(card, d.__error); else paintPoll(card, d, true); });
  }
  function paintPollError(card, code) {
    card.classList.add('rcx-gone');
    card.querySelector('.rcx-poll-hint').textContent = code === 'notfound' ? 'Esta sondagem já não está disponível.' : errText(code);
    card.querySelector('.rcx-opts').innerHTML = ''; card.querySelector('.rcx-poll-foot').innerHTML = '';
  }
  function paintPoll(card, d, first) {
    const opts = arr(d.options), mine = new Set(arr(d.mine).map(int)), votes = int(d.votes) || opts.reduce((a, o) => a + int(o.count), 0);
    const maxCount = Math.max(1, ...opts.map(o => int(o.count)));
    card.__poll = d;
    card.querySelector('.rcx-poll-q').textContent = d.question || '';
    card.querySelector('.rcx-poll-hint').textContent = d.multi ? 'Escolhe uma ou mais opções' : 'Escolhe uma opção';
    const box = card.querySelector('.rcx-opts');
    const old = [...box.querySelectorAll('.rcx-opt')];
    if (old.length !== opts.length) { box.innerHTML = ''; opts.forEach((o, i) => box.appendChild(UI.el(`<button type="button" class="rcx-opt" data-i="${i}"><span class="rcx-mark">${g('check', 12)}</span><span class="rcx-otxt"></span><span class="rcx-ocount"></span><span class="rcx-bar"><i></i></span></button>`))); }
    [...box.querySelectorAll('.rcx-opt')].forEach((b, i) => {
      const o = opts[i] || {}, n = int(o.count), on = mine.has(i);
      b.classList.toggle('on', on); b.classList.toggle('multi', !!d.multi); b.classList.toggle('lead', n > 0 && n === maxCount);
      b.querySelector('.rcx-otxt').textContent = o.text || '';
      b.querySelector('.rcx-ocount').textContent = n ? String(n) : '';
      const bar = b.querySelector('.rcx-bar i'), f = votes ? n / votes : 0;
      /* a barra só anima por transform (scaleX): nada de width a mudar no CEF */
      if (first) { bar.style.transform = 'scaleX(0)'; requestAnimationFrame(() => requestAnimationFrame(() => { bar.style.transform = `scaleX(${f.toFixed(4)})`; })); }
      else bar.style.transform = `scaleX(${f.toFixed(4)})`;
      b.onclick = ev => { stop(ev); vote(card, i); };
    });
    const foot = card.querySelector('.rcx-poll-foot');
    const people = int(d.total);
    foot.innerHTML = `<span>${people === 1 ? '1 pessoa votou' : people + ' pessoas votaram'}</span>`;
    if (d.showVoters && votes) { const l = UI.el('<button type="button" class="rcx-link">Ver votos</button>'); l.onclick = ev => { stop(ev); showVoters(card); }; foot.appendChild(l); }
    else if (!d.showVoters) foot.appendChild(UI.el('<span class="rcx-muted">Votos anónimos</span>'));
  }
  async function vote(card, i) {
    const d = card.__poll; if (!d || card.classList.contains('busy')) return;
    const mine = new Set(arr(d.mine).map(int));
    let next;
    if (d.multi) { if (mine.has(i)) mine.delete(i); else mine.add(i); next = [...mine].sort((a, b) => a - b); }
    else next = mine.has(i) && mine.size === 1 ? [] : [i];
    /* otimista: pinta já, desfaz se o servidor recusar */
    const prev = JSON.parse(JSON.stringify(d));
    const opts = arr(d.options).map(o => Object.assign({}, o));
    arr(d.mine).map(int).forEach(k => { if (opts[k]) opts[k].count = Math.max(0, int(opts[k].count) - 1); });
    next.forEach(k => { if (opts[k]) opts[k].count = int(opts[k].count) + 1; });
    const had = arr(d.mine).length > 0, has = next.length > 0;
    const optimistic = Object.assign({}, d, { options: opts, mine: next, votes: opts.reduce((a, o) => a + int(o.count), 0), total: int(d.total) + (has && !had ? 1 : 0) - (had && !has ? 1 : 0) });
    card.classList.add('busy'); paintPoll(card, optimistic, false); try { Sound.play('click'); } catch (e) {}
    const r = await Bridge.rpcRaw('recado.poll.vote', { pollId: int(d.id), options: next });
    card.classList.remove('busy');
    if (failed(r)) { paintPoll(card, prev, false); UI.toast(errText(codeOf(r))); if (r && r.error === 'notfound') paintPollError(card, 'notfound'); return; }
    pollCache.set(int(d.id), { data: r, t: Date.now() });
    liveEach(pollLive, int(d.id), el => paintPoll(el, r, false));
  }
  async function showVoters(card) {
    const d0 = card.__poll; if (!d0) return;
    const d = await fetchPoll(int(d0.id), true); if (d.__error) { UI.toast(errText(d.__error)); return; }
    const body = UI.el('<div class="rcx-voters"></div>');
    body.appendChild(UI.el(`<div class="rcx-voters-q">${esc(d.question || '')}</div>`));
    arr(d.options).forEach(o => {
      const vs = arr(o.voters);
      body.appendChild(UI.list([{ header: `${o.text} · ${int(o.count)} ${int(o.count) === 1 ? 'voto' : 'votos'}`, items: vs.length ? vs.map(n => ({ label: nameOf(n), avatar: { name: nameOf(n), avatar: seedOf(n) }, chevron: false })) : [{ label: 'Ninguém votou nesta opção', cls: 'rcx-muted', chevron: false }] }]));
    });
    UI.sheet({ title: 'Votos', right: 'OK', body, cls: 'rcx-sheet rcx-sheet-tall' });
  }
  Bridge.on('recadoPoll', p => {
    const id = int(p && p.pollId); if (!id) return;
    const c = pollCache.get(id);
    const counts = arr(p.counts).map(int);
    if (c && counts.length === arr(c.data.options).length) {
      const data = Object.assign({}, c.data, { options: arr(c.data.options).map((o, i) => Object.assign({}, o, { count: counts[i] })), total: int(p.total), votes: int(p.votes) || counts.reduce((a, b) => a + b, 0) });
      pollCache.set(id, { data, t: Date.now() - 20000 });   /* os votantes (showVoters) voltam a ler-se no próximo pedido */
      liveEach(pollLive, id, el => paintPoll(el, data, false));
    } else if (pollLive.has(id)) fetchPoll(id, true).then(d => { if (!d.__error) liveEach(pollLive, id, el => paintPoll(el, d, false)); });
  });

  /* ============================================================
     EVENTOS
     Data com a grelha do Calendário do projeto (.cal-*) e hora com os seletores do Relógio (.picker).
     O local "Aqui" é lido no servidor (posição do jogador); "Lugar" usa os pontos do Mapas (Config.POI).
     ============================================================ */
  const pad = n => String(n).padStart(2, '0');
  const MES3 = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
  const remLabel = m => { m = int(m); if (m < 0) return 'Sem lembrete'; if (m === 0) return 'Na hora'; if (m < 60) return m + ' min antes'; if (m % 1440 === 0) return m === 1440 ? '1 dia antes' : (m / 1440) + ' dias antes'; if (m % 60 === 0) return (m / 60) + ' h antes'; return m + ' min antes'; };
  const whenText = ts => { const d = new Date(+ts), n = new Date(); const t = UI.fmtTime(d); const tom = new Date(n); tom.setDate(n.getDate() + 1);
    if (d.toDateString() === n.toDateString()) return 'Hoje · ' + t; if (d.toDateString() === tom.toDateString()) return 'Amanhã · ' + t; return UI.fmtDate(d) + ' · ' + t; };
  const pois = () => { const l = (window.Maps && Array.isArray(Maps.poi) && Maps.poi.length) ? Maps.poi : (typeof DEFAULT_POI !== 'undefined' ? DEFAULT_POI : []); return l.filter(p => p && isFinite(+p.x) && isFinite(+p.y) && p.name).slice(0, 40); };

  function eventComposer(win, target) {
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours() + 1, 0, 0, 0);
    const st = { y: start.getFullYear(), m: start.getMonth(), d: start.getDate(), hh: start.getHours(), mm: 0, loc: 'none', poi: null, reminder: 15, calOpen: false };
    let viewM = new Date(st.y, st.m, 1);
    const body = UI.el(`<div class="rcx-form">
      <div class="rcx-hero ev"><div class="rcx-hero-ic">${g('calendar', 26)}</div><div><b>Novo evento</b><span>Combina um encontro e vê quem vai.</span></div></div>
      <div class="rcx-card-in"><input class="rcx-in rcx-title" type="text" maxlength="80" placeholder="Nome do evento"><textarea class="rcx-in rcx-desc" rows="2" maxlength="500" placeholder="Descrição (opcional)"></textarea></div>
      <div class="rcx-sec-h"><span>Quando</span></div>
      <div class="rcx-card-in"><button type="button" class="rcx-row rcx-date"><span class="rcx-tic">${g('calendar', 17)}</span><span class="rcx-tl">Data</span><span class="rcx-val"></span></button><div class="rcx-cal hidden"></div>
        <div class="rcx-row rcx-time"><span class="rcx-tic">${g('clock', 17)}</span><span class="rcx-tl">Hora</span><div class="picker rcx-picker"><select class="ph"></select><span>:</span><select class="pm"></select></div></div></div>
      <div class="rcx-sec-h"><span>Local</span></div>
      <div class="rcx-card-in rcx-locbox"><div class="rcx-locseg"></div><div class="rcx-locbody"></div></div>
      <div class="rcx-sec-h"><span>Lembrete</span></div>
      <div class="rcx-rem"></div>
      <div class="rcx-foot-note">Quem responder «Vou» ou «Talvez» recebe o lembrete, mesmo com o telemóvel desligado (chega quando voltar).</div></div>`);
    const title = body.querySelector('.rcx-title'), desc = body.querySelector('.rcx-desc'), dateBtn = body.querySelector('.rcx-date'), cal = body.querySelector('.rcx-cal');
    const ph = body.querySelector('.ph'), pm = body.querySelector('.pm');
    for (let h = 0; h < 24; h++) ph.appendChild(new Option(pad(h), h));
    for (let m = 0; m < 60; m += 5) pm.appendChild(new Option(pad(m), m));
    ph.value = st.hh; pm.value = st.mm;
    ph.onchange = () => { st.hh = int(ph.value); validate(); }; pm.onchange = () => { st.mm = int(pm.value); validate(); };
    const startMs = () => new Date(st.y, st.m, st.d, st.hh, st.mm, 0, 0).getTime();
    function paintDate() { dateBtn.querySelector('.rcx-val').textContent = UI.fmtDate(new Date(st.y, st.m, st.d)); dateBtn.classList.toggle('open', st.calOpen); cal.classList.toggle('hidden', !st.calOpen); if (st.calOpen) paintCal(); }
    function paintCal() {
      const today = new Date(); today.setHours(0, 0, 0, 0);
      cal.innerHTML = `<div class="cal-head"><span class="prev">‹</span><b>${(mn => mn.charAt(0).toUpperCase() + mn.slice(1))(UI.monthName ? UI.monthName(viewM.getMonth()) : UI.MESES[viewM.getMonth()])} ${viewM.getFullYear()}</b><span class="next">›</span></div><div class="cal-dow">${[1, 2, 3, 4, 5, 6, 0].map(i => UI.wdNarrow ? UI.wdNarrow(i) : ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][i]).map(x => `<div>${x}</div>`).join('')}</div><div class="cal-grid"></div>`;
      const grid = cal.querySelector('.cal-grid'), first = (viewM.getDay() + 6) % 7, dim = new Date(viewM.getFullYear(), viewM.getMonth() + 1, 0).getDate();
      for (let i = 0; i < first; i++) grid.appendChild(UI.el('<div class="cal-day dim"></div>'));
      for (let day = 1; day <= dim; day++) {
        const dt = new Date(viewM.getFullYear(), viewM.getMonth(), day); const past = dt < today;
        const sel = dt.getFullYear() === st.y && dt.getMonth() === st.m && day === st.d;
        const c = UI.el(`<div class="cal-day ${past ? 'dim rcx-past' : ''} ${sel ? 'rcx-sel' : ''} ${dt.getTime() === today.getTime() ? 'rcx-today' : ''}">${day}</div>`);
        if (!past) c.onclick = ev => { stop(ev); st.y = dt.getFullYear(); st.m = dt.getMonth(); st.d = day; st.calOpen = false; paintDate(); validate(); };
        grid.appendChild(c);
      }
      cal.querySelector('.prev').onclick = ev => { stop(ev); const p = new Date(viewM.getFullYear(), viewM.getMonth() - 1, 1); if (p >= new Date(today.getFullYear(), today.getMonth(), 1)) { viewM = p; paintCal(); } };
      cal.querySelector('.next').onclick = ev => { stop(ev); const n = new Date(viewM.getFullYear(), viewM.getMonth() + 1, 1); if (n <= new Date(today.getFullYear() + 1, today.getMonth(), 1)) { viewM = n; paintCal(); } };
    }
    dateBtn.onclick = ev => { stop(ev); st.calOpen = !st.calOpen; if (st.calOpen) viewM = new Date(st.y, st.m, 1); paintDate(); };
    /* local */
    const seg = body.querySelector('.rcx-locseg'), lb = body.querySelector('.rcx-locbody');
    const LOCS = [['none', 'Sem local'], ['here', 'Aqui'], ['poi', 'Lugar']];
    LOCS.forEach(([k, l]) => { const b = UI.el(`<button type="button" class="rcx-pill" data-k="${k}">${esc(l)}</button>`); b.onclick = ev => { stop(ev); st.loc = k; paintLoc(); validate(); }; seg.appendChild(b); });
    const labelIn = UI.el('<input class="rcx-in rcx-loclabel" type="text" maxlength="60" placeholder="Nome do local (opcional)">');
    function paintLoc() {
      seg.querySelectorAll('.rcx-pill').forEach(b => b.classList.toggle('on', b.dataset.k === st.loc));
      lb.innerHTML = '';
      if (st.loc === 'here') { lb.appendChild(UI.el(`<div class="rcx-locnote">${g('location', 15)}<span>Usa a tua posição atual no mapa, lida pelo servidor quando enviares.</span></div>`)); labelIn.placeholder = 'Nome do local (ex.: À porta da garagem)'; lb.appendChild(labelIn); }
      else if (st.loc === 'poi') {
        const wrap = UI.el('<div class="rcx-pois"></div>');
        pois().forEach(p => { const b = UI.el(`<button type="button" class="rcx-poi ${st.poi === p ? 'on' : ''}"><span class="rcx-poi-dot"></span><span></span></button>`); b.lastElementChild.textContent = p.name; if (p.color && /^#[0-9a-f]{3,8}$/i.test(p.color)) b.firstElementChild.style.background = p.color;
          b.onclick = ev => { stop(ev); st.poi = p; if (!labelIn.value.trim()) labelIn.value = String(p.name).slice(0, 60); paintLoc(); validate(); }; wrap.appendChild(b); });
        if (!wrap.children.length) wrap.appendChild(UI.el('<div class="rcx-muted rcx-pad">Sem lugares no Mapas.</div>'));
        lb.appendChild(wrap); labelIn.placeholder = 'Nome do local'; lb.appendChild(labelIn);
      }
    }
    /* lembrete */
    const rem = body.querySelector('.rcx-rem');
    function paintRem() { rem.innerHTML = ''; CFG.events.reminders.concat([-1]).forEach(m => { const b = UI.el(`<button type="button" class="rcx-pill ${st.reminder === m ? 'on' : ''}">${esc(remLabel(m))}</button>`); b.onclick = ev => { stop(ev); st.reminder = m; paintRem(); }; rem.appendChild(b); }); }
    function why() {
      if (!title.value.trim()) return 'Dá um nome ao evento.';
      if (startMs() < Date.now() - 30000) return 'Escolhe uma data e hora no futuro.';
      if (st.loc === 'poi' && !st.poi) return 'Escolhe um lugar.';
      return '';
    }
    function validate() { if (body.__setValid) body.__setValid(!why()); }
    body.__why = why; body.__validate = validate;
    title.oninput = validate;
    paintDate(); paintLoc(); paintRem();
    loadCfg().then(() => { if (!CFG.events.reminders.includes(st.reminder)) st.reminder = CFG.events.reminders.includes(15) ? 15 : (CFG.events.reminders[0] != null ? CFG.events.reminders[0] : -1); paintRem(); });
    const p = composeSheet('Evento', body, async () => {
      const req = Object.assign(targetArgs(target), { title: title.value.trim(), description: desc.value.trim(), start: startMs(), reminder: st.reminder });
      const label = labelIn.value.trim();
      /* "Aqui" partilha a posição do jogador: pede a mesma autorização de localização que a bolha de localização do chat */
      if (st.loc === 'here' && window.Perm && typeof Perm.request === 'function') { let okP = false; try { okP = await Perm.request('recado', 'location'); } catch (e) { okP = false; } if (!okP) return { error: 'noperm' }; }
      if (st.loc === 'here') req.location = { here: true, label: label || undefined };
      else if (st.loc === 'poi' && st.poi) req.location = { x: +st.poi.x, y: +st.poi.y, label: label || String(st.poi.name).slice(0, 60) };
      return Bridge.rpcRaw('recado.event.create', req);
    });
    setTimeout(() => { try { title.focus(); } catch (e) {} }, 420);
    return p;
  }

  const eventCache = new Map(), eventLive = new Map();
  function fetchEvent(id, force) {
    const c = eventCache.get(id);
    if (!force && c && Date.now() - c.t < 30000) return Promise.resolve(c.data);
    return Promise.resolve(Bridge.rpcRaw('recado.event.get', { eventId: id })).then(r => { if (failed(r)) return { __error: codeOf(r) }; eventCache.set(id, { data: r, t: Date.now() }); return r; }, () => ({ __error: 'internal' }));
  }
  function renderEvent(msg, host) {
    const id = int(payloadOf(msg).eventId);
    const card = UI.el(`<div class="rcx-card rcx-event"><div class="rcx-ev-top"><div class="rcx-ev-date"><b>-</b><span></span></div><div class="rcx-ev-main"><div class="rcx-kicker">${g('calendar', 14)}<span>Evento</span></div><div class="rcx-ev-title"></div><div class="rcx-ev-when">A carregar…</div></div></div><div class="rcx-ev-rest"></div></div>`);
    card.querySelector('.rcx-ev-title').textContent = msg.content || 'Evento';
    host.appendChild(card);
    if (!id) { paintEventError(card, 'notfound'); return; }
    liveAdd(eventLive, id, card);
    fetchEvent(id).then(d => { if (d.__error) paintEventError(card, d.__error); else paintEvent(card, d); });
  }
  function paintEventError(card, code) { card.classList.add('rcx-gone'); card.querySelector('.rcx-ev-when').textContent = code === 'notfound' ? 'Este evento já não está disponível.' : errText(code); card.querySelector('.rcx-ev-rest').innerHTML = ''; }
  function paintEvent(card, d) {
    card.__event = d;
    const dt = new Date(+d.start), past = +d.start < Date.now() - 3 * 3600000, cancelled = !!d.cancelled;
    card.classList.toggle('rcx-cancel', cancelled); card.classList.toggle('rcx-past', past && !cancelled);
    card.querySelector('.rcx-ev-date b').textContent = dt.getDate();
    card.querySelector('.rcx-ev-date span').textContent = MES3[dt.getMonth()];
    card.querySelector('.rcx-ev-title').textContent = d.title || '';
    card.querySelector('.rcx-ev-when').textContent = cancelled ? 'Cancelado' : (past ? 'Terminou · ' : '') + whenText(d.start);
    const rest = card.querySelector('.rcx-ev-rest'); rest.innerHTML = '';
    if (d.description) { const de = UI.el('<div class="rcx-ev-desc"></div>'); de.innerHTML = formatText(d.description); rest.appendChild(de); }
    const loc = d.location;
    if (loc && (loc.label || (loc.x != null && loc.y != null))) {
      const hasXY = isFinite(+loc.x) && isFinite(+loc.y) && loc.x != null && loc.y != null;
      const row = UI.el(`<div class="rcx-ev-loc"><span class="rcx-tic">${g('pin', 15)}</span><span class="rcx-ev-locname"></span>${hasXY ? '<button type="button" class="rcx-link">Abrir no mapa</button>' : ''}</div>`);
      row.querySelector('.rcx-ev-locname').textContent = loc.label || 'Localização';
      if (hasXY) row.querySelector('.rcx-link').onclick = ev => { stop(ev); openMap(loc, d.title); };
      rest.appendChild(row);
    }
    const counts = d.counts || {};
    const rs = UI.el('<div class="rcx-rsvp"></div>');
    [['yes', 'Vou', 'check'], ['maybe', 'Talvez', 'more'], ['no', 'Não', 'x']].forEach(([k, l, ic]) => {
      const b = UI.el(`<button type="button" class="rcx-rs ${d.mine === k ? 'on' : ''} rs-${k}" ${cancelled || past ? 'disabled' : ''}><span class="rcx-rs-ic">${g(ic, 13)}</span><span>${l}</span><b>${int(counts[k]) || ''}</b></button>`);
      b.onclick = ev => { stop(ev); if (cancelled || past) return; rsvp(card, d.mine === k ? null : k); };
      rs.appendChild(b);
    });
    rest.appendChild(rs);
    const foot = UI.el('<div class="rcx-poll-foot"></div>');
    const going = int(counts.yes);
    foot.appendChild(UI.el(`<span>${going === 1 ? '1 pessoa vai' : going + ' pessoas vão'}${int(d.reminder) >= 0 && !cancelled ? ' · ' + esc(remLabel(d.reminder).toLowerCase()) : ''}</span>`));
    const more = UI.el(`<button type="button" class="rcx-link rcx-more" aria-label="Mais">${g('more', 16)}</button>`);
    more.onclick = ev => { stop(ev); eventMenu(card); };
    foot.appendChild(more);
    rest.appendChild(foot);
  }
  function openMap(loc, title) {
    const p = { x: +loc.x, y: +loc.y, name: loc.label || title || 'Evento' };
    Bridge.call('setWaypoint', p);
    UI.toast('Marcado no GPS');
    try { if (window.System && System.openApp) { System.openApp('maps'); setTimeout(() => { if (window.Maps && Maps.showAt) Maps.showAt(p); }, 320); } } catch (e) {}
  }
  async function rsvp(card, answer) {
    const d = card.__event; if (!d || card.classList.contains('busy')) return;
    card.classList.add('busy');
    const r = await Bridge.rpcRaw('recado.event.rsvp', { eventId: int(d.id), answer });
    card.classList.remove('busy');
    if (failed(r)) { UI.toast(errText(codeOf(r))); return; }
    try { Sound.play('click'); } catch (e) {}
    eventCache.set(int(d.id), { data: r, t: Date.now() });
    liveEach(eventLive, int(d.id), el => paintEvent(el, r));
  }
  async function eventMenu(card) {
    const d = card.__event; if (!d) return;
    const mineEv = String(d.creator) === myNumber();
    const buttons = [{ label: 'Quem vai', icon: 'users', value: 'who' }, { label: 'Adicionar ao Calendário', icon: 'calendar', value: 'cal' }];
    if (mineEv && !d.cancelled) buttons.push({ label: 'Cancelar evento', icon: 'xCircle', danger: true, value: 'cancel' });
    const a = await UI.actionSheet({ title: d.title, buttons });
    if (a === 'who') showAttendees(card);
    if (a === 'cal') {
      const dt = new Date(+d.start), key = `${dt.getFullYear()}-${pad(dt.getMonth() + 1)}-${pad(dt.getDate())}`, time = `${pad(dt.getHours())}:${pad(dt.getMinutes())}`;
      /* o Calendário do telemóvel guarda os eventos no Store da personagem ('events'); só se acrescenta uma vez */
      let added = false;
      /* como nas Notas: o Calendário mostra 2 eventos de exemplo enquanto nada foi gravado; o valor por omissão é o
         mesmo do calendar.js, para "Adicionar" não apagar os exemplos que a pessoa está a ver */
      const today = new Date(), k2 = x => `${x.getFullYear()}-${pad(x.getMonth() + 1)}-${pad(x.getDate())}`;
      const tt = s => (window.L && L.t ? L.t(s) : s);   /* 1.1.8: exemplos já traduzidos, como no calendar.js */
      const calSeed = [{ id: 1, date: k2(today), title: tt('Reunião na garagem'), time: '15:00', color: 'var(--blue)' }, { id: 2, date: k2(new Date(today.getFullYear(), today.getMonth(), today.getDate() + 2)), title: tt('Pagar seguro'), time: '10:00', color: 'var(--red)' }];
      Store.update('events', calSeed, l => { if (!Array.isArray(l)) return; if (!l.some(x => x && x.recadoEvent === int(d.id))) { l.push({ id: Date.now(), date: key, title: String(d.title || 'Evento').slice(0, 80), time, color: 'var(--indigo)', recadoEvent: int(d.id) }); added = true; } });
      UI.toast(added ? 'Adicionado ao Calendário' : 'Já está no Calendário');
    }
    if (a === 'cancel' && await UI.confirm('Cancelar evento?', 'Todos na conversa vão ver o evento como cancelado e ninguém recebe o lembrete.', 'Cancelar evento', true)) {
      const r = await Bridge.rpcRaw('recado.event.cancel', { eventId: int(d.id) });
      if (failed(r)) { UI.toast(errText(codeOf(r))); return; }
      eventCache.set(int(d.id), { data: r, t: Date.now() });
      liveEach(eventLive, int(d.id), el => paintEvent(el, r));
    }
  }
  async function showAttendees(card) {
    const d0 = card.__event; if (!d0) return;
    const d = await fetchEvent(int(d0.id), true); if (d.__error) { UI.toast(errText(d.__error)); return; }
    const sec = (header, list) => ({ header: `${header} · ${list.length}`, items: list.length ? list.map(n => ({ label: nameOf(n), avatar: { name: nameOf(n), avatar: seedOf(n) }, chevron: false })) : [{ label: 'Ninguém', cls: 'rcx-muted', chevron: false }] });
    const body = UI.list([sec('Vão', arr(d.going)), sec('Talvez', arr(d.maybe)), sec('Não vão', arr(d.notGoing))]);
    UI.sheet({ title: 'Respostas', right: 'OK', body, cls: 'rcx-sheet rcx-sheet-tall' });
  }
  Bridge.on('recadoEvent', p => {
    const id = int(p && p.eventId); if (!id) return;
    const c = eventCache.get(id);
    if (c && p.counts && typeof p.counts === 'object') {
      const data = Object.assign({}, c.data, { counts: { yes: int(p.counts.yes), maybe: int(p.counts.maybe), no: int(p.counts.no) }, cancelled: !!(p.cancelled || c.data.cancelled) });
      eventCache.set(id, { data, t: Date.now() - 20000 });
      liveEach(eventLive, id, el => paintEvent(el, data));
    } else if (eventLive.has(id)) fetchEvent(id, true).then(d => { if (!d.__error) liveEach(eventLive, id, el => paintEvent(el, d)); });
  });

  /* ============================================================
     DOCUMENTOS - não há ficheiros no telemóvel: um documento é título + corpo (com a formatação do Recado)
     ou uma nota da app Notas (guardada no Store da personagem, chave 'notes': a primeira linha é o título).
     ============================================================ */
  /* A app Notas mostra 2 notas de exemplo enquanto a personagem nunca gravou nenhuma (Store.get('notes', seed) no
     notes.js, sem as escrever). Com [] por omissão, "Das Notas" dizia "Sem notas" ao lado de uma app com 2 notas, e
     "Guardar nas Notas" apagava os exemplos. Mesmos textos/ids do notes.js (se lá mudarem, muda-se aqui). */
  const notesSeed = () => { const tt = s => (window.L && L.t ? L.t(s) : s); return [{ id: 1, text: tt('Lista de compras\nPão, leite, café, ovos'), ts: Date.now() - 864e5 }, { id: 2, text: tt('Matrícula da carrinha\n48ABC123, garagem central'), ts: Date.now() - 2 * 864e5 }]; };   /* 1.1.8: já traduzidos, como no notes.js */
  const notesList = () => { const l = Store.get('notes', notesSeed()); return (Array.isArray(l) ? l : []).filter(n => n && typeof n.text === 'string' && n.text.trim()).sort((a, b) => (+b.ts || 0) - (+a.ts || 0)); };
  const noteParts = n => { const [t, ...r] = String(n.text || '').split('\n'); return { title: (t || 'Nota').trim().slice(0, 80) || 'Nota', body: r.join('\n').trim() || (t || '').trim() }; };
  const nfmt = n => Number(n).toLocaleString('pt-PT');

  function documentPicker(win, target) {
    const tmax = () => CFG.doc.titleMax, bmax = () => CFG.doc.bodyMax;
    const body = UI.el(`<div class="rcx-form">
      <div class="rcx-hero doc"><div class="rcx-hero-ic">${g('newspaper', 26)}</div><div><b>Documento</b><span>Escreve um texto ou partilha uma nota.</span></div></div>
      <div class="rcx-tabs2"><button type="button" class="rcx-pill on" data-t="write">Escrever</button><button type="button" class="rcx-pill" data-t="notes">Das Notas</button></div>
      <div class="rcx-pane" data-p="write"><div class="rcx-card-in"><input class="rcx-in rcx-dtitle" type="text" placeholder="Título"><textarea class="rcx-in rcx-dbody" rows="9" placeholder="Escreve aqui…"></textarea></div>
        <div class="rcx-sec-h"><span class="rcx-fmt-hint">*negrito* · _itálico_ · ~riscado~ · \`código\` · - lista · &gt; citação</span><span class="rcx-count"></span></div></div>
      <div class="rcx-pane hidden" data-p="notes"></div></div>`);
    const ti = body.querySelector('.rcx-dtitle'), bi = body.querySelector('.rcx-dbody'), count = body.querySelector('.rcx-count');
    ti.maxLength = tmax(); bi.maxLength = bmax();
    const panes = body.querySelectorAll('.rcx-pane'), tabs = body.querySelectorAll('.rcx-tabs2 .rcx-pill');
    const show = t => { tabs.forEach(b => b.classList.toggle('on', b.dataset.t === t)); panes.forEach(p => p.classList.toggle('hidden', p.dataset.p !== t)); if (t === 'notes') paintNotes(); };
    tabs.forEach(b => { b.onclick = ev => { stop(ev); show(b.dataset.t); }; });
    function paintNotes() {
      const pane = body.querySelector('[data-p="notes"]'); pane.innerHTML = '';
      const ns = notesList();
      if (!ns.length) { pane.appendChild(UI.empty('compose', 'Sem notas', 'As notas que escreveres na app Notas aparecem aqui.')); return; }
      pane.appendChild(UI.list([{ header: 'Notas', footer: 'Toca numa nota para a rever antes de enviar.', items: ns.slice(0, 60).map(n => { const p = noteParts(n); return { label: p.title, sub: plain(p.body).replace(/\s+/g, ' ').slice(0, 60), icon: 'compose', iconBg: '#F59E0B',
        onTap: () => { ti.value = p.title.slice(0, tmax()); bi.value = p.body.slice(0, bmax()); show('write'); validate(); } }; }) }]));
    }
    function why() { if (!ti.value.trim()) return 'Dá um título ao documento.'; if (!bi.value.trim()) return 'O documento está vazio.'; return ''; }
    function validate() { const n = bi.value.length; count.textContent = `${nfmt(n)} / ${nfmt(bmax())}`; count.classList.toggle('warn', n > bmax() * .9); if (body.__setValid) body.__setValid(!why()); }
    body.__why = why; body.__validate = validate;
    ti.oninput = validate; bi.oninput = validate;
    loadCfg().then(() => { ti.maxLength = tmax(); bi.maxLength = bmax(); validate(); });
    const p = composeSheet('Documento', body, () => Bridge.rpcRaw('recado.doc.share', Object.assign(targetArgs(target), { title: ti.value.trim(), body: bi.value })));
    setTimeout(() => { try { ti.focus(); } catch (e) {} }, 420);
    return p;
  }

  function renderDocument(msg, host) {
    const p = payloadOf(msg);
    const title = String(p.title || msg.content || 'Documento'), text = String(p.body || '');
    const words = text.trim() ? text.trim().split(/\s+/).length : 0;
    const card = UI.el(`<div class="rcx-card rcx-doc"><div class="rcx-doc-top"><div class="rcx-doc-ic"><svg viewBox="0 0 40 48" aria-hidden="true"><path d="M6 2h20l12 12v28a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4z" fill="#fff"/><path d="M26 2v8a4 4 0 0 0 4 4h8z" fill="#BBF7D0"/><path d="M9 22h20M9 29h22M9 36h14" stroke="#22C55E" stroke-width="3" stroke-linecap="round"/></svg></div>
      <div class="rcx-doc-main"><div class="rcx-kicker">${g('newspaper', 13)}<span>Documento</span></div><div class="rcx-doc-title"></div><div class="rcx-doc-meta"></div></div></div>
      <div class="rcx-doc-prev"></div><div class="rcx-poll-foot"><button type="button" class="rcx-link rcx-open">Abrir documento</button></div></div>`);
    card.querySelector('.rcx-doc-title').textContent = title;
    card.querySelector('.rcx-doc-meta').textContent = `${nfmt(words)} ${words === 1 ? 'palavra' : 'palavras'} · ${text.split('\n').length} ${text.split('\n').length === 1 ? 'linha' : 'linhas'}`;
    card.querySelector('.rcx-doc-prev').textContent = plain(text).replace(/\n{2,}/g, '\n').slice(0, 220);
    const open = ev => { stop(ev); openDocument(null, { title, body: text, sender: msg.sender, created: msg.created }); };
    card.querySelector('.rcx-open').onclick = open;
    card.querySelector('.rcx-doc-top').onclick = open;
    host.appendChild(card);
  }
  /* documento aberto: vista empurrada na janela do Recado (ou folha, sem janela) */
  function openDocument(win, doc) {
    win = win || (R() && R().win) || null;
    const title = String((doc && doc.title) || 'Documento'), text = String((doc && doc.body) || '');
    const page = UI.el(`<div class="rcx-docview"><div class="rcx-docview-h"></div><div class="rcx-docview-meta"></div><div class="rcx-docview-body rcx-fmt"></div></div>`);
    page.querySelector('.rcx-docview-h').textContent = title;
    page.querySelector('.rcx-docview-meta').textContent = [doc && doc.sender ? 'De ' + nameOf(doc.sender) : '', doc && doc.created ? UI.fmtDate(new Date(+doc.created), true) + ' · ' + UI.fmtTime(new Date(+doc.created)) : ''].filter(Boolean).join(' · ');
    page.querySelector('.rcx-docview-body').innerHTML = formatText(text);
    /* Msgs.copy guarda também na área de transferência interna do telemóvel (no CEF o navigator.clipboard costuma
       falhar). Sem ele: a promessa do writeText rejeita sem permissão - apanhada, senão era um erro solto na consola */
    const copy = () => { const t = title + '\n\n' + text; if (window.Msgs && typeof Msgs.copy === 'function') Msgs.copy(t); else { try { const pr = navigator.clipboard && navigator.clipboard.writeText(t); if (pr && pr.catch) pr.catch(() => {}); } catch (e) {} UI.toast('Copiado'); } };
    const save = () => { Store.update('notes', notesSeed(), l => { if (Array.isArray(l)) l.push({ id: Date.now(), text: (title + '\n' + text).slice(0, 20000), ts: Date.now() }); }); UI.toast('Guardado nas Notas'); };
    const stack = win && (win.classList && win.classList.contains('nav-stack') ? win : win.querySelector && win.querySelector('.nav-stack'));
    if (stack) {
      const v = UI.view({ title: 'Documento', back: true, cls: 'rcx-docv', right: [{ icon: 'copy', onTap: copy }, { icon: 'download', onTap: save }] });   /* 'download' = guardar (o lápis parecia "editar") */
      v.content.appendChild(page); UI.push(win, v); return v;
    }
    const acts = UI.el(`<div class="rcx-docacts"><button type="button" class="rcx-btn">${g('copy', 16)}<span>Copiar</span></button><button type="button" class="rcx-btn">${g('download', 16)}<span>Guardar nas Notas</span></button></div>`);
    acts.children[0].onclick = copy; acts.children[1].onclick = save;
    page.appendChild(acts);
    return UI.sheet({ title: 'Documento', right: 'OK', body: page, cls: 'rcx-sheet rcx-sheet-tall' });
  }

  /* ============================================================
     render(msg, bolhaEl) - o RB chama isto para cada mensagem; true = tratado aqui
     A bolha recebe .rcx-host (e .rcx-host-<tipo>): o CSS tira-lhe fundo e margens para o cartão ser a bolha.
     ============================================================ */
  function renderGif(msg, host) {
    const p = payloadOf(msg);
    if (!safeGif(p.url)) { host.appendChild(UI.el(`<div class="rcx-card rcx-gone"><div class="rcx-poll-hint">GIF indisponível</div></div>`)); return; }
    const tile = gifTile(p, true);
    tile.style.width = Math.round(Math.min(240, Math.max(120, 240 * Math.min(1, (int(p.w) || 1) / (int(p.h) || 1))))) + 'px';
    host.appendChild(tile);
  }
  function render(msg, bubbleEl) {
    if (!cfgP) loadCfg();   /* a primeira conversa aberta já traz a configuração (GIF ligado, packs) */
    if (!msg || !bubbleEl || !TYPES.includes(msg.type) || msg.deleted) return false;
    bubbleEl.classList.add('rcx-host', 'rcx-host-' + msg.type);
    bubbleEl.innerHTML = '';
    try {
      if (msg.type === 'sticker') { const p = payloadOf(msg); bubbleEl.appendChild(stickerEl(p.pack, p.id)); }
      else if (msg.type === 'gif') renderGif(msg, bubbleEl);
      else if (msg.type === 'document') renderDocument(msg, bubbleEl);
      else if (msg.type === 'poll') renderPoll(msg, bubbleEl);
      else if (msg.type === 'event') renderEvent(msg, bubbleEl);
    } catch (e) { console.error('[recado-extras] render', e); bubbleEl.textContent = label(msg); }
    return true;
  }
  function label(msg) {
    if (!msg) return '';
    const p = payloadOf(msg);
    switch (msg.type) {
      case 'poll': return '📊 ' + (msg.content || 'Sondagem');
      case 'event': return '📅 ' + (msg.content || 'Evento');
      case 'document': return '📄 ' + (p.title || msg.content || 'Documento');
      case 'sticker': { const s = findSticker(p.pack, p.id); return (s ? s.emoji + ' ' : '') + 'Sticker'; }
      case 'gif': return 'GIF';
      default: return null;
    }
  }
  /* a configuração lê-se quando uma folha abre (nada de RPC ao carregar o script: a personagem ainda não existe) */

  /* troca de personagem: as sondagens/eventos em cache eram os da personagem anterior (contagens, "os meus votos")
     e a configuração pode ter mudado com um restart do recurso */
  Bridge.on('session:changed', () => { pollCache.clear(); pollInflight.clear(); eventCache.clear(); pollLive.clear(); eventLive.clear(); cfgP = null; cfgAt = 0; });
  /* A configuração chega cedo (como o recado.js faz com as conversas): o chat (RB) decide mostrar o botão GIF com
     gifEnabled() no momento em que abre o painel - numa conversa vazia ainda nenhuma bolha tinha pedido a config
     e o botão ficava escondido mesmo com o fornecedor ativo. Só com o Recado instalado. */
  const warmCfg = () => { try { if (window.System && typeof System.isInstalled === 'function' && System.isInstalled('recado')) loadCfg(true); } catch (e) {} };
  Bridge.on('ready', () => setTimeout(warmCfg, 1800));
  Bridge.on('apps:changed', () => { if (!cfgP) warmCfg(); });

  const api = { emojiPicker, stickerPicker, gifPicker, pollComposer, eventComposer, documentPicker, render, formatText, label,
    types: TYPES.slice(), sticker: stickerEl, stickerPacks, gifEnabled: () => { if (!cfgP) loadCfg(); return !!CFG.gif.enabled; }, config: () => loadCfg(true) /* pedido explícito = sempre fresco (a cache de 60 s é para as folhas) */, openDocument, plain, safeGif };
  return api;
})();

/* Registo no Recado: o recado.js (RA) carrega DEPOIS deste ficheiro. Regista-se já se ele existir, senão
   quando o DOM acabar de carregar (e mais uma tentativa curta, para ordens de carregamento diferentes). */
(() => {
  let done = false;
  const tryReg = () => { if (done) return true; const r = window.Recado; if (r && typeof r.register === 'function') { try { r.register('extras', window.RecadoExtras); done = true; } catch (e) { console.error('[recado-extras] register', e); } } return done; };
  if (!tryReg()) { document.addEventListener('DOMContentLoaded', () => { if (!tryReg()) setTimeout(tryReg, 400); }); }
})();

/* ============================================================
   MOCKS DO BROWSER - os mesmos RPCs e as mesmas regras do server/recado_extras.lua sobre o LocalDB.
   A mensagem sai pelo mock do recado.send (RA) e, sem ele, pelo messages.send com app = 'recado'.
   Tabelas: recado_polls, recado_poll_votes, recado_events, recado_rsvp. GIF: desligado por omissão como no
   config_recado.lua; Store.global 'mock:recadoGif' = true liga um fornecedor falso (SVG locais).
   ============================================================ */
(() => {
  if (!window.LocalDB || typeof LocalDB.register !== 'function') return;
  const T = LocalDB.T, G = Store.global || Store, now = () => Date.now();
  const me = () => String(LocalDB.me().number);
  const int = v => { const n = Math.floor(+v); return isFinite(n) ? n : 0; };
  const MAX_OPT = 12, REMINDERS = [0, 15, 60, 1440], DOC_T = 80, DOC_B = 20000;
  /* ids pequenos e a subir, como o AUTO_INCREMENT */
  const nextId = (key, tbl) => { const n = Math.max(int(G.get(key, 0)), T(tbl).all().reduce((a, r) => Math.max(a, int(r.id) < 1e9 ? int(r.id) : 0), 0)) + 1; G.set(key, n); return n; };
  /* controlo e invisíveis de formatação (as mesmas famílias que o server tira); \\u em texto, nunca os próprios caracteres no ficheiro */
  const CTRL_ALL = new RegExp('[\\u0000-\\u001f\\u007f\\u200b-\\u200f\\u202a-\\u202e\\u2060-\\u206f\\ufeff]', 'g');
  const CTRL_TXT = new RegExp('[\\u0000-\\u0008\\u000b-\\u001f\\u007f\\u200b-\\u200f\\u202a-\\u202e\\u2060-\\u206f\\ufeff]', 'g');
  const line = (v, max) => (typeof v === 'string' || typeof v === 'number') ? String(v).replace(CTRL_ALL, ' ').replace(/\s+/g, ' ').trim().slice(0, max).trim() : '';
  const text = (v, max) => typeof v === 'string' ? v.replace(/\r\n?/g, '\n').replace(CTRL_TXT, '').replace(/\n{4,}/g, '\n\n\n').trim().slice(0, max) : '';
  const cleanNumber = v => { const s = String(v == null ? '' : v).trim(); return /^[\d+\-.() ]{3,20}$/.test(s) && (s.match(/\d/g) || []).length >= 3 ? s : ''; };
  const members = conv => T('conversation_members').all().filter(x => int(x.conversation_id) === conv && !x.left_at);
  const isMember = (conv, who) => members(conv).some(x => x.member === who);
  const pending = new Map();

  function target(d) {
    const my = me();
    let conv = d.conversation != null ? int(d.conversation) : 0;
    if (d.conversation == null) { const m = /^g:(\d+)$/.exec(String(d.number == null ? '' : d.number)); if (m) conv = int(m[1]); }
    if (d.conversation != null || conv) {
      if (conv <= 0) return { error: 'target' };
      const c = T('conversations').all().find(x => int(x.id) === conv);
      if (!c || (c.app || 'sms') !== 'recado' || !isMember(conv, my)) return { error: 'notfound' };
      return { me: my, conversation: conv };
    }
    const n = cleanNumber(d.number); if (!n || n === my) return { error: 'target' };
    if (T('blocks').all().some(b => (!b.owner || b.owner === LocalDB.cid) && b.number === n)) return { error: 'blocked' };
    return { me: my, number: n };
  }
  function send(t, type, content, payload, key) {
    const req = { app: 'recado', type, content, payload };
    if (t.conversation) req.conversation = t.conversation; else { req.number = t.number; req.to = t.number; }
    if (key) pending.set(key, now());
    let r = LocalDB.rpc('recado.send', req);
    /* sem mock do RA, ou um mock do RA que (bem) recusa poll/event vindos do cliente: grava-se pelo messages.send,
       que é o que o RecadoSend(…, { trusted = true }) faz no servidor */
    if (r && typeof r.error === 'string' && (r.error.startsWith('unknown rpc') || (key && r.error === 'badtype'))) r = LocalDB.rpc('messages.send', req);
    if (key) pending.delete(key);
    if (!r || r.error || r.ok === false) return { error: (r && r.error) || 'db' };
    const msg = r.message && typeof r.message === 'object' ? r.message : r;
    return msg.id ? msg : { error: 'db' };
  }
  /* para o mock do recado.send (RA): sondagem/evento só entram por aqui, como o RecadoExtrasPending do servidor */
  window.RecadoExtrasMock = { pending: (type, p) => !!(p && pending.has(type + ':' + int(type === 'poll' ? p.pollId : p.eventId))) };

  function visible(who, row) {
    if (!row || !row.message_id) return false;
    const m = T('messages').all().find(x => x.id === row.message_id);
    if (!m || m.deleted_all) return false;
    if (m.expires_at && +m.expires_at <= now()) return false;
    if (row.conversation_id) {
      if (int(m.conversation_id) !== row.conversation_id || !isMember(row.conversation_id, who)) return false;
      const mem = members(row.conversation_id).find(x => x.member === who);
      if (mem && mem.joined && +m.created < +mem.joined) return false;
      return !(m.sender === who && m.deleted_sender);
    }
    if (m.conversation_id) return false;
    if (who === m.sender) return !m.deleted_sender;
    if (who === m.receiver) return !m.deleted_receiver;
    return false;
  }
  const other = (row, my) => row.conversation_id ? null : (my === row.creator ? row.peer : row.creator);

  LocalDB.register('recado.extras.config', () => ({ gif: { enabled: !!G.get('mock:recadoGif', false), provider: G.get('mock:recadoGif', false) ? 'tenor' : 'none' }, polls: { maxOptions: MAX_OPT }, events: { reminders: REMINDERS.slice() }, stickers: ['basicos', 'cidade', 'reacoes'], doc: { titleMax: DOC_T, bodyMax: DOC_B } }));

  /* ---------- sondagens ---------- */
  function pollView(row, my) {
    const votes = T('recado_poll_votes').all().filter(v => v.poll_id === row.id).sort((a, b) => a.created - b.created);
    const counts = row.options.map(() => 0), voters = row.options.map(() => []), mine = [], people = new Set();
    votes.forEach(v => { const i = int(v.option_idx); if (i < 0 || i >= row.options.length) return; counts[i]++; people.add(v.voter); if (v.voter === my) mine.push(i); if (row.show_voters) voters[i].push(v.voter); });
    const out = { id: row.id, question: row.question, options: row.options.map((t, i) => Object.assign({ text: t, count: counts[i] }, row.show_voters && voters[i].length ? { voters: voters[i] } : {})), counts,
      multi: !!row.multi, showVoters: !!row.show_voters, total: people.size, votes: votes.length, creator: row.creator, created: row.created, conversation: row.conversation_id || null, messageId: row.message_id };
    if (mine.length) out.mine = mine;
    return out;
  }
  LocalDB.register('recado.poll.create', d => {
    const t = target(d); if (t.error) return t;
    const question = line(d.question, 300); if (!question) return { error: 'question' };
    if (!Array.isArray(d.options)) return { error: 'options' };
    const opts = [], seen = new Set();
    for (const o of d.options.slice(0, 64)) { const v = line(o, 100); if (!v) continue; if (seen.has(v.toLowerCase())) return { error: 'duplicate' }; seen.add(v.toLowerCase()); opts.push(v); }
    if (opts.length < 2) return { error: 'options' };
    if (opts.length > MAX_OPT) return { error: 'toomany', max: MAX_OPT };
    const id = nextId('mock:recadoPollSeq', 'recado_polls');
    T('recado_polls').insert({ id, message_id: null, conversation_id: t.conversation || null, creator: t.me, peer: t.number || null, question, options: opts, multi: d.multi === true ? 1 : 0, show_voters: d.showVoters === true ? 1 : 0, created: now() });
    const msg = send(t, 'poll', question, { pollId: id }, 'poll:' + id);
    if (msg.error) { T('recado_polls').remove(id); return msg; }
    T('recado_polls').update(id, { message_id: msg.id });
    return msg;
  });
  LocalDB.register('recado.poll.get', d => { const row = T('recado_polls').all().find(x => x.id === int(d.pollId)); if (!row || !visible(me(), row)) return { error: 'notfound' }; return pollView(row, me()); });
  LocalDB.register('recado.poll.vote', d => {
    const my = me(), row = T('recado_polls').all().find(x => x.id === int(d.pollId));
    if (!row || !visible(my, row)) return { error: 'notfound' };
    const sel = [];
    if (d.options != null) {
      if (!Array.isArray(d.options)) return { error: 'options' };
      for (const v of d.options.slice(0, 64)) { const i = Math.floor(+v); if (!isFinite(i) || String(v).trim() === '' || i < 0 || i >= row.options.length) return { error: 'options' }; if (!sel.includes(i)) sel.push(i); }
    }
    if (!row.multi && sel.length > 1) return { error: 'single' };
    T('recado_poll_votes').remove(v => v.poll_id === row.id && v.voter === my);
    sel.forEach(i => T('recado_poll_votes').insert({ poll_id: row.id, voter: my, option_idx: i, created: now() }));
    return pollView(row, my);
  });

  /* ---------- eventos ---------- */
  function eventView(row, my) {
    const counts = { yes: 0, maybe: 0, no: 0 }, lists = { yes: [], maybe: [], no: [] }; let mine;
    T('recado_rsvp').all().filter(r => r.event_id === row.id && (!row.conversation_id || isMember(row.conversation_id, r.who))).sort((a, b) => a.updated - b.updated).forEach(r => {
      if (!counts.hasOwnProperty(r.answer)) return; counts[r.answer]++; lists[r.answer].push(r.who); if (r.who === my) mine = r.answer; });
    const out = { id: row.id, title: row.title, start: row.start, created: row.created, creator: row.creator, reminder: row.reminder, cancelled: !!row.cancelled, conversation: row.conversation_id || null, messageId: row.message_id, counts };
    if (mine) out.mine = mine;
    if (row.description) out.description = row.description;
    if (row.loc_label || row.loc_x != null) out.location = { x: row.loc_x, y: row.loc_y, label: row.loc_label };
    if (lists.yes.length) out.going = lists.yes; if (lists.maybe.length) out.maybe = lists.maybe; if (lists.no.length) out.notGoing = lists.no;
    return out;
  }
  const coord = v => { const n = +v; return (v === null || v === '' || !isFinite(n) || Math.abs(n) > 10000) ? null : Math.round(n * 100) / 100; };
  function scheduleReminder(row) {
    if (row.reminder < 0 || row.reminded) return;
    const ms = row.start - row.reminder * 60000 - now();
    if (ms > 30 * 60000) return;   /* no browser só se agendam os próximos 30 min */
    setTimeout(() => {
      const r = T('recado_events').all().find(x => x.id === row.id); if (!r || r.cancelled || r.reminded) return;
      T('recado_events').update(r.id, { reminded: 1 });
      const mineR = T('recado_rsvp').all().find(x => x.event_id === r.id && x.who === me());
      if (!mineR || (mineR.answer !== 'yes' && mineR.answer !== 'maybe') || !visible(me(), r)) return;
      const min = Math.round((r.start - now()) / 60000);
      LocalDB.notify('recado', '📅 ' + r.title, (min <= 1 ? 'Está a começar agora' : 'Começa daqui a ' + min + ' min') + (r.loc_label ? ' · ' + r.loc_label : ''), Object.assign({ eventId: r.id }, r.conversation_id ? { conversation: r.conversation_id } : { number: other(r, me()) }), { type: 'banner' });
    }, Math.max(0, ms));
  }
  LocalDB.register('recado.event.create', d => {
    const t = target(d); if (t.error) return t;
    const title = line(d.title, 80); if (!title) return { error: 'title' };
    const description = d.description ? text(d.description, 500) : '';
    const start = Math.floor(+d.start); if (!isFinite(start) || start < now() - 60000 || start > now() + 366 * 864e5) return { error: 'start' };
    let lx = null, ly = null, label = null;
    if (d.location && typeof d.location === 'object') {
      label = line(d.location.label, 60) || null;
      if (d.location.here === true) { lx = 215.8; ly = -810.1; label = label || 'Localização partilhada'; }   /* no browser: a posição fixa do mock do GPS */
      else if (d.location.x != null || d.location.y != null) { lx = coord(d.location.x); ly = coord(d.location.y); if (lx == null || ly == null) return { error: 'location' }; }
    } else if (d.location != null && d.location !== false) return { error: 'location' };
    let reminder = -1;
    if (d.reminder != null && d.reminder !== false && +d.reminder !== -1) { reminder = int(d.reminder); if (!REMINDERS.includes(reminder) || String(d.reminder).trim() === '') return { error: 'reminder' }; }
    const reminded = (reminder < 0 || start - reminder * 60000 <= now() + 30000) ? 1 : 0;
    const id = nextId('mock:recadoEventSeq', 'recado_events');
    const row = T('recado_events').insert({ id, message_id: null, conversation_id: t.conversation || null, creator: t.me, peer: t.number || null, title, description: description || null, start, loc_x: lx, loc_y: ly, loc_label: label, reminder, reminded, cancelled: 0, created: now() });
    const msg = send(t, 'event', title, { eventId: id }, 'event:' + id);
    if (msg.error) { T('recado_events').remove(id); return msg; }
    T('recado_events').update(id, { message_id: msg.id });
    T('recado_rsvp').remove(r => r.event_id === id && r.who === t.me);
    T('recado_rsvp').insert({ event_id: id, who: t.me, answer: 'yes', updated: now() });
    scheduleReminder(Object.assign(row, { message_id: msg.id }));
    return msg;
  });
  const loadEv = d => T('recado_events').all().find(x => x.id === int(d.eventId));
  LocalDB.register('recado.event.get', d => { const row = loadEv(d); if (!row || !visible(me(), row)) return { error: 'notfound' }; return eventView(row, me()); });
  LocalDB.register('recado.event.rsvp', d => {
    const my = me(), row = loadEv(d); if (!row || !visible(my, row)) return { error: 'notfound' };
    if (row.cancelled) return { error: 'cancelled' };
    if (row.start < now() - 3 * 3600000) return { error: 'past' };
    const a = d.answer === '' || d.answer === false ? null : d.answer;
    if (a != null && !['yes', 'maybe', 'no'].includes(a)) return { error: 'answer' };
    T('recado_rsvp').remove(r => r.event_id === row.id && r.who === my);
    if (a) T('recado_rsvp').insert({ event_id: row.id, who: my, answer: a, updated: now() });
    return eventView(row, my);
  });
  LocalDB.register('recado.event.cancel', d => {
    const my = me(), row = loadEv(d); if (!row || !visible(my, row)) return { error: 'notfound' };
    if (row.creator !== my) return { error: 'notcreator' };
    const r = T('recado_events').update(row.id, { cancelled: 1, reminded: 1 });
    return eventView(r, my);
  });

  /* ---------- GIF (fornecedor falso) ---------- */
  const GIF_COLORS = [['#128C7E', '#25D366'], ['#F43F5E', '#F59E0B'], ['#22C55E', '#0EA5E9'], ['#A855F7', '#EC4899'], ['#0F172A', '#22C55E'], ['#F97316', '#FACC15']];
  const WORDS = ['OLÁ', 'BOA', 'LOL', 'UAU', 'FIXE', 'SIM', 'NÃO', 'TOP', 'OK', 'YES', 'BRAVO', 'UPS'];
  LocalDB.register('recado.gif.search', d => {
    if (!G.get('mock:recadoGif', false)) return { error: 'nogif' };
    const q = line(d.q, 60).toUpperCase();
    return { provider: 'tenor', items: Array.from({ length: 12 }, (_, i) => {
      const [a, b] = GIF_COLORS[i % GIF_COLORS.length], w = [220, 200, 240, 180][i % 4], h = [160, 220, 140, 200][(i + 1) % 4];
      /* o texto da pesquisa entra no SVG: escapado (um «<» partia o desenho e virava "GIF indisponível") */
      const label = UI.esc((q || WORDS[i % WORDS.length]).slice(0, 10));
      const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}"><defs><linearGradient id="a" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${a}"/><stop offset="1" stop-color="${b}"/></linearGradient></defs><rect width="${w}" height="${h}" fill="url(#a)"/><circle cx="${w / 2}" cy="${h / 2 - 12}" r="${Math.min(w, h) / 5}" fill="#fff" opacity=".22"><animate attributeName="r" values="${Math.min(w, h) / 6};${Math.min(w, h) / 4};${Math.min(w, h) / 6}" dur="1.2s" repeatCount="indefinite"/></circle><text x="50%" y="${h / 2 + 34}" font-family="Arial" font-size="26" font-weight="900" fill="#fff" text-anchor="middle">${label}</text></svg>`;
      const url = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svg);
      return { url, preview: url, w, h };
    }) };
  });

  /* ---------- documentos ---------- */
  LocalDB.register('recado.doc.share', d => {
    const t = target(d); if (t.error) return t;
    const title = line(d.title, DOC_T); if (!title) return { error: 'title' };
    if (typeof d.body !== 'string') return { error: 'body' };
    if (d.body.length > DOC_B) return { error: 'toolarge', max: DOC_B };
    const body = text(d.body, DOC_B); if (!body) return { error: 'body' };
    return send(t, 'document', title, { title, body });
  });
})();
