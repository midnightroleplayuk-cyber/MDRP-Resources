-- Server authority for framework permissions and custom inventory adapters.
TapeBridge={}
local B,S=TapeBridge,TapeServices
local function started(name) return GetResourceState(name)=='started' end
local function framework(name)
    name=name or Config.Permissions.Framework
    if name=='auto' then
        if started('qb-core') then return 'qb' end
        if started('es_extended') then return 'esx' end
        return 'standalone'
    end
    return name
end
local function hook(name,...)
    local fn=TapeBridgeHooks and TapeBridgeHooks[name]
    if type(fn)~='function' then return nil end
    local ok,value=pcall(fn,...)
    return ok and value or nil
end
local originalJob=S.job
function S.job(src,system)
    system=framework(system)
    if system=='custom' then return hook('Job',src) end
    if system=='standalone' then return nil end
    return originalJob(src,system)
end
function B.isStaff(src)
    if src==0 then return true end
    local p=Config.Permissions
    if IsPlayerAceAllowed(src,Config.AdminAce) or (p.StaffAce~='' and IsPlayerAceAllowed(src,p.StaffAce)) then return true end
    if not p.Enabled then return false end
    local system=framework()
    if system=='custom' then return hook('Staff',src)==true end
    local ok,value=pcall(function()
        if system=='qb' then
            local core=exports['qb-core']:GetCoreObject()
            for _,group in ipairs(p.StaffGroups) do if core.Functions.HasPermission(src,group) then return true end end
        elseif system=='esx' then
            local player=exports.es_extended:getSharedObject().GetPlayerFromId(src)
            local group=player and player.getGroup()
            for _,allowed in ipairs(p.StaffGroups) do if group==allowed then return true end end
        end
        return false
    end)
    return ok and value==true
end
function B.canUse(src)
    local p=Config.Permissions
    if not p.Enabled then return true end
    if p.StaffBypass and B.isStaff(src) then return true end
    if p.Mode=='public' then return true end
    if p.Mode=='staff' then return B.isStaff(src) end
    if p.Mode=='ace' then return p.UseAce~='' and IsPlayerAceAllowed(src,p.UseAce) end
    if p.Mode=='custom' then return hook('CanUse',src)==true end
    local job=S.job(src)
    local min=type(job)=='table' and p.Jobs[job.name]
    local grade=job and (type(job.grade)=='table' and job.grade.level or tonumber(job.grade)) or 0
    local allowed=min~=nil and (tonumber(grade) or 0)>=min and (not p.RequireOnDuty or job.onduty==true)
    return allowed or (p.Mode=='jobs_or_staff' and B.isStaff(src)) or false
end
local originalCount,originalTake,originalGive=S.count,S.take,S.give
function S.count(src,item)
    if item=='' then return math.huge end
    if Config.Inventory.System~='custom' then return originalCount(src,item) end
    local n=hook('CountItem',src,item)
    return type(n)=='number' and n==n and n>=0 and n<math.huge and math.floor(n) or 0
end
function S.take(src,item,count,consume)
    if not Config.Inventory.Enabled or item=='' then return true end
    if Config.Inventory.System~='custom' then return originalTake(src,item,count,consume) end
    if type(count)~='number' or count~=count or count<1 or count>=math.huge or count%1~=0 then return false end
    if S.count(src,item)<(consume and count or 1) then return false end
    return not consume or hook('RemoveItem',src,item,count)==true
end
function S.give(src,item,count)
    if Config.Inventory.System~='custom' then return originalGive(src,item,count) end
    return hook('AddItem',src,item,count)==true
end
local originalStartup=S.startup
function S.startup()
    local system=framework()
    if Config.Permissions.Enabled and ((system=='qb' and not started('qb-core')) or (system=='esx' and not started('es_extended'))) then
        print('[APEX Tape] Startup blocked: selected permission framework is not started.');return false
    end
    local required={}
    for _,gate in ipairs({Config.Jobs,Config.Departments}) do
        if gate.Enabled then
            local selected=framework(gate.Framework)
            if selected=='custom' then required[#required+1]='Job' end
            if (selected=='qb' and not started('qb-core')) or (selected=='esx' and not started('es_extended')) then
                print('[APEX Tape] Startup blocked: job/department framework is not started.');return false
            end
        end
    end
    if Config.Permissions.Enabled then
        local mode=Config.Permissions.Mode
        if mode=='custom' then required[#required+1]='CanUse' end
        if system=='custom' then
            if mode=='jobs' or mode=='jobs_or_staff' then required[#required+1]='Job' end
            if mode=='staff' or mode=='jobs_or_staff' or Config.Permissions.StaffBypass then required[#required+1]='Staff' end
        end
    end
    if Config.Inventory.Enabled and Config.Inventory.System=='custom' then
        for _,name in ipairs({'CountItem','RemoveItem','AddItem'}) do required[#required+1]=name end
    end
    for _,name in ipairs(required) do
        if type(TapeBridgeHooks[name])~='function' then print('[APEX Tape] Startup blocked: implement '..name..' in server/custom.lua.');return false end
    end
    return originalStartup()
end
