import React from 'react';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import InventorySlot from './InventorySlot';
import { HexIcon } from '../utils/icons/InventoryIcons';
import { Locale } from '../../store/locale';

// The hotbar IS the player's quick-use slots (1-5) — the same slots ox_inventory
// binds to the number keys. Dragging an item here moves it into a hotbar slot;
// those slots are hidden from POCKETS (which starts at slot 6) so each item only
// shows once.
const HOTBAR_SIZE = 5;

const HotbarPanel: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);
  const items = leftInventory.items.slice(0, HOTBAR_SIZE);

  return (
    <div className="hotbar-panel">
      <div className="inventory-grid-title">
        <div className="inventory-grid-badge">
          <HexIcon size={20} />
        </div>
        <div className="inventory-grid-title-text">
          <p className="inventory-grid-label">{Locale.ui_hotbar || 'HOTBAR'}</p>
          <span className="inventory-grid-subtitle">{Locale.ui_hotbar_sub || 'Quick-use slots (drag items here)'}</span>
        </div>
      </div>
      <div className="hotbar-panel-grid">
        {items.map((item, index) => (
          <div className="hotbar-panel-cell" key={`hotbar-${leftInventory.type}-${leftInventory.id}-${item.slot}`}>
            <InventorySlot
              item={item}
              inventoryType={leftInventory.type}
              inventoryGroups={leftInventory.groups}
              inventoryId={leftInventory.id}
              hideSlotNumber
            />
            <span className="hotbar-panel-key">{index + 1}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HotbarPanel;
