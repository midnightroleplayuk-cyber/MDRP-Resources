local Config = require("config.main")

---@param name string
---@param resource string
---@return boolean
function detectFramework(name, resource)
	local state = GetResourceState(resource)
	local isStarted = state == "started"

	local active = false
	if Config.Framework == "auto" then
		active = isStarted
	else
		active = Config.Framework == name
	end

	return active
end
