--[[
    - this script needs tgiann-core script to work, you can download the script from your keymaster account
      Start tgiann-core script after es_extented/qb-core script and before tgiann-* scripts
      Adjust the tgiann-core config file according to the framework you are using

    ⚠️ Recommended settings for PMA Voice : https://docs.tgiann.com/scripts/tgiann-radio/recommended-settings-for-pma-voice ⚠️
    ❗ If you experience any issues with sounds, use the recommended version and PMA settings.❗

    ⚠️⚠️⚠️ Installation : https://docs.tgiann.com/scripts/tgiann-radio/installation ⚠️⚠️⚠️
]]

tgiCoreExports = exports["tgiann-core"]
config = tgiCoreExports:getConfig()

config.showAvailableFreq = true -- When this setting is true, the frequencies that other players are connected to will be shown on the main page.
config.showPlayerAmount = true  -- When this setting is true, the number of connected players will be displayed on the main page and in the radio (channels with a password will show a dash). If false, the player count will not be displayed
config.disableShowUsersInRadio = {
    hud = false,                -- When true, the top-left HUD only shows speaking players (the show-all-users toggle is removed)
    radio = false,              -- When true, the main radio UI only shows the connected user count instead of the player list
}
config.passwordEnable = true    -- Players can set passwords on channels when true
config.canOpenWhenArmed = true -- When set to true, the player can use the radio item while holding a weapon
config.maxNameLength = 20       -- Maximum length of player names shown in the radio UI
config.maxPrefixLength = 10     -- Maximum length of the prefix that players can set for themselves in the radio UI
config.maxConnectedChannels = 9 -- Maximum number of channels a player can be connected to at the same time

-- If you are using Pazee's radio animations, this setting should be true
config.pazeeeRadioAnimations = GetResourceState("Pazeee_NewRadioEmotes") ~= "missing"

config.volumeOutput = { -- The intensity of the sound level of the radio speakers relative to the left and right
    left = 1.0,         -- max 1.0, min 0.0
    right = 1.0         -- max 1.0, min 0.0
}

config.volumeLimits = {
    min = 10,  -- Minimum volume level
    max = 100, -- Maximum volume level
    step = 5   -- Volume adjustment step
}

config.key = {
    active = true, -- Open on the radio menu when the key is pressed when true (When config.items.active is true, it also controls the item when the key is pressed)
    key = "="
}

-- Default radio talk key
config.defaultRadioKey = "CAPITAL"

config.connectedRadioHud = {
    active = true, -- When set to true, connected radios can be managed while the button is held down.
    key = "RMENU", -- Key to show/hide the connected radio HUD
}

