JobConfigLocales["sky_ambulancejob:es"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Evaluaciones médicas",
                sharedMedicalEvaluations = "Evaluaciones médicas compartidas",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Permitir reaparicion",
                        description = "Controla si esta cama puede usarse para respawns de jugadores.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configure trabajos de ambulancia, camas de hospital, sistemas de muerte, interacciones y configuraciones de funciones principales.",
                    title = "Trabajos de ambulancia",
                },
            },
            dispatchActions = {
                currentLocation = "Usar ubicación actual",
                addChannel = "Añadir canal de radio",
                addKeyword = "Añadir palabra clave",
                addPoi = "Añadir punto de interés",
                addReporter = "Añadir alertante",
                addStatus = "Añadir estado FMS",
                addVehicle = "Añadir unidad virtual",
                addVehicleType = "Añadir tipo de unidad",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Número mínimo de personal en las unidades seleccionadas para este plan de respuesta.",
                noUnitFallback = "Sin un centro o unidad con personal, envía una notificación Sky a todos los miembros en servicio.",
                radius = "Distancia máxima en metros a la que se puede escuchar el anuncio de la emisora.",
                requirements = "Demanda de respuesta como TYPE:COUNT pares, por ejemplo PATROL:2,CRIME:1.",
                statusCode = "Estado numérico de FMS que se muestra en la radio portátil.",
                statusLabel = "Significado de este estado de FMS para despachadores y unidades.",
                vehicleType = "Debe coincidir con un código de tipo de vehículo configurado en la subsección anterior.",
                vehicleTypeCode = "Código de unidad corto utilizado en requisitos de respuesta, por ejemplo PATRULLA, CRIMEN, EMS o RESCATE.",
                vehicleTypeLabel = "Nombre legible de esta categoría de unidad.",
                crewCapacity = "Número máximo de personas que pueden ocupar la unidad. Usa 0 para una dotación ilimitada.",
                joinLocked = "Impide que se incorporen más personas una vez ocupada la unidad.",
                poiId = "Identificador técnico estable que los perfiles de central pueden conservar aunque cambie el nombre del lugar.",
                readyStatusCode = "Estado FMS aplicado cuando el recurso queda disponible para despacho.",
                resourceType = "Clasifica el recurso operativo para los filtros y la coordinación de la central.",
                respondingStatusCode = "Estado FMS aplicado cuando el recurso responde a un incidente.",
                shortLabel = "Etiqueta corta opcional mostrada en las seis memorias de canales de radio.",
                stationId = "Asocia la unidad con una estación configurada en el perfil de la central.",
                unitId = "Identificador técnico estable que conserva la unidad aunque cambie su indicativo.",
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
                defaultChannel = "Canal de radio predeterminado",
                emergencyAppEnabled = "Mostrar en la aplicación de emergencia",
                enabled = "Habilitar despacho",
                icon = "Icono",
                incidentAssessmentEnabled = "Habilitar evaluación de emergencia",
                jobs = "Trabajos de destino (separados por comas)",
                keywordCode = "Código de palabra clave",
                label = "Etiqueta",
                minimumCrew = "Tripulación mínima",
                name = "Nombre",
                noUnitFallback = "Notificar al personal de servicio sin unidades",
                noneChannel = "Ninguno/grupo predeterminado",
                note = "Nota",
                phone = "Teléfono",
                radius = "Radio de anuncio",
                requirements = "Unidades requeridas (por ejemplo PATRULLA:2,CRIMEN:1)",
                type = "Tipo",
                vehicleType = "Tipo de unidad de respuesta",
                crewCapacity = "Capacidad de dotación",
                joinLocked = "Bloquear incorporación a la dotación",
                poiId = "ID estable del punto de interés",
                readyStatusCode = "Código de estado disponible",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado en respuesta",
                shortLabel = "Etiqueta de memoria de radio",
                stationId = "ID de estación",
                unitId = "ID estable de unidad",
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
                    statuses = "FMS disponible",
                    units = "Unidades virtuales",
                    reporters = "Alertantes conocidos",
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
                dispatchStatusCodes = "Configura las etiquetas de estado de FMS y qué estados cuentan como disponibles para nuevos incidentes.",
                dispatchVehicleTypes = "Define las categorías de unidades utilizadas por los planes de respuesta, como Patrulla, Unidad contra el crimen, EMS o Rescate.",
                dispatchVehicles = "Define vehículos de despacho virtuales que pueden contar con personal desde cualquier lugar sin necesidad de un vehículo generado.",
                dispatchReporters = "Gestiona nombres de alertantes, teléfonos de devolución de llamada y notas de despacho propias del trabajo.",
            },
            extensions = {
                invalidSelection = "Selección no válida: {value}",
                trainingSettings = {
                    description = "Configure el acceso a la capacitación, la inscripción, las aprobaciones y la planificación de cursos para este trabajo.",
                    label = "Configuración de entrenamiento",
                },
                dispatchReporters = "Alertantes conocidos",
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
            },
            features = {
                bleeding = {
                    description = "Habilite el sistema de purga.",
                    label = "Sangría",
                },
                bodybags = {
                    description = "Habilitar bolsas para cadáveres y flujos de entrega de bolsas para cadáveres.",
                    label = "Bolsas para cadáveres",
                },
                consciousScenarioBloodPressure = {
                    description = "Permitir controles de la presión arterial mientras el paciente esté consciente.",
                    label = "Presión arterial consciente",
                },
                deathTimeout = {
                    description = "Habilite el flujo de tiempo de espera de muerte.",
                    label = "Tiempo de espera de muerte",
                },
                fractures = {
                    description = "Permitir el manejo y tratamiento de fracturas.",
                    label = "Fracturas",
                },
                knockout = {
                    description = "Habilite el sistema de eliminación.",
                    label = "Knockear",
                },
                legShotRagdoll = {
                    description = "Hace caer al jugador al recibir un disparo en las zonas configuradas de piernas o pies.",
                    label = "Caída por disparo en la pierna",
                },
                pain = {
                    description = "Habilite el sistema de dolor.",
                    label = "Dolor",
                },
                respawnInBed = {
                    description = "Respawn revivió a los jugadores en una cama de hospital cuando estuviera disponible.",
                    label = "Reaparecer en la cama",
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
                gang = "Banda",
                allowInVehicle = "Permitir en vehículo",
                allowMovement = "Permitir movimiento",
                animDict = "Diccionario de animación",
                animFlag = "Indicador de animación",
                animName = "Nombre de animación",
                bleeding = "Sangrado",
                cause = "Causa",
                chance = "Probabilidad",
                class = "Clase",
                companyPrice = "Precio para empresas",
                companyPricePerEmployee = "Precio por empleado",
                copayPercent = "% de copago",
                description = "Descripción",
                dictionary = "Diccionario de animación",
                duration = "Duración",
                durationMs = "Duración (ms)",
                effect = "Efecto",
                effectDurationMs = "Duración del efecto (ms)",
                effectDurationSeconds = "Duración del efecto (segundos)",
                enabled = "Activado",
                extractionType = "Tipo de extracción",
                foreignObject = "Objeto extraño",
                heal = "Curación",
                id = "ID",
                itemName = "Nombre del artículo",
                key = "Clave",
                label = "Etiqueta",
                lang = "Idioma",
                limit = "Límite",
                lossPerSecond = "Pérdida por segundo",
                max = "Máximo",
                min = "Mínimo",
                minGrade = "Grado mínimo",
                minigame = "Minijuego",
                model = "Modelo de utilería",
                name = "Nombre del trabajo",
                options = "Opciones (tipos de selección)",
                pain = "Dolor",
                pauseBleedingSeconds = "Pausar sangrado (segundos)",
                price = "Precio",
                progressbarAllowInVehicle = "Progreso: permitir en vehículo",
                progressbarAllowMovement = "Progreso: permitir movimiento",
                progressbarCanCancel = "Progreso cancelable",
                progressbarDisableCarMovement = "Progreso: bloquear vehículo",
                progressbarDisableCombat = "Progreso: bloquear combate",
                progressbarDisableMouse = "Progreso: bloquear ratón",
                progressbarDisableMovement = "Progreso: bloquear movimiento",
                progressbarDisableSprint = "Progreso: bloquear carrera",
                progressbarDuration = "Duración del progreso",
                progressbarEnabled = "Barra de progreso activada",
                progressbarLabel = "Texto de progreso",
                progressbarUseWhileDead = "Progreso utilizable muerto",
                questions = "Preguntas",
                requireItems = "Requerir artículos",
                required = "Requerido",
                requiresExtraction = "Requiere extracción",
                requiresOpenWound = "Requiere herida abierta",
                sort = "Orden",
                state = "Estado",
                stopBleeding = "Detener sangrado",
                threshold = "Umbral",
                time = "Tiempo",
                type = "Tipo",
                useAnimation = "Usar animación",
                value = "Valor",
                zone = "Zona",
                zones = "Zonas",
                systolic = "Presión sistólica",
                diastolic = "Presión diastólica",
                cardiacArrest = "Paro cardíaco",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Generales",
                },
                billingRange = {
                    label = "Rango",
                },
                billingReasons = {
                    label = "Preajustes de motivo",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animación",
                },
                bodyBagAttachGeneral = {
                    label = "Adjuntar",
                },
                bodyBagAttachOffsets = {
                    label = "Compensaciones",
                },
                bodyBagAttachRotation = {
                    label = "Rotación",
                },
                bodyBagDeliveryGeneral = {
                    label = "Generales",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Generales",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Pago",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Generales",
                },
                crutchAssign = {
                    label = "Asignación",
                },
                crutchDuration = {
                    label = "Duración",
                },
                crutchGeneral = {
                    label = "Generales",
                },
                crutchItems = {
                    label = "Artículo",
                },
                crutchRestrictions = {
                    label = "Restricciones",
                },
                damageHandlingBladeWeapons = {
                    label = "Armas de hoja",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Lista negra de sangrado",
                },
                damageHandlingBleedingClasses = {
                    label = "Clases de sangrado",
                },
                damageHandlingBloodSystem = {
                    label = "Sistema sanguíneo",
                },
                damageHandlingDeathInjuries = {
                    label = "Lesiones de muerte",
                },
                damageHandlingInjuryEffects = {
                    label = "Efectos de las lesiones",
                },
                damageHandlingInjuryThresholds = {
                    label = "Umbrales de lesión",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll por disparo en pierna",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zonas de disparo en pierna",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Fracturas por daños vivos",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Oportunidades de zona",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Acumulacion de heridas abiertas",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limites por zona",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Clases de heridas vivas",
                },
                damageHandlingMedications = {
                    label = "Medicamentos",
                },
                damageHandlingPainClasses = {
                    label = "clases de dolor",
                },
                damageHandlingPainEffects = {
                    label = "Efectos del dolor",
                },
                damageHandlingStatusEffects = {
                    label = "Efectos de estado",
                },
                damageHandlingVehicleDamage = {
                    label = "Daños al vehículo",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Causas de daños",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Lesiones",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Protección contra impactos de vehículos",
                },
                deathAnimal = {
                    label = "Repliegue animal",
                },
                deathAnimalAnimation = {
                    label = "Animación de animales",
                },
                deathAnimation = {
                    label = "Animación",
                },
                deathGeneral = {
                    label = "Generales",
                },
                deathModels = {
                    label = "Anulaciones por modelo",
                },
                deathScreenAiMedic = {
                    label = "Generales",
                },
                deathScreenAiMedicAvailability = {
                    label = "Disponibilidad",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Comportamiento",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Fuerza revivir",
                },
                deathScreenAiMedicPayment = {
                    label = "Pago",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Revivir en la cama",
                },
                deathScreenAiMedicSpawn = {
                    label = "Desovar",
                },
                deathScreenAiMedicTiming = {
                    label = "Momento",
                },
                deathScreenControls = {
                    label = "Controles",
                },
                deathScreenDamageLogs = {
                    label = "Registros de daño",
                },
                deathScreenDimensions = {
                    label = "Dimensiones",
                },
                deathScreenDispatch = {
                    label = "Despacho",
                },
                deathScreenEarlyRespawn = {
                    label = "Generales",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Disponibilidad",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Pago",
                },
                deathScreenGeneral = {
                    label = "Generales",
                },
                deathScreenHospitalSelection = {
                    label = "Selección de hospitales",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Cámara de selección",
                },
                deathScreenInformation = {
                    label = "Generales",
                },
                deathScreenIntegration = {
                    label = "Integración",
                },
                deathScreenLogs = {
                    label = "Registros de muerte",
                },
                deathScreenMinigame = {
                    label = "Minijuego",
                },
                deathScreenRespawn = {
                    label = "Generales",
                },
                deathScreenRespawnAccounts = {
                    label = "Cuentas",
                },
                deathScreenRespawnFallback = {
                    label = "Coordenadas alternativas",
                },
                deathScreenRespawnItems = {
                    label = "Elementos",
                },
                deathScreenRespawnWeapons = {
                    label = "Armas",
                },
                deathScreenStyle = {
                    label = "Estilo de pantalla de muerte",
                },
                deathScreenVoice = {
                    label = "Voz",
                },
                deathTimeoutGeneral = {
                    label = "Generales",
                },
                deathTimeoutWhitelist = {
                    label = "Trabajos en lista blanca",
                },
                diagnoseAnim = {
                    label = "Animación",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Curación completa",
                },
                diagnoseGeneral = {
                    label = "Generales",
                },
                doctorNpcAvailability = {
                    label = "Disponibilidad",
                },
                doctorNpcGeneral = {
                    label = "Generales",
                },
                doctorNpcHealOther = {
                    label = "sanar a otros",
                },
                doctorNpcHealSelf = {
                    label = "curarse a uno mismo",
                },
                doctorNpcRanges = {
                    description = "Estos rangos no controlan qué tan cerca debe estar un jugador para abrir la interacción médico NPC. Solo se aplican después de que se abre el menú del médico.",
                    label = "Rangos",
                },
                doctorNpcRevive = {
                    label = "Reanimar",
                },
                doctorNpcReviveInBed = {
                    label = "Revivir en la cama",
                },
                firstAidAnimation = {
                    label = "Animación",
                },
                firstAidGeneral = {
                    label = "Generales",
                },
                firstAidLicenseAdd = {
                    label = "Agregar licencia",
                },
                firstAidLicenseRemove = {
                    label = "Quitar licencia",
                },
                firstAidPosition = {
                    label = "Posición",
                },
                healthInsuranceExpiration = {
                    label = "Vencimiento",
                },
                healthInsuranceGeneral = {
                    label = "Generales",
                },
                healthInsurancePayment = {
                    label = "Pago",
                },
                healthInsuranceProviders = {
                    label = "Proveedores",
                },
                hospitalBedsBedAnimation = {
                    label = "Animación de cama",
                },
                hospitalBedsCreator = {
                    label = "Creador",
                },
                hospitalBedsDistances = {
                    label = "Distancias",
                },
                hospitalBedsGeneral = {
                    label = "Generales",
                },
                hospitalBedsGetupAnimation = {
                    label = "Animación de preparación",
                },
                hospitalBedsModels = {
                    label = "Modelos",
                },
                hospitalBedsOffsets = {
                    label = "Compensaciones",
                },
                hospitalBlip = {
                    label = "Accidente hospitalario",
                },
                imagingGeneral = {
                    label = "Generales",
                },
                imagingRanges = {
                    label = "Rangos",
                },
                keybinds = {
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                    label = "Teclas",
                },
                knockoutGeneral = {
                    label = "Generales",
                },
                knockoutWeapons = {
                    label = "Armas",
                },
                medicCarryAttach = {
                    label = "Adjuntar",
                },
                medicCarryAttachOffsets = {
                    label = "Compensaciones",
                },
                medicCarryAttachRotation = {
                    label = "Rotación",
                },
                medicCarryCarrierAnimation = {
                    label = "Animación del transportista",
                },
                medicCarryGeneral = {
                    label = "Generales",
                },
                medicCarryPassengerAnimation = {
                    label = "Animación de pasajeros",
                },
                medicCarryRestrictions = {
                    label = "Restricciones",
                },
                medicRevivePersistence = {
                    label = "Generales",
                },
                medicalEvaluationRecipients = {
                    label = "Profesiones beneficiarias",
                },
                medicalEvaluationSharing = {
                    label = "Campos compartidos",
                },
                medicalEvaluationTypes = {
                    label = "Tipos de evaluación",
                },
                medicalEvaluationsGeneral = {
                    label = "Generales",
                },
                medicalWearablesArmRestrictions = {
                    label = "Restricciones del yeso de brazo",
                },
                medicalWearablesCasts = {
                    label = "Yesos",
                },
                medicalWearablesDuration = {
                    label = "Duración de uso",
                },
                medicalWearablesGeneral = {
                    label = "Generales",
                },
                medicalWearablesHeadBandage = {
                    label = "Vendaje de cabeza",
                },
                medicalWearablesLegRestrictions = {
                    label = "Restricciones del yeso de pierna",
                },
                medicalWearablesNeckBrace = {
                    label = "Collarín cervical",
                },
                medicalWearablesOxygenMask = {
                    label = "Mascarilla de oxígeno",
                },
                medicalWearablesPatientHud = {
                    label = "HUD del paciente",
                },
                medicalWearablesRemoval = {
                    label = "Retirada",
                },
                medicalWearablesSplints = {
                    label = "Férulas",
                },
                medicalWearablesTorsoBandage = {
                    label = "Vendaje de torso",
                },
                minigamesCprGeneral = {
                    label = "Generales",
                },
                minigamesEnabled = {
                    label = "Activado",
                },
                minigamesVentilationGeneral = {
                    label = "Generales",
                },
                operationsAnesthesia = {
                    label = "Anestesia",
                },
                operationsDistances = {
                    label = "Distancias",
                },
                operationsDoctorAnimation = {
                    label = "Animación del cirujano",
                },
                operationsGeneral = {
                    label = "Generales",
                },
                operationsPatientAnimation = {
                    label = "Animación del paciente",
                },
                operationsTrainingAnimation = {
                    label = "Animación de entrenamiento",
                },
                propPlacement = {
                    label = "Colocación de accesorios",
                },
                propPlacementItems = {
                    label = "Artículos de utilería",
                },
                publicTreatmentGeneral = {
                    label = "Generales",
                },
                publicTreatmentJobs = {
                    label = "Trabajos permitidos",
                },
                publicTreatmentRequirements = {
                    label = "Requisitos",
                },
                reviveRewardGeneral = {
                    label = "Generales",
                },
                reviveRewardPayment = {
                    label = "Pago",
                },
                selfDiagnoseGeneral = {
                    label = "Generales",
                },
                stretcherAnimation = {
                    label = "Animación",
                },
                stretcherCarryAttach = {
                    label = "Llevar adjunto",
                },
                stretcherFolded = {
                    label = "Variante plegada",
                },
                stretcherFoldedPatientAttach = {
                    label = "Accesorio para paciente plegado",
                },
                stretcherGeneral = {
                    label = "Generales",
                },
                stretcherHelicopter = {
                    label = "Helicóptero",
                },
                stretcherPatientAttach = {
                    label = "Adjuntar paciente",
                },
                stretcherTreatmentAnim = {
                    label = "Animación",
                },
                stretcherVehicleAttach = {
                    label = "Adjuntar vehículo",
                },
                stretcherVehicleLists = {
                    label = "Modelos de vehículos",
                },
                treatmentAnim = {
                    label = "Animación",
                },
                treatmentEnable = {
                    label = "Permitir",
                },
                trunk = {
                    label = "Trompa",
                },
                vehiclePullGeneral = {
                    label = "Generales",
                },
                wheelchairAssign = {
                    label = "Asignación",
                },
                wheelchairDuration = {
                    label = "Duración",
                },
                wheelchairGeneral = {
                    label = "Generales",
                },
                wheelchairItems = {
                    label = "Artículo",
                },
                wheelchairRestrictions = {
                    label = "Restricciones",
                },
                xrayGeneral = {
                    label = "Generales",
                },
                xrayRanges = {
                    label = "Rangos",
                },
                appointmentsGeneral = {
                    label = "Generales",
                },
                appointmentsLimits = {
                    label = "Límites",
                },
                appointmentsNotifications = {
                    label = "Notificaciones",
                },
                appointmentsScheduling = {
                    label = "Programación",
                },
                healthCompatibility = {
                    label = "Compatibilidad con la salud",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Generales",
                },
                minigamesRandomization = {
                    label = "Aleatorización",
                },
            },
            settingSections = {
                billing = "Facturación",
                bodyBag = "Bolsa para cadáveres",
                damageHandling = "Manejo de daños",
                death = "Muerte",
                deathScreen = "Pantalla de muerte",
                diagnose = "Diagnosticar",
                doctorNpc = "Doctor PNJ",
                general = "Generales",
                healthInsurance = "Seguro médico",
                hospitalBeds = "Camas de hospital",
                knockout = "Knockear",
                medicCarry = "Transporte médico",
                minigames = "Minijuegos",
                mobilityAid = "Ayudas para la movilidad",
                operations = "Operaciones",
                organization = "Organización",
                rewards = "Recompensas",
                treatment = "Tratamiento",
                vehiclePull = "Tracción del vehículo",
            },
            settingSubsections = {
                aiMedic = "Médico de IA",
                anesthesia = "Anestesia",
                animation = "Animación",
                animations = "Animaciones",
                attach = "Adjuntar",
                bedAnimation = "Animación de cama",
                blood = "Sangre",
                bodyBagDeliveryReward = "Recompensa por entrega de bolsa para cadáveres",
                carrierAnimation = "Animación del transportista",
                classification = "Clasificación",
                cpr = "CPR",
                crutch = "Muleta",
                deathInjuries = "Lesiones de muerte",
                deathScreenStyle = "Estilo de pantalla de muerte",
                deathTimeout = "Tiempo de espera de muerte",
                delivery = "Entrega",
                diagnoseAnim = "Diagnosticar animación",
                dispatch = "Despacho",
                earlyRespawn = "Reaparición temprana",
                effects = "Efectos",
                firstAid = "Primeros auxilios",
                general = "Generales",
                getupAnimation = "Animación de preparación",
                imaging = "Imágenes",
                information = "Información",
                keybinds = "Teclas",
                liveDamage = "Daño en vivo",
                logs = "Registros",
                medicRevivePersistence = "Médico revive la persistencia",
                medicalEvaluations = "Evaluaciones médicas",
                medicalWearables = "Dispositivos médicos",
                medications = "Medicamentos",
                minigame = "Minijuego",
                passengerAnimation = "Animación de pasajeros",
                pricing = "Precios",
                propPlacement = "Colocación de accesorios",
                publicTreatment = "Tratamiento Público",
                respawn = "Reaparecer",
                reviveInBed = "Revivir en la cama",
                reviveReward = "Revivir recompensa",
                selfDiagnose = "Autodiagnóstico",
                stretcher = "Camilla",
                stretcherTreatmentAnim = "Animación del tratamiento en camilla",
                thresholds = "Umbrales",
                treatmentAnim = "Animación del tratamiento",
                trunk = "Trompa",
                vehicleImpact = "Impacto del vehículo",
                ventilation = "Ventilación",
                wheelchair = "Silla de ruedas",
                xray = "Rayo X",
                appointments = "Citas",
                bloodTransfusion = "Transfusión de sangre",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor · UP",
                    description = "Configura: Editor: Subir.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor · DOWN",
                    description = "Configura: Editor: Bajar.",
                },
                ambulanceEditorControl174 = {
                    label = "Editor · LEFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl175 = {
                    label = "Editor · RIGHT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl177 = {
                    label = "Editor · BACK",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl201 = {
                    label = "Editor · RETURN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl202 = {
                    label = "Editor · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl21 = {
                    label = "Editor · LSHIFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl32 = {
                    label = "Editor · W",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl33 = {
                    label = "Editor · S",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl34 = {
                    label = "Editor · A",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl35 = {
                    label = "Editor · D",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl36 = {
                    label = "Editor · LCONTROL",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl37 = {
                    label = "Editor · TAB",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl38 = {
                    label = "Editor · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceEditorControl44 = {
                    label = "Editor · Q",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Primeros auxilios · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interacción · BACK",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interacción · RETURN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interacción · ESCAPE",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interacción · LSHIFT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interacción · IOM_WHEEL_UP",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interacción · IOM_WHEEL_DOWN",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interacción · MOUSE_RIGHT",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interacción · W",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interacción · S",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interacción · A",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interacción · D",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interacción · LCONTROL",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interacción · E",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interacción · Q",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                billingAccount = {
                    description = "Cuenta de sociedad alternativa heredada utilizada para la facturación.",
                    label = "Cuenta",
                },
                billingCloseOnSuccess = {
                    description = "Cierre la interfaz de usuario de facturación automáticamente después de una facturación exitosa.",
                    label = "Cerca del éxito",
                },
                billingCurrency = {
                    description = "Clave de moneda opcional utilizada para pagos de facturación.",
                    label = "Divisa",
                },
                billingCustomBillingReasons = {
                    description = "Permita que los médicos ingresen motivos de facturación personalizados.",
                    label = "Motivos personalizados",
                },
                billingDepositToSociety = {
                    description = "Depositar los ingresos de facturación en la cuenta de la sociedad.",
                    label = "Depósito a la sociedad",
                },
                billingEnabled = {
                    description = "Habilitar el sistema de facturación médica.",
                    label = "Activado",
                },
                billingMaxReasonLength = {
                    description = "Longitud máxima de los motivos de facturación personalizados.",
                    label = "Longitud máxima del motivo",
                },
                billingMode = {
                    description = "Elija si las facturas médicas se cargan instantáneamente, requieren confirmación o utilizan el sistema de facturación marco.",
                    label = "Modo de facturación",
                    options = {
                        consent = "Pagar o rechazar",
                        framework = "Proyecto de ley marco",
                        instant = "Carga instantánea",
                    },
                },
                billingRange = {
                    description = "Rango máximo para encontrar pacientes facturables.",
                    label = "Rango",
                },
                billingReasonPresets = {
                    description = "Motivos de facturación preestablecidos que se muestran en la interfaz de usuario de facturación.",
                    itemLabel = "Razón",
                    label = "Preajustes de motivo",
                },
                billingRefreshSeconds = {
                    description = "Segundos entre actualizaciones de jugadores facturables.",
                    label = "Actualizar segundos",
                },
                bladeWeapons = {
                    description = "Nombres de armas o hashes que deberían clasificarse como daños por cuchillo en lugar de contundentes.",
                    itemLabel = "Arma",
                    label = "Armas de hoja",
                },
                bleedingBlacklist = {
                    description = "Armas que nunca deberían provocar hemorragias vivas ni heridas abiertas.",
                    itemLabel = "Arma",
                    label = "Lista negra sangrante",
                },
                bleedingClassesProfiles = {
                    description = "Perfiles de gravedad del sangrado y su tasa de pérdida de sangre.",
                    label = "clases de sangrado",
                },
                bloodSystemDebugLogInterval = {
                    description = "Segundos entre mensajes de registro de depuración del sistema sanguíneo.",
                    label = "Intervalo de registro de depuración",
                },
                bloodSystemMaxVolume = {
                    description = "Valor máximo del volumen sanguíneo utilizado por el sistema de estado del paciente.",
                    label = "Volumen máximo",
                },
                bloodSystemRegenPerSecond = {
                    description = "La regeneración sanguínea pasiva se aplica cuando el paciente no está sangrando activamente.",
                    label = "Regeneración por segundo",
                },
                bloodSystemTickIntervalMs = {
                    description = "Intervalo de tic del servidor utilizado para actualizaciones de recuperación y pérdida de sangre.",
                    label = "Intervalo de tic ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Umbral de volumen sanguíneo por debajo del cual el paciente pierde el conocimiento.",
                    label = "Umbral inconsciente",
                },
                bodyBagAnimationDict = {
                    description = "Diccionario de animación utilizado para llevar una bolsa para cadáveres.",
                    label = "Diccionario de animación",
                },
                bodyBagAnimationEnabled = {
                    description = "Utilice una animación de transporte dedicada mientras lleva una bolsa para cadáveres.",
                    label = "Activado",
                },
                bodyBagAnimationFlag = {
                    description = "Bandera TaskPlayAnim utilizada para la animación de acarreo.",
                    label = "Bandera de animación",
                },
                bodyBagAnimationName = {
                    description = "Clip de animación utilizado para llevar una bolsa para cadáveres.",
                    label = "Nombre de la animación",
                },
                bodyBagAttachBone = {
                    description = "Nombre del hueso pediátrico o ID del hueso utilizado para el accesorio de la bolsa para cadáveres.",
                    label = "Hueso",
                },
                bodyBagAttachRx = {
                    description = "Bolsa para cadáveres adjuntar rotación X.",
                    label = "Adjuntar RX",
                },
                bodyBagAttachRy = {
                    description = "Bolsa para cadáveres adjunta rotación Y.",
                    label = "Adjuntar RY",
                },
                bodyBagAttachRz = {
                    description = "Bolsa para cadáveres adjunta rotación Z.",
                    label = "Adjuntar RZ",
                },
                bodyBagAttachX = {
                    description = "Bolsa para cadáveres adjuntar X desplazado.",
                    label = "Adjuntar X",
                },
                bodyBagAttachY = {
                    description = "Bolsa para cadáveres acoplada en Y desplazada.",
                    label = "Adjuntar Y",
                },
                bodyBagAttachZ = {
                    description = "Bolsa para cadáveres adjuntar desplazamiento Z.",
                    label = "Adjuntar Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Clave de configuración regional utilizada para el mensaje de ayuda para la entrega de la bolsa para cadáveres.",
                    label = "Tecla de etiqueta de ayuda",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distancia utilizada para la validación de entrega de bolsas para cadáveres.",
                    label = "Interactuar a distancia",
                },
                bodyBagDeliveryInteractKey = {
                    description = "ID de control utilizado para interacciones de entrega de bolsas para cadáveres.",
                    label = "Clave de interacción",
                },
                bodyBagDeliveryInteraction = {
                    description = "Clave de plantilla de interacción utilizada para la entrega de bolsas para cadáveres.",
                    label = "Plantilla de interacción",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Exigir a los médicos que entreguen bolsas para cadáveres en los puntos de entrega configurados.",
                    label = "Requerir entrega",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Exigir que los médicos estén de guardia antes de la entrega de la bolsa para cadáveres.",
                    label = "Requerir de turno",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Clave de cuenta principal utilizada para recompensas por entrega de bolsas para cadáveres.",
                    label = "Cuenta",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Tipo de cuenta principal utilizado para recompensas de entrega de bolsas para cadáveres.",
                    label = "Tipo de cuenta",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Monto de la recompensa pagada por la entrega de una bolsa para cadáveres.",
                    label = "Cantidad",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Clave de moneda personalizada opcional que se utiliza para recompensas de entrega de bolsas para cadáveres.",
                    label = "Divisa",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Pague una recompensa configurada después de que se complete la entrega de una bolsa para cadáveres.",
                    label = "Activado",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Deduzca las recompensas por la entrega de bolsas para cadáveres de la sociedad de trabajo compartido antes de pagarle al médico.",
                    label = "pagar de la sociedad",
                },
                bodyBagEnabled = {
                    description = "Habilite el sistema de bolsa para cadáveres.",
                    label = "Activado",
                },
                bodyBagHidePatient = {
                    description = "Oculte al paciente mientras la bolsa para cadáveres está colocada.",
                    label = "Ocultar paciente",
                },
                bodyBagModel = {
                    description = "Modelo de utilería utilizado para bolsas para cadáveres.",
                    label = "Modelo",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha se aplicó al paciente mientras estaba en una bolsa para el cuerpo.",
                    label = "Paciente alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Distancia máxima para asignar una muleta a otro jugador.",
                    label = "Asignar distancia máxima",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Desequipa automáticamente la muleta cuando expire la asignación.",
                    label = "Desequipamiento automático al expirar",
                },
                crutchClipset = {
                    description = "Clipset de movimiento aplicado mientras se usa la muleta.",
                    label = "conjunto de clips",
                },
                crutchDefaultDurationMinutes = {
                    description = "Duración de la muleta asignada por defecto en minutos.",
                    label = "Duración predeterminada",
                },
                crutchDisableSprint = {
                    description = "Bloquee el sprint mientras tiene equipada una muleta.",
                    label = "Desactivar sprint",
                },
                crutchDisableWeapons = {
                    description = "Bloquea el uso de armas mientras tengas una muleta equipada.",
                    label = "Desactivar armas",
                },
                crutchItemName = {
                    description = "Artículo de inventario utilizado para la muleta.",
                    label = "Nombre del artículo",
                },
                crutchMaxDurationMinutes = {
                    description = "Duración máxima permitida de la asignación de muletas en minutos.",
                    label = "Duración máxima",
                },
                crutchMinDurationMinutes = {
                    description = "Duración mínima permitida de la asignación de muletas en minutos.",
                    label = "Duración mínima",
                },
                crutchProp = {
                    description = "Modelo de utilería utilizado para la muleta.",
                    label = "Apuntalar",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Segundos durante los que se agrupan impactos individuales en un mensaje.",
                    label = "Intervalo de lote",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Número máximo de impactos individuales por mensaje de Discord.",
                    label = "Impactos por mensaje",
                },
                damageLogsEnabled = {
                    description = "Enviar a Discord los impactos no letales confirmados por el servidor.",
                    label = "Registros de daño",
                },
                deathAnimalAnimationDictionary = {
                    description = "Diccionario de animación utilizado para la animación de muerte alternativa de animales.",
                    label = "Diccionario de animales",
                },
                deathAnimalAnimationName = {
                    description = "Clip de animación utilizado para la animación de muerte alternativa del animal.",
                    label = "Nombre de la animación animal.",
                },
                deathAnimalUseAnimation = {
                    description = "Permita que el animal de reserva configurado utilice una animación de muerte programada.",
                    label = "Animación de animales",
                },
                deathAnimationDictionary = {
                    description = "Diccionario de animación utilizado para la animación de muerte predeterminada.",
                    label = "Diccionario de animación",
                },
                deathAnimationName = {
                    description = "Clip de animación utilizado para la animación de muerte predeterminada.",
                    label = "Nombre de la animación",
                },
                deathInjuriesProfiles = {
                    description = "Perfiles de lesiones que se aplican cuando un jugador muere por una causa específica.",
                    itemLabel = "Lesión",
                    label = "Lesiones mortales",
                },
                deathModels = {
                    description = "Anule el comportamiento de la animación de muerte por modelo ped o hash de modelo.",
                    label = "Anulaciones de modelo",
                },
                deathScreenAiMedicAccount = {
                    description = "Cuenta principal cargada por el médico de IA.",
                    label = "Cuenta",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Se agregan segundos al temporizador de sangrado cuando se solicita el médico de IA.",
                    label = "Agregar temporizador de muerte",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Permita que el médico de IA reviva las heridas fatales.",
                    label = "Permitir heridas mortales",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distancia a la que el médico de IA se detiene y se acerca a pie.",
                    label = "Distancia de aproximación",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Enfriamiento antes de que se pueda volver a llamar al médico de IA.",
                    label = "Segundos de enfriamiento",
                },
                deathScreenAiMedicCurrency = {
                    description = "Clave de moneda opcional utilizada para pagos médicos de IA.",
                    label = "Divisa",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Formateador de moneda utilizado para pagos médicos de IA.",
                    label = "Formateador de moneda",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Segundos antes de que el médico de la IA desaparezca después de terminar.",
                    label = "Retraso de desaparición",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Retraso antes de que comience el envío médico de IA.",
                    label = "Retraso en el envío",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Velocidad de conducción utilizada por el vehículo médico de IA.",
                    label = "Velocidad de conducción",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Tiempo máximo de conducción antes de que se active la reactivación forzada.",
                    label = "Tiempo de espera de conducción",
                },
                deathScreenAiMedicEnabled = {
                    description = "Habilite el flujo de rescate médico de IA.",
                    label = "Activado",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Cuenta alternativa utilizada cuando la cuenta médica principal de AI no tiene fondos suficientes.",
                    label = "Cuenta alternativa",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Fuerza una reanimación si el médico de la IA no puede alcanzar al jugador.",
                    label = "Forzar reactivación habilitada",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "El médico de IA solo funciona mientras los médicos de servicio tienen este recuento o menos.",
                    label = "Max médicos en línea",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Duración máxima de la misión antes de que se active la reactivación forzada.",
                    label = "Tiempo de espera de la misión",
                },
                deathScreenAiMedicPedModel = {
                    description = "Modelo de pediatría utilizado para el médico de IA.",
                    label = "modelo pediátrico",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Destino usado cuando el jugador abatido llama al médico de IA.",
                    label = "Destino de la solicitud del jugador",
                    options = {
                        hospital = "Hospital",
                        location = "Ubicación actual",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Precio cobrado por llamar al médico de IA.",
                    label = "Precio",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Segundos desde la muerte del jugador antes de que un médico pueda ofrecer un médico de IA remoto.",
                    label = "Espera de despacho remoto",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Permita que los médicos envíen el médico de IA a un jugador caído desde el mapa de envío y el comando /aimedic.",
                    label = "Despacho remoto",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "El envío médico remoto de IA solo funciona mientras los médicos de servicio están en este recuento o por debajo de él.",
                    label = "Despacho remoto de max medics en línea",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Destino usado cuando se envía y acepta un médico de IA remoto.",
                    label = "Destino del despacho remoto",
                    options = {
                        hospital = "Hospital",
                        location = "Ubicación actual",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Segundos disponibles para que el jugador acepte una oferta de médico de IA remoto.",
                    label = "Tiempo límite de la oferta remota",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Distancia requerida antes de que el médico de IA comience a revivir.",
                    label = "Revivir la distancia",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Segundos dedicados a reanimar al jugador.",
                    label = "Duración de revivir",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teletransporta al jugador a una cama de hospital en lugar de revivir en el acto.",
                    label = "Revivir en la cama",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Radio de búsqueda utilizado para encontrar una cama de reanimación.",
                    label = "Radio de búsqueda de camas",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Segundos después de la muerte, antes de que el médico de IA esté disponible.",
                    label = "Segundos hasta disponibles",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Radio máximo de generación de médicos de IA.",
                    label = "Radio de generación máximo",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Radio mínimo de generación de médicos de IA.",
                    label = "Radio de generación mínimo",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Modelo de vehículo utilizado por el médico de IA.",
                    label = "Modelo de vehículo",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Modo de voz mientras está inconsciente: ninguno, escuchar o completo.",
                    label = "Modo de voz",
                    options = {
                        full = "lleno",
                        listen = "escuchar",
                        none = "ninguno",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Identificaciones de control que permanecen habilitadas mientras estás inconsciente.",
                    label = "Controles permitidos",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Los jugadores reaparecen automáticamente si el temporizador de sangrado ya expiró mientras estaban desconectados.",
                    label = "Reconexión caducada de reaparición automática",
                },
                deathScreenBackgroundEnd = {
                    description = "Color final del fondo de la pantalla de muerte.",
                    label = "Fin del fondo",
                },
                deathScreenBackgroundStart = {
                    description = "Color inicial del fondo de la pantalla de muerte.",
                    label = "Inicio en segundo plano",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Segundos antes de que expire el temporizador de purga.",
                    label = "Temporizador de purga",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensiones donde se bloquea el flujo de reaparición de la pantalla de muerte.",
                    label = "Dimensiones bloqueadas",
                },
                deathScreenBorderColor = {
                    description = "Color de borde utilizado por la pantalla de muerte.",
                    label = "Color del borde",
                },
                deathScreenDispatchEnabled = {
                    description = "Envíe eventos de envío desde el flujo de la pantalla de muerte.",
                    label = "Despacho habilitado",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Destinatarios de respaldo si ningún destinatario principal está vivo y de servicio. Déjalo vacío para avisar siempre a los trabajos principales.",
                    itemLabel = "Trabajo",
                    label = "Trabajos de respaldo",
                },
                deathScreenDispatchJobs = {
                    description = "Trabajos alertados cuando un jugador incapacitado solicita ayuda.",
                    itemLabel = "Trabajo",
                    label = "Trabajos alertados",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Se cobra a la cuenta principal por reaparición anticipada.",
                    label = "Cuenta",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Mantenga disponible la reaparición temprana incluso para heridas fatales.",
                    label = "Permitir heridas mortales",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Clave de moneda opcional utilizada para pagos de reaparición anticipada.",
                    label = "Divisa",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Formateador de moneda utilizado para pagos de reaparición anticipada.",
                    label = "Formateador de moneda",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Habilite la reaparición anticipada pagada.",
                    label = "Activado",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Cuenta alternativa utilizada cuando la cuenta principal no tiene fondos suficientes.",
                    label = "Cuenta alternativa",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Se muestra una etiqueta opcional para el pago por reaparición anticipada.",
                    label = "etiqueta de pago",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Precio cobrado por una reaparición temprana.",
                    label = "Precio",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Solo permita la reaparición anticipada cuando no haya médicos de servicio.",
                    label = "No requiere médicos",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Segundos después de la muerte antes de que esté disponible la reaparición anticipada.",
                    label = "Segundos hasta disponibles",
                },
                deathScreenEnableKeyboard = {
                    description = "Permitir el uso del teclado en la pantalla de muerte.",
                    label = "Habilitar teclado",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Backend de voz externo para silenciar cuando está habilitado.",
                    label = "Sistema de voz externo",
                    options = {
                        saltychat = "charla salada",
                        yaca = "yaca",
                    },
                },
                deathScreenFocusKey = {
                    label = "Interacción con ratón en la pantalla de muerte",
                    description = "Asignación predeterminada de FiveM, p. ej. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vacío significa sin tecla predeterminada. Los jugadores pueden cambiar sus teclas en los ajustes de FiveM; se conservan las asignaciones guardadas.",
                },
                deathScreenHandlingMode = {
                    description = "Usa la animación de muerte estática o conserva la física ragdoll natural hasta que el cuerpo se estabilice.",
                    label = "Gestión de la muerte",
                    options = {
                        natural = "Natural",
                        static = "Estática",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Oculta la pantalla de muerte cuando ESPACIO cambia a los controles del juego; desactívalo para conservar la interfaz visible anterior.",
                    label = "Ocultar interfaz con controles del juego",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Desplazamiento de altura aplicado al objetivo de enfoque de la cámara.",
                    label = "Altura de enfoque",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Vista previa del campo de visión de la cámara.",
                    label = "Campo de visión",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Desplazamiento del rumbo utilizado al colocar la cámara de vista previa.",
                    label = "Desplazamiento de rumbo",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Desplazamiento de altura aplicado a la cámara de vista previa.",
                    label = "Altura de la cámara",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Tono aplicado a la cámara de vista previa.",
                    label = "Paso",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distancia desde la cámara de vista previa hasta el punto de generación.",
                    label = "Radio de la cámara",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Utilice una transición suave al abrir la cámara de selección de hospitales.",
                    label = "Transición suave",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Permita que los jugadores seleccionen un hospital antes de reaparecer.",
                    label = "Selección de hospital",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Solo muestra la selección de hospitales cuando existe más de un hospital.",
                    label = "Requiere múltiples hospitales",
                },
                deathScreenInformationEnabled = {
                    description = "Muestra el bloque de información en la pantalla de muerte.",
                    label = "Activado",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Muestra la causa de muerte en el bloque de información de la pantalla de muerte.",
                    label = "Mostrar causa de muerte",
                },
                deathScreenInformationShowInjuries = {
                    description = "Muestra lesiones en el bloque de información de la pantalla de muerte.",
                    label = "Mostrar lesiones",
                },
                deathScreenInformationShowKiller = {
                    description = "Muestra el nombre del asesino en el bloque de información de la pantalla de muerte.",
                    label = "mostrar asesino",
                },
                deathScreenInformationShowWeapon = {
                    description = "Muestra el arma en el bloque de información de la pantalla de muerte.",
                    label = "mostrar arma",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Bandas autorizadas",
                    description = "Selecciona nombres internos de bandas u organizaciones independientes. Un trabajo o banda coincidente concede el permiso o exención. El servicio solo se exige a los trabajos.",
                    itemLabel = "Banda",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Los trabajos permitieron ver información ampliada de la pantalla de muerte.",
                    itemLabel = "Trabajo",
                    label = "Trabajos en la lista blanca",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Segundos máximos permitidos para subir cada captura de muerte.",
                    label = "Tiempo límite de captura",
                },
                deathScreenLogScreenshots = {
                    description = "Subir las vistas de la víctima y del asesino confirmado después del registro de texto.",
                    label = "Capturas",
                },
                deathScreenLogsEnabled = {
                    description = "Enviar un registro a Discord cada vez que muera un jugador.",
                    label = "Registros de muerte",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distancia en metros utilizada para contar a un médico como cercano.",
                    label = "Radio médico cercano",
                },
                deathScreenMinigameEnabled = {
                    description = "Habilita el minijuego de la pantalla de la muerte.",
                    label = "Activado",
                },
                deathScreenMinigameUrl = {
                    description = "URL abierta para el minijuego de la pantalla de la muerte.",
                    label = "URL del minijuego",
                },
                deathScreenMode = {
                    description = "Usa la pantalla de muerte integrada o una integración externa.",
                    label = "Modo de pantalla",
                    options = {
                        external = "Externa",
                        internal = "Interna",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Silencia los sistemas de voz externos mientras el reproductor está inactivo.",
                    label = "Silenciar voz externa",
                },
                deathScreenMutedTextColor = {
                    description = "Color de texto apagado utilizado en la pantalla de muerte.",
                    label = "Color de texto apagado",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Muestra razones detalladas del cliente y del servidor mientras el cuerpo permanece en ragdoll.",
                    label = "Depuración del ragdoll natural",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Estabiliza automáticamente los cuerpos inmóviles o exige que un sanitario de servicio los coloque en la posición lateral de seguridad.",
                    label = "Estabilización natural",
                    options = {
                        automatic = "Automática",
                        medic = "Sanitario obligatorio",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Color de fondo del panel utilizado por la pantalla de muerte.",
                    label = "Fondo del panel",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Bloquea la reaparición automática después de un sangrado.",
                    label = "Evitar la reaparición automática",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Bloquea la reaparición automática mientras haya un médico cerca.",
                    label = "Bloquear cuando el médico esté cerca",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "El bloque revive después de que expira el temporizador de purga.",
                    label = "Prevenir revivir al vencimiento",
                },
                deathScreenPrimaryColor = {
                    description = "Color CSS base utilizado para el tema de la pantalla de muerte.",
                    label = "color primario",
                },
                deathScreenPrimaryDark = {
                    description = "Color de acento más oscuro opcional para la pantalla de muerte.",
                    label = "oscuro primario",
                },
                deathScreenPrimaryStrong = {
                    description = "Color de acento más fuerte opcional para la pantalla de muerte.",
                    label = "Primaria fuerte",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Rumbo utilizado cuando la estación no tiene rumbo definido.",
                    label = "Título predeterminado",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "El rumbo de reaparición alternativo se utiliza cuando no existen posiciones hospitalarias.",
                    label = "Rumbo alternativo",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Coordenada X de reaparición alternativa utilizada cuando no existen posiciones hospitalarias.",
                    label = "Respaldo X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "La coordenada Y de reaparición alternativa se utiliza cuando no existen posiciones hospitalarias.",
                    label = "Respaldo Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Coordenada Z de reaparición alternativa utilizada cuando no existen posiciones hospitalarias.",
                    label = "Repliegue Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Elija un hospital fijo para reaparecer. Déjelo vacío para utilizar el hospital más cercano.",
                    label = "hospital de reaparición",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Eliminar saldos de cuentas al reaparecer.",
                    label = "Eliminar cuentas",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Nombres de cuentas eliminados al reaparecer.",
                    itemLabel = "Cuenta",
                    label = "Nombres de cuentas",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Elimina los elementos del inventario al reaparecer.",
                    label = "Eliminar elementos",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Los artículos del inventario se mantienen al reaparecer.",
                    itemLabel = "Artículo",
                    label = "Artículos ignorados",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Elimina las armas de la rueda de armas al reaparecer.",
                    label = "Quitar armas",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Las armas siguieron reapareciendo.",
                    itemLabel = "Arma",
                    label = "Armas ignoradas",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teletransporta al jugador a un hospital al reaparecer.",
                    label = "Teletransportarse al hospital",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Reanude el temporizador de purga después de volver a conectarse en lugar de restablecerlo.",
                    label = "Reanudar al volver a conectar",
                },
                deathScreenShadowLight = {
                    description = "Color de sombra suave utilizado por la pantalla de la muerte.",
                    label = "luz de sombra",
                },
                deathScreenShadowMid = {
                    description = "Color de sombra medio utilizado por la pantalla de muerte.",
                    label = "Sombra media",
                },
                deathScreenShowNearestMedic = {
                    description = "Muestra el médico más cercano en la pantalla de muerte.",
                    label = "Mostrar médico más cercano",
                },
                deathScreenTextColor = {
                    description = "Color de texto principal utilizado por la pantalla de muerte.",
                    label = "Color del texto",
                },
                deathScreenTextShadow = {
                    description = "Color de sombra de texto utilizado por la pantalla de muerte.",
                    label = "Sombra de texto",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Aplica también el tiempo de espera de muerte después de que el nocaut reviva.",
                    label = "Aplicar al nocaut",
                },
                deathTimeoutSeconds = {
                    description = "Segundos después de revivir ese combate queda desactivado.",
                    label = "Artículos de segunda clase",
                },
                deathTimeoutShowUi = {
                    description = "Muestra el banner de cuenta regresiva del tiempo de espera de muerte mientras está activo.",
                    label = "Mostrar interfaz de usuario",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Bandas autorizadas",
                    description = "Selecciona nombres internos de bandas u organizaciones independientes. Un trabajo o banda coincidente concede el permiso o exención. El servicio solo se exige a los trabajos.",
                    itemLabel = "Banda",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Trabajos exentos de las restricciones de tiempo de espera por muerte.",
                    itemLabel = "Trabajo",
                    label = "Trabajos en la lista blanca",
                },
                deathUseAnimation = {
                    description = "Reproduzca la animación de muerte configurada para los pediatras admitidos.",
                    label = "Usar animación",
                },
                diagnoseAnimClip = {
                    description = "Clip de animación utilizado al abrir el diagnóstico. Déjelo vacío para usar un escenario en su lugar.",
                    label = "Nombre de la animación",
                },
                diagnoseAnimDict = {
                    description = "Diccionario de animación utilizado al abrir el diagnóstico. Déjelo vacío para usar un escenario en su lugar.",
                    label = "Diccionario de animación",
                },
                diagnoseAnimScenario = {
                    description = "Escenario utilizado al abrir el diagnóstico. Déjelo vacío para usar dict + clip en su lugar.",
                    label = "Guión",
                },
                diagnoseCprAnimDict = {
                    description = "Diccionario de animación utilizado para RCP.",
                    label = "Diccionario de animación",
                },
                diagnoseCprAnimName = {
                    description = "Clip de animación utilizado para RCP.",
                    label = "Nombre de la animación",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Tiempo de diagnóstico continuo necesario antes de mostrar la curación completa.",
                    label = "Retraso en segundos",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Requerir mochila de rescate",
                    description = "Exigir rescue_backpack para mostrar la barra izquierda de herramientas de exploración. Desactiva esta opción para mostrarla siempre; se mantienen los requisitos de objetos de cada herramienta.",
                },
                diagnoseFullHealEnabled = {
                    description = "Permite la curación completa después de una sesión de diagnóstico continua.",
                    label = "Activado",
                },
                diagnoseInteractDistance = {
                    description = "Distancia máxima requerida para diagnosticar o colocar en una bolsa para cadáveres a un paciente.",
                    label = "Interactuar a distancia",
                },
                diagnosePatientMovementMode = {
                    label = "Movimiento del paciente",
                    description = "Inmoviliza al paciente mientras otro jugador tenga abierto el menú de tratamiento, o permite el movimiento y cierra el menú al superar la distancia de tratamiento. El autodiagnóstico se configura por separado.",
                    options = {
                        freeze = "Inmovilizar al paciente",
                        distance = "Cerrar al superar la distancia",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Distancia de tratamiento (m)",
                    description = "Distancia máxima entre quien trata y el paciente antes de cerrar el menú en el modo de distancia. La distancia de apertura se configura por separado.",
                },
                diagnoseKey = {
                    description = "ID de control utilizado para diagnosticar interacciones.",
                    label = "Clave de interacción",
                },
                diagnoseOpenDelayMs = {
                    description = "Retraso antes de que se abra la interfaz de usuario de diagnóstico.",
                    label = "Retardo de apertura ms",
                },
                diagnosePromptDistance = {
                    description = "Distancia utilizada para mostrar el mensaje de diagnóstico.",
                    label = "distancia inmediata",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Duración utilizada para las animaciones de tratamiento.",
                    label = "Duración del tratamiento ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Deposite los pagos del médico en la cuenta de la sociedad compartida cuando los cobre directamente.",
                    label = "Añadir ingresos a la sociedad",
                },
                doctorNpcEnabled = {
                    description = "Habilitar el servicio médico NPC.",
                    label = "Activado",
                },
                doctorNpcHealOtherAccount = {
                    description = "Clave de cuenta principal utilizada para cargar la curación de otro jugador.",
                    label = "Cuenta",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Tipo de cuenta principal utilizada para cobrar por curar a otro jugador.",
                    label = "Tipo de cuenta",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Clave de moneda personalizada opcional que se utiliza para cargar la curación de otro jugador.",
                    label = "Divisa",
                },
                doctorNpcHealOtherPrice = {
                    description = "Precio para curar a otro jugador en el doctor NPC.",
                    label = "Precio",
                },
                doctorNpcHealSelfAccount = {
                    description = "Clave de cuenta principal utilizada para cargar la autorreparación.",
                    label = "Cuenta",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Tipo de cuenta principal utilizada para cobrar la autorreparación.",
                    label = "Tipo de cuenta",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Clave de moneda personalizada opcional que se utiliza para cargar la autorreparación.",
                    label = "Divisa",
                },
                doctorNpcHealSelfPrice = {
                    description = "Precio para curarte a ti mismo en el doctor NPC.",
                    label = "Precio",
                },
                doctorNpcInteractionRange = {
                    description = "Qué tan cerca debe permanecer el usuario del NPC médico mientras usa el menú médico abierto. Esto no cambia la distancia inicial del aviso de NPC.",
                    label = "Rango de interacción",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Doctor NPC solo funciona mientras los médicos de servicio están por debajo de este límite.",
                    label = "Max médicos en línea",
                },
                doctorNpcPatientRange = {
                    description = "Qué tan cerca debe estar el paciente del médico NPC para curar a otros o revivir para trabajar después de seleccionar la acción.",
                    label = "Rango de pacientes",
                },
                doctorNpcPaymentMode = {
                    description = "Cobra a los jugadores inmediatamente o envía una factura.",
                    label = "Modo de pago",
                    options = {
                        bill = "factura",
                        remove = "eliminar",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Solo se usa para enumerar jugadores cercanos en la interfaz de usuario del doctor NPC. No permite el tratamiento por sí solo.",
                    label = "Rango de escaneo del jugador",
                },
                doctorNpcReviveAccount = {
                    description = "La clave de cuenta principal utilizada para cobrar al médico revive.",
                    label = "Cuenta",
                },
                doctorNpcReviveAccountType = {
                    description = "El tipo de cuenta principal utilizado para cobrar al médico revive.",
                    label = "Tipo de cuenta",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Permite que el médico NPC reanime lesiones mortales o no reanimables. Un tiempo de desangrado agotado sigue bloqueando la reanimación.",
                    label = "Permitir heridas mortales",
                },
                doctorNpcReviveCurrency = {
                    description = "Clave de moneda personalizada opcional que se utiliza para cobrar las reanimaciones del médico.",
                    label = "Divisa",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Coloque a los jugadores revividos en la cama del hospital más cercana después de que un médico los reviva.",
                    label = "Activado",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Distancia máxima utilizada para encontrar una cama de hospital cercana para que el médico reviva.",
                    label = "Radio de búsqueda",
                },
                doctorNpcRevivePrice = {
                    description = "Precio para revivir a un jugador en el doctor NPC.",
                    label = "Precio",
                },
                firstAidActionDurationMs = {
                    description = "Cuánto tiempo dura la acción de primeros auxilios.",
                    label = "Duración de la acción ms",
                },
                firstAidAnimationDict = {
                    description = "Diccionario de animación utilizado durante la acción de primeros auxilios.",
                    label = "Diccionario de animación",
                },
                firstAidAnimationFlag = {
                    description = "Bandera TaskPlayAnim utilizada durante la acción de primeros auxilios.",
                    label = "Bandera de animación",
                },
                firstAidAnimationName = {
                    description = "Clip de animación utilizado durante la acción de primeros auxilios.",
                    label = "Nombre de la animación",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Se agregaron segundos al cronómetro de sangrado del paciente después de los primeros auxilios.",
                    label = "Segundos de extensión de sangrado",
                },
                firstAidEnabled = {
                    description = "Habilite la función de primeros auxilios para jugadores con licencia.",
                    label = "Primeros auxilios habilitados",
                },
                firstAidLicense = {
                    description = "Nombre de la licencia marco utilizada para validar el acceso a primeros auxilios.",
                    label = "Nombre de licencia",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Permitir que el personal de la ambulancia otorgue la licencia de primeros auxilios.",
                    label = "Agregar licencia habilitada",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Muestra la acción agregar licencia en el menú radial.",
                    label = "Agregar licencia radial",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Requerir la obligación de EMS antes de poder utilizar la acción de agregar licencia.",
                    label = "Agregar licencia requiere deber",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Permita que el personal de la ambulancia retire la licencia de primeros auxilios.",
                    label = "Quitar licencia habilitada",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Muestra la acción de quitar licencia en el menú radial.",
                    label = "Quitar licencia radial",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Requerir servicio EMS antes de que se pueda utilizar la acción de eliminación de licencia.",
                    label = "Quitar licencia requiere deber",
                },
                firstAidPositionChestOffset = {
                    description = "Desplazamiento del pecho utilizado mientras se alinea para primeros auxilios.",
                    label = "Desplazamiento del pecho",
                },
                firstAidPositionSideOffset = {
                    description = "Desplazamiento lateral utilizado al alinear para primeros auxilios.",
                    label = "Desplazamiento lateral",
                },
                firstAidPositionZOffset = {
                    description = "Desplazamiento vertical utilizado al alinear para primeros auxilios.",
                    label = "Desplazamiento Z",
                },
                firstAidRequireLicense = {
                    description = "Requerir la licencia de primeros auxilios configurada antes de que un jugador pueda usar primeros auxilios.",
                    label = "Requerir licencia",
                },
                firstAidTargetDistance = {
                    description = "Distancia máxima permitida para el uso de primeros auxilios.",
                    label = "Distancia objetivo",
                },
                healthInsuranceAccount = {
                    description = "Clave de cuenta alternativa utilizada para pagos de seguros.",
                    label = "Cuenta",
                },
                healthInsuranceAccountType = {
                    description = "Tipo de cuenta principal utilizada para pagos de seguros.",
                    label = "Tipo de cuenta",
                },
                healthInsuranceAvailableDays = {
                    description = "Duraciones de seguro disponibles en días.",
                    label = "Días disponibles",
                },
                healthInsuranceCommand = {
                    description = "Comando de chat utilizado para abrir la interfaz de usuario del seguro médico.",
                    label = "Dominio",
                },
                healthInsuranceCurrency = {
                    description = "Clave de moneda personalizada opcional utilizada para pagos de seguros.",
                    label = "Divisa",
                },
                healthInsuranceEnabled = {
                    description = "Habilitar el sistema de seguro médico.",
                    label = "Activado",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Permite que los empleados autorizados cambien los precios del seguro en la tableta. Desactívalo para aplicar los precios de la tabla de proveedores inferior.",
                    label = "Gestión de precios en la tableta",
                },
                healthInsuranceProviders = {
                    description = "Proveedores de seguros ofrecidos a los jugadores.",
                    itemLabel = "Proveedor",
                    label = "Proveedores",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Usa los mismos proveedores y pólizas para todos los trabajos registrados en este recurso de ambulancia.",
                    label = "Compartir entre trabajos de ambulancia",
                },
                hospitalBedsBedAnimationDict = {
                    description = "El diccionario de animación se repite mientras el jugador yace en la cama. Déjelo vacío para usar el respaldo predeterminado de animación de muerte.",
                    label = "Diccionario de animación",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Duración manual opcional para la animación de la cama en bucle. Solo se utiliza cuando se configura una animación de cama personalizada.",
                    label = "Duración ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Bandera TaskPlayAnim utilizada para la animación de la cama en bucle. Solo se utiliza cuando se configura una animación de cama personalizada.",
                    label = "Bandera de animación",
                },
                hospitalBedsBedAnimationName = {
                    description = "El clip de animación se repite mientras el jugador yace en la cama. Déjelo vacío para usar el respaldo predeterminado de animación de muerte.",
                    label = "Nombre de la animación",
                },
                hospitalBedsBreakDistance = {
                    description = "Distancia tras la cual el jugador es obligado a levantarse de la cama.",
                    label = "distancia de ruptura",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Vista previa del modelo pediátrico utilizado en el editor de posición de la cama del hospital.",
                    label = "Modelo de ped creador",
                },
                hospitalBedsEnabled = {
                    description = "Habilite las interacciones configuradas entre camas de hospital.",
                    label = "Activado",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Diccionario de animación que se reproduce cuando el jugador se levanta de la cama. Déjelo vacío para utilizar el comportamiento de pie predeterminado.",
                    label = "Diccionario de animación",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Duración manual opcional para la animación de levantamiento. Solo se usa cuando se configura una animación de levantamiento personalizada.",
                    label = "Duración ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Bandera TaskPlayAnim utilizada para la animación de inicio. Solo se usa cuando se configura una animación de levantamiento personalizada.",
                    label = "Bandera de animación",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Clip de animación reproducido cuando el jugador se levanta de la cama. Déjelo vacío para utilizar el comportamiento de pie predeterminado.",
                    label = "Nombre de la animación",
                },
                hospitalBedsHeadingOffset = {
                    description = "Desplazamiento del rumbo aplicado al colocar el reproductor en la cama.",
                    label = "Desplazamiento de rumbo",
                },
                hospitalBedsHeightOffset = {
                    description = "Desplazamiento vertical aplicado al colocar el reproductor en la cama.",
                    label = "Desplazamiento de altura",
                },
                hospitalBedsInteractDistance = {
                    description = "Distancia máxima requerida para utilizar una cama de hospital.",
                    label = "Interactuar a distancia",
                },
                hospitalBedsInteractKey = {
                    description = "Identificación de control utilizada para entrar o salir de una cama de hospital.",
                    label = "Clave de interacción",
                },
                hospitalBedsModels = {
                    description = "Modelos de objetos del mundo tratados como camas de hospital utilizables.",
                    itemLabel = "Modelo",
                    label = "Modelos de cama",
                },
                hospitalBedsSearchRadius = {
                    description = "Radio utilizado para encontrar accesorios de cama cercanos o camas configuradas.",
                    label = "Radio de búsqueda",
                },
                hospitalBlipColor = {
                    description = "ID de color de señal utilizado para señales de mapa de hospital.",
                    label = "Color",
                },
                hospitalBlipEnabled = {
                    description = "Muestra señales en el mapa del hospital para las posiciones hospitalarias configuradas.",
                    label = "Activado",
                },
                hospitalBlipName = {
                    description = "Se utiliza el nombre del aviso del hospital alternativo cuando no hay ningún nombre de estación disponible.",
                    label = "Nombre",
                },
                hospitalBlipScale = {
                    description = "Escala de señal utilizada para señales de mapa de hospitales.",
                    label = "Escala",
                },
                hospitalBlipSprite = {
                    description = "ID de sprite de Blip utilizado para los blips del mapa del hospital.",
                    label = "Duende",
                },
                imagingInteractionRange = {
                    description = "Distancia máxima desde la estación de imágenes para el operador.",
                    label = "Rango de interacción",
                },
                imagingPatientRange = {
                    description = "Distancia máxima desde la estación de imágenes para el paciente.",
                    label = "Rango de pacientes",
                },
                imagingScanDurationSeconds = {
                    description = "Duración en segundos para los resultados de la tomografía computarizada y la resonancia magnética.",
                    label = "Duración del escaneo",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Multiplicador solo visual para efectos de superposición de sangrado.",
                    label = "Intensidad de la superposición de sangrado",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Multiplicador solo visual para efectos de pantalla de dolor.",
                    label = "Intensidad de la pantalla de dolor",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Porcentaje mínimo de salud máxima perdida en un solo golpe antes de que se aplique sangrado y dolor.",
                    label = "Porcentaje mínimo de sangrado/dolor",
                },
                injuryThresholdRespectArmor = {
                    description = "Evita el sangrado y el dolor cuando el golpe fue absorbido por la armadura.",
                    label = "respetar la armadura",
                },
                knockoutRegenerateDamage = {
                    description = "Regenera el daño por nocaut después de que expire el temporizador de reaparición.",
                    label = "Regenerar daño",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Segundos durante los cuales se cura el daño por nocaut.",
                    label = "Duración de la regeneración",
                },
                knockoutRespawnSeconds = {
                    description = "Segundos antes de una reaparición automática cuando un jugador queda eliminado.",
                    label = "Segundos de reaparición",
                },
                knockoutWeapons = {
                    description = "Nombres de armas o hashes que deberían activar el nocaut en lugar de la pantalla de muerte completa.",
                    itemLabel = "Arma",
                    label = "Armas",
                },
                legShotRagdollChance = {
                    description = "Porcentaje de probabilidad de que un impacto valido active el ragdoll.",
                    label = "Probabilidad",
                },
                legShotRagdollCooldownMs = {
                    description = "Retraso minimo entre ragdolls por disparo en la pierna.",
                    label = "Refrigeración",
                },
                legShotRagdollDebug = {
                    description = "Registra decisiones del ragdoll para pruebas.",
                    label = "Depurar",
                },
                legShotRagdollDurationMs = {
                    description = "Cuanto tiempo dura el ragdoll.",
                    label = "Duracion ms",
                },
                legShotRagdollFeet = {
                    description = "Permite que impactos en los pies activen el ragdoll.",
                    label = "Pies",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Omite el ragdoll si la armadura absorbio el golpe.",
                    label = "Ignorar impactos en armadura",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Permite impactos en la pierna inferior izquierda.",
                    label = "Pierna inferior izquierda",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Permite impactos en la pierna superior izquierda.",
                    label = "Pierna superior izquierda",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Solo los disparos pueden activar el ragdoll.",
                    label = "Solo disparos",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Permite impactos en la pierna inferior derecha.",
                    label = "Pierna inferior derecha",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Permite impactos en la pierna superior derecha.",
                    label = "Pierna superior derecha",
                },
                liveDamageFracturesChance = {
                    description = "Probabilidad base de que un golpe de daño consciente provoque una fractura.",
                    label = "Oportunidad",
                },
                liveDamageFracturesEnabled = {
                    description = "Permita que los golpes de daño conscientes produzcan fracturas.",
                    label = "Activado",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Porcentaje mínimo de salud máxima perdido en un golpe antes de que pueda producirse una fractura.",
                    label = "Porcentaje mínimo de daño",
                },
                liveDamageFracturesZones = {
                    description = "Posibilidades de fractura por zona con daños vivos.",
                    label = "Oportunidades de zona",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maximo de acumulaciones de heridas abiertas por zona sin reemplazo.",
                    label = "Limite por defecto",
                },
                liveOpenWoundStacksZones = {
                    description = "Limites opcionales de heridas abiertas por zona.",
                    itemLabel = "Zona",
                    label = "Limites por zona",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Clase de sangrado inicial aplicada por causa de daño vivo.",
                    label = "Clase de sangrado de heridas vivas.",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Permite al portador entrar y conducir un vehículo sin soltar al paciente.",
                    label = "Permitir al portador en vehículos",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Permitir llevar jugadores conscientes.",
                    label = "Permitir objetivos conscientes",
                },
                medicCarryAllowSprint = {
                    description = "Permita correr mientras lleva a un paciente.",
                    label = "Permitir sprint",
                },
                medicCarryAttachBone = {
                    description = "Índice óseo utilizado para sujetar al jugador transportado.",
                    label = "Adjuntar hueso",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Llevar adjuntar rotación de tono.",
                    label = "Paso",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Llevar la rotación del rollo de fijación.",
                    label = "Rollo",
                },
                medicCarryAttachOffsetsX = {
                    description = "Llevar adjunto X desplazado.",
                    label = "Desplazamiento X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Llevar adjunto Y desplazamiento.",
                    label = "Compensación Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Llevar acoplar rotación de guiñada.",
                    label = "Guiñada",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Llevar adjunto desplazamiento Z.",
                    label = "Desplazamiento Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Diccionario de animación utilizado por el médico mientras transporta a un paciente.",
                    label = "Diccionario de animación",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Bandera TaskPlayAnim utilizada por la animación de transporte médico.",
                    label = "Bandera de animación",
                },
                medicCarryCarrierAnimationName = {
                    description = "Clip de animación utilizado por el médico mientras transporta a un paciente.",
                    label = "Nombre de la animación",
                },
                medicCarryEnabled = {
                    description = "Habilite el sistema de transporte médico.",
                    label = "Activado",
                },
                medicCarryMaxDistance = {
                    description = "Distancia máxima requerida para recoger a un paciente.",
                    label = "Distancia máxima",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Diccionario de animación utilizado por el paciente transportado.",
                    label = "Diccionario de animación",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Indicador TaskPlayAnim utilizado por la animación del paciente transportado.",
                    label = "Bandera de animación",
                },
                medicCarryPassengerAnimationName = {
                    description = "Clip de animación utilizado por el paciente transportado.",
                    label = "Nombre de la animación",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Vuelva a aplicar la animación de la muerte después de dejar caer a un paciente inconsciente.",
                    label = "Volver a aplicar la animación de la muerte.",
                },
                medicCarryRequireOnDuty = {
                    description = "Sólo los médicos de servicio pueden iniciar un transporte.",
                    label = "Requerir de turno",
                },
                medicReviveAllowFatalWounds = {
                    description = "Permite que los médicos de servicio traten y reanimen lesiones mortales o no reanimables. Un tiempo de desangrado agotado sigue bloqueando la reanimación.",
                    label = "Permitir heridas mortales",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Mantenga las lesiones no resueltas después del tratamiento o reviva la lista de verificación.",
                    label = "mantener lesiones",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Mantenga los valores de dolor después del tratamiento o la lista de verificación revive cuando se conservan las lesiones.",
                    label = "mantener el dolor",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Distancia máxima utilizada para enumerar jugadores cercanos cuando se crea una evaluación médica.",
                    label = "Gama de pacientes cercana",
                },
                medicalEvaluationRecipientJobs = {
                    description = "profesiones para las que se pueden emitir y compartir evaluaciones médicas.",
                    label = "Trabajos destinatarios",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Permitir que las profesiones receptoras vean la fecha de nacimiento del paciente.",
                    label = "Fecha de nacimiento",
                },
                medicalEvaluationShareConclusion = {
                    description = "Permitir que las profesiones beneficiarias vean la conclusión médica.",
                    label = "Conclusión sobre las acciones",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Permitir que las profesiones beneficiarias vean qué tipos de evaluación se han realizado.",
                    label = "Compartir tipos de evaluación",
                },
                medicalEvaluationShareFullName = {
                    description = "Permitir que las profesiones receptoras vean el nombre completo del paciente.",
                    label = "Compartir el nombre completo",
                },
                medicalEvaluationShareGender = {
                    description = "Permitir que las profesiones receptoras vean el género del paciente.",
                    label = "Compartir el género",
                },
                medicalEvaluationShareHeight = {
                    description = "Permitir que las profesiones receptoras vean la altura del paciente.",
                    label = "Compartir altura",
                },
                medicalEvaluationShareHobbies = {
                    description = "Permitir que las profesiones receptoras vean las actividades de ocio y aficiones del paciente.",
                    label = "Compartir ocio y pasatiempos",
                },
                medicalEvaluationShareIssuer = {
                    description = "Mostrar el nombre del autor. El trabajo emisor siempre identifica su carpeta de documentos compartidos.",
                    label = "Compartir datos del autor",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Permitir que las profesiones beneficiarias vean el ID personal del paciente.",
                    label = "Compartir personal ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Permitir que las profesiones beneficiarias vean la profesión del paciente.",
                    label = "Compartir profesión",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Permitir que las profesiones beneficiarias vean las preguntas del cuestionario y las respuestas registradas.",
                    label = "Compartir preguntas y respuestas",
                },
                medicalEvaluationShareResult = {
                    description = "Permitir que las profesiones beneficiarias vean si la evaluación está pendiente, superada o fallida.",
                    label = "Resultado de la participación",
                },
                medicalEvaluationShareWeight = {
                    description = "Permitir que las profesiones receptoras vean el peso del paciente.",
                    label = "Cuota de peso",
                },
                medicalEvaluationTypes = {
                    description = "Configure tipos de evaluación, preguntas, tipos de respuesta y si cada pregunta está activa.",
                    label = "Tipos de evaluación y cuestionarios",
                    options = {
                        boolean = "Sí / No",
                        boolean_text = "Sí / No con detalles",
                        date = "Fecha",
                        multi_select = "Opción múltiple",
                        number = "Número",
                        rating = "Calificación",
                        select = "Una sola opción",
                        text = "Texto",
                        textarea = "Área de texto",
                        time = "Hora",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Activar las evaluaciones médicas en la tableta de la ambulancia.",
                    label = "Activado",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Ofrece una duración permanente que sigue activa hasta que un médico retire el dispositivo.",
                    label = "Permitir hasta la retirada",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Impide los ataques cuerpo a cuerpo mientras se lleva un yeso de brazo.",
                    label = "Desactivar cuerpo a cuerpo",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Fuerza el combate sin armas e impide cambiar de arma mientras se lleva un yeso de brazo.",
                    label = "Desactivar armas",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Aplica restricciones de combate mientras se lleva un yeso de brazo.",
                    label = "Activado",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Trata las fracturas compatibles al colocar un yeso o una férula.",
                    label = "Integración de fracturas",
                },
                medicalWearablesCastsEnabled = {
                    description = "Permite yesos en ambos brazos y piernas.",
                    label = "Activado",
                },
                medicalWearablesCastsItem = {
                    description = "Objeto del inventario consumido al colocar un yeso.",
                    label = "Objeto",
                },
                medicalWearablesCastsMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para los yesos.",
                    label = "Minijuego",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Duración predeterminada del dispositivo médico en minutos. Usa 0 para mantenerlo hasta su retirada.",
                    label = "Minutos predeterminados",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Duraciones de dispositivos médicos mostradas a los médicos, en minutos.",
                    label = "Opciones de duración",
                },
                medicalWearablesEnabled = {
                    description = "Activa los modelos de yesos, férulas, vendajes, collarines y mascarillas de oxígeno en la interfaz de tratamiento.",
                    label = "Activado",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Frecuencia con la que se retiran los dispositivos temporizados caducados.",
                    label = "Comprobación de caducidad (segundos)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Permite el modelo de vendaje de cabeza.",
                    label = "Activado",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Objeto del inventario consumido para un vendaje de cabeza.",
                    label = "Objeto",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para un vendaje de cabeza.",
                    label = "Minijuego",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Impide saltar mientras se lleva un yeso de pierna.",
                    label = "Desactivar salto",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Impide correr mientras se lleva un yeso de pierna.",
                    label = "Desactivar carrera",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Fuerza el conjunto de animaciones de movimiento lesionado mientras se lleva un yeso de pierna.",
                    label = "Forzar paso lesionado",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Sobrescribe la velocidad de movimiento mientras se lleva un yeso de pierna.",
                    label = "Velocidad de movimiento",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Aplica restricciones de movimiento mientras se lleva un yeso de pierna.",
                    label = "Activado",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Permite el modelo de collarín cervical.",
                    label = "Activado",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Objeto del inventario consumido para un collarín cervical.",
                    label = "Objeto",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para un collarín cervical.",
                    label = "Minijuego",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Permite el modelo de mascarilla de oxígeno.",
                    label = "Activado",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Objeto del inventario consumido para una mascarilla de oxígeno.",
                    label = "Objeto",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para una mascarilla de oxígeno.",
                    label = "Minijuego",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Muestra al paciente sus ayudas médicas activas y el tiempo de uso restante.",
                    label = "Activado",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Elige dónde se muestra el HUD de ayudas médicas del paciente.",
                    label = "Posición",
                    options = {
                        ["bottom-center"] = "Abajo al centro",
                        ["bottom-left"] = "Abajo a la izquierda",
                        ["bottom-right"] = "Abajo a la derecha",
                        center = "Centro",
                        ["center-left"] = "Centro izquierda",
                        ["center-right"] = "Centro derecha",
                        ["top-center"] = "Arriba al centro",
                        ["top-left"] = "Arriba a la izquierda",
                        ["top-right"] = "Arriba a la derecha",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Restaura yesos, férulas, collarines cervicales y vendajes de torso temporizados tras reconexiones y reinicios del recurso.",
                    label = "Persistencia de dispositivos médicos",
                },
                medicalWearablesRemoval = {
                    description = "Permite a los médicos retirar yesos, férulas, collarines y vendajes de torso activos desde la interfaz de tratamiento.",
                    label = "Retirada por médicos",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Muestra la retirada de dispositivos médicos con la herramienta configurada en la interfaz de tratamiento.",
                    label = "Tratamiento de retirada activado",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Herramienta reutilizable del inventario necesaria para retirar un dispositivo médico.",
                    label = "Objeto",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minijuego para retirar ayudas médicas (cast_saw por defecto).",
                    label = "Minijuego",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Permite férulas de cabestrillo en ambos brazos.",
                    label = "Activado",
                },
                medicalWearablesSplintsItem = {
                    description = "Objeto del inventario consumido al colocar una férula.",
                    label = "Objeto",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para las férulas.",
                    label = "Minijuego",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Permite el modelo de vendaje de torso.",
                    label = "Activado",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Objeto del inventario consumido para un vendaje de torso.",
                    label = "Objeto",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Minijuego de tratamiento existente utilizado para un vendaje de torso.",
                    label = "Minijuego",
                },
                medicationsProfiles = {
                    description = "Entradas declarativas de medicación utilizadas para tratamiento y automedicación.",
                    itemLabel = "Medicamento",
                    label = "Medicamentos",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Habilita el minijuego de máscara de válvula de bolsa.",
                    label = "Máscara de válvula de bolsa",
                },
                minigamesCastSawEnabled = {
                    description = "Activa el minijuego de sierra para retirar ayudas médicas.",
                    label = "Sierra de escayola",
                },
                minigamesBandageWrapEnabled = {
                    description = "Habilita el minijuego de envoltura de vendajes.",
                    label = "Envoltura de vendaje",
                },
                minigamesBloodPressureEnabled = {
                    description = "Habilita el minijuego de presión arterial.",
                    label = "Presión arterial",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Habilita el minijuego de transfusión de sangre.",
                    label = "Transfusión de sangre",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Habilita el minijuego de extracción de balas.",
                    label = "Extracción de balas",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Respiraciones requeridas durante cada fase de ventilación.",
                    label = "Respiraciones por ciclo",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Segundos para completar una serie de compresión.",
                    label = "Duración de la compresión por serie",
                },
                minigamesCprCompressionWindow = {
                    description = "Desplazamiento permitido al alcanzar un ritmo de compresión.",
                    label = "Ventana de compresión",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Habilite la etapa del minijuego de compresiones de RCP.",
                    label = "Compresiones RCP",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Número de compresiones por serie.",
                    label = "Compresiones por serie",
                },
                minigamesCprCycles = {
                    description = "¿Cuántos ciclos de RCP se necesitan para terminar el minijuego?",
                    label = "Ciclos",
                },
                minigamesCprEnabled = {
                    description = "Habilita el minijuego de RCP.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Cuenta atrás antes de que comiencen las compresiones de RCP.",
                    label = "Segundos de retraso de introducción",
                },
                minigamesCprMaxMisses = {
                    description = "Fallos permitidos antes de fallar el minijuego de RCP.",
                    label = "max falla",
                },
                minigamesCprSetsPerCycle = {
                    description = "¿Cuántas series de compresión se ejecutan antes de una etapa de respiración?",
                    label = "Conjuntos por ciclo",
                },
                minigamesCprVentilationEnabled = {
                    description = "Habilite la etapa del minijuego de ventilación RCP.",
                    label = "Ventilación RCP",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Habilita el minijuego del medidor de glucosa.",
                    label = "Medidor de glucosa",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Habilita el minijuego de medición del pulso.",
                    label = "Medición del pulso",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Habilita el minijuego del oxímetro de pulso.",
                    label = "Oxímetro de pulso",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Habilita el minijuego de infusión salina.",
                    label = "Infusión salina",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Segundos antes de que se agote el tiempo de un intento de ventilación. Establezca 0 para desactivar.",
                    label = "Segundos de tiempo de respiración",
                },
                minigamesVentilationEnabled = {
                    description = "Habilita el minijuego de ventilación.",
                    label = "Ventilación",
                },
                minigamesVentilationTolerance = {
                    description = "Tolerancia de distancia de píxeles al rastrear la onda del flujo de aire.",
                    label = "Tolerancia",
                },
                operationsBreakDistance = {
                    description = "Distancia máxima que pueden alejarse los participantes antes de interrumpir el procedimiento.",
                    label = "Distancia de interrupción",
                },
                operationsDoctorAnimationDict = {
                    description = "Diccionario de animación de GTA usado por el cirujano durante una intervención real.",
                    label = "Diccionario de animación del cirujano",
                },
                operationsDoctorAnimationFlag = {
                    description = "Indicador de animación de GTA aplicado al cirujano durante una intervención real.",
                    label = "Indicador de animación del cirujano",
                },
                operationsDoctorAnimationName = {
                    description = "Clip de animación usado por el cirujano durante una intervención real.",
                    label = "Nombre de animación del cirujano",
                },
                operationsEnabled = {
                    description = "Activa los quirófanos y los procedimientos quirúrgicos.",
                    label = "Activado",
                },
                operationsFadeInMs = {
                    description = "Duración en milisegundos del fundido de entrada del paciente al despertar.",
                    label = "Fundido de despertar (ms)",
                },
                operationsFadeOutMs = {
                    description = "Duración en milisegundos del fundido a negro del paciente durante la anestesia.",
                    label = "Fundido de anestesia (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Tiempo máximo sin una acción válida del minijuego antes de que se aborte la sesión.",
                    label = "Tiempo límite de inactividad (s)",
                },
                operationsInteractDistance = {
                    description = "Distancia máxima para mostrar y usar las interacciones del quirófano.",
                    label = "Distancia de interacción",
                },
                operationsInteractKey = {
                    description = "ID de control utilizado para interactuar con la mesa de operaciones y la posición del cirujano.",
                    label = "Tecla de interacción",
                },
                operationsPatientAnimationDict = {
                    description = "Diccionario de animación de GTA usado mientras el paciente está bajo anestesia general.",
                    label = "Diccionario de animación del paciente",
                },
                operationsPatientAnimationFlag = {
                    description = "Indicador de animación de GTA aplicado a la animación del paciente tumbado.",
                    label = "Indicador de animación del paciente",
                },
                operationsPatientAnimationName = {
                    description = "Clip de animación usado mientras el paciente está bajo anestesia general.",
                    label = "Nombre de animación del paciente",
                },
                operationsPatientRange = {
                    description = "Radio máximo utilizado para detectar a un paciente tumbado en la mesa de operaciones.",
                    label = "Radio del paciente",
                },
                operationsRequireOnDuty = {
                    description = "Exige que los cirujanos estén de servicio antes de usar un quirófano.",
                    label = "Requerir servicio",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Tiempo máximo que el cirujano puede permanecer en la selección de operación antes de que se aborte la sesión.",
                    label = "Tiempo límite de selección (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Diccionario de animación de GTA usado para el entrenamiento quirúrgico sin paciente.",
                    label = "Diccionario de animación de entrenamiento",
                },
                operationsTrainingAnimationFlag = {
                    description = "Indicador de animación de GTA aplicado a la animación de entrenamiento quirúrgico.",
                    label = "Indicador de animación de entrenamiento",
                },
                operationsTrainingAnimationName = {
                    description = "Clip de animación usado para el entrenamiento quirúrgico sin paciente.",
                    label = "Nombre de animación de entrenamiento",
                },
                painClassesProfiles = {
                    description = "Umbrales de dolor, etiquetas y efectos de posprocesamiento.",
                    label = "clases de dolor",
                },
                painEffectsMinPainLevel = {
                    description = "Nivel mínimo de dolor antes de que comiencen los efectos de la pantalla de dolor.",
                    label = "Nivel mínimo de dolor",
                },
                primaryColor = {
                    description = "Color principal de la interfaz EMS y del grupo de trabajos de ambulancia.",
                    label = "color primario",
                },
                propPlacementConsumeItem = {
                    description = "Consume el artículo del inventario correspondiente cuando se coloque el accesorio.",
                    label = "Consumir artículo",
                },
                propPlacementEnabled = {
                    description = "Permitir que se coloquen accesorios EMS configurados a partir de elementos de inventario utilizables.",
                    label = "Activado",
                },
                propPlacementItemNames = {
                    description = "Asigne modelos de accesorios de EMS a nombres de artículos de inventario para su ubicación basada en artículos.",
                    label = "Nombres de elementos de utilería",
                },
                propPlacementRequireOnDuty = {
                    description = "Exija que el jugador esté de servicio antes de colocar accesorios EMS.",
                    label = "Requerir de turno",
                },
                propPlacementReturnItem = {
                    description = "Devuelve el objeto consumido cuando se retira un objeto colocado.",
                    label = "Devolver artículo al eliminarlo",
                },
                propPlacementVehicleAccess = {
                    description = "Permita que los accesorios del baúl abran el flujo de ubicación en lugar del uso exclusivo de elementos.",
                    label = "Acceso de vehículos",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Permitir el trato público a jugadores conscientes.",
                    label = "Permitir que los pacientes conscientes",
                },
                publicTreatmentAllowedGangs = {
                    label = "Bandas permitidas",
                    description = "Selecciona nombres internos de bandas u organizaciones independientes. Un trabajo o banda coincidente concede el permiso o exención. El servicio solo se exige a los trabajos. Rangos mínimos opcionales. Una lista vacía permite todos los rangos. Los requisitos de objetos siguen vigentes.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Trabajos que podrán utilizar tratamiento público sin ser EMS.",
                    label = "Trabajos permitidos",
                },
                publicTreatmentEnabled = {
                    description = "Habilite el tratamiento público para personal que no sea de EMS con acceso válido.",
                    label = "Tratamiento Público habilitado",
                },
                publicTreatmentInteractDistance = {
                    description = "Distancia máxima requerida para iniciar el tratamiento público.",
                    label = "Interactuar a distancia",
                },
                publicTreatmentKeybind = {
                    description = "Combinación de teclas de interacción predeterminada utilizada para el tratamiento público.",
                    label = "Combinación de teclas",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Muestra el aviso de tratamiento y activa su tecla. Desactiva esta opción si usas exports o un menú radial personalizado.",
                    label = "Interacción por teclado activada",
                },
                publicTreatmentPromptDistance = {
                    description = "Distancia utilizada para mostrar el aviso de trato al público.",
                    label = "distancia inmediata",
                },
                publicTreatmentRequireAllItems = {
                    description = "Requerir todos los artículos médicos enumerados en lugar de solo uno.",
                    label = "Requerir todos los artículos",
                },
                publicTreatmentRequiredItems = {
                    description = "Artículos de inventario que cuentan como equipo de tratamiento público válido.",
                    itemLabel = "Artículo",
                    label = "Artículos requeridos",
                },
                reviveRewardAccount = {
                    description = "Clave de cuenta principal utilizada para revivir pagos de recompensas.",
                    label = "Cuenta",
                },
                reviveRewardAccountType = {
                    description = "Tipo de cuenta principal utilizada para revivir pagos de recompensas.",
                    label = "Tipo de cuenta",
                },
                reviveRewardAmount = {
                    description = "Monto de la recompensa pagada al médico por una reanimación.",
                    label = "Cantidad",
                },
                reviveRewardCurrency = {
                    description = "Clave de moneda personalizada opcional que se utiliza para reactivar los pagos de recompensas.",
                    label = "Divisa",
                },
                reviveRewardEnabled = {
                    description = "Paga una recompensa configurada después de una reanimación médica exitosa.",
                    label = "Activado",
                },
                reviveRewardPayFromSociety = {
                    description = "Deduzca las recompensas por reactivación de la sociedad de trabajo compartido antes de pagarle al médico.",
                    label = "pagar de la sociedad",
                },
                selfDiagnoseCommand = {
                    description = "Comando de chat utilizado para abrir el autodiagnóstico.",
                    label = "Dominio",
                },
                selfDiagnoseEnabled = {
                    description = "Permita que los jugadores abran la interfaz de usuario de diagnóstico sobre sí mismos.",
                    label = "Autodiagnóstico habilitado",
                },
                selfDiagnoseKeybind = {
                    description = "Combinación de teclas predeterminada utilizada para abrir el autodiagnóstico.",
                    label = "Combinación de teclas",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Retraso antes de que se abra la IU de autodiagnóstico.",
                    label = "Retardo de apertura ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Restrinja el autodiagnóstico únicamente a trabajos médicos.",
                    label = "Requiere trabajo médico",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "No congele el reproductor mientras realiza el autodiagnóstico.",
                    label = "Saltar congelación en uno mismo",
                },
                statusEffectsProfiles = {
                    description = "Efectos de pantalla configurados y umbrales para sangrado, niveles bajos de sangre, hambre y sed.",
                    label = "Efectos de estado",
                },
                stretcherAnimDict = {
                    description = "Diccionario de animación utilizado mientras se lleva la camilla.",
                    label = "dictado de animación",
                },
                stretcherAnimName = {
                    description = "Nombre de la animación utilizada mientras se lleva la camilla.",
                    label = "Nombre de la animación",
                },
                stretcherAttachRx = {
                    description = "Lleva acoplador X de rotación para la camilla.",
                    label = "Adjuntar RX",
                },
                stretcherAttachRy = {
                    description = "Lleva acoplador de rotación Y para la camilla.",
                    label = "Adjuntar RY",
                },
                stretcherAttachRz = {
                    description = "Lleva acoplador de rotación Z para la camilla.",
                    label = "Adjuntar RZ",
                },
                stretcherAttachX = {
                    description = "Llevar acoplador X desplazado para la camilla.",
                    label = "Adjuntar X",
                },
                stretcherAttachY = {
                    description = "Lleva acoplador en Y desplazado para la camilla.",
                    label = "Adjuntar Y",
                },
                stretcherAttachZ = {
                    description = "Transporte acoplar desplazamiento Z para la camilla.",
                    label = "Adjuntar Z",
                },
                stretcherFoldedEnabled = {
                    description = "Habilitar la variante opcional de camilla plegada en el interior de los vehículos.",
                    label = "Plegado habilitado",
                },
                stretcherFoldedModel = {
                    description = "Modelo de utilería utilizado para la variante de camilla plegada.",
                    label = "modelo plegado",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Cabecera del paciente utilizada para la variante de camilla plegada.",
                    label = "Encabezado de paciente doblado",
                },
                stretcherFoldedPatientAttachX = {
                    description = "El paciente coloca el desplazamiento X para la camilla plegada.",
                    label = "Paciente plegado X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Colocación del paciente en Y desplazado para la camilla plegada.",
                    label = "Paciente plegado Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Colocación del paciente desplazada en Z para la camilla plegada.",
                    label = "Paciente plegado Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Anulación de la distancia de interacción utilizada para helicópteros.",
                    label = "Distancia de interacción del helicóptero",
                },
                stretcherHelicopterModels = {
                    description = "Modelos de vehículos tratados como helicópteros camilla.",
                    itemLabel = "Modelo",
                    label = "Modelos de helicópteros",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Anulación de la distancia de recogida utilizada para helicópteros.",
                    label = "Distancia de recogida del helicóptero",
                },
                stretcherInteractDistance = {
                    description = "Distancia máxima para indicaciones de interacción con la camilla.",
                    label = "Interactuar a distancia",
                },
                stretcherItemEnabled = {
                    description = "Activa el objeto de camilla del inventario, incluida su compra en la tienda y su uso.",
                    label = "Objeto camilla",
                },
                stretcherItemPickupEnabled = {
                    description = "Permite devolver al inventario las camillas desplegadas desde el objeto del inventario.",
                    label = "Recogida del objeto",
                },
                stretcherModel = {
                    description = "Modelo de soporte de camilla primario utilizado por el sistema de camilla EMS.",
                    label = "Modelo",
                },
                stretcherPatientAnimationDict = {
                    description = "Diccionario de animación para pacientes en camilla y el PNJ de vista previa.",
                    label = "Diccionario de animación del paciente",
                },
                stretcherPatientAnimationName = {
                    description = "Clip de animación para pacientes en camilla y el PNJ de vista previa.",
                    label = "Nombre de animación del paciente",
                },
                stretcherPatientAttachHeading = {
                    description = "Cabecera del paciente utilizada mientras está acostado en la camilla.",
                    label = "encabezado del paciente",
                },
                stretcherPatientAttachX = {
                    description = "Paciente colocado X desplazado en la camilla.",
                    label = "Paciente X",
                },
                stretcherPatientAttachY = {
                    description = "Colocación del paciente desplazada en Y sobre la camilla.",
                    label = "Paciente Y",
                },
                stretcherPatientAttachZ = {
                    description = "El paciente se fija en Z desplazado sobre la camilla.",
                    label = "Paciente Z",
                },
                stretcherPickupDistance = {
                    description = "Distancia requerida para recoger e interactuar con la camilla.",
                    label = "Distancia de recogida",
                },
                stretcherTreatmentAnimClip = {
                    description = "Clip de animación utilizado mientras se trata a un paciente en camilla. Déjelo vacío para usar un escenario o el respaldo de la animación del tratamiento.",
                    label = "Nombre de la animación",
                },
                stretcherTreatmentAnimDict = {
                    description = "Diccionario de animación utilizado mientras se trata a un paciente en camilla. Déjelo vacío para usar un escenario o el respaldo de la animación del tratamiento.",
                    label = "Diccionario de animación",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Escenario opcional utilizado mientras se trata a un paciente en camilla. Déjelo vacío para usar dict + clip o el respaldo de la animación del tratamiento.",
                    label = "Guión",
                },
                stretcherVehicleAttachRx = {
                    description = "Enganche al vehículo con rotación X para cargar la camilla.",
                    label = "RX del vehículo",
                },
                stretcherVehicleAttachRy = {
                    description = "Fijación del vehículo con rotación en Y para carga de la camilla.",
                    label = "Vehículo RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Enganche al vehículo con rotación en Z para cargar la camilla.",
                    label = "Vehículo RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Enganche al vehículo con desplazamiento X para cargar la camilla.",
                    label = "Vehículo X",
                },
                stretcherVehicleAttachY = {
                    description = "Enganche al vehículo con desplazamiento en Y para cargar la camilla.",
                    label = "Vehículo Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Enganche al vehículo con desplazamiento en Z para cargar la camilla.",
                    label = "Vehículo Z",
                },
                stretcherVehicleModels = {
                    description = "Modelos de vehículos autorizados para cargar la camilla.",
                    itemLabel = "Modelo",
                    label = "Modelos de vehículos",
                },
                treatmentAnimClip = {
                    description = "Clip de animación utilizado mientras se trata a un paciente. Déjelo vacío para usar un escenario en su lugar.",
                    label = "Nombre de la animación",
                },
                treatmentAnimDict = {
                    description = "Diccionario de animación utilizado durante el tratamiento de un paciente. Déjelo vacío para usar un escenario en su lugar.",
                    label = "Diccionario de animación",
                },
                treatmentAnimScenario = {
                    description = "Escenario utilizado durante el tratamiento de un paciente. Déjelo vacío para usar dict + clip en su lugar.",
                    label = "Guión",
                },
                trunkPropsEnabled = {
                    label = "Props del vehículo",
                    description = "Elige props junto a un vehículo de servicio cercano.",
                },
                trunkEnabled = {
                    description = "Habilite la función de maletero del vehículo para vehículos de ambulancia.",
                    label = "Activado",
                },
                vehicleDamageModifier = {
                    description = "El multiplicador de daño se aplica mientras el jugador está dentro de un vehículo.",
                    label = "Modificador de daños al vehículo",
                },
                vehicleImpactProtectionCauses = {
                    description = "Causas de muerte que deben contar como impactos de vehículos protegidos.",
                    itemLabel = "Causa",
                    label = "Causas de daño",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Evite que los impactos de vehículos a baja velocidad maten al jugador.",
                    label = "Activado",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Los impactos de vehículos por debajo de esta velocidad no pueden matar al jugador.",
                    label = "Velocidad fatal km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Los impactos de vehículos a esta velocidad o por encima de ella utilizan la configuración normal de lesiones mortales.",
                    label = "Velocidad de daño total km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Lesiones que se aplican cuando la protección contra impactos de un vehículo bloquea un impacto fatal.",
                    itemLabel = "Lesión",
                    label = "Lesiones",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Porcentaje de salud máxima conservada cuando un impacto protegido habría matado al jugador.",
                    label = "Porcentaje de salud de supervivencia",
                },
                vehiclePullEnabled = {
                    description = "Permitir sacar pacientes de los vehículos.",
                    label = "Activado",
                },
                vehiclePullMaxDistance = {
                    description = "Distancia máxima requerida para sacar a un paciente de un vehículo.",
                    label = "Distancia máxima",
                },
                wheelchairAssignMaxDistance = {
                    description = "Distancia máxima para asignar una silla de ruedas a otro jugador.",
                    label = "Asignar distancia máxima",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Desequipar automáticamente la silla de ruedas cuando expire la asignación.",
                    label = "Desequipamiento automático al expirar",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Duración predeterminada de la silla de ruedas asignada en minutos.",
                    label = "Duración predeterminada",
                },
                wheelchairDisableSprint = {
                    description = "Bloquee el sprint mientras la silla de ruedas está equipada.",
                    label = "Desactivar sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Bloquee el uso de armas mientras la silla de ruedas esté equipada.",
                    label = "Desactivar armas",
                },
                wheelchairExitControl = {
                    description = "ID de control utilizado para abandonar la silla de ruedas.",
                    label = "control de salida",
                },
                wheelchairItemName = {
                    description = "Artículo de inventario utilizado para la silla de ruedas.",
                    label = "Nombre del artículo",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Duración máxima permitida de la asignación de silla de ruedas en minutos.",
                    label = "Duración máxima",
                },
                wheelchairMinDurationMinutes = {
                    description = "Duración mínima permitida de la asignación de silla de ruedas en minutos.",
                    label = "Duración mínima",
                },
                wheelchairVehicle = {
                    description = "Modelo de vehículo utilizado para la silla de ruedas.",
                    label = "Modelo de vehículo",
                },
                xrayInteractionRange = {
                    description = "Distancia máxima desde la estación de rayos X para el operador.",
                    label = "Rango de interacción",
                },
                xrayPatientRange = {
                    description = "Distancia máxima desde la estación de rayos X para el paciente.",
                    label = "Rango de pacientes",
                },
                xrayScanDurationSeconds = {
                    description = "Duración en segundos del resultado de la exploración de rayos X.",
                    label = "Duración del escaneo",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Refrigeración en segundos entre intentos de reserva del paciente.",
                    label = "Refrigeración de reserva",
                },
                appointmentsEnabled = {
                    description = "Activar la cita con el paciente y el calendario médico personal.",
                    label = "Activado",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Máximo número de días en el futuro que los pacientes pueden reservar.",
                    label = "Reserva anticipada máxima",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "El número máximo de citas futuras activas que un paciente puede tener.",
                    label = "Citas máximas por paciente",
                },
                appointmentsMinLeadMinutes = {
                    description = "Número mínimo de minutos entre la reserva y la cita.",
                    label = "Tiempo mínimo de ejecución",
                },
                appointmentsNotificationApp = {
                    description = "Identificador de la aplicación telefónica utilizado para las notificaciones de citas.",
                    label = "Aplicación de notificación",
                },
                appointmentsNotificationsEnabled = {
                    description = "Notificar a los pacientes en su teléfono cuando las citas se reservan o cancelan.",
                    label = "Comunicaciones telefónicas",
                },
                appointmentsReasonMaxLength = {
                    description = "Número máximo de caracteres aceptados por motivo de nombramiento.",
                    label = "Límite del carácter de la razón",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Duración e intervalo de la cuadrícula de una cita ranura en minutos.",
                    label = "Duración de la franja horaria",
                },
                enforceMaxHealth = {
                    description = "Mantenga la máxima salud del jugador en 200. Deshabilite esto cuando otro recurso administra la máxima salud.",
                    label = "Hacer cumplir 200 max salud",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Licencias marco adicionales que el personal de ambulancias puede dar o eliminar en los registros de pacientes. La licencia de primeros auxilios configurada siempre está incluida.",
                    itemLabel = "Licencia",
                    label = "Licencias adicionales para pacientes",
                },
                minigamesBandageWrapRandomization = {
                    description = "Aleatorizar la dirección, la forma y las proporciones del camino de la gasa.",
                    label = "Variación del envoltorio de vendaje",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Aleatorizar el camino de acceso venoso para transfusiones de sangre.",
                    label = "Variación del acceso a la transfusión",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Requerir el procedimiento de acceso venoso de varios pasos antes de controlar el flujo. Deshabilitar para la versión antigua simple.",
                    label = "Etapa de acceso venoso",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Aleatorizar la forma, el ancho y las obstrucciones del canal de la herida.",
                    label = "Variación de la extracción de balas",
                },
                stretcherVehicleAttachEditor = {
                    description = "Coloque y gire la camilla dentro de una ambulancia configurada.",
                    label = "Fijación del vehículo",
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
            warnings = {
                firstAidPublicTreatmentConflict = "No se pueden habilitar al mismo tiempo Primeros Auxilios y Tratamiento Público. Guardar desactiva ambos.",
            },
        },
    },
}
