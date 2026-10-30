local sessions, issued, attempts, lastAction = {}, {}, {}, {}
-- Stock is attached to the live vehicle entity. A freshly spawned garage vehicle
-- starts with a full allocation. Opening/closing the tablet never resets stock.
local vehicleStocks = {}
local function vehicleStock(netId)
  local vehicle = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
  if vehicle == 0 or not DoesEntityExist(vehicle) then return nil end
  local plate = GetVehicleNumberPlateText(vehicle)
  local record = vehicleStocks[netId]
  if not record or record.entity ~= vehicle or record.plate ~= plate then
    record = {entity=vehicle,plate=plate,stock={police={},firearms={}}}
    vehicleStocks[netId] = record
  end
  return record
end
local function available(netId, section, entry)
  local record = vehicleStock(netId)
  if not record then return 0 end
  local remaining = record.stock[section][entry.id]
  if remaining == nil then return math.max(1, math.floor(tonumber(entry.count) or 1)) end
  return remaining
end
local function setAvailable(netId,section,id,value)
  local record = vehicleStock(netId)
  if not record then return false end
  record.stock[section][id]=math.max(0,value)
  return true
end
local function issueKey(citizenid,netId,section,id)
  return citizenid .. ':' .. tostring(netId) .. ':' .. section .. ':' .. id
end
local function contains(t, value)
  for _, v in ipairs(t) do if v == value then return true end end
  return false
end
local function gradeOf(player)
  local job = player and player.PlayerData and player.PlayerData.job
  if not job or job.name ~= Config.Job or (Config.RequireDuty and not job.onduty) then return nil end
  local grade = job.grade
  return tonumber(type(grade) == 'table' and grade.level or grade) or 0
end
local function validVehicle(src, netId, section)
  local ped = GetPlayerPed(src)
  if ped == 0 then return false end
  local vehicle = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
  if vehicle == 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then return false end
  if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > Config.SessionDistance then return false end
  local model = GetEntityModel(vehicle)
  local allowed = false
  for _, name in ipairs(Config.Vehicles) do if model == joaat(name) then allowed = true break end end
  if not allowed then return false end
  if section == 'traffic' or section == 'firearms' then
    local models = section == 'traffic' and Config.TrafficVehicles or Config.FirearmsVehicles
    local found = false
    for _, name in ipairs(models) do if model == joaat(name) then found = true break end end
    if not found then return false end
  end
  return true
end
local function authorized(src, netId, section)
  local player = exports.qbx_core:GetPlayer(src)
  local grade = gradeOf(player)
  return grade ~= nil and grade >= (Config.MinGrade[section] or 0) and validVehicle(src, netId, section), grade
end
local function active(src, netId, section)
  local s = sessions[src]
  return s and s.netId == netId and s.expires > os.time() and authorized(src, netId, section)
end
local function findEntry(list, id)
  for _, entry in ipairs(list) do if entry.id == id then return entry end end
end
local function throttle(src)
  local now = GetGameTimer()
  if lastAction[src] and now - lastAction[src] < Config.ActionCooldownMs then return false end
  lastAction[src] = now
  return true
