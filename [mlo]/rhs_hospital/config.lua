-- RHS Burton Hospital: settings you may edit. This file is not protected; everything in client/ is.
Config = {}

-- Native door controller for the RHS fire doors (hinged, GTA doors) and the garage shutter: registers them unlocked.
-- Set Enabled = false when a doorlock resource (ox_doorlock, qb-doorlock, ...) controls these doors.
Config.Doors = { Enabled = true }

-- Automatic sliding entrances (A&E, ambulance, main and rear): glass leaves moved by client/managed_doors.lua. They
-- open when a player walks or drives up and close 3 s after. They are not GTA door-system doors, so a doorlock resource
-- does not move them (keep this on even when Config.Doors is off). Support: /rhsdoors in F8 lists every leaf.
Config.AutoDoors = { Enabled = true }

-- Four-stop lift (A&E, reception, first floor, roof). Stand at a lift front: E = up, G = down.
Config.Lift = { Enabled = true }

-- Keeps ambient peds out of the hospital rooms. Mission peds and players are never touched.
Config.NpcBlock = { Enabled = true }

-- Switches off the old Burton Los Santos Customs interior so it cannot overlap the hospital.
-- Leave it on unless another resource already does this.
Config.RetireOldCustoms = true

-- The door list used by the door controller. id must stay unique. coords are the WORLD position of the door entity of
-- the MLO (the hinge, at floor level); model is the door model. Delete a line to leave that door to another resource.
RHSDoors = {
    { id = 'rhs4_00_ae_wait_blood', model = 'rhs_oak_vp_1304_2296', coords = { x = -364.2966, y = -98.6482, z = 37.7400 } },
    { id = 'rhs4_01_ae_wait_corr', model = 'rhs_oak_vp_1302_2300', coords = { x = -365.0628, y = -100.7531, z = 37.7400 } },
    { id = 'rhs4_02_ae_wait_corr', model = 'rhs_oak_vp_1302_2300', coords = { x = -365.9558, y = -103.2066, z = 37.7400 } },
    { id = 'rhs4_03_doc1_ae_wait', model = 'rhs_oak_solid_1304_2296', coords = { x = -367.3098, y = -94.5138, z = 37.7400 } },
    { id = 'rhs4_04_doc2_ae_wait', model = 'rhs_oak_solid_1304_2296', coords = { x = -364.2088, y = -95.6424, z = 37.7400 } },
    { id = 'rhs4_05_wc_m_ae_ae_wait', model = 'rhs_wc_door_1305_2296', coords = { x = -375.6078, y = -89.3652, z = 37.7400 } },
    { id = 'rhs4_06_wc_f_ae_ae_wait', model = 'rhs_wc_door_1305_2296', coords = { x = -373.0707, y = -90.2886, z = 37.7400 } },
    { id = 'rhs4_07_wc_acc_ae_ae_wait', model = 'rhs_wc_door_1305_2296', coords = { x = -370.5805, y = -91.1950, z = 37.7400 } },
    { id = 'rhs4_08_treat_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -357.5934, y = -102.7327, z = 37.7400 } },
    { id = 'rhs4_09_treat_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -355.1426, y = -103.6246, z = 37.7400 } },
    { id = 'rhs4_10_resus_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -350.5457, y = -105.2978, z = 37.7400 } },
    { id = 'rhs4_11_resus_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -348.0949, y = -106.1898, z = 37.7400 } },
    { id = 'rhs4_12_xray_corr', model = 'rhs_oak_solid_1300_2296', coords = { x = -341.0119, y = -108.3421, z = 37.7400 } },
    { id = 'rhs4_13_xray_corr', model = 'rhs_oak_solid_1300_2296', coords = { x = -338.5612, y = -109.2341, z = 37.7400 } },
    { id = 'rhs4_14_mri_corr', model = 'rhs_oak_solid_1300_2296', coords = { x = -329.2658, y = -112.6174, z = 37.7400 } },
    { id = 'rhs4_15_mri_corr', model = 'rhs_oak_solid_1300_2296', coords = { x = -326.8151, y = -113.5094, z = 37.7400 } },
    { id = 'rhs4_16_morgue_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -317.9904, y = -116.7213, z = 37.7400 } },
    { id = 'rhs4_17_morgue_corr', model = 'rhs_oak_vp_1300_2296', coords = { x = -315.5378, y = -117.6140, z = 37.7400 } },
    { id = 'rhs4_18_viewing_public', model = 'rhs_oak_solid_1300_2296', coords = { x = -309.9616, y = -123.9003, z = 39.2400 } },
    { id = 'rhs4_19_viewing_public', model = 'rhs_oak_solid_1300_2296', coords = { x = -307.5090, y = -124.7929, z = 39.2400 } },
    { id = 'rhs4_20_recovery_spine', model = 'rhs_oak_vp_1300_2296', coords = { x = -339.6429, y = -118.6266, z = 37.7400 } },
    { id = 'rhs4_21_recovery_spine', model = 'rhs_oak_vp_1300_2296', coords = { x = -340.5349, y = -121.0773, z = 37.7400 } },
    { id = 'rhs4_22_recovery_backrec', model = 'rhs_oak_vp_1300_2296', coords = { x = -347.7660, y = -123.9749, z = 37.7400 } },
    { id = 'rhs4_23_recovery_backrec', model = 'rhs_oak_vp_1300_2296', coords = { x = -345.3152, y = -124.8669, z = 37.7400 } },
    { id = 'rhs4_24_surg1_spine', model = 'rhs_oak_solid_1300_2296', coords = { x = -333.8328, y = -117.2827, z = 37.7400 } },
    { id = 'rhs4_25_surg1_spine', model = 'rhs_oak_solid_1300_2296', coords = { x = -334.7248, y = -119.7334, z = 37.7400 } },
    { id = 'rhs4_26_surg2_spine', model = 'rhs_oak_solid_1300_2296', coords = { x = -336.0560, y = -123.3907, z = 37.7400 } },
    { id = 'rhs4_27_surg2_spine', model = 'rhs_oak_solid_1300_2296', coords = { x = -336.9480, y = -125.8414, z = 37.7400 } },
    { id = 'rhs4_28_staff_spine', model = 'rhs_oak_vp_1290_2296', coords = { x = -341.7682, y = -139.0850, z = 37.7400 } },
    { id = 'rhs4_29_lock_w_spine', model = 'rhs_oak_solid_1162_2296', coords = { x = -344.7392, y = -147.2476, z = 37.7400 } },
    { id = 'rhs4_30_lock_m_glink', model = 'rhs_oak_solid_1162_2296', coords = { x = -346.8084, y = -152.9328, z = 37.7400 } },
    { id = 'rhs4_31_pharmacy_public', model = 'rhs_oak_vp_1162_2296', coords = { x = -314.3534, y = -131.0110, z = 39.2400 } },
    { id = 'rhs4_32_ward_public', model = 'rhs_oak_vp_1302_2300', coords = { x = -320.0004, y = -146.5258, z = 39.2400 } },
    { id = 'rhs4_33_ward_public', model = 'rhs_oak_vp_1302_2300', coords = { x = -320.8934, y = -148.9793, z = 39.2400 } },
    { id = 'rhs4_34_canteen_public', model = 'rhs_oak_vp_1448_2130', coords = { x = -324.7382, y = -159.5429, z = 39.2400 } },
    { id = 'rhs4_35_canteen_public', model = 'rhs_oak_vp_1448_2130', coords = { x = -325.7321, y = -162.2736, z = 39.2400 } },
    { id = 'rhs4_36_boss_public', model = 'rhs_oak_solid_1304_2296', coords = { x = -328.8108, y = -170.7322, z = 39.2400 } },
    { id = 'rhs4_37_wc_m_public', model = 'rhs_wc_door_1305_2296', coords = { x = -307.3611, y = -133.7284, z = 39.2400 } },
    { id = 'rhs4_38_wc_f_public', model = 'rhs_wc_door_1305_2296', coords = { x = -309.4133, y = -139.3665, z = 39.2400 } },
    { id = 'rhs12_control_xray', model = 'rhs_oak_solid_1304_2294', coords = { x = -340.0470, y = -102.3083, z = 37.7401 } },
    { id = 'rhs12_control_mri', model = 'rhs_oak_solid_1304_2294', coords = { x = -328.9571, y = -106.9832, z = 37.7401 } },
    { id = 'rhs4_39_relwait_icu', model = 'rhs_oak_vp_1302_2300', coords = { x = -324.9176, y = -138.6761, z = 43.7400 } },
    { id = 'rhs4_40_relwait_icu', model = 'rhs_oak_vp_1302_2300', coords = { x = -322.4641, y = -139.5691, z = 43.7400 } },
    { id = 'rhs4_41_relwait_ucorr', model = 'rhs_oak_vp_1448_2130', coords = { x = -315.3326, y = -133.7013, z = 43.7400 } },
    { id = 'rhs4_42_relwait_ucorr', model = 'rhs_oak_vp_1448_2130', coords = { x = -316.3265, y = -136.4321, z = 43.7400 } },
    { id = 'rhs4_43_icu_ucorr', model = 'rhs_oak_vp_1302_2300', coords = { x = -322.3945, y = -153.1036, z = 43.7400 } },
    { id = 'rhs4_44_icu_ucorr', model = 'rhs_oak_vp_1302_2300', coords = { x = -323.2875, y = -155.5572, z = 43.7400 } },
    { id = 'rhs4_45_oncall_ucorr', model = 'rhs_oak_solid_1304_2296', coords = { x = -328.8108, y = -170.7322, z = 43.7400 } },
    { id = 'rhs4_46_off1_ucorr', model = 'rhs_oak_solid_1290_2296', coords = { x = -310.9584, y = -133.3784, z = 43.7400 } },
    { id = 'rhs4_47_off2_ucorr', model = 'rhs_oak_solid_1290_2296', coords = { x = -313.5920, y = -140.6140, z = 43.7400 } },
    { id = 'rhs4_48_meeting_ucorr', model = 'rhs_oak_vp_1448_2130', coords = { x = -317.6960, y = -151.8899, z = 43.7400 } },
    { id = 'rhs4_49_meeting_ucorr', model = 'rhs_oak_vp_1448_2130', coords = { x = -318.6899, y = -154.6206, z = 43.7400 } },
    { id = 'rhs4_50_glink_garage', model = 'rhs_oak_vp_1448_2130', coords = { x = -348.5990, y = -153.7430, z = 37.7400 } },
    { id = 'rhs4_51_glink_garage', model = 'rhs_oak_vp_1448_2130', coords = { x = -350.0087, y = -151.2018, z = 37.7400 } },
    { id = 'rhs4_61_garage_door', model = 'rhs_exit_1290_2304', coords = { x = -355.4943, y = -150.7071, z = 37.2900 } },
    { id = 'rhs4_60_garage_shutter', model = 'v_ilev_bl_shutter2', coords = { x = -358.7222, y = -152.5155, z = 37.2900 }, automaticDistance = 7.0, automaticRate = 0.6 },
}

-- The automatic sliding leaves (generated by the build; world position of the closed leaf, heading, travel when open,
-- the zone that opens it, and a point in the MLO room that lights it). Delete an entrance's lines (same group) to remove it.
RHSAutoDoors = {
    { id = 'rhs_main_0', model = 'rhs_bf_slider', group = 'main', room = "Main Reception", x = -307.9077, y = -164.8338, z = 39.2400, heading = 55.757, vx = -0.56271, vy = -0.82665, vz = 0.00000, travel = 1.320, speed = 0.900, sensorX = -307.4164, sensorY = -164.3608, ax = 0.56271, ay = 0.82665, along = 1.40, across = 2.40, roomX = -309.4830, roomY = -162.9540, roomZ = 40.2400 },
    { id = 'rhs_main_1', model = 'rhs_bf_slider', group = 'main', room = "Main Reception", x = -307.1565, y = -163.7302, z = 39.2400, heading = 55.757, vx = 0.56271, vy = 0.82665, vz = 0.00000, travel = 1.320, speed = 0.900, sensorX = -307.4164, sensorY = -164.3608, ax = 0.56271, ay = 0.82665, along = 1.40, across = 2.40, roomX = -309.4830, roomY = -162.9540, roomZ = 40.2400 },
    { id = 'rhs_rear_0', model = 'rhs_bf_slider_t', group = 'rear', room = "Main Corridor and Back Reception", x = -352.4490, y = -127.9063, z = 37.7400, heading = 250.000, vx = 0.34202, vy = 0.93969, vz = 0.00000, travel = 0.639, speed = 0.448, sensorX = -352.9192, sensorY = -128.7887, ax = -0.34202, ay = -0.93969, along = 1.40, across = 2.40, roomX = -350.5699, roomY = -129.6437, roomZ = 38.7400 },
    { id = 'rhs_rear_1', model = 'rhs_bf_slider_t', group = 'rear', room = "Main Corridor and Back Reception", x = -352.6226, y = -128.5295, z = 37.7400, heading = 250.000, vx = 0.34202, vy = 0.93969, vz = 0.00000, travel = 1.284, speed = 0.900, sensorX = -352.9192, sensorY = -128.7887, ax = -0.34202, ay = -0.93969, along = 1.40, across = 2.40, roomX = -350.5699, roomY = -129.6437, roomZ = 38.7400 },
    { id = 'rhs_rear_2', model = 'rhs_bf_slider_t', group = 'rear', room = "Main Corridor and Back Reception", x = -353.1262, y = -129.7669, z = 37.7400, heading = 250.000, vx = -0.34202, vy = -0.93969, vz = 0.00000, travel = 0.638, speed = 0.448, sensorX = -352.9192, sensorY = -128.7887, ax = -0.34202, ay = -0.93969, along = 1.40, across = 2.40, roomX = -350.5699, roomY = -129.6437, roomZ = 38.7400 },
    { id = 'rhs_rear_3', model = 'rhs_bf_slider_t', group = 'rear', room = "Main Corridor and Back Reception", x = -352.8586, y = -129.1779, z = 37.7400, heading = 250.000, vx = -0.34202, vy = -0.93969, vz = 0.00000, travel = 1.283, speed = 0.900, sensorX = -352.9192, sensorY = -128.7887, ax = -0.34202, ay = -0.93969, along = 1.40, across = 2.40, roomX = -350.5699, roomY = -129.6437, roomZ = 38.7400 },
    { id = 'rhs_ae_0', model = 'rhs_bf_slider_t', group = 'ae', room = "Emergency Waiting Area", x = -378.4695, y = -99.2421, z = 37.7400, heading = 340.000, vx = -0.93969, vy = 0.34202, vz = 0.00000, travel = 0.665, speed = 0.457, sensorX = -377.5871, sensorY = -99.7122, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -376.7320, roomY = -97.3630, roomZ = 38.7400 },
    { id = 'rhs_ae_1', model = 'rhs_bf_slider_t', group = 'ae', room = "Emergency Waiting Area", x = -377.8463, y = -99.4157, z = 37.7400, heading = 340.000, vx = -0.93969, vy = 0.34202, vz = 0.00000, travel = 1.310, speed = 0.900, sensorX = -377.5871, sensorY = -99.7122, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -376.7320, roomY = -97.3630, roomZ = 38.7400 },
    { id = 'rhs_ae_2', model = 'rhs_bf_slider_t', group = 'ae', room = "Emergency Waiting Area", x = -376.6089, y = -99.9193, z = 37.7400, heading = 340.000, vx = 0.93969, vy = -0.34202, vz = 0.00000, travel = 0.665, speed = 0.457, sensorX = -377.5871, sensorY = -99.7122, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -376.7320, roomY = -97.3630, roomZ = 38.7400 },
    { id = 'rhs_ae_3', model = 'rhs_bf_slider_t', group = 'ae', room = "Emergency Waiting Area", x = -377.1979, y = -99.6517, z = 37.7400, heading = 340.000, vx = 0.93969, vy = -0.34202, vz = 0.00000, travel = 1.310, speed = 0.900, sensorX = -377.5871, sensorY = -99.7122, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -376.7320, roomY = -97.3630, roomZ = 38.7400 },
    { id = 'rhs_ambulance_0', model = 'rhs_bf_slider_t', group = 'ambulance', room = "Clinical Corridor", x = -357.9607, y = -106.7067, z = 37.7400, heading = 340.000, vx = -0.93969, vy = 0.34202, vz = 0.00000, travel = 0.196, speed = 0.210, sensorX = -357.0783, sensorY = -107.1768, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -356.2232, roomY = -104.8276, roomZ = 38.7400 },
    { id = 'rhs_ambulance_1', model = 'rhs_bf_slider_t', group = 'ambulance', room = "Clinical Corridor", x = -357.3375, y = -106.8803, z = 37.7400, heading = 340.000, vx = -0.93969, vy = 0.34202, vz = 0.00000, travel = 0.841, speed = 0.900, sensorX = -357.0783, sensorY = -107.1768, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -356.2232, roomY = -104.8276, roomZ = 38.7400 },
    { id = 'rhs_ambulance_2', model = 'rhs_bf_slider_t', group = 'ambulance', room = "Clinical Corridor", x = -356.1001, y = -107.3839, z = 37.7400, heading = 340.000, vx = 0.93969, vy = -0.34202, vz = 0.00000, travel = 0.665, speed = 0.457, sensorX = -357.0783, sensorY = -107.1768, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -356.2232, roomY = -104.8276, roomZ = 38.7400 },
    { id = 'rhs_ambulance_3', model = 'rhs_bf_slider_t', group = 'ambulance', room = "Clinical Corridor", x = -356.6891, y = -107.1163, z = 37.7400, heading = 340.000, vx = 0.93969, vy = -0.34202, vz = 0.00000, travel = 1.310, speed = 0.900, sensorX = -357.0783, sensorY = -107.1768, ax = 0.93969, ay = -0.34202, along = 1.40, across = 2.40, roomX = -356.2232, roomY = -104.8276, roomZ = 38.7400 },
}
