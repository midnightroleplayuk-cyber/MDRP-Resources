Interaction = Interaction or {}

if IsDuplicityVersion() then return end

local ICON_LABELS = {
    SCROLL = 'Scroll',
    MOUSE = 'Mouse',
    LMB = 'Left Click',
    RMB = 'Right Click',
}

local function buildHelpText(phase)
    local items = {}

    if Config and Config.AnimPos then
        for _, entry in ipairs(Config.AnimPos) do
            if entry.type == 'help' and entry.phase == phase then
                items[#items + 1] = entry
            end
        end
    end

    if #items == 0 and Config and Config.AnimPosHelp then
        if phase == 'help' then
            items = Config.AnimPosHelp.helpItems or {}
        elseif phase == 'helpEdit' then
            items = Config.AnimPosHelp.editHelpItems or {}
        end
    end

    local lines = {}

    for _, item in ipairs(items) do
        local label = item.text
        if not label and item.textKey then
            label = Translate(item.textKey)
        end

        local key = item.key
        if not key and item.icon then
            key = ICON_LABELS[item.icon] or item.icon
        end

        if label and label ~= '' then
            if key and key ~= '' then
                lines[#lines + 1] = ('[%s]  %s'):format(key, label)
            else
                lines[#lines + 1] = label
            end
        end
    end

    if #lines == 0 then return nil end

    return table.concat(lines, '  \n')
end

CreateThread(function()
    if Config.Interaction ~= "ox_lib" then return end

    ---@class InteractionOptions
    ---@field position? '"right-center"' | '"left-center"' | '"top-center"' | '"bottom-center"'
    ---@field icon? string | table
    ---@field iconColor? string
    ---@field iconAnimation? '"spin"' | '"spinPulse"' | '"spinReverse"' | '"pulse"' | '"beat"' | '"fade"' | '"beatFade"' | '"bounce"' | '"shake"'
    ---@field style? table
    ---@field alignIcon? '"top"' | '"center"'

    function Interaction.ShowTextUI(text, options)
        lib.showTextUI(text, options)
    end

    function Interaction.HideTextUI()
        lib.hideTextUI()
    end

    function Interaction.IsOpen()
        return lib.isTextUIOpen()
    end

    function Interaction.ShowQuestion(text)
        lib.showTextUI('[E] ' .. Translate('ACCEPT') .. ' | [G] ' .. Translate('DENY') .. '\n' .. text, {
            position = 'top-center',
            icon = 'question'
        })
    end

    function Interaction.HideQuestion()
        lib.hideTextUI()
    end

    function Interaction.ShowInfo(text)
        lib.showTextUI('[G] ' .. text, {
            position = 'right-center',
        })
    end

    function Interaction.HideInfo()
        lib.hideTextUI()
    end

    function Interaction.ShowHelp(toggle)
        if toggle then
            local text = buildHelpText('help')
                or Translate('PLACE_HELP_TEXT')
                or 'Use controls to adjust position'
            lib.showTextUI(text, {
                position = GetHelpBarPosition(),
                icon = 'circle-info'
            })
        else
            lib.hideTextUI()
        end
    end

    function Interaction.HideHelp()
        lib.hideTextUI()
    end

    function Interaction.ShowEditAnim(toggle)
        if toggle then
            local controlsText = buildHelpText('helpEdit') or string.format(
                '[W/A/S/D] %s\n[Q/Z] %s\n[Scroll] %s\n[PgUp/PgDn] %s\n[E] %s | [ESC] %s',
                Translate('EDIT_MOVE') or 'Move',
                Translate('EDIT_HEIGHT') or 'Height',
                Translate('EDIT_ROTATE') or 'Rotate',
                Translate('EDIT_PITCH') or 'Pitch',
                Translate('EDIT_CONFIRM') or 'Confirm',
                Translate('EDIT_CANCEL') or 'Cancel'
            )
            lib.showTextUI(controlsText, {
                position = GetHelpBarPosition(),
                icon = 'arrows-up-down-left-right'
            })
        else
            lib.hideTextUI()
        end
    end

    function Interaction.HideEditAnim()
        lib.hideTextUI()
    end

    function Interaction.ShowSitPrompt(toggle)
        if toggle then
            lib.showTextUI('[X] ' .. (Translate('STAND_UP') or 'Stand Up'), {
                position = 'right-center',
                icon = 'chair'
            })
        else
            lib.hideTextUI()
        end
    end

    function Interaction.HideSitPrompt()
        lib.hideTextUI()
    end
end)
