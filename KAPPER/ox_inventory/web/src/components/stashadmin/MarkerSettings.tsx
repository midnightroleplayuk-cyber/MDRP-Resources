import React, { useEffect, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  Appearance,
  AppearanceBlock,
  AppearanceKind,
  BlipConfig,
  DEFAULT_BLOCK,
  MarkerConfig,
  selectStashAdmin,
  setAppearance,
} from '../../store/stashAdmin';
import { fetchNui } from '../../utils/fetchNui';
import useNuiEvent from '../../hooks/useNuiEvent';

// Curated DrawMarker types that read well as a ground marker.
const MARKER_TYPES: { value: number; label: string }[] = [
  { value: 21, label: 'Pillar' },
  { value: 1, label: 'Cylinder' },
  { value: 25, label: 'Ring' },
  { value: 27, label: 'Flat ring' },
  { value: 2, label: 'Chevron' },
  { value: 0, label: 'Cone' },
  { value: 28, label: 'Sphere' },
  { value: 4, label: 'Checkpoint' },
];

// A handful of common GTA blip colours (id → css preview).
const BLIP_COLORS: { value: number; hex: string }[] = [
  { value: 0, hex: '#ffffff' },
  { value: 1, hex: '#ff5252' },
  { value: 2, hex: '#62d676' },
  { value: 3, hex: '#54b6ff' },
  { value: 5, hex: '#fff36b' },
  { value: 17, hex: '#ff9f43' },
  { value: 27, hex: '#7a5cff' },
  { value: 31, hex: '#1f5eff' },
  { value: 38, hex: '#0048f0' },
  { value: 48, hex: '#19e6e6' },
  { value: 49, hex: '#ff63c8' },
];

// Where the blip is shown. GTA display ids: 2 = both, 3 = minimap only,
// 5 = main map only.
const BLIP_DISPLAYS: { value: number; label: string }[] = [
  { value: 2, label: 'Both' },
  { value: 3, label: 'Minimap' },
  { value: 5, label: 'Main map' },
];

// A few useful blip sprites with friendly names (free-text id still allowed).
const BLIP_SPRITES: { value: number; label: string }[] = [
  { value: 566, label: 'Box' },
  { value: 478, label: 'Crate' },
  { value: 402, label: 'Wrench' },
  { value: 446, label: 'Anvil' },
  { value: 52, label: 'Store' },
  { value: 59, label: 'Cart' },
  { value: 605, label: 'Ammu' },
  { value: 500, label: 'Mask' },
];

const rgbToHex = (c: { r: number; g: number; b: number }) =>
  '#' + [c.r, c.g, c.b].map((v) => Math.max(0, Math.min(255, v)).toString(16).padStart(2, '0')).join('');

const hexToRgb = (hex: string) => {
  const m = /^#?([0-9a-f]{6})$/i.exec(hex.trim());
  if (!m) return { r: 31, g: 94, b: 255 };
  const n = parseInt(m[1], 16);
  return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 };
};

const KIND_TABS: { key: AppearanceKind; label: string }[] = [
  { key: 'stash', label: 'Stashes' },
  { key: 'craft', label: 'Crafting' },
  { key: 'shop', label: 'Shops' },
];

// Merge a saved config (possibly partial / legacy flat) into the full per-type
// shape so no control ever reads `undefined`.
const withDefaults = (a: any): Appearance => {
  const mergeBlock = (b: any): AppearanceBlock => ({
    marker: { ...DEFAULT_BLOCK.marker, ...(b?.marker || {}), color: { ...DEFAULT_BLOCK.marker.color, ...(b?.marker?.color || {}) } },
    blip: { ...DEFAULT_BLOCK.blip, ...(b?.blip || {}) },
  });
  // Legacy flat { marker, blip } → spread to all types.
  if (a && (a.marker || a.blip)) {
    return { stash: mergeBlock(a), craft: mergeBlock(a), shop: mergeBlock(a) };
  }
  return { stash: mergeBlock(a?.stash), craft: mergeBlock(a?.craft), shop: mergeBlock(a?.shop) };
};

