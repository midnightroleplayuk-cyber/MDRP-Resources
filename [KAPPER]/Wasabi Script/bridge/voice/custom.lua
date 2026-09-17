--[[
    Community voice adapter contract

    Set Config.Radio.provider to the name registered below. Adapter methods must
    return true only after the external voice system accepted the change. `get`
    must return the verified current MDT channel before any mutation. The MDT
    compensates failed `set`/`clear` calls back to that value; custom adapters must
    therefore keep all three methods truthful and safe to retry.

    MdtRadio.register('my-voice', {
        available = function(config)
            return GetResourceState('my-voice') == 'started'
        end,
        set = function(source, channel, channelConfig, config)
            -- channel is the MDT channel value. channelConfig is its full row from
            -- Config.Radio.channels (or nil for a dynamic channel).
            return true -- or: return false, 'reason'
        end,
        clear = function(source, channel, channelConfig, config)
            return true -- or: return false, 'reason'
        end,
        get = function(source, channels, config)
            -- Return the matching MDT channel value, or nil when off radio.
            return nil
        end,
    })
]]
