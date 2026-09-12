-- Chat bridge: sends a chat message to a player from any tgiann script.
-- Supports tgiann-chat (tag style) and the default FiveM chat (colored text) out
-- of the box, edit this file to adapt it to a different chat resource
local tgiannChat = GetResourceState("tgiann-chat") ~= "missing"

---On tgiann-chat every field is used, the default FiveM chat only uses title, message and color
---@param src number Player id, -1 sends to everyone
---@param data TgiCoreChatMessage
tgiCore.SendChatMessage = function(src, data)
    local color = data.color or { 54, 255, 159 }
    if tgiannChat then
        TriggerClientEvent("chat:addMessage", src, {
            args = { data.message },
            color = data.textColor,
            multiline = data.multiline,
            tags = data.tags or { { tag = data.title, bgColor = color } },
        })
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = color,
            args = { data.title, data.message },
        })
    end
end
