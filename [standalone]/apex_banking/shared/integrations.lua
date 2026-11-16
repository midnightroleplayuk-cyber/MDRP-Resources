--[[
    Apex Banking — Open-source Integration Points
    ────────────────────────────────────────────────────────────
    EDIT ME. This file is intentionally outside the build/* folder
    and listed in `escrow_ignore` so it stays editable forever.

    Use these hooks to:
      • route notifications through whatever notify resource you
        already use (apex_notify, ox_lib, okokNotify, mythic, etc.),
      • plug into your own analytics / Discord bot / housing /
        phone resource,
      • restrict bank usage to specific characters or jobs,
      • react to bank events without modifying core code.

    Every function here ships with a sensible default. Override
    only the ones you need.
]]

Integrations = Integrations or {}

-- ═══════════════════════════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════════════════════════
-- Provider auto-detection. Reads Config.providers.notify and
-- picks the first available export when set to 'auto'.
local function _detectNotifyProvider()
    local pick = (Config and Config.providers and Config.providers.notify) or 'auto'
    if pick ~= 'auto' then return pick end
    if GetResourceState('apex_notify')  == 'started' then return 'apex_notify' end
    if GetResourceState('ox_lib')       == 'started' then return 'ox_lib'      end
    if GetResourceState('okokNotify')   == 'started' then return 'okok'        end
    if GetResourceState('mythic_notify')== 'started' then return 'mythic'      end
    if GetResourceState('es_extended')  == 'started' then return 'esx'         end
    if GetResourceState('qb-core')      == 'started' then return 'qb'          end
    if GetResourceState('qbx_core')     == 'started' then return 'qb'          end
    return 'builtin'
end

-- Client-side notify dispatcher. Routes to the provider chosen
-- by Config.providers.notify. Override Integrations.OnNotify on
-- the client to short-circuit and route to your own resource.
-- PUBLIC: every client notification in the resource funnels through
-- here, so overriding Integrations.OnNotify (or Config.providers.notify)
-- swaps notifications EVERYWHERE at once.
function Integrations.ClientNotify(message, kind, title, duration)
    kind     = kind or 'info'
    title    = title or (Config and Config.notify and Config.notify.title) or 'Banking'
    duration = duration or (Config and Config.notify and Config.notify.duration) or 5000
    if Integrations.OnNotify and Integrations.OnNotify(message, kind, title, duration) then
        return
    end
    local provider = _detectNotifyProvider()
    if provider == 'apex_notify' and GetResourceState('apex_notify') == 'started' then
        exports['apex_notify']:Notify(message, kind, title, duration)
    elseif provider == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({ title = title, description = message, type = kind, duration = duration })
    elseif provider == 'okok' and GetResourceState('okokNotify') == 'started' then
        exports['okokNotify']:Alert(title, message, duration, kind)
    elseif provider == 'mythic' and GetResourceState('mythic_notify') == 'started' then
        exports['mythic_notify']:SendAlert(kind, message, duration)
    elseif provider == 'esx' and GetResourceState('es_extended') == 'started' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX and ESX.ShowNotification then ESX.ShowNotification(message) end
    elseif provider == 'qb' and GetResourceState('qbx_core') == 'started' then
        -- QBox does NOT listen for 'QBCore:Notify'. Firing it there made
        -- every notification vanish with no error at all.
        local ok = pcall(function() exports.qbx_core:Notify(message, kind, duration) end)
        if not ok then TriggerEvent('QBCore:Notify', message, kind, duration) end
    elseif provider == 'qb' and GetResourceState('qb-core') == 'started' then
        TriggerEvent('QBCore:Notify', message, kind, duration)
    else
        -- Built-in NUI toast (the bank's own fallback — always available)
        SendNUIMessage({
            action  = 'notify',
            payload = {
                title    = title,
                message  = message,
                type     = kind,
                duration = duration,
                position = (Config and Config.notify and Config.notify.position) or 'top-right',
            },
        })
    end
end

-- Signature: src, message, type ('info'|'success'|'warning'|'error'), duration
function Integrations.Notify(src, message, type, duration)
    type     = type     or 'info'
    duration = duration or (Config and Config.notify and Config.notify.duration) or 5000
    local title = (Config and Config.notify and Config.notify.title) or 'Banking'

    if IsDuplicityVersion() then
        if not src then return end
        TriggerClientEvent('apex_banking:notify', src, title, message, type, duration)
    else
        Integrations.ClientNotify(message, type, title, duration)
    end
end

-- ═══════════════════════════════════════════════════════════
-- TARGET (client) — for the bank teller ped
-- ═══════════════════════════════════════════════════════════
-- Called by build/client/target.lua. Returns true if the provider
-- successfully registered the interaction, false to fall back to
-- the proximity textUI. Override OnRegisterTarget to plug a
-- bespoke target resource.
function Integrations.RegisterTargetPed(ped, label, icon, onSelect)
    if Integrations.OnRegisterTarget
       and Integrations.OnRegisterTarget(ped, label, icon, onSelect) then
        return true
    end
    local pick = (Config and Config.providers and Config.providers.target) or 'auto'
    if pick == 'none' then return false end
    -- Bridge.present() also accepts 'starting'. This runs once per ped, at
    -- bootstrap, and folder order alone can have the target resource still
    -- booting at that exact moment — with `== 'started'` the ped then got
    -- no target for the rest of the session, silently.
    local up = (Bridge and Bridge.present) or function(res) return GetResourceState(res) == 'started' end
    if pick == 'auto' then
        if     up('ox_target')  then pick = 'ox_target'
        elseif up('qb-target')  then pick = 'qb-target'
        elseif up('qtarget')    then pick = 'qtarget'
        elseif up('interact')   then pick = 'interact'
        else return false end
    end

    if pick == 'ox_target' then
        exports.ox_target:addLocalEntity(ped, {{
            label = label, icon = icon or 'fa-solid fa-building-columns',
            onSelect = function() onSelect() end,
            distance = (Config and Config.targetMaxDistance) or 3.5,
        }})
        return true
    elseif pick == 'qb-target' or pick == 'qtarget' then
        exports[pick]:AddTargetEntity(ped, {
            options = {{
                label = label, icon = icon or 'fas fa-building-columns',
                action = function() onSelect() end,
            }},
            distance = (Config and Config.targetMaxDistance) or 3.5,
        })
        return true
    end
    return false
end

-- ═══════════════════════════════════════════════════════════
-- TEXT UI / 3D INTERACTION PROMPT (client)
-- ═══════════════════════════════════════════════════════════
-- Drives the "[E] Open the bank / Use the ATM" prompt shown when you
-- walk up to a bank ped or an ATM (when Config.interaction is NOT
-- 'target'). Pick the look with Config.providers.textui:
--
--   'auto' / 'apex'  → built-in floating 3D NUI marker (default — the
--                      polished look from the showcase video)
--   'ox_lib'         → ox_lib lib.showTextUI / lib.hideTextUI
--   'qb'             → qb-core DrawText / HideText
--   'custom'         → your own — override Integrations.OnPrompt
--   'none'           → no prompt (e.g. when you only use target)
--
-- Override Integrations.OnPrompt(phase, info) for full control.
--   phase = 'enter' (in range) | 'frame' (per-frame, carries sx/sy/
--           scale/onScreen) | 'exit' (left range)
--   info  = { label, icon, faIcon, key, sx, sy, scale, onScreen, coords }
local function _detectTextUIProvider()
    local pick = (Config and Config.providers and Config.providers.textui) or 'auto'
    if pick == 'auto' then return 'apex' end
    return pick
end

-- True only when the active provider needs per-frame screen coords
-- (just the built-in 3D marker). Lets callers skip World3dToScreen2d
-- for static text-ui providers.
function Integrations.PromptNeedsScreenPos()
    return _detectTextUIProvider() == 'apex'
end

function Integrations.Prompt(phase, info)
    info = info or {}
    if Integrations.OnPrompt and Integrations.OnPrompt(phase, info) then return end
    local p = _detectTextUIProvider()

    -- /bankadmin "world markers" off: the floating 3D marker (the 'apex'
    -- prompt) stays hidden; the interaction key keeps working.
    if p == 'apex' and Config and Config.features and Config.features.worldMarkers == false then return end

    if p == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        if phase == 'enter' then
            exports.ox_lib:showTextUI(('[%s]  %s'):format(info.key or 'E', info.label or 'Interact'), {
                icon     = info.faIcon or 'building-columns',
                position = (Config and Config.textui and Config.textui.position) or 'left-center',
            })
        elseif phase == 'exit' then
            exports.ox_lib:hideTextUI()
        end

    elseif p == 'qb' and GetResourceState('qb-core') == 'started' then
        -- Only qb-core has DrawText/HideText. Admitting a QBox-only server
        -- into this branch threw "No such export DrawText in resource
        -- qb-core" on EVERY frame of the prompt, because the exports
        -- metatable errors when the key is READ, not when it is called.
        if phase == 'enter' then
            exports['qb-core']:DrawText(('[%s] %s'):format(info.key or 'E', info.label or 'Interact'),
                (Config and Config.textui and Config.textui.position) or 'left')
        elseif phase == 'exit' then
            exports['qb-core']:HideText()
        end

    elseif p == 'qb' and GetResourceState('qbx_core') == 'started' then
        -- QBox dropped qb-core's DrawText in favour of ox_lib's text UI,
        -- which every QBox install ships.
        if GetResourceState('ox_lib') == 'started' then
            if phase == 'enter' then
                exports.ox_lib:showTextUI(('[%s]  %s'):format(info.key or 'E', info.label or 'Interact'), {
                    icon     = info.faIcon or 'building-columns',
                    position = (Config and Config.textui and Config.textui.position) or 'left-center',
                })
            elseif phase == 'exit' then
                exports.ox_lib:hideTextUI()
            end
        end

    elseif p == 'none' then
        -- no prompt

    else -- 'apex' built-in floating 3D NUI marker
        if phase == 'frame' then
            if info.onScreen then
                SendNUIMessage({
                    action = 'show3DIcon',
                    x = info.sx, y = info.sy, scale = info.scale or 1.0,
                    label = info.label or 'Interact',
                    icon  = info.icon  or 'building',
                    key   = info.key   or 'E',
                })
            else
                SendNUIMessage({ action = 'hide3DIcon' })
            end
        elseif phase == 'exit' then
            SendNUIMessage({ action = 'hide3DIcon' })
        end
    end
end

-- ═══════════════════════════════════════════════════════════
-- OPTIONAL NATIVE GROUND MARKER (client)
-- ═══════════════════════════════════════════════════════════
-- Off by default — the floating NUI marker above is the showcase
-- look. If you'd rather draw a classic GTA cylinder on the ground at
-- each bank / ATM, set Config.marker.enabled = true (and tune
-- Config.marker.*), or override Integrations.OnDrawMarker to draw
-- anything. Called every frame for the closest in-range point.
function Integrations.DrawWorldMarker(coords)
    if Integrations.OnDrawMarker and Integrations.OnDrawMarker(coords) then return end
    if Config and Config.features and Config.features.worldMarkers == false then return end
    local m = (Config and Config.marker) or {}
    if not m.enabled then return end
    local col = m.color or { r = 31, g = 94, b = 255, a = 120 }
    local sz  = m.scale or { x = 1.2, y = 1.2, z = 0.6 }
    DrawMarker(m.type or 1,
        coords.x, coords.y, coords.z - (m.zOffset or 0.95), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        sz.x, sz.y, sz.z, col.r, col.g, col.b, col.a,
        m.bob or false, false, 2, m.rotate or false, nil, nil, false)
end

-- ═══════════════════════════════════════════════════════════
-- INVENTORY (server) — reading the apex_atm_card item meta
-- ═══════════════════════════════════════════════════════════
-- Returns the card meta table from whichever inventory resource is
-- running. Falls back to nil when no provider is available so the
-- ATM auth code knows to use the "first card on identifier" path.
function Integrations.GetCardMeta(src)
    if Integrations.OnGetCardMeta then
        local meta = Integrations.OnGetCardMeta(src)
        if meta then return meta end
    end
    local pick = (Config and Config.providers and Config.providers.inventory) or 'auto'
    local item = (Config and Config.card and Config.card.item) or 'apex_atm_card'
    if pick == 'none' then return nil end
    if pick == 'auto' then
        if     GetResourceState('ox_inventory') == 'started' then pick = 'ox_inventory'
        elseif GetResourceState('qb-inventory') == 'started' then pick = 'qb-inventory'
        elseif GetResourceState('qs-inventory') == 'started' then pick = 'qs-inventory'
        elseif GetResourceState('codem-inventory') == 'started' then pick = 'codem'
        else pick = 'esx' end
    end

    if pick == 'ox_inventory' then
        local items = exports.ox_inventory:Search(src, 'slots', item)
        if items and items[1] then return items[1].metadata end
    end
    -- Other providers (qb / qs / codem / esx native) don't carry
    -- per-item metadata reliably — fall back to nil so the server
    -- picks the player's primary card by identifier.
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- ACCESS CONTROL (server)
-- ═══════════════════════════════════════════════════════════
-- Return false to deny this player from using ANY banking surface.
-- Useful for "felons can't open accounts" or "blacklist by job".
function Integrations.CanUseBanking(src, identifier)
    return true
end

-- Per-feature gate. Return false to hide a specific module from
-- the player even though Config.features.* enables it globally.
-- Module values match Config.features keys ('cards', 'loans', …).
function Integrations.CanUseFeature(src, identifier, feature)
    return true
end

-- ═══════════════════════════════════════════════════════════
-- LIFECYCLE HOOKS (server)
-- ═══════════════════════════════════════════════════════════
-- Card issued. Called after a player is granted a brand-new
-- apex_atm_card. You can log this externally, charge a small fee,
-- or refuse with `false` to roll the issuance back.
function Integrations.OnCardIssued(src, identifier, accountId, iban)
    return true
end

-- Money moved. Called after every successful money movement.
-- Useful for analytics or pushing live data to a Discord bot.
function Integrations.OnTransaction(tx)
    -- tx = { type, fromAccount, toAccount, fromIban, toIban,
    --        amount, fee, label, src, ts }
end

-- Loan offered. Return false to refuse a particular loan request
-- based on your own credit-score rules. Default approves anything
-- within Config.loans + the trust ceiling.
function Integrations.CanTakeLoan(src, identifier, amount)
    return true
end

-- Generic log sink. Called when Config.providers.logger = 'custom'.
function Integrations.OnLog(payload)
    -- payload = { channel, title, fields = { … }, color, ts }
end