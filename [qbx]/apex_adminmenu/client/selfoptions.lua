local Invisible, GodMode, Noclip, Wallhack, StaffTag
local StaffTagsRemote = {} -- [serverId] = { name = '...', expires = osTime }

-- ============================================================
-- Toggle helpers
-- ============================================================

InvisibleMode = function(enabled)
    if enabled and Invisible then return end
    Invisible = enabled

    SendNUIMessage({
        action  = 'updateToggleState',
        menu    = Strings.self_options_menu,
        index   = 2,
        checked = enabled
    })

    SetEntityVisible(cache.ped, not enabled)
    if enabled then
        TriggerEvent('apex_adminmenu:notify', Strings.invisibility_activated, Strings.invisibility_activated, 'success')
    else
        TriggerEvent('apex_adminmenu:notify', Strings.invisibility_deactivated, Strings.invisibility_deactivated, 'error')
    end
end

-- Read by spectate, which has to turn invincibility back on or off
-- afterwards without switching off a god mode the admin had enabled.
IsGodModeOn = function() return GodMode == true end

GodModeMode = function(enabled)
    if enabled and GodMode then return end
    GodMode = enabled

    SendNUIMessage({
        action  = 'updateToggleState',
        menu    = Strings.self_options_menu,
        index   = 3,
        checked = enabled
    })

    SetEntityInvincible(cache.ped, enabled)
    if enabled then
        TriggerEvent('apex_adminmenu:notify', Strings.godmode_activated, Strings.godmode_activated, 'success')
    else
        TriggerEvent('apex_adminmenu:notify', Strings.godmode_deactivated, Strings.godmode_deactivated, 'error')
    end
end

-- ============================================================
-- WALLHACK — professional overlay (HP/Armor/Name/ID over head)
-- ============================================================

WallhackMode = function(enabled)
    if enabled and Wallhack then return end
    Wallhack = enabled

    SendNUIMessage({
        action  = 'updateToggleState',
        menu    = Strings.self_options_menu,
        index   = 4,
        checked = enabled
    })

    if enabled then
        TriggerEvent('apex_adminmenu:notify', Strings.wallhack_activated, Strings.wallhack_activated, 'success')
        StartWallhackThread()
    else
        TriggerEvent('apex_adminmenu:notify', Strings.wallhack_deactivated, Strings.wallhack_deactivated, 'error')
    end
end

-- Tunables
local WH_RANGE         = 250.0   -- max distance to render overlay (units)
local WH_NEAR_RANGE    = 80.0    -- distance threshold for "near" sizing
local WH_BAR_WIDTH     = 0.030   -- screen-space width (in screen ratio) of HP bar at distance 0
local WH_BAR_HEIGHT    = 0.0018  -- thin bars (HP + armor)
local WH_HEAD_OFFSET   = 1.1     -- meters above bone head where the overlay floats

-- Internal helper: world bone above head -> screen
local function getHeadOverlayCoords(ped)
    local boneIdx = GetPedBoneIndex(ped, 12844) -- SKEL_Head
    local bx, by, bz
    if boneIdx ~= -1 then
        bx, by, bz = table.unpack(GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0))
    else
        local coords = GetEntityCoords(ped)
        bx, by, bz = coords.x, coords.y, coords.z + 0.95
    end
    return bx, by, bz + WH_HEAD_OFFSET * 0.4
end

-- Draw a 3D-anchored, screen-space rectangle.
local function drawRectAt(sx, sy, w, h, r, g, b, a)
    DrawRect(sx, sy, w, h, r, g, b, a or 220)
end

-- Draw 3D-anchored text using a single scale factor proportional to distance.
local function drawWHText(sx, sy, text, scale, r, g, b, a, centered)
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(r, g, b, a or 230)
    SetTextDropShadow()
    SetTextOutline()
    if centered then SetTextCentre(true) end
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(sx, sy)
end

-- Distance-based scale: 1.0 close, fades to ~0.45 far.
local function distanceScale(dist)
    local t = math.max(0.0, math.min(1.0, dist / WH_RANGE))
    return 1.0 - (t * 0.55)
end

-- HP/Armor color tiers
local function hpColor(pct)
    if pct > 0.66 then return 52, 199, 123 end   -- success
    if pct > 0.33 then return 229, 169, 60 end   -- warning
    return 229, 86, 75                            -- error
end

