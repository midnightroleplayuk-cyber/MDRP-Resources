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
    paintTaskMode = 'full', -- full | panels
    paintDurationMs = 14000,
    defaultTaskDurationMs = 4500,
    enforceTaskOrder = true,
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