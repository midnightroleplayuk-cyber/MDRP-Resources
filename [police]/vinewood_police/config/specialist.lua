---------------------------------------------------------------------------
-- Specialist units (phase 5): police dogs and Stinger.
---------------------------------------------------------------------------
Config.Dogs = {
    Command = 'dog',              -- deploy or recall your dog (signed on as Dog section)
    Units = { 'dogs' },
    Model = 'vw_policedog',       -- the Vinewood police dog (stream/policedog/). 'a_c_shepherd' = the game's shepherd
    -- Which texture of each part the dog wears (0 = the first: a, 1 = b...). random = true picks
    -- different head and coat textures each time it's deployed.
    Look = {
        random = false,
        head = 0,                 -- head: a, b or c (0-2)
        uppr = 0,                 -- coat: a, b, c or d (0-3)
        accs = 0,                 -- harness (drawable 0); false = no harness
    },
    SearchRange = 4.0,            -- the dog must be this close to what it searches
    HandlerRange = 30.0,          -- and you this close to the dog
    -- Items a drugs dog indicates on (players' inventories and vehicles)
    DrugItems = { 'weed', 'weed_brick', 'cannabis', 'coke', 'coke_brick', 'cocaine', 'crack', 'meth', 'heroin', 'xtc', 'joint' },
    -- Words in an NPC's finds that a dog indicates on
    DrugWords = { 'cannabis', 'powder', 'wraps', 'drug', 'grinder', 'deal bag' },
    BitePlayers = true,           -- the dog can detain fleeing players (false: NPCs only)
    RedeployAfterInjury = 300,    -- seconds before an injured dog can be deployed again

    -- The lead: a rope from the handler's hand to the dog's collar. On the lead the dog stays at heel and,
    -- when told to bark at someone, holds its ground beside you. Off the lead it goes up to them and barks.
    Lead = {
        Length = 1.8,             -- metres of lead
        Style = 'drawn',          -- 'drawn': a strap drawn between hand and collar every frame (reliable);
                                  -- 'rope': GTA's physics rope (can fail to show on some builds)
        Colour = { 18, 18, 22 },  -- drawn lead colour (black nylon)
        Thickness = 0.018,        -- drawn lead width, metres
        RopeType = 4,             -- GTA rope style, for Style = 'rope' (4 is thin)
        HandBone = 'SKEL_R_Hand',
        CollarBone = 'SKEL_Neck_1',
    },
    Bark = {
        Seconds = 8,              -- how long the dog barks before settling
        HoldDistance = 3.0,       -- off the lead: how close it goes before stopping to bark
        Range = 25.0,             -- how far away the person can be
        IntimidateRange = 10.0,   -- NPC suspects this close may give up...
        SurrenderChance = 60,     -- ...this often (%), if they're running or fighting
        Sound = 'policedogbark.mp3', -- in web/sounds/, heard by everyone nearby; false = the game's own bark
        Volume = 0.8,
        HearRange = 40.0,
    },
}

Config.Stinger = {
    Command = 'stinger',
    Model = 'p_ld_stinger_s',
    Range = 15.0,                 -- how far ahead of you it can be laid
    Lifetime = 180,               -- seconds before it's withdrawn automatically
    MaxPerOfficer = 1,
    IgnoreEmergencyVehicles = true,
}
