--[[ ONE REGISTRY FOR THE CONFIGURABLE COMMANDS (2.2.10).

     These six used to exist on the SERVER only, and a server-side command
     shares its name with every other resource on the server. ESX Legacy
     ships its own /noclip, so on any current ESX server two resources
     registered the same command and which one answered was decided by load
     order: the framework's noclip (which knows nothing about Apex staff
     groups) could run instead of this one, and `apexdoctor` reported the
     framework itself as "another admin menu" to be stopped. qb-adminmenu's
     /kick and /ban are the same story on QBCore.

     The menu commands never had this problem, because they are registered on
     the CLIENT and the client resolves its own commands before forwarding
     anything to the server. These six now do the same: client/main.lua
     registers each ENABLED one and forwards it here, to the very handler the
     server-side command runs. The permission checks stay where they were,
     inside each handler, on the server.

     The server-side registration is kept: it is what the console and other
     resources' ExecuteCommand reach. ]]
local SERVER_COMMANDS = {}

local function serverCommand(key, handler)
    local def = Config.Commands[key]
    SERVER_COMMANDS[key] = handler
    RegisterCommand(def.command, handler)
end

-- A player may only repeat a forwarded command this often (ms). The handlers
-- write to Discord and the database, and a net event can be fired in a loop.
local FORWARD_MIN_MS = 250
local lastForward = {}

RegisterNetEvent('apex_adminmenu:command', function(key, args)
    local src = source
    if type(key) ~= 'string' then return end
    local handler = SERVER_COMMANDS[key]          -- only what is ENABLED is in here
    if not handler then return end

    local now = GetGameTimer()
    if lastForward[src] and (now - lastForward[src]) < FORWARD_MIN_MS then return end
    lastForward[src] = now

    -- Exactly what a typed command would have delivered: a short list of
    -- words. Anything else a client sends is dropped, not passed along.
    local clean = {}
    if type(args) == 'table' then
        for i = 1, math.min(#args, 16) do
            local a = args[i]
            if type(a) == 'string' or type(a) == 'number' then
                clean[#clean + 1] = tostring(a):sub(1, 200)
            end
        end
    end
    handler(src, clean, table.concat(clean, ' '))
end)

AddEventHandler('playerDropped', function()
    lastForward[source] = nil
end)

if Config.Commands.Ban.enabled then
    serverCommand('Ban', function(source, args)
        local target, reason = tonumber(args[1]), (args[2] or Strings.ban_reason_replace)
        local player = GetPlayer(target)
        if not HasActionPermission(source, 'banPlayers') then return end
        if player then
            BanPlayer(target, 'perm', reason, source) 
            
            -- Log ban command
            SendDiscordLog(
                "Admin Command: Ban",
                "Admin banned a player using command",
                {
                    {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true},
                    {name = "Reason", value = reason, inline = false},
                    {name = "Duration", value = "Permanent", inline = true}
                },
                "playerActions",
                15158332  -- Red color
            )
        else
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.Kick.enabled then
    serverCommand('Kick', function(source, args)
        local target, reason = tonumber(args[1]), (args[2] or Strings.ban_reason_replace)
        local player = GetPlayer(target)
        if not HasActionPermission(source, 'kickPlayers') then return end
        if player then
            DropPlayer(target, reason)
            
            -- Log kick command
            SendDiscordLog(
                "Admin Command: Kick",
                "Admin kicked a player using command",
                {
                    {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true},
                    {name = "Reason", value = reason, inline = false}
                },
                "playerActions",
                15158332  -- Red color
            )
        else
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.NoClip.enabled then
    serverCommand('NoClip', function(source)
        if not AdminPerms(source) then return end
        TriggerClientEvent('apex_adminmenu:noclip', source)
        
        -- Log noclip command
        SendDiscordLog(
            "Admin Command: NoClip",
            "Admin toggled noclip using command",
            {},
            "playerActions"
        )
    end)
end

if Config.Commands.SearchInv.enabled then
    serverCommand('SearchInv', function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(target)
        if not HasActionPermission(source, 'giveItems') then return end
        if player then
            -- Force-open on the server: every modern inventory only exposes
            -- the API there (see configs/compat.lua).
            Apex.Compat.ForceOpenInventory(source, target)

            -- Log search inventory command
            SendDiscordLog(
                "Admin Command: Search Inventory",
                "Admin searched a player's inventory using command",
                {
                    {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
                },
                "moneyActions"
            )
        else
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.ClearInv.enabled then
    serverCommand('ClearInv', function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(target)
        if not HasActionPermission(source, 'giveItems') then return end
        if player then
            -- Clear inventory logic
            local identifier
            if Framework == 'esx' and ESX then
                local xTarget = ESX.GetPlayerFromId(target)
                if xTarget then
                    identifier = xTarget.identifier
                    xTarget.setAccountMoney('money', 0)
                    xTarget.setAccountMoney('black_money', 0)
                    for i = 1, #(xTarget.inventory or {}) do
                        if xTarget.inventory[i].count > 0 then
                            xTarget.removeInventoryItem(xTarget.inventory[i].name, xTarget.inventory[i].count)
                        end
                    end
                end
            elseif Framework == 'qb' then
                -- QBCore and QBox both report as 'qb'; QBox player objects
                -- may not carry ClearInventory, hence the guard.
                if player.Functions and player.Functions.ClearInventory then
                    pcall(function() player.Functions.ClearInventory() end)
                end
                if player.PlayerData and player.PlayerData.citizenid then
                    MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), player.PlayerData.citizenid })
                end
            end

            -- Standalone inventory provider, auto-detected.
            Apex.Compat.ClearInventory(target, identifier)

            -- Log clear inventory command
            SendDiscordLog(
                "Admin Command: Clear Inventory",
                "Admin cleared a player's inventory using command",
                {
                    {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
                },
                "moneyActions"
            )
            
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_clearedinv, Strings.notify_clearedinv_desc:format(GetPlayerName(target)), 'success', 'fa-check')
        else
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.SkinMenu.enabled then
    serverCommand('SkinMenu', function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(target)
        if not AdminPerms(source) then return end
        if player then
            TriggerClientEvent('apex_adminmenu:skinmenu', target)
            
            -- Log skin menu command
            SendDiscordLog(
                "Admin Command: Skin Menu",
                "Admin opened skin menu for a player using command",
                {
                    {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
                },
                "playerActions"
            )
        else
            TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end
