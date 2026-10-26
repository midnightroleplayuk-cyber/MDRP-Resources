-- Shared server adapters. All optional integrations fail closed.
TapeServices = { Refunds={}, LastBackup=0, Templates={}, NextTemplateId=1 }
local S=TapeServices
local function resource() return GetCurrentResourceName() end
local function state(name) return type(GetResourceState)=='function' and GetResourceState(name)=='started' end
function S.job(src,framework)
    local ok,job=pcall(function()
        if framework=='esx' then local player=exports.es_extended:getSharedObject().GetPlayerFromId(src);return player and player.getJob() end
        local player=exports['qb-core']:GetCoreObject().Functions.GetPlayer(src);return player and player.PlayerData.job
    end)
    return ok and job or nil
end
function S.department(src)
    if not Config.Departments.Enabled then return nil,true end
    local job=S.job(src,Config.Departments.Framework)
    local rule=job and Config.Departments.Rules[job.name]
    local grade=job and (type(job.grade)=='table' and job.grade.level or tonumber(job.grade)) or 0
    if not rule or (grade or 0)<rule.MinGrade or (Config.Departments.RequireOnDuty and job.onduty~=true) then return nil,false end
    return rule,true
end
function S.styleAllowed(src,id)
    local style=type(id)=='string' and Config.TapeStyles[id]
    if not style or style.enabled==false then return false end
    local rule,allowed=S.department(src)
    if not allowed then return false end
    return not rule or (rule.Styles and rule.Styles[id]==true) or (rule.Categories and rule.Categories[style.category]==true) or false
end
function S.rules(src)
    local rule,allowed=S.department(src)
    local styles={}
    if allowed then for id,style in pairs(Config.TapeStyles) do if S.styleAllowed(src,id) then styles[id]=style end end end
    local default=rule and rule.DefaultStyle or 'police'
    if not styles[default] then default=next(styles) end
    return {styles=styles,default=default,maxTapes=rule and rule.MaxTapes or Config.MaxPerPlayer}
end
function S.count(src,item)
    if item=='' then return math.huge end
    local ok,count=pcall(function()
        if Config.Inventory.System=='ox' then return exports.ox_inventory:Search(src,'count',item) end
        if Config.Inventory.System=='qb' then local p=exports['qb-core']:GetCoreObject().Functions.GetPlayer(src);local i=p and p.Functions.GetItemByName(item);return i and (i.amount or i.count) or 0 end
        local p=exports.es_extended:getSharedObject().GetPlayerFromId(src);local i=p and p.getInventoryItem(item);return i and i.count or 0
    end)
    return ok and type(count)=='number' and count or 0
end
function S.take(src,item,count,consume)
    if not Config.Inventory.Enabled or item=='' then return true end
    if S.count(src,item)<count then return false end
    if not consume then return true end
    local ok,result=pcall(function()
        if Config.Inventory.System=='ox' then return exports.ox_inventory:RemoveItem(src,item,count) end
        if Config.Inventory.System=='qb' then local p=exports['qb-core']:GetCoreObject().Functions.GetPlayer(src);return p and p.Functions.RemoveItem(item,count) end
        local p=exports.es_extended:getSharedObject().GetPlayerFromId(src);if not p then return false end
        local before=S.count(src,item);p.removeInventoryItem(item,count);return S.count(src,item)==before-count
    end)
    return ok and result==true
end
function S.give(src,item,count)
    local ok,result=pcall(function()
        if Config.Inventory.System=='ox' then return exports.ox_inventory:AddItem(src,item,count) end
        if Config.Inventory.System=='qb' then local p=exports['qb-core']:GetCoreObject().Functions.GetPlayer(src);return p and p.Functions.AddItem(item,count) end
        local p=exports.es_extended:getSharedObject().GetPlayerFromId(src);if not p or (p.canCarryItem and not p.canCarryItem(item,count)) then return false end
        local before=S.count(src,item);p.addInventoryItem(item,count);return S.count(src,item)==before+count
    end)
    return ok and result==true
