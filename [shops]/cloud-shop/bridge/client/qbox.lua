if not detectFramework("qbox", "qbx_core") then return end

-- [[ Death Handling ]]

local Interaction = require("client.modules.interaction")

RegisterNetEvent("qbx_core:client:onSetMetaData", function(key, oldValue, newValue)
	if key == "isdead" and newValue then
		Interaction.CloseUI()
	elseif key == "inlaststand" and newValue then
		Interaction.CloseUI()
	end
end)
