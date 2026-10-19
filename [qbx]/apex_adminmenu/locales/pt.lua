-- ============================================================
-- PORTUGUÊS (pt-PT)
-- ------------------------------------------------------------
-- Overlay sobre configs/strings.lua. Qualquer chave que não
-- esteja aqui usa automaticamente o texto inglês, por isso é
-- seguro traduzir por partes.
--
-- Os marcadores %s têm de ser mantidos e pela MESMA ordem do
-- original — são preenchidos por :format() no código.
-- ============================================================

Locales = Locales or {}

-- ============================================================
-- Painel F6 (NUI)
-- ------------------------------------------------------------
-- O painel é HTML, por isso as strings dele vivem numa tabela
-- própria enviada para a NUI no arranque. Os elementos traduzíveis
-- em html/admin/index.html têm data-i18n="chave".
-- Chaves em falta mantêm o texto inglês do HTML.
-- ============================================================
PanelLocales = PanelLocales or {}

PanelLocales['pt'] = {
    -- Navegação
    nav_home = 'Início',
    nav_players = 'Jogadores',
    nav_monitoring = 'Monitorização',
    nav_moderation = 'Moderação',
    nav_chats = 'Conversas',
    nav_items = 'Itens',
    nav_vehicles = 'Veículos',
    nav_console = 'Consola',
    nav_events = 'Registo de Eventos',
    nav_staff = 'Equipa',
    nav_jobs = 'Empregos',
    nav_blips = 'Blips',
    nav_logs = 'Registos',
    nav_settings = 'Definições',

    -- Barra superior
    tb_players = 'Jogadores:',
    tb_uptime = 'Ativo há:',
    tb_search = 'Procurar jogadores, páginas, empregos…',
    tb_announce = 'Anunciar',

    -- Cabeçalhos de página
    page_home = 'Início',
    page_home_sub = 'Mapa ao vivo e estado do servidor',
    page_players = 'Jogadores',
    page_players_sub = 'Jogadores online',

    -- Cartões do Início
    kpi_players = 'Jogadores online',
    kpi_staff = 'Equipa online',
    kpi_new_today = 'Novos jogadores hoje',
    card_vehicle_delete = 'Limpeza de Veículos',
    card_vehicle_delete_sub = 'Remove veículos não utilizados',
    card_next_deletion = 'Próxima limpeza',
    card_server_time = 'Hora do Servidor',
    card_server_time_sub = 'Relógio do jogo',
    card_weather = 'Meteorologia',
    card_latest = 'Últimos Jogadores',
    card_latest_sub = 'Entradas mais recentes',
    btn_update = 'Atualizar',

    -- Definições
    set_appearance = 'Aparência',
    set_behaviour = 'Comportamento',
    set_notifications = 'Notificações',
    set_stafftag = 'Etiqueta de Equipa',
    set_keybinds = 'Teclas',
    set_discord = 'Registos Discord',
    set_theme = 'Tema e Marca',
    set_background = 'Fundo',
    set_uisize = 'Tamanho da Interface',
    set_display_mode = 'Modo de Visualização',
    set_opacity = 'Opacidade do Painel',
    set_custom_colour = 'Cor personalizada',
    set_reset_default = 'Repor predefinição Apex',
    set_dark = 'Escuro',
    set_light = 'Claro',
    set_default = 'Predefinição',
    set_brighter = 'Interface mais clara',

    -- Comuns
    common_close = 'Fechar',
    common_save = 'Guardar',
    common_cancel = 'Cancelar',
    common_search = 'Procurar',
    common_select_player = 'Seleciona um jogador',
    common_select_vehicle = 'Seleciona um veículo para ver os donos',
    common_no_results = 'Sem resultados'
}