StartWallhackThread = function()
    CreateThread(function()
        while Wallhack do
            local myPed    = cache.ped
            local myCoords = GetEntityCoords(myPed)

            for _, plyId in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(plyId)
                if targetPed ~= 0 and targetPed ~= myPed and DoesEntityExist(targetPed) then
                    local tCoords  = GetEntityCoords(targetPed)
                    local distance = #(myCoords - tCoords)

                    if distance < WH_RANGE then
                        local hx, hy, hz = getHeadOverlayCoords(targetPed)
                        local onScreen, sx, sy = World3dToScreen2d(hx, hy, hz)

                        if onScreen then
                            local scale  = distanceScale(distance)
                            local txtBig = 0.32 * scale
                            local txtSm  = 0.26 * scale

                            -- Stats
                            local maxHp     = GetEntityMaxHealth(targetPed)
                            local hp        = math.max(0, GetEntityHealth(targetPed) - 100)
                            local hpPctRaw  = (maxHp > 100) and (hp / (maxHp - 100)) or 0.0
                            local hpPct     = math.max(0.0, math.min(1.0, hpPctRaw))
                            local armor     = GetPedArmour(targetPed)
                            local armorPct  = math.max(0.0, math.min(1.0, armor / 100.0))

                            local isDead    = IsEntityDead(targetPed) or hp <= 0
                            local inVehicle = IsPedInAnyVehicle(targetPed, false)

                            local serverId   = GetPlayerServerId(plyId)
                            local playerName = GetPlayerName(plyId) or '?'
                            local staffTag   = StaffTagsRemote[serverId]

                            -- ── Background card behind text ────────────────
                            local cardW = WH_BAR_WIDTH * 1.7 * scale
                            local cardH = 0.060 * scale
                            local cardY = sy - 0.018 * scale
                            drawRectAt(sx, cardY + cardH * 0.5, cardW, cardH, 10, 10, 11, 170)

                            -- ── Name (with optional staff tag) ─────────────
                            local nameLine = staffTag and ('[STAFF] ' .. staffTag.name) or playerName
                            drawWHText(sx, cardY + 0.0015, nameLine, txtBig, 244, 244, 245, 235, true)

                            -- ── ID + distance ──────────────────────────────
                            local meta = ('ID %d  ·  %.0fm%s'):format(
                                serverId,
                                distance,
                                inVehicle and '  ·  VEH' or (isDead and '  ·  DEAD' or '')
                            )
                            drawWHText(sx, cardY + 0.018 * scale, meta, txtSm, 168, 168, 173, 230, true)

                            -- ── HP bar (thin) ───────────────────────────────
                            -- Bars are anchored top-left so the fill grows
                            -- from left to right like a regular health bar.
                            local barW    = WH_BAR_WIDTH * 1.7 * scale
                            local barH    = WH_BAR_HEIGHT * scale
                            local barLeft = sx - barW * 0.5  -- left edge in screen space
                            local barY1   = cardY + 0.040 * scale
                            -- HP background (track)
                            drawRectAt(sx, barY1, barW, barH, 31, 31, 33, 220)
                            -- HP fill
                            local hpR, hpG, hpB = hpColor(hpPct)
                            local hpFillW = barW * hpPct
                            drawRectAt(barLeft + hpFillW * 0.5, barY1, hpFillW, barH, hpR, hpG, hpB, 245)

                            -- ── Armor bar (only if > 0) ────────────────────
                            if armor > 0 then
                                local barY2 = barY1 + barH + 0.0022
                                drawRectAt(sx, barY2, barW, barH, 31, 31, 33, 220)
                                local aFillW = barW * armorPct
                                drawRectAt(barLeft + aFillW * 0.5, barY2, aFillW, barH, 78, 156, 229, 245)
                            end
                        end
                    end
                end
            end

            Wait(0)
        end
    end)
end

-- Legacy text-3d helper kept for compatibility.
DrawText3D = function(x, y, z, text)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.32, 0.32)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(244, 244, 245, 230)
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(sx, sy)
    end
end

-- ============================================================
-- STAFF TAG — "[STAFF] <Name>" floating above head
-- ============================================================

local function getStaffDisplayName()
    local name
    if Framework == 'qb' and PlayerData and PlayerData.charinfo then
        name = (PlayerData.charinfo.firstname or '') .. ' ' .. (PlayerData.charinfo.lastname or '')
        name = name:gsub('^%s+', ''):gsub('%s+$', '')
    elseif Framework == 'esx' and ESX then
        local pd = ESX.GetPlayerData and ESX.GetPlayerData() or nil
        if pd and pd.firstName and pd.lastName then
            name = pd.firstName .. ' ' .. pd.lastName
        end
    end
    if not name or name == '' then name = GetPlayerName(PlayerId()) end
    return name
end

