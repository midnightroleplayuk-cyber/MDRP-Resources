if not Config then Config = {} end

-- ============================================================================
--  FRAMEWORK COMPATIBILITY LAYER  (esx_license / QBCore / Qbox)
-- ============================================================================
-- devhub_licenses can impersonate the classic ESX `esx_license` resource and
-- mirror license state into the QBCore/Qbox `metadata.licences` table, so
-- third-party scripts written against those systems keep working without a
-- single line changed.
--
-- devhub_licenses stays the single source of truth: compatibility state is
-- always DERIVED from devhub licenses and re-asserted after every change and
-- on player login. Changes made by OTHER scripts directly to `user_licenses`
-- or `metadata.licences` are not imported back (see the docs for why).

Config.Compat = {}

-- A license counts as "held" for the compatibility layer when the player is
-- the ORIGINAL owner of an ACTIVE, non-fake license record. Set this to true
-- to ALSO count granted permissions that were never picked up at the clerk
-- (grant = allowed to obtain the license, record = the issued card).
Config.Compat.GrantsCountAsLicenses = false

-- ----------------------------------------------------------------------------
-- esx_license impersonation (ESX servers)
-- ----------------------------------------------------------------------------
-- Re-implements the full esx_license API surface on top of devhub_licenses:
--   * net events:      esx_license:addLicense, esx_license:removeLicense
--   * server events:   esx_license:getLicense, esx_license:getLicenses,
--                      esx_license:checkLicense, esx_license:getLicensesList
--   * ESX callbacks:   esx_license:getLicense / getLicenses / checkLicense /
--                      getLicensesList (registered only when es_extended runs)
-- Works with esx_dmvschool, esx_policejob, esx_weaponshop, ox_inventory's ESX
-- bridge and anything else that talks to esx_license.
--
-- The impersonation auto-disables itself (with a console warning) when a real
-- `esx_license` resource is running — never run both at once.
Config.Compat.EsxLicense = {
    enabled = false,

    -- Left side = what ESX scripts pass, right side = your template.
    typeMap = {
        ["drive"]  = "driving_license",
        ["weapon"] = "weapon_license",
        ["id"]     = "id_card",
        -- ["dmv"]         = "driving_theory",
        -- ["drive_bike"]  = "bike_license",
        -- ["drive_truck"] = "truck_license",
        -- ["boat"]        = "boat_license",
    },

    -- Allow `esx_license:addLicense` triggered DIRECTLY from a client (the
    -- original resource allowed this — it is an exploit vector, cheaters can
    -- self-grant any license). Server-to-server calls (esx_dmvschool,
    -- esx_weaponshop, ...) are always allowed and unaffected by this flag.
    allowClientAddLicense = false,

    -- Jobs allowed to trigger `esx_license:removeLicense` from a client
    -- (esx_policejob revokes licenses this way). Mirrors the original
    -- resource's Config.allowedJobs. Server-to-server calls bypass this.
    removeLicenseJobs = {
        ["police"] = true,
    },

    -- Maintain the classic `licenses` / `user_licenses` SQL tables (created
    -- automatically when missing) so scripts that read them DIRECTLY keep
    -- working — e.g. ox_inventory's ESX bridge run
    -- their own SELECT on user_licenses. Rows are kept in sync with active
    -- devhub licenses; rows of license types unknown to devhub_licenses are
    -- left untouched. Only active on ESX servers.
    sqlMirror = true,
}

-- ----------------------------------------------------------------------------
-- QBCore / Qbox licences metadata mirror
-- ----------------------------------------------------------------------------
-- Keeps `PlayerData.metadata.licences` in sync with devhub licenses so stock
-- consumers (qb-cityhall, qb-policejob, qb-shops, qb-phone, ox_inventory's QB
-- bridge, ...) see the right flags. Keys are re-asserted on every license
-- change AND on player login — this also self-heals the infamous qb-policejob
-- seizure handler that wipes custom keys from the licences table.
--
-- NOTE: this is one-way (devhub -> metadata). A script flipping a metadata
-- flag directly does NOT create/revoke a devhub license; issue licenses
-- through devhub_licenses (exports, issue menu, exams) instead.
Config.Compat.QbLicences = {
    enabled = false,

    -- Left side = your template, right side = the key in PlayerData.metadata.licences
    map = {
        ["driving_license"] = "driver",
        ["weapon_license"]  = "weapon",
        ["id_card"]         = "id",
        -- ["business_license"] = "business",
    },
}
