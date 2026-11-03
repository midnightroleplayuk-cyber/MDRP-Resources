Config = Config or {}

Config.StretcherLimit = true -- Will limit the spawnable amount of stretchers to 1 per person. 
Config.StretcherModel = {
    regular = 'sittingfernocot',
    folded = 'fernocot',
    lowered = 'loweredfernocot',
}
Config.StretcherAttach = {
    -- Medic carrying the stretcher (attached to carrier bone)
    carryOffset = {
        freemode = vector3(-0.2, -1.2, -1.4),
        ped = vector3(-0.05, 1.3, -1.0),
    },
    carryRotation = {
        freemode = vector3(-140.0, -220.0, 100.0),
        ped = vector3(0.0, 0.0, -90.0),
    },

    -- Patient lying/sitting on the stretcher
    patientOffset = {
        regular = {
            freemode = vector3(0.3, 0.0, 2.1),
            ped = vector3(0.0, 0.0, 2.1),
        },
        folded = {
            freemode = vector3(0.2, 0.0, 2.1),
            ped = vector3(0.15, 0.0, 2.1),
        },
        lowered = {
            freemode = vector3(0.2, 0.0, 1.5),
            ped = vector3(0.0, 0.0, 1.5),
        },
    },
    patientRotation = {
        regular = {
            freemode = vector3(0.0, 0.0, 100.0),
            ped = vector3(0.0, 0.0, 100.0),
        },
        folded = {
            freemode = vector3(0.0, 0.0, 90.0),
            ped = vector3(0.0, 0.0, 90.0),
        },
        lowered = {
            freemode = vector3(0.0, 0.0, 90.0),
            ped = vector3(0.0, 0.0, 90.0),
        },
    },
}



-- Ambulances with stretcher support
-- Empty stretchers are stored without a move-in animation (no empty-stretcher offsets needed).
-- Only configure offsets for when a player is on the stretcher.
Config.Ambulances = {
    ["ambulance"] = {
        stretcheroffset = vector3(0.0,-0.62,-0.2), -- Stretcher offset, relative to the player
        stretcherrotation = vector3(90.0, -90.0, -195.0), -- Stretcher rotation, relative to the player
        playeroffset = vector3(0.0,-2.3,1.45), -- Player offset relative to the ambulance
        playerrotation = vector3(0.0, 0.0, 177.0), -- Player rotation relative to the ambulance.
    },
    ["ambulance2"] = {
        stretcheroffset = vector3(0.0,-0.80,-0.2),
        stretcherrotation = vector3(90.0, -90.0, -195.0),
        playeroffset = vector3(0.0,-2.5,1.6),
        playerrotation = vector3(0.0, 0.0, 177.0),
    },
    ["polmav"] = {
        stretcheroffset = vector3(0.0,-0.80,-0.2),
        stretcherrotation = vector3(90.0, -95.0, -193.0),
        playeroffset = vector3(0.05,1.1,0.97),
        playerrotation = vector3(0.0, 0.0, 90.0),
    },
}

Config.AuthorizedVehicles = { -- Vehicles players can use based on their ambulance job grade level
	-- Grade 0
	[0] = {
		["ambulance"] = "Ambulance",
	},
	-- Grade 1
	[1] = {
		["ambulance"] = "Ambulance",
	},
	-- Grade 2
	[2] = {
		["ambulance"] = "Ambulance",
	},
	-- Grade 3
	[3] = {
		["ambulance"] = "Ambulance",
	},
	-- Grade 4
	[4] = {
		["ambulance"] = "Ambulance",
	}
}

Config.VehicleExtras = { -- Enable/disable the vehicle extras when spawning them with the job vehicle spawner
    ["ambulance"] = { -- Model name
        ["1"] = false, -- on/off
        ["2"] = true, -- !OBS! The native checks for an inverted value, so if you want to have this extra enabled it should be false and the other way around. !OBS!
        ["3"] = true,
        ["4"] = true,
        ["5"] = true,
        ["6"] = true,
        ["7"] = true,
        ["8"] = true,
        ["9"] = true,
        ["10"] = true,
        ["11"] = true,
        ["12"] = true,
    },
    ["ambulance2"] = {
        ["1"] = false,
        ["2"] = true,
        ["3"] = true,
        ["4"] = true,
        ["5"] = true,
        ["6"] = true,
        ["7"] = true,
        ["8"] = true,
        ["9"] = true,
        ["10"] = true,
        ["11"] = true,
        ["12"] = true,
    }
}