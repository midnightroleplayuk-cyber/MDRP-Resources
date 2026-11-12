VMC = VMC or {}

VMC.Ease = {
    linear         = function(t) return t end,
    easeInOutSine  = function(t) return -(math.cos(math.pi * t) - 1) / 2 end,
    easeInOutCubic = function(t) return t < 0.5 and 4 * t * t * t or 1 - ((-2 * t + 2) ^ 3) / 2 end,
    easeInOutQuint = function(t) return t < 0.5 and 16 * t ^ 5 or 1 - ((-2 * t + 2) ^ 5) / 2 end,
    easeOutQuart   = function(t) return 1 - (1 - t) ^ 4 end,
    easeOutExpo    = function(t) return t == 1 and 1 or 1 - 2 ^ (-10 * t) end,
    easeInQuad     = function(t) return t * t end,
}

VMC.EaseNames = { 'linear', 'easeInOutSine', 'easeInOutCubic', 'easeInOutQuint', 'easeOutQuart', 'easeOutExpo', 'easeInQuad' }

function VMC.GetEase(name)
    return VMC.Ease[name or ''] or VMC.Ease.easeInOutCubic
end

function VMC.Clamp(v, min, max)
    v = tonumber(v) or min
    if v < min then return min end
    if v > max then return max end
    return v
end

function VMC.Round(v, dp)
    local m = 10 ^ (dp or 3)
    return math.floor((tonumber(v) or 0) * m + 0.5) / m
end

function VMC.Copy(t)
    if type(t) ~= 'table' then return t end
    local out = {}
    for k, v in pairs(t) do out[k] = VMC.Copy(v) end
    return out
end

local function num(v, def, min, max)
    v = tonumber(v)
    if not v or v ~= v then return def end -- nan check
    if min and v < min then v = min end
    if max and v > max then v = max end
    return v
end
VMC.Num = num

local function xyz(t, def)
    t = type(t) == 'table' and t or {}
    def = def or { x = 0, y = 0, z = 0 }
    return {
        x = VMC.Round(num(t.x, def.x, -20000, 20000), 4),
        y = VMC.Round(num(t.y, def.y, -20000, 20000), 4),
        z = VMC.Round(num(t.z, def.z, -2000, 5000), 4),
    }
end
VMC.XYZ = xyz

local function str(v, max, def)
    if type(v) ~= 'string' then return def end
    v = v:gsub('[%c]', '')
    if #v > (max or 64) then v = v:sub(1, max or 64) end
    return v
end
VMC.Str = str

