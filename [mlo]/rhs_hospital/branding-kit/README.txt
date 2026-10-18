RHS Burton Hospital - branding kit
==================================

What this is: every texture that shows the hospital's name or logo ("RHS, Royal Health Service, Burton Hospital"),
as PNG files, with the same names and sizes as the textures in the dictionaries in stream/branding/.
Each sub-folder of this kit is named after its dictionary: branding-kit/rhs_branding_signs/ holds the images of
stream/branding/rhs_branding_signs.ytd, and so on.

How to rebrand (three steps):
1. Open the dictionary (.ytd) in OpenIV or CodeWalker and replace each texture you want with your own image.
   Keep the NAME, the SIZE and the FORMAT shown below (DXT1 = no transparency, DXT5 = with transparency).
2. Save the file, restart the server and clear the client cache.
3. Only the textures you replace change. You do not need to replace all of them.

rhs_branding.ytd  -  Hospital name and logo: facade signs, reception backdrop and totems, directory totem, site totem, the reception posters and notices
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  WHAT IT SHOWS
rhs_sg_brand                         2048x256    DXT1    Hospital name and logo on blue (facade signs, reception backdrop, care and check-in totems)
rhs_sg_directory                     512x1024    DXT1    Directory totem: "Welcome to Burton Hospital" and the department list
rhs_sg_totem_n                       1024x2048   DXT5    Site totem outside, first face (arrows point left): logo, name and directions
rhs_sg_totem_s                       1024x2048   DXT5    Site totem outside, second face (arrows point right): logo, name and directions
rhs_sg_poster_care                   512x1024    DXT1    Poster "Better care. Brighter lives."
rhs_sg_poster_checkin                512x1024    DXT1    Poster "Welcome. Please check in at reception."
rhs_sg_poster_respect                512x1024    DXT1    Poster "People. Healthier. Brighter. Together."
rhs_sg_pst_breastfeeding_welcome     512x1024    DXT1    Notice: breastfeeding welcome here
rhs_sg_pst_children_supervised       512x1024    DXT1    Notice: children must be supervised
rhs_sg_pst_cycle_to_work             512x1024    DXT1    Notice: cycle to work
rhs_sg_pst_hospital_radio            512x1024    DXT1    Notice: Burton Hospital Radio
rhs_sg_pst_pay_and_display           512x1024    DXT1    Notice: pay and display
rhs_sg_pst_recycle                   512x1024    DXT1    Notice: recycle right
rhs_sg_pst_self_checkin              512x1024    DXT1    Notice: self check-in
rhs_sg_pst_stem_cell                 512x1024    DXT1    Notice: stem cell register
rhs_sg_pst_sun_safety                512x1024    DXT1    Notice: protect your skin
rhs_sg_pst_volunteer                 512x1024    DXT1    Notice: volunteer with us
rhs_sg_pst_winter_ready              512x1024    DXT1    Notice: keep warm, keep well


