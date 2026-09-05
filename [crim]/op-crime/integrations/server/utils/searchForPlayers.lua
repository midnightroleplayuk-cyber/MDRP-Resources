-- ──────────────────────────────────────────────────────────────────────────────
-- Search Player Result Callback
-- (Information) ► Handles player search in admin tablet / organisation panels.
-- (Information) ► Searches database by identifier, firstname/lastname (ESX),
--                 or charinfo JSON (QB/QBOX). Returns up to 15 results.
-- (Information) ► Full-name search (with/without space) works for CJK names.
-- ──────────────────────────────────────────────────────────────────────────────

while Framework == nil do Wait(5) end

local function buildPlayerResult(identificator, firstname, lastname)
    firstname = firstname and tostring(firstname) or ""
    lastname = lastname and tostring(lastname) or ""
    local fullName = (firstname .. " " .. lastname):gsub("^%s+", ""):gsub("%s+$", "")
    if fullName == "" then
        fullName = identificator or "Unknown"
    end

    return {
        identificator = identificator,
        name = fullName,
        steamName = "",
    }
end

local function normalizeSearchTerm(searchTerm)
    if type(searchTerm) ~= "string" then
        searchTerm = tostring(searchTerm or "")
    end

    searchTerm = searchTerm:match("^%s*(.-)%s*$") or ""
    return searchTerm
end

Fr.RegisterServerCallback('op-crime:searchResult', function(source, cb, searchTerm)
    local playersList = {}
    searchTerm = normalizeSearchTerm(searchTerm)

    if searchTerm == "" then
        return cb(playersList)
    end

    local likeTerm = '%' .. searchTerm .. '%'
    -- Chinese / Asian players often type "姓名" without a space.
    local noSpaceTerm = searchTerm:gsub("%s+", "")
    local likeNoSpace = '%' .. noSpaceTerm .. '%'

    if ESX then
        MySQL.Async.fetchAll([[
            SELECT identifier, firstname, lastname
            FROM ]] .. Fr.usersTable .. [[
            WHERE ]] .. Fr.identificatorTable .. [[ LIKE @search
               OR firstname LIKE @search
               OR lastname LIKE @search
               OR CONCAT(IFNULL(firstname, ''), ' ', IFNULL(lastname, '')) LIKE @search
               OR CONCAT(IFNULL(firstname, ''), IFNULL(lastname, '')) LIKE @searchNoSpace
            LIMIT 15
        ]], {
            ['@search'] = likeTerm,
            ['@searchNoSpace'] = likeNoSpace,
        }, function(results)
            for _, v in pairs(results or {}) do
                playersList[#playersList + 1] = buildPlayerResult(
                    v[Fr.identificatorTable] or v.identifier,
                    v.firstname,
                    v.lastname
                )
            end

            cb(playersList)
        end)

    elseif QBCore or QBox then
        MySQL.Async.fetchAll([[
            SELECT *
            FROM ]] .. Fr.usersTable .. [[
            WHERE ]] .. Fr.identificatorTable .. [[ LIKE @search
               OR charinfo LIKE @search
            LIMIT 15
        ]], {
            ['@search'] = likeTerm,
        }, function(results)
            for _, v in pairs(results or {}) do
                local charinfo = v.charinfo
                if type(charinfo) == "string" then
                    local ok, decoded = pcall(json.decode, charinfo)
                    if ok then
                        charinfo = decoded
                    else
                        charinfo = {}
                    end
                end

                charinfo = charinfo or {}
                playersList[#playersList + 1] = buildPlayerResult(
                    v[Fr.identificatorTable],
                    charinfo.firstname,
                    charinfo.lastname
                )
            end

            cb(playersList)
        end)
    else
        cb(playersList)
    end
end)
