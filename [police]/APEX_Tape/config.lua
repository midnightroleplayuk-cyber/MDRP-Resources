-- APEX Tape 2.0 | Buyer settings
-- Edit this file, then restart APEX_Tape. Omitted settings use shared/defaults.lua.
-- Keep one entry per group. Merge guide examples into Settings below.
UserConfig={Version=2,Settings={
    Locale='en', -- en / fr / de
    PerformanceProfile='balanced', -- low / balanced / high / custom

    -- Public works immediately. Choose 'ace' to require UseAce, or use
    -- Framework='qb'/'esx', Mode='jobs_or_staff' and your actual job names.
    Permissions={
        Framework='standalone',Mode='jobs',
        Jobs={police=0,ambulance=0,fire=0},
        RequireOnDuty=true,StaffBypass=true,
        UseAce='apex.policetape',StaffAce='apex.policetape.admin',
    },

    -- Optional ox_target. Commands work without it.
    -- Removal is restricted to the tape owner/admin.
    Target={Enabled=true,System='ox',RemovePolicy='owner'},

    -- Register these items in your inventory before enabling it.
    Inventory={
        Enabled=true,System='ox', -- ox / qb / esx / custom
        TapeItem='police_tape',ConsumeOnPlace=true,RefundOnRemove=true,
        CutItem='scissors',ConsumeCutItem=false,
        RepairItem='police_tape',ConsumeRepairItem=true,
    },
    BlockAiTraffic=true,
    Editor={Enabled=true,Mode='auto'},
    CustomText={Enabled=true,StaffOnly=false},

    -- Optional examples: remove -- to enable; keep keys unique.
    -- LifetimeMinutes=120, -- automatically remove after two hours
    -- Commands={ptape='tape',changetape='tapedesign'}, -- no slashes
    -- TapeStyles={vip={enabled=false}}, -- hide a design
}}
