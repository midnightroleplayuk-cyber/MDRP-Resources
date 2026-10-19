-- ============================================================
-- PORTUGUÊS (BRASIL) — pt-br
-- ------------------------------------------------------------
-- Camada sobre configs/strings.lua. Qualquer chave que não
-- esteja aqui mantém o texto em inglês, então traduzir por
-- partes é seguro.
--
-- Existe separado de locales/pt.lua (português europeu) porque
-- o vocabulário diverge no que este script mais usa: tela vs
-- ecrã, celular vs telemóvel, você vs tu, dinheiro em espécie
-- vs numerário. Config.Locale = 'pt-BR' cai exatamente aqui;
-- só 'pt' é que usa a versão europeia.
--
-- Os marcadores %s têm de ser mantidos e na MESMA ordem do
-- original — são preenchidos por :format() no código.
--
-- Ativação:  Config.Locale = 'pt-BR'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['pt-br'] = {
    -- ── Menu principal ──────────────────────────────────────
    main_title = 'Menu de Administração',
    self_options = 'Opções Pessoais',
    self_options_desc = 'Opções sobre você mesmo',
    player_options_title = 'Opções de Jogador',
    player_options_desc = 'Opções sobre outros jogadores',
    vehicle_options = 'Opções de Veículo',
    vehicle_options_desc = 'Opções sobre veículos',
    server_options = 'Opções de Servidor',
    server_options_desc = 'Opções sobre o servidor',
    admin_zone_options = 'Zonas de Admin',
    admin_zone_options_desc = 'Gerenciar, adicionar e excluir zonas de admin',
    developer_options = 'Opções de Desenvolvedor',
    developer_options_desc = '',

    -- ── Opções pessoais ─────────────────────────────────────
    self_options_menu = 'Opções Pessoais',
    self_health = 'Vida (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Reviver',
    self_revive_desc = 'Reviver você mesmo',
    self_heal = 'Curar',
    self_heal_desc = 'Curar você mesmo',
    self_skinmenu = 'Menu de Roupas',
    self_set_ped = 'Trocar de Ped',
    self_skinmenu_desc = 'Abrir o menu de roupas localmente',
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
    player_spectate = 'Espectar',
    player_spectate_desc = 'Assistir às ações deste jogador',
    player_playerdata = 'Dados do Jogador',
    player_playerdata_desc = 'Ver os dados do jogador',
    player_revive = 'Reviver',
    player_revive_desc = 'Reviver o jogador',
    player_heal = 'Curar',
    player_heal_desc = 'Curar o jogador',
    player_skinmenu = 'Menu de Roupas',
    player_skinmenu_desc = 'Abrir um menu de roupas na tela do jogador',
    player_money = 'Dar Dinheiro',
    player_money_desc = 'Dar dinheiro ao jogador selecionado',
    player_item = 'Dar Item',
    player_item_desc = 'Dar um item ao jogador selecionado',
    player_openinv = 'Abrir Inventário',
    player_openinv_desc = 'Abrir o inventário do jogador',
    player_clearinv = 'Limpar Inventário',
    player_clearinv_desc = 'Limpar o inventário do jogador',
    player_teleport_to = 'Teleportar Até o Jogador',
    player_teleport_to_desc = 'Teleportar você até o jogador',
    player_bring = 'Trazer',
    player_bring_desc = 'Trazer o jogador até a sua posição',
    player_kick = 'Expulsar',
    player_kick_desc = 'Expulsar o jogador do servidor',
    player_ban = 'Banir Jogador',

    -- ── Menu de veículo ─────────────────────────────────────
    vehicle_menu = 'Menu de Veículo',
    spawn_car = 'Spawnar Veículo',
    spawn_car_desc = 'Spawnar um veículo',
    repair_car = 'Consertar Veículo',
    repair_car_desc = 'Consertar o veículo atual ou o mais próximo',
    delete_car = 'Excluir Veículo',
    delete_car_desc = 'Excluir o veículo atual ou o mais próximo',
    number_plate = 'Modificar Placa',
    number_plate_desc = 'Alterar o texto da placa atual',
    refuel = 'Abastecer Veículo',
    refuel_desc = 'Abastecer o veículo atual ou o mais próximo',
    give_keys = 'Dar Chaves',
    give_keys_desc = 'Dar a você as chaves do veículo atual',
    doors = 'Trancar/Destrancar Portas',
    doors_desc = 'Alterna as travas do veículo mais próximo',
    boost_car = 'Multiplicador de Torque',
    boost_car_desc = 'Modificar o torque do veículo atual',
    color_change = 'Mudar Cor do Veículo',
    color_change_desc = 'Mudar a cor do veículo atual ou o mais próximo',

    -- ── Gerenciamento do servidor ───────────────────────────
    server_management = 'Gerenciamento do Servidor',
    server_announcement = 'Anúncio do Servidor',
    server_announcement_desc = 'Enviar um anúncio global para todo o servidor',
    ban_list = 'Lista de Banimentos',
    ban_list_desc = 'Conferir todos os banimentos ativos',
    objects_list = 'Excluir Entidades',
    objects_list_desc = 'Excluir veículos e peds',
    objects_list_label = 'Opções',
    weather_menu = 'Gerenciamento do Clima',
    weather_menu_desc = 'Gerenciar o clima',

    -- ── Zonas de admin ──────────────────────────────────────
    zones_create = 'Criar Zona',
    zones_create_desc = 'Criar uma nova zona de admin',
    zones_manage = 'Gerenciar Zonas',
    zones_manage_desc = 'Editar ou excluir as zonas ativas',
    zone_edit_current = 'Editar Zona Atual',
    zone_edit_current_desc = 'Gerenciar a zona em que você está',
    zone_delete_current = 'Excluir Zona Atual',
    zone_delete_current_desc = 'Excluir a zona em que você está',
    zone_manage_menu = 'Editando a Zona (%s)',
    zone_edit = 'Editar Zona',
    zone_edit_desc = 'Modificar a zona: %s',
    zone_delete = 'Excluir Zona',
    zone_delete_desc = 'Excluir a zona: %s',
    zone_teleport = 'Teleportar Para a Zona',
    zone_teleport_desc = 'Ir para a zona: %s',

    -- ── Menu de desenvolvedor ───────────────────────────────
    dev_options = 'Opções de Desenvolvedor',
    debug_mode = 'Modo Debug',
    debug_mode_desc = 'Ligar/desligar o modo debug',
    copy_vec3 = 'Copiar Coordenadas Vector3',
    copy_vec3_desc = 'Copia a sua posição atual (vector3) para a área de transferência',
    copy_vec4 = 'Copiar Coordenadas Vector4',
    copy_vec4_desc = 'Copia a sua posição atual (vector4) para a área de transferência',
    copy_heading = 'Copiar Direção',
    copy_heading_desc = 'Copia a sua direção atual para a área de transferência',
    cant_delete = 'Não dá para excluir!',
    cant_delete_player_desc = 'Você não pode excluir peds de jogadores!',
    cant_delete_entity_desc = 'Você não pode excluir os objetos padrão do mapa!',

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
    ban_list_no_data_desc = 'Nenhum banimento ativo foi encontrado!',

    -- ── Dados do jogador ────────────────────────────────────
    playerdata_menu = 'Dados do Jogador',
    playerdata_license_esx = 'Licença: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Clique para copiar a licença completa',
    playerdata_igname = 'Nome: %s',
    playerdata_igname_desc = 'Nome completo do jogador dentro do jogo',
    playerdata_steam = 'Nome na Steam: %s',
    playerdata_steam_desc = 'Nome completo do jogador na Steam',
    playerdata_gender = 'Sexo: %s',
    playerdata_gender_desc = 'Sexo do jogador',
    playerdata_cash = 'Dinheiro: %s',
    playerdata_cash_desc = 'Saldo em dinheiro do jogador',
    playerdata_bank = 'Banco: %s',
    playerdata_bank_desc = 'Saldo bancário do jogador',
    playerdata_blackmoney = 'Dinheiro Sujo: %s',
    playerdata_blackmoney_desc = 'Saldo de dinheiro sujo do jogador',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Aperte [E] para excluir a entidade  \nHash: %s  \nCoords: vec3(%s, %s, %s)  \nDireção: %s  \nDono: [%s] - %s',
    debug_textui_noname = 'Aperte [E] para excluir a entidade\n  Hash: %s\n  Coords: vec3(%s, %s, %s)\n  Direção: %s\n  Dono: DESCONHECIDO',

    textui_invisible = 'Modo Invisível - Ativado',
    textui_godmode = 'Modo Deus - Ativado',
    textui_wallhack = 'Wallhack - Ativado',
    textui_noclip_activated = 'No Clip - Ativado',
    textui_torque = 'Multiplicador de Torque - %s',

    -- ── Anúncios ────────────────────────────────────────────
    dialog_announce = 'Anúncio',
    dialog_announce_label = 'Mensagem',
    dialog_announce_select = 'Todo mundo',
    dialog_announce_everyone = 'Todo mundo',
    dialog_announce_placeholder = 'Mensagem importante aqui. . .',

    -- ── Desbanimento ────────────────────────────────────────
    dialog_unban = 'Tem certeza?',
    dialog_unban_content = 'Quer mesmo desbanir %s?',

    -- ── Exclusão de entidades ───────────────────────────────
    dialog_objects = 'Escolha uma opção',
    dialog_clear_objects = 'Excluir TODOS os objetos',
    dialog_clear_cars = 'Excluir TODOS os carros (sem motorista)',
    dialog_clear_peds = 'Excluir TODOS os peds',

    -- ── Dar dinheiro ────────────────────────────────────────
    dialog_givemoney = 'Dar Dinheiro',
    givemoney_input_label = 'Valor',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Conta',
    givemoney_select_option1 = 'Dinheiro',
    givemoney_select_option2 = 'Banco',
    givemoney_select_option3 = 'Dinheiro Sujo',

    -- ── Dar item ────────────────────────────────────────────
    dialog_giveitem = 'Dar Item',
    giveitem_input_label = 'Nome do Item',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Quantidade',
    giveitem_amount_input_placeholder = '3',

    -- ── Spawnar veículo ─────────────────────────────────────
    dialog_spawn_a_car = 'Spawnar Veículo',
    dialog_car_model = 'Nome do Modelo',
    dialog_car_model_holder = 'Ex: 20charger',
    dialog_car_plate = 'Placa (opcional)',
    dialog_car_plate_holder = 'Ex: W4S4B1',
    dialog_car_color_primary = 'Cor Primária (opcional)',
    dialog_car_color_second = 'Cor Secundária (opcional)',
    dialog_car_maxed = 'Modificações no Máximo (opcional)',

    -- ── Expulsão ────────────────────────────────────────────
    dialog_kick = 'Expulsar %s',
    dialog_kick_reason = 'Motivo',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Você foi expulso do servidor!',

    -- ── Banimento ───────────────────────────────────────────
    dialog_ban = 'Banir %s',
    dialog_ban_reason = 'Motivo',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Você foi banido deste servidor!',

    -- ── Criação de zona ─────────────────────────────────────
    dialog_zone_create = 'Criação de Zona',
    dialog_zone_name = 'Nome',
    dialog_zone_name_desc = 'O nome da zona / do blip',
    dialog_zone_name_holder = 'Zona de Admin',
    dialog_zone_text = 'Texto Exibido',
    dialog_zone_text_desc = 'O texto exibido aos jogadores dentro da zona',
    dialog_zone_text_holder = 'ZONA DE ADMIN - ATIVA',
    dialog_zone_size = 'Tamanho',
    dialog_zone_speed = 'Limite de Velocidade',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID do Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID da Cor',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Piscando',
    dialog_zone_disarm = 'Desarmar',
    dialog_zone_revive = 'Reviver',
    dialog_zone_invincible = 'Invencível',
    dialog_zone_edit = 'Editando "%s"',
    dialog_zone_delete_confirm = 'Tem certeza?',
    dialog_zone_delete_confirm_desc = 'Quer mesmo excluir a zona: %s',

    -- ── Notificações: dinheiro ──────────────────────────────
    notify_givemoney_success = 'Dinheiro Concedido',
    notify_givemoney_success_desc = 'Você creditou %s em $%s na conta: %s',
    notify_givemoney_fail = 'Sem Sucesso',
    notify_givemoney_fail_desc = 'Você tentou creditar %s mas algo deu errado! Tente de novo.',

    -- ── Notificações: itens ─────────────────────────────────
    notify_giveitem_success = 'Item Concedido',
    notify_giveitem_success_desc = 'Você creditou %s. Item: %s Quantidade: %s',
    notify_giveitem_fail = 'Falhou',
    notify_giveitem_fail_desc = 'Você tentou creditar %s mas algo deu errado! Tente de novo.',

    -- ── Notificações: expulsão / banimento ──────────────────
    notify_kicked_success = 'Expulsão Bem-sucedida',
    notify_kicked_success_desc = 'Você expulsou %s com sucesso',
    notify_banned_success = 'Banimento Bem-sucedido',
    notify_banned_success_desc = 'Você baniu %s com sucesso',

    -- ── Notificações: inventário ────────────────────────────
    notify_clearedinv = 'Inventário Limpo',
    notify_clearedinv_desc = 'Você limpou o inventário de %s com sucesso',

    -- ── Notificações: ID inválido ───────────────────────────
    notify_invalidid = 'ID Inválido',
    notify_invalidid_desc = 'O ID digitado é inválido, tente de novo.',

    -- ── Notificações: limpeza ───────────────────────────────
    notify_deleted_car = 'Carros Excluídos',
    notify_deleted_car_desc = 'Você excluiu todos os carros sem motorista com sucesso.',
    notify_deleted_ped = 'Peds Excluídos',
    notify_deleted_ped_desc = 'Você excluiu todos os peds do mapa com sucesso',
    notify_deleted_objects = 'Objetos Excluídos',
    notify_deleted_objects_desc = 'Você excluiu todos os objetos do mapa com sucesso',

    -- ── Notificações: clima ─────────────────────────────────
    notify_weather = 'Clima Modificado',
    notify_weather_desc = 'Clima alterado para: %s',

    -- ── Notificações: copiar coordenadas ────────────────────
    notify_copied = 'Copiado',
    notify_copied_vec3 = 'Vector3 copiado para a área de transferência!',
    notify_copied_vec4 = 'Vector4 copiado para a área de transferência!',
    notify_copied_headin = 'Direção copiada para a área de transferência!',

    -- ── Notificações: portas ────────────────────────────────
    notify_locked_doors = 'Trancado',
    notify_locked_doors_desc = 'Portas do veículo trancadas com sucesso.',
    notify_unlocked_doors = 'Destrancado',
    notify_unlocked_doors_desc = 'Portas do veículo destrancadas com sucesso.',

    -- ── Notificações: zonas de admin ────────────────────────
    notify_zone_deleted = 'Zona Excluída',
    notify_zone_deleted_desc = 'Você removeu a zona com sucesso: %s.',
    notify_zone_not_deleted_desc = 'Ocorreu um erro ao tentar excluir a zona: %s.',
    notify_zone_edited = 'Zona Modificada',
    notify_zone_edited_desc = 'Você modificou a zona com sucesso: %s.',
    notify_zone_not_edited_desc = 'Ocorreu um erro ao tentar modificar a zona: %s.',
    notify_zone_action_cancelled = 'Ação Cancelada',
    notify_zone_delete_cancel = 'Você cancelou a exclusão da zona: %s',
    notify_zone_no_weapons = 'Armas Não Autorizadas',
    notify_zone_no_weapons_desc = 'Você não tem permissão para usar armas dentro desta zona.',
    notify_zones_not_found = 'Nenhuma Zona',
    notify_zones_not_found_desc = 'No momento não há zonas ativas para gerenciar.',
    notify_zones_teleport = 'Teleportado',
    notify_zones_teleport_desc = 'Você foi teleportado para a zona com sucesso: %s.',

    -- ── Notificações: desbanimento ──────────────────────────
    successfully_unbanned = 'Banimento Revogado',
    successfully_unbanned_desc = 'Você desbaniu com sucesso: %s.',
    unsuccessful_unban = 'Algo deu errado ao tentar desbanir: %s.',

    -- ── Conexão (deferrals) ─────────────────────────────────
    deferral_welcome = '[%s] Olá %s, verificando banimentos. . .',
    deferral_banned = 'Você está banido do servidor. Motivo: "%s" (Tempo restante: %s horas %s minutos).',
    deferral_banned_perm = 'Você está banido do servidor. Motivo: "%s" (Tempo restante: Permanente).',

    -- ── Erros ───────────────────────────────────────────────
    notify_error = 'Erro',
    notify_disabled_keys = 'Nenhum script de chaves de veículo está configurado. Fale com o desenvolvedor do servidor.',
    notify_no_appearance = 'Nenhum script de roupas / aparência detectado. Fale com o desenvolvedor do servidor.',
    notify_no_vehicle = 'Nenhum veículo encontrado!',
    notify_invalid_entry = 'Entrada inválida!',

    -- ── Atalho de teclado ───────────────────────────────────
    keymapping_desc = 'Abrir o Menu de Administração (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Ativado',
    noclip_deactivated = 'NoClip Desativado',

    -- ── Invisibilidade ──────────────────────────────────────
    invisibility_activated = 'Modo Invisível Ativado',
    invisibility_deactivated = 'Modo Invisível Desativado',

    -- ── Modo Deus ───────────────────────────────────────────
    godmode_activated = 'Modo Deus Ativado',
    godmode_deactivated = 'Modo Deus Desativado',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Ativado',
    wallhack_deactivated = 'Wallhack Desativado',

    -- ── Modo debug ──────────────────────────────────────────
    debug_activated = 'Modo Debug Ativado',
    debug_deactivated = 'Modo Debug Desativado',

    -- ── Notificações: veículos ──────────────────────────────
    vehicle_repaired = 'Veículo Consertado',
    vehicle_repaired_desc = 'O veículo foi consertado com sucesso.',
    vehicle_deleted = 'Veículo Excluído',
    vehicle_deleted_desc = 'O veículo foi excluído com sucesso.',
    vehicle_spawned = 'Veículo Spawnado',
    vehicle_spawned_desc = 'O veículo %s foi spawnado com sucesso.',
    vehicle_plate_changed = 'Placa Alterada',
    vehicle_plate_changed_desc = 'Placa do veículo alterada para: %s',
    vehicle_refueled = 'Veículo Abastecido',
    vehicle_refueled_desc = 'O veículo foi abastecido com sucesso.',
    vehicle_keys_given = 'Chaves Recebidas',
    vehicle_keys_given_desc = 'Você recebeu as chaves do veículo de placa: %s',
    vehicle_color_changed = 'Cor do Veículo Alterada',
    vehicle_color_changed_desc = 'Cor do veículo alterada para: %s',
    vehicle_torque_set = 'Multiplicador de Torque Definido',
    vehicle_torque_set_desc = 'Torque definido em: %sx',
    vehicle_torque_disabled = 'Multiplicador de Torque Desativado',

    -- ── Espectar ────────────────────────────────────────────
    spectate_started = 'Espectando',
    spectate_started_desc = 'Espectando %s. Aperte X para parar.',
    spectate_ended = 'Espectação Encerrada',
    spectate_ended_desc = 'Você não está mais espectando ninguém.',
    spectate_error = 'Erro ao Espectar',
    spectate_error_desc = 'Jogador alvo não encontrado ou não existe mais.',

    -- ── Teleporte ───────────────────────────────────────────
    teleport_success = 'Teleportado',
    teleport_success_desc = 'Você foi teleportado com sucesso.',

    -- ── Reviver / curar ─────────────────────────────────────
    player_revived = 'Jogador Revivido',
    player_revived_desc = 'Você reviveu %s com sucesso.',
    player_healed = 'Jogador Curado',
    player_healed_desc = 'Você curou %s com sucesso.',
    self_revived = 'Revivido',
    self_revived_desc = 'Você reviveu a si mesmo.',
    self_healed = 'Curado',
    self_healed_desc = 'Você curou a si mesmo.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Alterado',
    ped_changed_desc = 'O seu modelo de ped foi alterado.',
    ped_restored = 'Ped Restaurado',
    ped_restored_desc = 'O seu modelo de ped original foi restaurado.',

    skin_menu_opened = 'Menu de Roupas Aberto',

    admin_menu_opened = 'Menu de Admin Aberto',
    admin_menu_closed = 'Menu de Admin Fechado',

    entity_deleted = 'Entidade Excluída',
    entity_deleted_desc = 'A entidade foi excluída com sucesso.',

    player_frozen = 'Jogador Congelado',
    player_frozen_desc = 'O jogador %s foi congelado.',
    player_unfrozen = 'Jogador Descongelado',
    player_unfrozen_desc = 'O jogador %s foi descongelado.',

    -- ── Placa personalizada ─────────────────────────────────
    dialog_license_plate = 'Placa Personalizada',
    dialog_license_plate_label = 'Placa',
    dialog_license_plate_placeholder = 'Placa',

    -- ── Tirar dinheiro ──────────────────────────────────────
    player_removemoney = 'Tirar Dinheiro',
    player_removemoney_desc = 'Tirar dinheiro do jogador selecionado',
    dialog_removemoney = 'Tirar Dinheiro',
    removemoney_input_label = 'Valor',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Conta',
    notify_removemoney_success = 'Dinheiro Removido',
    notify_removemoney_success_desc = 'Você tirou $%s de %s (conta: %s)',
    notify_removemoney_fail = 'Sem Sucesso',
    notify_removemoney_fail_desc = 'Não foi possível tirar dinheiro de %s (talvez saldo insuficiente).',

    -- ── Dimensões / routing buckets ─────────────────────────
    self_dimension = 'Definir Minha Dimensão',
    self_dimension_desc = 'Mover você para um routing bucket (0 = mundo principal)',
    player_dimension = 'Definir Dimensão',
    player_dimension_desc = 'Mover este jogador para um routing bucket',
    player_dimension_bring = 'Trazer Para Minha Dimensão',
    player_dimension_bring_desc = 'Puxar este jogador para a sua dimensão atual',
    player_dimension_goto = 'Entrar na Dimensão do Jogador',
    player_dimension_goto_desc = 'Mover você para a dimensão deste jogador',
    dialog_dimension = 'Definir Dimensão',
    dimension_input_label = 'Dimensão (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensão Alterada',
    notify_dimension_self_desc = 'Você está agora na dimensão %s.',
    notify_dimension_player_desc = '%s foi movido para a dimensão %s.',
    notify_dimension_join_desc = 'Você entrou na dimensão de %s (%s).',
    notify_dimension_fail = 'Erro de Dimensão',
    notify_dimension_fail_desc = 'Não foi possível alterar a dimensão.',

    -- ── Teleportar para dentro do veículo ───────────────────
    player_tp_vehicle = 'Teleportar Para o Veículo',
    player_tp_vehicle_desc = 'Entrar no veículo deste jogador para ajudar a recuperá-lo',
    notify_tp_vehicle_fail = 'Sem Veículo',
    notify_tp_vehicle_fail_desc = '%s não está em um veículo.',
    notify_tp_vehicle_success = 'Teleportado',
    notify_tp_vehicle_success_desc = 'Você foi colocado dentro do veículo de %s.',

    -- ── Recuperar veículo ───────────────────────────────────
    recover_car = 'Recuperar / Desvirar Veículo',
    recover_car_desc = 'Endireitar e mover para a rua mais próxima (mar/capotado)',
    vehicle_recovered = 'Veículo Recuperado',
    vehicle_recovered_desc = 'O veículo foi endireitado e colocado na rua mais próxima.',

    -- ── Veículos do jogador ─────────────────────────────────
    player_owned_vehicles = 'Veículos do Jogador',
    player_owned_vehicles_desc = 'Ver, adicionar ou remover os carros deste jogador',
    owned_vehicles_menu = 'Veículos do Jogador (%s)',
    owned_vehicles_add = 'Adicionar Veículo',
    owned_vehicles_add_desc = 'Adicionar um veículo à garagem deste jogador',
    owned_vehicles_none = 'Sem Veículos',
    owned_vehicles_none_desc = 'Este jogador não possui nenhum veículo.',
    owned_vehicle_desc = 'Placa: %s · clique para remover',
    dialog_add_vehicle = 'Adicionar Veículo',
    add_vehicle_model_label = 'Nome do Modelo',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Placa (opcional)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Remover %s?',
    notify_owned_added = 'Veículo Adicionado',
    notify_owned_added_desc = 'Adicionado %s (placa %s) a %s.',
    notify_owned_removed = 'Veículo Removido',
    notify_owned_removed_desc = 'Removida a placa %s de %s.',
    notify_owned_fail = 'Erro de Banco de Dados',
    notify_owned_fail_desc = 'A operação no banco de dados de veículos falhou.',

    -- ── Menu de peds ────────────────────────────────────────
    player_pedmenu = 'Dar Menu de Peds',
    player_pedmenu_desc = 'Abrir um menu de seleção de ped na tela deste jogador',
    pedmenu_title = 'Menu de Peds',
    pedmenu_given = 'Menu de Peds Enviado',
    pedmenu_given_desc = 'Menu de peds aberto para %s.'
}
