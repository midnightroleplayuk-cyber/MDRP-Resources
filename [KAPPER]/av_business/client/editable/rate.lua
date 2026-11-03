function rateMenu(job)
    local myJob = exports['av_laptop']:getJob().name
    if myJob == job then
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['same_job'], "error")
        return
    end
    local options = {}
    for i =1, 5 do
        options[i] = {value = i, label = i}
    end
    local input = exports['av_laptop']:inputDialog(Lang['rate_us'], {
        {type = 'select', label = Lang['star'], required = true, icon = "star", options = options},
        {type = 'textarea', label = Lang['leave_feedback'], required = true, min = 2, max = 4, autosize = true},
    })
    if input then
        TriggerServerEvent("av_business:rateUs", job, input)
    end
end