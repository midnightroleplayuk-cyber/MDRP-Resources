-- ============================================================
-- 한국어 (ko)
-- ------------------------------------------------------------
-- configs/strings.lua 위에 덮어쓰는 레이어입니다. 여기에 없는
-- 키는 자동으로 영어 원문을 유지하므로 부분 번역도 안전합니다.
--
-- %s 자리표시자는 반드시 남겨야 하며 순서도 원문과 같아야
-- 합니다. 코드의 :format() 이 채워 넣습니다. %% 는 퍼센트
-- 기호 자체를 출력합니다.
--
-- 활성화:  Config.Locale = 'ko'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['ko'] = {
    -- ── 메인 메뉴 ───────────────────────────────────────────
    main_title = '관리자 메뉴',
    self_options = '내 설정',
    self_options_desc = '자신과 관련된 설정',
    player_options_title = '플레이어 설정',
    player_options_desc = '다른 플레이어와 관련된 설정',
    vehicle_options = '차량 설정',
    vehicle_options_desc = '차량과 관련된 설정',
    server_options = '서버 설정',
    server_options_desc = '서버와 관련된 설정',
    admin_zone_options = '관리 구역',
    admin_zone_options_desc = '관리 구역을 관리, 추가, 삭제',
    developer_options = '개발자 설정',
    developer_options_desc = '',

    -- ── 내 설정 ─────────────────────────────────────────────
    self_options_menu = '내 설정',
    self_health = '체력 (%s%%)',
    self_noclip = '노클립',
    self_revive = '소생',
    self_revive_desc = '자신을 소생시킵니다',
    self_heal = '치료',
    self_heal_desc = '자신을 치료합니다',
    self_skinmenu = '의상 메뉴',
    self_set_ped = 'Ped 변경',
    self_skinmenu_desc = '의상 메뉴를 로컬에서 엽니다',
    self_invisible = '투명화',
    self_godmode = '무적 모드',
    self_wallhack = '월핵',

    -- ── 플레이어 설정 ───────────────────────────────────────
    player_options_menu = '접속 중인 플레이어 %s/%s',
    player_options = '플레이어: %s',
    player_health = '플레이어 체력 (%s%%)',
    player_freeze = '고정',
    player_freeze_desc = '켜기/끄기',
    player_noclip = '노클립',
    player_noclip_desc = '켜기/끄기',
    player_spectate = '관전',
    player_spectate_desc = '이 플레이어의 행동을 관찰합니다',
    player_playerdata = '플레이어 정보',
    player_playerdata_desc = '플레이어 정보를 확인합니다',
    player_revive = '소생',
    player_revive_desc = '플레이어를 소생시킵니다',
    player_heal = '치료',
    player_heal_desc = '플레이어를 치료합니다',
    player_skinmenu = '의상 메뉴',
    player_skinmenu_desc = '플레이어 화면에 의상 메뉴를 엽니다',
    player_money = '돈 지급',
    player_money_desc = '선택한 플레이어에게 돈을 지급합니다',
    player_item = '아이템 지급',
    player_item_desc = '선택한 플레이어에게 아이템을 지급합니다',
    player_openinv = '인벤토리 열기',
    player_openinv_desc = '플레이어의 인벤토리를 엽니다',
    player_clearinv = '인벤토리 비우기',
    player_clearinv_desc = '플레이어의 인벤토리를 비웁니다',
    player_teleport_to = '플레이어에게 이동',
    player_teleport_to_desc = '플레이어 위치로 순간이동합니다',
    player_bring = '데려오기',
    player_bring_desc = '플레이어를 내 위치로 데려옵니다',
    player_kick = '추방',
    player_kick_desc = '플레이어를 서버에서 추방합니다',
    player_ban = '플레이어 차단',

    -- ── 차량 메뉴 ───────────────────────────────────────────
    vehicle_menu = '차량 메뉴',
    spawn_car = '차량 소환',
    spawn_car_desc = '차량을 소환합니다',
    repair_car = '차량 수리',
    repair_car_desc = '현재 또는 가장 가까운 차량을 수리합니다',
    delete_car = '차량 삭제',
    delete_car_desc = '현재 또는 가장 가까운 차량을 삭제합니다',
    number_plate = '번호판 변경',
    number_plate_desc = '현재 번호판의 문구를 변경합니다',
    refuel = '차량 주유',
    refuel_desc = '현재 또는 가장 가까운 차량에 주유합니다',
    give_keys = '열쇠 지급',
    give_keys_desc = '현재 차량의 열쇠를 자신에게 지급합니다',
    doors = '문 잠금/해제',
    doors_desc = '가장 가까운 차량의 잠금을 전환합니다',
    boost_car = '토크 배율',
    boost_car_desc = '현재 차량의 토크를 변경합니다',
    color_change = '차량 색상 변경',
    color_change_desc = '현재 또는 가장 가까운 차량의 색상을 변경합니다',

    -- ── 서버 관리 ───────────────────────────────────────────
    server_management = '서버 관리',
    server_announcement = '서버 공지',
    server_announcement_desc = '서버 전체에 공지를 발송합니다',
    ban_list = '차단 목록',
    ban_list_desc = '활성화된 모든 차단을 확인합니다',
    objects_list = '엔티티 삭제',
    objects_list_desc = '차량과 Ped를 삭제합니다',
    objects_list_label = '옵션',
    weather_menu = '날씨 관리',
    weather_menu_desc = '날씨를 관리합니다',

    -- ── 관리 구역 ───────────────────────────────────────────
    zones_create = '구역 생성',
    zones_create_desc = '새 관리 구역을 생성합니다',
    zones_manage = '구역 관리',
    zones_manage_desc = '활성화된 구역을 수정하거나 삭제합니다',
    zone_edit_current = '현재 구역 수정',
    zone_edit_current_desc = '현재 있는 구역을 관리합니다',
    zone_delete_current = '현재 구역 삭제',
    zone_delete_current_desc = '현재 있는 구역을 삭제합니다',
    zone_manage_menu = '구역 수정 중 (%s)',
    zone_edit = '구역 수정',
    zone_edit_desc = '구역 수정: %s',
    zone_delete = '구역 삭제',
    zone_delete_desc = '구역 삭제: %s',
    zone_teleport = '구역으로 이동',
    zone_teleport_desc = '구역으로 이동: %s',

    -- ── 개발자 메뉴 ─────────────────────────────────────────
    dev_options = '개발자 설정',
    debug_mode = '디버그 모드',
    debug_mode_desc = '디버그 모드 켜기/끄기',
    copy_vec3 = 'Vector3 좌표 복사',
    copy_vec3_desc = '현재 위치(vector3)를 클립보드에 복사합니다',
    copy_vec4 = 'Vector4 좌표 복사',
    copy_vec4_desc = '현재 위치(vector4)를 클립보드에 복사합니다',
    copy_heading = '방향 복사',
    copy_heading_desc = '현재 바라보는 방향을 클립보드에 복사합니다',
    cant_delete = '삭제할 수 없습니다!',
    cant_delete_player_desc = '플레이어 Ped는 삭제할 수 없습니다!',
    cant_delete_entity_desc = '맵의 기본 오브젝트는 삭제할 수 없습니다!',

    -- ── 차단 목록 ───────────────────────────────────────────
    ban_list_menu = '차단 목록',
    ban_list_name = '이름: %s',
    ban_list_license = '라이선스:',
    ban_list_by = '처리자: %s',
    ban_list_reason = '사유: %s',
    ban_list_length = '남은 시간: %s시간 %s분',
    ban_list_modify = '차단 수정',
    ban_list_unban = '플레이어 차단 해제',
    ban_list_no_data = '차단 없음',
    ban_list_no_data_desc = '활성화된 차단을 찾을 수 없습니다!',

    -- ── 플레이어 정보 ───────────────────────────────────────
    playerdata_menu = '플레이어 정보',
    playerdata_license_esx = '라이선스: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = '클릭하면 전체 라이선스를 복사합니다',
    playerdata_igname = '이름: %s',
    playerdata_igname_desc = '게임 내 플레이어의 전체 이름',
    playerdata_steam = 'Steam 이름: %s',
    playerdata_steam_desc = '플레이어의 전체 Steam 이름',
    playerdata_gender = '성별: %s',
    playerdata_gender_desc = '플레이어의 성별',
    playerdata_cash = '현금: %s',
    playerdata_cash_desc = '플레이어의 현금 잔액',
    playerdata_bank = '은행: %s',
    playerdata_bank_desc = '플레이어의 은행 잔액',
    playerdata_blackmoney = '검은돈: %s',
    playerdata_blackmoney_desc = '플레이어의 검은돈 잔액',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = '[E] 키를 눌러 엔티티 삭제  \nHash: %s  \n좌표: vec3(%s, %s, %s)  \n방향: %s  \n소유자: [%s] - %s',
    debug_textui_noname = '[E] 키를 눌러 엔티티 삭제\n  Hash: %s\n  좌표: vec3(%s, %s, %s)\n  방향: %s\n  소유자: 알 수 없음',

    textui_invisible = '투명화 모드 - 활성',
    textui_godmode = '무적 모드 - 활성',
    textui_wallhack = '월핵 - 활성',
    textui_noclip_activated = '노클립 - 활성',
    textui_torque = '토크 배율 - %s',

    -- ── 공지 ────────────────────────────────────────────────
    dialog_announce = '공지',
    dialog_announce_label = '메시지',
    dialog_announce_select = '전체',
    dialog_announce_everyone = '전체',
    dialog_announce_placeholder = '여기에 중요한 메시지를. . .',

    -- ── 차단 해제 ───────────────────────────────────────────
    dialog_unban = '확실합니까?',
    dialog_unban_content = '정말 %s 의 차단을 해제하시겠습니까?',

    -- ── 엔티티 삭제 ─────────────────────────────────────────
    dialog_objects = '옵션을 선택하세요',
    dialog_clear_objects = '모든 오브젝트 삭제',
    dialog_clear_cars = '모든 차량 삭제 (운전자 없음)',
    dialog_clear_peds = '모든 Ped 삭제',

    -- ── 돈 지급 ─────────────────────────────────────────────
    dialog_givemoney = '돈 지급',
    givemoney_input_label = '금액',
    givemoney_input_placeholder = '123456',
    givemoney_select = '계좌',
    givemoney_select_option1 = '현금',
    givemoney_select_option2 = '은행',
    givemoney_select_option3 = '검은돈',

    -- ── 아이템 지급 ─────────────────────────────────────────
    dialog_giveitem = '아이템 지급',
    giveitem_input_label = '아이템 이름',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = '수량',
    giveitem_amount_input_placeholder = '3',

    -- ── 차량 소환 ───────────────────────────────────────────
    dialog_spawn_a_car = '차량 소환',
    dialog_car_model = '모델 이름',
    dialog_car_model_holder = '예: 20charger',
    dialog_car_plate = '번호판 (선택)',
    dialog_car_plate_holder = '예: W4S4B1',
    dialog_car_color_primary = '기본 색상 (선택)',
    dialog_car_color_second = '보조 색상 (선택)',
    dialog_car_maxed = '최대 튜닝 (선택)',

    -- ── 추방 ────────────────────────────────────────────────
    dialog_kick = '%s 추방',
    dialog_kick_reason = '사유',
    dialog_kick_placeholder = '핵 사용자',
    kicked_reason_replace = '서버에서 추방되었습니다!',

    -- ── 차단 ────────────────────────────────────────────────
    dialog_ban = '%s 차단',
    dialog_ban_reason = '사유',
    dialog_ban_placeholder = '핵 사용자',
    ban_reason_replace = '이 서버에서 차단되었습니다!',

    -- ── 구역 생성 ───────────────────────────────────────────
    dialog_zone_create = '구역 생성',
    dialog_zone_name = '이름',
    dialog_zone_name_desc = '구역 / 블립의 이름',
    dialog_zone_name_holder = '관리 구역',
    dialog_zone_text = '표시 문구',
    dialog_zone_text_desc = '구역 안의 플레이어에게 표시할 문구',
    dialog_zone_text_holder = '관리 구역 - 활성',
    dialog_zone_size = '크기',
    dialog_zone_speed = '제한 속도',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = '블립 ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = '색상 ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = '깜빡이는 블립',
    dialog_zone_disarm = '무장 해제',
    dialog_zone_revive = '소생',
    dialog_zone_invincible = '무적',
    dialog_zone_edit = '「%s」 수정 중',
    dialog_zone_delete_confirm = '확실합니까?',
    dialog_zone_delete_confirm_desc = '정말 이 구역을 삭제하시겠습니까: %s',

    -- ── 알림: 돈 ────────────────────────────────────────────
    notify_givemoney_success = '돈이 지급되었습니다',
    notify_givemoney_success_desc = '%s 에게 $%s 을(를) 입금했습니다. 계좌: %s',
    notify_givemoney_fail = '실패',
    notify_givemoney_fail_desc = '%s 에게 입금을 시도했지만 오류가 발생했습니다! 다시 시도하세요.',

    -- ── 알림: 아이템 ────────────────────────────────────────
    notify_giveitem_success = '아이템이 지급되었습니다',
    notify_giveitem_success_desc = '%s 에게 지급했습니다. 아이템: %s 수량: %s',
    notify_giveitem_fail = '실패',
    notify_giveitem_fail_desc = '%s 에게 지급을 시도했지만 오류가 발생했습니다! 다시 시도하세요.',

    -- ── 알림: 추방 / 차단 ───────────────────────────────────
    notify_kicked_success = '추방 성공',
    notify_kicked_success_desc = '%s 을(를) 성공적으로 추방했습니다',
    notify_banned_success = '차단 성공',
    notify_banned_success_desc = '%s 을(를) 성공적으로 차단했습니다',

    -- ── 알림: 인벤토리 ──────────────────────────────────────
    notify_clearedinv = '인벤토리를 비웠습니다',
    notify_clearedinv_desc = '%s 의 인벤토리를 성공적으로 비웠습니다',

    -- ── 알림: 잘못된 ID ─────────────────────────────────────
    notify_invalidid = '잘못된 ID',
    notify_invalidid_desc = '입력한 ID가 올바르지 않습니다. 다시 시도하세요.',

    -- ── 알림: 정리 ──────────────────────────────────────────
    notify_deleted_car = '차량을 삭제했습니다',
    notify_deleted_car_desc = '운전자가 없는 모든 차량을 삭제했습니다.',
    notify_deleted_ped = 'Ped를 삭제했습니다',
    notify_deleted_ped_desc = '맵의 모든 Ped를 삭제했습니다',
    notify_deleted_objects = '오브젝트를 삭제했습니다',
    notify_deleted_objects_desc = '맵의 모든 오브젝트를 삭제했습니다',

    -- ── 알림: 날씨 ──────────────────────────────────────────
    notify_weather = '날씨가 변경되었습니다',
    notify_weather_desc = '날씨를 다음으로 변경했습니다: %s',

    -- ── 알림: 좌표 복사 ─────────────────────────────────────
    notify_copied = '복사됨',
    notify_copied_vec3 = 'vector3 을(를) 클립보드에 복사했습니다!',
    notify_copied_vec4 = 'vector4 을(를) 클립보드에 복사했습니다!',
    notify_copied_headin = '방향을 클립보드에 복사했습니다!',

    -- ── 알림: 문 ────────────────────────────────────────────
    notify_locked_doors = '잠김',
    notify_locked_doors_desc = '차량 문을 성공적으로 잠갔습니다.',
    notify_unlocked_doors = '잠금 해제됨',
    notify_unlocked_doors_desc = '차량 문의 잠금을 성공적으로 해제했습니다.',

    -- ── 알림: 관리 구역 ─────────────────────────────────────
    notify_zone_deleted = '구역이 삭제되었습니다',
    notify_zone_deleted_desc = '구역을 성공적으로 제거했습니다: %s.',
    notify_zone_not_deleted_desc = '구역을 삭제하는 중 오류가 발생했습니다: %s.',
    notify_zone_edited = '구역이 수정되었습니다',
    notify_zone_edited_desc = '구역을 성공적으로 수정했습니다: %s.',
    notify_zone_not_edited_desc = '구역을 수정하는 중 오류가 발생했습니다: %s.',
    notify_zone_action_cancelled = '작업이 취소되었습니다',
    notify_zone_delete_cancel = '구역 삭제를 취소했습니다: %s',
    notify_zone_no_weapons = '무기 사용 금지',
    notify_zone_no_weapons_desc = '이 구역 안에서는 무기를 사용할 수 없습니다.',
    notify_zones_not_found = '구역 없음',
    notify_zones_not_found_desc = '현재 관리할 수 있는 활성 구역이 없습니다.',
    notify_zones_teleport = '이동 완료',
    notify_zones_teleport_desc = '구역으로 성공적으로 이동했습니다: %s.',

    -- ── 알림: 차단 해제 ─────────────────────────────────────
    successfully_unbanned = '차단이 해제되었습니다',
    successfully_unbanned_desc = '성공적으로 차단을 해제했습니다: %s.',
    unsuccessful_unban = '차단 해제 중 오류가 발생했습니다: %s.',

    -- ── 접속 (deferral) ─────────────────────────────────────
    deferral_welcome = '[%s] 안녕하세요 %s 님, 차단 여부를 확인하는 중입니다. . .',
    deferral_banned = '이 서버에서 차단되었습니다. 사유: 「%s」 (남은 시간: %s시간 %s분).',
    deferral_banned_perm = '이 서버에서 차단되었습니다. 사유: 「%s」 (남은 시간: 영구).',

    -- ── 오류 ────────────────────────────────────────────────
    notify_error = '오류',
    notify_disabled_keys = '차량 열쇠 스크립트가 설정되어 있지 않습니다. 서버 개발자에게 문의하세요.',
    notify_no_appearance = '의상 / 외형 스크립트를 찾을 수 없습니다. 서버 개발자에게 문의하세요.',
    notify_no_vehicle = '차량을 찾을 수 없습니다!',
    notify_invalid_entry = '잘못된 입력입니다!',

    -- ── 단축키 ──────────────────────────────────────────────
    keymapping_desc = '관리자 메뉴 열기 (apex_adminmenu)',

    -- ── 노클립 ──────────────────────────────────────────────
    noclip_activated = '노클립 활성화',
    noclip_deactivated = '노클립 비활성화',

    -- ── 투명화 ──────────────────────────────────────────────
    invisibility_activated = '투명화 모드 활성화',
    invisibility_deactivated = '투명화 모드 비활성화',

    -- ── 무적 모드 ───────────────────────────────────────────
    godmode_activated = '무적 모드 활성화',
    godmode_deactivated = '무적 모드 비활성화',

    -- ── 월핵 ────────────────────────────────────────────────
    wallhack_activated = '월핵 활성화',
    wallhack_deactivated = '월핵 비활성화',

    -- ── 디버그 모드 ─────────────────────────────────────────
    debug_activated = '디버그 모드 활성화',
    debug_deactivated = '디버그 모드 비활성화',

    -- ── 알림: 차량 ──────────────────────────────────────────
    vehicle_repaired = '차량 수리 완료',
    vehicle_repaired_desc = '차량이 성공적으로 수리되었습니다.',
    vehicle_deleted = '차량 삭제 완료',
    vehicle_deleted_desc = '차량이 성공적으로 삭제되었습니다.',
    vehicle_spawned = '차량 소환 완료',
    vehicle_spawned_desc = '차량 %s 이(가) 성공적으로 소환되었습니다.',
    vehicle_plate_changed = '번호판 변경 완료',
    vehicle_plate_changed_desc = '차량 번호판을 다음으로 변경했습니다: %s',
    vehicle_refueled = '차량 주유 완료',
    vehicle_refueled_desc = '차량에 성공적으로 주유했습니다.',
    vehicle_keys_given = '열쇠를 받았습니다',
    vehicle_keys_given_desc = '번호판이 %s 인 차량의 열쇠를 받았습니다',
    vehicle_color_changed = '차량 색상 변경 완료',
    vehicle_color_changed_desc = '차량 색상을 다음으로 변경했습니다: %s',
    vehicle_torque_set = '토크 배율 설정 완료',
    vehicle_torque_set_desc = '토크를 다음으로 설정했습니다: %sx',
    vehicle_torque_disabled = '토크 배율 비활성화',

    -- ── 관전 ────────────────────────────────────────────────
    spectate_started = '관전 중',
    spectate_started_desc = '%s 을(를) 관전 중입니다. X 키로 종료합니다.',
    spectate_ended = '관전 종료',
    spectate_ended_desc = '더 이상 아무도 관전하고 있지 않습니다.',
    spectate_error = '관전 오류',
    spectate_error_desc = '대상 플레이어를 찾을 수 없거나 더 이상 존재하지 않습니다.',

    -- ── 순간이동 ────────────────────────────────────────────
    teleport_success = '이동 완료',
    teleport_success_desc = '성공적으로 순간이동했습니다.',

    -- ── 소생 / 치료 ─────────────────────────────────────────
    player_revived = '플레이어 소생 완료',
    player_revived_desc = '%s 을(를) 성공적으로 소생시켰습니다.',
    player_healed = '플레이어 치료 완료',
    player_healed_desc = '%s 을(를) 성공적으로 치료했습니다.',
    self_revived = '소생 완료',
    self_revived_desc = '자신을 소생시켰습니다.',
    self_healed = '치료 완료',
    self_healed_desc = '자신을 치료했습니다.',

    -- ── Ped ─────────────────────────────────────────────────
    ped_changed = 'Ped 변경 완료',
    ped_changed_desc = 'Ped 모델이 변경되었습니다.',
    ped_restored = 'Ped 복원 완료',
    ped_restored_desc = '원래의 Ped 모델이 복원되었습니다.',

    skin_menu_opened = '의상 메뉴를 열었습니다',

    admin_menu_opened = '관리자 메뉴를 열었습니다',
    admin_menu_closed = '관리자 메뉴를 닫았습니다',

    entity_deleted = '엔티티 삭제 완료',
    entity_deleted_desc = '엔티티가 성공적으로 삭제되었습니다.',

    player_frozen = '플레이어 고정됨',
    player_frozen_desc = '플레이어 %s 이(가) 고정되었습니다.',
    player_unfrozen = '플레이어 고정 해제됨',
    player_unfrozen_desc = '플레이어 %s 의 고정이 해제되었습니다.',

    -- ── 커스텀 번호판 ───────────────────────────────────────
    dialog_license_plate = '커스텀 번호판',
    dialog_license_plate_label = '번호판',
    dialog_license_plate_placeholder = '번호판',

    -- ── 돈 회수 ─────────────────────────────────────────────
    player_removemoney = '돈 회수',
    player_removemoney_desc = '선택한 플레이어에게서 돈을 회수합니다',
    dialog_removemoney = '돈 회수',
    removemoney_input_label = '금액',
    removemoney_input_placeholder = '123456',
    removemoney_select = '계좌',
    notify_removemoney_success = '돈을 회수했습니다',
    notify_removemoney_success_desc = '$%s 을(를) %s 에게서 회수했습니다 (계좌: %s)',
    notify_removemoney_fail = '실패',
    notify_removemoney_fail_desc = '%s 에게서 돈을 회수할 수 없습니다 (잔액이 부족할 수 있습니다).',

    -- ── 디멘션 / routing bucket ─────────────────────────────
    self_dimension = '내 디멘션 설정',
    self_dimension_desc = '자신을 routing bucket 으로 이동합니다 (0 = 메인 월드)',
    player_dimension = '디멘션 설정',
    player_dimension_desc = '이 플레이어를 routing bucket 으로 이동합니다',
    player_dimension_bring = '내 디멘션으로 데려오기',
    player_dimension_bring_desc = '이 플레이어를 현재 디멘션으로 끌어옵니다',
    player_dimension_goto = '플레이어의 디멘션으로 이동',
    player_dimension_goto_desc = '자신을 이 플레이어의 디멘션으로 이동합니다',
    dialog_dimension = '디멘션 설정',
    dimension_input_label = '디멘션 (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = '디멘션이 변경되었습니다',
    notify_dimension_self_desc = '현재 디멘션 %s 에 있습니다.',
    notify_dimension_player_desc = '%s 을(를) 디멘션 %s (으)로 이동했습니다.',
    notify_dimension_join_desc = '%s 의 디멘션 (%s) 에 참여했습니다.',
    notify_dimension_fail = '디멘션 오류',
    notify_dimension_fail_desc = '디멘션을 변경할 수 없습니다.',

    -- ── 차량 안으로 이동 ────────────────────────────────────
    player_tp_vehicle = '차량 안으로 이동',
    player_tp_vehicle_desc = '이 플레이어의 차량에 탑승해 구조를 돕습니다',
    notify_tp_vehicle_fail = '차량 없음',
    notify_tp_vehicle_fail_desc = '%s 은(는) 차량에 타고 있지 않습니다.',
    notify_tp_vehicle_success = '이동 완료',
    notify_tp_vehicle_success_desc = '%s 의 차량 안으로 이동했습니다.',

    -- ── 차량 구조 ───────────────────────────────────────────
    recover_car = '차량 구조 / 뒤집기',
    recover_car_desc = '차량을 바로 세우고 가장 가까운 도로로 옮깁니다 (침수/전복)',
    vehicle_recovered = '차량 구조 완료',
    vehicle_recovered_desc = '차량을 바로 세워 가장 가까운 도로에 배치했습니다.',

    -- ── 보유 차량 ───────────────────────────────────────────
    player_owned_vehicles = '보유 차량',
    player_owned_vehicles_desc = '이 플레이어의 차량을 확인, 추가, 제거합니다',
    owned_vehicles_menu = '보유 차량 (%s)',
    owned_vehicles_add = '차량 추가',
    owned_vehicles_add_desc = '이 플레이어의 차고에 차량을 추가합니다',
    owned_vehicles_none = '차량 없음',
    owned_vehicles_none_desc = '이 플레이어는 차량을 보유하고 있지 않습니다.',
    owned_vehicle_desc = '번호판: %s · 클릭하면 제거',
    dialog_add_vehicle = '차량 추가',
    add_vehicle_model_label = '모델 이름',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = '번호판 (선택)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '%s 을(를) 제거하시겠습니까?',
    notify_owned_added = '차량이 추가되었습니다',
    notify_owned_added_desc = '%s (번호판 %s) 을(를) %s 에게 추가했습니다.',
    notify_owned_removed = '차량이 제거되었습니다',
    notify_owned_removed_desc = '번호판 %s 을(를) %s 에게서 제거했습니다.',
    notify_owned_fail = '데이터베이스 오류',
    notify_owned_fail_desc = '차량 데이터베이스 작업에 실패했습니다.',

    -- ── Ped 메뉴 ────────────────────────────────────────────
    player_pedmenu = 'Ped 메뉴 지급',
    player_pedmenu_desc = '이 플레이어의 화면에 Ped 선택 메뉴를 엽니다',
    pedmenu_title = 'Ped 메뉴',
    pedmenu_given = 'Ped 메뉴를 전송했습니다',
    pedmenu_given_desc = '%s 을(를) 위해 Ped 메뉴를 열었습니다.'
}
