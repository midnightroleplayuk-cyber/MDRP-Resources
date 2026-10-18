# Edited GTA files (stream/vanilla) and Vertex Hub

To make room for the station, the resource ships edited copies of 78 GTA map files. They all sit
in `stream/vanilla/` and none of them is encrypted.

FiveM loads only one file per file name. If another map on your server ships a file with the same name as one
below (typical for maps near Mission Plaza and Hawick Avenue, and for lodlights / distlodlights maps), only one
copy loads and the other map's change is lost: missing or doubled buildings, floating props, holes in the road
or missing collisions.

## How to fix a clash

1. Search your other map resources for the file names below.
2. Merge each duplicate pair with the Vertex Hub merger (https://app.vertex-hub.com/merger): load our copy from
   `stream/vanilla/` and the other resource's copy, and download the merged file.
3. Put the merged file in ONE of the two resources and delete the other copy, so the name exists only once.
4. Restart the server and check both maps.

Keep a copy of the original files before you merge. Updates of the station replace `stream/vanilla/`. When the
changelog says the edited GTA files did not change, your merged files still apply: put them back. Otherwise merge
again after updating.

## The files

| File | Type | Area |
|---|---|---|
| `apa_distlodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `apa_distlodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `apa_distlodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `apa_lodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `apa_lodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `apa_lodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `distlodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `distlodlights_small030.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `distlodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_distlodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_distlodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_distlodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_lodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_lodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_lodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `lodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `lodlights_small030.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `lodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_distlodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_distlodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_distlodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_lodlights_medium022.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_lodlights_small031.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `vw_lodlights_small032.ymap` | map placements | distant lights (lodlights / distlodlights) |
| `hei_hw1_occl_01.ymap` | map placements | occlusion |
| `hw1_occl_01.ymap` | map placements | occlusion |
| `hei_hw1_lod.ymap` | map placements | distant (LOD) models and maps of the area |
| `hw1_lod.ymap` | map placements | distant (LOD) models and maps of the area |
| `hw1_lod_24_25_28_29_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_lod_b_slod2_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_lod_c_slod2_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_lod_slod3_emi_proxy_01.ydr` | model | distant (LOD) models and maps of the area |
| `hw1_lod_slod3_emi_proxy_01_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_lod_slod4.ydr` | model | distant (LOD) models and maps of the area |
| `hw1_lod_slod4_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_props_combo0706_slod_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_rd_b6_slod1_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hw1_rd_c3_slod1_children.ydd` | model dictionary | distant (LOD) models and maps of the area |
| `hei_hw1_25.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `hei_hw1_25_long_0.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `hei_hw1_25_strm_0.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `hi@hw1_25_0.ybn` | collision | Mission Plaza map tile (hw1_25) |
| `hw1_25.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `hw1_25_0.ybn` | collision | Mission Plaza map tile (hw1_25) |
| `hw1_25_long_0.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `hw1_25_strm_0.ymap` | map placements | Mission Plaza map tile (hw1_25) |
| `ma@hw1_25_0.ybn` | collision | Mission Plaza map tile (hw1_25) |
| `hw1_props_cblnw_133.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_134.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_135.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_136.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_137.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_138.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_139.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_140.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_141.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_142.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_143.ydr` | model | overhead cables over the site |
| `hw1_props_cblnw_144.ydr` | model | overhead cables over the site |
| `hei_hw1_rd.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hei_hw1_rd_1.ybn` | collision | road tiles around the station (hw1_rd) |
| `hei_hw1_rd_critical_0.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hei_hw1_rd_long_0.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hei_hw1_rd_strm_2.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hi@hei_hw1_rd_2.ybn` | collision | road tiles around the station (hw1_rd) |
| `hi@hei_hw1_rd_5.ybn` | collision | road tiles around the station (hw1_rd) |
| `hi@hw1_rd_2.ybn` | collision | road tiles around the station (hw1_rd) |
| `hi@hw1_rd_5.ybn` | collision | road tiles around the station (hw1_rd) |
| `hw1_rd.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hw1_rd_02_001.ydr` | model | road tiles around the station (hw1_rd) |
| `hw1_rd_02_03.ydr` | model | road tiles around the station (hw1_rd) |
| `hw1_rd_02_04.ydr` | model | road tiles around the station (hw1_rd) |
| `hw1_rd_1.ybn` | collision | road tiles around the station (hw1_rd) |
| `hw1_rd_critical_0.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hw1_rd_long_0.ymap` | map placements | road tiles around the station (hw1_rd) |
| `hw1_rd_strm_2.ymap` | map placements | road tiles around the station (hw1_rd) |
| `ma@hei_hw1_rd_1.ybn` | collision | road tiles around the station (hw1_rd) |
| `ma@hw1_rd_1.ybn` | collision | road tiles around the station (hw1_rd) |