rhs_branding_signs.ytd  -  The 32 room door signs (logo + room name)
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
rhs7_back_reception                  1024x256    DXT1    rhs7_sg_back_reception          Room sign
rhs7_blood                           1024x256    DXT1    rhs7_sg_blood                   Room sign
rhs7_canteen                         1024x256    DXT1    rhs7_sg_canteen                 Room sign
rhs7_changing_f                      1024x256    DXT1    rhs7_sg_changing_f              Room sign
rhs7_changing_m                      1024x256    DXT1    rhs7_sg_changing_m              Room sign
rhs7_consult1                        1024x256    DXT1    rhs7_sg_consult1                Room sign
rhs7_consult2                        1024x256    DXT1    rhs7_sg_consult2                Room sign
rhs7_director                        1024x256    DXT1    rhs7_sg_director                Room sign
rhs7_ed_treat                        1024x256    DXT1    rhs7_sg_ed_treat                Room sign
rhs7_garage                          1024x256    DXT1    rhs7_sg_garage                  Room sign
rhs7_icu                             1024x256    DXT1    rhs7_sg_icu                     Room sign
rhs7_majors                          1024x256    DXT1    rhs7_sg_majors                  Room sign
rhs7_meeting                         1024x256    DXT1    rhs7_sg_meeting                 Room sign
rhs7_morgue                          1024x256    DXT1    rhs7_sg_morgue                  Room sign
rhs7_mortuary                        1024x256    DXT1    rhs7_sg_mortuary                Room sign
rhs7_mri                             1024x256    DXT1    rhs7_sg_mri                     Room sign
rhs7_office1                         1024x256    DXT1    rhs7_sg_office1                 Room sign
rhs7_office2                         1024x256    DXT1    rhs7_sg_office2                 Room sign
rhs7_oncall                          1024x256    DXT1    rhs7_sg_oncall                  Room sign
rhs7_pharmacy                        1024x256    DXT1    rhs7_sg_pharmacy                Room sign
rhs7_recovery                        1024x256    DXT1    rhs7_sg_recovery                Room sign
rhs7_relatives                       1024x256    DXT1    rhs7_sg_relatives               Room sign
rhs7_resus                           1024x256    DXT1    rhs7_sg_resus                   Room sign
rhs7_staffroom                       1024x256    DXT1    rhs7_sg_staffroom               Room sign
rhs7_stairs_lift                     1024x256    DXT1    rhs7_sg_stairs_lift             Room sign
rhs7_theatre1                        1024x256    DXT1    rhs7_sg_theatre1                Room sign
rhs7_theatre2                        1024x256    DXT1    rhs7_sg_theatre2                Room sign
rhs7_ward1                           1024x256    DXT1    rhs7_sg_ward1                   Room sign
rhs7_wc_access                       1024x256    DXT1    rhs7_sg_wc_access               Room sign
rhs7_wc_gents                        1024x256    DXT1    rhs7_sg_wc_gents                Room sign
rhs7_wc_ladies                       1024x256    DXT1    rhs7_sg_wc_ladies               Room sign
rhs7_xray                            1024x256    DXT1    rhs7_sg_xray                    Room sign


rhs_branding_wayfinding.ytd  -  Hanging direction signs (both faces), the cafe, shop and help-desk signs, the cafe menu board
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
rhs6_cafe_menu                       2048x1024   DXT1    rhs6_cafe_menu                  Cafe menu board
rhs7_bl_ae_back                      1024x256    DXT1    rhs7_bl_ae                      Hanging direction sign, one face
rhs7_bl_ae_fwd                       1024x256    DXT1    rhs7_bl_ae                      Hanging direction sign, one face
rhs7_bl_c15e_back                    1024x256    DXT1    rhs7_bl_c15_east                Hanging direction sign, one face
rhs7_bl_c15e_fwd                     1024x256    DXT1    rhs7_bl_c15_east                Hanging direction sign, one face
rhs7_bl_c15w_back                    1024x256    DXT1    rhs7_bl_c15_west                Hanging direction sign, one face
rhs7_bl_c15w_fwd                     1024x256    DXT1    rhs7_bl_c15_west                Hanging direction sign, one face
rhs7_bl_entry                        1024x256    DXT1    rhs7_bl_way_out                 Hanging direction sign, one face
rhs7_bl_ff_east                      1024x256    DXT1    rhs7_bl_first_floor             Hanging direction sign, one face
rhs7_bl_ff_west                      1024x256    DXT1    rhs7_bl_first_floor             Hanging direction sign, one face
rhs7_bl_jn_back                      1024x256    DXT1    rhs7_bl_junction                Hanging direction sign, one face
rhs7_bl_jn_fwd                       1024x256    DXT1    rhs7_bl_junction                Hanging direction sign, one face
rhs7_bl_mainrec                      1024x256    DXT1    rhs7_bl_stairs                  Hanging direction sign, one face
rhs7_bl_ramp_back                    1024x256    DXT1    rhs7_bl_ramp_top                Hanging direction sign, one face
rhs7_bl_ramp_fwd                     1024x256    DXT1    rhs7_bl_ramp_top                Hanging direction sign, one face
rhs7_bl_stairs                       1024x256    DXT1    rhs7_bl_stairs                  Hanging direction sign, one face
rhs7_bl_wayout                       1024x256    DXT1    rhs7_bl_way_out                 Hanging direction sign, one face
rhs7_legacy_cafe                     2048x512    DXT1    rhs6_sign_cafe                  Wall sign "RHS Cafe"
rhs7_legacy_help                     2048x512    DXT1    rhs6_sign_help                  Wall sign "Help & Information"
rhs7_legacy_shop                     2048x512    DXT1    rhs6_sign_shop                  Wall sign "RHS Shop"


