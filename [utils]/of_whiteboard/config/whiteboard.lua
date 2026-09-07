Config = Config or {}

Config.images = {
  max_total_bytes = 64 * 1024 * 1024, -- server-wide budget; placement is refused past this
  max_image_bytes = 1024 * 1024,      -- per-image cap, measured on the encoded payload
  chunk_bytes     = 48 * 1024,        -- transfer chunk size
  client_cache    = 24,               -- images a client keeps cached (LRU)
  export_max_px   = 1024,             -- longest side of the exported image
  export_quality  = 0.85,             -- webp quality of the export
}

Config.render_distance = 20.0 -- distance at which a poster's DUI is drawn
Config.server_color    = { r = 108, g = 59, b = 255 }

Config.stream = {
  distance = 150.0, -- radius within which poster metadata is streamed to a client
  interval = 600,   -- ms between server-side interest recalculations
}

Config.max_active_duis = 12  -- hard cap on simultaneously live DUIs
Config.dui_resolution  = 512 -- pooled DUI render surface, square px

Config.creation = {
  max_per_area = 4,
  area_radius  = 30.0,
}

Config.keys = {
  select_building_bound = 176, -- enter
  leave_building_mode   = 200, -- esc
}

-- Restriction to place posters
Config.Check = {}

-- Example: police, grade 2 and above
-- Config.Check = {
--   __operator = "or", -- and,
--   HasJob = {
--     name  = "police",
--     grade = 2, -- and above
--   },
-- }

-- Who may edit or remove a placed poster
Config.ownership = {
  enabled          = true,    -- restrict edit/remove to the author
  admin_override   = true,    -- let admins act on any poster
  admin_permission = "admin", -- qb/qbx permission name, ace name under ESX
}

-- Requires oxmysql
Config.persistence = {
  enabled = true,
  table   = "of_whiteboard_posters",
}

-- Discord webhook logging. Every entry is off until you paste a URL in
Config.logs = {
  enabled  = false,
  username = nil, -- webhook display name, nil falls back to `brand:name`
  footer   = nil, -- embed footer, nil falls back to `brand:name`

  webhooks = {
    placed  = "",
    edited  = "",
    removed = "",
  },

  -- Fields to include. Anything the framework bridge can't resolve is skipped
  identity = {
    character  = true,
    framework  = true, -- citizenid / identifier
    phone      = true,
    discord    = true,
    license    = true,
  },

  -- Posters are data URIs, which Discord can't render from an embed. Set a host
  -- to upload them first; "none" logs the entry without a preview
  image_host = {
    provider    = "none", -- "none" or "fivemanage"
    key_convar  = "of_whiteboard_media_key",
    endpoint    = "https://api.fivemanage.com/api/v3/file/base64",
  },
}

-- On use, `item` triggers `event` on `target`. `id` is the export name ox_inventory
-- binds the usable to. To rename an item, edit `item`
Config.items = {
  { item = "place_poster",  id = "place_image",  target = "client", event = "of_whiteboard:client:start_building" },
  { item = "edit_poster",   id = "edit_image",   target = "server", event = "of_whiteboard:server:edit_image"     },
  { item = "remove_poster", id = "remove_image", target = "server", event = "of_whiteboard:server:remove_image"   },
}
