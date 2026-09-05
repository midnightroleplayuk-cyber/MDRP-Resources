-- ──────────────────────────────────────────────────────────────────────────────
-- Organisations: Data Exports                                                 
-- (Information) ► These helpers expose organisation data to other resources (QB/QBOX,
--        garage scripts, admin tools, etc.) via exports.
-- ──────────────────────────────────────────────────────────────────────────────

-- ──────────────────────────────────────────────────────────────────────────────
-- getOrganisationsListforQb                                                   
-- (Information) ► Builds a QB/QBOX-compatible gang table from internal organisations.
-- (Information) ► Output format matches qb-core/qbx_core gang structure:
--        {
--          ['gang_x'] = {
--              label  = 'Gang Name',
--              grades = {
--                  [0/1/2...] = { name = 'Rank Label', isBoss = bool },
--              }
--          }
--        }
-- ──────────────────────────────────────────────────────────────────────────────
function getOrganisationsListforQb()
    local list = {}

    for k, v in pairs(organisations) do 
        local gradesList = {}

        for _, rankData in pairs(v.ranks) do 
            local rankIndex = tostring(rankData.rankIndex)

            if QBox then 
                rankIndex = tonumber(rankIndex)
            end

            gradesList[rankIndex] = {
                name  = rankData.label,
                isBoss = rankData.rankIndex == 1 and true or false
            }
        end

        list["gang_" .. v.id] = {
            label  = v.label, 
            grades = gradesList
        }
    end

    return list
end
exports('getOrganisationsListforQb', getOrganisationsListforQb)

-- ──────────────────────────────────────────────────────────────────────────────
-- getPlayerOrganisationForQB                                                  
-- (Information) ► Returns a QB-style gang object for given identifier (license/cid/etc.).
-- (Information) ► Used when external scripts expect qb-core style gang data:
--        {
--          name  = 'gang_x' | 'None',
--          grade = { name = 'Rank', level = int },
--          isboss = bool,
--          label  = 'Gang Label' | 'No Gang'
--        }
-- ──────────────────────────────────────────────────────────────────────────────
function getPlayerOrganisationForQB(identifier)
    local playerObj = playersJobs[identifier]

    if not playerObj then
        return {
            name  = "None",
            grade = {
                name  = "Unaffiliated",
                level = 0
            },
            isboss = false,
            label  = "No Gang"
        }
    end

    local playerOrg = organisations[tostring(playerObj.jobId)]

    if not playerOrg then
        return {
            name  = "None",
            grade = {
                name  = "Unaffiliated",
                level = 0
            },
            isboss = false,
            label  = "No Gang"
        }
    end

    local isBoss     = false
    local gradeLevel = 1

    for k, v in pairs(playerOrg.ranks) do 
        if v.label == playerObj.rank then 
            gradeLevel = v.rankIndex
        end
    end

    return {
        name  = "gang_" .. playerOrg.id,
        grade = {
            name  = playerObj.rank,
            level = gradeLevel
        },
        isboss = true,
        label  = playerOrg.label
    }
end
exports('getPlayerOrganisationForQB', getPlayerOrganisationForQB)

-- ──────────────────────────────────────────────────────────────────────────────
-- getPlayerOrganisation                                                       
-- (Information) ► Returns full internal organisation data for given player identifier.
-- (Information) ► This is meant for scripts that want complete access:
--        - orgIndex  → organisation id
--        - player    → player job/meta inside org
--        - orgData   → full org definition from organisations[]
-- ──────────────────────────────────────────────────────────────────────────────
function getPlayerOrganisation(identifier)
    local playerObj = playersJobs[identifier]

    if not playerObj then return false end

    local playerOrg = organisations[tostring(playerObj.jobId)]
    if not playerOrg then return false end

    return {
        orgIndex = playerOrg.id,
        player = {
            identifier = playerObj.identificator,
            totalTime  = playerObj.totalTime,
            rank       = playerObj.rank,
            status     = playerObj.status
        },
        orgData = playerOrg
    }
end
exports('getPlayerOrganisation', getPlayerOrganisation)

-- ──────────────────────────────────────────────────────────────────────────────
-- getOrganisation                                                             
-- (Information) ► Fetch organisation definition by id.
-- (Information) ► Returns the organisation table or false if not found.
-- ──────────────────────────────────────────────────────────────────────────────
function getOrganisation(id)
    local org = organisations[tostring(id)]
    return org or false
end
exports('getOrganisation', getOrganisation)

-- ──────────────────────────────────────────────────────────────────────────────
-- getOrganisationsList                                                        
-- (Information) ► Returns a lightweight list of organisations:
--        { { identifier = id, label = 'Name' }, ... }
-- (Information) ► Useful for dropdowns, menus and admin panels.
-- ──────────────────────────────────────────────────────────────────────────────
function getOrganisationsList()
    local list = {}

    for k, v in pairs(organisations) do 
        table.insert(list, {
            identifier = v.id,
            label      = v.label
        })
    end

    return list
