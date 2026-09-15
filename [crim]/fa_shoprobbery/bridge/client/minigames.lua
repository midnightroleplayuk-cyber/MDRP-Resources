local function getMinigamePreset(store, stage)
    local minigame = Config.Minigames[stage]

    if store and store.Minigames and store.Minigames[stage] ~= nil then
        minigame = store.Minigames[stage]
    end

    return minigame
end

local function runOxKeypadInput(validate)
    while true do
        local input = lib.inputDialog(locale('keypad_input_title'), {
            {
                type = 'number',
                label = locale('keypad_input_label'),
                description = locale('keypad_input_description'),
                icon = 'key',
                min = 1000,
                max = 9999,
                precision = 0,
                step = 1,
                required = true
            }
        }, {
            allowCancel = true
        })

        if not input then
            return { submitted = false, reason = 'cancelled' }
        end

        local numericCode = tonumber(input[1])
        local code = numericCode and numericCode % 1 == 0 and tostring(numericCode) or nil
        code = code and code:match('^%d%d%d%d$') and code or nil

        if code then
            if type(validate) ~= 'function' then
                return { submitted = true, code = code, reason = 'completed' }
            end

            local validated, response = pcall(validate, code)
            response = validated and type(response) == 'table' and response or {
                success = false,
                close = true,
                reason = 'failed'
            }

            if response.success == true or response.close ~= false then
                return {
                    submitted = true,
                    validated = true,
                    success = response.success == true,
                    reason = response.reason or (response.success == true and 'completed' or 'failed'),
                    message = response.message
                }
            end

            if response.message then
                Bridge.Notify(response.message, 'error')
            end
        end
    end
end

function RunRegisterMinigame(store)
    local minigame = getMinigamePreset(store, 'Register')

    if not minigame or minigame == 'none' then
        return true
    end

    if minigame == 'ox_skillcheck' then
        return lib.skillCheck({ 'easy', 'easy', 'medium' }, { 'w', 'a', 's', 'd' })
    end

    if minigame == 'lation_ui_skillcheck' then
        return exports.lation_ui:skillCheck('Open Register', { 'easy', 'easy', 'medium' }, { 'w', 'a', 's', 'd' })
    end

    if minigame == 'lation_ui_patternlock' then
        return exports.lation_ui:patternLock('Open Register', 'easy')
    end

    if minigame == 'custom' then
        -- Add your custom register minigame here.
        return false
    end

    return true
end

function RunSafeMinigame(store)
    local minigame = getMinigamePreset(store, 'Safe')

    if not minigame or minigame == 'none' then
        return true
    end

    if minigame == 'ox_skillcheck' then
        return lib.skillCheck({ 'medium', 'hard', 'medium', 'easy' }, { 'w', 'a', 's', 'd' })
    end

    if minigame == 'lation_ui_skillcheck' then
        return exports.lation_ui:skillCheck('Open Safe', { 'medium', 'hard', 'medium', 'easy' }, { 'w', 'a', 's', 'd' })
    end

    if minigame == 'lation_ui_patternlock' then
        return exports.lation_ui:patternLock('Open Safe', 'hard')
    end

    if minigame == 'custom' then
        -- Add your custom safe minigame here.
        return false
    end

    return true
end

function RunDrillMinigame(store)
    local preset = getMinigamePreset(store, 'Safe')

    if preset == 'custom' then
        -- Add your custom drill minigame here.
        return { success = false, reason = 'failed' }
    end

    if preset ~= 'fa_minigames' then
        return { success = false, reason = 'unsupported_preset' }
    end

    if GetResourceState('fa_minigames') ~= 'started' then
        return { success = false, reason = 'missing_resource' }
    end

    local result = exports.fa_minigames:Drill({
        difficulty = tonumber(Utils.GetSafeAccessValue(store, 'drill', 'Difficulty')) or 2,
        timeout = tonumber(Utils.GetSafeAccessValue(store, 'drill', 'Timeout')) or 45000
    })

    if type(result) ~= 'table' then return { success = false, reason = 'failed' } end
    return result
end

function RunKeypadMinigame(store, validate)
    local preset = getMinigamePreset(store, 'Safe')

    if preset == 'custom' then
        -- Add your custom keypad minigame here. Never pass the correct safe code to client-side UI.
        return { submitted = false, reason = 'failed' }
    end

    if preset == 'ox_input' then
        return runOxKeypadInput(validate)
    end

    if preset ~= 'fa_minigames' then
        return { submitted = false, reason = 'unsupported_preset' }
    end

    if GetResourceState('fa_minigames') ~= 'started' then
        return runOxKeypadInput(validate)
    end

    local exported, result = pcall(function()
        return exports.fa_minigames:Keypad({
            title = 'Safe',
            timeout = tonumber(Utils.GetSafeAccessValue(store, 'keypad', 'Timeout')) or 30000,
            validate = validate
        })
    end)

    if not exported or type(result) ~= 'table' then
        return runOxKeypadInput(validate)
    end

    return result
end
