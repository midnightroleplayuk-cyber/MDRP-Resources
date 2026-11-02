local minigame = {
    ['easy'] = {
        difficulty = { 'easy', 'easy', 'medium' },
    },
    ['medium'] = {
        difficulty = { 'easy', 'medium', 'medium', 'hard' },
    },
    ['hard'] = {
        difficulty = { 'medium', 'hard', 'hard', 'hard' },
    },
}

function hackDoor(difficulty)
    TaskStartScenarioInPlace(
        cache.ped,
        'WORLD_HUMAN_STAND_MOBILE',
        0,
        true
    )

    Wait(1500)

    local settings = minigame[difficulty] or minigame['easy']

    local success = lib.skillCheck(settings.difficulty)

    ClearPedTasks(cache.ped)

    return success
end