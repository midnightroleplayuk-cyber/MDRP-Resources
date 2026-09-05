local config = lib.load('config')
local gs = config.GlobalSettings
local vs = config.VehiclesSettings

---@param decimal number
---@return boolean[]
local function sequencerToBits(decimal)
    local bits = {}
    for i = 31, 0, -1 do
        bits[32 - i] = ((decimal >> i) & 1) == 1
    end
    return bits
end

---@param vehModel number
---@return table|nil
local function getElsConfig(vehModel)
    local vc = vs[vehModel]
    return vc and vc.Els or nil
end

---@param vehModel number
---@return number|nil
local function getElsStageCount(vehModel)
    local vc = vs[vehModel]
    if vc and vc.Els and vc.Els.Stages then
        local count = 0
        for _ in pairs(vc.Els.Stages) do count = count + 1 end
        return count
    end
    return nil
end

---@param vehModel number
---@return number|nil
local function getNonElsStageCount(vehModel)
    local vc = vs[vehModel]
    if vc and not vc.Els and vc.Stages then
        local count = 0
        for _ in pairs(vc.Stages) do count = count + 1 end
        return count
    end
    return nil
end

---@param vehModel number
---@return boolean
local function hasTakedowns(vehModel)
    local vc = vs[vehModel]
    if not vc then return false end
    if vc.Els and vc.Els.Takedowns and vc.Els.Takedowns.extra then return true end
    if not vc.Els and vc.takedowns and vc.takedowns.extra then return true end
    return false
end

---@param vehModel number
---@return boolean
local function hasParkPattern(vehModel)
    local vc = vs[vehModel]
    if not vc then return false end
    if vc.Els and vc.Els.ParkPattern and next(vc.Els.ParkPattern) ~= nil then return true end
    if not vc.Els and vc.automaticpark then return true end
    return false
end

---@param vehModel number
---@return number
local function getMaxStage(vehModel)
    local elsCount = getElsStageCount(vehModel)
    if elsCount then return elsCount end
    local nonElsCount = getNonElsStageCount(vehModel)
    if nonElsCount then return nonElsCount end
    local vc = vs[vehModel]
    local hasPark = vc and (not vc.Els) and vc.automaticpark
    return hasPark and 2 or 1
end

---@param vehModel number
---@return SirenConfigTable
local function getVehicleConfig(vehModel)
    return vs[vehModel] or gs[1]
end

---@param vehModel number
---@return boolean
local function hasElsParkPattern(vehModel)
    local vc = vs[vehModel]
    return vc and vc.Els and vc.Els.ParkPattern and next(vc.Els.ParkPattern) ~= nil
end

---@param vehModel number
---@return table|nil
local function getNonElsStages(vehModel)
    local vc = vs[vehModel]
    if vc and not vc.Els and vc.Stages then return vc.Stages end
end

---@param vehModel number
---@return table|nil
local function getNonElsTakedowns(vehModel)
    local vc = vs[vehModel]
    if vc and not vc.Els and vc.takedowns and vc.takedowns.extra then return vc.takedowns end
end

return {
    sequencerToBits = sequencerToBits,
    getElsConfig = getElsConfig,
    getElsStageCount = getElsStageCount,
    getNonElsStageCount = getNonElsStageCount,
    hasTakedowns = hasTakedowns,
    hasParkPattern = hasParkPattern,
    getMaxStage = getMaxStage,
    getVehicleConfig = getVehicleConfig,
    hasElsParkPattern = hasElsParkPattern,
    getNonElsStages = getNonElsStages,
    getNonElsTakedowns = getNonElsTakedowns,
    Perms = config.Perms,
}
