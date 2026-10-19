-- ============================================================
-- POLSKI (pl)
-- ------------------------------------------------------------
-- Nakładka na configs/strings.lua. Każdy klucz, którego tu nie ma,
-- zachowuje angielski tekst, więc tłumaczenie częściowe jest bezpieczne.
--
-- Znaczniki %s muszą zostać zachowane i w TEJ SAMEJ kolejności
-- co w oryginale — wypełnia je :format() w kodzie. %% drukuje
-- dosłowny znak procenta.
--
-- Włączenie:  Config.Locale = 'pl'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['pl'] = {
    -- ── Menu główne ─────────────────────────────────────────
    main_title = 'Menu Administratora',
    self_options = 'Opcje Własne',
    self_options_desc = 'Opcje dotyczące ciebie',
    player_options_title = 'Opcje Gracza',
    player_options_desc = 'Opcje dotyczące innych graczy',
    vehicle_options = 'Opcje Pojazdu',
    vehicle_options_desc = 'Opcje dotyczące pojazdów',
    server_options = 'Opcje Serwera',
    server_options_desc = 'Opcje dotyczące serwera',
    admin_zone_options = 'Strefy Admina',
    admin_zone_options_desc = 'Zarządzaj, dodawaj i usuwaj strefy admina',
    developer_options = 'Opcje Dewelopera',
    developer_options_desc = '',

    -- ── Opcje własne ────────────────────────────────────────
    self_options_menu = 'Opcje Własne',
    self_health = 'Życie (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Ożyw',
    self_revive_desc = 'Ożyw samego siebie',
    self_heal = 'Ulecz',
    self_heal_desc = 'Ulecz samego siebie',
    self_skinmenu = 'Menu Ubrań',
    self_set_ped = 'Zmień Peda',
    self_skinmenu_desc = 'Otwórz menu ubrań lokalnie',
    self_invisible = 'Niewidzialność',
    self_godmode = 'Tryb Boga',
    self_wallhack = 'Wallhack',

    -- ── Opcje gracza ────────────────────────────────────────
    player_options_menu = 'Gracze Online %s/%s',
    player_options = 'Gracz: %s',
    player_health = 'Życie Gracza (%s%%)',
    player_freeze = 'Zamroź',
    player_freeze_desc = 'Włącz/wyłącz',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Włącz/wyłącz',
    player_spectate = 'Obserwuj',
    player_spectate_desc = 'Obserwuj działania tego gracza',
    player_playerdata = 'Dane Gracza',
    player_playerdata_desc = 'Zobacz dane gracza',
    player_revive = 'Ożyw',
    player_revive_desc = 'Ożyw gracza',
    player_heal = 'Ulecz',
    player_heal_desc = 'Ulecz gracza',
    player_skinmenu = 'Menu Ubrań',
    player_skinmenu_desc = 'Otwórz graczowi menu ubrań',
    player_money = 'Daj Pieniądze',
    player_money_desc = 'Daj pieniądze wybranemu graczowi',
    player_item = 'Daj Przedmiot',
    player_item_desc = 'Daj przedmiot wybranemu graczowi',
    player_openinv = 'Otwórz Ekwipunek',
    player_openinv_desc = 'Otwórz ekwipunek gracza',
    player_clearinv = 'Wyczyść Ekwipunek',
    player_clearinv_desc = 'Wyczyść ekwipunek gracza',
    player_teleport_to = 'Teleportuj do Gracza',
    player_teleport_to_desc = 'Teleportuj się do gracza',
    player_bring = 'Przyciągnij',
    player_bring_desc = 'Przyciągnij gracza do swojej pozycji',
    player_kick = 'Wyrzuć',
    player_kick_desc = 'Wyrzuć gracza z serwera',
    player_ban = 'Zbanuj Gracza',

    -- ── Menu pojazdu ────────────────────────────────────────
    vehicle_menu = 'Menu Pojazdu',
    spawn_car = 'Stwórz Pojazd',
    spawn_car_desc = 'Stwórz pojazd',
    repair_car = 'Napraw Pojazd',
    repair_car_desc = 'Napraw obecny lub najbliższy pojazd',
    delete_car = 'Usuń Pojazd',
    delete_car_desc = 'Usuń obecny lub najbliższy pojazd',
    number_plate = 'Zmień Tablicę',
    number_plate_desc = 'Zmień tekst obecnej tablicy rejestracyjnej',
    refuel = 'Zatankuj Pojazd',
    refuel_desc = 'Zatankuj obecny lub najbliższy pojazd',
    give_keys = 'Daj Kluczyki',
    give_keys_desc = 'Daj sobie kluczyki do obecnego pojazdu',
    doors = 'Zamknij/Otwórz Drzwi',
    doors_desc = 'Przełącza zamki najbliższego pojazdu',
    boost_car = 'Mnożnik Momentu',
    boost_car_desc = 'Zmień moment obrotowy obecnego pojazdu',
    color_change = 'Zmień Kolor Pojazdu',
    color_change_desc = 'Zmień kolor obecnego lub najbliższego pojazdu',

    -- ── Zarządzanie serwerem ────────────────────────────────
    server_management = 'Zarządzanie Serwerem',
    server_announcement = 'Ogłoszenie Serwerowe',
    server_announcement_desc = 'Wyślij globalne ogłoszenie na cały serwer',
    ban_list = 'Lista Banów',
    ban_list_desc = 'Sprawdź wszystkie aktywne bany',
    objects_list = 'Usuń Encje',
    objects_list_desc = 'Usuń pojazdy i pedy',
    objects_list_label = 'Opcje',
    weather_menu = 'Zarządzanie Pogodą',
    weather_menu_desc = 'Zarządzaj pogodą',

    -- ── Strefy admina ───────────────────────────────────────
    zones_create = 'Utwórz Strefę',
    zones_create_desc = 'Utwórz nową strefę admina',
    zones_manage = 'Zarządzaj Strefami',
    zones_manage_desc = 'Edytuj lub usuń aktywne strefy',
    zone_edit_current = 'Edytuj Obecną Strefę',
    zone_edit_current_desc = 'Zarządzaj strefą, w której się znajdujesz',
    zone_delete_current = 'Usuń Obecną Strefę',
    zone_delete_current_desc = 'Usuń strefę, w której się znajdujesz',
    zone_manage_menu = 'Edycja Strefy (%s)',
    zone_edit = 'Edytuj Strefę',
    zone_edit_desc = 'Zmodyfikuj strefę: %s',
    zone_delete = 'Usuń Strefę',
    zone_delete_desc = 'Usuń strefę: %s',
    zone_teleport = 'Teleportuj do Strefy',
    zone_teleport_desc = 'Idź do strefy: %s',

    -- ── Menu dewelopera ─────────────────────────────────────
    dev_options = 'Opcje Dewelopera',
    debug_mode = 'Tryb Debugowania',
    debug_mode_desc = 'Włącz/wyłącz tryb debugowania',
    copy_vec3 = 'Kopiuj Koordynaty Vector3',
    copy_vec3_desc = 'Kopiuje twoją obecną pozycję (vector3) do schowka',
    copy_vec4 = 'Kopiuj Koordynaty Vector4',
    copy_vec4_desc = 'Kopiuje twoją obecną pozycję (vector4) do schowka',
    copy_heading = 'Kopiuj Kierunek',
    copy_heading_desc = 'Kopiuje twój obecny kierunek do schowka',
    cant_delete = 'Nie można usunąć!',
    cant_delete_player_desc = 'Nie możesz usuwać pedów graczy!',
    cant_delete_entity_desc = 'Nie możesz usuwać domyślnych obiektów mapy!',

    -- ── Lista banów ─────────────────────────────────────────
    ban_list_menu = 'Lista Banów',
    ban_list_name = 'Nazwa: %s',
    ban_list_license = 'Licencja:',
    ban_list_by = 'Nadany przez: %s',
    ban_list_reason = 'Powód: %s',
    ban_list_length = 'Pozostało: %s godzin %s minut',
    ban_list_modify = 'Zmień Bana',
    ban_list_unban = 'Odbanuj Gracza',
    ban_list_no_data = 'Brak Banów',
    ban_list_no_data_desc = 'Nie znaleziono żadnych aktywnych banów!',

    -- ── Dane gracza ─────────────────────────────────────────
    playerdata_menu = 'Dane Gracza',
    playerdata_license_esx = 'Licencja: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Kliknij, aby skopiować pełną licencję',
    playerdata_igname = 'Imię: %s',
    playerdata_igname_desc = 'Pełne imię gracza w grze',
    playerdata_steam = 'Nazwa Steam: %s',
    playerdata_steam_desc = 'Pełna nazwa Steam gracza',
    playerdata_gender = 'Płeć: %s',
    playerdata_gender_desc = 'Płeć gracza',
    playerdata_cash = 'Gotówka: %s',
    playerdata_cash_desc = 'Stan gotówki gracza',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Stan konta bankowego gracza',
    playerdata_blackmoney = 'Brudne Pieniądze: %s',
    playerdata_blackmoney_desc = 'Stan brudnych pieniędzy gracza',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Naciśnij [E], aby usunąć encję  \nHash: %s  \nKoordynaty: vec3(%s, %s, %s)  \nKierunek: %s  \nWłaściciel: [%s] - %s',
    debug_textui_noname = 'Naciśnij [E], aby usunąć encję\n  Hash: %s\n  Koordynaty: vec3(%s, %s, %s)\n  Kierunek: %s\n  Właściciel: NIEZNANY',

    textui_invisible = 'Tryb Niewidzialności - Aktywny',
    textui_godmode = 'Tryb Boga - Aktywny',
    textui_wallhack = 'Wallhack - Aktywny',
    textui_noclip_activated = 'No Clip - Aktywny',
    textui_torque = 'Mnożnik Momentu - %s',

    -- ── Ogłoszenia ──────────────────────────────────────────
    dialog_announce = 'Ogłoszenie',
    dialog_announce_label = 'Wiadomość',
    dialog_announce_select = 'Wszyscy',
    dialog_announce_everyone = 'Wszyscy',
    dialog_announce_placeholder = 'Ważna wiadomość tutaj. . .',

    -- ── Odbanowanie ─────────────────────────────────────────
    dialog_unban = 'Jesteś pewien?',
    dialog_unban_content = 'Czy na pewno chcesz odbanować %s?',

    -- ── Usuwanie encji ──────────────────────────────────────
    dialog_objects = 'Wybierz opcję',
    dialog_clear_objects = 'Usuń WSZYSTKIE obiekty',
    dialog_clear_cars = 'Usuń WSZYSTKIE auta (bez kierowcy)',
    dialog_clear_peds = 'Usuń WSZYSTKIE pedy',

    -- ── Dawanie pieniędzy ───────────────────────────────────
    dialog_givemoney = 'Daj Pieniądze',
    givemoney_input_label = 'Kwota',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Konto',
    givemoney_select_option1 = 'Gotówka',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Brudne Pieniądze',

    -- ── Dawanie przedmiotu ──────────────────────────────────
    dialog_giveitem = 'Daj Przedmiot',
    giveitem_input_label = 'Nazwa Przedmiotu',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Ilość',
    giveitem_amount_input_placeholder = '3',

    -- ── Tworzenie pojazdu ───────────────────────────────────
    dialog_spawn_a_car = 'Stwórz Pojazd',
    dialog_car_model = 'Nazwa Modelu',
    dialog_car_model_holder = 'Np: 20charger',
    dialog_car_plate = 'Tablica (opcjonalnie)',
    dialog_car_plate_holder = 'Np: W4S4B1',
    dialog_car_color_primary = 'Kolor Podstawowy (opcjonalnie)',
    dialog_car_color_second = 'Kolor Dodatkowy (opcjonalnie)',
    dialog_car_maxed = 'Maksymalny Tuning (opcjonalnie)',

    -- ── Wyrzucenie ──────────────────────────────────────────
    dialog_kick = 'Wyrzuć %s',
    dialog_kick_reason = 'Powód',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Zostałeś wyrzucony z serwera!',

    -- ── Ban ─────────────────────────────────────────────────
    dialog_ban = 'Zbanuj %s',
    dialog_ban_reason = 'Powód',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Zostałeś zbanowany na tym serwerze!',

    -- ── Tworzenie strefy ────────────────────────────────────
    dialog_zone_create = 'Tworzenie Strefy',
    dialog_zone_name = 'Nazwa',
    dialog_zone_name_desc = 'Nazwa strefy / blipa',
    dialog_zone_name_holder = 'Strefa Admina',
    dialog_zone_text = 'Wyświetlany Tekst',
    dialog_zone_text_desc = 'Tekst wyświetlany graczom wewnątrz strefy',
    dialog_zone_text_holder = 'STREFA ADMINA - AKTYWNA',
    dialog_zone_size = 'Rozmiar',
    dialog_zone_speed = 'Limit Prędkości',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID Blipa',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Koloru',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Migający Blip',
    dialog_zone_disarm = 'Rozbrój',
    dialog_zone_revive = 'Ożyw',
    dialog_zone_invincible = 'Nieśmiertelność',
    dialog_zone_edit = 'Edycja „%s"',
    dialog_zone_delete_confirm = 'Jesteś pewien?',
    dialog_zone_delete_confirm_desc = 'Czy na pewno chcesz usunąć strefę: %s',

    -- ── Powiadomienia: pieniądze ────────────────────────────
    notify_givemoney_success = 'Pieniądze Przyznane',
    notify_givemoney_success_desc = 'Przelałeś %s $%s na konto: %s',
    notify_givemoney_fail = 'Niepowodzenie',
    notify_givemoney_fail_desc = 'Próbowałeś przelać %s, ale coś poszło nie tak! Spróbuj ponownie.',

    -- ── Powiadomienia: przedmioty ───────────────────────────
    notify_giveitem_success = 'Przedmiot Przyznany',
    notify_giveitem_success_desc = 'Przekazałeś %s. Przedmiot: %s Ilość: %s',
    notify_giveitem_fail = 'Niepowodzenie',
    notify_giveitem_fail_desc = 'Próbowałeś przekazać %s, ale coś poszło nie tak! Spróbuj ponownie.',

    -- ── Powiadomienia: wyrzucenie / ban ─────────────────────
    notify_kicked_success = 'Wyrzucenie Udane',
    notify_kicked_success_desc = 'Pomyślnie wyrzuciłeś %s',
    notify_banned_success = 'Ban Udany',
    notify_banned_success_desc = 'Pomyślnie zbanowałeś %s',

    -- ── Powiadomienia: ekwipunek ────────────────────────────
    notify_clearedinv = 'Ekwipunek Wyczyszczony',
    notify_clearedinv_desc = 'Pomyślnie wyczyściłeś ekwipunek gracza %s',

    -- ── Powiadomienia: niepoprawne ID ───────────────────────
    notify_invalidid = 'Niepoprawne ID',
    notify_invalidid_desc = 'Wprowadzone ID jest niepoprawne, spróbuj ponownie.',

    -- ── Powiadomienia: czyszczenie ──────────────────────────
    notify_deleted_car = 'Auta Usunięte',
    notify_deleted_car_desc = 'Pomyślnie usunąłeś wszystkie auta bez kierowcy.',
    notify_deleted_ped = 'Pedy Usunięte',
    notify_deleted_ped_desc = 'Pomyślnie usunąłeś wszystkie pedy na mapie',
    notify_deleted_objects = 'Obiekty Usunięte',
    notify_deleted_objects_desc = 'Pomyślnie usunąłeś wszystkie obiekty na mapie',

    -- ── Powiadomienia: pogoda ───────────────────────────────
    notify_weather = 'Pogoda Zmieniona',
    notify_weather_desc = 'Pogoda zmieniona na: %s',

    -- ── Powiadomienia: kopiowanie koordynatów ───────────────
    notify_copied = 'Skopiowano',
    notify_copied_vec3 = 'Pomyślnie skopiowano vector3 do schowka!',
    notify_copied_vec4 = 'Pomyślnie skopiowano vector4 do schowka!',
    notify_copied_headin = 'Pomyślnie skopiowano kierunek do schowka!',

    -- ── Powiadomienia: drzwi ────────────────────────────────
    notify_locked_doors = 'Zamknięto',
    notify_locked_doors_desc = 'Pomyślnie zamknięto drzwi pojazdu.',
    notify_unlocked_doors = 'Otwarto',
    notify_unlocked_doors_desc = 'Pomyślnie otwarto drzwi pojazdu.',

    -- ── Powiadomienia: strefy admina ────────────────────────
    notify_zone_deleted = 'Strefa Usunięta',
    notify_zone_deleted_desc = 'Pomyślnie usunąłeś strefę: %s.',
    notify_zone_not_deleted_desc = 'Wystąpił błąd podczas usuwania strefy: %s.',
    notify_zone_edited = 'Strefa Zmieniona',
    notify_zone_edited_desc = 'Pomyślnie zmodyfikowałeś strefę: %s.',
    notify_zone_not_edited_desc = 'Wystąpił błąd podczas modyfikowania strefy: %s.',
    notify_zone_action_cancelled = 'Akcja Anulowana',
    notify_zone_delete_cancel = 'Anulowałeś usuwanie strefy: %s',
    notify_zone_no_weapons = 'Broń Zabroniona',
    notify_zone_no_weapons_desc = 'Nie masz uprawnień do używania broni w tej strefie.',
    notify_zones_not_found = 'Brak Stref',
    notify_zones_not_found_desc = 'Obecnie nie ma żadnych aktywnych stref do zarządzania.',
    notify_zones_teleport = 'Teleportowano',
    notify_zones_teleport_desc = 'Pomyślnie teleportowałeś się do strefy: %s.',

    -- ── Powiadomienia: odbanowanie ──────────────────────────
    successfully_unbanned = 'Ban Cofnięty',
    successfully_unbanned_desc = 'Pomyślnie odbanowałeś: %s.',
    unsuccessful_unban = 'Coś poszło nie tak przy odbanowywaniu: %s.',

    -- ── Łączenie (deferrals) ────────────────────────────────
    deferral_welcome = '[%s] Cześć %s, sprawdzam bany. . .',
    deferral_banned = 'Jesteś zbanowany na tym serwerze. Powód: „%s" (Pozostało: %s godzin %s minut).',
    deferral_banned_perm = 'Jesteś zbanowany na tym serwerze. Powód: „%s" (Pozostało: Permanentnie).',

    -- ── Błędy ───────────────────────────────────────────────
    notify_error = 'Błąd',
    notify_disabled_keys = 'Nie skonfigurowano żadnego skryptu kluczyków. Skontaktuj się z deweloperem serwera.',
    notify_no_appearance = 'Nie wykryto skryptu ubrań / wyglądu. Skontaktuj się z deweloperem serwera.',
    notify_no_vehicle = 'Nie znaleziono pojazdu!',
    notify_invalid_entry = 'Niepoprawny wpis!',

    -- ── Skrót klawiszowy ────────────────────────────────────
    keymapping_desc = 'Otwórz Menu Administratora (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Włączony',
    noclip_deactivated = 'NoClip Wyłączony',

    -- ── Niewidzialność ──────────────────────────────────────
    invisibility_activated = 'Tryb Niewidzialności Włączony',
    invisibility_deactivated = 'Tryb Niewidzialności Wyłączony',

    -- ── Tryb Boga ───────────────────────────────────────────
    godmode_activated = 'Tryb Boga Włączony',
    godmode_deactivated = 'Tryb Boga Wyłączony',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Włączony',
    wallhack_deactivated = 'Wallhack Wyłączony',

    -- ── Tryb debugowania ────────────────────────────────────
    debug_activated = 'Tryb Debugowania Włączony',
    debug_deactivated = 'Tryb Debugowania Wyłączony',

    -- ── Powiadomienia: pojazdy ──────────────────────────────
    vehicle_repaired = 'Pojazd Naprawiony',
    vehicle_repaired_desc = 'Pojazd został pomyślnie naprawiony.',
    vehicle_deleted = 'Pojazd Usunięty',
    vehicle_deleted_desc = 'Pojazd został pomyślnie usunięty.',
    vehicle_spawned = 'Pojazd Utworzony',
    vehicle_spawned_desc = 'Pojazd %s został pomyślnie utworzony.',
    vehicle_plate_changed = 'Tablica Zmieniona',
    vehicle_plate_changed_desc = 'Tablica rejestracyjna zmieniona na: %s',
    vehicle_refueled = 'Pojazd Zatankowany',
    vehicle_refueled_desc = 'Pojazd został pomyślnie zatankowany.',
    vehicle_keys_given = 'Kluczyki Otrzymane',
    vehicle_keys_given_desc = 'Otrzymałeś kluczyki do pojazdu o tablicy: %s',
    vehicle_color_changed = 'Kolor Pojazdu Zmieniony',
    vehicle_color_changed_desc = 'Kolor pojazdu zmieniony na: %s',
    vehicle_torque_set = 'Mnożnik Momentu Ustawiony',
    vehicle_torque_set_desc = 'Moment ustawiony na: %sx',
    vehicle_torque_disabled = 'Mnożnik Momentu Wyłączony',

    -- ── Obserwowanie ────────────────────────────────────────
    spectate_started = 'Obserwowanie',
    spectate_started_desc = 'Obserwujesz %s. Naciśnij X, aby zakończyć.',
    spectate_ended = 'Obserwowanie Zakończone',
    spectate_ended_desc = 'Nie obserwujesz już nikogo.',
    spectate_error = 'Błąd Obserwowania',
    spectate_error_desc = 'Nie znaleziono gracza lub już nie istnieje.',

    -- ── Teleportacja ────────────────────────────────────────
    teleport_success = 'Teleportowano',
    teleport_success_desc = 'Zostałeś pomyślnie teleportowany.',

    -- ── Ożywianie / leczenie ────────────────────────────────
    player_revived = 'Gracz Ożywiony',
    player_revived_desc = 'Pomyślnie ożywiłeś %s.',
    player_healed = 'Gracz Uleczony',
    player_healed_desc = 'Pomyślnie uleczyłeś %s.',
    self_revived = 'Ożywiony',
    self_revived_desc = 'Ożywiłeś samego siebie.',
    self_healed = 'Uleczony',
    self_healed_desc = 'Uleczyłeś samego siebie.',

    -- ── Pedy ────────────────────────────────────────────────
    ped_changed = 'Ped Zmieniony',
    ped_changed_desc = 'Twój model peda został zmieniony.',
    ped_restored = 'Ped Przywrócony',
    ped_restored_desc = 'Twój oryginalny model peda został przywrócony.',

    skin_menu_opened = 'Menu Ubrań Otwarte',

    admin_menu_opened = 'Menu Admina Otwarte',
    admin_menu_closed = 'Menu Admina Zamknięte',

    entity_deleted = 'Encja Usunięta',
    entity_deleted_desc = 'Encja została pomyślnie usunięta.',

    player_frozen = 'Gracz Zamrożony',
    player_frozen_desc = 'Gracz %s został zamrożony.',
    player_unfrozen = 'Gracz Odmrożony',
    player_unfrozen_desc = 'Gracz %s został odmrożony.',

    -- ── Własna tablica ──────────────────────────────────────
    dialog_license_plate = 'Własna Tablica',
    dialog_license_plate_label = 'Tablica',
    dialog_license_plate_placeholder = 'Tablica',

    -- ── Zabieranie pieniędzy ────────────────────────────────
    player_removemoney = 'Zabierz Pieniądze',
    player_removemoney_desc = 'Zabierz pieniądze wybranemu graczowi',
    dialog_removemoney = 'Zabierz Pieniądze',
    removemoney_input_label = 'Kwota',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Konto',
    notify_removemoney_success = 'Pieniądze Zabrane',
    notify_removemoney_success_desc = 'Zabrałeś $%s graczowi %s (konto: %s)',
    notify_removemoney_fail = 'Niepowodzenie',
    notify_removemoney_fail_desc = 'Nie udało się zabrać pieniędzy graczowi %s (może brak środków).',

    -- ── Wymiary / routing buckets ───────────────────────────
    self_dimension = 'Ustaw Mój Wymiar',
    self_dimension_desc = 'Przenieś się do routing bucketa (0 = główny świat)',
    player_dimension = 'Ustaw Wymiar',
    player_dimension_desc = 'Przenieś tego gracza do routing bucketa',
    player_dimension_bring = 'Przyciągnij do Mojego Wymiaru',
    player_dimension_bring_desc = 'Przeciągnij tego gracza do twojego obecnego wymiaru',
    player_dimension_goto = 'Dołącz do Wymiaru Gracza',
    player_dimension_goto_desc = 'Przenieś się do wymiaru tego gracza',
    dialog_dimension = 'Ustaw Wymiar',
    dimension_input_label = 'Wymiar (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Wymiar Zmieniony',
    notify_dimension_self_desc = 'Jesteś teraz w wymiarze %s.',
    notify_dimension_player_desc = '%s został przeniesiony do wymiaru %s.',
    notify_dimension_join_desc = 'Dołączyłeś do wymiaru gracza %s (%s).',
    notify_dimension_fail = 'Błąd Wymiaru',
    notify_dimension_fail_desc = 'Nie udało się zmienić wymiaru.',

    -- ── Teleportacja do pojazdu ─────────────────────────────
    player_tp_vehicle = 'Teleportuj do Pojazdu',
    player_tp_vehicle_desc = 'Wskocz do pojazdu tego gracza, aby pomóc go odzyskać',
    notify_tp_vehicle_fail = 'Brak Pojazdu',
    notify_tp_vehicle_fail_desc = '%s nie jest w pojeździe.',
    notify_tp_vehicle_success = 'Teleportowano',
    notify_tp_vehicle_success_desc = 'Zostałeś przeniesiony do pojazdu gracza %s.',

    -- ── Odzyskiwanie pojazdu ────────────────────────────────
    recover_car = 'Odzyskaj / Obróć Pojazd',
    recover_car_desc = 'Postaw na koła i przenieś na najbliższą drogę (morze/dachowanie)',
    vehicle_recovered = 'Pojazd Odzyskany',
    vehicle_recovered_desc = 'Pojazd został postawiony na koła i przeniesiony na najbliższą drogę.',

    -- ── Pojazdy gracza ──────────────────────────────────────
    player_owned_vehicles = 'Posiadane Pojazdy',
    player_owned_vehicles_desc = 'Zobacz, dodaj lub usuń auta tego gracza',
    owned_vehicles_menu = 'Posiadane Pojazdy (%s)',
    owned_vehicles_add = 'Dodaj Pojazd',
    owned_vehicles_add_desc = 'Dodaj pojazd do garażu tego gracza',
    owned_vehicles_none = 'Brak Pojazdów',
    owned_vehicles_none_desc = 'Ten gracz nie posiada żadnych pojazdów.',
    owned_vehicle_desc = 'Tablica: %s · kliknij, aby usunąć',
    dialog_add_vehicle = 'Dodaj Pojazd',
    add_vehicle_model_label = 'Nazwa Modelu',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Tablica (opcjonalnie)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Usunąć %s?',
    notify_owned_added = 'Pojazd Dodany',
    notify_owned_added_desc = 'Dodano %s (tablica %s) do %s.',
    notify_owned_removed = 'Pojazd Usunięty',
    notify_owned_removed_desc = 'Usunięto tablicę %s z %s.',
    notify_owned_fail = 'Błąd Bazy Danych',
    notify_owned_fail_desc = 'Operacja na bazie danych pojazdów nie powiodła się.',

    -- ── Menu pedów ──────────────────────────────────────────
    player_pedmenu = 'Daj Menu Pedów',
    player_pedmenu_desc = 'Otwórz menu wyboru peda na ekranie tego gracza',
    pedmenu_title = 'Menu Pedów',
    pedmenu_given = 'Menu Pedów Wysłane',
    pedmenu_given_desc = 'Menu pedów otwarte dla %s.'
}
