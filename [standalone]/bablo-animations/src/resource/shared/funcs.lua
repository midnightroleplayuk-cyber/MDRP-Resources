Trace = function(...)
    if not Config.Debug then
        return
    end

    local logLine = ""
    local logString = { ... }

    if IsDuplicityVersion() then
        logLine = os.date('%Y-%m-%d %H:%M:%S', os.time())
    end

    logLine = logLine .. " [" .. (GetCurrentResourceName() or "LOG") .. "] "

    for i = 1, #logString do
        logLine = logLine .. tostring(logString[i]) .. " "
    end

    print(logLine)
end

Translate = function(key, args)
    if not Config.Locale then
        return key
    end

    local translation = Locales[Config.Locale][key]

    if not translation then
        return key
    else
        if args then
            for i = 1, #args do
                translation = translation:gsub("%%s", args[i], 1)
            end
        end
    end

    return translation
end

IsResourceStartedOrStarting = function(resource)
    local state = GetResourceState(resource)
    return state == "started" or state == "starting"
end

local HELP_BAR_POSITIONS = {
    ["bottom-center"] = true,
    ["top-center"] = true,
    ["left-center"] = true,
    ["right-center"] = true,
}

HELP_BAR_DEFAULT_POSITION = "bottom-center"

GetHelpBarPosition = function()
    local position = Config and Config.HelpBarPosition

    if type(position) == "string" and HELP_BAR_POSITIONS[position] then
        return position
    end

    return HELP_BAR_DEFAULT_POSITION
end

GenerateUniqueId = function()
    local id = ""

    for i = 1, 3 do
        id = id .. string.upper(string.gsub(string.format("%05d", math.random(0, 99999)), " ", "0"))
        if i < 3 then
            id = id .. "-"
        end
    end

    return id
end

if Config.Framework == "auto" then
    Trace("Detecting framework")
    if IsResourceStartedOrStarting("es_extended") then
        Config.Framework = "esx"
    elseif IsResourceStartedOrStarting("qbx_core") then
        Config.Framework = "qbox"
    elseif IsResourceStartedOrStarting("qb-core") then
        Config.Framework = "qbcore"
    else
        Config.Framework = "standalone"
    end
    Trace("Detected framework: " .. Config.Framework)
end

if not IsDuplicityVersion() then
    local stateBagStrictMode = nil
    local localStateBagValues = {}
    local localStateBagKnown = {}
    local localStateBagWatched = {}

    IsStateBagStrictMode = function()
        if stateBagStrictMode == nil then
            local convar = GetConvar('sv_stateBagStrictMode', 'false')
            stateBagStrictMode = convar == 'true' or convar == '1'
        end

        return stateBagStrictMode
    end

    local function watchLocalStateBag(bag)
        if localStateBagWatched[bag] then
            return
        end

        localStateBagWatched[bag] = true

        AddStateBagChangeHandler(bag, ('player:%s'):format(GetPlayerServerId(PlayerId())),
            function(bagName, key, value, _reserved, replicated)
                localStateBagValues[bag] = value
                localStateBagKnown[bag] = true
            end)
    end

    SetLocalStateBag = function(bag, value)
        watchLocalStateBag(bag)

        localStateBagValues[bag] = value
        localStateBagKnown[bag] = true

        if not IsStateBagStrictMode() then
            LocalPlayer.state[bag] = value
        end
    end

    GetLocalStateBag = function(bag)
        if localStateBagKnown[bag] then
            return localStateBagValues[bag]
        end

        watchLocalStateBag(bag)

        local value = LocalPlayer.state[bag]
        localStateBagValues[bag] = value
        localStateBagKnown[bag] = true

        return value
    end

    SetSharedStateBag = function(bag, value)
        if IsStateBagStrictMode() then
            TriggerServerEvent(eventName .. 'server:setPlayerStateBag', bag, value)
            return
        end

        LocalPlayer.state:set(bag, value, true)
    end

    SetSharedPedStateBag = function(ped, bag, value)
        if IsStateBagStrictMode() then
            if ped ~= cache.ped then
                return
            end

            TriggerServerEvent(eventName .. 'server:setPedStateBag', bag, value)
            return
        end

        Entity(ped).state:set(bag, value, true)
    end

    local textUIActive = false
    local currentTextUIText = nil

    ShowTextUI = function(text, options)
        if Interaction and Interaction.ShowTextUI then
            Interaction.ShowTextUI(text, options)
            textUIActive = true
            currentTextUIText = text
        end
    end

    HideTextUI = function()
        if Interaction and Interaction.HideTextUI then
            Interaction.HideTextUI()
            textUIActive = false
            currentTextUIText = nil
        end
    end

    ShowHelpText = function(text)
        if Interaction and Interaction.ShowTextUI then
            if not textUIActive or currentTextUIText ~= text then
                Interaction.ShowTextUI(text)
                textUIActive = true
                currentTextUIText = text
            end
        end
    end

    IsTextUIActive = function()
        if Interaction and Interaction.IsOpen then
            return Interaction.IsOpen()
        end
        return textUIActive
    end

    ShowQuestion = function(text)
        if Interaction and Interaction.ShowQuestion then
            Interaction.ShowQuestion(text)
        end
    end

    HideQuestion = function()
        if Interaction and Interaction.HideQuestion then
            Interaction.HideQuestion()
        end
    end

    ShowInfo = function(text)
        if Interaction and Interaction.ShowInfo then
            Interaction.ShowInfo(text)
        end
    end

    HideInfo = function()
        if Interaction and Interaction.HideInfo then
            Interaction.HideInfo()
        end
    end

    ShowHelp = function(toggle)
        if Interaction and Interaction.ShowHelp then
            Interaction.ShowHelp(toggle)
        end
    end

    HideHelp = function()
        if Interaction and Interaction.HideHelp then
            Interaction.HideHelp()
        end
    end

    ShowEditAnim = function(toggle)
        if Interaction and Interaction.ShowEditAnim then
            Interaction.ShowEditAnim(toggle)
        end
    end

    HideEditAnim = function()
        if Interaction and Interaction.HideEditAnim then
            Interaction.HideEditAnim()
        end
    end
end
