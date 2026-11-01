function setBusy(state)
    dbug('setBusy(state)', state)
    LocalPlayer.state:set("busy",state,true)
end

function getBusy()
    local state = LocalPlayer.state.busy
    dbug('getBusy?', state)
    return state
end