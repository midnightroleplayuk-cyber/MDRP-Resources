// Prop presets per manager type, plus a "custom model" escape hatch.
export interface PropPreset {
  model: string;
  label: string;
}

export const STASH_PROPS: PropPreset[] = [
  { model: 'prop_drop_crate_01', label: 'Crate' },
  { model: 'prop_ld_int_safe_01', label: 'Safe (small)' },
  { model: 'p_v_43_safe_s', label: 'Safe (wall)' },
];

export const CRAFT_PROPS: PropPreset[] = [
  { model: 'prop_tool_bench02', label: 'Tool bench' },
  { model: 'prop_tool_bench02_ld', label: 'Tool bench (LD)' },
  { model: 'gr_prop_gr_bench_02', label: 'Gunrunning bench' },
];

export const SHOP_PROPS: PropPreset[] = [
  { model: 'prop_till_01', label: 'Till / register' },
  { model: 'prop_vend_soda_02', label: 'Soda machine' },
  { model: 'prop_vend_water_01', label: 'Water machine' },
];

// A few common shopkeeper peds for the NPC option.
export const SHOP_PEDS: PropPreset[] = [
  { model: 'mp_m_shopkeep_01', label: 'Shopkeeper' },
  { model: 's_m_m_linecook', label: 'Cook' },
  { model: 's_m_y_dealer_01', label: 'Dealer' },
  { model: 's_m_y_ammucity_01', label: 'Ammu clerk' },
];

export const STASH_DEFAULT_PROP = STASH_PROPS[0].model;
export const CRAFT_DEFAULT_PROP = CRAFT_PROPS[0].model;
export const SHOP_DEFAULT_PROP = SHOP_PROPS[0].model;
export const SHOP_DEFAULT_PED = SHOP_PEDS[0].model;
