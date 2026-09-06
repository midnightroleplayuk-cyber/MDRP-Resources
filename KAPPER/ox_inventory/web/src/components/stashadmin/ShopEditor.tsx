import React, { useMemo, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  CustomShop,
  PlacedLocation,
  removeShop,
  selectStashAdmin,
  ShopProduct,
  upsertShop,
} from '../../store/stashAdmin';
import { fetchNui } from '../../utils/fetchNui';
import { BoxIcon, PedIcon, PinIcon, PlusIcon, TrashIcon } from './icons';
import PropSelect from './PropSelect';
import ItemSelect from './ItemSelect';
import ConfirmDialog from './ConfirmDialog';
import { SHOP_DEFAULT_PED, SHOP_DEFAULT_PROP, SHOP_PEDS, SHOP_PROPS } from './propPresets';

interface Props {
  selected: string | null;
  setSelected: (id: string | null) => void;
  startPlacement: (mode: 'follow' | 'prop', payload: any, onResult: (r: any) => void) => void;
}

type Placement = 'none' | 'prop' | 'ped';

interface DraftShop {
  id: string;
  label: string;
  groups: Record<string, number>;
  inventory: ShopProduct[];
  locations: PlacedLocation[];
  placement: Placement;
  propModel: string;
  pedModel: string;
  showMarker: boolean;
  blip: boolean;
  // Blank = use the global shop blip appearance.
  blipSprite: string;
  blipColor: string;
}

// Normalise a shop's coords (single object or array) into a locations array.
const toLocations = (c?: any): PlacedLocation[] => {
  if (!c) return [];
  const arr = Array.isArray(c) ? c : [c];
  return arr
    .filter(Boolean)
    .map((l) => ({ x: l.x, y: l.y, z: l.z, heading: l.heading ?? 0 }));
};

const emptyDraft = (): DraftShop => ({
  id: '',
  label: '',
  groups: {},
  inventory: [],
  locations: [],
  placement: 'prop',
  propModel: SHOP_DEFAULT_PROP,
  pedModel: SHOP_DEFAULT_PED,
  showMarker: true,
  blip: false,
  blipSprite: '',
  blipColor: '',
});

const toDraft = (s: CustomShop): DraftShop => ({
  id: s.id,
  label: s.label,
  groups: s.groups || {},
  inventory: s.inventory || [],
  locations: toLocations(s.coords),
  placement: s.ped?.enabled ? 'ped' : s.prop?.enabled ? 'prop' : 'none',
  propModel: s.prop?.model || SHOP_DEFAULT_PROP,
  pedModel: s.ped?.model || SHOP_DEFAULT_PED,
  showMarker: (s as any).showMarker ?? true,
  blip: (s as any).blip ?? false,
  blipSprite: s.blipSprite != null ? String(s.blipSprite) : '',
  blipColor: s.blipColor != null ? String(s.blipColor) : '',
});

const newProduct = (): ShopProduct => ({ name: '', price: 0, currency: 'money' });

