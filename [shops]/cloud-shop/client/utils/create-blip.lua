---@param coords vector3
---@param config table
---@return integer
function createBlip(coords, config)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, config.sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, config.scale)
	SetBlipColour(blip, config.color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(config.name)
	EndTextCommandSetBlipName(blip)

	return blip
end
