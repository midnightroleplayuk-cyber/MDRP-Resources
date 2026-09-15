--[[ Apex Laundry — Español ]]
Locales = Locales or {}
Locales.es = {
    -- Notificaciones
    n_no_permission   = 'No tienes acceso a esta máquina.',
    n_no_dirty        = 'No tienes suficiente dinero sucio.',
    n_no_cleaners     = 'No hay suficientes productos de limpieza en la máquina.',
    n_wash_started    = 'Ciclo de lavado iniciado.',
    n_wash_cancelled  = 'Lavado cancelado — se te ha devuelto el dinero sucio.',
    n_wash_collected  = 'Has recogido %s en dinero limpio.',
    n_wash_in_progress= 'Ya hay un lavado en curso en esta máquina.',
    n_no_wash         = 'No hay ningún lavado en curso en esta máquina.',
    n_wash_not_done   = 'El lavado aún no ha terminado.',
    n_upgrade_ok      = 'Máquina mejorada.',
    n_upgrade_maxed   = 'Esta mejora ya está al nivel máximo.',
    n_upgrade_no_money= 'No puedes permitirte esta mejora.',
    n_cleaners_added  = 'Has cargado %s productos de limpieza en la máquina.',
    n_cleaners_full   = 'Esta máquina no puede guardar más productos de limpieza.',
    n_cleaners_none   = 'No tienes tantos productos de limpieza.',
    n_amount_invalid  = 'Cantidad no válida.',
    n_feature_off     = 'Esa función está desactivada en este servidor.',
    n_over_capacity   = 'Eso supera la capacidad de lavado de esta máquina.',
    n_not_near        = 'No estás cerca de una máquina de lavandería.',
    n_inventory_full  = 'Tu inventario está lleno — libera espacio e inténtalo de nuevo.',
    n_creator_placed    = 'Lavandería colocada.',
    n_creator_removed   = 'Lavandería eliminada.',
    n_creator_none      = 'No hay ninguna lavandería colocada cerca.',
    n_creator_cancelled = 'Colocación cancelada.',
    n_creator_load_fail = 'No se pudo cargar el prop de la lavandería.',

    -- HUD / textui
    hud_use_machine   = 'Usar la máquina',
    ld_world_label    = 'Usar la máquina',
    ld_loader_status  = 'Conectando al terminal',
    ld_loader_foot    = 'Cifrado · Red de lavado Apex',

    -- Wordmark
    wm_first          = 'APEX',
    wm_second         = 'LAUNDRY',

    -- Encabezado
    ui_brand          = 'Lavandería Apex',
    ui_subtitle       = 'Terminal de blanqueo de dinero',
    ui_status_idle    = 'Inactiva',
    ui_status_washing = 'Lavando',
    ui_status_ready   = 'Lista para recoger',
    ui_offline        = 'Sin acceso',

    -- Productos de limpieza
    ui_cleaners       = 'Productos de limpieza',
    ui_cleaners_sub   = 'Abastece la máquina para ejecutar un lavado',
    ui_in_stock       = 'En la máquina',
    ui_deposit        = 'Depositar',
    ui_units          = 'unidades',

    -- Lavado
    ui_wash           = 'Blanquear dinero',
    ui_wash_sub       = 'Convierte el dinero sucio en dinero limpio',
    ui_amount         = 'Cantidad',
    ui_amount_ph      = 'Introduce el importe sucio',
    ui_on_hand        = 'Disponible',
    ui_capacity       = 'Capacidad',
    ui_needs          = 'Limpiadores necesarios',
    ui_you_get        = 'Recibirás',
    ui_start          = 'Iniciar lavado',
    ui_max            = 'Máx',
    ui_dirty          = 'Dinero sucio',
    ui_clean          = 'Dinero limpio',

    -- Lavado activo
    ui_active         = 'Lavado en curso',
    ui_remaining      = 'Tiempo restante',
    ui_payout         = 'Retorno',
    ui_collect        = 'Recoger',
    ui_cancel         = 'Cancelar',
    ui_complete       = 'Completo',

    -- Mejoras
    ui_upgrades       = 'Mejoras',
    ui_level          = 'Nivel',
    ui_max_level      = 'Al máximo',
    ui_upgrade        = 'Mejorar',
    ui_next           = 'Siguiente',
    up_efficiency       = 'Eficiencia',
    up_efficiency_desc  = 'Aumenta la cantidad máxima que puedes blanquear en un solo lavado.',
    up_potency          = 'Potencia',
    up_potency_desc     = 'Mejora el hardware para reducir el tiempo de lavado.',

    -- Pie / meta
    ui_tax_rate       = 'Impuesto',
    ui_wash_rate      = 'Velocidad base',
    ui_close          = 'Cerrar',
    ui_locked_title   = 'Acceso denegado',
    ui_locked_text    = 'Esta máquina está restringida. No estás autorizado a operarla.',

    -- Modales
    md_deposit_title  = 'Depositar productos de limpieza',
    md_deposit_text   = '¿Cuántas unidades quieres cargar en la máquina?',
    md_deposit_ph     = 'Unidades',
    md_cancel_title   = '¿Cancelar el lavado?',
    md_cancel_text    = 'Se te devolverá el dinero sucio, pero los productos de limpieza ya usados se pierden.',
    md_upgrade_title  = 'Confirmar mejora',
    md_upgrade_text   = '¿Mejorar %s al nivel %s por %s?',
    md_confirm        = 'Confirmar',
    md_dismiss        = 'Descartar',

    -- Ajustes (por jugador)
    ui_settings       = 'Ajustes',
    ui_brand_color    = 'Color de marca',
    ui_background     = 'Fondo',
    ui_position       = 'Posición',
    ui_pos_left       = 'Izquierda',
    ui_pos_center     = 'Centro',
    ui_pos_right      = 'Derecha',
    ui_opacity        = 'Opacidad',
    ui_size           = 'Tamaño',
    ui_size_s         = 'Pequeño',
    ui_size_m         = 'Mediano',
    ui_size_l         = 'Grande',
    ui_reset_default  = 'Restablecer',

    -- Creador (menú de colocación)
    cr_title          = 'Nueva Lavandería',
    cr_machine        = 'Máquina',
    cr_access         = 'Acceso',
    cr_public         = 'Pública',
    cr_jobs_hint      = 'Añade los trabajos que pueden usar esta máquina (con grado mínimo).',
    cr_invisible      = 'Prop invisible',
    cr_place          = 'Colocar',
    cr_controls       = 'Controles de colocación',
    cr_rotate         = 'Rotar',
    cr_depth          = 'Empujar / Tirar',
    cr_height         = 'Altura',
    cr_add_job        = 'Añadir trabajo…',
    cr_grade          = 'Grado',
}
