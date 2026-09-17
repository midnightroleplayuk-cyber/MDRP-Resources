Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Workshop placeables (cones, barriers)
-- ──────────────────────────────────────────────────────────────────────────────
Config.Placeables = {
    enabled = true,
    showInF6Menu = true,
    requireItem = false,
    requireJob = true,
    maxPlaceDistance = 8.0,
    interactDistance = 2.0,
    pickupAnim = {
        dict = 'pickup_object',
        clip = 'pickup_low',
        flag = 48,
        durationMs = 1600,
    },
    pickupProgress = true,
    maxPerPlayer = 20,
    maxTotal = 80,
    removeOnDisconnect = true,
    returnItemOnPickup = true,
    pickup = 'job', -- job | placer | anyone
    objects = {
        {
            id = 'cone',
            label = 'Traffic cone',
            model = 'prop_roadcone02a',
            item = 'mechanic_cone',
            icon = 'fa-solid fa-triangle-exclamation',
        },
        {
            id = 'cone_light',
            label = 'Cone (light)',
            model = 'prop_roadcone01a',
            item = 'mechanic_cone_light',
            icon = 'fa-solid fa-lightbulb',
        },
        {
            id = 'barrier',
            label = 'Work barrier',
            model = 'prop_barrier_work05',
            item = 'mechanic_barrier',
            icon = 'fa-solid fa-road-barrier',
        },
        {
            id = 'barrier_small',
            label = 'Small barrier',
            model = 'prop_mp_barrier_02b',
            item = 'mechanic_barrier_small',
            icon = 'fa-solid fa-bars',
        },
        {
            id = 'parking_barrier',
            label = 'Parking barrier',
            model = 'prop_barrier_work06a',
            item = 'mechanic_parking_barrier',
            icon = 'fa-solid fa-ban',
        },
    },
}