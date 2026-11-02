Config = Config or {}
Config.CounterStashWeight = 100000
Config.CounterStashSlots = 25
Config.CounterStashLabel = "Counter Stash"

Config.CounterNPC = {
    ['avscripts'] = { -- index key should be the job name linked to the business
        {
            model = "mp_m_shopkeep_01", -- model name for the npc
            coords = vector4(-271.3835, 220.5195, 89.5726, 355.8087), -- coords vector4(x,y,z,heading) for the npc
        },
        {
            model = "mp_m_shopkeep_01", -- model name for the npc
            coords = vector4(-274.0507, 220.5029, 89.5726, 5.8135), -- coords vector4(x,y,z,heading) for the npc
        },
    }
}