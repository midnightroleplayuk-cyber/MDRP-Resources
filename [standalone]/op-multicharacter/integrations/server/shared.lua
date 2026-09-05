RegisterNetEvent('op-multicharacter:saveSkin', function(skin)
    local src = source

    if not skin then
        return debugPrint(('[ERROR] Failed to save player skin — no skin data provided (src: %s)'):format(src))
    end

    if ESX then
        local xPlayer = Fr.getPlayerFromId(src)
        if not xPlayer then
            return debugPrint(('[ERROR] Failed to fetch ESX player (src: %s)'):format(src))
        end

        local affectedRows = MySQL.query.await(
            'UPDATE users SET skin = ? WHERE identifier = ?',
            { json.encode(skin), xPlayer.identifier }
        )

        local updated = tonumber(affectedRows?.affectedRows or affectedRows)

        if not updated or updated < 1 then
            return debugPrint(('[ERROR] Database update returned 0 rows — probably no matching identifier (src: %s, identifier: %s)')
                :format(src, xPlayer.identifier))
        end

        debugPrint(('[AppearanceSave] Skin saved successfully for ESX player (src: %s, identifier: %s)')
            :format(src, xPlayer.identifier))
    elseif QBCore or QBox then
        local Player = Fr.getPlayerFromId(src)
        if not Player or not Player.PlayerData then
            return debugPrint(('[ERROR] Failed to fetch QB/QBox player data (src: %s)'):format(src))
        end

        local cid = Player.PlayerData.citizenid

        MySQL.query('DELETE FROM playerskins WHERE citizenid = ?', { cid }, function()
            MySQL.insert(
                'INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)',
                { cid, skin.model, json.encode(skin), 1 },
                function(insertId)
                    if insertId then
                        debugPrint(('[AppearanceSave] Skin saved successfully (QBCore/QBox) (src: %s, cid: %s)')
                            :format(src, cid))
                    else
                        debugPrint(('[ERROR] Insert failed — DB returned nil insertId (src: %s, cid: %s)')
                            :format(src, cid))
                    end
                end
            )
        end)

    else
        debugPrint(('[AppearanceSave] Unsupported framework — ESX/QBCore/QBox not detected (src: %s)'):format(src))
    end
end)