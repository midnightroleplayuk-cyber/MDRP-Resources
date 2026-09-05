SH = SH or {}

function SH.addBlip(coords, blipId, blipColor, blipLabel, blipCategory)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, blipId)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.Blips.size)
    SetBlipColour(blip, blipColor)
    SetBlipAsShortRange(blip, true)

    if blipCategory then
        SetBlipCategory(blip, blipCategory)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blipLabel)
    EndTextCommandSetBlipName(blip)

    return blip
end