-- ============================================================
-- 简体中文 (zh)
-- ------------------------------------------------------------
-- 覆盖在 configs/strings.lua 之上的语言层。此处缺少的任何键都会
-- 自动保留英文原文，因此部分翻译是安全的。
--
-- %s 占位符必须保留，且顺序要与原文完全一致：它们由代码中的
-- :format() 填充。%% 会输出一个字面的百分号。
--
-- 启用方式：Config.Locale = 'zh'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['zh'] = {
    -- ── 主菜单 ──────────────────────────────────────────────
    main_title = '管理员菜单',
    self_options = '自身选项',
    self_options_desc = '与你自己相关的选项',
    player_options_title = '玩家选项',
    player_options_desc = '与其他玩家相关的选项',
    vehicle_options = '载具选项',
    vehicle_options_desc = '与载具相关的选项',
    server_options = '服务器选项',
    server_options_desc = '与服务器相关的选项',
    admin_zone_options = '管理区域',
    admin_zone_options_desc = '管理、添加和删除管理区域',
    developer_options = '开发者选项',
    developer_options_desc = '',

    -- ── 自身选项 ────────────────────────────────────────────
    self_options_menu = '自身选项',
    self_health = '生命值 (%s%%)',
    self_noclip = '穿墙模式',
    self_revive = '复活',
    self_revive_desc = '复活你自己',
    self_heal = '治疗',
    self_heal_desc = '治疗你自己',
    self_skinmenu = '服装菜单',
    self_set_ped = '更换角色模型',
    self_skinmenu_desc = '在本地打开服装菜单',
    self_invisible = '隐身',
    self_godmode = '上帝模式',
    self_wallhack = '透视',

    -- ── 玩家选项 ────────────────────────────────────────────
    player_options_menu = '在线玩家 %s/%s',
    player_options = '玩家：%s',
    player_health = '玩家生命值 (%s%%)',
    player_freeze = '冻结',
    player_freeze_desc = '开启/关闭',
    player_noclip = '穿墙模式',
    player_noclip_desc = '开启/关闭',
    player_spectate = '观察',
    player_spectate_desc = '观察该玩家的行为',
    player_playerdata = '玩家数据',
    player_playerdata_desc = '查看该玩家的数据',
    player_revive = '复活',
    player_revive_desc = '复活该玩家',
    player_heal = '治疗',
    player_heal_desc = '治疗该玩家',
    player_skinmenu = '服装菜单',
    player_skinmenu_desc = '在该玩家处打开服装菜单',
    player_money = '给予金钱',
    player_money_desc = '给选中的玩家发放金钱',
    player_item = '给予物品',
    player_item_desc = '给选中的玩家发放物品',
    player_openinv = '打开背包',
    player_openinv_desc = '打开该玩家的背包',
    player_clearinv = '清空背包',
    player_clearinv_desc = '清空该玩家的背包',
    player_teleport_to = '传送到玩家',
    player_teleport_to_desc = '传送到该玩家身边',
    player_bring = '拉过来',
    player_bring_desc = '把该玩家拉到你的位置',
    player_kick = '踢出',
    player_kick_desc = '把该玩家踢出服务器',
    player_ban = '封禁玩家',

    -- ── 载具菜单 ────────────────────────────────────────────
    vehicle_menu = '载具菜单',
    spawn_car = '生成载具',
    spawn_car_desc = '生成一辆载具',
    repair_car = '维修载具',
    repair_car_desc = '维修当前或最近的载具',
    delete_car = '删除载具',
    delete_car_desc = '删除当前或最近的载具',
    number_plate = '修改车牌',
    number_plate_desc = '修改当前车牌上的文字',
    refuel = '加满油',
    refuel_desc = '给当前或最近的载具加满油',
    give_keys = '给予钥匙',
    give_keys_desc = '把当前载具的钥匙给自己',
    doors = '上锁/解锁车门',
    doors_desc = '切换最近载具的车锁状态',
    boost_car = '扭矩倍率',
    boost_car_desc = '修改当前载具的扭矩',
    color_change = '更改载具颜色',
    color_change_desc = '更改当前或最近载具的颜色',

    -- ── 服务器管理 ──────────────────────────────────────────
    server_management = '服务器管理',
    server_announcement = '服务器公告',
    server_announcement_desc = '向整个服务器发送全服公告',
    ban_list = '封禁列表',
    ban_list_desc = '查看所有生效中的封禁',
    objects_list = '删除实体',
    objects_list_desc = '删除载具和 NPC',
    objects_list_label = '选项',
    weather_menu = '天气管理',
    weather_menu_desc = '管理天气',

    -- ── 管理区域 ────────────────────────────────────────────
    zones_create = '创建区域',
    zones_create_desc = '创建一个新的管理区域',
    zones_manage = '管理区域',
    zones_manage_desc = '编辑或删除生效中的区域',
    zone_edit_current = '编辑当前区域',
    zone_edit_current_desc = '管理你所在的区域',
    zone_delete_current = '删除当前区域',
    zone_delete_current_desc = '删除你所在的区域',
    zone_manage_menu = '正在编辑区域 (%s)',
    zone_edit = '编辑区域',
    zone_edit_desc = '修改区域：%s',
    zone_delete = '删除区域',
    zone_delete_desc = '删除区域：%s',
    zone_teleport = '传送到区域',
    zone_teleport_desc = '前往区域：%s',

    -- ── 开发者菜单 ──────────────────────────────────────────
    dev_options = '开发者选项',
    debug_mode = '调试模式',
    debug_mode_desc = '开启/关闭调试模式',
    copy_vec3 = '复制 Vector3 坐标',
    copy_vec3_desc = '把你当前的位置 (vector3) 复制到剪贴板',
    copy_vec4 = '复制 Vector4 坐标',
    copy_vec4_desc = '把你当前的位置 (vector4) 复制到剪贴板',
    copy_heading = '复制朝向',
    copy_heading_desc = '把你当前的朝向复制到剪贴板',
    cant_delete = '无法删除！',
    cant_delete_player_desc = '你不能删除玩家角色！',
    cant_delete_entity_desc = '你不能删除地图上的默认物件！',

    -- ── 封禁列表 ────────────────────────────────────────────
    ban_list_menu = '封禁列表',
    ban_list_name = '名称：%s',
    ban_list_license = '许可证：',
    ban_list_by = '执行者：%s',
    ban_list_reason = '原因：%s',
    ban_list_length = '剩余时间：%s 小时 %s 分钟',
    ban_list_modify = '修改封禁',
    ban_list_unban = '解封玩家',
    ban_list_no_data = '没有封禁',
    ban_list_no_data_desc = '未找到任何生效中的封禁！',

    -- ── 玩家数据 ────────────────────────────────────────────
    playerdata_menu = '玩家数据',
    playerdata_license_esx = '许可证：%s',
    playerdata_license_qbcore = 'Citizen ID：%s',
    playerdata_license_desc = '点击复制完整许可证',
    playerdata_igname = '名称：%s',
    playerdata_igname_desc = '玩家在游戏内的全名',
    playerdata_steam = 'Steam 名称：%s',
    playerdata_steam_desc = '玩家完整的 Steam 名称',
    playerdata_gender = '性别：%s',
    playerdata_gender_desc = '玩家的性别',
    playerdata_cash = '现金：%s',
    playerdata_cash_desc = '玩家的现金余额',
    playerdata_bank = '银行：%s',
    playerdata_bank_desc = '玩家的银行余额',
    playerdata_blackmoney = '黑钱：%s',
    playerdata_blackmoney_desc = '玩家的黑钱余额',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = '按 [E] 删除实体  \nHash：%s  \n坐标：vec3(%s, %s, %s)  \n朝向：%s  \n所有者：[%s] - %s',
    debug_textui_noname = '按 [E] 删除实体\n  Hash：%s\n  坐标：vec3(%s, %s, %s)\n  朝向：%s\n  所有者：未知',

    textui_invisible = '隐身模式 - 已启用',
    textui_godmode = '上帝模式 - 已启用',
    textui_wallhack = '透视 - 已启用',
    textui_noclip_activated = '穿墙模式 - 已启用',
    textui_torque = '扭矩倍率 - %s',

    -- ── 公告 ────────────────────────────────────────────────
    dialog_announce = '公告',
    dialog_announce_label = '消息',
    dialog_announce_select = '所有人',
    dialog_announce_everyone = '所有人',
    dialog_announce_placeholder = '在此填写重要消息. . .',

    -- ── 解封 ────────────────────────────────────────────────
    dialog_unban = '你确定吗？',
    dialog_unban_content = '你真的要解封 %s 吗？',

    -- ── 删除实体 ────────────────────────────────────────────
    dialog_objects = '请选择一个选项',
    dialog_clear_objects = '删除所有物件',
    dialog_clear_cars = '删除所有车辆（无驾驶员）',
    dialog_clear_peds = '删除所有 NPC',

    -- ── 给予金钱 ────────────────────────────────────────────
    dialog_givemoney = '给予金钱',
    givemoney_input_label = '金额',
    givemoney_input_placeholder = '123456',
    givemoney_select = '账户',
    givemoney_select_option1 = '现金',
    givemoney_select_option2 = '银行',
    givemoney_select_option3 = '黑钱',

    -- ── 给予物品 ────────────────────────────────────────────
    dialog_giveitem = '给予物品',
    giveitem_input_label = '物品名称',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = '数量',
    giveitem_amount_input_placeholder = '3',

    -- ── 生成载具 ────────────────────────────────────────────
    dialog_spawn_a_car = '生成载具',
    dialog_car_model = '模型名称',
    dialog_car_model_holder = '例如：20charger',
    dialog_car_plate = '车牌（可选）',
    dialog_car_plate_holder = '例如：W4S4B1',
    dialog_car_color_primary = '主色（可选）',
    dialog_car_color_second = '副色（可选）',
    dialog_car_maxed = '满级改装（可选）',

    -- ── 踢出 ────────────────────────────────────────────────
    dialog_kick = '踢出 %s',
    dialog_kick_reason = '原因',
    dialog_kick_placeholder = '作弊者',
    kicked_reason_replace = '你已被踢出服务器！',

    -- ── 封禁 ────────────────────────────────────────────────
    dialog_ban = '封禁 %s',
    dialog_ban_reason = '原因',
    dialog_ban_placeholder = '作弊者',
    ban_reason_replace = '你已被本服务器封禁！',

    -- ── 创建区域 ────────────────────────────────────────────
    dialog_zone_create = '创建区域',
    dialog_zone_name = '名称',
    dialog_zone_name_desc = '区域 / 地图标记的名称',
    dialog_zone_name_holder = '管理区域',
    dialog_zone_text = '显示文字',
    dialog_zone_text_desc = '显示给区域内玩家的文字',
    dialog_zone_text_holder = '管理区域 - 已启用',
    dialog_zone_size = '大小',
    dialog_zone_speed = '限速',
    mph = '英里/小时',
    kmh = '公里/小时',
    dialog_zone_blip_id = '地图标记 ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = '颜色 ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = '闪烁标记',
    dialog_zone_disarm = '缴械',
    dialog_zone_revive = '复活',
    dialog_zone_invincible = '无敌',
    dialog_zone_edit = '正在编辑「%s」',
    dialog_zone_delete_confirm = '你确定吗？',
    dialog_zone_delete_confirm_desc = '你真的要删除这个区域吗：%s',

    -- ── 通知：金钱 ──────────────────────────────────────────
    notify_givemoney_success = '金钱已发放',
    notify_givemoney_success_desc = '你给 %s 的账户存入了 $%s，账户：%s',
    notify_givemoney_fail = '未成功',
    notify_givemoney_fail_desc = '你尝试给 %s 存钱但出错了！请重试。',

    -- ── 通知：物品 ──────────────────────────────────────────
    notify_giveitem_success = '物品已发放',
    notify_giveitem_success_desc = '你给了 %s。物品：%s 数量：%s',
    notify_giveitem_fail = '失败',
    notify_giveitem_fail_desc = '你尝试给 %s 发放物品但出错了！请重试。',

    -- ── 通知：踢出 / 封禁 ───────────────────────────────────
    notify_kicked_success = '踢出成功',
    notify_kicked_success_desc = '你成功踢出了 %s',
    notify_banned_success = '封禁成功',
    notify_banned_success_desc = '你成功封禁了 %s',

    -- ── 通知：背包 ──────────────────────────────────────────
    notify_clearedinv = '背包已清空',
    notify_clearedinv_desc = '你成功清空了 %s 的背包',

    -- ── 通知：无效 ID ───────────────────────────────────────
    notify_invalidid = '无效 ID',
    notify_invalidid_desc = '你输入的 ID 无效，请重试。',

    -- ── 通知：清理 ──────────────────────────────────────────
    notify_deleted_car = '车辆已删除',
    notify_deleted_car_desc = '你成功删除了所有无驾驶员的车辆。',
    notify_deleted_ped = 'NPC 已删除',
    notify_deleted_ped_desc = '你成功删除了地图上的所有 NPC',
    notify_deleted_objects = '物件已删除',
    notify_deleted_objects_desc = '你成功删除了地图上的所有物件',

    -- ── 通知：天气 ──────────────────────────────────────────
    notify_weather = '天气已修改',
    notify_weather_desc = '天气已改为：%s',

    -- ── 通知：复制坐标 ──────────────────────────────────────
    notify_copied = '已复制',
    notify_copied_vec3 = '已成功把 vector3 复制到剪贴板！',
    notify_copied_vec4 = '已成功把 vector4 复制到剪贴板！',
    notify_copied_headin = '已成功把朝向复制到剪贴板！',

    -- ── 通知：车门 ──────────────────────────────────────────
    notify_locked_doors = '已上锁',
    notify_locked_doors_desc = '载具车门已成功上锁。',
    notify_unlocked_doors = '已解锁',
    notify_unlocked_doors_desc = '载具车门已成功解锁。',

    -- ── 通知：管理区域 ──────────────────────────────────────
    notify_zone_deleted = '区域已删除',
    notify_zone_deleted_desc = '你成功移除了区域：%s。',
    notify_zone_not_deleted_desc = '删除区域时发生错误：%s。',
    notify_zone_edited = '区域已修改',
    notify_zone_edited_desc = '你成功修改了区域：%s。',
    notify_zone_not_edited_desc = '修改区域时发生错误：%s。',
    notify_zone_action_cancelled = '操作已取消',
    notify_zone_delete_cancel = '你取消了删除区域：%s',
    notify_zone_no_weapons = '禁止使用武器',
    notify_zone_no_weapons_desc = '你不被允许在此区域内使用武器。',
    notify_zones_not_found = '没有区域',
    notify_zones_not_found_desc = '目前没有可管理的生效区域。',
    notify_zones_teleport = '已传送',
    notify_zones_teleport_desc = '你已成功传送到区域：%s。',

    -- ── 通知：解封 ──────────────────────────────────────────
    successfully_unbanned = '封禁已撤销',
    successfully_unbanned_desc = '你成功解封了：%s。',
    unsuccessful_unban = '尝试解封时出错：%s。',

    -- ── 连接（deferral） ────────────────────────────────────
    deferral_welcome = '[%s] 你好 %s，正在检查封禁记录. . .',
    deferral_banned = '你已被本服务器封禁。原因：「%s」（剩余时间：%s 小时 %s 分钟）。',
    deferral_banned_perm = '你已被本服务器封禁。原因：「%s」（剩余时间：永久）。',

    -- ── 错误 ────────────────────────────────────────────────
    notify_error = '错误',
    notify_disabled_keys = '未配置任何车钥匙脚本。请联系服务器开发者。',
    notify_no_appearance = '未检测到服装 / 外观脚本。请联系服务器开发者。',
    notify_no_vehicle = '未找到载具！',
    notify_invalid_entry = '输入无效！',

    -- ── 快捷键 ──────────────────────────────────────────────
    keymapping_desc = '打开管理员菜单 (apex_adminmenu)',

    -- ── 穿墙模式 ────────────────────────────────────────────
    noclip_activated = '穿墙模式已开启',
    noclip_deactivated = '穿墙模式已关闭',

    -- ── 隐身 ────────────────────────────────────────────────
    invisibility_activated = '隐身模式已开启',
    invisibility_deactivated = '隐身模式已关闭',

    -- ── 上帝模式 ────────────────────────────────────────────
    godmode_activated = '上帝模式已开启',
    godmode_deactivated = '上帝模式已关闭',

    -- ── 透视 ────────────────────────────────────────────────
    wallhack_activated = '透视已开启',
    wallhack_deactivated = '透视已关闭',

    -- ── 调试模式 ────────────────────────────────────────────
    debug_activated = '调试模式已开启',
    debug_deactivated = '调试模式已关闭',

    -- ── 通知：载具 ──────────────────────────────────────────
    vehicle_repaired = '载具已维修',
    vehicle_repaired_desc = '载具已成功维修。',
    vehicle_deleted = '载具已删除',
    vehicle_deleted_desc = '载具已成功删除。',
    vehicle_spawned = '载具已生成',
    vehicle_spawned_desc = '载具 %s 已成功生成。',
    vehicle_plate_changed = '车牌已更改',
    vehicle_plate_changed_desc = '载具车牌已改为：%s',
    vehicle_refueled = '载具已加油',
    vehicle_refueled_desc = '载具已成功加满油。',
    vehicle_keys_given = '已获得钥匙',
    vehicle_keys_given_desc = '你已获得车牌为 %s 的载具钥匙',
    vehicle_color_changed = '载具颜色已更改',
    vehicle_color_changed_desc = '载具颜色已改为：%s',
    vehicle_torque_set = '扭矩倍率已设置',
    vehicle_torque_set_desc = '扭矩已设为：%sx',
    vehicle_torque_disabled = '扭矩倍率已关闭',

    -- ── 观察 ────────────────────────────────────────────────
    spectate_started = '观察中',
    spectate_started_desc = '正在观察 %s。按 X 结束。',
    spectate_ended = '观察已结束',
    spectate_ended_desc = '你已不再观察任何人。',
    spectate_error = '观察错误',
    spectate_error_desc = '未找到目标玩家或该玩家已不存在。',

    -- ── 传送 ────────────────────────────────────────────────
    teleport_success = '已传送',
    teleport_success_desc = '你已成功传送。',

    -- ── 复活 / 治疗 ─────────────────────────────────────────
    player_revived = '玩家已复活',
    player_revived_desc = '你成功复活了 %s。',
    player_healed = '玩家已治疗',
    player_healed_desc = '你成功治疗了 %s。',
    self_revived = '已复活',
    self_revived_desc = '你复活了自己。',
    self_healed = '已治疗',
    self_healed_desc = '你治疗了自己。',

    -- ── 角色模型 ────────────────────────────────────────────
    ped_changed = '角色模型已更换',
    ped_changed_desc = '你的角色模型已被更换。',
    ped_restored = '角色模型已还原',
    ped_restored_desc = '你原本的角色模型已还原。',

    skin_menu_opened = '服装菜单已打开',

    admin_menu_opened = '管理员菜单已打开',
    admin_menu_closed = '管理员菜单已关闭',

    entity_deleted = '实体已删除',
    entity_deleted_desc = '该实体已成功删除。',

    player_frozen = '玩家已冻结',
    player_frozen_desc = '玩家 %s 已被冻结。',
    player_unfrozen = '玩家已解冻',
    player_unfrozen_desc = '玩家 %s 已被解冻。',

    -- ── 自定义车牌 ──────────────────────────────────────────
    dialog_license_plate = '自定义车牌',
    dialog_license_plate_label = '车牌',
    dialog_license_plate_placeholder = '车牌',

    -- ── 扣除金钱 ────────────────────────────────────────────
    player_removemoney = '扣除金钱',
    player_removemoney_desc = '从选中的玩家身上扣除金钱',
    dialog_removemoney = '扣除金钱',
    removemoney_input_label = '金额',
    removemoney_input_placeholder = '123456',
    removemoney_select = '账户',
    notify_removemoney_success = '金钱已扣除',
    -- 参数顺序必须与英文一致：金额、玩家、账户。
    notify_removemoney_success_desc = '你扣除了 $%s，来自 %s（账户：%s）',
    notify_removemoney_fail = '未成功',
    notify_removemoney_fail_desc = '无法从 %s 扣除金钱（可能余额不足）。',

    -- ── 维度 / routing bucket ───────────────────────────────
    self_dimension = '设置我的维度',
    self_dimension_desc = '把自己移动到某个 routing bucket（0 = 主世界）',
    player_dimension = '设置维度',
    player_dimension_desc = '把该玩家移动到某个 routing bucket',
    player_dimension_bring = '拉入我的维度',
    player_dimension_bring_desc = '把该玩家拉进你当前的维度',
    player_dimension_goto = '加入玩家的维度',
    player_dimension_goto_desc = '把自己移动到该玩家的维度',
    dialog_dimension = '设置维度',
    dimension_input_label = '维度 (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = '维度已更改',
    notify_dimension_self_desc = '你现在位于维度 %s。',
    notify_dimension_player_desc = '%s 已被移动到维度 %s。',
    notify_dimension_join_desc = '你加入了 %s 的维度 (%s)。',
    notify_dimension_fail = '维度错误',
    notify_dimension_fail_desc = '无法更改维度。',

    -- ── 传送进载具 ──────────────────────────────────────────
    player_tp_vehicle = '传送进载具',
    player_tp_vehicle_desc = '进入该玩家的载具以帮助救援',
    notify_tp_vehicle_fail = '没有载具',
    notify_tp_vehicle_fail_desc = '%s 不在载具内。',
    notify_tp_vehicle_success = '已传送',
    notify_tp_vehicle_success_desc = '你已被放进 %s 的载具内。',

    -- ── 救援载具 ────────────────────────────────────────────
    recover_car = '救援 / 翻正载具',
    recover_car_desc = '翻正并移动到最近的道路（落水/翻车）',
    vehicle_recovered = '载具已救援',
    vehicle_recovered_desc = '载具已翻正并放置到最近的道路上。',

    -- ── 名下载具 ────────────────────────────────────────────
    player_owned_vehicles = '名下载具',
    player_owned_vehicles_desc = '查看、添加或移除该玩家的车辆',
    owned_vehicles_menu = '名下载具 (%s)',
    owned_vehicles_add = '添加载具',
    owned_vehicles_add_desc = '向该玩家的车库添加一辆载具',
    owned_vehicles_none = '没有载具',
    owned_vehicles_none_desc = '该玩家名下没有任何载具。',
    owned_vehicle_desc = '车牌：%s · 点击移除',
    dialog_add_vehicle = '添加载具',
    add_vehicle_model_label = '模型名称',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = '车牌（可选）',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '移除 %s？',
    notify_owned_added = '载具已添加',
    notify_owned_added_desc = '已把 %s（车牌 %s）添加给 %s。',
    notify_owned_removed = '载具已移除',
    -- 参数顺序必须与英文一致：车牌、玩家。
    notify_owned_removed_desc = '车牌 %s 已从 %s 移除。',
    notify_owned_fail = '数据库错误',
    notify_owned_fail_desc = '载具数据库操作失败。',

    -- ── 角色模型菜单 ────────────────────────────────────────
    player_pedmenu = '给予角色模型菜单',
    player_pedmenu_desc = '在该玩家的屏幕上打开角色模型选择菜单',
    pedmenu_title = '角色模型菜单',
    pedmenu_given = '角色模型菜单已发送',
    pedmenu_given_desc = '已为 %s 打开角色模型菜单。'
}
