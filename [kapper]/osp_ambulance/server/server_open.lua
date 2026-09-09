function DebugPrint(...)
    if Config.Debug then
        print(...)
    end
end

-- Override this to integrate a custom dispatch system (server-side path).
-- Built-in adapters live in integrations/dispatch/* and are selected via Config.Dispatch.
-- src (optional): the server id of the player who triggered the alert.
function TriggerDispatchAlert(coords, message, src)
    local tool = GetEnsuredDispatchTool()
    local dispatch = Dispatch[tool]

    if dispatch and dispatch.alert then
        dispatch.alert(coords, message, src)
        return true
    end

    if tool ~= 'default' and Dispatch['default'] and Dispatch['default'].alert then
        Dispatch['default'].alert(coords, message, src)
        return true
    end

    return false
end

function IsValidBloodType(bloodType)
    return type(bloodType) == 'string' and bloodType ~= '' and Config.bloodTypes and Config.bloodTypes[bloodType] ~= nil
end

-- Override this to send blood drops to a third-party evidence script (server-side).
-- bloodType is always the medical-system type. Return true if you handled the drop.
function CreateCustomBloodDropEvidence(source, bloodType, coords, identifier)
    -- Example:
    -- exports['my_evidence']:CreateBloodDrop(source, identifier, bloodType, coords)
    -- return true
    return false
end

-- Default QB / Qbox / ESX evidence. Override CreateCustomBloodDropEvidence instead of this
-- unless you want to replace the built-in events entirely.
function CreateBloodDropEvidence(source, bloodType, coords)
    if not IsValidBloodType(bloodType) then return false end

    local identifier = GetIdentifier and GetIdentifier(source)
    if CreateCustomBloodDropEvidence(source, bloodType, coords, identifier) then
        return true
    end

    TriggerEvent('osp_ambulance:bloodDropEvidence', source, bloodType, coords, identifier)

    return true
end

RegisterNetEvent('osp_ambulance:createBloodDropEvidence', function(bloodType, coords)
    local src = source
    local body = Player(src).state.BodyDamage
    if type(body) == 'table' and IsValidBloodType(body.bloodType) then
        bloodType = body.bloodType
    elseif not IsValidBloodType(bloodType) then
        return
    end

    CreateBloodDropEvidence(src, bloodType, coords)
end)

-- External insurance: return a table to override built-in coverage for hospital bills and prescriptions.
-- Return nil to use the built-in plan stored on the player (when Config.UseBuiltInInsurance is true).
-- Pair with HandleExternalInsuranceMenu in client_open.lua.
--
-- {
--     planId = 'external',
--     label = 'National Health',
--     checkInDiscount = 0.50,            -- 0.0-1.0 off check-in / hospital bill
--     freeMedications = true,            -- true = all medications, or { 'paracetamol', 'xanax' }
--     expiresAt = os.time() + 86400,     -- optional unix timestamp
-- }
function GetExternalInsurance(source)
    -- if GetResourceState('my_insurance') ~= 'started' then return end
    -- local data = exports['my_insurance']:GetPlayerInsurance(source)
    -- if not data or not data.active then return end
    -- return {
    --     planId = data.plan or 'external',
    --     label = data.label or 'Insured',
    --     checkInDiscount = data.discount or 0.5,
    --     freeMedications = true,
    -- }

    return nil
end

lib.callback.register('osp_ambulance:GetTime', function(source, data)
    return os.date("%X")
end)

lib.callback.register('osp_ambulance:getServerTime', function()
    return os.time()
end)

CreateUseableItem('pager', function(source, item)
    TriggerClientEvent('osp_ambulance:incoming', source)
end)

CreateUseableItem('stretcher', function(source, item)
    TriggerClientEvent('osp_ambulance:SpawnStretcher', source)
end)

CreateUseableItem('wheelchair', function(source, item)
    TriggerClientEvent('osp_ambulance:givePlayerWheelChair', source, true)
end)

CreateUseableItem('crutch', function(source, item)
    TriggerClientEvent('osp_ambulance:givePlayerCrutch', source, true)
end)

CreateUseableItem('ecg', function(source, item)
    TriggerClientEvent('osp_ambulance:activate', source)
end)

CreateUseableItem(Config.MedicalBag.itemName, function(source, item, metadata)
    UseMedicalBagItem(source, item, metadata)
end)

CreateUseableItem('prescription', function(source, item, metadata)
    TriggerClientEvent('osp_ambulance:viewPrescription', source, metadata or item.info or item.metadata or {}, metadata.slot or item.slot)
end)

for _, medication in pairs(Config.PrescriptionMedications or {}) do
    local itemName = medication.itemName
    if itemName then
        CreateUseableItem(itemName, function(source, item)
            TriggerClientEvent('osp_ambulance:usePrescriptionMedication', source, itemName)
        end)
    end
end

RegisterNetEvent('osp_ambulance:buyItemSv', function(data, input, price, name)
    local src = source
    if data.amount then
        if data.amount > 0 then
            if data.amount >= input[1] then
                local money = CheckMoney(src)
                if money*input[1] > price*input[1] then
                    RemoveMoney(src, price*input[1])
                    for i=1,input[1] do
                        AddItem(src, name, 1)
                    end
                    if data.index then
                        TriggerEvent('osp_ambulance:RemoveItemFromStock', data.index, input[1])
                    end
                else
                    TriggerClientEvent('osp_ambulance:SendTextMessage', src, GetLang().interactions.medicalHeader, GetLang().error.not_enough_money, 5000, "error")
                end
            end
        else
            print('no stock')
        end
    else
        local money = CheckMoney(src)
        if money > price*input[1] then
            RemoveMoney(src, price*input[1])
            for i=1,input[1] do
                AddItem(src, name, 1)
            end
        else
            TriggerClientEvent('osp_ambulance:SendTextMessage', src, GetLang().interactions.medicalHeader, GetLang().error.not_enough_money, 5000, "error")
        end
    end
end)



RegisterNetEvent('osp_ambulance:revive', function(ply)
    TriggerClientEvent('hospital:client:Revive', ply, true)
end)

RegisterNetEvent('osp_ambulance:partialReviveSv', function(ply)
    TriggerClientEvent('osp_ambulance:partialRevive', ply)
end)

RegisterNetEvent('osp_ambulance:CprHelpUpSv', function(patientId)
    local medicId = source
    if type(patientId) ~= 'number' then return end
    -- Revive first so the patient can play the help-up scene, then start both sides together
    TriggerClientEvent('osp_ambulance:partialRevive', patientId)
    SetTimeout(300, function()
        TriggerClientEvent('osp_ambulance:CprHelpUpCl', medicId, patientId, true)
        TriggerClientEvent('osp_ambulance:CprHelpUpCl', patientId, medicId, false)
    end)
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end

    TriggerClientEvent('hospital:client:Revive', eventData.id, true)
end)

CreateThread(function()
    Wait(1000)
    while true do
        doctorCount = 0
        local serverPlayers = GetPlayers()
        for k,v in pairs(serverPlayers) do
            local sourcePlayer = GetPlayer(v)
            if sourcePlayer then
                if GetActiveFramework() == 'qb'  then
                    for _,x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.PlayerData.job.name == x and sourcePlayer.PlayerData.job.onduty then
                            doctorCount = doctorCount + 1
                        end
                    end
                else
                    for _,x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.job.name == x then
                            doctorCount = doctorCount + 1
                        end
                    end
                end
            end
            Wait(10)
        end
        Wait(2*60*1000)
        TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
    end
end)

RegisterNetEvent('hospital:server:SendToBed', function(bedId, isRevive, hospitalID, bedType)
    local src = source
    bedType = bedType or 'beds'

    local bedData
    if bedType == 'xray' then
        local xray = Config.Hospitals[hospitalID].Xray and Config.Hospitals[hospitalID].Xray[bedId]
        if not xray then return end
        bedData = {
            coords = xray.bedcoords,
            model = xray.model or 'v_med_bed1',
            getOutOffset = xray.getOutOffset or 1.3,
        }
    else
        bedData = Config.Hospitals[hospitalID]["beds"][bedId]
    end

    TriggerClientEvent('hospital:client:SendToBed', src, bedId, bedData, isRevive, hospitalID, bedType)
    TriggerClientEvent('hospital:client:SetBed', -1, bedId, true, hospitalID, bedType)
    if isRevive then
        ChargeHospitalBill(src)
    end
end)

RegisterNetEvent('osp_ambulance:mutePlayer', function(bool)
    MumbleSetPlayerMuted(source, bool)
    Player(source).state.isDead = bool
    -- exports['saltychat']:SetPlayerAlive(source, not bool) -- Uncomment if using saltychat
end)


function SetClosestBed(src)
    local pos = GetEntityCoords(GetPlayerPed(src), true)
    local current = nil
    local dist = nil
    local hosID = nil
    for id, hospital in pairs(Config.Hospitals) do
        for k, v in pairs(hospital["beds"]) do
            if not v.taken and not v.lockedBed then
                local dist2 = #(pos - vector3(hospital["beds"][k].coords.x, hospital["beds"][k].coords.y, hospital["beds"][k].coords.z))
                if current then
                    if dist2 < dist then
                        current = k
                        dist = dist2
                        hosID = id
                    end
                else
                    dist = dist2
                    current = k
                    hosID = id
                end
            end
        end
    end

    return current, hosID
end

-- Normalize vector3 / vector4 / table coords. Override with client_open helpers if needed.
function NormalizeRespawnCoords(coords)
    if not coords then
        return nil
    end

    local coordType = type(coords)
    if coordType == 'vector4' then
        return coords.x, coords.y, coords.z, coords.w
    end
    if coordType == 'vector3' then
        return coords.x, coords.y, coords.z, 0.0
    end
    if coordType == 'table' then
        local x = coords.x or coords[1]
        local y = coords.y or coords[2]
        local z = coords.z or coords[3]
        local w = coords.w or coords[4] or 0.0
        if x and y and z then
            return x + 0.0, y + 0.0, z + 0.0, w + 0.0
        end
    end

    return nil
end

-- Finds the closest Config.RespawnLocations entry to the player.
-- Override this for custom location tables / filtering on the server.
function GetClosestRespawnLocation(src, fromCoords)
    local locations = Config.RespawnLocations
    if type(locations) ~= 'table' then
        return nil
    end

    local origin = fromCoords
    if not origin then
        origin = GetEntityCoords(GetPlayerPed(src), true)
    end

    local closestCoords = nil
    local closestDist = nil

    for _, location in pairs(locations) do
        local x, y, z, w = NormalizeRespawnCoords(location)
        if x then
            local dist = #(origin - vector3(x, y, z))
            if not closestDist or dist < closestDist then
                closestDist = dist
                closestCoords = vector4(x, y, z, w)
            end
        end
    end

    return closestCoords
end

-- Returns true when coords-mode respawn was applied (caller should return).
-- Falls through to bed logic when mode is not 'coords' or no locations are configured.
function TryRespawnAtClosestCoords(src)
    if Config.RespawnMode ~= 'coords' then
        return false
    end

    local coords = GetClosestRespawnLocation(src)
    if not coords then
        return false
    end

    TriggerClientEvent('hospital:client:RespawnAtCoords', src, coords)
    respawnCode(src)
    return true
end

function respawnCode(src)
    local sourcePlayer = GetPlayer(src)
    if Config.WipeInventoryOnRespawn then
        ClearInventory(sourcePlayer)
        TriggerClientEvent('osp_ambulance:SendTextMessage', src, GetLang().interactions.medicalHeader, GetLang().error.possessions_taken, 3000, 'error')
    end
    ChargeHospitalBill(src)
end

-- Used when HandleCustomRespawn on the client returns coordinates.
RegisterNetEvent('hospital:server:RespawnAtCoords', function()
    local src = source
    respawnCode(src)
end)

RegisterNetEvent('hospital:server:RespawnAtHospital', function()
    local src = source
    local sourcePlayer = GetPlayer(src)
    if GetActiveFramework() == 'qb'  then
        if sourcePlayer.PlayerData.metadata["injail"] > 0 then
            for k, v in pairs(Config.JailBeds) do
                if not v.taken then
                    TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
                    TriggerClientEvent('hospital:client:SetBed2', -1, k, true)
                    respawnCode(src)
                    return
                end
            end
            TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.JailBeds[1], true)
            TriggerClientEvent('hospital:client:SetBed2', -1, 1, true)
            respawnCode(src)
        else
            if TryRespawnAtClosestCoords(src) then
                return
            end

            local bedId, hospitalID = SetClosestBed(src)
            if bedId then
                TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Hospitals[hospitalID]["beds"][bedId], true, hospitalID)
                TriggerClientEvent('hospital:client:SetBed', -1, bedId, true, hospitalID)
                respawnCode(src)
                return
            end
            TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.Hospitals[hospitalID]["beds"][1], true, hospitalID)
            TriggerClientEvent('hospital:client:SetBed', -1, Config.Hospitals[hospitalID]["beds"][1], true, hospitalID)
            respawnCode(src)
        end
    else

        local jailTime = 0
		MySQL.Async.fetchAll([[
            SELECT COLUMN_NAME
            FROM information_schema.COLUMNS
            WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'jail_time'
        ]], {}, function(result)
			if #result ~= 0 then
                MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = sourcePlayer.identifier
                }, function(result)
                    if result[1] and result[1].jail_time > 0 then
                        jailTime = result[1].jail_time
                    end
                end)
			end
		end)
        if jailTime > 0 then
            for k, v in pairs(Config.JailBeds) do
                if not v.taken then
                    TriggerClientEvent('hospital:client:SendToBed', src, k, v, true)
                    TriggerClientEvent('hospital:client:SetBed2', -1, k, true)
                    respawnCode(src)
                    return
                end
            end
            TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.JailBeds[1], true)
            TriggerClientEvent('hospital:client:SetBed2', -1, 1, true)
            respawnCode(src)
        else
            if TryRespawnAtClosestCoords(src) then
                return
            end

            local bedId, hospitalID = SetClosestBed(src)
            if bedId then
                TriggerClientEvent('hospital:client:SendToBed', src, bedId, Config.Hospitals[hospitalID]["beds"][bedId], true, hospitalID)
                TriggerClientEvent('hospital:client:SetBed', -1, bedId, true, hospitalID)
                respawnCode(src)
                return
            end
    
    
            TriggerClientEvent('hospital:client:SendToBed', src, 1, Config.Hospitals[hospitalID]["beds"][1], true, hospitalID)
            TriggerClientEvent('hospital:client:SetBed', -1, Config.Hospitals[hospitalID]["beds"][1], true, hospitalID)
            respawnCode(src)
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    if PersistWoundData then
        PersistWoundData(src, GetCachedWoundData and GetCachedWoundData(src) or PlayerServerData[src])
    else
        local sourcePlayer = GetPlayer(src)
        if GetActiveFramework() == 'qb' then
            if sourcePlayer and PlayerServerData[src] ~= nil then
                MySQL.Async.execute('UPDATE players SET woundData = @woundData WHERE citizenid = @citizenid', {
                    ['@woundData'] = json.encode(PlayerServerData[src]),
                    ['@citizenid'] = sourcePlayer.PlayerData.citizenid,
                })
            end
        elseif sourcePlayer and PlayerServerData[src] ~= nil then
            MySQL.Async.execute('UPDATE users SET woundData = @woundData WHERE identifier = @identifier', {
                ['@woundData'] = json.encode(PlayerServerData[src]),
                ['@identifier'] = sourcePlayer.identifier,
            })
        end
    end
    if ClearCachedWoundData then
        ClearCachedWoundData(src)
    end

    if Doctors[src] then
        doctorCount = doctorCount - 1
        TriggerClientEvent("hospital:client:SetDoctorCount", -1, doctorCount)
        Doctors[src] = nil
    end
end)

lib.callback.register('osp_ambulance:getPlayerNames', function(source, data)
    local newtable = {}
    for k,v in pairs(data) do
        local sourcePlayer = GetPlayer(v.id)
        local charactername = nil
        if GetActiveFramework() == 'qb'  then
            local firstname = sourcePlayer.PlayerData.charinfo.firstname
            local lastname = sourcePlayer.PlayerData.charinfo.lastname
            charactername = firstname .. ' ' .. lastname
        elseif GetActiveFramework() == 'esx' then
            charactername = sourcePlayer.name
        end

        local table = {name = v.name, id = v.id, charactername = charactername}
        newtable[k] = table
    end
    return newtable
end)

lib.callback.register('osp_ambulance:getPlayerCoords', function(source, playerid)
    local vector = GetEntityCoords(GetPlayerPed(playerid))
    return vector
end)


RegisterNetEvent('hospital:server:SendDoctorAlert', function()
    local src = source
    if not doctorCalled then
        doctorCalled = true
        local serverPlayers = GetPlayers()
        for k,v in pairs(serverPlayers) do
            local sourcePlayer = GetPlayer(v)
            if sourcePlayer then
                if GetActiveFramework() == 'qb'  then
                    for _,x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.PlayerData.job.name == x and sourcePlayer.PlayerData.job.onduty then
                            TriggerClientEvent('osp_ambulance:SendTextMessage', sourcePlayer.PlayerData.source, GetLang().interactions.medicalHeader, GetLang().info.dr_needed, 3000, 'error')
                        end
                    end
                else
                    for _,x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.job.name == x then
                            TriggerClientEvent('osp_ambulance:SendTextMessage', v, GetLang().interactions.medicalHeader, GetLang().info.dr_needed, 3000, 'error')
                        end
                    end
                end
            end
        end

        SetTimeout(Config.DocCooldown * 60000, function()
            doctorCalled = false
        end)
    else
        TriggerClientEvent('osp_ambulance:SendTextMessage', src, GetLang().interactions.medicalHeader, 'Doctor has already been notified', 3000, 'error')
    end
end)



RegisterServerEvent("osp_ambulance:wipeECGTable")
AddEventHandler("osp_ambulance:wipeECGTable", function()
    MySQL.Async.execute("DELETE FROM ecg",function()end)
end)



local function GetDutyBlipInfo(sourcePlayer)
    if not sourcePlayer then
        return nil
    end

    if GetActiveFramework() == 'qb' then
        local playerData = sourcePlayer.PlayerData
        local job = playerData and playerData.job
        if not job or job.onduty == false or not ConfigLoader.IsEmsJob(Config, job.name) then
            return nil
        end
        local charinfo = playerData.charinfo or {}
        return {
            job = job.name,
            label = (charinfo.firstname or '') .. ' ' .. (charinfo.lastname or ''),
        }
    end

    local job = sourcePlayer.job
    if not job or not ConfigLoader.IsEmsJob(Config, job.name) then
        return nil
    end

    return {
        job = job.name,
        label = sourcePlayer.name,
    }
end

function UpdateBlips()
    local dutyPlayers = {}
    local recipients = {}
    local players = GetPlayers()

    for _, id in pairs(players) do
        local src = tonumber(id) or id
        local info = GetDutyBlipInfo(GetPlayer(src))
        if info then
            local ped = GetPlayerPed(src)
            if ped and ped ~= 0 then
                local coords = GetEntityCoords(ped)
                dutyPlayers[#dutyPlayers + 1] = {
                    source = src,
                    label = info.label,
                    job = info.job,
                    location = {
                        x = coords.x,
                        y = coords.y,
                        z = coords.z,
                        w = GetEntityHeading(ped)
                    }
                }
                recipients[#recipients + 1] = src
            end
        end
    end

    for i = 1, #recipients do
        TriggerClientEvent('osp_ambulance:jobBlipsCl', recipients[i], dutyPlayers)
    end
end

local ATTENDING_BUSY_RADIUS = 5.0
local ATTENDING_HOSPITAL_RADIUS = 200.0

function GetHospitalCenter(hospital)
    if hospital.blip and hospital.blip.coords then
        local c = hospital.blip.coords
        return vector3(c.x, c.y, c.z)
    end
    if hospital.elevator and hospital.elevator[1] and hospital.elevator[1].floors and hospital.elevator[1].floors[1] and hospital.elevator[1].floors[1].coords then
        local c = hospital.elevator[1].floors[1].coords
        return vector3(c.x, c.y, c.z)
    end
    if hospital.duty and hospital.duty[1] then
        local d = hospital.duty[1]
        return vector3(d.x, d.y, d.z)
    end
    return nil
end

--- Location activity for attending board: available | busy | en_route | emergency
--- Busy when within 5m of blood donation / xray, or farther than 200m from nearest hospital.
local function GetAttendingActivityStatus(coords)
    if not coords or not Config.Hospitals then
        return 'available'
    end

    local nearestHospitalDist = nil

    for _, hospital in pairs(Config.Hospitals) do
        if hospital.donation then
            for _, donation in pairs(hospital.donation) do
                local c = donation.coords or donation
                if c and c.x then
                    if #(coords - vector3(c.x, c.y, c.z)) <= ATTENDING_BUSY_RADIUS then
                        return 'busy'
                    end
                end
            end
        end

        if hospital.Xray then
            for _, xray in pairs(hospital.Xray) do
                local c = xray.bedcoords
                if c then
                    if #(coords - vector3(c.x, c.y, c.z)) <= ATTENDING_BUSY_RADIUS then
                        return 'busy'
                    end
                end
            end
        end

        local center = GetHospitalCenter(hospital)
        if center then
            local dist = #(coords - center)
            if not nearestHospitalDist or dist < nearestHospitalDist then
                nearestHospitalDist = dist
            end
        end
    end

    if nearestHospitalDist and nearestHospitalDist > ATTENDING_HOSPITAL_RADIUS then
        return 'busy'
    end

    return 'available'
end

function FormatAttendingName(lastname)
    lastname = tostring(lastname or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if lastname == '' then
        return 'Dr. Unknown'
    end
    return 'Dr. ' .. lastname
end

function GetIncomingParamedicName(src)
    local sourcePlayer = GetPlayer(src)
    if not sourcePlayer then
        return FormatAttendingName(GetPlayerName(src))
    end

    local fw = GetActiveFramework()
    if fw == 'qb' or fw == 'qbox' then
        local charinfo = sourcePlayer.PlayerData and sourcePlayer.PlayerData.charinfo or {}
        return FormatAttendingName(charinfo.lastname)
    end

    local lastname = nil
    if sourcePlayer.get then
        lastname = sourcePlayer.get('lastName') or sourcePlayer.get('lastname')
    end
    if not lastname or lastname == '' then
        local full = sourcePlayer.name
        if sourcePlayer.getName then
            full = sourcePlayer.getName()
        end
        lastname = tostring(full or ''):match('(%S+)$') or full
    end
    return FormatAttendingName(lastname)
end

function UpdateAttendingRoster()
    local staff = {}
    local players = GetPlayers()
    local fw = GetActiveFramework()

    for _, v in pairs(players) do
        local sourcePlayer = GetPlayer(v)
        if sourcePlayer then
            local ped = GetPlayerPed(v)
            local coords = ped and ped ~= 0 and GetEntityCoords(ped) or nil
            local activity = GetAttendingActivityStatus(coords)

            if fw == 'qb' or fw == 'qbox' then
                local job = sourcePlayer.PlayerData and sourcePlayer.PlayerData.job
                if job then
                    for _, jobName in pairs(Config.AmbulanceJobs) do
                        if job.name == jobName then
                            local charinfo = sourcePlayer.PlayerData.charinfo or {}
                            staff[#staff + 1] = {
                                name = FormatAttendingName(charinfo.lastname),
                                grade = (job.grade and job.grade.name) or 'EMS',
                                onduty = job.onduty == true,
                                status = activity,
                                job = job.name,
                            }
                            break
                        end
                    end
                end
            else
                local job = sourcePlayer.job
                if job then
                    for _, jobName in pairs(Config.AmbulanceJobs) do
                        if job.name == jobName then
                            local src = tonumber(v)
                            local lastname = nil
                            if sourcePlayer.get then
                                lastname = sourcePlayer.get('lastName') or sourcePlayer.get('lastname')
                            end
                            if not lastname or lastname == '' then
                                local full = sourcePlayer.name
                                if sourcePlayer.getName then
                                    full = sourcePlayer.getName()
                                end
                                lastname = tostring(full or ''):match('(%S+)$') or full
                            end
                            staff[#staff + 1] = {
                                name = FormatAttendingName(lastname),
                                grade = job.grade_label or 'EMS',
                                onduty = src ~= nil and Doctors[src] == true,
                                status = activity,
                                job = job.name,
                            }
                            break
                        end
                    end
                end
            end
        end
    end

    table.sort(staff, function(a, b)
        if a.onduty ~= b.onduty then
            return a.onduty
        end
        return (a.name or '') < (b.name or '')
    end)

    TriggerClientEvent('osp_ambulance:attendingRoster', -1, staff)
end

CreateThread(function()
    Wait(2000)
    while true do
        if Config.JobBlips then
            UpdateBlips()
        end
        Wait(10*1000)
    end
end)

CreateThread(function()
    Wait(2000)
    while true do
        UpdateAttendingRoster()
        Wait(1*60*1000)
    end
end)

exports('GetAmbulanceData', function(playerid)
    if playerid and playerid ~= 0 then
        local ent = Player(playerid)
        local stat = ent.state.BodyDamage
        return stat
    else
        print('^1[ERROR] missing playerID for export function GetAmbulanceData! ^0')
    end
end)

RegisterServerEvent("osp_ambulance:SendTextMessageSv")
AddEventHandler("osp_ambulance:SendTextMessageSv", function(player, msgtitle, msg, time, type)
    TriggerClientEvent("osp_ambulance:SendTextMessage", player, msgtitle, msg, time, type)
end)

RegisterServerEvent("osp_ambulance:rewardBloodDonatorSv")
AddEventHandler("osp_ambulance:rewardBloodDonatorSv", function(donator)
    -- Add rewards for donating blood
end)

RegisterNetEvent("osp_ambulance:createWheelchairInteractionSv", function(netId)
    TriggerClientEvent('osp_ambulance:createWheelchairInteractionCl', -1, netId)
    RemoveItem(source, 'wheelchair', 1)
end)

RegisterNetEvent("osp_ambulance:pickupWheelchairSv", function(netId)
    local src = source
    if DoesEntityExist(NetworkGetEntityFromNetworkId(netId)) then
        DeleteEntity(NetworkGetEntityFromNetworkId(netId))
    end
    AddItem(src, 'wheelchair', 1)
end)

local function IsAmbulanceAdmin(source)
    if source == 0 then
        return true
    end

    if IsPlayerAceAllowed(source, 'osp_ambulance.admin') or IsPlayerAceAllowed(source, 'command') then
        return true
    end

    if IsFrameworkAdmin and IsFrameworkAdmin(source) then
        return true
    end

    if Config and Config.Debug then
        return true
    end

    return false
end

RegisterCommand('ambulanceconfig', function(source, args)
    if not IsAmbulanceAdmin(source) then
        return
    end

    TriggerClientEvent('osp_ambulance:configmenu', source)
end, false)

local function ApplySavedConfigToServer()
    Config = ConfigLoader.Load() or Config or {}
    ConfigLoader.PrepareServerConfig(Config)
end

-- Full client config exceeds TriggerClientEvent's size limit (network event overflow).
-- Never push GetClientPayload to clients: ask them to pull via ox_lib callback instead.
-- Location edits sync a tiny path/value delta so vector saves stay under the limit.
local function ForEachOtherPlayer(excludeSource, fn)
    for _, playerId in ipairs(GetPlayers()) do
        local id = tonumber(playerId)

        if id and id ~= excludeSource then
            fn(id)
        end
    end
end

local function BroadcastClientConfigReload(excludeSource)
    ForEachOtherPlayer(excludeSource, function(playerId)
        TriggerClientEvent('osp_ambulance:client:reloadConfig', playerId)
    end)
end

local function BroadcastLocationChange(excludeSource, change)
    ForEachOtherPlayer(excludeSource, function(playerId)
        TriggerClientEvent('osp_ambulance:client:locationChanged', playerId, change)
    end)
end

local function SafeNormalizeAndSave(resourceName, changedKeys)
    local normalizeOk, normalizeErr = pcall(function()
        LocationVectors.NormalizeConfig(Config)
    end)

    if not normalizeOk then
        local message = tostring(normalizeErr)
        print(('^1[osp_ambulance] Config normalize crashed: %s^0'):format(message))
        return false, 'normalize_failed'
    end

    local saved, saveResult = ConfigWriter.Save(resourceName, Config, changedKeys)
    return saved, saveResult
end

lib.callback.register('osp_ambulance:saveConfig', function(source, saveTable)
    local ok, result = pcall(function()
        if not IsAmbulanceAdmin(source) then
            return { ok = false, error = 'not_authorized' }
        end

        if type(ConfigWriter) ~= 'table' or not ConfigWriter.Save then
            return { ok = false, error = 'config_writer_missing' }
        end

        local resourceName = GetCurrentResourceName()

        for key, value in pairs(saveTable or {}) do
            Config[key] = value
        end

        local saved, saveResult = SafeNormalizeAndSave(resourceName, saveTable)

        if not saved then
            print(('^1[osp_ambulance] Failed to save config to config/ files: %s^0'):format(saveResult or 'unknown_error'))
            return { ok = false, error = saveResult or 'save_failed' }
        end

        ApplySavedConfigToServer()
        print(('^2[osp_ambulance] Config saved to config/ files (%s).^0'):format(table.concat(saveResult, ', ')))
        BroadcastClientConfigReload(source)

        return { ok = true, files = saveResult }
    end)

    if not ok then
        print(('^1[osp_ambulance] saveConfig callback crashed: %s^0'):format(tostring(result)))
        return { ok = false, error = 'save_callback_crashed' }
    end

    return result
end)

-- Path-only location saves avoid round-tripping the full Hospitals table (which can
-- reshuffle array indexes over the network and renumber beds in the configurator).
lib.callback.register('osp_ambulance:saveLocation', function(source, payload)
    local ok, result = pcall(function()
        if not IsAmbulanceAdmin(source) then
            return { ok = false, error = 'not_authorized' }
        end

        if type(ConfigWriter) ~= 'table' or not ConfigWriter.Save then
            return { ok = false, error = 'config_writer_missing' }
        end

        if type(payload) ~= 'table' or type(payload.path) ~= 'string' or payload.value == nil then
            return { ok = false, error = 'invalid_location' }
        end

        local valueType = payload.valueType or 'vector3'

        if not LocationVectors.SetLocationValue(Config, payload.path, payload.value, valueType) then
            return { ok = false, error = 'invalid_path' }
        end

        local changedKeys = {}

        if payload.path:find('^JailBeds%.') then
            changedKeys.JailBeds = Config.JailBeds
        else
            changedKeys.Hospitals = Config.Hospitals
        end

        local resourceName = GetCurrentResourceName()
        local saved, saveResult = SafeNormalizeAndSave(resourceName, changedKeys)

        if not saved then
            print(('^1[osp_ambulance] Failed to save location to config/ files: %s^0'):format(saveResult or 'unknown_error'))
            return { ok = false, error = saveResult or 'save_failed' }
        end

        ApplySavedConfigToServer()
        print(('^2[osp_ambulance] Location saved (%s) to %s.^0'):format(payload.path, table.concat(saveResult, ', ')))
        BroadcastLocationChange(source, {
            action = 'set',
            path = payload.path,
            value = payload.value,
            valueType = valueType,
        })

        return { ok = true, files = saveResult }
    end)

    if not ok then
        print(('^1[osp_ambulance] saveLocation callback crashed: %s^0'):format(tostring(result)))
        return { ok = false, error = 'save_callback_crashed' }
    end

    return result
end)

local function SaveLocationStructureChange(source, payload, action)
    local ok, result = pcall(function()
        if not IsAmbulanceAdmin(source) then
            return { ok = false, error = 'not_authorized' }
        end

        if type(ConfigWriter) ~= 'table' or not ConfigWriter.Save then
            return { ok = false, error = 'config_writer_missing' }
        end

        if type(payload) ~= 'table' then
            return { ok = false, error = 'invalid_location' }
        end

        local mutateOk, changedKey

        if action == 'add' then
            if type(payload.categoryKey) ~= 'string' then
                return { ok = false, error = 'invalid_location' }
            end

            mutateOk, changedKey = LocationVectors.AddLocation(Config, payload)
        else
            if type(payload.path) ~= 'string' then
                return { ok = false, error = 'invalid_location' }
            end

            mutateOk, changedKey = LocationVectors.RemoveLocation(Config, payload.path)
        end

        if not mutateOk or not changedKey then
            return { ok = false, error = action == 'add' and 'add_failed' or 'remove_failed' }
        end

        local changedKeys = {
            [changedKey] = Config[changedKey],
        }

        local resourceName = GetCurrentResourceName()
        local saved, saveResult = SafeNormalizeAndSave(resourceName, changedKeys)

        if not saved then
            print(('^1[osp_ambulance] Failed to %s location in config/ files: %s^0'):format(action, saveResult or 'unknown_error'))
            return { ok = false, error = saveResult or 'save_failed' }
        end

        ApplySavedConfigToServer()
        print(('^2[osp_ambulance] Location %s (%s) saved to %s.^0'):format(
            action,
            action == 'add' and tostring(payload.categoryKey) or tostring(payload.path),
            table.concat(saveResult, ', ')
        ))

        if action == 'add' then
            BroadcastLocationChange(source, {
                action = 'add',
                hospitalIndex = payload.hospitalIndex,
                categoryKey = payload.categoryKey,
                elevatorIndex = payload.elevatorIndex,
                coords = payload.coords,
            })
        else
            BroadcastLocationChange(source, {
                action = 'remove',
                path = payload.path,
            })
        end

        return { ok = true, files = saveResult }
    end)

    if not ok then
        print(('^1[osp_ambulance] %sLocation callback crashed: %s^0'):format(action, tostring(result)))
        return { ok = false, error = 'save_callback_crashed' }
    end

    return result
end

lib.callback.register('osp_ambulance:addLocation', function(source, payload)
    return SaveLocationStructureChange(source, payload, 'add')
end)

lib.callback.register('osp_ambulance:removeLocation', function(source, payload)
    return SaveLocationStructureChange(source, payload, 'remove')
end)