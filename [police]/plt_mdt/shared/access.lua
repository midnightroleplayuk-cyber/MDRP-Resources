local MDT_ACCESS_NONE = "none"
local MDT_ACCESS_READ = "read"
local MDT_ACCESS_WRITE = "write"

local MDT_DEFAULT_CATEGORIES = {
    "dashboard",
    "citizens",
    "vehicles",
    "incidents",
    "warrants",
    "charges",
    "dispatch",
    "officers"
}

local function NormalizeMdtAccessLevel(value)
    if value == true then return MDT_ACCESS_WRITE end
    if value == false or value == nil then return MDT_ACCESS_NONE end

    local level = string.lower(tostring(value))
    if level == "rw" or level == "readwrite" or level == "read_write" or level == "read-and-write" then
        return MDT_ACCESS_WRITE
    end
    if level == "r" or level == "readonly" or level == "read_only" or level == "read-only" then
        return MDT_ACCESS_READ
    end
    if level == MDT_ACCESS_WRITE or level == MDT_ACCESS_READ or level == MDT_ACCESS_NONE then
        return level
    end

    return MDT_ACCESS_NONE
end

local function AccessRank(level)
    level = NormalizeMdtAccessLevel(level)
    if level == MDT_ACCESS_WRITE then return 2 end
    if level == MDT_ACCESS_READ then return 1 end
    return 0
end

local function GetJobGradeLevel(job)
    if not job or not job.grade then return 0 end
    if type(job.grade) == "table" then
        return tonumber(job.grade.level or job.grade.grade or job.grade.name) or 0
    end
    return tonumber(job.grade) or 0
end

local function GetMdtCategories()
    local configured = Config and Config.MDTAccess and Config.MDTAccess.categories
    if type(configured) == "table" and #configured > 0 then return configured end
    return MDT_DEFAULT_CATEGORIES
end

local function ResolveAccessRule(rule, gradeLevel)
    if type(rule) == "table" then
        local minGrade = tonumber(rule.minGrade)
        if minGrade and (tonumber(gradeLevel) or 0) < minGrade then
            return MDT_ACCESS_NONE
        end
        rule = rule.access or rule.level or rule.permission or rule.mode
    end

    return NormalizeMdtAccessLevel(rule)
end

local function GetRawJobAccessRule(jobName)
    local accessConfig = Config.MDTAccess or {}
    local byJobRule = accessConfig.byJob and accessConfig.byJob[jobName]
    if byJobRule ~= nil then return byJobRule end

    local departmentRule = Config.Departments[jobName] and Config.Departments[jobName].mdtAccess
    if departmentRule ~= nil then return departmentRule end

    return accessConfig.default or MDT_ACCESS_NONE
end

function GetMdtAccessForJob(jobName, gradeLevel, category)
    if not jobName or not Config or not Config.Departments or not Config.Departments[jobName] then
        return MDT_ACCESS_NONE
    end

    local accessConfig = Config.MDTAccess or {}
    if accessConfig.enabled == false then
        return MDT_ACCESS_WRITE
    end

    local rule = GetRawJobAccessRule(jobName)

    if type(rule) == "table" then
        if category then
            local categoryRule = rule[category]
            if categoryRule == nil then categoryRule = rule.all or accessConfig.default end
            return ResolveAccessRule(categoryRule, gradeLevel)
        end

        local best = MDT_ACCESS_NONE
        for _, cat in ipairs(GetMdtCategories()) do
            local level = GetMdtAccessForJob(jobName, gradeLevel, cat)
            if AccessRank(level) > AccessRank(best) then best = level end
        end
        return best
    end

    return ResolveAccessRule(rule, gradeLevel)
end

function GetMdtAccessMapForJob(jobName, gradeLevel)
    local accessMap = {}
    for _, category in ipairs(GetMdtCategories()) do
        accessMap[category] = GetMdtAccessForJob(jobName, gradeLevel, category)
    end
    return accessMap
end

function CanReadMdtJob(jobName, gradeLevel, category)
    local access = GetMdtAccessForJob(jobName, gradeLevel, category)
    return access == MDT_ACCESS_READ or access == MDT_ACCESS_WRITE
end

function CanWriteMdtJob(jobName, gradeLevel, category)
    return GetMdtAccessForJob(jobName, gradeLevel, category) == MDT_ACCESS_WRITE
end

function HasAnyMdtAccessJob(jobName, gradeLevel)
    for _, category in ipairs(GetMdtCategories()) do
        if CanReadMdtJob(jobName, gradeLevel, category) then return true end
    end
    return false
end

if IsDuplicityVersion() then
    local function GetPlayerJobAndGrade(source)
        local Player = Framework.GetPlayer(source)
        if not Player or not Player.job then return nil, 0 end
        return Player.job.name, GetJobGradeLevel(Player.job)
    end

    function GetMdtAccessForSource(source, category)
        local jobName, gradeLevel = GetPlayerJobAndGrade(source)
        return GetMdtAccessForJob(jobName, gradeLevel, category)
    end

    function GetMdtAccessMapForSource(source)
        local jobName, gradeLevel = GetPlayerJobAndGrade(source)
        return GetMdtAccessMapForJob(jobName, gradeLevel)
    end

    function CanReadMdt(source, category)
        local access = GetMdtAccessForSource(source, category)
        return access == MDT_ACCESS_READ or access == MDT_ACCESS_WRITE
    end

    function CanWriteMdt(source, category)
        return GetMdtAccessForSource(source, category) == MDT_ACCESS_WRITE
    end

    function HasAnyMdtAccess(source)
        local jobName, gradeLevel = GetPlayerJobAndGrade(source)
        return HasAnyMdtAccessJob(jobName, gradeLevel)
    end
else
    local function GetPlayerDataJobAndGrade(PlayerData)
        if not PlayerData or not PlayerData.job then return nil, 0 end
        return PlayerData.job.name, GetJobGradeLevel(PlayerData.job)
    end

    function GetMdtAccessForPlayerData(PlayerData, category)
        local jobName, gradeLevel = GetPlayerDataJobAndGrade(PlayerData)
        return GetMdtAccessForJob(jobName, gradeLevel, category)
    end

    function GetMdtAccessMapForPlayerData(PlayerData)
        local jobName, gradeLevel = GetPlayerDataJobAndGrade(PlayerData)
        return GetMdtAccessMapForJob(jobName, gradeLevel)
    end

    function CanReadMdtPlayerData(PlayerData, category)
        local access = GetMdtAccessForPlayerData(PlayerData, category)
        return access == MDT_ACCESS_READ or access == MDT_ACCESS_WRITE
    end

    function CanWriteMdtPlayerData(PlayerData, category)
        return GetMdtAccessForPlayerData(PlayerData, category) == MDT_ACCESS_WRITE
    end

    function HasAnyMdtAccessPlayerData(PlayerData)
        local jobName, gradeLevel = GetPlayerDataJobAndGrade(PlayerData)
        return HasAnyMdtAccessJob(jobName, gradeLevel)
    end
end
