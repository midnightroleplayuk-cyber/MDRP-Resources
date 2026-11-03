JobConfigLocales["sky_policejob:es"] = {
    JobConfiguratorComingSoon = "Este configurador de trabajo estará disponible próximamente.",
    JobConfiguratorNoPermission = "No tienes permiso para usar este comando.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configurar departamentos de policía, tiendas, props, vehículos, estaciones y ajustes de las funciones principales.",
                    title = "Trabajos Policiales",
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
                autoAlarm = "Asigna inmediatamente unidades disponibles coincidentes cuando se crea un incidente.",
                available = "Las unidades en este estado pueden ser sugeridas y asignadas a un nuevo incidente.",
                averageResponseSpeedKmh = "Calcula la estimación de llegada mostrada a partir de la distancia en línea recta.",
                callsign = "Indicativo de radio único que se muestra cuando los jugadores trabajan en esta unidad virtual.",
                centerEnabled = "Permite que los miembros autorizados en servicio proporcionen personal a un centro de despacho.",
                channelId = "ID de canal de radio para PMA Voice, SaltyChat y YACA. Los identificadores numéricos como 2500 permanecen sin cambios; PMA Voice asigna identificaciones de texto a un número estable.",
                channelLabel = "Nombre de canal legible que se muestra a los despachadores y unidades.",
                crewCapacity = "Número máximo de personas que pueden ocupar la unidad. Usa 0 para una dotación ilimitada.",
                defaultChannel = "Los despachadores se unen a este canal al iniciar su turno. Las unidades se unen manualmente desde la pestaña Radio. Seleccione Ninguno para utilizar el valor predeterminado del grupo de trabajos.",
                emergencyAppEnabled = "Hace que este trabajo sea seleccionable como servicio público en la aplicación del teléfono de emergencia.",
                enabled = "Hace que este trabajo esté disponible para la aplicación Dispatch y para incidentes entre trabajos.",
                icon = "Seleccione el ícono que se muestra para esta categoría de unidad en la aplicación Dispatch.",
                incidentAssessmentEnabled = "Muestra preguntas médicas y de evaluación de peligros en la entrada completa del incidente.",
                jobs = "Nombres de trabajos adicionales que reciben incidentes utilizando esta palabra clave.",
                joinLocked = "Impide que se incorporen más personas una vez ocupada la unidad.",
                minimumCrew = "Número mínimo de personas en las unidades seleccionadas para este plan de respuesta.",
                noUnitFallback = "Sin un centro o unidad con personal, envía una notificación Sky a todos los miembros en servicio.",
                poiId = "Identificador técnico estable que los perfiles de central pueden conservar aunque cambie el nombre del lugar.",
                radius = "Distancia máxima en metros a la que se puede escuchar el anuncio de la emisora.",
                readyStatusCode = "Estado FMS aplicado cuando el recurso queda disponible para despacho.",
                requirements = "Demanda de respuesta como TYPE:COUNT pares, por ejemplo PATROL:2,CRIME:1.",
                resourceType = "Clasifica el recurso operativo para los filtros y la coordinación de la central.",
                respondingStatusCode = "Estado FMS aplicado cuando el recurso responde a un incidente.",
                shortLabel = "Etiqueta corta opcional mostrada en las seis memorias de canales de radio.",
                stationId = "Asocia la unidad con una estación configurada en el perfil de la central.",
                statusCode = "Estado numérico de FMS que se muestra en la radio portátil.",
                statusLabel = "Significado de este estado de FMS para despachadores y unidades.",
                unitId = "Identificador técnico estable que conserva la unidad aunque cambie su indicativo.",
                vehicleType = "Debe coincidir con un código de tipo de vehículo configurado en la subsección anterior.",
                vehicleTypeCode = "Código de unidad corto utilizado en requisitos de respuesta, por ejemplo PATRULLA, CRIMEN, EMS o RESCATE.",
                vehicleTypeLabel = "Nombre legible de esta categoría de unidad.",
            },
            dispatchFields = {
                address = "Dirección",
                autoAlarm = "Alarma automática",
                available = "Disponible para envío",
                averageResponseSpeedKmh = "Velocidad de respuesta estimada (km/h)",
                callsign = "Indicativo de llamada",
                category = "Categoría",
                centerEnabled = "Habilitar centro de despacho",
                channelId = "ID de canal",
                code = "Código",
                crewCapacity = "Capacidad de dotación",
                defaultChannel = "Canal de radio predeterminado",
                emergencyAppEnabled = "Mostrar en la aplicación de emergencia",
                enabled = "Habilitar despacho",
                icon = "Icono",
                incidentAssessmentEnabled = "Habilitar evaluación de emergencia",
                jobs = "Trabajos de destino (separados por comas)",
                joinLocked = "Bloquear incorporación a la dotación",
                keywordCode = "Código de palabra clave",
                label = "Etiqueta",
                minimumCrew = "Dotación mínima",
                name = "Nombre",
                noUnitFallback = "Notificar al personal de servicio sin unidades",
                noneChannel = "Ninguno/grupo predeterminado",
                note = "Nota",
                phone = "Teléfono",
                poiId = "ID estable del punto de interés",
                radius = "Radio de anuncio",
                readyStatusCode = "Código de estado disponible",
                requirements = "Unidades requeridas (por ejemplo PATRULLA:2,CRIMEN:1)",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado en respuesta",
                shortLabel = "Etiqueta de memoria de radio",
                stationId = "ID de estación",
                type = "Tipo",
                unitId = "ID estable de unidad",
                vehicleType = "Tipo de unidad de respuesta",
                radioButton = "Botón",
                radioButtonAction = "Acción del botón",
                radioButtonStatus = "Situación FMS",
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
            dispatchNavigation = {
                active = "Despacho activo",
                description = "Configure la entrada de emergencia, radio, unidades, planes de respuesta, ubicaciones y datos de reporteros para este trabajo.",
                inactive = "Despacho deshabilitado",
                steps = {
                    accessText = "Habilite el despacho y decida si este trabajo puede dotar de personal a un centro de despacho.",
                    accessTitle = "Acceso y admisión de emergencia",
                    fleetText = "Configura canales, códigos de estado FMS, tipos de vehículos e indicativos.",
                    fleetTitle = "Radio y flota",
                    responseText = "Termine con palabras clave, requisitos de respuesta y puntos de interés.",
                    responseTitle = "Planes de respuesta",
                },
                summary = {
                    channels = "Canales de radio",
                    plans = "Planes de respuesta",
                    reporters = "Alertantes conocidos",
                    statuses = "FMS disponible",
                    units = "Unidades virtuales",
                },
                title = "Despacho",
                warnings = {
                    channels = "No existen canales de radio explícitos; Se utilizará el canal de reserva del grupo de trabajos.",
                    defaultChannel = "El canal predeterminado seleccionado ya no existe.",
                    disabled = "El envío está deshabilitado para este trabajo.",
                    statuses = "Al menos un estado de FMS debe estar disponible para que las unidades puedan recibir alarmas.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Define los canales de radio a los que pueden unirse las unidades y los centros de despacho con personal.",
                dispatchKeywords = "Define palabras clave de incidentes, recuentos de vehículos requeridos, trabajos participantes y alarmas automáticas opcionales.",
                dispatchPois = "Almacena estaciones y ubicaciones comunes para formularios de incidentes y anuncios de estaciones basados ​​en la posición.",
                dispatchReporters = "Gestiona nombres de alertantes, teléfonos de devolución de llamada y notas de despacho propias del trabajo.",
                dispatchStatusCodes = "Configura las etiquetas de estado de FMS y qué estados cuentan como disponibles para nuevos incidentes.",
                dispatchVehicleTypes = "Define las categorías de unidades utilizadas por los planes de respuesta, como Patrulla, Unidad contra el crimen, EMS o Rescate.",
                dispatchVehicles = "Define vehículos de despacho virtuales que pueden contar con personal desde cualquier lugar sin necesidad de un vehículo generado.",
                dispatchRadioButtons = "Establece la acción predefinida centralmente para cada botón de función física.",
                dispatchRadioFmsKeys = "Asigna el estado FMS a las teclas de número físico. El teclado sólo realiza FMS cambios.",
            },
            extensions = {
                caseNumbering = {
                    label = "Números de expediente",
                    description = "Configura los números automáticos de expediente para este trabajo.",
                    fields = {
                        prefix = {
                            label = "Prefijo de expediente",
                            description = "Prefijo para nuevos expedientes, como LSPD o LSCSD. Hasta 16 caracteres, convertidos a mayúsculas; vacío usa CASE. Se conservan los números existentes y los asignados manualmente.",
                        },
                    },
                },
                dispatchReporters = "Alertantes conocidos",
                invalidSelection = "Selección no válida: {value}",
                trainingSettings = {
                    description = "Configure el acceso a la capacitación, la inscripción, las aprobaciones y la planificación de cursos para este trabajo.",
                    label = "Configuración de entrenamiento",
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
                dispatchRadioButtons = "Botones de función de radio",
                dispatchRadioFmsKeys = "FMS Asignación de claves",
            },
            features = {
                billing = {
                    description = "Habilitar los flujos de facturación policial.",
                    label = "Facturación",
                },
                devices = {
                    description = "Habilitar dispositivos de aplicación de la ley desplegables.",
                    label = "CCTV y Cámaras de Velocidad",
                },
                evidence = {
                    description = "Habilitar el almacenamiento de evidencias, la evidencia de campo y los flujos de escáner.",
                    label = "Evidencias",
                },
                impound = {
                    description = "Habilitar los flujos del depósito de incautación.",
                    label = "Incautación",
                },
                jail = {
                    description = "Habilitar la asignación de cárcel y las actividades de los reclusos.",
                    label = "Cárcel",
                },
                propPlacement = {
                    description = "Habilitar props policiales configurables y equipamiento de props de vehículos.",
                    label = "Colocación de Props",
                },
                radial = {
                    description = "Habilitar acciones radiales policiales como la incautación y el cepo de rueda.",
                    label = "Acciones Radiales",
                },
                restraints = {
                    description = "Habilitar esposas, bridas, restricciones de piernas y bolsas de cabeza.",
                    label = "Restricciones",
                },
                socialWork = {
                    description = "Habilitar la asignación de trabajo social y las actividades de tareas.",
                    label = "Trabajo Social",
                },
                tablet = {
                    description = "Habilitar las aplicaciones de la tableta policial configuradas por este recurso.",
                    label = "Tableta Policial",
                },
                tracking = {
                    description = "Habilitar rastreadores GPS y monitores de tobillo.",
                    label = "Seguimiento",
                },
                vehicleRadar = {
                    description = "Habilitar el radar del vehículo de patrulla.",
                    label = "Radar del Vehículo",
                },
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
            settingFields = {
                gangMinimumGrade = "Rango mínimo",
                gang = "Banda",
                component = "Componente",
                description = "Descripción",
                fineAmount = "Monto de la multa",
                itemName = "Nombre del objeto",
                length = "Longitud",
                max = "Máx",
                maxOverKmh = "Exceso máximo",
                min = "Mín",
                minOverKmh = "Exceso mínimo",
                model = "Modelo del prop",
                propModel = "Modelo del prop",
                reason = "Motivo",
                vehicleClass = "Clase",
            },
            settingGroups = {
                access = {
                    label = "Acceso",
                },
                animation = {
                    label = "Animación",
                },
                ankleMonitor = {
                    label = "Monitor de Tobillo",
                },
                ankleMonitorAccess = {
                    label = "Acceso al Monitor de Tobillo",
                },
                ankleMonitorPlacement = {
                    label = "Colocación del Monitor de Tobillo",
                },
                ankleMonitorZone = {
                    label = "Zona del Monitor de Tobillo",
                },
                ankleMonitorZoneVisual = {
                    label = "Visuales de la Zona del Monitor de Tobillo",
                },
                assignment = {
                    label = "Asignación",
                },
                blip = {
                    label = "Blip de la Estación",
                },
                carry = {
                    label = "Transporte",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Durabilidad de CCTV",
                },
                cctvPlacement = {
                    label = "Colocación de CCTV",
                },
                cctvRepair = {
                    label = "Reparación de CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animación de Reparación de CCTV",
                },
                clamp = {
                    label = "Cepo",
                },
                clampWeld = {
                    label = "Soldadura del Cepo",
                },
                cleanup = {
                    label = "Limpieza",
                },
                collection = {
                    label = "Recolección",
                },
                controls = {
                    label = "Controles",
                },
                creator = {
                    label = "Creador",
                },
                crimeSceneTape = {
                    label = "Cinta de escena del crimen",
                },
                crimeSceneTapeAccess = {
                    label = "Acceso a la cinta",
                },
                crimeSceneTapeInventory = {
                    label = "Inventario de la cinta",
                },
                crimeSceneTapeLength = {
                    label = "Longitud de la cinta",
                },
                crimeSceneTapePlacement = {
                    label = "Colocación de la cinta",
                },
                database = {
                    label = "Base de Datos",
                },
                delivery = {
                    label = "Entrega",
                },
                detection = {
                    label = "Detección",
                },
                dispatch = {
                    label = "Despacho",
                },
                escape = {
                    label = "Escapar",
                },
                escort = {
                    label = "Escolta",
                },
                evidenceStorage = {
                    label = "Almacenamiento de Evidencias",
                },
                fastLock = {
                    label = "Bloqueo Rápido Automático",
                },
                general = {
                    label = "Generales",
                },
                gpsTracker = {
                    label = "Rastreador GPS",
                },
                gpsTrackerAccess = {
                    label = "Acceso al Rastreador GPS",
                },
                gpsTrackerPlacement = {
                    label = "Colocación del Rastreador GPS",
                },
                gpsTrackerTiming = {
                    label = "Tiempos del Rastreador GPS",
                },
                handcuffs = {
                    label = "Esposas",
                },
                handsUp = {
                    label = "Manos Arriba",
                },
                header = {
                    label = "Encabezado",
                },
                impound = {
                    label = "Incautación",
                },
                imprisonment = {
                    label = "Encarcelamiento",
                },
                jailCanteenGeneral = {
                    label = "Cantina de la Cárcel",
                },
                jailCanteenPackage = {
                    label = "Paquete de la Cantina",
                },
                jailCarry = {
                    label = "Trabajo de Carga",
                },
                jailCarryInspection = {
                    label = "Inspección de Carga",
                },
                jailCleaning = {
                    label = "Trabajo de Limpieza",
                },
                jailCleaningIllegalFinds = {
                    label = "Hallazgos Ilegales",
                },
                jailCleaningOutline = {
                    label = "Contorno de Limpieza",
                },
                jailDoctor = {
                    label = "Médico de la Cárcel",
                },
                jailElectricalCodes = {
                    label = "Códigos Eléctricos",
                },
                jailElectricalGeneral = {
                    label = "Panel Eléctrico de la Cárcel",
                },
                jailElectricalPenalties = {
                    label = "Penalizaciones Eléctricas",
                },
                jailElectricalRewards = {
                    label = "Recompensas Eléctricas",
                },
                jailInmatesAlcoholic = {
                    label = "Recluso Alcohólico",
                },
                jailInmatesCodeList = {
                    label = "Recluso Informante",
                },
                jailInmatesDrugDealer = {
                    label = "Recluso Traficante de Drogas",
                },
                jailInmatesWireCutter = {
                    label = "Recluso Contrabandista de Herramientas",
                },
                jailJobs = {
                    label = "Trabajos en la Cárcel",
                },
                jailOutfitFemale = {
                    label = "Vestuario Femenino",
                },
                jailOutfitMale = {
                    label = "Vestuario Masculino",
                },
                keybinds = {
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                    label = "Teclas",
                },
                keybindsHandcuff = {
                    label = "Atajo de Esposas",
                },
                keybindsUnhandcuff = {
                    label = "Atajo para Quitar Esposas",
                },
                marker = {
                    label = "Marcador",
                },
                markerColor = {
                    label = "Color del Marcador",
                },
                mugshotAnimation = {
                    label = "Animación de la Foto de Ingreso",
                },
                mugshotBoard = {
                    label = "Panel de la Foto de Ingreso",
                },
                mugshotCameraCoords = {
                    label = "Posición de la Cámara de la Foto de Ingreso",
                },
                mugshotCameraRotation = {
                    label = "Rotación de la Cámara de la Foto de Ingreso",
                },
                mugshotGeneral = {
                    label = "Foto de Ingreso",
                },
                mugshotMetadata = {
                    label = "Metadatos de la Foto de Ingreso",
                },
                mugshotPosition = {
                    label = "Posición de la Foto de Ingreso",
                },
                mugshotTiming = {
                    label = "Tiempos de la Foto de Ingreso",
                },
                officerDown = {
                    label = "Oficial Caído",
                },
                outfit = {
                    label = "Vestuario",
                },
                overlay = {
                    label = "Superposición de Placa",
                },
                payment = {
                    label = "Pago",
                },
                paymentFlow = {
                    label = "Flujo de Pago",
                },
                penalties = {
                    label = "Penalizaciones",
                },
                playerSearch = {
                    label = "Búsqueda de Jugadores",
                },
                playerSearchAnimation = {
                    label = "Animación de Búsqueda de Jugadores",
                },
                props = {
                    label = "Props",
                },
                reasons = {
                    label = "Motivos",
                },
                release = {
                    label = "Liberación",
                },
                restore = {
                    label = "Restauración",
                },
                rules = {
                    label = "Reglas",
                },
                scan = {
                    label = "Escaneo",
                },
                scanner = {
                    label = "Escáner",
                },
                sentence = {
                    label = "Condena",
                },
                shotsFired = {
                    label = "Disparos",
                },
                sound = {
                    label = "Sonido",
                },
                speedcam = {
                    label = "Cámaras de Velocidad",
                },
                speedcamBilling = {
                    label = "Facturación de la Cámara de Velocidad",
                },
                speedcamDispatch = {
                    label = "Despacho de la Cámara de Velocidad",
                },
                speedcamDurability = {
                    label = "Durabilidad de la Cámara de Velocidad",
                },
                speedcamPlacement = {
                    label = "Colocación de la Cámara de Velocidad",
                },
                speedcamRepair = {
                    label = "Reparación de la Cámara de Velocidad",
                },
                speedcamRepairAnimation = {
                    label = "Animación de Reparación de la Cámara de Velocidad",
                },
                speedcamTiming = {
                    label = "Tiempos de la Cámara de Velocidad",
                },
                speedcamVisual = {
                    label = "Visuales de la Cámara de Velocidad",
                },
                speedcams = {
                    label = "Cámaras de Velocidad",
                },
                storage = {
                    label = "Almacenamiento",
                },
                subscription = {
                    label = "Suscripción de la Aplicación",
                },
                tasks = {
                    label = "Tareas",
                },
                theme = {
                    label = "Tema",
                },
                timing = {
                    label = "Tiempos",
                },
                warningUi = {
                    label = "Interfaz de Advertencia",
                },
                world = {
                    label = "Mundo",
                },
                zipties = {
                    label = "Bridas",
                },
                ziptiesCutter = {
                    label = "Cortador de Bridas",
                },
                cctvMotionDetection = {
                    label = "Detección de movimiento",
                },
                cctvMotionDispatch = {
                    label = "Envío de detección de movimiento",
                },
                cctvMotionTiming = {
                    label = "Motion Detection Timeing",
                },
                display = {
                    label = "Pantalla",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Informes",
                },
                speedcamAdvanced = {
                    label = "Cámara de velocidad avanzada",
                },
                tackle = {
                    label = "Derribar",
                },
                vin = {
                    label = "VIN Comprobación",
                },
            },
            settingSections = {
                radarGun = "Pistola de radar",
                billing = "Facturación",
                cctv = "CCTV",
                dispatch = "Despacho",
                equipment = "Equipo",
                evidence = "Evidencias",
                impound = "Incautación",
                jail = "Cárcel",
                radar = "Radar del Vehículo",
                radial = "Acciones Radiales",
                restraints = "Restricciones",
                socialWork = "Trabajo Social",
                speedCamera = "Cámara de Velocidad",
                spikeStrips = "Bandas de Pinchos",
                stations = "Estaciones",
                tablet = "Aplicaciones de la Tableta",
                tracking = "Seguimiento",
                fakePlates = "Placas falsas",
                general = "Generales",
            },
            settingSubsections = {
                app = "Aplicación de Cámara de Velocidad",
                apps = "Aplicaciones",
                billing = "Facturación",
                canteen = "Cantina de la Cárcel",
                dispatch = "Despacho",
                durability = "Durabilidad",
                electrical = "Panel Eléctrico de la Cárcel",
                general = "Generales",
                handcuffs = "Esposas y bridas",
                inmates = "Reclusos",
                jobs = "Trabajos en la Cárcel",
                keybinds = "Teclas",
                motionDetection = "Detección de movimiento",
                mugshot = "Foto de Ingreso",
                placement = "Colocación",
                repair = "Reparación",
                timing = "Tiempos",
                visuals = "Visuales",
            },
            settings = {
                radarGunClearKey = { label = "Pistola radar: Borrar lectura" },
                radarGunToggleUiKey = { label = "Pistola radar: Alternar interfaz" },
                radarGunNoTargetHoldMs = { label = "Tiempo de retención del objetivo (ms)" },
                radarGunMinimumReading = { label = "Velocidad mínima mostrada" },
                radarGunSpeedSmoothing = { label = "Suavizado de velocidad (0–1)" },
                radarGunBeamRadius = { label = "Radio del haz (m)" },
                radarGunRefreshRateMs = { label = "Intervalo de medición (ms)" },
                radarGunUseMph = { label = "Usar MPH", description = "Muestra las mediciones en millas por hora en lugar de kilómetros por hora." },
                radarGunRange = { label = "Alcance de medición", description = "Distancia máxima en metros a la que la pistola de radar detecta vehículos." },
                radarGunRequireOnDuty = { label = "Requerir servicio", description = "Exige que los agentes estén de servicio antes de medir vehículos con la pistola de radar." },
                radarGunAllowedJobs = { label = "Trabajos o grupos permitidos", description = "police incluye todos los trabajos policiales configurados; también admite nombres directos. Una lista vacía elimina las restricciones de trabajo.", itemLabel = "Trabajo o grupo" },
                radarGunEnabled = { label = "Pistola de radar", description = "Activa la pistola de radar portátil SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Bandas permitidas",
                    description = "Selecciona nombres internos de bandas u organizaciones independientes. Un trabajo o banda coincidente concede el permiso o exención. El servicio solo se exige a los trabajos.",
                    itemLabel = "Banda",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Rangos mínimos de bandas",
                    description = "Rangos mínimos opcionales. Una lista vacía permite todos los rangos. Los requisitos de objetos siguen vigentes.",
                },

                speedCamProcessingMode = {
                    description = "Elige cobro inmediato, pago dentro del plazo configurado o solo revisión policial.",
                    label = "Modo de procesamiento",
                    options = {
                        instant = "Cobrar ahora",
                        later = "Pagar después (predeterminado)",
                        review = "Solo revisión policial",
                    },
                },
                tabletRegistry = { label = "Registro", description = "Activar registros RP personalizados en File Explorer. Los expedientes de ciudadanos y vehículos siguen disponibles por separado." },
                tabletFiles = { label = "Explorador de archivos", description = "Agrupa los registros policiales en el explorador de archivos. Los documentos del DOJ aparecen solo cuando está activo." },
                ankleMonitorAnimDurationMs = {
                    description = "Milisegundos empleados en aplicar un monitor de tobillo.",
                    label = "Duración de aplicación",
                },
                ankleMonitorAnimScenario = {
                    description = "Escenario reproducido al aplicar un monitor de tobillo.",
                    label = "Escenario de aplicación",
                },
                ankleMonitorAttachBone = {
                    description = "Hueso del ped usado para anclar el prop del monitor de tobillo.",
                    label = "Hueso de anclaje",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Quitar el objeto del monitor de tobillo tras colocarlo.",
                    label = "Consumir monitor de tobillo",
                },
                ankleMonitorCutItem = {
                    description = "Objeto de inventario usado para retirar monitores de tobillo.",
                    label = "Objeto de corte",
                },
                ankleMonitorEnabled = {
                    description = "Habilitar la colocación de monitores de tobillo.",
                    label = "Monitor de tobillo",
                },
                ankleMonitorItem = {
                    description = "Objeto de inventario usado para colocar monitores de tobillo.",
                    label = "Objeto del monitor de tobillo",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Milisegundos entre actualizaciones del mapa del monitor de tobillo.",
                    label = "Intervalo de actualización del mapa",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Mantiene los monitores de tobillo en la base de datos cuando los jugadores vigilados se desconectan para restaurarlos tras reconexiones y reinicios del servidor.",
                    label = "Conservar tras la desconexión",
                },
                ankleMonitorPlaceDistance = {
                    description = "Distancia máxima para colocar un monitor de tobillo.",
                    label = "Distancia de colocación",
                },
                ankleMonitorPropModel = {
                    description = "Modelo de prop usado para el efecto visual del monitor de tobillo.",
                    label = "Modelo del prop",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Requerir estar de servicio antes de usar monitores de tobillo.",
                    label = "Monitor de tobillo requiere servicio",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Requerir que el jugador pertenezca al grupo policial antes de usar monitores de tobillo.",
                    label = "Monitor de tobillo requiere grupo policial",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Devolver el objeto del monitor de tobillo al retirarlo.",
                    label = "Devolver monitor de tobillo al retirarlo",
                },
                ankleMonitorWarningSeconds = {
                    description = "Tiempo de advertencia antes de que se despache una violación de zona del monitor de tobillo.",
                    label = "Segundos de advertencia de zona",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Milisegundos entre pitidos de advertencia de zona del monitor de tobillo.",
                    label = "Intervalo de pitido de zona",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Nombre del sonido usado para las advertencias de zona del monitor de tobillo.",
                    label = "Sonido de pitido",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Conjunto de sonido usado para las advertencias de zona del monitor de tobillo.",
                    label = "Conjunto de sonido del pitido",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Valor de transparencia usado para los blips de zona del monitor de tobillo.",
                    label = "Transparencia del blip",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Color del blip usado cuando un objetivo está dentro del área permitida.",
                    label = "Color de blip permitido",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Color del blip usado cuando un objetivo abandona el área permitida.",
                    label = "Color de blip excluido",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Milisegundos entre comprobaciones de zona del monitor de tobillo.",
                    label = "Intervalo de comprobación de zona",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Segundos antes de que se pueda enviar otro despacho de zona del monitor de tobillo.",
                    label = "Enfriamiento de despacho de zona",
                },
                ankleMonitorZoneEnabled = {
                    description = "Habilitar las comprobaciones de zona del monitor de tobillo.",
                    label = "Zonas del monitor de tobillo",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Sprite del blip usado para los marcadores de zona del monitor de tobillo.",
                    label = "Sprite de la etiqueta de zona",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Radio usado para los contornos de zona del monitor de tobillo.",
                    label = "Radio del contorno",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Tamaño de paso usado para los contornos de zona del monitor de tobillo.",
                    label = "Paso del contorno",
                },
                billingAccount = {
                    description = "Cuenta alternativa usada cuando un trabajo no tiene una cuenta de sociedad configurada.",
                    label = "Cuenta de sociedad alternativa",
                },
                billingCloseOnSuccess = {
                    description = "Cerrar la interfaz de facturación después de emitir una factura.",
                    label = "Cerrar tras éxito",
                },
                billingCurrency = {
                    description = "Clave de moneda usada para la facturación. Dejar vacío para usar la moneda predeterminada.",
                    label = "Moneda",
                },
                billingCustomReasons = {
                    description = "Permitir motivos de facturación personalizados en lugar de solo los predefinidos.",
                    label = "Motivos personalizados",
                },
                billingDepositToSociety = {
                    description = "Depositar los ingresos por facturación en la cuenta de sociedad del trabajo.",
                    label = "Depositar en la sociedad",
                },
                billingMaxReasonLength = {
                    description = "Número máximo de caracteres para los motivos de facturación personalizados.",
                    label = "Longitud del motivo",
                },
                billingMode = {
                    description = "Elegir si las facturas policiales se cobran al instante, requieren confirmación del ciudadano o usan el sistema de facturación del framework.",
                    label = "Modo de facturación",
                    options = {
                        consent = "Pagar o rechazar",
                        framework = "Factura del framework",
                        instant = "Cobro instantáneo",
                    },
                },
                billingRange = {
                    description = "Distancia máxima al objetivo para emitir facturas policiales.",
                    label = "Distancia de facturación",
                },
                billingReasonPresets = {
                    description = "Motivos de facturación predefinidos mostrados en la interfaz de facturación.",
                    itemLabel = "Motivo",
                    label = "Motivos predefinidos",
                },
                billingRefreshSeconds = {
                    description = "Intervalo de actualización del objetivo mientras la interfaz de facturación está abierta.",
                    label = "Segundos de actualización",
                },
                billingShowRecipientName = {
                    description = "Mostrar el nombre del ciudadano en las vistas previas y los recibos de multas.",
                    label = "Mostrar nombre del destinatario",
                },
                carryAllowCarrierInVehicle = {
                    description = "Permite al portador entrar y conducir un vehículo sin soltar al jugador.",
                    label = "Permitir al portador en vehículos",
                },
                carryAllowConscious = {
                    description = "Permitir transportar objetivos conscientes.",
                    label = "Transportar objetivos conscientes",
                },
                carryAllowSprint = {
                    description = "Permitir correr mientras se transporta a otro jugador.",
                    label = "Permitir correr mientras se transporta",
                },
                carryEnabled = {
                    description = "Habilitar el transporte de jugadores.",
                    label = "Transporte",
                },
                carryMaxDistance = {
                    description = "Distancia máxima para comenzar a transportar a un jugador.",
                    label = "Distancia de transporte",
                },
                carryRequireOnDuty = {
                    description = "Requerir estar de servicio antes de iniciar un transporte.",
                    label = "Transporte requiere servicio",
                },
                cctvDamageCooldownMs = {
                    description = "Milisegundos antes de que la CCTV pueda volver a recibir daño.",
                    label = "Enfriamiento de daño",
                },
                cctvDamagePerHit = {
                    description = "Daño de durabilidad aplicado a las cámaras CCTV por cada impacto.",
                    label = "Daño por impacto",
                },
                cctvDefaultName = {
                    description = "Nombre visible predeterminado para las cámaras CCTV desplegadas.",
                    label = "Nombre predeterminado de CCTV",
                },
                cctvDefaultPitch = {
                    description = "Inclinación predeterminada de la cámara para la colocación de CCTV.",
                    label = "Inclinación predeterminada",
                },
                cctvDisassembleDistance = {
                    description = "Distancia usada para desmontar cámaras CCTV.",
                    label = "Distancia de desmontaje",
                },
                cctvEnabled = {
                    description = "Habilitar la colocación y transmisión de cámaras CCTV.",
                    label = "Cámaras CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Distancia a la que se muestra el estado de la CCTV.",
                    label = "Distancia de visualización de estado",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Milisegundos que permanece visible el estado de la CCTV.",
                    label = "Duración de visualización de estado",
                },
                cctvHealthTextOffset = {
                    description = "Desplazamiento vertical usado para el texto de estado de la CCTV.",
                    label = "Desplazamiento del texto de estado",
                },
                cctvHeightStep = {
                    description = "Paso de altura usado al posicionar cámaras CCTV.",
                    label = "Paso de altura",
                },
                cctvItem = {
                    description = "Objeto de inventario usado para colocar cámaras CCTV.",
                    label = "Objeto de CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Umbral de durabilidad en el que se recomienda el mantenimiento de CCTV.",
                    label = "Umbral de mantenimiento",
                },
                cctvMaxDurability = {
                    description = "Durabilidad máxima de la cámara CCTV.",
                    label = "Durabilidad de CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Segundos antes de que una cámara pueda crear otro despacho por movimiento.",
                    label = "Espera del despacho",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Milisegundos entre escaneos de movimiento del cliente.",
                    label = "Intervalo de escaneo",
                },
                cctvMotionClientCooldownMs = {
                    description = "Milisegundos antes de que un cliente pueda reportar de nuevo la misma cámara.",
                    label = "Espera de reporte del cliente",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Activa automáticamente las alertas de movimiento en las cámaras CCTV recién colocadas.",
                    label = "Activar cámaras nuevas por defecto",
                },
                cctvMotionDetectionEnabled = {
                    description = "Activa las alertas de despacho por movimiento para cada cámara CCTV.",
                    label = "Alertas de movimiento",
                },
                cctvMotionDetectionRadius = {
                    description = "Distancia máxima de detección de movimiento en metros.",
                    label = "Radio de detección",
                },
                cctvMotionFieldOfView = {
                    description = "Ángulo del cono de detección de movimiento en grados.",
                    label = "Campo de visión",
                },
                cctvMotionJobs = {
                    description = "Nombres de trabajos o grupos que reciben despachos de movimiento CCTV.",
                    itemLabel = "Trabajo o grupo",
                    label = "Trabajos de despacho",
                },
                cctvMotionMinimumSpeed = {
                    description = "Velocidad mínima de una entidad en metros por segundo para contar como movimiento.",
                    label = "Velocidad mínima de movimiento",
                },
                cctvMoveStep = {
                    description = "Paso de movimiento usado al posicionar cámaras CCTV.",
                    label = "Paso de movimiento",
                },
                cctvPropModel = {
                    description = "Modelo de prop usado para las cámaras CCTV desplegadas.",
                    label = "Modelo del prop de CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Diccionario de animación usado al reparar cámaras CCTV.",
                    label = "Diccionario de animación de reparación",
                },
                cctvRepairAnimFlag = {
                    description = "Bandera de animación usada al reparar cámaras CCTV.",
                    label = "Bandera de la animación de reparación",
                },
                cctvRepairAnimName = {
                    description = "Nombre de animación usado al reparar cámaras CCTV.",
                    label = "Nombre de la animación de reparación",
                },
                cctvRepairCancelDelayMs = {
                    description = "Milisegundos antes de que se pueda cancelar la reparación de CCTV.",
                    label = "Retraso de cancelación de reparación",
                },
                cctvRepairDistance = {
                    description = "Distancia usada para reparar cámaras CCTV.",
                    label = "Distancia de reparación",
                },
                cctvRepairItem = {
                    description = "Objeto de inventario usado para reparar cámaras CCTV.",
                    label = "Objeto de reparación",
                },
                cctvRepairPerTick = {
                    description = "Durabilidad restaurada por cada pulso de reparación de CCTV.",
                    label = "Reparación por pulso",
                },
                cctvRepairTickMs = {
                    description = "Milisegundos entre pulsos de reparación de CCTV.",
                    label = "Intervalo de reparación",
                },
                cctvRotateStep = {
                    description = "Paso de rotación usado al posicionar cámaras CCTV.",
                    label = "Paso de rotación",
                },
                cctvStreamDistance = {
                    description = "Distancia usada para cargar las cámaras CCTV.",
                    label = "Distancia de carga",
                },
                cctvViewOffset = {
                    description = "Desplazamiento de vista usado para la transmisión en vivo de la cámara CCTV.",
                    label = "Desplazamiento de vista",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Crea una barrera de colisión a lo largo de la cinta para impedir que los jugadores la atraviesen.",
                    label = "Colisión de bloqueo de la cinta",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Retira un objeto de cinta del inventario después de colocarlo correctamente.",
                    label = "Consumir objeto de cinta",
                },
                crimeSceneTapeDynamic = {
                    description = "Hace que la cinta reaccione a la física y la gravedad en lugar de quedar fija.",
                    label = "Física dinámica",
                },
                crimeSceneTapeEnabled = {
                    description = "Permite colocar cinta de escena del crimen usando un objeto del inventario.",
                    label = "Cinta de escena del crimen",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Solo los trabajos autorizados pueden retirar la cinta y, si se exige, deben estar de servicio.",
                    label = "Restringir retirada",
                },
                crimeSceneTapeItem = {
                    description = "Nombre del objeto de inventario que inicia la colocación de la cinta de escena del crimen.",
                    label = "Objeto de cinta",
                },
                crimeSceneTapeJobs = {
                    description = "Nombres de los trabajos que pueden usar la cinta de escena del crimen.",
                    itemLabel = "Trabajo",
                    label = "Trabajos autorizados",
                },
                crimeSceneTapeLabel = {
                    description = "Nombre visible de la cinta de escena del crimen durante su colocación.",
                    label = "Etiqueta de la cinta",
                },
                crimeSceneTapeLengthStep = {
                    description = "Incremento en metros al que se redondea la longitud seleccionada de la cinta.",
                    label = "Incremento de longitud",
                },
                crimeSceneTapeMaxLength = {
                    description = "Distancia máxima permitida entre los dos postes de la cinta, en metros.",
                    label = "Longitud máxima de la cinta",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Distancia máxima de cualquiera de los extremos respecto al agente que coloca la cinta.",
                    label = "Distancia máxima de colocación",
                },
                crimeSceneTapeMinLength = {
                    description = "Distancia mínima permitida entre los dos postes de la cinta, en metros.",
                    label = "Longitud mínima de la cinta",
                },
                crimeSceneTapeModel = {
                    description = "Nombre del modelo de prop utilizado para la cinta de escena del crimen colocada.",
                    label = "Modelo de cinta",
                },
                crimeSceneTapePostModel = {
                    description = "Modelo de prop utilizado para ambos postes de la cinta.",
                    label = "Modelo de poste",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Distancia máxima desde la que se puede retirar la cinta de escena del crimen colocada.",
                    label = "Distancia de retirada",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Solo los miembros de trabajos autorizados que estén de servicio pueden colocar la cinta.",
                    label = "Exigir servicio activo",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Devuelve el objeto consumido al retirar la cinta colocada.",
                    label = "Devolver objeto al retirar",
                },
                crimeSceneTapeSag = {
                    description = "Comba máxima hacia abajo de la cinta entre los postes, en metros.",
                    label = "Comba de la cinta",
                },
                crimeSceneTapeSections = {
                    description = "Modelos nativos de secciones de cinta utilizados para componer la longitud seleccionada.",
                    itemLabel = "Sección de cinta",
                    label = "Secciones de cinta",
                },
                crimeSceneTapeShowPosts = {
                    description = "Genera postes de soporte visibles en ambos extremos de la cinta de escena del crimen de longitud variable.",
                    label = "Mostrar postes de la cinta",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Distancia dentro de la cual se carga la cinta de escena del crimen colocada.",
                    label = "Distancia de carga",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Altura de la cinta sobre los puntos del suelo seleccionados.",
                    label = "Altura de la cinta",
                },
                crimeSceneTapeVariableLength = {
                    description = "Permite a los agentes definir un punto inicial y uno final para colocar la cinta con una longitud ajustable.",
                    label = "Longitud variable de la cinta",
                },
                crimeSceneTapeZOffset = {
                    description = "Desplazamiento vertical aplicado al colocar el modelo de cinta.",
                    label = "Desplazamiento vertical",
                },
                cuffsAnimDict = {
                    description = "Diccionario de animación usado para los jugadores restringidos.",
                    label = "Diccionario de animación",
                },
                cuffsAnimFlag = {
                    description = "Bandera de animación usada para los jugadores restringidos.",
                    label = "Bandera de la animación",
                },
                cuffsAnimName = {
                    description = "Nombre de animación usado para los jugadores restringidos.",
                    label = "Nombre de la animación",
                },
                cuffsConsumeItem = {
                    description = "Quitar el objeto de esposas al aplicarlas.",
                    label = "Consumir esposas",
                },
                cuffsEnabled = {
                    description = "Habilitar las acciones de esposar.",
                    label = "Esposas",
                },
                cuffsEscapeEnabled = {
                    description = "Habilitar el minijuego de escape de esposas.",
                    label = "Escape de esposas",
                },
                cuffsEscapeKeyPool = {
                    description = "Teclas que pueden aparecer en el minijuego de escape de esposas.",
                    itemLabel = "Tecla",
                    label = "Grupo de teclas de escape",
                },
                cuffsEscapeRounds = {
                    description = "Número de rondas requeridas en el minijuego de escape de esposas.",
                    label = "Rondas de escape",
                },
                cuffsEscapeWindowMs = {
                    description = "Milisegundos permitidos por cada ventana de entrada del escape de esposas.",
                    label = "Ventana de escape",
                },
                cuffsHandsUpEnabled = {
                    description = "Habilitar el estado de manos arriba usado por esposas y bridas.",
                    label = "Manos arriba",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Segundos que debe mantenerse pulsada la tecla de manos arriba antes de activarse.",
                    label = "Segundos manteniendo manos arriba",
                },
                cuffsHandsUpKey = {
                    description = "Tecla del teclado usada para levantar las manos.",
                    label = "Tecla de manos arriba",
                },
                cuffsItem = {
                    description = "Objeto de inventario usado para las acciones de esposar.",
                    label = "Objeto de esposas",
                },
                cuffsMaxDistance = {
                    description = "Distancia máxima al objetivo para las acciones de esposar.",
                    label = "Distancia de esposado",
                },
                cuffsRequireItem = {
                    description = "Requerir el objeto de esposas configurado.",
                    label = "Esposas requieren objeto",
                },
                cuffsRequireOnDuty = {
                    description = "Requerir estar de servicio antes de esposar.",
                    label = "Esposas requieren servicio",
                },
                cuffsReturnOnRemove = {
                    description = "Devolver el objeto de esposas al quitarlas.",
                    label = "Devolver esposas",
                },
                dispatchOfficerDownEnabled = {
                    description = "Enviar una alerta de despacho cuando un oficial de servicio cae herido.",
                    label = "Alertas de oficial caído",
                },
                dispatchOfficerDownJobs = {
                    description = "Trabajos que deben recibir despachos de oficial caído.",
                    itemLabel = "Trabajo",
                    label = "Trabajos de oficial caído",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Notificar solo a los jugadores que actualmente están de servicio.",
                    label = "Oficial caído requiere servicio",
                },
                dispatchShotsFiredChance = {
                    description = "Probabilidad entre 0.0 y 1.0 de que un disparo detectado genere una alerta.",
                    label = "Probabilidad de alerta",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Segundos antes de que el mismo jugador pueda activar otra alerta de disparos.",
                    label = "Enfriamiento de disparos",
                },
                dispatchShotsFiredEnabled = {
                    description = "Habilitar las alertas de despacho por disparos.",
                    label = "Alertas de disparos",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Armas que no deben activar alertas de disparos.",
                    itemLabel = "Arma",
                    label = "Armas ignoradas",
                },
                dispatchShotsFiredJobs = {
                    description = "Trabajos que deben recibir despachos de disparos.",
                    itemLabel = "Trabajo",
                    label = "Trabajos de disparos",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Notificar solo a los jugadores que actualmente están de servicio.",
                    label = "Disparos requieren servicio",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Crear entradas de despacho cuando se detecten disparos.",
                    label = "Enviar despacho de disparos",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Probabilidad entre 0.0 y 1.0 de que un disparo con silenciador detectado genere una alerta.",
                    label = "Probabilidad de alerta con silenciador",
                },
                escortEnabled = {
                    description = "Habilitar la escolta de jugadores.",
                    label = "Escolta",
                },
                escortMaxDistance = {
                    description = "Distancia máxima para comenzar a escoltar a un jugador.",
                    label = "Distancia de escolta",
                },
                escortRequireOnDuty = {
                    description = "Requerir estar de servicio antes de escoltar jugadores.",
                    label = "Escolta requiere servicio",
                },
                escortVehicleDistance = {
                    description = "Distancia máxima para colocar a un jugador escoltado en un vehículo.",
                    label = "Distancia de escolta al vehículo",
                },
                evidenceBloodDamageThreshold = {
                    description = "Umbral mínimo de daño antes de crear evidencia de sangre.",
                    label = "Umbral de daño de sangre",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Milisegundos antes de que se pueda crear otro casquillo.",
                    label = "Enfriamiento de casquillos",
                },
                evidenceCasingMergeRadius = {
                    description = "Radio usado para fusionar casquillos cercanos.",
                    label = "Radio de fusión de casquillos",
                },
                evidenceCleanupIntervalMs = {
                    description = "Milisegundos entre pasadas de limpieza de evidencia.",
                    label = "Intervalo de limpieza",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Segundos antes de que la evidencia de campo expire automáticamente.",
                    label = "TTL de limpieza",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Limpiador para todos",
                    description = "Permitir que todos eliminen rastros con peróxido de hidrógeno. Desactiva para usar las listas de trabajos y bandas.",
                },
                evidenceCleanerJobs = {
                    label = "Trabajos del limpiador",
                    description = "Nombres internos permitidos sin acceso público. Basta con que coincida el trabajo o la banda; las listas vacías deniegan el acceso.",
                    itemLabel = "Trabajo",
                },
                evidenceCleanerGangs = {
                    label = "Bandas del limpiador",
                    description = "Nombres internos permitidos sin acceso público. Basta con que coincida el trabajo o la banda; las listas vacías deniegan el acceso.",
                    itemLabel = "Banda",
                },
                evidenceCollectDistance = {
                    description = "Distancia usada para recolectar evidencia de campo.",
                    label = "Distancia de recolección",
                },
                evidenceDiscoverDistance = {
                    description = "Distancia usada para descubrir marcadores de evidencia cercanos.",
                    label = "Distancia de descubrimiento",
                },
                evidenceFieldEnabled = {
                    description = "Habilitar la creación y recolección de evidencia en el campo.",
                    label = "Evidencia de campo",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Arma usada para inspeccionar y revelar evidencia en el campo.",
                    label = "Arma linterna",
                },
                evidenceGloveFreeHands = {
                    description = "ID de componentes de mano considerados como no llevar guantes.",
                    label = "Manos sin guantes",
                },
                evidenceMarkerColor = {
                    description = "Color RGBA usado para los marcadores de evidencia de campo.",
                    label = "Color del marcador",
                },
                evidenceMarkerDrawDistance = {
                    description = "Distancia de dibujo usada para los marcadores de evidencia de campo.",
                    label = "Distancia de dibujo",
                },
                evidenceMarkerOffset = {
                    description = "Desplazamiento vertical del marcador usado para la evidencia de campo.",
                    label = "Desplazamiento",
                },
                evidenceMarkerScaleX = {
                    description = "Escala X del marcador usada para la evidencia de campo.",
                    label = "Escala X",
                },
                evidenceMarkerScaleY = {
                    description = "Escala Y del marcador usada para la evidencia de campo.",
                    label = "Escala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Escala Z del marcador usada para la evidencia de campo.",
                    label = "Escala Z",
                },
                evidenceMarkerType = {
                    description = "Tipo de marcador usado para la evidencia de campo.",
                    label = "Tipo de marcador",
                },
                evidenceMaxCreateDistance = {
                    description = "Distancia máxima para crear registros de evidencia.",
                    label = "Distancia de creación",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Milisegundos permitidos para el consentimiento de la muestra de saliva.",
                    label = "Tiempo de espera del consentimiento de saliva",
                },
                evidenceScannerDistance = {
                    description = "Distancia usada para las interacciones con el escáner de evidencia.",
                    label = "Distancia del escáner",
                },
                evidenceScannerDurationMs = {
                    description = "Duración de la acción de huellas/escáner en milisegundos.",
                    label = "Duración del escáner",
                },
                evidenceStorageMaxCompartments = {
                    description = "Número máximo de compartimentos de almacenamiento de evidencia.",
                    label = "Compartimentos de almacenamiento",
                },
                gpsTrackerBeepDistance = {
                    description = "Distancia a partir de la cual se vuelve relevante el pitido del rastreador GPS.",
                    label = "Distancia del pitido",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Milisegundos entre pitidos al estar lejos de un rastreador.",
                    label = "Intervalo de pitido lejano",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Milisegundos entre pitidos al estar cerca de un rastreador.",
                    label = "Intervalo de pitido cercano",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Quitar el objeto del rastreador tras colocarlo.",
                    label = "Consumir rastreador GPS",
                },
                gpsTrackerEnabled = {
                    description = "Habilitar la colocación y el escaneo de rastreadores GPS en vehículos.",
                    label = "Rastreador GPS",
                },
                gpsTrackerItem = {
                    description = "Objeto de inventario usado para colocar rastreadores GPS.",
                    label = "Objeto del rastreador",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Milisegundos entre actualizaciones del mapa de rastreadores.",
                    label = "Intervalo de actualización del mapa",
                },
                gpsTrackerPlaceDistance = {
                    description = "Distancia máxima para colocar un rastreador GPS en un vehículo.",
                    label = "Distancia de colocación",
                },
                gpsTrackerRemoveDistance = {
                    description = "Distancia máxima para retirar un rastreador GPS colocado.",
                    label = "Distancia de retiro",
                },
                gpsTrackerRemoveKey = {
                    description = "Código de control usado para retirar un rastreador GPS colocado.",
                    label = "Tecla de retiro",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Requerir estar de servicio antes de usar rastreadores GPS.",
                    label = "GPS requiere servicio",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Requerir que el jugador pertenezca al grupo policial antes de usar rastreadores GPS.",
                    label = "GPS requiere grupo policial",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Devolver el objeto del rastreador al retirarlo.",
                    label = "Devolver rastreador al retirarlo",
                },
                gpsTrackerScanDistance = {
                    description = "Distancia máxima para escanear rastreadores.",
                    label = "Distancia de escaneo GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Milisegundos empleados en escanear un rastreador GPS.",
                    label = "Duración del escaneo",
                },
                gpsTrackerScannerWeapon = {
                    description = "Arma o herramienta usada para escanear rastreadores GPS.",
                    label = "Arma escáner",
                },
                impoundAccount = {
                    description = "Cuenta usada para cobrar las liberaciones de incautación.",
                    label = "Cuenta de pago",
                },
                impoundCreatorVehicleModel = {
                    description = "Modelo de vehículo mostrado en la vista previa del creador de incautación.",
                    label = "Modelo del vehículo del creador",
                },
                impoundCustomGarageEnabled = {
                    description = "Usar una interfaz de garaje de incautación personalizada cuando esté disponible.",
                    label = "Incautación de garaje personalizado",
                },
                impoundDefaultPrice = {
                    description = "Precio predeterminado de liberación de incautación.",
                    label = "Precio predeterminado",
                },
                impoundDeliveryDistance = {
                    description = "Distancia usada para las interacciones de entrega de incautación.",
                    label = "Distancia de entrega",
                },
                impoundDeliveryMarker = {
                    description = "Configuración del marcador usada para las entregas de incautación.",
                    label = "Marcador de entrega",
                },
                impoundEnabled = {
                    description = "Habilitar los flujos de incautación.",
                    label = "Incautación",
                },
                impoundMarker = {
                    description = "Configuración del marcador usada para las interacciones de incautación.",
                    label = "Marcador de incautación",
                },
                impoundRadialEnabled = {
                    description = "Habilitar las acciones radiales de incautación.",
                    label = "Acción de incautación",
                },
                impoundRadialRequireOnDuty = {
                    description = "Requerir estar de servicio antes de usar la acción radial de incautación.",
                    label = "Incautación requiere servicio",
                },
                impoundRadialVehicleDistance = {
                    description = "Distancia máxima al vehículo objetivo para las acciones radiales de incautación.",
                    label = "Distancia al vehículo incautado",
                },
                impoundReleaseDistance = {
                    description = "Distancia usada para las interacciones de liberación de incautación.",
                    label = "Distancia de liberación",
                },
                impoundReleaseKey = {
                    description = "Código de control usado para liberar los vehículos incautados.",
                    label = "Tecla de liberación",
                },
                impoundRequireDelivery = {
                    description = "Requerir la entrega a un depósito de incautación configurado.",
                    label = "Requerir entrega",
                },
                impoundStorageBasePrice = {
                    description = "Precio base de liberación para los vehículos incautados almacenados.",
                    label = "Precio base de almacenamiento",
                },
                impoundStorageDailyFee = {
                    description = "Tarifa adicional de almacenamiento de incautación por cada día configurado.",
                    label = "Tarifa diaria de almacenamiento",
                },
                impoundStorageDaySeconds = {
                    description = "Cuántos segundos cuentan como un día de facturación de almacenamiento.",
                    label = "Segundos por día de almacenamiento",
                },
                impoundStorageEnabled = {
                    description = "Habilitar la gestión de almacenamiento de incautación de pago.",
                    label = "Almacenamiento de incautación",
                },
                jailAssignRange = {
                    description = "Distancia máxima para enviar a un objetivo a la cárcel.",
                    label = "Distancia de asignación",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minutos que un recluso debe esperar antes de reclamar otro paquete de la cantina.",
                    label = "Minutos de enfriamiento",
                },
                jailCanteenPackage = {
                    description = "Objetos otorgados por el paquete de la cantina de la cárcel.",
                    label = "Paquete de la cantina",
                },
                jailCellStreamDistance = {
                    description = "Distancia usada para la carga de props de la celda de aislamiento.",
                    label = "Distancia de carga de celda",
                },
                jailClearInventory = {
                    description = "Vaciar el inventario del jugador al enviarlo a la cárcel.",
                    label = "Vaciar inventario",
                },
                jailDefaultMonths = {
                    description = "Duración de cárcel predeterminada al abrir la interfaz de asignación.",
                    label = "Meses predeterminados",
                },
                jailDispatchJobs = {
                    description = "Trabajos que deben recibir despachos de la cárcel.",
                    itemLabel = "Trabajo",
                    label = "Trabajos de despacho",
                },
                jailDoctorHealEvent = {
                    description = "Evento del servidor o del cliente que se activa cuando el médico de la cárcel cura a un recluso.",
                    label = "Evento de curación",
                },
                jailElectricalCodeListItem = {
                    description = "Objeto de inventario requerido para revelar los códigos eléctricos generados.",
                    label = "Objeto de lista de códigos",
                },
                jailElectricalCodeMax = {
                    description = "Valor máximo de código aleatorio para el panel eléctrico.",
                    label = "Código máximo",
                },
                jailElectricalCodeMin = {
                    description = "Valor mínimo de código aleatorio para el panel eléctrico.",
                    label = "Código mínimo",
                },
                jailElectricalCodesCount = {
                    description = "Cuántos códigos candidatos se generan para el panel eléctrico.",
                    label = "Cantidad de códigos",
                },
                jailElectricalEnabled = {
                    description = "Habilitar el minijuego de fuga por el panel eléctrico.",
                    label = "Panel eléctrico",
                },
                jailElectricalPinLength = {
                    description = "Número de dígitos usados para los códigos PIN del panel eléctrico.",
                    label = "Longitud del PIN",
                },
                jailElectricalPropModel = {
                    description = "Modelo de prop del mundo usado para el panel eléctrico de la cárcel.",
                    label = "Modelo del prop",
                },
                jailElectricalShockDamage = {
                    description = "Daño infligido cuando un recluso falla la secuencia eléctrica.",
                    label = "Daño de descarga",
                },
                jailElectricalShockRagdollMs = {
                    description = "Milisegundos de ragdoll tras una descarga eléctrica.",
                    label = "Ragdoll de descarga",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Minutos de condena eliminados tras un intento exitoso de fuga eléctrica.",
                    label = "Minutos de reducción por éxito",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Cantidad requerida para el intercambio con el recluso alcohólico.",
                    label = "Cantidad requerida",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Objeto requerido para el intercambio con el recluso alcohólico.",
                    label = "Objeto requerido",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Cantidad de recompensa para el intercambio con el recluso alcohólico.",
                    label = "Cantidad de recompensa",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Objeto de recompensa para el intercambio con el recluso alcohólico.",
                    label = "Objeto de recompensa",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para el intercambio con el recluso alcohólico.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Cantidad requerida para el intercambio con el recluso informante.",
                    label = "Cantidad requerida",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Objeto requerido para el intercambio con el recluso informante.",
                    label = "Objeto requerido",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Cantidad de recompensa para el intercambio con el recluso informante.",
                    label = "Cantidad de recompensa",
                },
                jailInmateCodeListRewardItem = {
                    description = "Objeto de recompensa para el intercambio con el recluso informante.",
                    label = "Objeto de recompensa",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para el intercambio con el recluso informante.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Objetos aceptados para el intercambio con el recluso traficante de drogas.",
                    label = "Objetos aceptados",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Cantidad requerida para el intercambio con el recluso traficante de drogas.",
                    label = "Cantidad requerida",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Cantidad de recompensa para el intercambio con el recluso traficante de drogas.",
                    label = "Cantidad de recompensa",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Objeto de recompensa para el intercambio con el recluso traficante de drogas.",
                    label = "Objeto de recompensa",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para el intercambio con el recluso traficante de drogas.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Permitir que el contrabando encontrado durante la limpieza de la cárcel cuente para el intercambio con el recluso traficante de drogas.",
                    label = "Usar contrabando de limpieza",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Cantidad requerida para el intercambio con el recluso contrabandista de herramientas.",
                    label = "Cantidad requerida",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Objeto requerido para el intercambio con el recluso contrabandista de herramientas.",
                    label = "Objeto requerido",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Cantidad de recompensa para el intercambio con el recluso contrabandista de herramientas.",
                    label = "Cantidad de recompensa",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Objeto de recompensa para el intercambio con el recluso contrabandista de herramientas.",
                    label = "Objeto de recompensa",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para el intercambio con el recluso contrabandista de herramientas.",
                    label = "Etiqueta de recompensa",
                },
                jailJobsCarryBoxModel = {
                    description = "Modelo de prop usado para la caja del trabajo de carga en la cárcel.",
                    label = "Modelo de la caja de carga",
                },
                jailJobsCarryDropoffKey = {
                    description = "Código de control usado para entregar las cajas del trabajo de carga.",
                    label = "Tecla de entrega de carga",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Radio de entrega para el trabajo de carga en la cárcel.",
                    label = "Radio de entrega",
                },
                jailJobsCarryInspectKey = {
                    description = "Código de control usado para inspeccionar las cajas del trabajo de carga.",
                    label = "Tecla de inspección",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Objetos basura que se pueden encontrar al inspeccionar las cajas del trabajo de carga.",
                    label = "Objetos basura de inspección",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Probabilidad de obtener una recompensa utilizable al inspeccionar cajas.",
                    label = "Probabilidad de botín utilizable",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Objetos utilizables que se pueden encontrar al inspeccionar las cajas del trabajo de carga.",
                    label = "Objetos utilizables de inspección",
                },
                jailJobsCarryInteractDistance = {
                    description = "Distancia de interacción para el trabajo de carga en la cárcel.",
                    label = "Distancia de interacción de carga",
                },
                jailJobsCarryMaxDistance = {
                    description = "Distancia máxima permitida para avanzar en el trabajo de carga en la cárcel.",
                    label = "Distancia máxima de carga",
                },
                jailJobsCarryPickupKey = {
                    description = "Código de control usado para recoger las cajas del trabajo de carga.",
                    label = "Tecla de recogida de carga",
                },
                jailJobsCarryPickupOffset = {
                    description = "Objeto de desplazamiento usado para el punto de recogida del trabajo de carga.",
                    label = "Desplazamiento de recogida",
                },
                jailJobsCarryTimeReduction = {
                    description = "Reducción de condena por completar el trabajo de carga en la cárcel.",
                    label = "Reducción de tiempo por carga",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Código de control usado en el contenedor de basura de la cárcel.",
                    label = "Tecla del contenedor",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modelo usado para el prop del contenedor de limpieza de la cárcel.",
                    label = "Modelo del contenedor",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Probabilidad de encontrar contrabando mientras se limpia.",
                    label = "Probabilidad de hallazgo ilegal",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Objetos que se pueden encontrar mientras se limpia en la cárcel.",
                    label = "Objetos de hallazgo ilegal",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Tiempo de espera para los avisos de hallazgo ilegal en milisegundos.",
                    label = "Tiempo de espera del aviso de hallazgo",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distancia usada para la interacción con la basura de limpieza.",
                    label = "Distancia de interacción de limpieza",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Distancia máxima antes de que los props de limpieza se reinicien o desaparezcan.",
                    label = "Distancia máxima de limpieza",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Máximo de props de basura simultáneos para la limpieza de la cárcel.",
                    label = "Máximo de props de basura",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Distancia mínima desde el centro para la aparición de basura de limpieza.",
                    label = "Radio mínimo de aparición",
                },
                jailJobsCleaningPickupKey = {
                    description = "Código de control usado para recoger la basura de limpieza de la cárcel.",
                    label = "Tecla de recogida de limpieza",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Milisegundos entre intentos de aparición de basura de limpieza.",
                    label = "Intervalo de aparición de basura",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Radio usado para generar los props de basura de limpieza.",
                    label = "Radio de aparición de basura",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modelos de props de basura usados para el trabajo de limpieza en la cárcel.",
                    itemLabel = "Modelo",
                    label = "Modelos de basura",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Color RGBA del contorno usado para los props de basura de limpieza en la cárcel.",
                    label = "Color del contorno",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Habilitar contornos en los props de basura de limpieza en la cárcel.",
                    label = "Contorno de basura",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID del shader usado para los contornos de la basura de limpieza en la cárcel.",
                    label = "Shader del contorno",
                },
                jailJobsTimeReduction = {
                    description = "Reducción de condena por completar el trabajo de limpieza en la cárcel.",
                    label = "Reducción de tiempo por limpieza",
                },
                jailJobsTrashGoal = {
                    description = "Cantidad de basura necesaria para completar el trabajo de limpieza en la cárcel.",
                    label = "Meta de basura de limpieza",
                },
                jailMaxMonths = {
                    description = "Duración máxima de cárcel seleccionable.",
                    label = "Meses máximos",
                },
                jailMinMonths = {
                    description = "Duración mínima de cárcel seleccionable.",
                    label = "Meses mínimos",
                },
                jailMonthMinutes = {
                    description = "Minutos en tiempo real que representa un mes de cárcel.",
                    label = "Minutos por mes",
                },
                jailObjectStreamDistance = {
                    description = "Distancia usada para la carga de objetos persistentes del mundo de la cárcel.",
                    label = "Distancia de carga de objetos",
                },
                jailOutfitApplyDelayMs = {
                    description = "Retraso tras unirse antes de aplicar el vestuario de la cárcel.",
                    label = "Retraso de aplicación del vestuario",
                },
                jailOutfitEnabled = {
                    description = "Habilitar los vestuarios de la cárcel.",
                    label = "Vestuario de la cárcel",
                },
                jailOutfitFemaleArms = {
                    description = "Componente de brazos del vestuario femenino de la cárcel.",
                    label = "Brazos",
                },
                jailOutfitFemaleChain1 = {
                    description = "Drawable de la cadena del vestuario femenino de la cárcel.",
                    label = "Cadena 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Textura de la cadena del vestuario femenino de la cárcel.",
                    label = "Cadena 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Drawable de las calcomanías del vestuario femenino de la cárcel.",
                    label = "Calcomanías 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Textura de las calcomanías del vestuario femenino de la cárcel.",
                    label = "Calcomanías 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Drawable de las gafas del vestuario femenino de la cárcel (-1 quita las gafas).",
                    label = "Gafas 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Textura de las gafas del vestuario femenino de la cárcel.",
                    label = "Gafas 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Drawable del casco del vestuario femenino de la cárcel.",
                    label = "Casco 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Textura del casco del vestuario femenino de la cárcel.",
                    label = "Casco 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Drawable del pantalón del vestuario femenino de la cárcel.",
                    label = "Pantalón 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Textura del pantalón del vestuario femenino de la cárcel.",
                    label = "Pantalón 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Drawable de los zapatos del vestuario femenino de la cárcel.",
                    label = "Zapatos 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Textura de los zapatos del vestuario femenino de la cárcel.",
                    label = "Zapatos 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Drawable del torso del vestuario femenino de la cárcel.",
                    label = "Torso 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Textura del torso del vestuario femenino de la cárcel.",
                    label = "Torso 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Drawable de la camiseta del vestuario femenino de la cárcel.",
                    label = "Camiseta 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Textura de la camiseta del vestuario femenino de la cárcel.",
                    label = "Camiseta 2",
                },
                jailOutfitMaleArms = {
                    description = "Componente de brazos del vestuario masculino de la cárcel.",
                    label = "Brazos",
                },
                jailOutfitMaleChain1 = {
                    description = "Drawable de la cadena del vestuario masculino de la cárcel.",
                    label = "Cadena 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Textura de la cadena del vestuario masculino de la cárcel.",
                    label = "Cadena 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Drawable de las calcomanías del vestuario masculino de la cárcel.",
                    label = "Calcomanías 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Textura de las calcomanías del vestuario masculino de la cárcel.",
                    label = "Calcomanías 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Drawable de las gafas del vestuario masculino de la cárcel (-1 quita las gafas).",
                    label = "Gafas 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Textura de las gafas del vestuario masculino de la cárcel.",
                    label = "Gafas 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Drawable del casco del vestuario masculino de la cárcel.",
                    label = "Casco 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Textura del casco del vestuario masculino de la cárcel.",
                    label = "Casco 2",
                },
                jailOutfitMalePants1 = {
                    description = "Drawable del pantalón del vestuario masculino de la cárcel.",
                    label = "Pantalón 1",
                },
                jailOutfitMalePants2 = {
                    description = "Textura del pantalón del vestuario masculino de la cárcel.",
                    label = "Pantalón 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Drawable de los zapatos del vestuario masculino de la cárcel.",
                    label = "Zapatos 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Textura de los zapatos del vestuario masculino de la cárcel.",
                    label = "Zapatos 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Drawable del torso del vestuario masculino de la cárcel.",
                    label = "Torso 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Textura del torso del vestuario masculino de la cárcel.",
                    label = "Torso 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Drawable de la camiseta del vestuario masculino de la cárcel.",
                    label = "Camiseta 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Textura de la camiseta del vestuario masculino de la cárcel.",
                    label = "Camiseta 2",
                },
                jailRequireJailTerminal = {
                    description = "Permitir condenas de cárcel de agentes solo cerca de una terminal de la cárcel seleccionada.",
                    label = "Requerir terminal de cárcel",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Restaurar el atuendo civil guardado cuando un recluso se fuga.",
                    label = "Restaurar vestuario tras la fuga",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Ventana de gracia después de la restauración antes de que deje de aplicarse la corrección de aparición.",
                    label = "Ventana de corrección de restauración",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teletransportar a los reclusos restaurados de vuelta al punto de aparición de la cárcel si cargan fuera de la zona de la cárcel.",
                    label = "Teletransportar reclusos restaurados",
                },
                jailTerminalRange = {
                    description = "Distancia máxima del agente a una terminal de la cárcel seleccionada.",
                    label = "Distancia de terminal",
                },
                jailZoneExitGraceMs = {
                    description = "Ventana de gracia antes de que una salida de la zona de la cárcel cuente como fuga.",
                    label = "Gracia de salida de zona",
                },
                mugshotAnimDict = {
                    description = "Diccionario de animación usado durante la captura de la foto de ingreso.",
                    label = "Diccionario de animación",
                },
                mugshotAnimFlag = {
                    description = "Bandera de animación usada durante la captura de la foto de ingreso.",
                    label = "Bandera de la animación",
                },
                mugshotAnimName = {
                    description = "Nombre de animación usado durante la captura de la foto de ingreso.",
                    label = "Nombre de la animación",
                },
                mugshotBoardHeader = {
                    description = "Encabezado principal mostrado en el panel de la foto de ingreso.",
                    label = "Encabezado del panel",
                },
                mugshotBoardSubheader = {
                    description = "Subencabezado alternativo mostrado en el panel de la foto de ingreso.",
                    label = "Subencabezado del panel",
                },
                mugshotCameraCoordsX = {
                    description = "Coordenada X del mundo de la cámara usada para las fotos de ingreso.",
                    label = "Cámara X",
                },
                mugshotCameraCoordsY = {
                    description = "Coordenada Y del mundo de la cámara usada para las fotos de ingreso.",
                    label = "Cámara Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Coordenada Z del mundo de la cámara usada para las fotos de ingreso.",
                    label = "Cámara Z",
                },
                mugshotCameraFov = {
                    description = "Campo de visión usado para las capturas de la foto de ingreso.",
                    label = "FOV de la cámara",
                },
                mugshotCameraRotX = {
                    description = "Rotación X de la cámara usada para las fotos de ingreso.",
                    label = "Rotación X",
                },
                mugshotCameraRotY = {
                    description = "Rotación Y de la cámara usada para las fotos de ingreso.",
                    label = "Rotación Y",
                },
                mugshotCameraRotZ = {
                    description = "Rotación Z de la cámara usada para las fotos de ingreso.",
                    label = "Rotación Z",
                },
                mugshotCaptureTimeout = {
                    description = "Milisegundos máximos permitidos para las devoluciones de llamada de captura de la foto de ingreso.",
                    label = "Tiempo de espera de captura",
                },
                mugshotEnabled = {
                    description = "Habilitar la captura de la foto de ingreso durante el proceso de admisión en la cárcel.",
                    label = "Captura de foto de ingreso",
                },
                mugshotHeading = {
                    description = "Orientación aplicada durante la captura de la foto de ingreso.",
                    label = "Orientación",
                },
                mugshotLocationX = {
                    description = "Coordenada X del mundo usada para la captura de la foto de ingreso.",
                    label = "Ubicación X",
                },
                mugshotLocationY = {
                    description = "Coordenada Y del mundo usada para la captura de la foto de ingreso.",
                    label = "Ubicación Y",
                },
                mugshotLocationZ = {
                    description = "Coordenada Z del mundo usada para la captura de la foto de ingreso.",
                    label = "Ubicación Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Formato de descripción usado para los metadatos almacenados de la foto de ingreso.",
                    label = "Descripción de metadatos",
                },
                mugshotMetadataName = {
                    description = "Nombre de metadatos de inventario usado para la foto de ingreso almacenada.",
                    label = "Nombre de metadatos",
                },
                mugshotWaitMs = {
                    description = "Milisegundos de espera antes de tomar la foto de ingreso.",
                    label = "Milisegundos de espera",
                },
                playerSearchAnimDict = {
                    description = "Diccionario de animación usado durante las búsquedas de jugadores.",
                    label = "Diccionario de animación",
                },
                playerSearchAnimFlag = {
                    description = "Bandera de animación usada durante las búsquedas de jugadores.",
                    label = "Bandera de la animación",
                },
                playerSearchAnimName = {
                    description = "Nombre de animación usado durante las búsquedas de jugadores.",
                    label = "Nombre de la animación",
                },
                playerSearchDurationMs = {
                    description = "Duración de la vista previa de búsqueda de jugador en milisegundos.",
                    label = "Duración de la búsqueda",
                },
                playerSearchEnabled = {
                    description = "Habilitar el flujo de vista previa de búsqueda de jugadores.",
                    label = "Búsqueda de jugadores",
                },
                playerSearchRange = {
                    description = "Distancia máxima para iniciar una búsqueda de jugador.",
                    label = "Alcance de búsqueda",
                },
                playerSearchScenario = {
                    description = "Escenario usado cuando no se reproduce una animación de búsqueda explícita.",
                    label = "Escenario de búsqueda",
                },
                policeBillingControl200 = {
                    label = "Facturación · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeBillingControl322 = {
                    label = "Facturación · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl10 = {
                    label = "Editor · PAGEUP",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl11 = {
                    label = "Editor · PAGEDOWN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl172 = {
                    label = "Editor · UP",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl173 = {
                    label = "Editor · DOWN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl174 = {
                    label = "Editor · LEFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl175 = {
                    label = "Editor · RIGHT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl177 = {
                    label = "Editor · BACK",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl191 = {
                    label = "Editor · RETURN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl201 = {
                    label = "Editor · RETURN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl202 = {
                    label = "Editor · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl21 = {
                    label = "Editor · LSHIFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl32 = {
                    label = "Editor · W",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl322 = {
                    label = "Editor · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl33 = {
                    label = "Editor · S",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl34 = {
                    label = "Editor · A",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl35 = {
                    label = "Editor · D",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl36 = {
                    label = "Editor · LCONTROL",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl37 = {
                    label = "Editor · TAB",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl38 = {
                    label = "Editor · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl44 = {
                    label = "Editor · Q",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policeEditorControl73 = {
                    label = "Editor · X",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                policePrimaryColor = {
                    description = "Color predeterminado para el grupo de trabajos de policía.",
                    label = "Color primario",
                },
                propPlacementConsumeItem = {
                    description = "Quitar un objeto del inventario al colocar un prop.",
                    label = "Consumir objeto del prop",
                },
                propPlacementEnabled = {
                    description = "Permitir colocar los props policiales configurados desde objetos o vehículos.",
                    label = "Colocación de props",
                },
                propPlacementItemNames = {
                    description = "Asignar modelos de props a nombres de objetos de inventario para la colocación de props basada en objetos.",
                    label = "Nombres de objetos de props",
                },
                propPlacementRequireOnDuty = {
                    description = "Solo los agentes de servicio pueden colocar props configurados.",
                    label = "Props requieren servicio",
                },
                propPlacementReturnItem = {
                    description = "Devolver el objeto consumido cuando se retira un prop colocado.",
                    label = "Devolver objeto del prop",
                },
                propPlacementVehicleAccess = {
                    description = "Permitir que los vehículos del trabajo expongan su equipamiento de props configurado.",
                    label = "Acceso a props del vehículo",
                },
                radialEnabled = {
                    description = "Habilitar las acciones radiales policiales.",
                    label = "Radial policial",
                },
                radialHandcuffKeybindCommand = {
                    description = "Nombre del comando registrado para el atajo de esposas.",
                    label = "Comando de esposas",
                },
                radialHandcuffKeybindDescription = {
                    description = "Descripción mostrada para el atajo de esposas.",
                    label = "Descripción de esposas",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Habilitar el atajo directo para esposar.",
                    label = "Atajo de esposas",
                },
                radialHandcuffKeybindKey = {
                    description = "Tecla del teclado usada para la acción directa de esposar.",
                    label = "Tecla de esposas",
                },
                radialKeybindsEnabled = {
                    description = "Habilitar atajos de teclado directos para las acciones radiales seleccionadas.",
                    label = "Atajos directos",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Nombre del comando registrado para el atajo de quitar esposas.",
                    label = "Comando para quitar esposas",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Descripción mostrada para el atajo de quitar esposas.",
                    label = "Descripción para quitar esposas",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Habilitar el atajo directo para quitar esposas.",
                    label = "Atajo para quitar esposas",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Tecla del teclado usada para la acción directa de quitar esposas.",
                    label = "Tecla para quitar esposas",
                },
                socialWorkAssignRange = {
                    description = "Distancia máxima para asignar tareas de trabajo social.",
                    label = "Distancia de asignación",
                },
                socialWorkDeadlineDefault = {
                    description = "Fecha límite predeterminada de trabajo social en minutos. Cero desactiva las fechas límite.",
                    label = "Fecha límite predeterminada",
                },
                socialWorkDeadlineMax = {
                    description = "Fecha límite máxima de trabajo social en minutos. Cero desactiva el límite.",
                    label = "Fecha límite máxima",
                },
                socialWorkDeadlineMin = {
                    description = "Fecha límite mínima de trabajo social en minutos.",
                    label = "Fecha límite mínima",
                },
                socialWorkDefaultTasks = {
                    description = "Cantidad de tareas predeterminada al abrir la asignación de trabajo social.",
                    label = "Tareas predeterminadas",
                },
                socialWorkEnabled = {
                    description = "Habilitar los flujos de asignación y tareas de trabajo social.",
                    label = "Trabajo social",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID de cárcel usada cuando las infracciones de trabajo social conllevan encarcelamiento.",
                    label = "ID de cárcel alternativa",
                },
                socialWorkImprisonmentMonths = {
                    description = "Meses asignados cuando las infracciones de trabajo social resultan en cárcel.",
                    label = "Meses de encarcelamiento",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Nombre de oficial usado para los registros de encarcelamiento por trabajo social.",
                    label = "Nombre del oficial de encarcelamiento",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Enviar a los infractores a aislamiento cuando se activa el encarcelamiento.",
                    label = "Usar aislamiento",
                },
                socialWorkInactivityMinutes = {
                    description = "Minutos antes de que se apliquen las penalizaciones por inactividad en trabajo social.",
                    label = "Minutos de inactividad",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Penalización de tareas aplicada cuando un jugador de trabajo social permanece inactivo demasiado tiempo.",
                    label = "Penalización de tareas por inactividad",
                },
                socialWorkMaxTasks = {
                    description = "Cantidad máxima seleccionable de tareas de trabajo social.",
                    label = "Tareas máximas",
                },
                socialWorkMinTasks = {
                    description = "Cantidad mínima seleccionable de tareas de trabajo social.",
                    label = "Tareas mínimas",
                },
                speedCamBillingEnabled = {
                    description = "Emitir facturas automáticas cuando las cámaras de velocidad capturen una infracción coincidente. Requiere que la función global de Facturación esté habilitada.",
                    label = "Multas automáticas",
                },
                speedCamBillingExcludedJobs = {
                    description = "Trabajos que nunca reciben facturas automáticas de radares de velocidad.",
                    itemLabel = "Trabajo",
                    label = "Trabajos excluidos",
                },
                speedCamBillingExcludedModels = {
                    description = "Nombres de aparición de vehículos que nunca reciben facturas automáticas de radares de velocidad.",
                    itemLabel = "Modelo",
                    label = "Modelos de vehículo excluidos",
                },
                speedCamBillingRules = {
                    description = "Reglas de multa usadas por las cámaras de velocidad. Se factura primero el rango de exceso que coincida más estrechamente; si ninguna regla coincide, se usan las infracciones de SpeedViolation como alternativa.",
                    label = "Reglas de multa",
                },
                speedCamCameraEaseMs = {
                    description = "Cuánto tarda la vista en ajustarse al ángulo de la cámara de velocidad. Menor = movimiento más corto; demasiado bajo puede desalinear la foto.",
                    label = "Transición de la cámara (ms)",
                },
                speedCamCameraFov = {
                    description = "Campo de visión usado para las capturas de la cámara de velocidad.",
                    label = "FOV de la cámara",
                },
                speedCamCheckIntervalMs = {
                    description = "Milisegundos entre escaneos de la cámara de velocidad.",
                    label = "Intervalo de comprobación",
                },
                speedCamCooldownMs = {
                    description = "Milisegundos antes de que la misma cámara de velocidad pueda activarse de nuevo.",
                    label = "Enfriamiento de activación",
                },
                speedCamDamageCooldownMs = {
                    description = "Milisegundos antes de que la cámara de velocidad pueda volver a recibir daño.",
                    label = "Enfriamiento de daño",
                },
                speedCamDamagePerHit = {
                    description = "Daño de durabilidad aplicado a las cámaras de velocidad por cada impacto.",
                    label = "Daño por impacto",
                },
                speedCamDamagedModelThreshold = {
                    description = "Porcentaje de la durabilidad máxima a partir del cual, hacia abajo, se muestra el modelo dañado. Ejemplo: 50 con una durabilidad máxima de 200 cambia el modelo al llegar a 100.",
                    label = "Umbral del modelo dañado (%)",
                },
                speedCamDefaultLimit = {
                    description = "Límite predeterminado de la cámara de velocidad.",
                    label = "Límite de velocidad predeterminado",
                },
                speedCamDefaultName = {
                    description = "Nombre visible sugerido al colocar un radar. Se puede traducir sin cambiar el objeto del inventario ni el modelo.",
                    label = "Nombre predeterminado",
                },
                speedCamDefaultTolerance = {
                    description = "Tolerancia predeterminada de la cámara de velocidad.",
                    label = "Tolerancia predeterminada",
                },
                speedCamDisassembleDistance = {
                    description = "Distancia usada para desmontar cámaras de velocidad.",
                    label = "Distancia de desmontaje",
                },
                speedCamEnabled = {
                    description = "Habilitar las cámaras de velocidad portátiles.",
                    label = "Cámaras de velocidad",
                },
                speedCamFlashColor = {
                    description = "Color RGBA del flash usado por las cámaras de velocidad.",
                    label = "Color del flash",
                },
                speedCamFlashDurationMs = {
                    description = "Tiempo de desvanecimiento del flash rojo de la cámara de velocidad. No configurar demasiado bajo o se hará visible el movimiento de la cámara.",
                    label = "Duración del flash (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distancia a la que se muestra el estado de la cámara de velocidad.",
                    label = "Distancia de visualización de estado",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Milisegundos que permanece visible el estado de la cámara de velocidad.",
                    label = "Duración de visualización de estado",
                },
                speedCamHealthTextOffset = {
                    description = "Desplazamiento vertical usado para el texto de estado de la cámara de velocidad.",
                    label = "Desplazamiento del texto de estado",
                },
                speedCamItem = {
                    description = "Nombre interno exacto del objeto en el inventario, p. ej. speedcam. Introduce la clave del objeto, no su nombre visible; la tienda del trabajo debe entregar el mismo objeto.",
                    label = "Nombre del objeto del radar",
                },
                speedCamMaintenanceThreshold = {
                    description = "Umbral de durabilidad en el que se recomienda el mantenimiento de la cámara de velocidad.",
                    label = "Umbral de mantenimiento",
                },
                speedCamMaxDurability = {
                    description = "Durabilidad máxima de las cámaras de velocidad desplegadas.",
                    label = "Durabilidad máxima",
                },
                speedCamMaxLimit = {
                    description = "Límite máximo configurable de la cámara de velocidad.",
                    label = "Límite de velocidad máximo",
                },
                speedCamMaxTolerance = {
                    description = "Tolerancia máxima configurable de la cámara de velocidad.",
                    label = "Tolerancia máxima",
                },
                speedCamPhotoLocale = {
                    description = "Configuración regional opcional usada para la marca de tiempo en las fotos de la cámara de velocidad. Dejar vacío para usar la configuración regional local del jugador fotografiado.",
                    label = "Configuración regional de la foto",
                },
                speedCamPhotoTimeZone = {
                    description = "Zona horaria opcional usada para la marca de tiempo en las fotos de la cámara de velocidad. Dejar vacío para usar la zona horaria local del jugador fotografiado.",
                    label = "Zona horaria de la foto",
                },
                speedCamPoliceNotification = {
                    description = "Enviar una notificación de despacho cuando las cámaras de velocidad capturen infracciones.",
                    label = "Alerta policial de cámara de velocidad",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Tratar el objetivo del despacho de la cámara de velocidad como un grupo de trabajo.",
                    label = "Objetivo del despacho es grupo",
                },
                speedCamPoliceNotificationJob = {
                    description = "Clave de trabajo o grupo usada para las notificaciones de despacho de la cámara de velocidad.",
                    label = "Objetivo del despacho",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Notificar solo a los objetivos de despacho de la cámara de velocidad que estén de servicio.",
                    label = "Despacho requiere servicio",
                },
                speedCamPoliceNotificationType = {
                    description = "Severidad/tipo de despacho usado para las alertas de la cámara de velocidad.",
                    label = "Tipo de despacho",
                },
                speedCamPropModel = {
                    description = "Nombre de aparición del modelo intacto del radar, p. ej. sky_speedcam. Un ajuste predefinido también selecciona los modelos dañado y destruido. Los modelos personalizados deben estar disponibles en el juego.",
                    label = "Modelo del prop de la cámara de velocidad",
                    custom = "Modelo personalizado",
                    choose = "Elegir modelo",
                    preview = "Vista previa 3D",
                    customPlaceholder = "Nombre de aparición del objeto",
                    previewDescription = "Muestra el objeto elegido en el juego. La vista previa no guarda cambios.",
                    invalidModel = "Introduce primero un nombre de objeto válido.",
                    modelMissing = "Este modelo no está disponible en el juego.",
                    previewFailed = "No se pudo abrir la vista previa del modelo.",
                    intact = "Modelo intacto",
                    previewRequiresGame = "Abre /jobconfig en FiveM para ver el objeto en directo.",
                    previewHelp = "Flechas: mover; Re Pág/Av Pág: altura; rueda: girar; Intro: cerrar; Retroceso: cancelar.",
                    options = {
                        sky_speedcam = "Radar estándar",
                        sky_germ_speedcam = "Radar alemán",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Nombre de aparición del modelo dañado del radar, p. ej. sky_speedcam2. Usa una variante que corresponda al modelo intacto.",
                    label = "Modelo de prop dañado",
                },
                speedCamPropModelDestroyed = {
                    description = "Nombre del modelo mostrado cuando la durabilidad llega a 0, p. ej. sky_speedcam1. Usa una variante que corresponda al modelo intacto.",
                    label = "Modelo de prop destruido",
                },
                speedCamRepairAnimDict = {
                    description = "Diccionario de animación usado al reparar cámaras de velocidad.",
                    label = "Diccionario de animación de reparación",
                },
                speedCamRepairAnimFlag = {
                    description = "Bandera de animación usada al reparar cámaras de velocidad.",
                    label = "Bandera de la animación de reparación",
                },
                speedCamRepairAnimName = {
                    description = "Nombre de animación usado al reparar cámaras de velocidad.",
                    label = "Nombre de la animación de reparación",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Milisegundos antes de que se pueda cancelar la reparación de la cámara de velocidad.",
                    label = "Retraso de cancelación de reparación",
                },
                speedCamRepairDistance = {
                    description = "Distancia usada para reparar cámaras de velocidad.",
                    label = "Distancia de reparación",
                },
                speedCamRepairItem = {
                    description = "Nombre interno exacto del objeto de reparación, p. ej. fixtool. Introduce la clave del objeto, no su nombre visible.",
                    label = "Nombre del objeto de reparación",
                },
                speedCamRepairPerTick = {
                    description = "Durabilidad restaurada por cada pulso de reparación de la cámara de velocidad.",
                    label = "Reparación por pulso",
                },
                speedCamRepairTickMs = {
                    description = "Milisegundos entre pulsos de reparación de la cámara de velocidad.",
                    label = "Intervalo de reparación",
                },
                speedCamStreamDistance = {
                    description = "Distancia al jugador en metros dentro de la cual se cargan los modelos de los radares. Fuera de ella se descargan los modelos; los radares guardados siguen colocados.",
                    label = "Distancia de carga",
                },
                speedCamTriggerRadius = {
                    description = "Radio de detección en metros alrededor del radar para vehículos que superan la velocidad permitida.",
                    label = "Radio de activación",
                },
                speedCamUseMph = {
                    description = "Mostrar y procesar los límites de la cámara de velocidad en MPH.",
                    label = "Usar MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Armas permitidas para dañar las cámaras de velocidad mientras la restricción esté habilitada.",
                    itemLabel = "Arma",
                    label = "Armas permitidas",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Solo las armas listadas pueden dañar las cámaras de velocidad mientras esto esté habilitado.",
                    label = "Restricción habilitada",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distancia en metros antes de eliminar las advertencias de cámara de velocidad.",
                    label = "Distancia de limpieza",
                },
                speedCameraAppDefaultApp = {
                    description = "Mostrar la aplicación de cámara de velocidad como aplicación predeterminada de la tableta.",
                    label = "Aplicación predeterminada",
                },
                speedCameraAppDescription = {
                    description = "Descripción mostrada para la aplicación de cámara de velocidad de la tableta.",
                    label = "Descripción",
                },
                speedCameraAppDeveloper = {
                    description = "Etiqueta de desarrollador mostrada para la aplicación de cámara de velocidad de la tableta.",
                    label = "Desarrollador",
                },
                speedCameraAppEnabled = {
                    description = "Habilitar la aplicación de cámara de velocidad en la tableta policial.",
                    label = "Aplicación de cámara de velocidad",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Ceja del encabezado mostrada en la aplicación de cámara de velocidad.",
                    label = "Ceja del encabezado",
                },
                speedCameraAppHeaderTitle = {
                    description = "Título del encabezado mostrado en la aplicación de cámara de velocidad.",
                    label = "Título del encabezado",
                },
                speedCameraAppIcon = {
                    description = "Ruta del ícono usada para la aplicación de cámara de velocidad de la tableta.",
                    label = "Ruta del ícono",
                },
                speedCameraAppIdentifier = {
                    description = "Identificador interno de la aplicación de cámara de velocidad de la tableta.",
                    label = "Identificador",
                },
                speedCameraAppInFrontDot = {
                    description = "Umbral de producto punto usado para determinar si una cámara de velocidad está al frente del jugador.",
                    label = "Punto de frente",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Velocidad mínima del vehículo en KMH antes de mostrar advertencias.",
                    label = "Velocidad mínima del vehículo",
                },
                speedCameraAppName = {
                    description = "Nombre visible de la aplicación de cámara de velocidad de la tableta.",
                    label = "Nombre de la aplicación",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distancia en metros antes de avisar sobre cámaras de velocidad cercanas.",
                    label = "Distancia de aviso",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Advertir sobre cámaras de velocidad solo mientras el jugador esté en un vehículo.",
                    label = "Solo en vehículo",
                },
                speedCameraAppOverlayBackground = {
                    description = "Color de fondo usado para la superposición de la imagen de la placa.",
                    label = "Fondo de la superposición",
                },
                speedCameraAppOverlayBorder = {
                    description = "Color del borde usado para la superposición de la imagen de la placa.",
                    label = "Borde de la superposición",
                },
                speedCameraAppOverlayColor = {
                    description = "Color del texto usado para la superposición de la imagen de la placa.",
                    label = "Color de la superposición",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Habilitar la superposición de la imagen de la placa en las imágenes capturadas por la cámara de velocidad.",
                    label = "Superposición habilitada",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Escala de fuente usada para la superposición de la imagen de la placa.",
                    label = "Escala de fuente de la superposición",
                },
                speedCameraAppOverlayX = {
                    description = "Posición X normalizada de la superposición, de izquierda a derecha.",
                    label = "Superposición X",
                },
                speedCameraAppOverlayY = {
                    description = "Posición Y normalizada de la superposición, de arriba a abajo.",
                    label = "Superposición Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Advertir solo sobre cámaras de velocidad que estén al frente del jugador.",
                    label = "Requerir al frente",
                },
                speedCameraAppRoute = {
                    description = "Ruta del enrutador abierta por la aplicación de cámara de velocidad de la tableta.",
                    label = "Ruta",
                },
                speedCameraAppSize = {
                    description = "Tamaño de almacenamiento reportado para la aplicación de cámara de velocidad de la tableta.",
                    label = "Tamaño de la aplicación",
                },
                speedCameraAppSoundCoord = {
                    description = "Reproducir los sonidos de advertencia de cámara de velocidad en coordenadas del mundo.",
                    label = "Sonido por coordenadas",
                },
                speedCameraAppSoundEnabled = {
                    description = "Habilitar sonidos de advertencia para la aplicación de cámara de velocidad.",
                    label = "Sonido habilitado",
                },
                speedCameraAppSoundFrontend = {
                    description = "Reproducir los sonidos de advertencia de cámara de velocidad en el canal de audio frontend.",
                    label = "Sonido de frontend",
                },
                speedCameraAppSoundLayers = {
                    description = "Número de sonidos de advertencia superpuestos reproducidos por la aplicación de cámara de velocidad.",
                    label = "Capas de sonido",
                },
                speedCameraAppSoundName = {
                    description = "Nombre del sonido usado para las advertencias de la aplicación de cámara de velocidad.",
                    label = "Nombre del sonido",
                },
                speedCameraAppSoundRange = {
                    description = "Alcance usado para los sonidos de advertencia de la aplicación de cámara de velocidad.",
                    label = "Alcance del sonido",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Número de veces que se repite el sonido de advertencia de la cámara de velocidad.",
                    label = "Cantidad de repeticiones",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Milisegundos entre repeticiones del sonido de advertencia de la cámara de velocidad.",
                    label = "Retraso de repetición",
                },
                speedCameraAppSoundSet = {
                    description = "Conjunto de sonido usado para las advertencias de la aplicación de cámara de velocidad.",
                    label = "Conjunto de sonido",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Cuenta usada para los pagos de suscripción de la aplicación de cámara de velocidad de la tableta.",
                    label = "Cuenta",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Habilitar suscripciones de pago para la aplicación de cámara de velocidad de la tableta.",
                    label = "Suscripción habilitada",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Días entre renovaciones de la suscripción de la aplicación de cámara de velocidad de la tableta.",
                    label = "Días de intervalo",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Precio cobrado por la suscripción a la aplicación de cámara de velocidad de la tableta.",
                    label = "Precio de suscripción",
                },
                speedCameraAppThemeAccent = {
                    description = "Color de acento usado por la aplicación de cámara de velocidad.",
                    label = "Acento",
                },
                speedCameraAppThemeBackground = {
                    description = "Fondo de gradiente lineal usado por la aplicación de cámara de velocidad.",
                    label = "Fondo",
                },
                speedCameraAppThemeBorder = {
                    description = "Color de borde usado por la aplicación de cámara de velocidad.",
                    label = "Borde",
                },
                speedCameraAppThemeButtonText = {
                    description = "Color del texto del botón usado por la aplicación de cámara de velocidad.",
                    label = "Texto del botón",
                },
                speedCameraAppThemeDanger = {
                    description = "Color de peligro usado por la aplicación de cámara de velocidad.",
                    label = "Peligro",
                },
                speedCameraAppThemeGhost = {
                    description = "Color del botón fantasma usado por la aplicación de cámara de velocidad.",
                    label = "Botón fantasma",
                },
                speedCameraAppThemeGhostText = {
                    description = "Color del texto del botón fantasma usado por la aplicación de cámara de velocidad.",
                    label = "Texto fantasma",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Color de gradiente suave usado por la aplicación de cámara de velocidad.",
                    label = "Gradiente suave",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Color de borde inactivo usado por la aplicación de cámara de velocidad.",
                    label = "Borde inactivo",
                },
                speedCameraAppThemeModal = {
                    description = "Color de fondo del modal usado por la aplicación de cámara de velocidad.",
                    label = "Modal",
                },
                speedCameraAppThemeMutedText = {
                    description = "Color de texto atenuado usado por la aplicación de cámara de velocidad.",
                    label = "Texto atenuado",
                },
                speedCameraAppThemeOverlay = {
                    description = "Color de superposición usado por la aplicación de cámara de velocidad.",
                    label = "Superposición",
                },
                speedCameraAppThemePillText = {
                    description = "Color del texto de las etiquetas usado por la aplicación de cámara de velocidad.",
                    label = "Texto de etiqueta",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Color inicial del gradiente primario usado por la aplicación de cámara de velocidad.",
                    label = "Inicio del primario",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Color final del gradiente primario usado por la aplicación de cámara de velocidad.",
                    label = "Fin del primario",
                },
                speedCameraAppThemeShadow = {
                    description = "Color de sombra usado por la aplicación de cámara de velocidad.",
                    label = "Sombra",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Color de acento del foco usado por la aplicación de cámara de velocidad.",
                    label = "Foco",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Color de texto sutil usado por la aplicación de cámara de velocidad.",
                    label = "Texto sutil",
                },
                speedCameraAppThemeSuccess = {
                    description = "Color de éxito usado por la aplicación de cámara de velocidad.",
                    label = "Éxito",
                },
                speedCameraAppThemeSurface = {
                    description = "Color de superficie usado por la aplicación de cámara de velocidad.",
                    label = "Superficie",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Color de superficie suave usado por la aplicación de cámara de velocidad.",
                    label = "Superficie suave",
                },
                speedCameraAppThemeText = {
                    description = "Color de texto principal usado por la aplicación de cámara de velocidad.",
                    label = "Texto",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Color de acento RGBA usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Acento RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Color RGBA usado para el fondo de la interfaz de advertencia de cámara de velocidad.",
                    label = "Fondo RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Color RGBA del ícono usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Ícono RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Color RGBA del texto del ícono usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Texto del ícono RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Segundos que la interfaz de advertencia permanece visible.",
                    label = "Segundos de la interfaz de advertencia",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Color RGBA del subtexto usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Subtexto RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Color RGBA del texto usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Texto RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Color RGBA del título usado para la interfaz de advertencia de cámara de velocidad.",
                    label = "Título RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Milisegundos entre comprobaciones de proximidad de bandas de pinchos.",
                    label = "Intervalo de comprobación",
                },
                spikeStripsEnabled = {
                    description = "Habilitar las bandas de pinchos desplegadas.",
                    label = "Bandas de pinchos",
                },
                spikeStripsModels = {
                    description = "Modelos de props tratados como bandas de pinchos activas.",
                    itemLabel = "Modelo",
                    label = "Modelos",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Milisegundos antes de reintentar el escaneo de bandas de pinchos tras no encontrar coincidencia.",
                    label = "Intervalo de reintento",
                },
                spikeStripsScanDistance = {
                    description = "Distancia usada para escanear bandas de pinchos cercanas.",
                    label = "Distancia de escaneo",
                },
                spikeStripsTriggerDistance = {
                    description = "Distancia a la que las ruedas revientan por una banda de pinchos.",
                    label = "Distancia de activación",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Etiqueta de categoría usada para los blips del creador de estaciones.",
                    label = "Categoría del blip de la estación",
                },
                stationCreatorBlipColor = {
                    description = "Color del blip del mapa usado para las estaciones de policía.",
                    label = "Color del blip de la estación",
                },
                stationCreatorBlipScale = {
                    description = "Escala usada para los blips de las estaciones de policía.",
                    label = "Escala del blip de la estación",
                },
                stationCreatorBlipShortRange = {
                    description = "Mostrar los blips de la estación solo a corta distancia.",
                    label = "Blip de la estación de corto alcance",
                },
                stationCreatorBlipSprite = {
                    description = "Sprite del blip del mapa usado para las estaciones de policía.",
                    label = "Sprite del blip de la estación",
                },
                stationCreatorBlipUseStationName = {
                    description = "Usar el nombre configurado de la estación como etiqueta del blip del mapa.",
                    label = "Usar nombre de la estación",
                },
                tabletAutoFillCitizens = {
                    description = "Precargar el registro de ciudadanos desde la base de datos del framework.",
                    label = "Autocompletar ciudadanos",
                },
                tabletAutoFillVehicles = {
                    description = "Precargar el registro de vehículos desde la base de datos del framework.",
                    label = "Autocompletar vehículos",
                },
                tabletBolos = {
                    description = "Mostrar la aplicación de BOLOs.",
                    label = "BOLOS",
                },
                tabletCases = {
                    description = "Mostrar la aplicación de casos.",
                    label = "Casos",
                },
                tabletCitizens = {
                    description = "Mostrar la aplicación de registro de ciudadanos.",
                    label = "Ciudadanos",
                },
                tabletConfiscations = {
                    description = "Mostrar el registro de objetos incautados durante los cacheos.",
                    label = "Incautaciones",
                },
                tabletOffences = {
                    description = "Mostrar la aplicación de delitos.",
                    label = "Delitos",
                },
                tabletPrison = {
                    description = "Mostrar la aplicación de prisión.",
                    label = "Prisión",
                },
                tabletReportEnforcement = {
                    description = "Permite asignar delitos y emitir multas o condenas desde informes guardados.",
                    label = "Ejecución de informes",
                },
                tabletReports = {
                    description = "Mostrar la aplicación de informes.",
                    label = "Informes",
                },
                tabletSocialWork = {
                    description = "Mostrar la aplicación de trabajo social.",
                    label = "Trabajo social",
                },
                tabletVehicles = {
                    description = "Mostrar la aplicación de registro de vehículos.",
                    label = "Vehículos",
                },
                tabletWarrants = {
                    description = "Mostrar la aplicación de órdenes de arresto.",
                    label = "Órdenes de arresto",
                },
                tabletWeapons = {
                    description = "Mostrar la aplicación de registro de armas.",
                    label = "Armas",
                },
                tackleCuffKey = {
                    label = "Esposar a la persona derribada",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                tackleKey = {
                    label = "Derribar",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                tackleReleaseKey = {
                    label = "Soltar a la persona derribada",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Milisegundos antes de que se pueda emitir otra alerta del radar.",
                    label = "Enfriamiento de alerta",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Clases de vehículo permitidas para usar el radar.",
                    label = "Clases de vehículo permitidas",
                },
                vehicleRadarAutoFastLock = {
                    description = "Marcar automáticamente los objetivos muy rápidos en el radar.",
                    label = "Bloqueo rápido automático",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Umbral de velocidad usado para el bloqueo rápido automático.",
                    label = "Umbral de bloqueo rápido",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Asignación de tecla usada para disminuir el límite de velocidad del radar.",
                    label = "Tecla de disminuir límite",
                },
                vehicleRadarDefaultLimit = {
                    description = "Límite de velocidad predeterminado usado por el radar del vehículo.",
                    label = "Límite predeterminado del radar",
                },
                vehicleRadarEnabled = {
                    description = "Habilitar el radar del vehículo de patrulla.",
                    label = "Radar del vehículo",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Asignación de tecla usada para aumentar el límite de velocidad del radar.",
                    label = "Tecla de aumentar límite",
                },
                vehicleRadarLimitStep = {
                    description = "Cantidad cambiada por cada ajuste del límite del radar.",
                    label = "Paso del límite",
                },
                vehicleRadarLockFrontKey = {
                    description = "Asignación de tecla usada para bloquear el objetivo del radar frontal.",
                    label = "Tecla de bloqueo frontal",
                },
                vehicleRadarLockRearKey = {
                    description = "Asignación de tecla usada para bloquear el objetivo del radar trasero.",
                    label = "Tecla de bloqueo trasero",
                },
                vehicleRadarMaxLimit = {
                    description = "Límite de velocidad máximo permitido en el radar del vehículo.",
                    label = "Límite máximo del radar",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Inclinación máxima permitida para el objetivo del radar.",
                    label = "Grados máximos de inclinación",
                },
                vehicleRadarMinLimit = {
                    description = "Límite de velocidad mínimo permitido en el radar del vehículo.",
                    label = "Límite mínimo del radar",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Velocidad mínima antes de que el radar considere válido a un objetivo.",
                    label = "Velocidad mínima del objetivo",
                },
                vehicleRadarModeFrontKey = {
                    description = "Asignación de tecla usada para cambiar el modo de radar frontal.",
                    label = "Tecla de modo frontal",
                },
                vehicleRadarModeRearKey = {
                    description = "Asignación de tecla usada para cambiar el modo de radar trasero.",
                    label = "Tecla de modo trasero",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Milisegundos entre escaneos del radar mientras el vehículo de patrulla está en movimiento.",
                    label = "Intervalo de escaneo en movimiento",
                },
                vehicleRadarPassengerControl = {
                    description = "Permitir que los pasajeros controlen el radar del vehículo.",
                    label = "Control del pasajero",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Permitir que los pasajeros vean los datos reflejados del radar.",
                    label = "Espejo para el pasajero",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Milisegundos entre actualizaciones de sincronización del radar para los pasajeros.",
                    label = "Intervalo de sincronización del pasajero",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Umbral de proyección usado al evaluar los objetivos del radar.",
                    label = "Umbral de proyección",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Requerir línea de visión despejada antes de que el radar bloquee un objetivo.",
                    label = "Requerir línea de visión",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Requerir estar de servicio antes de usar el radar del vehículo.",
                    label = "Radar requiere servicio",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Milisegundos entre escaneos del radar estacionario.",
                    label = "Intervalo de escaneo",
                },
                vehicleRadarScanRadius = {
                    description = "Radio de escaneo del radar del vehículo.",
                    label = "Radio de escaneo",
                },
                vehicleRadarToggleKey = {
                    description = "Asignación de tecla usada para alternar el radar del vehículo.",
                    label = "Tecla de alternancia",
                },
                vehicleRadarUseMph = {
                    description = "Mostrar los valores de velocidad del radar en MPH.",
                    label = "Radar usa MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Milisegundos entre actualizaciones del grupo de vehículos cercanos.",
                    label = "Actualización del grupo de vehículos",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Asignación de tecla usada para XMIT/HOLD del radar frontal.",
                    label = "Tecla XMIT frontal",
                },
                vehicleRadarXmitRearKey = {
                    description = "Asignación de tecla usada para XMIT/HOLD del radar trasero.",
                    label = "Tecla XMIT trasera",
                },
                wheelClampConsumeItem = {
                    description = "Quitar el objeto del cepo tras colocarlo.",
                    label = "Consumir objeto del cepo",
                },
                wheelClampEnabled = {
                    description = "Habilitar la acción del cepo de rueda.",
                    label = "Cepo de rueda",
                },
                wheelClampItem = {
                    description = "Objeto de inventario usado para colocar el cepo de rueda.",
                    label = "Objeto del cepo",
                },
                wheelClampPropModel = {
                    description = "Modelo de prop usado para el cepo colocado.",
                    label = "Modelo del prop del cepo",
                },
                wheelClampRequireItem = {
                    description = "Requerir el objeto de cepo configurado. Mantener esto habilitado cuando el modo de uso del cepo esté en Inventario o Ambos.",
                    label = "Cepo requiere objeto",
                },
                wheelClampRequireOnDuty = {
                    description = "Requerir estar de servicio antes de colocar cepos.",
                    label = "Cepo requiere servicio",
                },
                wheelClampTyreDistance = {
                    description = "Distancia máxima a la rueda al colocar o soldar un cepo.",
                    label = "Distancia a la rueda",
                },
                wheelClampUseItem = {
                    description = "Usar radial, inventario o ambos para la colocación del cepo. Inventario o Ambos debe combinarse con «Cepo requiere objeto».",
                    label = "Modo de uso del cepo",
                    options = {
                        both = "Ambos",
                        inventory = "Inventario",
                        radial = "Radial",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Distancia máxima al vehículo objetivo al colocar un cepo.",
                    label = "Distancia al vehículo",
                },
                wheelClampWeldBurstTyre = {
                    description = "Reventar la rueda después de soldar el cepo.",
                    label = "Reventar rueda",
                },
                wheelClampWeldDurationMs = {
                    description = "Milisegundos necesarios para retirar un cepo soldando.",
                    label = "Duración de la soldadura",
                },
                wheelClampWeldEnabled = {
                    description = "Permitir retirar los cepos de rueda con una soldadora.",
                    label = "Soldadura del cepo",
                },
                wheelClampWeldItem = {
                    description = "Objeto de inventario requerido para soldar el cepo.",
                    label = "Objeto de soldadura",
                },
                wheelClampWeldMinigame = {
                    description = "Requerir el minijuego de soldadura del cepo antes de completar la retirada.",
                    label = "Minijuego de soldadura",
                },
                ziptiesConsumeItem = {
                    description = "Quitar un objeto de bridas al aplicarlo.",
                    label = "Consumir bridas",
                },
                ziptiesCutterConsumeItem = {
                    description = "Quitar el objeto del cortador tras cortar las bridas.",
                    label = "Consumir objeto del cortador",
                },
                ziptiesCutterEnabled = {
                    description = "Permitir que los cortacables retiren las bridas.",
                    label = "Cortador de bridas",
                },
                ziptiesCutterItem = {
                    description = "Objeto de inventario usado para cortar bridas.",
                    label = "Objeto del cortador",
                },
                ziptiesEnabled = {
                    description = "Habilitar las acciones con bridas.",
                    label = "Bridas",
                },
                ziptiesItem = {
                    description = "Objeto de inventario usado para las acciones con bridas.",
                    label = "Objeto de bridas",
                },
                ziptiesRequireHandsUp = {
                    description = "Requerir el estado de manos arriba antes de aplicar bridas.",
                    label = "Manos arriba para bridas",
                },
                ziptiesRequireItem = {
                    description = "Requerir el objeto de bridas configurado.",
                    label = "Bridas requieren objeto",
                },
                ziptiesReturnOnRemove = {
                    description = "Devolver un objeto de bridas al retirarlas.",
                    label = "Devolver bridas",
                },
                evidenceGsrDurationSeconds = {
                    description = "Segundos residuos de disparos permanecen en las manos de un jugador.",
                    label = "Duración de GSR",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Evitar que el GSR se aplique cuando el tirador use guantes.",
                    label = "Guantes proteger las manos",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Armas que no aplican residuos de disparos.",
                    label = "Armas ignoradas",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milisegundos entre los controles de limpieza de agua/lluvia mientras que GSR está activo.",
                    label = "Intervalo de control de lavado",
                },
                evidenceGsrWashInRain = {
                    description = "Dejar que la lluvia elimine los residuos de disparos.",
                    label = "Lavarse con lluvia",
                },
                evidenceGsrWashInWater = {
                    description = "Deje que el agua elimine los residuos de disparos.",
                    label = "Lavar en agua",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam muestra una placa falsa",
                    description = "Muestra la placa falsa en la cámara del helicóptero.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Herramientas normales muestran placa falsa",
                    description = "Muestra la placa falsa en herramientas policiales estándar.",
                },
                fakePlateRadarDisplay = {
                    label = "El radar muestra una placa falsa",
                    description = "Muestra la placa falsa en el radar de a bordo.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Permita que los sistemas policiales lean la bolsa falsa compartida.",
                    label = "Reconocer las placas falsas",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "La clave de la entidad de vehículo Statebag publicada por Mechanicjob.",
                    label = "Llave Statebag",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam muestra la placa falsa",
                    description = "Muestra la placa falsa en informes de radar fijos.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Profesión opcional/lista de permisos de grado. Dejar vacío para permitir todos los grados de las profesiones permitidas.",
                    label = "VIN grados",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN profesiones",
                    description = "las profesiones autorizadas a utilizar la verificación VIN.",
                },
                fakePlateVinAudit = {
                    label = "Auditoría VIN controles",
                    description = "Guarda VIN cheques en el registro de auditoría.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN Comprobación habilitada",
                    description = "Activa el comando de verificación del vehículo VIN.",
                },
                fakePlateVinCommand = {
                    label = "Comando VIN",
                    description = "Comando utilizado para verificar un vehículo VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN enfriamiento",
                    description = "Retraso entre dos cheques VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN distancia máxima",
                    description = "Distancia máxima entre el oficial y el vehículo para verificar su VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Mostrar indicador falso",
                    description = "Muestra un indicador cuando un cheque detecta una placa falsa.",
                },
                fakePlateVinRequireDuty = {
                    label = "Requerir deber",
                    description = "Requiere que el oficial esté en servicio para verificar un VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Requerir elemento del escáner",
                    description = "Requiere el objeto del escáner configurado para verificar un VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Elemento del escáner",
                    description = "Elemento de inventario necesario para verificar un VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Ponga al prisionero en situación de desempleo cuando sea encarcelado.",
                    label = "Eliminar la profesión en la cárcel",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Restaurar la profesión original del prisionero después de la liberación. Incapacidad para mantenerlos desempleados.",
                    label = "Restaurar la profesión original",
                },
                primaryColor = {
                    description = "Color predeterminado para el grupo de trabajos de policía.",
                    label = "color primario",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Permitir a los revisores facturar al propietario registrado incluso cuando la placa capturada está marcada como falsa o clonada.",
                    label = "Permitir que se sospechen placas falsas",
                },
                speedCamAdvancedPageSize = {
                    description = "Capturas máximas devueltas por página de la tableta.",
                    label = "Tamaño de la página de revisión",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Lados del vehículo cuyas fotos se pueden utilizar para el reconocimiento de la placa.",
                    itemLabel = "Lado",
                    label = "Lados reconocidos",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Sólo permitir la aprobación después de que la cámara de velocidad de carga de fotos completada.",
                    label = "Requerir pruebas fotográficas",
                },
                speedCamAdvancedReviewPermission = {
                    description = "El permiso Bossmenu requerido para aprobar o desechar capturas. 18 es Administrar la facturación.",
                    label = "Permiso de revisión ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Mantener las capturas cuya placa no esté presente en la base de datos de vehículos registrados.",
                    label = "Almacenar los vehículos no registrados",
                },
                tabletSpeedcamReviews = {
                    description = "Muestra la aplicación de revisión de cámara de velocidad avanzada cuando esté activado el modo avanzado.",
                    label = "Revisión de la cámara de velocidad",
                },
                tackleCommand = {
                    description = "Comando registrado para abordar a la persona más cercana. Introduzca el nombre de la orden sin una barra.",
                    label = "Comando Tackle",
                },
                tackleCuffCommand = {
                    description = "Comando registrado para esposar a la persona actualmente retenida después de un tackle. Introduzca el nombre del comando sin una barra.",
                    label = "Comando del manguito del tackle",
                },
                tackleCuffDescription = {
                    description = "Descripción que se muestra para el encuadernación del manguito del tackle en el menú de fijaciones de teclas FiveM.",
                    label = "Descripción del llavero del manguito",
                },
                tackleDescription = {
                    description = "Descripción mostrada para el encuadernación de tackle en el menú de encuadernaciones de teclas FiveM.",
                    label = "Descripción del keybind",
                },
                tackleEnabled = {
                    description = "Activar atacar a la persona más cercana y mantenerlos en el suelo.",
                    label = "Derribar",
                },
                tackleMaxDistance = {
                    description = "Distancia máxima al objetivo al iniciar un tackle.",
                    label = "Distancia de los pesquisas",
                },
                tackleNeedsSprint = {
                    description = "Requerir que el oficial esté corriendo antes de atacar a una persona.",
                    label = "Tackle requiere velocidad",
                },
                tackleReleaseCommand = {
                    description = "Comando registrado para liberar a la persona actualmente retenida después de un tackle. Introduzca el nombre del comando sin una barra.",
                    label = "Comando de liberación de tackle",
                },
                tackleReleaseDescription = {
                    description = "Descripción mostrada para el enlace de liberación de tackle en el menú de enlaces de teclas FiveM.",
                    label = "Descripción del keybind de liberación de tackle",
                },
                tackleRequireOnDuty = {
                    description = "Requerir el estado de deber antes de que un oficial pueda atacar a una persona.",
                    label = "Tackle requiere deber",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Comando utilizado para abrir o cerrar el editor de diseño de radar. Introduzca el nombre del comando sin una barra.",
                    label = "Comando de distribución de radar",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Orden usada para restaurar el diseño predeterminado del radar. Introduzca el nombre del comando sin una barra.",
                    label = "Reiniciar el comando de disposición de radar",
                },
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
            locationDescriptions = {
                jail_public_blip = "La posición se toma automáticamente del punto de aparición de la prisión o, si no está configurado, del primer terminal de la prisión.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Los puños de consumo no tienen efecto mientras que el requisito del objeto del manguito está desactivado.",
                wheelClampUseItemRequiresItem = "Modo de uso de la abrazadera Inventario o Ambos requieren que la abrazadera requiera elemento para permanecer activado.",
                ziptiesConsumeRequiresItem = "Consumir cremalleras no tiene ningún efecto mientras que el requisito de elemento Ziptie está deshabilitado.",
            },
        },
    },
    JobConfiguratorImportFailed = "Falló al importar los valores de config.lua para '%s': %s.",
    JobConfiguratorImportHistoryFailed = "La importación tuvo éxito, pero su entrada de la historia no se pudo guardar.",
    JobConfiguratorImportNoData = "'%s' no proporciona datos de importación de config.lua.",
    JobConfiguratorImportSuccess = "Valores de config.lua importados para '%s': %d profesiones, %d configuración, %d característica, y %d desviaciones de interacción aplicadas.",
    JobConfiguratorTitle = "Configurador de profesiones",
    JobConfiguratorUnknown = "Configurador de profesión desconocido.",
}
