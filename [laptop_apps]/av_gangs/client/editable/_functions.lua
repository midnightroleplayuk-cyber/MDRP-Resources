function setBusy(state)
	LocalPlayer.state:set("busy", state, true)
end

function isBusy()
	return LocalPlayer.state.busy
end

-- Triggered when the player is in a territory and kills another player
-- Return false to cancel the event from being sent to the server
-- Useful for players playing paintball or doing some other activity where they don't want to trigger territory events
function isAllowedToTrigger()
	return true
end
