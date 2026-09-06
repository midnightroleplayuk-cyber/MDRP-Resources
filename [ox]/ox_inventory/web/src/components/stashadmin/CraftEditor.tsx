import React, { useMemo, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  CraftBench,
  CraftRecipe,
  PlacedLocation,
  removeBench,
  selectStashAdmin,
  upsertBench,
} from '../../store/stashAdmin';
import { fetchNui } from '../../utils/fetchNui';
import { BoxIcon, PinIcon, PlusIcon, TrashIcon } from './icons';
import PropSelect from './PropSelect';
import { CRAFT_DEFAULT_PROP, CRAFT_PROPS } from './propPresets';
import ItemSelect from './ItemSelect';
import ConfirmDialog from './ConfirmDialog';

interface Props {
  selected: string | null;
  setSelected: (id: string | null) => void;
  startPlacement: (mode: 'follow' | 'prop', payload: any, onResult: (r: any) => void) => void;
}

type PlaceType = 'none' | 'prop';

interface DraftBench {
  id: string;
  label: string;
  groups: Record<string, number>;
  recipes: CraftRecipe[];
  locations: PlacedLocation[];
  placement: PlaceType;
  propModel: string;
  showMarker: boolean;
  blip: boolean;
}

// Normalise a bench's coords (single object or array) into a locations array.
const toLocations = (c?: any): PlacedLocation[] => {
  if (!c) return [];
  const arr = Array.isArray(c) ? c : [c];
  return arr.filter(Boolean).map((l) => ({ x: l.x, y: l.y, z: l.z, heading: l.heading ?? 0 }));
};

const emptyDraft = (): DraftBench => ({
  id: '',
  label: '',
  groups: {},
  recipes: [],
  locations: [],
  placement: 'prop',
  propModel: CRAFT_DEFAULT_PROP,
  showMarker: true,
  blip: false,
});

const toDraft = (b: CraftBench): DraftBench => ({
  id: b.id,
  label: b.label,
  groups: b.groups || {},
  // Stored durations are in ms; the editor edits seconds, so convert back.
  recipes: (b.recipes || []).map((r) => ({ ...r, duration: Math.round((r.duration ?? 3000) / 1000) })),
  locations: toLocations(b.coords),
  placement: b.prop?.enabled ? 'prop' : 'none',
  propModel: b.prop?.model || CRAFT_DEFAULT_PROP,
  showMarker: (b as any).showMarker ?? true,
  blip: (b as any).blip ?? false,
});

const newRecipe = (): CraftRecipe => ({ name: '', count: 1, duration: 5, ingredients: [{ name: '', count: 1 }] });

