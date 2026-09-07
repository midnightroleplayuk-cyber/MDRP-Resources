if not IsActiveFramework("esx") then return end

Framework = Framework or {}
Framework.Functions = Framework.Functions or {}
Framework.Core = exports.es_extended:getSharedObject()

if IsDuplicityVersion() then

  ---@param source number
  ---@return string? name, number grade
  Framework.Functions.GetJob = function(source)
    local xPlayer = Framework.Core.GetPlayerFromId(source)
    if not xPlayer then return nil, 0 end
    local job = xPlayer.getJob() or {}
    return job.name, tonumber(job.grade) or 0
  end

  ---Stable per-character id. Poster ownership is keyed on this, so it has to
  ---survive a reconnect (unlike `source`)
  ---@param source number
  ---@return string?
  Framework.Functions.GetIdentifier = function(source)
    local xPlayer = Framework.Core.GetPlayerFromId(source)
    return xPlayer and xPlayer.identifier or nil
  end

  ---@param source number
  ---@return string?
  Framework.Functions.GetCharacterName = function(source)
    local xPlayer = Framework.Core.GetPlayerFromId(source)
    if not xPlayer then return nil end
    return (xPlayer.getName and xPlayer.getName()) or xPlayer.name
  end

  ---ESX has no first-party phone column; leave it to the framework-agnostic
  ---default unless a server wires one up here
  ---@return string?
  Framework.Functions.GetPhone = function()
    return nil
  end

  ---@param source number
  ---@param permission string
  ---@return boolean
  Framework.Functions.IsAdmin = function(source, permission)
    return IsPlayerAceAllowed(source, permission) == true
  end

else

  ---@return string? name, number grade
  Framework.Functions.GetJob = function()
    local job = (Framework.Core.GetPlayerData() or {}).job or {}
    return job.name, tonumber(job.grade) or 0
  end

end
