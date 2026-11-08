if not Config.Modules.informants then return end

local cfg = Config.Informants
local busy = false

local PHONE_ANIM = { dict = 'cellphone@', clip = 'cellphone_call_listen_base', flag = 49 }
local PHONE_PROP = { model = 'prop_npc_phone_02', bone = 28422, pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) }

local function notify(key, kind, ...)
    lib.notify({ description = locale(key, ...), type = kind or 'inform' })
end

local function call(seconds, labelKey)
    return lib.progressBar({
        duration = seconds * 1000, label = locale(labelKey), canCancel = true,
        disable = { car = false, combat = true }, anim = PHONE_ANIM, prop = PHONE_PROP,
    })
end

local function register()
    local choice = lib.alertDialog({
        header = locale('informant_offer_title'),
        content = locale('informant_offer_body'),
        centered = true, cancel = true,
        labels = { confirm = locale('informant_offer_yes'), cancel = locale('informant_offer_no') },
    })
    if choice ~= 'confirm' then return end
    if not call(6, 'informant_calling') then return end
    local ok, res = lib.callback.await('vinewood_gangs:server:informantRegister', false)
    if ok then notify('informant_registered', 'success', res) else notify(res or 'failed', 'error') end
end

local function tip(option)
    if not call(8, 'informant_talking') then return end
    local ok, res = lib.callback.await('vinewood_gangs:server:informantTip', false, option.key)
    if ok then notify('informant_paid', 'success', Utils.FormatMoney(res)) else notify(res or 'failed', 'error') end
end

function UseBurnerPhone()
    if busy then return end
    busy = true
    local menu, err = lib.callback.await('vinewood_gangs:server:informantMenu', false)
    busy = false
    if not menu then return notify(err or 'failed', 'error') end
    if menu.stopped then return notify('informant_stopped', 'error') end
    if not menu.registered then return register() end

    local options = {
        { title = locale('informant_menu_status', menu.code), description = locale('informant_menu_stats', menu.tips, Utils.FormatMoney(menu.earned), menu.left), icon = 'user-secret', readOnly = true },
    }
    if not menu.inGang then
        options[#options + 1] = { title = locale('informant_menu_nothing'), description = locale('informant_menu_nothing_desc'), readOnly = true }
    end
    for _, o in ipairs(menu.options) do
        options[#options + 1] = {
            title = o.label,
            description = o.blocked or locale('informant_menu_pays', Utils.FormatMoney(o.pay)),
            icon = 'phone', disabled = o.blocked ~= nil or menu.left <= 0,
            onSelect = function() tip(o) end,
        }
    end
    lib.registerContext({ id = 'vg_burner', title = locale('informant_menu_title'), options = options })
    lib.showContext('vg_burner')
end

exports('useBurner', UseBurnerPhone)
RegisterNetEvent('vinewood_gangs:client:burner', UseBurnerPhone)
if cfg.command then RegisterCommand(cfg.command, UseBurnerPhone, false) end
