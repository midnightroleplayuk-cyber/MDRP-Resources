return function(JOB_KEY)
    local Utils = require 'client.modules.utils'
    local config = lib.load(('jobs.%s.config'):format(JOB_KEY))
    if not config then
        lib.print.error(('[corner] missing config for %s'):format(JOB_KEY))
        return
    end

    local drugKey = config.drugKey
    local drugData = drugKey and config.drugs and config.drugs[drugKey] or nil
    if not drugData then
        for key, value in pairs(config.drugs or {}) do
            drugKey = key
            drugData = value
            break
        end
    end

    local HANDOFF = {
        dict = 'mp_common',
        give = 'givetake1_a',
        take = 'givetake1_b',
        flag = 49,
        duration = 2800,
    }

    -- Fallback props when a corner config omits handoff.drug_prop
    local DEFAULT_DRUG_PROPS = {
        weed = 'bkr_prop_weed_bag_01a',
        coke = 'prop_drug_package_02',
        meth = 'prop_meth_bag_01',
        oxy  = 'prop_cs_pills',
    }

    local job = {}
    local state = {
        selectedAreaIndex = nil,
        salesInArea = 0,
        salesUntilRotate = 3,
        rotating = false,
        workingStatus = false,
        workingThreadStatus = 'off',
        areaBlip = { coords = nil, radius = nil },
        customerPed = { entity = nil, netId = nil },
        handProps = {},
    }

    local function addBlipRadius(center, radius)
        local blip = AddBlipForRadius(center.x, center.y, center.z, radius)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, config.blips.area.color or 5)
        SetBlipAlpha(blip, 75)
        SetBlipAsShortRange(blip, true)
        return blip
    end

    local function resolveAreaIndex(index)
        if index == nil then return nil end
        if type(index) == 'string' then index = tonumber(index) end
        if not index or not config.game.areas[index] then return nil end
        return index
    end

    local function getSelectedArea()
        local index = resolveAreaIndex(state.selectedAreaIndex)
        if not index then return nil, nil end
        return config.game.areas[index], index
    end

    local function isPlayerInSelectedArea(playerCoords)
        local selectedArea = getSelectedArea()
        if not selectedArea then return false end
        local limit = math.max(25.0, selectedArea.radius or 25.0)
        return #(playerCoords - selectedArea.coords) <= limit
    end

    local function clearAreaBlips()
        if state.areaBlip.coords then RemoveBlip(state.areaBlip.coords) end
        if state.areaBlip.radius then RemoveBlip(state.areaBlip.radius) end
        state.areaBlip = { coords = nil, radius = nil }
    end

    local function setAreaBlips(area)
        clearAreaBlips()
        if not area or not area.coords then return end
        state.areaBlip = {
            coords = Utils.addBlip(area.coords, config.blips.area, true),
            radius = addBlipRadius(area.coords, math.max(25, area.radius or 25)),
        }
        Utils.setStepWaypoint(area.coords, config.blips.area)
    end

    local function rollSalesUntilRotate()
        local rot = config.game.rotate_after_sales or { min = 2, max = 4 }
        local lo = math.max(1, rot.min or 2)
        local hi = math.max(lo, rot.max or 4)
        return math.random(lo, hi)
    end

    --- Pick a random area index, optionally excluding the current one.
    local function pickAreaIndex(exclude)
        local areas = config.game.areas or {}
        local candidates = {}
        for i = 1, #areas do
            if i ~= exclude then
                candidates[#candidates + 1] = i
            end
        end
        if #candidates == 0 then
            return (#areas > 0) and 1 or nil
        end
        return candidates[math.random(1, #candidates)]
    end

    local function assignCornerArea(index, opts)
        opts = opts or {}
        local areas = config.game.areas or {}
        if #areas == 0 then return nil, nil end

        index = resolveAreaIndex(index) or pickAreaIndex(opts.exclude)
        if not index then return nil, nil end

        state.selectedAreaIndex = index
        state.salesInArea = 0
        state.salesUntilRotate = rollSalesUntilRotate()
        state.rotating = false

        local area = areas[index]
        setAreaBlips(area)

        if opts.notify ~= false then
            local msg = opts.rotate
                and (locale('corner_deal.area_rotated', area.label, state.salesUntilRotate)
                    or ('Heat\'s up — move to %s. Hold for ~%s more sales.'):format(area.label, state.salesUntilRotate))
                or (locale('corner_deal.area_assigned', area.label)
                    or ('Corner assigned: %s — head there to deal.'):format(area.label))
            Utils.notify(msg, opts.rotate and 'error' or 'inform')
        end

        return area, index
    end

    local function getCustomerSpawnCoords(nearCoords, maxRadius)
        local minDist = 8.0
        local maxDist = math.max(minDist + 2.0, math.min(maxRadius or 18.0, 22.0))
        local angle = math.random() * math.pi * 2
        local dist = minDist + math.random() * (maxDist - minDist)
        return vector3(
            nearCoords.x + math.cos(angle) * dist,
            nearCoords.y + math.sin(angle) * dist,
            nearCoords.z
        )
    end

    local function configureCustomerPed(ped)
        SetEntityAsMissionEntity(ped, true, true)
        SetPedDefaultComponentVariation(ped)
        SetEntityInvincible(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedCanRagdoll(ped, false)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 17, true)
        SetPedCombatAttributes(ped, 46, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        SetPedKeepTask(ped, true)
        FreezeEntityPosition(ped, false)
    end

    -- ClearPedTasksImmediately + a fresh TaskGoToCoordAnyMeans interrupts the
    -- ped's current navmesh path, causing a visible stop/stutter mid-stride.
    -- Only worth paying that cost when the destination actually moved or the
    -- ped genuinely stopped making progress — not on every re-check tick.
    local function sendCustomerToPlayer(ped, force)
        if not DoesEntityExist(ped) then return end
        local dest = GetEntityCoords(cache.ped)
        local pedCoords = GetEntityCoords(ped)
        local tracker = state.customerPed

        if not force and tracker.lastDest then
            local destUnchanged = #(dest - tracker.lastDest) < 3.0
            local pedMoved = tracker.lastPos and #(pedCoords - tracker.lastPos) > 0.3
            if destUnchanged and pedMoved then
                tracker.lastPos = pedCoords
                return
            end
        end

        tracker.lastDest = dest
        tracker.lastPos = pedCoords
        ClearPedTasksImmediately(ped)
        TaskGoToCoordAnyMeans(ped, dest.x, dest.y, dest.z, 1.15, 0, false, 786603, 0.0)
        SetPedKeepTask(ped, true)
    end

    local function createCustomerPed(nearCoords)
        local models = config.game.pedModels
        if not models or #models == 0 then return nil end

        local modelName = models[math.random(1, #models)]
        local model = type(modelName) == 'string' and joaat(modelName) or modelName
        local coords = getCustomerSpawnCoords(nearCoords, 18.0)

        lib.requestModel(model)
        local ped = CreatePed(4, model, coords.x, coords.y, coords.z, math.random(0, 360) + 0.0, false, true)
        local timeout = GetGameTimer() + 5000
        while not DoesEntityExist(ped) and GetGameTimer() < timeout do Wait(0) end
        if not DoesEntityExist(ped) then
            SetModelAsNoLongerNeeded(model)
            return nil
        end

        configureCustomerPed(ped)
        SetModelAsNoLongerNeeded(model)

        state.customerPed.entity = ped
        state.customerPed.netId = nil

        sendCustomerToPlayer(ped)
        Utils.addBlip(ped, config.blips.customer)
        Utils.notify(locale('corner_deal.customer_incoming'), 'inform')
        return ped
    end

    local function clearHandProps()
        for _, ent in pairs(state.handProps) do
            if ent and DoesEntityExist(ent) then
                DetachEntity(ent, true, true)
                DeleteEntity(ent)
            end
        end
        state.handProps = {}
    end

    local function attachPropToPed(ped, modelName, bone, ox, oy, oz, rx, ry, rz)
        if not ped or not DoesEntityExist(ped) or not modelName then return nil end
        lib.requestModel(modelName)
        local coords = GetEntityCoords(ped)
        local obj = CreateObject(joaat(modelName), coords.x, coords.y, coords.z + 0.2, true, true, false)
        local timeout = GetGameTimer() + 3000
        while not DoesEntityExist(obj) and GetGameTimer() < timeout do Wait(0) end
        if not DoesEntityExist(obj) then
            SetModelAsNoLongerNeeded(modelName)
            return nil
        end
        SetEntityCollision(obj, false, true)
        AttachEntityToEntity(
            obj, ped, GetPedBoneIndex(ped, bone or 28422),
            ox or 0.05, oy or 0.0, oz or -0.02,
            rx or 0.0, ry or 90.0, rz or 0.0,
            true, true, false, true, 1, true
        )
        SetModelAsNoLongerNeeded(modelName)
        state.handProps[#state.handProps + 1] = obj
        return obj
    end

    local function resolveHandoffProps()
        local handoff = (config.game and config.game.handoff) or {}
        local drugProp = handoff.drug_prop
            or (drugKey and DEFAULT_DRUG_PROPS[drugKey])
            or 'prop_drug_package_02'
        local cashProp = handoff.cash_prop or 'prop_anim_cash_note'
        local duration = handoff.duration or HANDOFF.duration
        return drugProp, cashProp, duration
    end

    local function stopHandoffAnims(otherPed)
        local ped = cache.ped
        if IsEntityPlayingAnim(ped, HANDOFF.dict, HANDOFF.give, 3) then
            StopAnimTask(ped, HANDOFF.dict, HANDOFF.give, 1.0)
        end
        if otherPed and DoesEntityExist(otherPed) and IsEntityPlayingAnim(otherPed, HANDOFF.dict, HANDOFF.take, 3) then
            StopAnimTask(otherPed, HANDOFF.dict, HANDOFF.take, 1.0)
        end
        clearHandProps()
    end

    --- Face buyer, attach drug + cash props, play give/take exchange.
    local function playDealHandoff(otherPed)
        if not otherPed or not DoesEntityExist(otherPed) then return false end

        local ped = cache.ped
        local drugProp, cashProp, duration = resolveHandoffProps()

        FreezeEntityPosition(otherPed, true)
        TaskTurnPedToFaceEntity(ped, otherPed, 650)
        TaskTurnPedToFaceEntity(otherPed, ped, 650)
        Wait(550)

        -- Player offers product; buyer holds cash for the swap
        attachPropToPed(ped, drugProp, 28422, 0.05, 0.0, -0.02, 0.0, 90.0, 0.0)
        attachPropToPed(otherPed, cashProp, 28422, 0.08, 0.0, -0.01, 0.0, 0.0, 0.0)

        lib.requestAnimDict(HANDOFF.dict)
        TaskPlayAnim(ped, HANDOFF.dict, HANDOFF.give, 8.0, -8.0, duration, HANDOFF.flag, 0.0, false, false, false)
        TaskPlayAnim(otherPed, HANDOFF.dict, HANDOFF.take, 8.0, -8.0, duration, HANDOFF.flag, 0.0, false, false, false)

        local endsAt = GetGameTimer() + duration
        while GetGameTimer() < endsAt do
            if not DoesEntityExist(otherPed) then break end
            Wait(50)
        end

        stopHandoffAnims(otherPed)
        if DoesEntityExist(otherPed) then
            ClearPedTasks(otherPed)
            FreezeEntityPosition(otherPed, true)
        end
        ClearPedTasks(ped)
        return true
    end

    local cornerHoldingTask

    local function waitUntilInCornerThenStart()
        CreateThread(function()
            while state.workingStatus and client.currentJob and client.currentJob.name == JOB_KEY do
                if state.rotating then
                    Wait(400)
                elseif state.workingThreadStatus ~= 'off' then
                    Wait(500)
                elseif isPlayerInSelectedArea(GetEntityCoords(cache.ped)) then
                    if not cornerHoldingTask() then
                        state.workingStatus = false
                    elseif client.currentJob and not client.currentJob.steps[2].done then
                        lib.callback.await(_e('server:jobs:onStepDone'), false, client.lobby.id, 2)
                    end
                    return
                else
                    Wait(750)
                end
            end
        end)
    end

    local function rotateCornerArea()
        local _, current = getSelectedArea()
        state.rotating = true
        -- Pause dealing until the player reaches the new block
        if state.workingThreadStatus == 'on' then
            state.workingThreadStatus = 'idle'
        end

        local area = assignCornerArea(nil, { exclude = current, rotate = true })
        if not area then
            state.rotating = false
            return
        end

        Utils.notify(locale('corner_deal.go_to_corner') or 'Head to your marked corner to start dealing.', 'inform')

        CreateThread(function()
            while state.workingStatus and client.currentJob and client.currentJob.name == JOB_KEY do
                if isPlayerInSelectedArea(GetEntityCoords(cache.ped)) then
                    state.rotating = false
                    while state.workingThreadStatus ~= 'off' and state.workingThreadStatus ~= 'idle' do
                        Wait(200)
                    end
                    state.workingThreadStatus = 'off'
                    if state.workingStatus then
                        cornerHoldingTask()
                    end
                    return
                end
                Wait(750)
            end
            state.rotating = false
        end)
    end

    cornerHoldingTask = function()
        if state.workingThreadStatus == 'on' then return false end
        if state.rotating then return false end

        local selectedArea = getSelectedArea()
        if not selectedArea then
            Utils.notify(locale('corner_deal.select_area_first'), 'error')
            return false
        end

        local playerPed = cache.ped
        local playerCoords = GetEntityCoords(playerPed)

        if not isPlayerInSelectedArea(playerCoords) then
            Utils.notify(locale('corner_deal.cant_corner_here'), 'error')
            return false
        end

        if IsEntityDead(playerPed) then
            Utils.notify(locale('corner_deal.cant_corner_while_dead'), 'error')
            return false
        end

        if lib.callback.await(_e('server:jobs:getCopCount'), false) < (config.requiredMinCopCount or 0) then
            Utils.notify(locale('corner_deal.not_enough_police'), 'error')
            return false
        end

        if not drugKey then
            Utils.notify(locale('corner_deal.select_drug_first'), 'error')
            return false
        end

        state.workingThreadStatus = 'on'
        Utils.notify(locale('corner_deal.on_started'), 'success')

        Citizen.CreateThread(function()
            if not client.currentJob then return end

            local customerPed = createCustomerPed(playerCoords)
            if not customerPed then
                Utils.notify(locale('corner_deal.customer_spawn_failed'), 'error')
                state.workingThreadStatus = 'off'
                state.workingStatus = false
                return
            end

            local reachedTarget = false
            local timeout = 90000
            local startTime = GetGameTimer()
            local lastTaskAt = 0
            local dealAccepted = false
            local outOfStock = false

            while state.workingThreadStatus == 'on' do
                if DoesEntityExist(customerPed) then
                    local customerCoords = GetEntityCoords(customerPed)
                    local targetCoords = GetEntityCoords(cache.ped)
                    local distance = #(targetCoords - customerCoords)

                    if distance <= 2.2 then
                        ClearPedTasksImmediately(customerPed)
                        TaskStandStill(customerPed, -1)
                        FreezeEntityPosition(customerPed, true)
                        reachedTarget = true
                        local heading = GetHeadingFromVector_2d(
                            targetCoords.x - customerCoords.x,
                            targetCoords.y - customerCoords.y
                        )
                        SetEntityHeading(customerPed, heading)
                        break
                    end

                    if GetGameTimer() - lastTaskAt > 2500 then
                        sendCustomerToPlayer(customerPed)
                        lastTaskAt = GetGameTimer()
                    end
                else
                    Utils.notify(locale('corner_deal.customer_spawn_failed'), 'error')
                    break
                end

                if GetGameTimer() - startTime > timeout then
                    Utils.notify(locale('corner_deal.customer_given_up'), 'error')
                    break
                end

                Wait(200)
            end

            if reachedTarget and state.workingThreadStatus == 'on' then
                local offerData = lib.callback.await(
                    _e(('server:jobs:%s:createOffer'):format(JOB_KEY)),
                    false, client.lobby.id, drugKey
                )

                if not offerData then
                    state.workingThreadStatus = 'off'
                    state.workingStatus = false
                else
                    local Dialogue = require 'client.modules.dialogue'
                    local price = offerData.price or offerData.amount or '?'
                    local qty = offerData.count or offerData.qty or offerData.amount or 1
                    local accepted = Dialogue.confirm(
                        customerPed,
                        ('Looking to score? I\'ll take %sx for $%s.'):format(qty, price),
                        locale('corner_deal.offer_accept_key') or 'Deal',
                        locale('corner_deal.offer_refuse_key') or 'No deal'
                    )
                    if accepted then
                        local response = lib.callback.await(
                            _e(('server:jobs:%s:onOfferAccepted'):format(JOB_KEY)),
                            false, client.lobby.id
                        )
                        if type(response) == 'table' and response.error then
                            Utils.notify(response.error, 'error')
                            if response.outOfStock then
                                outOfStock = true
                            end
                        else
                            playDealHandoff(customerPed)
                            Utils.notify(locale('corner_deal.offer_accepted'), 'success')
                            dealAccepted = true
                            state.salesInArea = (state.salesInArea or 0) + 1

                            -- Push the live sales-progress bar (step 3 has no other
                            -- "done" trigger since corner dealing never finishes).
                            if type(response) == 'table' and response.salesProgress and client.currentJob then
                                local step3 = client.currentJob.steps and client.currentJob.steps[3]
                                if step3 then
                                    step3.progress = response.salesProgress
                                    client.sendReactMessage('setCurrentJob', client.currentJob)
                                end
                                if response.completed then
                                    Utils.notify(locale('corner_deal.progress_banked') or 'Run banked — skill progress earned!', 'success')
                                end
                            end
                        end
                    else
                        Utils.notify(locale('corner_deal.offer_refused'), 'error')
                    end
                end
            end

            if DoesEntityExist(customerPed) then
                state.customerPed = {}
                local refusedOrLeft = not reachedTarget or not dealAccepted
                Utils.dismissPedWalkAway(customerPed, {
                    flee = refusedOrLeft,
                    speed = refusedOrLeft and 1.8 or 1.15,
                })
            else
                state.customerPed = {}
            end

            Utils.hideTextUI()
            Wait(800)

            if state.workingThreadStatus == 'idle' then
                state.workingThreadStatus = 'off'
                return
            end

            state.workingThreadStatus = 'off'

            -- Out of product — the mission ends here, same as any other job
            -- finishing (payout, progression, cooldown, lobby teardown).
            if outOfStock then
                state.workingStatus = false
                Utils.notify(locale('corner_deal.out_of_stock') or 'Out of product — wrapping up the run.', 'error')
                lib.callback.await(_e('server:jobs:finishJob'), false, client.lobby.id)
                return
            end

            if math.random() < (selectedArea.alertChance or 0.2) then
                Utils.triggerPoliceAlert(JOB_KEY, locale('corner_deal'))
            end

            -- Rotate corners after enough sales on this block
            if dealAccepted
                and state.workingStatus
                and not state.rotating
                and (state.salesInArea or 0) >= (state.salesUntilRotate or 3)
            then
                rotateCornerArea()
                return
            end

            local cooldown = (config.game.extra_client_ped_cooldown or 0) * 1000
            if cooldown > 0 then Wait(cooldown) end

            if state.workingStatus and state.workingThreadStatus == 'off' and not state.rotating then
                cornerHoldingTask()
            end
        end)

        return true
    end

    local function openJobSettingsInputDialog()
        -- Area is assigned randomly — players only toggle dealing on/off
        if not resolveAreaIndex(state.selectedAreaIndex) then
            assignCornerArea(nil, { notify = true })
            if client.currentJob and not client.currentJob.steps[1].done then
                lib.callback.await(_e('server:jobs:onStepDone'), false, client.lobby.id, 1)
            end
        end

        local input = Utils.inputDialog(locale('corner_deal.inputs.heading'), {
            {
                type = 'select',
                label = locale('corner_deal.inputs.select_on_working'),
                options = {
                    { label = locale('corner_deal.inputs.options_on_working_on_label'), value = 'on' },
                    { label = locale('corner_deal.inputs.options_on_working_off_label'), value = 'off' },
                },
                description = locale('corner_deal.inputs.select_on_working_description'),
                default = state.workingStatus and 'on' or 'off',
                required = true,
            },
        })
        if not input then return end

        local selectedWorkingStatus = input[1]

        if (selectedWorkingStatus == 'on' and state.workingStatus)
            or (selectedWorkingStatus == 'off' and not state.workingStatus) then
            return
        end

        state.workingStatus = selectedWorkingStatus == 'on'
        if not state.workingStatus then
            if state.workingThreadStatus == 'on' then
                state.workingThreadStatus = 'idle'
            end
            state.rotating = false
            return
        end

        while state.workingThreadStatus ~= 'off' do Wait(500) end

        if not isPlayerInSelectedArea(GetEntityCoords(cache.ped)) then
            Utils.notify(locale('corner_deal.go_to_corner') or 'Head to your marked corner to start dealing.', 'inform')
            waitUntilInCornerThenStart()
            return
        end

        if not cornerHoldingTask() then
            state.workingStatus = false
        end
        if client.currentJob and not client.currentJob.steps[2].done then
            lib.callback.await(_e('server:jobs:onStepDone'), false, client.lobby.id, 2)
        end
    end

    function job.cleanup()
        stopHandoffAnims(state.customerPed and state.customerPed.entity)
        clearHandProps()
        clearAreaBlips()
        if state.customerPed.entity and DoesEntityExist(state.customerPed.entity) then
            DeleteEntity(state.customerPed.entity)
        end
        state.areaBlip = {}
        state.customerPed = {}
        state.selectedAreaIndex = nil
        state.salesInArea = 0
        state.rotating = false
        state.workingStatus = false
        state.workingThreadStatus = 'off'
        Utils.hideTextUI()
    end

    function job.start()
        CreateThread(function()
            local timeout = GetGameTimer() + 4000
            while client.uiOpen and GetGameTimer() < timeout do
                Wait(50)
            end
            Wait(150)
            if not client.currentJob or client.currentJob.name ~= JOB_KEY then return end
            job.onStepStart(1)
        end)
        return true
    end

    function job.stop()
        job.cleanup()
        return true
    end

    function job.onStepStart(stepIndex)
        if stepIndex <= 1 then
            CreateThread(function()
                -- Random first corner before the work toggle dialog
                if not resolveAreaIndex(state.selectedAreaIndex) then
                    assignCornerArea(nil, { notify = true })
                    if client.currentJob and not client.currentJob.steps[1].done then
                        lib.callback.await(_e('server:jobs:onStepDone'), false, client.lobby.id, 1)
                    end
                end
                openJobSettingsInputDialog()
            end)
            return true
        end
        return stepIndex <= 3
    end

    function job.onStepDone(stepIndex)
        return job.onStepStart(stepIndex + 1)
    end

    RegisterNetEvent(_e(('client:jobs:%s:onUseSetCornerAreaCommand'):format(JOB_KEY)), function()
        if not client.currentJob or client.currentJob.name ~= JOB_KEY then return end
        CreateThread(openJobSettingsInputDialog)
    end)

    Jobs.register(JOB_KEY, job)
end
