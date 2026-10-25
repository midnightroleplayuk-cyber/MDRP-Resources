---@param msg string
---@param type? "success" | "warning" | "error"
---@param time? number
function Framework.Client.Notify(msg, type, time)
  type = type or "success"
  time = time or 5000

  if (Config.Notifications == "auto" and GetResourceState("okokNotify") == "started") or Config.Notifications == "okokNotify" then
    exports["okokNotify"]:Alert("Mechanic", msg, time, type)
  elseif (Config.Notifications == "auto" and GetResourceState("ps-ui") == "started") or Config.Notifications == "ps-ui" then
    exports["ps-ui"]:Notify(msg, type, time)
  elseif (Config.Notifications == "auto" and GetResourceState("nox_notify") == "started") or Config.Notifications == "nox_notify" then
    TriggerEvent("nox_notify:showClientNotify", "Mechanic", msg, type, time)
  elseif (Config.Notifications == "auto" and GetResourceState("ox_lib") == "started") or Config.Notifications == "ox_lib" then
    exports["ox_lib"]:notify({
      title = "Mechanic",
      description = msg,
      type = type
    })
  else
    if Config.Framework == "QBCore" then
      return QBCore.Functions.Notify(msg, type, time)
    elseif Config.Framework == "Qbox" then
      exports.qbx_core:Notify(msg, type, time)
    elseif Config.Framework == "ESX" then
      return ESX.ShowNotification(msg, type)
    else
      BeginTextCommandThefeedPost("STRING")
      AddTextComponentSubstringPlayerName(("[%s] %s"):format(type:upper(), msg))
      EndTextCommandThefeedPostTicker(true, true)
    end
  end
end

RegisterNetEvent("jg-handling:client:notify", function(...)
  Framework.Client.Notify(...)
end)

-- Get a nice vehicle label from either QB/Qbx shared or GTA natives 
---@param model string | number
function Framework.Client.GetVehicleLabel(model)
  if type(model) == "string" then
    if Config.Framework == "QBCore" and QBCore.Shared.Vehicles then
      local vehShared = QBCore.Shared.Vehicles[model]
      if vehShared then
        return vehShared.brand .. " " .. vehShared.name
      end
    end

    if Config.Framework == "Qbox" and exports.qbx_core:GetVehiclesByName() then
      local vehShared = exports.qbx_core:GetVehiclesByName()[model]
      if vehShared then
        return vehShared.brand .. " " .. vehShared.name
      end
    end
  end

  local hash = type(model) == "string" and joaat(model) or model
  local makeName = GetMakeNameFromVehicleModel(hash)
  local modelName = GetDisplayNameFromVehicleModel(hash)
  local label = GetLabelText(makeName) .. " " .. GetLabelText(modelName)

  if makeName == "CARNOTFOUND" or modelName == "CARNOTFOUND" then
    label = tostring(model)
  else
    if GetLabelText(modelName) == "NULL" and GetLabelText(makeName) == "NULL" then
      label = (makeName or "") .. " " .. (modelName or "")
    elseif GetLabelText(makeName) == "NULL" then
      label = GetLabelText(modelName)
    end
  end

  return label
end

---@param vehicle integer
---@return string|false plate
function Framework.Client.GetPlate(vehicle)
  local plate = GetVehicleNumberPlateText(vehicle)
  if not plate or plate == nil or plate == "" then return false end

  if GetResourceState("brazzers-fakeplates") == "started" then
    local originalPlate = lib.callback.await("jg-handling:server:brazzers-get-plate-from-fakeplate", false, plate)
    if originalPlate then plate = originalPlate end
  end

  local trPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1")
  return trPlate
end