local numpad = {
    {'NUM0', 'NUMPAD0', 'INSERT'}, {'NUM1', 'NUMPAD1', 'END'},
    {'NUM2', 'NUMPAD2', 'ARROWDOWN'}, {'NUM3', 'NUMPAD3', 'PAGEDOWN'},
    {'NUM4', 'NUMPAD4', 'ARROWLEFT'}, {'NUM5', 'NUMPAD5', 'CLEAR'},
    {'NUM6', 'NUMPAD6', 'ARROWRIGHT'}, {'NUM7', 'NUMPAD7', 'HOME'},
    {'NUM8', 'NUMPAD8', 'ARROWUP'}, {'NUM9', 'NUMPAD9', 'PAGEUP'},
    {'NUMDECIMAL', 'DECIMAL', 'DELETE'}, {'NUMADD', 'ADD', 'N+'},
    {'NUMSUBTRACT', 'SUBTRACT', 'N-'}, {'NUMMULTIPLY', 'MULTIPLY', 'N*'},
    {'NUMDIVIDE', 'DIVIDE', 'N/'}, {'NUMENTER', 'NUMPADENTER', 'NENTER'},
}
local navigation = {
    INSERT = 'INSERT', END = 'END', ARROWDOWN = 'DOWN', PAGEDOWN = 'PAGEDOWN',
    ARROWLEFT = 'LEFT', ARROWRIGHT = 'RIGHT', HOME = 'HOME', ARROWUP = 'UP',
    PAGEUP = 'PAGEUP', DELETE = 'DELETE',
}
local mouse = { MOUSE3 = 'MOUSE_MIDDLE', MOUSE4 = 'MOUSE_EXTRABTN1', MOUSE5 = 'MOUSE_EXTRABTN2' }
local normal = { I = true, J = true, O = true, K = true }
local native = {}
local menuInputs = {}
for _, item in ipairs(numpad) do
    native[item[1]], native[item[3]], native['SHIFT+' .. item[1]] = true, true, true
    menuInputs[item[1]], menuInputs['SHIFT+' .. item[1]] = true, true
end
for key in pairs(mouse) do
    native[key], native['SHIFT+' .. key] = true, true
    menuInputs[key], menuInputs['SHIFT+' .. key] = true, true
end
for key in pairs(normal) do native[key] = true end

local function shiftPressed()
    return IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21)
end

function Main:isNativeEmoteBind(key)
    return native[key:upper()] == true
end

function Main:isSupportedPlayTogetherBind(key)
    return type(key) == 'string' and menuInputs[key:upper()] == true
end

function Main:isSupportedWheelBind(key)
    if type(key) ~= 'string' then return false end
    key = key:upper()
    if native[key] then return true end
    for name, control in pairs(self.rawControls or {}) do
        if name:upper() == key and control < 1000 then return true end
    end
    return false
end

