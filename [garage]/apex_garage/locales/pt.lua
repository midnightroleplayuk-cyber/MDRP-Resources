--[[ apex_garage — locales/pt.lua

    Português europeu (pt-PT). Espelha a estrutura de en.lua chave a chave.
    shared/utils.lua faz fallback para Locales.dict['en'], por isso uma chave
    em falta nunca é fatal — mas aqui não deve faltar nenhuma.

    Os especificadores de formato são obrigatórios — manter exatamente:
        ui_sell_confirm  %s (veículo), %s (preço)
        ui_hours         %s (horas)
        n_paid_fee       %s (valor)
        n_sold           $%s (valor)
]]

Locales = Locales or {}
Locales.dict = Locales.dict or {}

Locales.dict['pt'] = {
    -- ─────────────────────────────────────────────────────────────
    -- Prompts (TextUI / etiquetas de target)
    -- ─────────────────────────────────────────────────────────────
    prompt_open      = 'Abrir garagem',
    prompt_store     = 'Guardar veículo',
    prompt_impound   = 'Depósito de apreensões',

    -- Frase do TextUI: <prefixo> [E] <sufixo> <prompt_* em minúsculas>
    -- ex.: "Prime [E] para abrir garagem"
    ui_press_prefix  = 'Prime',
    ui_press_suffix  = 'para',

    -- ─────────────────────────────────────────────────────────────
    -- UI — estrutura, listas e filtros
    -- ─────────────────────────────────────────────────────────────
    ui_garage        = 'GARAGEM',
    ui_impound       = 'APREENSÃO',
    ui_search        = 'Procurar por nome ou matrícula…',
    ui_cash          = 'Dinheiro',
    ui_bank          = 'Banco',
    ui_all           = 'Todos',
    ui_empty         = 'Não tens veículos nesta garagem.',
    ui_empty_impound = 'Sem veículos apreendidos.',
    ui_sort_name     = 'Nome (A-Z)',
    ui_sort_status   = 'Estado',
    ui_confirm       = 'Confirmar',
    ui_cancel        = 'Cancelar',
    ui_fee           = 'Taxa',

    -- ─────────────────────────────────────────────────────────────
    -- UI — cartão do veículo
    -- ─────────────────────────────────────────────────────────────
    ui_nickname       = 'Alcunha',
    ui_nickname_set   = 'Definir alcunha',
    ui_nickname_ph    = 'Alcunha do veículo',
    ui_fuel           = 'Combustível',
    ui_engine         = 'Motor',
    ui_body           = 'Chassis',
    ui_status_stored  = 'Na garagem',
    ui_status_out     = 'Fora da garagem',
    ui_status_impound = 'Apreendido',
    ui_financed       = 'A ser pago',

    -- ─────────────────────────────────────────────────────────────
    -- UI — ações do veículo
    -- ─────────────────────────────────────────────────────────────
    ui_drive         = 'Retirar',
    ui_return_drive  = 'Recuperar e retirar',
    ui_transfer      = 'Transferir',
    ui_release       = 'Devolver ao dono',
    ui_recover       = 'Recuperar',
    ui_sell          = 'Vender',
    ui_sell_title    = 'Vender veículo',
    ui_sell_confirm  = 'Vais vender %s por %s. Esta ação é irreversível.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — fluxo de transferência
    -- ─────────────────────────────────────────────────────────────
    ui_transfer_title       = 'Transferir veículo',
    ui_transfer_garage      = 'Para outra garagem',
    ui_transfer_player      = 'Para outro jogador',
    ui_transfer_pick_garage = 'Escolhe a garagem de destino',
    ui_transfer_pick_player = 'Jogadores por perto',
    ui_transfer_no_players  = 'Ninguém por perto.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — fluxo de apreensão (lado polícia / admin)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_title       = 'Apreender veículo',
    ui_impound_reason      = 'Motivo',
    ui_impound_reason_ph   = 'Motivo da apreensão…',
    ui_impound_retrievable = 'Recuperável pelo dono',
    ui_impound_time        = 'Tempo até recuperação',
    ui_impound_cost        = 'Custo de recuperação',
    ui_impound_confirm     = 'Apreender',
    ui_hours               = '%sh',
    ui_time_none           = 'Sem prazo',
    ui_reason              = 'Motivo',

    -- ─────────────────────────────────────────────────────────────
    -- UI — aparência (painel de admin: tema global do servidor)
    -- ─────────────────────────────────────────────────────────────
    ui_theme            = 'Aparência',
    ui_theme_colors     = 'Cores',
    ui_theme_brand      = 'Cor principal',
    ui_theme_bg         = 'Cor de fundo',
    ui_theme_derive     = 'Todas as superfícies, contornos e sombras são derivadas destas duas cores. Ao guardar, a nova aparência é aplicada instantaneamente a TODOS os jogadores.',
    ui_theme_presets    = 'Predefinições',
    ui_theme_preview    = 'Pré-visualização',
    ui_theme_apply      = 'Aplicar a todos',
    ui_theme_reset_def  = 'Repor predefinição',

    -- conteúdo fictício do cartão de pré-visualização (nunca aparece fora do painel de aparência)
    ui_theme_demo_title      = 'As minhas viaturas',
    ui_theme_demo_stored     = 'Na garagem',
    ui_theme_demo_finance    = 'A ser pago',
    ui_theme_demo_kpi_stored = 'Guardadas',
    ui_theme_demo_kpi_out    = 'Cá fora',
    ui_theme_demo_take       = 'Retirar',
    ui_theme_demo_transfer   = 'Transferir',
    ui_theme_demo_search     = 'Procurar viatura',

    -- ─────────────────────────────────────────────────────────────
    -- Notificações (n_) — avisos para o jogador
    -- ─────────────────────────────────────────────────────────────
    n_no_access      = 'Não tens acesso a esta garagem.',
    n_no_vehicle     = 'Não estás num veículo.',
    n_not_driver     = 'Tens de ser o condutor.',
    -- Config.occupantGuard: a ação ia apagar o veículo com pessoas lá dentro
    n_occupied         = 'Tira os passageiros do veículo antes de o guardares.',
    n_occupied_impound = 'Tira toda a gente do veículo antes de o apreenderes.',
    n_impound_on_foot = 'Sai do veículo para usares o depósito.',
    n_wrong_class    = 'Este veículo não pertence a esta garagem.',
    n_stored         = 'Veículo guardado.',
    n_taken_out      = 'Veículo retirado.',
    n_blocked        = 'Não há espaço para retirar o veículo aqui.',
    n_paid_fee       = 'Taxa paga: %s.',
    n_nickname_ok    = 'Alcunha atualizada.',
    n_transferred    = 'Veículo transferido.',
    n_sold           = 'Veículo vendido por $%s.',
    n_impounded      = 'Veículo apreendido.',
    n_released       = 'Veículo devolvido à garagem do dono.',
    n_recovered      = 'Veículo recuperado da apreensão.',
    n_no_target      = 'Nenhum veículo por perto.',

    -- ─────────────────────────────────────────────────────────────
    -- Notificações — comandos de admin e garagens privadas
    -- ─────────────────────────────────────────────────────────────
    n_npc_removed    = 'Veículo sem dono removido.',
    n_priv_created   = 'Garagem privada criada.',
    n_priv_deleted   = 'Garagem privada removida.',
    n_priv_noperm    = 'Não podes criar garagens privadas.',
    n_priv_name      = 'Esse nome já existe.',
    n_plate_changed  = 'Matrícula alterada.',
    n_veh_returned   = 'Veículo devolvido à garagem.',
    n_veh_deleted    = 'Veículo removido da base de dados.',

    -- ─────────────────────────────────────────────────────────────
    -- Erros (e_) — devolvidos pelo servidor, procurados dinamicamente
    -- ─────────────────────────────────────────────────────────────
    e_nil         = 'Ocorreu um erro.',
    e_invalid     = 'Inválido.',
    e_no_access   = 'Sem acesso.',
    e_not_owner   = 'Não és o dono.',
    e_wrong_class = 'Este veículo não pertence a esta garagem.',
    e_no_money    = 'Dinheiro insuficiente.',
    e_unavailable = 'Indisponível.',
    -- o servidor recusou a retirada porque todos os pontos de spawn estão ocupados
    e_blocked     = 'Não há espaço para retirar o veículo aqui.',
    e_busy        = 'Já tens uma ação em curso.',
    e_no_target   = 'Nenhum veículo por perto.',
    e_already_out = 'Esse veículo já está lá fora.',
    -- aparece também no botão de recuperar, por isso convém ser curto
    e_occupied    = 'Está alguém dentro desse veículo.',
    e_name        = 'Esse nome já está a ser usado.',
    e_stock_all_out    = 'Estão todos lá fora.',
    e_fleet_admin_only = 'Só um admin pode alterar os veículos desta garagem.',
    e_no_vehicle       = 'Não estás num veículo.',
    e_stock_boss_only  = 'Só um patrão nomeado ou um admin pode alterar a capacidade da frota.',

    -- erros — venda
    e_sell_off      = 'A venda instantânea não está disponível.',
    e_sell_financed = 'Não podes vender um veículo financiado.',
    e_sell_out      = 'O veículo está lá fora.',
    e_sell_parked   = 'O veículo está estacionado.',
    e_sell_impound  = 'O veículo está apreendido.',
    e_sell_noprice  = 'Este veículo não tem preço de mercado.',
    e_sell_payfail  = 'A venda falhou no pagamento. Contacta um administrador.',

    -- ─────────────────────────────────────────────────────────────
    -- Erros — estacionamento persistente
    -- ─────────────────────────────────────────────────────────────
    e_park_off         = 'O estacionamento persistente está desativado.',
    e_park_noperm      = 'Não tens permissão para estacionar aqui.',
    e_park_notowned    = 'Este veículo não é teu.',
    e_park_max         = 'Já atingiste o limite de veículos estacionados.',
    e_park_occupied    = 'Já está um veículo estacionado neste sítio.',
    e_park_none        = 'Não há nenhum veículo estacionado com essa matrícula.',
    e_park_notowner    = 'Só o dono pode retirar este veículo.',
    e_park_busy        = 'O sistema de estacionamento ainda está a arrancar.',
    e_park_already     = 'Este veículo já está estacionado.',
    e_park_parked      = 'Este veículo está estacionado na rua — vai buscá-lo lá.',
    e_park_notdriving  = 'Tens de estar dentro do veículo que queres estacionar.',
    e_park_moving      = 'Imobiliza o veículo por completo antes de o estacionares.',
    e_park_blacklisted = 'Não é permitido estacionar nesta zona.',
    e_park_in_garage   = 'Não podes estacionar dentro de uma garagem.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — rótulos genéricos (botões, chips e títulos reutilizados)
    -- ─────────────────────────────────────────────────────────────
    ui_save          = 'Guardar',
    ui_close         = 'Fechar',
    ui_collapse      = 'Recolher',
    ui_remove        = 'Remover',
    ui_edit          = 'Editar',
    ui_teleport      = 'Teleportar',
    ui_name          = 'Nome',
    ui_set           = 'Definir',
    ui_class         = 'Classe',
    ui_add           = 'Adicionar',
    ui_create        = 'Criar',
    ui_delete        = 'Eliminar',
    ui_clear         = 'Limpar',
    ui_place         = 'Colocar',
    ui_none          = 'Nenhum',
    ui_optional      = 'opcional',
    ui_yes           = 'Sim',
    ui_no            = 'Não',
    ui_vehicle       = 'Veículo',
    ui_min_grade     = 'Grade mínimo',
    ui_add_vehicle   = 'Adicionar veículo',

    -- chips de estado do editor. O inglês tem uma só palavra ('Set') para a
    -- zona (feminina) e para o ponto de arrumação (masculino); em pt-PT fica
    -- o masculino, que é o genérico.
    ui_state_set     = 'Definido',
    ui_state_unset   = 'Por definir',
    ui_shape_corners = 'Cantos',
    ui_shape_circle  = 'Círculo',

    -- contagem de veículos — par singular/plural, %s é o número
    ui_count_one     = '%s veículo',
    ui_count_many    = '%s veículos',
    ui_grade         = 'grade %s',

    -- sobrescrito do cartão de veículo (maiúsculas por design)
    ui_brand_air     = 'AR',
    ui_brand_sea     = 'MAR',
    ui_brand_car     = 'VEÍCULO',

    -- título da secção de apreensão no painel de detalhe (≠ ui_impound, que é
    -- a marca em maiúsculas, e ≠ ui_impound_title, que é o título do modal)
    ui_impound_section = 'Apreensão',

    -- barra de pré-visualização 3D (tooltips)
    ui_pv_rotate_left  = 'Rodar para a esquerda',
    ui_pv_autorotate   = 'Rotação automática',
    ui_pv_rotate_right = 'Rodar para a direita',
    ui_pv_zoom_out     = 'Afastar',
    ui_pv_zoom_in      = 'Aproximar',
    ui_pv_reset        = 'Repor câmara',

    -- ─────────────────────────────────────────────────────────────
    -- Painel de admin (adm_) — lista de garagens, patrão e privadas
    -- ─────────────────────────────────────────────────────────────
    adm_count_one   = '%s garagem',
    adm_count_many  = '%s garagens',
    adm_garages     = 'Garagens',
    adm_new_garage  = 'Nova garagem',
    adm_edit_garage = 'Editar garagem',
    adm_empty       = 'Sem garagens',
    adm_empty_sub   = 'Cria a primeira com "Nova garagem".',
    adm_row_vehicles = '%s veíc.',
    adm_tp_garage   = 'Teleportar para a garagem',
    adm_src_config      = 'Definida em shared/config.lua',
    adm_src_created     = 'Criada no jogo',
    adm_src_config_chip = 'config.lua',
    adm_src_config_hint = 'Edita-a em shared/config.lua e reinicia o resource',

    -- tipos de garagem (filtro e seletor do editor partilham a mesma chave)
    adm_type_public  = 'Pública',
    adm_type_job     = 'Emprego',
    adm_type_private = 'Privada',
    adm_type_impound = 'Apreensão',

    adm_pick_player    = 'Escolher jogador',
    adm_nobody_online  = 'Ninguém online.',

    -- painel do patrão
    adm_company          = 'EMPRESA',
    adm_management       = 'GESTÃO',
    adm_admin            = 'ADMIN',
    adm_company_garage   = 'GARAGEM DA EMPRESA',
    adm_company_fallback = 'Empresa',
    adm_boss_stock       = 'Por stock',
    adm_boss_infinite    = 'Tirada infinita',
    adm_boss_empty       = 'Sem veículos',
    adm_boss_empty_sub   = 'Adiciona os que a empresa pode tirar.',
    adm_boss_empty_adm   = 'Um admin define esta frota em /apexgarage.',

    -- garagens privadas
    adm_priv_title          = 'Garagens privadas',
    adm_priv_empty          = 'Ainda não tens garagens privadas.',
    adm_priv_create_here    = 'Criar garagem privada aqui',
    adm_priv_delete_confirm = 'Remover esta garagem privada?',
    adm_priv_create_title   = 'Criar garagem privada',
    adm_class_car_fallback  = 'Carro',

    -- ─────────────────────────────────────────────────────────────
    -- Editor de garagens (ed_)
    -- ─────────────────────────────────────────────────────────────
    ed_identification    = 'Identificação',
    ed_name_ph           = 'Nome da garagem',
    ed_type              = 'Tipo',
    ed_class_land        = 'Terra',
    ed_class_air         = 'Ar',
    ed_class_sea         = 'Mar',
    ed_officer_job       = 'Job dos agentes',
    ed_veh_mode          = 'Modo de veículos',
    ed_veh_mode_personal = 'Pessoais',
    ed_veh_mode_company  = 'Empresa',
    ed_veh_mode_list     = 'Lista',
    ed_stock_mode        = 'Modo de stock',
    ed_stock_infinite    = 'Infinito',
    ed_stock_by_stock    = 'Por stock',
    ed_boss_grade        = 'Grade do patrão',
    ed_owners            = 'Donos',
    ed_owner_add         = 'Adicionar dono',
    ed_owners_existing   = '%s dono(s) atuais (preservados; adiciona para substituir).',
    ed_owners_none       = 'Nenhum dono — a garagem ficará inacessível até adicionares um.',

    -- colocação no mundo
    ed_placement    = 'Colocação no mundo',
    ed_zone         = 'Zona da garagem',
    ed_zone_poly    = 'Polígono · %s cantos',
    ed_zone_circle  = 'Círculo · raio %s m',
    ed_zone_unset   = 'Ainda não definida',
    ed_tp_zone      = 'Teleportar para a zona',
    ed_spawns       = 'Pontos de spawn',
    ed_spawns_sub   = 'Onde o veículo aparece ao ser retirado',
    ed_store_point  = 'Ponto de arrumação',
    ed_store_set    = 'Ponto próprio definido',
    ed_store_unset  = 'Opcional — se vazio usa-se a zona',
    ed_list_vehicles = 'Veículos da lista',
    ed_no_vehicles  = 'Sem veículos. Adiciona os que este job pode tirar.',
    ed_spawn_code   = 'Código do veículo',
    ed_stock        = 'Stock',
    ed_stock_start  = 'Stock inicial',
    ed_veh_edit     = 'Editar veículo',
    ed_veh_fleet_hint = 'Só um admin pode alterar os veículos desta garagem. O patrão ajusta a quantidade.',

    -- ─────────────────────────────────────────────────────────────
    -- Painel de estacionamento persistente (pk_)
    -- ─────────────────────────────────────────────────────────────
    pk_title    = 'Estacionamento',
    pk_settings = 'Definições',

    -- separadores do topo (strip estreito — manter curtos)
    pk_tab_parking   = 'Estacionados',
    pk_tab_noparking = 'Zonas',
    pk_tab_settings  = 'Definições',

    -- o nome do comando é configurável (Config.commands.park) e o call site da
    -- NUI é t('chave') sem argumentos — nunca nomear o comando nestes textos
    pk_enabled       = 'Estacionamento ativo',
    pk_enabled_desc  = 'Permite aos jogadores estacionar em qualquer sítio do servidor.',
    pk_nocol         = 'Sem colisão',
    pk_nocol_desc    = 'Os outros veículos atravessam os carros estacionados.',
    pk_jobveh        = 'Veículos de empresa',
    pk_jobveh_desc   = 'Deixa estacionar carros de job/empresa.',
    pk_nogarage      = 'Proibir dentro de garagens',
    pk_nogarage_desc = 'Impede estacionar dentro da zona de qualquer garagem.',
    pk_who           = 'Quem pode estacionar',
    pk_who_desc      = 'Define quem tem acesso ao comando.',
    pk_mode_public     = 'Todos',
    pk_mode_job        = 'Por job',
    pk_mode_permission = 'Por permissão',
    pk_jobs          = 'Jobs permitidos',
    pk_jobs_desc     = 'Separados por vírgula.',
    pk_max           = 'Máximo por jogador',
    pk_max_desc      = 'Quantos carros cada um pode deixar estacionados.',
    pk_unit_count    = 'un',
    pk_radius        = 'Raio anti-sobreposição',
    pk_radius_desc   = 'Distância mínima a outro carro já estacionado.',

    pk_perms           = 'Permissões',
    pk_grant           = 'Conceder',
    pk_grant_title     = 'Conceder permissão',
    pk_perms_empty     = 'Sem permissões',
    pk_perms_empty_sub = 'Concede acesso a um jogador online.',
    pk_revoke          = 'Revogar',
    pk_offline         = 'Offline',

    pk_zones           = 'Zonas proibidas',
    pk_zones_empty     = 'Sem zonas proibidas',
    pk_zones_empty_sub = 'Desenha uma área onde ninguém pode estacionar.',
    pk_zone            = 'Zona',
    pk_zone_corners    = '%s cantos',
    pk_zone_radius     = 'raio %s m',

    pk_parked           = 'Veículos estacionados',
    pk_parked_empty     = 'Nada estacionado',
    pk_parked_empty_sub = 'Ninguém deixou veículos no mundo.',
    pk_save_note        = 'As alterações só se aplicam depois de guardar.',

    -- ─────────────────────────────────────────────────────────────
    -- Prompts do colocador no mundo (prompt_)
    -- ─────────────────────────────────────────────────────────────
    prompt_key_radius      = 'Raio',
    prompt_key_place       = 'Colocar',
    prompt_key_cancel      = 'Cancelar',
    prompt_key_rotate      = 'Rodar',
    prompt_key_add_corner  = 'Adicionar canto',
    prompt_key_finish      = 'Concluir',
    prompt_key_remove_last = 'Remover último',
    prompt_key_place_spawn = 'Colocar spawn',

    prompt_title_zone    = 'Definir zona',
    prompt_title_corners = 'Cantos da zona',
    prompt_title_spawn   = 'Definir ponto de spawn',
    prompt_title_spawns  = 'Pontos de spawn',
    prompt_spawns_count  = '%s — %s colocados',

    prompt_place_zone_poly   = 'Cantos da zona — marca 3 ou mais',
    prompt_place_zone_circle = 'Zona da garagem — scroll ajusta o raio',
    prompt_place_store       = 'Ponto de arrumação',
    prompt_back_panel        = 'Voltar ao painel',
    prompt_pk_zone_circle    = 'Zona proibida — scroll ajusta o raio',
    prompt_pk_zone_poly      = 'Zona proibida — marca 3 ou mais cantos',

    -- ─────────────────────────────────────────────────────────────
    -- Notificações — painel de admin e estacionamento
    -- ─────────────────────────────────────────────────────────────
    n_garage_created      = 'Garagem criada.',
    n_garage_updated      = 'Garagem atualizada.',
    n_garage_deleted      = 'Garagem eliminada.',
    n_theme_saved         = 'Aparência guardada para todo o servidor.',
    n_theme_reset         = 'Aparência reposta.',
    n_veh_added           = 'Veículo adicionado.',
    n_parked              = 'Veículo estacionado.',
    n_unparked            = 'Veículo desestacionado — voltou à garagem.',
    n_park_exiting        = 'A estacionar — a sair do veículo…',
    n_park_exit_failed    = 'Não saíste do veículo como devias, mas ficou estacionado.',
    n_park_released       = 'Veículo libertado. Já podes conduzi-lo.',
    n_park_settings_saved = 'Definições de estacionamento guardadas.',
    n_park_veh_removed    = 'Veículo estacionado removido.',
    n_park_zone_created   = 'Zona proibida criada.',
    n_park_zone_removed   = 'Zona removida.',

    -- ─────────────────────────────────────────────────────────────
    -- Erros — painel de admin e estacionamento
    -- e_noperm corresponde ao código 'noperm' do servidor; não confundir
    -- com e_no_access ('no_access'), que é uma falha diferente.
    -- ─────────────────────────────────────────────────────────────
    e_noperm          = 'Sem permissão.',
    e_theme_invalid   = 'Cores inválidas.',
    e_zone_create     = 'Erro ao criar a zona.',
    e_no_zone         = 'Essa garagem ainda não tem zona definida.',
    e_need_placement  = 'Define a zona e pelo menos um ponto de spawn.',
    e_config_readonly = 'Essa garagem está definida em shared/config.lua — edita-a lá e reinicia o resource.',
    diag_nearest      = 'Garagem mais próxima: %s (%s), a %s m — ponto de acesso %s',
    diag_none         = 'Este cliente ainda não carregou nenhuma garagem.',
    e_no_boss_garage  = 'Não geres nenhuma garagem de empresa.',
    e_park_none_near  = 'Não estás perto de nenhum veículo teu estacionado.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — apreensão (lotes, estado e ações) — rótulos curtos
    -- ui_impound_wait  %s (tempo restante)
    -- ui_dur_h/%s (horas), ui_dur_m/%s (minutos), ui_dur_hm/%h e %m (literais)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_lot             = 'Depósito',
    ui_impound_lot_nearest     = 'Mais próximo',
    ui_impound_owner           = 'Dono',
    ui_impound_roster          = 'Veículos retidos',
    ui_impound_locked_hint     = 'Só um agente pode libertar este veículo.',
    ui_impound_retrievable_desc = 'O dono pode recomprar o veículo quando o prazo terminar.',
    ui_impound_held_at         = 'Retido em',
    ui_impound_officer         = 'Apreendido por',
    ui_impound_no_reason       = 'Sem motivo indicado',
    ui_impound_release         = 'Libertar',
    ui_impound_release_owner   = 'O dono pode levantar',
    ui_impound_release_police  = 'Só a polícia liberta',
    ui_impound_available       = 'Disponível em',
    ui_impound_available_now   = 'Já disponível',
    ui_impound_free            = 'Grátis',
    ui_impound_wait            = 'Disponível em %s',
    ui_at_impound              = 'Retido no depósito',
    ui_owner                   = 'Dono',
    ui_unknown_owner           = 'Dono desconhecido',
    ui_time_now                = 'Disponível já',
    ui_time_immediate          = 'Disponível já',
    ui_dur_h                   = '%sh',
    ui_dur_m                   = '%smin',
    ui_dur_hm                  = '%hh %mmin',

    -- ─────────────────────────────────────────────────────────────
    -- Notificações e erros — apreensão
    -- n_impound_released  %s (veículo), %s (garagem)
    -- n_impounded_reason  %s (agente), %s (motivo)
    -- ─────────────────────────────────────────────────────────────
    n_impound_locked     = 'Este veículo só pode ser libertado por um agente.',
    e_impound_locked     = 'Só um agente liberta.',
    n_impound_not_ready  = 'Este veículo ainda não pode ser levantado.',
    e_impound_not_ready  = 'Ainda não está disponível.',
    n_too_far            = 'Estás demasiado longe do depósito de apreensões.',
    e_too_far            = 'Demasiado longe.',
    e_no_lot             = 'Nenhum depósito aceita este veículo.',
    n_impound_released   = 'O teu veículo %s foi libertado da apreensão e está à espera em %s.',
    n_impounded_reason   = 'Apreendido por %s — %s',
    n_impound_no_reason  = 'Sem motivo indicado',
    e_impounded          = 'Apreendido.',
    n_impound_empty      = 'Não tens veículos neste depósito.',

    -- ─────────────────────────────────────────────────────────────
    -- SEM USO — já não são referenciadas por código Lua ou NUI.
    -- Mantidas por compatibilidade.
    -- ─────────────────────────────────────────────────────────────
    ui_leave            = 'Sair',
    ui_sort_recent      = 'Recentes',
    ui_plate            = 'Matrícula',
    ui_theme_brand_desc = 'Botões, marcadores e destaques em todo o servidor.',
    ui_theme_bg_desc    = 'Tom base da interface; as restantes superfícies são derivadas daqui.',
    ui_theme_reset      = 'Repor',
    ui_theme_save       = 'Guardar',
    ui_theme_hint       = 'As cores aplicam-se a todos os jogadores assim que guardares.',
    ui_theme_unsaved    = 'Pré-visualização — ainda não está guardada.',
    n_not_owner         = 'Este veículo não é teu.',
    n_unavailable       = 'Veículo indisponível de momento.',
    n_already_out       = 'Esse veículo já está lá fora.',
    n_no_money          = 'Dinheiro insuficiente.',
    n_invalid           = 'Ação inválida.',
}
