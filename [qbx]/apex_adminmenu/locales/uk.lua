-- ============================================================
-- УКРАЇНСЬКА (uk)
-- ------------------------------------------------------------
-- Накладка поверх configs/strings.lua. Будь-який ключ, якого
-- тут немає, зберігає англійський текст, тож частковий переклад
-- є безпечним.
--
-- Підстановки %s треба зберігати і в ТОМУ САМОМУ порядку, що і
-- в оригіналі: їх заповнює :format() у коді. %% виводить
-- буквальний знак відсотка.
--
-- Увімкнення:  Config.Locale = 'uk'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['uk'] = {
    -- ── Головне меню ────────────────────────────────────────
    main_title = 'Адмін-меню',
    self_options = 'Власні Налаштування',
    self_options_desc = 'Налаштування, що стосуються тебе',
    player_options_title = 'Налаштування Гравця',
    player_options_desc = 'Налаштування, що стосуються інших гравців',
    vehicle_options = 'Налаштування Транспорту',
    vehicle_options_desc = 'Налаштування, що стосуються транспорту',
    server_options = 'Налаштування Сервера',
    server_options_desc = 'Налаштування, що стосуються сервера',
    admin_zone_options = 'Адмін-зони',
    admin_zone_options_desc = 'Керувати, додавати та видаляти адмін-зони',
    developer_options = 'Налаштування Розробника',
    developer_options_desc = '',

    -- ── Власні налаштування ─────────────────────────────────
    self_options_menu = 'Власні Налаштування',
    self_health = 'Здоров\'я (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Воскресити',
    self_revive_desc = 'Воскресити себе',
    self_heal = 'Вилікувати',
    self_heal_desc = 'Вилікувати себе',
    self_skinmenu = 'Меню Одягу',
    self_set_ped = 'Змінити Педа',
    self_skinmenu_desc = 'Відкрити меню одягу локально',
    self_invisible = 'Невидимість',
    self_godmode = 'Режим Бога',
    self_wallhack = 'Wallhack',

    -- ── Налаштування гравця ─────────────────────────────────
    player_options_menu = 'Гравців Онлайн %s/%s',
    player_options = 'Гравець: %s',
    player_health = 'Здоров\'я Гравця (%s%%)',
    player_freeze = 'Заморозити',
    player_freeze_desc = 'Увімк./вимк.',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Увімк./вимк.',
    player_spectate = 'Спостерігати',
    player_spectate_desc = 'Стежити за діями цього гравця',
    player_playerdata = 'Дані Гравця',
    player_playerdata_desc = 'Переглянути дані гравця',
    player_revive = 'Воскресити',
    player_revive_desc = 'Воскресити гравця',
    player_heal = 'Вилікувати',
    player_heal_desc = 'Вилікувати гравця',
    player_skinmenu = 'Меню Одягу',
    player_skinmenu_desc = 'Відкрити гравцеві меню одягу',
    player_money = 'Видати Гроші',
    player_money_desc = 'Видати гроші обраному гравцю',
    player_item = 'Видати Предмет',
    player_item_desc = 'Видати предмет обраному гравцю',
    player_openinv = 'Відкрити Інвентар',
    player_openinv_desc = 'Відкрити інвентар гравця',
    player_clearinv = 'Очистити Інвентар',
    player_clearinv_desc = 'Очистити інвентар гравця',
    player_teleport_to = 'Телепорт до Гравця',
    player_teleport_to_desc = 'Телепортуватися до гравця',
    player_bring = 'Притягнути',
    player_bring_desc = 'Притягнути гравця до своєї позиції',
    player_kick = 'Кікнути',
    player_kick_desc = 'Вигнати гравця з сервера',
    player_ban = 'Забанити Гравця',

    -- ── Меню транспорту ─────────────────────────────────────
    vehicle_menu = 'Меню Транспорту',
    spawn_car = 'Заспавнити Транспорт',
    spawn_car_desc = 'Заспавнити транспорт',
    repair_car = 'Полагодити Транспорт',
    repair_car_desc = 'Полагодити поточний або найближчий транспорт',
    delete_car = 'Видалити Транспорт',
    delete_car_desc = 'Видалити поточний або найближчий транспорт',
    number_plate = 'Змінити Номер',
    number_plate_desc = 'Змінити текст поточного номерного знака',
    refuel = 'Заправити Транспорт',
    refuel_desc = 'Заправити поточний або найближчий транспорт',
    give_keys = 'Видати Ключі',
    give_keys_desc = 'Видати собі ключі від поточного транспорту',
    doors = 'Замкнути/Відімкнути Двері',
    doors_desc = 'Перемикає замки найближчого транспорту',
    boost_car = 'Множник Крутного Моменту',
    boost_car_desc = 'Змінити крутний момент поточного транспорту',
    color_change = 'Змінити Колір Транспорту',
    color_change_desc = 'Змінити колір поточного або найближчого транспорту',

    -- ── Керування сервером ──────────────────────────────────
    server_management = 'Керування Сервером',
    server_announcement = 'Оголошення Сервера',
    server_announcement_desc = 'Надіслати глобальне оголошення всьому серверу',
    ban_list = 'Список Банів',
    ban_list_desc = 'Переглянути всі активні бани',
    objects_list = 'Видалити Сутності',
    objects_list_desc = 'Видалити транспорт і педів',
    objects_list_label = 'Опції',
    weather_menu = 'Керування Погодою',
    weather_menu_desc = 'Керувати погодою',

    -- ── Адмін-зони ──────────────────────────────────────────
    zones_create = 'Створити Зону',
    zones_create_desc = 'Створити нову адмін-зону',
    zones_manage = 'Керувати Зонами',
    zones_manage_desc = 'Редагувати або видалити активні зони',
    zone_edit_current = 'Редагувати Поточну Зону',
    zone_edit_current_desc = 'Керувати зоною, в якій ти перебуваєш',
    zone_delete_current = 'Видалити Поточну Зону',
    zone_delete_current_desc = 'Видалити зону, в якій ти перебуваєш',
    zone_manage_menu = 'Редагування Зони (%s)',
    zone_edit = 'Редагувати Зону',
    zone_edit_desc = 'Змінити зону: %s',
    zone_delete = 'Видалити Зону',
    zone_delete_desc = 'Видалити зону: %s',
    zone_teleport = 'Телепорт до Зони',
    zone_teleport_desc = 'Перейти до зони: %s',

    -- ── Меню розробника ─────────────────────────────────────
    dev_options = 'Налаштування Розробника',
    debug_mode = 'Режим Налагодження',
    debug_mode_desc = 'Увімкнути/вимкнути режим налагодження',
    copy_vec3 = 'Скопіювати Координати Vector3',
    copy_vec3_desc = 'Копіює твою поточну позицію (vector3) у буфер обміну',
    copy_vec4 = 'Скопіювати Координати Vector4',
    copy_vec4_desc = 'Копіює твою поточну позицію (vector4) у буфер обміну',
    copy_heading = 'Скопіювати Напрямок',
    copy_heading_desc = 'Копіює твій поточний напрямок у буфер обміну',
    cant_delete = 'Неможливо видалити!',
    cant_delete_player_desc = 'Не можна видаляти педів гравців!',
    cant_delete_entity_desc = 'Не можна видаляти стандартні об\'єкти карти!',

    -- ── Список банів ────────────────────────────────────────
    ban_list_menu = 'Список Банів',
    ban_list_name = 'Ім\'я: %s',
    ban_list_license = 'Ліцензія:',
    ban_list_by = 'Видав: %s',
    ban_list_reason = 'Причина: %s',
    ban_list_length = 'Залишилось: %s годин %s хвилин',
    ban_list_modify = 'Змінити Бан',
    ban_list_unban = 'Розбанити Гравця',
    ban_list_no_data = 'Банів Немає',
    ban_list_no_data_desc = 'Активних банів не знайдено!',

    -- ── Дані гравця ─────────────────────────────────────────
    playerdata_menu = 'Дані Гравця',
    playerdata_license_esx = 'Ліцензія: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Натисни, щоб скопіювати повну ліцензію',
    playerdata_igname = 'Ім\'я: %s',
    playerdata_igname_desc = 'Повне ігрове ім\'я гравця',
    playerdata_steam = 'Ім\'я у Steam: %s',
    playerdata_steam_desc = 'Повне ім\'я гравця у Steam',
    playerdata_gender = 'Стать: %s',
    playerdata_gender_desc = 'Стать гравця',
    playerdata_cash = 'Готівка: %s',
    playerdata_cash_desc = 'Баланс готівки гравця',
    playerdata_bank = 'Банк: %s',
    playerdata_bank_desc = 'Банківський баланс гравця',
    playerdata_blackmoney = 'Брудні Гроші: %s',
    playerdata_blackmoney_desc = 'Баланс брудних грошей гравця',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Натисни [E], щоб видалити сутність  \nHash: %s  \nКоординати: vec3(%s, %s, %s)  \nНапрямок: %s  \nВласник: [%s] - %s',
    debug_textui_noname = 'Натисни [E], щоб видалити сутність\n  Hash: %s\n  Координати: vec3(%s, %s, %s)\n  Напрямок: %s\n  Власник: НЕВІДОМИЙ',

    textui_invisible = 'Режим Невидимості - Активний',
    textui_godmode = 'Режим Бога - Активний',
    textui_wallhack = 'Wallhack - Активний',
    textui_noclip_activated = 'No Clip - Активний',
    textui_torque = 'Множник Моменту - %s',

    -- ── Оголошення ──────────────────────────────────────────
    dialog_announce = 'Оголошення',
    dialog_announce_label = 'Повідомлення',
    dialog_announce_select = 'Усі',
    dialog_announce_everyone = 'Усі',
    dialog_announce_placeholder = 'Важливе повідомлення сюди. . .',

    -- ── Розбан ──────────────────────────────────────────────
    dialog_unban = 'Ти впевнений?',
    dialog_unban_content = 'Справді розбанити %s?',

    -- ── Видалення сутностей ─────────────────────────────────
    dialog_objects = 'Обери опцію',
    dialog_clear_objects = 'Видалити ВСІ об\'єкти',
    dialog_clear_cars = 'Видалити ВСІ авто (без водія)',
    dialog_clear_peds = 'Видалити ВСІХ педів',

    -- ── Видача грошей ───────────────────────────────────────
    dialog_givemoney = 'Видати Гроші',
    givemoney_input_label = 'Сума',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Рахунок',
    givemoney_select_option1 = 'Готівка',
    givemoney_select_option2 = 'Банк',
    givemoney_select_option3 = 'Брудні Гроші',

    -- ── Видача предмета ─────────────────────────────────────
    dialog_giveitem = 'Видати Предмет',
    giveitem_input_label = 'Назва Предмета',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Кількість',
    giveitem_amount_input_placeholder = '3',

    -- ── Спавн транспорту ────────────────────────────────────
    dialog_spawn_a_car = 'Заспавнити Транспорт',
    dialog_car_model = 'Назва Моделі',
    dialog_car_model_holder = 'Напр: 20charger',
    dialog_car_plate = 'Номер (необов\'язково)',
    dialog_car_plate_holder = 'Напр: W4S4B1',
    dialog_car_color_primary = 'Основний Колір (необов\'язково)',
    dialog_car_color_second = 'Додатковий Колір (необов\'язково)',
    dialog_car_maxed = 'Максимальний Тюнінг (необов\'язково)',

    -- ── Кік ─────────────────────────────────────────────────
    dialog_kick = 'Кікнути %s',
    dialog_kick_reason = 'Причина',
    dialog_kick_placeholder = 'Чітер',
    kicked_reason_replace = 'Тебе вигнали з сервера!',

    -- ── Бан ─────────────────────────────────────────────────
    dialog_ban = 'Забанити %s',
    dialog_ban_reason = 'Причина',
    dialog_ban_placeholder = 'Чітер',
    ban_reason_replace = 'Тебе забанено на цьому сервері!',

    -- ── Створення зони ──────────────────────────────────────
    dialog_zone_create = 'Створення Зони',
    dialog_zone_name = 'Назва',
    dialog_zone_name_desc = 'Назва зони / блипа',
    dialog_zone_name_holder = 'Адмін-зона',
    dialog_zone_text = 'Відображуваний Текст',
    dialog_zone_text_desc = 'Текст, який бачать гравці всередині зони',
    dialog_zone_text_holder = 'АДМІН-ЗОНА - АКТИВНА',
    dialog_zone_size = 'Розмір',
    dialog_zone_speed = 'Обмеження Швидкості',
    mph = 'MPH',
    kmh = 'КМ/ГОД',
    dialog_zone_blip_id = 'ID Блипа',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Кольору',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Мигаючий Блип',
    dialog_zone_disarm = 'Роззброїти',
    dialog_zone_revive = 'Воскресіння',
    dialog_zone_invincible = 'Безсмертя',
    dialog_zone_edit = 'Редагування «%s»',
    dialog_zone_delete_confirm = 'Ти впевнений?',
    dialog_zone_delete_confirm_desc = 'Справді видалити зону: %s',

    -- ── Сповіщення: гроші ───────────────────────────────────
    notify_givemoney_success = 'Гроші Видано',
    notify_givemoney_success_desc = 'Ти нарахував %s $%s на рахунок: %s',
    notify_givemoney_fail = 'Невдало',
    notify_givemoney_fail_desc = 'Ти спробував нарахувати %s, але щось пішло не так! Спробуй ще раз.',

    -- ── Сповіщення: предмети ────────────────────────────────
    notify_giveitem_success = 'Предмет Видано',
    notify_giveitem_success_desc = 'Ти видав %s. Предмет: %s Кількість: %s',
    notify_giveitem_fail = 'Помилка',
    notify_giveitem_fail_desc = 'Ти спробував видати %s, але щось пішло не так! Спробуй ще раз.',

    -- ── Сповіщення: кік / бан ───────────────────────────────
    notify_kicked_success = 'Кік Успішний',
    notify_kicked_success_desc = 'Ти успішно кікнув %s',
    notify_banned_success = 'Бан Успішний',
    notify_banned_success_desc = 'Ти успішно забанив %s',

    -- ── Сповіщення: інвентар ────────────────────────────────
    notify_clearedinv = 'Інвентар Очищено',
    notify_clearedinv_desc = 'Ти успішно очистив інвентар гравця %s',

    -- ── Сповіщення: невірний ID ─────────────────────────────
    notify_invalidid = 'Невірний ID',
    notify_invalidid_desc = 'Введений ID невірний, спробуй ще раз.',

    -- ── Сповіщення: прибирання ──────────────────────────────
    notify_deleted_car = 'Авто Видалено',
    notify_deleted_car_desc = 'Ти успішно видалив усі авто без водія.',
    notify_deleted_ped = 'Педів Видалено',
    notify_deleted_ped_desc = 'Ти успішно видалив усіх педів на карті',
    notify_deleted_objects = 'Об\'єкти Видалено',
    notify_deleted_objects_desc = 'Ти успішно видалив усі об\'єкти на карті',

    -- ── Сповіщення: погода ──────────────────────────────────
    notify_weather = 'Погоду Змінено',
    notify_weather_desc = 'Погоду змінено на: %s',

    -- ── Сповіщення: копіювання координат ────────────────────
    notify_copied = 'Скопійовано',
    notify_copied_vec3 = 'Vector3 успішно скопійовано в буфер обміну!',
    notify_copied_vec4 = 'Vector4 успішно скопійовано в буфер обміну!',
    notify_copied_headin = 'Напрямок успішно скопійовано в буфер обміну!',

    -- ── Сповіщення: двері ───────────────────────────────────
    notify_locked_doors = 'Замкнено',
    notify_locked_doors_desc = 'Двері транспорту успішно замкнено.',
    notify_unlocked_doors = 'Відімкнено',
    notify_unlocked_doors_desc = 'Двері транспорту успішно відімкнено.',

    -- ── Сповіщення: адмін-зони ──────────────────────────────
    notify_zone_deleted = 'Зону Видалено',
    notify_zone_deleted_desc = 'Ти успішно видалив зону: %s.',
    notify_zone_not_deleted_desc = 'Сталася помилка під час видалення зони: %s.',
    notify_zone_edited = 'Зону Змінено',
    notify_zone_edited_desc = 'Ти успішно змінив зону: %s.',
    notify_zone_not_edited_desc = 'Сталася помилка під час зміни зони: %s.',
    notify_zone_action_cancelled = 'Дію Скасовано',
    notify_zone_delete_cancel = 'Ти скасував видалення зони: %s',
    notify_zone_no_weapons = 'Зброю Заборонено',
    notify_zone_no_weapons_desc = 'Тобі не дозволено використовувати зброю в цій зоні.',
    notify_zones_not_found = 'Зон Не Знайдено',
    notify_zones_not_found_desc = 'Наразі немає активних зон для керування.',
    notify_zones_teleport = 'Телепортовано',
    notify_zones_teleport_desc = 'Ти успішно телепортувався до зони: %s.',

    -- ── Сповіщення: розбан ──────────────────────────────────
    successfully_unbanned = 'Бан Знято',
    successfully_unbanned_desc = 'Ти успішно розбанив: %s.',
    unsuccessful_unban = 'Щось пішло не так під час розбану: %s.',

    -- ── Підключення (deferrals) ─────────────────────────────
    deferral_welcome = '[%s] Привіт, %s, перевіряємо бани. . .',
    deferral_banned = 'Тебе забанено на цьому сервері. Причина: «%s» (Залишилось: %s годин %s хвилин).',
    deferral_banned_perm = 'Тебе забанено на цьому сервері. Причина: «%s» (Залишилось: Назавжди).',

    -- ── Помилки ─────────────────────────────────────────────
    notify_error = 'Помилка',
    notify_disabled_keys = 'Не налаштовано жодного скрипта ключів від транспорту. Звернись до розробника сервера.',
    notify_no_appearance = 'Скрипт одягу / зовнішності не виявлено. Звернись до розробника сервера.',
    notify_no_vehicle = 'Транспорт не знайдено!',
    notify_invalid_entry = 'Невірне введення!',

    -- ── Гаряча клавіша ──────────────────────────────────────
    keymapping_desc = 'Відкрити Адмін-меню (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Увімкнено',
    noclip_deactivated = 'NoClip Вимкнено',

    -- ── Невидимість ─────────────────────────────────────────
    invisibility_activated = 'Режим Невидимості Увімкнено',
    invisibility_deactivated = 'Режим Невидимості Вимкнено',

    -- ── Режим бога ──────────────────────────────────────────
    godmode_activated = 'Режим Бога Увімкнено',
    godmode_deactivated = 'Режим Бога Вимкнено',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Увімкнено',
    wallhack_deactivated = 'Wallhack Вимкнено',

    -- ── Режим налагодження ──────────────────────────────────
    debug_activated = 'Режим Налагодження Увімкнено',
    debug_deactivated = 'Режим Налагодження Вимкнено',

    -- ── Сповіщення: транспорт ───────────────────────────────
    vehicle_repaired = 'Транспорт Полагоджено',
    vehicle_repaired_desc = 'Транспорт було успішно полагоджено.',
    vehicle_deleted = 'Транспорт Видалено',
    vehicle_deleted_desc = 'Транспорт було успішно видалено.',
    vehicle_spawned = 'Транспорт Заспавнено',
    vehicle_spawned_desc = 'Транспорт %s було успішно заспавнено.',
    vehicle_plate_changed = 'Номер Змінено',
    vehicle_plate_changed_desc = 'Номерний знак змінено на: %s',
    vehicle_refueled = 'Транспорт Заправлено',
    vehicle_refueled_desc = 'Транспорт було успішно заправлено.',
    vehicle_keys_given = 'Ключі Отримано',
    vehicle_keys_given_desc = 'Ти отримав ключі від транспорту з номером: %s',
    vehicle_color_changed = 'Колір Транспорту Змінено',
    vehicle_color_changed_desc = 'Колір транспорту змінено на: %s',
    vehicle_torque_set = 'Множник Моменту Встановлено',
    vehicle_torque_set_desc = 'Крутний момент встановлено: %sx',
    vehicle_torque_disabled = 'Множник Моменту Вимкнено',

    -- ── Спостереження ───────────────────────────────────────
    spectate_started = 'Спостереження',
    spectate_started_desc = 'Ти спостерігаєш за %s. Натисни X, щоб зупинити.',
    spectate_ended = 'Спостереження Завершено',
    spectate_ended_desc = 'Ти більше ні за ким не спостерігаєш.',
    spectate_error = 'Помилка Спостереження',
    spectate_error_desc = 'Цільового гравця не знайдено або він більше не існує.',

    -- ── Телепортація ────────────────────────────────────────
    teleport_success = 'Телепортовано',
    teleport_success_desc = 'Тебе було успішно телепортовано.',

    -- ── Воскресіння / лікування ─────────────────────────────
    player_revived = 'Гравця Воскрешено',
    player_revived_desc = 'Ти успішно воскресив %s.',
    player_healed = 'Гравця Вилікувано',
    player_healed_desc = 'Ти успішно вилікував %s.',
    self_revived = 'Воскрешено',
    self_revived_desc = 'Ти воскресив себе.',
    self_healed = 'Вилікувано',
    self_healed_desc = 'Ти вилікував себе.',

    -- ── Педи ────────────────────────────────────────────────
    ped_changed = 'Педа Змінено',
    ped_changed_desc = 'Твою модель педа було змінено.',
    ped_restored = 'Педа Відновлено',
    ped_restored_desc = 'Твою початкову модель педа було відновлено.',

    skin_menu_opened = 'Меню Одягу Відкрито',

    admin_menu_opened = 'Адмін-меню Відкрито',
    admin_menu_closed = 'Адмін-меню Закрито',

    entity_deleted = 'Сутність Видалено',
    entity_deleted_desc = 'Сутність було успішно видалено.',

    player_frozen = 'Гравця Заморожено',
    player_frozen_desc = 'Гравця %s було заморожено.',
    player_unfrozen = 'Гравця Розморожено',
    player_unfrozen_desc = 'Гравця %s було розморожено.',

    -- ── Власний номерний знак ───────────────────────────────
    dialog_license_plate = 'Власний Номерний Знак',
    dialog_license_plate_label = 'Номер',
    dialog_license_plate_placeholder = 'Номерний знак',

    -- ── Вилучення грошей ────────────────────────────────────
    player_removemoney = 'Забрати Гроші',
    player_removemoney_desc = 'Забрати гроші в обраного гравця',
    dialog_removemoney = 'Забрати Гроші',
    removemoney_input_label = 'Сума',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Рахунок',
    notify_removemoney_success = 'Гроші Вилучено',
    notify_removemoney_success_desc = 'Ти забрав $%s у %s (рахунок: %s)',
    notify_removemoney_fail = 'Невдало',
    notify_removemoney_fail_desc = 'Не вдалося забрати гроші в %s (можливо, недостатньо коштів).',

    -- ── Виміри / routing buckets ────────────────────────────
    self_dimension = 'Задати Свій Вимір',
    self_dimension_desc = 'Перемістити себе в routing bucket (0 = основний світ)',
    player_dimension = 'Задати Вимір',
    player_dimension_desc = 'Перемістити цього гравця в routing bucket',
    player_dimension_bring = 'Притягнути в Мій Вимір',
    player_dimension_bring_desc = 'Перетягнути цього гравця у твій поточний вимір',
    player_dimension_goto = 'Увійти у Вимір Гравця',
    player_dimension_goto_desc = 'Перемістити себе у вимір цього гравця',
    dialog_dimension = 'Задати Вимір',
    dimension_input_label = 'Вимір (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Вимір Змінено',
    notify_dimension_self_desc = 'Ти тепер у вимірі %s.',
    notify_dimension_player_desc = '%s переміщено у вимір %s.',
    notify_dimension_join_desc = 'Ти увійшов у вимір гравця %s (%s).',
    notify_dimension_fail = 'Помилка Виміру',
    notify_dimension_fail_desc = 'Не вдалося змінити вимір.',

    -- ── Телепорт у транспорт ────────────────────────────────
    player_tp_vehicle = 'Телепорт у Транспорт',
    player_tp_vehicle_desc = 'Сісти в транспорт цього гравця, щоб допомогти його витягнути',
    notify_tp_vehicle_fail = 'Немає Транспорту',
    notify_tp_vehicle_fail_desc = '%s не в транспорті.',
    notify_tp_vehicle_success = 'Телепортовано',
    notify_tp_vehicle_success_desc = 'Тебе було поміщено в транспорт гравця %s.',

    -- ── Порятунок транспорту ────────────────────────────────
    recover_car = 'Витягнути / Перевернути Транспорт',
    recover_car_desc = 'Поставити на колеса й перемістити на найближчу дорогу (море/перекидання)',
    vehicle_recovered = 'Транспорт Врятовано',
    vehicle_recovered_desc = 'Транспорт поставлено на колеса й переміщено на найближчу дорогу.',

    -- ── Транспорт у власності ───────────────────────────────
    player_owned_vehicles = 'Транспорт Гравця',
    player_owned_vehicles_desc = 'Переглянути, додати або прибрати авто цього гравця',
    owned_vehicles_menu = 'Транспорт Гравця (%s)',
    owned_vehicles_add = 'Додати Транспорт',
    owned_vehicles_add_desc = 'Додати транспорт до гаража цього гравця',
    owned_vehicles_none = 'Транспорту Немає',
    owned_vehicles_none_desc = 'Цей гравець не має жодного транспорту.',
    owned_vehicle_desc = 'Номер: %s · натисни, щоб прибрати',
    dialog_add_vehicle = 'Додати Транспорт',
    add_vehicle_model_label = 'Назва Моделі',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Номер (необов\'язково)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Прибрати %s?',
    notify_owned_added = 'Транспорт Додано',
    notify_owned_added_desc = 'Додано %s (номер %s) гравцю %s.',
    notify_owned_removed = 'Транспорт Прибрано',
    notify_owned_removed_desc = 'Прибрано номер %s у %s.',
    notify_owned_fail = 'Помилка Бази Даних',
    notify_owned_fail_desc = 'Операція з базою даних транспорту не вдалася.',

    -- ── Меню педів ──────────────────────────────────────────
    player_pedmenu = 'Видати Меню Педів',
    player_pedmenu_desc = 'Відкрити меню вибору педа на екрані цього гравця',
    pedmenu_title = 'Меню Педів',
    pedmenu_given = 'Меню Педів Надіслано',
    pedmenu_given_desc = 'Меню педів відкрито для %s.'
}