end
exports('getOrganisationsList', getOrganisationsList)

-- ──────────────────────────────────────────────────────────────────────────────
-- getGaragesToCreate                                                          
-- (Information) ► Returns a list of garage spawn points based on organisation data.
-- (Information) ► Used mainly by external garage resources to auto-generate org garages.
--        Each entry:
--        {
--          coords = vec3(x,y,z),
--          label  = 'Org label',
--          id     = 'orgId'
--        }
-- ──────────────────────────────────────────────────────────────────────────────
function getGaragesToCreate()
    local garages = {}

    for k, v in pairs(organisations) do
        local gx = tonumber(v.dataCoords.garageCoords.x) or 0
        local gy = tonumber(v.dataCoords.garageCoords.y) or 0
        local gz = tonumber(v.dataCoords.garageCoords.z) or 0
        local gw = tonumber(v.dataCoords.garageCoords.w) or 0

        local garageCoords = vec4(gx, gy, gz, gw)

        table.insert(garages, {
            coords = garageCoords,
            label  = v.label,
            id     = tostring(v.id)
        })
    end

    return garages
end
exports('getGaragesToCreate', getGaragesToCreate)

-- ──────────────────────────────────────────────────────────────────────────────
-- Server-side Organisation Events                                             
-- (Information) ► Internal “API” for trusted integrations (other resources or tools).
-- (Information) ► These events are designed to be triggered from server-side only.
-- [SEC]  Calls from players are blocked by source checks below.
-- ──────────────────────────────────────────────────────────────────────────────

RegisterServerEvent('op-crime:addOrganisationEXP')
AddEventHandler('op-crime:addOrganisationEXP', function(orgId, amount)
    -- [SEC] Allow only server-side calls (no player source).
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal money add attempt from player: %s'):format(source))
        return
    end

    addOrgExp(orgId, amount)
end)

RegisterServerEvent('op-crime:removeOrganisationEXP')
AddEventHandler('op-crime:removeOrganisationEXP', function(orgId, amount)
    -- [SEC] Allow only server-side calls (no player source).
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal exp remove attempt from player: %s'):format(source))
        return
    end

    removeOrgExp(orgId, amount)
end)

RegisterServerEvent('op-crime:addOrganisationMoney')
AddEventHandler('op-crime:addOrganisationMoney', function(orgId, amount, account)
    -- account: "balance" / "dirtymoney"
    -- [SEC] Allow only server-side calls.
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal money add attempt from player: %s'):format(source))
        return
    end

    addOrgMoney(account, amount, orgId)
end)

RegisterServerEvent('op-crime:removeOrganisationMoney')
AddEventHandler('op-crime:removeOrganisationMoney', function(orgId, amount, account)
    -- account: "balance" / "dirtymoney"
    -- [SEC] Allow only server-side calls.
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal money add attempt from player: %s'):format(source))
        return
    end

    removeOrgMoney(account, amount, orgId) 
end)

RegisterServerEvent('op-crime:addOrgMissionsDone')
AddEventHandler('op-crime:addOrgMissionsDone', function(orgId, amount)
    -- [SEC] Allow only server-side calls.
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal money add attempt from player: %s'):format(source))
        return
    end

    addOrgDoneMissions(orgId, amount)
end)

RegisterServerEvent('op-crime:addZonesCaptured')
AddEventHandler('op-crime:addZonesCaptured', function(orgId, amount)
    -- [SEC] Allow only server-side calls.
    if source ~= 0 and not source == "" then
        print(('[op-crime] Blocked illegal money add attempt from player: %s'):format(source))
        return
    end

    addOrgZoneCapture(orgId, amount)
end)

-- ──────────────────────────────────────────────────────────────────────────────
-- getOnlinePlayers                                                            
-- (Information) ► Fetch online members.
-- (Information) ► Returns the online players table
-- ──────────────────────────────────────────────────────────────────────────────
function getOnlinePlayers(id)
    local returnObj = {}

    for k, v in pairs(playersJobs) do 
        if v.status == "Online" then
            table.insert(returnObj, {
                jobId = v.jobId,
                id = v.playerServerId
            })
        end
    end

    return returnObj
end
exports('getOnlinePlayers', getOnlinePlayers)

-- ──────────────────────────────────────────────────────────────────────────────
-- Turf Zones Exports                                                          
-- (Information) ► Also available via exports('getTurfZones') / getTurfZone
--        from server/turfZones.lua. Re-exported here for discovery next to
--        other organisation helpers.
-- ──────────────────────────────────────────────────────────────────────────────
-- getTurfZones / getTurfZone / op-crime:turfZoneUpdated are defined in
-- server/turfZones.lua (loaded with server/*.lua).