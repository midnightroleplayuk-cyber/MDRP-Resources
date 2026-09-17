-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- editable (not escrowed) — api keys, webhook, billing/jail hooks go here

--[[
    FiveManage API key for cloud photo uploads.
    Get one here: https://refer.fivemanage.com/wasabi
    Requires screenshot-basic. DO NOT SHARE THIS KEY.
--]]
Config.FIVEMANAGE_API_KEY = ''

-- discord webhook for ServerConfig.AuditLog
Config.DiscordWebhook = ''

--[[
    CHARGE LINK / UNLINK INTEGRATION HOOKS

    Fired when an officer links/unlinks a charge to/from an incident. Wire your
    billing (fines) and jail (jail_time) systems here. Both run server-side; a
    matching client event also fires on the citizen if online.

    Parameters:
      chargeData        { id, title, description, jail_time, fine, category, ... }
      primaryIdentifier the citizen identifier the incident is filed against
      incidentData      { id, title, description, primary_citizen_data, ... }
      officerData       { identifier, name, job, ... }
      adjustments       { adjusted_fine, adjusted_jail, fine_reduction, jail_reduction }
--]]
AddEventHandler('wasabi_mdt:onChargeLinked', function(chargeData, primaryIdentifier, incidentData, officerData, adjustments)
    local fine = adjustments and adjustments.adjusted_fine or chargeData.fine
    local jailTime = adjustments and adjustments.adjusted_jail or chargeData.jail_time

    -- Example billing integration (nass_billing):
    -- if fine and fine > 0 and incidentData.primary_citizen_data then
    --     exports['nass_billing']:createInvoiceByIdentifier(
    --         officerData.name, officerData.identifier,
    --         incidentData.primary_citizen_data.name, primaryIdentifier,
    --         chargeData.title, chargeData.description, fine, officerData.job, nil
    --     )
    -- end

    -- Example jail integration (rcore_prison):
    -- if jailTime and jailTime > 0 then
    --     local bridge = Modules.require('bridge')
    --     local playerId = bridge.getPlayerIdFromIdentifier(primaryIdentifier)
    --     local officerPlayerId = bridge.getPlayerIdFromIdentifier(officerData.identifier)
    --     if playerId then
    --         exports['rcore_prison']:Jail(playerId, jailTime, chargeData.title, officerPlayerId or nil)
    --     end
    -- end
end)

AddEventHandler('wasabi_mdt:onChargeUnlinked', function(chargeData, primaryIdentifier, incidentData, officerData)
    -- Example refund:
    -- exports['your_billing']:refundBill(primaryIdentifier, chargeData.fine, 'MDT Charge Removed: ' .. chargeData.title)
end)
