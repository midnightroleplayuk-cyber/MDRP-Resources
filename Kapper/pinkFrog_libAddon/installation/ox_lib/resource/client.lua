--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

local _registerCommand = RegisterCommand

---@param commandName string
---@param callback fun(source, args, raw)
---@param restricted boolean?
function RegisterCommand(commandName, callback, restricted)
	_registerCommand(commandName, function(source, args, raw)
		if not restricted or lib.callback.await('ox_lib:checkPlayerAce', 100, ('command.%s'):format(commandName)) then
			callback(source, args, raw)
		end
	end)
end

local function buildConfig()
    local cfg = exports['pinkFrog_libAddon']:getAcutalSettings()
    return {
        primaryColor      = GetConvar('ox:primaryColor', 'blue'),
        primaryShade      = GetConvarInt('ox:primaryShade', 8),
        useFastHotkeys    = cfg.useFastHotkeys == true,
        mainAccent        = cfg.mainAccent,
        secondaryColor    = cfg.secondaryColor,
        allIconsWhite     = cfg.allIconsWhite == true,
        sharpBorders      = cfg.sharpBorders == true,
        serverName             = cfg.serverName,
        labelSkillCheckTitle   = cfg.labelSkillCheckTitle,
        labelSkillCheckSurvive = cfg.labelSkillCheckSurvive,
        notifSound             = cfg.notifSound,
        notifSoundVolume       = cfg.notifSoundVolume,
        dialogOverlay          = cfg.dialogOverlay ~= false,
        radialStyle            = cfg.radialStyle,
        notifPreviewTitle      = cfg.Locales and cfg.Locales.notifTitle,
        notifPreviewDesc       = cfg.Locales and cfg.Locales.notifDesc,
        notifTitleInfo         = cfg.Locales and cfg.Locales.notifTitleInfo,
        notifTitleSuccess      = cfg.Locales and cfg.Locales.notifTitleSuccess,
        notifTitleWarning      = cfg.Locales and cfg.Locales.notifTitleWarning,
        notifTitleError        = cfg.Locales and cfg.Locales.notifTitleError,
    }
end

RegisterNUICallback('getConfig', function(_, cb)
    cb(buildConfig())
end)

AddEventHandler('ox_lib:updateConfig', function()
    SendNUIMessage({
        action = 'updateConfig',
        data   = buildConfig(),
    })
end)

-- Live preview: called while config inputDialog is open (field change)
RegisterNUICallback('inputLivePreview', function(data, cb)
    if type(data) ~= 'table' or #data < 8 then cb('') return end
    local cfg = exports['pinkFrog_libAddon']:getAcutalSettings()
    SendNUIMessage({
        action = 'updateConfig',
        data = {
            primaryColor           = GetConvar('ox:primaryColor', 'blue'),
            primaryShade           = GetConvarInt('ox:primaryShade', 8),
            useFastHotkeys         = data[1] == true,
            allIconsWhite          = data[2] == true,
            sharpBorders           = data[3] == true,
            dialogOverlay          = data[4] == true,
            radialStyle            = data[5],
            notifSound             = data[6],
            notifSoundVolume       = tonumber(data[7]) or 50,
            mainAccent             = data[8],
            secondaryColor         = data[9],
            serverName             = cfg.serverName,
            labelSkillCheckTitle   = cfg.labelSkillCheckTitle,
            labelSkillCheckSurvive = cfg.labelSkillCheckSurvive,
            notifPreviewTitle      = cfg.Locales and cfg.Locales.notifTitle,
            notifPreviewDesc       = cfg.Locales and cfg.Locales.notifDesc,
            notifTitleInfo         = cfg.Locales and cfg.Locales.notifTitleInfo,
            notifTitleSuccess      = cfg.Locales and cfg.Locales.notifTitleSuccess,
            notifTitleWarning      = cfg.Locales and cfg.Locales.notifTitleWarning,
            notifTitleError        = cfg.Locales and cfg.Locales.notifTitleError,
        }
    })
    cb('')
end)

-- Live preview cancelled — restore real config from storage
RegisterNUICallback('inputLivePreviewCancel', function(_, cb)
    SendNUIMessage({ action = 'updateConfig', data = buildConfig() })
    cb('')
end)
