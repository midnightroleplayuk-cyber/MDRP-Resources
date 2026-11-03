Config = {
    -- Global settings for all scripts
    -- Dont forget to uncomment the imports in fxmanifest.lua if you are using vrp!
    framework = "auto", -- auto, esx, qb, qbox, vrp, custom - can be customized in config/framework
    garage = "auto", -- auto, custom, esx, qb, qbox, msk, codem, quasar, okok, jg, cd, bp, my, vms, op, hex, ws, ak47, rx, zyke_garages, ds-servercreator - can be customized in config/integration/garage
    -- Progress adapters live in config/integration/progress.
    -- Additional progress providers: codem-supreme-hud, aty_uikitv2, 17mov_Hud, ZSX_UIV2, risk-notify, lation_ui, prism_uipack, frkn-uikit, msk_core.
    progressbar = "auto", -- auto, custom, esx, ox, qb, mythic, hex, jaksam, wasabi, or an additional provider above.
    -- Notification providers (case-sensitive; config/integration/notification):
    -- default, auto, custom, 17mov_Hud, aty_ui, aty_uikitv2, brutal_notify, codem-notification,
    -- codem-supreme-notification, core_notify, cp_notify, cs_hud, esx, esx_notify, frkn-uikit, hex_1_hud, hex_2_hud,
    -- hex_4_hud, hex_final_hud, hex_finalhud_v2, hex_future_hud, hex_genesis_hud, hex_hud_prem, lation_ui, msk_core,
    -- mythic_notify, okokNotify, ox_lib, prims_hud, prism_uipack, qb, qbox, qs-interface, risk-notify, rtx_notify,
    -- RxNotify, sky_hud, sky_notify, Venice-Notification, vms_notifyv2, wasabi_notify, wasabi_uikit, zenit_hud,
    -- ZSX_UIV2, ZSX_UIV2_default (above-minimap notifications).
    notification = "default", -- default: Sky NUI; auto: startup detection; custom: edit custom.lua.
    notificationPosition = "middle-left", -- Sky NUI only: top-left, top-center, top-right, middle-left, middle-right, bottom-left, bottom-center, bottom-right.
    -- Help notification providers (case-sensitive; config/integration/helpnotify):
    -- default, auto, custom, 17mov_Hud, aty_ui, brutal_textui, codem-supreme-hud, codem-textui, esx, esx_textui,
    -- hex_1_hud, hex_2_hud, hex_4_hud, hex_final_hud, hex_finalhud_v2, hex_future_hud, hex_genesis_hud, hex_hud_prem,
    -- jg-textui, lation_ui, msk_core, okokTextUI, ox_lib, prims_hud, qb, qbox, qs-textui, risk-notify, sky_hud,
    -- wasabi_uikit, zenit_hud, ZSX_UIV2 (TextUI), ZSX_UIV2_help (top-left help).
    helpnotify = "default", -- default: Sky NUI; auto: startup detection; custom: edit custom.lua.
    sql = "auto", -- auto, oxmysql or mysql-async
    locale = "en", -- locale file to use from config/locales/
    phone = "auto", -- auto, none (phone integration disabled), custom, sky, esx, qb, npwd, qs, d, gks, lb, lb-unique, yseries, codem, okok, roadphone, sd, 17mov
    tablet = "default", -- default (sky_jobs_base tablet), auto, sd, lb, roadpad
    voice = "auto", -- auto, none, pma, saltychat, yaca - unified radio bridge
    voiceRadioSounds = {
        enabled = false, -- provider-native clicks for PMA Voice and SaltyChat; keep disabled when a radio UI provides its own sounds
        transmitStartVolume = 18, -- PMA Voice click-on volume, 1-100
        transmitEndVolume = 8, -- PMA Voice click-off volume, 1-100
    },
    license = "auto", -- standalone, auto, custom, esx, qb, qbox, cs, ak47, codem, quasar, papa, bit, vms, stg-walletv2 - can be customized in config/integration/license
    billing = "sky", -- Sky Billing in sky_jobs_base (default). External: auto, custom, apex, retro (no creation API), lore, hex, esx, codem, codemv2, okok, jacksam, quasar, vms, rxbilling, wasabi, corem, fd, groot, tgg, vivum, synz, companymanager, nass_billing.
    vehiclekeys = "auto", -- auto, none (no external key system), custom, qb, vehicles_keys, mrnewb, mk, quasar, wasabi, msk, brutal, kiminaze, ak47, jota, tgiann - can be customized in config/integration/vehiclekeys
    fuel = "auto", -- auto, custom, msk, lc, cdn, ox, qb, legacy, rcore, hex, myFuel, okokGasStation, qs-fuelstation, stg-van, xfuel, native - can be customized in config/integration/fuel
    weather = "auto", -- auto, native, esx_weather, Renewed-Weathersync, weathersync, qb-weathersync, cd_easytime, custom; adapters in config/integration/weather
    medical = "auto", -- auto, none, visn_are, custom; external injury-buffer reset after the owning resource revives a player.
    inventory = "auto", -- auto, custom, esx, qb, qb-inv, qbox, vrp, ox, qs, ps, codem, codemv2, tgiann, jaksam, ak47, one, core, origen, jpr, hex - can be customized in config/integration/inventory
    -- Society banking is independent of the billing provider. Select the owner of the society funds:
    -- "esx": ESX shared accounts via esx_addonaccount (e.g. okok uses UseAddonAccount = true
    --        or SocietyResource = "esx_addonaccount").
    -- "okok": okokBanking's own society accounts (e.g. UseAddonAccount = false
    --         or SocietyResource = "okokBanking").
    -- The job's society account must already exist in the selected provider.
    -- billing = "okok" selects okokBilling; it does not require banking = "okok".
    -- "auto" detects running resources, not okok's private account mode. Select banking explicitly for these setups.
    banking = "auto", -- auto, custom, sky, apex, oxlyn, retro, devmosaic, crm, codem, codem-supreme-banking, qs, okok, bablo, fd, rx, tgg, kartik, esx, qb, renewed, pc, wasabi, groot, ak47, jaksam, hex, synz - can be customized in config/integration/banking
    useSkyBankingFallback = false, -- Uses sky_base's own DB-backed job accounts when the selected banking resource fails. Set banking = "sky" to force it.
    useMph = false, -- use mph or kmh for speed
    debug = false, -- legacy master switch: true enables every log level
    debugLevels = {
        all = false, -- enable every level without changing the legacy debug switch
        debug = false,
        info = true,
        warn = true,
        error = true,
    },
    debugQueue = {
        maxEntries = 1000, -- bounded queue; warn/error entries replace older logs when full
        batchSize = 10, -- maximum console writes before the logger schedules another batch
        batchDelay = 0, -- delay in ms before each scheduled batch; 0 means the next scheduler tick
    },

    defaultCallbackTimeout = 300000, -- wait limit in both directions in ms (5 minutes); does not cancel remote work
    hideCallbackEventNames = true, -- false: append callback keys to network event names for diagnostics; restart the server after changing
    callbackPerformance = {
        enabled = true, -- store callback execution and round-trip statistics for the current resource session
        warningsEnabled = false, -- opt in to automatic slow-handler warnings; statistics and real errors remain available
        warningThreshold = 500, -- slow-handler threshold in ms for statistics and optional warnings; includes awaited work
        warningCooldown = 300000, -- minimum ms between warnings for the same callback name (5 minutes)
    },
    interactionDistance = 2.0, -- default distance from where you can interact with a marker / npc / target zone
    interactionDrawBuffer = 20.0, -- extra range beyond interactionDistance where markers are drawn and tracked
    streamNpcEnabled = true, -- only spawn interaction-point NPC peds while the player is within streamNpcDistance (set false for legacy: peds exist everywhere at once)
    streamNpcDistance = 100.0, -- default range (in game units) a player must be within for an interaction NPC ped to exist; despawns past streamNpcDistance + 20%
    streamNpcRefreshMs = 1000, -- how often (ms) the streaming pass re-evaluates ped distances when no point is in interaction range
    streamNpcMaxSpawnsPerPass = 4, -- max number of streamed interaction NPCs to spawn in one streaming pass; higher values reduce visible spawn delay for groups
    defaultMarkerSize = 1.2, -- default marker scale when marker.scaleX / marker.scaleY / markerSize is not set
    defaultBlipSize = 0.8,
    defaultMarkerColor = {
        red = 0,
        green = 255,
        blue = 255,
    },
    target = "none", -- none (marker + help notification), custom, ox, qb, tgiann, vivum, auto - can be customized in config/integration/target. "auto" picks a started target resource and replaces the normal marker interaction, only opt-in.
    showMarkersWithTarget = true, -- keep drawing configured interaction markers when target is enabled
    useStreamerMode = false, -- enable streamer mode
    maxPing = 5000, -- max ping allowed for events
}

Config.Licenses = {
    -- Additional license types exposed by the single provider selected above.
    -- Use identifiers understood by that provider. The standalone provider
    -- stores every listed type in sky_base_licenses.
    -- CodeStudio (cs): use the license template's inventory item name; create
    -- that template/item in cs_license first. Job badges use the job name.
    catalog = {
        { type = "firstaidcourse", label = "First Aid Course" },
    },
    papaGiveItem = false, -- papa_licensecreator: also give the physical license item when granting access.
}

-- Blacklist for words you dont want to be used on your server
Config.Blacklist = {
    "<",
    ">",
    "script",
    "iframe",
    "&#8203;",
    "&#x27;",
    "null",
    "undefined",
    "nega",
    "hurensohn",
    "nigga",
    "adolf",
    "hitler",
    "neger",
}
