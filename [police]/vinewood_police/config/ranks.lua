---------------------------------------------------------------------------
-- Ranks, in order. Level decides seniority: a permission needing 'ps'
-- is open to every rank at or above sergeant.
---------------------------------------------------------------------------
Config.Ranks = {
    { id = 'student', label = 'Student Officer',           short = 'SPC',    level = 1 },
    { id = 'pc',      label = 'Police Constable',          short = 'PC',     level = 2 },
    { id = 'ps',      label = 'Police Sergeant',           short = 'PS',     level = 3 },
    { id = 'insp',    label = 'Inspector',                 short = 'Insp',   level = 4 },
    { id = 'ci',      label = 'Chief Inspector',           short = 'CI',     level = 5 },
    { id = 'supt',    label = 'Superintendent',            short = 'Supt',   level = 6 },
    { id = 'csupt',   label = 'Chief Superintendent',      short = 'C/Supt', level = 7 },
    { id = 'acc',     label = 'Assistant Chief Constable', short = 'ACC',    level = 8 },
    { id = 'dcc',     label = 'Deputy Chief Constable',    short = 'DCC',    level = 9 },
    { id = 'cc',      label = 'Chief Constable',           short = 'CC',     level = 10 },
}

---------------------------------------------------------------------------
-- Police jobs and how framework grades map onto ranks.
-- A grade that isn't listed takes the nearest listed grade below it.
---------------------------------------------------------------------------
Config.Jobs = {
    police = {
        label = 'Police',
        grades = {
            [0] = 'student',
            [1] = 'pc',
            [2] = 'ps',
            [3] = 'insp',
            [4] = 'ci',
            [5] = 'supt',
            [6] = 'csupt',
            [7] = 'cc',
        },
    },
}

---------------------------------------------------------------------------
-- Permissions.
--   rank           lowest rank allowed
--   duty           false = allowed off duty (default: must be on duty)
--   qualifications every one listed must be held and in date
-- Later drops add their own entries here.
---------------------------------------------------------------------------
Config.Permissions = {
    ['duty.toggle']    = { rank = 'student', duty = false },
    ['qual.view']      = { rank = 'student', duty = false },
    ['qual.grant']     = { rank = 'ps' },
    ['qual.revoke']    = { rank = 'ps' },
    ['officer.collar'] = { rank = 'ps' },
    ['audit.view']     = { rank = 'insp', duty = false },

    ['duty.status']    = { rank = 'student' },
    ['roster.view']    = { rank = 'student' },
    ['notebook.write'] = { rank = 'student', duty = false },

    ['equipment.basic']    = { rank = 'student' },
    ['equipment.taser']    = { rank = 'pc', qualifications = { 'taser' } },
    ['equipment.firearms'] = { rank = 'pc', qualifications = { 'firearms' } },
    ['restraint.cuff']     = { rank = 'student' },
    ['restraint.escort']   = { rank = 'student' },
    ['arrest.make']        = { rank = 'student' },
    ['search.person']      = { rank = 'student' },
    ['search.seize']       = { rank = 'student' },
    ['stopsearch.record']  = { rank = 'student' },
    ['arrest.release']     = { rank = 'student' },
    ['roads.stop']         = { rank = 'student' },
    ['roads.ticket']       = { rank = 'student' },
    ['roads.search']       = { rank = 'student' },
    ['roads.test']         = { rank = 'student' },
    ['roads.seize']        = { rank = 'pc' },
    ['scene.place']        = { rank = 'student' },
    ['custody.view']       = { rank = 'student' },
    ['custody.cells']      = { rank = 'student' },                                  -- cells, welfare checks
    ['custody.book']       = { rank = 'ps' },                                       -- book in, observation level, release (sergeant and above)
    ['evidence.view']      = { rank = 'student' },
    ['calls.attend']       = { rank = 'student' },
    ['incident.join']      = { rank = 'student' },
    ['incident.declare']   = { rank = 'ps' },             -- declare, assign roles, move cordons, stand down
    ['cid.view']           = { rank = 'pc' },
    ['cid.create']         = { rank = 'pc' },
    ['uof.submit']         = { rank = 'student', duty = false },
    ['standards.view']     = { rank = 'insp', duty = false },   -- reviews, complaints, audit log
    ['dogs.handle']        = { rank = 'pc', qualifications = { 'dog_handler' } },
    ['roads.stinger']      = { rank = 'pc', qualifications = { 'stinger' } },
    -- Management (/management): rank limits always apply on top of these
    ['manage.view']        = { rank = 'insp', duty = false },
    ['manage.hire']        = { rank = 'insp', duty = false },
    ['manage.promote']     = { rank = 'ci', duty = false },
    ['manage.discipline']  = { rank = 'insp', duty = false },  -- suspend from duty
    ['manage.fire']        = { rank = 'supt', duty = false },
    ['evidence.manage']    = { rank = 'ps' },                                       -- return to owner, destroy
}
