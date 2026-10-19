-- ============================================================
-- ESPAÑOL (es)
-- ------------------------------------------------------------
-- Capa sobre configs/strings.lua. Cualquier clave que falte aquí
-- conserva el texto en inglés, así que traducir por partes es seguro.
--
-- Los marcadores %s deben conservarse y en el MISMO orden que el
-- original: los rellena :format() en el código. Un %% imprime un
-- signo de porcentaje literal.
--
-- Activación:  Config.Locale = 'es'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['es'] = {
    -- ── Menú principal ──────────────────────────────────────
    main_title = 'Menú de Administración',
    self_options = 'Opciones Personales',
    self_options_desc = 'Opciones sobre ti mismo',
    player_options_title = 'Opciones de Jugador',
    player_options_desc = 'Opciones sobre otros jugadores',
    vehicle_options = 'Opciones de Vehículo',
    vehicle_options_desc = 'Opciones sobre vehículos',
    server_options = 'Opciones de Servidor',
    server_options_desc = 'Opciones sobre el servidor',
    admin_zone_options = 'Zonas de Admin',
    admin_zone_options_desc = 'Gestionar, añadir y eliminar zonas de admin',
    developer_options = 'Opciones de Desarrollador',
    developer_options_desc = '',

    -- ── Opciones personales ─────────────────────────────────
    self_options_menu = 'Opciones Personales',
    self_health = 'Vida (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Reanimar',
    self_revive_desc = 'Reanimarte a ti mismo',
    self_heal = 'Curar',
    self_heal_desc = 'Curarte a ti mismo',
    self_skinmenu = 'Menú de Ropa',
    self_set_ped = 'Cambiar de Ped',
    self_skinmenu_desc = 'Abrir el menú de ropa localmente',
    self_invisible = 'Invisible',
    self_godmode = 'Modo Dios',
    self_wallhack = 'Wallhack',

    -- ── Opciones de jugador ─────────────────────────────────
    player_options_menu = 'Jugadores Conectados %s/%s',
    player_options = 'Jugador: %s',
    player_health = 'Vida del Jugador (%s%%)',
    player_freeze = 'Congelar',
    player_freeze_desc = 'Activar/desactivar',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Activar/desactivar',
    player_spectate = 'Espectar',
    player_spectate_desc = 'Observar las acciones de este jugador',
    player_playerdata = 'Datos del Jugador',
    player_playerdata_desc = 'Ver los datos del jugador',
    player_revive = 'Reanimar',
    player_revive_desc = 'Reanimar al jugador',
    player_heal = 'Curar',
    player_heal_desc = 'Curar al jugador',
    player_skinmenu = 'Menú de Ropa',
    player_skinmenu_desc = 'Abrir un menú de ropa en el jugador',
    player_money = 'Dar Dinero',
    player_money_desc = 'Dar dinero al jugador seleccionado',
    player_item = 'Dar Objeto',
    player_item_desc = 'Dar un objeto al jugador seleccionado',
    player_openinv = 'Abrir Inventario',
    player_openinv_desc = 'Abrir el inventario del jugador',
    player_clearinv = 'Vaciar Inventario',
    player_clearinv_desc = 'Vaciar el inventario del jugador',
    player_teleport_to = 'Teletransportarse al Jugador',
    player_teleport_to_desc = 'Teletransportarte hasta el jugador',
    player_bring = 'Traer',
    player_bring_desc = 'Traer al jugador a tu posición',
    player_kick = 'Expulsar',
    player_kick_desc = 'Expulsar al jugador del servidor',
    player_ban = 'Banear Jugador',

    -- ── Menú de vehículo ────────────────────────────────────
    vehicle_menu = 'Menú de Vehículo',
    spawn_car = 'Generar Vehículo',
    spawn_car_desc = 'Generar un vehículo',
    repair_car = 'Reparar Vehículo',
    repair_car_desc = 'Reparar el vehículo actual o el más cercano',
    delete_car = 'Eliminar Vehículo',
    delete_car_desc = 'Eliminar el vehículo actual o el más cercano',
    number_plate = 'Modificar Matrícula',
    number_plate_desc = 'Cambiar el texto de la matrícula actual',
    refuel = 'Repostar Vehículo',
    refuel_desc = 'Repostar el vehículo actual o el más cercano',
    give_keys = 'Dar Llaves',
    give_keys_desc = 'Darte las llaves del vehículo actual',
    doors = 'Bloquear/Desbloquear Puertas',
    doors_desc = 'Alterna los seguros del vehículo más cercano',
    boost_car = 'Multiplicador de Par',
    boost_car_desc = 'Modificar el par motor del vehículo actual',
    color_change = 'Cambiar Color del Vehículo',
    color_change_desc = 'Cambiar el color del vehículo actual o el más cercano',

    -- ── Gestión del servidor ────────────────────────────────
    server_management = 'Gestión del Servidor',
    server_announcement = 'Anuncio del Servidor',
    server_announcement_desc = 'Enviar un anuncio global a todo el servidor',
    ban_list = 'Lista de Baneos',
    ban_list_desc = 'Consultar todos los baneos activos',
    objects_list = 'Eliminar Entidades',
    objects_list_desc = 'Eliminar vehículos y peds',
    objects_list_label = 'Opciones',
    weather_menu = 'Gestión del Clima',
    weather_menu_desc = 'Gestionar el clima',

    -- ── Zonas de admin ──────────────────────────────────────
    zones_create = 'Crear Zona',
    zones_create_desc = 'Crear una nueva zona de admin',
    zones_manage = 'Gestionar Zonas',
    zones_manage_desc = 'Editar o eliminar las zonas activas',
    zone_edit_current = 'Editar Zona Actual',
    zone_edit_current_desc = 'Gestionar la zona en la que te encuentras',
    zone_delete_current = 'Eliminar Zona Actual',
    zone_delete_current_desc = 'Eliminar la zona en la que te encuentras',
    zone_manage_menu = 'Editando la Zona (%s)',
    zone_edit = 'Editar Zona',
    zone_edit_desc = 'Modificar la zona: %s',
    zone_delete = 'Eliminar Zona',
    zone_delete_desc = 'Eliminar la zona: %s',
    zone_teleport = 'Teletransportarse a la Zona',
    zone_teleport_desc = 'Ir a la zona: %s',

    -- ── Menú de desarrollador ───────────────────────────────
    dev_options = 'Opciones de Desarrollador',
    debug_mode = 'Modo Depuración',
    debug_mode_desc = 'Activar/desactivar el modo depuración',
    copy_vec3 = 'Copiar Coordenadas Vector3',
    copy_vec3_desc = 'Copia tu posición actual (vector3) al portapapeles',
    copy_vec4 = 'Copiar Coordenadas Vector4',
    copy_vec4_desc = 'Copia tu posición actual (vector4) al portapapeles',
    copy_heading = 'Copiar Orientación',
    copy_heading_desc = 'Copia tu orientación actual al portapapeles',
    cant_delete = '¡No se puede eliminar!',
    cant_delete_player_desc = '¡No puedes eliminar el ped de un jugador!',
    cant_delete_entity_desc = '¡No puedes eliminar los objetos por defecto del mapa!',

    -- ── Lista de baneos ─────────────────────────────────────
    ban_list_menu = 'Lista de Baneos',
    ban_list_name = 'Nombre: %s',
    ban_list_license = 'Licencia:',
    ban_list_by = 'Emitido por: %s',
    ban_list_reason = 'Motivo: %s',
    ban_list_length = 'Tiempo restante: %s horas %s minutos',
    ban_list_modify = 'Modificar Baneo',
    ban_list_unban = 'Desbanear Jugador',
    ban_list_no_data = 'Sin Baneos',
    ban_list_no_data_desc = '¡No se ha encontrado ningún baneo activo!',

    -- ── Datos del jugador ───────────────────────────────────
    playerdata_menu = 'Datos del Jugador',
    playerdata_license_esx = 'Licencia: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Haz clic para copiar la licencia completa',
    playerdata_igname = 'Nombre: %s',
    playerdata_igname_desc = 'Nombre completo del jugador en el juego',
    playerdata_steam = 'Nombre de Steam: %s',
    playerdata_steam_desc = 'Nombre completo de Steam del jugador',
    playerdata_gender = 'Sexo: %s',
    playerdata_gender_desc = 'Sexo del jugador',
    playerdata_cash = 'Efectivo: %s',
    playerdata_cash_desc = 'Saldo en efectivo del jugador',
    playerdata_bank = 'Banco: %s',
    playerdata_bank_desc = 'Saldo bancario del jugador',
    playerdata_blackmoney = 'Dinero Negro: %s',
    playerdata_blackmoney_desc = 'Saldo de dinero negro del jugador',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Pulsa [E] para eliminar la entidad  \nHash: %s  \nCoords: vec3(%s, %s, %s)  \nOrientación: %s  \nPropietario: [%s] - %s',
    debug_textui_noname = 'Pulsa [E] para eliminar la entidad\n  Hash: %s\n  Coords: vec3(%s, %s, %s)\n  Orientación: %s\n  Propietario: DESCONOCIDO',

    textui_invisible = 'Modo Invisible - Activado',
    textui_godmode = 'Modo Dios - Activado',
    textui_wallhack = 'Wallhack - Activado',
    textui_noclip_activated = 'No Clip - Activado',
    textui_torque = 'Multiplicador de Par - %s',

    -- ── Anuncios ────────────────────────────────────────────
    dialog_announce = 'Anuncio',
    dialog_announce_label = 'Mensaje',
    dialog_announce_select = 'Todos',
    dialog_announce_everyone = 'Todos',
    dialog_announce_placeholder = 'Mensaje importante aquí. . .',

    -- ── Desbaneo ────────────────────────────────────────────
    dialog_unban = '¿Estás seguro?',
    dialog_unban_content = '¿Seguro que quieres desbanear a %s?',

    -- ── Eliminar entidades ──────────────────────────────────
    dialog_objects = 'Elige una opción',
    dialog_clear_objects = 'Eliminar TODOS los objetos',
    dialog_clear_cars = 'Eliminar TODOS los coches (sin conductor)',
    dialog_clear_peds = 'Eliminar TODOS los peds',

    -- ── Dar dinero ──────────────────────────────────────────
    dialog_givemoney = 'Dar Dinero',
    givemoney_input_label = 'Cantidad',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Cuenta',
    givemoney_select_option1 = 'Efectivo',
    givemoney_select_option2 = 'Banco',
    givemoney_select_option3 = 'Dinero Negro',

    -- ── Dar objeto ──────────────────────────────────────────
    dialog_giveitem = 'Dar Objeto',
    giveitem_input_label = 'Nombre del Objeto',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Cantidad',
    giveitem_amount_input_placeholder = '3',

    -- ── Generar vehículo ────────────────────────────────────
    dialog_spawn_a_car = 'Generar Vehículo',
    dialog_car_model = 'Nombre del Modelo',
    dialog_car_model_holder = 'Ej: 20charger',
    dialog_car_plate = 'Matrícula (opcional)',
    dialog_car_plate_holder = 'Ej: W4S4B1',
    dialog_car_color_primary = 'Color Primario (opcional)',
    dialog_car_color_second = 'Color Secundario (opcional)',
    dialog_car_maxed = 'Modificaciones al Máximo (opcional)',

    -- ── Expulsión ───────────────────────────────────────────
    dialog_kick = 'Expulsar a %s',
    dialog_kick_reason = 'Motivo',
    dialog_kick_placeholder = 'Tramposo',
    kicked_reason_replace = '¡Has sido expulsado del servidor!',

    -- ── Baneo ───────────────────────────────────────────────
    dialog_ban = 'Banear a %s',
    dialog_ban_reason = 'Motivo',
    dialog_ban_placeholder = 'Tramposo',
    ban_reason_replace = '¡Has sido baneado de este servidor!',

    -- ── Creación de zona ────────────────────────────────────
    dialog_zone_create = 'Creación de Zona',
    dialog_zone_name = 'Nombre',
    dialog_zone_name_desc = 'El nombre de la zona / del blip',
    dialog_zone_name_holder = 'Zona de Admin',
    dialog_zone_text = 'Texto Mostrado',
    dialog_zone_text_desc = 'El texto que se muestra a los jugadores dentro de la zona',
    dialog_zone_text_holder = 'ZONA DE ADMIN - ACTIVA',
    dialog_zone_size = 'Tamaño',
    dialog_zone_speed = 'Límite de Velocidad',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID del Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID de Color',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Parpadeante',
    dialog_zone_disarm = 'Desarmar',
    dialog_zone_revive = 'Reanimar',
    dialog_zone_invincible = 'Invencible',
    dialog_zone_edit = 'Editando «%s»',
    dialog_zone_delete_confirm = '¿Estás seguro?',
    dialog_zone_delete_confirm_desc = '¿Seguro que quieres eliminar la zona: %s',

    -- ── Notificaciones: dinero ──────────────────────────────
    notify_givemoney_success = 'Dinero Entregado',
    notify_givemoney_success_desc = 'Has abonado a %s $%s en la cuenta: %s',
    notify_givemoney_fail = 'Sin Éxito',
    notify_givemoney_fail_desc = '¡Has intentado abonar a %s pero algo salió mal! Inténtalo de nuevo.',

    -- ── Notificaciones: objetos ─────────────────────────────
    notify_giveitem_success = 'Objeto Entregado',
    notify_giveitem_success_desc = 'Has abonado a %s. Objeto: %s Cantidad: %s',
    notify_giveitem_fail = 'Fallo',
    notify_giveitem_fail_desc = '¡Has intentado abonar a %s pero algo salió mal! Inténtalo de nuevo.',

    -- ── Notificaciones: expulsión / baneo ───────────────────
    notify_kicked_success = 'Expulsión Correcta',
    notify_kicked_success_desc = 'Has expulsado a %s correctamente',
    notify_banned_success = 'Baneo Correcto',
    notify_banned_success_desc = 'Has baneado a %s correctamente',

    -- ── Notificaciones: inventario ──────────────────────────
    notify_clearedinv = 'Inventario Vaciado',
    notify_clearedinv_desc = 'Has vaciado correctamente el inventario de %s',

    -- ── Notificaciones: ID inválido ─────────────────────────
    notify_invalidid = 'ID Inválido',
    notify_invalidid_desc = 'El ID introducido no es válido, inténtalo de nuevo.',

    -- ── Notificaciones: limpieza ────────────────────────────
    notify_deleted_car = 'Coches Eliminados',
    notify_deleted_car_desc = 'Has eliminado correctamente todos los coches sin conductor.',
    notify_deleted_ped = 'Peds Eliminados',
    notify_deleted_ped_desc = 'Has eliminado correctamente todos los peds del mapa',
    notify_deleted_objects = 'Objetos Eliminados',
    notify_deleted_objects_desc = 'Has eliminado correctamente todos los objetos del mapa',

    -- ── Notificaciones: clima ───────────────────────────────
    notify_weather = 'Clima Modificado',
    notify_weather_desc = 'Clima cambiado a: %s',

    -- ── Notificaciones: copiar coordenadas ──────────────────
    notify_copied = 'Copiado',
    notify_copied_vec3 = '¡Vector3 copiado al portapapeles!',
    notify_copied_vec4 = '¡Vector4 copiado al portapapeles!',
    notify_copied_headin = '¡Orientación copiada al portapapeles!',

    -- ── Notificaciones: puertas ─────────────────────────────
    notify_locked_doors = 'Bloqueado',
    notify_locked_doors_desc = 'Puertas del vehículo bloqueadas correctamente.',
    notify_unlocked_doors = 'Desbloqueado',
    notify_unlocked_doors_desc = 'Puertas del vehículo desbloqueadas correctamente.',

    -- ── Notificaciones: zonas de admin ──────────────────────
    notify_zone_deleted = 'Zona Eliminada',
    notify_zone_deleted_desc = 'Has eliminado correctamente la zona: %s.',
    notify_zone_not_deleted_desc = 'Ocurrió un error al intentar eliminar la zona: %s.',
    notify_zone_edited = 'Zona Modificada',
    notify_zone_edited_desc = 'Has modificado correctamente la zona: %s.',
    notify_zone_not_edited_desc = 'Ocurrió un error al intentar modificar la zona: %s.',
    notify_zone_action_cancelled = 'Acción Cancelada',
    notify_zone_delete_cancel = 'Has cancelado la eliminación de la zona: %s',
    notify_zone_no_weapons = 'Armas No Autorizadas',
    notify_zone_no_weapons_desc = 'No tienes permiso para usar armas dentro de esta zona.',
    notify_zones_not_found = 'Sin Zonas',
    notify_zones_not_found_desc = 'Actualmente no hay ninguna zona activa que gestionar.',
    notify_zones_teleport = 'Teletransportado',
    notify_zones_teleport_desc = 'Te has teletransportado correctamente a la zona: %s.',

    -- ── Notificaciones: desbaneo ────────────────────────────
    successfully_unbanned = 'Baneo Revocado',
    successfully_unbanned_desc = 'Has desbaneado correctamente a: %s.',
    unsuccessful_unban = 'Algo salió mal al intentar desbanear a: %s.',

    -- ── Conexión (deferrals) ────────────────────────────────
    deferral_welcome = '[%s] Hola %s, comprobando baneos. . .',
    deferral_banned = 'Estás baneado del servidor. Motivo: «%s» (Tiempo restante: %s horas %s minutos).',
    deferral_banned_perm = 'Estás baneado del servidor. Motivo: «%s» (Tiempo restante: Permanente).',

    -- ── Errores ─────────────────────────────────────────────
    notify_error = 'Error',
    notify_disabled_keys = 'No hay ningún script de llaves de vehículo configurado. Contacta con el desarrollador del servidor.',
    notify_no_appearance = 'No se ha detectado ningún script de ropa / apariencia. Contacta con el desarrollador del servidor.',
    notify_no_vehicle = '¡No se ha encontrado ningún vehículo!',
    notify_invalid_entry = '¡Entrada no válida!',

    -- ── Atajo de teclado ────────────────────────────────────
    keymapping_desc = 'Abrir el Menú de Administración (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Activado',
    noclip_deactivated = 'NoClip Desactivado',

    -- ── Invisibilidad ───────────────────────────────────────
    invisibility_activated = 'Modo Invisible Activado',
    invisibility_deactivated = 'Modo Invisible Desactivado',

    -- ── Modo Dios ───────────────────────────────────────────
    godmode_activated = 'Modo Dios Activado',
    godmode_deactivated = 'Modo Dios Desactivado',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Activado',
    wallhack_deactivated = 'Wallhack Desactivado',

    -- ── Modo depuración ─────────────────────────────────────
    debug_activated = 'Modo Depuración Activado',
    debug_deactivated = 'Modo Depuración Desactivado',

    -- ── Notificaciones: vehículos ───────────────────────────
    vehicle_repaired = 'Vehículo Reparado',
    vehicle_repaired_desc = 'El vehículo se ha reparado correctamente.',
    vehicle_deleted = 'Vehículo Eliminado',
    vehicle_deleted_desc = 'El vehículo se ha eliminado correctamente.',
    vehicle_spawned = 'Vehículo Generado',
    vehicle_spawned_desc = 'El vehículo %s se ha generado correctamente.',
    vehicle_plate_changed = 'Matrícula Cambiada',
    vehicle_plate_changed_desc = 'Matrícula del vehículo cambiada a: %s',
    vehicle_refueled = 'Vehículo Repostado',
    vehicle_refueled_desc = 'El vehículo se ha repostado correctamente.',
    vehicle_keys_given = 'Llaves Recibidas',
    vehicle_keys_given_desc = 'Has recibido las llaves del vehículo con matrícula: %s',
    vehicle_color_changed = 'Color del Vehículo Cambiado',
    vehicle_color_changed_desc = 'Color del vehículo cambiado a: %s',
    vehicle_torque_set = 'Multiplicador de Par Aplicado',
    vehicle_torque_set_desc = 'Par ajustado a: %sx',
    vehicle_torque_disabled = 'Multiplicador de Par Desactivado',

    -- ── Espectar ────────────────────────────────────────────
    spectate_started = 'Espectando',
    spectate_started_desc = 'Estás espectando a %s. Pulsa X para salir.',
    spectate_ended = 'Espectar Finalizado',
    spectate_ended_desc = 'Ya no estás espectando a nadie.',
    spectate_error = 'Error al Espectar',
    spectate_error_desc = 'Jugador objetivo no encontrado o ya no existe.',

    -- ── Teletransporte ──────────────────────────────────────
    teleport_success = 'Teletransportado',
    teleport_success_desc = 'Te has teletransportado correctamente.',

    -- ── Reanimar / curar ────────────────────────────────────
    player_revived = 'Jugador Reanimado',
    player_revived_desc = 'Has reanimado correctamente a %s.',
    player_healed = 'Jugador Curado',
    player_healed_desc = 'Has curado correctamente a %s.',
    self_revived = 'Reanimado',
    self_revived_desc = 'Te has reanimado a ti mismo.',
    self_healed = 'Curado',
    self_healed_desc = 'Te has curado a ti mismo.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Cambiado',
    ped_changed_desc = 'Tu modelo de ped ha sido cambiado.',
    ped_restored = 'Ped Restaurado',
    ped_restored_desc = 'Tu modelo de ped original ha sido restaurado.',

    skin_menu_opened = 'Menú de Ropa Abierto',

    admin_menu_opened = 'Menú de Admin Abierto',
    admin_menu_closed = 'Menú de Admin Cerrado',

    entity_deleted = 'Entidad Eliminada',
    entity_deleted_desc = 'La entidad se ha eliminado correctamente.',

    player_frozen = 'Jugador Congelado',
    player_frozen_desc = 'El jugador %s ha sido congelado.',
    player_unfrozen = 'Jugador Descongelado',
    player_unfrozen_desc = 'El jugador %s ha sido descongelado.',

    -- ── Matrícula personalizada ─────────────────────────────
    dialog_license_plate = 'Matrícula Personalizada',
    dialog_license_plate_label = 'Matrícula',
    dialog_license_plate_placeholder = 'Matrícula',

    -- ── Quitar dinero ───────────────────────────────────────
    player_removemoney = 'Quitar Dinero',
    player_removemoney_desc = 'Quitar dinero al jugador seleccionado',
    dialog_removemoney = 'Quitar Dinero',
    removemoney_input_label = 'Cantidad',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Cuenta',
    notify_removemoney_success = 'Dinero Retirado',
    notify_removemoney_success_desc = 'Has quitado $%s a %s (cuenta: %s)',
    notify_removemoney_fail = 'Sin Éxito',
    notify_removemoney_fail_desc = 'No se pudo quitar dinero a %s (quizá saldo insuficiente).',

    -- ── Dimensiones / routing buckets ───────────────────────
    self_dimension = 'Definir Mi Dimensión',
    self_dimension_desc = 'Moverte a un routing bucket (0 = mundo principal)',
    player_dimension = 'Definir Dimensión',
    player_dimension_desc = 'Mover a este jugador a un routing bucket',
    player_dimension_bring = 'Traer a Mi Dimensión',
    player_dimension_bring_desc = 'Traer a este jugador a tu dimensión actual',
    player_dimension_goto = 'Unirse a la Dimensión del Jugador',
    player_dimension_goto_desc = 'Moverte a la dimensión de este jugador',
    dialog_dimension = 'Definir Dimensión',
    dimension_input_label = 'Dimensión (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensión Cambiada',
    notify_dimension_self_desc = 'Ahora estás en la dimensión %s.',
    notify_dimension_player_desc = '%s ha sido movido a la dimensión %s.',
    notify_dimension_join_desc = 'Te has unido a la dimensión de %s (%s).',
    notify_dimension_fail = 'Error de Dimensión',
    notify_dimension_fail_desc = 'No se pudo cambiar la dimensión.',

    -- ── Teletransporte al vehículo ──────────────────────────
    player_tp_vehicle = 'Teletransportarse al Vehículo',
    player_tp_vehicle_desc = 'Entrar en el vehículo de este jugador para ayudar a recuperarlo',
    notify_tp_vehicle_fail = 'Sin Vehículo',
    notify_tp_vehicle_fail_desc = '%s no está en un vehículo.',
    notify_tp_vehicle_success = 'Teletransportado',
    notify_tp_vehicle_success_desc = 'Has sido colocado dentro del vehículo de %s.',

    -- ── Recuperar vehículo ──────────────────────────────────
    recover_car = 'Recuperar / Enderezar Vehículo',
    recover_car_desc = 'Enderezar y mover a la carretera más cercana (mar/volcado)',
    vehicle_recovered = 'Vehículo Recuperado',
    vehicle_recovered_desc = 'El vehículo fue enderezado y colocado en la carretera más cercana.',

    -- ── Vehículos en propiedad ──────────────────────────────
    player_owned_vehicles = 'Vehículos en Propiedad',
    player_owned_vehicles_desc = 'Ver, añadir o quitar los coches de este jugador',
    owned_vehicles_menu = 'Vehículos en Propiedad (%s)',
    owned_vehicles_add = 'Añadir Vehículo',
    owned_vehicles_add_desc = 'Añadir un vehículo al garaje de este jugador',
    owned_vehicles_none = 'Sin Vehículos',
    owned_vehicles_none_desc = 'Este jugador no posee ningún vehículo.',
    owned_vehicle_desc = 'Matrícula: %s · haz clic para quitar',
    dialog_add_vehicle = 'Añadir Vehículo',
    add_vehicle_model_label = 'Nombre del Modelo',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Matrícula (opcional)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '¿Quitar %s?',
    notify_owned_added = 'Vehículo Añadido',
    notify_owned_added_desc = 'Añadido %s (matrícula %s) a %s.',
    notify_owned_removed = 'Vehículo Quitado',
    notify_owned_removed_desc = 'Quitada la matrícula %s de %s.',
    notify_owned_fail = 'Error de Base de Datos',
    notify_owned_fail_desc = 'La operación en la base de datos de vehículos ha fallado.',

    -- ── Menú de peds ────────────────────────────────────────
    player_pedmenu = 'Dar Menú de Peds',
    player_pedmenu_desc = 'Abrir un menú de selección de ped en la pantalla de este jugador',
    pedmenu_title = 'Menú de Peds',
    pedmenu_given = 'Menú de Peds Enviado',
    pedmenu_given_desc = 'Menú de peds abierto para %s.'
}
