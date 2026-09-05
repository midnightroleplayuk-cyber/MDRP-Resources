--[[
    UI settings bridge — forwards ox_lib player settings (transparency, border
    radius, gradient, perspective) from KVP to the NUI on load and whenever
    the player saves changes via the /ox_lib command menu.
]]

local settings = require 'resource.settings'

---@return { transparency: number, borderRadius: number, gradientIntensity: number, perspective: string }
function lib.getUiSettings()
    return {
        transparency = math.max(50, settings.ui_transparency or 100),
        borderRadius = math.max(0, math.min(20, settings.ui_border_radius or 10)),
        gradientIntensity = math.max(0, math.min(100, settings.ui_gradient_intensity or 0)),
        perspective = settings.ui_perspective and settings.ui_perspective ~= '' and settings.ui_perspective or 'none',
    }
end

local function pushSettings(data)
    if data and next(data) then
        SendNUIMessage({
            action = 'uiSettings',
            data = data
        })
    end
end

RegisterNUICallback('getUiSettings', function(_, cb)
    cb(lib.getUiSettings())
end)

AddEventHandler('ox_lib:uiSettingsChanged', function(data)
    pushSettings(data)
end)

AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= cache.resource then return end

    SetTimeout(500, function()
        pushSettings(lib.getUiSettings())
    end)
end)
