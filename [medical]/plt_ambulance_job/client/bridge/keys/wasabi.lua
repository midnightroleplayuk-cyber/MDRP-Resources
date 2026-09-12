if Bridge.Keys ~= 'wasabi' then return end

Keys.SetProvider('wasabi_carkeys', function(plate)
    exports.wasabi_carkeys:GiveKeys(plate)
end)
