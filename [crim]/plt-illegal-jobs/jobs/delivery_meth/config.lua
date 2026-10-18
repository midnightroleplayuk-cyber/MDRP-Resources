---@type Job
return {
    level = 2,
    label = 'Meth Delivery',
    description = 'Pick up meth bricks and courier them across town.',
    image = 'illegal_delivery.png',
    reward = { exp = 150, money = 7400 },
    cooldown = { enabled = true, minutes = 12 },
    information = 'Load at the lab, deliver discreetly.',
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('illegal_delivery.steps.1') },
        { label = locale('illegal_delivery.steps.2') },
        { label = locale('illegal_delivery.steps.3'), progress = { target = 8 } },
        { label = locale('illegal_delivery.steps.4'), timeLimit = 600 },
    },
    blips = {
        location = { sprite = 270, color = 5, text = 'Meth Pickup' },
        vehicle = { sprite = 67, color = 5, text = 'Delivery Van' },
        delivery = { sprite = 270, color = 5, text = 'Meth Drop' },
    },
    game = {
        police_alert_chance = 0.25,
        vehicle_model = 'burrito3',
        product = {
            key = 'meth',
            label = 'Meth Bricks',
            item = 'meth',
            pickup = vec4(1099.18, -3189.44, 5.9, 173.98),
        },
        buyer_types = {
            street = { pay = 520, police_alert_chance = 0.25 },
            dealer = { pay = 780, police_alert_chance = 0.40 },
        },
        locations = {
            { vehicle_location = vec4(1099.18, -3189.44, 5.9, 173.98) },
        },
        drop_off_points = {
            { coords = vector4(98.02, 3682.01, 38.74, 0.0), buyerType = 'street' },
            { coords = vector4(70.43, 3753.41, 38.77, 0.0), buyerType = 'street' },
            { coords = vector4(15.22, 3688.84, 39.13, 0.0), buyerType = 'street' },
            { coords = vector4(41.57, 3705.39, 39.52, 0.0), buyerType = 'street' },
            { coords = vector4(333.2, -2041.8, 19.9, 0.0), buyerType = 'street' },
            { coords = vector4(1221.39, -668.83, 62.49, 0.0), buyerType = 'dealer' },
            { coords = vector4(1203.69, -598.96, 67.06, 0.0), buyerType = 'dealer' },
            { coords = vector4(1204.48, -557.80, 68.62, 0.0), buyerType = 'dealer' },
            { coords = vector4(1251.20, -621.31, 68.41, 0.0), buyerType = 'dealer' },
            { coords = vector4(1271.05, -683.56, 65.03, 0.0), buyerType = 'dealer' },
        },
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_mexgoon_01`,
        coords   = vec4(-85.17, -2235.05, 7.81, 267.31),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'illegal_delivery.mp3',
        line     = 'Package\'s hot, driver — don\'t make me regret this.',
    },
}
