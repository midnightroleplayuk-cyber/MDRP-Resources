local lastUse = 0
local ignored = {}

for _, model in ipairs(Config.IgnoreModels) do
    ignored[type(model) == 'string' and joaat(model) or model] = true
end

local function notify(msg, kind)
    if GetResourceState('ox_lib') == 'started' then
        TriggerEvent('ox_lib:notify', { description = msg, type = kind or 'inform' })
    else
        TriggerEvent('chat:addMessage', { args = { 'Props', msg } })
    end
end

local function requestControl(entity)
    if not NetworkGetEntityIsNetworked(entity) then return true end
    local timeout = GetGameTimer() + 1000
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeout do
        Wait(0)
        NetworkRequestControlOfEntity(entity)
    end
    return NetworkHasControlOfEntity(entity)
end

local function clearProps()
    local ped = PlayerPedId()
    local weaponObj = GetCurrentPedWeaponEntityIndex(ped)
    local removed, leftover = 0, {}

    for _, obj in ipairs(GetGamePool('CObject')) do
        if DoesEntityExist(obj)
            and obj ~= weaponObj
            and IsEntityAttachedToEntity(obj, ped)
            and not ignored[GetEntityModel(obj)] then

            if requestControl(obj) then
                DetachEntity(obj, true, true)
                SetEntityAsMissionEntity(obj, true, true)
                DeleteEntity(obj)
                if DoesEntityExist(obj) then DeleteObject(obj) end
            end

            if DoesEntityExist(obj) then
                -- couldn't get ownership; let the server delete it
                if NetworkGetEntityIsNetworked(obj) then
                    leftover[#leftover + 1] = ObjToNet(obj)
                end
            else
                removed = removed + 1
            end
        end
    end

    if #leftover > 0 then
        TriggerServerEvent('rsvx_clearprops:server:delete', leftover)
        removed = removed + #leftover
    end

    if Config.ClearAnimation then
        if IsPedInAnyVehicle(ped, false) then
            ClearPedSecondaryTask(ped)
        else
            ClearPedTasks(ped)
        end
    end

    if Config.HolsterWeapon then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    end

    return removed
end

RegisterCommand(Config.Command, function()
    local now = GetGameTimer()
    if now - lastUse < Config.Cooldown * 1000 then
        local left = math.ceil((Config.Cooldown * 1000 - (now - lastUse)) / 1000)
        return notify(('Wait %ds before using this again.'):format(left), 'error')
    end
    lastUse = now

    local count = clearProps()
    if count > 0 then
        notify(('Removed %d stuck prop%s.'):format(count, count == 1 and '' or 's'), 'success')
    else
        notify('No stuck props found.', 'inform')
    end
end, false)

RegisterKeyMapping(Config.Command, 'Clear stuck props', 'keyboard', Config.Keybind)

TriggerEvent('chat:addSuggestion', '/' .. Config.Command, 'Remove props stuck in your hands')

-- staff-triggered clear
RegisterNetEvent('rsvx_clearprops:client:force', function()
    local count = clearProps()
    notify(('Staff cleared %d prop%s from you.'):format(count, count == 1 and '' or 's'), 'inform')
end)
