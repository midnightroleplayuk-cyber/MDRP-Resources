-- ============================================================
-- ΕΛΛΗΝΙΚΑ (el)
-- ------------------------------------------------------------
-- Επίστρωση πάνω από το configs/strings.lua. Κάθε κλειδί που
-- λείπει από εδώ κρατά το αγγλικό κείμενο, οπότε η μερική
-- μετάφραση είναι ασφαλής.
--
-- Τα %s πρέπει να διατηρηθούν και με την ΙΔΙΑ σειρά όπως στο
-- πρωτότυπο: τα συμπληρώνει η :format() στον κώδικα. Το %%
-- τυπώνει ένα κυριολεκτικό σύμβολο ποσοστού.
--
-- Ενεργοποίηση:  Config.Locale = 'el'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['el'] = {
    -- ── Κύριο μενού ─────────────────────────────────────────
    main_title = 'Μενού Διαχείρισης',
    self_options = 'Προσωπικές Επιλογές',
    self_options_desc = 'Επιλογές που αφορούν εσένα',
    player_options_title = 'Επιλογές Παίκτη',
    player_options_desc = 'Επιλογές που αφορούν άλλους παίκτες',
    vehicle_options = 'Επιλογές Οχήματος',
    vehicle_options_desc = 'Επιλογές που αφορούν οχήματα',
    server_options = 'Επιλογές Διακομιστή',
    server_options_desc = 'Επιλογές που αφορούν τον διακομιστή',
    admin_zone_options = 'Ζώνες Διαχείρισης',
    admin_zone_options_desc = 'Διαχείριση, προσθήκη και διαγραφή ζωνών διαχείρισης',
    developer_options = 'Επιλογές Προγραμματιστή',
    developer_options_desc = '',

    -- ── Προσωπικές επιλογές ─────────────────────────────────
    self_options_menu = 'Προσωπικές Επιλογές',
    self_health = 'Ζωή (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Αναζωογόνηση',
    self_revive_desc = 'Αναζωογόνησε τον εαυτό σου',
    self_heal = 'Θεραπεία',
    self_heal_desc = 'Θεράπευσε τον εαυτό σου',
    self_skinmenu = 'Μενού Ρούχων',
    self_set_ped = 'Αλλαγή Ped',
    self_skinmenu_desc = 'Άνοιγμα του μενού ρούχων τοπικά',
    self_invisible = 'Αόρατος',
    self_godmode = 'Λειτουργία Θεού',
    self_wallhack = 'Wallhack',

    -- ── Επιλογές παίκτη ─────────────────────────────────────
    player_options_menu = 'Παίκτες Online %s/%s',
    player_options = 'Παίκτης: %s',
    player_health = 'Ζωή Παίκτη (%s%%)',
    player_freeze = 'Πάγωμα',
    player_freeze_desc = 'Ενεργοποίηση/απενεργοποίηση',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Ενεργοποίηση/απενεργοποίηση',
    player_spectate = 'Παρακολούθηση',
    player_spectate_desc = 'Παρακολούθησε τις ενέργειες αυτού του παίκτη',
    player_playerdata = 'Δεδομένα Παίκτη',
    player_playerdata_desc = 'Δες τα δεδομένα του παίκτη',
    player_revive = 'Αναζωογόνηση',
    player_revive_desc = 'Αναζωογόνησε τον παίκτη',
    player_heal = 'Θεραπεία',
    player_heal_desc = 'Θεράπευσε τον παίκτη',
    player_skinmenu = 'Μενού Ρούχων',
    player_skinmenu_desc = 'Άνοιξε ένα μενού ρούχων στον παίκτη',
    player_money = 'Δώσε Χρήματα',
    player_money_desc = 'Δώσε χρήματα στον επιλεγμένο παίκτη',
    player_item = 'Δώσε Αντικείμενο',
    player_item_desc = 'Δώσε ένα αντικείμενο στον επιλεγμένο παίκτη',
    player_openinv = 'Άνοιγμα Αποθήκης',
    player_openinv_desc = 'Άνοιξε την αποθήκη του παίκτη',
    player_clearinv = 'Άδειασμα Αποθήκης',
    player_clearinv_desc = 'Άδειασε την αποθήκη του παίκτη',
    player_teleport_to = 'Τηλεμεταφορά στον Παίκτη',
    player_teleport_to_desc = 'Τηλεμεταφέρσου στον παίκτη',
    player_bring = 'Φέρε',
    player_bring_desc = 'Φέρε τον παίκτη στη θέση σου',
    player_kick = 'Αποβολή',
    player_kick_desc = 'Απόβαλε τον παίκτη από τον διακομιστή',
    player_ban = 'Αποκλεισμός Παίκτη',

    -- ── Μενού οχήματος ──────────────────────────────────────
    vehicle_menu = 'Μενού Οχήματος',
    spawn_car = 'Δημιουργία Οχήματος',
    spawn_car_desc = 'Δημιούργησε ένα όχημα',
    repair_car = 'Επισκευή Οχήματος',
    repair_car_desc = 'Επισκεύασε το τρέχον ή το πλησιέστερο όχημα',
    delete_car = 'Διαγραφή Οχήματος',
    delete_car_desc = 'Διάγραψε το τρέχον ή το πλησιέστερο όχημα',
    number_plate = 'Αλλαγή Πινακίδας',
    number_plate_desc = 'Άλλαξε το κείμενο της τρέχουσας πινακίδας',
    refuel = 'Ανεφοδιασμός Οχήματος',
    refuel_desc = 'Ανεφοδίασε το τρέχον ή το πλησιέστερο όχημα',
    give_keys = 'Δώσε Κλειδιά',
    give_keys_desc = 'Δώσε στον εαυτό σου τα κλειδιά του τρέχοντος οχήματος',
    doors = 'Κλείδωμα/Ξεκλείδωμα Θυρών',
    doors_desc = 'Εναλλάσσει τις κλειδαριές του πλησιέστερου οχήματος',
    boost_car = 'Πολλαπλασιαστής Ροπής',
    boost_car_desc = 'Άλλαξε τη ροπή του τρέχοντος οχήματος',
    color_change = 'Αλλαγή Χρώματος Οχήματος',
    color_change_desc = 'Άλλαξε το χρώμα του τρέχοντος ή του πλησιέστερου οχήματος',

    -- ── Διαχείριση διακομιστή ───────────────────────────────
    server_management = 'Διαχείριση Διακομιστή',
    server_announcement = 'Ανακοίνωση Διακομιστή',
    server_announcement_desc = 'Στείλε μια γενική ανακοίνωση σε όλο τον διακομιστή',
    ban_list = 'Λίστα Αποκλεισμών',
    ban_list_desc = 'Δες όλους τους ενεργούς αποκλεισμούς',
    objects_list = 'Διαγραφή Οντοτήτων',
    objects_list_desc = 'Διάγραψε οχήματα και peds',
    objects_list_label = 'Επιλογές',
    weather_menu = 'Διαχείριση Καιρού',
    weather_menu_desc = 'Διαχειρίσου τον καιρό',

    -- ── Ζώνες διαχείρισης ───────────────────────────────────
    zones_create = 'Δημιουργία Ζώνης',
    zones_create_desc = 'Δημιούργησε μια νέα ζώνη διαχείρισης',
    zones_manage = 'Διαχείριση Ζωνών',
    zones_manage_desc = 'Επεξεργάσου ή διάγραψε ενεργές ζώνες',
    zone_edit_current = 'Επεξεργασία Τρέχουσας Ζώνης',
    zone_edit_current_desc = 'Διαχειρίσου τη ζώνη στην οποία βρίσκεσαι',
    zone_delete_current = 'Διαγραφή Τρέχουσας Ζώνης',
    zone_delete_current_desc = 'Διάγραψε τη ζώνη στην οποία βρίσκεσαι',
    zone_manage_menu = 'Επεξεργασία Ζώνης (%s)',
    zone_edit = 'Επεξεργασία Ζώνης',
    zone_edit_desc = 'Τροποποίησε τη ζώνη: %s',
    zone_delete = 'Διαγραφή Ζώνης',
    zone_delete_desc = 'Διάγραψε τη ζώνη: %s',
    zone_teleport = 'Τηλεμεταφορά στη Ζώνη',
    zone_teleport_desc = 'Πήγαινε στη ζώνη: %s',

    -- ── Μενού προγραμματιστή ────────────────────────────────
    dev_options = 'Επιλογές Προγραμματιστή',
    debug_mode = 'Λειτουργία Debug',
    debug_mode_desc = 'Ενεργοποίηση/απενεργοποίηση της λειτουργίας debug',
    copy_vec3 = 'Αντιγραφή Συντεταγμένων Vector3',
    copy_vec3_desc = 'Αντιγράφει την τρέχουσα θέση σου (vector3) στο πρόχειρο',
    copy_vec4 = 'Αντιγραφή Συντεταγμένων Vector4',
    copy_vec4_desc = 'Αντιγράφει την τρέχουσα θέση σου (vector4) στο πρόχειρο',
    copy_heading = 'Αντιγραφή Κατεύθυνσης',
    copy_heading_desc = 'Αντιγράφει την τρέχουσα κατεύθυνσή σου στο πρόχειρο',
    cant_delete = 'Δεν διαγράφεται!',
    cant_delete_player_desc = 'Δεν μπορείς να διαγράψεις peds παικτών!',
    cant_delete_entity_desc = 'Δεν μπορείς να διαγράψεις τα προεπιλεγμένα αντικείμενα του χάρτη!',

    -- ── Λίστα αποκλεισμών ───────────────────────────────────
    ban_list_menu = 'Λίστα Αποκλεισμών',
    ban_list_name = 'Όνομα: %s',
    ban_list_license = 'Άδεια:',
    ban_list_by = 'Από: %s',
    ban_list_reason = 'Αιτία: %s',
    ban_list_length = 'Χρόνος που απομένει: %s ώρες %s λεπτά',
    ban_list_modify = 'Τροποποίηση Αποκλεισμού',
    ban_list_unban = 'Άρση Αποκλεισμού',
    ban_list_no_data = 'Κανένας Αποκλεισμός',
    ban_list_no_data_desc = 'Δεν βρέθηκαν ενεργοί αποκλεισμοί!',

    -- ── Δεδομένα παίκτη ─────────────────────────────────────
    playerdata_menu = 'Δεδομένα Παίκτη',
    playerdata_license_esx = 'Άδεια: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Κάνε κλικ για αντιγραφή ολόκληρης της άδειας',
    playerdata_igname = 'Όνομα: %s',
    playerdata_igname_desc = 'Το πλήρες όνομα του παίκτη στο παιχνίδι',
    playerdata_steam = 'Όνομα Steam: %s',
    playerdata_steam_desc = 'Το πλήρες όνομα Steam του παίκτη',
    playerdata_gender = 'Φύλο: %s',
    playerdata_gender_desc = 'Το φύλο του παίκτη',
    playerdata_cash = 'Μετρητά: %s',
    playerdata_cash_desc = 'Το υπόλοιπο μετρητών του παίκτη',
    playerdata_bank = 'Τράπεζα: %s',
    playerdata_bank_desc = 'Το τραπεζικό υπόλοιπο του παίκτη',
    playerdata_blackmoney = 'Μαύρο Χρήμα: %s',
    playerdata_blackmoney_desc = 'Το υπόλοιπο μαύρου χρήματος του παίκτη',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Πάτα [E] για διαγραφή της οντότητας  \nHash: %s  \nΣυντεταγμένες: vec3(%s, %s, %s)  \nΚατεύθυνση: %s  \nΙδιοκτήτης: [%s] - %s',
    debug_textui_noname = 'Πάτα [E] για διαγραφή της οντότητας\n  Hash: %s\n  Συντεταγμένες: vec3(%s, %s, %s)\n  Κατεύθυνση: %s\n  Ιδιοκτήτης: ΑΓΝΩΣΤΟΣ',

    textui_invisible = 'Λειτουργία Αοράτου - Ενεργή',
    textui_godmode = 'Λειτουργία Θεού - Ενεργή',
    textui_wallhack = 'Wallhack - Ενεργό',
    textui_noclip_activated = 'No Clip - Ενεργό',
    textui_torque = 'Πολλαπλασιαστής Ροπής - %s',

    -- ── Ανακοινώσεις ────────────────────────────────────────
    dialog_announce = 'Ανακοίνωση',
    dialog_announce_label = 'Μήνυμα',
    dialog_announce_select = 'Όλοι',
    dialog_announce_everyone = 'Όλοι',
    dialog_announce_placeholder = 'Σημαντικό μήνυμα εδώ. . .',

    -- ── Άρση αποκλεισμού ────────────────────────────────────
    dialog_unban = 'Είσαι σίγουρος;',
    dialog_unban_content = 'Θέλεις πραγματικά να άρεις τον αποκλεισμό του %s;',

    -- ── Διαγραφή οντοτήτων ──────────────────────────────────
    dialog_objects = 'Διάλεξε μια επιλογή',
    dialog_clear_objects = 'Διαγραφή ΟΛΩΝ των αντικειμένων',
    dialog_clear_cars = 'Διαγραφή ΟΛΩΝ των οχημάτων (χωρίς οδηγό)',
    dialog_clear_peds = 'Διαγραφή ΟΛΩΝ των peds',

    -- ── Δόση χρημάτων ───────────────────────────────────────
    dialog_givemoney = 'Δώσε Χρήματα',
    givemoney_input_label = 'Ποσό',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Λογαριασμός',
    givemoney_select_option1 = 'Μετρητά',
    givemoney_select_option2 = 'Τράπεζα',
    givemoney_select_option3 = 'Μαύρο Χρήμα',

    -- ── Δόση αντικειμένου ───────────────────────────────────
    dialog_giveitem = 'Δώσε Αντικείμενο',
    giveitem_input_label = 'Όνομα Αντικειμένου',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Ποσότητα',
    giveitem_amount_input_placeholder = '3',

    -- ── Δημιουργία οχήματος ─────────────────────────────────
    dialog_spawn_a_car = 'Δημιουργία Οχήματος',
    dialog_car_model = 'Όνομα Μοντέλου',
    dialog_car_model_holder = 'Π.χ: 20charger',
    dialog_car_plate = 'Πινακίδα (προαιρετικό)',
    dialog_car_plate_holder = 'Π.χ: W4S4B1',
    dialog_car_color_primary = 'Κύριο Χρώμα (προαιρετικό)',
    dialog_car_color_second = 'Δευτερεύον Χρώμα (προαιρετικό)',
    dialog_car_maxed = 'Μέγιστες Βελτιώσεις (προαιρετικό)',

    -- ── Αποβολή ─────────────────────────────────────────────
    dialog_kick = 'Αποβολή %s',
    dialog_kick_reason = 'Αιτία',
    dialog_kick_placeholder = 'Ζαβολιάρης',
    kicked_reason_replace = 'Αποβλήθηκες από τον διακομιστή!',

    -- ── Αποκλεισμός ─────────────────────────────────────────
    dialog_ban = 'Αποκλεισμός %s',
    dialog_ban_reason = 'Αιτία',
    dialog_ban_placeholder = 'Ζαβολιάρης',
    ban_reason_replace = 'Αποκλείστηκες από αυτόν τον διακομιστή!',

    -- ── Δημιουργία ζώνης ────────────────────────────────────
    dialog_zone_create = 'Δημιουργία Ζώνης',
    dialog_zone_name = 'Όνομα',
    dialog_zone_name_desc = 'Το όνομα της ζώνης / του blip',
    dialog_zone_name_holder = 'Ζώνη Διαχείρισης',
    dialog_zone_text = 'Εμφανιζόμενο Κείμενο',
    dialog_zone_text_desc = 'Το κείμενο που βλέπουν οι παίκτες μέσα στη ζώνη',
    dialog_zone_text_holder = 'ΖΩΝΗ ΔΙΑΧΕΙΡΙΣΗΣ - ΕΝΕΡΓΗ',
    dialog_zone_size = 'Μέγεθος',
    dialog_zone_speed = 'Όριο Ταχύτητας',
    mph = 'MPH',
    kmh = 'ΧΛΜ/Ω',
    dialog_zone_blip_id = 'ID Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Χρώματος',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip που Αναβοσβήνει',
    dialog_zone_disarm = 'Αφοπλισμός',
    dialog_zone_revive = 'Αναζωογόνηση',
    dialog_zone_invincible = 'Άτρωτος',
    dialog_zone_edit = 'Επεξεργασία «%s»',
    dialog_zone_delete_confirm = 'Είσαι σίγουρος;',
    dialog_zone_delete_confirm_desc = 'Θέλεις πραγματικά να διαγράψεις τη ζώνη: %s',

    -- ── Ειδοποιήσεις: χρήματα ───────────────────────────────
    notify_givemoney_success = 'Χρήματα Δόθηκαν',
    notify_givemoney_success_desc = 'Πίστωσες στον %s $%s στον λογαριασμό: %s',
    notify_givemoney_fail = 'Ανεπιτυχές',
    notify_givemoney_fail_desc = 'Προσπάθησες να πιστώσεις τον %s αλλά κάτι πήγε στραβά! Δοκίμασε ξανά.',

    -- ── Ειδοποιήσεις: αντικείμενα ───────────────────────────
    notify_giveitem_success = 'Αντικείμενο Δόθηκε',
    notify_giveitem_success_desc = 'Έδωσες στον %s. Αντικείμενο: %s Ποσότητα: %s',
    notify_giveitem_fail = 'Απέτυχε',
    notify_giveitem_fail_desc = 'Προσπάθησες να δώσεις στον %s αλλά κάτι πήγε στραβά! Δοκίμασε ξανά.',

    -- ── Ειδοποιήσεις: αποβολή / αποκλεισμός ─────────────────
    notify_kicked_success = 'Επιτυχής Αποβολή',
    notify_kicked_success_desc = 'Απέβαλες με επιτυχία τον %s',
    notify_banned_success = 'Επιτυχής Αποκλεισμός',
    notify_banned_success_desc = 'Απέκλεισες με επιτυχία τον %s',

    -- ── Ειδοποιήσεις: αποθήκη ───────────────────────────────
    notify_clearedinv = 'Αποθήκη Άδειασε',
    notify_clearedinv_desc = 'Άδειασες με επιτυχία την αποθήκη του %s',

    -- ── Ειδοποιήσεις: άκυρο ID ──────────────────────────────
    notify_invalidid = 'Άκυρο ID',
    notify_invalidid_desc = 'Το ID που έδωσες ήταν άκυρο, δοκίμασε ξανά.',

    -- ── Ειδοποιήσεις: καθαρισμός ────────────────────────────
    notify_deleted_car = 'Οχήματα Διαγράφηκαν',
    notify_deleted_car_desc = 'Διέγραψες με επιτυχία όλα τα οχήματα χωρίς οδηγό.',
    notify_deleted_ped = 'Peds Διαγράφηκαν',
    notify_deleted_ped_desc = 'Διέγραψες με επιτυχία όλα τα peds στον χάρτη',
    notify_deleted_objects = 'Αντικείμενα Διαγράφηκαν',
    notify_deleted_objects_desc = 'Διέγραψες με επιτυχία όλα τα αντικείμενα στον χάρτη',

    -- ── Ειδοποιήσεις: καιρός ────────────────────────────────
    notify_weather = 'Ο Καιρός Άλλαξε',
    notify_weather_desc = 'Ο καιρός άλλαξε σε: %s',

    -- ── Ειδοποιήσεις: αντιγραφή συντεταγμένων ───────────────
    notify_copied = 'Αντιγράφηκε',
    notify_copied_vec3 = 'Το vector3 αντιγράφηκε στο πρόχειρο!',
    notify_copied_vec4 = 'Το vector4 αντιγράφηκε στο πρόχειρο!',
    notify_copied_headin = 'Η κατεύθυνση αντιγράφηκε στο πρόχειρο!',

    -- ── Ειδοποιήσεις: πόρτες ────────────────────────────────
    notify_locked_doors = 'Κλειδώθηκε',
    notify_locked_doors_desc = 'Οι πόρτες του οχήματος κλειδώθηκαν με επιτυχία.',
    notify_unlocked_doors = 'Ξεκλειδώθηκε',
    notify_unlocked_doors_desc = 'Οι πόρτες του οχήματος ξεκλειδώθηκαν με επιτυχία.',

    -- ── Ειδοποιήσεις: ζώνες διαχείρισης ─────────────────────
    notify_zone_deleted = 'Ζώνη Διαγράφηκε',
    notify_zone_deleted_desc = 'Αφαίρεσες με επιτυχία τη ζώνη: %s.',
    notify_zone_not_deleted_desc = 'Παρουσιάστηκε σφάλμα κατά τη διαγραφή της ζώνης: %s.',
    notify_zone_edited = 'Ζώνη Τροποποιήθηκε',
    notify_zone_edited_desc = 'Τροποποίησες με επιτυχία τη ζώνη: %s.',
    notify_zone_not_edited_desc = 'Παρουσιάστηκε σφάλμα κατά την τροποποίηση της ζώνης: %s.',
    notify_zone_action_cancelled = 'Η Ενέργεια Ακυρώθηκε',
    notify_zone_delete_cancel = 'Ακύρωσες τη διαγραφή της ζώνης: %s',
    notify_zone_no_weapons = 'Απαγορεύονται τα Όπλα',
    notify_zone_no_weapons_desc = 'Δεν επιτρέπεται να χρησιμοποιείς όπλα μέσα σε αυτή τη ζώνη.',
    notify_zones_not_found = 'Καμία Ζώνη',
    notify_zones_not_found_desc = 'Αυτή τη στιγμή δεν υπάρχουν ενεργές ζώνες προς διαχείριση.',
    notify_zones_teleport = 'Τηλεμεταφέρθηκες',
    notify_zones_teleport_desc = 'Τηλεμεταφέρθηκες με επιτυχία στη ζώνη: %s.',

    -- ── Ειδοποιήσεις: άρση αποκλεισμού ──────────────────────
    successfully_unbanned = 'Ο Αποκλεισμός Ήρθη',
    successfully_unbanned_desc = 'Ήρες με επιτυχία τον αποκλεισμό: %s.',
    unsuccessful_unban = 'Κάτι πήγε στραβά κατά την άρση του αποκλεισμού: %s.',

    -- ── Σύνδεση (deferrals) ─────────────────────────────────
    deferral_welcome = '[%s] Γεια σου %s, γίνεται έλεγχος αποκλεισμών. . .',
    deferral_banned = 'Είσαι αποκλεισμένος από τον διακομιστή. Αιτία: «%s» (Χρόνος που απομένει: %s ώρες %s λεπτά).',
    deferral_banned_perm = 'Είσαι αποκλεισμένος από τον διακομιστή. Αιτία: «%s» (Χρόνος που απομένει: Μόνιμα).',

    -- ── Σφάλματα ────────────────────────────────────────────
    notify_error = 'Σφάλμα',
    notify_disabled_keys = 'Δεν έχει ρυθμιστεί κανένα script κλειδιών οχημάτων. Επικοινώνησε με τον προγραμματιστή του διακομιστή.',
    notify_no_appearance = 'Δεν εντοπίστηκε script ρούχων / εμφάνισης. Επικοινώνησε με τον προγραμματιστή του διακομιστή.',
    notify_no_vehicle = 'Δεν βρέθηκε όχημα!',
    notify_invalid_entry = 'Άκυρη καταχώρηση!',

    -- ── Συντόμευση πληκτρολογίου ────────────────────────────
    keymapping_desc = 'Άνοιγμα Μενού Διαχείρισης (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Ενεργοποιήθηκε',
    noclip_deactivated = 'NoClip Απενεργοποιήθηκε',

    -- ── Αορατότητα ──────────────────────────────────────────
    invisibility_activated = 'Λειτουργία Αοράτου Ενεργοποιήθηκε',
    invisibility_deactivated = 'Λειτουργία Αοράτου Απενεργοποιήθηκε',

    -- ── Λειτουργία θεού ─────────────────────────────────────
    godmode_activated = 'Λειτουργία Θεού Ενεργοποιήθηκε',
    godmode_deactivated = 'Λειτουργία Θεού Απενεργοποιήθηκε',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Ενεργοποιήθηκε',
    wallhack_deactivated = 'Wallhack Απενεργοποιήθηκε',

    -- ── Λειτουργία debug ────────────────────────────────────
    debug_activated = 'Λειτουργία Debug Ενεργοποιήθηκε',
    debug_deactivated = 'Λειτουργία Debug Απενεργοποιήθηκε',

    -- ── Ειδοποιήσεις: οχήματα ───────────────────────────────
    vehicle_repaired = 'Όχημα Επισκευάστηκε',
    vehicle_repaired_desc = 'Το όχημα επισκευάστηκε με επιτυχία.',
    vehicle_deleted = 'Όχημα Διαγράφηκε',
    vehicle_deleted_desc = 'Το όχημα διαγράφηκε με επιτυχία.',
    vehicle_spawned = 'Όχημα Δημιουργήθηκε',
    vehicle_spawned_desc = 'Το όχημα %s δημιουργήθηκε με επιτυχία.',
    vehicle_plate_changed = 'Πινακίδα Άλλαξε',
    vehicle_plate_changed_desc = 'Η πινακίδα του οχήματος άλλαξε σε: %s',
    vehicle_refueled = 'Όχημα Ανεφοδιάστηκε',
    vehicle_refueled_desc = 'Το όχημα ανεφοδιάστηκε με επιτυχία.',
    vehicle_keys_given = 'Κλειδιά Παραλήφθηκαν',
    vehicle_keys_given_desc = 'Έλαβες τα κλειδιά του οχήματος με πινακίδα: %s',
    vehicle_color_changed = 'Χρώμα Οχήματος Άλλαξε',
    vehicle_color_changed_desc = 'Το χρώμα του οχήματος άλλαξε σε: %s',
    vehicle_torque_set = 'Πολλαπλασιαστής Ροπής Ορίστηκε',
    vehicle_torque_set_desc = 'Η ροπή ορίστηκε σε: %sx',
    vehicle_torque_disabled = 'Πολλαπλασιαστής Ροπής Απενεργοποιήθηκε',

    -- ── Παρακολούθηση ───────────────────────────────────────
    spectate_started = 'Παρακολούθηση',
    spectate_started_desc = 'Παρακολουθείς τον %s. Πάτα X για να σταματήσεις.',
    spectate_ended = 'Η Παρακολούθηση Τελείωσε',
    spectate_ended_desc = 'Δεν παρακολουθείς πλέον κανέναν.',
    spectate_error = 'Σφάλμα Παρακολούθησης',
    spectate_error_desc = 'Ο παίκτης-στόχος δεν βρέθηκε ή δεν υπάρχει πλέον.',

    -- ── Τηλεμεταφορά ────────────────────────────────────────
    teleport_success = 'Τηλεμεταφέρθηκες',
    teleport_success_desc = 'Τηλεμεταφέρθηκες με επιτυχία.',

    -- ── Αναζωογόνηση / θεραπεία ─────────────────────────────
    player_revived = 'Ο Παίκτης Αναζωογονήθηκε',
    player_revived_desc = 'Αναζωογόνησες με επιτυχία τον %s.',
    player_healed = 'Ο Παίκτης Θεραπεύτηκε',
    player_healed_desc = 'Θεράπευσες με επιτυχία τον %s.',
    self_revived = 'Αναζωογονήθηκες',
    self_revived_desc = 'Αναζωογόνησες τον εαυτό σου.',
    self_healed = 'Θεραπεύτηκες',
    self_healed_desc = 'Θεράπευσες τον εαυτό σου.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Το Ped Άλλαξε',
    ped_changed_desc = 'Το μοντέλο ped σου άλλαξε.',
    ped_restored = 'Το Ped Επαναφέρθηκε',
    ped_restored_desc = 'Το αρχικό σου μοντέλο ped επαναφέρθηκε.',

    skin_menu_opened = 'Το Μενού Ρούχων Άνοιξε',

    admin_menu_opened = 'Το Μενού Διαχείρισης Άνοιξε',
    admin_menu_closed = 'Το Μενού Διαχείρισης Έκλεισε',

    entity_deleted = 'Η Οντότητα Διαγράφηκε',
    entity_deleted_desc = 'Η οντότητα διαγράφηκε με επιτυχία.',

    player_frozen = 'Ο Παίκτης Πάγωσε',
    player_frozen_desc = 'Ο παίκτης %s πάγωσε.',
    player_unfrozen = 'Ο Παίκτης Ξεπάγωσε',
    player_unfrozen_desc = 'Ο παίκτης %s ξεπάγωσε.',

    -- ── Προσαρμοσμένη πινακίδα ──────────────────────────────
    dialog_license_plate = 'Προσαρμοσμένη Πινακίδα',
    dialog_license_plate_label = 'Πινακίδα',
    dialog_license_plate_placeholder = 'Πινακίδα',

    -- ── Αφαίρεση χρημάτων ───────────────────────────────────
    player_removemoney = 'Αφαίρεση Χρημάτων',
    player_removemoney_desc = 'Αφαίρεσε χρήματα από τον επιλεγμένο παίκτη',
    dialog_removemoney = 'Αφαίρεση Χρημάτων',
    removemoney_input_label = 'Ποσό',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Λογαριασμός',
    notify_removemoney_success = 'Χρήματα Αφαιρέθηκαν',
    notify_removemoney_success_desc = 'Αφαίρεσες $%s από τον %s (λογαριασμός: %s)',
    notify_removemoney_fail = 'Ανεπιτυχές',
    notify_removemoney_fail_desc = 'Δεν ήταν δυνατή η αφαίρεση χρημάτων από τον %s (ίσως ανεπαρκές υπόλοιπο).',

    -- ── Διαστάσεις / routing buckets ────────────────────────
    self_dimension = 'Όρισε τη Διάστασή Μου',
    self_dimension_desc = 'Μετακίνησε τον εαυτό σου σε ένα routing bucket (0 = κύριος κόσμος)',
    player_dimension = 'Όρισε Διάσταση',
    player_dimension_desc = 'Μετακίνησε αυτόν τον παίκτη σε ένα routing bucket',
    player_dimension_bring = 'Φέρε στη Διάστασή Μου',
    player_dimension_bring_desc = 'Τράβα αυτόν τον παίκτη στην τρέχουσα διάστασή σου',
    player_dimension_goto = 'Μπες στη Διάσταση του Παίκτη',
    player_dimension_goto_desc = 'Μετακίνησε τον εαυτό σου στη διάσταση αυτού του παίκτη',
    dialog_dimension = 'Όρισε Διάσταση',
    dimension_input_label = 'Διάσταση (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Η Διάσταση Άλλαξε',
    notify_dimension_self_desc = 'Είσαι τώρα στη διάσταση %s.',
    notify_dimension_player_desc = 'Ο %s μετακινήθηκε στη διάσταση %s.',
    notify_dimension_join_desc = 'Μπήκες στη διάσταση του %s (%s).',
    notify_dimension_fail = 'Σφάλμα Διάστασης',
    notify_dimension_fail_desc = 'Δεν ήταν δυνατή η αλλαγή διάστασης.',

    -- ── Τηλεμεταφορά μέσα στο όχημα ─────────────────────────
    player_tp_vehicle = 'Τηλεμεταφορά Μέσα στο Όχημα',
    player_tp_vehicle_desc = 'Μπες στο όχημα αυτού του παίκτη για να βοηθήσεις στην ανάκτησή του',
    notify_tp_vehicle_fail = 'Κανένα Όχημα',
    notify_tp_vehicle_fail_desc = 'Ο %s δεν είναι σε όχημα.',
    notify_tp_vehicle_success = 'Τηλεμεταφέρθηκες',
    notify_tp_vehicle_success_desc = 'Τοποθετήθηκες μέσα στο όχημα του %s.',

    -- ── Ανάκτηση οχήματος ───────────────────────────────────
    recover_car = 'Ανάκτηση / Αναποδογύρισμα Οχήματος',
    recover_car_desc = 'Ισιώνει το όχημα και το μετακινεί στον πλησιέστερο δρόμο (θάλασσα/αναποδογυρισμένο)',
    vehicle_recovered = 'Το Όχημα Ανακτήθηκε',
    vehicle_recovered_desc = 'Το όχημα ίσιωσε και τοποθετήθηκε στον πλησιέστερο δρόμο.',

    -- ── Οχήματα ιδιοκτησίας ─────────────────────────────────
    player_owned_vehicles = 'Οχήματα Ιδιοκτησίας',
    player_owned_vehicles_desc = 'Δες, πρόσθεσε ή αφαίρεσε τα οχήματα αυτού του παίκτη',
    owned_vehicles_menu = 'Οχήματα Ιδιοκτησίας (%s)',
    owned_vehicles_add = 'Προσθήκη Οχήματος',
    owned_vehicles_add_desc = 'Πρόσθεσε ένα όχημα στο γκαράζ αυτού του παίκτη',
    owned_vehicles_none = 'Κανένα Όχημα',
    owned_vehicles_none_desc = 'Αυτός ο παίκτης δεν κατέχει κανένα όχημα.',
    owned_vehicle_desc = 'Πινακίδα: %s · κάνε κλικ για αφαίρεση',
    dialog_add_vehicle = 'Προσθήκη Οχήματος',
    add_vehicle_model_label = 'Όνομα Μοντέλου',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Πινακίδα (προαιρετικό)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Αφαίρεση %s;',
    notify_owned_added = 'Όχημα Προστέθηκε',
    notify_owned_added_desc = 'Προστέθηκε %s (πινακίδα %s) στον %s.',
    notify_owned_removed = 'Όχημα Αφαιρέθηκε',
    notify_owned_removed_desc = 'Αφαιρέθηκε η πινακίδα %s από τον %s.',
    notify_owned_fail = 'Σφάλμα Βάσης Δεδομένων',
    notify_owned_fail_desc = 'Η λειτουργία στη βάση δεδομένων οχημάτων απέτυχε.',

    -- ── Μενού ped ───────────────────────────────────────────
    player_pedmenu = 'Δώσε Μενού Ped',
    player_pedmenu_desc = 'Άνοιξε ένα μενού επιλογής ped στην οθόνη αυτού του παίκτη',
    pedmenu_title = 'Μενού Ped',
    pedmenu_given = 'Το Μενού Ped Στάλθηκε',
    pedmenu_given_desc = 'Το μενού ped άνοιξε για τον %s.'
}
