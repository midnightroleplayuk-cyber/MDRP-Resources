/* ============================================================
   OVERLAY - camadas FORA do telemóvel (painel admin, loja), 2026-10-03; janelas por cima do jogo desde 11 nov (css/ovkit.css)
   O body leva .hidden quando o telemóvel está guardado: estas camadas precisam de aparecer na mesma. Overlay.open(id)
   põe body.ov-on (o CSS mostra o body e esconde o .stage) e Overlay.close(id) tira-a quando já não há nenhuma aberta.
   O foco da NUI é do Lua (client/overlay.lua): fechar pela NUI avisa com Bridge.call('overlay', { id, open:false });
   fechar pelo Lua chega como push 'overlay:close' { id } e cada camada trata do seu (Overlay.onClose(id, fn)).
   Overlay.rpc(name, data) → OVRPC[name] no servidor (server/overlay.lua); nomes 'admin.*' só para admins.
   ============================================================ */
/* ============================================================
   CORES DA LOJA E DO PAINEL (11 nov, ovkit): o admin escolhe, para a LOJA e para o PAINEL, a cor de MARCA, a cor de
   FUNDO, a opacidade do vidro e se o jogo fica desfocado por trás (Painel › Aparência, server/admin.lua 'theme',
   GlobalState 'apex_phone:settings'.theme = { shop = { acc, bg, glass, blur }, admin = { ... } }).
   Daqui saem os tokens --k-* do css/ovkit.css (marca clara e escura, tinta sobre a marca, marca legível como texto,
   fundo, opacidade), em JS e sem color-mix (transparente no CEF), numa <style id="ovth"> no fim do <head> que passa
   por cima dos de origem. Vazio = os de origem: azul Apex (#1F5EFF) sobre o cinza escuro dos scripts Apex (#131314), vidro a 86 %.
   Fundos têm de ser ESCUROS e a marca não pode ser quase preta: o texto das duas camadas é claro (okBg / okAcc).
   O desfoque é do Lua (client/overlay.lua lê o mesmo GlobalState); a página só guarda o valor.
   ============================================================ */
