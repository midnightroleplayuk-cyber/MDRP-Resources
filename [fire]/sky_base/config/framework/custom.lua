-- Set Config.framework = "custom" to enable this shared framework template.
if Sky.Config.framework ~= "custom" then return end

Sky.FW = {}

-- Client integration:
-- Map your framework's client events to the normalized sky_base events below.
-- TriggerEvent("sky_base:playerLoaded")
-- TriggerEvent("sky_base:updateAccountMoney", account_name, amount)
-- TriggerEvent("sky_base:enteredVehicle", vehicle, plate, seat)
-- TriggerEvent("sky_base:exitedVehicle", vehicle, plate, seat)
-- TriggerEvent("sky_base:inventoryUpdated")
-- TriggerEvent("sky_base:updateJob", job)

if not IsDuplicityVersion() then
    function Sky.FW.GetPlayerState(key, server_id)
        if server_id then
            return Player(server_id).state[key]
        end
        return LocalPlayer.state[key]
    end

    function Sky.FW.GetOwnedVehicleCount()
        return nil, "server_only"
    end

    return
end

-- Server integration:
-- TriggerEvent("sky_base:playerLoaded", source) from the framework's login event.
-- Keep every return shape compatible with SKY_BASE_DOCS_AI.md.

function Sky.FW.IsPlayerOnline(source_or_identifier)
    -- Return false when offline, otherwise true or the matching server id.
    error("Custom framework integration: IsPlayerOnline is not implemented")
end

function Sky.FW.GetIdentifier(source)
    error("Custom framework integration: GetIdentifier is not implemented")
end

function Sky.FW.GetName(source_or_identifier)
    error("Custom framework integration: GetName is not implemented")
end

function Sky.FW.GetFirstname(source_or_identifier)
    error("Custom framework integration: GetFirstname is not implemented")
end

function Sky.FW.GetLastname(source_or_identifier)
    error("Custom framework integration: GetLastname is not implemented")
end

function Sky.FW.GetGender(source_or_identifier)
    error("Custom framework integration: GetGender is not implemented")
end

function Sky.FW.GetBirthdate(source_or_identifier)
    error("Custom framework integration: GetBirthdate is not implemented")
end

function Sky.FW.GetHeight(source)
    -- Optional character height in centimeters; return nil when not stored.
    return nil
end

function Sky.FW.GetPlayerDirectoryQueryConfig()
    -- Return the SQL shape used by the player directory.
    error("Custom framework integration: GetPlayerDirectoryQueryConfig is not implemented")
end

function Sky.FW.GetAccountMoney(source, account)
    -- Normalize money/cash, bank and black_money/black account names.
    error("Custom framework integration: GetAccountMoney is not implemented")
end

function Sky.FW.AddAccountMoney(source, account, amount)
    error("Custom framework integration: AddAccountMoney is not implemented")
end

function Sky.FW.RemoveAccountMoney(source, account, amount, options)
    -- Return false without removing money when the balance is insufficient. When
    -- options.allowOverdraft is true, only the bank account may become negative.
    error("Custom framework integration: RemoveAccountMoney is not implemented")
end

function Sky.FW.GetJobUsers(job_name)
    -- Return { identifier, job_grade, name? } entries.
    error("Custom framework integration: GetJobUsers is not implemented")
end

function Sky.FW.GetJob(source_or_identifier)
    -- Return the job name or an empty string.
    error("Custom framework integration: GetJob is not implemented")
end

function Sky.FW.GetGang(source_or_identifier)
    return nil
end

function Sky.FW.GetGangData(source_or_identifier, action)
    return nil
end

function Sky.FW.GetGangUsers(gang_name)
    -- Return { identifier, job_grade, name? } entries.
    error("Custom framework integration: GetGangUsers is not implemented")
end

function Sky.FW.SetGang(source_or_identifier, gang_name, gang_grade)
    error("Custom framework integration: SetGang is not implemented")
end

function Sky.FW.DoesGangExist(gang_name, grade)
    error("Custom framework integration: DoesGangExist is not implemented")
end

function Sky.FW.GetGangs()
    -- Return { name, label, grades = { { grade, name, label, payment } } } entries.
    error("Custom framework integration: GetGangs is not implemented")
end

function Sky.FW.PrepareEmptyGroupMembership(name, kind, authorize)
    Sky.Debug("error", "[Sky.FW.PrepareEmptyGroupMembership] Group creation vacancy is unsupported on the custom framework: %s", tostring(name))
    return nil, "unsupported_framework"
