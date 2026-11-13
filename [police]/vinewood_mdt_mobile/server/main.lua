local CORS = {
    ['Access-Control-Allow-Origin']  = '*',
    ['Access-Control-Allow-Headers'] = 'Authorization, Content-Type',
    ['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS',
}

local function send(res, status, data)
    local headers = { ['Content-Type'] = 'application/json' }
    for k, v in pairs(CORS) do headers[k] = v end
    res.writeHead(status, headers)
    res.send(json.encode(data or {}))
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
        local ok, status, data = pcall(Api.Handle, ctx)
        if not ok then
            print(('^1[vinewood_mdt_mobile] %s %s failed: %s^0'):format(ctx.method, ctx.path, status))
            return send(res, 500, { error = 'Server error. Check the server console.' })
        end
        send(res, status, data)
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

-- Database ---------------------------------------------------------------

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
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS vinewood_mdt_mobile_bolos (
            id          INT AUTO_INCREMENT PRIMARY KEY,
            kind        VARCHAR(10) NOT NULL DEFAULT 'person',
            title       VARCHAR(80) NOT NULL,
            details     TEXT,
            plate       VARCHAR(10),
            created_by  VARCHAR(120),
            created_cid VARCHAR(64),
            active      TINYINT(1) NOT NULL DEFAULT 1,
            created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS vinewood_mdt_mobile_audit (
            id         INT AUTO_INCREMENT PRIMARY KEY,
            citizenid  VARCHAR(64),
            name       VARCHAR(100),
            action     VARCHAR(32),
            detail     VARCHAR(200),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (citizenid)
        )
    ]])
    Auth.Load()
    print(('[vinewood_mdt_mobile] API ready at http://<server-ip>:%s/%s/api'):format(
        GetConvar('netPort', '30120'), GetCurrentResourceName()))
end)

-- Commands ---------------------------------------------------------------

RegisterCommand(Config.Commands.link, function(src)
    if src == 0 then return end
    local o = Framework.GetPlayer(src)
    if not o or not o.isPolice then
        return Util.Notify(src, 'Only police can link the MDT app.', 'error')
    end
    local code = Auth.CreateCode(o)
    Util.Notify(src, ('Your pairing code is %s. Enter it in the MDT app within %d seconds.')
        :format(code, Config.Pairing.codeLifetime), 'success')
end, false)

RegisterCommand(Config.Commands.unlink, function(src)
    if src == 0 then return end
    local o = Framework.GetPlayer(src)
    if not o then return end
    local n = Auth.RevokeAll(o.citizenid)
    Util.Notify(src, n > 0 and ('Signed out %d phone(s).'):format(n) or 'No phones are linked to this character.', 'inform')
end, false)

-- Server owners can sign anyone out from the console: mdtmobile_revoke <citizenid>
RegisterCommand('mdtmobile_revoke', function(src, args)
    if src ~= 0 or not args[1] then return end
    print(('[vinewood_mdt_mobile] Revoked %d phone(s) for %s'):format(Auth.RevokeAll(args[1]), args[1]))
end, true)

exports('RevokeAll', Auth.RevokeAll)
