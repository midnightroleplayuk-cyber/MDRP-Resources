---------------------------------------------------------------------------
-- Specialist units (phase 5): police dogs and Stinger.
---------------------------------------------------------------------------
Config.Dogs = {
    Command = 'dog',              -- deploy or recall your dog (signed on as Dog section)
    Units = { 'dogs' },
    Model = 'a_c_shepherd',
    SearchRange = 4.0,            -- the dog must be this close to what it searches
    HandlerRange = 30.0,          -- and you this close to the dog
    -- Items a drugs dog indicates on (players' inventories and vehicles)
    DrugItems = { 'weed', 'weed_brick', 'cannabis', 'coke', 'coke_brick', 'cocaine', 'crack', 'meth', 'heroin', 'xtc', 'joint' },
    -- Words in an NPC's finds that a dog indicates on
    DrugWords = { 'cannabis', 'powder', 'wraps', 'drug', 'grinder', 'deal bag' },
    BitePlayers = true,           -- the dog can detain fleeing players (false: NPCs only)
    RedeployAfterInjury = 300,    -- seconds before an injured dog can be deployed again
}

Config.Stinger = {
    Command = 'stinger',
    Model = 'p_ld_stinger_s',
    Range = 15.0,                 -- how far ahead of you it can be laid
    Lifetime = 180,               -- seconds before it's withdrawn automatically
    MaxPerOfficer = 1,
    IgnoreEmergencyVehicles = true,
}
