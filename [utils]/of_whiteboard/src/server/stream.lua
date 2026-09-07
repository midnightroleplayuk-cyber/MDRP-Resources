Stream = {}

local CELL        = Config.stream.distance -- cell size == interest radius, so 3x3 covers it
local STREAM_DIST = Config.stream.distance
local INTERVAL    = Config.stream.interval or 600

local Posters  = {} -- id -> { id, bounds = {vec3, vec3}, center = vec3, cell, img, author }
local grid     = {} -- "cx:cy" -> { [id] = true }
local streamed = {} -- src(number) -> { [id] = true }

local function cellKey(x, y)
  return ("%d:%d"):format(math.floor(x / CELL), math.floor(y / CELL))
end

local function addToGrid(poster)
  poster.cell = cellKey(poster.center.x, poster.center.y)
  local cell = grid[poster.cell]
  if not cell then cell = {}; grid[poster.cell] = cell end
  cell[poster.id] = true
end

local function removeFromGrid(poster)
  local cell = grid[poster.cell]
  if not cell then return end
  cell[poster.id] = nil
  if next(cell) == nil then grid[poster.cell] = nil end
end

-- Ids from the 3x3 cell neighbourhood around a world position
local function candidatesAround(x, y)
  local cx, cy = math.floor(x / CELL), math.floor(y / CELL)
  local out = {}
  for gx = cx - 1, cx + 1 do
    for gy = cy - 1, cy + 1 do
      local cell = grid[("%d:%d"):format(gx, gy)]
      if cell then
        for id in pairs(cell) do out[id] = true end
      end
    end
  end
  return out
end

-- Nearest distance from `pos` to either bound corner of the poster
local function nearestDist(poster, pos)
  return math.min(#(poster.bounds[1] - pos), #(poster.bounds[2] - pos))
end

function Stream.Get(id) return Posters[id] end

function Stream.All() return Posters end

-- Is `id` currently streamed to `src`? Gates image transfers (src/server/images.lua):
-- a player may only pull the bytes of a poster already in their interest set
function Stream.IsStreamedTo(src, id)
  local set = streamed[src]
  return (set and set[id]) == true
end

-- Count posters within `radius` of a point (broadphase + exact). Used by the
-- placement density cap
function Stream.CountNear(pos, radius)
  local n = 0
  for id in pairs(candidatesAround(pos.x, pos.y)) do
    local p = Posters[id]
    if p and nearestDist(p, pos) <= radius then n = n + 1 end
  end
  return n
end

-- Nearest poster to `pos` within `maxDist` (default: unlimited within broadphase).
-- `predicate` narrows the search rather than filtering afterwards, so standing
-- next to someone else's poster doesn't hide your own
function Stream.NearestTo(pos, maxDist, predicate)
  local best, bestDist
  for id in pairs(candidatesAround(pos.x, pos.y)) do
    local p = Posters[id]
    if p and (not predicate or predicate(p)) then
      local d = nearestDist(p, pos)
      if (not maxDist or d <= maxDist) and (not bestDist or d < bestDist) then
        best, bestDist = p, d
      end
    end
  end
  return best, bestDist
end

-- Register a poster without announcing it. Used by the persistence load, where
-- the reconcile pass is what eventually streams it out
function Stream.Register(poster)
  Posters[poster.id] = poster
  addToGrid(poster)
end

-- Register a poster and immediately stream it to any player already in range
function Stream.Add(poster)
  Posters[poster.id] = poster
  addToGrid(poster)

  for _, sid in ipairs(GetPlayers()) do
    local src = tonumber(sid)
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
      if nearestDist(poster, GetEntityCoords(ped)) <= STREAM_DIST then
        local set = streamed[src]; if not set then set = {}; streamed[src] = set end
        if not set[poster.id] then
          set[poster.id] = true
          TriggerClientEvent("of_whiteboard:client:stream:add", src, poster)
        end
      end
    end
  end
end

-- Re-push a poster's metadata to everyone already streaming it. Its bounds don't
-- move, so this is only ever about a changed image
function Stream.Refresh(id)
  local poster = Posters[id]
  if not poster then return end

  for src, set in pairs(streamed) do
    if set[id] then
      TriggerClientEvent("of_whiteboard:client:stream:update", src, poster)
    end
  end
end

-- Remove a poster and tell every player currently streaming it. Returns the poster
function Stream.Remove(id)
  local poster = Posters[id]
  if not poster then return nil end

  removeFromGrid(poster)
  Posters[id] = nil

  for src, set in pairs(streamed) do
    if set[id] then
      set[id] = nil
      TriggerClientEvent("of_whiteboard:client:stream:remove", src, id)
    end
  end
  return poster
end

local function reconcile(src)
  local ped = GetPlayerPed(src)
  if not ped or ped == 0 then return end

  local coords = GetEntityCoords(ped)
  local set = streamed[src]; if not set then set = {}; streamed[src] = set end

  local inRange = candidatesAround(coords.x, coords.y)

  -- Additions (and prune candidates that fail the exact distance test)
  for id in pairs(inRange) do
    local p = Posters[id]
    if p and nearestDist(p, coords) <= STREAM_DIST then
      if not set[id] then
        set[id] = true
        TriggerClientEvent("of_whiteboard:client:stream:add", src, p)
      end
    else
      inRange[id] = nil
    end
  end

  -- Removals: anything streamed that is no longer in range
  for id in pairs(set) do
    if not inRange[id] then
      set[id] = nil
      TriggerClientEvent("of_whiteboard:client:stream:remove", src, id)
    end
  end
end

CreateThread(function()
  while true do
    for _, sid in ipairs(GetPlayers()) do
      reconcile(tonumber(sid))
    end
    Wait(INTERVAL)
  end
end)

AddEventHandler("playerDropped", function()
  streamed[source] = nil
end)

if Config.Debug then
  RegisterCommand("test_posters", function()
    local posterCount, cellCount = 0, 0
    for _ in pairs(Posters) do posterCount = posterCount + 1 end
    for _ in pairs(grid) do cellCount = cellCount + 1 end
    print(("[of_whiteboard] %d posters across %d grid cells"):format(posterCount, cellCount))
    print(json.encode(Posters, { indent = true }))
  end, false)
end
