local function policeJob()
    local data = exports.qbx_core:GetPlayerData()
    return data and data.job and data.job.name == Config.PoliceJob and data.job.onduty == true
end

RegisterNetEvent('hf1_cellbuzz:client:policeAlert', function(stationId, buzzerName)
    if not policeJob() then return end
    lib.notify({ title = Config.Stations[stationId] and Config.Stations[stationId].label or 'Police Buzzer', description = ('Police Buzzer: %s requesting assistance.'):format(buzzerName), type = 'warning', duration = 7000 })
    if Config.SoundEnabled then
        SendNUIMessage({ action = 'play', volume = Config.SoundVolume })
    end
end)

local function openControl(stationId)
    if not policeJob() then return end
    local entries = lib.callback.await('hf1_cellbuzz:server:getControl', false, stationId)
    if not entries then
        lib.notify({ description = 'Unable to access the buzzer control.', type = 'error' })
        return
    end
    local station = Config.Stations[stationId]
    local options = {}
    for i, buzzer in ipairs(station.buzzers) do
        local entry = entries[i]
        local index = i
        options[#options + 1] = {
            title = buzzer.name,
            description = (entry.enabled and 'Enabled' or 'Disabled') .. (entry.pending and ' | ASSISTANCE REQUESTED' or ' | No active request'),
            icon = entry.pending and 'bell' or (entry.enabled and 'check' or 'ban'),
            onSelect = function()
                local submenu = 'hf1_cellbuzz:manage:' .. stationId .. ':' .. index
                lib.registerContext({
                    id = submenu,
                    title = buzzer.name,
                    menu = 'hf1_cellbuzz:control:' .. stationId,
                    options = {
                        { title = entry.enabled and 'Disable buzzer' or 'Enable buzzer', icon = 'power', onSelect = function()
                            TriggerServerEvent('hf1_cellbuzz:server:control', stationId, index, 'toggle')
                        end },
                        { title = 'Clear assistance request', icon = 'check-double', disabled = not entry.pending, onSelect = function()
                            TriggerServerEvent('hf1_cellbuzz:server:control', stationId, index, 'clear')
                        end }
                    }
                })
                lib.showContext(submenu)
            end
        }
    end
    local menuId = 'hf1_cellbuzz:control:' .. stationId
    lib.registerContext({ id = menuId, title = station.label .. ' | Buzzer Control', options = options })
    lib.showContext(menuId)
end

CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        local sid = stationId
        for i, buzzer in ipairs(station.buzzers) do
            local index = i
            exports.ox_target:addSphereZone({
                coords = buzzer.coords,
                radius = 0.55,
                debug = false,
                options = {{
                    name = 'hf1_cellbuzz:' .. sid .. ':' .. index,
                    icon = 'fa-solid fa-bell',
                    label = 'Press ' .. buzzer.name .. ' Buzzer',
                    distance = Config.BuzzerInteractDistance,
                    onSelect = function() TriggerServerEvent('hf1_cellbuzz:server:press', sid, index) end
                }}
            })
        end
        exports.ox_target:addSphereZone({
            coords = station.control,
            radius = 0.65,
            debug = false,
            options = {{
                name = 'hf1_cellbuzz:control:' .. sid,
                icon = 'fa-solid fa-sliders',
                label = 'Buzzer Control',
                distance = Config.ControlInteractDistance,
                canInteract = function() return policeJob() end,
                onSelect = function() openControl(sid) end
            }}
        })
    end
end)
