-- ox_inventory item-use bridge. Consumption remains in server placement handlers.
exports('UseTapeItem',function(data,slot)
 if not Config.Inventory.Enabled or Config.Inventory.System~='ox' then
  if TapeClient then TapeClient.notify('Enable Inventory with System=ox in APEX Tape config.lua.','error') end
  return
 end
 if GetResourceState('ox_inventory')~='started' or type(data)~='table' or data.name~=Config.Inventory.TapeItem then return end
 exports.ox_inventory:useItem(data,function(used)
  if not used then return end
  -- The normal menu command checks APEX permissions; placement checks inventory again.
  CreateThread(function()ExecuteCommand(TapeCommands.name('changetape'))end)
 end)
end)
