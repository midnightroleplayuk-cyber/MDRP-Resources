---@type Job
return {
    level = 2,
    label = 'Weed Delivery',
    description = 'Pick up weed bags and deliver to street buyers.',
    image = 'illegal_delivery.png',
    reward = { exp = 120, money = 5200 },
    cooldown = { enabled = true, minutes = 10 },
    information = 'Van spawn at the grow house. Load bags, then deliver.',
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('illegal_delivery.steps.1') },
        { label = locale('illegal_delivery.steps.2') },
        { label = locale('illegal_delivery.steps.3'), progress = { target = 8 } },
        { label = locale('illegal_delivery.steps.4'), timeLimit = 600 },
    },
    blips = {
        location = { sprite = 270, color = 2, text = 'Weed Pickup' },
        vehicle = { sprite = 67, color = 2, text = 'Delivery Van' },
        delivery = { sprite = 270, color = 2, text = 'Weed Drop' },
    },
    game = {
        police_alert_chance = 0.15,
        vehicle_model = 'burrito3',
        product = {
            key = 'weed',
            label = 'Weed Bags',
            item = 'weed',
            pickup = vector4(2201.12, 5611.84, 53.9, 265.0),
        },
        buyer_types = {
            street = { pay = 420, police_alert_chance = 0.15 },
            dealer = { pay = 650, police_alert_chance = 0.30 },
        },
        locations = {
            { vehicle_location = vector4(2201.12, 5611.84, 53.9, 265.0) },
        },
        drop_off_points = {
            { coords = vector4(175.28, -1279.60, 28.26, 0.0), buyerType = 'street' },
            { coords = vector4(76.20, -1948.22, 20.17, 0.0), buyerType = 'street' },
            { coords = vector4(85.96, -1959.71, 20.12, 0.0), buyerType = 'street' },
            { coords = vector4(118.42, -1920.99, 20.32, 0.0), buyerType = 'street' },
            { coords = vector4(23.56, -1896.17, 21.96, 0.0), buyerType = 'street' },
            { coords = vector4(1228.86, -725.41, 59.80, 0.0), buyerType = 'dealer' },
            { coords = vector4(1222.79, -697.04, 59.80, 0.0), buyerType = 'dealer' },
            { coords = vector4(1206.88, -620.22, 65.44, 0.0), buyerType = 'dealer' },
            { coords = vector4(1241.99, -565.69, 68.66, 0.0), buyerType = 'dealer' },
            { coords = vector4(1265.51, -648.17, 66.92, 0.0), buyerType = 'dealer' },
        },
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_mexgoon_01`,
        coords   = vec4(2194.21, 5594.19, 53.75, 343.45),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'illegal_delivery.mp3',
        line     = 'Package\'s hot, driver — don\'t make me regret this.',
    },
}
