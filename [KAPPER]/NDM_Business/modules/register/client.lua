local CONFIRM_TIMEOUT = 30000
local confirmToken = 0

local ACTIONS = { refresh = true, charge = true }

function NDM.OpenRegister(pointId)
    if NDM.IsPanelOpen() then return end
    CreateThread(function()
        local ok, result = pcall(lib.callback.await, 'ndm_business:register:open', false, { point = pointId })
        if not ok or not result or not result.ok then
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
            return
        end
        NDM.SetPanelOpen(true)
        SendNUIMessage({ action = 'openRegister', data = result.data })
    end)
end

RegisterNUICallback('registerRequest', function(body, cb)
    local action = body and body.action
    if not ACTIONS[action] then
        cb({ ok = false, error = 'Unknown action.' })
        return
    end
    local ok, result = pcall(lib.callback.await, 'ndm_business:register:' .. action, false, body.payload)
    if not ok or result == nil then
        cb({ ok = false, error = 'The server did not respond.' })
        return
    end
    cb(result)
end)

lib.callback.register('ndm_business:register:confirm', function(request)
    if NDM.IsPanelOpen() or type(request) ~= 'table' then return false end

    confirmToken = confirmToken + 1
    local token = confirmToken
    SetTimeout(CONFIRM_TIMEOUT, function()
        if confirmToken == token then lib.closeAlertDialog() end
    end)

    local answer = lib.alertDialog({
        header = ('Pay %s'):format(request.venue),
        content = ('%s\n\n**Total: $%d** from your %s.'):format(request.summary, request.total, request.account),
        centered = true,
        cancel = true,
        labels = { confirm = 'Pay', cancel = 'Decline' },
    })
    confirmToken = confirmToken + 1
    return answer == 'confirm'
end)
