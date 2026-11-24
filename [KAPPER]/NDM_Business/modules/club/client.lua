local DRUNK = NDM.ClubConfig.drunk
local TIERS = { 'extreme', 'heavy', 'moderate', 'light' }
local TIER_STRENGTH = { light = 0.15, moderate = 0.3, heavy = 0.5, extreme = 0.75 }

local drunkLevel = 0.0
local drunkTier = nil
local drunkThread = false
local serving = false

local function tierFor(level)
    for _, tier in ipairs(TIERS) do
        if level >= DRUNK.thresholds[tier] then return tier end
    end
    return nil
end

local function clearDrunkEffects()
    drunkTier = nil
    ResetPedMovementClipset(cache.ped, 1.0)
    SetPedIsDrunk(cache.ped, false)
    SetPedMotionBlur(cache.ped, false)
    ClearTimecycleModifier()
    StopGameplayCamShaking(false)
end

local function applyTier(tier)
    if tier == drunkTier then return end
    if not tier then
        clearDrunkEffects()
        return
    end
    drunkTier = tier
    local walk = DRUNK.walks[tier]
    lib.requestAnimSet(walk)
    SetPedMovementClipset(cache.ped, walk, 1.0)
    SetPedIsDrunk(cache.ped, true)
    SetPedMotionBlur(cache.ped, true)
    SetTimecycleModifier('Drunk')
    SetTimecycleModifierStrength(TIER_STRENGTH[tier])
    ShakeGameplayCam('DRUNK_SHAKE', TIER_STRENGTH[tier])
end

local function ensureDrunkThread()
    if drunkThread then return end
    drunkThread = true
    CreateThread(function()
        while drunkLevel > 0 do
            Wait(1000)
            if IsEntityDead(cache.ped) then
                drunkLevel = 0.0
            else
                drunkLevel = math.max(0.0, drunkLevel - DRUNK.decayPerSecond)
            end
            applyTier(tierFor(drunkLevel))
        end
        applyTier(nil)
        drunkThread = false
    end)
end

RegisterNetEvent('ndm_business:club:consume', function(label, alcohol)
    alcohol = tonumber(alcohol) or 0
    CreateThread(function()
        local dict = 'mp_player_intdrink'
        lib.requestAnimDict(dict)
        TaskPlayAnim(cache.ped, dict, 'loop_bottle', 3.0, -3.0, 3000, 49, 0.0, false, false, false)
        lib.notify({ type = 'inform', description = ('You drink a %s.'):format(label) })
        Wait(3000)
        StopAnimTask(cache.ped, dict, 'loop_bottle', 1.0)
        RemoveAnimDict(dict)
        if alcohol > 0 then
            drunkLevel = math.min(DRUNK.maxLevel, drunkLevel + alcohol / 100)
            applyTier(tierFor(drunkLevel))
            ensureDrunkThread()
        end
    end)
end)

local function chooseAccount(title)
    local input = lib.inputDialog(title, {
        {
            type = 'select',
            label = 'Payment',
            required = true,
            default = 'cash',
            options = {
                { value = 'cash', label = 'Cash' },
                { value = 'bank', label = 'Card' },
            },
        },
    })
    return input and input[1] or nil
end

function NDM.OpenClubEntry(pointId)
    CreateThread(function()
        local ok, info = pcall(lib.callback.await, 'ndm_business:club:entryInfo', false, { point = pointId })
        if not ok or not info or not info.ok then
            lib.notify({ type = 'error', description = info and info.error or 'The server did not respond.' })
            return
        end

        local function buy(passType, price)
            CreateThread(function()
                local account = 'cash'
                if price > 0 then
                    account = chooseAccount(('Pay $%d'):format(price))
                    if not account then return end
                end
                local called, result = pcall(lib.callback.await, 'ndm_business:club:buyPass', false, {
                    point = pointId,
                    type = passType,
                    account = account,
                })
                if called and result and result.ok then
                    lib.notify({ type = 'success', description = ('Pass active for %d hours.'):format(result.hours) })
                else
                    lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
                end
            end)
        end

        local options = {}
        if info.pass then
            options[#options + 1] = {
                title = info.pass == 'vip' and 'VIP pass active' or 'Entry pass active',
                description = ('%d minutes remaining'):format(info.minutesLeft or 0),
                readOnly = true,
                icon = 'fa-solid fa-ticket',
            }
        end
        options[#options + 1] = {
            title = 'Entry pass',
            description = ('$%d for %d hours'):format(info.entryPrice, info.passHours),
            icon = 'fa-solid fa-ticket',
            disabled = info.pass ~= nil,
            onSelect = function() buy('entry', info.entryPrice) end,
        }
        if info.vipEnabled then
            options[#options + 1] = {
                title = 'VIP pass',
                description = ('$%d for %d hours, with cheaper drinks'):format(info.vipPrice, info.passHours),
                icon = 'fa-solid fa-crown',
                disabled = info.pass == 'vip',
                onSelect = function() buy('vip', info.vipPrice) end,
            }
        end

        lib.registerContext({ id = 'ndm_business_club_entry', title = info.venue, options = options })
        lib.showContext('ndm_business_club_entry')
    end)
end

