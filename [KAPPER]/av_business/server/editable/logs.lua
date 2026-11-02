local functions = {
    ['applications'] = function(...) 
        return applicationsLog(...) 
    end,
    ['cashier'] = function(...) 
        return cashiersLog(...) 
    end,
    ['rate'] = function(...) 
        return ratingsLog(...) 
    end,
    ['duty'] = function(...) 
        return dutyLogs(...) 
    end,
    ['employee'] = function(...) 
        return employeeLogs(...) 
    end,
    ['bank'] = function(...) 
        return fundsLogs(...) 
    end,
    ['items'] = function(...) 
        return itemLogs(...) 
    end,
    ['supplies'] = function(...)
        return suppliesLogs(...)
    end,
    ['pawnshop'] = function(...)
        return pawnLogs(...)
    end,
    -- ['custom_log'] = function(...) -- index key needs to match your log value
    --     return customLogs(...) -- customLogs is the name of the function to trigger
    -- end,
}

function sendLog(type, source, job, data)
    if functions[type] then
        local webhook = getWebhook(job,type)
        dbug("Logs(type, source, job, webhook)", type, source, job, webhook)
        if webhook then
            functions[type](webhook, source, job, data)
        else
            dbug("Business doesn't have a webhook, skipping sendLog for this.")
        end
    else
        warn("[ERROR] "..type.." doesn't exist in functions table (server/editable/logs.lua)")
    end
end

function applicationsLog(webhook, source, job, data)
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['player_identifier']..":** "..data.identifier
    }
    local message = {
        {
            ['title'] = Lang['logs_application'],
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function cashiersLog(webhook, source, job, data)
    local earnings = data['total'] - data['commission']
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['cart_total']..":** $"..data.total,
        "**"..Lang['commission']..":** $"..data.commission,
        "**"..Lang['revenue']..":** $"..earnings,
    }
    if data['coupon'] then
        table.insert(description, "**"..(Lang['coupon_log'] or "Coupon")..":** "..(data.coupon and data.coupon.discount).." ("..data.coupon.code..")")
    end
    table.insert(description, "**"..Lang['products']..":** "..data.description)
    local message = {
        {
            ['title'] = Lang['cashier_log'],
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function ratingsLog(webhook, source, job, data)
    local description = {
        "**"..Lang['star']..":** "..data.stars,
        "**"..Lang['player_description']..":** "..data.description,
        "**"..Lang['player_identifier']..":** "..data.identifier
    }
    local message = {
        {
            ['title'] = Lang['logs_rating'],
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function dutyLogs(webhook, source, job, data)
    local header = Lang['off_duty_log']
    if data and data.duty then
        header = Lang['on_duty_log']
    end
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['player_identifier']..":** "..data.identifier
    }
    local message = {
        {
            ['title'] = header,
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function employeeLogs(webhook, source, job, data)
    local header = data['title'] or ""
    local description = {
        "**"..Lang['bossName']..":** "..data.bossName,
        "**"..Lang['bossIdentifier']..":** "..data.bossIdentifier,
        "**"..Lang['employeeName']..":** "..data.employeeName,
        "**"..Lang['employeeIdentifier']..":** "..data.employeeIdentifier,
    }
    if data['gradeLabel'] then -- used when boss edits employee grade
        table.insert(description, "**"..Lang['gradeLabel']..":** "..data.gradeLabel)
    end
    if data['bonus'] then -- used when boss sends money bonus
        table.insert(description, "**"..Lang['bonus_payment']..":** $"..data.bonus)
    end
    local message = {
        {
            ['title'] = header,
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function fundsLogs(webhook, source, job, data)
    local type = data['type']
    local header = Lang[type]
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['player_identifier']..":** "..data.identifier,
        "**"..Lang['amount']..":** $"..data.amount,
    }
    local message = {
        {
            ['title'] = header,
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

function itemLogs(webhook, source, job, data)
    local header = data['title']
    local description = false
    if header == Lang['new_item'] then
        description = {
            "**"..Lang['item_name']..":** "..data.name,
            "**"..Lang['item_type']..":** "..data.type,
            "**"..Lang['item_description']..":** "..data.description,
            "**"..Lang['item_price']..":** $"..data.price,
            "**"..Lang['employeeName']..":** "..data.employeeName,
            "**"..Lang['employeeIdentifier']..":** "..data.employeeIdentifier,
        }
    else
        description = {
            "**"..Lang['item_name']..":** "..data.name,
            "**"..Lang['employeeName']..":** "..data.employeeName,
            "**"..Lang['employeeIdentifier']..":** "..data.employeeIdentifier,
        }
    end
    if description then
        local message = {
            {
                ['title'] = header,
                ['description'] = table.concat(description, "\n"),
                ['color'] = "5793266",
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
            } 
        }
        exports['av_laptop']:Discord(webhook, message)
    end
end

function suppliesLogs(webhook, source, job, data)
    local header = data['title']
    local description = {
        "**"..Lang['total_products']..":** "..data.products,
        "**"..Lang['invoice_amount']..":** $"..data.total,
        "**"..Lang['employeeName']..":** "..data.name,
        "**"..Lang['employeeIdentifier']..":** "..data.identifier,
    }
    if description then
        local message = {
            {
                ['title'] = header,
                ['description'] = table.concat(description, "\n"),
                ['color'] = "5793266",
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
            } 
        }
        exports['av_laptop']:Discord(webhook, message)
    end
end

function pawnLogs(webhook, source, job, data)
    local header = data['title']
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['pawnshop_total_'..data.type]..":** $"..data.total,
    }
    table.insert(description, "**"..Lang['products']..":** "..data.description)
    local message = {
        {
            ['title'] = header,
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end

exports("sendLog",sendLog)