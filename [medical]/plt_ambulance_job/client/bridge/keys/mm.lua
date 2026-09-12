if Bridge.Keys ~= 'mm' then return end

Keys.SetProvider('mm_carkeys', function(plate)
    exports.mm_carkeys:GiveTempKeys(plate)
end)
