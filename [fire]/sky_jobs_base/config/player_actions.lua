-- Editable integrations for the selected player's actions and document UI.
-- Server hooks receive only targets and license types authorized by Jobs Base.
if IsDuplicityVersion() then
    Config.PlayerActions = {
        documents = function(target_id, permission, licenses)
            local cards = {}
            local provider = GetResourceState("qbx_idcard") == "started" and "qbx_idcard"
                or GetResourceState("um-idcard") == "started" and "um-idcard"
            if provider then
                local item_types = permission == "identity" and { id_card = {} } or {}
                local license_items = { drive = "driver_license", driver = "driver_license", weapon = "weaponlicense" }
                for _, license in ipairs(licenses) do
                    local item_name = license_items[license.type]
                    if item_name then
                        item_types[item_name] = item_types[item_name] or {}
                        item_types[item_name][#item_types[item_name] + 1] = license.type
                    end
                end
                for item_name, license_types in pairs(item_types) do
                    local item = Sky.FW.GetInventoryItem(target_id, item_name)
                    if item and item.amount > 0 and item.metadata and item.metadata.cardtype == item_name then
                        cards[#cards + 1] = { provider = provider, type = item_name,
                            data = item.metadata, licenseTypes = license_types }
                    end
                end
                return #cards > 0 and cards or nil
            end
            if Sky.Config.framework ~= "esx" or GetResourceState("jsfour-idcard") ~= "started" then return nil end
            if permission == "identity" then
                cards[1] = { type = "identity", data = { licenses = {} }, licenseTypes = {} }
            else
                local driving_types = { drive = true, drive_bike = true, drive_truck = true }
                for _, card_type in ipairs({ "driver", "weapon" }) do
                    local card = { type = card_type, data = { licenses = {} }, licenseTypes = {} }
                    for _, license in ipairs(licenses) do
                        if card_type == "driver" and driving_types[license.type] or card_type == "weapon" and license.type == "weapon" then
                            card.data.licenses[#card.data.licenses + 1] = { type = license.type }
                            card.licenseTypes[#card.licenseTypes + 1] = license.type
                        end
                    end
                    if #card.licenseTypes > 0 then cards[#cards + 1] = card end
                end
            end
            if #cards == 0 then return nil end
            local user = Sky.DB.Select("SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = ?",
                { Sky_Jobs.PlayerCache.GetIdentifier(target_id) })
            if not user or not user[1] then return nil, "unavailable" end
            for _, card in ipairs(cards) do
                card.provider = "jsfour-idcard"
                card.data.user, card.data.ownerServerId = user, target_id
            end
            return cards
        end,
        openDocument = function(source_id, card, target_id, authorize)
            local allowed, reason = authorize()
            if not allowed then return false, reason end
            if GetResourceState(card.provider) ~= "started" then return false, "unavailable" end
            if card.provider == "jsfour-idcard" then
                TriggerClientEvent("jsfour-idcard:open", source_id, card.data, card.type ~= "identity" and card.type or nil)
            else
                TriggerClientEvent("um-idcard:client:sendData", source_id, card.data)
            end
            return true
        end,
    }
    return
end

-- Radial/ox_target hooks return success and an optional error reason.
-- Identity defaults to the selected character's cached identity; it needs no consent popup.
-- To use your own ID resource, replace identity(target_id) below with its client event
-- or export and return success/error. Keep target_id as the selected person's server ID;
-- the external resource must still authorize its own server operation.
-- The server documents/openDocument callbacks above integrate native document cards.
Config.PlayerActions = {
    billing = function(target_id)
        return Sky_Jobs.OpenPlayerInvoice(target_id)
    end,
    identity = function(target_id)
        return Sky_Jobs.RequestPlayerIdentity(target_id, "identity")
    end,
    licenses = function(target_id)
        return Sky_Jobs.RequestPlayerIdentity(target_id, "licenses")
    end,
    openDocument = function(target_id, permission, card_type, target_identifier)
        local response = Sky.Cb.TriggerWithTimeout("sky_jobs_base:interactions:identity:request", 22000,
            target_id, permission, card_type, target_identifier)
        if not response then return false, "unavailable" end
        return response.success, response.error
    end,
}
