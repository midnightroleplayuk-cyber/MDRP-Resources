Config = {}

-- Show the Cayo Perico blip and enable its minimap overlay
Config.EnableCayoMap = true

-- Interior map overrides
-- When inside a building, the minimap will switch to the matching interior view.
-- Add an entry per building: interiorId -> { name, x, y }
-- The interiorId is what GetInteriorFromPrimaryView() returns while inside that building.
Config.Interiors = {
    -- Example:
    -- [120834] = { name = 'ex_cardealer_01',  x = 210.0,   y = -1002.0 },
    -- [237378] = { name = 'p_hotel_imn_foyer', x = -1452.0, y = -250.0  },
}
