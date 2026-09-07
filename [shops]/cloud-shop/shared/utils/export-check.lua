---@param resource string
---@param export string
---@return boolean
function doesExportExist(resource, export)
	local exists = false

	TriggerEvent((("__cfx_export_%s_%s"):format(resource, export)), function(_)
		exists = true
	end)

	return exists
end