StaffTagMode = function(enabled)
    if enabled and StaffTag then return end
    if not enabled and not StaffTag then return end
    StaffTag = enabled and true or false

    SendNUIMessage({
        action  = 'updateToggleState',
        menu    = Strings.self_options_menu,
        index   = 9,
        checked = StaffTag
    })

    if StaffTag then
        TriggerServerEvent('apex_adminmenu:setStaffTag', true, getStaffDisplayName())
        TriggerEvent('apex_adminmenu:notify', 'Staff Tag', 'Staff tag enabled', 'success')
    else
        TriggerServerEvent('apex_adminmenu:setStaffTag', false)
        TriggerEvent('apex_adminmenu:notify', 'Staff Tag', 'Staff tag disabled', 'error')
    end
end

-- Server -> clients broadcast: refresh staff tag table
RegisterNetEvent('apex_adminmenu:syncStaffTags', function(tags)
    StaffTagsRemote = tags or {}
end)

-- Floating local staff tag draw thread (own player). Wallhack draws
-- the "[STAFF]" line for OTHER players directly.
CreateThread(function()
    while true do
        Wait(0)
        if next(StaffTagsRemote) ~= nil then
            for serverId, tag in pairs(StaffTagsRemote) do
                local plyId = GetPlayerFromServerId(serverId)
                if plyId ~= -1 then
                    local ped = GetPlayerPed(plyId)
                    if ped ~= 0 and DoesEntityExist(ped) then
                        -- Only draw the tag bubble when *not* in wallhack —
                        -- wallhack already shows it.
                        if not Wallhack then
                            local pCoords = GetEntityCoords(ped)
                            local myCoords = GetEntityCoords(cache.ped)
                            local dist = #(myCoords - pCoords)
                            if dist < 25.0 then
                                local x, y, z = getHeadOverlayCoords(ped)
                                local onScreen, sx, sy = World3dToScreen2d(x, y, z + 0.05)
                                if onScreen then
                                    SetTextScale(0.30, 0.30)
                                    SetTextFont(4)
                                    SetTextProportional(true)
                                    SetTextColour(26, 114, 73, 235)
                                    SetTextOutline()
                                    BeginTextCommandDisplayText('STRING')
                                    AddTextComponentSubstringPlayerName(('[STAFF] %s'):format(tag.name or '?'))
                                    SetTextCentre(true)
                                    EndTextCommandDisplayText(sx, sy)
                                end
                            end
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

-- ============================================================
-- Set ped
-- ============================================================
SetPed = function(model)
    if model == 'restore' then
        -- Whichever appearance resource is running (illenium-appearance,
        -- fivem-appearance, qb-clothing, esx_skin, …) — see configs/compat.lua.
        if not Apex.Compat.RestoreAppearance() then
            return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_appearance, 'error', 'fa-xmark')
        end
        TriggerEvent('apex_adminmenu:notify', Strings.ped_restored, Strings.ped_restored_desc, 'success')
    else
        lib.requestModel(model)
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        TriggerEvent('apex_adminmenu:notify', Strings.ped_changed, Strings.ped_changed_desc, 'success')
    end
end

-- ============================================================
-- Self options menu
-- ============================================================
SelfOptions = function()
    local health = GetEntityHealth(cache.ped) / 2
    local options = {
        {
            icon = 'fas fa-heart-pulse',
            label = (Strings.self_health):format(math.floor(health)),
            close = false,
            progress = health
        },
        {
            icon = 'fas fa-person-walking-dashed-line-arrow-right',
            label = Strings.self_noclip,
            checked = IsNoClipping or false
        },
        {
            icon = 'fas fa-eye-slash',
            label = Strings.self_invisible,
            checked = Invisible or false
        },
        {
            icon = 'fas fa-person-rays',
            label = Strings.self_godmode,
            checked = GodMode or false
        },
        {
            icon = 'fas fa-eye',
            label = Strings.self_wallhack,
            checked = Wallhack or false
        },
        {
            icon = 'fas fa-bed-pulse',
            close = false,
            label = Strings.self_revive,
            description = Strings.self_revive_desc
        },
        {
            icon = 'fas fa-bandage',
            close = false,
            label = Strings.self_heal,
            description = Strings.self_heal_desc
        },
        {
            icon = 'fas fa-shirt',
            label = Strings.self_skinmenu,
            description = Strings.self_skinmenu_desc
        },
        {
            icon = 'fas fa-people-arrows',
            label = Strings.self_set_ped,
            values = Peds,
            defaultIndex = 0,
            close = false
        },
        { -- index 9
            icon = 'fas fa-id-badge',
            label = 'Staff Tag',
            description = 'Show [STAFF] tag above your character to everyone',
            checked = StaffTag or false
        }
    }

    -- index 10 — Set My Dimension (only when the feature is enabled)
    if Config.Dimensions and Config.Dimensions.enabled then
        options[#options + 1] = {
            icon = 'fas fa-layer-group',
            label = Strings.self_dimension,
            description = Strings.self_dimension_desc
        }
    end

    SendNUIMessage({
        action = 'openSubMenu',
        title  = Strings.self_options_menu,
        items  = options,
        parent = 'main'
    })

    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.self_options_menu then
            -- through the server: some ambulance scripts (Wasabi V2) only
            -- revive / heal from the server side
            if data.index == 5 then
                TriggerServerEvent('apex_adminmenu:revive', GetPlayerServerId(PlayerId()))
            elseif data.index == 6 then
                TriggerServerEvent('apex_adminmenu:heal', GetPlayerServerId(PlayerId()))
            elseif data.index == 7 then
                TriggerEvent('apex_adminmenu:skinmenu')
            elseif data.index == 10 then -- Set My Dimension
                ApexSetSelfDimensionDialog()
            end
        end
        cb('ok')
    end)
