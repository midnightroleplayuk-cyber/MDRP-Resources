--[[
    Dev MapScanner - Main Client
    Admin-only via txAdmin permissions (universal, no framework dependency)
]]

local isOpen = false
local lastScanReport = nil
local entityScanRadius = 100.0
local isAdmin = false

-- ══════════════════════════════════════════
--  Admin Check
-- ══════════════════════════════════════════

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end
    Wait(2000)
    TriggerServerEvent("mapscanner:checkAccess")
end)

RegisterNetEvent("mapscanner:accessGranted")
AddEventHandler("mapscanner:accessGranted", function()
    isAdmin = true
    TriggerEvent("chat:addSuggestion", "/mapscanner", "Toggle the Map Scanner UI (also F9)")
    TriggerEvent("chat:addSuggestion", "/mapscan", "Run a map scan and open the UI")
end)

RegisterNetEvent("mapscanner:accessDenied")
AddEventHandler("mapscanner:accessDenied", function()
    isAdmin = false
    if isOpen then
        SendNUIMessage({ action = "close" })
        SetNuiFocus(false, false)
        isOpen = false
    end
end)

-- ══════════════════════════════════════════
--  NUI Management
-- ══════════════════════════════════════════

local function OpenUI()
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open" })
end

local function CloseUI()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
end

-- ══════════════════════════════════════════
--  Commands
-- ══════════════════════════════════════════

RegisterCommand("mapscanner", function()
    if not isAdmin then return end
    if isOpen then
        CloseUI()
    else
        OpenUI()
        PerformScan()
    end
end, false)

RegisterCommand("mapscan", function()
    if not isAdmin then return end
    PerformScan()
    if not isOpen then
        OpenUI()
    end
end, false)

RegisterKeyMapping("mapscanner", "Toggle Map Scanner", "keyboard", "F9")

-- ══════════════════════════════════════════
--  Scan Logic
-- ══════════════════════════════════════════

function PerformScan()
    if not isAdmin then return end
    SendNUIMessage({ action = "scanStarted" })
    TriggerServerEvent("mapscanner:requestScan")
end

RegisterNetEvent("mapscanner:scanResults")
AddEventHandler("mapscanner:scanResults", function(report)
    lastScanReport = report
    SendNUIMessage({ action = "scanComplete", report = report })
end)

-- ══════════════════════════════════════════
--  Entity Scan
-- ══════════════════════════════════════════

function PerformEntityScan(radius)
    if not isAdmin then return end
    radius = radius or entityScanRadius
    SendNUIMessage({ action = "entityScanStarted" })

    Citizen.CreateThread(function()
        local entities = Scanner.ScanNearbyEntities(radius)
        local enriched = {}
        for _, ent in ipairs(entities) do
            table.insert(enriched, {
                type = ent.type,
                handle = ent.handle,
                model = string.format("0x%X", ent.model),
                modelDec = ent.model,
                coords = ent.coords,
                distance = math.floor(ent.distance * 100) / 100,
                source = Scanner.IdentifyEntitySource(ent.handle),
            })
        end
        SendNUIMessage({ action = "entityScanComplete", entities = enriched, radius = radius, count = #enriched })
    end)
end

-- ══════════════════════════════════════════
--  NUI Callbacks
-- ══════════════════════════════════════════

RegisterNUICallback("close", function(_, cb) CloseUI() cb("ok") end)
RegisterNUICallback("scan", function(_, cb) PerformScan() cb("ok") end)
RegisterNUICallback("scanEntities", function(data, cb)
    PerformEntityScan(tonumber(data.radius) or entityScanRadius)
    cb("ok")
end)

RegisterNUICallback("teleportTo", function(data, cb)
    if not isAdmin then cb("ok") return end
    if data.x and data.y and data.z then
        SetEntityCoords(PlayerPedId(), data.x + 0.0, data.y + 0.0, data.z + 0.0, false, false, false, false)
    end
    cb("ok")
end)

RegisterNUICallback("highlightEntity", function(data, cb)
    local handle = tonumber(data.handle)
    if handle and DoesEntityExist(handle) then
        Citizen.CreateThread(function()
            for i = 1, 10 do
                SetEntityAlpha(handle, 100, false)
                Wait(200)
                ResetEntityAlpha(handle)
                Wait(200)
            end
        end)
    end
    cb("ok")
end)

RegisterNUICallback("deleteEntity", function(data, cb)
    if not isAdmin then cb("ok") return end
    local handle = tonumber(data.handle)
    if handle and DoesEntityExist(handle) then
        SetEntityAsMissionEntity(handle, true, true)
        DeleteEntity(handle)
    end
    cb("ok")
end)

-- ══════════════════════════════════════════
--  3D Markers
-- ══════════════════════════════════════════

local showMarkers = false
local markerLocations = {}

RegisterNUICallback("toggleMarkers", function(data, cb)
    showMarkers = not showMarkers
    if data.locations then markerLocations = data.locations end
    cb(json.encode({ active = showMarkers }))
end)

Citizen.CreateThread(function()
    while true do
        if showMarkers and #markerLocations > 0 then
            local playerCoords = GetEntityCoords(PlayerPedId())
            for _, loc in ipairs(markerLocations) do
                if #(playerCoords - vector3(loc.x, loc.y, loc.z)) < 200.0 then
                    DrawMarker(1, loc.x, loc.y, loc.z + 2.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 50, 50, 150, true, false, 2, false, nil, nil, false)
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)
