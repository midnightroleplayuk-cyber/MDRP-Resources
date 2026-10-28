// tr_core's interaction panel. client/interact.lua sends what to show (SendDuiMessage); the page says when
// it has painted it, so the game draws it only then (a texture still holding the last one would flash).
(() => {
  const res = new URLSearchParams(location.search).get('res') || 'tr_core';
  const post = (name, data) =>
    fetch(`https://${res}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data ?? {}),
    }).catch(() => {});

  const ui = document.getElementById('ui');
  const panel = document.getElementById('panel');
  const mark = document.getElementById('mark');
  const list = document.getElementById('rows');
  const key = document.getElementById('key');
  let rows = [];
  let shown = -1;

  function render(labels) {
    rows = labels.map((text) => {
      const row = document.createElement('div');
      row.className = 'row';
      const slot = document.createElement('span');
      slot.className = 'slot';
      const label = document.createElement('span');
      label.className = 'label';
      label.textContent = String(text);
      row.append(slot, label);
      return row;
    });
    list.replaceChildren(...rows);
    ui.classList.toggle('multi', rows.length > 1);
  }

  function pick(index) {
    const selected = Math.max(0, Math.min(rows.length - 1, Number(index) | 0));
    rows.forEach((row, i) => row.classList.toggle('on', i === selected));
    ui.style.setProperty('--sel', String(selected));
  }

  // The key's width in css px (a long key name makes it wider than a square keycap), whatever zoom does
  // to measurements.
  function setKey(label) {
    key.textContent = label || 'E';
    const zoom = document.body.getBoundingClientRect().width / 400 || 1;
    ui.style.setProperty('--kw', `${Math.max(28, Math.round(key.getBoundingClientRect().width / zoom))}px`);
  }

  // Where the panel is on the page (css px, as laid out: with the first option at the key) and a row's
  // height, so the game can keep dots from under it. Offsets leave out the scroll's transform.
  function box() {
    const zoom = document.body.offsetWidth / 400 || 1;
    return {
      x: panel.offsetLeft / zoom,
      y: panel.offsetTop / zoom,
      w: panel.offsetWidth / zoom,
      h: panel.offsetHeight / zoom,
      row: mark.offsetHeight / zoom,
    };
  }

  // Two frames: the new picture is in the texture by then.
  const painted = (seq) =>
    requestAnimationFrame(() =>
      requestAnimationFrame(() => {
        shown = seq;
        post('interact:painted', { seq, box: box() });
      }),
    );

  // The labels' font loading after a paint makes them wider: the box again.
  document.fonts.addEventListener('loadingdone', () => {
    if (shown >= 0) post('interact:painted', { seq: shown, box: box() });
  });

  // Changes that mustn't animate (a new thing's options replacing the last one's).
  function instantly(fn) {
    ui.classList.add('instant');
    fn();
    void ui.offsetWidth;
    ui.classList.remove('instant');
  }

  const actions = {
    show(m) {
      instantly(() => {
        ui.dataset.state = 'hidden';
        setKey(m.key); // measured before it starts small
        render(m.rows || []);
        pick(m.selected);
      });
      ui.dataset.state = 'shown';
      painted(m.seq);
    },
    update(m) {
      instantly(() => {
        render(m.rows || []);
        pick(m.selected);
      });
      painted(m.seq);
    },
    select(m) {
      pick(m.selected);
    },
    press() {
      key.classList.remove('pressed');
      void key.offsetWidth;
      key.classList.add('pressed');
    },
    hide() {
      if (ui.dataset.state === 'shown') ui.dataset.state = 'leaving';
    },
  };

  window.addEventListener('message', (event) => {
    let m = event.data;
    if (typeof m === 'string') {
      try {
        m = JSON.parse(m);
      } catch {
        return;
      }
    }
    if (m && typeof m.action === 'string' && actions[m.action]) actions[m.action](m);
  });

  post('interact:ready');
})();
