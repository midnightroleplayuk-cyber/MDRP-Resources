-- Framework bridge (server). Every module talks to VPO.Bridge, never to a framework directly.
--
-- VPO.Bridge.Name                        'qbox' | 'qbcore' | 'esx' | nil
-- VPO.Bridge.GetIdentifier(src)          citizenid / ESX identifier
-- VPO.Bridge.GetSource(identifier)       online server id or nil
-- VPO.Bridge.GetName(src)                character name
-- VPO.Bridge.GetJob(src)                 { name, label, grade, gradeLabel, onduty } (onduty is nil on ESX)
-- VPO.Bridge.SetFrameworkDuty(src, on)   keeps the framework's own duty flag in step (no-op on ESX)
-- VPO.Bridge.SetCallsignMetadata(src, cs) metadata.callsign on QB/Qbox (no-op on ESX)
-- VPO.Bridge.AddMoney(src, account, amount, reason)    account: 'bank' | 'cash'
-- VPO.Bridge.RemoveMoney(src, account, amount, reason)
-- VPO.Bridge.GetVehicleByPlate(plate)     { plate, model, owner } from the framework's vehicle table
-- VPO.Bridge.GetNameByIdentifier(id)     character name, online or offline
-- VPO.Bridge.SetJob(identifier, job, grade)  online or offline; job = Config.Management.UnemployedJob to dismiss
-- VPO.Bridge.IsFrameworkAdmin(src)       ESX admin/superadmin group, QBCore admin/god permission
-- VPO.Bridge.JobMembers(job)              { { identifier, name, grade } } including offline
-- VPO.Bridge.OnPlayerLoaded(cb)          cb(src) when a character is loaded
-- VPO.Bridge.OnPlayerUnloaded(cb)        cb(src, identifier) on logout or drop

VPO.Bridge = {}
local Bridge = VPO.Bridge

local function running(res)
    local s = GetResourceState(res)
    return s == 'started' or s == 'starting'
end

local function meta(res, key) return GetResourceMetadata(res, key, 0) or '' end

-- Qbox can be installed under the qb-core folder name. Its manifest still says what it is.
local function looksLikeQbox(res)
    if meta(res, 'name') == 'qbx_core' then return true end
    return meta(res, 'repository'):lower():find('qbox%-project') ~= nil
end

local function detect()
    local want = tostring(Config.Framework or 'auto'):lower()
    if want == 'qbox' then return 'qbox', running('qbx_core') and 'qbx_core' or 'qb-core' end
    if want == 'qbcore' then return 'qbcore', 'qb-core' end
    if want == 'esx' then return 'esx', 'es_extended' end
    if running('qbx_core') then return 'qbox', 'qbx_core' end
    if running('qb-core') then
        if looksLikeQbox('qb-core') then return 'qbox', 'qb-core' end
        return 'qbcore', 'qb-core'
    end
    if running('es_extended') then return 'esx', 'es_extended' end
    return nil, nil
end

Bridge.Name, Bridge.Resource = detect()
if not Bridge.Name then
    VPO.Log.error('No supported framework found. Start qbx_core, qb-core or es_extended before %s, or set Config.Framework.', VPO.Resource)
end

---------------------------------------------------------------------------
-- Character load / unload. Framework files call Bridge._Loaded / Bridge._Unloaded.
---------------------------------------------------------------------------
local loadedCbs, unloadedCbs = {}, {}
local identifiers = {} -- [src] = identifier, kept so unload/drop handlers still know who it was

function Bridge.OnPlayerLoaded(cb) loadedCbs[#loadedCbs + 1] = cb end
function Bridge.OnPlayerUnloaded(cb) unloadedCbs[#unloadedCbs + 1] = cb end

--- Identifier cached at load; survives the framework forgetting the player on drop.
function Bridge.CachedIdentifier(src) return identifiers[src] end

function Bridge._Loaded(src)
    src = tonumber(src)
    if not src then return end
    local id = Bridge.GetIdentifier(src)
    if not id then return end
    identifiers[src] = id
    for _, cb in ipairs(loadedCbs) do
        local ok, err = pcall(cb, src)
        if not ok then VPO.Log.error('player loaded handler failed: %s', err) end
    end
end

function Bridge._Unloaded(src)
    src = tonumber(src)
    local id = src and identifiers[src]
    if not id then return end
    identifiers[src] = nil
    for _, cb in ipairs(unloadedCbs) do
        local ok, err = pcall(cb, src, id)
        if not ok then VPO.Log.error('player unloaded handler failed: %s', err) end
    end
end

AddEventHandler('playerDropped', function() Bridge._Unloaded(source) end)

-- Defaults so nothing errors if no framework was found.
function Bridge.GetIdentifier() return nil end
function Bridge.GetSource() return nil end
function Bridge.GetName() return nil end
function Bridge.GetJob() return nil end
function Bridge.SetFrameworkDuty() end
function Bridge.SetCallsignMetadata() end
function Bridge.GetVehicleByPlate() return nil end
function Bridge.GetNameByIdentifier() return nil end
function Bridge.SetJob() return false end
function Bridge.IsFrameworkAdmin() return false end
function Bridge.JobMembers() return {} end
function Bridge.AddMoney() return false end
function Bridge.RemoveMoney() return false end
