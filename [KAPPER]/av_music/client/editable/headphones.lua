local model = `sf_prop_sf_headphones_dj`
local headphones = nil

function setHeadphones(state)
    if not Config.UseAnimation then return end
    if state and not headphones then
        lib.requestModel(model, 10000)
        CreateThread(function()
            playAnim("mp_masks@standard_car@ds@", "put_on_mask")
        end)
        headphones = CreateObject(model, GetEntityCoords(cache.ped), true, true, true)
        SetEntityCollision(headphones, false, true)
        AttachEntityToEntity(headphones, cache.ped, GetPedBoneIndex(cache.ped, 12844), 0.09, 0.03, 0.0, -20.0, 90.0, 0.0, true, true, false, false, 1, true)
    else
        if headphones then
            playAnim("missheist_agency2ahelmet", "take_off_helmet_stand")
            DeleteObject(headphones)
            headphones = nil
        end
    end
end

function playAnim(dict,anim)
    if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
	end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 49, 0.0, 0.0, 0.0, 0.0)
    Wait(1000)
    RemoveAnimDict(dict)
    ClearPedTasks(PlayerPedId())
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if headphones then
        DeleteObject(headphones)
        headphones = nil
    end
end)