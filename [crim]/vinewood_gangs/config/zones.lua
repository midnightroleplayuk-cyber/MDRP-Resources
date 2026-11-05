-- Example polygons only - replace with your own zone layout.
-- Zone keys are stored in the database, so don't rename a key once the server is live.
Config.Zones = {
    davis = {
        label = 'Davis',
        value = 1.0, -- income/influence multiplier for this zone
        points = {
            vec2(-250.0, -1900.0), vec2(100.0, -1900.0),
            vec2(100.0, -1550.0),  vec2(-250.0, -1550.0),
        },
    },
    strawberry = {
        label = 'Strawberry',
        value = 1.0,
        points = {
            vec2(-350.0, -1550.0), vec2(-100.0, -1550.0),
            vec2(-100.0, -1250.0), vec2(-350.0, -1250.0),
        },
    },
    rancho = {
        label = 'Rancho',
        value = 1.2,
        points = {
            vec2(250.0, -2050.0), vec2(600.0, -2050.0),
            vec2(600.0, -1650.0), vec2(250.0, -1650.0),
        },
    },
}
