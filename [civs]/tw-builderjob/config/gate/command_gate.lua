
if _G.__twCommandGateInstalled then return end -- double-wrap safety
_G.__twCommandGateInstalled = true

local ALLOW = {}

do
    local c = Config and Config.Command or {}
    ALLOW[c.jobReset or 'builderjobreset']         = true -- player: reset the job
    ALLOW[c.jobLeave or 'builderjobleave']         = true -- player: leave the lobby

    ALLOW['cranesite']    = true -- admin: place a site
    ALLOW['cranesites']   = true -- admin: list
    ALLOW['cranesitedel'] = true -- admin: delete
    ALLOW['cranesiteid']  = true -- admin: print my identifiers (for the whitelist)

    ALLOW['tw_bp'] = true -- admin: region 1 site / blueprint placer
    ALLOW['j12site'] = true -- admin: region 12 drop-off placer

    ALLOW[(Config.AdminPanel and Config.AdminPanel.command) or 'builderadmin'] = true

    ALLOW[c.settings or 'builderjobsettings'] = true -- visual detail / sync quality panel
    ALLOW[c.keys or 'keys']                  = true -- key binding panel (same menu)

    ALLOW['panelwall_wall_reset'] = true
end

local _RegisterCommand = RegisterCommand

local DESC = {
    builderjobreset = TL('cmd_job_reset', 'Reset the construction job'),
    builderjobleave = TL('cmd_job_leave', 'Leave the crew'),
    builderjobsettings = TL('cmd_jobsettings', 'Visual detail / sync quality panel'),
    keys          = TL('cmd_keys', 'Key binding panel'),
    tw_bp         = TL('bp_cmd_hint', 'Site tool - "go" = no menu, ORBIT/FREE camera (V), TAB = UI panel, ENTER = save'),
    cranesite     = TL('cmd_cranesite', 'Place a tower-crane panel site'),
    cranesites    = TL('cmd_cranesites', 'List the tower-crane panel sites'),
    cranesitedel  = TL('cmd_cranesitedel', 'Delete a tower-crane panel site'),
    cranesiteid   = TL('cmd_cranesiteid', 'Print my identifiers (for the site whitelist)'),

    step          = '<1-10> jump to a build phase (formwork, mesh, concrete, ...)',
    stepstatus    = 'Phase + fill dump of the current plank job',
    finishnow     = 'Finish the active job immediately',
    towercrane    = '[instance|off] spawn or clear the tower crane',
    towerjobstop  = 'Stop the tower-crane job',
    towersit      = 'Sit in the tower cabin',
    towerstand    = 'Leave the tower cabin',
    towercam      = 'Free camera around the tower cabin',
    towerseat     = 'Print the tower cabin seat diagnosis',
    towerskipto   = '<stage> jump to a tower-crane stage',
    cranev2       = 'Spawn the mobile crane',
    pumpv2        = 'Spawn the concrete pump',
    findcrane     = '<model> [radius] scan for a prop model nearby',
    slingui       = 'Open the sling tuner panel',
    slingpick     = 'Toggle the rope point picker',
    xox           = '[o|sling|stop] tic-tac-toe crane test scene',
    syncmachine   = '<0-8> how many machines animate at once (0 = unlimited)',
    keydebug      = 'Show the raw key-read diagnosis',
    training      = '[cranev2|pumpv2|tower] enter a training module',
    trainingexit  = 'Leave training mode',
    budget        = 'Frame-budget scheduler numbers',
    economymeasure = 'Measure the pay-per-minute of the active job',
    lodhud        = 'Toggle the machine LOD overlay',
    profiler      = '[dump] event/network profiler',
}

local IS_SERVER = (IsDuplicityVersion and IsDuplicityVersion()) and true or false
local suggestReady = false
local queued = {}

local function emitSuggestion(name)
    TriggerEvent('chat:addSuggestion', '/' .. name,
        DESC[name] or 'tw-builderjob command')
end

