local function adminName(src)
    return ('%s (%s)'):format(GetPlayerName(src) or 'console', Bridge.GetLicense(src) or src)
end

local function guard(src)
    if not IsVMCAdmin(src) then
        DB.Log('Blocked admin call', ('%s tried to use the multichar admin without permission'):format(adminName(src)))
        return false
    end
    return true
end

local function onlinePlayers()
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        local allowed, breakdown = Slots.GetAllowed(src)
        out[#out + 1] = {
            id = src,
            name = GetPlayerName(src),
            license = Bridge.GetLicense(src),
            discord = Bridge.GetDiscord(src),
            allowed = allowed,
            breakdown = breakdown,
        }
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

local function adminData(src, forceRoles)
    return {
        settings = Slots.GetSettings(),
        scenes = Scenes.All(),
        overrides = Slots.GetOverrides(),
        players = onlinePlayers(),
        discord = {
            enabled = Discord.Enabled(),
            roles = Discord.GetGuildRoles(forceRoles),
        },
        framework = Bridge.Name,
    }
end

lib.addCommand(Config.AdminCommand, { help = 'Open the character selection admin menu' }, function(src)
    if not guard(src) then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'You do not have permission to use this.' })
        return
    end
    TriggerClientEvent('vmc:client:openAdmin', src)
end)

lib.callback.register('vmc:admin:data', function(src, forceRoles)
    if not guard(src) then return nil end
    if forceRoles then Discord.ClearCache() end
    return adminData(src, forceRoles)
end)

lib.callback.register('vmc:admin:saveSettings', function(src, settings)
    if not guard(src) or type(settings) ~= 'table' then return false end
    local saved = Slots.SaveSettings(settings)
    -- push the new look to everyone right now (selection screens update live)
    TriggerClientEvent('vmc:client:theme', -1, saved.theme)
    DB.Log('Settings saved', adminName(src) .. ' updated slot / scene settings')
    return true, adminData(src)
end)

lib.callback.register('vmc:admin:saveScene', function(src, scene)
    if not guard(src) or type(scene) ~= 'table' then return false end
    local saved = Scenes.Save(scene, GetPlayerName(src))
    DB.Log('Scene saved', ('%s saved scene #%s "%s"'):format(adminName(src), tostring(saved and saved.id), saved and saved.name or '?'))
    return saved ~= nil, saved
end)

lib.callback.register('vmc:admin:sceneAction', function(src, action, id, value)
    if not guard(src) then return false end
    if action == 'delete' then
        Scenes.Delete(id)
        DB.Log('Scene deleted', ('%s deleted scene #%s'):format(adminName(src), tostring(id)))
    elseif action == 'toggle' then
        Scenes.SetEnabled(id, value == true)
    elseif action == 'duplicate' then
        Scenes.Duplicate(id, GetPlayerName(src))
    elseif action == 'weight' then
        local s = Scenes.Get(id)
        if s then s.weight = math.floor(VMC.Num(value, 1, 0, 100)); Scenes.Save(s, GetPlayerName(src)) end
    end
    return true, adminData(src)
end)

lib.callback.register('vmc:admin:setOverride', function(src, d)
    if not guard(src) or type(d) ~= 'table' then return false end
    local identifier = d.identifier
    local name = d.name
    -- allow passing an online server id instead of an identifier
    if tonumber(identifier) and GetPlayerName(tonumber(identifier)) then
        local target = tonumber(identifier)
        name = name or GetPlayerName(target)
        identifier = Bridge.GetLicense(target)
    end
    local ok, err = Slots.SetOverride(identifier, d.mode, d.slots, d.note, name, GetPlayerName(src))
    if not ok then return false, err end
    DB.Log('Slot override', ('%s set %s to %s %s slots (%s)'):format(adminName(src), identifier, d.mode == 'set' and 'exactly' or '+', tostring(d.slots), d.note or 'no note'))
    return true, adminData(src)
end)

lib.callback.register('vmc:admin:removeOverride', function(src, identifier)
    if not guard(src) then return false end
    Slots.RemoveOverride(identifier)
    DB.Log('Slot override removed', ('%s removed the override on %s'):format(adminName(src), tostring(identifier)))
    return true, adminData(src)
end)

exports('SetSlotOverride', function(identifier, mode, slots, note)
    return Slots.SetOverride(identifier, mode, slots, note, nil, 'export')
end)
