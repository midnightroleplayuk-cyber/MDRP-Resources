import InventoryGrid from './InventoryGrid';
import CraftingMenu from './CraftingMenu';
import ShopMenu from './ShopMenu';
import { useAppSelector } from '../../store';
import { selectRightInventory } from '../../store/inventory';

const RightInventory: React.FC = () => {
  const rightInventory = useAppSelector(selectRightInventory);

  // A crafting bench gets a dedicated recipe menu instead of the slot grid.
  if (rightInventory.type === 'crafting') {
    return (
      <div className="inventory-panel inventory-panel-right">
        <CraftingMenu />
      </div>
    );
  }

  // A shop gets a dedicated storefront with product cards + cash/bank payment.
  if (rightInventory.type === 'shop') {
    return (
      <div className="inventory-panel inventory-panel-right">
        <ShopMenu />
      </div>
    );
  }

  return (
    <div className="inventory-panel inventory-panel-right">
      <InventoryGrid inventory={rightInventory} title="SECONDARY" subtitle="Store necessary assets" fill />
    </div>
  );
};

export default RightInventory;
