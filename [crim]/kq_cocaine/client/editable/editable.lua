
function CanCollectCocaLeaves()
    -- Change this with a custom statement if you wish
    return true
end

function CanUsePit()
    -- Change this with a custom statement if you wish
    return true
end

function CanUseBarrel()
    -- Change this with a custom statement if you wish
    return true
end

function CanUseFirepit()
    -- Change this with a custom statement if you wish
    return true
end

function IsPlayerUnreachable()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed) or IsPedRagdoll(playerPed) or IsEntityDead(playerPed)
end

function CreateBlip(coords, sprite, color, alpha, scale, message)
    local blip = AddBlipForCoord(coords)
    
    SetBlipSprite(blip, sprite)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(message)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    
    return blip
end

function DisableInputs()
    -- https://docs.fivem.net/docs/game-references/controls/#controls
    local inputs = {21, 44}
    
    for k, input in pairs(inputs) do
        DisableControlAction(0, input, true)
    end
end

RegisterNetEvent('kq_cocaine:client:playLeavesAnimation')
AddEventHandler('kq_cocaine:client:playLeavesAnimation', function()
    SetCooldown()
    
    PlayAnim('amb@world_human_gardener_plant@male@enter', 'enter')
    Citizen.Wait(1500)
    PlayAnim('amb@world_human_gardener_plant@male@base', 'base')
    Citizen.Wait(4000)
    PlayAnim('amb@world_human_gardener_plant@male@exit', 'exit')
    Citizen.Wait(1500)
    ClearPedTasks(PlayerPedId())
end)

local function SpawnCementBagInHands()
    local playerPed = PlayerPedId()
    
    local bone = 57005
    local coords = GetEntityBonePosition_2(playerPed, GetPedBoneIndex(playerPed, bone))
    local object = CreateObject('kq_cement_bag', coords, 1, 1, 0)
    
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, bone),
        vec3(0.05, -0.1, -0.25),
        vec3(0, 90, 120),
        1, 0, 0, 0, 2, 1)
    
    FadeInEntity(object, 500)
    
    return object
end

local function PlayCementThrowParticles(object, duration)
    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + duration
        
        local dict = 'core'
        if not HasNamedPtfxAssetLoaded(dict) then
            RequestNamedPtfxAsset(dict)
            while not HasNamedPtfxAssetLoaded(dict) do
                Citizen.Wait(1)
            end
        end
        
        while endTime > GetGameTimer() do
            SetPtfxAssetNextCall(dict)
            local particle = StartNetworkedParticleFxLoopedOnEntity('ent_amb_stoner_rubble_drop', object, vec3(0, -0.3, 0), vec3(0, 0, 0), 1.2, vec3(0, 0, 0))
            SetParticleFxNonLoopedColour(particle, 1.0, 1.0, 1.0)
            
            Citizen.Wait(750)
            
            Citizen.SetTimeout(2000, function()
                StopParticleFxLooped(particle, 0)
                RemoveParticleFx(particle, true)
            end)
        end
    end)
end

RegisterNetEvent('kq_cocaine:client:playCementAnimation')
AddEventHandler('kq_cocaine:client:playCementAnimation', function()
    SetCooldown()
    local duration = 8000

    PlayAnim('anim@amb@casino@mini@drinking@champagne_drinking@heels@base', 'spray_right_down', 49)
    
    local cementBag = SpawnCementBagInHands()
    PlayCementThrowParticles(cementBag, duration)
    
    Citizen.Wait(duration)
    
    FadeOutEntity(cementBag, 700)
    
    DeleteEntity(cementBag)
    ClearPedTasks(PlayerPedId())
end)

if Config.debug then
    RegisterCommand('d_cementanim', function()
        TriggerEvent('kq_cocaine:client:playCementAnimation')
    end)
end