config.closeKeys = { "Escape" }
if config.key.active then
    config.closeKeys[#config.closeKeys + 1] = config.key.key
end

config.hudLocations = {
    radio = {
        right = "2vh"
    },
    list = {
        x = "15vh",
        y = "2vh"
    }
}

config.items = {
    active = true, -- When true, the item system is activated
    -- One entry per radio item. "name" is the item name in your inventory.
    items = {
        {
            name = "radio", -- Item name
            -- Job names | Table or nil | jobs = { ["police"] = true, ["ambulance"] = true }, | jobs = { ["police"] = { 2, 3, 5 }, "ambulance" }, -- Example with grade
            jobs = {},
            -- Discord perm id | Table or nil | discord = { "1294775830572040282", "3244275130272040282" }
            discord = {},
            -- Ace perm name | Table or nil | acePerms = { "admin", "god" } -- https://forum.cfx.re/t/basic-aces-principals-overview-guide/90917
            acePerms = {},
            -- Default Channel List | Table |  defaultChannels = { "PD1", "PD2", "EMS5" }
            defaultChannels = {},
            -- Distance effect of this item | Table or nil | nil = config.radioDistanceEffect.radioDistance is used
            -- When the speaker and the listener use different items, the item with the shorter range wins.
            distance = nil,
        },
        {
            name = "pd_radio",
            jobs = { ["police"] = true },
            defaultChannels = {
                "PD1", "PD2", "PD3", "PD4", "PD5", "EMS5", "a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "l"
            }
        },
        {
            name = "mhs_radio",
            jobs = { ["ambulance"] = { 2, 3, 5 }, ["ambulance2"] = true }, -- Example with grade
            defaultChannels = {
                "EMS1", "EMS2", "EMS3", "EMS4", "EMS5", "PD5"
            }
        },
        {
            name = "short_radio", -- Cheap civilian radio: clear up to 500 m, heavily distorted and quieter beyond
            jobs = {},
            discord = {},
            acePerms = {},
            defaultChannels = {},
            distance = {
                -- Same format as config.radioDistanceEffect.radioDistance, effect names from config.radioDistanceEffect.effects
                steps = {
                    { dist = 500, effect = "radioDefault" }, -- Under 500
                },
                -- Beyond the last step | volume = multiplier on the channel volume (0-1)
                outOfRange = { effect = "radioBroken", volume = 0.5 },
            },
        },
    }
}

config.restrictChannel = {
    active = true, -- if true, restrict channels will be active
    channels = {
        -- Values are the same as in item config (jobs, acePerms, discord).
        -- Values like [1], [2], [3] are the number of the frequency. (When you connect to frequencies like 1.21, 1.43, 1.52, the config value for [1] is checked.)
        -- disablePlayerAmount: true does not show the number of players connected to the channel
        [1] = { acePerms = { "group.police" }, disablePlayerAmount = true },
        [2] = { jobs = { ["police"] = { 3, 4, 5 }, ["leo"] = true, }, acePerms = { "group.ambulance" }, disablePlayerAmount = true },
        [3] = { jobs = { ["police"] = true, ["ambulance"] = true }, acePerms = { "group.police", "group.ambulance" }, disablePlayerAmount = true },
        [4] = { discord = { '6408948030806425710', '240864823081642572' }, disablePlayerAmount = true },
        [5] = { jobs = { ["police"] = true, ["ambulance"] = true }, disablePlayerAmount = true },
        ["pd-0"] = { jobs = { ["police"] = true, ["ambulance"] = true }, disablePlayerAmount = true },
    }
}

-- you can use the animations you added to the animation list in config.animations
config.animationList = {
    ui = {
        anim = {
            dict = "cellphone@",
            name = "cellphone_text_read_base",
            blendInSpeed = 0.0,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
        prop = {
            active = true, -- When true, the walkie talkie prop will be active
            hash = `prop_cs_hand_radio`,
            bone = 57005,
            placement = { 0.14, 0.01, -0.02, 110.0, 120.0, -15.0 },
        }
    },
    talkNormal = {
        anim = {
            dict = "random@arrests",
            name = "generic_radio_enter",
            blendInSpeed = 3.0,
            blendOutSpeed = 3.0,
            startPhase = 1.0
        },
    },
    talkWithProp = {
        anim = {
            dict = "anim@radio_pose_3",
            name = "radio_holding_gun",
        },
        prop = {
            active = true, -- When true, the walkie talkie prop will be active
            hash = `prop_cs_hand_radio`,
            bone = 60309,
            placement = { 0.0750, 0.0470, 0.0110, -97.9442, 3.7058, -23.2367 },
        }
    },
    --- Pazeee
    pazeee_talk_normal = {
        anim = {
            dict = "pazeee@radioa@animations",
            name = "pazeee@radioa@clip",
            blendInSpeed = 2.5,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
        prop = {
            active = true,
            hash = `prop_cs_hand_radio`,
            bone = 57005,
            rotationOrder = 1,
            placement = {
                0.160,
                0.060,
                -0.010,
                -119.52,
                -157.824,
                46.041
            },
        }
    },
    pazeee_talk_weapon_pistols = {
        anim = {
            dict = "pazeee@radiof@animations",
            name = "pazeee@radiof@clip",
            blendInSpeed = 2.5,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
        prop = {
            active = true,
            hash = `prop_cs_hand_radio`,
            bone = 18905,
            rotationOrder = 1,
            placement = { 0.154, 0.067, 0.010, -120.8, -33.752, -32.259, },
        }
    },
    pazeee_talk_weapon_others = {
        anim = {
            dict = "pazeee@radiob@animations",
            name = "pazeee@radiob@clip",
            blendInSpeed = 2.5,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
        prop = {
            active = true,
            hash = `prop_cs_hand_radio`,
            bone = 18905,
            rotationOrder = 1,
            placement = { 0.141, 0.066, 0.0110, -120.8, -33.752, -32.259 },
        }
    },
    pazeee_talk_clothe_shoulder = {
        anim = {
            dict = "pazeee@radiog@animations",
            name = "pazeee@radiog@clip",
            blendInSpeed = 2.5,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
    },
    pazeee_talk_clothe_ear = {
        anim = {
            dict = "pazeee@radiom@animations",
            name = "pazeee@radiom@clip",
            blendInSpeed = 2.5,
            blendOutSpeed = 2.5,
            startPhase = 0.0
        },
    },
}

config.animations = {
    openUi = { -- When the radio menu is opened, the animation that will be played on the player
        anim = config.animationList.ui.anim,
        prop = config.animationList.ui.prop
    },
    talk = {
        active = true, -- When true, the talk animation will be active
        anim = config.animationList.talkNormal.anim,
        prop = config.animationList.talkNormal.prop
    },
    talkClothe = {
        active = false, -- When true, the talk animation changes according to the your clothe (config.animation.talk is played if the player's clothes do not match config)
        clothes = {
            {
                drawable = 9,         -- https://docs.fivem.net/natives/?_0x67F3780DD425D4FC (drawable list)
                male = { 1, 2, 4 },   -- male variations id (clothe number)
                female = { 1, 2, 4 }, -- female variations id (clothe number)
                anim = config.animationList.talkWithProp.anim,
                prop = config.animationList.talkWithProp.prop
            },
            {
                drawable = 9,
                male = { 5, 6, 7 },   -- male variations id (clothe number)
                female = { 5, 6, 7 }, -- female variations id (clothe number)
                anim = config.animationList.ui.anim,
                prop = config.animationList.ui.prop
            },
        }
    },
    talkWeapon = {
        active = true, -- When true, the talk animation will be active when the player is holding a weapon
        weapons = {
            {
                groups = { 416676503 }, -- https://docs.fivem.net/natives/?_0xC3287EE3050FB74C (weapon groups)
                anim = config.animationList.talkWithProp.anim,
                prop = config.animationList.talkWithProp.prop
            }
        }
    }
}

config.micClickState = true -- If true, all players will have mic click sound on by default
config.micClickCommand = {
    active = true,          -- Activate command to turn micclick sound off and on
    name = "micclick"       -- Command name
}

config.micClickSyncState = true -- If true, other players will hear the mic click sounds when a player starts/stops talking, otherwise only the local player will hear the mic click sounds
config.micClickSyncCommand = {
    active = true,              -- Activate command to turn micclick sync off and on
    name = "micclicksync"       -- Command name
}

config.radioDistanceEffect = {
    active = false,
    effects = {
        {
            name = "radioDefault",
            effects = {
                [`freq_low`] = 389.0,
                [`freq_hi`] = 3248.0,
                [`rm_mod_freq`] = 0.0,
                [`rm_mix`] = 0.16,
                [`fudge`] = 0.0,
                [`o_freq_lo`] = 348.0,
                [`o_freq_hi`] = 4900.0,
            }
        },
        {
            name = "radioMid",
            effects = {
                [`freq_low`] = 389.0,
                [`freq_hi`] = 1748.0,
                [`rm_mod_freq`] = 90.0,
                [`rm_mix`] = 0.25,
                [`fudge`] = 0.0,
                [`o_freq_lo`] = 348.0,
                [`o_freq_hi`] = 4900.0,
            }
        },
        {
            name = "radioFar",
            effects = {
                [`freq_low`] = 389.0,
                [`freq_hi`] = 1048.0,
                [`rm_mod_freq`] = 125.0,
                [`rm_mix`] = 0.5,
                [`fudge`] = 0.0,
                [`o_freq_lo`] = 348.0,
                [`o_freq_hi`] = 4900.0,
            }
        },
        {
            name = "radioBroken", -- Out of range: narrow band and strong ring modulation
            effects = {
                [`freq_low`] = 600.0,
                [`freq_hi`] = 900.0,
                [`rm_mod_freq`] = 250.0,
                [`rm_mix`] = 0.85,
                [`fudge`] = 0.5,
                [`o_freq_lo`] = 348.0,
                [`o_freq_hi`] = 4900.0,
            }
        },
    },
    -- Default distance steps, used by every item without its own "distance" table. volume (optional) = multiplier on the channel volume (0-1)
    radioDistance = {                             -- Max dist 9k
        { dist = 2000, effect = "radioDefault" }, -- Under 2000
        { dist = 5000, effect = "radioMid" },     -- Under 5000
        { dist = 6500, effect = "radioFar" },     -- Under or above 6500
    },
    -- Beyond the last radioDistance step | Table or nil | nil = the last step stays active. Example: { effect = "radioBroken", volume = 0.5 }
    outOfRange = nil,
    -- Frequencies that will not have distance effect
    ignoredChannels = {
        "15"
    }
}

config.commands = {
    join = {
        active = true,
        command = "r",            -- Command Name
        desc = "commandJoinDesc", -- U can change from lang file
        args = { { name = "frequency", help = "frequency" } }
    },
    leave = {
        active = true,
        command = "rl",           -- Command Name
        desc = "commandLeaveDesc" -- U can change from lang file
    },
    adminJoin = {
        active = true,
        command = "radmin",            -- Command Name
        desc = "commandAdminJoinDesc", -- U can change from lang file
        args = { { name = "frequency", help = "frequency" } },
        perms = config.tgiannServer and { "tgi" } or config.framework == "qb" and "god" or "admin"
    },
    adminRadioList = {
        active = true,
        command = "rlistadmin",             -- Command Name
        desc = "commandAdminRadioListDesc", -- U can change from lang file
        perms = config.tgiannServer and { "tgi" } or config.framework == "qb" and "god" or "admin"
    }
}

config.tgiannGps = GetResourceState("tgiann-gps") ~= "missing" -- If you are using tgiann-gps, this setting should be true
config.defaultVolume = 50                                      -- Default talking sound
config.leaveRadioWhenDie = true                                -- When true, automatically disconnects from all radios when the player dies
config.uiPlayerColorList = { "#CC4545", "#9D5329", "#CCAE45", "#80CC45", "#2C8158", "#49AD95", "#457BCC", "#7845CC", "#9145CC", "#CC45BE", "#CC4565", "#6A1414", "#E8E8E8", }

if config.pazeeeRadioAnimations then
    config.animations.talk.active = true
    config.animations.talk.anim = config.animationList.pazeee_talk_normal.anim
    config.animations.talk.prop = config.animationList.pazeee_talk_normal.prop

    config.animations.talkWeapon.active = true
    config.animations.talkWeapon.weapons = {
        {
            groups = { 3539449195, -755518101, 416676503, 416676503, 690389602, 690389602 },
            anim = config.animationList.pazeee_talk_weapon_pistols.anim,
            prop = config.animationList.pazeee_talk_weapon_pistols.prop
        },
        {
            groups = {
                4257178988, -37788308, 2725924767, -1569042529, 3566412244, -728555052,
                1159398588, 1159398588, 1595662460, 1595662460, 970310034, 970310034,
                860033945, 860033945, 3337201093, -957766203, 3082541095, -1212426201,
                1548507267, 1548507267
            },
            anim = config.animationList.pazeee_talk_weapon_others.anim,
            prop = config.animationList.pazeee_talk_weapon_others.prop
        }
    }

    config.animations.talkClothe.active = true
    config.animations.talkClothe.clothes = {
        -- shoulder radio
        {
            drawable = 8,         -- https://docs.fivem.net/natives/?_0x67F3780DD425D4FC (drawable list)
            male = { 58, 153 },   -- male variations id (clothe number)
            female = { 35, 189 }, -- female variations id (clothe number)
            anim = config.animationList.pazeee_talk_clothe_shoulder.anim,
        },
        -- ear radio
        {
            drawable = 2,         -- https://docs.fivem.net/natives/?_0x67F3780DD425D4FC (drawable list)
            isDrawableProp = true,
            male = { 0, 1, 2 },   -- male variations id (clothe number)
            female = { 0, 1, 2 }, -- female variations id (clothe number)
            anim = config.animationList.pazeee_talk_clothe_ear.anim,
        }
    }
end

config.langs = {}
