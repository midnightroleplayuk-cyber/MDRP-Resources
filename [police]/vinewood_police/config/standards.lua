---------------------------------------------------------------------------
-- Professional standards (phase 5): use of force forms, discharge reviews, complaints, audit viewer.
---------------------------------------------------------------------------
Config.Standards = {
    Command = 'standards',          -- supervisors' panel (permission standards.view)
    ComplaintCommand = 'complaint', -- anyone can make a complaint about an officer
    ComplaintCooldown = 600,        -- seconds between complaints from the same player

    -- Use of force tactics and reasons (based on the national use of force form)
    Tactics = {
        'Handcuffing (compliant)', 'Handcuffing (non-compliant)', 'Unarmed skills', 'Ground restraint', 'Limb or body restraints',
        'Baton drawn', 'Baton used', 'Irritant spray drawn', 'Irritant spray used',
        'Taser drawn', 'Taser aimed', 'Taser red-dotted', 'Taser fired', 'Taser drive-stun',
        'Firearm aimed', 'Firearm fired', 'Police dog deployed', 'Spit and bite guard',
    },
    Reasons = { 'Protect self', 'Protect other officers', 'Protect the public', 'Protect the subject', 'Prevent an offence',
        'Effect an arrest', 'Prevent escape', 'Remove a weapon', 'Prevent harm to property' },

    -- A form is waiting for the officer after these (they fill it in from the hub's Forms tab)
    PromptOnCuff = true,
    PromptOnTaser = true,
    PromptOnFirearm = true,
    -- Weapons whose firing starts a use of force form
    TaserWeapons = { 'WEAPON_STUNGUN' },
    FirearmWeapons = { 'WEAPON_PISTOL', 'WEAPON_CARBINERIFLE' },

    ComplaintCategories = { 'Rudeness or incivility', 'Use of force', 'Unfair treatment', 'Unlawful arrest or detention',
        'Search', 'Property', 'Driving', 'Other' },
    ComplaintStatuses = { 'Received', 'Under investigation', 'Local resolution', 'Upheld', 'Not upheld', 'Withdrawn' },
    DischargeOutcomes = { 'Justified', 'Words of advice', 'Further investigation', 'Referred to professional standards' },
}
