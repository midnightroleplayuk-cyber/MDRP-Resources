import InventoryGrid from './InventoryGrid';
import { useAppSelector } from '../../store';
import { selectLeftInventory, selectSecondaryOpen } from '../../store/inventory';

const LeftInventory: React.FC = () => {
  const leftInventory = useAppSelector(selectLeftInventory);
  // With a shop, bench or container open the right column is a tall panel — let
  // POCKETS fill the full column height (scrolling) so its card matches that panel
  // instead of leaving empty space below a fixed 4-row grid.
  const fillPockets = useAppSelector(selectSecondaryOpen);

  return (
    <div className="inventory-panel inventory-panel-left">
      <InventoryGrid
        inventory={leftInventory}
        title="POCKETS"
        subtitle="Items on your character"
        hideSlotNumbers
        skipSlots={5}
        fill={fillPockets}
      />
    </div>
  );
};

export default LeftInventory;
