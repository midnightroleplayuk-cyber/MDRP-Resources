-- Ranks inherit every node of the rank named in `inherits`.
Config.Ranks = {
    osg = {
        label = 'Operational Support Grade',
        nodes = { 'roster.view', 'cell.lock', 'intel.submit', 'account.view', 'cctv.view', 'alarm.raise' },
    },
    officer = {
        label = 'Prison Officer',
        inherits = 'osg',
        nodes = { 'reception.process', 'cell.allocate', 'search.cell', 'search.person', 'behaviour.add', 'regime.run', 'adjudication.charge', 'evidence.access', 'incident.manage', 'visits.manage', 'phone.manage', 'transport.escort', 'escape.recapture' },
    },
    so = {
        label = 'Supervising Officer',
        inherits = 'officer',
        nodes = { 'door.remote', 'iep.review', 'lockdown.wing', 'industries.manage', 'search.full', 'transport.manage' },
    },
    cm = {
        label = 'Custodial Manager',
        inherits = 'so',
        nodes = { 'segregation.place', 'intel.read', 'release.authorise', 'category.set', 'welfare.manage', 'gangs.manage' },
    },
    dutygov = {
        label = 'Duty Governor',
        inherits = 'cm',
        nodes = { 'adjudication.hear', 'lockdown.prison', 'sentence.adjust', 'audit.view', 'account.adjust', 'parole.review' },
    },
    governor = {
        label = 'Governing Governor',
        inherits = 'dutygov',
        nodes = { 'staff.manage', 'adjudication.additional_days' },
    },
}

-- Framework job grade -> rank. Unmapped grades use the nearest mapped grade below them.
Config.GradeRanks = {
    prison = {
        [0] = 'osg',
        [1] = 'officer',
        [2] = 'so',
        [3] = 'cm',
        [4] = 'dutygov',
        [5] = 'governor',
    },
}

-- ACE that grants every node (admins, support staff)
Config.AdminAce = 'vinewood_prison.admin'

-- Admins (the ace above) open every door. Set false to test doors as staff do:
-- admins then need the prison job and rank, or a keycard, like everyone else.
Config.AdminDoorBypass = true

-- ox_inventory item; metadata.level (1-5) must be >= the door's access level
Config.KeycardItem = 'prison_keycard'
