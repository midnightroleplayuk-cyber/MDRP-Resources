import React, { useState, useLayoutEffect } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryHotbar from './InventoryHotbar';
import { useAppDispatch, useAppSelector } from '../../store';
import { refreshSlots, setAdditionalMetadata, setupInventory, selectSecondaryOpen } from '../../store/inventory';
import { selectSettings } from '../../store/settings';
import { Locale } from '../../store/locale';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';
import Tooltip from '../utils/Tooltip';
import { closeTooltip } from '../../store/tooltip';
import InventoryContext from './InventoryContext';
import { closeContextMenu } from '../../store/contextMenu';
import Fade from '../utils/transitions/Fade';
import PlayerStatus from './PlayerStatus';
import PlayerHeader from './PlayerHeader';
import HotbarPanel from './HotbarPanel';
import InventoryControl from './InventoryControl';
import Clothing from './Clothing';
import TopNav from './TopNav';
import SettingsPanel from './SettingsPanel';
import UsefulControls from './UsefulControls';
import { fetchNui } from '../../utils/fetchNui';

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = useState(false);
  const [clothesMode, setClothesMode] = useState(false);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [utilityOpen, setUtilityOpen] = useState(false);
  const dispatch = useAppDispatch();
  const settings = useAppSelector(selectSettings);
  // When a shop, crafting bench or container (stash/trunk/…) is open the right
  // column becomes a large dedicated panel — hide the hotbar and the action bar so
  // the layout is a clean, aligned two-column view.
  const bigRightPanel = useAppSelector(selectSecondaryOpen);
  // Exact top-nav alignment: measure the inventory column and pad the (un-zoomed)
  // top-nav to match — so the left chips line up with the profile card's left edge
  // and the right with the SECONDARY's right edge, at ANY resolution / UI size.
  const [navPad, setNavPad] = useState<{ left: number; right: number } | null>(null);

  const enterClothes = () => {
    setClothesMode(true);
    fetchNui('openClothing', {});
  };
  const exitClothes = () => {
    setClothesMode(false);
    fetchNui('closeClothing', {});
  };

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
    setClothesMode(false);
    fetchNui('closeClothing', {});
    dispatch(closeContextMenu());
    dispatch(closeTooltip());
  });
  useExitListener(setInventoryVisible);

  // Fired by the client-side clothing keybind (default Y): jump straight to the
  // wardrobe. If the inventory was closed the client opens it first, then sends this.
  useNuiEvent('openClothesTab', () => {
    setSettingsOpen(false);
    if (!clothesMode) enterClothes();
  });

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent('displayMetadata', (data: Array<{ metadata: string; value: string }>) => {
    dispatch(setAdditionalMetadata(data));
  });

  useLayoutEffect(() => {
    if (!inventoryVisible || clothesMode || settingsOpen) return;
    const measure = () => {
      const main = document.querySelector('.inv-main') as HTMLElement | null;
      if (!main) return;
      const r = main.getBoundingClientRect();
      if (r.width === 0) return;
      setNavPad({
        left: Math.max(0, Math.round(r.left)),
        right: Math.max(0, Math.round(window.innerWidth - r.right)),
      });
    };
    measure();
    const t1 = window.setTimeout(measure, 240);
    const t2 = window.setTimeout(measure, 620); // after the open animation settles
    window.addEventListener('resize', measure);
    return () => {
      window.clearTimeout(t1);
      window.clearTimeout(t2);
      window.removeEventListener('resize', measure);
    };
  }, [inventoryVisible, clothesMode, settingsOpen, settings.uiSize, settings.showProfileCard]);

  return (
    <>
      <Fade in={inventoryVisible}>
        <div className="inventory-wrapper">
          <TopNav
            clothesMode={clothesMode}
            settingsOpen={settingsOpen}
            navPad={navPad}
            onInventory={() => {
              exitClothes();
              setSettingsOpen(false);
            }}
            onClothes={() => {
              setSettingsOpen(false);
              enterClothes();
            }}
            onSettings={() => {
              exitClothes();
              setSettingsOpen(true);
            }}
          />
          {clothesMode ? (
            <Clothing onClose={exitClothes} />
          ) : settingsOpen ? (
            <SettingsPanel />
          ) : (
            <>
              <div className={`inventory-layout${bigRightPanel ? ' panel-mode' : ''}`}>
                <div className="inv-main">
                  <PlayerHeader />
                  <div className="inv-center">
                    <PlayerStatus />
                    <div className="inventory-body">
                      <LeftInventory />
                      <RightInventory />
                    </div>
                    {!bigRightPanel && (
                      <div className="inv-bottom">
                        <HotbarPanel />
                        <InventoryControl />
                      </div>
                    )}
                  </div>
                </div>
              </div>
              {settings.showEscHint && (
                <div className="esc-hint">
                  <kbd>ESC</kbd>
                  <span>{Locale.ui_fechar || 'Fechar'}</span>
                </div>
              )}
            </>
          )}
          <Tooltip />
          <InventoryContext />
          <UsefulControls infoVisible={utilityOpen} setInfoVisible={setUtilityOpen} />
        </div>
      </Fade>
      <InventoryHotbar />
    </>
  );
};

export default Inventory;
