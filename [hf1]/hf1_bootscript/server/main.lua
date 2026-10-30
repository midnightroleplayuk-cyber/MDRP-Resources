local sessions, issued, attempts, lastAction = {}, {}, {}, {}
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
  for _, e in ipairs(Config.Clothing) do if grade >= (e.minGrade or 0) then options.clothing[#options.clothing+1] = {id=e.id,label=e.label} end end
  for _, e in ipairs(Config.PoliceItems) do if grade >= (e.minGrade or 0) then options.police[#options.police+1] = {id=e.id,label=e.label} end end
  if authorized(src, netId, 'firearms') then
    for _, e in ipairs(Config.Firearms) do if grade >= (e.minGrade or 0) then options.firearms[#options.firearms+1] = {id=e.id,label=e.label} end end
  end
  return {options=options, traffic=not not authorized(src,netId,'traffic'), firearms=not not authorized(src,netId,'firearms'), vehicle=GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(netId))}
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
lib.callback.register('hf1_bootscript:issue', function(src, netId, section, id)
  if section ~= 'police' and section ~= 'firearms' then return {ok=false,message='Invalid category'} end
  if not active(src,netId,section) or not throttle(src) then return {ok=false,message='Access denied or too many requests'} end
  if section == 'firearms' and not sessions[src].unlocked then return {ok=false,message='Unlock the lockbox first'} end
  local entry = findEntry(section == 'police' and Config.PoliceItems or Config.Firearms,id)
  local _, grade = authorized(src,netId,section)
  if not entry or grade < (entry.minGrade or 0) then return {ok=false,message='Item unavailable'} end
  local player = exports.qbx_core:GetPlayer(src)
  local key = player.PlayerData.citizenid .. ':' .. section .. ':' .. id
  if Config.TrackIssuedItems and issued[key] then return {ok=false,message='Already issued; return it first'} end
  local count = math.max(1,math.floor(tonumber(entry.count) or 1))
  if not exports.ox_inventory:CanCarryItem(src,entry.item,count) then return {ok=false,message='Inventory full'} end
  local success = exports.ox_inventory:AddItem(src,entry.item,count)
  if not success then return {ok=false,message='Could not issue item'} end
  if Config.TrackIssuedItems then issued[key]={item=entry.item,count=count} end
  return {ok=true,message=entry.label .. ' issued'}
end)
lib.callback.register('hf1_bootscript:returnItem', function(src,netId,section,id)
  if section ~= 'police' and section ~= 'firearms' or not active(src,netId,section) or not throttle(src) then return {ok=false,message='Access denied'} end
  if section == 'firearms' and not sessions[src].unlocked then return {ok=false,message='Unlock first'} end
  local player = exports.qbx_core:GetPlayer(src)
  local key = player.PlayerData.citizenid .. ':' .. section .. ':' .. id
  local record = issued[key]
  if not record then return {ok=false,message='No tracked issue to return'} end
  local removed = exports.ox_inventory:RemoveItem(src,record.item,record.count)
  if not removed then return {ok=false,message='Required item not in inventory'} end
  issued[key]=nil
  return {ok=true,message='Item returned'}
end)
lib.callback.register('hf1_bootscript:check',function(src,netId,section)
  return not not active(src,netId,section)
end)
RegisterNetEvent('hf1_bootscript:close',function() sessions[source]=nil end)
AddEventHandler('playerDropped',function() sessions[source]=nil attempts[source]=nil lastAction[source]=nil end)
