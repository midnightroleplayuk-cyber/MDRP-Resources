Locales = Locales or {}

-- Español. Mantén las claves sincronizadas con en.lua.
Locales['es'] = {
    -- ── Marca ──
    brand_name        = 'APEX',
    brand_accent      = 'GANGS',
    brand_sub         = 'Mando de Banda',

    -- ── Genérico ──
    ui_open           = 'Abrir',
    ui_close          = 'Cerrar',
    ui_save           = 'Guardar',
    ui_cancel         = 'Cancelar',
    ui_confirm        = 'Confirmar',
    ui_delete         = 'Eliminar',
    ui_edit           = 'Editar',
    ui_create         = 'Crear',
    ui_refresh        = 'Actualizar',
    ui_search         = 'Buscar…',
    ui_none           = 'Ninguno',
    ui_loading        = 'Cargando…',

    -- ── Pestañas ──
    tab_overview      = 'Resumen',
    tab_members       = 'Miembros',
    tab_ranks         = 'Rangos',
    tab_turf          = 'Territorio',
    tab_graffiti      = 'Grafiti',
    tab_vault         = 'Caja Fuerte',
    tab_garage        = 'Garaje',
    tab_operations    = 'Operaciones',
    tab_tasks         = 'Tareas',
    tab_upgrades      = 'Mejoras',
    tab_medic         = 'Médico',
    tab_logs          = 'Registros',
    tab_settings      = 'Ajustes',
    tab_admin         = 'Admin',

    -- ── Notificaciones ──
    notify_no_gang        = 'No perteneces a ninguna banda.',
    notify_not_authorized = 'No estás autorizado.',
    notify_menu_failed    = 'No se pudo abrir el menú (%s) — no es un problema de permisos. Revisa la consola del servidor.',
    notify_perm_report    = 'Informe de permisos escrito en tu consola F8.',
    notify_perm_report_offline = 'No hay ningún jugador conectado con ese id.',
    notify_no_permission  = 'No tienes permiso para eso.',
    notify_not_leader     = 'Solo los líderes de la banda pueden hacer eso.',
    notify_gang_created   = 'Banda "%s" creada.',
    notify_gang_deleted   = 'Banda eliminada.',
    notify_gang_full      = 'La banda está llena.',
    notify_member_joined  = 'Te uniste a %s.',
    notify_member_kicked  = 'Fuiste expulsado de %s.',
    notify_member_invited = '%s invitado.',
    notify_promoted       = '%s ascendido.',
    notify_demoted        = '%s degradado.',
    notify_lead_transfer  = 'Liderazgo transferido a %s.',
    notify_cooldown       = 'En espera — inténtalo de nuevo más tarde.',
    notify_saved          = 'Guardado.',
    notify_deleted        = 'Eliminado.',

    -- ── Territorio ──
    turf_entering         = 'Entrando en el territorio de %s',
    turf_leaving          = 'Saliendo del territorio de %s',
    turf_neutral          = 'Territorio neutral',
    turf_capturing        = 'Capturando… %d%%',
    turf_contested        = '¡Territorio en disputa!',
    turf_captured         = '%s capturó %s',
    turf_lost             = 'Tu banda perdió %s',
    turf_tagging          = 'Marcando este territorio… %d/%d firmas',

    -- ── Grafiti ──
    graffiti_placed       = 'Firma colocada.',
    graffiti_removed      = 'Firma eliminada.',
    graffiti_limit        = 'Límite de grafiti alcanzado.',
    graffiti_no_wall      = 'Apunta a una pared plana.',
    graffiti_aim          = 'Apunta dónde pintar · [E] confirmar · [Esc] cancelar',
    graffiti_rotate       = 'Rotar',
    graffiti_resize       = 'Redimensionar',
    graffiti_place        = 'Colocar',
    graffiti_cancel       = 'Cancelar',
    graffiti_spraying     = 'Pintando grafiti…',
    graffiti_spraying_sub = 'Quédate quieto mientras marcas la pared',
    graffiti_shaking      = 'Agitando el bote…',
    graffiti_shaking_sub  = 'Mezclando la pintura',
    graffiti_size         = 'Tamaño',
    graffiti_rotation     = 'Rotación',
    graffiti_draw         = 'Dibujar',

    -- ── Caja fuerte ──
    vault_deposited       = 'Depositaste %s.',
    vault_withdrawn       = 'Retiraste %s.',
    vault_insufficient    = 'Fondos insuficientes.',

    -- ── Garaje ──
    garage_stored         = 'Vehículo guardado.',
    garage_out            = 'Vehículo retirado.',
    garage_limit          = 'El garaje está lleno.',
    garage_not_here       = 'No hay ningún punto de garaje cerca.',
    garage_not_yours      = 'Ese no es tu vehículo — solo tus propios coches pueden entrar al garaje de la banda.',
    garage_not_gang       = 'Ese vehículo pertenece a otra banda.',

    -- ── Operaciones ──
    scout_started         = 'Reconocimiento en curso…',
    scout_done            = 'Reconocimiento completado — información recopilada.',
    scout_failed          = 'Reconocimiento fallido.',
    scout_alerted         = '¡Un rival te está vigilando!',
    scout_left_zone       = 'Reconocimiento cancelado — saliste del territorio.',
    scout_cancelled       = 'Reconocimiento cancelado.',
    scout_busy            = 'Ya hay un reconocimiento en curso.',
    scout_prompt          = 'Reconocer %s',
    raid_started          = '¡Asalto iniciado!',
    raid_incoming         = '¡Tu banda está siendo asaltada!',
    raid_success          = 'Asalto exitoso.',
    raid_failed           = 'Asalto fallido.',
    raid_need_scout       = 'Reconoce primero el objetivo.',
    raid_need_attackers   = 'No hay suficientes atacantes.',

    -- ── Tareas ──
    task_complete         = 'Tarea completada: %s',
    task_progress         = '%s · %d/%d',
    hq_nothing            = 'Nada que explorar aquí por ahora — consigue primero el contrato "Vigilar el cuartel".',
    mission_started       = 'Misión: %s — sigue el marcador.',
    mission_done          = 'Misión completada — pago enviado a la banda.',
    mission_failed        = 'Misión fallida.',
    mission_busy          = 'Ya tienes una misión en curso.',
    mission_deliver       = 'Entrégalo en el punto de entrega.',
    mission_cancelled     = 'Misión cancelada.',
    mission_none          = 'No tienes ninguna misión en curso.',
    mission_cancel_hint   = 'Cancela en cualquier momento con /cancelmission (o F6 → Cancelar Misión).',
    mstep_travel          = 'Viaja a la ubicación',
    mstep_eliminate       = 'Elimina al objetivo',
    mstep_meet            = 'Reúnete con el comprador para recoger',
    mstep_grab            = 'Coge el paquete',
    mstep_grab_person     = 'Carga al objetivo (F6 → Cargar / [E])',
    mstep_grab_body       = 'Carga el cuerpo (F6 → Cargar / [E])',
    mstep_deliver         = 'Deja al objetivo con los compradores (F6 → Soltar / [E])',
    mstep_dispose         = 'Deja el cuerpo aquí (F6 → Soltar / [E])',
    mstep_clear           = 'Elimina a los guardias del cártel',
    mstep_grab_loot       = 'Coge el cargamento',
    mstep_sell            = 'Vende a los compradores',

    -- ── Reputación ──
    rep_label             = 'Reputación',
    need_rep              = 'Tu banda necesita más reputación para asaltar.',

    -- ── Niveles / mejoras ──
    level_up              = '¡Tu banda alcanzó el nivel %d!',
    upgrade_bought        = 'Mejora comprada: %s',
    upgrade_maxed         = 'La mejora ya está al máximo.',
    upgrade_level_locked  = 'Requiere banda de nivel %d.',

    -- ── Médico ──
    medic_healed          = 'Fuiste curado.',
    medic_revived         = 'Fuiste reanimado.',
    medic_locked          = 'El médico de la banda no está desbloqueado.',

    -- ── Creador / editor ──
    creator_title         = 'Zonas de Banda',
    creator_aim           = 'Apunta dónde debe ir el punto · [E] confirmar · [Esc] cancelar',
    creator_saved         = 'Zona "%s" guardada.',
    creator_deleted       = 'Zona eliminada.',

    -- ── Modo de prueba ──
    test_enabled          = 'Modo de prueba ACTIVADO — invasiones en solitario + defensores NPC.',
    test_disabled         = 'Modo de prueba DESACTIVADO.',
    test_defenders        = '¡%d defensores en camino!',
    test_zone_cleared     = 'Zona despejada — manténla para capturarla.',
    test_rival_created    = 'Banda rival de prueba lista: %s',
    test_zone_created     = 'Zona de territorio rival creada aquí (dueño: %s). Entra y pulsa [E] para reconocer.',
    test_zone_nocoords    = 'Aún no hay posición — muévete unos pasos e inténtalo de nuevo.',

    -- ── Lanzamiento aéreo ──
    airdrop_inbound       = 'Un lanzamiento aéreo está llegando — ¡encuentra la caja!',
    airdrop_dispatched    = 'Lanzamiento aéreo enviado.',
    airdrop_no_zones      = 'No hay zonas de lanzamiento aéreo activadas.',
    airdrop_locked        = 'La caja sigue sellada — espera a que se active.',
    airdrop_open          = 'Abrir Lanzamiento',
    airdrop_looted        = '¡Lanzamiento aéreo saqueado!',

    -- ── Aviso en el mundo ──
    prompt_open_menu      = 'Abrir Menú de Banda',
    target_open           = 'Abrir Menú de Banda',
}
