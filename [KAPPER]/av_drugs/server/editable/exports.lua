-- Get Player Strain
exports('getStrain', function(source)
    if not source then
        dbug("export getStrain received null instead of source") 
        return false
    end
    local identifier = exports['av_laptop']:getIdentifier(source)
    if not identifier then
        dbug("getStrain() identifier not found? source:", source) 
        return false
    end
    allPlayers = allPlayers or {}
    if allPlayers and allPlayers[identifier] then
        return allPlayers[identifier] and allPlayers[identifier]['strain'] or false
    end
    dbug("getStrain() player doesn't have any strain.")
    return false
end)

-- Get Player Drugs
exports('getDrug', function(source,name)
    if not source then
        dbug("export getDrug received null instead of source.")
        return false
    end
    if Config.Drugs and not Config.Drugs[name] then
        print("^3[WARNING] ^7Drug ^1", name, "^7doesn't exist in Config.Drugs, please register it first.")
        return false
    end
    local identifier = exports['av_laptop']:getIdentifier(source)
    if not identifier then
        dbug("getDrug() identifier not found? source:", source) 
        return false
    end
    allPlayers = allPlayers or {}
    if allPlayers and allPlayers[identifier] then
        if not name then
            return allPlayers[identifier]['drugs'] or false
        else
            return allPlayers[identifier]['drugs'] and allPlayers[identifier]['drugs'][name] or false
        end
    end
    dbug("getDrug() drug not found or player doesn't have any, drug:", name)
    return false
end)

-- Add drug and strain rep to a specific zone
exports("addZoneRep", function(zone,strain,drug,bags)
    if not zone or not strain or not drug or not bags then
        dbug("export addZoneRep is missing a param (zone,strain,drug,bags)", zone,strain,drug,bags)
        return false
    end
    if Config.Drugs and not Config.Drugs[drug] then
        print("^3[WARNING] ^7Drug ^1", drug, "^7doesn't exist in Config.Drugs, please register it first.")
        return false
    end
    allZones = allZones or {}
    allZones[zone] = allZones[zone] or {}
    allZones[zone][strain] = allZones[zone][strain] or {}
    allZones[zone][strain][drug] = allZones[zone][strain][drug] or 0
    allZones[zone][strain][drug] += bags
    save("zones")
    return true
end)

-- Add drug XP to player
exports('addXP', function(source,drug,xp)
    if not source or not drug or not xp then
        dbug("export addXP is missing a param (source,drug,xp)", source,drug,xp)
        return false
    end
    if Config.Drugs and not Config.Drugs[drug] then
        print("^3[WARNING] ^7Drug ^1", drug, "^7doesn't exist in Config.Drugs, please register it first.")
        return false
    end
    local identifier = exports['av_laptop']:getIdentifier(source)
    if not identifier then
        dbug("addXP() identifier not found? source:", source) 
        return false
    end
    allPlayers = allPlayers or {}
    allPlayers[identifier] = allPlayers[identifier] or {}
    allPlayers[identifier]['drugs'] = allPlayers[identifier]['drugs'] or {}
    allPlayers[identifier]['drugs'][drug] = allPlayers[identifier]['drugs'][drug] or {
        sold = 0,
        name = Config.Drugs[drug] and Config.Drugs[drug]['name'] or "",
        xp = 0,
        label = Config.Drugs[drug] and Config.Drugs[drug]['label'] or "",
        income = 0
    }
    allPlayers[identifier]['drugs'][drug]['xp'] += xp
    save("players")
    return true
end)

-- remove drug XP from player
exports('removeXP', function(source,drug,xp)
    if not source or not drug or not xp then
        dbug("export addXP is missing a param (source,drug,xp)", source,drug,xp)
        return false
    end
    if Config.Drugs and not Config.Drugs[drug] then
        print("^3[WARNING] ^7Drug ^1", drug, "^7doesn't exist in Config.Drugs, please register it first.")
        return false
    end
    local identifier = exports['av_laptop']:getIdentifier(source)
    if not identifier then
        dbug("addXP() identifier not found? source:", source) 
        return false
    end
    allPlayers = allPlayers or {}
    if allPlayers[identifier] and allPlayers[identifier]['drugs'] then
        if allPlayers[identifier]['drugs'][drug] and tonumber(xp) then
            allPlayers[identifier]['drugs'][drug] -= xp
            save("players")
        end
    end
    dbug("addXP() player doesn't have any drug with this name")
    return false
end)