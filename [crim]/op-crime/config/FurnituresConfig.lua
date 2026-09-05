-- ──────────────────────────────────────────────────────────────────────────────
-- 🪑 FURNITURE SYSTEM CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
-- Description:
-- This configuration controls the furniture system used inside gang hideouts.
-- Players can place, manage, and sell furniture objects such as decor,
-- storage units, and functional objects (boss menu, storage, etc.).
-- ──────────────────────────────────────────────────────────────────────────────

-- 🔧 GENERAL SETTINGS
Config.EnableFurnitures = true -- Enable / Disable furniture system

Config.FurnituresCommand = "furnitures" 
-- Command used to open the furniture menu inside gang hideout

Config.FurnitureSellPercentage = 90 
-- Percentage of original price returned when selling furniture
-- Example: 500$ item → player gets 450$ (10% loss)

-- 🏠 SHELLS (INTERIORS)
-- Defines available interiors where furniture can be placed

-- Shells in this config (FREE): https://k4mb1maps.com/product/5015840

Config.Shells = {
    ['k4_house3_shell'] = {
        name = "K4 Small House",
        spawn = "k4_house3_shell", -- Shell model
        coords = vec3(-1035.2122, -851.6562, -12.7472), -- Interior coordinates
        entranceDoor = vec4(-1032.7672, -855.3149, -11.5169, 81.7287) -- Entrance position
    },
    ['k4_warehouse1_shell'] = {
        name = "K4 Warehouse",
        spawn = "k4_warehouse1_shell",
        coords = vec3(-1020.3682, -815.6011, -11.7018),
        entranceDoor = vec4(-1028.8514, -815.3627, -10.3859, 259.8542)
    }
}


-- 📂 FURNITURE CATEGORIES
-- Used to organize furniture in the UI
Config.FurnituresCategories = {
    {name = "Living Room"},
    {name = "Bedroom"},
    {name = "Kitchen"},
    {name = "Bathroom"},
    {name = "Decor"},

    {name = "Boss Office - Desks"},
    {name = "Boss Office - Electronics"},
    {name = "Boss Office - Seating"},

    {name = "Storage"},
    {name = "Warehouse"}
}


-- 🪑 FURNITURE LIST
-- Each furniture item includes:
-- model     -> GTA prop model
-- category  -> UI category
-- price     -> purchase price
-- label     -> display name
-- usable    -> (optional) interaction type
-- helpText  -> (optional) description shown to player

