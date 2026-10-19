-- ============================================================
-- العربية (ar)
-- ------------------------------------------------------------
-- طبقة فوق configs/strings.lua. أي مفتاح غير موجود هنا يحتفظ
-- بالنص الإنجليزي، لذا الترجمة الجزئية آمنة.
--
-- يجب الإبقاء على العلامات %s وبنفس الترتيب الموجود في الأصل:
-- تملؤها ‎:format()‎ في الشيفرة. و‎%%‎ تطبع علامة نسبة مئوية حرفية.
--
-- التفعيل:  Config.Locale = 'ar'   (configs/config.lua)
--
-- ملاحظة: واجهة FiveM ترسم النص من اليسار إلى اليمين، لذا قد
-- تظهر بعض السطور المختلطة (عربي + أرقام/إنجليزي) بترتيب غير
-- متوقع داخل اللعبة. هذا قيد في المحرك وليس في الترجمة.
-- ============================================================

Locales = Locales or {}

Locales['ar'] = {
    -- ── القائمة الرئيسية ────────────────────────────────────
    main_title = 'قائمة الإدارة',
    self_options = 'خيارات شخصية',
    self_options_desc = 'خيارات تخصك أنت',
    player_options_title = 'خيارات اللاعب',
    player_options_desc = 'خيارات تخص اللاعبين الآخرين',
    vehicle_options = 'خيارات المركبة',
    vehicle_options_desc = 'خيارات تخص المركبات',
    server_options = 'خيارات السيرفر',
    server_options_desc = 'خيارات تخص السيرفر',
    admin_zone_options = 'مناطق الإدارة',
    admin_zone_options_desc = 'إدارة وإضافة وحذف مناطق الإدارة',
    developer_options = 'خيارات المطور',
    developer_options_desc = '',

    -- ── الخيارات الشخصية ────────────────────────────────────
    self_options_menu = 'خيارات شخصية',
    self_health = 'الصحة (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'إنعاش',
    self_revive_desc = 'إنعاش نفسك',
    self_heal = 'علاج',
    self_heal_desc = 'علاج نفسك',
    self_skinmenu = 'قائمة الملابس',
    self_set_ped = 'تغيير الشخصية',
    self_skinmenu_desc = 'فتح قائمة الملابس محليًا',
    self_invisible = 'اختفاء',
    self_godmode = 'وضع الخلود',
    self_wallhack = 'Wallhack',

    -- ── خيارات اللاعب ───────────────────────────────────────
    player_options_menu = 'اللاعبون المتصلون %s/%s',
    player_options = 'اللاعب: %s',
    player_health = 'صحة اللاعب (%s%%)',
    player_freeze = 'تجميد',
    player_freeze_desc = 'تشغيل/إيقاف',
    player_noclip = 'No Clip',
    player_noclip_desc = 'تشغيل/إيقاف',
    player_spectate = 'مراقبة',
    player_spectate_desc = 'مراقبة تصرفات هذا اللاعب',
    player_playerdata = 'بيانات اللاعب',
    player_playerdata_desc = 'عرض بيانات اللاعب',
    player_revive = 'إنعاش',
    player_revive_desc = 'إنعاش اللاعب',
    player_heal = 'علاج',
    player_heal_desc = 'علاج اللاعب',
    player_skinmenu = 'قائمة الملابس',
    player_skinmenu_desc = 'فتح قائمة ملابس لدى اللاعب',
    player_money = 'إعطاء أموال',
    player_money_desc = 'إعطاء أموال للاعب المحدد',
    player_item = 'إعطاء غرض',
    player_item_desc = 'إعطاء غرض للاعب المحدد',
    player_openinv = 'فتح الحقيبة',
    player_openinv_desc = 'فتح حقيبة اللاعب',
    player_clearinv = 'تفريغ الحقيبة',
    player_clearinv_desc = 'تفريغ حقيبة اللاعب',
    player_teleport_to = 'الانتقال إلى اللاعب',
    player_teleport_to_desc = 'الانتقال إلى موقع اللاعب',
    player_bring = 'إحضار',
    player_bring_desc = 'إحضار اللاعب إلى موقعك',
    player_kick = 'طرد',
    player_kick_desc = 'طرد اللاعب من السيرفر',
    player_ban = 'حظر اللاعب',

    -- ── قائمة المركبة ───────────────────────────────────────
    vehicle_menu = 'قائمة المركبة',
    spawn_car = 'استدعاء مركبة',
    spawn_car_desc = 'استدعاء مركبة',
    repair_car = 'إصلاح المركبة',
    repair_car_desc = 'إصلاح المركبة الحالية أو الأقرب',
    delete_car = 'حذف المركبة',
    delete_car_desc = 'حذف المركبة الحالية أو الأقرب',
    number_plate = 'تعديل اللوحة',
    number_plate_desc = 'تغيير نص اللوحة الحالية',
    refuel = 'تعبئة وقود المركبة',
    refuel_desc = 'تعبئة وقود المركبة الحالية أو الأقرب',
    give_keys = 'إعطاء المفاتيح',
    give_keys_desc = 'إعطاء نفسك مفاتيح المركبة الحالية',
    doors = 'قفل/فتح الأبواب',
    doors_desc = 'يبدّل أقفال أقرب مركبة',
    boost_car = 'مضاعف العزم',
    boost_car_desc = 'تعديل عزم المركبة الحالية',
    color_change = 'تغيير لون المركبة',
    color_change_desc = 'تغيير لون المركبة الحالية أو الأقرب',

    -- ── إدارة السيرفر ───────────────────────────────────────
    server_management = 'إدارة السيرفر',
    server_announcement = 'إعلان السيرفر',
    server_announcement_desc = 'إرسال إعلان عام لكل السيرفر',
    ban_list = 'قائمة الحظر',
    ban_list_desc = 'عرض كل حالات الحظر النشطة',
    objects_list = 'حذف الكيانات',
    objects_list_desc = 'حذف المركبات والشخصيات',
    objects_list_label = 'الخيارات',
    weather_menu = 'إدارة الطقس',
    weather_menu_desc = 'التحكم في الطقس',

    -- ── مناطق الإدارة ───────────────────────────────────────
    zones_create = 'إنشاء منطقة',
    zones_create_desc = 'إنشاء منطقة إدارة جديدة',
    zones_manage = 'إدارة المناطق',
    zones_manage_desc = 'تعديل أو حذف المناطق النشطة',
    zone_edit_current = 'تعديل المنطقة الحالية',
    zone_edit_current_desc = 'إدارة المنطقة التي تقف فيها',
    zone_delete_current = 'حذف المنطقة الحالية',
    zone_delete_current_desc = 'حذف المنطقة التي تقف فيها',
    zone_manage_menu = 'تعديل المنطقة (%s)',
    zone_edit = 'تعديل المنطقة',
    zone_edit_desc = 'تعديل المنطقة: %s',
    zone_delete = 'حذف المنطقة',
    zone_delete_desc = 'حذف المنطقة: %s',
    zone_teleport = 'الانتقال إلى المنطقة',
    zone_teleport_desc = 'الذهاب إلى المنطقة: %s',

    -- ── قائمة المطور ────────────────────────────────────────
    dev_options = 'خيارات المطور',
    debug_mode = 'وضع التصحيح',
    debug_mode_desc = 'تشغيل/إيقاف وضع التصحيح',
    copy_vec3 = 'نسخ إحداثيات Vector3',
    copy_vec3_desc = 'ينسخ موقعك الحالي (vector3) إلى الحافظة',
    copy_vec4 = 'نسخ إحداثيات Vector4',
    copy_vec4_desc = 'ينسخ موقعك الحالي (vector4) إلى الحافظة',
    copy_heading = 'نسخ الاتجاه',
    copy_heading_desc = 'ينسخ اتجاهك الحالي إلى الحافظة',
    cant_delete = 'لا يمكن الحذف!',
    cant_delete_player_desc = 'لا يمكنك حذف شخصيات اللاعبين!',
    cant_delete_entity_desc = 'لا يمكنك حذف الأجسام الافتراضية في الخريطة!',

    -- ── قائمة الحظر ─────────────────────────────────────────
    ban_list_menu = 'قائمة الحظر',
    ban_list_name = 'الاسم: %s',
    ban_list_license = 'الرخصة:',
    ban_list_by = 'أصدره: %s',
    ban_list_reason = 'السبب: %s',
    ban_list_length = 'الوقت المتبقي: %s ساعة %s دقيقة',
    ban_list_modify = 'تعديل الحظر',
    ban_list_unban = 'رفع الحظر عن اللاعب',
    ban_list_no_data = 'لا يوجد حظر',
    ban_list_no_data_desc = 'لم يتم العثور على أي حظر نشط!',

    -- ── بيانات اللاعب ───────────────────────────────────────
    playerdata_menu = 'بيانات اللاعب',
    playerdata_license_esx = 'الرخصة: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'اضغط لنسخ الرخصة كاملة',
    playerdata_igname = 'الاسم: %s',
    playerdata_igname_desc = 'اسم اللاعب الكامل داخل اللعبة',
    playerdata_steam = 'اسم Steam: %s',
    playerdata_steam_desc = 'اسم اللاعب الكامل في Steam',
    playerdata_gender = 'الجنس: %s',
    playerdata_gender_desc = 'جنس اللاعب',
    playerdata_cash = 'نقدًا: %s',
    playerdata_cash_desc = 'رصيد اللاعب النقدي',
    playerdata_bank = 'البنك: %s',
    playerdata_bank_desc = 'رصيد اللاعب البنكي',
    playerdata_blackmoney = 'أموال سوداء: %s',
    playerdata_blackmoney_desc = 'رصيد اللاعب من الأموال السوداء',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'اضغط [E] لحذف الكيان  \nHash: %s  \nالإحداثيات: vec3(%s, %s, %s)  \nالاتجاه: %s  \nالمالك: [%s] - %s',
    debug_textui_noname = 'اضغط [E] لحذف الكيان\n  Hash: %s\n  الإحداثيات: vec3(%s, %s, %s)\n  الاتجاه: %s\n  المالك: غير معروف',

    textui_invisible = 'وضع الاختفاء - مفعّل',
    textui_godmode = 'وضع الخلود - مفعّل',
    textui_wallhack = 'Wallhack - مفعّل',
    textui_noclip_activated = 'No Clip - مفعّل',
    textui_torque = 'مضاعف العزم - %s',

    -- ── الإعلانات ───────────────────────────────────────────
    dialog_announce = 'إعلان',
    dialog_announce_label = 'الرسالة',
    dialog_announce_select = 'الجميع',
    dialog_announce_everyone = 'الجميع',
    dialog_announce_placeholder = 'رسالة مهمة هنا. . .',

    -- ── رفع الحظر ───────────────────────────────────────────
    dialog_unban = 'هل أنت متأكد؟',
    dialog_unban_content = 'هل تريد فعلاً رفع الحظر عن %s؟',

    -- ── حذف الكيانات ────────────────────────────────────────
    dialog_objects = 'اختر خيارًا',
    dialog_clear_objects = 'حذف كل الأجسام',
    dialog_clear_cars = 'حذف كل السيارات (بدون سائق)',
    dialog_clear_peds = 'حذف كل الشخصيات',

    -- ── إعطاء الأموال ───────────────────────────────────────
    dialog_givemoney = 'إعطاء أموال',
    givemoney_input_label = 'المبلغ',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'الحساب',
    givemoney_select_option1 = 'نقدًا',
    givemoney_select_option2 = 'البنك',
    givemoney_select_option3 = 'أموال سوداء',

    -- ── إعطاء غرض ───────────────────────────────────────────
    dialog_giveitem = 'إعطاء غرض',
    giveitem_input_label = 'اسم الغرض',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'الكمية',
    giveitem_amount_input_placeholder = '3',

    -- ── استدعاء مركبة ───────────────────────────────────────
    dialog_spawn_a_car = 'استدعاء مركبة',
    dialog_car_model = 'اسم الموديل',
    dialog_car_model_holder = 'مثال: 20charger',
    dialog_car_plate = 'اللوحة (اختياري)',
    dialog_car_plate_holder = 'مثال: W4S4B1',
    dialog_car_color_primary = 'اللون الأساسي (اختياري)',
    dialog_car_color_second = 'اللون الثانوي (اختياري)',
    dialog_car_maxed = 'أقصى التعديلات (اختياري)',

    -- ── الطرد ───────────────────────────────────────────────
    dialog_kick = 'طرد %s',
    dialog_kick_reason = 'السبب',
    dialog_kick_placeholder = 'غشاش',
    kicked_reason_replace = 'تم طردك من السيرفر!',

    -- ── الحظر ───────────────────────────────────────────────
    dialog_ban = 'حظر %s',
    dialog_ban_reason = 'السبب',
    dialog_ban_placeholder = 'غشاش',
    ban_reason_replace = 'تم حظرك من هذا السيرفر!',

    -- ── إنشاء منطقة ─────────────────────────────────────────
    dialog_zone_create = 'إنشاء منطقة',
    dialog_zone_name = 'الاسم',
    dialog_zone_name_desc = 'اسم المنطقة / العلامة',
    dialog_zone_name_holder = 'منطقة إدارة',
    dialog_zone_text = 'النص المعروض',
    dialog_zone_text_desc = 'النص الذي يظهر للاعبين داخل المنطقة',
    dialog_zone_text_holder = 'منطقة إدارة - نشطة',
    dialog_zone_size = 'الحجم',
    dialog_zone_speed = 'حد السرعة',
    mph = 'MPH',
    kmh = 'كم/س',
    dialog_zone_blip_id = 'معرّف العلامة',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'معرّف اللون',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'علامة وامضة',
    dialog_zone_disarm = 'نزع السلاح',
    dialog_zone_revive = 'إنعاش',
    dialog_zone_invincible = 'خالد',
    dialog_zone_edit = 'تعديل «%s»',
    dialog_zone_delete_confirm = 'هل أنت متأكد؟',
    dialog_zone_delete_confirm_desc = 'هل تريد فعلاً حذف المنطقة: %s',

    -- ── إشعارات: الأموال ────────────────────────────────────
    notify_givemoney_success = 'تم إعطاء الأموال',
    notify_givemoney_success_desc = 'أضفت للاعب %s مبلغ $%s في الحساب: %s',
    notify_givemoney_fail = 'فشل',
    notify_givemoney_fail_desc = 'حاولت الإضافة للاعب %s لكن حدث خطأ! حاول مرة أخرى.',

    -- ── إشعارات: الأغراض ────────────────────────────────────
    notify_giveitem_success = 'تم إعطاء الغرض',
    notify_giveitem_success_desc = 'أعطيت اللاعب %s. الغرض: %s الكمية: %s',
    notify_giveitem_fail = 'فشل',
    notify_giveitem_fail_desc = 'حاولت الإعطاء للاعب %s لكن حدث خطأ! حاول مرة أخرى.',

    -- ── إشعارات: الطرد / الحظر ──────────────────────────────
    notify_kicked_success = 'تم الطرد بنجاح',
    notify_kicked_success_desc = 'طردت %s بنجاح',
    notify_banned_success = 'تم الحظر بنجاح',
    notify_banned_success_desc = 'حظرت %s بنجاح',

    -- ── إشعارات: الحقيبة ────────────────────────────────────
    notify_clearedinv = 'تم تفريغ الحقيبة',
    notify_clearedinv_desc = 'فرّغت حقيبة اللاعب %s بنجاح',

    -- ── إشعارات: معرّف غير صالح ─────────────────────────────
    notify_invalidid = 'معرّف غير صالح',
    notify_invalidid_desc = 'المعرّف الذي أدخلته غير صالح، حاول مرة أخرى.',

    -- ── إشعارات: التنظيف ────────────────────────────────────
    notify_deleted_car = 'تم حذف السيارات',
    notify_deleted_car_desc = 'حذفت كل السيارات بدون سائق بنجاح.',
    notify_deleted_ped = 'تم حذف الشخصيات',
    notify_deleted_ped_desc = 'حذفت كل الشخصيات في الخريطة بنجاح',
    notify_deleted_objects = 'تم حذف الأجسام',
    notify_deleted_objects_desc = 'حذفت كل الأجسام في الخريطة بنجاح',

    -- ── إشعارات: الطقس ──────────────────────────────────────
    notify_weather = 'تم تغيير الطقس',
    notify_weather_desc = 'تم تغيير الطقس إلى: %s',

    -- ── إشعارات: نسخ الإحداثيات ─────────────────────────────
    notify_copied = 'تم النسخ',
    notify_copied_vec3 = 'تم نسخ vector3 إلى الحافظة بنجاح!',
    notify_copied_vec4 = 'تم نسخ vector4 إلى الحافظة بنجاح!',
    notify_copied_headin = 'تم نسخ الاتجاه إلى الحافظة بنجاح!',

    -- ── إشعارات: الأبواب ────────────────────────────────────
    notify_locked_doors = 'تم القفل',
    notify_locked_doors_desc = 'تم قفل أبواب المركبة بنجاح.',
    notify_unlocked_doors = 'تم الفتح',
    notify_unlocked_doors_desc = 'تم فتح أبواب المركبة بنجاح.',

    -- ── إشعارات: مناطق الإدارة ──────────────────────────────
    notify_zone_deleted = 'تم حذف المنطقة',
    notify_zone_deleted_desc = 'أزلت المنطقة بنجاح: %s.',
    notify_zone_not_deleted_desc = 'حدث خطأ أثناء محاولة حذف المنطقة: %s.',
    notify_zone_edited = 'تم تعديل المنطقة',
    notify_zone_edited_desc = 'عدّلت المنطقة بنجاح: %s.',
    notify_zone_not_edited_desc = 'حدث خطأ أثناء محاولة تعديل المنطقة: %s.',
    notify_zone_action_cancelled = 'تم إلغاء الإجراء',
    notify_zone_delete_cancel = 'ألغيت حذف المنطقة: %s',
    notify_zone_no_weapons = 'الأسلحة غير مسموحة',
    notify_zone_no_weapons_desc = 'غير مسموح لك باستخدام الأسلحة داخل هذه المنطقة.',
    notify_zones_not_found = 'لا توجد مناطق',
    notify_zones_not_found_desc = 'لا توجد حاليًا مناطق نشطة لإدارتها.',
    notify_zones_teleport = 'تم الانتقال',
    notify_zones_teleport_desc = 'انتقلت بنجاح إلى المنطقة: %s.',

    -- ── إشعارات: رفع الحظر ──────────────────────────────────
    successfully_unbanned = 'تم إلغاء الحظر',
    successfully_unbanned_desc = 'رفعت الحظر بنجاح عن: %s.',
    unsuccessful_unban = 'حدث خطأ أثناء محاولة رفع الحظر عن: %s.',

    -- ── الاتصال (deferrals) ─────────────────────────────────
    deferral_welcome = '[%s] مرحبًا %s، جارٍ التحقق من الحظر. . .',
    deferral_banned = 'أنت محظور من هذا السيرفر. السبب: «%s» (الوقت المتبقي: %s ساعة %s دقيقة).',
    deferral_banned_perm = 'أنت محظور من هذا السيرفر. السبب: «%s» (الوقت المتبقي: دائم).',

    -- ── الأخطاء ─────────────────────────────────────────────
    notify_error = 'خطأ',
    notify_disabled_keys = 'لا يوجد سكربت مفاتيح مركبات مُعد. تواصل مع مطور السيرفر.',
    notify_no_appearance = 'لم يتم اكتشاف سكربت ملابس / مظهر. تواصل مع مطور السيرفر.',
    notify_no_vehicle = 'لم يتم العثور على مركبة!',
    notify_invalid_entry = 'إدخال غير صالح!',

    -- ── اختصار لوحة المفاتيح ────────────────────────────────
    keymapping_desc = 'فتح قائمة الإدارة (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'تم تفعيل NoClip',
    noclip_deactivated = 'تم إيقاف NoClip',

    -- ── الاختفاء ────────────────────────────────────────────
    invisibility_activated = 'تم تفعيل وضع الاختفاء',
    invisibility_deactivated = 'تم إيقاف وضع الاختفاء',

    -- ── وضع الخلود ──────────────────────────────────────────
    godmode_activated = 'تم تفعيل وضع الخلود',
    godmode_deactivated = 'تم إيقاف وضع الخلود',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'تم تفعيل Wallhack',
    wallhack_deactivated = 'تم إيقاف Wallhack',

    -- ── وضع التصحيح ─────────────────────────────────────────
    debug_activated = 'تم تفعيل وضع التصحيح',
    debug_deactivated = 'تم إيقاف وضع التصحيح',

    -- ── إشعارات: المركبات ───────────────────────────────────
    vehicle_repaired = 'تم إصلاح المركبة',
    vehicle_repaired_desc = 'تم إصلاح المركبة بنجاح.',
    vehicle_deleted = 'تم حذف المركبة',
    vehicle_deleted_desc = 'تم حذف المركبة بنجاح.',
    vehicle_spawned = 'تم استدعاء المركبة',
    vehicle_spawned_desc = 'تم استدعاء المركبة %s بنجاح.',
    vehicle_plate_changed = 'تم تغيير اللوحة',
    vehicle_plate_changed_desc = 'تم تغيير لوحة المركبة إلى: %s',
    vehicle_refueled = 'تم تعبئة الوقود',
    vehicle_refueled_desc = 'تم تعبئة وقود المركبة بنجاح.',
    vehicle_keys_given = 'تم استلام المفاتيح',
    vehicle_keys_given_desc = 'استلمت مفاتيح المركبة ذات اللوحة: %s',
    vehicle_color_changed = 'تم تغيير لون المركبة',
    vehicle_color_changed_desc = 'تم تغيير لون المركبة إلى: %s',
    vehicle_torque_set = 'تم ضبط مضاعف العزم',
    vehicle_torque_set_desc = 'تم ضبط العزم على: %sx',
    vehicle_torque_disabled = 'تم إيقاف مضاعف العزم',

    -- ── المراقبة ────────────────────────────────────────────
    spectate_started = 'جارٍ المراقبة',
    spectate_started_desc = 'أنت تراقب %s. اضغط X للإيقاف.',
    spectate_ended = 'انتهت المراقبة',
    spectate_ended_desc = 'لم تعد تراقب أحدًا.',
    spectate_error = 'خطأ في المراقبة',
    spectate_error_desc = 'اللاعب المستهدف غير موجود أو لم يعد متصلاً.',

    -- ── الانتقال ────────────────────────────────────────────
    teleport_success = 'تم الانتقال',
    teleport_success_desc = 'تم نقلك بنجاح.',

    -- ── الإنعاش / العلاج ────────────────────────────────────
    player_revived = 'تم إنعاش اللاعب',
    player_revived_desc = 'أنعشت %s بنجاح.',
    player_healed = 'تم علاج اللاعب',
    player_healed_desc = 'عالجت %s بنجاح.',
    self_revived = 'تم الإنعاش',
    self_revived_desc = 'أنعشت نفسك.',
    self_healed = 'تم العلاج',
    self_healed_desc = 'عالجت نفسك.',

    -- ── الشخصيات ────────────────────────────────────────────
    ped_changed = 'تم تغيير الشخصية',
    ped_changed_desc = 'تم تغيير موديل شخصيتك.',
    ped_restored = 'تمت استعادة الشخصية',
    ped_restored_desc = 'تمت استعادة موديل شخصيتك الأصلي.',

    skin_menu_opened = 'تم فتح قائمة الملابس',

    admin_menu_opened = 'تم فتح قائمة الإدارة',
    admin_menu_closed = 'تم إغلاق قائمة الإدارة',

    entity_deleted = 'تم حذف الكيان',
    entity_deleted_desc = 'تم حذف الكيان بنجاح.',

    player_frozen = 'تم تجميد اللاعب',
    player_frozen_desc = 'تم تجميد اللاعب %s.',
    player_unfrozen = 'تم إلغاء تجميد اللاعب',
    player_unfrozen_desc = 'تم إلغاء تجميد اللاعب %s.',

    -- ── لوحة مخصصة ──────────────────────────────────────────
    dialog_license_plate = 'لوحة مخصصة',
    dialog_license_plate_label = 'اللوحة',
    dialog_license_plate_placeholder = 'اللوحة',

    -- ── سحب الأموال ─────────────────────────────────────────
    player_removemoney = 'سحب أموال',
    player_removemoney_desc = 'سحب أموال من اللاعب المحدد',
    dialog_removemoney = 'سحب أموال',
    removemoney_input_label = 'المبلغ',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'الحساب',
    notify_removemoney_success = 'تم سحب الأموال',
    notify_removemoney_success_desc = 'سحبت $%s من %s (الحساب: %s)',
    notify_removemoney_fail = 'فشل',
    notify_removemoney_fail_desc = 'تعذّر سحب الأموال من %s (ربما الرصيد غير كافٍ).',

    -- ── الأبعاد / routing buckets ───────────────────────────
    self_dimension = 'تحديد بُعدي',
    self_dimension_desc = 'انقل نفسك إلى routing bucket (0 = العالم الرئيسي)',
    player_dimension = 'تحديد البُعد',
    player_dimension_desc = 'انقل هذا اللاعب إلى routing bucket',
    player_dimension_bring = 'إحضار إلى بُعدي',
    player_dimension_bring_desc = 'اسحب هذا اللاعب إلى بُعدك الحالي',
    player_dimension_goto = 'الانضمام إلى بُعد اللاعب',
    player_dimension_goto_desc = 'انقل نفسك إلى بُعد هذا اللاعب',
    dialog_dimension = 'تحديد البُعد',
    dimension_input_label = 'البُعد (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'تم تغيير البُعد',
    notify_dimension_self_desc = 'أنت الآن في البُعد %s.',
    notify_dimension_player_desc = 'تم نقل %s إلى البُعد %s.',
    notify_dimension_join_desc = 'انضممت إلى بُعد %s (%s).',
    notify_dimension_fail = 'خطأ في البُعد',
    notify_dimension_fail_desc = 'تعذّر تغيير البُعد.',

    -- ── الانتقال داخل المركبة ───────────────────────────────
    player_tp_vehicle = 'الانتقال داخل المركبة',
    player_tp_vehicle_desc = 'ادخل مركبة هذا اللاعب للمساعدة في إخراجها',
    notify_tp_vehicle_fail = 'لا توجد مركبة',
    notify_tp_vehicle_fail_desc = '%s ليس داخل مركبة.',
    notify_tp_vehicle_success = 'تم الانتقال',
    notify_tp_vehicle_success_desc = 'تم وضعك داخل مركبة %s.',

    -- ── إنقاذ المركبة ───────────────────────────────────────
    recover_car = 'إنقاذ / تعديل المركبة',
    recover_car_desc = 'إعادتها على عجلاتها ونقلها إلى أقرب طريق (البحر/الانقلاب)',
    vehicle_recovered = 'تم إنقاذ المركبة',
    vehicle_recovered_desc = 'تم تعديل المركبة ووضعها على أقرب طريق.',

    -- ── المركبات المملوكة ───────────────────────────────────
    player_owned_vehicles = 'المركبات المملوكة',
    player_owned_vehicles_desc = 'عرض أو إضافة أو إزالة سيارات هذا اللاعب',
    owned_vehicles_menu = 'المركبات المملوكة (%s)',
    owned_vehicles_add = 'إضافة مركبة',
    owned_vehicles_add_desc = 'إضافة مركبة إلى كراج هذا اللاعب',
    owned_vehicles_none = 'لا توجد مركبات',
    owned_vehicles_none_desc = 'هذا اللاعب لا يملك أي مركبة.',
    owned_vehicle_desc = 'اللوحة: %s · اضغط للإزالة',
    dialog_add_vehicle = 'إضافة مركبة',
    add_vehicle_model_label = 'اسم الموديل',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'اللوحة (اختياري)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'إزالة %s؟',
    notify_owned_added = 'تمت إضافة المركبة',
    notify_owned_added_desc = 'تمت إضافة %s (اللوحة %s) إلى %s.',
    notify_owned_removed = 'تمت إزالة المركبة',
    notify_owned_removed_desc = 'تمت إزالة اللوحة %s من %s.',
    notify_owned_fail = 'خطأ في قاعدة البيانات',
    notify_owned_fail_desc = 'فشلت العملية على قاعدة بيانات المركبات.',

    -- ── قائمة الشخصيات ──────────────────────────────────────
    player_pedmenu = 'إعطاء قائمة الشخصيات',
    player_pedmenu_desc = 'فتح قائمة اختيار الشخصية على شاشة هذا اللاعب',
    pedmenu_title = 'قائمة الشخصيات',
    pedmenu_given = 'تم إرسال قائمة الشخصيات',
    pedmenu_given_desc = 'تم فتح قائمة الشخصيات لـ %s.'
}
