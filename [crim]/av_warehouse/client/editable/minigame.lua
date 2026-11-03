local minigame = {
    ['easy'] = {
        numberOfNodes = 7,
        duration = 10 * 1000, -- 10 seconds
    },
    ['medium'] = {
        numberOfNodes = 10,
        duration = 15 * 1000, -- 15 seconds
    },
    ['hard'] = {
        numberOfNodes = 12,
        duration = 15 * 1000, -- 15 seconds
    },
}

function hackDoor(difficulty)
	TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    Wait(1500)
    if GetResourceState('bl_ui') == "started" then
        local settings = minigame and minigame[difficulty] or minigame['easy'] or false
        local result = exports['bl_ui']:Untangle(3, {
            numberOfNodes = settings and settings['numberOfNodes'] or 10,
            duration = settings and settings['duration'] or 10000,
        })
        return result
    end
    warn("bl_ui is NOT installed, there's no minigame, add your own in client/editable/minigame.lua and remove this print too.")
    warn("This is NOT a script problem. :)")
    return false
end