end
lib.callback.register('hf1_bootscript:open', function(src, netId)
  if not authorized(src, netId, 'clothing') then return {error = 'Not authorized or too far from the vehicle.'} end
  local _, grade = authorized(src, netId, 'clothing')
  sessions[src] = {netId = netId, expires = os.time() + Config.SessionSeconds, unlocked = false}
  local options = {clothing = {}, police = {}, firearms = {}}
  local player = exports.qbx_core:GetPlayer(src)
  local citizenid = player.PlayerData.citizenid
  local issuedState = {police = {}, firearms = {}}
  for _, e in ipairs(Config.Clothing) do if grade >= (e.minGrade or 0) then options.clothing[#options.clothing+1] = {id=e.id,label=e.label,image=e.image} end end
  for _, e in ipairs(Config.PoliceItems) do if grade >= (e.minGrade or 0) then options.police[#options.police+1] = {id=e.id,label=e.label,image=e.image or e.item,count=available(netId,'police',e)} end; local k=issueKey(citizenid,netId,'police',e.id); issuedState.police[e.id] = issued[k] and issued[k].count or 0 end
  if authorized(src, netId, 'firearms') then
    for _, e in ipairs(Config.Firearms) do if grade >= (e.minGrade or 0) then options.firearms[#options.firearms+1] = {id=e.id,label=e.label,image=e.image or e.item,count=available(netId,'firearms',e)} end; local k=issueKey(citizenid,netId,'firearms',e.id); issuedState.firearms[e.id] = issued[k] and issued[k].count or 0 end
  end
  return {options=options, traffic=not not authorized(src,netId,'traffic'), firearms=not not authorized(src,netId,'firearms'), vehicle=GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(netId)),issued=issuedState}
end)
lib.callback.register('hf1_bootscript:pin', function(src, netId, pin)
  if not active(src,netId,'firearms') then return {ok=false,message='Access denied'} end
  local a = attempts[src] or {count=0,untilTime=0}
  if a.untilTime > os.time() then return {ok=false,message='Lockbox temporarily locked'} end
  if type(pin) ~= 'string' or not pin:match('^%d%d%d%d$') or pin ~= GetConvar('hf1_boot_pin', '') then
    a.count = a.count + 1
    if a.count >= Config.PinMaxAttempts then a.count=0 a.untilTime=os.time()+Config.PinCooldownSeconds end
    attempts[src]=a
    return {ok=false,message='Incorrect PIN'}
  end
  attempts[src]={count=0,untilTime=0}
  sessions[src].unlocked=true
  return {ok=true}
end)
lib.callback.register('hf1_bootscript:issue', function(src, netId, section, id, requestedCount)
  if section ~= 'police' and section ~= 'firearms' then return {ok=false,message='Invalid category'} end
  if not active(src,netId,section) or not throttle(src) then return {ok=false,message='Access denied or too many requests'} end
  if section == 'firearms' and not sessions[src].unlocked then return {ok=false,message='Unlock the lockbox first'} end
  local entry = findEntry(section == 'police' and Config.PoliceItems or Config.Firearms,id)
  local _, grade = authorized(src,netId,section)
  if not entry or grade < (entry.minGrade or 0) then return {ok=false,message='Item unavailable'} end
  local player = exports.qbx_core:GetPlayer(src)
  local key = issueKey(player.PlayerData.citizenid,netId,section,id)
  if Config.TrackIssuedItems and issued[key] then return {ok=false,message='Already issued; return it first'} end
  local maxCount = available(netId,section,entry)
  local count = tonumber(requestedCount)
  if not count or count ~= math.floor(count) or count < 1 or count > maxCount then return {ok=false,message='Invalid quantity'} end
  if not exports.ox_inventory:CanCarryItem(src,entry.item,count) then return {ok=false,message='Inventory full'} end
  local success = exports.ox_inventory:AddItem(src,entry.item,count)
  if not success then return {ok=false,message='Could not issue item'} end
  if not setAvailable(netId,section,id,maxCount-count) then
    exports.ox_inventory:RemoveItem(src,entry.item,count)
    return {ok=false,message='Vehicle stock unavailable'}
  end
  issued[key]={item=entry.item,count=count}
  return {ok=true,message=count .. ' × ' .. entry.label .. ' taken',issued=count,available=maxCount-count}
end)
lib.callback.register('hf1_bootscript:returnItem', function(src,netId,section,id)
  if section ~= 'police' and section ~= 'firearms' or not active(src,netId,section) or not throttle(src) then return {ok=false,message='Access denied'} end
  if section == 'firearms' and not sessions[src].unlocked then return {ok=false,message='Unlock first'} end
  local player = exports.qbx_core:GetPlayer(src)
  local key = issueKey(player.PlayerData.citizenid,netId,section,id)
  local record = issued[key]
  if not record then return {ok=false,message='No tracked issue to return'} end
  -- Consumables may have been used. Return only what remains, never remove more than issued.
  local remaining = exports.ox_inventory:GetItemCount(src,record.item) or 0
  local toReturn = math.min(record.count, math.max(0,remaining))
  if toReturn > 0 then
    local removed = exports.ox_inventory:RemoveItem(src,record.item,toReturn)
    if not removed then return {ok=false,message='Could not return remaining items'} end
  end
  local newAvailable = available(netId,section,findEntry(section == 'police' and Config.PoliceItems or Config.Firearms,id)) + toReturn
  setAvailable(netId,section,id,newAvailable)
  issued[key]=nil
  return {ok=true,message=toReturn .. ' returned; ' .. (record.count-toReturn) .. ' used or missing',issued=0,available=newAvailable}
end)
lib.callback.register('hf1_bootscript:check',function(src,netId,section)
  return not not active(src,netId,section)
end)
RegisterNetEvent('hf1_bootscript:close',function() sessions[source]=nil end)
AddEventHandler('playerDropped',function() sessions[source]=nil attempts[source]=nil lastAction[source]=nil end)

-- Clean stock records for despawned vehicles. Fresh garage spawns restock automatically.
CreateThread(function()
  while true do
    Wait(60000)
    for netId, record in pairs(vehicleStocks) do
      local entity=NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
      if entity == 0 or not DoesEntityExist(entity) or entity ~= record.entity then
        vehicleStocks[netId]=nil
      end
    end
  end
end)
