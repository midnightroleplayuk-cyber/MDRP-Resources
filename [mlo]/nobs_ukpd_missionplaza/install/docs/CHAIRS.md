# Mission Plaza UK Police Station 1.2.0: chairs you can sit on

Use this list for your sit script's model whitelist. We do not know which sit resource your server runs, so the
chairs were picked from models that common FiveM sit scripts already list. Add any model your script is missing,
and check in game that your sit script seats players correctly on them.

## Sit-script chair models in the station (11 models, 189 chairs)

| Model | Hash | Signed hash | Inside | Outside | Seat height | Sitter faces | Source |
|---|---|---|---|---|---|---|---|
| `ex_prop_offchair_exec_01` | 2668900977 | -1626066319 | 10 | 0 | 0.46 m | -Y | measured |
| `hei_prop_heist_off_chair` | 3096623373 | -1198343923 | 4 | 0 | 0.46 m | -Y | measured |
| `prop_chair_04b` | 2353589337 | -1941377959 | 27 | 0 | 0.44 m | -Y | measured |
| `prop_off_chair_01` | 536071214 | 536071214 | 19 | 0 | 0.46 m | -Y | measured |
| `prop_off_chair_04` | 1268458364 | 1268458364 | 8 | 0 | 0.44 m | -Y | measured |
| `prop_off_chair_04_s` | 475561894 | 475561894 | 31 | 0 | 0.48 m | -Y | measured |
| `prop_off_chair_05` | 1037469683 | 1037469683 | 33 | 0 | 0.42 m | -Y | measured |
| `prop_waiting_seat_01` | 1355718178 | 1355718178 | 3 | 0 | 0.40 m | -Y | measured |
| `v_corp_bk_chair3` | 589738836 | 589738836 | 3 | 0 | 0.36 m | -Y | measured |
| `v_corp_offchair` | 4185610837 | -109356459 | 15 | 0 | 0.44 m | -Y | measured |
| `v_serv_ct_chair02` | 4123023395 | -171943901 | 36 | 0 | 0.42 m | -Y | measured |

Seat height is measured from the mesh where we had one (`measured`), otherwise it is the common default of 0.47 m.
"Sitter faces" is the side of the model the seated ped looks towards: `-Y` is the model's front.

Copy-paste list:

```lua
'ex_prop_offchair_exec_01',
'hei_prop_heist_off_chair',
'prop_chair_04b',
'prop_off_chair_01',
'prop_off_chair_04',
'prop_off_chair_04_s',
'prop_off_chair_05',
'prop_waiting_seat_01',
'v_corp_bk_chair3',
'v_corp_offchair',
'v_serv_ct_chair02'
```

## Seats designed to be sat on that are not on the common list

| Model | Hash | Signed hash | Placed | Rooms |
|---|---|---|---|---|
| `hei_heist_stn_benchshort` | 2427095687 | -1867871609 | 1 | Training Room |
| `nobs_ukpd_slatbench_atlas` | 1007470258 | 1007470258 | 15 | SCO-19 Armoury |
| `v_res_fh_benchlong` | 1427480666 | 1427480666 | 1 | Gym |

## Other seat-like models in the station

These were placed as furniture. They were not designed or checked for sitting:

| Model | Placed |
|---|---|
| `nobs_ukpd_d25_public_seating` | 14 |
| `nobs_ukpd_d37_mbench_01` | 1 |
| `nobs_ukpd_d37_mbench_05` | 1 |
| `nobs_ukpd_d37_mbench_06` | 1 |
| `nobs_ukpd_slatbench` | 4 |
| `tr_prop_tr_chair_01a` | 30 |
| `v_corp_sidechair` | 6 |
| `v_med_bench1` | 3 |
| `v_med_bench2` | 1 |
| `v_med_cor_medstool` | 2 |
| `v_med_p_sofa` | 1 |
| `v_res_tre_sofa` | 1 |

## Notes

- Every listed chair is a local map object. The station freezes the listed dynamic chairs in place
  (`install/docs/INSTALL.md`, "Props frozen in place"), so players cannot push them out of position. Sit scripts that
  attach or teleport the ped to the chair work with frozen chairs. A script that has to move the chair itself will not
  move it.
- Hashes are GTA `joaat` model hashes, shown unsigned and signed. Scripts that take model names can use the names.
