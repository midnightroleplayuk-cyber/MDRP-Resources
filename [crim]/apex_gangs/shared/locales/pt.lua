Locales = Locales or {}

-- Português (Portugal). Mantém as chaves sincronizadas com en.lua.
Locales['pt'] = {
    -- ── Marca ──
    brand_name        = 'APEX',
    brand_accent      = 'GANGS',
    brand_sub         = 'Comando de Gangue',

    -- ── Genérico ──
    ui_open           = 'Abrir',
    ui_close          = 'Fechar',
    ui_save           = 'Guardar',
    ui_cancel         = 'Cancelar',
    ui_confirm        = 'Confirmar',
    ui_delete         = 'Eliminar',
    ui_edit           = 'Editar',
    ui_create         = 'Criar',
    ui_refresh        = 'Atualizar',
    ui_search         = 'Procurar…',
    ui_none           = 'Nenhum',
    ui_loading        = 'A carregar…',

    -- ── Separadores ──
    tab_overview      = 'Visão Geral',
    tab_members       = 'Membros',
    tab_ranks         = 'Cargos',
    tab_turf          = 'Território',
    tab_graffiti      = 'Graffiti',
    tab_vault         = 'Cofre',
    tab_garage        = 'Garagem',
    tab_operations    = 'Operações',
    tab_tasks         = 'Tarefas',
    tab_upgrades      = 'Melhorias',
    tab_medic         = 'Médico',
    tab_logs          = 'Registos',
    tab_settings      = 'Definições',
    tab_admin         = 'Admin',

    -- ── Notificações ──
    notify_no_gang        = 'Não pertences a nenhum gangue.',
    notify_not_authorized = 'Não estás autorizado.',
    notify_menu_failed    = 'Não foi possível abrir o menu (%s) — não é um problema de permissões. Vê a consola do servidor.',
    notify_perm_report    = 'Relatório de permissões escrito na tua consola F8.',
    notify_perm_report_offline = 'Não há nenhum jogador online com esse id.',
    notify_no_permission  = 'Não tens permissão para isso.',
    notify_not_leader     = 'Só os líderes do gangue podem fazer isso.',
    notify_gang_created   = 'Gangue "%s" criado.',
    notify_gang_deleted   = 'Gangue eliminado.',
    notify_gang_full      = 'O gangue está cheio.',
    notify_member_joined  = 'Entraste em %s.',
    notify_member_kicked  = 'Foste removido de %s.',
    notify_member_invited = '%s convidado.',
    notify_promoted       = '%s promovido.',
    notify_demoted        = '%s despromovido.',
    notify_lead_transfer  = 'Liderança transferida para %s.',
    notify_cooldown       = 'Em espera — tenta novamente mais tarde.',
    notify_saved          = 'Guardado.',
    notify_deleted        = 'Eliminado.',

    -- ── Território ──
    turf_entering         = 'A entrar no território de %s',
    turf_leaving          = 'A sair do território de %s',
    turf_neutral          = 'Território neutro',
    turf_capturing        = 'A capturar… %d%%',
    turf_contested        = 'Território disputado!',
    turf_captured         = '%s capturou %s',
    turf_lost             = 'O teu gangue perdeu %s',
    turf_tagging          = 'A marcar este território… %d/%d tags',

    -- ── Graffiti ──
    graffiti_placed       = 'Tag colocada.',
    graffiti_removed      = 'Tag removida.',
    graffiti_limit        = 'Limite de graffiti atingido.',
    graffiti_no_wall      = 'Aponta para uma parede plana.',
    graffiti_aim          = 'Aponta onde pintar · [E] confirmar · [Esc] cancelar',
    graffiti_rotate       = 'Rodar',
    graffiti_resize       = 'Tamanho',
    graffiti_place        = 'Colocar',
    graffiti_cancel       = 'Cancelar',
    graffiti_spraying     = 'A pintar graffiti…',
    graffiti_spraying_sub = 'Fica quieto enquanto pintas a parede',
    graffiti_shaking      = 'A chocalhar a lata…',
    graffiti_shaking_sub  = 'A misturar a tinta',
    graffiti_size         = 'Tamanho',
    graffiti_rotation     = 'Rotação',
    graffiti_draw         = 'Desenhar',

    -- ── Cofre ──
    vault_deposited       = 'Depositaste %s.',
    vault_withdrawn       = 'Levantaste %s.',
    vault_insufficient    = 'Fundos insuficientes.',

    -- ── Garagem ──
    garage_stored         = 'Veículo guardado.',
    garage_out            = 'Veículo retirado.',
    garage_limit          = 'A garagem está cheia.',
    garage_not_here       = 'Não há ponto de garagem por perto.',
    garage_not_yours      = 'Esse veículo não é teu — só os teus carros podem ir para a garagem do gangue.',
    garage_not_gang       = 'Esse veículo pertence a outro gangue.',

    -- ── Operações ──
    scout_started         = 'Reconhecimento em curso…',
    scout_done            = 'Reconhecimento concluído — intel recolhida.',
    scout_failed          = 'Reconhecimento falhou.',
    scout_alerted         = 'Um rival está a vigiar-te!',
    scout_left_zone       = 'Reconhecimento cancelado — saíste do território.',
    scout_cancelled       = 'Reconhecimento cancelado.',
    scout_busy            = 'Já tens um reconhecimento em curso.',
    scout_prompt          = 'Vigiar %s',
    raid_started          = 'Ataque iniciado!',
    raid_incoming         = 'O teu gangue está a ser atacado!',
    raid_success          = 'Ataque bem-sucedido.',
    raid_failed           = 'Ataque falhou.',
    raid_need_scout       = 'Faz primeiro o reconhecimento do alvo.',
    raid_need_attackers   = 'Não há atacantes suficientes.',

    -- ── Tarefas ──
    task_complete         = 'Tarefa concluída: %s',
    task_progress         = '%s · %d/%d',
    hq_nothing            = 'Nada para explorar aqui agora — apanha primeiro o contrato "Case the HQ".',
    mission_started       = 'Missão: %s — segue o marcador.',
    mission_done          = 'Missão concluída — recompensa enviada para a gang.',
    mission_failed        = 'Missão falhada.',
    mission_busy          = 'Já tens uma missão a decorrer.',
    mission_deliver       = 'Entrega no ponto de destino.',
    mission_cancelled     = 'Missão cancelada.',
    mission_none          = 'Não tens nenhuma missão a decorrer.',
    mission_cancel_hint   = 'Cancela a qualquer momento com /cancelmission (ou F6 → Cancelar Missão).',
    mstep_travel          = 'Vai até ao local',
    mstep_eliminate       = 'Elimina o alvo',
    mstep_meet            = 'Encontra o comprador para receber',
    mstep_grab            = 'Apanha o pacote',
    mstep_grab_person     = 'Carrega o alvo (F6 → Carregar / [E])',
    mstep_grab_body       = 'Carrega o corpo (F6 → Carregar / [E])',
    mstep_deliver         = 'Larga o alvo nos compradores (F6 → Largar / [E])',
    mstep_dispose         = 'Larga o corpo aqui (F6 → Largar / [E])',
    mstep_clear           = 'Elimina os guardas do cartel',
    mstep_grab_loot       = 'Apanha o carregamento',
    mstep_sell            = 'Vende aos compradores',

    -- ── Reputação ──
    rep_label             = 'Reputação',
    need_rep              = 'A tua gang precisa de mais reputação para atacar.',

    -- ── Níveis / melhorias ──
    level_up              = 'O teu gangue atingiu o nível %d!',
    upgrade_bought        = 'Melhoria comprada: %s',
    upgrade_maxed         = 'Melhoria já no máximo.',
    upgrade_level_locked  = 'Requer gangue de nível %d.',

    -- ── Médico ──
    medic_healed          = 'Foste curado.',
    medic_revived         = 'Foste reanimado.',
    medic_locked          = 'O médico do gangue não está desbloqueado.',

    -- ── Criador / editor ──
    creator_title         = 'Zonas de Gangue',
    creator_aim           = 'Aponta onde o ponto deve ficar · [E] confirmar · [Esc] cancelar',
    creator_saved         = 'Zona "%s" guardada.',
    creator_deleted       = 'Zona eliminada.',

    -- ── Modo de teste ──
    test_enabled          = 'Modo de teste LIGADO — invasões a solo + NPCs defensores.',
    test_disabled         = 'Modo de teste DESLIGADO.',
    test_defenders        = '%d defensores a chegar!',
    test_zone_cleared     = 'Área limpa — fica na zona para capturar.',
    test_rival_created    = 'Gangue rival de teste pronto: %s',
    test_zone_created     = 'Zona de turf rival criada aqui (dono: %s). Entra e carrega em [E] para vigiar.',
    test_zone_nocoords    = 'Ainda sem posição — anda uns passos e tenta de novo.',

    -- ── Airdrop ──
    airdrop_inbound       = 'Um airdrop está a chegar — encontra a caixa!',
    airdrop_dispatched    = 'Airdrop enviado.',
    airdrop_no_zones      = 'Não há zonas de airdrop ativas.',
    airdrop_locked        = 'A caixa ainda está selada — espera que arme.',
    airdrop_open          = 'Abrir Airdrop',
    airdrop_looted        = 'Airdrop saqueado!',

    -- ── Aviso no mundo ──
    prompt_open_menu      = 'Abrir Menu do Gangue',
    target_open           = 'Abrir Menu do Gangue',
}
