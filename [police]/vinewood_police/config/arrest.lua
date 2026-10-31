---------------------------------------------------------------------------
-- Arrest, person search and stop and search.
-- When vinewood-mdt 2.18+ is running, its offences, powers and outcomes are used and every
-- record goes to the MDT. The lists below are only used without it.
---------------------------------------------------------------------------
Config.Arrest = {
    RequireCuffs = true,       -- they must be handcuffed to be arrested
    GroundsMinLength = 20,     -- characters in the grounds for arrest

    -- England and Wales caution (PACE Code C 10.5)
    Caution = 'You do not have to say anything. But it may harm your defence if you do not mention when questioned something which you later rely on in court. Anything you do say may be given in evidence.',

    -- Why the arrest is necessary (PACE Code G 2.9). At least one must be ticked.
    Necessity = {
        'To find out their name or address',
        'To prevent injury to themselves or others',
        'To prevent loss of or damage to property',
        'To prevent an offence against public decency',
        'To prevent an unlawful obstruction of the highway',
        'To protect a child or other vulnerable person',
        'To allow the prompt and effective investigation of the offence',
        'To prevent the prosecution being hindered by their disappearance',
    },

    -- Used only without vinewood-mdt. Same shape as the MDT's Config.Offences.
    -- Offences on the arrest form, grouped by Act. Officers arrest "on suspicion of" these.
    -- Merged with the MDT's own list when vinewood-mdt is running, so anything in either shows.
    -- Sexual offences aren't listed by default (many servers don't allow that roleplay): add them if yours does.
    Offences = {
        { act = 'Theft Act 1968', items = { 's.1 Theft', 's.8 Robbery', 's.8 Assault with intent to rob', 's.9 Burglary', 's.9 Burglary (dwelling)',
            's.9 Burglary (non-dwelling)', 's.10 Aggravated burglary', 's.12 Taking a vehicle without consent', 's.12A Aggravated vehicle taking',
            's.21 Blackmail', 's.22 Handling stolen goods', 's.25 Going equipped for theft' } },
        { act = 'Theft Act 1978', items = { 's.3 Making off without payment' } },
        { act = 'Fraud Act 2006', items = { 's.1 Fraud', 's.6 Possession of articles for use in fraud', 's.7 Making or supplying articles for use in fraud' } },
        { act = 'Misuse of Drugs Act 1971', items = { 's.4 Supply of a controlled drug', 's.4(2) Production of a controlled drug',
            's.4(3) Being concerned in the supply of a controlled drug', 's.5(2) Possession of a controlled drug',
            's.5(3) Possession with intent to supply', 's.6 Cultivation of cannabis', 's.8 Permitting premises to be used for drugs' } },
        { act = 'Psychoactive Substances Act 2016', items = { 's.5 Supplying a psychoactive substance', 's.7 Possession with intent to supply' } },
        { act = 'Proceeds of Crime Act 2002', items = { 's.327 Concealing criminal property (money laundering)',
            's.328 Entering into a money laundering arrangement', 's.329 Acquiring, using or possessing criminal property' } },
        { act = 'Offences Against the Person Act 1861', items = { 's.4 Soliciting murder', 's.16 Threats to kill', 's.18 Wounding with intent',
            's.20 Unlawful wounding', 's.47 Assault occasioning ABH' } },
        { act = 'Common law', items = { 'Murder', 'Attempted murder', 'Manslaughter', 'Kidnapping', 'False imprisonment',
            'Conspiracy', 'Perverting the course of justice', 'Escape from lawful custody', 'Breach of the peace' } },
        { act = 'Criminal Justice Act 1988', items = { 's.39 Common assault', 's.139 Possession of a bladed article', 's.139A Bladed article on school premises' } },
        { act = 'Prevention of Crime Act 1953', items = { 's.1 Possession of an offensive weapon' } },
        { act = 'Firearms Act 1968', items = { 's.1 Possession without certificate', 's.5 Possession of a prohibited weapon',
            's.16 Possession with intent to endanger life', 's.16A Possession with intent to cause fear of violence',
            's.17 Using a firearm to resist arrest', 's.18 Carrying a firearm with criminal intent',
            's.19 Carrying a firearm in a public place', 's.21 Possession by a prohibited person' } },
        { act = 'Public Order Act 1986', items = { 's.1 Riot', 's.2 Violent disorder', 's.3 Affray', 's.4 Fear or provocation of violence',
            's.4A Intentional harassment', 's.5 Harassment, alarm or distress' } },
        { act = 'Crime and Disorder Act 1998', items = { 's.29 Racially or religiously aggravated assault',
            's.30 Racially or religiously aggravated criminal damage', 's.31 Racially or religiously aggravated public order' } },
        { act = 'Criminal Damage Act 1971', items = { 's.1(1) Criminal damage', 's.1(2) Criminal damage endangering life', 's.1(3) Arson',
            's.2 Threats to destroy or damage property', 's.3 Possession with intent to damage' } },
        { act = 'Protection from Harassment Act 1997', items = { 's.2 Harassment', 's.2A Stalking', 's.4 Putting people in fear of violence' } },
        { act = 'Serious Crime Act 2015', items = { 's.76 Controlling or coercive behaviour' } },
        { act = 'Modern Slavery Act 2015', items = { 's.1 Slavery, servitude or forced labour', 's.2 Human trafficking' } },
        { act = 'Criminal Justice and Public Order Act 1994', items = { 's.51 Intimidation of a witness' } },
        { act = 'Police Act 1996', items = { 's.89 Assault on a constable', 's.89(2) Obstructing a constable' } },
        { act = 'Assaults on Emergency Workers (Offences) Act 2018', items = { 's.1 Assault on an emergency worker' } },
        { act = 'Road Traffic Act 1988', items = { 's.1 Causing death by dangerous driving', 's.2 Dangerous driving', 's.3 Careless driving',
            's.3ZB Causing death by driving unlicensed or uninsured', 's.4 Driving while unfit through drink or drugs',
            's.5 Driving with excess alcohol', 's.5A Driving with a specified drug above the limit', 's.7(6) Failing to provide a specimen',
            's.103 Driving while disqualified', 's.143 No insurance', 's.163 Failing to stop for police', 's.170 Failing to stop' } },
        { act = 'Licensing and drunkenness', items = { 's.91 Drunk and disorderly (CJA 1967)', 's.12 Drunk and incapable (Licensing Act 1872)' } },
        { act = 'Bail Act 1976', items = { 's.6 Failing to surrender to bail', 's.7 Breach of bail conditions' } },
        { act = 'Warrants and recall', items = { 'Wanted on warrant', 'Recall to prison (licence revoked)', 'Breach of a court order' } },
        { act = 'Prison Act 1952', items = { 's.40C Conveying prohibited articles into prison' } },
        { act = 'Computer Misuse Act 1990', items = { 's.1 Unauthorised access to computer material' } },
        { act = 'Dangerous Dogs Act 1991', items = { 's.3 Dog dangerously out of control' } },
    },

}

