--- Resolves Config.UI defaults for world HUD minigames and progress bars.

local UiConfig = {}

---@param base table|nil
---@param override table|nil
---@return table
local function merge(base, override)
    local out = {}
    for k, v in pairs(base or {}) do
        out[k] = v
    end
    for k, v in pairs(override or {}) do
        if type(v) == 'table' and type(out[k]) == 'table' and not v[1] then
            out[k] = merge(out[k], v)
        else
            out[k] = v
        end
    end
    return out
end

---@param jobName string|nil
---@param action string|nil
---@return table|nil
function UiConfig.getJobAction(jobName, action)
    if not jobName or not action then return nil end
    local ui = Config.UI or {}
    local jobs = ui.Jobs or {}
    local jobCfg = jobs[jobName]
    if not jobCfg then return nil end
    return jobCfg[action]
end

---@param game string
---@param opts table|nil
---@param jobName string|nil
---@param action string|nil
---@return string, table
function UiConfig.applyMinigame(game, opts, jobName, action)
    local ui = Config.UI or {}
    local mg = ui.Minigame or {}
    opts = opts or {}

    local actionCfg = UiConfig.getJobAction(jobName, action)
    local actionMinigame = actionCfg and actionCfg.minigame or {}

    local resolvedGame = actionMinigame.game or game
    if type(resolvedGame) == 'string' then
        resolvedGame = resolvedGame:gsub('^eye:', '')
    end
    local gameDefaults = (mg.Games or {})[resolvedGame] or {}

    local merged = merge(gameDefaults, actionMinigame)
    merged = merge(merged, opts)
    -- Drop legacy external-resource fields (game pack is bundled in NUI now)
    merged.provider = nil
    merged.fallback = nil
    merged.eye = nil

    if merged.allowCancel == nil and mg.AllowCancel ~= nil then
        merged.allowCancel = mg.AllowCancel
    end

    if merged.difficulty == nil and mg.DefaultDifficulty then
        merged.difficulty = mg.DefaultDifficulty
    end

    return resolvedGame, merged
end

---@param data table|nil
---@param jobName string|nil
---@param action string|nil
---@return table
function UiConfig.applyProgressBar(data, jobName, action)
    local ui = Config.UI or {}
    local pb = ui.ProgressBar or {}
    local actionCfg = UiConfig.getJobAction(jobName, action)
    local actionProgress = actionCfg and actionCfg.progress or {}
    return merge(merge(pb, actionProgress), data or {})
end

---@param jobName string
---@param action string
---@param optsOverride table|nil
---@return boolean
function UiConfig.playJobMinigame(jobName, action, optsOverride)
    local actionCfg = UiConfig.getJobAction(jobName, action)
    local minigame = actionCfg and actionCfg.minigame
    if not minigame or not minigame.game then
        lib.print.error(('Config.UI.Jobs.%s.%s.minigame is not configured'):format(jobName, action))
        return false
    end

    local Nui = require 'client.modules.nui'
    local game, opts = UiConfig.applyMinigame(minigame.game, optsOverride, jobName, action)
    return Nui.playMinigame(game, opts)
end

---@param jobName string
---@param action string
---@param data table|nil
---@return boolean
function UiConfig.progressJobBar(jobName, action, data)
    local Nui = require 'client.modules.nui'
    local merged = UiConfig.applyProgressBar(data, jobName, action)

    -- Default lockpick / hotwire hand anim whenever progress has no custom anim
    local lockpickActions = {
        unlockVehicle = true,
        openCrate = true,
        openContainer = true,
        hotwireForklift = true,
    }
    if not merged.anim and action and lockpickActions[action] then
        merged.anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
            flag = 49,
        }
    end

    return Nui.progressBar(merged)
end

return UiConfig
