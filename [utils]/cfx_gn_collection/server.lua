--! Please keep this file to stay tuned about all our updates!

local GITHUB_URL = 'https://raw.githubusercontent.com/G-N-s-Studio/gn_versions/main/versions.json'
local git_versions

local function loadVersions()
    PerformHttpRequest(GITHUB_URL, function(status, response)
        if status ~= 200 then return end
        git_versions = json.decode(response)
    end, 'GET')
end

local function checkResources()
    loadVersions()

    local format = string.format
    local getNumResources = GetNumResources
    local getResourceByFindIndex = GetResourceByFindIndex
    local getResourceMetadata = GetResourceMetadata
    local print = print
    local wait = Wait
    local isGnEnv = GetConvarInt('isGnEnv', 0) == 1

    local function isGnResource(resourceName)
        local author = GetResourceMetadata(resourceName, 'author', 0)
        return author and author:find('G&N') and resourceName:find('gn_')
    end

    local function isStarted(resource)
        return GetResourceState(resource):find('start')
    end

    -- Wait for git_versions with a timeout
    local timeout = 1000
    while not git_versions and timeout > 0 do
        wait(0)
        timeout -= 1
    end

    if not git_versions then return end

    local resourcesCount = getNumResources()

    for i = 1, resourcesCount do
        local resource = getResourceByFindIndex(i)

        if resource and isGnResource(resource) then
            local latestVersion = git_versions[resource]

            if isGnEnv and not latestVersion then
                print("^5[G&N's Studio]^6[DEV] ^3No latest version found for " .. resource .. "^7")
            elseif latestVersion and isStarted(resource) then
                local currentVersion = getResourceMetadata(resource, 'version', 0)

                if currentVersion and currentVersion < latestVersion then
                    local msg = format("^3・[G&N's Studio] v%s is available for ^5%s^3 (current version: %s)\r\n・Download it here: ^5%s^7",
                        latestVersion,
                        resource,
                        currentVersion,
                        'https://keymaster.fivem.net/'
                    )
                    print(msg)
                end
            end
        end
    end
end

CreateThread(checkResources)
