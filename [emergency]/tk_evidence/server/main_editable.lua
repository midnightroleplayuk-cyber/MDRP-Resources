function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = 'Notify',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(src, text, notifyType)
    end
end

function Webhook(message)
    local webhookLink = '' -- place your webhook link here on this line inside the quotes
    if not webhookLink or webhookLink == '' then return end

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = { ["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' })
end

function RemoveItemWithMetadata(playerId, item, amount, metadata)
    if Config.Inventory == 'ox' then
        local slotId = exports.ox_inventory:GetSlotIdWithItem(playerId, item, metadata, true)
        if slotId then
            exports.ox_inventory:RemoveItem(playerId, item, amount, nil, slotId)
        end

        return
    end

    if Config.Inventory == 'qs' then
        metadata.quality = 100
        exports['qs-inventory']:RemoveItem(playerId, item, amount, nil, metadata)
        return
    end

    local items = exports['qb-inventory']:GetItemsByName(playerId, item)
    if #items > 0 then
        for _,itemData in ipairs(items) do
            if itemData.info and itemData.info.evidenceId == metadata.evidenceId then
                exports['qb-inventory']:RemoveItem(playerId, item, amount, itemData.slot)
            end
        end
    end
end

function GetCurrentWeaponSerialNumber(playerId)
    if Config.Inventory == 'ox' then
        local weapon = exports.ox_inventory:GetCurrentWeapon(playerId)
        return weapon?.metadata?.serial
    end

    if Config.Framework == 'qb' and Config.Inventory == 'default' then
        local xPlayer = GetPlayerFromId(playerId)
        if not xPlayer then
            return
        end

        local ped = GetPlayerPed(playerId)
        local currentWeapon = GetSelectedPedWeapon(ped)

        if currentWeapon == `WEAPON_UNARMED` then
            return
        end

        for _,item in pairs(xPlayer.PlayerData.items) do
            if item.type == "weapon" and joaat(item.name) == currentWeapon then
                return item.info and item.info.serie
            end
        end
    end

    return
end

function RegisterMDTEvidence(playerId, evidence)
    local notes = ''

    if evidence.data.playerName then
        notes = notes .. 'DNA: ' .. evidence.data.playerName .. '\n'
    end

    if evidence.data.plate then
        notes = notes .. 'Plate: ' .. evidence.data.plate .. '\n'
    end

    if evidence.data.weaponName then
        notes = notes .. 'Weapon: ' .. evidence.data.weaponName .. '\n'
    end

    if evidence.data.weaponType then
        notes = notes .. 'Weapon Type: ' .. _U(evidence.data.weaponType) .. '\n'
    end

    if evidence.data.serialNumber then
        notes = notes .. 'Serial Number: ' .. evidence.data.serialNumber .. '\n'
    end

    if evidence.data.time then
        notes = notes .. 'Time: ' .. evidence.data.time .. '\n'
    end

    return exports.tk_mdt:registerEvidence({
        playerId = playerId,
        name = _U(evidence.data.evidenceType),
        page = 'police',
        notes = notes ~= '' and notes or nil,
    })
end

function RemoveMDTEvidence(evidence)
    exports.tk_mdt:removeEvidence(evidence.data.mdtEvidenceId)
end

function GetGSRLoadQuery()
    return Config.Framework == 'esx' and 'SELECT identifier, gsr FROM users WHERE gsr > ?' or 'SELECT citizenid as identifier, gsr FROM players WHERE gsr > ?'
end

function GetGSRUpdateQuery()
    return Config.Framework == 'esx' and 'UPDATE users SET gsr = ? WHERE identifier = ?' or 'UPDATE players SET gsr = ? WHERE citizenid = ?'
end