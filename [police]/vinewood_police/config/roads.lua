---------------------------------------------------------------------------
-- Vehicle stops and roadside checks (phase 2).
-- With vinewood-mdt 2.18+ vehicle and driver checks and tickets go through the MDT.
-- Without it, vinewood_licensing and vinewood-vehicleservices are read directly.
---------------------------------------------------------------------------
Config.Roads = {
    -- Command (and keybind) to stop the vehicle in front of you while driving a police vehicle.
    StopCommand = 'stopvehicle',
    StopKeybind = '',            -- e.g. 'Y'. Players can rebind it in GTA settings.
    StopRange = 45.0,            -- how far ahead (metres)
    RequireEmergencyVehicle = true, -- must be driving an emergency-class vehicle
    RequireLights = true,        -- blue lights must be on

    PanelDistance = 6.0,         -- how close to the vehicle to open the roadside panel
    DriverRange = 12.0,          -- people this close to the vehicle are offered as the driver
    StopTimeout = 45,            -- minutes before an unfinished stop closes itself

    -- Why the vehicle was stopped
    Reasons = {
        'Routine check (s.163 RTA 1988)', 'Speeding', 'Manner of driving', 'ANPR hit', 'Vehicle defect',
        'No lights', 'Mobile phone use', 'Seat belt', 'Suspected drink or drug driving', 'Other',
    },
    -- How the stop ended
    Outcomes = {
        'Words of advice', 'Fixed penalty issued', 'Traffic offence report', 'Vehicle defect rectification notice',
        'Arrest', 'Vehicle seized', 'No further action',
    },

    -- Fixed penalties when vinewood-mdt isn't running (with it, the MDT's own list is used).
    -- Points go on through vinewood_licensing. Without the MDT there's no payment collection:
    -- the ticket is recorded and the officer collects the fine in roleplay.
    Currency = '£',
    Offences = {
        { code = 'SP30', label = 'Exceeding the speed limit', amount = 100, points = 3, type = 'FPN' },
        { code = 'CU80', label = 'Using a hand-held phone while driving', amount = 200, points = 6, type = 'FPN' },
        { code = 'TS10', label = 'Failing to comply with a red traffic light', amount = 100, points = 3, type = 'FPN' },
        { code = 'CD10', label = 'Careless driving (lower level)', amount = 100, points = 3, type = 'FPN' },
        { code = 'IN10', label = 'Using a vehicle uninsured', amount = 300, points = 6, type = 'FPN' },
        { code = 'LC20', label = 'Driving otherwise than in accordance with a licence', amount = 100, points = 3, type = 'FPN' },
        { code = 'MOT', label = 'No MOT certificate', amount = 100, points = 0, type = 'FPN' },
        { code = 'SB', label = 'Not wearing a seat belt', amount = 100, points = 0, type = 'FPN' },
    },

    -- Preliminary breath and drug tests (s.6 RTA 1988)
    Tests = {
        BreathLimit = 35,         -- micrograms per 100 ml of breath (England and Wales)
        -- Players choose how they blow (there's no shared drunk state across frameworks).
        -- Return a number from this function instead to read it from your own drink script.
        PlayerReading = nil,      -- function(src) return 0 end
        DrugsTested = { 'Cannabis', 'Cocaine' },
        PromptTimeout = 30,
    },

    -- Vehicle seizure and recovery
    Seizure = {
        Powers = {
            { id = 's165a', label = 's.165A RTA 1988 (no insurance / no licence)' },
            { id = 's59',   label = 's.59 Police Reform Act 2002 (antisocial driving)' },
            { id = 's19',   label = 's.19 PACE 1984 (evidence)' },
            { id = 'stolen', label = 'Stolen vehicle recovered' },
            { id = 'removal', label = 'Removal (obstruction, abandoned or dangerous)' },
        },
        RecoveryDelay = 30,       -- seconds after seizure before the recovery truck "collects" it (vehicle removed)
        Fee = 150,                -- release fee passed to the impound hook
        -- Called on the server once the vehicle is recovered. Default: QB/Qbox player_vehicles state 2
        -- (impound) with the fee as depot price. ESX garages differ: add yours here.
        OnImpound = function(plate, info)
            if not IsDuplicityVersion() then return end
            if GetResourceState('qbx_core') == 'started' or GetResourceState('qb-core') == 'started' then
                MySQL.update("UPDATE player_vehicles SET state = 2, depotprice = ? WHERE REPLACE(UPPER(plate), ' ', '') = ?",
                    { info.fee, (plate:upper():gsub('%s', '')) })
            end
        end,
    },
}
