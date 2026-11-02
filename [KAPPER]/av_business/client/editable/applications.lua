local limits = {
    ['input'] = 50,
    ['textarea'] = 10
}

function applicationsMenu(job)
    dbug("applicationsMenu(job)", job)
    local form = lib.callback.await('av_business:getForm', false, job)
    if form and next(form) then
        local questions = {}
        for i=1, #form do
            local v = form[i]
            questions[#questions+1] = {
                type = v['type'] or 'input',
                label = v['title'],
                required = true,
                max = limits[v['type']] or false
            }
        end
        local input = exports['av_laptop']:inputDialog(Lang['application_title'], questions)
        if input then
            local answers = {}
            for i=1, #form do
                local v = form[i]
                answers[#answers+1] = {
                    type = v['type'] or 'input',
                    title = v['title'],
                    answer = input[i] or "N/A"
                }
            end
            TriggerServerEvent("av_business:newApplication", job, answers)
        end
    else
        TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['empty_form'], 'inform')
        dbug("getForm returned nil, this business doesn't have any form saved.")
    end
end