Config = {}

Config.CheckInterval = 1000
Config.LoadDistance = 500.0

Config.Maps = {
    ['metro_entry'] = {
        coords = vector3(90.01935, 6322.115, 30.1379967),
        entitySets = {
            { name = 'trash', enabled = true }
        }
    },
	['metro'] = {
        coords = vector3(154.8045, 6288.67969, 20.7689037),
        entitySets = {
            { name = 'trash', enabled = true }
        }
    },
    ['police_station'] = {
        coords = vector3(-454.539551, 6008.609, 33.2010841),
        entitySets = {
            { name = 'sheriff_theme', enabled = false },
			{ name = 'pd_theme', enabled = true },
			{ name = 'gym_props', enabled = true }
        }
    }
}

