import React, { useEffect, useState } from 'react';
import { useAppSelector } from '../../store';
import { selectSettings } from '../../store/settings';
import { Locale } from '../../store/locale';
import useNuiEvent from '../../hooks/useNuiEvent';

interface Props {
  clothesMode: boolean;
  settingsOpen: boolean;
  navPad: { left: number; right: number } | null;
  onInventory: () => void;
  onClothes: () => void;
  onSettings: () => void;
}

interface World {
  zone: string;
  weather: string;
  temp: number;
}

const Icon: React.FC<{ d: string; size?: number }> = ({ d, size = 14 }) => (
  <svg viewBox="0 0 24 24" width={size} height={size} fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
    <path d={d} />
  </svg>
);

const PATHS = {
  pin: 'M12 21s-7-5.5-7-11a7 7 0 1 1 14 0c0 5.5-7 11-7 11z M12 10a2 2 0 1 0 0-0.01',
  clock: 'M12 7v5l3 2 M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18z',
  bag: 'M6 7V6a3 3 0 0 1 6 0v1 M4 7h16l-1 13H5L4 7z',
  shirt: 'M16 3l5 4-3 3-1-1v9H7V9L6 10 3 7l5-4 1.7.9a2.3 2.3 0 0 0 4.6 0z',
  gear: 'M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z M19.4 15a1.6 1.6 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.6 1.6 0 0 0-2.7 1.1V21a2 2 0 1 1-4 0v-.1A1.6 1.6 0 0 0 7 19.4a1.6 1.6 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.6 1.6 0 0 0-1.1-2.7H1a2 2 0 1 1 0-4h.1A1.6 1.6 0 0 0 2.6 7a1.6 1.6 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.6 1.6 0 0 0 1.8.3H7a1.6 1.6 0 0 0 1-1.5V1a2 2 0 1 1 4 0v.1a1.6 1.6 0 0 0 2.7 1.1l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.6 1.6 0 0 0-.3 1.8V7a1.6 1.6 0 0 0 1.5 1H23a2 2 0 1 1 0 4h-.1a1.6 1.6 0 0 0-1.5 1z',
};

// weather category → icon path + accent colour
const WEATHER: Record<string, { d: string; color: string }> = {
  clear: {
    d: 'M12 4V2 M12 22v-2 M5 5L3.6 3.6 M20.4 20.4L19 19 M4 12H2 M22 12h-2 M5 19l-1.4 1.4 M20.4 3.6L19 5 M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z',
    color: '#f5c46a',
  },
  clouds: { d: 'M7 18a4.5 4.5 0 0 1-.5-9 6 6 0 0 1 11.5 1.5A3.5 3.5 0 0 1 17.5 18H7z', color: '#a8b3c4' },
  rain: {
    d: 'M7 14a4.5 4.5 0 0 1-.5-9 6 6 0 0 1 11.5 1.5A3.5 3.5 0 0 1 17.5 14H7z M8 18l-1 2.5 M12 18l-1 2.5 M16 18l-1 2.5',
    color: '#5aa9e6',
  },
  thunder: {
    d: 'M7 14a4.5 4.5 0 0 1-.5-9 6 6 0 0 1 11.5 1.5A3.5 3.5 0 0 1 17.5 14H10l2-0 M13 13l-3 5h2.5l-1.5 4 4-5.5h-2.5l1.5-3.5z',
    color: '#a78bfa',
  },
  snow: {
    d: 'M7 13a4.5 4.5 0 0 1-.5-9 6 6 0 0 1 11.5 1.5A3.5 3.5 0 0 1 17.5 13H7z M8.5 17h.01 M12 18.5h.01 M15.5 17h.01 M10.5 20.5h.01 M13.5 20.5h.01',
    color: '#9fd8ff',
  },
  fog: { d: 'M3 8h18 M5 12h14 M7 16h10', color: '#b7bfca' },
};

