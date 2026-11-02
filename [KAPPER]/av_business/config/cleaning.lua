-- More cleaning config can be found in admin panel > Bills tab > Dirt per craft % and clean per item use %
Config = Config or {}
-- Cleaning Products
Config.CleaningProducts = {
    ['cleaning_rag'] = {
        label = 'Cleaning',
        anim = {
            dict = 'amb@world_human_maid_clean@',
            clip = 'base'
        },
        time = 10000,
        canWalk = true,
        prop = {
            model = `prop_rag_01`,
            bone = 6286,
            pos = vec3(0.0, 0.0, 0.0),
            rot = vec3(0.0, 0.0, 0.0)
        },
    },
    ['cleaning_broom'] = {
        label = 'Cleaning',
        anim = {
            dict = 'anim@scripted@freemode@ig13_mop_floor@heeled@',
            clip = 'action'
        },
        time = 10000,
        canWalk = true,
        prop = {
            model = `prop_tool_broom`,
            bone = 57005,
            pos = vec3(0.2, -0.55, -0.5),
            rot = vec3(-45.0, -15.0, 7.10)
        },
    },
}