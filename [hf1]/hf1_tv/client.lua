local state = nil
local runtimeName = 'qb_tv_diag_' .. tostring(GetPlayerServerId(PlayerId()))
local textureName = 'screen'
local dictName = runtimeName
local width, height = 1280, 720
local preview = nil

local function log(message)
    print(('[qb_tv_stage1] %s'):format(message))
end

local function notify(message)
    log(message)
    TriggerEvent('chat:addMessage', { args = { 'TV Test', message } })
end

local function safeNative(fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then log('Native failed: ' .. tostring(result)) end
    return ok, result
end

local function stopTest()
    if not state then return end
    local old = state
    state = nil -- stop draw thread before releasing handles
    Wait(100)
    if old.dui then safeNative(DestroyDui, old.dui) end
    -- Do not release a model-wide named render target while another resource might use it.
    log('Test stopped; DUI destroyed. Named render target remains registered until resource cleanup.')
end

local function nearestTV()
    local player = PlayerPedId()
    local origin = GetEntityCoords(player)
    local best, bestDistance, bestConfig = nil, Config.SearchRadius + 0.01, nil
    for model, settings in pairs(Config.Models) do
        local entity = GetClosestObjectOfType(origin.x, origin.y, origin.z, Config.SearchRadius, model, false, false, false)
        if entity ~= 0 and DoesEntityExist(entity) then
            local dist = #(origin - GetEntityCoords(entity))
            if dist < bestDistance then
                best, bestDistance, bestConfig = entity, dist, settings
            end
        end
    end
    return best, bestDistance, bestConfig
end

local function startTest()
    stopTest()
    local entity, distance, settings = nearestTV()
    if not entity then
        notify(('No supported TV prop found within %.1fm. Try standing next to a TV.'):format(Config.SearchRadius))
        return
    end
    if not settings.target or settings.target == '' then
        notify('This TV has no named render target configured; Stage 1 cannot draw to it.')
        return
    end
    local model = GetEntityModel(entity)
    local name = settings.target
    log(('Entity=%s model=%s distance=%.2f target=%s'):format(entity, model, distance, name))

    if not IsNamedRendertargetRegistered(name) then
        local ok, result = safeNative(RegisterNamedRendertarget, name, false)
        if not ok or result == false then notify('RegisterNamedRendertarget failed. Check F8.') return end
    end
    if not IsNamedRendertargetLinked(model) then
        local ok, result = safeNative(LinkNamedRendertarget, model)
        log(('Link attempt: nativeOK=%s result=%s linked=%s'):format(tostring(ok), tostring(result), tostring(IsNamedRendertargetLinked(model))))
        if not ok or not IsNamedRendertargetLinked(model) then
            notify('This prop cannot link to tvscreen. Use /tvpreview to test DUI separately, or try prop_tv_flat_01.')
            return
        end
    end
    if not IsNamedRendertargetRegistered(name) or not IsNamedRendertargetLinked(model) then
        notify('Render target registration/linking was not confirmed. Check F8.') return
    end
    local ok, renderId = safeNative(GetNamedRendertargetRenderId, name)
    if not ok or not renderId or renderId == 0 or renderId == -1 then
        notify('Invalid named render ID: ' .. tostring(renderId)) return
    end
    local url = ('https://cfx-nui-%s/html/test.html'):format(GetCurrentResourceName())
    local dui = CreateDui(url, width, height)
    if not dui then notify('CreateDui returned no handle.') return end
    local available = false
    for i = 1, 100 do
        if IsDuiAvailable(dui) then available = true break end
        Wait(50)
    end
    if not available then
        safeNative(DestroyDui, dui)
        notify('DUI did not become available within 5 seconds.') return
    end
    local duiHandle = GetDuiHandle(dui)
    if not duiHandle or duiHandle == '' then
        safeNative(DestroyDui, dui)
        notify('GetDuiHandle returned an empty handle.') return
    end
    local txd = CreateRuntimeTxd(dictName)
    if not txd then
        safeNative(DestroyDui, dui)
        notify('CreateRuntimeTxd failed.') return
    end
    local texture = CreateRuntimeTextureFromDuiHandle(txd, textureName, duiHandle)
    if not texture then
        safeNative(DestroyDui, dui)
        notify('CreateRuntimeTextureFromDuiHandle failed.') return
    end
    state = { entity = entity, model = model, target = name, renderId = renderId, dui = dui, txd = txd }
    notify(('Test running on model %s / target %s. Look at TV. Use /tvdebug for diagnostics.'):format(model, name))
end

local function startPreview()
    if preview then
        if preview.dui then safeNative(DestroyDui, preview.dui) end
        preview = nil
        notify('DUI preview stopped.')
        return
    end
    local url = ('https://cfx-nui-%s/html/test.html'):format(GetCurrentResourceName())
    local dui = CreateDui(url, width, height)
    if not dui then notify('Preview CreateDui failed.') return end
    local ready = false
    for i = 1, 100 do
        if IsDuiAvailable(dui) then ready = true break end
        Wait(50)
    end
    if not ready then
        safeNative(DestroyDui, dui)
        notify('Preview DUI unavailable after 5 seconds.')
        return
    end
    local handle = GetDuiHandle(dui)
    if not handle or handle == '' then
        safeNative(DestroyDui, dui)
        notify('Preview GetDuiHandle failed.')
        return
    end
    local txd = CreateRuntimeTxd('qb_tv_preview_dict')
    if not txd then safeNative(DestroyDui, dui) notify('Preview TXD failed.') return end
    local tex = CreateRuntimeTextureFromDuiHandle(txd, 'preview', handle)
    if not tex then safeNative(DestroyDui, dui) notify('Preview texture failed.') return end
    preview = { dui = dui }
    notify('DUI preview running at top-right. Run /tvpreview again to stop.')
end

RegisterCommand('tvpreview', function() CreateThread(startPreview) end, false)

CreateThread(function()
    while true do
        if preview and IsDuiAvailable(preview.dui) then
            DrawSprite('qb_tv_preview_dict', 'preview', 0.78, 0.24, 0.38, 0.38 * (9.0 / 16.0) * (GetAspectRatio(false)), 0.0, 255, 255, 255, 255)
            Wait(0)
        else
            Wait(200)
        end
    end
end)

RegisterCommand('tvtest', function() CreateThread(startTest) end, false)
RegisterCommand('tvstop', function() CreateThread(stopTest) end, false)
RegisterCommand('tvdebug', function()
    local entity, distance, settings = nearestTV()
    log(('Nearest TV: entity=%s distance=%s target=%s'):format(tostring(entity), tostring(distance), settings and tostring(settings.target) or 'none'))
    if entity and settings then
        log(('model=%s exists=%s registered=%s linked=%s'):format(GetEntityModel(entity), tostring(DoesEntityExist(entity)), tostring(IsNamedRendertargetRegistered(settings.target)), tostring(IsNamedRendertargetLinked(GetEntityModel(entity)))))
    end
    if state then
        log(('Active: entity=%s renderId=%s DUIavailable=%s target=%s'):format(state.entity, state.renderId, tostring(IsDuiAvailable(state.dui)), state.target))
    else
        log('No active test')
    end
    notify('Diagnostics printed to F8 console.')
end, false)

CreateThread(function()
    while true do
        if not state then
            Wait(250)
        else
            local current = state
            local valid = DoesEntityExist(current.entity) and GetEntityModel(current.entity) == current.model
            if not valid then
                log('TV entity disappeared or changed. Stopping test.')
                stopTest()
            else
                local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(current.entity))
                if distance <= Config.DrawDistance and IsDuiAvailable(current.dui) then
                    -- Named targets are model-wide: other TVs sharing this model may show the test.
                    local ok = safeNative(SetTextRenderId, current.renderId)
                    if ok then
                        SetScriptGfxDrawBehindPausemenu(true)
                        DrawSprite(dictName, textureName, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                        safeNative(SetTextRenderId, GetDefaultScriptRendertargetRenderId())
                        SetScriptGfxDrawBehindPausemenu(false)
                    end
                    Wait(0)
                else
                    Wait(100)
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if preview then
        if preview.dui then safeNative(DestroyDui, preview.dui) end
        preview = nil
    end
    if state then
        safeNative(SetTextRenderId, GetDefaultScriptRendertargetRenderId())
        if state.dui then safeNative(DestroyDui, state.dui) end
        state = nil
    end
end)
