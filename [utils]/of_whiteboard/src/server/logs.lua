Logs = {}

local cfg   = Config.logs or {}
local hosts = {}

local EVENTS = {
  placed  = { title = "log:poster_placed",  color = 0x61FD59 },
  edited  = { title = "log:poster_edited",  color = 0x356EFF },
  removed = { title = "log:poster_removed", color = 0xDD3939 },
}

local function brand()
  local name = T("brand:name")
  return name ~= "brand:name" and name or GetCurrentResourceName()
end

-- Posters are data URIs, which Discord won't render from an embed. A host turns
-- one into a URL first; without one the entry still goes out, just without a
-- preview. Add a provider here to support another uploader
hosts.none = function()
  return nil
end

hosts.fivemanage = function(dataUri, filename)
  local host = cfg.image_host or {}
  local key  = GetConvar(host.key_convar or "of_whiteboard_media_key", "")

  if key == "" then
    debugC("Image host key convar is empty, logging without a preview")
    return nil
  end

  local ext = dataUri:match("^data:image/([%w%+%-%.]+);base64,")
  local raw = dataUri:match("base64,(.+)")
  if not raw then return nil end

  local p = promise.new()

  PerformHttpRequest(host.endpoint, function(status, body)
    if status < 200 or status >= 300 then
      debugC("Image upload failed", status, body)
      return p:resolve(nil)
    end

    local ok, decoded = pcall(json.decode, body)
    local url = ok and decoded and ((decoded.data and decoded.data.url) or decoded.url) or nil
    if not url then debugC("Image upload returned no url", body) end

    p:resolve(url)
  end, "POST", json.encode({
    base64   = raw,
    filename = ("%s.%s"):format(filename, ext or "png"),
  }), {
    ["Content-Type"]  = "application/json",
    ["Authorization"] = key,
  })

  return Citizen.Await(p)
end

---Yields on the upload; call from a thread
---@param dataUri string|nil
---@return string|nil url
local function hostImage(dataUri, filename)
  if type(dataUri) ~= "string" then return nil end

  local host = hosts[(cfg.image_host or {}).provider or "none"]
  if not host then return nil end

  local ok, url = pcall(host, dataUri, filename)
  return ok and url or nil
end

---Only the fields the bridge could actually resolve, in a stable order
local function identityFields(source)
  local want = cfg.identity or {}
  local id   = Framework.Identity(source)

  local fields = {}
  local function add(enabled, name, value)
    if enabled and value then
      fields[#fields + 1] = { name = name, value = tostring(value), inline = true }
    end
  end

  add(want.character, "Character", id.name)
  add(want.framework, "Identifier", id.identifier)
  add(want.phone, "Phone", id.phone)
  add(want.discord, "Discord", id.discord and ("<@%s>"):format(id.discord) or nil)
  add(want.license, "License", id.license)

  return fields
end

---Fire-and-forget: spawns its own thread so the caller never waits on an upload
---@param event "placed"|"edited"|"removed"
---@param source number
---@param posterId string
---@param dataUri string|nil current image
---@param previousUri string|nil image before an edit
function Logs.Send(event, source, posterId, dataUri, previousUri)
  if not cfg.enabled then return end

  local webhook = (cfg.webhooks or {})[event]
  if not webhook or webhook == "" then return end

  local meta = EVENTS[event]
  if not meta then return end

  CreateThread(function()
    local afterUrl  = hostImage(dataUri, ("%s_after"):format(posterId))
    local beforeUrl = previousUri and hostImage(previousUri, ("%s_before"):format(posterId)) or nil

    local fields = identityFields(source)
    fields[#fields + 1] = { name = "Poster", value = posterId, inline = false }

    local embeds = {}

    if beforeUrl then
      embeds[#embeds + 1] = {
        title  = T("log:before"),
        color  = meta.color,
        image  = { url = beforeUrl },
      }
    end

    embeds[#embeds + 1] = {
      title     = T(meta.title),
      color     = meta.color,
      fields    = fields,
      image     = afterUrl and { url = afterUrl } or nil,
      footer    = { text = cfg.footer or brand() },
      timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }

    PerformHttpRequest(webhook, function(status, body)
      if status ~= 200 and status ~= 204 then
        print(("^3[of_whiteboard]^7 webhook '%s' failed, HTTP %s :: %s"):format(event, tostring(status), tostring(body)))
      end
    end, "POST", json.encode({
      username = cfg.username or brand(),
      embeds   = embeds,
    }), { ["Content-Type"] = "application/json" })
  end)
end