local function suggest(name)
    if IS_SERVER then return end
    if type(name) ~= 'string' or name:match('^[+-]') then return end
    if suggestReady then
        emitSuggestion(name)
    else
        queued[#queued + 1] = name
    end
end

if not IS_SERVER and CreateThread then
    CreateThread(function()
        Wait(2000) -- chat resource up, every script loaded
        suggestReady = true
        for _, n in ipairs(queued) do emitSuggestion(n) end
        queued = {}
    end)
end

local STASH = {}

local PROD      = {}   -- declared via RegisterKeyMapping: bound to a player key
local codeDepth = 0    -- > 0 while inside ExecuteCommand: code is calling, not a player
local adminCache       -- nil = unknown (ask again), true = confirmed admin

local evAdmin
local function adminEvent()
    if evAdmin then return evAdmin end
    if _event then
        evAdmin = _event('admin:check')
    elseif GetCurrentResourceName then
        evAdmin = GetCurrentResourceName() .. ':admin:check'
    end
    return evAdmin
end

local function say(src, msg)
    local line = { args = { 'tw-builderjob', msg } }
    if IS_SERVER then
        if src and src > 0 then TriggerClientEvent('chat:addMessage', src, line) end
    else
        TriggerEvent('chat:addMessage', line)
    end
end

local DENY = 'This is a debug command. Add your identifier to Config.Admins '
    .. '(run /cranesiteid to print it), or set Config.DebugCommands = false.'

local function isAdmin(src)
    if IS_SERVER then
        src = tonumber(src) or 0
        if src == 0 then return true end                   -- server console
        return (TwIsAdmin and TwIsAdmin(src)) and true or false
    end
    if adminCache then return true end
    if not TriggerServerCallback then return false end     -- not loaded yet
    local ev = adminEvent()
    if not ev then return false end
    local ok, res = pcall(TriggerServerCallback, ev)
    if not (ok and res) then return false end              -- error or denied: do not cache
    adminCache = true
    return true
end

local function passesAdminGate(name, src)
    if codeDepth > 0 then return true end                  -- called by code
    if ALLOW[name] or PROD[name] then return true end      -- production command
    if isAdmin(src) then return true end
    say(src, DENY)
    return false
end

local function wrapCb(name, cb)
    if type(cb) ~= 'function' then return cb end
    return function(...)
        if not passesAdminGate(name, ...) then return end
        _G.__twInCmd = (_G.__twInCmd or 0) + 1
        local ok, err = pcall(cb, ...)
        _G.__twInCmd = _G.__twInCmd - 1
        if not ok then error(err, 0) end
    end
end

function RegisterCommand(name, cb, restricted)
    cb = wrapCb(name, cb) -- STASH also gets the wrapped one: revive/ExecuteCommand paths covered
    if type(name) == 'string' and not ALLOW[name]
        and not (Config and Config.DebugCommands) then
        STASH[name] = { cb = cb, restricted = restricted }
        return -- not registered: not in chat, not in autocomplete
    end
    suggest(name)
    return _RegisterCommand(name, cb, restricted)
end

local function revive(name)
    local st = STASH[name]
    if not st then return false end
    STASH[name] = nil
    suggest(name)
    _RegisterCommand(name, st.cb, st.restricted)
    return true
end

if RegisterKeyMapping then -- client-only native
    local _RegisterKeyMapping = RegisterKeyMapping
    function RegisterKeyMapping(cmd, desc, mapper, key)
        if type(cmd) == 'string' then
            PROD[cmd] = true
            revive(cmd)
            local sign, base = cmd:match('^([+-])(.+)$')
            if sign then
                local other = (sign == '+' and '-' or '+') .. base
                PROD[other] = true
                revive(other)
            end
        end
        return _RegisterKeyMapping(cmd, desc, mapper, key)
    end
end

if ExecuteCommand then
    local _ExecuteCommand = ExecuteCommand
    function ExecuteCommand(str)
        local s = tostring(str or '')
        local name = s:match('^%s*(%S+)')
        local st = name and STASH[name]
        if st then
            local args = {}
            for w in s:gmatch('%S+') do args[#args + 1] = w end
            table.remove(args, 1)
            codeDepth = codeDepth + 1
            local ok, err = pcall(st.cb, 0, args, s)
            codeDepth = codeDepth - 1
            if not ok then print('^1[cmdgate] "' .. name .. '" error: ' .. tostring(err) .. '^7') end
            return
        end
        codeDepth = codeDepth + 1
        local ok2, err2 = pcall(_ExecuteCommand, str)
        codeDepth = codeDepth - 1
        if not ok2 then error(err2, 0) end
    end
end
