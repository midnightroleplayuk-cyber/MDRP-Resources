-- ============================================================
-- 日本語 (ja)
-- ------------------------------------------------------------
-- configs/strings.lua に重ねるレイヤーです。ここに無いキーは
-- 自動的に英語のまま残るため、部分的な翻訳でも安全です。
--
-- %s のプレースホルダーは必ず残し、順序も原文と同じにして
-- ください。コード側の :format() が埋めます。%% はパーセント
-- 記号そのものを出力します。
--
-- 有効化：Config.Locale = 'ja'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['ja'] = {
    -- ── メインメニュー ──────────────────────────────────────
    main_title = '管理メニュー',
    self_options = '自分の設定',
    self_options_desc = '自分に関する設定',
    player_options_title = 'プレイヤー設定',
    player_options_desc = '他のプレイヤーに関する設定',
    vehicle_options = '車両設定',
    vehicle_options_desc = '車両に関する設定',
    server_options = 'サーバー設定',
    server_options_desc = 'サーバーに関する設定',
    admin_zone_options = '管理ゾーン',
    admin_zone_options_desc = '管理ゾーンの管理・追加・削除',
    developer_options = '開発者設定',
    developer_options_desc = '',

    -- ── 自分の設定 ──────────────────────────────────────────
    self_options_menu = '自分の設定',
    self_health = '体力 (%s%%)',
    self_noclip = 'ノークリップ',
    self_revive = '蘇生',
    self_revive_desc = '自分を蘇生する',
    self_heal = '回復',
    self_heal_desc = '自分を回復する',
    self_skinmenu = '服装メニュー',
    self_set_ped = 'Ped を変更',
    self_skinmenu_desc = '服装メニューをローカルで開く',
    self_invisible = '透明化',
    self_godmode = 'ゴッドモード',
    self_wallhack = 'ウォールハック',

    -- ── プレイヤー設定 ──────────────────────────────────────
    player_options_menu = 'オンラインのプレイヤー %s/%s',
    player_options = 'プレイヤー: %s',
    player_health = 'プレイヤーの体力 (%s%%)',
    player_freeze = '固定',
    player_freeze_desc = 'オン/オフ',
    player_noclip = 'ノークリップ',
    player_noclip_desc = 'オン/オフ',
    player_spectate = '観戦',
    player_spectate_desc = 'このプレイヤーの行動を観察する',
    player_playerdata = 'プレイヤー情報',
    player_playerdata_desc = 'プレイヤーの情報を表示',
    player_revive = '蘇生',
    player_revive_desc = 'プレイヤーを蘇生する',
    player_heal = '回復',
    player_heal_desc = 'プレイヤーを回復する',
    player_skinmenu = '服装メニュー',
    player_skinmenu_desc = 'プレイヤーの画面に服装メニューを開く',
    player_money = 'お金を渡す',
    player_money_desc = '選択したプレイヤーにお金を渡す',
    player_item = 'アイテムを渡す',
    player_item_desc = '選択したプレイヤーにアイテムを渡す',
    player_openinv = 'インベントリを開く',
    player_openinv_desc = 'プレイヤーのインベントリを開く',
    player_clearinv = 'インベントリを空にする',
    player_clearinv_desc = 'プレイヤーのインベントリを空にする',
    player_teleport_to = 'プレイヤーへテレポート',
    player_teleport_to_desc = 'プレイヤーの所へテレポートする',
    player_bring = '呼び寄せる',
    player_bring_desc = 'プレイヤーを自分の位置へ呼び寄せる',
    player_kick = 'キック',
    player_kick_desc = 'プレイヤーをサーバーからキックする',
    player_ban = 'プレイヤーをBAN',

    -- ── 車両メニュー ────────────────────────────────────────
    vehicle_menu = '車両メニュー',
    spawn_car = '車両をスポーン',
    spawn_car_desc = '車両をスポーンする',
    repair_car = '車両を修理',
    repair_car_desc = '現在または最も近い車両を修理する',
    delete_car = '車両を削除',
    delete_car_desc = '現在または最も近い車両を削除する',
    number_plate = 'ナンバープレートを変更',
    number_plate_desc = '現在のナンバープレートの文字を変更する',
    refuel = '車両に給油',
    refuel_desc = '現在または最も近い車両に給油する',
    give_keys = '鍵を渡す',
    give_keys_desc = '現在の車両の鍵を自分に渡す',
    doors = 'ドアを施錠/解錠',
    doors_desc = '最も近い車両のロックを切り替える',
    boost_car = 'トルク倍率',
    boost_car_desc = '現在の車両のトルクを変更する',
    color_change = '車両の色を変更',
    color_change_desc = '現在または最も近い車両の色を変更する',

    -- ── サーバー管理 ────────────────────────────────────────
    server_management = 'サーバー管理',
    server_announcement = 'サーバーアナウンス',
    server_announcement_desc = 'サーバー全体にアナウンスを送信する',
    ban_list = 'BANリスト',
    ban_list_desc = '有効なBANをすべて確認する',
    objects_list = 'エンティティを削除',
    objects_list_desc = '車両とPedを削除する',
    objects_list_label = 'オプション',
    weather_menu = '天候管理',
    weather_menu_desc = '天候を管理する',

    -- ── 管理ゾーン ──────────────────────────────────────────
    zones_create = 'ゾーンを作成',
    zones_create_desc = '新しい管理ゾーンを作成する',
    zones_manage = 'ゾーンを管理',
    zones_manage_desc = '有効なゾーンを編集または削除する',
    zone_edit_current = '現在のゾーンを編集',
    zone_edit_current_desc = '今いるゾーンを管理する',
    zone_delete_current = '現在のゾーンを削除',
    zone_delete_current_desc = '今いるゾーンを削除する',
    zone_manage_menu = 'ゾーンを編集中 (%s)',
    zone_edit = 'ゾーンを編集',
    zone_edit_desc = 'ゾーンを変更: %s',
    zone_delete = 'ゾーンを削除',
    zone_delete_desc = 'ゾーンを削除: %s',
    zone_teleport = 'ゾーンへテレポート',
    zone_teleport_desc = 'ゾーンへ移動: %s',

    -- ── 開発者メニュー ──────────────────────────────────────
    dev_options = '開発者設定',
    debug_mode = 'デバッグモード',
    debug_mode_desc = 'デバッグモードのオン/オフ',
    copy_vec3 = 'Vector3 座標をコピー',
    copy_vec3_desc = '現在位置 (vector3) をクリップボードにコピーします',
    copy_vec4 = 'Vector4 座標をコピー',
    copy_vec4_desc = '現在位置 (vector4) をクリップボードにコピーします',
    copy_heading = '向きをコピー',
    copy_heading_desc = '現在の向きをクリップボードにコピーします',
    cant_delete = '削除できません!',
    cant_delete_player_desc = 'プレイヤーのPedは削除できません!',
    cant_delete_entity_desc = 'マップ既定のオブジェクトは削除できません!',

    -- ── BANリスト ───────────────────────────────────────────
    ban_list_menu = 'BANリスト',
    ban_list_name = '名前: %s',
    ban_list_license = 'ライセンス:',
    ban_list_by = '実行者: %s',
    ban_list_reason = '理由: %s',
    ban_list_length = '残り時間: %s 時間 %s 分',
    ban_list_modify = 'BANを変更',
    ban_list_unban = 'プレイヤーのBANを解除',
    ban_list_no_data = 'BANなし',
    ban_list_no_data_desc = '有効なBANは見つかりませんでした!',

    -- ── プレイヤー情報 ──────────────────────────────────────
    playerdata_menu = 'プレイヤー情報',
    playerdata_license_esx = 'ライセンス: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'クリックでライセンス全体をコピー',
    playerdata_igname = '名前: %s',
    playerdata_igname_desc = 'ゲーム内でのプレイヤーのフルネーム',
    playerdata_steam = 'Steam名: %s',
    playerdata_steam_desc = 'プレイヤーのSteam名（フル）',
    playerdata_gender = '性別: %s',
    playerdata_gender_desc = 'プレイヤーの性別',
    playerdata_cash = '現金: %s',
    playerdata_cash_desc = 'プレイヤーの現金残高',
    playerdata_bank = '銀行: %s',
    playerdata_bank_desc = 'プレイヤーの銀行残高',
    playerdata_blackmoney = '闇金: %s',
    playerdata_blackmoney_desc = 'プレイヤーの闇金残高',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = '[E] キーでエンティティを削除  \nHash: %s  \n座標: vec3(%s, %s, %s)  \n向き: %s  \n所有者: [%s] - %s',
    debug_textui_noname = '[E] キーでエンティティを削除\n  Hash: %s\n  座標: vec3(%s, %s, %s)\n  向き: %s\n  所有者: 不明',

    textui_invisible = '透明化モード - 有効',
    textui_godmode = 'ゴッドモード - 有効',
    textui_wallhack = 'ウォールハック - 有効',
    textui_noclip_activated = 'ノークリップ - 有効',
    textui_torque = 'トルク倍率 - %s',

    -- ── アナウンス ──────────────────────────────────────────
    dialog_announce = 'アナウンス',
    dialog_announce_label = 'メッセージ',
    dialog_announce_select = '全員',
    dialog_announce_everyone = '全員',
    dialog_announce_placeholder = 'ここに重要なメッセージを. . .',

    -- ── BAN解除 ─────────────────────────────────────────────
    dialog_unban = '本当によろしいですか?',
    dialog_unban_content = '本当に %s のBANを解除しますか?',

    -- ── エンティティ削除 ────────────────────────────────────
    dialog_objects = 'オプションを選択',
    dialog_clear_objects = 'すべてのオブジェクトを削除',
    dialog_clear_cars = 'すべての車両を削除（運転手なし）',
    dialog_clear_peds = 'すべてのPedを削除',

    -- ── お金を渡す ──────────────────────────────────────────
    dialog_givemoney = 'お金を渡す',
    givemoney_input_label = '金額',
    givemoney_input_placeholder = '123456',
    givemoney_select = '口座',
    givemoney_select_option1 = '現金',
    givemoney_select_option2 = '銀行',
    givemoney_select_option3 = '闇金',

    -- ── アイテムを渡す ──────────────────────────────────────
    dialog_giveitem = 'アイテムを渡す',
    giveitem_input_label = 'アイテム名',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = '個数',
    giveitem_amount_input_placeholder = '3',

    -- ── 車両スポーン ────────────────────────────────────────
    dialog_spawn_a_car = '車両をスポーン',
    dialog_car_model = 'モデル名',
    dialog_car_model_holder = '例: 20charger',
    dialog_car_plate = 'ナンバープレート（任意）',
    dialog_car_plate_holder = '例: W4S4B1',
    dialog_car_color_primary = 'メインカラー（任意）',
    dialog_car_color_second = 'サブカラー（任意）',
    dialog_car_maxed = 'フルカスタム（任意）',

    -- ── キック ──────────────────────────────────────────────
    dialog_kick = '%s をキック',
    dialog_kick_reason = '理由',
    dialog_kick_placeholder = 'チーター',
    kicked_reason_replace = 'サーバーからキックされました!',

    -- ── BAN ─────────────────────────────────────────────────
    dialog_ban = '%s をBAN',
    dialog_ban_reason = '理由',
    dialog_ban_placeholder = 'チーター',
    ban_reason_replace = 'このサーバーからBANされました!',

    -- ── ゾーン作成 ──────────────────────────────────────────
    dialog_zone_create = 'ゾーンの作成',
    dialog_zone_name = '名前',
    dialog_zone_name_desc = 'ゾーン / ブリップの名前',
    dialog_zone_name_holder = '管理ゾーン',
    dialog_zone_text = '表示テキスト',
    dialog_zone_text_desc = 'ゾーン内のプレイヤーに表示されるテキスト',
    dialog_zone_text_holder = '管理ゾーン - 有効',
    dialog_zone_size = 'サイズ',
    dialog_zone_speed = '速度制限',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ブリップID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'カラーID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = '点滅するブリップ',
    dialog_zone_disarm = '武装解除',
    dialog_zone_revive = '蘇生',
    dialog_zone_invincible = '無敵',
    dialog_zone_edit = '「%s」を編集中',
    dialog_zone_delete_confirm = '本当によろしいですか?',
    dialog_zone_delete_confirm_desc = '本当にこのゾーンを削除しますか: %s',

    -- ── 通知: お金 ──────────────────────────────────────────
    notify_givemoney_success = 'お金を付与しました',
    notify_givemoney_success_desc = '%s に $%s を入金しました。口座: %s',
    notify_givemoney_fail = '失敗',
    notify_givemoney_fail_desc = '%s への入金を試みましたが、エラーが発生しました! もう一度お試しください。',

    -- ── 通知: アイテム ──────────────────────────────────────
    notify_giveitem_success = 'アイテムを付与しました',
    notify_giveitem_success_desc = '%s に渡しました。アイテム: %s 個数: %s',
    notify_giveitem_fail = '失敗',
    notify_giveitem_fail_desc = '%s への付与を試みましたが、エラーが発生しました! もう一度お試しください。',

    -- ── 通知: キック / BAN ──────────────────────────────────
    notify_kicked_success = 'キック成功',
    notify_kicked_success_desc = '%s のキックに成功しました',
    notify_banned_success = 'BAN成功',
    notify_banned_success_desc = '%s のBANに成功しました',

    -- ── 通知: インベントリ ──────────────────────────────────
    notify_clearedinv = 'インベントリを空にしました',
    notify_clearedinv_desc = '%s のインベントリを空にしました',

    -- ── 通知: 無効なID ──────────────────────────────────────
    notify_invalidid = '無効なID',
    notify_invalidid_desc = '入力されたIDは無効です。もう一度お試しください。',

    -- ── 通知: 一括削除 ──────────────────────────────────────
    notify_deleted_car = '車両を削除しました',
    notify_deleted_car_desc = '運転手のいない車両をすべて削除しました。',
    notify_deleted_ped = 'Pedを削除しました',
    notify_deleted_ped_desc = 'マップ上のPedをすべて削除しました',
    notify_deleted_objects = 'オブジェクトを削除しました',
    notify_deleted_objects_desc = 'マップ上のオブジェクトをすべて削除しました',

    -- ── 通知: 天候 ──────────────────────────────────────────
    notify_weather = '天候を変更しました',
    notify_weather_desc = '天候を次に変更しました: %s',

    -- ── 通知: 座標コピー ────────────────────────────────────
    notify_copied = 'コピーしました',
    notify_copied_vec3 = 'vector3 をクリップボードにコピーしました!',
    notify_copied_vec4 = 'vector4 をクリップボードにコピーしました!',
    notify_copied_headin = '向きをクリップボードにコピーしました!',

    -- ── 通知: ドア ──────────────────────────────────────────
    notify_locked_doors = '施錠しました',
    notify_locked_doors_desc = '車両のドアを施錠しました。',
    notify_unlocked_doors = '解錠しました',
    notify_unlocked_doors_desc = '車両のドアを解錠しました。',

    -- ── 通知: 管理ゾーン ────────────────────────────────────
    notify_zone_deleted = 'ゾーンを削除しました',
    notify_zone_deleted_desc = 'ゾーンを削除しました: %s。',
    notify_zone_not_deleted_desc = 'ゾーンの削除中にエラーが発生しました: %s。',
    notify_zone_edited = 'ゾーンを変更しました',
    notify_zone_edited_desc = 'ゾーンを変更しました: %s。',
    notify_zone_not_edited_desc = 'ゾーンの変更中にエラーが発生しました: %s。',
    notify_zone_action_cancelled = '操作をキャンセルしました',
    notify_zone_delete_cancel = 'ゾーンの削除をキャンセルしました: %s',
    notify_zone_no_weapons = '武器は使用できません',
    notify_zone_no_weapons_desc = 'このゾーン内では武器の使用は許可されていません。',
    notify_zones_not_found = 'ゾーンなし',
    notify_zones_not_found_desc = '現在、管理できる有効なゾーンはありません。',
    notify_zones_teleport = 'テレポートしました',
    notify_zones_teleport_desc = 'ゾーンへテレポートしました: %s。',

    -- ── 通知: BAN解除 ───────────────────────────────────────
    successfully_unbanned = 'BANを解除しました',
    successfully_unbanned_desc = 'BANの解除に成功しました: %s。',
    unsuccessful_unban = 'BAN解除中にエラーが発生しました: %s。',

    -- ── 接続 (deferral) ─────────────────────────────────────
    deferral_welcome = '[%s] こんにちは %s さん、BANを確認しています. . .',
    deferral_banned = 'あなたはこのサーバーからBANされています。理由: 「%s」（残り時間: %s 時間 %s 分）。',
    deferral_banned_perm = 'あなたはこのサーバーからBANされています。理由: 「%s」（残り時間: 永久）。',

    -- ── エラー ──────────────────────────────────────────────
    notify_error = 'エラー',
    notify_disabled_keys = '車両キーのスクリプトが設定されていません。サーバー開発者にお問い合わせください。',
    notify_no_appearance = '服装 / 外見スクリプトが検出されませんでした。サーバー開発者にお問い合わせください。',
    notify_no_vehicle = '車両が見つかりません!',
    notify_invalid_entry = '入力が無効です!',

    -- ── キーバインド ────────────────────────────────────────
    keymapping_desc = '管理メニューを開く (apex_adminmenu)',

    -- ── ノークリップ ────────────────────────────────────────
    noclip_activated = 'ノークリップ 有効',
    noclip_deactivated = 'ノークリップ 無効',

    -- ── 透明化 ──────────────────────────────────────────────
    invisibility_activated = '透明化モード 有効',
    invisibility_deactivated = '透明化モード 無効',

    -- ── ゴッドモード ────────────────────────────────────────
    godmode_activated = 'ゴッドモード 有効',
    godmode_deactivated = 'ゴッドモード 無効',

    -- ── ウォールハック ──────────────────────────────────────
    wallhack_activated = 'ウォールハック 有効',
    wallhack_deactivated = 'ウォールハック 無効',

    -- ── デバッグモード ──────────────────────────────────────
    debug_activated = 'デバッグモード 有効',
    debug_deactivated = 'デバッグモード 無効',

    -- ── 通知: 車両 ──────────────────────────────────────────
    vehicle_repaired = '車両を修理しました',
    vehicle_repaired_desc = '車両の修理が完了しました。',
    vehicle_deleted = '車両を削除しました',
    vehicle_deleted_desc = '車両の削除が完了しました。',
    vehicle_spawned = '車両をスポーンしました',
    vehicle_spawned_desc = '車両 %s のスポーンが完了しました。',
    vehicle_plate_changed = 'ナンバープレートを変更しました',
    vehicle_plate_changed_desc = '車両のナンバープレートを次に変更しました: %s',
    vehicle_refueled = '車両に給油しました',
    vehicle_refueled_desc = '車両への給油が完了しました。',
    vehicle_keys_given = '鍵を受け取りました',
    vehicle_keys_given_desc = 'ナンバープレート %s の車両の鍵を受け取りました',
    vehicle_color_changed = '車両の色を変更しました',
    vehicle_color_changed_desc = '車両の色を次に変更しました: %s',
    vehicle_torque_set = 'トルク倍率を設定しました',
    vehicle_torque_set_desc = 'トルクを次に設定しました: %sx',
    vehicle_torque_disabled = 'トルク倍率を無効にしました',

    -- ── 観戦 ────────────────────────────────────────────────
    spectate_started = '観戦中',
    spectate_started_desc = '%s を観戦しています。X キーで終了します。',
    spectate_ended = '観戦を終了しました',
    spectate_ended_desc = '誰も観戦していません。',
    spectate_error = '観戦エラー',
    spectate_error_desc = '対象のプレイヤーが見つからないか、すでに存在しません。',

    -- ── テレポート ──────────────────────────────────────────
    teleport_success = 'テレポートしました',
    teleport_success_desc = 'テレポートが完了しました。',

    -- ── 蘇生 / 回復 ─────────────────────────────────────────
    player_revived = 'プレイヤーを蘇生しました',
    player_revived_desc = '%s の蘇生に成功しました。',
    player_healed = 'プレイヤーを回復しました',
    player_healed_desc = '%s の回復に成功しました。',
    self_revived = '蘇生しました',
    self_revived_desc = '自分を蘇生しました。',
    self_healed = '回復しました',
    self_healed_desc = '自分を回復しました。',

    -- ── Ped ─────────────────────────────────────────────────
    ped_changed = 'Ped を変更しました',
    ped_changed_desc = 'あなたのPedモデルが変更されました。',
    ped_restored = 'Ped を復元しました',
    ped_restored_desc = '元のPedモデルが復元されました。',

    skin_menu_opened = '服装メニューを開きました',

    admin_menu_opened = '管理メニューを開きました',
    admin_menu_closed = '管理メニューを閉じました',

    entity_deleted = 'エンティティを削除しました',
    entity_deleted_desc = 'エンティティの削除が完了しました。',

    player_frozen = 'プレイヤーを固定しました',
    player_frozen_desc = 'プレイヤー %s を固定しました。',
    player_unfrozen = 'プレイヤーの固定を解除しました',
    player_unfrozen_desc = 'プレイヤー %s の固定を解除しました。',

    -- ── カスタムナンバープレート ────────────────────────────
    dialog_license_plate = 'カスタムナンバープレート',
    dialog_license_plate_label = 'プレート',
    dialog_license_plate_placeholder = 'ナンバープレート',

    -- ── お金を没収 ──────────────────────────────────────────
    player_removemoney = 'お金を没収',
    player_removemoney_desc = '選択したプレイヤーからお金を没収する',
    dialog_removemoney = 'お金を没収',
    removemoney_input_label = '金額',
    removemoney_input_placeholder = '123456',
    removemoney_select = '口座',
    notify_removemoney_success = 'お金を没収しました',
    notify_removemoney_success_desc = '$%s を %s から没収しました（口座: %s）',
    notify_removemoney_fail = '失敗',
    notify_removemoney_fail_desc = '%s からお金を没収できませんでした（残高不足の可能性があります）。',

    -- ── ディメンション / routing bucket ─────────────────────
    self_dimension = '自分のディメンションを設定',
    self_dimension_desc = '自分を routing bucket へ移動する（0 = メインワールド）',
    player_dimension = 'ディメンションを設定',
    player_dimension_desc = 'このプレイヤーを routing bucket へ移動する',
    player_dimension_bring = '自分のディメンションへ呼ぶ',
    player_dimension_bring_desc = 'このプレイヤーを現在のディメンションへ引き込む',
    player_dimension_goto = 'プレイヤーのディメンションへ参加',
    player_dimension_goto_desc = '自分をこのプレイヤーのディメンションへ移動する',
    dialog_dimension = 'ディメンションを設定',
    dimension_input_label = 'ディメンション (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'ディメンションを変更しました',
    notify_dimension_self_desc = '現在ディメンション %s にいます。',
    notify_dimension_player_desc = '%s をディメンション %s へ移動しました。',
    notify_dimension_join_desc = '%s のディメンション (%s) に参加しました。',
    notify_dimension_fail = 'ディメンションエラー',
    notify_dimension_fail_desc = 'ディメンションを変更できませんでした。',

    -- ── 車両内へテレポート ──────────────────────────────────
    player_tp_vehicle = '車両内へテレポート',
    player_tp_vehicle_desc = 'このプレイヤーの車両に乗り込んで救助を手伝う',
    notify_tp_vehicle_fail = '車両なし',
    notify_tp_vehicle_fail_desc = '%s は車両に乗っていません。',
    notify_tp_vehicle_success = 'テレポートしました',
    notify_tp_vehicle_success_desc = '%s の車両内に移動しました。',

    -- ── 車両の救出 ──────────────────────────────────────────
    recover_car = '車両を救出 / 起こす',
    recover_car_desc = '車両を起こして最寄りの道路へ移動する（水没・横転）',
    vehicle_recovered = '車両を救出しました',
    vehicle_recovered_desc = '車両を起こして最寄りの道路に配置しました。',

    -- ── 所有車両 ────────────────────────────────────────────
    player_owned_vehicles = '所有車両',
    player_owned_vehicles_desc = 'このプレイヤーの車両を確認・追加・削除する',
    owned_vehicles_menu = '所有車両 (%s)',
    owned_vehicles_add = '車両を追加',
    owned_vehicles_add_desc = 'このプレイヤーのガレージに車両を追加する',
    owned_vehicles_none = '車両なし',
    owned_vehicles_none_desc = 'このプレイヤーは車両を所有していません。',
    owned_vehicle_desc = 'ナンバープレート: %s · クリックで削除',
    dialog_add_vehicle = '車両を追加',
    add_vehicle_model_label = 'モデル名',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'ナンバープレート（任意）',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '%s を削除しますか?',
    notify_owned_added = '車両を追加しました',
    notify_owned_added_desc = '%s（プレート %s）を %s に追加しました。',
    notify_owned_removed = '車両を削除しました',
    notify_owned_removed_desc = 'プレート %s を %s から削除しました。',
    notify_owned_fail = 'データベースエラー',
    notify_owned_fail_desc = '車両データベースの処理に失敗しました。',

    -- ── Pedメニュー ─────────────────────────────────────────
    player_pedmenu = 'Pedメニューを渡す',
    player_pedmenu_desc = 'このプレイヤーの画面にPed選択メニューを開く',
    pedmenu_title = 'Pedメニュー',
    pedmenu_given = 'Pedメニューを送信しました',
    pedmenu_given_desc = '%s のためにPedメニューを開きました。'
}
