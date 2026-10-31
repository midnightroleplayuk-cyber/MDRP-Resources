-- Sentencing guidance shown to officers, the CPS and solicitors.
-- Loosely based on the Sentencing Council approach (offence range, then aggravating and
-- mitigating factors, then a reduction for a guilty plea), squashed down for roleplay.
-- The statutory maximum shown is the real-life one; the "jail" ranges are for your server.
--
-- court: 'summary' (magistrates only), 'either' (either way), 'indictable' (Crown Court only)
-- ooc:   out-of-court options that can be suitable: cr = community resolution,
--        caution = simple caution, pnd = penalty notice
-- fine:  { min, max } in Config.Fines.Currency, or nil if a fine is unusual
-- jail:  { min, max } in Config.Sentencing.JailUnit, or nil if the offence isn't imprisonable
-- driving: points or ban that comes with it
Config.Sentencing = {
    enabled = true,
    JailUnit = 'months',          -- shown as "months"; set MinutesPerUnit to match your prison script
    MinutesPerUnit = 1,           -- 1 month in the guide = 1 minute in prison
    Notice = 'Guidance only. The court decides the sentence.',

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
        ['s.1 Causing death by dangerous driving'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 24, 180 }, driving = 'Obligatory disqualification (minimum 5 years) and extended retest',
            notes = 'Racing, drink or drugs, or a prolonged course of bad driving: top of the range.' },
        ['s.2 Dangerous driving'] = { court = 'either', max = '2 years', ooc = {},
            fine = { 500, 2500 }, community = true, jail = { 0, 24 }, driving = 'Obligatory disqualification (minimum 1 year) and extended retest' },
        ['s.3 Careless driving'] = { court = 'summary', max = 'Unlimited fine', ooc = {},
            fine = { 100, 2500 }, driving = '3 to 9 points or disqualification',
            notes = 'Not imprisonable. Lower-level cases can get a fixed penalty (3 points).' },
        ['s.5 Driving with excess alcohol'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 },
            driving = 'Obligatory disqualification: 12 months (3 years if a second offence within 10 years)' },
        ['s.103 Driving while disqualified'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 }, driving = '6 points or further disqualification' },
        ['s.143 No insurance'] = { court = 'summary', max = 'Unlimited fine', ooc = {},
            fine = { 300, 1000 }, driving = '6 to 8 points or disqualification',
            notes = 'Not imprisonable. Fixed penalty £300 and 6 points. Vehicle can be seized (s.165).' },
        ['s.170 Failing to stop'] = { court = 'summary', max = '12 months', ooc = {},
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

        ---------------------------------------------------------------------------
        -- Added in 2.19.1 (the full offence list shared with vinewood_police)
        ---------------------------------------------------------------------------
        -- Common law
        ['Murder'] = { court = 'indictable', max = 'Life (mandatory)', ooc = {},
            jail = { 180, 360 }, notes = 'Life sentence with a minimum term. A weapon taken to the scene, or a firearm, raises the starting point sharply.' },
        ['Attempted murder'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 120, 360 }, notes = 'Needs an intent to kill, not just to cause serious harm.' },
        ['Manslaughter'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 24, 240 }, notes = 'Unlawful act or gross negligence. Culpability sets the range.' },
        ['Kidnapping'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 24, 144 }, notes = 'Taking or carrying away by force or fraud. Ransom, violence or length of time push it higher.' },
        ['False imprisonment'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 6, 96 }, notes = 'Holding someone against their will. Often charged with the offence it was for.' },
        ['Conspiracy'] = { court = 'indictable', max = 'As the offence agreed', ooc = {},
            jail = { 0, 120 }, notes = 'Sentenced by reference to the offence the conspirators agreed to commit.' },
        ['Perverting the course of justice'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 4, 48 }, notes = 'False alibis, destroying evidence, giving someone else\'s details. Almost always custody.' },
        ['Escape from lawful custody'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 3, 24 }, notes = 'Added to the sentence already being served or awaited.' },
        ['Breach of the peace'] = { court = 'summary', max = 'Bind over (not a criminal offence)', ooc = {},
            notes = 'A power of arrest, not a crime. Release once the danger has passed, or put before the court to be bound over.' },
        ['Wanted on warrant'] = { court = 'summary', max = 'As the original matter', ooc = {},
            notes = 'Arrested to go before the court that issued the warrant. No new charge.' },
        ['Recall to prison (licence revoked)'] = { court = 'summary', max = 'Rest of the sentence', ooc = {},
            notes = 'Returned to prison to serve the rest of their sentence. No court hearing needed.' },
        ['Breach of a court order'] = { court = 'either', max = '5 years', ooc = {},
            community = true, jail = { 0, 24 }, notes = 'Restraining, non-molestation and criminal behaviour orders. Breach is an offence in its own right.' },

        -- Drugs
        ['s.4(2) Production of a controlled drug'] = { court = 'either', max = 'Life (Class A), 14 years (B and C)', ooc = {},
            jail = { 12, 120 }, notes = 'Scale of the operation and the defendant\'s role set the range.' },
        ['s.4(3) Being concerned in the supply of a controlled drug'] = { court = 'either', max = 'Life (Class A), 14 years (B and C)', ooc = {},
            jail = { 12, 144 }, notes = 'Leading, significant or lesser role. Dealing lines, couriers and stash holders are all "concerned in supply".' },
        ['s.6 Cultivation of cannabis'] = { court = 'either', max = '14 years', ooc = { caution = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 48 }, notes = 'A few plants for personal use is at the bottom; a commercial grow is supply-level.' },
        ['s.8 Permitting premises to be used for drugs'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 0, 48 }, notes = 'Occupier or manager knowingly allowing supply or production at the premises.' },
        ['s.5 Supplying a psychoactive substance'] = { court = 'either', max = '7 years', ooc = {},
            community = true, jail = { 0, 48 } },
        ['s.7 Possession with intent to supply'] = { court = 'either', max = '7 years', ooc = {},
            community = true, jail = { 0, 36 }, notes = 'Psychoactive Substances Act. Controlled drugs are s.5(3) Misuse of Drugs Act.' },

        -- Proceeds of Crime Act 2002
        ['s.327 Concealing criminal property (money laundering)'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 6, 120 }, notes = 'Amount laundered and how sophisticated it was set the range.' },
        ['s.328 Entering into a money laundering arrangement'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 6, 120 } },
        ['s.329 Acquiring, using or possessing criminal property'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 0, 96 }, notes = 'Cash found with no explanation is the usual case.' },

        -- Fraud Act 2006
        ['s.1 Fraud'] = { court = 'either', max = '10 years', ooc = { caution = true },
            fine = { 100, 5000 }, community = true, jail = { 0, 96 } },
        ['s.6 Possession of articles for use in fraud'] = { court = 'either', max = '5 years', ooc = {},
            community = true, jail = { 0, 36 } },
        ['s.7 Making or supplying articles for use in fraud'] = { court = 'either', max = '10 years', ooc = {},
            community = true, jail = { 0, 72 } },

        -- Theft
        ['s.8 Assault with intent to rob'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 12, 96 }, notes = 'As robbery, where nothing was taken.' },
        ['s.9 Burglary (dwelling)'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 6, 72 }, notes = 'Someone home at the time is a serious aggravating factor. Third domestic burglary: minimum 3 years.' },
        ['s.9 Burglary (non-dwelling)'] = { court = 'either', max = '10 years', ooc = { caution = true },
            fine = { 250, 2500 }, community = true, jail = { 0, 48 } },
        ['s.10 Aggravated burglary'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 24, 156 }, notes = 'Burglary while carrying a weapon or firearm.' },
        ['s.12A Aggravated vehicle taking'] = { court = 'either', max = '2 years (14 years if a death is caused)', ooc = {},
            community = true, jail = { 0, 24 }, driving = 'Minimum 1 year disqualification' },
        ['s.21 Blackmail'] = { court = 'indictable', max = '14 years', ooc = {},
            jail = { 12, 96 } },
        ['s.25 Going equipped for theft'] = { court = 'either', max = '3 years', ooc = { caution = true },
            fine = { 100, 1000 }, community = true, jail = { 0, 24 } },
        ['s.3 Making off without payment'] = { court = 'either', max = '2 years', ooc = { cr = true, caution = true },
            fine = { 50, 1000 }, jail = { 0, 6 }, notes = 'Fuel drive-offs and unpaid taxi fares. Theft Act 1978.' },

        -- Violence and weapons
        ['s.4 Soliciting murder'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 60, 240 } },
        ['s.16 Threats to kill'] = { court = 'either', max = '10 years', ooc = {},
            community = true, jail = { 6, 84 }, notes = 'The victim must have been meant to fear the threat would be carried out.' },
        ['s.1 Possession of an offensive weapon'] = { court = 'either', max = '4 years', ooc = {},
            community = true, jail = { 0, 36 }, notes = 'Second weapon offence: minimum 6 months unless unjust.' },
        ['s.139A Bladed article on school premises'] = { court = 'either', max = '4 years', ooc = {},
            community = true, jail = { 0, 36 } },
        ['s.1 Assault on an emergency worker'] = { court = 'either', max = '2 years', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 24 }, notes = 'Police, paramedics, fire and prison officers. Not suitable for a caution.' },
        ['s.29 Racially or religiously aggravated assault'] = { court = 'either', max = '7 years', ooc = {},
            community = true, jail = { 0, 60 } },
        ['s.76 Controlling or coercive behaviour'] = { court = 'either', max = '5 years', ooc = {},
            community = true, jail = { 0, 48 } },
        ['s.51 Intimidation of a witness'] = { court = 'either', max = '5 years', ooc = {},
            jail = { 6, 48 }, notes = 'Strikes at the justice system: custody is the norm.' },

        -- Firearms Act 1968
        ['s.16A Possession with intent to cause fear of violence'] = { court = 'indictable', max = '10 years', ooc = {},
            jail = { 24, 96 } },
        ['s.17 Using a firearm to resist arrest'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 60, 240 } },
        ['s.18 Carrying a firearm with criminal intent'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 36, 180 } },
        ['s.19 Carrying a firearm in a public place'] = { court = 'either', max = '7 years', ooc = {},
            jail = { 12, 60 }, notes = 'Minimum 5 years where the weapon is prohibited.' },
        ['s.21 Possession by a prohibited person'] = { court = 'either', max = '5 years', ooc = {},
            jail = { 6, 48 }, notes = 'People released from a sentence of 3 years or more are banned for life.' },

        -- Public order
        ['s.1 Riot'] = { court = 'indictable', max = '10 years', ooc = {},
            jail = { 24, 120 } },
        ['s.2 Violent disorder'] = { court = 'either', max = '5 years', ooc = {},
            jail = { 6, 60 } },
        ['s.3 Affray'] = { court = 'either', max = '3 years', ooc = {},
            community = true, jail = { 0, 36 } },
        ['s.31 Racially or religiously aggravated public order'] = { court = 'either', max = '2 years', ooc = { caution = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 24 } },
        ['s.91 Drunk and disorderly (CJA 1967)'] = { court = 'summary', max = 'Fine (level 3)', ooc = { cr = true, caution = true, pnd = true },
            fine = { 50, 500 } },
        ['s.12 Drunk and incapable (Licensing Act 1872)'] = { court = 'summary', max = 'Fine (level 1)', ooc = { cr = true, caution = true },
            fine = { 25, 200 } },

        -- Damage
        ['s.1(2) Criminal damage endangering life'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 12, 120 } },
        ['s.2 Threats to destroy or damage property'] = { court = 'either', max = '10 years', ooc = { caution = true },
            community = true, jail = { 0, 36 } },
        ['s.3 Possession with intent to damage'] = { court = 'either', max = '10 years', ooc = { caution = true },
            community = true, jail = { 0, 24 } },
        ['s.30 Racially or religiously aggravated criminal damage'] = { court = 'either', max = '14 years', ooc = {},
            community = true, jail = { 0, 36 } },

        -- Harassment
        ['s.2 Harassment'] = { court = 'summary', max = '6 months', ooc = { cr = true, caution = true },
            fine = { 100, 1000 }, community = true, jail = { 0, 6 }, notes = 'A restraining order is usually made too.' },
        ['s.2A Stalking'] = { court = 'summary', max = '6 months', ooc = { caution = true },
            fine = { 100, 1000 }, community = true, jail = { 0, 6 } },
        ['s.4 Putting people in fear of violence'] = { court = 'either', max = '10 years', ooc = {},
            community = true, jail = { 0, 60 } },

        -- Modern Slavery Act 2015
        ['s.1 Slavery, servitude or forced labour'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 48, 180 } },
        ['s.2 Human trafficking'] = { court = 'indictable', max = 'Life', ooc = {},
            jail = { 48, 180 } },

        -- Roads
        ['s.3ZB Causing death by driving unlicensed or uninsured'] = { court = 'either', max = '2 years', ooc = {},
            jail = { 0, 24 }, driving = 'Minimum 1 year disqualification' },
        ['s.4 Driving while unfit through drink or drugs'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 }, driving = 'Minimum 12 months disqualification' },
        ['s.5A Driving with a specified drug above the limit'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 }, driving = 'Minimum 12 months disqualification' },
        ['s.7(6) Failing to provide a specimen'] = { court = 'summary', max = '6 months', ooc = {},
            fine = { 250, 2500 }, community = true, jail = { 0, 6 }, driving = 'Minimum 12 months disqualification when driving' },
        ['s.163 Failing to stop for police'] = { court = 'summary', max = 'Fine (level 5)', ooc = {},
            fine = { 100, 1000 }, notes = 'Usually charged alongside the driving it was for.' },

        -- Other
        ['s.7 Breach of bail conditions'] = { court = 'summary', max = 'Not an offence: bail is reviewed', ooc = {},
            notes = 'A power of arrest only. The court decides whether to remand in custody.' },
        ['s.40C Conveying prohibited articles into prison'] = { court = 'either', max = '10 years', ooc = {},
            jail = { 6, 72 }, notes = 'Phones and drugs into prison. Custody is the norm.' },
        ['s.1 Unauthorised access to computer material'] = { court = 'either', max = '2 years', ooc = { caution = true },
            fine = { 100, 2500 }, community = true, jail = { 0, 24 } },
        ['s.3 Dog dangerously out of control'] = { court = 'either', max = '6 months (14 years if a death is caused)', ooc = { caution = true },
            fine = { 100, 2500 }, jail = { 0, 24 }, notes = 'The court can order the dog destroyed or ban the owner from keeping dogs.' },
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
