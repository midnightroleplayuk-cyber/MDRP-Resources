-- This function is responsible for creating the text shown on the bottom of the screen
function DrawMissionText(text, time)
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time or 30000, 1)
end

function TextInput(maxLen)
    DisplayOnscreenKeyboard(10, "FMMC_KEY_TIP9N", "", "", "", "", "", maxLen or 16)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(1);
    end
    if (GetOnscreenKeyboardResult()) then
        return GetOnscreenKeyboardResult()
    end

    return nil
end

-- This function is responsible for drawing all the 3d texts ('Press [E] to open bag' e.g)
function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Triggered when bag gets opened
function OnBadOpened()

end


-- Triggered when bag gets closed
function OnBagClosed()

end

function OnPlayerApplyOutfit(oData, name)
    --
    if Config.clothingSystemSaving and Config.clothingSystemSaving.enabled then
        local system = Config.clothingSystemSaving.system
        if system == 'op-clothing' then
            -- KQ Outfitbag has already applied the outfit at this point.
            -- Give the ped a moment to finish updating, then persist the
            -- current appearance through OP Clothing.
            Wait(250)
            exports['op-clothing']:SaveAppearance()
        elseif system == 'illenium-appearance' then
            local appearance = exports['illenium-appearance']:getPedAppearance(PlayerPedId())

            TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
        elseif system == 'fivem-appearance' then
            local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

            TriggerServerEvent("fivem-appearance:server:saveAppearance", appearance)
        elseif Contains({'qb-clothing', 'codem-appearance'}, system) then
            local drawable = oData.drawable
            local props = oData.props

            local skin = {
                outfitData = {
                    ['t-shirt'] = { item = drawable.undershirt.drawable, texture = drawable.undershirt.texture },
                    ['torso2'] = { item = drawable.tops.drawable, texture = drawable.tops.texture },
                    ['ear'] = { item = props.ear.prop, texture = props.ear.texture },
                    ['decals'] = { item = drawable.decals.drawable, texture = drawable.decals.texture },
                    ['mask'] = { item = drawable.mask.drawable, texture = drawable.mask.texture },
                    ['arms'] = { item = drawable.torso.drawable, texture = drawable.torso.texture },
                    ['pants'] = { item = drawable.legs.drawable, texture = drawable.legs.texture },
                    ['shoes'] = { item = drawable.feet.drawable, texture = drawable.feet.texture },
                    ['hat'] = { item = props.helmet.drawable, texture = props.helmet.texture },
                    ['accessory'] = { item = drawable.accessory.drawable, texture = drawable.accessory.texture },
                    ['bag'] = { item = drawable.bag.drawable, texture = drawable.bag.texture },
                    ['glass'] = { item = props.glasses.drawable, texture = props.glasses.texture },
                    ['vest'] = { item = drawable.chest.drawable, texture = drawable.chest.texture },
                }
            }
            TriggerEvent('qb-clothing:client:loadOutfit', skin)
        elseif system == 'rcore_clothing' then
            TriggerEvent('rcore_clothing:saveCurrentSkin')
        elseif system == '17mov_CharacterSystem' then
            TriggerEvent("17mov_CharacterSystem:SaveCurrentSkin")
        end
    end
end


if Config.debug then
    RegisterCommand('outfit-output', function(source, args)
        TriggerServerEvent('kq_outfitbag2:server:log', GetCurrentOutfitData(), args[1] or GetGameTimer())
    end)
end