function Main:getWheelBindKeys()
    local keys, seen = {}, {}
    local function add(key)
        key = key:upper()
        if not seen[key] and self:isSupportedWheelBind(key) then
            keys[#keys + 1], seen[key] = key, true
        end
    end
    for key in pairs(self.rawControls or {}) do add(key) end
    for key in pairs(native) do add(key) end
    return keys
end

function Main:hasBindCapture()
    return self.inAction and (self.emoteBindCapture or self.emoteWheelCapture or self.playTogetherCapture)
end

function Main:setBindCapture(field, active)
    local ownsFocus = self.inAction == true and IsNuiFocused()
    local enabled = active == true and ownsFocus
    if enabled then
        self.emoteBindCapture, self.emoteWheelCapture, self.playTogetherCapture = false, false, false
    end
    self[field] = enabled
    if ownsFocus then SetNuiFocusKeepInput(true) end
end

function Main:handleMenuBindInput(key, legacy)
    if self.inAction and IsNuiFocused() then
        if self.emoteBindCapture then return false end
        if self.emoteWheelCapture then
            self:sendReactMessage('EMOTE_WHEEL_KEY_CAPTURED', {key = key})
        elseif self.playTogetherCapture then
            if menuInputs[key] then self:sendReactMessage('PLAY_TOGETHER_BUTTON_CAPTURED', {button = key}) end
        elseif self.settings and type(self.settings.playTogetherButton) == 'string'
            and self.settings.playTogetherButton:upper() == key and menuInputs[key] then
            self:sendReactMessage('PLAY_TOGETHER_TRIGGER', {key = key})
        end
        return true
    end
    if self:hasBindCapture() then return true end
    local wheelKey = self.settings and self.settings.emoteWheelKey
    if type(wheelKey) ~= 'string' or wheelKey == '' then return false end
    wheelKey = wheelKey:upper()
    local matches = wheelKey == key or (legacy and wheelKey == legacy and not key:find('SHIFT+', 1, true))
    if normal[key] and shiftPressed() then matches = false end
    if matches and Config.EmoteWheel and self.emoteInputWheel and not self.inAction
        and not IsPauseMenuActive() and (not IsNuiFocused() or self.emoteWheelOpen) then
        self.emoteInputWheel()
        return true
    end
    return false
end

function Main:canUseEmoteBind()
    return not Config.DisableKeybinds and not self.inAction and not self.emoteWheelOpen
        and not self.isBusy and not self.pedHandle and not IsNuiFocused() and not IsPauseMenuActive()
end

function Main:handleEmoteInput(key, legacy, needsShift, isNumpad)
    if (mouse[key] or isNumpad) and shiftPressed() then key = 'SHIFT+' .. key end
    if self:handleMenuBindInput(key, legacy) then return end
    if Config.DisableKeybinds or (isNumpad and Config.DisableNumpadKeybinds) then return end
    if self.emoteBindCapture and self.inAction and IsNuiFocused() then
        if not needsShift or shiftPressed() then
            self:sendReactMessage('EMOTE_BIND_CAPTURED', {key = key})
        end
        return
    end
    if not self:canUseEmoteBind() or (needsShift and not shiftPressed()) then return end
    local binds = self.currentBinds or {}
    local animation = binds[key]
    if not animation and legacy and shiftPressed() then animation = binds[legacy] end
    if animation then self:playAnimation(cache.ped, animation) end
end

function Main:registerEmoteInputKeys(openWheel)
    self.emoteInputWheel = openWheel
    for index, item in ipairs(numpad) do
        local key, parameter, legacy = table.unpack(item)
        local command = '___anim_' .. (index <= 10 and legacy or key)
        RegisterCommand(command, function() self:handleEmoteInput(key, legacy, false, true) end)
        RegisterKeyMapping(command, 'Bablo Emote: ' .. parameter, 'keyboard', parameter)
    end
    for key, parameter in pairs(navigation) do
        local bind = key
        local command = '___anim_nav_' .. bind
        RegisterCommand(command, function() self:handleEmoteInput(bind, nil, true, false) end)
        RegisterKeyMapping(command, 'Bablo Emote: Shift + ' .. parameter, 'keyboard', parameter)
    end
    for key, parameter in pairs(mouse) do
        local bind = key
        local command = '___anim_' .. bind
        RegisterCommand(command, function() self:handleEmoteInput(bind, nil, false, false) end)
        RegisterKeyMapping(command, 'Bablo Emote: ' .. bind, 'MOUSE_BUTTON', parameter)
    end
    for key in pairs(normal) do
        local bind = key
        self:registerKey('___anim_' .. bind, 'Bablo Emote: Shift + ' .. bind, bind, function()
            if shiftPressed() or self:hasBindCapture() then
                self:handleEmoteInput(bind, nil, true, false)
            elseif Config.EmoteWheel and openWheel and (self.emoteWheelOpen or not IsNuiFocused()) then
                local wheelKey = self.settings and self.settings.emoteWheelKey
                if wheelKey and wheelKey:upper() == bind then openWheel() end
            end
        end)
    end
end

RegisterNUICallback('SET_EMOTE_BIND_CAPTURE', function(data, cb)
    Main:setBindCapture('emoteBindCapture', data and data.active)
    cb(true)
end)

RegisterNUICallback('SET_EMOTE_WHEEL_CAPTURE', function(data, cb)
    Main:setBindCapture('emoteWheelCapture', data and data.active)
    cb(true)
end)
