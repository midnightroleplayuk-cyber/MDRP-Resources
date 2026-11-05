local placed = {}
local lastAction = {}
local function tell(src,msg,kind)
    TriggerClientEvent('ox_lib:notify',src,{title='HF1 TV',description=msg,type=kind or 'error'})
end
local function owner(src)
    for _,id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1,8)=='license:' then return id end
    end
end
local function nearby(src,p,maxDist)
    local ped=GetPlayerPed(src)
    return ped~=0 and #(GetEntityCoords(ped)-vector3(p.x,p.y,p.z))<=maxDist
end
local function throttle(src)
    local now=os.time()
    if lastAction[src] and now-lastAction[src]<2 then return false end
    lastAction[src]=now
    return true
end
local function validPlacement(src,data)
    if type(data)~='table' or type(data.model)~='string' or not Config.PlaceableModels[data.model] then return false end
    local p=data.coords
    if type(p)~='table' or type(p.x)~='number' or type(p.y)~='number' or type(p.z)~='number' then return false end
    if p.x~=p.x or p.y~=p.y or p.z~=p.z or math.abs(p.x)>10000 or math.abs(p.y)>10000 or math.abs(p.z)>2000 then return false end
    if type(data.heading)~='number' or data.heading~=data.heading or math.abs(data.heading)>3600 then return false end
    if not nearby(src,p,Config.PlacementMaxDistance+2.0) then return false end
    for _,tv in pairs(placed) do
        local q=tv.coords
        if #(vector3(p.x,p.y,p.z)-vector3(q.x,q.y,q.z))<Config.PlacementMinSpacing then return false end
    end
    return true
end
local function broadcast()
    TriggerClientEvent('hf1_tv:placedSnapshot',-1,placed)
end
MySQL.ready(function()
    local rows=MySQL.query.await('SELECT id, owner, model, x, y, z, heading FROM hf1_tv_placed',{})
    for _,r in ipairs(rows or {}) do
        if Config.PlaceableModels[r.model] then
            placed[tonumber(r.id)]={id=tonumber(r.id),owner=r.owner,model=r.model,coords={x=r.x+0.0,y=r.y+0.0,z=r.z+0.0},heading=r.heading+0.0}
        end
    end
    print(('[hf1_tv] Loaded %d placed TVs (all start switched off)'):format(#(rows or {})))
end)
RegisterNetEvent('hf1_tv:placedRequest',function()
    TriggerClientEvent('hf1_tv:placedSnapshot',source,placed)
end)
RegisterNetEvent('hf1_tv:place',function(data)
    local src=source
    if not throttle(src) or not validPlacement(src,data) then tell(src,'Invalid TV position or another TV is too close') return end
    local idOwner=owner(src)
    if not idOwner then tell(src,'Could not verify your player license') return end
    if exports.ox_inventory:GetItemCount(src,Config.TelevisionItem)<1 then tell(src,'You need a television item') return end
    if not exports.ox_inventory:RemoveItem(src,Config.TelevisionItem,1) then tell(src,'Could not take the television item') return end
    local p=data.coords
    local ok,id=pcall(function()
        return MySQL.insert.await('INSERT INTO hf1_tv_placed (owner,model,x,y,z,heading) VALUES (?,?,?,?,?,?)', {idOwner,data.model,p.x,p.y,p.z,data.heading})
    end)
    if not ok or not id then
        exports.ox_inventory:AddItem(src,Config.TelevisionItem,1)
        tell(src,'Database save failed; television returned')
        return
    end
    placed[id]={id=id,owner=idOwner,model=data.model,coords=p,heading=data.heading}
    broadcast()
    tell(src,'Television placed and saved','success')
end)
local function removePlaced(src,id,admin)
    id=tonumber(id)
    local tv=id and placed[id]
    if not tv then tell(src,'TV not found') return end
    if not nearby(src,tv.coords,Config.PlacementMaxDistance+3.0) then tell(src,'Move closer to that TV') return end
    if not admin and tv.owner~=owner(src) then tell(src,'Only the person who placed this TV can pick it up') return end
    if not admin and not exports.ox_inventory:CanCarryItem(src,Config.TelevisionItem,1) then tell(src,'Not enough inventory space') return end
    local ok,affected=pcall(function() return MySQL.update.await('DELETE FROM hf1_tv_placed WHERE id=?',{id}) end)
    if not ok or affected~=1 then tell(src,'Database removal failed') return end
    if not admin then
        if not exports.ox_inventory:AddItem(src,Config.TelevisionItem,1) then
            -- Restore DB and leave the object if inventory insertion unexpectedly fails.
            MySQL.insert.await('INSERT INTO hf1_tv_placed (id,owner,model,x,y,z,heading) VALUES (?,?,?,?,?,?,?)', {id,tv.owner,tv.model,tv.coords.x,tv.coords.y,tv.coords.z,tv.heading})
            tell(src,'Could not return item; TV remains placed')
            return
        end
    end
    placed[id]=nil
    TriggerEvent('hf1_tv:placedDeletedInternal',tv)
    TriggerClientEvent('hf1_tv:placedRemoved',-1,id)
    tell(src,admin and 'Admin removed television' or 'Television picked up','success')
end
RegisterNetEvent('hf1_tv:pickup',function(id)
    local src=source
    if not throttle(src) then return end
    removePlaced(src,id,false)
end)
RegisterNetEvent('hf1_tv:adminRemove',function(id)
    local src=source
    if not IsPlayerAceAllowed(src,'group.admin') then tell(src,'Admin permission required') return end
    if not throttle(src) then return end
    removePlaced(src,id,true)
end)
AddEventHandler('playerDropped',function() lastAction[source]=nil end)