const ShopEditor: React.FC<Props> = ({ selected, setSelected, startPlacement }) => {
  const dispatch = useAppDispatch();
  const { shops, items, jobs, currencies } = useAppSelector(selectStashAdmin);

  const [draft, setDraft] = useState<DraftShop>(emptyDraft());
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [confirmDel, setConfirmDel] = useState(false);

  React.useEffect(() => {
    if (selected) {
      const s = shops.find((x) => x.id === selected);
      if (s) setDraft(toDraft(s));
    } else {
      setDraft(emptyDraft());
    }
    setError(null);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selected]);

  const isProp = draft.placement === 'prop';
  const isPed = draft.placement === 'ped';
  const placeModel = isPed ? draft.pedModel : draft.propModel;

  // Add a new location: walk-to (zone only) or prop/ped placement editor.
  const addLocation = () => {
    if (draft.placement === 'none') {
      startPlacement('follow', { prop: false }, (r) =>
        setDraft((d) => ({ ...d, locations: [...d.locations, { ...r.coords, heading: r.heading }] }))
      );
      return;
    }
    startPlacement(
      'prop',
      { prop: true, model: placeModel, kind: 'shop', ped: isPed },
      (r) =>
        setDraft((d) => ({
          ...d,
          locations: [...d.locations, { ...r.coords, heading: r.rotation?.z ?? r.heading ?? 0 }],
        }))
    );
  };

  // Reposition an existing location in place.
  const repositionLocation = (i: number) => {
    const loc = draft.locations[i];
    if (draft.placement === 'none') {
      startPlacement('follow', { prop: false }, (r) =>
        setDraft((d) => ({
          ...d,
          locations: d.locations.map((l, idx) => (idx === i ? { ...r.coords, heading: r.heading } : l)),
        }))
      );
      return;
    }
    startPlacement(
      'prop',
      { prop: true, model: placeModel, kind: 'shop', ped: isPed, name: selected || undefined, coords: loc, rotation: { x: 0, y: 0, z: loc.heading ?? 0 } },
      (r) =>
        setDraft((d) => ({
          ...d,
          locations: d.locations.map((l, idx) =>
            idx === i ? { ...r.coords, heading: r.rotation?.z ?? r.heading ?? 0 } : l
          ),
        }))
    );
  };

  const removeLocation = (i: number) =>
    setDraft((d) => ({ ...d, locations: d.locations.filter((_, idx) => idx !== i) }));

  const toggleJob = (job: string) => {
    setDraft((d) => {
      const groups = { ...d.groups };
      if (groups[job] !== undefined) delete groups[job];
      else groups[job] = 0;
      return { ...d, groups };
    });
  };

  const addProduct = () => setDraft((d) => ({ ...d, inventory: [...d.inventory, newProduct()] }));
  const removeProduct = (i: number) =>
    setDraft((d) => ({ ...d, inventory: d.inventory.filter((_, idx) => idx !== i) }));
  const patchProduct = (i: number, patch: Partial<ShopProduct>) =>
    setDraft((d) => ({ ...d, inventory: d.inventory.map((p, idx) => (idx === i ? { ...p, ...patch } : p)) }));

  const canSave = useMemo(() => {
    if (!draft.id.trim() || !draft.label.trim()) return false;
    if (draft.locations.length === 0) return false;
    return draft.inventory.some((p) => p.name.trim());
  }, [draft]);

  const save = async () => {
    if (!canSave || busy) return;
    setBusy(true);
    setError(null);

    const inventory = draft.inventory
      .filter((p) => p.name.trim())
      .map((p) => ({
        name: p.name,
        price: p.price,
        currency: p.currency && p.currency !== 'money' ? p.currency : undefined,
        grade: p.grade,
        license: p.license,
      }));

    const payload = {
      id: draft.id.trim(),
      label: draft.label.trim(),
      groups: Object.keys(draft.groups).length ? draft.groups : undefined,
      inventory,
      // Always an array of {x,y,z,heading} — the backend spawns a prop/ped per entry.
      coords: draft.locations,
      prop: draft.placement === 'prop' ? { enabled: true, model: draft.propModel } : undefined,
      ped: draft.placement === 'ped' ? { enabled: true, model: draft.pedModel } : undefined,
      showMarker: draft.showMarker,
      blip: draft.blip,
      blipSprite: draft.blip && draft.blipSprite.trim() !== '' ? parseInt(draft.blipSprite) : undefined,
      blipColor: draft.blip && draft.blipColor.trim() !== '' ? parseInt(draft.blipColor) : undefined,
    };

    const res = await fetchNui<{ ok: boolean; shop?: CustomShop; error?: string }>('saveCustomShop', payload);
    setBusy(false);
    if (!res?.ok) {
      setError(res?.error || 'Failed to save');
      return;
    }
    if (res.shop) {
      dispatch(upsertShop(res.shop));
      setSelected(res.shop.id);
    }
  };

  const del = async (id: string) => {
    if (busy) return;
    setBusy(true);
    const res = await fetchNui<{ ok: boolean }>('deleteCustomShop', { id });
    setBusy(false);
    if (res?.ok) {
      dispatch(removeShop(id));
      setSelected(null);
    }
  };

  const placeVerb = isPed ? 'NPC' : isProp ? 'prop' : 'zone';

  return (
    <>
      <div className="sa-main-head">
        <h2>{selected ? 'Edit shop' : 'Create shop'}</h2>
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
              value={draft.id}
              disabled={!!selected}
              placeholder="general_store"
              onChange={(e) => setDraft({ ...draft, id: e.target.value })}
            />
          </Field>
          <Field label="Display label">
            <input
              className="sa-input"
              value={draft.label}
              placeholder="General Store"
              onChange={(e) => setDraft({ ...draft, label: e.target.value })}
            />
          </Field>
        </div>

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
                </div>
              );
            })}
          </div>
        </Field>

        {/* Products */}
        <Field label="Products">
          <div className="sa-products">
            {draft.inventory.length === 0 && <span className="sa-hint">No products yet — add one below.</span>}
            {draft.inventory.map((p, i) => (
              <div className="sa-product" key={i}>
                <div className="sa-product-item">
                  <ItemSelect
                    items={items}
                    value={p.name}
                    placeholder="Item"
                    onChange={(name) => patchProduct(i, { name })}
                  />
                </div>
                <div className="sa-product-price">
                  <label>$</label>
                  <input
                    className="sa-input sa-input-mini"
                    type="number"
                    value={p.price}
                    onChange={(e) => patchProduct(i, { price: Math.max(0, parseInt(e.target.value) || 0) })}
                  />
                </div>
                <div className="sa-select sa-product-cur">
                  <select value={p.currency || 'money'} onChange={(e) => patchProduct(i, { currency: e.target.value })}>
                    {currencies.map((c) => (
                      <option key={c} value={c}>
                        {c}
                      </option>
                    ))}
                  </select>
                  <span className="sa-select-arrow">▾</span>
                </div>
                <div className="sa-product-grade">
                  <label>grade</label>
                  <input
                    className="sa-input sa-input-mini"
                    type="number"
                    placeholder="—"
                    value={p.grade ?? ''}
                    onChange={(e) =>
                      patchProduct(i, { grade: e.target.value === '' ? undefined : parseInt(e.target.value) })
                    }
                  />
                </div>
                <button className="sa-recipe-del" onClick={() => removeProduct(i)} title="Remove product">
                  <TrashIcon size={13} />
                </button>
              </div>
            ))}
            <button className="sa-ghost" onClick={addProduct}>
              <PlusIcon size={14} />
              Add product
            </button>
          </div>
        </Field>

        {/* Placement type: none (zone only), prop or npc */}
        <Field label="Storefront — applies to every location">
          <div className="sa-segment">
            <button
              className={`sa-seg-item${draft.placement === 'none' ? ' sa-seg-active' : ''}`}
              onClick={() => setDraft({ ...draft, placement: 'none' })}
            >
              <PinIcon size={14} /> Zone only
            </button>
            <button
              className={`sa-seg-item${draft.placement === 'prop' ? ' sa-seg-active' : ''}`}
              onClick={() => setDraft({ ...draft, placement: 'prop' })}
            >
              <BoxIcon size={14} /> Prop
            </button>
            <button
              className={`sa-seg-item${draft.placement === 'ped' ? ' sa-seg-active' : ''}`}
              onClick={() => setDraft({ ...draft, placement: 'ped' })}
            >
              <PedIcon size={14} /> NPC
            </button>
          </div>
          {draft.placement !== 'none' && (
            <PropSelect
              presets={isPed ? SHOP_PEDS : SHOP_PROPS}
              value={isPed ? draft.pedModel : draft.propModel}
              onChange={(model) =>
                setDraft((d) => (d.placement === 'ped' ? { ...d, pedModel: model } : { ...d, propModel: model }))
              }
            />
          )}
        </Field>

        {/* Locations (multiple) */}
        <Field label={`Locations · ${draft.locations.length}`}>
          <div className="sa-locs">
            {draft.locations.length === 0 && (
              <span className="sa-hint">No locations yet — add one or more below.</span>
            )}
            {draft.locations.map((loc, i) => (
              <div className="sa-loc-row" key={i}>
                <span className="sa-loc-num">#{i + 1}</span>
                <span className="sa-loc-coords">
                  x {loc.x}　y {loc.y}　z {loc.z}
                </span>
                <button className="sa-loc-edit" onClick={() => repositionLocation(i)} title={`Reposition ${placeVerb}`}>
                  {isPed ? <PedIcon size={13} /> : isProp ? <BoxIcon size={13} /> : <PinIcon size={13} />}
                </button>
                <button className="sa-recipe-del" onClick={() => removeLocation(i)} title="Remove location">
                  <TrashIcon size={13} />
                </button>
              </div>
            ))}
            <button className="sa-ghost sa-ghost-accent" onClick={addLocation}>
              <PlusIcon size={14} />
              Add location
            </button>
          </div>
        </Field>

        <Field label="Marker">
          <div className="sa-row-between">
            <span className="sa-hint">Show a floating marker above each location.</span>
            <button
              className={`sa-toggle${draft.showMarker ? ' sa-toggle-on' : ''}`}
              onClick={() => setDraft({ ...draft, showMarker: !draft.showMarker })}
            >
              <span className="sa-toggle-knob" />
            </button>
          </div>
        </Field>

        <Field label="Map blip">
          <div className="sa-row-between">
            <span className="sa-hint">Show a blip on the map for every location.</span>
            <button
              className={`sa-toggle${draft.blip ? ' sa-toggle-on' : ''}`}
              onClick={() => setDraft({ ...draft, blip: !draft.blip })}
            >
              <span className="sa-toggle-knob" />
            </button>
          </div>
          {draft.blip && (
            <div className="sa-grid-2" style={{ marginTop: 8 }}>
              <div className="sa-field">
                <span className="sa-field-label">Blip sprite (icon)</span>
                <input
                  className="sa-input"
                  type="number"
                  placeholder="e.g. 52 (Ammu-Nation)"
                  value={draft.blipSprite}
                  onChange={(e) => setDraft({ ...draft, blipSprite: e.target.value })}
                />
                <span className="sa-hint">Blank = default. See the GTA blip sprite list for IDs (Ammu-Nation 110, Liquor 93, Store 52…).</span>
              </div>
              <div className="sa-field">
                <span className="sa-field-label">Blip colour</span>
                <input
                  className="sa-input"
                  type="number"
                  placeholder="e.g. 1 (red)"
                  value={draft.blipColor}
                  onChange={(e) => setDraft({ ...draft, blipColor: e.target.value })}
                />
                <span className="sa-hint">Blank = default. GTA blip colour ID.</span>
              </div>
            </div>
          )}
        </Field>

        {error && <div className="sa-error">{error}</div>}

        <button className="sa-save" disabled={!canSave || busy} onClick={save}>
          {busy ? 'Saving…' : selected ? 'Save changes' : 'Create shop'}
        </button>
      </div>

      <ConfirmDialog
        open={confirmDel && !!selected}
        title="Delete shop"
        message={`This permanently removes "${selected}". This cannot be undone.`}
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

export default ShopEditor;
