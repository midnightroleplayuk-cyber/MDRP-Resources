-- ======= DO NOT EDIT THIS PART !!! FIELD CONFIGURATION BELOW !!! =========

local function createBoxZone(coords, width, height, data)
    if IsDuplicityVersion() then
        return
    end

    if PublicSharedSoccerConfig.PolyZone == "ox" then
        return lib.zones.box(
            {
                coords = coords,
                debug = false,
                size = vector3(height, width, coords.z),
                isInside = false,
                OnEnter = function(self)
                    self.isInside = true
                end,
                OnExit = function(self)
                    self.isInside = false
                end,
                isPointInside = function(self, point)
                    return self:contains(point)
                end,
                onPlayerInOut = function(self, onPointInOutCb)
                    CreateThread(function()
                        while self do
                            local point = GetEntityCoords(PlayerPedId())
                            local newIsInside = self:contains(point)
                            if newIsInside ~= self.isInside then
                                onPointInOutCb(newIsInside, point)
                                self.isInside = newIsInside
                            end
                            Wait(500)
                        end
                    end)
                end,
                rotation = data.heading,
            }
        )
    else
        return BoxZone:Create(coords, width, height, data)
    end
end

---@enum SoccerFieldPosition
SoccerFieldPosition = {
    GOALEE = 0,
    LEFT_PULLBACK = 1,
    RIGHT_PULLBACK = 2,
    LEFT_HALFBACK = 3,
    RIGHT_HALFBACK = 4,
    CENTER_HALFBACK = 5,
    LEFT_WING = 6,
    RIGHT_WING = 7,
    LEFT_INSIDE = 8,
    RIGHT_INSIDE = 9,
    CENTER_FORWARD = 10,
}

---@enum GoaleeMode
GoaleeMode = {
    NORMAL = 0,
    HANDS = 1,
}

---@enum GameplayMode
GameplayMode = {
    PLAYER = 0,
    GOALEE = 1,
}


RED_TEAM = 0
BLUE_TEAM = 1

-- =======================================
-- ______ _____ ______ _      _____   _____
-- |  ____|_   _|  ____| |    |  __ \ / ____|
-- | |__    | | | |__  | |    | |  | | (___
-- |  __|   | | |  __| | |    | |  | |\___ \
-- | |     _| |_| |____| |____| |__| |____) |
-- |_|    |_____|______|______|_____/|_____/

-- Hint: In order to generate positions easily, use the command /setupfield in game

