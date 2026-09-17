-- Configurable server-side voice adapter used by dispatch and patrol.

MdtRadio = MdtRadio or {}

local adapters = {}

local function providerName()
    return (Config.Radio and Config.Radio.provider) or 'pma-voice'
end

local function channelEntry(channel)
    for _, entry in ipairs((Config.Radio and Config.Radio.channels) or {}) do
        if entry.channel == channel or tostring(entry.channel) == tostring(channel) then
            return entry
        end
    end
    return nil
end

local function providerConfig(name)
    if name == 'pma-voice' then return (Config.Radio and Config.Radio.pmaVoice) or {} end
    if name == 'saltychat' then return (Config.Radio and Config.Radio.saltyChat) or {} end
    return Config.Radio or {}
end

local function callAdapter(method, ...)
    local name = providerName()
    local adapter = adapters[name]
    if not adapter then return false, 'unsupported_radio_provider' end

    local ok, result, reason = pcall(method, ...)
    if not ok then
        print(('[wasabi_mdt] Radio adapter "%s" failed: %s'):format(name, tostring(result)))
        return false, 'radio_adapter_error'
    end
    if result ~= true then return false, reason or 'radio_switch_failed' end
    return true
end

---@param name string
---@param adapter table { available: function?, set: function, clear: function, get: function }
function MdtRadio.register(name, adapter)
    assert(type(name) == 'string' and name ~= '', 'radio adapter name must be a non-empty string')
    assert(type(adapter) == 'table', 'radio adapter must be a table')
    assert(type(adapter.set) == 'function', 'radio adapter requires set')
    assert(type(adapter.clear) == 'function', 'radio adapter requires clear')
    assert(type(adapter.get) == 'function', 'radio adapter requires get')
    adapters[name] = adapter
end

---@return boolean
---@return string?
function MdtRadio.available()
    if not Config.Radio or Config.Radio.enabled ~= true then return false, 'radio_disabled' end
    local name = providerName()
    local adapter = adapters[name]
    if not adapter then return false, 'unsupported_radio_provider' end
    if type(adapter.available) ~= 'function' then return true end

    local ok, available = pcall(adapter.available, providerConfig(name))
    if not ok or available ~= true then return false, 'radio_resource_unavailable' end
    return true
end

---@param source number
---@param channel number|string
---@return boolean
---@return string?
function MdtRadio.setPlayerChannel(source, channel)
    local available, reason = MdtRadio.available()
    if not available then return false, reason end
    local name = providerName()
    local adapter = adapters[name]
    local previous, readable = MdtRadio.getPlayerChannel(source)
    if readable ~= true then return false, 'radio_lookup_failed' end

    local switched, switchReason = callAdapter(adapter.set, source, channel, channelEntry(channel), providerConfig(name))
    if switched then return true end

    local restored
    if previous ~= nil then
        restored = callAdapter(adapter.set, source, previous, channelEntry(previous), providerConfig(name))
    else
        restored = callAdapter(adapter.clear, source, channel, channelEntry(channel), providerConfig(name))
    end
    if not restored then
        print(('[wasabi_mdt] Radio adapter "%s" could not roll back player %s after a failed switch'):format(name, source))
        return false, 'radio_rollback_failed'
    end
    return false, switchReason
end

---@param source number
---@param channel number|string|nil
---@return boolean
---@return string?
function MdtRadio.clearPlayerChannel(source, channel)
    local available, reason = MdtRadio.available()
    if not available then return false, reason end
    local name = providerName()
    local adapter = adapters[name]
    local previous, readable = MdtRadio.getPlayerChannel(source)
    if readable ~= true then return false, 'radio_lookup_failed' end

    local cleared, clearReason = callAdapter(adapter.clear, source, channel, channelEntry(channel), providerConfig(name))
    if cleared then return true end
    if previous == nil then return false, clearReason end

    local restored = callAdapter(adapter.set, source, previous, channelEntry(previous), providerConfig(name))
    if not restored then
        print(('[wasabi_mdt] Radio adapter "%s" could not roll back player %s after a failed clear'):format(name, source))
        return false, 'radio_rollback_failed'
    end
    return false, clearReason
end

