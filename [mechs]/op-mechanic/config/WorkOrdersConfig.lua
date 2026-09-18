Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Work orders (paid tuning → mechanic tasks)
-- Parts/tools -> Config.Parts
-- ──────────────────────────────────────────────────────────────────────────────
Config.WorkOrders = {
    enabled = true,

    instantOptions = {
        --'tuning.antilag',
    },
    instantPropKeys = {
        --['tuning.antilag'] = { 'antilag' },
    },
    interactDistance = 2.25,
    oneOrderPerVehicle = true,
    oneActiveOrderPerMechanic = true,
    rollbackOnCancel = true,
    rollbackOnDisconnect = true,
    persistOnComplete = true,
    allowCustomerCancel = true,
    customerCancelRefund = true,
    mechanicCancelRefund = true,
    autoFinishOnLastTask = true,
    paintTaskMode = 'panels', -- full | panels
    paintDurationMs = 14000,
    defaultTaskDurationMs = 4500,
    enforceTaskOrder = true,
    -- false = Start WO without all parts; inventory is checked when you begin each task
    -- true  = classic: must hold every required part before Start
    checkPartsOnStart = false,
    showGuideMarker = true,
    guideMarkerHideDistance = 1.05,
    targetZoneRadius = 0.9,
    progressBar = {
        enabled = true,
        durationMs = 4000,
        useTaskDuration = false,
        style = 'circle', -- circle | bar
        canCancel = true,
    },
    minigames = {
        enabled = true,
        closeDelayMs = 900,
        timeoutMs = 180000,
    },
}