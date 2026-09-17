--- @param oldStatus: "offduty" | "active" | "busy"
--- @param newStatus: "offduty" | "active" | "busy"
--- @param playerId: number
function onDutyChange(oldStatus, newStatus, playerId)   
end

--- @param playerId: number
--- @param newStatus: "offduty" | "active" | "busy"
function changePlayerDuty(playerId, newStatus)
    applyActivity(playerId, newStatus)
end
exports("changePlayerDuty", changePlayerDuty)