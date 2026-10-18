--[[
  Shared corner-selling server factory.
  Call: require 'server.modules.corner_deal_factory'(JOB_KEY)
]]

return function(JOB_KEY)
    local Inventory = require 'server.modules.inventory'
    local Progression = require 'server.modules.progression'
    local config = lib.load(('jobs.%s.config'):format(JOB_KEY))
    if not config then
        lib.print.error(('[corner] missing config for %s'):format(JOB_KEY))
        return
    end

    -- Corner dealing never "finishes" like other jobs (no cash-out event), so
    -- it can't rely on server:jobs:finishJob to report skill-tree progress —
    -- that callback also tears down the job/lobby, which would interrupt the
    -- always-on dealing loop. Instead, every N accepted sales we award
    -- progression directly and keep dealing running uninterrupted.
    local completionSales = math.max(1, tonumber(config.game and config.game.completion_sales) or 8)

    local job = {}
    local state = { lastOffer = {}, sales = {} }

    function job.start(lobby)
        if not server.exports.beforeJobStart(lobby, lobby.currentJob) then
            return Jobs.abort(lobby.id, locale('job_start_blocked'))
        end
        lobby.currentJob.game = { customerPeds = {} }
        lobby.currentJob.reward = lobby.currentJob.reward or { money = 0, exp = 0 }
        lobby.currentJob.reward.exp = lobby.currentJob.reward.exp or 0
        for _, member in pairs(lobby.members) do
            state.sales[member.source] = 0
        end
        return true
    end

    function job.stop(lobbyId)
        state.lastOffer[lobbyId] = nil
        local lobby = Lobby.getLobbyById(lobbyId)
        if lobby then
            for _, member in pairs(lobby.members) do
                state.sales[member.source] = nil
            end
        end
        return true
    end

    function job.onStepDone(source, lobbyId, stepId)
        local lobby = Lobby.getLobbyById(lobbyId)
        if not lobby or not lobby.currentJob then return false end
        if lobby.currentJob.steps[stepId].done then return false end
        lobby.currentJob.steps[stepId].done = true
        for _, member in pairs(lobby.members) do
            TriggerClientEvent(_e('client:jobs:onStepDone'), member.source, JOB_KEY, stepId, lobby.currentJob)
        end
        return true
    end

    lib.callback.register(_e(('server:jobs:%s:createOffer'):format(JOB_KEY)), function(source, lobbyId, selectedDrugType)
        local lobby = Lobby.getLobbyById(lobbyId)
        if not lobby or not lobby.currentJob then return false end
        if not Lobby.isPlayerInLobby(lobbyId, source) then return false end

        local drugType = selectedDrugType or config.drugKey
        local selectedDrug = config.drugs and config.drugs[drugType]
        if not selectedDrug then return false end

        local offerData = {
            label = selectedDrug.label,
            count = math.random(1, 3),
            price = math.random(selectedDrug.minPrice, selectedDrug.maxPrice),
            itemName = selectedDrug.itemName,
            exp = selectedDrug.exp or 10,
        }
        state.lastOffer[lobbyId] = offerData
        return offerData
    end)

    lib.callback.register(_e(('server:jobs:%s:onOfferAccepted'):format(JOB_KEY)), function(source, lobbyId)
        local lobby = Lobby.getLobbyById(lobbyId)
        if not lobby or not lobby.currentJob then return false end

        local data = state.lastOffer[lobbyId]
        if not data then return false end

        if not Inventory.hasItem(source, data.itemName, data.count) then
            return {
                error = locale('you_do_not_have_required_items', data.label),
                outOfStock = true,
            }
        end

        Inventory.removeItem(source, data.itemName, data.count)

        if config.money_type == 'dirty_money' then
            if Config.DirtyMoney.isItem then
                Inventory.giveItem(source, Config.DirtyMoney.itemName, data.price)
            elseif Config.DirtyMoney.accountName then
                server.playerAddMoney(source, Config.DirtyMoney.accountName, data.price)
            end
        else
            if Config.CleanMoney.isItem then
                Inventory.giveItem(source, Config.CleanMoney.itemName, data.price)
            elseif Config.CleanMoney.accountName then
                server.playerAddMoney(source, Config.CleanMoney.accountName, data.price)
            end
        end

        lobby.currentJob.reward = lobby.currentJob.reward or { money = 0, exp = 0 }
        lobby.currentJob.reward.exp = (lobby.currentJob.reward.exp or 0) + (data.exp or 0)
        state.lastOffer[lobbyId] = nil

        -- Corner dealing has no cash-out event, so award skill-tree progress
        -- directly every `completionSales` sales instead of waiting on
        -- server:jobs:finishJob (which would end the always-on dealing loop).
        state.sales[source] = (state.sales[source] or 0) + 1
        local completed = false
        if state.sales[source] >= completionSales then
            state.sales[source] = 0
            completed = true
            Progression.onJobFinished(source, JOB_KEY, lobby.currentJob)
        end

        return {
            salesProgress = { current = state.sales[source] or 0, target = completionSales },
            completed = completed,
        }
    end)

    if config.setCornerAreaCommand then
        lib.addCommand(config.setCornerAreaCommand, {
            help = locale('corner_deal.commands.desc_set_corner_area'),
        }, function(source)
            TriggerClientEvent(_e(('client:jobs:%s:onUseSetCornerAreaCommand'):format(JOB_KEY)), source)
        end)
    end

    Jobs.register(JOB_KEY, job)
end
