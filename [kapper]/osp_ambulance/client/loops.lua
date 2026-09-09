-- Continuous polling threads

local function WaitUntilBodyDamageReady()
    while true do
        if IsBodyDamageReady and IsBodyDamageReady(BodyDamage) then
            return
        end
        if BodyDamage and EnsureBodyDamageStructure then
            EnsureBodyDamageStructure(BodyDamage)
        end
        Wait(100)
    end
end

CreateThread(function()
    while true do
        local auth = false
        for _,x in pairs(Config.AmbulanceJobs) do
            if onDuty and PlayerJob.name == x then
                auth = true
            end
        end
        if not auth then
            if DutyBlips then
                for _, v in pairs(DutyBlips) do
                    if v and DoesBlipExist(v) then
                        RemoveBlip(v)
                    end
                end
                DutyBlips = {}
            end
        end
        Wait(5000)
    end
end)

CreateThread(function()
    while true do
        if not PlayerLoaded then
            if GetCharacterName() then
                Wait(3000)
                PlayerLoaded = true
                break
            end
        end
        Wait(5000)
    end
end)

CreateThread(function()
    Wait(1000)
    SyncServerTime()
    while true do
        Wait(60*1000)
        SyncServerTime()
    end
end)

CreateThread(function() -- Check if the player is recieving CPR
    local cprAnimDict = 'missheistfbi3b_ig8_2'
    local cprAnimName = 'cpr_loop_victim'
    while true do
        if BodyDamage.beingPerformedCPROn then
            lib.requestAnimDict(cprAnimDict, 1000)
            if not IsEntityPlayingAnim(PlayerPedId(), cprAnimDict, cprAnimName, 3) then
                TaskPlayAnim(PlayerPedId(), cprAnimDict, cprAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    if Config.UseMovementRate then
        while true do
            if SlowEffect1 then
                SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[1])
            elseif SlowEffect2 then
                SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[2])
            elseif SlowEffect3 then
                SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[3])
            end
            Wait(2000)
        end
    end
end)

CreateThread(function()
    while true do
        local ply = PlayerPedId()
        SetPlayerHealthRechargeMultiplier(ply, 0.0)
        SetPlayerHealthRechargeLimit(ply, 0.0)
        Wait(2000)
    end
end)

CreateThread(function()
    Wait(1000*30)
	if GetCurrentResourceName() ~= 'osp_ambulance' then
		while true do
			Wait(1000)
            print('^1 FATAL ERROR! osp_ambulance script has been renamed, the script WILL NOT WORK!')
		end
	end
end)

CreateThread(function()
    while true do
        local objectPool = GetGamePool('CNetObject') -- Get the list of entities from the pool
        if #objectPool > 75 then
            print('^1 WARNING! YOU ARE ABOUT TO EXCEED THE MAXIMUM NUMBER OF NETWORKED ENTITIES! 75/80. THE AMBULANCE SCRIPT WILL START CLEARING 10 ENTITIES')
            for i = 1, 10 do
                if objectPool[i] then
                    DeleteEntity(objectPool[i])
                end
            end
        end
        Wait(10*1000)
    end
end)

CreateThread(function() -- Auto checkin player if they are near a checkin location and dead
    while true do
        local sleep = 10*1000
        if PlayerLoaded then
            sleep = 3000
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)

            local foundCheckin = false
            for id, hospital in pairs(Config.Hospitals) do
                for _, v in pairs(hospital["checking"] or {}) do
                    local dist = #(playerCoords - vec3(v.x, v.y, v.z))
                    if (dist < 3.0) and (BodyDamage.isDead or BodyDamage.inLastStand) and not IsInsurvivable(BodyDamage) then
                        foundCheckin = id
                    end
                end
            end

            if foundCheckin and not checkin then
                TriggerEvent('osp_ambulance:checkin', {hospitalID = foundCheckin})
                foundCheckin = false
                Wait(10*1000)
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    Wait(1000)
    while true do
        if PlayerLoaded then
            TriggerServerEvent('osp_ambulance:RetreivePlayerDamageData', BodyDamage)
            TriggerServerEvent("hospital:server:SetArmourStatus", BodyDamage.playerArmour)
        end
        Wait(Config.SavePlayerDataTimer)
    end
end)

CreateThread(function()
    WaitUntilBodyDamageReady()
    while true do
        ProcessRunStuff()
        Wait(5000)
    end
end)

CreateThread(function()
    WaitUntilBodyDamageReady()
    while true do
        ProcessSideEffects()
        Wait(Config.SideEffectsTime)
    end
end)

CreateThread(function()
    WaitUntilBodyDamageReady()
    if Config.BleedEffect then
        while true do
            if ShouldPlayBleedEffect() then
                BleedEffect()
            end
            Wait(Config.BleedTime)
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 2000
        if isInHospitalBed and canLeaveBed then
            sleep = 3
            textUi(GetLang().text.bed_out)

            if IsControlJustReleased(0, 38) or IsDisabledControlJustReleased(0, 38) then
                removeTextUi()
                LeaveBed()
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 2
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

CreateThread(function()
    while not PlayerLoaded do
        Wait(500)
    end
    if Config.Decay then
        while true do
            Wait(Config.decayTick)
            local invItems = GetMedicalInventoryItems()

            if not invItems then
                print('^1 UNABLE TO GET INVENTORY ITEMS, TRY RAISING Config.decayTick AND MAKE SURE TO CONFIGURE THE SCRIPT')
            else
                for key, item in pairs(invItems) do
                    local metadata  = item.info
                    local name  = item.item

                    if metadata and name:find("blood") and name:find("ml") then
                        local durability = metadata.quality or metadata.durability

                        if durability and durability > 0 then
                            local newDurability = durability - (Config.decayTick / Config.decayTime) * 100
                            newDurability = round(newDurability, 2)

                            if newDurability <= 0 then
                                -- set blood to expired if durability is below 0
                                newDurability = 0

                                TriggerServerEvent('osp_ambulance:removeItem', name, 1)
                                TriggerServerEvent('osp_ambulance:addItem', 'expiredblood', 1)
                            end

                            TriggerServerEvent('osp_ambulance:setItemMetadata', item.slot, {quality = newDurability})
                            DebugPrint('^2 Updated blood quality for item: ' .. durability .. ' in slot: ' .. key .. ' to ' .. newDurability)
                        end
                    end
                end
            end
            invItems = {}
        end
    end
end)
