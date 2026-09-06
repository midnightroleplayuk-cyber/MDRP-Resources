import { useState } from 'react';
import InventoryComponent from './components/inventory';
import useNuiEvent from './hooks/useNuiEvent';
import { Items } from './store/items';
import { Locale } from './store/locale';
import { ENGLISH_UI_LOCALE } from './store/englishLocale';
import { setImagePath } from './store/imagepath';
import { setupInventory } from './store/inventory';
import { Inventory } from './typings';
import { useAppDispatch } from './store';
import { debugData } from './utils/debugData';
import DragPreview from './components/utils/DragPreview';
import { fetchNui } from './utils/fetchNui';
import { useDragDropManager } from 'react-dnd';
import KeyPress from './components/utils/KeyPress';
import { setAccount, setJob, setPlayerData, PlayerAccount, PlayerJob, PlayerState } from './store/player';
import { setPlayerStatus, PlayerStatusState } from './store/playerStatus';
import { setClothing, ClothingItem } from './store/clothing';
import SettingsApplier from './components/inventory/SettingsApplier';
import StashAdmin from './components/stashadmin/StashAdmin';
import { openStashAdmin, closeStashAdmin } from './store/stashAdmin';
import type { CustomStash, JobEntry } from './store/stashAdmin';

debugData([
  {
    action: 'setupInventory',
    data: {
      leftInventory: {
        id: 'test',
        type: 'player',
        slots: 50,
        label: 'Bob Smith',
        weight: 3000,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'iron',
            weight: 3000,
            metadata: {
              description: `name: Svetozar Miletic  \n Gender: Male`,
              ammo: 3,
              mustard: '60%',
              ketchup: '30%',
              mayo: '10%',
            },
            count: 5,
          },
          { slot: 2, name: 'powersaw', weight: 0, count: 1, metadata: { durability: 75 } },
          { slot: 3, name: 'copper', weight: 100, count: 12, metadata: { type: 'Special' } },
          {
            slot: 4,
            name: 'water',
            weight: 100,
            count: 1,
            metadata: { description: 'Generic item description' },
          },
          { slot: 5, name: 'water', weight: 100, count: 1 },
          {
            slot: 6,
            name: 'backwoods',
            weight: 100,
            count: 1,
            metadata: {
              label: 'Russian Cream',
              imageurl: 'https://i.imgur.com/2xHhTTz.png',
            },
          },
        ],
      },
      rightInventory: {
        id: 'shop',
        type: 'crafting',
        slots: 5000,
        label: 'Bob Smith',
        weight: 3000,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'lockpick',
            weight: 500,
            price: 300,
            ingredients: {
              iron: 5,
              copper: 12,
              powersaw: 0.1,
            },
            metadata: {
              description: 'Simple lockpick that breaks easily and can pick basic door locks',
            },
          },
        ],
      },
    },
  },
  {
    action: 'setPlayerData',
    data: {
      name: 'Silverio Passo',
      serverId: 12,
      accounts: [
        { name: 'money', money: 0, label: 'Cash' },
        { name: 'bank', money: 2100, label: 'Bank' },
        { name: 'black_money', money: 3, label: 'Dirty' },
      ],
      job: { name: 'police', label: 'Police', grade: 3, gradeLabel: 'Sergeant' },
    },
  },
]);

const App: React.FC = () => {
  const dispatch = useAppDispatch();
  const manager = useDragDropManager();
  // Chroma-green backdrop behind the inventory, for screenshotting item icons.
  const [greenscreen, setGreenscreen] = useState(false);

  useNuiEvent<{
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
    imagepath: string;
  }>('init', ({ locale, items, leftInventory, imagepath }) => {
    for (const name in locale) Locale[name] = locale[name];
    Object.assign(Locale, ENGLISH_UI_LOCALE);
    for (const name in items) Items[name] = items[name];

    setImagePath(imagepath);
    dispatch(setupInventory({ leftInventory }));
  });

  useNuiEvent<PlayerState>('setPlayerData', (data) => dispatch(setPlayerData(data)));

  useNuiEvent<PlayerAccount>('setAccount', (data) => dispatch(setAccount(data)));

  useNuiEvent<PlayerJob>('setJob', (data) => dispatch(setJob(data)));

  useNuiEvent<Partial<PlayerStatusState>>('setPlayerStatus', (data) => dispatch(setPlayerStatus(data)));

  useNuiEvent<{ items: ClothingItem[] }>('setClothing', (data) => dispatch(setClothing(data.items || [])));

  useNuiEvent<{ stashes: CustomStash[]; jobs: JobEntry[] }>('openStashAdmin', (data) => dispatch(openStashAdmin(data)));

  useNuiEvent('closeStashAdmin', () => dispatch(closeStashAdmin()));

  fetchNui('uiLoaded', {});

  useNuiEvent('closeInventory', () => {
    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  // Toggle (or explicitly set) the green chroma backdrop behind the inventory.
  useNuiEvent<{ state?: boolean } | undefined>('toggleGreenscreen', (data) =>
    setGreenscreen((prev) => (data && typeof data.state === 'boolean' ? data.state : !prev))
  );

  return (
    <div className="app-wrapper">
      {greenscreen && <div className="greenscreen-bg" />}
      <SettingsApplier />
      <InventoryComponent />
      <DragPreview />
      <KeyPress />
      <StashAdmin />
    </div>
  );
};

addEventListener('dragstart', function (event) {
  event.preventDefault();
});

export default App;
