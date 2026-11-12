local selecting = false
local selData
local current = 1
local introDone = false

local function nui(action, data) SendNUIMessage({ action = action, data = data }) end

local function uiConfig()
    local c = Config.Character
    return {
        ui = Config.UI,
        character = {
            minAge = c.MinAge, maxAge = c.MaxAge, nameMin = c.NameMin, nameMax = c.NameMax,
            allowDelete = c.AllowDelete, confirmName = c.DeleteConfirmName,
            nationalities = c.Nationalities, defaultNationality = c.DefaultNationality,
        },
    }
end

local function payload(d)
    return {
        characters = d.characters, allowed = d.allowed, display = d.display, breakdown = d.breakdown,
        lockedText = d.lockedText, lockedLink = d.lockedLink, config = uiConfig(), theme = d.theme,
        allowDelete = d.allowDelete,
    }
end

local function firstSlot(chars)
    local best
    for _, c in ipairs(chars or {}) do
        if not c.locked and (not best or c.slot < best) then best = c.slot end
    end
    return best or 1
end

local function fadeOut(ms)
    DoScreenFadeOut(ms)
    while not IsScreenFadedOut() do Wait(0) end
end

function OpenSelection()
    if selecting then return end
    selecting = true
    fadeOut(400)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    local d = lib.callback.await('vmc:getSelection', false)
    if not d or d.error then
        selecting = false
        DoScreenFadeIn(500)
        return
    end
    selData = d
    -- stop spawnmanager respawning/unhiding the ped underneath us
    pcall(function() exports.spawnmanager:setAutoSpawn(false) end)
    Open.BeforeSelection()

    Scene.Load(d.scene)
    Scene.SetCharacters(d.characters)
    current = firstSlot(d.characters)

    Cam.Create()
    introDone = false
    Scene.PlayIntro(current, function() introDone = true end)
    DoScreenFadeIn(1200)

    local p = payload(d)
    p.selected = current
    nui('select:open', p)
    SetNuiFocus(true, true)

    -- Floating info card: project the selected character's shoulder to screen space
    CreateThread(function()
        local last = { x = -1, y = -1, show = false }
        while selecting do
            local show, x, y = false, 0.0, 0.0
            local ped = introDone and Scene.GetPed(current)
            if ped and GetEntityAlpha(ped) > 200 then
                local p = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0) -- head
                local h = math.rad(GetEntityHeading(ped))
                -- a little to the ped's left shoulder, which sits on screen-right when they face the camera
                local world = p + vec3(-math.cos(h) * 0.22, -math.sin(h) * 0.22, -0.22)
                local on, sx, sy = GetScreenCoordFromWorldCoord(world.x, world.y, world.z)
                if on then show, x, y = true, sx, sy end
            end
            if show ~= last.show or math.abs(x - last.x) > 0.0006 or math.abs(y - last.y) > 0.0006 then
                SendNUIMessage({ action = 'select:anchor', data = { show = show, x = x, y = y, slot = current } })
                last.show, last.x, last.y = show, x, y
            end
            Wait(0)
        end
    end)

    CreateThread(function()
        while selecting do
            Scene.HidePlayer()
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            Wait(0)
        end
    end)
end

local function closeSelection()
    selecting = false
    nui('select:close')
    SetNuiFocus(false, false)
    Scene.Unload()
    Cam.Destroy(0)
    Open.AfterSelection()
end

RegisterNetEvent('vmc:client:theme', function(theme)
    if type(theme) == 'table' then nui('theme', theme) end
end)

RegisterNetEvent('vmc:client:open', function()
    Wait(250)
    OpenSelection()
end)

-- Selection NUI ---------------------------------------------------------------------------
local selectOps = {}

selectOps.focus = function(d)
    local slot = math.floor(tonumber(d.slot) or 1)
    if slot == current then return true end
    current = slot
    Scene.Focus(slot)
    return true
end

selectOps.play = function(d)
    nui('loading', { show = true, text = 'Loading in' })
    local ok, info = lib.callback.await('vmc:play', false, d.id)
    if not ok then
        nui('loading', { show = false })
        nui('toast', { type = 'error', text = info or 'Could not load that character.' })
        return false
    end
    fadeOut(600)
    closeSelection()
    nui('loading', { show = false })
    Open.SpawnExisting(info)
    return true
end

selectOps.create = function(d)
    nui('loading', { show = true, text = 'Creating character' })
    local ok, info = lib.callback.await('vmc:create', false, d.slot, d.data)
    nui('loading', { show = false })
    if not ok then
        nui('toast', { type = 'error', text = info or 'Could not create that character.' })
        return false
    end
    fadeOut(600)
    closeSelection()
    Open.SpawnNew(info)
    return true
end

selectOps.delete = function(d)
    local ok, data = lib.callback.await('vmc:delete', false, d.id)
    if not ok then
        nui('toast', { type = 'error', text = data or 'Could not delete that character.' })
        return false
    end
    selData = data
    Scene.SetCharacters(data.characters)
    Scene.Focus(current, false)
    local p = payload(data)
    p.selected = current
    nui('select:update', p)
    nui('toast', { type = 'success', text = 'Character deleted.' })
    return true
end

RegisterNUICallback('select', function(d, cb)
    if not selecting then return cb(false) end
    local fn = selectOps[d.op]
    cb(fn and fn(d) or false)
end)

-- Admin ----------------------------------------------------------------------------------------
function OpenAdmin()
    local d = lib.callback.await('vmc:admin:data', false)
    if not d then return end
    nui('admin:open', d)
    SetNuiFocus(true, true)
end

RegisterNetEvent('vmc:client:openAdmin', function()
    if selecting or Editor.IsOpen() then return end
    OpenAdmin()
end)

local adminOps = {}

adminOps.close = function()
    SetNuiFocus(false, false)
    return true
end

adminOps.refresh = function(d)
    return lib.callback.await('vmc:admin:data', false, d.discord == true)
end

adminOps.saveSettings = function(d)
    local ok, data = lib.callback.await('vmc:admin:saveSettings', false, d.settings)
    return ok and data or false
end

adminOps.sceneAction = function(d)
    local ok, data = lib.callback.await('vmc:admin:sceneAction', false, d.action, d.id, d.value)
    return ok and data or false
end

adminOps.setOverride = function(d)
    local ok, data = lib.callback.await('vmc:admin:setOverride', false, d.override)
    if not ok then return { error = data or 'Could not save that override.' } end
    return data
end

adminOps.removeOverride = function(d)
    local ok, data = lib.callback.await('vmc:admin:removeOverride', false, d.identifier)
    return ok and data or false
end

local function openEditor(id, preview)
    local scene
    if id then
        scene = lib.callback.await('vmc:getScene', false, id)
        if not scene then return false end
    end
    nui('admin:close')
    Editor.Open(scene)
    if preview then Editor.Op({ op = 'preview' }) end
    return true
end

adminOps.newScene = function() return openEditor(nil) end
adminOps.editScene = function(d) return openEditor(d.id) end
adminOps.previewScene = function(d) return openEditor(d.id, true) end

RegisterNUICallback('admin', function(d, cb)
    local fn = adminOps[d.op]
    cb(fn and fn(d) or false)
end)

-- Startup ---------------------------------------------------------------------------------------
CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(100) end
    Wait(1000)
    if CBridge.IsLoggedIn() then return end
    OpenSelection()
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if selecting then
        Scene.Unload()
        Cam.Destroy(0)
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(0)
    end
    if Editor.IsOpen() then Editor.Close() end
end)

exports('OpenSelection', OpenSelection)
exports('IsSelecting', function() return selecting end)