window.OvTheme = (() => {
  const HEX = /^#[0-9a-fA-F]{6}$/;
  const BG_MAX = 0.07, ACC_MIN = 0.06, GLASS_MIN = 60, GLASS_MAX = 100;
  const DEF = { acc: '#1F5EFF', bg: '#131314', glass: 86 };
  const BLUR_DEF = { shop: false, admin: true };
  /* paletas prontas do painel (rótulos em PT: o tradutor do DOM trata deles; Apex e Elevate são marcas) */
  const PRESETS = [
    { id: 'apex', label: 'Apex', brand: true, acc: '#1F5EFF', bg: '#131314' },
    { id: 'elevate', label: 'Elevate', brand: true, acc: '#14C3D6', bg: '#0E1013' },
    { id: 'graphite', label: 'Grafite', acc: '#9AA6BC', bg: '#0F1013' },
    { id: 'ocean', label: 'Oceano', acc: '#0EA5E9', bg: '#071826' },
    { id: 'emerald', label: 'Esmeralda', acc: '#22C55E', bg: '#07140D' },
    { id: 'violet', label: 'Violeta', acc: '#8B5CF6', bg: '#110C22' },
    { id: 'amber', label: 'Âmbar', acc: '#F59E0B', bg: '#15100A' },
    { id: 'ruby', label: 'Rubi', acc: '#F43F5E', bg: '#180A10' },
  ];
  const rgbOf = x => { const n = parseInt(String(x).slice(1), 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
  const hexOf = a => '#' + a.map(v => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('').toUpperCase();
  const mix = (a, b, t) => a.map((v, i) => v + (b[i] - v) * t);
  const lum = a => { const f = v => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }; return 0.2126 * f(a[0]) + 0.7152 * f(a[1]) + 0.0722 * f(a[2]); };
  const W = [255, 255, 255], K = [0, 0, 0];
  const okBg = x => HEX.test(String(x || '')) && lum(rgbOf(x)) <= BG_MAX;
  const okAcc = x => HEX.test(String(x || '')) && lum(rgbOf(x)) >= ACC_MIN;
  const okGlass = g => typeof g === 'number' && isFinite(g) && g >= GLASS_MIN && g <= GLASS_MAX;
  /* o que está guardado de uma camada: '' / null = o de origem */
  const part = (p, which) => ({
    acc: p && okAcc(p.acc) ? String(p.acc).toUpperCase() : '',
    bg: p && okBg(p.bg) ? String(p.bg).toUpperCase() : '',
    glass: p && okGlass(Number(p.glass)) && p.glass !== '' && p.glass !== null ? Math.round(Number(p.glass)) : null,
    blur: p && typeof p.blur === 'boolean' ? p.blur : (BLUR_DEF[which] !== undefined ? BLUR_DEF[which] : true),
  });
  /* tokens --k-* de uma camada (sempre o conjunto inteiro) */
  function vars(p) {
    p = p || {};
    const acc = okAcc(p.acc) ? String(p.acc).toUpperCase() : DEF.acc;
    const bg = okBg(p.bg) ? String(p.bg).toUpperCase() : DEF.bg;
    const glass = okGlass(Number(p.glass)) && p.glass !== null && p.glass !== '' ? Number(p.glass) : DEF.glass;
    const A = rgbOf(acc), B = rgbOf(bg);
    /* tinta sobre a marca: branca quando chega (contraste >= 3), senão quase preta (aqua, âmbar) */
    const ink = (1.05 / (lum(A) + 0.05)) >= 3 ? '#FFFFFF' : '#06080C';
    /* a marca como TEXTO em fundo escuro: clareia até se ler (azul Apex fica #7DA0FF) */
    let t = 0; while (t < 0.8 && lum(mix(A, W, t)) < 0.26) t += 0.05;
    return {
      '--k-acc': acc, '--k-acc-rgb': A.join(', '),
      '--k-acc-hi': hexOf(mix(A, W, 0.14)), '--k-acc-lo': hexOf(mix(A, K, 0.16)),
      '--k-acc-ink': ink, '--k-acc-txt': hexOf(mix(A, W, t)),
      '--k-bg': bg, '--k-bg-rgb': B.join(', '),
      '--k-tint': (Math.max(GLASS_MIN, Math.min(GLASS_MAX, glass)) / 100).toFixed(3),
    };
  }
  const decl = o => Object.keys(o).map(k => `${k}:${o[k]}`).join(';');
  function cssOf(th) {
    th = th || {};
    return `body .pad{${decl(vars(th.admin))}}body .xs-root{${decl(vars(th.shop))}}`;
  }
  let saved = null, shown = '';
  function paint(th) {
    const css = cssOf(th); if (css === shown) return; shown = css;
    let el = document.getElementById('ovth');
    if (!el) { el = document.createElement('style'); el.id = 'ovth'; document.head.appendChild(el); }
    if (el !== document.head.lastElementChild) document.head.appendChild(el);   /* sempre depois dos <link> das camadas */
    el.textContent = css;
  }
  return {
    okBg, okAcc, okGlass, part, vars, BG_MAX, ACC_MIN, GLASS_MIN, GLASS_MAX, DEF, BLUR_DEF, PRESETS,
    /* o que está guardado no servidor (push das definições do painel) */
    set(th) { saved = th && typeof th === 'object' ? { shop: part(th.shop, 'shop'), admin: part(th.admin, 'admin') } : null; paint(saved); },
    /* pré-visualização ao vivo (rascunho do painel); restore() volta ao guardado */
    preview(th) { paint(th); },
    restore() { paint(saved); },
    get saved() { return saved; },
  };
})();
if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => OvTheme.restore()); else OvTheme.restore();

window.Overlay = (() => {
  const open = new Set(), closers = {};
  /* fora do FiveM (browser, _shot.html, _test.html) os pedidos vão a Overlay.mock[name](data) - cada módulo regista os seus */
  const mock = {};
  const sync = () => { document.body.classList.toggle('ov-on', open.size > 0); };
  function rpc(name, data, timeout) {
    if (!window.Bridge || !Bridge.inFiveM) return Promise.resolve().then(() => (mock[name] ? mock[name](data || {}) : { ok: false, error: 'nomock' }));
    if (!Bridge.call) return Promise.resolve({ ok: false, error: 'nobridge' });
    return Bridge.call('ov', { name, data: data || {}, timeout }).then(r => r || { ok: false, error: 'timeout' });
  }
  /* definições do painel admin (client/overlay.lua manda-as no arranque e a cada alteração): apps desligadas para toda a gente */
  /* defaultLang / defaultTheme: idioma e tema das contas novas escolhidos no painel (System.setDefaults) */
  const adminSettings = d => { if (!d) return; if (window.System && System.setAdminDisabled) System.setAdminDisabled(d.disabledApps); OvTheme.set(d.theme); if (window.System && System.setDefaults) System.setDefaults(d); };
  if (window.Bridge && Bridge.on) Bridge.on('admin:settings', adminSettings);
  /* o push do arranque pode chegar antes desta página: pede a lista uma vez depois de carregar */
  if (window.Bridge && Bridge.inFiveM) setTimeout(() => { Bridge.call('admin:settingsGet', {}).then(adminSettings); }, 2500);
  if (window.Bridge && Bridge.on) Bridge.on('overlay:close', d => { const id = d && d.id; if (!id || !open.has(id)) return; open.delete(id); sync(); (closers[id] || []).forEach(fn => { try { fn(false); } catch (e) { console.error(e); } }); });
  return {
    open(id) { open.add(id); sync(); },
    /* fechar pela NUI (botão, ESC): avisa o Lua para largar o foco */
    close(id) { if (!open.has(id)) return; open.delete(id); sync(); if (window.Bridge && Bridge.call) Bridge.call('overlay', { id, open: false }); },
    isOpen(id) { return id ? open.has(id) : open.size > 0; },
    /* fn(fromUI) quando a camada é fechada pelo Lua (o jogador afastou-se, morreu, o admin perdeu a permissão) */
    onClose(id, fn) { (closers[id] = closers[id] || []).push(fn); },
    rpc, mock,
  };
})();
