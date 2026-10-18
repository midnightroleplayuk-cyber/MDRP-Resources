# Compatibility: the GTA files this map overrides

RHS Burton Hospital replaces the Los Santos Customs in Burton, so it ships edited copies of the GTA files for that
tile. They are in `stream/vanilla/` and are **not encrypted**, so Vertex Hub can read and merge them.

Two resources that ship a file with the same name clash: only one copy loads. If another map on your server
edits any file below, merge the two with Vertex Hub and let the merged resource start last.

All of this resource's own files start with `rhs`; nothing outside `stream/vanilla/` carries a GTA name.

## Map placement (ymap)

The Burton tile and its Online variants. The old Customs is removed from the tile.

- `apa_bt1_02_interior_v_carmod_milo_.ymap`
- `apa_bt1_02_strm_0.ymap`
- `apa_ss1_rd1.ymap`
- `apa_ss1_rd1_critical_1.ymap`
- `apa_ss1_rd1_long_0.ymap`
- `apa_ss1_rd1_strm_2.ymap`
- `bt1_02_interior_v_carmod_milo_.ymap`
- `bt1_02_strm_0.ymap`
- `hei_bt1_02_interior_v_carmod_milo_.ymap`
- `hei_bt1_02_strm_0.ymap`
- `hei_ss1_rd1.ymap`
- `hei_ss1_rd1_critical_1.ymap`
- `hei_ss1_rd1_long_0.ymap`
- `hei_ss1_rd1_strm_2.ymap`
- `ss1_rd1.ymap`
- `ss1_rd1_critical_1.ymap`
- `ss1_rd1_long_0.ymap`
- `ss1_rd1_strm_2.ymap`

## Occluders (ymap)

Occlusion boxes for the tile.

- `apa_ss1_occl_00.ymap`
- `hei_ss1_occl_00.ymap`
- `ss1_occl_00.ymap`

## Lod lights (ymap)

Lights that sat inside the hospital footprint are removed.

- `apa_distlodlights_medium015.ymap`
- `apa_lodlights_medium015.ymap`
- `distlodlights_medium015.ymap`
- `hei_distlodlights_medium015.ymap`
- `hei_lodlights_medium015.ymap`
- `lodlights_medium015.ymap`
- `m25_2_distlodlights_medium015.ymap`
- `m25_2_lodlights_medium015.ymap`
- `vw_distlodlights_medium015.ymap`
- `vw_lodlights_medium015.ymap`

## Models (ydr)

The Burton block and its neighbours: cut, cleaned and re-textured so the hospital can replace the Customs.

- `bt1_02_block_01_ovl.ydr`
- `bt1_02_building02.ydr`
- `bt1_02_emissive_c.ydr`
- `bt1_02_emissive_wind_hd_proxy.ydr`
- `bt1_02_ground.ydr`
- `bt1_02_ground_emm.ydr`
- `bt1_02_loadingbay_ovl.ydr`
- `bt1_02_loadingbay_ovl02.ydr`
- `bt1_02_mall_ov.ydr`
- `bt1_02_mallblock.ydr`
- `bt1_02_shadowproxy01.ydr`
- `bt1_02_signem_slod1.ydr`
- `bt1_02_stairs01.ydr`
- `bt1_02_steps01.ydr`
- `ss1_rd1_00.ydr`
- `ss1_rd1_15.ydr`
- `ss1_rd1_26.ydr`

## Distant lod models (ydd)

The distant versions of the same buildings.

- `bt1_02_emissive_slod_children.ydd`
- `bt1_02_slod1_children.ydd`
- `ss1_lod_bt_01_02_03_children.ydd`
- `ss1_lod_emissive_bt_01_02_03_children.ydd`

## Collision (ybn)

With the hi@ and ma@ twins.

- `bt1_02_0.ybn`
- `hi@bt1_02_0.ybn`
- `ma@bt1_02_0.ybn`
- `ma@ss1_rd1_1.ybn`
- `ss1_rd1_1.ybn`

## If you own two of our maps

Maps by No BS Scripts that touch different tiles share no files. If two of them ever override the same GTA file,
use the Vertex Hub merger, or ask us for a merged copy.
