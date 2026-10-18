# Mission Plaza UK Police Station 1.2.0 - install guide (NO BS SCRIPTS)

One resource: `nobs_ukpd_missionplaza`. Tested game build 3258 (newer builds are fine). Version 1.2.0,
2026-10-08. Paths in this guide are inside the `nobs_ukpd_missionplaza` folder.

## Install

1. Stop the server and back up your server.cfg. If an older version of the station is installed, follow "Updating"
   below instead.
2. Download `nobs_ukpd_missionplaza` from your Cfx account (portal.cfx.re, granted assets) and copy the whole folder
   into your server `resources` folder. Keep the hidden `.fxap` file next to `fxmanifest.lua`; without it the
   escrowed files cannot be read. Upload in binary mode (some FTP programs skip or damage dot-files).
3. Add the lines from `install/docs/server.cfg.example` to your server.cfg. Keep exactly one `sv_enforceGameBuild`
   line (3258 or newer). The station needs one ensure line:

   ```
   ensure nobs_ukpd_missionplaza
   ```

4. Remove any other map that replaces the Hawick / Mission Plaza site. Do not let two doorlock scripts control the
   same door.
5. Restart the server and reconnect, then check the server console and F8. A good start shows no yellow or red lines
   from `nobs_ukpd_missionplaza`. A yellow warning that names `config.lua` means the file has a mistake (see
   "Settings"). A note that one of the station's texture dictionaries is large (about 30 MiB) is expected.

No ox or qb framework is required. Location: approximately vec4(384.33, -352.48, 45.82, 319.48).

If the console reports that you lack the entitlement for the resource, the server's license key belongs to a
different Cfx account from the one that bought the station: use a license key generated with the purchasing
account. A "failed to verify" error usually means a damaged upload: copy the folder again in binary mode.

## Updating

Every update replaces the whole folder, `config.lua` included.

1. Back up your settings outside the resources folder before you delete anything. Updating from 1.1.x: back up all
   four 1.1.x settings files, not only `config.lua` (see "From 1.1.x (the old file layout)" below for their names
   and where each setting goes now). From 1.2.0 on, every setting is in `config.lua`. Keep any edited branding
   `.ytd` and Vertex Hub merged files too.
2. Stop the server and DELETE the old `nobs_ukpd_missionplaza` folder (or the folder you renamed it to) completely,
   including its hidden `.fxap` file. Do
   not copy the new folder over the old one: old files would stay behind, and old stream files would keep loading
   and clash with the new ones.
3. Copy the new folder as in "Install", step 2 (your server.cfg lines stay as they are).
4. Set your settings again in the new `config.lua` (from 1.1.x: with the table below and your four backed-up files).
   Do not paste a whole old file over it: a new version can add or move settings.
5. Put back your edited branding `.ytd`. Vertex Hub merged files: put them back when the changelog says the edited
   GTA files in `stream/vanilla/` did not change (true for 1.2.0), otherwise merge again. If you keep a merged file
   in another resource, delete the station's new copy of that file again.
6. Doorlock entries you imported and qb-doorlock config files you copied stay as they are: door names do not change.
7. Start the server and check the console (see "Install", step 5).

### From 1.1.x (the old file layout)

Version 1.2.0 moved every setting into one `config.lua` and the other files into `scripts/` and `install/`. The old
settings files are no longer read, even if they are still in the folder. 1.1.x has four settings files: `config.lua`,
`managed_doors_config.lua`, `armoury_display_config.lua` and `site_config.lua`. Copy all four out of the old folder
before you delete it (step 2 above). Where your 1.1.x settings go:

| 1.1.x file | 1.1.x setting | In 1.2.0 |
|---|---|---|
| `config.lua` | `MPGateConfig`: `enabled`, `controller`, `restrictedOpenForAll`, `locks` | `config.lua` section 1, same names |
| `config.lua` | `range` / `speed` in the `MPGateConfig.gates` list | section 1, `MPGateConfig.timing.entrance` / `.exit` |
| `config.lua` | `MPGateConfig.canOpen` (your job check) | section 1, below `MPGateConfig` |
| `managed_doors_config.lua` | `MPManagedDoorLocks` | section 2, same names |
| `managed_doors_config.lua` | `along` / `across` / `openAlong` / `openAcross` in the door list | section 2, `MPManagedDoors.entrance` / `.garage` |
| `armoury_display_config.lua` | `ArmouryDisplay` settings | section 3, same names |
| `armoury_display_config.lua` | `ArmouryDisplay.sets` / `.mlo` (the weapon layouts) | not a setting: `scripts/data/armoury_data.lua` (see below) |
| `site_config.lua` | `MPDisabledEmitters` | section 4 |
| `site_config.lua` | `MPStaticProps` (the frozen props) / `MPBuilding` | not a setting: `scripts/data/site_data.lua` (see below) |

