RegisterNetEvent('av_gangs:ingredients', function(data) -- ingredients stash
    local propertyIdentifier = data and data['propertyIdentifier']
    dbug('ingredients(propertyId)', propertyIdentifier)
    if not propertyIdentifier then
        warn('ingredients event received null instead of propertyIdentifier')
        return
    end
    local stashName = data['propertyIdentifier'].."ingredients"
    local stashData = Config.Stashes and Config.Stashes['ingredients']
    openStash(stashName, Lang['ingredients'], stashData and stashData['weight'] or 5000, stashData and stashData['slots'] or 5)
end)

RegisterNetEvent('av_gangs:product', function(data) -- products stash
    local propertyIdentifier = data and data['propertyIdentifier']
    dbug('products(propertyId)', propertyIdentifier)
    if not propertyIdentifier then
        warn('product event received null instead of propertyIdentifier')
        return
    end
    local stashName = data['propertyIdentifier'].."products"
    local stashData = Config.Stashes and Config.Stashes['products']
    openStash(stashName, Lang['products'], stashData and stashData['weight'] or 10000, stashData and stashData['slots'] or 10)
end)

RegisterNetEvent('av_gangs:stash', function(data) -- regular stash
    local propertyIdentifier = data and data['propertyIdentifier']
    dbug('products(propertyId)', propertyIdentifier)
    if not propertyIdentifier then
        warn('product event received null instead of (propertyIdentifier)', propertyIdentifier)
        return
    end
    local stashData = lib.callback.await('av_gangs:getStash', false, data['gang'], data['interiorType'], data['propertyIdentifier'])
    if stashData then
        openStash(propertyIdentifier.."stash", Lang['stash'], stashData['weight'], stashData['slots'])
    else
        warn('stashData returned null, verify your server console for more info.')
    end
end)

function openStash(name, label, weight, slots)
    dbug('openStash(name,label,weight,slots)', name, label, weight, slots)
    local progress = exports['av_laptop']:progressBar({
        duration = 3000,
        label = Lang['opening'],
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'missheistfbisetup1',
            clip = 'hassle_intro_loop_f'
        },
        prop = {
        },
    })
    if not progress then
        dbug("Progressbar was cancelled or returned false")
        return
    end
    exports['av_laptop']:openStash(name, label, weight, slots, true)
end