import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import {
  applyTemplate,
  BG_PRESETS,
  CUSTOM_TEMPLATE,
  InventoryTemplate,
  pickVisual,
  receiveGlobalTheme,
  resetSettings,
  selectRawSettings,
  selectReadOnly,
  selectSettings,
  setAdminLock,
  setAdminMode,
  setBgColor,
  setBgOpacity,
  setRarityColors,
  setShowClock,
  setShowEscHint,
  setShowItemNames,
  setShowLocation,
  setShowProfileCard,
  setShowStats,
  setShowTemp,
  setShowWeight,
  setSlotShape,
  setThemeColor,
  setTitleShape,
  setUiSize,
  SlotShape,
  TEMPLATES,
  THEME_PRESETS,
  TitleShape,
  UiSize,
} from '../../store/settings';
import { Locale } from '../../store/locale';
import { RARITY_COLORS, RARITY_LABELS } from '../../helpers/itemMeta';
import { fetchNui } from '../../utils/fetchNui';

const SLOT_SHAPES: { value: SlotShape; label: string }[] = [
  { value: 'rounded', label: 'Rounded' },
  { value: 'square', label: 'Square' },
];

const TITLE_SHAPES: { value: TitleShape; label: string }[] = [
  { value: 'rounded', label: 'Rounded' },
  { value: 'square', label: 'Square' },
  { value: 'circle', label: 'Circle' },
  { value: 'hexagon', label: 'Hexagon' },
  { value: 'diamond', label: 'Diamond' },
];

const UI_SIZES: { value: UiSize; label: string }[] = [
  { value: 'small', label: 'Small' },
  { value: 'medium', label: 'Medium' },
  { value: 'large', label: 'Large' },
];

// Mirrors SettingsApplier's shape mapping so a preview looks like the real thing.
const PREVIEW_SLOT_RADIUS: Record<SlotShape, string> = { rounded: '6px', square: '2px' };
const PREVIEW_TITLE: Record<TitleShape, React.CSSProperties> = {
  rounded: { borderRadius: '4px' },
  square: { borderRadius: '1px' },
  circle: { borderRadius: '50%' },
  hexagon: { clipPath: 'polygon(25% 5%, 75% 5%, 100% 50%, 75% 95%, 25% 95%, 0% 50%)' },
  diamond: { clipPath: 'polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%)' },
};

const hexToRgba = (hex: string, alpha: number): string => {
  const clean = hex.replace('#', '');
  const full = clean.length === 3 ? clean.split('').map((c) => c + c).join('') : clean;
  const r = parseInt(full.substring(0, 2), 16) || 0;
  const g = parseInt(full.substring(2, 4), 16) || 0;
  const b = parseInt(full.substring(4, 6), 16) || 0;
  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};

const Toggle: React.FC<{ label: string; sub: string; on: boolean; onChange: () => void }> = ({
  label,
  sub,
  on,
  onChange,
}) => (
  <div className="settings-section settings-section-row">
    <div>
      <span className="settings-label">{label}</span>
      <span className="settings-sub">{sub}</span>
    </div>
    <button
      className={`settings-toggle${on ? ' settings-toggle-on' : ''}`}
      onClick={onChange}
      role="switch"
      aria-checked={on}
    >
      <span className="settings-toggle-knob" />
    </button>
  </div>
);

/**
 * Miniature of the inventory rendered with the template's own colours, opacity
 * and geometry — sitting on a faux "game world" backdrop so the transparency of
 * a glass template reads differently from an opaque one.
 */
