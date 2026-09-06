import React from 'react';
import { useAppSelector } from '../../store';
import { selectClothing, ClothingItem } from '../../store/clothing';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';

const toggle = (key: string) => fetchNui('clothingToggle', { key });
const rotate = (dir: number) => fetchNui('rotateClothing', { dir });

// One line-icon per clothing piece (lucide-style strokes).
const CLOTHING_ICONS: Record<string, string> = {
  Hat: 'M3 18h18 M5 18a7 7 0 0 1 14 0 M8 18c0-6 1-9 4-9s4 3 4 9',
  Mask: 'M4 9c2-1 5-1.5 8-1.5S18 8 20 9v3a8 8 0 0 1-16 0V9z M8 12h.01 M16 12h.01 M9.5 15.5c1 .7 4 .7 5 0',
  Glasses: 'M2 12a3 3 0 1 0 6 0 3 3 0 0 0-6 0z M16 12a3 3 0 1 0 6 0 3 3 0 0 0-6 0z M8 12h8 M2 12V9 M22 12V9',
  Earrings: 'M9 4a3 3 0 0 1 6 0 M12 4v7 M12 11a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5z',
  Top: 'M16 3l5 4-3 3-1-1v9H7V9L6 10 3 7l5-4 1.7.9a2.3 2.3 0 0 0 4.6 0z',
  Armour: 'M12 2l8 4v5c0 5-4 9-8 11-4-2-8-6-8-11V6l8-4z M9 11l2 2 4-4',
  Accessory: 'M10 2h4l-1 5 2 9-3 6-3-6 2-9-1-5z',
  Pants: 'M7 2h10l-1 20h-4l-1-11-1 11H8L7 2z',
  Bag: 'M7 9a5 5 0 0 1 10 0v10a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V9z M9 9V7a3 3 0 0 1 6 0v2 M7 14h10',
  Shoes: 'M2 16l1-4 4 1 3 3h10a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H2v-4z M3 13l4 3',
  Watch: 'M12 7a5 5 0 1 0 0 10 5 5 0 0 0 0-10z M9 3h6l-.6 3.6 M9 21h6l-.6-3.6',
  Bracelet: 'M12 6a6 6 0 1 0 0 12 6 6 0 0 0 0-12z M12 6V3 M9 4h6',
};
const FALLBACK_ICON = 'M20 6H4l2 14h12l2-14z M9 6V4a3 3 0 0 1 6 0v2';

const ClothingIcon: React.FC<{ name: string }> = ({ name }) => (
  <svg viewBox="0 0 24 24" width={22} height={22} fill="none" stroke="currentColor" strokeWidth={1.7} strokeLinecap="round" strokeLinejoin="round">
    <path d={CLOTHING_ICONS[name] || FALLBACK_ICON} />
  </svg>
);

const Slot: React.FC<{ item: ClothingItem }> = ({ item }) => (
  <div className={`clothing-slot${item.worn ? ' is-worn' : ''}`} onClick={() => toggle(item.key)}>
    <div className="clothing-slot-icon">
      <ClothingIcon name={item.key} />
    </div>
    <div className="clothing-slot-info">
      <p className="clothing-slot-name">{item.header}</p>
      <p className="clothing-slot-state">
        {item.worn
          ? Locale.ui_equipped || 'Equipped · click to remove'
          : item.canRestore
            ? Locale.ui_removed || 'Removed · click to equip'
            : Locale.ui_empty || 'Empty'}
      </p>
    </div>
    <div className={`clothing-dot${item.worn ? ' on' : ''}`} />
  </div>
);

const Chevron: React.FC<{ dir: 'l' | 'r' }> = ({ dir }) => (
  <svg viewBox="0 0 24 24" width={20} height={20} fill="none" stroke="currentColor" strokeWidth={2.4} strokeLinecap="round" strokeLinejoin="round">
    {dir === 'l' ? <path d="M15 18l-6-6 6-6" /> : <path d="M9 18l6-6-6-6" />}
  </svg>
);

const Clothing: React.FC<{ onClose: () => void }> = ({ onClose }) => {
  const items = useAppSelector(selectClothing);
  const mid = Math.ceil(items.length / 2);

  return (
    <div className="clothing-overlay">
      <div className="clothing-col">{items.slice(0, mid).map((i) => <Slot key={i.key} item={i} />)}</div>

      <div className="clothing-center">
        <div className="clothing-title">
          <span>{Locale.ui_wardrobe || 'Wardrobe'}</span>
          <p>{Locale.ui_wardrobe_sub || 'Take off & put on your outfit'}</p>
        </div>

        <div className="clothing-controls">
          <div className="clothing-rotate">
            <button onClick={() => rotate(-1)} title="Rotate left">
              <Chevron dir="l" />
            </button>
            <span>{Locale.ui_rotate || 'Rotate'}</span>
            <button onClick={() => rotate(1)} title="Rotate right">
              <Chevron dir="r" />
            </button>
          </div>
          <button className="clothing-close" onClick={onClose}>
            {Locale.ui_close_wardrobe || 'Close wardrobe'}
          </button>
        </div>
      </div>

      <div className="clothing-col">{items.slice(mid).map((i) => <Slot key={i.key} item={i} />)}</div>
    </div>
  );
};

export default Clothing;
