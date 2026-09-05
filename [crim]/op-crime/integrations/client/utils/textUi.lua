local textUiLastText = ""

function showTextUi(text, icon, coords, disableE)
    coords = coords or GetEntityCoords(PlayerPedId())

    if Config.TextUI == "jg-textui" then
        text = disableE and text or "[E] " .. text
        exports['jg-textui']:DrawText(text)
    elseif Config.TextUI == "okokTextUI" then
        if textUiLastText ~= text then
            textUiLastText = text
            exports['okokTextUI']:Open(text, 'darkblue', 'right')
        end
    elseif Config.TextUI == "brutal_textui" then
        exports['brutal_textui']:Open(text, "blue")
    elseif Config.TextUI == "ox_lib" then
        text = disableE and text or "[E] " .. text
        lib.showTextUI(text, {
            position = 'left-center',
            icon = icon
        })
    elseif Config.TextUI == "0r-textui" then
        exports['0r-textui']:AddClassic(coords, '(E)', text, 2.5)
    end
end

function hideTextUI() 
    if Config.TextUI == "jg-textui" then
        exports['jg-textui']:HideText()
    elseif Config.TextUI == "okokTextUI" then
        exports['okokTextUI']:Close()
    elseif Config.TextUI == "brutal_textui" then
        exports['brutal_textui']:Close()
    elseif Config.TextUI == "ox_lib" then
        lib.hideTextUI()
    end
end