const TemplatePreview: React.FC<{ tpl: InventoryTemplate }> = ({ tpl }) => {
  const { themeColor, bgColor, bgOpacity, slotShape, titleShape, gridSpatial, rarityColors } = tpl.values;
  const op = bgOpacity / 100;
  const radius = PREVIEW_SLOT_RADIUS[slotShape];

  // Highlighted cells: rarity tiers when the template colours by rarity, else the
  // brand accent. A spatial template shows one cell spanning two columns.
  const accents: Record<number, string> = rarityColors
    ? { 1: RARITY_COLORS.legendary, 5: RARITY_COLORS.rare }
    : { 1: themeColor };

  // A 2-wide cell eats one of the 8 slots, so render 7 to keep two tidy rows.
  const cells = gridSpatial ? 7 : 8;

  return (
    <span className="tpl-preview">
      <span className="tpl-preview-world" />
      <span className="tpl-preview-panel" style={{ backgroundColor: hexToRgba(bgColor, op) }}>
        <span className="tpl-preview-nav">
          <span className="tpl-preview-badge" style={{ backgroundColor: themeColor, ...PREVIEW_TITLE[titleShape] }} />
          <span className="tpl-preview-line" />
          <span className="tpl-preview-line tpl-preview-line-sm" />
        </span>
        <span className="tpl-preview-grid" style={gridSpatial ? { gridAutoFlow: 'row dense' } : undefined}>
          {Array.from({ length: cells }).map((_, i) => {
            const accent = accents[i];
            return (
              <span
                key={i}
                className="tpl-preview-slot"
                style={{
                  borderRadius: radius,
                  backgroundColor: hexToRgba(bgColor, Math.min(1, op + 0.14)),
                  borderColor: accent || 'rgba(255, 255, 255, 0.1)',
                  boxShadow: accent ? `0 0 10px ${hexToRgba(accent, 0.45)}` : 'none',
                  gridColumn: gridSpatial && i === 1 ? 'span 2' : undefined,
                }}
              />
            );
          })}
        </span>
      </span>
    </span>
  );
};