---@type SoccerFieldSpec[]
SoccerFields = {
    -- Default Field
    {
        Key = "default_field",                       -- Field identifier, must be unique to each field or will error!
        Middle = vector3(771.279, -233.283, 65.214), -- Ball origin (middle)
        FieldZone = createBoxZone(vector3(771.29, -233.41, 66.11), 77.600000000001, 119.6,
            {                                        -- Polyzone for the field (must be bigger than the area zone and cover the npc)
                name = "default_field",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        AreaZone = createBoxZone(vector3(771.02, -233.89, 66.11), 39.4, 69.0,
            { -- Polyzone for the area (if ball leaves this area it's "out")
                name = "default_field_area",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        GoaleeZoneRed = createBoxZone(vector3(744.67, -220.58, 66.11), 20.6, 8.8,
            { -- Polyzone for the red team goalee area (where the goalee can use their hands)
                name = "default_field_goaleered",
                heading = 334,
                minZ = 65.11,
                maxZ = 69.11,
            }),
        GoaleeZoneBlue = createBoxZone(vector3(798.15, -247.13, 66.11), 20.0, 7.6,
            { -- Polyzone for the blue team goalee area (where the goalee can use their hands)
                name = "default_field_goaleeblue",
                heading = 333,
                minZ = 65.11,
                maxZ = 69.11
            }),
        RedTeamGoalZone = createBoxZone(vector3(740.98, -218.68, 66.11), 7.4, 0.4,
            { -- Polyzone for the red team goal (where the ball must be to score)
                name = "default_field_goalred",
                heading = 334,
                minZ = 64.11,
                maxZ = 68.11,
            }),
        BlueTeamGoalZone = createBoxZone(vector3(801.7, -248.6, 66.11), 7.4, 0.4,
            { -- Polyzone for the blue team goal (where the ball must be to score)
                name = "default_field_goalblue",
                heading = 333,
                minZ = 64.11,
                maxZ = 68.11
            }),
        ManagerNPC = { -- NPC that manages the field
            coords = vector3(772.376, -211.728, 65.114),
            heading = 166.779,
            model = "ig_djsolrobt"
        },
        Positions = { -- Positions for all player spots, generated with /setupfield
            { index = SoccerFieldPosition.GOALEE,          team = RED_TEAM,  position = vector3(741.93737792969, -219.08222961426, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.RIGHT_PULLBACK,  team = RED_TEAM,  position = vector3(746.72015380859, -228.20501708984, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.LEFT_PULLBACK,   team = RED_TEAM,  position = vector3(752.07208251953, -217.24157714844, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.CENTER_HALFBACK, team = RED_TEAM,  position = vector3(756.85485839844, -226.36436462402, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.RIGHT_HALFBACK,  team = RED_TEAM,  position = vector3(751.98547363281, -236.33929443359, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.LEFT_HALFBACK,   team = RED_TEAM,  position = vector3(761.72424316406, -216.38943481445, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.CENTER_FORWARD,  team = RED_TEAM,  position = vector3(764.31353759766, -230.00543212891, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.RIGHT_INSIDE,    team = RED_TEAM,  position = vector3(761.63757324219, -235.48715209961, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.LEFT_INSIDE,     team = RED_TEAM,  position = vector3(766.98950195313, -224.5237121582, 66.114501953125),  heading = 243.72 },
            { index = SoccerFieldPosition.RIGHT_WING,      team = RED_TEAM,  position = vector3(759.88287353516, -239.08171081543, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.LEFT_WING,       team = RED_TEAM,  position = vector3(768.74426269531, -220.92913818359, 66.114501953125), heading = 243.72 },
            { index = SoccerFieldPosition.GOALEE,          team = BLUE_TEAM, position = vector3(800.61871337891, -247.72821044922, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.RIGHT_PULLBACK,  team = BLUE_TEAM, position = vector3(795.8359375, -238.60543823242, 66.114501953125),     heading = 63.72 },
            { index = SoccerFieldPosition.LEFT_PULLBACK,   team = BLUE_TEAM, position = vector3(790.48400878906, -249.56886291504, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.CENTER_HALFBACK, team = BLUE_TEAM, position = vector3(785.70123291016, -240.44609069824, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.RIGHT_HALFBACK,  team = BLUE_TEAM, position = vector3(790.57061767578, -230.47116088867, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.LEFT_HALFBACK,   team = BLUE_TEAM, position = vector3(780.83190917969, -250.42102050781, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.CENTER_FORWARD,  team = BLUE_TEAM, position = vector3(778.24249267578, -236.80502319336, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.RIGHT_INSIDE,    team = BLUE_TEAM, position = vector3(780.91845703125, -231.32330322266, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.LEFT_INSIDE,     team = BLUE_TEAM, position = vector3(775.56652832031, -242.28674316406, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.RIGHT_WING,      team = BLUE_TEAM, position = vector3(782.67321777344, -227.72874450684, 66.114501953125), heading = 63.72 },
            { index = SoccerFieldPosition.LEFT_WING,       team = BLUE_TEAM, position = vector3(773.81182861328, -245.88131713867, 66.114501953125), heading = 63.72 },
        },
        TouchlinePositions = { -- Positions for throwing the ball when the ball goes out (closer selected automatically)
            { coords = vector4(735.550, -237.454, 66.116, 355.507) },
            { coords = vector4(738.542, -239.043, 66.117, 0.788) },
            { coords = vector4(741.017, -240.326, 66.115, 348.075) },
            { coords = vector4(743.991, -241.887, 66.114, 338.533) },
            { coords = vector4(746.842, -243.291, 66.114, 347.581) },
            { coords = vector4(749.714, -244.771, 66.114, 342.3) },
            { coords = vector4(752.529, -246.293, 66.114, 331.905) },
            { coords = vector4(755.395, -247.770, 66.114, 343.135) },
            { coords = vector4(758.161, -249.240, 66.114, 359.89) },
            { coords = vector4(760.483, -250.279, 66.114, 14.772) },
            { coords = vector4(763.671, -251.987, 66.114, 344.414) },
            { coords = vector4(766.308, -253.368, 66.114, 3.52) },
            { coords = vector4(769.143, -254.707, 66.114, 353.553) },
            { coords = vector4(771.905, -256.134, 66.114, 11.644) },
            { coords = vector4(775.027, -257.729, 66.114, 332.952) },
            { coords = vector4(777.878, -259.228, 66.114, 338.654) },
            { coords = vector4(780.592, -260.486, 66.114, 354.927) },
            { coords = vector4(783.431, -261.976, 66.114, 347.298) },
            { coords = vector4(786.857, -263.722, 66.111, 350.137) },
            { coords = vector4(789.666, -265.264, 66.107, 336.45) },
            { coords = vector4(806.676, -230.423, 66.114, 173.205) },
            { coords = vector4(803.783, -229.089, 66.114, 164.92) },
            { coords = vector4(800.710, -227.406, 66.114, 172.844) },
            { coords = vector4(797.887, -226.017, 66.114, 180.16) },
            { coords = vector4(794.749, -224.459, 66.114, 179.077) },
            { coords = vector4(791.520, -222.873, 66.114, 166.601) },
            { coords = vector4(788.420, -221.083, 66.114, 175.163) },
            { coords = vector4(785.380, -219.699, 66.114, 194.137) },
            { coords = vector4(782.516, -218.241, 66.116, 158.089) },
            { coords = vector4(779.722, -216.800, 66.116, 186.271) },
            { coords = vector4(776.900, -215.421, 66.116, 158.682) },
            { coords = vector4(773.146, -213.616, 66.114, 166.327) },
            { coords = vector4(770.191, -212.189, 66.114, 160.581) },
            { coords = vector4(767.245, -210.585, 66.114, 174.074) },
            { coords = vector4(764.345, -209.168, 66.114, 148.847) },
            { coords = vector4(761.699, -207.790, 66.114, 164.96) },
            { coords = vector4(758.868, -206.373, 66.114, 172.699) },
            { coords = vector4(755.570, -204.721, 66.114, 145.185) },
            { coords = vector4(752.080, -203.074, 66.114, 162.307) },
            { coords = vector4(792.475, -266.479, 66.107, 43.26),   corner = true, team = BLUE_TEAM },
            { coords = vector4(809.908, -232.213, 66.114, 123.743), corner = true, team = BLUE_TEAM },
            { coords = vector4(749.295, -201.838, 66.114, 222.925), corner = true, team = RED_TEAM },
            { coords = vector4(732.736, -235.856, 66.114, 295.626), corner = true, team = RED_TEAM },
        },
    },
     {
        Key = "jamestown_estate",                       -- Field identifier, must be unique to each field or will error!
        Middle = vector3(356.41, -2091.28, 17.42), -- Ball origin (middle)
        FieldZone = createBoxZone(vector3(356.41, -2091.28, 17.42), 77.600000000001, 119.6,
            {                                        -- Polyzone for the field (must be bigger than the area zone and cover the npc)
                name = "default_field",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        AreaZone = createBoxZone(vector3(771.02, -233.89, 66.11), 39.4, 69.0,
            { -- Polyzone for the area (if ball leaves this area it's "out")
                name = "default_field_area",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        GoaleeZoneRed = createBoxZone(vector3(366.95, -2101.55, 17.42), 20.6, 8.8,
            { -- Polyzone for the red team goalee area (where the goalee can use their hands)
                name = "default_field_goaleered",
                heading = 334,
                minZ = 65.11,
                maxZ = 69.11,
            }),
        GoaleeZoneBlue = createBoxZone(vector3(346.07, -2080.94, 17.42), 20.0, 7.6,
            { -- Polyzone for the blue team goalee area (where the goalee can use their hands)
                name = "default_field_goaleeblue",
                heading = 333,
                minZ = 65.11,
                maxZ = 69.11
            }),
        RedTeamGoalZone = createBoxZone(vec3(366.95, -2101.55, 17.42), 7.4, 0.4,
            { -- Polyzone for the red team goal (where the ball must be to score)
                name = "default_field_goalred",
                heading = 334,
                minZ = 64.11,
                maxZ = 68.11,
            }),
        BlueTeamGoalZone = createBoxZone(vector3(346.07, -2080.94, 17.42), 7.4, 0.4,
            { -- Polyzone for the blue team goal (where the ball must be to score)
                name = "default_field_goalblue",
                heading = 333,
                minZ = 64.11,
                maxZ = 68.11
            }),
        ManagerNPC = { -- NPC that manages the field - DONE HF1
            coords = vector3(365.54, -2088.71, 17.48),
            heading = 307.93,
            model = "a_m_m_tennis_01"
        },
        Positions = { -- DONE - HF1
{ index = SoccerFieldPosition.GOALEE, team = RED_TEAM, position = vector3(365.67156982422, -2100.5415039062, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_PULLBACK, team = RED_TEAM, position = vector3(364.69607543945, -2097.001953125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_PULLBACK, team = RED_TEAM, position = vector3(362.14010620117, -2099.537109375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.CENTER_HALFBACK, team = RED_TEAM, position = vector3(361.16461181641, -2095.9975585938, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_HALFBACK, team = RED_TEAM, position = vector3(365.99255371094, -2091.208984375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_HALFBACK, team = RED_TEAM, position = vector3(356.33666992188, -2100.7861328125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.CENTER_FORWARD, team = RED_TEAM, position = vector3(358.9111328125, -2093.7255859375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_INSIDE, team = RED_TEAM, position = vector3(360.18911743164, -2092.4580078125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_INSIDE, team = RED_TEAM, position = vector3(357.63314819336, -2094.9931640625, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_WING, team = RED_TEAM, position = vector3(363.02908325195, -2089.6411132812, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_WING, team = RED_TEAM, position = vector3(354.79321289062, -2097.8100585938, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.GOALEE, team = BLUE_TEAM, position = vector3(347.22125244141, -2081.9396972656, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_PULLBACK, team = BLUE_TEAM, position = vector3(348.19674682617, -2085.4792480469, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_PULLBACK, team = BLUE_TEAM, position = vector3(350.75271606445, -2082.9440917969, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.CENTER_HALFBACK, team = BLUE_TEAM, position = vector3(351.72821044922, -2086.4836425781, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_HALFBACK, team = BLUE_TEAM, position = vector3(346.90026855469, -2091.2722167969, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_HALFBACK, team = BLUE_TEAM, position = vector3(356.55615234375, -2081.6950683594, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.CENTER_FORWARD, team = BLUE_TEAM, position = vector3(353.98168945312, -2088.7556152344, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_INSIDE, team = BLUE_TEAM, position = vector3(352.70370483398, -2090.0231933594, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_INSIDE, team = BLUE_TEAM, position = vector3(355.25967407227, -2087.4880371094, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_WING, team = BLUE_TEAM, position = vector3(349.86373901367, -2092.8400878906, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_WING, team = BLUE_TEAM, position = vector3(358.099609375, -2084.6711425781, 18.419994354248), heading = 224.76585388184 },

        },
        TouchlinePositions = { -- Positions for throwing the ball when the ball goes out (closer selected automatically)
            { coords = vector4(735.550, -237.454, 66.116, 355.507) },
            { coords = vector4(738.542, -239.043, 66.117, 0.788) },
            { coords = vector4(741.017, -240.326, 66.115, 348.075) },
            { coords = vector4(743.991, -241.887, 66.114, 338.533) },
            { coords = vector4(746.842, -243.291, 66.114, 347.581) },
            { coords = vector4(749.714, -244.771, 66.114, 342.3) },
            { coords = vector4(752.529, -246.293, 66.114, 331.905) },
            { coords = vector4(755.395, -247.770, 66.114, 343.135) },
            { coords = vector4(758.161, -249.240, 66.114, 359.89) },
            { coords = vector4(760.483, -250.279, 66.114, 14.772) },
            { coords = vector4(763.671, -251.987, 66.114, 344.414) },
            { coords = vector4(766.308, -253.368, 66.114, 3.52) },
            { coords = vector4(769.143, -254.707, 66.114, 353.553) },
            { coords = vector4(771.905, -256.134, 66.114, 11.644) },
            { coords = vector4(775.027, -257.729, 66.114, 332.952) },
            { coords = vector4(777.878, -259.228, 66.114, 338.654) },
            { coords = vector4(780.592, -260.486, 66.114, 354.927) },
            { coords = vector4(783.431, -261.976, 66.114, 347.298) },
            { coords = vector4(786.857, -263.722, 66.111, 350.137) },
            { coords = vector4(789.666, -265.264, 66.107, 336.45) },
            { coords = vector4(806.676, -230.423, 66.114, 173.205) },
            { coords = vector4(803.783, -229.089, 66.114, 164.92) },
            { coords = vector4(800.710, -227.406, 66.114, 172.844) },
            { coords = vector4(797.887, -226.017, 66.114, 180.16) },
            { coords = vector4(794.749, -224.459, 66.114, 179.077) },
            { coords = vector4(791.520, -222.873, 66.114, 166.601) },
            { coords = vector4(788.420, -221.083, 66.114, 175.163) },
            { coords = vector4(785.380, -219.699, 66.114, 194.137) },
            { coords = vector4(782.516, -218.241, 66.116, 158.089) },
            { coords = vector4(779.722, -216.800, 66.116, 186.271) },
            { coords = vector4(776.900, -215.421, 66.116, 158.682) },
            { coords = vector4(773.146, -213.616, 66.114, 166.327) },
            { coords = vector4(770.191, -212.189, 66.114, 160.581) },
            { coords = vector4(767.245, -210.585, 66.114, 174.074) },
            { coords = vector4(764.345, -209.168, 66.114, 148.847) },
            { coords = vector4(761.699, -207.790, 66.114, 164.96) },
            { coords = vector4(758.868, -206.373, 66.114, 172.699) },
            { coords = vector4(755.570, -204.721, 66.114, 145.185) },
            { coords = vector4(752.080, -203.074, 66.114, 162.307) },
            { coords = vector4(792.475, -266.479, 66.107, 43.26),   corner = true, team = BLUE_TEAM },
            { coords = vector4(809.908, -232.213, 66.114, 123.743), corner = true, team = BLUE_TEAM },
            { coords = vector4(749.295, -201.838, 66.114, 222.925), corner = true, team = RED_TEAM },
            { coords = vector4(732.736, -235.856, 66.114, 295.626), corner = true, team = RED_TEAM },
        },
    },
         {
        Key = "midnight_prison",                       -- Field identifier, must be unique to each field or will error!
        Middle = vec3(1145.95, -1327.46, 33.6), -- Ball origin (middle)
        FieldZone = createBoxZone(vector3(356.41, -2091.28, 17.42), 77.600000000001, 119.6,
            {                                        -- Polyzone for the field (must be bigger than the area zone and cover the npc)
                name = "default_field",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        AreaZone = createBoxZone(vector3(771.02, -233.89, 66.11), 39.4, 69.0,
            { -- Polyzone for the area (if ball leaves this area it's "out")
                name = "default_field_area",
                heading = 333,
                minZ = 30.91,
                maxZ = 95.91,
            }),
        GoaleeZoneRed = createBoxZone(vector3(744.67, -220.58, 66.11), 20.6, 8.8,
            { -- Polyzone for the red team goalee area (where the goalee can use their hands)
                name = "default_field_goaleered",
                heading = 334,
                minZ = 65.11,
                maxZ = 69.11,
            }),
        GoaleeZoneBlue = createBoxZone(vector3(798.15, -247.13, 66.11), 20.0, 7.6,
            { -- Polyzone for the blue team goalee area (where the goalee can use their hands)
                name = "default_field_goaleeblue",
                heading = 333,
                minZ = 65.11,
                maxZ = 69.11
            }),
        RedTeamGoalZone = createBoxZone(vector3(740.98, -218.68, 66.11), 7.4, 0.4,
            { -- Polyzone for the red team goal (where the ball must be to score)
                name = "default_field_goalred",
                heading = 334,
                minZ = 64.11,
                maxZ = 68.11,
            }),
        BlueTeamGoalZone = createBoxZone(vector3(801.7, -248.6, 66.11), 7.4, 0.4,
            { -- Polyzone for the blue team goal (where the ball must be to score)
                name = "default_field_goalblue",
                heading = 333,
                minZ = 64.11,
                maxZ = 68.11
            }),
        ManagerNPC = { -- NPC that manages the field - DONE HF1
            coords = vector3(1135.68, -1328.81, 33.48),
            heading = 88.02,
            model = "a_m_m_tennis_01"
        },
        Positions = { -- 
{ index = SoccerFieldPosition.GOALEE, team = RED_TEAM, position = vector3(365.67156982422, -2100.5415039062, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_PULLBACK, team = RED_TEAM, position = vector3(364.69607543945, -2097.001953125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_PULLBACK, team = RED_TEAM, position = vector3(362.14010620117, -2099.537109375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.CENTER_HALFBACK, team = RED_TEAM, position = vector3(361.16461181641, -2095.9975585938, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_HALFBACK, team = RED_TEAM, position = vector3(365.99255371094, -2091.208984375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_HALFBACK, team = RED_TEAM, position = vector3(356.33666992188, -2100.7861328125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.CENTER_FORWARD, team = RED_TEAM, position = vector3(358.9111328125, -2093.7255859375, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_INSIDE, team = RED_TEAM, position = vector3(360.18911743164, -2092.4580078125, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_INSIDE, team = RED_TEAM, position = vector3(357.63314819336, -2094.9931640625, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.RIGHT_WING, team = RED_TEAM, position = vector3(363.02908325195, -2089.6411132812, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.LEFT_WING, team = RED_TEAM, position = vector3(354.79321289062, -2097.8100585938, 18.419994354248), heading = 44.765830993652 },
{ index = SoccerFieldPosition.GOALEE, team = BLUE_TEAM, position = vector3(347.22125244141, -2081.9396972656, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_PULLBACK, team = BLUE_TEAM, position = vector3(348.19674682617, -2085.4792480469, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_PULLBACK, team = BLUE_TEAM, position = vector3(350.75271606445, -2082.9440917969, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.CENTER_HALFBACK, team = BLUE_TEAM, position = vector3(351.72821044922, -2086.4836425781, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_HALFBACK, team = BLUE_TEAM, position = vector3(346.90026855469, -2091.2722167969, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_HALFBACK, team = BLUE_TEAM, position = vector3(356.55615234375, -2081.6950683594, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.CENTER_FORWARD, team = BLUE_TEAM, position = vector3(353.98168945312, -2088.7556152344, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_INSIDE, team = BLUE_TEAM, position = vector3(352.70370483398, -2090.0231933594, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_INSIDE, team = BLUE_TEAM, position = vector3(355.25967407227, -2087.4880371094, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.RIGHT_WING, team = BLUE_TEAM, position = vector3(349.86373901367, -2092.8400878906, 18.419994354248), heading = 224.76585388184 },
{ index = SoccerFieldPosition.LEFT_WING, team = BLUE_TEAM, position = vector3(358.099609375, -2084.6711425781, 18.419994354248), heading = 224.76585388184 },

        },
        TouchlinePositions = { -- Positions for throwing the ball when the ball goes out (closer selected automatically)
            { coords = vector4(735.550, -237.454, 66.116, 355.507) },
            { coords = vector4(738.542, -239.043, 66.117, 0.788) },
            { coords = vector4(741.017, -240.326, 66.115, 348.075) },
            { coords = vector4(743.991, -241.887, 66.114, 338.533) },
            { coords = vector4(746.842, -243.291, 66.114, 347.581) },
            { coords = vector4(749.714, -244.771, 66.114, 342.3) },
            { coords = vector4(752.529, -246.293, 66.114, 331.905) },
            { coords = vector4(755.395, -247.770, 66.114, 343.135) },
            { coords = vector4(758.161, -249.240, 66.114, 359.89) },
            { coords = vector4(760.483, -250.279, 66.114, 14.772) },
            { coords = vector4(763.671, -251.987, 66.114, 344.414) },
            { coords = vector4(766.308, -253.368, 66.114, 3.52) },
            { coords = vector4(769.143, -254.707, 66.114, 353.553) },
            { coords = vector4(771.905, -256.134, 66.114, 11.644) },
            { coords = vector4(775.027, -257.729, 66.114, 332.952) },
            { coords = vector4(777.878, -259.228, 66.114, 338.654) },
            { coords = vector4(780.592, -260.486, 66.114, 354.927) },
            { coords = vector4(783.431, -261.976, 66.114, 347.298) },
            { coords = vector4(786.857, -263.722, 66.111, 350.137) },
            { coords = vector4(789.666, -265.264, 66.107, 336.45) },
            { coords = vector4(806.676, -230.423, 66.114, 173.205) },
            { coords = vector4(803.783, -229.089, 66.114, 164.92) },
            { coords = vector4(800.710, -227.406, 66.114, 172.844) },
            { coords = vector4(797.887, -226.017, 66.114, 180.16) },
            { coords = vector4(794.749, -224.459, 66.114, 179.077) },
            { coords = vector4(791.520, -222.873, 66.114, 166.601) },
            { coords = vector4(788.420, -221.083, 66.114, 175.163) },
            { coords = vector4(785.380, -219.699, 66.114, 194.137) },
            { coords = vector4(782.516, -218.241, 66.116, 158.089) },
            { coords = vector4(779.722, -216.800, 66.116, 186.271) },
            { coords = vector4(776.900, -215.421, 66.116, 158.682) },
            { coords = vector4(773.146, -213.616, 66.114, 166.327) },
            { coords = vector4(770.191, -212.189, 66.114, 160.581) },
            { coords = vector4(767.245, -210.585, 66.114, 174.074) },
            { coords = vector4(764.345, -209.168, 66.114, 148.847) },
            { coords = vector4(761.699, -207.790, 66.114, 164.96) },
            { coords = vector4(758.868, -206.373, 66.114, 172.699) },
            { coords = vector4(755.570, -204.721, 66.114, 145.185) },
            { coords = vector4(752.080, -203.074, 66.114, 162.307) },
            { coords = vector4(792.475, -266.479, 66.107, 43.26),   corner = true, team = BLUE_TEAM },
            { coords = vector4(809.908, -232.213, 66.114, 123.743), corner = true, team = BLUE_TEAM },
            { coords = vector4(749.295, -201.838, 66.114, 222.925), corner = true, team = RED_TEAM },
            { coords = vector4(732.736, -235.856, 66.114, 295.626), corner = true, team = RED_TEAM },
        },
    },
    -- MBA Field
    {
        Key = "mba_field",
        Middle = vector3(-324.230011, -1968.500000, 20.745253), -- since this field requires a special setup, do not change this position or it will break the field
        IsGabzMBA = true,
        FieldZone = createBoxZone(vector3(-324.33, -1968.61, 21.62), 37.0, 63.8, {
            name = "mba_field",
            heading = 320,
            minZ = 20.62,
            maxZ = 43.82,
            debugPoly = false
        }),
        AreaZone = createBoxZone(vector3(-324.31, -1968.43, 21.62), 30.2, 60.25, {
            name = "mba_area",
            heading = 320,
            minZ = 20.62,
            maxZ = 43.82,
            debugPoly = false
        }),
        GoaleeZoneRed = createBoxZone(vector3(-304.8, -1984.75, 21.62), 8.25, 9.8, {
            name = "mba_field_goaleered",
            heading = 320,
            minZ = 20.62,
            maxZ = 43.82,
            debugPoly = false,
        }),
        GoaleeZoneBlue = createBoxZone(vector3(-343.59, -1952.2, 21.62), 8.25, 9.8, {
            name = "mba_field_goaleeblue",
            heading = 320,
            minZ = 20.62,
            maxZ = 43.82,
            debugPoly = false,
        }),
        RedTeamGoalZone = createBoxZone(vector3(-300.87, -1988.09, 21.62), 5.45, 0.8, {
            name = "mba_field_goalred",
            heading = 320,
            debugPoly = false,
            minZ = 19.27,
            maxZ = 23.27,
        }),
        BlueTeamGoalZone = createBoxZone(vector3(-347.59, -1948.87, 21.62), 5.45, 0.8, {
            name = "mba_field_goalblue",
            heading = 320,
            debugPoly = false,
            minZ = 19.22,
            maxZ = 23.22
        }),
        ManagerNPC = {
            coords = vector3(-319.52, -1952.22, 20.6),
            heading = 272.44,
            model = "ig_djsolrobt"
        },
        Positions = {
            { index = SoccerFieldPosition.GOALEE,          team = RED_TEAM,  position = vector3(-302.70343017578, -1986.6872558594, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.RIGHT_PULLBACK,  team = RED_TEAM,  position = vector3(-305.04507446289, -1978.1545410156, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.LEFT_PULLBACK,   team = RED_TEAM,  position = vector3(-311.50570678711, -1985.7873535156, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.CENTER_HALFBACK, team = RED_TEAM,  position = vector3(-313.8473815918, -1977.2547607422, 21.620252609253),  heading = 49.754508972168 },
            { index = SoccerFieldPosition.RIGHT_HALFBACK,  team = RED_TEAM,  position = vector3(-307.38671875, -1969.6219482422, 21.620252609253),    heading = 49.754508972168 },
            { index = SoccerFieldPosition.LEFT_HALFBACK,   team = RED_TEAM,  position = vector3(-320.30801391602, -1984.8875732422, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.CENTER_FORWARD,  team = RED_TEAM,  position = vector3(-319.41934204102, -1972.5384521484, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.RIGHT_INSIDE,    team = RED_TEAM,  position = vector3(-316.18902587891, -1968.7220458984, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.LEFT_INSIDE,     team = RED_TEAM,  position = vector3(-322.64965820313, -1976.3548583984, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.RIGHT_WING,      team = RED_TEAM,  position = vector3(-313.6047668457, -1965.6689453125, 21.620252609253),  heading = 49.754508972168 },
            { index = SoccerFieldPosition.LEFT_WING,       team = RED_TEAM,  position = vector3(-325.23391723633, -1979.4079589844, 21.620252609253), heading = 49.754508972168 },
            { index = SoccerFieldPosition.GOALEE,          team = BLUE_TEAM, position = vector3(-345.75262451172, -1950.2492675781, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.RIGHT_PULLBACK,  team = BLUE_TEAM, position = vector3(-343.41098022461, -1958.7819824219, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.LEFT_PULLBACK,   team = BLUE_TEAM, position = vector3(-336.95034790039, -1951.1491699219, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.CENTER_HALFBACK, team = BLUE_TEAM, position = vector3(-334.60870361328, -1959.6817626953, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.RIGHT_HALFBACK,  team = BLUE_TEAM, position = vector3(-341.0693359375, -1967.3146972656, 21.620252609253),  heading = 229.75450134277 },
            { index = SoccerFieldPosition.LEFT_HALFBACK,   team = BLUE_TEAM, position = vector3(-328.14804077148, -1952.0489501953, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.CENTER_FORWARD,  team = BLUE_TEAM, position = vector3(-329.03671264648, -1964.3980712891, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.RIGHT_INSIDE,    team = BLUE_TEAM, position = vector3(-332.26705932617, -1968.2144775391, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.LEFT_INSIDE,     team = BLUE_TEAM, position = vector3(-325.80639648438, -1960.5816650391, 21.620252609253), heading = 229.75450134277 },
            { index = SoccerFieldPosition.RIGHT_WING,      team = BLUE_TEAM, position = vector3(-334.8512878418, -1971.267578125, 21.620252609253),   heading = 229.75450134277 },
            { index = SoccerFieldPosition.LEFT_WING,       team = BLUE_TEAM, position = vector3(-323.22213745117, -1957.5285644531, 21.620252609253), heading = 229.75450134277 },
        },
        TouchlinePositions = {
            { coords = vector4(-319.98, -1991.31, 21.62, 334.15) },
            { coords = vector4(-323.26, -1988.54, 21.62, 306.95) },
            { coords = vector4(-326.5, -1985.72, 21.62, 344.9) },
            { coords = vector4(-329.87, -1983.03, 21.62, 315.47) },
            { coords = vector4(-332.85, -1980.52, 21.62, 329.66) },
            { coords = vector4(-336.5, -1977.47, 21.62, 320.53) },
            { coords = vector4(-339.8, -1974.7, 21.62, 339.69) },
            { coords = vector4(-342.63, -1972.31, 21.62, 321.61) },
            { coords = vector4(-345.35, -1970.01, 21.62, 342.17) },
            { coords = vector4(-348.04, -1967.78, 21.62, 307.57) },
            { coords = vector4(-325.88, -1947.82, 21.62, 140.77) },
            { coords = vector4(-322.96, -1950.33, 21.62, 145.21) },
            { coords = vector4(-320.4, -1952.42, 21.62, 157.88) },
            { coords = vector4(-317.4, -1954.97, 21.62, 158.17) },
            { coords = vector4(-314.52, -1957.42, 21.62, 150.34) },
            { coords = vector4(-311.86, -1959.65, 21.62, 153.63) },
            { coords = vector4(-308.52, -1962.37, 21.62, 116.69) },
            { coords = vector4(-306.05, -1964.46, 21.62, 158.72) },
            { coords = vector4(-302.51, -1967.46, 21.62, 142.15) },
            { coords = vector4(-300.03, -1969.63, 21.62, 130.02) },
            { coords = vector4(-337.46, -1942.26, 21.62, 181.02), corner = true, team = BLUE_TEAM },
            { coords = vector4(-352.18, -1961.1, 21.62, 329.97),  corner = true, team = BLUE_TEAM },
            { coords = vector4(-312.71, -1994.75, 21.62, 345.31), corner = true, team = RED_TEAM },
            { coords = vector4(-296.43, -1975.06, 21.62, 142.28), corner = true, team = RED_TEAM },
        },
    }
}

if not IsDuplicityVersion() then
    -- Add scenario blocks here if needed
    SetPedPathsInArea(749.258, -201.411, 0.0, 793.137, -267.084, 90.0, false)
    AddScenarioBlockingArea(749.258, -201.411, 0.0, 793.137, -267.084, 90.0, false, true, true, true)
end
