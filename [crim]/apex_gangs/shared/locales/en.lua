Locales = Locales or {}

-- English is the master / fallback. Keep keys in sync across all langs.
Locales['en'] = {
    -- ── Brand ──
    brand_name        = 'APEX',
    brand_accent      = 'GANGS',
    brand_sub         = 'Gang Command',

    -- ── Generic ──
    ui_open           = 'Open',
    ui_close          = 'Close',
    ui_save           = 'Save',
    ui_cancel         = 'Cancel',
    ui_confirm        = 'Confirm',
    ui_delete         = 'Delete',
    ui_edit           = 'Edit',
    ui_create         = 'Create',
    ui_refresh        = 'Refresh',
    ui_search         = 'Search…',
    ui_none           = 'None',
    ui_loading        = 'Loading…',

    -- ── Tabs ──
    tab_overview      = 'Overview',
    tab_members       = 'Members',
    tab_ranks         = 'Ranks',
    tab_turf          = 'Territory',
    tab_graffiti      = 'Graffiti',
    tab_vault         = 'Safe',
    tab_garage        = 'Garage',
    tab_operations    = 'Operations',
    tab_tasks         = 'Tasks',
    tab_upgrades      = 'Upgrades',
    tab_medic         = 'Medic',
    tab_logs          = 'Logs',
    tab_settings      = 'Settings',
    tab_admin         = 'Admin',

    -- ── Notifications ──
    notify_no_gang        = 'You are not in a gang.',
    notify_not_authorized = 'You are not authorised.',
    notify_menu_failed    = 'Could not open the menu (%s) — this is not a permission problem. Check the server console.',
    notify_perm_report    = 'Permission report printed to your F8 console.',
    notify_perm_report_offline = 'No player online with that server id.',
    notify_no_permission  = 'You lack permission for that.',
    notify_not_leader     = 'Only gang leaders can do that.',
    notify_gang_created   = 'Gang "%s" created.',
    notify_gang_deleted   = 'Gang deleted.',
    notify_gang_full      = 'The gang is full.',
    notify_member_joined  = 'You joined %s.',
    notify_member_kicked  = 'You were removed from %s.',
    notify_member_invited = 'Invited %s.',
    notify_promoted       = 'Promoted %s.',
    notify_demoted        = 'Demoted %s.',
    notify_lead_transfer  = 'Leadership transferred to %s.',
    notify_cooldown       = 'On cooldown — try again later.',
    notify_saved          = 'Saved.',
    notify_deleted        = 'Deleted.',

    -- ── Turf ──
    turf_entering         = 'Entering %s territory',
    turf_leaving          = 'Leaving %s territory',
    turf_neutral          = 'Neutral territory',
    turf_capturing        = 'Capturing… %d%%',
    turf_contested        = 'Territory contested!',
    turf_captured         = '%s captured %s',
    turf_lost             = 'Your gang lost %s',
    turf_tagging          = 'Tagging this turf… %d/%d tags',

    -- ── Graffiti ──
    graffiti_placed       = 'Tag placed.',
    graffiti_removed      = 'Tag removed.',
    graffiti_limit        = 'Graffiti limit reached.',
    graffiti_no_wall      = 'Aim at a flat wall.',
    graffiti_aim          = 'Aim where to spray · [E] confirm · [Esc] cancel',
    graffiti_rotate       = 'Rotate',
    graffiti_resize       = 'Resize',
    graffiti_place        = 'Place',
    graffiti_cancel       = 'Cancel',
    graffiti_spraying     = 'Spraying graffiti…',
    graffiti_spraying_sub = 'Hold still while you tag the wall',
    graffiti_shaking      = 'Shaking the can…',
    graffiti_shaking_sub  = 'Mixing the paint',
    graffiti_size         = 'Size',
    graffiti_rotation     = 'Rotation',
    graffiti_draw         = 'Draw',

    -- ── Vault / safe ──
    vault_deposited       = 'Deposited %s.',
    vault_withdrawn       = 'Withdrew %s.',
    vault_insufficient    = 'Not enough funds.',

    -- ── Garage ──
    garage_stored         = 'Vehicle stored.',
    garage_out            = 'Vehicle taken out.',
    garage_limit          = 'Garage is full.',
    garage_not_here       = 'No garage point nearby.',
    garage_not_yours      = "That's not your vehicle — only your own cars can go into the gang garage.",
    garage_not_gang       = 'That vehicle belongs to another gang.',

    -- ── Operations ──
    scout_started         = 'Scout in progress…',
    scout_done            = 'Scout complete — intel gathered.',
    scout_failed          = 'Scout failed.',
    scout_alerted         = 'A rival is scouting you!',
    scout_left_zone       = 'Scout cancelled — you left the territory.',
    scout_cancelled       = 'Scout cancelled.',
    scout_busy            = 'A scout is already in progress.',
    scout_prompt          = 'Scout %s',
    raid_started          = 'Raid started!',
    raid_incoming         = 'Your gang is being raided!',
    raid_success          = 'Raid successful.',
    raid_failed           = 'Raid failed.',
    raid_need_scout       = 'Scout the target first.',
    raid_need_attackers   = 'Not enough attackers.',

    -- ── Tasks ──
    task_complete         = 'Task complete: %s',
    task_progress         = '%s · %d/%d',
    hq_nothing            = 'Nothing to explore here right now — grab the "Case the HQ" contract first.',
    mission_started       = 'Mission: %s — follow the marker.',
    mission_done          = 'Mission complete — payout sent to the gang.',
    mission_failed        = 'Mission failed.',
    mission_busy          = 'You already have a mission running.',
    mission_deliver       = 'Deliver it to the drop-off.',
    mission_cancelled     = 'Mission cancelled.',
    mission_none          = 'You have no mission running.',
    mission_cancel_hint   = 'Cancel any time with /cancelmission (or F6 → Cancel Mission).',
    mstep_travel          = 'Travel to the location',
    mstep_eliminate       = 'Eliminate the target',
    mstep_meet            = 'Meet the buyer to collect',
    mstep_grab            = 'Grab the package',
    mstep_grab_person     = 'Carry the target (F6 → Carry / [E])',
    mstep_grab_body       = 'Carry the body (F6 → Carry / [E])',
    mstep_deliver         = 'Drop the target at the buyers (F6 → Drop / [E])',
    mstep_dispose         = 'Drop the body here (F6 → Drop / [E])',
    mstep_clear           = 'Clear the cartel guards',
    mstep_grab_loot       = 'Grab the shipment',
    mstep_sell            = 'Sell to the buyers',

    -- ── Reputation ──
    rep_label             = 'Reputation',
    need_rep              = 'Your gang needs more reputation to raid.',

    -- ── Levels / upgrades ──
    level_up              = 'Your gang reached level %d!',
    upgrade_bought        = 'Upgrade purchased: %s',
    upgrade_maxed         = 'Upgrade already maxed.',
    upgrade_level_locked  = 'Requires gang level %d.',

    -- ── Medic ──
    medic_healed          = 'You were healed.',
    medic_revived         = 'You were revived.',
    medic_locked          = 'The gang medic is not unlocked.',

    -- ── Creator / editor ──
    creator_title         = 'Gang Zones',
    creator_aim           = 'Aim where the point should be · [E] confirm · [Esc] cancel',
    creator_saved         = 'Zone "%s" saved.',
    creator_deleted       = 'Zone deleted.',

    -- ── Test mode ──
    test_enabled          = 'Test mode ON — solo invasions + NPC defenders.',
    test_disabled         = 'Test mode OFF.',
    test_defenders        = '%d defenders incoming!',
    test_zone_cleared     = 'Area cleared — hold it to capture.',
    test_rival_created    = 'Test rival gang ready: %s',
    test_zone_created     = 'Rival turf zone created here (owner: %s). Walk in and press [E] to scout.',
    test_zone_nocoords    = 'No position yet — move a few steps and try again.',

    -- ── Airdrop ──
    airdrop_inbound       = 'An airdrop is inbound — find the crate!',
    airdrop_dispatched    = 'Airdrop dispatched.',
    airdrop_no_zones      = 'No airdrop zones are enabled.',
    airdrop_locked        = 'The crate is still sealed — wait for it to arm.',
    airdrop_open          = 'Open Airdrop',
    airdrop_looted        = 'Airdrop looted!',

    -- ── World prompt ──
    prompt_open_menu      = 'Open Gang Menu',
    target_open           = 'Open Gang Menu',
}
