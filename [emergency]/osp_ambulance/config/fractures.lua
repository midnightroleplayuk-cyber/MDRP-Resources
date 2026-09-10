Config = Config or {}

Config.Fractures = {
    {
        bone = 'Head',
        chance = 10, -- Chance in % that a fracture is being applied when wounded
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        pain = 15.0
    }, 
    {
        bone = 'Larm',
        chance = 10,
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        pain = 15.0,
        lockSteering = true,
    },
    {
        bone = 'Rarm',
        chance = 10,
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        pain = 15.0,
        lockSteering = true,
    },
    {
        bone = 'Rleg',
        chance = 10,
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        pain = 15.0,
        causeStaggering = true, 
    },
    {
        bone = 'Lleg',
        chance = 10,
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        pain = 15.0,
        causeStaggering = true,
    },
}