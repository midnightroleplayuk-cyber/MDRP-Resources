---------------------------------------------------------------------------
-- Major incidents and CID case files (phase 4, drop 3)
---------------------------------------------------------------------------
Config.Incidents = {
    Command = 'incident',
    Types = { 'Crime scene', 'Major incident', 'Firearms incident', 'Serious collision', 'Missing person search', 'Public order', 'Sudden death' },
    Roles = { 'Bronze commander', 'Silver commander', 'Scene guard', 'Cordon officer', 'Scene log keeper', 'CSI', 'Search lead', 'Family liaison' },
    -- Silver commander needs this rank or above
    SilverRank = 'insp',
    DefaultInner = 25,    -- metres
    DefaultOuter = 80,
    MaxRadius = 400,
    MaxActive = 4,        -- incidents running at once
    -- Anyone who isn't on the incident's list going inside the inner cordon is logged and the scene is told
    WatchInnerCordon = true,
}

Config.CID = {
    Command = 'cases',
    Statuses = { 'Open', 'Under investigation', 'Suspect identified', 'Awaiting forensics', 'Charged', 'Filed: no further action', 'Closed' },
    Types = { 'Theft', 'Burglary', 'Robbery', 'Armed robbery', 'Assault', 'Drugs', 'Weapons', 'Criminal damage', 'Vehicle crime', 'Fraud',
        'Missing person', 'Sudden death', 'Public order', 'Other' },
    PersonRoles = { 'Suspect', 'Victim', 'Witness', 'Person of interest' },
    -- Who can edit a case besides its officer in case (OIC): this rank and above, or anyone signed on as one of these units
    ManageRank = 'ps',
    ManageUnits = { 'cid' },
}
