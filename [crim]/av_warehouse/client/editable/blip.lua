local blips = {}

function createBlip(x, y, z, identifier)
    dbug('createBlip(x,y,z,identifier)',x,y,z,identifier)
    if not identifier then return end
    if blips[identifier] and DoesBlipExist(blips[identifier]) then
        RemoveBlip(blips[identifier])
    end
    local blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip, Config.Blip and Config.Blip['sprite'] or 473)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, Config.Blip and Config.Blip['color'] or 1)
    SetBlipAlpha(blip, 200)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip and Config.Blip['label'] or 'Warehouse')
    EndTextCommandSetBlipName(blip)
    blips[identifier] = blip
end

function removeBlip(identifier)
    dbug('removeBlip(identifier)', identifier)
    if not identifier then return end
    if blips[identifier] and DoesBlipExist(blips[identifier]) then
        RemoveBlip(blips[identifier])
        blips[identifier] = nil
    end
end