-- Confirm persisted native employment after the existing Sky Hex V1 mutation owner.
local framework_resources = { esx = "es_extended", qb = "qb-core", qbox = "qbx_core" }

-- Readback only. Framework saves are asynchronous; an unconfirmed save remains pending.
-- The identifier is an exact character identifier supplied by the server's PlayerCache owner.
function Sky.FW.VerifyHexPlayerJobPersistence(player_id, identifier, job_name, grade, on_duty, authorize)
    if type(player_id) ~= "number" or player_id <= 0 or player_id % 1 ~= 0
        or type(identifier) ~= "string" or identifier == "" or type(job_name) ~= "string" or job_name == ""
        or type(grade) ~= "number" or grade < 0 or grade % 1 ~= 0 or grade > 9007199254740991
        or type(on_duty) ~= "boolean" then
        return false, "invalid_player_job"
    end
    local framework = Sky.Config.framework
    local resource = framework_resources[framework]
    if not resource then return false, "unsupported_framework" end
    local function current()
        local allowed, reason = authorize()
        if allowed ~= true then return false, reason or "forbidden" end
        if Sky.Config.framework ~= framework or GetResourceState(resource) ~= "started" then
            return false, "framework_changed"
        end
        if Sky.FW.GetIdentifier(player_id) ~= identifier then return false, "session_changed" end
        local native = Sky.FW.GetJobData(player_id, { "grade", "duty" })
        if type(native) ~= "table" or Sky.FW.GetJob(player_id) ~= job_name or tonumber(native.grade) ~= grade then
            return false, "job_changed"
        end
        if native.duty ~= on_duty then return false, "member_persistence_pending" end
        return true
    end
    local allowed, reason = current()
    if not allowed then return false, reason end
    local query = framework == "esx"
        and "SELECT identifier, job, job_grade, CAST(metadata AS CHAR) AS metadata FROM users WHERE BINARY identifier = BINARY ? LIMIT 2"
        or "SELECT citizenid AS identifier, CAST(job AS CHAR) AS job FROM players WHERE BINARY citizenid = BINARY ? LIMIT 2"
    local rows = Sky.DB.Select(query, { identifier })
    allowed, reason = current()
    if not allowed then return false, reason end
    if not rows then return false, "db_read_failed" end
    if #rows ~= 1 or rows[1].identifier ~= identifier then return false, "member_persistence_pending" end
    local row = rows[1]
    if framework == "esx" then
        -- Installed ESX persists duty as metadata.jobDuty (Core.SavePlayer / xPlayer.setJob).
        local decoded, metadata = pcall(json.decode, row.metadata)
        if row.job ~= job_name or tonumber(row.job_grade) ~= grade or not decoded
            or type(metadata) ~= "table" or metadata.jobDuty ~= on_duty then
            return false, "member_persistence_pending"
        end
    else
        local decoded, job = pcall(json.decode, row.job)
        if not decoded or type(job) ~= "table" or type(job.grade) ~= "table"
            or job.name ~= job_name or job.grade.level ~= grade or job.onduty ~= on_duty then
            return false, "member_persistence_pending"
        end
        if framework == "qbox" and job_name ~= "unemployed" then
            rows = Sky.DB.Select("SELECT citizenid, grade FROM player_groups WHERE BINARY citizenid = BINARY ? AND BINARY type = BINARY 'job' AND BINARY `group` = BINARY ? LIMIT 2", { identifier, job_name })
            allowed, reason = current()
            if not allowed then return false, reason end
            if not rows then return false, "db_read_failed" end
            if #rows ~= 1 or rows[1].citizenid ~= identifier or rows[1].grade ~= grade then
                return false, "member_persistence_pending"
            end
        end
    end
    return true
end
