-- ------------------------------------------------------------------------------
-- OP Clothing - Shop Templates
-- Defines shop type, branding and default pricing.
-- Locations: /clothingadmin -> data/shops_store.json
-- ------------------------------------------------------------------------------

Config.ShopTemplates = {
    binco = {
        type              = 'clothing',
        label             = 'Binco',
        logo              = 'binco.png',
        blip              = { enabled = true, sprite = 73, color = 47, scale = 0.8, shortRange = true },
        allowedCategories = 'all',
        pricing           = { modules = { clothing = 35 } },
    },

    suburban = {
        type              = 'clothing',
        label             = 'Suburban',
        logo              = 'suburban.png',
        blip              = { enabled = true, sprite = 73, color = 47, scale = 0.8, shortRange = true },
        allowedCategories = 'all',
        pricing           = { modules = { clothing = 55 } },
    },

    ponsonbys = {
        type              = 'clothing',
        label             = 'Ponsonbys',
        logo              = 'ponsonbys.png',
        blip              = { enabled = true, sprite = 73, color = 4, scale = 0.8, shortRange = true },
        allowedCategories = 'all',
        pricing           = { modules = { clothing = 90 } },
    },

    mask = {
        type              = 'clothing',
        label             = 'Mask Shop',
        blip              = { enabled = true, sprite = 362, color = 0, scale = 0.75, shortRange = true },
        allowedCategories = { 'mask' },
        pricing           = { categories = { mask = 30 } },
    },

    barber = {
        type              = 'barber',
        label             = 'Barber Shop',
        blip              = { enabled = true, sprite = 71, color = 25, scale = 0.7, shortRange = true },
        allowedCategories = 'all',
    },

    tattoo = {
        type           = 'tattoo',
        label          = 'Tattoo Parlor',
        blip           = { enabled = true, sprite = 75, color = 1, scale = 0.7, shortRange = true },
        allowedTattoos = {},
    },

    surgeon = {
        type              = 'surgeon',
        label             = 'Plastic Surgery',
        blip              = { enabled = true, sprite = 153, color = 4, scale = 0.7, shortRange = true },
        allowedCategories = 'none',
        pricing           = { modules = { surgeon = 250 } },
    },
}