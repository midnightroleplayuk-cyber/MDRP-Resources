-- Someone asked how to create a custom event for plushies
-- This is not officially supported by me

local obj = nil
local plushies = { -- Add your item names and their config here....
    ['purple_plushie'] = { -- change it to an existing item name
        dict = "impexp_int-0",
        anim = "mp_m_waremech_01_dual-0",
        model = `sum_prop_sum_arcade_plush_01a`,
        bone = 24817,
        offset = { -0.15, 0.45, -0.02, -180.0, -90.0, 0.0 },
    },
}

local keybind = lib.addKeybind({
    name = 'plushies',
    description = 'Press H to stop animation',
    defaultKey = 'H',
    disabled = true,
    onPressed = function(self)
        cancelAnim()
    end,
})

-- RegisterCommand("plushie", function()
--     TriggerEvent('av_business:plushies', nil, 'purple_plushie')
-- end)

RegisterNetEvent('av_business:plushies', function(_,itemName)
    dbug('plushies(itemName)', itemName)
    if obj then
        cancelAnim()
    end
    local settings = plushies[itemName] or false
    if settings then
        dbug("Item ", itemName, "exist in plushies table, load model...")
        local model = settings['model']
        local dict = settings['dict']
        if not model or not dict then
            warn("model or dict doesn't exist in plushies table for this item", itemName)
            return
        end
        if IsModelValid(model) then
            lib.requestModel(settings['model'], 30000) -- load model :)
            lib.playAnim(cache.ped, dict, settings['anim'], 8.0, 8.0, -1, 50, 0.0, false, 0, false)
            local pCoords = GetEntityCoords(cache.ped)
            local offsets = settings['offset']
            obj = CreateObject(model, pCoords.x, pCoords.y, pCoords.z, true, true, false)
            AttachEntityToEntity(obj, cache.ped, GetPedBoneIndex(cache.ped, settings['bone']), offsets[1], offsets[2], offsets[3], offsets[4], offsets[5], offsets[6], true, true, false, false, 1, true)
            keybind:disable(false)
            lib.showTextUI("[H] Stop Animation")
            while obj do
                if not IsEntityPlayingAnim(cache.ped, settings['dict'], settings['anim'], 3) then
                    lib.playAnim(cache.ped, dict, settings['anim'], 8.0, 8.0, -1, 50, 0.0, false, 0, false)
                end
                Wait(500)
            end
        else
            warn('Prop', plushies[itemName]['prop'],"doesn't seem to be valid, this is NOT a script problem.")
        end
    else
        dbug("Item", itemName, "doesn't exist in plushies table.")
    end
end)

function cancelAnim()
    dbug('cancelAnim()')
    if obj then
        DeleteObject(obj)
    end
    ClearPedTasks(cache.ped)
    obj = nil
    keybind:disable(true)
    lib.hideTextUI()
end