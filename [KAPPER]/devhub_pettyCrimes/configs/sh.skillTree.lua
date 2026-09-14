if not Config then Config = {} end

-- ─────────────────────────────────────────────────────────────────────────────
-- SKILL TREE (devhub_skillTree) https://devhub.gg/product/6440792
-- ─────────────────────────────────────────────────────────────────────────────

Config.SkillTreeEnabled = true -- master switch; the script runs fine without the tree

Config.SkillsCategory = {
    skill = 'pettyCrimes',
    title = 'Petty Crimes',
}

-- XP handed to the tree after each committed crime (points come from levelling).
Config.SkillTreeXp = {
    default = 10,
    perActivity = {
        postalBoxTheft    = 8,
        parkingMeterTheft = 8,
        phoneBoothTheft   = 8,
        carRadioTheft     = 12,
        npcPickpocket     = 10,
        npcMugging        = 15,
        porchTheft        = 12,
        smashAndGrab      = 15,
    },
}

-- Hard ceilings on each perk's summed effect (%), so a fully-levelled player can
-- never reach an absurd value (e.g. a zero-length progress bar).
Config.SkillCaps = {
    speed        = 60, -- max % the action time can be shortened by
    autocomplete = 50, -- max % chance the minigame is auto-solved
    lowprofile   = 75, -- max % the police-alert chance is reduced by
}

-- The three perks. Every crime gets a bundle of two of each (tier I + II); the
-- two `tiers` effects are additive. Edit the numbers, text and art freely — %s in
-- a description is replaced with that tier's effect number.
Config.SkillPerks = {
    speed = {
        title = 'Quick Hands',
        desc  = 'You work <strong>%s%% faster</strong> — the progress bar and the setup animation both take less time.',
        icon  = 'fa-solid fa-gauge-high',
        img   = 'https://upload.devhub.gg/dh_upload/pettyCrimes_speed.png',
        tiers = { { effect = 8, points = 1 }, { effect = 12, points = 2 } },
    },
    autocomplete = {
        title = 'Muscle Memory',
        desc  = 'A <strong>%s%% chance</strong> you crack it on instinct — the minigame is solved for you and skipped entirely.',
        icon  = 'fa-solid fa-wand-magic-sparkles',
        img   = 'https://upload.devhub.gg/dh_upload/pettyCrimes_autocomplete.png',
        tiers = { { effect = 4, points = 2 }, { effect = 6, points = 3 } },
    },
    lowprofile = {
        title = 'Low Profile',
        desc  = 'You leave less behind. The chance the police are alerted drops by <strong>%s%%</strong>.',
        icon  = 'fa-solid fa-user-secret',
        img   = 'https://upload.devhub.gg/dh_upload/pettyCrimes_lowprofile.png',
        tiers = { { effect = 12, points = 1 }, { effect = 18, points = 2 } },
    },
}

-- The crimes that get a skill bundle, in the order they appear in the tree.
-- `label` is the caption shown above the bundle. Remove a line to drop that
-- crime's bundle; a crime that is disabled in the /petty editor is dropped
-- automatically regardless.
Config.SkillCrimes = {
    { activity = 'postalBoxTheft',    label = 'Postal Box Theft' },
    { activity = 'parkingMeterTheft', label = 'Parking Meter Theft' },
    { activity = 'phoneBoothTheft',   label = 'Phone Booth Theft' },
    { activity = 'carRadioTheft',     label = 'Car Radio Theft' },
    { activity = 'npcPickpocket',     label = 'Pickpocketing' },
    { activity = 'npcMugging',        label = 'Mugging' },
    { activity = 'porchTheft',        label = 'Porch Theft' },
    { activity = 'smashAndGrab',      label = 'Smash & Grab' },
}
