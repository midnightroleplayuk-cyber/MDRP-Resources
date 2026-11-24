-- Physical props offered for each location type in the Locations tab.
-- A location type with no list here can only be an invisible interaction point.
NDM.PropOptions = {
    management = {
        { model = 'prop_pc_02a', label = 'Desktop PC' },
        { model = 'bkr_prop_clubhouse_laptop_01b', label = 'Laptop' },
        { model = 'ba_prop_battle_club_computer_01', label = 'Office computer' },
    },
    register = {
        { model = 'pickle_register_01', label = 'Restaurant register' },
        { model = 'prop_till_01', label = 'Till 1' },
        { model = 'prop_till_02', label = 'Till 2' },
        { model = 'prop_till_03', label = 'Till 3' },
        { model = 'vw_prop_casino_till', label = 'Casino till' },
        { model = 'ch_prop_casino_till_01a', label = 'Modern till' },
    },
    stock = {
        { model = 'ch_prop_ch_laundry_shelving_01b', label = 'Shelving 1' },
        { model = 'ch_prop_ch_laundry_shelving_01c', label = 'Shelving 2' },
        { model = 'ch_chint02_office_shelving', label = 'Office shelving' },
        { model = 'prop_bar_beerfridge_01', label = 'Beer fridge' },
        { model = 'prop_bar_fridge_02', label = 'Bar fridge' },
    },
    crafting = {
        { model = 'pickle_kitchen_prep_01', label = 'Prep station' },
        { model = 'pickle_stovetop_01', label = 'Stovetop' },
        { model = 'pickle_fryer_01', label = 'Fryer' },
        { model = 'pickle_soda_fountain_01', label = 'Soda fountain' },
    },
    grill = {
        { model = 'pickle_stovetop_01', label = 'Stovetop' },
    },
    fryer = {
        { model = 'pickle_fryer_01', label = 'Fryer' },
    },
    prep = {
        { model = 'pickle_kitchen_prep_01', label = 'Prep table' },
    },
    drinks = {
        { model = 'pickle_soda_fountain_01', label = 'Soda fountain' },
    },
    shop = {
        { model = 'pickle_kiosk_large_01', label = 'Order kiosk 1' },
        { model = 'pickle_kiosk_large_02', label = 'Order kiosk 2' },
        { model = 'prop_ff_counter_02', label = 'Counter 1' },
        { model = 'prop_ff_counter_03', label = 'Counter 2' },
    },
    menu_board = {
        { model = 'pickle_screen_menu_01', label = 'Menu screen' },
    },
    club_entry = {
        { model = 'vw_prop_casino_till', label = 'Entry till' },
        { model = 'pickle_kiosk_large_01', label = 'Entry kiosk' },
        { model = 'prop_ff_counter_02', label = 'Entry counter' },
    },
    bar = {
        { model = 'prop_bar_beerfridge_01', label = 'Beer fridge' },
        { model = 'prop_bar_fridge_02', label = 'Bar fridge' },
        { model = 'p_new_j_counter_01', label = 'Bar counter' },
        { model = 'npds_coaster_round_02', label = 'Drink coaster' },
    },
}

function NDM.IsPropAllowed(pointType, model)
    for _, option in ipairs(NDM.PropOptions[pointType] or {}) do
        if option.model == model then return true end
    end
    return false
end
