Dispatch = Dispatch or {}

local function GetAmbulanceJobTable()
    local jobs = Config.AmbulanceJobs
    if type(jobs) == 'table' and #jobs > 0 then
        return jobs
    end

    return { 'ambulance' }
end

-- Resource folder may be cd_dispatch or cd_dispatch3d; both use this event.
-- Alerts must be triggered from the client (server->client AddNotification is deprecated on 3D).
local function CdDispatchAlert(coords, message)
    TriggerServerEvent('cd_dispatch:AddNotification', {
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
