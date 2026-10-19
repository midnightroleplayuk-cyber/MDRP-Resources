-- ============================================================
-- Staff Tag — server store + broadcaster
-- Admins toggle "[STAFF] <Name>" floating above their head.
-- All clients receive the full tag table on change/join.
-- ============================================================

local StaffTags = {} -- [serverId] = { name = '...' }

local function broadcast()
    TriggerClientEvent('apex_adminmenu:syncStaffTags', -1, StaffTags)
end

-- Internal core — both the net event handler below and the panel
-- bridge from adminpanel.lua call into this with an explicit src.
function ApplyStaffTagFor(src, enabled, name)
    if not src or src == 0 then return end
    -- Accept anyone who can open the admin panel (covers PanelHasPerm
    -- entries) in addition to the legacy AdminPerms gate.
    local allowed = (AdminPerms and AdminPerms(src)) or (PanelCanOpen and PanelCanOpen(src))
    if not allowed then
        if StaffTags[src] then StaffTags[src] = nil; broadcast() end
        return
    end
    if enabled then
        name = tostring(name or GetPlayerName(src) or 'Staff'):sub(1, 32)
        StaffTags[src] = { name = name, since = os.time() }
    else
        StaffTags[src] = nil
    end
    broadcast()
end

RegisterNetEvent('apex_adminmenu:setStaffTag', function(enabled, name)
    ApplyStaffTagFor(source, enabled, name)
end)

-- On player join, push the current set so they see existing tags.
AddEventHandler('playerJoining', function()
    local src = source
    -- Delay slightly so the client-side event handler is up.
    SetTimeout(2000, function()
        TriggerClientEvent('apex_adminmenu:syncStaffTags', src, StaffTags)
    end)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if StaffTags[src] then
        StaffTags[src] = nil
        broadcast()
    end
end)

-- Convenience: clients ask for sync after fully loaded.
-- The base 'reqsync' event already exists for weather; we attach a second
-- handler so both run together.
AddEventHandler('apex_adminmenu:reqsync', function()
    TriggerClientEvent('apex_adminmenu:syncStaffTags', source, StaffTags)
end)
