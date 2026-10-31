---------------------------------------------------------------------------
-- Management (boss menu): /management for senior officers.
-- Nobody can act on someone of their own rank or above, or promote anyone to their own rank or above.
---------------------------------------------------------------------------
Config.Management = {
    Command = 'management',
    HireDistance = 5.0,           -- the person being hired must be standing this close
    HireRank = 'student',         -- new recruits start at this rank
    UnemployedJob = 'unemployed', -- job given on dismissal
}