rhs_branding_posters_1.ytd  -  Wall posters, first third (antibiotics to DVT)
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
rhs7_antibiotics                     512x1024    DXT1    rhs7_pst_antibiotics            Poster
rhs7_asthma                          512x1024    DXT1    rhs7_pst_asthma                 Poster
rhs7_bare_below_elbows               512x1024    DXT1    rhs7_pst_bare_below_elbows      Poster
rhs7_blood_pressure                  512x1024    DXT1    rhs7_pst_blood_pressure         Poster
rhs7_bowel_screening                 512x1024    DXT1    rhs7_pst_bowel_screening        Poster
rhs7_breast_screening                512x1024    DXT1    rhs7_pst_breast_screening       Poster
rhs7_call_dont_fall                  512x1024    DXT1    rhs7_pst_call_dont_fall         Poster
rhs7_carers                          512x1024    DXT1    rhs7_pst_carers                 Poster
rhs7_catch_it                        512x1024    DXT1    rhs7_pst_catch_it               Poster
rhs7_cervical_screening              512x1024    DXT1    rhs7_pst_cervical_screening     Poster
rhs7_chaplaincy                      512x1024    DXT1    rhs7_pst_chaplaincy             Poster
rhs7_choose_well                     512x1024    DXT1    rhs7_pst_choose_well            Poster
rhs7_confidentiality                 512x1024    DXT1    rhs7_pst_confidentiality        Poster
rhs7_covid_booster                   512x1024    DXT1    rhs7_pst_covid_booster          Poster
rhs7_cpr_learn                       512x1024    DXT1    rhs7_pst_cpr_learn              Poster
rhs7_defib_location                  512x1024    DXT1    rhs7_pst_defib_location         Poster
rhs7_dementia_friendly               512x1024    DXT1    rhs7_pst_dementia_friendly      Poster
rhs7_diabetes_risk                   512x1024    DXT1    rhs7_pst_diabetes_risk          Poster
rhs7_discharge_lounge                512x1024    DXT1    rhs7_pst_discharge_lounge       Poster
rhs7_dvt                             512x1024    DXT1    rhs7_pst_dvt                    Poster


rhs_branding_posters_2.ytd  -  Wall posters, second third (fire action to norovirus)
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
rhs7_fire_action                     512x1024    DXT1    rhs7_pst_fire_action            Poster
rhs7_five_a_day                      512x1024    DXT1    rhs7_pst_five_a_day             Poster
rhs7_five_moments                    512x1024    DXT1    rhs7_pst_five_moments           Poster
rhs7_flu_jab                         512x1024    DXT1    rhs7_pst_flu_jab                Poster
rhs7_friends_family_test             512x1024    DXT1    rhs7_pst_friends_family_test    Poster
rhs7_give_blood                      512x1024    DXT1    rhs7_pst_give_blood             Poster
rhs7_hands                           512x1024    DXT1    rhs7_pst_hands                  Poster
rhs7_hearing_loop                    512x1024    DXT1    rhs7_pst_hearing_loop           Poster
rhs7_heart_attack                    512x1024    DXT1    rhs7_pst_heart_attack           Poster
rhs7_interpreter                     512x1024    DXT1    rhs7_pst_interpreter            Poster
rhs7_know_your_pulse                 512x1024    DXT1    rhs7_pst_know_your_pulse        Poster
rhs7_know_your_units                 512x1024    DXT1    rhs7_pst_know_your_units        Poster
rhs7_measles_mmr                     512x1024    DXT1    rhs7_pst_measles_mmr            Poster
rhs7_meningitis                      512x1024    DXT1    rhs7_pst_meningitis             Poster
rhs7_mental_health                   512x1024    DXT1    rhs7_pst_mental_health          Poster
rhs7_mobile_silent                   512x1024    DXT1    rhs7_pst_mobile_silent          Poster
rhs7_move_more                       512x1024    DXT1    rhs7_pst_move_more              Poster
rhs7_mrsa_screening                  512x1024    DXT1    rhs7_pst_mrsa_screening         Poster
rhs7_no_photography                  512x1024    DXT1    rhs7_pst_no_photography         Poster
rhs7_norovirus                       512x1024    DXT1    rhs7_pst_norovirus              Poster


