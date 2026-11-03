-- In this file u can restrict access from specific market products
-- Just in case u need an extra check other than the gang whitelist from admin panel > Market tab
function haveAccess(playerId, product, gang)
    local result = true
    dbug('haveAccess(playerId, product, gang)', playerId, product, gang)

    return result
end