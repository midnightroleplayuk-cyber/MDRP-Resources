Config = {}

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'ox' -- 'esx' | 'qb' | 'ox' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.DebugMode = false -- false | true

Config.Inventory = 'ox' -- 'default' | 'ox' | 'qs'
Config.Target = 'ox' -- 'none' | 'ox' | 'qb'
Config.Use3DTextForEvidence = true -- false | true, should 3d text and marker be used for evidence even tho target is used
Config.UseOxLib = true -- false | true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true
Config.UseMDT = true -- false | true, set to true if you have tk_mdt and want evidence to be automatically registered in it when putting in evidence locker (make sure you have latest version of tk_mdt!)

Config.UISettings = {
    color = 'purple', -- https://v6.mantine.dev/theming/colors/
    shade = 6, -- 1-9
}
Config.DateFormat = {year = 'numeric', month = '2-digit', day = '2-digit', hour = '2-digit', minute = '2-digit' } -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleString#options
Config.Use3DViewer = true

Config.Controls = {
    interact = 38, -- E
    remove = 246, -- Y
}

Config.Anims = {
    collect = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    },
    remove = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    },
}

Config.Dist = {
    analyze = 2.0,
    evidence = {
        see = 10.0,
        interact = 2.0,
    },
    reconstruction = 20.0,
}

Config.PoliceJobs = {
    police = 0, -- job name, minimum grade required
    sheriff = 0,
}

Config.EnableEvidence = true
Config.EnableGSR = true
Config.EnableVehFingerprints = true
Config.UseFingerprintSystem = false -- false | true, if set to true police will first need to use a fingerprint scanner to get player fingerprints and only after that they can see player name from DNA

Config.Items = {
    gsrTest = 'gsr_test_kit',
    gsrCloth = 'gsr_cloth',
    uvLight = 'uv_light',
    camera = 'evidence_camera',
    fingerprintScanner = 'fingerprint_scanner',
}

Config.Markers = { -- marker settings for different evidence types
    bullet_casing = {
        type = 27,
        color = {r = 204, g = 150, b = 24, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
    bullet_fragment = {
        type = 27,
        color = {r = 174, g = 124, b = 0, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
    bullet_hole = {
        type = 3,
        color = {r = 24, g = 96, b = 240, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
    fingerprint = {
        type = 3,
        color = {r = 24, g = 96, b = 240, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
    blood_sample = {
        type = 27,
        color = {r = 150, g = 0, b = 0, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
    evidence = {
        type = 3,
        color = {r = 24, g = 96, b = 240, a = 200},
        scale = vec3(0.15, 0.15, 0.15),
        faceCamera = true,
        bob = false,
    },
}

Config.WeaponsNoShells = { -- Weapons that shouldn't drop shells
    --[`WEAPON_STUNGUN`] = true,
}
Config.WeaponsNoGSR = { -- Weapons that won't leave a GSR
    [`WEAPON_STUNGUN`] = true,
}
Config.WeaponsNoFragments = { -- Weapons that won't leave bullet fragments
    [`WEAPON_STUNGUN`] = true,
}
Config.WeaponsNoHoles = { -- Weapons that won't leave bullet holes
    [`WEAPON_STUNGUN`] = true,
}

Config.WeaponToSeeEvidence = 'WEAPON_FLASHLIGHT' -- Weapon needed to see evidence on ground, leave to blank if you want players to always see evidence on ground
Config.ShellRandomness = true -- Should shell coords have a small random offset

Config.ShootingWait = 500 -- How many milliseconds to wait before checking again if player is shooting, bigger = better performance
Config.UpdateEvidenceTime = 1000 * 60 * 10 -- How often should server check whether an evidence should be deleted, bigger = better performance (last number = time in minues)
Config.UpdateGSRTime = 1000 * 60 * 5 -- How often should server check whether a gsr should be deleted, bigger = better performance (last number = time in minues)

Config.AnalyzeCoords = { -- Coords where you can analyze evidence
   vec3(458.68, -974.3, 23.92),
}

Config.GSR = {
    removeInWater = true, -- Should gsr be removed when player goes into water (true / false)
    cleanTime = 15, -- How long should it take to remove gsr when in water (in seconds)
    disappearTime = 60 * 60, -- How long should it take for GSR to disappear from hands (last number = time in minutes)
    recentTime = 60 * 10, -- Time for the GSR test to show that the GSR is recent (last number = time in minutes)
    testDuration = 5000, -- How long should it take to do a GSR test (in milliseconds)
    clothDuration = 5000, -- How long should it take to use a GSR cloth (in milliseconds)
    needJob = true, -- Do you need a job to use the GSR test kit (true / false)
    useCloth = true, -- Use GSR cloth item (allows players to take off GSR by using this item)
    saveToDatabase = true, -- Should GSR be saved to database (true / false)
}

Config.SerialChance = { -- chance for player weapon serial number to be shown when evidence analyzed (percentage), only evidence listed here will have a chance for serial number to be shown (only works with ox_inventory)
    bullet_casing = 100,
    --bullet_fragment = 10,
}

Config.NameChance = { -- chance for player name to be shown when evidence analyzed (percentage), only evidence listed here will have a chance for name to be shown
    blood_sample = 100,
    bullet_casing = 50,
    fingerprint = 100,
    --bullet_fragment = 50,
}

Config.GlovesAffect = { -- should gloves affect the chance of fingerprints being left in certain evidence
    bullet_casing = true,
    bullet_fragment = true,
    fingerprint = true,
}

Config.DuplicateDistance = { -- distance to check for duplicate evidence before spawning new one
    bullet_fragment = 0.2,
    bullet_casing = 0.2,
    bullet_hole = 0.2,
    blood_sample = 0.2,
}

Config.Disappear = { -- how long for different evidence types to disappear
    bullet_casing = 60 * 360,  -- (last number = time in minutes)
    bullet_fragment = 60 * 360,
    bullet_hole = 60 * 360,
    fingerprint = 60 * 360,
    blood_sample = 60 * 360,
    evidence = 60 * 360,
    vehicle_fingerprint = 1000 * 60 * 120
}