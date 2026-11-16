/* ============================================================
   I18N - tradutor do DOM, por cima do window.L (locales.js)
   ------------------------------------------------------------
   LEIA-ME
   · A CHAVE É O TEXTO DE ORIGEM EM PORTUGUÊS, tal como está no código (o mesmo do L.t).
     O motor observa o DOM (MutationObserver, tratado dentro do próprio callback, antes de
     a página pintar: nada pisca) e troca cada nó de texto e os atributos placeholder,
     title, aria-label e alt cujo texto (aparado e com os espaços colapsados) seja uma
     chave. Os espaços das pontas ficam. Guarda, por nó, a origem e o valor escrito: se a
     app escrever depois outra coisa, isso passa a ser a origem; trocar de idioma traduz
     de novo a partir da origem; 'pt' repõe a origem.
   · Chaves com %s ou %d são PADRÕES: "Recebeste %s €" casa "Recebeste 25,00 €" e o valor
     apanhado entra na tradução pela mesma ordem, ou por posição (%1$s, %2$s) quando a
     língua precisa de outra ordem. %d só casa números. Nomes de apps apanhados num
     padrão também se traduzem ("Abrir %s" + Mensagens → "Open Messages").
   · Texto escrito pelo CSS (content:'...' e content:attr(x)) também se traduz: o motor lê
     as folhas de estilo e acrescenta as regras traduzidas no fim do <head>.
   FICHEIROS DE DICIONÁRIO: html/js/i18n-<código>.js, um por idioma:
       I18N.add("de", {
         "Cancelar": "Abbrechen",
         "Recebeste %s €": "Du hast %s € erhalten"
       });
     O objeto tem de ser JSON VÁLIDO (aspas duplas, sem comentários lá dentro, sem vírgula
     no fim): o gerador dos dicionários Lua (locales/<código>.lua) lê-o assim. As frases
     destes ficheiros ganham às do locales.js e o L.t / L.tf passam a conhecê-las.
     O i18n-en.js carrega com a página; os outros só quando o idioma é escolhido, uma vez.
   ACRESCENTAR UM IDIOMA: o código tem de existir em L.NAMES e L.ORDER (locales.js); criar
     js/i18n-<código>.js; o fxmanifest já serve html/js/*.js. Lua: gerar locales/<código>.lua
     e pô-lo no fxmanifest (client_scripts). Idiomas da direita para a esquerda precisam de
     CSS próprio antes de se traduzirem.
   CONTEÚDO DO JOGADOR NUNCA SE TRADUZ (uma mensagem "Olá" ou "Sim" fica como foi escrita):
     · I18N.USER_CONTENT, mais abaixo: [seletor, 'tree'] salta o elemento e tudo o que tem
       dentro; [seletor, 'own'] salta só o texto que é filho direto (os filhos-elemento,
       como "Mensagem apagada" num <span>, continuam a traduzir-se). Mais abaixo também as
       regras por função: notificações de conversas (título/texto), nomes em linhas com avatar.
     · nomes de contactos e do próprio jogador nunca se traduzem, estejam onde estiverem
       (I18N.protectNames(fn) junta mais nomes).
     · no HTML: data-noi18n, translate="no" ou um atributo lang num elemento.
     · em código: I18N.exclude(seletor, 'tree' | 'own'); I18N.excludeIf(fn, classe).
     · nunca se mexe em value de input/textarea, contenteditable, script/style, canvas.
   HARNESS: _shot.html#home&lang=de (o localdb.js põe o idioma no `ready` do mock e
     mantém-no); por omissão o mock continua em português.
   API: I18N.add(código, obj) · I18N.t(texto[, código]) · I18N.lang · I18N.load(código)
        I18N.sweep([raiz]) · I18N.source(nó ou elemento) = texto de origem (para lógica que lê o
        DOM) · I18N.stats() · I18N.collect(true) e I18N.missing() (textos vistos no ecrã sem
        tradução, com o sítio onde apareceram: serve para encontrar chaves em falta).
   O CLIENTE (Lua) sabe o idioma pela callback NUI 'lang' { code } (arranque e cada troca) e
     traduz avisos, chat e sugestões com locales/<código>.lua (client/i18n.lua).
   ============================================================ */
