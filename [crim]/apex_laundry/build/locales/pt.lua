--[[ Apex Laundry — Português ]]
Locales = Locales or {}
Locales.pt = {
    -- Notificações
    n_no_permission   = 'Não tens acesso a esta máquina.',
    n_no_dirty        = 'Não tens dinheiro sujo suficiente.',
    n_no_cleaners     = 'Produtos de limpeza insuficientes na máquina.',
    n_wash_started    = 'Ciclo de lavagem iniciado.',
    n_wash_cancelled  = 'Lavagem cancelada — o teu dinheiro sujo foi devolvido.',
    n_wash_collected  = 'Recolheste %s em dinheiro limpo.',
    n_wash_in_progress= 'Já existe uma lavagem a decorrer nesta máquina.',
    n_no_wash         = 'Não há nenhuma lavagem a decorrer nesta máquina.',
    n_wash_not_done   = 'A lavagem ainda não terminou.',
    n_upgrade_ok      = 'Máquina melhorada.',
    n_upgrade_maxed   = 'Esta melhoria já está no nível máximo.',
    n_upgrade_no_money= 'Não tens dinheiro para esta melhoria.',
    n_cleaners_added  = 'Carregaste %s produtos de limpeza na máquina.',
    n_cleaners_full   = 'Esta máquina não consegue guardar mais produtos de limpeza.',
    n_cleaners_none   = 'Não tens assim tantos produtos de limpeza.',
    n_amount_invalid  = 'Quantia inválida.',
    n_feature_off     = 'Essa funcionalidade está desativada neste servidor.',
    n_over_capacity   = 'Isso excede a capacidade de lavagem desta máquina.',
    n_not_near        = 'Não estás perto de uma máquina de lavandaria.',
    n_inventory_full  = 'O teu inventário está cheio — liberta espaço e tenta de novo.',
    n_creator_placed    = 'Lavandaria colocada.',
    n_creator_removed   = 'Lavandaria removida.',
    n_creator_none      = 'Não há nenhuma lavandaria colocada por perto.',
    n_creator_cancelled = 'Colocação cancelada.',
    n_creator_load_fail = 'Falha ao carregar o prop da lavandaria.',

    -- HUD / textui
    hud_use_machine   = 'Usar a máquina',
    ld_world_label    = 'Usar a máquina',
    ld_loader_status  = 'A ligar ao terminal',
    ld_loader_foot    = 'Encriptado · Rede de lavagem Apex',

    -- Wordmark
    wm_first          = 'APEX',
    wm_second         = 'LAUNDRY',

    -- Cabeçalho
    ui_brand          = 'Lavandaria Apex',
    ui_subtitle       = 'Terminal de lavagem de dinheiro',
    ui_status_idle    = 'Inativa',
    ui_status_washing = 'A lavar',
    ui_status_ready   = 'Pronto a recolher',
    ui_offline        = 'Sem acesso',

    -- Produtos de limpeza
    ui_cleaners       = 'Produtos de limpeza',
    ui_cleaners_sub   = 'Abastece a máquina para correr uma lavagem',
    ui_in_stock       = 'Na máquina',
    ui_deposit        = 'Depositar',
    ui_units          = 'unidades',

    -- Lavagem
    ui_wash           = 'Lavar dinheiro',
    ui_wash_sub       = 'Converte dinheiro sujo em dinheiro limpo',
    ui_amount         = 'Quantia',
    ui_amount_ph      = 'Insere o valor sujo',
    ui_on_hand        = 'Disponível',
    ui_capacity       = 'Capacidade',
    ui_needs          = 'Limpadores necessários',
    ui_you_get        = 'Vais receber',
    ui_start          = 'Iniciar lavagem',
    ui_max            = 'Máx',
    ui_dirty          = 'Dinheiro sujo',
    ui_clean          = 'Dinheiro limpo',

    -- Lavagem ativa
    ui_active         = 'Lavagem em curso',
    ui_remaining      = 'Tempo restante',
    ui_payout         = 'Retorno',
    ui_collect        = 'Recolher',
    ui_cancel         = 'Cancelar',
    ui_complete       = 'Completo',

    -- Melhorias
    ui_upgrades       = 'Melhorias',
    ui_level          = 'Nível',
    ui_max_level      = 'No máximo',
    ui_upgrade        = 'Melhorar',
    ui_next           = 'Próximo',
    up_efficiency       = 'Eficiência',
    up_efficiency_desc  = 'Aumenta a quantia máxima que podes lavar numa única lavagem.',
    up_potency          = 'Potência',
    up_potency_desc     = 'Melhora o hardware para reduzir o tempo de lavagem.',

    -- Rodapé / meta
    ui_tax_rate       = 'Taxa',
    ui_wash_rate      = 'Velocidade base',
    ui_close          = 'Fechar',
    ui_locked_title   = 'Acesso negado',
    ui_locked_text    = 'Esta máquina é restrita. Não estás autorizado a operá-la.',

    -- Modais
    md_deposit_title  = 'Depositar produtos de limpeza',
    md_deposit_text   = 'Quantas unidades queres carregar na máquina?',
    md_deposit_ph     = 'Unidades',
    md_cancel_title   = 'Cancelar a lavagem?',
    md_cancel_text    = 'O teu dinheiro sujo será devolvido, mas os produtos de limpeza já usados perdem-se.',
    md_upgrade_title  = 'Confirmar melhoria',
    md_upgrade_text   = 'Melhorar %s para o nível %s por %s?',
    md_confirm        = 'Confirmar',
    md_dismiss        = 'Cancelar',

    -- Definições (por jogador)
    ui_settings       = 'Definições',
    ui_brand_color    = 'Cor da marca',
    ui_background     = 'Fundo',
    ui_position       = 'Posição',
    ui_pos_left       = 'Esquerda',
    ui_pos_center     = 'Centro',
    ui_pos_right      = 'Direita',
    ui_opacity        = 'Opacidade',
    ui_size           = 'Tamanho',
    ui_size_s         = 'Pequeno',
    ui_size_m         = 'Médio',
    ui_size_l         = 'Grande',
    ui_reset_default  = 'Repor predefinição',

    -- Criador (menu de colocação)
    cr_title          = 'Nova Lavandaria',
    cr_machine        = 'Máquina',
    cr_access         = 'Acesso',
    cr_public         = 'Pública',
    cr_jobs_hint      = 'Adiciona os jobs que podem usar esta máquina (com grade mínimo).',
    cr_invisible      = 'Prop invisível',
    cr_place          = 'Colocar',
    cr_controls       = 'Controlos de colocação',
    cr_rotate         = 'Rodar',
    cr_depth          = 'Empurrar / Puxar',
    cr_height         = 'Altura',
    cr_add_job        = 'Adicionar job…',
    cr_grade          = 'Grade',
}
