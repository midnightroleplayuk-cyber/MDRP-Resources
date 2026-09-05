if Config.Housing ~= "bcs_housing" then return end

function giveStarterHouse(identifier, playerId)
    -- bcs_housing integration is located in: op-multicharacter/framework/client/shared.lua
    -- Do not delete this function!

    debugPrint('bcs_housing -> triggering SetupSpawnUI')
    debugPrint("playerId", playerId)
    TriggerClientEvent('Housing:client:SetupSpawnUI', tonumber(playerId), nil)
end