window.I18N = (() => {
  const own = Object.prototype.hasOwnProperty;
  const ATTRS = ['placeholder', 'title', 'aria-label', 'alt'];   /* + os que o CSS mostra com content:attr(x) */
  const LETTER = /\p{L}/u, LOWER = /\p{Ll}/u, DIGIT = /\d/, PH = /%(?:\d+\$)?[sd]/, WSRUN = /\s{2,}|[\t\n\r\f\v\u00a0\u202f]/;
  const ANY = '([\\s\\S]+?)', NUM = '(-?\\d+(?:[.,\\u00a0\\u202f ]\\d+)*)';
  /* elementos onde nunca se entra (o TEXTAREA trata-se à parte: atributos sim, texto não) */
  const SKIP = new Set(['SCRIPT', 'STYLE', 'NOSCRIPT', 'TEMPLATE', 'IFRAME', 'CANVAS', 'VIDEO', 'AUDIO', 'PRE', 'CODE', 'OBJECT', 'EMBED']);
  const MAXLEN = 4000;   /* textos maiores não são frases da interface */

  /* ---------- estado ---------- */
  let lang = 'pt';                          /* idioma em que o DOM está escrito agora */
  const DICT = new Map();                   /* código → dicionário compilado */
  const KEYS = new Set();                   /* todas as chaves (origens em português) */
  const WT = new WeakMap();                 /* nó de texto → { s: origem, v: valor escrito, l: idioma } */
  const WA = new WeakMap();                 /* elemento → { atributo: { s, v, l } } */
  const LOADED = new Set(), FAILED = new Set(), WAIT = new Map();
  const stats = { callbacks: 0, cbMs: 0, cbMaxMs: 0, nodes: 0, writes: 0, sweeps: 0, sweepMs: 0, lastSweepMs: 0, lastSweepNodes: 0, lastCbMs: 0, lastCbNodes: 0, cssScanMs: 0 };
  let collecting = false; const MISS = new Map();
  const norm = c => (window.L && L.norm ? L.norm(c) : String(c || 'pt'));
  const PROTECT = new Set();                /* nunca se traduzem: nomes dos idiomas na própria língua */
  try { Object.keys(L.NAMES).forEach(k => PROTECT.add(L.NAMES[k])); } catch (e) {}
  /* e as marcas: "NOVA" (a pasta das ferramentas do Nova UI) passava a "NEW" pela regra das maiúsculas ("Nova" = "New") */
  ['NOVA', 'NOVA Store', 'Nova UI', 'PearPhone', 'PearOS', 'Zapp', 'Instashot', 'Vera', 'Vera Chat', 'Face Key', 'AirPods Pro 3', 'NOVA Buds 4 Pro', 'Apex Mobile'].forEach(n => PROTECT.add(n));

  /* ---------- texto: pontas e núcleo ---------- */
  const isWS = c => c <= 32 ? (c === 32 || (c >= 9 && c <= 13)) : (c === 160 || c === 0x1680 || (c >= 0x2000 && c <= 0x200a) || c === 0x2028 || c === 0x2029 || c === 0x202f || c === 0x205f || c === 0x3000 || c === 0xfeff);
  function cut(v) { let a = 0, b = v.length; while (a < b && isWS(v.charCodeAt(a))) a++; while (b > a && isWS(v.charCodeAt(b - 1))) b--; return [a, b]; }
  const reEsc = s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

  /* ---------- dicionários ---------- */
  function newDict() { return { ex: new Map(), up: null, pk: new Map(), pre: new Map(), suf: new Map(), loose: [], rev: null, cache: new Map(), rcache: new Map() }; }
  function dictOf(c) {
    let d = DICT.get(c); if (d) return d;
    d = newDict(); DICT.set(c, d);
    const base = window.L && L.dict ? L.dict(c) : null;   /* o que o locales.js já traduz (assistente, código) */
    if (base) fill(d, base);
    return d;
  }
  /* padrão: "^lit(captura)lit…$" + o que o pré-filtro precisa (prefixo, sufixo, só números, tamanho do texto fixo) */
  function compile(tpl) {
    const parts = tpl.split(/(%(?:\d+\$)?[sd])/); let re = '^', lit = '', n = 0, onlyD = true; const order = [];
    for (let i = 0; i < parts.length; i++) {
      const p = parts[i];
      if (i % 2) { const m = /^%(?:(\d+)\$)?([sd])$/.exec(p); order.push(m[1] ? +m[1] - 1 : n); n++; if (m[2] === 'd') re += NUM; else { re += ANY; onlyD = false; } }
      else if (p) { re += reEsc(p); lit += p; }
    }
    /* sem letras fixas não há nada para traduzir; com menos de 3 ("%s de %s", "%s e %s") o padrão casaria texto
       qualquer ("Rua de Lisboa"): fica só para o L.tf, que procura a chave exata */
    if (!n || (lit.match(/\p{L}/gu) || []).length < 3) return null;
    /* 1.5.2: FRACO = começa e acaba numa captura e o texto fixo são só palavras minúsculas ("%s para %s", "%s removeu %s",
       "%s e mais %s"). Casava frases inteiras de texto sem tradução: "…offline para o dia a dia" passava a "…offline to o dia
       a dia". Um padrão fraco só casa texto curto (ver runPats). */
    const pre = parts[0], suf = parts[parts.length - 1];
    const weak = pre === '' && suf === '' && parts.every((p, i) => i % 2 || /^[\s\p{Ll}-]*$/u.test(p));
    return { re: new RegExp(re + '$'), pre, suf, n, order, onlyD, len: lit.length, weak };
  }
  function bucket(m, k, p) { let a = m.get(k); if (!a) m.set(k, a = []); let i = 0; while (i < a.length && a[i].c.len >= p.c.len) i++; a.splice(i, 0, p); }   /* mais específicos primeiro */
  function place(d, p, rev) {
    const c = p.c, pre = rev ? d.rev.pre : d.pre, suf = rev ? d.rev.suf : d.suf, loose = rev ? d.rev.loose : d.loose;
    if (c.pre.length >= 2) bucket(pre, c.pre.slice(0, 2), p); else if (c.suf.length >= 2) bucket(suf, c.suf.slice(-2), p);
    else { let i = 0; while (i < loose.length && loose[i].c.len >= c.len) i++; loose.splice(i, 0, p); }
  }
  function fill(d, obj) {
    for (const k in obj) {
      if (!own.call(obj, k)) continue; const raw = obj[k]; if (typeof raw !== 'string') continue;
      const key = k.trim(), v = raw.trim(); if (!key || !v) continue;
      KEYS.add(key); d.ex.set(key, v);
      if (WSRUN.test(key)) { const nk = key.replace(/\s+/g, ' '); KEYS.add(nk); d.ex.set(nk, v); }
      /* 1.5.2: um padrão solto cuja tradução não tem letras ("%s de %s de %s" → "%s %s %s", feito para datas montadas com L.tf)
         não traduz nada no DOM, só apaga: em qualquer frase portuguesa com dois " de " tirava-os ("Conversas privadas e de grupo,
         mensagens de voz" → "Conversas privadas e grupo, mensagens voz"). Fica só para o L.tf (chave exata). */
      if (PH.test(key)) { const p = d.pk.get(key); if (p) p.v = v; else { const c = compile(key); if (c && !(c.pre === '' && c.suf === '' && !LETTER.test(v.replace(/%(?:\d+\$)?[sd]/g, '')))) { const np = { k: key, v, c }; d.pk.set(key, np); place(d, np, false); } } }
    }
    d.up = null; d.rev = null; d.cache.clear(); d.rcache.clear();
  }

  /* nomes das apps (para traduzir quando aparecem DENTRO de um padrão) */
  let capSet = null, capAt = -1e9;
  function caps() {
    const now = performance.now(); if (capSet && now - capAt < 3000) return capSet;   /* refeito no máximo a cada 3 s (apps de terceiros entram depois) */
    capAt = now; const s = new Set();
    try { const all = window.App && App.all ? App.all() : null; if (all) Object.keys(all).forEach(id => { try { s.add(App.name(id)); if (App.baseName) s.add(App.baseName(id)); } catch (e) {} }); } catch (e) {}
    return (capSet = s);
  }
  function capT(d, s) { if (!caps().has(s)) return s; const t = d.ex.get(s); return t === undefined ? s : t; }
  /* valor final de um padrão: %s/%d pela ordem dos valores apanhados, %n$s por posição */
  function render(d, v, m) { let i = 1; return v.replace(/%(?:(\d+)\$)?[sd]/g, (x, k) => { const c = k ? m[+k] : m[i++]; return c == null ? '' : capT(d, c); }); }
  function runPats(list, s, hasD, best) {
    if (!list) return best;
    for (let i = 0; i < list.length; i++) {
      const p = list[i], c = p.c;
      if (best && c.len <= best.p.c.len) break;
      if (c.onlyD && !hasD) continue;
      if (s.length <= c.len || !s.startsWith(c.pre) || !s.endsWith(c.suf)) continue;
      if (c.weak && s.length > 90) continue;
      const m = c.re.exec(s);
      /* padrão fraco: cada valor apanhado é um nome, um número, uma lista curta ("Ana removeu Rui", "Ana, Rui e mais 2"), nunca
         um pedaço de frase */
      if (m && c.weak) { let okW = true; for (let j = 1; j < m.length; j++) { const x = m[j]; if (x != null && (x.length > 32 || /[.!?]\s/.test(x))) { okW = false; break; } } if (!okW) continue; }
      if (m) return { p, m };
    }
    return best;
  }
  function matchPat(d, s, rev) {
    if (s.length > 700) return null;
    const hasD = DIGIT.test(s), T = rev ? d.rev : d;
    let best = runPats(T.pre.get(s.slice(0, 2)), s, hasD, null);
    best = runPats(T.suf.get(s.slice(-2)), s, hasD, best);
    best = runPats(T.loose, s, hasD, best);
    return best;
  }
  /* MAIÚSCULAS feitas em JS ("MENSAGENS"): procura a chave sem caixa e devolve a tradução em maiúsculas */
  function upper(d, s) {
    if (s.length < 2 || LOWER.test(s) || !LETTER.test(s)) return undefined;
    if (!d.up) { d.up = new Map(); for (const k of d.ex.keys()) { const u = k.toLocaleUpperCase('pt'); if (u !== k && !d.up.has(u)) d.up.set(u, k); } }
    const k = d.up.get(s); if (k === undefined) return undefined;
    try { return d.ex.get(k).toLocaleUpperCase(window.L && L.intl ? L.intl(lang) : undefined); } catch (e) { return d.ex.get(k).toUpperCase(); }
  }
  /* nomes de pessoas (contactos, o próprio jogador) nunca se traduzem, estejam onde estiverem: um contacto
     chamado "Mãe", "Casa" ou "Chefe" coincide muitas vezes com uma frase da interface */
  const NAMEFN = [() => (window.Contacts && Array.isArray(Contacts.cache) ? Contacts.cache.map(c => c && c.name) : []),
    () => { const p = window.System && System.player, a = window.System && System.account; return p ? [p.firstname, p.lastname, (p.firstname || '') + ' ' + (p.lastname || ''), a && a.username] : []; }];
  let nameSet = new Set(), namesAt = -1e9;
  function isName(s) {
    const now = performance.now();
    if (now - namesAt > 2000) { namesAt = now; const n = new Set(); NAMEFN.forEach(f => { try { (f() || []).forEach(x => { if (x != null) { const v = String(x).trim(); if (v) n.add(v); } }); } catch (e) {} }); nameSet = n; }
    return nameSet.has(s);
  }
  /* tradução de um núcleo (sem espaços nas pontas) ou null */
  function tr(d, core) {
    if (PROTECT.has(core) || isName(core)) return null;
    let r = d.cache.get(core); if (r !== undefined) return r;
    r = d.ex.get(core);
    if (r === undefined && WSRUN.test(core)) r = d.ex.get(core.replace(/\s+/g, ' '));
    /* os padrões também com os espaços normalizados: "Máx.&nbsp;26°" ou "Máx.: 26°  Mín.: 18°" (espaço que não parte, dois
       espaços) não casavam a chave e ficavam em português */
    if (r === undefined) { let b = matchPat(d, core, false); if (!b && WSRUN.test(core)) b = matchPat(d, core.replace(/\s+/g, ' '), false); if (b) r = render(d, b.p.v, b.m); }
    if (r === undefined) r = upper(d, core);
    if (r === undefined) r = null;
    if (d.cache.size > 40000) d.cache.clear();
    d.cache.set(core, r);
    return r;
  }
  /* ---------- origem de um texto escrito noutro idioma (L.t / L.tf já traduzidos) ---------- */
  function revOf(d) {
    if (d.rev) return d.rev;
    const R = d.rev = { ex: new Map(), pre: new Map(), suf: new Map(), loose: [] };
    for (const [k, v] of d.ex) if (!PH.test(k) && !R.ex.has(v)) R.ex.set(v, k);
    for (const p of d.pk.values()) { const c = compile(p.v); if (c && c.n === p.c.n) place(d, { k: p.k, v: p.k, c }, true); }
    return R;
  }
  function recoverCore(d, core) {
    let r = d.rcache.get(core); if (r !== undefined) return r;
    const R = revOf(d); r = R.ex.get(core);
    if (r === undefined && WSRUN.test(core)) r = R.ex.get(core.replace(/\s+/g, ' '));
    if (r === undefined) { const b = matchPat(d, core, true); if (b) { const vals = []; b.p.c.order.forEach((k, j) => { vals[k] = b.m[j + 1]; }); let i = 0; r = b.p.k.replace(/%[sd]/g, () => { const x = vals[i++]; return x == null ? '' : x; }); } }
    if (r === undefined) r = null;
    if (d.rcache.size > 20000) d.rcache.clear();
    d.rcache.set(core, r);
    return r;
  }
  /* v foi escrito pela app quando o idioma era `from`: devolve a origem portuguesa (ou o próprio v) */
  function recover(v, from) {
    if (from === 'pt') return v;
    const d = DICT.get(from); if (!d) return v;
    const [a, b] = cut(v); if (a >= b) return v; const core = a || b < v.length ? v.slice(a, b) : v;
    if (KEYS.has(core) || isName(core) || tr(d, core) !== null) return v;   /* já é uma origem (ou um nome) */
    const k = recoverCore(d, core);
    return k == null ? v : v.slice(0, a) + k + v.slice(b);
  }
  /* origem → texto no idioma atual (mantém as pontas) */
  function translate(src, where) {
    if (lang === 'pt') return src;
    const d = DICT.get(lang); if (!d) return src;
    const [a, b] = cut(src); if (a >= b) return src; const core = a || b < src.length ? src.slice(a, b) : src;
    const t = tr(d, core);
    if (t === null) { if (collecting) miss(core, where); return src; }
    return a || b < src.length ? src.slice(0, a) + t + src.slice(b) : t;
  }
  function miss(core, where) {
    if (!LETTER.test(core) || MISS.size > 20000) return;
    const m = MISS.get(core); if (m) { m.n++; return; }
    let w = ''; try { const el = where && (where.nodeType === 1 ? where : where.parentElement); const win = el && el.closest && el.closest('[data-app]'); w = (win ? win.dataset.app + ' ' : '') + (el ? el.tagName.toLowerCase() + (typeof el.className === 'string' && el.className.trim() ? '.' + el.className.trim().split(/\s+/).slice(0, 2).join('.') : '') : ''); } catch (e) {}
    MISS.set(core, { n: 1, where: w });
  }

  /* ---------- exclusões (conteúdo do jogador) ---------- */
  /* índices: pela classe do último composto, senão pela etiqueta (b, span, p…), senão genéricos (testados em todos) */
  const EXC = { tree: { cls: new Map(), tag: new Map(), gen: [], sel: '' }, own: { cls: new Map(), tag: new Map(), gen: [], sel: '' }, fn: new Map() };
  function lastCompound(s) { let depth = 0, at = 0; for (let i = 0; i < s.length; i++) { const c = s[i]; if (c === '[' || c === '(') depth++; else if (c === ']' || c === ')') depth--; else if (!depth && (c === ' ' || c === '>' || c === '+' || c === '~')) at = i + 1; } return s.slice(at); }
  function splitSel(s) { const out = []; let depth = 0, at = 0; for (let i = 0; i < s.length; i++) { const c = s[i]; if (c === '(' || c === '[') depth++; else if (c === ')' || c === ']') depth--; else if (c === ',' && !depth) { out.push(s.slice(at, i)); at = i + 1; } } out.push(s.slice(at)); return out.map(x => x.trim()).filter(Boolean); }
  function exclude(selector, mode) {
    const T = mode === 'own' ? EXC.own : EXC.tree;
    splitSel(String(selector || '')).forEach(s => {
      try { document.createDocumentFragment().querySelector(s); } catch (e) { console.warn('[i18n] seletor inválido', s); return; }
      const last = lastCompound(s), m = /\.([\w-]+)/.exec(last), tg = /^[a-z][a-z0-9-]*/i.exec(last);
      if (m) { const key = m[1], cur = T.cls.get(key); if (s === '.' + key || cur === true) T.cls.set(key, true); else T.cls.set(key, cur ? cur + ',' + s : s); }
      else if (tg) { const key = tg[0].toUpperCase(), cur = T.tag.get(key); T.tag.set(key, cur ? cur + ',' + s : s); }
      else { T.gen.push(s); T.sel = T.gen.join(','); }
    });
  }
  /* fn(el) → true = conteúdo do jogador; só é chamada para elementos com a classe `cls` */
  function excludeIf(fn, cls) { if (typeof fn !== 'function' || !cls) return; const a = EXC.fn.get(cls) || []; a.push(fn); EXC.fn.set(cls, a); }
  function hit(T, el) {
    const cl = el.classList;
    if (cl) for (let i = 0; i < cl.length; i++) { const s = T.cls.get(cl[i]); if (s !== undefined && (s === true || el.matches(s))) return true; }
    const ts = T.tag.get(el.tagName); if (ts !== undefined && el.matches(ts)) return true;
    return T.sel !== '' && el.matches(T.sel);
  }
  function excluded(el) {
    if (SKIP.has(el.tagName)) return true;
    if (el.hasAttribute('data-noi18n') || el.hasAttribute('lang') || el.getAttribute('translate') === 'no') return true;
    const ce = el.getAttribute('contenteditable'); if (ce !== null && ce !== 'false') return true;
    if (hit(EXC.tree, el)) return true;
    if (EXC.fn.size) { const cl = el.classList; if (cl) for (let i = 0; i < cl.length; i++) { const fs = EXC.fn.get(cl[i]); if (fs) for (const f of fs) { try { if (f(el)) return true; } catch (e) {} } } }
    return false;
  }
  const ownOff = el => !el || el.nodeType !== 1 || el.tagName === 'TEXTAREA' || hit(EXC.own, el);

  /* ---------- escrever ---------- */
  function doText(n, from, force) {
    const v = n.nodeValue, r = WT.get(n); let src;
    stats.nodes++;
    if (r !== undefined && r.v === v) { if (!force && r.l === lang) return; src = r.s; }
    else if (!v || v.length > MAXLEN || !LETTER.test(v)) { if (r !== undefined) WT.delete(n); return; }
    else src = recover(v, from);
    const out = translate(src, n);
    if (out !== v) { n.nodeValue = out; stats.writes++; }
    if (out !== src) WT.set(n, { s: src, v: out, l: lang }); else if (r !== undefined) WT.delete(n);
  }
  function doAttr(el, a, from, force) {
    const v = el.getAttribute(a); let rs = WA.get(el); const r = rs && rs[a]; let src;
    if (r && r.v === v) { if (!force && r.l === lang) return; src = r.s; }
    else if (!v || v.length > MAXLEN || !LETTER.test(v)) { if (r) delete rs[a]; return; }
    else src = recover(v, from);
    const out = translate(src, el);
    if (out !== v) { el.setAttribute(a, out); stats.writes++; }
    if (out !== src) { if (!rs) WA.set(el, rs = {}); rs[a] = { s: src, v: out, l: lang }; } else if (r) delete rs[a];
  }
  function attrs(el, from, force) { if (!el.hasAttributes()) return; for (let i = 0; i < ATTRS.length; i++) if (el.hasAttribute(ATTRS[i])) doAttr(el, ATTRS[i], from, force); }
  /* percorre os filhos de root (sem recursão): elementos excluídos saltam-se com tudo o que têm dentro */
  function walk(root, from, force) {
    let n = root.firstChild;
    while (n) {
      let down = false;
      if (n.nodeType === 3) { if (!ownOff(n.parentNode)) doText(n, from, force); }
      else if (n.nodeType === 1) { if (!excluded(n)) { attrs(n, from, force); down = n.firstChild !== null && n.tagName !== 'TEXTAREA'; } }
      if (down) { n = n.firstChild; continue; }
      while (n !== root && n.nextSibling === null) n = n.parentNode;
      if (n === root) break;
      n = n.nextSibling;
    }
  }
  /* texto de origem (português) de um nó de texto ou de um elemento inteiro */
  function srcText(n) {
    if (!n) return '';
    if (n.nodeType === 3) { const r = WT.get(n); return r && r.v === n.nodeValue ? r.s : n.nodeValue; }
    if (n.nodeType !== 1) return '';
    let out = ''; const tw = document.createTreeWalker(n, NodeFilter.SHOW_TEXT); let x;
    while ((x = tw.nextNode())) { const r = WT.get(x); out += r && r.v === x.nodeValue ? r.s : x.nodeValue; }
    return out;
  }
  /* o elemento (ou um antepassado) está excluído? memo por callback */
  function blocked(el, memo) {
    let r = memo.get(el); if (r !== undefined) return r;
    const chain = [], top = document.documentElement; let e = el; r = false;
    /* sobe até ao <body> (o <html lang="…"> não conta como "conteúdo noutra língua") */
    while (e && e.nodeType === 1 && e !== top) { const m = memo.get(e); if (m !== undefined) { r = m; break; } chain.push(e); if (excluded(e)) { r = true; break; } e = e.parentElement; }
    for (let i = 0; i < chain.length; i++) memo.set(chain[i], r);
    return r;
  }

  /* ---------- observador ---------- */
  const mo = typeof MutationObserver === 'function' ? new MutationObserver(onMut) : null;
  let observing = false;
  function onMut(list) {
    if (lang === 'pt') return;
    const t0 = performance.now(), n0 = stats.nodes, memo = new Map();
    for (let i = 0; i < list.length; i++) {
      const m = list[i], t = m.target;
      if (m.type === 'childList') {
        const add = m.addedNodes; if (!add.length || !t.isConnected || blocked(t.nodeType === 1 ? t : t.parentElement || t, memo)) continue;
        for (let j = 0; j < add.length; j++) {
          const n = add[j]; if (!n.isConnected) continue;
          if (n.nodeType === 3) { if (!ownOff(t)) doText(n, lang, false); }
          else if (n.nodeType === 1) { if (!excluded(n)) { attrs(n, lang, false); if (n.tagName !== 'TEXTAREA') walk(n, lang, false); } }
        }
      } else if (m.type === 'characterData') {
        if (!t.isConnected) continue; const p = t.parentNode;
        if (!p || p.nodeType !== 1 || blocked(p, memo) || ownOff(p)) continue;
        doText(t, lang, false);
      } else if (m.type === 'attributes') {
        if (!t.isConnected || blocked(t, memo)) continue;
        doAttr(t, m.attributeName, lang, false);
      }
    }
    if (mo) mo.takeRecords();   /* as escritas acima são nossas */
    const ms = performance.now() - t0;
    stats.callbacks++; stats.cbMs += ms; stats.lastCbMs = ms; stats.lastCbNodes = stats.nodes - n0; if (ms > stats.cbMaxMs) stats.cbMaxMs = ms;
  }
  function connect() { if (!mo || !document.body) return; mo.observe(document.body, { childList: true, subtree: true, characterData: true, attributes: true, attributeFilter: ATTRS.slice() }); observing = true; }
  function disconnect() { if (!mo || !observing) return; mo.takeRecords(); mo.disconnect(); observing = false; }

  /* ---------- CSS: content:'texto' e content:attr(x) ---------- */
  let cssList = null, cssEl = null;
  function cssScan() {
    cssList = [];
    const scan = rules => { for (let i = 0; i < rules.length; i++) { const r = rules[i];
      if (r.cssRules && !r.style) { scan(r.cssRules); continue; }
      if (!r.style || !r.selectorText) continue;
      const c = r.style.getPropertyValue('content'); if (!c || c === 'none' || c === 'normal') continue;
      const q = /^\s*(["'])((?:\\.|(?!\1).)*)\1\s*$/.exec(c);
      if (q && LETTER.test(q[2])) cssList.push({ sel: r.selectorText, src: q[2].replace(/\\(.)/g, '$1'), imp: r.style.getPropertyPriority('content') });
      const a = /attr\(\s*([\w-]+)\s*\)/.exec(c); if (a && !ATTRS.includes(a[1].toLowerCase())) ATTRS.push(a[1].toLowerCase());
    } };
    for (const sh of Array.from(document.styleSheets)) { if (sh.ownerNode && sh.ownerNode.id === 'i18n-css') continue; let rules = null; try { rules = sh.cssRules; } catch (e) { rules = null; } if (rules) scan(rules); }
  }
  function cssApply() {
    if (!cssList || !cssList.length) return;
    const d = DICT.get(lang); let txt = '';
    if (lang !== 'pt' && d) cssList.forEach(x => { const t = tr(d, x.src); if (t !== null) txt += x.sel + '{content:"' + t.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\A ') + '"' + (x.imp ? ' !important' : '') + '}\n'; });
    if (!cssEl) { if (!txt) return; cssEl = document.createElement('style'); cssEl.id = 'i18n-css'; }
    if (cssEl.textContent !== txt) cssEl.textContent = txt;
    if (!cssEl.isConnected || cssEl !== document.head.lastElementChild) document.head.appendChild(cssEl);   /* sempre a última: ganha aos empates */
  }

  /* ---------- varrer o documento todo ---------- */
  function sweepAll(from) {
    const b = document.body; if (!b) return;
    const t0 = performance.now(), n0 = stats.nodes;
    if (mo && observing) mo.takeRecords();   /* o que estava pendente é revisto aqui */
    /* 1.ª vez fora do português: lê as folhas de estilo (texto do CSS e os atributos de content:attr) ANTES de varrer */
    if (lang !== 'pt' && !cssList) { const n = ATTRS.length, c0 = performance.now(); try { cssScan(); } catch (e) { cssList = []; } stats.cssScanMs = performance.now() - c0; if (ATTRS.length !== n && observing) connect(); }
    if (!excluded(b)) { attrs(b, from, true); walk(b, from, true); }
    try { cssApply(); } catch (e) { console.warn('[i18n] css', e); }
    if (mo && observing) mo.takeRecords();
    const ms = performance.now() - t0;
    stats.sweeps++; stats.sweepMs += ms; stats.lastSweepMs = ms; stats.lastSweepNodes = stats.nodes - n0;
  }
  /* mudar de idioma. Um idioma ainda por carregar espera pelo seu ficheiro (alguns ms): o ecrã fica no
     idioma anterior em vez de piscar em português pelo meio */
  let pending = null;
  function setLang(code) {
    code = norm(code); report(false);
    if (code !== 'pt' && !LOADED.has(code) && !FAILED.has(code)) {
      pending = code; dictOf(code);
      load(code).then(() => { if (pending === code) { pending = null; switchTo(code); } });
      return;
    }
    pending = null; switchTo(code);
  }
  /* o que está no ecrã foi escrito em `prev` */
  function switchTo(code) {
    const prev = lang; if (code === prev) return;
    lang = code; if (code !== 'pt') dictOf(code);
    sweepAll(prev);
    if (code === 'pt') disconnect(); else if (!observing) connect();
  }
  /* chegou um dicionário do idioma atual: tudo outra vez (num microtask, junta vários add seguidos) */
  let resweepQ = false;
  function resweep() { if (resweepQ) return; resweepQ = true; Promise.resolve().then(() => { resweepQ = false; if (lang !== 'pt') sweepAll(lang); }); }

  /* ---------- carregar os dicionários ---------- */
  const ME = (() => { try { const s = document.currentScript && document.currentScript.src; const m = s && /^(.*\/)i18n\.js(\?[^#]*)?/.exec(s); if (m) return { base: m[1], q: m[2] || '' }; } catch (e) {} return { base: 'js/', q: '' }; })();
  function load(c) {
    c = norm(c);
    if (c === 'pt' || LOADED.has(c)) return Promise.resolve(true);
    if (FAILED.has(c)) return Promise.resolve(false);
    let p = WAIT.get(c); if (p) return p;
    p = new Promise(res => {
      const s = document.createElement('script'); s.src = ME.base + 'i18n-' + c + '.js' + ME.q; s.async = true;
      s.onload = () => { WAIT.delete(c); LOADED.add(c); res(true); };
      s.onerror = () => { WAIT.delete(c); FAILED.add(c); console.warn('[i18n] sem dicionário para ' + c + ' (js/i18n-' + c + '.js)'); res(false); };
      (document.head || document.documentElement).appendChild(s);
    });
    WAIT.set(c, p); return p;
  }
  function add(c, obj) {
    if (!obj || typeof obj !== 'object') return;
    c = norm(c); if (c === 'pt') return;
    if (window.L && L.add) L.add(c, obj);    /* o L.t / L.tf conhecem as mesmas frases */
    fill(dictOf(c), obj);
    LOADED.add(c);
    if (c === lang) resweep();
  }

  /* ---------- o cliente (Lua) precisa de saber o idioma: avisos do jogo, chat, sugestões ---------- */
  let sent = null;
  function report(force) {
    const c = window.L ? L.code : lang; if (!force && c === sent) return; sent = c;
    try { if (window.Bridge && Bridge.call) Bridge.call('lang', { code: c }); } catch (e) {}
  }

  /* ---------- conteúdo do jogador: lista de origem ----------
     Seletores dos textos escritos por jogadores (ou vindos deles: nomes, mensagens, publicações, notas,
     e-mails, anúncios). 'own' = só o texto direto do elemento (os <span> de sistema lá dentro traduzem-se). */
  const USER_CONTENT = [
    /* sistema */
    ['#setup .hello, #setup .hello-hint, .akb-spl', 'tree'],                     /* "olá" do assistente em cada língua; nome do teclado */
    ['.avatar, .n-avwrap, .n-person, .wg.ext, .wx-tpl', 'tree'],                 /* iniciais; widgets de recursos externos */
    ['.vera-msg.user, .vera-bubble, .aai-b, .aic-b', 'tree'],                    /* o que se disse à Vera; Vera Chat (pergunta e resposta) */
    ['.isl-name, .island .grow, .cs-name, .ic-name, .ft-name, [data-hook="name"], .dial-hint', 'tree'],   /* quem liga */
    ['.wg-notes .bd > .t, .wg-notes .bd > .t ~ .s, .wg-notes .bd > div > .t, .wg-notes .bd > div > .s, .aw-nt-r, .aw-nt-c, .aw-rm-r span', 'tree'],   /* widgets: notas, lembretes */
    /* Mensagens */
    ['.bubble, .msl-sub', 'own'],                                                /* o texto da bolha (os <span> de sistema traduzem-se) */
    ['.bubble .reply, .bubble.ct, .msg-from, .msg-qo, .msl-top b, .msg-htx b, .pb-tx span, .rq span', 'tree'],
    /* Telefone, Contactos, FaceCall */
    ['[data-app="phone"] .li-label > span, .profile > .name', 'tree'],
    /* Mail */
    ['.mr-subj, .mr-name, [data-app="mail"] .prev, .mail-body, .mail-meta .subj, .mm-name, .amail-who, .amail-subj, .amail-prev, .amail-rsubj, .amail-fw', 'tree'],
    /* Zapp */
    ['.rc-name, .rc-prev, .rcb-text, .rcb-from, .rcb-quote, .rcb-xcard-tx, .rcb-doc, .rcb-vw-cap, .rcc-row-n, .rcu-card-n, .rcu-thumb-t, .rcu-v-text, .rcu-v-cap, .rcu-post-txt, .rcp-hero-name, .rcp-join-name, .rcp-join-d, .rcx-voters-q', 'tree'],
    /* Instashot, Twix, Reels, DMs, Stories, Instants */
    ['.ig-cap, .tw-t, .bio, .ta.bio, .rbot p, .ig-cmt-row .tx, .ig-loc, .igdm-b-txt, .igdm-b, .igdm-head-t b, .st-txt, .st-chip span, .st-card .q, .st-card .opts, .ins-txt', 'tree'],
    /* DarkChat, Marketplace, Onion */
    ['[data-app="darkchat"] .anon, [data-app="darkchat"] .li-sub, .mk-title, .mk-info h2, .mk-info p, .ta.d, .on-ct, .on-cs, .on-handle', 'tree'],
    /* Faturas, Carteira, Serviços, AppShop (avaliações), Match, Encontrar, Garagem */
    ['[data-app="billing"] .bt, [data-app="billing"] .bs, .wl-cname, .wl-tb > b, .awal-tb > b, .rd, .astore-revt, .astore-revh, .rx, .mt-bio, .f-bio, .mt-me-name, .mt-convo-t, .mt-tile > span, .fm-rb > b, .afind-htx b, .gr-name, .plate', 'tree'],
    /* Notas, Lembretes, Calendário, Relógio (nome dos alarmes), Música (listas) */
    ['[data-app="notes"] .li[class*="nid-"] .li-body, .anote-page, .anote-t, .anote-rb, [data-app="reminders"] .li-label, .aw-rm-r, .acal-eb b, .acal-dtitle b, [data-app="calendar"] .li-label > .row, .aclk-al-n, .vm-plname, .aw-cal-ev b', 'tree'],
  ];
  USER_CONTENT.forEach(([s, m]) => exclude(s, m));
  /* notificações: o título e o texto de uma notificação de conversa são do jogador (nome e mensagem);
     as do sistema (Carteira, Definições, Faturas, ...) traduzem-se. 't' = título, 'm' = texto */
  const NOTIF_USER = { messages: 'tm', recado: 'tm', groups: 'tm', mail: 'tm', darkchat: 'tm', instashot: 'tm', twix: 'tm', reels: 'tm', phone: 't', facetime: 't' };
  let idApp = null, idAppAt = -1e9;
  const appIdByName = nm => { const now = performance.now(); if (!idApp || now - idAppAt > 5000) { idAppAt = now; idApp = new Map(); try { const all = App.all(); Object.keys(all).forEach(id => { try { idApp.set(App.name(id), id); if (App.baseName) idApp.set(App.baseName(id), id); } catch (e) {} }); } catch (e) {} } return idApp.get(nm) || null; };
  /* a notificação de que o elemento faz parte (cartão do PearOS, painel rápido / flutuante da Nova UI, banner) */
  function notifItem(el) {
    const card = el.closest('.notif-card, .qp-nc, .ahn-card, .nbanner');
    if (card && card.dataset.id && window.Notify && Notify.all) { const id = card.dataset.id; return Notify.all().find(x => x && String(x.id) === id) || null; }
    return null;
  }
  function notifApp(el) {
    const n = notifItem(el); if (n) return n.app;
    const box = el.closest('.ncard, .n-x, .nbanner, .island'); if (!box) return null;
    if (box.querySelector('.n-avwrap, .n-person')) return 'messages';
    const a = box.querySelector('.n-app, .n-xapp, .n-t'); return a ? appIdByName(srcText(a).trim()) : null;
  }
  /* data.sys (servidor, 1.1.8): texto de SISTEMA numa app cujas notificações são normalmente do jogador - "@ana respondeu-te",
     "%s adicionou-te ao grupo", "Chamada de grupo não atendida", "3 mensagens por ler em 2 conversas". true = título e texto,
     't' / 'm' = só uma das partes. Essas partes traduzem-se como as de qualquer outra app; sem a marca fica tudo como antes
     (era isto que deixava estas frases em português em qualquer idioma). */
  const notifPart = part => el => { const n = notifItem(el); const s = n && n.data && n.data.sys; if (s === true || (typeof s === 'string' && s.indexOf(part) >= 0)) return false; const app = n ? n.app : notifApp(el); const f = app && NOTIF_USER[app]; return !!(f && f.indexOf(part) >= 0); };
  ['n-title', 'n-xtitle', 'n-m'].forEach(c => excludeIf(notifPart('t'), c));
  ['n-msg', 'n-xmsg'].forEach(c => excludeIf(notifPart('m'), c));
  /* Calendário: o título do evento por cima da hora na folha de edição */
  excludeIf(el => { const n = el.nextElementSibling; return !!(n && n.classList.contains('picker')); }, 'group-header');
  /* nome de pessoa numa linha com avatar (contactos em qualquer lista) */
  excludeIf(el => { const li = el.parentElement && el.parentElement.parentElement; return !!(li && li.classList.contains('li') && li.querySelector(':scope > .avatar')); }, 'li-label');

  /* ---------- arranque ---------- */
  function init() {
    if (window.L && L.onChange) L.onChange(c => { try { setLang(c); } catch (e) { console.error('[i18n]', e); } });
    if (window.Bridge && Bridge.on) { Bridge.on('ready', () => report(true)); Bridge.on('session:changed', () => setTimeout(() => report(true), 0)); Bridge.on('lang:report', () => report(true)); /* /phonelang in F8 */ }
    const start = () => { if (window.L && L.code !== lang) setLang(L.code); setTimeout(() => report(false), 4000); };
    if (document.body) start(); else document.addEventListener('DOMContentLoaded', start);
  }
  init();

  return {
    add, load, exclude, excludeIf, USER_CONTENT, ATTRS,
    get lang() { return lang; },
    loaded: c => LOADED.has(norm(c)),
    /* traduz um texto solto para o idioma atual (ou o pedido); sem tradução devolve-o igual */
    t: (s, c) => { const k = c ? norm(c) : lang; if (k === 'pt' || s == null) return s; const d = dictOf(k); const v = String(s), [a, b] = cut(v); if (a >= b) return v; const t = tr(d, v.slice(a, b)); return t === null ? v : v.slice(0, a) + t + v.slice(b); },
    get pending() { return pending; },
    /* origem portuguesa de um nó de texto, ou do texto todo de um elemento */
    source: srcText,
    /* mais nomes de pessoas a proteger: fn() → lista de nomes */
    protectNames: fn => { if (typeof fn === 'function') { NAMEFN.push(fn); namesAt = -1e9; } },
    sweep: root => { if (lang === 'pt') return; if (root && root.nodeType === 1) { const memo = new Map(); if (!blocked(root, memo)) { attrs(root, lang, true); walk(root, lang, true); } if (mo) mo.takeRecords(); } else sweepAll(lang); },
    stats: () => Object.assign({ lang, observing, keys: KEYS.size, dicts: [...DICT.keys()], loaded: [...LOADED], failed: [...FAILED] }, stats),
    resetStats: () => { Object.keys(stats).forEach(k => { stats[k] = 0; }); },
    collect: on => { collecting = on !== false; if (collecting) MISS.clear(); },
    missing: () => [...MISS.entries()].sort((a, b) => b[1].n - a[1].n).map(([s, o]) => ({ s, n: o.n, where: o.where })),
    report: () => report(true),
  };
})();