// Inline settings page — lives in the normal screen flow (like the inventory /
// wardrobe), NOT a floating modal over the UI.
const SettingsPanel: React.FC = () => {
  const dispatch = useAppDispatch();
  const settings = useAppSelector(selectSettings);
  const raw = useAppSelector(selectRawSettings);
  const readOnly = useAppSelector(selectReadOnly);

  const { isAdmin, adminMode, adminLock } = raw;

  // ── Admin broadcast ────────────────────────────────────────────
  // While admin mode is on, every visual change the admin makes is pushed to
  // every player. Debounced so dragging the opacity slider doesn't spam the
  // server, and de-duplicated so an unchanged payload never round-trips.
  const timer = useRef<number | undefined>(undefined);
  const lastSent = useRef<string>('');
  const [pushed, setPushed] = useState(false);
  const payload = JSON.stringify({ settings: pickVisual(settings), locked: adminLock });

  useEffect(() => {
    if (!isAdmin || !adminMode) return;
    if (payload === lastSent.current) return;

    window.clearTimeout(timer.current);
    timer.current = window.setTimeout(async () => {
      lastSent.current = payload;
      const body = JSON.parse(payload);
      const res = await fetchNui<{ ok?: boolean }>('setUiTheme', body).catch(() => null);
      if (!res?.ok) {
        lastSent.current = ''; // let the next change retry
        return;
      }
      setPushed(true);
      dispatch(receiveGlobalTheme(body));
    }, 350);

    return () => window.clearTimeout(timer.current);
  }, [dispatch, isAdmin, adminMode, payload]);

  // Leaving admin mode stops the broadcast but leaves the last pushed theme live.
  useEffect(() => {
    if (!adminMode) lastSent.current = '';
  }, [adminMode]);

  const clearGlobal = useCallback(async () => {
    const res = await fetchNui<{ ok?: boolean }>('clearUiTheme', {}).catch(() => null);
    if (!res?.ok) return;
    lastSent.current = '';
    setPushed(false);
    dispatch(receiveGlobalTheme(null));
  }, [dispatch]);

  const globalActive = !!raw.enforced || pushed;

  // ── Fit-to-screen ──────────────────────────────────────────────
  // Todas as definições têm de ser visíveis sem scroll, em qualquer resolução.
  // Medimos a altura natural do conteúdo (offsetHeight ignora o transform, por
  // isso não há loop de feedback) e encolhemos até caber na área útil da página.
  const pageRef = useRef<HTMLDivElement>(null);
  const fitRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(1);

  useEffect(() => {
    const page = pageRef.current;
    const fit = fitRef.current;
    if (!page || !fit) return;

    const measure = () => {
      const style = getComputedStyle(page);
      const availH = page.clientHeight - parseFloat(style.paddingTop) - parseFloat(style.paddingBottom);
      const availW = page.clientWidth - parseFloat(style.paddingLeft) - parseFloat(style.paddingRight);
      const h = fit.offsetHeight;
      const w = fit.offsetWidth;
      if (!h || !w || availH <= 0 || availW <= 0) return;
      setScale(Math.min(1, availH / h, availW / w));
    };

    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(fit);
    ro.observe(page);
    return () => ro.disconnect();
  }, []);

  return (
    <div ref={pageRef} className={`settings-page${readOnly ? ' settings-page-locked' : ''}`}>
      <div ref={fitRef} className="settings-fit" style={{ transform: `scale(${scale})` }}>
      {readOnly && (
        <div className="settings-lock-banner">
          <svg viewBox="0 0 24 24" width={15} height={15} fill="none" stroke="currentColor" strokeWidth={2}>
            <path d="M7 11V8a5 5 0 0 1 10 0v3 M5 11h14v10H5z" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
          <span>{Locale.ui_theme_locked || "The inventory's look is set by the server administrator."}</span>
        </div>
      )}

      <div className="settings-grid">
        {/* ── Templates ── */}
        <div className="settings-card settings-card-wide">
          <div className="settings-card-head">{Locale.ui_templates || 'Templates'}</div>

          <div className="settings-section">
            <span className="settings-sub settings-templates-hint">
              {Locale.ui_templates_sub || 'One click swaps colour, opacity, geometry, size and HUD at once.'}
            </span>
            <div className="tpl-grid">
              {TEMPLATES.map((tpl) => (
                <button
                  key={tpl.id}
                  className={`tpl-card${settings.template === tpl.id ? ' tpl-card-active' : ''}`}
                  disabled={readOnly}
                  onClick={() => dispatch(applyTemplate(tpl.id))}
                >
                  <TemplatePreview tpl={tpl} />
                  <span className="tpl-meta">
                    <span className="tpl-name">{tpl.label}</span>
                    <span className="tpl-desc">{Locale[tpl.descKey] || tpl.desc}</span>
                  </span>
                </button>
              ))}
            </div>
            {settings.template === CUSTOM_TEMPLATE && (
              <span className="settings-sub tpl-custom-hint">
                {Locale.ui_templates_custom || 'Custom — tweaked by hand below.'}
              </span>
            )}
          </div>
        </div>

        {/* ── Appearance ── */}
        <div className={`settings-card${readOnly ? ' settings-card-disabled' : ''}`}>
          <div className="settings-card-head">{Locale.ui_appearance || 'Appearance'}</div>

          <div className="settings-section">
            <span className="settings-label">{Locale.ui_brand_color || 'Brand colour'}</span>
            <div className="settings-swatches">
              {THEME_PRESETS.map((preset) => (
                <button
                  key={preset.value}
                  className={`settings-swatch${
                    settings.themeColor.toLowerCase() === preset.value ? ' settings-swatch-active' : ''
                  }`}
                  style={{ backgroundColor: preset.value }}
                  title={preset.label}
                  onClick={() => dispatch(setThemeColor(preset.value))}
                />
              ))}
              <label className="settings-swatch settings-swatch-custom" title={Locale.ui_custom || 'Custom'}>
                <input type="color" value={settings.themeColor} onChange={(e) => dispatch(setThemeColor(e.target.value))} />
                <span>+</span>
              </label>
            </div>
          </div>

          <div className="settings-section">
            <span className="settings-label">{Locale.ui_bg || 'Inventory background'}</span>
            <div className="settings-swatches">
              {BG_PRESETS.map((preset) => (
                <button
                  key={preset.value}
                  className={`settings-swatch${
                    settings.bgColor.toLowerCase() === preset.value ? ' settings-swatch-active' : ''
                  }`}
                  style={{ backgroundColor: preset.value }}
                  title={Locale[preset.labelKey] || preset.label}
                  onClick={() => dispatch(setBgColor(preset.value))}
                />
              ))}
              <label className="settings-swatch settings-swatch-custom" title={Locale.ui_custom || 'Custom'}>
                <input type="color" value={settings.bgColor} onChange={(e) => dispatch(setBgColor(e.target.value))} />
                <span>+</span>
              </label>
            </div>
            <div className="settings-slider-field settings-slider-block">
              <span className="settings-sub">{Locale.ui_opacity || 'Opacity'} {settings.bgOpacity}%</span>
              <input
                type="range"
                min={20}
                max={100}
                step={1}
                value={settings.bgOpacity}
                style={{ '--fill': `${((settings.bgOpacity - 20) / 80) * 100}%` } as React.CSSProperties}
                onChange={(e) => dispatch(setBgOpacity(parseInt(e.target.value, 10)))}
              />
            </div>
          </div>

          <div className="settings-section">
            <span className="settings-label">{Locale.ui_size || 'Size'}</span>
            <div className="settings-segment">
              {UI_SIZES.map((size) => (
                <button
                  key={size.value}
                  className={`settings-segment-item${settings.uiSize === size.value ? ' settings-segment-active' : ''}`}
                  onClick={() => dispatch(setUiSize(size.value))}
                >
                  <span className={`settings-size-preview settings-size-${size.value}`} />
                  {size.label}
                </button>
              ))}
            </div>
          </div>

          <div className="settings-section">
            <span className="settings-label">{Locale.ui_title_shape || 'Title icon shape'}</span>
            <div className="settings-segment settings-segment-wrap">
              {TITLE_SHAPES.map((shape) => (
                <button
                  key={shape.value}
                  className={`settings-segment-item${settings.titleShape === shape.value ? ' settings-segment-active' : ''}`}
                  onClick={() => dispatch(setTitleShape(shape.value))}
                >
                  <span className={`settings-shape-preview settings-title-preview-${shape.value}`} />
                  {shape.label}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* ── Grid & items ── */}
        <div className={`settings-card${readOnly ? ' settings-card-disabled' : ''}`}>
          <div className="settings-card-head">{Locale.ui_grid || 'Grid & items'}</div>

          <div className="settings-section">
            <span className="settings-label">{Locale.ui_slot_shape || 'Slot shape'}</span>
            <div className="settings-segment">
              {SLOT_SHAPES.map((shape) => (
                <button
                  key={shape.value}
                  className={`settings-segment-item${settings.slotShape === shape.value ? ' settings-segment-active' : ''}`}
                  onClick={() => dispatch(setSlotShape(shape.value))}
                >
                  <span className={`settings-shape-preview settings-shape-${shape.value}`} />
                  {shape.label}
                </button>
              ))}
            </div>
          </div>

          <Toggle
            label={Locale.ui_rarity_colors || 'Rarity colours'}
            sub={Locale.ui_rarity_colors_sub || 'Tint each slot with the colour of the item tier.'}
            on={settings.rarityColors}
            onChange={() => dispatch(setRarityColors(!settings.rarityColors))}
          />
          <Toggle
            label={Locale.ui_show_weight || 'Weight'}
            sub={Locale.ui_show_weight_sub || 'Show the weight on each slot'}
            on={settings.showWeight}
            onChange={() => dispatch(setShowWeight(!settings.showWeight))}
          />
          <Toggle
            label={Locale.ui_show_names || 'Show names'}
            sub={Locale.ui_show_names_sub || 'Item name always visible (no hover)'}
            on={settings.showItemNames}
            onChange={() => dispatch(setShowItemNames(!settings.showItemNames))}
          />

          {settings.rarityColors && (
            <div className="settings-section">
              <span className="settings-label">{Locale.ui_rarity_legend || 'Tiers'}</span>
              <div className="rarity-legend">
                {(Object.keys(RARITY_COLORS) as (keyof typeof RARITY_COLORS)[]).map((tier) => (
                  <span key={tier} className="rarity-chip">
                    <span className="rarity-chip-dot" style={{ backgroundColor: RARITY_COLORS[tier] }} />
                    {Locale['ui_rarity_' + tier] || RARITY_LABELS[tier]}
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* ── Interface ── */}
        <div className={`settings-card${readOnly ? ' settings-card-disabled' : ''}`}>
          <div className="settings-card-head">{Locale.ui_display || 'Display'}</div>

          <Toggle
            label={Locale.ui_show_profile || 'Profile card'}
            sub={Locale.ui_show_profile_sub || 'Show the player card on the left'}
            on={settings.showProfileCard}
            onChange={() => dispatch(setShowProfileCard(!settings.showProfileCard))}
          />
          <Toggle
            label={Locale.ui_show_stats || 'Status card'}
            sub={Locale.ui_show_stats_sub || 'Health, armour, hunger & thirst'}
            on={settings.showStats}
            onChange={() => dispatch(setShowStats(!settings.showStats))}
          />
          <Toggle
            label={Locale.ui_show_location || 'Location'}
            sub={Locale.ui_show_location_sub || 'LOS SANTOS in the top bar'}
            on={settings.showLocation}
            onChange={() => dispatch(setShowLocation(!settings.showLocation))}
          />
          <Toggle
            label={Locale.ui_show_clock || 'Clock'}
            sub={Locale.ui_show_clock_sub || 'Time in the top bar'}
            on={settings.showClock}
            onChange={() => dispatch(setShowClock(!settings.showClock))}
          />
          <Toggle
            label={Locale.ui_show_temp || 'Temperature'}
            sub={Locale.ui_show_temp_sub || 'Degrees in the top bar'}
            on={settings.showTemp}
            onChange={() => dispatch(setShowTemp(!settings.showTemp))}
          />
          <Toggle
            label={Locale.ui_show_esc || 'ESC hint'}
            sub={Locale.ui_show_esc_sub || '“ESC · Close” in the corner'}
            on={settings.showEscHint}
            onChange={() => dispatch(setShowEscHint(!settings.showEscHint))}
          />

          <button className="settings-reset" onClick={() => dispatch(resetSettings())}>
            {Locale.ui_reset || 'Reset to defaults'}
          </button>
        </div>

        {/* ── Server / admin (only rendered for holders of ox_inventory.admin) ── */}
        {isAdmin && (
          <div className={`settings-card settings-card-wide settings-card-admin${adminMode ? ' is-live' : ''}`}>
            <div className="settings-card-head settings-card-head-admin">
              <span>{Locale.ui_admin || 'Server · Administration'}</span>
              {adminMode && (
                <span className="settings-live-pill">
                  <span className="settings-live-dot" />
                  {Locale.ui_admin_live || 'Broadcasting'}
                </span>
              )}
            </div>

            <Toggle
              label={Locale.ui_admin_mode || 'Admin mode'}
              sub={
                Locale.ui_admin_mode_sub ||
                "While this is on, everything you change here is applied to every player's inventory."
              }
              on={adminMode}
              onChange={() => dispatch(setAdminMode(!adminMode))}
            />

            {adminMode && (
              <>
                <Toggle
                  label={Locale.ui_admin_lock || 'Lock customisation'}
                  sub={
                    Locale.ui_admin_lock_sub ||
                    "Players cannot change the look — the server theme wins. Off, it's just a theme they may edit afterwards."
                  }
                  on={adminLock}
                  onChange={() => dispatch(setAdminLock(!adminLock))}
                />

                <div className="settings-section settings-admin-actions">
                  <span className="settings-sub">
                    {globalActive
                      ? Locale.ui_admin_active ||
                        'Global theme active — saved, and applied to players who join later too.'
                      : Locale.ui_admin_idle || 'Change any setting above to broadcast.'}
                  </span>
                  <button className="settings-danger" onClick={clearGlobal}>
                    {Locale.ui_admin_clear || 'Remove global theme'}
                  </button>
                </div>
              </>
            )}
          </div>
        )}
        </div>
      </div>
    </div>
  );
};

export default SettingsPanel;
