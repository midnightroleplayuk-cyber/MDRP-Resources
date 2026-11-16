--[[ apex_garage — locales/es.lua

    Traducción al español (España). Tuteo.
    Referencia canónica: locales/en.lua. shared/utils.lua recurre a
    Locales.dict['en'] clave a clave, así que una traducción ausente nunca es fatal.

    Los especificadores de formato son críticos — mantenlos exactos:
        ui_sell_confirm  %s (vehículo), %s (precio)
        ui_hours         %s (horas)
        n_paid_fee       %s (importe)
        n_sold           $%s (importe)
]]

Locales = Locales or {}
Locales.dict = Locales.dict or {}

Locales.dict['es'] = {
    -- ─────────────────────────────────────────────────────────────
    -- Prompts (TextUI / etiquetas de target)
    -- ─────────────────────────────────────────────────────────────
    prompt_open      = 'Abrir garaje',
    prompt_store     = 'Guardar vehículo',
    prompt_impound   = 'Abrir depósito',

    -- Frase TextUI: <prefix> [E] <suffix> <prompt_* en minúsculas>
    -- p. ej. "Pulsa [E] para abrir garaje"
    ui_press_prefix  = 'Pulsa',
    ui_press_suffix  = 'para',

    -- ─────────────────────────────────────────────────────────────
    -- UI — shell, listas y filtros
    -- ─────────────────────────────────────────────────────────────
    ui_garage        = 'GARAJE',
    ui_impound       = 'DEPÓSITO',
    ui_search        = 'Buscar por nombre o matrícula…',
    ui_cash          = 'Efectivo',
    ui_bank          = 'Banco',
    ui_all           = 'Todos',
    ui_empty         = 'No tienes vehículos en este garaje.',
    ui_empty_impound = 'No hay vehículos en el depósito.',
    ui_sort_name     = 'Nombre (A-Z)',
    ui_sort_status   = 'Estado',
    ui_confirm       = 'Confirmar',
    ui_cancel        = 'Cancelar',
    ui_fee           = 'Tasa',
    ui_leave         = 'Salir',

    -- ─────────────────────────────────────────────────────────────
    -- UI — ficha del vehículo
    -- ─────────────────────────────────────────────────────────────
    ui_nickname       = 'Alias',
    ui_nickname_set   = 'Poner alias',
    ui_nickname_ph    = 'Alias del vehículo',
    ui_fuel           = 'Gasolina',
    ui_engine         = 'Motor',
    ui_body           = 'Carrocería',
    ui_status_stored  = 'En el garaje',
    ui_status_out     = 'Fuera',
    ui_status_impound = 'En el depósito',
    ui_financed       = 'Financiado',

    -- ─────────────────────────────────────────────────────────────
    -- UI — acciones del vehículo
    -- ─────────────────────────────────────────────────────────────
    ui_drive         = 'Sacar',
    ui_return_drive  = 'Recuperar y conducir',
    ui_transfer      = 'Transferir',
    ui_release       = 'Devolver al dueño',
    ui_recover       = 'Recuperar',
    ui_sell          = 'Vender',
    ui_sell_title    = 'Vender vehículo',
    ui_sell_confirm  = 'Vas a vender %s por %s. Esto no se puede deshacer.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — flujo de transferencia
    -- ─────────────────────────────────────────────────────────────
    ui_transfer_title       = 'Transferir vehículo',
    ui_transfer_garage      = 'A otro garaje',
    ui_transfer_player      = 'A otro jugador',
    ui_transfer_pick_garage = 'Elige el garaje de destino',
    ui_transfer_pick_player = 'Jugadores cercanos',
    ui_transfer_no_players  = 'No hay nadie cerca.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — flujo de depósito (policía / admin)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_title       = 'Incautar vehículo',
    ui_impound_reason      = 'Motivo',
    ui_impound_reason_ph   = 'Motivo de la incautación…',
    ui_impound_retrievable = 'El dueño puede recuperarlo',
    ui_impound_time        = 'Tiempo hasta poder recuperarlo',
    ui_impound_cost        = 'Coste de recuperación',
    ui_impound_confirm     = 'Incautar',
    ui_hours               = '%sh',
    ui_time_none           = 'Sin límite',
    ui_reason              = 'Motivo',

    -- UI — depósito: formulario y ficha (claves nuevas)
    ui_impound_lot              = 'Depósito',
    ui_impound_lot_nearest      = 'El más cercano',
    ui_impound_retrievable_desc = 'El dueño podrá recomprarlo cuando termine la retención.',
    ui_time_now                 = 'Disponible ya',
    ui_time_immediate           = 'Disponible ya',
    ui_impound_held_at          = 'Retenido en',
    ui_impound_officer          = 'Incautado por',
    ui_impound_no_reason        = 'Sin motivo',
    ui_impound_release          = 'Liberar',
    ui_impound_release_owner    = 'El dueño puede recogerlo',
    ui_impound_release_police   = 'Solo lo libera la policía',
    ui_impound_available        = 'Disponible en',
    ui_impound_available_now    = 'Disponible ya',
    ui_impound_free             = 'Gratis',
    ui_impound_wait             = 'Disponible en %s',
    ui_impound_owner            = 'Dueño',
    ui_impound_roster           = 'Vehículos retenidos',
    ui_impound_locked_hint      = 'Solo un agente puede liberarlo.',
    ui_at_impound               = 'Retenido en el depósito',
    ui_owner                    = 'Dueño',
    ui_unknown_owner            = 'Dueño desconocido',
    ui_dur_h                    = '%sh',
    ui_dur_m                    = '%smin',
    ui_dur_hm                   = '%hh %mmin',

    -- ─────────────────────────────────────────────────────────────
    -- UI — apariencia (panel de admin: tema global del servidor)
    -- ─────────────────────────────────────────────────────────────
    ui_theme            = 'Apariencia',
    ui_theme_colors     = 'Colores',
    ui_theme_brand      = 'Color de acento',
    ui_theme_bg         = 'Color de fondo',
    ui_theme_derive     = 'Cada superficie, borde y sombra se deriva de estos dos colores. Al guardar, el nuevo aspecto se aplica al instante a TODOS los jugadores.',
    ui_theme_presets    = 'Preajustes',
    ui_theme_preview    = 'Vista previa',
    ui_theme_apply      = 'Aplicar a todos',
    ui_theme_reset_def  = 'Restaurar por defecto',

    -- contenido de ejemplo de la vista previa (nunca se ve fuera del panel de apariencia)
    ui_theme_demo_title      = 'Mis vehículos',
    ui_theme_demo_stored     = 'Guardado',
    ui_theme_demo_finance    = 'Financiado',
    ui_theme_demo_kpi_stored = 'Guardados',
    ui_theme_demo_kpi_out    = 'Fuera',
    ui_theme_demo_take       = 'Sacar',
    ui_theme_demo_transfer   = 'Transferir',
    ui_theme_demo_search     = 'Buscar vehículo',

    -- ─────────────────────────────────────────────────────────────
    -- Notificaciones (n_) — avisos para el jugador
    -- ─────────────────────────────────────────────────────────────
    n_no_access      = 'No tienes acceso a este garaje.',
    n_no_vehicle     = 'No estás en un vehículo.',
    n_not_driver     = 'Tienes que ser el conductor.',
    -- Config.occupantGuard: la acción habría borrado el vehículo con gente dentro
    n_occupied         = 'Saca a los pasajeros del vehículo antes de guardarlo.',
    n_occupied_impound = 'Saca a todo el mundo del vehículo antes de incautarlo.',
    n_impound_on_foot = 'Baja del vehículo para usar el depósito.',
    n_wrong_class    = 'Este vehículo no pertenece a este garaje.',
    n_stored         = 'Vehículo guardado.',
    n_taken_out      = 'Vehículo sacado.',
    n_blocked        = 'No hay sitio para sacar el vehículo aquí.',
    n_paid_fee       = 'Tasa pagada: %s.',
    n_nickname_ok    = 'Alias actualizado.',
    n_transferred    = 'Vehículo transferido.',
    n_sold           = 'Vehículo vendido por %s$.',
    n_impounded      = 'Vehículo incautado.',
    n_released       = 'Vehículo devuelto al garaje del dueño.',
    n_recovered      = 'Vehículo recuperado del depósito.',
    n_no_target      = 'No hay ningún vehículo cerca.',

    -- notificaciones — depósito (claves nuevas)
    n_impound_locked    = 'Este vehículo solo lo puede liberar un agente.',
    n_impound_not_ready = 'Este vehículo aún no se puede recoger.',
    n_too_far           = 'Estás demasiado lejos del depósito.',
    n_impound_released  = 'Tu vehículo %s ha salido del depósito y te espera en %s.',
    n_impounded_reason  = 'Incautado por %s — %s',
    n_impound_no_reason = 'Sin motivo',
    n_impound_empty     = 'No tienes vehículos en este depósito.',

    -- ─────────────────────────────────────────────────────────────
    -- Notificaciones — comandos de admin y garajes privados
    -- ─────────────────────────────────────────────────────────────
    n_npc_removed    = 'Vehículo sin dueño eliminado.',
    n_priv_created   = 'Garaje privado creado.',
    n_priv_deleted   = 'Garaje privado eliminado.',
    n_priv_noperm    = 'No puedes crear garajes privados.',
    n_priv_name      = 'Ese nombre ya existe.',
    n_plate_changed  = 'Matrícula cambiada.',
    n_veh_returned   = 'Vehículo devuelto al garaje.',
    n_veh_deleted    = 'Vehículo eliminado de la base de datos.',

    -- ─────────────────────────────────────────────────────────────
    -- Errores (e_) — devueltos por el servidor, se buscan dinámicamente
    -- ─────────────────────────────────────────────────────────────
    e_nil         = 'Algo ha salido mal.',
    e_invalid     = 'No válido.',
    e_no_access   = 'Sin acceso.',
    e_not_owner   = 'No eres el dueño.',
    e_wrong_class = 'Este vehículo no pertenece a este garaje.',
    e_no_money    = 'No tienes suficiente dinero.',
    e_unavailable = 'No disponible.',
    -- el servidor rechazó la salida porque todas las plazas están ocupadas
    e_blocked     = 'No hay sitio para sacar el vehículo aquí.',
    e_busy        = 'Ya tienes una acción en curso.',
    e_no_target   = 'No hay ningún vehículo cerca.',
    e_already_out = 'Ese vehículo ya está fuera.',
    -- aparece también en el botón de recuperar, conviene que sea corto
    e_occupied    = 'Hay alguien dentro de ese vehículo.',
    e_stock_all_out    = 'Ya están todos fuera.',
    e_fleet_admin_only = 'Solo un administrador puede cambiar qué vehículos ofrece este garaje.',
    e_no_vehicle       = 'No estás en un vehículo.',
    e_stock_boss_only  = 'Solo un jefe designado o un administrador puede cambiar el aforo de la flota.',
    e_name        = 'Ese nombre ya está en uso.',

    -- errores — depósito (claves nuevas)
    e_impound_locked    = 'Solo lo libera un agente.',
    e_impound_not_ready = 'Aún no disponible.',
    e_too_far           = 'Demasiado lejos.',
    e_no_lot            = 'Ningún depósito admite este vehículo.',
    e_impounded         = 'Incautado.',

    -- errores — venta
    e_sell_off      = 'La venta instantánea no está disponible.',
    e_sell_financed = 'No puedes vender un vehículo financiado.',
    e_sell_out      = 'El vehículo está fuera.',
    e_sell_parked   = 'El vehículo está aparcado.',
    e_sell_impound  = 'El vehículo está en el depósito.',
    e_sell_noprice  = 'Este vehículo no tiene precio de mercado.',
    e_sell_payfail  = 'El pago de la venta ha fallado. Contacta con un administrador.',

    -- ─────────────────────────────────────────────────────────────
    -- Errores — aparcamiento persistente (/estacionar)
    -- ─────────────────────────────────────────────────────────────
    e_park_off         = 'El aparcamiento persistente está desactivado.',
    e_park_noperm      = 'No puedes aparcar aquí.',
    e_park_notowned    = 'Este vehículo no es tuyo.',
    e_park_max         = 'Has alcanzado tu límite de vehículos aparcados.',
    e_park_occupied    = 'Ya hay un vehículo aparcado aquí.',
    e_park_none        = 'No hay ningún vehículo aparcado con esa matrícula.',
    e_park_notowner    = 'Solo el dueño puede recuperar este vehículo.',
    e_park_busy        = 'El sistema de aparcamiento aún se está iniciando.',
    e_park_already     = 'Este vehículo ya está aparcado.',
    e_park_parked      = 'Este vehículo está aparcado en la calle — ve a buscarlo allí.',
    e_park_notdriving  = 'Tienes que estar dentro del vehículo que quieres aparcar.',
    e_park_moving      = 'Detén el vehículo por completo antes de aparcarlo.',
    e_park_blacklisted = 'No se puede aparcar en esta zona.',
    e_park_in_garage   = 'No puedes aparcar dentro de un garaje.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — verbos y etiquetas genéricas (botones, filas, diálogos)
    -- ─────────────────────────────────────────────────────────────
    ui_save        = 'Guardar',
    ui_close       = 'Cerrar',
    ui_collapse    = 'Contraer',
    ui_remove      = 'Quitar',
    ui_teleport    = 'Teletransportar',
    ui_name        = 'Nombre',
    ui_set         = 'Definir',
    ui_class       = 'Clase',
    ui_add         = 'Añadir',
    ui_create      = 'Crear',
    ui_delete      = 'Eliminar',
    ui_clear       = 'Limpiar',
    ui_place       = 'Colocar',
    ui_none        = 'Ninguno',
    ui_optional    = 'opcional',
    ui_yes         = 'Sí',
    ui_no          = 'No',
    ui_vehicle     = 'Vehículo',
    ui_min_grade   = 'Rango mínimo',
    ui_add_vehicle = 'Añadir vehículo',
    ui_edit        = 'Editar',
    ui_impound_section = 'Incautación',

    -- contadores — %s es el número; el JS elige singular o plural
    ui_count_one   = '%s vehículo',
    ui_count_many  = '%s vehículos',
    ui_grade       = 'rango %s',

    -- distintivo de la tarjeta del vehículo (MAYÚSCULAS a propósito)
    ui_brand_air   = 'AIRE',
    ui_brand_sea   = 'MAR',
    ui_brand_car   = 'VEHÍCULO',

    -- forma y estado de una zona
    ui_shape_corners = 'Esquinas',
    ui_shape_circle  = 'Círculo',
    ui_state_set     = 'Definida',
    ui_state_unset   = 'Sin definir',

    -- ─────────────────────────────────────────────────────────────
    -- UI — controles de la vista previa 3D (tooltips)
    -- ─────────────────────────────────────────────────────────────
    ui_pv_rotate_left  = 'Girar a la izquierda',
    ui_pv_autorotate   = 'Giro automático',
    ui_pv_rotate_right = 'Girar a la derecha',
    ui_pv_zoom_out     = 'Alejar',
    ui_pv_zoom_in      = 'Acercar',
    ui_pv_reset        = 'Reiniciar cámara',

    -- ─────────────────────────────────────────────────────────────
    -- Panel de admin (adm_) — lista de garajes, jefe y privados
    -- ─────────────────────────────────────────────────────────────
    adm_count_one   = '%s garaje',
    adm_count_many  = '%s garajes',
    adm_garages     = 'Garajes',
    adm_new_garage  = 'Nuevo garaje',
    adm_edit_garage = 'Editar garaje',
    adm_empty       = 'No hay garajes',
    adm_empty_sub   = 'Crea el primero con "Nuevo garaje".',
    adm_row_vehicles = '%s veh.',
    adm_tp_garage   = 'Teletransportarte al garaje',
    adm_src_config      = 'Definido en shared/config.lua',
    adm_src_created     = 'Creado en el juego',
    adm_src_config_chip = 'config.lua',
    adm_src_config_hint = 'Edítalo en shared/config.lua y reinicia el recurso',

    -- tipos de garaje (filtro y selector del editor)
    adm_type_public  = 'Público',
    adm_type_job     = 'Empleo',
    adm_type_private = 'Privado',
    adm_type_impound = 'Depósito',

    adm_pick_player     = 'Elegir jugador',
    adm_nobody_online   = 'No hay nadie conectado.',

    -- panel de jefe
    adm_company        = 'EMPRESA',
    adm_management     = 'GESTIÓN',
    adm_admin          = 'ADMIN',
    adm_company_garage = 'GARAJE DE EMPRESA',
    adm_company_fallback = 'Empresa',
    adm_boss_stock     = 'Por stock',
    adm_boss_infinite  = 'Retirada ilimitada',
    adm_boss_empty     = 'No hay vehículos',
    adm_boss_empty_sub = 'Añade los que la empresa pueda sacar.',
    adm_boss_empty_adm = 'Un administrador define esta flota en /apexgarage.',

    -- garajes privados
    adm_priv_title          = 'Garajes privados',
    adm_priv_empty          = 'Aún no tienes garajes privados.',
    adm_priv_create_here    = 'Crear aquí un garaje privado',
    adm_priv_delete_confirm = '¿Quitar este garaje privado?',
    adm_priv_create_title   = 'Crear garaje privado',
    adm_class_car_fallback  = 'Coche',

    -- ─────────────────────────────────────────────────────────────
    -- Editor de garajes (ed_)
    -- ─────────────────────────────────────────────────────────────
    ed_identification = 'Identificación',
    ed_name_ph        = 'Nombre del garaje',
    ed_type           = 'Tipo',
    ed_class_land     = 'Tierra',
    ed_class_air      = 'Aire',
    ed_class_sea      = 'Mar',
    ed_officer_job    = 'Empleo de los agentes',

    ed_veh_mode          = 'Modo de vehículos',
    ed_veh_mode_personal = 'Personal',
    ed_veh_mode_company  = 'Empresa',
    ed_veh_mode_list     = 'Lista',
    ed_stock_mode        = 'Modo de stock',
    ed_stock_infinite    = 'Ilimitado',
    ed_stock_by_stock    = 'Por stock',
    ed_stock             = 'Stock',
    ed_stock_start       = 'Stock inicial',
    ed_spawn_code        = 'Código de spawn',
    ed_veh_edit          = 'Editar vehículo',
    ed_veh_fleet_hint    = 'Solo un administrador puede cambiar qué vehículos ofrece este garaje. El jefe ajusta cuántos.',
    ed_boss_grade        = 'Rango de jefe',

    ed_owners          = 'Dueños',
    ed_owner_add       = 'Añadir dueño',
    ed_owners_existing = '%s dueño(s) actual(es) (se mantienen; añade uno para sustituirlos).',
    ed_owners_none     = 'Sin dueños — el garaje seguirá inaccesible hasta que añadas uno.',

    ed_zone_poly   = 'Polígono · %s esquinas',
    ed_zone_circle = 'Círculo · radio %s m',
    ed_zone_unset  = 'Aún sin definir',
    ed_store_set   = 'Punto dedicado definido',
    ed_store_unset = 'Opcional — si está vacío se usa la zona',

    ed_placement     = 'Ubicación en el mundo',
    ed_zone          = 'Zona del garaje',
    ed_tp_zone       = 'Teletransportarte a la zona',
    ed_spawns        = 'Puntos de aparición',
    ed_spawns_sub    = 'Dónde aparece el vehículo al sacarlo',
    ed_store_point   = 'Punto de guardado',
    ed_list_vehicles = 'Vehículos de la lista',
    ed_no_vehicles   = 'No hay vehículos. Añade los que este empleo pueda sacar.',

    -- ─────────────────────────────────────────────────────────────
    -- Aparcamiento persistente (pk_) — panel de admin
    -- ─────────────────────────────────────────────────────────────
    pk_title    = 'Aparcamiento',
    pk_settings = 'Ajustes',

    pk_tab_parking   = 'Aparcados',
    pk_tab_noparking = 'Zonas',
    pk_tab_settings  = 'Ajustes',

    pk_enabled       = 'Aparcamiento activado',
    pk_enabled_desc  = 'Permite a los jugadores aparcar en cualquier punto del servidor.',
    pk_nocol         = 'Sin colisión',
    pk_nocol_desc    = 'Los demás vehículos atraviesan los coches aparcados.',
    pk_jobveh        = 'Vehículos de empresa',
    pk_jobveh_desc   = 'Permite aparcar coches de empleo o empresa.',
    pk_nogarage      = 'Prohibir dentro de garajes',
    pk_nogarage_desc = 'Impide aparcar dentro de cualquier zona de garaje.',

    pk_who      = 'Quién puede aparcar',
    pk_who_desc = 'Define quién tiene acceso al comando.',
    pk_mode_public     = 'Todo el mundo',
    pk_mode_job        = 'Por empleo',
    pk_mode_permission = 'Por permiso',
    pk_jobs      = 'Empleos permitidos',
    pk_jobs_desc = 'Separados por comas.',

    pk_max         = 'Máximo por jugador',
    pk_max_desc    = 'Cuántos coches puede dejar aparcados cada jugador.',
    pk_unit_count  = 'ud',
    pk_radius      = 'Radio antisolape',
    pk_radius_desc = 'Distancia mínima a otro coche ya aparcado.',

    pk_perms           = 'Permisos',
    pk_grant           = 'Conceder',
    pk_grant_title     = 'Conceder permiso',
    pk_perms_empty     = 'No hay permisos',
    pk_perms_empty_sub = 'Concede acceso a un jugador conectado.',
    pk_revoke          = 'Revocar',
    pk_offline         = 'Desconectado',

    pk_zones           = 'Zonas sin aparcamiento',
    pk_zones_empty     = 'No hay zonas prohibidas',
    pk_zones_empty_sub = 'Dibuja un área donde nadie pueda aparcar.',
    pk_zone            = 'Zona',
    pk_zone_corners    = '%s esquinas',
    pk_zone_radius     = 'radio %s m',

    pk_parked           = 'Vehículos aparcados',
    pk_parked_empty     = 'No hay nada aparcado',
    pk_parked_empty_sub = 'Nadie ha dejado vehículos en el mundo.',
    pk_save_note        = 'Los cambios solo se aplican al guardar.',

    -- ─────────────────────────────────────────────────────────────
    -- Colocador en el mundo (prompt_) — teclas y títulos
    -- ─────────────────────────────────────────────────────────────
    prompt_key_radius      = 'Radio',
    prompt_key_place       = 'Colocar',
    prompt_key_cancel      = 'Cancelar',
    prompt_key_rotate      = 'Girar',
    prompt_key_add_corner  = 'Añadir esquina',
    prompt_key_finish      = 'Terminar',
    prompt_key_remove_last = 'Quitar la última',
    prompt_key_place_spawn = 'Colocar aparición',

    prompt_title_zone    = 'Definir zona',
    prompt_title_corners = 'Esquinas de la zona',
    prompt_title_spawn   = 'Definir punto de aparición',
    prompt_title_spawns  = 'Puntos de aparición',
    prompt_spawns_count  = '%s — %s colocados',

    prompt_place_zone_poly   = 'Esquinas de la zona — marca 3 o más',
    prompt_place_zone_circle = 'Zona del garaje — la rueda ajusta el radio',
    prompt_place_store       = 'Punto de guardado',
    prompt_back_panel        = 'Volver al panel',
    prompt_pk_zone_circle    = 'Zona sin aparcamiento — la rueda ajusta el radio',
    prompt_pk_zone_poly      = 'Zona sin aparcamiento — marca 3 esquinas o más',

    -- ─────────────────────────────────────────────────────────────
    -- Notificaciones — panel de admin y aparcamiento
    -- ─────────────────────────────────────────────────────────────
    n_garage_created      = 'Garaje creado.',
    n_garage_updated      = 'Garaje actualizado.',
    n_garage_deleted      = 'Garaje eliminado.',
    n_theme_saved         = 'Apariencia guardada para todo el servidor.',
    n_theme_reset         = 'Apariencia restaurada por defecto.',
    n_veh_added           = 'Vehículo añadido.',
    n_parked              = 'Vehículo aparcado.',
    n_unparked            = 'Vehículo retirado — devuelto al garaje.',
    n_park_exiting        = 'Aparcando — saliendo del vehículo…',
    n_park_exit_failed    = 'No saliste del todo, pero el vehículo queda aparcado.',
    n_park_released       = 'Vehículo liberado. Ya puedes conducirlo.',
    n_park_settings_saved = 'Ajustes de aparcamiento guardados.',
    n_park_veh_removed    = 'Vehículo aparcado eliminado.',
    n_park_zone_created   = 'Zona sin aparcamiento creada.',
    n_park_zone_removed   = 'Zona eliminada.',

    -- ─────────────────────────────────────────────────────────────
    -- Errores — panel de admin y aparcamiento
    -- ─────────────────────────────────────────────────────────────
    e_noperm          = 'Sin permiso.',
    e_theme_invalid   = 'Colores no válidos.',
    e_zone_create     = 'No se ha podido crear la zona.',
    e_no_zone         = 'Ese garaje aún no tiene zona definida.',
    e_need_placement  = 'Define la zona y al menos un punto de aparición.',
    e_config_readonly = 'Ese garaje está definido en shared/config.lua: edítalo allí y reinicia el recurso.',
    diag_nearest      = 'Garaje más cercano: %s (%s), a %s m — punto de acceso %s',
    diag_none         = 'Este cliente aún no ha cargado ningún garaje.',
    e_no_boss_garage  = 'No gestionas ningún garaje de empresa.',
    e_park_none_near  = 'No estás cerca de ninguno de tus vehículos aparcados.',

    -- ─────────────────────────────────────────────────────────────
    -- SIN USO — ya no se referencian desde ningún código Lua ni NUI.
    -- Se mantienen por compatibilidad.
    -- OJO: ui_leave YA NO va aquí — se usa en index.html:65 y se ha
    -- movido a la sección «UI — shell». Tradúcelo siempre.
    -- ─────────────────────────────────────────────────────────────
    ui_sort_recent      = 'Recientes',
    ui_plate            = 'Matrícula',
    ui_theme_brand_desc = 'Botones, marcadores y resaltados en todo el servidor.',
    ui_theme_bg_desc    = 'Tono base de la interfaz; todas las demás superficies se derivan de él.',
    ui_theme_reset      = 'Restablecer',
    ui_theme_save       = 'Guardar',
    ui_theme_hint       = 'Los colores se aplican a todos los jugadores en cuanto guardas.',
    ui_theme_unsaved    = 'Vista previa — aún sin guardar.',
    n_not_owner         = 'Este vehículo no es tuyo.',
    n_unavailable       = 'Vehículo no disponible ahora mismo.',
    n_already_out       = 'Ese vehículo ya está fuera.',
    n_no_money          = 'No tienes suficiente dinero.',
    n_invalid           = 'Acción no válida.',
}