- qb-doorlock owners: set `controller = 'qb-doorlock'` again, or the station and qb-doorlock both move the gate leaves.
- If you had removed or emptied `MPDisabledEmitters` to hear the radio, write `MPDisabledEmitters = {}`: without the
  line the station now switches the restaurant radio off again.
- A `canOpen` job check needs no extra script line in `fxmanifest.lua` any more: define it in `config.lua`.
- `MPStaticProps`, `MPBuilding`, `ArmouryDisplay.sets` / `.mlo` and the gate and door lists are generated data now,
  in `scripts/data/`. Every update replaces them, and the station ignores them in `config.lua` (a yellow console
  notice says so). Editing them is not supported. If you must (for example to unfreeze a chair for your sit script),
  edit the file in `scripts/data/` and make the same edit again after every update.
- If you paste an old 1.1.x `config.lua` anyway, the station still runs: the old gate and door lists in it are
  ignored (a yellow console notice names the new settings) and anything missing uses its default.
- The guides moved from `docs/` to `install/docs/`, the doorlock data from `doorlocks/` to `install/doorlocks/` and the
  logo templates from `branding_kit/` to `install/branding_kit/`. `docs/VERSION.txt` is gone: the version is in
  `fxmanifest.lua`, `README.md` and `install/docs/CHANGELOG.md`.

## Settings

`config.lua` (in the resource folder) holds every setting, in four sections. It is loaded on the server and on every
client. After an edit, restart the resource and check the server console and F8. A yellow warning that names
`config.lua` means the file has a mistake (a missing comma, quote or bracket: the station then runs on its default
settings until you fix it) or still holds an old 1.1.x list, which is ignored (see "From 1.1.x (the old file layout)").
The generated data in `scripts/data/` is replaced by every update: do not edit it.

- **1. Vehicle gates** (`MPGateConfig`). Default `restrictedOpenForAll = true`: the police gate and barrier open for
  any nearby player. Set it to `false` and they open only for a player in an emergency-class vehicle. For a job
  check, define `MPGateConfig.canOpen` as described in `config.lua`. `MPGateConfig.timing` sets the opening distance
  and speed of the public entrance and the police exit gate.
- **Vehicle gates with ox_doorlock**. The station swings the gates itself and follows ox_doorlock's lock: locked =
  the gate closes (never onto a car or a person in its swing) and stays shut; unlocked = it opens automatically for
  nearby players. Keep `controller = 'builtin'` (`'ox_doorlock'` does the same) and import
  `install/doorlocks/ox_doorlock/nobs_ukpd_gates.sql` (police yard exit starts locked and relocks 15 s after it is
  unlocked; public entrance starts unlocked; set your job name in `groups`), or make a door at a gate with ox's own
  editor. Other doorlocks: from a server script `TriggerEvent('nobs_ukpd:setGateLocked', 'exit', true)`. qb-doorlock
  can instead own the gates: `controller = 'qb-doorlock',` and copy
  `install/doorlocks/qb-doorlock/nobs_ukpd_gates.lua` into qb-doorlock/configs.
- **2. Automatic doors** (`MPManagedDoorLocks`, `MPManagedDoors`: front entrance sliders, garage rollers). They are
  moved by the station, so a doorlock cannot move them, but with ox_doorlock running they follow its lock state:
  locked = they close (also when open, never onto someone in the doorway) and stay shut; unlocked = automatic. Make
  the ox doors with ox's own editor by aiming at them, or import
  `install/doorlocks/ox_doorlock/nobs_ukpd_autodoors.sql` (set your police group). Other doorlocks: from a server
  script `TriggerEvent('nobs_ukpd:setAutoDoorLocked', 'garage_bay1', true)`. Opening distances:
  `MPManagedDoors.entrance` and `MPManagedDoors.garage`.
