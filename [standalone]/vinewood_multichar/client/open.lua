--[[ ─────────────────────────────────────────────────────────────
    OPEN FILE: edit these hooks to fit your server.
    Nothing in here is escrowed.
───────────────────────────────────────────────────────────── ]]
Open = {}

local function started(r) return GetResourceState(r) == 'started' end

-- Called just before the selection screen appears
function Open.BeforeSelection()
    DisplayRadar(false)
    -- Pause weather sync scripts so the scene's weather/time holds
    if started('qb-weathersync') then TriggerEvent('qb-weathersync:client:DisableSync') end
    -- Hide your HUD here, e.g. TriggerEvent('vinewood_hud:client:toggle', false)
end

-- Called after a character has been chosen/created, once the scene has gone
function Open.AfterSelection()
    if started('qb-weathersync') then TriggerEvent('qb-weathersync:client:EnableSync') end
    DisplayRadar(true)
end

local function restorePed()
    local ped = PlayerPedId()
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
end

local function qbLoaded()
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
end

local function teleport(coords, heading)
    local ped = PlayerPedId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)
    local t = GetGameTimer() + 5000
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < t do Wait(0) end
end

-- Existing character: info = { position, skin, skinFormat, framework }
function Open.SpawnExisting(info)
    local pos = info.position or {}
    local coords = (pos.x and vec3(pos.x, pos.y, pos.z)) or Config.NewCharacterSpawn.xyz
    local heading = pos.w or pos.heading or Config.NewCharacterSpawn.w

    -- Using a spawn selector? Replace this block, e.g. for qbx_spawn / qb-spawn:
    --   TriggerEvent('qb-spawn:client:setupSpawns', citizenid, false, nil)
    --   TriggerEvent('qb-spawn:client:openUI', true)
    --   return
    teleport(coords, heading)
    restorePed()

    if info.framework == 'qbx' or info.framework == 'qb' then
        qbLoaded()
    end
    Open.LoadOwnSkin(info)

    TriggerServerEvent('vmc:server:spawned')
    DoScreenFadeIn(1000)
end

-- Put the chosen character's saved look on the player after spawning.
-- Most clothing scripts do this themselves on the framework's "player loaded" event.
function Open.LoadOwnSkin(info)
    local c = VMC.DetectClothing()
    if c == 'op-clothing' then
        SetTimeout(500, function() pcall(function() exports['op-clothing']:ReloadAppearance() end) end)
    elseif info.framework == 'esx' and info.skin and next(info.skin) then
        if c == 'skinchanger' or info.skin.tshirt_1 ~= nil then
            TriggerEvent('skinchanger:loadSkin', info.skin)
        elseif c == 'illenium-appearance' or c == 'fivem-appearance' or c == 'qs-appearance' then
            pcall(function() exports[c]:setPlayerAppearance(info.skin) end)
        end
    end
    -- rcore_clothing, illenium on Qbox/QBCore and qb-clothing load the skin themselves
end

-- Opens the clothing script's first-time character creator
function Open.OpenCreator(info)
    local c = VMC.DetectClothing()
    local esx = info.framework == 'esx'

    if c == 'op-clothing' then
        exports['op-clothing']:OpenCharacterCreator({ allowCancel = false, allowModelChange = true })
    elseif c == 'custom' then
        Open.OpenCustomCreator(info)
    elseif esx and c == 'rcore_clothing' then
        TriggerEvent('esx_skin:resetFirstSpawn')
        TriggerEvent('esx_skin:playerRegistered')
    elseif esx then
        TriggerEvent('skinchanger:loadDefaultModel', info.gender ~= 'female', function()
            TriggerEvent('esx_skin:openSaveableMenu', function() end, function() end)
        end)
    else
        -- illenium-appearance, qs-appearance, fivem-appearance, qb-clothing and rcore_clothing
        -- all open their creator from this QBCore event
        TriggerEvent('qb-clothes:client:CreateFirstCharacter')
    end
end

-- 'custom' clothing hooks --------------------------------------------------------------
-- Dress a selection-screen preview ped. skin/model come from server/clothing.lua fromCustom()
function Open.ApplyPreviewSkin(ped, skin, char)
    -- exports.my_clothing:ApplyToPed(ped, skin)
end

function Open.OpenCustomCreator(info)
    -- exports.my_clothing:OpenCreator()
end

-- Brand new character: info = { id, gender, framework }
function Open.SpawnNew(info)
    local model = info.gender == 'female' and `mp_f_freemode_01` or `mp_m_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(model)

    local s = Config.NewCharacterSpawn
    teleport(s.xyz, s.w)
    restorePed()

    if info.framework == 'qbx' or info.framework == 'qb' then qbLoaded() end
    DoScreenFadeIn(1000)
    Open.OpenCreator(info)

    TriggerServerEvent('vmc:server:spawned')
end
