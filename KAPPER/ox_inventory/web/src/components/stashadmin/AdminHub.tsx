import React from 'react';
import { CraftIcon, GearIcon, ShopIcon, StashIcon } from './icons';

type Section = 'stashes' | 'craft' | 'shops' | 'settings';

interface Props {
  onPick: (section: Section) => void;
  onClose: () => void;
  counts: { stashes: number; craft: number; shops: number };
}

const CARDS: { key: Section; label: string; desc: string; Icon: React.FC<{ size?: number }> }[] = [
  { key: 'stashes', label: 'Stashes', desc: 'Storage containers', Icon: StashIcon },
  { key: 'craft', label: 'Crafting', desc: 'Crafting benches', Icon: CraftIcon },
  { key: 'shops', label: 'Shops', desc: 'Stores & vendors', Icon: ShopIcon },
  { key: 'settings', label: 'Settings', desc: 'Markers & blips', Icon: GearIcon },
];

// Initial selector — big cards centered, choose what to manage.
const AdminHub: React.FC<Props> = ({ onPick, onClose, counts }) => (
  <div className="hub-overlay">
    <div className="hub-panel">
      <button className="hub-x" onClick={onClose} title="Close">
        <svg xmlns="http://www.w3.org/2000/svg" height="0.9em" viewBox="0 0 400 528">
          <path d="M376.6 84.5c11.3-13.6 9.5-33.8-4.1-45.1s-33.8-9.5-45.1 4.1L192 206 56.6 43.5C45.3 29.9 25.1 28.1 11.5 39.4S-3.9 70.9 7.4 84.5L150.3 256 7.4 427.5c-11.3 13.6-9.5 33.8 4.1 45.1s33.8 9.5 45.1-4.1L192 306 327.4 468.5c11.3 13.6 31.5 15.4 45.1 4.1s15.4-31.5 4.1-45.1L233.7 256 376.6 84.5z" />
        </svg>
      </button>

      <div className="hub-header">
        <div className="hub-badge">
          <StashIcon size={22} />
        </div>
        <div>
          <p className="hub-title">OX MANAGER</p>
          <span className="hub-sub">ox_inventory · admin — choose what to manage</span>
        </div>
      </div>

      <div className="hub-cards">
        {CARDS.map(({ key, label, desc, Icon }) => (
          <button key={key} className="hub-card" onClick={() => onPick(key)}>
            <span className="hub-card-icon">
              <Icon size={30} />
            </span>
            <span className="hub-card-label">{label}</span>
            <span className="hub-card-desc">{desc}</span>
            <span className="hub-card-count">
              {key === 'settings' ? 'Appearance' : `${counts[key as 'stashes' | 'craft' | 'shops']} active`}
            </span>
          </button>
        ))}
      </div>
    </div>
  </div>
);

export default AdminHub;