- **3. Armoury weapon display** (`ArmouryDisplay`; `setr nobs_ukpd_armoury_display 1` in server.cfg, on by default). The
  weapons on the armoury racks are local client objects placed by the station, because GTA weapons cannot be map
  entities. They are on when the convar is missing. `setr nobs_ukpd_armoury_display 0` turns them off for everyone; the
  racks, lockers and cases stay. A player can switch them off on their own screen with `/ukpd_armoury off`.
- **4. Ambient radio** (`MPDisabledEmitters`). GTA plays background radio from fixed "static emitters"; the
  restaurant that stood on this site left one (East Los FM) inside the station. The station switches it off while
  it runs and back on when it stops. Add another emitter name to the list to silence it too.
- **Doorlocks** (optional). `install/doorlocks/` holds ready data for ox_doorlock, qb-doorlock and a neutral
  JSON / CSV / Lua list. The station does not load it; follow `install/doorlocks/README.md`. A station door that your
  doorlock locks while it stands open (or while it is still swinging shut) swings shut by itself, smoothly and in
  either direction, waiting only while someone is right in its path (any door entry works, also ones made with ox's
  editor).
- **Your own badge and logo**: `install/docs/BRANDING.md`.
- **Map clashes with other resources** (Vertex Hub): `install/docs/VANILLA_FILES.md`.

## What is open and what is protected

Cfx asset escrow encrypts
the 356 station models in `stream/mlo/` and `stream/exterior/` and the 8 scripts in `scripts/client/` and
`scripts/server/`.
Everything else ships readable:

- `config.lua` (every setting) and `README.md`
- `scripts/data/`: the generated data (gate and door positions, the frozen-prop list, the armoury layouts) and the
  texture dictionary parents `scripts/data/gtxd.meta` and `scripts/data/roof_gtxd.meta`
- `install/`: these guides (`install/docs/`), the doorlock data with its optional helper resource (`install/doorlocks/`)
  and the logo templates (`install/branding_kit/`)
- `stream/branding/nobs_ukpd_branding.ytd` (your logo textures) and every `.ytd`, `.ymap`, `.ybn`, `.ytyp` and `.ymf` in
  `stream/`
- `stream/vanilla/`: the 78 edited GTA files, models included (see `install/docs/VANILLA_FILES.md`)

The fxmanifest lists these in `escrow_ignore`.

## Doors not in the doorlock data

The doorlock data in `install/doorlocks/` covers the custody doors and the access-controlled doors (armouries, evidence
store, control room, CID, intelligence unit, roof and others). Other doors, such as the meeting-room door and the door
from the first-floor corridor into the Roads Policing Unit (RPU) room, are free-swing doors that are not in it. To lock
one, add it with your doorlock resource's own editor by aiming at the leaf; the RPU door leaf, if you enter it by hand:

- model `nobs_ukpd_d36_fire110_p_hinge` (hash 3229811073 / -1065156223)
- coords `vec3(380.965958, -315.216546, 50.142982)`, heading `158.3818`

Do not let two doorlock scripts control the same door.

## Sit scripts

11 chair models (189 chairs) that common sit scripts know are placed. `install/docs/CHAIRS.md` lists them with their
hashes for your sit script's whitelist. We do not know your sit script, so check in game that it seats players correctly
on them.

## Props frozen in place

The station freezes each map object listed in `scripts/data/site_data.lua` (`MPStaticProps`, 1435 entries, 408 models).
It matches by model and position (within 0.5 m), and only freezes local map objects, never networked or mission
entities. 693 of the entries are dynamic GTA props (167 models, listed in the appendix): chairs, monitors, gym kit and
clutter that would otherwise move when bumped.

## Appendix: dynamic props frozen in place

