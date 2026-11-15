local CORS = {
    ['Access-Control-Allow-Origin']  = '*',
    ['Access-Control-Allow-Headers'] = 'Authorization, Content-Type',
    ['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS',
}

local function send(res, status, data, contentType)
    local headers = { ['Content-Type'] = contentType or 'application/json', ['X-Content-Type-Options'] = 'nosniff' }
    for k, v in pairs(CORS) do headers[k] = v end
    if contentType then
        headers['Cache-Control'] = contentType:find('^image/') and 'public, max-age=86400' or 'no-cache'
    else
        headers['Cache-Control'] = 'no-store'
    end
    res.writeHead(status, headers)
    res.send(contentType and data or json.encode(data or {}))
end

local function handle(req, res, rawBody)
    CreateThread(function()
        local path, query = Util.ParsePath(req.path or '/')
        local ctx = {
            method  = req.method,
            path    = path,
            query   = query,
            headers = req.headers or {},
            ip      = Util.IpOf(req.address),
            body    = Util.DecodeJson(rawBody),
        }
        local ok, status, data, contentType = pcall(Api.Handle, ctx)
        if not ok then
            print(('^1[vinewood_mdt_mobile] %s %s failed: %s^0'):format(ctx.method, ctx.path, status))
            return send(res, 500, { error = 'Server error. Check the server console.' })
        end
        send(res, status, data, contentType)
    end)
end

SetHttpHandler(function(req, res)
    if req.method == 'OPTIONS' then
        res.writeHead(204, CORS)
        return res.send('')
    end
    if req.method == 'POST' then
        req.setDataHandler(function(body) handle(req, res, body) end)
    else
        handle(req, res, nil)
    end
end)

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS vinewood_mdt_mobile_tokens (
            token      VARCHAR(64) PRIMARY KEY,
            citizenid  VARCHAR(64) NOT NULL,
            name       VARCHAR(100),
            device     VARCHAR(60),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_used  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (citizenid)
        )
    ]])
    Auth.Load()
    local port = GetConvar('netPort', '30120')
    print(('[vinewood_mdt_mobile] Ready. Website: http://<server-ip>:%s/%s/'):format(port, GetCurrentResourceName()))
end)

-- /mdtlink 123456  approves the sign-in code shown on the app or website
RegisterCommand(Config.Commands.link, function(src, args)
    if src == 0 then return end
    local player = Framework.GetPlayer(src)
    if not player then return end
    local code = tostring(args[1] or ''):gsub('%D', '')
    if #code ~= 6 then
        return Util.Notify(src, ('Open the MDT app or website, then type /%s followed by the 6-digit code it shows.')
            :format(Config.Commands.link), 'inform')
    end
    if GetResourceState(Config.MDTResource) ~= 'started' then
        return Util.Notify(src, 'The MDT isn’t running on this server.', 'error')
    end
    if not exports[Config.MDTResource]:MobileAccess(src) then
        return Util.Notify(src, 'You need MDT access to sign in. Check you’re on duty.', 'error')
    end
    local device, err = Auth.Approve(code, player)
    if not device then return Util.Notify(src, err, 'error') end
    print(('[vinewood_mdt_mobile] %s (%s) signed in on: %s'):format(player.name, player.citizenid, device))
    Util.Notify(src, ('Signed in on %s.'):format(device), 'success')
end, false)

RegisterCommand(Config.Commands.unlink, function(src)
    if src == 0 then return end
    local player = Framework.GetPlayer(src)
    if not player then return end
    local n = Auth.RevokeAll(player.citizenid)
    Util.Notify(src, n > 0 and ('Signed out %d device(s).'):format(n) or 'No devices are signed in on this character.', 'inform')
end, false)

-- Console: mdtmobile_revoke <citizenid>
RegisterCommand('mdtmobile_revoke', function(src, args)
    if src ~= 0 or not args[1] then return end
    print(('[vinewood_mdt_mobile] Revoked %d device(s) for %s'):format(Auth.RevokeAll(args[1]), args[1]))
end, true)

exports('RevokeAll', Auth.RevokeAll)
