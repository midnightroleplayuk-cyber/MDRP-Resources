while Framework == nil do Wait(5) end
Fr.RegisterServerCallback('op-garages:searchResult', function(source, cb, searchTerm)
    local playersList = {}

    if ESX then
        MySQL.Async.fetchAll(
            "SELECT * FROM "..Fr.usersTable.." WHERE " ..
            Fr.identificatorTable.." LIKE @search OR firstname LIKE @search OR lastname LIKE @search LIMIT 15",
            {
                ['@search'] = '%' .. searchTerm .. '%'
            },
            function(results)
                for _, v in pairs(results) do
                    local playerString = {
                        identificator = v[Fr.identificatorTable],
                        id = v[Fr.identificatorTable],
                        name = v.firstname .. " " .. v.lastname,
                    }

                    table.insert(playersList, playerString)
                end

                cb(playersList)
            end
        )
    elseif QBCore or QBox then
        MySQL.Async.fetchAll(
            "SELECT * FROM "..Fr.usersTable.." WHERE " ..
            Fr.identificatorTable.." LIKE @search OR charinfo LIKE @search LIMIT 15",
            {
                ['@search'] = '%' .. searchTerm .. '%'
            },
            function(results)
                for _, v in pairs(results) do
                    v.charinfo = json.decode(v.charinfo)
                    local playerString = {
                        identificator = v[Fr.identificatorTable],
                        id = v[Fr.identificatorTable],
                        name = v.charinfo.firstname .. " " .. v.charinfo.lastname,
                    }

                    table.insert(playersList, playerString)
                end

                cb(playersList)
            end
        )
    end
end)