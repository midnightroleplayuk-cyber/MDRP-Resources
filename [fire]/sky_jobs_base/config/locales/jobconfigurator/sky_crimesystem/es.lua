JobConfigLocales["sky_crimesystem:es"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Comando directo",
            roleDefaults = {
                title = "Roles",
                description = "Elige el rango mínimo para cada permiso predeterminado. Los permisos de rango guardados en el menú del jefe tienen prioridad.",
                bossHint = "Los rangos de jefe y subjefe siempre conservan acceso completo.",
                empty = "Este trabajo aún no tiene rangos disponibles.",
                gradesTitle = "Rangos del trabajo",
                noDefault = "Sin permiso predeterminado",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Los valores compartidos se aplican a los campos heredados. Cambiar un valor en su página de ajustes lo convierte en un valor propio. Las entradas existentes conservan sus valores.",
            weaponStreetDescription = "Al usar un contacto callejero de drogas, el servidor puede comprar ocasionalmente un arma válida. La selección, el precio y el pago se deciden en el servidor.",
            weaponGroups = {
                general = "Valores generales",
                access = "Valores de acceso",
                collection = "Valores de recolección",
                production = "Valores de producción",
                market = "Valores de mercado",
                delivery = "Valores de pedidos",
                street = "Venta callejera de armas",
            },
            weaponOptions = {
                scrap_search = "Buscar en la chatarra",
                player = "Por jugador",
                global = "Mundial",
                money = "Efectivo",
                bank = "Cuenta bancaria",
                black_money = "Dinero negro",
                timing = "Detén el indicador dentro del rango óptimo.",
                precision = "Sincroniza cada corte dentro de la ventana de precisión.",
                pressure = "Detén la prensa en su presión óptima.",
            },

            reputation = {
                remove = "Eliminar",
                title = "Reputación",
                action = "Acción",
                points = "Puntos por finalización",
                enabled = "Activa",
                search = "Buscar acciones",
                added = "Ya añadida",
                noResults = "No se encontraron acciones coincidentes.",
                empty = "Todavía no hay acciones. Usa el botón más para añadir una.",
                name = "Nombre de la regla",
                target = "Objetivo (opcional)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Facciones",
                    subtitle = "Configura los trabajos criminales y sus ubicaciones compartidas.",
                    title = "Sistema de crimen",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Base principal",
                    entryPluralLabel = "Bases principales",
                    label = "Zona de base principal",
                },
                presetTerritories = {
                    label = "Distritos preestablecidos",
                    entryLabel = "Distrito preestablecido",
                    entryPluralLabel = "Distritos preestablecidos",
                },
                customTerritories = {
                    label = "Territorios personalizados",
                    entryLabel = "Territorio personalizado",
                    entryPluralLabel = "Territorios personalizados",
                },
                objectsSection = {
                    label = "Objetos de interrogatorio",
                    entryLabel = "Objeto",
                    entryPluralLabel = "Objetos de interrogatorio",
                },
                blockedZonesSection = {
                    label = "Zonas bloqueadas",
                    entryLabel = "Zona",
                    entryPluralLabel = "Zonas bloqueadas",
                },
                toolsSection = {
                    label = "Herramientas",
                    entryLabel = "Herramienta",
                    entryPluralLabel = "Herramientas",
                },
                sessionsSection = {
                    label = "Sesiones en curso",
                    entryLabel = "Sesión",
                    entryPluralLabel = "Sesiones en curso",
                },
                orphansSection = {
                    label = "Objetos huérfanos",
                    entryLabel = "Objeto",
                    entryPluralLabel = "Objetos huérfanos",
                },
            },
            darknetActions = {
                currentLocation = "Usar ubicación actual",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Los valores más altos hacen que el mal cuidado sea mucho más lento, mientras que preservan bonificaciones fuertes para un buen cuidado.",
                    label = "Curva de respuesta al cuidado",
                },
                drugGrowthMaxMultiplier = {
                    description = "Multiplicador de crecimiento máximo alcanzado en condiciones excelentes.",
                    label = "Multiplicador de cuidado perfecto",
                },
                drugGrowthMinMultiplier = {
                    description = "Multiplicador de crecimiento utilizado cuando las condiciones de la planta son críticamente malas.",
                    label = "Multiplicador de cuidado crítico",
                },
                drugGrowthQualityBonusMax = {
                    description = "Bonificación de crecimiento adicional máxima otorgada por la calidad de la planta.",
                    label = "Bonificación de crecimiento por calidad",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Elige rangos mínimos válidos para los permisos de los roles.",
                base_raid_locked = "La base está siendo asaltada. Sus ubicaciones de almacenamiento y configuración están bloqueadas.",
                base_storage_outside_zone = "Todos los puntos de almacenamiento, taquillas y almacenamiento de atracos deben estar dentro de la zona de la base.",
                base_zone_invalid_polygon = "Coloca al menos tres puntos distintos sin cruzar bordes, luego comprueba la altura (3–200 m) y el grupo de rutas.",
                base_zone_point_limit = "Una zona de base principal admite como máximo 64 puntos de límite.",
                base_zone_required = "Configura primero una zona de base principal válida para este trabajo criminal.",
                crime_interrogation_invalid_model = "Introduce un modelo de objeto válido.",
                crime_interrogation_invalid_coords = "Coloca el objeto en una posición válida.",
                crime_interrogation_invalid_zone_points = "Coloca al menos tres puntos de límite válidos.",
                crime_interrogation_duplicate_id = "Ya existe un objeto con este ID.",
                crime_interrogation_tool_invalid = "Revisa la definición de la herramienta.",
                crime_interrogation_tool_id_invalid = "Introduce un ID de herramienta válido.",
                crime_interrogation_tool_label_missing = "Introduce un nombre para la herramienta.",
                crime_interrogation_effect_missing = "Configura un efecto para la herramienta.",
                crime_interrogation_effect_type_unknown = "Selecciona un tipo de efecto compatible.",
                crime_interrogation_effect_status_missing = "Indica el estado afectado por esta herramienta.",
                crime_interrogation_minigame_missing = "Configura un minijuego para la herramienta.",
                crime_interrogation_minigame_type_unknown = "Selecciona un tipo de minijuego compatible.",
                crime_interrogation_keys_missing = "Configura los controles de la herramienta.",
                crime_interrogation_keys_invalid = "Revisa los controles configurados de la herramienta.",
                crime_interrogation_keys_duplicate = "Asigna cada acción y control de herramienta una sola vez.",
                crime_interrogation_anim_invalid = "Revisa el diccionario y el clip de animación de la herramienta.",
                crime_interrogation_anim_missing = "Configura una animación para el usuario de la herramienta.",
                crime_interrogation_occupied = "Ya hay alguien atado a este objeto.",
                crime_interrogation_not_found = "Eso ya no está ahí.",
            },
            extensions = {
                baseZone = {
                    description = "Coloca los puntos límite de 3 a 64 en orden. El punto más bajo establece la base; la altura se extiende hacia arriba desde allí. Los puntos se guardan como borrador; usa Guardar para aplicar la zona. Solo el almacenamiento, las taquillas y el almacenamiento de atraco dentro de la zona son accesibles durante las incursiones. Los puntos fuera de la zona no impiden guardar ni iniciar una incursión. Los límites existentes permanecen activos hasta que guardes.",
                    fields = {
                        bucket = "Bucket de enrutamiento",
                        configured = "Configurado",
                        height = "Altura (metros)",
                        radius = "Radio (metros)",
                        x = "Centro X",
                        y = "Centro Y",
                        z = "Centro Z",
                    },
                    label = "Zona de base principal",
                },
                invalidSelection = "Selección no válida: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Punto principal de esta ubicación de trabajo. Si el marcador en el mapa está activado en Trabajo → Marcadores, aparecerá aquí.",
            },
            locationTypes = {
                crimeStationPosition = "Ubicación / marcador de mapa",
                heistCrafting = "Taller de atraco",
                heistStorage = "Almacén de atracos",
            },
            membershipMigration = {
                cancel = "Cancelar",
                confirm = "Migrar y guardar",
                message = "Las membresías de organizaciones existentes se migrarán al modelo seleccionado. El empleo normal permanece separado en el modo independiente.",
                title = "¿Cambiar modelo de membresía?",
            },
            moneywashActions = {
                currentLocation = "Usar ubicación actual",
                invalidLocations = "Comprueba las IDs, nombres, selecciones de interiores y coordenadas. Cada ubicación necesita una ID única.",
                position = "Posición",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Puntos de construcción", description = "Coloca equipos compatibles en estos puntos. Coordenadas relativas al interior seleccionado." },
                mwBuildNodes = "Puntos de construcción",
                moneywashPublicEquipment = { label = "Equipamiento público", description = "Asigna lavadoras, generadores y ventiladores a locales públicos y puntos compatibles." },
                mwPublicEquipment = "Equipamiento público",
                moneywashMaterials = { label = "Materiales", description = "Usa nombres exactos del inventario. Peso en gramos; instala los objetos que falten." },
                mwMaterials = "Materiales",
                moneywashMaterialRecipes = { label = "Recetas de materiales", description = "Entradas, salidas y duración por unidad. Los procesadores usan estas recetas." },
                mwMaterialRecipes = "Recetas de materiales",
                moneywashProductionRecipes = { label = "Recetas de impresión", description = "Papel, tinta y tiempos por unidad. Efectivo después del secado y control de calidad." },
                mwProductionRecipes = "Recetas de impresión",
                moneywashCollectors = { label = "Recolectores", description = "Configura rendimiento, herramientas, espera y posición de cada recolector." },
                mwCollectors = "Recolectores",
                moneywashProcessors = { label = "Procesadores", description = "Elige receta de materiales y posición de cada procesador." },
                mwProcessors = "Procesadores",

                control = "Panel de control",
                editor = {
                    addBusiness = "Añadir negocio",
                    addInterior = "Añadir interior",
                    advanced = "Detalles técnicos",
                    asset_ipl = "IPL: Introduce el nombre exacto del IPL y la posición del interior.",
                    asset_mlo = "MLO: Utiliza la posición de un interior ya instalado. El acceso utiliza actualmente la entrada del negocio.",
                    asset_shell = "Shell: El recurso del modelo debe estar instalado y ejecutándose en el servidor.",
                    businessHelp = "Nombra el negocio, elige su interior y establece el precio de compra.",
                    businessListHelp = "Gestiona las entradas y los precios de compra de tus negocios.",
                    businesses = "Negocios",
                    capture = "Establecer en el juego",
                    captureOrigin = "Establecer posición del interior",
                    chooseInterior = "Elegir un interior",
                    coordinates = "Editar coordenadas",
                    editSections = "Configuración",
                    emptyBusinessHelp = "Vincula una entrada del mapa a un interior. Tus organizaciones podrán entonces comprar el negocio vacío.",
                    emptyBusinesses = "Tu primer negocio",
                    emptyInteriorHelp = "Conecta una IPL, una shell o un MLO instalado, y luego establece los puntos utilizados por el negocio.",
                    emptyInteriors = "Tu primer interior",
                    entranceHelp = "Establece la entrada donde los jugadores deben comprar y entrar al negocio.",
                    freecamHelp = "Freecam: WASD para mover, Q/E arriba/abajo, Shift más rápido, Ctrl más lento. Clic derecho: mirar. Arrastrar gizmo, R rotar/mover, Enter colocar, Backspace cancelar.",
                    general = "Generales",
                    heading = "Orientación",
                    interiorHelp = "Elige el tipo de interior y su asset.",
                    interiorListHelp = "Prepara espacios vacíos. Los jugadores colocarán sus propias máquinas y equipamiento.",
                    interiors = "Interiores",
                    listEmpty = "Sin entradas.",
                    locationTypes = "Gestión de ubicaciones",
                    newBusiness = "Nuevo negocio",
                    newInterior = "Nuevo interior",
                    noResults = "No hay entradas coincidentes.",
                    notSet = "No establecido",
                    offsetHelp = "Los valores de entrada son desplazamientos desde el origen. La posición del mundo se muestra arriba.",
                    origin = "Origen",
                    originHelp = "Posición del interior. Todos los demás puntos son relativos a este.",
                    originRequired = "Establece primero la posición del interior en General.",
                    outsideRange = "Fuera del rango de {range} metros",
                    point_control = "Mueve y rota el panel de la pared con el gizmo hasta colocarlo. La altura confirmada del objeto se mantendrá exacta. Activa su marcador en Interacciones → Money Wash: panel de control.",
                    point_entry = "Aquí llegan y salen los jugadores. Salir les devuelve automáticamente a la entrada de su negocio en el exterior.",
                    point_position = "Este punto está fuera del negocio.",
                    point_storage = "Mueve y rota la estantería con el gizmo hasta que esté apoyada en el suelo. Los miembros acceden aquí al equipamiento comprado. Activa su marcador en Interacciones → Money Wash: almacén.",
                    points = "Puntos",
                    pointsHelp = "Selecciona un punto y establécelo directamente en el juego.",
                    rangeNote = "Se aplica un radio de {range} metros alrededor del origen del interior, sin restricción de altura.",
                    remove = "Eliminar",
                    repairRange = "Mueve estos puntos más cerca del origen del interior.",
                    saveHint = "Aplica los cambios con Guardar en la parte superior.",
                    search = "Buscar …",
                    set = "Establecido",
                    teleport = "Teletransporte",
                    viewInteriors = "Ver interiores",
                    visit = "Visitar",
                    visitHint = "Muévete libremente. Pulsa Backspace para volver al editor.",
                    visitTitle = "Visita al interior",
                },
                entry = "Entrada y salida",
                fields = {
                    mode = "Modo de acceso",
                    ownerKind = "Tipo de propietario",
                    productionEnabled = "Ampliación de impresión disponible",
                    feePercent = "Comisión (%) / -1 = global",
                    storageCapacity = "Capacidad del almacén (objetos)",
                    maximumOrders = "Pedidos simultáneos por jugador",
                    gridPower = "Potencia de red / 0 = generador",
                    autoService = "Mantenimiento público automático",
                    maximumPendingOutputs = "Máximo de pagos pendientes",
                    placementRange = "Radio de colocación (m)",
                    placementHeight = "Rango vertical de colocación (m)",
                    interiorId = "ID del interior",
                    equipmentId = "ID del equipo",
                    nodeId = "ID del punto de construcción",
                    generatorNode = "ID del punto del generador",
                    maxOffset = "Desplazamiento máximo del punto (m)",
                    maxHeight = "Desplazamiento vertical máximo (m)",
                    weight = "Peso del objeto (g)",
                    inputItem = "Material de entrada",
                    secondItem = "Segundo material de entrada",
                    outputItem = "Material de salida",
                    requiredTool = "Herramienta requerida",
                    baseQuality = "Calidad inicial (%)",
                    minimumQuality = "Calidad mínima (%)",
                    inspectionCards = "Tarjetas de revisión",
                    inspectionPenalty = "Pérdida de calidad por error (%)",
                    rejectPercent = "Billetes descartados (%)",
                    accessoryModel = "Modelo accesorio",
                    accessoryMaximum = "Máximo de accesorios visibles",
                    accessoryActiveOnly = "Accesorios solo durante el proceso",
                    animDict = "Diccionario de animación",
                    animClip = "Clip de animación",
                    cooldown = "Espera (segundos)",
                    minimum = "Rendimiento mínimo",
                    maximum = "Rendimiento máximo",
                    productionPrice = "Impresión de dinero · Precio de compra",
                    recipeId = "Receta ID",
                    inputAmount = "Material / por unidad",
                    secondAmount = "Material / por unidad",
                    outputAmount = "Material / por unidad",
                    paperItem = "Papel de impresión",
                    inkItem = "Tinta de impresión",
                    paperAmount = "Papel de impresión / por unidad",
                    inkAmount = "Tinta de impresión / por unidad",
                    notesPerUnit = "Billetes / por unidad",
                    valuePerNote = "Efectivo / Billetes",
                    maximumUnits = "Unidades (max.)",
                    printSeconds = "Imprimir / por unidad (Segundos)",
                    inspectionSeconds = "Revisar / por unidad (Segundos)",
                    rinseSeconds = "Lavar / por unidad (Segundos)",
                    drySeconds = "Secar / por unidad (Segundos)",
                    accessoryUnit = "Billetes / por unidad",
                    accessoryX = "Modelo accesorio · X (m)",
                    accessoryY = "Modelo accesorio · Y (m)",
                    accessoryZ = "Modelo accesorio · Z (m)",
                    accessoryStep = "Modelo accesorio · Z (m)",

                    capacity = "Capacidad por ciclo",
                    controlHeading = "Orientación del panel de control",
                    controlHeight = "Altura de montaje sobre el punto (m)",
                    controlModel = "Modelo de panel de pared",
                    controlX = "Panel de control X",
                    controlY = "Panel de control Y",
                    controlZ = "Panel de control Z",
                    disableSets = "Conjuntos de entidades ocultas (separados por comas)",
                    enableSets = "Conjuntos de entidades habilitados (separados por comas)",
                    entryX = "Desfase de entrada X",
                    entryY = "Desfase de entrada Y",
                    entryZ = "Desfase de entrada Z",
                    heading = "Dirección de orientación",
                    id = "ID único",
                    interior = "Interior",
                    ipl = "Nombre de la IPL",
                    kind = "Tipo",
                    label = "Nombre",
                    model = "Nombre del modelo",
                    power = "Unidades de energía",
                    price = "Precio de compra",
                    radius = "Radio de colocación (m)",
                    repairPrice = "Precio de reparación (0 = gratis)",
                    seconds = "Duración del ciclo (segundos)",
                    storageHeading = "Orientación del punto de almacén",
                    storageModel = "Modelo de estantería",
                    storageX = "Punto de almacén X",
                    storageY = "Punto de almacén Y",
                    storageZ = "Punto de almacén Z",
                    wear = "Desgaste por ciclo (%)",
                    x = "Origen X",
                    y = "Origen Y",
                    z = "Origen Z",
                },
                interactions = {
                    control = "Money Wash: panel de control",
                    storage = "Money Wash: almacén",
                },
                item = "Entrada",
                moneywashBucketStart = {
                    description = "Reserva este rango exclusivamente para el Lavado de Dinero. Los cambios se aplicarán en la próxima entrada.",
                    label = "Inicio del rango de instancia",
                },
                moneywashEquipment = {
                    description = "Los jugadores compran y colocan dispositivos. La capacidad, la duración y el desgaste se aplican a las lavadoras. La energía es el suministro del generador o la demanda del dispositivo. Los cambios afectan a las nuevas compras.",
                    label = "Equipamiento comprable",
                },
                moneywashInteriors = {
                    description = "Configura interiores vacíos de IPL, shell o MLO. El punto de entrada, el panel de control, el almacén y los límites de construcción son relativos al origen. Salir devuelve a los jugadores a la entrada de su negocio.",
                    label = "Interiores (IPL, shell o MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Máximo de dispositivos y kits de reparación comprados por negocio.",
                    label = "Límite de equipamiento",
                },
                moneywashPreviewBucketStart = {
                    description = "La visita añade el ID del jugador a este valor para una instancia de admin privada. Resérvalo por separado de los negocios y otros recursos. Los cambios se aplicarán en la siguiente vista previa.",
                    label = "Inicio del rango de instancia de vista previa",
                },
                moneywashProperties = {
                    description = "Establece una entrada, elige un interior y fija el precio de compra. Los negocios comprados conservan su interior y diseño guardados.",
                    label = "Entradas del negocio",
                },
                moneywashRepairShops = {
                    description = "Establece tiendas de reparación, teletranspórtate a ellas y fija el precio del servicio. Venden kits de reparación y dan servicio a las máquinas almacenadas.",
                    label = "Ubicaciones de tiendas",
                },
                moneywashShops = {
                    description = "Coloca tiendas para lavadoras, generadores y ventiladores. Los pedidos se envían al negocio seleccionado de la organización.",
                    label = "Ubicaciones de tiendas",
                },
                mwEquipment = "Tienda de equipamiento",
                mwInteriors = "Interiores vacíos",
                mwProperties = "Ubicaciones",
                mwRepairShops = "Taller de reparaciones",
                mwSettings = "Ajustes del negocio",
                names = {
                    mwPublicLaundry = "Lavandería pública",
                    mwPaperPulp = "Pasta de papel",
                    mwPrintingPaper = "Papel de impresión",
                    mwPrintingInk = "Tinta de impresión",
                    mwPaperRecipe = "Fabricar papel de impresión",
                    mwPrintingRecipe = "Billetes normales",
                    mwPaperCollector = "Recolector de papel",
                    mwInkCollector = "Recolector de tinta",
                    mwPaperProcessor = "Procesador de papel",
                    mwPrinter = "Imprenta",
                    mwInspectionTable = "Mesa de revisión",
                    mwDryingCabinet = "Armario de secado",
                    mwNode1 = "1 · Lavar",
                    mwNode2 = "2 · Lavar",
                    mwNode3 = "3 · Puntos de construcción",
                    mwNode4 = "4 · Imprimir",
                    mwNode5 = "5 · Revisar",
                    mwNode6 = "6 · Secar",
                    mwNode7 = "7 · Puntos de construcción",

                    mwInteriorWarehouse = "Almacén vacío",
                },
                options = {
                    private = "Privado",
                    public = "Público",
                    faction = "Organización",
                    person = "Personaje",
                    printer = "Imprenta",
                    inspection = "Mesa de revisión",
                    dryer = "Armario de secado",

                    fan = "Ventilador",
                    generator = "Generador",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Kit de reparación",
                    shell = "Modelo de shell",
                    washer = "Lavadora",
                },
                origin = "Origen",
                storage = "Punto de almacén",
            },
            settingFields = {
                cultivationLevel = "Nivel de cultivo",
                cultivationTitle = "Nombre del nivel",
                cultivationRequiredXp = "XP total requerida",
                cultivationAction = "Acción",
                cultivationXp = "XP",
                cultivationCategory = "Categoría",
                cultivationEntry = "Entrada",
                cultivationRequiredLevel = "Nivel requerido",
                alias = "Alias",
                atmHeading = "Orientación",
                atmId = "ID",
                atmModel = "Modelo de cajero",
                centerX = "Centro X",
                centerY = "Centro Y",
                centerZ = "Centro Z",
                deliveryMethod = "Método de entrega",
                description = "Descripción",
                enabled = "Activado",
                groupKey = "Clave de grupo",
                id = "ID",
                itemLabel = "Etiqueta de mercancía",
                itemName = "Nombre del objeto del inventario",
                knownScammer = "Estafador conocido",
                locationName = "Nombre de la ubicación",
                observerW = "Orientación del observador",
                observerX = "Observador X",
                observerY = "Observador Y",
                observerZ = "Observador Z",
                pedModel = "Modelo de ped NPC",
                pickpocketItemChance = "Probabilidad (%)",
                pickpocketItemMaximum = "Cantidad máxima",
                pickpocketItemMinimum = "Cantidad mínima",
                pickpocketItemName = "Nombre del objeto del inventario",
                quantity = "Cantidad",
                radius = "Radio",
                rating = "Calificación mostrada",
                ratingCount = "Cantidad de calificaciones mostradas",
                scamChance = "Probabilidad de estafa del comerciante (%)",
                shopCategory = "Categoría",
                shopClerkHeading = "Orientación del dependiente",
                shopClerkModel = "Modelo de dependiente",
                shopClerkRequired = "Se requiere dependiente",
                shopClerkX = "Dependiente X",
                shopClerkY = "Dependiente Y",
                shopClerkZ = "Dependiente Z",
                shopCodeEnabled = "Permitir apertura con código",
                shopDrillEnabled = "Permitir taladrado",
                shopEnabled = "Activado",
                shopHackEnabled = "Permitir hackeo",
                shopLocationId = "ID de la tienda",
                shopLocationLabel = "Etiqueta",
                shopRegisterId = "ID de caja registradora",
                shopSafeEnabled = "Caja fuerte activada",
                shopSafeHeading = "Orientación de la caja fuerte",
                shopSafeX = "Caja fuerte X",
                shopSafeY = "Caja fuerte Y",
                shopSafeZ = "Caja fuerte Z",
                side = "Lado del mercado",
                spawns = "Aparición de equipo",
                successfulTrades = "Transacciones exitosas mostradas",
                title = "Título de la oferta",
                unitPrice = "Precio por unidad",
                verified = "Comerciante verificado",
                w = "Orientación",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Posición del empleado",
                shopRegisterPosition = "Posición de la caja registradora",
                shopSafePosition = "Posición de la caja fuerte",
                registerId = "ID de la caja registradora",
                registerX = "Coordenada X de la caja",
                registerY = "Coordenada Y de la caja",
                registerZ = "Coordenada Z de la caja",
                heading = "Orientación",
                captureLocation = "Capturar ubicación",
            },
            crimeDashboard = {
                jobs = "Gestiona facciones, miembros, permisos y ubicaciones.",
                jobCreator = "Selecciona una facción para editar sus ubicaciones y zonas.",
                jobsQuestion = "¿Dónde edito facciones y ubicaciones?",
                jobsAnswer = "Abre {path}, selecciona una facción y elige Editar. Allí puedes configurar sus ajustes y ubicaciones.",
                creatorsAnswer = "Los creadores están en {path}. Estos enlaces abren el editor; las herramientas de facción comienzan seleccionando una facción.",
                missingAnswer = "Los creadores disponibles dependen del recurso seleccionado y de sus ajustes. Las herramientas de facción comienzan en la facción correspondiente.",
                creators = {
                    mainbaseZones = "Selecciona una facción y configura la zona de su base.",
                    presetTerritories = "Revisa los distritos predefinidos y elige cuáles están activos.",
                    objectsSection = "Gestiona las sillas de interrogatorio y los carros de herramientas permanentes.",
                    blockedZonesSection = "Define zonas donde no se pueden colocar objetos de interrogatorio.",
                    toolsSection = "Configura las herramientas disponibles durante los interrogatorios.",
                    sessionsSection = "Consulta los interrogatorios activos y finaliza sesiones cuando sea necesario.",
                    orphansSection = "Revisa y elimina los objetos de interrogatorio abandonados.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Elige cómo las organizaciones criminales almacenan y gestionan a sus miembros.",
                },
                territories = {
                    zones = "Configura «Zonas de territorio» en la sección «Territorios».",
                    ownership = "Configura «Propiedad» en la sección «Territorios».",
                    decay = "Configura «Decaimiento» en la sección «Territorios».",
                    presence = "Configura «Presencia» en la sección «Territorios».",
                    activity = "Configura «Puntuación de actividad» en la sección «Territorios».",
                    ownershipBenefits = "Configura «Beneficios de propiedad» en la sección «Territorios».",
                },
                graffiti = {
                    general = "Configura «Generales» en la sección «Grafiti».",
                    streaming = "Configura «Renderizado» en la sección «Grafiti».",
                    moderation = "Configura «Moderación» en la sección «Grafiti».",
                },
                pvpEvents = {
                    pvpAvailability = "Controla si la aplicación de eventos PvP está disponible y dónde aparece.",
                    pvpAutomation = "Configura los eventos recurrentes y el procesamiento de inicio automático.",
                    pvpRuntime = "Ajusta el manejo de solicitudes, las muertes y los reaparecimientos durante las partidas en vivo.",
                    pvpModes = "Configura el modo de juego preseleccionado en la tablet PvP.",
                    pvpArenas = "Crea la zona circular, el punto de observación y los puntos de aparición de equipos utilizados en eventos PvP.",
                    pvpLimits = "Establece los límites de recompensas e historial de la tablet.",
                    pvpPermissions = "Asigna la gestión de eventos y las finanzas a los permisos de ACE y de trabajo.",
                    pvpTakeoverRules = "Controla la disponibilidad y los requisitos de participación para las tomas de laboratorios y campistas.",
                    pvpTakeoverZones = "Configura las áreas de interacción, alerta y captura junto con sus duraciones.",
                    pvpTakeoverMethods = "Configura cuánto tarda cada método en forzar una entrada.",
                },
                drugs = {
                    creator = "Abre el editor de drogas de Sky Crime y cierra el configurador de empleos.",
                    creatorSettings = "Configura «Ajustes del editor» en la sección «Sistema de drogas».",
                    interfaceHud = "Configura «Posiciones de la interfaz» en la sección «Sistema de drogas».",
                    drugsGeneral = "Configura «Generales» en la sección «Sistema de drogas».",
                    runtimeAccess = "Configura «Acceso y propiedad» en la sección «Sistema de drogas».",
                    runtimePayouts = "Configura «Pagos» en la sección «Sistema de drogas».",
                    runtimeDispatch = "Configura «Central y policía» en la sección «Sistema de drogas».",
                    performanceInactiveControlIntervalMs = "Parámetro de funcionamiento para Rendimiento / Inactivo / Control / Intervalo / ms.",
                    performanceInteractionIdleScanIntervalMs = "Parámetro de funcionamiento para Rendimiento / Interacción / Inactivo / Intervalo de escaneo / ms.",
                    performanceInteractionPromptIntervalMs = "Parámetro de funcionamiento para Rendimiento / Interacción / Aviso de interacción / Intervalo / ms.",
                    performanceInteractionScanIntervalMs = "Parámetro de funcionamiento para Rendimiento / Interacción / Intervalo de escaneo / ms.",
                    performanceMinimumScanIntervalMs = "Parámetro de funcionamiento para Rendimiento / Mínimo / Intervalo de escaneo / ms.",
                    performanceStreetPedActivationDistance = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Activación / Distancia.",
                    performanceStreetPedIdleScanIntervalMs = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Inactivo / Intervalo de escaneo / ms.",
                    performanceStreetPedScanIntervalMs = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Intervalo de escaneo / ms.",
                    performanceWorldCachePadding = "Parámetro de funcionamiento para Rendimiento / Mundo / Caché / Margen adicional.",
                    performanceWorldCacheRefreshIntervalMs = "Parámetro de funcionamiento para Rendimiento / Mundo / Caché / Actualización / Intervalo / ms.",
                    performanceWorldIdleIntervalMs = "Parámetro de funcionamiento para Rendimiento / Mundo / Inactivo / Intervalo / ms.",
                },
                drugProduction = {
                    qualityWeights = "Configura «Calidad / Ponderaciones» en la sección «Producción de drogas».",
                    qualityTiers = "Configura «Calidad / Niveles de calidad» en la sección «Producción de drogas».",
                    packagingGeneral = "Configura «Generales» en la sección «Producción de drogas».",
                    processingFlow = "Configura «Flujo de procesamiento» en la sección «Producción de drogas».",
                    processingGeneral = "Configura «Generales» en la sección «Producción de drogas».",
                },
                drugOperations = {
                    growingGeneral = "Configura «Generales» en la sección «Operaciones de drogas».",
                    plantDefaults = "Configura «Planta / Valores predeterminados» en la sección «Operaciones de drogas».",
                    harvestWindow = "Configura «Cosecha / Ventana temporal» en la sección «Operaciones de drogas».",
                    labsGeneral = "Activa: laboratorios y autocaravanas en el juego.",
                    labRent = "Configura «Alquiler y ciclo de vida» en la sección «Operaciones de drogas».",
                    camperDefaults = "Configura «Autocaravana» en la sección «Operaciones de drogas».",
                    labUpgrades = "Multiplicador para Laboratorio / Nivel / Mejora / Precios.",
                    labDefaults = "Configura «Laboratorio / Valores predeterminados» en la sección «Operaciones de drogas».",
                    powerGeneral = "Configura «Generales» en la sección «Operaciones de drogas».",
                    generators = "Configura «Generadores» en la sección «Operaciones de drogas».",
                    equipmentWear = "Multiplicador global para Desgaste del equipo / Procesamiento.",
                    workersGeneral = "Configura «Generales» en la sección «Operaciones de drogas».",
                    cultivationGeneral = "Configura «Generales» en la sección «Operaciones de drogas».",
                    cultivationCurve = "Configura el nombre y la XP total requerida para cada nivel de cultivo.",
                    cultivationExperience = "Configura cuánta XP de cultivo otorga cada acción.",
                    cultivationUnlocks = "Configura el nivel requerido para contenedores, sustratos, equipo, variedades y niveles del escáner.",
                    powerRuntime = "Intervalo en segundos para actualización del consumo de generadores y las huellas eléctricas.",
                    powerHeat = "Configura «Sospecha y huella eléctrica» en la sección «Operaciones de drogas».",
                    powerModes = "Configura «Gestión / Modos» en la sección «Operaciones de drogas».",
                    powerPriorities = "Configura «Carga / Prioridades» en la sección «Operaciones de drogas».",
                },
                drugMarketRisk = {
                    marketGeneral = "Configura «Generales» en la sección «Mercado y riesgo».",
                    marketPrices = "Configura «Precios» en la sección «Mercado y riesgo».",
                    distribution = "Configura «Distribución» en la sección «Mercado y riesgo».",
                    threatsGeneral = "Configura «Generales» en la sección «Mercado y riesgo».",
                    threatHeat = "Configura «Presión policial» en la sección «Mercado y riesgo».",
                    threatChances = "Configura «Probabilidades» en la sección «Mercado y riesgo».",
                    consumptionGeneral = "Configura «Generales» en la sección «Mercado y riesgo».",
                    consumerDecay = "Configura «Reducción de tolerancia y adicción» en la sección «Mercado y riesgo».",
                    consumerEffects = "Configura «Efectos y riesgos» en la sección «Mercado y riesgo».",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Parámetro de funcionamiento para Mercado Dinámico / Enfriamiento de acción / segundos.",
                    dynamicMarketActionHistoryLimit = "Parámetro de funcionamiento para Mercado Dinámico / Acción / Límite del historial.",
                    dynamicMarketAmountSaturationWeight = "Parámetro de funcionamiento para Mercado Dinámico / Cantidad / Saturación / Peso.",
                    dynamicMarketBaseIntelAccuracy = "Parámetro de funcionamiento para Mercado Dinámico / Valor base / Precisión de la información.",
                    dynamicMarketDefaultAverageQuality = "Parámetro de funcionamiento para Mercado Dinámico / Valor predeterminado / Promedio / Calidad.",
                    dynamicMarketDefaultResourceElasticity = "Parámetro de funcionamiento para Mercado Dinámico / Valor predeterminado / Recurso / Elasticidad.",
                    dynamicMarketDemandCenter = "Parámetro de funcionamiento para Mercado Dinámico / Demanda / Valor central.",
                    dynamicMarketDemandPriceImpact = "Parámetro de funcionamiento para Mercado Dinámico / Demanda / Precio / Impacto.",
                    dynamicMarketDirectionThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Dirección / Umbral.",
                    dynamicMarketEnabled = "Parámetro de funcionamiento para Mercado Dinámico / Activado.",
                    dynamicMarketEventChance = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Oportunidad.",
                    dynamicMarketEventDurationMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Duración / Minutos.",
                    dynamicMarketEventMinimumDurationMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Mínimo / Duración / Minutos.",
                    dynamicMarketEventStrengthMaximum = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Intensidad / Máximo.",
                    dynamicMarketEventStrengthMinimum = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Intensidad / Mínimo.",
                    dynamicMarketEvents = "Configura «Eventos» en la sección «Redes de drogas».",
                    dynamicMarketExactIntelReputation = "Parámetro de funcionamiento para Mercado Dinámico / Información exacta / Reputación.",
                    dynamicMarketExactIntelTrust = "Parámetro de funcionamiento para Mercado Dinámico / Información exacta / Confianza.",
                    dynamicMarketGlobalZoneLabel = "Parámetro de funcionamiento para Mercado Dinámico / Global / Zona / Etiqueta.",
                    dynamicMarketHistoryLimit = "Parámetro de funcionamiento para Mercado Dinámico / Límite del historial.",
                    dynamicMarketInitialDemand = "Parámetro de funcionamiento para Mercado Dinámico / Valor inicial / Demanda.",
                    dynamicMarketInitialPriceMultiplier = "Parámetro de funcionamiento para Mercado Dinámico / Valor inicial / Multiplicador de Precio.",
                    dynamicMarketIntelDemandError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Demanda / Error.",
                    dynamicMarketIntelMaximumAccuracy = "Parámetro de funcionamiento para Mercado Dinámico / Información / Máximo / Precisión.",
                    dynamicMarketIntelMinimumAccuracy = "Parámetro de funcionamiento para Mercado Dinámico / Información / Mínimo / Precisión.",
                    dynamicMarketIntelPoliceError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Policía / Error.",
                    dynamicMarketIntelPriceError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Error.",
                    dynamicMarketIntelPriceMaximum = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Máximo.",
                    dynamicMarketIntelPriceMinimum = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Mínimo.",
                    dynamicMarketIntelReputationWeight = "Parámetro de funcionamiento para Mercado Dinámico / Información / Reputación / Peso.",
                    dynamicMarketIntelResourcePriceError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Recurso / Precio / Error.",
                    dynamicMarketIntelSaturationError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Saturación / Error.",
                    dynamicMarketIntelSeedBucketSeconds = "Parámetro de funcionamiento para Mercado Dinámico / Ventana de semilla de información / segundos.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Información / Estado / Precisión / Umbral.",
                    dynamicMarketIntelStatusErrorThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Información / Estado / Error / Umbral.",
                    dynamicMarketIntelSupplyError = "Parámetro de funcionamiento para Mercado Dinámico / Información / Suministro / Error.",
                    dynamicMarketIntelTrustWeight = "Parámetro de funcionamiento para Mercado Dinámico / Información / Confianza / Peso.",
                    dynamicMarketManipulationCooldownMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Minutos de enfriamiento.",
                    dynamicMarketManipulationDemandShift = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Demanda / Variación.",
                    dynamicMarketManipulationDurationMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Duración / Minutos.",
                    dynamicMarketManipulationHeat = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Presión policial.",
                    dynamicMarketManipulationMinimumBatchAmount = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Mínimo / Lote / Cantidad.",
                    dynamicMarketManipulationPaymentAccount = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Cuenta de pago.",
                    dynamicMarketManipulationPrice = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Precio.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Zona / Presión policial / Multiplicador.",
                    dynamicMarketMaximumIntelAgeMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Máximo / Antigüedad de la información / Minutos.",
                    dynamicMarketMaximumPriceMultiplier = "Parámetro de funcionamiento para Mercado Dinámico / Máximo / Multiplicador de Precio.",
                    dynamicMarketMinimumIntelAgeMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Antigüedad de la información / Minutos.",
                    dynamicMarketMinimumMetricWindowMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Métrica / Ventana temporal / Minutos.",
                    dynamicMarketMinimumPriceMultiplier = "Parámetro de funcionamiento para Mercado Dinámico / Precio mínimo / Multiplicador.",
                    dynamicMarketMinimumUpdateMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Actualización / Minutos.",
                    dynamicMarketPoliceDemandWeight = "Parámetro de funcionamiento para Mercado Dinámico / Policía / Demanda / Peso.",
                    dynamicMarketPolicePriceImpact = "Parámetro de funcionamiento para Mercado Dinámico / Policía / Precio / Impacto.",
                    dynamicMarketPoorQualityDemandPenalty = "Parámetro de funcionamiento para Mercado Dinámico / Mala calidad / Demanda / Penalización.",
                    dynamicMarketPoorQualityThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Mala calidad / Umbral.",
                    dynamicMarketPremiumQualityDemandBonus = "Parámetro de funcionamiento para Mercado Dinámico / Calidad prémium / Bono de demanda.",
                    dynamicMarketPremiumQualityThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Calidad prémium / Umbral.",
                    dynamicMarketProductionSupplyWeight = "Parámetro de funcionamiento para Mercado Dinámico / Producción / Suministro / Peso.",
                    dynamicMarketProductionWindowMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Producción / Ventana temporal / Minutos.",
                    dynamicMarketQualityCenter = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Valor central.",
                    dynamicMarketQualityConfidenceImpact = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Confianza / Impacto.",
                    dynamicMarketQualityRange = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Rango de valores.",
                    dynamicMarketRarityBonusMaximum = "Parámetro de funcionamiento para Mercado Dinámico / Rareza / Bonificación / Máximo.",
                    dynamicMarketRegionalGlobalWeight = "Parámetro de funcionamiento para Mercado Dinámico / Regional / Global / Peso.",
                    dynamicMarketRegionalLocalWeight = "Parámetro de funcionamiento para Mercado Dinámico / Regional / Local / Peso.",
                    dynamicMarketResourceAliases = "Configura «Recurso / Alias» en la sección «Redes de drogas».",
                    dynamicMarketResourceDirectionFallThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Dirección / Descenso / Umbral.",
                    dynamicMarketResourceDirectionRiseThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Dirección / Aumento / Umbral.",
                    dynamicMarketResources = "Configura «Recursos» en la sección «Redes de drogas».",
                    dynamicMarketSalesWindowMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Ventas / Ventana temporal / Minutos.",
                    dynamicMarketSaturationDemandWeight = "Parámetro de funcionamiento para Mercado Dinámico / Saturación / Demanda / Peso.",
                    dynamicMarketSaturationPriceImpact = "Parámetro de funcionamiento para Mercado Dinámico / Saturación / Precio / Impacto.",
                    dynamicMarketScarcityDemandWeight = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Demanda / Peso.",
                    dynamicMarketScarcityPriceImpact = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Precio / Impacto.",
                    dynamicMarketSeasonEndMonths = "Configura «Estación / Fin / Meses» en la sección «Redes de drogas».",
                    dynamicMarketSeasonMultipliers = "Configura «Estación / Multiplicadores» en la sección «Redes de drogas».",
                    dynamicMarketShortageRumorThreshold = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Rumor / Umbral.",
                    dynamicMarketStatusThresholds = "Configura «Estado / Umbrales» en la sección «Redes de drogas».",
                    dynamicMarketTargetSupply = "Parámetro de funcionamiento para Mercado Dinámico / Objetivo / Suministro.",
                    dynamicMarketTrendChance = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Oportunidad.",
                    dynamicMarketTrendDurationMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Duración / Minutos.",
                    dynamicMarketTrendMaximumStrength = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Máximo / Intensidad.",
                    dynamicMarketTrendMinimumStrength = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Mínimo / Intensidad.",
                    dynamicMarketUpdateMinutes = "Parámetro de funcionamiento para Mercado Dinámico / Actualización / Minutos.",
                    dynamicMarketVolatilityMaximum = "Parámetro de funcionamiento para Mercado Dinámico / Volatilidad / Máximo.",
                    dynamicMarketVolatilityMinimum = "Parámetro de funcionamiento para Mercado Dinámico / Volatilidad / Mínimo.",
                    dynamicMarketWeatherMultipliers = "Configura «Clima / Multiplicadores» en la sección «Redes de drogas».",
                    dynamicMarketWeatherState = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Estado.",
                    heatActionCooldownSeconds = "Parámetro de funcionamiento para Sospecha y riesgo / Enfriamiento de acción / segundos.",
                    heatActivityRiskWeights = "Configura «Actividad / Riesgo / Ponderaciones» en la sección «Redes de drogas».",
                    heatAggressiveHeatMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Modo agresivo / Presión policial / Multiplicador.",
                    heatBurnerBurnThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Exposición / Umbral.",
                    heatBurnerHeatPerWholesale = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Presión policial / Por venta mayorista.",
                    heatBurnerPhoneItem = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Objeto.",
                    heatCamperOperationalHeatMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Multiplicador.",
                    heatCamperOperationalHeatThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Umbral.",
                    heatCamperParkedHeat = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana aparcada / Presión policial.",
                    heatContaminatedHeatMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Contaminación / Presión policial / Multiplicador.",
                    heatContaminatedThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Contaminación / Umbral.",
                    heatCultivationFreePlants = "Parámetro de funcionamiento para Sospecha y riesgo / Cultivo / Plantas sin riesgo adicional.",
                    heatCultivationHeatPerPlant = "Parámetro de funcionamiento para Sospecha y riesgo / Cultivo / Presión policial / Por planta.",
                    heatDealerHiddenMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Distribuidor / oculto / Minutos.",
                    heatDecayPerTick = "Configura «Decaimiento / Por ciclo de actualización» en la sección «Redes de drogas».",
                    heatEnabled = "Parámetro de funcionamiento para Sospecha y riesgo / Activado.",
                    heatEnforcementHeat = "Configura «Presencia policial / Presión policial» en la sección «Redes de drogas».",
                    heatEnforcementMultipliers = "Configura «Presencia policial / Multiplicadores» en la sección «Redes de drogas».",
                    heatEntityTypes = "Configura «Entidad / Tipos» en la sección «Redes de drogas».",
                    heatEventCooldownMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Evento / Minutos de enfriamiento.",
                    heatEventHistoryLimit = "Parámetro de funcionamiento para Sospecha y riesgo / Evento / Límite del historial.",
                    heatLabHeatSyncThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Laboratorio / Presión policial / Sincronización / Umbral.",
                    heatLayLowCooldownMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Minutos de enfriamiento.",
                    heatLayLowIdleMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Inactivo / Minutos.",
                    heatLayLowReduction = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Reducción.",
                    heatLockdownMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Bloqueo / Minutos.",
                    heatMinimumDurationMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Duración / Minutos.",
                    heatMinimumEventCooldownSeconds = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Evento / Enfriamiento (segundos).",
                    heatMinimumIdleSeconds = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Inactivo / segundos.",
                    heatProcessingHeatMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Procesamiento / Presión policial / Multiplicador.",
                    heatRiskWeights = "Configura «Riesgo / Ponderaciones» en la sección «Redes de drogas».",
                    heatRotateBurnerReduction = "Parámetro de funcionamiento para Sospecha y riesgo / Cambiar teléfono desechable / Reducción.",
                    heatRouteControlMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Ruta / Control / Minutos.",
                    heatSaleHeat = "Configura «Venta / Presión policial» en la sección «Redes de drogas».",
                    heatThresholds = "Configura «Umbrales» en la sección «Redes de drogas».",
                    heatTickMinutes = "Parámetro de funcionamiento para Sospecha y riesgo / Ciclo de actualización / Minutos.",
                    heatWholesaleHeatMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Mayorista / Presión policial / Multiplicador.",
                    heatWorkerLeakAlertRadius = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Radio de alerta.",
                    heatWorkerLeakBaseChance = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Valor base / Oportunidad.",
                    heatWorkerLeakFactionMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Facción / Multiplicador.",
                    heatWorkerLeakHighSeverityThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Alto / Gravedad / Umbral.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Lealtad / Oportunidad / Multiplicador.",
                    heatWorkerLeakLoyaltyThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Lealtad / Umbral.",
                    heatWorkerLeakMaximumChance = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Máximo / Oportunidad.",
                    heatWorkerLeakMinimumCooldownSeconds = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Mínimo / Enfriamiento (segundos).",
                    heatWorkerLeakRouteMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Ruta / Multiplicador.",
                    heatWorkerLeakStrengthMaximum = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Máximo.",
                    heatWorkerLeakStrengthMinimum = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Mínimo.",
                    heatWorkerLeakStrengthMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Multiplicador.",
                    heatWorkerLeakStressChanceMultiplier = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Estrés / Oportunidad / Multiplicador.",
                    heatWorkerLeakStressThreshold = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Estrés / Umbral.",
                    contactsActionCooldownSeconds = "Parámetro de funcionamiento para Red de contactos / Enfriamiento de acción / segundos.",
                    contactsActiveHotspotCount = "Parámetro de funcionamiento para Red de contactos / Cantidad de puntos calientes activos.",
                    contactsBurnerHintTrust = "Parámetro de funcionamiento para Red de contactos / Pista de burner / Confianza.",
                    contactsBurnerOfferMaximumMultiplier = "Parámetro de funcionamiento para Red de contactos / Teléfono desechable / Oferta / Máximo / Multiplicador.",
                    contactsBurnerOfferMinimumMultiplier = "Parámetro de funcionamiento para Red de contactos / Teléfono desechable / Oferta / Mínimo / Multiplicador.",
                    contactsBuyerCooldownMinutes = "Parámetro de funcionamiento para Red de contactos / Comprador / Minutos de enfriamiento.",
                    contactsBuyerDeliveryDistance = "Parámetro de funcionamiento para Red de contactos / Comprador / Distancia de entrega.",
                    contactsBuyerPremiumSuccessScore = "Parámetro de funcionamiento para Red de contactos / Comprador / Premium / Éxito / Puntuación.",
                    contactsBuyerPremiumTrustGain = "Parámetro de funcionamiento para Red de contactos / Comprador / Premium / Confianza / ganancia.",
                    contactsBuyerRequestHeatRiskWeight = "Parámetro de funcionamiento para Red de contactos / Comprador / Solicitud / Nivel de búsqueda y riesgo / Peso.",
                    contactsBuyerStandardTrustGain = "Parámetro de funcionamiento para Red de contactos / Comprador / Estándar / Confianza / ganancia.",
                    contactsContactActiveDelaySeconds = "Configura «Espera para activar contacto / segundos» en la sección «Redes de drogas».",
                    contactsContactDemandRange = "Configura «Contacto / Demanda / Rango de valores» en la sección «Redes de drogas».",
                    contactsContactLossTrust = "Parámetro de funcionamiento para Red de contactos / Contacto / Pérdida / Confianza.",
                    contactsDarknetExactIntelMinutes = "Parámetro de funcionamiento para Red de contactos / Red oscura / Información exacta / Minutos.",
                    contactsDarknetHotspotIntelPrice = "Parámetro de funcionamiento para Red de contactos / Red oscura / Zona activa / Información / Precio.",
                    contactsDarknetIntelPrice = "Parámetro de funcionamiento para Red de contactos / Red oscura / Información / Precio.",
                    contactsDealerBasePrice = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Precio base.",
                    contactsDealerHireCapacity = "Configura «Distribuidor / Contratación / capacidad» en la sección «Redes de drogas».",
                    contactsDealerHireRisk = "Configura «Distribuidor / Contratación / Riesgo» en la sección «Redes de drogas».",
                    contactsDealerHireSkill = "Configura «Distribuidor / Contratación / Habilidad» en la sección «Redes de drogas».",
                    contactsDealerOffers = "Configura «Ofertas de distribuidores» en la sección «Redes de drogas».",
                    contactsDealerProtectionHours = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Protección / Horas.",
                    contactsDealerProtectionPrice = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Protección / Precio.",
                    contactsDealerSaleMax = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Venta / Máximo.",
                    contactsDealerSaleMin = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Venta / Mínimo.",
                    contactsDealerSimulation = "Configura «Distribuidor / Simulación» en la sección «Redes de drogas».",
                    contactsDealerTickMinutes = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Ciclo de actualización / Minutos.",
                    contactsDealerWage = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario.",
                    contactsDealerWageDecay = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario / Decaimiento.",
                    contactsDealerWageLoyaltyGain = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario / Lealtad / ganancia.",
                    contactsDealerWeaknesses = "Configura «Distribuidor / Debilidades» en la sección «Redes de drogas».",
                    contactsDefaultContactDemand = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Contacto / Demanda.",
                    contactsDefaultContactRisk = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Contacto / Riesgo.",
                    contactsDefaultDealerCapacity = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / capacidad.",
                    contactsDefaultDealerRisk = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / Riesgo.",
                    contactsDefaultDealerSkill = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / Habilidad.",
                    contactsDefaultHotspotRadius = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Zona activa / Radio.",
                    contactsDemandResetMinutes = "Parámetro de funcionamiento para Red de contactos / Reinicio de demanda (minutos).",
                    contactsEnabled = "Parámetro de funcionamiento para Red de contactos / Activado.",
                    contactsExactLocationTrust = "Parámetro de funcionamiento para Red de contactos / Ubicación exacta / Confianza.",
                    contactsFactionDiscoveryReputation = "Parámetro de funcionamiento para Red de contactos / Facción / Descubrimiento / Reputación.",
                    contactsFactionHintTrust = "Parámetro de funcionamiento para Red de contactos / Facción / Pista / Confianza.",
                    contactsFailedDeliveryCooldownMinutes = "Parámetro de funcionamiento para Red de contactos / Entrega fallida / Minutos de enfriamiento.",
                    contactsFakeDealEncounter = "Configura «Trato falso / Encuentro» en la sección «Redes de drogas».",
                    contactsFallbackPreferredDrug = "Parámetro de funcionamiento para Red de contactos / Valor alternativo / Droga Preferida.",
                    contactsFallbackProductLabel = "Parámetro de funcionamiento para Red de contactos / Valor alternativo / Etiqueta del producto.",
                    contactsGuideBookItem = "Parámetro de funcionamiento para Red de contactos / Guía / Libro / Objeto.",
                    contactsGuideBookTrust = "Parámetro de funcionamiento para Red de contactos / Guía / Libro / Confianza.",
                    contactsHireDealerPrice = "Parámetro de funcionamiento para Red de contactos / Contratar dealer / Precio.",
                    contactsHistoryLimit = "Parámetro de funcionamiento para Red de contactos / Límite del historial.",
                    contactsHotspotIntelMinutes = "Parámetro de funcionamiento para Red de contactos / Zona activa / Información / Minutos.",
                    contactsHotspotRotationMinutes = "Parámetro de funcionamiento para Red de contactos / Zona activa / Rotación / Minutos.",
                    contactsListingDurationMinutes = "Parámetro de funcionamiento para Red de contactos / Anuncio / Duración / Minutos.",
                    contactsMaxOwnedDealers = "Parámetro de funcionamiento para Red de contactos / Máximo / Propiedad / Dealers.",
                    contactsMinimumBuyerDeliveryDistance = "Parámetro de funcionamiento para Red de contactos / Mínimo / Comprador / Distancia de entrega.",
                    contactsMinimumContactRotationMinutes = "Parámetro de funcionamiento para Red de contactos / Mínimo / Rotación de contactos (minutos).",
                    contactsMinimumDemandResetMinutes = "Parámetro de funcionamiento para Red de contactos / Mínimo / Reinicio de demanda (minutos).",
                    contactsMinimumHeatMultiplier = "Parámetro de funcionamiento para Red de contactos / Mínimo / Presión policial / Multiplicador.",
                    contactsMinimumHotspotIntelMinutes = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Información / Minutos.",
                    contactsMinimumHotspotRadius = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Radio.",
                    contactsMinimumHotspotRotationMinutes = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Rotación / Minutos.",
                    contactsMinimumListingDurationMinutes = "Parámetro de funcionamiento para Red de contactos / Mínimo / Anuncio / Duración / Minutos.",
                    contactsMinimumRewardMultiplier = "Parámetro de funcionamiento para Red de contactos / Recompensa mínima / Multiplicador.",
                    contactsMinimumRobberyMultiplier = "Parámetro de funcionamiento para Red de contactos / Mínimo / Robo / Multiplicador.",
                    contactsMinimumSpotPriceMultiplier = "Parámetro de funcionamiento para Red de contactos / Mínimo / Ubicación / Multiplicador de Precio.",
                    contactsOtherDrugPriceMultiplier = "Parámetro de funcionamiento para Red de contactos / Otros / Droga / Multiplicador de Precio.",
                    contactsPaymentAccount = "Parámetro de funcionamiento para Red de contactos / Cuenta de pago.",
                    contactsPostDeliveryDemandResetSeconds = "Parámetro de funcionamiento para Red de contactos / Después de la entrega / Demanda / Reset / segundos.",
                    contactsPreferredDrugPriceMultiplier = "Parámetro de funcionamiento para Red de contactos / Droga Preferida / Multiplicador de Precio.",
                    contactsRegionLocationTrust = "Parámetro de funcionamiento para Red de contactos / Región / Ubicación / Confianza.",
                    contactsRequestAmounts = "Configura «Solicitud / Cantidades» en la sección «Redes de drogas».",
                    contactsRotationMinutes = "Parámetro de funcionamiento para Red de contactos / Rotación / Minutos.",
                    contactsSpotPools = "Configura «Ubicación / Conjuntos de selección» en la sección «Redes de drogas».",
                    contactsStreetHotspots = "Configura «Calle / Zonas activas» en la sección «Redes de drogas».",
                    contactsTrustLevels = "Configura «Confianza / Niveles» en la sección «Redes de drogas».",
                    businessActionCooldownSeconds = "Parámetro de funcionamiento para Red de negocios / Enfriamiento de acción / segundos.",
                    businessBalance = "Configura «Saldo» en la sección «Redes de drogas».",
                    businessContracts = "Configura «Contratos» en la sección «Redes de drogas».",
                    businessDefaultBusinessName = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Nombre del negocio.",
                    businessDefaultRankId = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Rango / ID.",
                    businessDefaultStaffStyle = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Personal / Estilo de trabajo.",
                    businessDefaultTransport = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Transporte.",
                    businessEnabled = "Parámetro de funcionamiento para Red de negocios / Activado.",
                    businessHubs = "Configura «Centros de distribución» en la sección «Redes de drogas».",
                    businessLimits = "Configura «Límites» en la sección «Redes de drogas».",
                    businessPayments = "Elige qué saldo paga las compras y los costes operativos de la Red de Negocios.",
                    businessPayoutAccount = "Parámetro de funcionamiento para Red de negocios / Pago / Cuenta.",
                    businessRanks = "Configura «Rangos» en la sección «Redes de drogas».",
                    businessReportDays = "Parámetro de funcionamiento para Red de negocios / Período del informe / días.",
                    businessRouteEndpointTypes = "Configura «Ruta / Punto final / Tipos» en la sección «Redes de drogas».",
                    businessRuntime = "Configura «Funcionamiento en juego» en la sección «Redes de drogas».",
                    businessSocietyPermission = "Parámetro de funcionamiento para Red de negocios / Organización / Permiso.",
                    businessStaff = "Configura «Personal» en la sección «Redes de drogas».",
                    businessTickMinutes = "Parámetro de funcionamiento para Red de negocios / Ciclo de actualización / Minutos.",
                    businessTransports = "Configura «Transportes» en la sección «Redes de drogas».",
                },
                robbery = {
                    atmAvailability = "Activa o desactiva el sistema independiente de robo de cajeros automáticos.",
                    atmLocations = "Gestiona las posiciones de cajeros automáticos autorizadas por el servidor disponibles para robos.",
                    atmPolice = "Configura el requisito de policías en servicio para iniciar un robo.",
                    atmItems = "Configura los objetos de taladro, eslinga y carga explosiva necesarios.",
                    atmActionTimes = "Establece la duración de las acciones de colocar, plantar, detonar y saquear.",
                    atmTimeouts = "Controla cuánto tiempo permanece disponible para saquear un cajero automático forzado.",
                    atmPayout = "Configura la cuenta objetivo y el rango de recompensa aleatoria.",
                    atmDistances = "Establece los rangos de jugador y vehículo utilizados en las interacciones de cajeros automáticos.",
                    atmExplosionEffects = "Configura los parámetros nativos de explosión utilizados durante la detonación.",
                    atmDispatchAlert = "Configura el radio, la duración y la prioridad para la alerta policial.",
                    atmDispatchRecipients = "Elige qué nombres de trabajos reciben las alertas de robo de cajeros automáticos.",
                    shopAvailability = "Activa los robos y configura el requisito policial.",
                    shopTiming = "Configura la intimidación, las acciones, el tiempo límite y el tiempo de espera.",
                    shopSafe = "Configura los intentos del teclado y el objeto de taladro.",
                    shopRegisterReward = "Configura la recompensa aleatoria para cada caja registradora.",
                    shopSafeReward = "Configura la recompensa aleatoria de la caja fuerte.",
                    shopDispatchSettings = "Configura los destinatarios y las propiedades de la alerta.",
                    shopLocationTable = "Gestiona tiendas con personal y cajas fuertes.",
                    pickpocketAvailability = "Activa la función y, opcionalmente, limítala a los trabajos criminales configurados.",
                    pickpocketGameplay = "Elige el desafío y las probabilidades independientes de huida, llamada de emergencia y contraataque.",
                    pickpocketItemRewards = "Controla los bolsillos vacíos y las opciones de objetos visibles hasta un 0.0001 por ciento.",
                    pickpocketMoney = "Configura el rango de efectivo aleatorio generado por el servidor.",
                    pickpocketDistances = "Establece el rango de NPC utilizado por el sistema radial y de objetivo compartido.",
                    pickpocketRateLimits = "Controla la limitación de solicitudes, el tiempo de espera por NPC y la expiración de la sesión.",
                    pickpocketDispatchSettings = "Configura la alerta enviada cuando un NPC llama a los servicios de emergencia.",
                    heistCrafting = "Elige cuánta interacción se requiere al fabricar equipo para el heist. Se aplica a nuevos intentos en todo el Sistema Criminal.",
                    heistCreatorMenu = "Crea, edita y publica atracos modulares en el Creador de Atracos dedicado.",
                    heistExecution = "Ventana de inicio, inactividad y tiempo de espera para los intentos de robo.",
                    npcPoliceSupport = "Oficiales NPC armados responden a pie ante alarmas de robo y apoyan a la policía enfrentando a los ladrones.",
                },
                baseRaids = {
                    baseRaids = "Acceso a incursiones, requisitos y categorías de botín seleccionables individualmente. Las incursiones abiertas no tienen límite de tiempo de transporte.",
                },
                weapons = {
                    weaponCreatorMenu = "Gestiona rutas de armas y blanqueo de dinero en un creador.",
                    weaponRuntime = "Controla la disponibilidad y el acceso a las rutas de armas.",
                    weaponDefaultsgeneral = "Configura «Valores generales» en la sección «Rutas de armas».",
                    weaponDefaultsaccess = "Configura «Valores de acceso» en la sección «Rutas de armas».",
                    weaponDefaultscollection = "Configura «Valores de recolección» en la sección «Rutas de armas».",
                    weaponDefaultsproduction = "Configura «Valores de producción» en la sección «Rutas de armas».",
                    weaponDefaultsmarket = "Configura «Valores de mercado» en la sección «Rutas de armas».",
                    weaponDefaultsdelivery = "Configura «Valores de pedidos» en la sección «Rutas de armas».",
                    weaponStreet = "Configura «Venta callejera de armas» en la sección «Rutas de armas».",
                },
                darknetMarket = {
                    darknetAvailability = "Controla la aplicación de la tablet y su ubicación.",
                    darknetEconomy = "Configura los saldos de la billetera, el intercambio de monedas y las tasas de pago.",
                    darknetListings = "Controla los límites de ofertas, precios y el vencimiento automático.",
                    darknetChat = "Limita los mensajes encriptados del mercado.",
                    darknetIdentity = "Configura la rotación de identidad, la verificación y las advertencias de estafa.",
                    darknetDelivery = "Configura encuentros físicos y cajas robables en el mundo.",
                    darknetDeliveryLocations = "Configura los grupos de ubicaciones asignados aleatoriamente a los intercambios de BlackBay NPC.",
                    darknetPolice = "Grupos de trabajo autorizados para publicar trampas y ver investigaciones.",
                    darknetNpcTraders = "Compradores y vendedores NPC persistentes con riesgo configurable.",
                },
                interrogation = {
                    general = "Configura «Generales» en la sección «Interrogatorio».",
                    consent = "Configura «Protección de jugadores» en la sección «Interrogatorio».",
                    objects = "Configura «Objetos» en la sección «Interrogatorio».",
                    grab = "Configura «Sujeción» en la sección «Interrogatorio».",
                    session = "Configura «Sesión» en la sección «Interrogatorio».",
                    dispatch = "Configura «Alertas policiales» en la sección «Interrogatorio».",
                    logging = "Configura «Registro de actividad» en la sección «Interrogatorio».",
                    security = "Configura «Seguridad» en la sección «Interrogatorio».",
                    presentation = "Configura «Presentación» en la sección «Interrogatorio».",
                },
                reputation = {
                    crimeReputation = "Configura «Reputación» en la sección «Reputación».",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Generales", description = "Controla la disponibilidad y el acceso a las rutas de armas." },
                weaponCreatorMenu = { label = "Creador de negocios ilegales", description = "Gestiona rutas de armas y blanqueo de dinero en un creador." },
                atmActionTimes = {
                    description = "Establece la duración de las acciones de colocar, plantar, detonar y saquear.",
                    label = "Duraciones de acción",
                },
                atmAvailability = {
                    description = "Activa o desactiva el sistema independiente de robo de cajeros automáticos.",
                    label = "Disponibilidad",
                },
                atmDispatchAlert = {
                    description = "Configura el radio, la duración y la prioridad para la alerta policial.",
                    label = "Propiedades de la alerta",
                },
                atmDispatchRecipients = {
                    description = "Elige qué nombres de trabajos reciben las alertas de robo de cajeros automáticos.",
                    label = "Destinatarios",
                },
                atmDistances = {
                    description = "Establece los rangos de jugador y vehículo utilizados en las interacciones de cajeros automáticos.",
                    label = "Distancias de interacción",
                },
                atmExplosionEffects = {
                    description = "Configura los parámetros nativos de explosión utilizados durante la detonación.",
                    label = "Efectos de explosión",
                },
                atmItems = {
                    description = "Configura los objetos de taladro, eslinga y carga explosiva necesarios.",
                    label = "Objetos requeridos",
                },
                atmLocations = {
                    description = "Gestiona las posiciones de cajeros automáticos autorizadas por el servidor disponibles para robos.",
                    label = "Ubicaciones de cajeros automáticos",
                },
                atmPayout = {
                    description = "Configura la cuenta objetivo y el rango de recompensa aleatoria.",
                    label = "Pago",
                },
                atmPolice = {
                    description = "Configura el requisito de policías en servicio para iniciar un robo.",
                    label = "Requisito policial",
                },
                atmPulling = {
                    description = "Configura el movimiento necesario para arrancar un cajero automático de la pared.",
                    label = "Detección de extracción",
                },
                atmTimeouts = {
                    description = "Controla cuánto tiempo permanece disponible para saquear un cajero automático forzado.",
                    label = "Tiempo límite de botín",
                },
                baseRaids = {
                    description = "Acceso a incursiones, requisitos y categorías de botín seleccionables individualmente. Las incursiones abiertas no tienen límite de tiempo de transporte.",
                    label = "Incursiones a bases",
                },
                businessPayments = {
                    description = "Elige qué saldo paga las compras y los costes operativos de la Red de Negocios.",
                    label = "Pagos",
                },
                crimeMembership = {
                    description = "Elige cómo las organizaciones criminales almacenan y gestionan a sus miembros.",
                    label = "Modelo de membresía",
                },
                darknetAvailability = {
                    description = "Controla la aplicación de la tablet y su ubicación.",
                    label = "Disponibilidad",
                },
                darknetChat = {
                    description = "Limita los mensajes encriptados del mercado.",
                    label = "Chat privado",
                },
                darknetDelivery = {
                    description = "Configura encuentros físicos y cajas robables en el mundo.",
                    label = "Entregas y dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Configura los grupos de ubicaciones asignados aleatoriamente a los intercambios de BlackBay NPC.",
                    label = "Ubicaciones de entrega",
                },
                darknetEconomy = {
                    description = "Configura los saldos de la billetera, el intercambio de monedas y las tasas de pago.",
                    label = "Criptomoneda",
                },
                darknetIdentity = {
                    description = "Configura la rotación de identidad, la verificación y las advertencias de estafa.",
                    label = "Alias y reputación",
                },
                darknetListings = {
                    description = "Controla los límites de ofertas, precios y el vencimiento automático.",
                    label = "Ofertas y caducidad",
                },
                darknetNpcTraders = {
                    description = "Compradores y vendedores NPC persistentes con riesgo configurable.",
                    label = "Comerciantes NPC",
                },
                darknetPolice = {
                    description = "Grupos de trabajo autorizados para publicar trampas y ver investigaciones.",
                    label = "Acceso policial",
                },
                heistCrafting = {
                    description = "Elige cuánta interacción se requiere al fabricar equipo para el heist. Se aplica a nuevos intentos en todo el Sistema Criminal.",
                    label = "Taller de atraco",
                },
                heistCreatorMenu = {
                    description = "Crea, edita y publica atracos modulares en el Creador de Atracos dedicado.",
                    label = "Menú de creador",
                },
                heistExecution = {
                    description = "Ventana de inicio, inactividad y tiempo de espera para los intentos de robo.",
                    label = "Tiempos del robo",
                },
                moneywashEconomy = {
                    description = "Habilita negocios y configura la cuenta de depósito, la tarifa de servicio y las distancias de interacción.",
                    label = "Generales",
                },
                npcPoliceSupport = {
                    description = "Oficiales NPC armados responden a pie ante alarmas de robo y apoyan a la policía enfrentando a los ladrones.",
                    label = "Apoyo policial NPC",
                },
                pickpocketAvailability = {
                    description = "Activa la función y, opcionalmente, limítala a los trabajos criminales configurados.",
                    label = "Disponibilidad",
                },
                pickpocketDispatchSettings = {
                    description = "Configura la alerta enviada cuando un NPC llama a los servicios de emergencia.",
                    label = "Despacho de emergencia",
                },
                pickpocketDistances = {
                    description = "Establece el rango de NPC utilizado por el sistema radial y de objetivo compartido.",
                    label = "Distancias de interacción",
                },
                pickpocketGameplay = {
                    description = "Elige el desafío y las probabilidades independientes de huida, llamada de emergencia y contraataque.",
                    label = "Riesgo y minijuego",
                },
                pickpocketItemRewards = {
                    description = "Controla los bolsillos vacíos y las opciones de objetos visibles hasta un 0.0001 por ciento.",
                    label = "Botín de bolsillo visible",
                },
                pickpocketMoney = {
                    description = "Configura el rango de efectivo aleatorio generado por el servidor.",
                    label = "Recompensa en efectivo",
                },
                pickpocketRateLimits = {
                    description = "Controla la limitación de solicitudes, el tiempo de espera por NPC y la expiración de la sesión.",
                    label = "Salvaguardas del servidor",
                },
                pvpArenas = {
                    description = "Crea la zona circular, el punto de observación y los puntos de aparición de equipos utilizados en eventos PvP.",
                    label = "Arenas y zonas de combate",
                },
                pvpAutomation = {
                    description = "Configura los eventos recurrentes y el procesamiento de inicio automático.",
                    label = "Automatización",
                },
                pvpAvailability = {
                    description = "Controla si la aplicación de eventos PvP está disponible y dónde aparece.",
                    label = "Disponibilidad",
                },
                pvpLimits = {
                    description = "Establece los límites de recompensas e historial de la tablet.",
                    label = "Límites e historial",
                },
                pvpModes = {
                    description = "Configura el modo de juego preseleccionado en la tablet PvP.",
                    label = "Modos de juego",
                },
                pvpPermissions = {
                    description = "Asigna la gestión de eventos y las finanzas a los permisos de ACE y de trabajo.",
                    label = "Permisos",
                },
                pvpRuntime = {
                    description = "Ajusta el manejo de solicitudes, las muertes y los reaparecimientos durante las partidas en vivo.",
                    label = "Duración del evento",
                },
                pvpTakeoverMethods = {
                    description = "Configura cuánto tarda cada método en forzar una entrada.",
                    label = "Métodos de intrusión",
                },
                pvpTakeoverRules = {
                    description = "Controla la disponibilidad y los requisitos de participación para las tomas de laboratorios y campistas.",
                    label = "Reglas de toma de control",
                },
                pvpTakeoverZones = {
                    description = "Configura las áreas de interacción, alerta y captura junto con sus duraciones.",
                    label = "Zonas y tiempos",
                },
                shopAvailability = {
                    description = "Activa los robos y configura el requisito policial.",
                    label = "Disponibilidad",
                },
                shopDispatchSettings = {
                    description = "Configura los destinatarios y las propiedades de la alerta.",
                    label = "Alerta policial",
                },
                shopLocationTable = {
                    description = "Gestiona tiendas con personal y cajas fuertes.",
                    label = "Ubicaciones de tiendas",
                },
                shopRegisterReward = {
                    description = "Configura la recompensa aleatoria para cada caja registradora.",
                    label = "Recompensa de la caja",
                },
                shopRegisterTable = {
                    description = "Asigna cajas registradoras individuales a las tiendas.",
                    label = "Cajas registradoras",
                },
                shopSafe = {
                    description = "Configura los intentos del teclado y el objeto de taladro.",
                    label = "Caja fuerte",
                },
                shopSafeReward = {
                    description = "Configura la recompensa aleatoria de la caja fuerte.",
                    label = "Recompensa de la caja fuerte",
                },
                shopTiming = {
                    description = "Configura la intimidación, las acciones, el tiempo límite y el tiempo de espera.",
                    label = "Tiempos",
                },
            },
            settingSections = {
                weapons = "Rutas de armas",
                drugs = "Sistema de drogas",
                drugProduction = "Producción de drogas",
                drugOperations = "Operaciones de drogas",
                drugMarketRisk = "Mercado y riesgo",
                drugNetworks = "Redes de drogas",
                atmRobbery = "Robo de cajero automático",
                baseRaids = "Incursiones a bases",
                crimeOrganizations = "Organizaciones",
                darknetMarket = "Mercado Darknet",
                moneywash = "Lavado de dinero",
                pvpEvents = "PvP de facción",
                robbery = "Robo",
                territories = "Territorios",
                graffiti = "Grafiti",
                interrogation = "Interrogatorio",
            },
            settingSubsections = {
                baseRaidEquipment = "Equipo necesario",
                baseRaidBreach = "Forzado de acceso",
                baseRaidLoot = "Botín y vehículos",
                graffitiLimits = "Límites y moderación",
                interrogationTechnical = "Registros y seguridad",
                atmDispatch = "Despacho policial",
                atmEquipment = "Equipo",
                atmExplosion = "Explosión",
                atmOverview = "Resumen y ubicaciones",
                atmRewards = "Recompensas",
                atmTiming = "Tiempos",
                atmVehicle = "Vehículo y arrastre",
                baseRaids = "Incursiones a bases",
                crimeMembership = "Membresía",
                heistCreator = "Creador de atracos",
                npcPoliceSupport = "Apoyo policial NPC",
                pickpocket = "Robo de carteras a NPCs",
                pvpArenas = "Arenas",
                pvpEquipment = "Modos de juego",
                pvpOverview = "Resumen",
                pvpRuntime = "Duración del evento",
                pvpTakeovers = "Toma de laboratorios",
                shopRobbery = "Robos a tiendas",
                atmRobbery = "Robo de cajero automático",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Distancia de interacción" },
                weaponDefaultGeneralPedModel = { label = "Modelo de NPC predeterminado" },
                weaponDefaultAccessActiveHourStart = { label = "Hora de apertura (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Hora de cierre (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Policías de servicio requeridos" },
                weaponDefaultAccessPoliceJobs = { label = "Trabajos policiales" },
                weaponDefaultCollectionDurationSeconds = { label = "Duración en segundos" },
                weaponDefaultCollectionCooldownSeconds = { label = "Espera en segundos" },
                weaponDefaultCollectionCooldownScope = { label = "Ámbito de espera" },
                weaponDefaultCollectionUseMinigame = { label = "Usar minijuego" },
                weaponDefaultCollectionMinigame = { label = "Minijuego" },
                weaponDefaultCollectionMinigameRounds = { label = "Rondas del minijuego" },
                weaponDefaultProductionDurationSeconds = { label = "Duración en segundos" },
                weaponDefaultProductionSuccessChance = { label = "Probabilidad de éxito (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Consumir materiales al fallar" },
                weaponDefaultProductionUseMinigame = { label = "Usar minijuego" },
                weaponDefaultProductionMinigame = { label = "Minijuego" },
                weaponDefaultProductionMinigameRounds = { label = "Rondas del minijuego" },
                weaponDefaultProductionQualityMin = { label = "Calidad mínima" },
                weaponDefaultProductionQualityMax = { label = "Calidad máxima" },
                weaponDefaultProductionCooldownSeconds = { label = "Espera en segundos" },
                weaponDefaultProductionCooldownScope = { label = "Ámbito de espera" },
                weaponDefaultMarketPayoutAccount = { label = "Cuenta de pago" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Factor de precio mínimo (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Factor de precio máximo (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Intervalo de reposición en segundos" },
                weaponDefaultMarketCooldownSeconds = { label = "Espera en segundos" },
                weaponDefaultMarketCooldownScope = { label = "Ámbito de espera" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Plazo del pedido en minutos" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Bonificación del pedido (%)" },
                weaponStreetEnabled = { label = "Ventas ocasionales de armas a compradores callejeros" },
                weaponStreetChance = { label = "Probabilidad de oferta de arma (%)" },
                weaponStreetCooldown = { label = "Espera en segundos" },
                weaponStreetAmount = { label = "Cantidad máxima" },
                weaponStreetPriceMin = { label = "Factor de precio mínimo (%)" },
                weaponStreetPriceMax = { label = "Factor de precio máximo (%)" },
                weaponStreetAccount = { label = "Cuenta de pago" },
                weaponStreetDirect = { label = "Venta directa" },
                weaponStreetBulk = { label = "Venta por lotes" },
                weaponStreetContract = { label = "Pedido del cartel" },
                weaponSystemEnabled = { label = "Sistema de rutas de armas", description = "Activa la recogida y el procesamiento de armas y su venta a cárteles." },
                weaponRuntimeEnabled = { label = "Acciones de rutas de armas", description = "Permite usar las rutas de armas configuradas en el mundo del juego." },
                weaponCreatorAccess = { label = "Acceso al creador de armas", description = "Elige quién puede abrir el creador de armas.", options = { permission = "Solo con permiso", jobManagement = "Gestión del empleo", ownerOnly = "Solo propietario" } },
                openWeaponCreator = { label = "Creador de negocios ilegales", description = "Gestiona rutas de armas y blanqueo de dinero en un creador.", buttonLabel = "Creador de negocios ilegales", unsavedTooltip = "Guardar primero" },

                drugCultivationProgressionEnabled = { label = "Activar niveles de cultivo", description = "Activa la XP de cultivo, los niveles y los desbloqueos según el nivel." },
                drugCultivationMaxLevel = { label = "Nivel máximo de cultivo", description = "Nivel de cultivo más alto alcanzable. Los niveles superiores no se podrán alcanzar." },
                drugCultivationLevels = { label = "Curva de niveles", description = "Configura el nombre y la XP total requerida para cada nivel de cultivo." },
                drugCultivationActionXp = { label = "Recompensas de XP", description = "Configura cuánta XP de cultivo otorga cada acción." },
                drugCultivationUnlocks = { label = "Desbloqueos por nivel", description = "Configura el nivel requerido para contenedores, sustratos, equipo, variedades y niveles del escáner." },
                reputationRewards = { label = "Acciones de reputación", description = "Añade acciones, cambia los puntos y desactiva o elimina entradas. Solo las entradas activas otorgan puntos." },
                reputationEnabled = { label = "Activar reputación criminal", description = "Otorgar reputación personal." },
                reputationPointsPerLevel = { label = "Puntos por nivel", description = "Cada nivel requiere esta cantidad de puntos adicionales." },
                reputationMinimumJoinPoints = { label = "Reputación mínima para ingresar", description = "Puntos totales necesarios para unirse a una facción criminal. 0 desactiva el requisito. Los miembros actuales mantienen su acceso." },
                reputation_atm = { label = "Robo de cajero automático", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_shop_register = { label = "Caja de tienda", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_shop_safe = { label = "Caja fuerte de tienda", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_pickpocket = { label = "Hurto", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_heist = { label = "Atraco completado", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_harvest = { label = "Cosecha de drogas", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_processing = { label = "Procesamiento de drogas", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_sale = { label = "Venta de drogas", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_delivery = { label = "Entrega de drogas", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_contract = { label = "Contrato de distribución", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_drug_raid = { label = "Asalto de drogas", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_graffiti = { label = "Grafiti", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_moneywash = { label = "Blanqueo de dinero", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_base_raid = { label = "Asalto a base", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                reputation_pvp_win = { label = "Victoria JcJ", description = "Puntos por acción completada con éxito. 0 desactiva esta recompensa." },
                atmChargeProp = {
                    description = "Modelo de objeto que se muestra en el cajero automático mientras se coloca la carga explosiva.",
                    label = "Objeto de carga",
                },
                atmConsumeDrill = {
                    description = "Consume la cantidad configurada tras completar con éxito cada punto de perforación del cajero.",
                    label = "Consumir taladro",
                },
                atmDrillItem = {
                    description = "ID del objeto del inventario necesario para perforar un cajero arrancado. Se configura por separado del taladro de cajas fuertes de tiendas.",
                    label = "Objeto de taladro",
                },
                atmDrillItemAmount = {
                    description = "Número de objetos de taladro necesarios para cada punto de perforación del cajero.",
                    label = "Cantidad de taladros requerida",
                },
                atmDebug = {
                    description = "Escribe diagnósticos detallados del robo al ATM en la consola del servidor y en la consola F8 del cliente.",
                    label = "Logs de depuración de ATM",
                },
                atmDispatchDurationSeconds = {
                    description = "Segundos que la alerta del cajero automático sigue siendo relevante para los receptores de despacho.",
                    label = "Duración del despacho",
                },
                atmDispatchEnabled = {
                    description = "Crea un incidente de Base de Trabajos cuando se asalta un ATM.",
                    label = "Activar despacho policial",
                },
                atmDispatchJobs = {
                    description = "Nombres de trabajos separados por comas que reciben la alerta del cajero automático.",
                    label = "Trabajos de despacho",
                },
                atmDispatchPriority = {
                    description = "Valor de prioridad pasado sin cambios a la integración de despacho.",
                    label = "Prioridad de despacho",
                },
                atmDispatchRadius = {
                    description = "Radio de alerta aproximado enviado a la integración de despacho.",
                    label = "Radio de despacho",
                },
                atmEnabled = {
                    description = "Hace que los cajeros automáticos configurados estén disponibles para robos con lazo o con explosivos.",
                    label = "Activar robos a cajeros automáticos",
                },
                atmExplosionCameraShake = {
                    description = "Intensidad de la sacudida de cámara para el cliente que genera la explosión.",
                    label = "Sacudida de cámara por explosión",
                },
                atmExplosionDamageScale = {
                    description = "Intensidad de daño e impulso pasada a la función nativa de explosión.",
                    label = "Escala de daño por explosión",
                },
                atmExplosionType = {
                    description = "Tipo de explosión de GTA utilizado en la detonación. Mantén el predeterminado a menos que se haya probado otro tipo.",
                    label = "Tipo de explosión",
                },
                atmDrillDurationSeconds = {
                    label = "Tiempo mínimo de perforación por tornillo (s)",
                    description = "Tiempo mínimo en segundos para cada uno de los cuatro tornillos. Las pausas de enfriamiento prolongan el intento. Se aplica a los intentos de perforación que comiencen después de guardar.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Segundos necesarios para colocar la carga explosiva.",
                    label = "Duración de la colocación de la carga",
                },
                atmExplosiveItem = {
                    description = "Objeto de inventario que se consume tras colocar la carga.",
                    label = "Objeto explosivo",
                },
                atmExplosiveItemAmount = {
                    description = "Número de objetos explosivos consumidos para una carga colocada.",
                    label = "Cantidad de explosivos consumidos",
                },
                atmFuseSeconds = {
                    description = "Segundos entre la colocación y la detonación.",
                    label = "Duración de la mecha",
                },
                atmInteractionDistance = {
                    description = "Rango máximo de interacción del cliente; la validación del servidor añade un margen de seguridad.",
                    label = "Distancia de interacción",
                },
                atmLocations = {
                    description = "Ubicaciones de producción oficiales. Las ubicaciones creadas con /atmtest son temporales.",
                    itemLabel = "Ubicación del cajero automático",
                    label = "Ubicaciones de cajeros automáticos",
                },
                atmLootDurationSeconds = {
                    description = "Segundos requeridos para forzar un cajero automático abierto.",
                    label = "Duración del botín",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Segundos máximos que un jugador puede reservar un cajero mientras lo abre; se mantiene automáticamente por encima de la duración del saqueo.",
                    label = "Tiempo de espera de reserva de botín",
                },
                atmLootWindowMinutes = {
                    description = "Minutos que un cajero automático forzado permanece saqueable antes de agotarse.",
                    label = "Ventana de botín",
                },
                atmMinimumPolice = {
                    description = "Miembros en servicio del grupo policial configurado requeridos para iniciar un atraco.",
                    label = "Mínimo de policía",
                },
                atmPoliceGroup = {
                    description = "Grupo de trabajo sky_jobs_base contado para el requisito policial.",
                    label = "Grupo de trabajo policial",
                },
                atmPullDistance = {
                    description = "Desplazamiento del vehículo desde la posición del cajero necesario para completar el forcejeo.",
                    label = "Distancia de tracción requerida",
                },
                atmPullMinimumSpeed = {
                    description = "Velocidad mínima del vehículo en metros por segundo cuando se alcanza la distancia de tracción.",
                    label = "Velocidad mínima de extracción",
                },
                atmReservationTimeoutSeconds = {
                    description = "Segundos máximos reservados mientras un jugador coloca una eslinga o una carga; se mantiene automáticamente por encima de la duración de la acción.",
                    label = "Tiempo de espera de reserva de preparación",
                },
                atmRewardAccount = {
                    description = "Elige entre efectivo y el objeto black_money.",
                    label = "Tipo de pago del cajero",
                },
                atmRewardMaximum = {
                    description = "Pago máximo en efectivo de un solo cajero; nunca inferior al mínimo.",
                    label = "Recompensa máxima",
                },
                atmRewardMinimum = {
                    description = "Pago mínimo en efectivo de un cajero automático.",
                    label = "Recompensa mínima",
                },
                atmSlingDurationSeconds = {
                    description = "Segundos requeridos para colocar el lazo.",
                    label = "Duración de colocar el lazo",
                },
                atmSlingItem = {
                    description = "Objeto de inventario reutilizable requerido para el método del vehículo.",
                    label = "Objeto de enganche",
                },
                atmSlingItemAmount = {
                    description = "Número de objetos lazo que deben estar presentes. No se consumen.",
                    label = "Cantidad de lazo requerida",
                },
                atmTestScanDistance = {
                    description = "Distancia máxima utilizada por /atmtest al buscar un objeto de ATM compatible.",
                    label = "Distancia de escaneo de prueba de ATM",
                },
                atmVehicleMaxDistance = {
                    description = "Distancia máxima entre el cajero automático y un vehículo apto al enganchar la eslinga.",
                    label = "Distancia de enganche del vehículo",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Límite de tiempo de cada intento de forzar un almacén (segundos).",
                    label = "Tiempo límite de brecha (segundos)",
                },
                baseRaid_command = {
                    description = "Nombre del comando sin barra diagonal. Reinicia el recurso de crimen después de cambiarlo.",
                    label = "Comando de incursión",
                },
                baseRaid_crimeItem = {
                    description = "Objeto de brecha de banda.",
                    label = "Objeto de brecha de banda",
                },
                baseRaid_crimeVehicles = {
                    description = "Acceso a vehículos de la banda.",
                    label = "Acceso a vehículos de la banda",
                },
                baseRaid_difficulty = {
                    description = "Dificultad del skillcheck.",
                    label = "Dificultad del skillcheck",
                    options = {
                        easy = "Fácil",
                        expert = "Experto",
                        hard = "Difícil",
                        normal = "Normal",
                    },
                },
                baseRaid_enabled = {
                    description = "Activar incursiones a bases.",
                    label = "Activar incursiones a bases",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Tiempo de espera al terminar una redada sin abrir ningún almacén (minutos).",
                    label = "Enfriamiento tras fallo (minutos)",
                },
                baseRaid_interactionDistance = {
                    description = "Distancia de interacción con el almacenamiento.",
                    label = "Distancia de interacción con el almacenamiento",
                },
                baseRaid_lootHeistStorage = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Almacén de botín de atraco",
                },
                baseRaid_lootLaboratories = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Saquear almacén del laboratorio",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Saquear taquillas personales",
                },
                baseRaid_lootStorage = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Saquear almacén",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Saquear guanteras",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Permite el retiro completo de esta categoría de inventario durante un atraco activo.",
                    label = "Saquear maleteros",
                },
                baseRaid_minimumDefenders = {
                    description = "Mínimo de defensores en línea.",
                    label = "Mínimo de defensores en línea",
                },
                baseRaid_policeItem = {
                    description = "Objeto de asalto policial.",
                    label = "Objeto de asalto policial",
                },
                baseRaid_policeRequireDuty = {
                    description = "La policía debe estar de servicio.",
                    label = "La policía debe estar de servicio",
                },
                baseRaid_policeVehicles = {
                    description = "Acceso a vehículos policiales.",
                    label = "Acceso a vehículos de la policía",
                },
                baseRaid_protectionHours = {
                    description = "Protección tras el éxito (horas).",
                    label = "Protección tras el éxito (horas)",
                },
                baseRaid_requiredHits = {
                    description = "Acertos de skillcheck requeridos.",
                    label = "Acertos de skillcheck requeridos",
                },
                baseRaid_warrantItem = {
                    description = "Se consume uno de estos objetos por cada inicio de incursión policial válida.",
                    label = "Objeto de orden de registro",
                },
                crimeMembershipMode = {
                    description = "El modo Framework mantiene la integración de trabajo o banda nativa existente. El modo Independiente ejecuta la organización criminal en segundo plano junto al trabajo normal del jugador y migra las membresías existentes automáticamente.",
                    label = "Modelo de membresía de la organización",
                    options = {
                        framework = "Trabajo de framework / banda",
                        independent = "Organización independiente",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Antigüedad mínima de una identidad antes de que pueda ser retirada de nuevo.",
                    label = "Tiempo de espera para cambio de alias (horas)",
                },
                darknetCurrencyCode = {
                    description = "Etiqueta corta mostrada para el libro contable interno de criptomonedas.",
                    label = "Código de moneda",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Distancia requerida para buscar y reclamar una caja.",
                    label = "Distancia de interacción de dead drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Tiempo antes de que una caja no reclamada expire.",
                    label = "Duración del dead drop (horas)",
                },
                darknetDeadDropModel = {
                    description = "Modelo de objeto de GTA generado localmente para los dead drops disponibles.",
                    label = "Modelo de caja de entrega muerta",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervalo utilizado para actualizar las cajas cercanas y las reuniones NPC.",
                    label = "Intervalo de actualización del mundo (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distancia a la que se cargan las cajas y los contactos de reuniones NPC.",
                    label = "Distancia de streaming de dead drop",
                },
                darknetDropLocations = {
                    description = "Ubicaciones asignadas aleatoriamente para los intercambios de entrega muerta con NPCs. Configura al menos dos.",
                    itemLabel = "Ubicación de entrega muerta",
                    label = "Ubicaciones de entrega muerta",
                },
                darknetEnabled = {
                    description = "Habilita la aplicación de la tablet del mercado negro y su lógica de ejecución.",
                    label = "Activar Mercado Darknet",
                },
                darknetExchangeBuyPrice = {
                    description = "Monto cobrado de la cuenta de pago por cada moneda.",
                    label = "Precio de compra por moneda",
                },
                darknetExchangeEnabled = {
                    description = "Permite a los usuarios autenticados de BlackBay comprar y vender monedas en su página de cuenta.",
                    label = "Activar intercambio de monedas",
                },
                darknetExchangeMaximumAmount = {
                    description = "Cantidad máxima de monedas enteras aceptada en un intercambio.",
                    label = "Máximo de monedas por intercambio",
                },
                darknetExchangeMinimumAmount = {
                    description = "Cantidad mínima de monedas enteras aceptada en un intercambio.",
                    label = "Mínimo de monedas por intercambio",
                },
                darknetExchangePaymentAccount = {
                    description = "Cuenta del framework utilizada para compras de monedas y pagos de ventas.",
                    label = "Cuenta de pago de intercambio",
                    options = {
                        bank = "Banco",
                        black_money = "Dinero sucio",
                        money = "Efectivo",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Monto pagado a la cuenta de pago por cada moneda.",
                    label = "Precio de venta por moneda",
                },
                darknetFaceToFaceDistance = {
                    description = "Distancia máxima entre ambos jugadores o con el punto NPC configurado.",
                    label = "Distancia de entrega",
                },
                darknetKnownScammerReports = {
                    description = "Reportes de transacciones únicos requeridos para la insignia de estafador conocido.",
                    label = "Reportes para advertencia de estafador",
                },
                darknetListingExpiryHours = {
                    description = "Las ofertas activas caducan automáticamente después de este número de horas.",
                    label = "Duración de la oferta (horas)",
                },
                darknetMaximumListingQuantity = {
                    description = "Límite superior de cantidad para una oferta.",
                    label = "Cantidad máxima de mercancía",
                },
                darknetMaximumListings = {
                    description = "Máximo de ofertas por alias activo.",
                    label = "Máximo de ofertas activas",
                },
                darknetMaximumMessageLength = {
                    description = "Número máximo de caracteres por mensaje de chat encriptado.",
                    label = "Longitud máxima del mensaje",
                },
                darknetMaximumUnitPrice = {
                    description = "Precio máximo de cripto por una sola unidad.",
                    label = "Precio máximo por unidad",
                },
                darknetMeetingLocations = {
                    description = "Lugares asignados aleatoriamente para intercambios cara a cara con NPCs. Configurar al menos dos.",
                    itemLabel = "Lugar de encuentro",
                    label = "Lugares de encuentro",
                },
                darknetNpcBuyerAliases = {
                    description = "Nombres ficticios asignados al azar a las nuevas solicitudes de compra de NPCs. Configura al menos dos alias únicos.",
                    label = "Alias de compradores NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Límite superior utilizado al elegir aleatoriamente cuántas solicitudes de compra de NPC se activan.",
                    label = "Máximo de solicitudes de compra de NPC",
                },
                darknetNpcMaximumSellListings = {
                    description = "Límite superior utilizado al elegir aleatoriamente cuántas ofertas de venta de NPC se activan.",
                    label = "Máximo de ofertas de venta de NPC",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Cuando el mercado de NPCs se repone, permanecerán activos al menos este número de solicitudes de compra seleccionadas al azar.",
                    label = "Mínimo de solicitudes de compra de NPCs",
                },
                darknetNpcMinimumSellListings = {
                    description = "Cuando el mercado de NPCs se repone, al menos este número de ofertas de venta seleccionadas aleatoriamente permanecerán activas.",
                    label = "Ofertas mínimas de venta de NPCs",
                },
                darknetNpcSellerAliases = {
                    description = "Nombres ficticios asignados aleatoriamente a las nuevas ofertas de venta de NPC. Configura al menos dos alias únicos.",
                    label = "Alias de vendedores NPC",
                },
                darknetNpcTraders = {
                    description = "Configura las ofertas sintéticas, el método de entrega, la reputación y la probabilidad de estafa.",
                    label = "Compradores y vendedores NPC",
                },
                darknetPoliceGroups = {
                    description = "Claves de grupo que pueden publicar ofertas de señuelo y ver investigaciones.",
                    label = "Grupos de trabajos policiales autorizados",
                },
                darknetRenewalHours = {
                    description = "Horas añadidas cuando un propietario renueva una oferta.",
                    label = "Duración de la renovación (horas)",
                },
                darknetScamChance = {
                    description = "Probabilidad mínima de que un comerciante NPC tome el pago o la mercancía sin entregar la contrapartida. Se aplicará una probabilidad mayor específica del comerciante.",
                    label = "Probabilidad global de estafa de NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Cripto asignada solo cuando un jugador abre el mercado por primera vez.",
                    label = "Saldo inicial de la billetera",
                },
                darknetTabletOrder = {
                    description = "Controla la posición del Mercado Darknet en la tablet.",
                    label = "Orden de la app de la tablet",
                },
                darknetVerifiedMinimumRating = {
                    description = "Calificación media mínima para un vendedor verificado.",
                    label = "Calificación requerida para verificación",
                },
                darknetVerifiedMinimumSales = {
                    description = "Ventas exitosas requeridas antes de que un vendedor pueda ser verificado.",
                    label = "Ventas requeridas para verificación",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Cuenta utilizada cuando la fuente de pago se establece como la cuenta del jugador. Los pagos de la organización siempre utilizan la cuenta del Menú de Jefe.",
                    label = "Cuenta de pago del jugador",
                    options = {
                        bank = "Banco",
                        black_money = "Dinero sucio",
                        money = "Efectivo",
                    },
                    requiresWarning = "Solo se utiliza con la fuente de pago de la cuenta del jugador.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Usa el saldo del jugador que realiza la compra o la cuenta del Menú de Jefe de la organización.",
                    label = "Fuente de pago",
                    options = {
                        player = "Cuenta del jugador",
                        society = "Cuenta de la organización",
                    },
                },
                drugCamperLockKey = {
                    description = "Establece la tecla predeterminada para bloquear y desbloquear campers propios o compartidos con la facción. Los jugadores pueden sobrescribirla en sus controles de FiveM.",
                    label = "Tecla predeterminada de bloqueo del camper",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Añade datos de calidad y lote a los resultados de recolección por defecto. Desactiva esto para que los materiales crudos se apilen normalmente.",
                    label = "Metadatos de objetos de recolección",
                },
                drugLabAssaultAlertDuration = {
                    description = "Segundos que el radio de alerta del defensor permanece visible en el mapa.",
                    label = "Duración de la alerta de defensor",
                },
                drugLabAssaultAlertRadius = {
                    description = "Radio de la zona de ataque mostrada a la facción defensora en el mapa.",
                    label = "Radio de alerta de defensores",
                },
                drugLabAssaultBreachRadius = {
                    description = "Radio en el que el atacante debe permanecer mientras se fuerza la entrada.",
                    label = "Radio de permanencia de asalto",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Segundos que los atacantes deben mantener la entrada sin oposición para tomar el control del laboratorio o del camper.",
                    label = "Duración de la toma de control",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Área de entrada utilizada para contar a los atacantes y a los defensores en disputa.",
                    label = "Radio de captura",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Segundos necesarios para hackear el sistema de entrada.",
                    label = "Duración del hackeo electrónico",
                },
                drugLabAssaultEnabled = {
                    description = "Permite a las facciones asaltar y tomar el control de laboratorios rivales y campistas compartidos por facciones.",
                    label = "Activar tomas de laboratorios y campistas",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Segundos requeridos para forzar la entrada con una carga explosiva.",
                    label = "Duración de la brecha explosiva",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Distancia máxima desde la entrada del laboratorio o del camper al iniciar un ataque.",
                    label = "Distancia de interacción en la entrada",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Segundos necesarios para taladrar la cerradura de la entrada.",
                    label = "Duración del asalto mecánico",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Miembros en línea de la facción defensora requeridos antes de que pueda comenzar un ataque.",
                    label = "Defensores mínimos",
                },
                drugLabAssaultRequireDuty = {
                    description = "Solo cuenta a los miembros de la facción defensora que estén actualmente de servicio.",
                    label = "Contar solo defensores de servicio",
                },
                drugProcessingInventoryMetadata = {
                    description = "Adjunta datos de calidad y lote a los resultados de procesamiento de forma predeterminada. Las recetas individuales pueden anular este ajuste.",
                    label = "Metadatos de procesamiento de objetos",
                },
                graffitiItemName = {
                    description = "Objeto de inventario requerido para empezar a pintar cuando la opción de requisito de objeto esté activada. El objeto debe existir en el inventario activo.",
                    label = "Objeto de graffiti requerido",
                },
                heistCooldownMinutes = {
                    description = "Bloquea el mismo atraco después de que un intento con interacciones reales termine y se haya limpiado. El valor 0 desactiva el tiempo de espera. Una ventana de inicio no utilizada no lo activa.",
                    label = "Enfriamiento del atraco (minutos)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Barra de progreso de cinco segundos. Los ingredientes necesarios se consumen al completar con éxito.",
                        medium = "Selecciona los ingredientes en el orden indicado y supera una prueba de precisión temporal por ingrediente.",
                        advanced = "Montaje completo para recetas con perfil de dispositivo; en las demás, dos pruebas de precisión temporal por ingrediente.",
                    },
                    description = "Simple: barra de progreso de cinco segundos. Medio: selección de ingredientes y comprobaciones de tiempo. Máximo: ensamblaje completo del dispositivo; las recetas sin perfil de dispositivo utilizan dos comprobaciones de tiempo precisas por ingrediente.",
                    label = "Complejidad de fabricación",
                    options = {
                        advanced = "Complejidad máxima",
                        medium = "Complejidad media",
                        simple = "Sencillo",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Después de la primera interacción, cada nueva acción del atraco reinicia este temporizador. El vencimiento finaliza el intento y elimina sus objetos del mundo. Se aplica a nuevos intentos.",
                    label = "Límite de inactividad del atraco (minutos)",
                },
                heistStartTimeoutMinutes = {
                    description = "Tiempo tras pulsar Iniciar para interactuar en el objetivo. Sin interacción, el intento se reinicia y puede volver a iniciarse. Se aplica a nuevos intentos.",
                    label = "Minutos hasta la primera interacción del atraco",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banco",
                        black_money = "Dinero sucio",
                        money = "Efectivo",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Cuenta de la cual se retira el dinero sucio del jugador cuando comienza un ciclo de lavado.",
                    label = "Cuenta de depósito",
                },
                moneywashDrawDistance = {
                    description = "Distancia máxima en metros a la que se muestran las entradas de negocios y tiendas.",
                    label = "Distancia de visualización",
                },
                moneywashEnabled = {
                    description = "Hace que los negocios de lavado de dinero de la organización estén disponibles.",
                    label = "Activar lavado de dinero",
                },
                moneywashFeePercent = {
                    description = "Porcentaje deducido de cada lote antes del pago a la organización.",
                    label = "Comisión de servicio (%)",
                },
                moneywashInteractionDistance = {
                    description = "Distancia máxima en metros para usar entradas de negocios y tiendas.",
                    label = "Distancia de interacción",
                },
                npcPoliceAccuracy = {
                    description = "Precisión de los oficiales NPC de 0 a 100.",
                    label = "Precisión de disparo",
                },
                npcPoliceArmour = {
                    description = "Valor de blindaje de cada oficial NPC de 0 a 100.",
                    label = "Chaleco antibalas",
                },
                npcPoliceAtms = {
                    description = "Envía apoyo policial NPC cuando se activa la alarma de un robo a un cajero automático.",
                    label = "Apoyo policial durante robos a cajeros",
                },
                npcPoliceDurationSeconds = {
                    description = "Tiempo máximo que los oficiales NPC permanecen desplegados tras aparecer (30–900 segundos).",
                    label = "Duración del despliegue (segundos)",
                },
                npcPoliceEnabled = {
                    description = "Envía oficiales NPC armados cuando se activa una alarma de robo. Desactivado por defecto.",
                    label = "Activar apoyo policial NPC",
                },
                npcPoliceHeists = {
                    description = "Envía apoyo policial NPC cuando se activa una alarma de robo.",
                    label = "Apoyo durante los robos",
                },
                npcPoliceOfficerCount = {
                    description = "Número de oficiales NPC armados enviados por cada alarma de robo (1–8).",
                    label = "Oficiales por respuesta",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Tiempo entre la alarma de robo y la llegada de los oficiales NPC (0–300 segundos).",
                    label = "Retraso de respuesta (segundos)",
                },
                npcPoliceShops = {
                    description = "Envía apoyo policial de NPC cuando se activa la alarma de un robo a una tienda.",
                    label = "Apoyo durante robos a tiendas",
                },
                npcPoliceSpawnDistance = {
                    description = "Distancia objetivo desde la ubicación del robo en la que aparecen los oficiales NPC (15–150 metros).",
                    label = "Distancia de aparición (metros)",
                },
                npcPoliceWeapon = {
                    description = "Arma equipada por cada oficial NPC que responda. El valor predeterminado es una pistola.",
                    label = "Arma de servicio",
                    options = {
                        WEAPON_CARBINERIFLE = "Carabina",
                        WEAPON_PISTOL = "Pistola",
                        WEAPON_PUMPSHOTGUN = "Escopeta de corredera",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Abrir Creador de atracos",
                    description = "Abre el Heist Creator y cierra el Job Configurator.",
                    label = "Creador de atracos",
                    unsavedTooltip = "Guarda los cambios primero",
                },
                pickpocketAggressionChance = {
                    description = "Probabilidad independiente de que el NPC ataque tras un intento fallido, cancelado o expirado.",
                    label = "Probabilidad de contraataque (%)",
                },
                pickpocketAlertChance = {
                    description = "Probabilidad independiente de que el NPC reporte un intento fallido, cancelado o expirado.",
                    label = "Probabilidad de llamada de emergencia (%)",
                },
                pickpocketDifficulty = {
                    description = "Controla la velocidad del cursor, la rapidez con la que se encoge el objetivo, la longitud de la secuencia y los errores tolerados.",
                    label = "Dificultad",
                    options = {
                        easy = "Fácil",
                        expert = "Experto",
                        hard = "Difícil",
                        normal = "Normal",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Denunciar una vez cada intento de carterismo iniciado, incluso si tiene éxito e independientemente de la probabilidad de llamada de emergencia.",
                    label = "Enviar siempre un aviso",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Segundos que el reporte sigue siendo relevante para los consumidores de despacho.",
                    label = "Duración del despacho",
                },
                pickpocketDispatchJobs = {
                    description = "Nombres de trabajos separados por comas que reciben llamadas de emergencia.",
                    label = "Trabajos de despacho",
                },
                pickpocketDispatchPriority = {
                    description = "Prioridad enviada sin cambios a la integración de despacho.",
                    label = "Prioridad de despacho",
                },
                pickpocketDispatchRadius = {
                    description = "Radio de alerta aproximado enviado a la integración de despacho.",
                    label = "Radio de despacho",
                },
                pickpocketEmptyChance = {
                    description = "Probabilidad de que el NPC no lleve ningún botín seleccionable.",
                    label = "Probabilidad de bolsillos vacíos (%)",
                },
                pickpocketEnabled = {
                    description = "Permite a los jugadores intentar robar a NPCs ambientales en red que sean aptos.",
                    label = "Activar carterismo a NPCs",
                },
                pickpocketFleeChance = {
                    description = "Probabilidad independiente de que el NPC huya tras un intento fallido, cancelado o expirado.",
                    label = "Probabilidad de huida del NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Rango máximo del cliente; el servidor lo valida con un pequeño margen de sincronización.",
                    label = "Distancia de interacción",
                },
                pickpocketItems = {
                    description = "Cada fila controla su probabilidad de aparición. Cuatro decimales permiten un 0.0001 por ciento.",
                    itemLabel = "Probabilidad del objeto",
                    label = "Botín de objetos",
                },
                pickpocketItemsEnabled = {
                    description = "También incluye objetos configurados en el contenido visible de los bolsillos.",
                    label = "Activar botín de objetos",
                },
                pickpocketMaximumLootChoices = {
                    description = "Número máximo de espacios de efectivo o de objetos generados por el servidor que se muestran para un NPC.",
                    label = "Botín visible máximo",
                },
                pickpocketMinigame = {
                    description = "Elige un desafío o rota aleatoriamente entre los tres.",
                    label = "Minijuego",
                    options = {
                        pulse = "Pulso de presión",
                        random = "Rotación aleatoria",
                        sequence = "Secuencia de dirección",
                        timing = "Barra de tiempo",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Cantidad máxima de efectivo visible; se mantendrá automáticamente en o por encima del mínimo.",
                    label = "Efectivo máximo",
                },
                pickpocketMoneyMinimum = {
                    description = "Cantidad mínima generada por el servidor para un espacio de efectivo visible.",
                    label = "Efectivo mínimo",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Segundos mínimos entre solicitudes de inicio de un mismo jugador.",
                    label = "Enfriamiento de solicitud",
                },
                pickpocketRequireCrimeJob = {
                    description = "Activado: añade la acción solo a los trabajos del Sistema Criminal registrados. Desactivado: elimina la acción radial integrada y requiere la exportación del servidor.",
                    label = "Usar menú radial de trabajo criminal",
                },
                pickpocketRequiredHits = {
                    description = "Valor base para cada minijuego. El efectivo valioso lo aumenta por pasos; los objetos extremadamente raros requieren al menos ocho aciertos.",
                    label = "Acertos mínimos",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Segundos antes de que expire un desafío del servidor sin terminar.",
                    label = "Tiempo de espera de sesión",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Bloqueo tras intentos cancelados o fallidos; los NPCs vaciados con éxito permanecerán no disponibles.",
                    label = "Enfriamiento de NPC",
                },
                pvpAdminAce = {
                    description = "Objeto ACE que otorga acceso a la gestión global de eventos PvP.",
                    label = "ACE de Administrador",
                },
                pvpArenaReturnSeconds = {
                    description = "Tiempo de retorno predeterminado para nuevos eventos. Los líderes de evento pueden sobrescribirlo en la tablet.",
                    label = "Tiempo de retorno a la arena",
                },
                pvpArenaWarningPosition = {
                    description = "Controla dónde aparece la advertencia de regreso a la arena.",
                    label = "Posición de la advertencia de la arena",
                    options = {
                        bottom_center = "Abajo al centro",
                        bottom_left = "Abajo a la izquierda",
                        bottom_right = "Abajo a la derecha",
                        middle_center = "Centro de la pantalla",
                        middle_left = "Centro a la izquierda",
                        middle_right = "Centro a la derecha",
                        top_center = "Arriba al centro",
                        top_left = "Arriba a la izquierda",
                        top_right = "Arriba a la derecha",
                    },
                },
                pvpArenas = {
                    description = "Crea zonas de combate circulares con un punto de observación y al menos dos puntos de aparición para los equipos.",
                    itemLabel = "Arena",
                    label = "Arenas PvP",
                },
                pvpCountdownPosition = {
                    description = "Controla dónde aparece la cuenta regresiva de inicio del enfrentamiento.",
                    label = "Posición de la cuenta regresiva",
                    options = {
                        bottom_center = "Abajo al centro",
                        bottom_left = "Abajo a la izquierda",
                        bottom_right = "Abajo a la derecha",
                        middle_center = "Centro de la pantalla",
                        middle_left = "Centro a la izquierda",
                        middle_right = "Centro a la derecha",
                        top_center = "Arriba al centro",
                        top_left = "Arriba a la izquierda",
                        top_right = "Arriba a la derecha",
                    },
                },
                pvpDefaultMode = {
                    description = "Modo de juego preseleccionado para nuevos eventos.",
                    label = "Modo de juego predeterminado",
                    options = {
                        free_for_all = "Todos contra todos",
                        last_man_standing = "Último hombre en pie",
                        team_deathmatch = "Duelo por equipos",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Número predeterminado de eliminaciones requeridas para ganar en Team Deathmatch o Free For All.",
                    label = "Objetivo de eliminación predeterminado",
                },
                pvpEventsEnabled = {
                    description = "Habilita la aplicación de la tablet de PvP de facción y la ejecución de eventos.",
                    label = "Activar eventos de PvP de facción",
                },
                pvpKillfeedPosition = {
                    description = "Controla dónde se muestran las eliminaciones recientes.",
                    label = "Posición del killfeed",
                    options = {
                        bottom_center = "Abajo al centro",
                        bottom_left = "Abajo a la izquierda",
                        bottom_right = "Abajo a la derecha",
                        middle_center = "Centro de la pantalla",
                        middle_left = "Centro a la izquierda",
                        middle_right = "Centro a la derecha",
                        top_center = "Arriba al centro",
                        top_left = "Arriba a la izquierda",
                        top_right = "Arriba a la derecha",
                    },
                },
                pvpLeaderPermission = {
                    description = "Permiso de trabajo requerido para crear, registrar, iniciar y gestionar eventos de facción.",
                    label = "Permiso de líder de facción",
                },
                pvpMatchDurationMinutes = {
                    description = "Duración predeterminada en minutos para nuevos eventos. Cero desactiva el límite de tiempo.",
                    label = "Duración de la partida",
                },
                pvpMaxHistory = {
                    description = "Número máximo de eventos finalizados o cancelados devueltos en la tablet.",
                    label = "Historial de eventos visible",
                },
                pvpMaxRewards = {
                    description = "Número máximo de recompensas combinadas de objetos, armas, vehículos o dinero por evento.",
                    label = "Máximo de recompensas adicionales",
                },
                pvpMoneyPermission = {
                    description = "Permiso de trabajo requerido para cuotas de entrada y premios.",
                    label = "Permiso de finanzas de facción",
                },
                pvpRequestCooldownMs = {
                    description = "Milisegundos mínimos entre solicitudes de mutación PvP de un mismo jugador.",
                    label = "Enfriamiento de acción",
                },
                pvpRespawnDelaySeconds = {
                    description = "Segundos antes de que un jugador reaparezca o se mueva al área de observadores tras morir.",
                    label = "Retraso de reaparición",
                },
                pvpSchedulePollSeconds = {
                    description = "Segundos entre las comprobaciones de plantillas recurrentes y de inicios automáticos.",
                    label = "Intervalo de comprobación de programación",
                },
                pvpScoreboardPosition = {
                    description = "Controla dónde aparece la tabla de puntuación en vivo compacta durante los combates de facciones.",
                    label = "Posición en la tabla de puntuación",
                    options = {
                        bottom_center = "Abajo al centro",
                        bottom_left = "Abajo a la izquierda",
                        bottom_right = "Abajo a la derecha",
                        middle_center = "Centro de la pantalla",
                        middle_left = "Centro a la izquierda",
                        middle_right = "Centro a la derecha",
                        top_center = "Arriba al centro",
                        top_left = "Arriba a la izquierda",
                        top_right = "Arriba a la derecha",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Permite que los administradores de PvP se registren e inicien manualmente con un miembro de la facción. Desactivar esto en producción.",
                    label = "Activar pruebas en solitario para administradores",
                },
                pvpStartCountdownSeconds = {
                    description = "Cuenta regresiva por defecto para eventos recién creados. Los líderes del evento pueden modificarla en la tablet.",
                    label = "Iniciar cuenta regresiva",
                },
                pvpTabletOrder = {
                    description = "Controla dónde aparece la app de PvP de facción en la tablet.",
                    label = "Orden de la app de la tablet",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minutos antes de que un robo abandonado falle.",
                    label = "Tiempo de espera de actividad",
                },
                shopConsumeDrill = {
                    description = "Consumir el taladro tras una apertura exitosa.",
                    label = "Consumir taladro",
                },
                shopConsumeHackItem = {
                    description = "Consumir el objeto de hackeo tras abrir la caja fuerte con éxito.",
                    label = "Consumir objeto de hackeo",
                },
                shopCooldownMinutes = {
                    description = "Minutos de tiempo de ejecución antes de que la tienda se reinicie.",
                    label = "Enfriamiento de la tienda",
                },
                shopDispatchAlways = {
                    description = "Denunciar una vez cada robo a una tienda al iniciarse, incluso con intimidación continua y en tiendas que no requieren dependiente.",
                    label = "Enviar siempre un aviso",
                },
                shopDispatchDurationSeconds = {
                    description = "Segundos que la alerta permanece relevante.",
                    label = "Duración del despacho",
                },
                shopDispatchJobs = {
                    description = "Trabajos de destinatarios de alerta separados por comas.",
                    label = "Trabajos de despacho",
                },
                shopDispatchPriority = {
                    description = "Prioridad enviada al despacho.",
                    label = "Prioridad de despacho",
                },
                shopDispatchRadius = {
                    description = "Radio de alerta policial aproximado.",
                    label = "Radio de despacho",
                },
                shopDrillDurationSeconds = {
                    description = "Segundos necesarios para taladrar la caja fuerte.",
                    label = "Duración del taladro de la caja fuerte",
                },
                shopDrillItem = {
                    description = "ID del objeto del inventario necesario para perforar cajas fuertes de tiendas. Se configura por separado del taladro de cajeros.",
                    label = "Objeto taladro",
                },
                shopDrillItemAmount = {
                    description = "Número de objetos taladro requeridos.",
                    label = "Cantidad de taladros requerida",
                },
                shopEnabled = {
                    description = "Activa los robos en las tiendas con personal configuradas.",
                    label = "Activar robos a tiendas",
                },
                shopHackItem = {
                    description = "Objeto requerido para el minijuego de hackeo de la caja fuerte. Habilita el método de apertura por separado para cada tienda.",
                    label = "Objeto de hackeo",
                },
                shopHackItemAmount = {
                    description = "Cantidad requerida del objeto de hackeo.",
                    label = "Cantidad de objeto de hackeo",
                },
                shopIntimidationSeconds = {
                    description = "Segundos que el dependiente debe permanecer bajo amenaza de arma.",
                    label = "Duración de la intimidación",
                },
                shopLocations = {
                    description = "Un dependiente, una caja registradora y una caja fuerte opcional por tienda.",
                    itemLabel = "Tienda",
                    label = "Ubicaciones de tiendas",
                },
                shopMinimumPolice = {
                    description = "Miembros de la policía en servicio requeridos para comenzar.",
                    label = "Mínimo de policía",
                },
                shopPoliceGroup = {
                    description = "Grupo de trabajo contabilizado para el requisito policial.",
                    label = "Grupo de trabajo policial",
                },
                shopRegisterDurationSeconds = {
                    description = "Segundos necesarios para vaciar una caja registradora.",
                    label = "Duración del saqueo de caja registradora",
                },
                shopRegisterRewardMaximum = {
                    description = "Pago máximo de la caja registradora.",
                    label = "Recompensa máxima de caja registradora",
                },
                shopRegisterRewardMinimum = {
                    description = "Pago mínimo de la caja registradora.",
                    label = "Recompensa mínima de la caja registradora",
                },
                shopRegisterRewardName = {
                    description = "Nombre opcional de objeto o cuenta.",
                    label = "Nombre de la recompensa de la caja registradora",
                },
                shopRegisterRewardSort = {
                    description = "Elige entre efectivo y el objeto black_money.",
                    label = "Tipo de pago de la caja",
                },
                shopRegisters = {
                    description = "Posiciones de caja asignadas por ID de tienda.",
                    itemLabel = "Caja registradora",
                    label = "Cajas registradoras",
                },
                shopSafeLootDurationSeconds = {
                    description = "Segundos requeridos para llevar el efectivo tras introducir un código de caja fuerte válido.",
                    label = "Duración del botín de la caja fuerte",
                },
                shopSafeRewardMaximum = {
                    description = "Pago máximo de la caja fuerte.",
                    label = "Recompensa máxima de la caja fuerte",
                },
                shopSafeRewardMinimum = {
                    description = "Pago mínimo de la caja fuerte.",
                    label = "Recompensa mínima de la caja fuerte",
                },
                shopSafeRewardName = {
                    description = "Nombre opcional de objeto o cuenta.",
                    label = "Nombre de la recompensa de la caja fuerte",
                },
                shopSafeRewardSort = {
                    description = "Elige entre efectivo y el objeto black_money.",
                    label = "Tipo de pago de la caja fuerte",
                },
                shopThreatGraceSeconds = {
                    description = "Interrupción permitida antes de la alarma.",
                    label = "Periodo de gracia de apuntado",
                },
                territoryDrugSalesEnabled = {
                    description = "Las ventas callejeras exitosas a NPCs otorgan influencia a la banda del vendedor en el territorio de calle actual.",
                    label = "Las ventas de NPCs otorgan influencia de territorio",
                },
                atmLocationMode = {
                    label = "Modo de ubicación de cajeros",
                    description = "Detecta automáticamente objetos compatibles del mundo o utiliza solo ubicaciones configuradas manualmente.",
                    options = {
                        automatic = "Automático",
                        manual = "Manual",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Exigir policías de servicio",
                    description = "Exige el número configurado de policías de servicio antes de iniciar un robo a un cajero.",
                },
                openDrugCreator = {
                    label = "Editor de drogas",
                    description = "Abre el editor de drogas de Sky Crime y cierra el configurador de empleos.",
                    buttonLabel = "Abrir editor de drogas",
                    unsavedTooltip = "Guarda primero",
                },
                drugCreatorRuntimeDensity = {
                    label = "Densidad del panel de actividad",
                    description = "Determina la compacidad del panel de funcionamiento del editor de drogas.",
                    options = {
                        comfortable = "Cómoda",
                        compact = "Compacto",
                    },
                },
                drugCreatorListDensity = {
                    label = "Densidad de la lista",
                    description = "Determina la compacidad de la lista de entradas del editor.",
                    options = {
                        comfortable = "Cómoda",
                        compact = "Compacto",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Mostrar listas de actividad vacías",
                    description = "Muestra las secciones del panel de actividad aunque no tengan entradas.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Ocultar entradas desactivadas",
                    description = "Oculta las entradas de módulos desactivadas en la lista del editor de drogas.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Generar ID automáticamente",
                    description = "Genera los identificadores a partir de los nombres al crear entradas en el editor de drogas.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Abrir editor al cambiar módulo",
                    description = "Abre el editor automáticamente al cambiar de módulo activo.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Sufijo automático para copias",
                    description = "Añade un sufijo automático al duplicar entradas del editor de drogas.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Preseleccionar objetivos del juego",
                    description = "Preselecciona automáticamente laboratorios y lotes disponibles.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Centrar en problemas al abrir",
                    description = "Abre el panel de actividad centrado en las entradas que requieren atención.",
                },
                drugActivityHudPosition = {
                    label = "Posición del HUD de actividad",
                    description = "Arrastra el HUD de colocación y recolección a la posición deseada de la pantalla.",
                },
                drugInteractionHudPosition = {
                    label = "Posición del HUD de interacción",
                    description = "Arrastra el HUD de interacción de plantas, laboratorios y caravanas a la posición deseada.",
                },
                drugPlantStatusHudPosition = {
                    label = "Posición del HUD de estado de planta",
                    description = "Arrastra el HUD detallado del estado de la planta a la posición deseada.",
                },
                drugSystemEnabled = {
                    label = "Sistema de drogas",
                    description = "Activa: producción de drogas, datos del editor e interfaces del juego para este empleo criminal.",
                },
                drugCreatorAccess = {
                    label = "Acceso al editor de drogas",
                    description = "Determina quién puede abrir el editor avanzado de drogas.",
                    options = {
                        permission = "Solo con permiso",
                        job_management = "Gestión del empleo",
                        owner_only = "Solo propietario",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfaces de funcionamiento",
                    description = "Permite a los jugadores usar las acciones de laboratorios, plantas, procesamiento y mercado en el juego.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Creación de laboratorios por jugadores",
                    description = "Permite crear laboratorios desde las plantillas del editor a jugadores con acceso al sistema, aunque no sean administradores.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Cultivo al aire libre",
                    description = "Permite cultivos exteriores de jugadores fuera de los laboratorios configurados.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Cosecha exterior por otros jugadores",
                    description = "Permite a otros jugadores cosechar plantas exteriores que no hayan plantado.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Cobrar compra del laboratorio",
                    description = "Cobra a los jugadores el precio configurado al crear un laboratorio.",
                },
                drugRuntimeStrictInventory = {
                    label = "Validar estrictamente el inventario",
                    description = "Las acciones solo continúan si las operaciones configuradas de objetos, herramientas y dinero tienen éxito.",
                },
                drugRuntimeSalePayouts = {
                    label = "Venta / Pagos",
                    description = "Paga a los jugadores cuando se venden lotes o rutas mediante el sistema de mercado.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Pago / Cuenta",
                    description = "Cuenta para los pagos de ventas de drogas, por ejemplo black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Despacho / Alertas",
                    description = "Envía los eventos de riesgo de drogas a la central y a los empleos policiales configurados.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Policía / Notificaciones",
                    description = "Notifica a los empleos policiales configurados cuando un evento de riesgo de drogas genera una alerta.",
                },
                drugBatchPrefix = {
                    label = "Lote / Prefijo",
                    description = "Prefijo de los identificadores de nuevos lotes de drogas.",
                },
                drugTestingKitAccuracy = {
                    label = "Kit de Prueba / Precisión",
                    description = "Variación permitida de los valores ocultos con un kit de pruebas básico.",
                },
                drugDecayIntervalMinutes = {
                    label = "Decaimiento / Intervalo",
                    description = "Intervalo en minutos para comprobaciones de pérdida de frescura y reducción de contaminación.",
                },
                drugDefaultPackaging = {
                    label = "Valor predeterminado / Embalaje",
                    description = "Embalaje para lotes crudos o procesados creados sin un tipo de embalaje explícito.",
                    options = {
                        loose = "Suelto",
                        baggy = "Bolsita",
                        jar = "Frasco",
                        vacuum = "Bolsa al vacío",
                        brick = "Envoltura de bloque",
                        premium_seal = "Sellado prémium",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Calidad / Peso",
                    description = "Influencia en la calidad final: Calidad base.",
                },
                drugQualityWeightPurity = {
                    label = "Pureza / Peso",
                    description = "Influencia en la calidad final: Pureza.",
                },
                drugQualityWeightFreshness = {
                    label = "Frescura / Peso",
                    description = "Influencia en la calidad final: Frescura.",
                },
                drugQualityWeightPotency = {
                    label = "Potencia / Peso",
                    description = "Influencia en la calidad final: Potencia.",
                },
                drugQualityWeightStability = {
                    label = "Estabilidad / Peso",
                    description = "Influencia en la calidad final: Estabilidad.",
                },
                drugQualityWeightContamination = {
                    label = "Contaminación / Penalización",
                    description = "Penalización de calidad para productos contaminados.",
                },
                drugTierGoodMin = {
                    label = "Bueno / Nivel / Mínimo",
                    description = "Puntuación mínima para el nivel de calidad Bueno.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Nivel / Mínimo",
                    description = "Puntuación mínima para el nivel de calidad Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Calidad superior / Nivel / Mínimo",
                    description = "Puntuación mínima para el nivel de calidad Calidad superior.",
                },
                drugTierLabGradeMin = {
                    label = "Calidad de laboratorio / Nivel / Mínimo",
                    description = "Puntuación mínima para el nivel de calidad Calidad de laboratorio.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Bolsita / Decaimiento",
                    description = "Multiplicador para pérdida de frescura / Bolsitas.",
                },
                drugJarDecayMultiplier = {
                    label = "Frasco / Decaimiento",
                    description = "Multiplicador para pérdida de frescura / Frascos.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vacío / Decaimiento",
                    description = "Multiplicador para pérdida de frescura / Bolsas al vacío.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Sellado prémium / Precio",
                    description = "Multiplicador para Premium / Producto sellado / Precio.",
                },
                drugGrowingEnabled = {
                    label = "Cultivo / Activado",
                    description = "Activa: crecimiento de plantas y cosecha.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Inspección del lugar de cultivo",
                    description = "Al activarla, las plantas colocadas libremente esperan una inspección automática del lugar por un administrador. Desactívala para permitir el crecimiento sin aprobación administrativa.",
                },
                drugGrowthTickMinutes = {
                    label = "Crecimiento / Ciclo de actualización / Minutos",
                    description = "Intervalo en minutos para actualizaciones del crecimiento de plantas.",
                },
                drugBaseGrowthPerTick = {
                    label = "Valor base / Crecimiento / Por ciclo de actualización",
                    description = "Crecimiento base antes de los modificadores de variedad, equipo y cuidados.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Planta salvaje / Reaparición",
                    description = "Espera en minutos antes de: Planta salvaje / Reaparición.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Resaltar plantas silvestres",
                    description = "Muestra el contorno de las plantas silvestres generadas cuando un jugador entra en el radio de resaltado.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Radio de resaltado de plantas silvestres",
                    description = "Distancia en metros alrededor de cada planta silvestre generada en la que se muestra su contorno.",
                },
                drugDefaultPlantWater = {
                    label = "Valor predeterminado / Agua",
                    description = "Valor inicial al crear una planta: Agua.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Valor predeterminado / Fertilizante",
                    description = "Valor inicial al crear una planta: Fertilizante.",
                },
                drugDefaultPlantHealth = {
                    label = "Valor predeterminado / Salud",
                    description = "Valor inicial al crear una planta: Salud.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Valor predeterminado / Probabilidad de mutación",
                    description = "Probabilidad base de mutación si la variedad no especifica un valor propio.",
                },
                drugHarvestPerfectStart = {
                    label = "Inicio de cosecha óptima",
                    description = "Porcentaje de crecimiento para la ventana de cosecha óptima: Inicio.",
                },
                drugHarvestPerfectEnd = {
                    label = "Fin de cosecha óptima",
                    description = "Porcentaje de crecimiento para la ventana de cosecha óptima: Fin.",
                },
                drugLabsEnabled = {
                    label = "Laboratorios / Activado",
                    description = "Activa: laboratorios y autocaravanas en el juego.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratorios por personaje",
                    description = "Máximo de laboratorios fijos comprados o alquilados por propietario. 0 significa sin límite; las autocaravanas y los accesos compartidos no cuentan.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratorios por facción",
                    description = "Máximo de laboratorios fijos comprados o alquilados por propietario. 0 significa sin límite; las autocaravanas y los accesos compartidos no cuentan.",
                },
                drugDefaultRentDays = {
                    label = "Valor predeterminado / Días de alquiler",
                    description = "Valor predeterminado para Laboratorio / Alquiler / Duración.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Autocaravana robada / Minutos",
                    description = "Tiempo durante el que las autocaravanas robadas mantienen un riesgo elevado.",
                },
                drugLabRentWarningHours = {
                    label = "Alquiler / Aviso / Horas",
                    description = "Horas antes del vencimiento del alquiler del laboratorio para mostrar una advertencia.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Alquiler vencido / Presión policial",
                    description = "Sospecha añadida al vencer el alquiler del laboratorio.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Autocaravana / Mover / Enfriamiento",
                    description = "Espera en minutos antes de: Autocaravana / Laboratorio / Nuevo traslado.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Mejora / Costo / Multiplicador",
                    description = "Multiplicador para Laboratorio / Nivel / Mejora / Precios.",
                },
                drugCamperBaseSlots = {
                    label = "Autocaravana / Ranuras",
                    description = "Valor predeterminado para laboratorios de autocaravana / espacios de equipamiento.",
                },
                drugCamperBaseStorage = {
                    label = "Autocaravana / Almacenamiento",
                    description = "Valor predeterminado para laboratorios de autocaravana / Capacidad de almacenamiento.",
                },
                drugCamperBasePower = {
                    label = "Autocaravana / Energía",
                    description = "Valor predeterminado para laboratorios de autocaravana / Alimentación integrada.",
                },
                drugBasementBaseSlots = {
                    label = "Sótano / Ranuras",
                    description = "Valor predeterminado para laboratorios de sótano / espacios de equipamiento.",
                },
                drugBasementBaseStorage = {
                    label = "Sótano / Almacenamiento",
                    description = "Valor predeterminado para laboratorios de sótano / Capacidad de almacenamiento.",
                },
                drugWarehouseBasePower = {
                    label = "Almacén / Energía",
                    description = "Valor predeterminado para laboratorios de almacén / Alimentación integrada.",
                },
                drugPowerEnabled = {
                    label = "Energía / Sistema",
                    description = "Activa: generación eléctrica, consumo y comprobaciones de sobrecarga del laboratorio.",
                },
                drugOverloadGraceSeconds = {
                    label = "Sobrecarga / Plazo de gracia",
                    description = "Segundos antes de que una sobrecarga eléctrica se vuelva peligrosa.",
                },
                drugHeatPerKilowatt = {
                    label = "Presión policial / Por kilovatio",
                    description = "Sospecha del laboratorio generada por el consumo eléctrico.",
                },
                drugGeneratorT1Watts = {
                    label = "Generador T1 / Watts",
                    description = "Potencia de los generadores de nivel T1 en vatios.",
                },
                drugGeneratorT2Watts = {
                    label = "Generador T2 / Watts",
                    description = "Potencia de los generadores de nivel T2 en vatios.",
                },
                drugGeneratorT3Watts = {
                    label = "Generador T3 / Watts",
                    description = "Potencia de los generadores de nivel T3 en vatios.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Desgaste / Multiplicador",
                    description = "Multiplicador global para Desgaste del equipo / Procesamiento.",
                },
                drugWorkersEnabled = {
                    label = "Trabajadores / Activado",
                    description = "Activa: químicos, cultivadores, empaquetadores y personal de seguridad en laboratorios de drogas.",
                },
                drugMaxWorkersPerLab = {
                    label = "Máximo / Trabajadores / Laboratorio",
                    description = "Número máximo de trabajadores por laboratorio.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Fatiga por procesamiento",
                    description = "Fatiga añadida para Trabajadores después de esta tarea: Paso de procesamiento.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Cultivo / Fatiga",
                    description = "Fatiga añadida para Cultivadores después de esta tarea: Cosecha o cultivo.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Trabajador / Recuperación",
                    description = "Recuperación de Fatiga en cada paso: Actualización de crecimiento.",
                },
                drugMarketEnabled = {
                    label = "Mercado / Activado",
                    description = "Activa: compradores, traficantes y ventas de lotes.",
                },
                drugMarketBasePriceFallback = {
                    label = "Valor alternativo / Precio base",
                    description = "Precio base para drogas sin un precio específico configurado.",
                },
                drugMarketStreetMultiplier = {
                    label = "Calle / Multiplicador",
                    description = "Multiplicador global para Precio / Ventas callejeras.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Mayorista / Multiplicador",
                    description = "Multiplicador global para Precio / Mayorista / Tratos.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Multiplicador",
                    description = "Multiplicador global para Precio / Premium / Compradores.",
                },
                drugMarketHeatPerSale = {
                    label = "Presión policial / Venta",
                    description = "Presión policial base añadida al laboratorio al vender un lote.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribución / Ciclo de actualización",
                    description = "Intervalo en minutos para actualizaciones de distribución de traficantes.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribución / Intervalo",
                    description = "Valor predeterminado para Distribuidor / Espera antes de venta / Minutos.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Máximo / Distribuidor / Órdenes",
                    description = "Valor predeterminado para Distribuidor / cantidad máxima de pedidos de distribución activos.",
                },
                drugThreatsEnabled = {
                    label = "Amenazas / Activado",
                    description = "Activa: reducción de sospecha, redadas y sabotajes en laboratorios.",
                },
                drugThreatTickMinutes = {
                    label = "Amenaza / Ciclo de actualización",
                    description = "Intervalo en minutos para reducción de sospecha y comprobaciones de redada y sabotaje.",
                },
                drugRaidHeatThreshold = {
                    label = "Umbral de sospecha para redadas",
                    description = "Presión policial necesaria en el laboratorio para poder activar: Redadas.",
                },
                drugSabotageHeatThreshold = {
                    label = "Umbral de sospecha para sabotaje",
                    description = "Presión policial necesaria en el laboratorio para poder activar: Sabotaje.",
                },
                drugThreatHeatDecay = {
                    label = "Presión policial / Decaimiento",
                    description = "Reduce la sospecha del laboratorio en este valor con cada actualización de amenazas.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Probabilidad de redada",
                    description = "Probabilidad base de Asalto al alcanzar el umbral de presión policial correspondiente.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotaje / Oportunidad",
                    description = "Probabilidad base de Sabotaje al alcanzar el umbral de presión policial correspondiente.",
                },
                drugConsumptionEnabled = {
                    label = "Consumo habilitado",
                    description = "Activa: efectos de drogas y seguimiento de tolerancia y adicción.",
                },
                drugDoseConsumesBatch = {
                    label = "Consumir lote al usar",
                    description = "Retira un lote consumido del stock activo.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerancia / Decaimiento",
                    description = "Intervalo en minutos para actualizaciones de reducción de tolerancia.",
                },
                drugAddictionDecayMinutes = {
                    label = "Adicción / Decaimiento",
                    description = "Intervalo en minutos para actualizaciones de reducción de adicción.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potencia / Multiplicador",
                    description = "Determina cuánto aumenta la potencia la intensidad de los efectos.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Sobredosis / Umbral",
                    description = "Carga de potencia necesaria para que pueda calcularse una sobredosis.",
                },
                drugBaseAddictionGain = {
                    label = "Valor base / Adicción / ganancia",
                    description = "Aumento base de la adicción por dosis.",
                },
                drugProcessingEnabled = {
                    label = "Procesamiento / Activado",
                    description = "Activa: trabajos de procesamiento, embalaje y kits de pruebas.",
                },
                drugBatchMetadataItemKey = {
                    label = "Lote / Metadatos / Llave",
                    description = "Clave de metadatos del inventario que usan las integraciones para los datos de lotes.",
                },
                drugDefaultProcessDuration = {
                    label = "Duración predeterminada del procesamiento",
                    description = "Valor predeterminado para Procesamiento / Duración / segundos / Sin valor propio de la receta.",
                },
                drugDefaultFailureRisk = {
                    label = "Valor predeterminado / Riesgo de fallo",
                    description = "Valor predeterminado para Procesamiento / Riesgo de fallo / Sin valor propio de la receta.",
                },
                drugPackagingDuration = {
                    label = "Tiempo de embalaje",
                    description = "Valor predeterminado para Embalaje / Duración / segundos.",
                },
                drugPowerTickSeconds = {
                    label = "Energía / Ciclo de actualización / segundos",
                    description = "Intervalo en segundos para actualización del consumo de generadores y las huellas eléctricas.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Huella eléctrica / Presión policial / Hora",
                    description = "Sospecha generada por hora por la huella eléctrica del laboratorio.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Sobrecarga / Presión policial / Hora",
                    description = "Presión policial adicional por hora mientras el laboratorio está sobrecargado.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Inactivo / Presión policial / Decaimiento / Hora",
                    description = "Reducción de sospecha por hora mientras el laboratorio no tenga una huella eléctrica activa.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manual / Máximo / Carga",
                    description = "Valor del modo energético Manual: Máximo / Carga.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manual / Presión policial / Multiplicador",
                    description = "Valor del modo energético Manual: Presión policial / Multiplicador.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manual / Ruido / Multiplicador",
                    description = "Valor del modo energético Manual: Ruido / Multiplicador.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Equilibrado / Máximo / Carga",
                    description = "Valor del modo energético Equilibrado: Máximo / Carga.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Equilibrado / Presión policial / Multiplicador",
                    description = "Valor del modo energético Equilibrado: Presión policial / Multiplicador.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Equilibrado / Ruido / Multiplicador",
                    description = "Valor del modo energético Equilibrado: Ruido / Multiplicador.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Sigilo / Máximo / Carga",
                    description = "Valor del modo energético Sigilo: Máximo / Carga.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Sigilo / Presión policial / Multiplicador",
                    description = "Valor del modo energético Sigilo: Presión policial / Multiplicador.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Sigilo / Ruido / Multiplicador",
                    description = "Valor del modo energético Sigilo: Ruido / Multiplicador.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Control de olores / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Control de olores / Equipamiento.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilación / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Ventilación / Equipamiento.",
                },
                drugPowerPrioritySecurity = {
                    label = "Seguridad / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Equipo de seguridad.",
                },
                drugPowerPriorityGrowing = {
                    label = "Cultivo / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Cultivo / Equipamiento.",
                },
                drugPowerPriorityLight = {
                    label = "Iluminación / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Iluminación / Equipamiento.",
                },
                drugPowerPriorityTesting = {
                    label = "Análisis / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Análisis / Equipamiento.",
                },
                drugPowerPriorityPackaging = {
                    label = "Embalaje / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Embalaje / Equipamiento.",
                },
                drugPowerPriorityChemistry = {
                    label = "Química / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Química / Equipamiento.",
                },
                drugPowerPriorityHeating = {
                    label = "Calefacción / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Calefacción / Equipamiento.",
                },
                drugPowerPriorityPressing = {
                    label = "Prensado / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Prensado / Equipamiento.",
                },
                drugPowerPriorityGeneral = {
                    label = "Generales / Prioridad",
                    description = "Prioridad de desconexión automática de cargas: Equipo general.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Rendimiento / Inactivo / Control / Intervalo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Inactivo / Control / Intervalo / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Rendimiento / Interacción / Inactivo / Intervalo de escaneo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Interacción / Inactivo / Intervalo de escaneo / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Rendimiento / Interacción / Aviso de interacción / Intervalo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Interacción / Aviso de interacción / Intervalo / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Rendimiento / Interacción / Intervalo de escaneo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Interacción / Intervalo de escaneo / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Rendimiento / Mínimo / Intervalo de escaneo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Mínimo / Intervalo de escaneo / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Rendimiento / Calle / Ped / Activación / Distancia",
                    description = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Activación / Distancia.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Rendimiento / Calle / Ped / Inactivo / Intervalo de escaneo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Inactivo / Intervalo de escaneo / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Rendimiento / Calle / Ped / Intervalo de escaneo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Calle / Ped / Intervalo de escaneo / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Rendimiento / Mundo / Caché / Margen adicional",
                    description = "Parámetro de funcionamiento para Rendimiento / Mundo / Caché / Margen adicional.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Rendimiento / Mundo / Caché / Actualización / Intervalo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Mundo / Caché / Actualización / Intervalo / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Rendimiento / Mundo / Inactivo / Intervalo / ms",
                    description = "Parámetro de funcionamiento para Rendimiento / Mundo / Inactivo / Intervalo / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Mercado Dinámico / Enfriamiento de acción / segundos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Enfriamiento de acción / segundos.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Mercado Dinámico / Acción / Límite del historial",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Acción / Límite del historial.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Mercado Dinámico / Cantidad / Saturación / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Cantidad / Saturación / Peso.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Mercado Dinámico / Valor base / Precisión de la información",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Valor base / Precisión de la información.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Mercado Dinámico / Valor predeterminado / Promedio / Calidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Valor predeterminado / Promedio / Calidad.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Mercado Dinámico / Valor predeterminado / Recurso / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Valor predeterminado / Recurso / Elasticidad.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Mercado Dinámico / Demanda / Valor central",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Demanda / Valor central.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Mercado Dinámico / Demanda / Precio / Impacto",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Demanda / Precio / Impacto.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Mercado Dinámico / Dirección / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Dirección / Umbral.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Mercado Dinámico / Activado",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Activado.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Mercado Dinámico / Evento / Oportunidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Oportunidad.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Mercado Dinámico / Evento / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Duración / Minutos.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Mercado Dinámico / Evento / Mínimo / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Mínimo / Duración / Minutos.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Mercado Dinámico / Evento / Intensidad / Máximo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Intensidad / Máximo.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Mercado Dinámico / Evento / Intensidad / Mínimo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Evento / Intensidad / Mínimo.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Mercado Dinámico / Eventos / Operación policial / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Operación policial / Demanda.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Mercado Dinámico / Eventos / Operación policial / Policía",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Operación policial / Policía.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Mercado Dinámico / Eventos / Operación policial / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Operación policial / Precio.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Mercado Dinámico / Eventos / Festival / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Demanda.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Mercado Dinámico / Eventos / Festival / Efectos / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Efectos / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Mercado Dinámico / Eventos / Festival / Efectos / 2",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Efectos / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Mercado Dinámico / Eventos / Festival / Efectos / 3",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Efectos / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Mercado Dinámico / Eventos / Festival / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Precio.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Mercado Dinámico / Eventos / Festival / Perfiles / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Festival / Perfiles / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Mercado Dinámico / Eventos / Conflicto de bandas / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Conflicto de bandas / Demanda.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Mercado Dinámico / Eventos / Conflicto de bandas / Policía",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Conflicto de bandas / Policía.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Mercado Dinámico / Eventos / Conflicto de bandas / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Conflicto de bandas / Precio.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Mercado Dinámico / Eventos / Conflicto de bandas / Perfiles / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Conflicto de bandas / Perfiles / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Mercado Dinámico / Eventos / Redada en laboratorio / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Redada en laboratorio / Demanda.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Mercado Dinámico / Eventos / Redada en laboratorio / Policía",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Redada en laboratorio / Policía.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Mercado Dinámico / Eventos / Redada en laboratorio / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Redada en laboratorio / Precio.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Mercado Dinámico / Eventos / Redada en laboratorio / Suministro",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Redada en laboratorio / Suministro.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Demanda.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Efectos / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Efectos / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Efectos / 2",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Efectos / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Efectos / 3",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Efectos / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Precio.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Perfiles / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Perfiles / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Mercado Dinámico / Eventos / Fiesta / Perfiles / 2",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Fiesta / Perfiles / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Mercado Dinámico / Eventos / Escasez / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Escasez / Demanda.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Mercado Dinámico / Eventos / Escasez / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Escasez / Precio.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Mercado Dinámico / Eventos / Escasez / Suministro",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Eventos / Escasez / Suministro.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Mercado Dinámico / Información exacta / Reputación",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información exacta / Reputación.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Mercado Dinámico / Información exacta / Confianza",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información exacta / Confianza.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Mercado Dinámico / Global / Zona / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Global / Zona / Etiqueta.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Mercado Dinámico / Límite del historial",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Límite del historial.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Mercado Dinámico / Valor inicial / Demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Valor inicial / Demanda.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Mercado Dinámico / Valor inicial / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Valor inicial / Multiplicador de Precio.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Mercado Dinámico / Información / Demanda / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Demanda / Error.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Mercado Dinámico / Información / Máximo / Precisión",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Máximo / Precisión.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Mercado Dinámico / Información / Mínimo / Precisión",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Mínimo / Precisión.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Mercado Dinámico / Información / Policía / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Policía / Error.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Mercado Dinámico / Información / Precio / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Error.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Mercado Dinámico / Información / Precio / Máximo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Máximo.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Mercado Dinámico / Información / Precio / Mínimo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Precio / Mínimo.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Mercado Dinámico / Información / Reputación / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Reputación / Peso.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Mercado Dinámico / Información / Recurso / Precio / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Recurso / Precio / Error.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Mercado Dinámico / Información / Saturación / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Saturación / Error.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Mercado Dinámico / Ventana de semilla de información / segundos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Ventana de semilla de información / segundos.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Mercado Dinámico / Información / Estado / Precisión / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Estado / Precisión / Umbral.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Mercado Dinámico / Información / Estado / Error / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Estado / Error / Umbral.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Mercado Dinámico / Información / Suministro / Error",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Suministro / Error.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Mercado Dinámico / Información / Confianza / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Información / Confianza / Peso.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Mercado Dinámico / Manipulación / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Minutos de enfriamiento.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Mercado Dinámico / Manipulación / Demanda / Variación",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Demanda / Variación.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Mercado Dinámico / Manipulación / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Duración / Minutos.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Mercado Dinámico / Manipulación / Presión policial",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Presión policial.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Mercado Dinámico / Manipulación / Mínimo / Lote / Cantidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Mínimo / Lote / Cantidad.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Mercado Dinámico / Manipulación / Cuenta de pago",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Cuenta de pago.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Mercado Dinámico / Manipulación / Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Precio.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Mercado Dinámico / Manipulación / Zona / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Manipulación / Zona / Presión policial / Multiplicador.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Mercado Dinámico / Máximo / Antigüedad de la información / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Máximo / Antigüedad de la información / Minutos.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Mercado Dinámico / Máximo / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Máximo / Multiplicador de Precio.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Mercado Dinámico / Mínimo / Antigüedad de la información / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Antigüedad de la información / Minutos.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Mercado Dinámico / Mínimo / Métrica / Ventana temporal / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Métrica / Ventana temporal / Minutos.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Mercado Dinámico / Precio mínimo / Multiplicador",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Precio mínimo / Multiplicador.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Mercado Dinámico / Mínimo / Actualización / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Mínimo / Actualización / Minutos.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Mercado Dinámico / Policía / Demanda / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Policía / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Mercado Dinámico / Policía / Precio / Impacto",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Policía / Precio / Impacto.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Mercado Dinámico / Mala calidad / Demanda / Penalización",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Mala calidad / Demanda / Penalización.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Mercado Dinámico / Mala calidad / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Mala calidad / Umbral.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Mercado Dinámico / Calidad prémium / Bono de demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Calidad prémium / Bono de demanda.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Mercado Dinámico / Calidad prémium / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Calidad prémium / Umbral.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Mercado Dinámico / Producción / Suministro / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Producción / Suministro / Peso.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Mercado Dinámico / Producción / Ventana temporal / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Producción / Ventana temporal / Minutos.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Mercado Dinámico / Calidad / Valor central",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Valor central.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Mercado Dinámico / Calidad / Confianza / Impacto",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Confianza / Impacto.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Mercado Dinámico / Calidad / Rango de valores",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Calidad / Rango de valores.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Mercado Dinámico / Rareza / Bonificación / Máximo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Rareza / Bonificación / Máximo.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Mercado Dinámico / Regional / Global / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Regional / Global / Peso.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Mercado Dinámico / Regional / Local / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Regional / Local / Peso.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Mercado Dinámico / Recurso / Alias / Droga / Embalaje",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Alias / Droga / Embalaje.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Mercado Dinámico / Recurso / Alias / Bidón de combustible",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Alias / Bidón de combustible.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Mercado Dinámico / Recurso / Alias / Aceite de maquinaria",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Alias / Aceite de maquinaria.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Mercado Dinámico / Recurso / Alias / Nutrientes para plantas",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Alias / Nutrientes para plantas.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Mercado Dinámico / Recurso / Alias / Kit de reparación",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Alias / Kit de reparación.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Mercado Dinámico / Recurso / Dirección / Descenso / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Dirección / Descenso / Umbral.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Mercado Dinámico / Recurso / Dirección / Aumento / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recurso / Dirección / Aumento / Umbral.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 2",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 3",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Filtro de carbón / Drogas vinculadas / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Mercado Dinámico / Recursos / Precursor químico / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Precursor químico / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Mercado Dinámico / Recursos / Precursor químico / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Precursor químico / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Mercado Dinámico / Recursos / Precursor químico / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Precursor químico / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Mercado Dinámico / Recursos / Precursor químico / Drogas vinculadas / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Precursor químico / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Mercado Dinámico / Recursos / Precursor químico / Drogas vinculadas / 2",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Precursor químico / Drogas vinculadas / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Mercado Dinámico / Recursos / Piezas de equipo / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Piezas de equipo / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Mercado Dinámico / Recursos / Piezas de equipo / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Piezas de equipo / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Mercado Dinámico / Recursos / Piezas de equipo / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Piezas de equipo / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Mercado Dinámico / Recursos / Fertilizante / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Fertilizante / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Mercado Dinámico / Recursos / Fertilizante / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Fertilizante / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Mercado Dinámico / Recursos / Fertilizante / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Fertilizante / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Mercado Dinámico / Recursos / Fertilizante / Drogas vinculadas / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Fertilizante / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Mercado Dinámico / Recursos / Combustible de laboratorio / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Combustible de laboratorio / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Mercado Dinámico / Recursos / Combustible de laboratorio / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Combustible de laboratorio / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Mercado Dinámico / Recursos / Combustible de laboratorio / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Combustible de laboratorio / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Mercado Dinámico / Recursos / Bolsa de embalaje / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Bolsa de embalaje / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Mercado Dinámico / Recursos / Bolsa de embalaje / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Bolsa de embalaje / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Mercado Dinámico / Recursos / Bolsa de embalaje / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Bolsa de embalaje / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Mercado Dinámico / Recursos / Maceta / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Maceta / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Mercado Dinámico / Recursos / Maceta / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Maceta / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Mercado Dinámico / Recursos / Maceta / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Maceta / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Mercado Dinámico / Recursos / Maceta / Drogas vinculadas / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Maceta / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Mercado Dinámico / Recursos / Semilla de cannabis / Precio base",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Semilla de cannabis / Precio base.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Mercado Dinámico / Recursos / Semilla de cannabis / Elasticidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Semilla de cannabis / Elasticidad.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Mercado Dinámico / Recursos / Semilla de cannabis / Etiqueta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Semilla de cannabis / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Mercado Dinámico / Recursos / Semilla de cannabis / Drogas vinculadas / 1",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Recursos / Semilla de cannabis / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Mercado Dinámico / Ventas / Ventana temporal / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Ventas / Ventana temporal / Minutos.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Mercado Dinámico / Saturación / Demanda / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Saturación / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Mercado Dinámico / Saturación / Precio / Impacto",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Saturación / Precio / Impacto.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Mercado Dinámico / Escasez / Demanda / Peso",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Mercado Dinámico / Escasez / Precio / Impacto",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Precio / Impacto.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Mercado Dinámico / Estación / Fin / Meses / Diciembre",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Fin / Meses / Diciembre.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Mercado Dinámico / Estación / Fin / Meses / Primavera",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Fin / Meses / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Mercado Dinámico / Estación / Fin / Meses / Verano",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Fin / Meses / Verano.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Mercado Dinámico / Estación / Fin / Meses / Invierno",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Fin / Meses / Invierno.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Mercado Dinámico / Estación / Multiplicadores / Otoño",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Multiplicadores / Otoño.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Mercado Dinámico / Estación / Multiplicadores / Primavera",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Multiplicadores / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Mercado Dinámico / Estación / Multiplicadores / Verano",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Multiplicadores / Verano.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Mercado Dinámico / Estación / Multiplicadores / Invierno",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estación / Multiplicadores / Invierno.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Mercado Dinámico / Escasez / Rumor / Umbral",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Escasez / Rumor / Umbral.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Mercado Dinámico / Estado / Umbrales / Alta demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estado / Umbrales / Alta demanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Mercado Dinámico / Estado / Umbrales / Buscado",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estado / Umbrales / Buscado.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Mercado Dinámico / Estado / Umbrales / Baja demanda",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estado / Umbrales / Baja demanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Mercado Dinámico / Estado / Umbrales / Saturado",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Estado / Umbrales / Saturado.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Mercado Dinámico / Objetivo / Suministro",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Objetivo / Suministro.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Mercado Dinámico / Tendencia / Oportunidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Oportunidad.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Mercado Dinámico / Tendencia / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Duración / Minutos.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Mercado Dinámico / Tendencia / Máximo / Intensidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Máximo / Intensidad.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Mercado Dinámico / Tendencia / Mínimo / Intensidad",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Tendencia / Mínimo / Intensidad.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Mercado Dinámico / Actualización / Minutos",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Actualización / Minutos.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Mercado Dinámico / Volatilidad / Máximo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Volatilidad / Máximo.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Mercado Dinámico / Volatilidad / Mínimo",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Volatilidad / Mínimo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Mercado Dinámico / Clima / Multiplicadores / Frío",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Multiplicadores / Frío.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Mercado Dinámico / Clima / Multiplicadores / Ola de calor",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Multiplicadores / Ola de calor.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Mercado Dinámico / Clima / Multiplicadores / Normal",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Multiplicadores / Normal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Mercado Dinámico / Clima / Multiplicadores / Lluvia",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Multiplicadores / Lluvia.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Mercado Dinámico / Clima / Multiplicadores / Tormenta",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Multiplicadores / Tormenta.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Mercado Dinámico / Clima / Estado",
                    description = "Parámetro de funcionamiento para Mercado Dinámico / Clima / Estado.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Sospecha y riesgo / Enfriamiento de acción / segundos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Enfriamiento de acción / segundos.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Cantidad",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Cantidad.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Duración / Minutos.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Presión policial",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Presión policial.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Reputación",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Reputación.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Seguridad",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Actividad / Riesgo / Ponderaciones / Seguridad.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Sospecha y riesgo / Modo agresivo / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Modo agresivo / Presión policial / Multiplicador.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Sospecha y riesgo / Teléfono desechable / Exposición / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Exposición / Umbral.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Sospecha y riesgo / Teléfono desechable / Presión policial / Por venta mayorista",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Presión policial / Por venta mayorista.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Sospecha y riesgo / Teléfono desechable / Objeto",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Teléfono desechable / Objeto.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Multiplicador.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana en funcionamiento / Presión policial / Umbral.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Sospecha y riesgo / Autocaravana aparcada / Presión policial",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Autocaravana aparcada / Presión policial.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Sospecha y riesgo / Contaminación / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Contaminación / Presión policial / Multiplicador.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Sospecha y riesgo / Contaminación / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Contaminación / Umbral.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Sospecha y riesgo / Cultivo / Plantas sin riesgo adicional",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Cultivo / Plantas sin riesgo adicional.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Sospecha y riesgo / Cultivo / Presión policial / Por planta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Cultivo / Presión policial / Por planta.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Sospecha y riesgo / Distribuidor / oculto / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Distribuidor / oculto / Minutos.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Lote",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Lote.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Autocaravana",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Autocaravana.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Distribuidor",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Distribuidor.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Facción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Facción.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Centro de distribución",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Centro de distribución.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Laboratorio",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Laboratorio.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Jugador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Jugador.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Ruta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Ruta.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Zona",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Decaimiento / Por ciclo de actualización / Zona.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Sospecha y riesgo / Activado",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Activado.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Sospecha y riesgo / Presencia policial / Presión policial / Crítico",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Presión policial / Crítico.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Sospecha y riesgo / Presencia policial / Presión policial / Alto",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Presión policial / Alto.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Sospecha y riesgo / Presencia policial / Presión policial / Bajo",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Presión policial / Bajo.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Sospecha y riesgo / Presencia policial / Presión policial / Mediano",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Presión policial / Mediano.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Sospecha y riesgo / Presencia policial / Multiplicadores / Lote",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Multiplicadores / Lote.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Sospecha y riesgo / Presencia policial / Multiplicadores / Facción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Multiplicadores / Facción.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Sospecha y riesgo / Presencia policial / Multiplicadores / Zona",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Presencia policial / Multiplicadores / Zona.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Lote",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Lote.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Autocaravana",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Autocaravana.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Distribuidor",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Distribuidor.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Facción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Facción.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Centro de distribución",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Centro de distribución.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Laboratorio",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Laboratorio.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Jugador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Jugador.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Ruta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Ruta.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Sospecha y riesgo / Entidad / Tipos / Zona",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Entidad / Tipos / Zona.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Sospecha y riesgo / Evento / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Evento / Minutos de enfriamiento.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Sospecha y riesgo / Evento / Límite del historial",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Evento / Límite del historial.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Sospecha y riesgo / Laboratorio / Presión policial / Sincronización / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Laboratorio / Presión policial / Sincronización / Umbral.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Sospecha y riesgo / Pasar desapercibido / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Minutos de enfriamiento.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Sospecha y riesgo / Pasar desapercibido / Inactivo / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Inactivo / Minutos.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Sospecha y riesgo / Pasar desapercibido / Reducción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Pasar desapercibido / Reducción.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Sospecha y riesgo / Bloqueo / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Bloqueo / Minutos.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Sospecha y riesgo / Mínimo / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Duración / Minutos.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Sospecha y riesgo / Mínimo / Evento / Enfriamiento (segundos)",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Evento / Enfriamiento (segundos).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Sospecha y riesgo / Mínimo / Inactivo / segundos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Mínimo / Inactivo / segundos.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Sospecha y riesgo / Procesamiento / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Procesamiento / Presión policial / Multiplicador.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Lote",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Lote.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Autocaravana",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Autocaravana.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Distribuidor",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Distribuidor.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Facción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Facción.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Centro de distribución",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Centro de distribución.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Laboratorio",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Laboratorio.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Jugador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Jugador.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Ruta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Ruta.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Sospecha y riesgo / Riesgo / Ponderaciones / Zona",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Riesgo / Ponderaciones / Zona.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Sospecha y riesgo / Cambiar teléfono desechable / Reducción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Cambiar teléfono desechable / Reducción.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Sospecha y riesgo / Ruta / Control / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Ruta / Control / Minutos.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Lote",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Lote.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Autocaravana",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Autocaravana.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Distribuidor",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Distribuidor.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Facción",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Facción.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Centro de distribución",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Centro de distribución.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Laboratorio",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Laboratorio.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Jugador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Jugador.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Ruta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Ruta.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Sospecha y riesgo / Venta / Presión policial / Zona",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Venta / Presión policial / Zona.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Sospecha y riesgo / Umbrales / Crítico",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Umbrales / Crítico.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Sospecha y riesgo / Umbrales / Alto",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Umbrales / Alto.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Sospecha y riesgo / Umbrales / Bloqueo",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Umbrales / Bloqueo.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Sospecha y riesgo / Umbrales / Bajo",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Umbrales / Bajo.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Sospecha y riesgo / Umbrales / Mediano",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Umbrales / Mediano.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Sospecha y riesgo / Ciclo de actualización / Minutos",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Ciclo de actualización / Minutos.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Sospecha y riesgo / Mayorista / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Mayorista / Presión policial / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Radio de alerta",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Radio de alerta.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Valor base / Oportunidad",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Valor base / Oportunidad.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Facción / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Facción / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Alto / Gravedad / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Alto / Gravedad / Umbral.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Lealtad / Oportunidad / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Lealtad / Oportunidad / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Lealtad / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Lealtad / Umbral.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Máximo / Oportunidad",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Máximo / Oportunidad.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Mínimo / Enfriamiento (segundos)",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Mínimo / Enfriamiento (segundos).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Ruta / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Ruta / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Intensidad / Máximo",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Máximo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Intensidad / Mínimo",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Mínimo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Intensidad / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Intensidad / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Estrés / Oportunidad / Multiplicador",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Estrés / Oportunidad / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Sospecha y riesgo / Trabajador / Filtración / Estrés / Umbral",
                    description = "Parámetro de funcionamiento para Sospecha y riesgo / Trabajador / Filtración / Estrés / Umbral.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Red de contactos / Enfriamiento de acción / segundos",
                    description = "Parámetro de funcionamiento para Red de contactos / Enfriamiento de acción / segundos.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Red de contactos / Cantidad de puntos calientes activos",
                    description = "Parámetro de funcionamiento para Red de contactos / Cantidad de puntos calientes activos.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Red de contactos / Pista de burner / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Pista de burner / Confianza.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Red de contactos / Teléfono desechable / Oferta / Máximo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Teléfono desechable / Oferta / Máximo / Multiplicador.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Red de contactos / Teléfono desechable / Oferta / Mínimo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Teléfono desechable / Oferta / Mínimo / Multiplicador.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Red de contactos / Comprador / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Minutos de enfriamiento.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Red de contactos / Comprador / Distancia de entrega",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Distancia de entrega.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Red de contactos / Comprador / Premium / Éxito / Puntuación",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Premium / Éxito / Puntuación.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Red de contactos / Comprador / Premium / Confianza / ganancia",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Premium / Confianza / ganancia.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Red de contactos / Comprador / Solicitud / Nivel de búsqueda y riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Solicitud / Nivel de búsqueda y riesgo / Peso.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Red de contactos / Comprador / Estándar / Confianza / ganancia",
                    description = "Parámetro de funcionamiento para Red de contactos / Comprador / Estándar / Confianza / ganancia.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Red de contactos / Espera para activar contacto / segundos / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Espera para activar contacto / segundos / Máximo.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Red de contactos / Espera para activar contacto / segundos / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Espera para activar contacto / segundos / Mínimo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Red de contactos / Contacto / Demanda / Rango de valores / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Contacto / Demanda / Rango de valores / Máximo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Red de contactos / Contacto / Demanda / Rango de valores / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Contacto / Demanda / Rango de valores / Mínimo.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Red de contactos / Contacto / Pérdida / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Contacto / Pérdida / Confianza.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Red de contactos / Red oscura / Información exacta / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Red oscura / Información exacta / Minutos.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Red de contactos / Red oscura / Zona activa / Información / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Red oscura / Zona activa / Información / Precio.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Red de contactos / Red oscura / Información / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Red oscura / Información / Precio.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Red de contactos / Distribuidor / Precio base",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Precio base.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Red de contactos / Distribuidor / Contratación / capacidad / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / capacidad / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Red de contactos / Distribuidor / Contratación / capacidad / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / capacidad / Mínimo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Red de contactos / Distribuidor / Contratación / Riesgo / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / Riesgo / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Red de contactos / Distribuidor / Contratación / Riesgo / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / Riesgo / Mínimo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Red de contactos / Distribuidor / Contratación / Habilidad / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / Habilidad / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Red de contactos / Distribuidor / Contratación / Habilidad / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Contratación / Habilidad / Mínimo.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Red de contactos / Ofertas de distribuidores / 1 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Red de contactos / Ofertas de distribuidores / 1 / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 1 / Objeto.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Red de contactos / Ofertas de distribuidores / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Red de contactos / Ofertas de distribuidores / 1 / Confianza mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 1 / Confianza mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Red de contactos / Ofertas de distribuidores / 1 / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 1 / Precio.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Red de contactos / Ofertas de distribuidores / 2 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Red de contactos / Ofertas de distribuidores / 2 / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 2 / Objeto.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Red de contactos / Ofertas de distribuidores / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Red de contactos / Ofertas de distribuidores / 2 / Confianza mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 2 / Confianza mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Red de contactos / Ofertas de distribuidores / 2 / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 2 / Precio.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Red de contactos / Ofertas de distribuidores / 3 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Red de contactos / Ofertas de distribuidores / 3 / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 3 / Objeto.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Red de contactos / Ofertas de distribuidores / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Red de contactos / Ofertas de distribuidores / 3 / Confianza mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 3 / Confianza mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Red de contactos / Ofertas de distribuidores / 3 / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 3 / Precio.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Red de contactos / Ofertas de distribuidores / 4 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Red de contactos / Ofertas de distribuidores / 4 / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 4 / Objeto.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Red de contactos / Ofertas de distribuidores / 4 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 4 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Red de contactos / Ofertas de distribuidores / 4 / Confianza mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 4 / Confianza mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Red de contactos / Ofertas de distribuidores / 4 / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 4 / Precio.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Red de contactos / Ofertas de distribuidores / 5 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Red de contactos / Ofertas de distribuidores / 5 / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 5 / Objeto.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Red de contactos / Ofertas de distribuidores / 5 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 5 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Red de contactos / Ofertas de distribuidores / 5 / Confianza mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 5 / Confianza mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Red de contactos / Ofertas de distribuidores / 5 / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ofertas de distribuidores / 5 / Precio.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Red de contactos / Distribuidor / Protección / Horas",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Protección / Horas.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Red de contactos / Distribuidor / Protección / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Protección / Precio.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Red de contactos / Distribuidor / Venta / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Venta / Máximo.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Red de contactos / Distribuidor / Venta / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Venta / Mínimo.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Red de contactos / Distribuidor / Simulación / Modo agresivo / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Modo agresivo / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Red de contactos / Distribuidor / Simulación / Calidad base / Factor de precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Calidad base / Factor de precio.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Red de contactos / Distribuidor / Simulación / Al por mayor / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Al por mayor / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Red de contactos / Distribuidor / Simulación / Ventas baratas / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Ventas baratas / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Red de contactos / Distribuidor / Simulación / Valor predeterminado / Calidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Valor predeterminado / Calidad.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Red de contactos / Distribuidor / Simulación / Umbral de deslealtad",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Umbral de deslealtad.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Red de contactos / Distribuidor / Simulación / Experiencia / Por nivel",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Experiencia / Por nivel.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Red de contactos / Distribuidor / Simulación / Experiencia / Por unidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Experiencia / Por unidad.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Red de contactos / Distribuidor / Simulación / Incidente / Lealtad / Pérdida",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Incidente / Lealtad / Pérdida.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Red de contactos / Distribuidor / Simulación / Incidente / Comprobación aleatoria / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Incidente / Comprobación aleatoria / Máximo.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Red de contactos / Distribuidor / Simulación / Nivel / Precio / Bonificación",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Nivel / Precio / Bonificación.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Red de contactos / Distribuidor / Simulación / Nivel / Venta / Divisor",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Nivel / Venta / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Red de contactos / Distribuidor / Simulación / Lealtad / Riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Lealtad / Riesgo / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Red de contactos / Distribuidor / Simulación / Máximo / Incidente / Oportunidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Máximo / Incidente / Oportunidad.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Red de contactos / Distribuidor / Simulación / Máximo / Nivel",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Máximo / Nivel.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Red de contactos / Distribuidor / Simulación / Premium / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Premium / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Red de contactos / Distribuidor / Simulación / Perfil / Riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Perfil / Riesgo / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Red de contactos / Distribuidor / Simulación / Protección / Riesgo / Reducción",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Protección / Riesgo / Reducción.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Red de contactos / Distribuidor / Simulación / Calidad / Precio / Divisor",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Calidad / Precio / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Red de contactos / Distribuidor / Simulación / Recuperación / Valor base / Oportunidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Recuperación / Valor base / Oportunidad.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Red de contactos / Distribuidor / Simulación / Recuperación / Lealtad / Peso",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Recuperación / Lealtad / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Red de contactos / Distribuidor / Simulación / Pérdida de stock por robo",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Pérdida de stock por robo.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Red de contactos / Distribuidor / Simulación / Habilidad / Riesgo / Reducción",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Habilidad / Riesgo / Reducción.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Red de contactos / Distribuidor / Simulación / Habilidad / Venta / Divisor",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Habilidad / Venta / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Red de contactos / Distribuidor / Simulación / Umbral de lealtad estable",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Umbral de lealtad estable.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Red de contactos / Distribuidor / Simulación / Territorio / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Territorio / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Red de contactos / Distribuidor / Simulación / Territorio / Riesgo / Reducción",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Simulación / Territorio / Riesgo / Reducción.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Red de contactos / Distribuidor / Ciclo de actualización / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Ciclo de actualización / Minutos.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Red de contactos / Distribuidor / Salario",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Red de contactos / Distribuidor / Salario / Decaimiento",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario / Decaimiento.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Red de contactos / Distribuidor / Salario / Lealtad / ganancia",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Salario / Lealtad / ganancia.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Red de contactos / Distribuidor / Debilidades / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Debilidades / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Red de contactos / Distribuidor / Debilidades / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Debilidades / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Red de contactos / Distribuidor / Debilidades / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Debilidades / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Red de contactos / Distribuidor / Debilidades / 4",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Debilidades / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Red de contactos / Distribuidor / Debilidades / 5",
                    description = "Parámetro de funcionamiento para Red de contactos / Distribuidor / Debilidades / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Red de contactos / Valor predeterminado / Contacto / Demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Contacto / Demanda.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Red de contactos / Valor predeterminado / Contacto / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Contacto / Riesgo.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Red de contactos / Traficante predeterminado / capacidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / capacidad.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Red de contactos / Traficante predeterminado / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / Riesgo.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Red de contactos / Traficante predeterminado / Habilidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Traficante predeterminado / Habilidad.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Red de contactos / Valor predeterminado / Zona activa / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Valor predeterminado / Zona activa / Radio.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Red de contactos / Reinicio de demanda (minutos)",
                    description = "Parámetro de funcionamiento para Red de contactos / Reinicio de demanda (minutos).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Red de contactos / Activado",
                    description = "Parámetro de funcionamiento para Red de contactos / Activado.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Red de contactos / Ubicación exacta / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación exacta / Confianza.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Red de contactos / Facción / Descubrimiento / Reputación",
                    description = "Parámetro de funcionamiento para Red de contactos / Facción / Descubrimiento / Reputación.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Red de contactos / Facción / Pista / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Facción / Pista / Confianza.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Red de contactos / Entrega fallida / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Red de contactos / Entrega fallida / Minutos de enfriamiento.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Red de contactos / Trato falso / Encuentro / Atacante / Cantidad",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Atacante / Cantidad.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Atacante / Modelos / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Red de contactos / Trato falso / Encuentro / Duración (segundos)",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Duración (segundos).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Red de contactos / Trato falso / Encuentro / Policía / Modelos / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Policía / Modelos / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Red de contactos / Trato falso / Encuentro / Policía / Modelos / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Policía / Modelos / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Red de contactos / Trato falso / Encuentro / Policía / Modelos / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Policía / Modelos / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Red de contactos / Trato falso / Encuentro / Radio de aparición",
                    description = "Parámetro de funcionamiento para Red de contactos / Trato falso / Encuentro / Radio de aparición.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Red de contactos / Valor alternativo / Droga Preferida",
                    description = "Parámetro de funcionamiento para Red de contactos / Valor alternativo / Droga Preferida.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Red de contactos / Valor alternativo / Etiqueta del producto",
                    description = "Parámetro de funcionamiento para Red de contactos / Valor alternativo / Etiqueta del producto.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Red de contactos / Guía / Libro / Objeto",
                    description = "Parámetro de funcionamiento para Red de contactos / Guía / Libro / Objeto.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Red de contactos / Guía / Libro / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Guía / Libro / Confianza.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Red de contactos / Contratar dealer / Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Contratar dealer / Precio.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Red de contactos / Límite del historial",
                    description = "Parámetro de funcionamiento para Red de contactos / Límite del historial.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Red de contactos / Zona activa / Información / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Zona activa / Información / Minutos.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Red de contactos / Zona activa / Rotación / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Zona activa / Rotación / Minutos.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Red de contactos / Anuncio / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Anuncio / Duración / Minutos.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Red de contactos / Máximo / Propiedad / Dealers",
                    description = "Parámetro de funcionamiento para Red de contactos / Máximo / Propiedad / Dealers.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Red de contactos / Mínimo / Comprador / Distancia de entrega",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Comprador / Distancia de entrega.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Red de contactos / Mínimo / Rotación de contactos (minutos)",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Rotación de contactos (minutos).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Red de contactos / Mínimo / Reinicio de demanda (minutos)",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Reinicio de demanda (minutos).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Red de contactos / Mínimo / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Red de contactos / Mínimo / Zona activa / Información / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Información / Minutos.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Red de contactos / Mínimo / Zona activa / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Radio.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Red de contactos / Mínimo / Zona activa / Rotación / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Zona activa / Rotación / Minutos.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Red de contactos / Mínimo / Anuncio / Duración / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Anuncio / Duración / Minutos.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Red de contactos / Recompensa mínima / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Recompensa mínima / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Red de contactos / Mínimo / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Red de contactos / Mínimo / Ubicación / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Mínimo / Ubicación / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Red de contactos / Otros / Droga / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Otros / Droga / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Red de contactos / Cuenta de pago",
                    description = "Parámetro de funcionamiento para Red de contactos / Cuenta de pago.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Red de contactos / Después de la entrega / Demanda / Reset / segundos",
                    description = "Parámetro de funcionamiento para Red de contactos / Después de la entrega / Demanda / Reset / segundos.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Red de contactos / Droga Preferida / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Droga Preferida / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Red de contactos / Región / Ubicación / Confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Región / Ubicación / Confianza.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Red de contactos / Solicitud / Cantidades / Al por mayor / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Al por mayor / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Red de contactos / Solicitud / Cantidades / Al por mayor / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Al por mayor / Mínimo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Red de contactos / Solicitud / Cantidades / Premium / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Premium / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Red de contactos / Solicitud / Cantidades / Premium / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Premium / Mínimo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Red de contactos / Solicitud / Cantidades / Estándar / Máximo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Estándar / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Red de contactos / Solicitud / Cantidades / Estándar / Mínimo",
                    description = "Parámetro de funcionamiento para Red de contactos / Solicitud / Cantidades / Estándar / Mínimo.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Red de contactos / Rotación / Minutos",
                    description = "Parámetro de funcionamiento para Red de contactos / Rotación / Minutos.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante callejero / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Comprador predeterminado / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante predeterminado / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Traficante de la red / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Intermediario prémium / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 1 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 2 / Riesgo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / W",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Región.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de contactos / Ubicación / Conjuntos de selección / Contacto mayorista / 3 / Riesgo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Bonificación de aceptación",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Bonificación de aceptación.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Arquetipo",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Arquetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Bono de demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Bono de demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 4",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Drogas preferidas / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Radio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Región.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 1 / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 1 / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Bonificación de aceptación",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Bonificación de aceptación.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Arquetipo",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Arquetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Bono de demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Bono de demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Calidad mínima",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Calidad mínima.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Drogas preferidas / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Drogas preferidas / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Radio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Región.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 2 / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 2 / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Bonificación de aceptación",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Bonificación de aceptación.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Arquetipo",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Arquetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Bono de demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Bono de demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Radio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Región.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 3 / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 3 / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Bonificación de aceptación",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Bonificación de aceptación.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Arquetipo",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Arquetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Bono de demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Bono de demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 3",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Radio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Región.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 4 / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 4 / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Bonificación de aceptación",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Bonificación de aceptación.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Arquetipo",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Arquetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Bono de demanda",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Bono de demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Presión policial / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Presión policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / ID",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Drogas preferidas / 1",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Drogas preferidas / 2",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Multiplicador de Precio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Multiplicador de Precio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Radio",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Radio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Región",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Región.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Red de contactos / Calle / Zonas activas / 5 / Robo / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de contactos / Calle / Zonas activas / 5 / Robo / Multiplicador.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Red de contactos / Confianza / Niveles / Conocido",
                    description = "Parámetro de funcionamiento para Red de contactos / Confianza / Niveles / Conocido.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Red de contactos / Confianza / Niveles / Fiable",
                    description = "Parámetro de funcionamiento para Red de contactos / Confianza / Niveles / Fiable.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Red de contactos / Confianza / Niveles / De confianza",
                    description = "Parámetro de funcionamiento para Red de contactos / Confianza / Niveles / De confianza.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Red de negocios / Enfriamiento de acción / segundos",
                    description = "Parámetro de funcionamiento para Red de negocios / Enfriamiento de acción / segundos.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Red de negocios / Saldo / Valor base / Precio por unidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Valor base / Precio por unidad.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Red de negocios / Saldo / Calor de la red / Por traficante",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Calor de la red / Por traficante.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Red de negocios / Saldo / Calor de la red / Por centro de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Calor de la red / Por centro de distribución.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Red de negocios / Saldo / Calor de la red / Por ruta",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Calor de la red / Por ruta.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Red de negocios / Saldo / Calor de la red / Por empleado",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Calor de la red / Por empleado.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Red de negocios / Saldo / Fiabilidad / ganancia",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Fiabilidad / ganancia.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Red de negocios / Saldo / Fiabilidad / Pérdida",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Fiabilidad / Pérdida.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Red de negocios / Saldo / Ruta / Presión policial / Decaimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Saldo / Ruta / Presión policial / Decaimiento.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Red de negocios / Contratos / Categorías / banda / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / banda / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / banda / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Red de NPCs / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Red de NPCs / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Organización / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Organización / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Premium / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Premium / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Pusher / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Pusher / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Especial / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Especial / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Cantidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Cantidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Cantidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Cantidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Mínimo / Rango",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Mínimo / Rango.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Calidad / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Calidad / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Calidad / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Calidad / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Recompensa / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Recompensa / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Riesgo / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Riesgo / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Red de negocios / Contratos / Categorías / Mayorista / Riesgo / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Categorías / Mayorista / Riesgo / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Red de negocios / Contratos / Distancia de entrega",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Distancia de entrega.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Red de negocios / Contratos / Duración / Minutos / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Duración / Minutos / Máximo.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Red de negocios / Contratos / Duración / Minutos / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Duración / Minutos / Mínimo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Región",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Región.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Recompensa / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 1 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 1 / Riesgo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Región",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Región.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Recompensa / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 2 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 2 / Riesgo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Región",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Región.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Recompensa / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 3 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 3 / Riesgo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / X",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / Y",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / Z",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Región",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Región.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Recompensa / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Red de negocios / Contratos / Encuentro / Puntos / 4 / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Encuentro / Puntos / 4 / Riesgo.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Red de negocios / Contratos / Negociación / Anticipo / Opciones / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Anticipo / Opciones / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Red de negocios / Contratos / Negociación / Anticipo / Opciones / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Anticipo / Opciones / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Red de negocios / Contratos / Negociación / Anticipo / Opciones / 3",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Anticipo / Opciones / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Red de negocios / Contratos / Negociación / Cantidad / Margen de negociación / Porcentaje",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Cantidad / Margen de negociación / Porcentaje.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Red de negocios / Contratos / Negociación / Valor base / Aceptación",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Valor base / Aceptación.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Red de negocios / Contratos / Negociación / Fecha límite / Margen de negociación / Porcentaje",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Fecha límite / Margen de negociación / Porcentaje.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Red de negocios / Contratos / Negociación / Máximo / Rondas",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Máximo / Rondas.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Red de negocios / Contratos / Negociación / Calidad / Margen de negociación",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Calidad / Margen de negociación.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Red de negocios / Contratos / Negociación / Rechazo / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Rechazo / Minutos de enfriamiento.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Red de negocios / Contratos / Negociación / Ronda / Presión",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Negociación / Ronda / Presión.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Red de negocios / Contratos / Oferta / Cantidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Oferta / Cantidad.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Red de negocios / Contratos / Actualización / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Contratos / Actualización / Minutos.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Red de negocios / Valor predeterminado / Nombre del negocio",
                    description = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Nombre del negocio.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Red de negocios / Valor predeterminado / Rango / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Rango / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Red de negocios / Valor predeterminado / Personal / Estilo de trabajo",
                    description = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Personal / Estilo de trabajo.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Red de negocios / Valor predeterminado / Transporte",
                    description = "Parámetro de funcionamiento para Red de negocios / Valor predeterminado / Transporte.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Red de negocios / Activado",
                    description = "Parámetro de funcionamiento para Red de negocios / Activado.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Red de negocios / Centros de distribución / Centro de distribución / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Centro de distribución / capacidad.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Red de negocios / Centros de distribución / Centro de distribución / Precio de compra",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Centro de distribución / Precio de compra.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Red de negocios / Centros de distribución / Centro de distribución / Seguridad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Centro de distribución / Seguridad.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Red de negocios / Centros de distribución / Centro de distribución / Mantenimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Centro de distribución / Mantenimiento.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Red de negocios / Centros de distribución / Escondite / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Escondite / capacidad.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Red de negocios / Centros de distribución / Escondite / Precio de compra",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Escondite / Precio de compra.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Red de negocios / Centros de distribución / Escondite / Seguridad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Escondite / Seguridad.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Red de negocios / Centros de distribución / Escondite / Mantenimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Escondite / Mantenimiento.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Red de negocios / Centros de distribución / Almacén / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Almacén / capacidad.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Red de negocios / Centros de distribución / Almacén / Precio de compra",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Almacén / Precio de compra.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Red de negocios / Centros de distribución / Almacén / Seguridad",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Almacén / Seguridad.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Red de negocios / Centros de distribución / Almacén / Mantenimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Centros de distribución / Almacén / Mantenimiento.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Red de negocios / Límites / Contratos activos",
                    description = "Parámetro de funcionamiento para Red de negocios / Límites / Contratos activos.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Red de negocios / Límites / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Límites / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Red de negocios / Límites / Libro contable / Filas",
                    description = "Parámetro de funcionamiento para Red de negocios / Límites / Libro contable / Filas.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Red de negocios / Límites / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Límites / Rutas.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Red de negocios / Límites / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Límites / Personal.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Red de negocios / Pago / Cuenta",
                    description = "Parámetro de funcionamiento para Red de negocios / Pago / Cuenta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Red de negocios / Rangos / 1 / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Red de negocios / Rangos / 1 / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Red de negocios / Rangos / 1 / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Red de negocios / Rangos / 1 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Red de negocios / Rangos / 1 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Red de negocios / Rangos / 1 / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Rutas.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Red de negocios / Rangos / 1 / Puntuación",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Puntuación.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Red de negocios / Rangos / 1 / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 1 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Red de negocios / Rangos / 2 / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Red de negocios / Rangos / 2 / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Red de negocios / Rangos / 2 / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Red de negocios / Rangos / 2 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Red de negocios / Rangos / 2 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Red de negocios / Rangos / 2 / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Rutas.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Red de negocios / Rangos / 2 / Puntuación",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Puntuación.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Red de negocios / Rangos / 2 / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 2 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Red de negocios / Rangos / 3 / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Red de negocios / Rangos / 3 / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Red de negocios / Rangos / 3 / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Red de negocios / Rangos / 3 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Red de negocios / Rangos / 3 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Red de negocios / Rangos / 3 / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Rutas.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Red de negocios / Rangos / 3 / Puntuación",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Puntuación.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Red de negocios / Rangos / 3 / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 3 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Red de negocios / Rangos / 4 / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Red de negocios / Rangos / 4 / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Red de negocios / Rangos / 4 / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Red de negocios / Rangos / 4 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Red de negocios / Rangos / 4 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Red de negocios / Rangos / 4 / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Rutas.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Red de negocios / Rangos / 4 / Puntuación",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Puntuación.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Red de negocios / Rangos / 4 / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 4 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Red de negocios / Rangos / 5 / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Red de negocios / Rangos / 5 / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Red de negocios / Rangos / 5 / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Red de negocios / Rangos / 5 / ID",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Red de negocios / Rangos / 5 / Etiqueta",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Red de negocios / Rangos / 5 / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Rutas.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Red de negocios / Rangos / 5 / Puntuación",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Puntuación.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Red de negocios / Rangos / 5 / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Rangos / 5 / Personal.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Red de negocios / Período del informe / días",
                    description = "Parámetro de funcionamiento para Red de negocios / Período del informe / días.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Comprador",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Comprador.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Contrato",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Contrato.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Distribuidor",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Distribuidor.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / banda",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / banda.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Centro de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Centro de distribución.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Laboratorio",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Laboratorio.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Organización",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Organización.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Red de negocios / Ruta / Punto final / Tipos / Pusher",
                    description = "Parámetro de funcionamiento para Red de negocios / Ruta / Punto final / Tipos / Pusher.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Frecuencia / Minutos / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Frecuencia / Minutos / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Frecuencia / Minutos / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Frecuencia / Minutos / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Enfriamiento / Mínimo / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Enfriamiento / Mínimo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Fallo / Fiabilidad / Pérdida",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Fallo / Fiabilidad / Pérdida.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Mínimo / Frecuencia / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Mínimo / Frecuencia / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Mínimo / Encuentro / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Mínimo / Encuentro / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Red de negocios / Funcionamiento en juego / Penalización del contrato / Crecimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Penalización del contrato / Crecimiento.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Penalización del contrato / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Penalización del contrato / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Calidad / Fallo / Minutos de enfriamiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Calidad / Fallo / Minutos de enfriamiento.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Calidad / Precio / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Calidad / Precio / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Calidad / Precio / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Calidad / Precio / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Calidad / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Fiabilidad / Pérdida / Calidad / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Reputación / Calidad / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Reputación / Calidad / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Riesgo / Ponderaciones / Categoría",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Riesgo / Ponderaciones / Categoría.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Red de negocios / Funcionamiento en juego / Contrato / Riesgo / Ponderaciones / Encuentro",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Contrato / Riesgo / Ponderaciones / Encuentro.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Centro de distribución / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Centro de distribución / capacidad.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Centro de distribución / Seguridad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Centro de distribución / Seguridad.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Encuentro / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Encuentro / Riesgo.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Calidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Calidad.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Capacidad de ruta",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Capacidad de ruta.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Ruta / Intervalo / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Ruta / Intervalo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Red de negocios / Funcionamiento en juego / Valor predeterminado / Ruta / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor predeterminado / Ruta / Riesgo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Presión policial / Decaimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Presión policial / Decaimiento.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Carga / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Carga / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Asalto / Recuperación / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Asalto / Recuperación / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Costo / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Costo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Costo / Por nivel",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Costo / Por nivel.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Mejora",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Seguridad / Mejora.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Impago / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Impago / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Impago / Seguridad / Pérdida",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Impago / Seguridad / Pérdida.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Red de negocios / Funcionamiento en juego / Centro de distribución / Mantenimiento / Intervalo / Horas",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Centro de distribución / Mantenimiento / Intervalo / Horas.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Red de negocios / Funcionamiento en juego / Valor inicial / Fiabilidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Valor inicial / Fiabilidad.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Red de negocios / Funcionamiento en juego / Máximo / Nombre del negocio / Longitud",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Máximo / Nombre del negocio / Longitud.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Mínimo / Contrato / Entrega / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Mínimo / Contrato / Entrega / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Red de negocios / Funcionamiento en juego / Mínimo / Distancia de entrega",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Mínimo / Distancia de entrega.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Red de negocios / Funcionamiento en juego / Mínimo / Libro contable / Filas",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Mínimo / Libro contable / Filas.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Red de negocios / Funcionamiento en juego / Mínimo / Ruta / Intervalo / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Mínimo / Ruta / Intervalo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Anticipo / Costo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Anticipo / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Anticipo / Precio / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Anticipo / Precio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Costo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Margen de negociación / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Margen de negociación / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Cantidad / Riesgo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Oferta de contrapartida / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Oferta de contrapartida / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Fecha límite / Margen de negociación / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Fecha límite / Margen de negociación / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Máximo / Aceptación",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Máximo / Aceptación.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Mínimo / Aceptación",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Mínimo / Aceptación.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Calidad / Beneficio / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Calidad / Beneficio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Calidad / Costo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Calidad / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Calidad / Margen de negociación / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Calidad / Margen de negociación / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Calidad / Recompensa / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Calidad / Recompensa / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Fiabilidad / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Fiabilidad / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Reputación / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Reputación / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Recompensa solicitada / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Recompensa solicitada / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Recompensa solicitada / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Recompensa solicitada / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Costo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Recompensa / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Beneficio / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Beneficio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Riesgo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Negociación / Urgencia / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Otros / Fallo / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Otros / Fallo / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Presión personal / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Presión personal / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Policía / Fallo / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Policía / Fallo / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Valor base / unidades",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Valor base / unidades.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Al por mayor / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Al por mayor / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Ventas baratas / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Ventas baratas / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Experiencia / Por nivel",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Experiencia / Por nivel.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Experiencia / Por unidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Experiencia / Por unidad.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Centro de distribución / Presión policial / Por unidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Centro de distribución / Presión policial / Por unidad.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Premium / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Premium / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Habilidad / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Habilidad / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Red de negocios / Funcionamiento en juego / Pusher / Habilidad / ganancia",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Pusher / Habilidad / ganancia.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Duración / Valor base / segundos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Duración / Valor base / segundos.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Duración / Por unidad / segundos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Duración / Por unidad / segundos.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 3",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 4",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Fallo / Causas / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Fallo / Value / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Fallo / Value / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Presión policial / Cantidad / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Presión policial / Cantidad / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Reducción de búsqueda / Costo / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Reducción de búsqueda / Costo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Reducción de búsqueda / Costo / Por punto de sospecha",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Reducción de búsqueda / Costo / Por punto de sospecha.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Lealtad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Lealtad.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Runner / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Runner / Riesgo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Habilidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Riesgo / Ponderaciones / Habilidad.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Red de negocios / Funcionamiento en juego / Rotación de ruta / Reducción de búsqueda",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Rotación de ruta / Reducción de búsqueda.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Red de negocios / Funcionamiento en juego / Rotación de ruta / Riesgo / Reducción",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Rotación de ruta / Riesgo / Reducción.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Venta / Base de calidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Venta / Base de calidad.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Venta / Calidad / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Venta / Calidad / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Venta / Riesgo / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Venta / Riesgo / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Ruta / Inicio / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Ruta / Inicio / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Red de negocios / Funcionamiento en juego / Runner / Experiencia / Por nivel",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Runner / Experiencia / Por nivel.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Red de negocios / Funcionamiento en juego / Runner / Experiencia / Por unidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Runner / Experiencia / Por unidad.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Red de negocios / Funcionamiento en juego / Runner / Fallo / Lealtad / Pérdida",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Runner / Fallo / Lealtad / Pérdida.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Red de negocios / Funcionamiento en juego / Runner / Riesgo de fallo / ganancia",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Runner / Riesgo de fallo / ganancia.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Red de negocios / Funcionamiento en juego / Runner / Habilidad / ganancia",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Runner / Habilidad / ganancia.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Presión policial",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Presión policial.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Fiabilidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Fiabilidad.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Reputación",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Reputación.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Estructura",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Puntuación / Ponderaciones / Estructura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / capacidad / Valor base / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / capacidad / Valor base / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Lealtad / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Lealtad / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Lealtad / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Lealtad / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Riesgo / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Riesgo / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Riesgo / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Riesgo / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Habilidad / Máximo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Habilidad / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Contratación / Habilidad / Mínimo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Contratación / Habilidad / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Lealtad / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Lealtad / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Máximo / Oportunidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Máximo / Oportunidad.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 3",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 4",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Resultados / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Incidente / Riesgo / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Incidente / Riesgo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Lealtad / Decaimiento",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Lealtad / Decaimiento.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Máximo / Nivel",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Máximo / Nivel.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Pérdida de lealtad por captación",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Pérdida de lealtad por captación.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Protección / Costo / Valor base",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Protección / Costo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Protección / Horas",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Protección / Horas.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Protección / Incidente / Reducción",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Protección / Incidente / Reducción.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Protección / Riesgo / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Protección / Riesgo / Costo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Recuperación / Valor base / Oportunidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Recuperación / Valor base / Oportunidad.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Recuperación / Lealtad / Peso",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Recuperación / Lealtad / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Salario / Valor base / Multiplicador",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Salario / Valor base / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Salario / Lealtad / ganancia",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Salario / Lealtad / ganancia.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Salario / Habilidad / Divisor",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Salario / Habilidad / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 1",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 2",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 3",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 4",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 5",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Red de negocios / Funcionamiento en juego / Personal / Debilidades / 6",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Personal / Debilidades / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Contratos",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Contratos.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Dealers",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Dealers.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Centros de distribución",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Centros de distribución.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Rutas",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Rutas.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Personal",
                    description = "Parámetro de funcionamiento para Red de negocios / Funcionamiento en juego / Estructura / Ponderaciones / Personal.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Red de negocios / Organización / Permiso",
                    description = "Parámetro de funcionamiento para Red de negocios / Organización / Permiso.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Red de negocios / Personal / Pusher / Valor base / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Pusher / Valor base / capacidad.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Red de negocios / Personal / Pusher / Valor base / Salario",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Pusher / Valor base / Salario.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Red de negocios / Personal / Pusher / Comisión",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Pusher / Comisión.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Red de negocios / Personal / Pusher / Contratación / Precio",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Pusher / Contratación / Precio.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Red de negocios / Personal / Runner / Valor base / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Runner / Valor base / capacidad.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Red de negocios / Personal / Runner / Valor base / Salario",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Runner / Valor base / Salario.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Red de negocios / Personal / Runner / Comisión",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Runner / Comisión.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Red de negocios / Personal / Runner / Contratación / Precio",
                    description = "Parámetro de funcionamiento para Red de negocios / Personal / Runner / Contratación / Precio.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Red de negocios / Ciclo de actualización / Minutos",
                    description = "Parámetro de funcionamiento para Red de negocios / Ciclo de actualización / Minutos.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Red de negocios / Transportes / Avión / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Avión / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Red de negocios / Transportes / Avión / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Avión / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Red de negocios / Transportes / Avión / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Avión / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Red de negocios / Transportes / Avión / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Avión / Riesgo.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Red de negocios / Transportes / Barco / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Barco / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Red de negocios / Transportes / Barco / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Barco / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Red de negocios / Transportes / Barco / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Barco / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Red de negocios / Transportes / Barco / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Barco / Riesgo.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Red de negocios / Transportes / Coche / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Coche / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Red de negocios / Transportes / Coche / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Coche / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Red de negocios / Transportes / Coche / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Coche / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Red de negocios / Transportes / Coche / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Coche / Riesgo.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Red de negocios / Transportes / A pie / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / A pie / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Red de negocios / Transportes / A pie / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / A pie / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Red de negocios / Transportes / A pie / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / A pie / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Red de negocios / Transportes / A pie / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / A pie / Riesgo.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Red de negocios / Transportes / Camión / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Camión / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Red de negocios / Transportes / Camión / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Camión / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Red de negocios / Transportes / Camión / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Camión / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Red de negocios / Transportes / Camión / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Camión / Riesgo.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Red de negocios / Transportes / Furgoneta / capacidad",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Furgoneta / capacidad.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Red de negocios / Transportes / Furgoneta / Costo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Furgoneta / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Red de negocios / Transportes / Furgoneta / Multiplicador de duración",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Furgoneta / Multiplicador de duración.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Red de negocios / Transportes / Furgoneta / Riesgo",
                    description = "Parámetro de funcionamiento para Red de negocios / Transportes / Furgoneta / Riesgo.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Integración genérica",
                        custom = "Integración personalizada",
                        none = "Desactivado",
                    },
                },
                reputationRules = {
                    label = "Reglas de reputación",
                    description = "Configura reglas con nombre para acciones y objetivos opcionales. Solo las reglas activadas otorgan puntos.",
                },
            },
            territoryMap = {
                addPoint = "Agregar punto",
                clear = "Borrar",
                create = "Crear",
                custom = "Territorios personalizados",
                deletePoint = "Eliminar punto",
                eyebrow = "Editor de territorios",
                minimum = "Mínimo 3",
                pointCount = "{count} puntos",
                presets = "Distritos preestablecidos",
                shown = "Mostrar en el mapa",
                street = "Calle",
                supply = "Suministro",
                territories = "Territorios",
                type = "Tipo de territorio",
                undo = "Deshacer",
            },
            shopPositionTools = {
                currentPosition = "Usar posición actual",
                selectEntity = "Seleccionar entidad",
                selectEntityHint = "Apunta el láser a una caja registradora o a una caja fuerte. Enter: usar la posición y orientación del objeto resaltado. Retroceso: cancelar.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Niveles de cultivo",
                general = "Generales",
                runtime = "Acceso a acciones del juego",
                quality = "Calidad",
                packaging = "Embalaje",
                growing = "Cultivo",
                labs = "Laboratorios y autocaravanas",
                power = "Energía y equipamiento",
                workers = "Trabajadores",
                market = "Mercado y distribución",
                threats = "Redadas y sabotaje",
                pvpTakeovers = "Toma de laboratorios",
                consumption = "Consumo",
                processing = "Procesamiento",
                performance = "Rendimiento",
                dynamicMarket = "Mercado Dinámico",
                heat = "Sospecha y riesgo",
                contacts = "Red de contactos",
                business = "Red de negocios",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Generales" },
                cultivationCurve = { label = "Curva de niveles" },
                cultivationExperience = { label = "Recompensas de XP" },
                cultivationUnlocks = { label = "Desbloqueos por nivel" },
                creator = {
                    label = "Abrir editor",
                },
                creatorSettings = {
                    label = "Ajustes del editor",
                },
                interfaceHud = {
                    label = "Posiciones de la interfaz",
                },
                drugsGeneral = {
                    label = "Generales",
                },
                runtimeAccess = {
                    label = "Acceso y propiedad",
                },
                runtimePayouts = {
                    label = "Pagos",
                },
                runtimeDispatch = {
                    label = "Central y policía",
                },
                qualityWeights = {
                    label = "Calidad / Ponderaciones",
                },
                qualityTiers = {
                    label = "Calidad / Niveles de calidad",
                },
                packagingGeneral = {
                    label = "Generales",
                },
                growingGeneral = {
                    label = "Generales",
                },
                plantDefaults = {
                    label = "Planta / Valores predeterminados",
                },
                harvestWindow = {
                    label = "Cosecha / Ventana temporal",
                },
                labsGeneral = {
                    label = "Generales",
                },
                labRent = {
                    label = "Alquiler y ciclo de vida",
                },
                camperDefaults = {
                    label = "Autocaravana",
                },
                labUpgrades = {
                    label = "Mejoras",
                },
                labDefaults = {
                    label = "Laboratorio / Valores predeterminados",
                },
                powerGeneral = {
                    label = "Generales",
                },
                generators = {
                    label = "Generadores",
                },
                equipmentWear = {
                    label = "Equipamiento",
                },
                workersGeneral = {
                    label = "Generales",
                },
                marketGeneral = {
                    label = "Generales",
                },
                marketPrices = {
                    label = "Precios",
                },
                distribution = {
                    label = "Distribución",
                },
                threatsGeneral = {
                    label = "Generales",
                },
                threatHeat = {
                    label = "Presión policial",
                },
                threatChances = {
                    label = "Probabilidades",
                },
                pvpTakeoverRules = {
                    label = "Reglas de toma de control",
                },
                pvpTakeoverZones = {
                    label = "Zonas & Tiempos",
                },
                pvpTakeoverMethods = {
                    label = "Métodos de intrusión",
                },
                consumptionGeneral = {
                    label = "Generales",
                },
                consumerDecay = {
                    label = "Reducción de tolerancia y adicción",
                },
                consumerEffects = {
                    label = "Efectos y riesgos",
                },
                processingFlow = {
                    label = "Flujo de procesamiento",
                },
                processingGeneral = {
                    label = "Generales",
                },
                powerRuntime = {
                    label = "Funcionamiento en juego",
                },
                powerHeat = {
                    label = "Sospecha y huella eléctrica",
                },
                powerModes = {
                    label = "Gestión / Modos",
                },
                powerPriorities = {
                    label = "Carga / Prioridades",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inactivo / Control / Intervalo / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interacción / Inactivo / Intervalo de escaneo / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interacción / Aviso de interacción / Intervalo / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interacción / Intervalo de escaneo / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Mínimo / Intervalo de escaneo / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Calle / Ped / Activación / Distancia",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Calle / Ped / Inactivo / Intervalo de escaneo / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Calle / Ped / Intervalo de escaneo / ms",
                },
                performanceWorldCachePadding = {
                    label = "Mundo / Caché / Margen adicional",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Mundo / Caché / Actualización / Intervalo / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Mundo / Inactivo / Intervalo / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Enfriamiento de acción / segundos",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Acción / Límite del historial",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Cantidad / Saturación / Peso",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Valor base / Precisión de la información",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Valor predeterminado / Promedio / Calidad",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Valor predeterminado / Recurso / Elasticidad",
                },
                dynamicMarketDemandCenter = {
                    label = "Demanda / Valor central",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Demanda / Precio / Impacto",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Dirección / Umbral",
                },
                dynamicMarketEnabled = {
                    label = "Activado",
                },
                dynamicMarketEventChance = {
                    label = "Evento / Oportunidad",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Evento / Duración / Minutos",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Evento / Mínimo / Duración / Minutos",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Evento / Intensidad / Máximo",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Evento / Intensidad / Mínimo",
                },
                dynamicMarketEvents = {
                    label = "Eventos",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Información exacta / Reputación",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Información exacta / Confianza",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zona / Etiqueta",
                },
                dynamicMarketHistoryLimit = {
                    label = "Límite del historial",
                },
                dynamicMarketInitialDemand = {
                    label = "Valor inicial / Demanda",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Valor inicial / Multiplicador de Precio",
                },
                dynamicMarketIntelDemandError = {
                    label = "Información / Demanda / Error",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Información / Máximo / Precisión",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Información / Mínimo / Precisión",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Información / Policía / Error",
                },
                dynamicMarketIntelPriceError = {
                    label = "Información / Precio / Error",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Información / Precio / Máximo",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Información / Precio / Mínimo",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Información / Reputación / Peso",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Información / Recurso / Precio / Error",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Información / Saturación / Error",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Ventana de semilla de información / segundos",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Información / Estado / Precisión / Umbral",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Información / Estado / Error / Umbral",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Información / Suministro / Error",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Información / Confianza / Peso",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulación / Minutos de enfriamiento",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulación / Demanda / Variación",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulación / Duración / Minutos",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulación / Presión policial",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulación / Mínimo / Lote / Cantidad",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulación / Cuenta de pago",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulación / Precio",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulación / Zona / Presión policial / Multiplicador",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Máximo / Antigüedad de la información / Minutos",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Máximo / Multiplicador de Precio",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Mínimo / Antigüedad de la información / Minutos",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Mínimo / Métrica / Ventana temporal / Minutos",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Precio mínimo / Multiplicador",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Mínimo / Actualización / Minutos",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Policía / Demanda / Peso",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Policía / Precio / Impacto",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Mala calidad / Demanda / Penalización",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Mala calidad / Umbral",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Calidad prémium / Bono de demanda",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Calidad prémium / Umbral",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Producción / Suministro / Peso",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Producción / Ventana temporal / Minutos",
                },
                dynamicMarketQualityCenter = {
                    label = "Calidad / Valor central",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Calidad / Confianza / Impacto",
                },
                dynamicMarketQualityRange = {
                    label = "Calidad / Rango de valores",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Rareza / Bonificación / Máximo",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regional / Global / Peso",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regional / Local / Peso",
                },
                dynamicMarketResourceAliases = {
                    label = "Recurso / Alias",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Recurso / Dirección / Descenso / Umbral",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Recurso / Dirección / Aumento / Umbral",
                },
                dynamicMarketResources = {
                    label = "Recursos",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Ventas / Ventana temporal / Minutos",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Saturación / Demanda / Peso",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Saturación / Precio / Impacto",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Escasez / Demanda / Peso",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Escasez / Precio / Impacto",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Estación / Fin / Meses",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Estación / Multiplicadores",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Escasez / Rumor / Umbral",
                },
                dynamicMarketStatusThresholds = {
                    label = "Estado / Umbrales",
                },
                dynamicMarketTargetSupply = {
                    label = "Objetivo / Suministro",
                },
                dynamicMarketTrendChance = {
                    label = "Tendencia / Oportunidad",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Tendencia / Duración / Minutos",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Tendencia / Máximo / Intensidad",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Tendencia / Mínimo / Intensidad",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Actualización / Minutos",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatilidad / Máximo",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatilidad / Mínimo",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Clima / Multiplicadores",
                },
                dynamicMarketWeatherState = {
                    label = "Clima / Estado",
                },
                heatActionCooldownSeconds = {
                    label = "Enfriamiento de acción / segundos",
                },
                heatActivityRiskWeights = {
                    label = "Actividad / Riesgo / Ponderaciones",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Modo agresivo / Presión policial / Multiplicador",
                },
                heatBurnerBurnThreshold = {
                    label = "Teléfono desechable / Exposición / Umbral",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Teléfono desechable / Presión policial / Por venta mayorista",
                },
                heatBurnerPhoneItem = {
                    label = "Teléfono desechable / Objeto",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Autocaravana en funcionamiento / Presión policial / Multiplicador",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Autocaravana en funcionamiento / Presión policial / Umbral",
                },
                heatCamperParkedHeat = {
                    label = "Autocaravana aparcada / Presión policial",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Contaminación / Presión policial / Multiplicador",
                },
                heatContaminatedThreshold = {
                    label = "Contaminación / Umbral",
                },
                heatCultivationFreePlants = {
                    label = "Cultivo / Plantas sin riesgo adicional",
                },
                heatCultivationHeatPerPlant = {
                    label = "Cultivo / Presión policial / Por planta",
                },
                heatDealerHiddenMinutes = {
                    label = "Distribuidor / oculto / Minutos",
                },
                heatDecayPerTick = {
                    label = "Decaimiento / Por ciclo de actualización",
                },
                heatEnabled = {
                    label = "Activado",
                },
                heatEnforcementHeat = {
                    label = "Presencia policial / Presión policial",
                },
                heatEnforcementMultipliers = {
                    label = "Presencia policial / Multiplicadores",
                },
                heatEntityTypes = {
                    label = "Entidad / Tipos",
                },
                heatEventCooldownMinutes = {
                    label = "Evento / Minutos de enfriamiento",
                },
                heatEventHistoryLimit = {
                    label = "Evento / Límite del historial",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratorio / Presión policial / Sincronización / Umbral",
                },
                heatLayLowCooldownMinutes = {
                    label = "Pasar desapercibido / Minutos de enfriamiento",
                },
                heatLayLowIdleMinutes = {
                    label = "Pasar desapercibido / Inactivo / Minutos",
                },
                heatLayLowReduction = {
                    label = "Pasar desapercibido / Reducción",
                },
                heatLockdownMinutes = {
                    label = "Bloqueo / Minutos",
                },
                heatMinimumDurationMinutes = {
                    label = "Mínimo / Duración / Minutos",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Mínimo / Evento / Enfriamiento (segundos)",
                },
                heatMinimumIdleSeconds = {
                    label = "Mínimo / Inactivo / segundos",
                },
                heatProcessingHeatMultiplier = {
                    label = "Procesamiento / Presión policial / Multiplicador",
                },
                heatRiskWeights = {
                    label = "Riesgo / Ponderaciones",
                },
                heatRotateBurnerReduction = {
                    label = "Cambiar teléfono desechable / Reducción",
                },
                heatRouteControlMinutes = {
                    label = "Ruta / Control / Minutos",
                },
                heatSaleHeat = {
                    label = "Venta / Presión policial",
                },
                heatThresholds = {
                    label = "Umbrales",
                },
                heatTickMinutes = {
                    label = "Ciclo de actualización / Minutos",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Mayorista / Presión policial / Multiplicador",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Trabajador / Filtración / Radio de alerta",
                },
                heatWorkerLeakBaseChance = {
                    label = "Trabajador / Filtración / Valor base / Oportunidad",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Trabajador / Filtración / Facción / Multiplicador",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Trabajador / Filtración / Alto / Gravedad / Umbral",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Trabajador / Filtración / Lealtad / Oportunidad / Multiplicador",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Trabajador / Filtración / Lealtad / Umbral",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Trabajador / Filtración / Máximo / Oportunidad",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Trabajador / Filtración / Mínimo / Enfriamiento (segundos)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Trabajador / Filtración / Ruta / Multiplicador",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Trabajador / Filtración / Intensidad / Máximo",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Trabajador / Filtración / Intensidad / Mínimo",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Trabajador / Filtración / Intensidad / Multiplicador",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Trabajador / Filtración / Estrés / Oportunidad / Multiplicador",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Trabajador / Filtración / Estrés / Umbral",
                },
                contactsActionCooldownSeconds = {
                    label = "Enfriamiento de acción / segundos",
                },
                contactsActiveHotspotCount = {
                    label = "Cantidad de puntos calientes activos",
                },
                contactsBurnerHintTrust = {
                    label = "Pista de burner / Confianza",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Teléfono desechable / Oferta / Máximo / Multiplicador",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Teléfono desechable / Oferta / Mínimo / Multiplicador",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Comprador / Minutos de enfriamiento",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Comprador / Distancia de entrega",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Comprador / Premium / Éxito / Puntuación",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Comprador / Premium / Confianza / ganancia",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Comprador / Solicitud / Nivel de búsqueda y riesgo / Peso",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Comprador / Estándar / Confianza / ganancia",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Espera para activar contacto / segundos",
                },
                contactsContactDemandRange = {
                    label = "Contacto / Demanda / Rango de valores",
                },
                contactsContactLossTrust = {
                    label = "Contacto / Pérdida / Confianza",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Red oscura / Información exacta / Minutos",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Red oscura / Zona activa / Información / Precio",
                },
                contactsDarknetIntelPrice = {
                    label = "Red oscura / Información / Precio",
                },
                contactsDealerBasePrice = {
                    label = "Distribuidor / Precio base",
                },
                contactsDealerHireCapacity = {
                    label = "Distribuidor / Contratación / capacidad",
                },
                contactsDealerHireRisk = {
                    label = "Distribuidor / Contratación / Riesgo",
                },
                contactsDealerHireSkill = {
                    label = "Distribuidor / Contratación / Habilidad",
                },
                contactsDealerOffers = {
                    label = "Ofertas de distribuidores",
                },
                contactsDealerProtectionHours = {
                    label = "Distribuidor / Protección / Horas",
                },
                contactsDealerProtectionPrice = {
                    label = "Distribuidor / Protección / Precio",
                },
                contactsDealerSaleMax = {
                    label = "Distribuidor / Venta / Máximo",
                },
                contactsDealerSaleMin = {
                    label = "Distribuidor / Venta / Mínimo",
                },
                contactsDealerSimulation = {
                    label = "Distribuidor / Simulación",
                },
                contactsDealerTickMinutes = {
                    label = "Distribuidor / Ciclo de actualización / Minutos",
                },
                contactsDealerWage = {
                    label = "Distribuidor / Salario",
                },
                contactsDealerWageDecay = {
                    label = "Distribuidor / Salario / Decaimiento",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Distribuidor / Salario / Lealtad / ganancia",
                },
                contactsDealerWeaknesses = {
                    label = "Distribuidor / Debilidades",
                },
                contactsDefaultContactDemand = {
                    label = "Valor predeterminado / Contacto / Demanda",
                },
                contactsDefaultContactRisk = {
                    label = "Valor predeterminado / Contacto / Riesgo",
                },
                contactsDefaultDealerCapacity = {
                    label = "Traficante predeterminado / capacidad",
                },
                contactsDefaultDealerRisk = {
                    label = "Traficante predeterminado / Riesgo",
                },
                contactsDefaultDealerSkill = {
                    label = "Traficante predeterminado / Habilidad",
                },
                contactsDefaultHotspotRadius = {
                    label = "Valor predeterminado / Zona activa / Radio",
                },
                contactsDemandResetMinutes = {
                    label = "Reinicio de demanda (minutos)",
                },
                contactsEnabled = {
                    label = "Activado",
                },
                contactsExactLocationTrust = {
                    label = "Ubicación exacta / Confianza",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Facción / Descubrimiento / Reputación",
                },
                contactsFactionHintTrust = {
                    label = "Facción / Pista / Confianza",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Entrega fallida / Minutos de enfriamiento",
                },
                contactsFakeDealEncounter = {
                    label = "Trato falso / Encuentro",
                },
                contactsFallbackPreferredDrug = {
                    label = "Valor alternativo / Droga Preferida",
                },
                contactsFallbackProductLabel = {
                    label = "Valor alternativo / Etiqueta del producto",
                },
                contactsGuideBookItem = {
                    label = "Guía / Libro / Objeto",
                },
                contactsGuideBookTrust = {
                    label = "Guía / Libro / Confianza",
                },
                contactsHireDealerPrice = {
                    label = "Contratar dealer / Precio",
                },
                contactsHistoryLimit = {
                    label = "Límite del historial",
                },
                contactsHotspotIntelMinutes = {
                    label = "Zona activa / Información / Minutos",
                },
                contactsHotspotRotationMinutes = {
                    label = "Zona activa / Rotación / Minutos",
                },
                contactsListingDurationMinutes = {
                    label = "Anuncio / Duración / Minutos",
                },
                contactsMaxOwnedDealers = {
                    label = "Máximo / Propiedad / Dealers",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Mínimo / Comprador / Distancia de entrega",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Mínimo / Rotación de contactos (minutos)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Mínimo / Reinicio de demanda (minutos)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Mínimo / Presión policial / Multiplicador",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Mínimo / Zona activa / Información / Minutos",
                },
                contactsMinimumHotspotRadius = {
                    label = "Mínimo / Zona activa / Radio",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Mínimo / Zona activa / Rotación / Minutos",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Mínimo / Anuncio / Duración / Minutos",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Recompensa mínima / Multiplicador",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Mínimo / Robo / Multiplicador",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Mínimo / Ubicación / Multiplicador de Precio",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Otros / Droga / Multiplicador de Precio",
                },
                contactsPaymentAccount = {
                    label = "Cuenta de pago",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Después de la entrega / Demanda / Reset / segundos",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Droga Preferida / Multiplicador de Precio",
                },
                contactsRegionLocationTrust = {
                    label = "Región / Ubicación / Confianza",
                },
                contactsRequestAmounts = {
                    label = "Solicitud / Cantidades",
                },
                contactsRotationMinutes = {
                    label = "Rotación / Minutos",
                },
                contactsSpotPools = {
                    label = "Ubicación / Conjuntos de selección",
                },
                contactsStreetHotspots = {
                    label = "Calle / Zonas activas",
                },
                contactsTrustLevels = {
                    label = "Confianza / Niveles",
                },
                businessActionCooldownSeconds = {
                    label = "Enfriamiento de acción / segundos",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Contratos",
                },
                businessDefaultBusinessName = {
                    label = "Valor predeterminado / Nombre del negocio",
                },
                businessDefaultRankId = {
                    label = "Valor predeterminado / Rango / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Valor predeterminado / Personal / Estilo de trabajo",
                },
                businessDefaultTransport = {
                    label = "Valor predeterminado / Transporte",
                },
                businessEnabled = {
                    label = "Activado",
                },
                businessHubs = {
                    label = "Centros de distribución",
                },
                businessLimits = {
                    label = "Límites",
                },
                businessPayments = {
                    label = "Pagos",
                },
                businessPayoutAccount = {
                    label = "Pago / Cuenta",
                },
                businessRanks = {
                    label = "Rangos",
                },
                businessReportDays = {
                    label = "Período del informe / días",
                },
                businessRouteEndpointTypes = {
                    label = "Ruta / Punto final / Tipos",
                },
                businessRuntime = {
                    label = "Funcionamiento en juego",
                },
                businessSocietyPermission = {
                    label = "Organización / Permiso",
                },
                businessStaff = {
                    label = "Personal",
                },
                businessTickMinutes = {
                    label = "Ciclo de actualización / Minutos",
                },
                businessTransports = {
                    label = "Transportes",
                },
            },
            territorySettings = {
                section = "Territorios",
                zonesGroup = "Zonas de territorio",
                sourceLabel = "Fuente de la zona",
                sourceDescription = "Usa los distritos preestablecidos protegidos o define tus propios polígonos de territorio.",
                sourcePreset = "Distritos preestablecidos",
                sourceCustom = "Territorios personalizados",
                editLabel = "Editor de territorio",
                editDescription = "Edita los distritos utilizados por la fuente de zona seleccionada.",
                editButton = "Editar territorios",
                presetSection = "Distritos preestablecidos",
                presetEntry = "Distrito preestablecido",
                customSection = "Territorios personalizados",
                customEntry = "Territorio personalizado",
                typeLabel = "Tipo de territorio",
                streetType = "Calle",
                supplyType = "Suministro",
                enabledLabel = "Mostrar en el mapa",
                enabledDescription = "Los distritos preestablecidos desactivados se eliminan del mapa y no pueden ser reclamados.",
                zoneLabel = "Límite del territorio",
                zoneDescription = "Añade al menos tres puntos en orden alrededor del límite del territorio.",
                ownershipGroup = "Propiedad",
                decayGroup = "Decaimiento",
                presenceGroup = "Presencia",
                activityGroup = "Puntuación de actividad",
                ownershipBenefitsGroup = "Beneficios de propiedad",
                ownershipThresholdLabel = "Umbral de propiedad",
                ownershipThresholdDescription = "Porcentaje de control que una banda debe superar para poseer oficialmente un territorio.",
                activityFloorLabel = "Mínimo de actividad fijo",
                activityFloorDescription = "Puntos de influencia requeridos cuando los mínimos basados en tamaño están desactivados.",
                floorByZoneSizeLabel = "Escalar mínimo por tamaño de zona",
                floorByZoneSizeDescription = "Calcula el mínimo de actividad de cada territorio según el área de su polígono en lugar de usar el mínimo fijo.",
                floorPointsPerSizeUnitLabel = "Puntos de mínimo por km²",
                floorPointsPerSizeUnitDescription = "Puntos de mínimo de actividad requeridos por cada kilómetro cuadrado de área de territorio.",
                fixedFloorRequirement = "Desactiva los mínimos basados en tamaño para editar el mínimo de actividad fijo.",
                sizeFloorRequirement = "Activa los mínimos basados en tamaño para editar los puntos por kilómetro cuadrado.",
                dailyDecayLabel = "Decaimiento de influencia diario",
                dailyDecayDescription = "Porcentaje de influencia eliminado cada 24 horas.",
                presenceIntervalLabel = "Intervalo de presencia",
                presenceIntervalDescription = "Minutos entre las recompensas automáticas de presencia en el territorio.",
                presencePointsLabel = "Puntos de presencia por miembro",
                presencePointsDescription = "Puntos de presencia otorgados a cada miembro elegible de la banda por intervalo.",
                drugSalesEnabledLabel = "Las ventas de NPCs otorgan influencia de territorio",
                drugSalesEnabledDescription = "Las ventas callejeras exitosas a NPCs otorgan influencia a la banda del vendedor en el territorio de calle actual.",
                drugSalePointsLabel = "Puntos por droga vendida",
                drugSalePointsDescription = "Puntos de influencia otorgados por cada unidad de droga reportada como vendida.",
                drugSalesRequirement = "Activa la influencia por ventas de NPC para configurar sus puntos.",
                graffitiPointsLabel = "Puntos de graffiti por 24 horas",
                graffitiPointsDescription = "Puntos de presencia otorgados cuando un graffiti ha existido durante un total de 24 horas reportadas.",
                streetSellingPriceBonusLabel = "Bono de precio de venta callejera",
                streetSellingPriceBonusDescription = "Porcentaje añadido a los precios de venta de drogas para el dueño oficial de un territorio de calle.",
                supplyProductionSpeedBonusLabel = "Bono de velocidad de producción de suministros",
                supplyProductionSpeedBonusDescription = "Porcentaje añadido a la velocidad de producción de drogas para el dueño oficial de un territorio de suministros.",
                pruneToleranceLabel = "Tolerancia de poda de influencia",
                pruneToleranceDescription = "La influencia efectiva por debajo de este valor se trata como cero.",
            },
            graffitiSettings = {
                section = "Grafiti",
                generalGroup = "Generales",
                streamingGroup = "Renderizado",
                moderationGroup = "Moderación",
                graffitiEnabledLabel = "Activar graffiti",
                graffitiEnabledDescription = "Permite a los jugadores pintar y ver graffitis.",
                graffitiRequireItemLabel = "Requiere spray",
                graffitiRequireItemDescription = "Los jugadores necesitan un objeto de spray para pintar. De lo contrario, se usará el comando /graffiti.",
                graffitiChargesPerCanLabel = "Cargas por bote",
                graffitiChargesPerCanDescription = "Cuántos graffitis se pueden crear con un solo bote de spray.",
                graffitiCooldownSecondsLabel = "Enfriamiento de spray",
                graffitiCooldownSecondsDescription = "Segundos que un jugador debe esperar entre graffitis.",
                graffitiMaxPerPlayerLabel = "Máx. graffitis por jugador",
                graffitiMaxPerPlayerDescription = "Máximo de graffitis activos que un jugador puede tener. 0 significa ilimitado.",
                graffitiMaxDistanceLabel = "Distancia máx. de spray",
                graffitiMaxDistanceDescription = "A qué distancia puede estar una pared para poder pintarla, en metros.",
                graffitiSprayDurationLabel = "Duración del spray",
                graffitiSprayDurationDescription = "Cuánto dura la animación de spray, en milisegundos.",
                graffitiExpiryDaysLabel = "Tiempo de caducidad",
                graffitiExpiryDaysDescription = "Días hasta que un graffiti desaparece automáticamente. 0 significa nunca.",
                graffitiTerritoryHoursLabel = "Horas de territorio por spray",
                graffitiTerritoryHoursDescription = "Horas de presencia en el territorio que un graffiti nuevo otorga a su banda.",
                graffitiStreamRadiusLabel = "Radio de streaming",
                graffitiStreamRadiusDescription = "Distancia en metros a la que los graffitis se vuelven visibles para los jugadores.",
                graffitiPoolSizeLabel = "Tamaño del pool de decals",
                graffitiPoolSizeDescription = "Cuántos graffitis se renderizan a la vez. Valores más altos consumen más rendimiento.",
                graffitiReportsEnabledLabel = "Activar reportes",
                graffitiReportsEnabledDescription = "Permite a los jugadores reportar graffitis ofensivos.",
                graffitiAutoHideThresholdLabel = "Umbral de ocultación automática",
                graffitiAutoHideThresholdDescription = "Número de reportes que ocultan automáticamente un graffiti. 0 desactiva esto.",
            },
            darknetSettings = {
                section = "Mercado Darknet",
                availabilityGroup = "Disponibilidad",
                economyGroup = "Criptomoneda",
                listingsGroup = "Ofertas y caducidad",
                chatGroup = "Chat privado",
                identityGroup = "Alias y reputación",
                deliveryGroup = "Entregas y dead drops",
                policeGroup = "Acceso policial",
                npcGroup = "Comerciantes NPC",
                enabledLabel = "Activar Mercado Darknet",
                enabledDescription = "Habilita la aplicación de la tablet del mercado negro y su lógica de ejecución.",
                tabletOrderLabel = "Orden de la app de la tablet",
                tabletOrderDescription = "Controla la posición del Mercado Darknet en la tablet.",
                currencyCodeLabel = "Código de moneda",
                currencyCodeDescription = "Etiqueta corta mostrada para el libro contable interno de criptomonedas.",
                starterBalanceLabel = "Saldo inicial de la billetera",
                starterBalanceDescription = "Cripto asignada solo cuando un jugador abre el mercado por primera vez.",
                exchangeEnabledLabel = "Activar intercambio de monedas",
                exchangeEnabledDescription = "Permite a los usuarios autenticados de BlackBay comprar y vender monedas en su página de cuenta.",
                exchangeAccountLabel = "Cuenta de pago de intercambio",
                exchangeAccountDescription = "Cuenta del framework utilizada para compras de monedas y pagos de ventas.",
                exchangeBuyPriceLabel = "Precio de compra por moneda",
                exchangeBuyPriceDescription = "Monto cobrado de la cuenta de pago por cada moneda.",
                exchangeSellPriceLabel = "Precio de venta por moneda",
                exchangeSellPriceDescription = "Monto pagado a la cuenta de pago por cada moneda.",
                exchangeMinimumLabel = "Mínimo de monedas por intercambio",
                exchangeMinimumDescription = "Cantidad mínima de monedas enteras aceptada en un intercambio.",
                exchangeMaximumLabel = "Máximo de monedas por intercambio",
                exchangeMaximumDescription = "Cantidad máxima de monedas enteras aceptada en un intercambio.",
                accountMoney = "Efectivo",
                accountBank = "Banco",
                accountBlackMoney = "Dinero sucio",
                scamChanceLabel = "Probabilidad global de estafa de NPC (%)",
                scamChanceDescription = "Probabilidad mínima de que un comerciante NPC tome el pago o la mercancía sin entregar la contrapartida. Se aplicará una probabilidad mayor específica del comerciante.",
                listingExpiryLabel = "Duración de la oferta (horas)",
                listingExpiryDescription = "Las ofertas activas caducan automáticamente después de este número de horas.",
                renewalHoursLabel = "Duración de la renovación (horas)",
                renewalHoursDescription = "Horas añadidas cuando un propietario renueva una oferta.",
                maximumListingsLabel = "Máximo de ofertas activas",
                maximumListingsDescription = "Máximo de ofertas por alias activo.",
                maximumQuantityLabel = "Cantidad máxima de mercancía",
                maximumQuantityDescription = "Límite superior de cantidad para una oferta.",
                maximumPriceLabel = "Precio máximo por unidad",
                maximumPriceDescription = "Precio máximo de cripto por una sola unidad.",
                maximumMessageLengthLabel = "Longitud máxima del mensaje",
                maximumMessageLengthDescription = "Número máximo de caracteres por mensaje de chat encriptado.",
                aliasCooldownLabel = "Tiempo de espera para cambio de alias (horas)",
                aliasCooldownDescription = "Antigüedad mínima de una identidad antes de que pueda ser retirada de nuevo.",
                verifiedSalesLabel = "Ventas requeridas para verificación",
                verifiedSalesDescription = "Ventas exitosas requeridas antes de que un vendedor pueda ser verificado.",
                verifiedRatingLabel = "Calificación requerida para verificación",
                verifiedRatingDescription = "Calificación media mínima para un vendedor verificado.",
                scammerReportsLabel = "Reportes para advertencia de estafador",
                scammerReportsDescription = "Reportes de transacciones únicos requeridos para la insignia de estafador conocido.",
                meetingDistanceLabel = "Distancia de entrega",
                meetingDistanceDescription = "Distancia máxima entre ambos jugadores o con el punto NPC configurado.",
                dropModelLabel = "Modelo de caja de entrega muerta",
                dropModelDescription = "Modelo de objeto de GTA generado localmente para los dead drops disponibles.",
                dropStreamLabel = "Distancia de streaming de dead drop",
                dropStreamDescription = "Distancia a la que se cargan las cajas y los contactos de reuniones NPC.",
                dropInteractionLabel = "Distancia de interacción de dead drop",
                dropInteractionDescription = "Distancia requerida para buscar y reclamar una caja.",
                dropLifetimeLabel = "Duración del dead drop (horas)",
                dropLifetimeDescription = "Tiempo antes de que una caja no reclamada expire.",
                dropPollLabel = "Intervalo de actualización del mundo (ms)",
                dropPollDescription = "Intervalo utilizado para actualizar las cajas cercanas y las reuniones NPC.",
                policeGroupsLabel = "Grupos de trabajos policiales autorizados",
                policeGroupsDescription = "Claves de grupo del configurador de trabajos que pueden publicar ofertas señuelo y ver investigaciones.",
                policeGroupEntry = "Grupo policial",
                groupKeyLabel = "Clave de grupo",
                npcTradersLabel = "Compradores y vendedores NPC",
                npcTradersDescription = "Configura ofertas sintéticas persistentes, método de entrega, reputación y probabilidad de estafa.",
                npcTraderEntry = "Comerciante NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Lado del mercado",
                sideSell = "Vende a jugadores",
                sideBuy = "Compra a jugadores",
                npcTitleLabel = "Título de la oferta",
                npcDescriptionLabel = "Descripción",
                npcItemNameLabel = "Nombre del objeto del inventario",
                npcItemLabelLabel = "Etiqueta de mercancía",
                npcQuantityLabel = "Cantidad",
                npcPriceLabel = "Precio por unidad",
                npcDeliveryLabel = "Método de entrega",
                deliveryBoth = "Encuentro y dead drop",
                deliveryMeeting = "Solo cara a cara",
                deliveryDrop = "Solo dead drop",
                npcScamChanceLabel = "Probabilidad de estafa del comerciante (%)",
                npcPedModelLabel = "Modelo de ped NPC",
                npcRatingLabel = "Calificación mostrada",
                npcRatingCountLabel = "Cantidad de calificaciones mostradas",
                npcTradesLabel = "Comercios exitosos mostrados",
                npcVerifiedLabel = "Comerciante verificado",
                npcScammerLabel = "Estafador conocido",
                npcEnabledLabel = "Activado",
            },
            interrogationSettings = {
                section = "Interrogatorio",
                generalGroup = "Generales",
                consentGroup = "Protección de jugadores",
                objectGroup = "Objetos",
                grabGroup = "Sujeción",
                sessionGroup = "Sesión",
                dispatchGroup = "Alertas policiales",
                loggingGroup = "Registro de actividad",
                securityGroup = "Seguridad",
                presentationGroup = "Presentación",
                enabledLabel = "Activar interrogatorio",
                enabledDescription = "Permite a los jugadores atar a otros en sillas de interrogatorio y usar herramientas con ellos.",
                consentRequiredLabel = "Requerir consentimiento",
                consentRequiredDescription = "Solo los jugadores que hayan dado su consentimiento pueden convertirse en víctimas. Ya no existe una función de consentimiento general, por lo que se requiere la configuración de abajo.",
                consentDefaultLabel = "Consentimiento por defecto",
                consentDefaultDescription = "Los nuevos personajes comienzan con el consentimiento otorgado en lugar de denegado.",
                globalIntensityLabel = "Intensidad del efecto",
                globalIntensityDescription = "Escala los efectos de pantalla, partículas y sonido. 0 los desactiva por completo.",
                maxPerPlayerLabel = "Objetos por jugador",
                maxPerPlayerDescription = "Cuántas sillas y carros puede colocar un jugador. 0 significa ilimitado.",
                maxGlobalLabel = "Objetos en todo el servidor",
                maxGlobalDescription = "Total de objetos colocados permitidos a la vez. 0 significa ilimitado.",
                placementDistanceLabel = "Distancia de colocación",
                placementDistanceDescription = "Qué tan lejos del jugador se puede colocar un objeto, en metros.",
                interactDistanceLabel = "Distancia de interacción",
                interactDistanceDescription = "Qué tan cerca debe estar un jugador para usar una silla o un carro, en metros.",
                inactivityMinutesLabel = "Eliminación automática tras",
                inactivityMinutesDescription = "Minutos de inactividad antes de que un objeto colocado desaparezca. 0 lo mantiene para siempre.",
                persistObjectsLabel = "Mantener objetos tras reinicio",
                persistObjectsDescription = "Los objetos colocados se restauran desde la base de datos cuando el servidor vuelve a estar en línea.",
                grabEnabledLabel = "Activar forcejeo",
                grabEnabledDescription = "Permite a los jugadores someter y cargar a otro jugador.",
                grabItemLabel = "Objeto requerido",
                grabItemDescription = "Objeto que el atacante necesita para sujetar a alguien. Deja vacío para que no se requiera ninguno.",
                grabAngleLabel = "Ángulo de aproximación",
                grabAngleDescription = "Qué tan lejos del ángulo directamente detrás del atacante se puede estar, en grados.",
                grabHealthBelowLabel = "Umbral de salud",
                grabHealthBelowDescription = "Una víctima por debajo de este nivel de salud puede ser sujetada sin ser atada. 0 lo desactiva.",
                grabCooldownLabel = "Enfriamiento tras fallo",
                grabCooldownDescription = "Segundos antes de que se pueda intentar un forcejeo fallido nuevamente.",
                grabVehiclesLabel = "Vehículos permitidos",
                grabVehiclesDescription = "Modelos de vehículos en los que se puede cargar a una víctima sujetada.",
                carryEnabledLabel = "Permitir cargar",
                carryEnabledDescription = "Permite al atacante cargar a la víctima sobre su hombro.",
                restrictVisionLabel = "Restringir visión de la víctima",
                restrictVisionDescription = "Oscurece la pantalla de la víctima mientras está siendo transportada.",
                escapeEnabledLabel = "Permitir intentos de escape",
                escapeEnabledDescription = "Permite que una víctima transportada intente liberarse.",
                escapeSecondsLabel = "Duración del escape",
                escapeSecondsDescription = "Segundos que la víctima debe mantener la tecla para liberarse.",
                maxDurationLabel = "Duración máxima",
                maxDurationDescription = "Minutos tras los cuales una sesión termina por sí sola.",
                warnMinutesLabel = "Advertencia antes del fin",
                warnMinutesDescription = "Minutos antes del límite en los que ambos bandos son advertidos.",
                idleMinutesLabel = "Liberar por inactividad",
                idleMinutesDescription = "Minutos sin interacción alguna antes de que la víctima sea liberada.",
                selfReleaseMinutesLabel = "Autoliberación tras",
                selfReleaseMinutesDescription = "Minutos sin interacción del atacante antes de que la víctima pueda liberarse por sí misma.",
                graceSecondsLabel = "Gracia tras desconexión",
                graceSecondsDescription = "Segundos que la víctima permanece atada cuando el atacante abandona el servidor.",
                rescueEnabledLabel = "Permitir rescates",
                rescueEnabledDescription = "Permite que jugadores no involucrados liberen a una víctima atada.",
                rescueSecondsLabel = "Duración del rescate",
                rescueSecondsDescription = "Segundos que un rescatador necesita para cortar las ataduras de la víctima.",
                rescueItemLabel = "Objeto de rescate",
                rescueItemDescription = "Objeto que necesita un rescatador. Deja vacío para que no se requiera ninguno.",
                allowInventoryLabel = "La víctima conserva el inventario",
                allowInventoryDescription = "Una víctima atada aún puede abrir su inventario.",
                dispatchEnabledLabel = "Activar alertas policiales",
                dispatchEnabledDescription = "Reporta secuestros e interrogatorios a los servicios de emergencia.",
                dispatchAdapterLabel = "Sistema de alerta",
                dispatchAdapterDescription = "Qué sistema de despacho recibe los reportes.",
                dispatchJobsLabel = "Trabajos que reciben la alerta.",
                dispatchJobsDescription = "Trabajos que reciben la alerta.",
                dispatchGrabChanceLabel = "Probabilidad de sometimiento",
                dispatchGrabChanceDescription = "Probabilidad porcentual de que se reporte un sometimiento.",
                dispatchFixateChanceLabel = "Probabilidad de atar",
                dispatchFixateChanceDescription = "Probabilidad porcentual de que se reporte atar a alguien a una silla.",
                dispatchToolChanceLabel = "Probabilidad de uso de herramientas",
                dispatchToolChanceDescription = "Probabilidad porcentual de que se reporte el uso de una herramienta.",
                dispatchWitnessLabel = "Requiere un testigo",
                dispatchWitnessDescription = "Solo reportar cuando otro jugador esté lo suficientemente cerca para darse cuenta.",
                dispatchWitnessRadiusLabel = "Radio del testigo",
                dispatchWitnessRadiusDescription = "Qué tan cerca debe estar un testigo, en metros.",
                dispatchCooldownLabel = "Enfriamiento de alerta",
                dispatchCooldownDescription = "Segundos entre dos alertas de la misma sesión.",
                dispatchInaccuracyLabel = "Inexactitud de posición",
                dispatchInaccuracyDescription = "Metros que la posición reportada se desvía aleatoriamente. 0 reporta el punto exacto.",
                loggingEnabledLabel = "Activar registro",
                loggingEnabledDescription = "Registra colocaciones, sometimientos, uso de herramientas, liberaciones y acciones de admin.",
                logDatabaseLabel = "Registrar en la base de datos",
                logDatabaseDescription = "Escribe adicionalmente cada entrada en la tabla de registros de interrogatorio.",
                logRetentionLabel = "Conservar registros",
                logRetentionDescription = "Días antes de que los registros de la base de datos sean eliminados. 0 los conserva para siempre.",
                pingToleranceLabel = "Tolerancia de distancia",
                pingToleranceDescription = "Metros añadidos a cada comprobación de distancia del lado del servidor para absorber el lag.",
                violationThresholdLabel = "Umbral de infracción",
                violationThresholdDescription = "Infracciones de seguridad dentro del intervalo antes de que se active la reacción. 0 lo desactiva.",
                violationActionLabel = "Reacción a infracciones",
                violationActionDescription = "Qué sucede una vez que un jugador supera el umbral de infracción.",
                violationActionNone = "No hacer nada",
                violationActionLog = "Solo registrar",
                violationActionKick = "Expulsar",
                violationActionCheating = "Reportar como trampa",
                particlesLabel = "Efectos de partículas",
                particlesDescription = "Mostrar sangre, chispas y llamas durante el uso de herramientas.",
                soundLabel = "Efectos de sonido",
                soundDescription = "Reproducir sonidos de herramientas para todos los que estén cerca.",
                cameraWorkLabel = "Movimiento de cámara",
                cameraWorkDescription = "Mover la cámara al atar a alguien y durante el uso de herramientas.",
                screenEffectsLabel = "Efectos de pantalla",
                screenEffectsDescription = "Sacudida, destello, desenfoque y filtros de color en la pantalla de la víctima.",
                objectsSection = "Objetos de interrogatorio",
                objectsEntry = "Objeto",
                objectsEditLabel = "Objetos de interrogatorio",
                objectsEditDescription = "Colocar sillas permanentes y carros de herramientas en el mapa.",
                objectsEditButton = "Editar objetos",
                objectsKindLabel = "Tipo de objeto",
                objectsKindChair = "Silla",
                objectsKindCart = "Carro de herramientas",
                objectsModelLabel = "Modelo de objeto",
                objectsPositionLabel = "Posición",
                blockedZonesSection = "Zonas bloqueadas",
                blockedZonesEntry = "Zona",
                blockedZonesEditLabel = "Zonas bloqueadas",
                blockedZonesEditDescription = "Áreas donde no se puede colocar ningún objeto de interrogatorio.",
                blockedZonesEditButton = "Editar zonas",
                blockedZonesZoneLabel = "Contorno de zona",
                blockedZonesZoneDescription = "Arrastra las esquinas para dar forma al área donde se prohíbe la colocación.",
                toolsSection = "Herramientas",
                toolsEntry = "Herramienta",
                toolsEditLabel = "Herramientas",
                toolsEditDescription = "Añade o ajusta las herramientas que se pueden usar en una víctima.",
                toolsEditButton = "Editar herramientas",
                toolsItemLabel = "Objeto requerido",
                toolsConsumeLabel = "Consumir objeto",
                toolsDamageLabel = "Daño por uso",
                toolsHealthFloorLabel = "Límite de salud",
                toolsCooldownLabel = "Enfriamiento en segundos",
                toolsProgressLabel = "Progreso por uso",
                sessionsSection = "Sesiones en curso",
                sessionsEntry = "Sesión",
                sessionsEditLabel = "Sesiones en curso",
                sessionsEditDescription = "Ver quién está siendo interrogado actualmente y finalizarla si es necesario.",
                sessionsEditButton = "Mostrar sesiones",
                sessionsStateLabel = "Estado",
                sessionsProgressLabel = "Progreso",
                orphansSection = "Objetos huérfanos",
                orphansEntry = "Objeto",
                orphansEditLabel = "Objetos huérfanos",
                orphansEditDescription = "Eliminar objetos cuyo dueño no se haya visto en mucho tiempo.",
                orphansEditButton = "Limpiar",
                sessionStates = {
                    binding = "Siendo inmovilizado",
                    active = "Activa",
                    ending = "Finalizando",
                },
            },
        },
    },
}
