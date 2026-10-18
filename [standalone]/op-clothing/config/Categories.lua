-- ------------------------------------------------------------------------------
-- OP Clothing - Categories
-- module = clothing | barber | tattoo
-- kind   = component | prop | hair | hairFade | overlay | eyeColor
-- noneDrawable = drawable used as "off" / empty slot
-- display = 'slider' forces scrub UI instead of thumbnail grid
-- ------------------------------------------------------------------------------

Config.Categories = {
    -- -- Clothing (components) --------------------------------------------------
    { id = 'jacket',     module = 'clothing', kind = 'component', index = 11, texture = true, icon = 'shirt',              labelKey = 'category.jacket',     order = 10 },
    { id = 'undershirt', module = 'clothing', kind = 'component', index = 8,  texture = true, noneDrawable = 15, icon = 'shirt', labelKey = 'category.undershirt', order = 20 },
    { id = 'torso',      module = 'clothing', kind = 'component', index = 3,  texture = true, icon = 'shirt',              labelKey = 'category.torso',      order = 30 }, -- arms / gloves
    { id = 'pants',      module = 'clothing', kind = 'component', index = 4,  texture = true, icon = 'rectangle-vertical', labelKey = 'category.pants',      order = 40 },
    { id = 'shoes',      module = 'clothing', kind = 'component', index = 6,  texture = true, icon = 'footprints',         labelKey = 'category.shoes',      order = 50 },
    { id = 'bag',        module = 'clothing', kind = 'component', index = 5,  texture = true, noneDrawable = 0, icon = 'backpack', labelKey = 'category.bag', order = 60 },
    { id = 'armor',      module = 'clothing', kind = 'component', index = 9,  texture = true, icon = 'shield',             labelKey = 'category.armor',      order = 70 },
    { id = 'mask',       module = 'clothing', kind = 'component', index = 1,  texture = true, noneDrawable = 0, icon = 'venetian-mask', labelKey = 'category.mask', order = 80 },
    { id = 'accessory',  module = 'clothing', kind = 'component', index = 7,  texture = true, noneDrawable = 0, icon = 'gem', labelKey = 'category.accessory', order = 90 },
    { id = 'decals',     module = 'clothing', kind = 'component', index = 10, texture = true, display = 'slider', icon = 'sticker', labelKey = 'category.decals', order = 120 },

    -- -- Clothing (props) -------------------------------------------------------
    { id = 'hat',      module = 'clothing', kind = 'prop', index = 0, texture = true, icon = 'hard-hat', labelKey = 'category.hat',      order = 100 },
    { id = 'glasses',  module = 'clothing', kind = 'prop', index = 1, texture = true, icon = 'glasses',  labelKey = 'category.glasses',  order = 110 },
    { id = 'ears',     module = 'clothing', kind = 'prop', index = 2, texture = true, icon = 'ear',      labelKey = 'category.ears',     order = 130 },
    { id = 'watch',    module = 'clothing', kind = 'prop', index = 6, texture = true, icon = 'watch',    labelKey = 'category.watch',    order = 140 },
    { id = 'bracelet', module = 'clothing', kind = 'prop', index = 7, texture = true, icon = 'circle',   labelKey = 'category.bracelet', order = 150 },

    -- -- Barber -----------------------------------------------------------------
    { id = 'hair',       module = 'barber', kind = 'hair',     index = 2,  texture = true, color = true, palette = 'hair',   icon = 'scissors', labelKey = 'category.hair',       order = 10 },
    { id = 'hairfade',   module = 'barber', kind = 'hairFade', index = 0,  color = true, palette = 'hair', icon = 'scissors', labelKey = 'category.hairfade', order = 15 },
    { id = 'beard',      module = 'barber', kind = 'overlay',  index = 1,  color = true, palette = 'hair',   icon = 'user',     labelKey = 'category.beard',      order = 20 },
    { id = 'eyebrows',   module = 'barber', kind = 'overlay',  index = 2,  color = true, palette = 'hair',   icon = 'eye',      labelKey = 'category.eyebrows',   order = 30 },
    { id = 'chesthair',  module = 'barber', kind = 'overlay',  index = 10, color = true, palette = 'hair',   icon = 'user',     labelKey = 'category.chesthair',  order = 40 },
    { id = 'makeup',     module = 'barber', kind = 'overlay',  index = 4,  color = true, palette = 'makeup', icon = 'palette',  labelKey = 'category.makeup',     order = 50 },
    { id = 'blush',      module = 'barber', kind = 'overlay',  index = 5,  color = true, palette = 'makeup', icon = 'palette',  labelKey = 'category.blush',      order = 60 },
    { id = 'lipstick',   module = 'barber', kind = 'overlay',  index = 8,  color = true, palette = 'makeup', icon = 'palette',  labelKey = 'category.lipstick',   order = 70 },
    { id = 'blemishes',  module = 'barber', kind = 'overlay',  index = 0,  icon = 'circle-dot', labelKey = 'category.blemishes',  order = 80 },
    { id = 'ageing',     module = 'barber', kind = 'overlay',  index = 3,  icon = 'clock',      labelKey = 'category.ageing',     order = 90 },
    { id = 'complexion', module = 'barber', kind = 'overlay',  index = 6,  icon = 'droplet',    labelKey = 'category.complexion', order = 100 },
    { id = 'sundamage',  module = 'barber', kind = 'overlay',  index = 7,  icon = 'sun',        labelKey = 'category.sundamage',  order = 110 },
    { id = 'moles',      module = 'barber', kind = 'overlay',  index = 9,  icon = 'circle-dot', labelKey = 'category.moles',      order = 120 },
    { id = 'eyecolor',   module = 'barber', kind = 'eyeColor', index = 0,  icon = 'eye',        labelKey = 'category.eyecolor',   order = 130 },
}