if not IsActiveFramework("qbx") then return end

Framework = Framework or {}
Framework.Functions = Framework.Functions or {}

if IsDuplicityVersion() then

  ---@param source number
  ---@return string? name, number grade
  Framework.Functions.GetJob = function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return nil, 0 end
    local job = Player.PlayerData.job or {}
    return job.name, (job.grade and job.grade.level) or 0
  end

  ---Stable per-character id. Poster ownership is keyed on this, so it has to
  ---survive a reconnect (unlike `source`)
  ---@param source number
  ---@return string?
  Framework.Functions.GetIdentifier = function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    return Player and Player.PlayerData.citizenid or nil
  end

  ---@param source number
  ---@return string?
  Framework.Functions.GetCharacterName = function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    local charinfo = Player and Player.PlayerData.charinfo
    if not charinfo then return nil end
    return ("%s %s"):format(charinfo.firstname or "", charinfo.lastname or ""):match("^%s*(.-)%s*$")
  end

  ---@param source number
  ---@return string?
  Framework.Functions.GetPhone = function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    local charinfo = Player and Player.PlayerData.charinfo
    return charinfo and charinfo.phone or nil
  end

  ---@param source number
  ---@param permission string
  ---@return boolean
  Framework.Functions.IsAdmin = function(source, permission)
    return exports.qbx_core:HasPermission(source, permission) == true
  end

else

  ---@return string? name, number grade
  Framework.Functions.GetJob = function()
    local job = (exports.qbx_core:GetPlayerData() or {}).job or {}
    return job.name, (job.grade and job.grade.level) or 0
  end

end
