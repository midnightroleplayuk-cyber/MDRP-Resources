DB = {}
DB.enabled = false

-- Canvas objects (text boxes, shapes, strokes) as the editor serialised them,
-- kept alongside the flattened image so a re-edit reopens the real objects
CanvasJson = {}

local cfg   = Config.persistence or {}
local TABLE = cfg.table or "of_whiteboard_posters"

-- Talking to oxmysql through its raw exports instead of `@oxmysql/lib/MySQL.lua`
-- keeps it an optional dependency: with persistence off, or oxmysql absent, this
-- file just no-ops instead of failing the resource at load
local function await(method, query, parameters)
  local p = promise.new()

  exports.oxmysql[method](nil, query, parameters, function(result, err)
    if err then return p:reject(err) end
    p:resolve(result)
  end, Server.Resource, true)

  return Citizen.Await(p)
end

---@return boolean ok, any result
local function exec(method, sql, parameters)
  local ok, res = pcall(await, method, sql, parameters)
  if not ok then
    print(("^1[of_whiteboard]^7 database error :: %s"):format(tostring(res)))
  end
  return ok, res
end

local function query(method, sql, parameters)
  if not DB.enabled then return nil end

  local ok, res = exec(method, sql, parameters)
  return ok and res or nil
end

local function ensureTable()
  local ok = exec("query", ([[
    CREATE TABLE IF NOT EXISTS `%s` (
      `id`         VARCHAR(64) NOT NULL,
      `author`     VARCHAR(64) DEFAULT NULL,
      `x1`         DOUBLE NOT NULL,
      `y1`         DOUBLE NOT NULL,
      `z1`         DOUBLE NOT NULL,
      `x2`         DOUBLE NOT NULL,
      `y2`         DOUBLE NOT NULL,
      `z2`         DOUBLE NOT NULL,
      `img_width`  INT NOT NULL DEFAULT 0,
      `img_height` INT NOT NULL DEFAULT 0,
      `img_data`   MEDIUMTEXT NOT NULL,
      `canvas`     LONGTEXT DEFAULT NULL,
      `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    )
  ]]):format(TABLE))

  return ok
end

---Rebuild the in-memory store from the table. Registers rather than adds, so no
---stream events fire before any player is connected
local function load()
  local rows = query("query", ("SELECT * FROM `%s`"):format(TABLE))
  if not rows then return end

  local restored = 0
  for _, row in ipairs(rows) do
    if Images.Restore(row.id, row.img_data) then
      CanvasJson[row.id] = row.canvas

      Stream.Register({
        id     = row.id,
        bounds = { vector3(row.x1, row.y1, row.z1), vector3(row.x2, row.y2, row.z2) },
        center = vector3((row.x1 + row.x2) / 2.0, (row.y1 + row.y2) / 2.0, (row.z1 + row.z2) / 2.0),
        img    = { id = row.id, width = row.img_width, height = row.img_height },
        author = row.author,
      })
      restored = restored + 1
    end
  end

  debugC(("Restored %d/%d persisted poster(s)"):format(restored, #rows))
end

---@param poster table
---@param dataUri string
---@param canvasJson string?
function DB.Save(poster, dataUri, canvasJson)
  local p1, p2 = poster.bounds[1], poster.bounds[2]

  query("insert", ([[
    INSERT INTO `%s` (id, author, x1, y1, z1, x2, y2, z2, img_width, img_height, img_data, canvas)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ]]):format(TABLE), {
    poster.id, poster.author,
    p1.x, p1.y, p1.z,
    p2.x, p2.y, p2.z,
    poster.img.width, poster.img.height,
    dataUri, canvasJson,
  })
end

---@param poster table
---@param dataUri string
---@param canvasJson string?
function DB.Update(poster, dataUri, canvasJson)
  query("update", ([[
    UPDATE `%s` SET img_width = ?, img_height = ?, img_data = ?, canvas = ? WHERE id = ?
  ]]):format(TABLE), {
    poster.img.width, poster.img.height, dataUri, canvasJson, poster.id,
  })
end

---@param id string
function DB.Delete(id)
  CanvasJson[id] = nil
  query("update", ("DELETE FROM `%s` WHERE id = ?"):format(TABLE), { id })
end

CreateThread(function()
  if not cfg.enabled then
    return debugC("Persistence disabled, posters live for this session only")
  end

  if GetResourceState("oxmysql") ~= "started" then
    return print("^3[of_whiteboard]^7 persistence is enabled but oxmysql isn't running, posters won't survive a restart")
  end

  DB.enabled = true

  if not ensureTable() then
    DB.enabled = false
    return print("^1[of_whiteboard]^7 couldn't create the poster table, persistence is off")
  end

  load()
end)
