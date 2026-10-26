Interaction = Interaction or {}

if IsDuplicityVersion() then return end

CreateThread(function()
    if Config.Interaction ~= "default" then return end

    local isShowing = false
    local currentText = ""

    function Interaction.ShowTextUI(text, options)
        currentText = text
        if not isShowing then
            isShowing = true
            CreateThread(function()
                while isShowing do
                    SetTextComponentFormat("STRING")
                    AddTextComponentSubstringPlayerName(currentText)
                    DisplayHelpTextFromStringLabel(0, false, true, -1)
                    Wait(0)
                end
            end)
        end
    end

    function Interaction.HideTextUI()
        isShowing = false
        currentText = ""
    end

    function Interaction.IsOpen()
        return isShowing
    end

    function Interaction.ShowQuestion(text)
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showQuestion',
            toggle = true
        })
        Main:sendReactMessage('SET_MENU', {
            questionText = text
        })
    end

    function Interaction.HideQuestion()
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showQuestion',
            toggle = false
        })
    end

    function Interaction.ShowInfo(text)
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showInfo',
            toggle = true
        })
        Main:sendReactMessage('SET_INFO', {
            infoText = text
        })
    end

    function Interaction.HideInfo()
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showInfo',
            toggle = false
        })
    end

    function Interaction.ShowHelp(toggle)
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showHelp',
            toggle = toggle
        })
    end

    function Interaction.HideHelp()
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showHelp',
            toggle = false
        })
    end

    function Interaction.ShowEditAnim(toggle)
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showEditAnim',
            toggle = toggle
        })
    end

    function Interaction.HideEditAnim()
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showEditAnim',
            toggle = false
        })
    end

    function Interaction.ShowSitPrompt(toggle)
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showSitPrompt',
            toggle = toggle
        })
    end

    function Interaction.HideSitPrompt()
        Main:sendReactMessage('SHOW_MENU', {
            element = 'showSitPrompt',
            toggle = false
        })
    end
end)
