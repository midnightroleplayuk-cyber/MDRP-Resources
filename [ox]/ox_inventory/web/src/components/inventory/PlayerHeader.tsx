import React from 'react';
import { useAppSelector } from '../../store';
import { selectPlayer } from '../../store/player';
import { selectLeftInventory } from '../../store/inventory';
import { getTotalWeight } from '../../helpers';
import { BankIcon, CashIcon } from '../utils/icons/InventoryIcons';
import { Locale } from '../../store/locale';

const fmt = (v: number) => v.toLocaleString('en-US');

const getInitials = (name: string) => {
  const p = name.trim().split(/\s+/).filter(Boolean);
  if (!p.length) return '';
  return (p.length === 1 ? p[0][0] : p[0][0] + p[p.length - 1][0]).toUpperCase();
};

const RowIcon: React.FC<{ d: string }> = ({ d }) => (
  <svg viewBox="0 0 24 24" width={16} height={16} fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round">
    <path d={d} />
  </svg>
);

const Chevron = () => (
  <svg className="player-row-chevron" viewBox="0 0 24 24" width={16} height={16} fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
    <path d="M9 18l6-6-6-6" />
  </svg>
);

const PATHS = {
  faction: 'M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z M23 21v-2a4 4 0 0 0-3-3.87 M16 3.13a4 4 0 0 1 0 7.75',
  cargo: 'M20 7h-4V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z M12 12h.01',
  license: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z M14 2v6h6 M9 13h6 M9 17h4',
  registry: 'M4 19.5A2.5 2.5 0 0 1 6.5 17H20 M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z',
};

const PlayerHeader: React.FC = () => {
  const player = useAppSelector(selectPlayer);
  const left = useAppSelector(selectLeftInventory);
  const showProfileCard = useAppSelector((s) => s.settings.showProfileCard);

  if (!showProfileCard) return null;
  if (!player.name && player.accounts.length === 0) return null;

  const weight = left.maxWeight !== undefined ? Math.floor(getTotalWeight(left.items) * 1000) / 1000 : 0;
  const maxWeight = left.maxWeight ?? 0;
  const weightPct = maxWeight ? Math.min(100, (weight / maxWeight) * 100) : 0;
  const usedSlots = left.items.filter((i) => i && i.name).length;

  const cash = player.accounts.find((a) => a.name === 'money' || a.name === 'cash')?.money ?? 0;
  const bank = player.accounts.find((a) => a.name === 'bank')?.money ?? 0;
  const jobLabel = player.job?.label || player.job?.name || '—';
  const gradeLabel =
    player.job?.gradeLabel || (player.job?.grade !== undefined ? `Grade ${player.job.grade}` : '—');
  const licenses = player.licenses?.length ? player.licenses.join('  ') : '—';
  const registration =
    player.registration || (player.serverId !== undefined ? `#${String(player.serverId).padStart(5, '0')}` : '—');

  return (
    <div className="player-card">
      <div className="player-card-top">
        <div className={`player-avatar${player.mugshot ? '' : ' player-avatar-initials'}`}>
          {player.mugshot ? (
            <img className="player-avatar-img" src={player.mugshot} alt={player.name} />
          ) : (
            getInitials(player.name)
          )}
        </div>
        <div className="player-card-id">
          <div className="player-card-name-row">
            <span className="player-card-name">{player.name || 'Unknown'}</span>
          </div>
          {player.serverId !== undefined && <span className="player-id-badge">ID {player.serverId}</span>}
          <span className="player-card-org">{gradeLabel !== '—' ? `${jobLabel} · ${gradeLabel}` : jobLabel}</span>
        </div>
      </div>

      <div className="player-card-money">
        <div className="player-money-card">
          <CashIcon size={18} />
          <div className="player-money-text">
            <span className="player-money-amt">${fmt(cash)}</span>
            <span className="player-money-lbl">{Locale.ui_cash || 'Dinheiro'}</span>
          </div>
        </div>
        <div className="player-money-card">
          <BankIcon size={18} />
          <div className="player-money-text">
            <span className="player-money-amt">${fmt(bank)}</span>
            <span className="player-money-lbl">{Locale.ui_bank || 'Banco'}</span>
          </div>
        </div>
      </div>

      <div className="player-card-list">
        <div className="player-info-row">
          <span className="player-row-ic"><RowIcon d={PATHS.faction} /></span>
          <div className="player-row-text"><span className="player-row-k">{Locale.ui_faction || 'Facção'}</span><span className="player-row-v">{jobLabel}</span></div>
          <Chevron />
        </div>
        <div className="player-info-row">
          <span className="player-row-ic"><RowIcon d={PATHS.cargo} /></span>
          <div className="player-row-text"><span className="player-row-k">{Locale.ui_grade || 'Cargo'}</span><span className="player-row-v">{gradeLabel}</span></div>
          <Chevron />
        </div>
        <div className="player-info-row">
          <span className="player-row-ic"><RowIcon d={PATHS.license} /></span>
          <div className="player-row-text"><span className="player-row-k">{Locale.ui_licenses || 'Habilitações'}</span><span className="player-row-v">{licenses}</span></div>
          <Chevron />
        </div>
        <div className="player-info-row">
          <span className="player-row-ic"><RowIcon d={PATHS.registry} /></span>
          <div className="player-row-text"><span className="player-row-k">{Locale.ui_registration || 'Registro'}</span><span className="player-row-v">{registration}</span></div>
          <Chevron />
        </div>
      </div>

      <div className="player-card-footer">
        <div className="player-card-cap-head">
          <span className="player-card-cap-label">{Locale.ui_capacity || 'Capacidade'}</span>
          <span className="player-card-cap-value">
            {(weight / 1000).toFixed(1)} / {(maxWeight / 1000).toFixed(0)} kg
          </span>
        </div>
        <div className="player-card-cap-track">
          <div
            className={`player-card-cap-fill${weightPct > 85 ? ' is-full' : ''}`}
            style={{ width: `${weightPct}%` }}
          />
        </div>
        <div className="player-card-cap-foot">
          <span>{usedSlots} {Locale.ui_items || 'itens'}</span>
          <span>{Math.round(weightPct)}% {Locale.ui_full || 'cheio'}</span>
        </div>
      </div>
    </div>
  );
};

export default PlayerHeader;
