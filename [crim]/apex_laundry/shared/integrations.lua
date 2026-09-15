--[[
    Apex Laundry — Open-source Integration Points
    ────────────────────────────────────────────────────────────
    EDIT ME. Kept outside build/* and listed in `escrow_ignore`
    so it stays editable forever.

    Use these hooks to route notifications through your own notify
    resource, plug a bespoke target system, change the world
    prompt, restrict who can use a machine, or sink Discord logs.
    Every function ships with a sensible default — override only
    the ones you need.
]]

Integrations = Integrations or {}

-- ═══════════════════════════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════════════════════════
local function _detectNotifyProvider()
    local pick = (Config and Config.providers and Config.providers.notify) or 'auto'
    if pick ~= 'auto' then return pick end
    if GetResourceState('apex_notify')   == 'started' then return 'apex_notify' end
    if GetResourceState('ox_lib')         == 'started' then return 'ox_lib'      end
    if GetResourceState('okokNotify')     == 'started' then return 'okok'        end
    if GetResourceState('mythic_notify')  == 'started' then return 'mythic'      end
    if GetResourceState('es_extended')    == 'started' then return 'esx'         end
    if GetResourceState('qb-core')        == 'started' then return 'qb'          end
    if GetResourceState('qbx_core')       == 'started' then return 'qb'          end
    return 'builtin'
end

-- Client-side notify dispatcher. Every client notification funnels
-- through here, so overriding Integrations.OnNotify (or
-- Config.providers.notify) swaps notifications EVERYWHERE at once.
function Integrations.ClientNotify(message, kind, title, duration)
    kind     = kind or 'info'
    title    = title or (Config and Config.notify and Config.notify.title) or 'Laundromat'
    duration = duration or (Config and Config.notify and Config.notify.duration) or 4500
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
    elseif provider == 'qb' and (GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started') then
        TriggerEvent('QBCore:Notify', message, kind, duration)
    else
        -- Built-in NUI toast (always available).
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
    type     = type or 'info'
    duration = duration or (Config and Config.notify and Config.notify.duration) or 4500
    local title = (Config and Config.notify and Config.notify.title) or 'Laundromat'
    if IsDuplicityVersion() then
        if not src then return end
        TriggerClientEvent('apex_laundry:notify', src, title, message, type, duration)
    else
        Integrations.ClientNotify(message, type, title, duration)
    end
end

-- ═══════════════════════════════════════════════════════════
-- TARGET (client) — for the laundromat machine entity
-- ═══════════════════════════════════════════════════════════
function Integrations.RegisterTargetEntity(entity, label, icon, onSelect)
    if Integrations.OnRegisterTarget
       and Integrations.OnRegisterTarget(entity, label, icon, onSelect) then
        return true
    end
    local pick = (Config and Config.providers and Config.providers.target) or 'auto'
    if pick == 'none' then return false end
    if pick == 'auto' then
        if     GetResourceState('ox_target') == 'started' then pick = 'ox_target'
        elseif GetResourceState('qb-target') == 'started' then pick = 'qb-target'
        elseif GetResourceState('qtarget')   == 'started' then pick = 'qtarget'
        else return false end
    end
    if pick == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, {{
            label = label, icon = icon or 'fa-solid fa-soap',
            onSelect = function() onSelect() end,
            distance = (Config and Config.targetMaxDistance) or 2.0,
        }})
        return true
    elseif pick == 'qb-target' or pick == 'qtarget' then
        exports[pick]:AddTargetEntity(entity, {
            options = {{
                label = label, icon = icon or 'fas fa-soap',
                action = function() onSelect() end,
            }},
            distance = (Config and Config.targetMaxDistance) or 2.0,
        })
        return true
    end
    return false
end

-- ═══════════════════════════════════════════════════════════
-- TEXT UI / 3D INTERACTION PROMPT (client)
-- ═══════════════════════════════════════════════════════════
-- Drives the "[E] Use the machine" prompt when Config.interaction
-- is NOT 'target'. Pick the look with Config.providers.textui.
--   phase = 'enter' | 'frame' (carries sx/sy/scale/onScreen) | 'exit'
local function _detectTextUIProvider()
    local pick = (Config and Config.providers and Config.providers.textui) or 'auto'
    if pick == 'auto' then return 'apex' end
    return pick
end

function Integrations.PromptNeedsScreenPos()
    return _detectTextUIProvider() == 'apex'
end

function Integrations.Prompt(phase, info)
    info = info or {}
    if Integrations.OnPrompt and Integrations.OnPrompt(phase, info) then return end
    local p = _detectTextUIProvider()

    if p == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        if phase == 'enter' then
            exports.ox_lib:showTextUI(('[%s]  %s'):format(info.key or 'E', info.label or 'Interact'), {
                icon     = info.faIcon or 'soap',
                position = (Config and Config.textui and Config.textui.position) or 'left-center',
            })
        elseif phase == 'exit' then
            exports.ox_lib:hideTextUI()
        end

    elseif p == 'qb' and (GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started') then
        if phase == 'enter' then
            exports['qb-core']:DrawText(('[%s] %s'):format(info.key or 'E', info.label or 'Interact'),
                (Config and Config.textui and Config.textui.position) or 'left')
        elseif phase == 'exit' then
            exports['qb-core']:HideText()
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
                    icon  = info.icon  or 'soap',
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
function Integrations.DrawWorldMarker(coords)
    if Integrations.OnDrawMarker and Integrations.OnDrawMarker(coords) then return end
    local m = (Config and Config.marker) or {}
    if not m.enabled then return end
    local col = m.color or { r = 31, g = 94, b = 255, a = 120 }
    local sz  = m.scale or { x = 1.1, y = 1.1, z = 0.5 }
    DrawMarker(m.type or 1,
        coords.x, coords.y, coords.z - (m.zOffset or 0.98), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        sz.x, sz.y, sz.z, col.r, col.g, col.b, col.a,
        m.bob or false, false, 2, m.rotate or false, nil, nil, false)
end

-- ═══════════════════════════════════════════════════════════
-- ACCESS CONTROL (server) — return false to deny use entirely.
-- Runs IN ADDITION to a machine's Config permission. Useful for
-- "felons only" / job gating on top of the per-machine groups.
-- ═══════════════════════════════════════════════════════════
function Integrations.CanUseMachine(src, identifier, machineId)
    return true
end

-- ═══════════════════════════════════════════════════════════
-- LIFECYCLE HOOKS (server)
-- ═══════════════════════════════════════════════════════════
-- Called after a wash STARTS. tx = { machineId, src, amount, result, cleaners, seconds }
function Integrations.OnWashStarted(tx) end
-- Called after laundered money is COLLECTED. tx = { machineId, src, amount }
function Integrations.OnWashCollected(tx) end
-- Generic log sink (Config.providers.logger = 'custom').
function Integrations.OnLog(payload) end