Config.Search = {
    Distance = 2.5,
    -- Searching someone who isn't handcuffed or under arrest asks them first. They can refuse.
    ConsentTimeout = 20,       -- seconds before no answer counts as a refusal
    ConsentLasts = 300,        -- seconds a yes stays valid (re-opening the search doesn't ask again)
    -- Let the officer open the person's inventory to move items (ox_inventory, qb-inventory 2.x).
    AllowOpenInventory = true,
}

-- Used only without vinewood-mdt.
Config.StopSearch = {
    Powers = {
        { id = 'pace1',     label = 's.1 PACE 1984 (stolen or prohibited articles)' },
        { id = 'mda23',     label = 's.23 Misuse of Drugs Act 1971 (controlled drugs)' },
        { id = 'fa47',      label = 's.47 Firearms Act 1968 (firearms)' },
        { id = 'cjpoa60',   label = 's.60 CJPOA 1994 (authorised area, no grounds needed)', authorisation = true },
        { id = 'cjpoa60aa', label = 's.60AA CJPOA 1994 (face coverings)', authorisation = true },
    },
    Objects = { 'Controlled drugs', 'Offensive weapon', 'Bladed article', 'Firearm', 'Stolen property', 'Going equipped', 'Criminal damage articles', 'Other' },
    Outcomes = { 'No further action', 'Arrest', 'Community resolution', 'Penalty notice', 'Cannabis or khat warning', 'Summons / postal requisition', 'Caution' },
}
