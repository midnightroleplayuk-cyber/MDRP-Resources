-- Hospital / check-in point registry: Config.Hospitals plus points made in-city with
-- /goodcivconfig. Custom points are kept in server KVP, so they survive resource updates.
Hospitals = {}

local KVP = 'goodciv:hospitals'
local custom = {}

local function toast(src, kind, msg) TriggerClientEvent('goodciv:client:toast', src, kind, msg) end

local function load()
    local raw = GetResourceKvpString(KVP)
    local ok, data = pcall(json.decode, raw or '[]')
    custom = ok and type(data) == 'table' and data or {}
end

local function save()
    SetResourceKvp(KVP, json.encode(custom))
end

---Publish the merged list to every client (GlobalState) and to this side.
function Hospitals.Publish()
    local list = {}
    if Config.CheckIn.UseConfigHospitals or #custom == 0 then
        for i, h in ipairs(Config.Hospitals) do
            list[#list + 1] = {
                id = 'cfg' .. i, label = h.label, custom = false,
                x = h.coords.x, y = h.coords.y, z = h.coords.z,
                dx = h.drop.x, dy = h.drop.y, dz = h.drop.z, dh = h.drop.w,
                radius = h.radius, fee = h.fee,
            }
        end
    end
    for _, h in ipairs(custom) do list[#list + 1] = h end
    GlobalState['goodciv:hospitals'] = list
    GoodCiv.SetHospitals(list)
end

local function isAdmin(src)
    return src ~= 0 and IsPlayerAceAllowed(src, Config.Admin.Ace)
end

local function findCustom(id)
    for i, h in ipairs(custom) do
        if h.id == id then return h, i end
    end
end

local function clean(data)
    data = type(data) == 'table' and data or {}
    local label = tostring(data.label or ''):gsub('[%c<>]', ''):sub(1, 48)
    if label:match('^%s*$') then return nil end
    local fee = math.floor(math.max(0, math.min(1000000, tonumber(data.fee) or Config.CheckIn.Fee)))
    local radius = math.max(5.0, math.min(250.0, tonumber(data.radius) or 30.0))
    return label, fee, radius
end

local function placeAt(h, src)
    local ped = GetPlayerPed(src)
    local c = GetEntityCoords(ped)
    h.x, h.y, h.z = c.x, c.y, c.z
    h.dx, h.dy, h.dz, h.dh = c.x, c.y, c.z, GetEntityHeading(ped)
end

---------------------------------------------------------------------------
-- /goodcivconfig
---------------------------------------------------------------------------
RegisterCommand(Config.Admin.Command, function(src)
    if src == 0 then return print('[goodciv] use this command in game') end
    if not isAdmin(src) then return toast(src, 'error', L('no_permission')) end
    TriggerClientEvent('goodciv:client:openConfig', src)
end, false)

RegisterNetEvent('goodciv:server:cfgAdd', function(data)
    local src = source
    if not isAdmin(src) then return end
    local label, fee, radius = clean(data)
    if not label then return toast(src, 'error', L('cfg_need_label')) end
    local h = { id = ('c%d%03d'):format(os.time(), math.random(0, 999)), label = label, fee = fee, radius = radius, custom = true }
    placeAt(h, src)
    custom[#custom + 1] = h
    save()
    Hospitals.Publish()
    toast(src, 'success', L('cfg_added', label))
end)

RegisterNetEvent('goodciv:server:cfgUpdate', function(data)
    local src = source
    if not isAdmin(src) or type(data) ~= 'table' then return end
    local h = findCustom(data.id)
    if not h then return toast(src, 'error', L('cfg_builtin')) end
    local label, fee, radius = clean(data)
    if not label then return toast(src, 'error', L('cfg_need_label')) end
    h.label, h.fee, h.radius = label, fee, radius
    save()
    Hospitals.Publish()
    toast(src, 'success', L('cfg_saved', label))
end)

RegisterNetEvent('goodciv:server:cfgMove', function(id)
    local src = source
    if not isAdmin(src) then return end
    local h = findCustom(id)
    if not h then return toast(src, 'error', L('cfg_builtin')) end
    placeAt(h, src)
    save()
    Hospitals.Publish()
    toast(src, 'success', L('cfg_moved', h.label))
end)

RegisterNetEvent('goodciv:server:cfgRemove', function(id)
    local src = source
    if not isAdmin(src) then return end
    local h, i = findCustom(id)
    if not h then return toast(src, 'error', L('cfg_builtin')) end
    table.remove(custom, i)
    save()
    Hospitals.Publish()
    toast(src, 'info', L('cfg_removed', h.label))
end)

---------------------------------------------------------------------------
-- /goodcivrevive [id]
---------------------------------------------------------------------------
RegisterCommand(Config.Admin.ReviveCommand, function(src, args)
    if src ~= 0 and not isAdmin(src) then return toast(src, 'error', L('no_permission')) end
    local target = tonumber(args[1]) or src
    if target == 0 or GetPlayerPed(target) == 0 then
        if src ~= 0 then toast(src, 'error', L('no_player')) else print('[goodciv] no such player') end
        return
    end
    local inc = Incidents.GetByPatient(target)
    if inc then Incidents.Close(inc, 'resolved') end
    Bridge.Revive(target)
    SetTimeout(1000, function()
        if GetPlayerPed(target) ~= 0 then Injury.Clear(target, true) end
    end)
end, false)

load()
Hospitals.Publish()
