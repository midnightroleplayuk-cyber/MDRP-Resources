JobConfigLocales["sky_crimesystem:it"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Comando diretto",
            roleDefaults = {
                title = "Ruoli",
                description = "Scegli il grado minimo per ogni permesso predefinito. I permessi dei gradi salvati nel menu del capo hanno la precedenza.",
                bossHint = "I gradi di capo e vicecapo mantengono sempre l’accesso completo.",
                empty = "Non sono ancora disponibili gradi per questo lavoro.",
                gradesTitle = "Gradi del lavoro",
                noDefault = "Nessun permesso predefinito",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "I valori condivisi si applicano ai campi ereditati. Modificare un valore nella sua pagina delle impostazioni lo rende personalizzato. Le voci esistenti conservano i loro valori.",
            weaponStreetDescription = "Durante un contatto di vendita di droga, il server può occasionalmente acquistare un'arma valida. Selezione, prezzo e pagamento sono decisi dal server.",
            weaponGroups = {
                general = "Valori generali",
                access = "Valori di accesso",
                collection = "Valori di raccolta",
                production = "Valori di produzione",
                market = "Valori di mercato",
                delivery = "Valori degli ordini",
                street = "Vendita di armi in strada",
            },
            weaponOptions = {
                scrap_search = "Cerca nel mucchio di rottami",
                player = "Per giocatore",
                global = "Globale",
                money = "Contanti",
                bank = "Conto bancario",
                black_money = "Soldi sporchi",
                timing = "Ferma l'indicatore all'interno dell'intervallo ottimale.",
                precision = "Esegui ogni taglio all'interno della finestra di precisione.",
                pressure = "Ferma la pressa alla sua pressione ottimale.",
            },

            reputation = {
                remove = "Elimina",
                title = "Reputazione",
                action = "Azione",
                points = "Punti per completamento",
                enabled = "Attiva",
                search = "Cerca azioni",
                added = "Già aggiunta",
                noResults = "Nessuna azione corrispondente trovata.",
                empty = "Nessuna azione presente. Usa il pulsante più per aggiungerne una.",
                name = "Nome della regola",
                target = "Bersaglio (facoltativo)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Fazioni",
                    subtitle = "Configurare i lavori criminali e le loro posizioni condivise.",
                    title = "Sistema criminale",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Base principale",
                    entryPluralLabel = "Basi principali",
                    label = "Zona base principale",
                },
                presetTerritories = {
                    label = "Distretti predefiniti",
                    entryLabel = "Distretto predefinito",
                    entryPluralLabel = "Distretti predefiniti",
                },
                customTerritories = {
                    label = "Territori personalizzati",
                    entryLabel = "Territorio personalizzato",
                    entryPluralLabel = "Territori personalizzati",
                },
                objectsSection = {
                    label = "Oggetti di interrogatorio",
                    entryLabel = "Oggetto",
                    entryPluralLabel = "Oggetti di interrogatorio",
                },
                blockedZonesSection = {
                    label = "Zone bloccate",
                    entryLabel = "Zona",
                    entryPluralLabel = "Zone bloccate",
                },
                toolsSection = {
                    label = "Attrezzi",
                    entryLabel = "Strumento",
                    entryPluralLabel = "Attrezzi",
                },
                sessionsSection = {
                    label = "Sessioni in corso",
                    entryLabel = "Sessione",
                    entryPluralLabel = "Sessioni in corso",
                },
                orphansSection = {
                    label = "Oggetti orfani",
                    entryLabel = "Oggetto",
                    entryPluralLabel = "Oggetti orfani",
                },
            },
            darknetActions = {
                currentLocation = "Usa posizione attuale",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                drugGrowthMaxMultiplier = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                drugGrowthMinMultiplier = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                drugGrowthQualityBonusMax = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Scegli gradi minimi validi per i permessi dei ruoli.",
                base_raid_locked = "La base è sotto attacco. Posizioni dei depositi e configurazione sono bloccate.",
                base_storage_outside_zone = "Tutti i depositi, gli armadietti e i depositi colpi devono essere nella zona della base.",
                base_zone_invalid_polygon = "Posiziona almeno tre punti distinti senza lati incrociati e controlla altezza (3–200 m) e dimensione.",
                base_zone_point_limit = "Una zona della base supporta al massimo 64 vertici.",
                base_zone_required = "Configura prima una zona base principale valida per questa banda.",
                crime_interrogation_invalid_model = "Inserisci un modello di oggetto valido.",
                crime_interrogation_invalid_coords = "Posiziona l'oggetto in una posizione valida.",
                crime_interrogation_invalid_zone_points = "Posiziona almeno tre punti di confine validi.",
                crime_interrogation_duplicate_id = "Esiste già un oggetto con questo ID.",
                crime_interrogation_tool_invalid = "Controlla la definizione dello strumento.",
                crime_interrogation_tool_id_invalid = "Inserisci un ID strumento valido.",
                crime_interrogation_tool_label_missing = "Inserisci un nome per lo strumento.",
                crime_interrogation_effect_missing = "Configura un effetto per lo strumento.",
                crime_interrogation_effect_type_unknown = "Seleziona un tipo di effetto supportato.",
                crime_interrogation_effect_status_missing = "Specifica lo stato influenzato da questo strumento.",
                crime_interrogation_minigame_missing = "Configura un minigioco per lo strumento.",
                crime_interrogation_minigame_type_unknown = "Seleziona un tipo di minigioco supportato.",
                crime_interrogation_keys_missing = "Configura i comandi dello strumento.",
                crime_interrogation_keys_invalid = "Controlla i comandi configurati dello strumento.",
                crime_interrogation_keys_duplicate = "Assegna ogni azione e comando dello strumento una sola volta.",
                crime_interrogation_anim_invalid = "Controlla il dizionario e la clip di animazione dello strumento.",
                crime_interrogation_anim_missing = "Configura un'animazione per l'utilizzatore dello strumento.",
                crime_interrogation_occupied = "C'è già qualcuno legato a questo oggetto.",
                crime_interrogation_not_found = "Non è più presente.",
            },
            extensions = {
                baseZone = {
                    description = "Posiziona da 3 a 64 vertici in ordine. Il punto più basso determina il limite inferiore; l’altezza si estende verso l’alto da lì. I punti vengono salvati come bozza; premi Salva per applicare la zona. Solo depositi, armadietti e depositi colpi all’interno della zona sono accessibili durante le incursioni. I punti esterni non impediscono il salvataggio o l’avvio di un’incursione. I confini esistenti restano attivi fino al salvataggio.",
                    fields = {
                        bucket = "Dimensione",
                        configured = "Configurata",
                        height = "Altezza (metri)",
                        radius = "Raggio (metri)",
                        x = "Centro X",
                        y = "Centro Y",
                        z = "Centro Z",
                    },
                    label = "Zona base principale",
                },
                invalidSelection = "Selezione non valida: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Punto principale di questa sede del lavoro. Se l'icona sulla mappa è attivata in Lavoro → Blip, appare qui.",
            },
            locationTypes = {
                crimeStationPosition = "Sede / icona sulla mappa",
                heistCrafting = "Officina del colpo",
                heistStorage = "Deposito del colpo",
            },
            membershipMigration = {
                cancel = "Annulla",
                confirm = "Migra e salva",
                message = "Le appartenenze esistenti verranno migrate al modello selezionato. In modalità indipendente il lavoro normale rimane separato.",
                title = "Cambiare il modello di appartenenza?",
            },
            moneywashActions = {
                currentLocation = "Usa posizione attuale",
                invalidLocations = "Controlla ID, nomi, interni selezionati e coordinate. Ogni posizione deve avere un ID univoco.",
                position = "Posizione",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Punti di costruzione", description = "Posiziona attrezzature compatibili sui punti. Coordinate relative all’interno selezionato." },
                mwBuildNodes = "Punti di costruzione",
                moneywashPublicEquipment = { label = "Attrezzatura pubblica", description = "Assegna lavatrici, generatori e ventilatori ai locali pubblici e punti compatibili." },
                mwPublicEquipment = "Attrezzatura pubblica",
                moneywashMaterials = { label = "Materiali", description = "Usa nomi esatti dell’inventario. Peso in grammi; installa gli oggetti mancanti." },
                mwMaterials = "Materiali",
                moneywashMaterialRecipes = { label = "Ricette materiali", description = "Ingressi, uscite e durata per unità. I lavoratori usano queste ricette." },
                mwMaterialRecipes = "Ricette materiali",
                moneywashProductionRecipes = { label = "Ricette di stampa", description = "Carta, inchiostro e tempi per unità. Contanti dopo asciugatura e controllo qualità." },
                mwProductionRecipes = "Ricette di stampa",
                moneywashCollectors = { label = "Raccoglitori", description = "Configura resa, strumenti, attesa e posizione di ogni raccoglitore." },
                mwCollectors = "Raccoglitori",
                moneywashProcessors = { label = "Lavoratori", description = "Scegli ricetta materiali e posizione di ogni lavoratore." },
                mwProcessors = "Lavoratori",

                control = "Pannello di controllo",
                editor = {
                    addBusiness = "Aggiungi attività",
                    addInterior = "Aggiungi interno",
                    advanced = "Dettagli tecnici",
                    asset_ipl = "IPL: inserisci il nome esatto e la posizione dell’interno.",
                    asset_mlo = "MLO: usa la posizione di un interno già installato. L’accesso avviene dall’ingresso dell’attività.",
                    asset_shell = "Shell: la risorsa del modello deve essere installata e avviata sul server.",
                    businessHelp = "Assegna un nome all’attività, scegli l’interno e imposta il prezzo.",
                    businessListHelp = "Gestisci ingressi e prezzi di acquisto delle attività.",
                    businesses = "Attività",
                    capture = "Imposta in gioco",
                    captureOrigin = "Imposta posizione interno",
                    chooseInterior = "Scegli un interno",
                    coordinates = "Modifica coordinate",
                    editSections = "Configurazione",
                    emptyBusinessHelp = "Collega un ingresso sulla mappa a un interno. Le organizzazioni potranno acquistare l’attività vuota.",
                    emptyBusinesses = "La prima attività",
                    emptyInteriorHelp = "Collega un IPL, una shell o un MLO installato, poi imposta i punti per l’attività.",
                    emptyInteriors = "Il primo interno",
                    entranceHelp = "Imposta l’ingresso dove i giocatori acquistano e accedono all’attività.",
                    freecamHelp = "Camera libera: WASD muovi, Q/E su/giù, Shift accelera, Ctrl rallenta. Tasto destro: guarda. Trascina gizmo, R ruota/sposta, Invio conferma, Backspace annulla.",
                    general = "Generale",
                    heading = "Orientamento",
                    interiorHelp = "Scegli il tipo di interno e il relativo asset.",
                    interiorListHelp = "Prepara spazi vuoti. I giocatori collocano macchine e attrezzature.",
                    interiors = "Interni",
                    listEmpty = "Nessuna voce.",
                    locationTypes = "Gestione sedi",
                    newBusiness = "Nuova attività",
                    newInterior = "Nuovo interno",
                    noResults = "Nessun risultato.",
                    notSet = "Da impostare",
                    offsetHelp = "I valori sono scostamenti dall’origine. La posizione nel mondo è mostrata sopra.",
                    origin = "Origine",
                    originHelp = "Posizione dell’interno. Tutti gli altri punti sono relativi ad essa.",
                    originRequired = "Imposta prima la posizione dell’interno in Generale.",
                    outsideRange = "Fuori dal raggio di {range} metri",
                    point_control = "Sposta e ruota il pannello sulla parete con il gizmo. L'altezza confermata dell'oggetto viene mantenuta esattamente. Attiva o disattiva il marker in Interactions → Money Wash: pannello di controllo.",
                    point_entry = "I giocatori arrivano ed escono da qui. Uscendo tornano automaticamente all'ingresso esterno della propria attività.",
                    point_position = "Questo punto si trova all’esterno dell’attività.",
                    point_storage = "Sposta e ruota lo scaffale con il gizmo fino ad appoggiarlo sul pavimento. Qui i membri accedono alle attrezzature acquistate. Attiva o disattiva il marker in Interactions → Money Wash: deposito.",
                    points = "Punti",
                    pointsHelp = "Seleziona un punto e impostalo direttamente in gioco.",
                    rangeNote = "Si applica un raggio di {range} metri attorno all’origine dell’interno, senza limiti di altezza.",
                    remove = "Rimuovi",
                    repairRange = "Avvicina questi punti all’origine dell’interno.",
                    saveHint = "Applica le modifiche con Salva in alto.",
                    search = "Cerca …",
                    set = "Impostato",
                    teleport = "Teletrasporto",
                    viewInteriors = "Visualizza interni",
                    visit = "Visita",
                    visitHint = "Muoviti liberamente. Premi Backspace per tornare all'editor.",
                    visitTitle = "Esplora l'interno",
                },
                entry = "Punto di ingresso e uscita",
                fields = {
                    mode = "Modalità di accesso",
                    ownerKind = "Tipo di proprietario",
                    productionEnabled = "Espansione di stampa disponibile",
                    feePercent = "Commissione (%) / -1 = globale",
                    storageCapacity = "Capacità scorte (oggetti)",
                    maximumOrders = "Ordini simultanei per giocatore",
                    gridPower = "Potenza rete / 0 = generatore",
                    autoService = "Manutenzione pubblica automatica",
                    maximumPendingOutputs = "Massimo pagamenti in sospeso",
                    placementRange = "Raggio di posizionamento (m)",
                    placementHeight = "Intervallo verticale (m)",
                    interiorId = "ID interno",
                    equipmentId = "ID attrezzatura",
                    nodeId = "ID punto di costruzione",
                    generatorNode = "ID punto generatore",
                    maxOffset = "Scostamento massimo dal punto (m)",
                    maxHeight = "Scostamento verticale massimo (m)",
                    weight = "Peso oggetto (g)",
                    inputItem = "Materiale in entrata",
                    secondItem = "Secondo materiale in entrata",
                    outputItem = "Materiale in uscita",
                    requiredTool = "Strumento richiesto",
                    baseQuality = "Qualità iniziale (%)",
                    minimumQuality = "Qualità minima (%)",
                    inspectionCards = "Schede di controllo",
                    inspectionPenalty = "Perdita qualità per errore (%)",
                    rejectPercent = "Banconote scartate (%)",
                    accessoryModel = "Modello accessorio",
                    accessoryMaximum = "Massimo accessori visibili",
                    accessoryActiveOnly = "Accessori solo durante la lavorazione",
                    animDict = "Dizionario animazione",
                    animClip = "Sequenza animazione",
                    cooldown = "Attesa (secondi)",
                    minimum = "Resa minima",
                    maximum = "Resa massima",
                    productionPrice = "Stampa di denaro · Prezzo",
                    recipeId = "Ricetta ID",
                    inputAmount = "Materiale / per unità",
                    secondAmount = "Materiale / per unità",
                    outputAmount = "Materiale / per unità",
                    paperItem = "Carta da stampa",
                    inkItem = "Inchiostro da stampa",
                    paperAmount = "Carta da stampa / per unità",
                    inkAmount = "Inchiostro da stampa / per unità",
                    notesPerUnit = "Banconote / per unità",
                    valuePerNote = "Contanti / Banconote",
                    maximumUnits = "Unità (max.)",
                    printSeconds = "Stampare / per unità (Secondi)",
                    inspectionSeconds = "Controllare / per unità (Secondi)",
                    rinseSeconds = "Lavare / per unità (Secondi)",
                    drySeconds = "Asciugare / per unità (Secondi)",
                    accessoryUnit = "Banconote / per unità",
                    accessoryX = "Modello accessorio · X (m)",
                    accessoryY = "Modello accessorio · Y (m)",
                    accessoryZ = "Modello accessorio · Z (m)",
                    accessoryStep = "Modello accessorio · Z (m)",

                    capacity = "Capacità per ciclo",
                    controlHeading = "Pannello di controllo orientamento",
                    controlHeight = "Altezza di montaggio sopra il punto (m)",
                    controlModel = "Modello del pannello a parete",
                    controlX = "Pannello di controllo X",
                    controlY = "Pannello di controllo Y",
                    controlZ = "Pannello di controllo Z",
                    disableSets = "Set nascosti (separati da virgola)",
                    enableSets = "Set attivati (separati da virgola)",
                    entryX = "Offset ingresso X",
                    entryY = "Offset ingresso Y",
                    entryZ = "Offset ingresso Z",
                    heading = "Orientamento",
                    id = "ID univoco",
                    interior = "Interno",
                    ipl = "Nome IPL",
                    kind = "Tipo",
                    label = "Nome",
                    model = "Nome modello",
                    power = "Unità energia",
                    price = "Prezzo",
                    radius = "Raggio posizionamento (m)",
                    repairPrice = "Prezzo riparazione (0 = gratis)",
                    seconds = "Durata ciclo (secondi)",
                    storageHeading = "Punto deposito orientamento",
                    storageModel = "Modello dello scaffale",
                    storageX = "Punto deposito X",
                    storageY = "Punto deposito Y",
                    storageZ = "Punto deposito Z",
                    wear = "Usura per ciclo (%)",
                    x = "Origine X",
                    y = "Origine Y",
                    z = "Origine Z",
                },
                interactions = {
                    control = "Money Wash: pannello di controllo",
                    storage = "Money Wash: deposito",
                },
                item = "Voce",
                moneywashBucketStart = {
                    description = "Riserva questo intervallo a Money Wash. Le modifiche valgono dal prossimo ingresso.",
                    label = "Inizio intervallo istanze",
                },
                moneywashEquipment = {
                    description = "I giocatori acquistano e posizionano dispositivi. Capacità, durata e usura valgono per le lavatrici. Potenza indica produzione o consumo. Le modifiche valgono per nuovi acquisti.",
                    label = "Attrezzature acquistabili",
                },
                moneywashInteriors = {
                    description = "Configura interni vuoti IPL, shell o MLO. Ingresso, pannello di controllo, magazzino e limiti di costruzione sono relativi all'origine. Uscendo si torna all'ingresso della propria attività.",
                    label = "Interni (IPL, shell o MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Numero massimo di dispositivi e kit acquistati per attività.",
                    label = "Limite attrezzature",
                },
                moneywashPreviewBucketStart = {
                    description = "Visit aggiunge l'ID del giocatore a questo valore per un'istanza privata dell'amministratore. Riservalo separatamente dalle attività e dalle altre risorse. Le modifiche valgono dalla prossima anteprima.",
                    label = "Inizio intervallo istanze di anteprima",
                },
                moneywashProperties = {
                    description = "Imposta un ingresso, scegli un interno e stabilisci il prezzo di acquisto. Le attività acquistate conservano l'interno e l'arredamento salvati.",
                    label = "Ingressi dei locali",
                },
                moneywashRepairShops = {
                    description = "Posiziona officine e imposta il prezzo di riparazione. Vendono kit e riparano macchine in deposito.",
                    label = "Posizioni negozi",
                },
                moneywashShops = {
                    description = "Posiziona negozi per lavatrici, generatori e ventilatori. Gli acquisti vanno all’attività selezionata.",
                    label = "Posizioni negozi",
                },
                mwEquipment = "Negozio attrezzature",
                mwInteriors = "Interni vuoti",
                mwProperties = "Posizioni",
                mwRepairShops = "Officina riparazioni",
                mwSettings = "Impostazioni attività",
                names = {
                    mwPublicLaundry = "Lavanderia pubblica",
                    mwPaperPulp = "Pasta di carta",
                    mwPrintingPaper = "Carta da stampa",
                    mwPrintingInk = "Inchiostro da stampa",
                    mwPaperRecipe = "Produrre carta da stampa",
                    mwPrintingRecipe = "Banconote standard",
                    mwPaperCollector = "Raccoglitore di carta",
                    mwInkCollector = "Raccoglitore di inchiostro",
                    mwPaperProcessor = "Lavoratore della carta",
                    mwPrinter = "Macchina da stampa",
                    mwInspectionTable = "Tavolo di controllo",
                    mwDryingCabinet = "Armadio essiccatore",
                    mwNode1 = "1 · Lavare",
                    mwNode2 = "2 · Lavare",
                    mwNode3 = "3 · Punti di costruzione",
                    mwNode4 = "4 · Stampare",
                    mwNode5 = "5 · Controllare",
                    mwNode6 = "6 · Asciugare",
                    mwNode7 = "7 · Punti di costruzione",

                    mwInteriorWarehouse = "Magazzino vuoto",
                },
                options = {
                    private = "Privato",
                    public = "Pubblico",
                    faction = "Organizzazione",
                    person = "Personaggio",
                    printer = "Macchina da stampa",
                    inspection = "Tavolo di controllo",
                    dryer = "Armadio essiccatore",

                    fan = "Ventilatore",
                    generator = "Generatore",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Kit riparazione",
                    shell = "Modello shell",
                    washer = "Lavatrice",
                },
                origin = "Origine",
                storage = "Punto deposito",
            },
            settingFields = {
                cultivationLevel = "Livello di coltivazione",
                cultivationTitle = "Nome del livello",
                cultivationRequiredXp = "XP totale richiesta",
                cultivationAction = "Azione",
                cultivationXp = "XP",
                cultivationCategory = "Categoria",
                cultivationEntry = "Voce",
                cultivationRequiredLevel = "Livello richiesto",
                alias = "Pseudonimi",
                atmHeading = "Orientamento",
                atmId = "ID",
                atmModel = "Modello ATM",
                centerX = "Centro X",
                centerY = "Centro Y",
                centerZ = "Centro Z",
                deliveryMethod = "Metodo di consegna",
                description = "Descrizione",
                enabled = "Attivo",
                groupKey = "Chiave gruppo",
                id = "ID",
                itemLabel = "Nome merce",
                itemName = "Nome item inventario",
                knownScammer = "Truffatore noto",
                locationName = "Nome posizione",
                observerW = "Direzione dell'osservatore",
                observerX = "Osservatore X",
                observerY = "Osservatore Y",
                observerZ = "Osservatore Z",
                pedModel = "Modello ped NPC",
                pickpocketItemChance = "Probabilità (%)",
                pickpocketItemMaximum = "Quantità massima",
                pickpocketItemMinimum = "Quantità minima",
                pickpocketItemName = "Nome oggetto inventario",
                quantity = "Quantità",
                radius = "Raggio",
                rating = "Valutazione mostrata",
                ratingCount = "Numero valutazioni mostrato",
                scamChance = "Probabilità di truffa del commerciante (%)",
                shopCategory = "Categoria",
                shopClerkHeading = "Direzione commesso",
                shopClerkModel = "Modello commesso",
                shopClerkRequired = "Commesso obbligatorio",
                shopClerkX = "Commesso X",
                shopClerkY = "Commesso Y",
                shopClerkZ = "Commesso Z",
                shopCodeEnabled = "Consenti apertura con codice",
                shopDrillEnabled = "Consenti perforazione",
                shopEnabled = "Abilitato",
                shopHackEnabled = "Consenti hacking",
                shopLocationId = "ID negozio",
                shopLocationLabel = "Etichetta",
                shopRegisterId = "ID cassa",
                shopSafeEnabled = "Cassaforte abilitata",
                shopSafeHeading = "Direzione cassaforte",
                shopSafeX = "Cassaforte X",
                shopSafeY = "Cassaforte Y",
                shopSafeZ = "Cassaforte Z",
                side = "Lato mercato",
                spawns = "La squadra si genera",
                successfulTrades = "Scambi riusciti mostrati",
                title = "Titolo annuncio",
                unitPrice = "Prezzo unitario",
                verified = "Commerciante verificato",
                w = "Intestazione",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Posizione commesso",
                shopRegisterPosition = "Posizione cassa",
                shopSafePosition = "Posizione cassaforte",
                registerId = "ID del registratore di cassa",
                registerX = "Coordinata X della cassa",
                registerY = "Coordinata Y della cassa",
                registerZ = "Coordinata Z della cassa",
                heading = "Orientamento",
                captureLocation = "Acquisisci posizione",
            },
            crimeDashboard = {
                jobs = "Gestisci fazioni, membri, permessi e posizioni.",
                jobCreator = "Seleziona una fazione per modificarne le posizioni e le aree.",
                jobsQuestion = "Dove modifico fazioni e posizioni?",
                jobsAnswer = "Apri {path}, seleziona una fazione e scegli Modifica. Lì puoi configurarne le impostazioni e le posizioni.",
                creatorsAnswer = "I creatori si trovano in {path}. Questi collegamenti aprono l’editor; gli strumenti delle fazioni iniziano dalla selezione della fazione.",
                missingAnswer = "I creatori disponibili dipendono dalla risorsa selezionata e dalle sue impostazioni. Gli strumenti delle fazioni iniziano dalla fazione interessata.",
                creators = {
                    mainbaseZones = "Seleziona una fazione e configura l’area della sua base.",
                    presetTerritories = "Controlla i distretti predefiniti e scegli quali attivare.",
                    objectsSection = "Gestisci le sedie per interrogatori e i carrelli degli attrezzi permanenti.",
                    blockedZonesSection = "Definisci le aree dove non è possibile posizionare oggetti per interrogatori.",
                    toolsSection = "Configura gli strumenti disponibili durante gli interrogatori.",
                    sessionsSection = "Visualizza gli interrogatori attivi e termina le sessioni quando necessario.",
                    orphansSection = "Controlla e rimuovi gli oggetti per interrogatori abbandonati.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Scegli come le organizzazioni criminali memorizzano e gestiscono i propri membri.",
                },
                territories = {
                    zones = "Configura «Zone territoriali» nella sezione «Territori».",
                    ownership = "Configura «Proprietà» nella sezione «Territori».",
                    decay = "Configura «Decadimento» nella sezione «Territori».",
                    presence = "Configura «Presenza» nella sezione «Territori».",
                    activity = "Configura «Punteggio attività» nella sezione «Territori».",
                    ownershipBenefits = "Configura «Vantaggi di proprietà» nella sezione «Territori».",
                },
                graffiti = {
                    general = "Configura «Generale» nella sezione «Graffiti».",
                    streaming = "Configura «Rendering» nella sezione «Graffiti».",
                    moderation = "Configura «Moderazione» nella sezione «Graffiti».",
                },
                pvpEvents = {
                    pvpAvailability = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpAutomation = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpRuntime = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpModes = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpArenas = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpLimits = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpPermissions = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    pvpTakeoverRules = "Gestisce la disponibilità e i requisiti per conquistare laboratori e camper.",
                    pvpTakeoverZones = "Configura le aree di interazione, allerta e conquista insieme alle loro durate.",
                    pvpTakeoverMethods = "Configura il tempo necessario a ogni metodo per forzare un ingresso.",
                },
                drugs = {
                    creator = "Apre l'editor di droghe Sky Crime e chiude il configuratore dei lavori.",
                    creatorSettings = "Configura «Impostazioni dell'editor» nella sezione «Sistema delle droghe».",
                    interfaceHud = "Configura «Posizioni interfaccia» nella sezione «Sistema delle droghe».",
                    drugsGeneral = "Configura «Generale» nella sezione «Sistema delle droghe».",
                    runtimeAccess = "Configura «Accesso e proprietà» nella sezione «Sistema delle droghe».",
                    runtimePayouts = "Configura «Pagamenti» nella sezione «Sistema delle droghe».",
                    runtimeDispatch = "Configura «Centrale e polizia» nella sezione «Sistema delle droghe».",
                    performanceInactiveControlIntervalMs = "Parametro di funzionamento per Prestazioni / Inattivo / Controllo / Intervallo / ms.",
                    performanceInteractionIdleScanIntervalMs = "Parametro di funzionamento per Prestazioni / Interazione / Inattivo / Intervallo di scansione / ms.",
                    performanceInteractionPromptIntervalMs = "Parametro di funzionamento per Prestazioni / Interazione / Avviso di interazione / Intervallo / ms.",
                    performanceInteractionScanIntervalMs = "Parametro di funzionamento per Prestazioni / Interazione / Intervallo di scansione / ms.",
                    performanceMinimumScanIntervalMs = "Parametro di funzionamento per Prestazioni / Minimo / Intervallo di scansione / ms.",
                    performanceStreetPedActivationDistance = "Parametro di funzionamento per Prestazioni / Strada / Ped / Attivazione / Distanza.",
                    performanceStreetPedIdleScanIntervalMs = "Parametro di funzionamento per Prestazioni / Strada / Ped / Inattivo / Intervallo di scansione / ms.",
                    performanceStreetPedScanIntervalMs = "Parametro di funzionamento per Prestazioni / Strada / Ped / Intervallo di scansione / ms.",
                    performanceWorldCachePadding = "Parametro di funzionamento per Prestazioni / Mondo / Cache / Margine aggiuntivo.",
                    performanceWorldCacheRefreshIntervalMs = "Parametro di funzionamento per Prestazioni / Mondo / Cache / Aggiornamento / Intervallo / ms.",
                    performanceWorldIdleIntervalMs = "Parametro di funzionamento per Prestazioni / Mondo / Inattivo / Intervallo / ms.",
                },
                drugProduction = {
                    qualityWeights = "Configura «Qualità / Pesi» nella sezione «Produzione di droghe».",
                    qualityTiers = "Configura «Qualità / Livelli di qualità» nella sezione «Produzione di droghe».",
                    packagingGeneral = "Configura «Generale» nella sezione «Produzione di droghe».",
                    processingFlow = "Configura «Flusso di lavorazione» nella sezione «Produzione di droghe».",
                    processingGeneral = "Configura «Generale» nella sezione «Produzione di droghe».",
                },
                drugOperations = {
                    growingGeneral = "Configura «Generale» nella sezione «Attività della droga».",
                    plantDefaults = "Configura «Pianta / Valori predefiniti» nella sezione «Attività della droga».",
                    harvestWindow = "Configura «Raccolta / Finestra temporale» nella sezione «Attività della droga».",
                    labsGeneral = "Attiva: laboratori e camper nel gioco.",
                    labRent = "Configura «Affitto e ciclo di vita» nella sezione «Attività della droga».",
                    camperDefaults = "Configura «Camper» nella sezione «Attività della droga».",
                    labUpgrades = "Moltiplicatore per Laboratorio / Livello / Miglioramento / Prezzi.",
                    labDefaults = "Configura «Laboratorio / Valori predefiniti» nella sezione «Attività della droga».",
                    powerGeneral = "Configura «Generale» nella sezione «Attività della droga».",
                    generators = "Configura «Generatori» nella sezione «Attività della droga».",
                    equipmentWear = "Moltiplicatore globale per Usura Attrezzatura / Lavorazione.",
                    workersGeneral = "Configura «Generale» nella sezione «Attività della droga».",
                    cultivationGeneral = "Configura «Generale» nella sezione «Attività della droga».",
                    cultivationCurve = "Configura nome e soglia XP totale per ogni livello di coltivazione.",
                    cultivationExperience = "Configura quanta XP di coltivazione assegna ogni azione.",
                    cultivationUnlocks = "Configura il livello richiesto per contenitori, substrati, attrezzatura, varietà e livelli dello scanner.",
                    powerRuntime = "Intervallo in secondi per aggiornamento del consumo dei generatori e delle tracce elettriche.",
                    powerHeat = "Configura «Sospetto e traccia elettrica» nella sezione «Attività della droga».",
                    powerModes = "Configura «Trattamento / Modalità» nella sezione «Attività della droga».",
                    powerPriorities = "Configura «Carico / Priorità» nella sezione «Attività della droga».",
                },
                drugMarketRisk = {
                    marketGeneral = "Configura «Generale» nella sezione «Mercato e rischi».",
                    marketPrices = "Configura «Prezzi» nella sezione «Mercato e rischi».",
                    distribution = "Configura «Distribuzione» nella sezione «Mercato e rischi».",
                    threatsGeneral = "Configura «Generale» nella sezione «Mercato e rischi».",
                    threatHeat = "Configura «Pressione della polizia» nella sezione «Mercato e rischi».",
                    threatChances = "Configura «Probabilità» nella sezione «Mercato e rischi».",
                    consumptionGeneral = "Configura «Generale» nella sezione «Mercato e rischi».",
                    consumerDecay = "Configura «Riduzione di tolleranza e dipendenza» nella sezione «Mercato e rischi».",
                    consumerEffects = "Configura «Effetti e rischi» nella sezione «Mercato e rischi».",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Parametro di funzionamento per Mercato Dinamico / Bonus di crescita di qualità / secondi.",
                    dynamicMarketActionHistoryLimit = "Parametro di funzionamento per Mercato Dinamico / Azione / Limite cronologia.",
                    dynamicMarketAmountSaturationWeight = "Parametro di funzionamento per Mercato Dinamico / Quantità / Saturazione / Peso.",
                    dynamicMarketBaseIntelAccuracy = "Parametro di funzionamento per Mercato Dinamico / Valore base / Precisione dell'intelligence.",
                    dynamicMarketDefaultAverageQuality = "Parametro di funzionamento per Mercato Dinamico / Valore predefinito / Media / Qualità.",
                    dynamicMarketDefaultResourceElasticity = "Parametro di funzionamento per Mercato Dinamico / Valore predefinito / Risorsa / Elasticità.",
                    dynamicMarketDemandCenter = "Parametro di funzionamento per Mercato Dinamico / Domanda / Valore centrale.",
                    dynamicMarketDemandPriceImpact = "Parametro di funzionamento per Mercato Dinamico / Domanda / Prezzo / Impatto.",
                    dynamicMarketDirectionThreshold = "Parametro di funzionamento per Mercato Dinamico / Direzione / Soglia.",
                    dynamicMarketEnabled = "Parametro di funzionamento per Mercato Dinamico / Abilitato.",
                    dynamicMarketEventChance = "Parametro di funzionamento per Mercato Dinamico / Evento / Possibilità.",
                    dynamicMarketEventDurationMinutes = "Parametro di funzionamento per Mercato Dinamico / Evento / Durata / Minuti.",
                    dynamicMarketEventMinimumDurationMinutes = "Parametro di funzionamento per Mercato Dinamico / Evento / Minimo / Durata / Minuti.",
                    dynamicMarketEventStrengthMaximum = "Parametro di funzionamento per Mercato Dinamico / Evento / Intensità / Massimo.",
                    dynamicMarketEventStrengthMinimum = "Parametro di funzionamento per Mercato Dinamico / Evento / Intensità / Minimo.",
                    dynamicMarketEvents = "Configura «Eventi» nella sezione «Reti della droga».",
                    dynamicMarketExactIntelReputation = "Parametro di funzionamento per Mercato Dinamico / Informazioni esatte / Reputazione.",
                    dynamicMarketExactIntelTrust = "Parametro di funzionamento per Mercato Dinamico / Informazioni esatte / Fiducia.",
                    dynamicMarketGlobalZoneLabel = "Parametro di funzionamento per Mercato Dinamico / Globale / Zona / Etichetta.",
                    dynamicMarketHistoryLimit = "Parametro di funzionamento per Mercato Dinamico / Limite cronologia.",
                    dynamicMarketInitialDemand = "Parametro di funzionamento per Mercato Dinamico / Valore iniziale / Domanda.",
                    dynamicMarketInitialPriceMultiplier = "Parametro di funzionamento per Mercato Dinamico / Valore iniziale / Moltiplicatore Prezzo.",
                    dynamicMarketIntelDemandError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Domanda / Errore.",
                    dynamicMarketIntelMaximumAccuracy = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Massimo / Precisione.",
                    dynamicMarketIntelMinimumAccuracy = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Minimo / Precisione.",
                    dynamicMarketIntelPoliceError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Polizia / Errore.",
                    dynamicMarketIntelPriceError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Errore.",
                    dynamicMarketIntelPriceMaximum = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Massimo.",
                    dynamicMarketIntelPriceMinimum = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Minimo.",
                    dynamicMarketIntelReputationWeight = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Reputazione / Peso.",
                    dynamicMarketIntelResourcePriceError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Risorsa / Prezzo / Errore.",
                    dynamicMarketIntelSaturationError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Saturazione / Errore.",
                    dynamicMarketIntelSeedBucketSeconds = "Parametro di funzionamento per Mercato Dinamico / Finestra del seme delle informazioni / secondi.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Stato / Precisione / Soglia.",
                    dynamicMarketIntelStatusErrorThreshold = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Stato / Errore / Soglia.",
                    dynamicMarketIntelSupplyError = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Fornitura / Errore.",
                    dynamicMarketIntelTrustWeight = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Fiducia / Peso.",
                    dynamicMarketManipulationCooldownMinutes = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Minuti tempo di attesa.",
                    dynamicMarketManipulationDemandShift = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Domanda / Variazione.",
                    dynamicMarketManipulationDurationMinutes = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Durata / Minuti.",
                    dynamicMarketManipulationHeat = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Pressione della polizia.",
                    dynamicMarketManipulationMinimumBatchAmount = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Minimo / Lotto / Quantità.",
                    dynamicMarketManipulationPaymentAccount = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Conto di pagamento.",
                    dynamicMarketManipulationPrice = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Prezzo.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Zona / Pressione della polizia / Moltiplicatore.",
                    dynamicMarketMaximumIntelAgeMinutes = "Parametro di funzionamento per Mercato Dinamico / Massimo / Età dell'intelligence / Minuti.",
                    dynamicMarketMaximumPriceMultiplier = "Parametro di funzionamento per Mercato Dinamico / Massimo / Moltiplicatore Prezzo.",
                    dynamicMarketMinimumIntelAgeMinutes = "Parametro di funzionamento per Mercato Dinamico / Minimo / Età dell'intelligence / Minuti.",
                    dynamicMarketMinimumMetricWindowMinutes = "Parametro di funzionamento per Mercato Dinamico / Minimo / Metrica / Finestra temporale / Minuti.",
                    dynamicMarketMinimumPriceMultiplier = "Parametro di funzionamento per Mercato Dinamico / Prezzo minimo / Moltiplicatore.",
                    dynamicMarketMinimumUpdateMinutes = "Parametro di funzionamento per Mercato Dinamico / Minimo / Aggiornamento / Minuti.",
                    dynamicMarketPoliceDemandWeight = "Parametro di funzionamento per Mercato Dinamico / Polizia / Domanda / Peso.",
                    dynamicMarketPolicePriceImpact = "Parametro di funzionamento per Mercato Dinamico / Polizia / Prezzo / Impatto.",
                    dynamicMarketPoorQualityDemandPenalty = "Parametro di funzionamento per Mercato Dinamico / Scarsa qualità / Domanda / Penalità.",
                    dynamicMarketPoorQualityThreshold = "Parametro di funzionamento per Mercato Dinamico / Scarsa qualità / Soglia.",
                    dynamicMarketPremiumQualityDemandBonus = "Parametro di funzionamento per Mercato Dinamico / Qualità premium / Bonus domanda.",
                    dynamicMarketPremiumQualityThreshold = "Parametro di funzionamento per Mercato Dinamico / Qualità premium / Soglia.",
                    dynamicMarketProductionSupplyWeight = "Parametro di funzionamento per Mercato Dinamico / Produzione / Fornitura / Peso.",
                    dynamicMarketProductionWindowMinutes = "Parametro di funzionamento per Mercato Dinamico / Produzione / Finestra temporale / Minuti.",
                    dynamicMarketQualityCenter = "Parametro di funzionamento per Mercato Dinamico / Qualità / Valore centrale.",
                    dynamicMarketQualityConfidenceImpact = "Parametro di funzionamento per Mercato Dinamico / Qualità / Affidabilità / Impatto.",
                    dynamicMarketQualityRange = "Parametro di funzionamento per Mercato Dinamico / Qualità / Intervallo di valori.",
                    dynamicMarketRarityBonusMaximum = "Parametro di funzionamento per Mercato Dinamico / Rarità / Bonus / Massimo.",
                    dynamicMarketRegionalGlobalWeight = "Parametro di funzionamento per Mercato Dinamico / Regionale / Globale / Peso.",
                    dynamicMarketRegionalLocalWeight = "Parametro di funzionamento per Mercato Dinamico / Regionale / Locale / Peso.",
                    dynamicMarketResourceAliases = "Configura «Risorsa / Alias» nella sezione «Reti della droga».",
                    dynamicMarketResourceDirectionFallThreshold = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Direzione / Calo / Soglia.",
                    dynamicMarketResourceDirectionRiseThreshold = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Direzione / Aumento / Soglia.",
                    dynamicMarketResources = "Configura «Risorse» nella sezione «Reti della droga».",
                    dynamicMarketSalesWindowMinutes = "Parametro di funzionamento per Mercato Dinamico / Vendite / Finestra temporale / Minuti.",
                    dynamicMarketSaturationDemandWeight = "Parametro di funzionamento per Mercato Dinamico / Saturazione / Domanda / Peso.",
                    dynamicMarketSaturationPriceImpact = "Parametro di funzionamento per Mercato Dinamico / Saturazione / Prezzo / Impatto.",
                    dynamicMarketScarcityDemandWeight = "Parametro di funzionamento per Mercato Dinamico / Scarsità / Domanda / Peso.",
                    dynamicMarketScarcityPriceImpact = "Parametro di funzionamento per Mercato Dinamico / Scarsità / Prezzo / Impatto.",
                    dynamicMarketSeasonEndMonths = "Configura «Stagione / Fine / Mesi» nella sezione «Reti della droga».",
                    dynamicMarketSeasonMultipliers = "Configura «Stagione / Moltiplicatori» nella sezione «Reti della droga».",
                    dynamicMarketShortageRumorThreshold = "Parametro di funzionamento per Mercato Dinamico / Carenza / Voce / Soglia.",
                    dynamicMarketStatusThresholds = "Configura «Stato / Soglie» nella sezione «Reti della droga».",
                    dynamicMarketTargetSupply = "Parametro di funzionamento per Mercato Dinamico / Obiettivo / Fornitura.",
                    dynamicMarketTrendChance = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Possibilità.",
                    dynamicMarketTrendDurationMinutes = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Durata / Minuti.",
                    dynamicMarketTrendMaximumStrength = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Massimo / Intensità.",
                    dynamicMarketTrendMinimumStrength = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Minimo / Intensità.",
                    dynamicMarketUpdateMinutes = "Parametro di funzionamento per Mercato Dinamico / Aggiornamento / Minuti.",
                    dynamicMarketVolatilityMaximum = "Parametro di funzionamento per Mercato Dinamico / Volatilità / Massimo.",
                    dynamicMarketVolatilityMinimum = "Parametro di funzionamento per Mercato Dinamico / Volatilità / Minimo.",
                    dynamicMarketWeatherMultipliers = "Configura «Meteo / Moltiplicatori» nella sezione «Reti della droga».",
                    dynamicMarketWeatherState = "Parametro di funzionamento per Mercato Dinamico / Meteo / Stato.",
                    heatActionCooldownSeconds = "Parametro di funzionamento per Sospetto e rischio / Bonus di crescita di qualità / secondi.",
                    heatActivityRiskWeights = "Configura «Attività / Rischio / Pesi» nella sezione «Reti della droga».",
                    heatAggressiveHeatMultiplier = "Parametro di funzionamento per Sospetto e rischio / Modalità aggressiva / Pressione della polizia / Moltiplicatore.",
                    heatBurnerBurnThreshold = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Compromissione / Soglia.",
                    heatBurnerHeatPerWholesale = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Pressione della polizia / Per vendita all'ingrosso.",
                    heatBurnerPhoneItem = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Oggetto.",
                    heatCamperOperationalHeatMultiplier = "Parametro di funzionamento per Sospetto e rischio / Camper in funzione / Pressione della polizia / Moltiplicatore.",
                    heatCamperOperationalHeatThreshold = "Parametro di funzionamento per Sospetto e rischio / Camper in funzione / Pressione della polizia / Soglia.",
                    heatCamperParkedHeat = "Parametro di funzionamento per Sospetto e rischio / Camper parcheggiato / Pressione della polizia.",
                    heatContaminatedHeatMultiplier = "Parametro di funzionamento per Sospetto e rischio / Contaminazione / Pressione della polizia / Moltiplicatore.",
                    heatContaminatedThreshold = "Parametro di funzionamento per Sospetto e rischio / Contaminazione / Soglia.",
                    heatCultivationFreePlants = "Parametro di funzionamento per Sospetto e rischio / Coltivazione / Piante senza rischio aggiuntivo.",
                    heatCultivationHeatPerPlant = "Parametro di funzionamento per Sospetto e rischio / Coltivazione / Pressione della polizia / Per pianta.",
                    heatDealerHiddenMinutes = "Parametro di funzionamento per Sospetto e rischio / Rivenditore / nascosto / Minuti.",
                    heatDecayPerTick = "Configura «Decadimento / Per ciclo di aggiornamento» nella sezione «Reti della droga».",
                    heatEnabled = "Parametro di funzionamento per Sospetto e rischio / Abilitato.",
                    heatEnforcementHeat = "Configura «Presenza della polizia / Pressione della polizia» nella sezione «Reti della droga».",
                    heatEnforcementMultipliers = "Configura «Presenza della polizia / Moltiplicatori» nella sezione «Reti della droga».",
                    heatEntityTypes = "Configura «Entità / Tipi» nella sezione «Reti della droga».",
                    heatEventCooldownMinutes = "Parametro di funzionamento per Sospetto e rischio / Evento / Minuti tempo di attesa.",
                    heatEventHistoryLimit = "Parametro di funzionamento per Sospetto e rischio / Evento / Limite cronologia.",
                    heatLabHeatSyncThreshold = "Parametro di funzionamento per Sospetto e rischio / Laboratorio / Pressione della polizia / Sincronizzazione / Soglia.",
                    heatLayLowCooldownMinutes = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Minuti tempo di attesa.",
                    heatLayLowIdleMinutes = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Inattivo / Minuti.",
                    heatLayLowReduction = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Riduzione.",
                    heatLockdownMinutes = "Parametro di funzionamento per Sospetto e rischio / Lockdown / Minuti.",
                    heatMinimumDurationMinutes = "Parametro di funzionamento per Sospetto e rischio / Minimo / Durata / Minuti.",
                    heatMinimumEventCooldownSeconds = "Parametro di funzionamento per Sospetto e rischio / Minimo / Evento / Cooldown (secondi).",
                    heatMinimumIdleSeconds = "Parametro di funzionamento per Sospetto e rischio / Minimo / Inattivo / secondi.",
                    heatProcessingHeatMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavorazione / Pressione della polizia / Moltiplicatore.",
                    heatRiskWeights = "Configura «Rischio / Pesi» nella sezione «Reti della droga».",
                    heatRotateBurnerReduction = "Parametro di funzionamento per Sospetto e rischio / Cambia telefono usa e getta / Riduzione.",
                    heatRouteControlMinutes = "Parametro di funzionamento per Sospetto e rischio / Percorso / Controllo / Minuti.",
                    heatSaleHeat = "Configura «Vendita / Pressione della polizia» nella sezione «Reti della droga».",
                    heatThresholds = "Configura «Soglie» nella sezione «Reti della droga».",
                    heatTickMinutes = "Parametro di funzionamento per Sospetto e rischio / Ciclo di aggiornamento / Minuti.",
                    heatWholesaleHeatMultiplier = "Parametro di funzionamento per Sospetto e rischio / Commercio all'ingrosso / Pressione della polizia / Moltiplicatore.",
                    heatWorkerLeakAlertRadius = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Raggio d'allerta.",
                    heatWorkerLeakBaseChance = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Valore base / Possibilità.",
                    heatWorkerLeakFactionMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Fazione / Moltiplicatore.",
                    heatWorkerLeakHighSeverityThreshold = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Alto / Gravità / Soglia.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Possibilità / Moltiplicatore.",
                    heatWorkerLeakLoyaltyThreshold = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Soglia.",
                    heatWorkerLeakMaximumChance = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Massimo / Possibilità.",
                    heatWorkerLeakMinimumCooldownSeconds = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Minimo / Cooldown (secondi).",
                    heatWorkerLeakRouteMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Percorso / Moltiplicatore.",
                    heatWorkerLeakStrengthMaximum = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Massimo.",
                    heatWorkerLeakStrengthMinimum = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Minimo.",
                    heatWorkerLeakStrengthMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Moltiplicatore.",
                    heatWorkerLeakStressChanceMultiplier = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Possibilità / Moltiplicatore.",
                    heatWorkerLeakStressThreshold = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Soglia.",
                    contactsActionCooldownSeconds = "Parametro di funzionamento per Rete di contatti / Bonus di crescita di qualità / secondi.",
                    contactsActiveHotspotCount = "Parametro di funzionamento per Rete di contatti / Numero di zone attive.",
                    contactsBurnerHintTrust = "Parametro di funzionamento per Rete di contatti / Suggerimento burner / Fiducia.",
                    contactsBurnerOfferMaximumMultiplier = "Parametro di funzionamento per Rete di contatti / Telefono usa e getta / Offerta / Massimo / Moltiplicatore.",
                    contactsBurnerOfferMinimumMultiplier = "Parametro di funzionamento per Rete di contatti / Telefono usa e getta / Offerta / Minimo / Moltiplicatore.",
                    contactsBuyerCooldownMinutes = "Parametro di funzionamento per Rete di contatti / Acquirente / Minuti tempo di attesa.",
                    contactsBuyerDeliveryDistance = "Parametro di funzionamento per Rete di contatti / Acquirente / Distanza di consegna.",
                    contactsBuyerPremiumSuccessScore = "Parametro di funzionamento per Rete di contatti / Acquirente / Premium / Successo / Punteggio.",
                    contactsBuyerPremiumTrustGain = "Parametro di funzionamento per Rete di contatti / Acquirente / Premium / Fiducia / guadagno.",
                    contactsBuyerRequestHeatRiskWeight = "Parametro di funzionamento per Rete di contatti / Acquirente / Richiesta / Calore e Rischio / Peso.",
                    contactsBuyerStandardTrustGain = "Parametro di funzionamento per Rete di contatti / Acquirente / Norma / Fiducia / guadagno.",
                    contactsContactActiveDelaySeconds = "Configura «Attesa per attivazione contatto / secondi» nella sezione «Reti della droga».",
                    contactsContactDemandRange = "Configura «Contatto / Domanda / Intervallo di valori» nella sezione «Reti della droga».",
                    contactsContactLossTrust = "Parametro di funzionamento per Rete di contatti / Contatto / Perdita / Fiducia.",
                    contactsDarknetExactIntelMinutes = "Parametro di funzionamento per Rete di contatti / Darknet / Informazioni esatte / Minuti.",
                    contactsDarknetHotspotIntelPrice = "Parametro di funzionamento per Rete di contatti / Darknet / Zona attiva / Informazioni / Prezzo.",
                    contactsDarknetIntelPrice = "Parametro di funzionamento per Rete di contatti / Darknet / Informazioni / Prezzo.",
                    contactsDealerBasePrice = "Parametro di funzionamento per Rete di contatti / Rivenditore / Prezzo Base.",
                    contactsDealerHireCapacity = "Configura «Rivenditore / Assunzione / capacità» nella sezione «Reti della droga».",
                    contactsDealerHireRisk = "Configura «Rivenditore / Assunzione / Rischio» nella sezione «Reti della droga».",
                    contactsDealerHireSkill = "Configura «Rivenditore / Assunzione / Abilità» nella sezione «Reti della droga».",
                    contactsDealerOffers = "Configura «Offerte spacciatori» nella sezione «Reti della droga».",
                    contactsDealerProtectionHours = "Parametro di funzionamento per Rete di contatti / Rivenditore / Protezione / Ore.",
                    contactsDealerProtectionPrice = "Parametro di funzionamento per Rete di contatti / Rivenditore / Protezione / Prezzo.",
                    contactsDealerSaleMax = "Parametro di funzionamento per Rete di contatti / Rivenditore / Vendita / Massimo.",
                    contactsDealerSaleMin = "Parametro di funzionamento per Rete di contatti / Rivenditore / Vendita / Minimo.",
                    contactsDealerSimulation = "Configura «Rivenditore / Simulazione» nella sezione «Reti della droga».",
                    contactsDealerTickMinutes = "Parametro di funzionamento per Rete di contatti / Rivenditore / Ciclo di aggiornamento / Minuti.",
                    contactsDealerWage = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario.",
                    contactsDealerWageDecay = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario / Decadimento.",
                    contactsDealerWageLoyaltyGain = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario / Lealtà / guadagno.",
                    contactsDealerWeaknesses = "Configura «Rivenditore / Debolezze» nella sezione «Reti della droga».",
                    contactsDefaultContactDemand = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Contatto / Domanda.",
                    contactsDefaultContactRisk = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Contatto / Rischio.",
                    contactsDefaultDealerCapacity = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / capacità.",
                    contactsDefaultDealerRisk = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / Rischio.",
                    contactsDefaultDealerSkill = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / Abilità.",
                    contactsDefaultHotspotRadius = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Zona attiva / Raggio.",
                    contactsDemandResetMinutes = "Parametro di funzionamento per Rete di contatti / Reset domanda (minuti).",
                    contactsEnabled = "Parametro di funzionamento per Rete di contatti / Abilitato.",
                    contactsExactLocationTrust = "Parametro di funzionamento per Rete di contatti / Posizione esatta / Fiducia.",
                    contactsFactionDiscoveryReputation = "Parametro di funzionamento per Rete di contatti / Fazione / Scoperta / Reputazione.",
                    contactsFactionHintTrust = "Parametro di funzionamento per Rete di contatti / Fazione / Indizio / Fiducia.",
                    contactsFailedDeliveryCooldownMinutes = "Parametro di funzionamento per Rete di contatti / Consegna fallita / Minuti tempo di attesa.",
                    contactsFakeDealEncounter = "Configura «Finto affare / Incontro» nella sezione «Reti della droga».",
                    contactsFallbackPreferredDrug = "Parametro di funzionamento per Rete di contatti / Valore sostitutivo / Droga Preferita.",
                    contactsFallbackProductLabel = "Parametro di funzionamento per Rete di contatti / Valore sostitutivo / Etichetta prodotto.",
                    contactsGuideBookItem = "Parametro di funzionamento per Rete di contatti / Guida / Libro / Oggetto.",
                    contactsGuideBookTrust = "Parametro di funzionamento per Rete di contatti / Guida / Libro / Fiducia.",
                    contactsHireDealerPrice = "Parametro di funzionamento per Rete di contatti / Assumi dealer / Prezzo.",
                    contactsHistoryLimit = "Parametro di funzionamento per Rete di contatti / Limite cronologia.",
                    contactsHotspotIntelMinutes = "Parametro di funzionamento per Rete di contatti / Zona attiva / Informazioni / Minuti.",
                    contactsHotspotRotationMinutes = "Parametro di funzionamento per Rete di contatti / Zona attiva / Rotazione / Minuti.",
                    contactsListingDurationMinutes = "Parametro di funzionamento per Rete di contatti / Annuncio / Durata / Minuti.",
                    contactsMaxOwnedDealers = "Parametro di funzionamento per Rete di contatti / Massimo / Di proprietà / Rivenditori.",
                    contactsMinimumBuyerDeliveryDistance = "Parametro di funzionamento per Rete di contatti / Minimo / Acquirente / Distanza di consegna.",
                    contactsMinimumContactRotationMinutes = "Parametro di funzionamento per Rete di contatti / Minimo / Rotazione contatti (minuti).",
                    contactsMinimumDemandResetMinutes = "Parametro di funzionamento per Rete di contatti / Minimo / Reset domanda (minuti).",
                    contactsMinimumHeatMultiplier = "Parametro di funzionamento per Rete di contatti / Minimo / Pressione della polizia / Moltiplicatore.",
                    contactsMinimumHotspotIntelMinutes = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Informazioni / Minuti.",
                    contactsMinimumHotspotRadius = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Raggio.",
                    contactsMinimumHotspotRotationMinutes = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Rotazione / Minuti.",
                    contactsMinimumListingDurationMinutes = "Parametro di funzionamento per Rete di contatti / Minimo / Annuncio / Durata / Minuti.",
                    contactsMinimumRewardMultiplier = "Parametro di funzionamento per Rete di contatti / Ricompensa minima / Moltiplicatore.",
                    contactsMinimumRobberyMultiplier = "Parametro di funzionamento per Rete di contatti / Minimo / Rapine / Moltiplicatore.",
                    contactsMinimumSpotPriceMultiplier = "Parametro di funzionamento per Rete di contatti / Minimo / Posizione / Moltiplicatore Prezzo.",
                    contactsOtherDrugPriceMultiplier = "Parametro di funzionamento per Rete di contatti / Altro / Droga / Moltiplicatore Prezzo.",
                    contactsPaymentAccount = "Parametro di funzionamento per Rete di contatti / Conto di pagamento.",
                    contactsPostDeliveryDemandResetSeconds = "Parametro di funzionamento per Rete di contatti / Dopo la consegna / Domanda / Reset / secondi.",
                    contactsPreferredDrugPriceMultiplier = "Parametro di funzionamento per Rete di contatti / Droga Preferita / Moltiplicatore Prezzo.",
                    contactsRegionLocationTrust = "Parametro di funzionamento per Rete di contatti / Regione / Posizione / Fiducia.",
                    contactsRequestAmounts = "Configura «Richiesta / Quantità» nella sezione «Reti della droga».",
                    contactsRotationMinutes = "Parametro di funzionamento per Rete di contatti / Rotazione / Minuti.",
                    contactsSpotPools = "Configura «Posizione / Gruppi di selezione» nella sezione «Reti della droga».",
                    contactsStreetHotspots = "Configura «Strada / Zone attive» nella sezione «Reti della droga».",
                    contactsTrustLevels = "Configura «Fiducia / Livelli» nella sezione «Reti della droga».",
                    businessActionCooldownSeconds = "Parametro di funzionamento per Rete di attività / Bonus di crescita di qualità / secondi.",
                    businessBalance = "Configura «Saldo» nella sezione «Reti della droga».",
                    businessContracts = "Configura «Contratti» nella sezione «Reti della droga».",
                    businessDefaultBusinessName = "Parametro di funzionamento per Rete di attività / Valore predefinito / Nome dell'azienda.",
                    businessDefaultRankId = "Parametro di funzionamento per Rete di attività / Valore predefinito / Classifica / ID.",
                    businessDefaultStaffStyle = "Parametro di funzionamento per Rete di attività / Valore predefinito / Personale / Stile di lavoro.",
                    businessDefaultTransport = "Parametro di funzionamento per Rete di attività / Valore predefinito / Trasporti.",
                    businessEnabled = "Parametro di funzionamento per Rete di attività / Abilitato.",
                    businessHubs = "Configura «Centri di distribuzione» nella sezione «Reti della droga».",
                    businessLimits = "Configura «Limiti» nella sezione «Reti della droga».",
                    businessPayments = "Scegli quale saldo paga gli acquisti e i costi operativi della rete commerciale.",
                    businessPayoutAccount = "Parametro di funzionamento per Rete di attività / Pagamento / Conto.",
                    businessRanks = "Configura «Gradi» nella sezione «Reti della droga».",
                    businessReportDays = "Parametro di funzionamento per Rete di attività / Periodo del rapporto / giorni.",
                    businessRouteEndpointTypes = "Configura «Percorso / Punto finale / Tipi» nella sezione «Reti della droga».",
                    businessRuntime = "Configura «Funzionamento in gioco» nella sezione «Reti della droga».",
                    businessSocietyPermission = "Parametro di funzionamento per Rete di attività / Organizzazione / Permesso.",
                    businessStaff = "Configura «Personale» nella sezione «Reti della droga».",
                    businessTickMinutes = "Parametro di funzionamento per Rete di attività / Ciclo di aggiornamento / Minuti.",
                    businessTransports = "Configura «Trasporti» nella sezione «Reti della droga».",
                },
                robbery = {
                    atmAvailability = "Attiva o disattiva il sistema autonomo di rapina ai bancomat.",
                    atmLocations = "Gestisce le posizioni autorizzate dal server per le rapine.",
                    atmPolice = "Configura il numero di agenti in servizio richiesto per iniziare.",
                    atmItems = "Configura gli oggetti richiesti per trapano, cinghia e carica esplosiva.",
                    atmActionTimes = "Imposta i tempi di fissaggio, piazzamento, detonazione e saccheggio.",
                    atmTimeouts = "Determina per quanto tempo un ATM aperto resta saccheggiabile.",
                    atmPayout = "Configura il conto di destinazione e l'intervallo casuale della ricompensa.",
                    atmDistances = "Imposta le distanze usate per giocatore e veicolo.",
                    atmExplosionEffects = "Configura i parametri della native usata per l'esplosione.",
                    atmDispatchAlert = "Configura raggio, durata e priorità dell'allarme di polizia.",
                    atmDispatchRecipients = "Sceglie i nomi dei job che ricevono gli allarmi ATM.",
                    shopAvailability = "Abilita le rapine e configura il requisito di polizia.",
                    shopTiming = "Configura intimidazione, azioni, scadenza e recupero.",
                    shopSafe = "Configura tentativi e oggetto trapano.",
                    shopRegisterReward = "Configura la ricompensa casuale di ogni cassa.",
                    shopSafeReward = "Configura la ricompensa della cassaforte.",
                    shopDispatchSettings = "Configura destinatari e proprietà dell'allarme.",
                    shopLocationTable = "Gestisce negozi con commesso e casseforti.",
                    pickpocketAvailability = "Abilita la funzione e la limita opzionalmente ai lavori criminali configurati.",
                    pickpocketGameplay = "Sceglie la sfida e le probabilità indipendenti di fuga, emergenza e contrattacco.",
                    pickpocketItemRewards = "Controlla tasche vuote e oggetti visibili fino allo 0,0001 percento.",
                    pickpocketMoney = "Configura l'intervallo casuale generato dal server.",
                    pickpocketDistances = "Imposta la portata NPC usata dal sistema radiale e target condiviso.",
                    pickpocketRateLimits = "Controlla limiti richieste, cooldown NPC e scadenza sessione.",
                    pickpocketDispatchSettings = "Configura l'allerta inviata quando un NPC chiama i soccorsi.",
                    heistCrafting = "Scegli quanta interazione richiede la creazione dell'equipaggiamento per i colpi. Si applica ai nuovi tentativi in tutto il sistema criminale.",
                    heistCreatorMenu = "Crea, modifica e pubblica colpi modulari nell'Heist Creator dedicato.",
                    heistExecution = "Finestra iniziale, inattività e attesa tra le sessioni del colpo.",
                    npcPoliceSupport = "Questa funzionalità è temporaneamente disattivata a causa di problemi di stabilità e al momento non può essere attivata nel Job Configurator.",
                },
                baseRaids = {
                    baseRaids = "Accesso, requisiti e categorie di bottino selezionabili. Nessun limite di tempo per il trasporto durante un’incursione.",
                },
                weapons = {
                    weaponCreatorMenu = "Gestisci rotte delle armi e riciclaggio in un unico editor.",
                    weaponRuntime = "Controlla la disponibilità e l’accesso alle rotte delle armi.",
                    weaponDefaultsgeneral = "Configura «Valori generali» nella sezione «Rotte delle armi».",
                    weaponDefaultsaccess = "Configura «Valori di accesso» nella sezione «Rotte delle armi».",
                    weaponDefaultscollection = "Configura «Valori di raccolta» nella sezione «Rotte delle armi».",
                    weaponDefaultsproduction = "Configura «Valori di produzione» nella sezione «Rotte delle armi».",
                    weaponDefaultsmarket = "Configura «Valori di mercato» nella sezione «Rotte delle armi».",
                    weaponDefaultsdelivery = "Configura «Valori degli ordini» nella sezione «Rotte delle armi».",
                    weaponStreet = "Configura «Vendita di armi in strada» nella sezione «Rotte delle armi».",
                },
                darknetMarket = {
                    darknetAvailability = "Controlla l'app tablet e la sua posizione.",
                    darknetEconomy = "Configura saldi wallet, cambio monete e tassi di pagamento.",
                    darknetListings = "Controlla limiti, prezzi e scadenza automatica.",
                    darknetChat = "Limita i messaggi cifrati del mercato.",
                    darknetIdentity = "Configura identità, verifica e avvisi truffa.",
                    darknetDelivery = "Configura incontri fisici e casse rubabili.",
                    darknetDeliveryLocations = "Configura gli elenchi di posizioni scelti casualmente per gli scambi BlackBay con NPC.",
                    darknetPolice = "Gruppi autorizzati a creare trappole e vedere le indagini.",
                    darknetNpcTraders = "Compratori e venditori NPC con rischio configurabile.",
                },
                interrogation = {
                    general = "Configura «Generale» nella sezione «Interrogatorio».",
                    consent = "Configura «Protezione giocatori» nella sezione «Interrogatorio».",
                    objects = "Configura «Oggetti» nella sezione «Interrogatorio».",
                    grab = "Configura «Sottomissione» nella sezione «Interrogatorio».",
                    session = "Configura «Sessione» nella sezione «Interrogatorio».",
                    dispatch = "Configura «Allarmi polizia» nella sezione «Interrogatorio».",
                    logging = "Configura «Registrazione» nella sezione «Interrogatorio».",
                    security = "Configura «Sicurezza» nella sezione «Interrogatorio».",
                    presentation = "Configura «Presentazione» nella sezione «Interrogatorio».",
                },
                reputation = {
                    crimeReputation = "Configura «Reputazione» nella sezione «Reputazione».",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Generale", description = "Controlla la disponibilità e l’accesso alle rotte delle armi." },
                weaponCreatorMenu = { label = "Creatore di imprese illegali", description = "Gestisci rotte delle armi e riciclaggio in un unico editor." },
                atmActionTimes = {
                    description = "Imposta i tempi di fissaggio, piazzamento, detonazione e saccheggio.",
                    label = "Durata delle azioni",
                },
                atmAvailability = {
                    description = "Attiva o disattiva il sistema autonomo di rapina ai bancomat.",
                    label = "Disponibilità",
                },
                atmDispatchAlert = {
                    description = "Configura raggio, durata e priorità dell'allarme di polizia.",
                    label = "Proprietà dell'allarme",
                },
                atmDispatchRecipients = {
                    description = "Sceglie i nomi dei job che ricevono gli allarmi ATM.",
                    label = "Destinatari",
                },
                atmDistances = {
                    description = "Imposta le distanze usate per giocatore e veicolo.",
                    label = "Distanze d'interazione",
                },
                atmExplosionEffects = {
                    description = "Configura i parametri della native usata per l'esplosione.",
                    label = "Effetti dell'esplosione",
                },
                atmItems = {
                    description = "Configura gli oggetti richiesti per trapano, cinghia e carica esplosiva.",
                    label = "Oggetti richiesti",
                },
                atmLocations = {
                    description = "Gestisce le posizioni autorizzate dal server per le rapine.",
                    label = "Posizioni ATM",
                },
                atmPayout = {
                    description = "Configura il conto di destinazione e l'intervallo casuale della ricompensa.",
                    label = "Pagamento",
                },
                atmPolice = {
                    description = "Configura il numero di agenti in servizio richiesto per iniziare.",
                    label = "Requisito di polizia",
                },
                atmPulling = {
                    description = "Configura il movimento necessario per strappare l'ATM dal muro.",
                    label = "Rilevamento del traino",
                },
                atmTimeouts = {
                    description = "Determina per quanto tempo un ATM aperto resta saccheggiabile.",
                    label = "Tempo di saccheggio",
                },
                baseRaids = {
                    description = "Accesso, requisiti e categorie di bottino selezionabili. Nessun limite di tempo per il trasporto durante un’incursione.",
                    label = "Incursioni nelle basi",
                },
                businessPayments = {
                    description = "Scegli quale saldo paga gli acquisti e i costi operativi della rete commerciale.",
                    label = "Pagamenti",
                },
                crimeMembership = {
                    description = "Scegli come le organizzazioni criminali memorizzano e gestiscono i propri membri.",
                    label = "Modello di appartenenza",
                },
                darknetAvailability = {
                    description = "Controlla l'app tablet e la sua posizione.",
                    label = "Disponibilità",
                },
                darknetChat = {
                    description = "Limita i messaggi cifrati del mercato.",
                    label = "Chat privata",
                },
                darknetDelivery = {
                    description = "Configura incontri fisici e casse rubabili.",
                    label = "Consegne e dead drop",
                },
                darknetDeliveryLocations = {
                    description = "Configura gli elenchi di posizioni scelti casualmente per gli scambi BlackBay con NPC.",
                    label = "Luoghi di consegna",
                },
                darknetEconomy = {
                    description = "Configura saldi wallet, cambio monete e tassi di pagamento.",
                    label = "Criptovaluta",
                },
                darknetIdentity = {
                    description = "Configura identità, verifica e avvisi truffa.",
                    label = "Alias e reputazione",
                },
                darknetListings = {
                    description = "Controlla limiti, prezzi e scadenza automatica.",
                    label = "Annunci e scadenza",
                },
                darknetNpcTraders = {
                    description = "Compratori e venditori NPC con rischio configurabile.",
                    label = "Commercianti NPC",
                },
                darknetPolice = {
                    description = "Gruppi autorizzati a creare trappole e vedere le indagini.",
                    label = "Accesso polizia",
                },
                heistCrafting = {
                    description = "Scegli quanta interazione richiede la creazione dell'equipaggiamento per i colpi. Si applica ai nuovi tentativi in tutto il sistema criminale.",
                    label = "Officina dei colpi",
                },
                heistCreatorMenu = {
                    description = "Crea, modifica e pubblica colpi modulari nell'Heist Creator dedicato.",
                    label = "Menu Creator",
                },
                heistExecution = {
                    description = "Finestra iniziale, inattività e attesa tra le sessioni del colpo.",
                    label = "Tempi del colpo",
                },
                moneywashEconomy = {
                    description = "Abilita le attività e configura il conto di deposito, la commissione e le distanze di interazione.",
                    label = "Generale",
                },
                npcPoliceSupport = {
                    description = "Questa funzionalità è temporaneamente disattivata a causa di problemi di stabilità e al momento non può essere attivata nel Job Configurator.",
                    label = "Supporto della polizia NPC (attualmente disattivato)",
                },
                pickpocketAvailability = {
                    description = "Abilita la funzione e la limita opzionalmente ai lavori criminali configurati.",
                    label = "Disponibilità",
                },
                pickpocketDispatchSettings = {
                    description = "Configura l'allerta inviata quando un NPC chiama i soccorsi.",
                    label = "Chiamata di emergenza",
                },
                pickpocketDistances = {
                    description = "Imposta la portata NPC usata dal sistema radiale e target condiviso.",
                    label = "Distanze di interazione",
                },
                pickpocketGameplay = {
                    description = "Sceglie la sfida e le probabilità indipendenti di fuga, emergenza e contrattacco.",
                    label = "Rischio e minigioco",
                },
                pickpocketItemRewards = {
                    description = "Controlla tasche vuote e oggetti visibili fino allo 0,0001 percento.",
                    label = "Contenuto visibile",
                },
                pickpocketMoney = {
                    description = "Configura l'intervallo casuale generato dal server.",
                    label = "Ricompensa in contanti",
                },
                pickpocketRateLimits = {
                    description = "Controlla limiti richieste, cooldown NPC e scadenza sessione.",
                    label = "Protezioni server",
                },
                pvpArenas = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpAutomation = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpAvailability = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpLimits = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpModes = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpPermissions = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpRuntime = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpTakeoverMethods = {
                    description = "Configura il tempo necessario a ogni metodo per forzare un ingresso.",
                    label = "Metodi di irruzione",
                },
                pvpTakeoverRules = {
                    description = "Gestisce la disponibilità e i requisiti per conquistare laboratori e camper.",
                    label = "Regole di conquista",
                },
                pvpTakeoverZones = {
                    description = "Configura le aree di interazione, allerta e conquista insieme alle loro durate.",
                    label = "Zone e tempistiche",
                },
                shopAvailability = {
                    description = "Abilita le rapine e configura il requisito di polizia.",
                    label = "Disponibilità",
                },
                shopDispatchSettings = {
                    description = "Configura destinatari e proprietà dell'allarme.",
                    label = "Allarme polizia",
                },
                shopLocationTable = {
                    description = "Gestisce negozi con commesso e casseforti.",
                    label = "Negozi",
                },
                shopRegisterReward = {
                    description = "Configura la ricompensa casuale di ogni cassa.",
                    label = "Ricompensa cassa",
                },
                shopRegisterTable = {
                    description = "Assegna casse individuali ai negozi.",
                    label = "Casse",
                },
                shopSafe = {
                    description = "Configura tentativi e oggetto trapano.",
                    label = "Cassaforte",
                },
                shopSafeReward = {
                    description = "Configura la ricompensa della cassaforte.",
                    label = "Ricompensa cassaforte",
                },
                shopTiming = {
                    description = "Configura intimidazione, azioni, scadenza e recupero.",
                    label = "Tempi",
                },
            },
            settingSections = {
                weapons = "Rotte delle armi",
                drugs = "Sistema delle droghe",
                drugProduction = "Produzione di droghe",
                drugOperations = "Attività della droga",
                drugMarketRisk = "Mercato e rischi",
                drugNetworks = "Reti della droga",
                atmRobbery = "Rapina ai bancomat",
                baseRaids = "Incursioni nelle basi",
                crimeOrganizations = "Organizzazioni",
                darknetMarket = "Mercato darknet",
                moneywash = "Riciclaggio di denaro",
                pvpEvents = "PvP di fazione",
                robbery = "Rapine",
                territories = "Territori",
                graffiti = "Graffiti",
                interrogation = "Interrogatorio",
            },
            settingSubsections = {
                baseRaidEquipment = "Equipaggiamento richiesto",
                baseRaidBreach = "Effrazione",
                baseRaidLoot = "Bottino e veicoli",
                graffitiLimits = "Limiti e moderazione",
                interrogationTechnical = "Registri e sicurezza",
                atmDispatch = "Allarme di polizia",
                atmEquipment = "Equipaggiamento",
                atmExplosion = "Esplosione",
                atmOverview = "Panoramica e posizioni",
                atmRewards = "Ricompense",
                atmTiming = "Tempi",
                atmVehicle = "Veicolo e traino",
                baseRaids = "Incursioni nelle basi",
                crimeMembership = "Appartenenza",
                heistCreator = "Creatore Heist",
                npcPoliceSupport = "Supporto della polizia NPC (attualmente disattivato)",
                pickpocket = "Borseggio NPC",
                pvpArenas = "Arene",
                pvpEquipment = "Modalità di gioco",
                pvpOverview = "Panoramica",
                pvpRuntime = "Durata della corrispondenza",
                pvpTakeovers = "Conquiste dei laboratori",
                shopRobbery = "Rapine ai negozi",
                atmRobbery = "Rapina ai bancomat",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Distanza di interazione" },
                weaponDefaultGeneralPedModel = { label = "Modello NPC predefinito" },
                weaponDefaultAccessActiveHourStart = { label = "Ora di apertura (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Ora di chiusura (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Poliziotti in servizio richiesti" },
                weaponDefaultAccessPoliceJobs = { label = "Lavori di polizia" },
                weaponDefaultCollectionDurationSeconds = { label = "Durata in secondi" },
                weaponDefaultCollectionCooldownSeconds = { label = "Attesa in secondi" },
                weaponDefaultCollectionCooldownScope = { label = "Ambito dell’attesa" },
                weaponDefaultCollectionUseMinigame = { label = "Usa minigioco" },
                weaponDefaultCollectionMinigame = { label = "Minigioco" },
                weaponDefaultCollectionMinigameRounds = { label = "Turni del minigioco" },
                weaponDefaultProductionDurationSeconds = { label = "Durata in secondi" },
                weaponDefaultProductionSuccessChance = { label = "Probabilità di successo (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Consuma ingredienti in caso di fallimento" },
                weaponDefaultProductionUseMinigame = { label = "Usa minigioco" },
                weaponDefaultProductionMinigame = { label = "Minigioco" },
                weaponDefaultProductionMinigameRounds = { label = "Turni del minigioco" },
                weaponDefaultProductionQualityMin = { label = "Qualità minima" },
                weaponDefaultProductionQualityMax = { label = "Qualità massima" },
                weaponDefaultProductionCooldownSeconds = { label = "Attesa in secondi" },
                weaponDefaultProductionCooldownScope = { label = "Ambito dell’attesa" },
                weaponDefaultMarketPayoutAccount = { label = "Conto di pagamento" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Fattore di prezzo minimo (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Fattore di prezzo massimo (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Intervallo di rifornimento in secondi" },
                weaponDefaultMarketCooldownSeconds = { label = "Attesa in secondi" },
                weaponDefaultMarketCooldownScope = { label = "Ambito dell’attesa" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Scadenza ordine in minuti" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Bonus ordine (%)" },
                weaponStreetEnabled = { label = "Vendite rare di armi ad acquirenti di strada" },
                weaponStreetChance = { label = "Probabilità di offerta arma (%)" },
                weaponStreetCooldown = { label = "Attesa in secondi" },
                weaponStreetAmount = { label = "Quantità massima" },
                weaponStreetPriceMin = { label = "Fattore di prezzo minimo (%)" },
                weaponStreetPriceMax = { label = "Fattore di prezzo massimo (%)" },
                weaponStreetAccount = { label = "Conto di pagamento" },
                weaponStreetDirect = { label = "Vendita diretta" },
                weaponStreetBulk = { label = "Vendita in blocco" },
                weaponStreetContract = { label = "Ordine del cartello" },
                weaponSystemEnabled = { label = "Sistema delle rotte delle armi", description = "Attiva la raccolta e la lavorazione di armi e la vendita ai cartelli." },
                weaponRuntimeEnabled = { label = "Azioni delle rotte delle armi", description = "Consenti di usare le rotte delle armi configurate nel mondo di gioco." },
                weaponCreatorAccess = { label = "Accesso al creatore di armi", description = "Scegli chi può aprire il creatore di armi.", options = { permission = "Solo con permesso", jobManagement = "Gestione del lavoro", ownerOnly = "Solo proprietario" } },
                openWeaponCreator = { label = "Creatore di imprese illegali", description = "Gestisci rotte delle armi e riciclaggio in un unico editor.", buttonLabel = "Creatore di imprese illegali", unsavedTooltip = "Salva prima" },

                drugCultivationProgressionEnabled = { label = "Abilita livelli di coltivazione", description = "Abilita XP di coltivazione, livelli e sblocchi basati sul livello." },
                drugCultivationMaxLevel = { label = "Livello massimo di coltivazione", description = "Livello di coltivazione massimo raggiungibile. I livelli superiori restano irraggiungibili." },
                drugCultivationLevels = { label = "Curva dei livelli", description = "Configura nome e soglia XP totale per ogni livello di coltivazione." },
                drugCultivationActionXp = { label = "Ricompense XP", description = "Configura quanta XP di coltivazione assegna ogni azione." },
                drugCultivationUnlocks = { label = "Sblocchi di livello", description = "Configura il livello richiesto per contenitori, substrati, attrezzatura, varietà e livelli dello scanner." },
                reputationRewards = { label = "Azioni reputazione", description = "Aggiungi azioni, modifica i punti e disattiva o elimina le voci. Solo le voci attive assegnano punti." },
                reputationEnabled = { label = "Attiva reputazione criminale", description = "Assegna reputazione personale." },
                reputationPointsPerLevel = { label = "Punti per livello", description = "Ogni livello richiede questo numero di punti aggiuntivi." },
                reputationMinimumJoinPoints = { label = "Reputazione minima per entrare", description = "Punti totali richiesti per entrare in una fazione criminale. 0 disattiva il requisito. I membri attuali mantengono l’accesso." },
                reputation_atm = { label = "Rapina al bancomat", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_shop_register = { label = "Cassa del negozio", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_shop_safe = { label = "Cassaforte del negozio", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_pickpocket = { label = "Borseggio", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_heist = { label = "Colpo completato", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_harvest = { label = "Raccolta di droga", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_processing = { label = "Lavorazione di droga", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_sale = { label = "Vendita di droga", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_delivery = { label = "Consegna di droga", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_contract = { label = "Contratto di distribuzione", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_drug_raid = { label = "Assalto per droga", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_graffiti = { label = "Graffiti", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_moneywash = { label = "Riciclaggio di denaro", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_base_raid = { label = "Assalto alla base", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                reputation_pvp_win = { label = "Vittoria PvP", description = "Punti per ogni azione completata con successo. 0 disattiva questa ricompensa." },
                atmChargeProp = {
                    description = "Modello dell'oggetto mostrato sull'ATM mentre la carica è piazzata.",
                    label = "Oggetto della carica",
                },
                atmConsumeDrill = {
                    description = "Consuma la quantità configurata dopo ogni punto di foratura del bancomat completato con successo.",
                    label = "Consuma trapano",
                },
                atmDrillItem = {
                    description = "ID dell’oggetto nell’inventario necessario per forare un bancomat sradicato. Impostazione separata dal trapano delle casseforti dei negozi.",
                    label = "Oggetto trapano",
                },
                atmDrillItemAmount = {
                    description = "Numero di oggetti trapano necessari per ogni punto di foratura del bancomat.",
                    label = "Quantità di trapani richiesta",
                },
                atmDebug = {
                    description = "Scrive diagnostica dettagliata delle rapine ATM nella console del server e nella console F8 del client.",
                    label = "Log di debug ATM",
                },
                atmDispatchDurationSeconds = {
                    description = "Secondi per cui l'allarme resta rilevante nel dispatch.",
                    label = "Durata dell'allarme",
                },
                atmDispatchEnabled = {
                    description = "Crea un intervento Jobs Base quando un ATM viene forzato.",
                    label = "Attiva allarme di polizia",
                },
                atmDispatchJobs = {
                    description = "Nomi dei job separati da virgole che ricevono l'allarme ATM.",
                    label = "Job dell'allarme",
                },
                atmDispatchPriority = {
                    description = "Valore di priorità passato invariato all'integrazione dispatch.",
                    label = "Priorità dell'allarme",
                },
                atmDispatchRadius = {
                    description = "Raggio approssimativo inviato all'integrazione dispatch.",
                    label = "Raggio dell'allarme",
                },
                atmEnabled = {
                    description = "Rende disponibili gli ATM configurati per cinghia ed esplosivo.",
                    label = "Attiva le rapine ATM",
                },
                atmExplosionCameraShake = {
                    description = "Intensità della scossa per il client che crea l'esplosione.",
                    label = "Scossa della telecamera",
                },
                atmExplosionDamageScale = {
                    description = "Forza di danno e impulso passata alla native dell'esplosione.",
                    label = "Potenza dell'esplosione",
                },
                atmExplosionType = {
                    description = "Tipo di esplosione GTA usato. Cambiarlo solo dopo un test in gioco.",
                    label = "Tipo di esplosione",
                },
                atmDrillDurationSeconds = {
                    label = "Tempo minimo di perforazione per vite (s)",
                    description = "Tempo minimo in secondi per ciascuna delle quattro viti. Le pause di raffreddamento prolungano il tentativo. Si applica ai tentativi di perforazione avviati dopo il salvataggio.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Secondi necessari per piazzare la carica esplosiva.",
                    label = "Durata piazzamento carica",
                },
                atmExplosiveItem = {
                    description = "Oggetto consumato dopo aver piazzato la carica.",
                    label = "Oggetto esplosivo",
                },
                atmExplosiveItemAmount = {
                    description = "Numero di cariche consumate per ogni piazzamento.",
                    label = "Quantità di esplosivo consumata",
                },
                atmFuseSeconds = {
                    description = "Secondi tra il piazzamento e la detonazione.",
                    label = "Durata della miccia",
                },
                atmInteractionDistance = {
                    description = "Portata massima del client; il server aggiunge un margine di sicurezza.",
                    label = "Distanza d'interazione",
                },
                atmLocations = {
                    description = "Posizioni di produzione autorizzate. Quelle create con /atmtest restano temporanee.",
                    itemLabel = "Posizione ATM",
                    label = "Posizioni ATM",
                },
                atmLootDurationSeconds = {
                    description = "Secondi necessari per aprire un ATM divelto.",
                    label = "Durata del saccheggio",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Secondi massimi per cui un giocatore riserva l'ATM; resta automaticamente superiore alla durata del saccheggio.",
                    label = "Timeout prenotazione saccheggio",
                },
                atmLootWindowMinutes = {
                    description = "Minuti per cui un ATM aperto resta saccheggiabile.",
                    label = "Finestra di saccheggio",
                },
                atmMinimumPolice = {
                    description = "Membri in servizio del gruppo di polizia richiesti per iniziare una rapina.",
                    label = "Polizia minima",
                },
                atmPoliceGroup = {
                    description = "Gruppo job di sky_jobs_base contato per il requisito di polizia.",
                    label = "Gruppo job della polizia",
                },
                atmPullDistance = {
                    description = "Spostamento del veicolo dalla posizione ATM necessario per aprirlo.",
                    label = "Distanza di traino richiesta",
                },
                atmPullMinimumSpeed = {
                    description = "Velocità minima del veicolo in metri al secondo al raggiungimento della distanza.",
                    label = "Velocità minima di traino",
                },
                atmReservationTimeoutSeconds = {
                    description = "Secondi massimi durante il fissaggio o il piazzamento; resta automaticamente superiore alla durata dell'azione.",
                    label = "Timeout prenotazione preparazione",
                },
                atmRewardAccount = {
                    description = "Scegli tra contanti e l'oggetto black_money.",
                    label = "Tipo di pagamento ATM",
                },
                atmRewardMaximum = {
                    description = "Pagamento massimo, mai inferiore al minimo.",
                    label = "Ricompensa massima",
                },
                atmRewardMinimum = {
                    description = "Pagamento minimo ottenibile da un ATM.",
                    label = "Ricompensa minima",
                },
                atmSlingDurationSeconds = {
                    description = "Secondi necessari per fissare la cinghia.",
                    label = "Durata fissaggio cinghia",
                },
                atmSlingItem = {
                    description = "Oggetto riutilizzabile richiesto per il metodo con veicolo.",
                    label = "Oggetto cinghia",
                },
                atmSlingItemAmount = {
                    description = "Numero di cinghie richiesto; non vengono consumate.",
                    label = "Quantità di cinghie richiesta",
                },
                atmTestScanDistance = {
                    description = "Distanza massima usata da /atmtest per cercare un modello ATM supportato.",
                    label = "Distanza scansione ATM",
                },
                atmVehicleMaxDistance = {
                    description = "Distanza massima tra ATM e veicolo idoneo quando si fissa la cinghia.",
                    label = "Distanza del veicolo",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Tempo massimo per ogni tentativo di scasso di un deposito (secondi).",
                    label = "Tempo per lo scasso (secondi)",
                },
                baseRaid_command = {
                    description = "Nome comando senza barra. Riavvia la risorsa dopo la modifica.",
                    label = "Comando incursione",
                },
                baseRaid_crimeItem = {
                    description = "Attrezzo della banda.",
                    label = "Attrezzo della banda",
                },
                baseRaid_crimeVehicles = {
                    description = "Accesso veicoli bande.",
                    label = "Accesso veicoli bande",
                },
                baseRaid_difficulty = {
                    description = "Difficoltà prova di abilità.",
                    label = "Difficoltà prova di abilità",
                    options = {
                        easy = "Facile",
                        expert = "Esperto",
                        hard = "Difficile",
                        normal = "Normale",
                    },
                },
                baseRaid_enabled = {
                    description = "Abilita incursioni nelle basi.",
                    label = "Abilita incursioni nelle basi",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Attesa dopo un raid concluso senza aprire alcun deposito (minuti).",
                    label = "Attesa dopo fallimento (minuti)",
                },
                baseRaid_interactionDistance = {
                    description = "Distanza interazione deposito.",
                    label = "Distanza interazione deposito",
                },
                baseRaid_lootHeistStorage = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia deposito colpi",
                },
                baseRaid_lootLaboratories = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia laboratorio",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia armadietti personali",
                },
                baseRaid_lootStorage = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia deposito",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia vani portaoggetti",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Consente il prelievo completo di questa categoria durante un’incursione attiva.",
                    label = "Saccheggia bagagliai",
                },
                baseRaid_minimumDefenders = {
                    description = "Difensori online minimi.",
                    label = "Difensori online minimi",
                },
                baseRaid_policeItem = {
                    description = "Attrezzo della polizia.",
                    label = "Attrezzo della polizia",
                },
                baseRaid_policeRequireDuty = {
                    description = "Polizia in servizio obbligatoria.",
                    label = "Polizia in servizio obbligatoria",
                },
                baseRaid_policeVehicles = {
                    description = "Accesso veicoli polizia.",
                    label = "Accesso veicoli polizia",
                },
                baseRaid_protectionHours = {
                    description = "Protezione dopo il successo (ore).",
                    label = "Protezione dopo il successo (ore)",
                },
                baseRaid_requiredHits = {
                    description = "Successi richiesti.",
                    label = "Successi richiesti",
                },
                baseRaid_warrantItem = {
                    description = "Un oggetto viene consumato per ogni avvio valido di una retata della polizia.",
                    label = "Mandato di perquisizione",
                },
                crimeMembershipMode = {
                    description = "La modalità framework mantiene l'integrazione esistente con lavori o gang native. La modalità indipendente mantiene l'organizzazione criminale in background insieme al lavoro normale e migra automaticamente le appartenenze esistenti.",
                    label = "Modello di appartenenza all'organizzazione",
                    options = {
                        framework = "Lavoro framework / gang",
                        independent = "Organizzazione indipendente",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Età minima dell'identità prima di poterla ritirare.",
                    label = "Attesa cambio alias (ore)",
                },
                darknetCurrencyCode = {
                    description = "Etichetta breve della criptovaluta interna.",
                    label = "Codice valuta",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Distanza necessaria per aprire una cassa.",
                    label = "Distanza interazione dead drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Tempo prima della scadenza di una cassa non ritirata.",
                    label = "Durata dead drop (ore)",
                },
                darknetDeadDropModel = {
                    description = "Modello prop GTA usato per i dead drop.",
                    label = "Modello cassa dead drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervallo per aggiornare casse e incontri NPC vicini.",
                    label = "Intervallo aggiornamento mondo (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distanza di caricamento di casse e incontri NPC.",
                    label = "Distanza streaming dead drop",
                },
                darknetDropLocations = {
                    description = "Queste posizioni vengono scelte casualmente per i dead drop con NPC. Configurane almeno due.",
                    itemLabel = "Dead drop",
                    label = "Posizioni dei dead drop",
                },
                darknetEnabled = {
                    description = "Rende disponibile l'app del mercato nero e la sua logica.",
                    label = "Abilita mercato darknet",
                },
                darknetExchangeBuyPrice = {
                    description = "Importo addebitato dal conto di pagamento per una moneta.",
                    label = "Prezzo di acquisto per moneta",
                },
                darknetExchangeEnabled = {
                    description = "Consente agli utenti BlackBay autenticati di comprare e vendere monete nella pagina account.",
                    label = "Abilita cambio monete",
                },
                darknetExchangeMaximumAmount = {
                    description = "Quantità intera massima accettata in un cambio.",
                    label = "Monete massime per cambio",
                },
                darknetExchangeMinimumAmount = {
                    description = "Quantità intera minima accettata in un cambio.",
                    label = "Monete minime per cambio",
                },
                darknetExchangePaymentAccount = {
                    description = "Conto framework usato per acquisti di monete e pagamenti delle vendite.",
                    label = "Conto di pagamento del cambio",
                    options = {
                        bank = "Banca",
                        black_money = "Denaro sporco",
                        money = "Contanti",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Importo versato sul conto di pagamento per una moneta.",
                    label = "Prezzo di vendita per moneta",
                },
                darknetFaceToFaceDistance = {
                    description = "Distanza massima fra giocatori o dal punto NPC.",
                    label = "Distanza consegna",
                },
                darknetKnownScammerReports = {
                    description = "Segnalazioni uniche necessarie per l'avviso pubblico.",
                    label = "Segnalazioni per avviso truffatore",
                },
                darknetListingExpiryHours = {
                    description = "Gli annunci attivi scadono automaticamente dopo queste ore.",
                    label = "Durata annuncio (ore)",
                },
                darknetMaximumListingQuantity = {
                    description = "Limite della quantità di merce in un annuncio.",
                    label = "Quantità massima",
                },
                darknetMaximumListings = {
                    description = "Numero massimo di annunci per alias attivo.",
                    label = "Annunci attivi massimi",
                },
                darknetMaximumMessageLength = {
                    description = "Numero massimo di caratteri per messaggio cifrato.",
                    label = "Lunghezza massima messaggio",
                },
                darknetMaximumUnitPrice = {
                    description = "Prezzo crypto massimo per unità.",
                    label = "Prezzo unitario massimo",
                },
                darknetMeetingLocations = {
                    description = "Queste posizioni vengono scelte casualmente per gli incontri con NPC. Configurane almeno due.",
                    itemLabel = "Punto d'incontro",
                    label = "Punti d'incontro",
                },
                darknetNpcBuyerAliases = {
                    description = "Nomi fittizi assegnati casualmente alle nuove richieste di acquisto NPC. Configura almeno due alias univoci.",
                    label = "Alias acquirenti NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Limite superiore usato per scegliere casualmente quante richieste di acquisto NPC attivare.",
                    label = "Richieste acquisto NPC massime",
                },
                darknetNpcMaximumSellListings = {
                    description = "Limite superiore usato per scegliere casualmente quante offerte di vendita NPC attivare.",
                    label = "Offerte vendita NPC massime",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Al rifornimento restano attive almeno queste richieste di acquisto NPC scelte casualmente.",
                    label = "Richieste acquisto NPC minime",
                },
                darknetNpcMinimumSellListings = {
                    description = "Al rifornimento restano attive almeno queste offerte di vendita NPC scelte casualmente.",
                    label = "Offerte vendita NPC minime",
                },
                darknetNpcSellerAliases = {
                    description = "Nomi fittizi assegnati casualmente alle nuove offerte di vendita NPC. Configura almeno due alias univoci.",
                    label = "Alias venditori NPC",
                },
                darknetNpcTraders = {
                    description = "Configura annunci NPC, consegna, reputazione e probabilità di truffa.",
                    label = "Compratori e venditori NPC",
                },
                darknetPoliceGroups = {
                    description = "Chiavi gruppo che possono creare esche e vedere le indagini.",
                    label = "Gruppi polizia autorizzati",
                },
                darknetRenewalHours = {
                    description = "Ore aggiunte quando un annuncio viene rinnovato.",
                    label = "Durata rinnovo (ore)",
                },
                darknetScamChance = {
                    description = "Probabilità minima che un commerciante NPC prenda il pagamento o la merce senza consegnare la contropartita. Si applica comunque un valore specifico del commerciante più alto.",
                    label = "Probabilità globale di truffa NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Criptovaluta assegnata solo al primo accesso del giocatore.",
                    label = "Saldo nuovo wallet",
                },
                darknetTabletOrder = {
                    description = "Controlla la posizione del mercato darknet nel tablet.",
                    label = "Ordine app tablet",
                },
                darknetVerifiedMinimumRating = {
                    description = "Valutazione media minima per un venditore verificato.",
                    label = "Valutazione per la verifica",
                },
                darknetVerifiedMinimumSales = {
                    description = "Vendite riuscite richieste per diventare verificato.",
                    label = "Vendite per la verifica",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Usato quando la fonte di pagamento è il conto del giocatore. I pagamenti dell'organizzazione usano sempre il conto del menu boss.",
                    label = "Conto di pagamento del giocatore",
                    options = {
                        bank = "Banca",
                        black_money = "Denaro sporco",
                        money = "Contanti",
                    },
                    requiresWarning = "Usato solo con la fonte di pagamento Conto del giocatore.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Usa il saldo del giocatore che acquista oppure il conto dell'organizzazione nel menu boss.",
                    label = "Fonte di pagamento",
                    options = {
                        player = "Conto del giocatore",
                        society = "Conto dell'organizzazione",
                    },
                },
                drugCamperLockKey = {
                    description = "Imposta il tasto predefinito per bloccare e sbloccare i camper posseduti o condivisi con la fazione. I giocatori possono modificarlo nelle associazioni tasti di FiveM.",
                    label = "Tasto predefinito serratura camper",
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
                    description = "Aggiunge per impostazione predefinita dati di qualità e lotto ai prodotti raccolti. Disattiva per impilare normalmente le materie prime.",
                    label = "Metadati oggetti di raccolta",
                },
                drugLabAssaultAlertDuration = {
                    description = "Secondi durante i quali il raggio di allerta resta visibile sulla mappa.",
                    label = "Durata dell'allerta",
                },
                drugLabAssaultAlertRadius = {
                    description = "Raggio della zona di attacco mostrata sulla mappa alla fazione difendente.",
                    label = "Raggio di allerta dei difensori",
                },
                drugLabAssaultBreachRadius = {
                    description = "Raggio entro cui l'attaccante deve restare mentre forza l'ingresso.",
                    label = "Raggio da mantenere durante l'irruzione",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Secondi per cui gli attaccanti devono mantenere l'ingresso senza contestazioni per conquistare il laboratorio o il camper.",
                    label = "Durata della conquista",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Area d'ingresso usata per contare attaccanti e difensori che contestano la conquista.",
                    label = "Raggio di conquista",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Secondi necessari per violare il sistema dell'ingresso.",
                    label = "Durata dell'irruzione elettronica",
                },
                drugLabAssaultEnabled = {
                    description = "Consente alle fazioni di forzare e conquistare laboratori rivali e camper condivisi con una fazione.",
                    label = "Abilita conquiste di laboratori e camper",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Secondi necessari per forzare l'ingresso con una carica esplosiva.",
                    label = "Durata dell'irruzione esplosiva",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Distanza massima dall'ingresso del laboratorio o del camper per avviare un attacco.",
                    label = "Distanza di interazione dall'ingresso",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Secondi necessari per perforare la serratura dell'ingresso.",
                    label = "Durata dell'irruzione meccanica",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Membri online della fazione difendente richiesti prima che un attacco possa iniziare.",
                    label = "Difensori minimi",
                },
                drugLabAssaultRequireDuty = {
                    description = "Considera soltanto i membri della fazione difendente attualmente in servizio.",
                    label = "Conta solo i difensori in servizio",
                },
                drugProcessingInventoryMetadata = {
                    description = "Aggiunge per impostazione predefinita dati di qualità e lotto ai prodotti lavorati. Le singole ricette possono ignorare questa impostazione.",
                    label = "Metadati oggetti lavorati",
                },
                graffitiItemName = {
                    description = "Oggetto dell'inventario necessario per iniziare a dipingere quando il requisito è attivo. L'oggetto deve esistere nell'inventario in uso.",
                    label = "Oggetto richiesto per i graffiti",
                },
                heistCooldownMinutes = {
                    description = "Blocca lo stesso colpo dopo la fine e la pulizia di una sessione con interazioni effettive. Zero disattiva l'attesa. Una finestra iniziale inutilizzata non la attiva.",
                    label = "Attesa tra i colpi (minuti)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Barra di avanzamento di cinque secondi. Gli ingredienti richiesti vengono consumati in caso di successo.",
                        medium = "Seleziona gli ingredienti nell’ordine indicato e supera una prova di tempismo per ingrediente.",
                        advanced = "Montaggio completo per le ricette con un profilo del dispositivo; altrimenti due prove di tempismo precise per ingrediente.",
                    },
                    description = "Semplice: barra di avanzamento di cinque secondi. Media: selezione degli ingredienti e prove di tempismo. Massima: assemblaggio completo; le ricette senza un profilo del dispositivo richiedono due prove precise per ingrediente.",
                    label = "Complessità della creazione",
                    options = {
                        advanced = "Massima complessità",
                        medium = "Complessità media",
                        simple = "Molto semplice",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Dopo la prima interazione, ogni nuova azione del colpo azzera il timer. Alla scadenza la sessione termina e i suoi oggetti vengono rimossi. Si applica alle nuove sessioni.",
                    label = "Limite di inattività del colpo (minuti)",
                },
                heistStartTimeoutMinutes = {
                    description = "Tempo dopo Avvia per interagire sul posto. Senza interazioni la sessione viene ripristinata e può essere riavviata. Si applica alle nuove sessioni.",
                    label = "Minuti per la prima interazione del colpo",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banca",
                        black_money = "Denaro sporco",
                        money = "Contanti",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Conto dal quale viene rimosso il denaro sporco del giocatore all'avvio di un ciclo di lavaggio.",
                    label = "Conto di deposito",
                },
                moneywashDrawDistance = {
                    description = "Distanza massima in metri alla quale vengono mostrati gli ingressi delle attività e i negozi.",
                    label = "Distanza di visualizzazione",
                },
                moneywashEnabled = {
                    description = "Rende disponibili le attività di riciclaggio delle organizzazioni criminali.",
                    label = "Abilita riciclaggio",
                },
                moneywashFeePercent = {
                    description = "Percentuale detratta da ogni lotto prima del versamento all'organizzazione.",
                    label = "Commissione (%)",
                },
                moneywashInteractionDistance = {
                    description = "Distanza massima in metri per utilizzare gli ingressi delle attività e i negozi.",
                    label = "Distanza di interazione",
                },
                npcPoliceAccuracy = {
                    description = "Precisione degli agenti NPC da 0 a 100.",
                    label = "Precisione di tiro",
                },
                npcPoliceArmour = {
                    description = "Valore di armatura di ogni agente NPC da 0 a 100.",
                    label = "Giubbotto antiproiettile",
                },
                npcPoliceAtms = {
                    description = "Invia il supporto della polizia NPC quando scatta l'allarme di una rapina a un bancomat.",
                    label = "Supporto durante le rapine ai bancomat",
                },
                npcPoliceDurationSeconds = {
                    description = "Tempo massimo per cui gli agenti NPC restano schierati dopo la comparsa (30–900 secondi).",
                    label = "Durata dell'intervento (secondi)",
                },
                npcPoliceEnabled = {
                    description = "Attualmente disattivato a causa di problemi di stabilità. Questo interruttore al momento non può attivare la funzionalità.",
                    label = "Attiva il supporto della polizia NPC",
                },
                npcPoliceHeists = {
                    description = "Invia il supporto della polizia NPC quando scatta l'allarme di un colpo.",
                    label = "Supporto durante i colpi",
                },
                npcPoliceOfficerCount = {
                    description = "Numero di agenti NPC armati inviati per ogni allarme di rapina (1–8).",
                    label = "Agenti per intervento",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Tempo tra l'allarme di rapina e l'arrivo degli agenti NPC (0–300 secondi).",
                    label = "Ritardo di intervento (secondi)",
                },
                npcPoliceShops = {
                    description = "Invia il supporto della polizia NPC quando scatta l'allarme di una rapina a un negozio.",
                    label = "Supporto durante le rapine ai negozi",
                },
                npcPoliceSpawnDistance = {
                    description = "Distanza desiderata dal luogo della rapina alla quale compaiono gli agenti NPC (15–150 metri).",
                    label = "Distanza di comparsa (metri)",
                },
                npcPoliceWeapon = {
                    description = "Arma assegnata a ogni agente NPC inviato. L'arma predefinita è una pistola.",
                    label = "Arma di servizio",
                    options = {
                        WEAPON_CARBINERIFLE = "Carabina",
                        WEAPON_PISTOL = "Pistola",
                        WEAPON_PUMPSHOTGUN = "Fucile a pompa",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Apri Heist Creator",
                    description = "Apre l'Heist Creator e chiude il Configuratore lavori.",
                    label = "Creatore Heist",
                    unsavedTooltip = "Salva prima le modifiche",
                },
                pickpocketAggressionChance = {
                    description = "Probabilità indipendente che l'NPC attacchi dopo un tentativo fallito, annullato o scaduto.",
                    label = "Probabilità contrattacco (%)",
                },
                pickpocketAlertChance = {
                    description = "Probabilità indipendente che l'NPC segnali un tentativo fallito, annullato o scaduto.",
                    label = "Probabilità chiamata emergenza (%)",
                },
                pickpocketDifficulty = {
                    description = "Controlla velocità, riduzione dell'area bersaglio, lunghezza sequenza ed errori consentiti.",
                    label = "Difficoltà",
                    options = {
                        easy = "Facile",
                        expert = "Esperto",
                        hard = "Difficile",
                        normal = "Normale",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Segnala una volta ogni tentativo di borseggio avviato, anche se riuscito e indipendentemente dalla probabilità di chiamata d’emergenza.",
                    label = "Invia sempre una segnalazione",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Secondi di rilevanza della segnalazione.",
                    label = "Durata dispatch",
                },
                pickpocketDispatchJobs = {
                    description = "Nomi dei lavori destinatari separati da virgole.",
                    label = "Lavori dispatch",
                },
                pickpocketDispatchPriority = {
                    description = "Priorità inoltrata all'integrazione dispatch.",
                    label = "Priorità dispatch",
                },
                pickpocketDispatchRadius = {
                    description = "Raggio approssimativo inviato all'integrazione dispatch.",
                    label = "Raggio dispatch",
                },
                pickpocketEmptyChance = {
                    description = "Probabilità che l'NPC non abbia alcun bottino selezionabile.",
                    label = "Probabilità tasche vuote (%)",
                },
                pickpocketEnabled = {
                    description = "Permette di borseggiare NPC casuali idonei e sincronizzati.",
                    label = "Abilita borseggio NPC",
                },
                pickpocketFleeChance = {
                    description = "Probabilità indipendente che l'NPC fugga dopo un tentativo fallito, annullato o scaduto.",
                    label = "Probabilità di fuga NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Portata massima client; il server aggiunge un piccolo margine di sincronizzazione.",
                    label = "Distanza interazione",
                },
                pickpocketItems = {
                    description = "Ogni riga controlla la probabilità di apparire con quattro cifre decimali.",
                    itemLabel = "Probabilità oggetto",
                    label = "Bottino oggetto",
                },
                pickpocketItemsEnabled = {
                    description = "Estrae gli oggetti configurati nel contenuto visibile della tasca.",
                    label = "Abilita bottino oggetto",
                },
                pickpocketMaximumLootChoices = {
                    description = "Numero massimo di slot contanti o oggetto generati dal server per NPC.",
                    label = "Bottino visibile massimo",
                },
                pickpocketMinigame = {
                    description = "Sceglie una sfida o ruota casualmente fra tutte e tre.",
                    label = "Minigioco",
                    options = {
                        pulse = "Impulso pressione",
                        random = "Rotazione casuale",
                        sequence = "Sequenza direzioni",
                        timing = "Barra tempismo",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Importo visibile massimo, mai inferiore al minimo.",
                    label = "Contanti massimi",
                },
                pickpocketMoneyMinimum = {
                    description = "Importo minimo generato dal server per uno slot contanti visibile.",
                    label = "Contanti minimi",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Secondi minimi fra richieste di avvio dello stesso giocatore.",
                    label = "Cooldown richieste",
                },
                pickpocketRequireCrimeJob = {
                    description = "Attivo: mostra l'azione solo ai lavori registrati nel Crime System. Disattivo: rimuove l'azione radiale interna e richiede l'export server.",
                    label = "Usa il menu radiale criminale",
                },
                pickpocketRequiredHits = {
                    description = "Valore base per ogni minigioco. Il denaro di valore lo aumenta gradualmente; gli oggetti estremamente rari richiedono almeno otto successi.",
                    label = "Successi minimi",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Secondi prima che una challenge incompleta scada.",
                    label = "Timeout sessione",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Blocco dopo tentativi annullati o falliti; gli NPC svuotati restano indisponibili.",
                    label = "Cooldown NPC",
                },
                pvpAdminAce = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpArenaReturnSeconds = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpArenaWarningPosition = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                    options = {
                        bottom_center = "Centro inferiore",
                        bottom_left = "In basso a sinistra",
                        bottom_right = "In basso a destra",
                        middle_center = "Centro schermo",
                        middle_left = "Sinistra centrale",
                        middle_right = "Medio a destra",
                        top_center = "Centro superiore",
                        top_left = "In alto a sinistra",
                        top_right = "In alto a destra",
                    },
                },
                pvpArenas = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    itemLabel = "Arena",
                    label = "Bonus di crescita di qualità",
                },
                pvpCountdownPosition = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                    options = {
                        bottom_center = "Centro inferiore",
                        bottom_left = "In basso a sinistra",
                        bottom_right = "In basso a destra",
                        middle_center = "Centro schermo",
                        middle_left = "Sinistra centrale",
                        middle_right = "Medio a destra",
                        top_center = "Centro superiore",
                        top_left = "In alto a sinistra",
                        top_right = "In alto a destra",
                    },
                },
                pvpDefaultMode = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                    options = {
                        free_for_all = "Gratis per tutti",
                        last_man_standing = "Ultimo uomo in piedi",
                        team_deathmatch = "Squadra Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpEventsEnabled = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpKillfeedPosition = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                    options = {
                        bottom_center = "Centro inferiore",
                        bottom_left = "In basso a sinistra",
                        bottom_right = "In basso a destra",
                        middle_center = "Centro schermo",
                        middle_left = "Sinistra centrale",
                        middle_right = "Medio a destra",
                        top_center = "Centro superiore",
                        top_left = "In alto a sinistra",
                        top_right = "In alto a destra",
                    },
                },
                pvpLeaderPermission = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpMatchDurationMinutes = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpMaxHistory = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpMaxRewards = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpMoneyPermission = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpRequestCooldownMs = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpRespawnDelaySeconds = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpSchedulePollSeconds = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpScoreboardPosition = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                    options = {
                        bottom_center = "Centro inferiore",
                        bottom_left = "In basso a sinistra",
                        bottom_right = "In basso a destra",
                        middle_center = "Centro schermo",
                        middle_left = "Sinistra centrale",
                        middle_right = "Medio a destra",
                        top_center = "Centro superiore",
                        top_left = "In alto a sinistra",
                        top_right = "In alto a destra",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpStartCountdownSeconds = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                pvpTabletOrder = {
                    description = "Massimo bonus di crescita supplementare concesso dalla qualità delle piante.",
                    label = "Bonus di crescita di qualità",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuti prima che una rapina abbandonata fallisca.",
                    label = "Scadenza attiva",
                },
                shopConsumeDrill = {
                    description = "Consuma il trapano dopo il successo.",
                    label = "Consuma trapano",
                },
                shopConsumeHackItem = {
                    description = "Consuma il dispositivo dopo aver aperto la cassaforte con successo.",
                    label = "Consuma dispositivo",
                },
                shopCooldownMinutes = {
                    description = "Minuti runtime prima del ripristino.",
                    label = "Recupero negozio",
                },
                shopDispatchAlways = {
                    description = "Segnala una volta ogni rapina a un negozio al suo inizio, anche con intimidazione continua e nei negozi senza commesso obbligatorio.",
                    label = "Invia sempre una segnalazione",
                },
                shopDispatchDurationSeconds = {
                    description = "Secondi di rilevanza dell'allarme.",
                    label = "Durata dispatch",
                },
                shopDispatchJobs = {
                    description = "Job destinatari separati da virgole.",
                    label = "Job dispatch",
                },
                shopDispatchPriority = {
                    description = "Priorità inviata al dispatch.",
                    label = "Priorità dispatch",
                },
                shopDispatchRadius = {
                    description = "Raggio approssimativo dell'allarme.",
                    label = "Raggio dispatch",
                },
                shopDrillDurationSeconds = {
                    description = "Secondi per perforare la cassaforte.",
                    label = "Durata perforazione",
                },
                shopDrillItem = {
                    description = "ID dell’oggetto nell’inventario necessario per forare le casseforti dei negozi. Impostazione separata dal trapano dei bancomat.",
                    label = "Oggetto trapano",
                },
                shopDrillItemAmount = {
                    description = "Numero di oggetti richiesti.",
                    label = "Quantità trapano",
                },
                shopEnabled = {
                    description = "Abilita rapine nei negozi configurati.",
                    label = "Abilita rapine ai negozi",
                },
                shopHackItem = {
                    description = "Oggetto richiesto per il minigioco della cassaforte. Abilita questo metodo separatamente per ogni negozio.",
                    label = "Dispositivo per hacking",
                },
                shopHackItemAmount = {
                    description = "Quantità richiesta del dispositivo per hacking.",
                    label = "Quantità dispositivi",
                },
                shopIntimidationSeconds = {
                    description = "Secondi di minaccia continua.",
                    label = "Durata intimidazione",
                },
                shopLocations = {
                    description = "Un commesso, un registratore di cassa e una cassaforte opzionale per negozio.",
                    itemLabel = "Negozio",
                    label = "Negozi",
                },
                shopMinimumPolice = {
                    description = "Agenti in servizio richiesti per iniziare.",
                    label = "Polizia minima",
                },
                shopPoliceGroup = {
                    description = "Gruppo di lavoro contato nel requisito.",
                    label = "Gruppo polizia",
                },
                shopRegisterDurationSeconds = {
                    description = "Secondi per svuotare una cassa.",
                    label = "Durata saccheggio cassa",
                },
                shopRegisterRewardMaximum = {
                    description = "Pagamento massimo della cassa.",
                    label = "Ricompensa cassa massima",
                },
                shopRegisterRewardMinimum = {
                    description = "Pagamento minimo della cassa.",
                    label = "Ricompensa cassa minima",
                },
                shopRegisterRewardName = {
                    description = "Nome opzionale di oggetto o conto.",
                    label = "Nome ricompensa cassa",
                },
                shopRegisterRewardSort = {
                    description = "Scegli tra contanti e l'oggetto black_money.",
                    label = "Tipo di pagamento cassa",
                },
                shopRegisters = {
                    description = "Posizioni assegnate per ID negozio.",
                    itemLabel = "Cassa",
                    label = "Casse",
                },
                shopSafeLootDurationSeconds = {
                    description = "Secondi necessari per prendere il denaro dopo aver inserito un codice valido.",
                    label = "Durata saccheggio cassaforte",
                },
                shopSafeRewardMaximum = {
                    description = "Pagamento massimo della cassaforte.",
                    label = "Ricompensa cassaforte massima",
                },
                shopSafeRewardMinimum = {
                    description = "Pagamento minimo della cassaforte.",
                    label = "Ricompensa cassaforte minima",
                },
                shopSafeRewardName = {
                    description = "Nome opzionale di oggetto o conto.",
                    label = "Nome ricompensa cassaforte",
                },
                shopSafeRewardSort = {
                    description = "Scegli tra contanti e l'oggetto black_money.",
                    label = "Tipo di pagamento cassaforte",
                },
                shopThreatGraceSeconds = {
                    description = "Interruzione concessa prima dell'allarme.",
                    label = "Tolleranza mira",
                },
                territoryDrugSalesEnabled = {
                    description = "Le vendite in strada riuscite agli NPC assegnano influenza alla fazione del venditore nel territorio stradale attuale.",
                    label = "Le vendite agli NPC danno influenza territoriale",
                },
                atmLocationMode = {
                    label = "Modalità posizioni bancomat",
                    description = "Rileva automaticamente gli oggetti supportati nel mondo oppure usa solo le posizioni configurate manualmente.",
                    options = {
                        automatic = "Automatico",
                        manual = "Manuale",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Richiedi agenti in servizio",
                    description = "Richiede il numero configurato di agenti in servizio prima di iniziare una rapina al bancomat.",
                },
                openDrugCreator = {
                    label = "Editor di droghe",
                    description = "Apre l'editor di droghe Sky Crime e chiude il configuratore dei lavori.",
                    buttonLabel = "Apri l'editor di droghe",
                    unsavedTooltip = "Salva prima",
                },
                drugCreatorRuntimeDensity = {
                    label = "Densità del pannello operativo",
                    description = "Determina la compattezza del pannello operativo nell'editor delle droghe.",
                    options = {
                        comfortable = "Comoda",
                        compact = "Compatto",
                    },
                },
                drugCreatorListDensity = {
                    label = "Densità dell'elenco",
                    description = "Determina la compattezza dell'elenco delle voci nell'editor.",
                    options = {
                        comfortable = "Comoda",
                        compact = "Compatto",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Mostra elenchi operativi vuoti",
                    description = "Mostra le sezioni del pannello operativo anche senza voci.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Nascondi voci disattivate",
                    description = "Nasconde le voci dei moduli disattivate nell'elenco dell'editor di droghe.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Genera ID automaticamente",
                    description = "Genera gli ID dai nomi quando si creano nuove voci nell'editor di droghe.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Apri editor al cambio di modulo",
                    description = "Apre automaticamente l'editor quando si cambia il modulo attivo.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Suffisso automatico per copie",
                    description = "Aggiunge un suffisso automatico quando si duplicano voci nell'editor delle droghe.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Preseleziona obiettivi di gioco",
                    description = "Preseleziona automaticamente i laboratori e i lotti disponibili.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Mostra i problemi all'apertura",
                    description = "Apre il pannello operativo evidenziando le voci che richiedono attenzione.",
                },
                drugActivityHudPosition = {
                    label = "Posizione HUD attività",
                    description = "Trascina l'HUD di posizionamento e raccolta nella posizione desiderata sullo schermo.",
                },
                drugInteractionHudPosition = {
                    label = "Posizione HUD interazione",
                    description = "Trascina l'HUD di interazione di piante, laboratori e camper nella posizione desiderata.",
                },
                drugPlantStatusHudPosition = {
                    label = "Posizione HUD stato pianta",
                    description = "Trascina l'HUD dettagliato dello stato della pianta nella posizione desiderata.",
                },
                drugSystemEnabled = {
                    label = "Sistema delle droghe",
                    description = "Attiva: produzione di droghe, dati dell'editor e interfacce di gioco per questo lavoro criminale.",
                },
                drugCreatorAccess = {
                    label = "Accesso all'editor di droghe",
                    description = "Determina chi può aprire l'editor avanzato delle droghe.",
                    options = {
                        permission = "Solo con permesso",
                        job_management = "Gestione del lavoro",
                        owner_only = "Solo proprietario",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfacce operative",
                    description = "Consente ai giocatori di usare le azioni di laboratorio, piante, lavorazione e mercato nel gioco.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Creazione laboratori da parte dei giocatori",
                    description = "Consente ai giocatori con accesso al sistema di creare laboratori dai modelli dell'editor anche senza essere amministratori.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Coltivazione all'aperto",
                    description = "Consente ai giocatori coltivazioni all'aperto fuori dai laboratori configurati.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Raccolta all'aperto da altri giocatori",
                    description = "Consente agli altri giocatori di raccogliere piante all'aperto che non hanno piantato.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Addebita acquisto laboratorio",
                    description = "Addebita ai giocatori il prezzo configurato quando creano un laboratorio.",
                },
                drugRuntimeStrictInventory = {
                    label = "Verifica rigorosa dell'inventario",
                    description = "Le azioni proseguono solo se le operazioni configurate su oggetti, strumenti e denaro riescono.",
                },
                drugRuntimeSalePayouts = {
                    label = "Vendita / Pagamenti",
                    description = "Paga i giocatori quando lotti o rotte vengono venduti tramite il sistema di mercato.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Pagamento / Conto",
                    description = "Conto usato per i pagamenti delle vendite di droghe, ad esempio black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Spedizione / Allarmi",
                    description = "Inoltra gli eventi di rischio legati alla droga alla centrale e ai lavori di polizia configurati.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Polizia / Comunicazioni",
                    description = "Avvisa i lavori di polizia configurati quando un evento di rischio legato alla droga genera un allarme.",
                },
                drugBatchPrefix = {
                    label = "Lotto / Prefisso",
                    description = "Prefisso degli ID dei nuovi lotti di droga.",
                },
                drugTestingKitAccuracy = {
                    label = "Kit di test / Precisione",
                    description = "Variazione consentita dei valori nascosti con un kit di analisi di base.",
                },
                drugDecayIntervalMinutes = {
                    label = "Decadimento / Intervallo",
                    description = "Intervallo in minuti per controlli di perdita di freschezza e riduzione della contaminazione.",
                },
                drugDefaultPackaging = {
                    label = "Valore predefinito / Confezionamento",
                    description = "Confezione dei lotti grezzi o lavorati creati senza un tipo di imballaggio specifico.",
                    options = {
                        loose = "Sfuso",
                        baggy = "Bustina",
                        jar = "Barattolo",
                        vacuum = "Sacchetto sottovuoto",
                        brick = "Involucro del panetto",
                        premium_seal = "Sigillatura premium",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Qualità / Peso",
                    description = "Influenza sulla qualità finale: Qualità di base.",
                },
                drugQualityWeightPurity = {
                    label = "Purezza / Peso",
                    description = "Influenza sulla qualità finale: Purezza.",
                },
                drugQualityWeightFreshness = {
                    label = "Freschezza / Peso",
                    description = "Influenza sulla qualità finale: Freschezza.",
                },
                drugQualityWeightPotency = {
                    label = "Potenza / Peso",
                    description = "Influenza sulla qualità finale: Potenza.",
                },
                drugQualityWeightStability = {
                    label = "Stabilità / Peso",
                    description = "Influenza sulla qualità finale: Stabilità.",
                },
                drugQualityWeightContamination = {
                    label = "Contaminazione / Penalità",
                    description = "Penalità alla qualità dei prodotti contaminati.",
                },
                drugTierGoodMin = {
                    label = "Buono / Livello / Minimo",
                    description = "Punteggio minimo per il livello di qualità Buono.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Livello / Minimo",
                    description = "Punteggio minimo per il livello di qualità Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Qualità eccellente / Livello / Minimo",
                    description = "Punteggio minimo per il livello di qualità Qualità eccellente.",
                },
                drugTierLabGradeMin = {
                    label = "Qualità da laboratorio / Livello / Minimo",
                    description = "Punteggio minimo per il livello di qualità Qualità da laboratorio.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Bustina / Decadimento",
                    description = "Moltiplicatore per perdita di freschezza / Bustine.",
                },
                drugJarDecayMultiplier = {
                    label = "Barattolo / Decadimento",
                    description = "Moltiplicatore per perdita di freschezza / Barattoli.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Sottovuoto / Decadimento",
                    description = "Moltiplicatore per perdita di freschezza / Sacchetti sottovuoto.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Sigillatura premium / Prezzo",
                    description = "Moltiplicatore per Premium / Prodotto sigillato / Prezzo.",
                },
                drugGrowingEnabled = {
                    label = "Coltivazione / Abilitato",
                    description = "Attiva: crescita delle piante e raccolta.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Verifica del luogo di coltivazione",
                    description = "Se attiva, le piante collocate liberamente attendono una verifica automatica del luogo da parte di un amministratore. Disattivala per consentire la crescita senza approvazione amministrativa.",
                },
                drugGrowthTickMinutes = {
                    label = "Crescita / Ciclo di aggiornamento / Minuti",
                    description = "Intervallo in minuti per aggiornamenti della crescita delle piante.",
                },
                drugBaseGrowthPerTick = {
                    label = "Valore base / Crescita / Per ciclo di aggiornamento",
                    description = "Crescita base prima dei modificatori di varietà, attrezzatura e cura.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Pianta selvatica / Ricomparsa",
                    description = "Attesa in minuti prima di: Pianta selvatica / Ricomparsa.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Evidenzia piante selvatiche",
                    description = "Mostra il contorno delle piante selvatiche generate quando un giocatore entra nel raggio di evidenziazione.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Raggio di evidenziazione delle piante selvatiche",
                    description = "Distanza in metri attorno a ogni pianta selvatica generata entro cui il suo contorno diventa visibile.",
                },
                drugDefaultPlantWater = {
                    label = "Valore predefinito / Acqua",
                    description = "Valore iniziale alla creazione di una pianta: Acqua.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Valore predefinito / Fertilizzante",
                    description = "Valore iniziale alla creazione di una pianta: Fertilizzante.",
                },
                drugDefaultPlantHealth = {
                    label = "Valore predefinito / Salute",
                    description = "Valore iniziale alla creazione di una pianta: Salute.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Valore predefinito / Probabilità mutazione",
                    description = "Probabilità base di mutazione se la varietà non specifica un valore proprio.",
                },
                drugHarvestPerfectStart = {
                    label = "Inizio raccolta ottimale",
                    description = "Percentuale di crescita per la finestra di raccolta ottimale: Inizio.",
                },
                drugHarvestPerfectEnd = {
                    label = "Fine raccolta ottimale",
                    description = "Percentuale di crescita per la finestra di raccolta ottimale: Fine.",
                },
                drugLabsEnabled = {
                    label = "Laboratori / Abilitato",
                    description = "Attiva: laboratori e camper nel gioco.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratori per personaggio",
                    description = "Numero massimo di laboratori fissi acquistati o affittati per proprietario. 0 significa illimitato; camper e accessi condivisi non contano.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratori per fazione",
                    description = "Numero massimo di laboratori fissi acquistati o affittati per proprietario. 0 significa illimitato; camper e accessi condivisi non contano.",
                },
                drugDefaultRentDays = {
                    label = "Valore predefinito / Giorni di affitto",
                    description = "Valore predefinito per Laboratorio / Affitto / Durata.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Camper rubato / Minuti",
                    description = "Durata del rischio elevato per i camper rubati.",
                },
                drugLabRentWarningHours = {
                    label = "Affitto / Avviso / Ore",
                    description = "Ore prima della scadenza dell'affitto del laboratorio in cui mostrare un avviso.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Affitto scaduto / Pressione della polizia",
                    description = "Sospetto aggiunto alla scadenza dell'affitto del laboratorio.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Camper / Sposta / Tempo di ricarica",
                    description = "Attesa in minuti prima di: Camper / Laboratorio / Nuovo spostamento.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Miglioramento / Costo / Moltiplicatore",
                    description = "Moltiplicatore per Laboratorio / Livello / Miglioramento / Prezzi.",
                },
                drugCamperBaseSlots = {
                    label = "Camper / Slot",
                    description = "Valore predefinito per laboratori nei camper / spazi per attrezzature.",
                },
                drugCamperBaseStorage = {
                    label = "Camper / Stoccaggio",
                    description = "Valore predefinito per laboratori nei camper / Capacità di stoccaggio.",
                },
                drugCamperBasePower = {
                    label = "Camper / Energia",
                    description = "Valore predefinito per laboratori nei camper / Alimentazione integrata.",
                },
                drugBasementBaseSlots = {
                    label = "Seminterrato / Slot",
                    description = "Valore predefinito per laboratori nel seminterrato / spazi per attrezzature.",
                },
                drugBasementBaseStorage = {
                    label = "Seminterrato / Stoccaggio",
                    description = "Valore predefinito per laboratori nel seminterrato / Capacità di stoccaggio.",
                },
                drugWarehouseBasePower = {
                    label = "Magazzino / Energia",
                    description = "Valore predefinito per laboratori nei magazzini / Alimentazione integrata.",
                },
                drugPowerEnabled = {
                    label = "Energia / Sistema",
                    description = "Attiva: generazione elettrica, consumo e controlli di sovraccarico del laboratorio.",
                },
                drugOverloadGraceSeconds = {
                    label = "Sovraccarico / Periodo di tolleranza",
                    description = "Secondi prima che un sovraccarico elettrico diventi pericoloso.",
                },
                drugHeatPerKilowatt = {
                    label = "Pressione della polizia / Per kilowatt",
                    description = "Sospetto del laboratorio generato dal consumo elettrico.",
                },
                drugGeneratorT1Watts = {
                    label = "Generatore T1 / Watt",
                    description = "Potenza dei generatori di livello T1 in watt.",
                },
                drugGeneratorT2Watts = {
                    label = "Generatore T2 / Watt",
                    description = "Potenza dei generatori di livello T2 in watt.",
                },
                drugGeneratorT3Watts = {
                    label = "Generatore T3 / Watt",
                    description = "Potenza dei generatori di livello T3 in watt.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Usura / Moltiplicatore",
                    description = "Moltiplicatore globale per Usura Attrezzatura / Lavorazione.",
                },
                drugWorkersEnabled = {
                    label = "Lavoratori / Abilitato",
                    description = "Attiva: chimici, coltivatori, confezionatori e addetti alla sicurezza nei laboratori di droghe.",
                },
                drugMaxWorkersPerLab = {
                    label = "Massimo / Lavoratori / Laboratorio",
                    description = "Numero massimo di lavoratori per laboratorio.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Fatica da lavorazione",
                    description = "Fatica aggiunta per Lavoratori dopo questo lavoro: Fase di lavorazione.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Coltivazione / Fatica",
                    description = "Fatica aggiunta per Coltivatori dopo questo lavoro: Raccolta o coltivazione.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Lavoratore / Recupero",
                    description = "Recupero di Fatica a ogni passo: Aggiornamento della crescita.",
                },
                drugMarketEnabled = {
                    label = "Mercato / Abilitato",
                    description = "Attiva: acquirenti, spacciatori e vendite di lotti.",
                },
                drugMarketBasePriceFallback = {
                    label = "Valore sostitutivo / Prezzo Base",
                    description = "Prezzo base delle droghe senza un prezzo specifico configurato.",
                },
                drugMarketStreetMultiplier = {
                    label = "Strada / Moltiplicatore",
                    description = "Moltiplicatore globale per Prezzo / Vendite di strada.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Commercio all'ingrosso / Moltiplicatore",
                    description = "Moltiplicatore globale per Prezzo / Commercio all'ingrosso / Affari.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Moltiplicatore",
                    description = "Moltiplicatore globale per Prezzo / Premium / Acquirenti.",
                },
                drugMarketHeatPerSale = {
                    label = "Pressione della polizia / Vendita",
                    description = "Pressione della polizia base aggiunta al laboratorio alla vendita di un lotto.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribuzione / Ciclo di aggiornamento",
                    description = "Intervallo in minuti per aggiornamenti della distribuzione degli spacciatori.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribuzione / Intervallo",
                    description = "Valore predefinito per Rivenditore / Attesa prima della vendita / Minuti.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Massimo / Rivenditore / Ordini",
                    description = "Valore predefinito per Rivenditore / numero massimo di ordini di distribuzione attivi.",
                },
                drugThreatsEnabled = {
                    label = "Minacce / Abilitato",
                    description = "Attiva: riduzione del sospetto, retate e sabotaggi nei laboratori.",
                },
                drugThreatTickMinutes = {
                    label = "Minaccia / Ciclo di aggiornamento",
                    description = "Intervallo in minuti per riduzione del sospetto e controlli di retate e sabotaggi.",
                },
                drugRaidHeatThreshold = {
                    label = "Soglia di sospetto per retate",
                    description = "Pressione della polizia richiesta nel laboratorio prima di poter attivare: Incursioni.",
                },
                drugSabotageHeatThreshold = {
                    label = "Soglia di sospetto per sabotaggio",
                    description = "Pressione della polizia richiesta nel laboratorio prima di poter attivare: Sabotaggio.",
                },
                drugThreatHeatDecay = {
                    label = "Pressione della polizia / Decadimento",
                    description = "Riduce il sospetto del laboratorio di questo valore a ogni aggiornamento delle minacce.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Probabilità di retata",
                    description = "Probabilità base di Assalto al raggiungimento della relativa soglia di pressione della polizia.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotaggio / Possibilità",
                    description = "Probabilità base di Sabotaggio al raggiungimento della relativa soglia di pressione della polizia.",
                },
                drugConsumptionEnabled = {
                    label = "Consumo abilitato",
                    description = "Attiva: effetti delle droghe e monitoraggio di tolleranza e dipendenza.",
                },
                drugDoseConsumesBatch = {
                    label = "Consuma il lotto all'uso",
                    description = "Rimuove un lotto consumato dalle scorte attive.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolleranza / Decadimento",
                    description = "Intervallo in minuti per aggiornamenti della riduzione di tolleranza.",
                },
                drugAddictionDecayMinutes = {
                    label = "Dipendenza / Decadimento",
                    description = "Intervallo in minuti per aggiornamenti della riduzione di dipendenza.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potenza / Moltiplicatore",
                    description = "Determina quanto la potenza aumenta l'intensità degli effetti.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Overdose / Soglia",
                    description = "Carico di potenza necessario prima che possa essere calcolata un'overdose.",
                },
                drugBaseAddictionGain = {
                    label = "Valore base / Dipendenza / guadagno",
                    description = "Aumento base della dipendenza per dose.",
                },
                drugProcessingEnabled = {
                    label = "Lavorazione / Abilitato",
                    description = "Attiva: lavori di trasformazione, confezionamento e kit di analisi.",
                },
                drugBatchMetadataItemKey = {
                    label = "Lotto / Metadati / Chiave",
                    description = "Chiave dei metadati dell'inventario usata dalle integrazioni per i dati dei lotti.",
                },
                drugDefaultProcessDuration = {
                    label = "Durata predefinita di lavorazione",
                    description = "Valore predefinito per Lavorazione / Durata / secondi / Senza valore specifico della ricetta.",
                },
                drugDefaultFailureRisk = {
                    label = "Valore predefinito / Rischio di Fallimento",
                    description = "Valore predefinito per Lavorazione / Rischio di Fallimento / Senza valore specifico della ricetta.",
                },
                drugPackagingDuration = {
                    label = "Tempo di confezionamento",
                    description = "Valore predefinito per Confezionamento / Durata / secondi.",
                },
                drugPowerTickSeconds = {
                    label = "Energia / Ciclo di aggiornamento / secondi",
                    description = "Intervallo in secondi per aggiornamento del consumo dei generatori e delle tracce elettriche.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Traccia elettrica / Pressione della polizia / Ora",
                    description = "Sospetto generato ogni ora dalla traccia elettrica del laboratorio.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Sovraccarico / Pressione della polizia / Ora",
                    description = "Pressione della polizia aggiuntiva ogni ora mentre il laboratorio è sovraccarico.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Inattivo / Pressione della polizia / Decadimento / Ora",
                    description = "Riduzione oraria del sospetto quando il laboratorio non ha una traccia elettrica attiva.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuale / Massimo / Carico",
                    description = "Valore per la modalità energetica Manuale: Massimo / Carico.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuale / Pressione della polizia / Moltiplicatore",
                    description = "Valore per la modalità energetica Manuale: Pressione della polizia / Moltiplicatore.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuale / Rumore / Moltiplicatore",
                    description = "Valore per la modalità energetica Manuale: Rumore / Moltiplicatore.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Bilanciato / Massimo / Carico",
                    description = "Valore per la modalità energetica Bilanciato: Massimo / Carico.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Bilanciato / Pressione della polizia / Moltiplicatore",
                    description = "Valore per la modalità energetica Bilanciato: Pressione della polizia / Moltiplicatore.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Bilanciato / Rumore / Moltiplicatore",
                    description = "Valore per la modalità energetica Bilanciato: Rumore / Moltiplicatore.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Furtività / Massimo / Carico",
                    description = "Valore per la modalità energetica Furtività: Massimo / Carico.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Furtività / Pressione della polizia / Moltiplicatore",
                    description = "Valore per la modalità energetica Furtività: Pressione della polizia / Moltiplicatore.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Furtività / Rumore / Moltiplicatore",
                    description = "Valore per la modalità energetica Furtività: Rumore / Moltiplicatore.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Controllo degli odori / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Controllo degli odori / Attrezzatura.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilazione / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Ventilazione / Attrezzatura.",
                },
                drugPowerPrioritySecurity = {
                    label = "Sicurezza / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Attrezzatura di sicurezza.",
                },
                drugPowerPriorityGrowing = {
                    label = "Coltivazione / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Coltivazione / Attrezzatura.",
                },
                drugPowerPriorityLight = {
                    label = "Illuminazione / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Illuminazione / Attrezzatura.",
                },
                drugPowerPriorityTesting = {
                    label = "Analisi / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Analisi / Attrezzatura.",
                },
                drugPowerPriorityPackaging = {
                    label = "Confezionamento / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Confezionamento / Attrezzatura.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chimica / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Chimica / Attrezzatura.",
                },
                drugPowerPriorityHeating = {
                    label = "Riscaldamento / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Riscaldamento / Attrezzatura.",
                },
                drugPowerPriorityPressing = {
                    label = "Pressatura / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Pressatura / Attrezzatura.",
                },
                drugPowerPriorityGeneral = {
                    label = "Generale / Priorità",
                    description = "Priorità del distacco automatico dei carichi: Attrezzatura generale.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Prestazioni / Inattivo / Controllo / Intervallo / ms",
                    description = "Parametro di funzionamento per Prestazioni / Inattivo / Controllo / Intervallo / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Prestazioni / Interazione / Inattivo / Intervallo di scansione / ms",
                    description = "Parametro di funzionamento per Prestazioni / Interazione / Inattivo / Intervallo di scansione / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Prestazioni / Interazione / Avviso di interazione / Intervallo / ms",
                    description = "Parametro di funzionamento per Prestazioni / Interazione / Avviso di interazione / Intervallo / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Prestazioni / Interazione / Intervallo di scansione / ms",
                    description = "Parametro di funzionamento per Prestazioni / Interazione / Intervallo di scansione / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Prestazioni / Minimo / Intervallo di scansione / ms",
                    description = "Parametro di funzionamento per Prestazioni / Minimo / Intervallo di scansione / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Prestazioni / Strada / Ped / Attivazione / Distanza",
                    description = "Parametro di funzionamento per Prestazioni / Strada / Ped / Attivazione / Distanza.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Prestazioni / Strada / Ped / Inattivo / Intervallo di scansione / ms",
                    description = "Parametro di funzionamento per Prestazioni / Strada / Ped / Inattivo / Intervallo di scansione / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Prestazioni / Strada / Ped / Intervallo di scansione / ms",
                    description = "Parametro di funzionamento per Prestazioni / Strada / Ped / Intervallo di scansione / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Prestazioni / Mondo / Cache / Margine aggiuntivo",
                    description = "Parametro di funzionamento per Prestazioni / Mondo / Cache / Margine aggiuntivo.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Prestazioni / Mondo / Cache / Aggiornamento / Intervallo / ms",
                    description = "Parametro di funzionamento per Prestazioni / Mondo / Cache / Aggiornamento / Intervallo / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Prestazioni / Mondo / Inattivo / Intervallo / ms",
                    description = "Parametro di funzionamento per Prestazioni / Mondo / Inattivo / Intervallo / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Mercato Dinamico / Bonus di crescita di qualità / secondi",
                    description = "Parametro di funzionamento per Mercato Dinamico / Bonus di crescita di qualità / secondi.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Mercato Dinamico / Azione / Limite cronologia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Azione / Limite cronologia.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Mercato Dinamico / Quantità / Saturazione / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Quantità / Saturazione / Peso.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Mercato Dinamico / Valore base / Precisione dell'intelligence",
                    description = "Parametro di funzionamento per Mercato Dinamico / Valore base / Precisione dell'intelligence.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Mercato Dinamico / Valore predefinito / Media / Qualità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Valore predefinito / Media / Qualità.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Mercato Dinamico / Valore predefinito / Risorsa / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Valore predefinito / Risorsa / Elasticità.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Mercato Dinamico / Domanda / Valore centrale",
                    description = "Parametro di funzionamento per Mercato Dinamico / Domanda / Valore centrale.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Mercato Dinamico / Domanda / Prezzo / Impatto",
                    description = "Parametro di funzionamento per Mercato Dinamico / Domanda / Prezzo / Impatto.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Mercato Dinamico / Direzione / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Direzione / Soglia.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Mercato Dinamico / Abilitato",
                    description = "Parametro di funzionamento per Mercato Dinamico / Abilitato.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Mercato Dinamico / Evento / Possibilità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Evento / Possibilità.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Mercato Dinamico / Evento / Durata / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Evento / Durata / Minuti.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Mercato Dinamico / Evento / Minimo / Durata / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Evento / Minimo / Durata / Minuti.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Mercato Dinamico / Evento / Intensità / Massimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Evento / Intensità / Massimo.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Mercato Dinamico / Evento / Intensità / Minimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Evento / Intensità / Minimo.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Mercato Dinamico / Eventi / Operazione di polizia / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Operazione di polizia / Domanda.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Mercato Dinamico / Eventi / Operazione di polizia / Polizia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Operazione di polizia / Polizia.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Mercato Dinamico / Eventi / Operazione di polizia / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Operazione di polizia / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Mercato Dinamico / Eventi / Festival / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Domanda.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Mercato Dinamico / Eventi / Festival / Effetti / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Effetti / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Mercato Dinamico / Eventi / Festival / Effetti / 2",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Effetti / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Mercato Dinamico / Eventi / Festival / Effetti / 3",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Effetti / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Mercato Dinamico / Eventi / Festival / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Mercato Dinamico / Eventi / Festival / Profili / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festival / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Mercato Dinamico / Eventi / Conflitto tra gang / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Conflitto tra gang / Domanda.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Mercato Dinamico / Eventi / Conflitto tra gang / Polizia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Conflitto tra gang / Polizia.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Mercato Dinamico / Eventi / Conflitto tra gang / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Conflitto tra gang / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Mercato Dinamico / Eventi / Conflitto tra gang / Profili / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Conflitto tra gang / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Mercato Dinamico / Eventi / Retata al laboratorio / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Retata al laboratorio / Domanda.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Mercato Dinamico / Eventi / Retata al laboratorio / Polizia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Retata al laboratorio / Polizia.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Mercato Dinamico / Eventi / Retata al laboratorio / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Retata al laboratorio / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Mercato Dinamico / Eventi / Retata al laboratorio / Fornitura",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Retata al laboratorio / Fornitura.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Mercato Dinamico / Eventi / Festa / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Domanda.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Mercato Dinamico / Eventi / Festa / Effetti / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Effetti / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Mercato Dinamico / Eventi / Festa / Effetti / 2",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Effetti / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Mercato Dinamico / Eventi / Festa / Effetti / 3",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Effetti / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Mercato Dinamico / Eventi / Festa / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Mercato Dinamico / Eventi / Festa / Profili / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Mercato Dinamico / Eventi / Festa / Profili / 2",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Festa / Profili / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Mercato Dinamico / Eventi / Carenza / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Carenza / Domanda.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Mercato Dinamico / Eventi / Carenza / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Carenza / Prezzo.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Mercato Dinamico / Eventi / Carenza / Fornitura",
                    description = "Parametro di funzionamento per Mercato Dinamico / Eventi / Carenza / Fornitura.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Mercato Dinamico / Informazioni esatte / Reputazione",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni esatte / Reputazione.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Mercato Dinamico / Informazioni esatte / Fiducia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni esatte / Fiducia.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Mercato Dinamico / Globale / Zona / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Globale / Zona / Etichetta.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Mercato Dinamico / Limite cronologia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Limite cronologia.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Mercato Dinamico / Valore iniziale / Domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Valore iniziale / Domanda.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Mercato Dinamico / Valore iniziale / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Valore iniziale / Moltiplicatore Prezzo.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Mercato Dinamico / Informazioni / Domanda / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Domanda / Errore.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Mercato Dinamico / Informazioni / Massimo / Precisione",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Massimo / Precisione.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Mercato Dinamico / Informazioni / Minimo / Precisione",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Minimo / Precisione.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Mercato Dinamico / Informazioni / Polizia / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Polizia / Errore.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Mercato Dinamico / Informazioni / Prezzo / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Errore.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Mercato Dinamico / Informazioni / Prezzo / Massimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Massimo.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Mercato Dinamico / Informazioni / Prezzo / Minimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Prezzo / Minimo.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Mercato Dinamico / Informazioni / Reputazione / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Reputazione / Peso.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Mercato Dinamico / Informazioni / Risorsa / Prezzo / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Risorsa / Prezzo / Errore.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Mercato Dinamico / Informazioni / Saturazione / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Saturazione / Errore.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Mercato Dinamico / Finestra del seme delle informazioni / secondi",
                    description = "Parametro di funzionamento per Mercato Dinamico / Finestra del seme delle informazioni / secondi.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Mercato Dinamico / Informazioni / Stato / Precisione / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Stato / Precisione / Soglia.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Mercato Dinamico / Informazioni / Stato / Errore / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Stato / Errore / Soglia.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Mercato Dinamico / Informazioni / Fornitura / Errore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Fornitura / Errore.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Mercato Dinamico / Informazioni / Fiducia / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Informazioni / Fiducia / Peso.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Mercato Dinamico / Manipolazione / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Minuti tempo di attesa.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Mercato Dinamico / Manipolazione / Domanda / Variazione",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Domanda / Variazione.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Mercato Dinamico / Manipolazione / Durata / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Durata / Minuti.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Mercato Dinamico / Manipolazione / Pressione della polizia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Pressione della polizia.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Mercato Dinamico / Manipolazione / Minimo / Lotto / Quantità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Minimo / Lotto / Quantità.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Mercato Dinamico / Manipolazione / Conto di pagamento",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Conto di pagamento.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Mercato Dinamico / Manipolazione / Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Prezzo.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Mercato Dinamico / Manipolazione / Zona / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Manipolazione / Zona / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Mercato Dinamico / Massimo / Età dell'intelligence / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Massimo / Età dell'intelligence / Minuti.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Mercato Dinamico / Massimo / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Massimo / Moltiplicatore Prezzo.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Mercato Dinamico / Minimo / Età dell'intelligence / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Minimo / Età dell'intelligence / Minuti.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Mercato Dinamico / Minimo / Metrica / Finestra temporale / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Minimo / Metrica / Finestra temporale / Minuti.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Mercato Dinamico / Prezzo minimo / Moltiplicatore",
                    description = "Parametro di funzionamento per Mercato Dinamico / Prezzo minimo / Moltiplicatore.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Mercato Dinamico / Minimo / Aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Minimo / Aggiornamento / Minuti.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Mercato Dinamico / Polizia / Domanda / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Polizia / Domanda / Peso.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Mercato Dinamico / Polizia / Prezzo / Impatto",
                    description = "Parametro di funzionamento per Mercato Dinamico / Polizia / Prezzo / Impatto.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Mercato Dinamico / Scarsa qualità / Domanda / Penalità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Scarsa qualità / Domanda / Penalità.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Mercato Dinamico / Scarsa qualità / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Scarsa qualità / Soglia.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Mercato Dinamico / Qualità premium / Bonus domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Qualità premium / Bonus domanda.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Mercato Dinamico / Qualità premium / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Qualità premium / Soglia.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Mercato Dinamico / Produzione / Fornitura / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Produzione / Fornitura / Peso.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Mercato Dinamico / Produzione / Finestra temporale / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Produzione / Finestra temporale / Minuti.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Mercato Dinamico / Qualità / Valore centrale",
                    description = "Parametro di funzionamento per Mercato Dinamico / Qualità / Valore centrale.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Mercato Dinamico / Qualità / Affidabilità / Impatto",
                    description = "Parametro di funzionamento per Mercato Dinamico / Qualità / Affidabilità / Impatto.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Mercato Dinamico / Qualità / Intervallo di valori",
                    description = "Parametro di funzionamento per Mercato Dinamico / Qualità / Intervallo di valori.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Mercato Dinamico / Rarità / Bonus / Massimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Rarità / Bonus / Massimo.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Mercato Dinamico / Regionale / Globale / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Regionale / Globale / Peso.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Mercato Dinamico / Regionale / Locale / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Regionale / Locale / Peso.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Mercato Dinamico / Risorsa / Alias / Droga / Confezionamento",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Alias / Droga / Confezionamento.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Mercato Dinamico / Risorsa / Alias / Tanica di carburante",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Alias / Tanica di carburante.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Mercato Dinamico / Risorsa / Alias / Olio per macchine",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Alias / Olio per macchine.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Mercato Dinamico / Risorsa / Alias / Nutrienti per piante",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Alias / Nutrienti per piante.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Mercato Dinamico / Risorsa / Alias / Kit riparazione",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Alias / Kit riparazione.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Mercato Dinamico / Risorsa / Direzione / Calo / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Direzione / Calo / Soglia.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Mercato Dinamico / Risorsa / Direzione / Aumento / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorsa / Direzione / Aumento / Soglia.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 2",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 3",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Filtro a carboni attivi / Droghe collegate / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Mercato Dinamico / Risorse / Precursore chimico / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Precursore chimico / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Mercato Dinamico / Risorse / Precursore chimico / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Precursore chimico / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Mercato Dinamico / Risorse / Precursore chimico / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Precursore chimico / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Mercato Dinamico / Risorse / Precursore chimico / Droghe collegate / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Precursore chimico / Droghe collegate / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Mercato Dinamico / Risorse / Precursore chimico / Droghe collegate / 2",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Precursore chimico / Droghe collegate / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Mercato Dinamico / Risorse / Componenti per Attrezzatura / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Componenti per Attrezzatura / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Mercato Dinamico / Risorse / Componenti per Attrezzatura / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Componenti per Attrezzatura / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Mercato Dinamico / Risorse / Componenti per Attrezzatura / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Componenti per Attrezzatura / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Mercato Dinamico / Risorse / Fertilizzante / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Fertilizzante / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Mercato Dinamico / Risorse / Fertilizzante / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Fertilizzante / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Mercato Dinamico / Risorse / Fertilizzante / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Fertilizzante / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Mercato Dinamico / Risorse / Fertilizzante / Droghe collegate / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Fertilizzante / Droghe collegate / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Mercato Dinamico / Risorse / Carburante da Laboratorio / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Carburante da Laboratorio / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Mercato Dinamico / Risorse / Carburante da Laboratorio / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Carburante da Laboratorio / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Mercato Dinamico / Risorse / Carburante da Laboratorio / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Carburante da Laboratorio / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Mercato Dinamico / Risorse / Sacchetto da imballaggio / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Sacchetto da imballaggio / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Mercato Dinamico / Risorse / Sacchetto da imballaggio / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Sacchetto da imballaggio / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Mercato Dinamico / Risorse / Sacchetto da imballaggio / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Sacchetto da imballaggio / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Mercato Dinamico / Risorse / Vaso / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Vaso / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Mercato Dinamico / Risorse / Vaso / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Vaso / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Mercato Dinamico / Risorse / Vaso / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Vaso / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Mercato Dinamico / Risorse / Vaso / Droghe collegate / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Vaso / Droghe collegate / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Mercato Dinamico / Risorse / Seme di cannabis / Prezzo Base",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Seme di cannabis / Prezzo Base.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Mercato Dinamico / Risorse / Seme di cannabis / Elasticità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Seme di cannabis / Elasticità.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Mercato Dinamico / Risorse / Seme di cannabis / Etichetta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Seme di cannabis / Etichetta.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Mercato Dinamico / Risorse / Seme di cannabis / Droghe collegate / 1",
                    description = "Parametro di funzionamento per Mercato Dinamico / Risorse / Seme di cannabis / Droghe collegate / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Mercato Dinamico / Vendite / Finestra temporale / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Vendite / Finestra temporale / Minuti.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Mercato Dinamico / Saturazione / Domanda / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Saturazione / Domanda / Peso.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Mercato Dinamico / Saturazione / Prezzo / Impatto",
                    description = "Parametro di funzionamento per Mercato Dinamico / Saturazione / Prezzo / Impatto.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Mercato Dinamico / Scarsità / Domanda / Peso",
                    description = "Parametro di funzionamento per Mercato Dinamico / Scarsità / Domanda / Peso.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Mercato Dinamico / Scarsità / Prezzo / Impatto",
                    description = "Parametro di funzionamento per Mercato Dinamico / Scarsità / Prezzo / Impatto.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Mercato Dinamico / Stagione / Fine / Mesi / Dicembre",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Fine / Mesi / Dicembre.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Mercato Dinamico / Stagione / Fine / Mesi / Primavera",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Fine / Mesi / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Mercato Dinamico / Stagione / Fine / Mesi / Estate",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Fine / Mesi / Estate.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Mercato Dinamico / Stagione / Fine / Mesi / Inverno",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Fine / Mesi / Inverno.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Mercato Dinamico / Stagione / Moltiplicatori / Autunno",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Moltiplicatori / Autunno.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Mercato Dinamico / Stagione / Moltiplicatori / Primavera",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Moltiplicatori / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Mercato Dinamico / Stagione / Moltiplicatori / Estate",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Moltiplicatori / Estate.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Mercato Dinamico / Stagione / Moltiplicatori / Inverno",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stagione / Moltiplicatori / Inverno.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Mercato Dinamico / Carenza / Voce / Soglia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Carenza / Voce / Soglia.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Mercato Dinamico / Stato / Soglie / Alta domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stato / Soglie / Alta domanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Mercato Dinamico / Stato / Soglie / Ricercato",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stato / Soglie / Ricercato.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Mercato Dinamico / Stato / Soglie / Bassa domanda",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stato / Soglie / Bassa domanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Mercato Dinamico / Stato / Soglie / Saturato",
                    description = "Parametro di funzionamento per Mercato Dinamico / Stato / Soglie / Saturato.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Mercato Dinamico / Obiettivo / Fornitura",
                    description = "Parametro di funzionamento per Mercato Dinamico / Obiettivo / Fornitura.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Mercato Dinamico / Tendenza / Possibilità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Possibilità.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Mercato Dinamico / Tendenza / Durata / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Durata / Minuti.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Mercato Dinamico / Tendenza / Massimo / Intensità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Massimo / Intensità.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Mercato Dinamico / Tendenza / Minimo / Intensità",
                    description = "Parametro di funzionamento per Mercato Dinamico / Tendenza / Minimo / Intensità.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Mercato Dinamico / Aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Mercato Dinamico / Aggiornamento / Minuti.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Mercato Dinamico / Volatilità / Massimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Volatilità / Massimo.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Mercato Dinamico / Volatilità / Minimo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Volatilità / Minimo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Mercato Dinamico / Meteo / Moltiplicatori / Freddo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Moltiplicatori / Freddo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Mercato Dinamico / Meteo / Moltiplicatori / Ondata di caldo",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Moltiplicatori / Ondata di caldo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Mercato Dinamico / Meteo / Moltiplicatori / Normale",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Moltiplicatori / Normale.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Mercato Dinamico / Meteo / Moltiplicatori / Pioggia",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Moltiplicatori / Pioggia.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Mercato Dinamico / Meteo / Moltiplicatori / Tempesta",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Moltiplicatori / Tempesta.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Mercato Dinamico / Meteo / Stato",
                    description = "Parametro di funzionamento per Mercato Dinamico / Meteo / Stato.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Sospetto e rischio / Bonus di crescita di qualità / secondi",
                    description = "Parametro di funzionamento per Sospetto e rischio / Bonus di crescita di qualità / secondi.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Sospetto e rischio / Attività / Rischio / Pesi / Quantità",
                    description = "Parametro di funzionamento per Sospetto e rischio / Attività / Rischio / Pesi / Quantità.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Sospetto e rischio / Attività / Rischio / Pesi / Durata / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Attività / Rischio / Pesi / Durata / Minuti.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Sospetto e rischio / Attività / Rischio / Pesi / Pressione della polizia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Attività / Rischio / Pesi / Pressione della polizia.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Sospetto e rischio / Attività / Rischio / Pesi / Reputazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Attività / Rischio / Pesi / Reputazione.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Sospetto e rischio / Attività / Rischio / Pesi / Sicurezza",
                    description = "Parametro di funzionamento per Sospetto e rischio / Attività / Rischio / Pesi / Sicurezza.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Sospetto e rischio / Modalità aggressiva / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Modalità aggressiva / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Sospetto e rischio / Telefono usa e getta / Compromissione / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Compromissione / Soglia.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Sospetto e rischio / Telefono usa e getta / Pressione della polizia / Per vendita all'ingrosso",
                    description = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Pressione della polizia / Per vendita all'ingrosso.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Sospetto e rischio / Telefono usa e getta / Oggetto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Telefono usa e getta / Oggetto.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Sospetto e rischio / Camper in funzione / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Camper in funzione / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Sospetto e rischio / Camper in funzione / Pressione della polizia / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Camper in funzione / Pressione della polizia / Soglia.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Sospetto e rischio / Camper parcheggiato / Pressione della polizia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Camper parcheggiato / Pressione della polizia.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Sospetto e rischio / Contaminazione / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Contaminazione / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Sospetto e rischio / Contaminazione / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Contaminazione / Soglia.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Sospetto e rischio / Coltivazione / Piante senza rischio aggiuntivo",
                    description = "Parametro di funzionamento per Sospetto e rischio / Coltivazione / Piante senza rischio aggiuntivo.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Sospetto e rischio / Coltivazione / Pressione della polizia / Per pianta",
                    description = "Parametro di funzionamento per Sospetto e rischio / Coltivazione / Pressione della polizia / Per pianta.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Sospetto e rischio / Rivenditore / nascosto / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rivenditore / nascosto / Minuti.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Lotto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Lotto.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Camper",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Camper.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Rivenditore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Rivenditore.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Fazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Fazione.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Centro di distribuzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Centro di distribuzione.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Laboratorio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Laboratorio.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Giocatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Giocatore.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Percorso",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Percorso.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Zona",
                    description = "Parametro di funzionamento per Sospetto e rischio / Decadimento / Per ciclo di aggiornamento / Zona.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Sospetto e rischio / Abilitato",
                    description = "Parametro di funzionamento per Sospetto e rischio / Abilitato.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Sospetto e rischio / Presenza della polizia / Pressione della polizia / Critico",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Pressione della polizia / Critico.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Sospetto e rischio / Presenza della polizia / Pressione della polizia / Alto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Pressione della polizia / Alto.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Sospetto e rischio / Presenza della polizia / Pressione della polizia / Bassa",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Pressione della polizia / Bassa.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Sospetto e rischio / Presenza della polizia / Pressione della polizia / Medio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Pressione della polizia / Medio.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Sospetto e rischio / Presenza della polizia / Moltiplicatori / Lotto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Moltiplicatori / Lotto.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Sospetto e rischio / Presenza della polizia / Moltiplicatori / Fazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Moltiplicatori / Fazione.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Sospetto e rischio / Presenza della polizia / Moltiplicatori / Zona",
                    description = "Parametro di funzionamento per Sospetto e rischio / Presenza della polizia / Moltiplicatori / Zona.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Sospetto e rischio / Entità / Tipi / Lotto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Lotto.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Sospetto e rischio / Entità / Tipi / Camper",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Camper.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Sospetto e rischio / Entità / Tipi / Rivenditore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Rivenditore.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Sospetto e rischio / Entità / Tipi / Fazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Fazione.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Sospetto e rischio / Entità / Tipi / Centro di distribuzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Centro di distribuzione.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Sospetto e rischio / Entità / Tipi / Laboratorio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Laboratorio.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Sospetto e rischio / Entità / Tipi / Giocatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Giocatore.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Sospetto e rischio / Entità / Tipi / Percorso",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Percorso.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Sospetto e rischio / Entità / Tipi / Zona",
                    description = "Parametro di funzionamento per Sospetto e rischio / Entità / Tipi / Zona.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Sospetto e rischio / Evento / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Sospetto e rischio / Evento / Minuti tempo di attesa.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Sospetto e rischio / Evento / Limite cronologia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Evento / Limite cronologia.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Sospetto e rischio / Laboratorio / Pressione della polizia / Sincronizzazione / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Laboratorio / Pressione della polizia / Sincronizzazione / Soglia.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Sospetto e rischio / Mantenere un basso profilo / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Minuti tempo di attesa.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Sospetto e rischio / Mantenere un basso profilo / Inattivo / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Inattivo / Minuti.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Sospetto e rischio / Mantenere un basso profilo / Riduzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Mantenere un basso profilo / Riduzione.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Sospetto e rischio / Lockdown / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lockdown / Minuti.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Sospetto e rischio / Minimo / Durata / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Minimo / Durata / Minuti.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Sospetto e rischio / Minimo / Evento / Cooldown (secondi)",
                    description = "Parametro di funzionamento per Sospetto e rischio / Minimo / Evento / Cooldown (secondi).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Sospetto e rischio / Minimo / Inattivo / secondi",
                    description = "Parametro di funzionamento per Sospetto e rischio / Minimo / Inattivo / secondi.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Sospetto e rischio / Lavorazione / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavorazione / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Sospetto e rischio / Rischio / Pesi / Lotto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Lotto.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Sospetto e rischio / Rischio / Pesi / Camper",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Camper.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Sospetto e rischio / Rischio / Pesi / Rivenditore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Rivenditore.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Sospetto e rischio / Rischio / Pesi / Fazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Fazione.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Sospetto e rischio / Rischio / Pesi / Centro di distribuzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Centro di distribuzione.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Sospetto e rischio / Rischio / Pesi / Laboratorio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Laboratorio.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Sospetto e rischio / Rischio / Pesi / Giocatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Giocatore.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Sospetto e rischio / Rischio / Pesi / Percorso",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Percorso.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Sospetto e rischio / Rischio / Pesi / Zona",
                    description = "Parametro di funzionamento per Sospetto e rischio / Rischio / Pesi / Zona.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Sospetto e rischio / Cambia telefono usa e getta / Riduzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Cambia telefono usa e getta / Riduzione.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Sospetto e rischio / Percorso / Controllo / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Percorso / Controllo / Minuti.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Lotto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Lotto.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Camper",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Camper.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Rivenditore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Rivenditore.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Fazione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Fazione.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Centro di distribuzione",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Centro di distribuzione.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Laboratorio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Laboratorio.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Giocatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Giocatore.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Percorso",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Percorso.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Sospetto e rischio / Vendita / Pressione della polizia / Zona",
                    description = "Parametro di funzionamento per Sospetto e rischio / Vendita / Pressione della polizia / Zona.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Sospetto e rischio / Soglie / Critico",
                    description = "Parametro di funzionamento per Sospetto e rischio / Soglie / Critico.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Sospetto e rischio / Soglie / Alto",
                    description = "Parametro di funzionamento per Sospetto e rischio / Soglie / Alto.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Sospetto e rischio / Soglie / Lockdown",
                    description = "Parametro di funzionamento per Sospetto e rischio / Soglie / Lockdown.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Sospetto e rischio / Soglie / Bassa",
                    description = "Parametro di funzionamento per Sospetto e rischio / Soglie / Bassa.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Sospetto e rischio / Soglie / Medio",
                    description = "Parametro di funzionamento per Sospetto e rischio / Soglie / Medio.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Sospetto e rischio / Ciclo di aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Sospetto e rischio / Ciclo di aggiornamento / Minuti.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Sospetto e rischio / Commercio all'ingrosso / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Commercio all'ingrosso / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Raggio d'allerta",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Raggio d'allerta.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Valore base / Possibilità",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Valore base / Possibilità.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Fazione / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Fazione / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Alto / Gravità / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Alto / Gravità / Soglia.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Possibilità / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Possibilità / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Lealtà / Soglia.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Massimo / Possibilità",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Massimo / Possibilità.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Minimo / Cooldown (secondi)",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Minimo / Cooldown (secondi).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Percorso / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Percorso / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Massimo",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Massimo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Minimo",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Minimo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Intensità / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Possibilità / Moltiplicatore",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Possibilità / Moltiplicatore.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Soglia",
                    description = "Parametro di funzionamento per Sospetto e rischio / Lavoratore / Fuga di informazioni / Stress / Soglia.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Rete di contatti / Bonus di crescita di qualità / secondi",
                    description = "Parametro di funzionamento per Rete di contatti / Bonus di crescita di qualità / secondi.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Rete di contatti / Numero di zone attive",
                    description = "Parametro di funzionamento per Rete di contatti / Numero di zone attive.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Rete di contatti / Suggerimento burner / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Suggerimento burner / Fiducia.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Rete di contatti / Telefono usa e getta / Offerta / Massimo / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Telefono usa e getta / Offerta / Massimo / Moltiplicatore.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Rete di contatti / Telefono usa e getta / Offerta / Minimo / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Telefono usa e getta / Offerta / Minimo / Moltiplicatore.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Rete di contatti / Acquirente / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Minuti tempo di attesa.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Rete di contatti / Acquirente / Distanza di consegna",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Distanza di consegna.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Rete di contatti / Acquirente / Premium / Successo / Punteggio",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Premium / Successo / Punteggio.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Rete di contatti / Acquirente / Premium / Fiducia / guadagno",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Premium / Fiducia / guadagno.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Rete di contatti / Acquirente / Richiesta / Calore e Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Richiesta / Calore e Rischio / Peso.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Rete di contatti / Acquirente / Norma / Fiducia / guadagno",
                    description = "Parametro di funzionamento per Rete di contatti / Acquirente / Norma / Fiducia / guadagno.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Rete di contatti / Attesa per attivazione contatto / secondi / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Attesa per attivazione contatto / secondi / Massimo.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Rete di contatti / Attesa per attivazione contatto / secondi / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Attesa per attivazione contatto / secondi / Minimo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Rete di contatti / Contatto / Domanda / Intervallo di valori / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Contatto / Domanda / Intervallo di valori / Massimo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Rete di contatti / Contatto / Domanda / Intervallo di valori / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Contatto / Domanda / Intervallo di valori / Minimo.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Rete di contatti / Contatto / Perdita / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Contatto / Perdita / Fiducia.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Rete di contatti / Darknet / Informazioni esatte / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Darknet / Informazioni esatte / Minuti.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Rete di contatti / Darknet / Zona attiva / Informazioni / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Darknet / Zona attiva / Informazioni / Prezzo.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Rete di contatti / Darknet / Informazioni / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Darknet / Informazioni / Prezzo.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Rete di contatti / Rivenditore / Prezzo Base",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Prezzo Base.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Rete di contatti / Rivenditore / Assunzione / capacità / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / capacità / Massimo.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Rete di contatti / Rivenditore / Assunzione / capacità / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / capacità / Minimo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Rete di contatti / Rivenditore / Assunzione / Rischio / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / Rischio / Massimo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Rete di contatti / Rivenditore / Assunzione / Rischio / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / Rischio / Minimo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Rete di contatti / Rivenditore / Assunzione / Abilità / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / Abilità / Massimo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Rete di contatti / Rivenditore / Assunzione / Abilità / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Assunzione / Abilità / Minimo.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Rete di contatti / Offerte spacciatori / 1 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Rete di contatti / Offerte spacciatori / 1 / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 1 / Oggetto.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Rete di contatti / Offerte spacciatori / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Rete di contatti / Offerte spacciatori / 1 / Fiducia minima",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 1 / Fiducia minima.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Rete di contatti / Offerte spacciatori / 1 / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 1 / Prezzo.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Rete di contatti / Offerte spacciatori / 2 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Rete di contatti / Offerte spacciatori / 2 / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 2 / Oggetto.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Rete di contatti / Offerte spacciatori / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Rete di contatti / Offerte spacciatori / 2 / Fiducia minima",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 2 / Fiducia minima.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Rete di contatti / Offerte spacciatori / 2 / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 2 / Prezzo.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Rete di contatti / Offerte spacciatori / 3 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Rete di contatti / Offerte spacciatori / 3 / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 3 / Oggetto.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Rete di contatti / Offerte spacciatori / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Rete di contatti / Offerte spacciatori / 3 / Fiducia minima",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 3 / Fiducia minima.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Rete di contatti / Offerte spacciatori / 3 / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 3 / Prezzo.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Rete di contatti / Offerte spacciatori / 4 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Rete di contatti / Offerte spacciatori / 4 / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 4 / Oggetto.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Rete di contatti / Offerte spacciatori / 4 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 4 / Etichetta.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Rete di contatti / Offerte spacciatori / 4 / Fiducia minima",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 4 / Fiducia minima.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Rete di contatti / Offerte spacciatori / 4 / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 4 / Prezzo.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Rete di contatti / Offerte spacciatori / 5 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Rete di contatti / Offerte spacciatori / 5 / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 5 / Oggetto.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Rete di contatti / Offerte spacciatori / 5 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 5 / Etichetta.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Rete di contatti / Offerte spacciatori / 5 / Fiducia minima",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 5 / Fiducia minima.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Rete di contatti / Offerte spacciatori / 5 / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Offerte spacciatori / 5 / Prezzo.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Rete di contatti / Rivenditore / Protezione / Ore",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Protezione / Ore.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Rete di contatti / Rivenditore / Protezione / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Protezione / Prezzo.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Rete di contatti / Rivenditore / Vendita / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Vendita / Massimo.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Rete di contatti / Rivenditore / Vendita / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Vendita / Minimo.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Modalità aggressiva / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Modalità aggressiva / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Qualità di base / Fattore prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Qualità di base / Fattore prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Rete di contatti / Rivenditore / Simulazione / All'ingrosso / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / All'ingrosso / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Vendite economiche / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Vendite economiche / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Valore predefinito / Qualità",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Valore predefinito / Qualità.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Soglia di slealtà",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Soglia di slealtà.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Esperienza / Per livello",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Esperienza / Per livello.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Esperienza / Per unità",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Esperienza / Per unità.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Incidente / Lealtà / Perdita",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Incidente / Lealtà / Perdita.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Incidente / Verifica casuale / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Incidente / Verifica casuale / Massimo.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Livello / Prezzo / Bonus",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Livello / Prezzo / Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Livello / Vendita / Divisore",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Livello / Vendita / Divisore.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Lealtà / Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Lealtà / Rischio / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Massimo / Incidente / Possibilità",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Massimo / Incidente / Possibilità.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Massimo / Livello",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Massimo / Livello.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Premium / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Premium / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Profilo / Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Profilo / Rischio / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Protezione / Rischio / Riduzione",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Protezione / Rischio / Riduzione.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Qualità / Prezzo / Divisore",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Qualità / Prezzo / Divisore.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Recupero / Valore base / Possibilità",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Recupero / Valore base / Possibilità.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Recupero / Lealtà / Peso",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Recupero / Lealtà / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Perdita scorte per rapina",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Perdita scorte per rapina.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Abilità / Rischio / Riduzione",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Abilità / Rischio / Riduzione.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Abilità / Vendita / Divisore",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Abilità / Vendita / Divisore.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Soglia di lealtà stabile",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Soglia di lealtà stabile.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Territorio / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Territorio / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Rete di contatti / Rivenditore / Simulazione / Territorio / Rischio / Riduzione",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Simulazione / Territorio / Rischio / Riduzione.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Rete di contatti / Rivenditore / Ciclo di aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Ciclo di aggiornamento / Minuti.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Rete di contatti / Rivenditore / Salario",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Rete di contatti / Rivenditore / Salario / Decadimento",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario / Decadimento.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Rete di contatti / Rivenditore / Salario / Lealtà / guadagno",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Salario / Lealtà / guadagno.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Rete di contatti / Rivenditore / Debolezze / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Debolezze / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Rete di contatti / Rivenditore / Debolezze / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Debolezze / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Rete di contatti / Rivenditore / Debolezze / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Debolezze / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Rete di contatti / Rivenditore / Debolezze / 4",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Debolezze / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Rete di contatti / Rivenditore / Debolezze / 5",
                    description = "Parametro di funzionamento per Rete di contatti / Rivenditore / Debolezze / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Rete di contatti / Valore predefinito / Contatto / Domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Contatto / Domanda.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Rete di contatti / Valore predefinito / Contatto / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Contatto / Rischio.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Rete di contatti / Spacciatore predefinito / capacità",
                    description = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / capacità.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Rete di contatti / Spacciatore predefinito / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / Rischio.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Rete di contatti / Spacciatore predefinito / Abilità",
                    description = "Parametro di funzionamento per Rete di contatti / Spacciatore predefinito / Abilità.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Rete di contatti / Valore predefinito / Zona attiva / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Valore predefinito / Zona attiva / Raggio.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Rete di contatti / Reset domanda (minuti)",
                    description = "Parametro di funzionamento per Rete di contatti / Reset domanda (minuti).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Rete di contatti / Abilitato",
                    description = "Parametro di funzionamento per Rete di contatti / Abilitato.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Rete di contatti / Posizione esatta / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione esatta / Fiducia.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Rete di contatti / Fazione / Scoperta / Reputazione",
                    description = "Parametro di funzionamento per Rete di contatti / Fazione / Scoperta / Reputazione.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Rete di contatti / Fazione / Indizio / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Fazione / Indizio / Fiducia.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Rete di contatti / Consegna fallita / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Rete di contatti / Consegna fallita / Minuti tempo di attesa.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Rete di contatti / Finto affare / Incontro / Attaccante / Numero",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Attaccante / Numero.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Attaccante / Modelli / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Rete di contatti / Finto affare / Incontro / Durata (secondi)",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Durata (secondi).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Polizia / Modelli / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Rete di contatti / Finto affare / Incontro / Raggio di Spawn",
                    description = "Parametro di funzionamento per Rete di contatti / Finto affare / Incontro / Raggio di Spawn.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Rete di contatti / Valore sostitutivo / Droga Preferita",
                    description = "Parametro di funzionamento per Rete di contatti / Valore sostitutivo / Droga Preferita.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Rete di contatti / Valore sostitutivo / Etichetta prodotto",
                    description = "Parametro di funzionamento per Rete di contatti / Valore sostitutivo / Etichetta prodotto.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Rete di contatti / Guida / Libro / Oggetto",
                    description = "Parametro di funzionamento per Rete di contatti / Guida / Libro / Oggetto.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Rete di contatti / Guida / Libro / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Guida / Libro / Fiducia.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Rete di contatti / Assumi dealer / Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Assumi dealer / Prezzo.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Rete di contatti / Limite cronologia",
                    description = "Parametro di funzionamento per Rete di contatti / Limite cronologia.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Rete di contatti / Zona attiva / Informazioni / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Zona attiva / Informazioni / Minuti.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Rete di contatti / Zona attiva / Rotazione / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Zona attiva / Rotazione / Minuti.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Rete di contatti / Annuncio / Durata / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Annuncio / Durata / Minuti.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Rete di contatti / Massimo / Di proprietà / Rivenditori",
                    description = "Parametro di funzionamento per Rete di contatti / Massimo / Di proprietà / Rivenditori.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Rete di contatti / Minimo / Acquirente / Distanza di consegna",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Acquirente / Distanza di consegna.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Rete di contatti / Minimo / Rotazione contatti (minuti)",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Rotazione contatti (minuti).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Rete di contatti / Minimo / Reset domanda (minuti)",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Reset domanda (minuti).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Rete di contatti / Minimo / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Rete di contatti / Minimo / Zona attiva / Informazioni / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Informazioni / Minuti.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Rete di contatti / Minimo / Zona attiva / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Raggio.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Rete di contatti / Minimo / Zona attiva / Rotazione / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Zona attiva / Rotazione / Minuti.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Rete di contatti / Minimo / Annuncio / Durata / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Annuncio / Durata / Minuti.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Rete di contatti / Ricompensa minima / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Ricompensa minima / Moltiplicatore.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Rete di contatti / Minimo / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Rete di contatti / Minimo / Posizione / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Minimo / Posizione / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Rete di contatti / Altro / Droga / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Altro / Droga / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Rete di contatti / Conto di pagamento",
                    description = "Parametro di funzionamento per Rete di contatti / Conto di pagamento.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Rete di contatti / Dopo la consegna / Domanda / Reset / secondi",
                    description = "Parametro di funzionamento per Rete di contatti / Dopo la consegna / Domanda / Reset / secondi.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Rete di contatti / Droga Preferita / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Droga Preferita / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Rete di contatti / Regione / Posizione / Fiducia",
                    description = "Parametro di funzionamento per Rete di contatti / Regione / Posizione / Fiducia.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Rete di contatti / Richiesta / Quantità / All'ingrosso / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / All'ingrosso / Massimo.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Rete di contatti / Richiesta / Quantità / All'ingrosso / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / All'ingrosso / Minimo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Rete di contatti / Richiesta / Quantità / Premium / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / Premium / Massimo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Rete di contatti / Richiesta / Quantità / Premium / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / Premium / Minimo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Rete di contatti / Richiesta / Quantità / Norma / Massimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / Norma / Massimo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Rete di contatti / Richiesta / Quantità / Norma / Minimo",
                    description = "Parametro di funzionamento per Rete di contatti / Richiesta / Quantità / Norma / Minimo.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Rete di contatti / Rotazione / Minuti",
                    description = "Parametro di funzionamento per Rete di contatti / Rotazione / Minuti.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore di strada / 3 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Acquirente predefinito / 3 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore predefinito / 3 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Spacciatore della rete / 3 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Intermediario premium / 3 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 1 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 2 / Rischio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / W",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Coordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Regione.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di contatti / Posizione / Gruppi di selezione / Contatto all'ingrosso / 3 / Rischio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Bonus di accettazione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Bonus di accettazione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Archetipo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Archetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Coordinate / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Bonus domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Bonus domanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Etichetta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 4",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Droghe preferite / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Raggio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Regione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 1 / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 1 / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Bonus di accettazione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Bonus di accettazione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Archetipo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Archetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Coordinate / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Bonus domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Bonus domanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Etichetta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Qualità minima",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Qualità minima.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Droghe preferite / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Droghe preferite / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Droghe preferite / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Droghe preferite / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Raggio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Regione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 2 / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 2 / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Bonus di accettazione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Bonus di accettazione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Archetipo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Archetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Coordinate / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Bonus domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Bonus domanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Etichetta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Droghe preferite / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Raggio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Regione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 3 / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 3 / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Bonus di accettazione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Bonus di accettazione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Archetipo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Archetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Coordinate / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Bonus domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Bonus domanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Etichetta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 3",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Droghe preferite / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Raggio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Regione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 4 / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 4 / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Bonus di accettazione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Bonus di accettazione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Archetipo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Archetipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Coordinate / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Coordinate / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Coordinate / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Bonus domanda",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Bonus domanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Pressione della polizia / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Pressione della polizia / Moltiplicatore.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / ID",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Etichetta",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Etichetta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Droghe preferite / 1",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Droghe preferite / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Droghe preferite / 2",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Droghe preferite / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Moltiplicatore Prezzo",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Moltiplicatore Prezzo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Raggio",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Raggio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Regione",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Regione.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Rete di contatti / Strada / Zone attive / 5 / Rapine / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di contatti / Strada / Zone attive / 5 / Rapine / Moltiplicatore.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Rete di contatti / Fiducia / Livelli / Conosciuto",
                    description = "Parametro di funzionamento per Rete di contatti / Fiducia / Livelli / Conosciuto.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Rete di contatti / Fiducia / Livelli / Affidabile",
                    description = "Parametro di funzionamento per Rete di contatti / Fiducia / Livelli / Affidabile.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Rete di contatti / Fiducia / Livelli / Fidato",
                    description = "Parametro di funzionamento per Rete di contatti / Fiducia / Livelli / Fidato.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Rete di attività / Bonus di crescita di qualità / secondi",
                    description = "Parametro di funzionamento per Rete di attività / Bonus di crescita di qualità / secondi.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Rete di attività / Saldo / Valore base / Prezzo unitario",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Valore base / Prezzo unitario.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Rete di attività / Saldo / Calore della rete / Per spacciatore",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Calore della rete / Per spacciatore.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Rete di attività / Saldo / Calore della rete / Per centro di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Calore della rete / Per centro di distribuzione.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Rete di attività / Saldo / Calore della rete / Per rotta",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Calore della rete / Per rotta.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Rete di attività / Saldo / Calore della rete / Per dipendente",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Calore della rete / Per dipendente.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Rete di attività / Saldo / Affidabilità / guadagno",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Affidabilità / guadagno.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Rete di attività / Saldo / Affidabilità / Perdita",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Affidabilità / Perdita.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Rete di attività / Saldo / Percorso / Pressione della polizia / Decadimento",
                    description = "Parametro di funzionamento per Rete di attività / Saldo / Percorso / Pressione della polizia / Decadimento.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Rete di attività / Contratti / Categorie / gang / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / gang / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / gang / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Rete NPC / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Rete NPC / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Organizzazione / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Organizzazione / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Premium / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Premium / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Spacciatore / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Spacciatore / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Speciale / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Speciale / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Quantità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Quantità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Quantità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Quantità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Minimo / Classifica",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Minimo / Classifica.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Qualità / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Qualità / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Qualità / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Qualità / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Ricompensa / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Ricompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Ricompensa / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Ricompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Rischio / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Rischio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Rischio / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Categorie / Commercio all'ingrosso / Rischio / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Rete di attività / Contratti / Distanza di consegna",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Distanza di consegna.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Rete di attività / Contratti / Durata / Minuti / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Durata / Minuti / Massimo.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Rete di attività / Contratti / Durata / Minuti / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Durata / Minuti / Minimo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Coordinate / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Etichetta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Regione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Regione.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Ricompensa / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Ricompensa / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 1 / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 1 / Rischio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Coordinate / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Etichetta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Regione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Regione.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Ricompensa / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Ricompensa / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 2 / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 2 / Rischio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Coordinate / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Etichetta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Regione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Regione.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Ricompensa / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Ricompensa / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 3 / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 3 / Rischio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / X",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / Y",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / Z",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Coordinate / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Etichetta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Regione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Regione.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Ricompensa / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Ricompensa / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Rete di attività / Contratti / Incontro / Punti / 4 / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Incontro / Punti / 4 / Rischio.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 1",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 2",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 3",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Anticipo / Opzioni / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Rete di attività / Contratti / Trattativa / Quantità / Margine di trattativa / Percentuale",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Quantità / Margine di trattativa / Percentuale.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Rete di attività / Contratti / Trattativa / Valore base / Accettazione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Valore base / Accettazione.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Rete di attività / Contratti / Trattativa / Scadenza / Margine di trattativa / Percentuale",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Scadenza / Margine di trattativa / Percentuale.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Rete di attività / Contratti / Trattativa / Massimo / Turni",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Massimo / Turni.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Rete di attività / Contratti / Trattativa / Qualità / Margine di trattativa",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Qualità / Margine di trattativa.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Rete di attività / Contratti / Trattativa / Rifiuto / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Rifiuto / Minuti tempo di attesa.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Rete di attività / Contratti / Trattativa / Round / Pressione",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Trattativa / Round / Pressione.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Rete di attività / Contratti / Offerta / Numero",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Offerta / Numero.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Rete di attività / Contratti / Aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Contratti / Aggiornamento / Minuti.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Rete di attività / Valore predefinito / Nome dell'azienda",
                    description = "Parametro di funzionamento per Rete di attività / Valore predefinito / Nome dell'azienda.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Rete di attività / Valore predefinito / Classifica / ID",
                    description = "Parametro di funzionamento per Rete di attività / Valore predefinito / Classifica / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Rete di attività / Valore predefinito / Personale / Stile di lavoro",
                    description = "Parametro di funzionamento per Rete di attività / Valore predefinito / Personale / Stile di lavoro.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Rete di attività / Valore predefinito / Trasporti",
                    description = "Parametro di funzionamento per Rete di attività / Valore predefinito / Trasporti.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Rete di attività / Abilitato",
                    description = "Parametro di funzionamento per Rete di attività / Abilitato.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Rete di attività / Centri di distribuzione / Centro di distribuzione / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Centro di distribuzione / capacità.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Rete di attività / Centri di distribuzione / Centro di distribuzione / Prezzo",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Centro di distribuzione / Prezzo.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Rete di attività / Centri di distribuzione / Centro di distribuzione / Sicurezza",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Centro di distribuzione / Sicurezza.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Rete di attività / Centri di distribuzione / Centro di distribuzione / Mantenimento",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Centro di distribuzione / Mantenimento.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Rete di attività / Centri di distribuzione / Nascondiglio / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Nascondiglio / capacità.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Rete di attività / Centri di distribuzione / Nascondiglio / Prezzo",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Nascondiglio / Prezzo.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Rete di attività / Centri di distribuzione / Nascondiglio / Sicurezza",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Nascondiglio / Sicurezza.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Rete di attività / Centri di distribuzione / Nascondiglio / Mantenimento",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Nascondiglio / Mantenimento.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Rete di attività / Centri di distribuzione / Magazzino / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Magazzino / capacità.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Rete di attività / Centri di distribuzione / Magazzino / Prezzo",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Magazzino / Prezzo.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Rete di attività / Centri di distribuzione / Magazzino / Sicurezza",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Magazzino / Sicurezza.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Rete di attività / Centri di distribuzione / Magazzino / Mantenimento",
                    description = "Parametro di funzionamento per Rete di attività / Centri di distribuzione / Magazzino / Mantenimento.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Rete di attività / Limiti / Contratti attivi",
                    description = "Parametro di funzionamento per Rete di attività / Limiti / Contratti attivi.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Rete di attività / Limiti / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Limiti / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Rete di attività / Limiti / Registro contabile / Righe",
                    description = "Parametro di funzionamento per Rete di attività / Limiti / Registro contabile / Righe.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Rete di attività / Limiti / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Limiti / Rotte.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Rete di attività / Limiti / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Limiti / Personale.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Rete di attività / Pagamento / Conto",
                    description = "Parametro di funzionamento per Rete di attività / Pagamento / Conto.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Rete di attività / Gradi / 1 / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Contratti.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Rete di attività / Gradi / 1 / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Rete di attività / Gradi / 1 / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Rete di attività / Gradi / 1 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Rete di attività / Gradi / 1 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Etichetta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Rete di attività / Gradi / 1 / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Rotte.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Rete di attività / Gradi / 1 / Punteggio",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Punteggio.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Rete di attività / Gradi / 1 / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 1 / Personale.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Rete di attività / Gradi / 2 / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Contratti.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Rete di attività / Gradi / 2 / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Rete di attività / Gradi / 2 / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Rete di attività / Gradi / 2 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Rete di attività / Gradi / 2 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Etichetta.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Rete di attività / Gradi / 2 / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Rotte.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Rete di attività / Gradi / 2 / Punteggio",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Punteggio.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Rete di attività / Gradi / 2 / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 2 / Personale.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Rete di attività / Gradi / 3 / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Contratti.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Rete di attività / Gradi / 3 / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Rete di attività / Gradi / 3 / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Rete di attività / Gradi / 3 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Rete di attività / Gradi / 3 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Etichetta.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Rete di attività / Gradi / 3 / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Rotte.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Rete di attività / Gradi / 3 / Punteggio",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Punteggio.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Rete di attività / Gradi / 3 / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 3 / Personale.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Rete di attività / Gradi / 4 / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Contratti.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Rete di attività / Gradi / 4 / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Rete di attività / Gradi / 4 / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Rete di attività / Gradi / 4 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Rete di attività / Gradi / 4 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Etichetta.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Rete di attività / Gradi / 4 / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Rotte.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Rete di attività / Gradi / 4 / Punteggio",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Punteggio.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Rete di attività / Gradi / 4 / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 4 / Personale.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Rete di attività / Gradi / 5 / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Contratti.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Rete di attività / Gradi / 5 / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Rete di attività / Gradi / 5 / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Rete di attività / Gradi / 5 / ID",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Rete di attività / Gradi / 5 / Etichetta",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Etichetta.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Rete di attività / Gradi / 5 / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Rotte.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Rete di attività / Gradi / 5 / Punteggio",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Punteggio.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Rete di attività / Gradi / 5 / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Gradi / 5 / Personale.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Rete di attività / Periodo del rapporto / giorni",
                    description = "Parametro di funzionamento per Rete di attività / Periodo del rapporto / giorni.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Acquirente",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Acquirente.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Contratto",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Contratto.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Rivenditore",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Rivenditore.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / gang",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Centro di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Centro di distribuzione.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Laboratorio",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Laboratorio.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Organizzazione",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Organizzazione.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Rete di attività / Percorso / Punto finale / Tipi / Spacciatore",
                    description = "Parametro di funzionamento per Rete di attività / Percorso / Punto finale / Tipi / Spacciatore.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Frequenza / Minuti / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Frequenza / Minuti / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Frequenza / Minuti / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Frequenza / Minuti / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Tempo di ricarica / Minimo / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Tempo di ricarica / Minimo / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Fallimento / Affidabilità / Perdita",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Fallimento / Affidabilità / Perdita.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Minimo / Frequenza / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Minimo / Frequenza / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Minimo / Incontro / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Minimo / Incontro / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Rete di attività / Funzionamento in gioco / Penale contrattuale / Crescita",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Penale contrattuale / Crescita.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Penale contrattuale / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Penale contrattuale / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Qualità / Fallimento / Minuti tempo di attesa",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Qualità / Fallimento / Minuti tempo di attesa.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Qualità / Prezzo / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Qualità / Prezzo / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Qualità / Prezzo / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Qualità / Prezzo / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Qualità / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Affidabilità / Perdita / Qualità / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Reputazione / Qualità / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Reputazione / Qualità / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Rischio / Pesi / Categoria",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Rischio / Pesi / Categoria.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Rete di attività / Funzionamento in gioco / Contratto / Rischio / Pesi / Incontro",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Contratto / Rischio / Pesi / Incontro.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Centro di distribuzione / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Centro di distribuzione / capacità.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Centro di distribuzione / Sicurezza",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Centro di distribuzione / Sicurezza.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Incontro / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Incontro / Rischio.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Qualità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Qualità.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Capacità rotta",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Capacità rotta.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Percorso / Intervallo / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Percorso / Intervallo / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Rete di attività / Funzionamento in gioco / Valore predefinito / Percorso / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore predefinito / Percorso / Rischio.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Pressione della polizia / Decadimento",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Pressione della polizia / Decadimento.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Carico / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Carico / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Assalto / Recupero / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Assalto / Recupero / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Costo / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Costo / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Costo / Per livello",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Costo / Per livello.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Miglioramento",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Sicurezza / Miglioramento.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mancato pagamento / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mancato pagamento / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mancato pagamento / Sicurezza / Perdita",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mancato pagamento / Sicurezza / Perdita.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mantenimento / Intervallo / Ore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Centro di distribuzione / Mantenimento / Intervallo / Ore.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Rete di attività / Funzionamento in gioco / Valore iniziale / Affidabilità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Valore iniziale / Affidabilità.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Rete di attività / Funzionamento in gioco / Massimo / Nome dell'azienda / Lunghezza",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Massimo / Nome dell'azienda / Lunghezza.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Minimo / Contratto / Consegna / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Minimo / Contratto / Consegna / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Rete di attività / Funzionamento in gioco / Minimo / Distanza di consegna",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Minimo / Distanza di consegna.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Rete di attività / Funzionamento in gioco / Minimo / Registro contabile / Righe",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Minimo / Registro contabile / Righe.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Rete di attività / Funzionamento in gioco / Minimo / Percorso / Intervallo / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Minimo / Percorso / Intervallo / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Anticipo / Costo / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Anticipo / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Anticipo / Prezzo / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Anticipo / Prezzo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Costo / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Margine di trattativa / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Margine di trattativa / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Quantità / Rischio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Controfferta / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Controfferta / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Scadenza / Margine di trattativa / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Scadenza / Margine di trattativa / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Massimo / Accettazione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Massimo / Accettazione.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Minimo / Accettazione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Minimo / Accettazione.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Beneficio / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Beneficio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Costo / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Margine di trattativa / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Margine di trattativa / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Ricompensa / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Qualità / Ricompensa / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Affidabilità / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Affidabilità / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Reputazione / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Reputazione / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa richiesta / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa richiesta / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa richiesta / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa richiesta / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Costo / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Costo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Ricompensa / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Beneficio / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Beneficio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Rischio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Trattativa / Urgenza / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Altro / Fallimento / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Altro / Fallimento / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Attenzione personale / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Attenzione personale / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Polizia / Fallimento / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Polizia / Fallimento / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Valore base / unità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Valore base / unità.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / All'ingrosso / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / All'ingrosso / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Vendite economiche / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Vendite economiche / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Esperienza / Per livello",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Esperienza / Per livello.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Esperienza / Per unità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Esperienza / Per unità.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Centro di distribuzione / Pressione della polizia / Per unità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Centro di distribuzione / Pressione della polizia / Per unità.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Premium / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Premium / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Abilità / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Abilità / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Rete di attività / Funzionamento in gioco / Spacciatore / Abilità / guadagno",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Spacciatore / Abilità / guadagno.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Durata / Valore base / secondi",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Durata / Valore base / secondi.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Durata / Per unità / secondi",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Durata / Per unità / secondi.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 1",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 2",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 3",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 4",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Cause / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Valore / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Fallimento / Valore / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Pressione della polizia / Quantità / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Pressione della polizia / Quantità / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Riduzione Calore / Costo / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Riduzione Calore / Costo / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Riduzione Calore / Costo / Per punto di sospetto",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Riduzione Calore / Costo / Per punto di sospetto.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Lealtà",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Lealtà.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Corriere / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Corriere / Rischio.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Abilità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Rischio / Pesi / Abilità.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Rete di attività / Funzionamento in gioco / Rotazione rotte / Riduzione Calore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Rotazione rotte / Riduzione Calore.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Rete di attività / Funzionamento in gioco / Rotazione rotte / Rischio / Riduzione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Rotazione rotte / Rischio / Riduzione.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Vendita / Qualità Base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Vendita / Qualità Base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Vendita / Qualità / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Vendita / Qualità / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Vendita / Rischio / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Vendita / Rischio / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Percorso / Inizio / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Percorso / Inizio / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Rete di attività / Funzionamento in gioco / Corriere / Esperienza / Per livello",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Corriere / Esperienza / Per livello.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Rete di attività / Funzionamento in gioco / Corriere / Esperienza / Per unità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Corriere / Esperienza / Per unità.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Rete di attività / Funzionamento in gioco / Corriere / Fallimento / Lealtà / Perdita",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Corriere / Fallimento / Lealtà / Perdita.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Rete di attività / Funzionamento in gioco / Corriere / Rischio di Fallimento / guadagno",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Corriere / Rischio di Fallimento / guadagno.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Rete di attività / Funzionamento in gioco / Corriere / Abilità / guadagno",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Corriere / Abilità / guadagno.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Pressione della polizia",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Pressione della polizia.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Affidabilità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Affidabilità.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Reputazione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Reputazione.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Struttura",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Punteggio / Pesi / Struttura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / capacità / Valore base / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / capacità / Valore base / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Lealtà / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Lealtà / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Lealtà / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Lealtà / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Rischio / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Rischio / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Rischio / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Rischio / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Abilità / Massimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Abilità / Massimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Assunzione / Abilità / Minimo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Assunzione / Abilità / Minimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Lealtà / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Lealtà / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Massimo / Possibilità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Massimo / Possibilità.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 1",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 2",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 3",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 4",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Risultati / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Incidente / Rischio / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Incidente / Rischio / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Lealtà / Decadimento",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Lealtà / Decadimento.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Massimo / Livello",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Massimo / Livello.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Perdita di lealtà per reclutamento rivale",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Perdita di lealtà per reclutamento rivale.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Protezione / Costo / Valore base",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Protezione / Costo / Valore base.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Protezione / Ore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Protezione / Ore.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Protezione / Incidente / Riduzione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Protezione / Incidente / Riduzione.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Protezione / Rischio / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Protezione / Rischio / Costo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Recupero / Valore base / Possibilità",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Recupero / Valore base / Possibilità.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Recupero / Lealtà / Peso",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Recupero / Lealtà / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Salario / Valore base / Moltiplicatore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Salario / Valore base / Moltiplicatore.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Salario / Lealtà / guadagno",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Salario / Lealtà / guadagno.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Salario / Abilità / Divisore",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Salario / Abilità / Divisore.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 1",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 2",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 3",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 4",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 5",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Rete di attività / Funzionamento in gioco / Personale / Debolezze / 6",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Personale / Debolezze / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Rete di attività / Funzionamento in gioco / Struttura / Pesi / Contratti",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Struttura / Pesi / Contratti.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Rete di attività / Funzionamento in gioco / Struttura / Pesi / Rivenditori",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Struttura / Pesi / Rivenditori.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Rete di attività / Funzionamento in gioco / Struttura / Pesi / Centri di distribuzione",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Struttura / Pesi / Centri di distribuzione.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Rete di attività / Funzionamento in gioco / Struttura / Pesi / Rotte",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Struttura / Pesi / Rotte.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Rete di attività / Funzionamento in gioco / Struttura / Pesi / Personale",
                    description = "Parametro di funzionamento per Rete di attività / Funzionamento in gioco / Struttura / Pesi / Personale.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Rete di attività / Organizzazione / Permesso",
                    description = "Parametro di funzionamento per Rete di attività / Organizzazione / Permesso.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Rete di attività / Personale / Spacciatore / Valore base / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Spacciatore / Valore base / capacità.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Rete di attività / Personale / Spacciatore / Valore base / Salario",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Spacciatore / Valore base / Salario.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Rete di attività / Personale / Spacciatore / Commissione",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Spacciatore / Commissione.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Rete di attività / Personale / Spacciatore / Assunzione / Prezzo",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Spacciatore / Assunzione / Prezzo.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Rete di attività / Personale / Corriere / Valore base / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Corriere / Valore base / capacità.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Rete di attività / Personale / Corriere / Valore base / Salario",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Corriere / Valore base / Salario.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Rete di attività / Personale / Corriere / Commissione",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Corriere / Commissione.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Rete di attività / Personale / Corriere / Assunzione / Prezzo",
                    description = "Parametro di funzionamento per Rete di attività / Personale / Corriere / Assunzione / Prezzo.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Rete di attività / Ciclo di aggiornamento / Minuti",
                    description = "Parametro di funzionamento per Rete di attività / Ciclo di aggiornamento / Minuti.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Rete di attività / Trasporti / Aereo / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Aereo / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Rete di attività / Trasporti / Aereo / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Aereo / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Rete di attività / Trasporti / Aereo / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Aereo / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Rete di attività / Trasporti / Aereo / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Aereo / Rischio.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Rete di attività / Trasporti / Imbarcazione / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Imbarcazione / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Rete di attività / Trasporti / Imbarcazione / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Imbarcazione / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Rete di attività / Trasporti / Imbarcazione / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Imbarcazione / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Rete di attività / Trasporti / Imbarcazione / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Imbarcazione / Rischio.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Rete di attività / Trasporti / Auto / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Auto / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Rete di attività / Trasporti / Auto / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Auto / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Rete di attività / Trasporti / Auto / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Auto / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Rete di attività / Trasporti / Auto / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Auto / Rischio.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Rete di attività / Trasporti / A piedi / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / A piedi / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Rete di attività / Trasporti / A piedi / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / A piedi / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Rete di attività / Trasporti / A piedi / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / A piedi / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Rete di attività / Trasporti / A piedi / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / A piedi / Rischio.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Rete di attività / Trasporti / Camion / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Camion / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Rete di attività / Trasporti / Camion / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Camion / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Rete di attività / Trasporti / Camion / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Camion / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Rete di attività / Trasporti / Camion / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Camion / Rischio.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Rete di attività / Trasporti / Furgone / capacità",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Furgone / capacità.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Rete di attività / Trasporti / Furgone / Costo",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Furgone / Costo.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Rete di attività / Trasporti / Furgone / Moltiplicatore durata",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Furgone / Moltiplicatore durata.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Rete di attività / Trasporti / Furgone / Rischio",
                    description = "Parametro di funzionamento per Rete di attività / Trasporti / Furgone / Rischio.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Integrazione generica",
                        custom = "Integrazione personalizzata",
                        none = "Disattivato",
                    },
                },
                reputationRules = {
                    label = "Regole della reputazione",
                    description = "Configura regole con nome per le azioni e i bersagli facoltativi. Solo le regole attivate assegnano punti.",
                },
            },
            territoryMap = {
                addPoint = "Aggiungi",
                clear = "Cancella",
                create = "Crea",
                custom = "Territori personalizzati",
                deletePoint = "Sopprimere",
                eyebrow = "Editor del territorio",
                minimum = "Minimo 3",
                pointCount = "Punti {count}",
                presets = "Distretti predefiniti",
                shown = "Mostrato sulla mappa",
                street = "Via",
                supply = "Fornitura",
                territories = "Territori",
                type = "Tipo di territorio",
                undo = "Annulla",
            },
            shopPositionTools = {
                currentPosition = "Usa posizione attuale",
                selectEntity = "Seleziona entità",
                selectEntityHint = "Punta il laser su una cassa o cassaforte. Invio: usa posizione e direzione dell'oggetto evidenziato. Backspace: annulla.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Livelli di coltivazione",
                general = "Generale",
                runtime = "Accesso alle azioni di gioco",
                quality = "Qualità",
                packaging = "Confezionamento",
                growing = "Coltivazione",
                labs = "Laboratori e camper",
                power = "Energia e attrezzature",
                workers = "Lavoratori",
                market = "Mercato e distribuzione",
                threats = "Retate e sabotaggio",
                pvpTakeovers = "Conquiste dei laboratori",
                consumption = "Consumo",
                processing = "Lavorazione",
                performance = "Prestazioni",
                dynamicMarket = "Mercato Dinamico",
                heat = "Sospetto e rischio",
                contacts = "Rete di contatti",
                business = "Rete di attività",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Generale" },
                cultivationCurve = { label = "Curva dei livelli" },
                cultivationExperience = { label = "Ricompense XP" },
                cultivationUnlocks = { label = "Sblocchi di livello" },
                creator = {
                    label = "Apri editor",
                },
                creatorSettings = {
                    label = "Impostazioni dell'editor",
                },
                interfaceHud = {
                    label = "Posizioni interfaccia",
                },
                drugsGeneral = {
                    label = "Generale",
                },
                runtimeAccess = {
                    label = "Accesso e proprietà",
                },
                runtimePayouts = {
                    label = "Pagamenti",
                },
                runtimeDispatch = {
                    label = "Centrale e polizia",
                },
                qualityWeights = {
                    label = "Qualità / Pesi",
                },
                qualityTiers = {
                    label = "Qualità / Livelli di qualità",
                },
                packagingGeneral = {
                    label = "Generale",
                },
                growingGeneral = {
                    label = "Generale",
                },
                plantDefaults = {
                    label = "Pianta / Valori predefiniti",
                },
                harvestWindow = {
                    label = "Raccolta / Finestra temporale",
                },
                labsGeneral = {
                    label = "Generale",
                },
                labRent = {
                    label = "Affitto e ciclo di vita",
                },
                camperDefaults = {
                    label = "Camper",
                },
                labUpgrades = {
                    label = "Miglioramenti",
                },
                labDefaults = {
                    label = "Laboratorio / Valori predefiniti",
                },
                powerGeneral = {
                    label = "Generale",
                },
                generators = {
                    label = "Generatori",
                },
                equipmentWear = {
                    label = "Attrezzatura",
                },
                workersGeneral = {
                    label = "Generale",
                },
                marketGeneral = {
                    label = "Generale",
                },
                marketPrices = {
                    label = "Prezzi",
                },
                distribution = {
                    label = "Distribuzione",
                },
                threatsGeneral = {
                    label = "Generale",
                },
                threatHeat = {
                    label = "Pressione della polizia",
                },
                threatChances = {
                    label = "Probabilità",
                },
                pvpTakeoverRules = {
                    label = "Regole di conquista",
                },
                pvpTakeoverZones = {
                    label = "Zone & Tempi",
                },
                pvpTakeoverMethods = {
                    label = "Metodi di irruzione",
                },
                consumptionGeneral = {
                    label = "Generale",
                },
                consumerDecay = {
                    label = "Riduzione di tolleranza e dipendenza",
                },
                consumerEffects = {
                    label = "Effetti e rischi",
                },
                processingFlow = {
                    label = "Flusso di lavorazione",
                },
                processingGeneral = {
                    label = "Generale",
                },
                powerRuntime = {
                    label = "Funzionamento in gioco",
                },
                powerHeat = {
                    label = "Sospetto e traccia elettrica",
                },
                powerModes = {
                    label = "Trattamento / Modalità",
                },
                powerPriorities = {
                    label = "Carico / Priorità",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inattivo / Controllo / Intervallo / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interazione / Inattivo / Intervallo di scansione / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interazione / Avviso di interazione / Intervallo / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interazione / Intervallo di scansione / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimo / Intervallo di scansione / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Strada / Ped / Attivazione / Distanza",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Strada / Ped / Inattivo / Intervallo di scansione / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Strada / Ped / Intervallo di scansione / ms",
                },
                performanceWorldCachePadding = {
                    label = "Mondo / Cache / Margine aggiuntivo",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Mondo / Cache / Aggiornamento / Intervallo / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Mondo / Inattivo / Intervallo / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Bonus di crescita di qualità / secondi",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Azione / Limite cronologia",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Quantità / Saturazione / Peso",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Valore base / Precisione dell'intelligence",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Valore predefinito / Media / Qualità",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Valore predefinito / Risorsa / Elasticità",
                },
                dynamicMarketDemandCenter = {
                    label = "Domanda / Valore centrale",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Domanda / Prezzo / Impatto",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Direzione / Soglia",
                },
                dynamicMarketEnabled = {
                    label = "Abilitato",
                },
                dynamicMarketEventChance = {
                    label = "Evento / Possibilità",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Evento / Durata / Minuti",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Evento / Minimo / Durata / Minuti",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Evento / Intensità / Massimo",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Evento / Intensità / Minimo",
                },
                dynamicMarketEvents = {
                    label = "Eventi",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Informazioni esatte / Reputazione",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Informazioni esatte / Fiducia",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Globale / Zona / Etichetta",
                },
                dynamicMarketHistoryLimit = {
                    label = "Limite cronologia",
                },
                dynamicMarketInitialDemand = {
                    label = "Valore iniziale / Domanda",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Valore iniziale / Moltiplicatore Prezzo",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informazioni / Domanda / Errore",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informazioni / Massimo / Precisione",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informazioni / Minimo / Precisione",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informazioni / Polizia / Errore",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informazioni / Prezzo / Errore",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informazioni / Prezzo / Massimo",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informazioni / Prezzo / Minimo",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informazioni / Reputazione / Peso",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informazioni / Risorsa / Prezzo / Errore",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informazioni / Saturazione / Errore",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Finestra del seme delle informazioni / secondi",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informazioni / Stato / Precisione / Soglia",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informazioni / Stato / Errore / Soglia",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informazioni / Fornitura / Errore",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informazioni / Fiducia / Peso",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipolazione / Minuti tempo di attesa",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipolazione / Domanda / Variazione",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipolazione / Durata / Minuti",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipolazione / Pressione della polizia",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipolazione / Minimo / Lotto / Quantità",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipolazione / Conto di pagamento",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipolazione / Prezzo",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipolazione / Zona / Pressione della polizia / Moltiplicatore",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Massimo / Età dell'intelligence / Minuti",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Massimo / Moltiplicatore Prezzo",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimo / Età dell'intelligence / Minuti",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimo / Metrica / Finestra temporale / Minuti",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Prezzo minimo / Moltiplicatore",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimo / Aggiornamento / Minuti",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Polizia / Domanda / Peso",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Polizia / Prezzo / Impatto",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Scarsa qualità / Domanda / Penalità",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Scarsa qualità / Soglia",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Qualità premium / Bonus domanda",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Qualità premium / Soglia",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produzione / Fornitura / Peso",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produzione / Finestra temporale / Minuti",
                },
                dynamicMarketQualityCenter = {
                    label = "Qualità / Valore centrale",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Qualità / Affidabilità / Impatto",
                },
                dynamicMarketQualityRange = {
                    label = "Qualità / Intervallo di valori",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Rarità / Bonus / Massimo",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regionale / Globale / Peso",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regionale / Locale / Peso",
                },
                dynamicMarketResourceAliases = {
                    label = "Risorsa / Alias",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Risorsa / Direzione / Calo / Soglia",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Risorsa / Direzione / Aumento / Soglia",
                },
                dynamicMarketResources = {
                    label = "Risorse",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Vendite / Finestra temporale / Minuti",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Saturazione / Domanda / Peso",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Saturazione / Prezzo / Impatto",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Scarsità / Domanda / Peso",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Scarsità / Prezzo / Impatto",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Stagione / Fine / Mesi",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Stagione / Moltiplicatori",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Carenza / Voce / Soglia",
                },
                dynamicMarketStatusThresholds = {
                    label = "Stato / Soglie",
                },
                dynamicMarketTargetSupply = {
                    label = "Obiettivo / Fornitura",
                },
                dynamicMarketTrendChance = {
                    label = "Tendenza / Possibilità",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Tendenza / Durata / Minuti",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Tendenza / Massimo / Intensità",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Tendenza / Minimo / Intensità",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Aggiornamento / Minuti",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatilità / Massimo",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatilità / Minimo",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Meteo / Moltiplicatori",
                },
                dynamicMarketWeatherState = {
                    label = "Meteo / Stato",
                },
                heatActionCooldownSeconds = {
                    label = "Bonus di crescita di qualità / secondi",
                },
                heatActivityRiskWeights = {
                    label = "Attività / Rischio / Pesi",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Modalità aggressiva / Pressione della polizia / Moltiplicatore",
                },
                heatBurnerBurnThreshold = {
                    label = "Telefono usa e getta / Compromissione / Soglia",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Telefono usa e getta / Pressione della polizia / Per vendita all'ingrosso",
                },
                heatBurnerPhoneItem = {
                    label = "Telefono usa e getta / Oggetto",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Camper in funzione / Pressione della polizia / Moltiplicatore",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Camper in funzione / Pressione della polizia / Soglia",
                },
                heatCamperParkedHeat = {
                    label = "Camper parcheggiato / Pressione della polizia",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Contaminazione / Pressione della polizia / Moltiplicatore",
                },
                heatContaminatedThreshold = {
                    label = "Contaminazione / Soglia",
                },
                heatCultivationFreePlants = {
                    label = "Coltivazione / Piante senza rischio aggiuntivo",
                },
                heatCultivationHeatPerPlant = {
                    label = "Coltivazione / Pressione della polizia / Per pianta",
                },
                heatDealerHiddenMinutes = {
                    label = "Rivenditore / nascosto / Minuti",
                },
                heatDecayPerTick = {
                    label = "Decadimento / Per ciclo di aggiornamento",
                },
                heatEnabled = {
                    label = "Abilitato",
                },
                heatEnforcementHeat = {
                    label = "Presenza della polizia / Pressione della polizia",
                },
                heatEnforcementMultipliers = {
                    label = "Presenza della polizia / Moltiplicatori",
                },
                heatEntityTypes = {
                    label = "Entità / Tipi",
                },
                heatEventCooldownMinutes = {
                    label = "Evento / Minuti tempo di attesa",
                },
                heatEventHistoryLimit = {
                    label = "Evento / Limite cronologia",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratorio / Pressione della polizia / Sincronizzazione / Soglia",
                },
                heatLayLowCooldownMinutes = {
                    label = "Mantenere un basso profilo / Minuti tempo di attesa",
                },
                heatLayLowIdleMinutes = {
                    label = "Mantenere un basso profilo / Inattivo / Minuti",
                },
                heatLayLowReduction = {
                    label = "Mantenere un basso profilo / Riduzione",
                },
                heatLockdownMinutes = {
                    label = "Lockdown / Minuti",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimo / Durata / Minuti",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimo / Evento / Cooldown (secondi)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimo / Inattivo / secondi",
                },
                heatProcessingHeatMultiplier = {
                    label = "Lavorazione / Pressione della polizia / Moltiplicatore",
                },
                heatRiskWeights = {
                    label = "Rischio / Pesi",
                },
                heatRotateBurnerReduction = {
                    label = "Cambia telefono usa e getta / Riduzione",
                },
                heatRouteControlMinutes = {
                    label = "Percorso / Controllo / Minuti",
                },
                heatSaleHeat = {
                    label = "Vendita / Pressione della polizia",
                },
                heatThresholds = {
                    label = "Soglie",
                },
                heatTickMinutes = {
                    label = "Ciclo di aggiornamento / Minuti",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Commercio all'ingrosso / Pressione della polizia / Moltiplicatore",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Lavoratore / Fuga di informazioni / Raggio d'allerta",
                },
                heatWorkerLeakBaseChance = {
                    label = "Lavoratore / Fuga di informazioni / Valore base / Possibilità",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Lavoratore / Fuga di informazioni / Fazione / Moltiplicatore",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Lavoratore / Fuga di informazioni / Alto / Gravità / Soglia",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Lavoratore / Fuga di informazioni / Lealtà / Possibilità / Moltiplicatore",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Lavoratore / Fuga di informazioni / Lealtà / Soglia",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Lavoratore / Fuga di informazioni / Massimo / Possibilità",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Lavoratore / Fuga di informazioni / Minimo / Cooldown (secondi)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Lavoratore / Fuga di informazioni / Percorso / Moltiplicatore",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Lavoratore / Fuga di informazioni / Intensità / Massimo",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Lavoratore / Fuga di informazioni / Intensità / Minimo",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Lavoratore / Fuga di informazioni / Intensità / Moltiplicatore",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Lavoratore / Fuga di informazioni / Stress / Possibilità / Moltiplicatore",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Lavoratore / Fuga di informazioni / Stress / Soglia",
                },
                contactsActionCooldownSeconds = {
                    label = "Bonus di crescita di qualità / secondi",
                },
                contactsActiveHotspotCount = {
                    label = "Numero di zone attive",
                },
                contactsBurnerHintTrust = {
                    label = "Suggerimento burner / Fiducia",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Telefono usa e getta / Offerta / Massimo / Moltiplicatore",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Telefono usa e getta / Offerta / Minimo / Moltiplicatore",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Acquirente / Minuti tempo di attesa",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Acquirente / Distanza di consegna",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Acquirente / Premium / Successo / Punteggio",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Acquirente / Premium / Fiducia / guadagno",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Acquirente / Richiesta / Calore e Rischio / Peso",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Acquirente / Norma / Fiducia / guadagno",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Attesa per attivazione contatto / secondi",
                },
                contactsContactDemandRange = {
                    label = "Contatto / Domanda / Intervallo di valori",
                },
                contactsContactLossTrust = {
                    label = "Contatto / Perdita / Fiducia",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Informazioni esatte / Minuti",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Zona attiva / Informazioni / Prezzo",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Informazioni / Prezzo",
                },
                contactsDealerBasePrice = {
                    label = "Rivenditore / Prezzo Base",
                },
                contactsDealerHireCapacity = {
                    label = "Rivenditore / Assunzione / capacità",
                },
                contactsDealerHireRisk = {
                    label = "Rivenditore / Assunzione / Rischio",
                },
                contactsDealerHireSkill = {
                    label = "Rivenditore / Assunzione / Abilità",
                },
                contactsDealerOffers = {
                    label = "Offerte spacciatori",
                },
                contactsDealerProtectionHours = {
                    label = "Rivenditore / Protezione / Ore",
                },
                contactsDealerProtectionPrice = {
                    label = "Rivenditore / Protezione / Prezzo",
                },
                contactsDealerSaleMax = {
                    label = "Rivenditore / Vendita / Massimo",
                },
                contactsDealerSaleMin = {
                    label = "Rivenditore / Vendita / Minimo",
                },
                contactsDealerSimulation = {
                    label = "Rivenditore / Simulazione",
                },
                contactsDealerTickMinutes = {
                    label = "Rivenditore / Ciclo di aggiornamento / Minuti",
                },
                contactsDealerWage = {
                    label = "Rivenditore / Salario",
                },
                contactsDealerWageDecay = {
                    label = "Rivenditore / Salario / Decadimento",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Rivenditore / Salario / Lealtà / guadagno",
                },
                contactsDealerWeaknesses = {
                    label = "Rivenditore / Debolezze",
                },
                contactsDefaultContactDemand = {
                    label = "Valore predefinito / Contatto / Domanda",
                },
                contactsDefaultContactRisk = {
                    label = "Valore predefinito / Contatto / Rischio",
                },
                contactsDefaultDealerCapacity = {
                    label = "Spacciatore predefinito / capacità",
                },
                contactsDefaultDealerRisk = {
                    label = "Spacciatore predefinito / Rischio",
                },
                contactsDefaultDealerSkill = {
                    label = "Spacciatore predefinito / Abilità",
                },
                contactsDefaultHotspotRadius = {
                    label = "Valore predefinito / Zona attiva / Raggio",
                },
                contactsDemandResetMinutes = {
                    label = "Reset domanda (minuti)",
                },
                contactsEnabled = {
                    label = "Abilitato",
                },
                contactsExactLocationTrust = {
                    label = "Posizione esatta / Fiducia",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Fazione / Scoperta / Reputazione",
                },
                contactsFactionHintTrust = {
                    label = "Fazione / Indizio / Fiducia",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Consegna fallita / Minuti tempo di attesa",
                },
                contactsFakeDealEncounter = {
                    label = "Finto affare / Incontro",
                },
                contactsFallbackPreferredDrug = {
                    label = "Valore sostitutivo / Droga Preferita",
                },
                contactsFallbackProductLabel = {
                    label = "Valore sostitutivo / Etichetta prodotto",
                },
                contactsGuideBookItem = {
                    label = "Guida / Libro / Oggetto",
                },
                contactsGuideBookTrust = {
                    label = "Guida / Libro / Fiducia",
                },
                contactsHireDealerPrice = {
                    label = "Assumi dealer / Prezzo",
                },
                contactsHistoryLimit = {
                    label = "Limite cronologia",
                },
                contactsHotspotIntelMinutes = {
                    label = "Zona attiva / Informazioni / Minuti",
                },
                contactsHotspotRotationMinutes = {
                    label = "Zona attiva / Rotazione / Minuti",
                },
                contactsListingDurationMinutes = {
                    label = "Annuncio / Durata / Minuti",
                },
                contactsMaxOwnedDealers = {
                    label = "Massimo / Di proprietà / Rivenditori",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimo / Acquirente / Distanza di consegna",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimo / Rotazione contatti (minuti)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimo / Reset domanda (minuti)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimo / Pressione della polizia / Moltiplicatore",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimo / Zona attiva / Informazioni / Minuti",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimo / Zona attiva / Raggio",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimo / Zona attiva / Rotazione / Minuti",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimo / Annuncio / Durata / Minuti",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Ricompensa minima / Moltiplicatore",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimo / Rapine / Moltiplicatore",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimo / Posizione / Moltiplicatore Prezzo",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Altro / Droga / Moltiplicatore Prezzo",
                },
                contactsPaymentAccount = {
                    label = "Conto di pagamento",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Dopo la consegna / Domanda / Reset / secondi",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Droga Preferita / Moltiplicatore Prezzo",
                },
                contactsRegionLocationTrust = {
                    label = "Regione / Posizione / Fiducia",
                },
                contactsRequestAmounts = {
                    label = "Richiesta / Quantità",
                },
                contactsRotationMinutes = {
                    label = "Rotazione / Minuti",
                },
                contactsSpotPools = {
                    label = "Posizione / Gruppi di selezione",
                },
                contactsStreetHotspots = {
                    label = "Strada / Zone attive",
                },
                contactsTrustLevels = {
                    label = "Fiducia / Livelli",
                },
                businessActionCooldownSeconds = {
                    label = "Bonus di crescita di qualità / secondi",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Contratti",
                },
                businessDefaultBusinessName = {
                    label = "Valore predefinito / Nome dell'azienda",
                },
                businessDefaultRankId = {
                    label = "Valore predefinito / Classifica / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Valore predefinito / Personale / Stile di lavoro",
                },
                businessDefaultTransport = {
                    label = "Valore predefinito / Trasporti",
                },
                businessEnabled = {
                    label = "Abilitato",
                },
                businessHubs = {
                    label = "Centri di distribuzione",
                },
                businessLimits = {
                    label = "Limiti",
                },
                businessPayments = {
                    label = "Pagamenti",
                },
                businessPayoutAccount = {
                    label = "Pagamento / Conto",
                },
                businessRanks = {
                    label = "Gradi",
                },
                businessReportDays = {
                    label = "Periodo del rapporto / giorni",
                },
                businessRouteEndpointTypes = {
                    label = "Percorso / Punto finale / Tipi",
                },
                businessRuntime = {
                    label = "Funzionamento in gioco",
                },
                businessSocietyPermission = {
                    label = "Organizzazione / Permesso",
                },
                businessStaff = {
                    label = "Personale",
                },
                businessTickMinutes = {
                    label = "Ciclo di aggiornamento / Minuti",
                },
                businessTransports = {
                    label = "Trasporti",
                },
            },
            territorySettings = {
                section = "Territori",
                zonesGroup = "Zone territoriali",
                sourceLabel = "Fonte della zona",
                sourceDescription = "Usa i distretti predefiniti protetti o definisci i tuoi poligoni territoriali.",
                sourcePreset = "Distretti predefiniti",
                sourceCustom = "Territori personalizzati",
                editLabel = "Editor del territorio",
                editDescription = "Modifica i distretti utilizzati dalla fonte della zona selezionata.",
                editButton = "Modifica territori",
                presetSection = "Distretti predefiniti",
                presetEntry = "Distretto predefinito",
                customSection = "Territori personalizzati",
                customEntry = "Territorio personalizzato",
                typeLabel = "Tipo di territorio",
                streetType = "Strada",
                supplyType = "Fornitura",
                enabledLabel = "Mostrato sulla mappa",
                enabledDescription = "I distretti predefiniti disabilitati vengono rimossi dalla mappa e non possono essere rivendicati.",
                zoneLabel = "Confine del territorio",
                zoneDescription = "Aggiungi almeno tre punti in sequenza lungo il confine del territorio.",
                ownershipGroup = "Proprietà",
                decayGroup = "Decadimento",
                presenceGroup = "Presenza",
                activityGroup = "Punteggio attività",
                ownershipBenefitsGroup = "Vantaggi di proprietà",
                ownershipThresholdLabel = "Soglia di proprietà",
                ownershipThresholdDescription = "Percentuale di controllo che una gang deve superare per possedere ufficialmente un territorio.",
                activityFloorLabel = "Soglia minima di attività fissa",
                activityFloorDescription = "Punti influenza richiesti quando le soglie basate sulla dimensione sono disattivate.",
                floorByZoneSizeLabel = "Scalare la soglia in base alla dimensione della zona",
                floorByZoneSizeDescription = "Calcola la soglia di attività di ogni territorio in base alla sua area poligonale invece di usare la soglia fissa.",
                floorPointsPerSizeUnitLabel = "Punti soglia per km²",
                floorPointsPerSizeUnitDescription = "Punti soglia di attività richiesti per ogni chilometro quadrato di territorio.",
                fixedFloorRequirement = "Disattiva le soglie basate sulla dimensione per modificare la soglia di attività fissa.",
                sizeFloorRequirement = "Attiva le soglie basate sulla dimensione per modificare i punti per chilometro quadrato.",
                dailyDecayLabel = "Decadimento giornaliero dell'influenza",
                dailyDecayDescription = "Percentuale di influenza rimossa ogni 24 ore.",
                presenceIntervalLabel = "Intervallo di presenza",
                presenceIntervalDescription = "Minuti tra l'assegnazione automatica dei premi di presenza.",
                presencePointsLabel = "Punti presenza per membro",
                presencePointsDescription = "Punti presenza assegnati a ogni membro idoneo della gang per intervallo.",
                drugSalesEnabledLabel = "Le vendite agli NPC danno influenza territoriale",
                drugSalesEnabledDescription = "Le vendite in strada riuscite agli NPC assegnano influenza alla fazione del venditore nel territorio stradale attuale.",
                drugSalePointsLabel = "Punti per droga venduta",
                drugSalePointsDescription = "Punti influenza assegnati per ogni unità di droga segnalata come venduta.",
                drugSalesRequirement = "Attiva l'influenza delle vendite NPC per configurare i relativi punti.",
                graffitiPointsLabel = "Punti graffiti per 24 ore",
                graffitiPointsDescription = "Punti presenza assegnati quando un graffito esiste per un totale di 24 ore segnalate.",
                streetSellingPriceBonusLabel = "Bonus prezzo di vendita in strada",
                streetSellingPriceBonusDescription = "Percentuale aggiunta ai prezzi di vendita della droga per il proprietario ufficiale di un territorio di Strada.",
                supplyProductionSpeedBonusLabel = "Bonus velocità di produzione rifornimenti",
                supplyProductionSpeedBonusDescription = "Percentuale aggiunta alla velocità di produzione della droga per il proprietario ufficiale di un territorio di Rifornimenti.",
                pruneToleranceLabel = "Tolleranza per la potatura dell'influenza",
                pruneToleranceDescription = "L'influenza effettiva al di sotto di questo valore viene trattata come zero.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Generale",
                streamingGroup = "Rendering",
                moderationGroup = "Moderazione",
                graffitiEnabledLabel = "Abilita graffiti",
                graffitiEnabledDescription = "Permette ai giocatori di spruzzare e visualizzare graffiti.",
                graffitiRequireItemLabel = "Richiede bomboletta",
                graffitiRequireItemDescription = "I giocatori hanno bisogno di una bomboletta per spruzzare. Altrimenti si usa il comando /graffiti.",
                graffitiChargesPerCanLabel = "Cariche per bomboletta",
                graffitiChargesPerCanDescription = "Quanti graffiti può creare una singola bomboletta.",
                graffitiCooldownSecondsLabel = "Cooldown spruzzo",
                graffitiCooldownSecondsDescription = "Secondi che un giocatore deve attendere tra uno spruzzo e l'altro.",
                graffitiMaxPerPlayerLabel = "Max graffiti per giocatore",
                graffitiMaxPerPlayerDescription = "Numero massimo di graffiti attivi che un giocatore può possedere. 0 significa illimitato.",
                graffitiMaxDistanceLabel = "Max distanza spruzzo",
                graffitiMaxDistanceDescription = "A che distanza massima (in metri) può trovarsi una parete per poterla ancora spruzzare.",
                graffitiSprayDurationLabel = "Durata spruzzo",
                graffitiSprayDurationDescription = "Quanto dura l'animazione dello spruzzo, in millisecondi.",
                graffitiExpiryDaysLabel = "Tempo di scadenza",
                graffitiExpiryDaysDescription = "Giorni prima che un graffito scompaia automaticamente. 0 significa mai.",
                graffitiTerritoryHoursLabel = "Ore di territorio per spruzzo",
                graffitiTerritoryHoursDescription = "Ore di presenza nel territorio che un nuovo graffito garantisce alla sua gang.",
                graffitiStreamRadiusLabel = "Raggio di streaming",
                graffitiStreamRadiusDescription = "Distanza in metri alla quale i graffiti diventano visibili ai giocatori.",
                graffitiPoolSizeLabel = "Dimensione pool decal",
                graffitiPoolSizeDescription = "Quanti graffiti vengono renderizzati contemporaneamente. Valori più alti richiedono più prestazioni.",
                graffitiReportsEnabledLabel = "Abilita segnalazioni",
                graffitiReportsEnabledDescription = "Permette ai giocatori di segnalare graffiti offensivi.",
                graffitiAutoHideThresholdLabel = "Soglia auto-nascondi",
                graffitiAutoHideThresholdDescription = "Numero di segnalazioni che nasconde automaticamente un graffito. 0 disabilita questa funzione.",
            },
            darknetSettings = {
                section = "Mercato darknet",
                availabilityGroup = "Disponibilità",
                economyGroup = "Criptovaluta",
                listingsGroup = "Annunci e scadenza",
                chatGroup = "Chat privata",
                identityGroup = "Alias e reputazione",
                deliveryGroup = "Consegne e dead drop",
                policeGroup = "Accesso polizia",
                npcGroup = "Commercianti NPC",
                enabledLabel = "Abilita mercato darknet",
                enabledDescription = "Rende disponibile l'app del mercato nero e la sua logica.",
                tabletOrderLabel = "Ordine app tablet",
                tabletOrderDescription = "Controlla la posizione del mercato darknet nel tablet.",
                currencyCodeLabel = "Codice valuta",
                currencyCodeDescription = "Etichetta breve della criptovaluta interna.",
                starterBalanceLabel = "Saldo nuovo wallet",
                starterBalanceDescription = "Cripto assegnata solo quando un giocatore apre il mercato per la prima volta.",
                exchangeEnabledLabel = "Abilita cambio monete",
                exchangeEnabledDescription = "Consente agli utenti BlackBay autenticati di comprare e vendere monete nella pagina account.",
                exchangeAccountLabel = "Conto di pagamento del cambio",
                exchangeAccountDescription = "Conto framework usato per acquisti di monete e pagamenti delle vendite.",
                exchangeBuyPriceLabel = "Prezzo di acquisto per moneta",
                exchangeBuyPriceDescription = "Importo addebitato dal conto di pagamento per una moneta.",
                exchangeSellPriceLabel = "Prezzo di vendita per moneta",
                exchangeSellPriceDescription = "Importo versato sul conto di pagamento per una moneta.",
                exchangeMinimumLabel = "Monete minime per cambio",
                exchangeMinimumDescription = "Quantità intera minima accettata in un cambio.",
                exchangeMaximumLabel = "Monete massime per cambio",
                exchangeMaximumDescription = "Quantità intera massima accettata in un cambio.",
                accountMoney = "Contanti",
                accountBank = "Banca",
                accountBlackMoney = "Denaro sporco",
                scamChanceLabel = "Probabilità globale di truffa NPC (%)",
                scamChanceDescription = "Probabilità minima che un commerciante NPC prenda il pagamento o la merce senza consegnare la contropartita. Si applica comunque un valore specifico del commerciante più alto.",
                listingExpiryLabel = "Durata annuncio (ore)",
                listingExpiryDescription = "Gli annunci attivi scadono automaticamente dopo queste ore.",
                renewalHoursLabel = "Durata rinnovo (ore)",
                renewalHoursDescription = "Ore aggiunte quando un annuncio viene rinnovato.",
                maximumListingsLabel = "Annunci attivi massimi",
                maximumListingsDescription = "Numero massimo di annunci per alias attivo.",
                maximumQuantityLabel = "Quantità massima",
                maximumQuantityDescription = "Limite della quantità di merce in un annuncio.",
                maximumPriceLabel = "Prezzo unitario massimo",
                maximumPriceDescription = "Prezzo crypto massimo per unità.",
                maximumMessageLengthLabel = "Lunghezza massima messaggio",
                maximumMessageLengthDescription = "Numero massimo di caratteri per messaggio cifrato.",
                aliasCooldownLabel = "Attesa cambio alias (ore)",
                aliasCooldownDescription = "Età minima di un'identità prima che possa essere ritirata nuovamente.",
                verifiedSalesLabel = "Vendite per la verifica",
                verifiedSalesDescription = "Vendite riuscite richieste per diventare verificato.",
                verifiedRatingLabel = "Valutazione per la verifica",
                verifiedRatingDescription = "Valutazione media minima per un venditore verificato.",
                scammerReportsLabel = "Segnalazioni per avviso truffatore",
                scammerReportsDescription = "Segnalazioni uniche di scambi necessarie per il badge di truffatore noto.",
                meetingDistanceLabel = "Distanza consegna",
                meetingDistanceDescription = "Distanza massima fra giocatori o dal punto NPC.",
                dropModelLabel = "Modello cassa dead drop",
                dropModelDescription = "Modello prop GTA generato localmente per i dead drop disponibili.",
                dropStreamLabel = "Distanza streaming dead drop",
                dropStreamDescription = "Distanza di caricamento di casse e incontri NPC.",
                dropInteractionLabel = "Distanza interazione dead drop",
                dropInteractionDescription = "Distanza necessaria per aprire una cassa.",
                dropLifetimeLabel = "Durata dead drop (ore)",
                dropLifetimeDescription = "Tempo prima della scadenza di una cassa non ritirata.",
                dropPollLabel = "Intervallo aggiornamento mondo (ms)",
                dropPollDescription = "Intervallo per aggiornare casse e incontri NPC vicini.",
                policeGroupsLabel = "Gruppi polizia autorizzati",
                policeGroupsDescription = "Chiavi di gruppo del Configuratore di Lavoro che possono pubblicare offerte esca e visualizzare indagini.",
                policeGroupEntry = "Gruppo di polizia",
                groupKeyLabel = "Chiave gruppo",
                npcTradersLabel = "Compratori e venditori NPC",
                npcTradersDescription = "Configura offerte sintetiche persistenti, metodo di consegna, reputazione e probabilità di truffa.",
                npcTraderEntry = "Commerciante NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "Pseudonimi",
                npcSideLabel = "Lato mercato",
                sideSell = "Vende ai giocatori",
                sideBuy = "Compra dai giocatori",
                npcTitleLabel = "Titolo annuncio",
                npcDescriptionLabel = "Descrizione",
                npcItemNameLabel = "Nome articolo dell'inventario",
                npcItemLabelLabel = "Nome merce",
                npcQuantityLabel = "Quantità",
                npcPriceLabel = "Prezzo unitario",
                npcDeliveryLabel = "Metodo di consegna",
                deliveryBoth = "Incontro e dead drop",
                deliveryMeeting = "Solo di persona",
                deliveryDrop = "Solo dead drop",
                npcScamChanceLabel = "Probabilità di truffa del commerciante (%)",
                npcPedModelLabel = "Modello ped NPC",
                npcRatingLabel = "Valutazione mostrata",
                npcRatingCountLabel = "Numero valutazioni mostrato",
                npcTradesLabel = "Operazioni completate visualizzate",
                npcVerifiedLabel = "Commerciante verificato",
                npcScammerLabel = "Truffatore noto",
                npcEnabledLabel = "Attivo",
            },
            interrogationSettings = {
                section = "Interrogatorio",
                generalGroup = "Generale",
                consentGroup = "Protezione giocatori",
                objectGroup = "Oggetti",
                grabGroup = "Sottomissione",
                sessionGroup = "Sessione",
                dispatchGroup = "Allarmi polizia",
                loggingGroup = "Registrazione",
                securityGroup = "Sicurezza",
                presentationGroup = "Presentazione",
                enabledLabel = "Abilita interrogatorio",
                enabledDescription = "Permette ai giocatori di legare altri a sedie per interrogatori e di usare strumenti su di essi.",
                consentRequiredLabel = "Richiedi consenso",
                consentRequiredDescription = "Solo i giocatori che hanno dato il consenso possono diventare vittime. Non esiste un tasto per dare il consenso, quindi è necessaria l'impostazione sottostante.",
                consentDefaultLabel = "Consenso predefinito",
                consentDefaultDescription = "I nuovi personaggi iniziano con il consenso già concesso invece che negato.",
                globalIntensityLabel = "Intensità effetti",
                globalIntensityDescription = "Regola l'intensità di effetti a schermo, particelle e suoni. 0 li disattiva completamente.",
                maxPerPlayerLabel = "Oggetti per giocatore",
                maxPerPlayerDescription = "Quante sedie e carrelli può posizionare un singolo giocatore. 0 significa illimitato.",
                maxGlobalLabel = "Oggetti in tutto il server",
                maxGlobalDescription = "Numero totale di oggetti posizionati contemporaneamente consentiti. 0 significa illimitato.",
                placementDistanceLabel = "Distanza di posizionamento",
                placementDistanceDescription = "La distanza massima alla quale un oggetto può essere posizionato dal giocatore, in metri.",
                interactDistanceLabel = "Distanza interazione",
                interactDistanceDescription = "La distanza minima che un giocatore deve mantenere per usare una sedia o un carrello, in metri.",
                inactivityMinutesLabel = "Rimozione automatica dopo",
                inactivityMinutesDescription = "Minuti di inattività prima che un oggetto posizionato scompaia. 0 lo mantiene per sempre.",
                persistObjectsLabel = "Mantieni oggetti dopo il riavvio",
                persistObjectsDescription = "Gli oggetti posizionati vengono ripristinati dal database quando il server torna online.",
                grabEnabledLabel = "Abilita sottomissione",
                grabEnabledDescription = "Permette ai giocatori di sormontare e trascinare via un altro giocatore.",
                grabItemLabel = "Oggetto richiesto",
                grabItemDescription = "L'oggetto di cui l'aggressore ha bisogno per sormettere qualcuno. Lasciare vuoto per non richiedere nulla.",
                grabAngleLabel = "Angolo di approccio",
                grabAngleDescription = "La distanza laterale rispetto alla posizione direttamente dietro l'aggressore entro cui può trovarsi, in gradi.",
                grabHealthBelowLabel = "Soglia salute",
                grabHealthBelowDescription = "Una vittima con salute inferiore a questo valore può essere sottomessa senza essere legata. 0 disabilita questa funzione.",
                grabCooldownLabel = "Cooldown dopo il fallimento",
                grabCooldownDescription = "Secondi prima che un tentativo di sottomissione fallito possa essere ripetuto.",
                grabVehiclesLabel = "Veicoli consentiti",
                grabVehiclesDescription = "Modelli di veicoli in cui una vittima sottomessa può essere caricata.",
                carryEnabledLabel = "Permetti trasporto",
                carryEnabledDescription = "L'aggressore può trasportare la vittima sulla spalla.",
                restrictVisionLabel = "Limita la vista della vittima",
                restrictVisionDescription = "Oscura lo schermo della vittima durante il trasporto.",
                escapeEnabledLabel = "Permetti tentativi di fuga",
                escapeEnabledDescription = "Permetti a una vittima trasportata di provare a liberarsi.",
                escapeSecondsLabel = "Durata fuga",
                escapeSecondsDescription = "Secondi in cui la vittima deve tenere premuto il tasto per liberarsi.",
                maxDurationLabel = "Durata massima",
                maxDurationDescription = "Minuti dopo i quali una sessione termina automaticamente.",
                warnMinutesLabel = "Avviso prima della fine",
                warnMinutesDescription = "Minuti prima del limite entro i quali entrambi i soggetti vengono avvisati.",
                idleMinutesLabel = "Rilascio per inattività",
                idleMinutesDescription = "Minuti di inattività prima che la vittima venga rilasciata.",
                selfReleaseMinutesLabel = "Autoliberazione dopo",
                selfReleaseMinutesDescription = "Minuti di inattività dell'aggressore prima che la vittima possa liberarsi da sola.",
                graceSecondsLabel = "Tempo di grazia dopo la disconnessione",
                graceSecondsDescription = "Secondi in cui la vittima rimane legata se l'aggressore lascia il server.",
                rescueEnabledLabel = "Permetti salvataggi",
                rescueEnabledDescription = "Permetti a giocatori non coinvolti di liberare una vittima legata.",
                rescueSecondsLabel = "Durata salvataggio",
                rescueSecondsDescription = "Secondi necessari a un soccorritore per tagliare le legature della vittima.",
                rescueItemLabel = "Oggetto per il salvataggio",
                rescueItemDescription = "Oggetto richiesto per il salvataggio. Lasciare vuoto se non richiesto.",
                allowInventoryLabel = "La vittima mantiene l'inventario",
                allowInventoryDescription = "Una vittima legata può comunque aprire il proprio inventario.",
                dispatchEnabledLabel = "Abilita avvisi alla polizia",
                dispatchEnabledDescription = "Segnala rapimenti e interrogatori ai servizi di emergenza.",
                dispatchAdapterLabel = "Sistema di allerta",
                dispatchAdapterDescription = "Quale sistema di dispatch riceve le segnalazioni.",
                dispatchJobsLabel = "Lavori riceventi",
                dispatchJobsDescription = "Lavori che ricevono l'allerta.",
                dispatchGrabChanceLabel = "Probabilità di cattura",
                dispatchGrabChanceDescription = "Percentuale di probabilità che una cattura venga segnalata.",
                dispatchFixateChanceLabel = "Probabilità di legatura",
                dispatchFixateChanceDescription = "Percentuale di probabilità che il legare qualcuno a una sedia venga segnalato.",
                dispatchToolChanceLabel = "Probabilità uso strumenti",
                dispatchToolChanceDescription = "Percentuale di probabilità che l'uso di uno strumento venga segnalato.",
                dispatchWitnessLabel = "Richiedi un testimone",
                dispatchWitnessDescription = "Segnala solo se un altro giocatore è abbastanza vicino da accorgersene.",
                dispatchWitnessRadiusLabel = "Raggio testimone",
                dispatchWitnessRadiusDescription = "La distanza massima in metri entro cui deve trovarsi un testimone.",
                dispatchCooldownLabel = "Tempo di ricarica allerta",
                dispatchCooldownDescription = "Secondi tra due allerte provenienti dalla stessa sessione.",
                dispatchInaccuracyLabel = "Inaccuratezza posizione",
                dispatchInaccuracyDescription = "Metri di scostamento casuale della posizione segnalata. 0 segnala il punto esatto.",
                loggingEnabledLabel = "Abilita log",
                loggingEnabledDescription = "Registra posizionamenti, catture, uso di strumenti, rilasci e azioni admin.",
                logDatabaseLabel = "Scrivi nel database",
                logDatabaseDescription = "Scrive inoltre ogni voce nella tabella dei log degli interrogatori.",
                logRetentionLabel = "Mantieni log",
                logRetentionDescription = "Giorni prima che i log nel database vengano eliminati. 0 li conserva per sempre.",
                pingToleranceLabel = "Tolleranza distanza",
                pingToleranceDescription = "Metri aggiunti a ogni controllo della distanza lato server per compensare il lag.",
                violationThresholdLabel = "Soglia di violazione",
                violationThresholdDescription = "Violazioni di sicurezza nell'intervallo di tempo prima che scatti la reazione. 0 la disabilita.",
                violationActionLabel = "Reazione alle violazioni",
                violationActionDescription = "Cosa succede quando un giocatore supera la soglia di violazione.",
                violationActionNone = "Non fare nulla",
                violationActionLog = "Solo log",
                violationActionKick = "Espulsione",
                violationActionCheating = "Segnala come cheating",
                particlesLabel = "Effetti particellari",
                particlesDescription = "Mostra sangue, scintille e fiamme durante l'uso degli strumenti.",
                soundLabel = "Effetti sonori",
                soundDescription = "Riproduce i suoni degli strumenti per tutti i presenti nelle vicinanze.",
                cameraWorkLabel = "Movimento camera",
                cameraWorkDescription = "Muove la camera durante la legatura di qualcuno e durante l'uso degli strumenti.",
                screenEffectsLabel = "Effetti schermo",
                screenEffectsDescription = "Vibrazione, flash, sfocatura e filtri colore sullo schermo della vittima.",
                objectsSection = "Oggetti di interrogatorio",
                objectsEntry = "Oggetto",
                objectsEditLabel = "Oggetti di interrogatorio",
                objectsEditDescription = "Posiziona sedie permanenti e carrelli per strumenti sulla mappa.",
                objectsEditButton = "Modifica oggetti",
                objectsKindLabel = "Tipo di oggetto",
                objectsKindChair = "Sedia",
                objectsKindCart = "Carrello per strumenti",
                objectsModelLabel = "Modello prop",
                objectsPositionLabel = "Posizione",
                blockedZonesSection = "Zone bloccate",
                blockedZonesEntry = "Zona",
                blockedZonesEditLabel = "Zone bloccate",
                blockedZonesEditDescription = "Aree in cui non è possibile posizionare oggetti di interrogatorio.",
                blockedZonesEditButton = "Modifica zone",
                blockedZonesZoneLabel = "Contorno zona",
                blockedZonesZoneDescription = "Trascina gli angoli per definire l'area in cui il posizionamento è vietato.",
                toolsSection = "Attrezzi",
                toolsEntry = "Strumento",
                toolsEditLabel = "Attrezzi",
                toolsEditDescription = "Aggiungi o adatta gli strumenti che possono essere usati su una vittima.",
                toolsEditButton = "Modifica strumenti",
                toolsItemLabel = "Oggetto richiesto",
                toolsConsumeLabel = "Consumare oggetto",
                toolsDamageLabel = "Danno per utilizzo",
                toolsHealthFloorLabel = "Soglia salute",
                toolsCooldownLabel = "Cooldown in secondi",
                toolsProgressLabel = "Progresso per utilizzo",
                sessionsSection = "Sessioni in corso",
                sessionsEntry = "Sessione",
                sessionsEditLabel = "Sessioni in corso",
                sessionsEditDescription = "Vedi chi sta subendo un interrogatorio e interrompilo se necessario.",
                sessionsEditButton = "Mostra sessioni",
                sessionsStateLabel = "Stato",
                sessionsProgressLabel = "Progresso",
                orphansSection = "Oggetti orfani",
                orphansEntry = "Oggetto",
                orphansEditLabel = "Oggetti orfani",
                orphansEditDescription = "Rimuove gli oggetti il cui proprietario non viene visto da molto tempo.",
                orphansEditButton = "Pulisci",
                sessionStates = {
                    binding = "Immobilizzazione in corso",
                    active = "Attiva",
                    ending = "In chiusura",
                },
            },
        },
    },
}
