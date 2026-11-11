-- Links that can be played on courtroom screens. Left unencrypted: add your own sites here.
--
-- Each provider has:
--   id, label         shown in the system ("YouTube", "Streamable"...)
--   match(url, host)  return what to play, or nil if the link isn't theirs:
--     { kind = 'embed', src = 'https://...' }   the site's own player in a frame
--     { kind = 'file',  src = 'https://...mp4' } a video file: synced for everyone, volume fades with distance
--     { kind = 'image', src = 'https://...png' } a photo or screenshot
--   Optional in the result:
--     fallback = 'https://...png'   (file only) shown as an image if the video won't load
--     offset = seconds    start this far in (from a timestamp in the link)
--     control = 'youtube' | 'vimeo'   the player accepts volume commands
--   In an embed src, {start} is replaced with the seconds to start from when someone walks in
--   (the link's timestamp plus however long the exhibit has been playing).
VideoLinks = {}

local CR = Config.Courtrooms or {}
local P = CR.Providers or {}
local RES_HOST = ('cfx-nui-%s'):format(GetCurrentResourceName())

local function on(id) return P[id] ~= false end

--- '90', '90s', '1m30s', '1h2m3s' -> seconds
local function seconds(t)
    if not t then return 0 end
    t = tostring(t)
    if t:match('^%d+$') then return tonumber(t) end
    local h, m, s = t:match('(%d+)h'), t:match('(%d+)m'), t:match('(%d+)s')
    return (tonumber(h) or 0) * 3600 + (tonumber(m) or 0) * 60 + (tonumber(s) or 0)
end

local function query(url, key) return url:match('[?&#]' .. key .. '=([^&#]+)') end
local function path(url) return url:match('^https?://[^/]+(/[^?#]*)') or '/' end

local function ext(url)
    local f = (url:match('^[^?#]+') or ''):lower()
    if f:match('%.mp4$') or f:match('%.webm$') or f:match('%.mov$') or f:match('%.m4v$') then return 'video' end
    if f:match('%.png$') or f:match('%.jpe?g$') or f:match('%.webp$') or f:match('%.gif$') then return 'image' end
end

local function hostIn(host, list)
    for _, h in ipairs(list or {}) do
        h = h:lower()
        if host == h or host:sub(-(#h + 1)) == '.' .. h then return true end
    end
    return false
end

VideoLinks.Providers = {
    {
        id = 'medal', label = 'Medal',
        match = function(url, host)
            if host ~= 'medal.tv' and host ~= 'www.medal.tv' then return end
            -- /clip/<id>, /clips/<id>, /games/<game>/clips/<id>, /<lang>/games/<game>/clips/<id>, /users/<u>/clips/<id>, plus an optional /<key>
            local id, key = path(url):match('/clips?/([%w_-]+)/?([%w_-]*)')
            if not id then return nil, 'That does not look like a Medal clip link.' end
            if key == '' then key = nil end
            return { kind = 'embed', src = ('https://medal.tv/clip/%s%s?autoplay=1&muted=0&loop=0&cta=0'):format(id, key and ('/' .. key) or '') }
        end,
    },
    {
        id = 'youtube', label = 'YouTube',
        match = function(url, host)
            if not (host == 'youtube.com' or host == 'www.youtube.com' or host == 'm.youtube.com' or host == 'youtu.be' or host == 'www.youtube-nocookie.com') then return end
            local id = query(url, 'v') or url:match('youtu%.be/([%w_-]+)') or url:match('/shorts/([%w_-]+)')
                or url:match('/embed/([%w_-]+)') or url:match('/live/([%w_-]+)')
            if not id then return nil, 'That does not look like a YouTube video link.' end
            return {
                kind = 'embed', control = 'youtube', offset = seconds(query(url, 't') or query(url, 'start')),
                src = ('https://www.youtube.com/embed/%s?autoplay=1&controls=0&rel=0&modestbranding=1&playsinline=1&enablejsapi=1&start={start}'):format(id),
            }
        end,
    },
    {
        id = 'twitch', label = 'Twitch',
        match = function(url, host)
            local parent = RES_HOST
            if host == 'clips.twitch.tv' then
                local slug = path(url):match('^/([%w_-]+)')
                if slug and slug ~= 'embed' then return { kind = 'embed', src = ('https://clips.twitch.tv/embed?clip=%s&parent=%s&autoplay=true&muted=false'):format(slug, parent) } end
                local q = query(url, 'clip')
                if q then return { kind = 'embed', src = ('https://clips.twitch.tv/embed?clip=%s&parent=%s&autoplay=true&muted=false'):format(q, parent) } end
            elseif host == 'twitch.tv' or host == 'www.twitch.tv' or host == 'm.twitch.tv' then
                local slug = path(url):match('/clip/([%w_-]+)')
                if slug then return { kind = 'embed', src = ('https://clips.twitch.tv/embed?clip=%s&parent=%s&autoplay=true&muted=false'):format(slug, parent) } end
                local vod = path(url):match('^/videos/(%d+)')
                if vod then
                    return { kind = 'embed', offset = seconds(query(url, 't')),
                        src = ('https://player.twitch.tv/?video=v%s&parent=%s&autoplay=true&muted=false&time={start}s'):format(vod, parent) }
                end
                return nil, 'Use a Twitch clip or a past broadcast (videos) link.'
            end
        end,
    },
    {
        id = 'streamable', label = 'Streamable',
        match = function(url, host)
            if host ~= 'streamable.com' and host ~= 'www.streamable.com' then return end
            local id = path(url):match('^/e/([%w]+)') or path(url):match('^/([%w]+)')
            if not id then return nil, 'That does not look like a Streamable link.' end
            return { kind = 'embed', src = ('https://streamable.com/e/%s?autoplay=1&nocontrols=1'):format(id) }
        end,
    },
    {
        id = 'vimeo', label = 'Vimeo',
        match = function(url, host)
            if host ~= 'vimeo.com' and host ~= 'www.vimeo.com' and host ~= 'player.vimeo.com' then return end
            local id, hash = path(url):match('/(%d+)/?([%w]*)')
            if not id then return nil, 'That does not look like a Vimeo video link.' end
            local h = query(url, 'h') or (hash ~= '' and hash or nil)
            return { kind = 'embed', control = 'vimeo', offset = seconds(url:match('#t=([%dhms]+)')),
                src = ('https://player.vimeo.com/video/%s?autoplay=1&controls=0&title=0&byline=0&portrait=0%s#t={start}s'):format(id, h and ('&h=' .. h) or '') }
        end,
    },
    {
        id = 'dailymotion', label = 'Dailymotion',
        match = function(url, host)
            local id
            if host == 'dai.ly' then id = path(url):match('^/([%w]+)')
            elseif host == 'dailymotion.com' or host == 'www.dailymotion.com' then id = path(url):match('/video/([%w]+)') end
            if host ~= 'dai.ly' and host ~= 'dailymotion.com' and host ~= 'www.dailymotion.com' then return end
            if not id then return nil, 'That does not look like a Dailymotion video link.' end
            return { kind = 'embed', offset = seconds(query(url, 'start')),
                src = ('https://www.dailymotion.com/embed/video/%s?autoplay=1&controls=0&start={start}'):format(id) }
        end,
    },
    {
        id = 'tiktok', label = 'TikTok',
        match = function(url, host)
            if host == 'vm.tiktok.com' or host == 'vt.tiktok.com' then
                return nil, 'Open the TikTok in a browser and copy the full link (tiktok.com/@user/video/...). Short links will not work.'
            end
            if host ~= 'tiktok.com' and host ~= 'www.tiktok.com' and host ~= 'm.tiktok.com' then return end
            local id = path(url):match('/video/(%d+)') or path(url):match('/embed/v2/(%d+)')
            if not id then return nil, 'Use the full TikTok video link (tiktok.com/@user/video/...). Short vm.tiktok.com links will not work.' end
            return { kind = 'embed', src = ('https://www.tiktok.com/embed/v2/%s?autoplay=1'):format(id) }
        end,
    },
    {
        id = 'gdrive', label = 'Google Drive',
        match = function(url, host)
            if host ~= 'drive.google.com' then return end
            local id = path(url):match('/file/d/([%w_-]+)') or query(url, 'id')
            if not id then return nil, 'Use a Google Drive file share link, set to "Anyone with the link".' end
            return { kind = 'embed', src = ('https://drive.google.com/file/d/%s/preview'):format(id) }
        end,
    },
    {
        id = 'dropbox', label = 'Dropbox',
        match = function(url, host)
            if host ~= 'dropbox.com' and host ~= 'www.dropbox.com' and host ~= 'dl.dropboxusercontent.com' then return end
            local kind = ext(url)
            if not kind then return nil, 'Use a Dropbox link to a video or image file.' end
            -- raw=1 serves the file itself instead of the Dropbox preview page.
            local direct = url:gsub('[?&]dl=%d', ''):gsub('[?&]raw=%d', '')
            direct = direct .. (direct:find('?', 1, true) and '&' or '?') .. 'raw=1'
            return { kind = kind == 'video' and 'file' or 'image', src = direct }
        end,
    },
    {
        id = 'imgur', label = 'Imgur',
        match = function(url, host)
            if host ~= 'imgur.com' and host ~= 'www.imgur.com' and host ~= 'i.imgur.com' then return end
            local id, e = path(url):match('^/([%w]+)%.?(%w*)$')
            if not id or id == 'a' or id == 'gallery' then return nil, 'Use a link to a single Imgur image or video (not an album).' end
            e = (e or ''):lower()
            if e == 'mp4' or e == 'gifv' or e == 'webm' then return { kind = 'file', src = ('https://i.imgur.com/%s.mp4'):format(id) } end
            if e == '' then return { kind = 'image', src = ('https://i.imgur.com/%s.png'):format(id) } end
            return { kind = 'image', src = ('https://i.imgur.com/%s.%s'):format(id, e) }
        end,
    },
    {
        id = 'gyazo', label = 'Gyazo',
        match = function(url, host)
            if host ~= 'gyazo.com' and host ~= 'i.gyazo.com' then return end
            local id, e = path(url):match('^/([%x]+)%.?(%w*)$')
            if not id then return nil, 'That does not look like a Gyazo link.' end
            e = (e or ''):lower()
            if e == 'png' or e == 'jpg' or e == 'gif' then return { kind = 'image', src = ('https://i.gyazo.com/%s.%s'):format(id, e) } end
            -- A plain Gyazo link could be either: try the video, fall back to the image.
            return { kind = 'file', src = ('https://i.gyazo.com/%s.mp4'):format(id), fallback = ('https://i.gyazo.com/%s.png'):format(id) }
        end,
    },
    {
        -- Direct links to a video or image file on a host in VideoHosts (or any host if AllowAnyVideoHost).
        id = 'file', label = 'File',
        match = function(url, host)
            local kind = ext(url)
            if not kind then return end
            if not (CR.AllowAnyVideoHost or hostIn(host, CR.VideoHosts)) then
                return nil, ('Files from %s are not allowed. Upload it to Medal, YouTube, Streamable or an allowed host.'):format(host)
            end
            return { kind = kind == 'video' and 'file' or 'image', src = url }
        end,
    },
}

--- What to play for a link: { kind, src, provider, providerLabel, offset, control } or nil, reason.
function VideoLinks.Parse(url)
    url = type(url) == 'string' and url:gsub('^%s+', ''):gsub('%s+$', '') or nil
    if not url or url == '' then return nil, 'Paste a link to the footage.' end
    if #url > 500 then return nil, 'That link is too long.' end
    if not url:match('^https://') then return nil, 'The link must start with https://' end
    local host = (url:match('^https://([^/:?#]+)') or ''):lower()
    for _, p in ipairs(VideoLinks.Providers) do
        if p.id == 'file' or on(p.id) then
            local r, err = p.match(url, host)
            if r then
                if r.kind == 'image' and P.images == false then return nil, 'Images are switched off on this server.' end
                r.provider, r.providerLabel, r.offset = p.id, p.label, r.offset or 0
                return r
            end
            if err then return nil, err end
        end
    end
    return nil, 'That link is not supported. Try ' .. VideoLinks.Names() .. '.'
end

--- "Medal, YouTube, Twitch..." for hints.
function VideoLinks.Names()
    local out = {}
    for _, p in ipairs(VideoLinks.Providers) do
        if p.id ~= 'file' and on(p.id) then out[#out + 1] = p.label end
    end
    out[#out + 1] = 'a direct video or image file'
    return table.concat(out, ', ')
end