const CraftEditor: React.FC<Props> = ({ selected, setSelected, startPlacement }) => {
  const dispatch = useAppDispatch();
  const { benches, items, jobs } = useAppSelector(selectStashAdmin);

  const [draft, setDraft] = useState<DraftBench>(emptyDraft());
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [confirmDel, setConfirmDel] = useState(false);

  React.useEffect(() => {
    if (selected) {
      const b = benches.find((x) => x.id === selected);
      if (b) setDraft(toDraft(b));
    } else {
      setDraft(emptyDraft());
    }
    setError(null);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selected]);

  const isProp = draft.placement === 'prop';

  // Add a new location: walk-to (zone only) or prop placement editor.
  const addLocation = () => {
    if (!isProp) {
      startPlacement('follow', { prop: false }, (r) =>
        setDraft((d) => ({ ...d, locations: [...d.locations, { ...r.coords, heading: r.heading }] }))
      );
      return;
    }
    startPlacement('prop', { prop: true, model: draft.propModel, kind: 'craft' }, (r) =>
      setDraft((d) => ({
        ...d,
        locations: [...d.locations, { ...r.coords, heading: r.rotation?.z ?? r.heading ?? 0 }],
      }))
    );
  };

  // Reposition an existing location in place.
  const repositionLocation = (i: number) => {
    const loc = draft.locations[i];
    if (!isProp) {
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
      { prop: true, model: draft.propModel, kind: 'craft', name: selected || undefined, coords: loc, rotation: { x: 0, y: 0, z: loc.heading ?? 0 } },
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
  const setJobGrade = (job: string, grade: number) => setDraft((d) => ({ ...d, groups: { ...d.groups, [job]: grade } }));

  // Recipe helpers
  const addRecipe = () => setDraft((d) => ({ ...d, recipes: [...d.recipes, newRecipe()] }));
  const removeRecipe = (i: number) => setDraft((d) => ({ ...d, recipes: d.recipes.filter((_, idx) => idx !== i) }));
  const patchRecipe = (i: number, patch: Partial<CraftRecipe>) =>
    setDraft((d) => ({ ...d, recipes: d.recipes.map((r, idx) => (idx === i ? { ...r, ...patch } : r)) }));
  const addIngredient = (ri: number) =>
    patchRecipe(ri, { ingredients: [...draft.recipes[ri].ingredients, { name: '', count: 1 }] });
  const removeIngredient = (ri: number, ii: number) =>
    patchRecipe(ri, { ingredients: draft.recipes[ri].ingredients.filter((_, idx) => idx !== ii) });
  const patchIngredient = (ri: number, ii: number, patch: Partial<{ name: string; count: number }>) =>
    patchRecipe(ri, {
      ingredients: draft.recipes[ri].ingredients.map((g, idx) => (idx === ii ? { ...g, ...patch } : g)),
    });

  const canSave = useMemo(() => {
    if (!draft.id.trim() || !draft.label.trim()) return false;
    return draft.locations.length > 0;
  }, [draft]);

  const save = async () => {
    if (!canSave || busy) return;
    setBusy(true);
    setError(null);

    const cleanRecipes = draft.recipes
      .filter((r) => r.name.trim())
      .map((r) => ({
        name: r.name,
        count: r.count,
        // Editor edits seconds → store ms. Clamp to a sane 1s–3600s range so a
        // bad value can never blow up (and re-saving fixes corrupted rows).
        duration: Math.min(3600, Math.max(1, r.duration || 5)) * 1000,
        ingredients: r.ingredients.filter((g) => g.name.trim()).map((g) => ({ name: g.name, count: g.count })),
      }));

    const payload = {
      id: draft.id.trim(),
      label: draft.label.trim(),
      groups: Object.keys(draft.groups).length ? draft.groups : undefined,
      recipes: cleanRecipes,
      // Always an array of {x,y,z,heading} — the backend builds a point/zone per entry.
      coords: draft.locations,
      prop: isProp ? { enabled: true, model: draft.propModel } : undefined,
      showMarker: draft.showMarker,
      blip: draft.blip,
    };

    const res = await fetchNui<{ ok: boolean; bench?: CraftBench; error?: string }>('saveCustomCraft', payload);
    setBusy(false);
    if (!res?.ok) {
      setError(res?.error || 'Failed to save');
      return;
    }
    if (res.bench) {
      dispatch(upsertBench(res.bench));
      setSelected(res.bench.id);
    }
  };

  const del = async (id: string) => {
    if (busy) return;
    setBusy(true);
    const res = await fetchNui<{ ok: boolean }>('deleteCustomCraft', { id });
    setBusy(false);
    if (res?.ok) {
      dispatch(removeBench(id));
      setSelected(null);
    }
  };

  return (
    <>
      <div className="sa-main-head">
        <h2>{selected ? 'Edit bench' : 'Create crafting bench'}</h2>
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
              placeholder="weapon_bench"
              onChange={(e) => setDraft({ ...draft, id: e.target.value })}
            />
          </Field>
          <Field label="Display label">
            <input
              className="sa-input"
              value={draft.label}
              placeholder="Weapon Bench"
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

        {/* Recipes */}
        <Field label="Recipes">
          <div className="sa-recipes">
            {draft.recipes.length === 0 && <span className="sa-hint">No recipes yet — add one below.</span>}
            {draft.recipes.map((r, ri) => (
              <div className="sa-recipe" key={ri}>
                <div className="sa-recipe-head">
                  <span className="sa-recipe-num">#{ri + 1}</span>
                  <div className="sa-recipe-result">
                    <ItemSelect
                      items={items}
                      value={r.name}
                      placeholder="Result item"
                      onChange={(name) => patchRecipe(ri, { name })}
                    />
                  </div>
                  <button className="sa-recipe-del" onClick={() => removeRecipe(ri)} title="Remove recipe">
                    <TrashIcon size={13} />
                  </button>
                </div>

                <div className="sa-recipe-meta">
                  <label className="sa-mini-field">
                    <span>Amount</span>
                    <input
                      className="sa-input sa-input-mini"
                      type="number"
                      value={r.count}
                      onChange={(e) => patchRecipe(ri, { count: Math.max(1, parseInt(e.target.value) || 1) })}
                    />
                  </label>
                  <label className="sa-mini-field">
                    <span>Duration (s)</span>
                    <input
                      className="sa-input sa-input-mini"
                      type="number"
                      value={r.duration}
                      onChange={(e) => patchRecipe(ri, { duration: Math.max(0, parseInt(e.target.value) || 0) })}
                    />
                  </label>
                </div>

                <div className="sa-ingredients">
                  <span className="sa-ing-title">Ingredients</span>
                  {r.ingredients.map((g, ii) => (
                    <div className="sa-ingredient" key={ii}>
                      <ItemSelect
                        items={items}
                        value={g.name}
                        placeholder="Ingredient"
                        onChange={(name) => patchIngredient(ri, ii, { name })}
                      />
                      <input
                        className="sa-input sa-input-mini"
                        type="number"
                        value={g.count}
                        onChange={(e) => patchIngredient(ri, ii, { count: Math.max(1, parseInt(e.target.value) || 1) })}
                      />
                      <button className="sa-ing-del" onClick={() => removeIngredient(ri, ii)}>
                        ×
                      </button>
                    </div>
                  ))}
                  <button className="sa-ing-add" onClick={() => addIngredient(ri)}>
                    <PlusIcon size={12} />
                    Ingredient
                  </button>
                </div>
              </div>
            ))}
            <button className="sa-ghost" onClick={addRecipe}>
              <PlusIcon size={14} />
              Add recipe
            </button>
          </div>
        </Field>

        {/* Placement type */}
        <Field label="Bench placement — applies to every location">
          <div className="sa-segment">
            <button
              className={`sa-seg-item${draft.placement === 'none' ? ' sa-seg-active' : ''}`}
              onClick={() => setDraft({ ...draft, placement: 'none' })}
            >
              <PinIcon size={15} />
              <span>Zone only</span>
            </button>
            <button
              className={`sa-seg-item${draft.placement === 'prop' ? ' sa-seg-active' : ''}`}
              onClick={() => setDraft({ ...draft, placement: 'prop' })}
            >
              <BoxIcon size={15} />
              <span>Prop</span>
            </button>
          </div>
          {isProp && (
            <PropSelect
              presets={CRAFT_PROPS}
              value={draft.propModel}
              onChange={(model) => setDraft({ ...draft, propModel: model })}
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
                <button
                  className="sa-loc-edit"
                  onClick={() => repositionLocation(i)}
                  title={isProp ? 'Reposition prop' : 'Reposition zone'}
                >
                  {isProp ? <BoxIcon size={13} /> : <PinIcon size={13} />}
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
            <span className="sa-hint">Show a floating marker above the bench.</span>
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
            <span className="sa-hint">Show a blip on the map for this bench.</span>
            <button
              className={`sa-toggle${draft.blip ? ' sa-toggle-on' : ''}`}
              onClick={() => setDraft({ ...draft, blip: !draft.blip })}
            >
              <span className="sa-toggle-knob" />
            </button>
          </div>
        </Field>

        {error && <div className="sa-error">{error}</div>}

        <button className="sa-save" disabled={!canSave || busy} onClick={save}>
          {busy ? 'Saving…' : selected ? 'Save changes' : 'Create bench'}
        </button>
      </div>

      <ConfirmDialog
        open={confirmDel && !!selected}
        title="Delete bench"
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

export default CraftEditor;
