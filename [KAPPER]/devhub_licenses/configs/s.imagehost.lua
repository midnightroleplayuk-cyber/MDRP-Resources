-- ============================================================================
--  License avatar photo hosting.
-- ----------------------------------------------------------------------------
--  TIP: Do NOT use a raw Discord webhook here. Discord's CDN links now expire,
--  so after a while every license photo will turn into a broken image.
--
--  RECOMMENDED: use https://uploadhub.gg - it hands you a Discord-format webhook
--  URL but hosts the images permanently (links never expire). Setup:
--    1. Visit https://uploadhub.gg
--    2. Log in
--    3. Create a new project
--    4. Open the "Webhook" tab and generate a new webhook with format "Discord"
--    5. Copy that webhook URL and paste it into the `webhook` field below
-- ============================================================================
Config.AvatarUpload = {
    -- "webhook" | "custom"
    provider = "webhook",

    -- Webhook URL (Discord format). Use an https://uploadhub.gg webhook - a raw
    -- Only used when provider = "webhook".
    -- https://devhub.gg/docs/id-card-and-license/avatar-photo-hosting
    webhook = "WEBHOOK_URL_HERE",
}

-- ============================================================================
--  Custom host - only used when provider = "custom".  (any provider value that
--  is not "webhook" routes here, so this is your fallback hosting path.)
-- ----------------------------------------------------------------------------
--  Upload the image wherever you like, then call resolve(publicUrl) with the
--  public URL - or resolve(nil) if it failed. The upload can be async: just 
--  call resolve() whenever you're done.
--
--  @param source  number  Server id of the player the photo belongs to
--  @param base64  string  Raw base64 image data (no "data:" prefix)
--  @param format  string  Image format/extension: "jpg" | "png" | "webp"
--  @param resolve fun(url: string|nil)
--
--  Example - imgur (pseudo, needs your own Client-ID):
--    PerformHttpRequest("https://api.imgur.com/3/image", function(status, body)
--        local ok, res = pcall(json.decode, body)
--        resolve(ok and res and res.data and res.data.link or nil)
--    end, "POST", json.encode({ image = base64, type = "base64" }), {
--        ["Authorization"] = "Client-ID YOUR_CLIENT_ID",
--        ["Content-Type"]  = "application/json",
--    })
-- ============================================================================
function UploadAvatarImage(source, base64, format, resolve)
    resolve(nil)
end
