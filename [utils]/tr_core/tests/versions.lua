-- tr_core's version check (server/versions.lua): which resources count, the wait, the printed block.

local check = T.check

local function run(resources, answer)
    T.resource = 'tr_core'
    T.timer = 0
    local printed, request, waits = {}, nil, 0
    local thread

    -- name -> { state, meta = { key = { values } } }
    GetNumResources = function() return #resources end
    GetResourceByFindIndex = function(i) return resources[i + 1] and resources[i + 1].name end
    local function find(name)
        if name == 'tr_core' then return { state = 'started', meta = { version = { '1.4.0' } } } end
        for _, r in ipairs(resources) do if r.name == name then return r end end
    end
    GetResourceState = function(name) local r = find(name) return r and r.state or 'missing' end
    GetNumResourceMetadata = function(name, key) local r = find(name) return r and r.meta[key] and #r.meta[key] or 0 end
    GetResourceMetadata = function(name, key, i) local r = find(name) return r and r.meta[key] and r.meta[key][i + 1] end
    CreateThread = function(fn) thread = fn end
    Wait = function(ms) waits = waits + 1 T.timer = T.timer + ms end
    PerformHttpRequest = function(url, cb) request = url cb(answer.status, answer.body) end
    local realPrint = print
    print = function(line) printed[#printed + 1] = line end

    load(LoadResourceFile('tr_core', 'server/versions.lua'), '@versions.lua')()
    TriggerEvent('onServerResourceStart', 'tr_late')
    thread()
    print = realPrint
    return printed, request, waits
end

local latest = [[{"tr_core":{"version":"1.4.0","download":"https://github.com/x/tr_core/releases/latest"},"tr_minigames":{"version":"1.1.0","download":"https://github.com/x/tr_minigames/releases/latest"},"tr_fraud":{"version":"0.6.0","download":"https://portal.cfx.re/assets/granted-assets"},"tr_laptop":{"version":"1.0.2","download":"https://github.com/x/tr_laptop/releases/latest"}}]]

local resources = {
    { name = 'tr_minigames', state = 'started', meta = { version = { '1.0.0' }, shared_script = { '@tr_core/init.lua' } } },
    { name = 'fraud', state = 'started', meta = { name = { 'tr_fraud' }, version = { '0.6.0' }, dependency = { 'tr_core' } } },
    { name = 'tr_laptop', state = 'stopped', meta = { version = { '1.0.1' }, dependency = { 'tr_core' } } },
    { name = 'tr_crypto', state = 'started', meta = { version = { '0.1.0' }, dependency = { 'tr_core' } } },
    { name = 'ox_lib', state = 'started', meta = { version = { '3.0.0' }, dependency = { '/onesync' } } },
}

do
    local printed, url, waits = run(resources, { status = 200, body = latest })
    local all = table.concat(printed, '\n')
    check('versions asks the dashboard', url == 'https://admin.tr-scripts.com/api/versions')
    check('versions waits until starting has been quiet', waits >= 5)
    check('versions header counts updates', printed[1]:find('1 update available', 1, true) ~= nil)
    check('versions tr_core first and up to date', printed[2]:find('tr_core', 1, true) and printed[2]:find('up to date', 1, true))
    check('versions outdated script with its download', all:find('tr_minigames%s+1%.0%.0%s+%^3update to 1%.1%.0%^7: https://github%.com/x/tr_minigames') ~= nil)
    check('versions renamed folder found by its fxmanifest name', all:find('fraud%s+0%.6%.0%s+%^2up to date') ~= nil)
    check('versions stopped resource left out', not all:find('tr_laptop', 1, true))
    check('versions unknown script left out', not all:find('tr_crypto', 1, true))
    check('versions resource without tr_core left out', not all:find('ox_lib', 1, true))
    check('versions four lines', #printed == 4)
end

do
    local printed = run({ resources[2] }, { status = 200, body = latest })
    check('versions all up to date', printed[1]:find('everything is up to date', 1, true) ~= nil and #printed == 3)
end

do
    local newer = [[{"tr_core":{"version":"1.3.0"}}]]
    local printed = run({}, { status = 200, body = newer })
    check('versions newer than released', printed[2]:find('newer than the latest release (1.3.0)', 1, true) ~= nil)
end

do
    local printed = run(resources, { status = 0, body = nil })
    check('versions no answer: one line', #printed == 1 and printed[1]:find("couldn't check for updates (HTTP 0)", 1, true) ~= nil)
    printed = run(resources, { status = 200, body = '<html>' })
    check('versions bad body: one line', #printed == 1 and printed[1]:find("couldn't check", 1, true) ~= nil)
end

T.done('versions')
