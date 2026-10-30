local current, savedAppearance, wearing = nil, nil, {}
local function controlVehicle(vehicle)
  if not DoesEntityExist(vehicle) then return false end
  if not NetworkGetEntityIsNetworked(vehicle) then return true end
  NetworkRequestControlOfEntity(vehicle)
  local untilTime = GetGameTimer() + 1200
  while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < untilTime do
    NetworkRequestControlOfEntity(vehicle)
    Wait(0)
  end
  return NetworkHasControlOfEntity(vehicle)
end
local function closeVehicleBoot(vehicle)
  if vehicle and DoesEntityExist(vehicle) then
    controlVehicle(vehicle)
    SetVehicleDoorShut(vehicle, Config.BootDoorIndex or 5, false)
  end
end
local function notify(message, kind) lib.notify({title='HF1 Boot',description=message,type=kind or 'inform'}) end
local function animateOpenBoot(vehicle)
  local ped = cache.ped
  local dict = 'anim@mp_player_intmenu@key_fob@'
  RequestAnimDict(dict)
  local deadline = GetGameTimer() + 1500
  while not HasAnimDictLoaded(dict) and GetGameTimer() < deadline do Wait(0) end
  if HasAnimDictLoaded(dict) then
    TaskPlayAnim(ped, dict, 'fob_click', 8.0, -8.0, 850, 48, 0.0, false, false, false)
    Wait(550)
    RemoveAnimDict(dict)
  end
  if DoesEntityExist(vehicle) then
    controlVehicle(vehicle)
    SetVehicleDoorOpen(vehicle, Config.BootDoorIndex or 5, false, false)
    -- Retry after ownership settles on streamed / networked custom vehicles.
    Wait(250)
    if DoesEntityExist(vehicle) and GetVehicleDoorAngleRatio(vehicle, Config.BootDoorIndex or 5) < 0.05 then
      controlVehicle(vehicle)
      SetVehicleDoorOpen(vehicle, Config.BootDoorIndex or 5, false, false)
    end
    if GetVehicleDoorAngleRatio(vehicle, Config.BootDoorIndex or 5) < 0.05 then
      notify('Trunk did not open. Check custom vehicle door bones / BootDoorIndex.', 'warning')
    end
  end
end
local function appearanceExport(method, ...)
  if GetResourceState(Config.Appearance) ~= 'started' then return nil end
  if Config.Appearance == 'illenium-appearance' or Config.Appearance == 'op-clothing' then
    if method == 'get' then return exports[Config.Appearance]:getPedAppearance(cache.ped) end
    if method == 'set' then return exports[Config.Appearance]:setPedAppearance(cache.ped, ...) end
  elseif Config.Appearance == 'fivem-appearance' then
    if method == 'get' then return exports['fivem-appearance']:getPedAppearance(cache.ped) end
    if method == 'set' then return exports['fivem-appearance']:setPedAppearance(cache.ped, ...) end
  end
