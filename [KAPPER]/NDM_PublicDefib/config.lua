Config = {}

Config.Debug = false

---------------------------------------------------------------------------
-- When the cabinets unlock
---------------------------------------------------------------------------
-- Cabinets only open when fewer than MinOnDuty medics are on duty (same rule as GoodCiv alerts).
-- The count comes from GoodCiv (exports.NDM_GoodCiv:GetOnDutyMedicCount) when it's running,
-- otherwise from qbx_core duty counts for Config.Availability.Jobs.
Config.Availability = {
    OnlyWhenNoMedics = true,
    MinOnDuty = 1,                    -- 1 = only when no medics at all
    GoodCivResource = 'NDM_GoodCiv',
    Jobs = { 'ambulance' },           -- fallback when GoodCiv isn't running
}

---------------------------------------------------------------------------
-- Cabinets
---------------------------------------------------------------------------
-- Easiest: place cabinets in game with /defibplace (admins). Aim at a wall, adjust the height,
-- press E and name it. They're saved on the server and show up for everyone straight away.
-- Manage them with /defibcabinets (teleport / reset / remove).
--
-- Cabinets can also be listed here: coords = where you stand facing the wall (/defibpos copies it).
-- prop = model for that cabinet, propCoords = exact model position + heading (optional).
Config.Cabinets = {
    { label = 'Burton Hospital entrance', coords = vector4(-303.5, -152.2, 40.24, 70.0) },
    -- { label = 'Legion Square', coords = vector4(...) },
}

Config.CabinetProp = 'uk_aed_cabinet'         -- e.g. `prop_ld_health_pack`; per cabinet: prop = `model`
-- Cabinet prop position from coords (where you stand, facing the wall):
--   forward = metres in front of you to the wall, up = bottom edge of the cabinet vs. your coords
-- Per cabinet you can instead set propCoords = vector4(...) for the exact prop position + heading.
Config.CabinetPropOffset = { forward = 0.6, up = 0.0 }
Config.HandProp = {               -- what you carry
    model = `prop_ld_health_pack`,
    bone = 57005,
    offset = vector3(0.13, 0.0, -0.08),
    rotation = vector3(-90.0, 0.0, 90.0),
}

Config.Blip = { sprite = 153, colour = 2, scale = 0.6, label = 'Public defibrillator' } -- nil = no blips

Config.TakeDistance = 2.0         -- metres from the cabinet to take / return / restock

---------------------------------------------------------------------------
-- Carrying (the defib is tracked by the server, it's not an inventory item)
---------------------------------------------------------------------------
Config.Carry = {
    WarnDistance = 150.0,         -- warn the carrier past this distance from its cabinet
    MaxDistance = 250.0,          -- defib is lost (cabinet needs restocking) past this
    MaxTime = 600,                -- seconds before it's lost if not returned
    PlayerCooldown = 300,         -- seconds before the same player can take another one
}

---------------------------------------------------------------------------
-- Using it
---------------------------------------------------------------------------
Config.Use = {
    Distance = 2.5,               -- user must be this close to the patient
    AttachTime = 5,               -- seconds: putting the pads on
    AnalyseTime = 6,              -- seconds: AED analysing
    ShockTime = 2,                -- seconds: stand clear + shock
    ReanalyseAfter = 30,          -- seconds of CPR before it will analyse again

    -- Analysis. A real shockable rhythm in osp_ambulance (VF / VT / torsades / after medic CPR)
    -- is always "shock advised". A patient in cardiac arrest (osp dead / asystole) gets
    -- ShockableChance, multiplied by ShockableDecay for every analysis after the first.
    ShockableChance = 0.6,
    ShockableDecay = 0.6,
    -- Patients in last stand (still breathing) only get a shock if osp says the rhythm is shockable.

    -- Chance a shock brings the patient round
    SuccessChance = 0.35,
    OspShockableBonus = 0.25,     -- added when osp itself has the patient in a shockable rhythm
    MaxShocks = 3,                -- per patient per pad session

    OspLog = true,                -- write AED events to the patient's osp message log
}

-- Runs on the server when a shock works. Same "brought round but still injured" revive GoodCiv uses.
Config.Revive = function(patient)
    TriggerClientEvent('osp_ambulance:partialRevive', patient, true)
end

---------------------------------------------------------------------------
-- Restocking (medical service)
---------------------------------------------------------------------------
-- A cabinet needs restocking after its defib was used (a shock was given) or lost.
Config.Restock = {
    AfterUse = true,
    Jobs = { ambulance = 0 },     -- job = minimum grade
    RequireOnDuty = true,
    Time = 6,                     -- seconds
    AutoMinutes = 60,             -- restocks itself after this long (0 = only by medics)
    Reward = 0,                   -- cash to the medic per restock (0 = none)
}

---------------------------------------------------------------------------
-- Discord logs (webhook URL goes in server/webhooks.lua, never here)
---------------------------------------------------------------------------
Config.Logs = {
    Enabled = true,
    Username = 'Public Defib Logs',
}

Config.AdminAce = 'publicdefib.admin'   -- /defibplace, /defibcabinets, /defibpos, /defibreset
