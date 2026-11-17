/* ============================================================
   MAIN - arranque + metadados das apps de sistema
   ============================================================ */
(() => {
  /* categorias/core das apps que não os declaram */
  const META = { safari: ['Utilitários', true], music: ['Entretenimento', true], calendar: ['Produtividade', true], clock: ['Utilitários', true], calculator: ['Utilitários', true], notes: ['Produtividade', true], reminders: ['Produtividade', false], facetime: ['Comunicação', false] };
  Object.keys(META).forEach(id => { const d = App.get(id); if (d) { d.category = d.category || META[id][0]; if (d.core === undefined || d.core === false) d.core = META[id][1]; } });
  Bridge.on('hideUI', v => document.body.classList.toggle('shot', !!v));
  Bridge.on('openApp', d => { if (!d || !d.id) return; if (System.locked) Lock.requestUnlock(() => System.openApp(d.id)); else System.openApp(d.id); });
  Bridge.on('reset', () => { System.factoryReset(); });
  /* Fase 1 - personagem: o client.lua manda `session { citizenid }` quando uma personagem carrega;
     se for outra, o System troca tudo (Store, estado, janelas) e volta a pedir a conta */
  Bridge.on('session', d => { if (d && d.citizenid != null) System.switchCharacter(String(d.citizenid)); });
  /* Fase 1 - deep links vindos do Lua: Push('openURL', { url = 'phone://app/caminho' }) (ou a string direta) */
  Bridge.on('openURL', d => { const url = typeof d === 'string' ? d : d && d.url; if (url) System.openURL(url); });
  document.addEventListener('DOMContentLoaded', () => { System.init(); });
})();
