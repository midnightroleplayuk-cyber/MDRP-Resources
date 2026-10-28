-- ====================================================================
-- REGION 10 -- Plank Decking
-- ====================================================================
-- 91 slots, hand-carried. Pile points were measured in game; move them
-- with /j7pile.
-- ====================================================================

Config.Job7 = {
    zoneId = 'job7',

    maxPlayers           = 4,
    cooldownHours        = 0,

    rewardPerSlot         = 75,
    rewardCompletionBonus = 4500,
    rewardXP              = 1000,

    rentAllowed  = { 'bison2' },
    crewProfiles = {
        [1] = { vehicles = { bison2 = 1 } },
        [2] = { vehicles = { bison2 = 1 } },
        [3] = { vehicles = { bison2 = 1 } },
        [4] = { vehicles = { bison2 = 1 } },
    },
    requireRental = false,

    sourcePiles = {
        { labelKey = 'j7_pile_deck2_a', label = TL('j7_pile_deck2_a', '2nd Floor Deck A'),     coords = vec3(-1129.36, -963.33, 5.63),
          carryModel = 'tworst_job7plank',
          acceptsModels = { 'tworst_job7plank' },
          rot       = vec3(0.0, 0.0, 30.0),
          stackStep = vec3(0.0, 0.0, 0.053) , stackCount = 13 },
        { labelKey = 'j7_pile_deck2_b', label = TL('j7_pile_deck2_b', '2nd Floor Deck B'),     coords = vec3(-1125.84, -962.62, 5.63),
          carryModel = 'tworst_job7plank',
          acceptsModels = { 'tworst_job7plank' },
          rot       = vec3(0.0, 0.0, 30.0),
          stackStep = vec3(0.0, 0.0, 0.053) , stackCount = 13 },

        { labelKey = 'j7_pile_wall2_a', label = TL('j7_pile_wall2_a', '2nd Floor Side Wall A'), coords = vec3(-1128.51, -953.14, 5.63),
          carryModel = 'tworst_job7planka',
          acceptsModels = { 'tworst_job7planka', 'tworst_job7planka1', 'tworst_job7planka2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 16 },
        { labelKey = 'j7_pile_wall2_b', label = TL('j7_pile_wall2_b', '2nd Floor Side Wall B'), coords = vec3(-1132.88, -956.68, 5.63),
          carryModel = 'tworst_job7planka',
          acceptsModels = { 'tworst_job7planka', 'tworst_job7planka1', 'tworst_job7planka2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 16 },

        { labelKey = 'j7_pile_wall1_a', label = TL('j7_pile_wall1_a', '1st Floor Side Wall A'), coords = vec3(-1117.40, -972.98, 1.15),
          carryModel = 'tworst_job7plankb',
          acceptsModels = { 'tworst_job7plankb', 'tworst_job7plankb1', 'tworst_job7plankb2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 7 },
        { labelKey = 'j7_pile_wall1_b', label = TL('j7_pile_wall1_b', '1st Floor Side Wall B'), coords = vec3(-1123.54, -972.50, 1.15),
          carryModel = 'tworst_job7plankb',
          acceptsModels = { 'tworst_job7plankb', 'tworst_job7plankb1', 'tworst_job7plankb2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 7 },
        { labelKey = 'j7_pile_wall1_c', label = TL('j7_pile_wall1_c', '1st Floor Side Wall C'), coords = vec3(-1131.335, -961.421, 6.194),
          carryModel = 'tworst_job7plankb',
          acceptsModels = { 'tworst_job7plankb', 'tworst_job7plankb1', 'tworst_job7plankb2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 7 },
        { labelKey = 'j7_pile_wall1_d', label = TL('j7_pile_wall1_d', '1st Floor Side Wall D'), coords = vec3(-1130.528, -955.528, 5.972),
          carryModel = 'tworst_job7plankb',
          acceptsModels = { 'tworst_job7plankb', 'tworst_job7plankb1', 'tworst_job7plankb2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 6 },
        { labelKey = 'j7_pile_wall1_e', label = TL('j7_pile_wall1_e', '1st Floor Side Wall E'), coords = vec3(-1125.15, -960.13, 1.15),
          carryModel = 'tworst_job7plankb',
          acceptsModels = { 'tworst_job7plankb', 'tworst_job7plankb1', 'tworst_job7plankb2' },
          rot       = vec3(0.0, 90.0, 32.533),
          stackStep = vec3(0.0, 0.0, 0.068) , stackCount = 6 },
    },

    pileStock = true,

    pileDefaults = {
        stackCount      = 6,
        respawnOnPlaced = true,
    },

    slots = {
        { model = 'tworst_job7plank',   coords = vec3(-1128.095, -966.235, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1127.568, -967.147, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1124.136, -965.166, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1123.609, -966.079, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1127.041, -968.060, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1126.514, -968.973, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1123.082, -966.991, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1122.555, -967.904, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1125.987, -969.885, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1125.460, -970.798, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1122.028, -968.817, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1121.501, -969.729, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1124.933, -971.711, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1124.406, -972.623, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1120.974, -970.642, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1120.447, -971.555, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1123.879, -973.536, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1123.352, -974.449, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1119.920, -972.467, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1119.393, -973.380, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1122.825, -975.361, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1122.298, -976.274, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1118.866, -974.293, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1118.339, -975.205, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1121.771, -977.187, 5.607), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plank',   coords = vec3(-1124.663, -964.253, 5.607), rot = vec3(0.0, 0.0,  30.0) },

        { model = 'tworst_job7planka',  coords = vec3(-1122.591, -958.549, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1123.516, -956.946, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1124.422, -955.376, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1125.365, -953.745, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1126.328, -952.076, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1127.261, -950.460, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1128.629, -950.159, 7.298), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1130.230, -951.083, 7.298), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1131.875, -952.033, 7.298), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1133.459, -952.947, 7.310), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1135.084, -953.886, 7.310), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1136.289, -955.698, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1135.375, -957.282, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1134.393, -958.982, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1133.465, -960.589, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1132.556, -962.164, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1130.665, -965.439, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1131.639, -963.752, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka2', coords = vec3(-1124.951, -975.335, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1126.010, -973.501, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1126.925, -971.917, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1127.903, -970.222, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1128.804, -968.661, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1129.719, -967.077, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1122.699, -975.337, 7.143), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1121.074, -974.398, 7.143), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1119.490, -973.484, 7.143), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1117.845, -972.534, 7.143), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1116.244, -971.610, 7.143), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka',  coords = vec3(-1121.621, -960.229, 7.310), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7planka1', coords = vec3(-1136.352, -954.657, 7.310), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7planka1', coords = vec3(-1123.967, -976.107, 7.143), rot = vec3(0.0, 0.0, 120.0) },

        { model = 'tworst_job7plankb',  coords = vec3(-1120.698, -961.820, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1122.575, -958.569, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1123.495, -956.975, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1125.346, -953.769, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1124.409, -955.391, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1126.327, -952.069, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1127.242, -950.485, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1128.591, -950.138, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1130.175, -951.053, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1131.851, -952.020, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1133.435, -952.935, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1135.050, -953.867, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1136.294, -955.711, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1135.380, -957.295, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1133.461, -960.618, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1134.398, -958.995, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1132.547, -962.202, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1131.627, -963.795, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1129.750, -967.047, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1130.670, -965.453, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1126.944, -971.906, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1125.970, -973.593, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1127.915, -970.224, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1128.846, -968.612, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1121.414, -977.485, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1119.799, -976.553, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1118.215, -975.638, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1116.539, -974.671, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1114.955, -973.756, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb',  coords = vec3(-1121.620, -960.223, 3.465), rot = vec3(0.0, 0.0,  30.0) },
        { model = 'tworst_job7plankb1', coords = vec3(-1136.303, -954.627, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb1', coords = vec3(-1122.683, -978.218, 3.465), rot = vec3(0.0, 0.0, 120.0) },
        { model = 'tworst_job7plankb2', coords = vec3(-1124.946, -975.365, 3.465), rot = vec3(0.0, 0.0,  30.0) },
    },
}

do
    local data = TwMeasuredJob7
    do
        local list = Config.Job7.sourcePiles
        if type(data) == 'table' and type(data.piles) == 'table' then
            if tonumber(data.pileCount) ~= #list then
                print(('^3[job7] measured_job7.lua was written for %d pile(s), there are now %d — NOT APPLIED. Re-save with /j7pile.^7')
                    :format(tonumber(data.pileCount) or -1, #list))
            else
                local n = 0
                for _, e in ipairs(data.piles) do
                    local p = list[tonumber(e.i) or 0]
                    if p and tonumber(e.x) and tonumber(e.rx) then
                        p.coords = vec3(e.x + 0.0, e.y + 0.0, e.z + 0.0)
                        p.rot    = vec3(e.rx + 0.0, e.ry + 0.0, e.rz + 0.0)
                        n = n + 1
                    end
                end
                if n > 0 and Config.Debug then print(('[job7] %d measured pile position(s) applied'):format(n)) end
            end
        end
    end
end
