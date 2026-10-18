--[[
    Apex Handling Studio: Configuration
    ────────────────────────────────────────────────────────────
    Everything an installer is expected to touch lives here.
    The resource is plug-and-play: drop it in resources/, add
    `ensure apex_handling` to server.cfg and you are done.
]]

Config = {}

-- ─── Language ───────────────────────────────────────────────
-- Ships with: en (English), pt (Português), es (Español),
--             fr (Français), de (Deutsch), it (Italiano)
--
-- This one setting drives EVERYTHING: chat/framework notifications,
-- the whole studio interface and the tutorial. Each language lives in
-- a single file under locales/.
--
-- To add your own: copy locales/en.lua, translate the values, rename
-- the table (Locales.xx) and set Config.locale = 'xx'. Anything you
-- leave untranslated falls back to English key by key, so a partial
-- file is safe to ship, and an unknown code here simply means English.
Config.locale = 'en'

-- ─── Opening the studio ─────────────────────────────────────
Config.command        = 'handling'       -- /handling toggles the studio
Config.timingCommand  = 'handlingtiming' -- standalone timing overlay (no editor)
Config.keybind        = ''               -- e.g. 'F7': empty = command only
-- The studio always requires a vehicle (it edits the car you are in);
-- only the driver-seat requirement is configurable.
Config.mustBeDriver    = true            -- require the driver seat

-- ─── Access control ─────────────────────────────────────────
-- A player gets FULL access when ANY of these matches:
--   · the ace permission below
--   · a framework group listed in fullGroups
--   · a job name listed in fullJobs
-- A player gets SIMPLE-ONLY access (simplified editor, no file
-- writes, no flags) when their job is in simpleJobs: perfect
-- for mechanics who should fix cars, not rewrite the server.
--
-- GRANTING THE ACE PERMISSION, per framework. The prefix differs:
--   ESX / QBox / txAdmin / manual:
--       add_ace group.admin apex.handling allow
--   QBCore (its admins live under the qbcore.* principal tree):
--       add_ace qbcore.admin apex.handling allow
--       add_ace qbcore.god   apex.handling allow
--
-- fullGroups is matched against BOTH ace trees and the framework's own
-- permission store, so listing a group name here is usually enough on
-- its own. 'owner'/'admin' are the ESX Legacy defaults; 'god'/'mod' are
-- the QBCore/QBox ones.
Config.access = {
    acePermission = 'apex.handling',
    fullGroups    = { 'owner', 'admin', 'superadmin', 'god', 'mod' },
    fullJobs      = {},                    -- e.g. { 'developer' }
    simpleJobs    = { 'mechanic' },        -- simplified editor only
    everyone      = true,                 -- true = anyone gets FULL access (dev servers)
    everyoneSimple = false,                -- true = anyone gets the SIMPLE editor
}

-- Timing tool standalone access (job-lockable like JG timing).
Config.timing = {
    everyone = true,          -- false = restrict to jobs/aces below
    jobs     = { 'mechanic' },
    useHandlingAccess = true, -- players with studio access always may
}

-- ─── Live sync ──────────────────────────────────────────────
-- Handling applied in the studio is written to the vehicle's
-- statebag so EVERY client simulates the same physics, and the
-- server remembers model overrides so newly spawned vehicles of
-- that model pick the tune up automatically.
Config.sync = {
    statebagKey    = 'apexHandling',
    modelOverrides = true,     -- persist per-model overrides (data/overrides.json)
    reapplyOnSpawn = true,     -- apply model overrides to freshly seen vehicles
}

-- ─── Writing straight into handling.meta files ──────────────
-- The killer feature: the studio locates the resource that ships
-- the vehicle's handling.meta and rewrites the matching
-- <Item type="CHandlingData"> in place (backup kept as
-- handling.meta.apexbak). Restart the vehicle resource (or the
-- server) and the tune is permanent + shareable.
Config.metaWrite = {
    enabled       = true,
    backup        = true,             -- keep handling.meta.apexbak (first write only)
    scanOnBoot    = false,            -- build the meta index at server start (true = slower boot)
    ignoreResources = {               -- never scan/touch these
        'apex_handling',
    },
    -- Extra probe paths tried per resource when a directory scan
    -- is unavailable ({model} is replaced by the model name):
    probePaths = {
        'handling.meta',
        'data/handling.meta',
        'data/{model}/handling.meta',
        '{model}/handling.meta',
        'meta/handling.meta',
        'data/meta/handling.meta',
    },
}

-- ─── Profiles ───────────────────────────────────────────────
Config.profiles = {
    maxPerPlayer = 60,
    maxNameLen   = 48,
}

-- ─── Telemetry ──────────────────────────────────────────────
Config.telemetry = {
    hz         = 12,     -- samples per second streamed to the UI
    gSmoothing = 0.35,   -- 0..1 exponential smoothing on G readings
}

-- ─── Units ──────────────────────────────────────────────────
Config.units = 'kmh'     -- 'kmh' or 'mph' (UI toggle persists per player)

-- ─── Misc ───────────────────────────────────────────────────
Config.debug = false