end

-- ============================================================
-- Events
-- ============================================================
-- Revive. This single handler is the target for: self-revive (quick menu),
-- revive-other (quick menu → server → target client) and the admin panel
-- revive button.
--
-- The ambulance resource goes FIRST when there is one. Every medical script
-- keeps its own death state — qb-ambulancejob has `isDead` + `InLaststand`
-- client-side plus a death flag saved on the character server-side — and
-- resurrecting with raw natives alone leaves all of it set. Its death thread
-- then carries on with the respawn timer, the death camera and the disabled
-- controls, so the player never actually gets up: "the revive does nothing".
--
-- The native path below stays as the fallback for standalone servers, and
-- still runs if the provider's own flags were out of sync and left the ped
-- down. Which provider was picked is shown by `apexcompat` in the console.
local function ApexReviveSelf()
    if Apex and Apex.Compat and Apex.Compat.Revive then
        local handled, serverSide = Apex.Compat.Revive()
        -- Revived by the server (Wasabi Ambulance V2): it plays its own
        -- get-up, and resurrecting natively on top would fight it.
        if handled and serverSide then return end
        if handled then
            -- Provider handled it and owns health / invincibility / control from
            -- here. Only continue if the ped is somehow still down.
            local p = PlayerPedId()
            if not (IsEntityDead(p) or IsPedDeadOrDying(p, true)) then return end
        end
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    -- Resurrect first if dead/dying, then top up health & scrub the
    -- death state so the player can move and act immediately.
    if IsEntityDead(ped) or IsPedDeadOrDying(ped, true) then
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    end

    local maxHealth = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, maxHealth)
    SetPlayerInvincible(PlayerId(), false)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedTasksImmediately(ped)
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    SetPlayerControl(PlayerId(), true, 0)

    -- Mirror the flags common framework death systems read, so anything
    -- still tracking "dead" status syncs up — best-effort, harmless if no
    -- one listens. (statebags + the usual revive/death events.)
    local lp = LocalPlayer
    if lp and lp.state then
        lp.state:set('isDead', false, true)
        lp.state:set('dead', false, true)
    end
end

RegisterNetEvent('apex_adminmenu:revive', function()
    ApexReviveSelf()
    TriggerEvent('apex_adminmenu:notify', Strings.self_revived, Strings.self_revived_desc, 'success')
end)

RegisterNetEvent('apex_adminmenu:heal', function()
    local ped = PlayerPedId()
    -- Revive too if they happened to be down, then fully heal + clean up.
    if IsEntityDead(ped) or IsPedDeadOrDying(ped, true) then
        ApexReviveSelf()
        ped = PlayerPedId()   -- the handle changes across a resurrect
    end
    -- Clear the ambulance resource's own injuries: bleeding, damaged body
    -- parts and the limp clipset live in ITS state, so the natives below
    -- top the health bar up while the player keeps limping and bleeding.
    if Apex and Apex.Compat and Apex.Compat.Heal then Apex.Compat.Heal() end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    -- Optional status top-up for servers that DO run a hunger/thirst
    -- resource. These are no-ops when the resource isn't present.
    if Framework == 'esx' then
        TriggerEvent('esx_status:set', 'hunger', 1000000)
        TriggerEvent('esx_status:set', 'thirst', 1000000)
    else
        TriggerServerEvent('hospital:server:resetHungerThirst')
    end
    TriggerEvent('apex_adminmenu:notify', Strings.self_healed, Strings.self_healed_desc, 'success')
end)

RegisterNetEvent('apex_adminmenu:skinmenu', function()
    -- Framework-agnostic: the provider is auto-detected, so an ESX server
    -- running illenium-appearance (or a QBox one running fivem-appearance)
    -- opens the right menu instead of firing a dead event.
    if not Apex.Compat.OpenAppearance() then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_appearance, 'error', 'fa-xmark')
    end
    TriggerEvent('apex_adminmenu:notify', Strings.skin_menu_opened, Strings.skin_menu_opened, 'success')
end)
