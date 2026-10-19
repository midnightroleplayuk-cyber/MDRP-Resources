-- ============================================================
-- APEX ADMIN — INSTALL DOCTOR
-- ------------------------------------------------------------
-- Almost every support ticket for this resource is one of a small
-- number of INSTALL faults, not a code fault:
--
--   • ox_lib / oxmysql started AFTER apex_adminmenu  → "won't start"
--   • the SQL never imported                          → empty panel
--   • Config.Commands gives one name to two commands  → one of them never
--                                                        answers
--   • apex_panel_url set without apex_panel_key       → silent relay
--   • the resource folder renamed or double-nested    → "Could not open
--                                                        resource metadata
--                                                        file"
--
-- Each of those looks identical from the outside: the menu doesn't open.
-- This file answers "which one is it?" from inside the server, so the
-- answer arrives with the bug report instead of after three round trips.
--
--   apexdoctor        full report, server console only
--
-- A short warning banner is also printed on start-up, but ONLY when
-- something is actually wrong. A healthy server stays silent.
-- ============================================================

local RESOURCE = GetCurrentResourceName()

--[[ WHICH COMMANDS ARE OURS, read from the config instead of written down.

     The list used to be four literal names ('admin', 'adminpanel', 'noclip',
     'report'). That ignored a renamed command, a disabled one and every alias,
     and it left out /ban, /kick, /searchinv, /clearinv and /skinmenu, so it
     could both miss a real overlap and report one for a command this server
     had switched off. ]]
local CONFIGURABLE = { 'Ban', 'Kick', 'NoClip', 'SearchInv', 'ClearInv', 'SkinMenu' }

