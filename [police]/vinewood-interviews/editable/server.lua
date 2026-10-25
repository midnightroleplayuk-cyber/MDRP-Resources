--[[
    Open server file: not encrypted by escrow. Change notifications or hook other scripts
    into interview events here. Updates to vinewood-interviews won't overwrite your changes
    as long as you keep this file when updating.
]]
Editable = Editable or {}

--- Notification sent to a player from the server.
function Editable.Notify(src, message, kind)
    TriggerClientEvent('ox_lib:notify', src, {
        title = Config.Text.title,
        description = message,
        type = kind or 'inform',
    })
end

--- Called when a recording starts.
--- data = { id, roomId, roomLabel, caseRef, interviewee, intervieweeCid, officers, solicitor, cctv, startedBy (server id) }
function Editable.OnInterviewStarted(data)
    -- Example: exports['my-dispatch']:Log(('Interview %d started in %s'):format(data.id, data.roomLabel))
end

--- Called when a recording ends.
--- data = { id, roomId, roomLabel, durationMs, reason ('manual' | 'empty' | 'max_duration') }
function Editable.OnInterviewEnded(data)
end
