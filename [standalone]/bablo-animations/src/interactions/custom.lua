Interaction = Interaction or {}

if IsDuplicityVersion() then return end

CreateThread(function()
    if Config.Interaction ~= "custom" then return end

    --[[
        CUSTOM INTERACTION IMPLEMENTATION

        Edit these functions to use your own TextUI / notification system.
        Examples: DrawText, custom NUI, qb-core DrawText, etc.

        Available functions to implement:
        - Interaction.ShowTextUI(text, options)
        - Interaction.HideTextUI()
        - Interaction.IsOpen()
        - Interaction.ShowQuestion(text)
        - Interaction.HideQuestion()
        - Interaction.ShowInfo(text)
        - Interaction.HideInfo()
        - Interaction.ShowHelp(toggle)
        - Interaction.HideHelp()
    ]]

    local isShowing = false

    function Interaction.ShowTextUI(text, options)
        -- Example: exports['your-resource']:ShowTextUI(text)
        -- Using ox_lib as fallback
        lib.showTextUI(text, options)
        isShowing = true
    end

    function Interaction.HideTextUI()
        -- Example: exports['your-resource']:HideTextUI()
        lib.hideTextUI()
        isShowing = false
    end

    function Interaction.IsOpen()
        return isShowing
    end

    function Interaction.ShowQuestion(text)
        -- Example: exports['your-resource']:ShowQuestion(text)
        lib.showTextUI('[E] ' .. Translate('ACCEPT') .. ' | [G] ' .. Translate('DENY') .. '\n' .. text, {
            position = 'top-center',
            icon = 'question'
        })
    end

    function Interaction.HideQuestion()
        -- Example: exports['your-resource']:HideQuestion()
        lib.hideTextUI()
    end

    function Interaction.ShowInfo(text)
        -- Example: exports['your-resource']:ShowInfo(text)
        lib.showTextUI(text, {
            position = 'right-center',
            icon = 'info'
        })
    end

    function Interaction.HideInfo()
        -- Example: exports['your-resource']:HideInfo()
        lib.hideTextUI()
    end

    function Interaction.ShowHelp(toggle)
        -- Example: exports['your-resource']:ShowHelp(toggle)
        if toggle then
            lib.showTextUI(Translate('PLACE_HELP_TEXT') or 'Use controls to adjust position', {
                position = 'left-center',
                icon = 'circle-info'
            })
        else
            lib.hideTextUI()
        end
    end

    function Interaction.HideHelp()
        -- Example: exports['your-resource']:HideHelp()
        lib.hideTextUI()
    end

    function Interaction.ShowEditAnim(toggle)
        -- Example: exports['your-resource']:ShowEditAnim(toggle)
        if toggle then
            local controlsText = string.format(
                '[W/A/S/D] %s\n[Q/Z] %s\n[Scroll] %s\n[PgUp/PgDn] %s\n[E] %s | [ESC] %s',
                Translate('EDIT_MOVE') or 'Move',
                Translate('EDIT_HEIGHT') or 'Height',
                Translate('EDIT_ROTATE') or 'Rotate',
                Translate('EDIT_PITCH') or 'Pitch',
                Translate('EDIT_CONFIRM') or 'Confirm',
                Translate('EDIT_CANCEL') or 'Cancel'
            )
            lib.showTextUI(controlsText, {
                position = 'left-center',
                icon = 'arrows-up-down-left-right'
            })
        else
            lib.hideTextUI()
        end
    end

    function Interaction.HideEditAnim()
        -- Example: exports['your-resource']:HideEditAnim()
        lib.hideTextUI()
    end

    function Interaction.ShowSitPrompt(toggle)
        -- Example: exports['your-resource']:ShowSitPrompt(toggle)
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
        -- Example: exports['your-resource']:HideSitPrompt()
        lib.hideTextUI()
    end
end)
