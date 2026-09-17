Functions.particles = {}

local defaultTimeout = 5000

---@param message string @ Failure detail
local function warn(message)
    print(("^3[WARNING] [%s] %s^7"):format(ResName, message))
end

---@param asset string
---@param skipWarning? boolean
---@param timeout? integer @ Maximum wait in milliseconds
---@return boolean loaded
function Functions.particles.load(asset, skipWarning, timeout)
    if (type(asset) ~= "string" or asset == "") then
        if (not skipWarning) then warn("Invalid particle asset name") end

        return false
    end

    timeout = math.max(0, math.floor(tonumber(timeout) or defaultTimeout))
    local startedAt = GetGameTimer()

    RequestNamedPtfxAsset(asset)

    while (not HasNamedPtfxAssetLoaded(asset)) do
        if (GetGameTimer() - startedAt >= timeout) then
            RemoveNamedPtfxAsset(asset)

            if (not skipWarning) then
                warn(("Timed out loading particle asset '%s' after %dms"):format(asset, timeout))
            end

            return false
        end

        Wait(0)
    end

    return true
end

---@param asset string
function Functions.particles.unload(asset)
    if (type(asset) ~= "string" or asset == "") then return end

    RemoveNamedPtfxAsset(asset)
end

return Functions.particles