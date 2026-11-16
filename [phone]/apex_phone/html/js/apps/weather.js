/* ===================== METEOROLOGIA - o tempo REAL do jogo =====================
   2026-09-20: acabaram as quatro cidades inventadas (Los Santos/Lisboa/Porto/Londres com Math.sin), a previsão a 10 dias e
   a hora do nascer do sol fixas. O que se mostra vem do `WX` (shell/lock.js): o tipo de tempo que está no céu (client/main.lua,
   qb-weathersync ou transição do jogo), a hora do jogo, e uma temperatura ESTIMADA a partir dos dois (o GTA não tem
   temperatura - está escrito na app). Em vez de previsão, o que JÁ esteve hoje (últimas mudanças) - dados que existem. */
App.define('weather', {
  name: 'Meteorologia', statusBar: 'dark', core: true, category: 'Utilitários', needs: ['location'],
  open(win) {
    const g = UI.g;
    /* NOVA UI (Android): os mesmos dados do WX, desenhados como a Meteorologia da Nova UI (fundo conforme o tempo, temperatura
       grande ao centro, cartões de vidro r26). O ecrã é construído UMA vez e cada mudança de tempo só troca texto e classes. */
    if (System.isAndroid && System.isAndroid()) {
      const root = UI.el(`<div class="awx"><div class="awx-top"><div class="awx-loc">${g('nav', 18)}<b></b></div><div class="awx-acts"><div class="awx-ib awx-map">${g('map', 22)}</div><div class="awx-ib awx-rf">${g('update', 22)}</div></div></div>
        <div class="awx-hero"><div class="awx-upd"></div><div class="awx-tmain"><span class="awx-temp"></span><span class="awx-hic"></span></div><div class="awx-cond"></div><div class="awx-hl"></div></div>
        <div class="awx-card awx-now"></div>
        <div class="awx-card"><div class="awx-ct">${g('clock', 16)}<span>Hoje até agora</span></div><div class="awx-hours"></div></div>
        <div class="awx-grid"></div>
        <div class="awx-card awx-sunc"></div>
        <div class="awx-note">A temperatura, o vento e a humidade são estimativas a partir do tipo de tempo e da hora do jogo: o jogo não os mede. As horas de dia e de noite são as do GTA.</div></div>`);
      const $ = s => root.querySelector(s);
      $('.awx-map').onclick = () => System.openApp('maps');
      $('.awx-rf').onclick = () => { Sound.play('click'); paint(); UI.toast('Atualizado'); };
      /* arco do sol: das 06:00 às 20:00 (as horas do GTA), com o ponto na hora do jogo */
      const sunArc = (h, night) => { const t = Math.max(0, Math.min(1, (h - 6) / 14)); const a = Math.PI * (1 - t); const cx = 150 + 120 * Math.cos(a), cy = 96 - 80 * Math.sin(a);
        return `<svg class="awx-arc" viewBox="0 0 300 110"><path d="M30 96 A120 80 0 0 1 270 96" fill="none" stroke="rgba(255,255,255,.35)" stroke-width="2" stroke-dasharray="4 6"/><line x1="12" y1="96" x2="288" y2="96" stroke="rgba(255,255,255,.35)" stroke-width="1.5"/>${night ? '' : `<circle cx="${cx.toFixed(1)}" cy="${cy.toFixed(1)}" r="9" fill="#FFD54A"/>`}</svg>`; };
      const COND = ['sunny', 'night', 'cloudy', 'rain', 'storm', 'snow', 'fog'];
      function paint() {
        const w = WX.now(), h = w.hour, hist = WX.hist();
        COND.forEach(c => root.classList.toggle('awx-' + c, w.cond === c)); root.classList.toggle('awx-dark', !!w.night);
        $('.awx-loc b').textContent = w.city;
        $('.awx-upd').textContent = w.measured ? 'Atualizado ' + UI.rel(Store.get('wxLast', {}).at || Date.now()) : 'Sem medição do servidor';
        $('.awx-temp').textContent = w.t + '°';
        $('.awx-hic').innerHTML = g(w.icon, 64);
        $('.awx-cond').textContent = w.label + (w.blackout ? ' · Apagão' : '');
        const feel = w.t + (w.wind >= 35 ? -3 : w.c === 'sunny' && !w.night ? 2 : -1);
        $('.awx-hl').textContent = `${w.hi}° / ${w.lo}°  ·  Sensação térmica ${feel}°`;
        $('.awx-now').innerHTML = `<div class="awx-ct">${g('info', 16)}<span>Agora · ${UI.pad(h)}:00 no jogo</span></div><div class="awx-nowb"><b></b><span></span></div>`;
        $('.awx-nowb b').textContent = w.label;
        $('.awx-nowb span').textContent = w.measured ? 'Tipo de tempo do servidor: ' + w.w : 'À espera do tempo do jogo: mostra-se céu limpo até chegar';
        const hh = $('.awx-hours'); hh.innerHTML = '';
        if (hist.length) hist.forEach((x, i) => { const it = UI.el(`<div class="awx-h"><span></span>${g(WX.icon(x.hour < 6 || x.hour >= 20 ? (x.c === 'sunny' ? 'night' : x.c) : x.c), 26)}<b></b></div>`); it.querySelector('span').textContent = i === hist.length - 1 ? 'Agora' : UI.pad(x.hour) + ':00'; it.querySelector('b').textContent = x.t + '°'; hh.appendChild(it); });
        else hh.appendChild(UI.el('<div class="awx-hnone">Ainda não houve mudanças de tempo desde que o telemóvel ligou.</div>'));
        const vis = w.c === 'fog' ? '2 km' : w.c === 'rain' || w.c === 'storm' ? '8 km' : w.c === 'snow' ? '5 km' : '24 km';
        const tiles = [
          ['wind', 'Vento', w.wind + ' km/h', w.wind >= 35 ? 'Forte' : w.wind >= 18 ? 'Moderado' : 'Fraco'],
          ['drop', 'Humidade', w.hum + '%', w.hum >= 85 ? 'Muito húmido' : w.hum >= 60 ? 'Húmido' : 'Seco'],
          ['eye', 'Visibilidade', vis, w.c === 'fog' ? 'Muito reduzida' : w.c === 'rain' || w.c === 'storm' || w.c === 'snow' ? 'Reduzida' : 'Clara'],
          ['thermo', 'Sensação', feel + '°', w.wind >= 35 ? 'Vento a arrefecer' : 'Semelhante à real'],
          ['bolt', 'Energia', w.blackout ? 'Apagão' : 'Normal', w.blackout ? 'A cidade está às escuras' : 'Sem falhas na cidade'],
          [w.night ? 'moon' : 'sun', w.night ? 'Noite' : 'Dia', UI.pad(h) + ':00', w.night ? 'Amanhece às 06:00' : 'Anoitece às 20:00'],
        ];
        const grid = $('.awx-grid'); grid.innerHTML = '';
        tiles.forEach(([ic, t, big, sub]) => { const c = UI.el(`<div class="awx-card awx-tile"><div class="awx-ct">${g(ic, 16)}<span></span></div><b></b><em></em></div>`); c.querySelector('.awx-ct span').textContent = t; c.querySelector('b').textContent = big; c.querySelector('em').textContent = sub; grid.appendChild(c); });
        $('.awx-sunc').innerHTML = `<div class="awx-ct">${g('sun', 16)}<span>Nascer e pôr do sol</span></div>${sunArc(h, w.night)}<div class="awx-sunr"><div><em>Nascer do sol</em><b>06:00</b></div><div><em>Pôr do sol</em><b>20:00</b></div></div>`;
      }
      paint();
      win.querySelector('.nav-stack').appendChild(root);
      /* o tempo mudou no jogo enquanto a app está aberta: repinta (só com a app à frente; a janela fechada continua viva no LRU) */
      const offA = Bridge.on('wx:changed', () => { if (System.currentApp() === 'weather') paint(); });
      const prevA = win.onClose; win.onClose = () => { offA(); prevA && prevA(); };
      return;
    }
    const render = () => {
      const w = WX.now(); const h = w.hour;
      const hist = WX.hist();
      const wx = UI.el(`<div class="wx ${w.cond}"><div class="wx-hero"><div class="city">${UI.esc(w.city)}</div><div class="temp">${w.t}°</div><div class="cond">${UI.esc(w.label)}${w.blackout ? ' · Apagão' : ''}</div><div class="hl">Máx.: ${w.hi}°  Mín.: ${w.lo}°</div></div></div>`);
      /* estado atual (o que o jogo diz) */
      const nowCard = UI.el(`<div class="wx-card"><div class="t">${g('clock', 19)} Agora · ${UI.pad(h)}:00 no jogo</div><div class="wx-now">${g(w.icon, 44)}<div><b>${UI.esc(w.label)}</b><span>${w.measured ? 'Tipo de tempo do servidor: ' + UI.esc(w.w) : 'À espera do tempo do jogo: mostra-se céu limpo até chegar'}</span></div></div></div>`);
      /* o que já esteve hoje (últimas mudanças de tempo que o telemóvel viu) */
      const hcard = UI.el(`<div class="wx-card"><div class="t">${g('calendar', 19)} Hoje até agora</div><div class="wx-hourly"></div></div>`);
      const hh = hcard.querySelector('.wx-hourly');
      if (hist.length) hist.forEach((x, i) => hh.appendChild(UI.el(`<div class="wx-h"><span>${i === hist.length - 1 ? 'Agora' : UI.pad(x.hour) + 'h'}</span>${g(WX.icon(x.hour < 6 || x.hour >= 20 ? (x.c === 'sunny' ? 'night' : x.c) : x.c))}<span>${x.t}°</span></div>`)));
      else hh.appendChild(UI.el('<div class="wx-h" style="min-width:0;align-items:flex-start;opacity:.85">Ainda não houve mudanças de tempo desde que o telemóvel ligou.</div>'));
      const vis = w.c === 'fog' ? '2 km' : w.c === 'rain' || w.c === 'storm' ? '8 km' : w.c === 'snow' ? '5 km' : '24 km';
      const grid = UI.el(`<div class="wx-grid">
        <div class="wx-card"><div class="t">${g('wind', 19)} Vento</div><div class="big">${w.wind} km/h</div><div>${w.wind >= 35 ? 'Forte' : w.wind >= 18 ? 'Moderado' : 'Fraco'}</div></div>
        <div class="wx-card"><div class="t">${g('drop', 19)} Humidade</div><div class="big">${w.hum}%</div><div>${w.hum >= 85 ? 'Muito húmido' : w.hum >= 60 ? 'Húmido' : 'Seco'}</div></div>
        <div class="wx-card"><div class="t">${g('eye', 19)} Visibilidade</div><div class="big">${vis}</div><div>${w.c === 'fog' ? 'Muito reduzida' : w.c === 'rain' || w.c === 'storm' || w.c === 'snow' ? 'Reduzida' : 'Clara'}</div></div>
        <div class="wx-card"><div class="t">${g('thermo', 19)} Sensação</div><div class="big">${w.t + (w.wind >= 35 ? -3 : w.c === 'sunny' && !w.night ? 2 : -1)}°</div><div>${w.wind >= 35 ? 'Vento a arrefecer' : 'Semelhante à real'}</div></div>
        <div class="wx-card"><div class="t">${g(w.night ? 'moon' : 'sun', 19)} ${w.night ? 'Noite' : 'Dia'}</div><div class="big">${UI.pad(h)}:00</div><div>${w.night ? 'Amanhece às 06:00' : 'Anoitece às 20:00'}</div></div>
        <div class="wx-card"><div class="t">${g('bolt', 19)} Energia</div><div class="big">${w.blackout ? 'Apagão' : 'Normal'}</div><div>${w.blackout ? 'A cidade está às escuras' : 'Sem falhas na cidade'}</div></div></div>`);
      wx.append(nowCard, hcard, grid);
      wx.appendChild(UI.el('<div class="wx-note">A temperatura, o vento e a humidade são estimativas a partir do tipo de tempo e da hora do jogo: o jogo não os mede. As horas de dia e de noite são as do GTA.</div>'));
      /* classe em vez de estilo inline: o backdrop-filter numa barra de largura total colada ao fundo era recomposto em todos os frames
         dentro do jogo, e um inline nem sequer podia ser anulado pelo bloco body.fivem de motion.css */
      const bar = UI.el(`<div class="wx-bottombar" style="position:absolute;left:0;right:0;bottom:0;padding:12px 22px calc(var(--safe-bottom) + 6px);display:flex;justify-content:space-between;align-items:center;color:#fff"><div class="mapb" style="cursor:pointer">${g('map', 24)}</div><div style="font-size:13px;opacity:.85">${w.measured ? 'Atualizado ' + UI.rel(Store.get('wxLast', {}).at || Date.now()) : 'Sem medição'}</div><div class="refresh" style="cursor:pointer">${g('rotate', 24)}</div></div>`);
      bar.querySelector('.mapb').onclick = () => System.openApp('maps');
      bar.querySelector('.refresh').onclick = () => { Sound.play('click'); render(); };
      const stack = win.querySelector('.nav-stack'); stack.innerHTML = ''; stack.append(wx, bar);
      /* PearPhone Fold: o mapa e o atualizar vão para a barra direita (a barra de baixo fica só com a hora da medição, apps.css) */
      if (UI.railFor) UI.railFor(win, { primary: [[{ icon: 'map', label: 'Mapas', onTap: () => System.openApp('maps') }, { icon: 'rotate', label: 'Atualizar', onTap: () => { Sound.play('click'); render(); } }]] });
    };
    render();
    /* o tempo mudou no jogo enquanto a app está aberta: repinta */
    const off = Bridge.on('wx:changed', () => { if (System.currentApp() === 'weather') render(); });
    const prev = win.onClose; win.onClose = () => { off(); prev && prev(); };
  }
});
