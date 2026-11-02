Config.Reception = {
    -- When on-duty staff are online, imprisonments wait at reception for an officer.
    -- With no staff online, reception processes automatically.
    RequireOfficer = true,
    ArrivalTimeout = 600,       -- seconds a pending arrival waits before automatic processing
    DeskRange = 10.0,           -- how close people must be to the reception desk to be processed

    AllowManualSentence = true, -- officers can enter a sentence at the desk (when no MoJ script)

    Categories = { 'A', 'B', 'C', 'D' },
    DefaultCategory = 'C',

    KeepItems = {},             -- item names never confiscated, e.g. { 'id_card' }
    KitItems = {                -- issued at reception
        { name = 'water', count = 1 },
        { name = 'bread', count = 1 },
    },

    -- Clothing system used to save the player's own look at reception and give it back at release.
    -- 'auto' finds the first one running. Or force one:
    --   '17mov' | 'illenium-appearance' | 'fivem-appearance' | 'qs-appearance' | 'skinchanger' | 'native'
    -- 'native' uses GTA's clothing functions only (clothes and props, not hair, tattoos or face).
    Clothing = 'auto',

    -- [component] = { drawable, texture }. Set these to your server's prison clothing.
    Uniform = {
        male = {
            components = { [3] = { 0, 0 }, [4] = { 7, 15 }, [6] = { 34, 0 }, [8] = { 15, 0 }, [11] = { 238, 0 } },
            clearProps = { 0, 1 },
        },
        female = {
            components = { [3] = { 14, 0 }, [4] = { 3, 15 }, [6] = { 35, 0 }, [8] = { 3, 0 }, [11] = { 247, 0 } },
            clearProps = { 0, 1 },
        },
    },
}
