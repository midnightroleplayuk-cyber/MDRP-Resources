--[[
    Just an example to render graffiti blips on map
]]--
local useThis = false -- Set this to true if you want to use the example below, but make sure to read the comments and adjust it to your needs
local command = "gangs:blips" -- Command to toggle blips
local blipRadius = 50.0 -- Adjust the radius of the blips
local gangsColors = {
    -- Index key should be a gang name, and the value should be the blip color you want to use for that gang's graffiti blips
    -- All colors can be found here: https://docs.fivem.net/docs/game-references/blips/#blip-colors
    ['ballas'] = 1,
    ['families'] = 2,
    ['vagos'] = 3,
}
local blips = {}

if useThis then
    RegisterCommand(command, function()
        if not PlayerGang then
            TriggerEvent("av_laptop:notification",Lang['app_title'],Lang['not_now'],"error")
            return
        end
        if not ready then
            warn("The script isn't fully loaded, please use it again in a minute")
            return
        end
        local allGraffitis = lib.callback.await("av_gangs:getGraffitis")
        if blips and next(blips) then
            for identifier, v in pairs(blips) do
                if DoesBlipExist(v) then RemoveBlip(v) end
                blips[identifier] = nil
            end
        else
            blips = blips or {}
            for gang, data in pairs(allGraffitis) do
                for identifier, graffiti in pairs(data) do
                    local blip = AddBlipForRadius(graffiti['coords'].x, graffiti['coords'].y, graffiti['coords'].z, blipRadius or 25.0)
                    SetBlipAlpha(blip, 155)
                    SetBlipColour(blip, gangsColors[gang] or 1)
                    blips[identifier] = blip
                end
            end
        end
    end,false)
end

function refreshBlips()
    if not useThis then return end
    if blips and next(blips) then
        for identifier, v in pairs(blips) do
            if DoesBlipExist(v) then RemoveBlip(v) end
            blips[identifier] = nil
        end
        local allGraffitis = lib.callback.await("av_gangs:getGraffitis")
        if blips and next(blips) then
            for identifier, v in pairs(blips) do
                if DoesBlipExist(v) then RemoveBlip(v) end
                blips[identifier] = nil
            end
        else
            blips = blips or {}
            for gang, data in pairs(allGraffitis) do
                for identifier, graffiti in pairs(data) do
                    local blip = AddBlipForRadius(graffiti['coords'].x, graffiti['coords'].y, graffiti['coords'].z, blipRadius or 25.0)
                    SetBlipAlpha(blip, 155)
                    SetBlipColour(blip, gangsColors[gang] or 1)
                    blips[identifier] = blip
                end
            end
        end
    end
end