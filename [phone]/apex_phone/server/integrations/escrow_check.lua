-- ------------------------------------------------------------
-- ESCROW CHECK (since 1.5.1). Not a provider adapter: it lives in server/integrations/ because every manifest since
-- 1.3.1 loads this folder with 'server/integrations/*.lua', so it still runs when an OLD fxmanifest.lua was
-- left behind over newer files. It is readable in every build on purpose.
--
-- The protected build ships encrypted Lua files. When the server cannot decrypt them it reads them as plain
-- Lua and the console fills with one line per file:
--     Error parsing script @apex_phone/server/main.lua ... :1: syntax error near '<\1>'
-- usually followed by "attempt to index a nil value (local 'PI')". That is an installation problem (the hidden
-- .fxap file missing or from another version, a folder that mixes two versions, files damaged by an FTP text
-- transfer, old server artifacts), not a script bug, and nothing in config.lua causes or fixes it. An encrypted
-- check could not report it, because it would be one of the files that failed to load. This one stays open,
-- looks at what happened and prints what to do.
--
-- It prints nothing when the phone loaded normally and does nothing in the open source build.
-- ------------------------------------------------------------
local FILES_VERSION = '1.5.3'   -- the version these files belong to (fxmanifest.lua carries the same number)
local RES = GetCurrentResourceName()

-- first bytes of a file of this resource, exactly as they are on disk (nil = no such file)
local function head(file)
    local ok, raw = pcall(LoadResourceFile, RES, file)
    if ok and type(raw) == 'string' then return raw:sub(1, 4) end
    return nil
end

-- an encrypted file starts with the bytes "FXAP"
local PROBES = { 'server/main.lua', 'server/integrations.lua', 'server/console.lua' }
local protected = false
for i = 1, #PROBES do
    if head(PROBES[i]) == 'FXAP' then protected = true break end
end
if not protected then return end   -- open source build: nothing to check

local function meta(key)
    local ok, v = pcall(GetResourceMetadata, RES, key, 0)
    if ok and type(v) == 'string' and v ~= '' then return v end
    return nil
end

local function say(line) print(('^1[apex_phone]^0 %s'):format(line)) end

local function report()
    local manVersion = meta('version')
    local lua54      = meta('lua54')
    local okV, artifact = pcall(GetConvar, 'version', '')

    say('^1============================================================================^0')
    say('^1THE PHONE DID NOT START: the server could not decrypt the protected files.^0')
    say('The "syntax error near \'<\\1>\'" and "local \'PI\'" lines above are this one problem.')
    say('It is an installation problem, not a script bug, and config.lua has nothing to do with it.')
    say(('files %s | fxmanifest.lua %s | folder "%s" | lua54 %s'):format(FILES_VERSION, tostring(manVersion or '?'),
        RES, tostring(lua54 or 'not set')))
    if okV and artifact ~= '' then say('server: ' .. tostring(artifact)) end
    say('')
    if manVersion ~= FILES_VERSION then
        say(('^3>> This folder mixes two versions: fxmanifest.lua is %s, these files are %s.^0'):format(
            tostring(manVersion or 'unknown'), FILES_VERSION))
        say('   An update was copied over an older install (or some files were skipped). The encrypted files')
        say('   and the hidden .fxap file only work together when they come from the same download.')
        say('')
    end
    if lua54 ~= 'yes' then
        say('^3>> fxmanifest.lua does not have the line  lua54 \'yes\'  (it was edited or replaced).^0')
        say('')
    end
    say('How to fix it:')
    say('  1. Download the asset again from https://portal.cfx.re (Granted Assets) and unzip it on your PC.')
    say('     Use your own download: files copied from another server or sent by someone else will not work.')
    say(('  2. Delete the whole "%s" folder on the server, then upload the new one COMPLETE. It has a hidden'):format(RES))
    say('     file ".fxap" next to fxmanifest.lua: FTP programs and web file managers often skip it, and')
    say('     without it (or with the one of an older version) every protected file fails like above.')
    say('     Do not copy only some files over an older version, and keep the original fxmanifest.lua.')
    say('  3. FTP: transfer type Binary (FileZilla: Transfer > Transfer type > Binary). Text/ASCII mode')
    say('     damages the encrypted files.')
    say('  4. Update the server artifacts if they are old, and use an sv_licenseKey of the Cfx.re account')
    say('     that owns the asset.')
    say('  5. Restart the whole server (not only "ensure").')
    say('^1============================================================================^0')
end

CreateThread(function()
    Wait(3000)
    -- server/main.lua creates RPC. When it exists the files were decrypted and all is well.
    if type(RPC) == 'table' then return end
    report()
    Wait(60000)   -- once more after the start-up scroll, so it is not lost among the other resources
    if type(RPC) == 'table' then return end
    report()
end)
