-- RHS Burton Hospital: settings you may edit. This file is not protected; everything in client/ is.
Config = {}

-- Native door controller: the automatic entrance doors, the garage shutter and the unlocked push doors.
-- Set Enabled = false when a doorlock resource (ox_doorlock, qb-doorlock, ...) controls these doors.
Config.Doors = { Enabled = true }

-- Four-stop lift (A&E, reception, first floor, roof). Stand at a lift front: E = up, G = down.
Config.Lift = { Enabled = true }

-- Keeps ambient peds out of the hospital rooms. Mission peds and players are never touched.
Config.NpcBlock = { Enabled = true }

-- Switches off the old Burton Los Santos Customs interior so it cannot overlap the hospital.
-- Leave it on unless another resource already does this.
Config.RetireOldCustoms = true

-- The door list used by the door controller. id must stay unique. coords are the WORLD position of the
-- door entity of the MLO; model is the game door model. Delete a line to leave that door to another resource.
RHSDoors = {
    { id = 'rhs4_00_ae_wait_blood', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -364.2966, y = -98.6481, z = 38.8881 } },
    { id = 'rhs4_01_ae_wait_corr', model = 'ch_prop_ch_gendoor_01', coords = { x = -365.0627, y = -100.7531, z = 38.8900 } },
    { id = 'rhs4_02_ae_wait_corr', model = 'ch_prop_ch_gendoor_01', coords = { x = -365.9558, y = -103.2066, z = 38.8900 } },
    { id = 'rhs4_03_doc1_ae_wait', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -367.3098, y = -94.5137, z = 38.8881 } },
    { id = 'rhs4_04_doc2_ae_wait', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -364.2088, y = -95.6424, z = 38.8881 } },
    { id = 'rhs4_05_wc_m_ae_ae_wait', model = 'ba_prop_door_club_glam_wc', coords = { x = -375.6078, y = -89.3652, z = 38.9053 } },
    { id = 'rhs4_06_wc_f_ae_ae_wait', model = 'ba_prop_door_club_glam_wc', coords = { x = -373.0706, y = -90.2886, z = 38.9053 } },
    { id = 'rhs4_07_wc_acc_ae_ae_wait', model = 'ba_prop_door_club_glam_wc', coords = { x = -370.5804, y = -91.1950, z = 38.9053 } },
    { id = 'rhs4_08_treat_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -357.5901, y = -102.7338, z = 38.8888 } },
    { id = 'rhs4_09_treat_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -355.1459, y = -103.6234, z = 38.8888 } },
    { id = 'rhs4_10_resus_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -350.5424, y = -105.2990, z = 38.8888 } },
    { id = 'rhs4_11_resus_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -348.0982, y = -106.1886, z = 38.8888 } },
    { id = 'rhs4_12_xray_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -341.0086, y = -108.3433, z = 38.8888 } },
    { id = 'rhs4_13_xray_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -338.5645, y = -109.2329, z = 38.8888 } },
    { id = 'rhs4_14_mri_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -329.2625, y = -112.6185, z = 38.8888 } },
    { id = 'rhs4_15_mri_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -326.8183, y = -113.5081, z = 38.8888 } },
    { id = 'rhs4_16_morgue_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -317.9904, y = -116.7213, z = 38.8888 } },
    { id = 'rhs4_17_morgue_corr', model = 'ch_prop_ch_service_door_01a', coords = { x = -315.5378, y = -117.6139, z = 38.8888 } },
    { id = 'rhs4_18_viewing_public', model = 'ex_p_mp_door_office_door01', coords = { x = -309.9615, y = -123.9002, z = 40.3881 } },
    { id = 'rhs4_19_viewing_public', model = 'ex_p_mp_door_office_door01', coords = { x = -307.5089, y = -124.7929, z = 40.3881 } },
    { id = 'rhs4_20_recovery_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -339.6440, y = -118.6299, z = 38.8888 } },
    { id = 'rhs4_21_recovery_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -340.5336, y = -121.0740, z = 38.8888 } },
    { id = 'rhs4_22_recovery_backrec', model = 'ch_prop_ch_service_door_01a', coords = { x = -347.7627, y = -123.9761, z = 38.8888 } },
    { id = 'rhs4_23_recovery_backrec', model = 'ch_prop_ch_service_door_01a', coords = { x = -345.3185, y = -124.8656, z = 38.8888 } },
    { id = 'rhs4_24_surg1_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -333.8340, y = -117.2860, z = 38.8888 } },
    { id = 'rhs4_25_surg1_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -334.7236, y = -119.7301, z = 38.8888 } },
    { id = 'rhs4_26_surg2_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -336.0571, y = -123.3940, z = 38.8888 } },
    { id = 'rhs4_27_surg2_spine', model = 'ch_prop_ch_service_door_01a', coords = { x = -336.9467, y = -125.8381, z = 38.8888 } },
    { id = 'rhs4_28_staff_spine', model = 'v_ilev_cor_firedoorwide', coords = { x = -341.7682, y = -139.0850, z = 38.7600 } },
    { id = 'rhs4_29_lock_w_spine', model = 'xm3_prop_xm3_firedoor_01b', coords = { x = -344.7392, y = -147.2476, z = 38.7597 } },
    { id = 'rhs4_30_lock_m_glink', model = 'xm3_prop_xm3_firedoor_01b', coords = { x = -346.8084, y = -152.9327, z = 38.7597 } },
    { id = 'rhs4_31_pharmacy_public', model = 'xm3_prop_xm3_firedoor_01b', coords = { x = -314.3534, y = -131.0109, z = 40.2597 } },
    { id = 'rhs4_32_ward_public', model = 'ch_prop_ch_gendoor_01', coords = { x = -320.0003, y = -146.5257, z = 40.3900 } },
    { id = 'rhs4_33_ward_public', model = 'ch_prop_ch_gendoor_01', coords = { x = -320.8933, y = -148.9793, z = 40.3900 } },
    { id = 'rhs4_34_canteen_public', model = 'prop_hospital_door_l', coords = { x = -324.7382, y = -159.5428, z = 39.2400 } },
    { id = 'rhs4_35_canteen_public', model = 'prop_hospital_door_r', coords = { x = -325.7321, y = -162.2736, z = 39.2400 } },
    { id = 'rhs4_36_boss_public', model = 'ex_p_mp_door_office_door01', coords = { x = -328.8108, y = -170.7322, z = 40.3881 } },
    { id = 'rhs4_37_wc_m_public', model = 'ba_prop_door_club_glam_wc', coords = { x = -307.3611, y = -133.7283, z = 40.4053 } },
    { id = 'rhs4_38_wc_f_public', model = 'ba_prop_door_club_glam_wc', coords = { x = -309.4132, y = -139.3665, z = 40.4053 } },
    { id = 'rhs12_control_xray', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -340.0470, y = -102.3082, z = 38.8881 } },
    { id = 'rhs12_control_mri', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -328.9571, y = -106.9831, z = 38.8881 } },
    { id = 'rhs4_39_relwait_icu', model = 'ch_prop_ch_gendoor_01', coords = { x = -324.9176, y = -138.6760, z = 44.8900 } },
    { id = 'rhs4_40_relwait_icu', model = 'ch_prop_ch_gendoor_01', coords = { x = -322.4641, y = -139.5690, z = 44.8900 } },
    { id = 'rhs4_41_relwait_ucorr', model = 'prop_hospital_door_l', coords = { x = -315.3326, y = -133.7013, z = 43.7400 } },
    { id = 'rhs4_42_relwait_ucorr', model = 'prop_hospital_door_r', coords = { x = -316.3265, y = -136.4320, z = 43.7400 } },
    { id = 'rhs4_43_icu_ucorr', model = 'ch_prop_ch_gendoor_01', coords = { x = -322.3945, y = -153.1036, z = 44.8900 } },
    { id = 'rhs4_44_icu_ucorr', model = 'ch_prop_ch_gendoor_01', coords = { x = -323.2875, y = -155.5571, z = 44.8900 } },
    { id = 'rhs4_45_oncall_ucorr', model = 'ex_p_mp_door_apart_doorwhite01', coords = { x = -328.8108, y = -170.7322, z = 44.8881 } },
    { id = 'rhs4_46_off1_ucorr', model = 'v_ilev_cor_firedoorwide', coords = { x = -310.9584, y = -133.3784, z = 44.7600 } },
    { id = 'rhs4_47_off2_ucorr', model = 'v_ilev_cor_firedoorwide', coords = { x = -313.5919, y = -140.6140, z = 44.7600 } },
    { id = 'rhs4_48_meeting_ucorr', model = 'prop_hospital_door_l', coords = { x = -317.6960, y = -151.8899, z = 43.7400 } },
    { id = 'rhs4_49_meeting_ucorr', model = 'prop_hospital_door_r', coords = { x = -318.6899, y = -154.6206, z = 43.7400 } },
    { id = 'rhs4_50_glink_garage', model = 'prop_hospital_door_l', coords = { x = -348.5989, y = -153.7430, z = 37.7400 } },
    { id = 'rhs4_51_glink_garage', model = 'prop_hospital_door_r', coords = { x = -350.0086, y = -151.2018, z = 37.7400 } },
    { id = 'rhs4_52_entrance', model = 'v_ilev_ph_door01', coords = { x = -352.4731, y = -127.5633, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_53_entrance', model = 'v_ilev_ph_door002', coords = { x = -353.3651, y = -130.0140, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_54_entrance', model = 'v_ilev_ph_door01', coords = { x = -308.1501, y = -165.4387, z = 40.3900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_55_entrance', model = 'v_ilev_ph_door002', coords = { x = -306.6826, y = -163.2828, z = 40.3900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_56_entrance', model = 'v_ilev_ph_door01', coords = { x = -378.8124, y = -99.2662, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_57_entrance', model = 'v_ilev_ph_door002', coords = { x = -376.3617, y = -100.1582, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_58_entrance', model = 'v_ilev_ph_door01', coords = { x = -358.3036, y = -106.7308, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_59_entrance', model = 'v_ilev_ph_door002', coords = { x = -355.8529, y = -107.6228, z = 38.8900 }, automaticDistance = 2.5, automaticRate = 1.0 },
    { id = 'rhs4_60_garage_shutter', model = 'v_ilev_bl_shutter2', coords = { x = -358.7222, y = -152.5155, z = 37.2900 }, automaticDistance = 7.0, automaticRate = 0.6 },
    { id = 'rhs4_61_garage_door', model = 'v_ilev_cor_firedoorwide', coords = { x = -355.4943, y = -150.7070, z = 38.3100 } },
}
