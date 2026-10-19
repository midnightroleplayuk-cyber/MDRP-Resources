--[[
    Apex MDT - Client bootstrap
    Duty toggle + state, station/hospital blips, on/off-duty 3D markers,
    the /mdt + /duty commands and the open keybind.
]]

local function feat(k) return Config.features and Config.features[k] ~= false end

-- ═══════════════════════════════════════════════════════════
-- DUTY
-- ═══════════════════════════════════════════════════════════
Duty = Duty or {}
local onDuty = false
function Duty.IsOn() return onDuty end

function Duty.Set(state)
    onDuty = state == true
    if UI and UI.IsOpen() then UI.Push('dutyChanged', { duty = onDuty }) end
end

function Duty.Toggle()
    if not feat('enableDutyToggle') then return end
    local ok, newState = Apex.Callback('apex_mdt:toggleDuty', not onDuty)
    if ok then Duty.Set(newState) end
end

RegisterNetEvent('apex_mdt:forceDuty', function(state) Duty.Set(state) end)

-- ═══════════════════════════════════════════════════════════
-- STATION BLIPS + DUTY MARKERS
-- ═══════════════════════════════════════════════════════════
local stationBlips = {}

local function spawnStationBlips()
    if not feat('enableStationBlips') then return end
    for _, st in ipairs(Config.stations or {}) do
        if st.coords and st.blip then
            local b = AddBlipForCoord(st.coords.x, st.coords.y, st.coords.z)
            SetBlipSprite(b, st.blip.sprite or 60)
            SetBlipColour(b, st.blip.color or 29)
            SetBlipScale(b, st.blip.scale or 0.9)
            SetBlipAsShortRange(b, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(st.label or 'Station')
            EndTextCommandSetBlipName(b)
            stationBlips[#stationBlips + 1] = b
        end
    end
end

local function despawnStationBlips()
    for _, b in ipairs(stationBlips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    stationBlips = {}
end

-- 3D on/off-duty markers at each station - walk in + press E.
CreateThread(function()
    local key = 38 -- E
    while true do
        local wait = 1000
        if feat('enableDutyMarkers') and feat('enableDutyToggle') then
            local ped = PlayerPedId()
            local pc  = GetEntityCoords(ped)
            for _, st in ipairs(Config.stations or {}) do
                local m = st.duty or st.coords
                if m then
                    local d = #(pc - vector3(m.x, m.y, m.z))
                    if d < 12.0 then
                        wait = 0
                        DrawMarker(2, m.x, m.y, m.z + 0.6, 0,0,0, 0,0,0, 0.3,0.3,0.3,
                            31,94,255,180, false, true, 2, true, nil, nil, false)
                        if d < 1.4 then
                            local label = onDuty and ('[E] ' .. (L('ui_off_duty'))) or ('[E] ' .. (L('ui_on_duty')))
                            DrawText3D(m.x, m.y, m.z + 1.0, label)
                            if IsControlJustReleased(0, key) then Duty.Toggle() end
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    SetTextCentre(true)
    SetDrawOrigin(x, y, z, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

-- ═══════════════════════════════════════════════════════════
-- AUTO WEAPONS CALL (any player's gunfire -> 10-71 for the police CAD)
-- ═══════════════════════════════════════════════════════════
-- Up to 1.2.2 this polled IsPedShooting every 800 ms and only while the OWN
-- unit was on duty. IsPedShooting is only true for the frame(s) a round
-- leaves the barrel, so the poll missed nearly every shot, and a civilian's
-- gunfire was never looked at - the CAD never saw a "Shots Fired" call.
-- Now: every player runs the detector (Config.weaponsCall.shooters), the
-- per-frame check only runs while a weapon is in hand, one report per
-- cooldown. The server picks the police units and applies its own cooldown.
CreateThread(function()
    local last   = 0
    local ignore = {}
    for _, w in ipairs((Config.weaponsCall and Config.weaponsCall.ignoreWeapons) or {}) do
        ignore[joaat(w)] = true
    end
    while true do
        local wc   = Config.weaponsCall or {}
        local wait = 500
        if feat('enableAutoWeaponsCall') and (wc.shooters ~= 'units' or Duty.IsOn()) then
            local ped = PlayerPedId()
            if IsPedArmed(ped, 7) then       -- weapon in hand -> watch every frame
                wait = 0
                if IsPedShooting(ped) and (GetGameTimer() - last) > (tonumber(wc.cooldownMs) or 30000) then
                    local weapon = GetSelectedPedWeapon(ped)
                    local skip = ignore[weapon]
                        or (wc.ignoreSilenced ~= false and IsPedCurrentWeaponSilenced(ped))
                        or (wc.ignoreInVehicle == true and IsPedInAnyVehicle(ped, false))
                    if not skip then
                        last = GetGameTimer()
                        local c = GetEntityCoords(ped)
                        TriggerServerEvent('apex_mdt:shotsFired', {
                            coords   = { x = c.x, y = c.y, z = c.z },
                            location = GetStreetNameFromHashKey(GetStreetNameAtCoord(c.x, c.y, c.z)),
                            weapon   = weapon,
                        })
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- BOOT
-- ═══════════════════════════════════════════════════════════
CreateThread(function()
    Wait(800)
    SetNuiFocus(false, false)
    spawnStationBlips()
end)

RegisterNetEvent('esx:playerLoaded', function() despawnStationBlips(); spawnStationBlips() end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() despawnStationBlips(); spawnStationBlips() end)
AddEventHandler('onResourceStop', function(r) if r == GetCurrentResourceName() then despawnStationBlips() end end)

-- ═══════════════════════════════════════════════════════════
-- LIVE JOB SWITCH (police ↔ ambulance) - no reopen / restart
-- When the player's job changes we tell the server to drop stale duty/unit
-- state and, if the tablet is open, re-bootstrap it so the mode, theme,
-- department info and apps all switch to the new job immediately.
-- ═══════════════════════════════════════════════════════════
local function onJobChange()
    TriggerServerEvent('apex_mdt:jobChangedSv')
    if UI and UI.IsOpen() and UI.Refresh then UI.Refresh() end
end
RegisterNetEvent('esx:setJob',                function() onJobChange() end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function() onJobChange() end)
RegisterNetEvent('apex_mdt:jobChanged',       function() onJobChange() end)

-- ═══════════════════════════════════════════════════════════
-- COMMANDS + KEYBIND
-- ═══════════════════════════════════════════════════════════
RegisterCommand(Config.command or 'mdt', function() UI.OpenPanel() end, false)
RegisterCommand(Config.dutyCmd or 'duty', function() Duty.Toggle() end, false)
RegisterCommand(Config.panicCmd or 'panic', function() if Dispatch then Dispatch.Panic() end end, false)

if Config.keybind and Config.keybind.enable then
    RegisterKeyMapping('+apexmdt', Config.keybind.label or 'Open MDT Tablet', 'keyboard', Config.keybind.key or 'F6')
    RegisterCommand('+apexmdt', function() UI.OpenPanel() end, false)
    RegisterCommand('-apexmdt', function() end, false)
end
