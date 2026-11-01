JobConfigLocales["sky_mechanicjob:es"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Instalación del dinamómetro móvil",
                    entryPluralLabel = "Instalaciones del dinamómetro móvil",
                    label = "Instalaciones del dinamómetro móvil",
                },
                workshops = {
                    entryLabel = "Taller",
                    entryPluralLabel = "Talleres",
                    label = "Talleres",
                },
            },
            dispatchActions = {
                addChannel = "Añadir canal de radio",
                addKeyword = "Añadir palabra clave",
                addPoi = "Añadir punto de interés",
                addReporter = "Añadir alertante",
                addStatus = "Añadir estado FMS",
                addVehicle = "Añadir unidad virtual",
                addVehicleType = "Añadir tipo de unidad",
                currentLocation = "Usar ubicación actual",
            },
            dispatchFieldDescriptions = {
                crewCapacity = "Número máximo de personas que pueden ocupar la unidad. Usa 0 para una dotación ilimitada.",
                joinLocked = "Impide que se incorporen más personas una vez ocupada la unidad.",
                minimumCrew = "Número mínimo de personas en las unidades seleccionadas para este plan de respuesta.",
                poiId = "Identificador técnico estable que los perfiles de central pueden conservar aunque cambie el nombre del lugar.",
                readyStatusCode = "Estado FMS aplicado cuando el recurso queda disponible para despacho.",
                resourceType = "Clasifica el recurso operativo para los filtros y la coordinación de la central.",
                respondingStatusCode = "Estado FMS aplicado cuando el recurso responde a un incidente.",
                shortLabel = "Etiqueta corta opcional mostrada en las seis memorias de canales de radio.",
                stationId = "Asocia la unidad con una estación configurada en el perfil de la central.",
                unitId = "Identificador técnico estable que conserva la unidad aunque cambie su indicativo.",
                autoAlarm = "Asigna inmediatamente unidades disponibles coincidentes cuando se crea un incidente.",
                available = "Las unidades en este estado pueden ser sugeridas y asignadas a un nuevo incidente.",
                averageResponseSpeedKmh = "Calcula la estimación de llegada mostrada a partir de la distancia en línea recta.",
                callsign = "Indicativo de radio único que se muestra cuando los jugadores trabajan en esta unidad virtual.",
                centerEnabled = "Permite que los miembros autorizados en servicio proporcionen personal a un centro de despacho.",
                channelId = "ID de canal de radio para PMA Voice, SaltyChat y YACA. Los identificadores numéricos como 2500 permanecen sin cambios; PMA Voice asigna identificaciones de texto a un número estable.",
                channelLabel = "Nombre de canal legible que se muestra a los despachadores y unidades.",
                defaultChannel = "Los despachadores se unen a este canal al iniciar su turno. Las unidades se unen manualmente desde la pestaña Radio. Seleccione Ninguno para utilizar el valor predeterminado del grupo de trabajos.",
                emergencyAppEnabled = "Hace que este trabajo sea seleccionable como servicio público en la aplicación del teléfono de emergencia.",
                enabled = "Hace que este trabajo esté disponible para la aplicación Dispatch y para incidentes entre trabajos.",
                icon = "Seleccione el ícono que se muestra para esta categoría de unidad en la aplicación Dispatch.",
                incidentAssessmentEnabled = "Muestra preguntas médicas y de evaluación de peligros en la entrada completa del incidente.",
                jobs = "Nombres de trabajos adicionales que reciben incidentes utilizando esta palabra clave.",
                noUnitFallback = "Sin un centro o unidad con personal, envía una notificación Sky a todos los miembros en servicio.",
                radius = "Distancia máxima en metros a la que se puede escuchar el anuncio de la emisora.",
                requirements = "Demanda de respuesta como TYPE:COUNT pares, por ejemplo PATROL:2,CRIME:1.",
                statusCode = "Estado numérico de FMS que se muestra en la radio portátil.",
                statusLabel = "Significado de este estado de FMS para despachadores y unidades.",
                vehicleType = "Debe coincidir con un código de tipo de vehículo configurado en la subsección anterior.",
                vehicleTypeCode = "Código de unidad corto utilizado en requisitos de respuesta, por ejemplo PATRULLA, CRIMEN, EMS o RESCATE.",
                vehicleTypeLabel = "Nombre legible de esta categoría de unidad.",
            },
            dispatchFields = {
                crewCapacity = "Capacidad de dotación",
                joinLocked = "Bloquear incorporación a la dotación",
                minimumCrew = "Dotación mínima",
                poiId = "ID estable del punto de interés",
                readyStatusCode = "Código de estado disponible",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado en respuesta",
                shortLabel = "Etiqueta de memoria de radio",
                stationId = "ID de estación",
                unitId = "ID estable de unidad",
                address = "Dirección",
                autoAlarm = "Alarma automática",
                available = "Disponible para envío",
                averageResponseSpeedKmh = "Velocidad de respuesta estimada (km/h)",
                callsign = "Indicativo de llamada",
                category = "Categoría",
                centerEnabled = "Habilitar centro de despacho",
                channelId = "ID de canal",
                code = "Código",
                defaultChannel = "Canal de radio predeterminado",
                emergencyAppEnabled = "Mostrar en la aplicación de emergencia",
                enabled = "Habilitar despacho",
                icon = "Icono",
                incidentAssessmentEnabled = "Habilitar evaluación de emergencia",
                jobs = "Trabajos de destino (separados por comas)",
                keywordCode = "Código de palabra clave",
                label = "Etiqueta",
                name = "Nombre",
                noUnitFallback = "Notificar al personal de servicio sin unidades",
                noneChannel = "Ninguno/grupo predeterminado",
                note = "Nota",
                phone = "Teléfono",
                radius = "Radio de anuncio",
                requirements = "Unidades requeridas (por ejemplo PATRULLA:2,CRIMEN:1)",
                type = "Tipo",
                vehicleType = "Tipo de unidad de respuesta",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Alertantes conocidos",
                    channels = "Canales de radio",
                    plans = "Planes de respuesta",
                    statuses = "Estados FMS disponibles",
                    units = "Unidades virtuales",
                },
                active = "Central de despacho activa",
                description = "Configura la recepción de emergencias, la radio, las unidades, los planes de respuesta, las ubicaciones y los datos de alertantes para este trabajo.",
                inactive = "Central de despacho desactivada",
                steps = {
                    accessText = "Activa la central y decide si este trabajo puede dotar de personal a un centro de despacho.",
                    accessTitle = "Acceso y recepción",
                    fleetText = "Configura canales, códigos de estado FMS, tipos de vehículos e indicativos.",
                    fleetTitle = "Radio y flota",
                    responseText = "Finaliza con palabras clave, requisitos de respuesta y puntos de interés.",
                    responseTitle = "Planes de respuesta",
                },
                title = "Central de despacho",
                warnings = {
                    channels = "No hay canales de radio propios; se utilizará el canal alternativo del grupo de trabajos.",
                    defaultChannel = "El canal predeterminado seleccionado ya no existe.",
                    disabled = "La central de despacho está desactivada para este trabajo.",
                    statuses = "Debe haber al menos un estado FMS disponible para poder alertar a las unidades.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Gestiona nombres de alertantes, teléfonos de devolución de llamada y notas de despacho propias del trabajo.",
                dispatchChannels = "Define los canales de radio a los que pueden unirse las unidades y los centros de despacho con personal.",
                dispatchKeywords = "Define palabras clave de incidentes, recuentos de vehículos requeridos, trabajos participantes y alarmas automáticas opcionales.",
                dispatchPois = "Almacena estaciones y ubicaciones comunes para formularios de incidentes y anuncios de estaciones basados ​​en la posición.",
                dispatchStatusCodes = "Configura las etiquetas de estado de FMS y qué estados cuentan como disponibles para nuevos incidentes.",
                dispatchVehicleTypes = "Define las categorías de unidades utilizadas por los planes de respuesta, como Patrulla, Unidad contra el crimen, EMS o Rescate.",
                dispatchVehicles = "Define vehículos de despacho virtuales que pueden contar con personal desde cualquier lugar sin necesidad de un vehículo generado.",
            },
            diagnosticsSettings = {
                enabledLabel = "Activar diagnóstico de vehículos",
                enabledDescription = "Permite que este trabajo abra el diagnóstico de vehículos y repare piezas desde él.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnóstico de vehículos",
                    description = "Configura el acceso de este trabajo al diagnóstico de vehículos.",
                },
                dispatchReporters = "Alertantes conocidos",
                invalidSelection = "Selección no válida: {value}",
                billingPrices = {
                    description = "Configure los precios de las facturas para las entradas del historial de mantenimiento y reparación. La clave de acción se compara con action_key, action_type, o la etiqueta de trabajo.",
                    label = "Razones de facturación",
                },
                billingSettings = {
                    description = "Configure el comportamiento de facturación mecánica para esta profesión.",
                    label = "Facturación",
                },
                dispatchChannels = "Canales de radio",
                dispatchKeywords = "Palabras clave y planes de respuesta",
                dispatchPois = "Enviar POIs",
                dispatchSettings = {
                    description = "Configure el acceso de despacho, la entrada de emergencia y el canal de radio predeterminado.",
                    label = "Ajustes de envío",
                },
                dispatchStatusCodes = "Códigos de estado",
                dispatchVehicleTypes = "Tipos de vehículos de despacho",
                dispatchVehicles = "Expedición de datos de flota",
                emptyDescription = "Utilice el botón Agregar de arriba para crear la primera entrada.",
                emptyTitle = "Aún no hay nada configurado",
                partsDeliveryShop = "Tienda de entrega de piezas",
                trainingSettings = {
                    description = "Configure el acceso a la capacitación, la inscripción, las aprobaciones y la planificación de cursos para este trabajo.",
                    label = "Configuración de entrenamiento",
                },
                tuningCostProfile = {
                    description = "Configura costes de rendimiento, estetica, ruedas y opciones especiales para este job.",
                    label = "Precios de tuning",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Cámara libre en el menú de tuning",
                    description = "Permite ocultar el cursor con Espacio para mover la cámara libremente. Escape sigue cerrando el menú.",
                },
                tuningCamera = {
                    description = "Enfoca automáticamente la pieza seleccionada. Al desactivarla, se mantiene la cámara normal del juego.",
                    label = "Cámara automática de tuning",
                },
                jgMileage = {
                    description = "Usar JG Vehicle Mileage mientras su recurso esté activo. En caso contrario, usar el kilometraje de Sky. JG HUD se configura por separado.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Mostrar el kilometraje seleccionado en JG HUD. Funciona sin JG Vehicle Mileage; instala el adaptador del HUD según el README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Activa el editor de administración y sus reglas automáticas por matrícula y modelo. Tras desactivarlo, vuelve a sacar del garaje los vehículos afectados para restablecer los valores ya aplicados.",
                    label = "Editor de conducción",
                },
                kuv = {
                    description = "Iniciar inspección técnica",
                    label = "Inspección técnica del vehículo",
                },
                mobileDyno = {
                    description = "Activa el dinamómetro móvil, las pantallas de control y resultados, el controlador de ventiladores y la tableta.",
                    label = "Dinamómetro móvil",
                },
                vehicleRegistration = {
                    description = "Matricular / cambiar titular",
                    label = "Matriculación",
                },
                antiLag = {
                    description = "Activar la instalación anti-lag y los efectos de escape.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Activar el calor de los frenos escenificados, discos brillantes, chispas críticas y el freno corto se desvanecen.",
                    label = "Sobrecalentamiento del freno",
                },
                carryItems = {
                    description = "Requiere transportar piezas entregadas por el taller.",
                    label = "Manipulacion fisica de piezas",
                },
                customHandling = {
                    description = "Activar la transmisión personalizada y el manejo de ajuste.",
                    label = "Manejo personalizado",
                },
                electronicTuning = {
                    description = "Activar las opciones de afinación de iluminación y asistencia al conductor persistentes ECU.",
                    label = "Afinación electrónica",
                },
                instantTuning = {
                    description = "Permitir sintonización directa en ubicaciones de sintonización pública configuradas.",
                    label = "Ajuste instantáneo",
                },
                mileageHud = {
                    description = "Muestra informacion de kilometraje al conducir.",
                    label = "HUD de kilometraje",
                },
                nitro = {
                    description = "Activar la instalación de nitro y el uso del vehículo.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Activa pedidos de piezas del taller y zonas de entrega.",
                    label = "Entrega de piezas",
                },
                selfServiceOrderNotifications = {
                    description = "Notificar a los empleados de servicio cuando se cree una orden de afinación de autoservicio.",
                    label = "Notificaciones de pedidos de autoservicio",
                },
                stance = {
                    description = "Mostrar ajustes de Stance en todos los menús de ajuste y habilitar el elemento Stance Kit.",
                    label = "Postura",
                },
                stanceWheelSize = {
                    description = "Mostrar, guardar y aplicar ajustes de tamaño de rueda en Stance.",
                    label = "Tamaño de la rueda de resistencia",
                },
                stanceWheelWidth = {
                    description = "Mostrar, guardar y aplicar ajustes de ancho de rueda en Stance.",
                    label = "Ancho de la rueda de resistencia",
                },
                subscriptions = {
                    description = "Activar terminales de suscripción de talleres, gestión y descuentos de clientes.",
                    label = "Suscripciones a talleres",
                },
                twoStep = {
                    description = "Activar el control de lanzamiento en dos pasos y los efectos de escape.",
                    label = "Dos pasos",
                },
                vehicleMaintenanceNotifications = {
                    description = "Notificar a los propietarios cuando su vehículo alcance el umbral de mantenimiento configurado.",
                    label = "Notificaciones de mantenimiento de vehículos",
                },
                wheelDamage = {
                    description = "Activa dano realista de ruedas y reparaciones.",
                    label = "Dano de ruedas",
                },
                workshopLift = {
                    description = "Activa puntos de elevador utilizables en talleres.",
                    label = "Elevador de taller",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Coloca el punto en la zona de inspección del taller. El vehículo debe estar dentro de la distancia de inspección configurada para la revisión técnica y la matriculación.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Posición del monitor de resultados.",
                    label = "Monitor de resultados",
                },
                mobile_dyno_station = {
                    description = "Posición del dinamómetro móvil.",
                    label = "Estación de dinamómetro móvil",
                },
                vehicle_registry = "Punto de inspección y matriculación",
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Para mostrar este trabajo en la aplicación de emergencias, el despacho debe estar activado. Actívalo o desactiva «Mostrar en la aplicación de emergencias» en los ajustes de despacho.",
                dispatchJobNotCovered = "Ningún centro de despacho activo cubre el trabajo «{job}». En sky_jobs_base/config/config.lua, añade «{job}» a coveredJobs en el perfil correspondiente de Config.Dispatch.centers y reinicia sky_jobs_base. Restablecer los ajustes no modifica esta asignación.",
                invalidDispatchChannels = "Los ID de canal deben ser únicos y cada canal necesita una etiqueta válida.",
                invalidDispatchDefaultChannel = "El canal de radio predeterminado no existe. En los ajustes de despacho, selecciona un canal existente o «Ninguno».",
                invalidDispatchKeywords = "Los planes de respuesta deben tener códigos únicos y requisitos TIPO:CANTIDAD válidos.",
                invalidDispatchPois = "Los ID, nombres y coordenadas de los puntos de interés deben ser válidos y únicos.",
                invalidDispatchRadioButtons = "Revisa los botones de función de la radio: usa cada botón admitido una sola vez y selecciona una acción de su lista.",
                invalidDispatchRadioFmsKeys = "Revisa las teclas FMS de la radio: usa cada tecla (0-9, * o #) una sola vez y asigna un código de estado existente o déjala sin asignar.",
                invalidDispatchReadyStatus = "En los ajustes de despacho, selecciona un código de disponibilidad marcado como disponible en la lista de códigos de estado.",
                invalidDispatchReporters = "Los datos de alertantes conocidos superan el número de entradas o la longitud permitidos.",
                invalidDispatchRespondingStatus = "En los ajustes de despacho, selecciona un código de salida a un incidente marcado como no disponible en la lista de códigos de estado.",
                invalidDispatchSettings = "Selecciona un estado disponible existente, un estado de respuesta no disponible y un canal predeterminado válido.",
                invalidDispatchStatusCodes = "Los códigos FMS deben ser únicos y al menos un estado debe estar disponible.",
                invalidDispatchVehicleTypes = "Los códigos de tipo de unidad deben ser únicos y estar completos.",
                invalidDispatchVehicles = "Los ID e indicativos de unidad deben ser únicos y todas las referencias de tipo y estación deben existir.",
            },
            settingGroups = {
                diagnostics = {
                    label = "Diagnóstico",
                },
                keybinds = {
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                    label = "Teclas",
                },
                safety = {
                    label = "Validación y seguridad",
                },
                antiExploit = {
                    label = "Antiexploit",
                },
                coach = {
                    label = "Entrenador de telemetría",
                },
                cooldownMultipliers = {
                    label = "Multiplicadores de enfriamiento",
                },
                crashFalloff = {
                    label = "Caída de choque",
                },
                criticalEngine = {
                    label = "Motor roto",
                },
                deformation = {
                    label = "Deformación",
                },
                fade = {
                    label = "Pérdida de eficacia de los frenos",
                },
                features = {
                    label = "Funciones",
                },
                format = {
                    label = "Formato",
                },
                frontalImpact = {
                    label = "Impacto frontal severo",
                },
                general = {
                    label = "Generales",
                },
                heatMultipliers = {
                    label = "Multiplicadores de calentamiento",
                },
                illegalMarket = {
                    label = "Mercado ilegal",
                },
                integration = {
                    label = "Integración",
                },
                items = {
                    label = "Objetos",
                },
                lifetime = {
                    label = "Vida útil",
                },
                limits = {
                    label = "Límites de almacenamiento",
                },
                repairRestore = {
                    label = "Restauración de reparación",
                },
                risk = {
                    label = "Riesgo",
                },
                rules = {
                    label = "Reglas",
                },
                stages = {
                    label = "Etapas de sobrecalentamiento",
                },
                tyreRepair = {
                    label = "Reparación de neumáticos",
                },
                visuals = {
                    label = "Efectos visuales",
                },
            },
            settingSections = {
                electronicTuning = "Software del motor ECU",
                handlingEditor = "Editor de manejo",
                mobileDyno = "Dinamómetro móvil",
                vehicleRegistry = "Documentos del vehículo",
                advancedPricing = "Precios avanzados",
                brakeOverheating = "Sobrecalentamiento del freno",
                carryItems = "Artículos de transporte",
                fakePlates = "Placas falsas",
                firejobVehicleFires = "Incendios de vehículos",
                general = "Generales",
                instantTuning = "Ajuste instantáneo",
                maintenanceNotifications = "Notificaciones de mantenimiento",
                mileageHud = "HUD de kilometraje",
                oilLeaks = "Fugas de fluidos para vehículos",
                partsTheft = "Robo de piezas",
                subscriptions = "Suscripciones",
                tuning = "Sintonización",
                vehicleCare = "Cuidado de vehículos",
                wear = "Desgaste",
                wheelDamage = "Dano de ruedas",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Adicional",
                handlingAir = "Aire",
                handlingGeneral = "Generales",
                handlingRoad = "Tierra",
                handlingWater = "Agua",
            },
            settingSubsections = {
                mechanicHotkeys = "Teclas",
                database = "Base de datos",
                handlingEditorGeneral = "Ajustes del editor",
                handlingMaximumCBikeHandlingData = "Motocicleta",
                handlingMaximumCBoatHandlingData = "Barco",
                handlingMaximumCCarHandlingData = "Coche",
                handlingMaximumCFlyingHandlingData = "Aeronave",
                handlingMaximumCHandlingData = "Base del vehículo",
                handlingMaximumCSeaPlaneHandlingData = "Hidroavión",
                handlingMaximumCSpecialFlightHandlingData = "Vuelo especial",
                handlingMaximumCSubmarineHandlingData = "Submarino",
                handlingMaximumCTrailerHandlingData = "Remolque",
                handlingMaximumCVehicleWeaponHandlingData = "Armas del vehículo",
                keybinds = "Teclas",
                operation = "Operación",
                placementRules = "Reglas de colocación",
                testFlow = "Flujo de prueba",
                tuning = "Opciones de modificación instantánea",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Reparación del vehículo",
                    description = "Ofrecer reparaciones en los puntos de tuning instantáneo.",
                },
                instantTuningRepairPrice = {
                    label = "Precio de reparación",
                    description = "Precio fijo de reparación sin el multiplicador de tuning.",
                },
                instantTuningWashEnabled = {
                    label = "Lavado del vehículo",
                    description = "Ofrecer lavados en los puntos de tuning instantáneo.",
                },
                instantTuningWashPrice = {
                    label = "Precio de lavado",
                    description = "Precio fijo del lavado sin el multiplicador de tuning.",
                },
                vehiclePriceSource = {
                    label = "Origen de los precios de vehículos",
                    description = "Automático: SQL en ESX; catálogo de vehículos en QBCore/Qbox. Base de datos: tabla SQL configurada en cualquier framework.",
                    options = {
                        auto = "Automático (framework)",
                        database = "Base de datos",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabla de precios de vehículos",
                    description = "Tabla con los precios de compra, por ejemplo dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Columna del nombre de spawn",
                    description = "Columna de nombres de spawn, por ejemplo spawn_code (JG), no del nombre mostrado.",
                },
                vehiclePricePriceColumn = {
                    label = "Columna del precio",
                    description = "Columna de precios de compra numéricos, por ejemplo price.",
                },
                vehiclePriceHashColumn = {
                    label = "Columna del hash del modelo (opcional)",
                    description = "Columna opcional de hashes numéricos, por ejemplo hashkey (JG). Déjala vacía para calcular los hashes de los nombres de spawn.",
                },
                handlingEditorFieldMaximum = {
                    description = "Máximo estricto que acepta el editor para este campo de manejo.",
                },
                handlingEditorFocusKey = {
                    label = "Volver al editor de manejo",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Bytes codificados a partir de los cuales una solicitud, respuesta o instantánea del editor se notifica como grande.",
                    label = "Umbral de carga grande",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mide las operaciones del editor y avisa mediante Sky.Debug cuando se superan los límites configurados.",
                    label = "Comprobaciones de rendimiento",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Milisegundos entre resúmenes de rendimiento agregados con la depuración detallada activada.",
                    label = "Intervalo del resumen",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Milisegundos a partir de los cuales una operación del editor se notifica como lenta.",
                    label = "Umbral de operación lenta",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Porcentaje máximo que un control numérico puede alejarse por encima o por debajo de la base del vehículo leída. La entrada directa y la importación XML siguen siendo sin pérdidas. Un máximo del campo distinto del predeterminado sustituye el límite superior del control.",
                    label = "Desviación máxima del control",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Robo de catalizador · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Robo de catalizador · X",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl172 = {
                    label = "Banco de pruebas · UP",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl173 = {
                    label = "Banco de pruebas · DOWN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl174 = {
                    label = "Banco de pruebas · LEFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl175 = {
                    label = "Banco de pruebas · RIGHT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl177 = {
                    label = "Banco de pruebas · BACK",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl38 = {
                    label = "Banco de pruebas · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl45 = {
                    label = "Banco de pruebas · R",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicDynoControl47 = {
                    label = "Banco de pruebas · G",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Pintura · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Pintura · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Cuidado del vehículo · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Cuidado del vehículo · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Empujar vehículo · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Empujar vehículo · S",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Empujar vehículo · A",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Empujar vehículo · D",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Empujar vehículo · W",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Empujar vehículo · LSHIFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Cambio de rueda · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Cambio de rueda · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Cambio de rueda · SPACE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Robo de rueda · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Robo de rueda · X",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                mobileDynoConsumeItem = {
                    description = "Retirar un objeto después de colocarlo correctamente.",
                    label = "Consumir objeto",
                },
                mobileDynoCooldownMs = {
                    label = "Duración de enfriamiento",
                },
                mobileDynoCountdownMs = {
                    label = "Cuenta atrás inicial",
                },
                mobileDynoDuiDistance = {
                    label = "Distancia de renderizado",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Distancia del controlador de ventiladores",
                    description = "Distancia en metros para utilizar el interruptor físico entre los ventiladores de refrigeración.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Duración a plena carga",
                    description = "Millisegundos pasados a plena carga sostenida en perfiles que incluyen una etapa de carga completa.",
                },
                mobileDynoHistoryLimit = {
                    label = "Límite del historial",
                },
                mobileDynoInteractionDistance = {
                    label = "Distancia de interacción",
                },
                mobileDynoItemUseEnabled = {
                    description = "Permitir colocar el banco y el monitor usando objetos.",
                    label = "Colocar con objetos",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Límite de sesiones activas",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Distancia de captura del vehículo",
                },
                mobileDynoMonitorItem = {
                    description = "Objeto del inventario para colocar el monitor.",
                    label = "Objeto del monitor",
                },
                mobileDynoPersistItems = {
                    description = "Conservar las nuevas colocaciones tras reiniciar el servidor.",
                    label = "Guardar posiciones",
                },
                mobileDynoPickupDistance = {
                    description = "Distancia máxima en metros para recoger el equipo.",
                    label = "Distancia de recogida",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Variación máxima de altura",
                    description = "Máxima variación de altura del suelo en metros aceptada en todas las sondas de huella de dinamo.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Pendiente máxima de colocación",
                    description = "La pendiente máxima del suelo en grados aceptados a través de la huella de dinamo.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Los mecánicos deben estar de servicio para colocar y utilizar el equipo.",
                    label = "Exigir servicio",
                },
                mobileDynoResultDuiDistance = {
                    label = "Distancia de la pantalla de resultados",
                    description = "Distancia máxima en metros a la que se representa el monitor de resultado separado.",
                },
                mobileDynoReturnItem = {
                    description = "Devolver el objeto consumido al recoger el equipo.",
                    label = "Devolver objeto",
                },
                mobileDynoStationItem = {
                    description = "Objeto del inventario para colocar el banco.",
                    label = "Objeto del banco",
                },
                mobileDynoTabletDistance = {
                    description = "Distancia máxima del banco en metros para controlar y mantener pruebas desde la tableta.",
                    label = "Alcance de la tableta",
                },
                nitroActivationKey = {
                    label = "Mantener nitro",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                registryBikeChecks = {
                    description = "Puntos de inspección de motos",
                    label = "Puntos de inspección de motos",
                },
                registryCarChecks = {
                    description = "Puntos de inspección de coches",
                    label = "Puntos de inspección de coches",
                },
                registryDistance = {
                    description = "Distancia de servicio (metros)",
                    label = "Distancia de servicio (metros)",
                },
                registryKuvFee = {
                    description = "Tarifa Inspección técnica del vehículo",
                    label = "Tarifa Inspección técnica del vehículo",
                },
                registryKuvValidityDays = {
                    description = "Validez de nuevas inspecciones en tiempo real. Predeterminado: 30 días. Se conservan las fechas de vencimiento existentes.",
                    label = "Validez de inspección (días reales)",
                },
                registryKuvWarningDays = {
                    description = "Aviso previo (días)",
                    label = "Aviso previo (días)",
                },
                registryRegistrationFee = {
                    description = "Tarifa de matriculación",
                    label = "Tarifa de matriculación",
                },
                registryReinspectionFee = {
                    description = "Tarifa de reinspección",
                    label = "Tarifa de reinspección",
                },
                registryRequireKuv = {
                    description = "Exigir Inspección técnica del vehículo válida para matricular",
                    label = "Exigir Inspección técnica del vehículo válida para matricular",
                },
                registrySessionSeconds = {
                    description = "Plazo de confirmación (segundos)",
                    label = "Plazo de confirmación (segundos)",
                },
                registryTransferFee = {
                    description = "Tarifa de cambio de titular",
                    label = "Tarifa de cambio de titular",
                },
                registryVehicleTypes = {
                    description = "Tipos de vehículo permitidos",
                    label = "Tipos de vehículo permitidos",
                },
                tuningFocusKey = {
                    label = "Interacción con ratón del tuning",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                addRevenueToSociety = {
                    description = "Depósito pagado orden de ajuste dinero en la cuenta de la sociedad de la profesión de ajuste.",
                    label = "Depositar ingresos a la sociedad",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Las categorías de tiendas de entrega de piezas que permanecen libremente disponibles mientras que los precios avanzados están habilitados.",
                    itemLabel = "Categoría",
                    label = "Categorías siempre disponibles",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Mantenga los artículos configurados de la tienda de las categorías seleccionadas disponibles sin un orden de ajuste y el precio de ellos a través del sistema de proveedores dinámico.",
                    label = "Artículos de la tienda siempre disponibles",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Número de días mostrados en el análisis del beneficio de la tableta.",
                    label = "Período de análisis",
                },
                advancedPricingCategoryRules = {
                    description = "Participación del proveedor, margen, mano de obra y límites de precios por categoría de ajuste.",
                    label = "Normas de categoría",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Margen mecánico predeterminado antes de los ajustes de clase y grado.",
                    label = "Margen predeterminado",
                },
                advancedPricingDifficultyRules = {
                    description = "Coste adicional de mano de obra por cada dificultad de ajuste.",
                    label = "Reglas de dificultad",
                },
                advancedPricingEnabled = {
                    description = "Recalcular los precios de afinación en el servidor y, cuando la entrega de piezas está habilitada, requieren piezas de Dinastía que se compran para su orden de afinamiento específica.",
                    label = "Activar precios avanzados",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Stock virtual normal para cada artículo del proveedor.",
                    label = "Existencias básicas",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Puntos de demanda eliminados por día transcurrido.",
                    label = "Decaimiento diario de la demanda",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "El marcado del proveedor se agregó para cada punto de demanda.",
                    label = "Valorización de la demanda por unidad",
                },
                advancedPricingInventoryEnabled = {
                    description = "Elevar los precios de los proveedores cuando el stock virtual es bajo o la demanda es alta.",
                    label = "Existencias dinámicas de proveedores",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Máximo margen de beneficio del proveedor causado por las bajas existencias.",
                    label = "Marcado bajo en stock",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Nivel de stock por debajo del cual comienzan los precios de escasez.",
                    label = "Umbral de bajas existencias",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Límite superior para el marcado de demanda.",
                    label = "Máximo margen de demanda",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Unidades virtuales reabastecidas por día transcurrido.",
                    label = "Reabastecimiento diario",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Límite máximo de descuento global para facturas mecánicas.",
                    label = "Descuento máximo",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Máximo margen mecánico permitido.",
                    label = "Margen máximo",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Límite de precio superior global para una pieza de ajuste.",
                    label = "Precio máximo al por menor",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Marcado, mano de obra y límites de descuento por grado mecánico.",
                    label = "Normas de calificación mecánica",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Margen mecánico más bajo permitido.",
                    label = "Margen mínimo",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Límite mundial de precios más bajos para una parte de ajuste.",
                    label = "Precio mínimo al por menor",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Valor del vehículo utilizado para el ejemplo compacto.",
                    label = "Valor de vista previa compacto",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Ejemplo de porcentaje de costo de ajuste utilizado por la vista previa en vivo.",
                    label = "Previsualización de la tasa de ajuste",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Valor del vehículo utilizado para el ejemplo deportivo.",
                    label = "Valor de vista previa de deportes",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Valor del vehículo utilizado para el ejemplo de supercoche.",
                    label = "Super valor de vista previa",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minutos antes de que se vuelva a calcular una cotización de precio no pagada.",
                    label = "Cita vida útil",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Porcentaje reembolsado por una parte adquirida sujeta al pedido.",
                    label = "Reembolso de la devolución",
                },
                advancedPricingRoundingStep = {
                    description = "Redondea cada línea de adquisiciones de la dinastía a este paso de dinero.",
                    label = "Paso de redondeo del proveedor",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Porcentaje del precio de la parte del cliente cobrado por Dynasty Auto Supply.",
                    label = "Parte del proveedor",
                },
                advancedPricingTaxPercent = {
                    description = "Porcentaje fiscal almacenado por separado en la contabilidad de precios.",
                    label = "Impuestos",
                },
                advancedPricingVehicleClassRules = {
                    description = "Ajustes de margen y mano de obra por GTA clase de vehículo.",
                    label = "Normas de clase del vehículo",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Multiplicadores de actualización de freno de enfriamiento",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Multiplicadores de refrigeración de clase de vehículo",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Retraso en milisegundos después de frenar antes de que comience el enfriamiento activo.",
                    label = "Retraso en la refrigeración",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Calor retirado por segundo mientras el freno no está siendo utilizado.",
                    label = "Ritmo de enfriamiento",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Nivel de calor en el que chispas y freno corto se desvanecen puede comenzar.",
                    label = "Umbral crítico",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Oportunidad de 0 a 1 para un corte de freno corto mientras frena a fuego crítico.",
                    label = "Oportunidad perdida por segundo",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Refrigeración de humo",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Duración máxima de desvanecimiento",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Duración mínima de desvanecimiento",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Multiplicadores de calor de actualización de frenos",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Multiplicadores de calor de clase de vehículo",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Se obtiene calor de base por segundo al frenar a la velocidad de referencia.",
                    label = "Aumento de calor",
                },
                brakeOverheatingHotThreshold = {
                    label = "Umbral caliente",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Velocidad mínima del vehículo en km/h antes de que el frenado genere calor.",
                    label = "Velocidad mínima de frenado",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Velocidad en km/h a la que se aplica la ganancia de calor de base configurada.",
                    label = "Velocidad de referencia",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Intervalo máximo de chispas",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Intervalo mínimo de chispas",
                },
                brakeOverheatingVisualDistance = {
                    description = "Distancia máxima en metros para el brillo y la representación de chispas.",
                    label = "Distancia visual",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Umbral tibio",
                },
                carryItems = {
                    description = "Piezas entregadas que deben convertirse en accesorios físicos transportados.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Elevador del motor",
                                forklift = "Montacargas",
                                hand = "Mano",
                            },
                        },
                    },
                    itemLabel = "Artículos de transporte",
                    label = "Artículos de transporte",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 no añade potencia; 1,10 aumenta el par un 10 %. Se aplica a los vehículos con esta etapa de ECU.",
                    label = "Multiplicador de par de la etapa 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 no añade potencia; 1,10 aumenta el par un 10 %. Se aplica a los vehículos con esta etapa de ECU.",
                    label = "Multiplicador de par de la etapa 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 no añade potencia; 1,10 aumenta el par un 10 %. Se aplica a los vehículos con esta etapa de ECU.",
                    label = "Multiplicador de par de la etapa 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 no añade potencia; 1,10 aumenta el par un 10 %. Se aplica a los vehículos con esta etapa de ECU.",
                    label = "Multiplicador de par de la etapa 4",
                },
                fakePlatesAudit = {
                    label = "Registro de auditoría",
                },
                fakePlatesBlacklist = {
                    description = "Palabras o fragmentos bloqueados que no pueden aparecer en placas falsas.",
                    label = "Lista negra",
                },
                fakePlatesBlankPlateItem = {
                    description = "Material de artesanía/tienda utilizado para los bucles de economía de placas falsas.",
                    label = "Artículo de la placa en blanco",
                },
                fakePlatesCooldownMinutes = {
                    label = "Minutos de enfriamiento",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Oportunidad de caída",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Fallo de choque activado",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Velocidad mínima de choque",
                },
                fakePlatesEnabled = {
                    description = "Permite a los jugadores utilizar kits de placas falsas en los vehículos.",
                    label = "Activar placas falsas",
                },
                fakePlatesExpireMinutes = {
                    description = "0 mantiene las placas falsas activas hasta que la manipulación de reinicio o reinicio las elimine.",
                    label = "Expirar minutos",
                },
                fakePlatesExpireOnRestart = {
                    label = "Expirar al reiniciar",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Cuenta de pago",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Acceso al mercado ilegal",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Precio de mercado ilegal",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Multiplicador de riesgo",
                },
                fakePlatesInstallDurationMs = {
                    label = "Duración de instalación ms",
                },
                fakePlatesItem = {
                    description = "Elemento de un solo uso que inicia el flujo de instalación de placa falsa.",
                    label = "Juego falso de la placa",
                },
                fakePlatesMaxLength = {
                    label = "Longitud máxima",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Distancia al vehículo",
                },
                fakePlatesMinLength = {
                    label = "Longitud mínima",
                },
                fakePlatesPattern = {
                    description = "Patrón de lua utilizado para validar texto falso de la placa, por ejemplo ^[A-Z0-9]+$.",
                    label = "Patrón de lua",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Distancia de la posición de la placa",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Bloquear las placas falsas activas duplicadas",
                },
                fakePlatesPrinterItem = {
                    description = "Herramienta de artesanía/tienda utilizada para los bucles de economía de placas falsas.",
                    label = "Elemento de impresora de placa",
                },
                fakePlatesRequireEngineOff = {
                    label = "El motor debe estar apagado",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Utilice Config.Functions.CanApplyFakePlate antes de permitir la instalación.",
                    label = "Requerir propietario o llaves",
                },
                fakePlatesRequireStopped = {
                    label = "Debe detenerse el vehículo",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Reservado para integraciones de garaje que llaman al evento de reinicio/exportación.",
                    label = "Reiniciar en la tienda de garaje",
                },
                fakePlatesRiskCharacters = {
                    label = "Caracteres tipográficos",
                },
                fakePlatesRiskEnabled = {
                    label = "Errores de riesgo activados",
                },
                fakePlatesRiskTypoChance = {
                    label = "Probabilidad de error tipográfico",
                },
                fallbackVehicleValue = {
                    description = "Valor utilizado cuando no se puede resolver el precio del vehículo.",
                    label = "Valor del vehículo de retroceso",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Oportunidad de 0 a 1 después de que el motor sigue siendo crítico.",
                    label = "Posibilidad crítica de incendio del motor",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Segundos antes de que pueda disparar otro motor roto.",
                    label = "Refrigeración crítica del motor",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Retraso en milisegundos antes de que un motor roto pueda encenderse.",
                    label = "Retardo crítico del motor ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Permitir que los motores gravemente dañados para iniciar un incendio vehículo Firejob después de un retraso.",
                    label = "Motores rotos de encendido",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Densidad de humo utilizada para solicitudes de incendio de motores rotos.",
                    label = "Densidad crítica del humo del motor",
                },
                firejobVehicleFiresEnabled = {
                    description = "Permitir que los sistemas de daños de trabajo mecánico para solicitar incendios de vehículos de Firejob.",
                    label = "Activar incendios de vehículos Firejob",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Relación de movimiento hacia delante requerida de 0 a 1.",
                    label = "Relación de movimiento hacia adelante",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Oportunidad de 0 a 1 de que un impacto clasificatorio inicie un incendio.",
                    label = "Posibilidades de incendio de impacto",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Segundos antes de que otro fuego de impacto pueda disparar.",
                    label = "Refrigeración del fuego de impacto",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Permitir accidentes frontales fuertes para solicitar un incendio vehículo Firejob.",
                    label = "Encender después de accidentes graves",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Densidad de humo utilizada para solicitudes de incendio desencadenadas por choque.",
                    label = "Densidad de humo de impacto",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automático utiliza el recurso configurado Firejob; Disabled impide Mechanicjob de crear incendios.",
                    label = "Modo de integración",
                    options = {
                        automatic = "Automática",
                        disabled = "Desactivado",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Salud corporal mínima perdida durante el impacto.",
                    label = "Daño corporal mínimo",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "La salud mínima del motor se perdió durante el impacto.",
                    label = "Daño mínimo del motor",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Utilice 0 para desactivar esta comprobación de deformación.",
                    label = "Deformación delantera mínima",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Velocidad mínima previa al impacto en km/h.",
                    label = "Velocidad mínima de impacto",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Pérdida de velocidad requerida en km/h durante el impacto.",
                    label = "Pérdida mínima de velocidad",
                },
                firejobVehicleFiresResource = {
                    description = "Recurso que recibe solicitudes de incendio de vehículos.",
                    label = "Recursos de fuegos artificiales",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Evento de servidor interno utilizado por el cliente mecánico para solicitar un incendio vehículo Firejob.",
                    label = "Evento del servidor mecánico",
                },
                freeVehicles = {
                    description = "Modelos de desove de vehículos que reciben órdenes de afinación gratuita.",
                    itemLabel = "Modelo del vehículo",
                    label = "Vehículos de afinación gratuitos",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Prevenir Aplicar mientras exista un conflicto de manejo crítico.",
                    label = "Bloquear los hallazgos críticos",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Deceleración máxima esperada en m/s2 para un ensayo de frenado completado.",
                    label = "Deceleración mínima del freno",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Se requieren muestras medidas antes de que Telemetry Coach evalúe una carrera.",
                    label = "Muestras mínimas",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Velocidad de giro de la rueda medida en km/h a la que se informa de pérdida de tracción.",
                    label = "Aviso de deslizamiento de la rueda",
                },
                handlingEditorDefaultTab = {
                    description = "Página seleccionada cuando se abre el Editor de Manejo independiente.",
                    label = "Página de inicio",
                    options = {
                        advanced = "Avanzado",
                        export = "Exportar",
                        flags = "Banderas",
                        fleet = "Flota",
                        inspector = "Capas",
                        profiles = "Perfiles",
                        simple = "Sencillo",
                        telemetry = "Telemetría",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Proporcionar efecto, rango de referencia, síntomas, campos relacionados y soporte en vivo para cada valor de manipulación.",
                    label = "Documentación sobre el terreno",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Buscar y filtrar nombres de bandera, efectos, posiciones de bits y máscaras hexadecimales.",
                    label = "Búsqueda de banderas",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Buscar, inspeccionar, promover y restaurar el modelo y las reglas de manejo de placas.",
                    label = "Administrador de flotas",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Mostrar la base del vehículo, ajuste personalizado instalado, regla del modelo, regla de la placa y borrador actual del editor para cada campo.",
                    label = "Inspector de capa",
                },
                handlingEditorMaxFleetResults = {
                    description = "Reglas máximas de modelo y placa cargadas en Fleet Manager.",
                    label = "Límite del resultado de la flota",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Número máximo de revisiones retenidas para cada perfil.",
                    label = "Revisiones del perfil",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Máximo espacio de trabajo nombrado retenido para cada administrador.",
                    label = "Espacios de trabajo personales",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Cree una revisión auditable cada vez que se actualice o restablezca un perfil compartido.",
                    label = "Versión de perfil",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Crear recomendaciones transparentes basadas en normas a partir de datos medidos de pruebas de carretera.",
                    label = "Entrenador de telemetría",
                },
                handlingEditorValidatorEnabled = {
                    description = "Detectar combinaciones inseguras o contradictorias antes de aplicar la manipulación.",
                    label = "Validador de manejo",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Permitir que los administradores mantengan borradores de editores privados.",
                    label = "Espacios de trabajo personales",
                },
                instantTuningAllowedJobs = {
                    description = "Lista de permitidos global opcional. Déjelo vacío para permitir el acceso a todos, a menos que esté habilitado Solo mecánico.",
                    itemLabel = "Nombre del trabajo",
                    label = "Trabajos permitidos",
                },
                instantTuningBlipColor = {
                    description = "GTA id. de color blip.",
                    label = "Color de Blip",
                },
                instantTuningBlipEnabled = {
                    description = "Mostrar los blips del mapa para ubicaciones de sintonización instantánea.",
                    label = "Blip activado",
                },
                instantTuningBlipName = {
                    description = "Nombre del mapa.",
                    label = "Nombre del marcador",
                },
                instantTuningBlipSprite = {
                    description = "GTA id de sprite blip.",
                    label = "Sprite intermitente",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Utilice la interacción de estilo marcador E incluso cuando esté habilitado el soporte de destino.",
                    label = "Forzar interacción con el marcador",
                },
                instantTuningInteractionDistance = {
                    description = "Distancia predeterminada para el uso de puntos de ajuste instantáneos.",
                    label = "Distancia de interacción",
                },
                instantTuningLabel = {
                    description = "Texto predeterminado mostrado en puntos de sintonización instantánea.",
                    label = "Etiqueta predeterminada",
                },
                instantTuningLocations = {
                    description = "Puntos de ajuste instantáneo. Utilice la distancia 0 para heredar la distancia de interacción predeterminada.",
                    itemLabel = "Ubicaciones",
                    label = "Ubicaciones",
                },
                instantTuningMarkerEnabled = {
                    description = "Dibuja un marcador mundial en ubicaciones de sintonización instantánea.",
                    label = "Marcador activado",
                },
                instantTuningMarkerType = {
                    description = "Tipo de marcador GTA utilizado para ubicaciones de sintonización instantánea.",
                    label = "Tipo de marcador",
                },
                instantTuningMechanicOnly = {
                    description = "Restringir todas las ubicaciones de sintonización instantánea a profesiones mecánicas configuradas.",
                    label = "Mecánico únicamente",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplicador aplicado a los precios de tuning instantáneo.",
                    label = "Multiplicador de precio",
                },
                instantTuningProfile = {
                    description = "Configure qué opciones de sintonización están disponibles en puntos de sintonización instantánea.",
                    label = "Opciones de ajuste instantáneas",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Mínimo minutos antes de que el mismo vehículo pueda activar otro recordatorio de mantenimiento.",
                    label = "Refrigeración de la notificación",
                },
                maintenanceNotificationsEnabled = {
                    description = "Notificar a los propietarios de vehículos cuando una pieza de desgaste alcance el umbral de mantenimiento.",
                    label = "Activado",
                },
                maintenanceNotificationsThreshold = {
                    description = "Porcentaje de desgaste en o por debajo del cual se considera que el mantenimiento es debido.",
                    label = "Umbral de la obligación",
                },
                mileageHudDigits = {
                    description = "Número de dígitos mostrados en el kilometraje HUD.",
                    label = "Dígitos",
                },
                mileageHudPosition = {
                    description = "Arrastre la vista previa del kilometraje HUD a la posición deseada de la pantalla.",
                    label = "Posición",
                },
                oilLeaksCooldownSeconds = {
                    description = "Segundos antes de que se pueda desencadenar otra fuga de impacto.",
                    label = "Refrigeración de impacto",
                },
                oilLeaksEnabled = {
                    description = "Permitir que los vehículos de combustión dañados dejen fluido mientras conducen.",
                    label = "Activar fugas de líquido",
                },
                oilLeaksEngineOilChance = {
                    description = "Posibilidad de fuga normal de 0 a 1.",
                    label = "Oportunidad del aceite del motor",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Posibilidad crítica de fuga de 0 a 1.",
                    label = "Oportunidad crítica del aceite del motor",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Estado del aceite del motor en o por debajo del cual se utiliza la oportunidad crítica.",
                    label = "Umbral crítico de aceite de motor",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Estado del aceite del motor en o por debajo del cual se puede iniciar una fuga.",
                    label = "Umbral de aceite del motor",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Relación de movimiento hacia delante requerida de 0 a 1.",
                    label = "Relación de movimiento hacia adelante",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Permitir impactos frontales severos para iniciar una fuga temporal de fluido del motor.",
                    label = "Pérdidas por impacto frontal",
                },
                oilLeaksImpactChance = {
                    description = "Oportunidad de 0 a 1 de que un impacto clasificatorio inicie una fuga.",
                    label = "Posibilidad de fugas de impacto",
                },
                oilLeaksImpactRadius = {
                    description = "Radio del punto de fluido inicial creado por un impacto.",
                    label = "Radio de derrame de impacto",
                },
                oilLeaksIntervalSeconds = {
                    description = "Segundero mínimo entre los puntos del sendero.",
                    label = "Intervalo de la trayectoria",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Segundos una fuga continúa después de un impacto clasificatorio.",
                    label = "Duración de la fuga de impacto",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Salud corporal mínima perdida durante el impacto.",
                    label = "Daño corporal mínimo",
                },
                oilLeaksMinDistance = {
                    description = "Distancia mínima recorrida entre los puntos de la pista.",
                    label = "Distancia de la pista",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "La salud mínima del motor se perdió durante el impacto.",
                    label = "Daño mínimo del motor",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Deformación frontal requerida. Utilice 0 para desactivar esta comprobación.",
                    label = "Deformación delantera mínima",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Velocidad mínima previa al impacto en km/h.",
                    label = "Velocidad mínima de impacto",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Pérdida de velocidad requerida en km/h durante el impacto.",
                    label = "Pérdida mínima de velocidad",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Velocidad mínima del vehículo en km/h antes de que una fuga de fluido pueda crear un rastro.",
                    label = "Velocidad mínima",
                },
                oilLeaksRadius = {
                    description = "Radio de puntos de rastro de fluidos de vehículos regulares.",
                    label = "Radio de la trayectoria",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Posibilidad de fuga normal de 0 a 1.",
                    label = "Posibilidad de fluido de transmisión",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Posibilidad crítica de fuga de 0 a 1.",
                    label = "Posibilidad de transmisión crítica",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Condición de fluido de transmisión en o por debajo de la cual se usa la oportunidad crítica.",
                    label = "Umbral de transmisión crítico",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Afección del fluido de transmisión en o por debajo de la cual se puede iniciar una fuga.",
                    label = "Umbral de fluido de transmisión",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Clases de vehículos que pueden completar trabajos de pedido dependientes de ascensores sin un ascensor de taller.",
                    itemLabel = "Añadir clase de vehículo",
                    label = "Clases de vehículos de circunvalación de elevación",
                    options = {
                        ["0"] = "Compactos",
                        ["1"] = "Sedans",
                        ["10"] = "Industrial",
                        ["11"] = "Utilidad",
                        ["12"] = "Vans",
                        ["13"] = "Ciclos",
                        ["14"] = "Barcos",
                        ["15"] = "Helicopteros",
                        ["16"] = "Planos",
                        ["17"] = "Servicio",
                        ["18"] = "Emergencia",
                        ["19"] = "Militar",
                        ["2"] = "SUVs",
                        ["20"] = "Comercial",
                        ["21"] = "Trenes",
                        ["22"] = "Rueda abierta",
                        ["3"] = "Coupes",
                        ["4"] = "Músculo",
                        ["5"] = "Clásicos deportivos",
                        ["6"] = "Deportes",
                        ["7"] = "Súper",
                        ["8"] = "Motocicletas",
                        ["9"] = "Todoterreno",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modelos de desove de vehículos que pueden completar trabajos de pedido dependientes de ascensores sin un elevador de taller.",
                    itemLabel = "Modelo del vehículo",
                    label = "Modelos de vehículos de circunvalación de elevación",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millisegundos utilizados para los pasos de instalación de orden que no ejecuten un minijuego.",
                    label = "Duración de instalación sencilla",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "IDs de clase de vehículo que siempre utilizan el mecánico normal instalar sin ascensores especializados o flujos de minijuego.",
                    label = "Clases de vehículos no pertenecientes al minijuego",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modelos de desove de vehículos que utilizan siempre el mecánico normal instalar sin ascensores especializados o flujos de minijuego.",
                    label = "Modelos de vehículos distintos del minijuego",
                },
                partsDeliveryCompanyCard = {
                    description = "Permitir que las órdenes de entrega de piezas utilicen los fondos de la empresa.",
                    label = "Pago con tarjeta de la empresa",
                },
                partsDeliveryMode = {
                    description = "Mantenga el flujo de entrega física estándar o agregue la entrega completa directamente al inventario del jugador que recoge.",
                    label = "Manejo de la entrega",
                    options = {
                        player_inventory = "Inventario de jugadores",
                        standard = "Flujo de entrega estándar",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Milisegundos necesarios para desempacar una entrega de piezas listas.",
                    label = "Duración de apertura",
                },
                partsDeliveryOwnCard = {
                    description = "Permita a los jugadores pagar las órdenes de entrega de piezas con su propio dinero.",
                    label = "Pago con tarjeta propia",
                },
                partsDeliveryTimeSeconds = {
                    description = "Segundos entre el pedido de piezas y la entrega de estar listo.",
                    label = "Plazo de entrega",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Artículo de inventario adjudicado cuando un convertidor catalítico es robado.",
                    label = "Convertidor catalítico",
                },
                partsTheftDealerAccount = {
                    description = "Cuenta utilizada para pagos de distribuidores de piezas robadas, como dinero o banco.",
                    label = "Cuenta de pago del concesionario",
                },
                partsTheftDealerItems = {
                    description = "Los artículos robados el distribuidor comprará y sus valores de pago.",
                    itemLabel = "Artículo del concesionario",
                    label = "Artículos del concesionario",
                },
                partsTheftDealerPayoutItem = {
                    description = "Artículo de inventario dado cuando el tipo de pago del distribuidor es Artículo. El precio de venta se utiliza como la cantidad del artículo.",
                    label = "Elemento de pago del concesionario",
                },
                partsTheftDealerPayoutType = {
                    description = "Elija si el distribuidor paga en una cuenta marco o da un artículo de inventario.",
                    label = "Tipo de pago del concesionario",
                    options = {
                        account = "Cuenta",
                        item = "Objeto",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Distancia máxima del distribuidor para vender piezas robadas.",
                    label = "Distancia de venta del concesionario",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Segundos antes de que la misma parte del vehículo puede crear otro despacho.",
                    label = "Espera del despacho",
                },
                partsTheftDispatchEnabled = {
                    description = "Crear un despacho de policía cuando se roba una rueda o un convertidor catalítico.",
                    label = "Enviar despacho de la policía",
                },
                partsTheftDispatchJobs = {
                    description = "Nombres profesionales que reciben envíos de robo de piezas.",
                    itemLabel = "Nombre del trabajo",
                    label = "Trabajos de despacho",
                },
                partsTheftDispatchMessage = {
                    description = "Mensaje mostrado en la alerta de envío. Soporta {plate}, {part} y {type}.",
                    label = "Mensaje de envío",
                },
                partsTheftDispatchTitle = {
                    description = "Título que aparece en la alerta de envío. {plate}, {part}, y {type}.",
                    label = "Título de envío",
                },
                partsTheftItem = {
                    description = "Artículo de inventario utilizado para robar ruedas y convertidores catalíticos.",
                    label = "Elemento de la herramienta de robo",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Quitar el elemento de la herramienta de robo después de una acción de robo con éxito.",
                    label = "Consumir herramienta de robo",
                },
                partsTheftStolenWheelItem = {
                    description = "Artículo de inventario adjudicado cuando las ruedas son robadas.",
                    label = "Artículo de la rueda robada",
                },
                priceType = {
                    description = "Porcentaje calcula los costos a partir del precio del vehículo.",
                    label = "Tipo de precio",
                    options = {
                        class = "Clase de vehículo",
                        fixed = "Fijo",
                        percentage = "Porcentaje",
                    },
                },
                primaryColor = {
                    description = "Color predeterminado para el grupo de profesión mecánica y nuevas profesiones. Utilice un valor hexadecimal como #EDC001.",
                    label = "color primario",
                },
                publicUsersSeePrices = {
                    description = "Cuando está habilitado, los clientes públicos pagan mientras ordenan. Deshabilite esto para crear pedidos no pagados para facturación mecánica.",
                    label = "Cargar órdenes públicas de autoservicio",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Permitir que los jefes autorizados compren una suscripción para toda su profesión utilizando fondos de la empresa.",
                    label = "Suscripciones a empresas",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Moneda de pago",
                },
                subscriptionsEnabled = {
                    description = "Activar suscripciones a talleres, terminales de clientes y descuentos de suscripción.",
                    label = "Activado",
                },
                subscriptionsMaximumDurations = {
                    description = "Duración máxima y precio por modelo de suscripción.",
                    label = "Duración máxima",
                },
                subscriptionsMaximumModels = {
                    description = "Modelos de suscripción máxima que un taller puede configurar en la tableta.",
                    label = "Modelos máximos",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Clip de animación de bucle opcional utilizado cuando el escenario está vacío.",
                    label = "NPC clip emote",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Diccionario de animación opcional utilizado cuando el escenario está vacío.",
                    label = "Diccionario emote NPC",
                },
                subscriptionsNpcPedModel = {
                    description = "Modelo de Ped generado en terminales de suscripción, por ejemplo s_m_m_autoshop_01.",
                    label = "Modelo de NPC predeterminado",
                },
                subscriptionsNpcScenario = {
                    description = "Escenario opcional GTA como WORLD_HUMAN_CLIPBOARD. Deja vacío para usar la animación emote.",
                    label = "Hipótesis NPC",
                },
                tuningBlockedPlates = {
                    description = "Los vehículos con una de estas placas no pueden ser sintonizados, instalados o eliminados. La coincidencia ignora la carcasa y el espacio en blanco.",
                    itemLabel = "Matrícula",
                    label = "Placas de afinación bloqueadas",
                },
                tuningWorkshopDistance = {
                    description = "Distancia máxima desde un punto de afinación de autoservicio para las acciones de instalación o eliminación requeridas.",
                    label = "Distancia requerida para el taller",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Requerir instalación de orden de ajuste para iniciar y completar cerca de un punto de ajuste de autoservicio.",
                    label = "Requerir taller para instalaciones",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Requiere que las eliminaciones de sintonización comiencen y se completen cerca de un punto de afinación de autoservicio.",
                    label = "Requerir taller para mudanzas",
                },
                vehicleCareRepairDurationMs = {
                    description = "Reparar la duración del progreso en milisegundos.",
                    label = "Duración de la reparación",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "También restablecer el daño realista de la rueda al utilizar la acción de reparación.",
                    label = "Fijar el daño realista de la rueda",
                },
                vehicleCareRepairItem = {
                    description = "Artículo de inventario utilizado por la acción de reparación del vehículo.",
                    label = "Objeto de reparación",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Distancia máxima del vehículo durante la reparación.",
                    label = "Reparar la distancia máxima",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Retire el artículo de reparación después de su uso.",
                    label = "Reparación de consumibles",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Reparación normal GTA daños al vehículo al utilizar la acción de reparación.",
                    label = "Arreglar los daños del vehículo",
                },
                vehicleCareRepairWearParts = {
                    description = "Elija qué piezas de desgaste y servicio restaura el artículo de reparación. Deshabilite los fluidos aquí si el aceite, refrigerante, líquido de freno, o fluido de transmisión debe requerir el flujo de reparación de diagnóstico.",
                    itemLabel = "Parte de desgaste",
                    label = "Reparar piezas restauradas",
                },
                vehicleCareWashItem = {
                    description = "Artículo de inventario utilizado para lavar un vehículo.",
                    label = "Artículo de lavado",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Retire el elemento de lavado después de su uso.",
                    label = "Consumir artículos de lavado",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Distancia un vehículo encerado permanece limpio.",
                    label = "Cera limpia kilómetros",
                },
                vehicleCareWaxItem = {
                    description = "Artículo de inventario utilizado para encerar un vehículo.",
                    label = "Artículo de cera",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Retire el elemento de cera después de su uso.",
                    label = "Consumir cera",
                },
                vehicleClassPricing = {
                    description = "Anule el tipo de precio y el multiplicador de costes por cada clase de vehículo GTA.",
                    label = "Precio de la clase de vehículo",
                },
                wearParts = {
                    description = "Piezas de desgaste del vehículo, su distancia de vida útil, artículo de reparación requerido, consumo de artículos e instalación de flujo.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Convertidor catalítico",
                                fluid_refill = "Relleno de líquidos",
                                hood_install = "Instalación de capó",
                                oil_change = "Cambio de aceite",
                                performance = "Rendimiento",
                                underbody_neon = "Bajo el cuerpo / elevación",
                                wheel = "Rueda",
                            },
                        },
                    },
                    itemLabel = "Parte de desgaste",
                    label = "Partes de desgaste",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Multiplicador de daño de rueda base.",
                    label = "Multiplicador predeterminado",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtra puntos de sonda de deformación que no apuntan de vuelta al cuerpo del vehículo.",
                    label = "Umbral de ángulo de sonda",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Fuerza adicional añadió cada iteración de restauración.",
                    label = "Incremento del daño por deformación",
                },
                wheelDamageDeformationEnabled = {
                    description = "Capturar y restaurar las abolladuras durante la reparación de neumáticos geometría reconstruye.",
                    label = "Restaurar la deformación",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Fuerza de inicio utilizada al restaurar las abolladuras.",
                    label = "Daño por deformación inicial",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Máximo SetVehicleDamage pasa para reconstruir abolladuras.",
                    label = "Iteraciones de deformación",
                },
                wheelDamageDeformationThreshold = {
                    description = "Mínima magnitud de deformación detectada para almacenar.",
                    label = "Umbral de deformación",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplicador utilizado cuando el vehículo tiene ruedas todo terreno.",
                    label = "Multiplicador de rueda todoterreno",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra instantánea non-wheel daño restaurar pases después de la geometría de la rueda se reconstruye.",
                    label = "Reaplicar pases de daños",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Pases instantáneos adicionales para los neumáticos que aún faltan o que están planos después de reparar una rueda.",
                    label = "Reaplicar pases de estado de rueda",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Mantenga cuerpo, motor, ventanas, puertas, suciedad y daños visuales cuando la reparación de neumáticos reconstruye la geometría de la rueda.",
                    label = "Preservar los daños del vehículo",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Restaurar ventanas rotas sin el fuerte efecto de aplastamiento siempre que sea posible.",
                    label = "Ventanas silenciosas rotas",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Volver a aplicar neumáticos fijos sin provocar un nuevo sonido o efecto pop del neumático.",
                    label = "Reaplicación silenciosa de neumáticos planos",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Distancia máxima del neumático dañado o faltante para la acción de montaje.",
                    label = "Distancia de fijación del neumático",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Distancia máxima desde el gato de coche colocado para la acción de eliminación.",
                    label = "El gato del coche quita la distancia",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Multiplicadores de daños por clase de vehículo GTA.",
                    itemLabel = "Clase de vehículo",
                    label = "Multiplicadores de clase del vehículo",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Bloquear otras profesiones si hay mecánicos de servicio",
                },
                allowsprint = {
                    label = "Permitir correr con cajas de reparto",
                },
            },
            tuningCategories = {
                bodywork = "Carrocería",
                electronics = "ECU y electrónica del vehículo",
                engineSounds = "Sonidos del motor",
                handling = "Manejo",
                lights = "Luces",
                other = "Otros",
                paint = "Pintura",
                performance = "Rendimiento",
                stance = "Postura",
                wheels = "Ruedas",
            },
            advancedPricingPreview = {
                compact = "Honda / Compacto",
                customer = "Precio al cliente",
                description = "Ejemplo de cálculo cosmético utilizando las reglas actuales.",
                labor = "Trabajo",
                live = "Vista previa en vivo",
                margin = "Margen",
                sports = "Coche deportivo",
                super = "Supercoche",
                supplier = "Proveedor",
                title = "Vista previa de precios",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configure profesiones mecánicas, tiendas, vehículos y talleres.",
                    title = "Profesiones mecánicas",
                },
            },
            dispatchIconOptions = {
                crime = "Unidad contra el Crimen",
                emergency = "Unidad de Emergencia",
                ems = "Unidad EMS",
                fire = "Unidad de Bomberos",
                heavy = "Unidad Pesada",
                k9 = "Unidad K-9",
                medical = "Unidad Médica",
                patrol = "Patrulla",
                rescue = "Unidad de Rescate",
                service = "Unidad de Servicio",
                supervisor = "Supervisora",
                tactical = "Unidad Táctica",
            },
            fields = {
                quantity = "Cantidad",
            },
            settingFieldDescriptions = {
                radialEnabled = "Abrir facturación mecánica desde el menú radial.",
                allowTuningInvoices = "Envíe la cesta de ajuste al cliente más cercano. La instalación se desbloquea después del pago completo.",
                customerRange = "Distancia máxima en metros para emitir facturas a clientes cercanos.",
                allowAnalytics = "Permitir el análisis de facturación a menos que una regla de calificación lo anula.",
                allowCustomPrices = "Permitir que la mecánica edite los precios de posición de la factura antes de emitir.",
                allowEstimates = "Permitir estimaciones que los clientes deben aceptar antes del pago.",
                allowImmediatePayment = "Permitir que las facturas de esta profesión se paguen directamente.",
                allowManualItems = "Permitir que los mecánicos creen posiciones de factura arbitrarias.",
                allowPartialPayments = "Permitir depósitos y múltiples pagos hacia una factura.",
                analyticsPeriodDays = "Días incluidos en el análisis de facturación.",
                defaultDueDays = "Días hasta que una factura se atrase.",
                depositPercent = "Porcentaje de depósito requerido después de que se emite una factura o se acepta una estimación.",
                enabled = "Permita que esta profesión utilice la facturación mecánica.",
                estimateLifetimeHours = "Horas antes de que expire una estimación sin respuesta.",
                gradeRules = "Límites de facturas y acciones disponibles para cada grado mecánico.",
                maxDiscountPercent = "El descuento más grande puede recibir una factura.",
                maximumInvoiceAmount = "Total máximo global antes de los límites de grado.",
                maximumManualItems = "Máximas posiciones arbitrarias por documento.",
                maximumReminders = "Recordatorios máximos permitidos por factura.",
                minimumInvoiceAmount = "Total mínimo para estimaciones y facturas.",
                minimumPartialPayment = "Pago parcial más pequeño, excluyendo un saldo o depósito más pequeño.",
                reminderFee = "Tasa añadida por cada recordatorio válido.",
                reminderGraceDays = "Días de retraso antes de que se permita el primer recordatorio.",
                taxPercent = "Impuestos añadidos después de descuentos.",
            },
            settingFields = {
                radialEnabled = "Acción radial de la factura",
                allowTuningInvoices = "Clientes de afinación de facturas",
                customerRange = "Distancia del cliente",
                allowAnalytics = "Análisis contable",
                allowCancellation = "Cancelación",
                allowCustomPrices = "Permitir precios personalizados",
                allowEstimates = "Permitir estimaciones",
                allowImmediatePayment = "Permitir el pago inmediato",
                allowManualItems = "Permitir posiciones propias",
                allowPartialPayments = "Permitir pagos parciales",
                allowReminders = "Recordatorios",
                amount = "Cantidad",
                analyticsPeriodDays = "Período de análisis",
                bone = "Hueso",
                category = "Categoría",
                classId = "Clase ID",
                defaultDueDays = "Plazo de pago (días)",
                depositPercent = "Porcentaje de depósitos",
                difficulty = "Dificultad",
                enabled = "Activado",
                estimateLifetimeHours = "Duración estimada (horas)",
                flow = "Instalar flujo",
                grade = "Grado",
                gradeRules = "Normas de calificación",
                item = "Objeto",
                key = "Clave",
                kilometersToZero = "Kilómetros a cero",
                label = "Etiqueta",
                laborFee = "Coste laboral",
                laborMultiplier = "Multiplicador del trabajo",
                marginAdjustmentPercent = "Ajuste del margen",
                marginPercent = "Margen %",
                maxDiscountPercent = "Descuento máximo",
                maximumInvoiceAmount = "Factura máxima",
                maximumManualItems = "Posiciones propias máximas",
                maximumPrice = "Máximo",
                maximumReminders = "Máximo recordatorio",
                minimumInvoiceAmount = "Factura mínima",
                minimumPartialPayment = "Pago parcial mínimo",
                minimumPrice = "Mínimo",
                multiplier = "Multiplicador",
                name = "Nombre del objeto",
                partKey = "Tecla de parte",
                price = "Precio",
                priceType = "Tipo de precio",
                prop = "Objeto",
                reason = "Motivo",
                reminderFee = "Tasa de recordatorio",
                reminderGraceDays = "Período de gracia del recordatorio",
                removeAfterUse = "Consumir objeto",
                repair = "Reparación con kit",
                repairItem = "Objeto de reparación",
                rx = "Rot X",
                ry = "Roto Y",
                rz = "Roto Z",
                supplierSharePercent = "Proveedor %",
                taxPercent = "Impuesto sobre facturas",
                transport = "Transporte",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Mejora",
                maximumDiscountPercent = "Descuento máximo",
            },
            settingValues = {
                air_filter = "Filtro de aire",
                brake_fluid = "Fluido de freno",
                brake_pads = "Almohadillas de freno",
                catalytic_converter = "Convertidor catalítico",
                clutch = "Embrague",
                coolant = "Refrigerante",
                engine_oil = "Aceite de motor",
                inverter = "Inversor de energía",
                spark_plugs = "Bujías de chispa",
                suspension = "Suspensión",
                traction_battery = "Batería de tracción",
                transmission_fluid = "Fluido de transmisión",
                tyres = "Neumáticos",
                vehicleClass_0 = "Compactos",
                vehicleClass_1 = "Sedans",
                vehicleClass_10 = "Industrial",
                vehicleClass_11 = "Utilidad",
                vehicleClass_12 = "Vans",
                vehicleClass_13 = "Ciclos",
                vehicleClass_14 = "Barcos",
                vehicleClass_15 = "Helicopteros",
                vehicleClass_16 = "Planos",
                vehicleClass_17 = "Servicio",
                vehicleClass_18 = "Emergencia",
                vehicleClass_19 = "Militar",
                vehicleClass_2 = "SUVs",
                vehicleClass_20 = "Comercial",
                vehicleClass_21 = "Trenes",
                vehicleClass_22 = "Rueda abierta",
                vehicleClass_3 = "Coupes",
                vehicleClass_4 = "Músculo",
                vehicleClass_5 = "Clásicos deportivos",
                vehicleClass_6 = "Deportes",
                vehicleClass_7 = "Súper",
                vehicleClass_8 = "Motocicletas",
                vehicleClass_9 = "Todoterreno",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Permite a los empleados inscribirse en las sesiones de capacitación disponibles.",
                approvalRequired = "Mantiene pendientes las autoinscripciones hasta que un instructor autorizado las apruebe.",
                defaultCapacity = "Número predeterminado de asientos utilizados cuando se crea una nueva sesión de capacitación.",
                enabled = "Hace que la aplicación de capacitación esté disponible para este trabajo.",
                requireOnDuty = "Requiere que los empleados estén de servicio antes de abrir o utilizar la aplicación de capacitación.",
                upcomingDays = "Número de días futuros que se muestran en el cronograma de la aplicación de capacitación.",
            },
            trainingFields = {
                allowSelfEnrollment = "Permitir la autoinscripción",
                approvalRequired = "Requerir aprobación de inscripción",
                defaultCapacity = "Capacidad predeterminada",
                enabled = "Habilitar entrenamiento",
                requireOnDuty = "Requerir deber",
                upcomingDays = "Próximo período (días)",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Estándar de GTA",
                        [2] = "Pops de calle",
                        [3] = "Raza Anti-Lag",
                        [4] = "Anti-lag de rally",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Riesgos automáticos",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Activado",
                    },
                },
                electronic_brake_lights = {
                    label = "Luces de freno",
                    values = {
                        [0] = "Normal",
                        [1] = "Flash de emergencia",
                        [2] = "Desactivado",
                    },
                },
                electronic_engine_tune = {
                    label = "Software del motor",
                    values = {
                        [0] = "Población",
                        [1] = "Etapa 1",
                        [2] = "Etapa 2",
                        [3] = "Etapa 3",
                        [4] = "Etapa 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Brillo de los faros",
                    values = {
                        [0] = "25%",
                        [1] = "50%",
                        [2] = "75%",
                        [3] = "100%",
                        [4] = "125%",
                        [5] = "150%",
                    },
                },
                electronic_highbeams_on_horn = {
                    label = "Altas vigas en el Cuerno",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Activado",
                    },
                },
                electronic_idle_rpm = {
                    label = "Inactivo RPM",
                    values = {
                        [0] = "Población",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Luz interior",
                    values = {
                        [0] = "Normal",
                        [1] = "Rojo",
                    },
                },
                electronic_mood_color = {
                    label = "Color de luz del humor",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Rojo",
                        [10] = "Lima",
                        [11] = "Turquesa",
                        [12] = "Índigo",
                        [13] = "Blanco",
                        [14] = "Blanco cálido",
                        [15] = "Blanco frío",
                        [16] = "Ámbar",
                        [2] = "Azul",
                        [3] = "Verde",
                        [4] = "Cian",
                        [5] = "Magenta",
                        [6] = "Amarillo",
                        [7] = "Naranja",
                        [8] = "Morado",
                        [9] = "Rosa",
                    },
                },
                electronic_mood_intensity = {
                    label = "Intensidad de la luz del humor",
                    values = {
                        [0] = "Dim",
                        [1] = "Normal",
                        [2] = "Brillante",
                    },
                },
                electronic_radio_power = {
                    label = "Potencia de radio",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Activado",
                    },
                },
                electronic_throttle_response = {
                    label = "Respuesta del acelerador",
                    values = {
                        [0] = "Más tracción",
                        [1] = "Agresivo",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Ajuste para caballitos",
                    values = {
                        [0] = "Desactivado",
                        [1] = "Suave",
                        [2] = "Intenso",
                    },
                },
            },
            vehicleClassLabel = "Clase {id} ({name})",
        },
    },
}
