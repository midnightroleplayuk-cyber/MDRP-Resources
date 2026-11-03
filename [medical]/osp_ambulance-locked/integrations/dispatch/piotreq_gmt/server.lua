Dispatch = Dispatch or {}

local function GetAmbulanceJobTable()
    local jobs = Config.AmbulanceJobs
    if type(jobs) == 'table' and #jobs > 0 then
        local tbl = {}
        for _, job in ipairs(jobs) do
            tbl[job] = true
        end
        return tbl
    end

    return { ['ambulance'] = true }
end

Dispatch['piotreq_gmt'] = {
    alert = function(coords, message, src)
        if GetResourceState('piotreq_gmt') ~= 'started' then
            return
        end

        pcall(function()
            exports['piotreq_gmt']:SendAlert(src, {
                title = 'Ambulance Alert',
                code = '911',
                icon = 'fa-solid fa-truck-medical',
                info = {
                    { icon = 'fa-solid fa-road', isStreet = true },
                    { icon = 'fa-solid fa-triangle-exclamation', data = message },
                },
                jobs = GetAmbulanceJobTable(),
                blip = {
                    scale = 1.2,
                    sprite = 61,
                    color = 1,
                    priority = 5,
                    short = true,
                    alpha = 200,
                    name = 'Ambulance Alert',
                },
                type = 'risk',
                canAnswer = true,
                maxOfficers = 4,
                time = 5,
                notifyTime = 7000,
            })
        end)
    end
}