end
function S.audit(action,src,details)
    if not Config.Audit.Enabled then return end
    local entry={time=os.time(),action=action,source=src or 0,details=details or {}}
    if Config.Audit.IncludeIdentifiers and src and src>0 then entry.identifier=GetPlayerIdentifierByType(src,'license') end
    local encoded=json.encode(entry)
    if Config.Audit.Console then print('[APEX Tape AUDIT] '..encoded) end
    if Config.Audit.File then
        local path='data/audit.jsonl'
        local raw=LoadResourceFile(resource(),path) or ''
        if #raw+#encoded+1>Config.Audit.MaxBytes then
            for i=Config.Audit.Backups,2,-1 do local old=LoadResourceFile(resource(),'data/audit.'..(i-1)..'.jsonl');if old and not SaveResourceFile(resource(),'data/audit.'..i..'.jsonl',old,#old) then print('[APEX Tape] Audit rotation failed.');return end end
            if not SaveResourceFile(resource(),'data/audit.1.jsonl',raw,#raw) then print('[APEX Tape] Audit rotation failed.');return end
            raw=''
        end
        raw=raw..encoded..'\n'
        if not SaveResourceFile(resource(),path,raw,#raw) then print('[APEX Tape] Audit write failed.') end
    end
end
function S.refund(src,item,count)
    if not item or count<1 then return false end
    if S.give(src,item,count) then S.audit('refund',src,{item=item,count=count});return true end
    local id=GetPlayerIdentifierByType(src,'license')
    if id then S.Refunds[id]=S.Refunds[id] or {};S.Refunds[id][item]=(S.Refunds[id][item] or 0)+count end
    S.audit('refund_pending',src,{item=item,count=count})
    return false
end
function S.claim(src)
    if not Config.Inventory.Enabled then return 0 end
    local id=GetPlayerIdentifierByType(src,'license')
    local pending=id and S.Refunds[id]
    local claimed=0
    if pending then
        for item,count in pairs(pending) do if S.give(src,item,count) then claimed=claimed+count;pending[item]=nil;S.audit('refund_claim',src,{item=item,count=count}) end end
        if not next(pending) then S.Refunds[id]=nil end
    end
    return claimed
end
function S.vehicleProfile(vehicle)
    local name
    local model=type(GetEntityModel)=='function' and GetEntityModel(vehicle)
    for modelName,profile in pairs(Config.Breakaway.Models) do
        local hash=type(GetHashKey)=='function' and GetHashKey(modelName) or modelName
        if model==hash then name=profile;break end
    end
    if not name then
        local kind=type(GetVehicleType)=='function' and GetVehicleType(vehicle) or 'automobile'
        name=Config.Breakaway.VehicleTypes[kind] or 'car'
    end
    local profile=Config.Breakaway.Profiles[name] or Config.Breakaway.Profiles.car
    if profile.Enabled==false then return nil end
    return profile
end
function S.validStore(raw)
    if type(raw)~='string' or raw=='' then return false end
    local ok,data=pcall(json.decode,raw)
    if not ok or type(data)~='table' or (data.version~=2 and data.version~=3) or type(data.tapes)~='table' then return false end
    local function number(v) return type(v)=='number' and v==v and v>-math.huge and v<math.huge end
    local function integer(v) return number(v) and v>=0 and v%1==0 end
    local function point(p) return type(p)=='table' and number(p.x) and number(p.y) and number(p.z) and math.abs(p.x)<100000 and math.abs(p.y)<100000 and math.abs(p.z)<100000 end
    local function normal(p)return point(p) and math.abs(p.x*p.x+p.y*p.y+p.z*p.z-1)<.05 end
    local records=0
    for key in pairs(data.tapes) do if type(key)~='number' or key<1 or key%1~=0 then return false end;records=records+1 end
    for i=1,records do if data.tapes[i]==nil then return false end end
    for _,t in pairs(data.tapes) do
        if type(t)~='table' or not integer(t.id) or not integer(t.bucket) or not point(t.a) or not point(t.b)
            or (t.aSurface and not normal(t.aSurface)) or (t.bSurface and not normal(t.bSurface))
            or type(t.coneAId)~='string' or type(t.coneBId)~='string' or type(t.style)~='string' or not number(t.createdAt)
            or (t.expiresAt and not number(t.expiresAt)) or (t.brokenAt and not number(t.brokenAt))
            or (t.restLength and (not number(t.restLength) or t.restLength<=0))
            or (t.breakFraction and (not number(t.breakFraction) or t.breakFraction<0 or t.breakFraction>1)) then return false end
    end
    if data.scenes~=nil and type(data.scenes)~='table' then return false end
    for _,scene in pairs(data.scenes or {}) do
        if type(scene)~='table' or not integer(scene.id) or not integer(scene.bucket) or type(scene.name)~='string' or not number(scene.createdAt) or (scene.expiresAt and not number(scene.expiresAt)) then return false end
        if scene.detour~=nil then
            if type(scene.detour)~='table' or #scene.detour>100 then return false end
            for _,waypoint in pairs(scene.detour) do if not point(waypoint) then return false end end
        end
    end
    if data.refunds~=nil and type(data.refunds)~='table' then return false end
    for id,items in pairs(data.refunds or {}) do
        if type(id)~='string' or type(items)~='table' then return false end
        for item,count in pairs(items) do if type(item)~='string' or not integer(count) then return false end end
    end
    if data.templates~=nil and type(data.templates)~='table' then return false end
    for _,template in pairs(data.templates or {}) do
        if type(template)~='table' or not integer(template.id) or type(template.name)~='string' or type(template.spans)~='table' or #template.spans<1 or #template.spans>1000 then return false end
        for _,span in ipairs(template.spans) do if type(span)~='table' or not point(span.a) or not point(span.b) or type(span.style)~='string' then return false end end
    end
    if data.nextTemplateId~=nil and (not integer(data.nextTemplateId) or data.nextTemplateId<1 or data.nextTemplateId>2147483647) then return false end
    return true
end
function S.readStore()
    local primary=LoadResourceFile(resource(),'data/tapes.json')
    if S.validStore(primary) then return primary end
    if Config.Backups.Enabled and Config.Backups.RecoverAutomatically then
        for i=1,Config.Backups.Count do
            local backup=LoadResourceFile(resource(),'data/tapes.backup'..i..'.json')
            if S.validStore(backup) then
                if primary and primary~='' then
                    local path='data/tapes.corrupt.'..os.time()..'.json'
                    if not SaveResourceFile(resource(),path,primary,#primary) then print('[APEX Tape] Cannot preserve corrupt primary; automatic recovery aborted.');return primary end
                end
                if SaveResourceFile(resource(),'data/tapes.json',backup,#backup) then print('[APEX Tape] Recovered tape storage from backup '..i..'.');S.audit('storage_recovered',0,{backup=i});return backup end
                print('[APEX Tape] Backup is valid but primary is not writable.');return primary
            end
        end
    end
    return primary
end
-- Check the actual file contents, rather than assuming a particular native return type.
function S.writeVerified(path,data)
    local ok,result=pcall(SaveResourceFile,resource(),path,data,#data)
    if not ok then return false,path..': '..tostring(result) end
    if result==false or result==0 then return false,path..': native rejected write' end
    local readOk,stored=pcall(LoadResourceFile,resource(),path)
    if readOk and stored==data then return true end
    return false,path..': write could not be verified (native result '..tostring(result)..')'
end
function S.writeStore(encoded)
    local previous=LoadResourceFile(resource(),'data/tapes.json')
    if Config.Backups.Enabled and S.validStore(previous) and os.time()-S.LastBackup>=Config.Backups.IntervalSeconds then
        for i=Config.Backups.Count,2,-1 do
            local raw=LoadResourceFile(resource(),'data/tapes.backup'..(i-1)..'.json')
            if S.validStore(raw) and not S.writeVerified('data/tapes.backup'..i..'.json',raw) then S.LastStorageError='Backup rotation failed';return false end
        end
        if not S.writeVerified('data/tapes.backup1.json',previous) then S.LastStorageError='data/tapes.backup1.json: backup write could not be verified';return false end
        S.LastBackup=os.time()
    end
    local ok,err=S.writeVerified('data/tapes.json',encoded)
    S.LastStorageError=err
    return ok
end
function S.startup()
    if not TapeSettings.Valid then print('[APEX Tape] Startup blocked by configuration errors.');return false end
    for _,message in ipairs(TapeSettings.Warnings) do print('[APEX Tape] '..message) end
    local probe='data/.write-test'
    if Config.Persistence then
        local ok,reason=S.writeVerified(probe,'APEX '..Config.Version..' '..tostring(os.time()))
        if not ok then print('[APEX Tape] Startup blocked: '..tostring(reason)..'. Check the resource data directory and filesystem access.');return false end
    end
    local systems={}
    if Config.Inventory.Enabled then systems[#systems+1]=({ox='ox_inventory',qb='qb-core',esx='es_extended'})[Config.Inventory.System] end
    if Config.Jobs.Enabled then systems[#systems+1]=({qb='qb-core',esx='es_extended'})[Config.Jobs.Framework] end
    if Config.Departments.Enabled then systems[#systems+1]=({qb='qb-core',esx='es_extended'})[Config.Departments.Framework] end
    if Config.RequiredOxItem~='' then systems[#systems+1]='ox_inventory' end
    for _,name in ipairs(systems) do if not state(name) then print('[APEX Tape] Startup blocked: required integration '..name..' is not started.');return false end end
    if Config.Inventory.Enabled and Config.Inventory.System=='ox' then
        for _,item in ipairs({Config.Inventory.TapeItem,Config.Inventory.CutItem,Config.Inventory.RepairItem}) do
            local ok,exists=pcall(function()return item=='' or exports.ox_inventory:Items(item)end)
            if not ok or not exists then print('[APEX Tape] Startup blocked: ox_inventory item not registered: '..tostring(item));return false end
        end
    end
    local count=0 for _,style in pairs(Config.TapeStyles) do if style.enabled~=false then count=count+1 end end
    print(('[APEX Tape %s] Ready checks passed: %d designs, %s profile, locale %s.'):format(Config.Version,count,Config.PerformanceProfile,Config.Locale))
    return true
end
