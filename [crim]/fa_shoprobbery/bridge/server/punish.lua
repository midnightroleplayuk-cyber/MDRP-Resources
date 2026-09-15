ServerEditable = ServerEditable or {}

function ServerEditable.Punish(src, reason, context)
    Bridge.Log(src, 'security_violation', {
        reason = reason,
        context = context or {}
    })

    if Config.Security.DropOnExploit then
        DropPlayer(src, reason)
    end
end
