Dispatch = Dispatch or {}

local function GetAmbulanceJobTable()
    local jobs = Config.AmbulanceJobs
    if type(jobs) == 'table' and #jobs > 0 then
        return jobs
    end

    return { 'ambulance' }
end

-- Server-side path (hospital:server:ambulanceAlert). Do NOT use TriggerClientEvent
-- for cd_dispatch:AddNotification — that is deprecated on cd_dispatch3d (error 7132).
local function CdDispatchAlert(coords, message)
    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = GetAmbulanceJobTable(),
        coords = coords,
        title = 'Ambulance Alert',
        message = message,
        flash = 0,
        unique_id = tostring(math.random(1000000, 9999999)),
        sound = 1,
        blip = {
            sprite = 61,
            scale = 1.2,
            colour = 1,
            flashes = false,
            text = 'Ambulance Alert',
            time = 5,
            radius = 0,
        }
    })
end

Dispatch['cd_dispatch'] = {
    alert = CdDispatchAlert
}
