import React from 'react';
import { Locale } from '../../store/locale';

const InventoryHeader: React.FC = () => {
  return (
    <div className="inventory-header">
      <h1 className="inventory-header-title">{Locale.ui_inventory || 'INVENTORY'}</h1>
    </div>
  );
};

export default InventoryHeader;
