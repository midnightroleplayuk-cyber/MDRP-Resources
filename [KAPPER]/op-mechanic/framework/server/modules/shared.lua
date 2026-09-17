Framework = nil
Fr = {}

function Fr.HasJob(src, jobName, minGrade)
    local job = Fr.GetJob and Fr.GetJob(src) or nil
    if not job or job.name ~= jobName then
        return false
    end
    return (job.grade or 0) >= (minGrade or 0)
end

function Fr.SearchPlayers(_query, _opts)
    return {}
end

function Fr.GetCharacterProfile(src)
    if not src then
        return nil
    end
    local name = GetPlayerName(src)
    if not name then
        return nil
    end
    return {
        identifier = Fr.GetIdentifier and Fr.GetIdentifier(src) or tostring(src),
        name = name,
        firstname = name,
        lastname = '',
        serverId = src,
    }
end

--- Character first + last name. Falls back to Steam nick only if the profile is empty.
function Fr.GetPlayerName(src)
    local profile = Fr.GetCharacterProfile and Fr.GetCharacterProfile(src)
    if profile and type(profile.name) == 'string' and profile.name ~= '' then
        return profile.name
    end
    return GetPlayerName(src)
end

function Fr.AddItem(_src, _item, _count)
    return true
end

-- ── Billing ──────────────────────────────────────────────────────────────────

function Fr.Charge(src, amount, reason)
    if amount <= 0 then return true end
    return Fr.RemoveMoney(src, 'bank', amount, reason or 'op-mechanic-tuning')
end