end

function Sky.FW.ReadGangMemberSnapshot(gang_name, authorize)
    Sky.Debug("error", "[Sky.FW.ReadGangMemberSnapshot] Raw gang membership snapshots are unsupported on the custom framework: %s", tostring(gang_name))
    return nil, "unsupported_framework"
end

function Sky.FW.ReadJobMemberSnapshot(job_name, authorize)
    Sky.Debug("error", "[Sky.FW.ReadJobMemberSnapshot] Raw Core membership snapshots are unsupported on the custom framework: %s", tostring(job_name))
    return nil, "unsupported_framework"
end

function Sky.FW.ReadJobAdoptionSnapshot(job_name, aliases)
    Sky.Debug("error", "[Sky.FW.ReadJobAdoptionSnapshot] Persisted adoption snapshots are unsupported on the custom framework: %s", tostring(job_name))
    return nil, "unsupported_framework"
end

function Sky.FW.SetJob(source_or_identifier, job_name, job_grade)
    error("Custom framework integration: SetJob is not implemented")
end

function Sky.FW.RefreshJobs()
    error("Custom framework integration: RefreshJobs is not implemented")
end

function Sky.FW.UpdateJob(job_name, data, skip_check)
    error("Custom framework integration: UpdateJob is not implemented")
end

function Sky.FW.AddJobGrade(job_name, grade_data, skip_check)
    error("Custom framework integration: AddJobGrade is not implemented")
end

function Sky.FW.RemoveJobGrade(job_name, grade, skip_check)
    error("Custom framework integration: RemoveJobGrade is not implemented")
end

function Sky.FW.DoesJobExist(job_name, grade)
    error("Custom framework integration: DoesJobExist is not implemented")
end

function Sky.FW.GetJobs()
    -- Return { name, label, grades = { { grade, name, label, payment } } } entries.
    error("Custom framework integration: GetJobs is not implemented")
end

function Sky.FW.GetPlayers()
    -- Return an array of online server ids.
    error("Custom framework integration: GetPlayers is not implemented")
end

function Sky.FW.IsVehicleOwnedByPlayer(source, plate)
    error("Custom framework integration: IsVehicleOwnedByPlayer is not implemented")
end

function Sky.FW.GetOwnedVehicleCount(source)
    if not IsDuplicityVersion() then
        return nil, "server_only"
    end

    -- Return a non-negative integer for an online character. Keep nil, "unsupported"
    -- until the custom framework has a persistent vehicle ownership lookup.
    return nil, "unsupported"
end

function Sky.FW.GetJobData(source_or_identifier, action)
    -- `action` may be one field name or an array of field names.
    error("Custom framework integration: GetJobData is not implemented")
end

function Sky.FW.GetStatus(source, name)
    -- Return a normalized value from 0 to 100.
    error("Custom framework integration: GetStatus is not implemented")
end

function Sky.FW.ChangePlayerName(source_or_identifier, firstname, lastname)
    error("Custom framework integration: ChangePlayerName is not implemented")
end

function Sky.FW.SetStatus(source, name, value)
    error("Custom framework integration: SetStatus is not implemented")
end

function Sky.FW.RemoveStatus(source, name, amount)
    error("Custom framework integration: RemoveStatus is not implemented")
end

function Sky.FW.IsDead(source)
    error("Custom framework integration: IsDead is not implemented")
end

function Sky.FW.SetPlayerState(source, key, value)
    Player(source).state:set(key, value, true)
end

function Sky.FW.GetPlayerState(source, key)
    return Player(source).state[key]
end

function Sky.FW.GetPlaytime(source)
    -- Return playtime in minutes.
    error("Custom framework integration: GetPlaytime is not implemented")
end

function Sky.FW.HasCommandPermission(source, ace_permission)
    -- Console source 0 must be allowed.
    error("Custom framework integration: HasCommandPermission is not implemented")
end

function Sky.FW.IsPlayerVisibleOnCamera(source)
    error("Custom framework integration: IsPlayerVisibleOnCamera is not implemented")
end

function Sky.FW.SetDuty(source, on_duty)
    error("Custom framework integration: SetDuty is not implemented")
end

function Sky.FW.ToggleDuty(source)
    error("Custom framework integration: ToggleDuty is not implemented")
end

function Sky.FW.GetOnDutyCount(job_name)
    -- Return the count followed by an array of matching server ids.
    error("Custom framework integration: GetOnDutyCount is not implemented")
end
