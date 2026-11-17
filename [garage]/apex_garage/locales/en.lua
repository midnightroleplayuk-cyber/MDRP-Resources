--[[ apex_garage — locales/en.lua

    Canonical reference locale. Every key the resource can ask for lives here.
    Other locales (pt.lua, es.lua, …) may be partial: shared/utils.lua falls back
    to Locales.dict['en'] key by key, so a missing translation is never fatal.

    Format specifiers are load-bearing — keep them exactly:
        ui_sell_confirm  %s (vehicle), %s (price)
        ui_hours         %s (hours)
        n_paid_fee       %s (amount)
        n_sold           $%s (amount)
]]

Locales = Locales or {}
Locales.dict = Locales.dict or {}

Locales.dict['en'] = {
    -- ─────────────────────────────────────────────────────────────
    -- Prompts (TextUI / target labels)
    -- ─────────────────────────────────────────────────────────────
    prompt_open      = 'Open garage',
    prompt_store     = 'Store vehicle',
    prompt_impound   = 'Impound lot',

    -- World placer — key hints (rendered verbatim by the NUI)
    prompt_key_radius      = 'Radius',
    prompt_key_place       = 'Place',
    prompt_key_cancel      = 'Cancel',
    prompt_key_rotate      = 'Rotate',
    prompt_key_add_corner  = 'Add corner',
    prompt_key_finish      = 'Finish',
    prompt_key_remove_last = 'Remove last',
    prompt_key_place_spawn = 'Place spawn',

    -- World placer — headings
    prompt_title_zone        = 'Set zone',
    prompt_title_corners     = 'Zone corners',
    prompt_title_spawn       = 'Set spawn point',
    prompt_title_spawns      = 'Spawn points',
    prompt_spawns_count      = '%s — %s placed',
    prompt_place_zone_poly   = 'Zone corners — mark 3 or more',
    prompt_place_zone_circle = 'Garage zone — scroll adjusts the radius',
    prompt_place_store       = 'Store point',
    prompt_back_panel        = 'Back to panel',
    prompt_pk_zone_circle    = 'No-parking zone — scroll adjusts the radius',
    prompt_pk_zone_poly      = 'No-parking zone — mark 3 or more corners',

    -- TextUI sentence: <prefix> [E] <suffix> <lowercased prompt_*>
    -- e.g. "Press [E] to open garage"
    ui_press_prefix  = 'Press',
    ui_press_suffix  = 'to',

    -- ─────────────────────────────────────────────────────────────
    -- UI — shell, lists and filters
    -- ─────────────────────────────────────────────────────────────
    ui_garage        = 'GARAGE',
    ui_impound       = 'IMPOUND',
    ui_search        = 'Search by name or plate…',
    ui_cash          = 'Cash',
    ui_bank          = 'Bank',
    ui_all           = 'All',
    ui_empty         = 'You have no vehicles in this garage.',
    ui_empty_impound = 'No impounded vehicles.',
    ui_sort_name     = 'Name (A-Z)',
    ui_sort_status   = 'Status',
    ui_confirm       = 'Confirm',
    ui_cancel        = 'Cancel',
    ui_fee           = 'Fee',
    ui_leave         = 'Leave',

    -- generic buttons / chips (short — they sit inside fixed-width boxes)
    ui_save     = 'Save',
    ui_close    = 'Close',
    ui_collapse = 'Collapse',
    ui_remove   = 'Remove',
    ui_teleport = 'Teleport',
    ui_name     = 'Name',
    ui_set      = 'Set',
    ui_class    = 'Class',
    ui_add      = 'Add',
    ui_create   = 'Create',
    ui_delete   = 'Delete',
    ui_clear    = 'Clear',
    ui_place    = 'Place',
    ui_none     = 'None',
    ui_optional = 'optional',
    ui_yes      = 'Yes',
    ui_no       = 'No',
    ui_vehicle  = 'Vehicle',
    ui_edit     = 'Edit',

    ui_min_grade   = 'Minimum grade',
    ui_add_vehicle = 'Add vehicle',

    -- plural pair — JS picks the form, then .replace('%s', n)
    ui_count_one  = '%s vehicle',
    ui_count_many = '%s vehicles',
    ui_grade      = 'grade %s',

    -- vehicle-card eyebrow (uppercase by design)
    ui_brand_air = 'AIR',
    ui_brand_sea = 'SEA',
    ui_brand_car = 'VEHICLE',

    ui_shape_corners = 'Corners',
    ui_shape_circle  = 'Circle',
    ui_state_set     = 'Set',
    ui_state_unset   = 'Not set',

    -- preview dock tooltips
    ui_pv_rotate_left  = 'Rotate left',
    ui_pv_autorotate   = 'Auto-rotate',
    ui_pv_rotate_right = 'Rotate right',
    ui_pv_zoom_out     = 'Zoom out',
    ui_pv_zoom_in      = 'Zoom in',
    ui_pv_reset        = 'Reset camera',

    -- ─────────────────────────────────────────────────────────────
    -- UI — vehicle card
    -- ─────────────────────────────────────────────────────────────
    ui_nickname       = 'Nickname',
    ui_nickname_set   = 'Set nickname',
    ui_nickname_ph    = 'Vehicle nickname',
    ui_fuel           = 'Fuel',
    ui_engine         = 'Engine',
    ui_body           = 'Body',
    ui_status_stored  = 'In garage',
    ui_status_out     = 'Left out',
    ui_status_impound = 'Impounded',
    ui_financed       = 'Being financed',

    -- ─────────────────────────────────────────────────────────────
    -- UI — vehicle actions
    -- ─────────────────────────────────────────────────────────────
    ui_drive         = 'Take out',
    ui_return_drive  = 'Recover & drive',
    ui_transfer      = 'Transfer',
    ui_release       = 'Return to owner',
    ui_recover       = 'Recover',
    ui_sell          = 'Sell',
    ui_sell_title    = 'Sell vehicle',
    ui_sell_confirm  = 'You are about to sell %s for %s. This cannot be undone.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — transfer flow
    -- ─────────────────────────────────────────────────────────────
    ui_transfer_title       = 'Transfer vehicle',
    ui_transfer_garage      = 'To another garage',
    ui_transfer_player      = 'To another player',
    ui_transfer_pick_garage = 'Choose the destination garage',
    ui_transfer_pick_player = 'Nearby players',
    ui_transfer_no_players  = 'Nobody nearby.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — impound flow (police / admin side)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_title       = 'Impound vehicle',
    ui_impound_reason      = 'Reason',
    ui_impound_reason_ph   = 'Reason for impound…',
    ui_impound_retrievable = 'Owner may retrieve',
    ui_impound_time        = 'Time until retrieval',
    ui_impound_cost        = 'Retrieval cost',
    ui_impound_confirm     = 'Impound',
    ui_hours               = '%sh',
    ui_time_none           = 'No limit',
    ui_reason              = 'Reason',
    ui_impound_section     = 'Impound',

    -- impound form — lot picker & retrievability
    ui_impound_lot             = 'Impound lot',
    ui_impound_lot_nearest     = 'Nearest lot',
    ui_impound_retrievable_desc = 'The owner may buy this vehicle back once the hold expires.',
    ui_time_now                = 'Available immediately',
    ui_time_immediate          = 'Available immediately',

    -- impound readout (detail pane)
    ui_impound_held_at        = 'Held at',
    ui_impound_officer        = 'Impounded by',
    ui_impound_no_reason      = 'No reason given',
    ui_impound_release        = 'Release',
    ui_impound_release_owner  = 'Owner may collect',
    ui_impound_release_police = 'Police release only',
    ui_impound_available      = 'Available in',
    ui_impound_available_now  = 'Available now',
    ui_impound_free           = 'Free',
    ui_impound_wait           = 'Available in %s',
    ui_impound_locked_hint    = 'Only an officer can release this vehicle.',
    ui_at_impound             = 'Held at the impound',
    ui_impound_roster         = 'Vehicles held',
    ui_impound_owner          = 'Owner',
    ui_owner                  = 'Owner',
    ui_unknown_owner          = 'Unknown owner',

    -- duration chips (%h / %m are named — String.replace only swaps the first %s)
    ui_dur_h  = '%sh',
    ui_dur_m  = '%sm',
    ui_dur_hm = '%hh %mm',

    -- ─────────────────────────────────────────────────────────────
    -- UI — appearance (admin panel: the server-wide theme)
    -- ─────────────────────────────────────────────────────────────
    ui_theme            = 'Appearance',
    ui_theme_colors     = 'Colours',
    ui_theme_brand      = 'Accent colour',
    ui_theme_bg         = 'Background colour',
    ui_theme_derive     = 'Every surface, border and shade is derived from these two colours. Saving applies the new look to EVERY player instantly.',
    ui_theme_presets    = 'Presets',
    ui_theme_preview    = 'Preview',
    ui_theme_apply      = 'Apply to everyone',
    ui_theme_reset_def  = 'Restore default',

    -- mock content of the preview card (never shown outside the appearance pane)
    ui_theme_demo_title      = 'My vehicles',
    ui_theme_demo_stored     = 'Stored',
    ui_theme_demo_finance    = 'Financed',
    ui_theme_demo_kpi_stored = 'Stored',
    ui_theme_demo_kpi_out    = 'Out',
    ui_theme_demo_take       = 'Take out',
    ui_theme_demo_transfer   = 'Transfer',
    ui_theme_demo_search     = 'Search vehicle',

    -- ─────────────────────────────────────────────────────────────
    -- Admin panel (adm_) — garage list, boss panel, private garages
    -- ─────────────────────────────────────────────────────────────
    adm_count_one  = '%s garage',
    adm_count_many = '%s garages',
    adm_garages    = 'Garages',
    adm_new_garage  = 'New garage',
    adm_edit_garage = 'Edit garage',
    adm_empty      = 'No garages',
    adm_empty_sub  = "Create the first one with \"New garage\".",
    adm_row_vehicles = '%s veh.',
    adm_tp_garage    = 'Teleport to the garage',
    -- where a garage lives (the list shows both kinds since 1.1.7)
    adm_src_config      = 'Defined in shared/config.lua',
    adm_src_created     = 'Created in-game',
    adm_src_config_chip = 'config.lua',
    adm_src_config_hint = 'Edit it in shared/config.lua and restart the resource',

    adm_type_public  = 'Public',
    adm_type_job     = 'Job',
    adm_type_private = 'Private',
    adm_type_impound = 'Impound',

    adm_pick_player    = 'Choose player',
    adm_nobody_online  = 'Nobody online.',

    -- boss panel
    adm_company          = 'COMPANY',
    adm_management       = 'MANAGEMENT',
    adm_admin            = 'ADMIN',
    adm_company_garage   = 'COMPANY GARAGE',
    adm_company_fallback = 'Company',
    adm_boss_stock       = 'By stock',
    adm_boss_infinite    = 'Unlimited take-out',
    adm_boss_empty       = 'No vehicles',
    adm_boss_empty_sub   = 'Add the ones the company can take out.',
    adm_boss_empty_adm   = 'An admin defines this fleet in /apexgarage.',

    -- private garages
    adm_priv_title          = 'Private garages',
    adm_priv_empty          = 'You have no private garages yet.',
    adm_priv_create_here    = 'Create a private garage here',
    adm_priv_delete_confirm = 'Remove this private garage?',
    adm_priv_create_title   = 'Create private garage',
    adm_class_car_fallback  = 'Car',

    -- ─────────────────────────────────────────────────────────────
    -- Garage editor (ed_)
    -- ─────────────────────────────────────────────────────────────
    ed_identification = 'Identification',
    ed_name_ph        = 'Garage name',
    ed_type           = 'Type',
    ed_class_land     = 'Land',
    ed_class_air      = 'Air',
    ed_class_sea      = 'Sea',
    ed_officer_job    = 'Officers\' job',

    ed_veh_mode          = 'Vehicle mode',
    ed_veh_mode_personal = 'Personal',
    ed_veh_mode_company  = 'Company',
    ed_veh_mode_list     = 'List',
    ed_stock_infinite    = 'Unlimited',
    ed_stock_by_stock    = 'By stock',
    ed_boss_grade        = 'Boss grade',

    ed_owners          = 'Owners',
    ed_owner_add       = 'Add owner',
    ed_owners_existing = '%s current owner(s) (kept; add one to replace them).',
    ed_owners_none     = 'No owners — the garage stays inaccessible until you add one.',

    ed_zone_poly    = 'Polygon · %s corners',
    ed_zone_circle  = 'Circle · radius %s m',
    ed_zone_unset   = 'Not set yet',
    ed_store_set    = 'Dedicated point set',
    ed_store_unset  = 'Optional — the zone is used when empty',

    ed_placement      = 'World placement',
    ed_zone           = 'Garage zone',
    ed_tp_zone        = 'Teleport to the zone',
    ed_spawns         = 'Spawn points',
    ed_spawns_sub     = 'Where the vehicle appears when taken out',
    ed_store_point    = 'Storing point',
    ed_list_vehicles  = 'List vehicles',
    ed_no_vehicles    = 'No vehicles. Add the ones this job can take out.',

    ed_stock_mode      = 'Stock mode',
    ed_spawn_code      = 'Spawn code',
    ed_stock           = 'Stock',
    ed_stock_start     = 'Starting stock',
    ed_veh_edit        = 'Edit vehicle',
    ed_veh_fleet_hint  = 'Only an admin can change which vehicles this garage offers. The boss adjusts how many.',

    -- ─────────────────────────────────────────────────────────────
    -- Parking panel (pk_)
    -- ─────────────────────────────────────────────────────────────
    pk_title    = 'Parking',
    pk_settings = 'Settings',

    pk_tab_parking   = 'Parking',
    pk_tab_noparking = 'No parking',
    pk_tab_settings  = 'Settings',

    pk_enabled        = 'Parking enabled',
    pk_enabled_desc   = 'Allows players to park anywhere on the server.',
    pk_nocol          = 'No collision',
    pk_nocol_desc     = 'Other vehicles drive through parked cars.',
    pk_jobveh         = 'Company vehicles',
    pk_jobveh_desc    = 'Lets job/company cars be parked.',
    pk_nogarage       = 'Forbid inside garages',
    pk_nogarage_desc  = 'Blocks parking inside any garage zone.',
    pk_who            = 'Who can park',
    pk_who_desc       = 'Sets who has access to the command.',
    pk_mode_public     = 'Everyone',
    pk_mode_job        = 'By job',
    pk_mode_permission = 'By permission',
    pk_jobs           = 'Allowed jobs',
    pk_jobs_desc      = 'Comma separated.',
    pk_max            = 'Maximum per player',
    pk_max_desc       = 'How many cars each player may leave parked.',
    pk_unit_count     = 'pcs',
    pk_radius         = 'Anti-overlap radius',
    pk_radius_desc    = 'Minimum distance to another already parked car.',

    pk_perms           = 'Permissions',
    pk_grant           = 'Grant',
    pk_grant_title     = 'Grant permission',
    pk_perms_empty     = 'No permissions',
    pk_perms_empty_sub = 'Grant access to an online player.',
    pk_revoke          = 'Revoke',
    pk_offline         = 'Offline',

    pk_zones           = 'No-parking zones',
    pk_zones_empty     = 'No forbidden zones',
    pk_zones_empty_sub = 'Draw an area where nobody may park.',
    pk_zone            = 'Zone',
    pk_zone_corners    = '%s corners',
    pk_zone_radius     = 'radius %s m',

    pk_parked           = 'Parked vehicles',
    pk_parked_empty     = 'Nothing parked',
    pk_parked_empty_sub = 'Nobody has left vehicles in the world.',
    pk_save_note        = 'Changes only take effect after saving.',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications (n_) — player-facing toasts
    -- ─────────────────────────────────────────────────────────────
    n_no_access      = 'You cannot access this garage.',
    n_no_vehicle     = 'You are not in a vehicle.',
    n_not_driver     = 'You must be the driver.',
    -- Config.occupantGuard: the action would have deleted the car with people in it
    n_occupied         = 'Get your passengers out before storing the vehicle.',
    n_occupied_impound = 'Get everyone out of the vehicle before impounding it.',
    n_impound_on_foot = 'Get out of your vehicle to use the impound lot.',
    n_wrong_class    = 'This vehicle does not belong to this garage.',
    n_stored         = 'Vehicle stored.',
    n_taken_out      = 'Vehicle taken out.',
    n_blocked        = 'No room to take the vehicle out here.',
    n_paid_fee       = 'Fee paid: %s.',
    n_nickname_ok    = 'Nickname updated.',
    n_transferred    = 'Vehicle transferred.',
    n_sold           = 'Vehicle sold for $%s.',
    n_impounded      = 'Vehicle impounded.',
    n_released       = 'Vehicle returned to the owner\'s garage.',
    n_recovered      = 'Vehicle recovered from impound.',
    n_no_target      = 'No vehicle nearby.',

    -- notifications — impound
    n_impound_locked    = 'This vehicle can only be released by an officer.',
    n_impound_not_ready = 'This vehicle cannot be collected yet.',
    n_impound_released  = 'Your vehicle %s was released from the impound and is waiting at %s.',
    n_impound_empty     = 'You have no vehicles at this impound.',
    n_impounded_reason  = 'Impounded by %s — %s',
    n_impound_no_reason = 'No reason given',
    n_too_far           = 'You are too far from the impound lot.',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications — admin commands & private garages
    -- ─────────────────────────────────────────────────────────────
    n_npc_removed    = 'Unowned vehicle removed.',
    n_priv_created   = 'Private garage created.',
    n_priv_deleted   = 'Private garage removed.',
    n_priv_noperm    = 'You cannot create private garages.',
    n_priv_name      = 'That name already exists.',
    n_plate_changed  = 'Plate changed.',
    n_veh_returned   = 'Vehicle returned to garage.',
    n_veh_deleted    = 'Vehicle removed from the database.',

    n_garage_created = 'Garage created.',
    n_garage_updated = 'Garage updated.',
    n_garage_deleted = 'Garage deleted.',
    n_theme_saved    = 'Appearance saved for the whole server.',
    n_theme_reset    = 'Appearance restored to default.',
    n_veh_added      = 'Vehicle added.',

    -- notifications — persistent parking
    n_parked              = 'Vehicle parked.',
    n_unparked            = 'Vehicle unparked — returned to the garage.',
    n_park_exiting        = 'Parking — getting out…',
    n_park_exit_failed    = 'You did not get out cleanly, but the vehicle is parked.',
    n_park_released       = 'Vehicle released. You can drive it now.',
    n_park_settings_saved = 'Parking settings saved.',
    n_park_veh_removed    = 'Parked vehicle removed.',
    n_park_zone_created   = 'No-parking zone created.',
    n_park_zone_removed   = 'Zone removed.',

    -- ─────────────────────────────────────────────────────────────
    -- Errors (e_) — returned by the server, looked up dynamically
    -- ─────────────────────────────────────────────────────────────
    e_nil         = 'Something went wrong.',
    e_invalid     = 'Invalid.',
    e_no_access   = 'No access.',
    e_not_owner   = 'Not the owner.',
    e_wrong_class = 'This vehicle does not belong to this garage.',
    e_no_money    = 'Not enough money.',
    e_unavailable = 'Unavailable.',
    -- the server refused the take-out because every spawn slot is occupied
    e_blocked     = 'No room to take the vehicle out here.',
    e_busy        = 'You already have an action in progress.',
    e_no_target   = 'No vehicle nearby.',
    e_already_out = 'That vehicle is already out.',
    -- shown on the Recover button too, so keep it short
    e_occupied    = 'Someone is inside that vehicle.',
    e_noperm      = 'No permission.',
    e_name        = 'That name is already taken.',

    -- errors — impound
    e_impound_locked    = 'Officer release only.',
    e_impound_not_ready = 'Not available yet.',
    e_impounded         = 'Impounded.',
    e_too_far           = 'Too far away.',
    e_no_lot            = 'No impound lot accepts this vehicle.',

    -- errors — admin panel / editor
    e_theme_invalid   = 'Invalid colours.',
    e_zone_create     = 'Failed to create the zone.',
    e_no_zone         = 'That garage has no zone defined yet.',
    e_need_placement  = 'Define the zone and at least one spawn point.',
    e_config_readonly = 'That garage is defined in shared/config.lua — edit it there and restart the resource.',
    -- /garagewhere   %s (garage), %s (source), %s (metres), %s (coordinates)
    diag_nearest      = 'Nearest garage: %s (%s), %s m away — access point %s',
    diag_none         = 'No garage loaded on this client yet.',
    e_no_boss_garage  = 'You do not manage any company garage.',
    e_fleet_admin_only = 'Only a server admin can change which vehicles this garage offers.',

    -- errors — job fleet stock
    e_stock_all_out   = 'Every one of those is already out.',
    e_no_vehicle      = 'You are not in a vehicle.',
    e_stock_boss_only = 'Only an appointed boss or a server admin can change fleet capacity.',

    -- errors — selling
    e_sell_off      = 'Instant sell is not available.',
    e_sell_financed = 'You cannot sell a financed vehicle.',
    e_sell_out      = 'The vehicle is out in the world.',
    e_sell_parked   = 'The vehicle is parked.',
    e_sell_impound  = 'The vehicle is impounded.',
    e_sell_noprice  = 'This vehicle has no market price.',
    e_sell_payfail  = 'The sale failed to pay out. Contact an administrator.',

    -- ─────────────────────────────────────────────────────────────
    -- Errors — persistent parking
    -- ─────────────────────────────────────────────────────────────
    e_park_off         = 'Persistent parking is disabled.',
    e_park_noperm      = 'You are not allowed to park here.',
    e_park_notowned    = 'This vehicle is not yours.',
    e_park_max         = 'You have reached your parked vehicle limit.',
    e_park_occupied    = 'There is already a vehicle parked here.',
    e_park_none        = 'No parked vehicle with that plate.',
    e_park_notowner    = 'Only the owner can take this vehicle back.',
    e_park_busy        = 'The parking system is still starting up.',
    e_park_already     = 'This vehicle is already parked.',
    e_park_parked      = 'This vehicle is parked out in the street — go get it there.',
    e_park_notdriving  = 'You must be inside the vehicle you want to park.',
    e_park_moving      = 'Bring the vehicle to a full stop before parking it.',
    e_park_blacklisted = 'Parking is not allowed in this area.',
    e_park_in_garage   = 'You cannot park inside a garage.',
    e_park_none_near   = 'You are not near any of your parked vehicles.',

    -- ─────────────────────────────────────────────────────────────
    -- UNUSED — no longer referenced by any Lua or NUI code.
    -- Kept for compatibility; safe to skip when translating.
    -- ─────────────────────────────────────────────────────────────
    ui_sort_recent      = 'Recent',
    ui_plate            = 'Plate',
    ui_theme_brand_desc = 'Buttons, markers and highlights across the whole server.',
    ui_theme_bg_desc    = 'Base tone of the interface; every other surface is derived from it.',
    ui_theme_reset      = 'Reset',
    ui_theme_save       = 'Save',
    ui_theme_hint       = 'The colours apply to every player as soon as you save.',
    ui_theme_unsaved    = 'Preview — not saved yet.',
    n_not_owner         = 'This is not your vehicle.',
    n_unavailable       = 'Vehicle currently unavailable.',
    n_already_out       = 'That vehicle is already out.',
    n_no_money          = 'Not enough money.',
    n_invalid           = 'Invalid action.',
}
