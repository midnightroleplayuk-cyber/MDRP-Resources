-- ============================================================
-- Auto-installer for the admin panel schema.
-- Runs on resource start, executes every CREATE TABLE statement
-- in the bundled .sql files so administrators don't need to
-- import the SQL manually. Idempotent (uses IF NOT EXISTS).
--
-- Sets the global `PanelSchemaReady` flag once the tables exist so
-- early start-up DB writes (event logs, avatar cache warm) can hold
-- off until the schema is in place — otherwise they fire before this
-- thread runs and oxmysql spams "table doesn't exist".
-- ============================================================

PanelSchemaReady = false

-- Split a SQL script into individual statements. A naive "strip -- and
-- split on ;" breaks the moment a value contains a ';', '--', '#' or a
-- quote (e.g. the JSON permission arrays / '#1F5EFF' colours we seed).
-- This char-walker tracks string state ('...', "...", `...`) so a comment
-- or semicolon INSIDE a value is never mistaken for a delimiter, and it
-- strips both `-- line` / `# line` and `/* block */` comments. The result:
-- the auto-install is framework-independent (pure oxmysql) AND bulletproof
-- for any statement these .sql files hold now or later.
local function splitStatements(sql)
    local statements, buf = {}, {}
    local i, n = 1, #sql
    local inS, inD, inB = false, false, false  -- single / double / backtick

    local function flush()
        local stmt = table.concat(buf):gsub('^%s+', ''):gsub('%s+$', '')
        if stmt ~= '' then statements[#statements + 1] = stmt end
        buf = {}
    end

    while i <= n do
        local c  = sql:sub(i, i)
        local c2 = sql:sub(i, i + 1)

        if inS then
            buf[#buf + 1] = c
            if c == '\\' then
                buf[#buf + 1] = sql:sub(i + 1, i + 1); i = i + 1
            elseif c == "'" then
                if sql:sub(i + 1, i + 1) == "'" then buf[#buf + 1] = "'"; i = i + 1
                else inS = false end
            end
        elseif inD then
            buf[#buf + 1] = c
            if c == '\\' then
                buf[#buf + 1] = sql:sub(i + 1, i + 1); i = i + 1
            elseif c == '"' then
                if sql:sub(i + 1, i + 1) == '"' then buf[#buf + 1] = '"'; i = i + 1
                else inD = false end
            end
        elseif inB then
            buf[#buf + 1] = c
            if c == '`' then inB = false end
        else
            if c2 == '/*' then
                local close = sql:find('*/', i + 2, true)
                i = (close and close + 1) or n
            elseif c2 == '--' then
                local nl = sql:find('\n', i, true)
                i = (nl and nl - 1) or n
            elseif c == '#' then
                local nl = sql:find('\n', i, true)
                i = (nl and nl - 1) or n
            elseif c == ';' then
                flush()
            elseif c == "'" then inS = true; buf[#buf + 1] = c
            elseif c == '"' then inD = true; buf[#buf + 1] = c
            elseif c == '`' then inB = true; buf[#buf + 1] = c
            else buf[#buf + 1] = c end
        end
        i = i + 1
    end
    flush()
    return statements
end

-- Execute every statement in a bundled .sql file. Idempotent — every
-- statement uses IF NOT EXISTS / INSERT IGNORE so re-running is harmless.
local function runSqlFile(fname)
    local file = LoadResourceFile(GetCurrentResourceName(), fname)
    if not file or file == '' then
        print(('^3[apex_adminmenu]^7 %s not found, skipping'):format(fname))
        return 0, 0
    end

    local applied, failed = 0, 0
    for _, stmt in ipairs(splitStatements(file)) do
        local ok, err = pcall(function() MySQL.query.await(stmt) end)
        if ok then
            applied = applied + 1
        else
            failed = failed + 1
            -- Don't blast the console: only warn on real failures, not
            -- "table already exists" (we use IF NOT EXISTS).
            if not tostring(err):find('already exists') then
                print(('^3[apex_adminmenu]^7 SQL skipped: %s'):format(tostring(err)))
            end
        end
    end
    return applied, failed
end

CreateThread(function()
    Wait(2000) -- wait for oxmysql

    -- Both bundled schemas: the admin panel tables + the bans table.
    local a1, f1 = runSqlFile('install_admin_panel.sql')
    local a2, f2 = runSqlFile('install_me.sql')

    -- Tables exist now — release the gate so DB writes elsewhere apply.
    PanelSchemaReady = true

    -- Lightweight migrations — CREATE TABLE IF NOT EXISTS doesn't touch
    -- existing tables, so columns added later need an explicit ALTER.
    -- Each migration is wrapped in pcall because a "Duplicate column"
    -- error on a fresh DB (where the CREATE already added it) is normal.
    local migrations = {
        -- v1.1 — base64 cache for steam avatars so the panel works
        -- even when Steam's CDN is unreachable.
        [[ALTER TABLE apex_steam_avatars ADD COLUMN avatar_b64 LONGTEXT NULL]],
        -- v1.3 — rebrand: groups still on the old brand green get the
        -- new Apex blue so staff cards match the theme. Custom colours
        -- the owner picked are untouched (only the old default migrates).
        [[UPDATE apex_staff_groups SET color = '#1F5EFF' WHERE LOWER(color) = '#1a7249']],

        -- v2.0 — apex_bans gains a primary key, the issuer's license and
        -- 64-bit timestamps. Older installs had none of these, which is
        -- why "ORDER BY id" queries and panel offline-bans failed.
        [[ALTER TABLE apex_bans ADD COLUMN id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST]],
        [[ALTER TABLE apex_bans ADD COLUMN author_lic VARCHAR(64) NULL AFTER author]],
        [[ALTER TABLE apex_bans MODIFY COLUMN ban_time BIGINT(20) NOT NULL DEFAULT 0]],
        [[ALTER TABLE apex_bans MODIFY COLUMN exp_time BIGINT(20) NOT NULL DEFAULT -1]],
        [[ALTER TABLE apex_bans ADD INDEX idx_apex_bans_license (license)]],
        -- Permanent bans used to be written as the STRING 'perm' into an
        -- INT column, which MySQL silently coerced to 0 — and 0 reads back
        -- as "expired long ago", so permanent bans let the player straight
        -- back in. Normalise those rows to the -1 sentinel.
        [[UPDATE apex_bans SET exp_time = -1 WHERE exp_time = 0]]
    }
    for _, mig in ipairs(migrations) do
        pcall(function() MySQL.query.await(mig) end)
    end

    -- v1.2 — add `jobs.*` to any existing apex_staff_groups admin
    -- row that doesn't have it yet. The Jobs page needs this perm
    -- and the DB row overrides the code default on every reload.
    pcall(function()
        local rows = MySQL.query.await('SELECT name, permissions FROM apex_staff_groups')
        for _, r in ipairs(rows or {}) do
            if r.permissions and r.permissions ~= '' and not r.permissions:find('jobs', 1, true) then
                local ok, perms = pcall(function() return json.decode(r.permissions) end)
                if ok and type(perms) == 'table' then
                    -- Inject jobs.read for moderator/helper, jobs.* for admin/owner.
                    local key = (r.name == 'admin' or r.name == 'owner') and 'jobs.*' or 'jobs.read'
                    local hasIt = false
                    for _, p in ipairs(perms) do if p == key or p == '*' or p == 'jobs.*' then hasIt = true end end
                    if not hasIt then
                        perms[#perms + 1] = key
                        MySQL.query.await(
                            'UPDATE apex_staff_groups SET permissions = ? WHERE name = ?',
                            { json.encode(perms), r.name }
                        )
                        print(('^2[apex_adminmenu]^7 added "%s" perm to staff group "%s"'):format(key, r.name))
                    end
                end
            end
        end
    end)

    -- v2.2 — grant 'settings.*' to the admin/owner groups.
    --
    -- This is the fix for "the panel deletes my Discord webhooks". The
    -- seeded `admin` row carried "staff.read", but saving the server-wide
    -- Settings page was gated on "staff.*" — which "staff.read" does NOT
    -- satisfy. So an admin could open Settings, type webhook URLs, and get
    -- a "Settings saved." toast while the server silently discarded the
    -- write and served the fields back masked/empty on the next open.
    --
    -- The DB row overrides the code defaults on every reload, which is why
    -- fixing DEFAULT_GROUPS alone would not reach an existing install.
    pcall(function()
        local rows = MySQL.query.await('SELECT name, permissions FROM apex_staff_groups')
        for _, r in ipairs(rows or {}) do
            if r.permissions and r.permissions ~= '' then
                local ok, perms = pcall(function() return json.decode(r.permissions) end)
                if ok and type(perms) == 'table' then
                    local has = false
                    for _, p in ipairs(perms) do
                        if p == '*' or p == 'settings.*' or p == 'staff.*' then has = true end
                    end
                    -- Only the groups that are meant to configure the server.
                    -- A moderator gaining this silently would be a privilege
                    -- escalation, not a bug fix.
                    if not has and (r.name == 'admin' or r.name == 'owner') then
                        perms[#perms + 1] = 'settings.*'
                        MySQL.query.await(
                            'UPDATE apex_staff_groups SET permissions = ? WHERE name = ?',
                            { json.encode(perms), r.name }
                        )
                        print(('^2[apex_adminmenu]^7 added "settings.*" perm to staff group "%s" '
                            .. '(required to save Discord webhooks)'):format(r.name))
                    end
                end
            end
        end
    end)

    if PanelReload then pcall(PanelReload) end
    print(('^2[apex_adminmenu]^7 schema ready (%d statements applied, %d skipped)')
        :format(a1 + a2, f1 + f2))
end)
