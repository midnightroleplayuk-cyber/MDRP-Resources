'use strict';

/* Line icons for the tablet (24 x 24, drawn for this resource). Static markup only, never user data. */
const ICON_PATHS = {
  overview: '<rect x="3.5" y="3.5" width="7" height="7" rx="1.6"/><rect x="13.5" y="3.5" width="7" height="7" rx="1.6"/><rect x="3.5" y="13.5" width="7" height="7" rx="1.6"/><rect x="13.5" y="13.5" width="7" height="7" rx="1.6"/>',
  members: '<circle cx="9" cy="8" r="3.4"/><path d="M2.8 20c0-3.4 2.8-6.1 6.2-6.1s6.2 2.7 6.2 6.1"/><circle cx="17.3" cy="9" r="2.5"/><path d="M15.8 14.1c3 .2 5.4 2.6 5.4 5.9"/>',
  ranks: '<path d="M5.5 10.5L12 5l6.5 5.5"/><path d="M5.5 15L12 9.5l6.5 5.5"/><path d="M5.5 19.5L12 14l6.5 5.5"/>',
  territory: '<path d="M3 6.5l6-2.3 6 2.3 6-2.3v13.3l-6 2.3-6-2.3-6 2.3z"/><path d="M9 4.2v13.3"/><path d="M15 6.5v13.3"/>',
  treasury: '<rect x="3" y="6" width="18" height="13.5" rx="2.4"/><path d="M3 10.2h18"/><path d="M6 4.5h10"/><circle cx="16.6" cy="14.6" r="1.2"/>',
  shop: '<path d="M5.2 8.5h13.6l-1.1 11.5H6.3z"/><path d="M9 8.5V6.6a3 3 0 0 1 6 0v1.9"/>',
  contracts: '<rect x="3" y="7" width="18" height="12.5" rx="2.2"/><path d="M9 7V5.2a1.2 1.2 0 0 1 1.2-1.2h3.6A1.2 1.2 0 0 1 15 5.2V7"/><path d="M3 12.5h18"/><path d="M11 12.5v2h2v-2"/>',
  rackets: '<path d="M4 9.5l1.6-5h12.8l1.6 5"/><path d="M5 9.5V20h14V9.5"/><path d="M4 9.5c0 1.6 1.3 2.8 2.7 2.8s2.6-1.2 2.6-2.8c0 1.6 1.2 2.8 2.7 2.8s2.7-1.2 2.7-2.8c0 1.6 1.2 2.8 2.6 2.8S20 11.1 20 9.5"/><path d="M10 20v-4.5h4V20"/>',
  safehouses: '<path d="M3.5 11L12 4l8.5 7"/><path d="M5.5 9.6V20h13V9.6"/><path d="M10 20v-5.6h4V20"/>',
  business: '<path d="M9.5 3.5h5"/><path d="M10.4 3.5v5.8L5.2 18.2A1.9 1.9 0 0 0 6.9 21h10.2a1.9 1.9 0 0 0 1.7-2.8l-5.2-8.9V3.5"/><path d="M7.6 15h8.8"/>',
  diplomacy: '<path d="M4.2 4.5h10.6a1.9 1.9 0 0 1 1.9 1.9v5.8a1.9 1.9 0 0 1-1.9 1.9H9.3l-3.7 3v-3H4.2a1.9 1.9 0 0 1-1.9-1.9V6.4a1.9 1.9 0 0 1 1.9-1.9z"/><path d="M19.4 9.2h.4a1.9 1.9 0 0 1 1.9 1.9v5.6a1.9 1.9 0 0 1-1.9 1.9h-.9v3l-3.6-3h-2.7"/>',
  market: '<path d="M13.6 3.6l6.8 6.8"/><path d="M10.6 6.6l6.8 6.8"/><path d="M12.1 5.1L7.4 9.8l6.8 6.8 4.7-4.7"/><path d="M9.6 12l-6.1 6.1 2.4 2.4 6.1-6.1"/>',
  tags: '<rect x="6.5" y="8.5" width="8" height="12.5" rx="1.6"/><path d="M8.5 8.5V5.6h4v2.9"/><path d="M12.5 5.6h2.2"/><path d="M18 4h.01M20.3 6.6h.01M18 8.8h.01M20.6 11h.01"/>',
  settings: '<circle cx="12" cy="12" r="3"/><path d="M12 2.8v2.6M12 18.6v2.6M4.9 4.9l1.8 1.8M17.3 17.3l1.8 1.8M2.8 12h2.6M18.6 12h2.6M4.9 19.1l1.8-1.8M17.3 6.7l1.8-1.8"/><circle cx="12" cy="12" r="6.4"/>',
  gangs: '<circle cx="9" cy="8" r="3.4"/><path d="M2.8 20c0-3.4 2.8-6.1 6.2-6.1s6.2 2.7 6.2 6.1"/><circle cx="17.3" cy="9" r="2.5"/><path d="M15.8 14.1c3 .2 5.4 2.6 5.4 5.9"/>',
  pin: '<path d="M12 21s6.8-6.1 6.8-11.6a6.8 6.8 0 1 0-13.6 0C5.2 14.9 12 21 12 21z"/><circle cx="12" cy="9.4" r="2.4"/>',
  bolt: '<path d="M13.2 2.5L4.6 13.6h6.6l-1 7.9 8.6-11.1h-6.6z"/>',
  phone: '<rect x="7" y="2.5" width="10" height="19" rx="2.2"/><path d="M10.8 18.3h2.4"/>',
  check: '<circle cx="12" cy="12" r="8.6"/><path d="M8.2 12.2l2.6 2.6 5-5.6"/>',
  vault: '<rect x="3" y="3.5" width="18" height="16" rx="2.4"/><circle cx="12" cy="11.5" r="4.2"/><path d="M12 7.3v1.6M12 14.1v1.6M7.8 11.5h1.6M14.6 11.5h1.6"/><path d="M6 19.5v1.5M18 19.5v1.5"/>',
  pill: '<rect x="3.2" y="8.6" width="17.6" height="6.8" rx="3.4" transform="rotate(-35 12 12)"/><path d="M9.4 8.4l5.2 7.2"/>',
  parachute: '<path d="M3.5 10.5a8.5 8.5 0 0 1 17 0"/><path d="M3.5 10.5c1.4-1 2.9-1 4.3 0 1.4-1 2.9-1 4.2 0 1.4-1 2.9-1 4.2 0 1.4-1 2.9-1 4.3 0"/><path d="M3.5 10.5l7 7.5M20.5 10.5l-7 7.5M12 10.5v7.5"/><rect x="9.8" y="18" width="4.4" height="3.5" rx="0.8"/>',
  lock: '<rect x="5" y="10.8" width="14" height="10" rx="2.2"/><path d="M8.3 10.8V7.9a3.7 3.7 0 0 1 7.4 0v2.9"/>',
  back: '<path d="M14.5 18l-6-6 6-6"/>',
  close: '<path d="M6.5 6.5l11 11M17.5 6.5l-11 11"/>',
  shield: '<path d="M12 3l7.5 3v5.5c0 4.6-3.2 8.3-7.5 9.5-4.3-1.2-7.5-4.9-7.5-9.5V6z"/><path d="M9 12l2.2 2.2L15.4 10"/>',
  wifi: '<path d="M3 9.4a13.6 13.6 0 0 1 18 0"/><path d="M6 12.7a9.2 9.2 0 0 1 12 0"/><path d="M9.1 15.9a4.7 4.7 0 0 1 5.8 0"/><path d="M12 19.2h.01"/>',
  battery: '<rect x="2.5" y="7.5" width="17" height="9" rx="2"/><rect x="4.5" y="9.5" width="11" height="5" rx="1" fill="currentColor" stroke="none"/><path d="M21.5 10.5v3"/>',
};

function icon(name, cls) {
  const el = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  el.setAttribute('viewBox', '0 0 24 24');
  el.setAttribute('fill', 'none');
  el.setAttribute('stroke', 'currentColor');
  el.setAttribute('stroke-width', '1.7');
  el.setAttribute('stroke-linecap', 'round');
  el.setAttribute('stroke-linejoin', 'round');
  el.setAttribute('aria-hidden', 'true');
  if (cls) el.setAttribute('class', cls);
  el.innerHTML = ICON_PATHS[name] || ICON_PATHS.overview;
  return el;
}
