Images = {}

local store = {} -- id -> { data = <data URI>, size = <bytes>, refs = <n> }
local used  = 0
local seq   = 0

local BUDGET    = Config.images.max_total_bytes
local MAX_IMAGE = Config.images.max_image_bytes
local CHUNK     = Config.images.chunk_bytes

local function kb(n) return math.floor(n / 1024) end

local function isDataUri(s)
  return type(s) == "string"
    and s:match("^data:image/[%w%+%-%.]+;base64,[A-Za-z0-9%+/=]+$") ~= nil
end

---@param dataUri string
---@return string|nil id, string|nil err
function Images.Add(dataUri)
  if not isDataUri(dataUri) then return nil, "not a base64 image data URI" end

  local size = #dataUri
  if size > MAX_IMAGE then
    return nil, ("image too large (%d KB, max %d KB)"):format(kb(size), kb(MAX_IMAGE))
  end
  if used + size > BUDGET then
    return nil, ("image store full (%d/%d KB used)"):format(kb(used), kb(BUDGET))
  end

  seq = seq + 1
  local id = ("img_%d_%d"):format(GetGameTimer(), seq)

  store[id] = { data = dataUri, size = size, refs = 1 }
  used = used + size

  debugC("Image stored", id, ("%d KB"):format(kb(size)), ("store %d/%d KB"):format(kb(used), kb(BUDGET)))
  return id
end

---Re-seed the store from persisted bytes, keyed by an id the caller already owns.
---No-op when the id is taken or the budget can't take it
---@param id string
---@param dataUri string
---@return boolean restored
function Images.Restore(id, dataUri)
  if store[id] or not isDataUri(dataUri) then return false end

  local size = #dataUri
  if used + size > BUDGET then
    debugC("Image restore skipped", id, ("store full %d/%d KB"):format(kb(used), kb(BUDGET)))
    return false
  end

  store[id] = { data = dataUri, size = size, refs = 1 }
  used = used + size
  return true
end

---@param id string
---@return string|nil dataUri
function Images.Data(id)
  local e = store[id]
  return e and e.data or nil
end

function Images.Ref(id)
  local e = store[id]
  if e then e.refs = e.refs + 1 end
end

function Images.Release(id)
  local e = store[id]
  if not e then return end

  e.refs = e.refs - 1
  if e.refs > 0 then return end

  store[id] = nil
  used = used - e.size
  debugC("Image freed", id, ("store %d/%d KB"):format(kb(used), kb(BUDGET)))
end

---@return integer chunks, integer size
function Images.Meta(id)
  local e = store[id]
  if not e then return 0, 0 end
  return math.ceil(e.size / CHUNK), e.size
end

---@param i integer 1-based chunk index
---@return string|nil
function Images.Chunk(id, i)
  local e = store[id]
  if not e then return nil end

  local from = (i - 1) * CHUNK + 1
  if from > e.size then return nil end
  return e.data:sub(from, from + CHUNK - 1)
end

lib.callback.register("of_whiteboard:server:image:chunk", function(source, posterId, index)
  if not Stream.IsStreamedTo(source, posterId) then return nil end

  local poster = Stream.Get(posterId)
  local imgId  = poster and poster.img and poster.img.id
  if not imgId then return nil end

  index = tonumber(index)
  if not index or index < 1 then return nil end

  local chunks, size = Images.Meta(imgId)
  if chunks == 0 then return nil end

  local data = Images.Chunk(imgId, index)
  if not data then return nil end

  return { index = index, chunks = chunks, size = size, data = data }
end)

if Config.Debug then
  RegisterCommand("test_images", function()
    local count = 0
    for _ in pairs(store) do count = count + 1 end
    print(("[of_whiteboard] %d images, %d/%d KB used"):format(count, kb(used), kb(BUDGET)))
    for id, e in pairs(store) do
      print(("  %s :: %d KB, %d ref(s)"):format(id, kb(e.size), e.refs))
    end
  end, false)
end
