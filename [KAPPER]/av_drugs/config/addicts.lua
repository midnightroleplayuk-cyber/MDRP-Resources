Config = Config or {}
--[[
    Addicts are only generated if some player has sold drugs in the zone during the current tsunami
    Addicts zones are reset after server restart
]]--
Config.UseAddicts = true -- true/false random NPC inside the drug selling areas will turn into addicts
Config.AddictsDebug = false -- A specific debug value for this because is a loop and it will spam console every X seconds
Config.BlacklistedPeds = { -- This peds will be ignored
    [`mp_f_freemode_01`] = true,
    [`mp_m_freemode_01`] = true,
    [`mp_m_fibsec_01`] = true,
    [`csb_cop`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
    [`s_m_m_snowcop_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`mp_m_shopkeep_01`] = true,
}
Config.BlacklistedZones = { -- This zones will not spawn addicts npc
    ['zoneName'] = true
}