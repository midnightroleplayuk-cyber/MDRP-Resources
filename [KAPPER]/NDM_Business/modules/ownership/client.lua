local CONFIRM_TIMEOUT = 30000
local confirmToken = 0

function NDM.OpenSale(pointId)
    CreateThread(function()
        local ok, info = pcall(lib.callback.await, 'ndm_business:ownership:info', false, { point = pointId })
        if not ok or not info then
            lib.notify({ type = 'error', description = 'This business is not for sale.' })
            return
        end

        local answer = lib.alertDialog({
            header = ('Buy %s'):format(info.label),
            content = ('Buy this %s for **$%d** from your bank account?'):format(info.type, info.price),
            centered = true,
            cancel = true,
            labels = { confirm = 'Buy business', cancel = 'Not now' },
        })
        if answer ~= 'confirm' then return end

        local called, result = pcall(lib.callback.await, 'ndm_business:ownership:buy', false, {
            point = pointId,
            price = info.price,
        })
        if called and result and result.ok then
            lib.notify({ type = 'success', description = ('You now own %s. Use /business to manage it.'):format(info.label) })
        else
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
        end
    end)
end

lib.callback.register('ndm_business:ownership:confirmTransfer', function(offer)
    if NDM.IsPanelOpen() or type(offer) ~= 'table' then return false end

    confirmToken = confirmToken + 1
    local token = confirmToken
    SetTimeout(CONFIRM_TIMEOUT, function()
        if confirmToken == token then lib.closeAlertDialog() end
    end)

    local answer = lib.alertDialog({
        header = 'Business transfer',
        content = ('%s wants to give you **%s**. Accept ownership?'):format(offer.from or 'A player', offer.venue),
        centered = true,
        cancel = true,
        labels = { confirm = 'Accept', cancel = 'Decline' },
    })
    confirmToken = confirmToken + 1
    return answer == 'confirm'
end)
