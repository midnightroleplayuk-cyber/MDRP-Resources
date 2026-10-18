--[[
  Shared NPC dialogue helpers — replaces instant Press-E / target actions
  with a mouse-driven choice UI (bubble / cyber panel).
]]
local Nui = require 'client.modules.nui'

local Dialogue = {}

---@param ped number|nil
---@param text string
---@param choices { id: string, label: string, style?: string }[]
---@param opts table|nil
---@return string|nil
function Dialogue.open(ped, text, choices, opts)
    opts = opts or {}
    if ped and DoesEntityExist(ped) then
        TaskTurnPedToFaceEntity(cache.ped, ped, 600)
        Wait(350)
    end
    return Nui.npcDialogue({
        ped = ped,
        text = text,
        choices = choices,
        style = opts.style,
        timeout = opts.timeout,
    })
end

--- Confirm / decline shortcut. Returns true if player picked the confirm choice.
---@param ped number|nil
---@param text string
---@param yesLabel string|nil
---@param noLabel string|nil
---@return boolean
function Dialogue.confirm(ped, text, yesLabel, noLabel)
    local choice = Dialogue.open(ped, text, {
        { id = 'yes', label = yesLabel or 'Let\'s go', style = 'confirm' },
        { id = 'no', label = noLabel or 'Nevermind', style = 'cancel' },
    })
    return choice == 'yes'
end

--- Talk / leave shortcut used by briefing contacts.
---@param ped number|nil
---@param text string
---@param talkLabel string|nil
---@param leaveLabel string|nil
---@return boolean
function Dialogue.talk(ped, text, talkLabel, leaveLabel)
    local choice = Dialogue.open(ped, text, {
        { id = 'talk', label = talkLabel or 'I\'m listening', style = 'confirm' },
        { id = 'leave', label = leaveLabel or 'Not now', style = 'cancel' },
    })
    return choice == 'talk'
end

return Dialogue