end
local function clone(t) return json.decode(json.encode(t)) end
local function applyClothing()
  if not savedAppearance then return end
  local app = clone(savedAppearance)
  local model = GetEntityModel(cache.ped)
  for _, entry in ipairs(Config.Clothing) do
    if wearing[entry.id] then
      local outfit = (model == joaat('mp_f_freemode_01') and entry.female) or entry.male or entry
      for _, component in ipairs(outfit.components or {}) do
        local replacement = clone(component)
        replacement.texture = replacement.texture or 0
        replacement.palette = replacement.palette or 0
        local found = false
        for i, old in ipairs(app.components or {}) do
          if old.component_id == replacement.component_id then app.components[i] = replacement found = true break end
        end
        if not found then app.components = app.components or {} app.components[#app.components+1] = replacement end
      end
      for _, prop in ipairs(outfit.props or {}) do
        local replacement = clone(prop)
        replacement.texture = replacement.texture or 0
        local found = false
        for i, old in ipairs(app.props or {}) do
          if old.prop_id == replacement.prop_id then app.props[i] = replacement found = true break end
        end
        if not found then app.props = app.props or {} app.props[#app.props+1] = replacement end
      end
    end
  end
  appearanceExport('set', app)
  -- Some appearance compatibility layers ignore individual components when applying
  -- a full appearance. Explicit natives ensure jacket (11) and arms/gloves (3) stick.
  for _, entry in ipairs(Config.Clothing) do
    if wearing[entry.id] then
      local outfit = (model == joaat('mp_f_freemode_01') and entry.female) or entry.male or entry
      for _, part in ipairs(outfit.components or {}) do
        local drawable, texture = tonumber(part.drawable), tonumber(part.texture) or 0
        if drawable and drawable >= 0 and drawable < GetNumberOfPedDrawableVariations(cache.ped, part.component_id) then
          if texture < GetNumberOfPedTextureVariations(cache.ped, part.component_id, drawable) then
            SetPedComponentVariation(cache.ped, part.component_id, drawable, texture, part.palette or 0)
          else notify(('Invalid texture %d for clothing %s'):format(texture, entry.id), 'error') end
        else notify(('Invalid drawable for %s (component %s)'):format(entry.id, tostring(part.component_id)), 'error') end
      end
    end
  end
end
local function toggleClothing(id)
  local entry
  for _, e in ipairs(Config.Clothing) do if e.id == id then entry=e break end end
  if not entry then return {ok=false,message='Unknown clothing'} end
  if not savedAppearance then
    savedAppearance = appearanceExport('get')
    if not savedAppearance then return {ok=false,message='Appearance resource not running or unsupported'} end
  end
  wearing[id] = not wearing[id] or nil
  local any = false
  for _, value in pairs(wearing) do if value then any=true break end end
  if any then applyClothing() else appearanceExport('set',savedAppearance) savedAppearance=nil end
  return {ok=true,message=wearing[id] and 'Clothing equipped' or 'Previous appearance restored',wearing=not not wearing[id]}
end
local function closeUI()
  SetNuiFocus(false,false)
  SendNUIMessage({type='close'})
  if current then
    closeVehicleBoot(current.entity)
    TriggerServerEvent('hf1_bootscript:close')
  end
  current=nil
end
local function openBoot(entity)
  if current then return end
  local netId = NetworkGetNetworkIdFromEntity(entity)
  local data = lib.callback.await('hf1_bootscript:open',false,netId)
  if not data or data.error then return notify(data and data.error or 'Unable to open boot','error') end
  current={netId=netId,entity=entity}
  animateOpenBoot(entity)
  if not current or not DoesEntityExist(entity) then closeUI() return end
  SetNuiFocus(true,true)
  SendNUIMessage({type='open',data=data,wearing=wearing,branding={forceName=Config.Tablet.forceName,title=Config.Tablet.title,logo=Config.Tablet.logo}})
end
local hashes = {}
for _, model in ipairs(Config.Vehicles) do hashes[#hashes+1]=joaat(model) end
exports.ox_target:addModel(hashes,{{
  name='hf1_bootscript:open',icon='fa-solid fa-box-open',label='Open Boot',distance=Config.InteractionDistance,
  bones={'boot'},
  canInteract=function(entity,distance)
    if distance > Config.InteractionDistance or IsPedInAnyVehicle(cache.ped,false) then return false end
    local p=exports.qbx_core:GetPlayerData()
    return p and p.job and p.job.name==Config.Job and (not Config.RequireDuty or p.job.onduty) and (tonumber(type(p.job.grade)=='table' and p.job.grade.level or p.job.grade) or 0) >= (tonumber(Config.MinGrade.clothing) or 0)
  end,
  onSelect=function(data) openBoot(data.entity) end
}})
RegisterNUICallback('close',function(_,cb) closeUI() cb({ok=true}) end)
RegisterNUICallback('action',function(data,cb)
  if not current then return cb({ok=false,message='No active boot'}) end
  local netId=current.netId
  if data.action=='pin' then return cb(lib.callback.await('hf1_bootscript:pin',false,netId,tostring(data.pin or ''))) end
  if data.action=='issue' or data.action=='returnItem' then
    return cb(lib.callback.await('hf1_bootscript:'..data.action,false,netId,data.section,data.id,data.count))
  end
  if data.action=='clothing' then
    local ok=lib.callback.await('hf1_bootscript:check',false,netId,'clothing')
    if not ok then return cb({ok=false,message='Access denied'}) end
    return cb(toggleClothing(data.id))
  end
  if data.action=='traffic' then
    local ok=lib.callback.await('hf1_bootscript:check',false,netId,'traffic')
    if not ok then return cb({ok=false,message='Traffic equipment restricted'}) end
    closeUI()
    if Config.Traffic.mode=='command' then
      ExecuteCommand(Config.Traffic.command)
    elseif Config.Traffic.mode=='export' then
      local success,err=pcall(function() exports[Config.Traffic.resource][Config.Traffic.export]() end)
      if not success then notify('Traffic integration failed: '..tostring(err),'error') end
    else TriggerEvent(Config.Traffic.event) end
    return cb({ok=true})
  end
  cb({ok=false,message='Unknown action'})
end)
CreateThread(function()
  while true do
    Wait(1000)
    if current and (not DoesEntityExist(current.entity) or #(GetEntityCoords(cache.ped)-GetEntityCoords(current.entity))>Config.SessionDistance or IsEntityDead(cache.ped)) then closeUI() end
  end
end)
AddEventHandler('onResourceStop',function(resource) if resource==GetCurrentResourceName() then
  if current then closeVehicleBoot(current.entity) end
  SetNuiFocus(false,false)
end end)
