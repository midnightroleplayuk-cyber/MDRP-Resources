-- ============================================================
-- PED LIST — "Change Ped" in Self Options
-- ------------------------------------------------------------
-- Add as many entries as you like. `value` must be a valid ped
-- model name; a full list is at https://docs.fivem.net/peds/
--
-- The 'Reset' entry restores the player's own character and
-- should stay at the top.
-- ============================================================
Peds = {
    { label = 'Reset (restore character)', value = 'restore' },

    -- Freemode
    { label = 'Freemode Male',    value = 'mp_m_freemode_01' },
    { label = 'Freemode Female',  value = 'mp_f_freemode_01' },

    -- Emergency services
    { label = 'Police Officer',   value = 's_m_y_cop_01' },
    { label = 'Police Officer 2', value = 's_f_y_cop_01' },
    { label = 'Sheriff',          value = 's_m_y_sheriff_01' },
    { label = 'Paramedic',        value = 's_m_m_paramedic_01' },
    { label = 'Firefighter',      value = 's_m_y_fireman_01' },

    -- Civilian
    { label = 'Business Man',     value = 'a_m_y_business_01' },
    { label = 'Business Woman',   value = 'a_f_y_business_01' },
    { label = 'Beach Woman',      value = 'a_f_m_beach_01' },
    { label = 'Beach Man',        value = 'a_m_y_beach_01' },
    { label = 'Construction',     value = 's_m_y_construct_01' },
    { label = 'Mechanic',         value = 's_m_y_xmech_01' },
    { label = 'Chef',             value = 's_m_y_chef_01' },
    { label = 'Security Guard',   value = 's_m_m_security_01' },

    -- Story characters
    { label = 'Michael',          value = 'player_zero' },
    { label = 'Franklin',         value = 'player_one' },
    { label = 'Trevor',           value = 'player_two' },
}
