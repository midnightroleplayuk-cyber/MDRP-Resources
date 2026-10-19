-- ============================================================
-- РУССКИЙ (ru)
-- ------------------------------------------------------------
-- Наложение поверх configs/strings.lua. Любой ключ, которого
-- здесь нет, сохраняет английский текст, поэтому частичный
-- перевод безопасен.
--
-- Подстановки %s нужно сохранять и в ТОМ ЖЕ порядке, что и в
-- оригинале: их заполняет :format() в коде. %% выводит
-- буквальный знак процента.
--
-- Включение:  Config.Locale = 'ru'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['ru'] = {
    -- ── Главное меню ────────────────────────────────────────
    main_title = 'Админ-меню',
    self_options = 'Свои Настройки',
    self_options_desc = 'Настройки, касающиеся тебя',
    player_options_title = 'Настройки Игрока',
    player_options_desc = 'Настройки, касающиеся других игроков',
    vehicle_options = 'Настройки Транспорта',
    vehicle_options_desc = 'Настройки, касающиеся транспорта',
    server_options = 'Настройки Сервера',
    server_options_desc = 'Настройки, касающиеся сервера',
    admin_zone_options = 'Админ-зоны',
    admin_zone_options_desc = 'Управлять, добавлять и удалять админ-зоны',
    developer_options = 'Настройки Разработчика',
    developer_options_desc = '',

    -- ── Свои настройки ──────────────────────────────────────
    self_options_menu = 'Свои Настройки',
    self_health = 'Здоровье (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Воскресить',
    self_revive_desc = 'Воскресить себя',
    self_heal = 'Вылечить',
    self_heal_desc = 'Вылечить себя',
    self_skinmenu = 'Меню Одежды',
    self_set_ped = 'Сменить Педа',
    self_skinmenu_desc = 'Открыть меню одежды локально',
    self_invisible = 'Невидимость',
    self_godmode = 'Режим Бога',
    self_wallhack = 'Wallhack',

    -- ── Настройки игрока ────────────────────────────────────
    player_options_menu = 'Игроков Онлайн %s/%s',
    player_options = 'Игрок: %s',
    player_health = 'Здоровье Игрока (%s%%)',
    player_freeze = 'Заморозить',
    player_freeze_desc = 'Вкл./выкл.',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Вкл./выкл.',
    player_spectate = 'Наблюдать',
    player_spectate_desc = 'Следить за действиями этого игрока',
    player_playerdata = 'Данные Игрока',
    player_playerdata_desc = 'Посмотреть данные игрока',
    player_revive = 'Воскресить',
    player_revive_desc = 'Воскресить игрока',
    player_heal = 'Вылечить',
    player_heal_desc = 'Вылечить игрока',
    player_skinmenu = 'Меню Одежды',
    player_skinmenu_desc = 'Открыть игроку меню одежды',
    player_money = 'Выдать Деньги',
    player_money_desc = 'Выдать деньги выбранному игроку',
    player_item = 'Выдать Предмет',
    player_item_desc = 'Выдать предмет выбранному игроку',
    player_openinv = 'Открыть Инвентарь',
    player_openinv_desc = 'Открыть инвентарь игрока',
    player_clearinv = 'Очистить Инвентарь',
    player_clearinv_desc = 'Очистить инвентарь игрока',
    player_teleport_to = 'Телепорт к Игроку',
    player_teleport_to_desc = 'Телепортироваться к игроку',
    player_bring = 'Притянуть',
    player_bring_desc = 'Притянуть игрока к своей позиции',
    player_kick = 'Кикнуть',
    player_kick_desc = 'Выгнать игрока с сервера',
    player_ban = 'Забанить Игрока',

    -- ── Меню транспорта ─────────────────────────────────────
    vehicle_menu = 'Меню Транспорта',
    spawn_car = 'Заспавнить Транспорт',
    spawn_car_desc = 'Заспавнить транспорт',
    repair_car = 'Починить Транспорт',
    repair_car_desc = 'Починить текущий или ближайший транспорт',
    delete_car = 'Удалить Транспорт',
    delete_car_desc = 'Удалить текущий или ближайший транспорт',
    number_plate = 'Изменить Номер',
    number_plate_desc = 'Изменить текст текущего номерного знака',
    refuel = 'Заправить Транспорт',
    refuel_desc = 'Заправить текущий или ближайший транспорт',
    give_keys = 'Выдать Ключи',
    give_keys_desc = 'Выдать себе ключи от текущего транспорта',
    doors = 'Закрыть/Открыть Двери',
    doors_desc = 'Переключает замки ближайшего транспорта',
    boost_car = 'Множитель Крутящего Момента',
    boost_car_desc = 'Изменить крутящий момент текущего транспорта',
    color_change = 'Изменить Цвет Транспорта',
    color_change_desc = 'Изменить цвет текущего или ближайшего транспорта',

    -- ── Управление сервером ─────────────────────────────────
    server_management = 'Управление Сервером',
    server_announcement = 'Объявление Сервера',
    server_announcement_desc = 'Отправить глобальное объявление всему серверу',
    ban_list = 'Список Банов',
    ban_list_desc = 'Посмотреть все активные баны',
    objects_list = 'Удалить Сущности',
    objects_list_desc = 'Удалить транспорт и педов',
    objects_list_label = 'Опции',
    weather_menu = 'Управление Погодой',
    weather_menu_desc = 'Управлять погодой',

    -- ── Админ-зоны ──────────────────────────────────────────
    zones_create = 'Создать Зону',
    zones_create_desc = 'Создать новую админ-зону',
    zones_manage = 'Управлять Зонами',
    zones_manage_desc = 'Изменить или удалить активные зоны',
    zone_edit_current = 'Изменить Текущую Зону',
    zone_edit_current_desc = 'Управлять зоной, в которой ты находишься',
    zone_delete_current = 'Удалить Текущую Зону',
    zone_delete_current_desc = 'Удалить зону, в которой ты находишься',
    zone_manage_menu = 'Редактирование Зоны (%s)',
    zone_edit = 'Изменить Зону',
    zone_edit_desc = 'Изменить зону: %s',
    zone_delete = 'Удалить Зону',
    zone_delete_desc = 'Удалить зону: %s',
    zone_teleport = 'Телепорт в Зону',
    zone_teleport_desc = 'Перейти в зону: %s',

    -- ── Меню разработчика ───────────────────────────────────
    dev_options = 'Настройки Разработчика',
    debug_mode = 'Режим Отладки',
    debug_mode_desc = 'Включить/выключить режим отладки',
    copy_vec3 = 'Скопировать Координаты Vector3',
    copy_vec3_desc = 'Копирует твою текущую позицию (vector3) в буфер обмена',
    copy_vec4 = 'Скопировать Координаты Vector4',
    copy_vec4_desc = 'Копирует твою текущую позицию (vector4) в буфер обмена',
    copy_heading = 'Скопировать Направление',
    copy_heading_desc = 'Копирует твоё текущее направление в буфер обмена',
    cant_delete = 'Нельзя удалить!',
    cant_delete_player_desc = 'Нельзя удалять педов игроков!',
    cant_delete_entity_desc = 'Нельзя удалять стандартные объекты карты!',

    -- ── Список банов ────────────────────────────────────────
    ban_list_menu = 'Список Банов',
    ban_list_name = 'Имя: %s',
    ban_list_license = 'Лицензия:',
    ban_list_by = 'Выдал: %s',
    ban_list_reason = 'Причина: %s',
    ban_list_length = 'Осталось: %s часов %s минут',
    ban_list_modify = 'Изменить Бан',
    ban_list_unban = 'Разбанить Игрока',
    ban_list_no_data = 'Банов Нет',
    ban_list_no_data_desc = 'Активных банов не найдено!',

    -- ── Данные игрока ───────────────────────────────────────
    playerdata_menu = 'Данные Игрока',
    playerdata_license_esx = 'Лицензия: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Нажми, чтобы скопировать полную лицензию',
    playerdata_igname = 'Имя: %s',
    playerdata_igname_desc = 'Полное игровое имя игрока',
    playerdata_steam = 'Имя в Steam: %s',
    playerdata_steam_desc = 'Полное имя игрока в Steam',
    playerdata_gender = 'Пол: %s',
    playerdata_gender_desc = 'Пол игрока',
    playerdata_cash = 'Наличные: %s',
    playerdata_cash_desc = 'Баланс наличных игрока',
    playerdata_bank = 'Банк: %s',
    playerdata_bank_desc = 'Банковский баланс игрока',
    playerdata_blackmoney = 'Грязные Деньги: %s',
    playerdata_blackmoney_desc = 'Баланс грязных денег игрока',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Нажми [E], чтобы удалить сущность  \nHash: %s  \nКоординаты: vec3(%s, %s, %s)  \nНаправление: %s  \nВладелец: [%s] - %s',
    debug_textui_noname = 'Нажми [E], чтобы удалить сущность\n  Hash: %s\n  Координаты: vec3(%s, %s, %s)\n  Направление: %s\n  Владелец: НЕИЗВЕСТЕН',

    textui_invisible = 'Режим Невидимости - Активен',
    textui_godmode = 'Режим Бога - Активен',
    textui_wallhack = 'Wallhack - Активен',
    textui_noclip_activated = 'No Clip - Активен',
    textui_torque = 'Множитель Момента - %s',

    -- ── Объявления ──────────────────────────────────────────
    dialog_announce = 'Объявление',
    dialog_announce_label = 'Сообщение',
    dialog_announce_select = 'Все',
    dialog_announce_everyone = 'Все',
    dialog_announce_placeholder = 'Важное сообщение сюда. . .',

    -- ── Разбан ──────────────────────────────────────────────
    dialog_unban = 'Ты уверен?',
    dialog_unban_content = 'Действительно разбанить %s?',

    -- ── Удаление сущностей ──────────────────────────────────
    dialog_objects = 'Выбери опцию',
    dialog_clear_objects = 'Удалить ВСЕ объекты',
    dialog_clear_cars = 'Удалить ВСЕ машины (без водителя)',
    dialog_clear_peds = 'Удалить ВСЕХ педов',

    -- ── Выдача денег ────────────────────────────────────────
    dialog_givemoney = 'Выдать Деньги',
    givemoney_input_label = 'Сумма',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Счёт',
    givemoney_select_option1 = 'Наличные',
    givemoney_select_option2 = 'Банк',
    givemoney_select_option3 = 'Грязные Деньги',

    -- ── Выдача предмета ─────────────────────────────────────
    dialog_giveitem = 'Выдать Предмет',
    giveitem_input_label = 'Название Предмета',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Количество',
    giveitem_amount_input_placeholder = '3',

    -- ── Спавн транспорта ────────────────────────────────────
    dialog_spawn_a_car = 'Заспавнить Транспорт',
    dialog_car_model = 'Название Модели',
    dialog_car_model_holder = 'Напр: 20charger',
    dialog_car_plate = 'Номер (необязательно)',
    dialog_car_plate_holder = 'Напр: W4S4B1',
    dialog_car_color_primary = 'Основной Цвет (необязательно)',
    dialog_car_color_second = 'Дополнительный Цвет (необязательно)',
    dialog_car_maxed = 'Максимальный Тюнинг (необязательно)',

    -- ── Кик ─────────────────────────────────────────────────
    dialog_kick = 'Кикнуть %s',
    dialog_kick_reason = 'Причина',
    dialog_kick_placeholder = 'Читер',
    kicked_reason_replace = 'Тебя выгнали с сервера!',

    -- ── Бан ─────────────────────────────────────────────────
    dialog_ban = 'Забанить %s',
    dialog_ban_reason = 'Причина',
    dialog_ban_placeholder = 'Читер',
    ban_reason_replace = 'Ты забанен на этом сервере!',

    -- ── Создание зоны ───────────────────────────────────────
    dialog_zone_create = 'Создание Зоны',
    dialog_zone_name = 'Название',
    dialog_zone_name_desc = 'Название зоны / блипа',
    dialog_zone_name_holder = 'Админ-зона',
    dialog_zone_text = 'Отображаемый Текст',
    dialog_zone_text_desc = 'Текст, показываемый игрокам внутри зоны',
    dialog_zone_text_holder = 'АДМИН-ЗОНА - АКТИВНА',
    dialog_zone_size = 'Размер',
    dialog_zone_speed = 'Ограничение Скорости',
    mph = 'MPH',
    kmh = 'КМ/Ч',
    dialog_zone_blip_id = 'ID Блипа',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Цвета',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Мигающий Блип',
    dialog_zone_disarm = 'Разоружить',
    dialog_zone_revive = 'Воскрешение',
    dialog_zone_invincible = 'Бессмертие',
    dialog_zone_edit = 'Редактирование «%s»',
    dialog_zone_delete_confirm = 'Ты уверен?',
    dialog_zone_delete_confirm_desc = 'Действительно удалить зону: %s',

    -- ── Уведомления: деньги ─────────────────────────────────
    notify_givemoney_success = 'Деньги Выданы',
    notify_givemoney_success_desc = 'Ты начислил %s $%s на счёт: %s',
    notify_givemoney_fail = 'Неудачно',
    notify_givemoney_fail_desc = 'Ты попытался начислить %s, но что-то пошло не так! Попробуй ещё раз.',

    -- ── Уведомления: предметы ───────────────────────────────
    notify_giveitem_success = 'Предмет Выдан',
    notify_giveitem_success_desc = 'Ты выдал %s. Предмет: %s Количество: %s',
    notify_giveitem_fail = 'Ошибка',
    notify_giveitem_fail_desc = 'Ты попытался выдать %s, но что-то пошло не так! Попробуй ещё раз.',

    -- ── Уведомления: кик / бан ──────────────────────────────
    notify_kicked_success = 'Кик Успешен',
    notify_kicked_success_desc = 'Ты успешно кикнул %s',
    notify_banned_success = 'Бан Успешен',
    notify_banned_success_desc = 'Ты успешно забанил %s',

    -- ── Уведомления: инвентарь ──────────────────────────────
    notify_clearedinv = 'Инвентарь Очищен',
    notify_clearedinv_desc = 'Ты успешно очистил инвентарь игрока %s',

    -- ── Уведомления: неверный ID ────────────────────────────
    notify_invalidid = 'Неверный ID',
    notify_invalidid_desc = 'Введённый ID неверный, попробуй ещё раз.',

    -- ── Уведомления: очистка ────────────────────────────────
    notify_deleted_car = 'Машины Удалены',
    notify_deleted_car_desc = 'Ты успешно удалил все машины без водителя.',
    notify_deleted_ped = 'Педы Удалены',
    notify_deleted_ped_desc = 'Ты успешно удалил всех педов на карте',
    notify_deleted_objects = 'Объекты Удалены',
    notify_deleted_objects_desc = 'Ты успешно удалил все объекты на карте',

    -- ── Уведомления: погода ─────────────────────────────────
    notify_weather = 'Погода Изменена',
    notify_weather_desc = 'Погода изменена на: %s',

    -- ── Уведомления: копирование координат ──────────────────
    notify_copied = 'Скопировано',
    notify_copied_vec3 = 'Vector3 успешно скопирован в буфер обмена!',
    notify_copied_vec4 = 'Vector4 успешно скопирован в буфер обмена!',
    notify_copied_headin = 'Направление успешно скопировано в буфер обмена!',

    -- ── Уведомления: двери ──────────────────────────────────
    notify_locked_doors = 'Закрыто',
    notify_locked_doors_desc = 'Двери транспорта успешно закрыты.',
    notify_unlocked_doors = 'Открыто',
    notify_unlocked_doors_desc = 'Двери транспорта успешно открыты.',

    -- ── Уведомления: админ-зоны ─────────────────────────────
    notify_zone_deleted = 'Зона Удалена',
    notify_zone_deleted_desc = 'Ты успешно удалил зону: %s.',
    notify_zone_not_deleted_desc = 'Произошла ошибка при удалении зоны: %s.',
    notify_zone_edited = 'Зона Изменена',
    notify_zone_edited_desc = 'Ты успешно изменил зону: %s.',
    notify_zone_not_edited_desc = 'Произошла ошибка при изменении зоны: %s.',
    notify_zone_action_cancelled = 'Действие Отменено',
    notify_zone_delete_cancel = 'Ты отменил удаление зоны: %s',
    notify_zone_no_weapons = 'Оружие Запрещено',
    notify_zone_no_weapons_desc = 'Тебе нельзя использовать оружие внутри этой зоны.',
    notify_zones_not_found = 'Зон Не Найдено',
    notify_zones_not_found_desc = 'Сейчас нет активных зон для управления.',
    notify_zones_teleport = 'Телепортирован',
    notify_zones_teleport_desc = 'Ты успешно телепортировался в зону: %s.',

    -- ── Уведомления: разбан ─────────────────────────────────
    successfully_unbanned = 'Бан Снят',
    successfully_unbanned_desc = 'Ты успешно разбанил: %s.',
    unsuccessful_unban = 'Что-то пошло не так при разбане: %s.',

    -- ── Подключение (deferrals) ─────────────────────────────
    deferral_welcome = '[%s] Привет, %s, проверяем баны. . .',
    deferral_banned = 'Ты забанен на этом сервере. Причина: «%s» (Осталось: %s часов %s минут).',
    deferral_banned_perm = 'Ты забанен на этом сервере. Причина: «%s» (Осталось: Навсегда).',

    -- ── Ошибки ──────────────────────────────────────────────
    notify_error = 'Ошибка',
    notify_disabled_keys = 'Не настроен ни один скрипт ключей от транспорта. Обратись к разработчику сервера.',
    notify_no_appearance = 'Скрипт одежды / внешности не обнаружен. Обратись к разработчику сервера.',
    notify_no_vehicle = 'Транспорт не найден!',
    notify_invalid_entry = 'Неверный ввод!',

    -- ── Горячая клавиша ─────────────────────────────────────
    keymapping_desc = 'Открыть Админ-меню (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Включён',
    noclip_deactivated = 'NoClip Выключен',

    -- ── Невидимость ─────────────────────────────────────────
    invisibility_activated = 'Режим Невидимости Включён',
    invisibility_deactivated = 'Режим Невидимости Выключен',

    -- ── Режим бога ──────────────────────────────────────────
    godmode_activated = 'Режим Бога Включён',
    godmode_deactivated = 'Режим Бога Выключен',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Включён',
    wallhack_deactivated = 'Wallhack Выключен',

    -- ── Режим отладки ───────────────────────────────────────
    debug_activated = 'Режим Отладки Включён',
    debug_deactivated = 'Режим Отладки Выключен',

    -- ── Уведомления: транспорт ──────────────────────────────
    vehicle_repaired = 'Транспорт Починен',
    vehicle_repaired_desc = 'Транспорт был успешно починен.',
    vehicle_deleted = 'Транспорт Удалён',
    vehicle_deleted_desc = 'Транспорт был успешно удалён.',
    vehicle_spawned = 'Транспорт Заспавнен',
    vehicle_spawned_desc = 'Транспорт %s был успешно заспавнен.',
    vehicle_plate_changed = 'Номер Изменён',
    vehicle_plate_changed_desc = 'Номерной знак изменён на: %s',
    vehicle_refueled = 'Транспорт Заправлен',
    vehicle_refueled_desc = 'Транспорт был успешно заправлен.',
    vehicle_keys_given = 'Ключи Получены',
    vehicle_keys_given_desc = 'Ты получил ключи от транспорта с номером: %s',
    vehicle_color_changed = 'Цвет Транспорта Изменён',
    vehicle_color_changed_desc = 'Цвет транспорта изменён на: %s',
    vehicle_torque_set = 'Множитель Момента Установлен',
    vehicle_torque_set_desc = 'Крутящий момент установлен: %sx',
    vehicle_torque_disabled = 'Множитель Момента Отключён',

    -- ── Наблюдение ──────────────────────────────────────────
    spectate_started = 'Наблюдение',
    spectate_started_desc = 'Ты наблюдаешь за %s. Нажми X, чтобы прекратить.',
    spectate_ended = 'Наблюдение Завершено',
    spectate_ended_desc = 'Ты больше ни за кем не наблюдаешь.',
    spectate_error = 'Ошибка Наблюдения',
    spectate_error_desc = 'Целевой игрок не найден или больше не существует.',

    -- ── Телепортация ────────────────────────────────────────
    teleport_success = 'Телепортирован',
    teleport_success_desc = 'Ты был успешно телепортирован.',

    -- ── Воскрешение / лечение ───────────────────────────────
    player_revived = 'Игрок Воскрешён',
    player_revived_desc = 'Ты успешно воскресил %s.',
    player_healed = 'Игрок Вылечен',
    player_healed_desc = 'Ты успешно вылечил %s.',
    self_revived = 'Воскрешён',
    self_revived_desc = 'Ты воскресил себя.',
    self_healed = 'Вылечен',
    self_healed_desc = 'Ты вылечил себя.',

    -- ── Педы ────────────────────────────────────────────────
    ped_changed = 'Пед Изменён',
    ped_changed_desc = 'Твоя модель педа была изменена.',
    ped_restored = 'Пед Восстановлен',
    ped_restored_desc = 'Твоя исходная модель педа была восстановлена.',

    skin_menu_opened = 'Меню Одежды Открыто',

    admin_menu_opened = 'Админ-меню Открыто',
    admin_menu_closed = 'Админ-меню Закрыто',

    entity_deleted = 'Сущность Удалена',
    entity_deleted_desc = 'Сущность была успешно удалена.',

    player_frozen = 'Игрок Заморожен',
    player_frozen_desc = 'Игрок %s был заморожен.',
    player_unfrozen = 'Игрок Разморожен',
    player_unfrozen_desc = 'Игрок %s был разморожен.',

    -- ── Свой номерной знак ──────────────────────────────────
    dialog_license_plate = 'Свой Номерной Знак',
    dialog_license_plate_label = 'Номер',
    dialog_license_plate_placeholder = 'Номерной знак',

    -- ── Изъятие денег ───────────────────────────────────────
    player_removemoney = 'Забрать Деньги',
    player_removemoney_desc = 'Забрать деньги у выбранного игрока',
    dialog_removemoney = 'Забрать Деньги',
    removemoney_input_label = 'Сумма',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Счёт',
    notify_removemoney_success = 'Деньги Изъяты',
    notify_removemoney_success_desc = 'Ты забрал $%s у %s (счёт: %s)',
    notify_removemoney_fail = 'Неудачно',
    notify_removemoney_fail_desc = 'Не удалось забрать деньги у %s (возможно, недостаточно средств).',

    -- ── Измерения / routing buckets ─────────────────────────
    self_dimension = 'Задать Своё Измерение',
    self_dimension_desc = 'Переместить себя в routing bucket (0 = основной мир)',
    player_dimension = 'Задать Измерение',
    player_dimension_desc = 'Переместить этого игрока в routing bucket',
    player_dimension_bring = 'Притянуть в Моё Измерение',
    player_dimension_bring_desc = 'Перетянуть этого игрока в твоё текущее измерение',
    player_dimension_goto = 'Войти в Измерение Игрока',
    player_dimension_goto_desc = 'Переместить себя в измерение этого игрока',
    dialog_dimension = 'Задать Измерение',
    dimension_input_label = 'Измерение (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Измерение Изменено',
    notify_dimension_self_desc = 'Ты теперь в измерении %s.',
    notify_dimension_player_desc = '%s перемещён в измерение %s.',
    notify_dimension_join_desc = 'Ты вошёл в измерение игрока %s (%s).',
    notify_dimension_fail = 'Ошибка Измерения',
    notify_dimension_fail_desc = 'Не удалось сменить измерение.',

    -- ── Телепорт в транспорт ────────────────────────────────
    player_tp_vehicle = 'Телепорт в Транспорт',
    player_tp_vehicle_desc = 'Сесть в транспорт этого игрока, чтобы помочь его вытащить',
    notify_tp_vehicle_fail = 'Нет Транспорта',
    notify_tp_vehicle_fail_desc = '%s не в транспорте.',
    notify_tp_vehicle_success = 'Телепортирован',
    notify_tp_vehicle_success_desc = 'Ты был помещён в транспорт игрока %s.',

    -- ── Спасение транспорта ─────────────────────────────────
    recover_car = 'Вытащить / Перевернуть Транспорт',
    recover_car_desc = 'Поставить на колёса и переместить на ближайшую дорогу (море/переворот)',
    vehicle_recovered = 'Транспорт Спасён',
    vehicle_recovered_desc = 'Транспорт поставлен на колёса и перемещён на ближайшую дорогу.',

    -- ── Транспорт во владении ───────────────────────────────
    player_owned_vehicles = 'Транспорт Игрока',
    player_owned_vehicles_desc = 'Посмотреть, добавить или убрать машины этого игрока',
    owned_vehicles_menu = 'Транспорт Игрока (%s)',
    owned_vehicles_add = 'Добавить Транспорт',
    owned_vehicles_add_desc = 'Добавить транспорт в гараж этого игрока',
    owned_vehicles_none = 'Транспорта Нет',
    owned_vehicles_none_desc = 'У этого игрока нет транспорта.',
    owned_vehicle_desc = 'Номер: %s · нажми, чтобы убрать',
    dialog_add_vehicle = 'Добавить Транспорт',
    add_vehicle_model_label = 'Название Модели',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Номер (необязательно)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Убрать %s?',
    notify_owned_added = 'Транспорт Добавлен',
    notify_owned_added_desc = 'Добавлен %s (номер %s) игроку %s.',
    notify_owned_removed = 'Транспорт Убран',
    notify_owned_removed_desc = 'Убран номер %s у %s.',
    notify_owned_fail = 'Ошибка Базы Данных',
    notify_owned_fail_desc = 'Операция с базой данных транспорта не удалась.',

    -- ── Меню педов ──────────────────────────────────────────
    player_pedmenu = 'Выдать Меню Педов',
    player_pedmenu_desc = 'Открыть меню выбора педа на экране этого игрока',
    pedmenu_title = 'Меню Педов',
    pedmenu_given = 'Меню Педов Отправлено',
    pedmenu_given_desc = 'Меню педов открыто для %s.'
}
