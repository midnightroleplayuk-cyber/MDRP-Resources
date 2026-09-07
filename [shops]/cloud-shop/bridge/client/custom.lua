if not detectFramework("custom", "your_framework") then return end

-- [[ Death Handling ]]

local Interaction = require("client.modules.interaction")

AddEventHandler("baseevents:onPlayerDied", Interaction.CloseUI)