const MarkerSettings: React.FC = () => {
  const dispatch = useAppDispatch();
  const { appearance } = useAppSelector(selectStashAdmin);

  const [kind, setKind] = useState<AppearanceKind>('stash');
  const [draft, setDraft] = useState<Appearance>(withDefaults(appearance));
  const [busy, setBusy] = useState(false);
  const [saved, setSaved] = useState(false);
  const [preview, setPreview] = useState(false);
  const [copied, setCopied] = useState(false);

  // Pull the latest config when the section mounts.
  useEffect(() => {
    fetchNui<{ allowed?: boolean; appearance?: Appearance }>('getAppearance', {}).then((d) => {
      if (d?.allowed && d.appearance) {
        dispatch(setAppearance(d.appearance));
        setDraft(withDefaults(d.appearance));
      }
    });
    // Make sure preview is stopped if we leave the section.
    return () => {
      fetchNui('appearancePreviewStop', {});
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const marker = draft[kind].marker;
  const blip = draft[kind].blip;

  // Keep the in-world preview in sync with the selected type's marker.
  useEffect(() => {
    if (preview) fetchNui('appearancePreviewUpdate', { marker });
  }, [marker, preview]);

  // Preview can be ended from outside (Esc) — keep the button label in sync.
  useNuiEvent('markerPreviewOff', () => setPreview(false));

  const patchMarker = (p: Partial<MarkerConfig>) => {
    setSaved(false);
    setDraft((d) => ({ ...d, [kind]: { ...d[kind], marker: { ...d[kind].marker, ...p } } }));
  };
  const patchBlip = (p: Partial<BlipConfig>) => {
    setSaved(false);
    setDraft((d) => ({ ...d, [kind]: { ...d[kind], blip: { ...d[kind].blip, ...p } } }));
  };

  const togglePreview = () => {
    if (preview) {
      fetchNui('appearancePreviewStop', {});
      setPreview(false);
    } else {
      fetchNui('appearancePreviewStart', { marker });
      setPreview(true);
    }
  };

  // Copy the current type's config onto the other two types.
  const applyToAll = () => {
    setSaved(false);
    setCopied(true);
    setDraft((d) => ({ stash: d[kind], craft: d[kind], shop: d[kind] }));
    setTimeout(() => setCopied(false), 1500);
  };

  const save = async () => {
    if (busy) return;
    setBusy(true);
    if (preview) {
      fetchNui('appearancePreviewStop', {});
      setPreview(false);
    }
    const res = await fetchNui<{ ok: boolean; appearance?: Appearance }>('saveAppearance', draft);
    setBusy(false);
    if (res?.ok && res.appearance) {
      dispatch(setAppearance(res.appearance));
      setDraft(withDefaults(res.appearance));
      setSaved(true);
    }
  };

  const reset = () => {
    setSaved(false);
    setDraft((d) => ({ ...d, [kind]: DEFAULT_BLOCK }));
  };

  const markerHex = rgbToHex(marker.color);

  return (
    <>
      <div className="sa-main-head">
        <h2>Markers &amp; blips</h2>
        <button className={`ms-preview-btn${preview ? ' ms-preview-on' : ''}`} onClick={togglePreview}>
          <span className="ms-preview-dot" />
          {preview ? 'Stop preview' : 'Preview in world'}
        </button>
      </div>

      <div className="sa-form">
        {/* Type selector — each type has its own marker + blip */}
        <div className="ms-kind-tabs">
          {KIND_TABS.map((t) => (
            <button
              key={t.key}
              className={`ms-kind-tab${kind === t.key ? ' ms-kind-tab-active' : ''}`}
              onClick={() => setKind(t.key)}
            >
              {t.label}
            </button>
          ))}
        </div>

        <span className="ms-group-title">Marker</span>

        {/* Marker shape */}
        <div className="sa-field">
          <span className="sa-field-label">Shape</span>
          <div className="ms-type-grid">
            {MARKER_TYPES.map((t) => (
              <button
                key={t.value}
                className={`ms-type${marker.type === t.value ? ' ms-type-active' : ''}`}
                onClick={() => patchMarker({ type: t.value })}
              >
                <span className={`ms-type-glyph ms-type-${t.value}`} style={{ background: markerHex }} />
                <span className="ms-type-label">{t.label}</span>
              </button>
            ))}
          </div>
          <div className="ms-sprite-custom">
            <span className="sa-hint">Custom marker type id</span>
            <input
              className="sa-input"
              type="number"
              min={0}
              value={marker.type}
              onChange={(e) => patchMarker({ type: Math.max(0, parseInt(e.target.value) || 0) })}
            />
          </div>
        </div>

        {/* Marker color */}
        <div className="sa-field">
          <span className="sa-field-label">Color</span>
          <div className="ms-color-row">
            <label className="ms-color-field">
              <input
                type="color"
                value={markerHex}
                onChange={(e) => patchMarker({ color: hexToRgb(e.target.value) })}
              />
              <span className="ms-color-swatch" style={{ background: markerHex }} />
              <span className="ms-color-hex">{markerHex.toUpperCase()}</span>
            </label>
            <div className="ms-rgb">
              {(['r', 'g', 'b'] as const).map((ch) => (
                <div key={ch} className="ms-rgb-item">
                  <span>{ch.toUpperCase()}</span>
                  <input
                    type="number"
                    min={0}
                    max={255}
                    value={marker.color[ch]}
                    onChange={(e) =>
                      patchMarker({
                        color: { ...marker.color, [ch]: Math.max(0, Math.min(255, parseInt(e.target.value) || 0)) },
                      })
                    }
                  />
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Marker scale + opacity */}
        <div className="sa-grid-2">
          <div className="sa-field">
            <span className="sa-field-label">Size · {marker.scale.toFixed(2)}</span>
            <input
              className="ms-range"
              type="range"
              min={0.1}
              max={2}
              step={0.05}
              value={marker.scale}
              style={{ '--fill': `${((marker.scale - 0.1) / 1.9) * 100}%` } as React.CSSProperties}
              onChange={(e) => patchMarker({ scale: parseFloat(e.target.value) })}
            />
          </div>
          <div className="sa-field">
            <span className="sa-field-label">Opacity · {Math.round((marker.alpha / 255) * 100)}%</span>
            <input
              className="ms-range"
              type="range"
              min={20}
              max={255}
              step={1}
              value={marker.alpha}
              style={{ '--fill': `${((marker.alpha - 20) / 235) * 100}%` } as React.CSSProperties}
              onChange={(e) => patchMarker({ alpha: parseInt(e.target.value, 10) })}
            />
          </div>
        </div>

        {/* Bob animation */}
        <div className="sa-field">
          <div className="sa-row-between">
            <span className="sa-hint">Bob up and down — the marker floats with a gentle animation.</span>
            <button
              className={`sa-toggle${marker.bob ? ' sa-toggle-on' : ''}`}
              onClick={() => patchMarker({ bob: !marker.bob })}
            >
              <span className="sa-toggle-knob" />
            </button>
          </div>
        </div>

        <span className="ms-group-title">Blip</span>

        {/* Blip sprite */}
        <div className="sa-field">
          <span className="sa-field-label">Sprite</span>
          <div className="ms-sprite-grid">
            {BLIP_SPRITES.map((s) => (
              <button
                key={s.value}
                className={`ms-sprite${blip.sprite === s.value ? ' ms-sprite-active' : ''}`}
                onClick={() => patchBlip({ sprite: s.value })}
              >
                <span className="ms-sprite-id">{s.value}</span>
                <span className="ms-sprite-label">{s.label}</span>
              </button>
            ))}
          </div>
          <div className="ms-sprite-custom">
            <span className="sa-hint">Custom sprite id</span>
            <input
              className="sa-input"
              type="number"
              min={1}
              value={blip.sprite}
              onChange={(e) => patchBlip({ sprite: Math.max(1, parseInt(e.target.value) || 1) })}
            />
          </div>
        </div>

        {/* Blip color */}
        <div className="sa-field">
          <span className="sa-field-label">Color</span>
          <div className="ms-blip-colors">
            {BLIP_COLORS.map((c) => (
              <button
                key={c.value}
                className={`ms-blip-color${blip.color === c.value ? ' ms-blip-color-active' : ''}`}
                style={{ background: c.hex }}
                title={`Color ${c.value}`}
                onClick={() => patchBlip({ color: c.value })}
              />
            ))}
          </div>
        </div>

        {/* Blip scale + alpha */}
        <div className="sa-grid-2">
          <div className="sa-field">
            <span className="sa-field-label">Size · {blip.scale.toFixed(2)}</span>
            <input
              className="ms-range"
              type="range"
              min={0.3}
              max={1.4}
              step={0.05}
              value={blip.scale}
              style={{ '--fill': `${((blip.scale - 0.3) / 1.1) * 100}%` } as React.CSSProperties}
              onChange={(e) => patchBlip({ scale: parseFloat(e.target.value) })}
            />
          </div>
          <div className="sa-field">
            <span className="sa-field-label">Opacity · {Math.round((blip.alpha / 255) * 100)}%</span>
            <input
              className="ms-range"
              type="range"
              min={0}
              max={255}
              step={1}
              value={blip.alpha}
              style={{ '--fill': `${(blip.alpha / 255) * 100}%` } as React.CSSProperties}
              onChange={(e) => patchBlip({ alpha: parseInt(e.target.value, 10) })}
            />
          </div>
        </div>

        {/* Blip display */}
        <div className="sa-field">
          <span className="sa-field-label">Show on</span>
          <div className="sa-segment">
            {BLIP_DISPLAYS.map((d) => (
              <button
                key={d.value}
                className={`sa-seg-item${blip.display === d.value ? ' sa-seg-active' : ''}`}
                onClick={() => patchBlip({ display: d.value })}
              >
                <span>{d.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Short range */}
        <div className="sa-field">
          <div className="sa-row-between">
            <span className="sa-hint">Short range — the blip only appears on the minimap when nearby.</span>
            <button
              className={`sa-toggle${blip.shortRange ? ' sa-toggle-on' : ''}`}
              onClick={() => patchBlip({ shortRange: !blip.shortRange })}
            >
              <span className="sa-toggle-knob" />
            </button>
          </div>
        </div>

        {/* Custom blip name */}
        <div className="sa-field">
          <span className="sa-field-label">Custom name — optional</span>
          <input
            className="sa-input"
            value={blip.name ?? ''}
            placeholder="Leave empty to use each location's label"
            maxLength={40}
            onChange={(e) => patchBlip({ name: e.target.value })}
          />
        </div>

        <button className="ms-applyall" onClick={applyToAll}>
          {copied ? 'Copied to all types ✓' : `Apply ${KIND_TABS.find((t) => t.key === kind)?.label} settings to all types`}
        </button>

        <div className="ms-actions">
          <button className="ms-reset" onClick={reset}>
            Reset this type
          </button>
          <button className="sa-save ms-save" disabled={busy} onClick={save}>
            {busy ? 'Saving…' : saved ? 'Saved ✓' : 'Save appearance'}
          </button>
        </div>
      </div>
    </>
  );
};

export default MarkerSettings;
