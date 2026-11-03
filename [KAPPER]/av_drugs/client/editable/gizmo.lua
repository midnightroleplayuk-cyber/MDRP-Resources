local testObj = nil
local inObjectPreview = false

RegisterNetEvent('av_drugs:placeTable', function(itemName, identifier, model, slot)
    if LocalPlayer.state.busy then
        dbug("LocalPlayer.state.busy is true")
        return
    end
    if not canPlace() then return end
    if model and IsModelValid(tonumber(model)) then
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['table_notification'], "info")
        inObjectPreview = true
        dbug('av_drugs:placeTable', itemName, identifier, model)
        if testObj and DoesEntityExist(testObj) then
            DeleteEntity(testObj)
            SetEntityAsNoLongerNeeded(testObj)
            testObj = nil
        end
        lib.requestModel(joaat(model), 50000)
        testObj = CreateObject(model, GetEntityCoords(cache.ped), false, true, false)
        SetEntityAlpha(testObj, 200, false)
        SetEntityCollision(testObj, false, false)
        FreezeEntityPosition(testObj, true)
        StopEntityFire(testObj)
        PlaceObjectOnGroundProperly(testObj)
        if exports['av_laptop']:getUI() == "ox_lib" then
            local textUI = {}
            textUI[#textUI+1] = '[E] ' .. tostring(Lang['table_confirm'] or "Confirm") .. "  \n"
            textUI[#textUI+1] = '[G] ' .. tostring(Lang['table_rotate90'] or "Rotate 90") .. "  \n"
            textUI[#textUI+1] = '[L/R Arrow] ' .. tostring(Lang['table_rotate'] or "Rotate") .. "  \n"
            textUI[#textUI+1] = '[H] ' .. tostring(Lang['table_cancel'] or "Cancel")
            local finalString = table.concat(textUI)
            exports['av_laptop']:showTextUI(finalString)
        else
            exports['av_laptop']:showTextUI(Lang['table_header'] or "Drug Table",{
                options = {
                    {keybind = "G", label = Lang['table_rotate90'], icon = "fa-rotate"},
                    {keybind = "L/R Arrow", label = Lang['table_rotate'], icon = "fa-rotate"},
                    {keybind = "E", label = Lang['table_confirm'], icon = "fa-check", iconColor = "#63e6be"},
                    {keybind = "H", label = Lang['table_cancel'], icon = 'fa-xmark', iconColor = "#fa5252"},
                }
            })
        end
        CreateThread(function()
            dbug("Entered object preview loop")
            while inObjectPreview do
                local hit, _, coords, _, _ = lib.raycast.fromCamera(1, 4, 7)
                if hit then
                    SetEntityCoords(testObj, coords.x, coords.y, coords.z)
                    PlaceObjectOnGroundProperly(testObj)
                    -- Left
                    if IsControlPressed(0, 174) then
                        SetEntityHeading(testObj, GetEntityHeading(testObj) - 0.3)
                    end
                    -- Right
                    if IsControlPressed(0, 175) then
                        SetEntityHeading(testObj, GetEntityHeading(testObj) + 0.3)
                    end
                    -- G
                    if IsControlJustPressed(0, 47) then
                        SetEntityHeading(testObj, GetEntityHeading(testObj) + 90.0)
                    end
                    -- E
                    if IsControlPressed(0, 38) then
                        local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(testObj))
                        local rotation = GetEntityRotation(testObj, 2)
                        if testObj then
                            DeleteEntity(testObj)
                            testObj = nil
                        end
                        if dist >= 2 then
                            TriggerEvent('av_laptop:notification', Lang['table_distance'], 'error')
                            exports['av_laptop']:hideTextUI()
                            return
                        end
                        LocalPlayer.state.busy = true
                        FreezeEntityPosition(cache.ped,true)
                        TaskStartScenarioInPlace(cache.ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                        exports['av_laptop']:hideTextUI()
                        dbug("progressBar...")
                        local res = progressBar(false, false, Config.PlacingTime)
                        dbug('progressBar result', res)
                        FreezeEntityPosition(cache.ped,false)
                        ClearPedTasks(cache.ped)
                        lib.timer(500, function()
                            LocalPlayer.state.busy = false
                        end, true)
                        if res then
                            TriggerServerEvent('av_drugs:setTable', coords, rotation, itemName, identifier, model, slot)
                        end
                        inObjectPreview = false
                    end
                end
                -- H
                if IsControlPressed(0, 74) then
                    inObjectPreview = false
                    exports['av_laptop']:hideTextUI()
                    if testObj then
                        DeleteEntity(testObj)
                        testObj = nil
                    end
                end
                Wait(1)
            end
        end)
    else
        print("^1[ERROR] ^7Model for table "..itemName.." doesn't exist in game, this is NOT a script problem.")
        print("^1[ERROR] ^7Model for table "..itemName.." doesn't exist in game, this is NOT a script problem.")
        print("^1[ERROR] ^7Model for table "..itemName.." doesn't exist in game, this is NOT a script problem.")
    end
end)