
local itemsRegistered, why = pcall(Inventory.Functions.RegisterUsables)
if not itemsRegistered then error("Couldnt register items", why) end

local posterSeq = 0

-- Ids outlive the session once posters are persisted, so `source` alone isn't
-- unique enough for a primary key. A per-boot tag keeps them from colliding with
-- rows written before a restart
local bootTag = ("%06x"):format(math.random(0, 0xFFFFFF))

local function nextPosterId()
  repeat
    posterSeq = posterSeq + 1
  until not Stream.Get(("poster_%s_%d"):format(bootTag, posterSeq))

  return ("poster_%s_%d"):format(bootTag, posterSeq)
end

local creationChecks = function(source, data)
  local ped = GetPlayerPed(source)
  local pCoords = GetEntityCoords(ped)

  assert(ped and pCoords, "Couldnt fetch player coords")
  assert(data.coords and data.coords.p1 and data.coords.p2, "Invalid point coords")
  assert(data.baseImg and type(data.baseImg) == "table", "Invalid baseImage")
  assert(#(data.coords.p1 - data.coords.p2) <= 50.0, "Surface too big")
  assert(#(pCoords - data.coords.p1) <= 15.0, "Invalid distance")

  local nearby = Stream.CountNear(pCoords, Config.creation.area_radius)
  assert(nearby < Config.creation.max_per_area, "Too many posters in this area")
end

local editChecks = function(source, poster, data)
  local ped = GetPlayerPed(source)
  local pCoords = GetEntityCoords(ped)

  assert(ped and pCoords, "Couldnt fetch player coords")
  assert(data.baseImg and type(data.baseImg) == "table", "Invalid baseImage")
  assert(
    math.min(#(pCoords - poster.bounds[1]), #(pCoords - poster.bounds[2])) <= 15.0,
    "Invalid distance"
  )
end

local buildPoster = function(data, key, author, imageId)
  local p1 = data.coords.p1
  local p2 = data.coords.p2
  local b1 = vector3(p1.x, p1.y, p1.z)
  local b2 = vector3(p2.x, p2.y, p2.z)

  return {
    id     = key,
    bounds = { b1, b2 },
    center = (b1 + b2) / 2.0,
    img = {
      id     = imageId,
      width  = data.baseImg.width,
      height = data.baseImg.height,
    },
    author = author,
  }
end

---A poster whose author couldn't be resolved at placement time stays unowned, so
---a core without an identifier bridge degrades to the old free-for-all instead of
---locking everyone out
---@param source number
---@param poster table
---@return boolean
local function canModify(source, poster)
  if not (Config.ownership and Config.ownership.enabled) then return true end
  if not poster.author then return true end
  if Framework.IsAdmin(source) then return true end

  return poster.author == Framework.Functions.GetIdentifier(source)
end

---Nearest poster the player is allowed to act on. Reports "not yours" only when
---something was in range but all of it belonged to someone else
---@param source number
---@return table|nil poster
local function nearestOwnPoster(source, action)
  local pCoords = GetEntityCoords(GetPlayerPed(source))
  local radius  = Config.creation.area_radius

  local poster = Stream.NearestTo(pCoords, radius, function(p) return canModify(source, p) end)
  if poster then return poster end

  if Stream.NearestTo(pCoords, radius) then
    Notify.Functions.Send(source, T("poster:not_owner"), "error")
    debugC("Denied", action, "for", source, ":: nothing in range is theirs")
  else
    TriggerClientEvent("of_whiteboard:client:no_posters_close", source)
    debugC("No poster nearby to", action, "for", source)
  end

  return nil
end

RegisterNetEvent("of_whiteboard:server:handlePosterCreation", function(data)
  local src = source
  local succ, err = pcall(creationChecks, src, data)
  if not succ then
    return error("Couldn't validate poster creation :: " .. tostring(err))
  end

  -- Before RemoveItem, so a rejected image costs the player nothing
  local imageId, imgErr = Images.Add(data.baseImg and data.baseImg.data)
  if not imageId then
    Notify.Functions.Send(src, T("poster:image_rejected"), "error")
    return error("Couldn't store poster image :: " .. tostring(imgErr))
  end

  if not Inventory.Functions.RemoveItem(src, Config.items[1].item, 1) then
    Images.Release(imageId)
    return
  end

  local posterKey = nextPosterId()
  local poster = buildPoster(data, posterKey, Framework.Functions.GetIdentifier(src), imageId)

  Stream.Add(poster) -- registers + streams to any player already in range

  CanvasJson[poster.id] = data.baseImg.canvas
  DB.Save(poster, data.baseImg.data, data.baseImg.canvas)

  debugC("Poster created", posterKey, "image", imageId)
  Logs.Send("placed", src, poster.id, data.baseImg.data)
end)

AddEventHandler("of_whiteboard:server:edit_image", function(source)
  local poster = nearestOwnPoster(source, "edit")
  if not poster then return end

  local dataUri = poster.img and Images.Data(poster.img.id)
  if not dataUri then
    return debugC("No image bytes to reopen for", poster.id)
  end

  TriggerClientEvent("of_whiteboard:client:start_editing", source, poster.id, dataUri, CanvasJson[poster.id])
end)

RegisterNetEvent("of_whiteboard:server:handlePosterEdit", function(data)
  local src = source
  local poster = data and data.posterId and Stream.Get(data.posterId)

  if not poster then
    return error("Couldn't find poster to edit :: " .. tostring(data and data.posterId))
  end

  if not canModify(src, poster) then
    Notify.Functions.Send(src, T("poster:not_owner"), "error")
    return debugC("Denied edit commit ::", src, "doesn't own", poster.id)
  end

  local succ, err = pcall(editChecks, src, poster, data)
  if not succ then
    return error("Couldn't validate poster edit :: " .. tostring(err))
  end

  local imageId, imgErr = Images.Add(data.baseImg.data)
  if not imageId then
    Notify.Functions.Send(src, T("poster:image_rejected"), "error")
    return error("Couldn't store edited poster image :: " .. tostring(imgErr))
  end

  local previousId  = poster.img and poster.img.id
  local previousUri = previousId and Images.Data(previousId)

  poster.img = { id = imageId, width = data.baseImg.width, height = data.baseImg.height }
  if previousId then Images.Release(previousId) end

  Stream.Refresh(poster.id) -- bounds are unchanged; only the texture moved

  CanvasJson[poster.id] = data.baseImg.canvas
  DB.Update(poster, data.baseImg.data, data.baseImg.canvas)

  debugC("Poster edited", poster.id, "image", imageId)
  Logs.Send("edited", src, poster.id, data.baseImg.data, previousUri)
end)

AddEventHandler("of_whiteboard:server:remove_image", function(source, item_data)
  local poster = nearestOwnPoster(source, "remove")
  if not poster then return end

  if not Inventory.Functions.RemoveItem(source, item_data.name, 1) then return end

  local removedUri = poster.img and Images.Data(poster.img.id)

  local removed = Stream.Remove(poster.id) -- drops it for everyone streaming it
  if removed and removed.img and removed.img.id then
    Images.Release(removed.img.id)
  end

  DB.Delete(poster.id)

  TriggerClientEvent("of_whiteboard:client:remove_confirmation", source)
  debugC("Removed", poster.id, "by", source)
  Logs.Send("removed", source, poster.id, removedUri)
end)
