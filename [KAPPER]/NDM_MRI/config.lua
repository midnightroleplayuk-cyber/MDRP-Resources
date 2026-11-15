Config = {}

-- Jobs that can run the MRI. Value = minimum grade.
Config.Jobs = {
    ambulance = 0,
}
Config.RequireOnDuty = true

-- Scanners. Add one entry per MRI scanner.
--   table   = where the patient lies: x, y, z (top of the table) and heading the patient faces.
--   console = optional: where the medic stands to start the scan (control room). Leave nil to
--             start the scan from the table itself.
-- Tip: stand / lie where you want and use /mripos to print your coords and heading to F8.
--
-- The Burton (RHS hospital) values below are an ESTIMATE worked out from the MLO file.
-- Replace them with the vectors you grab in game.
Config.Scanners = {
    {
        label = 'Burton MRI',
        table = vector4(-323.87, -109.29, 38.60, 69.0),
        console = nil, -- e.g. vector3(-329.50, -105.80, 38.50)
    },
}

Config.ScanDuration = 20000        -- ms the scan takes (progress bar length)
Config.PatientRadius = 2.0         -- how close to the table point the patient must be
Config.MedicRange = 3.0            -- how close the medic must be to the console (or table)
Config.LayPatientRange = 4.0       -- how close the patient must be to the medic to be laid on the table

-- Sound
Config.SoundFile = 'sounds/mri_scan.ogg'
Config.SoundVolume = 0.6           -- 0.0 - 1.0 at the table
Config.SoundRange = 20.0           -- metres; volume fades out to nothing at this distance

-- Mark fractures found by the MRI as imaged in OSP (same as the OSP X-ray does), so medics can
-- go straight to splint / cast without an X-ray.
Config.ConfirmFractures = true

-- Patient lying animation (same one OSP uses for hospital beds)
Config.LieAnim = { dict = 'anim@gangops@morgue@table@', clip = 'body_search' }

-- Debug: draws the table / console zones
Config.Debug = false
