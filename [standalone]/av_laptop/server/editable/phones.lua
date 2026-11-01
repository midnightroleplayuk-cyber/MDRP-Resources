function getSerial(source) -- get phone serial number, used to fetch data from gallery table
    if Config.UsingPhone == "qb-phone" then
        return getIdentifier(source) or ""
    elseif Config.UsingPhone == "lb-phone" then
        local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        return phoneNumber or ""
    end
end

function getFiles(serial) -- fetch files from phone_gallery using phone serial
    local column = "identifier"
    if Config.UsingPhone == "qb-phone" then
        column = "citizenid"
    elseif Config.UsingPhone == "lb-phone" then
        return MySQL.query.await('SELECT * FROM phone_photos WHERE phone_number = ?', {
            serial
        })
    end
    return MySQL.query.await('SELECT * FROM `phone_gallery` WHERE `'..column..'` = ?', {
        serial
    })
end

function getFileInfo(name,data)
    local info = {
        id = data['id'] or lib.string.random("..........."),
        name = name,
        identifier = data['identifier'] or data['citizenid'] or data['phone_number'],
        type = data['type'] or (data['is_video'] and "video" or "image"),
        content = data['content'] or data['image'] or data['link'],
        created_at = data['created_at'] or data['date'] or data['timestamp'],
        parent_id = "root",
    }
    return info
end