---@param source number
---@return number|string|nil channel
---@return boolean available
function MdtRadio.getPlayerChannel(source)
    local available = MdtRadio.available()
    if not available then return nil, false end
    local name = providerName()
    local adapter = adapters[name]
    local ok, channel = pcall(adapter.get, source, (Config.Radio and Config.Radio.channels) or {}, providerConfig(name))
    if not ok then
        print(('[wasabi_mdt] Radio adapter "%s" lookup failed: %s'):format(name, tostring(channel)))
        return nil, false
    end
    return channel, true
end

local function resourceStarted(config, fallback)
    return GetResourceState(config.resource or fallback) == 'started'
end

MdtRadio.register('pma-voice', {
    available = function(config)
        return resourceStarted(config, 'pma-voice')
    end,
    set = function(source, channel, _, config)
        local numericChannel = tonumber(channel)
        if not numericChannel then return false, 'invalid_radio_channel' end
        local resource = config.resource or 'pma-voice'
        exports[resource]:setPlayerRadio(source, numericChannel)
        local player = Player(source)
        return player ~= nil and tonumber(player.state.radioChannel) == numericChannel
    end,
    clear = function(source, _, _, config)
        local resource = config.resource or 'pma-voice'
        exports[resource]:setPlayerRadio(source, 0)
        local player = Player(source)
        return player ~= nil and (tonumber(player.state.radioChannel) or 0) == 0
    end,
    get = function(source)
        local player = Player(source)
        local channel = player and tonumber(player.state.radioChannel) or 0
        return channel > 0 and channel or nil
    end,
})

local saltyLastChannel = {}

local function saltyName(channel, entry, config)
    if entry and type(entry.saltyChat) == 'string' and entry.saltyChat ~= '' then
        return entry.saltyChat
    end
    return (config.channelPrefix or 'MDT-') .. tostring(channel)
end

local function saltyHasPlayer(resource, channelName, source)
    local players = exports[resource]:GetPlayersInRadioChannel(channelName) or {}
    for _, playerSource in pairs(players) do
        if tonumber(playerSource) == tonumber(source) then return true end
    end
    return false
end

local function saltyKnownNames(source, config)
    local names, seen = {}, {}
    for _, entry in ipairs((Config.Radio and Config.Radio.channels) or {}) do
        local name = saltyName(entry.channel, entry, config)
        if not seen[name] then
            seen[name] = true
            names[#names + 1] = name
        end
    end
    local previous = saltyLastChannel[source]
    if previous and not seen[previous.name] then names[#names + 1] = previous.name end
    return names
end

MdtRadio.register('saltychat', {
    available = function(config)
        return resourceStarted(config, 'saltychat')
    end,
    set = function(source, channel, entry, config)
        local resource = config.resource or 'saltychat'
        local channelName = saltyName(channel, entry, config)

        local previousNames = {}
        for _, knownName in ipairs(saltyKnownNames(source, config)) do
            if saltyHasPlayer(resource, knownName, source) then
                previousNames[#previousNames + 1] = knownName
                exports[resource]:RemovePlayerRadioChannel(source, knownName)
            end
        end

        exports[resource]:SetPlayerRadioChannel(source, channelName, config.primary ~= false)
        if not saltyHasPlayer(resource, channelName, source) then
            for _, previousName in ipairs(previousNames) do
                exports[resource]:SetPlayerRadioChannel(source, previousName, config.primary ~= false)
                if saltyHasPlayer(resource, previousName, source) then break end
            end
            return false, 'radio_switch_failed'
        end
        saltyLastChannel[source] = { channel = channel, name = channelName }
        return true
    end,
    clear = function(source, channel, entry, config)
        local resource = config.resource or 'saltychat'
        local names = channel ~= nil and { saltyName(channel, entry, config) } or saltyKnownNames(source, config)
        for _, channelName in ipairs(names) do
            exports[resource]:RemovePlayerRadioChannel(source, channelName)
            if saltyHasPlayer(resource, channelName, source) then return false, 'radio_clear_failed' end
        end
        saltyLastChannel[source] = nil
        return true
    end,
    get = function(source, channels, config)
        local resource = config.resource or 'saltychat'
        for _, entry in ipairs(channels) do
            if saltyHasPlayer(resource, saltyName(entry.channel, entry, config), source) then
                return entry.channel
            end
        end
        local previous = saltyLastChannel[source]
        if previous and saltyHasPlayer(resource, previous.name, source) then
            return previous.channel
        end
        return nil
    end,
})

AddEventHandler('playerDropped', function()
    saltyLastChannel[source] = nil
end)
