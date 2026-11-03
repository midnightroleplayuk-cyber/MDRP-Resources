
-- canUse(playerId) is triggered server side only, return boolean to allow player to use the Class type on App
-- playerId is the player server id
-- value:string is used internal for code
-- label:string For UI only

local VehicleClasses = {
    {value = "d", label = "D",
        canUse = function(playerId)
            return true
        end
    },
    {value = "c", label = "C",
        canUse = function(playerId)
            return true
        end
    },
    {value = "b", label = "B",
        canUse = function(playerId)
            return true
        end
    },
    {value = "a", label = "A",
        canUse = function(playerId)
            return true
        end
    },
    {value = "a+", label = "A+",
        canUse = function(playerId)
            return true
        end
    },
    {value = "s", label = "S",
        canUse = function(playerId)
            return true
        end
    },
    {value = "s+", label = "S+",
        canUse = function(playerId)
            return true
        end
    },
    {value = "m", label = "M",
        canUse = function(playerId)
            return true
        end
    },
}

-- Don't modify the callback, please and thank you :)
lib.callback.register('av_racing:getClasses', function(source, isAdmin)
    dbug('getClasses(isAdmin?)', isAdmin)
    local classes = {
        {value = "all", label = Lang['all']}
    }
    for i=1, #VehicleClasses do
        local class = VehicleClasses[i]
        local canAdd = isAdmin
        if not canAdd then
            canAdd = class["canUse"] and class["canUse"](source)
        end
        if canAdd then
            classes[#classes+1] = {
                value = class['value'],
                label = class['label'],
            }
        end
    end
    return classes
end)