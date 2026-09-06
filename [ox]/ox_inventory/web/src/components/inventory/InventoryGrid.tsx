import React, { useEffect, useMemo, useRef, useState } from 'react';
import { Inventory } from '../../typings';
import InventorySlot from './InventorySlot';
import { getTotalWeight } from '../../helpers';
import { useAppSelector } from '../../store';
import { useIntersection } from '../../hooks/useIntersection';
import { HexIcon, WeightIcon } from '../utils/icons/InventoryIcons';

const PAGE_SIZE = 30;
const PIP_COUNT = 16;

// Mirrors the SCSS grid metrics so a panel can render a custom number of rows.
const SLOT_VH = 11.82; // $gridSize + 0.22vh
const GAP_PX = 4; // $gridGap

const InventoryGrid: React.FC<{
  inventory: Inventory;
  title?: string;
  subtitle?: string;
  hideSlotNumbers?: boolean;
  rows?: number;
  fill?: boolean;
  // Hide the first N slots from this grid (used so POCKETS skips the 1-5 hotbar
  // slots — they're shown in the HOTBAR panel instead, no duplicates).
  skipSlots?: number;
}> = ({ inventory, title, subtitle, hideSlotNumbers, rows = 4, fill, skipSlots = 0 }) => {
  const weight = useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const [page, setPage] = useState(0);
  const containerRef = useRef(null);
  const { ref, entry } = useIntersection({ threshold: 0.5 });
  const isBusy = useAppSelector((state) => state.inventory.isBusy);

  // Uniform grid — every item is a single cell (the classic inventory layout).
  const slots = useMemo(() => inventory.items.slice(skipSlots), [inventory.items, skipSlots]);

  const weightPercent = inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0;
  const filledPips = Math.round((weightPercent / 100) * PIP_COUNT);

  useEffect(() => {
    if (entry && entry.isIntersecting) {
      setPage((prev) => ++prev);
    }
  }, [entry]);

  return (
    <div
      className={`inventory-grid-wrapper${fill ? ' inventory-grid-wrapper-fill' : ''}`}
      style={{ pointerEvents: isBusy ? 'none' : 'auto' }}
    >
      <div className="inventory-grid-header-wrapper">
        <div className="inventory-grid-title">
          <div className="inventory-grid-badge">
            <HexIcon size={20} />
          </div>
          <div className="inventory-grid-title-text">
            <p className="inventory-grid-label">{title || inventory.label}</p>
            {subtitle && <span className="inventory-grid-subtitle">{subtitle}</span>}
          </div>
        </div>
        <div className="inventory-grid-meta">
          {inventory.maxWeight !== undefined && (
            <div className="inventory-grid-weight">
              <WeightIcon size={14} />
              <p>
                {weight / 1000} / {inventory.maxWeight / 1000} kg
              </p>
            </div>
          )}
          <div className="inventory-grid-pips" aria-hidden>
            {Array.from({ length: PIP_COUNT }, (_, i) => (
              <span key={i} className={`inventory-pip${i < filledPips ? ' inventory-pip-filled' : ''}`} />
            ))}
          </div>
        </div>
      </div>
      <div className={fill ? 'inventory-grid-fill-area' : 'inventory-grid-static'}>
        <div
          className="inventory-grid-container"
          ref={containerRef}
          style={fill ? undefined : { height: `calc(${rows} * ${SLOT_VH}vh + ${(rows - 1) * GAP_PX}px)` }}
        >
          {slots.slice(0, (page + 1) * PAGE_SIZE).map((item, index, arr) => (
            <InventorySlot
              key={`${inventory.type}-${inventory.id}-${item.slot}`}
              item={item}
              ref={index === arr.length - 1 ? ref : null}
              inventoryType={inventory.type}
              inventoryGroups={inventory.groups}
              inventoryId={inventory.id}
              hideSlotNumber={hideSlotNumbers}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default InventoryGrid;
