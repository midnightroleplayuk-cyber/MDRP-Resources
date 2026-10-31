---------------------------------------------------------------------------
-- Qualifications are held separately from rank.
--   validDays     0 = never expires
--   grantRank     lowest rank that can sign it off
--   requires      qualifications the officer must already hold
--   granterNeeds  the signing officer must hold this one themselves
---------------------------------------------------------------------------
Config.Qualifications = {
    { id = 'basic_driver',        label = 'Basic driver',                validDays = 0,   grantRank = 'ps' },
    { id = 'response_driver',     label = 'Response driver',             validDays = 0,   grantRank = 'ps',   requires = { 'basic_driver' } },
    { id = 'advanced_driver',     label = 'Advanced driver (TPAC)',      validDays = 0,   grantRank = 'insp', requires = { 'response_driver' } },
    { id = 'taser',               label = 'Taser (CED)',                 validDays = 365, grantRank = 'ps' },
    { id = 'firearms',            label = 'Authorised firearms officer', validDays = 365, grantRank = 'insp' },
    { id = 'dog_handler',         label = 'Dog handler',                 validDays = 0,   grantRank = 'insp' },
    { id = 'public_order',        label = 'Public order (Level 2)',      validDays = 365, grantRank = 'ps' },
    { id = 'custody',             label = 'Custody trained',             validDays = 0,   grantRank = 'insp' },
    { id = 'tutor',               label = 'Tutor constable',             validDays = 0,   grantRank = 'ps' },
    { id = 'stinger',             label = 'Stinger (tactical pursuit)',  validDays = 365, grantRank = 'ps' },
    { id = 'independent_patrol',  label = 'Independent patrol',          validDays = 0,   grantRank = 'ps',   granterNeeds = 'tutor' },
}

-- Real seconds in one qualification "day". 86400 = real time.
-- Lower it to run expiry on roleplay time (3600 makes a 365-day qualification last about 15 real days).
Config.QualificationDayLength = 86400