| Model | Frozen entries | Fragment |
|---|---|---|
| `apa_p_apdlc_treadmill_s` | 3 |  |
| `bkr_prop_coke_scale_01` | 1 |  |
| `bkr_prop_duffel_bag_01a` | 4 |  |
| `bkr_prop_fakeid_desklamp_01a` | 1 |  |
| `bkr_prop_gunlocker_01a` | 1 |  |
| `ex_prop_offchair_exec_01` | 10 |  |
| `gr_prop_gr_target_04b` | 1 |  |
| `h4_prop_battle_analoguemixer_01a` | 1 |  |
| `hei_heist_stn_benchshort` | 1 |  |
| `hei_prop_bank_cctv_02` | 6 | yes |
| `hei_prop_heist_off_chair` | 4 |  |
| `imp_prop_impexp_tape_01` | 1 |  |
| `imp_prop_impexp_tyre_01c` | 3 |  |
| `m23_1_prop_m31_plasticcrate_01a` | 3 |  |
| `m23_2_prop_m32_bucket_mop_01a` | 2 |  |
| `m23_2_prop_m32_folder_01a` | 2 |  |
| `m23_2_prop_m32_folder_01b` | 1 |  |
| `m23_2_prop_m32_plasticbarrier_01a` | 2 |  |
| `m23_2_prop_m32_safe_01a` | 1 |  |
| `m23_2_prop_m32_vestcrate_02a` | 1 | yes |
| `m24_1_prop_m41_exerciseball_01a` | 1 |  |
| `m24_1_prop_m41_server_01a` | 2 |  |
| `p_amb_coffeecup_01` | 7 |  |
| `p_cs_beverly_lanyard_s` | 1 |  |
| `p_cs_cuffs_02_s` | 1 |  |
| `p_laptop_02_s` | 3 |  |
| `p_notepad_01_s` | 3 |  |
| `p_v_43_safe_s` | 1 |  |
| `prop_ballistic_shield` | 3 |  |
| `prop_barbell_01` | 2 |  |
| `prop_barrel_01a` | 1 |  |
| `prop_bin_10a` | 10 |  |
| `prop_bin_13a` | 1 |  |
| `prop_bollard_02a` | 6 | yes |
| `prop_box_ammo02a` | 1 |  |
| `prop_box_ammo07a` | 4 |  |
| `prop_box_ammo07b` | 3 |  |
| `prop_box_guncase_01a` | 1 |  |
| `prop_box_guncase_03a` | 1 |  |
| `prop_boxing_glove_01` | 3 |  |
| `prop_car_battery_01` | 1 |  |
| `prop_cash_dep_bag_01` | 4 |  |
| `prop_cd_folder_pile1` | 2 | yes |
| `prop_cd_folder_pile4` | 9 | yes |
| `prop_chair_04b` | 27 |  |
| `prop_coffee_mac_02` | 1 | yes |
| `prop_cs_binder_01` | 2 |  |
| `prop_cs_cardbox_01` | 8 |  |
| `prop_cs_cuffs_01` | 1 |  |
| `prop_cs_documents_01` | 16 |  |
| `prop_cs_duffel_01` | 11 |  |
| `prop_cs_hand_radio` | 9 |  |
| `prop_cs_heist_bag_02` | 1 |  |
| `prop_cs_keyboard_01` | 1 |  |
| `prop_cs_mopbucket_01` | 1 |  |
| `prop_cs_paper_cup` | 1 |  |
| `prop_cs_police_torch` | 3 |  |
| `prop_cs_walkie_talkie` | 3 |  |
| `prop_curl_bar_01` | 1 |  |
| `prop_ear_defenders_01` | 1 |  |
| `prop_exer_bike_01` | 1 |  |
| `prop_exercisebike` | 1 |  |
| `prop_fbi3_coffee_table` | 1 |  |
| `prop_fire_exting_1a` | 1 | yes |
| `prop_fire_exting_2a` | 6 | yes |
| `prop_fire_exting_3a` | 16 | yes |
| `prop_freeweight_01` | 2 |  |
| `prop_freeweight_02` | 2 |  |
| `prop_fridge_03` | 3 |  |
| `prop_gun_case_01` | 1 |  |
| `prop_gun_case_02` | 2 |  |
| `prop_headset_01` | 10 |  |
| `prop_hose_1` | 1 |  |
| `prop_jerrycan_01a` | 1 | yes |
| `prop_kettle_01` | 5 |  |
| `prop_keyboard_01b` | 32 |  |
| `prop_laptop_01a` | 3 | yes |
| `prop_laptop_02_closed` | 2 |  |
| `prop_ld_ammo_pack_01` | 2 |  |
| `prop_ld_flow_bottle` | 1 |  |
| `prop_ld_health_pack` | 2 |  |
| `prop_megaphone_01` | 1 |  |
| `prop_monitor_02` | 8 |  |
| `prop_night_safe_01` | 1 |  |
| `prop_notepad_02` | 1 |  |
| `prop_off_chair_01` | 19 |  |
| `prop_off_chair_04` | 8 |  |
| `prop_off_chair_04_s` | 31 |  |
| `prop_off_chair_05` | 33 |  |
| `prop_pap_camera_01` | 1 |  |
| `prop_paper_bag_01` | 2 |  |
| `prop_paper_box_02` | 3 |  |
| `prop_plant_int_03a` | 1 | yes |
| `prop_player_gasmask` | 1 |  |
| `prop_podium_mic` | 1 |  |
| `prop_police_radio_main` | 11 |  |
| `prop_poly_bag_01` | 1 |  |
| `prop_printer_02` | 1 |  |
| `prop_punch_bag_l` | 2 |  |
| `prop_rag_01` | 1 |  |
| `prop_recyclebin_02_c` | 1 |  |
| `prop_recyclebin_02_d` | 8 |  |
| `prop_riot_shield` | 3 |  |
| `prop_roadcone01a` | 3 |  |
| `prop_rub_cage01a` | 2 |  |
| `prop_safety_glasses` | 1 |  |
| `prop_skip_rope_01` | 1 |  |
| `prop_studio_light_02` | 1 |  |
| `prop_table_mic_01` | 7 |  |
| `prop_tea_trolly` | 1 |  |
| `prop_tool_box_02` | 2 |  |
| `prop_tool_box_04` | 2 |  |
| `prop_tool_sledgeham` | 1 |  |
| `prop_toolchest_03` | 1 |  |
| `prop_v_cam_01` | 2 |  |
| `prop_vend_soda_01` | 1 | yes |
| `prop_vend_soda_02` | 1 | yes |
| `prop_waiting_seat_01` | 3 |  |
| `prop_wall_light_02a` | 21 | yes |
| `prop_wall_light_13a` | 4 | yes |
| `prop_watercooler` | 7 | yes |
| `prop_weight_10k` | 1 |  |
| `prop_weight_15k` | 1 |  |
| `prop_weight_20k` | 1 |  |
| `prop_weight_5k` | 1 |  |
| `prop_weight_bench_02` | 1 | yes |
| `prop_weight_squat` | 1 | yes |
| `prop_yoga_mat_01` | 2 |  |
| `sf_prop_sf_cam_case_01a` | 1 | yes |
| `sf_prop_sf_helmet_01a` | 3 |  |
| `sf_prop_sf_speaker_wall_01a` | 1 | yes |
| `sf_prop_sf_table_office_01a` | 19 |  |
| `tr_prop_tr_chair_01a` | 30 |  |
| `tr_prop_tr_clipboard_sh_01a` | 1 |  |
| `v_corp_bk_chair3` | 3 |  |
| `v_corp_offchair` | 15 |  |
| `v_ilev_liconftable_sml` | 1 |  |
| `v_ind_cfwaste` | 1 |  |
| `v_ind_cs_toolboard` | 1 | yes |
| `v_med_beaker` | 2 | yes |
| `v_med_bed1` | 1 |  |
| `v_med_cor_medstool` | 2 |  |
| `v_med_flask` | 1 | yes |
| `v_res_binder` | 2 | yes |
| `v_res_desktidy` | 1 | yes |
| `v_res_filebox01` | 11 |  |
| `v_res_mountedprojector` | 2 | yes |
| `v_res_paperfolders` | 1 |  |
| `v_res_tre_sofa` | 1 |  |
| `v_ret_gc_bin` | 2 |  |
| `v_ret_gc_folder1` | 2 |  |
| `v_ret_gc_folder2` | 1 |  |
| `v_ret_gc_trays` | 3 | yes |
| `v_ret_ta_firstaid` | 15 |  |
| `v_serv_ct_chair02` | 36 |  |
| `v_serv_firealarm` | 1 | yes |
| `v_serv_plas_boxgt2` | 2 |  |
| `v_serv_tc_bin1_` | 1 |  |
| `v_serv_wetfloorsn` | 1 |  |
| `vw_prop_vw_key_cabinet_01a` | 2 |  |
| `xm3_prop_xm3_rack_vial_01a` | 1 |  |
| `xm_prop_x17_bag_01a` | 8 |  |
| `xm_prop_x17_bag_med_01a` | 1 |  |
| `xm_prop_x17_coffee_jug` | 3 |  |
| `xm_prop_x17_filecab_01a` | 1 |  |
| `xm_prop_x17_lectern_01` | 2 |  |
| `xs_prop_arena_clipboard_01a` | 1 |  |
