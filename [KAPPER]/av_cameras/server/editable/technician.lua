local reparing = {}
local lastFixed = {}

lib.callback.register("av_cameras:handleFix", function(source,identifier,problem)
    local src = source
    local neededItem = problem == "battery" and Config.BatteryItem or Config.RepairTool
    local hasItem = exports['av_laptop']:hasItem(src, neededItem)
    if Config.UseTechnician and Config.TechnicianJobName then
        local hasJob = exports['av_laptop']:hasJob(src, Config.TechnicianJobName)
        if not hasJob then
            TriggerClientEvent("av_laptop:notification", src, Lang['app_title'], Lang['technician_job_required'], "error")
            warn("Player " .. tostring(src) .. " attempted to fix camera " .. tostring(identifier) .. " without the required job")
            return false
        end
    end
    if not hasItem then
        dbug("Player " .. tostring(src) .. " attempted to fix camera " .. tostring(identifier) .. " without the required item: " .. tostring(neededItem))
        TriggerClientEvent("av_laptop:notification", src, Lang['app_title'], Lang['missing_item'], "error")
        return false
    end
    reparing[src] = {
        identifier = identifier,
        problem = problem,
    }
    return hasItem
end)

lib.callback.register("av_cameras:fixCamera", function(source, identifier)
    local src = source
    local repairData = reparing[src]
    if not repairData or repairData.identifier ~= identifier then
        warn("Player " .. tostring(src) .. " attempted to finish fixing camera " .. tostring(identifier) .. " without starting the repair process")
        return false
    end
    local problem = repairData.problem
    local neededItem = problem == "battery" and Config.BatteryItem or Config.RepairTool
    local shouldRemove = neededItem ~= Config.RepairTool or Config.RemoveToolOnUse
    if shouldRemove then
        local removed = exports['av_laptop']:removeItem(src, neededItem, 1)
        if not removed then
            warn("Player " .. tostring(src) .. " attempted to finish fixing camera " .. tostring(identifier) .. " but failed to remove the required item: " .. tostring(neededItem))
            return false
        end
    end
    reparing[src] = nil
    if problem == "battery" then
        MySQL.update.await("UPDATE `av_cameras` SET battery = 100 WHERE identifier = ?", {identifier})
    end
    lastFixed[identifier] = lastFixed[identifier] or 0
    local now = os.time()
    if now - lastFixed[identifier] >= 300 then -- 5 minutes cooldown to prevent abuse
        lastFixed[identifier] = now
        if Config.FixingPayment then
            exports['av_laptop']:addMoney(src, Config.MoneyAccount, Config.FixingPayment)
            local msg = string.format(Lang['fixing_payment_received'], Config.FixingPayment)
            TriggerClientEvent("av_laptop:notification", src, Lang['app_title'], msg, "success")
        end
    end
    MySQL.update.await("UPDATE `av_cameras` SET status = 'live' WHERE identifier = ?", {identifier})
    local updated = MySQL.single.await("SELECT * FROM `av_cameras` WHERE identifier = ?", {identifier})
    updated['coords'] = updated.coords and json.decode(updated.coords) or {}
    updated['settings'] = updated.settings and json.decode(updated.settings) or {}
    allCameras[identifier] = updated
    TriggerClientEvent("av_cameras:cameraUpdated", -1, updated)
    return updated
end)