Config.Furnitures = {

    -- LIVING ROOM (8)
    ["apa_mp_h_stn_sofacorn_01"] = { model = "apa_mp_h_stn_sofacorn_01", category = "Living Room", price = 2500, label = "Corner Sofa" },
    ["apa_mp_h_stn_sofa2seat_02"] = { model = "apa_mp_h_stn_sofa2seat_02", category = "Living Room", price = 1800, label = "Two Seat Sofa" },
    ["apa_mp_h_yacht_coffee_table_01"] = { model = "apa_mp_h_yacht_coffee_table_01", category = "Living Room", price = 900, label = "Coffee Table" },
    ["apa_mp_h_yacht_side_table_01"] = { model = "apa_mp_h_yacht_side_table_01", category = "Living Room", price = 600, label = "Side Table" },
    ["apa_mp_h_str_avunitl_01_b"] = { model = "apa_mp_h_str_avunitl_01_b", category = "Living Room", price = 1200, label = "TV Cabinet" },
    ["apa_mp_h_str_avunits_04"] = { model = "apa_mp_h_str_avunits_04", category = "Living Room", price = 1500, label = "Modern TV Unit" },
    ["prop_tv_flat_01"] = { model = "prop_tv_flat_01", category = "Living Room", price = 1300, label = "Flat TV" },
    ["apa_mp_h_stn_sofacorn_05"] = { model = "apa_mp_h_stn_sofacorn_05", category = "Living Room", price = 2600, label = "Modern Corner Sofa" },
    ["apa_mp_h_stn_sofa_daybed_01"] = { model = "apa_mp_h_stn_sofa_daybed_01", category = "Living Room", price = 2200, label = "Daybed Sofa" },
    ["prop_t_coffe_table"] = { model = "prop_t_coffe_table", category = "Living Room", price = 700, label = "Wood Coffee Table" },
    ["prop_tv_flat_02"] = { model = "prop_tv_flat_02", category = "Living Room", price = 1400, label = "Large Flat TV" },
    ["prop_cs_remote_01"] = { model = "prop_cs_remote_01", category = "Living Room", price = 100, label = "TV Remote" },

    -- BEDROOM (8)
    ["apa_mp_h_bed_double_08"] = { model = "apa_mp_h_bed_double_08", category = "Bedroom", price = 3000, label = "Double Bed" },
    ["apa_mp_h_bed_with_table_02"] = { model = "apa_mp_h_bed_with_table_02", category = "Bedroom", price = 3200, label = "Luxury Bed" },
    ["apa_mp_h_din_chair_04"] = { model = "apa_mp_h_din_chair_04", category = "Bedroom", price = 400, label = "Bedroom Chair" },
    ["apa_mp_h_bed_chestdrawer_02"] = { model = "apa_mp_h_bed_chestdrawer_02", category = "Bedroom", price = 1400, label = "Chest Drawer", usable = {type = "locker"}, helpText = "Locker for clothing" },
    ["apa_mp_h_str_shelffloorm_02"] = { model = "apa_mp_h_str_shelffloorm_02", category = "Bedroom", price = 1100, label = "Shelf Unit" },
    ["apa_mp_h_bed_double_09"] = { model = "apa_mp_h_bed_double_09", category = "Bedroom", price = 3100, label = "Modern Bed" },
    ["prop_clothes_rail_01"] = { model = "prop_clothes_rail_01", category = "Bedroom", price = 800, label = "Clothes Rail" },

    -- KITCHEN (8)
    ["apa_mp_h_din_table_06"] = { model = "apa_mp_h_din_table_06", category = "Kitchen", price = 2000, label = "Dining Table" },
    ["apa_mp_h_din_chair_08"] = { model = "apa_mp_h_din_chair_08", category = "Kitchen", price = 450, label = "Dining Chair" },
    ["prop_kitch_juicer"] = { model = "prop_kitch_juicer", category = "Kitchen", price = 300, label = "Juicer" },
    ["prop_micro_01"] = { model = "prop_micro_01", category = "Kitchen", price = 500, label = "Microwave" },
    ["prop_fridge_01"] = { model = "prop_fridge_01", category = "Kitchen", price = 1500, label = "Fridge" },
    ["prop_coffee_mac_02"] = { model = "prop_coffee_mac_02", category = "Kitchen", price = 450, label = "Coffee Machine" },
    ["prop_washer_01"] = { model = "prop_washer_01", category = "Kitchen", price = 1400, label = "Washer" },
    ["prop_cooker_03"] = { model = "prop_cooker_03", category = "Kitchen", price = 1100, label = "Cooker" },

    -- BATHROOM (8)
    ["prop_toilet_01"] = { model = "prop_toilet_01", category = "Bathroom", price = 400, label = "Toilet" },
    ["prop_sink_02"] = { model = "prop_sink_02", category = "Bathroom", price = 350, label = "Sink" },
    ["prop_shower_rack_01"] = { model = "prop_shower_rack_01", category = "Bathroom", price = 300, label = "Shower Rack" },
    ["prop_towel_rail_01"] = { model = "prop_towel_rail_01", category = "Bathroom", price = 200, label = "Towel Rail" },
    ["prop_mirror_01"] = { model = "prop_mirror_01", category = "Bathroom", price = 250, label = "Mirror" },
    ["prop_bin_05a"] = { model = "prop_bin_05a", category = "Bathroom", price = 150, label = "Trash Bin" },
    ["prop_toilet_brush_01"] = { model = "prop_toilet_brush_01", category = "Bathroom", price = 100, label = "Toilet Brush" },
    ["prop_table_05"] = { model = "prop_table_05", category = "Boss Office - Desks", price = 1000, label = "Wide Table" },
    ["prop_fbi3_coffee_table"] = { model = "prop_fbi3_coffee_table", category = "Boss Office - Desks", price = 1200, label = "Office Coffee Table" },

    -- DECOR (8)
    ["apa_mp_h_acc_vase_01"] = { model = "apa_mp_h_acc_vase_01", category = "Decor", price = 300, label = "Vase" },
    ["apa_mp_h_acc_plant_palm_01"] = { model = "apa_mp_h_acc_plant_palm_01", category = "Decor", price = 700, label = "Palm Plant" },
    ["apa_mp_h_acc_artwalll_02"] = { model = "apa_mp_h_acc_artwalll_02", category = "Decor", price = 800, label = "Wall Art" },
    ["apa_mp_h_acc_rugwooll_03"] = { model = "apa_mp_h_acc_rugwooll_03", category = "Decor", price = 450, label = "Wool Rug" },
    ["prop_glass_stack_01"] = { model = "prop_glass_stack_01", category = "Decor", price = 150, label = "Glass Stack" },
    ["prop_pot_plant_01a"] = { model = "prop_pot_plant_01a", category = "Decor", price = 350, label = "Small Plant" },
    

    -- BOSS OFFICE - DESKS (8)
    ["apa_mp_h_office_desk_02"] = { model = "apa_mp_h_office_desk_02", category = "Boss Office - Desks", price = 3500, label = "Modern Desk" },
    ["apa_mp_h_yacht_table_01"] = { model = "apa_mp_h_yacht_table_01", category = "Boss Office - Desks", price = 2800, label = "Meeting Table" },
    ["prop_table_02"] = { model = "prop_table_02", category = "Boss Office - Desks", price = 900, label = "Small Table" },
    ["prop_office_desk_01"] = { model = "prop_office_desk_01", category = "Boss Office - Desks", price = 2000, label = "Office Desk" },
    ["prop_table_03"] = { model = "prop_table_03", category = "Boss Office - Desks", price = 850, label = "Wood Table" },
    ["prop_table_04"] = { model = "prop_table_04", category = "Boss Office - Desks", price = 950, label = "Metal Desk" },
    ["prop_office_desk_02"] = { model = "prop_office_desk_02", category = "Boss Office - Desks", price = 2200, label = "Office Desk Large" },
    ["prop_table_05"] = { model = "prop_table_05", category = "Boss Office - Desks", price = 1000, label = "Wide Table" },
    ["prop_fbi3_coffee_table"] = { model = "prop_fbi3_coffee_table", category = "Boss Office - Desks", price = 1200, label = "Office Coffee Table" },

    -- BOSS OFFICE - ELECTRONICS (8)
    ["prop_laptop_01a"] = { model = "prop_laptop_01a", category = "Boss Office - Electronics", price = 0, label = "Laptop", usable = {type = "bossmenu"} },
    ["prop_monitor_01a"] = { model = "prop_monitor_01a", category = "Boss Office - Electronics", price = 800, label = "Monitor", usable = {type = "bossmenu"} },
    ["prop_pc_01a"] = { model = "prop_pc_01a", category = "Boss Office - Electronics", price = 1200, label = "PC Tower" },
    ["prop_printer_01"] = { model = "prop_printer_01", category = "Boss Office - Electronics", price = 700, label = "Printer" },
    ["prop_office_phone_tnt"] = { model = "prop_office_phone_tnt", category = "Boss Office - Electronics", price = 500, label = "Office Phone" },
    ["hei_prop_hei_bank_mon"] = { model = "hei_prop_hei_bank_mon", category = "Boss Office - Electronics", price = 2500, label = "Multi Monitor Setup" },
    ["prop_cctv_cam_01a"] = { model = "prop_cctv_cam_01a", category = "Boss Office - Electronics", price = 800, label = "CCTV Camera" },

    -- BOSS OFFICE - SEATING (8)
    ["prop_off_chair_01"] = { model = "prop_off_chair_01", category = "Boss Office - Seating", price = 700, label = "Desk Chair" },
    ["v_corp_offchair"] = { model = "v_corp_offchair", category = "Boss Office - Seating", price = 1000, label = "Corporate Chair" },
    ["prop_chair_01a"] = { model = "prop_chair_01a", category = "Boss Office - Seating", price = 300, label = "Basic Chair" },
    ["prop_armchair_01"] = { model = "prop_armchair_01", category = "Boss Office - Seating", price = 850, label = "Armchair" },
    ["prop_chair_04a"] = { model = "prop_chair_04a", category = "Boss Office - Seating", price = 350, label = "Meeting Chair" },
    ["prop_bar_stool_01"] = { model = "prop_bar_stool_01", category = "Boss Office - Seating", price = 250, label = "Bar Stool" },
    ["prop_chair_02"] = { model = "prop_chair_02", category = "Boss Office - Seating", price = 350, label = "Simple Chair" },
    ["prop_chair_06"] = { model = "prop_chair_06", category = "Boss Office - Seating", price = 400, label = "Plastic Chair" },

    -- STORAGE (8) 
    ["prop_boxpile_06b"] = { model = "prop_boxpile_06b", category = "Storage", price = 500, label = "Box Pile", usable = {type = "storage", capacity = 500000, slots = 50}, helpText = "This object allows you to store items up to 50kg capacity and 50 slots." },
    ["prop_box_wood02a_pu"] = { model = "prop_box_wood02a_pu", category = "Storage", price = 300, label = "Wood Box", usable = {type = "storage", capacity = 350000, slots = 30}, helpText = "This object allows you to store items up to 35kg capacity and 30 slots." },
    ["prop_crate_11e"] = { model = "prop_crate_11e", category = "Storage", price = 350, label = "Large Crate", usable = {type = "storage", capacity = 200000, slots = 20}, helpText = "This object allows you to store items up to 20kg capacity and 20 slots." },
    ["prop_ld_int_safe_01"] = { model = "prop_ld_int_safe_01", category = "Storage", price = 2500, label = "Safe", usable = {type = "storage", capacity = 5000, slots = 10}, helpText = "This object allows you to store items up to 5kg capacity and 10 slots." },
    ["prop_mil_crate_01"] = { model = "prop_mil_crate_01", category = "Storage", price = 600, label = "Military Crate", usable = {type = "storage", capacity = 20000, slots = 15}, helpText = "This object allows you to store items up to 20kg capacity and 15 slots." },
    ["prop_cabinet_02b"] = { model = "prop_cabinet_02b", category = "Storage", price = 900, label = "Storage Cabinet", usable = {type = "storage", capacity = 350000, slots = 50}, helpText = "This object allows you to store items up to 35kg capacity and 50 slots." },
    ["prop_boxpile_02c"] = { model = "prop_boxpile_02c", category = "Storage", price = 400, label = "Small Box Pile" },
    ["prop_crate_03a"] = { model = "prop_crate_03a", category = "Storage", price = 300, label = "Wood Crate" },
    ["prop_toolchest_01"] = { model = "prop_toolchest_01", category = "Storage", price = 800, label = "Tool Chest" },

    -- WAREHOUSE (8)
    ["prop_ind_mech_01c"] = { model = "prop_ind_mech_01c", category = "Warehouse", price = 3000, label = "Industrial Machine" },
    ["prop_generator_01a"] = { model = "prop_generator_01a", category = "Warehouse", price = 2800, label = "Generator" },
    ["prop_barrel_02a"] = { model = "prop_barrel_02a", category = "Warehouse", price = 250, label = "Barrel" },
    ["prop_container_05a"] = { model = "prop_container_05a", category = "Warehouse", price = 4000, label = "Shipping Container" },
    ["prop_gas_tank_01a"] = { model = "prop_gas_tank_01a", category = "Warehouse", price = 2200, label = "Gas Tank" },
    ["prop_worklight_03b"] = { model = "prop_worklight_03b", category = "Warehouse", price = 450, label = "Work Light" },
    ["prop_tool_bench02"] = { model = "prop_tool_bench02", category = "Warehouse", price = 1200, label = "Workbench" },
    ["prop_pallet_02a"] = { model = "prop_pallet_02a", category = "Warehouse", price = 300, label = "Pallet" },
    ["prop_barrel_03a"] = { model = "prop_barrel_03a", category = "Warehouse", price = 300, label = "Rusty Barrel" },

}

-- ⚙️ USABLE FURNITURE FUNCTIONS
-- Defines interactions for specific furniture types

Config.UsableFunctions = {
    ['storage'] = {
        label = "Open Storage",
        icon = "fa-solid fa-box", 
        onSelect = function(furnitureId, capacity, slots, label)
            openFurnitureStorage("furniture_storage_" .. furnitureId, capacity, slots, label)
        end,
    },
    ['bossmenu'] = {
        label = "Open Bossmenu",
        icon = "fa-solid fa-skull-crossbones",

        onSelect = function()
            openBossMenu(false, playerOrganisationData.jobId)
        end,
    },
    ['locker'] = {
        label = "Open Locker",
        icon = "fa-solid fa-shirt",

        onSelect = function()
            openCloakRoom()
        end,
    }
}