-- Sanitise a scene coming from an admin client so nothing silly ends up in the database
function VMC.SanitiseScene(s)
    s = type(s) == 'table' and s or {}
    local ed = Config.Editor
    local out = {
        name = str(s.name, 48, 'Untitled scene'),
        enabled = s.enabled ~= false,
        weight = math.floor(num(s.weight, 1, 0, 100)),
        env = {},
        camera = {},
        spots = {},
        props = {},
    }

    local env = type(s.env) == 'table' and s.env or {}
    out.env.hour = math.floor(num(env.hour, 19, 0, 23))
    out.env.minute = math.floor(num(env.minute, 0, 0, 59))
    out.env.weather = str(env.weather, 24, 'CLEAR'):upper()
    out.env.freeze = env.freeze ~= false

    local cam = type(s.camera) == 'table' and s.camera or {}
    out.camera.transition = math.floor(num(cam.transition, Config.Camera.Transition, 100, 10000))
    out.camera.ease = VMC.Ease[cam.ease or ''] and cam.ease or Config.Camera.Ease
    out.camera.shake = VMC.Round(num(cam.shake, Config.Camera.Shake, 0, 2), 3)
    local dof = type(cam.dof) == 'table' and cam.dof or {}
    out.camera.dof = { enabled = dof.enabled ~= false, strength = VMC.Round(num(dof.strength, 0.7, 0, 1), 2) }
    out.camera.flow = cam.flow ~= false            -- no stopping between keyframes
    out.camera.pathEase = VMC.Ease[cam.pathEase or ''] and cam.pathEase or 'easeInOutSine'
    out.camera.glide = cam.glide ~= false          -- carry the path straight into the first character
    out.camera.intro = {}
    if type(cam.intro) == 'table' then
        for i = 1, math.min(#cam.intro, ed.MaxKeyframes) do
            local k = cam.intro[i]
            if type(k) == 'table' then
                out.camera.intro[#out.camera.intro + 1] = {
                    pos = xyz(k.pos), rot = { x = VMC.Round(num(type(k.rot) == 'table' and k.rot.x, 0, -360, 360), 3), y = VMC.Round(num(type(k.rot) == 'table' and k.rot.y, 0, -180, 180), 3), z = VMC.Round(num(type(k.rot) == 'table' and k.rot.z, 0, -720, 720), 3) },
                    fov = VMC.Round(num(k.fov, 40, 5, 130), 2),
                    duration = math.floor(num(k.duration, 2000, 0, 60000)),
                    hold = math.floor(num(k.hold, 0, 0, 30000)),
                    ease = VMC.Ease[k.ease or ''] and k.ease or 'easeInOutSine',
                    aim = math.floor(num(k.aim, 0, 0, ed.MaxSpots)), -- 0 = free camera, n = track spot n
                }
            end
        end
    end

    if type(s.spots) == 'table' then
        for i = 1, math.min(#s.spots, ed.MaxSpots) do
            local p = s.spots[i]
            if type(p) == 'table' then
                local pose = type(p.pose) == 'table' and p.pose or {}
                local spot = {
                    pos = xyz(p.pos),
                    heading = VMC.Round(num(p.heading, 0, -720, 720) % 360, 2),
                    pose = {
                        type = ({ none = 1, preset = 1, anim = 1, scenario = 1 })[pose.type or ''] and pose.type or 'none',
                        preset = str(pose.preset, 32),
                        dict = str(pose.dict, 96),
                        clip = str(pose.clip, 96),
                        flag = math.floor(num(pose.flag, 1, 0, 1000000)),
                        scenario = str(pose.scenario, 64),
                    },
                }
                if type(p.prop) == 'table' and str(p.prop.model, 64) then
                    spot.prop = {
                        model = str(p.prop.model, 64),
                        bone = math.floor(num(p.prop.bone, 57005, 0, 70000)),
                        offset = xyz(p.prop.offset),
                        rot = xyz(p.prop.rot),
                    }
                end
                if type(p.cam) == 'table' and type(p.cam.pos) == 'table' then
                    spot.cam = { pos = xyz(p.cam.pos), rot = xyz(p.cam.rot), fov = VMC.Round(num(p.cam.fov, 38, 5, 130), 2) }
                end
                out.spots[#out.spots + 1] = spot
            end
        end
    end

    if type(s.props) == 'table' then
        for i = 1, math.min(#s.props, ed.MaxProps) do
            local p = s.props[i]
            if type(p) == 'table' and str(p.model, 64) then
                out.props[#out.props + 1] = {
                    model = str(p.model, 64),
                    pos = xyz(p.pos),
                    rot = xyz(p.rot),
                    collision = p.collision ~= false,
                }
            end
        end
    end

    return out
end

-- Theme ---------------------------------------------------------------------------------
VMC.Fonts = { bigshoulders = true, oswald = true, bebas = true, playfair = true, rajdhani = true, cinzel = true }

local function hex(v, def)
    if type(v) == 'string' and v:match('^#%x%x%x%x%x%x$') then return v:upper() end
    return def
end

function VMC.SanitiseTheme(t, base)
    t = type(t) == 'table' and t or {}
    base = base or Config.Theme
    local logo = VMC.Str(t.logo, 300, '') or ''
    if logo ~= '' and not (logo:match('^https://') or logo:match('^img/[%w%-_%.]+$') or logo:match('^nui://')) then logo = base.logo or '' end
    return {
        preset = VMC.Str(t.preset, 24, 'custom'),
        accent = hex(t.accent, base.accent),
        surface = hex(t.surface, base.surface),
        text = hex(t.text, base.text),
        danger = hex(t.danger, base.danger),
        bar = hex(t.bar, base.bar),
        font = VMC.Fonts[t.font or ''] and t.font or base.font,
        logo = logo,
        logoSize = math.floor(VMC.Num(t.logoSize, base.logoSize, 24, 160)),
        showName = t.showName ~= false,
        letterbox = t.letterbox ~= false,
        frame = t.frame ~= false,
        vignette = VMC.Round(VMC.Num(t.vignette, base.vignette, 0, 1), 2),
        layout = t.layout == 'right' and 'right' or 'left',
        serverName = VMC.Str(t.serverName, 40, Config.UI.ServerName),
        tagline = VMC.Str(t.tagline, 80, Config.UI.Tagline),
        rev = math.floor(VMC.Num(t.rev, 0, 0, 2147483647)), -- bumps on every save, busts the logo cache
    }
end

-- Clothing --------------------------------------------------------------------------------
-- op-clothing is checked first because it "provides" illenium/qb-clothing/rcore names
VMC.ClothingOrder = { 'op-clothing', 'rcore_clothing', 'qs-appearance', 'illenium-appearance', 'fivem-appearance', 'qb-clothing', 'skinchanger' }

function VMC.DetectClothing()
    if Config.Clothing and Config.Clothing ~= 'auto' then return Config.Clothing end
    for _, r in ipairs(VMC.ClothingOrder) do
        if GetResourceState(r) == 'started' then return r end
    end
    return 'none'
end