Locales['pt'] = {
    -- ── Menu principal ──────────────────────────────────────
    main_title = 'Menu de Administração',
    self_options = 'Opções Pessoais',
    self_options_desc = 'Opções sobre ti próprio',
    player_options_title = 'Opções de Jogador',
    player_options_desc = 'Opções sobre outros jogadores',
    vehicle_options = 'Opções de Veículo',
    vehicle_options_desc = 'Opções relacionadas com veículos',
    server_options = 'Opções de Servidor',
    server_options_desc = 'Opções relacionadas com o servidor',
    admin_zone_options = 'Zonas de Admin',
    admin_zone_options_desc = 'Gerir, criar e apagar zonas de admin',
    developer_options = 'Opções de Programador',
    developer_options_desc = '',

    -- ── Opções pessoais ─────────────────────────────────────
    self_options_menu = 'Opções Pessoais',
    self_health = 'Vida (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Reanimar',
    self_revive_desc = 'Reanima-te a ti próprio',
    self_heal = 'Curar',
    self_heal_desc = 'Cura-te a ti próprio',
    self_skinmenu = 'Menu de Roupa',
    self_set_ped = 'Mudar Ped',
    self_skinmenu_desc = 'Abrir o menu de roupa localmente',
    self_invisible = 'Invisível',
    self_godmode = 'Modo Deus',
    self_wallhack = 'Wallhack',

    -- ── Opções de jogador ───────────────────────────────────
    player_options_menu = 'Jogadores Online %s/%s',
    player_options = 'Jogador: %s',
    player_health = 'Vida do Jogador (%s%%)',
    player_freeze = 'Congelar',
    player_freeze_desc = 'Ligar/desligar',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Ligar/desligar',
    player_spectate = 'Espetar',
    player_spectate_desc = 'Observar as ações deste jogador',
    player_playerdata = 'Dados do Jogador',
    player_playerdata_desc = 'Ver os dados do jogador',
    player_revive = 'Reanimar',
    player_revive_desc = 'Reanimar o jogador',
    player_heal = 'Curar',
    player_heal_desc = 'Curar o jogador',
    player_skinmenu = 'Menu de Roupa',
    player_skinmenu_desc = 'Abrir o menu de roupa ao jogador',
    player_money = 'Dar Dinheiro',
    player_money_desc = 'Dar dinheiro ao jogador selecionado',
    player_item = 'Dar Item',
    player_item_desc = 'Dar um item ao jogador selecionado',
    player_openinv = 'Abrir Inventário',
    player_openinv_desc = 'Abrir o inventário do jogador',
    player_clearinv = 'Limpar Inventário',
    player_clearinv_desc = 'Limpar o inventário do jogador',
    player_teleport_to = 'Teleportar Para o Jogador',
    player_teleport_to_desc = 'Ir ter com o jogador',
    player_bring = 'Trazer',
    player_bring_desc = 'Trazer o jogador até ti',
    player_kick = 'Expulsar',
    player_kick_desc = 'Expulsar o jogador do servidor',
    player_ban = 'Banir Jogador',

    -- ── Menu de veículos ────────────────────────────────────
    vehicle_menu = 'Menu de Veículos',
    spawn_car = 'Criar Veículo',
    spawn_car_desc = 'Fazer aparecer um veículo',
    repair_car = 'Reparar Veículo',
    repair_car_desc = 'Reparar o veículo atual ou o mais próximo',
    delete_car = 'Apagar Veículo',
    delete_car_desc = 'Apagar o veículo atual ou o mais próximo',
    number_plate = 'Alterar Matrícula',
    number_plate_desc = 'Mudar o texto da matrícula atual',
    refuel = 'Abastecer Veículo',
    refuel_desc = 'Abastecer o veículo atual ou o mais próximo',
    give_keys = 'Dar Chaves',
    give_keys_desc = 'Dar-te as chaves do veículo atual',
    doors = 'Trancar/Destrancar Portas',
    doors_desc = 'Alterna a tranca do veículo mais próximo',
    boost_car = 'Multiplicador de Binário',
    boost_car_desc = 'Alterar o binário do veículo atual',
    color_change = 'Mudar Cor do Veículo',
    color_change_desc = 'Mudar a cor do veículo atual ou do mais próximo',

    -- ── Gestão do servidor ──────────────────────────────────
    server_management = 'Gestão do Servidor',
    server_announcement = 'Anúncio do Servidor',
    server_announcement_desc = 'Enviar um anúncio global',
    ban_list = 'Lista de Banimentos',
    ban_list_desc = 'Ver todos os banimentos ativos',
    objects_list = 'Apagar Entidades',
    objects_list_desc = 'Apagar veículos e peds',
    objects_list_label = 'Opções',
    weather_menu = 'Gestão do Tempo',
    weather_menu_desc = 'Gerir as condições meteorológicas',

    -- ── Zonas de admin ──────────────────────────────────────
    zones_create = 'Criar Zona',
    zones_create_desc = 'Criar uma nova zona de admin',
    zones_manage = 'Gerir Zonas',
    zones_manage_desc = 'Editar ou apagar zonas ativas',
    zone_edit_current = 'Editar Zona Atual',
    zone_edit_current_desc = 'Gerir a zona onde te encontras',
    zone_delete_current = 'Apagar Zona Atual',
    zone_delete_current_desc = 'Apagar a zona onde te encontras',
    zone_manage_menu = 'A editar a zona (%s)',
    zone_edit = 'Editar Zona',
    zone_edit_desc = 'Modificar a zona: %s',
    zone_delete = 'Apagar Zona',
    zone_delete_desc = 'Apagar a zona: %s',
    zone_teleport = 'Teleportar Para a Zona',
    zone_teleport_desc = 'Ir para a zona: %s',

    -- ── Programador ─────────────────────────────────────────
    dev_options = 'Opções de Programador',
    debug_mode = 'Modo de Depuração',
    debug_mode_desc = 'Ligar/desligar o modo de depuração',
    copy_vec3 = 'Copiar Coordenadas Vector3',
    copy_vec3_desc = 'Copia a tua posição atual (vector3) para a área de transferência',
    copy_vec4 = 'Copiar Coordenadas Vector4',
    copy_vec4_desc = 'Copia a tua posição atual (vector4) para a área de transferência',
    copy_heading = 'Copiar Orientação',
    copy_heading_desc = 'Copia a tua orientação atual para a área de transferência',
    cant_delete = 'Não é possível apagar!',
    cant_delete_player_desc = 'Não podes apagar peds de jogadores!',
    cant_delete_entity_desc = 'Não podes apagar objetos originais do jogo!',

    -- ── Lista de banimentos ─────────────────────────────────
    ban_list_menu = 'Lista de Banimentos',
    ban_list_name = 'Nome: %s',
    ban_list_license = 'Licença:',
    ban_list_by = 'Aplicado por: %s',
    ban_list_reason = 'Motivo: %s',
    ban_list_length = 'Tempo restante: %s horas %s minutos',
    ban_list_modify = 'Modificar Banimento',
    ban_list_unban = 'Desbanir Jogador',
    ban_list_no_data = 'Sem Banimentos',
    ban_list_no_data_desc = 'Não foram encontrados banimentos ativos!',

    -- ── Dados do jogador ────────────────────────────────────
    playerdata_menu = 'Dados do Jogador',
    playerdata_license_esx = 'Licença: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Clica para copiar a licença completa',
    playerdata_igname = 'Nome: %s',
    playerdata_igname_desc = 'Nome completo do jogador dentro do jogo',
    playerdata_steam = 'Nome Steam: %s',
    playerdata_steam_desc = 'Nome Steam completo do jogador',
    playerdata_gender = 'Género: %s',
    playerdata_gender_desc = 'Género do jogador',
    playerdata_cash = 'Dinheiro: %s',
    playerdata_cash_desc = 'Saldo em dinheiro do jogador',
    playerdata_bank = 'Banco: %s',
    playerdata_bank_desc = 'Saldo bancário do jogador',
    playerdata_blackmoney = 'Dinheiro Sujo: %s',
    playerdata_blackmoney_desc = 'Saldo de dinheiro sujo do jogador',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Prime [E] para apagar a entidade  \nHash: %s  \nCoords: vec3(%s, %s, %s)  \nOrientação: %s  \nDono: [%s] - %s',
    debug_textui_noname = 'Prime [E] para apagar a entidade\n  Hash: %s\n  Coords: vec3(%s, %s, %s)\n  Orientação: %s\n  Dono: DESCONHECIDO',
    textui_invisible = 'Modo Invisível - Ativado',
    textui_godmode = 'Modo Deus - Ativado',
    textui_wallhack = 'Wallhack - Ativado',
    textui_noclip_activated = 'No Clip - Ativado',
    textui_torque = 'Multiplicador de Binário - %s',

    -- ── Diálogos ────────────────────────────────────────────
    dialog_announce = 'Anúncio',
    dialog_announce_label = 'Mensagem',
    dialog_announce_select = 'Toda a gente',
    dialog_announce_everyone = 'Todos',
    dialog_announce_placeholder = 'Mensagem importante aqui. . .',
    dialog_unban = 'Tens a certeza?',
    dialog_unban_content = 'Queres mesmo desbanir %s?',

    dialog_objects = 'Escolhe uma opção',
    dialog_clear_objects = 'Limpar TODOS os objetos',
    dialog_clear_cars = 'Limpar TODOS os carros (sem condutor)',
    dialog_clear_peds = 'Limpar TODOS os peds',

    dialog_givemoney = 'Dar Dinheiro',
    givemoney_input_label = 'Quantia',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Conta',
    givemoney_select_option1 = 'Dinheiro',
    givemoney_select_option2 = 'Banco',
    givemoney_select_option3 = 'Dinheiro Sujo',

    dialog_giveitem = 'Dar Item',
    giveitem_input_label = 'Nome do Item',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Quantidade',
    giveitem_amount_input_placeholder = '3',

    dialog_spawn_a_car = 'Criar Veículo',
    dialog_car_model = 'Nome do Modelo',
    dialog_car_model_holder = 'Ex: 20charger',
    dialog_car_plate = 'Matrícula (opcional)',
    dialog_car_plate_holder = 'Ex: W4S4B1',
    dialog_car_color_primary = 'Cor Primária (opcional)',
    dialog_car_color_second = 'Cor Secundária (opcional)',
    dialog_car_maxed = 'Modificações no Máximo (opcional)',

    dialog_kick = 'Expulsar %s',
    dialog_kick_reason = 'Motivo',
    dialog_kick_placeholder = 'Batota',
    kicked_reason_replace = 'Foste expulso do servidor!',

    dialog_ban = 'Banir %s',
    dialog_ban_reason = 'Motivo',
    dialog_ban_placeholder = 'Batota',
    ban_reason_replace = 'Foste banido deste servidor!',

    dialog_zone_create = 'Criação de Zona',
    dialog_zone_name = 'Nome',
    dialog_zone_name_desc = 'O nome da zona/blip',
    dialog_zone_name_holder = 'Zona de Admin',
    dialog_zone_text = 'Texto a Mostrar',
    dialog_zone_text_desc = 'Texto mostrado aos jogadores dentro da zona',
    dialog_zone_text_holder = 'ZONA DE ADMIN - ATIVA',
    dialog_zone_size = 'Tamanho',
    dialog_zone_speed = 'Limite de Velocidade',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID do Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID da Cor',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Intermitente',
    dialog_zone_disarm = 'Desarmar',
    dialog_zone_revive = 'Reanimar',
    dialog_zone_invincible = 'Invencível',
    dialog_zone_edit = 'A editar "%s"',
    dialog_zone_delete_confirm = 'Tens a certeza?',
    dialog_zone_delete_confirm_desc = 'Queres mesmo apagar a zona: %s',

    dialog_license_plate = 'Matrícula Personalizada',
    dialog_license_plate_label = 'Matrícula',
    dialog_license_plate_placeholder = 'Matrícula',

    -- ── Notificações ────────────────────────────────────────
    notify_givemoney_success = 'Dinheiro Creditado',
    notify_givemoney_success_desc = 'Creditaste %s $%s na conta: %s',
    notify_givemoney_fail = 'Sem Sucesso',
    notify_givemoney_fail_desc = 'Tentaste creditar %s mas algo correu mal! Tenta novamente.',

    notify_giveitem_success = 'Item Entregue',
    notify_giveitem_success_desc = 'Entregaste a %s. Item: %s Quantidade: %s',
    notify_giveitem_fail = 'Falhou',
    notify_giveitem_fail_desc = 'Tentaste entregar a %s mas algo correu mal! Tenta novamente.',

    notify_kicked_success = 'Expulsão Concluída',
    notify_kicked_success_desc = 'Expulsaste %s com sucesso',

    notify_banned_success = 'Banimento Concluído',
    notify_banned_success_desc = 'Baniste %s com sucesso',

    notify_clearedinv = 'Inventário Limpo',
    notify_clearedinv_desc = 'Limpaste o inventário de %s com sucesso',

    notify_invalidid = 'ID Inválido',
    notify_invalidid_desc = 'O ID que introduziste é inválido, tenta novamente.',

    notify_deleted_car = 'Carros Apagados',
    notify_deleted_car_desc = 'Apagaste todos os carros sem condutor com sucesso.',

    notify_deleted_ped = 'Peds Apagados',
    notify_deleted_ped_desc = 'Apagaste todos os peds do mapa com sucesso',

    notify_deleted_objects = 'Objetos Apagados',
    notify_deleted_objects_desc = 'Apagaste todos os objetos do mapa com sucesso',

    notify_weather = 'Tempo Alterado',
    notify_weather_desc = 'Tempo alterado para: %s',

    notify_copied = 'Copiado',
    notify_copied_vec3 = 'Copiaste o vector3 para a área de transferência!',
    notify_copied_vec4 = 'Copiaste o vector4 para a área de transferência!',
    notify_copied_headin = 'Copiaste a orientação para a área de transferência!',

    notify_locked_doors = 'Trancado',
    notify_locked_doors_desc = 'Portas do veículo trancadas com sucesso.',
    notify_unlocked_doors = 'Destrancado',
    notify_unlocked_doors_desc = 'Portas do veículo destrancadas com sucesso.',

    notify_zone_deleted = 'Zona Apagada',
    notify_zone_deleted_desc = 'Removeste a zona com sucesso: %s.',
    notify_zone_not_deleted_desc = 'Ocorreu um erro ao apagar a zona: %s.',
    notify_zone_edited = 'Zona Modificada',
    notify_zone_edited_desc = 'Modificaste a zona com sucesso: %s.',
    notify_zone_not_edited_desc = 'Ocorreu um erro ao modificar a zona: %s.',
    notify_zone_action_cancelled = 'Ação Cancelada',
    notify_zone_delete_cancel = 'Cancelaste a eliminação da zona: %s',
    notify_zone_no_weapons = 'Armas Não Autorizadas',
    notify_zone_no_weapons_desc = 'Não tens permissão para usar armas dentro desta zona.',
    notify_zones_not_found = 'Sem Zonas',
    notify_zones_not_found_desc = 'Não existem zonas ativas para gerir.',
    notify_zones_teleport = 'Teleportado',
    notify_zones_teleport_desc = 'Teleportaste para a zona: %s.',

    successfully_unbanned = 'Banimento Revogado',
    successfully_unbanned_desc = 'Desbaniste %s com sucesso.',
    unsuccessful_unban = 'Algo correu mal ao tentar desbanir: %s.',

    -- ── Sistema de banimentos ───────────────────────────────
    deferral_welcome = '[%s] Olá %s, a verificar banimentos. . .',
    deferral_banned = 'Estás banido do servidor. Motivo: \'%s\' (Tempo restante: %s horas %s minutos).',
    deferral_banned_perm = 'Estás banido do servidor. Motivo: \'%s\' (Tempo restante: Permanente).',

    -- ── Erros ───────────────────────────────────────────────
    notify_error = 'Erro',
    notify_disabled_keys = 'Não há nenhum script de chaves configurado. Contacta o programador do servidor.',
    notify_no_appearance = 'Não foi detetado nenhum script de roupa/aparência. Contacta o programador do servidor.',
    notify_no_vehicle = 'Nenhum veículo encontrado!',
    notify_invalid_entry = 'Entrada inválida!',

    keymapping_desc = 'Abrir o Menu de Admin (apex_adminmenu)',

    -- ── Estados ligados/desligados ──────────────────────────
    noclip_activated = 'NoClip Ativado',
    noclip_deactivated = 'NoClip Desativado',
    invisibility_activated = 'Modo Invisível Ativado',
    invisibility_deactivated = 'Modo Invisível Desativado',
    godmode_activated = 'Modo Deus Ativado',
    godmode_deactivated = 'Modo Deus Desativado',
    wallhack_activated = 'Wallhack Ativado',
    wallhack_deactivated = 'Wallhack Desativado',
    debug_activated = 'Modo de Depuração Ativado',
    debug_deactivated = 'Modo de Depuração Desativado',

    -- ── Veículos ────────────────────────────────────────────
    vehicle_repaired = 'Veículo Reparado',
    vehicle_repaired_desc = 'O veículo foi reparado com sucesso.',
    vehicle_deleted = 'Veículo Apagado',
    vehicle_deleted_desc = 'O veículo foi apagado com sucesso.',
    vehicle_spawned = 'Veículo Criado',
    vehicle_spawned_desc = 'O veículo %s foi criado com sucesso.',
    vehicle_plate_changed = 'Matrícula Alterada',
    vehicle_plate_changed_desc = 'Matrícula do veículo alterada para: %s',
    vehicle_refueled = 'Veículo Abastecido',
    vehicle_refueled_desc = 'O veículo foi abastecido com sucesso.',
    vehicle_keys_given = 'Chaves Recebidas',
    vehicle_keys_given_desc = 'Recebeste as chaves do veículo com a matrícula: %s',
    vehicle_color_changed = 'Cor Alterada',
    vehicle_color_changed_desc = 'Cor do veículo alterada para: %s',
    vehicle_torque_set = 'Binário Definido',
    vehicle_torque_set_desc = 'Binário definido para: %sx',
    vehicle_torque_disabled = 'Multiplicador de Binário Desativado',

    -- ── Espetar ─────────────────────────────────────────────
    spectate_started = 'A Observar',
    spectate_started_desc = 'A observar %s. Prime X para parar.',
    spectate_ended = 'Observação Terminada',
    spectate_ended_desc = 'Já não estás a observar ninguém.',
    spectate_error = 'Erro ao Observar',
    spectate_error_desc = 'Jogador alvo não encontrado ou já não existe.',

    -- ── Teleporte ───────────────────────────────────────────
    teleport_success = 'Teleportado',
    teleport_success_desc = 'Foste teleportado com sucesso.',

    -- ── Reanimar / curar ────────────────────────────────────
    player_revived = 'Jogador Reanimado',
    player_revived_desc = 'Reanimaste %s com sucesso.',
    player_healed = 'Jogador Curado',
    player_healed_desc = 'Curaste %s com sucesso.',
    self_revived = 'Reanimado',
    self_revived_desc = 'Reanimaste-te a ti próprio.',
    self_healed = 'Curado',
    self_healed_desc = 'Curaste-te a ti próprio.',

    -- ── Ped ─────────────────────────────────────────────────
    ped_changed = 'Ped Alterado',
    ped_changed_desc = 'O teu modelo de ped foi alterado.',
    ped_restored = 'Ped Reposto',
    ped_restored_desc = 'O teu modelo de ped original foi reposto.',

    skin_menu_opened = 'Menu de Roupa Aberto',

    admin_menu_opened = 'Menu de Admin Aberto',
    admin_menu_closed = 'Menu de Admin Fechado',

    entity_deleted = 'Entidade Apagada',
    entity_deleted_desc = 'A entidade foi apagada com sucesso.',

    player_frozen = 'Jogador Congelado',
    player_frozen_desc = 'O jogador %s foi congelado.',
    player_unfrozen = 'Jogador Descongelado',
    player_unfrozen_desc = 'O jogador %s foi descongelado.',

    -- ── Remover dinheiro ────────────────────────────────────
    player_removemoney = 'Retirar Dinheiro',
    player_removemoney_desc = 'Retirar dinheiro ao jogador selecionado',
    dialog_removemoney = 'Retirar Dinheiro',
    removemoney_input_label = 'Quantia',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Conta',
    notify_removemoney_success = 'Dinheiro Retirado',
    notify_removemoney_success_desc = 'Retiraste $%s a %s (conta: %s)',
    notify_removemoney_fail = 'Sem Sucesso',
    notify_removemoney_fail_desc = 'Não foi possível retirar dinheiro a %s (talvez saldo insuficiente).',

    -- ── Dimensões / routing buckets ─────────────────────────
    self_dimension = 'Definir a Minha Dimensão',
    self_dimension_desc = 'Mover-te para um routing bucket (0 = mundo principal)',
    player_dimension = 'Definir Dimensão',
    player_dimension_desc = 'Mover este jogador para um routing bucket',
    player_dimension_bring = 'Trazer À Minha Dimensão',
    player_dimension_bring_desc = 'Puxar este jogador para a tua dimensão atual',
    player_dimension_goto = 'Entrar na Dimensão do Jogador',
    player_dimension_goto_desc = 'Mover-te para a dimensão deste jogador',
    dialog_dimension = 'Definir Dimensão',
    dimension_input_label = 'Dimensão (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensão Alterada',
    notify_dimension_self_desc = 'Estás agora na dimensão %s.',
    notify_dimension_player_desc = '%s foi movido para a dimensão %s.',
    notify_dimension_join_desc = 'Entraste na dimensão de %s (%s).',
    notify_dimension_fail = 'Erro de Dimensão',
    notify_dimension_fail_desc = 'Não foi possível alterar a dimensão.',

    -- ── Teleportar para dentro do veículo ───────────────────
    player_tp_vehicle = 'Teleportar Para o Veículo',
    player_tp_vehicle_desc = 'Entrar no veículo deste jogador para ajudar a recuperá-lo',
    notify_tp_vehicle_fail = 'Sem Veículo',
    notify_tp_vehicle_fail_desc = '%s não está num veículo.',
    notify_tp_vehicle_success = 'Teleportado',
    notify_tp_vehicle_success_desc = 'Foste colocado dentro do veículo de %s.',

    -- ── Recuperar veículo ───────────────────────────────────
    recover_car = 'Recuperar / Desvirar Veículo',
    recover_car_desc = 'Endireitar e mover para a estrada mais próxima (mar/capotado)',
    vehicle_recovered = 'Veículo Recuperado',
    vehicle_recovered_desc = 'O veículo foi endireitado e colocado na estrada mais próxima.',

    -- ── Veículos do jogador ─────────────────────────────────
    player_owned_vehicles = 'Veículos Possuídos',
    player_owned_vehicles_desc = 'Ver, adicionar ou remover os carros deste jogador',
    owned_vehicles_menu = 'Veículos Possuídos (%s)',
    owned_vehicles_add = 'Adicionar Veículo',
    owned_vehicles_add_desc = 'Adicionar um veículo à garagem deste jogador',
    owned_vehicles_none = 'Sem Veículos',
    owned_vehicles_none_desc = 'Este jogador não possui nenhum veículo.',
    owned_vehicle_desc = 'Matrícula: %s · clica para remover',
    dialog_add_vehicle = 'Adicionar Veículo',
    add_vehicle_model_label = 'Nome do Modelo',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Matrícula (opcional)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Remover %s?',
    notify_owned_added = 'Veículo Adicionado',
    notify_owned_added_desc = 'Adicionado %s (matrícula %s) a %s.',
    notify_owned_removed = 'Veículo Removido',
    notify_owned_removed_desc = 'Removida a matrícula %s de %s.',
    notify_owned_fail = 'Erro de Base de Dados',
    notify_owned_fail_desc = 'A operação na base de dados de veículos falhou.',

    -- ── Menu de peds ────────────────────────────────────────
    player_pedmenu = 'Dar Menu de Peds',
    player_pedmenu_desc = 'Abrir um menu de seleção de ped no ecrã deste jogador',
    pedmenu_title = 'Menu de Peds',
    pedmenu_given = 'Menu de Peds Enviado',
    pedmenu_given_desc = 'Menu de peds aberto para %s.'
}
