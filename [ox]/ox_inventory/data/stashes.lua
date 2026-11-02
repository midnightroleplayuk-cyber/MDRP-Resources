return {
	{
		coords = vec3(452.3, -991.4, 30.7),
		target = {
			loc = vec3(451.25, -994.28, 30.69),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open personal locker'
		},
		name = 'policelocker',
		label = 'Personal locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = shared.police
	},

    --Custody locker and tray

	{
		coords = vec3(377.06, -326.62, 46.14),
		target = {
			loc = vec3(377.06, -326.62, 46.14),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open custody locker'
		},
		name = 'custodylocker',
		label = 'Custody locker',
		owner = false,
		slots = 30,
		weight = 30000,
		groups = shared.police
	},

	{
		coords = vec3(374.72, -321.4, 45.9),
		target = {
			loc = vec3(374.72, -321.4, 45.9),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open custody Tray'
		},
		name = 'custodytray',
		label = 'Custody tray',
		owner = false,
		slots = 10,
		weight = 10000,
		groups = shared.police
	},
    
	-- MHS personal locker

	{
		coords = vec3(301.3, -600.23, 43.28),
		target = {
			loc = vec3(301.82, -600.99, 43.29),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},
}
