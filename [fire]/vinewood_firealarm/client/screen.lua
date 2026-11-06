-- Live panel screen: renders html/screen.html into a DUI and swaps it onto
-- the panel model's screen texture so everyone nearby can read it.
--
-- Note: texture replacement is per texture name, not per prop. Every panel
-- using that texture shows the same image, so the screen shows the NEAREST
-- panel to you. Panels in different businesses are rarely in sight of each
-- other, so in practice each one reads correctly.

local S = Config.Screen
if not S or not S.enabled then return end

local dui, applied, currentId, lastHash, lastSend = nil, false, nil, nil, 0
local RT_TXD, RT_TEX = 'vinewood_fap_rt', 'screen'

local function ensureDui()
    if dui then return end
    dui = CreateDui(('nui://%s/html/screen.html'):format(GetCurrentResourceName()), S.width, S.height)
    local txd = CreateRuntimeTxd(RT_TXD)
    CreateRuntimeTextureFromDuiHandle(txd, RT_TEX, GetDuiHandle(dui))
end

local function apply()
    if applied then return end
    AddReplaceTexture(S.txd, S.texture, RT_TXD, RT_TEX)
    applied = true
end

local function unapply()
    if not applied then return end
    RemoveReplaceTexture(S.txd, S.texture)
    applied, currentId, lastHash = false, nil, nil
    if dui then SendDuiMessage(dui, json.encode({ action = 'off' })) end
end

local function slimState(st)
    if not st then return nil end
    return {
        fire = st.fire, zones = st.zones, active = st.active, silenced = st.silenced,
        evacuate = st.evacuate, test = st.test, testSounding = st.testSounding,
        disabled = st.disabled, alarmAt = st.alarmAt, dispatched = st.dispatched,
        sprinklers = st.sprinklers, serverTime = st.serverTime,
    }
end

CreateThread(function()
    while true do
        local pc = GetEntityCoords(PlayerPedId())
        local bestId, bestDist
        for id, sys in pairs(Systems) do
            for _, d in ipairs(sys.devices) do
                if d.type == 'panel' and d.mode == 'prop' then
                    local dist = #(pc - vec3(d.x, d.y, d.z))
                    if dist < S.distance and (not bestDist or dist < bestDist) then bestId, bestDist = id, dist end
                end
            end
        end

        if bestId and States[bestId] then
            ensureDui()
            apply()
            local sys = Systems[bestId]
            local payload = {
                action = 'screen',
                system = { label = sys.label, zones = sys.zones, devices = sys.devices, dispatch = sys.dispatch, dispatchDelay = sys.dispatchDelay },
                state = slimState(States[bestId]),
            }
            local encoded = json.encode(payload)
            -- serverTime changes every sync, so hash without it
            local hash = bestId .. json.encode({ payload.system.label, payload.system.zones, payload.state.fire, payload.state.zones, payload.state.active,
                payload.state.silenced, payload.state.evacuate, payload.state.test, payload.state.testSounding, payload.state.disabled, payload.state.dispatched, payload.state.sprinklers })
            local t = GetGameTimer()
            if hash ~= lastHash or bestId ~= currentId or t - lastSend > 5000 then
                SendDuiMessage(dui, encoded)
                lastHash, currentId, lastSend = hash, bestId, t
            end
        else
            unapply()
        end
        Wait(500)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if applied then RemoveReplaceTexture(S.txd, S.texture) end
    if dui then DestroyDui(dui) end
end)
