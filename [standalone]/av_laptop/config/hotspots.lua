-- The hotspot list (with passwords) can be found in server/editable/hotspots.lua

-- Use the following function to enable/disable the WiFi panel
function WiFiState(serial, isPC)
	local enabled = true
	-- Run your custom code here:

	dbug("WiFiState(serial, isPC?, enabled?)", serial, isPC, enabled)
	return enabled -- true or false
end