rhs_branding_posters_3.ytd  -  Wall posters, last third (organ donation to zero tolerance)
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
rhs7_organ_donation                  512x1024    DXT1    rhs7_pst_organ_donation         Poster
rhs7_pals                            512x1024    DXT1    rhs7_pst_pals                   Poster
rhs7_pharmacy_first                  512x1024    DXT1    rhs7_pst_pharmacy_first         Poster
rhs7_please_ask                      512x1024    DXT1    rhs7_pst_please_ask             Poster
rhs7_pressure_ulcers                 512x1024    DXT1    rhs7_pst_pressure_ulcers        Poster
rhs7_protected_mealtimes             512x1024    DXT1    rhs7_pst_protected_mealtimes    Poster
rhs7_safe_lifting                    512x1024    DXT1    rhs7_pst_safe_lifting           Poster
rhs7_sepsis                          512x1024    DXT1    rhs7_pst_sepsis                 Poster
rhs7_smoke_free                      512x1024    DXT1    rhs7_pst_smoke_free             Poster
rhs7_speak_up                        512x1024    DXT1    rhs7_pst_speak_up               Poster
rhs7_staff_flu                       512x1024    DXT1    rhs7_pst_staff_flu              Poster
rhs7_staff_wellbeing                 512x1024    DXT1    rhs7_pst_staff_wellbeing        Poster
rhs7_stay_hydrated                   512x1024    DXT1    rhs7_pst_stay_hydrated          Poster
rhs7_stop_smoking                    512x1024    DXT1    rhs7_pst_stop_smoking           Poster
rhs7_stroke                          512x1024    DXT1    rhs7_pst_stroke                 Poster
rhs7_sugar_swaps                     512x1024    DXT1    rhs7_pst_sugar_swaps            Poster
rhs7_sunflower_lanyard               512x1024    DXT1    rhs7_pst_sunflower_lanyard      Poster
rhs7_visiting                        512x1024    DXT1    rhs7_pst_visiting               Poster
rhs7_wait_time                       512x1024    DXT1    rhs7_pst_wait_time              Poster
rhs7_zero_tolerance                  512x1024    DXT1    rhs7_pst_zero_tolerance         Poster


rhs_branding_screens.ytd  -  Equipment screens that show the hospital name: the vitals monitor and the three X-ray units
--------------------------------------------------------------------------------------------------------------
TEXTURE                              SIZE        FORMAT  USED BY MODEL                   WHAT IT SHOWS
c17_ecg                              512x256     DXT1    rhs6_vitals_monitor_stand       Vitals monitor screen ("Burton Hospital")
rhs6_xray_detector_v12_m03_diffuse   1024x1024   DXT1    rhs6_xray_detector_v12          X-ray detector stand: full texture sheet incl. its screen ("RHS")
rhs6_xray_table_v12_m02_diffuse      1024x1024   DXT1    rhs6_xray_table_v12             X-ray table: full texture sheet incl. its panel ("RHS")
rhs6_xray_tube_v12_m03_diffuse       1024x1024   DXT1    rhs6_xray_tube_v12              X-ray tube head: full texture sheet incl. its panel ("RHS")

Not in these dictionaries: the generic wayfinding signs (Main Entrance, A&E, Ambulance, Garage, X-Ray, ...) are in
stream/interior/rhs2_shared.ytd and can be edited the same way.

Do not rename textures, move them to another dictionary or put copies of them inside the .ydr models: the models
look the textures up by name in these dictionaries.
