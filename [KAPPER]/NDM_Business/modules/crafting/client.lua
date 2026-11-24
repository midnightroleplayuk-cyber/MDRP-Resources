local crafting = false

local function craft(pointId, recipeId)
    if crafting then return end
    crafting = true

    local ok, started = pcall(lib.callback.await, 'ndm_business:crafting:start', false, {
        point = pointId,
        recipe = recipeId,
    })
    if not ok or not started or not started.ok then
        crafting = false
        lib.notify({ type = 'error', description = started and started.error or 'The server did not respond.' })
        return
    end

    local completed = lib.progressBar({
        duration = started.duration,
        label = ('Making %s...'):format(started.label),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { scenario = 'PROP_HUMAN_BUM_BIN' },
    })
    ClearPedTasks(cache.ped)

    if not completed then
        pcall(lib.callback.await, 'ndm_business:crafting:cancel', false)
        crafting = false
        lib.notify({ type = 'inform', description = 'Crafting cancelled. Ingredients were returned.' })
        return
    end

    local finished, result = pcall(lib.callback.await, 'ndm_business:crafting:finish', false)
    crafting = false
    if finished and result and result.ok then
        lib.notify({ type = 'success', description = ('%s added to stock.'):format(result.label) })
    else
        lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
    end
end

function NDM.OpenCrafting(pointId)
    if crafting then return end
    CreateThread(function()
        local ok, result = pcall(lib.callback.await, 'ndm_business:crafting:list', false, { point = pointId })
        if not ok or not result or not result.ok then
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
            return
        end
        if #result.recipes == 0 then
            lib.notify({ type = 'inform', description = 'No recipes are set up for this venue yet.' })
            return
        end

        local options = {}
        for _, recipe in ipairs(result.recipes) do
            options[#options + 1] = {
                title = recipe.label,
                description = recipe.description,
                disabled = not recipe.available,
                onSelect = function()
                    CreateThread(function() craft(pointId, recipe.id) end)
                end,
            }
        end

        lib.registerContext({
            id = 'ndm_business_crafting',
            title = ('%s crafting'):format(result.venue),
            options = options,
        })
        lib.showContext('ndm_business_crafting')
    end)
end
