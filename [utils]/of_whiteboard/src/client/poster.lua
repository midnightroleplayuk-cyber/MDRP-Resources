Poster = {}
Poster.known = {} -- id -> { id, bounds = {vec3, vec3}, img, author, poolRef }

local RENDER_DIST  = CONST.RENDER_DISTANCE
local RELEASE_DIST = RENDER_DIST + 10.0 -- hysteresis so pacing the boundary doesn't thrash the pool
local MAX_DUIS     = Config.max_active_duis or 12
local DUI_RES      = Config.dui_resolution or 512
local CACHE_MAX    = Config.images.client_cache or 24
local RETRY_AFTER  = 5000 -- ms before re-attempting a failed image pull

local imgCache   = {} -- imageId -> data URI
local imgOrder   = {} -- imageId list, most recently used last
local imgPending = {} -- imageId -> true while a pull is in flight
local imgRetryAt = {} -- imageId -> earliest ms at which to retry a failed pull

local function cacheTouch(id)
  for i = #imgOrder, 1, -1 do
    if imgOrder[i] == id then table.remove(imgOrder, i) break end
  end
  imgOrder[#imgOrder + 1] = id
end

local function cachePut(id, data)
  imgCache[id] = data
  cacheTouch(id)

  while #imgOrder > CACHE_MAX do
    local evicted = table.remove(imgOrder, 1)
    imgCache[evicted] = nil
  end
end

---Yields; call from a thread
---@return string|nil dataUri
local function fetchImage(poster)
  local parts, total, index = {}, nil, 1

  repeat
    local res = lib.callback.await("of_whiteboard:server:image:chunk", false, poster.id, index)
    if not res or not res.data then
      debugC("Image pull failed for", poster.id, "at chunk", index)
      return nil
    end

    total = res.chunks
    parts[index] = res.data
    index = index + 1
  until index > total

  return table.concat(parts)
end

-- Kick off a background pull; the poster starts drawing once the bytes land
local function requestImage(poster)
  local imgId = poster.img and poster.img.id
  if not imgId or imgCache[imgId] or imgPending[imgId] then return end
  if imgRetryAt[imgId] and GetGameTimer() < imgRetryAt[imgId] then return end

  imgPending[imgId] = true
  Citizen.CreateThread(function()
    local data = fetchImage(poster)
    imgPending[imgId] = nil

    if data then
      imgRetryAt[imgId] = nil
      cachePut(imgId, data)
      debugC("Image cached", imgId, ("%d KB"):format(math.floor(#data / 1024)))
    else
      imgRetryAt[imgId] = GetGameTimer() + RETRY_AFTER
    end
  end)
end

-- DUIs take ~1s to spin up, so pool and re-point them instead of creating one per poster
local pool     = {} -- all created pool entries
local freeList = {} -- stack of currently free entries

local function blank(entry)
  SendDuiMessage(entry.dui, json.encode({ action = "setDuiProperties", imageSrc = "", width = 0, height = 0 }))
end

local function pointAt(entry, poster, dataUri)
  local function send()
    -- Fill the fixed pool surface (DUI_RES²) so the image is never clipped by the
    -- canvas; the on-world quad shape comes from the poster bounds, not these dims
    SendDuiMessage(entry.dui, json.encode({
      action   = "setDuiProperties",
      imageSrc = dataUri,
      width    = DUI_RES,
      height   = DUI_RES,
    }))
    entry.imgId = poster.img.id
  end

  if entry.ready then
    send()
  else
    -- Defer until the freshly-created DUI is live; skip if it got reassigned meanwhile
    Citizen.SetTimeout(1000, function()
      if entry.boundPoster == poster.id then
        entry.ready = true
        send()
      end
    end)
  end
end

local function createPoolEntry()
  local name = ("wb_poster_%d_%d"):format(GetGameTimer(), #pool + 1)
  local dui  = CreateDui(("https://cfx-nui-%s/dist/index.html"):format(Client.Resource), DUI_RES, DUI_RES)

  local entry = {
    dui        = dui,
    handle     = GetDuiHandle(dui),
    txdName    = name,
    txnName    = name,
    ready      = false,
    boundPoster = nil,
    imgId      = nil,
  }
  entry.txd     = CreateRuntimeTxd(entry.txdName)
  entry.texture = CreateRuntimeTextureFromDuiHandle(entry.txd, entry.txnName, entry.handle)

  Citizen.SetTimeout(1000, function() entry.ready = true end)

  pool[#pool + 1] = entry
  return entry
end

---@param dataUri string the poster's image bytes, already cached
---@return table|nil entry nil when the pool is exhausted
local function acquire(poster, dataUri)
  local entry = table.remove(freeList)
  if not entry then
    if #pool >= MAX_DUIS then return nil end
    entry = createPoolEntry()
  end

  entry.boundPoster = poster.id
  if entry.imgId ~= poster.img.id then
    pointAt(entry, poster, dataUri)
  end
  return entry
end

local function release(entry)
  if not entry then return end
  entry.boundPoster = nil
  entry.imgId = nil
  blank(entry)
  freeList[#freeList + 1] = entry
end

Poster.onStreamAdd = function(data)
  if not data or not data.id or Poster.known[data.id] then return end

  Poster.known[data.id] = {
    id     = data.id,
    author = data.author,
    img    = data.img,
    bounds = {
      vector3(data.bounds[1].x, data.bounds[1].y, data.bounds[1].z),
      vector3(data.bounds[2].x, data.bounds[2].y, data.bounds[2].z),
    },
    poolRef = nil,
  }
end

-- An edit swaps the image behind a poster that never moved. Drop the pooled DUI so
-- the render pass re-acquires one and pulls the new bytes
Poster.onStreamUpdate = function(data)
  if not data or not data.id then return end

  local p = Poster.known[data.id]
  if not p then return Poster.onStreamAdd(data) end

  p.img = data.img
  if p.poolRef then release(p.poolRef); p.poolRef = nil end
end

Poster.onStreamRemove = function(id)
  local p = Poster.known[id]
  if not p then return end
  if p.poolRef then release(p.poolRef); p.poolRef = nil end
  Poster.known[id] = nil
end

Poster.dispatchPosterCreationOnArea = function(p1, p2)
  Citizen.CreateThread(function()
    local succ, _ = pcall(Nui.dispatchCreation)
    if succ then
      local ped = GetPlayerPed(PlayerId())
      lib.playAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, 8.0, 2000, 8)
      Wait(2050)

      local image = Nui.consumeImage()
      TriggerServerEvent("of_whiteboard:server:handlePosterCreation", { baseImg = image, coords = { p1 = p1, p2 = p2 } })
    else debugC("Couldnt get image from Nui.dispatchCreation") end
  end)
end

RegisterNetEvent("of_whiteboard:client:remove_confirmation", function()
  local ped = PlayerPedId()
  lib.playAnim(ped, "amb@world_human_maid_clean@idle_a", "idle_c", 8.0, 8.0, 2000, 8)
end)

RegisterNetEvent("of_whiteboard:client:no_posters_close", function()
  lib.notify({ title = "Poster", description = T("poster:none_nearby") or "No posters nearby", type = "error" })
end)

-- When the pool is smaller than the number of in-range posters, the nearest ones win
Poster.renderThread = function()
  Citizen.CreateThread(function()
    local visible = {}

    while true do
      local wait = 500
      local coords = GetEntityCoords(PlayerPedId())

      for i = #visible, 1, -1 do visible[i] = nil end

      for _, p in pairs(Poster.known) do
        local dist = math.min(#(coords - p.bounds[1]), #(coords - p.bounds[2]))
        p._dist = dist

        if dist <= RENDER_DIST then
          visible[#visible + 1] = p
        elseif p.poolRef and dist > RELEASE_DIST then
          release(p.poolRef)
          p.poolRef = nil
        end
      end

      if #visible > 0 then
        wait = 0
        table.sort(visible, function(a, b) return a._dist < b._dist end)

        for _, p in ipairs(visible) do
          if not p.poolRef then
            local data = p.img and p.img.id and imgCache[p.img.id]
            if data then
              cacheTouch(p.img.id)
              p.poolRef = acquire(p, data)
            else
              requestImage(p)
            end
          end

          if p.poolRef then
            local b1, b2 = p.bounds[1], p.bounds[2]
            local minZ, maxZ = math.min(b1.z, b2.z), math.max(b1.z, b2.z)

            World.DrawImageOnArea(
              b1, b2, minZ, maxZ,
              255, 255, 255, 255,
              p.poolRef.txdName, p.poolRef.txnName
            )

            if Config.Debug then
              local width = #(vector3(b1.x, b1.y, 0.0) - vector3(b2.x, b2.y, 0.0))
              local top = vector3((b1.x + b2.x) / 2.0, (b1.y + b2.y) / 2.0, maxZ + 0.2)
              World.DrawText3D(top, ("%s :: %.2fm x %.2fm"):format(p.id, width, maxZ - minZ))
            end
          end
        end
      end

      Citizen.Wait(wait)
    end
  end)
end

Poster.renderThread()

RegisterNetEvent("of_whiteboard:client:stream:add", Poster.onStreamAdd)
RegisterNetEvent("of_whiteboard:client:stream:update", Poster.onStreamUpdate)
RegisterNetEvent("of_whiteboard:client:stream:remove", Poster.onStreamRemove)
