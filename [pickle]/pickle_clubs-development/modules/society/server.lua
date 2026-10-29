-- Society entity: server-side registration and employee management

local function GetPrimaryJobName(club)
    local jobs = club and club.jobs or {}
    for i = 1, #jobs do
        if jobs[i].primary and type(jobs[i].name) == "string" and jobs[i].name ~= "" then
            return jobs[i].name
        end
    end
    return nil
end

-- Authoritative management gate: admin OR boss-grade of the club's primary owning job.
-- Defers to CanManageClub (defined in modules/main/server.lua) which checks
-- IsPlayerAdmin OR IsPlayerJobBoss(source, primaryJob).
local function PlayerCanManage(source, clubId)
    if type(CanManageClub) ~= "function" then return false end
    return CanManageClub(source, clubId) == true
end

-- Get employees for a club's primary job
lib.callback.register("pickle_clubs:getEmployees", function(source, clubId)
    if not PlayerCanManage(source, clubId) then return {} end
    local club = Clubs[clubId]
    local jobName = GetPrimaryJobName(club)
    if not jobName or not GetEmployees then return {} end
    local employees = GetEmployees(jobName) or {}
    for _, emp in ipairs(employees) do
        if tonumber(emp.source) == tonumber(source) then
            emp.isSelf = true
        end
    end
    return employees
end)

-- Get job grades for a club's primary job
lib.callback.register("pickle_clubs:getJobGrades", function(source, clubId)
    if not PlayerCanManage(source, clubId) then return {} end
    local club = Clubs[clubId]
    local jobName = GetPrimaryJobName(club)
    if not jobName or not GetJobGrades then return {} end
    return GetJobGrades(jobName)
end)

-- Set employee grade
lib.callback.register("pickle_clubs:setEmployeeGrade", function(source, clubId, targetSource, grade)
    if not PlayerCanManage(source, clubId) then return false, "No access" end
    local club = Clubs[clubId]
    local jobName = GetPrimaryJobName(club)
    if not jobName or not SetPlayerJob then return false, "No job configured" end
    targetSource = tonumber(targetSource)
    grade = tonumber(grade)
    if not targetSource or not ClubFinite(grade,0,100) or grade%1~=0 then return false,'Invalid parameters' end
    if GetPlayerJobName(targetSource)~=jobName then return false,'Not an employee' end
    local valid=false
    for _,g in pairs(GetJobGrades(jobName) or {}) do if tonumber(g.grade or g.level)==grade then valid=true end end
    if not valid or (IsPlayerJobBoss and IsPlayerJobBoss(targetSource,jobName)) then return false,'Invalid rank' end
    if targetSource == source then return false, "You can't change your own rank" end
    SetPlayerJob(targetSource, jobName, grade)
    return true
end)

-- Fire employee (set to unemployed)
lib.callback.register("pickle_clubs:fireEmployee", function(source, clubId, targetSource)
    if not PlayerCanManage(source, clubId) then return false, "No access" end
    if not SetPlayerJob then return false, "Not supported" end
    targetSource = tonumber(targetSource)
    if not targetSource then return false, "Invalid target" end
    if targetSource == source then return false, "You can't fire yourself" end
    local jobName=GetPrimaryJobName(Clubs[clubId])
    if GetPlayerJobName(targetSource)~=jobName or (IsPlayerJobBoss and IsPlayerJobBoss(targetSource,jobName)) then return false,'Not an eligible employee' end
    SetPlayerJob(targetSource, "unemployed", 0)
    ShowNotification(targetSource, "You have been fired")
    return true
end)

-- Hire nearby player
lib.callback.register("pickle_clubs:hirePlayer", function(source, clubId, targetSource)
    if not PlayerCanManage(source, clubId) then return false, "No access" end
    local club = Clubs[clubId]
    local jobName = GetPrimaryJobName(club)
    if not jobName or not SetPlayerJob then return false, "No job configured" end
    targetSource = tonumber(targetSource)
    if not targetSource then return false, "Invalid target" end
    if not ClubNearby(source,targetSource,5) then return false,"Player must be nearby" end
    SetPlayerJob(targetSource, jobName, 0)
    local name = GetPlayerCharacterName and GetPlayerCharacterName(targetSource) or ("Player " .. targetSource)
    ShowNotification(targetSource, "You have been hired!")
    return true, name
end)

-- Get/set entry settings for a club
lib.callback.register("pickle_clubs:getEntrySettings", function(source, clubId)
    if not PlayerCanManage(source, clubId) then return nil end
    local club = Clubs[clubId]
    if not club then return nil end
    return club.entry_settings or {}
end)

lib.callback.register("pickle_clubs:setEntrySettings", function(source, clubId, settings)
    if not PlayerCanManage(source, clubId) then return false end
    local club = Clubs[clubId]
    if not club then return false end
    if UpdateClub then
        UpdateClub(clubId, { entry_settings = settings }, function() end)
    end
    return true
end)

-- Get nearby players with character names
lib.callback.register("pickle_clubs:getNearbyPlayers", function(source)
    local srcPed = GetPlayerPed(source)
    if not srcPed then return {} end
    local srcCoords = GetEntityCoords(srcPed)
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if pid ~= source then
            local targetPed = GetPlayerPed(pid)
            if targetPed then
                local targetCoords = GetEntityCoords(targetPed)
                if #(srcCoords - targetCoords) < 10.0 then
                    local name = GetPlayerCharacterName and GetPlayerCharacterName(pid) or GetPlayerName(pid)
                    players[#players + 1] = {
                        source = pid,
                        name = name or ("Player " .. pid),
                    }
                end
            end
        end
    end
    return players
end)

CreateThread(function()
    RegisterEntityType("society", {
        label = "Society",
        description = "Society deposit/withdraw interaction point.",
        onStart = function(id, entityId) end,
        onRender = function(id, entityId, source) end,
        onUnrender = function(id, entityId, source) end,
        onStop = function(id, entityId) end,
    })
end)
