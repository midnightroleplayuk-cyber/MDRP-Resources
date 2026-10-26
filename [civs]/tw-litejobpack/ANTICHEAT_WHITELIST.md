# Anticheat Whitelist — tw-litejobpack

All peds, vehicles, objects/props, and weapons spawned by this resource (24 jobs + shared components + dev tools). Whitelist these in your anticheat to avoid false-positive bans on entity/vehicle/weapon spawns.

> Standard GTA assets (`a_*`, `s_*`, `prop_*`) are usually already in your anticheat's default whitelist. The critical ones are the **custom stream props** (`tw_*`, `yusuf_*`) and the **NPC customer vehicles** (cardetailer / tiretechnician), since those spawn dynamically and commonly trigger "illegal spawn" bans.

---

## 🧍 PEDS (NPCs + Animals)

### Human NPCs
```
a_f_m_eastsa_02          a_f_m_bevhills_01        a_f_m_bevhills_02
a_f_m_beach_01           a_f_y_bevhills_01        a_f_y_bevhills_02
a_f_y_bevhills_03        a_f_y_bevhills_04        a_f_y_business_01
a_f_y_hipster_01         a_f_y_tourist_01         a_m_m_farmer_01
a_m_m_hillbilly_01       a_m_m_business_01        a_m_m_bevhills_01
a_m_m_bevhills_02        a_m_y_beach_03           a_m_y_bevhills_01
a_m_y_bevhills_02        a_m_y_business_01        a_m_y_hipster_01
a_m_y_vinewood_01        cs_hunter                cs_manuel
mp_m_forgery_01          s_m_m_cntrybar_01        s_m_m_gaffer_01
s_m_m_gardener_01        s_m_m_gentransport       s_m_m_linecook
s_m_m_mariachi_01        s_m_m_postal_02          s_m_m_trucker_01
s_m_m_warehouse_01       s_m_y_ammucity_01        s_m_y_baywatch_01
s_m_y_construct_01       s_m_y_construct_02       s_m_y_garbage
mp_f_freemode_01         mp_m_freemode_01
```
> `mp_*_freemode_01` → used by the clothing/cabin system. Most anticheats whitelist these by default.

### Animals (hunting / fishing / dogwalking / diving / treasurehunter)
```
a_c_boar        a_c_chickenhawk   a_c_coyote      a_c_crow
a_c_deer        a_c_fish          a_c_husky       a_c_mtlion
a_c_pig         a_c_poodle        a_c_pug         a_c_rabbit_01
a_c_retriever   a_c_rottweiler    a_c_sharkhammer a_c_sharktiger
a_c_shepherd
```

---

## 🚗 VEHICLES

### Fixed job vehicles
| Model          | Job(s)                       |
| -------------- | ---------------------------- |
| `bison`        | cleaner, landscaping         |
| `boxville2`    | delivery                     |
| `burrito`      | windowscleaner               |
| `cruiser`      | dogwalking (bicycle)         |
| `dinghy`       | diving, treasurehunter       |
| `dinghy2`      | fishing                      |
| `docktrailer`  | trucker (trailer)            |
| `forklift`     | forklift                     |
| `kamacho`      | hunting                      |
| `mule2`        | warehouse                    |
| `packer`       | trucker (tractor unit)       |
| `paradise`     | powerwash                    |
| `scorcher`     | newspaper (bicycle)          |
| `speedo`       | cardetailer                  |
| `taxi`         | taxi                         |
| `utillitruck4` | powerlines                   |

### Cardetailer — customer vehicles (random spawn)
```
exemplar  oracle  tailgater  schafter2  fugitive  felon
jackal    windsor  cognoscenti  superd  xls  baller3
```

### Tiretechnician — customer vehicles (random spawn)
```
picador  exemplar  gresley  weevil  rebel  sabregt2  sultan
vigero   retinue2  oracle2  vamos   virgo  hermes    bifta
emperor  fugitive  prairie  surge   stanier  stratum  ingot
asterope premier   intruder
```
> ⚠️ These two jobs spawn NPC vehicles, so they must be in the **vehicle spawn whitelist** or the anticheat will flag "illegal vehicle spawn".

---

## 📦 OBJECTS / PROPS

