-- Sentencing ranges used by judges (as guidance) and by the auto court (to decide).
-- Same offence names as vinewood-mdt, so charges authorised by the CPS match up.
-- Loosely based on the Sentencing Council approach: offence range, aggravating and
-- mitigating factors, then a reduction for a guilty plea. Squashed down for roleplay.
--
-- court: 'summary' (magistrates only), 'either' (either way), 'indictable' (Crown Court only)
-- fine:  { min, max } in Config.Fines.Currency, or nil if a fine is unusual
-- jail:  { min, max } in months, or nil if the offence isn't imprisonable
-- community: a community order is available
-- auto:  what the auto court adds for driving offences. points, banMonths, code (DVLA endorsement code)
Config.Sentencing = {
    MagistratesMaxMonths = 12,    -- custody above this (all offences together) has to go to the Crown Court
    SuspendUpTo = 24,             -- custody of this many months or less can be suspended
    SuspendOperationalDays = 14,  -- real days a suspended sentence hangs over someone
    Totality = 0.25,              -- each extra offence adds this share of its own sentence on top of the most serious
    CommunityHoursPerMonth = 10,  -- auto court: months on the guide become unpaid work hours
    CommunityHours = { 40, 300 },
    DischargeDays = 7,            -- conditional discharge period (real days)
    BanRealDaysPerYear = 7,       -- a 12 month driving ban = 7 real days on the licence system
    -- Auto court: immediate custody if the result is at least this many months and either it's
    -- over SuspendUpTo or they have this many previous convictions.
    AutoCustodyFrom = 6,
    AutoSuspendMaxPrevious = 1,

    Offences = {
        -- Theft Act 1968
        ['s.1 Theft'] = { court = 'either', max = '7 years', ooc = { cr = true, caution = true, pnd = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 24 },
            notes = 'Value taken and harm to the victim set the range. Retail theft under £100 can get a penalty notice.' },
        ['s.8 Robbery'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 12, 96 }, notes = 'Weapon produced or used, or serious injury: top of the range. Never an out-of-court disposal.' },
        ['s.9 Burglary'] = { court = 'either', max = '14 years (dwelling), 10 years (other)', ooc = { caution = true },
            fine = { 250, 2500 }, community = true, jail = { 6, 72 },
            notes = 'Dwelling burglary is far more serious than a shed or shop. Third domestic burglary: minimum 3 years. Caution only for low-level non-dwelling.' },
        ['s.12 Taking a vehicle without consent'] = { court = 'summary', max = '6 months', ooc = { cr = true, caution = true },
            fine = { 100, 1000 }, community = true, jail = { 0, 6 }, driving = 'Discretionary disqualification',
            notes = 'Aggravated (s.12A: damage, injury or dangerous driving) is far more serious.' },
        ['s.22 Handling stolen goods'] = { court = 'either', max = '14 years', ooc = { caution = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 48 },
            notes = 'Higher where the handler is a professional receiver or the goods came from a burglary or robbery.' },

        -- Offences Against the Person Act 1861
        ['s.18 Wounding with intent'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 36, 144 }, notes = 'Intent to cause really serious harm. Weapon use and premeditation push it higher.' },
        ['s.20 Unlawful wounding'] = { court = 'either', max = '5 years', ooc = {},
            community = true, jail = { 6, 48 }, notes = 'Wound or grievous harm without intent. Charge, not an out-of-court disposal.' },
        ['s.47 Assault occasioning ABH'] = { court = 'either', max = '5 years', ooc = { caution = true },
            fine = { 250, 2500 }, community = true, jail = { 0, 36 },
            notes = 'Caution only for a first, minor, admitted offence where the victim agrees. 10 years if racially or religiously aggravated.' },

        -- Criminal Justice Act 1988
        ['s.39 Common assault'] = { court = 'summary', max = '6 months (2 years on an emergency worker)', ooc = { cr = true, caution = true },
            fine = { 100, 1500 }, community = true, jail = { 0, 6 },
            notes = 'On an emergency worker it is an either-way offence with a 2 year maximum: use the higher end.' },
        ['s.139 Possession of a bladed article'] = { court = 'either', max = '4 years', ooc = {},
            community = true, jail = { 3, 24 },
            notes = 'Second offence: minimum 6 months unless unjust. Threatening with it (s.139AA) is more serious.' },

        -- Misuse of Drugs Act 1971
        ['s.4 Supply of a controlled drug'] = { court = 'either', max = 'Life (Class A), 14 years (B and C)', ooc = {},
            jail = { 12, 96 }, notes = 'Role (leading, significant, lesser) and quantity set the range. Third Class A trafficking: minimum 7 years.' },
        ['s.5(2) Possession of a controlled drug'] = { court = 'either', max = '7 years (A), 5 years (B), 2 years (C)', ooc = { cr = true, caution = true, pnd = true },
            fine = { 100, 1000 }, community = true, jail = { 0, 12 },
            notes = 'Small amount of cannabis for personal use: cannabis warning or penalty notice first. Class A: usually charge.' },
        ['s.5(3) Possession with intent to supply'] = { court = 'either', max = 'Life (Class A), 14 years (B and C)', ooc = {},
            jail = { 12, 72 }, notes = 'Treated like supply. Cash, scales, deal bags and phone evidence show intent.' },

        -- Firearms Act 1968
        ['s.1 Possession without certificate'] = { court = 'either', max = '5 years', ooc = {},
            community = true, jail = { 6, 48 }, notes = 'Higher if loaded, with ammunition, or carried in public.' },
        ['s.5 Possession of a prohibited weapon'] = { court = 'indictable', max = '10 years', ooc = {},
            jail = { 60, 120 }, notes = 'Minimum 5 years unless exceptional circumstances.' },
        ['s.16 Possession with intent to endanger life'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 72, 180 }, notes = 'Among the most serious firearms offences.' },

        -- Road Traffic Act 1988
        ['s.1 Causing death by dangerous driving'] = { auto = { banMonths = 60, code = 'DD80' }, court = 'indictable', max = 'Life', ooc = {},
            jail = { 24, 180 }, driving = 'Obligatory disqualification (minimum 5 years) and extended retest',
            notes = 'Racing, drink or drugs, or a prolonged course of bad driving: top of the range.' },
        ['s.2 Dangerous driving'] = { auto = { banMonths = 12, code = 'DD40' }, court = 'either', max = '2 years', ooc = {},
            fine = { 500, 2500 }, community = true, jail = { 0, 24 }, driving = 'Obligatory disqualification (minimum 1 year) and extended retest' },
        ['s.3 Careless driving'] = { auto = { points = 6, code = 'CD10' }, court = 'summary', max = 'Unlimited fine', ooc = {},
            fine = { 100, 2500 }, driving = '3 to 9 points or disqualification',
            notes = 'Not imprisonable. Lower-level cases can get a fixed penalty (3 points).' },
        ['s.5 Driving with excess alcohol'] = { auto = { banMonths = 12, code = 'DR10' }, court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 },
            driving = 'Obligatory disqualification: 12 months (3 years if a second offence within 10 years)' },
        ['s.103 Driving while disqualified'] = { auto = { points = 6, banMonths = 6, code = 'BA10' }, court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 }, driving = '6 points or further disqualification' },
        ['s.143 No insurance'] = { auto = { points = 6, code = 'IN10' }, court = 'summary', max = 'Unlimited fine', ooc = {},
            fine = { 300, 1000 }, driving = '6 to 8 points or disqualification',
            notes = 'Not imprisonable. Fixed penalty £300 and 6 points. Vehicle can be seized (s.165).' },
        ['s.170 Failing to stop'] = { auto = { points = 6, code = 'AC10' }, court = 'summary', max = '12 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 12 }, driving = '5 to 10 points or disqualification' },

        -- Public Order Act 1986
        ['s.4 Fear or provocation of violence'] = { court = 'summary', max = '6 months (2 years if aggravated)', ooc = { cr = true, caution = true },
            fine = { 100, 1500 }, community = true, jail = { 0, 6 } },
        ['s.4A Intentional harassment'] = { court = 'summary', max = '6 months (2 years if aggravated)', ooc = { caution = true },
            fine = { 100, 1500 }, community = true, jail = { 0, 6 } },
        ['s.5 Harassment, alarm or distress'] = { court = 'summary', max = 'Fine (level 3)', ooc = { cr = true, caution = true, pnd = true },
            fine = { 50, 500 }, notes = 'Not imprisonable. Penalty notice is the usual route.' },

        -- Criminal Damage Act 1971
        ['s.1(1) Criminal damage'] = { court = 'either', max = '10 years (3 months if under £5,000)', ooc = { cr = true, caution = true, pnd = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 18 },
            notes = 'Value of damage decides where it is tried. Under £300: penalty notice possible. Compensation is usually ordered.' },
        ['s.1(3) Arson'] = { court = 'either', max = 'Life', ooc = {},
            community = true, jail = { 6, 96 }, notes = 'Higher if life was endangered (s.1(2)).' },

        -- Bail Act 1976
        ['s.6 Failing to surrender to bail'] = { court = 'summary', max = '3 months (12 months at Crown Court)', ooc = {},
            fine = { 100, 1000 }, community = true, jail = { 0, 3 }, notes = 'Usually dealt with alongside the original offence.' },

        -- Police Act 1996
        ['s.89 Assault on a constable'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 },
            notes = 'Often charged as assault on an emergency worker (2 years). Not suitable for a caution.' },
        ['s.89(2) Obstructing a constable'] = { court = 'summary', max = '1 month', ooc = { cr = true, caution = true },
            fine = { 50, 1000 }, jail = { 0, 1 } },
    },

    -- Factors. weight = how much each moves the sentence (0.2 = 20%). auto = filled in from the record.
    Aggravating = {
        { id = 'previous', label = 'Previous convictions', weight = 0.1, perConviction = true, cap = 0.5, auto = true },
        { id = 'onbail', label = 'Committed while on bail', weight = 0.2, auto = true },
        { id = 'weapon', label = 'Weapon used or produced', weight = 0.25 },
        { id = 'emergency', label = 'Victim was an emergency worker', weight = 0.25 },
        { id = 'vulnerable', label = 'Vulnerable victim', weight = 0.2 },
        { id = 'hostility', label = 'Hate or hostility aggravated', weight = 0.25 },
        { id = 'planning', label = 'Planning or organised', weight = 0.15 },
        { id = 'group', label = 'Part of a group', weight = 0.1 },
        { id = 'influence', label = 'Under the influence of drink or drugs', weight = 0.1 },
    },
    Mitigating = {
        { id = 'nopcs', label = 'No previous convictions', weight = 0.1, auto = true },
        { id = 'remorse', label = 'Genuine remorse', weight = 0.1 },
        { id = 'minor', label = 'Minor or lesser role', weight = 0.15 },
        { id = 'mental', label = 'Mental health or learning disability', weight = 0.15 },
        { id = 'maturity', label = 'Age or lack of maturity', weight = 0.1 },
        { id = 'provoked', label = 'Provocation or excessive self-defence', weight = 0.1 },
    },
    -- Reduction for a guilty plea, as the Sentencing Council sets it.
    Pleas = {
        { id = 'first', label = 'Guilty at the first opportunity', reduction = 1 / 3 },
        { id = 'later', label = 'Guilty later, before trial', reduction = 1 / 4 },
        { id = 'trial', label = 'Guilty on the day of trial', reduction = 1 / 10 },
        { id = 'notguilty', label = 'Not guilty plea / convicted after trial', reduction = 0 },
    },
}
