-- ============================================================
-- TÜRKÇE (tr)
-- ------------------------------------------------------------
-- configs/strings.lua üzerine bir katmandır. Burada olmayan her
-- anahtar otomatik olarak İngilizce metni korur; bu yüzden kısmi
-- çeviri güvenlidir.
--
-- %s yer tutucuları korunmalı ve orijinaldeki AYNI sırada
-- kalmalıdır: koddaki :format() bunları doldurur. %% birebir
-- yüzde işareti yazar.
--
-- Etkinleştirme:  Config.Locale = 'tr'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['tr'] = {
    -- ── Ana menü ────────────────────────────────────────────
    main_title = 'Yetkili Menüsü',
    self_options = 'Kendi Seçeneklerim',
    self_options_desc = 'Kendinle ilgili seçenekler',
    player_options_title = 'Oyuncu Seçenekleri',
    player_options_desc = 'Diğer oyuncularla ilgili seçenekler',
    vehicle_options = 'Araç Seçenekleri',
    vehicle_options_desc = 'Araçlarla ilgili seçenekler',
    server_options = 'Sunucu Seçenekleri',
    server_options_desc = 'Sunucuyla ilgili seçenekler',
    admin_zone_options = 'Yetkili Bölgeleri',
    admin_zone_options_desc = 'Yetkili bölgelerini yönet, ekle ve sil',
    developer_options = 'Geliştirici Seçenekleri',
    developer_options_desc = '',

    -- ── Kendi seçeneklerim ──────────────────────────────────
    self_options_menu = 'Kendi Seçeneklerim',
    self_health = 'Can (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Canlandır',
    self_revive_desc = 'Kendini canlandır',
    self_heal = 'İyileştir',
    self_heal_desc = 'Kendini iyileştir',
    self_skinmenu = 'Kıyafet Menüsü',
    self_set_ped = 'Ped Değiştir',
    self_skinmenu_desc = 'Kıyafet menüsünü yerel olarak aç',
    self_invisible = 'Görünmezlik',
    self_godmode = 'Tanrı Modu',
    self_wallhack = 'Wallhack',

    -- ── Oyuncu seçenekleri ──────────────────────────────────
    player_options_menu = 'Çevrimiçi Oyuncular %s/%s',
    player_options = 'Oyuncu: %s',
    player_health = 'Oyuncu Canı (%s%%)',
    player_freeze = 'Dondur',
    player_freeze_desc = 'Aç/kapat',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Aç/kapat',
    player_spectate = 'İzle',
    player_spectate_desc = 'Bu oyuncunun hareketlerini izle',
    player_playerdata = 'Oyuncu Bilgileri',
    player_playerdata_desc = 'Oyuncunun bilgilerini görüntüle',
    player_revive = 'Canlandır',
    player_revive_desc = 'Oyuncuyu canlandır',
    player_heal = 'İyileştir',
    player_heal_desc = 'Oyuncuyu iyileştir',
    player_skinmenu = 'Kıyafet Menüsü',
    player_skinmenu_desc = 'Oyuncuda kıyafet menüsü aç',
    player_money = 'Para Ver',
    player_money_desc = 'Seçili oyuncuya para ver',
    player_item = 'Eşya Ver',
    player_item_desc = 'Seçili oyuncuya eşya ver',
    player_openinv = 'Envanteri Aç',
    player_openinv_desc = 'Oyuncunun envanterini aç',
    player_clearinv = 'Envanteri Temizle',
    player_clearinv_desc = 'Oyuncunun envanterini temizle',
    player_teleport_to = 'Oyuncuya Işınlan',
    player_teleport_to_desc = 'Oyuncunun yanına ışınlan',
    player_bring = 'Getir',
    player_bring_desc = 'Oyuncuyu bulunduğun konuma getir',
    player_kick = 'At',
    player_kick_desc = 'Oyuncuyu sunucudan at',
    player_ban = 'Oyuncuyu Yasakla',

    -- ── Araç menüsü ─────────────────────────────────────────
    vehicle_menu = 'Araç Menüsü',
    spawn_car = 'Araç Çıkar',
    spawn_car_desc = 'Bir araç çıkar',
    repair_car = 'Aracı Tamir Et',
    repair_car_desc = 'Mevcut veya en yakın aracı tamir et',
    delete_car = 'Aracı Sil',
    delete_car_desc = 'Mevcut veya en yakın aracı sil',
    number_plate = 'Plakayı Değiştir',
    number_plate_desc = 'Mevcut plakanın metnini değiştir',
    refuel = 'Aracı Doldur',
    refuel_desc = 'Mevcut veya en yakın aracın yakıtını doldur',
    give_keys = 'Anahtar Ver',
    give_keys_desc = 'Mevcut aracın anahtarlarını kendine ver',
    doors = 'Kapıları Kilitle/Aç',
    doors_desc = 'En yakın aracın kilitlerini değiştirir',
    boost_car = 'Tork Çarpanı',
    boost_car_desc = 'Mevcut aracın torkunu değiştir',
    color_change = 'Araç Rengini Değiştir',
    color_change_desc = 'Mevcut veya en yakın aracın rengini değiştir',

    -- ── Sunucu yönetimi ─────────────────────────────────────
    server_management = 'Sunucu Yönetimi',
    server_announcement = 'Sunucu Duyurusu',
    server_announcement_desc = 'Tüm sunucuya genel bir duyuru gönder',
    ban_list = 'Yasak Listesi',
    ban_list_desc = 'Tüm aktif yasakları görüntüle',
    objects_list = 'Varlıkları Sil',
    objects_list_desc = 'Araçları ve pedleri sil',
    objects_list_label = 'Seçenekler',
    weather_menu = 'Hava Durumu Yönetimi',
    weather_menu_desc = 'Hava durumunu yönet',

    -- ── Yetkili bölgeleri ───────────────────────────────────
    zones_create = 'Bölge Oluştur',
    zones_create_desc = 'Yeni bir yetkili bölgesi oluştur',
    zones_manage = 'Bölgeleri Yönet',
    zones_manage_desc = 'Aktif bölgeleri düzenle veya sil',
    zone_edit_current = 'Mevcut Bölgeyi Düzenle',
    zone_edit_current_desc = 'İçinde bulunduğun bölgeyi yönet',
    zone_delete_current = 'Mevcut Bölgeyi Sil',
    zone_delete_current_desc = 'İçinde bulunduğun bölgeyi sil',
    zone_manage_menu = 'Bölge Düzenleniyor (%s)',
    zone_edit = 'Bölgeyi Düzenle',
    zone_edit_desc = 'Bölgeyi değiştir: %s',
    zone_delete = 'Bölgeyi Sil',
    zone_delete_desc = 'Bölgeyi sil: %s',
    zone_teleport = 'Bölgeye Işınlan',
    zone_teleport_desc = 'Bölgeye git: %s',

    -- ── Geliştirici menüsü ──────────────────────────────────
    dev_options = 'Geliştirici Seçenekleri',
    debug_mode = 'Hata Ayıklama Modu',
    debug_mode_desc = 'Hata ayıklama modunu aç/kapat',
    copy_vec3 = 'Vector3 Koordinatlarını Kopyala',
    copy_vec3_desc = 'Mevcut konumunu (vector3) panoya kopyalar',
    copy_vec4 = 'Vector4 Koordinatlarını Kopyala',
    copy_vec4_desc = 'Mevcut konumunu (vector4) panoya kopyalar',
    copy_heading = 'Yönü Kopyala',
    copy_heading_desc = 'Mevcut bakış yönünü panoya kopyalar',
    cant_delete = 'Silinemez!',
    cant_delete_player_desc = 'Oyuncu pedlerini silemezsin!',
    cant_delete_entity_desc = 'Haritanın varsayılan nesnelerini silemezsin!',

    -- ── Yasak listesi ───────────────────────────────────────
    ban_list_menu = 'Yasak Listesi',
    ban_list_name = 'İsim: %s',
    ban_list_license = 'Lisans:',
    ban_list_by = 'Veren: %s',
    ban_list_reason = 'Sebep: %s',
    ban_list_length = 'Kalan Süre: %s saat %s dakika',
    ban_list_modify = 'Yasağı Düzenle',
    ban_list_unban = 'Yasağı Kaldır',
    ban_list_no_data = 'Yasak Yok',
    ban_list_no_data_desc = 'Aktif bir yasak bulunamadı!',

    -- ── Oyuncu bilgileri ────────────────────────────────────
    playerdata_menu = 'Oyuncu Bilgileri',
    playerdata_license_esx = 'Lisans: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Tam lisansı kopyalamak için tıkla',
    playerdata_igname = 'İsim: %s',
    playerdata_igname_desc = 'Oyuncunun oyun içi tam adı',
    playerdata_steam = 'Steam Adı: %s',
    playerdata_steam_desc = 'Oyuncunun tam Steam adı',
    playerdata_gender = 'Cinsiyet: %s',
    playerdata_gender_desc = 'Oyuncunun cinsiyeti',
    playerdata_cash = 'Nakit: %s',
    playerdata_cash_desc = 'Oyuncunun nakit bakiyesi',
    playerdata_bank = 'Banka: %s',
    playerdata_bank_desc = 'Oyuncunun banka bakiyesi',
    playerdata_blackmoney = 'Kara Para: %s',
    playerdata_blackmoney_desc = 'Oyuncunun kara para bakiyesi',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Varlığı silmek için [E]  \nHash: %s  \nKoordinat: vec3(%s, %s, %s)  \nYön: %s  \nSahip: [%s] - %s',
    debug_textui_noname = 'Varlığı silmek için [E]\n  Hash: %s\n  Koordinat: vec3(%s, %s, %s)\n  Yön: %s\n  Sahip: BİLİNMİYOR',

    textui_invisible = 'Görünmezlik Modu - Aktif',
    textui_godmode = 'Tanrı Modu - Aktif',
    textui_wallhack = 'Wallhack - Aktif',
    textui_noclip_activated = 'No Clip - Aktif',
    textui_torque = 'Tork Çarpanı - %s',

    -- ── Duyurular ───────────────────────────────────────────
    dialog_announce = 'Duyuru',
    dialog_announce_label = 'Mesaj',
    dialog_announce_select = 'Herkes',
    dialog_announce_everyone = 'Herkes',
    dialog_announce_placeholder = 'Önemli mesaj buraya. . .',

    -- ── Yasak kaldırma ──────────────────────────────────────
    dialog_unban = 'Emin misin?',
    dialog_unban_content = '%s adlı oyuncunun yasağını gerçekten kaldırmak istiyor musun?',

    -- ── Varlık silme ────────────────────────────────────────
    dialog_objects = 'Bir seçenek seç',
    dialog_clear_objects = 'TÜM nesneleri sil',
    dialog_clear_cars = 'TÜM araçları sil (sürücüsüz)',
    dialog_clear_peds = 'TÜM pedleri sil',

    -- ── Para verme ──────────────────────────────────────────
    dialog_givemoney = 'Para Ver',
    givemoney_input_label = 'Miktar',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Hesap',
    givemoney_select_option1 = 'Nakit',
    givemoney_select_option2 = 'Banka',
    givemoney_select_option3 = 'Kara Para',

    -- ── Eşya verme ──────────────────────────────────────────
    dialog_giveitem = 'Eşya Ver',
    giveitem_input_label = 'Eşya Adı',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Miktar',
    giveitem_amount_input_placeholder = '3',

    -- ── Araç çıkarma ────────────────────────────────────────
    dialog_spawn_a_car = 'Araç Çıkar',
    dialog_car_model = 'Model Adı',
    dialog_car_model_holder = 'Örn: 20charger',
    dialog_car_plate = 'Plaka (isteğe bağlı)',
    dialog_car_plate_holder = 'Örn: W4S4B1',
    dialog_car_color_primary = 'Birincil Renk (isteğe bağlı)',
    dialog_car_color_second = 'İkincil Renk (isteğe bağlı)',
    dialog_car_maxed = 'Maksimum Modifiye (isteğe bağlı)',

    -- ── Atma ────────────────────────────────────────────────
    dialog_kick = '%s adlı oyuncuyu at',
    dialog_kick_reason = 'Sebep',
    dialog_kick_placeholder = 'Hileci',
    kicked_reason_replace = 'Sunucudan atıldın!',

    -- ── Yasaklama ───────────────────────────────────────────
    dialog_ban = '%s adlı oyuncuyu yasakla',
    dialog_ban_reason = 'Sebep',
    dialog_ban_placeholder = 'Hileci',
    ban_reason_replace = 'Bu sunucudan yasaklandın!',

    -- ── Bölge oluşturma ─────────────────────────────────────
    dialog_zone_create = 'Bölge Oluşturma',
    dialog_zone_name = 'İsim',
    dialog_zone_name_desc = 'Bölgenin / blipin adı',
    dialog_zone_name_holder = 'Yetkili Bölgesi',
    dialog_zone_text = 'Gösterilecek Metin',
    dialog_zone_text_desc = 'Bölge içindeki oyunculara gösterilecek metin',
    dialog_zone_text_holder = 'YETKİLİ BÖLGESİ - AKTİF',
    dialog_zone_size = 'Boyut',
    dialog_zone_speed = 'Hız Limiti',
    mph = 'MPH',
    kmh = 'KM/S',
    dialog_zone_blip_id = 'Blip ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Renk ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Yanıp Sönen Blip',
    dialog_zone_disarm = 'Silahsızlandır',
    dialog_zone_revive = 'Canlandır',
    dialog_zone_invincible = 'Ölümsüz',
    dialog_zone_edit = '"%s" düzenleniyor',
    dialog_zone_delete_confirm = 'Emin misin?',
    dialog_zone_delete_confirm_desc = 'Bu bölgeyi gerçekten silmek istiyor musun: %s',

    -- ── Bildirimler: para ───────────────────────────────────
    notify_givemoney_success = 'Para Verildi',
    notify_givemoney_success_desc = '%s adlı oyuncuya $%s yatırdın, hesap: %s',
    notify_givemoney_fail = 'Başarısız',
    notify_givemoney_fail_desc = '%s adlı oyuncuya para yatırmayı denedin ama bir şeyler ters gitti! Tekrar dene.',

    -- ── Bildirimler: eşya ───────────────────────────────────
    notify_giveitem_success = 'Eşya Verildi',
    notify_giveitem_success_desc = '%s adlı oyuncuya verildi. Eşya: %s Miktar: %s',
    notify_giveitem_fail = 'Başarısız',
    notify_giveitem_fail_desc = '%s adlı oyuncuya vermeyi denedin ama bir şeyler ters gitti! Tekrar dene.',

    -- ── Bildirimler: atma / yasaklama ───────────────────────
    notify_kicked_success = 'Atma Başarılı',
    notify_kicked_success_desc = '%s adlı oyuncuyu başarıyla attın',
    notify_banned_success = 'Yasaklama Başarılı',
    notify_banned_success_desc = '%s adlı oyuncuyu başarıyla yasakladın',

    -- ── Bildirimler: envanter ───────────────────────────────
    notify_clearedinv = 'Envanter Temizlendi',
    notify_clearedinv_desc = '%s adlı oyuncunun envanterini başarıyla temizledin',

    -- ── Bildirimler: geçersiz ID ────────────────────────────
    notify_invalidid = 'Geçersiz ID',
    notify_invalidid_desc = 'Girdiğin ID geçersiz, lütfen tekrar dene.',

    -- ── Bildirimler: temizlik ───────────────────────────────
    notify_deleted_car = 'Araçlar Silindi',
    notify_deleted_car_desc = 'Sürücüsüz tüm araçları başarıyla sildin.',
    notify_deleted_ped = 'Pedler Silindi',
    notify_deleted_ped_desc = 'Haritadaki tüm pedleri başarıyla sildin',
    notify_deleted_objects = 'Nesneler Silindi',
    notify_deleted_objects_desc = 'Haritadaki tüm nesneleri başarıyla sildin',

    -- ── Bildirimler: hava durumu ────────────────────────────
    notify_weather = 'Hava Durumu Değiştirildi',
    notify_weather_desc = 'Hava durumu şuna değiştirildi: %s',

    -- ── Bildirimler: koordinat kopyalama ────────────────────
    notify_copied = 'Kopyalandı',
    notify_copied_vec3 = 'Vector3 panoya başarıyla kopyalandı!',
    notify_copied_vec4 = 'Vector4 panoya başarıyla kopyalandı!',
    notify_copied_headin = 'Yön panoya başarıyla kopyalandı!',

    -- ── Bildirimler: kapılar ────────────────────────────────
    notify_locked_doors = 'Kilitlendi',
    notify_locked_doors_desc = 'Araç kapıları başarıyla kilitlendi.',
    notify_unlocked_doors = 'Kilit Açıldı',
    notify_unlocked_doors_desc = 'Araç kapılarının kilidi başarıyla açıldı.',

    -- ── Bildirimler: yetkili bölgeleri ──────────────────────
    notify_zone_deleted = 'Bölge Silindi',
    notify_zone_deleted_desc = 'Bölgeyi başarıyla kaldırdın: %s.',
    notify_zone_not_deleted_desc = 'Bölge silinirken bir hata oluştu: %s.',
    notify_zone_edited = 'Bölge Değiştirildi',
    notify_zone_edited_desc = 'Bölgeyi başarıyla değiştirdin: %s.',
    notify_zone_not_edited_desc = 'Bölge değiştirilirken bir hata oluştu: %s.',
    notify_zone_action_cancelled = 'İşlem İptal Edildi',
    notify_zone_delete_cancel = 'Bölgenin silinmesini iptal ettin: %s',
    notify_zone_no_weapons = 'Silahlara İzin Yok',
    notify_zone_no_weapons_desc = 'Bu bölgede silah kullanma iznin yok.',
    notify_zones_not_found = 'Bölge Bulunamadı',
    notify_zones_not_found_desc = 'Şu anda yönetilecek aktif bir bölge yok.',
    notify_zones_teleport = 'Işınlandın',
    notify_zones_teleport_desc = 'Bölgeye başarıyla ışınlandın: %s.',

    -- ── Bildirimler: yasak kaldırma ─────────────────────────
    successfully_unbanned = 'Yasak Kaldırıldı',
    successfully_unbanned_desc = 'Yasağı başarıyla kaldırdın: %s.',
    unsuccessful_unban = 'Yasak kaldırılırken bir şeyler ters gitti: %s.',

    -- ── Bağlanma (deferral) ─────────────────────────────────
    deferral_welcome = '[%s] Merhaba %s, yasaklar kontrol ediliyor. . .',
    deferral_banned = 'Bu sunucudan yasaklısın. Sebep: "%s" (Kalan Süre: %s saat %s dakika).',
    deferral_banned_perm = 'Bu sunucudan yasaklısın. Sebep: "%s" (Kalan Süre: Kalıcı).',

    -- ── Hatalar ─────────────────────────────────────────────
    notify_error = 'Hata',
    notify_disabled_keys = 'Yapılandırılmış bir araç anahtarı scripti yok. Lütfen sunucu geliştiricisiyle iletişime geç.',
    notify_no_appearance = 'Kıyafet / görünüm scripti tespit edilemedi. Lütfen sunucu geliştiricisiyle iletişime geç.',
    notify_no_vehicle = 'Araç bulunamadı!',
    notify_invalid_entry = 'Geçersiz giriş!',

    -- ── Kısayol tuşu ────────────────────────────────────────
    keymapping_desc = 'Yetkili Menüsünü Aç (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Açıldı',
    noclip_deactivated = 'NoClip Kapatıldı',

    -- ── Görünmezlik ─────────────────────────────────────────
    invisibility_activated = 'Görünmezlik Modu Açıldı',
    invisibility_deactivated = 'Görünmezlik Modu Kapatıldı',

    -- ── Tanrı modu ──────────────────────────────────────────
    godmode_activated = 'Tanrı Modu Açıldı',
    godmode_deactivated = 'Tanrı Modu Kapatıldı',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Açıldı',
    wallhack_deactivated = 'Wallhack Kapatıldı',

    -- ── Hata ayıklama modu ──────────────────────────────────
    debug_activated = 'Hata Ayıklama Modu Açıldı',
    debug_deactivated = 'Hata Ayıklama Modu Kapatıldı',

    -- ── Bildirimler: araçlar ────────────────────────────────
    vehicle_repaired = 'Araç Tamir Edildi',
    vehicle_repaired_desc = 'Araç başarıyla tamir edildi.',
    vehicle_deleted = 'Araç Silindi',
    vehicle_deleted_desc = 'Araç başarıyla silindi.',
    vehicle_spawned = 'Araç Çıkarıldı',
    vehicle_spawned_desc = '%s aracı başarıyla çıkarıldı.',
    vehicle_plate_changed = 'Plaka Değiştirildi',
    vehicle_plate_changed_desc = 'Araç plakası şuna değiştirildi: %s',
    vehicle_refueled = 'Araç Dolduruldu',
    vehicle_refueled_desc = 'Aracın yakıtı başarıyla dolduruldu.',
    vehicle_keys_given = 'Anahtarlar Alındı',
    vehicle_keys_given_desc = 'Şu plakalı aracın anahtarlarını aldın: %s',
    vehicle_color_changed = 'Araç Rengi Değiştirildi',
    vehicle_color_changed_desc = 'Araç rengi şuna değiştirildi: %s',
    vehicle_torque_set = 'Tork Çarpanı Ayarlandı',
    vehicle_torque_set_desc = 'Tork şuna ayarlandı: %sx',
    vehicle_torque_disabled = 'Tork Çarpanı Devre Dışı',

    -- ── İzleme ──────────────────────────────────────────────
    spectate_started = 'İzleniyor',
    spectate_started_desc = '%s izleniyor. Durdurmak için X\'e bas.',
    spectate_ended = 'İzleme Sonlandı',
    spectate_ended_desc = 'Artık kimseyi izlemiyorsun.',
    spectate_error = 'İzleme Hatası',
    spectate_error_desc = 'Hedef oyuncu bulunamadı veya artık mevcut değil.',

    -- ── Işınlanma ───────────────────────────────────────────
    teleport_success = 'Işınlandın',
    teleport_success_desc = 'Başarıyla ışınlandın.',

    -- ── Canlandırma / iyileştirme ───────────────────────────
    player_revived = 'Oyuncu Canlandırıldı',
    player_revived_desc = '%s adlı oyuncuyu başarıyla canlandırdın.',
    player_healed = 'Oyuncu İyileştirildi',
    player_healed_desc = '%s adlı oyuncuyu başarıyla iyileştirdin.',
    self_revived = 'Canlandın',
    self_revived_desc = 'Kendini canlandırdın.',
    self_healed = 'İyileştin',
    self_healed_desc = 'Kendini iyileştirdin.',

    -- ── Pedler ──────────────────────────────────────────────
    ped_changed = 'Ped Değiştirildi',
    ped_changed_desc = 'Ped modelin değiştirildi.',
    ped_restored = 'Ped Geri Yüklendi',
    ped_restored_desc = 'Orijinal ped modelin geri yüklendi.',

    skin_menu_opened = 'Kıyafet Menüsü Açıldı',

    admin_menu_opened = 'Yetkili Menüsü Açıldı',
    admin_menu_closed = 'Yetkili Menüsü Kapatıldı',

    entity_deleted = 'Varlık Silindi',
    entity_deleted_desc = 'Varlık başarıyla silindi.',

    player_frozen = 'Oyuncu Donduruldu',
    player_frozen_desc = '%s adlı oyuncu donduruldu.',
    player_unfrozen = 'Oyuncu Çözüldü',
    player_unfrozen_desc = '%s adlı oyuncunun dondurulması kaldırıldı.',

    -- ── Özel plaka ──────────────────────────────────────────
    dialog_license_plate = 'Özel Plaka',
    dialog_license_plate_label = 'Plaka',
    dialog_license_plate_placeholder = 'Plaka',

    -- ── Para alma ───────────────────────────────────────────
    player_removemoney = 'Para Al',
    player_removemoney_desc = 'Seçili oyuncudan para al',
    dialog_removemoney = 'Para Al',
    removemoney_input_label = 'Miktar',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Hesap',
    notify_removemoney_success = 'Para Alındı',
    -- Argüman sırası İngilizce ile aynı olmalı: tutar, oyuncu, hesap.
    notify_removemoney_success_desc = '$%s tutarını %s adlı oyuncudan aldın (hesap: %s)',
    notify_removemoney_fail = 'Başarısız',
    notify_removemoney_fail_desc = '%s adlı oyuncudan para alınamadı (bakiye yetersiz olabilir).',

    -- ── Boyutlar / routing bucket ───────────────────────────
    self_dimension = 'Kendi Boyutumu Ayarla',
    self_dimension_desc = 'Kendini bir routing buckete taşı (0 = ana dünya)',
    player_dimension = 'Boyut Ayarla',
    player_dimension_desc = 'Bu oyuncuyu bir routing buckete taşı',
    player_dimension_bring = 'Boyutuma Getir',
    player_dimension_bring_desc = 'Bu oyuncuyu mevcut boyutuna çek',
    player_dimension_goto = 'Oyuncunun Boyutuna Katıl',
    player_dimension_goto_desc = 'Kendini bu oyuncunun boyutuna taşı',
    dialog_dimension = 'Boyut Ayarla',
    dimension_input_label = 'Boyut (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Boyut Değiştirildi',
    notify_dimension_self_desc = 'Artık %s numaralı boyuttasın.',
    notify_dimension_player_desc = '%s adlı oyuncu %s numaralı boyuta taşındı.',
    notify_dimension_join_desc = '%s adlı oyuncunun boyutuna katıldın (%s).',
    notify_dimension_fail = 'Boyut Hatası',
    notify_dimension_fail_desc = 'Boyut değiştirilemedi.',

    -- ── Araca ışınlanma ─────────────────────────────────────
    player_tp_vehicle = 'Aracın İçine Işınlan',
    player_tp_vehicle_desc = 'Kurtarmaya yardım etmek için bu oyuncunun aracına bin',
    notify_tp_vehicle_fail = 'Araç Yok',
    notify_tp_vehicle_fail_desc = '%s bir araçta değil.',
    notify_tp_vehicle_success = 'Işınlandın',
    notify_tp_vehicle_success_desc = '%s adlı oyuncunun aracına yerleştirildin.',

    -- ── Araç kurtarma ───────────────────────────────────────
    recover_car = 'Aracı Kurtar / Düzelt',
    recover_car_desc = 'Düzeltip en yakın yola taşı (deniz/takla)',
    vehicle_recovered = 'Araç Kurtarıldı',
    vehicle_recovered_desc = 'Araç düzeltildi ve en yakın yola yerleştirildi.',

    -- ── Sahip olunan araçlar ────────────────────────────────
    player_owned_vehicles = 'Sahip Olunan Araçlar',
    player_owned_vehicles_desc = 'Bu oyuncunun araçlarını gör, ekle veya kaldır',
    owned_vehicles_menu = 'Sahip Olunan Araçlar (%s)',
    owned_vehicles_add = 'Araç Ekle',
    owned_vehicles_add_desc = 'Bu oyuncunun garajına bir araç ekle',
    owned_vehicles_none = 'Araç Yok',
    owned_vehicles_none_desc = 'Bu oyuncunun hiç aracı yok.',
    owned_vehicle_desc = 'Plaka: %s · kaldırmak için tıkla',
    dialog_add_vehicle = 'Araç Ekle',
    add_vehicle_model_label = 'Model Adı',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Plaka (isteğe bağlı)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '%s kaldırılsın mı?',
    notify_owned_added = 'Araç Eklendi',
    notify_owned_added_desc = '%s (plaka %s) %s adlı oyuncuya eklendi.',
    notify_owned_removed = 'Araç Kaldırıldı',
    notify_owned_removed_desc = '%s plakası %s adlı oyuncudan kaldırıldı.',
    notify_owned_fail = 'Veritabanı Hatası',
    notify_owned_fail_desc = 'Araç veritabanı işlemi başarısız oldu.',

    -- ── Ped menüsü ──────────────────────────────────────────
    player_pedmenu = 'Ped Menüsü Ver',
    player_pedmenu_desc = 'Bu oyuncunun ekranında ped seçim menüsü aç',
    pedmenu_title = 'Ped Menüsü',
    pedmenu_given = 'Ped Menüsü Gönderildi',
    pedmenu_given_desc = '%s için ped menüsü açıldı.'
}
