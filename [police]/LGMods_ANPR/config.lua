Config = {}

Config.Debug = false

Config.UseLGModsMDT = false -- or false if you want to disable the extra checks

-- Shown on in-car readout VOI symbol when a local BOLO hits (max 6 chars, Reg 109)
Config.ForceAbbrev = "LOCAL"

Config.AuthorizedVehicles = {
    "police",
    "police2",
    "police3",
    "komodamarked",
    "blista"
}

Config.MaxScanDistance = 50.0
Config.ScanAngle = 30.0
Config.ScanInterval = 500
Config.webhook = "" -- discord webhook for anpr alerts
Config.Dispatch = 'qs-dispatch' -- Either 'qs-dispatch', 'cd_dispatch', 'redutzu-mdt', 'night_shifts', 'ps-dispatch' or 'none'

-- Default commands:
Config.ANPRCommand = 'anpr' -- Change this to whatever you want.
Config.BOLOManagementCommand = 'bolo' -- Change this to whatever you want.
Config.FrontANPRCommand = 'frontanpr' -- Change this to whatever you want.
Config.RearANPRCommand = 'rearanpr' -- Change this to whatever you want.

-- Default keybinds (only used if EnableKeybinds = true)
Config.EnableKeybinds = true
Config.ANPRKeybind = "F5"
Config.BOLOManagementKeybind = "F6"
Config.FrontANPRKeybind = "F7"
Config.RearANPRKeybind = "F4"

-- Dev/test: local-only BOLO alert preview (authorised vehicle, no server broadcast)
Config.TestANPRAlertCommand = "testanpralert"

-- Enables screenshot functionality using the screenshot-basic resource.
-- NOTE: This only works for vehicle-based ANPR (i.e. when a BOLO is detected on a vehicle)
-- and does not apply for fixed camera ANPR.
Config.EnableScreenshot = false -- currently not reccomended

-- when adding coords for a camera make sure you are facing the direction in which you want the anpr to point at
Config.FixedANPRs = {
     {
         name = "Motorway (North Bound)", -- make sure to change these names and that each name is unqiue
        coords = vector4(708.9603, -1230.4087, 44.2681, 32.1235), 
         blip = {
             sprite = 604,
            color = 3,
             scale = 0.8,
             label = "ANPR Camera" -- keep this the same name for all cameras unless you want loads off different blips
         }
     },
     {
         name = "A12 (South Bound)",
         coords = vector4(-1349.8004, -2205.8557, 13.9448, 165.9586), 
         blip = {
             sprite = 604,
             color = 3,
             scale = 0.8,
            label = "ANPR Camera"
        }
     },
     {
         name = "Motorway",
         coords = vector4(388.8362, -1238.1863, 39.6592, 343.1317), 
         blip = {
             sprite = 604,
             color = 3,
             scale = 0.8,
             label = "ANPR Camera"
         }
    },
    {
        name = "Sandy",
        coords = vector4(738.7612, 2692.0186, 40.1855, 56.6879), 
        blip = {
            sprite = 604,
            color = 3,
            scale = 0.8,
            label = "ANPR Camera"
        }
   },
   {
    name = "Test",
    coords = vector4(480.2747, -1390.3096, 29.3367, 93.009), 
    blip = {
        sprite = 604,
        color = 3,
        scale = 0.8,
        label = "ANPR Camera"
    }
},
{
    name = "Test2",
    coords = vector4(509.1690, -782.1709, 24.8645, 179.0709), 
    blip = {
        sprite = 604,
        color = 3,
        scale = 0.8,
        label = "ANPR Camera"
    }
},
}

-- bolo categories you can add more (icon = Font Awesome class without "fas", e.g. "fa-car")
Config.BoloCategories = {
    {
        id = "stolen",
        label = "Stolen Vehicle",
        color = "#8b1538",
        icon = "fa-car"
    },
    {
        id = "wanted",
        label = "Wanted Suspect",
        color = "#c45c00",
        icon = "fa-user"
    },
    {
        id = "missing",
        label = "Missing Person",
        color = "#003087",
        icon = "fa-person-circle-question"
    },
    {
        id = "drugs",
        label = "Drug Related",
        color = "#2e6b2e",
        icon = "fa-pills"
    },
    {
        id = "other",
        label = "Other",
        color = "#5c6670",
        icon = "fa-file-lines"
    }
}

-- quick actions you can add more
Config.QuickActions = {
    {
        id = "stolen_vehicle",
        category = "stolen",
        label = "LoS: Lost or Stolen Vehicle",
        reason = "Vehicle reported Lost/Stolen in recent incident. Officers to make way"
    },
    {
        id = "armed_dangerous",
        category = "wanted",
        label = "WA: Wanted Suspect",
        reason = "Vehicle linked to a wanted suspect. Suspect believed to be armed"
    },
    {
        id = "drug_trafficking",
        category = "drugs",
        label = "DR: Vehicle Concerned in Drug Supply",
        reason = "Vehicle suspected to be involved in Drug Supply offences, stop and account/search where possible"
    },
    {
        id = "missing_person",
        category = "missing",
        label = "MISPER: Missing Person",
        reason = "This vehicle is connected to an active missing person enquiry. Occupants believed to be vulnerable. Officers to attend"
    }
}