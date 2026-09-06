import React, { useEffect, useMemo, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  closeStashAdmin,
  CustomStash,
  removeStash,
  selectStashAdmin,
  setCraftAdminData,
  setShopAdminData,
  StashCoords,
  upsertStash,
} from '../../store/stashAdmin';
import { fetchNui } from '../../utils/fetchNui';
import useNuiEvent from '../../hooks/useNuiEvent';
import PlacementBar from './PlacementBar';
import { BoxIcon, CloseIcon, CraftIcon, GearIcon, PinIcon, PlusIcon, ShopIcon, StashIcon, TrashIcon } from './icons';
import PropSelect from './PropSelect';
import { STASH_DEFAULT_PROP, STASH_PROPS } from './propPresets';
import CraftEditor from './CraftEditor';
import ShopEditor from './ShopEditor';
import ConfirmDialog from './ConfirmDialog';
import AdminHub from './AdminHub';
import MarkerSettings from './MarkerSettings';

const DEFAULT_PROP = STASH_DEFAULT_PROP;

type OwnerMode = 'shared' | 'personal';
type Tab = 'stashes' | 'craft' | 'shops' | 'settings';

interface DraftStash {
  name: string;
  label: string;
  owner: OwnerMode;
  slots: number;
  maxWeight: number;
  groups: Record<string, number>;
  coords?: StashCoords;
  target?: { coords?: StashCoords; heading?: number; size?: StashCoords; label?: string };
  prop: { enabled: boolean; model: string; coords?: StashCoords; rotation?: { x: number; y: number; z: number } };
  instance?: number;
  showMarker: boolean;
}

const emptyDraft = (): DraftStash => ({
  name: '',
  label: '',
  owner: 'shared',
  slots: 50,
  maxWeight: 100,
  groups: {},
  prop: { enabled: false, model: DEFAULT_PROP },
  showMarker: true,
});

const toDraft = (s: CustomStash): DraftStash => ({
  name: s.name,
  label: s.label,
  owner: s.owner === true || s.owner === 'true' ? 'personal' : 'shared',
  slots: s.slots,
  maxWeight: Math.round((s.maxWeight ?? 100000) / 1000),
  groups: s.groups || {},
  coords: s.coords,
  target: s.target,
  prop: {
    enabled: s.prop?.enabled ?? false,
    model: s.prop?.model || DEFAULT_PROP,
    coords: s.prop?.coords,
    rotation: s.prop?.rotation,
  },
  instance: s.instance,
  showMarker: (s as any).showMarker ?? true,
});

