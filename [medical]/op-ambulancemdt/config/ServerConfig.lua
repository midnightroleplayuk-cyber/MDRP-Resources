ServerConfig = {}

-- Legacy single webhook fallback.
-- Prefer setting `webhook` per log type inside `ServerConfig.LogsData`.
ServerConfig.LogsWebhook = "" -- Discord webhook (fallback).

-- Auto-delete old dispatch calls from memory (`dispatchList`).
-- Expired calls are removed from the tablet for all on-duty medics.
ServerConfig.DispatchAutoDelete = {
    enabled = true,
    retentionMinutes = 180,       -- Delete dispatch calls older than this (180 = 3 hours). Set 0 to disable.
    checkIntervalMinutes = 5,     -- How often cleanup runs while the server is online.
}

-- Periodically flush on-duty time to DB while medics stay Active/Busy.
-- Prevents losing hours/days when the resource restarts or medics never toggle Off Duty.
ServerConfig.DutyTimeSave = {
    enabled = true,
    intervalMinutes = 2,
}

local DEFAULT_DESC_TEMPLATE = "**Player:** `%s`\n**Identifier:** `%s`\n**Job:** `%s`\n**Action:** `%s`\n\n**Data:**\n```%s```"

ServerConfig.LogsData = {
    -- patient notes
    ["patient_note.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 3066993, header = "Added Note", desc = DEFAULT_DESC_TEMPLATE },
    ["patient_note.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited Note", desc = DEFAULT_DESC_TEMPLATE },
    ["patient_note.delete"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Deleted Note", desc = DEFAULT_DESC_TEMPLATE },

    -- patient chronic diseases
    ["patient_chronic_disease.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 3066993, header = "Added Chronic Desease", desc = DEFAULT_DESC_TEMPLATE },
    ["patient_chronic_disease.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited Chronic Desease", desc = DEFAULT_DESC_TEMPLATE },
    ["patient_chronic_disease.delete"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Deleted Chronic Desease", desc = DEFAULT_DESC_TEMPLATE },

    -- patient incidents
    ["patient_incident.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15105570, header = "Created incident", desc = DEFAULT_DESC_TEMPLATE },
    ["patient_incident.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited incident", desc = DEFAULT_DESC_TEMPLATE },

    -- medical condition categories
    ["med_condition_category.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15844367, header = "Created Condition Category", desc = DEFAULT_DESC_TEMPLATE },
    ["med_condition_category.delete"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Deleted Condition Category", desc = DEFAULT_DESC_TEMPLATE },

    -- medical conditions
    ["med_condition.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 3066993, header = "Added Condition", desc = DEFAULT_DESC_TEMPLATE },
    ["med_condition.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited Condition", desc = DEFAULT_DESC_TEMPLATE },
    ["med_condition.delete"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Deleted Condition", desc = DEFAULT_DESC_TEMPLATE },

    -- garage
    ["vehicle.buy"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 3066993, header = "Purchased Vehicle", desc = DEFAULT_DESC_TEMPLATE },
    ["vehicle.sell"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Sold Vehicle", desc = DEFAULT_DESC_TEMPLATE },
    ["vehicle.assign_driver"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Assigned Vehicle Driver", desc = DEFAULT_DESC_TEMPLATE },

    -- employees
    ["employee.hire"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 3066993, header = "Hired Employee", desc = DEFAULT_DESC_TEMPLATE },
    ["employee.fire"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15158332, header = "Fired Employee", desc = DEFAULT_DESC_TEMPLATE },
    ["employee.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited Employee", desc = DEFAULT_DESC_TEMPLATE },

    -- call reports
    ["callreport.create"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15105570, header = "Created Callreport", desc = DEFAULT_DESC_TEMPLATE },
    ["callreport.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 2236962, header = "Edited Callreport", desc = DEFAULT_DESC_TEMPLATE },

    -- permissions
    ["permissions.edit"] = { enabled = true, webhook = ServerConfig.LogsWebhook, color = 15844367, header = "Updated Permissions", desc = DEFAULT_DESC_TEMPLATE },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Formats webhook details (vars table) to readable multi-line string.
-- ──────────────────────────────────────────────────────────────────────────────
---@param details any
---@return string
ServerConfig._formatLogDetails = function(details)
    if details == nil then return "-" end
    if type(details) == "string" then return details end
    if type(details) ~= "table" then return tostring(details) end

    local keys, lines = {}, {}
    for k in pairs(details) do
        keys[#keys + 1] = tostring(k)
    end
    table.sort(keys)

    for _, k in ipairs(keys) do
        local v = details[k]
        local rendered

        if v == nil then
            rendered = "nil"
        elseif type(v) == "table" then
            local ok, encoded = pcall(json.encode, v)
            rendered = ok and tostring(encoded) or tostring(v)
        else
            rendered = tostring(v)
        end

        -- Prevent codeblock corruption.
        rendered = rendered:gsub("`", "'")

        lines[#lines + 1] = string.format("%s: %s", k, rendered)
    end

    if #lines == 0 then return "-" end
    return table.concat(lines, "\n")
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Formats webhook message based on LogsData entry and sends it.
-- ──────────────────────────────────────────────────────────────────────────────
---@param logType string   -- key in ServerConfig.LogsData
---@param logData table|nil
---@return boolean
-- logData expected fields:
--   playerName   : string
--   identifier   : string
--   job          : string
--   actionName   : string (optional; defaults to logType)
--   details      : table|string (optional; defaults to logData.vars)
ServerConfig.formatWebHook = function(logType, logData)
    local log = ServerConfig.LogsData[logType]
    if not log then
        print("^1[OP-AMBULANCEMDT] Invalid logType: " .. tostring(logType))
        return false
    end

    if log.enabled == false then
        return false
    end

    local webhook = log.webhook or ServerConfig.LogsWebhook
    if not webhook or webhook == "" then
        print("^3[OP-AMBULANCEMDT] Webhook not set for logType: " .. tostring(logType))
        return false
    end

    logData = logData or {}
    local playerName = tostring(logData.playerName or "N/A")
    local identifier = tostring(logData.identifier or "N/A")
    local job = tostring(logData.job or "N/A")
    local actionName = tostring(logData.actionName or logType)

    local details = logData.details or logData.vars or {}
    local detailsText = ServerConfig._formatLogDetails(details)

    local template = log.desc or DEFAULT_DESC_TEMPLATE
    local ok, formattedDesc = pcall(string.format, template, playerName, identifier, job, actionName, detailsText)
    if not ok then
        formattedDesc = string.format(DEFAULT_DESC_TEMPLATE, playerName, identifier, job, actionName, detailsText)
    end

    local embed = {{
        ["color"] = log.color or 0,
        ["title"] = log.header or actionName,
        ["description"] = formattedDesc,
        ["footer"] = { text = os.date("%c") .. " (Server Time)." }
    }}

    PerformHttpRequest(webhook,
        function(err, text, headers) end,
        "POST",
        json.encode({ username = "OP Ambulance Mdt", embeds = embed }),
        { ["Content-Type"] = "application/json" }
    )

    return true
end