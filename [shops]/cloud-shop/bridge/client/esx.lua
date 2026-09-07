if not detectFramework("esx", "es_extended") then return end

-- [[ Death Handling ]]

local Interaction = require("client.modules.interaction")

AddEventHandler("esx:onPlayerDeath", Interaction.CloseUI)