### Standard GTA props
```
ng_proc_food_ornge1a   sf_prop_sf_apple_01a   p_d_scuba_mask_s
p_michael_scuba_tank_s p_s_scuba_tank_s       xm_prop_x17_scuba_tank
prop_big_shit_01       prop_box_wood01a       prop_box_wood04a
prop_boxpile_06a       prop_bush_neat_08      prop_weeds_nxg08
prop_weeddry_nxg04     prop_car_engine_01     prop_carjack
prop_carjack_clsd      prop_coral_pillar_01   prop_crate_03a
prop_cs_cardbox_01     prop_cs_heist_bag_02   prop_cs_mop_s
prop_cs_newspaper      prop_cs_rub_binbag_01  prop_cs_trowel
prop_fishing_rod_01    prop_golf_ball         prop_hedge_trimmer_01
prop_ld_fireaxe        prop_ld_gold_chest     prop_metal_plates01
prop_mp_cone_01        prop_park_ticket_01    prop_sponge_01
prop_wheel_tyre        trash                  veo_pipes_r
```

### Rocks / ores (miner)
```
prop_rock_4_a   prop_rock_4_e         prop_rock_5_d_coal
prop_rock_5_d_diamond  prop_rock_5_d_emerald  prop_rock_5_d_gold
prop_rock_5_d_iron
```

### Car wreckage (scrapyard)
```
prop_rub_binbag_04  prop_rub_carpart_02  prop_rub_carpart_03
prop_rub_carwreck_3 prop_rub_carwreck_5  prop_rub_carwreck_10
prop_rub_tyre_01
```

### Tools (tool props)
```
prop_tool_consaw          prop_tool_drill            prop_tool_fireaxe_pro
prop_tool_fireaxe_rusted  prop_tool_pickaxe          prop_tool_pickaxe_pro
prop_tool_pickaxe_rusted  prop_tool_screwdvr01       prop_tool_shovel
prop_tool_shovel2         prop_hedge_trimmer_01
```

### Trees (lumberjack) / crops (farmer)
```
prop_tree_birch_04   prop_tree_oak_01   prop_tree_pine_02
prop_veg_crop_03_cab prop_veg_crop_03_pumpkin
prop_veg_crop_03_kavun prop_veg_crop_03_karpuz
```

### Bins + containers (cleanup)
```
prop_bin_01a  prop_bin_02a  prop_bin_03a  prop_bin_04a  prop_bin_05a
prop_bin_06a  prop_bin_07a  prop_bin_07b  prop_bin_08a  prop_bin_08open
prop_bin_09a  prop_bin_10a  prop_bin_10b  prop_bin_11a  prop_bin_12a
prop_bin_13a  prop_bin_14a  prop_bin_14b
prop_dumpster_01a  prop_dumpster_02a  prop_dumpster_02b
prop_dumpster_3a   prop_dumpster_4a
```

### 🔧 CUSTOM / STREAM PROPS (from the `tw-litejobpack-stream` pack)
```
tw_baskul                tw_cuttree
tw_changing_cabin        tw_changing_cabin_clothes   tw_changing_cabin_door
yusuf_prop_m52_crate_m_jewellery_01 / 02 / 03
yusuf_prop_m52_crate_m_antiques_01 / 02 / 03
yusuf_prop_m52_crate_m_tobacco_01 / 02 / 03
yusuf_prop_m52_crate_m_hazard_01 / 02 / 03
yusuf_prop_m52_crate_m_fake_01 / 02 / 03
```
> ⚠️ These are custom props, but the anticheat checks the spawned **hash**, so they still need to be whitelisted.

---

## 🔫 WEAPONS (if your anticheat does weapon whitelisting)
```
weapon_musket  weapon_heavysniper  weapon_sniperrifle   (hunting)
WEAPON_PRESSURE1 + prop w_ar_pressure1                  (powerwash)
WEAPON_ACIDPACKAGE                                       (powerwash / cleaning)
w_me_crowbar                                             (tool prop)
```

---

## Notes
- Standard GTA assets (`a_*`, `s_*`, `prop_*`) are typically already in your anticheat's default whitelist — the ones that matter most are the **custom props** (`tw_*`, `yusuf_*`) and the **customer vehicles** (cardetailer / tiretechnician), which spawn dynamically and can trigger bans.
- This list was extracted from both the `shared/jobs/*.lua` declarative definitions and the hardcoded models in components (`npc_carrier`, `miner`, `scrapyard`, `lumberjack`, and the `polish_placer` dev tool).
