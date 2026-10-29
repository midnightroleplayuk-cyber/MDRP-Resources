Config = {}
Config.Language = "en"
Config.Debug = true -- This enables debugging prints.
Config.RenderDistance = 100.0
Config.InteractDistance = 2.0
Config.MusicRadius = 20.0
Config.DebugListen = false -- When false, the broadcaster will not auto-listen to their own stream
Config.UseTarget = true -- This enables the use of the target system when available.
Config.ImageDirectory = "nui://ox_inventory/web/images/"
Config.ImageExtension = "png"
Config.WeaponsAreItems = true -- This enables the use of weapons as items. If set to false, weapons will be treated as items and not as weapons.
Config.Currency = { currency = "USD", countryCode = "en-US" } -- Look up JS currency and countryCode variables for more options. 
Config.AdminGroups = {
    "qbcore.admin",
    "qbcore.god",
    "god",
    "admin",
    "mod",
    "superadmin",
}
Config.TargetIcons = {
    dj = "fas fa-music",
}
Config.FrameworkSettings = {
    dirtyMoney = "DEFAULT",
    usableItemMetadata = function(item, data)
        if type(data) == "table" and data.metadata then return data.metadata end
        if type(item) == "table" and item.metadata then return item.metadata end
        if type(data) == "table" and data.info then return data.info end
        if type(item) == "table" and item.info then return item.info end
        print("^1ERROR: METADATA IS WRONGLY CONFIGURED, CHECK CONFIG.LUA:^0", item, data)
    end
}

Config.DJStations = {
    ["Advanced DJ Deck"] = {
        item = "dj_deck_advanced",
        prop = `sf_prop_sf_dj_desk_01a`,
    },
}

Config.LightingThemes = {
    ["default"] = {
        {r = 255, g = 0, b = 0}, -- Primary color
        {r = 0, g = 255, b = 0}, -- Secondary color
        {r = 0, g = 0, b = 255}, -- Tertiary color
    },
}

Config.SpeakerProps = {
    ["speaker_1"] = {
        item = "dj_speaker_large",
        label = "Large Speaker (100m)",
        model = `h4_prop_battle_club_speaker_large`,
        soundRadius = 100.0,
        soundOffset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
    },
    ["speaker_2"] = {
        item = "dj_speaker_medium",
        label = "Medium Speaker (50m)",
        model = `h4_prop_battle_club_speaker_med`,
        soundRadius = 50.0,
        soundOffset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
    },
    ["speaker_3"] = {
        item = "dj_speaker_small",
        label = "Small Speaker (15m)",
        model = `prop_speaker_08`,
        soundRadius = 15.0,
        soundOffset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
    },
}

Config.LightTypes = {
    ["ambient"] = {
        item = "dj_light_ambient",
        label = "Ambient Light",
        model = `stg_blinder`,
        strobeModel = `stg_strobe_blinder`,
        rotation = vector3(0.0, 0.0, 0.0),
    },
    ["spotlight"] = {
        item = "dj_light_spotlight",
        label = "Spotlight",
        model = `stg_spot_sharpy`,
        strobeModel = `stg_strobe_hdgh`,
        rotation = vector3(0.0, 0.0, 0.0),
    },
    ["barlight"] = {
        item = "dj_light_barlight",
        label = "Bar Light",
        model = `stg_rays_bar12_spr`,
        strobeModel = `stg_rays_strobe12_spr_t2`,
        rotation = vector3(0.0, 0.0, 180.0),
    },
}