--- name → the Config.Commands key that claims it. A second return lists the
--- names this config claims TWICE, which is the one conflict that really is
--- a mistake: two entries of ours fighting each other.
local function ownedCommands()
    local owned, clashes = {}, {}
    local function claim(name, key)
        if type(name) ~= 'string' or name == '' then return end
        name = name:lower()
        if owned[name] and owned[name] ~= key then
            clashes[#clashes + 1] = ('/%s (%s and %s)'):format(name, owned[name], key)
        else
            owned[name] = key
        end
    end
    local cmds = (Config and Config.Commands) or {}
    for _, key in ipairs({ 'AdminPanel', 'AdminMenu' }) do
        local def = cmds[key]
        if type(def) == 'table' and def.enabled ~= false then
            claim(def.command, key)
            for _, alias in ipairs(def.aliases or {}) do claim(alias, key) end
        end
    end
    for _, key in ipairs(CONFIGURABLE) do
        local def = cmds[key]
        if type(def) == 'table' and def.enabled then claim(def.command, key) end
    end
    claim('report', 'reports'); claim('reports', 'reports'); claim('reportmode', 'reports')
    return owned, clashes
end

-- A framework is not "another admin menu". ESX Legacy, QBCore and Qbox all
-- ship staff commands of their own (/noclip, /kick, /ban), and telling an
-- owner to stop or rename the resource their whole server runs on is advice
-- nobody can follow.
local FRAMEWORKS = {
    es_extended = 'ESX', ['qb-core'] = 'QBCore', qbx_core = 'Qbox', ox_core = 'ox_core', ND_Core = 'ND Core',
}

local function started(res)
    return GetResourceState(res) == 'started'
end

-- ── Individual checks ───────────────────────────────────────
-- Each returns: ok(boolean|nil), headline, detail|nil
-- ok == nil means "not applicable / informational".

local function checkFolderName()
    if RESOURCE == 'apex_adminmenu' then
        return true, 'folder name        : apex_adminmenu'
    end
    return false,
        ('folder name        : "%s" (expected apex_adminmenu)'):format(RESOURCE),
        'Renaming the folder breaks every server.cfg line, ACE and doc that '
     .. 'names the resource. Rename it back to apex_adminmenu.'
end

local function checkOxLib()
    if not started('ox_lib') then
        return false, 'ox_lib             : NOT STARTED',
            'fxmanifest pulls in @ox_lib/init.lua, so nothing in this resource '
         .. 'can run without it. Put `ensure ox_lib` in server.cfg ABOVE the '
         .. 'line that starts apex_adminmenu.'
    end
    if type(lib) ~= 'table' then
        return false, 'ox_lib             : started, but `lib` is missing',
            'ox_lib is running but did not export its Lua API. That is usually a '
         .. 'half-extracted or outdated ox_lib — reinstall the latest release.'
    end
    return true, 'ox_lib             : ok'
end

local function checkOxMysql()
    if not started('oxmysql') then
        return false, 'oxmysql            : NOT STARTED',
            'Staff, bans, warnings, jails, logs and blips all live in MySQL. '
         .. 'Put `ensure oxmysql` in server.cfg ABOVE apex_adminmenu.'
    end
    if type(MySQL) ~= 'table' then
        return false, 'oxmysql            : started, but MySQL is missing', nil
    end
    -- Started is not the same as connected: a wrong mysql_connection_string
    -- leaves oxmysql up and every query failing.
    local ok = pcall(function() return MySQL.scalar.await('SELECT 1') end)
    if not ok then
        return false, 'oxmysql            : started but NOT CONNECTED',
            'oxmysql is running and `SELECT 1` still fails — check '
         .. 'set mysql_connection_string in server.cfg.'
    end
    return true, 'oxmysql            : ok (connected)'
end

local function checkSchema()
    if type(MySQL) ~= 'table' then return nil, 'schema             : skipped (no oxmysql)' end

    local required = {
        'apex_staff', 'apex_staff_groups', 'apex_staff_log',
        'apex_bans', 'apex_warnings'
    }
    local missing = {}
    for _, t in ipairs(required) do
        local ok, n = pcall(function()
            return MySQL.scalar.await(
                'SELECT COUNT(*) FROM information_schema.tables '
             .. 'WHERE table_schema = DATABASE() AND table_name = ?', { t })
        end)
        if not ok or (n or 0) == 0 then missing[#missing + 1] = t end
    end

    if #missing > 0 then
        return false,
            ('schema             : %d table(s) MISSING'):format(#missing),
            ('Missing: %s. The auto-installer runs install_admin_panel.sql on '
          .. 'start-up; if tables are still absent the DB user has no CREATE '
          .. 'right, or the import failed. Import install_admin_panel.sql and '
          .. 'install_me.sql by hand.'):format(table.concat(missing, ', '))
    end
    return true, 'schema             : ok'
end

local function checkFramework()
    if Framework == 'esx' then return true, 'framework          : ESX' end
    if Framework == 'qb' then
        return true, ('framework          : %s'):format(IsQBox and 'QBox (qbx_core)' or 'QBCore')
    end
    return false, 'framework          : NONE DETECTED',
        'No bridge attached. The bridges look for es_extended, qb-core or '
     .. 'qbx_core to be STARTED — if your framework starts after this resource, '
     .. 'move its ensure line above apex_adminmenu.'
end

--[[ COMMAND OVERLAPS: reported, explained, and no longer an "install problem".

     This check used to FAIL the install whenever any other resource had a
     server-side command called /admin, /adminpanel, /noclip or /report, and
     told the owner to "stop or rename the other admin menu". On every current
     ESX Legacy server the "other admin menu" was es_extended, whose built-in
     /noclip tripped it: a red banner on every boot, about something the owner
     could not act on and that was not what the banner said it was.

     What it can actually see is the SERVER's command registry. Every command
     this resource offers is registered on the CLIENT (the menu commands always
     were, the six configurable ones since 2.2.10), and a client resolves its
     own commands before it forwards anything to the server. So a same-named
     server-side command elsewhere does not take ours over: players typing it
     get the Apex one. That is an overlap worth knowing about, with the way to
     hand the name back, and it is not a fault.

     The one thing here that IS a fault is the config claiming the same name
     twice, and that still fails. ]]
local function checkCommandConflicts()
    local owned, clashes = ownedCommands()

    if #clashes > 0 then
        return false,
            ('command names      : %d used twice in Config.Commands'):format(#clashes),
            ('The same name is given to two commands of this resource: %s. Only '
          .. 'one of them can answer. Give each entry in Config.Commands its own '
          .. 'name (check the aliases too).'):format(table.concat(clashes, ', '))
    end

    if type(GetRegisteredCommands) ~= 'function' then
        return nil, 'command overlaps   : cannot check on this build'
    end

    local seen, lines, fromFramework, fromOthers = {}, {}, 0, 0
    for _, c in ipairs(GetRegisteredCommands() or {}) do
        local name = type(c.name) == 'string' and c.name:lower() or nil
        local res = c.resource
        if name and owned[name] and type(res) == 'string' and res ~= RESOURCE and not seen[name .. '|' .. res] then
            seen[name .. '|' .. res] = true
            local fw = FRAMEWORKS[res]
            if fw then
                fromFramework = fromFramework + 1
                lines[#lines + 1] = ('/%s is also a built-in command of %s (%s).'):format(name, res, fw)
            else
                fromOthers = fromOthers + 1
                lines[#lines + 1] = ('/%s is also registered by %s.'):format(name, res)
            end
        end
    end

    if #lines == 0 then
        return true, 'command overlaps   : none'
    end

    local detail = table.concat(lines, ' ')
        .. ' Nothing to fix: players who type it get the Apex command, because this resource '
        .. 'registers its commands on the client and a client resolves its own commands before '
        .. 'anything reaches the server. To hand a name back to the other resource, set '
        .. 'enabled = false for that command in Config.Commands (or give it another name there).'
    if fromOthers > 0 then
        detail = detail .. ' If the other resource is a second admin menu, running two side by '
            .. 'side still means two sets of keys and two permission systems: stopping it is the '
            .. 'tidy option, not a requirement.'
    end
    -- nil = informational. It is printed by apexdoctor and never counted as a
    -- problem, so it cannot raise the start-up banner.
    return nil, ('command overlaps   : %d, handled (nothing to fix)'):format(#lines), detail
end

local function checkWebPanel()
    local url = GetConvar('apex_panel_url', '')
    local key = GetConvar('apex_panel_key', '')
    if url == '' and key == '' then
        return nil, 'web panel          : disabled (no convars set)'
    end
    if url == '' or key == '' then
        return false, 'web panel          : HALF CONFIGURED',
            'Both apex_panel_url AND apex_panel_key must be set or the relay '
         .. 'stays off without saying so. apex_panel_url is the address you open '
         .. 'the web panel at in the browser (https://...); apex_panel_key is the '
         .. 'server key on the panel\'s Setup tab.'
    end
    local problem = PanelUrlProblem and PanelUrlProblem(url)
    if problem then
        return false, ('web panel          : URL LOOKS WRONG (%s)'):format(url),
            'apex_panel_url ' .. problem .. ' Then run `apexpaneltest`.'
    end
    return true, ('web panel          : configured (%s)'):format(url)
end

local function checkScreenshot()
    if started('screenshot-basic') then
        return true, 'screenshot-basic   : ok'
    end
    return nil, 'screenshot-basic   : not installed (optional)',
        'Report screenshots and staff face shots are unavailable without it, '
     .. 'and Watch screen loses its fallback. Everything else works.'
end

local function checkStaffResolution()
    local total, resolved = 0, 0
    for _, p in ipairs(GetPlayers() or {}) do
        local src = tonumber(p)
        if src then
            total = total + 1
            if PanelGetGroup and select(1, PanelGetGroup(src)) then
                resolved = resolved + 1
            end
        end
    end
    if total == 0 then
        return nil, 'staff resolution   : nobody online to test'
    end
    if resolved == 0 then
        return false,
            ('staff resolution   : 0 of %d online players resolve to a group'):format(total),
            'Nobody online is recognised as staff. Run `apexwho <id>` for the '
         .. 'full permission chain of one player.'
    end
    return true, ('staff resolution   : %d of %d online players are staff'):format(resolved, total)
end

local CHECKS = {
    checkFolderName, checkOxLib, checkOxMysql, checkSchema, checkFramework,
    checkCommandConflicts, checkWebPanel, checkScreenshot, checkStaffResolution
}

--- Run every check.
--- @return table results, integer problems
local function runChecks()
    local results, problems = {}, 0
    for _, fn in ipairs(CHECKS) do
        local ok, headline, detail = fn()
        results[#results + 1] = { ok = ok, headline = headline, detail = detail }
        if ok == false then problems = problems + 1 end
    end
    return results, problems
end

-- ── Report ──────────────────────────────────────────────────

RegisterCommand('apexdoctor', function(src)
    if src ~= 0 then return end   -- server console only
    -- Several checks use MySQL.*.await, which needs a coroutine. A command
    -- handler is not guaranteed to be one.
    CreateThread(function() ApexDoctorReport() end)
end, true)

function ApexDoctorReport()
    local results, problems = runChecks()

    -- The border is drawn from box characters, which are multi-byte, so the
    -- padding width is counted in CHARACTERS here and the format width is
    -- the ASCII part only.
    local bar = string.rep('═', 62)
    print(('^5╔%s╗^0'):format(bar))
    print(('^5║ apex_adminmenu %-45s ║^0'):format(
        'v' .. (GetResourceMetadata(RESOURCE, 'version', 0) or '?')))
    print(('^5╚%s╝^0'):format(bar))

    for _, r in ipairs(results) do
        local mark = (r.ok == true and '^2 OK  ^0')
                  or (r.ok == false and '^1FAIL ^0')
                  or '^3 --  ^0'
        print(('%s %s'):format(mark, r.headline))
        if r.detail and r.ok ~= true then
            -- Wrap by hand: the console does not, and a 200-character advice
            -- line scrolled off the right edge of txAdmin's console is advice
            -- nobody reads.
            local line = ''
            for word in r.detail:gmatch('%S+') do
                if #line + #word + 1 > 62 then
                    print(('       ^7%s^0'):format(line))
                    line = word
                else
                    line = (line == '') and word or (line .. ' ' .. word)
                end
            end
            if line ~= '' then print(('       ^7%s^0'):format(line)) end
        end
    end

    print('')
    if problems == 0 then
        print('^2[apexdoctor] No install problems found.^0')
    else
        print(('^1[apexdoctor] %d problem(s) above need fixing.^0'):format(problems))
    end

    -- This one cannot be detected from inside the resource: if the folder is
    -- double-nested the server never loads any of this code. Say it anyway,
    -- because anyone running apexdoctor is already debugging an install.
    print('')
    print('^3If the server says "Could not open resource metadata file", this^0')
    print('^3resource never started and none of the checks above ran. That^0')
    print('^3error means fxmanifest.lua is not DIRECTLY inside the folder —^0')
    print('^3almost always apex_adminmenu/apex_adminmenu/fxmanifest.lua after^0')
    print('^3a Windows "Extract All". Move the inner folder up one level.^0')
end

-- ── Start-up banner ─────────────────────────────────────────
-- Only speaks when something is wrong. A healthy install prints nothing,
-- because a resource that congratulates itself on every boot is just more
-- noise in a console that already has too much.
CreateThread(function()
    -- After the schema auto-installer (Wait(2000) + statements) and after
    -- the frameworks have had time to attach.
    local guard = 0
    while not PanelSchemaReady and guard < 50 do Wait(200); guard = guard + 1 end
    Wait(3000)

    -- Always, problems or not: which build this server is running. "I
    -- updated and nothing changed" starts with this line.
    print(('^2[apex_adminmenu] v%s started^7 - `apexdoctor` prints the install report, `apexstaffdiag` the Staff page.')
        :format(GetResourceMetadata(RESOURCE, 'version', 0) or '?'))

    local results, problems = runChecks()
    if problems == 0 then return end

    print('^1┌──────────────────────────────────────────────────────────────^0')
    print(('^1│ apex_adminmenu: %d install problem(s) detected^0'):format(problems))
    for _, r in ipairs(results) do
        if r.ok == false then
            print(('^1│  • %s^0'):format(r.headline))
        end
    end
    print('^1│ Run `apexdoctor` in this console for the full report.^0')
    print('^1└──────────────────────────────────────────────────────────────^0')
end)
