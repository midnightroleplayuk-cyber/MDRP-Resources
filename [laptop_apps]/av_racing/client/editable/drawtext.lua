local textUI = {}

function DrawTextLib()
    if exports['av_laptop']:getUI() == "ox_lib" then
        exports['av_laptop']:hideTextUI()
        ClearTextUI()
        textUI[#textUI + 1] = (Lang['checkpoint']..': %s  \n'):format(#CreatorData.checkpoints)
        textUI[#textUI + 1] = Config.EditorKeys['add']['Label'].."  \n"
        textUI[#textUI + 1] = Config.EditorKeys['delete']['Label'].."  \n"
        textUI[#textUI + 1] = Config.EditorKeys['toggle']['Label'].."  \n"
        textUI[#textUI + 1] = Config.EditorKeys['distance']['Label'].."  \n"
        textUI[#textUI + 1] = Config.EditorKeys['rotate']['Label'].."  \n"
        textUI[#textUI + 1] = Config.EditorKeys['reset']['Label'].."  \n"
        if Config.Freecam and Config.Freecam.enabled then
            textUI[#textUI + 1] = Config.EditorKeys['model']['Label'].."  \n"
            textUI[#textUI + 1] = Config.EditorKeys['freecam']['Label']
        else
            textUI[#textUI + 1] = Config.EditorKeys['model']['Label']
        end
        exports['av_laptop']:showTextUI(table.concat(textUI))
    else
        local labels = {"add", "delete", "toggle", "distance", "rotate", "reset", "model"}
        if Config.Freecam and Config.Freecam.enabled then
            labels[#labels + 1] = "freecam"
        end
        local controls = {}
        for i=1,#labels do
            local key, text = parseMenuItem(Config.EditorKeys[labels[i]]['Label'])
            controls[i] = {label = text, keybind = key}
        end
        exports['av_laptop']:showTextUI((Lang['checkpoint']..': %s'):format(#CreatorData.checkpoints), {
            title = "Circuit Editor",
            options = controls
        })
    end
end

function ClearTextUI()
    textUI = {}
end

function clearAll()
    exports['av_laptop']:hideTextUI()
    redrawBlips()
end

function parseMenuItem(input)
    if not input then return nil, nil end
    local key, text = string.match(input, "^(%S+)%s*-%s*(.-)%s*$")
    if key and text then
        return key, text
    end
    return nil, input
end