const StashAdmin: React.FC = () => {
  const dispatch = useAppDispatch();
  const { open, stashes, jobs, benches, shops } = useAppSelector(selectStashAdmin);

  // 'hub' = the initial 3-card selector; otherwise the chosen manager.
  const [view, setView] = useState<'hub' | Tab>('hub');
  const tab = view as Tab;
  const [selected, setSelected] = useState<string | null>(null);
  const [craftSelected, setCraftSelected] = useState<string | null>(null);
  const [shopSelected, setShopSelected] = useState<string | null>(null);
  const [draft, setDraft] = useState<DraftStash>(emptyDraft());
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [confirmDel, setConfirmDel] = useState(false);
  const [panelHidden, setPanelHidden] = useState(false);
  const [placing, setPlacing] = useState(false);
  const [previewing, setPreviewing] = useState(false);
  const [placeMode, setPlaceMode] = useState<'follow' | 'prop'>('follow');
  // Generic placement: whoever started it registers a callback for the result.
  const placeCallback = React.useRef<((r: any) => void) | null>(null);

  // Generic placement entry-point used by both stash and craft editors.
  const startPlacement = (mode: 'follow' | 'prop', payload: any, onResult: (r: any) => void) => {
    placeCallback.current = onResult;
    setPlaceMode(mode);
    fetchNui('stashPlacementEditor', payload);
  };

  useNuiEvent<any>('stashPlacementResult', (result) => {
    const cb = placeCallback.current;
    placeCallback.current = null;
    if (result && cb) cb(result);
  });

  useNuiEvent('hideStashAdminPanel', () => setPanelHidden(true));
  useNuiEvent('showStashAdminPanel', () => setPanelHidden(false));
  useNuiEvent<{ mode?: 'follow' | 'prop' }>('showPlacementBar', (d) => {
    if (d?.mode) setPlaceMode(d.mode);
    setPlacing(true);
  });
  useNuiEvent('closePlacementBar', () => setPlacing(false));
  // Marker preview keeps the panel open but docks it aside so the in-world
  // marker is visible next to it.
  useNuiEvent('markerPreviewOn', () => setPreviewing(true));
  useNuiEvent('markerPreviewOff', () => setPreviewing(false));
  useNuiEvent<{ benches?: any[]; items?: any[] }>('setCraftAdminData', (d) =>
    dispatch(setCraftAdminData({ benches: d?.benches || [], items: d?.items || [] }))
  );
  useNuiEvent<{ shops?: any[]; items?: any[]; currencies?: string[] }>('setShopAdminData', (d) =>
    dispatch(setShopAdminData({ shops: d?.shops || [], items: d?.items || [], currencies: d?.currencies || [] }))
  );

  // Prefetch craft + shop data as soon as the manager opens so the hub cards
  // show the correct counts immediately (not only after entering a section).
  useEffect(() => {
    if (!open) return;
    fetchNui<{ allowed?: boolean; benches?: any[]; items?: any[] }>('getCraftAdminData', {}).then((d) => {
      if (d?.allowed) dispatch(setCraftAdminData({ benches: d.benches || [], items: d.items || [] }));
    });
    fetchNui<{ allowed?: boolean; shops?: any[]; items?: any[]; currencies?: string[] }>('getShopAdminData', {}).then(
      (d) => {
        if (d?.allowed)
          dispatch(setShopAdminData({ shops: d.shops || [], items: d.items || [], currencies: d.currencies || [] }));
      }
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  useEffect(() => {
    if (!open) {
      setSelected(null);
      setCraftSelected(null);
      setShopSelected(null);
      setDraft(emptyDraft());
      setError(null);
      setView('hub');
      setPanelHidden(false);
      setPlacing(false);
      setPreviewing(false);
    }
  }, [open]);

  const pickSection = (section: Tab) => {
    setSelected(null);
    setCraftSelected(null);
    setShopSelected(null);
    setView(section);
  };

  const startCreate = () => {
    setSelected(null);
    setDraft(emptyDraft());
    setError(null);
  };

  const startEdit = (s: CustomStash) => {
    setSelected(s.name);
    setDraft(toDraft(s));
    setError(null);
  };

  const close = () => {
    fetchNui('closeStashAdmin', {});
    dispatch(closeStashAdmin());
  };

  // Set a zone location: hide the UI, walk to the spot, confirm (follow mode).
  const useCurrentPosition = () => {
    startPlacement('follow', { prop: false }, (result) => {
      setDraft((d) => ({
        ...d,
        coords: result.coords,
        target: { ...d.target, coords: result.coords, heading: result.heading, size: { x: 1.5, y: 1.5, z: 2 } },
      }));
    });
  };

  // Place / reposition the prop. Repositioning starts from its saved coords and
  // tells the client which stash's real prop to hide while editing.
  const placeProp = () => {
    startPlacement(
      'prop',
      {
        prop: true,
        model: draft.prop.model,
        kind: 'stash',
        coords: draft.prop.coords,
        rotation: draft.prop.rotation,
        name: selected || undefined,
      },
      (result) => {
        setDraft((d) => ({
          ...d,
          prop: { ...d.prop, coords: result.coords, rotation: result.rotation },
          coords: result.coords,
        }));
      }
    );
  };

  // ESC: cancel placement first, otherwise close the whole UI.
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key !== 'Escape') return;
      if (placing) {
        fetchNui('stashPlacementAction', { action: 'cancel' });
      } else if (previewing) {
        fetchNui('appearancePreviewStop', {});
      } else {
        close();
      }
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, placing, previewing]);

  const toggleJob = (job: string) => {
    setDraft((d) => {
      const groups = { ...d.groups };
      if (groups[job] !== undefined) delete groups[job];
      else groups[job] = 0;
      return { ...d, groups };
    });
  };

  const setJobGrade = (job: string, grade: number) => {
    setDraft((d) => ({ ...d, groups: { ...d.groups, [job]: grade } }));
  };

  const locationSet = draft.prop.enabled ? draft.prop.coords : draft.coords;

  const canSave = useMemo(() => {
    if (!draft.name.trim() || !draft.label.trim()) return false;
    return draft.prop.enabled ? !!draft.prop.coords : !!draft.coords;
  }, [draft]);

  const save = async () => {
    if (!canSave || busy) return;
    setBusy(true);
    setError(null);

    const payload = {
      name: draft.name.trim(),
      label: draft.label.trim(),
      owner: draft.owner,
      slots: draft.slots,
      maxWeight: draft.maxWeight * 1000,
      groups: Object.keys(draft.groups).length ? draft.groups : undefined,
      coords: draft.coords,
      target: draft.prop.enabled ? undefined : draft.target,
      prop: draft.prop.enabled ? draft.prop : undefined,
      instance: draft.instance,
      showMarker: draft.showMarker,
    };

    const res = await fetchNui<{ ok: boolean; stash?: CustomStash; error?: string }>('saveCustomStash', payload);
    setBusy(false);

    if (!res?.ok) {
      setError(res?.error || 'Failed to save');
      return;
    }
    if (res.stash) {
      dispatch(upsertStash(res.stash));
      setSelected(res.stash.name);
    }
  };

  const del = async (name: string) => {
    if (busy) return;
    setBusy(true);
    const res = await fetchNui<{ ok: boolean }>('deleteCustomStash', { name });
    setBusy(false);
    if (res?.ok) {
      dispatch(removeStash(name));
      if (selected === name) startCreate();
    }
  };

  if (!open) return null;

  // Initial hub selector.
  if (view === 'hub' && !panelHidden) {
    return (
      <AdminHub
        onPick={pickSection}
        onClose={close}
        counts={{ stashes: stashes.length, craft: benches.length, shops: shops.length }}
      />
    );
  }

  const sectionTitle =
    tab === 'craft' ? 'Crafting' : tab === 'shops' ? 'Shops' : tab === 'settings' ? 'Settings' : 'Stashes';
  const SectionIcon =
    tab === 'craft' ? CraftIcon : tab === 'shops' ? ShopIcon : tab === 'settings' ? GearIcon : StashIcon;

  return (
    <>
      <PlacementBar open={placing} mode={placeMode} />

      {/* Keep the panel mounted while placing (so editor state survives) but
          hide it visually so the world is unobstructed. While previewing a
          marker, dock the panel aside so the in-world marker stays visible. */}
      <div
        className={`sa-overlay${panelHidden ? ' sa-overlay-hidden' : ''}${
          previewing ? ' sa-overlay-preview' : ''
        }`}
      >
        <div className="sa-panel">
          {/* Close X — top-right of the whole panel. */}
          <button className="sa-close-x" onClick={close} title="Close">
            <CloseIcon size={16} />
          </button>

          {/* Sidebar */}
          <aside className="sa-sidebar">
            <div className="sa-brand">
              <div className="sa-brand-badge">
                <SectionIcon size={20} />
              </div>
              <div>
                <p className="sa-brand-title">{sectionTitle}</p>
                <span className="sa-brand-sub">ox_inventory · admin</span>
              </div>
            </div>

            {tab === 'stashes' && (
              <>
                <button className="sa-create-btn" onClick={startCreate}>
                  <PlusIcon size={16} />
                  New stash
                </button>

                <div className="sa-list">
                  {stashes.length === 0 && <div className="sa-empty">No stashes yet</div>}
                  {stashes.map((s) => (
                    <button
                      key={s.name}
                      className={`sa-list-item${selected === s.name ? ' sa-list-item-active' : ''}`}
                      onClick={() => startEdit(s)}
                    >
                      <span className="sa-list-icon">{s.prop?.enabled ? <BoxIcon size={15} /> : <PinIcon size={15} />}</span>
                      <span className="sa-list-text">
                        <span className="sa-list-label">{s.label}</span>
                        <span className="sa-list-name">{s.name}</span>
                      </span>
                      <span className="sa-list-slots">{s.slots}</span>
                    </button>
                  ))}
                </div>
              </>
            )}

            {tab === 'craft' && (
              <>
                <button className="sa-create-btn" onClick={() => setCraftSelected(null)}>
                  <PlusIcon size={16} />
                  New bench
                </button>

                <div className="sa-list">
                  {benches.length === 0 && <div className="sa-empty">No benches yet</div>}
                  {benches.map((b) => (
                    <button
                      key={b.id}
                      className={`sa-list-item${craftSelected === b.id ? ' sa-list-item-active' : ''}`}
                      onClick={() => setCraftSelected(b.id)}
                    >
                      <span className="sa-list-icon">
                        <CraftIcon size={15} />
                      </span>
                      <span className="sa-list-text">
                        <span className="sa-list-label">{b.label}</span>
                        <span className="sa-list-name">{b.id}</span>
                      </span>
                      <span className="sa-list-slots">{b.recipes?.length ?? 0}</span>
                    </button>
                  ))}
                </div>
              </>
            )}

            {tab === 'shops' && (
              <>
                <button className="sa-create-btn" onClick={() => setShopSelected(null)}>
                  <PlusIcon size={16} />
                  New shop
                </button>

                <div className="sa-list">
                  {shops.length === 0 && <div className="sa-empty">No shops yet</div>}
                  {shops.map((s) => (
                    <button
                      key={s.id}
                      className={`sa-list-item${shopSelected === s.id ? ' sa-list-item-active' : ''}`}
                      onClick={() => setShopSelected(s.id)}
                    >
                      <span className="sa-list-icon">
                        <ShopIcon size={15} />
                      </span>
                      <span className="sa-list-text">
                        <span className="sa-list-label">{s.label}</span>
                        <span className="sa-list-name">{s.id}</span>
                      </span>
                      <span className="sa-list-slots">{s.inventory?.length ?? 0}</span>
                    </button>
                  ))}
                </div>
              </>
            )}

            {tab === 'settings' && (
              <div className="sa-side-note">
                <p>Configure markers &amp; blips separately for stashes, benches and shops.</p>
                <ul>
                  <li>Marker shape, color, size &amp; opacity</li>
                  <li>Floating bob animation</li>
                  <li>Map blip sprite, color &amp; size</li>
                </ul>
                <span className="sa-side-note-foot">Pick a type up top — changes apply live.</span>
              </div>
            )}

            {/* Back sits alone at the bottom of the sidebar. */}
            <button className="sa-back" onClick={() => setView('hub')}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M15 18l-6-6 6-6" />
              </svg>
              Back
            </button>
          </aside>

          {/* Main */}
          <main className="sa-main">
            {tab === 'settings' ? (
              <MarkerSettings />
            ) : tab === 'craft' ? (
              <CraftEditor selected={craftSelected} setSelected={setCraftSelected} startPlacement={startPlacement} />
            ) : tab === 'shops' ? (
              <ShopEditor selected={shopSelected} setSelected={setShopSelected} startPlacement={startPlacement} />
            ) : (
              <>
                <div className="sa-main-head">
                  <h2>{selected ? 'Edit stash' : 'Create stash'}</h2>
                  {selected && (
                    <button className="sa-delete" onClick={() => setConfirmDel(true)}>
                      <TrashIcon size={14} />
                      Delete
                    </button>
                  )}
                </div>

                <div className="sa-form">
                  <div className="sa-grid-2">
                    <Field label="Identifier (unique)">
                      <input
                        className="sa-input"
                        value={draft.name}
                        disabled={!!selected}
                        placeholder="warehouse_a"
                        onChange={(e) => setDraft({ ...draft, name: e.target.value })}
                      />
                    </Field>
                    <Field label="Display label">
                      <input
                        className="sa-input"
                        value={draft.label}
                        placeholder="Warehouse A"
                        onChange={(e) => setDraft({ ...draft, label: e.target.value })}
                      />
                    </Field>
                  </div>

                  <div className="sa-grid-3">
                    <Field label="Slots">
                      <input
                        className="sa-input"
                        type="number"
                        value={draft.slots}
                        onChange={(e) => setDraft({ ...draft, slots: Math.max(1, parseInt(e.target.value) || 0) })}
                      />
                    </Field>
                    <Field label="Max weight (kg)">
                      <input
                        className="sa-input"
                        type="number"
                        value={draft.maxWeight}
                        onChange={(e) => setDraft({ ...draft, maxWeight: Math.max(1, parseInt(e.target.value) || 0) })}
                      />
                    </Field>
                    <Field label="Instance">
                      <input
                        className="sa-input"
                        type="number"
                        placeholder="none"
                        value={draft.instance ?? ''}
                        onChange={(e) =>
                          setDraft({ ...draft, instance: e.target.value === '' ? undefined : parseInt(e.target.value) })
                        }
                      />
                    </Field>
                  </div>

                  <Field label="Access">
                    <div className="sa-segment">
                      {(['shared', 'personal'] as OwnerMode[]).map((mode) => (
                        <button
                          key={mode}
                          className={`sa-seg-item${draft.owner === mode ? ' sa-seg-active' : ''}`}
                          onClick={() => setDraft({ ...draft, owner: mode })}
                        >
                          {mode === 'shared' ? 'Shared' : 'Personal'}
                        </button>
                      ))}
                    </div>
                    <span className="sa-hint">
                      {draft.owner === 'shared'
                        ? 'One shared inventory for everyone with access.'
                        : 'Each player gets their own private stash at this location.'}
                    </span>
                  </Field>

                  <Field label="Job access — leave empty for everyone">
                    <div className="sa-jobs">
                      {jobs.length === 0 && <span className="sa-hint">No jobs found in database.</span>}
                      {jobs.map((job) => {
                        const active = draft.groups[job.name] !== undefined;
                        return (
                          <div key={job.name} className={`sa-job${active ? ' sa-job-active' : ''}`}>
                            <button className="sa-job-toggle" onClick={() => toggleJob(job.name)}>
                              <span className="sa-job-check">{active ? '✓' : ''}</span>
                              {job.label}
                            </button>
                            {active && job.grades.length > 0 && (
                              <div className="sa-select">
                                <select
                                  value={draft.groups[job.name]}
                                  onChange={(e) => setJobGrade(job.name, parseInt(e.target.value))}
                                >
                                  {job.grades.map((g) => (
                                    <option key={g.grade} value={g.grade}>
                                      {g.label} ({g.grade}+)
                                    </option>
                                  ))}
                                </select>
                                <span className="sa-select-arrow">▾</span>
                              </div>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  </Field>

                  <Field label="Prop">
                    <div className="sa-row-between">
                      <span className="sa-hint">Spawn a physical crate the player interacts with.</span>
                      <button
                        className={`sa-toggle${draft.prop.enabled ? ' sa-toggle-on' : ''}`}
                        onClick={() => setDraft({ ...draft, prop: { ...draft.prop, enabled: !draft.prop.enabled } })}
                      >
                        <span className="sa-toggle-knob" />
                      </button>
                    </div>
                    {draft.prop.enabled && (
                      <PropSelect
                        presets={STASH_PROPS}
                        value={draft.prop.model}
                        onChange={(model) => setDraft({ ...draft, prop: { ...draft.prop, model } })}
                      />
                    )}
                  </Field>

                  <Field label="Location">
                    <div className="sa-loc">
                      <div className={`sa-loc-status${locationSet ? ' sa-loc-set' : ''}`}>
                        {locationSet
                          ? `x ${locationSet.x}   y ${locationSet.y}   z ${locationSet.z}`
                          : draft.prop.enabled
                            ? 'No prop placed yet'
                            : 'No location set'}
                      </div>
                      {draft.prop.enabled ? (
                        <button className="sa-ghost sa-ghost-accent" onClick={placeProp}>
                          <BoxIcon size={15} />
                          {locationSet ? 'Reposition prop' : 'Place prop in world'}
                        </button>
                      ) : (
                        <button className="sa-ghost sa-ghost-accent" onClick={useCurrentPosition}>
                          <PinIcon size={15} />
                          Use my position
                        </button>
                      )}
                    </div>
                  </Field>

                  <Field label="Marker">
                    <div className="sa-row-between">
                      <span className="sa-hint">Show a floating marker above the stash.</span>
                      <button
                        className={`sa-toggle${draft.showMarker ? ' sa-toggle-on' : ''}`}
                        onClick={() => setDraft({ ...draft, showMarker: !draft.showMarker })}
                      >
                        <span className="sa-toggle-knob" />
                      </button>
                    </div>
                  </Field>

                  {error && <div className="sa-error">{error}</div>}

                  <button className="sa-save" disabled={!canSave || busy} onClick={save}>
                    {busy ? 'Saving…' : selected ? 'Save changes' : 'Create stash'}
                  </button>
                </div>
              </>
            )}
          </main>
        </div>
      </div>

      <ConfirmDialog
        open={confirmDel && !!selected}
        title="Delete stash"
        message={`This permanently removes "${selected}" and its stored items. This cannot be undone.`}
        onCancel={() => setConfirmDel(false)}
        onConfirm={() => {
          setConfirmDel(false);
          if (selected) del(selected);
        }}
      />
    </>
  );
};

const Field: React.FC<{ label: string; children: React.ReactNode }> = ({ label, children }) => (
  <div className="sa-field">
    <span className="sa-field-label">{label}</span>
    {children}
  </div>
);

export default StashAdmin;
