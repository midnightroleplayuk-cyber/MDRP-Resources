---@type Job
return {
    level = 3,
    label = 'Coke Delivery',
    description = 'Pick up coke packages and hit dealer drops.',
    image = 'illegal_delivery.png',
    reward = { exp = 180, money = 9800 },
    cooldown = { enabled = true, minutes = 15 },
    information = 'High heat courier run. Stay off main roads.',
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('illegal_delivery.steps.1') },
        { label = locale('illegal_delivery.steps.2') },
        { label = locale('illegal_delivery.steps.3'), progress = { target = 8 } },
        { label = locale('illegal_delivery.steps.4'), timeLimit = 600 },
    },
    blips = {
        location = { sprite = 270, color = 3, text = 'Coke Pickup' },
        vehicle = { sprite = 67, color = 3, text = 'Delivery Van' },
        delivery = { sprite = 270, color = 3, text = 'Coke Drop' },
    },
    game = {
        police_alert_chance = 0.30,
        vehicle_model = 'burrito3',
        product = {
            key = 'coke',
            label = 'Cocaine Package',
            item = 'coke',
            pickup = vec4(-68.81, -2231.44, 7.81, 270.95),
        },
        buyer_types = {
            street = { pay = 600, police_alert_chance = 0.30 },
            dealer = { pay = 900, police_alert_chance = 0.45 },
        },
        locations = {
            { vehicle_location = vec4(-68.81, -2231.44, 7.81, 270.95) },
        },
        drop_off_points = {
            { coords = vector4(-1002.18, -1218.45, 4.76, 0.0), buyerType = 'street' },
            { coords = vector4(-42.02, -1792.18, 26.83, 0.0), buyerType = 'street' },
            { coords = vector4(29.99, -1854.56, 23.07, 0.0), buyerType = 'street' },
            { coords = vector4(54.33, -1872.97, 21.81, 0.0), buyerType = 'street' },
            { coords = vector4(72.24, -1939.14, 20.37, 0.0), buyerType = 'street' },
            { coords = vector4(1200.84, -575.72, 68.14, 0.0), buyerType = 'dealer' },
            { coords = vector4(1241.38, -601.70, 68.43, 0.0), buyerType = 'dealer' },
            { coords = vector4(1265.37, -703.04, 63.57, 0.0), buyerType = 'dealer' },
            { coords = vector4(1228.86, -725.41, 59.80, 0.0), buyerType = 'dealer' },
            { coords = vector4(175.28, -1279.60, 28.26, 0.0), buyerType = 'dealer' },
        },
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_mexgoon_01`,
        coords   = vec4(-85.26, -2235.23, 7.81, 270.67),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'illegal_delivery.mp3',
        line     = 'Package\'s hot, driver — don\'t make me regret this.',
    },
}
