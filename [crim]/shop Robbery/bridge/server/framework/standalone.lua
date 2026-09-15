if not Bridge.ShouldLoadFramework('standalone') then return end

Bridge.SetFramework('standalone', {
    getPlayer = function(src)
        return { source = src }
    end,

    getIdentifier = function(src)
        return GetPlayerIdentifierByType(src, 'license') or ('source:%s'):format(src)
    end,

    getJob = function()
        return nil, false
    end
})