local function serveDrink(pointId, drink, customers)
    if serving then return end
    local customerOptions = {}
    for _, customer in ipairs(customers) do
        customerOptions[#customerOptions + 1] = {
            value = tostring(customer.id),
            label = ('%s (%d)'):format(customer.name, customer.id),
        }
    end

    local input = lib.inputDialog(('Serve %s'):format(drink.label), {
        { type = 'select', label = 'Customer', required = true, default = customerOptions[1].value, options = customerOptions },
        {
            type = 'select',
            label = 'Payment',
            required = true,
            default = 'cash',
            options = { { value = 'cash', label = 'Cash' }, { value = 'bank', label = 'Card' } },
        },
    })
    if not input then return end

    serving = true
    local dict = 'amb@prop_human_bbq@male@base'
    lib.requestAnimDict(dict)
    TaskPlayAnim(cache.ped, dict, 'base', 3.0, -3.0, -1, 49, 0.0, false, false, false)
    local mixed = lib.skillCheck({ 'easy', 'easy', 'medium' }, { 'e' })
    StopAnimTask(cache.ped, dict, 'base', 1.0)
    RemoveAnimDict(dict)

    if not mixed then
        serving = false
        lib.notify({ type = 'error', description = 'You spilled the drink. Nobody was charged.' })
        return
    end

    local ok, result = pcall(lib.callback.await, 'ndm_business:club:serve', false, {
        point = pointId,
        drink = drink.id,
        customer = tonumber(input[1]),
        account = input[2],
    })
    serving = false
    if ok and result and result.ok then
        lib.notify({ type = 'success', description = result.message })
    else
        lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
    end
end

function NDM.OpenBar(pointId)
    if serving then return end
    CreateThread(function()
        local ok, menu = pcall(lib.callback.await, 'ndm_business:club:barMenu', false, { point = pointId })
        if not ok or not menu or not menu.ok then
            lib.notify({ type = 'error', description = menu and menu.error or 'The server did not respond.' })
            return
        end

        local options = {}
        for _, drink in ipairs(menu.drinks) do
            options[#options + 1] = {
                title = drink.label,
                description = ('$%d · %d%% alcohol'):format(drink.price, drink.alcohol),
                icon = 'fa-solid fa-martini-glass',
                onSelect = function()
                    CreateThread(function() serveDrink(pointId, drink, menu.customers) end)
                end,
            }
        end
        lib.registerContext({ id = 'ndm_business_bar', title = ('%s bar'):format(menu.venue), options = options })
        lib.showContext('ndm_business_bar')
    end)
end

local function securityAction(target, action, label)
    CreateThread(function()
        local answer = lib.alertDialog({
            header = label,
            content = 'Are you sure?',
            centered = true,
            cancel = true,
        })
        if answer ~= 'confirm' then return end
        local ok, result = pcall(lib.callback.await, 'ndm_business:club:securityAction', false, {
            target = target,
            action = action,
        })
        if ok and result and result.ok then
            lib.notify({ type = 'success', description = 'Done.' })
        else
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
        end
    end)
end

local function openSecurity(target)
    CreateThread(function()
        local ok, info = pcall(lib.callback.await, 'ndm_business:club:inspect', false, { target = target })
        if not ok or not info or not info.ok then
            lib.notify({ type = 'error', description = info and info.error or 'The server did not respond.' })
            return
        end

        local status = info.banned and 'Banned' or (info.pass == 'vip' and 'VIP pass' or (info.pass and 'Entry pass' or 'No pass'))
        local options = {
            { title = info.name, description = status, icon = 'fa-solid fa-id-card', readOnly = true },
        }
        if info.protected then
            options[#options + 1] = {
                title = 'Protected',
                description = 'Staff and emergency services cannot be removed.',
                icon = 'fa-solid fa-shield',
                readOnly = true,
            }
        else
            options[#options + 1] = {
                title = 'Revoke pass',
                icon = 'fa-solid fa-ticket',
                disabled = not info.pass,
                onSelect = function() securityAction(target, 'revoke', 'Revoke pass') end,
            }
            options[#options + 1] = {
                title = 'Throw out',
                icon = 'fa-solid fa-door-open',
                onSelect = function() securityAction(target, 'throw', 'Throw out') end,
            }
            options[#options + 1] = {
                title = 'Ban from club',
                icon = 'fa-solid fa-ban',
                disabled = info.banned,
                onSelect = function() securityAction(target, 'ban', 'Ban from club') end,
            }
        end

        lib.registerContext({ id = 'ndm_business_security', title = ('%s security'):format(info.venue), options = options })
        lib.showContext('ndm_business_security')
    end)
end

CreateThread(function()
    exports.ox_target:addGlobalPlayer({
        {
            name = 'ndm_business_club_security',
            icon = 'fa-solid fa-shield-halved',
            label = 'Club security',
            distance = 3.0,
            canInteract = function() return NDM.IsNearOwnClub() end,
            onSelect = function(data)
                local player = NetworkGetPlayerIndexFromPed(data.entity)
                if player and player ~= -1 then openSecurity(GetPlayerServerId(player)) end
            end,
        },
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if drunkLevel > 0 or drunkTier then clearDrunkEffects() end
    exports.ox_target:removeGlobalPlayer({ 'ndm_business_club_security' })
end)
