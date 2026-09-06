import React from 'react';
import { useAppSelector } from '../../store';
import { selectPlayerStatus, PlayerStatusState } from '../../store/playerStatus';
import { Locale } from '../../store/locale';

// Dependency-free inline icons (this fork ships no icon library).
const ICONS: Record<keyof PlayerStatusState, React.ReactNode> = {
  health: <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />,
  armour: <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z" />,
  hunger: (
    <g>
      <path d="M4 12a8 8 0 0 1 16 0H4z" />
      <rect x="4" y="13" width="16" height="2.6" rx="1.3" />
      <path d="M5.5 17h13a3 3 0 0 1-3 3h-7a3 3 0 0 1-3-3z" />
    </g>
  ),
  thirst: <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z" />,
};

const STATS: { key: keyof PlayerStatusState; label: string; lkey: string; color: string }[] = [
  { key: 'health', label: 'Vida', lkey: 'ui_health', color: '#34C77B' },
  { key: 'armour', label: 'Colete', lkey: 'ui_armour', color: '#3B82F6' },
  { key: 'hunger', label: 'Fome', lkey: 'ui_hunger', color: '#E5A93C' },
  { key: 'thirst', label: 'Sede', lkey: 'ui_thirst', color: '#38BDF8' },
];

const PlayerStatus: React.FC = () => {
  const status = useAppSelector(selectPlayerStatus);

  return (
    <div className="player-status">
      {STATS.map(({ key, label, lkey, color }) => {
        const value = Math.max(0, Math.min(100, status[key] ?? 0));
        const text = Locale[lkey] || label;
        return (
          <div className="player-status-item" key={key} title={`${text}: ${Math.round(value)}%`}>
            <div className="player-status-head">
              <div className="player-status-icon" style={{ color }}>
                <svg viewBox="0 0 24 24" width={13} height={13} fill="currentColor">
                  {ICONS[key]}
                </svg>
              </div>
              <span className="player-status-label">{text}</span>
              <span className="player-status-val">{Math.round(value)}%</span>
            </div>
            <div className="player-status-track">
              <div
                className="player-status-fill"
                style={{ width: `${value}%`, background: color, boxShadow: `0 0 8px ${color}99` }}
              />
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default PlayerStatus;
