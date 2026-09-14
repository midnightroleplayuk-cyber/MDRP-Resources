-- Server event for receiving log requests from client
-- This keeps the webhook URL server-side only
RegisterNetEvent('devhub_licenses:server:sendLog', function(data)
    local source = source
    if Config.LogsWebhook and Config.LogsWebhook ~= "" then
        Core.SendLog(source, Config.LogsWebhook, data)
    end
end)

OpenServerFunctions = {

    ---Called AFTER a legitimate license has been successfully created and saved to the database.
    ---Use this to sync with external systems (MDT, Discord logs, achievements, etc.)
    ---@param source number Server ID of the player who received the license
    ---@param licenseId string Unique license ID (e.g. "A1B2C3D4")
    ---@param templateName string Template name (e.g. "driving_license")
    ---@param templateLabel string Human-readable template label (e.g. "Driving License")
    ---@param licenseData table Full license data table including all DataFields values and avatar URL
    ---@param expirationDate number Unix timestamp of when the license expires (0 = never)
    OnLicenseCreated = function(source, licenseId, templateName, templateLabel, licenseData, expirationDate)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Created",
                licenseId = licenseId,
                templateName = templateName,
                templateLabel = templateLabel,
                ownerName = licenseData.fullName or "Unknown",
                expirationDate = expirationDate > 0 and os.date("%Y-%m-%d", expirationDate) or "Never",
            })
        end
    end,

    ---Called AFTER a fake license has been successfully created and saved to the database.
    ---@param source number Server ID of the player who created the fake
    ---@param licenseId string Unique license ID
    ---@param templateName string Template name that was faked
    ---@param templateLabel string Human-readable template label
    ---@param fakeData table The fake data fields used on the license
    OnFakeLicenseCreated = function(source, licenseId, templateName, templateLabel, fakeData)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Fake License Created",
                licenseId = licenseId,
                templateName = templateName,
                templateLabel = templateLabel,
                fakeName = fakeData.fullName or "Unknown",
            })
        end
    end,

    ---Called AFTER a license status has been changed (active → suspended, revoked, etc.)
    ---@param source number|nil Server ID of who performed the change (nil if system/offline)
    ---@param owner string Identifier of the license owner
    ---@param licenseId string The license ID that was changed
    ---@param templateName string Template name of the license
    ---@param oldStatus string Previous status ("active", "suspended", "lost", "expired", "revoked")
    ---@param newStatus string New status
    ---@param reason string Reason provided for the status change
    ---@param suspensionTime number|nil Unix timestamp when suspension ends (nil if not suspended)
    OnLicenseStatusChanged = function(source, owner, licenseId, templateName, oldStatus, newStatus, reason, suspensionTime)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Status Changed",
                licenseId = licenseId,
                templateName = templateName,
                ownerIdentifier = owner,
                oldStatus = oldStatus,
                newStatus = newStatus,
                reason = reason or "No reason",
                suspensionUntil = suspensionTime and os.date("%Y-%m-%d %H:%M", suspensionTime) or "N/A",
            })
        end
    end,

    ---Called AFTER one or more data fields on an existing license were overwritten through the
    ---updateLicenseData export. Fires for offline owners too (source is then 0).
    ---@param source number Server ID of who performed the change (0 if system/offline)
    ---@param owner string Identifier of the license's original owner
    ---@param licenseId string The license ID that was patched
    ---@param templateName string Template name of the license
    ---@param changed table Map of fieldName -> { from = oldValue, to = newValue }
    ---@param reason string|nil Reason passed to the export
    OnLicenseDataUpdated = function(source, owner, licenseId, templateName, changed, reason)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            local fields = {}
            for field in pairs(changed or {}) do fields[#fields + 1] = field end
            table.sort(fields)
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Data Updated",
                licenseId = licenseId,
                templateName = templateName,
                ownerIdentifier = owner,
                fields = table.concat(fields, ", "),
                reason = reason or "No reason",
            })
        end
    end,

    ---Called AFTER a license has been destroyed (owner set to '-'). License is permanently gone from the player.
    ---@param source number Server ID of the player who destroyed the license
    ---@param licenseId string The destroyed license ID
    ---@param templateName string Template name of the destroyed license
    ---@param identifier string Identifier of the player who owned it
    OnLicenseDestroyed = function(source, licenseId, templateName, identifier)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Destroyed",
                licenseId = licenseId,
                templateName = templateName,
                ownerIdentifier = identifier,
            })
        end
    end,

    ---Called AFTER a license has been transferred from one player to another via the "give" action.
    ---@param source number Server ID of the player who gave the license
    ---@param targetSource number Server ID of the player who received the license
    ---@param licenseId string The license ID that was transferred
    ---@param templateName string Template name
    ---@param giverIdentifier string Identifier of the giving player
    ---@param receiverIdentifier string Identifier of the receiving player
    OnLicenseGiven = function(source, targetSource, licenseId, templateName, giverIdentifier, receiverIdentifier)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Given",
                licenseId = licenseId,
                templateName = templateName,
                giverIdentifier = giverIdentifier,
                receiverIdentifier = receiverIdentifier,
                targetServerId = targetSource,
            })
        end
    end,

    ---Called AFTER a license has been taken/confiscated from another player.
    ---@param source number Server ID of the player who took the license
    ---@param targetSource number Server ID of the player it was taken from
    ---@param licenseId string The license ID that was taken
    ---@param templateName string Template name
    ---@param takerIdentifier string Identifier of the player who took it
    ---@param victimIdentifier string Identifier of the player it was taken from
    OnLicenseTaken = function(source, targetSource, licenseId, templateName, takerIdentifier, victimIdentifier)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Taken/Confiscated",
                licenseId = licenseId,
                templateName = templateName,
                takerIdentifier = takerIdentifier,
                victimIdentifier = victimIdentifier,
                victimServerId = targetSource,
            })
        end
    end,

    ---Called AFTER a license permission has been granted to a player.
    ---Return false to prevent the grant (e.g. custom permission checks beyond job grade).
    ---@param source number Server ID of who granted the permission
    ---@param identifier string Identifier of the player receiving the permission
    ---@param templateName string Template name being granted
    ---@param templateLabel string Human-readable template label
    ---@return boolean allowed Return false to block the grant, true (or nil) to allow
    OnPermissionGranted = function(source, identifier, templateName, templateLabel)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Permission Granted",
                targetIdentifier = identifier,
                templateName = templateName,
                templateLabel = templateLabel,
            })
        end
        return true
    end,

    ---Called AFTER a license permission has been revoked from a player.
    ---@param source number Server ID of who revoked the permission
    ---@param identifier string Identifier of the player losing the permission
    ---@param templateName string Template name being revoked
    ---@param templateLabel string Human-readable template label
    OnPermissionRevoked = function(source, identifier, templateName, templateLabel)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Permission Revoked",
                targetIdentifier = identifier,
                templateName = templateName,
                templateLabel = templateLabel,
            })
        end
    end,

    ---Called AFTER a license template has been created or updated by an admin.
    ---@param source number Server ID of the admin who saved the template
    ---@param templateName string Template name (unique key)
    ---@param templateData table Full template data (label, components, layout, etc.)
    ---@param isUpdate boolean True if updating existing template, false if new creation
    OnTemplateSaved = function(source, templateName, templateData, isUpdate)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = isUpdate and "Template Updated" or "Template Created",
                templateName = templateName,
                templateLabel = templateData.label or templateName,
            })
        end
    end,

    ---Called AFTER a player's license data has been fully loaded from the database.
    ---Use this for initial syncs with external systems when a player connects.
    ---@param source number Server ID of the player
    ---@param identifier string Player identifier
    ---@param licenses table Table of all player licenses (keyed by license ID)
    ---@param granted table Table of granted template permissions (keyed by template name)
    OnPlayerLoaded = function(source, identifier, licenses, granted)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            local licenseCount = 0
            for _ in pairs(licenses or {}) do licenseCount = licenseCount + 1 end
            local grantCount = 0
            for _ in pairs(granted or {}) do grantCount = grantCount + 1 end
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Player Loaded",
                identifier = identifier,
                totalLicenses = licenseCount,
                totalGrants = grantCount,
            })
        end
    end,

    ---Called BEFORE a player's data is saved and unloaded from memory (disconnect/resource stop).
    ---@param source number Server ID of the player
    ---@param identifier string Player identifier
    OnPlayerUnloaded = function(source, identifier)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Player Unloaded",
                identifier = identifier,
            })
        end
    end,

    ---Called WHEN a player shows a license to nearby players.
    ---Return false to prevent the license from being shown.
    ---@param source number Server ID of the player showing the license
    ---@param licenseId string The license ID being shown
    ---@param templateName string Template name of the license
    ---@param targetServerId number|nil Specific target player server ID (nil = show to all nearby)
    ---@return boolean allowed Return false to block showing, true (or nil) to allow
    OnLicenseShown = function(source, licenseId, templateName, targetServerId)
        return true
    end,

    ---Called WHEN a player's licenses are being viewed/checked by another player (police search, etc.)
    ---Return false to prevent the check (e.g. require certain job).
    ---@param source number Server ID of the player performing the check
    ---@param targetServerId number Server ID of the player being checked
    ---@return boolean allowed Return false to block the check, true (or nil) to allow
    OnPlayerLicensesChecked = function(source, targetServerId)
        -- Example: Only allow police to check licenses
        -- local job = Core.GetJob(source)
        -- if job.name ~= "police" then return false end
        return true
    end,

    ---Called AFTER a fake ID mission has been completed and reward paid.
    ---@param source number Server ID of the player
    ---@param licenseId string The fake license ID that was delivered
    ---@param templateName string Template name of the delivered fake
    ---@param payment number Amount paid to the player
    OnFakeIdMissionCompleted = function(source, licenseId, templateName, payment)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "Fake ID Mission Completed",
                licenseId = licenseId,
                templateName = templateName,
                paymentReceived = "$" .. tostring(payment),
            })
        end
    end,

    ---Called BEFORE a player picks up (creates) a license at the city hall NPC.
    ---Return false to prevent the pickup (e.g. custom requirements check).
    ---@param source number Server ID of the player
    ---@param templateName string Template name they are trying to pick up
    ---@param paymentMethod string "cash" or "card"
    ---@param chargeAmount number Amount being charged (0 = free)
    ---@return boolean allowed Return false to block the pickup, true (or nil) to allow
    CanPickupLicense = function(source, templateName, paymentMethod, chargeAmount)
        -- Example: Require passing a driving test first
        -- if templateName == "driving_license" and not exports['driving_school']:hasPassed(source) then return false end
        return true
    end,

    ---Called AFTER a license has been successfully picked up and payment processed.
    ---@param source number Server ID of the player
    ---@param templateName string Template name that was picked up
    ---@param paymentMethod string "cash" or "card"
    ---@param chargeAmount number Amount that was charged
    OnLicensePickedUp = function(source, templateName, paymentMethod, chargeAmount)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = "License Picked Up",
                templateName = templateName,
                paymentMethod = paymentMethod,
                chargeAmount = "$" .. tostring(chargeAmount),
            })
        end
    end,

    ---Called BEFORE a player is allowed to start a license exam at the clerk (see configs/s.exams.lua).
    ---Return false to block the attempt (e.g. require a prerequisite license or job first).
    ---@param source number Server ID of the player
    ---@param templateName string Template name the exam grants
    ---@return boolean allowed Return false to block, true (or nil) to allow
    CanStartExam = function(source, templateName)
        -- Example: require the player to already hold an id_card before the driving test
        -- if templateName == "driver_license" and not exports['devhub_licenses']:playerHasLicense(source, "id_card") then return false end
        return true
    end,

    ---Called AFTER a player finishes a license exam (whether they passed or failed).
    ---On a pass the permission has already been granted by the time this fires.
    ---@param source number Server ID of the player
    ---@param templateName string Template name the exam grants
    ---@param passed boolean True if the player scored at or above the passing score
    ---@param score number The player's score as a percentage (0-100)
    ---@param correctCount number Number of questions answered correctly
    ---@param total number Total number of questions asked
    OnExamCompleted = function(source, templateName, passed, score, correctCount, total)
        if Config.LogsWebhook and Config.LogsWebhook ~= "" then
            Core.SendLog(source, Config.LogsWebhook, {
                action = passed and "License Exam Passed" or "License Exam Failed",
                templateName = templateName,
                score = tostring(score) .. "%",
                result = tostring(correctCount) .. "/" .. tostring(total),
            })
        end
    end,
}
