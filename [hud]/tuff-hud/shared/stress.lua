Stress = {}

Stress.MinimumSpeed = {
    buckled = 150,  -- minimum speed to gain stress when buckled
    unbuckled = 100 -- minimum speed to gain stress when unbuckled
}

Stress.BlacklistedVehicles = { -- vehicles that will not cause stress when speeding
    'jet'
}

Stress.DisabledVehicleClasses = { -- Vehicle classes where speed-based stress is disabled (e.g. 8 = Motorcycles, 13 = Bicycles, 14 = Boats, 15 = Helicopters, 16 = Planes, 21 = Trains)
    8,  -- Motorcycles
    13, -- Bicycles
    14, -- Boats
    15, -- Helicopters
    16, -- Planes
    21  -- Trains
}

Stress.Disablejob = { -- jobs that will not gain stress from shooting (if they are not whitelisted in Stress.WhitelistedWeapons)
    police = true,
    ambulance = true,
}

Stress.WhitelistedWeapons = { -- weapons that will not cause stress when shooting for jobs that are disabled in Stress.Disablejob
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

Stress.WeaponCooldown = 2000 -- Cooldown in milliseconds for gaining stress from shooting

Stress.MinimumStress = 50 -- Minimum Stress Level For Screen Shaking

Stress.BlurIntensity = {
    {
        min = 50,
        max = 60,
        intensity = 1500,
    },
    {
        min = 60,
        max = 70,
        intensity = 2000,
    },
    {
        min = 70,
        max = 80,
        intensity = 2500,
    },
    {
        min = 80,
        max = 90,
        intensity = 2700,
    },
    {
        min = 90,
        max = 100,
        intensity = 3000,
    },
}

Stress.EffectInterval = {
    {
        min = 50,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}
