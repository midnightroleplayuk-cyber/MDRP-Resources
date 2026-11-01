if lib.context == "client" then return end -- this is server side only
Config = Config or {}
Config.MaxStorage = 100 -- Every device can store up to 100 files (folders, images, documents...)
local customStorage = {
    -- index key can be a player framework identifier or a laptop serial
    ['SLI31388'] = 250,
}

function getStorage(serial,owner)
    local storage = customStorage and (customStorage[serial] or customStorage[owner]) or Config.MaxStorage
    dbug("getStorage(serial,owner,storage)", serial, owner, storage)
    return storage or 100
end