if lib.context == "client" then return end -- this is server side only
Config = Config or {}
local customStorage = {
    -- index key can be a player framework identifier or a PC identifier
    ['SLI31388'] = 250,
}

function getStorage(serial,owner)
    local storage = customStorage and (customStorage[serial] or customStorage[owner]) or Config.MaxStorage
    dbug("getStorage(serial,owner,storage)", serial, owner, storage)
    return storage or 100
end