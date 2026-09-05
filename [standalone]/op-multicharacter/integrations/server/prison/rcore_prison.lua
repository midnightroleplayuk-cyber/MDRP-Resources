if Config.Prison ~= "rcore_prison" then return end

lib.callback.register('op-multicharacter:isPrisoner', function(source)
    return exports['rcore_prison']:IsPrisoner(source) == true
end)