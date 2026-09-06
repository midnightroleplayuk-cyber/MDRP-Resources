import React, { useMemo, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectLeftInventory, selectRightInventory } from '../../store/inventory';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import { getItemUrl, isSlotWithItem } from '../../helpers';
import { SlotWithItem } from '../../typings';
import { craftItem } from '../../thunks/craftItem';
import { HexIcon } from '../utils/icons/InventoryIcons';
import ClockIcon from '../utils/icons/ClockIcon';

// Counts how many of `name` the player currently holds (whole-item ingredients).
const playerCount = (items: any[], name: string) =>
  items.reduce((total, slot) => (isSlotWithItem(slot) && slot.name === name ? total + (slot.count || 0) : total), 0);

const itemLabel = (name: string) => Items[name]?.label || name;

const CraftingMenu: React.FC = () => {
  const dispatch = useAppDispatch();
  const right = useAppSelector(selectRightInventory);
  const left = useAppSelector(selectLeftInventory);
  const isBusy = useAppSelector((state) => state.inventory.isBusy);

  const recipes = useMemo(() => right.items.filter((i) => isSlotWithItem(i)) as SlotWithItem[], [right.items]);
  const [selected, setSelected] = useState(0);

  const recipe = recipes[selected] || recipes[0];

  // First free slot in the player inventory for the crafted item to land in.
  const firstFreeSlot = useMemo(() => {
    const slot = left.items.find((s) => !s.name);
    return slot?.slot ?? 1;
  }, [left.items]);

  if (!recipe) {
    return (
      <div className="inventory-panel craft-panel">
        <div className="craft-empty">No recipes available.</div>
      </div>
    );
  }

  const ingredients = recipe.ingredients ? Object.entries(recipe.ingredients) : [];

  const canCraft = ingredients.every(([name, need]) => {
    if (need < 1) return true; // durability-based, handled server-side
    return playerCount(left.items, name) >= need;
  });

  // Durations are stored in ms; clamp to guard against any bad/legacy value.
  const duration = Math.min(3600, Math.max(1, Math.round((recipe.duration ?? 3000) / 1000)));
  const resultCount = recipe.count ?? 1;

  const doCraft = () => {
    if (!canCraft || isBusy) return;
    dispatch(
      craftItem({
        fromSlot: recipe.slot,
        toSlot: firstFreeSlot,
        fromType: right.type,
        toType: left.type,
        count: 1,
      })
    );
  };

  return (
    <div className="inventory-panel craft-panel" style={{ pointerEvents: isBusy ? 'none' : 'auto' }}>
      {/* Header */}
      <div className="craft-head">
        <div className="inventory-grid-badge">
          <HexIcon size={20} />
        </div>
        <div className="inventory-grid-title-text">
          <p className="inventory-grid-label">{right.label || 'CRAFTING'}</p>
          <span className="inventory-grid-subtitle">{recipes.length} recipes</span>
        </div>
      </div>

      <div className="craft-body">
        {/* Recipe list */}
        <div className="craft-list">
          {recipes.map((r, i) => (
            <button
              key={`${r.name}-${r.slot}`}
              className={`craft-list-item${i === selected ? ' craft-list-item-active' : ''}`}
              onClick={() => setSelected(i)}
            >
              <span
                className="craft-list-thumb"
                style={{ backgroundImage: `url(${getItemUrl(r as SlotWithItem) || 'none'})` }}
              />
              <span className="craft-list-text">
                <span className="craft-list-name">{r.metadata?.label || itemLabel(r.name)}</span>
                <span className="craft-list-sub">{(r.count ?? 1) > 1 ? `x${r.count}` : 'Craftable'}</span>
              </span>
            </button>
          ))}
        </div>

        {/* Selected recipe detail */}
        <div className="craft-detail">
          <div className="craft-hero">
            <div
              className="craft-hero-img"
              style={{ backgroundImage: `url(${getItemUrl(recipe as SlotWithItem) || 'none'})` }}
            />
            <div className="craft-hero-info">
              <p className="craft-hero-name">{recipe.metadata?.label || itemLabel(recipe.name)}</p>
              <div className="craft-hero-meta">
                {resultCount > 1 && <span className="craft-chip">x{resultCount}</span>}
                <span className="craft-chip craft-chip-time">
                  <ClockIcon />
                  {duration}s
                </span>
              </div>
            </div>
          </div>

          <div className="craft-ingredients">
            <span className="craft-section-label">{Locale.ui_required || 'Required'}</span>
            {ingredients.length === 0 && <span className="craft-hint">No ingredients.</span>}
            {ingredients.map(([name, need]) => {
              const have = playerCount(left.items, name);
              const isDurability = need < 1;
              const enough = isDurability || have >= need;
              return (
                <div className={`craft-ing${enough ? '' : ' craft-ing-missing'}`} key={name}>
                  <span
                    className="craft-ing-img"
                    style={{ backgroundImage: `url(${getItemUrl(name) || 'none'})` }}
                  />
                  <span className="craft-ing-name">{itemLabel(name)}</span>
                  <span className="craft-ing-count">
                    {isDurability ? `${Math.floor(need * 100)}%` : `${have}/${need}`}
                  </span>
                </div>
              );
            })}
          </div>

          <button className="craft-btn" disabled={!canCraft || isBusy} onClick={doCraft}>
            {canCraft ? Locale.ui_craft || 'Craft' : Locale.ui_missing_items || 'Missing items'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default CraftingMenu;
