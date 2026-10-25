Config = {}

Config.Department = 'Midnight Police Department'

Config.PoliceJobs = { 'police' }

Config.CommandGrade = 4

Config.TabGrades = {
    lookup = 4,
    stock = 4,
    rules = 4,
}

Config.ApproverGrade = 3
Config.ApprovalTimeout = 60

Config.DefaultMinGrade = 0

Config.MaxOut = 3

Config.UseDistance = 2.5

Config.HistoryPageSize = 10

Config.ServiceBelow = 20

Config.AutoReturn = {
    offDuty = true,
    grace = 60,
    interval = 15,
}

Config.Handover = { enabled = true, duration = 2500 }

Config.Armories = {
    {
        label = 'Main Armory',
        coords = vec4(481.5, -995.5, 30.69, 270.0),
        model = 's_m_y_cop_01',
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        blip = true,
        weapons = { 'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_STUNGUN', 'WEAPON_NIGHTSTICK' },
        ammo = { 'ammo-9' },

    },
    {
        label = 'Tactical Armory',
        coords = vec4(486.3, -995.5, 30.69, 90.0),
        model = 's_m_y_swat_01',
        scenario = 'WORLD_HUMAN_GUARD_STAND',
        blip = true,
        weapons = { 'WEAPON_CARBINERIFLE', 'WEAPON_PUMPSHOTGUN' },
        ammo = { 'ammo-rifle', 'ammo-shotgun' },
    },
}

Config.Weapons = {
    { name = 'WEAPON_PISTOL',       label = 'Glock 17',      prefix = 'PD', stock = 12,
      desc = 'Standard issue semi-automatic sidearm for patrol officers.',
      kit = { ['ammo-9'] = 48 } },
    { name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', prefix = 'PD', stock = 8,
      desc = 'Duty pistol with a higher magazine capacity.',
      kit = { ['ammo-9'] = 48 } },
    { name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', prefix = 'CR', stock = 6,
      desc = 'Patrol rifle. Authorised for tactical and high-risk deployments only.',
      kit = { ['ammo-rifle'] = 90 }, requireReason = true, approval = true },
    { name = 'WEAPON_PUMPSHOTGUN',  label = 'Shotgun',       prefix = 'SG', stock = 4,
      desc = 'Pump-action shotgun for tactical and breaching use.',
      kit = { ['ammo-shotgun'] = 24 }, requireReason = true },
    { name = 'WEAPON_STUNGUN',      label = 'Taser',         prefix = 'TS', stock = 12,
      desc = 'Conducted energy weapon. Less-lethal option for compliance.' },
    { name = 'WEAPON_NIGHTSTICK',   label = 'Baton',         prefix = 'BT', stock = 12,
      desc = 'Standard issue impact weapon.' },
}

Config.Ammo = {
    { item = 'ammo-9',       label = '9mm Rounds',      amount = 50, desc = 'Pistol ammunition.' },
    { item = 'ammo-rifle',   label = '5.56 Rounds',     amount = 60, desc = 'Rifle ammunition.' },
    { item = 'ammo-shotgun', label = '12 Gauge Shells', amount = 24, desc = 'Shotgun shells.' },
}

Config.AmmoCooldown = 30

Config.AmmoPerShift = 3
