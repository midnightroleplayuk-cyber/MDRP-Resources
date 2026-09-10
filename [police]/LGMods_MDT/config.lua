Config = {}

Config.Debug = false -- set to true to enable debug messages in console and server

Config.UseLGModsANPR = true  -- if you use LGMods_ANPR and want the mdt to work with it, set to true, if not, set to false

Config.UseLGModsDispatch = true -- if you use LGMods_Dispatch and want to display officer callsigns instead of random IDs, set to true (of course the dispatch system hasn't released yet, so keep this as false or your script may not work.)

Config.UseLGModsBanking = true -- if you use LGMods Banking system, set to true to deposit fines into LGMods business accounts if false the fines won't be deposited into the business accounts.

Config.UseLGModsActiveStation = true -- if you use LGMods_ActiveStation, set to true to enable viewing of bodycam and taser logs in the MDT

Config.UseLGModsActiveSpeedCameras = false -- if you use LGMods speed camera system, set to true to display speeding violations in vehicle searches

Config.UseLGModsLicensing = false -- if you use LGMods Licensing system, set to true to enable license management in the MDT

-- Webhook Configuration
Config.EvidenceWebhook = "https://discord.com/api/webhooks/1543426958468317325/cxejf11Lf5RgNQGg4sI4LHJst4di_VwkopVB-UgU7UQMk6r-eFMKWzHZR-7mgb8OjCQ1" -- webhook for evidence activity logs  
Config.PoliceReportWebhook = "" -- webhook for police report activity logs
Config.VehicleReportWebhook = "" -- webhook for vehicle report activity logs
Config.CrimeReportWebhook = "" -- webhook for crime report activity logs
Config.WarrantWebhook = "" -- webhook for warrant activity logs

-- Business accounts where fines will be deposited
Config.ChargeSocieties = {
    police = "police" -- [JobName] = "BusinessAccountName" (usually the same as the job name)
}

Config.Phone = "default" -- options: "default", "lb-phone", "gks-phone", "qs-smartphone", "qs-smartphonepro" (default covers most phones anyway)

-- Prison
Config.Prison = {
    System = "xt-prison", -- "xt-prison" , "qb-prison" , "pickle-prisons" , "rcore-prison" , "p_policejob" , "tk_jail"
    Location = "default", -- Pickle only: prison id from pickle_prisons config (often "default")
}
Config.FingerprintLocations = {
    police = {
        coords = vector3(467.09, -993.96, 23.92),  
        heading = 270.0,
        info = "Police Fingerprint Management Database"
    },
    suspect = {
        coords = vector3(467.13, -995.28, 23.92),
        heading = 90.0,
        info = "Suspect Fingerprint Terminal"
    }
}

Config.PoliceBossRanks = {
    police = 4,
}

Config.OpenMDTCommand = "mdt" -- command used to open the mdt

Config.OpenMDTItem = "mdt" -- item used to open mdt

-- MDT presentation
Config.MDT = {
    SystemTitle = "Midnight Police Constabulary",
    TerminalSubtitle = "Midnight Police National Computer",
    DepartmentNetwork = "Midnight Law Enforcement Database Service",
    Accent = "#a6b809a1",
    AccentSoft = "rgba(30, 5, 141, 0.36)",
    BootSequence = true,
    BootDurationMs = 1650,
    ClassifiedRibbon = false,
}

-- Vehicle Services Location
Config.TaxAndInsuranceLocation = vector3(-27.7946, -1104.0782, 26.4223)

-- Insurance Levels, there isn't current a claims system in place, so this insurance is just to add the realism of owning and maintaining a road legal vehicle.
Config.InsuranceLevels = {
    {
        name = "Third Party",
        price = 500,
        duration = 7, -- days
        coverage = "basic"
    },
    {
        name = "Third Party, Fire & Theft",
        price = 1000,
        duration = 7,
        coverage = "medium"
    },
    {
        name = "Fully Comprehensive",
        price = 2000,
        duration = 7,
        coverage = "full"
    }
}

-- Vehicle tax bands
Config.TaxBands = {
    -- sports
    {
        classes = {0, 3, 6},
        price = 1000,
        duration = 7
    },
    -- suvs and luxury cars
    {
        classes = {2, 7},
        price = 750,
        duration = 7
    },
    -- standard cars
    {
        classes = {1, 4, 5},
        price = 500,
        duration = 7
    }
}

-- Vehicle models that are exempt from tax and insurance requirements
Config.TaxInsuranceExempt = {
    "police",
    "police2",
    "police3", 
    "ambulance",
    "firetruk",
    "lguard",
    "sheriff",
    "sheriff2",
    "pbus"
}

Config.AllowedDepartments = {
    police = true
}

Config.AllowedToAccessMDTFeatures = {
    police = true
}

Config.Offenses = {
    {
        category = "Road Traffic Offenses",
        offenses = {
            "Dangerous Driving",
            "Drink Driving",
            "Drug Driving",
            "Driving Without Insurance",
            "Driving Without License",
            "Speeding",
            "Using Mobile Phone While Driving",
            "Failing to Stop After Accident",
            "Careless Driving"
        }
    },
    {
        category = "Theft & Property Offenses",
        offenses = {
            "Theft",
            "Burglary",
            "Robbery",
            "Handling Stolen Goods",
            "Going Equipped for Theft",
            "Vehicle Theft",
            "Shoplifting",
            "Criminal Damage"
        }
    },
    {
        category = "Violent Offenses",
        offenses = {
            "Common Assault",
            "Actual Bodily Harm (ABH)",
            "Grievous Bodily Harm (GBH)",
            "Affray",
            "Threatening Behaviour",
            "Possession of Offensive Weapon",
            "Assault on Emergency Worker"
        }
    },
    {
        category = "Public Order Offenses",
        offenses = {
            "Drunk and Disorderly",
            "Public Order Act Section 4",
            "Public Order Act Section 5",
            "Breach of the Peace",
            "Anti-social Behaviour",
            "Harassment",
            "Causing Fear or Provocation of Violence"
        }
    },
    {
        category = "Drug Offenses",
        offenses = {
            "Possession of Class A Drugs",
            "Possession of Class B Drugs",
            "Possession of Class C Drugs",
            "Possession with Intent to Supply Class A",
            "Possession with Intent to Supply Class B",
            "Possession with Intent to Supply Class C",
            "Production of Controlled Drug"
        }
    },
    {
        category = "Firearms Offenses",
        offenses = {
            "Possession of Firearm",
            "Possession of Imitation Firearm",
            "Possession of Firearm with Intent",
            "Carrying Firearm in Public Place",
            "Possession of Prohibited Weapon"
        }
    }
}

-- charges configuration with prison time (in minutes) and fine amounts
Config.Charges = {
    {
        category = "Road Traffic Offenses",
        charges = {
            {name = "Dangerous Driving", prison_time = 20, fine = 700},
            {name = "Drink Driving", prison_time = 15, fine = 700},
            {name = "Drug Driving", prison_time = 15, fine = 700},
            {name = "Driving Without Insurance", prison_time = 10, fine = 500},
            {name = "Driving Without License", prison_time = 10, fine = 500},
            {name = "Speeding", prison_time = 5, fine = 500},
            {name = "Using Mobile Phone While Driving", prison_time = 5, fine = 250},
            {name = "Failing to Stop After Accident", prison_time = 15, fine = 2000},
            {name = "Careless Driving", prison_time = 10, fine = 500}
        }
    },
    {
        category = "Theft & Property Offenses",
        charges = {
            {name = "Theft", prison_time = 15, fine = 700},
            {name = "Burglary", prison_time = 30, fine = 3000},
            {name = "Robbery", prison_time = 40, fine = 4000},
            {name = "Handling Stolen Goods", prison_time = 15, fine = 700},
            {name = "Going Equipped for Theft", prison_time = 10, fine = 500},
            {name = "Vehicle Theft", prison_time = 25, fine = 2500},
            {name = "Shoplifting", prison_time = 10, fine = 500},
            {name = "Criminal Damage", prison_time = 15, fine = 700}
        }
    },
    {
        category = "Violent Offenses",
        charges = {
            {name = "Common Assault", prison_time = 15, fine = 700},
            {name = "Actual Bodily Harm (ABH)", prison_time = 25, fine = 2500},
            {name = "Grievous Bodily Harm (GBH)", prison_time = 40, fine = 4000},
            {name = "Affray", prison_time = 20, fine = 2000},
            {name = "Threatening Behaviour", prison_time = 15, fine = 700},
            {name = "Possession of Offensive Weapon", prison_time = 20, fine = 2000},
            {name = "Assault on Emergency Worker", prison_time = 30, fine = 3000}
        }
    },
    {
        category = "Public Order Offenses",
        charges = {
            {name = "Drunk and Disorderly", prison_time = 5, fine = 500},
            {name = "Public Order Act Section 4", prison_time = 10, fine = 500},
            {name = "Public Order Act Section 5", prison_time = 15, fine = 700},
            {name = "Breach of the Peace", prison_time = 10, fine = 500},
            {name = "Anti-social Behaviour", prison_time = 5, fine = 500},
            {name = "Harassment", prison_time = 15, fine = 700},
            {name = "Causing Fear or Provocation of Violence", prison_time = 20, fine = 2000}
        }
    },
    {
        category = "Drug Offenses",
        charges = {
            {name = "Possession of Class A Drugs", prison_time = 15, fine = 700},
            {name = "Possession of Class B Drugs", prison_time = 10, fine = 500},
            {name = "Possession of Class C Drugs", prison_time = 5, fine = 500},
            {name = "Possession with Intent to Supply Class A", prison_time = 40, fine = 4000},
            {name = "Possession with Intent to Supply Class B", prison_time = 30, fine = 3000},
            {name = "Possession with Intent to Supply Class C", prison_time = 20, fine = 2000},
            {name = "Production of Controlled Drug", prison_time = 35, fine = 3500}
        }
    },
    {
        category = "Firearms Offenses",
        charges = {
            {name = "Possession of Firearm", prison_time = 35, fine = 3500},
            {name = "Possession of Imitation Firearm", prison_time = 20, fine = 2000},
            {name = "Possession of Firearm with Intent", prison_time = 50, fine = 5000},
            {name = "Carrying Firearm in Public Place", prison_time = 30, fine = 3000},
            {name = "Possession of Prohibited Weapon", prison_time = 40, fine = 4000}
        }
    }
}