// English fallbacks; localised at render via Locale['ui_w_<cat>'].
const WEATHER_LABELS: Record<string, string> = {
  clear: 'Sunny',
  clouds: 'Cloudy',
  rain: 'Rain',
  thunder: 'Thunder',
  snow: 'Snow',
  fog: 'Fog',
};

// The clock follows the player's own locale rather than a hardcoded language.
const DTF_DATE = new Intl.DateTimeFormat(undefined, { weekday: 'short', day: 'numeric', month: 'short' });

const TopNav: React.FC<Props> = ({ clothesMode, settingsOpen, navPad, onInventory, onClothes, onSettings }) => {
  const settings = useAppSelector(selectSettings);
  const [time, setTime] = useState('--:--');
  const [date, setDate] = useState('');
  const [world, setWorld] = useState<World>({ zone: '', weather: 'clear', temp: 23 });

  useNuiEvent<World>('setWorld', (data) => setWorld((w) => ({ ...w, ...data })));

  useEffect(() => {
    const tick = () => {
      const d = new Date();
      setTime(`${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`);
      setDate(DTF_DATE.format(d));
    };
    tick();
    const id = setInterval(tick, 15000);
    return () => clearInterval(id);
  }, []);

  const active = settingsOpen ? 'settings' : clothesMode ? 'clothes' : 'inventory';
  // Os chips (localização/hora/tempo) são contexto do inventário — nas outras
  // páginas competem com o conteúdo e roubam altura, por isso saem.
  const showChips = active === 'inventory';
  const wx = WEATHER[world.weather] || WEATHER.clear;
  const wxLabel = Locale['ui_w_' + world.weather] || WEATHER_LABELS[world.weather] || '';

  return (
    <div
      className="top-nav"
      style={navPad ? { paddingLeft: navPad.left, paddingRight: navPad.right } : undefined}
    >
      <div className="top-nav-side top-nav-left">
        {showChips && settings.showLocation && (
          <span className="top-nav-chip top-nav-loc">
            <Icon d={PATHS.pin} />
            <span className="top-nav-stack">
              <span className="top-nav-main">LOS SANTOS</span>
              {world.zone && <span className="top-nav-sub">{world.zone}</span>}
            </span>
          </span>
        )}
        {showChips && settings.showClock && (
          <span className="top-nav-chip top-nav-clock">
            <Icon d={PATHS.clock} />
            <span className="top-nav-stack">
              <span className="top-nav-main">{time}</span>
              <span className="top-nav-sub">{date}</span>
            </span>
          </span>
        )}
        {showChips && settings.showTemp && (
          <span className="top-nav-chip top-nav-weather">
            <span className="top-nav-weather-ic">
              <svg viewBox="0 0 24 24" width={16} height={16} fill="none" stroke={wx.color} strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
                <path d={wx.d} />
              </svg>
            </span>
            <span className="top-nav-stack">
              <span className="top-nav-main">{world.temp}°C</span>
              <span className="top-nav-sub">{wxLabel}</span>
            </span>
          </span>
        )}
      </div>

      <div className="top-nav-tabs">
        <button className={`top-nav-tab${active === 'inventory' ? ' is-active' : ''}`} onClick={onInventory}>
          <Icon d={PATHS.bag} size={15} />
          <span>{Locale.ui_inventory || 'Inventory'}</span>
        </button>
        <button className={`top-nav-tab${active === 'clothes' ? ' is-active' : ''}`} onClick={onClothes}>
          <Icon d={PATHS.shirt} size={15} />
          <span>{Locale.ui_clothes || 'Clothes'}</span>
        </button>
        <button className={`top-nav-tab${active === 'settings' ? ' is-active' : ''}`} onClick={onSettings}>
          <Icon d={PATHS.gear} size={15} />
          <span>{Locale.ui_settings || 'Settings'}</span>
        </button>
      </div>

      {/* right side intentionally empty — keeps the tabs centred */}
      <div className="top-nav-side top-nav-right" />
    </div>
  );
};

export default TopNav;
