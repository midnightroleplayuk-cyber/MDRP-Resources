-- This file is for custom implementations and overrides
-- You can add your own functions here to customize the admin menu.
--
-- NOTE: this file is loaded AFTER bridge/**/client.lua, which is what
-- detects your framework and sets the `Framework` / `ESX` / `QBCore` /
-- `QBX` globals. Never assign `Framework` here — an earlier version of
-- this file forced `Framework = 'esx'` unconditionally, which silently
-- broke every QBCore and QBox server (all the `Framework == 'qb'`
-- branches stopped matching). The bridge already got it right.

-- ============================================================
-- Vehicle keys — used when Config.UsingVehicleKeys = 'custom'
-- ============================================================
-- Every common key resource (qbx_vehiclekeys, qb-vehiclekeys, wasabi,
-- Renewed, MrNewb, qs-vehiclekeys, jaksam, cd_garage, t1ger, okokGarage,
-- mono_carkeys, apex_carlock) is already handled automatically in
-- configs/compat.lua. Only fill this in for an in-house key system.
function CustomGiveKeys(plate, model, vehicle)
    -- Example:
    -- TriggerServerEvent('my_keys:give', plate)
    print(('[apex_adminmenu] CustomGiveKeys called for plate %s — not implemented'):format(tostring(plate)))
end

-- ============================================================
-- Appearance — used when Config.SkinMenu = 'custom'
-- ============================================================
-- illenium-appearance, fivem-appearance, bl_appearance, rcore_clothing,
-- codem-appearance, tgiann-clothing, qb-clothing and esx_skin are all
-- detected automatically. Only override for an in-house clothing script.

--- Open the saveable customisation menu for the local player.
function CustomSkinMenu()
    -- Example:
    -- TriggerEvent('my_clothing:openMenu')
    print('[apex_adminmenu] CustomSkinMenu called — not implemented')
end

--- Re-apply the player's saved appearance (used by "Restore ped").
function CustomRestoreSkin()
    -- Example:
    -- TriggerServerEvent('my_clothing:loadSkin')
    print('[apex_adminmenu] CustomRestoreSkin called — not implemented')
end

-- ============================================================
-- Medical / ambulance — used when Config.Medical = 'custom'
-- ============================================================
-- qbx_medical, qb-ambulancejob (and the ps- / lj- forks),
-- wasabi_ambulance, codem-ambulancejob, ars_ambulancejob and
-- esx_ambulancejob are all detected automatically. Only override for an
-- in-house medical script.
--
-- These MUST clear your ambulance script's own death state, not just
-- resurrect the ped. Every one of them tracks death separately (a client
-- flag plus, usually, something saved on the character), and a revive that
-- only calls the natives leaves that set — the player gets off the floor
-- and the death loop carries straight on with the respawn timer and the
-- disabled controls. Run `apexcompat` in the server console to check which
-- provider was picked.

--- Bring the local player back up.
function CustomRevive()
    -- Example:
    -- TriggerEvent('my_medical:revive')
    print('[apex_adminmenu] CustomRevive called — not implemented')
end

--- Clear injuries, bleeding and the limp on the local player.
function CustomHeal()
    -- Example:
    -- TriggerEvent('my_medical:healInjuries', 'full')
    print('[apex_adminmenu] CustomHeal called — not implemented')
end
