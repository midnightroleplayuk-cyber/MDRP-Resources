if not Config.Modules.rackets then return end

local cfg = Config.Rackets
local busy = false

-- Shops come from the server (built-in plus any added in game); config is only a fallback
local shops = cfg.businesses
local function applyShops(list)
    if type(list) ~= 'table' then return end
    local out = {}
    for i, b in ipairs(list) do out[i] = { key = b.key, label = b.label, coords = vector3(b.x, b.y, b.z) } end
    shops = out
end
applyShops(GlobalState.vg_racket_shops)
AddStateBagChangeHandler('vg_racket_shops', 'global', function(_, _, value) applyShops(value) end)

local TALK_ANIM = { dict = 'misscarsteal4@actor', clip = 'actor_berating_loop' }
local THREAT_ANIM = { dict = 'misscommon@response', clip = 'bring_it_on' }
local COLLECT_ANIM = { dict = 'mp_common', clip = 'givetake1_a' }

local function notify(key, kind, ...)
    lib.notify({ description = locale(key, ...), type = kind or 'inform' })
end

local function canWork()
    local gang = GetPlayerGang()
    if not gang then return false end
    for _, p in ipairs(gang.permissions) do
        if p == '*' or p == 'rackets' then return true end
    end
    return false
end

local function progress(duration, labelKey, anim)
    return lib.progressBar({
        duration = duration, label = locale(labelKey), canCancel = true,
        disable = { move = true, car = true, combat = true }, anim = anim,
    })
end

local OUTCOME = {
    agreed = { 'racket_agreed', 'success' },
    taken_over = { 'racket_taken_over', 'success' },
    refused = { 'racket_refused', 'error' },
}

local function offer(b, intimidate)
    busy = true
    if progress(cfg.talkTime, intimidate and 'racket_leaning' or 'racket_talking', intimidate and THREAT_ANIM or TALK_ANIM) then
        local ok, res = lib.callback.await('vinewood_gangs:server:racketOffer', false, b.key, intimidate)
        if ok then
            local o = OUTCOME[res] or OUTCOME.refused
            notify(o[1], o[2], b.label)
        else
            notify(res or 'failed', 'error', cfg.minInfluence)
        end
    end
    busy = false
end

local function collect(b)
    busy = true
    if progress(cfg.collectTime, 'racket_collecting', COLLECT_ANIM) then
        local ok, res, hex = lib.callback.await('vinewood_gangs:server:racketCollect', false, b.key)
        if ok then
            notify('racket_collected', 'success', Utils.FormatMoney(res))
            if hex then notify('racket_collected_control', 'inform', hex.gained, hex.control) end
        else notify(res or 'failed', 'error') end
    end
    busy = false
end

local function openMenu(b)
    local info, err = lib.callback.await('vinewood_gangs:server:racketInfo', false, b.key)
    if not info then return notify(err or 'failed', 'error') end

    local options = {}
    if info.mine then
        options[#options + 1] = {
            title = locale('racket_menu_collect'),
            description = info.owed > 0 and locale('racket_menu_owed', Utils.FormatMoney(info.owed)) or locale('racket_menu_nothing'),
            icon = 'sack-dollar',
            disabled = info.owed <= 0,
            onSelect = function() collect(b) end,
        }
        options[#options + 1] = {
            title = locale('racket_menu_rate'),
            description = locale('racket_menu_rate_desc', Utils.FormatMoney(info.income), info.minutes),
            icon = 'clock', readOnly = true,
        }
    else
        local why = info.blocked and locale(info.blocked, info.blocked == 'racket_cooldown' and info.cooldown or cfg.minInfluence)
        local status = info.protectedBy and locale('racket_menu_paying', info.protectedBy) or locale('racket_menu_unprotected')
        options[#options + 1] = { title = status, description = info.area and locale('racket_menu_area', info.area) or nil, icon = 'store', readOnly = true }
        if info.freeGround and not info.blocked then
            options[#options + 1] = { title = locale('racket_menu_free_ground'), description = locale('racket_menu_free_ground_desc', info.area or '?'), icon = 'map', readOnly = true }
        end
        options[#options + 1] = {
            title = locale(info.protectedBy and 'racket_menu_takeover' or 'racket_menu_offer'),
            description = why or locale('racket_odds_' .. info.odds),
            icon = 'handshake', disabled = info.blocked ~= nil,
            onSelect = function() offer(b, false) end,
        }
        options[#options + 1] = {
            title = locale('racket_menu_lean'),
            description = why or locale('racket_menu_lean_desc'),
            icon = 'hand-fist', disabled = info.blocked ~= nil,
            onSelect = function() offer(b, true) end,
        }
    end

    lib.registerContext({ id = 'vg_racket', title = info.label, options = options })
    lib.showContext('vg_racket')
end

-- Prompt at each business counter for members who can run rackets
CreateThread(function()
    local shown
    while true do
        local sleep = 1000
        local target
        if not busy and canWork() then
            local pos = GetEntityCoords(cache.ped)
            for _, b in ipairs(shops) do
                local d = #(pos - b.coords)
                if d < 20.0 then sleep = 250 end
                if d < 1.8 then target = b sleep = 0 break end
            end
        end

        if target ~= shown then
            if shown then lib.hideTextUI() end
            if target then lib.showTextUI(locale('racket_prompt')) end
            shown = target
        end
        if target and IsControlJustPressed(0, 38) then
            lib.hideTextUI()
            shown = nil
            openMenu(target)
        end
        Wait(sleep)
    end
end)
