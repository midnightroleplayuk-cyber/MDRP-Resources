JobConfigLocales["sky_dojjob:es"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Finanzas" ,
                doj_conditions = "Condiciones",
                doj_elections = "Elecciones",
                doj_files = "Explorador de archivos de caso",
                doj_hearings = "Audiencias",
                doj_law = "Códigos jurídicos",
                doj_offences = "Catálogo fino",
                doj_shared_files = "Documentos compartidos",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Configurar el acceso a expedientes",
                description = "Elige quién puede acceder a los registros y en qué ámbito trabaja. Los rangos sin asignación no tienen acceso.",
                status = {
                    unpublished = "La asignación aún no se ha publicado",
                    conflict = "Resuelve las asignaciones duplicadas",
                    disabled = "La tablet del DOJ está desactivada",
                    incomplete = "Asigna al menos un rango",
                    ready = "Listo para guardar",
                },
                steps = {
                    tabletTitle = "Activar la tablet del DOJ",
                    tabletText = "La tablet debe estar activada para abrir las aplicaciones de expedientes.",
                    gradesTitle = "Asignar rangos del DOJ",
                    gradesText = "Selecciona un único ámbito de registros para cada rango que deba obtener acceso.",
                    publishTitle = "Publicar y guardar",
                    publishText = "Se prepara automáticamente una nueva versión de la asignación después de cada cambio.",
                },
                grades = {
                    title = "Asignaciones de rangos",
                    description = "Selecciona un ámbito por rango. Elige Sin acceso para los rangos que deban permanecer bloqueados.",
                    search = "Buscar rangos",
                    conflict = "Un rango tiene más de una asignación. Selecciona un ámbito o Sin acceso para resolver el conflicto.",
                    notFound = "Ya no existe en el framework",
                    noResults = "No se encontró ningún rango coincidente.",
                    empty = "No se encontraron rangos para el trabajo del DOJ configurado.",
                    emptyHint = "Crea primero los rangos del DOJ en tu framework y vuelve a abrir el configurador.",
                    gradeColumn = "Rango",
                    domainColumn = "Ámbito de registros",
                    noAccess = "Sin acceso",
                    chooseDomain = "Resolver asignación",
                    assigned = "rangos asignados",
                },
                publish = {
                    saveHint = "Pulsa Guardar arriba para aplicar los cambios. Después, los jugadores podrán volver a comprobar su acceso.",
                },
            },
            registryFiles = { licenseType = "Tipo de licencia", licenseLabel = "Nombre del registro", marriages = "Registro matrimonial" },
            features = {
                dojHandovers = {
                    label = "Traspasos",
                    description = "Activa los traspasos, las decisiones judiciales y los informes de ejecución. Los documentos y su uso compartido siguen disponibles.",
                },
                dojBodycamRequests = {
                    label = "Solicitudes de cámara corporal",
                    description = "Solicitar grabaciones policiales. Requiere Traspasos; las grabaciones guardadas siguen disponibles por separado.",
                },
                dojFinance = { label = "Finanzas", description = "Saldos de facciones, transferencias de tesorería e historial." },
                dojConditions = {
                    description = "Activar condiciones estructuradas, pruebas, plazos y seguimiento de la violación.",
                    label = "Condiciones",
                },
                dojCourtroom = {
                    description = "Activar sesiones de sala de audiencias en directo seguras, presentación de pruebas e interacciones en salas basadas en roles.",
                    label = "Sala de audiencias en vivo",
                },
                dojElections = {
                    description = "Activar la administración electoral y asegurar la votación en las cabinas de votación registradas.",
                    label = "Elecciones",
                },
                dojHearings = {
                    description = "Activar la programación de la sala, el check-in y los controles autorizados del estado de audición.",
                    label = "Audiencias",
                },
                dojLegalCodes = {
                    description = "Activar libros legales, edición de textos ricos y revisión de la historia.",
                    label = "Códigos jurídicos",
                },
                dojOffences = {
                    description = "Activar el catálogo de delitos compactos y previsualización de la calculadora.",
                    label = "Catálogo fino",
                },
                dojPrinters = {
                    description = "Activar las impresoras físicas y su infraestructura de tiempo de ejecución.",
                    label = "Impresoras",
                },
                dojPublicDisplays = {
                    description = "Activar datos vivos filtrados por privacidad para las pantallas de los tribunales.",
                    label = "Exhibiciones públicas de la sala de audiencias",
                },
                dojTablet = {
                    description = "Activar el acceso a las aplicaciones para tablets DOJ.",
                    label = "DOJ comprimidos",
                },
                dojTaxes = {
                    description = "Recauda periódicamente los impuestos de vehículos y casas de los jugadores en línea.",
                    label = "Impuestos sobre los activos",
                },
            },
            settingSections = {
                finance = "Finanzas",
                courtroom = "Sala de audiencias",
                registries = "Registro",
                courthouses = "Salas de justicia",
                general = "Generales",
                legalCodes = "Códigos jurídicos",
                offences = "Catálogo fino",
                recordsAccess = "Acceso a los archivos de casos",
                tablet = "Tableta",
                taxes = "Impuestos",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registros de licencias",
                    description = "Elige las licencias que puede expedir el DOJ. Cada entrada tiene su propio registro. Eliminar una entrada no revoca las licencias existentes.",
                },
                dojRegistryAccess = {
                    ["label"] = "Acceso a registros por archivo",
                    ["description"] = "Ajusta el acceso a los registros de config/registry. Una lista vacía usa los valores del archivo. Los campos y las funciones de servidor/cliente se editan en los archivos Lua.",
                },
                dojTreasuryJob = { label = "Trabajo de tesorería", description = "Trabajo cuya cuenta compartida recibe los cobros y paga las transferencias." },
                dojFinanceJobs = { label = "Facciones visibles", description = "Claves de trabajos registrados disponibles en las cuentas. La tesorería siempre se incluye." },
                dojFinanceLimit = { label = "Límite por operación", description = "Importe máximo por transferencia o cobro." },
                dojFinePaymentMode = { label = "Pago de multas impuestas", description = "Pago bancario directo o factura externa. Crear una factura no confirma el pago.", options = { bank = "Pago bancario", billing = "Factura" } },
                dojFineSociety = { label = "Destinatario de multas", description = "Trabajo cuya cuenta compartida recibe las multas impuestas." },
                dojCourtroomBoardMove = {
                    label = "Mueva el tablero de la corte",
                    description = "Tecla predeterminada para agarrar o soltar un tablero móvil (por ejemplo, F). Los jugadores pueden anularlo en las fijaciones de teclas FiveM. El movimiento es temporal y se reinicia después de reiniciar.",
                },
                dojCourtroomGavel = {
                    label = "Juez Maíz",
                    description = "Modelo Gavel, fijación a mano, animación, patrones de sonido y huelga. Los cambios también se aplican sin reiniciar.",
                },
                dojHearingParticipantRoles = {
                    label = "Funciones de los participantes",
                    description = "Roles predeterminados: acusado, testigo, jurado, juez. Agregue las claves de rol en minúsculas personalizadas aquí (hasta 24 caracteres, subrayados permitidos). Mantenga juez. Los roles personalizados no otorgan permisos de juez o jurado.",
                },
                dojWarrantTemplateCodes = {
                    label = "Códigos de la plantilla de garantía",
                    description = "Códigos de la plantilla que figuran en PD Órdenes después de la firma judicial y el intercambio. HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registros",
                    description = "Activar y nombrar DOJ registros, a continuación, establecer el acceso a la profesión y la autorización. DOJ permisos de rol existentes todavía se aplican. RP registros personalizados se gestionan en las profesiones Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Etiqueta de categoría usada para blips de mapas de corte.",
                    label = "Categoría del marcador",
                },
                dojCourthouseBlipColor = {
                    description = "Color de mapa utilizado para los tribunales.",
                    label = "Color de Blip",
                },
                dojCourthouseBlipScale = {
                    description = "Escala de mapas utilizada para los blips de los tribunales.",
                    label = "Escala de blip",
                },
                dojCourthouseBlipShortRange = {
                    description = "Sólo mostrar los blips de la corte a corto alcance.",
                    label = "Corto alcance",
                },
                dojCourthouseBlipSprite = {
                    description = "sprite mapa utilizado para los tribunales.",
                    label = "Sprite intermitente",
                },
                dojLegalBookItem = {
                    description = "Elemento de inventario para una edición de código legal fijo. El primer uso guarda su contenido y fecha; requiere elementos individuales con metadatos.",
                    label = "Artículo del libro de códigos jurídicos",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes de creación de libros legales.",
                    label = "Crear refrescamiento de libros",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes de creación de revisiones.",
                    label = "Crear el enfriamiento de la revisión",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Mínimo milisegundos entre las solicitudes de eliminación de libros legales.",
                    label = "Borrar refrescamiento de libros",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Mínimo milisegundos entre las solicitudes de eliminación de revisiones.",
                    label = "Eliminar el enfriamiento de la revisión",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes de un libro legal.",
                    label = "Cargar refrescamiento de libros",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes para la lista de libros legales.",
                    label = "Cargar el enfriamiento de la biblioteca",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Tiempo mínimo de espera utilizado para solicitudes de documentos de gran tamaño.",
                    label = "Tiempo límite de solicitud grande en milisegundos",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Número máximo de caracteres permitidos en una abreviatura de libro legal.",
                    label = "Longitud máxima de la abreviatura",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Número máximo de caracteres permitidos en un título de libro legal.",
                    label = "Longitud máxima del título del libro",
                },
                dojLegalMaxContentBytes = {
                    description = "Máximo tamaño serializado de una revisión completa del libro legal.",
                    label = "Tamaño máximo del contenido en bytes",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Longitud máxima del título aceptada al importar párrafos estructurados heredados.",
                    label = "Longitud máxima del título del párrafo heredado",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Número máximo de párrafos estructurados aceptados durante las importaciones heredadas.",
                    label = "Parágrafos heredados máximos por libro",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Número máximo de caracteres permitidos en una nota de revisión.",
                    label = "Longitud máxima de la nota de revisión",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Número máximo de nodos de editor permitidos en una revisión.",
                    label = "Máximo nodos de texto enriquecido",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Límite de ancho de banda por jugador utilizado para transferir grandes documentos legales.",
                    label = "Tasa de transferencia en bytes por segundo",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes de reordenación de libros legales.",
                    label = "Reordenar libros de enfriamiento",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Mínimo milisegundos entre actualizaciones de metadatos del libro legal.",
                    label = "Actualizar el refrescado del libro",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Número máximo de revisiones cargadas al abrir un libro legal.",
                    label = "Historial de revisiones visible",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Mínimo milisegundos entre las vistas previas de la calculadora del lado del servidor.",
                    label = "Refrigeración de la calculadora",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Mínimo milisegundos entre solicitudes de catálogo.",
                    label = "Refrigeración del catálogo de carga",
                },
                dojOffenceMaxSelection = {
                    description = "Número máximo de delitos incluidos en una vista previa de la calculadora.",
                    label = "Selección máxima",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Mínimos milisegundos entre cambios en el catálogo de delitos.",
                    label = "Refrigeración de edición de catálogo",
                },
                dojOffenceMirandaWarning = {
                    description = "Aviso personalizado que se muestra en el catálogo fino. Deje vacío para usar el texto estándar en el idioma seleccionado.",
                    label = "Alerta Miranda",
                },
                dojPrimaryColor = {
                    description = "Color principal utilizado por el grupo de profesión DOJ y tabletas.",
                    label = "Color principal",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Estos grados trabajan con la administración de los tribunales y registros de registro.",
                    label = "Administración de los tribunales",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Estos grados trabajan con registros y decisiones judiciales.",
                    label = "Poder judicial",
                },
                dojRecordsMappingVersion = {
                    description = "Revisión publicada de la asignación de dominio de grado a registro. Un valor vacío mantiene los registros de acceso desactivados.",
                    label = "Versión de publicación",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Estas notas funcionan con los registros de la fiscalía.",
                    label = "Procesamiento",
                },
                dojTabletRequireDuty = {
                    description = "Sólo en servicio DOJ empleados pueden abrir la aplicación de código legal.",
                    label = "Requerir deber",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Moneda directa",
                },
                dojTaxHouseAmount = {
                    description = "Cantidad cobrada por cada casa propiedad de un jugador.",
                    label = "Impuestos por vivienda",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Segundos a esperar antes de la primera recaudación cuando no se almacena ningún ciclo fiscal anterior.",
                    label = "Retraso inicial",
                },
                dojTaxIntervalMinutes = {
                    description = "Minutos entre los ciclos automáticos de recaudación de activos y impuestos.",
                    label = "Intervalo de recogida",
                },
                dojTaxNotifyPlayer = {
                    description = "Notificar a los jugadores después de una recaudación directa, una presentación de la factura, o fondos insuficientes.",
                    label = "Notificar a los jugadores",
                },
                dojTaxPaymentMode = {
                    description = "Utilice el saldo bancario/monetario seleccionado directamente o envíe una factura de sociedad Sky Base por jugador sujeto a impuestos y ciclo tributario.",
                    label = "Método de pago",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Balanza bancaria/monetaria",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ profesión cuya cuenta de sociedad configurada recibe todos los ingresos fiscales recaudados.",
                    label = "Destinatario DOJ profesión",
                },
                dojTaxVehicleAmount = {
                    description = "Cantidad cobrada por cada vehículo propiedad de un jugador.",
                    label = "Impuestos por vehículo",
                },
            },
            printers = {
                groups = {
                    paper = "Papel",
                    ink = "Tinta",
                    general = "Impresora",
                    printing = "Impresión y acceso",
                    placement = "Modelo y posición",
                },
                actions = {
                    selectExisting = "Seleccionar impresora existente",
                    selectExistingHint = "Apunta a la impresora. Intro: seleccionar · Esc: cancelar",
                    add = "Añadir impresora",
                    open = "Inspeccionar impresora",
                    place = "Colocar impresora",
                    setPosition = "Usar ubicación actual",
                },
                classes = {
                    office = "Oficina",
                    professional = "Profesional",
                    standard = "Estándar",
                },
                description = "Configura impresoras, consumibles, colas, acceso y ubicación para este trabajo.",
                fieldDescriptions = {
                    paperCapacity = "Cantidad máxima de papel para cada impresora de este trabajo.",
                    paperEnabled = "Al activarlo, las impresoras de este trabajo empiezan vacías y requieren el objeto de recarga compartido.",
                    refillAmount = "Papel añadido a una impresora de este trabajo al usar el objeto de recarga compartido.",
                    refillItem = "Nombre interno del objeto del inventario que se consume al recargar una impresora de este trabajo.",
                },
                fields = {
                    active = "Activa",
                    class = "Clase",
                    heading = "Orientación",
                    id = "ID estable",
                    label = "Nombre",
                    maxQueue = "Capacidad de la cola",
                    minimumGrade = "Rango mínimo",
                    paperCapacity = "Capacidad de papel",
                    paperEnabled = "Requerir recargas de papel",
                    propModel = "Modelo del objeto",
                    refillAmount = "Papel por recarga",
                    refillItem = "Objeto de recarga",
                    deleteCopiesAfterRestart = "Eliminar copias al reiniciar",
                    deleteCopiesAfterRestartHint = "Eliminar las impresiones sin recoger al reiniciar el servicio de impresión.",
                    spawnProp = "Crear objeto",
                    speed = "Velocidad de impresión",
                    status = "Estado",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Clase: {class}",
                    paper = "Papel: {paper} / {capacity}",
                    queue = "Cola: {queue} / {maxQueue}",
                    status = "Estado: {status}",
                    title = "Impresora",
                },
                messages = {
                    grade_too_low = "Tu rango es demasiado bajo para esta impresora.",
                    invalid_amount = "La cantidad de recarga no es válida.",
                    missingModel = "Selecciona un modelo de impresora válido antes de colocarlo.",
                    missing_refill_item = "No tienes el objeto de recarga configurado.",
                    no_refill_printer = "No hay ninguna impresora accesible que use papel cerca.",
                    paper_capacity_exceeded = "Se superaría la capacidad de papel.",
                    paper_disabled = "El consumo de papel está desactivado para esta impresora.",
                    paper_full = "La bandeja de papel de esta impresora ya está llena.",
                    printer_inactive = "Esta impresora está desactivada.",
                    printer_not_found = "La impresora ya no existe.",
                    refill_cooldown = "Espera un momento antes de volver a recargar.",
                    refilled = "Se han añadido {amount} hojas. Existencias: {paper} / {capacity}.",
                    too_far_away = "Acércate a la impresora.",
                    unavailable = "Impresora no disponible.",
                    wrong_job = "Tu trabajo no permite usar esta impresora.",
                },
                settings = {
                    description = "Estos ajustes se aplican a todas las impresoras configuradas para este trabajo.",
                    title = "Ajustes de impresoras del trabajo",
                },
                statuses = {
                    maintenance = "Mantenimiento",
                    offline = "Sin conexión",
                    online = "En línea",
                },
                title = "Impresoras",
                values = {
                    disabled = "Desactivado",
                    enabled = "Activado",
                    selectItem = "Seleccionar objeto",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Configure DOJ profesiones, sedes judiciales y la aplicación de código legal.",
                    title = "Profesiones del Departamento de Justicia",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Tribunal de Justicia",
                    entryPluralLabel = "Salas de justicia",
                    label = "Salas de justicia",
                },
            },
            extensions = {
                invalidSelection = "Selección no válida: {value}",
                trainingSettings = {
                    description = "Configure el acceso a la capacitación, la inscripción, las aprobaciones y la planificación de cursos para este trabajo.",
                    label = "Configuración de entrenamiento",
                },
            },
            locations = {
                stationPosition = "Ubicación / marcador de mapa",
                stationPositionHint = "Punto principal de esta ubicación de trabajo. Si el marcador en el mapa está activado en Trabajo → Marcadores, aparecerá aquí.",
                addCourtroom = "Añadir sala de audiencias",
                courtroom = "Sala de audiencias",
                courtroom_display_desk_27 = "Exhibición de pruebas en el tribunal – monitor de escritorio de 27 pulgadas",
                courtroom_display_wall_55 = "Exposición de pruebas en el tribunal – pared TV de 55 pulgadas",
                courtroom_display_wall_75 = "Exposición de pruebas en el tribunal – pared TV de 75 pulgadas",
                courtroom_display_wall_100 = "Exposición de pruebas en el tribunal – pared TV de 100 pulgadas",
                courtroom_display_wall_120 = "Exposición de pruebas en el tribunal – pared TV de 120 pulgadas",
                courtroom_display_wall_150 = "Exposición de pruebas en el tribunal – pared TV de 150 pulgadas",
                courtroom_display_board_93 = "Tablero interactivo de la sala del tribunal – 150 pulgadas de soporte móvil",
                courtroom_display_projection = "Exhibición de pruebas en el tribunal – pantalla de proyección de 4.5 m",
                courtroom_judge_mic = "Sala de audiencias – micrófono del juez",
                courtroom_jury_room = "Sala de audiencias – sala de jurados",
                courtroom_room = "Sala de audiencias / centro de salas",
                courtroom_witness = "Sala de audiencias – estrado de testigos",
                electionBooth = "Cabina de votación",
                publicDisplayDesk27 = "Pantalla pública – monitor de escritorio de 27 pulgadas",
                publicDisplayTerminal43 = "Pantalla pública – 43 pulgadas de terminal de piso",
                publicDisplayWall55 = "Pantalla pública: pared TV de 55 pulgadas",
                publicDisplayWall75 = "Pantalla pública: pared TV de 75 pulgadas",
                publicDisplayWall100 = "Pantalla pública: pared TV de 100 pulgadas",
                publicDisplayWall120 = "Pantalla pública: pared TV de 120 pulgadas",
                publicDisplayWall150 = "Pantalla pública: pared TV de 150 pulgadas",
                publicDisplayProjection = "Pantalla pública – 4.5 m Pantalla de proyección",
                publicLegalCode = "Código jurídico público",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Órdenes judiciales",
                },
                dojAccess = {
                    label = "Acceso",
                },
                dojCourthouseBlip = {
                    label = "Blip del mapa",
                },
                dojLegalBooks = {
                    label = "Libros",
                },
                dojLegalContentLimits = {
                    label = "Límites de contenido",
                },
                dojLegalItem = {
                    label = "Ítem de inventario",
                },
                dojLegalRateLimits = {
                    label = "Límites de las tasas",
                },
                dojLegalRevisions = {
                    label = "Revisión",
                },
                dojLegalTransfers = {
                    label = "Documentos de gran tamaño",
                },
                dojOffenceCalculation = {
                    label = "Calculadora",
                },
                dojOffenceRateLimits = {
                    label = "Límites de las tasas",
                },
                dojOffenceMiranda = {
                    label = "Orientación del catálogo",
                },
                dojOffenceSource = {
                    label = "Fuente del catálogo",
                },
                dojRecordsGradeBindings = {
                    description = "Asignar cada grado disponible DOJ a exactamente un dominio de registros, luego publicar la asignación.",
                    label = "Grados y dominios de registro",
                },
                dojTaxPayment = {
                    label = "Pago",
                },
                dojTaxRates = {
                    label = "Tasas",
                },
                dojTaxSchedule = {
                    label = "Cuadro",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Contratos notariales",
                    powers_of_attorney = "Facultades de abogado",
                    name_changes = "Cambios de nombre",
                    company_registry = "Registro de sociedades",
                    association_registry = "Registro de asociaciones",
                    licensing = "Licencias",
                    administrative_decisions = "Decisiones administrativas",
                    administrative_objections = "Objeciones administrativas",
                },
            },
            gavel = {
                enabled = "Activado",
                cooldown = "Refrigeración del activador (ms)",
                defaultPreset = "Patrón de ataque predeterminado",
                prop = "Propulsor de gaveta",
                model = "Nombre del modelo",
                bone = "Hueso de mano ID",
                offset = "Desplazamiento (metros)",
                rotation = "Rotación (grados)",
                presets = "Patrones de huelga",
                single = "Huelga única",
                double = "Doble golpe",
                strikes = "Número de huelgas",
                interval = "Intervalo de huelga (ms)",
                impact = "Retraso del sonido (ms)",
                audio = "Sonido",
                asset = "Activo de audio",
                volume = "Volumen",
                animation = "Animación",
                dict = "Diccionario de animación",
                clip = "Nombre de la animación",
                duration = "Duración de la moción (ms)",
                flag = "Banderas de animación",
                x = "X",
                y = "Y",
                z = "Z",
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
        },
    },
}