-- ── Society (banking globals from integrations/server/banking/*) ─────────────

local function societyJobName(account)
    account = tostring(account or '')
    return account:gsub('^society_', '')
end

function Fr.SocietyAccount(jobName)
    if OPM and OPM.Jobs and OPM.Jobs.SocietyAccount then
        return OPM.Jobs.SocietyAccount(jobName)
    end
    if jobName and jobName ~= '' then
        return 'society_' .. jobName
    end
    return 'society_mechanic'
end

--- Banking exports sometimes return nothing (0 values) instead of nil/0.
--- `tonumber(fn())` then becomes `tonumber()` and Lua errors "value expected".
local function safeGetAccountMoney(jobName)
    if type(getAccountMoney) ~= 'function' then
        return 0
    end
    local ok, money = pcall(getAccountMoney, jobName)
    if not ok then
        return 0
    end
    return tonumber(money) or 0
end

function Fr.GetSocietyMoney(account)
    account = account or Fr.SocietyAccount()
    return safeGetAccountMoney(societyJobName(account))
end

function Fr.AddSocietyMoney(account, amount)
    account = account or Fr.SocietyAccount()
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return true
    end
    local jobName = societyJobName(account)
    if type(addAccountMoney) ~= 'function' then
        return false
    end
    local ok, result = pcall(addAccountMoney, jobName, amount)
    if not ok then
        return false
    end
    -- Some banking bridges return nil on success; treat only explicit false as failure.
    return result ~= false
end

function Fr.RemoveSocietyMoney(account, amount)
    account = account or Fr.SocietyAccount()
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return true
    end
    local jobName = societyJobName(account)
    if type(removeAccountMoney) ~= 'function' then
        return false
    end
    local ok, result = pcall(removeAccountMoney, jobName, amount)
    if not ok then
        return false
    end
    return result ~= false
end

-- Optional nested table for callers that prefer Fr.Society.*
Fr.Society = {
    AccountName = function(jobName)
        return Fr.SocietyAccount(jobName)
    end,
    GetMoney = function(account)
        return Fr.GetSocietyMoney(account)
    end,
    AddMoney = function(account, amount)
        return Fr.AddSocietyMoney(account, amount)
    end,
    RemoveMoney = function(account, amount)
        return Fr.RemoveSocietyMoney(account, amount)
    end,
}

-- ── Job / permissions / employees ────────────────────────────────────────────

function Fr.HasMinGrade(src, minGrade)
    return OPM.Jobs.HasAccess(src, minGrade)
end

function Fr.IsBoss(src, minGrade)
    return OPM.Jobs.HasAccess(src, minGrade)
end

function Fr.ListEmployees(jobName)
    if Fr.GetEmployees then
        return Fr.GetEmployees(jobName) or {}
    end
    return {}
end

function Fr.GetJobGradesList(jobName)
    if Fr.GetJobGrades then
        return Fr.GetJobGrades(jobName) or {}
    end
    return {}
end

function Fr.SetPlayerJob(target, jobName, grade)
    if Fr.SetJob then
        return Fr.SetJob(target, jobName, grade)
    end
    return false
end

function Fr.CanTune(src, minGrade)
    return OPM.Jobs.HasAccess(src, minGrade)
end

function Fr.CanAccessTabletApp(src, appId)
    local info = OPM.Jobs.ResolveSrc(src)
    if not info then
        return false
    end
    local minGrade = OPM.Jobs.TabletAppMinGrade(info.name, appId)
    return info.grade >= minGrade
end

function Fr.SaveVehicleProps(plate, props)
    if OPM and OPM.Utils and OPM.Utils.Debug then
        OPM.Utils.Debug('SaveVehicleProps stub', plate)
    end
    return true
end

-- ── Inventory defaults (adapters override Fr.HasItem / Fr.RegisterStash / …) ─

function Fr.RegisterStash(_stashId, _label, _slots, _weight, _owner)
    return true
end

function Fr.AddItemToStash(_stashId, _item, _count)
    return false
end

function Fr.RemoveItemFromStash(_stashId, _item, _count)
    return false
end

function Fr.NormalizePlate(plate)
    return tostring(plate or ''):upper():gsub('%s+', '')
end

--- Plate as shown on the entity (trim only) — matches ox_inventory trunk ids.
function Fr.TrimVehiclePlate(plate)
    return tostring(plate or ''):match('^%s*(.-)%s*$') or ''
end

---@return string|nil plate, number|nil vehicle
function Fr.GetVehiclePlateFromNetId(netId)
    local veh = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return nil, nil
    end
    local plate = Fr.TrimVehiclePlate(GetVehicleNumberPlateText(veh))
    if plate == '' then
        return nil, veh
    end
    return plate, veh
end

--- Resolve plate from hint or live entity (parts pickup passes client plate).
---@return string|nil plate
function Fr.ResolveVehiclePlate(netId, plateHint)
    local plate = Fr.TrimVehiclePlate(plateHint)
    if plate ~= '' then
        return plate
    end
    return select(1, Fr.GetVehiclePlateFromNetId(netId))
end

--- ox_inventory trunk ref: load + add requires `{ id = 'trunk'..plate, netid = netId }`.
---@return table|nil ref `{ id, netid, plate }`
function Fr.OxVehicleTrunkRef(netId, plateHint)
    netId = tonumber(netId) or 0
    if netId <= 0 then
        return nil
    end
    local plate = Fr.ResolveVehiclePlate(netId, plateHint)
    if not plate then
        return nil
    end
    return { id = 'trunk' .. plate, netid = netId, plate = plate }
end

--- qb-inventory / codem / one_inventory trunk stash id.
---@return string|nil
function Fr.QbVehicleTrunkStashId(plate)
    plate = Fr.TrimVehiclePlate(plate)
    if plate == '' then
        return nil
    end
    return 'trunk-' .. plate
end

function Fr.AddItemToVehicleTrunk(_src, _netId, _item, _count, _plateHint)
    return false
end

function Fr.RemoveItemFromVehicleTrunk(_src, _netId, _item, _count, _plateHint)
    return false
end

function Fr.OpenStash(_src, _stashId, _data)
    return false
end

function Fr.RegisterUsableItem(itemName, cb)
    local fw = Config.Framework
    if fw == 'qb' or fw == 'qbox' then
        local ok, QBCore = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and QBCore and QBCore.Functions and QBCore.Functions.CreateUseableItem then
            QBCore.Functions.CreateUseableItem(itemName, function(src)
                cb(src)
            end)
            return true
        end
    elseif fw == 'esx' then
        local ok, ESX = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and ESX and ESX.RegisterUsableItem then
            ESX.RegisterUsableItem(itemName, function(src)
                cb(src)
            end)
            return true
        end
    end
    return false
end

RegisterNetEvent('opm:server:inventory:openStash', function(stashId, data)
    local src = source
    if type(stashId) ~= 'string' or stashId == '' then
        return
    end
    if not stashId:find('^opm_', 1) then
        return
    end
    if OPM.MechanicAdmin and OPM.MechanicAdmin.CanOpenStash then
        if not OPM.MechanicAdmin.CanOpenStash(src, stashId) then
            if Fr.Notify then
                Fr.Notify(src, OPM.T('mechmenu.error.noJob') or 'Mechanic job required', 'error')
            end
            return
        end
    end
    Fr.OpenStash(src, stashId, type(data) == 'table' and data or {})
end)

local invScript = (Config.Inventory and Config.Inventory.inventoryScript) or 'none'
if OPM and OPM.Utils and OPM.Utils.Debug then
    OPM.Utils.Debug(('Inventory: %s'):format(invScript))
end