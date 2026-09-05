-- ──────────────────────────────────────────────────────────────────────────────
-- Clothing System Detection                                                   
-- (Information) ► Detects your character appearance system automatically.
-- (Information) ► This is used for outfit switching during the laundry mission.
-- (Information) ► Add new integrations by expanding the list below and implementing
--        the logic inside your clothing adapter handlers.
-- ──────────────────────────────────────────────────────────────────────────────
local compatibleClothingList = { 
    ['skinchanger']           = "skinchanger",
    ['illenium-appearance']   = "illenium-appearance",
    ['fivem-appearance']      = "fivem-appearance",
    ['17mov_CharacterSystem'] = "17mov_CharacterSystem",
    ['rcore_clothing']        = "rcore_clothing",
    ['crm-appearance']        = "crm-appearance",
    ['tgiann-clothing']       = "tgiann_clothing",
    ['0r-clothingv2']         = "0r-clothingv2",
}

Config.Clothing = { 
    enable = true, -- Disable/Enable gang locker.
    clothingScript = scriptCheck(compatibleClothingList) or 'none'
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Laundry Mission: Outfit Configuration                                       
-- (Information) ► Defines the outfit the player will wear during the Laundry Mission.
-- (Information) ► Each clothing script uses its own format (components, props, ids, etc.)
-- (Information) ► Use /getMyOutfit in-game to print your current outfit to the F8 console.
-- (Information) ► Do not mix formats between systems. Only edit the block of the system
--        you are using. Wrong formatting will break outfit application.
-- ──────────────────────────────────────────────────────────────────────────────
Config.LaundryClothing = {
    enable = false, -- Enable/disable outfit swapping during laundry missions.

    -- (Information) ► Outfit lists per clothing script.
    -- (Information) ► The script will automatically choose the correct block based on the
    -- detected clothing system (Config.Clothing.clothingScript).
    playerOutFit = {
        ['crm-appearance'] = { {
            crm_texture = 0,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 0,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 1,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 3,
            crm_style = 4
            }, {
            crm_texture = 5,
            crm_id = 4,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 5,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 6,
            crm_style = 3
            }, {
            crm_texture = 0,
            crm_id = 7,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 8,
            crm_style = 15
            }, {
            crm_texture = 0,
            crm_id = 9,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 10,
            crm_style = 0
            }, {
            crm_texture = 0,
            crm_id = 11,
            crm_style = 12
            } },
        ['rcore_clothing'] = {
            components = {
                ["3"] = "nondlcgta5--3--0--0",
                ["8"] = "8_15_0",
                ["11"] = "nondlcgta5--11--9--14"
            },
            props = {}
        },
        ['skinchanger'] = {
            chain_2 = 0,
            mask_1 = 0,
            pants_2 = 1,
            torso_1 = 14,
            bproof_1 = 0,
            shoes_1 = 57,
            bproof_2 = 0,
            glasses_2 = 0,
            glasses_1 = 0,
            helmet_2 = 1,
            tshirt_1 = 15,
            bags_1 = 0,
            decals_1 = 0,
            mask_2 = 0,
            arms_2 = 0,
            tshirt_2 = 0,
            torso_2 = 7,
            bags_2 = 0,
            shoes_2 = 10,
            chain_1 = 0,
            pants_1 = 6,
            arms = 0,
            helmet_1 = 45,
            decals_2 = 0
        },
        ['illenium-appearance'] = {
            { component_id = 0, drawable = 0, texture = 0 },
            { component_id = 1, drawable = 10, texture = 0 },
            { component_id = 2, drawable = 0, texture = 0 },
            { component_id = 3, drawable = 0, texture = 0 },
            { component_id = 4, drawable = 0, texture = 0 },
            { component_id = 5, drawable = 0, texture = 0 },
            { component_id = 6, drawable = 0, texture = 0 },
            { component_id = 7, drawable = 0, texture = 0 },
            { component_id = 8, drawable = 0, texture = 0 },
            { component_id = 9, drawable = 0, texture = 0 },
            { component_id = 10, drawable = 0, texture = 0 },
            { component_id = 11, drawable = 10, texture = 0 }
        },
        ['fivem-appearance'] = {
            { component_id = 0, drawable = 0, texture = 0 },
            { component_id = 1, drawable = 10, texture = 0 },
            { component_id = 2, drawable = 0, texture = 0 },
            { component_id = 3, drawable = 0, texture = 0 },
            { component_id = 4, drawable = 0, texture = 0 },
            { component_id = 5, drawable = 0, texture = 0 },
            { component_id = 6, drawable = 0, texture = 0 },
            { component_id = 7, drawable = 0, texture = 0 },
            { component_id = 8, drawable = 0, texture = 0 },
            { component_id = 9, drawable = 0, texture = 0 },
            { component_id = 10, drawable = 0, texture = 0 },
            { component_id = 11, drawable = 10, texture = 0 }
        },
        ['17mov_CharacterSystem'] = { {
            component_id = 1,
            texture = 0,
            drawable = 0
            }, {
            component_id = 3,
            texture = 0,
            drawable = 0
            }, {
            component_id = 4,
            texture = 2,
            drawable = 15
            }, {
            component_id = 5,
            texture = 0,
            drawable = 0
            }, {
            component_id = 6,
            texture = 0,
            drawable = 114
            }, {
            component_id = 7,
            texture = 0,
            drawable = 0
            }, {
            component_id = 8,
            texture = 0,
            drawable = 15
            }, {
            component_id = 9,
            texture = 0,
            drawable = 0
            }, {
            component_id = 10,
            texture = 0,
            drawable = 0
            }, {
            component_id = 11,
            texture = 0,
            drawable = 36
        }},
    }
}